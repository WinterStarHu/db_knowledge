# 初始化安装环境

为了保证openGauss的正确安装，请首先对主机环境进行配置。

## 准备安装用户及环境

创建完openGauss配置文件后，在执行安装前，为了后续能以最小权限进行安装及openGauss管理操作，保证系统安全性，需要运行安装前置脚本gs\_preinstall准备好安装用户及环境。

安装前置脚本gs_preinstall可以协助用户自动完成如下的安装环境准备工作：

- 自动设置Linux内核参数以达到提高服务器负载能力的目的。这些参数直接影响数据库系统的运行状态，请仅在确认必要时调整。openGauss所设置的Linux内核参数取值请参见[配置操作系统参数](#配置操作系统参数)。
- 自动将openGauss配置文件、安装包拷贝到openGauss主机的相同目录下。
- openGauss安装用户、用户组不存在时，自动创建安装用户以及用户组。
- 读取openGauss配置文件中的目录信息并创建，将目录权限授予安装用户。

### 前提条件

- 已完成[安装准备](preparing_the_software_and_hardware_installation_environment.md)的所有任务。
- 如果是普通用户执行前置脚本gs_preinstall，需要完成[前提操作](prerequisites.md)。

### 注意事项

- 用户需要检查上层目录权限，保证安装用户对安装包和配置文件目录读写执行的权限。
- xml文件中各主机的名称与IP映射配置正确。
- 普通用户执行gs_preinstall命令，只会检查A1,A2,A3,A4,A5,A8,A12,A13选项。
- root执行gs_preinstall命令，默认跳过gs_checkos网卡的校验（A11）。

### 操作步骤

1. 以root或普通用户登录待安装openGauss的任意主机，并按规划创建存放安装包的目录。

```shell
mkdir -p /opt/software/openGauss
```

>[!NOTE]说明
>
>- 不建议把安装包的存放目录规划到openGauss用户的根目录或其子目录下，可能导致权限问题。
>

2.将安装包“openGauss-All-x.x.x-openEuler20.03-x86_64.tar.gz”和配置文件“cluster_config.xml”都上传至上一步所创建的目录中。

3.在第一步所创建的安装包的目录下，解压安装包openGauss-All-x.x.x-openEuler20.03-x86_64.tar.gz。安装包解压后，会有OM安装包和Server安装包。继续解压OM安装包，会在/opt/software/openGauss路径下自动生成script子目录，并且在script目录下生成gs_preinstall等各种OM工具脚本。

```shell
cd /opt/software/openGauss
tar -zxvf openGauss-All-x.x.x-openEuler20.03-x86_64.tar.gz
tar -zxvf openGauss-OM-x.x.x-openEuler20.03-x86_64.tar.gz
```

>[!NOTE]说明
>
>- 在执行前置脚本gs_preinstall时，需要规划好openGauss配置文件路径、安装包存放路径、程序安装目录、实例数据目录，后续普通用户使用过程中不能再更改这些路径。
>
>- 运行前置脚本gs_preinstall准备安装环境时，脚本内部会自动将openGauss配置文件、解压后的安装包同步拷贝到其余服务器的相同目录下。
>
>- 在执行前置脚本或者互信前，请检查/etc/profile文件中是否包含错误输出信息，如果存在错误输出，需手动处理。

4.修改安装包目录权限

```shell
chmod 755 -R /opt/software
```

>[!NOTE]说明
>
>- openGauss用户须具有/opt/software/openGauss目录的读写权限。

5.进入到工具脚本存放目录下。

```shell
cd /opt/software/openGauss/script
```

6.如果是openEuler的操作系统（openEuler 20.03），执行如下命令打开performance.sh文件，用#注释sysctl -w vm.min_free_kbytes=112640 &> /dev/null，键入“ESC”键进入指令模式，执行 **:wq** 保存并退出修改。

```shell
vi /etc/profile.d/performance.sh
```

7.为确保成功安装，检查hostname与/etc/hostname是否一致。预安装过程中，会对hostname进行检查。

8.使用gs_preinstall准备好安装环境。若为共用环境需加入--sep-env-file=ENVFILE参数分离环境变量，避免与其他用户相互影响，ENVFILE为用户自行指定的环境变量分离文件的路径，可以为一个空文件。

- 采用交互模式执行前置，并在执行过程中自动创建操作系统root用户互信和omm用户互信：

```shell
./gs_preinstall -U omm -G dbgrp -X /opt/software/openGauss/cluster_config.xml [--sep-env-file=ENVFILE]
```

omm为数据库管理员（也是运行openGauss的操作系统用户），dbgrp为运行openGauss的操作系统用户的群组名称，/opt/software/openGauss/cluster_config.xml为openGauss配置文件路径。在执行过程中，用户根据提示选择是否创建互信，并输入操作系统root用户或omm用户的密码。

> [!WARNING]注意
>
> 分离的环境变量ENVFILE为用户可以访问到的目录，例如，/opt/software/openGauss/ENVFILE,不指定目录的情况下会默认将ENVFILE放在script目录下。

- 允许创建root用户互信时，预安装脚本在执行的时候会将各个主机的ip,hostname写入到/etc/hosts中，并在每个映射关系后边加入注释内容：#Gauss OM IP Hosts Mapping。
- 不允许创建root用户互信时，此时需要用户手动先建立互信（也就是将各个主机的ip，hostname写入到/etc/hosts中），然后执行预安装脚本

a.执行下面命令准备安装环境。

    ```shell
    cd /opt/software/openGauss/script
    ./gs_preinstall -U omm -G dbgrp -L -X /opt/software/openGauss/cluster_config.xml
    ```

>[!NOTE]说明
>此操作需要在每台主机上执行该命令。
>

  - 采用非交互模式执行前置：

a.参考[手工建立互信](#手工建立互信)章节手工建立root用户互信和openGauss用户互信。

b.执行下面命令准备安装环境。

    ```shell
    cd /opt/software/openGauss/script
    ./gs_preinstall -U omm -G dbgrp -X /opt/software/openGauss/cluster_config.xml --non-interactive
    ```

>[!NOTE]说明
>
>- 此模式要求用户确保在执行前，已经建立了各节点root用户互信和openGauss用户互信。
>
>- root用户互信可能会存在安全隐患，因此建议用户在执行完安装后，立即删除各主机上root用户的互信。

### 示例

执行前置脚本：

```shell
plat1:/opt/software/openGauss/script # ./gs_preinstall -U omm -G dbgrp -X /opt/software/openGauss/cluster_config.xml
Parsing the configuration file.
Successfully parsed the configuration file.
Installing the tools on the local node.
Successfully installed the tools on the local node.
Are you sure you want to create trust for root (yes/no)? yes
Please enter password for root.
Password:
Creating SSH trust for the root permission user.
Setting host ip env
Successfully set host ip env.
Distributing package.
Begin to distribute package to tool path.
Successfully distribute package to tool path.
Begin to distribute package to package path.
Successfully distribute package to package path.
Successfully distributed package.
Are you sure you want to create the user[omm] and create trust for it (yes/no)? yes
Please enter password for cluster user.
Password:
Generate cluster user password files successfully.
Successfully created [omm] user on all nodes.
Preparing SSH service.
Successfully prepared SSH service.
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
Successfully created SSH trust for the root permission user.
Setting pssh path
Successfully set core path.
Distributing package.
Begin to distribute package to tool path.
Successfully distribute package to tool path.
Begin to distribute package to package path.
Successfully distribute package to package path.
Successfully distributed package.
Are you sure you want to create the user[omm] and create trust for it (yes/no)? yes
Please enter password for cluster user.
Password:
Please enter password for cluster user again.
Password:
Successfully created [omm] user on all nodes.
Preparing SSH service.
Successfully prepared SSH service.
Installing the tools in the cluster.
Successfully installed the tools in the cluster.
Checking hostname mapping.
Successfully checked hostname mapping.
Creating SSH trust for [omm] user.
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
Checking OS software.
Successfully check os software.
Checking OS version.
Successfully checked OS version.
Creating cluster's path.
Successfully created cluster's path.
Set and check OS parameter.
Setting OS parameters.
Successfully set OS parameters.
Preparing CRON service.
Successfully prepared CRON service.
Setting user environmental variables.
Successfully set user environmental variables.
Setting the dynamic link library.
Successfully set the dynamic link library.
Setting Core file
Successfully set core path.
Setting pssh path
Successfully set pssh path.
Set ARM Optimization.
No need to set ARM Optimization.
Fixing server package owner.
Setting finish flag.
Successfully set finish flag.
PreInstallationGuide succeeded.
```

如果主备机的root用户密码不同，且不能统一修改为一致时，执行前置脚本本地安装模式：

```shell
plat1:/opt/software/openGauss/script # ./gs_preinstall -U omm -G dbgrp -L -X /opt/software/openGauss/cluster_config.xml
Parsing the configuration file.
Successfully parsed the configuration file.
Installing the tools on the local node.
Successfully installed the tools on the local node.
Checking OS version.
Successfully checked OS version.
Creating cluster's path.
Successfully created cluster's path.
Set and check OS parameter.
Setting OS parameters.
Successfully set OS parameters.
Warning: InstallationGuide environment contains some warning messages.
Please get more details by "/home/package/r8c00/script/gs_checkos -i A -h SIA1000068990".
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
Setting Cgroup.
Successfully set Cgroup.
Setting finish flag.
Successfully set finish flag.
PreInstallationGuide succeeded.
```

以非交互模式执行前置：

```shell
plat1:/opt/software/openGauss/script # ./gs_preinstall -U omm -G dbgrp -X /opt/software/openGauss/cluster_config.xml --non-interactive
Parsing the configuration file.
Successfully parsed the configuration file.
Installing the tools on the local node.
Successfully installed the tools on the local node.
Distributing package.
Begin to distribute package to tool path.
Successfully distribute package to tool path.
Begin to distribute package to package path.
Successfully distribute package to package path.
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
Setting Cgroup.
Successfully set Cgroup.
Set ARM Optimization.
Successfully set ARM Optimization.
Setting finish flag.
Successfully set finish flag.
PreInstallationGuide succeeded.
```

### 错误排查

如果准备安装环境失败请根据openGauss日志目录“$GAUSSLOG/om”下的“gs_preinstall-YYYY-MM-DD_HHMMSS.log”和“gs_local-YYYY-MM-DD_HHMMSS.log”中的日志信息排查错误。例如配置文件中“gaussdbLogPath”参数指定的路径为“/var/log/gaussdb”，则“$GAUSSLOG/om”路径为“/var/log/gaussdb/omm/om”，omm用户为运行openGauss的用户。

>[!TIP]须知
>
>准备安装用户及环境的过程中会使用root添加定时任务用于定时巡检和上报。

## 手工建立互信

openGauss在安装过程中，需要在openGauss中的主机间执行命令、传送文件等操作。因此，在普通用户安装前需要确保互信是连通的。前置脚本中会先建立root用户间的互信，然后创建普通用户，并建立普通用户间的互信。

>[!TIP]须知
>
>root用户互信可能会存在安全隐患，因此建议用户在使用完成后，立即删除各主机上root用户的互信。

### 前提条件

- 确保ssh服务打开。
- 确保ssh端口不会被防火墙关闭。
- 确保xml文件中各主机名称和IP配置正确。
- 确保所有机器节点间网络畅通。
- 如果为普通用户建立互信，需要提前在各主机创建相同用户并设置密码。
- 如果各主机安装并启动了SELinux服务，需要确保/root和/home目录安全上下文为默认值（home目录：system_u:object_r:home_root_t:s0，root目录：system_u:object_r:admin_home_t:s0）或者关闭掉SELinux服务。

检查系统SELinux状态的方法：执行命令getenforce，如果返回结果是Enforcing，说明SELinux安装并启用。

检查目录安全上下文的命令：

    ```shell
    ls -ldZ  /root | awk '{print $4}'
    ```

    ```shell
    ls -ldZ  /home | awk '{print $4}'
    ```

恢复目录安全上下文命令：

    ```shell
    restorecon -r -vv /home/
    ```

    ```shell
    restorecon -r -vv /root/
    ```

### 使用脚本建立互信

1.创建一个执行互信脚本所需要的输入文本，并在此文件中添加openGauss中所有主机IP。

```shell
plat1:/opt/software/openGauss> vim hostfile
192.168.0.1
192.168.0.2
192.168.0.3
```

2.以需要创建互信的用户执行脚本。
3.执行下面脚本建立互信。

```shell
plat1:/opt/software/openGauss/script# ./gs_sshexkey -f /opt/software/hostfile
```

/opt/software/hostfile为主机列表，列出所有需要建立互信机器的主机IP。

### 手工建立互信

如果openGauss各主机的root密码不一致，gs_preinstall脚本无法建立互信，可以手工建立互信。

>[!NOTE]说明
>
>建立互信的过程中需要生成如下4个文件：authorized_keys、id_rsa、id_rsa.pub、known_hosts。请勿删除或破坏这些互信相关的文件。
>
手工建立信任关系，步骤如下，plat1、plat2、plat3是主机名：

1.在其中一个主机上，生成root用户的本机授权文件。假设在主机plat1上执行。

a. 生成密钥。

```shell
ssh-keygen -t rsa
```

示例如下：

```shell
plat1:~ # ssh-keygen -t rsa
Generating public/private rsa key pair.
Enter file in which to save the key (/root/.ssh/id_rsa):
Created directory '/root/.ssh'.
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /root/.ssh/id_rsa.
Your public key has been saved in /root/.ssh/id_rsa.pub.
The key fingerprint is:
d5:35:46:33:27:22:09:f0:1e:12:a7:87:fa:33:3f:ab root@plat1
The key's randomart image is:
+--[ RSA 2048]----+
|      o.o.....O .|
|       *  .o + * |
|      + + . .    |
|     . + o       |
|    .   S        |
|     .           |
|      +          |
|       +.        |
|      E.oo       |
+-----------------+
```

b. 生成本机授权文件。

```shell
cat .ssh/id_rsa.pub >> ~/.ssh/authorized_keys
```

示例如下：

```shell
plat1:~ # cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
```

2.收集所有的待建互信主机的公钥，写入到本机的known_hosts文件中。此步骤需要在步骤1执行的主机上执行。需要收集plat1、plat2、plat3三个主机的公钥。

a. 收集plat1的公钥，写入到本机known_hosts文件中。

```shell
ssh-keyscan -t rsa plat1 >> ~/.ssh/known_hosts
```

示例如下：

```shell
plat1:~ # ssh-keyscan -t rsa plat1 >> ~/.ssh/known_hosts
# plat1 SSH-2.0-OpenSSH_5.1
```

b. 收集plat2的公钥，写入到本机known_hosts文件中。

```shell
ssh-keyscan -t rsa plat2 >> ~/.ssh/known_hosts
```

示例如下：

```shell
plat1:~ # ssh-keyscan -t rsa plat2 >> ~/.ssh/known_hosts
# plat2 SSH-2.0-OpenSSH_5.1
```

c. 收集plat3的公钥，写入到本机known_hosts文件中。

```shell
ssh-keyscan -t rsa plat3 >> ~/.ssh/known_hosts
```

示例如下：

```shell
plat1:~ # ssh-keyscan -t rsa plat3 >> ~/.ssh/known_hosts
# plat3 SSH-2.0-OpenSSH_5.1
```

>[!NOTE]说明
>
>- 当远程主机的公钥被接受以后，它就会被保存在文件$HOME/.ssh/known_hosts之中。下次再连接这台主机，系统就会认出它的公钥已经保存在本地了，从而跳过警告部分。
>
>- 如果该主机上known_hosts文件被删除，互信仍然可以使用，但是会有告警提示信息。如果需要规避告警提示信息，请将/etc/ssh/ssh_config配置文件中，StrictHostKeyChecking参数设置为no。
>
>- root和omm用户都需要建立互信。 omm下除了使用节点名称建立互信外，还需要建立节点ip之间的互信。操作步骤同上，将节点名称替换为节点ip执行。

3.将互信文件分发到其它所有主机上。在本例中，需要将plat1上的互信文件分发到plat2和plat3上。

a. 将互信文件分发到plat2上。Password输入拷贝目标主机的密码。

```shell
scp -r ~/.ssh plat2:~
```

示例如下：

```shell
plat1:~ # scp -r ~/.ssh plat2:~
Password:
authorized_keys                 100%  796     0.8KB/s   00:00
id_rsa                          100% 1675     1.6KB/s   00:00
id_rsa.pub                      100%  398     0.4KB/s   00:00
known_hosts                     100% 1089     1.1KB/s   00:00
```

b. 将互信文件分发到plat3上。Password输入拷贝目标主机的密码。

```shell
scp -r ~/.ssh plat3:~
```

示例如下：

```shell
plat1:~ # scp -r ~/.ssh plat3:~
Password:
authorized_keys                 100%  796     0.8KB/s   00:00
id_rsa                          100% 1675     1.6KB/s   00:00
id_rsa.pub                      100%  398     0.4KB/s   00:00
known_hosts                     100% 1089     1.1KB/s   00:00
```

4.查看互信是否建成功，可以互相ssh主机名。输入exit退出。

```shell
plat1:~ # ssh plat2
Last login: Sat Jun 20 14:01:07 2020
plat2:~ # exit
logout
Connection to plat2 closed.
plat1:~ #
```

>[!NOTE]说明
>
>如果openGauss集群包含三个以上服务器节点，操作过程和上述步骤类似。假设节点名为plat1、plat2、plat3、......。第一步，需要在plat1上生成root用户的本机授权文件；第二步，需要收集所有待建互信主机(plat1、plat2、plat3、......)的公钥并写入到本机known_hosts文件中；第三步，需要将互信文件分发到除本机外的所有其它主机(plat2、plat3、......)上；第四步，检查互信是否建立成功。
>

### 删除root用户互信

为了避免root用户互信可能存在的安全隐患，因此建议用户在使用完成后，立即删除各主机上root用户的互信。

1.删除openGauss数据库各节点上的互信相关文件/root/.ssh。

```shell
rm –rf ~/.ssh
```

2.查看互信是否删除成功，可以互相ssh主机名，提示不能互信，互信删除成功。

```shell
plat1:\~ \# ssh plat2

he authenticity of host ' plssat2 \(plat2\)' can't be established.

ECDSA key fingerprint is SHA256:Q4DPRedFytsjsJSKf4l2lHKuzVw4prq3bIUCNVKIa7M.

ECDSA key fingerprint is MD5:e2:77:6c:aa:4c:43:5f:f2:c4:58:ec:d5:53:de:7c:fc.

Are you sure you want to continue connecting \(yes/no\)?
```

### 示例

root用户建立互信示例：

```shell
plat1:~ # gs_sshexkey -f /opt/software/hostfile -W Gauss_123
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
```

普通用户建立互信示例：

```shell
gaussdb@plat1:~ > gs_sshexkey -f /opt/software/hostfile -W Gauss_123
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
```

安全模式下建立互信示例，需要用户根据提示，手动输入建立互信的用户密码（建议使用安全模式）：

```shell
plat1:~ # gs_sshexkey -f /opt/software/hostfile
Please enter password for current user[root].
Password:
Checking network information.
All nodes in the network are Normal.
Successfully checked network information.
Creating SSH trust.
Creating the local key file.
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
```

## 配置操作系统参数

openGauss要求各主机上的操作系统参数设置成一定的值，以满足系统运行的性能要求等。

这些参数有些会在openGauss安装环境准备阶段完成设置，且这些参数将直接影响openGauss的运行状态，请仅在确认必要时进行手动调整。方法如下：

1.以root用户身份登录服务器。

2.对文件“/etc/sysctl.conf”进行编辑修改。

具体参数的修改请参见[操作系统参数](#操作系统参数)。

3.执行如下命令使修改配置生效。

```shell
sysctl -p
```

### 操作系统参数

**表 1**  操作系统参数

参数名称 参数说明 预安装时是否由脚本自动设置 推荐取值 net.ipv4.tcp_max_tw_buckets 表示同时保持TIME_WAIT状态的TCP/IP连接最大数量。如果超过所配置的取值，TIME_WAIT将立刻被释放并打印警告信息。
10000 net.ipv4.tcp_tw_reuse 允许将TIME-WAIT状态的sockets重新用于新的TCP连接。
0表示关闭。1表示开启。
net.ipv4.tcp_tw_recycle 表示开启TCP连接中TIME-WAIT状态sockets的快速回收。
0表示关闭。1表示开启。
net.ipv4.tcp_keepalive_time 表示当keepalive启用的时候，TCP发送keepalive消息的频度。
net.ipv4.tcp_keepalive_probes 在认定连接失效之前，发送TCP的keepalive探测包数量。这个值乘以tcp_keepalive_intvl之后决定了一个连接发送了keepalive之后可以有多少时间没有回应。
net.ipv4.tcp_keepalive_intvl 当探测没有确认时，重新发送探测的频度。
net.ipv4.tcp_retries1 在连接建立过程中TCP协议最大重试次数。
net.ipv4.tcp_syn_retries TCP协议SYN报文最大重试次数。
net.ipv4.tcp_synack_retries TCP协议SYN应答报文最大重试次数。
net.ipv4.tcp_retries2 控制内核向已经建立连接的远程主机重新发送数据的次数，低值可以更早的检测到与远程主机失效的连接，因此服务器可以更快的释放该连接。
发生“connection reset by peer”时可以尝试调大该值规避问题。
vm.overcommit_memory 控制在做内存分配的时候，内核的检查方式。
0：表示系统会尽量精确计算当前可用的内存。1：表示不作检查直接返回成功。2：内存总量×vm.overcommit_ratio/100＋SWAP的总量，如果申请空间超过此数值则返回失败。
内核默认是2过于保守，推荐设置为0，如果系统压力大可以设置为1。
net.ipv4.tcp_rmem TCP协议接收端缓冲区的可用内存大小。分无压力、有压力和压力大三个区间，单位为页面。
8192 250000 16777216 net.ipv4.tcp_wmem TCP协议发送端缓冲区的可用内存大小。分无压力、有压力和压力大三个区间，单位为页面。
8192 250000 16777216 net.core.wmem_max socket发送端缓冲区大小的最大值。
21299200 net.core.rmem_max socket接收端缓冲区大小的最大值。
21299200 net.core.wmem_default socket发送端缓冲区大小的默认值。
21299200 net.core.rmem_default socket接收端缓冲区大小的默认值。
21299200 net.ipv4.ip_local_port_range 物理机可用临时端口范围。
26000-65535 kernel.sem 内核信号量参数设置大小。
250 6400000 1000 25600 vm.min_free_kbytes 保证物理内存有足够空闲空间，防止突发性换页。
系统总内存的5% net.core.somaxconn 定义了系统中每一个端口最大的监听队列的长度，这是个全局的参数。
65535 net.ipv4.tcp_syncookies 当出现SYN等待队列溢出时，启用cookies来处理，可防范少量SYN攻击。
0表示关闭SYN Cookies。1表示开启SYN Cookies。
net.core.netdev_max_backlog 在每个网络接口接收数据包的速率比内核处理这些包的速率快时，允许送到队列的数据包的最大数目。
65535 net.ipv4.tcp_max_syn_backlog 记录的那些尚未收到客户端确认信息的连接请求的最大值。
65535 net.ipv4.tcp_fin_timeout 系统默认的超时时间。
kernel.shmall 内核可用的共享内存总量。
1152921504606846720 kernel.shmmax 内核参数定义单个共享内存段的最大值。
18446744073709551615 net.ipv4.tcp_sack 启用有选择的应答，通过有选择地应答乱序接受到的报文来提高性能，让发送者只发送丢失的报文段（对于广域网来说）这个选项应该启用，但是会增加对CPU的占用。
0表示关闭。1表示开启。
net.ipv4.tcp_timestamps TCP时间戳（会在TCP包头增加12节），以一种比重发超时更精确的方式（参考RFC 1323）来启用对RTT的计算，启用可以实现更好的性能。
0表示关闭。1表示开启。
vm.extfrag_threshold 系统内存不够用时，linux会为当前系统内存碎片情况打分，如果超过vm.extfrag_threshold的值，kswapd就会触发memory compaction。所以这个值设置的接近1000，说明系统在内存碎片的处理倾向于把旧的页换出，以符合申请的需要，而设置接近0，表示系统在内存碎片的处理倾向做memory compaction。
500 vm.overcommit_ratio 系统使用绝不过量分配内存的算法时，系统整个内存地址空间不得超过swap+RAM值的此参数百分比，当vm.overcommit_memory=2时此参数生效。
MTU 节点网卡最大传输单元。OS默认值为1500，调整为8192可以提升数据收发的性能。
8192

### 文件系统参数

- soft nofile

说明：soft nofile表示软限制，用户使用的文件句柄数量可以超过该限制，但是如果超过会有告警信息。

推荐取值：1000000

- hard nofile

说明：hard nofile表示硬限制，是一个严格的限制，用户使用的文件句柄数量一定不能超过该设置。

推荐取值：1000000

- stack size

说明：线程堆栈大小。

推荐值：3072

### transparent\_hugepage设置

openGauss默认关闭使用transparent\_hugepage服务，并将关闭命令写入操作系统启动文件。

### 文件句柄设置

需要对文件句柄数进行手动设置时，使用root用户执行如下命令进行参数修改：

```shell
echo "* soft nofile 1000000" >>/etc/security/limits.conf
echo "* hard nofile 1000000" >>/etc/security/limits.conf
```

完成修改后，需重启操作系统使得设置的参数生效。

**表 2**  文件句柄数设置

参数名 预安装时是否由脚本自动设置 推荐取值
* soft nofile
soft nofile表示软限制，即表示任何用户能打开的最大文件数量为1000000，不管它开启多少个shell。
1000000
* hard nofile
hard nofile表示硬限制，软限制要小于等于硬限制。
1000000

### 系统支持的最大进程数设置

需要对系统支持的最大进程数进行手动设置时，执行如下命令打开conf文件。

```shell
vim /etc/security/limits.d/90-nproc.conf
```

修改\* soft nproc参数。

完成修改后，需重启操作系统使得设置的参数生效。

**表 3**  系统支持的最大进程数设置

参数名 预安装时是否由脚本自动设置 推荐取值
* soft nproc
soft nproc参数用来限制每个用户的最大processes数量。
unlimited

### 网卡参数配置

**表 4**  网卡参数配置

参数名 预安装时是否由脚本自动设置 推荐取值 网卡接收队列长度设置 4096 网卡传送队列长度设置 4096

>[!TIP]须知
>
>- 网卡参数配置功能只针对万兆及万兆以上级别的业务网卡，即backIp1所绑定的网卡。
>
>- 设置网卡参数的命令只有在设置成功后，才会被写入系统启动文件。执行失败的信息会被记入后台日志中。
