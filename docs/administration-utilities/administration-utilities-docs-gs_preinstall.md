# gs_preinstall

## 背景信息

openGauss提供了gs_preinstall工具来帮助完成openGauss的环境配置，以保证openGauss安装的正常进行。

## 注意事项

- 用户需要检查上层目录权限，保证安装用户对安装包和配置文件目录读写执行的权限。
- xml文件中各主机的名称与IP映射配置正确。
- 普通用户执行gs_preinstall命令，只会检查A1,A2,A3,A4,A5,A8,A12,A13选项。
- root执行gs_preinstall命令，默认跳过gs_checkos网卡的校验（A11）。
- 使用root用户执行gs_preinstall会清理/etc/hosts中的openGauss映射信息，可能存在已部署数据库连接丢失风险，可以在安装结束后手动添加其它数据库映射至/etc/hosts文件中。
- gs_preinstall指定的用户不支持使用-d手动选定家目录，仅支持系统默认创建的/home下和用户同名的/home目录。
-
- 本产品支持同一操作系统大版本下的小版本混合部署，其支持列表如下：

    ```
    CentOS 6.4/6.5/6.6/6.7/6.8/6.9
    CentOS 7.0/7.1/7.2/7.3/7.4
    openEuler
    ```

## 语法

- 准备openGauss环境

    ```
    gs_preinstall -U USER -G GROUP -X XMLFILE [-L] [--skip-os-set] [--env-var="ENVVAR" [...]] [--sep-env-file=MPPRCFILE] [--skip-hostname-set] [-l LOGFILE] [--non-interactive] [--enable-perf-config]
    ```

- 显示帮助信息

    ```
    gs_preinstall -? | --help
    ```

- 显示版本号信息

    ```
    gs_preinstall -V | --version
    ```

## 参数说明

- -U

运行openGauss的操作系统用户名。

取值范围：字符串，要符合标识符的命名规范。

>[!NOTE]说明
>配置-U参数值时，字符串中不能包含“|”、“;”、“&”、“$”、“”、“\`”、“\\\\”、“'”、“\\”、“\{”、“\}”、“\(”、“\)”、“\[”、“\]”、“\~”、“\*”、“?”特殊字符。

- -G

运行openGauss的操作系统用户的群组名。

取值范围：字符串，要符合标识符的命名规范。

- -X

openGauss配置文件路径。

取值范围：xml文件的存储路径。

- -L

指定该参数则仅给当前节点准备好openGauss安装环境。适用于不允许使用root互信的场景和设置安全加固参数PermitRootLogin为no的场景。需要满足如下前提条件：

  1. 安装包和openGauss配置文件已提前上传到所有主机；
  2. openGauss安装用户已提前创建好并建立好互信关系；
  3. 用户需要自己保证各台主机上所执行命令的一致性；
  4. 手动将所有节点的主机名和ip映射关系写入各个主机的/etc/hosts，并在每个映射关系后边加入注释内容：\#Gauss OM IP Hosts Mapping。

- --skip-os-set

是否设置操作系统参数。默认设置系统参数。如果指定该参数则不设置。

- --env-var="ENVVAR"

配置普通用户环境变量。可以指定多个。

取值范围：字符串。

>[!NOTE]说明
>本参数不能指定为openGauss默认创建的环境变量。否则，openGauss的环境变量将被覆盖。openGauss默认创建的环境变量见[表1](#zh-cn_topic_0237152419_zh-cn_topic_0059778992_tb25e10cef2104026bdbbedc439fbcd50)。

- --sep-env-file=MPPRCFILE

保存环境变量的文件。如果指定该参数，表示将使用环境变量分离的版本。

>[!NOTE]说明
>不能指定环境变量文件为openGauss相关目录或者和这些目录同名，不能和openGauss用户的目录相同。

- --skip-hostname-set

是否将xml配置文件中主机名与IP的映射关系写入“/etc/hosts”文件中。默认写入，如果指定该参数则不写入。
- --unused-third-party

是否使用om提供的三方库。默认使用，如果指定该参数则不使用。

- --one-stop-install

一站式安装数据库。默认不使用，如果指定该参数，表示通过命令行交互式进行预安装。

- -l

指定日志文件名及路径。在内部会自动给日志名添加一个时间戳。

默认值：/var/log/gaussdb/用户名/om/gs\_preinstall.log

当不明确指定-l，但在XML文件中配置了gaussdbLogPath时，默认值为gaussdbLogPath的值、用户名和om/gs\_preinstall-YYYY-MM-DD\_hhmmss.log的组合。

- --non-interactive

指定前置执行模式。

  - 当不指定该参数时，则为安全交互模式，在此模式下用户需要人机交互输入密码。
  - 当指定该参数时，为非交互模式，不需要进行人机交互。

- --enable-perf-config

在preinstall结束后，调用gs_perfconfig调整操作系统配置，以使openGauss获得比较好的性能。

- -?, --help

显示帮助信息。

- -V, --version

显示版本号信息。

**表 1**  openGauss默认创建的环境变量

环境变量名称 MPPDB_ENV_SEPARATE_PATH openGauss环境变量分离文件路径 GPHOME openGauss工具目录 PATH openGauss工具脚本目录 LD_LIBRARY_PATH openGauss引用第三方动态库路径 PYTHONPATH python软件路径 GAUSS_WARNING_TYPE 告警类型 GAUSSHOME openGauss安装路径 GAUSS_VERSION openGauss版本号 PGHOST openGauss用户的临时目录路径 GS_CLUSTER_NAME openGauss名称 GAUSSLOG openGauss日志路径 GAUSS_ENV openGauss环境变量标识

## 手动设置服务端SYSLOG配置

设置“/etc/syslog-ng/syslog-ng.conf”文件，在文件中添加如下内容：

```
template t_gaussdb {template("$DATE $SOURCEIP $MSGONLY\n");template_escape(no);};
source s_gaussdb{ udp(); };
filter f_gaussdb    { level(err,  crit) and match('GaussDB'); };
destination d_gaussdb { file("/var/log/syslog_MPPDB", template(t_gaussdb)); };
log { source(s_gaussdb); filter(f_gaussdb); destination(d_gaussdb); };
```

设置“/etc/sysconfig/syslog”文件，在文件中添加如下内容：

```
SYSLOGD_OPTIONS="-r -m 0"
KLOGD_OPTIONS="-x"
```

>[!NOTE]说明
>该配置需要在openGauss每台机器上都要修改。

## 示例

使用非交互方式进行openGauss环境准备：

```
./gs_preinstall -U omm -G dbgrp -X /opt/software/openGauss/clusterconfig.xml --non-interactive
Parsing the configuration file.
Successfully parsed the configuration file.
Installing the tools on the local node.
Successfully installed the tools on the local node.
Distributing package.
Successfully distributed package.
Installing the tools in the cluster.
Successfully installed the tools in the cluster.
Checking hostname mapping.
Successfully checked hostname mapping.
Checking OS version.
Successfully checked OS version.
Creating cluster's path.
Successfully created cluster's path.
Set and check OS parameter.
Setting OS parameters.
Successfully set OS parameters.
Warning: InstallationGuide environment contains some warning messages.
Please get more details by "/package_r8/sudo/gs_checkos -i A -h host179174,host179175,host179176 --skip-item-num=A11 --detail".
Set and check OS parameter completed.
Preparing CRON service.
Successfully prepared CRON service.
Preparing SSH service.
Successfully prepared SSH service.
Setting user environmental variables.
Successfully set user environmental variables.
Configuring alarms on the cluster nodes.
Successfully configured alarms on the cluster nodes.
Setting the dynamic link library.
Successfully set the dynamic link library.
Setting finish flag.
Successfully set finish flag.
PreInstallationGuide succeeded.
```

使用交互模式进行openGauss环境准备：

```
./gs_preinstall -U omm -G dbgrp -X /opt/software/openGauss/clusterconfig.xml
Parsing the configuration file.
Successfully parsed the configuration file.
Installing the tools on the local node.
Successfully installed the tools on the local node.
Are you sure you want to create trust for root (yes/no)? yes
Please enter password for root.
Password:
Creating SSH trust for the root permission user.
Please enter password for current user[root].
Password:
Checking network information.
All nodes in the network are Normal.
Successfully checked network information.
Creating SSH trust.
Creating the local key file.
Successfully created the local key files.
Appending local ID to authorized_keys.
Successfully appended local ID to authorized_keys.
Updating the known_hosts file.
Successfully updated the known_hosts file.
Appending authorized_key on the remote node.
Successfully appended authorized_key on all remote node.
Checking common authentication file content.
Successfully checked common authentication content.
Distributing SSH trust file to all node.
Successfully distributed SSH trust file to all node.
Verifying SSH trust on all hosts.
Successfully verified SSH trust on all hosts.
Successfully created SSH trust.
Successfully created SSH trust for the root permission user.
Distributing package.
Successfully distributed package.
Are you sure you want to create the user[omm] and create trust for it (yes/no)? yes
Please enter password for cluster user.
Password:
Please enter password for cluster user again.
Password:
Creating [omm] user on all nodes.
Successfully created [omm] user on all nodes.
Installing the tools in the cluster.
Successfully installed the tools in the cluster.
Checking hostname mapping.
Successfully checked hostname mapping.
Creating SSH trust for [omm] user.
Please enter password for current user[omm].
Password:
Checking network information.
All nodes in the network are Normal.
Successfully checked network information.
Creating SSH trust.
Creating the local key file.
Successfully created the local key files.
Appending local ID to authorized_keys.
Successfully appended local ID to authorized_keys.
Updating the known_hosts file.
Successfully updated the known_hosts file.
Appending authorized_key on the remote node.
Successfully appended authorized_key on all remote node.
Checking common authentication file content.
Successfully checked common authentication content.
Distributing SSH trust file to all node.
Successfully distributed SSH trust file to all node.
Verifying SSH trust on all hosts.
Successfully verified SSH trust on all hosts.
Successfully created SSH trust.
Successfully created SSH trust for [omm] user.
Checking OS version.
Successfully checked OS version.
Creating cluster's path.
Successfully created cluster's path.
Set and check OS parameter.
Setting OS parameters.
Successfully set OS parameters.
Warning: InstallationGuide environment contains some warning messages.
Please get more details by "/package_r8/sudo/gs_checkos -i A -h host179174,host179175,host179176 --skip-item-num=A11 --detail".
Set and check OS parameter completed.
Preparing CRON service.
Successfully prepared CRON service.
Preparing SSH service.
Successfully prepared SSH service.
Setting user environmental variables.
Successfully set user environmental variables.
Configuring alarms on the cluster nodes.
Successfully configured alarms on the cluster nodes.
Setting the dynamic link library.
Successfully set the dynamic link library.
Setting finish flag.
Successfully set finish flag.
PreInstallationGuide succeeded.
```

## 相关命令

[gs\_install](gs_install.md)，[gs\_postuninstall](gs_postuninstall.md)
