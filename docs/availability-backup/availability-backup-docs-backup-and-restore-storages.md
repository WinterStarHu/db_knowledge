---
title: 备份存储
summary: 了解 BR 支持的备份存储服务的 URI 格式、鉴权方案和使用方式。
aliases: ['/docs-cn/dev/br/backup-and-restore-storages/','/zh/tidb/dev/backup-storage-S3/','/zh/tidb/dev/backup-storage-azblob/','/zh/tidb/dev/backup-storage-gcs/','/zh/tidb/dev/external-storage/']
---

# 备份存储

TiDB 支持 Amazon S3、Google Cloud Storage (GCS)、Azure Blob Storage 和 NFS 作为备份恢复的存储。具体来说，可以在 `br` 的 `--storage` 或 `-s` 选项中指定备份存储的 URI。本文介绍不同外部存储服务中 [URI 的定义格式](#uri-格式)、存储过程中的[鉴权方案](#鉴权)以及[存储服务端加密](#存储服务端加密)。

## BR 向 TiKV 发送凭证

| 命令行参数 | 描述 | 默认值 |
|:----------|:-------|:-------|
| `--send-credentials-to-tikv` | 是否将 BR 获取到的权限凭证发送给 TiKV。 | `true` |

在默认情况下，使用 Amazon S3、Google Cloud Storage (GCS)、Azure Blob Storage 存储时，BR 会将凭证发送到每个 TiKV 节点，以减少设置的复杂性。该操作由参数 `--send-credentials-to-tikv`（或简写为 `-c`）控制。

但是，这个操作不适合云端环境，如果采用了 IAM Role 方式授权，那么每个节点都有自己的角色和权限。在这种情况下，你需要设置 `--send-credentials-to-tikv=false`（或简写为 `-c=0`）来禁止发送凭证：

```bash
tiup br backup full -c=0 -u pd-service:2379 --storage 's3://bucket-name/prefix'
```

使用 SQL 进行[备份](/sql-statements/sql-statement-backup.md)[恢复](/sql-statements/sql-statement-restore.md)时，可加上 `SEND_CREDENTIALS_TO_TIKV = FALSE` 选项：

```sql
BACKUP DATABASE * TO 's3://bucket-name/prefix' SEND_CREDENTIALS_TO_TIKV = FALSE;
```

## URI 格式

### 格式说明

外部存储服务的 URI 格式如下：

```shell
[scheme]://[host]/[path]?[parameters]
```

关于 URI 格式的详细信息，请参考[外部存储服务的 URI 格式](/external-storage-uri.md)。

### URI 示例

本部分示例以 `host`（上表中 `bucket name`、`container name`）为 `external` 为例进行介绍。

## 鉴权

将数据存储到云服务存储系统时，根据云服务供应商的不同，需要设置不同的鉴权参数。本部分介绍使用 Amazon S3、GCS 及 Azure Blob Storage 时所用存储服务的鉴权方式以及如何配置访问相应存储服务的账户。

## 存储服务端加密

### Amazon S3 存储服务端加密备份数据

TiDB 备份恢复功能支持对备份到 Amazon S3 的数据进行 S3 服务端加密 (SSE)。S3 服务端加密也支持使用用户自行创建的 AWS KMS 密钥，详细信息请参考 [BR S3 服务端加密](/encryption-at-rest.md#br-s3-服务端加密)。

### Azure Blob Storage 存储服务端加密备份数据

TiDB 备份恢复功能支持对备份到 Azure Blob Storage 的数据设置 Azure 服务端加密范围 (Encryption Scope) 或提供加密密钥 (Encryption Key)，为同一存储账户的不同备份数据建立安全边界。详细信息请参考 [BR Azure Blob Storage 服务端加密](/encryption-at-rest.md#br-azure-blob-storage-服务端加密)。

## 存储服务其他功能支持

Amazon [S3 对象锁定](https://docs.aws.amazon.com/zh_cn/AmazonS3/latest/userguide/object-lock.html)功能支持用户通过设置数据留存期，有效防止备份数据在指定时间内被意外或故意删除，提升了数据的安全性和完整性。从 v6.3.0 起，BR 为快照备份引入了对 Amazon S3 对象锁定功能的支持，为全量备份增加了额外的安全性保障。从 v8.0.0 起，PITR 也引入了对 Amazon S3 对象锁定功能的支持，无论是全量备份还是日志数据备份，都可以通过对象锁定功能提供更可靠的数据保护，进一步加强了数据备份和恢复的安全性，并满足了监管方面的需求。

BR 和 PITR 将自动检测 Amazon S3 对象锁定功能的开启或关闭状态，你无需进行任何额外的操作。

> **警告：**
>
> 如果在快照备份执行过程中或者 PITR 日志备份过程中，才开启了对象锁定功能，快照备份或者日志备份可能会失败。需要重新启动快照备份或者 PITR 日志备份任务来继续完成备份。
