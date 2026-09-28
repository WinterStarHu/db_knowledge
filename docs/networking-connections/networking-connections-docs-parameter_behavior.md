# 参数行为备忘(`ssl_wallet` / `_implicit_ssl_wallet` / `_allow_system_wallet` / `wallet_root`)

> 这部分与 `system:` 钱包主线无关,从主调研文档摘出独立存放。仅为记录,不在 system: 测试集中体现。

## 元数据
```
ssl_wallet            = (null)  -- ssl_wallet                                   [CDB 级,动态可改 scope=both;PDB 内改报 ORA-65040]
wallet_root           = (null)  -- wallet root instance initialization parameter [不可动态改,ORA-02095;只能 spfile+重启]
_implicit_ssl_wallet  = TRUE    -- Implicitly use SSL Wallet for UTL_HTTP request
_allow_system_wallet  = TRUE    -- Allow Usage of SYSTEM Wallet Path for Outbound Communication
```

## 可改性
| 参数 | session 改 | system 改 | 实测 |
|---|---|---|---|
| `ssl_wallet` | ❌ | ✅(CDB$ROOT,scope=both)| PDB 内 `alter system set` → ORA-65040;切到 CDB$ROOT(`sys/oracle@localhost:1521/FREE as sysdba`)**scope=both 成功** |
| `wallet_root` | ❌ | ❌(动态)| `alter system set ... scope=both` → **ORA-02095**(只能 spfile+重启)|
| `_allow_system_wallet` | ❌(ORA-02096)| ✅ spfile | session 改报 ORA-02096;`scope=spfile` + 重启后生效(实测 param=FALSE 已确认)|
| `_implicit_ssl_wallet` | spfile+重启 | — | session 不可改;`scope=spfile`+重启可改 |

> 为何要重启:`wallet_root` / `_allow_system_wallet` / `_implicit_ssl_wallet` 的 `ISSYS_MODIFIABLE=FALSE`(非动态),只能写 spfile,重启才生效——Oracle 参数语义规定的,非可选。`ssl_wallet` 是 IMMEDIATE,不用重启。

## 行为实测

### `ssl_wallet` + `_implicit_ssl_wallet`(CDB 设 ssl_wallet,两种 _implicit 值)
```
_implicit=TRUE:  I1 无 SET_WALLET(隐式用 ssl_wallet?)-> ERR -29273 ORA-29024   没有自动套用
                 I2 SET_WALLET('system:')            -> OK  len=559            system: 不受 ssl_wallet 影响
_implicit=FALSE: M1 无 SET_WALLET                    -> ERR -29273 ORA-29024   与 TRUE 一样
                 M2 system:                           -> OK len=559
                 M3 file:                             -> OK len=559
```
结论:无论 `_implicit_ssl_wallet` TRUE/FALSE,**UTL_HTTP 都不会自动拿 `ssl_wallet` 当 HTTPS 信任库**;该参数在本配置对 UTL_HTTP 无可观察效果。要验证 HTTPS 仍须显式 `SET_WALLET`。
> `ssl_wallet` 对 `file:` 前缀不识别——设 `file:/home/oracle/wallet_http` 被规范化成 `$ORACLE_HOME/dbs/file:/...`(当相对路径)。`ssl_wallet` 应填纯目录路径。测试后已 `reset` 清干净。

### `_allow_system_wallet=FALSE`(spfile + 重启)
```
spfile: alter system set "_allow_system_wallet"=false scope=spfile  -> OK
shutdown immediate; startup; 确认 _allow_system_wallet=FALSE, status=OPEN
T1 SET_WALLET('system:') -> OK len=559   ← 开关关掉,system: 照样能用!
T2 SET_WALLET('file:...')  -> OK len=559
恢复: alter system set "_allow_system_wallet"=true scope=spfile + 重启 -> VERIFY system: OK
```
结论:`_allow_system_wallet=FALSE` **不会**禁用显式 `UTL_HTTP.SET_WALLET('system:')`。该参数虽被 HTTP 初始化层读取(二进制有 `pihtinit: Failed to get _allow_system_wallet parameter value` 字样),但在本配置下对 UTL_HTTP 显式 `system:` 无可观察影响——大概管的是另一条"系统钱包"代码路径,而非 `system:` 字面量。

## 连接/启动要点(本 appliance 坑)
`.bashrc` 设了 `export TWO_TASK=freepdb1`,导致 `sys/oracle as sysdba`(不带 @)也走 listener→service `freepdb1`;实例一旦关闭,listener 端口连不上(ORA-12514 / ORA-01017)。要对 down 的实例做 STARTUP:
```bash
unset TWO_TASK
export ORACLE_SID=FREE
sqlplus / as sysdba          # bequeath OS 认证(本机 OS 认证可用,只是被 TWO_TASK 屏蔽)
> STARTUP
```
