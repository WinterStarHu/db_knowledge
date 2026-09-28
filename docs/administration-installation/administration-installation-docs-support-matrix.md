---
title: 'Support matrix'
sidebarTitle: 'Support matrix'
slug: /use-cases/data-lake/support-matrix
description: 'Comprehensive support matrices for ClickHouse open table format integrations and data catalog connections.'
keywords: ['data lake', 'lakehouse', 'support', 'iceberg', 'delta lake', 'hudi', 'paimon', 'catalog', 'features']
doc_type: 'reference'
---

This page provides comprehensive support matrices for ClickHouse's data lake integrations. It covers the features available for each open table format, the catalogs ClickHouse can connect to, and the capabilities supported by each catalog.

Support is shown separately for ClickHouse Cloud and self-managed ClickHouse. Experimental features are disabled by default in ClickHouse Cloud and [must be requested through Support](https://clickhouse.com/blog/common-getting-started-issues-with-clickhouse#13-experimental-features-in-production). Availability is feature-dependent, so contact Support to confirm whether a specific experimental feature can be enabled. Deployment-specific configuration and limitations are described in the Notes column.

## Open table format support {#format-support}

ClickHouse integrates with four open table formats: [Apache Iceberg](/reference/engines/table-engines/integrations/iceberg), [Delta Lake](/reference/engines/table-engines/integrations/deltalake), [Apache Hudi](/reference/engines/table-engines/integrations/hudi), and [Apache Paimon](/reference/functions/table-functions/paimon). Select a format below to view its support matrix.

**Legend:** ✅ Supported | ⚠️ Partial, experimental, or deprecated | ❌ Not supported

## Catalog support {#catalog-support}

ClickHouse can connect to external data catalogs using the [`DataLakeCatalog`](/reference/engines/database-engines/datalake) database engine, which exposes the catalog as a ClickHouse database. Tables registered in the catalog appear automatically and can be queried with standard SQL.

The following catalogs are currently supported. Refer to each catalog's reference guide for full setup instructions.

| Catalog | Formats | Read | Create table | INSERT | Reference guide |
|---------|---------|:-:|:-:|:-:|---------|
| [AWS Glue Catalog](/guides/use-cases/data-warehousing/glue-catalog) | Iceberg | ✅ Beta | ❌ | ❌ | [Glue catalog guide](/guides/use-cases/data-warehousing/glue-catalog) |
| [BigLake Metastore](/guides/use-cases/data-warehousing/biglake-catalog) | Iceberg | ✅ Beta | ❌ | ❌ | [BigLake Metastore guide](/guides/use-cases/data-warehousing/biglake-catalog) |
| [Databricks Unity Catalog](/guides/use-cases/data-warehousing/unity-catalog) | Delta, Iceberg | ✅ Beta | ✅ Beta | ✅ Beta | [Unity Catalog guide](/guides/use-cases/data-warehousing/unity-catalog) |
| [Iceberg REST](/guides/use-cases/data-warehousing/rest-catalog) | Iceberg | ✅ Beta | ❌ | ❌ | [REST catalog guide](/guides/use-cases/data-warehousing/rest-catalog) |
| [Lakekeeper](/guides/use-cases/data-warehousing/lakekeeper-catalog) | Iceberg | ✅ Beta | ❌ | ❌ | [Lakekeeper catalog guide](/guides/use-cases/data-warehousing/lakekeeper-catalog) |
| [Project Nessie](/guides/use-cases/data-warehousing/nessie-catalog) | Iceberg | ✅ Experimental | ❌ | ❌ | [Nessie catalog guide](/guides/use-cases/data-warehousing/nessie-catalog) |
| [Microsoft OneLake](/guides/use-cases/data-warehousing/onelake-catalog) | Iceberg | ✅ Beta | ✅ Beta | ✅ Beta | [OneLake catalog guide](/guides/use-cases/data-warehousing/onelake-catalog) |
| [SeaweedFS](/guides/use-cases/data-warehousing/seaweedfs-catalog) | Iceberg | ✅ Beta | ✅ Beta | ✅ Beta | [SeaweedFS catalog guide](/guides/use-cases/data-warehousing/seaweedfs-catalog) |

All catalog integrations currently require an experimental or beta setting to be enabled. With the exception of Microsoft OneLake, Databricks Unity Catalog, and SeaweedFS, all catalogs expose **read-only** access — tables can be queried but not created or written to through the catalog connection. To load data from a catalog into ClickHouse for faster analytics, use `INSERT INTO SELECT` as described in the [accelerating analytics guide](/guides/use-cases/data-warehousing/getting-started/accelerating-analytics). To write data back to open table formats, create standalone Iceberg tables as described in the [writing data guide](/guides/use-cases/data-warehousing/getting-started/writing-data).
