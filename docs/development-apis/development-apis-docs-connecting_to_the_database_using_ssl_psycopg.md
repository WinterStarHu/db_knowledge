# 连接数据库（SSL方式）

用户通过psycopy2连接openGauss服务器时，可以通过开启SSL加密客户端和服务器之间的通讯。在使用SSL时，默认用户已经获取了服务端和客户端所需要的证书和私钥文件，关于证书等文件的获取请参考[Openssl相关文档和命令](https://www.openssl.net.cn/)。

1. 使用\*.ini文件（python的configparser包可以解析这种类型的配置文件）保存数据库连接的配置信息。

文件内容如下:

    ```
    [opengauss]
    host=localhost
    database=postgres
    user=omm
    password=test
    ```

2. 在连接选项中添加SSL连接相关参数：sslmode、sslcert、sslkey、sslrootcert。
a.  sslmode：可选项见[表1](#table167989176183)。
b.  sslcert：客户端证书路径。
c.  sslkey：客户端密钥路径。
d.  sslrootcert：根证书路径。

3. 使用psycopg2.connect函数获得connection对象。

    ```python
    from configparser import ConfigParser
    import psycopg2
    parser = ConfigParser()
    parser.read('database.ini')
    parameters = dict()
    for parameter, value in parser.items('opengauss'):
        parameters[parameter] = value
    connection = psycopg2.connect(**parameters)
   ```

4. 使用connection对象创建cursor对象。

    ```python
    cursor = connection.cursor()
    ```

**表 1**  sslmode的可选项及其描述

sslmode 是否会启用SSL加密 disable 不适用SSL安全连接。
allow 如果数据库服务器要求使用，则可以使用SSL安全加密连接，但不验证数据库服务器的真实性。
prefer 如果数据库支持，那么首选使用SSL连接，但不验证数据库服务器的真实性。
require 必须使用SSL安全连接，但是只做了数据加密，而并不验证数据库服务器的真实性。
verify-ca 必须使用SSL安全连接。
verify-full 必须使用SSL安全连接，目前暂不支持。
