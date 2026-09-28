# 调研结论:Oracle 23ai `UTL_HTTP.SET_WALLET('system:')`

> 配套实证:`run_system_wallet_tests.sh` / `.out`(常规场景)、`tamper_ca_bundle.sh` / `.out`(篡改/容错)。本文件为结论蒸馏,详细取证见 `调研文档_UTL_HTTP_system_wallet.md`,参数行为见 `parameter_behavior.md`。
> 环境:Oracle Database 23ai Free 23.26.0.0.0 / Oracle Linux 8。

---

## 一句话结论
`SET_WALLET('system:')` 让 UTL_HTTP 用**宿主机 OS 的 CA 信任库**(`system:` 路径=`/etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem`,本机 148 个公共根)做 HTTPS 服务端证书校验,**不用自建 Oracle 钱包**;但它**必须显式调用**,且只信公共 CA、对 bundle 内容不容错(非证书内容会崩)。

---

## 1. system: 是什么、读哪个文件
- `system:` = 走 OS/OpenSSL 系统信任库,**不读** Oracle 钱包文件(`ewallet.p12`/`cwallet.sso`)。
- 路径取证(实锤):把 `/etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem` 移走 → `ORA-28759 failure to open file`;移回 → 恢复。即 `system:` 每次请求现读这一个文件,不缓存。

## 2. 必须显式调用
- 不调 `SET_WALLET`(或传 NULL)→ HTTPS 直接 **ORA-29024**。
- 没有任何"隐式默认":设 `ssl_wallet` 参数 + `_implicit_ssl_wallet=TRUE` 也不会自动套用(仍 ORA-29024)。**代码里必须写 `UTL_HTTP.SET_WALLET('system:');`**。

## 3. 写法对比
| 写法 | 结果 | 语义 |
|---|---|---|
| 不设钱包 | ❌ ORA-29024 | 无信任库 |
| `system`(漏冒号) | ❌ ORA-29248 | 非法 WRL |
| `system:` / `SYSTEM:` / `System:` | ✅ | OS 信任库;**冒号必须、大小写不敏感** |
| `file:/钱包目录` | ✅ | Oracle 钱包(须含 `cwallet.sso`/`ewallet.p12`)|
| `file:/非钱包路径`(含 OS bundle 目录、不存在目录) | ❌ ORA-28759 | 不是 Oracle 钱包 |
| 非法 scheme(`garbage`/`http:`/`ldap:`) | ❌ ORA-29248 | 无合法 scheme |
| `file:`(空路径) | ❌ ORA-28784 | file name translation failure |
| HTTP(非 https)URL | ✅ | 钱包只对 HTTPS 生效,HTTP 无关 |
| `system:` + 错误密码 | ✅ | 密码被**静默忽略**(system: 无密码) |

## 4. 校验机制与错误码(system: 与 file: 同码,同源 OpenSSL)
| 故障 | 错误码 | 触发顺序 |
|---|---|---|
| TLS 版本不匹配(如仅 TLS1.1) | **ORA-29019** | 握手期,**先于**证书校验 |
| 证书过期(叶子/中间) | ORA-29024 | 校验期 |
| 未知 CA / 自签 | ORA-29024 | 校验期(与过期同码,靠上下文区分) |
| 主机名不匹配(CN/SAN≠host) | **ORA-24263** | 专门码 |
| 钱包文件打不开 | **ORA-28759** | 加载期 |

> 校验两道独立关卡:① 信任链(链到 bundle 里的根)② 主机名匹配。`system:` 信了根也不会"包庇"主机名对不上。

## 5. 篡改与容错(重要安全/稳定性发现)
- **信任 = bundle 内容**:把 OS bundle 换成自建 CA → `system:` 就信被该 CA 签的自签证书(实测 OK);真根没了公网站点就挂。**`system:` 的可信度 = OS bundle 的完整性**(靠 OS 文件权限 / `ca-certificates` 包完整性 / root 控制),Oracle 层不防。
- **bundle 内容不容错(疑似 bug)**:往 bundle 文件里塞**任何非 `CERTIFICATE` 的 PEM 块**(RSA/EC/PKCS8 私钥、CSR、PKCS7)或**二进制数据** → `system:` 走任何 HTTPS **必崩** ORA-03113(dedicated server 进程死,实例不挂);只有纯文本(无 `-----BEGIN`)被忽略。
  - 对照:同目录放散落的私钥**文件**(不动 bundle 文件)→ 不影响(`system:` 只读那一个文件)。
  - 所以 OS bundle 必须**只含证书块**;被污染(哪怕一段私钥/二进制)就崩。

## 6. 参数(详见 `parameter_behavior.md`)
- `_allow_system_wallet`(默认 TRUE)实测置 FALSE+重启后 **不禁用** 显式 `system:`(纠正"它是总开关"的说法)。
- `_implicit_ssl_wallet` TRUE/FALSE 对 UTL_HTTP 无可观察影响(不自动套用 `ssl_wallet`)。
- `ssl_wallet` 可 CDB 级动态改,但 UTL_HTTP 不会隐式用它。
- `wallet_root` 与 UTL_HTTP trust 无关。

## 7. 何时用 system: / file:
- 目标是**公网 CA 签发**的证书 → `system:`,一行,零配置。
- 目标是**自签 / 企业私有 CA** → `file:` 钱包,`orapki wallet add -trusted_cert` 导入私有 CA。
- 不论哪种,OS bundle 都要保证**只含证书**(否则 `system:` 崩)。

## 8. 复现
```bash
ssh -p 2222 oracle@127.0.0.1
bash run_system_wallet_tests.sh          # 常规 11 场景(S1-S8 + C/D/F),无 DB 重启
bash tamper_ca_bundle.sh                 # 篡改/容错实验(信任=内容、非证书内容必崩)
# 各自 stdout 即对应 .out(实跑逐字,非拼接)
```

## 9. 安全建议
- 用 `system:` 时,确保 OS 的 `ca-certificates` 及时更新(本机就有一个已过期根 Baltimore,2025-05,平时不影响但说明包滞后)。
- **保护 OS bundle 文件完整性**(root 权限、包签名校验)——它被篡改/污染,`system:` 就跟着被操控或崩。
- 不要把私钥/CSR 等非证书内容写进 OS bundle(会触发进程崩)。
- mTLS(客户端证书)只能用 `file:` 钱包,`system:` 不提供客户端凭据。
