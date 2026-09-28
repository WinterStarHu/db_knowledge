# PostgreSQL: Documentation: 18: 28.6. WAL Internals

PostgreSQL: Documentation: 18: 28.6. WAL Internals Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
28.6. WAL Internals
Prev Up Chapter 28. Reliability and the Write-Ahead Log Home Next
28.6. WAL Internals #
WAL is automatically enabled; no action is required from the administrator except ensuring that the disk-space requirements for the WAL files are met, and that any necessary tuning is done (see Section 28.5).
WAL records are appended to the WAL files as each new record is written. The insert position is described by a Log Sequence Number (LSN) that is a byte offset into the WAL, increasing monotonically with each new record. LSN values are returned as the datatype pg_lsn. Values can be compared to calculate the volume of WAL data that separates them, so they are used to measure the progress of replication and recovery.
WAL files are stored in the directory pg_wal under the data directory, as a set of segment files, normally each 16 MB in size (but the size can be changed by altering the --wal-segsize initdb option). Each segment is divided into pages, normally 8 kB each (this size can be changed via the --with-wal-blocksize configure option). The WAL record headers are described in access/xlogrecord.h; the record content is dependent on the type of event that is being logged. Segment files are given ever-increasing numbers as names, starting at 000000010000000000000001. The numbers do not wrap, but it will take a very, very long time to exhaust the available stock of numbers.
It is advantageous if the WAL is located on a different disk from the main database files. This can be achieved by moving the pg_wal directory to another location (while the server is shut down, of course) and creating a symbolic link from the original location in the main data directory to the new location.
The aim of WAL is to ensure that the log is written before database records are altered, but this can be subverted by disk drives that falsely report a successful write to the kernel, when in fact they have only cached the data and not yet stored it on the disk. A power failure in such a situation might lead to irrecoverable data corruption. Administrators should try to ensure that disks holding PostgreSQL's WAL files do not make such false reports. (See Section 28.1.) After a checkpoint has been made and the WAL flushed, the checkpoint's position is saved in the file pg_control. Therefore, at the start of recovery, the server first reads pg_control and then the checkpoint record; then it performs the REDO operation by scanning forward from the WAL location indicated in the checkpoint record. Because the entire content of data pages is saved in the WAL on the first page modification after a checkpoint (assuming full_page_writes is not disabled), all pages changed since the checkpoint will be restored to a consistent state.
To deal with the case where pg_control is corrupt, we should support the possibility of scanning existing WAL segments in reverse order — newest to oldest — in order to find the latest checkpoint. This has not been implemented yet. pg_control is small enough (less than one disk page) that it is not subject to partial-write problems, and as of this writing there have been no reports of database failures due solely to the inability to read pg_control itself. So while it is theoretically a weak spot, pg_control does not seem to be a problem in practice.
Prev Up Next
28.5. WAL Configuration
Home Chapter 29. Logical Replication Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
