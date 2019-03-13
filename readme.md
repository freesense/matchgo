# 竞价撮合 - 资产管理 & 清算

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

* [竞价撮合 - 资产管理 & 清算](#竞价撮合-资产管理-清算)
	* [释义](#释义)
	* [Redis Key Define](#redis-key-define)
	* [数据格式和字典](#数据格式和字典)
	* [对账](#对账)
	* [委托协议](#委托协议)
		* [委托](#委托)
		* [全部撤单](#全部撤单)
	* [用户资产协议](#用户资产协议)
		* [用户登出](#用户登出)
		* [资金调度](#资金调度)
		* [查询资产](#查询资产)
		* [查询资金流水](#查询资金流水)
		* [查询委托](#查询委托)
		* [查询成交](#查询成交)
	* [维护协议](#维护协议)
		* [打印某symbol在内存撮合中的排队情况](#打印某symbol在内存撮合中的排队情况)
		* [系统退出](#系统退出)
		* [停止收单](#停止收单)
		* [开始收单](#开始收单)

<!-- /code_chunk_output -->

## 释义

- acc 账号
- ccy 币种
- oid 委托编号
- bid 成交编号
- fid 资金流水编号
- rid 关联业务单编号，默认为0
- result 业务结果，默认为0

## Redis Key Define

- 行情库 select 0
- 交易库 select 1

key name | type | description |
---------|------|-------------|
oid_generator | string | 委托编号发生器 |
bid_generator | string | 成交编号发生器 |
fid_generator | string | 资金流水编号发生器 |
trading | string | 正常交易标志<li>not 不可交易<li>nil or else 可交易
asset.[acc].[ccy] | hash | 客户资产<li>balance 余额<li>frozen 冻结数 |
consign.[acc].[oid] | hash | 委托单<li>time 委托时间<li>type 委托类型<li>channel 委托渠道<li>symbol 交易币<li>reference 参考币<li>price 委托价格<li>qty 委托数量<li>status 委托状态<li>deal_qty 成交数量<li>deal_amount 成交金额 |
bargain.oid.[oid] | list | 单个委托单的全部成交编号 |
bargain.[bid] | hash | 成交单<li>time 成交时间<li>price 成交价格<li>qty 成交数量<li>activate_oid 主动委托编号<li>proactive_oid 被动委托编号|
ccyflow.[acc].[ccy].[type 资金流水类型].[rid].[result] | hash | 资金流水，不管资金发生业务是否成功，都必须记录该笔业务<li>fid 资金流水编号<li>time 发生时间<li>occur_amount 发生金额<li>pre_amount 发生前金额<li>post_amount 发生后金额 |
sync.[acc] | string | 同步标志<li>time 同步时间<li>sync 正在对账 |

## 数据格式和字典

name | description |
-----|-------------|
时间 | yyyy-mm-dd hh:mm:ss |
委托渠道 | <li>w 网上交易<li>a 安卓<li>i IOS<li>u 未知 |
委托类型 | <li>0 限价买入<li>1 限价卖出<li>2 撤单<li>8 市价买入<li>9 市价卖出 |
委托状态 | <li>1 已提交<li>2 已接受<li>3 排队中<li>4 部分成交<li>5 全部成交<li>6 部分撤单<li>7 全部撤单<li>8 已拒绝<li>9 市价单专用，表示等待全部成交完毕再结算 |
资金流水类型 | <li>1/BB 币币交易<li>2/BBFE 币币交易手续费<li>3/CZ 冲正<li>4/OUT 充提币<li>5/OUTFEE 充提币手续费<li>6/TRAN 币币法币互转<li>7/FAKE 资产注水<li>8/BONU 糖果<li>9/FEEBACK 返佣 |
业务结果 | <li>0 成功<li>1 未知<li>其它 错误代码 |
Errno/errcode | <li>0 成功<li>1 未知<li>其它 错误代码 |
errmsg | 错误信息，*utf8*编码，语言由`language`参数决定：<li>en(default)<li>zh-cn<li>zh-tw |

## 对账

在以下时间系统对单个用户对账，对账成功后，将最新的资产和交易数据同步到数据库，同时删除相关的redis key。对账时，该账户不能做任何资产业务，包括查询。

- 用户登出时。对账完毕，用户登出系统。
- 用户登入超过一定时间后。对账完毕，保持登入状态。

## 委托协议

ZMQ.REQ-REP

``` go
type OrderRequest struct {
	User_id, Symbol, Reference, Otype, Channel uint32
	Price, Qty, Language               		   string
	Related_id                        		   uint64
}

type Answer struct {
	Errno      int
	Errmsg     string
	Consign_id uint64
	Status     int
}
```

### 委托

### 全部撤单

仅支持全部撤掉某用户的排队委托

## 用户资产协议

- 仅对允许的ip地址开放
- 查询协议说明
	- `start`表示从哪一条记录开始查询，但是这一条记录并不会包含在返回的结果集中，默认为0
		- 查询资金流水，fid
		- 查询委托，oid
		- 查询成交，bid
	- `num`表示应该返回几条记录，10~100，默认50
	- 如果返回的记录条数小于`num`，表示没有更多记录，可以停止翻页

### 用户登出

```
/logout?user_id=xxx&language=en
```

``` json
{
	"errcode": 0,
	"errmsg": "success"
}
```

### 资金调度

- `balance`和`frozen`至少存在一个

```
/trans?user_id=xxx&ccy=BTC&balance=xxx&frozen=xxx&type=xxx&language=en
```

``` json
{
	"errcode": 0,
	"errmsg": "success",
	"ccy": "BTC",
	"balance": "4.17280013",
	"frozen": "0.0225"
}
```

### 查询资产

- `ccy`省略表示查询全部币种的资产

```
/asset?user_id=xxx&ccy=xxx&language=en
```

``` json
{
	"errcode": 0,
	"errmsg": "success",
	"datas": [
		{
			"ccy": "BTC",
			"balance": "4.17280013",
			"frozen": "0.0225"
		},
		{
			"ccy": "ETH",
			"balance": "210.44092",
			"frozen": "0"
		}
	]
}
```

### 查询资金流水

- `ccy`省略表示查询全部币种的资金流水

```
/zflow?user_id=xxx&ccy=xxx&start=xxx&num=xxx&language=en
```

``` json
{
	"errcode": 0,
	"errmsg": "success",
	"datas": [
		{
			"fid": 12345678,
			"ccy": "BTC",
			"type": "TRAN",
			"amount": "1.1108",
			"rid": 310422
		}
	]
}
```

### 查询委托

- `orderid`省略表示查询全部委托

```
/orders?user_id=xxx&orderid=xxx&start=xxx&num=xxx&language=en
```

``` json
{
	"errcode": 0,
	"errmsg": "success",
	"datas": [
		{
			"oid": 32,
			"type": "BUY",
			"symbol": "BTC/ETH",
			"price": "330.58",
			"qty": "1.1108",
			"deal_qty": "0.25",
			"deal_amount": "178.662",
			"status": "partial_filled"
		}
	]
}
```

### 查询成交明细

- `orderid`省略表示查询全部委托的成交明细

```
/bargains?user_id=xxx&orderid=xxx&start=xxx&num=xxx&language=en
```

``` json
{
	"errcode": 0,
	"errmsg": "success",
	"datas": [
		{
			"oid": 79110,
			"bid": 8864,
			"price": "330.58",
			"qty": "1.1108"
		}
	]
}
```

## 维护协议

- 仅对允许的ip地址开放

### 打印某symbol在内存撮合中的排队情况

- `depth`取值1~50，默认为20

```
/dumporder?symbol=xxx&depth=xxx&language=en
```

``` json
{
	"errcode": 0,
	"errmsg": "success",
	"latest": "1184.72",
	"bids": [
		{
			"p": "1184.71",
			"q": "12000"
		},
		...
	],
	"asks": [
		{
			"p": "1184.73",
			"q": "4169"
		},
		...
	]
}
```

### 系统退出

```
/exit?language=en
```

``` json
{
	"errcode": 0,
	"errmsg": "success"
}
```

### 停止收单

```
/stop-receive-order?language=en
```

``` json
{
	"errcode": 0,
	"errmsg": "success"
}
```

### 开始收单

```
/start-receive-order?language=en
```

``` json
{
	"errcode": 0,
	"errmsg": "success"
}
```
