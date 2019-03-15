package public

import (
	"database/sql"
	"fmt"
	"log"
	"math"
	"path"
	"reflect"
	"runtime"
	"strconv"
	"strings"
	"time"

	"github.com/garyburd/redigo/redis"
	_ "github.com/go-sql-driver/mysql"
	"github.com/larspensjo/config"
	"github.com/shopspring/decimal"
)

var base_coin int // 基准数字货币

func PrintAssets(asset interface{}, format string, x ...interface{}) {
	msg := fmt.Sprintf(format, x...)
	if y, ok := asset.(map[uint32][2]int64); ok {
		for ccy, v := range y {
			if v[0] == 0 && v[1] == 0 {
				continue
			}
			msg += fmt.Sprintf("ccy: %v, balance: %v, frozen: %v\n", ccy, v[0], v[1])
		}
	} else if y, ok := asset.(map[uint32]*[2]int64); ok {
		for ccy, v := range y {
			if v[0] == 0 && v[1] == 0 {
				continue
			}
			msg += fmt.Sprintf("ccy: %v, balance: %v, frozen: %v\n", ccy, v[0], v[1])
		}
	} else {
		Printf("Invalid asset type: %v\n", reflect.TypeOf(asset))
		return
	}
	Printf(msg)
}

//////////////////////////////////////////////////////////////////////////////
type DbWrapper struct {
	dsn            string
	dbname         string
	db             *sql.DB
	symbol_ids     map[string]uint32
	symbol_names   map[string]uint32
	symbol_datums  map[string][]uint32       // 基币下属的全部币对id, snapshot使用
	symbols        map[uint32]string         // symbol_id:symbol_name, 1:USDT/BTC
	forex          map[int32]decimal.Decimal //fixed forex // for byex
	base_symbols   map[uint32]bool
	nofee_accounts map[uint32]bool // 免收手续费账号
}

type HisDbWrapper struct {
	dsn string
	db  *sql.DB
}

func NewDbWrapper(cfg *config.Config, conf string) *DbWrapper {
	db_host, err := cfg.String(conf, "db_host")
	FatalError(err)
	db_user, err := cfg.String(conf, "db_user")
	FatalError(err)
	db_pwd, err := cfg.String(conf, "db_pwd")
	FatalError(err)
	db_name, err := cfg.String(conf, "db_database")
	FatalError(err)
	max_conn, err := cfg.Int(conf, "db_max_conn")
	FatalError(err)
	min_conn, err := cfg.Int(conf, "db_min_conn")
	FatalError(err)
	idle_timeout, err := cfg.Int(conf, "db_idle_timeout")
	FatalError(err)

	dsn := fmt.Sprintf("%s:%s@tcp(%s)/%s?charset=utf8&autocommit=true&multiStatements=true", db_user, db_pwd, db_host, db_name)

	db, err := sql.Open("mysql", dsn)
	FatalError(err)
	db.SetMaxOpenConns(max_conn)
	db.SetMaxIdleConns(min_conn)
	db.SetConnMaxLifetime(time.Duration(idle_timeout) * time.Second)

	sids, snames, sdatums, symbols := Get_all_symbol(db)

	var forex map[int32]decimal.Decimal
	var base_symbols map[uint32]bool
	transfer, err := cfg.Bool(conf, "transfer")
	if err != nil {
		transfer = false
	}
	if transfer {
		base_coin, err = cfg.Int(conf, "base_coin")
		FatalError(err)
		forex = GetFixedForex(db, db_name)
		forex[int32(base_coin)] = decimal.NewFromFloat(1.0)
		base_symbols = GetBaseSymbol(db, base_coin)
	}
	accs := make(map[uint32]bool)
	acc, err := cfg.String("public", "feefree")
	if err == nil {
		tmp := strings.Split(acc, ",")
		for _, susers := range tmp {
			v, err := strconv.Atoi(susers)
			if HasError(err, susers) {
				continue
			}
			accs[uint32(v)] = true
		}
	}

	return &DbWrapper{dsn, db_name, db, sids, snames, sdatums, symbols, forex, base_symbols, accs}
}

func NewHisDbWrapper(cfg *config.Config, conf string) *HisDbWrapper {
	host, err := cfg.String(conf, "his_host")
	FatalError(err)
	user, err := cfg.String(conf, "his_user")
	FatalError(err)
	pwd, err := cfg.String(conf, "his_pwd")
	FatalError(err)
	max_conn, err := cfg.Int(conf, "db_max_conn")
	FatalError(err)
	min_conn, err := cfg.Int(conf, "db_min_conn")
	FatalError(err)
	idle_timeout, err := cfg.Int(conf, "db_idle_timeout")
	FatalError(err)

	dsn := fmt.Sprintf("%s:%s@tcp(%s)/jys_his?charset=utf8&autocommit=true&multiStatements=true", user, pwd, host)
	db, err := sql.Open("mysql", dsn)
	FatalError(err)
	db.SetMaxOpenConns(max_conn)
	db.SetMaxIdleConns(min_conn)
	db.SetConnMaxLifetime(time.Duration(idle_timeout) * time.Second)

	return &HisDbWrapper{dsn, db}
}

func (self *DbWrapper) Close() {
	self.db.Close()
	Println(">>> dbw closed.")
}

func (self *HisDbWrapper) Close() {
	self.db.Close()
	Println(">>> dbw-his closed.")
}

//////////////////////////////////////////////////////////////////////////////
func (self *DbWrapper) Execute(statement []string) (err error) {
	var tx *sql.Tx
	tx, err = self.db.Begin()
	if HasError(err) {
		return
	}
	for _, s := range statement {
		_, err = tx.Exec(s)
		if HasError(err) {
			err = tx.Rollback()
			HasError(err)
			return
		}
	}
	err = tx.Commit()
	HasError(err)
	return
}

//////////////////////////////////////////////////////////////////////////////
func Get_all_symbol(db *sql.DB) (symbolids, symbolnames map[string]uint32, symboldatums map[string][]uint32, symbols map[uint32]string) {
	sql := "select m.id,m.datum_id,m.datum_name,n.trade_id,n.trade_name from (select a.id,b.coin as datum_name,b.id as datum_id from jys_all_symbol a,jys_all_coin b where a.datum_coin_id=b.id) m,(select a.id,b.coin as trade_name,b.id as trade_id from jys_all_symbol a,jys_all_coin b where a.trade_coin_id=b.id) n where m.id=n.id"
	rows, err := db.Query(sql)
	FatalError(err)
	defer rows.Close()

	symbolids = make(map[string]uint32)
	symbolnames = make(map[string]uint32)
	symboldatums = make(map[string][]uint32)
	symbols = make(map[uint32]string)

	var symbol_id uint32
	var datum_id, trade_id uint32
	var datum_name, trade_name string
	for rows.Next() {
		rows.Scan(&symbol_id, &datum_id, &datum_name, &trade_id, &trade_name)
		symbolids[fmt.Sprintf("%d/%d", trade_id, datum_id)] = symbol_id
		symbolnames[fmt.Sprintf("%s/%s", trade_name, datum_name)] = symbol_id
		symboldatums[datum_name] = append(symboldatums[datum_name], symbol_id)
		symbols[symbol_id] = fmt.Sprintf("%s/%s", trade_name, datum_name)
	}
	FatalError(rows.Err())
	Println("Symbol Initialize OK.")
	return
}

func (self *DbWrapper) Get_symbolname_from_id(sid uint32) (string, bool) {
	if name, ok := self.symbols[sid]; ok {
		return name, true
	}
	return "", false
}

func (self *DbWrapper) Get_symbolid_from_id(name string) (uint32, bool) {
	// 从"3/4"格式字符串中获得币对id
	if sid, ok := self.symbol_ids[name]; ok {
		return sid, true
	}
	return 0, false
}

func (self *DbWrapper) Get_symbolid_from_name(name string) (uint32, bool) {
	// 从"EOS/USDT"格式字符串中获得币对id
	if sid, ok := self.symbol_names[name]; ok {
		return sid, true
	}
	return 0, false
}

func (self *DbWrapper) Get_datumids(name string) ([]uint32, bool) {
	// 获得基币下属的全部币对id
	if ls, ok := self.symbol_datums[name]; ok {
		return ls, true
	}
	return nil, false
}

func (self *DbWrapper) ConvSymbolNames(names []string) []uint32 {
	// 将币对名称列表转换成币对id列表，如果币对名称不存在，继续
	ids := make([]uint32, len(names))
	for _, name := range names {
		if id, ok := self.Get_symbolid_from_name(name); ok {
			ids = append(ids, id)
		}
	}
	return ids
}

func (self *DbWrapper) GetPendingOrders() (orders []*Order) {
	rows, err := self.db.Query("select a.consign_id,a.user_id,b.id as symbol,a.consign_type,a.price,a.qty-a.deal_qty from consign a,jys_all_symbol b where a.`status` in (3,4) and a.consign_type!=2 and a.symbol=b.trade_coin_id and a.reference=b.datum_coin_id order by a.consign_id asc")
	if HasError(err) {
		return
	}
	defer rows.Close()

	for rows.Next() {
		ord := &Order{}
		if err = rows.Scan(&ord.Oid, &ord.User_id, &ord.Symbol_id, &ord.Otype, &ord.Price, &ord.Qty); HasError(err) {
			continue
		}
		orders = append(orders, ord)
	}

	return
}

func (self *DbWrapper) Ord_queued(oid uint64) (err error) {
	tx, err := self.db.Begin()
	if HasError(err) {
		return
	}
	defer func() {
		if err != nil {
			tx.Rollback()
		} else {
			tx.Commit()
		}
	}()

	rows, err := tx.Query("select `status` from consign where consign_id=? for update", oid)
	if HasError(err) {
		return
	}
	defer rows.Close()

	var status int32
	if ok := rows.Next(); !ok {
		err = BuildError(true, false, "consign %d not found", oid)
		return
	}
	if err = rows.Scan(&status); HasError(err) {
		return
	}
	rows.Close()

	if status == Accepted {
		_, err = tx.Exec("update consign set `status`=?,update_dt=current_timestamp() where consign_id=?", Queued, oid)
		if HasError(err) {
			return
		}
	}
	return
}

func (self *DbWrapper) Add_cancel(user_id uint32, relate_id uint64) (consign_id uint64, symbol, reference uint32, price uint64, err error) {
	var res sql.Result
	var rows *sql.Rows
	var cnt int64

	if relate_id == 0 { // cancel all
		err = BuildError(true, false, "Cancel all not supported")
		return
		//res, err = self.db.Exec("insert consign(consign_dt,user_id,consign_type,related_id) select current_timestamp(),?,2,0 from dual where (select count(*) from consign where related_id=0 and user_id=? and consign_type=2 and `status` in (1,2,3,4))=0", user_id, user_id)
	}

	// cancel relate_id
	tx, err := self.db.Begin()
	if HasError(err) {
		return
	}
	defer func() {
		if err != nil {
			err = tx.Rollback()
		} else {
			err = tx.Commit()
		}
		HasError(err)
	}()

	// lock order will be cancelled
	rows, err = tx.Query("select consign_id from consign where consign_id=? for update", relate_id)
	if HasError(err) {
		return
	}
	rows.Close()

	res, err = tx.Exec("insert consign(consign_dt,user_id,consign_type,related_id) select current_timestamp(),?,2,? FROM DUAL WHERE (select count(*) from consign where related_id=?)=0", user_id, relate_id, relate_id)
	if HasError(err) {
		return
	}
	if cnt, err = res.RowsAffected(); HasError(err) {
		return
	}
	if cnt == 0 {
		err = BuildError(false, false, "user %d cancel repeat: %d", user_id, relate_id)
		return
	}

	rows, err = tx.Query("select a.consign_id,b.symbol,b.reference,b.price from consign a,(select symbol,reference,price from consign where consign_id=?) b WHERE a.related_id=?", relate_id, relate_id)
	if HasError(err) {
		return
	}
	defer rows.Close()

	rows.Next()
	err = rows.Err()
	if HasError(err) {
		return
	}

	rows.Scan(&consign_id, &symbol, &reference, &price)
	HasError(err)
	return
}

func (self *DbWrapper) Add_order(ord *OrderRequest, iPrice, iQty uint64) (consign_id uint64, err error) {
	res, err := self.db.Exec("INSERT consign(consign_dt,user_id,symbol,reference,consign_type,price,qty) values(current_timestamp(),?,?,?,?,?,?)", ord.User_id, ord.Symbol, ord.Reference, ord.Otype, iPrice, iQty)
	if HasError(err) {
		return
	}
	_consign_id, err := res.LastInsertId()
	if HasError(err) {
		return
	}
	consign_id = uint64(_consign_id)
	return
}

func (self *DbWrapper) CheckConsign(req *OrderRequest, consign_id uint64) (ok bool) {
	// 检查订单合法性，consign_id为订单id
	status := Rejected
	var result sql.Result
	var affect int64
	var frozen uint64
	var tx *sql.Tx
	var rows *sql.Rows
	var err error
	ok = false

	tx, err = self.db.Begin()
	if HasError(err) {
		return
	}

	if req.Otype&0x02 > 0 { // 撤单
		if req.Related_id == 0 { // cancel all
			status = Accepted
		} else { // cancel relate_id
			// 查询被撤订单状态
			rows, err = tx.Query("SELECT IFNULL(`status`,0) FROM consign WHERE consign_id=? FOR UPDATE", req.Related_id)
			if HasError(err) {
				tx.Rollback()
				return
			}
			defer rows.Close()

			if ok = rows.Next(); !ok {
				tx.Rollback()
				Println("Unable to find consign: %d", req.Related_id)
				return
			}

			if err = rows.Err(); HasError(err) {
				tx.Rollback()
				return
			}
			err = rows.Scan(&status)
			if HasError(err) {
				tx.Rollback()
				return
			}
			rows.Close()

			//不可撤销 1.未找到被撤订单 2.订单结束
			if status < Filled {
				status = Accepted
			} else {
				//Printf("Cancel %d failed, status=%d\n", req.Related_id, status)
			}
		}
	} else { // 下单
		/*var existing_cancel_all uint32
		row := tx.QueryRow("select count(*) from consign where user_id=? and consign_type=2 and related_id=0 and `status`!=?", req.User_id, Filled)
		if err = row.Scan(&existing_cancel_all); HasError(err) {
			return
		}

		if existing_cancel_all != 0 {
			err = BuildError(true, false, "cancelling all")
			return
		}*/

		var ccy uint32
		if req.Otype&0x01 > 0 { // 卖出交易币，买入参考币
			ccy = req.Symbol
			frozen, err = StringMulUint64(req.Qty)
			if HasError(err) {
				return
			}
		} else { // 卖出参考币，买入交易币
			ccy = req.Reference
			if req.Otype&0x08 > 0 { // 市价买入
				frozen, err = StringMulUint64(req.Qty)
				if HasError(err) {
					return
				}
			} else { // 其他
				var price, qty decimal.Decimal
				price, err = StringToDec(req.Price)
				if HasError(err) {
					return
				}
				qty, err = StringToDec(req.Qty)
				if HasError(err) {
					return
				}
				frozen = DecToUint64(price.Mul(qty)) + 1 // 安全区1
			}
		}

		if frozen > 0 {
			var balance uint64
			rows, err = tx.Query("select balance from jys_position where user_id=? and ccy=? for update", req.User_id, ccy)
			if HasError(err) {
				return
			}
			defer rows.Close()

			if ok = rows.Next(); !ok {
				balance = 0
			} else if err = rows.Scan(&balance); HasError(err) {
				tx.Rollback()
				return
			}
			rows.Close()

			if balance >= frozen {
				result, err = tx.Exec("update jys_position set balance=balance-?,frozen=frozen+? where user_id=? and ccy=?", frozen, frozen, req.User_id, ccy)
				if HasError(err) {
					tx.Rollback()
					return
				}
				affect, err = result.RowsAffected()
				if HasError(err) {
					tx.Rollback()
					return
				}
				if affect == 1 { // 购买力充足
					status = Accepted
				}
			}
		}
	}

	result, err = tx.Exec("UPDATE consign SET `status`=?,frozen=?,update_dt=current_timestamp() where consign_id=?", status, frozen, consign_id)
	if HasError(err) {
		tx.Rollback()
		return
	}

	affect, err = result.RowsAffected()
	if HasError(err) {
		tx.Rollback()
		return
	}

	if affect == 0 {
		tx.Rollback()
		return
	}

	err = tx.Commit()
	HasError(err)
	return status == Accepted
}

func (self *DbWrapper) Add_tick(obj *Tick) (auser, puser, astatus, pstatus uint32, err error) {
	var tx *sql.Tx
	tx, err = self.db.Begin()
	if HasError(err) {
		return
	}

	_, err = tx.Exec("insert bargain(bargain_dt,consign_id_activated,consign_id_proactive,price,qty) values(current_timestamp(),?,?,?,?)", obj.Oid_activated, obj.Oid_proactive, obj.Price, obj.Qty)
	if HasError(err) {
		tx.Rollback()
		return
	}

	auser, astatus, err = self.inDeal(tx, obj.Oid_activated, obj.Price, obj.Qty)
	if err != nil {
		tx.Rollback()
		return
	}

	puser, pstatus, err = self.inDeal(tx, obj.Oid_proactive, obj.Price, obj.Qty)
	if err != nil {
		tx.Rollback()
		return
	}

	err = tx.Commit()
	HasError(err)
	return
}

func (db *DbWrapper) inDeal(tx *sql.Tx, oid, this_price, this_qty uint64) (usrid, status uint32, err error) {
	rows, err := tx.Query("select user_id,symbol,reference,consign_type,price,qty,deal_qty,deal_amount,`status`,frozen from consign where consign_id=? for update", oid)
	if HasError(err) {
		return
	}
	defer rows.Close()

	rows.Next()
	if err = rows.Err(); HasError(err, oid) {
		return
	}

	var otype, symbol, reference uint32
	var price, qty, deal_qty, deal_amount, frozen uint64
	if err = rows.Scan(&usrid, &symbol, &reference, &otype, &price, &qty, &deal_qty, &deal_amount, &status, &frozen); HasError(err) {
		return
	}
	rows.Close()

	if status == 6 || status == 7 {
		status = Partial_Cancelled
	} else if deal_qty+this_qty >= qty {
		status = Filled
	} else {
		status = Partial_Filled
	}

	var totalDealAmount uint64
	if err = tx.QueryRow("select ifnull(convert(sum(price/?*qty),unsigned),0) from bargain where consign_id_activated=? or consign_id_proactive=?", Dmul.IntPart(), oid, oid).Scan(&totalDealAmount); HasError(err, oid) {
		return
	}

	fee, err := db.inCcyflow(tx, frozen, price, qty, this_price, this_qty, deal_qty, deal_amount, usrid, symbol, reference, otype, status, oid, totalDealAmount)
	if err != nil {
		return
	}

	// update consign
	_, err = tx.Exec("UPDATE consign SET deal_qty=deal_qty+?,deal_amount=?,`status`=?,fee=?,update_dt=current_timestamp() WHERE consign_id=?", this_qty, totalDealAmount, status, fee, oid)
	HasError(err, oid)

	return
}

func (self *DbWrapper) inCcyflow(tx *sql.Tx, frozen /*委托冻结数量*/, price /*委托价格*/, qty /*委托数量*/, this_price /*本次成交价*/, this_qty /*本次成交量*/, deal_qty /*本次之前委托成交量*/, deal_amount /*本次之前委托成交金额*/ uint64, usrid /*用户id*/, symbol /*交易币id*/, reference /*基币id*/, otype /*委托类型*/, status /*本次成交后委托状态*/ uint32, oid /*订单编号*/ uint64, total_amount uint64 /*总成交金额*/) (o_fee /*委托手续费*/ uint64, err error) {
	//decPrice := Uint64DivDec(this_price)
	//this_amount = DecToUint64(decPrice.Mul(Uint64DivDec(this_qty))) // 本次成交金额
	//total_amount := deal_amount + this_amount                       // 委托总成交金额
	total_qty := deal_qty + this_qty // 委托总成交量

	var o_income uint64   // 收入金额
	var o_outcome uint64  // 支出金额，负数
	var o_unfrozen uint64 // 委托解冻数
	var o_inccy uint32    // 收入币种
	var o_outccy uint32   // 支出币种

	if otype&0x01 != 0 { // 卖出解冻交易币
		o_outccy = symbol
	} else { // 买入解冻参考币
		o_outccy = reference
	}

	if status == Cancelled { // 返还委托单冻结
		// 在用户头寸中增加支出币解冻数，减少支出币冻结数
		if _, err = tx.Exec("insert ccyflow(user_id,ccy,occur_dt,occur_balance,occur_frozen,summary,business_id) values(?,?,current_timestamp(),?,-1*?,'CANL',?)", usrid, o_outccy, frozen, frozen, oid); HasError(err) {
			return
		}
	} else if status == Partial_Cancelled || status == Filled { // 结算
		if otype&0x01 != 0 { // 卖出交易币，收入参考币
			o_inccy = reference
			o_income = total_amount
			o_outcome = total_qty
			o_unfrozen = frozen - total_qty
		} else { // 买入交易币，卖出参考币
			o_inccy = symbol
			o_income = total_qty
			o_outcome = total_amount
			o_unfrozen = frozen - total_amount
		}

		if _, ok := self.nofee_accounts[usrid]; !ok {
			var rows *sql.Rows
			var fee decimal.Decimal

			rows, err = tx.Query("SELECT coin_buy_poundage FROM jys_all_coin WHERE id=?", symbol)
			if HasError(err) {
				return
			}
			defer rows.Close()

			if ok = rows.Next(); !ok {
				err = BuildError(true, false, "coin %d feerate not supported", symbol)
				return
			}
			if err = rows.Err(); HasError(err) {
				return
			}

			err = rows.Scan(&fee)
			if err != nil {
				return
			}
			rows.Close()
			o_fee = DecToUint64(fee.Mul(Uint64DivDec(o_income)))
			if o_fee == 0 {
				o_fee = 1
			}

			if otype&0x08 != 0 && this_price != 0 && this_qty != 0 {
				return
			}

			/*if self.base_symbols != nil {
				if reference == uint32(base_coin) {
					// update base coin forex
					self.SetForex(int32(symbol), decPrice)
				}

				var forex_fee, forex_amount decimal.Decimal
				var basefee, baseamount uint64

				if forex_fee, ok = self.GetForex(int32(o_inccy)); !ok {
					Printf("Forex of %d Not Found\n", o_inccy)
				} else if o_inccy == reference {
					forex_amount = forex_fee
				} else if forex_amount, ok = self.GetForex(int32(reference)); !ok {
					Printf("Forex of %d Not Found\n", reference)
				}

				if ok {
					basefee = uint64(forex_fee.Mul(decimal.NewFromFloat(float64(o_fee))).IntPart())
					baseamount = uint64(forex_amount.Mul(decimal.NewFromFloat(float64(total_amount))).IntPart())
					if _, err = tx.Exec("insert jys_bc_fee_flow(create_time,update_time,user_id,coin_id,bc_fee,isreturn,consign_id,bc_amount) values(now(),now(),?,?,?,0,?,?)", usrid, base_coin, basefee, oid, baseamount); HasError(err) {
						return
					}
				}
			}*/
		}

		if o_income != 0 { // 收入币资金流水
			if _, err = tx.Exec("insert ccyflow(user_id,ccy,occur_dt,occur_balance,occur_frozen,summary,business_id) values(?,?,current_timestamp(),?,0,'BB',?)", usrid, o_inccy, o_income, oid); HasError(err) {
				return
			}
		}

		if otype&0x08 != 0 || o_outcome != 0 { // 支出币资金流水
			if _, err = tx.Exec("insert ccyflow(user_id,ccy,occur_dt,occur_balance,occur_frozen,summary,business_id) values(?,?,current_timestamp(),?,-1*?,'BB',?)", usrid, o_outccy, o_unfrozen, frozen, oid); HasError(err) {
				return
			}
		}

		// 手续费资金流水
		if o_fee != 0 {
			_, err = tx.Exec("insert ccyflow(user_id,ccy,occur_dt,occur_balance,summary,business_id) values(?,?,current_timestamp(),-1*?,'BBFE',?)", usrid, o_inccy, o_fee, oid)
			if HasError(err) {
				return
			}
		}
	}

	return
}

func (self *DbWrapper) CancelAll(usrid uint32, push func(consignid uint64, usrid, status uint32)) (err error) {
	tx, err := self.db.Begin()
	if HasError(err) {
		return
	}
	defer func() {
		if err != nil {
			tx.Rollback()
		} else {
			tx.Commit()
		}
	}()

	tname := fmt.Sprintf("orders_%d", usrid)
	sql := fmt.Sprintf(`create table %s(
		consign_id bigint unsigned not null,
		user_id int unsigned not null,
		inccy int unsigned not null,
		fee bigint unsigned not null,
		income bigint unsigned not null,
		outccy int unsigned not null,
		unfrozen bigint not null,
		frozen bigint not null,
		_status int unsigned not null
	)
	`, tname)
	if _, err = tx.Exec(sql); HasError(err) {
		return
	}

	var susrid string
	if usrid != 0 {
		susrid = strconv.FormatUint(uint64(usrid), 10)
	}

	sql = fmt.Sprintf("insert into %s select a.consign_id,a.user_id,a.symbol,convert(a.deal_qty*b.coin_buy_poundage,unsigned),a.deal_qty-convert(a.deal_qty*b.coin_buy_poundage,unsigned),a.reference,a.frozen-a.deal_amount,frozen,case when deal_qty>0 then 6 else 7 end from consign a,jys_all_coin b where a.`status` in (2,3,4) and a.consign_type in (0,8) and a.symbol=b.id", tname)
	if usrid != 0 {
		sql += (" and a.user_id=" + susrid)
	}
	if _, err = tx.Exec(sql); HasError(err) {
		return
	}

	sql = fmt.Sprintf("insert into %s select a.consign_id,a.user_id,a.reference,convert(a.deal_amount*b.coin_buy_poundage,unsigned),a.deal_amount-convert(a.deal_amount*b.coin_buy_poundage,unsigned),a.symbol,a.frozen-a.deal_qty,frozen,case when deal_qty>0 then 6 else 7 end from consign a,jys_all_coin b where a.`status` in (2,3,4) and a.consign_type in (1,9) and a.reference=b.id", tname)
	if usrid != 0 {
		sql += (" and a.user_id=" + susrid)
	}
	if _, err = tx.Exec(sql); HasError(err) {
		return
	}

	if _, err = tx.Exec(fmt.Sprintf("update consign a inner join %s b on a.consign_id=b.consign_id set a.`status`=b._status,a.fee=b.fee,a.update_dt=current_timestamp()", tname)); HasError(err) {
		return
	}

	if _, err = tx.Exec(fmt.Sprintf("update jys_position a inner join (select user_id,inccy,sum(income) as income from %s group by user_id,inccy) b on a.user_id=b.user_id and a.ccy=b.inccy set a.balance=a.balance+b.income", tname)); HasError(err) {
		return
	}

	if _, err = tx.Exec(fmt.Sprintf("update jys_position a inner join (select user_id,outccy,sum(unfrozen) as unfrozen,sum(frozen) as frozen from %s group by user_id,outccy) b on a.user_id=b.user_id and a.ccy=b.outccy set a.balance=a.balance+b.unfrozen,a.frozen=a.frozen-b.frozen", tname)); HasError(err) {
		return
	}

	sql = "update consign set `status`=?,update_dt=current_timestamp() where consign_type=2 and `status` in (1,2,3,4)"
	if usrid != 0 {
		sql += (" and user_id=" + susrid)
	}
	if _, err = tx.Exec(sql, Filled); HasError(err) {
		return
	}

	sql = "update consign set `status`=?,update_dt=current_timestamp() where `status`=1"
	if usrid != 0 {
		sql += (" and user_id=" + susrid)
	}
	if _, err = tx.Exec(sql, Rejected); HasError(err) {
		return
	}

	rows, err := tx.Query(fmt.Sprintf("select user_id,consign_id,_status from %s", tname))
	if HasError(err) {
		return
	}
	defer rows.Close()

	var user_id, status uint32
	var consignid uint64
	for rows.Next() {
		if err := rows.Scan(&consignid, &user_id, &status); HasError(err) {
			continue
		}
		push(consignid, user_id, status)
	}

	_, err = tx.Exec(fmt.Sprintf("drop table %s", tname))
	if HasError(err, tname) {
		return
	}

	return
}

func (self *DbWrapper) On_cancel(obj *Tick) (aid uint64, auser, puser, astatus, pstatus uint32, err error) {
	// 获得撤单委托的consign_id
	rows, err := self.db.Query("SELECT consign_id,user_id FROM consign WHERE related_id=?", obj.Oid_proactive)
	if HasError(err) {
		return
	}
	defer rows.Close()

	has_activate := rows.Next() // may be no activated cancel order
	err = rows.Err()
	if HasError(err) {
		return
	}

	if has_activate {
		err = rows.Scan(&aid, &auser)
		if HasError(err) {
			return
		}
		rows.Close()
	}

	var o_status uint32        // 被撤订单原状态
	var o_cancelled_qty uint64 // 被撤订单当前可撤数量

	tx, err := self.db.Begin()
	if HasError(err) {
		return
	}

	// 被撤订单
	rows, err = tx.Query("SELECT user_id,symbol,reference,consign_type,price,qty,deal_qty,deal_amount,`status`,qty-deal_qty,frozen FROM consign WHERE consign_id=? FOR UPDATE", obj.Oid_proactive)
	if HasError(err) {
		tx.Rollback()
		return
	}
	defer rows.Close()

	var price, qty, deal_qty, deal_amount, frozen uint64
	var otype, symbol, reference uint32

	rows.Next()
	err = rows.Scan(&puser, &symbol, &reference, &otype, &price, &qty, &deal_qty, &deal_amount, &o_status, &o_cancelled_qty, &frozen)
	if HasError(err) {
		tx.Rollback()
		return
	}

	if o_status == Submitted || o_status == Accepted {
		astatus = Filled
		pstatus = Cancelled
		obj.Qty = o_cancelled_qty
	} else if obj.Qty == 0 {
		astatus = Rejected
		pstatus = o_status
	} else {
		astatus = Filled
		if o_status == Partial_Cancelled || o_status == Cancelled {
			Printf("Warning: cancel repeated, uid=%v, oid=%v\n", puser, obj.Oid_proactive)
			tx.Rollback()
			err = nil
			return
		}
		if o_status == Partial_Filled || o_status == Filled {
			pstatus = Partial_Cancelled
		} else {
			pstatus = Cancelled
		}
	}

	rows.Close()
	var fee uint64

	if obj.Qty > 0 && o_cancelled_qty == obj.Qty {
		// 结算被撤订单
		var totalDealAmount uint64
		if err = tx.QueryRow("select ifnull(convert(sum(price/?*qty),unsigned),0) from bargain where consign_id_activated=? or consign_id_proactive=?", Dmul.IntPart(), obj.Oid_proactive, obj.Oid_proactive).Scan(&totalDealAmount); HasError(err, obj.Oid_proactive) {
			tx.Rollback()
			return
		}
		fee, err = self.inCcyflow(tx, frozen, price, qty, 0, 0, deal_qty, deal_amount, puser, symbol, reference, otype, pstatus, obj.Oid_proactive, totalDealAmount)
		if err != nil {
			tx.Rollback()
			return
		}
	}

	// 设置两个订单的最终状态
	if has_activate {
		// 撤单订单
		_, err = tx.Exec("UPDATE consign SET `status`=?,update_dt=current_timestamp() WHERE consign_id=?", astatus, aid)
		if HasError(err) {
			tx.Rollback()
			return
		}
	}
	if obj.Qty > 0 {
		// 被撤订单
		_, err = tx.Exec("UPDATE consign SET `status`=?,fee=?,update_dt=current_timestamp() WHERE consign_id=?", pstatus, fee, obj.Oid_proactive)
		if HasError(err) {
			tx.Rollback()
			return
		}
	}

	err = tx.Commit()
	HasError(err)
	return
}

func (self *DbWrapper) On_market_finished(obj *Tick) (auser uint32, astatus uint32, err error) {
	// 市价买入结算
	// 只修改订单状态，手续费，ccy流水
	// 成交量，成交金额，成交流水由正常的成交tick来驱动
	tx, err := self.db.Begin()
	if HasError(err) {
		return
	}

	rows, err := tx.Query("SELECT user_id,consign_type,symbol,reference,price,qty,deal_qty,deal_amount,`status`,frozen FROM consign WHERE consign_id=? FOR UPDATE", obj.Oid_activated)
	if HasError(err) {
		tx.Rollback()
		return
	}
	defer rows.Close()

	if ok := rows.Next(); !ok {
		tx.Rollback()
		err = BuildError(true, false, "consign %d not found", obj.Oid_activated)
		return
	}

	err = rows.Err()
	if HasError(err) {
		tx.Rollback()
		return
	}

	var symbol, reference, otype uint32
	var price, qty, deal_qty, deal_amount, frozen uint64
	err = rows.Scan(&auser, &otype, &symbol, &reference, &price, &qty, &deal_qty, &deal_amount, &astatus, &frozen)
	if HasError(err) {
		tx.Rollback()
		return
	}
	rows.Close()

	finished := true
	if obj.Activate_type&0x01 == 1 { // 市价卖出，检查deal_qty && qty
		if obj.Qty < qty-deal_qty {
			finished = false
		}
	} else { // 市价买入，检查deal_amount && qty
		if obj.Qty < qty-deal_amount {
			finished = false
		}
	}

	if !finished { // 成交未全部记录，记录撤单值，等候
		tx.Rollback()
		astatus = Wait
		return
	}

	var totalDealAmount uint64
	if err = tx.QueryRow("select ifnull(convert(sum(price/?*qty),unsigned),0) from bargain where consign_id_activated=? or consign_id_proactive=?", Dmul.IntPart(), obj.Oid_activated, obj.Oid_activated).Scan(&totalDealAmount); HasError(err, obj.Oid_activated) {
		tx.Rollback()
		return
	}

	astatus = Filled
	var fee uint64
	fee, err = self.inCcyflow(tx, frozen, price, qty, 0, 0, deal_qty, deal_amount, auser, symbol, reference, otype, astatus, obj.Oid_activated, totalDealAmount)
	if err != nil {
		tx.Rollback()
		return
	}

	_, err = tx.Exec("UPDATE consign SET `status`=?,fee=?,update_dt=current_timestamp() WHERE consign_id=?", astatus, fee, obj.Oid_activated)
	if HasError(err) {
		tx.Rollback()
		return
	}

	err = tx.Commit()
	HasError(err)
	return
}

func (dbw *DbWrapper) Settle(oid uint64) (err error) {
	if oid == 0 {
		return
	}

	rows, err := dbw.db.Query("select user_id,ccy,sum(occur_balance),sum(occur_frozen) from ccyflow where business_id=? group by user_id,ccy order by ccy", oid)
	if HasError(err, oid) {
		return
	}
	defer rows.Close()

	type TmpBuf struct {
		usrid, ccy      uint32
		balance, frozen int64
	}

	var tmparray []*TmpBuf
	for rows.Next() {
		tmp := &TmpBuf{}
		if err = rows.Scan(&tmp.usrid, &tmp.ccy, &tmp.balance, &tmp.frozen); HasError(err, oid) {
			return
		}
		tmparray = append(tmparray, tmp)
	}
	rows.Close()

	tx, err := dbw.db.Begin()
	if HasError(err, oid) {
		return
	}
	defer func() {
		if err != nil {
			err = tx.Rollback()
			HasError(err, oid)
			return
		} else {
			err = tx.Commit()
			HasError(err, oid)
			return
		}
	}()

	var result sql.Result
	var frozen int64
	var affected int64
	for _, v := range tmparray {
		err = tx.QueryRow("select frozen from jys_position where user_id=? and ccy=? for update", v.usrid, v.ccy).Scan(&frozen)
		if err == nil {
			if frozen < int64(math.Abs(float64(v.frozen))) {
				err = BuildError(true, false, "warning: oid=%v, invalid frozen=%v/%v", oid, v.frozen, frozen)
				return
			}
			result, err = tx.Exec("update jys_position set balance=balance+?,frozen=frozen+? where user_id=? and ccy=?", v.balance, v.frozen, v.usrid, v.ccy)
		} else if err == sql.ErrNoRows {
			result, err = tx.Exec("insert jys_position(user_id,ccy,balance,frozen) values(?,?,?,?)", v.usrid, v.ccy, v.balance, v.frozen)
		} else {
			HasError(err, oid, v.usrid, v.ccy)
			return
		}

		/*result, err = tx.Exec("insert jys_position(user_id,ccy,balance,frozen) values(?,?,?,?) on duplicate key update balance=balance+?,frozen=frozen+?", v.usrid, v.ccy, v.balance, v.frozen, v.balance, v.frozen)
		if HasError(err, v.usrid, v.ccy, v.balance, v.frozen, v.balance, v.frozen) {
			return
		}*/
		affected, err = result.RowsAffected()
		if HasError(err, oid) {
			return
		}
		if affected == 0 {
			err = BuildError(true, false, "update position failed, oid=%v", oid)
			return
		}
	}

	return
}

func (d *DbWrapper) getHisdb(cfg *config.Config, conf string) (hisdb *sql.DB, err error) {
	host, err := cfg.String(conf, "his_host")
	if HasError(err) {
		return
	}
	user, err := cfg.String(conf, "his_user")
	if HasError(err) {
		return
	}
	pwd, err := cfg.String(conf, "his_pwd")
	if HasError(err) {
		return
	}
	return sql.Open("mysql", fmt.Sprintf("%s:%s@tcp(%s)/jys_his", user, pwd, host))
}

func (d *DbWrapper) GetTags(cfg *config.Config, conf string) (tags []string) {
	hisdb, err := d.getHisdb(cfg, conf)
	if HasError(err) {
		return
	}
	defer hisdb.Close()
	rows, err := hisdb.Query("select tags from consign group by tags")
	if HasError(err) {
		return
	}
	defer rows.Close()

	var tag string
	for rows.Next() {
		err = rows.Scan(&tag)
		if HasError(err) {
			continue
		}
		tags = append(tags, tag)
	}

	return
}

func (self *DbWrapper) DaySettle(cfg *config.Config, conf string) {
	defer Println("DaySettle finished.")

	hisdb, err := self.getHisdb(cfg, conf)
	if HasError(err) {
		return
	}
	defer hisdb.Close()
	name, err := cfg.String(conf, "db_database")
	if HasError(err) {
		return
	}

	tag := time.Now().Format("20060102T150405")

	sql := "CREATE TABLE if not exists `consign`(`tags` char(15) not null, `consign_id` bigint(20) UNSIGNED NOT NULL,`consign_dt` timestamp NOT NULL,`user_id` int(11) UNSIGNED,`symbol` smallint(6) NULL DEFAULT NULL,`reference` smallint(6) UNSIGNED NULL DEFAULT NULL,`consign_type` int(11) NULL DEFAULT NULL,`price` bigint(20) UNSIGNED NULL DEFAULT NULL,`qty` bigint(20) UNSIGNED NULL DEFAULT NULL,`status` tinyint(4) UNSIGNED NULL,`fee` bigint(20) UNSIGNED NULL DEFAULT NULL,`deal_qty` bigint(20) UNSIGNED NULL DEFAULT 0,`deal_amount` bigint(20) UNSIGNED NULL DEFAULT 0,`related_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0,`update_dt` timestamp NULL,`frozen` bigint(20) UNSIGNED NOT NULL DEFAULT 0,INDEX `ix_consign_user_id` (`user_id`) USING BTREE,INDEX `ix_consign_reference`(`reference`) USING BTREE,INDEX `ix_consign_symbol`(`symbol`) USING BTREE,INDEX `ix_consign_relateid`(`related_id`) USING BTREE)"
	_, err = hisdb.Exec(sql)
	if HasError(err) {
		return
	}

	sql = fmt.Sprintf("create table `jys_position_%s`(`user_id` int(11) NOT NULL,`balance` bigint(20) UNSIGNED NOT NULL,`frozen` bigint(20) NOT NULL,`ccy` smallint(6) NOT NULL,`id` int(11) NULL)", tag)
	_, err = hisdb.Exec(sql)
	if HasError(err) {
		return
	}

	sql = "CREATE TABLE IF NOT EXISTS `bargain`(`tags` char(15) not null, `bargain_id` bigint(20) UNSIGNED NOT NULL,`bargain_dt` timestamp NULL,`consign_id_activated` bigint(20) UNSIGNED NULL DEFAULT NULL,`consign_id_proactive` bigint(20) UNSIGNED NULL DEFAULT NULL,`price` bigint(20) UNSIGNED NULL DEFAULT NULL,`qty` bigint(20) UNSIGNED NULL DEFAULT NULL,INDEX `consign_id_activated`(`consign_id_activated`) USING BTREE,INDEX `consign_id_proactive`(`consign_id_proactive`) USING BTREE,INDEX `ix_bargain_consign_id_activated`(`consign_id_activated`) USING BTREE,INDEX `ix_bargain_consign_id_proactive`(`consign_id_proactive`) USING BTREE)"
	_, err = hisdb.Exec(sql)
	if HasError(err) {
		return
	}

	sql = "CREATE TABLE if not exists `ccyflow`(`tags` char(15) not null, `flow_id` bigint(20) NOT NULL,`user_id` int(11) NULL DEFAULT NULL,`ccy` int(11) NULL DEFAULT NULL,`occur_dt` timestamp NULL,`occur_balance` bigint(20) NULL DEFAULT NULL,`occur_frozen` bigint(20) NULL DEFAULT NULL,`summary` varchar(10) NULL,`business_id` int(11) NULL DEFAULT NULL,INDEX `ix_ccyflow_user_id`(`user_id`) USING BTREE,INDEX `ix_ccyflow_uid_ccy`(`user_id`, `ccy`) USING BTREE)"
	_, err = hisdb.Exec(sql)
	if HasError(err) {
		return
	}

	tx, err := hisdb.Begin()
	if HasError(err) {
		return
	}

	rows, err := tx.Query(fmt.Sprintf("select * from %s.jys_position for update", name))
	if HasError(err) {
		tx.Rollback()
		return
	}
	rows.Close()

	_, err = tx.Exec(fmt.Sprintf("insert into jys_position_%s select user_id,balance,frozen,ccy,id from %s.jys_position", tag, name))
	if HasError(err) {
		tx.Rollback()
		return
	}

	_, err = tx.Exec(fmt.Sprintf("insert into consign select '%s',consign_id,consign_dt,user_id,symbol,reference,consign_type,price,qty,`status`,fee,deal_qty,deal_amount,related_id,update_dt,frozen from %s.consign where `status` in (5,6,7,8)", tag, name))
	if HasError(err) {
		tx.Rollback()
		return
	}

	_, err = tx.Exec(fmt.Sprintf("delete from %s.consign where `status` in (5,6,7,8)", name))
	if HasError(err) {
		tx.Rollback()
		return
	}

	_, err = tx.Exec(fmt.Sprintf("insert into ccyflow select '%s',flow_id,user_id,ccy,occur_dt,occur_balance,occur_frozen,summary,business_id from %s.ccyflow", tag, name))
	if HasError(err) {
		tx.Rollback()
		return
	}

	/////// ccyflow ///////

	if _, err = tx.Exec(fmt.Sprintf("drop table if exists %s.ccyflow_bak", name)); HasError(err) {
		tx.Rollback()
		return
	}
	sql = `CREATE TABLE %s.ccyflow_bak (
		flow_id bigint(20) NOT NULL PRIMARY KEY,
		user_id int(11) DEFAULT NULL,
		ccy varchar(10) DEFAULT NULL,
		occur_dt timestamp NULL DEFAULT NULL,
		occur_balance bigint(20) NOT NULL DEFAULT '0',
		occur_frozen bigint(20) NOT NULL DEFAULT '0',
		summary varchar(10) DEFAULT NULL,
		business_id int(11) DEFAULT NULL
	  )`
	_, err = tx.Exec(fmt.Sprintf(sql, name))
	if HasError(err) {
		tx.Rollback()
		return
	}

	var auto_increment_ccyflow uint64
	row := tx.QueryRow("select auto_increment from information_schema.tables where table_schema=? and table_name=?", name, "ccyflow")
	if err = row.Scan(&auto_increment_ccyflow); HasError(err) {
		return
	}

	_, err = tx.Exec(fmt.Sprintf("insert into %s.ccyflow_bak select flow_id,user_id,ccy,occur_dt,occur_balance,occur_frozen,summary,business_id from %s.ccyflow where business_id not in (select consign_id from consign)", name, name))
	if HasError(err) {
		tx.Rollback()
		return
	}

	_, err = tx.Exec(fmt.Sprintf("drop table %s.ccyflow", name))
	if HasError(err) {
		tx.Rollback()
		return
	}

	// 改名
	_, err = tx.Exec(fmt.Sprintf("alter table %s.ccyflow_bak rename to %s.ccyflow", name, name))
	if HasError(err) {
		tx.Rollback()
		return
	}

	// 设置自增长
	_, err = tx.Exec(fmt.Sprintf("alter table %s.ccyflow change column flow_id flow_id bigint(20) not null auto_increment", name))
	if HasError(err) {
		tx.Rollback()
		return
	}

	// 设置自增长起始值
	_, err = tx.Exec(fmt.Sprintf("alter table %s.ccyflow auto_increment=%d", name, auto_increment_ccyflow))
	if HasError(err) {
		tx.Rollback()
		return
	}

	// 设置索引
	_, err = tx.Exec(fmt.Sprintf("alter table %s.ccyflow add index ix_ccyflow_user_id(user_id),add index ix_ccyflow_uidccy(user_id,ccy), add index ix_ccyflow_bid(business_id)", name))
	if HasError(err) {
		tx.Rollback()
		return
	}

	/////// ccyflow del finished ///////

	_, err = tx.Exec("create table allok (bargain_id bigint not null)")
	if HasError(err) {
		tx.Rollback()
		return
	}

	_, err = tx.Exec(fmt.Sprintf("insert into allok select bargain_id from %s.bargain where consign_id_activated in (select consign_id from consign) and consign_id_proactive in (select consign_id from consign)", name))
	if HasError(err) {
		tx.Rollback()
		return
	}

	_, err = tx.Exec(fmt.Sprintf("insert into bargain select '%s',bargain_id,bargain_dt,consign_id_activated,consign_id_proactive,price,qty from %s.bargain where bargain_id in (select bargain_id from allok)", tag, name))
	if HasError(err) {
		tx.Rollback()
		return
	}

	_, err = tx.Exec("drop table allok")
	if HasError(err) {
		tx.Rollback()
		return
	}

	/////// bargain ////////

	if _, err = tx.Exec(fmt.Sprintf("drop table if exists %s.bargain_bak", name)); HasError(err) {
		tx.Rollback()
		return
	}
	sql = `CREATE TABLE %s.bargain_bak (
		bargain_id bigint(20) unsigned NOT NULL PRIMARY KEY,
		bargain_dt timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
		consign_id_activated bigint(20) unsigned DEFAULT NULL,
		consign_id_proactive bigint(20) unsigned DEFAULT NULL,
		price bigint(20) unsigned DEFAULT NULL,
		qty bigint(20) unsigned DEFAULT NULL
	)`
	_, err = tx.Exec(fmt.Sprintf(sql, name))
	if HasError(err) {
		tx.Rollback()
		return
	}

	var auto_increment_bargain uint64
	row = tx.QueryRow("select auto_increment from information_schema.tables where table_schema=? and table_name=?", name, "bargain")
	if err = row.Scan(&auto_increment_bargain); HasError(err) {
		return
	}

	_, err = tx.Exec(fmt.Sprintf("insert into %s.bargain_bak select bargain_id,bargain_dt,consign_id_activated,consign_id_proactive,price,qty from %s.bargain where bargain_id not in (select bargain_id from bargain)", name, name))
	if HasError(err) {
		tx.Rollback()
		return
	}

	_, err = tx.Exec(fmt.Sprintf("drop table %s.bargain", name))
	if HasError(err) {
		tx.Rollback()
		return
	}

	// 改名
	_, err = tx.Exec(fmt.Sprintf("alter table %s.bargain_bak rename to %s.bargain", name, name))
	if HasError(err) {
		tx.Rollback()
		return
	}

	// 设置自增长
	_, err = tx.Exec(fmt.Sprintf("alter table %s.bargain change column bargain_id bargain_id bigint(20) unsigned not null auto_increment", name))
	if HasError(err) {
		tx.Rollback()
		return
	}

	// 设置自增长起始值
	_, err = tx.Exec(fmt.Sprintf("alter table %s.bargain auto_increment=%d", name, auto_increment_bargain))
	if HasError(err) {
		tx.Rollback()
		return
	}

	// 设置索引
	_, err = tx.Exec(fmt.Sprintf("alter table %s.bargain add index ix_bargain_consign_id_activated(consign_id_activated),add index ix_bargain_consign_id_proactive(consign_id_proactive)", name))
	if HasError(err) {
		tx.Rollback()
		return
	}

	/////// bargain del finished ///////

	sql = fmt.Sprintf("CREATE TABLE if not exists `consign_%s`(`consign_id` bigint(20) UNSIGNED NOT NULL,`consign_dt` timestamp NOT NULL,`user_id` int(11) UNSIGNED,`symbol` smallint(6) NULL DEFAULT NULL,`reference` smallint(6) UNSIGNED NULL DEFAULT NULL,`consign_type` int(11) NULL DEFAULT NULL,`price` bigint(20) UNSIGNED NULL DEFAULT NULL,`qty` bigint(20) UNSIGNED NULL DEFAULT NULL,`status` tinyint(4) UNSIGNED NULL,`fee` bigint(20) UNSIGNED NULL DEFAULT NULL,`deal_qty` bigint(20) UNSIGNED NULL DEFAULT 0,`deal_amount` bigint(20) UNSIGNED NULL DEFAULT 0,`related_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0,`update_dt` timestamp NULL,`frozen` bigint(20) UNSIGNED NOT NULL DEFAULT 0,INDEX `ix_consign_user_id` (`user_id`) USING BTREE,INDEX `ix_consign_reference`(`reference`) USING BTREE,INDEX `ix_consign_symbol`(`symbol`) USING BTREE,INDEX `ix_consign_relateid`(`related_id`) USING BTREE)", tag)
	_, err = tx.Exec(sql)
	if HasError(err) {
		tx.Rollback()
		return
	}

	_, err = tx.Exec(fmt.Sprintf("insert into consign_%s select consign_id,consign_dt,user_id,symbol,reference,consign_type,price,qty,`status`,fee,deal_qty,deal_amount,related_id,update_dt,frozen from %s.consign", tag, name))
	if HasError(err) {
		tx.Rollback()
		return
	}

	err = tx.Commit()
	HasError(err)
	return
}

func (self *DbWrapper) GetPositionInt(usrid uint32) (position map[uint32][2]int64, err error) {
	rows, err := self.db.Query("select a.ccy,a.balance,a.frozen from jys_position a where a.user_id=?", usrid)
	if HasError(err) {
		return
	}
	defer rows.Close()

	position = make(map[uint32][2]int64)
	var ccy uint32
	var balance int64
	var frozen int64
	for rows.Next() {
		if err = rows.Scan(&ccy, &balance, &frozen); HasError(err) {
			return
		}
		if balance != 0 || frozen != 0 {
			position[ccy] = [2]int64{balance, frozen}
		}
	}
	return
}

func (self *DbWrapper) GetPosition(usrid uint32) (position map[string][2]uint64, err error) {
	rows, err := self.db.Query("select b.coin,a.balance,a.frozen from jys_position a,jys_all_coin b where a.user_id=? and a.ccy=b.id", usrid)
	if HasError(err) {
		return
	}
	defer rows.Close()

	position = make(map[string][2]uint64)
	var ccy string
	var balance, frozen uint64
	for rows.Next() {
		if err = rows.Scan(&ccy, &balance, &frozen); HasError(err) {
			return
		}
		if balance != 0 || frozen != 0 {
			position[ccy] = [2]uint64{balance, frozen}
		}
	}
	return
}

////////////////////////////////////////////////////////////////////////////////////////
// 获得用户法币币币账户转账汇总
func (self *DbWrapper) GetTransfer(usrid uint, from, to string) (trans map[uint32]int64, err error) {
	var _from, _to string
	if len(from) > 0 {
		_from = ConvertDT(from)
	}
	if len(to) > 0 {
		_to = ConvertDT(to)
	} else {
		_to = "9999-99-99 99:99:99"
	}
	rows, err := self.db.Query("select b.id,floor(sum(case a.type when '币币到法币' then -100000000*num else 100000000*num end)) as occur_balance from jys_tarnsfer_account a,jys_all_coin b where a.user_id=? and convert_tz(a.utime,'+8:00','+0:00')>=? and convert_tz(a.utime,'+8:00','+0:00')<? and a.coin=b.coin group by a.coin", usrid, _from, _to)
	if HasError(err) {
		return
	}
	defer rows.Close()

	trans = make(map[uint32]int64)
	var ccy uint32
	var occur int64
	for rows.Next() {
		if err = rows.Scan(&ccy, &occur); HasError(err) {
			return
		}
		trans[ccy] = occur
	}

	return
}

// 获得充提币汇总
func (self *DbWrapper) GetRecharge(usrid uint, from, to string) (recharge map[uint32][2]int64, err error) {
	var _from, _to string
	if len(from) > 0 {
		_from = ConvertDT(from)
	}
	if len(to) > 0 {
		_to = ConvertDT(to)
	} else {
		_to = "9999-99-99 99:99:99"
	}
	rows, err := self.db.Query("select b.id,floor(sum(a.occur_balance)) as ob, floor(sum(a.occur_frozen)) as of from (select coin,100000000*amount as occur_balance,0 as occur_frozen from jys_recharge_distill where type='IN' and user_id=? and convert_tz(utime,'+8:00','+0:00')>=? and convert_tz(utime,'+8:00','+0:00')<? union all select coin,case `status` when 'WEB_PROCESSING' then -100000000*out_base_amount when 'COMPLETE' then -100000000*out_base_amount when 'WAIT' then -100000000*out_base_amount else 0 end as occur_balance,case `status` when 'WAIT' then 100000000*out_base_amount else 0 end as occur_frozen from jys_recharge_distill where type='OUT' and user_id=? and convert_tz(utime,'+8:00','+0:00')>=? and convert_tz(utime,'+8:00','+0:00')<?) a,jys_all_coin b where a.coin=b.coin group by a.coin", usrid, _from, _to, usrid, _from, _to)
	if HasError(err) {
		return
	}
	defer rows.Close()

	recharge = make(map[uint32][2]int64)
	var ccy uint32
	var ob, of int64
	for rows.Next() {
		if err = rows.Scan(&ccy, &ob, &of); HasError(err) {
			return
		}
		recharge[ccy] = [2]int64{ob, of}
	}

	return
}

func (self *DbWrapper) GetBonus(usrid uint, from, to string) (bonus map[uint32]int64, err error) {
	var _from, _to string
	if len(from) > 0 {
		_from = ConvertDT(from)
	}
	if len(to) > 0 {
		_to = ConvertDT(to)
	} else {
		_to = "9999-99-99 99:99:99"
	}
	row := self.db.QueryRow("select count(*) from oldbyex.byex_user a,jys_user_info b where b.id=? and (a.email=b.email or a.phone=b.mobile)", usrid)
	var count uint32
	if err = row.Scan(&count); HasError(err) {
		return
	}
	if count != 0 {
		return
	}

	// rows, err := self.db.Query("select b.id,floor(100000000*a.amount) from jys_register_give_bc a,jys_all_coin b where a.user_id=? and a.coin=b.coin and is_return=1 and convert_tz(a.ctime,'+8:00','+0:00')>=? and convert_tz(a.ctime,'+8:00','+0:00')<?", usrid, _from, _to)
	rows, err := self.db.Query("select b.id,floor(100000000*sum(a.amount)) from jys_register_give_bc a,jys_all_coin b where a.user_id=? and a.coin=b.coin and is_return=1 and convert_tz(a.ctime,'+8:00','+0:00')>=? and convert_tz(a.ctime,'+8:00','+0:00')<? group by b.id", usrid, _from, _to)

	if HasError(err) {
		return
	}
	defer rows.Close()

	bonus = make(map[uint32]int64)
	var ccy uint32
	var occur int64
	for rows.Next() {
		if err = rows.Scan(&ccy, &occur); HasError(err) {
			return
		}
		bonus[ccy] = occur
	}

	return
}

func (self *DbWrapper) GetOldByexAsset(usrid uint) (assets map[uint32][2]int64, err error) {
	rows, err := self.db.Query("select d.id as ccy,floor(100000000*c.total),floor(100000000*c.frozen) from oldbyex.byex_user a,jys_user_info b,oldbyex.byex_user_asset c,jys_all_coin d where (a.email=b.email or a.phone=b.mobile) and a.username=c.mem_username and c.coin_name=d.coin and b.id=? order by d.id", usrid)
	if HasError(err) {
		return
	}
	defer rows.Close()

	assets = make(map[uint32][2]int64)
	var ccy uint32
	var balance, frozen int64
	for rows.Next() {
		if err = rows.Scan(&ccy, &balance, &frozen); HasError(err) {
			return
		}
		assets[ccy] = [2]int64{balance, frozen}
	}

	return
}

//////////////////////////////////// 对账 ////////////////////////////////////////////
type _order struct {
	oid, price, qty, fee, dqty, damount, rid, frozen uint64
	uid, otype, status, symbol, refer                uint32
	dt                                               string
}

func GetForexFromHis(db *sql.DB, ccy uint32, dt string) (forex decimal.Decimal, err error) {
	sql := fmt.Sprintf("select consign_id from jys_his.consign where consign_dt=(select max(consign_dt) from jys_his.consign where symbol=%v and reference=%v and consign_dt<'%v') and symbol=%v and reference=%v and `status`=5 limit 0,1", ccy, base_coin, dt, ccy, base_coin)
	row := db.QueryRow(sql)

	var oid uint64
	if err = row.Scan(&oid); err != nil {
		return
	}

	row = db.QueryRow("select price from jys_his.bargain where consign_id_activated=? or consign_id_proactive=?", oid, oid)
	var price uint64
	if err = row.Scan(&price); err != nil {
		return
	}
	forex = Uint64DivDec(price)

	return
}

func (self *DbWrapper) GetUser() (users []uint, err error) {
	rows, err := self.db.Query("select distinct user_id from jys_position order by rand()")
	if HasError(err) {
		return
	}
	defer rows.Close()

	var user uint
	for rows.Next() {
		if err = rows.Scan(&user); HasError(err) {
			continue
		}
		users = append(users, user)
	}

	return
}

////////////////////////////////////////// 对账 /////////////////////////////////////////////////
type CheckOrderResult struct {
	ccy    uint32
	ob, of int64
	ok     bool
}

func CheckOrderWrapper(rdw *RDSWrapper, db *sql.DB, dbname string, ord *_order, checkfix bool, result chan *CheckOrderResult) {
	ccy, ob, of, ok := CheckOrder(rdw, db, dbname, ord, checkfix)
	result <- &CheckOrderResult{ccy, ob, of, ok}
}

func CheckOrder(rdw *RDSWrapper, db *sql.DB, dbname string, ord *_order, checkfix bool) (ccy uint32, ob, of int64, allok bool) {
	/*Printf("Checking UID: %v, OID: %v...\n", ord.uid, ord.oid)
	defer func() {
		msg := "OK"
		if allok == false {
			msg = "FAILED"
		}
		Printf("%s, UID: %v, OID: %v\n", msg, ord.uid, ord.oid)
	}()*/

	var err error
	//begin := time.Now()

	consign_changes := func() (ccy uint32, ob, of int64) {
		if ord.otype&0x01 > 0 { // 卖出
			ccy = ord.symbol
		} else { // 买入
			ccy = ord.refer
		}
		ob = int64(-ord.frozen)
		of = int64(ord.frozen)
		return
	}

	rds := rdw.Get(7)
	if rds == nil {
		return
	}
	found, err := redis.Bool(rds.Do("SISMEMBER", "order_ok", ord.oid))
	rds.Close()
	if HasError(err) {
		return
	}
	if found {
		allok = true
		if ord.status != Rejected {
			ccy, ob, of = consign_changes()
		}
		return
	}

	MyError := func(v ...interface{}) (err error) {
		var msg string
		if len(v) != 0 {
			format, ok := v[0].(string)
			if ok {
				msg = fmt.Sprintf(format, v[1:]...)
			}
		}
		_, file, line, _ := runtime.Caller(1)
		err = fmt.Errorf("[%s] %s:%d UID=%v OID=%v %s", dbname, path.Base(file), line, ord.uid, ord.oid, msg)
		log.Println(err.Error())
		return
	}

	must_nobargain := func() (err error) {
		row := db.QueryRow(fmt.Sprintf("select count(*) from %s.bargain where consign_id_activated=? or consign_id_proactive=?", dbname), ord.oid, ord.oid)
		var count uint32
		if err = row.Scan(&count); HasError(err) {
			return
		}
		if count > 0 {
			err = MyError("成交单应为0条，实为%v条", count)
		}
		return
	}

	must_ccycount := func(expected uint32) (err error) {
		row := db.QueryRow(fmt.Sprintf("select count(*) from %s.ccyflow where business_id=?", dbname), ord.oid)
		var count uint32
		if err = row.Scan(&count); HasError(err) {
			return
		}
		if count != expected {
			err = MyError("%d ccyflow expected %d", expected, count)
		}
		return
	}

	must_nodeal := func() (err error) {
		if ord.fee != 0 || ord.dqty != 0 || ord.damount != 0 {
			err = MyError()
		}
		return
	}

	check_ccycancel := func() (err error) {
		rows, err := db.Query(fmt.Sprintf("select user_id,ccy,occur_balance,occur_frozen,summary from %s.ccyflow where business_id=?", dbname), ord.oid)
		if HasError(err) {
			return
		}
		defer rows.Close()

		var mustccy uint32
		if IsBuy(ord.otype) {
			mustccy = ord.refer
		} else {
			mustccy = ord.symbol
		}

		count := 0
		for rows.Next() {
			count++
			var uid, ccy uint32
			var ob, of int64
			var remark string
			if err = rows.Scan(&uid, &ccy, &ob, &of, &remark); HasError(err) {
				return
			}
			if ccy != mustccy {
				return MyError("冻结币种错误")
			}
			if uid != ord.uid || ob+of != 0 || uint64(ob) != ord.frozen || remark != "CANL" {
				return MyError()
			}
		}

		if count == 0 {
			if !checkfix {
				return MyError("撤单委托无流水")
			} else {
				tag := time.Now().Format("20060102T150405")
				if dbname == "jys_his" {
					if _, err = db.Exec(fmt.Sprintf("insert %s.ccyflow(tags,flow_id,user_id,ccy,occur_balance,occur_frozen,summary,business_id) values(?,?,?,?,?,-1*?,'CANL',?)", dbname), tag, ord.oid, ord.uid, mustccy, ord.frozen, ord.frozen, ord.oid); HasError(err, tag) {
						return
					}
				} else {
					if _, err = db.Exec(fmt.Sprintf("insert %s.ccyflow(flow_id,user_id,ccy,occur_balance,occur_frozen,summary,business_id) values(?,?,?,?,-1*?,'CANL',?)", dbname), ord.oid, ord.uid, mustccy, ord.frozen, ord.frozen, ord.oid); HasError(err) {
						return
					}
				}
			}

		} else if count != 1 {
			return MyError("撤单委托流水数量=%v", count)
		}

		return
	}

	check_bargain := func() (err error) {
		if ord.qty < ord.dqty {
			return MyError("委托数量 < 成交数量")
		}

		queryTags, dbAnother := "", "jys_his"
		if dbname == "jys_his" {
			queryTags = "tags,"
			dbAnother = "byex_db"
		}
		sqlAnother := fmt.Sprintf("select price,qty from %s.bargain where consign_id_activated=? or consign_id_proactive=?", dbAnother)
		rows, err := db.Query(fmt.Sprintf("select %vbargain_id,consign_id_activated,consign_id_proactive,price,qty from %s.bargain where consign_id_activated=? or consign_id_proactive=?", queryTags, dbname), ord.oid, ord.oid)
		if HasError(err) {
			return
		}
		defer rows.Close()

		peer_oids := make(map[uint64]bool)
		var tags string
		var bid, oid1, oid2, price, qty, tqty uint64
		var amount uint64

		needsql := false
		var sqls []string
		//sql := "set autocommit=0;\n"
		for rows.Next() {
			if dbname == "jys_his" {
				if err = rows.Scan(&tags, &bid, &oid1, &oid2, &price, &qty); HasError(err) {
					return
				}
			} else {
				if err = rows.Scan(&bid, &oid1, &oid2, &price, &qty); HasError(err) {
					return
				}
			}
			peer_oid := oid2
			if oid2 == ord.oid {
				peer_oid = oid1
			}
			if _, ok := peer_oids[peer_oid]; ok {
				needsql = true
				sqls = append(sqls, fmt.Sprintf("delete from %s.bargain where tags='%v' and bargain_id=%v;\n", dbname, tags, bid))
				//return MyError("重复的成交单: %v", peer_oid)
			} else {
				peer_oids[peer_oid] = true
				tqty += qty
				amount += DecToUint64(Uint64DivDec(price).Mul(Uint64DivDec(qty)))
			}
		}

		if tqty != ord.dqty {
			var anotherTotalQty, this_price, this_qty uint64
			rows, err = db.Query(sqlAnother, ord.oid, ord.oid)
			if HasError(err) {
				return
			}
			defer rows.Close()
			for rows.Next() {
				if err = rows.Scan(&this_price, &this_qty); HasError(err) {
					return
				}
				anotherTotalQty += this_qty
			}
			if anotherTotalQty+tqty != ord.dqty {
				return MyError("成交量不匹配，委托单成交量：%v，成交单成交量：%v", ord.dqty, tqty)
			}
		}

		if amount != ord.damount {
			var anotherTotalQty, this_price, this_qty uint64
			rows, err = db.Query(sqlAnother, ord.oid, ord.oid)
			if HasError(err) {
				return
			}
			defer rows.Close()
			for rows.Next() {
				if err = rows.Scan(&this_price, &this_qty); HasError(err) {
					return
				}
				anotherTotalQty += DecToUint64(Uint64DivDec(this_price).Mul(Uint64DivDec(this_qty)))
			}
			if anotherTotalQty+amount != ord.damount {
				return MyError("成交金额不匹配，委托单成交金额：%v，成交单成交金额：%v", ord.damount, amount)
			}
		}

		if checkfix && needsql {
			var tx *sql.Tx
			tx, err = db.Begin()
			if HasError(err) {
				return
			}
			for _, sql := range sqls {
				if _, err = tx.Exec(sql); HasError(err) {
					return
				}
			}
			if err = tx.Commit(); HasError(err) {
				return
			}
		}

		return
	}

	check_ccyflow := func() (err error) {
		var inccy, outccy, uid, ccy, ccyCount, bbCount uint32
		var ob, of int64
		var inamount, outamount uint64
		var summary string
		if IsBuy(ord.otype) {
			inccy, outccy, inamount, outamount = ord.symbol, ord.refer, ord.dqty, ord.damount
		} else {
			outccy, inccy, inamount, outamount = ord.symbol, ord.refer, ord.damount, ord.dqty
		}

		rows, err := db.Query(fmt.Sprintf("select user_id,ccy,ifnull(occur_balance,0),ifnull(occur_frozen,0),summary from %s.ccyflow where business_id=? and user_id=?", dbname), ord.oid, ord.uid)
		if HasError(err) {
			return
		}
		defer rows.Close()

		for rows.Next() {
			ccyCount++
			if err = rows.Scan(&uid, &ccy, &ob, &of, &summary); HasError(err) {
				return
			}
			/*if uid != ord.uid {
				return MyError("uid[%v] != ord.uid[%v]", uid, ord.uid)
			}*/
			if summary == "BBFE" && (ccy != inccy || -1*ob != int64(ord.fee)) {
				if !checkfix {
					return MyError("交易手续费收取错误")
				}
				if _, err = db.Exec(fmt.Sprintf("update `%s`.`consign` set fee=? where consign_id=?", dbname), -1*ob, ord.oid); HasError(err) {
					return
				}
			}
			if summary == "BB" {
				bbCount++
				if of == 0 && (ccy != inccy || int64(inamount) != ob) {
					return MyError("收入流水错误, %v!=%v or %v!=%v", ccy, inccy, inamount, ob)
				}
				if of != 0 && (ccy != outccy || -1*int64(ord.frozen) != of || ob+of != -1*int64(outamount)) {
					return MyError("支出流水错误, %v!=%v, frozen=%v, ob=%v, of=%v, outamount=%v", ccy, outccy, ord.frozen, ob, of, outamount)
				}
			}
		}

		if ord.otype != 2 {
			if ccyCount == 0 {
				tag := time.Now().Format("20060102T150405")
				/*forex := decimal.NewFromFloat(1.0)
				if inccy == uint32(base_coin) {
					forex = forex.Div(decimal.NewFromFloat(float64(ord.damount) / float64(ord.dqty)))
				} else if outccy == uint32(base_coin) {
				} else {
					forex, err = GetForexFromHis(db, inccy, ord.dt)
					if err != nil {
						forexes := GetFixedForex(db, "byex_db")
						var ok bool
						if forex, ok = forexes[int32(inccy)]; !ok {
							return MyError("取不到币种 %v 的汇率", inccy)
						}
					}
				}*/
				//basefee := uint64(forex.Mul(decimal.NewFromFloat(float64(ord.fee))).IntPart())
				//baseamount := uint64(forex.Mul(decimal.NewFromFloat(float64(ord.damount))).IntPart())
				var sqls []string
				//sql := "set autocommit=0;\n"
				//sqls = append(sqls, fmt.Sprintf("insert byex_db.jys_bc_fee_flow(create_time,update_time,user_id,coin_id,bc_fee,isreturn,consign_id,bc_amount) values(now(),now(),%v,%v,%v,0,%v,%v);", ord.uid, inccy, basefee, ord.oid, baseamount))
				sqls = append(sqls, fmt.Sprintf("insert ccyflow(tags,flow_id,user_id,ccy,occur_dt,occur_balance,occur_frozen,summary,business_id) values('%v',%v,%v,%v,current_timestamp(),%v,0,'BB',%v);", tag, ord.oid, ord.uid, inccy, inamount, ord.oid))
				sqls = append(sqls, fmt.Sprintf("insert ccyflow(tags,flow_id,user_id,ccy,occur_dt,occur_balance,occur_frozen,summary,business_id) values('%v',%v,%v,%v,current_timestamp(),%v,-1*%v,'BB',%v);", tag, ord.oid+1, ord.uid, outccy, ord.frozen-outamount, ord.frozen, ord.oid))
				sqls = append(sqls, fmt.Sprintf("insert ccyflow(tags,flow_id,user_id,ccy,occur_dt,occur_balance,summary,business_id) values('%v',%v,%v,%v,current_timestamp(),-1*%v,'BBFE',%v);", tag, ord.oid+2, ord.uid, inccy, ord.fee, ord.oid))

				if !checkfix {
					return MyError("正常委托流水数量为0")
				} else {
					var tx *sql.Tx
					tx, err = db.Begin()
					if HasError(err) {
						return
					}
					for _, sql := range sqls {
						if _, err = tx.Exec(sql); HasError(err) {
							return
						}
					}
					if err = tx.Commit(); HasError(err) {
						return
					}
				}
			}
		} else if ccyCount != 0 {
			return MyError("撤单委托不应有流水，实为%v", ccyCount)
		}
		return
	}

	allok = true
	//var err error
	switch ord.status {
	case Rejected:
		if err = must_nobargain(); err != nil {
			allok = false
		}
		if err = must_ccycount(0); err != nil {
			allok = false
		}
	case Cancelled:
		if err = must_nobargain(); err != nil {
			allok = false
		}
		if err = check_ccycancel(); err != nil {
			allok = false
		}
	case Wait:
		err = MyError()
		allok = false
	case Submitted:
		if ord.frozen != 0 {
			err = MyError()
			allok = false
		}
		if err = must_nodeal(); err != nil {
			allok = false
		}
		if err = must_nobargain(); err != nil {
			allok = false
		}
		if err = must_ccycount(0); err != nil {
			allok = false
		}
	case Accepted:
		fallthrough
	case Queued:
		if err = must_nodeal(); err != nil {
			allok = false
		}
		if err = must_nobargain(); err != nil {
			allok = false
		}
		if err = must_ccycount(0); err != nil {
			allok = false
		}
	case Partial_Filled:
		if err = must_ccycount(0); err != nil {
			allok = false
		}
	default: // Filled, Partial_Cancelled
		if err = check_bargain(); err != nil {
			allok = false
		}
		if err = check_ccyflow(); err != nil {
			allok = false
		}
	}

	if ord.status != Rejected {
		ccy, ob, of = consign_changes()
	}

	if allok {
		rds := rdw.Get(7)
		if rds == nil {
			return
		}
		defer rds.Close()
		if _, err := rds.Do("SADD", "order_ok", ord.oid); HasError(err) {
			return
		}
	}
	return
}

func (his *HisDbWrapper) CheckAccount(rdw *RDSWrapper, usrid uint, checkfix bool) (allok bool, total int, changes map[uint32][2]int64) {
	return CheckAccount(rdw, his.db, "jys_his", usrid, checkfix)
}

func (cur *DbWrapper) CheckAccount(rdw *RDSWrapper, usrid uint, checkfix bool) (allok bool, total int, changes map[uint32][2]int64) {
	return CheckAccount(rdw, cur.db, cur.dbname, usrid, checkfix)
}

func (his *HisDbWrapper) GetOccurSum(usrid uint) (changes map[uint32][2]int64) {
	return GetOccurSum(his.db, "jys_his", usrid)
}

func (cur *DbWrapper) GetOccurSum(usrid uint) (changes map[uint32][2]int64) {
	return GetOccurSum(cur.db, cur.dbname, usrid)
}

func GetOccurSum(db *sql.DB, dbname string, usrid uint) (changes map[uint32][2]int64) {
	rows, err := db.Query(fmt.Sprintf("select ccy,sum(occur_balance),sum(occur_frozen) from %s.ccyflow where user_id=? group by ccy", dbname), usrid)
	if HasError(err) {
		return
	}

	changes = make(map[uint32][2]int64)
	var ccy uint32
	var ob, of int64
	for rows.Next() {
		if err = rows.Scan(&ccy, &ob, &of); HasError(err) {
			return
		}
		changes[ccy] = [2]int64{ob, of}
	}

	return
}

func CheckAccount(rdw *RDSWrapper, db *sql.DB, dbname string, usrid uint, checkfix bool) (allok bool, total int, changes map[uint32][2]int64) {
	allok = true
	changes = make(map[uint32][2]int64)
	results := make(chan *CheckOrderResult)

	var rows *sql.Rows
	var err error

	sql := "select consign_dt,consign_id,user_id,consign_type,ifnull(price,0),ifnull(qty,0),`status`,ifnull(fee,0),deal_qty,deal_amount,related_id,frozen,ifnull(symbol,0),ifnull(reference,0) from %s.consign where user_id=?"
	if dbname == "jys_his" {
		sql += " order by tags,consign_dt asc"
	} else {
		sql += " order by consign_dt asc"
	}

	sql = fmt.Sprintf(sql, dbname)
	rows, err = db.Query(sql, usrid)
	if HasError(err) {
		allok = false
		return
	}
	defer rows.Close()

	received := 0
	for rows.Next() {
		ord := &_order{}
		err = rows.Scan(&ord.dt, &ord.oid, &ord.uid, &ord.otype, &ord.price, &ord.qty, &ord.status, &ord.fee, &ord.dqty, &ord.damount, &ord.rid, &ord.frozen, &ord.symbol, &ord.refer)
		if HasError(err) {
			allok = false
			return
		}
		total++
		go CheckOrderWrapper(rdw, db, dbname, ord, checkfix, results)
	}

	if total != 0 {
		for {
			order := <-results
			received++

			if order.ok == false {
				allok = false
			} else if order.ccy == 0 { // quit for
			} else if e, ok := changes[order.ccy]; !ok {
				changes[order.ccy] = [2]int64{order.ob, order.of}
			} else {
				changes[order.ccy] = [2]int64{e[0] + order.ob, e[1] + order.of}
			}

			if received == total {
				break
			}
		}
	}

	return
}

// 在历史库中检查两个日结标签之间的资产是否正常
func (his *HisDbWrapper) CheckTag(single bool, usrid uint, fromtag, totag string, trans map[uint32]int64, recharge map[uint32][2]int64, bonus map[uint32]int64) (err error) {
	var ccy uint32
	var balance, frozen int64

	fromAsset := make(map[uint32]*[2]int64)
	toAsset := make(map[uint32][2]int64)
	changes := make(map[uint32]*[2]int64)

	// fromAsset
	rows, err := his.db.Query(fmt.Sprintf("select ccy,balance,frozen from jys_position_%s where user_id=?", fromtag), usrid)
	if HasError(err) {
		return err
	}
	for rows.Next() {
		if err = rows.Scan(&ccy, &balance, &frozen); HasError(err) {
			return
		}
		fromAsset[ccy] = &[2]int64{balance, frozen}
	}
	rows.Close()

	// toAsset
	rows, err = his.db.Query(fmt.Sprintf("select ccy,balance,frozen from jys_position_%s where user_id=?", totag), usrid)
	if HasError(err) {
		return err
	}
	for rows.Next() {
		if err = rows.Scan(&ccy, &balance, &frozen); HasError(err) {
			return err
		}
		toAsset[ccy] = [2]int64{balance, frozen}
	}
	rows.Close()

	// all consign of user and tag
	rows, err = his.db.Query("select consign_dt,consign_id,user_id,consign_type,ifnull(price,0),ifnull(qty,0),`status`,ifnull(fee,0),deal_qty,deal_amount,related_id,frozen,ifnull(symbol,0),ifnull(reference,0) from consign where user_id=? and tags=? order by consign_dt", usrid, totag)
	if HasError(err) {
		return err
	}
	ch := make(chan int)
	var reqCount, rspCount uint64
	for rows.Next() {
		ord := &_order{}
		err = rows.Scan(&ord.dt, &ord.oid, &ord.uid, &ord.otype, &ord.price, &ord.qty, &ord.status, &ord.fee, &ord.dqty, &ord.damount, &ord.rid, &ord.frozen, &ord.symbol, &ord.refer)
		if HasError(err) {
			return
		}
		reqCount++
		go his.CheckOrder(ord, ch)
	}

	allok := true
	if reqCount > 0 {
		for {
			x := <-ch
			if allok && x != 0 {
				allok = false
			}
			rspCount++
			if rspCount == reqCount {
				break
			}
		}
	}

	// finally, caculate user's asset changes
	if allok {
		params := fmt.Sprintf("usrid: %v, from %v, to %v", usrid, fromtag, totag)
		// 从上次日结以来的资金流水
		rows, err = his.db.Query("select ccy,sum(occur_balance),sum(occur_frozen) from ccyflow where user_id=? and tags=? group by ccy", usrid, totag)
		if HasError(err, params) {
			return
		}
		for rows.Next() {
			if err = rows.Scan(&ccy, &balance, &frozen); HasError(err) {
				return
			}
			if chg, ok := changes[ccy]; ok {
				chg[0] += balance
				chg[1] += frozen
			} else {
				changes[ccy] = &[2]int64{balance, frozen}
			}
		}
		rows.Close()

		var symbol, reference, otype uint32

		// 从上次日结以来的已结束的新委托单的冻结
		rows, err = his.db.Query(fmt.Sprintf("select ifnull(symbol,0),ifnull(reference,0),consign_type,frozen from consign where consign_id>(select ifnull(max(consign_id),0) from consign_%s where user_id=?) and user_id=? and tags=?", fromtag), usrid, usrid, totag)
		if HasError(err, params) {
			return
		}
		for rows.Next() {
			if err = rows.Scan(&symbol, &reference, &otype, &frozen); HasError(err) {
				return
			}
			if otype&0x01 > 0 {
				ccy = symbol
			} else {
				ccy = reference
			}
			if ccy == 0 {
				continue
			}
			if chg, ok := changes[ccy]; ok {
				chg[0] -= frozen
				chg[1] += frozen
			} else {
				changes[ccy] = &[2]int64{-1 * frozen, frozen}
			}
		}
		rows.Close()

		// 从上次日结以来的未结束的新委托单的冻结
		rows, err = his.db.Query(fmt.Sprintf("select ifnull(symbol,0),ifnull(reference,0),consign_type,frozen from consign_%s where consign_id>(select ifnull(max(consign_id),0) from consign_%s where user_id=?) and user_id=?", totag, fromtag), usrid, usrid)
		if HasError(err, params) {
			return
		}
		for rows.Next() {
			if err = rows.Scan(&symbol, &reference, &otype, &frozen); HasError(err) {
				return
			}
			if otype&0x1 > 0 {
				ccy = symbol
			} else {
				ccy = reference
			}
			if ccy == 0 {
				continue
			}
			if chg, ok := changes[ccy]; ok {
				chg[0] -= frozen
				chg[1] += frozen
			} else {
				changes[ccy] = &[2]int64{-1 * frozen, frozen}
			}
		}
		rows.Close()

		if single {
			PrintAssets(fromAsset, "用户 %v 期初资产\n", usrid)
			PrintAssets(toAsset, "用户 %v 期末资产\n", usrid)
			Printf("用户%v, trans: %v\n", usrid, trans)
			Printf("用户%v, bonus: %v\n", usrid, bonus)
			Printf("用户%v, recharge: %v\n", usrid, recharge)
		}

		for ccy, v := range fromAsset {
			if x, ok := trans[ccy]; ok {
				v[0] += x
			}
			if x, ok := bonus[ccy]; ok {
				v[0] += x
			}
			if x, ok := recharge[ccy]; ok {
				v[0] += x[0]
				v[1] += x[1]
			}
			if x, ok := changes[ccy]; ok {
				v[0] += x[0]
				v[1] += x[1]
			}
		}

		for ccy, v := range fromAsset {
			if x, ok := toAsset[ccy]; ok {
				if v[0] != x[0] || v[1] != x[1] {
					Printf("用户%v, 币种%v, 可用%v != 当前%v, 冻结%v != 当前%v\n", usrid, ccy, v[0], x[0], v[1], x[1])
				}
			}
		}
		if single {
			Printf("用户%v对账完成\n", usrid)
		}
	}

	return
}

func (his *HisDbWrapper) CheckOrder(ord *_order, ch chan int) {
	var err error
	allok := true
	defer func() {
		if !allok {
			ch <- -1
		} else {
			ch <- 0
		}
	}()

	MyError := func(v ...interface{}) (err error) {
		var msg string
		if len(v) != 0 {
			format, ok := v[0].(string)
			if ok {
				msg = fmt.Sprintf(format, v[1:]...)
			}
		}
		_, file, line, _ := runtime.Caller(1)
		err = fmt.Errorf("[jys_his] %s:%d UID=%v OID=%v %s", path.Base(file), line, ord.uid, ord.oid, msg)
		log.Println(err.Error())
		return
	}

	must_nobargain := func() (err error) {
		row := his.db.QueryRow(fmt.Sprintf("select count(*) from bargain where consign_id_activated=? or consign_id_proactive=?"), ord.oid, ord.oid)
		var count uint32
		if err = row.Scan(&count); HasError(err) {
			return
		}
		if count > 0 {
			err = MyError("成交单应为0笔，实为%v", count)
		}
		return
	}

	must_ccycount := func(expected uint32) (err error) {
		row := his.db.QueryRow(fmt.Sprintf("select count(*) from ccyflow where business_id=?"), ord.oid)
		var count uint32
		if err = row.Scan(&count); HasError(err) {
			return
		}
		if count != expected {
			err = MyError("%d ccyflow expected %d", expected, count)
		}
		return
	}

	must_nodeal := func() (err error) {
		if ord.fee != 0 || ord.dqty != 0 || ord.damount != 0 {
			err = MyError("deal qty must be zero: %d, %d, %d", ord.fee, ord.dqty, ord.damount)
		}
		return
	}

	check_ccycancel := func() (err error) {
		rows, err := his.db.Query(fmt.Sprintf("select user_id,ccy,occur_balance,occur_frozen,summary from ccyflow where business_id=?"), ord.oid)
		if HasError(err) {
			return
		}
		defer rows.Close()

		var mustccy uint32
		if IsBuy(ord.otype) {
			mustccy = ord.refer
		} else {
			mustccy = ord.symbol
		}

		count := 0
		for rows.Next() {
			count++
			var uid, ccy uint32
			var ob, of int64
			var remark string
			if err = rows.Scan(&uid, &ccy, &ob, &of, &remark); HasError(err) {
				return
			}
			if ccy != mustccy {
				return MyError("解冻币种错误")
			}
			if uid != ord.uid || ob+of != 0 || uint64(ob) != ord.frozen || remark != "CANL" {
				return MyError("解冻数据错误")
			}
		}

		if count != 1 {
			return MyError("撤单委托流水数量应为1，实为%v", count)
		}

		return
	}

	check_bargain := func() (err error) {
		if ord.qty < ord.dqty {
			return MyError("委托数量 < 成交数量")
		}

		rows, err := his.db.Query(fmt.Sprintf("select consign_id_activated,consign_id_proactive from bargain where consign_id_activated=? or consign_id_proactive=?"), ord.oid, ord.oid)
		if HasError(err) {
			return
		}
		defer rows.Close()

		peer_oids := make(map[uint64]bool)
		var oid1, oid2, amount, tqty uint64

		for rows.Next() {
			if err = rows.Scan(&oid1, &oid2); HasError(err) {
				return
			}
			peer_oid := oid2
			if oid2 == ord.oid {
				peer_oid = oid1
			}
			if _, ok := peer_oids[peer_oid]; ok {
				return MyError("重复的成交单: %v", peer_oid)
			} /* else {
				peer_oids[peer_oid] = true
				tqty += qty
				amount += DecToUint64(Uint64DivDec(price).Mul(Uint64DivDec(qty)))
			}*/
		}

		if err = his.db.QueryRow("select ifnull(sum(ifnull(qty,0)),0),ifnull(convert(sum(price/?*qty),unsigned),0) from (select price,qty from bargain where consign_id_activated=? or consign_id_proactive=? union all select price,qty from byex_db.bargain where consign_id_activated=? or consign_id_proactive=?) a", Dmul.IntPart(), ord.oid, ord.oid, ord.oid, ord.oid).Scan(&tqty, &amount); HasError(err, ord.oid) {
			return
		}

		if tqty != ord.dqty {
			return MyError("成交量不匹配，委托单成交量：%v，成交单成交量：%v", ord.dqty, tqty)
		}

		if amount != ord.damount {
			return MyError("成交金额不匹配，委托单成交金额：%v，成交单成交金额：%v", ord.damount, amount)
		}

		return
	}

	check_ccyflow := func() (err error) {
		var inccy, outccy, uid, ccy, ccyCount, bbCount uint32
		var ob, of int64
		var inamount, outamount uint64
		var summary string
		if IsBuy(ord.otype) {
			inccy, outccy, inamount, outamount = ord.symbol, ord.refer, ord.dqty, ord.damount
		} else {
			outccy, inccy, inamount, outamount = ord.symbol, ord.refer, ord.damount, ord.dqty
		}

		rows, err := his.db.Query("select user_id,ccy,ifnull(occur_balance,0),ifnull(occur_frozen,0),summary from ccyflow where business_id=? and user_id=?", ord.oid, ord.uid)
		if HasError(err) {
			return
		}
		defer rows.Close()

		for rows.Next() {
			ccyCount++
			if err = rows.Scan(&uid, &ccy, &ob, &of, &summary); HasError(err) {
				return
			}
			if uid != ord.uid {
				return MyError("uid[%v] != ord.uid[%v]", uid, ord.uid)
			}
			if summary == "BBFE" && (ccy != inccy || -1*ob != int64(ord.fee)) {
				return MyError("交易手续费收取错误，应收币种%v，实收币种%v，流水手续费%v，委托单手续费%v", inccy, ccy, -ob, ord.fee)
			}
			if summary == "BB" {
				bbCount++
				if of == 0 && (ccy != inccy || int64(inamount) != ob) {
					return MyError("收入流水错误, %v!=%v or %v!=%v", ccy, inccy, inamount, ob)
				}
				if of != 0 && (ccy != outccy || -1*int64(ord.frozen) != of || ob+of != -1*int64(outamount)) {
					return MyError("支出流水错误, %v!=%v, frozen=%v, ob=%v, of=%v, outamount=%v", ccy, outccy, ord.frozen, ob, of, outamount)
				}
			}
		}

		if ord.otype != 2 {
			if ccyCount == 0 {
				return MyError("正常委托成交流水不可为0")
			}
		} else if ccyCount != 0 {
			return MyError("撤单委托不应有流水，流水数量=%v", ccyCount)
		}
		return
	}

	switch ord.status {
	case Rejected:
		if err = must_nobargain(); err == nil {
			allok = false
		}
		if err = must_ccycount(0); err != nil {
			allok = false
		}
	case Cancelled:
		if err = must_nobargain(); err != nil {
			allok = false
		}
		if err = check_ccycancel(); err != nil {
			allok = false
		}
	case Wait:
		err = MyError("不支持该委托状态：Wait")
		allok = false
	case Submitted:
		if ord.frozen != 0 {
			err = MyError("冻结数必须为0")
			allok = false
		}
		if err = must_nodeal(); err != nil {
			allok = false
		}
		if err = must_nobargain(); err != nil {
			allok = false
		}
		if err = must_ccycount(0); err != nil {
			allok = false
		}
	case Accepted:
		fallthrough
	case Queued:
		if err = must_nodeal(); err != nil {
			allok = false
		}
		if err = must_nobargain(); err != nil {
			allok = false
		}
		if err = must_ccycount(0); err != nil {
			allok = false
		}
	case Partial_Filled:
		if err = must_ccycount(0); err != nil {
			allok = false
		}
	default: // Filled, Partial_Cancelled
		if err = check_bargain(); err != nil {
			allok = false
		}
		if err = check_ccyflow(); err != nil {
			allok = false
		}
	}
}

/*func (cur *DbWrapper) CheckFee() (err error) {
	statement := "update jys_bc_fee_flow a,(select m.coin_id,m.coin,convert(m.to_base*n.deal_amount,unsigned) as bc_amount,n.consign_id from jys_fix_forex m,jys_his.consign n where m.coin_id=n.reference and n.deal_amount!=0 and n.consign_id>=%v and n.consign_id<=%v) b set a.bc_amount=b.bc_amount where a.consign_id=b.consign_id"

	var res sql.Result
	var idx, end uint64
	var affected int64
	finish := false
	for {
		end = idx + 999
		if end > 14676443 {
			end = 14676443
			finish = true
		}
		res, err = cur.db.Exec(fmt.Sprintf(statement, idx, end))
		if HasError(err) {
			return
		}
		affected, err = res.RowsAffected()
		if HasError(err) {
			break
		}
		idx += 1000
		Printf("update %v done, affected: %v\n", idx, affected)
		if finish {
			break
		}
	}

	return
}*/

// 资金变动接口
func (self *DbWrapper) OnCcyflow(req *OrderRequest) (err error) {
	// related_id: business_id
	// Price: balance
	// Qty: frozen
	// Symbol: ccy
	// Reference: summary
	var balance, frozen uint64
	balance, err = strconv.ParseUint(req.Price, 10, 64)
	if HasError(err) {
		return
	}
	frozen, err = strconv.ParseUint(req.Qty, 10, 64)
	if HasError(err) {
		return
	}

	_balance, _frozen := int64(balance), int64(frozen)

	var tx *sql.Tx
	tx, err = self.db.Begin()
	if HasError(err) {
		return
	}
	defer func() {
		if err != nil {
			err = tx.Rollback()
		} else {
			err = tx.Commit()
		}
		HasError(err)
	}()

	_, err = tx.Exec("insert ccyflow(user_id,ccy,occur_balance,occur_frozen,summary,business_id) values(?,?,?,?,?,?)", req.User_id, req.Symbol, _balance, _frozen, CcyflowType(req.Reference).String(), req.Related_id)
	if HasError(err) {
		return
	}

	_, err = tx.Exec("update jys_position set balance=balance+?,frozen=frozen+? where user_id=? and ccy=?", _balance, _frozen, req.User_id, req.Symbol)
	if HasError(err) {
		return
	}

	return
}

/* cancel all
create table orders(
	consign_id bigint unsigned not null,
	user_id int unsigned not null,
	inccy int unsigned not null,
	fee bigint unsigned not null,
	income bigint unsigned not null,
	outccy int unsigned not null,
	unfrozen bigint not null,
	frozen bigint not null,
	_status int unsigned not null
);
insert into orders select a.consign_id,a.user_id,a.symbol,convert(a.deal_qty*b.coin_buy_poundage,unsigned),a.deal_qty-convert(a.deal_qty*b.coin_buy_poundage,unsigned),a.reference,a.frozen-a.deal_amount,frozen,case when deal_qty>0 then 6 else 7 end from consign a,jys_all_coin b where a.`status` in (2,3,4) and a.consign_type in (0,8) and a.symbol=b.id;
insert into orders select a.consign_id,a.user_id,a.reference,convert(a.deal_amount*b.coin_buy_poundage,unsigned),a.deal_amount-convert(a.deal_amount*b.coin_buy_poundage,unsigned),a.symbol,a.frozen-a.deal_qty,frozen,case when deal_qty>0 then 6 else 7 end from consign a,jys_all_coin b where a.`status` in (2,3,4) and a.consign_type in (1,9) and a.reference=b.id;
update consign a inner join orders b on a.consign_id=b.consign_id set a.`status`=b._status,a.fee=b.fee,a.update_dt=current_timestamp();
update jys_position a inner join (select user_id,inccy,sum(income) as income from orders group by user_id,inccy) b on a.user_id=b.user_id and a.ccy=b.inccy set a.balance=a.balance+b.income;
update jys_position a inner join (select user_id,outccy,sum(unfrozen) as unfrozen,sum(frozen) as frozen from orders group by user_id,outccy) b on a.user_id=b.user_id and a.ccy=b.outccy set a.balance=a.balance+b.unfrozen,a.frozen=a.frozen-b.frozen;
update consign set `status`=5,update_dt=current_timestamp() where consign_type=2 and `status` in (2,3,4);
update consign set `status`=8,update_dt=current_timestamp() where `status`=1;
drop table orders;
*/
