# 子事务并发回滚流程优化

## 可获得性

本特性自openGauss 5.1.0版本开始引入。

## 特性简介

本特性利用ProcArrayGroup数据结构管理所有抢占ProcArrayLock锁失败的backends，由第一个进入group的backend作为group leader负责请求ProcArrayLock锁，并在获取到锁后清理group中所有backend的事务信息。避免子事务并发回滚时，各backend互相争抢ProcArrayLock，导致事务被阻塞的问题。

## 客户价值

优化大量包含子事务的业务并发提交、回滚时，对ProcArrayLock锁的争抢问题，提高该场景下的事务并发能力。

## 特性描述

在子事务回滚场景，每个子事务回滚时都会清理PGPROC中的子事务列表等事务信息，并更新lastCompleteXid，在此期间需要申请ProcArrayLock用于保护ProcArray。如果一个事务内包括多个子事务，在回滚事务时，会串行回滚每个子事务，每次回滚都需要请求ProcArrayLock，此外事务提交或回滚同样需要请求ProcArrayLock锁。因此在大量子事务并发提交、回滚时，backends对ProcArrayLock的争抢会较为明显，进而可能导致事务的提交和回滚被阻塞。
针对该问题，本特性利用ProcArrayGroup数据结构管理所有抢占ProcArrayLock锁失败的backends，由第一个进入group的backend作为group leader负责请求ProcArrayLock锁，并在获取到锁后清理group中所有backend的事务信息，避免各backend之间互相争抢ProcArrayLock，提高子事务回滚效率。

## 特性增强

优化子事务并发回滚时，对ProcArrayLock锁的争抢问题。

## 特性约束

无。

## 依赖关系

本特性依赖于已有的事务结束和子事务回滚流程。
