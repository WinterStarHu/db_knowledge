---
sidebarTitle: 'Looker'
slug: /integrations/looker
keywords: ['clickhouse', 'looker', 'connect', 'integrate', 'ui']
description: 'Looker is an enterprise platform for BI, data applications, and embedded analytics that helps you explore and share insights in real time.'
title: 'Looker'
doc_type: 'guide'
integration:
  - support_level: 'partner'
  - category: 'data_visualization'
---

import { Image } from "/snippets/components/Image.jsx";
import ConnectionDetails from '/snippets/_gather_your_details_http.mdx';

import { PartnerBadge } from "/snippets/components/PartnerBadge/PartnerBadge.jsx";

Looker can connect to ClickHouse Cloud or on-premise deployment via the official ClickHouse data source.

Navigate to Admin -> Database -> Connections and click the "Add Connection" button in the top right corner.

Choose a name for your data source, and select `ClickHouse` from the dialect drop-down. Enter your credentials in the form.

If you're using ClickHouse Cloud or your deployment requires SSL, make sure you have SSL turned on in the additional settings.

Test your connection first, and, once it is done, connect to your new ClickHouse data source.

Now you should be able to attach ClickHouse Datasource to your Looker project.

## Known limitations {#3-known-limitations}

1. The following data types are handled as strings by default:
  * Array - serialization doesn't work as expected due to the JDBC driver limitations
  * Decimal* - can be changed to number in the model
  * LowCardinality(...) - can be changed to a proper type in the model
  * Enum8, Enum16
  * UUID
  * Tuple
  * Map
  * JSON
  * Nested
  * FixedString
  * Geo types
  * MultiPolygon
  * Polygon
  * Point
  * Ring
2. [Symmetric aggregate feature](https://cloud.google.com/looker/docs/reference/param-explore-symmetric-aggregates) isn't supported
3. [Full outer join](https://cloud.google.com/looker/docs/reference/param-explore-join-type#full_outer) isn't yet implemented in the driver
