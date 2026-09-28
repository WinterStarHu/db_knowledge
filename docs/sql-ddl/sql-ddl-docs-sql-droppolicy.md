# PostgreSQL: Documentation: 18: DROP POLICY

PostgreSQL: Documentation: 18: DROP POLICY Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11 / 10 /
9.6
/
9.5
DROP POLICY Prev Up SQL Commands Home Next DROP POLICY DROP POLICY — remove a row-level security policy from a table Synopsis DROP POLICY [ IF EXISTS ] name ON table_name [ CASCADE | RESTRICT ] Description DROP POLICY removes the specified policy from the table. Note that if the last policy is removed for a table and the table still has row-level security enabled via ALTER TABLE, then the default-deny policy will be used. ALTER TABLE ... DISABLE ROW LEVEL SECURITY can be used to disable row-level security for a table, whether policies for the table exist or not.
Parameters IF EXISTS Do not throw an error if the policy does not exist. A notice is issued in this case.
name The name of the policy to drop.
table_name The name (optionally schema-qualified) of the table that the policy is on.
CASCADERESTRICT These key words do not have any effect, since there are no dependencies on policies.
Examples To drop the policy called p1 on the table named my_table:
DROP POLICY p1 ON my_table;
Compatibility DROP POLICY is a PostgreSQL extension.
See AlsoCREATE POLICY, ALTER POLICY Prev Up Next DROP OWNED Home DROP PROCEDURE Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
