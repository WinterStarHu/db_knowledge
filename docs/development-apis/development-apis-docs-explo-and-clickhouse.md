---
sidebarTitle: 'Explo'
slug: /integrations/explo
keywords: ['clickhouse', 'Explo', 'connect', 'integrate', 'ui']
description: 'Explo is an easy-to-use, open source UI tool for asking questions about your data.'
title: 'Connecting Explo to ClickHouse'
doc_type: 'guide'
integration:
  - support_level: 'community'
  - category: 'data_visualization'
---

import { Image } from "/snippets/components/Image.jsx";
import ConnectionDetails from '/snippets/_gather_your_details_http.mdx';

import { CommunityMaintainedBadge } from "/snippets/components/CommunityMaintainedBadge/CommunityMaintainedBadge.jsx";

Customer-facing analytics for any platform. Designed for beautiful visualization. Engineered for simplicity.

## Goal {#goal}

In this guide you will connect your data from ClickHouse to Explo and visualize the results.  The chart will look like this:

**Add some data**

If you don't have a dataset to work with you can add one of the examples.  This guide uses the [UK Price Paid](/get-started/sample-datasets/uk-price-paid) dataset, so you might choose that one.  There are several others to look at in the same documentation category.

1. Sign up for an Explo account.

2. Click on the Explo **data** tab on the left hand sidebar.

3. Click **Connect Data Source** in the upper right hand side.

4. Fill out the information on the **Getting Started** page

5. Select **ClickHouse**

6. Enter your **ClickHouse Credentials**.

7. Configure **Security**

8. Within ClickHouse, **Whitelist the Explo IPs**.
`
54.211.43.19, 52.55.98.121, 3.214.169.94, and 54.156.141.148
`

1. Navigate to **Dashboard** tab on the left side nav bar.

2. Click **Create Dashboard** in the upper right corner and name your dashboard. You've now created a dashboard!

3. You should now see a screen that is similar to this:

1. Get your table name from the right hand sidebar under your schema title. You should then put the following command into your dataset editor:
` SELECT * FROM YOUR_TABLE_NAME LIMIT 100 `

2. Now click run and go to the preview tab to see your data.

1. From the left hand side, drag the bar chart icon onto the screen.

2. Select the dataset. You should now see a screen like the following:

3. Fill out the **county** in the X Axis and **Price** in the Y Axis Section like so:

4. Now, change the aggregation to **AVG**.

5. We now have average price of homes broken down by price!

## Learn more {#learn-more}

Find more information about Explo and how to build dashboards by visiting the Explo documentation.
