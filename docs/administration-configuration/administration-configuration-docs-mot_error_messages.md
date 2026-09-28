# MOT错误消息

错误可能由多种场景引起。所有错误都记录在数据库服务器日志文件中。此外，与用户相关的错误作为对查询、事务或存储过程执行或数据库管理操作的响应的一部分返回给用户。

- 服务器日志中报告的错误包括函数、实体、上下文、错误消息、错误描述和严重性。
- 向用户报告的错误被翻译成标准PostgreSQL错误码，可能由MOT特定的消息和描述组成。

错误提示、错误描述和错误码见下文。该错误码实际上是内部代码，不记录也不返回给用户。

## 写入日志文件的错误

所有错误都记录在数据库服务器日志文件中。以下列出了写入数据库服务器日志文件但未返回给用户的错误。该日志位于data文件夹中，命名为postgresql-DATE-TIME.log。

**表 1**  只写入日志文件的错误

日志消息 内部错误代码 Error code denoting success MOT_NO_ERROR 0 Out of memory MOT_ERROR_OOM 1 Invalid configuration MOT_ERROR_INVALID_CFG 2 Invalid argument passed to function MOT_ERROR_INVALID_ARG 3 System call failed MOT_ERROR_SYSTEM_FAILURE 4 Resource limit reached MOT_ERROR_RESOURCE_LIMIT 5 Internal logic error MOT_ERROR_INTERNAL 6 Resource unavailable MOT_ERROR_RESOURCE_UNAVAILABLE 7 Unique violation MOT_ERROR_UNIQUE_VIOLATION 8 Invalid memory allocation size MOT_ERROR_INVALID_MEMORY_SIZE 9 Index out of range MOT_ERROR_INDEX_OUT_OF_RANGE 10 Error code unknown MOT_ERROR_INVALID_STATE 11

## 返回给用户的错误

下面列出了写入数据库服务器日志文件并返回给用户的错误。

MOT使用返回码（Return Code，RC）返回Postgres标准错误代码至封装。某些RC会导致向正在与数据库交互的用户生成错误消息。

MOT从内部返回Postgres代码（见下文）到数据库包，数据库封装根据标准的Postgres行为对其做出反应。

>[!NOTE]说明
>提示信息中的%s、%u、%lu指代相应的错误信息（如查询、表名或其他信息）。
>
>- %s：字符串
>
>- %u：数字
>
>- %lu：数字

**表 2**  返回给用户并记录到日志文件的错误

返回给用户的短/长描述 Postgres代码 内部错误码 Success.
Denotes success ERRCODE_SUCCESSFUL_ COMPLETION RC_OK = 0 Failure Unknown error has occurred.
ERRCODE_FDW_ERROR RC_ERROR = 1 Unknown error has occurred.
Denotes aborted operation.
ERRCODE_FDW_ERROR RC_ABORT Column definition of %s is not supported.
Column type %s is not supported yet.
ERRCODE_INVALID_COLUMN_DEFINITION RC_UNSUPPORTED_COL_TYPE Column definition of %s is not supported.
Column type Array of %s is not supported yet.
ERRCODE_INVALID_COLUMN_DEFINITION RC_UNSUPPORTED_COL_TYPE_ARR Column size %d exceeds max tuple size %u.
Column definition of %s is not supported.
ERRCODE_FEATURE_NOT_SUPPORTED RC_EXCEEDS_MAX_ROW_SIZE Column name %s exceeds max name size %u.
Column definition of %s is not supported.
ERRCODE_INVALID_COLUMN_DEFINITION RC_COL_NAME_EXCEEDS_MAX_SIZE Column size %d exceeds max size %u.
Column definition of %s is not supported.
ERRCODE_INVALID_COLUMN_DEFINITION RC_COL_SIZE_INVLALID Cannot create table.
Cannot add column %s; as the number of declared columns exceeds the maximum declared columns.
ERRCODE_FEATURE_NOT_ SUPPORTED RC_TABLE_EXCEEDS_MAX_ DECLARED_COLS Cannot create index.
Total column size is greater than maximum index size %u.
ERRCODE_FDW_KEY_SIZE_ EXCEEDS_MAX_ALLOWED RC_INDEX_EXCEEDS_MAX_SIZE Cannot create index.
Total number of indexes for table %s is greater than the maximum number of indexes allowed %u.
ERRCODE_FDW_TOO_MANY_ INDEXES RC_TABLE_EXCEEDS_MAX_INDEXES Cannot execute statement.
Maximum number of DDLs per transaction reached the maximum %u.
ERRCODE_FDW_TOO_MANY_ DDL_CHANGES_IN_ TRANSACTION_NOT_ ALLOWED RC_TXN_EXCEEDS_MAX_DDLS Unique constraint violation Duplicate key value violates unique constraint \"%s\"".
Key %s already exists.
ERRCODE_UNIQUE_ VIOLATION RC_UNIQUE_VIOLATION Table \"%s\" does not exist.
ERRCODE_UNDEFINED_TABLE RC_TABLE_NOT_FOUND Index \"%s\" does not exist.
ERRCODE_UNDEFINED_TABLE RC_INDEX_NOT_FOUND Unknown error has occurred.
ERRCODE_FDW_ERROR RC_LOCAL_ROW_FOUND Unknown error has occurred.
ERRCODE_FDW_ERROR RC_LOCAL_ROW_NOT_FOUND Unknown error has occurred.
ERRCODE_FDW_ERROR RC_LOCAL_ROW_DELETED Unknown error has occurred.
ERRCODE_FDW_ERROR RC_INSERT_ON_EXIST Unknown error has occurred.
ERRCODE_FDW_ERROR RC_INDEX_RETRY_INSERT Unknown error has occurred.
ERRCODE_FDW_ERROR RC_INDEX_DELETE Unknown error has occurred.
ERRCODE_FDW_ERROR RC_LOCAL_ROW_NOT_VISIBLE Memory is temporarily unavailable.
ERRCODE_OUT_OF_LOGICAL_MEMORY RC_MEMORY_ALLOCATION_ERROR Unknown error has occurred.
ERRCODE_FDW_ERROR RC_ILLEGAL_ROW_STATE Null constraint violated.
NULL value cannot be inserted into non-null column %s at table %s.
ERRCODE_FDW_ERROR RC_NULL_VIOLATION Critical error.
Critical error: %s.
ERRCODE_FDW_ERROR RC_PANIC A checkpoint is in progress – cannot truncate table.
ERRCODE_FDW_OPERATION_NOT_SUPPORTED RC_NA Unknown error has occurred.
ERRCODE_FDW_ERROR RC_MAX_VALUE &lt;recovery message&gt;
ERRCODE_CONFIG_FILE_ERROR &lt;recovery message&gt;
ERRCODE_INVALID_TABLE_ DEFINITION Memory engine – Failed to perform commit prepared.
ERRCODE_INVALID_TRANSACTION_ STATE Invalid option &lt;option name&gt;
ERRCODE_FDW_INVALID_OPTION_ NAME Invalid memory allocation request size.
ERRCODE_INVALID_PARAMETER_ VALUE Memory is temporarily unavailable.
ERRCODE_OUT_OF_LOGICAL_ MEMORY Could not serialize access due to concurrent update.
ERRCODE_T_R_SERIALIZATION_ FAILURE Alter table operation is not supported for memory table.
Cannot create MOT tables while incremental checkpoint is enabled.
Re-index is not supported for memory tables.
ERRCODE_FDW_OPERATION_NOT_ SUPPORTED Allocation of table metadata failed.
ERRCODE_OUT_OF_MEMORY Database with OID %u does not exist.
ERRCODE_UNDEFINED_DATABASE Value exceeds maximum precision: %d.
ERRCODE_NUMERIC_VALUE_OUT_ OF_RANGE You have reached a maximum logical capacity %lu of allowed %lu.
ERRCODE_OUT_OF_LOGICAL_ MEMORY
