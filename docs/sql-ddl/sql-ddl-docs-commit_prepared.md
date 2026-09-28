# COMMIT PREPARED

## 功能描述

提交一个早先为两阶段提交准备好的事务。

## 注意事项

- 该功能仅在维护模式（GUC参数xc\_maintenance\_mode为on时）下可用。该模式谨慎打开，一般供维护人员排查问题使用，一般用户不应使用该模式。
- 命令执行者必须是该事务的创建者或系统管理员，且创建和提交操作只能在同一个会话中。
- 事务功能由数据库自动维护，不应显式使用事务功能。

## 语法格式

```
COMMIT PREPARED transaction_id ;
COMMIT PREPARED transaction_id WITH CSN;
```

## 参数说明

- **transaction\_id**

待提交事务的标识符。它不能和任何当前预备事务已经使用了的标识符同名。

- **CSN（commit sequence number）**

待提交事务的序列号。它是一个64位递增无符号数。

## 示例

```
--提交标识符为的trans_test的事务。
openGauss=# COMMIT PREPARED 'trans_test';
```

## 相关链接

[PREPARE TRANSACTION](prepare_transaction.md)，[ROLLBACK PREPARED](rollback_prepared.md)。
