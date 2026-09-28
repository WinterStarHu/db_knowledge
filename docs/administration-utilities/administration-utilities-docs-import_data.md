# 导入数据

- **[通过INSERT语句直接写入数据](running_the_insert_statement_to_insert_data.md)**

- **[使用COPY FROM STDIN导入数据](running_the_copy_from_stdin_statement_to_import_data.md)**

- **[使用gsql元命令导入数据](using_a_gsql_meta_command_to_import_data.md)**

- **[使用gs_restore命令导入数据](using_gs_restore_to_import_data.md)**

- **[更新表中数据](updating_a_table_by_using_dml_statements.md)**

- **[深层复制](deep_copy.md)**

- **[分析表](analysis_table.md)**

- **[对表执行VACUUM](doing_vacuum_to_a_table.md)**

- **[管理并发写入操作](transaction_isolation_description.md)**

openGauss数据库提供了灵活的数据入库方式：INSERT、COPY以及gsql元命令\\copy。各方式具有不同的特点，具体请参见[表1](#zh-cn_topic_0237121116_table59418455192145)。

**表 1**  导入方式特点说明

INSERT 通过INSERT语句插入一行或多行数据，及从指定表插入数据。
COPY 通过COPY FROM STDIN语句直接向openGauss数据库写入数据。
通过JDBC驱动的CopyManager接口从其他数据库向openGauss数据库写入数据时，具有业务数据无需落地成文件的优势。
gsql工具的元命令\copy 与直接使用SQL语句COPY不同，该命令读取/写入的文件只能是gsql客户端所在机器上的本地文件。
