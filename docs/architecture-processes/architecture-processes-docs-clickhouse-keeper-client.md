---
description: 'Documentation for the ClickHouse Keeper client utility'
sidebarTitle: 'clickhouse-keeper-client'
slug: /operations/utilities/clickhouse-keeper-client
title: 'clickhouse-keeper-client utility'
doc_type: 'reference'
---

A client application to interact with clickhouse-keeper by its native protocol.

## Keys {#clickhouse-keeper-client}

-   `-q QUERY`, `--query=QUERY` — Query to execute. If this parameter is not passed, `clickhouse-keeper-client` will start in interactive mode.
-   `-h HOST`, `--host=HOST` — Server host. Default value: `localhost`.
-   `-p N`, `--port=N` — Server port. Default value: 9181
-   `-c FILE_PATH`, `--config-file=FILE_PATH` — Set path of config file to get the connection string. Default value: `config.xml`.
-   `--password=PASSWORD` — Password for authentication. Can also be set via the `CLICKHOUSE_KEEPER_PASSWORD` environment variable or in the XML config file under ``.
-   `--identity=IDENTITY` — Identity for `digest` authentication scheme. Can also be set via the `CLICKHOUSE_KEEPER_IDENTITY` environment variable or in the XML config file under ``.
-   `--connection-timeout=TIMEOUT` — Set connection timeout in seconds. Default value: 10s.
-   `--session-timeout=TIMEOUT` — Set session timeout in seconds. Default value: 10s.
-   `--operation-timeout=TIMEOUT` — Set operation timeout in seconds. Default value: 10s.
-   `--history-file=FILE_PATH` — Set path of history file. Default value: `~/.keeper-client-history`.
-   `--log-level=LEVEL` — Set log level. Default value: `information`.
-   `--no-confirmation` — If set, will not require a confirmation on several commands. Default value `false` for interactive and `true` for query
-   `--help` — Shows the help message.

## Environment Variables {#clickhouse-keeper-client-env}

-   `CLICKHOUSE_KEEPER_PASSWORD` — Used as the default password if `--password` is not provided on the command line.
-   `CLICKHOUSE_KEEPER_IDENTITY` — Used as the default identity if `--identity` is not provided on the command line.

## Authentication {#clickhouse-keeper-client-auth}

When connecting to a Keeper server that requires authentication, the password is resolved in the following priority order (first match wins):

1. `--password` command-line argument
2. `CLICKHOUSE_KEEPER_PASSWORD` environment variable
3. `` in the XML config file specified by `--config-file`

The same priority applies to `--identity` / `CLICKHOUSE_KEEPER_IDENTITY` / ``.

Example XML config file with authentication settings:

```xml
secret
localhost
9181
```

## Example {#clickhouse-keeper-client-example}

```bash
./clickhouse-keeper-client -h localhost -p 9181 --connection-timeout 30 --session-timeout 30 --operation-timeout 30
Connected to ZooKeeper at [::1]:9181 with session_id 137
/ :) ls
keeper foo bar
/ :) cd 'keeper'
/keeper :) ls
api_version
/keeper :) cd 'api_version'
/keeper/api_version :) ls

/keeper/api_version :) cd 'xyz'
Path /keeper/api_version/xyz does not exist
/keeper/api_version :) cd ../../
/ :) ls
keeper foo bar
/ :) get 'keeper/api_version'
2
```

## Commands {#clickhouse-keeper-client-commands}

-   `ls '[path]' [watch_id]` -- Lists the nodes for the given path (default: cwd). Optionally sets a children watch identified by `watch_id`
-   `cd '[path]'` -- Changes the working path (default `.`)
-   `cp '' ''`  -- Copies 'src' node to 'dest' path
-   `cpr '' ''`  -- Copies 'src' node subtree to 'dest' path
-   `mv '' ''`  -- Moves 'src' node to the 'dest' path
-   `mvr '' ''`  -- Moves 'src' node subtree to 'dest' path
-   `exists '' [watch_id]` -- Returns `1` if node exists, `0` otherwise. Optionally sets a watch identified by `watch_id`
-   `set ''  [version]` -- Updates the node's value. Only updates if version matches (default: -1)
-   `create ''  [mode]` -- Creates new node with the set value
-   `touch ''` -- Creates new node with an empty string as value. Doesn't throw an exception if the node already exists
-   `get '' [watch_id]` -- Returns the node's value. Optionally sets a data watch identified by `watch_id`
-   `watch  [timeout_seconds]` -- Waits for the watch event identified by `watch_id` and prints the event type and path. If `timeout_seconds` is specified, returns an error after the given timeout
-   `rm '' [version]` -- Removes the node only if version matches (default: -1)
-   `rmr '' [limit]` -- Recursively deletes path if the subtree size is smaller than the limit. Confirmation required (default limit = 100)
-   `flwc ` -- Executes four-letter-word command
-   `help` -- Prints this message
-   `get_direct_children_number '[path]'` -- Get numbers of direct children nodes under a specific path
-   `get_all_children_number '[path]'` -- Get all numbers of children nodes under a specific path
-   `get_stat '[path]'` -- Returns the node's stat (default `.`)
-   `find_super_nodes  '[path]'` -- Finds nodes with number of children larger than some threshold for the given path (default `.`)
-   `delete_stale_backups` -- Deletes ClickHouse nodes used for backups that are now inactive
-   `find_big_family [path] [n]` -- Returns the top n nodes with the biggest family in the subtree (default path = `.` and n = 10)
-   `sync ''` -- Synchronizes node between processes and leader
-   `reconfig  "" [version]` -- Reconfigure Keeper cluster. See /docs/en/guides/sre/keeper/clickhouse-keeper#reconfiguration
