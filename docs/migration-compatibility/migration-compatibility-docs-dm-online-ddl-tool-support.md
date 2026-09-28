---
title: TiDB Data Migration 对 online DDL 工具的支持
summary: 了解 DM 对常见 online DDL 工具的支持情况，使用方法和注意事项。
---

# TiDB Data Migration 对 online DDL 工具的支持

在 MySQL 生态中，gh-ost 与 pt-osc 等工具较广泛地被使用，TiDB Data Migration (DM) 对其提供了特殊的支持以避免对不必要的中间数据进行迁移。本文介绍了在 DM 中使用常见 online DDL 工具的方法和注意事项。

有关 DM 对 online DDL 工具支持的原理、处理流程等，可参考 [online-ddl](/dm/feature-online-ddl.md)。

## 使用限制

- DM 仅针对 gh-ost 与 pt-osc 做了特殊支持。
- 在开启 `online-ddl` 时，增量复制对应的 checkpoint 应不处于 online DDL 执行过程中。如上游某次 online DDL 操作开始于 binlog `position-A`、结束于 `position-B`，则增量复制的起始点应早于 `position-A` 或晚于 `position-B`，否则可能出现迁移出错，具体可参考 [FAQ](/dm/dm-faq.md#设置了-online-ddl-truegh-ost-表相关的-ddl-报错该如何处理)。

## 参数配置
