package public

import (
	"database/sql"
	"fmt"
	"sync"

	"github.com/shopspring/decimal"
)

var forexLock sync.RWMutex

func GetFixedForex(db *sql.DB, dbname string) (d map[int32]decimal.Decimal) {
	rows, err := db.Query(fmt.Sprintf("select coin_id,to_base from %s.jys_fix_forex", "byex_db"))
	FatalError(err)
	defer rows.Close()

	d = make(map[int32]decimal.Decimal)

	var coinid int32
	var forex decimal.Decimal
	for rows.Next() {
		if err = rows.Scan(&coinid, &forex); HasError(err) {
			continue
		}
		d[coinid] = forex
	}
	return
}

func GetBaseSymbol(db *sql.DB, datumid int) (d map[uint32]bool) {
	rows, err := db.Query("select id from jys_all_symbol where datum_coin_id=?", datumid)
	FatalError(err)
	defer rows.Close()

	d = make(map[uint32]bool)

	var sid uint32
	for rows.Next() {
		if err = rows.Scan(&sid); HasError(err) {
			continue
		}
		d[sid] = true
	}

	return
}

func (self *DbWrapper) SetForex(coinid int32, forex decimal.Decimal) {
	forexLock.Lock()
	defer forexLock.Unlock()
	self.forex[coinid] = forex
}

func (self *DbWrapper) GetForex(coinid int32) (forex decimal.Decimal, ok bool) {
	forexLock.RLock()
	defer forexLock.RUnlock()
	forex, ok = self.forex[coinid]
	return
}

func (self *DbWrapper) isTransferSymbol(sid uint32) (ok bool) {
	_, ok = self.base_symbols[sid]
	return
}
