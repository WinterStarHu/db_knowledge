---
title: 通过反向代理使用 TiDB Dashboard
aliases: ['/docs-cn/dev/dashboard/dashboard-ops-reverse-proxy/'] summary: TiDB Dashboard 可通过反向代理安全提供给外部网络。首先获取实际地址，然后配置反向代理，最后修改路径前缀。详细步骤可参考官方文档。
---

# 通过反向代理使用 TiDB Dashboard

你可以使用反向代理将 TiDB Dashboard 服务安全从内部网络提供给外部网络。

## 操作步骤

### 第 1 步：获取实际 TiDB Dashboard 地址

当集群中部署有多个 PD 实例时，其中仅有一个 PD 实例会真正运行 TiDB Dashboard，因此需要确保反向代理的上游 (Upstream) 指向了正确的地址。关于该机制的详情，可参阅 [TiDB Dashboard 多 PD 实例部署](/dashboard/dashboard-ops-deploy.md#多-pd-实例部署)章节。

使用 TiUP 部署工具时，操作命令如下（将 `CLUSTER_NAME` 替换为集群名称）：

```shell
tiup cluster display CLUSTER_NAME --dashboard
```

输出即为实际 TiDB Dashboard 地址。样例如下：

```
http://192.168.0.123:2379/dashboard/
```

> **注意：**
>
> 该功能在 TiUP Cluster v1.0.3 或更高版本部署工具中提供。
>
>

### 第 2 步：配置反向代理

## 自定义路径前缀

TiDB Dashboard 默认在 `/dashboard/` 路径下提供服务，即使是反向代理也是如此，例如 `http://example.com:8033/dashboard/`。若要配置反向代理以非默认的路径提供 TiDB Dashboard 服务，例如 `http://example.com:8033/foo/` 或 `http://example.com:8033/`，可参考以下步骤。

### 第 1 步：修改 PD 配置指定 TiDB Dashboard 服务路径前缀

修改 PD 配置中 `[dashboard]` 类别的 `public-path-prefix` 配置项，可指定服务路径前缀。该配置修改后需要重启 PD 实例生效。

以 TiUP 部署且希望运行在 `http://example.com:8033/foo/` 为例，可指定以下配置：

```yaml
server_configs:
  pd:
    dashboard.public-path-prefix: /foo
```

若希望运行在根路径（如 `http://example.com:8033/`）下，相应的配置为：

```yaml
server_configs:
  pd:
    dashboard.public-path-prefix: /
```

> **警告：**
>
> 修改自定义路径前缀生效后，直接访问将不能正常使用 TiDB Dashboard，您只能通过和路径前缀匹配的反向代理访问。

### 第 2 步：修改反向代理配置

## 下一步

参阅[提高 TiDB Dashboard 安全性](/dashboard/dashboard-ops-security.md)文档了解如何增强 TiDB Dashboard 的安全性，如配置防火墙等。
