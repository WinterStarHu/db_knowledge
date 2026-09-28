# PKG\_SERVICE

PKG\_SERVICE支持的所有接口请参见[表1](#table35465232913)。

**表 1**  PKG\_SERVICE

接口名称 PKG_SERVICE.SQL_IS_CONTEXT_ACTIVE 确认该CONTEXT是否已注册。
PKG_SERVICE.SQL_CLEAN_ALL_CONTEXTS 取消所有注册的CONTEXT。
PKG_SERVICE.SQL_REGISTER_CONTEXT 注册一个CONTEXT。
PKG_SERVICE.SQL_UNREGISTER_CONTEXT 取消注册该CONTEXT。
PKG_SERVICE.SQL_SET_SQL 向CONTEXT设置一条SQL语句，目前只支持SELECT。
PKG_SERVICE.SQL_RUN 在一个CONTEXT上执行设置的SQL语句。
PKG_SERVICE.SQL_NEXT_ROW 读取该CONTEXT中的下一行数据。
PKG_SERVICE.SQL_GET_VALUE 读取该CONTEXT中动态定义的列值 PKG_SERVICE.SQL_SET_RESULT_TYPE 根据类型OID动态定义该CONTEXT的一个列。
PKG_SERVICE.JOB_CANCEL 通过任务ID来删除定时任务。
PKG_SERVICE.JOB_FINISH 禁用或者启用定时任务。
PKG_SERVICE.JOB_SUBMIT 提交一个定时任务。作业号由系统自动生成或由用户指定。
PKG_SERVICE.JOB_UPDATE 修改定时任务的属性，包括任务内容、下次执行时间、执行间隔。
PKG_SERVICE.SUBMIT_ON_NODES 提交一个任务到所有节点，作业号由系统自动生成。
PKG_SERVICE.ISUBMIT_ON_NODES 提交一个任务到所有节点，作业号由用户指定。
PKG_SERVICE.SQL_GET_ARRAY_RESULT 获取该CONTEXT中返回的数组值。
PKG_SERVICE.SQL_GET_VARIABLE_RESULT 获取该CONTEXT中返回的列值。

- PKG\_SERVICE.SQL\_IS\_CONTEXT\_ACTIVE

该函数用来确认一个CONTEXT是否已注册。该函数传入想查找的CONTEXT ID，如果该CONTEXT存在返回TRUE，反之返回FALSE。

PKG\_SERVICE.SQL\_IS\_CONTEXT\_ACTIVE函数原型为：

    ```
    PKG_SERVICE.SQL_IS_CONTEXT_ACTIVE(
     context_id     IN INTEGER
    )
    RETURN BOOLEAN;
    ```

**表 2**  PKG\_SERVICE.SQL\_IS\_CONTEXT\_ACTIVE接口说明

参数名称 context_id 想查找的CONTEXT ID号

- PKG\_SERVICE.SQL\_CLEAN\_ALL\_CONTEXTS

该函数用来取消所有CONTEXT

PKG\_SERVICE.SQL\_CLEAN\_ALL\_CONTEXTS函数原型为：

    ```
    PKG_SERVICE.SQL_CLEAN_ALL_CONTEXTS(
    )
    RETURN VOID;
    ```

- PKG\_SERVICE.SQL\_REGISTER\_CONTEXT

该函数用来打开一个CONTEXT，是后续对该CONTEXT进行各项操作的前提。该函数不传入任何参数，内部自动递增生成CONTEXT ID，并作为返回值返回给integer定义的变量。

PKG\_SERVICE.SQL\_REGISTER\_CONTEXT函数原型为：

    ```
    DBE_SQL.REGISTER_CONTEXT(
    )
    RETURN INTEGER;
    ```

- PKG\_SERVICE.SQL\_UNREGISTER\_CONTEXT

该函数用来关闭一个CONTEXT，是该CONTEXT中各项操作的结束。如果在存储过程结束时没有调用该函数，则该CONTEXT占用的内存仍然会保存，因此关闭CONTEXT非常重要。由于异常情况的发生会中途退出存储过程，导致CONTEXT未能关闭，因此建议存储过程中有异常处理，将该接口包含在内。

PKG\_SERVICE.SQL\_UNREGISTER\_CONTEXT函数原型为：

    ```
    PKG_SERVICE.SQL_UNREGISTER_CONTEXT(
     context_id     IN INTEGER
    )
    RETURN INTEGER;
    ```

**表 3**  PKG\_SERVICE.SQL\_UNREGISTER\_CONTEXT接口说明

参数名称 context_id 打算关闭的CONTEXT ID号

- PKG\_SERVICE.SQL\_SET\_SQL

该函数用来解析给定游标的查询语句，被传入的查询语句会立即执行。目前仅支持SELECT查询语句的解析，且语句参数仅可通过text类型传递，长度不大于1G。

PKG\_SERVICE.SQL\_SET\_SQL函数的原型为：

    ```
    PKG_SERVICE.SQL_SET_SQL(
    context_id     IN INTEGER,
    query_string   IN TEXT,
    language_flag  IN INTEGER
    )
    RETURN BOOLEAN;
    ```

**表 4**  PKG\_SERVICE.SQL\_SET\_SQL接口说明

参数名称 context_id 执行查询语句解析的CONTEXT ID query_string 执行的查询语句 language_flag 版本语言号，目前只支持1

- PKG\_SERVICE.SQL\_RUN

该函数用来执行一个给定的CONTEXT。该函数接收一个CONTEXT ID，运行后获得的数据用于后续操作。目前仅支持SELECT查询语句的执行。

PKG\_SERVICE.SQL\_RUN函数的原型为：

    ```
    PKG_SERVICE.SQL_RUN(
    context_id     IN INTEGER,
    )
    RETURN INTEGER;
    ```

**表 5**  PKG\_SERVICE.SQL\_RUN接口说明

参数名称 context_id 执行查询语句解析的CONTEXT ID

- PKG\_SERVICE.SQL\_NEXT\_ROW

该函数返回符合查询条件的数据行数，每一次运行该接口都会获取到新的行数的集合，直到数据读取完毕获取不到新行为止。

PKG\_SERVICE.SQL\_NEXT\_ROW函数的原型为：

    ```
    PKG_SERVICE.SQL_NEXT_ROW(
    context_id     IN INTEGER,
    )
    RETURN INTEGER;
    ```

**表 6**  PKG\_SERVICE.SQL\_NEXT\_ROW接口说明

参数名称 context_id 执行的CONTEXT ID

- PKG\_SERVICE.SQL\_GET\_VALUE

该函数用来返回给定CONTEXT中给定位置的CONTEXT元素值，该接口访问的是PKG\_SERVICE.SQL\_NEXT\_ROW获取的数据。

PKG\_SERVICE.SQL\_GET\_VALUE函数的原型为：

    ```
    PKG_SERVICE.SQL_GET_VALUE(
    context_id          IN    INTEGER,
    pos                 IN    INTEGER,
    col_type            IN    ANYELEMENT
    )
    RETURN ANYELEMENT;
    ```

**表 7**  PKG\_SERVICE.SQL\_GET\_VALUE接口说明

参数名称 context_id 执行的CONTEXT ID pos 动态定义列在查询中的位置 col_type 任意类型变量，定义列的返回值类型

- PKG\_SERVICE.SQL\_SET\_RESULT\_TYPE

该函数用来定义从给定CONTEXT返回的列，该接口只能应用于SELECT定义的CONTEXT中。定义的列通过查询列表的相对位置来标识，PKG\_SERVICE.SQL\_SET\_RESULT\_TYPE函数的原型为：

    ```
    PKG_SERVICE.SQL_SET_RESULT_TYPE(
    context_id     IN INTEGER,
    pos            IN INTEGER,
    coltype_oid    IN ANYELEMENT,
    maxsize        IN INTEGER
    )
    RETURN INTEGER;
    ```

**表 8**  PKG\_SERVICE.SQL\_SET\_RESULT\_TYPE接口说明

参数名称 context_id 执行的CONTEXT ID。
pos 动态定义列在查询中的位置。
coltype_oid 任意类型的变量，可根据变量类型得到对应类型OID。
maxsize 定义的列的长度。

- PKG\_SERVICE.JOB\_CANCEL

存储过程CANCEL删除指定的定时任务。

PKG\_SERVICE.JOB\_CANCEL函数原型为：

    ```
    PKG_SERVICE.JOB_CANCEL(
    job  IN  INTEGER);
    ```

**表 9**  PKG\_SERVICE.JOB\_CANCEL接口参数说明

入参/出参 是否可以为空 integer 指定的作业号。

示例：

    ```
    CALL PKG_SERVICE.JOB_CANCEL(101);
    ```

- PKG\_SERVICE.JOB\_FINISH

存储过程FINISH禁用或者启用定时任务。

PKG\_SERVICE.JOB\_FINISH函数原型为：

    ```
    PKG_SERVICE.JOB_FINISH(
    id          IN   INTEGER,
    finished      IN   BOOLEAN,
    next_time    IN   TIMESTAMP  DEFAULT  sysdate);
    ```

**表 10**  PKG\_SERVICE.JOB\_FINISH接口参数说明

入参/出参 是否可以为空 integer 指定的作业号。
finished Boolean 状态标志位，true代表禁用，false代表启用。根据true或false值更新当前job；如果为空值，则不改变原有job的状态。
next_time timestamp 下次运行时间，默认为当前系统时间。如果参数broken状态为true，则更新该参数为'4000-1-1'；如果参数broken状态为false，且如果参数next_time不为空值，则更新指定job的next_time值，如果next_time为空值，则不更新next_time值。该参数可以省略，为默认值。

- PKG\_SERVICE.JOB\_SUBMIT

存储过程JOB\_SUBMIT提交一个系统提供的定时任务。

PKG\_SERVICE.JOB\_SUBMIT函数原型为：

    ```
    PKG_SERVICE.JOB_SUBMIT(
    id            IN   BIGINT DEFAULT,
    content       IN   TEXT,
    next_date     IN   TIMESTAMP DEFAULT sysdate,
    interval_time IN   TEXT  DEFAULT 'null',
    job           OUT  INTEGER);
    ```

>[!NOTE]说明
>当创建一个定时任务（JOB）时，系统默认将当前数据库和用户名与当前创建的定时任务绑定起来。该接口函数可以通过call或select调用，如果通过select调用，可以不填写出参。如果在存储过程中，则需要通过perform调用该接口函数。如果提交的sql语句任务使用到非public的schema，应该指定表或者函数的schema，或者在sql语句前添加set current\_schema = xxx;语句。

>**注意：** 在创建定时任务时，默认的sysdate为创建该定时任务所对应的客户端时间，而非服务器时间。例如服务器有默认参数timezone='US/Eastern'，当我们在客户端中修改了timezone=PRC后，创建定时任务的sysdate的时间就变成了PRC时区下对应的时间。

**表 11**  PKG\_SERVICE.JOB\_SUBMIT接口参数说明

入参/出参 是否可以为空 bigint 作业号。如果传入id为NULL，则内部会生成作业ID。
context text 要执行的SQL语句。支持一个或多个‘DML’，‘匿名块’，‘调用存储过程的语句’或3种混合的场景。
next_time timestamp 下次作业运行时间。默认值为当前系统时间（sysdate）。如果是过去时间，在提交作业时表示立即执行。
interval_time text 用来计算下次作业运行时间的时间表达式，可以是interval表达式，也可以是sysdate加上一个numeric值（例如：sysdate+1.0/24）。如果为空值或字符串"null"表示只执行一次，执行后JOB状态STATUS变成'd' 不再执行。
job integer OUT 作业号。范围为1～32767。当使用select调用pkg_service.job_submit时，该参数可以省略。

示例：

    ```

    SELECT PKG_SERVICE.JOB_SUBMIT(NULL,'callpro_xxx();',to_date('20180101', 'yyyymmdd'),'sysdate()');

    SELECT PKG_SERVICE.JOB_SUBMIT(NULL,'callpro_xxx();',to_date('20180101', 'yyyymmdd'),'sysdate() ,0/24');

    CALL PKG_SERVICE.JOB_SUBMIT(NULL, 'INSERT INTO T_JOB  VALUES(1);  call pro_1(); call pro_2();', add_months(to_date('201701','yyyymm'),1), 'date_trunc(''day'',SYSDATE) + 1 +(8*60+30.0)/(24*60)' ,:jobid);

    SELECT PKG_SERVICE.JOB_SUBMIT (101, 'insert_msg_statistic1;', sysdate, 'sysdate+3.0/24');
    ```

- PKG\_SERVICE.JOB\_UPDATE

存储过程UPDATE修改定时任务的属性，包括任务内容、下次执行时间、执行间隔。

PKG\_SERVICE.JOB\_UPDATE函数原型为：

    ```
    PKG_SERVICE.JOB_UPDATE(
    id             IN   BIGINT,
    next_time      IN   TIMESTAMP,
    interval_time  IN   TEXT,
    content        IN   TEXT);
    ```

**表 12**  PKG\_SERVICE.JOB\_UPDATE接口参数说明

入参/出参 是否可以为空 integer 指定的作业号。
next_time timestamp 下次运行时间。如果该参数为空值，则不更新指定job的next_time值，否则更新指定job的next_time值。
interval_time text 用来计算下次作业运行时间的时间表达式。如果该参数为空值，则不更新指定job的interval_time值；如果该参数不为空值，会校验interval_time是否为有效的时间类型或interval类型，则更新指定job的interval_time值。如果为字符串"null"表示只执行一次，执行后JOB状态STATUS变成'd' 不再执行。
content text 执行的存储过程名或者sql语句块。如果该参数为空值，则不更新指定job的content值，否则更新指定job的content值。

示例：

    ```
    CALL PKG_SERVICE.JOB_UPDATE(101, 'call userproc();', sysdate, 'sysdate + 1.0/1440');
    CALL PKG_SERVICE.JOB_UPDATE(101, 'insert into tbl_a values(sysdate);', sysdate, 'sysdate + 1.0/1440');
    ```

- PKG\_SERVICE.SUBMIT\_ON\_NODES

存储过程SUBMIT\_ON\_NODES创建一个结点上的定时任务，仅sysadmin/monitor admin有此权限。

PKG\_SERVICE.SUBMIT\_ON\_NODES函数原型为：

    ```
    PKG_SERVICE.SUBMIT_ON_NODES(
    node_name    IN   TEXT,
    database     IN   TEXT
    what         IN   TEXT,
    next_date    IN   TIMESTAMP DEFAULT sysdate,
    job_interval IN   TEXT  DEFAULT 'null',
    job          OUT  INTEGER);
    ```

**表 13**  PKG\_SERVICE.SUBMIT\_ON\_NODES接口参数说明

入参/出参 是否可以为空 node_name text 指定作业的执行节点，当前仅支持值为'ALL_NODE'（在所有节点执行）与'CCN'（注：CCN在集中式/小型化环境下无意义）。
database text 数据库实例作业所使用的database，节点类型为'ALL_NODE'时仅支持值为'postgres'。
what text 要执行的SQL语句。支持一个或多个‘DML’，‘匿名块’，‘调用存储过程的语句’或3种混合的场景。
nextdate timestamp 下次作业运行时间。默认值为当前系统时间（sysdate）。如果是过去时间，在提交作业时表示立即执行。
job_interval text 用来计算下次作业运行时间的时间表达式，可以是interval表达式，也可以是sysdate加上一个numeric值（例如：sysdate+1.0/24）。如果为空值或字符串"null"表示只执行一次，执行后JOB状态STATUS变成'd'不再执行。
job integer OUT 作业号。范围为1～32767。当使用select调用dbms.submit_on_nodes时，该参数可以省略。

示例：

    ```
    select pkg_service.submit_on_nodes('ALL_NODE', 'postgres', 'select capture_view_to_json(''dbe_perf.statement'', 0);', sysdate, 'interval ''60 second''');
    select pkg_service.submit_on_nodes('CCN', 'postgres', 'select capture_view_to_json(''dbe_perf.statement'', 0);', sysdate, 'interval ''60 second''');
    ```

- PKG\_SERVICE.ISUBMIT\_ON\_NODES

ISUBMIT\_ON\_NODES与SUBMIT\_ON\_NODES语法功能相同，但其第一个参数是入参，即指定的作业号，SUBMIT最后一个参数是出参，表示系统自动生成的作业号。仅sysadmin/monitor admin有此权限。

- PKG\_SERVICE.SQL\_GET\_ARRAY\_RESULT

该函数用来返回绑定的数组类型的OUT参数的值，可以用来获取存储过程中的OUT参数。

PKG\_SERVICE.SQL\_GET\_ARRAY\_RESULT函数原型为：

    ```
    PKG_SERVICE.SQL_GET_ARRAY_RESULT(
        context_id in int,
        pos in VARCHAR2,
        column_value inout anyarray,
        result_type in anyelement
    );
    ```

**表 14**  PKG\_SERVICE.SQL\_GET\_ARRAY\_RESULT接口说明

参数名称 context_id 想查找的CONTEXT ID号。
pos 绑定的参数名。
column_value 返回值。
result_type 返回值类型。

- PKG\_SERVICE.SQL\_GET\_VARIABLE\_RESULT

该函数用来返回绑定的非数组类型的OUT参数的值，可以用来获取存储过程中的OUT参数。

PKG\_SERVICE.SQL\_GET\_VARIABLE\_RESULT函数原型为：

    ```
    PKG_SERVICE.SQL_GET_VARIABLE_RESULT(
        context_id in int,
        pos in VARCHAR2,
        result_type in anyelement
    )
    RETURNS anyelement;
    ```

**表 15**  PKG\_SERVICE.SQL\_GET\_VARIABLE\_RESULT接口说明

参数名称 context_id 想查找的CONTEXT ID号。
pos 绑定的参数名。
result_type 返回值类型。
