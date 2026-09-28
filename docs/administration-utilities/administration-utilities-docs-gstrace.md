# gstrace

## 功能介绍

gstrace是openGauss提供的用来跟踪内核代码执行路径、记录内核数据结构、分析代码性能的工具。Trace的有限点位和数据在版本中被固化，无法动态添加和删除。

>[!WARNING]注意
>
>1. 对内核dump指定内存变量的数据用于诊断分析，不存在直接指定任意寄存器或者内存地址的行为。读取的内存地址均是在开发阶段硬编码，没有任意地读取或者修改寄存器或内存的操作。
>2. Trace点可能涉及敏感数据，收集trace信息前需要同用户协商，授权和许可后方可收集。
>3. openGauss不会在敏感信息上打点，不会TRACE和用户相关的数据。
>4. Trace仅用于诊断目的，开启trace将对性能产生一定影响，影响的大小视负载的高低，trace的模块而不同。
>5. Trace工具的权限为0700，仅限于数据库用户读、写和执行。

>[!NOTE]说明
>如果进程异常终止，/dev/shm/ 目录下将会有gstrace\_trace\_cfg\_\*残留，可以手动清除。

## 语法

```
gstrace [start|stop|config|dump|detailcodepath|analyze] [-p ][-s ] [-f ] [-o ] [-t ]
```

## 参数说明

**表 1**  gstrace参数说明

start 开始记录trace。
stop 停止trace，释放存储信息的共享内存trace buffer。注意：trace buffer中已捕获trace信息会丢失。
config 显示trace的配置信息。
dump 将共享内存中的trace信息写入指定文件。若没有启动trace将报错。
detail 将dump出来的二进制文件解析成文本文件，显示trace点的线程、时间信息。
codepath 提取dump文件中的函数调用信息，按照调用栈的方式显示。
analyze 统计各个函数的执行次数、总耗时、平均耗时、最长耗时、最短耗时。
-p PORT 指定启动trace功能的实例侦听的端口号。
-f DUMP_FILE 指定dump导出的trace文件。
-o OUTPUT_FILE 指定写入的文件。
-t STEP_SIZE 指定分片分析的时间跨度（秒）,可选。将生成单独的{OUTPUT_FILE}.step文件。
-m MASK

指定哪些模块、函数需要追踪。参数不得为空。
格式：  &#60;COMP_FUNC_PAIR&#62; [,&#60;COMP_FUNC_PAIR&#62;]* 描述： &#60;COMP_FUNC_PAIR&#62; -> &#60;COMP_NAME&#62;.&#60;FUNC_NAME&#62;
COMP_FUNC_PAIR 代表一组模块与函数组合。
COMP_NAME 代表一个模块名。
&#60;FUNC_NAMES&#62; -> ALL|[&#60;FUNC_NAME&#62;[&#38;&#60;FUNC_NAME&#62;]*] FUNC_NAMES 可由用户指定为ALL 或者一个及以上的函数名。由于FUNC_NAMES一定是与COMP_NAME组合，因此，ALL代表追踪以COMP_NAME为名的模块的所有函数；而如果用户指定的是一个及以上的函数名，则是追踪以COMP_NAME为名的模块中的这几个指定FUNC_NAME对应的函数名。

示例： access.StartTransaction: 追踪一个模块access中的函数StartTransaction。
executer.ExecutorStart&ExecInitExpr: 追踪一个模块executer中的函数ExecutorStart和ExecInitExpr。
executer.ExecutorStart,tcop.PortalStart&PortalRun: 追踪模块executer中的ExecutorStart函数和模块tcop中的函数 PortalStart和PortalRun。
executer.ALL,access.ALL: 追踪模块executer和access中的所有函数。

-s BUFFER_SIZE 指定用于trace功能的共享内存大小，默认为1G。如果指定的BUFFER_SIZE小于最小值2048，系统将自动调整为最小值。如果指定的BUFFER_SIZE不是2^N（二的N次方），则向下对齐2^N；例如：指定BUFFER_SIZE=3072，由于2^11&lt;3072&lt;2^12，系统将调整为2048。

## 示例

1. 启动trace

    ```
    gstrace start -p 8000
    ```

2. 停止trace

    ```
    gstrace stop -p 8000
    ```

3. 查看trace配置

    ```
    gstrace config -p 8000
    ```

4. dump trace

    ```
    gstrace dump -p 8000 -o /data/8000.dump
    ```

5. 解析dump detail信息

    ```
    gstrace detail -f /data/8000.dump -o /data/8000.detail
    ```

6. 解析dump codepath

    ```
    gstrace codepath -f /data/8000.dump -o /data/8000.codepath
    ```

7. 分析全局性能

    ```
    gstrace analyze -f /data/8000.dump -o /data/8000.perf
    ```

8. 分析分片性能

    ```
    gstrace analyze -f /data/8000.dump -o /data/8000.perf -t 1
    ```
