# PostgreSQL: Documentation: 18: 70.2. Backup Manifest File Object

PostgreSQL: Documentation: 18: 70.2. Backup Manifest File Object Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13
70.2. Backup Manifest File Object
Prev Up Chapter 70. Backup Manifest Format Home Next
70.2. Backup Manifest File Object #
The object which describes a single file contains either a Path key or an Encoded-Path key. Normally, the Path key will be present. The associated string value is the path of the file relative to the root of the backup directory. Files located in a user-defined tablespace will have paths whose first two components are pg_tblspc and the OID of the tablespace. If the path is not a string that is legal in UTF-8, or if the user requests that encoded paths be used for all files, then the Encoded-Path key will be present instead. This stores the same data, but it is encoded as a string of hexadecimal digits. Each pair of hexadecimal digits in the string represents a single octet.
The following two keys are always present:
Size The expected size of this file, as an integer.
Last-Modified The last modification time of the file as reported by the server at the time of the backup. Unlike the other fields stored in the backup, this field is not used by pg_verifybackup. It is included only for informational purposes.
If the backup was taken with file checksums enabled, the following keys will be present:
Checksum-Algorithm The checksum algorithm used to compute a checksum for this file. Currently, this will be the same for every file in the backup manifest, but this may change in future releases. At present, the supported checksum algorithms are CRC32C, SHA224, SHA256, SHA384, and SHA512.
Checksum The checksum computed for this file, stored as a series of hexadecimal characters, two for each byte of the checksum.
Prev Up Next
70.1. Backup Manifest Top-level Object
Home
70.3. Backup Manifest WAL Range Object
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
