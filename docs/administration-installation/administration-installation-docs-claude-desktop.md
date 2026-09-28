---
slug: /use-cases/AI/MCP/claude-desktop
sidebarTitle: 'Set up ClickHouse MCP server'
title: 'Set up the ClickHouse MCP server'
description: 'Connect the ClickHouse MCP server to Claude Code, Claude Desktop, Codex, ChatGPT, Cursor, or Windsurf.'
keywords: ['AI', 'ClickHouse', 'MCP', 'Claude', 'Codex', 'ChatGPT']
show_related_blogs: true
doc_type: 'guide'
---

The [ClickHouse MCP server](https://github.com/ClickHouse/mcp-clickhouse) lets compatible AI assistants explore databases, inspect tables, and run SQL queries against ClickHouse.
This guide configures the local `stdio` server with `uv` and connects it to a major MCP client.

The server allows read-only queries by default.
Use a dedicated ClickHouse user with only the permissions that the assistant needs, and do not use a default or administrative user.

The following walkthrough demonstrates the setup with Claude Desktop.
The same ClickHouse connection details apply to the other clients covered in this guide.

## Prerequisites {#prerequisites}

Before you begin:

1. [Install `uv`](https://docs.astral.sh/uv/getting-started/installation/).
2. Install the MCP client that you want to use.
3. Collect the hostname, username, and password for your ClickHouse service.

The examples below use these placeholder values:

| Environment variable | Value |
|---|---|
| `CLICKHOUSE_HOST` | `your-clickhouse-host` |
| `CLICKHOUSE_USER` | `your-clickhouse-user` |
| `CLICKHOUSE_PASSWORD` | `your-clickhouse-password` |

Replace them with your connection details.
For a ClickHouse Cloud service, the server uses HTTPS on port `8443` by default.
For a self-managed service using plain HTTP, also set `CLICKHOUSE_SECURE=false` and, if needed, `CLICKHOUSE_PORT=8123`.

## Configure your MCP client {#configure-mcp-client}

## Verify the connection {#verify-connection}

After the client reports that `mcp-clickhouse` is connected, ask it:

```text
List the databases available in ClickHouse, then show me the tables in one of them.
```

The client might ask you to approve the first tool calls.
Review every request before granting access.

## Troubleshooting {#troubleshooting}

If the client reports that it cannot find `uv`, replace `uv` in the command or configuration with its absolute path.
Run `which uv` on macOS or Linux, or `where uv` on Windows, to find that path.

For additional connection settings, optional chDB support, HTTP transport, and authentication, see the [`mcp-clickhouse` README](https://github.com/ClickHouse/mcp-clickhouse).
