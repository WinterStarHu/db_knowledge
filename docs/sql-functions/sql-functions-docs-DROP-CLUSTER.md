# DROP CLUSTER

## Purpose
Use the `DROP` `CLUSTER` clause to remove a cluster from the database.
**Note:**   When you drop a cluster, any tables in the recycle bin that were once part of that cluster are purged from the recycle bin and can no longer be recovered with a `FLASHBACK TABLE` operation.
You cannot uncluster an individual table. Instead you must perform these steps:
- Create a new table with the same structure and contents as the old one, but with no CLUSTER clause.
- Drop the old table.
- Use the RENAME statement to give the new table the name of the old one.
****
- Grant privileges on the new unclustered table. Grants on the old clustered table do not apply. See Also: CREATE TABLE, DROP TABLE, RENAME, GRANT for information on these steps
## Prerequisites
The cluster must be in your own schema or you must have the `DROP` `ANY` `CLUSTER` system privilege.
## Syntax
## *drop_cluster*::=
Description of the illustration drop_cluster.eps
## Semantics
## IF EXISTS
Specify `IF EXISTS` to drop an existing cluster.
**Note:**   You can only use `IF EXISTS` from Release 19.28 and up.
## *schema*
Specify the schema containing the cluster. If you omit *schema*, then the database assumes the cluster is in your own schema.
## *cluster*
Specify the name of the cluster to be dropped. Dropping a cluster also drops the cluster index and returns all cluster space, including data blocks for the index, to the appropriate tablespace(s).
## INCLUDING TABLES
Specify `INCLUDING` `TABLES` to drop all tables that belong to the cluster.
**CASCADE CONSTRAINTS** Specify `CASCADE` `CONSTRAINTS` to drop all referential integrity constraints from tables outside the cluster that refer to primary and unique keys in tables of the cluster. If you omit this clause and such referential integrity constraints exist, then the database returns an error and does not drop the cluster.
## Examples
**Dropping a Cluster: Examples** The following examples drop the clusters created in the “Examples” section of `CREATE` `CLUSTER`.
The following statements drops the `language` cluster:
```
DROP CLUSTER language;
```
The following statement drops the `personnel` cluster as well as tables `dept_10` and `dept_20` and any referential integrity constraints that refer to primary or unique keys in those tables:
```
DROP CLUSTER personnel
   INCLUDING TABLES
   CASCADE CONSTRAINTS;
```
