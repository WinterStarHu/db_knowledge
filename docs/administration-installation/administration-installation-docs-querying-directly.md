---
title: 'Querying open table formats directly'
sidebarTitle: 'Direct querying'
slug: /use-cases/data-lake/getting-started/querying-directly
description: 'Use ClickHouse table functions to read Iceberg, Delta Lake, Hudi, and Paimon tables in object storage without any prior setup.'
toc_max_heading_level: 2
keywords: ['data lake', 'lakehouse', 'iceberg', 'delta lake', 'hudi', 'paimon', 'table functions']
doc_type: 'guide'
---

import { ExperimentalBadge } from "/snippets/components/ExperimentalBadge/ExperimentalBadge.jsx";

ClickHouse provides table functions for querying data stored in open table formats directly in object storage. This does not require connecting to an external catalog - it queries the data in place, similar to how AWS Athena reads from S3.

You pass the storage path and credentials directly in the function call, and ClickHouse handles the rest. All ClickHouse SQL syntax and functions are available, and queries benefit from ClickHouse's parallelized execution and [efficient native Parquet reader](https://clickhouse.com/blog/clickhouse-and-parquet-a-foundation-for-fast-lakehouse-analytics).

**Server, local or chDB**

The steps in this guide can be executed using an existing ClickHouse server installation. For ad hoc querying, you can instead use [clickhouse-local](/concepts/features/tools-and-utilities/clickhouse-local) and complete the same workflow without running a server. With minor adjustments, the process can also be performed using ClickHouse’s in process distribution, [chDB](/chdb/index).

The following examples use the [hits](/get-started/sample-datasets/star-schema) dataset stored in each lakehouse format on S3. For each lake format, dedicated functions exist for each object store provider.
