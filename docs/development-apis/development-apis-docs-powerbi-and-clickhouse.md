---
sidebarTitle: 'Power BI'
slug: /integrations/powerbi
keywords: ['clickhouse', 'Power BI', 'connect', 'integrate', 'ui']
description: 'Microsoft Power BI is an interactive data visualization software product developed by Microsoft with a primary focus on business intelligence.'
title: 'Power BI'
doc_type: 'guide'
integration:
  - support_level: 'core'
  - category: 'data_visualization'
---

import { Image } from "/snippets/components/Image.jsx";

import { ClickHouseSupportedBadge } from "/snippets/components/ClickHouseSupported/ClickHouseSupported.jsx";

Microsoft Power BI can query or load into memory data from [ClickHouse Cloud](https://clickhouse.com/cloud) or a self-managed deployment.

There are several flavours of Power BI that you can use to visualise your data:

* Power BI Desktop: A Windows desktop application for creating Dashboards and Visualisations
* Power BI Service: Available within Azure as a SaaS to host the Dashboards created on Power BI Desktop

Power BI requires you to create your dashboards within the Desktop version and publish them to Power BI Service.

This tutorial will guide you through the process of:

* [Installing the ClickHouse ODBC Driver](#install-the-odbc-driver)
* [Installing the ClickHouse Power BI Connector into Power BI Desktop](#power-bi-installation)
* [Querying data from ClickHouse for visualization in Power BI Desktop](#query-and-visualise-data)
* [Setting up an on-premise data gateway for Power BI Service](#power-bi-service)

## Prerequisites {#prerequisites}

### Power BI Installation {#power-bi-installation}

This tutorial assumes you have Microsoft Power BI Desktop installed on your Windows machine. You can download and install Power BI Desktop [here](https://www.microsoft.com/en-us/download/details.aspx?id=58494)

We recommend updating to the latest version of Power BI. The ClickHouse Connector is available by default from version `2.137.751.0`.

### Gather your ClickHouse connection details {#gather-your-clickhouse-connection-details}

You'll need the following details for connecting to your ClickHouse instance:

* Hostname - ClickHouse
* Username - User credentials
* Password - Password of the user
* Database - Name of the database on the instance you want to connect to

## Power BI desktop {#power-bi-desktop}

To get started with querying data in Power BI Desktop, you'll need to complete the following steps:

1. Install the ClickHouse ODBC Driver
2. Find the ClickHouse Connector
3. Connect to ClickHouse
4. Query and Visualize you data

### Install the ODBC Driver {#install-the-odbc-driver}

Download the most recent [ClickHouse ODBC release](https://github.com/ClickHouse/clickhouse-odbc/releases).

Execute the supplied `.msi` installer and follow the wizard.

#### Verify ODBC driver {#verify-odbc-driver}

When the driver installation is completed, you can verify the installation was successful by:

Searching for ODBC in the Start menu and select "ODBC Data Sources **(64-bit)**".

Verify the ClickHouse Driver is listed.

### Find the ClickHouse Connector {#find-the-clickhouse-connector}

On the Power BI Desktop start screen, click "Get Data".

Search for "ClickHouse"

### Connect to ClickHouse {#connect-to-clickhouse}

Select the connector, and enter in the ClickHouse instance credentials:

* Host (required) - Your instance domain/address. Make sure to add it with no prefixes/suffixes.
* Port (required) - Your instance port.
* Database - Your database name.
* Options - Any ODBC option as listed
in [ClickHouse ODBC GitHub Page](https://github.com/ClickHouse/clickhouse-odbc#configuration)
* Data Connectivity mode - DirectQuery

* Specify username and password

### Query and Visualise Data {#query-and-visualise-data}

Finally, you should see the databases and tables in the Navigator view. Select the desired table and click "Load" to
import the data from ClickHouse.

Once the import is complete, your ClickHouse Data should be accessible in Power BI as usual.

## Power BI service {#power-bi-service}

In order to use Microsoft Power BI Service, you need to create an [on-premise data gateway](https://learn.microsoft.com/en-us/power-bi/connect-data/service-gateway-onprem).

For more details on how to setup custom connectors, please refer to Microsoft's documentation on how to [use custom data connectors with an on-premises data gateway](https://learn.microsoft.com/en-us/power-bi/connect-data/service-gateway-custom-connectors).

## ODBC driver (import only) {#odbc-driver-import-only}

We recommend using the ClickHouse Connector that uses DirectQuery.

Install the [ODBC Driver](#install-the-odbc-driver) onto the on-premise data gateway instance and [verify](#verify-odbc-driver) as outlined above.

### Create a new User DSN {#create-a-new-user-dsn}

When the driver installation is complete, an ODBC data source can be created. Search for ODBC in the Start menu and select "ODBC Data Sources (64-bit)".

We need to add a new User DSN here. Click "Add" button on the left.

Choose the Unicode version of the ODBC driver.

Fill in the connection details.

### Get data into Power BI {#get-data-into-power-bi}

In case you don't have Power BI installed yet, [download and install Power BI Desktop](https://www.microsoft.com/en-us/download/details.aspx?id=58494).

On the Power BI Desktop start screen, click "Get Data".

Select "Other" -> "ODBC".

Select your previously created data source from the list.

Finally, you should see the databases and tables in the Navigator view. Select the desired table and click "Load" to import the data from ClickHouse.

Once the import is complete, your ClickHouse Data should be accessible in Power BI as usual.

## Optimizing work with large datasets {#optimizing-work-with-large-datasets}

PowerBI is designed for traditional row-based databases with moderate data volumes. When working with ClickHouse at scale (billions of rows), specific architectural patterns are required for optimal performance.

PowerBI automatically generates SQL queries with nested subqueries, complex joins, and on-the-fly transformations. These patterns work well with traditional SQL databases but can be inefficient when querying large-scale columnar databases like ClickHouse at scale.

**Recommended approach for large datasets:** Instead of querying raw tables directly, create dedicated `materialized views` in ClickHouse for each dashboard visualization. This gives you:

- Consistent, fast performance regardless of data volume
- Lower load on your ClickHouse cluster
- More predictable costs

If your dashboards are slow, check ClickHouse's [`query_log`](/reference/system-tables/query_log) to see what SQL queries Power BI is actually running. Common problems include nested subqueries, scanning entire tables, or inefficient joins. Once you identify the issue, create [materialized views](/concepts/features/materialized-views/index) that solve those specific problems.

### Implementation best practices {#implementation-best-practices}
####  Pre-aggregation strategy {#pre-aggregation-strategy}
Create materialized views at multiple aggregation levels:
- Hourly aggregations for recent, detailed dashboards
- Daily aggregations for historical trends
- Monthly rollups for long-term reporting
- Keep raw data with appropriate TTL for ad-hoc analysis

#### Data modelling optimization {#data-modelling-optimization}
- Define `ORDER BY` keys that match your query patterns
- Use partitioning for time-series data
- Convert small dimension tables to dictionaries for efficient lookups
- Leverage projections for additional query optimization

## Known limitations {#known-limitations}

### UInt64 {#uint64}

Unsigned integer types such as UInt64 or bigger won't be loaded into the dataset automatically, as Int64 is the maximum whole number type support by Power BI.

In this example, `pageviews` table has a UInt64 column, which is recognized as "Binary" by default.
"Transform Data" opens Power Query Editor, where we can reassign the type of the column, setting it as, for example, Text.

Once finished, click "Close & Apply" in the top left corner, and proceed with loading the data.
