# gs\_uninstall

## 背景信息

openGauss提供了gs\_uninstall工具来帮助完成openGauss的卸载。

## 语法

- 卸载openGauss

    ```
    gs_uninstall [--delete-data] [--clear-disk] [-L] [-l LOGFILE]
    ```

- 显示帮助信息

    ```
    gs_uninstall -? | --help
    ```

- 显示版本号信息

    ```
    gs_uninstall -V | --version
    ```

## 参数说明

- --delete-data

删除数据文件。

- --clear-disk

清除资源池化场景下LUN上的数据。

- -L

只卸载本地主机。如果openGauss内某主机做单点卸载后，openGauss不能再做全量卸载。

- -l

指定日志文件名及可访问的绝对路径。在内部会自动给日志名添加一个时间戳。

  - 当既不明确指定-l，又不在XML文件中配置gaussdbLogPath时，默认值为“$GAUSSLOG/om/gs\_uninstall-YYYY-MM-DD\_hhmmss.log”。
  - 当不明确指定-l，但在XML文件中配置了gaussdbLogPath时，默认值为“gaussdbLogPath/用户名/om/gs\_uninstall-YYYY-MM-DD\_hhmmss.log”。

>[!NOTE]说明
>由于在执行gs\_uninstall时，系统会自动删除openGauss相关目录。因此建议用户通过该参数指定日志文件到非openGauss相关路径。

- -?, --help

显示帮助信息。

- -V, --version

显示版本号信息。

## 示例

使用数据库用户执行gs\_uninstall脚本进行卸载openGauss。

```
gs_uninstall --delete-data
Checking unInstallationGuide.
Successfully checked unInstallationGuide.
Stopping the cluster.
Successfully stopped the cluster.
Successfully deleted instances.
Uninstalling application.
Successfully uninstalled application.
UnInstallationGuide succeeded.
```

## 相关命令

[gs\_install](gs_install.md)，[gs\_postuninstall](gs_postuninstall.md)
