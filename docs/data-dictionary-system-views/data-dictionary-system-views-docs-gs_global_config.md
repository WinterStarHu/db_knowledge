# GS\_GLOBAL\_CONFIG

GS\_GLOBAL\_CONFIG记录了数据库实例初始化时，用户指定的参数值。除此之外，还存放了用户设置的弱口令，支持数据库初始用户通过ALTER和DROP语法对系统表中的参数进行写入、修改和删除。

**表 1**  GS\_GLOBAL\_CONFIG字段

name name 数据库实例初始化时系统内置的指定参数名称。当前版本第一行默认为buckets_len，第二行起存放弱口令名称。
value text 数据库实例初始化时系统内置的指定参数值。当前版本第一行默认为bucketmap长度；第二行起存放弱口令。
