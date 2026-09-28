# PostgreSQL: Documentation: 18: 52.62. pg_ts_parser

PostgreSQL: Documentation: 18: 52.62. pg_ts_parser Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
52.62. pg_ts_parser
Prev Up Chapter 52. System Catalogs Home Next
52.62. pg_ts_parser #
The pg_ts_parser catalog contains entries defining text search parsers. A parser is responsible for splitting input text into lexemes and assigning a token type to each lexeme. Since a parser must be implemented by C-language-level functions, creation of new parsers is restricted to database superusers.
PostgreSQL's text search features are described at length in Chapter 12.
Table 52.62. pg_ts_parser Columns Column Type Description oid oid Row identifier prsname name Text search parser name prsnamespace oid (references pg_namespace.oid) The OID of the namespace that contains this parser prsstart regproc (references pg_proc.oid) OID of the parser's startup function prstoken regproc (references pg_proc.oid) OID of the parser's next-token function prsend regproc (references pg_proc.oid) OID of the parser's shutdown function prsheadline regproc (references pg_proc.oid) OID of the parser's headline function (zero if none) prslextype regproc (references pg_proc.oid) OID of the parser's lextype function Prev Up Next
52.61. pg_ts_dict
Home
52.63. pg_ts_template
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
