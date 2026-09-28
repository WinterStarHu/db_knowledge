# UWAL

## 介绍

本章节主要介绍openGauss数据库UWAL（Unified Write-Ahead Log）特性的安装使用，指导用户顺利完成操作。本特性将数据库和自研公共组件UWAL相结合，以提高数据库的主备事务提交和流复制传输性能，从而加速WAL（Write-Ahead Log）的处理效率。

## 安装准备

### 获取安装包

请通过openGauss社区RM SIG获取UWAL安装包。

### 环境要求

配置描述 具体型号根据实际情况确定，例如Mellanox的CX4/CX5系列网卡。
需要支持RDMA和以太网并开启RDMA协议，开启RDMA协议的具体步骤请参见《RDMA网络指导》。
交换机 开启RDMA协议，需要配置无损网络。TCP协议不需要配置无损网络。
服务器 开启RDMA协议，需要配置无损网络。TCP协议不需要配置无损网络。
操作系统 ArmopenEuler 22.03 LTSopenEuler 20.03 LTS x86openEuler 22.03 LTSopenEuler 20.03 LTSCentOS 7.6 x86 MLNX_OFED_LINUX-5.8-1.1.2.1 开启RDMA协议，需要安装RDMA网卡驱动。
GCC 7.3GCC 10.3 OCK_UWAL_23.0.0_centos-7.6-x86_64_gcc10.tar.gzOCK_UWAL_23.0.0_centos-7.6-x86_64_gcc7.tar.gzOCK_UWAL_23.0.0_openeuler_20.03-aarch64_gcc10.tar.gzOCK_UWAL_23.0.0_openeuler_20.03-aarch64_gcc7.tar.gzOCK_UWAL_23.0.0_openeuler_20.03-x86_64_gcc10.tar.gzOCK_UWAL_23.0.0_openeuler_20.03-x86_64_gcc7.tar.gzOCK_UWAL_23.0.0_openeuler_22.03-aarch64_gcc10.tar.gzOCK_UWAL_23.0.0_openeuler_22.03-aarch64_gcc7.tar.gzOCK_UWAL_23.0.0_openeuler_22.03-x86_64_gcc10.tar.gzOCK_UWAL_23.0.0_openeuler_22.03-x86_64_gcc7.tar.gz UWAL安装包。openeuler_22.03、centos-7.6表示操作系统，aarch64、x86_64表示服务器架构，gcc10、gcc7表示依赖的GCC版本，具体UWAL安装包请用户根据实际情况选择。

## 安装卸载

### 一键部署UWAL特性

UWAL提供简易部署脚本，支持一键部署。

- 前提条件
  - openGauss已部署完成。
  - 获取对应操作系统和CPU架构的UWAL安装包，例如：OCK\_UWAL\_23.0.0\_openeuler\_22.03-aarch64\_gcc10.tar.gz。
  - 主备节点均已存在以下目录：
  - “$\{GAUSSHOME\}/lib“路径
  - UWAL文件存放路径（“uwal\_devices\_path“对应的值）
  - UWAL日志文件存放路径（“uwal\_log\_path“对应的值）

- 操作步骤

>[!NOTE]说明
>以下操作除特殊说明外，默认只在主节点进行操作。

  1. 将安装包上传至节点，在安装包所在目录执行以下命令赋予openGauss数据库用户操作权限。

        ```
        chown omm:dbgrp OCK_UWAL_23.0.0_openeuler_22.03-aarch64_gcc10.tar.gz
        ```

>[!NOTE]说明
>- omm：数据库管理用户名。
>- dbgrp：数据库管理用户组。

  2. 切换为openGauss数据库管理用户，解压缩安装包。

        ```
        su - omm
        tar -xzvf OCK_UWAL_23.0.0_openeuler_22.03-aarch64_gcc10.tar.gz
        ```

解压后得到以下文件。

文件名 OCK_UWAL_23.0.0_openeuler_aarch64.tar.gz 源文件 OCK_UWAL_23.0.0_openeuler_aarch64.tar.gz.txt 签名文件 OCK_UWAL_23.0.0_openeuler_aarch64.tar.gz.cms 描述文件

  3. 解压源文件压缩包。

        ```
        tar -xzvf OCK_UWAL_23.0.0_openeuler_aarch64.tar.gz
        ```

解压后得到如下文件。

文件名 lib so文件 scripts 安装脚本 include UWAL头文件 bin 签名验证文件

>[!NOTE]说明
>如果重复解压源文件，需清理以上文件后再解压。

  4. 使用“bin“目录下的verification二进制，进行软件包签名验证。

        ```
        ./bin/verification OCK_UWAL_23.0.0_openeuler_aarch64.tar.gz OCK_UWAL_23.0.0_openeuler_aarch64.tar.gz.cms
        OCK_UWAL_23.0.0_openeuler_aarch64.tar.gz.txt
        ```

>[!NOTE]说明
>verification可执行二进制需要三个参数，按先后顺序分别是：源文件、签名文件、描述文件。

  - 验证成功控制台会输出：

            ```
            Starting to verify OCK_UWAL_23.0.0_openeuler_aarch64.tar.gz...
            Verify the source file passed.
            Verify the sha file passed.
            ```

  - 验证失败控制台会输出：

            ```
            Starting to verify OCK_UWAL_23.0.0_openeuler_aarch64.tar.gz...
            ...
            Verify the source file failed.
            ```

或者

            ```
            Starting to verify OCK_UWAL_23.0.0_openeuler_aarch64.tar.gz...
            ...
            Verify the sha file failed.
            ```

>[!NOTE]说明
>校验失败说明此安装包已被篡改，建议重新获取安装包后再次校验。

  5. 安装包验证成功后，进入“scripts“目录，准备执行部署脚本。

        ```
        cd scripts
        ```

  6. 启动脚本，即可完成UWAL部署。

        ```
        sh ock_uwal_install.sh -H '192.168.4.164 192.168.4.165 192.168.4.166' -U omm -D /home/omm/lib
        ```

>[!NOTE]说明
>- -H：集群IP地址。例如：'_192.168.4.164 192.168.4.165 192.168.4.166_'
>- -U：数据库管理用户名。例如：omm
>- -D：“$\{GAUSSHOME\}/lib“库路径。例如：“/home/omm/lib“
>- -h：查看帮助信息。

  7. （可选）kill om\_monitor进程。

        ```
        gs_om -t killmonitor
        ```

  8. 执行以下命令，加载环境变量。

        ```
        source ~/.bashrc
        ```

>[!TIP]须知
>此步骤也需要在备节点执行。

  9. （可选）UWAL组件依赖HCOM组件进行RPC通信，用户可根据需要配置以下环境变量。

        ```
        export HCOM_FILE_PATH_PREFIX="/home/uds/socket/file"
        export HCOM_OPENSSL_PATH="/home/openssl"
        export HCOM_TRACE_LEVEL=0
        export HCOM_QP_TRAFFIC_CLASS=106
        export HCOM_SHM_EXCHANGE_FD_QUEUE_SIZE=10
        export HCOM_CONNECTION_RETRY_TIMES=5
        export HCOM_CONNECTION_RETRY_INTERVAL_SEC=2
        ```

具体参数见下表：

参数名称 参数类型 参数说明 取值范围 默认值 HCOM_FILE_PATH_PREFIX 字符串 HCOM生成的文件路径的前缀，通过前缀保证文件只会在当前路径下（此路径需要已存在）创建删除。
HCOM_OPENSSL_PATH 字符串 HCOM依赖OpenSSL库，此路径为libssl.so和libcrypt.so的目录路径。
HCOM_TRACE_LEVEL HCOM的打点日志等级： 0：不开打点。1：打开高优先级打点。2：打开中优先级打点。3：打开低优先级打点。
0～3 HCOM_QP_TRAFFIC_CLASS HCOM中的RDMA协议的traffic_class字段设置优先级。
0～255 106 HCOM_SHM_EXCHANGE_FD_QUEUE_SIZE HCOM发送fds内部队列的大小。
10～256 HCOM_CONNECTION_RETRY_TIMES HCOM建链重试的次数。
0～10 HCOM_CONNECTION_RETRY_INTERVAL_SEC HCOM建链重试的间隔时间，单位：s。
0～60

### 启用UWAL特性

启用UWAL特性，需要通过修改配置文件，重启数据库使其生效。

- 前提条件
  - 主备节点已安装包含UWAL特性的openGauss版本。
  - 已完成UWAL特性的一键部署。

- 操作步骤

  1. 以数据库管理用户登录管理节点。
  2. 配置数据库的postgresql.conf文件。
  1. 打开postgresql.conf文件。

            ```
            vim postgresql.conf
            ```

  2. 按“i”进入编辑模式，在文件最后增加如下参数。此处以一主一备做举例，具体参数请根据实际情况设置，参数说明请参见[表1](#table135651186916)。

            ```
            replconninfo1='localhost=10.10.10.201 localport=5432 remotehost=10.10.10.207 remoteport=5432 remotenodeid=2 remoteuwalhost=10.10.10.207 remoteuwalport=9991'
            enable_uwal = on
            uwal_config = '{"uwal_nodeid": 0, "uwal_ip": "10.10.10.201", "uwal_port": 9991, "uwal_protocol": "tcp", "uwal_replinodes": [{"id": 1, "protocol": "tcp"}], "cpu_bind_switch": "true", "cpu_bind_start": 1, "cpu_bind_num": 3}'
            uwal_disk_size = 8589934592
            uwal_devices_path = '/home/Data/uwal/'
            uwal_log_path = '/home/Data/opengauss_master/uwal_log'
            uwal_rpc_compression_switch = true
            uwal_rpc_flowcontrol_switch = true
            uwal_rpc_flowcontrol_value = 128
            uwal_async_append_switch = false
            application_name = 'node201'
            ```

>[!NOTE]说明
>- 一主两备，需要在“replconninfo1“参数的下一行添加“replconninfo2“参数，如：
>
> ```
> replconninfo2='localhost=10.10.10.201 localport=5432 remotehost=10.10.10.208 remoteport=5432 remotenodeid=2 remoteuwalhost=10.10.10.208 remoteuwalport=9991'
>    ```
>
>- 一主N备时，依次增加至“replconninfoN“参数即可。

**表 1**  UWAL的配置参数

参数名称 参数类型 参数说明 取值范围 默认值 replconninfo{N} 字符串 配置远端UWAL节点的IP地址及Port，需要在原有参数后面增加remotenodeid（远端节点的uwal_nodeid）、remoteuwalhost（远端节点的uwal_ip）、remoteuwalport（远端节点的uwal_port）。“N”表示设置本端侦听和鉴权的第N个节点信息。
字符串。其中空字符串表示没有配置第N个节点信息。
空字符串 enable_uwal 布尔型 开启UWAL功能。
on，表示开启UWAL功能。off，表示关闭UWAL功能。
off uwal_config 字符串 UWAL配置。
JSON类型的字符串。
空字符串 uwal_disk_size UWAL占用磁盘大小，不能超过磁盘大小。单位：byte。
最小值：8589934592 最大值：4398046511104 8589934592 uwal_devices_path 字符串 UWAL文件存放路径（已存在的路径，不会自动创建目录），调用UwalInit()函数时传入的参数名。
文件存放路径组成的字符串。
空字符串 uwal_log_path 字符串 UWAL日志文件存放路径（已存在的路径，不会自动创建目录）。
文件存放路径组成的字符串。
空字符串 uwal_rpc_compression_switch 布尔型 是否压缩传输。
true，表示开启压缩传输。false，表示关闭压缩传输。
false uwal_rpc_flowcontrol_switch 布尔型 UWAL流控开关，在主库设置。
on，表示打开UWAL流控开关。off，表示关闭UWAL流控开关。
off uwal_rpc_flowcontrol_value UWAL接收阈值。单位：MB。
8～2048 128 uwal_async_append_switch 布尔型 UWAL使用同步写还是异步写。
true，表示使用异步写。false，表示使用同步写。
false application_name 字符串 当前连接请求当中，所使用的客户端名称。
任意字符串。
空字符串

**表 2**  uwal\_config配置参数

参数名称 参数类型 参数说明 取值范围 默认值 uwal_nodeid 当前UWAL节点的ID。
0～7 None uwal_ip 字符串 UWAL侦听地址，调用UwalInit()函数时传入的参数名。
IPv4 空字符串 uwal_port UWAL侦听端口，调用UwalInit()函数时传入的参数名。
9000～65535 None uwal_protocol 字符串 当前节点连接类型，调用UwalInit()函数时传入的参数名，可选。
tcprdma tcp

uwal_replinodes 远端节点类型。id为远端节点对应的uwal_nodeid，protocol与id对应远端节点的uwal_protocol保持一致，可选。
id：0~7protocol：tcprdma tcp

cpu_bind_switch 字符串 UWAL核心线程绑核开关，可选。
true，表示开启绑核。false，表示关闭绑核。
false cpu_bind_start UWAL绑核CPU起始编号，可选。
0～1024 cpu_bind_num UWAL绑核CPU数量，可选。
2～16

  3. 按“Esc”键，输入 **:wq!**，按“Enter”保存并退出编辑。

  3. 重启数据库使UWAL特性生效。
  1. 停止openGauss。

            ```
            cm_ctl stop
            ```

  2. 启动openGauss。

            ```
            cm_ctl start
            ```

>[!NOTE]说明
>如果启动失败请根据openGauss日志目录下的“postgresql-YYYY-MM-DD\_HHMMSS.log”日志信息排查错误。

  4. 验证UWAL特性是否启用成功。

        ```
        gsql -d postgres -p 16600 -c "show enable_uwal"
        ```

如果回显如下内容，则启用成功。

        ```
        enable_uwal
        -------------------
        on
        (1 row)
        ```

>[!NOTE]说明
>- -p 16600：16600为数据库端口号，请根据实际情况修改。
>- 如需查看启用UWAL特性的日志文件，可进入“uwal\_log\_path“对的路径执行以下命令。
>
> ```
> cat uwal*.log
>    ```

### 关闭UWAL特性

关闭UWAL特性，需要重启数据库使配置生效。

- 操作步骤

  1. 执行 **pg_switch_xlog()** 命令，切换到一个新的事务日志文件，将当前日志文件归档。

        ```
        gsql -d postgres -p 5432 -c "select pg_switch_xlog()"
        ```

>[!NOTE]说明
>- -p 5432：5432为数据库端口号，请根据实际情况修改。

  2. 执行**CHECKPOINT**命令，设置事务日志检查点。

        ```
        gsql -d postgres -p 5432 -c "CHECKPOINT"
        ```

  3. 停止openGauss。

        ```
        cm_ctl stop
        ```

  4. 补全事务日志文件，并替换原生路径下的事务日志文件。
  1. 查看生成的事务日志文件，最新的文件应小于单个事务日志文件大小（例如16MB），将其补全。

            ```
            dd if=000000010000000000000005 of=5.align bs=16M conv=sync
            ```

>[!NOTE]说明
>- 000000010000000000000005：最新的事务日志文件名，由数据库操作自动生成，文件名不固定。
>- 5.align：补全为16MB的事务日志文件名，由用户自定义。

  2. 用补全的事务日志文件替换原生的事务日志文件。

            ```
            cp 5.align pg_xlog/000000010000000000000005
            ```

  5. 配置数据库根目录下的postgresql.conf文件,关闭UWAL。
  1. 打开postgresql.conf文件。

            ```
            vim postgresql.conf
            ```

  2. 按“i”进入编辑模式。将参数“enable\_uwal“的值改为“off“，关闭UWAL特性。

            ```
            enable_uwal = off
            ```

  3. 按“Esc”键，输入 **:wq!**，按“Enter”保存并退出编辑。

  6. （可选）如需卸载UWAL特性可执行此步骤。删除UWAL动态库文件，并清除环境变量。

        ```
        rm -f /home/omm/lib/libuwal.so
        unset OCK_UWAL_LIB_PATH
        ```

其中，“/home/omm/lib/”表示libuwal.so所在目录的绝对路径。

  7. 重启openGauss。

        ```
        cm_ctl start
        ```
