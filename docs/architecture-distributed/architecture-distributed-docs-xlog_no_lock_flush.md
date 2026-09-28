# Xlog no Lock Flush

## 可获得性

本特性自openGauss 2.0.0 版本开始引入。

## 特性简介

取消WalInsertLock争抢及WalWriter专用磁盘写入线程。

## 客户价值

在保持原有XLog功能不变的基础上，进一步提升系统性能。

## 特性描述

对WalInsertLock进行优化，利用LSN（Log Sequence Number）及LRC（Log Record Count）记录了每个backend的拷贝进度，取消WalInsertLock机制。在backend将日志拷贝至WalBuffer时，不用对WalInsertLock进行争抢，可直接进行日志拷贝操作。并利用专用的WalWriter写日志线程，不需要backend线程自身来保证xlog的Flush。

## 特性增强

无。

## 特性约束

无。

## 依赖关系

无。
