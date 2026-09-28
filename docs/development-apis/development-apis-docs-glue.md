---
sidebarTitle: 'Amazon Glue'
slug: /integrations/glue
description: 'Integrate ClickHouse and Amazon Glue'
keywords: ['clickhouse', 'amazon', 'aws', 'glue', 'migrating', 'data', 'spark']
title: 'Integrating Amazon Glue with ClickHouse and Spark'
doc_type: 'guide'
integration:
  - support_level: 'core'
  - category: 'data_ingestion'
---

import { Image } from "/snippets/components/Image.jsx";

import { ClickHouseSupportedBadge } from "/snippets/components/ClickHouseSupported/ClickHouseSupported.jsx";

[Amazon Glue](https://aws.amazon.com/glue/) is a fully managed, serverless data integration service provided by Amazon Web Services (AWS). It simplifies the process of discovering, preparing, and transforming data for analytics, machine learning, and application development.

## Installation {#installation}

To integrate your Glue code with ClickHouse, you can use our official Spark connector in Glue via one of the following:
- Installing the ClickHouse Glue connector from the AWS Marketplace (recommended).
- Manually adding the Spark Connector's jars to your Glue job.

## Using AWS Secrets Manager for credentials {#secrets-manager}

Rather than hardcoding your ClickHouse user and password in the job, store them in [AWS Secrets Manager](https://docs.aws.amazon.com/secretsmanager/) and reference the secret from your Glue connection or job script. At runtime, Glue fetches the secret and merges its key-value pairs into the connector's connection options.

### Create the secret {#create-secret}

In AWS Secrets Manager, create a secret of type **Other type of secret** with key-value pairs whose keys match the connector's option names:

| Key | Value |
|---|---|
| `user` | your ClickHouse username |
| `password` | your ClickHouse password |

Any key you put in the secret is forwarded to the connector, so you can also store `host`, `database`, or any other option there if you'd like to keep them out of code.

### Reference the secret {#reference-secret}

There are two ways to wire the secret into a job.

**Option 1: attach it to the Glue connection.** When creating or editing the ClickHouse connection in Glue Studio, set the **AWS secret** field to the secret's name. Any job that uses this connection resolves the secret automatically — no code changes needed.

**Option 2: pass `secretId` in connection options.** Use this when the secret isn't attached to the connection. Add `secretId` alongside `connectionName`:

The secret's `user` and `password` keys are merged into the connector options at runtime, so you never need to read them in your script.

## Examples {#example}

The examples below use `marketplace.spark` and reference the connector by `connectionName`. If you installed the connector manually (Manual Installation tab), use `connection_type="custom.spark"` and pass `className`, `host`, `http_port`, `user`, and `password` directly in the options instead.

If you attached an AWS secret to the connection itself (Option 1 in [Using AWS Secrets Manager for credentials](#secrets-manager)), drop `secretId` from the options — Glue resolves credentials from the connection automatically.

For more details, please visit our [Spark documentation](/integrations/connectors/data-ingestion/apache-spark).
