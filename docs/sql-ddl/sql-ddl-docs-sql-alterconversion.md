# PostgreSQL: Documentation: 18: ALTER CONVERSION

PostgreSQL: Documentation: 18: ALTER CONVERSION Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
/
8.0
/
7.4
ALTER CONVERSION Prev Up SQL Commands Home Next ALTER CONVERSION ALTER CONVERSION — change the definition of a conversion Synopsis ALTER CONVERSION name RENAME TO new_name ALTER CONVERSION name OWNER TO { new_owner | CURRENT_ROLE | CURRENT_USER | SESSION_USER } ALTER CONVERSION name SET SCHEMA new_schema Description ALTER CONVERSION changes the definition of a conversion.
You must own the conversion to use ALTER CONVERSION. To alter the owner, you must be able to SET ROLE to the new owning role, and that role must have CREATE privilege on the conversion's schema. (These restrictions enforce that altering the owner doesn't do anything you couldn't do by dropping and recreating the conversion. However, a superuser can alter ownership of any conversion anyway.) Parameters name The name (optionally schema-qualified) of an existing conversion.
new_name The new name of the conversion.
new_owner The new owner of the conversion.
new_schema The new schema for the conversion.
Examples To rename the conversion iso_8859_1_to_utf8 to latin1_to_unicode:
ALTER CONVERSION iso_8859_1_to_utf8 RENAME TO latin1_to_unicode;
To change the owner of the conversion iso_8859_1_to_utf8 to joe:
ALTER CONVERSION iso_8859_1_to_utf8 OWNER TO joe;
Compatibility There is no ALTER CONVERSION statement in the SQL standard.
See AlsoCREATE CONVERSION, DROP CONVERSION Prev Up Next ALTER COLLATION Home ALTER DATABASE Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
