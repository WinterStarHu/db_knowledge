# 配置设置函数

配置设置函数是可以用于查询以及修改运行时配置参数的函数。

- current\_setting\(setting\_name\)

描述：当前的设置值。

返回值类型：text

备注：current\_setting用于以查询形式获取setting\_name的当前值。和SQL语句SHOW是等效的。比如：

    ```
    openGauss=# SELECT current_setting('datestyle');

     current_setting
    -----------------
     ISO, MDY
    (1 row)
    ```

- set\_working\_grand\_version\_num\_manually\(tmp\_version\)

描述：通过切换授权版本号来更新和升级数据库的新特性。

返回值类型：void

- shell\_in\(type\)

描述： 为shell类型输入路由（那些尚未填充的类型）。

返回值类型：void

- shell\_out\(type\)

描述：为shell 类型输出路由（那些尚未填充的类型）。

返回值类型：void

- set\_config\(setting\_name, new\_value, is\_local\)

描述：设置参数并返回新值。

返回值类型：text

备注：set\_config将参数setting\_name设置为new\_value。如果is\_local为true，则new\_value将只应用于当前事务。如果希望new\_value应用于当前会话，可以使用false，和SQL语句SET是等效的。例如：

    ```
    openGauss=# SELECT set_config('log_statement_stats', 'off', false);

     set_config
    ------------
     off
    (1 row)
    ```

- gs\_get\_hba\_conf\(\)

描述：返回当前hba配置选项。

返回值类型：record

**表 1**  gs\_get\_hba\_conf参数说明

参数类型 参数名 输出参数 type text 连接类型 输出参数 database text 数据库名 输出参数 user text 用户名 输出参数 address text IP 地址范围 输出参数 auth-method text 认证方法

## 示例

    ```
    select * from gs_get_hba_conf();
    type  | database | user |   address    | method
    -------+----------+------+--------------+--------
    local | all      | all  |              | trust
    host  | all      | all  | 127.0.0.1/32 | trust
    host  | all      | all  | ::1/128      | trust
    (4 rows)
    ```
