# 特性概览

## 高性能

CBO优化器 支持LLVM 向量化引擎 行列混合存储 自适应压缩 SQL by pass 鲲鹏NUMA架构优化 支持线程池高并发 SMP并行执行 Xlog no Lock Flush Parallel Page-based Redo For Ustore 行存转向量化 OCK加速数据传输 SCRLock加速分布式锁 子事务并发回滚流程优化 大页内存 堆表支持预读 开箱即用 用户态网络 非资源池化主备同步加速 HTAP 行列融合 自动参数化 UDF结果缓存 BLOOM索引 DPA哈希聚合加速

## 高可用

主备机 逻辑复制 逻辑备份 物理备份 gs_probackup备份增强 极致RTO 作业失败自动重试 基于Paxos协议的高可用 级联备机 延时回放 备机增加删除 延迟进入最大可用模式 并行逻辑解码 DCF 支持Global SysCache 支持备机build备机 两地三中心跨Region容灾 主备高可用能力增强 表级别并行恢复优化 异步备升主数据找回能力 RBP加速恢复 SQL防火墙能力 主库备库坏块修复功能

## 维护性

灰度升级 指定节点升级 支持WDR诊断报告 慢SQL诊断 监控告警 Session性能诊断 系统KPI辅助诊断 内置stack工具 支持SQL PATCH 冗余索引辅助诊断

## 数据库安全

访问控制模型 控制权和访问权分离 数据库认证机制 数据加密存储 数据库审计 网络通信安全 资源标签机制 统一审计机制 动态数据脱敏机制 行级访问控制 用户口令强度校验机制 全密态数据库等值查询 账本数据库机制 透明数据加密

## 资源池化

资源池化特性说明 资源池化性能优化 备机事务内透明写转发 DSS功能增强 资源池化算子卸载 资源池化主备双集群容灾 极致RTO按需回放 DSS线程池 CM SysSentry故障检测 MES灵衢内存语义通信优化 事务快照UB访问加速特性简介 资源池化多机并行 资源池化灵衢内存语义加速 资源池化可维护性增强 gs_collector适配资源池化 DMS资源统计函数 gs_probackup适配资源池化 cm支持双集群备集群switchover 资源池化支持主备参数同步 资源池化XLOG支持归档 在线reform 在线failover MES worker线程池化

## 向量数据库

向量数据库特性说明 openGauss MCP

## 企业级特性

函数及存储过程支持 支持SQL hint 全文索引 Copy接口支持容错机制 高级分析函数支持 物化视图 支持HyperLogLog 在线添加索引 自治事务 全局临时表 伪列ROWNUM 支持存储过程调试 JDBC客户端负载均衡与读写分离 In-place Update存储引擎 发布订阅 外键锁增强 支持OLTP场景数据压缩 支持特殊浮点数 事件触发器 支持UWAL特性 段页式空间回收 高级包

## 应用开发接口

支持标准SQL 支持标准开发接口 支持ograc标准开发接口 支持嵌入式SQL预处理器（ECPG） PG接口兼容 支持PL/Java MySQL兼容性增强

## AI能力

AI4DB: 数据库自治运维 DB4AI: 数据库驱动AI ABO优化器 OGAI oGMemory

## 工具链

DataKit MySQL一键式迁移 全量迁移gs_mysync 增量迁移gs_replicate(MySQL -> openGauss) 反向迁移gs_replicate(openGauss -> MySQL) 反向全量迁移(openGauss -> MySQL) PostgreSQL迁移 Oracle2OGRAC迁移工具 数据校验gs_datacheck openGauss客户端工具DataStudio 数据库安装流程解除对root用户的依赖 支持自定义ssh端口 录制回放工具 SQL语法审计工具libog_query Mysql全量迁移断点续传

## 中间件

分布式数据库能力 使用kubernetes部署分布式数据库 分布式分析能力

## 负载管理

支持底层执行层高时延逃生能力

## 高级特性

索引推荐 DB4AI 列存储 LLVM MOT 全密态数据库 DCF 并行查询 资源池化 UWAL 数据保险柜
