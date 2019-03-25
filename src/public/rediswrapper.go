package public

import (
	"fmt"
	"time"

	"github.com/garyburd/redigo/redis"
	"github.com/larspensjo/config"
)

var ERR_RDS_CONN = NewMyError("redis connector failed: db[%d]", "无法获得redis连接: db[%d]")

type RDSWrapper struct {
	pool    *redis.Pool
	host    string
	timeout time.Duration
	pwd     string
}

func NewRDSWrapper(cfg *config.Config, conf string) *RDSWrapper {
	host, err := cfg.String(conf, "rds_host")
	FatalError(err)
	pwd, err := cfg.String(conf, "rds_password")
	max_conn, err := cfg.Int(conf, "rds_max_conn")
	FatalError(err)
	min_conn, err := cfg.Int(conf, "rds_min_conn")
	FatalError(err)
	idle_timeout, err := cfg.Int(conf, "rds_idle_timeout")
	FatalError(err)

	idle := time.Duration(idle_timeout) * time.Second

	pool := &redis.Pool{
		Wait:        true,
		MaxIdle:     min_conn,
		MaxActive:   max_conn,
		IdleTimeout: idle,
		Dial: func() (redis.Conn, error) {
			c, err := redis.Dial("tcp", host, redis.DialConnectTimeout(idle), redis.DialReadTimeout(idle), redis.DialWriteTimeout(idle))
			if err != nil {
				return nil, err
			}
			if len(pwd) > 0 {
				if _, err = c.Do("auth", pwd); err != nil {
					return nil, err
				}
			}
			return c, nil
		},
		TestOnBorrow: func(c redis.Conn, t time.Time) error {
			if _, err := c.Do("PING"); err != nil {
				return err
			}
			return nil
		},
	}

	return &RDSWrapper{pool, host, idle, pwd}
}

func (self *RDSWrapper) Close() {
	self.pool.Close()
	Println(">>> rdw closed.")
}

func (self *RDSWrapper) Get(dbno int) redis.Conn {
	c := self.pool.Get()
	if _, err := c.Do("select", dbno); HasError(err) {
		c = nil
	}
	return c
}

func (self *RDSWrapper) GetPubSub() *redis.PubSubConn {
	for {
		c, err := redis.Dial("tcp", self.host, redis.DialConnectTimeout(self.timeout))
		if HasError(err) {
			time.Sleep(self.timeout)
		} else {
			if len(self.pwd) > 0 {
				_, err = c.Do("auth", self.pwd)
				if err != nil {
					return nil
				}
			}
			_, err = c.Do("select", 0)
			if HasError(err) {
				time.Sleep(self.timeout)
			} else {
				return &redis.PubSubConn{c}
			}
		}
	}
}

func (self *RDSWrapper) Add_order(ord *OrderRequest, iPrice, iQty uint64) (consign_id uint64, err error) {
	rds := self.Get(1)
	if rds == nil {
		return
	}
	defer rds.Close()

	if consign_id, err = redis.Uint64(rds.Do("INCR", "oid_generator")); HasError(err) {
		return
	}
	if _, err = redis.String(rds.Do("HMSET", fmt.Sprintf("consign.%d.%d", ord.User_id, consign_id),
		"time", time.Now().Unix(),
		"type", ord.Otype,
		"channel", ord.Channel,
		"symbol", ord.Symbol,
		"reference", ord.Reference,
		"price", iPrice,
		"qty", iQty,
		"status", 1,
		"deal_qty", 0,
		"deal_amount", 0)); HasError(err) {
		return
	}

	return
}

func (self *RDSWrapper) CheckConsign(req *OrderRequest, consign_id uint64) (ok bool) {
	rds := self.Get(1)
	if rds == nil {
		return
	}
	defer rds.Close()

	return true
}
