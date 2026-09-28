# 搭建编译环境

## 硬件要求

编译openGauss的硬件要求：

- 机器数量：1台
- 机器硬件规格：
  - CPU：4U（64位）
  - Memory：8G
  - Free Disk：100G

## 软件要求

**操作系统要求**

openGauss支持的操作系统（Linux 64位）：

- CentOS 7.6（x86_64 架构）
- openEuler-20.03-LTS（aarch64 架构）
- openEuler-20.03-LTS（x86_64架构）
- openEuler-22.03-LTS（aarch64 架构）
- openEuler-22.03-LTS（x86_64架构）
- openEuler-24.03-LTS（aarch64 架构）
- openEuler-24.03-LTS（x86_64架构）
- Kylin-V10（aarch64 架构）
- Asianux 7.6（x86_64架构）
- Asianux 7.5（aarch64 架构）
- FusionOS 22 (aarch64 架构)
- FusionOS 22 (x86 架构)

**软件依赖要求**

编译openGauss的软件依赖要求如[表 1 软件依赖要求](#table1212531681911)所示。

建议使用上述操作系统安装光盘或者源中，下列依赖软件的默认安装包，若不存在下列软件，可参看软件对应的建议版本。

**表 1**  软件依赖要求

所需软件 建议版本 libaio-devel 建议版本：0.3.109-13 flex 要求版本：2.5.31 以上 bison 建议版本：2.7-4 ncurses-devel 建议版本：5.9-13.20130511 glibc-devel 建议版本：2.17-111 patch 建议版本：2.7.1-10 redhat-lsb-core 建议版本：4.1 readline-devel 建议版本：7.0-13 libedit-devel 建议版本：3.0-3.1 libxml2-devel 建议版本：2.9.1-2.11.5 lz4-devel 建议版本：1.8.3-1.9.4 numactl-devel 建议版本：2.0.12-2.0.16 unixODBC-devel 建议版本：2.3.1-2.3.9 java-1.8.0-openjdk-devel 建议版本：1.8 openblas-devel 建议版本：0.3.3及以上

```shell
yum install libaio-devel flex bison ncurses-devel glibc-devel patch readline-devel libedit-devel libxml2-devel lz4-devel numactl-devel unixODBC-devel java-1.8.0-openjdk-devel openblas-devel
### centos中安装lsb_release
yum install redhat-lsb-core
### openEuler安装lsb_release
yum install dkms
```

## 环境变量配置

编译openGauss的环境变量配置已经统一写入一键式编译和打包脚本，因此无需自行配置。

若不想使用一键式编译脚本，则需要手动配置环境变量，将在[版本编译](compiling_the_version.md)文档中的“软件安装编译”里介绍。
