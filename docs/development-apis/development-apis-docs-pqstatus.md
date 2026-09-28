# PQstatus

## 功能描述

返回链接的状态。

## 原型

```
ConnStatusType PQstatus(const PGconn *conn);
```

## 参数

**表 1**  PQstatus参数

关键字 参数说明 conn 指向包含链接的对象指针。

## 返回值

ConnStatusType：链接状态的枚举，包括：

```
CONNECTION_STARTED
等待进行连接。

CONNECTION_MADE
连接成功；等待发送。

CONNECTION_AWAITING_RESPONSE
等待来自服务器的响应。

CONNECTION_AUTH_OK
已收到认证；等待后端启动结束。

CONNECTION_SSL_STARTUP
协商SSL加密。

CONNECTION_SETENV
协商环境驱动的参数设置。

CONNECTION_OK
链接正常。

CONNECTION_BAD
链接故障。
```

## 注意事项

状态可以是多个值之一。但是，在异步连接过程之外只能看到其中两个：CONNECTION\_OK和CONNECTION\_BAD。与数据库的良好连接状态为CONNECTION\_OK。与数据库的连接尝试失败为CONNECTION\_BAD。通常，“正常”状态将一直保持到PQfinish，但通信失败可能会导致状态CONNECTION\_BAD过早变为。在这种情况下，应用程序可以尝试通过调用进行恢复PQreset。

## 示例

请参见[示例](example_libpq.md)章节。
