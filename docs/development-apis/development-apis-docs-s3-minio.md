---
sidebarTitle: 'MinIO'
slug: /integrations/minio
description: 'Page describing how to use MinIO with ClickHouse'
title: 'Using MinIO'
doc_type: 'guide'
integration:
  - support_level: 'core'
  - category: 'data_ingestion'
keywords: ['s3', 'minio', 'object storage', 'data loading', 'compatible storage']
---

import SelfManaged from '/snippets/_self_managed_only_no_roadmap.mdx';

All S3 functions and tables and compatible with [MinIO](https://min.io/). You may experience superior throughput on self-hosted MinIO stores, especially in the event of optimal network locality.

Also backed merge tree configuration is compatible too, with some minor changes in configuration:

```xml
        ...
https://min.io/tables//
your_access_key_id
your_secret_access_key
/var/lib/clickhouse/disks/s3/
cache
/var/lib/clickhouse/disks/s3_cache/
10Gi
        ...
```

Note the double slash in the endpoint tag, this is needed to designate the bucket root.
