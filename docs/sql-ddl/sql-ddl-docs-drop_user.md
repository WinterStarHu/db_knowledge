# DROP USER

## 功能描述

删除用户，同时会删除同名的schema。

## 注意事项

- 须使用CASCADE级联删除依赖用户的对象（除数据库外）。当删除用户的级联对象时，如果级联对象处于锁定状态，则此级联对象无法被删除，直到对象被解锁或锁定级联对象的进程被杀死。
- 在openGauss中，存在一个配置参数enable\_kill\_query，此参数在配置文件postgresql.conf中。此参数影响级联删除用户对象的行为：
  - 当参数enable\_kill\_query为on ，且使用CASCADE模式删除用户时，会自动kill锁定用户级联对象的进程，并删除用户。
  - 当参数enable\_kill\_query为off，且使用CASCADE模式删除用户时，会等待锁定级联对象的进程结束之后再删除用户。

- 在数据库中删除用户时，如果依赖用户的对象在其他数据库中或者依赖用户的对象是其他数据库，请用户先手动删除其他数据库中的依赖对象或直接删除依赖数据库，再删除用户。即drop user不支持跨数据库进行级联删除。
- 如果该用户被DATA SOURCE对象依赖时，无法直接级联删除该用户，需要手动删除对应的DATA SOURCE对象之后再删除该用户。

## 语法格式

```
DROP USER [ IF EXISTS ] user_name [, ...] [ CASCADE | RESTRICT ];
```

## 参数说明

- **IF EXISTS**

如果指定的用户不存在，发出一个notice而不是抛出一个错误。

- **user\_name**

待删除的用户名。

取值范围：已存在的用户名。

- **CASCADE | RESTRICT**
  - CASCADE：级联删除依赖用户的对象。
  - RESTRICT：如果用户还有任何依赖的对象，则拒绝删除该用户（缺省行为）。

>[!NOTE]说明
>
>在openGauss中，存在一个配置参数enable\_kill\_query，此参数在配置文件postgresql.conf中。此参数影响级联删除用户对象的行为：
>
>- 当参数enable\_kill\_query为on ，且使用CASCADE模式删除用户时，会自动kill锁定用户级联对象的进程，并删除用户。
>
>- 当参数enable\_kill\_query为off，且使用CASCADE模式删除用户时，会等待锁定级联对象的进程结束之后再删除用户。

## 示例

请参考CREATE USER的[示例](create_user.md#zh-cn_topic_0283136891_zh-cn_topic_0237122125_zh-cn_topic_0059778166_sfbca773f5bcd4799b3ea668b3eb074fa)。

## 相关链接

[ALTER USER](alter_user.md)，[CREATE USER](create_user.md)
