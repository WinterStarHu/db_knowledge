# SQL防火墙系统函数

- gs\_create\_sql\_limit\(limit\_name, limit\_type, work\_node, max\_concurrency, start\_time, end\_time, limit\_opt, databases, users)

描述：新增SQL防火墙规则。

返回值类型：int8

**表 1**  gs\_create\_sql\_limit参数说明

参数类型 参数名 输入参数 limit_name name 规则名称 输入参数 limit_type text 规则类型。支持sqlid、select、update、insert、delete。
输入参数 work_node int1 规则生效节点。0表示生效主/备节点；1表示生效主节点；2表示生效备节点。其他值表示生效备节点。
输入参数 max_concurrency int8 规则最大并发数。-1表示规则不启用；>=0表示限制并发数。
输入参数 start_time timestampTz 规则生效起始时间。NULL表示不限制。
输入参数 end_time timestampTz 规则生效结束时间。NULL表示不限制。
输入参数 limit_opt text[] 规则详细信息。sqlid类型，填写'{722996022}'，表示限制unique_sql_id为722996022的SQL语句。select、update、insert、delete类型，填写'{select,from,t1}'，表示限制执行的SQL语句为select * from t1。
输入参数 databases name[] 规则生效数据库列表。可以为NULL，表示所有数据库生效。
输入参数 users name[] 规则生效用户列表。可以为NULL，表示所有用户生效。系统用户不受规则限制。

- gs\_update\_sql\_limit\(limit\_id, limit\_name, work\_node, max\_concurrency, start\_time, end\_time, limit\_opt, databases, users)

描述：更新SQL防火墙规则。

返回值类型：boolean

**表 2**  gs\_update\_sql\_limit参数说明

参数类型 参数名 输入参数 limit_id int8 规则id。通过gs_sql_limit系统表查询或者gs_select_sql_limit()函数获取。
输入参数 limit_name name 规则名称。

输入参数 work_node int1 规则生效节点。0表示生效主/备节点；1表示生效主节点；2表示生效备节点。其他值表示生效备节点。
输入参数 max_concurrency int8 规则最大并发数。-1表示规则不启用；>=0表示限制并发数。
输入参数 start_time timestampTz 规则生效起始时间。NULL表示不限制。
输入参数 end_time timestampTz 规则生效结束时间。NULL表示不限制。
输入参数 limit_opt text[] 规则详细信息。sqlid类型，填写'{722996022}'，表示限制unique_sql_id为722996022的SQL语句。select、update、insert、delete类型，填写'{select,from,t1}'，表示限制执行的SQL语句为select * from t1。
输入参数 databases name[] 规则生效数据库列表。可以为NULL，表示所有数据库生效。
输入参数 users name[] 规则生效用户列表。可以为NULL，表示所有用户生效。系统用户不受规则限制。

- gs\_select\_sql\_limit(limit\_id)

描述：查询指定limit_id的规则。

返回值类型：boolean

**表 3**  gs\_select\_sql\_limit参数说明

参数类型 参数名 输入参数 limit_id int8 规则id。
输出参数 limit_id int8 规则id。
输出参数 is_valid boolean 规则是否生效。当时间范围无效或最大并发数为负时，值为false。
输出参数 work_node int1 规则生效节点。
输出参数 max_concurrency int8 规则最大并发数。
输出参数 hit_count int8 规则被命中的次数。
输出参数 reject_count int8 拦截SQL的次数。

- gs\_select\_sql\_limit()

描述：查询所有的规则。

返回值类型：boolean

**表 4**  gs\_select\_sql\_limit参数说明

参数类型 参数名 输出参数 limit_id int8 规则id。
输出参数 is_valid boolean 规则是否生效。当时间范围无效或最大并发数为负时，值为false。
输出参数 work_node int1 规则生效节点。
输出参数 max_concurrency int8 规则最大并发数。
输出参数 hit_count int8 规则被命中的次数。
输出参数 reject_count int8 拦截SQL的次数。

- gs\_delete\_sql\_limit(limit\_id)

描述：删除指定id的规则。

返回值类型：boolean

**表 5**  gs\_delete\_sql\_limit参数说明

参数类型 参数名 输入参数 limit_id int8 规则id。
