package main

import (
	"fmt"
	"io/ioutil"
	"net"
	"net/http"
	. "public"
	"sort"
	"strconv"
	"strings"
	"sync"
	"time"

	"github.com/garyburd/redigo/redis"
	"github.com/gorilla/websocket"
	"github.com/shopspring/decimal"
)

var url_verify string
var maxtick int
var GetPosition, OnOrder *redis.Script
var l net.Listener

var upgrader = websocket.Upgrader{
	CheckOrigin: func(r *http.Request) bool {
		return true
	},
}

type PushRequest struct {
	Topic, Symbol, Period, Refresh_token string
	Subscribe, Unsubscribe               []string
	Depth, Count                         int
	From, To                             string
}

func (self *PushRequest) dump() string {
	return fmt.Sprintf("PR, Topic:%s, Symbol:%s, Period:%s, Token:%s, Depth:%d, Count:%d, From:%s, To:%s, Sub:%s, Unsub:%s", self.Topic, self.Symbol, self.Period, self.Refresh_token, self.Depth, self.Count, self.From, self.To, self.Subscribe, self.Unsubscribe)
}

type PushMessage struct {
	topic string // "quote"/"tick"/"orderstatus"
	id    uint32 // sid/sid/uid
	msg   interface{}
}

type PTick struct {
	Topic, Data string
}

type SnapShot struct {
	Topic string
	Now   int64 // UTC timestamp
	Data  map[string]string
}

type OrderStatus struct {
	Topic, Orderid, Status string
}

type Position struct {
	Topic, Symbol, Latest, Ask, Bid string
}

type K struct {
	Topic, Symbol, Result, Msg, First, Nearest string
	Data                                       map[uint64]string
}

type Daypass struct {
	Topic, Data string
}

func (o *PushMessage) dump() string {
	return fmt.Sprintf("PM, %s, id=%d: %s", o.topic, o.id, o.msg)
}

type LoginMessage struct {
	conn  *Client
	usrid uint32
}

type ClientManager struct {
	clients    map[*Client]bool
	users      map[uint32]*Client
	register   chan *Client
	unregister chan *Client
	login      chan *LoginMessage
	newpub     chan *redis.PubSubConn
	message    chan *PushMessage
	//quit       chan bool
	psConn *redis.PubSubConn
}

type Client struct {
	//id     string
	usrid    uint32
	socket   *websocket.Conn
	send     chan interface{}
	tlock    sync.RWMutex
	tsub     map[uint32]bool // tick订阅的symbolid
	plock    sync.RWMutex
	psub     map[uint32]bool // position订阅的symbolid
	serialno uint8           // push serialno
}

type Resp struct {
	Result, Topic, Errmsg string
}

func (c *Client) onerror(result, topic, errmsg string) *Resp {
	return &Resp{Result: result, Topic: topic, Errmsg: errmsg}
}

func (c *Client) TSub(l []uint32, u []uint32) {
	c.tlock.Lock()
	defer func() {
		c.tlock.Unlock()
	}()

	for _, _id := range u {
		delete(c.tsub, _id)
	}
	for _, _id := range l {
		c.tsub[_id] = true
	}
}

func (c *Client) PSub(l []uint32, u []uint32) {
	c.plock.Lock()
	defer func() {
		c.plock.Unlock()
	}()

	for _, _id := range u {
		delete(c.psub, _id)
	}
	for _, _id := range l {
		c.psub[_id] = true
	}
}

var manager = ClientManager{
	clients:    make(map[*Client]bool),
	users:      make(map[uint32]*Client),
	register:   make(chan *Client),
	unregister: make(chan *Client),
	login:      make(chan *LoginMessage),
	newpub:     make(chan *redis.PubSubConn),
	message:    make(chan *PushMessage),
	//quit:       make(chan bool),
}

func (manager *ClientManager) start() {
	defer Println("Push-Manager stopped.")

	CloseClient := func(client *Client) {
		close(client.send)
		client.socket.Close()
		if client.usrid > 0 {
			delete(manager.users, client.usrid)
		}
		delete(manager.clients, client)
	}

	for {
		select {
		/*case <-manager.quit:
		for client, _ := range manager.clients {
			CloseClient(client)
		}
		return*/

		case conn := <-manager.register:
			//Println("register")
			manager.clients[conn] = true

		case conn := <-manager.unregister:
			//Println("unregister")
			if _, ok := manager.clients[conn]; ok {
				manager.clients[conn] = false
			}

		case msg := <-manager.login:
			//Println("login")
			if _, ok := manager.clients[msg.conn]; ok {
				msg.conn.usrid = msg.usrid
				manager.users[msg.usrid] = msg.conn
				err := manager.psConn.Subscribe(fmt.Sprintf("orderstatus.%d", msg.usrid))
				HasError(err)
			}

		case c := <-manager.newpub:
			//Println("newpub")
			var err error
			for client, _ := range manager.clients {
				if client.usrid > 0 {
					err = c.Subscribe(fmt.Sprintf("orderstatus.%d", client.usrid))
					if HasError(err) {
						manager.newpub <- nil
						break
					}
				}
			}
			if err != nil {
				manager.newpub <- nil
				break
			}
			err = c.PSubscribe("tick.*", "quote.*", "quit.*" /*, "daypassed"*/)
			if HasError(err) {
				manager.newpub <- nil
			} else {
				manager.psConn = c
				manager.newpub <- c
			}

		case msg := <-manager.message:
			//Printf("message, topic=%s", msg.topic)
			switch msg.topic {
			case "quote":
				for client, alive := range manager.clients {
					if alive == false {
						CloseClient(client)
					} else {
						client.plock.RLock()
						if _, ok := client.psub[msg.id]; ok {
							select {
							case client.send <- msg.msg:
							default:
							}
						}
						client.plock.RUnlock()
					}
				}
			case "tick":
				for client, alive := range manager.clients {
					if alive == false {
						CloseClient(client)
					} else {
						//Printf("11111\n")
						client.tlock.RLock()
						if _, ok := client.tsub[msg.id]; ok {
							select {
							case client.send <- msg.msg:
							default:
							}
						}
						client.tlock.RUnlock()
						//Printf("22222\n")
					}
				}
			case "orderstatus":
				if client, ok := manager.users[msg.id]; ok {
					select {
					case client.send <- msg.msg:
					default:
					}
				}
			}
		}
	}
}

func (c *Client) read(ch chan *LoginMessage) {
	close := func() {
		manager.unregister <- c
	}
	defer close()

	for {
		var req PushRequest
		var rep interface{}

		err := c.socket.ReadJSON(&req)
		if err != nil {
			break
		}
		//Println(c.socket.RemoteAddr(), req.dump())

		switch req.Topic {
		case "ping":
			rep = c.onerror("ok", "pong", "")
		case "login":
			url := fmt.Sprintf("%s?refresh_token=%s", url_verify, req.Refresh_token)
			resp, err := http.Get(url)
			if HasError(err) {
				rep = c.onerror("failed", req.Topic, err.Error())
				break
			}
			defer resp.Body.Close()

			if resp.StatusCode != 200 {
				rep = c.onerror("failed", req.Topic, strconv.Itoa(resp.StatusCode))
				break
			}

			body, err := ioutil.ReadAll(resp.Body)
			if HasError(err) {
				rep = c.onerror("failed", req.Topic, err.Error())
				break
			}
			//Println(body)

			type verify_ans struct {
				User_id uint32
			}
			var _ans verify_ans
			err = json.Unmarshal(body, &_ans)
			if HasError(err) {
				rep = c.onerror("failed", req.Topic, err.Error())
				break
			}

			ch <- &LoginMessage{
				usrid: _ans.User_id,
				conn:  c,
			}

			rep = c.onerror("ok", req.Topic, "")

		case "logout":
			ch <- &LoginMessage{
				usrid: 0,
				conn:  c,
			}
			rep = c.onerror("ok", req.Topic, "")

		case "snapshot":
			// { "topic": "snapshot", "subscribe": ["BTC"] }
			rep, err = get_snapshot(c, &req)
			if err != nil {
				rep = c.onerror("failed", req.Topic, err.Error())
			}

		case "histick":
			// { "topic": "histick", "symbol": "USDT/BTC" }
			rep, err = get_histick(c, &req)
			if err != nil {
				rep = c.onerror("failed", req.Topic, err.Error())
			}

		case "k":
			// { "topic": "k", "symbol": "USDT/BTC", "period": "3m", "from": "20110101", "to": "20220202" }
			rep, err = get_k(c, &req)
			if err != nil {
				rep = c.onerror("failed", req.Topic, err.Error())
			}

		case "position":
			// { "topic": "position", "symbol": "USDT/BTC", "depth": 20 }
			rep, err = get_position(c, &req)
			if err != nil {
				rep = c.onerror("failed", req.Topic, err.Error())
			}

		default:
			rep = c.onerror("failed", req.Topic, "unknown topic")
		}

		//Println(c.socket.RemoteAddr(), rep)
		c.send <- rep
	}
}

func (c *Client) write() {
	for {
		select {
		case message, ok := <-c.send:
			if !ok {
				return
			}
			//serialno := strconv.Itoa(int(c.serialno))
			//c.serialno++
			//err := c.socket.WriteMessage(websocket.TextMessage, []byte(serialno))
			err := c.socket.WriteJSON(message)
			if err != nil {
				return
			}
		}
	}
}

func loop_push() {
	defer func() {
		Println(">>> Push finished.")
		wg.Done()
	}()

	var err error

	err = load_lua()
	if err != nil {
		return
	}

	url_verify, err = cfg.String(*conf, "url_verify")
	if HasError(err) {
		return
	}

	maxtick, err = cfg.Int("public", "maxtick")
	if HasError(err) {
		return
	}

	ws_addr, err := cfg.Int("service", "push")
	if HasError(err) {
		return
	}

	go manager.start()
	go handleRedis(manager.newpub, manager.message)

	Printf(">>> push started on %d...\n", ws_addr)
	l, err = net.Listen("tcp", fmt.Sprintf(":%d", ws_addr))
	if !HasError(err) {
		svr := http.Server{}
		http.HandleFunc("/", handleConnections)
		err = svr.Serve(l)
		HasError(err)
	}
}

func handleConnections(w http.ResponseWriter, r *http.Request) {
	ws, err := upgrader.Upgrade(w, r, nil)
	if HasError(err) {
		return
	}

	//Printf("ws %s connected.", ws.RemoteAddr())
	client := &Client{socket: ws, send: make(chan interface{}, 10), tsub: make(map[uint32]bool), psub: make(map[uint32]bool)}
	manager.register <- client
	go client.read(manager.login)
	go client.write()
}

func handleRedis(ch chan *redis.PubSubConn, q chan *PushMessage) {
	defer Println("Push-Redis stopped.")

	NewPub := func() *redis.PubSubConn {
		for {
			c := rdw.GetPubSub()
			ch <- c
			c = <-ch
			if c != nil {
				return c
			} else {
				c.Close()
				time.Sleep(time.Duration(5) * time.Second)
			}
		}
	}

	OnMessage := func(channel string, data []byte) {
		ch := strings.Split(channel, ".")
		nid, err := strconv.Atoi(ch[1])
		if HasError(err) {
			return
		}

		var obj = PushMessage{
			topic: ch[0],
			id:    uint32(nid),
		}

		d := strings.Split(string(data), ".")
		if ch[0] == "daypassed" {
			/*name, ok := dbw.Get_symbolname_from_id(uint32(nid))
			if !ok {
				Printf("Name not found with symbolid = %d", nid)
				return
			}
			_price, err := strconv.ParseUint(d[2], 0, 0)
			if HasError(err) {
				return
			}
			_qty, err := strconv.ParseUint(d[3], 0, 0)
			if HasError(err) {
				return
			}
			price := Uint64DivDec(_price)
			qty := Uint64DivDec(_qty)

			var msg Daypass
			msg.Topic = "daypassed"
			msg.Data = fmt.Sprintf("%s|%s|%s|%s", name, d[1], price.String(), qty.String())
			obj.msg = &msg
			*/
		} else if ch[0] == "quote" {
			name, ok := dbw.Get_symbolname_from_id(uint32(nid))
			if !ok {
				Printf("Name not found with symbolid = %d", nid)
				return
			}

			bs, err := strconv.Atoi(d[0])
			if HasError(err) {
				return
			}
			_price, err := strconv.ParseUint(d[1], 0, 0)
			if HasError(err) {
				return
			}
			_qty, err := strconv.ParseUint(d[2], 0, 0)
			if HasError(err) {
				return
			}
			price := Uint64DivDec(_price)
			qty := Uint64DivDec(_qty)

			var msg Position
			msg.Topic = "position-push"
			msg.Symbol = name
			if bs > 0 {
				msg.Ask = fmt.Sprintf("%s|%s", price.String(), qty.String())
			} else {
				msg.Bid = fmt.Sprintf("%s|%s", price.String(), qty.String())
			}
			obj.msg = &msg

		} else if ch[0] == "tick" {
			name, ok := dbw.Get_symbolname_from_id(uint32(nid))
			if !ok {
				Printf("Name not found with symbolid = %d", nid)
				return
			}

			_atype, dt := d[0], d[1]
			atype, err := strconv.Atoi(_atype)
			if HasError(err) {
				return
			}
			if atype&0x01 > 0 {
				atype = 1
			} else {
				atype = 0
			}
			_price, err := strconv.ParseUint(d[2], 0, 0)
			if HasError(err) {
				return
			}
			_qty, err := strconv.ParseUint(d[3], 0, 0)
			if HasError(err) {
				return
			}
			price := Uint64DivDec(_price)
			qty := Uint64DivDec(_qty)

			var msg PTick
			msg.Topic = "tick"
			msg.Data = fmt.Sprintf("%s|%d|%s|%s|%s", name, atype, dt, price.String(), qty.String())
			obj.msg = &msg

		} else if ch[0] == "orderstatus" {
			var msg OrderStatus
			msg.Topic = "orderstatus"
			msg.Orderid = d[0]
			msg.Status = d[1]
			obj.msg = &msg

		}

		q <- &obj
		return
	}

	c := NewPub()
	for {
		switch v := c.Receive().(type) {
		case error:
			HasError(v)
			c.Close()
			c = NewPub()
		case redis.Subscription:
			//Printf("Channel %s: %d\n", v.Channel, v.Count)
		case redis.PMessage:
			OnMessage(v.Channel, v.Data)
		case redis.Message:
			OnMessage(v.Channel, v.Data)
		default:
			Println("Unknown Message")
		}
	}

	//manager.quit <- true
	l.Close()
}

type HisTick struct {
	Topic, Symbol string
	Data          []string
}

func get_histick(c *Client, req *PushRequest) (obj *HisTick, err error) {
	req.Subscribe = append(req.Subscribe, req.Symbol)
	sub, unsub := subscribe(c, req)
	c.TSub(sub, unsub)

	var sid uint32
	var ok bool
	if sid, ok = dbw.Get_symbolid_from_name(req.Symbol); !ok {
		err = BuildError(true, "invalid symbol: %s", req.Symbol)
		return
	}

	rds := rdw.Get(0)
	if rds == nil {
		return
	}
	defer rds.Close()

	obj = &HisTick{Topic: "histick", Symbol: req.Symbol}

	values, err := redis.Strings(rds.Do("lrange", fmt.Sprintf("tick.%d", sid), 0, maxtick))
	if HasError(err) {
		return
	}

	for _, v := range values {
		d := strings.Split(v, "|")
		d[2], err = StringDivString(d[2])
		if HasError(err) {
			continue
		}
		d[3], err = StringDivString(d[3])
		if HasError(err) {
			continue
		}
		obj.Data = append(obj.Data, fmt.Sprintf("%s|%s|%s|%s|%s", req.Symbol, d[0], d[1], d[2], d[3]))
	}

	return
}

func get_position(c *Client, req *PushRequest) (obj *Position, err error) {
	req.Subscribe = append(req.Subscribe, req.Symbol)
	sub, unsub := subscribe(c, req)
	c.PSub(sub, unsub)

	var sid uint32
	var ok bool
	if sid, ok = dbw.Get_symbolid_from_name(req.Symbol); !ok {
		err = BuildError(true, "invalid symbol: %s", req.Symbol)
		return
	}

	if req.Depth == 0 {
		req.Depth = 20
	}

	rds := rdw.Get(0)
	if rds == nil {
		return
	}
	defer rds.Close()

	x, err := redis.Strings(GetPosition.Do(rds, sid, req.Depth))
	if HasError(err, "Symbol:", sid) {
		return
	}

	div := func(value string) string {
		if len(value) == 0 {
			return value
		}
		if v, err := StringDivString(value); err != nil {
			HasError(err, value)
			return value
		} else {
			return v
		}
	}

	obj = &Position{Topic: "position", Latest: div(x[0]), Symbol: req.Symbol}
	if len(x[1]) > 0 {
		y1 := strings.Split(strings.TrimLeft(x[1], "|"), "|")
		bid := make([]string, len(y1))
		for i, v := range y1 {
			bid[i] = div(v)
		}
		obj.Bid = strings.Join(bid, "|")
	}
	if len(x[2]) > 0 {
		y2 := strings.Split(strings.TrimLeft(x[2], "|"), "|")
		ask := make([]string, len(y2))
		for i, v := range y2 {
			ask[i] = div(v)
		}
		obj.Ask = strings.Join(ask, "|")
	}

	return
}

func subscribe_datum(c *Client, req *PushRequest) (sub, unsub []uint32) {
	for _, datum := range req.Subscribe {
		if l, ok := dbw.Get_datumids(datum); ok {
			sub = append(sub, l...)
		}
	}
	for _, datum := range req.Unsubscribe {
		if l, ok := dbw.Get_datumids(datum); ok {
			unsub = append(unsub, l...)
		}
	}
	return
}

func subscribe(c *Client, req *PushRequest) (sub, unsub []uint32) {
	sub = dbw.ConvSymbolNames(req.Subscribe)
	unsub = dbw.ConvSymbolNames(req.Unsubscribe)
	return
}

func get_k(c *Client, req *PushRequest) (obj *K, err error) {
	req.Subscribe = append(req.Subscribe, req.Symbol)
	sub, unsub := subscribe(c, req)
	c.TSub(sub, unsub)

	var sid uint32
	var ok bool
	if sid, ok = dbw.Get_symbolid_from_name(req.Symbol); !ok {
		err = BuildError(true, "invalid symbol: %s", req.Symbol)
		return
	}

	if len(req.Period) == 0 {
		req.Period = "1m"
	}

	if len(req.From) == 0 || len(req.To) == 0 {
		err = BuildError(true, "invalid from/to")
		return
	}

	from, err := strconv.ParseUint(req.From, 0, 0)
	if HasError(err) {
		return
	}

	to, err := strconv.ParseUint(req.To, 0, 0)
	if HasError(err) {
		return
	}

	if req.From > req.To {
		err = BuildError(true, "invalid from/to")
		return
	}

	_period, err := strconv.Atoi(req.Period[0 : len(req.Period)-1])
	if HasError(err) {
		return
	}
	_type := req.Period[len(req.Period)-1:]

	obj = &K{Topic: "k", Symbol: req.Symbol, Data: make(map[uint64]string)}
	switch _type {
	case "m":
		err = build_mink(sid, from, to, _period, obj)
	case "d":
		err = build_dayk(sid, from, to, _period, obj)
	case "w":
		err = build_week(sid, from, to, _period, obj)
	default:
		err = BuildError(true, "unknown k type: %s", _type)
	}

	return
}

type Int64Slice []int64

func (p Int64Slice) Len() int           { return len(p) }
func (p Int64Slice) Less(i, j int) bool { return p[i] < p[j] }
func (p Int64Slice) Swap(i, j int)      { p[i], p[j] = p[j], p[i] }

func build_mink(sid uint32, from, to uint64, period int, obj *K) error {
	if period >= 1440 || period <= 0 {
		return BuildError(true, "Invalid period: %d", period)
	}

	rds := rdw.Get(0)
	if rds == nil {
		return BuildError(false, "redis connection not available")
	}
	defer rds.Close()
	mins, err := redis.Int64s(rds.Do("smembers", fmt.Sprintf("min.%d", sid)))
	if HasError(err) {
		return err
	}
	if len(mins) == 0 {
		obj.First = ""
		return nil
	}

	sort.Sort(Int64Slice(mins))
	obj.First = strconv.FormatInt(mins[0], 10)

	last_day := uint32(mins[0] / 10000)
	last_idx := uint32(0)

	delims := func() []uint32 {
		// 按照period产生24小时内分钟数间隔
		var mins []uint32
		for i := 0; i <= 1440; i += period {
			mins = append(mins, uint32(i/60*100+i%60))
		}
		return mins
	}()

	get_first_min := func(_dt uint64, _last_day, _last_idx uint32) (dt uint64, last_day, last_idx uint32) {
		/* 获得分钟线对应的合并后分钟数
		_dt: 当前分钟线的时间(YYYYmmddHHMM)
		_last_day: 上一条分钟线的日期
		_last_idx: 从delims的哪一个索引开始计算，默认从头开始算
		return: 合并后分钟数(YYYYmmddHHMM), 本条分钟线的日期, 本条分钟线的delims索引
		*/
		_day, _min := _dt/10000, _dt%10000
		for {
			_next := (_last_idx + 1) % uint32(len(delims))
			if _next != 0 {
				if delims[_last_idx] <= uint32(_min) && uint32(_min) < delims[_next] {
					dt = _day*10000 + uint64(delims[_last_idx])
					last_day = uint32(_day)
					last_idx = _last_idx
					return
				}
				_last_idx = _next
			} else if uint32(_day) == _last_day {
				dt = _day*10000 + uint64(delims[_last_idx])
				last_day = uint32(_day)
				last_idx = _last_idx
				return
			} else { // 跨日
				_last_idx = 0
			}
		}
	}

	var key uint64
	var x = make(map[uint64][]decimal.Decimal)
	for _, min := range mins {
		if uint64(min) > to {
			break
		}
		if uint64(min) < from {
			obj.Nearest = strconv.FormatUint(uint64(min), 10)
			continue
		}

		key, last_day, last_idx = get_first_min(uint64(min), last_day, last_idx)
		data, err := redis.StringMap(rds.Do("hgetall", fmt.Sprintf("mink.%d.%d", min, sid)))
		if HasError(err) {
			return err
		}

		open, err := StringDivDec(data["open"])
		if HasError(err) {
			return err
		}
		high, err := StringDivDec(data["high"])
		if HasError(err) {
			return err
		}
		low, err := StringDivDec(data["low"])
		if HasError(err) {
			return err
		}
		close, err := StringDivDec(data["close"])
		if HasError(err) {
			return err
		}
		qty, err := StringDivDec(data["qty"])
		if HasError(err) {
			return err
		}

		if _x, ok := x[key]; !ok {
			x[key] = []decimal.Decimal{open, high, low, close, qty}
		} else {
			_x[1] = Max(_x[1], high)
			_x[2] = Min(_x[2], low)
			_x[3] = close
			_x[4] = _x[4].Add(qty)
		}
	}

	for k, v := range x {
		obj.Data[k] = fmt.Sprintf("%s|%s|%s|%s|%s", v[0].String(), v[1].String(), v[2].String(), v[3].String(), v[4].String())
	}
	return nil
}

func build_week(sid uint32, from, to uint64, period int, obj *K) error {
	rds := rdw.Get(0)
	if rds == nil {
		return BuildError(false, "redis connection not avaliable")
	}
	defer rds.Close()
	days, err := redis.Ints(rds.Do("smembers", fmt.Sprintf("day.%d", sid)))
	if HasError(err) {
		return err
	}
	if len(days) == 0 {
		obj.First = ""
	} else {
		sort.Ints(days)
		obj.First = strconv.Itoa(days[0])
	}

	get_week_first_day := func(day int) int {
		// sunday是每周第一天 返回所在周的第一天日期
		_day := time.Date(day/10000, time.Month((day%10000)/100), day%100, 0, 0, 0, 0, time.UTC)
		delta := _day.Weekday()
		first_day := _day.AddDate(0, 0, -1*int(delta))
		return first_day.Year()*10000 + int(first_day.Month())*100 + first_day.Day()
	}

	var x = make(map[uint32][]decimal.Decimal)
	for _, day := range days {
		if uint64(day) > to {
			break
		}
		if uint64(day) < from {
			obj.Nearest = strconv.FormatUint(uint64(day), 10)
			continue
		}
		first_day := get_week_first_day(day)
		data, err := redis.StringMap(rds.Do("hgetall", fmt.Sprintf("dayk.%d.%d", day, sid)))
		if HasError(err) {
			return err
		}

		open, err := StringDivDec(data["open"])
		if HasError(err) {
			return err
		}
		high, err := StringDivDec(data["high"])
		if HasError(err) {
			return err
		}
		low, err := StringDivDec(data["low"])
		if HasError(err) {
			return err
		}
		close, err := StringDivDec(data["close"])
		if HasError(err) {
			return err
		}
		qty, err := StringDivDec(data["qty"])
		if HasError(err) {
			return err
		}

		if _x, ok := x[uint32(first_day)]; !ok {
			x[uint32(first_day)] = []decimal.Decimal{open, high, low, close, qty}
		} else {
			_x[1] = Max(_x[1], high)
			_x[2] = Max(_x[2], high)
			_x[3] = close
			_x[4] = _x[4].Add(qty)
		}
	}

	for k, v := range x {
		obj.Data[uint64(k)] = fmt.Sprintf("%s|%s|%s|%s|%s", v[0].String(), v[1].String(), v[2].String(), v[3].String(), v[4].String())
	}
	return nil
}

func build_dayk(sid uint32, from, to uint64, period int, obj *K) error {
	rds := rdw.Get(0)
	if rds == nil {
		return BuildError(false, "redis connection not available")
	}
	defer rds.Close()
	days, err := redis.Ints(rds.Do("smembers", fmt.Sprintf("day.%d", sid)))
	if HasError(err) {
		return err
	}
	if len(days) == 0 {
		obj.First = ""
	} else {
		sort.Ints(days)
		obj.First = strconv.Itoa(days[0])
	}

	for _, day := range days {
		if uint64(day) > to {
			break
		}
		if uint64(day) < from {
			obj.Nearest = strconv.FormatUint(uint64(day), 10)
			continue
		}

		data, err := redis.StringMap(rds.Do("hgetall", fmt.Sprintf("dayk.%d.%d", day, sid)))
		if HasError(err) {
			return err
		}

		open, err := StringDivString(data["open"])
		if HasError(err) {
			return err
		}
		high, err := StringDivString(data["high"])
		if HasError(err) {
			return err
		}
		low, err := StringDivString(data["low"])
		if HasError(err) {
			return err
		}
		close, err := StringDivString(data["close"])
		if HasError(err) {
			return err
		}
		qty, err := StringDivString(data["qty"])
		if HasError(err) {
			return err
		}

		obj.Data[uint64(day)] = fmt.Sprintf("%s|%s|%s|%s|%s", open, high, low, close, qty)
	}
	return nil
}

func get_snapshot(c *Client, req *PushRequest) (obj *SnapShot, err error) {
	sub, unsub := subscribe_datum(c, req)
	c.TSub(sub, unsub)

	obj = &SnapShot{Topic: "snapshot", Data: make(map[string]string)}
	var values []string
	var mdata map[string]string
	var open, high, low, close, qty string

	rds := rdw.Get(0)
	if rds == nil {
		return
	}
	defer rds.Close()

	for _, sid := range sub {
		if name, ok := dbw.Get_symbolname_from_id(sid); ok {
			values, err = redis.Strings(rds.Do("sort", fmt.Sprintf("day.%d", sid), "limit", "0", "1", "desc"))
			if HasError(err) {
				continue
			}
			if len(values) == 0 {
				continue
			}
			lastday := values[0]
			mdata, err = redis.StringMap(rds.Do("hgetall", fmt.Sprintf("dayk.%s.%d", lastday, sid)))
			if len(mdata) > 0 {
				if HasError(err) {
					return
				}
				open, err = StringDivString(mdata["open"])
				if HasError(err) {
					return
				}
				high, err = StringDivString(mdata["high"])
				if HasError(err) {
					return
				}
				low, err = StringDivString(mdata["low"])
				if HasError(err) {
					return
				}
				close, err = StringDivString(mdata["close"])
				if HasError(err) {
					return
				}
				qty, err = StringDivString(mdata["qty"])
				if HasError(err) {
					return
				}
				//obj.Now = time.Unix(time.Now().Unix(), 0).Format("2006-01-02 15:04:05")
				obj.Now = time.Now().Unix()
				obj.Data[name] = fmt.Sprintf("%s|%s|%s|%s|%s|%s", lastday, open, high, low, close, qty)
			}
		}
	}
	return
}

func load_lua() (err error) {
	var c string
	rds := rdw.Get(0)
	if rds == nil {
		return
	}
	defer rds.Close()

	c, err = Decryptlua(factor, script_getposition)
	if HasError(err) {
		return
	}
	GetPosition = redis.NewScript(0, c)

	return
}
