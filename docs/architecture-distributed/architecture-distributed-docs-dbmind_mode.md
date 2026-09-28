# DBMind模式说明

## 关闭HISTORY记录

为了避免指令历史记录的安全隐患，在部署DBMind及其组件的服务之前，必须首先将各主机的history指令关闭。

1. 修改根目录下/etc/profile文件。

    ```
    vim /etc/profile
    ```

2. 设置HISTSIZE值为0。例如，系统中HISTSIZE默认值为1000，将其修改为0。

    ```
    HISTSIZE=0
    ```

3. 保存/etc/profile。

    ```
    :wq
    ```

4. 设置/etc/profile生效。

    ```
    source /etc/profile
    ```

用户在设置环境变量后，可通过gs\_dbmind命令调用DBMind下列基本功能：

- 服务功能：service子命令，包括创建并初始化配置目录、启动后台服务、关闭后台服务等；
- 调用组件：component子命令（如索引推荐、参数调优等）可通过该模式进行调用；
- 设置参数：set子命令，通过该命令，可以一键修改配置目录中的配置文件值；用户也可以通过文本编辑器进行手动修改。

例如，可以通过以下方法设置环境变量：

```
echo PATH=`pwd`/openGauss-DBMind:'$PATH' >> ~/.bashrc
echo 'export PATH' >> ~/.bashrc

source ~/.bashrc
```

用户可以通过 --help 选项获得上述模式的帮助信息，例如：

```
gs_dbmind --help
```

```
usage: [-h] [-v] {service,set,component,upgrade} ...

openGauss DBMind: An autonomous platform for openGauss

optional arguments:
  -h, --help            show this help message and exit
  -v, --version         show program's version number and exit

available subcommands:
  {service,set,component,upgrade}
                        type ' -h' for help on a specific subcommand
    service             send a command to DBMind to change the status of the service
    set                 set a parameter
    component           pass command line arguments to each sub-component.
    upgrade             update metadatabase and config files for the new dbmind, Notes: upgrade does not support cloud-native scenarios.
```

**表 1**  gs\_dbmind 选项基本说明

参数说明 取值范围 -h, --help 帮助命令。
-v, --version 版本号。
service 服务功能相关的子命令。
component 调用组件的子命令。
upgrade 升降级功能 set 修改配置文件的子命令。

- **[service子命令](service.md)**

- **[component子命令](component.md)**

- **[set子命令](dbmind_mode_set.md)**
