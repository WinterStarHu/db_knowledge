---
sidebarTitle: 'TABLUM.IO'
slug: /integrations/tablumio
description: 'TABLUM.IO is a data management SaaS that supports ClickHouse out of the box.'
title: 'Connecting TABLUM.IO to ClickHouse'
doc_type: 'guide'
keywords: ['tablum', 'sql client', 'database tool', 'query tool', 'desktop app']
integration:
  - support_level: 'community'
  - category: 'sql_client'
---

import { Image } from "/snippets/components/Image.jsx";

import { CommunityMaintainedBadge } from "/snippets/components/CommunityMaintainedBadge/CommunityMaintainedBadge.jsx";

## Open the TABLUM.IO startup page {#open-the-tablumio-startup-page}

First, sign up to TABLUM.IO using your email or use a quick-login via accounts in Google or Facebook.

Gather your ClickHouse connection details, navigate to the **Connector** tab, and fill in the host URL, port, username, password, database name, and connector's name. After completing these fields, click on **Test connection** button to validate the details and then click on  **Save connector for me** to make it persistent.

Make sure that you specify the correct **HTTP** port and toggle **SSL** mode according to your connection details.

Typically, the port is 8443 when using TLS or 8123 when not using TLS.

Navigate to the **Dataset** tab. Select recently created ClickHouse connector in the dropdown. In the right panel, you will see the list of available tables and schemas.

Type a query in the SQL Console and press **Run Query**. The results will be displayed as a spreadsheet.

Right-click on the column name to open the dropdown menu with sort, filter and other actions.

## Learn more {#learn-more}

Find more information about TABLUM.IO at https://tablum.io.
