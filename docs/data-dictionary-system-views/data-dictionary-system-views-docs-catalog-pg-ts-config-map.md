# PostgreSQL: Documentation: 18: 52.60. pg_ts_config_map

PostgreSQL: Documentation: 18: 52.60. pg_ts_config_map Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
52.60. pg_ts_config_map
Prev Up Chapter 52. System Catalogs Home Next
52.60. pg_ts_config_map #
The pg_ts_config_map catalog contains entries showing which text search dictionaries should be consulted, and in what order, for each output token type of each text search configuration's parser.
PostgreSQL's text search features are described at length in Chapter 12.
Table 52.60. pg_ts_config_map Columns Column Type Description mapcfg oid (references pg_ts_config.oid) The OID of the pg_ts_config entry owning this map entry maptokentype int4 A token type emitted by the configuration's parser mapseqno int4 Order in which to consult this entry (lower mapseqnos first) mapdict oid (references pg_ts_dict.oid) The OID of the text search dictionary to consult Prev Up Next
52.59. pg_ts_config
Home
52.61. pg_ts_dict
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
