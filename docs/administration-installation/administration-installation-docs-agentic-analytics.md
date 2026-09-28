---
title: 'Agentic analytics'
description: 'Learn how ClickHouse enables agentic analytics'
keywords: ['use cases', 'agentic analytics', 'agents']
sidebarTitle: 'Agentic analytics'
doc_type: 'guide'
---

import { Image } from "/snippets/components/Image.jsx";

AI workloads impose a consistent set of requirements regardless of use case:
- high query concurrency
- sub-second response times
- full-fidelity data at scale

This document explains how ClickHouse addresses those requirements across real-time analytics, data warehousing, and observability, and how those use cases are converging into a unified data platform for agentic applications.

## ClickHouse for agentic workloads {#agentic-workloads}

## Convergence of data warehousing and observability {#convergence-dwh-o11y}
Data warehousing and observability have historically been separate domains with separate vendors, buyers, and stacks. That separation is increasingly a convention rather than a technical requirement.
Both domains now write to object storage. Both require interactive, low-latency queries at high concurrency. And at the data level, the same events are often stored twice — once in an observability platform and once in a data warehouse — with a fragile synchronization layer in between.
Storing all of it once in open formats, queryable by both AI Analyst and AI SRE tooling, removes that duplication and makes context available across both workflows.

## The platform layer: Agent-ready interfaces and LLM observability {#platform-layer}
Two additional components are required alongside the database for a complete agentic analytics platform.

**Agent-ready interfaces**

When AI agents are the primary interface to data, the data platform needs to expose its capabilities in ways agents can consume — MCP-compatible APIs, natural language interfaces, and agent frameworks that integrate without bespoke per-use-case work. The Agentic Data Stack combines ClickHouse with LibreChat to provide a turnkey way to deploy analytics agents over your data.

**LLM observability**

As agents proliferate, tracing their execution, monitoring model performance, tracking costs, and debugging failures across multi-step workflows becomes a core engineering requirement. Langfuse runs on ClickHouse Cloud to provide real-time LLM observability at scale.
