package main

import (
	"flag"
	"log"
	. "public"
	"strings"
	"sync"

	_ "github.com/go-sql-driver/mysql"
	"github.com/larspensjo/config"
	zmq "github.com/pebbe/zmq4"
)

var wg sync.WaitGroup

var version = flag.Bool("v", false, "show version")
var inipath = flag.String("i", "./matcher.ini", "path of config ini")
var mode = flag.String("m", "all", "running mode: all/pre/post/order/push")
var conf = flag.String("conf", "default", "configure section")

var context *zmq.Context
var dbw *DbWrapper
var rdw *RDSWrapper
var cfg *config.Config

func main() {
	log.SetFlags(0)
	log.Printf("### matchgo version ###\n")
	log.Printf("Author:    %42s\n", "freesense@126.com")
	log.Printf("Build ver: %42s\n", BuildVer)
	log.Printf("Build date:%42s\n", BuildDate)

	flag.Parse()
	log.SetFlags(log.LstdFlags | log.Lmicroseconds)
	mode := strings.ToLower(*mode)

	if *version {
		return
	}

	var err error

	context, err = zmq.NewContext()
	FatalError(err)
	defer context.Term()

	cfg, err = config.ReadDefault(*inipath)
	FatalError(err)

	Init_public(cfg)

	dbw = NewDbWrapper(cfg, *conf)
	defer dbw.Close()

	rdw = NewRDSWrapper(cfg, *conf)
	defer rdw.Close()

	if mode == "pre" || mode == "all" || mode == "order" {
		wg.Add(1)
		go loop_pre()
	}

	if mode == "post" || mode == "all" || mode == "order" {
		wg.Add(1)
		go loop_post()
	}

	if mode == "push" || mode == "all" {
		wg.Add(1)
		go loop_push()
	}

	wg.Wait()
}
