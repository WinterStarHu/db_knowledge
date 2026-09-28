---
description: 'Guide to configuring secure SSL/TLS communication between ClickHouse
and ZooKeeper'
sidebarTitle: 'Secured Communication with Zookeeper'
slug: /operations/ssl-zookeeper
title: 'Optional secured communication between ClickHouse and Zookeeper'
doc_type: 'guide'
---

import SelfManaged from '/snippets/_self_managed_only_automated.mdx';

You should specify `ssl.keyStore.location`, `ssl.keyStore.password` and `ssl.trustStore.location`, `ssl.trustStore.password` for communication with ClickHouse client over SSL. These options are available from Zookeeper version 3.5.2.

You can add `zookeeper.crt` to trusted certificates.

```bash
sudo cp zookeeper.crt /usr/local/share/ca-certificates/zookeeper.crt
sudo update-ca-certificates
```

Client section in `config.xml` will look like:

```xml
/etc/clickhouse-server/client.crt
/etc/clickhouse-server/client.key
true
true
sslv2,sslv3
true
RejectCertificateHandler
```

Add Zookeeper to ClickHouse config with some cluster and macros:

```xml
localhost
2281
```

Start `clickhouse-server`. In logs you should see:

```text
ZooKeeper: initialized, hosts: secure://localhost:2281
```

Prefix `secure://` indicates that connection is secured by SSL.

To ensure traffic is encrypted run `tcpdump` on secured port:

```bash
tcpdump -i any dst port 2281 -nnXS
```

And query in `clickhouse-client`:

```sql
SELECT * FROM system.zookeeper WHERE path = '/';
```

On unencrypted connection you will see in `tcpdump` output something like this:

```text
..../zookeeper/quota.
```

On encrypted connection you should not see this.
