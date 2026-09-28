---
slug: /use-cases/AI/MCP/janai
sidebarTitle: 'Integrate Jan.ai'
title: 'Using ClickHouse MCP server with Jan.ai'
description: 'This guide explains how to set up Jan.ai with a ClickHouse MCP server.'
keywords: ['AI', 'Jan.ai', 'MCP']
show_related_blogs: true
doc_type: 'guide'
---

import { Image } from "/snippets/components/Image.jsx";

> This guide explains how to use the ClickHouse MCP server with [Jan.ai](https://jan.ai/docs).

Jan.ai is an open source ChatGPT-alternative that runs 100% offline.
You can download Jan.ai for [Mac](https://jan.ai/docs/desktop/install/mac), [Windows](https://jan.ai/docs/desktop/windows), or [Linux](https://jan.ai/docs/desktop/linux).

It's a native app, so once it's downloaded, you can launch it.

We can enabled models via the settings menu.

To enable OpenAI, we need to provide an API key, as shown below:

At the time of writing, MCP servers are an experimental feature in Jan.ai.
We can enable them by toggling experimental features:

Once that toggle is pressed, we'll see `MCP servers` on the left menu.

If we click on the `MCP servers` menu, we'll see a list of MCP servers that we can connect to:

There servers are all disabled by default, but we can able them by clicking the toggle.

To install the ClickHouse MCP server, we need to click on the `+` icon and then populate the form with the following:

Once we've done that, we'll need to toggle the ClickHouse Server if it's not already toggled:

The ClickHouse MCP server's tools will now be visible on the chat dialog:

It's time to have a conversation about some data stored in ClickHouse!
Let's ask a question:

Jan.ai will ask confirmation before calling a tool:

It will then show us the list of tool calls that were made:

If we click on the tool call, we can see the details of the call:

And then underneath, we have our result:
