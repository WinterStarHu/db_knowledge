---
slug: /optimize/query-optimization
sidebarTitle: 'Overview'
title: 'Query optimization'
description: 'Learn how to diagnose slow ClickHouse queries, isolate bottlenecks, and select targeted optimizations'
doc_type: 'guide'
keywords: ['query optimization', 'performance', 'best practices', 'query tuning', 'efficiency', 'query log', 'EXPLAIN']
---

These guides provide a workflow for investigating and improving slow queries in ClickHouse. Identify a recurring slow query, isolate its bottleneck, choose a targeted optimization, and compare the result with a repeatable baseline.

## Choose where to start {#choose-where-to-start}

The first three guides form an end-to-end workflow, but you can also enter at the stage that matches what you already know.

Start here when you need to identify a recurring slow-query pattern. Use local or cluster-wide query history to choose a representative run, inspect its resource usage, and form an initial hypothesis.
Start here when you have a slow query but do not yet know which operations dominate its performance. Compare progressively simpler forms of the query under controlled conditions.
Start here when you have evidence about the bottleneck and need to choose a targeted change. Compare approaches for reducing the data that is read, aligning the data layout with your queries, or precomputing repeatable work.

## Example {#example}

Start with workload queries against the NYC Taxi dataset, then apply schema and ordering-key changes, measuring each stage against the same baseline.
