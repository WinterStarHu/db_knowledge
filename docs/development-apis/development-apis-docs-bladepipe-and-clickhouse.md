---
sidebarTitle: 'BladePipe'
keywords: ['clickhouse', 'BladePipe', 'connect', 'integrate', 'cdc', 'etl', 'data integration']
slug: /integrations/bladepipe
description: 'Stream data into ClickHouse using BladePipe data pipelines'
title: 'Connect BladePipe to ClickHouse'
doc_type: 'guide'
---

import { Image } from "/snippets/components/Image.jsx";

import { PartnerBadge } from "/snippets/components/PartnerBadge/PartnerBadge.jsx";

BladePipe is a real-time end-to-end data integration tool with sub-second latency, boosting seamless data flow across platforms.

ClickHouse is one of BladePipe's pre-built connectors, allowing users to integrate data from various sources into ClickHouse automatically. This page will show how to load data into ClickHouse in real time step by step.

## Supported sources {#supported-sources}
Currently BladePipe supports for data integration to ClickHouse from the following sources:
- MySQL/MariaDB/AuroraMySQL
- Oracle
- PostgreSQL/AuroraPostgreSQL
- MongoDB
- Kafka
- PolarDB-MySQL
- OceanBase
- TiDB

More sources are to be supported.

1. Log in to BladePipe Cloud.

2. Follow the instructions in Install Worker (Docker) or Install Worker (Binary) to download and install a BladePipe Worker.

1. In BladePipe, click "DataSource" > "Add DataSource".

2. Select `ClickHouse`, and fill out the settings by providing your ClickHouse host and port, username and password, and click "Test Connection".

3. Click "Add DataSource" at the bottom, and a ClickHouse instance is added.
In this tutorial, we use a MySQL instance as the source, and explain the process of loading MySQL data to ClickHouse.

1. In BladePipe, click "DataSource" > "Add DataSource".

2. Select `MySQL`, and fill out the settings by providing your MySQL host and port, username and password, and click "Test Connection".

3. Click "Add DataSource" at the bottom, and a MySQL instance is added.

1. In BladePipe, click "DataJob" > "Create DataJob".

2. Select the added MySQL and ClickHouse instances and click "Test Connection" to ensure BladePipe is connected to the instances. Then, select the databases to be moved.

3. Select "Incremental" for DataJob Type, together with the "Full Data" option.

4. Select the tables to be replicated.

5. Select the columns to be replicated.

6. Confirm the DataJob creation, and the DataJob runs automatically.

1. Stop data write in MySQL instance and wait for ClickHouse to merge data.

2. Create a Verification DataJob. Once the Verification DataJob is completed, review the results to confirm that the data in ClickHouse is the same as the data in MySQL.
