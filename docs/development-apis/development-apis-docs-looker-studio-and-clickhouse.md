---
sidebarTitle: 'Looker Studio'
slug: /integrations/lookerstudio
keywords: ['clickhouse', 'looker', 'studio', 'connect', 'mysql', 'integrate', 'ui']
description: 'Looker Studio, formerly Google Data Studio, is an online tool for converting data into customizable informative reports and dashboards.'
title: 'Looker Studio'
doc_type: 'guide'
integration:
  - support_level: 'partner'
  - category: 'data_visualization'
---

import { Image } from "/snippets/components/Image.jsx";
import MySQLCloudSetup from '/snippets/_clickhouse_mysql_cloud_setup.mdx';
import MySQLOnPremiseSetup from '/snippets/_clickhouse_mysql_on_premise_setup.mdx';

import { PartnerBadge } from "/snippets/components/PartnerBadge/PartnerBadge.jsx";

Looker Studio can connect to ClickHouse via the MySQL interface using the official Google MySQL data source.

## ClickHouse Cloud setup {#clickhouse-cloud-setup}

## On-premise ClickHouse server setup {#on-premise-clickhouse-server-setup}

## Connecting Looker Studio to ClickHouse {#connecting-looker-studio-to-clickhouse}

First, log in to [Looker Studio](https://lookerstudio.google.com) using your Google account and create a new Data Source:

Search for the official MySQL connector provided by Google (named just **MySQL**):

Specify your connection details. Please note that MySQL interface port is 9004 by default, and it might be different depending on your server configuration.

Now, you have two options on how to fetch the data from ClickHouse. First, you could use the Table Browser feature:

Alternatively, you could specify a custom query to fetch your data:

Finally, you should be able to see the introspected table structure and adjust the data types if necessary.

Now you can proceed with exploring your data or creating a new report!

## Using Looker Studio with ClickHouse Cloud {#using-looker-studio-with-clickhouse-cloud}

When using ClickHouse Cloud, you need to enable MySQL interface first. You can do that in connection dialog, "MySQL" tab.

In the Looker Studio UI, choose the "Enable SSL" option. ClickHouse Cloud's SSL certificate is signed by [Let's Encrypt](https://letsencrypt.org/certificates/). You can download this root cert [here](https://letsencrypt.org/certs/isrgrootx1.pem).

The rest of the steps are the same as listed above in the previous section.
