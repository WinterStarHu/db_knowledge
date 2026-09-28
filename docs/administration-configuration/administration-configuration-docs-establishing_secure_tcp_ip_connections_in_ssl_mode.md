# 用SSL进行安全的TCP/IP连接

## 背景信息

openGauss支持SSL标准协议（TLS 1.2），SSL协议是安全性更高的协议标准，它们加入了数字签名和数字证书来实现客户端和服务器的双向身份验证，保证了通信双方更加安全的数据传输。

## 前提条件

从CA认证中心申请到正式的服务器、客户端的证书和密钥。（假设服务器的私钥为server.key，证书为server.crt，客户端的私钥为client.key，证书为client.crt，CA根证书名称为cacert.pem。）

## 注意事项

- 当用户远程连接到数据库主节点时，需要使用sha256的认证方式。
- 当内部服务器之间连接时，需要使用trust的认证方式，支持IP白名单认证。

## 操作步骤

openGauss在数据库部署完成后，默认已开启SSL认证模式。服务器端证书，私钥以及根证书已经默认配置完成。用户需要配置客户端的相关参数。

配置SSL认证相关的数字证书参数，具体要求请参见[表1](#zh-cn_topic_0283137035_zh-cn_topic_0237121092_zh-cn_topic_0059778374_table56811076112938)。

- 配置客户端参数。

已从CA认证中心申请到客户端默认证书，私钥，根证书以及私钥密码加密文件。假设证书、私钥和根证书都放在“/home/omm”目录。

双向认证需配置如下参数：

    ```
    export PGSSLCERT="/home/omm/client.crt"
    export PGSSLKEY="/home/omm/client.key"
    export PGSSLMODE="verify-ca"
    export PGSSLROOTCERT="/home/omm/cacert.pem"
    ```

单向认证需要配置如下参数：

    ```
    export PGSSLMODE="verify-ca"
    export PGSSLROOTCERT="/home/omm/cacert.pem"
    ```

- 修改客户端密钥的权限。

客户端根证书，密钥，证书以及密钥密码加密文件的权限，需保证权限为600。如果权限不满足要求，则客户端无法以SSL连接到openGauss。

    ```
    chmod 600 client.key
    chmod 600 client.crt
    chmod 600 client.key.cipher
    chmod 600 client.key.rand
    chmod 600 cacert.pem
    ```

>[!TIP]须知
>从安全性考虑，建议使用双向认证方式。
>配置客户端环境变量，必须包含文件的绝对路径。

**表 1**  认证方式

认证方式 配置客户端环境变量 维护建议 双向认证（推荐） 客户端验证服务器证书的有效性，同时服务器端也要验证客户端证书的有效性，只有认证成功，连接才能建立。
设置如下环境变量： PGSSLCERTPGSSLKEYPGSSLROOTCERTPGSSLMODE 该方式应用于安全性要求较高的场景。使用此方式时，建议设置客户端的PGSSLMODE变量为verify-ca。确保了网络数据的安全性。
单向认证 客户端只验证服务器证书的有效性，而服务器端不验证客户端证书的有效性。服务器加载证书信息并发送给客户端，客户端使用根证书来验证服务器端证书的有效性。
设置如下环境变量： PGSSLROOTCERTPGSSLMODE 为防止基于TCP链接的欺骗，建议使用SSL证书认证功能。除配置客户端根证书外，建议客户端使用PGSSLMODE变量为verify-ca方式连接。

## 相关参考

在服务器端的postgresql.conf文件中配置相关参数，详细信息请参见[表2](#zh-cn_topic_0283137035_zh-cn_topic_0237121092_zh-cn_topic_0059778374_tccd28484be8c47678b529d6ccd34d1fd)。

**表 2**  服务器参数

取值范围 ssl 表示是否启动SSL功能。
on：开启SSL功能。off：关闭SSL功能。
默认值：off（企业版安装默认为on） require_ssl 设置服务器端是否强制要求SSL连接。该参数只有当参数ssl为on时才有效。
on：服务器端强制要求SSL连接。off：服务器端对是否通过SSL连接不作强制要求。
默认值：off ssl_cert_file 指定服务器证书文件，包含服务器端的公钥。服务器证书用以表明服务器身份的合法性，公钥将发送给对端用来对数据进行加密。
请以实际的证书名为准，其相对路径是相对于数据目录的。
默认值：server.crt ssl_key_file 指定服务器私钥文件，用以对公钥加密的数据进行解密。
请以实际的服务器私钥名称为准，其相对路径是相对于数据目录的。
默认值：server.key ssl_ca_file CA服务器的根证书。此参数可选择配置，需要验证客户端证书的合法性时才需要配置。
请以实际的CA服务器根证书名称为准。
默认值：cacert.pem ssl_crl_file 证书吊销列表，如果客户端证书在该列表中，则当前客户端证书被视为无效证书。
请以实际的证书吊销列表名称为准。
默认值：空，表示没有吊销列表。
ssl_ciphers SSL通讯使用的加密算法。
本产品支持的加密算法的详细信息请参见表4。
默认值：ALL，表示允许对端使用产品支持的所有加密算法，但不包含ADH、LOW、EXP、MD5算法。
ssl_cert_notify_time SSL服务器证书到期前提醒的天数。
请按照需求配置证书过期前提醒天数。
默认值：90

在客户端配置SSL认证相关的环境变量，详细信息请参见[表3](#zh-cn_topic_0283137035_zh-cn_topic_0237121092_zh-cn_topic_0059778374_t1a20720af5504dc0ba3c5d0e8d1a028b)。

>[!NOTE]说明
>客户端环境变量的路径以“_/home/omm_”为例，在实际操作中请使用实际路径进行替换。

**表 3**  客户端参数

环境变量 取值范围 PGSSLCERT 指定客户端证书文件，包含客户端的公钥。客户端证书用以表明客户端身份的合法性，公钥将发送给对端用来对数据进行加密。
默认值：空 PGSSLKEY 指定客户端私钥文件，用以对公钥加密的数据进行解密。
默认值：空 PGSSLMODE 设置是否和服务器进行SSL连接协商，以及指定SSL连接的优先级。
取值及含义： disable：只尝试非SSL连接。allow：首先尝试非SSL连接，如果连接失败，再尝试SSL连接。prefer：首先尝试SSL连接，如果连接失败，将尝试非SSL连接。require：只尝试SSL连接。如果存在CA文件，则按设置成verify-ca的方式验证。verify-ca：只尝试SSL连接，并且验证服务器是否具有由可信任的证书机构签发的证书。verify-full：只尝试SSL连接，并且验证服务器是否具有由可信任的证书机构签发的证书，以及验证服务器主机名是否与证书中的一致。
默认值：prefer PGSSLROOTCERT 指定为客户端颁发证书的根证书文件，根证书用于验证服务器证书的有效性。
默认值：空 PGSSLCRL 指定证书吊销列表文件，用于验证服务器证书是否在废弃证书列表中，如果在，则服务器证书将会被视为无效证书。
默认值：空

服务器端参数ssl、require\_ssl与客户端参数sslmode配置组合结果如下：

ssl（服务器） sslmode（客户端） require_ssl（服务器） disable 由于服务器端要求使用SSL，但客户端针对该连接禁用了SSL，因此无法建立连接。
disable off 连接未加密。
allow 连接经过加密。
allow off 连接未加密。
prefer 连接经过加密。
prefer off 连接经过加密。
require 连接经过加密。
require off 连接经过加密。
verify-ca 连接经过加密，且验证了服务器证书。
verify-ca off 连接经过加密，且验证了服务器证书。
verify-full 连接经过加密，且验证了服务器证书和主机名。
verify-full off 连接经过加密，且验证了服务器证书和主机名。
off disable 连接未加密。
disable off 连接未加密。
allow 连接未加密。
allow off 连接未加密。
prefer 连接未加密。
prefer off 连接未加密。
require 由于客户端要求使用SSL，但服务器端禁用了SSL，因此无法建立连接。
require off 由于客户端要求使用SSL，但服务器端禁用了SSL，因此无法建立连接。
verify-ca 由于客户端要求使用SSL，但服务器端禁用了SSL，因此无法建立连接。
verify-ca off 由于客户端要求使用SSL，但服务器端禁用了SSL，因此无法建立连接。
verify-full 由于客户端要求使用SSL，但服务器端禁用了SSL，因此无法建立连接。
verify-full off 由于客户端要求使用SSL，但服务器端禁用了SSL，因此无法建立连接。

SSL传输支持一系列不同强度的加密和认证算法。用户可以通过修改postgresql.conf中的ssl\_ciphers参数指定数据库服务器使用的加密算法。目前本产品SSL支持的加密算法如[表4](#zh-cn_topic_0283137035_zh-cn_topic_0237121092_zh-cn_topic_0059778374_t34eea0830ef94be1a866f0410ba3eb07)所示。

**表 4**  加密算法套件

OpenSSL套件名 IANA套件名 安全程度 ECDHE-RSA-AES128-GCM-SHA256 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 HIGH ECDHE-RSA-AES256-GCM-SHA384 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 HIGH ECDHE-ECDSA-AES128-GCM-SHA256 TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256 HIGH ECDHE-ECDSA-AES256-GCM-SHA384 TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384 HIGH DHE-RSA-AES128-GCM-SHA256 TLS_DHE_RSA_WITH_AES_128_GCM_SHA256 HIGH DHE-RSA-AES256-GCM-SHA384 TLS_DHE_RSA_WITH_AES_256_GCM_SHA384 HIGH

>[!NOTE]说明
>
>- 目前只支持上表中的6种加密算法套件。
>
>- 配置参数ssl\_ciphers的默认值为ALL，表示支持上表中的所有加密算法。为保持前向兼容保留了DHE算法套件，即DHE-RSA-AES128-GCM-SHA256和DHE-RSA-AES256-GCM-SHA384，根据CVE-2002-20001漏洞披露DHE算法存在一定安全风险，非兼容场景不建议使用，可将ssl_ciphers参数配置为仅支持ECDHE类型算法套件。
>
>- 如需指定以上加密算法套件，可以设置ssl\_ciphers为上表中OpenSSL套件名称，加密算法套件之间需要使用分号分割，如在postgresql.conf设置：ssl\_ciphers='ECDHE-RSA-AES128-GCM-SHA256;ECDHE-ECDSA-AES128-GCM-SHA256'。
>
>- SSL连接认证不仅增加了登录（创建SSL环境）及退出过程（清理SSL环境）的时间消耗，同时需要消耗额外的时间用于加解密所需传输的内容，因此对性能有一定影响。特别的，对于频繁的登录登出，短时查询等场景有较大的影响。
>
>- 在证书有效期小于7天的时候，连接登录会在日志中产生告警提醒。
