# DBE\_PLDEBUGGER Schema

DBE\_PLDEBUGGER下系统函数用于单机下调试存储过程，目前支持的接口及其描述如下所示。仅管理员有权限执行这些调试接口，且无权限修改和创建新函数。

>[!TIP]须知
>当在函数体中创建用户时，调用attach、next、continue、 info\_code、step、info\_breakpoint、backtrace、 finish中会返回密码的明文。因此不建议用户在函数体中创建用户。

对应权限角色为gs\_role\_pldebugger，可以由管理员用户通过如下命令将debugger权限赋权给该用户。

```
GRANT gs_role_pldebugger to user;
```

需要有两个客户端连接数据库，一个客户端负责执行调试接口作为debug端，另一个客户端执行调试函数，控制server端存储过程执行。示例如下。

- 准备调试

通过PG\_PROC，查找到待调试存储过程的oid，并执行DBE\_PLDEBUGGER.turn\_on\(oid\)。本客户端就会作为server端使用。调试匿名块时，执行DBE\_PLDEBUGGER.turn\_on\(0\)。

    ```
    openGauss=# CREATE OR REPLACE PROCEDURE test_debug ( IN  x INT)
    AS
    BEGIN
        INSERT INTO t1 (a) VALUES (x);
        DELETE FROM t1 WHERE a = x;
    END;
    /
    CREATE PROCEDURE
    openGauss=# SELECT OID FROM PG_PROC WHERE PRONAME='test_debug';
      oid
    -------
     16389
    (1 row)
    openGauss=# SELECT * FROM DBE_PLDEBUGGER.turn_on(16389);
     nodename | port
    ----------+------
     datanode |    0
    (1 row)
    ```

- 开始调试

server端执行存储过程，会在存储过程内第一条SQL语句前hang住，等待debug端发送的调试消息。仅支持直接执行存储过程的调试，不支持通过trigger调用执行的存储过程调试。匿名块在turn_on后输入执行即可。

    ```
    openGauss=# call test_debug(1);

    # 匿名块
    openGauss=# do $$
    declare
       # declaration_section
    begin
       # executable_section
    end;
    $$
    LANGUAGE plpgsql;
    ```

再起一个客户端，作为debug端，通过turn\_on返回的数据，调用DBE\_PLDEBUGGER.attach关联到该存储过程上进行调试。

    ```
    openGauss=# SELECT * FROM DBE_PLDEBUGGER.attach('datanode',0);
     funcoid |  funcname  | lineno |              query
    ---------+------------+--------+----------------------------------
       16389 | test_debug |      3 |   INSERT INTO t1 (a) VALUES (x);
    (1 row)
    ```

在执行attach的客户端调试，执行下一条statement。

    ```
    openGauss=# SELECT * FROM DBE_PLDEBUGGER.next();
     funcoid |  funcname  | lineno |        query
    ---------+------------+--------+----------------------
       16389 | test_debug |      0 | [EXECUTION FINISHED]
    (1 row)
    ```

在执行attach的客户端调试，可以执行以下变量操作

    ```
    openGauss=# SELECT * FROM DBE_PLDEBUGGER.info_locals(); --打印全部变量
     varname | vartype | value | package_name | isconst
    ---------+---------+-------+--------------+---------
     x       | int4    | 1     |              | f
    (1 row)
    openGauss=# SELECT * FROM DBE_PLDEBUGGER.set_var('x', 2); --变量赋值
     set_var
    ---------
     t
    (1 row)
    openGauss=# SELECT * FROM DBE_PLDEBUGGER.print_var('x'); --打印单个变量
     varname | vartype | value | package_name | isconst
    ---------+---------+-------+--------------+---------
     x       | int4    | 2     |              | f
    (1 row)

    ```

直接执行完成当前正在调试的存储过程。

    ```
    openGauss=# SELECT * FROM DBE_PLDEBUGGER.continue();
     funcoid |  funcname  | lineno |        query
    ---------+------------+--------+----------------------
       16389 | test_debug |      0 | [EXECUTION FINISHED]
    (1 row)
    ```

直接退出当前正在调试的存储过程，不执行尚未执行的语句。

    ```
    openGauss=# SELECT * FROM DBE_PLDEBUGGER.abort();
     abort
    -------
     t
    (1 row)
    ```

client端查看代码信息并识别可以设置断点行号。

    ```
    openGauss=# SELECT * FROM DBE_PLDEBUGGER.info_code(16389);
     lineno |                           query                           | canbreak
    --------+-----------------------------------------------------------+----------
            | CREATE OR REPLACE PROCEDURE public.test_debug( IN  x INT) | f
          1 | AS  DECLARE                                               | f
          2 | BEGIN                                                     | f
          3 |     INSERT INTO t1 (a) VALUES (x);                        | t
          4 |     DELETE FROM t1 WHERE a = x;                           | t
          5 | END;                                                      | f
          6 | /                                                         | f
    (7 rows)
    ```

设置断点。

    ```
    openGauss=# SELECT * FROM DBE_PLDEBUGGER.add_breakpoint(16389,4);
     lineno |                           query                           | canbreak
    --------+-----------------------------------------------------------+----------
            | CREATE OR REPLACE PROCEDURE public.test_debug( IN  x INT) | f
          1 | AS  DECLARE                                               | f
          2 | BEGIN                                                     | f
          3 |     INSERT INTO t1 (a) VALUES (x);                        | t
          4 |     DELETE FROM t1 WHERE a = x;                           | t
          5 | END;                                                      | f
          6 | /                                                         | f
    (7 rows)
    ```

查看断点信息。

    ```
    openGauss=# SELECT * FROM DBE_PLDEBUGGER.info_breakpoints();
     breakpointno | funcoid | lineno |              query              | enable
    --------------+---------+--------+---------------------------------+--------
                0 |   16389 |      4 |     DELETE FROM t1 WHERE a = x; | t
    (1 row)
    ```

执行至断点。

    ```
    openGauss=# SELECT * FROM DBE_PLDEBUGGER.continue();
     funcoid |  funcname  | lineno |              query
    ---------+------------+--------+---------------------------------
       16389 | test_debug |      4 |     DELETE FROM t1 WHERE a = x;
    (1 row)
    ```

存储过程执行结束后，调试会自动退出，再进行调试需要重新attach关联。如果server端不需要继续调试，可执行turn\_off关闭，或退出session。具体调试接口请见下面列表。

**表 1**  DBE\_PLDEBUGGER

接口名称 DBE_PLDEBUGGER.turn_on server端调用，标记存储过程可以调试，调用后执行该存储过程时会hang住等待调试信息。
DBE_PLDEBUGGER.turn_off server端调用，标记存储过程关闭调试。
DBE_PLDEBUGGER.local_debug_server_info server端调用，打印本session内所有已turn_on的存储过程。
DBE_PLDEBUGGER.attach debug端调用，关联到正在调试存储过程。
DBE_PLDEBUGGER.info_locals debug端调用，打印正在调试的存储过程中的变量当前值。
DBE_PLDEBUGGER.next debug端调用，单步执行。
DBE_PLDEBUGGER.continue debug端调用，继续执行，直到断点或存储过程结束。
DBE_PLDEBUGGER.abort debug端调用，停止调试，server端报错长跳转。
DBE_PLDEBUGGER.print_var debug端调用，打印正在调试的存储过程中指定的变量当前值。
DBE_PLDEBUGGER.info_code debug和server端都可以调用，打印指定存储过程的源语句和各行对应的行号。info_code(0)可查看正在调试中的匿名块源语句和各行对应的行号。
DBE_PLDEBUGGER.step debug端调用，单步进入执行。
DBE_PLDEBUGGER.add_breakpoint debug端调用，新增断点。
DBE_PLDEBUGGER.delete_breakpoint debug端调用，删除断点。
DBE_PLDEBUGGER.info_breakpoints debug端调用，查看当前的所有断点。
DBE_PLDEBUGGER.backtrace debug端调用，查看当前的调用栈。
DBE_PLDEBUGGER.enable_breakpoint debug端调用，激活被禁用的断点。
DBE_PLDEBUGGER.disable_breakpoint debug端调用，禁用已激活的断点。
DBE_PLDEBUGGER.finish debug端调用，继续调试，直到断点或返回上一层调用栈。
DBE_PLDEBUGGER.set_var debug端调用，为变量进行赋值操作。
