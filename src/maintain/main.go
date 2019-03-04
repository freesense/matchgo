package main

import (
	"bytes"
	"database/sql"
	"encoding/binary"
	"encoding/json"
	"flag"
	"fmt"
	"log"
	"os"
	"path/filepath"
	. "public"
	"strconv"
	"strings"
	"sync"
	"time"

	"github.com/garyburd/redigo/redis"
	_ "github.com/go-sql-driver/mysql"
	"github.com/larspensjo/config"
	_ "github.com/mattn/go-sqlite3"
	zmq "github.com/pebbe/zmq4"
)

var version = flag.Bool("v", false, "显示版本号")
var inipath = flag.String("i", "./matcher.ini", "配置文件路径")
var conf = flag.String("conf", "default", "个性化配置")

var settle = flag.Bool("settle", false, "日结")
var cancelall = flag.Bool("cancel", false, "全部撤单")
var dumporder = flag.Bool("dumporder", false, "打印全部委托的挂单数量")
var dumpsymbol = flag.Int("dumpsymbol", 0, "打印symbol盘口数据")
var stoporder = flag.Bool("stoporder", false, "停止收单")
var startorder = flag.Bool("startorder", false, "启动收单")
var check = flag.Bool("check", false, "对账，可选参数：account，update，checkfix")
var checkfix = flag.Bool("checkfix", false, "对账检查出的错误数据是否需要自动修改正确")
var account = flag.Uint("account", 0, "账号uid")
var update = flag.Bool("update", false, "是否更新数据库")
var rebuild = flag.Bool("rebuild", false, "根据数据库中的委托重建内存挂单和行情")
var showtag = flag.Bool("showtag", false, "显示日结标签")

//var checkfee = flag.Bool("checkfee", false, "检查bc-fee")
var settleq = flag.Bool("settleq", false, "行情日结")
var checktag = flag.Bool("checktag", false, "日结对账，参数：from，to，可选参数：account")
var fromtag = flag.String("from", "", "从哪个日结标签开始，默认为最初的数据")
var totag = flag.String("to", "", "到哪个日结标签结束，默认为当前无标签的最新数据")

var context *zmq.Context
var dbw *DbWrapper
var rdw *RDSWrapper
var cfg *config.Config

func zmqMaintain(cb func() interface{}) {
	v := cb()
	data, err := json.Marshal(v)
	if HasError(err) {
		return
	}

	context, err := zmq.NewContext()
	if HasError(err) {
		return
	}
	defer context.Term()

	sock, err := context.NewSocket(zmq.REQ)
	if HasError(err) {
		return
	}
	defer sock.Close()

	addr, err := cfg.String("service", "order")
	if HasError(err) {
		return
	}

	idx := strings.LastIndex(addr, ":")
	if idx == -1 {
		Println("Order address invalid: ", addr)
		return
	}
	addr = "tcp://127.0.0.1" + addr[idx:len(addr)]

	err = sock.Connect(addr)
	if HasError(err, addr) {
		return
	}

	_, err = sock.SendBytes(data, 0)
	if HasError(err) {
		return
	}

	recvdata, err := sock.RecvBytes(0)
	if HasError(err) {
		return
	}
	Println(string(recvdata))

	return
}

func main() {
	log.SetFlags(0)
	log.Printf("### maintainer version ###\n")
	log.Printf("Author:    %42s\n", "freesense@126.com")
	log.Printf("Build ver: %42s\n", BuildVer)
	log.Printf("Build date:%42s\n", BuildDate)

	flag.Parse()
	log.SetFlags(log.LstdFlags | log.Lmicroseconds)

	if *version {
		return
	}

	var err error

	cfg, err = config.ReadDefault(*inipath)
	FatalError(err)

	Init_public(cfg)

	dbw = NewDbWrapper(cfg, *conf)
	defer dbw.Close()
	rdw = NewRDSWrapper(cfg, *conf)
	defer rdw.Close()

	switch {
	case *settle:
		hispath, err := cfg.String("public", "hisquote")
		if HasError(err) {
			return
		}
		if _, err = os.Stat(hispath); os.IsNotExist(err) {
			if err = os.MkdirAll(hispath, 0755); HasError(err) {
				return
			}
		}
		Println("===== Settle Begin =====")
		qok := make(chan int)
		go transferQuote(hispath, qok)
		dbw.DaySettle(cfg, *conf)
		<-qok
		Println("===== Settle End =====")
	case *settleq:
		hispath, err := cfg.String("public", "hisquote")
		if HasError(err) {
			return
		}
		if _, err = os.Stat(hispath); os.IsNotExist(err) {
			if err = os.MkdirAll(hispath, 0755); HasError(err) {
				return
			}
		}
		qok := make(chan int)
		go transferQuote(hispath, qok)
		<-qok
	case *showtag:
		tags := dbw.GetTags(cfg, *conf)
		for _, tag := range tags {
			fmt.Println(tag)
		}
	case *cancelall:
		zmqMaintain(func() interface{} {
			return &OrderRequest{User_id: 0, Otype: 2}
		})
	case *dumporder:
		zmqMaintain(func() interface{} {
			return &OrderRequest{User_id: 0, Otype: 1}
		})
	case *dumpsymbol != 0:
		zmqMaintain(func() interface{} {
			return &OrderRequest{User_id: 0, Otype: 1, Symbol: uint32(*dumpsymbol), Qty: "50"}
		})
	case *stoporder:
		zmqMaintain(func() interface{} {
			return &OrderRequest{User_id: 0, Otype: 4}
		})
	case *startorder:
		zmqMaintain(func() interface{} {
			return &OrderRequest{User_id: 0, Otype: 5}
		})
	case *check:
		checkAccount(*account, *update, *checkfix)
	case *checktag:
		checkTag(*account, *fromtag, *totag)
	case *rebuild:
		rebuildOrder()
	//case *checkfee:
	//	dbw.CheckFee()
	default:
		return
	}
}

// 转移行情到历史行情文件
func transferQuote(hispath string, qok chan int) {
	defer func() {
		Println("Transfer Quote finished.")
		qok <- 0
	}()

	day := time.Now().AddDate(0, -1, 0).Format("20060102")

	rds := rdw.Get()
	defer rds.Close()

	prepareSqlite := func(symbol string) (db *sql.DB, err error) {
		fpath := filepath.Join(hispath, fmt.Sprintf("%s.%s.q", symbol, day[:4]))
		db, err = sql.Open("sqlite3", fpath)
		if HasError(err) {
			return
		}
		sql := `
	create table if not exists mink(
		dt int not null primary key,
		open int not null,
		high int not null,
		low int not null,
		close int not null,
		qty int not null
	);
	create table if not exists dayk(
		dt int not null primary key,
		open int not null,
		high int not null,
		low int not null,
		close int not null,
		qty int not null
	);
	`
		if _, err = db.Exec(sql); HasError(err) {
			return
		}

		return
	}

	do := func(key, token string) (err error) {
		// key: min.{symbol}
		parts := strings.Split(key, ".")
		symbol := parts[1]

		keys, err := redis.Strings(rds.Do("sort", key, "asc"))
		if HasError(err) {
			return
		}

		db, err := prepareSqlite(symbol)
		if err != nil {
			return
		}
		defer db.Close()

		sql := "begin transaction;\n"
		var delkey1, delkey2 []interface{}
		var mink map[string]string
		var dt, open, high, low, close, qty uint64
		delkey2 = append(delkey2, key)
		for _, _key := range keys {
			// _key: yyyymmddhhmm
			if _key[0:8] > day {
				break
			}
			delkey2 = append(delkey2, _key)

			kkey := fmt.Sprintf("%s.%s.%s", token, _key, symbol)
			mink, err = redis.StringMap(rds.Do("hgetall", kkey))
			if HasError(err) {
				return
			}
			dt, err = strconv.ParseUint(_key, 10, 64)
			if HasError(err) {
				return
			}
			open, err = strconv.ParseUint(mink["open"], 10, 64)
			if HasError(err) {
				return
			}
			high, err = strconv.ParseUint(mink["high"], 10, 64)
			if HasError(err) {
				return
			}
			low, err = strconv.ParseUint(mink["low"], 10, 64)
			if HasError(err) {
				return
			}
			close, err = strconv.ParseUint(mink["close"], 10, 64)
			if HasError(err) {
				return
			}
			qty, err = strconv.ParseUint(mink["qty"], 10, 64)
			if HasError(err) {
				return
			}
			sql += fmt.Sprintf("insert into %s values(%v,%v,%v,%v,%v,%v);\n", token, dt, open, high, low, close, qty)
			delkey1 = append(delkey1, kkey)
		}
		sql += "commit;"

		if _, err = db.Exec(sql); HasError(err) {
			return
		}
		if len(delkey1) > 0 {
			_, err = rds.Do("del", delkey1...)
			if HasError(err) {
				return
			}
		}
		if len(delkey2) > 1 {
			_, err = rds.Do("srem", delkey2...)
			if HasError(err) {
				return
			}
		}

		return
	}

	keys, err := redis.Strings(rds.Do("keys", "min.*"))
	if HasError(err) {
		return
	}

	for _, minkey := range keys {
		if err = do(minkey, "mink"); err != nil {
			break
		}
	}

	keys, err = redis.Strings(rds.Do("keys", "day.*"))
	if HasError(err) {
		return
	}

	for _, daykey := range keys {
		if err = do(daykey, "dayk"); err != nil {
			break
		}
	}
}

// 在两个日结标签之间检查资产情况
func checkTag(usrid uint, from, to string) {
	his := NewHisDbWrapper(cfg, *conf)
	defer his.Close()

	isSingle := false
	count, total := 0, 0
	ch := make(chan bool, 100)

	checkSingle := func(uid uint, single bool) error {
		defer func() {
			ch <- true
		}()

		Println(11111)
		trans, err := dbw.GetTransfer(uid, from, to)
		if err != nil {
			return err
		}
		Println(22222)
		recharge, err := dbw.GetRecharge(uid, from, to)
		if err != nil {
			return err
		}
		Println(33333)
		bonus, err := dbw.GetBonus(uid, from, to)
		if err != nil {
			return err
		}
		Println(44444)
		return his.CheckTag(single, uid, from, to, trans, recharge, bonus)
	}

	if usrid != 0 {
		isSingle = true
		//count++
		total = 1
		go checkSingle(usrid, isSingle)
		//fmt.Printf("\r[%v/%v] OK.", count, total)
	} else {
		/*max_conn, err := cfg.Int(*conf, "db_max_conn")
		if HasError(err) {
			return
		}*/

		users, err := dbw.GetUser()
		if err != nil {
			return
		}
		total = len(users)
		Println("aaaaaa", total)

		for _, usrid = range users {
			//count++
			go checkSingle(usrid, isSingle)
			//fmt.Printf("\r[%v/%v] OK.", count, total)
		}
	}

	for {
		_ = <-ch
		count++
		fmt.Printf("\r[%v/%v] OK.", count, total)
		if count == total {
			break
		}
	}
}

// 检查某一个账号的币币交易账号资金，全部历史交易和当前交易库
func checkAccount(usrid uint, update, checkfix bool) {
	his := NewHisDbWrapper(cfg, *conf)
	defer his.Close()
	var DoneMutex sync.Mutex
	var Done, UserCount int
	isSingle := true

	addChecked := func(usrid uint32) {
		rds := rdw.Get()
		defer rds.Close()
		if _, err := rds.Do("SELECT", "7"); HasError(err) {
			return
		}
		if _, err := rds.Do("SADD", "checked", usrid); HasError(err) {
			return
		}
	}

	getSkipped := func() (skip map[uint32]bool) {
		rds := rdw.Get()
		defer rds.Close()
		if _, err := rds.Do("SELECT", "7"); HasError(err) {
			return
		}
		skip = make(map[uint32]bool)
		data, err := redis.Strings(rds.Do("SMEMBERS", "skipped"))
		if HasError(err) {
			return
		}
		for _, uid := range data {
			id, err := strconv.Atoi(uid)
			if HasError(err) {
				return
			}
			skip[uint32(id)] = true
		}
		data, err = redis.Strings(rds.Do("SMEMBERS", "checked"))
		if HasError(err) {
			return
		}
		for _, uid := range data {
			id, err := strconv.Atoi(uid)
			if HasError(err) {
				return
			}
			skip[uint32(id)] = true
		}
		return
	}

	checkSingle := func(singleid uint) {
		allok, sqlok, total := true, true, 0
		//Printf("用户 %v 对账开始\n", singleid)

		defer func() {
			remark := "请检查异常信息"
			if allok && sqlok {
				remark = "正常"
			}
			DoneMutex.Lock()
			Done++
			Printf("[%v/%v] 用户 %v 共 %v 笔交易, %v\n", Done, UserCount, singleid, total, remark)
			DoneMutex.Unlock()
		}()

		ok, count, changesOrd := his.CheckAccount(rdw, singleid, checkfix)
		total += count
		if ok == false {
			allok = false
		}
		ok, count, curres := dbw.CheckAccount(rdw, singleid, checkfix)
		total += count
		if ok == false {
			allok = false
		}
		for ccy, e := range curres {
			if x, ok := changesOrd[ccy]; !ok {
				changesOrd[ccy] = e
			} else {
				changesOrd[ccy] = [2]int64{x[0] + e[0], x[1] + e[1]}
			}
		}

		if allok {
			changesHis := his.GetOccurSum(singleid)
			changesCur := dbw.GetOccurSum(singleid)
			oldAssets, err := dbw.GetOldByexAsset(singleid)
			if err != nil {
				return
			}
			trans, err := dbw.GetTransfer(singleid, "", "")
			if err != nil {
				return
			}
			recharge, err := dbw.GetRecharge(singleid, "", "")
			if err != nil {
				return
			}
			bonus, err := dbw.GetBonus(singleid, "", "")
			if err != nil {
				return
			}

			if isSingle {
				Printf("changesOrd = %v\n", changesOrd)
				Printf("changesHis = %v\n", changesHis)
				Printf("changesCur = %v\n", changesCur)
				Printf("oldAssets = %v\n", oldAssets)
				Printf("trans = %v\n", trans)
				Printf("recharge = %v\n", recharge)
				Printf("bonus = %v\n", bonus)
			}

			rds := rdw.Get()
			defer rds.Close()
			if _, err = rds.Do("SELECT", "6"); HasError(err) {
				return
			}

			for ccy, e := range oldAssets {
				if e[0] == 0 && e[1] == 0 {
					continue
				}
				if _, err = rds.Do("HMSET", fmt.Sprintf("%v.%v", singleid, ccy), "balance", e[0], "frozen", e[1]); HasError(err) {
					return
				}
			}
			for ccy, e := range trans {
				if _, err = rds.Do("HINCRBY", fmt.Sprintf("%v.%v", singleid, ccy), "balance", e); HasError(err) {
					return
				}
			}
			for ccy, e := range bonus {
				if _, err = rds.Do("HINCRBY", fmt.Sprintf("%v.%v", singleid, ccy), "balance", e); HasError(err) {
					return
				}
			}
			for ccy, e := range recharge {
				if _, err = rds.Do("HINCRBY", fmt.Sprintf("%v.%v", singleid, ccy), "balance", e[0]); HasError(err) {
					return
				}
				if _, err = rds.Do("HINCRBY", fmt.Sprintf("%v.%v", singleid, ccy), "frozen", e[1]); HasError(err) {
					return
				}
			}
			for ccy, e := range changesOrd {
				if _, err := rds.Do("HINCRBY", fmt.Sprintf("%v.%v", singleid, ccy), "balance", e[0]); HasError(err) {
					return
				}
				if _, err = rds.Do("HINCRBY", fmt.Sprintf("%v.%v", singleid, ccy), "frozen", e[1]); HasError(err) {
					return
				}
			}
			for ccy, e := range changesHis {
				if _, err = rds.Do("HINCRBY", fmt.Sprintf("%v.%v", singleid, ccy), "balance", e[0]); HasError(err) {
					return
				}
				if _, err = rds.Do("HINCRBY", fmt.Sprintf("%v.%v", singleid, ccy), "frozen", e[1]); HasError(err) {
					return
				}
			}
			for ccy, e := range changesCur {
				if _, err = rds.Do("HINCRBY", fmt.Sprintf("%v.%v", singleid, ccy), "balance", e[0]); HasError(err) {
					return
				}
				if _, err = rds.Do("HINCRBY", fmt.Sprintf("%v.%v", singleid, ccy), "frozen", e[1]); HasError(err) {
					return
				}
			}

			holds, err := dbw.GetPositionInt(uint32(singleid))
			if HasError(err) {
				return
			}

			var sMatch string
			var orgBalance int64
			var orgFrozen int64
			var sql []string
			for i := 1; i < 20; i++ {
				data, err := redis.StringMap(rds.Do("HGETALL", fmt.Sprintf("%v.%v", singleid, i)))
				if HasError(err) {
					return
				}
				if org, ok := holds[uint32(i)]; ok {
					orgBalance = org[0]
					orgFrozen = int64(org[1])
				} else {
					orgBalance = 0
					orgFrozen = 0
				}
				if len(data) > 0 {
					var ok bool
					var balance, frozen string
					if balance, ok = data["balance"]; !ok || len(balance) == 0 {
						balance = "0"
					}
					if frozen, ok = data["frozen"]; !ok || len(frozen) == 0 {
						frozen = "0"
					}
					_balance, err := strconv.ParseInt(balance, 10, 64)
					if HasError(err) {
						sqlok = false
						break
					}
					_frozen, err := strconv.ParseInt(frozen, 10, 64)
					if HasError(err) {
						sqlok = false
						break
					}

					if orgBalance == _balance && orgFrozen == _frozen {
						sMatch = "OK"
					} else {
						sMatch = "Not Match"
					}

					if _balance >= 0 && _frozen >= 0 {
						sql = append(sql, fmt.Sprintf("update jys_position set balance=%v,frozen=%v where user_id=%v and ccy=%v;\n", balance, frozen, singleid, i))
						if isSingle {
							Printf("用户=%v, 币种=%v, balance=%v, frozen=%v [%s]\n", singleid, i, balance, frozen, sMatch)
						}
					} else {
						sqlok = false
						Printf("用户=%v, 币种=%v, balance=%v, frozen=%v [%s]\n", singleid, i, balance, frozen, sMatch)
					}
				} else {
					sql = append(sql, fmt.Sprintf("update jys_position set balance=0,frozen=0 where user_id=%v and ccy=%v;\n", singleid, i))
				}
			}
			if sqlok {
				if update {
					err = dbw.Execute(sql)
					if err == nil {
						addChecked(uint32(singleid))
					}
				}
			}
		}
	}

	rds := rdw.Get()
	defer rds.Close()
	if _, err := rds.Do("SELECT", "6"); HasError(err) {
		return
	}
	if _, err := rds.Do("FLUSHDB"); HasError(err) {
		return
	}

	if usrid != 0 {
		UserCount = 1
		checkSingle(usrid)
	} else {
		isSingle = false
		users, err := dbw.GetUser()
		if err != nil {
			return
		}

		skipped := getSkipped()
		UserCount = len(users) - len(skipped)
		Printf("共 %v 用户\n", UserCount)

		for _, user := range users {
			if _, ok := skipped[uint32(user)]; !ok {
				checkSingle(user)
			}
		}
	}
}

func rebuildOrder() {
	context, err := zmq.NewContext()
	FatalError(err)
	defer context.Term()

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

	rds := rdw.Get()
	defer rds.Close()

	v, err := redis.Strings(rds.Do("keys", "bars.*"))
	if HasError(err) {
		return
	}
	for _, k := range v {
		_, err = rds.Do("del", k)
		HasError(err)
	}

	v, err = redis.Strings(rds.Do("keys", "bar.*"))
	if HasError(err) {
		return
	}
	for _, k := range v {
		_, err = rds.Do("del", k)
		HasError(err)
	}

	orders := dbw.GetPendingOrders()
	total := len(orders)
	for idx, ord := range orders {
		buf := &bytes.Buffer{}
		binary.Write(buf, binary.LittleEndian, ord)
		for {
			_, err := coreSock.SendMessage("", buf)
			if err != nil {
				time.Sleep(time.Second)
			} else {
				break
			}
		}
		msg, err := coreSock.RecvMessage(0)
		if HasError(err) {
			break
		}
		l := strings.Split(msg[len(msg)-1], ".")
		_, err = strconv.Atoi(l[0])
		if HasError(err) {
			return
		}
		consign_id, err := strconv.ParseInt(l[1], 0, 0)
		if HasError(err) {
			return
		}
		if consign_id > 0 {
			fmt.Printf("\rLoading...[%d/%d]", idx+1, total)
		}
	}
	fmt.Printf("\rLoading...[%d/%d] OK\n", total, total)
}
