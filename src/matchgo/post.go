package main

import (
	"fmt"
	. "public"
	"sync/atomic"
	"time"
	"unsafe"

	zmq "github.com/pebbe/zmq4"
)

//var quitFlag sync.WaitGroup
var postCount int32

func Msgpost(obj *Tick) {
	defer atomic.AddInt32(&postCount, -1)

	var aid, pid uint64
	var auser, puser, astatus, pstatus uint32
	var err error
	var settleAid, settlePid uint64

	flag := true
	for {
		if obj.Oid_activated == 0 { // 撤单成交
			if obj.Activate_type == 0x06 { // cancel all
				push := func(consignid uint64, usrid, status uint32) {
					rds := rdw.Get(0)
					if rds == nil {
						return
					}
					defer rds.Close()
					_, err = rds.Do("publish", fmt.Sprintf("orderstatus.%d", usrid), fmt.Sprintf("%d.%d", consignid, status))
					HasError(err)
				}

				if obj.Symbol == 0 {
					for {
						x := atomic.LoadInt32(&postCount)
						if x != 1 {
							Printf("Cancel all, waiting %d post...\n", x)
							time.Sleep(time.Second)
						} else {
							break
						}
					}
				}
				dbw.CancelAll(obj.Symbol, push)
				Println("Cancel all finished.")
			} else {
				pid = obj.Oid_proactive
				settlePid = pid
				aid, auser, puser, astatus, pstatus, err = dbw.On_cancel(obj)
			}
		} else if obj.Oid_proactive == 0 { // market finished
			aid = obj.Oid_activated
			settleAid = aid
			for {
				auser, astatus, err = dbw.On_market_finished(obj)
				if astatus != Wait {
					break
				} else {
					time.Sleep(time.Millisecond)
				}
			}
		} else {
			aid = obj.Oid_activated
			pid = obj.Oid_proactive
			auser, puser, astatus, pstatus, err = dbw.Add_tick(obj)
			if astatus == 5 || astatus == 6 {
				settleAid = aid
			}
			if pstatus == 5 || pstatus == 6 {
				settlePid = pid
			}
		}
		if err == nil {
			if flag == false {
				Println("Post OK.")
			}
			break
		} else { // 事务已经回滚，继续提交
			flag = false
		}
	}

	dbw.Settle(settleAid)
	dbw.Settle(settlePid)

	rds := rdw.Get(0)
	if rds == nil {
		return
	}
	defer rds.Close()
	if aid != 0 {
		_, err = rds.Do("publish", fmt.Sprintf("orderstatus.%d", auser), fmt.Sprintf("%d.%d", aid, astatus))
		HasError(err)
	}
	if pid != 0 {
		_, err = rds.Do("publish", fmt.Sprintf("orderstatus.%d", puser), fmt.Sprintf("%d.%d", pid, pstatus))
		HasError(err)
	}
}

func loop_post() {
	defer func() {
		Println(">>> Post finished.")
		wg.Done()
	}()

	// todo: multi core notify
	addr, err := cfg.String("core", "notify")
	if HasError(err) {
		return
	}
	puller, err := context.NewSocket(zmq.PULL)
	if HasError(err) {
		return
	}
	defer puller.Close()
	err = puller.Connect(addr)
	if HasError(err) {
		return
	}

	Printf(">>> post started on %s ...", addr)

	for {
		msg, err := puller.RecvBytes(0)
		if !HasError(err) {
			obj := *(**Tick)(unsafe.Pointer(&msg))
			atomic.AddInt32(&postCount, 1)
			go Msgpost(obj)
		}
	}
}
