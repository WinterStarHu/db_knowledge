# postgresql-18 知识库索引

## 结构
- docs/ — 1148 个完整文档
- DB-GPT 按 Markdown 标题自动切 chunk

## 文档分类

### 配置管理(administration/configuration) — 464 个文件

- administration-configuration-docs-acronyms.md
- administration-configuration-docs-admin.md
- administration-configuration-docs-amcheck.md
- administration-configuration-docs-appendix-obsolete.md
- administration-configuration-docs-appendixes.md
- ... 共 464 个

### 安装部署(administration/installation) — 8 个文件

- administration-installation-docs-install-binaries.md
- administration-installation-docs-install-getsource.md
- administration-installation-docs-install-make.md
- administration-installation-docs-install-meson.md
- administration-installation-docs-install-post.md
- ... 共 8 个

### 管理工具(administration/utilities) — 32 个文件

- administration-utilities-docs-app-clusterdb.md
- administration-utilities-docs-app-createdb.md
- administration-utilities-docs-app-createuser.md
- administration-utilities-docs-app-dropdb.md
- administration-utilities-docs-app-dropuser.md
- ... 共 32 个

### 架构/进程(architecture/processes) — 1 个文件

- architecture-processes-docs-bgworker.md

### 复制(availability/replication) — 39 个文件

- availability-replication-docs-archive-module-callbacks.md
- availability-replication-docs-archive-module-init.md
- availability-replication-docs-archive-modules.md
- availability-replication-docs-backup-dump.md
- availability-replication-docs-backup-file.md
- ... 共 39 个

### 开发接口/驱动(development/apis) — 60 个文件

- development-apis-docs-connect-estab.md
- development-apis-docs-ecpg-commands.md
- development-apis-docs-ecpg-concept.md
- development-apis-docs-ecpg-connect.md
- development-apis-docs-ecpg-cpp.md
- ... 共 60 个

### 扩展/插件(development/extensions) — 101 个文件

- development-extensions-docs-contrib-dblink-build-sql-delete.md
- development-extensions-docs-contrib-dblink-build-sql-insert.md
- development-extensions-docs-contrib-dblink-build-sql-update.md
- development-extensions-docs-contrib-dblink-cancel-query.md
- development-extensions-docs-contrib-dblink-close.md
- ... 共 101 个

### 升级(migration/upgrade) — 8 个文件

- migration-upgrade-docs-release-18-1.md
- migration-upgrade-docs-release-18-2.md
- migration-upgrade-docs-release-18-3.md
- migration-upgrade-docs-release-18-4.md
- migration-upgrade-docs-release-18-6.md
- ... 共 8 个

### 协议(networking/protocols) — 10 个文件

- networking-protocols-docs-protocol-changes.md
- networking-protocols-docs-protocol-error-fields.md
- networking-protocols-docs-protocol-flow.md
- networking-protocols-docs-protocol-logical-replication.md
- networking-protocols-docs-protocol-logicalrep-message-formats.md
- ... 共 10 个

### 认证(security/authentication) — 18 个文件

- security-authentication-docs-auth-bsd.md
- security-authentication-docs-auth-cert.md
- security-authentication-docs-auth-delay.md
- security-authentication-docs-auth-ident.md
- security-authentication-docs-auth-ldap.md
- ... 共 18 个

### SQL DDL(数据定义)(sql/ddl) — 222 个文件

- sql-ddl-docs-arrays.md
- sql-ddl-docs-datatype-binary.md
- sql-ddl-docs-datatype-bit.md
- sql-ddl-docs-datatype-boolean.md
- sql-ddl-docs-datatype-character.md
- ... 共 222 个

### SQL DML(数据操作)(sql/dml) — 5 个文件

- sql-dml-docs-sql-delete.md
- sql-dml-docs-sql-insert.md
- sql-dml-docs-sql-merge.md
- sql-dml-docs-sql-update.md
- sql-dml-docs-sql-values.md

### SQL 函数(sql/functions) — 31 个文件

- sql-functions-docs-functions-admin.md
- sql-functions-docs-functions-aggregate.md
- sql-functions-docs-functions-array.md
- sql-functions-docs-functions-binarystring.md
- sql-functions-docs-functions-bitstring.md
- ... 共 31 个

### 存储过程/PL(sql/procedural) — 14 个文件

- sql-procedural-docs-plpgsql-control-structures.md
- sql-procedural-docs-plpgsql-cursors.md
- sql-procedural-docs-plpgsql-declarations.md
- sql-procedural-docs-plpgsql-development-tips.md
- sql-procedural-docs-plpgsql-errors-and-messages.md
- ... 共 14 个

### SQL 查询(sql/select) — 2 个文件

- sql-select-docs-sql-select.md
- sql-select-docs-sql-selectinto.md

### 索引(storage/indexes) — 36 个文件

- storage-indexes-docs-bloom.md
- storage-indexes-docs-brin.md
- storage-indexes-docs-gin.md
- storage-indexes-docs-gist.md
- storage-indexes-docs-index-api.md
- ... 共 36 个

### MVCC/并发控制(transactions/mvcc) — 9 个文件

- transactions-mvcc-docs-locking-indexes.md
- transactions-mvcc-docs-mvcc-caveats.md
- transactions-mvcc-docs-mvcc-intro.md
- transactions-mvcc-docs-mvcc-serialization-failure-handling.md
- transactions-mvcc-docs-mvcc.md
- ... 共 9 个

### 整本手册 — 88 个

- data-dictionary-system-views-docs-bki-commands.md
- data-dictionary-system-views-docs-bki-example.md
- data-dictionary-system-views-docs-bki-format.md
- data-dictionary-system-views-docs-bki-structure.md
- data-dictionary-system-views-docs-bki.md
- data-dictionary-system-views-docs-catalog-pg-aggregate.md
- data-dictionary-system-views-docs-catalog-pg-am.md
- data-dictionary-system-views-docs-catalog-pg-amop.md
- data-dictionary-system-views-docs-catalog-pg-amproc.md
- data-dictionary-system-views-docs-catalog-pg-attrdef.md
- data-dictionary-system-views-docs-catalog-pg-attribute.md
- data-dictionary-system-views-docs-catalog-pg-auth-members.md
- data-dictionary-system-views-docs-catalog-pg-authid.md
- data-dictionary-system-views-docs-catalog-pg-cast.md
- data-dictionary-system-views-docs-catalog-pg-class.md
- data-dictionary-system-views-docs-catalog-pg-collation.md
- data-dictionary-system-views-docs-catalog-pg-constraint.md
- data-dictionary-system-views-docs-catalog-pg-conversion.md
- data-dictionary-system-views-docs-catalog-pg-database.md
- data-dictionary-system-views-docs-catalog-pg-db-role-setting.md
- data-dictionary-system-views-docs-catalog-pg-default-acl.md
- data-dictionary-system-views-docs-catalog-pg-depend.md
- data-dictionary-system-views-docs-catalog-pg-description.md
- data-dictionary-system-views-docs-catalog-pg-enum.md
- data-dictionary-system-views-docs-catalog-pg-event-trigger.md
- data-dictionary-system-views-docs-catalog-pg-extension.md
- data-dictionary-system-views-docs-catalog-pg-foreign-data-wrapper.md
- data-dictionary-system-views-docs-catalog-pg-foreign-server.md
- data-dictionary-system-views-docs-catalog-pg-foreign-table.md
- data-dictionary-system-views-docs-catalog-pg-index.md
- data-dictionary-system-views-docs-catalog-pg-inherits.md
- data-dictionary-system-views-docs-catalog-pg-init-privs.md
- data-dictionary-system-views-docs-catalog-pg-language.md
- data-dictionary-system-views-docs-catalog-pg-largeobject-metadata.md
- data-dictionary-system-views-docs-catalog-pg-largeobject.md
- data-dictionary-system-views-docs-catalog-pg-namespace.md
- data-dictionary-system-views-docs-catalog-pg-opclass.md
- data-dictionary-system-views-docs-catalog-pg-operator.md
- data-dictionary-system-views-docs-catalog-pg-opfamily.md
- data-dictionary-system-views-docs-catalog-pg-parameter-acl.md
- data-dictionary-system-views-docs-catalog-pg-partitioned-table.md
- data-dictionary-system-views-docs-catalog-pg-policy.md
- data-dictionary-system-views-docs-catalog-pg-proc.md
- data-dictionary-system-views-docs-catalog-pg-publication-namespace.md
- data-dictionary-system-views-docs-catalog-pg-publication-rel.md
- data-dictionary-system-views-docs-catalog-pg-publication.md
- data-dictionary-system-views-docs-catalog-pg-range.md
- data-dictionary-system-views-docs-catalog-pg-replication-origin.md
- data-dictionary-system-views-docs-catalog-pg-rewrite.md
- data-dictionary-system-views-docs-catalog-pg-seclabel.md
- data-dictionary-system-views-docs-catalog-pg-sequence.md
- data-dictionary-system-views-docs-catalog-pg-shdepend.md
- data-dictionary-system-views-docs-catalog-pg-shdescription.md
- data-dictionary-system-views-docs-catalog-pg-shseclabel.md
- data-dictionary-system-views-docs-catalog-pg-statistic-ext-data.md
- data-dictionary-system-views-docs-catalog-pg-statistic-ext.md
- data-dictionary-system-views-docs-catalog-pg-statistic.md
- data-dictionary-system-views-docs-catalog-pg-subscription-rel.md
- data-dictionary-system-views-docs-catalog-pg-subscription.md
- data-dictionary-system-views-docs-catalog-pg-tablespace.md
- data-dictionary-system-views-docs-catalog-pg-transform.md
- data-dictionary-system-views-docs-catalog-pg-trigger.md
- data-dictionary-system-views-docs-catalog-pg-ts-config-map.md
- data-dictionary-system-views-docs-catalog-pg-ts-config.md
- data-dictionary-system-views-docs-catalog-pg-ts-dict.md
- data-dictionary-system-views-docs-catalog-pg-ts-parser.md
- data-dictionary-system-views-docs-catalog-pg-ts-template.md
- data-dictionary-system-views-docs-catalog-pg-type.md
- data-dictionary-system-views-docs-catalog-pg-user-mapping.md
- data-dictionary-system-views-docs-catalogs-overview.md
- data-dictionary-system-views-docs-catalogs.md
- data-dictionary-system-views-docs-information-schema.md
- data-dictionary-system-views-docs-views-overview.md
- data-dictionary-system-views-docs-views.md
- performance-execution-plans-docs-executor.md
- performance-execution-plans-docs-how-parallel-query-works.md
- performance-execution-plans-docs-parser-stage.md
- performance-execution-plans-docs-performance-tips.md
- performance-execution-plans-docs-planner-optimizer.md
- performance-execution-plans-docs-planner-stats-details.md
- performance-execution-plans-docs-planner-stats-security.md
- performance-execution-plans-docs-planner-stats.md
- performance-execution-plans-docs-when-can-parallel-query-be-used.md
- security-access-control-docs-sql-grant.md
- security-access-control-docs-sql-revoke.md
- troubleshooting-error-codes-docs-errcodes-appendix.md
- troubleshooting-error-codes-docs-error-message-reporting.md
- troubleshooting-error-codes-docs-error-style-guide.md

