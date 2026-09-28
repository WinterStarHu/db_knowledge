# 基于Psycopg开发

Psycopg是一种用于执行SQL语句的PythonAPI，可以为PostgreSQL、openGauss数据库提供统一访问接口，应用程序可基于它进行数据操作。Psycopg2是对libpq的封装，主要使用C语言实现，既高效又安全。它具有客户端游标和服务器端游标、异步通信和通知、支持“COPY TO/COPY FROM”功能。支持多种类型Python开箱即用，适配PostgreSQL数据类型；通过灵活的对象适配系统，可以扩展和定制适配。Psycopg2兼容Unicode和Python 3。

openGauss数据库提供了对Psycopg2特性的支持，并且支持Psycopg2通过SSL模式链接。

**表 1**  Psycopg支持平台

操作系统 EulerOS 2.5 x86_64位 EulerOS 2.8 ARM64位

- **[Psycopg包](psycopg_package.md)**

- **[开发流程](development_process_psycopg.md)**

- **[加载驱动](loading_a_driver_psycopg.md)**

- **[连接数据库](connecting_to_the_database_using_ssl_psycopg.md)**

- **[执行SQL语句](executing_sql_statements_psycopg.md)**

- **[处理结果集](processing_the_result_set_psycopg.md)**

- **[关闭连接](closing_the_connection_psycopg.md)**

- **[连接数据库（SSL方式）](connecting_to_the_database_using_ssl_psycopg.md)**

- **[示例：常用操作](example_common_operations_psycopg.md)**

- **[Psycopg接口参考](psycopg_api_reference.md)**
