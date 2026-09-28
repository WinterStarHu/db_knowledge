# PostgreSQL: Documentation: 18: 19.18. Short Options

PostgreSQL: Documentation: 18: 19.18. Short Options Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
19.18. Short Options
Prev Up Chapter 19. Server Configuration Home Next
19.18. Short Options #
For convenience there are also single letter command-line option switches available for some parameters. They are described in Table 19.5. Some of these options exist for historical reasons, and their presence as a single-letter option does not necessarily indicate an endorsement to use the option heavily.
Table 19.5. Short Option Key Short Option Equivalent -B x shared_buffers = x -d x log_min_messages = DEBUGx -e datestyle = euro -fb, -fh, -fi, -fm, -fn, -fo, -fs, -ft enable_bitmapscan = off, enable_hashjoin = off, enable_indexscan = off, enable_mergejoin = off, enable_nestloop = off, enable_indexonlyscan = off, enable_seqscan = off, enable_tidscan = off -F fsync = off -h x listen_addresses = x -i listen_addresses = '*' -k x unix_socket_directories = x -l ssl = on -N x max_connections = x -O allow_system_table_mods = on -p x port = x -P ignore_system_indexes = on -s log_statement_stats = on -S x work_mem = x -tpa, -tpl, -te log_parser_stats = on, log_planner_stats = on, log_executor_stats = on -W x post_auth_delay = x Prev Up Next
19.17. Developer Options
Home Chapter 20. Client Authentication Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
