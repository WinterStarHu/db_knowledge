# GS\_MASKING\_POLICY

GS\_MASKING\_POLICY系统表记录动态数据脱敏策略的主体信息，每条记录对应一个脱敏策略。需要有系统管理员或安全策略管理员权限才可以访问此系统表。

**表 1**  GS\_MASKING\_POLICY表字段

oid oid 行标识符（隐含属性，必须明确选择）。
polname name 策略名称，唯一不可重复。
polcomments name 策略描述字段，记录策略相关的描述信息，通过COMMENTS关键字体现。
modifydate timestamp 策略创建或修改的最新时间戳。
polenabled boolean 策略启动开关。
