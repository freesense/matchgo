package main

import (
	"bytes"
	"encoding/binary"
	"fmt"
	"math"
	. "public"
	"strconv"
	"strings"
	"sync"
	"sync/atomic"

	"github.com/garyburd/redigo/redis"

	"github.com/json-iterator/go"
	zmq "github.com/pebbe/zmq4"
)

var json = jsoniter.ConfigCompatibleWithStandardLibrary
var sWorkerCount sync.WaitGroup
var stopflag int32
var max_price, max_qty uint64 // 允许下单的最大价格和最大数量，防止溢出
var PriceRangeCheck bool
var PriceRange float64

type Answer struct {
	Errno      int
	Errmsg     string
	Consign_id uint64
	Status     int
}

func Msgfromcore(msg string) {
	// user_id.consign_id 不管是正常交易还是撤单
	l := strings.Split(msg, ".")
	user_id, err := strconv.Atoi(l[0])
	if HasError(err) {
		return
	}
	consign_id, err := strconv.ParseInt(l[1], 0, 0)
	if HasError(err) {
		return
	}

	if consign_id > 0 {
		_ = dbw.Ord_queued(uint64(consign_id))
		rds := rdw.Get()
		defer rds.Close()
		rds.Do("publish", fmt.Sprintf("orderstatus.%d", user_id), fmt.Sprintf("%d.%d", consign_id, Queued))
	}
}

func Msgfromweb(hubClient *zmq.Socket, msg []byte) (ord *Order, req *OrderRequest, stop int, err error) {
	err = json.Unmarshal(msg, &req)
	if HasError(err) {
		return
	}

	if req.User_id == 0 { // special maintain request
		var comment string
		ord = &Order{}
		ord.Otype = req.Otype
		switch req.Otype {
		case 1:
			comment = "dump symbol"
			ord.Symbol_id = req.Symbol
		case 2:
			comment = "cancel all"
		case 3:
			comment = "quit"
		case 4:
			comment = "stop order receiver"
			atomic.StoreInt32(&stopflag, 1)
		case 5:
			comment = "start order receiver"
			atomic.StoreInt32(&stopflag, 0)
		case 6:
			comment = "get position"
			stop = 1
			type CoinAsset struct {
				Ccy, Usable, Frozen string
			}
			type AllPosition struct {
				Errno  int
				Errmsg string
				Assets []CoinAsset
			}
			position, err := dbw.GetPosition(uint32(req.Related_id))
			ans := &AllPosition{}
			if err != nil {
				ans.Errno = -1
				ans.Errmsg = err.Error()
			} else {
				for ccy, p := range position {
					ans.Assets = append(ans.Assets, CoinAsset{ccy, Uint64DivString(p[0]), Uint64DivString(p[1])})
				}
			}
			rsp, err := json.Marshal(ans)
			if !HasError(err) {
				_, err = hubClient.SendBytes(rsp, 0)
				HasError(err)
			}
		default:
			err = BuildError(true, "unknown maintain type: %d", req.Otype)
			return
		}
		if stop == 0 {
			err = BuildError(true, comment)
		}
	} else if atomic.LoadInt32(&stopflag) == 1 {
		err = BuildError(false, "maintaining")
	} else if req.Otype == OtypeFundChg { // 资金流水
		// related_id: business_id
		// Price: balance
		// Qty: frozen
		// Symbol: ccy
		// Reference: summary
		if req.Symbol == 0 || req.Reference == 0 {
			err = BuildError(true, "invalid request")
			return
		}
		if err = dbw.OnCcyflow(req); err != nil {
			return
		}
	} else {
		if (req.Otype & 0x02) != 0 { // 撤单委托
			ord, err = Docancel(req)
		} else { // 正常委托
			ord, err = Donormal(req)
		}
	}

	return
}

func Docancel(req *OrderRequest) (ord *Order, err error) {
	flag := true
	var consign_id, price uint64
	var symbol, reference uint32
	for {
		consign_id, symbol, reference, price, err = dbw.Add_cancel(req.User_id, req.Related_id)
		if err == nil {
			if flag == false {
				Println("Add_cancel OK.")
			}
			break
		} else if strings.Contains(err.Error(), "cancel repeat") {
			return
		} else {
			flag = false
		}
	}

	var sid uint32
	var ok bool
	if req.Related_id != 0 {
		sid, ok = dbw.Get_symbolid_from_id(fmt.Sprintf("%d/%d", symbol, reference))
		if !ok {
			err = BuildError(true, "invalid symbol: %d/%d, consign_id: %v", symbol, reference, req.Related_id)
			return
		}
	}

	ord = &Order{consign_id, req.Related_id, price, 0, 0x02, sid, req.User_id}
	return
}

func Donormal(req *OrderRequest) (ord *Order, err error) {
	if req.Otype&0x08 != 0 {
		req.Price = "0"
	}

	if req.Symbol == 0 || req.Reference == 0 {
		err = BuildError(true, "invalid request")
		return
	}

	var symbolid uint32
	var ok bool
	if symbolid, ok = dbw.Get_symbolid_from_id(fmt.Sprintf("%d/%d", req.Symbol, req.Reference)); !ok {
		err = BuildError(true, "invalid trading-pair: %d/%d", req.Symbol, req.Reference)
		return
	}

	var consign_id, iPrice, iQty uint64

	if req.User_id == 0 {
		consign_id = 0
	} else {
		flag := true
		iPrice, err = StringMulUint64(req.Price)
		if HasError(err) {
			return
		}
		iQty, err = StringMulUint64(req.Qty)
		if HasError(err) {
			return
		}
		if iPrice > max_price || iQty > max_qty || iQty == 0 {
			err = BuildError(false, "invalid price or qty")
			return
		}

		if PriceRangeCheck {
			rds := rdw.Get()
			defer rds.Close()
			var latest string
			latest, err = redis.String(rds.Do("get", fmt.Sprintf("latest.%d", symbolid)))
			if err == redis.ErrNil {
			} else if HasError(err) {
				return
			} else if len(latest) > 0 {
				var _latest uint64
				_latest, err = strconv.ParseUint(latest, 10, 64)
				if HasError(err) {
					return
				}
				if _latest != 0 {
					if req.Otype&0x01 > 0 {
						minbound := uint64(math.Floor(float64(_latest)*(1-PriceRange) + 0.5))
						if iPrice < minbound {
							err = BuildError(true, "price exceed valid range")
							return
						}
					} else {
						maxbound := uint64(math.Floor(float64(_latest)*(1+PriceRange) + 0.5))
						if iPrice > maxbound {
							err = BuildError(true, "price exceed valid range")
							return
						}
					}
				}
			}
		}

		for {
			consign_id, err = dbw.Add_order(req, iPrice, iQty)
			if err == nil {
				if flag == false {
					Println("Add_order OK.")
				}
				break
			} else {
				flag = false
			}
		}
	}

	ord = &Order{consign_id, 0, iPrice, iQty, req.Otype, symbolid, req.User_id}
	return
}

func Docheck(req *OrderRequest, consign_id uint64) bool {
	if req.User_id == 0 || consign_id == 0 { // maintain request
		return true
	}

	ret := dbw.CheckConsign(req, consign_id)
	rds := rdw.Get()
	defer rds.Close()

	if ret {
		rds.Do("publish", fmt.Sprintf("orderstatus.%d", req.User_id), fmt.Sprintf("%d.%d", consign_id, Accepted))
	} else {
		rds.Do("publish", fmt.Sprintf("orderstatus.%d", req.User_id), fmt.Sprintf("%d.%d", consign_id, Rejected))
	}
	return ret
}

func worker() {
	defer sWorkerCount.Done()

	hubAddr, err := cfg.String("pre", "hub")
	if HasError(err) {
		return
	}
	hubClient, err := context.NewSocket(zmq.REP)
	if HasError(err) {
		return
	}
	defer hubClient.Close()
	err = hubClient.Connect(hubAddr)
	if HasError(err) {
		return
	}

	coreAddr, err := cfg.String("core", "addr")
	if HasError(err) {
		return
	}
	coreSock, err := context.NewSocket(zmq.DEALER)
	if HasError(err) {
		return
	}
	defer coreSock.Close()
	err = coreSock.Connect(coreAddr)
	if HasError(err) {
		return
	}

	poller := zmq.NewPoller()
	poller.Add(coreSock, zmq.POLLIN)
	/*idx := */ poller.Add(hubClient, zmq.POLLIN)

	var sacnt int32
	quitflag := false

	for {
		sockets, err := poller.Poll(-1)
		HasError(err)

		for _, socket := range sockets {
			switch s := socket.Socket; s {
			case hubClient:
				ans := &Answer{}
				msg, err := hubClient.RecvBytes(0)

				if !HasError(err) {
					ord, req, stop, err := Msgfromweb(hubClient, msg)
					if stop == 1 {
						break
					}
					if err != nil {
						ans.Errno = -1
						ans.Errmsg = err.Error()
					} else if ord != nil {
						ans.Consign_id = ord.Oid
						ans.Status = Submitted
					}

					rsp, err := json.Marshal(ans)
					if !HasError(err) {
						_, err = hubClient.SendBytes(rsp, 0)
						HasError(err)
					}

					if ord != nil {
						// 订单购买力检查
						ok := Docheck(req, ord.Oid)
						if !ok {
							rds := rdw.Get()
							defer rds.Close()
							rds.Do("publish", fmt.Sprintf("orderstatus.%d", ord.User_id), fmt.Sprintf("%d.%d", ord.Oid, Rejected))
						} else { // send to core
							buf := &bytes.Buffer{}
							binary.Write(buf, binary.LittleEndian, ord)
							_, err := coreSock.SendMessage("", buf)
							if !HasError(err) {
								atomic.AddInt32(&sacnt, 1)
							}
						}
					}
				}

			case coreSock:
				msg, err := coreSock.RecvMessage(0)
				if !HasError(err) {
					Msgfromcore(msg[len(msg)-1])
					atomic.AddInt32(&sacnt, -1)
				}
			}
		}

		if quitflag && atomic.LoadInt32(&sacnt) == 0 {
			return
		}
	}
}

func loop_pre() {
	defer func() {
		Println(">>> Pre finished.")
		wg.Done()
	}()

	tmp, err := cfg.String("pre", "floating_price")
	if err == nil {
		PriceRange, err = strconv.ParseFloat(tmp, 64)
		if !HasError(err) {
			PriceRangeCheck = true
		}
	}

	worker_count, err := cfg.Int("pre", "worker")
	if HasError(err) {
		return
	}
	_max_price, err := cfg.Int("pre", "max_price")
	if HasError(err) {
		return
	}
	max_price = uint64(_max_price) * Imul
	_max_qty, err := cfg.Int("pre", "max_qty")
	if HasError(err) {
		return
	}
	max_qty = uint64(_max_qty) * Imul
	for i := 0; i < worker_count; i++ {
		sWorkerCount.Add(1)
		go worker()
	}

	outerAddr, err := cfg.String("service", "order")
	if HasError(err) {
		return
	}
	outerSock, err := context.NewSocket(zmq.ROUTER)
	if HasError(err) {
		return
	}
	defer outerSock.Close()
	err = outerSock.Bind(outerAddr)
	if HasError(err) {
		return
	}

	hubAddr, err := cfg.String("pre", "hub")
	if HasError(err) {
		return
	}
	hubServer, err := context.NewSocket(zmq.DEALER)
	if HasError(err) {
		return
	}
	defer hubServer.Close()
	err = hubServer.Bind(hubAddr)
	if HasError(err) {
		return
	}

	Printf(">>> pre started on %s...", outerAddr)
	err = zmq.Proxy(outerSock, hubServer, nil)
	HasError(err)
}
