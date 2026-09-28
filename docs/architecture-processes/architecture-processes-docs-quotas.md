---
description: 'Guide to configuring and managing resource usage quotas in ClickHouse'
sidebarTitle: 'Quotas'
slug: /operations/quotas
title: 'Quotas'
doc_type: 'guide'
---

**Quotas in ClickHouse Cloud**

Quotas are supported in ClickHouse Cloud but must be created using the [DDL syntax](/reference/statements/create/quota). The XML configuration approach documented below is **not supported**.

Quotas allow you to limit resource usage over a period of time or track the use of resources.
Quotas are set up in the user config, which is usually 'users.xml'.

The system also has a feature for limiting the complexity of a single query. See the section [Restrictions on query complexity](/concepts/features/configuration/settings/query-complexity).

In contrast to query complexity restrictions, quotas:

- Place restrictions on a set of queries that can be run over a period of time, instead of limiting a single query.
- Account for resources spent on all remote servers for distributed query processing.

Let's look at the section of the 'users.xml' file that defines quotas.

```xml
3600

```

By default, the quota tracks resource consumption for each hour, without limiting usage.
The resource consumption calculated for each interval is output to the server log after each request.

```xml
3600

1000
100
100
5000000
100
1000000000
100000000000
900

86400

10000
10000
10000
1000
5000000000
160000000000
500000000000
16000000000000
7200
```

For the 'statbox' quota, restrictions are set for every hour and for every 24 hours (86,400 seconds). The time interval is counted, starting from an implementation-defined fixed moment in time. In other words, the 24-hour interval does not necessarily begin at midnight.

When the interval ends, all collected values are cleared. For the next hour, the quota calculation starts over.

Here are the amounts that can be restricted:

`queries` – The total number of requests.

`query_selects` – The total number of select requests.

`query_inserts` – The total number of insert requests.

`errors` – The number of queries that threw an exception.

`result_rows` – The total number of rows given as a result.

`result_bytes` - The total size of rows given as a result.

`read_rows` – The total number of source rows read from tables for running the query on all remote servers.

`read_bytes` - The total size read from tables for running the query on all remote servers.

`written_bytes` - The total size of a writing operation.

`execution_time` – The total query execution time, in seconds (wall time).

`failed_sequential_authentications` - The total number of sequential authentication errors.

`queries_per_normalized_hash` – The maximum number of executions of any single normalized query. Normalized queries are queries with literals replaced by placeholders, so `SELECT 1` and `SELECT 2` are considered the same normalized query. This limit is tracked per distinct normalized query pattern independently.

If the limit is exceeded for at least one time interval, an exception is thrown with a text about which restriction was exceeded, for which interval, and when the new interval begins (when queries can be sent again).

Quotas can use the "quota key" feature to report on resources for multiple keys independently. Here is an example of this:

```xml
<!-- keyed – The quota_key "key" is passed in the query parameter,
            and the quota is tracked separately for each key value.
        For example, you can pass a username as the key,
            so the quota will be counted separately for each username.
        Using keys makes sense only if quota_key is transmitted by the program, not by a user.

        You can also write , so the IP address is used as the quota key.
        (But keep in mind that users can change the IPv6 address fairly easily.)

        Instead of  you can use , so the address
        from the X-Forwarded-For header is used as the quota key.

        For both  and  you can additionally specify
and  to group clients by subnet instead of by a
        single address: the IP address is masked to the given prefix length before being used
        as the quota key. For example, 24 shares one bucket
        across a /24 IPv4 subnet, and 64 across a /64 IPv6
        subnet. These elements can only be used together with  or
    -->
```

You can also key quotas by normalized query hash, so that each distinct query pattern gets its own independent quota bucket. In the XML configuration this is written as ``:

```xml
3600
100
```

The same can be expressed with the DDL syntax:

```sql
CREATE QUOTA my_quota KEYED BY normalized_query_hash FOR INTERVAL 1 hour MAX queries = 100 TO my_user;
```

In this example, the user can execute up to 100 instances of each distinct normalized query per hour. `SELECT number FROM numbers(1)` and `SELECT number FROM numbers(2)` share the same bucket (because they have the same normalized form), but `SELECT number, number FROM numbers(1)` uses a separate bucket.

The quota is assigned to users in the 'users' section of the config. See the section "Access rights".

For distributed query processing, the accumulated amounts are stored on the requestor server. So if the user goes to another server, the quota there will "start over".

When the server is restarted, quotas are reset.

## Related Content {#related-content}

- Blog: [Building single page applications with ClickHouse](https://clickhouse.com/blog/building-single-page-applications-with-clickhouse-and-http)
