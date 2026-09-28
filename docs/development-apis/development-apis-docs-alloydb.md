---
sidebarTitle: 'AlloyDB Postgres'
description: 'Set up an AlloyDB Postgres instance as a source for ClickPipes'
slug: /integrations/clickpipes/postgres/source/alloydb
title: 'AlloyDB Postgres source setup guide'
doc_type: 'guide'
---

import { Image } from "/snippets/components/Image.jsx";

## Supported versions {#supported-versions}

To propagate data from your AlloyDB instance to ClickHouse Cloud using ClickPipes, your instance must be configured for **logical replication**. This is supported **from AlloyDB Version 14**.

## Enable logical replication {#enable-logical-replication}

To check if logical replication is enabled in your AlloyDB instance, run the following query against your primary instance:

```sql
SHOW  wal_level;
```

If the result is `logical`, logical replication is already enabled and you can skip to the [next step](#create-a-clickpipes-user-and-manage-replication-permissions). If the result is `replica`, you must set the [`alloydb.enable_pglogical`](https://cloud.google.com/alloydb/docs/reference/alloydb-flags#alloydb.enable_pglogical) and [`alloydb.logical_decoding`](https://cloud.google.com/alloydb/docs/reference/alloydb-flags#alloydb.logical_decoding) flags to `on` in the primary instance.

As noted in the [AlloyDB flags documentation](https://cloud.google.com/alloydb/docs/reference/alloydb-flags), modifying the flags that enable logical replication requires a restart of the primary instance.

To enable these flags:

1. In the Google Cloud Console, navigate to the AlloyDB [Clusters](https://console.cloud.google.com/alloydb/clusters) page. From the **Actions** menu for your primary instance, click **Edit**.

2. Scroll down to **Advanced configuration options** and expand the section. Under **Flags**, click **Add a database flag**.
  - Add the [`allowdb.enable_pglogical`](https://cloud.google.com/alloydb/docs/reference/alloydb-flags#alloydb.enable_pglogical) flag and set its value to `on`
  - Add the [`alloydb.logical_decoding`](https://cloud.google.com/alloydb/docs/reference/alloydb-flags#alloydb.logical_decoding) flag and set its value to `on`

3. Click **Update instance** to save the configuration changes. It's important to note that this action **triggers a restart of the primary instance.**

4. Once the status of the instance changes from `Updating` to `Ready`, run the following query against your primary instance to verify that logical replication is enabled:

   ```sql
   SHOW  wal_level;
   ```

The result should be `logical`.

## Create a ClickPipes user and manage replication permissions {#create-a-clickpipes-user-and-manage-replication-permissions}

Connect to your AlloyDB instance as an admin user and execute the following commands:

1. Create a dedicated user for ClickPipes:

   ```sql
   CREATE USER clickpipes_user PASSWORD 'some-password';
   ```

2. Grant schema-level, read-only access to the user you created in the previous step. The following example shows permissions for the `public` schema. Repeat these commands for each schema containing tables you want to replicate:

    ```sql
    GRANT USAGE ON SCHEMA "public" TO clickpipes_user;
    GRANT SELECT ON ALL TABLES IN SCHEMA "public" TO clickpipes_user;
    ALTER DEFAULT PRIVILEGES IN SCHEMA "public" GRANT SELECT ON TABLES TO clickpipes_user;
    ```

3. Grant replication privileges to the user:

   ```sql
   ALTER USER clickpipes_user WITH REPLICATION;
   ```

4. Create a [publication](https://www.postgresql.org/docs/current/logical-replication-publication.html) with the tables you want to replicate. We strongly recommend only including the tables you need in the publication to avoid performance overhead.

Any table included in the publication must either have a **primary key** defined _or_ have its **replica identity** configured to `FULL`. See the [Postgres FAQs](/integrations/clickpipes/postgres/faq#how-should-i-scope-my-publications-when-setting-up-replication) for guidance on scoping.

  - To create a publication for specific tables:

      ```sql
      CREATE PUBLICATION clickpipes FOR TABLE table_to_replicate, table_to_replicate2;
      ```

  - To create a publication for all tables in a specific schema:

      ```sql
      CREATE PUBLICATION clickpipes FOR TABLES IN SCHEMA "public";
      ```

The `clickpipes` publication defines the set of tables whose change events will be streamed to ClickPipes. We recommend against using `FOR ALL TABLES` unless you intend to replicate every table, as including unnecessary tables increases WAL traffic from Postgres to ClickPipes and reduces overall replication efficiency.

## Configure network access {#configure-network-access}

Next, choose how ClickPipes will connect to your AlloyDB instance.

## What's next? {#whats-next}

You can now [create your ClickPipe](/integrations/clickpipes/postgres/index) and start ingesting data from your Postgres instance into ClickHouse Cloud.
Make sure to note down the connection details you used while setting up your Postgres instance as you will need them during the ClickPipe creation process.
