# 执行安装

执行前置脚本准备好openGauss安装环境之后，按照启动安装过程部署openGauss。

## 前提条件

- 已成功执行前置脚本gs\_preinstall。即完成了[准备安装用户及环境](initializing_the_installation_environment.md)。
- 所有服务器操作系统和网络均正常运行。
- 用户需确保各个主机上的locale保持一致。

## 操作步骤

1. 检查安装包和openGauss配置文件在规划路径下是否已存在，如果没有，重新执行预安装，确保预安装成功，再执行以下步骤。

>[!NOTE]说明
>
>omm用户需要拥有安装包所在目录及子目录的权限。

2. 登录到openGauss的主机，并切换到omm用户。

    ```
    su - omm
    ```

>[!NOTE]说明
>
>- omm指的是前置脚本gs\_preinstall中-U参数指定的用户。
>
>- 安装脚本gs\_install必须以前置脚本中指定的omm执行，否则，脚本执行会报错。
>
>- openGauss在海思高版本芯片上编译的不能在海思低版本芯片的服务器上运行，比如Hi620编译的版本不能在Hi1616环境上运行。

3. 使用gs\_install安装openGauss。若为环境变量分离的模式安装的数据库需要source环境变量分离文件ENVFILE。

    ```
    source ENVFILE(若为环境变量分离的模式)
    gs_install -X /opt/software/openGauss/cluster_config.xml
    ```

/opt/software/openGauss/cluster\_config.xml为openGauss配置文件的路径。在执行过程中，用户需根据提示输入数据库的密码，密码具有一定的复杂度，为保证用户正常使用该数据库，请记住输入的数据库密码。

设置的密码要符合复杂度要求：

  - 最少包含8个字符，最多包含16个字符。
  - 不能和用户名、当前密码（ALTER）、或当前密码反序相同。
  - 至少包含大写字母（A-Z）、小写字母（a-z）、数字、非字母数字字符（限定为\~!@\#$%^&\*\(\)-\_=+\\|\[\{\}\];:,/?）四类字符中的三类字符。

安装过程中会生成ssl证书，证书存放路径为\{gaussdbAppPath\}/share/sslcert/om，其中\{gaussdbAppPath\}为openGauss配置文件中指定的程序安装目录。

日志文件路径下会生成两个日志文件：“gs\_install-YYYY-MMDD\_HHMMSS.log”和“gs\_local-YYYY-MM-DD\_HHMMSS.log”。

>[!NOTE]说明
>
>- openGauss支持字符集的多种写法：gbk/GBK、UTF-8/UTF8/utf8/utf-8和Latine1/latine1。
>
>- 安装时若不指定字符集，默认字符集为SQL\_ASCII，为简化和统一区域locale默认设置为C，若想指定其他字符集和区域，请在安装时使用参数--gsinit-parameter="--locale=LOCALE"来指定，LOCALE为新数据库设置缺省的区域。

例如用户要将数据库编码格式初始化为UTF-8，可以采用如下步骤：

用locale -a |grep utf8命令查看系统支持UTF-8编码的区域，如下：
        ```
        omm@linux:~>  locale -a|grep utf8
        ```
显示类似如下信息，其中en\_US.utf8表示区域en\_US支持UTF-8编码。
        ```
        en_SG.utf8
        en_US.utf8
        ```
根据需要选择区域，如en\_US.utf8，初始化数据库时加入--locale=en\_US.utf8选项进行安装，示例如下：
        ```
        gs_install -X /opt/software/openGauss/cluster_config.xml --gsinit-parameter="--locale=en_US.utf8"
        ```

4. 安装执行成功后，如果预安装用root执行，那么默认会将数据库的最大连接数设置为5k；如果预安装用普通用户执行，那么当系统信号量小于640万，数据库最大连接数设置为1k，其他情况会将数据库的最大连接数设置为5k。

5. 安装执行成功之后，需要手动删除主机root用户的互信，即删除openGauss数据库各节点上的互信文件。

rm –rf ~/.ssh

## 安装生成的目录

安装后的目录及各目录下的文件说明请参见[表1](#zh-cn_topic_0241805806_zh-cn_topic_0085434626_zh-cn_topic_0059782015_tdcb4fb0f38a6419099ee2c47d4d0b37f)。

**表 1**  安装生成的目录

项目目录说明 子目录 openGauss安装目录 /opt/huawei/install/app bin 存放数据库二进制文件的目录。
etc cgroup工具配置文件。
include 存放数据库运行所需要的头文件。
lib 存放数据库的库文件的目录。
share 存放数据库运行所需要的公共文件，如配置文件模板。
openGauss数据目录 /opt/huawei/install/data/dn DBnode实例的数据目录。
openGauss日志目录 /var/log/omm/用户名 bin 二进制程序的日志目录。
gs_profile 数据库内核性能日志目录。
OM的日志目录。例如： 部分local脚本产生的日志、增删数据库节点接口的日志、gs_om接口的日志、前置接口的日志、节点替换接口的日志等。
pg_audit 数据库审计日志目录。
pg_log 数据库节点实例的运行日志目录。
openGauss系统工具目录 /opt/huawei/install/om script 用于openGauss用户进行openGauss管理的脚本文件。
lib bin目录下的二进制文件依赖的库文件。
openGauss临时文件目录 /opt/huawei/tmp &nbsp;&nbsp;
用于放置临时文件。

## 示例

执行安装：

```
omm@plat1:~> gs_install -X /opt/software/openGauss/cluster_config.xml
Parsing the configuration file.
Check preinstall on every node.
Successfully checked preinstall on every node.
Creating the backup directory.
Successfully created the backup directory.
begin deploy..
Installing the cluster.
begin prepare Install Cluster..
Checking the InstallationGuide environment on all nodes.
begin install Cluster..
Installing applications on all nodes.
Successfully installed APP.
begin init Instance..
encrypt ciper and rand files for database.
Please enter password for database:
Please repeat for database:
begin to create CA cert files
The sslcert will be generated in /opt/gaussdb/cluster/app/share/sslcert/om
Cluster InstallationGuide is completed.
Configuring.
Deleting instances from all nodes.
Successfully deleted instances from all nodes.
Checking node configuration on all nodes.
Initializing instances on all nodes.
Updating instance configuration on all nodes.
Check consistence of memCheck and coresCheck on DN nodes.
Successful check consistence of memCheck and coresCheck on all nodes.
Configuring pg_hba on all nodes.
Configuration is completed.
Successfully started cluster.
Successfully installed application.
```

## 错误排查

如果安装失败请根据openGauss日志目录下的“gs\_install-YYYY-MM-DD\_HHMMSS.log”和“gs\_local-YYYY-MM-DD\_HHMMSS.log”中的日志信息排查错误。
