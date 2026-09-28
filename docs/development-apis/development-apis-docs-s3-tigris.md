---
sidebar_label: 'Tigris'
sidebar_position: 7
sidebarTitle: 'Tigris'
slug: /integrations/tigris
description: 'Use Tigris S3-compatible object storage with ClickHouse'
title: 'Using Tigris'
doc_type: 'guide'
integration:
  - support_level: 'community'
  - category: 'data_ingestion'
keywords: ['s3', 'tigris', 'object storage', 'data loading', 'compatible storage']
---

import SelfManaged from '/snippets/_self_managed_only_no_roadmap.mdx';

ClickHouse's `s3` table function and `S3` disk type are compatible with [Tigris](https://www.tigrisdata.com), an S3-compatible object storage service. Tigris exposes a single global endpoint at `https://t3.storage.dev` with reads served from the region nearest the caller, so a multi-region ClickHouse fleet can point at one bucket URL without per-region replicas or cross-region egress.

The backed merge tree configuration is compatible with minor changes:

```xml
        ...
https://your-bucket.t3.storage.dev/tables/
your_access_key_id
your_secret_access_key
auto
/var/lib/clickhouse/disks/s3/
cache
/var/lib/clickhouse/disks/s3_cache/
10Gi
        ...
```

Set `auto`. Tigris uses a single global endpoint rather than per-region buckets, but the AWS SigV4 signing flow that ClickHouse uses still requires a region value, and `auto` is the convention.

The `s3` table function works against the same endpoint:

```sql
SELECT *
FROM s3(
    'https://your-bucket.t3.storage.dev/path/to/file.parquet',
    'your_access_key_id',
    'your_secret_access_key',
    'Parquet'
);
```

Access keys can be created from the [Tigris Console](https://console.storage.dev/). Access key IDs are prefixed with `tid_` and secrets with `tsec_`.
