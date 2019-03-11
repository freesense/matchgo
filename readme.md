# 竞价撮合 - 资产管理 & 清算

## 释义

- acc 账号
- ccy 币种
- oid 委托编号
- bid 成交编号
- fid 资金流水编号
- rid 关联业务单编号，默认为0
- result 业务结果，默认为0

## Redis Key Define

key name | type | description |
---------|------|-------------|
oid_generator | string | 委托编号发生器 |
bid_generator | string | 成交编号发生器 |
fid_generator | string | 资金流水编号发生器 |
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
业务结果 | <li>0 未知<li>1 成功<li>2 失败 |

## 业务协议

### 用户登出

### 委托

### 资金调度

### 查询资产

### 查询资金流水

### 查询委托

### 查询成交

## 对账

在以下时间系统对单个用户对账，对账成功后，将最新的资产和交易数据同步到数据库，同时删除相关的redis key。对账时，该账户不能做任何资产业务，包括查询。

- 用户登出时。对账完毕，用户登出系统。
- 用户登入超过一定时间后。对账完毕，保持登入状态。
