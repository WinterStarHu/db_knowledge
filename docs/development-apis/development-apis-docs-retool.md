---
sidebarTitle: 'Retool'
slug: /integrations/retool
keywords: ['clickhouse', 'retool', 'connect', 'integrate', 'ui', 'admin', 'panel', 'dashboard', 'nocode', 'no-code']
description: 'Quickly build web and mobile apps with rich user interfaces, automate complex tasks, and integrate AI—all powered by your data.'
title: 'Connecting Retool to ClickHouse'
doc_type: 'guide'
integration:
  - support_level: 'partner'
  - category: 'data_integration'
---

import ConnectionDetails from '/snippets/_gather_your_details_http.mdx';
import { Image } from "/snippets/components/Image.jsx";

import { PartnerBadge } from "/snippets/components/PartnerBadge/PartnerBadge.jsx";

Login to your Retool account and navigate to the _Resources_ tab. Choose "Create New" -> "Resource":

Select "JDBC" from the list of available connectors:

In the setup wizard, make sure you select `com.clickhouse.jdbc.ClickHouseDriver` as the "Driver name":

Fill in your ClickHouse credentials in the following format: `jdbc:clickhouse://HOST:PORT/DATABASE?user=USERNAME&password=PASSWORD`.
If your instance requires SSL or you're using ClickHouse Cloud, add `&ssl=true` to the connection string, so it looks like `jdbc:clickhouse://HOST:PORT/DATABASE?user=USERNAME&password=PASSWORD&ssl=true`

After that, test your connection:

Now, you should be able to proceed to your app using your ClickHouse resource.
