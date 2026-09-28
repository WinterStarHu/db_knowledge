# SQLdiag

SQLdiag是openGauss中SQL语句执行时长预测工具。现有的预测技术主要基于执行计划的预测方法，但这些预测方案仅适用于分析型场景且可以获取执行计划的任务，对于OLTP或者HTAP这样的快速、简单查询是没有太多使用价值的。与上述方案不同，SQLdiag着眼于数据库的历史SQL语句，通过对历史SQL语句的执行表现进行总结归纳，将之再用于推断新的未知业务上。由于短时间内数据库SQL语句执行时长不会有太大的差距，SQLdiag可以从历史数据中检测出与已执行SQL语句相似的语句结果集，并基于SQL向量化技术通过SQL模板化和深度学习这两种方法来预测SQL语句执行时长。本工具有如下优点：

- 不需要SQL语句的执行计划，对数据库性能不会有任何的影响。
- 使用场景广泛，目前业内的很多算法局限性比较高，比如只适用于OLTP或者其他场景，而SQLdiag使用场景广泛。
- 该工具容易理解，只需要简单的操作，就可以训练出自己的预测模型。

本工具的典型应用场景是对一批即将上线的SQL语句进行透视，提前识别风险。

## 概述

SQLdiag是一个SQL语句执行时间预测工具。

通过模板化方法或者深度学习方法，实现在不获取SQL语句执行计划的前提下，依据语句逻辑相似度与历史执行记录，预测SQL语句的执行时间并以此发现异常SQL。

## 使用指导

### 前提条件与使用事项

- 需要保证用户提供训练数据。
- 如果用户通过提供的工具收集训练数据，则需要启用WDR功能，涉及到的参数为track\_stmt\_stat\_level和log\_min\_duration\_statement，具体情况见下面小结。
- 为保证预测准确率，用户提供的历史语句日志应尽可能全面并具有代表性。

### SQL流水采集方法

本工具需要用户提前准备数据，训练数据格式如下，每个样本通过换行符分隔：

```
SQL,EXECUTION_TIME
```

预测数据格式如下：

```
SQL
```

其中SQL表示SQL语句的文本，EXECUTION\_TIME表示SQL语句的执行时间，样例数据见sample\_data中的train.csv和predict.csv。

用户可以按照要求格式自己收集训练数据，工具也提供了脚本自动采集（load\_sql\_from\_rd），该脚本基于WDR报告获取SQL信息，涉及到的参数有log\_min\_duration\_statement和track\_stmt\_stat\_level：

- 其中log\_min\_duration\_statement表示慢SQL阈值，如果为0则全量收集，时间单位为毫秒；
- track\_stmt\_stat\_level表示信息捕获的级别，建议设置为track\_stmt\_stat\_level='L0,L0'

参数开启后，可能占用一定的系统资源，但一般不大。持续的高并发场景可能产生5%以内的损耗，数据库并发较低的场景，性能损耗可忽略。下述脚本存在于sqldiag根目录（$DBMINDPATH/dbmind/components/sqldiag）中。

```
使用脚本获取训练集方式：
usage: load_sql_from_wdr.py [-h] --port PORT --start-time START_TIME --finish-time FINISH_TIME [--save-path SAVE_PATH]

Fetch SQL information based on WDR.

optional arguments:
  -h, --help            show this help message and exit
  --port PORT, --db-port PORT
                        Port of database service.
  --start-time START_TIME
                        Start time of query
  --finish-time FINISH_TIME, --end-time FINISH_TIME
                        Finish time of query
  --save-path SAVE_PATH
                        Path to save result

例如：
    python load_sql_from_wdr.py --start-time "2021-04-25 00:00:00" --finish-time "2021-04-26 14:00:00" --port 5432  --save-path ./data.csv
```

### 操作步骤

1. 提供历史日志以供模型训练。
2. 进行训练与预测操作。
  - 基于模板法的训练与预测：

        ```
        gs_dbmind component sqldiag [train, predict] -f FILE --model template --model-path template_model_path --config-file config_path
        ```

  - 基于DNN的训练与预测：

        ```
        gs_dbmind component sqldiag [train, predict] -f FILE --model dnn --model-path dnn_model_path --config-file config_path
        ```

### 使用方法示例

- 使用提供的测试数据进行模板化训练：

    ```
    gs_dbmind component sqldiag train -f DBMINDPATH/dbmind/components/sqldiag/sample_data/train.csv --model template --model-path ./template --config-file config_path
    ```

- 使用提供的测试数据进行模板化预测：

    ```
    gs_dbmind component sqldiag predict -f DBMINDPATH/dbmind/components/sqldiag/sample_data/predict.csv --model template --model-path ./template --predicted-file ./result/t_result --config-file config_path
    ```

- 使用提供的测试数据进行模板化模型更新：

    ```
    gs_dbmind component sqldiag finetune -f DBMINDPATH/dbmind/components/sqldiag/sample_data/train.csv --model template --model-path ./template --config-file config_path
    ```

- 使用提供的测试数据进行DNN训练：

    ```
    gs_dbmind component sqldiag train -f DBMINDPATH/dbmind/components/sqldiag/sample_data/train.csv --model dnn --model-path ./dnn_model --config-file config_path
    ```

- 使用提供的测试数据进行DNN预测：

    ```
    gs_dbmind component sqldiag predict -f DBMINDPATH/dbmind/components/sqldiag/sample_data/predict.csv --model dnn --model-path ./dnn_model --predicted-file --config-file config_path
    ```

- 使用提供的测试数据进行DNN模型更新：

    ```
    gs_dbmind component sqldiag finetune -f DBMINDPATH/dbmind/components/sqldiag/sample_data/train.csv --model dnn --model-path ./dnn_model --config-file config_path
    ```

## 获取帮助

使用SQLdiag工具前，您可以通过以下指令获取帮助。

```
gs_dbmind component sqldiag --help
```

显示如下帮助信息：

```
usage:   [-h] [-f CSV_FILE] [--predicted-file PREDICTED_FILE]
               [--model {template,dnn}] [--query QUERY] [--threshold THRESHOLD] --model-file MODEL_FILE
               [--config-file CONFIG_FILE]
               {train,predict,finetune}

SQLdiag integrated by DBMind.

positional arguments:
  {train,predict,finetune}
                        The training mode is to perform feature extraction and
                        model training based on historical SQL statements. The
                        prediction mode is to predict the execution time of a
                        new SQL statement through the trained model.

optional arguments:
  -h, --help            show this help message and exit
  -f CSV_FILE, --csv-file CSV_FILE
                        The data set for training or prediction. The file
                        format is CSV. If it is two columns, the format is
                        (SQL statement, duration time). If it is three
                        columns, the format is (timestamp of SQL statement
                        execution time, SQL statement, duration time).
  --predicted-file PREDICTED_FILE
                        The file path to save the predicted result.
  --model {template,dnn}
                        Choose the model model to use.
  --query QUERY         Input the queries to predict.
  --threshold THRESHOLD
                        Slow SQL threshold.
  --model-file MODEL_FILE, --model-path MODEL_FILE
                        The storage path of the model file, used to read or
                        save the model file.
  --config-file CONFIG_FILE, --config CONFIG_FILE
```

## 命令参考

**表 1**  命令行参数说明

参数说明 取值范围 训练或预测文件位置。
--predicted-file 预测结果存储位置。
--model 模型选择。
template、dnn --model-path 训练模型存储位置。
--query SQL语句。
--threshold 慢SQL阈值。
--config-file 配置文件位置。

## 常见问题处理

- 训练场景失败：请检查历史日志文件路径是否正确，且文件格式符合上文规定。

- 预测场景失败：请检查模型路径是否正确。确保待预测负载文件格式正确。
