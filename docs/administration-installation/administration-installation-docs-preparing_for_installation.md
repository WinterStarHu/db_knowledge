# 安装准备

本章详细介绍openGauss极简安装的环境准备和配置，极简安装包括单节点安装和一主一备节点安装，请在安装之前仔细阅读本章的内容。如果已完成本章节的配置，请忽略。

## 获取安装包

### 操作步骤

1. 从openGauss开源社区下载对应平台的安装包。
  1. 登录[openGauss开源社区](https://opengauss.org/zh/download/)，选择对应平台的最新安装包下载。对于个人开发者或非企业级环境，下载极简安装包（不安装OM等组件）即可。
  2. 单击“下载”。

2. 检查安装包。

解压安装包，检查安装目录及文件是否齐全。在安装包所在目录执行以下命令：

    ```
    mkdir openGauss
    tar -jxf openGauss-Server-x.x.x-openEuler20.03-x86_64.tar.bz2 –C openGauss
    ls -lb openGauss/
    ```

执行ls命令，显示类似如下信息：

    ```
    total 90296
    drwx------ 3 root root     4096 Mar 31 21:18 bin
    drwx------ 3 root root     4096 Mar 31 21:18 etc
    drwx------ 3 root root     4096 Mar 31 21:18 include
    drwx------ 4 root root     4096 Mar 31 21:18 jre
    drwx------ 5 root root     4096 Mar 31 21:18 lib
    drwx------ 5 root root     4096 Mar 31 21:18 share
    drwx------ 2 root root     4096 Mar 31 21:18 simpleInstall
    -rw------- 1 root root       32 Mar 31 21:18 version.cfg
    ```

### 安装包完整性校验

为了确认软件包在传输过程中由于网络原因或者存储设备原因是否出现下载不完整的问题，在获取到软件包后，需要对软件包的完整性进行校验，通过了校验的软件包才能被部署。
这里通过对比校验文件中记录的校验值和手动方式计算的文件校验值，判断软件包是否完整。若两个值相同，说明文件完整，否则，文件完整性被破坏，请重新获取发布包。

#### 指导操作

文完整性校验操作步骤如下：

1. 计算文件的sha256校验值。linux执行命令如下：

    ```
    sha256sum openGauss-OM-6.0.0-openEuler20.03-aarch64.tar.gz
    sha256sum openGauss-Server-6.0.0-openEuler20.03-aarch64.tar.bz2
    ```

命令执行完成后，输出校验值。

2. 判断步骤1计算的两个校验值分别与校验文件1和校验文件2中的值是否一致。
如果校验值一致说明文件完整性没有破坏，如果校验值不一致则可以确认文件完整性已被破坏，需要重新获取。

## 准备软硬件安装环境

本章节描述安装前需要进行的环境准备。建议部署openGauss的各服务器具有等价的软硬件配置。

### 硬件环境要求

[表1 硬件环境要求](#zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_t62cd0eed17004265b1b8ad98f302a4bc)列出了openGauss服务器应具备的最低硬件要求。在实际产品中，硬件配置的规划需考虑数据规模及所期望的数据库响应速度。请根据实际情况进行规划。

**表 1**  硬件环境要求

<tr id="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_r22159407d305418785de8468729ae773"> id="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_aeb26fbf45f264229a75a015d5e872c73"> name="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_aeb26fbf45f264229a75a015d5e872c73"><a name="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_aeb26fbf45f264229a75a015d5e872c73">项目 id="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_ae6742eb120254caba0d2e3e8d78d3ce6"> name="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_ae6742eb120254caba0d2e3e8d78d3ce6"><a name="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_ae6742eb120254caba0d2e3e8d78d3ce6">配置描述 <tr id="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_r6e9f20e9463c41fa8ce77903aa38e901"> id="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_aac597314796e4f32be5624781db96791"> name="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_aac597314796e4f32be5624781db96791"><a name="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_aac597314796e4f32be5624781db96791">内存 id="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_a1eb44a187b20406fa74eee0a502319b1"> name="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_a1eb44a187b20406fa74eee0a502319b1"><a name="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_a1eb44a187b20406fa74eee0a502319b1">功能调试建议32GB以上。
name="zh-cn_topic_0283136474_zh-cn_topic_0241802565_p2733433132815"><a name="zh-cn_topic_0283136474_zh-cn_topic_0241802565_p2733433132815">性能测试和商业部署时，单实例部署建议128GB以上。
id="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_ab636748c0876485b987945069966473e"> name="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_ab636748c0876485b987945069966473e"><a name="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_ab636748c0876485b987945069966473e">复杂的查询对内存的需求量比较高，在高并发场景下，可能出现内存不足。此时建议使用大内存的机器，或使用负载管理限制系统的并发。
<tr id="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_row18457708163752"> id="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_p18679412163752"> name="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_p18679412163752"><a name="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_p18679412163752">CPU id="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_p36637388163752"> name="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_p36637388163752"><a name="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_p36637388163752">功能调试最小1×8 核 2.0GHz。
name="zh-cn_topic_0283136474_zh-cn_topic_0241802565_p655107143013"><a name="zh-cn_topic_0283136474_zh-cn_topic_0241802565_p655107143013">性能测试和商业部署时，建议1×16核
2.0GHz。
id="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_p2939854163851"> name="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_p2939854163851"><a name="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_p2939854163851">CPU超线程和非超线程两种模式都支持。

<tr id="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_rc2f89a29186544e79e7995d19878a617"> id="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_aeb29f61cf13345269542500c96fa3370"> name="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_aeb29f61cf13345269542500c96fa3370"><a name="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_aeb29f61cf13345269542500c96fa3370">硬盘 id="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_p27815444154057"> name="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_p27815444154057"><a name="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_p27815444154057">用于安装<span id="zh-cn_topic_0283136474_text434316502057"><a name="zh-cn_topic_0283136474_text434316502057"><a name="zh-cn_topic_0283136474_text434316502057">openGauss的硬盘需最少满足如下要求： name="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_ul38458483154057"><a name="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_ul38458483154057"> <ul id="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_ul38458483154057"> 至少1GB用于安装<a name="zh-cn_topic_0283136474_text119716545518"><a name="zh-cn_topic_0283136474_text119716545518">openGauss的应用程序。
每个主机需大约300MB用于元数据存储。
预留70%以上的磁盘剩余空间用于数据存储。
id="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_p1864232295654"> name="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_p1864232295654"><a name="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_p1864232295654">建议系统盘配置为Raid1，数据盘配置为Raid5，且规划4组Raid5数据盘用于安装<span id="zh-cn_topic_0283136474_text977517418"><a name="zh-cn_topic_0283136474_text977517418">openGauss。有关Raid的配置方法在本手册中不做介绍。请参考硬件厂家的手册或互联网上的方法进行配置，其中Disk Cache Policy一项需要设置为Disabled，否则机器异常掉电后有数据丢失的风险。
id="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_p32157354152912"> name="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_p32157354152912"><a name="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_p32157354152912"><span id="zh-cn_topic_0283136474_text283517517410"><a name="zh-cn_topic_0283136474_text283517517410"><a name="zh-cn_topic_0283136474_text283517517410">openGauss支持使用SSD盘作为数据库的主存储设备，支持SAS接口和NVME协议的SSD盘，以RAID的方式部署使用。
<tr id="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_rfd1c9b77d83d4ffba092bdfbdc322881"> id="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_a176cf03cd96e4828a9fcb162c5013968"> name="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_a176cf03cd96e4828a9fcb162c5013968"><a name="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_a176cf03cd96e4828a9fcb162c5013968">网络要求 id="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_a3f99d3fb009c4aeaae03e63a481f33ff"> name="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_a3f99d3fb009c4aeaae03e63a481f33ff"><a name="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_a3f99d3fb009c4aeaae03e63a481f33ff">300兆以上以太网。
id="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_p64430430154726"> name="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_p64430430154726"><a name="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_p64430430154726">建议网卡设置为双网卡冗余bond。有关网卡冗余bond的配置方法在本手册中不做介绍。请参考硬件厂商的手册或互联网上的方法进行配置。

### 软件环境要求

**表 2**  软件环境要求

<tr id="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_rbb0bb8c17c0c49fc9666f58bdd5487bb"> id="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_a177f29c592264a53a346a3b6c33a3ea0"> name="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_a177f29c592264a53a346a3b6c33a3ea0"><a name="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_a177f29c592264a53a346a3b6c33a3ea0">软件类型 id="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_a39384e588fc744db804eb3f5beecaa53"> name="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_a39384e588fc744db804eb3f5beecaa53"><a name="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_a39384e588fc744db804eb3f5beecaa53">配置描述 <tr id="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_rd18980a861d444ad8e87a077e7785e40"> id="zh-cn_topic_0283136474_zh-cn_topic_0085434629_zh-cn_topic_0059782022_a6036b745c87c44ab85a2f6cec7c4e5da"> name="zh-cn_topic_0283136474_zh-cn_topic_0085434629_zh-cn_topic_0059782022_a6036b745c87c44ab85a2f6cec7c4e5da"><a name="zh-cn_topic_0283136474_zh-cn_topic_0085434629_zh-cn_topic_0059782022_a6036b745c87c44ab85a2f6cec7c4e5da">Linux操作系统 name="zh-cn_topic_0283136474_ul2800840102316"><a name="zh-cn_topic_0283136474_ul2800840102316"> ARM：<a name="zh-cn_topic_0283136474_ul177759349286"> openEuler 20.03 LTS（推荐采用此操作系统） openEuler 22.03 LTS openEuler 24.03 LTS 麒麟V10 Asianux 7.5 统信V20 X86：<a name="zh-cn_topic_0283136474_ul851564911283"> openEuler 20.03 LTS openEuler 22.03 LTS openEuler 24.03 LTS CentOS 7.6 Asianux 7.6 麒麟V10

<tr id="zh-cn_topic_0283136474_zh-cn_topic_0241802565_zh-cn_topic_0085434629_zh-cn_topic_0059782022_rf52ebb45df8e4f57882a97bef3b36ca6"> id="zh-cn_topic_0283136474_zh-cn_topic_0085434629_zh-cn_topic_0059782022_a6f023000ee654c70b98c163f8c9b5d99"> name="zh-cn_topic_0283136474_zh-cn_topic_0085434629_zh-cn_topic_0059782022_a6f023000ee654c70b98c163f8c9b5d99"><a name="zh-cn_topic_0283136474_zh-cn_topic_0085434629_zh-cn_topic_0059782022_a6f023000ee654c70b98c163f8c9b5d99">Linux文件系统 name="zh-cn_topic_0283136474_p537517310381">剩余inode个数 &gt; 15亿（推荐） name="zh-cn_topic_0283136474_p682172212430">工具 name="zh-cn_topic_0283136474_p582112294311">bzip2

### 软件依赖要求

openGauss的软件依赖要求如[表3 软件依赖要求](#zh-cn_topic_0283136474_table1212531681911)所示。

建议使用上述操作系统安装光盘或者源中，下列依赖软件的默认安装包，若不存在下列软件，可参看软件对应的建议版本。

**表 3**  软件依赖要求

name="zh-cn_topic_0283136474_p14178216101910">所需软件 name="zh-cn_topic_0283136474_p1117815167195">建议版本 name="zh-cn_topic_0283136474_p111791816141910">libaio-devel name="zh-cn_topic_0283136474_p101791116151915">建议版本：0.3.109-13 name="zh-cn_topic_0283136474_p1718842421419">readline-devel name="zh-cn_topic_0283136474_p0189112418140">建议版本：7.0-13 libnsl（openEuler+x86环境中） 建议版本 ：2.28-36 libedit-devel 建议版本：3.0-3.1 libxml2-devel 建议版本：2.9.1-2.11.5 lz4-devel 建议版本：1.8.3-1.9.4 numactl-devel 建议版本：2.0.12-2.0.16 unixODBC-devel 建议版本：2.3.1-2.3.9 java-1.8.0-openjdk-devel 建议版本：1.8 openblas-devel 建议版本：0.3.3及以上

```shell
yum install libaio-devel readline-devel libnsl libedit-devel libxml2-devel lz4-devel numactl-devel unixODBC-devel java-1.8.0-openjdk-devel openblas-devel
```
