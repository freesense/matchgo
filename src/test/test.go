package main

import (
	. "public"

	"github.com/larspensjo/config"
)

func main() {
	inipath := "./matcher.ini"
	cfg, err := config.ReadDefault(inipath)
	FatalError(err)
	Init_public(cfg)

	p1, q1 := Uint64DivDec(50950000), uint64(38789203000)
	p2, q2 := Uint64DivDec(50950000), uint64(48810797000)
	a1 := (p1.Mul(Uint64DivDec(q1)))
	Println(a1)
	a2 := (p2.Mul(Uint64DivDec(q2)))
	Println(a2)
	Println(a1.Add(a2))
}
