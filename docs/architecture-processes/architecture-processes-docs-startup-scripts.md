---
description: 'Guide to configuring and using SQL startup scripts in ClickHouse for
automatic schema creation and migrations'
sidebarTitle: 'Startup scripts'
slug: /operations/startup-scripts
title: 'Startup scripts'
doc_type: 'guide'
---

ClickHouse can run arbitrary SQL queries from the server configuration during startup. This can be useful for migrations or automatic schema creation.

```xml
false
CREATE ROLE OR REPLACE test_role
CREATE TABLE TestTable (id UInt64) ENGINE=TinyLog
SELECT 1;
CREATE DICTIONARY test_dict (...) SOURCE(CLICKHOUSE(...))
default
```

ClickHouse executes all queries from the `startup_scripts` sequentially in the specified order. If any of the queries fail, the execution of the following queries won't be interrupted. However, if `throw_on_error` is set to true, the server will not start if an error occurs during script execution.

You can specify a conditional query in the config. In that case, the corresponding query executes only when the condition query returns the value `1` or `true`.
