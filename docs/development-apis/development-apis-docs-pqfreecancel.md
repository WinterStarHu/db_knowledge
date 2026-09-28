# PQfreeCancel

## 功能描述

释放PQgetCancel创建的数据结构。

## 原型

```
void PQfreeCancel(PGcancel *cancel);
```

## 参数

**表 1**  PQfreeCancel参数

关键字 参数说明 cancel 指向包含cancel信息的对象指针。

## 注意事项

PQfreeCancel释放一个由前面的PQgetCancel创建的数据对象。

## 示例

请参见[示例](example_libpq.md)章节。
