---
sidebarTitle: 'MongoDB Atlas'
description: 'Step-by-step guide on how to set up MongoDB Atlas as a source for ClickPipes'
slug: /integrations/clickpipes/mongodb/source/atlas
title: 'MongoDB Atlas source setup guide'
doc_type: 'guide'
keywords: ['clickpipes', 'mongodb', 'cdc', 'data ingestion', 'real-time sync']
integration:
  - support_level: 'core'
  - category: 'clickpipes'
---

import { Image } from "/snippets/components/Image.jsx";

## Configure oplog retention {#enable-oplog-retention}

Minimum oplog retention of 24 hours is required for replication. We recommend setting the oplog retention to 72 hours or longer to ensure that the oplog isn't truncated before the initial snapshot is completed. To set the oplog retention via UI:

1. Navigate to your cluster's `Overview` tab in the MongoDB Atlas console and click on the `Configuration` tab.

2. Click `Additional Settings` and scroll down to `More Configuration Options`.

3. Click `More Configuration Options` and set the minimum oplog window to `72 hours` or longer.

4. Click `Review Changes` to review, and then `Apply Changes` to deploy the changes.

## Configure a database user {#configure-database-user}

Once you're logged in to your MongoDB Atlas console, click `Database Access` under the Security tab in the left navigation bar. Click on "Add New Database User".

ClickPipes requires password authentication:

ClickPipes requires a user with the following roles:

- `readAnyDatabase`
- `clusterMonitor`

You can find them in the `Specific Privileges` section:

You can further specify the clusters/instances you wish to grant access to ClickPipes user:

## What's next? {#whats-next}

You can now [create your ClickPipe](/integrations/clickpipes/mongodb/index) and start ingesting data from your MongoDB instance into ClickHouse Cloud.
Make sure to note down the connection details you used while setting up your MongoDB instance as you will need them during the ClickPipe creation process.
