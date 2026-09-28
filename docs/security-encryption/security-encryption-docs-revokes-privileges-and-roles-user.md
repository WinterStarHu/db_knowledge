# Revokes of Privileges and Roles from a User

When you revoke system or object privileges, be aware of the cascading effects of revoking a privilege.
- Revokes of System Privileges and Roles The REVOKE SQL statement revokes system privileges and roles.
- Revokes of Object Privileges You can revoke multiple object privileges, object privileges on behalf of an object owner, column-selective object privileges, and the REFERENCES object privilege.
- Cascading Effects of Revoking Privileges There are no cascading effects for revoked object privileges related to DDL operations, but there are cascading effects for object privilege revocations.
## Revokes of System Privileges and Roles
The `REVOKE` SQL statement revokes system privileges and roles.
Any user with the `ADMIN` option for a system privilege or role can revoke the privilege or role from any other database user or role. The revoker does not have to be the user that originally granted the privilege or role. Users with `GRANT ANY ROLE` can revoke *any* role.
Example 4-12 revokes the `CREATE TABLE` system privilege and the `accts_rec` role from user `psmith`:
Example 4-12 Revoking a System Privilege and a Role from a User
```
REVOKE CREATE TABLE, accts_rec FROM psmith;
```
Be aware that the `ADMIN` option for a system privilege or role cannot be selectively revoked. Instead, revoke the privilege or role, and then grant the privilege or role again but without the `ADMIN` option.
## Revokes of Object Privileges
You can revoke multiple object privileges, object privileges on behalf of an object owner, column-selective object privileges, and the `REFERENCES` object privilege.
- About Revokes of Object Privileges To revoke an object privilege, you must meet the appropriate requirements.
- Revokes of Multiple Object Privileges The REVOKE statement can revoke multiple privileges on one object.
- Revokes of Object Privileges on Behalf of the Object Owner The GRANT ANY OBJECT PRIVILEGE system privilege can be used to revoke any object privilege where the object owner is the grantor.
````
- Revokes of Column-Selective Object Privileges GRANT and REVOKE operations for column-specific operations have different privileges and restrictions.
- Revokes of the REFERENCES Object Privilege When you revoke the REFERENCES object privilege, it affects foreign key constraints.
### About Revokes of Object Privileges
To revoke an object privilege, you must meet the appropriate requirements.
The requirements are either of the following conditions:
- You previously granted the object privilege to the user or role.
- You possess the GRANT ANY OBJECT PRIVILEGE system privilege that enables you to grant and revoke privileges on behalf of the object owner.
You can only revoke the privileges that you, the person who granted the privilege, directly authorized. You cannot revoke grants that were made by other users to whom you granted the `GRANT OPTION`. However, there is a cascading effect. If the object privileges of the user who granted the privilege are revoked, then the object privilege grants that were propagated using the `GRANT OPTION` are revoked as well.
### Revokes of Multiple Object Privileges
The `REVOKE` statement can revoke multiple privileges on one object.
Assuming you are the original grantor of the privilege, the following statement revokes the `SELECT` and `INSERT` privileges on the `emp` table from users `jfee` and `psmith`:
```
REVOKE SELECT, INSERT ON emp FROM jfee, psmith;
```
The following statement revokes all object privileges for the `dept` table that you originally granted to the `human_resource` role:
```
REVOKE ALL ON dept FROM human_resources;
```
**Note:**   The `GRANT OPTION` for an object privilege cannot be selectively revoked. Instead, revoke the object privilege and then grant it again but without the `GRANT OPTION`. Users cannot revoke object privileges from themselves.
### Revokes of Object Privileges on Behalf of the Object Owner
The `GRANT ANY OBJECT PRIVILEGE` system privilege can be used to revoke any object privilege where the object owner is the grantor.
This occurs when the object privilege is granted by the object owner, or on behalf of the owner by any user holding the `GRANT ANY OBJECT PRIVILEGE` system privilege.
In a situation where the object privilege was granted by both the owner of the object and the user executing the `REVOKE` statement (who has both the specific object privilege and the `GRANT ANY OBJECT PRIVILEGE` system privilege), Oracle Database only revokes the object privilege granted by the user issuing the `REVOKE` statement. This can be illustrated by continuing the example started in Grants of Object Privileges on Behalf of the Object Owner.
At this point, user `blake` granted the `SELECT` privilege on `HR.EMPLOYEES` to `clark`. Even though `blake` possesses the `GRANT ANY OBJECT PRIVILEGE` system privilege, he also holds the specific object privilege, thus this grant is attributed to him. Assume that user `HR` also grants the `SELECT` privilege on `HR.EMPLOYEES` to user `clark`. A query of the `DBA_TAB_PRIVS` view shows that the following grants are in effect for the `HR.EMPLOYEES` table:
```
GRANTEE  GRANTOR PRIVILEGE    GRANTABLE
-------- ------- -----------  ----------
BLAKE    HR       SELECT       YES CLARK    BLAKE    SELECT       NO CLARK    HR       SELECT       NO
```
User `blake` now issues the following `REVOKE` statement:
```
REVOKE  SELECT ON HR.EMPLOYEES FROM clark;
```
Only the object privilege for user `clark` granted by user `blake` is removed. The grant by the object owner, `HR`, remains.
```
GRANTEE  GRANTOR PRIVILEGE    GRANTABLE
-------- ------- -----------  ----------
BLAKE    HR       SELECT      YES CLARK    HR       SELECT      NO
```
If `blake` issues the `REVOKE` statement again, then this time the effect is to remove the object privilege granted by `adams` (on behalf of `HR`), using the `GRANT ANY OBEJCT PRIVILEGE` system privilege.
### Revokes of Column-Selective Object Privileges
`GRANT` and `REVOKE` operations for column-specific operations have different privileges and restrictions.
Although users can grant column-specific `INSERT`, `UPDATE`, and `REFERENCES` privileges for tables and views, they cannot selectively revoke column-specific privileges with a similar `REVOKE` statement. Instead, the grantor must first revoke the object privilege for all columns of a table or view, and then selectively repeat the grant of the column-specific privileges that the grantor intends to keep in effect.
For example, assume that role `human_resources` was granted the `UPDATE` privilege on the `deptno` and `dname` columns of the table `dept`. To revoke the `UPDATE` privilege on just the `deptno` column, issue the following two statements:
```
REVOKE UPDATE ON dept FROM human_resources;
GRANT UPDATE (dname) ON dept TO human_resources;
```
The `REVOKE` statement revokes the `UPDATE` privilege on all columns of the `dept` table from the role `human_resources`. The `GRANT` statement then repeats, restores, or reissues the grant of the `UPDATE` privilege on the `dname` column to the role `human_resources`.
### Revokes of the REFERENCES Object Privilege
When you revoke the `REFERENCES` object privilege, it affects foreign key constraints.
If the grantee of the `REFERENCES` object privilege has used the privilege to create a foreign key constraint (that currently exists), then the grantor can revoke the privilege only by specifying the `CASCADE CONSTRAINTS` option in the `REVOKE` statement.
For example:
```
REVOKE REFERENCES ON dept FROM jward CASCADE CONSTRAINTS;
```
Any foreign key constraints currently defined that use the revoked `REFERENCES` privilege are dropped when the `CASCADE CONSTRAINTS` clause is specified.
## Cascading Effects of Revoking Privileges
There are no cascading effects for revoked object privileges related to DDL operations, but there are cascading effects for object privilege revocations.
- Cascading Effects When Revoking System Privileges There are no cascading effects when you revoke a system privilege that is related to DDL operations.
- Cascading Effects When Revoking Object Privileges Revoking an object privilege can have cascading effects.
### Cascading Effects When Revoking System Privileges
There are no cascading effects when you revoke a system privilege that is related to DDL operations.
This applies regardless of whether the privilege was granted with or without the `ADMIN` option.
For example, assume the following:
``````
- The security administrator grants the CREATE TABLE system privilege to user jfee with the ADMIN option.
- User jfee creates a table.
``````
- User jfee grants the CREATE TABLE system privilege to user tsmith.
- User tsmith creates a table.
````
- The security administrator revokes the CREATE TABLE system privilege from user jfee.
``````
- The table created by user jfee continues to exist. User tsmith still has the table and the CREATE TABLE system privilege.
You can observe cascading effects when you revoke a system privilege related to a DML operation. If the `SELECT ANY TABLE` privilege is revoked from a user, then all procedures contained in the user’s schema relying on this privilege can no longer be executed successfully until the privilege is reauthorized.
### Cascading Effects When Revoking Object Privileges
Revoking an object privilege can have cascading effects.
Note the following:
****``````````
- Object definitions that depend on a DML object privilege can be affected if the DML object privilege is revoked. For example, assume that the body of the test procedure includes a SQL statement that queries data from the emp table. If the SELECT privilege on the emp table is revoked from the owner of the test procedure, then the procedure can no longer be executed successfully.
****``````````````````````````
- When a REFERENCES privilege for a table is revoked from a user, any foreign key integrity constraints that are defined by the user and require the dropped REFERENCES privilege are automatically dropped. For example, assume that user jward is granted the REFERENCES privilege for the deptno column of the dept table. This user now creates a foreign key on the deptno column in the emp table that references the deptno column of the dept table. If the REFERENCES privilege on the deptno column of the dept table is revoked, then the foreign key constraint on the deptno column of the emp table is dropped in the same operation.
****````````````````````````````
- The object privilege grants propagated using the GRANT OPTION are revoked if the object privilege of a grantor is revoked. For example, assume that user1 is granted the SELECT object privilege on the emp table with the GRANT OPTION, and grants the SELECT privilege on emp to user2. Subsequently, the SELECT privilege is revoked from user1. This REVOKE statement is also cascaded to user2. Any objects that depend on the revoked SELECT privilege of user1 and user2 can also be affected, as described earlier.
Object definitions that require the `ALTER` and `INDEX DDL` object privileges are not affected if the `ALTER` or `INDEX` object privilege is revoked. For example, if the `INDEX` privilege is revoked from a user that created an index on a table that belongs to another user, then the index continues to exist after the privilege is revoked.
## Related Topics
  - Grants of Object Privileges on Behalf of the Object Owner
