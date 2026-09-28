---
sidebarTitle: 'Tableau Online'
slug: /integrations/tableau-online
keywords: ['clickhouse', 'tableau', 'online', 'mysql', 'connect', 'integrate', 'ui']
description: 'Tableau Online streamlines the power of data to make people faster and more confident decision makers from anywhere.'
title: 'Tableau Online'
doc_type: 'guide'
integration:
  - support_level: 'core'
  - category: 'data_visualization'
---

import MySQLCloudSetup from '/snippets/_clickhouse_mysql_cloud_setup.mdx';
import MySQLOnPremiseSetup from '/snippets/_clickhouse_mysql_on_premise_setup.mdx';
import { Image } from "/snippets/components/Image.jsx";

Tableau Online can connect to ClickHouse Cloud or on-premise ClickHouse setup via MySQL interface using the official MySQL data source.

## ClickHouse Cloud setup {#clickhouse-cloud-setup}

## On-premise ClickHouse server setup {#on-premise-clickhouse-server-setup}

## Connecting Tableau Online to ClickHouse (on-premise without SSL) {#connecting-tableau-online-to-clickhouse-on-premise-without-ssl}

Login to your Tableau Cloud site and add a new Published Data Source.

Select "MySQL" from the list of available connectors.

Specify your connection details gathered during the ClickHouse setup.

Tableau Online will introspect the database and provide a list of available tables. Drag the desired table to the canvas on the right. Additionally, you can click "Update Now" to preview the data, as well as fine-tune the introspected field types or names.

After that, all that remains is to click "Publish As" in the top right corner, and you should be able to use a newly created dataset in Tableau Online as usual.

NB: if you want to use Tableau Online in combination with Tableau Desktop and share ClickHouse datasets between them, make sure you use Tableau Desktop with the default MySQL connector as well, following the setup guide that is displayed [here](https://www.tableau.com/support/drivers) if you select MySQL from the Data Source drop-down. If you have an M1 Mac, check [this troubleshooting thread](https://community.tableau.com/s/question/0D58b0000Ar6OhvCQE/unable-to-install-mysql-driver-for-m1-mac) for a driver installation workaround.

## Connecting Tableau Online to ClickHouse (cloud or on-premise setup with SSL) {#connecting-tableau-online-to-clickhouse-cloud-or-on-premise-setup-with-ssl}

As it isn't possible to provide the SSL certificates via the Tableau Online MySQL connection setup wizard, the only way is to use Tableau Desktop to set the connection up, and then export it to Tableau Online. This process is, however, pretty straightforward.

Run Tableau Desktop on a Windows or Mac machine, and select "Connect" -> "To a Server" -> "MySQL".
Likely, it will be required to install the MySQL driver on your machine first.
You can do that by following the setup guide that is displayed [here](https://www.tableau.com/support/drivers) if you select MySQL from the Data Source drop-down.
If you have an M1 Mac, check [this troubleshooting thread](https://community.tableau.com/s/question/0D58b0000Ar6OhvCQE/unable-to-install-mysql-driver-for-m1-mac) for a driver installation workaround.

Provide your ClickHouse Cloud instance MySQL user credentials and the path to the downloaded root certificate.

Choose the desired tables as usual (similarly to Tableau Online), and select "Server" -> "Publish Data Source" -> Tableau Cloud.

IMPORTANT: you need to select "Embedded password" in "Authentication" options.

Additionally, choose "Update workbook to use the published data source".

Finally, click "Publish", and your datasource with embedded credentials will be opened automatically in Tableau Online.

## Known limitations (ClickHouse 23.11) {#known-limitations-clickhouse-2311}

All the known limitations has been fixed in ClickHouse `23.11`. If you encounter any other incompatibilities, please don't hesitate to [contact us](https://clickhouse.com/company/contact) or create a [new issue](https://github.com/ClickHouse/ClickHouse/issues).
