package public

import (
	"time"

	"github.com/garyburd/redigo/redis"
	"github.com/larspensjo/config"
)

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
				_, err = c.Do("auth", pwd)
				if err != nil {
					return nil, err
				}
			}
			if err != nil {
				return nil, err
			}
			_, err = c.Do("select", 0)
			if err != nil {
				return nil, err
			}
			return c, nil
		},
		TestOnBorrow: func(c redis.Conn, t time.Time) error {
			_, err := c.Do("PING")
			if err != nil {
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

func (self *RDSWrapper) Get() redis.Conn {
	return self.pool.Get()
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
