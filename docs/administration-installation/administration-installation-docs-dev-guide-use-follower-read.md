---
title: Follower Read
summary: 使用 Follower Read 在特定情况下加速查询。
aliases: ['/zh/tidb/dev/use-follower-read','/zh/tidb/stable/dev-guide-use-follower-read/','/zh/tidb/dev/dev-guide-use-follower-read/','/zh/tidbcloud/dev-guide-use-follower-read/']
---

# Follower Read

本章将介绍使用 Follower Read 在特定情况下加速查询的方法。

## 简介

在 TiDB 当中，数据是以 [Region](/tidb-storage.md#region) 为单位，分散在集群中所有的节点上进行存储的。一个 Region 可以存在多个副本，副本又分为一个 leader 和多个 follower。当 leader 上的数据发生变化时，TiDB 会将数据同步更新到 follower。

默认情况下，TiDB 只会在同一个 Region 的 leader 上读写数据。当系统中存在读取热点 Region 导致 leader 资源紧张成为整个系统读取瓶颈时，启用 Follower Read 功能可明显降低 leader 的负担，并且通过在多个 follower 之间均衡负载，显著地提升整体系统的吞吐能力。

## 何时使用

### 优化读热点

你可以通过以下可视化的方法分析你的应用程序是否存在热点 Region。

- TiDB Cloud：打开 [TiDB Cloud 控制台中的 Key Visualizer 页面](https://docs.pingcap.com/zh/tidbcloud/tune-performance/#key-visualizer)，将指标选择框选择到 `Read (bytes)` 或 `Read (keys)` 查看是否存在读取热点 Region。

- TiDB：打开 [TiDB Dashboard 中的流量可视化页面](/dashboard/dashboard-key-visualizer.md)，将指标选择框选择到 `Read (bytes)` 或 `Read (keys)` 查看是否存在读取热点 Region。

如果发现确实存在热点问题，你可以参考 [TiDB 热点问题处理](/troubleshoot-hot-spot-issues.md)文档进行排查，以便从应用程序层面上避免热点的产生。

如果读取热点的确无法避免或者改动的成本很大，你可以尝试通过 Follower Read 功能将读取请求更好地负载均衡到 follower region。

### 优化跨数据中心部署的延迟

如果 TiDB 集群是跨地区或跨数据中心部署的，一个 Region 的不同副本分布在不同的地区或数据中心，此时可以通过配置 Follower Read 为 `closest-adaptive` 或 `closest-replicas` 让 TiDB 优先从当前的数据中心执行读操作，这样可以大幅降低读操作的延迟和流量开销。具体原理可参考 [Follower Read](/follower-read.md)。

## 开启 Follower Read

## 扩展阅读

- [Follower Read](/follower-read.md)
- [TiDB 热点问题处理](/troubleshoot-hot-spot-issues.md)
- [TiDB Cloud 控制台中的 Key Visualizer 页面](https://docs.pingcap.com/zh/tidbcloud/tune-performance/#key-visualizer)
- [TiDB Dashboard 流量可视化页面](/dashboard/dashboard-key-visualizer.md)
