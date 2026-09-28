# PostgreSQL: Documentation: 18: F.5. basic_archive — an example WAL archive module

PostgreSQL: Documentation: 18: F.5. basic_archive — an example WAL archive module Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 Development Versions:
19 / devel F.5. basic_archive — an example WAL archive module Prev Up Appendix F. Additional Supplied Modules and Extensions Home Next F.5. basic_archive — an example WAL archive module # F.5.1. Configuration Parameters F.5.2. Notes F.5.3. Author basic_archive is an example of an archive module. This module copies completed WAL segment files to the specified directory. This may not be especially useful, but it can serve as a starting point for developing your own archive module. For more information about archive modules, see Chapter 49.
In order to function, this module must be loaded via archive_library, and archive_mode must be enabled.
F.5.1. Configuration Parameters # basic_archive.archive_directory (string) The directory where the server should copy WAL segment files. This directory must already exist. The default is an empty string, which effectively halts WAL archiving, but if archive_mode is enabled, the server will accumulate WAL segment files in the expectation that a value will soon be provided.
These parameters must be set in postgresql.conf. Typical usage might be:
# postgresql.conf
archive_mode = 'on' archive_library = 'basic_archive' basic_archive.archive_directory = '/path/to/archive/directory' F.5.2. Notes # Server crashes may leave temporary files with the prefix archtemp in the archive directory. It is recommended to delete such files before restarting the server after a crash. It is safe to remove such files while the server is running as long as they are unrelated to any archiving still in progress, but users should use extra caution when doing so.
F.5.3. Author # Nathan Bossart Prev Up Next F.4. basebackup_to_shell — example "shell" pg_basebackup module Home F.6. bloom — bloom filter index access method Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
