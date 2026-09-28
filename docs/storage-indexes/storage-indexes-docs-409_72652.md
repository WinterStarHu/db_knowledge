# Introduction to the tencentdb_ai Plugin Features

> 来源: https://www.tencentcloud.com/document/product/409/72652

TencentDB for PostgreSQL Release Notes and Announcements Release Notes Product Announcements Product Introduction Overview Features Strengths Scenarios Regions and AZs Product Feature List Major Version Lifecycle Description MSSQL Compatible Version Billing Billing Overview Instance Type and Specification Purchase Methods Overdue Payments Refund Backup Space Billing Database Audit Billing Overview Getting Started Creating TencentDB for PostgreSQL Instance Connecting to TencentDB for PostgreSQL Instance Managing TencentDB for PostgreSQL Instance Importing Data Migrating Data with DTS Kernel Version Introduction Kernel Version Overview Kernel Version Release Notes Viewing Kernel Version Proprietary Kernel Features Database Audit Audit Service Description Enabling the Audit Service View Audit Logs Modify audit services Audit Performance Description User Guide Instance Management Upgrading Instance CPU Elastic Scaling Read-Only Instance Account Management Database Management Database Proxy Parameter Management Log Management and Analysis Backup and Restoration Extension Management Network Management Access Management Data Security Tenant and Resource Isolation Security Groups Monitoring and Alarms Tag AI Capabilities Overview of AI Capabilities for TencentDB for PostgreSQL Automatic Vectorization AI Large Model Invocation Introduction to the tencentdb_ai Plugin Features Building Applications by Calling Large Models Using tencentdb_ai tencentdb_ai RAG tencentdb_ai Model Backend Migration Guide Vector and Graph Search Multi-Agent Long-Term Memory AI for DB Intelligent Ops AI Vibe Coding Supabase Practical Tutorial Branch Capabilities Cloud Disk Edition Overview of PostgreSQL Cloud Disk Edition Viewing Instance Backups Migrating to Cloud Disk Edition Use Cases Cross-Database Access Automatically Creating Partition in PostgreSQL Searching in High Numbers of Tags Based on pg_roaringbitmap Querying People Nearby with One SQL Statement Configuring TencentDB for PostgreSQL as GitLab's External Data Source Supporting Tiered Storage Based on cos_fdw Extension Implement Read/Write Separation via pgpool Implementing Slow SQL Analysis Using the Auto_explain Plugin Using pglogical for Logical Replication Using Debezium to Collect PostgreSQL Data Set Up a Remote Disaster Recovery Environment for PostgreSQL Locally on CVM Read-Only Instance and Read-Only Group Practical Tutorial How to use failover slot for logical replication How to Use SCF for Scheduled Database Operations Fix Table Bloat Migration Guide DTS-Based Logical Migration Physical migration based on DTS DTS-Based Data Sync Performance White Paper Test Methods Test Results ​​API Reference History Introduction API Category Making API Requests Instance APIs Read-Only Instance APIs Backup and Recovery APIs Parameter Management APIs Security Group APIs Performance Optimization APIs Account APIs Database APIs Specification APIs Task APIs Other APIs Database Audit APIs Network APIs Data Types Error Codes Security and Compliance Information Security Standards and Certifications FAQs Agreements Service Level Agreement Terms of Service Glossary Contact Us Documentation TencentDB for PostgreSQL AI Capabilities AI Large Model Invocation Introduction to the tencentdb_ai Plugin Features Introduction to the tencentdb_ai Plugin Features Download Focus Mode Font Size Last updated: 2026-08-25 17:49:56 AI-Translated Currently, both foundational large models and AI application development are advancing rapidly. TencentDB for PostgreSQL provides the tencentdb_ai plugin, which enables you to easily call accessible large model APIs within TencentDB for PostgreSQL instances to complete application development for various scenarios. This plugin supports instances with the major version PostgreSQL 17.
Note:
The prerequisite for using tencentdb_ai is that you have already created an instance with the major version PostgreSQL 17.
Creating the tencentdb_ai plugin will also create the pgcrypto plugin. Please be aware of this.
tencentdb_ai Plugin Function Description Add a model The add_model  function is defined as follows:
tencentdb_ai.add_model( model_name NAME, version TEXT, region TEXT, json_path JSONPATH );
The parameters are explained as follows:
model_name: the model name, such as hunyuan-lite, deepseek-r1, and so on version: the public parameter version for this model. If the model does not require the version parameter, you can leave it blank.
region: the public parameter region for this model. If the model does not require the region parameter, you can leave it blank.
json_path: specifies how to extract the model's JSON response when the model is called. This is equivalent to applying the jsonb_path_query_first function to the model output. If this parameter is not specified, the model's raw response is output as-is by default.
Viewing Registered Models The list_models function is defined as follows:
tencentdb_ai.list_models(void);
Updating a Model The update_model_attr function is defined as follows:
tencentdb_ai.update_model_attr( model_name NAME, attr_name text, attr_value text );
The parameters are explained as follows:
model_name: the model name.
attr_name: the model attribute to be updated. Updatable model attributes include version, region, json_path, SecretId, and SecretKey.
attr_value: the value of the attribute to be updated.
For specific SecretId and SecretKey, refer to CAM.
Delete a model The delete_model function is defined as follows:
tencentdb_ai.delete_model( model_name NAME );
The parameters are explained as follows:
model_name: the model name.
Model Invocation The call_model function is defined as follows:
tencentdb_ai.call_model( model_name NAME, common_params TEXT[], api_params TEXT[] );
The parameters are explained as follows:
model_name: the model name.
common_params: the public parameters required to invoke the model, for example, ARRAY['Action: ChatCompletions', 'Version: 2023-09-01'] api_params: the proprietary parameters required to invoke the model, for example, ARRAY['"Stream": false', '"Model": "hunyuan-lite"', '"Messages": [{"Role": "user", "Content": "Hello"}]'] In addition to using the call_model function to invoke models, you can also use the following APIs for model invocation in specific scenarios.
Fixed-Scene APIs Dialogue The chat_completions function is defined as follows:
tencentdb_ai.chat_completions( model_name  NAME, content TEXT, args TEXT[] default NULL );
The parameters are explained as follows:
model_name: the model name.
content: the conversation content.
args: other parameters for model invocation, with a default value of NULL.
Invocation example:
SELECT tencentdb_ai.chat_completions('hunyuan-lite', 'Hello');

chat_completions

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------
{"Response":{"RequestId":"*******-****-****-****-***********","Note":"The above content is AI-generated and does not represent the developer's position. Please do not delete or modify this marker.","Choices":[{"Index":0,"Message":{"Role":"assistant","Co ntent":"Hello there! I'm very happy to chat with you. Is there anything you'd like to share with me today?"},"FinishReason":"stop"}],"Created":1739786393,"Id":"*******-****-****-****-*********","Usage":{"PromptTokens":3,"Completio nTokens":17,"TotalTokens":20}}} (1 row) Text to Vector The get_embedding function is defined as follows:
tencentdb_ai.get_embedding( model_name NAME, content TEXT[] );
The parameters are explained as follows:
model_name: the model name.
content: the content to be transformed.
Invocation example:
damoxing1=> SELECT tencentdb_ai.get_embedding('hunyuan-embedding', ARRAY['Hello', 'PostgreSQL']);
Text Ranking The run_rerank function is defined as follows:
tencentdb_ai.run_rerank( model_name NAME, query TEXT, documents TEXT[], args TEXT[] DEFAULT NULL );
The parameters are explained as follows:
model_name: the model name.
query: the text sorting problem.
documents: the content to be sorted by text.
args: the specified parameters for a specific model.
damoxing1=> SELECT COUNT(*) FROM tencentdb_ai.run_rerank('lke-reranker-base', 'Knowledge Engine Large Model', ARRAY['Hunyuan Large Model', 'Tencent Knowledge Engine']);
count
-------
2 (1 row) Image to Text The image_to_text function is defined as follows:
tencentdb_ai.image_to_text ( model_name NAME, query TEXT, image TEXT, args TEXT[] DEFAULT NULL );
The parameters are explained as follows:
model_name: the model name.
query: the image-to-text problem.
image: the image URL.
args: the specified parameters for a specific model.
Plugin Usage Examples The process of using the extension is described in detail below:
1.
Creating Extension damoxing=> CREATE EXTENSION tencentdb_ai CASCADE;
NOTICE:  installing required extension "pgcrypto" CREATE EXTENSION Check that the extension has been created.
damoxing=> SELECT * FROM pg_extension;
oid  |   extname    | extowner | extnamespace | extrelocatable | extversion | extconfig | extcondition
-------+--------------+----------+--------------+----------------+------------+-----------+--------------
14275 | plpgsql      |       10 |           11 | f              | 1.0        |           | 16440 | pgcrypto     |    16437 |         2200 | t              | 1.3        |           | 16477 | tencentdb_ai |    16437 |         2200 | t              | 1.0        | {16479}   | {""} (3 rows)
2.
Add a large model.
damoxing=> SELECT tencentdb_ai.add_model('hunyuan-lite','2023-09-01', NULL, NULL);
add_model
-----------

(1 row)
3.
Add the SecretId and SecretKey for large model API calls.
For specific SecretId and SecretKey, refer to CAM.
damoxing=> SELECT tencentdb_ai.update_model_attr('hunyuan-lite', 'SecretId', 'AKID***************');
update_model_attr
-------------------

(1 row) damoxing=> SELECT tencentdb_ai.update_model_attr('hunyuan-lite', 'SecretKey', '********************');
update_model_attr
-------------------

(1 row)
4.
View the list of currently added models.
damoxing=> SELECT * FROM tencentdb_ai.list_models();
-[ RECORD 1 ]-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- model_name | hunyuan-lite json_path  | secretid   | *************************** secretkey  | *************************** version    | region     | id_random  | 516234453022 key_random | 134577899689
5.
Call the large model.
For chat scenarios, you can use the call_model API.
damoxing=> SELECT tencentdb_ai.call_model('hunyuan-lite', ARRAY['Action: ChatCompletions', 'Version: 2023-09-01'], ARRAY['"Stream": false', '"Model": "hunyuan-lite"', '"Messages": [{"Role": "user", "Content": "Hello"}]']);damoxing(> damoxing(>

call_model

--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------
{"Response":{"RequestId":"*******-****-****-****-***********","Note":"The above content is AI-generated and does not represent the developer's position. Please do not delete or modify this marker.","Ch oices":[{"Index":0,"Message":{"Role":"assistant","Content":"Hello! I'm very happy to communicate with you. Is there anything I can help you with? Whether it's about life, work, or study, or any other questions, I will do my best to help you."},"FinishReason":"stop"}],"Created":1739793838,"Id":"*******-****-****-****-*********** ","Usage":{"PromptTokens":3,"CompletionTokens":33,"TotalTokens":36}}} (1 row) ﻿

damoxing=> Previous Topic: Automatic Vectorization Next Topic: Building Applications by Calling Large Models Using tencentdb_ai Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page tencentdb_ai Plugin Function Description Add a model Viewing Registered Models Updating a Model Delete a model Model Invocation Fixed-Scene APIs Dialogue Text to Vector Text Ranking Image to Text Plugin Usage Examples Search AllCurrent Product Search titles only Enter keywords to search documentation
