# Automatic Vectorization

> 来源: https://www.tencentcloud.com/document/product/409/82476

TencentDB for PostgreSQL Release Notes and Announcements Release Notes Product Announcements Product Introduction Overview Features Strengths Scenarios Regions and AZs Product Feature List Major Version Lifecycle Description MSSQL Compatible Version Billing Billing Overview Instance Type and Specification Purchase Methods Overdue Payments Refund Backup Space Billing Database Audit Billing Overview Getting Started Creating TencentDB for PostgreSQL Instance Connecting to TencentDB for PostgreSQL Instance Managing TencentDB for PostgreSQL Instance Importing Data Migrating Data with DTS Kernel Version Introduction Kernel Version Overview Kernel Version Release Notes Viewing Kernel Version Proprietary Kernel Features Database Audit Audit Service Description Enabling the Audit Service View Audit Logs Modify audit services Audit Performance Description User Guide Instance Management Upgrading Instance CPU Elastic Scaling Read-Only Instance Account Management Database Management Database Proxy Parameter Management Log Management and Analysis Backup and Restoration Extension Management Network Management Access Management Data Security Tenant and Resource Isolation Security Groups Monitoring and Alarms Tag AI Capabilities Overview of AI Capabilities for TencentDB for PostgreSQL Automatic Vectorization AI Large Model Invocation Vector and Graph Search Multi-Agent Long-Term Memory AI for DB Intelligent Ops AI Vibe Coding Supabase Practical Tutorial Branch Capabilities Cloud Disk Edition Overview of PostgreSQL Cloud Disk Edition Viewing Instance Backups Migrating to Cloud Disk Edition Use Cases Cross-Database Access Automatically Creating Partition in PostgreSQL Searching in High Numbers of Tags Based on pg_roaringbitmap Querying People Nearby with One SQL Statement Configuring TencentDB for PostgreSQL as GitLab's External Data Source Supporting Tiered Storage Based on cos_fdw Extension Implement Read/Write Separation via pgpool Implementing Slow SQL Analysis Using the Auto_explain Plugin Using pglogical for Logical Replication Using Debezium to Collect PostgreSQL Data Set Up a Remote Disaster Recovery Environment for PostgreSQL Locally on CVM Read-Only Instance and Read-Only Group Practical Tutorial How to use failover slot for logical replication How to Use SCF for Scheduled Database Operations Fix Table Bloat Migration Guide DTS-Based Logical Migration Physical migration based on DTS DTS-Based Data Sync Performance White Paper Test Methods Test Results ​​API Reference History Introduction API Category Making API Requests Instance APIs Read-Only Instance APIs Backup and Recovery APIs Parameter Management APIs Security Group APIs Performance Optimization APIs Account APIs Database APIs Specification APIs Task APIs Other APIs Database Audit APIs Network APIs Data Types Error Codes Security and Compliance Information Security Standards and Certifications FAQs Agreements Service Level Agreement Terms of Service Glossary Contact Us Documentation TencentDB for PostgreSQL AI Capabilities Automatic Vectorization Automatic Vectorization Download Focus Mode Font Size Last updated: 2026-08-25 17:49:57 AI-Translated TencentDB for PostgreSQL provides the automatic vectorization feature. This document describes the feature and how to use it.
Overview tencentdb_ai provides the automatic vectorization (Auto Embedding) feature, which allows users to automatically convert text to vectors during data writes without manually calling embedding APIs or writing additional ETL processes. You only need to register a task with one line of SQL, and all subsequent INSERT and UPDATE operations on the source table will automatically trigger vector generation, with the vector results written back to the target column in real time. This eliminates the cumbersome process of "data write → manual extraction → embedding call → write-back".
Supported Versions The database version must be PostgreSQL 14 - 18, and the tencentdb_ai extension must be version 1.5 or later, subject to the actual extversion in the instance.
Core Architecture The automatic vectorization feature is powered by three core components working together:
Component

Description

Incremental task (Incremental Task)

Automatically captures INSERT / UPDATE through triggers and generates vectors in real time.

Backfill task (Backfill Task)

Scans existing data in batches based on a primary key cursor and backfills historical vectors in one pass.

Background worker (Bgworker)

Runs as a resident background process, asynchronously consumes message queues, invokes the embedding model, and writes back results.
Use Cases RAG knowledge base: Documents are automatically vectorized after being chunked and stored, and the knowledge base works with tencentdb_ai.retrieve() / rag() to implement intelligent Q&A.
Product search: Automatically updates the vector index when product descriptions or titles change, enabling semantic search.
User profiling: User behavior text is vectorized in real time, supporting similar user recommendation.
Content moderation: Content is automatically vectorized after being stored, and deduplication/moderation is implemented through similarity search.
Prerequisites The database version must be PostgreSQL 14-18, and the tencentdb_ai extension must be version 1.5 or later, subject to the actual extversion in the instance.
pgvector extension (automatically installed through tencentdb_ai CASCADE).
pgmq extension (automatically installed through tencentdb_ai CASCADE).
An embedding model (such as kinfra-text-embedding-0.6b) has been configured, and embedding_dim has been set in model_list. For configuration details, see tencentdb_ai plugin feature introduction.
Add tencentdb_ai to the shared_preload_libraries parameter to enable background workers. The modification takes effect only after the instance is restarted.
Configure tencentdb_ai.autoembedding_database to specify the working database. The modification takes effect only after the instance is restarted.
Parameter The following GUC parameters can be configured in postgresql.conf. They are all at the SIGHUP level and take effect after pg_reload_conf() is called.
Parameter

Type

Default Value

Description

tencentdb_ai.autoembedding_worker

bool

on

Whether to enable the background automatic vectorization worker process

tencentdb_ai.autoembedding_database

string

postgres

Target database to which the worker process connects

tencentdb_ai.autoembedding_batch_size

int

32

Maximum number of messages processed per round (1-10000)

tencentdb_ai.autoembedding_max_retry

int

5

Maximum number of retries for a single message (0-1000)

tencentdb_ai.autoembedding_retry_base_ms

int

1000

Base interval for retry backoff (milliseconds, 1-600000)

tencentdb_ai.autoembedding_max_input_bytes

int

65536

Maximum input bytes for a single embedding call (1-1048576)

tencentdb_ai.autoembedding_naptime_ms

int

1000

Idle sleep interval of the worker process (milliseconds, 10-600000) Function Details I. add_incr_autoembedding_task() - Creating an Incremental Vectorization Task After an incremental task is created, the system automatically adds a vector embedding column to the target table and creates INSERT AFTER and UPDATE BEFORE triggers. Whenever data in the source column changes, the triggers automatically enqueue the changes, and background workers process them asynchronously.
Function Signature tencentdb_ai.add_incr_autoembedding_task( schema_name    NAME,        -- schema where the table resides table_name     NAME,        -- table name source_columns NAME[],      -- array of source text column names model_name     NAME,        -- embedding model name target_column  NAME  DEFAULT NULL,   -- target vector column name index_method   TEXT  DEFAULT 'hnsw', -- vector index method options        JSONB DEFAULT '{}'    -- extension options ) RETURNS BIGINT Parameter Description Parameter

Type

Description

schema_name

NAME

Name of the schema where the table resides

table_name

NAME

Table name (must have a single-column primary key)

source_columns

NAME[]

Array of text columns to be vectorized

model_name

NAME

Embedding model name, such as 'kinfra-text-embedding-0.6b'

target_column

NAME

Target vector column name, defaulting to {source_columns[1]}_embedding

index_method

TEXT

Vector index method, supporting 'none', 'hnsw', and 'ivfflat', with 'hnsw' as the default (the current version only records this configuration and does not automatically create indexes)

options

JSONB

Extension options, supporting vector_dim to override the default dimension Prerequisites The caller must be the table owner or have the pg_tencentdb_superuser role.
The table must have a single-column primary key.
The source column must exist. Values from non-text columns are converted to text before vectorization.
The model must already be registered in tencentdb_ai.model_list.
Must be executed in the configured autoembedding_database.
Behavior Description Vectors are asynchronously generated by background workers<1> (polling every second by default). For newly inserted or updated rows, the vector column is briefly NULL and then automatically written back.
When the source column is updated, the vector column is first cleared and then rebuilt asynchronously (controlled by the clear_embedding_on_update option, which is enabled by default).
When multiple source columns are configured, the values of each column are concatenated into a single input text in array order, using newline characters as separators. NULL values are treated as empty strings.
While a task exists, the target table and source/target columns are protected. DROP TABLE or DROP COLUMN operations are blocked and return an error. You must delete the task first.
Use Case -- Single-column embedding: Creates an embedding for the content column, with the target column automatically named content_embedding.
SELECT tencentdb_ai.add_incr_autoembedding_task( 'public', 'articles', ARRAY['content'], 'kinfra-text-embedding-0.6b' );
﻿

-- Multi-column embedding: Merges title + body to generate embeddings, with the target column and index method explicitly specified.
SELECT tencentdb_ai.add_incr_autoembedding_task( 'public', 'articles', ARRAY['title', 'body'], 'kinfra-text-embedding-0.6b', target_column => 'doc_embedding', index_method => 'hnsw' );
﻿

-- Override the vector dimension (when embedding_dim is not set in model_list).
SELECT tencentdb_ai.add_incr_autoembedding_task( 'public', 'articles', ARRAY['content'], 'kinfra-text-embedding-0.6b', options => '{"vector_dim": 1024}' );
II. add_backfill_autoembedding_task() - Creating a Backfill Vectorization Task Backfill tasks are used to batch-vectorize and backfill existing historical data. They do not create new columns or triggers. Instead, they scan existing data in batches based on a primary key cursor and enqueue the changes. Typically, you create an incremental task first to automatically create the vector column, and then create a backfill task to backfill historical data.
Function Signature tencentdb_ai.add_backfill_autoembedding_task( schema_name    NAME,        -- schema where the table resides table_name     NAME,        -- table name source_columns NAME[],      -- array of source text column names model_name     NAME,        -- embedding model name target_column  NAME  DEFAULT NULL,   -- target vector column name start_now      BOOL  DEFAULT false,  -- whether to start backfill immediately options        JSONB DEFAULT '{}'    -- extension options ) RETURNS BIGINT Parameter Description Parameter

Type

Description

schema_name

NAME

Name of the schema where the table resides

table_name

NAME

Table Name

source_columns

NAME[]

Array of text columns to be vectorized

model_name

NAME

Embedding model name

target_column

NAME

Target vector column name, defaulting to {source_columns[1]}_embedding

start_now

BOOL

Whether to start backfill immediately. Defaults to false. If false, the task remains in the not_started state and must be started by calling run_backfill_autoembedding_task().

options

JSONB

Extension options, must be consistent with the incremental task configuration.
Prerequisites The target vector column must already exist. It is typically created by add_incr_autoembedding_task first.
If an incremental task already exists on the same column, the configuration (source_columns, model_name, vector_dim) must be consistent.
Must be executed in the configured autoembedding_database.
Use Case -- First create an incremental task (automatically creates the vector column + triggers) SELECT tencentdb_ai.add_incr_autoembedding_task( 'public', 'articles', ARRAY['content'], 'kinfra-text-embedding-0.6b' );
﻿

-- Then create a backfill task to immediately backfill historical data.
SELECT tencentdb_ai.add_backfill_autoembedding_task( 'public', 'articles', ARRAY['content'], 'kinfra-text-embedding-0.6b', start_now => true );
﻿

-- Alternatively, you can register the task first (with start_now defaulting to false) and trigger it manually later.
SELECT tencentdb_ai.add_backfill_autoembedding_task( 'public', 'articles', ARRAY['content'], 'kinfra-text-embedding-0.6b' );
﻿

-- Start manually later.
SELECT tencentdb_ai.run_backfill_autoembedding_task(1);
III. drop_incr_autoembedding_task() / drop_backfill_autoembedding_task() - Deleting Tasks Deleting a task only cleans up metadata, triggers, and pending messages in the queue. It does not delete generated vector columns, indexes, or data.
Function Signature tencentdb_ai.drop_incr_autoembedding_task(task_id BIGINT) RETURNS VOID tencentdb_ai.drop_backfill_autoembedding_task(task_id BIGINT) RETURNS VOID Use Case -- Delete the incremental task.
SELECT tencentdb_ai.drop_incr_autoembedding_task(1);
﻿

-- Delete the backfill task.
SELECT tencentdb_ai.drop_backfill_autoembedding_task(2);
IV. run_backfill_autoembedding_task() - Manually Triggering Backfill You can use this function to manually trigger backfill tasks created with start_now => false, or to restart failed tasks.
Function Signature tencentdb_ai.run_backfill_autoembedding_task( task_id    BIGINT,           -- Backfill task ID batch_size INT DEFAULT 8192  -- Maximum number of rows a background worker scans and enqueues per round.
) RETURNS VOID This function only sets the task to the running state and resets the scan cursor, then returns immediately without a return value. The actual scanning and enqueueing is automatically advanced by background workers on a periodic basis. It raises an error when the task is already done, and resets and restarts the task when it has failed.
Use Case -- Manually start the backfill.
SELECT tencentdb_ai.run_backfill_autoembedding_task(1);
V. autoembedding_status - Task Status View A system view that displays the status of all automatic vectorization tasks in real time.
View Column Description Column Name

Type

Description

task_kind

TEXT

Task type: incr (incremental) or backfill (stock)

task_id

BIGINT

Task ID

schema_name

NAME

schema of the table

table_name

NAME

Table Name

source_columns

NAME[]

Source text column

target_column

NAME

Target vector column

model_name

NAME

Embedding model

status

ENUM

Incremental task status: enabled disabled error

backfill_state

ENUM

Backfill task status: not_started running done / failed

backfilled_rows

BIGINT

Backfilled row quantity for the backfill task

pending

BIGINT

Number of pending messages in the queue

failed_count

BIGINT

Number of errors recorded in the error table

last_error

TEXT

Last error message Use Case -- View the status of all tasks.
SELECT task_kind, task_id, schema_name, table_name, target_column, status, backfill_state, pending, backfilled_rows, failed_count FROM tencentdb_ai.autoembedding_status ORDER BY task_id;
VI. autoembedding_error - Error Record Table The system automatically records detailed failure information to facilitate troubleshooting.
Table Column Description Column Name

Type

Description

error_id

BIGSERIAL

Error record ID

msg_id

BIGINT

Message ID

task_kind

TEXT

Task type: incr or backfill

task_id

BIGINT

Associated Task ID

row_id

JSONB

Primary key value of the data row

error_code

TEXT

Error Code

error_message

TEXT

Error Message

detail

TEXT

Detailed error information

created_at

TIMESTAMPTZ

Error occurrence time Use Case -- View recent errors.
SELECT task_kind, task_id, row_id, error_message, created_at FROM tencentdb_ai.autoembedding_error ORDER BY created_at DESC LIMIT 10;
Complete Usage Example The following provides a complete end-to-end example that covers extension installation, model registration, incremental task creation, backfill, and data verification:
Step 1: Environment Preparation -- Install extensions. pgmq / pgvector are installed automatically through CASCADE.
CREATE EXTENSION IF NOT EXISTS tencentdb_ai CASCADE;
﻿

-- Register an embedding model. The json_path parameter must be NULL.
SELECT tencentdb_ai.add_model('kinfra-text-embedding-0.6b', NULL, NULL, NULL, 'tokenhub');
SELECT tencentdb_ai.update_model_attr('kinfra-text-embedding-0.6b', 'api_key', 'your_api_key');
﻿

-- Set the embedding dimension. This parameter is required. If it is not set, specify it through options.vector_dim when creating a task.
UPDATE tencentdb_ai.model_list SET embedding_dim = 1024 WHERE model_name = 'kinfra-text-embedding-0.6b';
Note:
Obtain the api_key from the TokenHub console.
Step 2: Creating the Source Table and Writing Data -- Create a knowledge base table.
CREATE TABLE kb_articles ( id      bigserial PRIMARY KEY,
title   text,
content text );
﻿

-- Insert test data.
INSERT INTO kb_articles (title, content) VALUES ('Introduction to PostgreSQL', 'PostgreSQL is a powerful open-source object-relational database system...'), ('Tencent Cloud VectorDB', 'Tencent Cloud VectorDB is a database system specifically designed for storing and searching high-dimensional vectors...'), ('RAG', 'Retrieval-Augmented Generation (RAG) is an AI technology that combines search and generation capabilities...'), Step 3: Creating an Auto Embedding Task -- Create an incremental task: automatically add the content_embedding column and create a trigger.
SELECT tencentdb_ai.add_incr_autoembedding_task( 'public', 'kb_articles', ARRAY['content'], 'kinfra-text-embedding-0.6b' ) AS incr_task_id;
﻿

-- Create a backfill task: immediately backfill the existing 3 rows of historical data.
SELECT tencentdb_ai.add_backfill_autoembedding_task( 'public', 'kb_articles', ARRAY['content'], 'kinfra-text-embedding-0.6b', start_now => true ) AS backfill_task_id;
Step 4: Verifying Embedding Generation -- Wait for the background process to complete. By default, a poll is performed every second.
SELECT pg_sleep(3);
﻿

-- Check the backfill progress.
SELECT backfill_state, backfilled_rows FROM tencentdb_ai.autoembedding_status WHERE task_kind = 'backfill';
backfill_state | backfilled_rows
----------------+-----------------
done           |               3 (1 row) -- Verify that the vector has been generated.
SELECT id, title, content_embedding IS NOT NULL AS has_embedding, vector_dims(content_embedding) AS dims FROM kb_articles ORDER BY id;
id |      title      | has_embedding | dims
----+-----------------+---------------+------
1 | Introduction to PostgreSQL | t             | 1024 2 | Tencent Cloud VectorDB      | t             | 1024 3 | RAG        | t             | 1024 (3 rows) -- View task status.
SELECT * FROM tencentdb_ai.autoembedding_status;
Step 5: Verifying Incremental Writes -- Insert new data. The trigger automatically enqueues it.
INSERT INTO kb_articles (title, content) VALUES ('Embedding model', 'An embedding model is a machine learning model that converts text into vector representations...');
﻿

-- Wait for the background process to complete.
SELECT pg_sleep(2);
﻿

-- Verify that the vector for the new data has been generated.
SELECT id, title, content_embedding IS NOT NULL AS has_embedding FROM kb_articles ORDER BY id;
id |      title      | has_embedding
----+-----------------+---------------
1 | Introduction to PostgreSQL | t 2 | Tencent Cloud VectorDB      | t 3 | RAG        | t 4 | Embedding model        | t (4 rows) Task Lifecycle Management Incremental Task Status Status

Description

enabled

The task is registered, and written data is automatically enqueued.

error

Task-level exception. Check the last_error field to troubleshoot.
Note:
To stop incremental vectorization, delete the task. drop_incr_autoembedding_task also deletes the trigger and pending messages in the queue. Re-register it when needed.
The task metadata table is read-only (SELECT). Do not modify it directly.
Existing Task Status Status

Description

Operation

not_started

Created but not started

Call run_backfill_autoembedding_task().

running

Backfilling in progress

The background process advances automatically.

done

Backfill completed

All historical data has been processed.

failed

Backfill failed

Check last_error. You can call run_backfill_autoembedding_task() to retry.
Error Handling and Troubleshooting Common Error Scenarios Error Scenario

Error Message

Solution

Unconfigured database

can only use tencentdb_ai autoembedding in database

Check the tencentdb_ai.autoembedding_database configuration.

Missing primary key

The table does not have a single-column primary key.

Add a single-column primary key to the table.

Source column does not exist.

source column X does not exist

Confirm that the source column name is correct and has not been deleted.

Model not registered.

model X not found

First register the model through add_model.

Missing vector dimension

embedding_dim is not set.

Set model_list.embedding_dim or specify it through options.vector_dim.

Vector column does not exist.

target column X does not exist

First run add_incr_autoembedding_task to create the column.

Configuration conflict

config conflicts with existing task

Ensure that incremental and existing task configurations for the same column are consistent.

Dimension write-back mismatch

The vector dimension returned by the embedding model is inconsistent with the task vector_dim. Messages are archived and recorded to autoembedding_error.

Check whether the model_list.embedding_dim or options.vector_dim configuration matches the actual model dimension.

Insufficient returned vectors

No error is reported. The number of pending tasks does not decrease for a long time, and no data is written back.

When the number of vectors returned by the embedding model in a single call is fewer than the number of input rows, back off and retry the entire batch of messages. After confirming that the model service status is normal, wait for recovery.

Worker process not running.

When a task is created, the error "autoembedding worker was never registered" is reported; or the number of pending tasks does not decrease for a long time, and no data is written back.

Verify the shared_preload_libraries and autoembedding_database configurations in the prerequisites, modify them, and then restart the instance for the changes to take effect.
Monitoring Task Status -- Check the queue backlog.
SELECT task_kind, task_id, pending FROM tencentdb_ai.autoembedding_status WHERE pending > 0;
﻿

-- View error details.
SELECT * FROM tencentdb_ai.autoembedding_error ORDER BY created_at DESC LIMIT 20;
Use Cases
1.
Incremental first, then backfill: Create an incremental task first to automatically create the vector column, and then create a backfill task to backfill historical data, ensuring that newly written data is not missed.
2.
Set batch_size appropriately: Adjust autoembedding_batch_size based on the QPS limit of the embedding model and the maximum number of input tokens per request.
3.
Configure embedding_dim: Set embedding_dim in model_list to avoid specifying it manually each time you create a task.
4.
Monitor the error table: Regularly check the autoembedding_error table to detect and handle failed embedding requests in a timely manner.
5.
Control the backfill rate: For backfilling large tables, you can reduce batch_size or increase naptime_ms to control the rate and avoid impacting online workloads.
6.
Verify before deleting a task: drop_*_autoembedding_task does not delete the vector column or data. To fully clean up, manually DROP COLUMN.
7.
Large-scale data import: Large transaction batch writes enqueue data row by row and trigger model calls. Complete the data import first, and then create an incremental task with a backfill task to backfill historical data, avoiding a large queue backlog during the import process.
Previous Topic: Overview of AI Capabilities for TencentDB for PostgreSQL Next Topic: Introduction to the tencentdb_ai Plugin Features Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Overview Supported Versions Core Architecture Use Cases Prerequisites Parameter Function Details I. add_incr_autoembedding_task() - Creating an Incremental Vectorization Task II. add_backfill_autoembedding_task() - Creating a Backfill Vectorization Task III. drop_incr_autoembedding_task() / drop_backfill_autoembedding_task() - Deleting Tasks IV. run_backfill_autoembedding_task() - Manually Triggering Backfill V. autoembedding_status - Task Status View VI. autoembedding_error - Error Record Table Complete Usage Example Step 1: Environment Preparation Step 2: Creating the Source Table and Writing Data Step 3: Creating an Auto Embedding Task Step 4: Verifying Embedding Generation Step 5: Verifying Incremental Writes Task Lifecycle Management Incremental Task Status Existing Task Status Error Handling and Troubleshooting Common Error Scenarios Monitoring Task Status Use Cases Search AllCurrent Product Search titles only Enter keywords to search documentation
