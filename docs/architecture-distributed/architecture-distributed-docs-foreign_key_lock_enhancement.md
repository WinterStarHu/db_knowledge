# 外键锁增强

## 可获得性

本特性自openGauss 3.0.0版本开始引入。

## 特性简介

新增两类行锁，由share和update锁扩展到key share、share、no key update和update。非主键的更新获取的是no key update锁，外键触发器获取的行锁为key share锁，这两种类型的锁互不冲突，以此提升了外键锁的并发性。

## 客户价值

绝大多数的表更新操作为非主键的更新，该特性有效地减少了有外键约束的场景下多并发更新的阻塞，提升效率。

## 特性描述

当对父表一行元组的非主键列进行更新时，获取no key update锁；对子表对应元组的更新或插入，触发外键触发器，获取父表元组的key share锁。两者互不阻塞。

由于增加了互不冲突的行锁，多事务不再只由share锁组成，而有多种不同行锁的组合方式，依据如下的冲突表。

锁模式 key share share no key update update key share &nbsp;&nbsp;
&nbsp;&nbsp;
&nbsp;&nbsp;
share &nbsp;&nbsp;
&nbsp;&nbsp;
no key update &nbsp;&nbsp;
update

## 特性增强

无。

## 特性约束

- 对于Ustore，目前行锁仅支持share和update。

## 依赖关系

无
