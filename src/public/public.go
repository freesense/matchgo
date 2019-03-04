package public

import (
	"fmt"
	"math/big"
	"os"
	"strconv"

	"github.com/larspensjo/config"
	"github.com/shopspring/decimal"
)

type CcyflowType uint32

func (t CcyflowType) String() string {
	switch t {
	case 1:
		return "BB" // 币币交易
	case 2:
		return "BBFE" // 币币交易手续费
	case 3:
		return "CZ" // 资金冲正
	case 4:
		return "OUTSIDE" // 充提币
	case 5:
		return "OUTFEE" // 充提币手续费
	case 6:
		return "TRANSFER" // 币币法币互转
	case 7:
		return "FAKE" // 资产注水
	case 8:
		return "BONUS" // 糖果
	case 9:
		return "FEEBACK" // 返佣
	default:
		Println("Unknown ccyflow type: %d\n", uint32(t))
		return "UNKNOWN"
	}
}

// 订单类型
const (
	OtypeLimitBid  = 0
	OtypeLimitAsk  = 1
	OtypeCancel    = 2
	OtypeMarketBid = 8
	OtypeMarketAsk = 9
	OtypeFundChg   = 0xffffffff // 资金流水
)

var Dmul decimal.Decimal
var Imul uint64

func Init_public(cfg *config.Config) {
	_multiple, err := cfg.String("public", "multiple")
	FatalError(err)
	decimal.DivisionPrecision, err = strconv.Atoi(_multiple)
	FatalError(err)
	Dmul, err = decimal.NewFromString("10")
	FatalError(err)
	y, err := decimal.NewFromString(_multiple)
	FatalError(err)
	Dmul = Dmul.Pow(y)
	Imul = uint64(Dmul.IntPart())
}

func Appendf(fname, format string, v ...interface{}) error {
	var f *os.File
	var err error
	if _, err = os.Stat(fname); os.IsNotExist(err) {
		f, err = os.Create(fname)
	} else {
		f, err = os.OpenFile(fname, os.O_APPEND, 0666)
	}

	if HasError(err) {
		return err
	}

	content := fmt.Sprintf(format, v...)

	cnt := len(content)
	for {
		n, err := f.WriteString(content[len(content)-cnt : len(content)-1])
		if HasError(err) {
			break
		}
		cnt -= n
		if cnt == 0 {
			break
		}
	}
	err = f.Close()
	HasError(err)
	return err
}

type Order struct {
	Oid, Relate_id, Price, Qty uint64
	Otype, Symbol_id, User_id  uint32
}

type OrderRequest struct {
	User_id, Symbol, Reference, Otype uint32
	Price, Qty                        string
	Related_id                        uint64
}

func IsBuy(otype uint32) bool {
	if otype&0x01 > 0 {
		return false
	}
	return true
}

func IsCancel(otype uint32) bool {
	if otype&0x08 > 0 {
		return true
	}
	return false
}

func (o *OrderRequest) Dump() string {
	return fmt.Sprintf("OR, User=%d, Symbol=%d/%d, Type=%d, Price=%s, Qty=%s, Relate=%d", o.User_id, o.Symbol, o.Reference, o.Otype, o.Price, o.Qty, o.Related_id)
}

type Tick struct {
	Symbol        uint32
	Activate_type uint32
	Occur_dt      uint64
	Oid_activated uint64
	Oid_proactive uint64
	Price         uint64
	Qty           uint64
}

const (
	Submitted         = iota + 1 // 1
	Accepted                     // 2
	Queued                       // 3
	Partial_Filled               // 4
	Filled                       // 5
	Partial_Cancelled            // 6
	Cancelled                    // 7
	Rejected                     // 8
	Wait                         // 9 市价单专用，表示等待全部成交完毕再结算
)

func StringMulUint64(s string) (value uint64, err error) {
	dec, err := decimal.NewFromString(s)
	if err != nil {
		return
	}
	dec = dec.Mul(Dmul)
	value = uint64(dec.IntPart())
	return
}

func StringToDec(s string) (value decimal.Decimal, err error) {
	value, err = decimal.NewFromString(s)
	if err != nil {
		return
	}
	return
}

func DecToUint64(v decimal.Decimal) uint64 {
	return uint64(v.Mul(Dmul).IntPart())
}

func StringDivDec(s string) (value decimal.Decimal, err error) {
	dec, err := decimal.NewFromString(s)
	if err != nil {
		return
	}
	value = dec.Div(Dmul)
	return
}

func StringDivString(s string) (value string, err error) {
	dec, err := StringDivDec(s)
	if err != nil {
		return
	}
	value = dec.String()
	return
}

func Uint64DivString(value uint64) string {
	return Uint64DivDec(value).String()
}

func Uint64DivDec(value uint64) decimal.Decimal {
	var _value big.Int
	dec := decimal.NewFromBigInt(_value.SetUint64(value), 0)
	dec = dec.Div(Dmul)
	return dec
}

func DecDivString(value decimal.Decimal) string {
	return value.Div(Dmul).String()
}

func Max(x, y decimal.Decimal) decimal.Decimal {
	if x.LessThan(y) {
		return y
	} else {
		return x
	}
}

func Min(x, y decimal.Decimal) decimal.Decimal {
	if x.LessThan(y) {
		return x
	} else {
		return y
	}
}

// 时间格式转换：yyyymmddthhmmss -> yyyy-mm-dd hh:mm:ss
func ConvertDT(tag string) string {
	return tag[0:4] + "-" + tag[4:6] + "-" + tag[6:8] + " " + tag[9:11] + ":" + tag[11:13] + ":" + tag[13:15]
}
