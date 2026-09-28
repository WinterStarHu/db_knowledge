---
description: 'Documentation for the ClickHouse ADBC driver'
sidebarTitle: 'ADBC driver'
slug: /interfaces/adbc
title: 'ADBC driver'
doc_type: 'reference'
---

The ClickHouse ADBC driver provides a standards-compliant [Arrow Database Connectivity (ADBC)](https://arrow.apache.org/adbc/) interface for connecting ADBC-compatible applications to ClickHouse.

The driver communicates with the ClickHouse server using the [HTTP protocol](/concepts/features/interfaces/http), which is the primary protocol supported across all ClickHouse deployments. This allows the driver to operate consistently in diverse environments, including local installations, cloud-managed services, and environments where only HTTP-based access is available.

The source code of the driver is available in the [adbc_clickhouse GitHub Repository](https://github.com/clickhouse/adbc_clickhouse).

## Installation {#installation}

You can install the latest version of the driver with [dbc](https://docs.columnar.tech/dbc/):

```bash
dbc install clickhouse
```

Alternatively, you can download it manually from [github.com/adbc-drivers/clickhouse/releases](https://github.com/adbc-drivers/clickhouse/releases).

## Database options {#database-options}

The database options below are used to establish a connection with the ClickHouse ADBC driver.

- `uri`: Specifies the full HTTP(S) endpoint of the ClickHouse server. This includes the protocol, host, and port.
- `username`: The username used for authentication with the ClickHouse server.
- `password`: The password associated with the specified username.
