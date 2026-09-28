---
sidebarTitle: 'Spark JDBC'
slug: /integrations/apache-spark/spark-jdbc
description: 'Introduction to Apache Spark with ClickHouse'
keywords: ['clickhouse', 'Apache Spark', 'jdbc', 'migrating', 'data']
title: 'Spark JDBC'
doc_type: 'guide'
integration:
  - support_level: 'core'
  - category: 'data_ingestion'
---

import { ClickHouseSupportedBadge } from "/snippets/components/ClickHouseSupported/ClickHouseSupported.jsx";

JDBC is one of the most commonly used data sources in Spark.
In this section, we will provide details on how to use the [ClickHouse official JDBC connector](/integrations/language-clients/java/jdbc) with Spark.

## Read data {#read-data}

## Write data {#write-data}

## Parallelism {#parallelism}

When using Spark JDBC, Spark reads the data using a single partition. To achieve higher concurrency, you must specify `partitionColumn`, `lowerBound`, `upperBound`, and `numPartitions`, which describe how to partition the table when reading in parallel from multiple workers.
Please visit Apache Spark's official documentation for more information on [JDBC configurations](https://spark.apache.org/docs/latest/sql-data-sources-jdbc.html#data-source-option).

## JDBC limitations {#jdbc-limitations}

*  Spark JDBC lacks support for complex types (MAP, ARRAY, STRUCT) due to missing ClickHouse dialect - use the native Spark-ClickHouse connector for full complex type support.
*  As of today, you can insert data using JDBC only into existing tables (currently, there is no way to auto-create the
table on DF insertion, as Spark does with other connectors).
