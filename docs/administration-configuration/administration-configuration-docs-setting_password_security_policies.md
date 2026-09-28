# 设置密码安全策略

## 操作步骤

用户密码存储在系统表pg\_authid中，为防止用户密码泄露，openGauss对用户密码进行加密存储，所采用的加密算法由配置参数password\_encryption\_type决定。

- 当参数password\_encryption\_type设置为0时，表示采用md5方式对密码加密。MD5加密算法安全性低，存在安全风险，不建议使用。
- 当参数password\_encryption\_type设置为1时，表示采用sha256和md5方式对密码加密。MD5加密算法安全性低，存在安全风险，不建议使用。
- 当参数password\_encryption\_type设置为2时，表示采用sha256方式对密码加密，为默认配置。
- 当参数password\_encryption\_type设置为3时，表示采用sm3方式对密码加密。

1. 以操作系统用户omm登录数据库主节点。

2. 使用如下命令连接数据库。

    ```
    gsql -d postgres -p 8000
    ```

postgres为需要连接的数据库名称，8000为数据库主节点的端口号。

连接成功后，系统显示类似如下信息：

    ```
    gsql ((openGauss x.x.x build 50dc16a6) compiled at 2020-11-29 05:49:21 commit 1071 last mr 1373)
    Non-SSL connection (SSL connection is recommended when requiring high-security)
    Type "help" for help.

    openGauss=#
    ```

3. 查看已配置的加密算法。

    ```
    openGauss=# SHOW password_encryption_type;
     password_encryption_type
    --------------------------
     2
    (1 row)
    ```

如果显示结果为0或1，执行“\\q”命令退出数据库。

4. 执行如下命令将其设置为安全的加密算法。

    ```
    gs_guc reload -N all -I all -c "password_encryption_type=2"
    ```

>[!TIP]须知
>为防止用户密码泄露，在执行CREATE USER/ROLE命令创建数据库用户时，不能指定UNENCRYPTED属性，即新创建的用户的密码只能是加密存储的。

5. 配置密码安全参数。

  - 密码复杂度

初始化数据库、创建用户、修改用户时需要指定密码。密码必须要符合复杂度（[password\_policy](../database_reference/security_and_authentication_postgresql_conf.md#zh-cn_topic_0237124696_zh-cn_topic_0059778664_s3db9d0a21a4d48b98ea4afc1f2e44626)）的要求，否则会提示用户重新输入密码。

  - 参数password\_policy设置为1时表示采用密码复杂度校验，默认值。
  - 参数password\_policy设置为0时表示不采用密码复杂度校验，但需满足密码不能为空并且只包含有效字符，有效字符范围为大写字母（A-Z）、小写字母（a-z）、数字（0-9）及特殊字符详见[表1](#zh-cn_topic_0283137010_zh-cn_topic_0237121110_zh-cn_topic_0151096202_zh-cn_topic_0085033092_zh-cn_topic_0059779155_t850059f5d3e64bc78857b77fc8ffbba8)。设置为0会存在安全风险，不建议设置为0，即使需要设置也要将所有openGauss节点中的password\_policy都设置为0才能生效。

配置password\_policy参数。

  1. 使用如下命令连接数据库。

        ```
        gsql -d postgres -p 8000
        ```

postgres为需要连接的数据库名称，8000为数据库主节点的端口号。

连接成功后，系统显示类似如下信息：

        ```
        gsql ((openGauss x.x.x build 50dc16a6) compiled at 2020-11-29 05:49:21 commit 1071 last mr 1373)
        Non-SSL connection (SSL connection is recommended when requiring high-security)
        Type "help" for help.

        openGauss=#
        ```

  2. 查看已配置的参数。

        ```
        openGauss=# SHOW password_policy;
         password_policy
        ---------------------
         1
        (1 row)
        ```

如果显示结果不为1，执行“\\q”命令退出数据库。

  3. 执行如下命令设置成默认值1。

        ```
        gs_guc reload -N all -I all -c "password_policy=1"
        ```

> [!NOTE]说明
>
> 帐户密码的复杂度要求如下：
>
> - 包含大写字母（A-Z）的最少个数（password\_min\_uppercase）
> - 包含小写字母（a-z）的最少个数（password\_min\_lowercase）
> - 包含数字（0-9）的最少个数（password\_min\_digital）
> - 包含特殊字符的最少个数（password\_min\_special）（特殊字符的列表请参见[表1](#zh-cn_topic_0283137010_zh-cn_topic_0237121110_zh-cn_topic_0151096202_zh-cn_topic_0085033092_zh-cn_topic_0059779155_t850059f5d3e64bc78857b77fc8ffbba8)）
> - 密码的最小长度（password\_min\_length）
> - 密码的最大长度（password\_max\_length）
> - 至少包含上述四类字符中的三类。
> - 不能和用户名、用户名倒写相同，本要求为非大小写敏感。
> - 不能和当前密码、当前密码的倒写相同。
> - 不能是弱口令。
> - 弱口令指的是强度较低，容易被破解的密码，对于不同的用户或群体，弱口令的定义可能会有所区别，用户需自己添加定制化的弱口令。
> - 弱口令字典中的口令存放在gs\_global\_config系统表中，当创建用户、修改用户需要设置密码时，系统将会把用户设置口令和弱口令字典中存放的口令进行对比，如果符合，则会提示用户该口令为弱口令，设置密码失败。
> - 弱口令字典默认为空，用户通过以下语法可以对弱口令字典进行增加和删除，示例如下：
>
> ```
> openGauss=# CREATE WEAK PASSWORD DICTIONARY WITH VALUES ('password1'), ('password2');
> openGauss=# DROP WEAK PASSWORD DICTIONARY;
> ```

  - 密码重用

用户修改密码时，只有超过不可重用天数（[password\_reuse\_time](../database_reference/security_and_authentication_postgresql_conf.md#zh-cn_topic_0237124696_zh-cn_topic_0059778664_s36625909efc14a42af3e142435ae9794)）或不可重用次数（[password\_reuse\_max](../database_reference/security_and_authentication_postgresql_conf.md#zh-cn_topic_0237124696_zh-cn_topic_0059778664_scad28ae18dfc4557b10f51bf147a9e53)）的密码才可以使用。参数配置说明如[表2](#zh-cn_topic_0283137010_zh-cn_topic_0237121110_zh-cn_topic_0151096202_zh-cn_topic_0085033092_zh-cn_topic_0059779155_t2013c9d251bc4cf5be274ef279c4faee)所示。

>[!NOTE]说明
>不可重用天数默认值为60天，不可重用次数默认值是0。这两个参数值越大越安全，但是在使用过程中会带来不便，其默认值符合安全标准，用户可以根据需要重新设置参数，提高安全等级。

配置password\_reuse\_time参数。

  1. 使用如下命令连接数据库。

        ```
        gsql -d postgres -p 8000
        ```

postgres为需要连接的数据库名称，8000为数据库主节点的端口号。

连接成功后，系统显示类似如下信息：

        ```
        gsql ((openGauss x.x.x build 50dc16a6) compiled at 2020-11-29 05:49:21 commit 1071 last mr 1373)
        Non-SSL connection (SSL connection is recommended when requiring high-security)
        Type "help" for help.

        openGauss=#
        ```

  2. 查看已配置的参数。

        ```
        openGauss=# SHOW password_reuse_time;
         password_reuse_time
        ---------------------
         60
        (1 row)
        ```

如果显示结果不为60，执行“\\q”命令退出数据库。

  3. 执行如下命令设置成默认值60。

>[!NOTE]说明
>不建议设置为0，即使需要设置也要将所有openGauss节点中的password\_reuse\_time都设置为0才能生效。

        ```
        gs_guc reload -N all -I all -c "password_reuse_time=60"
        ```

配置password\_reuse\_max参数。

  1. 使用如下命令连接数据库。

        ```
        gsql -d postgres -p 8000
        ```

postgres为需要连接的数据库名称，8000为数据库主节点的端口号。

连接成功后，系统显示类似如下信息：

        ```
        gsql ((openGauss x.x.x build 50dc16a6) compiled at 2020-11-29 05:49:21 commit 1071 last mr 1373)
        Non-SSL connection (SSL connection is recommended when requiring high-security)
        Type "help" for help.

        openGauss=#
        ```

  2. 查看已配置的参数。

        ```
        openGauss=# SHOW password_reuse_max;
        password_reuse_max
        --------------------
        0
        (1 row)
        ```

如果显示结果不为0，执行“\\q”命令退出数据库。

  3. 执行如下命令设置成默认值0。

        ```
        gs_guc reload -N all -I all -c "password_reuse_max = 0"
        ```

  - 密码有效期限

数据库用户的密码都有密码有效期（[password\_effect\_time](../database_reference/security_and_authentication_postgresql_conf.md#zh-cn_topic_0237124696_zh-cn_topic_0059778664_sfcc6124115734728917a548a8bd8f0d4)），当达到密码到期提醒天数（[password\_notify\_time](../database_reference/security_and_authentication_postgresql_conf.md#zh-cn_topic_0237124696_zh-cn_topic_0059778664_s1beab889ab8d49848ef28bf60c10d8f7)）时，系统会在用户登录数据库时提示用户修改密码。

>[!NOTE]说明
>考虑到数据库使用特殊性及业务连续性，密码过期后用户还可以登录数据库，但是每次登录都会提示修改密码，直至修改为止。

配置password\_effect\_time参数。

  1. 使用如下命令连接数据库。

        ```
        gsql -d postgres -p 8000
        ```

postgres为需要连接的数据库名称，8000为数据库主节点的端口号。

连接成功后，系统显示类似如下信息：

        ```
        gsql ((openGauss x.x.x build 50dc16a6) compiled at 2020-11-29 05:49:21 commit 1071 last mr 1373)
        Non-SSL connection (SSL connection is recommended when requiring high-security)
        Type "help" for help.

        openGauss=#
        ```

  2. 查看已配置的参数。

        ```
        openGauss=# SHOW password_effect_time;
         password_effect_time
        ----------------------
         90
        (1 row)
        ```

如果显示结果不为90，执行“\\q”命令退出数据库。

  3. 执行如下命令设置成默认值90（不建议设置为0）。

        ```
        gs_guc reload -N all -I all -c "password_effect_time = 90"
        ```

配置password_notify_time参数。

  1. 使用如下命令连接数据库。

        ```
        gsql -d postgres -p 8000
        ```

postgres为需要连接的数据库名称，8000为数据库主节点的端口号。

连接成功后，系统显示类似如下信息：

        ```
        gsql ((openGauss x.x.x build 50dc16a6) compiled at 2020-11-29 05:49:21 commit 1071 last mr 1373)
        Non-SSL connection (SSL connection is recommended when requiring high-security)
        Type "help" for help.

        openGauss=#
        ```

  2. 查看已配置的参数。

        ```
        openGauss=# SHOW password_notify_time;
        password_notify_time
        ----------------------
        7
        (1 row)
        ```

  3. 如果显示结果不为7，执行如下命令设置成默认值7（不建议设置为0）。

        ```
        gs_guc reload -N all -I all -c "password_notify_time = 7"
        ```

  - 密码修改

  - 在安装数据库时，会新建一个和初始化用户重名的操作系统用户，为了保证帐户安全，请定期修改操作系统用户的密码。

以修改用户user1密码为例，命令格式如下：

       ```
       passwd user1
       ```

根据提示信息完成修改密码操作。

  - 建议系统管理员和普通用户都要定期修改自己的帐户密码，避免帐户密码被非法窃取。

以修改用户user1密码为例，以系统管理员用户连接数据库并执行如下命令：

       ```
       openGauss=# ALTER USER user1 IDENTIFIED BY "$$$$$$$$" REPLACE "XXXXXXXX";
       ALTER ROLE
       ```

>[!NOTE]说明
>$$$$$$$$、XXXXXXXX分别代表用户user1的新密码和原始密码，这些密码要符合规则，否则会执行失败。

  - 管理员可以修改自己的或者其他帐户的密码。通过修改其他帐户的密码，解决用户密码遗失所造成无法登录的问题。

以修改用户joe帐户密码为例，命令格式如下：

       ```
       openGauss=# ALTER USER joe IDENTIFIED BY "abc@1234";
       ALTER ROLE
       ```

>[!NOTE]说明
>
>- 系统管理员之间不允许互相修改对方密码。
>- 系统管理员可以修改普通用户密码且不需要用户原密码。
>- 系统管理员修改自己密码但需要管理员原密码。

  - 密码验证

设置当前会话的用户和角色时，需要验证密码。如果输入密码与用户的存储密码不一致，则会报错。

以设置用户joe为例，命令格式如下：

     ```
     openGauss=# SET ROLE joe PASSWORD "xxxxxx";
     ERROR:  Invalid username/password,set role denied.
     ```

**表 1**  特殊字符

&lt;
&gt;
&amp;

**表 2**  不可重用天数和不可重用次数参数说明

取值范围 配置说明 不可重用天数（password_reuse_time） 正数或0，其中整数部分表示天数，小数部分可以换算成时，分，秒。
默认值为60。
如果参数变小，则后续修改密码按新的参数进行检查。如果参数变大（比如由a变大为b），因为b天之前的历史密码可能已经删除，所以b天之前的密码仍有可能被重用。则后续修改密码按新的参数进行检查。
不可重用次数（password_reuse_max） 正整数或0。
默认值为0，表示不检查重用次数。
如果参数变小，则后续修改密码按新的参数进行检查。如果参数变大（比如由a变大为b），因为b次之前的历史密码可能已经删除，所以b次之前的密码仍有可能被重用。则后续修改密码按新的参数进行检查。

6. 设置用户密码失效。

具有CREATEROLE权限的用户在创建用户时可以强制用户密码失效，新用户首次登录数据库后需要修改密码才允许执行其他查询操作，命令格式如下：

   ```
   openGauss=# CREATE USER joe PASSWORD "xxxxxx" EXPIRED;
   CREATE ROLE
   ```

具有CREATEROLE权限的用户可以强制用户密码失效或者强制修改密码且失效，命令格式如下：

   ```
   openGauss=# ALTER USER joe PASSWORD EXPIRED;
   ALTER ROLE
   ```

   ```
   openGauss=# ALTER USER joe PASSWORD "xxxxxx" EXPIRED;
   ALTER ROLE
   ```

>[!NOTE]说明
>
>- 密码失效的用户登录数据库后，当执行简单查询或者扩展查询时，会提示用户修改密码。修改密码后可以正常执行语句。
>
>- 只有初始用户、系统管理员（sysadmin）或拥有创建用户（CREATEROLE）权限的用户才可以设置用户密码失效，其中系统管理员也可以设置自己或其他系统管理员密码失效。不允许设置初始用户密码失效。
