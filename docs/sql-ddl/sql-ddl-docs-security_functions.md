# 安全函数

## 安全函数

- gs\_encrypt\_aes128\(encryptstr,keystr\)

描述：以keystr为密钥对encryptstr字符串进行加密，返回加密后的字符串。keystr的长度范围为8\~16字节，至少包含3种字符（大写字母、小写字母、数字、特殊字符）。

返回值类型：text

返回值长度：至少为92字节，不超过4\*\[\(Len+68\)/3\]字节，其中Len为加密前数据长度（单位为字节）。

示例：

  ```
  openGauss=# SELECT gs_encrypt_aes128('MPPDB','Asdf1234');

                                 gs_encrypt_aes128
  -------------------------------------------------------------------------------------
  gwditQLQG8NhFw4OuoKhhQJoXojhFlYkjeG0aYdSCtLCnIUgkNwvYI04KbuhmcGZp8jWizBdR1vU9CspjuzI0lbz12A=
  (1 row)
  ```

  >[!NOTE]说明
  >
  >由于该函数的执行过程需要传入解密口令，为了安全起见，gsql工具不会将该函数记录入执行历史。即无法在gsql里通过上下翻页功能找到该函数的执行历史。

- gs\_encrypt\(encryptstr,keystr,encrypttype\)

描述：根据encrypttype，以keystr为密钥对encryptstr字符串进行加密，返回加密后的字符串。keystr的长度范围为8\~16字节，至少包含3种字符（大写字母、小写字母、数字、特殊字符），encrypttype可以是aes128或sm4。

返回值类型：text

示例：

  ```
  openGauss=#  SELECT gs_encrypt('MPPDB','Asdf1234','sm4');
           gs_encrypt
   ------------------------------
   ZBzOmaGA4Bb+coyucJ0B8AkIShqc
  (1 row)
  ```

  >[!NOTE]说明
  >
  >由于该函数的执行过程需要传入解密口令，为了安全起见，gsql工具不会将该函数记录入执行历史。即无法在gsql里通过上下翻页功能找到该函数的执行历史。

- gs\_decrypt\_aes128\(decryptstr,keystr\)

描述：以keystr为密钥对decrypt字符串进行解密，返回解密后的字符串。解密使用的keystr必须保证与加密时使用的keystr一致才能正常解密。keystr不得为空。

  >[!NOTE]说明
  >
  >此参数需要结合gs\_encrypt\_aes128加密函数共同使用。

返回值类型：text

示例：

  ```
  openGauss=# SELECT gs_decrypt_aes128('gwditQLQG8NhFw4OuoKhhQJoXojhFlYkjeG0aYdSCtLCnIUgkNwvYI04KbuhmcGZp8jWizBdR1vU9CspjuzI0lbz12A=','1234');
   gs_decrypt_aes128
  -------------------
   MPPDB
  (1 row)
  ```

  >[!NOTE]说明
  >
  >由于该函数的执行过程需要传入解密口令，为了安全起见，gsql工具不会将该函数记录入执行历史；即无法在gsql里通过上下翻页功能找到该函数的执行历史。

- gs\_decrypt\(decryptstr,keystr,decrypttype\)

描述：根据decrypttype，以keystr为密钥对decrypt字符串进行解密，返回解密后的字符串。解密使用的decrypttype及keystr必须保证与加密时使用的encrypttype及keystr一致才能正常解密。keystr不得为空。decrypttype可以是aes128或sm4。

此函数需要结合gs\_encrypt加密函数共同使用。

返回值类型：text

示例：

  ```
  openGauss=# select gs_decrypt('ZBzOmaGA4Bb+coyucJ0B8AkIShqc','Asdf1234','sm4');
   gs_decrypt
  ------------
   MPPDB
  (1 row)
  ```

  >[!NOTE]说明
  >
  >由于该函数的执行过程需要传入解密口令，为了安全起见，gsql工具不会将该函数记录入执行历史；即无法在gsql里通过上下翻页功能找到该函数的执行历史。

- aes\_encrypt\(str, key\_str, init\_vector\)

描述：基于AES算法，使用密钥字符串key\_str和初始化向量init\_vector对字符串str进行加密。

参数解释：

-- str：需要被加密的字符串。若str为NULL，函数返回NULL。

-- key\_str：密钥字符串。若key\_str为NULL，函数返回NULL。为了安全，对于128bit/192bit/256bit的密钥长度（由块加密模式block\_encryption\_mode确定，参数介绍请参见[安全配置](../database_reference/security_configuration.md)），建议用户使用128bit/192bit/256bit的安全随机数作为密钥字符串。

-- init\_vector：为需要它的块加密模式提供初始化变量，长度大于等于16字节（大于16的字节会被在自动忽略）。str和key\_str均不为NULL时，该参数不可为NULL，否则报错。为了安全，建议用户在OFB模式下，保证每次加密IV值的唯一性；在CBC模式和CFB模式下，保证每次加密的IV值不可被预测。

返回值类型：text

示例：

    ```
    openGauss=# select aes_encrypt('huwei123','123456vfhex4dyu,vdaladhjsadad','1234567890123456');
     aes_encrypt
    -------------
     u*8\x05c?0
    (1 row)
    ```

>[!NOTE]说明
>
>（1）该函数仅在openGauss兼容MY类型时（即sql\_compatibility = 'B'）有效，其他类型不支持该函数。
>
>（2） 由于该函数的执行过程需要传入解密口令，为了安全起见，gsql工具不会将包含该函数名字样的SQL记录入执行历史；即无法在gsql里通过上下翻页功能找到该函数的执行历史。
>
>（3） 在存储过程的相关操作中需尽量避免调用该函数，避免敏感参数信息在日志中泄露的风险。同时建议用户在使用包含该函数的存储过程相关操作时，将该函数的参数信息过滤后再提供给外部维护人员定位，日志使用完后请及时删除。
>
>（4）在打开debug\_print\_plan开关的情况下需尽量避免调用该函数，避免敏感参数信息在日志中泄露的风险。同时建议用户在打开debug\_print\_plan开关生成的日志中对该函数的参数信息进行过滤后再提供给外部维护人员定位，日志使用完后请及时删除。
>
>（5）由于SQL\_ASCII设置与其他设置表现得相当不同。如果服务器字符集是SQL\_ASCII，服务器把字节值0-127根据 ASCII标准解释，而字节值128-255则当作无法解析的字符。如果设置为SQL\_ASCII，就不会有编码转换。该函数调用openssl三方库返回的数据的编码为非ASCII数据，因此当数据库服务端字符集设置为SQL\_ASCII时，客户端编码也需设置为SQL\_ASCII ，否则会报错。因为数据库不会帮助转换或者校验非ASCII字符。

- aes\_decrypt\(pass\_str, key\_str, init\_vector\)

描述：基于AES算法，使用密钥字符串key\_str和初始化向量init\_vector对字符串str进行解密。

参数解释：

-- pass\_str：需要被解密的字符串。若pass\_str为NULL，函数返回NULL。

-- key\_str: 密钥字符串。若key\_str为NULL，函数返回NULL。为了安全，对于128bit/192bit/256bit的密钥长度（由块加密模式block\_encryption\_mode确定，参数介绍请参见[安全配置](../database_reference/security_configuration.md)），建议用户使用128bit/192bit/256bit的安全随机数作为密钥字符串。

-- init\_vector：为需要它的块解密模式提供初始化变量，长度大于等于16字节（大于16的字节会被在自动忽略）。pass\_str和key\_str均不为NULL时，该参数不可为NULL，否则报错。为了安全，建议用户在OFB模式下，保证每次加密IV值的唯一性；在CBC模式和CFB模式下，保证每次加密的IV值不可被预测。

返回值类型：text

示例：

    ```
    openGauss=# select aes_decrypt(aes_encrypt('huwei123','123456vfhex4dyu,vdaladhjsadad','1234567890123456'),'123456vfhex4dyu,vdaladhjsadad','1234567890123456');
     aes_decrypt
    -------------
     huwei123
    (1 row)
    ```

>[!NOTE]说明
>
>（1）该函数仅在openGauss兼容MY类型时（即sql\_compatibility = 'B'）有效，其他类型不支持该函数。
>
>（2） 由于该函数的执行过程需要传入解密口令，为了安全起见，gsql工具不会将包含该函数名字样的SQL记录入执行历史；即无法在gsql里通过上下翻页功能找到该函数的执行历史。
>
>（3） 在存储过程的相关操作中需尽量避免调用该函数，避免敏感参数信息在日志中泄露的风险。同时建议用户在使用包含该函数的存储过程相关操作时，将该函数的参数信息过滤后再提供给外部维护人员定位，日志使用完后请及时删除。
>
>（4）在打开debug\_print\_plan开关的情况下需尽量避免调用该函数，避免敏感参数信息在日志中泄露的风险。同时建议用户在打开debug\_print\_plan开关生成的日志中对该函数的参数信息进行过滤后再提供给外部维护人员定位，日志使用完后请及时删除。
>
>（5）若想成功解密，需要保证block\_encryption\_mode，key\_str，iv值与加密时一致。
>
>（6）由于编码差异，不支持从gsql客户端直接拷贝加密后的数据进行解密，此场景解密出的结果不一定是加密前的字符串。
>
>（7）由于SQL\_ASCII设置与其他设置表现得相当不同。如果服务器字符集是SQL\_ASCII，服务器把字节值0-127根据 ASCII标准解释，而字节值128-255则当作无法解析的字符。如果设置为SQL\_ASCII，就不会有编码转换。该函数调用openssl三方库返回的数据的编码为非ASCII数据，因此当数据库服务端字符集设置为SQL\_ASCII时，客户端编码也需设置为SQL\_ASCII ，否则会报错。因为数据库不会帮助转换或者校验非ASCII字符。

- gs\_password\_deadline

描述：显示当前帐户密码离过期还距离多少天。

返回值类型：interval

示例：

    ```
    openGauss=# SELECT gs_password_deadline();
      gs_password_deadline
    -------------------------
     83 days 17:44:32.196094
    (1 row)
    ```

- gs\_password\_notifytime

描述：显示帐户密码到期前提醒的天数。

返回值类型：int32

- login\_audit\_messages

描述：查看登录用户的登录信息。

返回值类型：元组

示例：

  - 查看上一次登录认证通过的日期、时间和IP等信息。

        ```
        openGauss=> select * from login_audit_messages(true);
         username | database |       logintime        |    mytype     | result | client_conninfo
        ----------+----------+------------------------+---------------+--------+-----------------
         omm      | openGauss | 2020-06-29 21:56:40+08 | login_success | ok     | gsql@[local]
        (1 row)
        ```

  - 查看上一次登录认证失败的日期、时间和IP等信息。

        ```
        openGauss=>  select * from login_audit_messages(false) ORDER BY logintime desc limit 1;
         username | database |       logintime        |    mytype    | result |  client_conninfo
        ----------+----------+------------------------+--------------+--------+-------------------
         omm      | openGauss | 2020-06-29 21:57:55+08 | login_failed | failed | [unknown]@[local]
        (1 row)
        ```

  - 查看自从最后一次认证通过以来失败的尝试次数、日期和时间。

        ```
        openGauss=>  select * from login_audit_messages(false);
         username | database |       logintime        |    mytype    | result |  client_conninfo
        ----------+----------+------------------------+--------------+--------+-------------------
         omm      | openGauss | 2020-06-29 21:57:55+08 | login_failed | failed | [unknown]@[local]
         omm      | openGauss | 2020-06-29 21:57:53+08 | login_failed | failed | [unknown]@[local]
        (2 rows)
        ```

- login\_audit\_messages\_pid

描述：查看登录用户的登录信息。与login\_audit\_messages的区别在于结果基于当前backendid向前查找。所以不会因为同一用户的后续登录，而影响本次登录的查询结果。也就是查询不到该用户后续登录的信息。

返回值类型：元组

示例：

  - 查看上一次登录认证通过的日期、时间和IP等信息。

        ```
        openGauss=> SELECT * FROM login_audit_messages_pid(true);
         username | database |       logintime        |    mytype     | result | client_conninfo |    backendid
        ----------+----------+------------------------+---------------+--------+-----------------+-----------------
         omm      | openGauss | 2020-06-29 21:56:40+08 | login_success | ok     | gsql@[local]    | 139823109633792
        (1 row)
        ```

  - 查看上一次登录认证失败的日期、时间和IP等信息。

        ```
        openGauss=> SELECT * FROM login_audit_messages_pid(false) ORDER BY logintime desc limit 1;
         username | database |       logintime        |    mytype    | result |  client_conninfo  |    backendid
        ----------+----------+------------------------+--------------+--------+-------------------+-----------------
         omm      | openGauss | 2020-06-29 21:57:55+08 | login_failed | failed | [unknown]@[local] | 139823109633792
        (1 row)
        ```

  - 查看自从最后一次认证通过以来失败的尝试次数、日期和时间。

        ```
        openGauss=> SELECT * FROM login_audit_messages_pid(false);
         username | database |       logintime        |    mytype    | result |  client_conninfo  |    backendid
        ----------+----------+------------------------+--------------+--------+-------------------+-----------------
         omm      | openGauss | 2020-06-29 21:57:55+08 | login_failed | failed | [unknown]@[local] | 139823109633792
         omm      | openGauss | 2020-06-29 21:57:53+08 | login_failed | failed | [unknown]@[local] | 139823109633792
        (2 rows)
        ```

- inet\_server\_addr

描述：显示服务器IP信息。

返回值类型：inet

示例：

  ```
  openGauss=# SELECT inet_server_addr();
   inet_server_addr
  ------------------
   10.10.0.13
  (1 row)
  ```

  >[!NOTE]说明
  >
  >- 上面是以客户端在10.10.0.50上，服务器端在10.10.0.13上为例。
  >
  >- 如果是通过本地连接，使用此接口显示为空。

- inet\_client\_addr

描述：显示客户端IP信息。

返回值类型：inet

示例：

  ```
  openGauss=# SELECT inet_client_addr();
   inet_client_addr
  ------------------
   10.10.0.50
  (1 row)
  ```

  >[!NOTE]说明
  >
  >- 上面是以客户端在10.10.0.50上，服务器端在10.10.0.13上为例。
  >
  >- 如果是通过本地连接，使用此接口显示为空。

- pg\_query\_audit

描述：查看数据库主节点审计日志。

返回值类型：record

函数返回字段如下：

time timestamp with time zone 操作时间 type text 操作类型 result text 操作结果 userid oid 用户id username text 执行操作的用户名 database text 数据库名称 client_conninfo text 客户端连接信息 object_name text 操作对象名称 detail_info text 执行操作详细信息 node_name text 节点名称 thread_id text 线程id local_port text 本地端口 remote_port text 远端端口 sha_code text 校验值 verify_result BOOLEAN 校验结果

函数使用方法及示例请参考[查看审计结果](../database_administration_guide/querying_audit_results.md)。

- pg\_delete\_audit

描述：删除指定时间段的审计日志。

返回值类型：void

函数使用方法及示例请参考[维护审计日志](../database_administration_guide/maintaining_audit_logs.md)。
