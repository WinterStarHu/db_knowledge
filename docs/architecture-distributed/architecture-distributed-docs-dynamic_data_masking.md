# 动态数据脱敏机制

## 可获得性

本特性自openGauss 1.1.0版本开始引入。

## 特性简介

数据脱敏是行之有效的数据库隐私保护方案之一，可以在一定程度上限制非授权用户对隐私数据的窥探。动态数据脱敏机制是一种通过定制化制定脱敏策略从而实现对隐私数据保护的一种技术，可以有效地在保留原始数据的前提下解决非授权用户对敏感信息的访问问题。当管理员指定待脱敏对象和定制数据脱敏策略后，用户所查询的数据库资源如果关联到对应的脱敏策略时，则会根据用户身份和脱敏策略进行数据脱敏，从而限制非授权用户对隐私数据的访问。

## 客户价值

数据隐私保护是数据库安全所需要具备的安全能力之一，可以在一定程度上限制非授权用户对隐私数据的访问，保证隐私数据安全。动态数据脱敏机制可以通过配置脱敏策略实现对指定数据库资源信息的隐私保护，另一方面，脱敏策略的配置也具有一定的灵活性，可以仅针对特定用户场景实现有针对性的隐私保护能力。

## 特性描述

动态数据脱敏机制基于资源标签进行脱敏策略的定制化，可根据实际场景选择特定的脱敏方式，也可以针对某些特定用户制定脱敏策略。一个完整的脱敏策略创建的SQL语法如下所示：

```
CREATE RESOURCE LABEL label_for_creditcard ADD COLUMN(user1.table1.creditcard);
CREATE RESOURCE LABEL label_for_name ADD COLUMN(user1.table1.name);
CREATE MASKING POLICY msk_creditcard creditcardmasking ON LABEL(label_for_creditcard);
CREATE MASKING POLICY msk_name randommasking ON LABEL(label_for_name) FILTER ON IP(local), ROLES(dev);
```

其中，label\_for\_creditcard和msk\_name为本轮计划脱敏的资源标签，分别包含了两个列对象；creditcardmasking、randommasking为预置的脱敏函数；msk\_creditcard定义了所有用户对label\_for\_creditcard标签所包含的资源访问时做creditcardmasking的脱敏策略，不区分访问源；msk\_name定义了本地用户dev对label\_for\_name标签所包含的资源访问时做randommasking的脱敏策略；当不指定FILTER对象时则表示对所有用户生效，否则仅对标识场景的用户生效。

当前，预置的脱敏函数包括：

脱敏函数名 creditcardmasking '4880-9898-4545-2525' 将会被脱敏为 'xxxx-xxxx-xxxx-2525'，该函数仅对后4位之前的数字进行脱敏 basicemailmasking 'abcd@gmail.com' 将会被脱敏为'xxxx@gmail.com'， 对出现第一个'@'之前的文本进行脱敏 fullemailmasking 'abcd@gmail.com' 将会被脱敏为 'xxxx@xxxxx.com'，对出现最后一个'.'之前的文本（除'@'符外）进行脱敏 alldigitsmasking 'alex123alex' 将会被脱敏为 'alex000alex'， 仅对文本中的数字进行脱敏 shufflemasking 'hello word' 将会被随机打乱顺序脱敏为 'hlwoeor dl'， 该函数通过字符乱序排列的方式实现，属于弱脱敏函数，语义较强的字符串不建议使用该函数脱敏。
randommasking 'hello word' 将会被脱敏为 'ad5f5ghdf5'，将文本按字符随机脱敏 regexpmasking 需要用户顺序输入四个参数，reg为被替换的字符串，replace_text为替换后的字符串，pos为目标字符串开始替换的初始位置，为整数类型，reg_len为替换长度，为整数类型。reg、replace_text可以用正则表达，pos如果不指定则默认为0，reg_len如果不指定则默认为-1，即pos后所有字符串。如果用户输入参数与参数类型不一致，则会使用maskall方式脱敏。
CREATE MASKING POLICY msk_creditcard regexpmasking('[\d+]', 'x', 5, 9 )  ON LABEL(label_for_creditcard);
'4880-9898-4545-2525' 将会被脱敏为 '4880-xxxx-xxxx-2525' maskall '4880-9898-4545-2525' 将会被脱敏为 'xxxxxxxxxxxxxxxxxxx'

每个脱敏函数规格如下：

脱敏函数名 支持的数据类型 creditcardmasking BPCHAR, VARCHAR, NVARCHAR, TEXT（注：仅针对信用卡格式的文本类数据） basicemailmasking BPCHAR, VARCHAR, NVARCHAR, TEXT（注：仅针对email格式的文本类型数据） fullemailmasking BPCHAR, VARCHAR, NVARCHAR, TEXT（注：仅针对email格式的文本类型数据） alldigitsmasking BPCHAR, VARCHAR, NVARCHAR, TEXT（注：仅针对包含数字的文本类型数据） shufflemasking BPCHAR, VARCHAR, NVARCHAR, TEXT（注：仅针对文本类型数据） randommasking BPCHAR, VARCHAR, NVARCHAR, TEXT（注：仅针对文本类型数据） maskall BOOL, RELTIME, TIME, TIMETZ, INTERVAL, TIMESTAMP, TIMESTAMPTZ, SMALLDATETIME, ABSTIME, TEXT, BPCHAR, VARCHAR, NVARCHAR2, NAME, INT8, INT4, INT2, INT1, NUMRIC, FLOAT4, FLOAT8, CASH

对于不支持的数据类型，默认使用maskall函数进行数据脱敏，若数据类型不属于maskall支持的数据类型则全部使用数字0进行脱敏，如果脱敏列涉及隐式转换，则结果以隐式转换后的数据类型为基础进行脱敏。另外需要说明的是，如果脱敏策略应用到数据列并生效，此时对该列数据的操作将以脱敏后的结果为基础而进行。

动态数据脱敏适用于和实际业务紧密相关的场景，根据业务需要为用户提供合理的脱敏查询接口，以避免通过撞库而获取原始数据。

## 特性增强

无。

## 特性约束

- 动态数据脱敏策略需要由具备POLADMIN或SYSADMIN属性的用户或初始用户创建，普通用户没有访问安全策略系统表和系统视图的权限。

- 动态数据脱敏只在配置了脱敏策略的数据表上生效，而审计日志不在脱敏策略的生效范围内。

- 在一个脱敏策略中，对于同一个资源标签仅可指定一种脱敏方式，不可重复指定。

- 不允许多个脱敏策略对同一个资源标签进行脱敏，除以下脱敏场景外：使用FILTER指定策略生效的用户场景，包含相同资源标签的脱敏策略间FILTER生效场景无交集，此时可以根据用户场景明确辨别资源标签被哪种策略脱敏。

- Filter中的APP项建议仅在同一信任域内使用，由于客户端不可避免的可能出现伪造名称的情况，该选项使用时需要与客户端联合形成一套安全机制，减少误用风险。一般情况下不建议使用，使用时需要注意客户端仿冒的风险。

- 对于带有query子句的INSERT或MERGE INTO操作，如果源表中包含脱敏列，则上述两种操作中插入或更新的结果为脱敏后的值，且不可还原。

- 在内置安全策略开关开启的情况下，执行ALTER TABLE EXCHANGE PARTITION操作的源表若在脱敏列则执行失败。

- 对于设置了动态数据脱敏策略的表，需要谨慎授予其他用户对该表的trigger权限，以免其他用户利用触发器绕过脱敏策略。

- 最多支持创建98个动态数据脱敏策略。

- 仅支持使用上述七种预置脱敏策略。

- 仅支持对只包含COLUMN属性的资源标签做脱敏。

- 仅支持对基本表的列进行数据脱敏。

- 仅支持对SELECT查询到的数据进行脱敏。

- FILTER中的IP地址以ipv4为例支持如下格式。

ip地址格式 单ip
127.0.0.1
掩码表示ip
127.0.0.1|255.255.255.0
cidr表示ip
127.0.0.1/24
ip区间
127.0.0.1-127.0.0.5

## 依赖关系

无。
