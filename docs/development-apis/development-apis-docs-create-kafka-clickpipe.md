---
sidebarTitle: 'Create your first Kafka ClickPipe'
description: 'Step-by-step guide to creating your first Kafka ClickPipe.'
slug: /integrations/clickpipes/kafka/create-your-first-kafka-clickpipe
title: 'Creating your first Kafka ClickPipe'
doc_type: 'guide'
keywords: ['create kafka clickpipe', 'kafka', 'clickpipes', 'data sources', 'setup guide']
integration:
  - support_level: 'core'
  - category: 'clickpipes'
---

import { Image } from "/snippets/components/Image.jsx";

> In this guide, we will walk you through the process of creating your first Kafka ClickPipe.

Kafka ClickPipes can be deployed and managed manually using the ClickPipes UI, as well as programmatically using [OpenAPI](/integrations/clickpipes/programmatic-access/openapi) and [Terraform](/integrations/clickpipes/programmatic-access/terraform).

Select the `Data Sources` button on the left-side menu and click on "Set up a ClickPipe".

Select your Kafka data source from the list.

Fill out the form by providing your ClickPipe with a name, a description (optional), your credentials, and other connection details.

A valid schema is required for Avro and Protobuf topics. See [Schema registries](/integrations/clickpipes/kafka/schema-registries) for more details on how to configure a schema registry.

For Protobuf, you can instead leave **Schema registry** disabled and [upload a schema when selecting your topic](#7-select-your-topic).
Configure a Reverse Private Endpoint to allow ClickPipes to connect to your Kafka cluster using AWS PrivateLink.
See our [AWS PrivateLink documentation](/integrations/clickpipes/networking/aws-privatelink) for more information.

You can use SSH tunneling if your Kafka broker isn't publicly accessible. Instead of connecting directly, ClickPipes establishes an SSH connection to a bastion host (a server in your network that is publicly accessible) and then forwards traffic through it to your Kafka broker on your private network.

1. Enable the "SSH Tunnel" toggle.
2. Fill in the SSH connection details:
  - **SSH Host**: The hostname or IP address of your bastion host — this is the publicly accessible server that acts as a gateway into your private network.
  - **SSH Port**: The port for SSH on the bastion host (default `22`).
  - **SSH User**: The username to authenticate with on the bastion host.

3. To use Key-based authentication, click on "Revoke and regenerate key pair" to generate a new key pair and copy the generated public key to your SSH server under `~/.ssh/authorized_keys`.
4. Click on "Verify Connection" to verify the connection.

Select your topic. If you aren't using a schema registry, select your data format under **Schema format**. For `Protobuf`, upload a `.proto` file or serialized `FileDescriptorSet` (maximum 768 KiB).

The UI will then display a sample document from the topic.

In the next step, you can select whether you want to ingest data into a new ClickHouse table or reuse an existing one. Follow the instructions in the screen to modify your table name, schema, and settings. You can see a real-time preview of your changes in the sample table at the top.

You can also customize the advanced settings using the controls provided

ClickPipes will create a dedicated user for writing data into a destination table. You can select a role for this internal user using a custom role or one of the predefined role:
- `Full access`: with the full access to the cluster. It might be useful if you use Materialized View or Dictionary with the destination table.
- `Only destination table`: with the `INSERT` permissions to the destination table only.

Clicking on "Create ClickPipe" will create and run your ClickPipe. It will now be listed in the Data Sources section.
