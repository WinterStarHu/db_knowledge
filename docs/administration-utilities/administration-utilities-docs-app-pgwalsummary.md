# PostgreSQL: Documentation: 18: pg_walsummary

PostgreSQL: Documentation: 18: pg_walsummary Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 Development Versions:
19 / devel pg_walsummary Prev Up PostgreSQL Server Applications Home Next pg_walsummary pg_walsummary — print contents of WAL summary files Synopsis pg_walsummary [option...] [file...] Description pg_walsummary is used to print the contents of WAL summary files. These binary files are found in the pg_wal/summaries subdirectory of the data directory, and can be converted to text using this tool. This is not ordinarily necessary, since WAL summary files primarily exist to support incremental backup, but it may be useful for debugging purposes.
A WAL summary file is indexed by tablespace OID, relation OID, and relation fork. For each relation fork, it stores the list of blocks that were modified by WAL within the range summarized in the file. It can also store a "limit block," which is 0 if the relation fork was created or truncated within the relevant WAL range, and otherwise the shortest length to which the relation fork was truncated. If the relation fork was not created, deleted, or truncated within the relevant WAL range, the limit block is undefined or infinite and will not be printed by this tool.
Options -i--individual By default, pg_walsummary prints one line of output for each range of one or more consecutive modified blocks. This can make the output a lot briefer, since a relation where all blocks from 0 through 999 were modified will produce only one line of output rather than 1000 separate lines. This option requests a separate line of output for every modified block.
-q--quiet Do not print any output, except for errors. This can be useful when you want to know whether a WAL summary file can be successfully parsed but don't care about the contents.
-V--version Display version information, then exit.
-?--help Shows help about pg_walsummary command line arguments, and exits.
Environment The environment variable PG_COLOR specifies whether to use color in diagnostic messages. Possible values are always, auto and never.
See Alsopg_basebackup, pg_combinebackup Prev Up Next pg_waldump Home postgres Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
