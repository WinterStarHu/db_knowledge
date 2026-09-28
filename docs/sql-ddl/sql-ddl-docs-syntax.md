# 语法

默认情况下，数据库安装成功，登录后，可以使用\\help语句查看所有openGauss的SQL语法。

```
openGauss=# \help
Available help:
ABORT                             ALTER TABLE                       CREATE DATABASE                   CREATE TEXT SEARCH CONFIGURATION  DROP OPERATOR                     MERGE
  ALTER APP WORKLOAD GROUP          ALTER TABLE PARTITION             CREATE DIRECTORY                  CREATE TEXT SEARCH DICTIONARY     DROP OWNED                        MOVE
  ALTER APP WORKLOAD GROUP MAPPING  ALTER TABLESPACE                  CREATE Extension                  CREATE TRIGGER                    DROP PACKAGE                      PREPARE
  ALTER AUDIT POLICY                ALTER TEXT SEARCH CONFIGURATION   CREATE FOREIGN TABLE              CREATE TYPE                       DROP PACKAGE BODY                 PREPARE TRANSACTION
  ALTER DATA SOURCE                 ALTER TEXT SEARCH DICTIONARY      CREATE FUNCTION                   CREATE USER                       DROP PROCEDURE                    PUBLISH SNAPSHOT
  ALTER DATABASE                    ALTER TRIGGER                     CREATE GROUP                      CREATE VIEW                       DROP RESOURCE LABEL               PURGE SNAPSHOT
  ALTER DEFAULT PRIVILEGES          ALTER TYPE                        CREATE INDEX                      CREATE WEAK PASSWORD DICTIONARY   DROP RESOURCE POOL                REASSIGN OWNED
  ALTER DIRECTORY                   ALTER USER                        CREATE LANGUAGE                   CREATE WORKLOAD GROUP             DROP ROLE                         REFRESH MATERIALIZED VIEW
  ALTER Extension                   ALTER VIEW                        CREATE MASKING POLICY             CURSOR                            DROP ROW LEVEL SECURITY POLICY    REINDEX
  ALTER FOREIGN TABLE               ALTER WORKLOAD GROUP              CREATE MATERIALIZED VIEW          DEALLOCATE                        DROP SCHEMA                       RESET
  ALTER FOREIGN TABLE FOR HDFS      ANALYSE                           CREATE MODEL                      DECLARE                           DROP SEQUENCE                     REVOKE
  ALTER FUNCTION                    ANALYZE                           CREATE NODE                       DELETE                            DROP SERVER                       ROLLBACK
  ALTER GROUP                       ANONYMOUS BLOCK                   CREATE NODE GROUP                 DO                                DROP SYNONYM                      ROLLBACK PREPARED
  ALTER INDEX                       ARCHIVE SNAPSHOT                  CREATE OPERATOR                   DROP APP WORKLOAD GROUP           DROP TABLE                        SAMPLE SNAPSHOT
  ALTER LARGE OBJECT                BEGIN                             CREATE PACKAGE                    DROP APP WORKLOAD GROUP MAPPING   DROP TABLESPACE                   SAVEPOINT
  ALTER MASKING POLICY              CALL                              CREATE PACKAGE BODY               DROP AUDIT POLICY                 DROP TEXT SEARCH CONFIGURATION    SELECT
  ALTER MATERIALIZED VIEW           CHECKPOINT                        CREATE PROCEDURE                  DROP CLIENT MASTER KEY            DROP TEXT SEARCH DICTIONARY       SELECT INTO
  ALTER NODE                        CLEAN CONNECTION                  CREATE RESOURCE LABEL             DROP COLUMN ENCRYPTION KEY        DROP TRIGGER                      SET
  ALTER NODE GROUP                  CLOSE                             CREATE RESOURCE POOL              DROP DATA SOURCE                  DROP TYPE                         SET CONSTRAINTS
  ALTER OPERATOR                    CLUSTER                           CREATE ROLE                       DROP DATABASE                     DROP USER                         SET ROLE
  ALTER RESOURCE LABEL              COMMENT                           CREATE ROW LEVEL SECURITY POLICY  DROP DIRECTORY                    DROP VIEW                         SET SESSION AUTHORIZATION
  ALTER RESOURCE POOL               COMMIT                            CREATE SCHEMA                     DROP Extension                    DROP WEAK PASSWORD DICTIONARY     SET TRANSACTION
  ALTER ROLE                        COMMIT PREPARED                   CREATE SEQUENCE                   DROP FOREIGN TABLE                DROP WORKLOAD GROUP               SHOW
  ALTER ROW LEVEL SECURITY POLICY   COPY                              CREATE SERVER                     DROP FUNCTION                     END                               START TRANSACTION
  ALTER SCHEMA                      CREATE APP WORKLOAD GROUP         CREATE SNAPSHOT AS                DROP GROUP                        EXECUTE                           TRUNCATE
  ALTER SEQUENCE                    CREATE APP WORKLOAD GROUP MAPPING CREATE SNAPSHOT FROM              DROP INDEX                        EXECUTE DIRECT                    UPDATE
  ALTER SERVER                      CREATE AUDIT POLICY               CREATE SYNONYM                    DROP MASKING POLICY               EXPLAIN                           VACUUM
  ALTER SESSION                     CREATE BARRIER                    CREATE TABLE                      DROP MATERIALIZED VIEW            FETCH                             VALUES
  ALTER SYNONYM                     CREATE CLIENT MASTER KEY          CREATE TABLE AS                   DROP MODEL                        GRANT
  ALTER SYSTEM KILL SESSION         CREATE COLUMN ENCRYPTION KEY      CREATE TABLE PARTITION            DROP NODE                         INSERT
  ALTER SYSTEM SET                  CREATE DATA SOURCE                CREATE TABLESPACE                 DROP NODE GROUP                   LOCK

```

\\h name命令可以查看具体的语法信息。例如：

```
openGauss=# \h ABORT
Command:     ABORT
Description: abort the current transaction
Syntax:
ABORT [ WORK | TRANSACTION ] ;
```

## SQL语句

一个SQL语句通常包含了关键字、标识符（字段）、常量、特殊符号。例如，简单的SQL语句：

```
SELECT id, name FROM t1;
```

SELECT id, name FROM 符号类型 关键字 标识符（字段） 关键字 标识符 id和name字段 语句，用于设置条件规则等

关于SQL语法请见[附录：SQL语法](appendix_sql_syntax.md)。
