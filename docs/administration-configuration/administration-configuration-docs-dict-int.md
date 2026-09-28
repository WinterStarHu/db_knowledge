# PostgreSQL: Documentation: 18: F.12. dict_int — example full-text search dictionary for integers

PostgreSQL: Documentation: 18: F.12. dict_int — example full-text search dictionary for integers Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
F.12. dict_int — example full-text search dictionary for integers Prev Up Appendix F. Additional Supplied Modules and Extensions Home Next F.12. dict_int — example full-text search dictionary for integers # F.12.1. Configuration F.12.2. Usage dict_int is an example of an add-on dictionary template for full-text search. The motivation for this example dictionary is to control the indexing of integers (signed and unsigned), allowing such numbers to be indexed while preventing excessive growth in the number of unique words, which greatly affects the performance of searching.
This module is considered “trusted”, that is, it can be installed by non-superusers who have CREATE privilege on the current database.
F.12.1. Configuration # The dictionary accepts three options:
The maxlen parameter specifies the maximum number of digits allowed in an integer word. The default value is 6.
The rejectlong parameter specifies whether an overlength integer should be truncated or ignored. If rejectlong is false (the default), the dictionary returns the first maxlen digits of the integer. If rejectlong is true, the dictionary treats an overlength integer as a stop word, so that it will not be indexed. Note that this also means that such an integer cannot be searched for.
The absval parameter specifies whether leading “+” or “-” signs should be removed from integer words. The default is false. When true, the sign is removed before maxlen is applied.
F.12.2. Usage # Installing the dict_int extension creates a text search template intdict_template and a dictionary intdict based on it, with the default parameters. You can alter the parameters, for example mydb# ALTER TEXT SEARCH DICTIONARY intdict (MAXLEN = 4, REJECTLONG = true);
ALTER TEXT SEARCH DICTIONARY or create new dictionaries based on the template.
To test the dictionary, you can try mydb# select ts_lexize('intdict', '12345678');
ts_lexize
-----------
{123456} but real-world usage will involve including it in a text search configuration as described in Chapter 12. That might look like this:
ALTER TEXT SEARCH CONFIGURATION english ALTER MAPPING FOR int, uint WITH intdict;
Prev Up Next dblink_build_sql_update Home F.13. dict_xsyn — example synonym full-text search dictionary Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
