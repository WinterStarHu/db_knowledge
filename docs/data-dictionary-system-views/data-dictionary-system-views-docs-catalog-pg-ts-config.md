# PostgreSQL: Documentation: 18: 52.59. pg_ts_config

PostgreSQL: Documentation: 18: 52.59. pg_ts_config Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
52.59. pg_ts_config
Prev Up Chapter 52. System Catalogs Home Next
52.59. pg_ts_config #
The pg_ts_config catalog contains entries representing text search configurations. A configuration specifies a particular text search parser and a list of dictionaries to use for each of the parser's output token types. The parser is shown in the pg_ts_config entry, but the token-to-dictionary mapping is defined by subsidiary entries in pg_ts_config_map.
PostgreSQL's text search features are described at length in Chapter 12.
Table 52.59. pg_ts_config Columns Column Type Description oid oid Row identifier cfgname name Text search configuration name cfgnamespace oid (references pg_namespace.oid) The OID of the namespace that contains this configuration cfgowner oid (references pg_authid.oid) Owner of the configuration cfgparser oid (references pg_ts_parser.oid) The OID of the text search parser for this configuration Prev Up Next
52.58. pg_trigger
Home
52.60. pg_ts_config_map
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
