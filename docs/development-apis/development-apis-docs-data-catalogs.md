---
sidebarTitle: 'Data catalogs'
sidebar_label: 'Data catalogs'
sidebar_position: 2
description: 'How to connect a data catalog for Iceberg or Delta tables in ClickHouse Cloud via the Data sources UI.'
slug: /integrations/data-catalogs
title: 'Connect a data catalog in ClickHouse Cloud'
doc_type: 'guide'
keywords: ['data catalogs', 'data lake', 'iceberg', 'unity catalog', 'glue', 'delta lake', 'onelake', 'polaris', 'biglake', 'clickhouse cloud']
---

import { Image } from "/snippets/components/Image.jsx";
import { BetaBadge } from "/snippets/components/BetaBadge/BetaBadge.jsx";

Connect ClickHouse Cloud to your data catalogs to access your open table format tables. You can set up connections in the **Data sources** UI. For setup via SQL, use the [`DataLakeCatalog`](/reference/engines/database-engines/datalake) database engine in your SQL editor of choice.

Once connected, catalog tables show up in the SQL console under the database name you choose. You can query them with standard ClickHouse SQL, join them with [MergeTree](/reference/engines/table-engines/mergetree-family/mergetree) tables, and use them as sources for [materialized views](/concepts/features/materialized-views).

## Prerequisites {#prerequisites}

Before you connect a catalog, confirm the following:

- **Service permissions.** You need the `control-plane:service:manage` permission to access the **Data sources** page and add catalogs.
- **Running service.** If the service is idle, wake it from the **Data sources** or the service settings pages before connecting or viewing linked catalogs.
- **Catalog credentials.** Gather connection details for your catalog type before opening the flyout. Each catalog uses different fields and authentication — see [Add your catalog connection](#add-your-catalog-connection) below.

## Connect your catalog {#connect-your-catalog}

1. Select **Data sources** in the left navigation.
2. Click **+ Add catalog** if you haven't set up any data sources. Otherwise, click **Add data source** > **Add data lake catalog**.
3. In the **Connect your data catalog** flyout, select your catalog from the **Select catalog** dropdown. If the catalog supports multiple open table formats, choose the format in **Open table format**.

Select your catalog below for guidance and prerequisites. Then fill in the connection parameters, along with a **Database name** — the ClickHouse database that exposes your catalog tables in the SQL console.

After filling in the fields:

1. Click **Add catalog**. ClickHouse validates the connection and credentials when saving.
2. On success, a confirmation toast appears with a **View in SQL console** link. Your catalog is listed in the **Linked catalogs** table with its connection status and table count.

From the **Actions** menu on a linked catalog row, you can drop the catalog connection. Dropping removes the catalog's database from ClickHouse — it doesn't delete any data in your external catalog.

## Query your data {#query-data}

On the **Data sources** page, find your catalog in the **Linked catalogs** table and click **View tables**.

ClickHouse opens the SQL console with your catalog database selected and lists the available tables.

Write a query in the SQL editor and click **Run**. Wrap the full table name in backticks:

```sql
SELECT * FROM `identity_profiles.identity_profiles_iceberg`
```

## Troubleshooting {#troubleshooting}

- If you don't see your tables in the SQL console: verify credentials, network access, and table types in the catalog. Make sure the tables you expect to see are in supported file and table formats.

## See also {#see-also}

- [Accelerating analytics on lakehouse data](/guides/use-cases/data-warehousing/getting-started/accelerating-analytics) — load catalog tables into MergeTree for repeated queries
- [Accessing Iceberg data securely](/products/cloud/guides/data-sources/accessing-iceberg-data-securely) — IAM role setup for AWS Iceberg and Glue access
