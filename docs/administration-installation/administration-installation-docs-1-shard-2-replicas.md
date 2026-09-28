---
slug: /architecture/replication
sidebarTitle: 'Replication'
title: 'Replicating data'
description: 'Page describing an example architecture with five servers configured. Two are used to host copies of the data and the rest are used to coordinate the replication of data'
doc_type: 'guide'
keywords: ['replication', 'high availability', 'cluster setup', 'data redundancy', 'fault tolerance']
---

import { Image } from "/snippets/components/Image.jsx";

import ConfigExplanation from '/snippets/_config_explanation.mdx';
import ListenHost from '/snippets/_listen_host.mdx';
import ServerParameterTable from '/snippets/_server_parameter_table.mdx';
import KeeperConfig from '/snippets/_keeper_config.mdx';
import KeeperConfigExplanation from '/snippets/_keeper_explanation.mdx';
import VerifyKeeperStatus from '/snippets/_verify_keeper_using_mntr.mdx';
import DedicatedKeeperServers from '/snippets/_dedicated_keeper_servers.mdx';
import ExampleFiles from '/snippets/_working_example.mdx';
import CloudTip from '/snippets/_cloud_tip.mdx';

> In this example, you'll learn how to set up a simple ClickHouse cluster which
replicates the data. There are five servers configured. Two are used to host copies of the data. The other three servers are used to coordinate the replication of data.

The architecture of the cluster you will be setting up is shown below:

## Prerequisites {#pre-requisites}

- You've set up a [local ClickHouse server](/get-started/setup/install) before
- You're familiar with basic configuration concepts of ClickHouse such as [configuration files](/concepts/features/configuration/server-config/configuration-files)
- You have docker installed on your machine

In this tutorial, you will use [Docker compose](https://docs.docker.com/compose/) to set up the ClickHouse cluster. This setup could be modified to work for separate local machines, virtual machines or cloud instances as well.

Run the following commands to set up the directory structure for this example:

```bash
mkdir cluster_1S_2R
cd cluster_1S_2R

# Create clickhouse-keeper directories
for i in {01..03}; do
  mkdir -p fs/volumes/clickhouse-keeper-${i}/etc/clickhouse-keeper
done

# Create clickhouse-server directories
for i in {01..02}; do
  mkdir -p fs/volumes/clickhouse-${i}/etc/clickhouse-server
done
```

Add the following `docker-compose.yml` file to the `cluster_1S_2R` directory:

```yaml title="docker-compose.yml"
version: '3.8'
services:
  clickhouse-01:
    image: "clickhouse/clickhouse-server:latest"
    user: "101:101"
    container_name: clickhouse-01
    hostname: clickhouse-01
    volumes:
      - ${PWD}/fs/volumes/clickhouse-01/etc/clickhouse-server/config.d/config.xml:/etc/clickhouse-server/config.d/config.xml
      - ${PWD}/fs/volumes/clickhouse-01/etc/clickhouse-server/users.d/users.xml:/etc/clickhouse-server/users.d/users.xml
    ports:
      - "127.0.0.1:8123:8123"
      - "127.0.0.1:9000:9000"
    depends_on:
      - clickhouse-keeper-01
      - clickhouse-keeper-02
      - clickhouse-keeper-03
  clickhouse-02:
    image: "clickhouse/clickhouse-server:latest"
    user: "101:101"
    container_name: clickhouse-02
    hostname: clickhouse-02
    volumes:
      - ${PWD}/fs/volumes/clickhouse-02/etc/clickhouse-server/config.d/config.xml:/etc/clickhouse-server/config.d/config.xml
      - ${PWD}/fs/volumes/clickhouse-02/etc/clickhouse-server/users.d/users.xml:/etc/clickhouse-server/users.d/users.xml
    ports:
      - "127.0.0.1:8124:8123"
      - "127.0.0.1:9001:9000"
    depends_on:
      - clickhouse-keeper-01
      - clickhouse-keeper-02
      - clickhouse-keeper-03
  clickhouse-keeper-01:
    image: "clickhouse/clickhouse-keeper:latest-alpine"
    user: "101:101"
    container_name: clickhouse-keeper-01
    hostname: clickhouse-keeper-01
    volumes:
     - ${PWD}/fs/volumes/clickhouse-keeper-01/etc/clickhouse-keeper/keeper_config.xml:/etc/clickhouse-keeper/keeper_config.xml
    ports:
        - "127.0.0.1:9181:9181"
  clickhouse-keeper-02:
    image: "clickhouse/clickhouse-keeper:latest-alpine"
    user: "101:101"
    container_name: clickhouse-keeper-02
    hostname: clickhouse-keeper-02
    volumes:
     - ${PWD}/fs/volumes/clickhouse-keeper-02/etc/clickhouse-keeper/keeper_config.xml:/etc/clickhouse-keeper/keeper_config.xml
    ports:
        - "127.0.0.1:9182:9181"
  clickhouse-keeper-03:
    image: "clickhouse/clickhouse-keeper:latest-alpine"
    user: "101:101"
    container_name: clickhouse-keeper-03
    hostname: clickhouse-keeper-03
    volumes:
     - ${PWD}/fs/volumes/clickhouse-keeper-03/etc/clickhouse-keeper/keeper_config.xml:/etc/clickhouse-keeper/keeper_config.xml
    ports:
        - "127.0.0.1:9183:9181"
```

Create the following sub-directories and files:

```bash
for i in {01..02}; do
  mkdir -p fs/volumes/clickhouse-${i}/etc/clickhouse-server/config.d
  mkdir -p fs/volumes/clickhouse-${i}/etc/clickhouse-server/users.d
  touch fs/volumes/clickhouse-${i}/etc/clickhouse-server/config.d/config.xml
  touch fs/volumes/clickhouse-${i}/etc/clickhouse-server/users.d/users.xml
done
```

### Server setup {#server-setup}

Now modify each empty configuration file `config.xml` located at `fs/volumes/clickhouse-{}/etc/clickhouse-server/config.d`. The lines which are highlighted below need to be changed to be specific to each node:

```xml highlight={9,53-57}
debug
/var/log/clickhouse-server/clickhouse-server.log
/var/log/clickhouse-server/clickhouse-server.err.log
1000M
cluster_1S_2R node 1
0.0.0.0
8123
9000
users.xml
/var/lib/clickhouse/access/
/clickhouse/task_queue/ddl
true
clickhouse-01
9000
clickhouse-02
9000
clickhouse-keeper-01
9181
clickhouse-keeper-02
9181
clickhouse-keeper-03
9181
cluster_1S_2R
```

| Directory                                                 | File                                                                                                                                                                              |
|-----------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `fs/volumes/clickhouse-01/etc/clickhouse-server/config.d` | [`config.xml`](https://github.com/ClickHouse/examples/blob/main/docker-compose-recipes/recipes/cluster_1S_2R/fs/volumes/clickhouse-01/etc/clickhouse-server/config.d/config.xml)  |
| `fs/volumes/clickhouse-02/etc/clickhouse-server/config.d` | [`config.xml`](https://github.com/ClickHouse/examples/blob/main/docker-compose-recipes/recipes/cluster_1S_2R/fs/volumes/clickhouse-02/etc/clickhouse-server/config.d/config.xml)  |

Each section of the above configuration file is explained in more detail below.

#### Networking and logging {#networking}

Logging is defined in the `` block. This example configuration gives you a debug log that will roll over at 1000M three times:

```xml
debug
/var/log/clickhouse-server/clickhouse-server.log
/var/log/clickhouse-server/clickhouse-server.err.log
1000M
```

For more information on logging configuration, see the comments included in the default ClickHouse [configuration file](https://github.com/ClickHouse/ClickHouse/blob/master/programs/server/config.xml).

#### Cluster configuration {#cluster-configuration}

Configuration for the cluster is set up in the `` block.
Here the cluster name `cluster_1S_2R` is defined.

The `` block defines the layout of the cluster, using the `` and `` settings, and acts as a template for distributed DDL queries, which are queries that execute across the cluster using the `ON CLUSTER` clause. By default, distributed DDL queries are allowed, but can also be turned off with setting `allow_distributed_ddl_queries`.

`internal_replication` is set to true so that data is written to just one of the replicas.

```xml
false -->
true
clickhouse-01
9000
clickhouse-02
9000
```

#### Keeper configuration {#keeper-config-explanation}

The `` section tells ClickHouse where ClickHouse Keeper (or ZooKeeper) is running.
As we're using a ClickHouse Keeper cluster, each `` of the cluster needs to be specified, along with its hostname and port number using the `` and `` tags respectively.

Set up of ClickHouse Keeper is explained in the next step of the tutorial.

```xml
clickhouse-keeper-01
9181
clickhouse-keeper-02
9181
clickhouse-keeper-03
9181
```

#### Macros configuration {#macros-config-explanation}

Additionally, the `` section is used to define parameter substitutions for replicated tables. These are listed in `system.macros` and allow using substitutions like `{shard}` and `{replica}` in queries.

```xml
cluster_1S_2R
```

### User configuration {#user-config}

Now modify each empty configuration file `users.xml` located at `fs/volumes/clickhouse-{}/etc/clickhouse-server/users.d` with the following:

```xml title="/users.d/users.xml"
10000000000
in_order
default
::/0
default
3600
```

| Directory                                                 | File                                                                                                                                                                             |
|-----------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `fs/volumes/clickhouse-01/etc/clickhouse-server/users.d`  | [`users.xml`](https://github.com/ClickHouse/examples/blob/main/docker-compose-recipes/recipes/cluster_1S_2R/fs/volumes/clickhouse-01/etc/clickhouse-server/users.d/users.xml)    |
| `fs/volumes/clickhouse-02/etc/clickhouse-server/users.d`  | [`users.xml`](https://github.com/ClickHouse/examples/blob/main/docker-compose-recipes/recipes/cluster_1S_2R/fs/volumes/clickhouse-02/etc/clickhouse-server/users.d/users.xml)    |

In this example, the default user is configured without a password for simplicity.
In practice, this is discouraged.

### Keeper setup {#configuration-explanation}

| Directory                                                        | File                                                                                                                                                                                         |
|------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `fs/volumes/clickhouse-keeper-01/etc/clickhouse-keeper` | [`keeper_config.xml`](https://github.com/ClickHouse/examples/blob/main/docker-compose-recipes/recipes/cluster_1S_2R/fs/volumes/clickhouse-keeper-01/etc/clickhouse-keeper/keeper_config.xml) |
| `fs/volumes/clickhouse-keeper-02/etc/clickhouse-keeper` | [`keeper_config.xml`](https://github.com/ClickHouse/examples/blob/main/docker-compose-recipes/recipes/cluster_1S_2R/fs/volumes/clickhouse-keeper-02/etc/clickhouse-keeper/keeper_config.xml) |
| `fs/volumes/clickhouse-keeper-03/etc/clickhouse-keeper` | [`keeper_config.xml`](https://github.com/ClickHouse/examples/blob/main/docker-compose-recipes/recipes/cluster_1S_2R/fs/volumes/clickhouse-keeper-03/etc/clickhouse-keeper/keeper_config.xml) |

Make sure that docker is running on your machine.
Start the cluster using the `docker-compose up` command from the root of the `cluster_1S_2R` directory:

```bash
docker-compose up -d
```

You should see docker begin to pull the ClickHouse and Keeper images, and then start the containers:

```bash
[+] Running 6/6
 ✔ Network cluster_1s_2r_default   Created
 ✔ Container clickhouse-keeper-03  Started
 ✔ Container clickhouse-keeper-02  Started
 ✔ Container clickhouse-keeper-01  Started
 ✔ Container clickhouse-01         Started
 ✔ Container clickhouse-02         Started
```

To verify that the cluster is running, connect to either `clickhouse-01` or `clickhouse-02` and run the following query. The command to connect to the first node is shown:

```bash
# Connect to any node
docker exec -it clickhouse-01 clickhouse-client
```

If successful, you will see the ClickHouse client prompt:

```response
cluster_1S_2R node 1 :)
```

Run the following query to check what cluster topologies are defined for which hosts:

```sql title="Query"
SELECT
    cluster,
    shard_num,
    replica_num,
    host_name,
    port
FROM system.clusters;
```

```response title="Response"
   ┌─cluster───────┬─shard_num─┬─replica_num─┬─host_name─────┬─port─┐
1. │ cluster_1S_2R │         1 │           1 │ clickhouse-01 │ 9000 │
2. │ cluster_1S_2R │         1 │           2 │ clickhouse-02 │ 9000 │
3. │ default       │         1 │           1 │ localhost     │ 9000 │
   └───────────────┴───────────┴─────────────┴───────────────┴──────┘
```

Run the following query to check the status of the ClickHouse Keeper cluster:

```sql title="Query"
SELECT *
FROM system.zookeeper
WHERE path IN ('/', '/clickhouse')
```

```response title="Response"
   ┌─name───────┬─value─┬─path────────┐
1. │ sessions   │       │ /clickhouse │
2. │ task_queue │       │ /clickhouse │
3. │ keeper     │       │ /           │
4. │ clickhouse │       │ /           │
   └────────────┴───────┴─────────────┘
```

With this, you have successfully set up a ClickHouse cluster with a single shard and two replicas.
In the next step, you will create a table in the cluster.

Now that you have verified the cluster is correctly setup and is running, you will be recreating the same table as the one used in the [UK property prices](/get-started/sample-datasets/uk-price-paid) example dataset tutorial. It consists of around 30 million rows of prices paid for real-estate property in England and Wales since 1995.

Connect to the client of each host by running each of the following commands from separate terminal tabs or windows:

```bash
docker exec -it clickhouse-01 clickhouse-client
docker exec -it clickhouse-02 clickhouse-client
```

You can run the query below from clickhouse-client of each host to confirm that there are no databases created yet, apart from the default ones:

```sql title="Query"
SHOW DATABASES;
```

```response title="Response"
   ┌─name───────────────┐
1. │ INFORMATION_SCHEMA │
2. │ default            │
3. │ information_schema │
4. │ system             │
   └────────────────────┘
```

From the `clickhouse-01` client run the following **distributed** DDL query using the `ON CLUSTER` clause to create a new database called `uk`:

```sql highlight={2}
CREATE DATABASE IF NOT EXISTS uk
ON CLUSTER cluster_1S_2R;
```

You can again run the same query as before from the client of each host to confirm that the database has been created across the cluster despite running the query only `clickhouse-01`:

```sql
SHOW DATABASES;
```

```response highlight={6}
   ┌─name───────────────┐
1. │ INFORMATION_SCHEMA │
2. │ default            │
3. │ information_schema │
4. │ system             │
5. │ uk                 │
   └────────────────────┘
```

Now that the database has been created, create a table on the cluster.
Run the following query from any of the host clients:

```sql highlight={2,19}
CREATE TABLE IF NOT EXISTS uk.uk_price_paid_local
ON CLUSTER cluster_1S_2R
(
    price UInt32,
    date Date,
    postcode1 LowCardinality(String),
    postcode2 LowCardinality(String),
    type Enum8('terraced' = 1, 'semi-detached' = 2, 'detached' = 3, 'flat' = 4, 'other' = 0),
    is_new UInt8,
    duration Enum8('freehold' = 1, 'leasehold' = 2, 'unknown' = 0),
    addr1 String,
    addr2 String,
    street LowCardinality(String),
    locality LowCardinality(String),
    town LowCardinality(String),
    district LowCardinality(String),
    county LowCardinality(String)
)
ENGINE = ReplicatedMergeTree
ORDER BY (postcode1, postcode2, addr1, addr2);
```

Notice that it is identical to the query used in the original `CREATE` statement of the [UK property prices](/get-started/sample-datasets/uk-price-paid) example dataset tutorial, except for the `ON CLUSTER` clause and use of the `ReplicatedMergeTree` engine.

The `ON CLUSTER` clause is designed for distributed execution of DDL (Data Definition Language) queries such as `CREATE`, `DROP`, `ALTER`, and `RENAME`, ensuring that these schema changes are applied across all nodes in a cluster.

The [`ReplicatedMergeTree`](/reference/engines/table-engines/mergetree-family/replication#converting-from-mergetree-to-replicatedmergetree) engine works just as the ordinary `MergeTree` table engine, but it will also replicate the data.

You can run the query below from either `clickhouse-01` or `clickhouse-02` client to confirm that the table has been created across the cluster:

```sql title="Query"
SHOW TABLES IN uk;
```

```response title="Response"
   ┌─name────────────────┐
1. │ uk_price_paid.      │
   └─────────────────────┘
```

As the data set is large and takes a few minutes to completely ingest, we will insert only a small subset to begin with.

Insert a smaller subset of the data using the query below from `clickhouse-01`:

```sql
INSERT INTO uk.uk_price_paid_local
SELECT
    toUInt32(price_string) AS price,
    parseDateTimeBestEffortUS(time) AS date,
    splitByChar(' ', postcode)[1] AS postcode1,
    splitByChar(' ', postcode)[2] AS postcode2,
    transform(a, ['T', 'S', 'D', 'F', 'O'], ['terraced', 'semi-detached', 'detached', 'flat', 'other']) AS type,
    b = 'Y' AS is_new,
    transform(c, ['F', 'L', 'U'], ['freehold', 'leasehold', 'unknown']) AS duration,
    addr1,
    addr2,
    street,
    locality,
    town,
    district,
    county
FROM url(
    'http://prod1.publicdata.landregistry.gov.uk.s3-website-eu-west-1.amazonaws.com/pp-complete.csv',
    'CSV',
    'uuid_string String,
    price_string String,
    time String,
    postcode String,
    a String,
    b String,
    c String,
    addr1 String,
    addr2 String,
    street String,
    locality String,
    town String,
    district String,
    county String,
    d String,
    e String'
) LIMIT 10000
SETTINGS max_http_get_redirects=10;
```

Notice that the data is completely replicated on each host:

```sql
-- clickhouse-01
SELECT count(*)
FROM uk.uk_price_paid_local

--   ┌─count()─┐
-- 1.│   10000 │
--   └─────────┘

-- clickhouse-02
SELECT count(*)
FROM uk.uk_price_paid_local

--   ┌─count()─┐
-- 1.│   10000 │
--   └─────────┘
```

To demonstrate what happens when one of the hosts fails, create a simple test database and test table from either of the hosts:

```sql
CREATE DATABASE IF NOT EXISTS test ON CLUSTER cluster_1S_2R;
CREATE TABLE test.test_table ON CLUSTER cluster_1S_2R
(
    `id` UInt64,
    `name` String
)
ENGINE = ReplicatedMergeTree
ORDER BY id;
```

As with the `uk_price_paid` table, we can insert data from either host:

```sql
INSERT INTO test.test_table (id, name) VALUES (1, 'Clicky McClickface');
```

But what will happen if one of the hosts is down? To simulate this, stop `clickhouse-01` by running:

```bash
docker stop clickhouse-01
```

Check that the host is down by running:

```bash
docker-compose ps
```

```response title="Response"
NAME                   IMAGE                                        COMMAND            SERVICE                CREATED          STATUS          PORTS
clickhouse-02          clickhouse/clickhouse-server:latest          "/entrypoint.sh"   clickhouse-02          X minutes ago    Up X minutes    127.0.0.1:8124->8123/tcp, 127.0.0.1:9001->9000/tcp
clickhouse-keeper-01   clickhouse/clickhouse-keeper:latest-alpine   "/entrypoint.sh"   clickhouse-keeper-01   X minutes ago    Up X minutes    127.0.0.1:9181->9181/tcp
clickhouse-keeper-02   clickhouse/clickhouse-keeper:latest-alpine   "/entrypoint.sh"   clickhouse-keeper-02   X minutes ago    Up X minutes    127.0.0.1:9182->9181/tcp
clickhouse-keeper-03   clickhouse/clickhouse-keeper:latest-alpine   "/entrypoint.sh"   clickhouse-keeper-03   X minutes ago    Up X minutes    127.0.0.1:9183->9181/tcp
```

With `clickhouse-01` now down, insert another row of data into the test table and query the table:

```sql
INSERT INTO test.test_table (id, name) VALUES (2, 'Alexey Milovidov');
SELECT * FROM test.test_table;
```

```response title="Response"
   ┌─id─┬─name───────────────┐
1. │  1 │ Clicky McClickface │
2. │  2 │ Alexey Milovidov   │
   └────┴────────────────────┘
```

Now restart `clickhouse-01` with the following command (you can run `docker-compose ps` again after to confirm):

```sql
docker start clickhouse-01
```

Query the test table again from `clickhouse-01` after running `docker exec -it clickhouse-01 clickhouse-client`:

```sql title="Query"
SELECT * FROM test.test_table
```

```response title="Response"
   ┌─id─┬─name───────────────┐
1. │  1 │ Clicky McClickface │
2. │  2 │ Alexey Milovidov   │
   └────┴────────────────────┘
```

If at this stage you would like to ingest the full UK property price dataset to play around with, you can run the following queries to do so:

```sql
TRUNCATE TABLE uk.uk_price_paid_local ON CLUSTER cluster_1S_2R;
INSERT INTO uk.uk_price_paid_local
SELECT
    toUInt32(price_string) AS price,
    parseDateTimeBestEffortUS(time) AS date,
    splitByChar(' ', postcode)[1] AS postcode1,
    splitByChar(' ', postcode)[2] AS postcode2,
    transform(a, ['T', 'S', 'D', 'F', 'O'], ['terraced', 'semi-detached', 'detached', 'flat', 'other']) AS type,
    b = 'Y' AS is_new,
    transform(c, ['F', 'L', 'U'], ['freehold', 'leasehold', 'unknown']) AS duration,
    addr1,
    addr2,
    street,
    locality,
    town,
    district,
    county
FROM url(
    'http://prod1.publicdata.landregistry.gov.uk.s3-website-eu-west-1.amazonaws.com/pp-complete.csv',
    'CSV',
    'uuid_string String,
    price_string String,
    time String,
    postcode String,
    a String,
    b String,
    c String,
    addr1 String,
    addr2 String,
    street String,
    locality String,
    town String,
    district String,
    county String,
    d String,
    e String'
    ) SETTINGS max_http_get_redirects=10;
```

Query the table from `clickhouse-02` or `clickhouse-01`:

```sql title="Query"
SELECT count(*) FROM uk.uk_price_paid_local;
```

```response title="Response"
   ┌──count()─┐
1. │ 30212555 │ -- 30.21 million
   └──────────┘
```

## Conclusion {#conclusion}

The advantage of this cluster topology is that with two replicas, your data exists on two separate hosts. If one host fails, the other replica continues serving data without any loss. This eliminates single points of failure at the storage level.

When one host goes down, the remaining replica is still able to:
- Handle read queries without interruption
- Accept new writes (depending on your consistency settings)
- Maintain service availability for applications

When the failed host comes back online, it is able to:
- Automatically sync missing data from the healthy replica
- Resume normal operations without manual intervention
- Restore full redundancy quickly

In the next example, we'll look at how to set up a cluster with two shards but only one replica.
