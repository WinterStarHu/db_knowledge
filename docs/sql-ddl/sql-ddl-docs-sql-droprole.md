# PostgreSQL: Documentation: 18: DROP ROLE

PostgreSQL: Documentation: 18: DROP ROLE Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11 / 10 /
9.6
/
9.5
/
9.4
/
9.3
/
9.2
/
9.1
/
9.0
/
8.4
/
8.3
/
8.2
/
8.1
DROP ROLE Prev Up SQL Commands Home Next DROP ROLE DROP ROLE — remove a database role Synopsis DROP ROLE [ IF EXISTS ] name [, ...] Description DROP ROLE removes the specified role(s). To drop a superuser role, you must be a superuser yourself; to drop non-superuser roles, you must have CREATEROLE privilege and have been granted ADMIN OPTION on the role.
A role cannot be removed if it is still referenced in any database of the cluster; an error will be raised if so. Before dropping the role, you must drop all the objects it owns (or reassign their ownership) and revoke any privileges the role has been granted on other objects. The REASSIGN OWNED and DROP OWNED commands can be useful for this purpose; see Section 21.4 for more discussion.
However, it is not necessary to remove role memberships involving the role; DROP ROLE automatically revokes any memberships of the target role in other roles, and of other roles in the target role. The other roles are not dropped nor otherwise affected.
Parameters IF EXISTS Do not throw an error if the role does not exist. A notice is issued in this case.
name The name of the role to remove.
Notes PostgreSQL includes a program dropuser that has the same functionality as this command (in fact, it calls this command) but can be run from the command shell.
Examples To drop a role:
DROP ROLE jonathan;
Compatibility The SQL standard defines DROP ROLE, but it allows only one role to be dropped at a time, and it specifies different privilege requirements than PostgreSQL uses.
See AlsoCREATE ROLE, ALTER ROLE, SET ROLE Prev Up Next DROP PUBLICATION Home DROP ROUTINE Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
