# lo_lseek

## 功能描述

改变一个大对象描述符的当前读或写位置。

## 原型

```
int lo_lseek(PGconn* conn, int fd, int offset, int whence);
```

## 参数

**表 1**  lo\_lseek参数

关键字 参数说明 conn 一个数据库连接 文件描述符 offset 将文件描述符的当前位置指针移动到由offset指定的新位置 whence 从对象开头定位、从当前位置定位、或从对象末尾定位

## 返回值

int：新位置的指针，或者是-1表示出错。

# lo_lseek64

## 功能描述

改变一个\(可能超过2GB大小\)大对象描述符的当前读或写位置。

## 原型

```
long int lo_lseek64(PGconn *conn, int fd, long int offset, int whence);
```

## 参数

**表 1**  lo\_lseek64参数

关键字 参数说明 conn 一个数据库连接 文件描述符 offset 将文件描述符的当前位置指针移动到由offset指定的新位置 whence 从对象开头定位、从当前位置定位、或从对象末尾定位

## 返回值

int：新位置的指针，或者是-1表示出错。

## 示例

请参见[示例](example_libpq.md)章节。
