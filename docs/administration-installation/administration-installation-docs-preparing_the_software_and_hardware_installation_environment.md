# 准备软硬件安装环境

本章节描述安装前需要进行的环境准备。

## 软硬件环境要求

介绍openGauss的软硬件环境要求。建议部署openGauss的各服务器具有等价的软硬件配置。

**硬件环境要求**

[表1](#zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_t62cd0eed17004265b1b8ad98f302a4bc)列出了openGauss服务器应具备的最低硬件要求。在实际产品中，硬件配置的规划需考虑数据规模及所期望的数据库响应速度。请根据实际情况进行规划。

**表 1**  硬件环境要求

配置描述 功能调试建议32GB以上。
性能测试和商业部署时，单实例部署建议128GB以上。
复杂的查询对内存的需求量比较高，在高并发场景下，可能出现内存不足。此时建议使用大内存的机器，或使用负载管理限制系统的并发。
CPU 功能调试最小1×8核，2.0GHz。
性能测试和商业部署时，建议1×16核，2.0GHz。
CPU超线程和非超线程两种模式都支持。
用于安装openGauss的硬盘需最少满足如下要求： 至少1GB用于安装openGauss的应用程序。每个主机需大约300MB用于元数据存储。预留70%以上的磁盘剩余空间用于数据存储。
建议系统盘配置为RAID1，数据盘配置为RAID5，且规划4组RAID5数据盘用于安装openGauss。有关RAID的配置方法在本手册中不做介绍。请参考硬件厂家的手册或互联网上的方法进行配置，其中Disk Cache Policy一项需要设置为Disabled，否则机器异常掉电后有数据丢失的风险。
openGauss支持使用SSD盘作为数据库的主存储设备，支持SAS接口和NVME协议的SSD盘，以RAID的方式部署使用。
网络要求 300兆以上以太网。
建议网卡设置为双网卡冗余bond。有关网卡冗余bond的配置方法在本手册中不做介绍。请参考硬件厂商的手册或互联网上的方法进行配置。

**软件环境要求**

**表 2**  软件环境要求

name="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_tfb195a8129b24c709d238b091e57405a"> <tr id="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_rbb0bb8c17c0c49fc9666f58bdd5487bb"> id="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_a177f29c592264a53a346a3b6c33a3ea0"> name="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_a177f29c592264a53a346a3b6c33a3ea0"><a name="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_a177f29c592264a53a346a3b6c33a3ea0">软件类型 id="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_a39384e588fc744db804eb3f5beecaa53"> name="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_a39384e588fc744db804eb3f5beecaa53"><a name="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_a39384e588fc744db804eb3f5beecaa53">配置描述 <tr id="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_rd18980a861d444ad8e87a077e7785e40"> id="zh-cn_topic_0283136474_zh-cn_topic_0085434629_zh-cn_topic_0059782022_a6036b745c87c44ab85a2f6cec7c4e5da"> name="zh-cn_topic_0283136474_zh-cn_topic_0085434629_zh-cn_topic_0059782022_a6036b745c87c44ab85a2f6cec7c4e5da"><a name="zh-cn_topic_0283136474_zh-cn_topic_0085434629_zh-cn_topic_0059782022_a6036b745c87c44ab85a2f6cec7c4e5da">Linux操作系统 name="zh-cn_topic_0283136474_ul2800840102316"><a name="zh-cn_topic_0283136474_ul2800840102316"> ARM：<a name="zh-cn_topic_0283136474_ul177759349286"> openEuler 20.03 LTS（推荐采用此操作系统） openEuler 22.03 LTS openEuler 24.03 LTS 麒麟V10 Asianux 7.5 统信V20 x86：<a name="zh-cn_topic_0283136474_ul851564911283"> openEuler 20.03 LTS openEuler 22.03 LTS openEuler 24.03 LTS CentOS 7.6 Asianux 7.6 麒麟V10

<tr id="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_rf52ebb45df8e4f57882a97bef3b36ca6"> id="zh-cn_topic_0283136474_zh-cn_topic_0085434629_zh-cn_topic_0059782022_a6f023000ee654c70b98c163f8c9b5d99"> name="zh-cn_topic_0283136474_zh-cn_topic_0085434629_zh-cn_topic_0059782022_a6f023000ee654c70b98c163f8c9b5d99"><a name="zh-cn_topic_0283136474_zh-cn_topic_0085434629_zh-cn_topic_0059782022_a6f023000ee654c70b98c163f8c9b5d99">Linux文件系统 name="zh-cn_topic_0283136474_p537517310381">剩余inode个数 &gt; 15亿（推荐） name="zh-cn_topic_0283136474_p682172212430">工具 name="zh-cn_topic_0283136474_p582112294311">bzip2 name="zh-cn_topic_0289899729_zh-cn_topic_0283136474_p075762219324"><a name="zh-cn_topic_0289899729_zh-cn_topic_0283136474_p075762219324">Python name="zh-cn_concept_0283139016_ul1537120034117"><a name="zh-cn_concept_0283139016_ul1537120034117"> 支持Python3.6+

**软件依赖要求**

openGauss的软件依赖要求如[表3](#zh-cn_topic_0283136474_table1212531681911)所示。

建议使用上述操作系统安装光盘或者源中，下列依赖软件的默认安装包，若不存在下列软件，可参看软件对应的建议版本。

**表 3**  软件依赖要求

所需软件 建议版本 libaio-devel 建议版本：0.3.109-13

readline-devel 建议版本：7.0-13 expect libedit-devel 建议版本：3.0-3.1 libxml2-devel 建议版本：2.9.1-2.11.5 lz4-devel 建议版本：1.8.3-1.9.4 numactl-devel 建议版本：2.0.12-2.0.16 unixODBC-devel 建议版本：2.3.1-2.3.9 java-1.8.0-openjdk-devel 建议版本：1.8 openblas-devel 建议版本：0.3.3及以上

```shell
yum install libaio-devel readline-devel expect libedit-devel libxml2-devel lz4-devel numactl-devel unixODBC-devel java-1.8.0-openjdk-devel openblas-devel
```

## 修改操作系统配置

**注意：**

以下动作需要以root用户进行操作，操作完成后请及时注销root用户，避免误操作。

### **关闭操作系统防火墙**

为了在防火墙开启的状态下，确保openGauss的正常使用，用户需要将同openGauss相关的服务、协议、IP以及端口添加到openGauss主机的防火墙白名单中。

以openEuler操作系统为例，假设openGauss信息如[表4](#zh-cn_topic_0283136490_zh-cn_topic_0241802566_zh-cn_topic_0085434636_zh-cn_topic_0059782018_table4312170510523)所示。

**表 4**  openGauss信息

主机名称 内部IP 外部IP plat1
192.168.0.11
10.10.0.11
管理网络
10.10.64.236

目前仅支持在防火墙关闭的状态下进行安装。

1. 修改/etc/selinux/config文件中的“SELINUX”值为“disabled”。

a.  使用VIM打开config文件。
        ```shell
        vim /etc/selinux/config
        ```
b.  修改“SELINUX”的值“disabled”，执行**:wq**保存并退出修改。
        ```shell
        SELINUX=disabled
        ```
2. 重新启动操作系统。

    ```
    reboot
    ```

3. 检查防火墙是否关闭。

    ```
    systemctl status firewalld
    ```

若防火墙状态显示为active \(running\)，则表示防火墙未关闭，请执行[4](#zh-cn_topic_0283136490_li17330102819394)；

若防火墙状态显示为inactive \(dead\)，则无需再关闭防火墙。

4. 关闭防火墙。

    ```
    systemctl disable firewalld.service
    systemctl stop firewalld.service
    ```

5. 在其他主机上重复步骤1到步骤4。

### **设置字符集参数**

将各数据库节点的字符集设置为相同的字符集，可以在/etc/profile文件中添加“export LANG=XXX”（XXX为Unicode编码）。

```
vim /etc/profile
```

### **设置时区和时间**

在各数据库节点上，确保时区和时间一致。

1. 执行如下命令检查各数据库节点时间和时区是否一致。如果各数据库节点时间和时区不一致区，请执行[步骤2](#zh-cn_topic_0283136490_li1238816343545)\~[步骤3](#zh-cn_topic_0283136490_li153615819546)。

    ```
    date
    ```

2. 使用如下命令将各数据库节点/usr/share/zoneinfo/目录下的时区文件拷贝为/etc/localtime文件。

    ```
    cp /usr/share/zoneinfo/$地区/$时区 /etc/localtime
    ```

>[!NOTE]说明
>`$地区/$时区`为需要设置时区的信息，例如：Asia_Shanghai。

3. 使用**date -s**命令将各数据库节点的时间设置为统一时间，举例如下。

    ```
    date -s "Sat Sep 27 16:00:07 CST 2020"
    ```

### **（可选）关闭swap交换内存**

>[!NOTE]说明
>
>关闭swap交换内存是为了保障数据库的访问性能，避免把数据库的缓冲区内存淘汰到磁盘上。 如果服务器内存比较小，内存过载时，可打开swap交换内存保障正常运行。

在各数据库节点上，使用swapoff -a命令将交换内存关闭。

```
swapoff -a
```

### **关闭RemoveIPC**

在各数据库节点上，关闭RemoveIPC。CentOS操作系统默认为关闭，可以跳过该步骤。

1. 修改/etc/systemd/logind.conf文件中的“RemoveIPC”值为“no”。

a.  使用VIM打开logind.conf文件。

    ```shell
    vim  /etc/systemd/logind.conf
    ```

b.  修改“RemoveIPC”值为“no”。

    ```shell
    RemoveIPC=no
    ```

2. 修改/usr/lib/systemd/system/systemd-logind.service文件中的“RemoveIPC”值为“no”。

a.  使用VIM打开systemd-logind.service文件。

    ```shell
    vim /usr/lib/systemd/system/systemd-logind.service
    ```

b.  修改“RemoveIPC”值为“no”。

    ```shell
    RemoveIPC=no
    ```

3. 重新加载配置参数。

    ```shell
    systemctl daemon-reload
    systemctl restart systemd-logind
    ```

4. 检查修改是否生效。

    ```shell
    loginctl show-session | grep RemoveIPC
    systemctl show systemd-logind | grep RemoveIPC
    ```

5. 在其他主机上重复[步骤1](#zh-cn_topic_0283136490_zh-cn_topic_0241802566_li17785744465)到[步骤4](#zh-cn_topic_0283136490_li17330102819394)。

### 关闭HISTORY记录

>[!NOTE]说明
>
> 为避免指令历史记录安全隐患，需关闭各主机的history指令。

步骤 1 修改根目录下/etc/profile文件。

```
vim /etc/profile
```

步骤 2 设置HISTSIZE值为0。例如，系统中HISTSIZE默认值为1000，将其修改为0。

```
HISTSIZE=0
```

步骤 3 保存/etc/profile。

```
:wq
```

步骤 4 设置/etc/profile生效。

```
source /etc/profile
```
