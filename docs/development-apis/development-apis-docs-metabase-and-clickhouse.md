---
sidebarTitle: 'Metabase'
slug: /integrations/metabase
keywords: ['Metabase']
description: 'Metabase is an easy-to-use, open source UI tool for asking questions about your data.'
title: 'Connecting Metabase to ClickHouse'
show_related_blogs: true
doc_type: 'guide'
integration:
  - support_level: 'partner'
  - category: 'data_visualization'
  - website: 'https://github.com/clickhouse/metabase-clickhouse-driver'
---

import { Image } from "/snippets/components/Image.jsx";
import ConnectionDetails from '/snippets/_gather_your_details_http.mdx';

import { PartnerBadge } from "/snippets/components/PartnerBadge/PartnerBadge.jsx";

Metabase is an easy-to-use, open source UI tool for asking questions about your data. Metabase is a Java application that can be run by simply downloading the JAR file and running it with `java -jar metabase.jar`. Metabase connects to ClickHouse using a JDBC driver that you download and put in the `plugins` folder:

## Goal {#goal}

In this guide you will ask some questions of your ClickHouse data with Metabase and visualize the answers.  One of the answers will look like this:

**Add some data**

If you don't have a dataset to work with you can add one of the examples.  This guide uses the [UK Price Paid](/get-started/sample-datasets/uk-price-paid) dataset, so you might choose that one.  There are several others to look at in the same documentation category.

1. If you don't have a `plugins` folder, create one as a subfolder of where you have `metabase.jar` saved.

2. The plugin is a JAR file named `clickhouse.metabase-driver.jar`. Download the latest version of the JAR file at https://github.com/clickhouse/metabase-clickhouse-driver/releases/latest

3. Save `clickhouse.metabase-driver.jar` in your `plugins` folder.

4. Start (or restart) Metabase so that the driver gets loaded properly.

5. Access Metabase at http://hostname:3000. On the initial startup, you will see a welcome screen and have to work your way through a list of questions. If prompted to select a database, select "**I'll add my data later**":

1. Click on the gear icon in the top-right corner and select **Admin Settings** to visit your Metabase admin page.

2. Click on **Add a database**. Alternately, you can click on the **Databases** tab and select the **Add database** button.

3. If your driver installation worked, you will see **ClickHouse** in the dropdown menu for **Database type**:

4. Give your database a **Display name**, which is a Metabase setting - so use any name you like.

5. Enter the connection details of your ClickHouse database. Enable a secure connection if your ClickHouse server is configured to use SSL. For example:

6. Click the **Save** button and Metabase will scan your database for tables.

1. Exit the **Admin settings** by clicking the **Exit admin** button in the top-right corner.

2. In the top-right corner, click the **+ New** menu and notice you can ask questions, run SQL queries, and build a dashboard:

3. For example, here is a SQL query run on a table named `uk_price_paid` that returns the average price paid by year from 1995 to 2022:

1. Click on **+ New** and select **Question**. Notice you can build a question by starting with a database and table. For example, the following question is being asked of a table named `uk_price_paid` in the `default` database. Here is a simple question that calculates the average price by town, within the county of Greater Manchester:

2. Click the **Visualize** button to see the results in a tabular view.

3. Below the results, click the **Visualization** button to change the visualization to a bar chart (or any of the other options available):

## Learn more {#learn-more}

Find more information about Metabase and how to build dashboards by visiting the Metabase documentation.
