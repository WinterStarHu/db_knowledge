# PQsendQueryParams

## 功能描述

给服务器提交一个命令和分隔的参数，而不等待结果。

## 原型

```
int PQsendQueryParams(PGconn *conn,
                      const char *command,
                      int nParams,
                      const Oid *paramTypes,
                      const char * const *paramValues,
                      const int *paramLengths,
                      const int *paramFormats,
                      int resultFormat);
```

## 参数

**表 1**  PQsendQueryParams参数

关键字 参数说明 conn 指向包含链接的对象指针。
command 需要执行的查询字符串。
nParams 参数个数。
paramTypes 参数类型。
paramValues 参数值。
paramLengths 参数长度。
paramFormats 参数格式。
resultFormat 结果的格式。

## 返回值

int：执行结果为1表示成功，0表示失败，失败原因存到conn-\>errorMessage中。

## 注意事项

该函数等效于PQsendQuery，只是查询参数可以和查询字符串分开声明。函数的参数处理和PQexecParams一样，和PQexecParams类似，它不能在2.0版本的协议连接上工作，并且它只允许在查询字符串里出现一条命令。

## 示例

请参见[示例](example_libpq.md)章节。
