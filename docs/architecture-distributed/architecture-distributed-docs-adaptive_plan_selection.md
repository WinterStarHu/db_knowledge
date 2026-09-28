# 自适应计划选择

## 概述

自适应计划选择作用于使用通用缓存计划进行计划执行的场景。通过使用范围线性扩张进行缓存计划探索，通过范围覆盖匹配进行计划选择。自适应计划选择弥补了传统单一缓存计划无法根据查询条件参数进行变化带来的性能问题，并且避免了频繁调用查询优化。

### 可获得性

本特性自openGauss 3.1.0版本开始引入。

### 特性简介

本特性通过触发基于基表条件选择率的计划选择，以及对于使用了部分索引和offset的查询提供缓存多计划管理和自适应选择。典型场景下能够提升数倍查询吞吐。

### 客户价值

通过本功能，用户可以通过维护多个缓存计划实现适应不同的查询参数，从而提升查询执行性能。

### 特性描述

自适应计划选择作用于使用通用缓存计划进行计划执行的场景。通过使用范围线性扩张进行缓存计划探索，通过范围覆盖匹配进行计划选择。自适应计划选择弥补了传统单一缓存计划无法根据查询条件参数进行变化带来带来的性能问题，并且避免了频繁调用查询优化。

### 特性增强

无

### 特性约束

- 数据库运行正常。
- 用户成功登录数据库。
- 用户创建数据库，数据表并导入数据。

### 依赖关系

依赖于数据库内的计划缓存功能。

## 前置条件

数据库运行正常，GUC参数"enable\_cachedplan\_mgr"为on，启动自适应计划选择功能。

## 使用指导

**现网环境下**，对存在缓存计划问题的query使用hint开启计划自适应管理能力：

```
select /*+ choose_adaptive_gplan */ * from tab where c1 = xxx；
```

JDBC客户端默认会将以上带hint的SQL转换为PBE模型，并建立查询模板。除直接修改SQL外，hint还可通过sqlpatch能力进行添加。

**gsql环境下**，可以使用手动创建查询模板的模式进行：

```
prepare test_stmt as select /*+ choose_adaptive_gplan */ * from tab where c1 = $1；
```

## 最佳实践

**多索引自适应选择支持，举例如下：**

```
create table t1(c1 int, c2 int, c3 int, c4 varchar(32), c5 text);
create index t1_idx2 on t1(c1,c2,c3,c4);
create index t1_idx1 on t1(c1,c2,c3);

insert into t1( c1, c2, c3, c4, c5) SELECT (random()*(2*10^9))::integer , (random()*(2*10^9))::integer,  (random()*(2*10^9))::integer, (random()*(2*10^9))::integer,  repeat('abc', i%10) ::text from generate_series(1,1000000) i;
insert into t1( c1, c2, c3, c4, c5) SELECT (random()*1)::integer, (random()*1)::integer, (random()*1)::integer, (random()*(2*10^9))::integer, repeat('abc', i%10) ::text from generate_series(1,1000000) i;
```

**性能对比：**

随机参数：c1\~ random\(1, 20\); c2\~ random\(1, 20\); c3\~ random\(1, 20\); c4 \~ random\(2, 10000\)

线程数50，客户端50，执行时长60s

tps gplan prepare k as select * from t1 where c1=$1 and c2=$2 and c3=$3 and c4=$4;
35126 cplan prepare k as select /*+ use_cplan */ * from t1 where c1=$1 and c2=$2 and c3=$3 and c4=$4;
75817 gplan选择 prepare k as select /*+ choose_adaptive_gplan */ * from t1 where c1=$1 and c2=$2 and c3=$3 and c4=$4;
175681

## 常见问题处理

对于过于复杂的慢查询由于特征范围限制，可能无法使用本特性正确进行计划选择，建议直接使用CPLAN进行查询计划生成。
