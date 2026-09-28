# 调研:`UTL_HTTP.GET_RESPONSE` 的 `return_info_response` 参数

> 配套实证:`return_info_response.sh` / `.out`(实跑逐字)。环境:Oracle 23ai Free 23.26 / OL8。

## 1. 参数位置与签名
```
FUNCTION GET_RESPONSE RETURNS RESP
  R                       REQ      IN OUT
  RETURN_INFO_RESPONSE    BOOLEAN  IN DEFAULT   -- 默认 FALSE
```
`UTL_HTTP.GET_RESPONSE(r, return_info_response => …)` 的第二个参数。

## 2. 它干什么
控制 `GET_RESPONSE` 返回的是**中间的 1xx 信息响应**还是**最终响应**:
- **FALSE(默认)**:自动跳过 1xx 信息响应(如 `100 Continue`),直接返回**最终响应**(2xx/3xx/4xx/5xx)。日常用这个。
- **TRUE**:把 **1xx 信息响应本身**返回给调用者,不跳过。用于需要查看/处理 `100 Continue` 等中间信息的场景(如调试协议交互、`Expect: 100-continue`)。

> 1xx 信息响应(100/101/102…)是 HTTP/1.1 里服务端在正式响应前发的中间消息,通常没有 body。

## 3. 实测行为(对 example.com,HTTP/1.1)
| 调用 | 结果 |
|---|---|
| `get_response(r, FALSE)`(默认) | status=200 OK,body 559(自动跳过 100,直给最终) |
| `get_response(r, TRUE)` | status=**100 Continue**(返回了 1xx) |
| `TRUE` 一次 → 再 `FALSE` | 100 → 200 + body 559(**正确两步用法**) |
| **循环/重复 `TRUE`** | 反复返回同一个 100、不推进 → 累积未关闭请求 → **ORA-29270 too many open HTTP requests** |

关键点:**`TRUE` 不消费/不推进 1xx**——再调还是同一个 100,不会自动进到 200。要拿最终,得换回 `FALSE` 再调。

## 4. 为什么"循环 TRUE 会报错"(会话上限,不是崩)
循环 `get_response(TRUE)`:
- 每调一次 `TRUE` 会**开一个新的 HTTP 请求上下文**,**上一个不关闭**(`end_response` 也没机会对每个中间响应调)。
- UTL_HTTP 每会话**同时打开的 HTTP 请求数有上限(默认 5)** → 第 6 个 → **ORA-29270 "too many open HTTP requests"**。
- 这个错误是**正常抛出的 PL/SQL 异常**,被 `EXCEPTION WHEN OTHERS` 捕获了("PL/SQL procedure successfully completed")。
- 实测输出里 `R3 caught: ORA-29270 (after 6 iters)` 之后还跟了个 `ORA-03113`——那是**会话连接因残留未关闭请求而不可用**导致的连接断开,**不是 dedicated server 段错误式崩溃**(对比:之前 OS bundle 注入私钥的 ORA-03113 才是真崩,带具体 PID;这里 Process ID=0,是连接侧不可用)。

**结论:这是 UTL_HTTP 的会话上限机制(每会话最多 5 个 open HTTP requests),不是 bug 式崩溃。** 用对了(不循环 TRUE)就不会触发。

## 5. 正确用法
```sql
-- 不关心 1xx(绝大多数情况):用默认 FALSE
resp := utl_http.get_response(req);   -- 直接拿最终 200

-- 需要看 1xx:TRUE 一次,紧接着 FALSE 推进到最终
resp := utl_http.get_response(req, return_info_response=>TRUE);   -- 拿 100 Continue
... -- 处理/记录 1xx
resp := utl_http.get_response(req, return_info_response=>FALSE); -- 推进到 200
utl_http.read_text(resp, ...);        -- 读最终 body
utl_http.end_response(resp);
```
**不要循环 `get_response(TRUE)`**——1xx 不推进,会累积未关闭请求撞会话上限。

## 6. 一句话
`return_info_response` = "要不要把 1xx 信息响应交给调用者看"。默认 FALSE 自动跳过到最终;TRUE 则返回 1xx 但**不自动推进**,需手动再 FALSE 推进。误用(循环 TRUE)会撞 UTL_HTTP 每会话 open-requests 上限(ORA-29270),属会话限制,非崩溃。
