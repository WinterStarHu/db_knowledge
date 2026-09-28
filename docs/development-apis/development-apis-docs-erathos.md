---
sidebarTitle: 'Erathos'
keywords: ['clickhouse', 'Erathos', 'connect', 'integrate', 'ELT', 'etl', 'data integration', 'real-time', 'sync']
description: 'Sync data into ClickHouse using Erathos, an ELT platform for control and observability'
title: 'Connect Erathos to ClickHouse'
doc_type: 'guide'
integration:
  - support_level: 'community'
  - category: 'data_ingestion'
  - website: 'https://erathos.com'
---

import ConnectionDetails from '/snippets/_gather_your_details_http.mdx'; import { CommunityMaintainedBadge } from "/snippets/components/CommunityMaintainedBadge/CommunityMaintainedBadge.jsx";

Erathos is an ELT platform built for control without the overhead, letting teams manage every sync job from SaaS tools and databases into the warehouse.

## Overview {#overview}

Erathos gives teams visibility and control over every sync job as data moves from SaaS tools, ERPs, and CRMs into ClickHouse. Instead of managing pipelines as opaque, scheduled jobs, Erathos lets you monitor and control syncs in real time, making it easier to catch issues early and keep your warehouse up to date.

## Connecting Erathos to ClickHouse {#connecting-erathos-to-clickhouse}

After creating a service in ClickHouse Cloud, find the following required settings:

In Erathos, go to **Settings > Destination**, select **ClickHouse**, and enter the following:

- **Host** — your ClickHouse service URL (ClickHouse Cloud URLs typically end in `.clickhouse.cloud`)
- **Port** — usually `8443` for HTTPS connections
- **Username** — often `default`
- **Password** — the password for the account above

Save the configuration to complete the connection.

## Additional resources {#additional-resources}

For more details, see Erathos's ClickHouse destination docs, or contact support@erathos.com.
