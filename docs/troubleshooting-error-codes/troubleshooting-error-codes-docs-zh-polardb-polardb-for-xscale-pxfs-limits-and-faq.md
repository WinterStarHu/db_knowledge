# Agent文件服务PXFS限制与常见问题-云原生数据库 PolarDB(PolarDB)-阿里云帮助中心

> 来源: https://help.aliyun.com/zh/polardb/polardb-for-xscale/pxfs-limits-and-faq

Agent文件服务PXFS限制与常见问题-云原生数据库 PolarDB(PolarDB)-阿里云帮助中心

大模型产品解决方案权益定价AI 应用市场伙伴服务了解阿里云

查看 "" 全部搜索结果

AI 助理文档备案控制台

官方文档

产品简介

AI和智能体

快速入门

产品计费

动态与公告

用户指南

开发指南

SQL调优指南

技术白皮书

性能白皮书

最佳实践

分布式常见问题

安全合规

API参考

错误码

术语表

相关协议

PolarDB-X 1.0（DRDS）

PolarDB分布式轻量版

首页

云原生数据库 PolarDB

云原生数据库PolarDB分布式版

AI和智能体

Agent文件服务（PXFS）

限制与常见问题

限制与常见问题

更新时间：

复制 MD 格式

产品详情 我的收藏

本文介绍Agent文件服务（PXFS）的支持范围、常见问题及当前暂不支持的高级语义。

支持范围 PXFS的默认路径是普通文件接口，大多数应用只需要挂载、读写和继续工作。只有涉及跨主机数据库并发、历史目录树或少见POSIX高级语义时，才需要关注本页边界。

使用场景 当前状态 推荐方式

普通文件与目录读写 支持 直接使用POSIX文件接口

append、truncate、稀疏写 支持 关键结果完成后fsync

完整结果发布 支持 同目录临时文件 + rename

文件级历史 支持 /.versions//vN

微秒级工作区快照读取 支持 /.snapshot//

个人与团队空间 支持 个人根目录与授权的/.shared

Agent自动读取PXFS规则 支持 官方polardbx-filesystem Skill

SQLite memory 支持指定配置 单host、DELETE/FULL/NORMAL

跨host共享同一个mutable SQLite 暂不支持 每个可变数据库文件固定在一个NFS客户端主机

已删除路径和旧目录树的历史浏览 暂不支持 重要文件保留稳定路径 常见问题 为什么ls -a看不到.versions或.snapshot？
.versions和.snapshot是仅按路径访问（lookup-only）的虚拟入口，不保证出现在普通目录枚举中。直接访问已知路径即可： ls -la /workspace/project/.versions/file.txt cat /workspace/project/.snapshot/2026-08-29T10:30:00.123456Z/file.txt .snapshot只在挂载根目录吗？
不是。.snapshot是按目录使用的入口：要查询哪个目录里的文件，就在那个目录下使用.snapshot//。
为什么删除后的文件不能从原路径进入历史？
当前历史查询以现在仍可发现的路径为入口。通过旧文件名查找已删除路径、恢复旧目录树当前暂不支持。对需要长期回溯的重要文件，建议保留稳定路径并使用版本恢复覆盖内容。
我自己能修改官方Skill吗？
.agents/skills/polardbx-filesystem由PXFS提供并保持只读。您可以在.agents/skills下添加其他同级Skill，不会影响官方Skill。
多个Agent可以共享内容吗？
可以。每个Token首先进入自己的可见根目录；平台开通共享空间后，通过授权的/.shared目录交付团队内容。不要把Token作为共享手段。
配额不足时会怎样？
写入会返回明确错误。应用应停止继续发布，清理不再需要的业务文件，或联系平台调整配额；不要无界重试。
收到ESTALE、I/O error或网络超时怎么办？
先停止有副作用的自动重试，确认sidecar与挂载状态，再重新打开目标路径检查当前size/hash。对带幂等键的业务写入先查结果；仍无法恢复时，把时间、路径、操作类型、错误码和sidecar日志交给平台排查。
当前暂不支持的高级语义 以下高级语义当前暂不支持：

hard link

symlink

xattr

应用自定义的POSIX/NFSv4 ACL

socket、device、FIFO等特殊inode

reflink与copy_file_range快速复制语义

文件锁作为跨NFS客户端主机的全局协调机制

对mmap写入提供专门的一致性承诺

rename覆盖非空目录

业务文件或目录使用.versions、.snapshot、.pxfs等保留名称

单个UTF-8路径分量超过255字符 这些边界不影响常规文件、Agent产物和支持配置下的SQLite memory使用。

上一篇：SQLite适配下一篇：快速入门

该文章对您有帮助吗？

反馈

为什么选择阿里云什么是云计算全球基础设施技术领先稳定可靠安全合规分析师报告 大模型大模型服务平台千问大模型模型市场 产品和定价全部产品免费试用产品动态产品定价配置报价器云上成本管理 技术内容技术解决方案帮助文档开发者社区天池大赛阿里云认证 权益免费试用解决方案免费试用高校计划推荐返现计划 服务基础服务企业增值服务迁云服务官网公告健康看板信任中心 关注阿里云 关注阿里云公众号或下载阿里云APP，关注云资讯，随时随地运维管控云服务 联系我们：4008013260 法律声明Cookies 政策廉正举报安全举报联系我们加入我们 友情链接阿里巴巴集团淘宝网千问AI平台千问办公天猫全球速卖通阿里巴巴国际交易市场1688阿里妈妈飞猪阿里云计算万网高德UC友盟优酷钉钉支付宝达摩院淘宝海外阿里云盘 © 2009-现在 Aliyun.com 版权所有 增值电信业务经营许可证： 浙B2-20080101 域名注册服务机构许可： 浙D3-20210002 浙公网安备 33010602009975号浙B2-20080101-4
