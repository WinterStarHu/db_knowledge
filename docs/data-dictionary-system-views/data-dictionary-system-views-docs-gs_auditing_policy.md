# `GS_AUDITING_POLICY`

`GS_AUDITING_POLICY` 系统表记录统一审计的主体信息，每条记录对应一个设计策略。需要有系统管理员或安全策略管理员权限才可以访问此系统表。

**表 1** `GS_AUDITING_POLICY` 字段

oid oid 行标识符（隐含属性，必须明确选择）。
polname name 策略名称，需要唯一，不可重复。
polcomments name 策略描述字段，记录策略相关的描述信息，通过COMMENTS关键字体现。
modifydate timestamp without time zone 策略创建或修改的最新时间戳。
polenabled boolean 用来表示策略启动开关。
