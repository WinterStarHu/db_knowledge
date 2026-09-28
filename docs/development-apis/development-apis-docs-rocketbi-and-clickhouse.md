---
sidebarTitle: 'Rocket BI'
slug: /integrations/rocketbi
keywords: ['clickhouse', 'RocketBI', 'connect', 'integrate', 'ui']
description: 'RocketBI is a self-service business intelligence platform that helps you quickly analyze data, build drag-n-drop visualizations and collaborate with colleagues right on your web browser.'
title: 'Goal: build your first dashboard with Rocket.BI'
doc_type: 'guide'
integration:
  - support_level: 'community'
  - category: 'data_visualization'
---

import { Image } from "/snippets/components/Image.jsx";

import { CommunityMaintainedBadge } from "/snippets/components/CommunityMaintainedBadge/CommunityMaintainedBadge.jsx";

In this guide, you will install and build a simple dashboard using Rocket.BI .
This is the dashboard:

You can checkout [the Dashboard via this link.](https://demo.rocket.bi/dashboard/sales-dashboard-7?token=7eecf750-cbde-4c53-8fa8-8b905fec667e)

## Install {#install}

Start RocketBI with our pre-built docker images.

Get docker-compose.yml and configuration file:

```bash
wget https://raw.githubusercontent.com/datainsider-co/rocket-bi/main/docker/docker-compose.yml
wget https://raw.githubusercontent.com/datainsider-co/rocket-bi/main/docker/.clickhouse.env
```
Edit .clickhouse.env, add clickhouse server information.

Start RocketBI by run command: ``` docker-compose up -d . ```

Open browser, go to ```localhost:5050```, login with this account: ```hello@gmail.com/123456```

To build from source or advanced configuration you could check it here [Rocket.BI Readme](https://github.com/datainsider-co/rocket-bi/blob/main/README.md)

## Let's build the dashboard {#lets-build-the-dashboard}

In Dashboard, you will find your reportings, start visualization by clicking **+New**

You can build **unlimited dashboards** & draw **unlimited charts** in a dashboard.

See hi-res tutorial on Youtube: [https://www.youtube.com/watch?v=TMkdMHHfvqY](https://www.youtube.com/watch?v=TMkdMHHfvqY)

### Build the chart controls {#build-the-chart-controls}

#### Create a metrics control {#create-a-metrics-control}
In the Tab filter, select metric fields you want to use. Make sure to keep check on aggregation setting.

Rename filters & Save Control to Dashboard

#### Create a date type control {#create-a-date-type-control}
Choose a Date field as Main Date column:

Add duplicate variants with different lookup ranges. For example, Year, Monthly, Daily date or Day of Week.

Rename filters & Save Control to Dashboard

### Now, let build the Charts {#now-let-build-the-charts}

#### Pie chart: sales metrics by regions {#pie-chart-sales-metrics-by-regions}
Choose Adding new chart, then Select Pie Chart

First Drag & Drop the column "Region" from the Dataset to Legend Field

Then, change to Chart Control Tab

Drag & Drop the Metrics Control into Value Field

(you can also use Metrics Control as Sorting)

Navigate to Chart Setting for further customization

For example, change Data label to Percentage

Save & Add the Chart to Dashboard

#### Use date control in a time-series chart {#use-date-control-in-a-time-series-chart}
Let Use a Stacked Column Chart

In Chart Control, use Metrics Control as Y-axis & Date Range as X-axis

Add Region column in to Breakdown

Adding Number Chart as KPIs & glare-up the Dashboard

Now, you had successfully build your 1st dashboard with rocket.BI
