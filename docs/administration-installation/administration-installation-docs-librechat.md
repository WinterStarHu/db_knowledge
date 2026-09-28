---
slug: /use-cases/AI/MCP/librechat
sidebarTitle: 'Integrate LibreChat'
title: 'Using ClickHouse MCP server with LibreChat'
description: 'This guide explains how to set up LibreChat with a ClickHouse MCP server using Docker.'
keywords: ['AI', 'Librechat', 'MCP']
show_related_blogs: true
doc_type: 'guide'
---

import { Image } from "/snippets/components/Image.jsx";

> This guide explains how to set up LibreChat with a ClickHouse MCP server using Docker
> and connect it to the ClickHouse example datasets.

You will need Docker to run LibreChat and the MCP server. To get Docker:
1. Visit [docker.com](https://www.docker.com/products/docker-desktop)
2. Download Docker desktop for your operating system
3. Install Docker by following the instructions for your operating system
4. Open Docker Desktop and ensure it is running
For more information, see the [Docker documentation](https://docs.docker.com/get-docker/).

Open a terminal (command prompt, terminal or PowerShell) and clone the LibreChat repository using the following command:

```bash
git clone https://github.com/danny-avila/LibreChat.git
cd LibreChat
```

Copy the example configuration file from `.env.example` to `.env`:

```bash
cp .env.example .env
```

Open the `.env` file in your favorite text editor. You will see sections for many popular LLM providers, including OpenAI, Anthropic, AWS bedrock etc, for example:

```text title=".venv" highlight={4}
#============#
# Anthropic  #
#============#
ANTHROPIC_API_KEY=user_provided
# ANTHROPIC_MODELS=claude-opus-4-20250514,claude-sonnet-4-20250514,claude-3-7-sonnet-20250219,claude-3-5-sonnet-20241022,claude-3-5-haiku-20241022,claude-3-opus-20240229,claude-3-sonnet-20240229,claude-3-haiku-20240307
# ANTHROPIC_REVERSE_PROXY=
```

Replace `user_provided` with your API key for the LLM provider you want to use.

**Using a local LLM**

If you don't have an API key you can use a local LLM like Ollama. You'll see how to do this later in step ["Install Ollama"](#add-local-llm-using-ollama). For now don't modify the .env file and continue with the next steps.

Run the following command to create a new `librechat.yaml` file:

```bash
cp librechat.example.yaml librechat.yaml
```

This creates the main [configuration file](https://www.librechat.ai/docs/configuration/librechat_yaml) for LibreChat.

Next we'll add the ClickHouse MCP server to the LibreChat Docker compose file so that the LLM can interact with the [ClickHouse SQL playground](https://sql.clickhouse.com/).

Create a file called `docker-compose.override.yml` and add the following configuration to it:

```yml title="docker-compose.override.yml"
services:
  api:
    volumes:
      - ./librechat.yaml:/app/librechat.yaml
  mcp-clickhouse:
    image: mcp/clickhouse
    container_name: mcp-clickhouse
    ports:
      - 8001:8000
    extra_hosts:
      - "host.docker.internal:host-gateway"
    environment:
      - CLICKHOUSE_HOST=sql-clickhouse.clickhouse.com
      - CLICKHOUSE_USER=demo
      - CLICKHOUSE_PASSWORD=
      - CLICKHOUSE_MCP_SERVER_TRANSPORT=sse
      - CLICKHOUSE_MCP_BIND_HOST=0.0.0.0
```

If you want to explore your own data, you can do so by using the [host, username and password](/get-started/setup/cloud#connect-with-your-app) of your own ClickHouse Cloud service.

If you don't have a Cloud account yet, get started with ClickHouse Cloud today and receive $300 in credits. At the end of your 30-day free trial, continue with a pay-as-you-go plan, or contact us to learn more about our volume-based discounts. Visit our pricing page for details.

Open `librechat.yaml` and place the following configuration at the end of the file:

```yml
mcpServers:
  clickhouse-playground:
    type: sse
    url: http://host.docker.internal:8001/sse
```

This configures LibreChat to connect to the MCP server running on Docker.

Find the following line:

```text title="librechat.yaml"
socialLogins: ['github', 'google', 'discord', 'openid', 'facebook', 'apple', 'saml']
```

For simplicity, we will remove the need to authenticate for now:

```text title="librechat.yaml"
socialLogins: []
```

### Install Ollama {#install-ollama}

Go to the [Ollama website](https://ollama.com/download) and install Ollama for your system.

Once installed, you can run a model like this:

```bash
ollama run qwen3:32b
```

This will pull the model to your local machine if it isn't present.

For a list of models see the [Ollama library](https://ollama.com/library)

### Configure Ollama in librechat.yaml {#configure-ollama-in-librechat-yaml}

Once the model has downloaded, configure it in `librechat.yaml`:

```text title="librechat.yaml"
custom:
  - name: "Ollama"
    apiKey: "ollama"
    baseURL: "http://host.docker.internal:11434/v1/"
    models:
      default:
        [
          "qwen3:32b"
        ]
      fetch: false
    titleConvo: true
    titleModel: "current_model"
    summarize: false
    summaryModel: "current_model"
    forcePrompt: false
    modelDisplayLabel: "Ollama"
```

From the root of the LibreChat project folder, run the following command to start the services:

```bash
docker compose up
```

Wait until all services are fully running.

Once all services are up and running, open your browser and go to `http://localhost:3080/`

Create a free LibreChat account if you don't yet have one, and sign in. You should now see the LibreChat interface connected to the ClickHouse MCP server, and optionally, your local LLM.

From the chat interface, select `clickhouse-playground` as your MCP server:

You can now prompt the LLM to explore the ClickHouse example datasets. Give it a go:

```text title="Prompt"
What datasets do you have access to?
```

If `use` is set to `false` in the `mcpServers` section under `interface`, the MCP selection dropdown won't appear in chat:

```yml title="librechat.yaml"
interface:
  mcpServers:
    use: true
    share: false
    create: false
    public: false
```
