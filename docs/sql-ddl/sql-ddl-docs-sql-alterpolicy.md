# PostgreSQL: Documentation: 18: ALTER POLICY

PostgreSQL: Documentation: 18: ALTER POLICY Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11 / 10 /
9.6
/
9.5
ALTER POLICY Prev Up SQL Commands Home Next ALTER POLICY ALTER POLICY — change the definition of a row-level security policy Synopsis ALTER POLICY name ON table_name RENAME TO new_name ALTER POLICY name ON table_name [ TO { role_name | PUBLIC | CURRENT_ROLE | CURRENT_USER | SESSION_USER } [, ...] ] [ USING ( using_expression ) ] [ WITH CHECK ( check_expression ) ] Description ALTER POLICY changes the definition of an existing row-level security policy. Note that ALTER POLICY only allows the set of roles to which the policy applies and the USING and WITH CHECK expressions to be modified. To change other properties of a policy, such as the command to which it applies or whether it is permissive or restrictive, the policy must be dropped and recreated.
To use ALTER POLICY, you must own the table that the policy applies to.
In the second form of ALTER POLICY, the role list, using_expression, and check_expression are replaced independently if specified. When one of those clauses is omitted, the corresponding part of the policy is unchanged.
Parameters name The name of an existing policy to alter.
table_name The name (optionally schema-qualified) of the table that the policy is on.
new_name The new name for the policy.
role_name The role(s) to which the policy applies. Multiple roles can be specified at one time. To apply the policy to all roles, use PUBLIC.
using_expression The USING expression for the policy. See CREATE POLICY for details.
check_expression The WITH CHECK expression for the policy. See CREATE POLICY for details.
Compatibility ALTER POLICY is a PostgreSQL extension.
See AlsoCREATE POLICY, DROP POLICY Prev Up Next ALTER OPERATOR FAMILY Home ALTER PROCEDURE Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
