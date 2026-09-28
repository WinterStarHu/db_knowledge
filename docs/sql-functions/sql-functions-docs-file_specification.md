# file_specification                  document.write(''); document.write('body > .noscript, body > .noscript ~ * { opacity: 0; }'); document.write('');    if (window.require === undefined) { document.write(''); document.write(''); }

# *file_specification*
## Purpose
Use one of the *file_specification* forms to specify a file as a data file or temp file, or to specify a group of one or more files as a redo log file group. If you are storing your files in Oracle Automatic Storage Management (Oracle ASM) disk groups, then you can further specify the file as a disk group file.
A *file_specification* can appear in the following statements:
````
- CREATE CONTROLFILE (see CREATE CONTROLFILE)
````
- CREATE DATABASE (see CREATE DATABASE)
````
- ALTER DATABASE (see ALTER DATABASE)
````
- CREATE TABLESPACE (see CREATE TABLESPACE)
````
- ALTER TABLESPACE (see ALTER TABLESPACE)
````
- ALTER DISKGROUP (see ALTER DISKGROUP)
## Prerequisites
You must have the privileges necessary to issue the statement in which the file specification appears.
## Syntax
## *file_specification*::=
Description of the illustration file_specification.eps
## *datafile_tempfile_spec*::=
Description of the illustration datafile_tempfile_spec.eps (*size_clause::=*)
## *redo_log_file_spec*::=
Description of the illustration redo_log_file_spec.eps (*size_clause::=*)
## *ASM_filename*::=
Description of the illustration asm_filename.eps
## *fully_qualified_file_name*::=
Description of the illustration fully_qualified_file_name.eps
## *numeric_file_name*::=
Description of the illustration numeric_file_name.eps
## *incomplete_file_name*::=
Description of the illustration incomplete_file_name.eps
## *alias_file_name*::=
Description of the illustration alias_file_name.eps
## *autoextend_clause*::=
Description of the illustration autoextend_clause.eps (*size_clause::=*)
## *maxsize_clause*::=
Description of the illustration maxsize_clause.eps (*size_clause::=*)
## Semantics
This section describes the semantics of *file_specification*. For additional information, refer to the SQL statement in which you specify a data file, temp file, redo log file, or Oracle ASM disk group or disk group file.
***datafile_tempfile_spec*** Use this clause to specify the attributes of data files and temp files if your database storage is in a file system or in Oracle ASM disk groups.
***redo_log_file_spec*** Use this clause to specify the attributes of redo log files if your database storage is in a file system or in Oracle ASM disk groups.
***filename*** Use *filename* for files stored in a file system. The *filename* can specify either a new file or an existing file. For a *new* file:
****
- If you are not using Oracle Managed Files, then you must specify both filename and the SIZE clause or the statement fails. When you specify a filename without a size, Oracle attempts to reuse an existing file and returns an error if the file does not exist.
****
  - The DB_RECOVERY_FILE_DEST (for logfiles and control files)
  - The DB_CREATE_FILE_DEST initialization parameter (for any type of file)
**````
  - The DB_CREATE_ONLINE_LOG_DEST_n initialization parameter, which takes precedence over DB_CREATE_FILE_DEST and DB_RECOVERY_FILE_DEST for log files.
For an *existing* file, specify the name of either a data file, temp file, or a redo log file member. The *filename* can contain only single-byte characters from 7-bit ASCII or EBCDIC character sets. Multibyte characters are not valid.
The filename can include a path prefix. If you do not specify such a path prefix, then the database adds the path prefix for the default storage location, which is platform dependent.
A redo log file group can have one or more members (copies). Each *filename* must be fully specified according to the conventions for your operating system.
The way the database interprets *filename* also depends on whether you specify it with the `SIZE` and `REUSE` clauses.
**````
- If you specify filename only, or with the REUSE clause but without the SIZE clause, then the file must already exist.
**````
- If you specify filename with SIZE but without REUSE, then the file must be a new file.
**``````
- If you specify filename with both SIZE and REUSE, then the file can be either new or existing. If the file exists, then it is reused with the new size. If it does not exist, then the database ignores the REUSE keyword and creates a new file of the specified size.
**See Also:**   *Oracle Automatic Storage Management Administrator’s Guide* for more information on Oracle Managed Files, “Specifying a Data File: Example”, and “Specifying a Log File: Example”
## *ASM_filename*
Use a form of `ASM_filename` for files stored in Oracle ASM disk groups. You can create or refer to data files, temp files, and redo log files with this syntax.
All forms of `ASM_filename` begin with the plus sign (+) followed by the name of the disk group. You can determine the names of all Oracle ASM disk groups by querying the `V$ASM_DISKGROUP` view.
**See Also:**   *Oracle Automatic Storage Management Administrator’s Guide* for information on using Oracle ASM
## *fully_qualified_file_name*
When you create a file in an Oracle ASM disk group, the file receives a system-generated fully qualified Oracle ASM filename. You can use this form only when referring to an existing Oracle ASM file. Therefore, if you are using this form during file creation, you must also specify `REUSE`.
**
- db_name is the value of the DB_UNIQUE_NAME initialization parameter. This name is equivalent to the name of the database on which the file resides, but the parameter distinguishes between primary and standby databases, if both exist.
****
- file_type and file_type_tag indicate the type of database file.Table 8-1 lists all of the file types and their corresponding Oracle ASM tags.
****
- filenumber and incarnation_number are system-generated identifiers to guarantee uniqueness.
You can determine the fully qualified names of Oracle ASM files by querying the dynamic performance view appropriate for the file type (for example `V$DATAFILE` for data files, `V$CONTROLFILE` for control files, and so on). You can also obtain the *filenumber* and *incarnation_number* portions of the fully qualified names by querying the `V$ASM_FILE` view.
Table 1 Oracle File Types and Oracle ASM File Type Tags

| Oracle ASM file_type | Description | Oracle ASM file_type_tag | Comments |
|---|---|---|---|
| CONTROLFILE | Control files and backup control files | CurrentBackup | - |
| DATAFILE | Data files and data file copies | tsname | Tablespace into which the file is added |
| ONLINELOG | Online logs | group_group# | - |
| ARCHIVELOG | Archive logs | thread_thread#_seq_sequence# | - |
| TEMPFILE | Temp files | tsname | Tablespace into which the file is added |
| BACKUPSET | Data file and archive log backup pieces; data file incremental backup pieces | hasspfile_timestamp | hasspfile can take one of two values: s indicates that the backup set includes the spfile; n indicates that the backup set does not include the spfile. |
| PARAMETERFILE | Persistent parameter files | spfile | - |
| DATAGUARDCONFIG | Data Guard configuration file | db_unique_name | Data Guard uses the value of the DB_UNIQUE_NAME initialization parameter. |
| FLASHBACK | Flashback logs | log_log# | - |
| CHANGETRACKING | Block change tracking data | ctf | Used during incremental backups |
| DUMPSET | Data Pump dumpset | user*obj#*file# | Dump set files encode the user name, the job number that created the dump set, and the file number as part of the tag. |
| XTRANSPORT | Data file convert | tsname | - |
| AUTOBACKUP | Automatic backup files | hasspfile_timestamp | hasspfile can take one of two values: s indicates that the backup set includes the spfile; n indicates that the backup set does not include the spfile. |

## *numeric_file_name*
A numeric Oracle ASM filename is similar to a fully qualified filename except that it uses only the unique *filenumber.incarnation_number* string. You can use this form only to refer to an existing file. Therefore, if you are using this form during file creation, you must also specify `REUSE`.
## *incomplete_file_name*
Incomplete Oracle ASM filenames are used during file creation only. If you specify the disk group name alone, then Oracle ASM uses the appropriate default template for the file type. For example, if you are creating a data file in a `CREATE` `TABLESPACE` statement, Oracle ASM uses the default `DATAFILE` template to create an Oracle ASM data file. If you specify the disk group name with a template, then Oracle ASM uses the specified template to create the file. In both cases, Oracle ASM also creates a fully qualified filename.
## *template_name*
A template is a named collection of attributes. You can create templates and apply them to files in a disk group. You can determine the names of all Oracle ASM template names by querying the `V$ASM_TEMPLATE` data dictionary view. Refer to *diskgroup_template_clauses* for instructions on creating Oracle ASM templates.
You can specify *template* only during file creation. It appears in the incomplete and alias name forms of the *ASM_filename* diagram:
**
- If you specify template immediately after the disk group name, then Oracle ASM uses the specified template to create the file, and gives the file a fully qualified filename.
******
- If you specify template after specifying an alias, then Oracle ASM uses the specified template to create the file, gives the file a fully qualified filename, and also creates the alias so that you can subsequently use it to refer to the file. If the alias you specify refers to an existing file, then Oracle ASM ignores the template specification unless you also specify REUSE. See Also: diskgroup_template_clauses for information about the default templates
## *alias_file_name*
An alias is a user-friendly name for an Oracle ASM file. You can use alias filenames during file creation or reference. You can specify a template with an alias, but only during file creation. To determine the alias names for Oracle ASM files, query the `V$ASM_ALIAS` data dictionary view.
If you are specifying an alias during file creation, then refer to *diskgroup_directory_clauses* and *diskgroup_alias_clauses* for instructions on specifying the full alias name.
## SIZE Clause
Specify the size of the file in bytes. Use `K`, `M`, `G`, or `T` to specify the size in kilobytes, megabytes, gigabytes, or terabytes.
- For undo tablespaces, you must specify the SIZE clause for each data file. For other tablespaces, you can omit this parameter if the file already exists, or if you are creating an Oracle Managed File.
- If you omit this clause when creating an Oracle Managed File, then Oracle creates a 100M file.
******
- The size of a tablespace must be one block greater than the sum of the sizes of the objects contained in it. See Also: Oracle Database Administrator’s Guide for information on automatic undo management and undo tablespaces and “Adding a Log File: Example”
## BLOCKSIZE Clause
Specify `BLOCKSIZE` to override the operating system-dependent sector size. If you omit this clause, then the database uses the operating system-dependent sector size as the block size.
When you add a redo log file to a 512-byte sector disk or to a 4KB sector disk with 512-byte emulation, the blocksize of the new file must be the original platform base block size or 4KB.
- If the redo log file is being added to a 512-byte sector disk, then you must specify 512 or 1024 (or 1K) as the block size, depending on your platform.
- If the redo log file is being added to a 4KB sector disk (native), then you must specify either 4096 or 4K as the block size.
- If the redo log file is being added to a 4KB sector disk with 512-byte emulation, then you can specify either 512, 1024 (or 1K), or 4096 (or 4K) as the block size, depending on your platform.
All logs within a log group must have the same block size. Two log groups created on separate disks can have different block sizes. However, the mixed configuration introduces overhead at every log switch. Oracle recommends that you create all log files with the same block size.
This clause is useful when the 4K sector size is in use, but you want to optimize disk space use rather than performance. In such a case you can override the operating system sector size by specifying `BLOCKSIZE` 512 or, for HP-UX, `BLOCKSIZE` 1024.
**See Also:**   “Adding a Log File: Example”
## REUSE
Specify `REUSE` to allow Oracle to reuse an existing file.
- If the file already exists, then Oracle reuses the filename and applies the new size (if you specify SIZE) or retains the original size.
- If the file does not exist, then Oracle ignores this clause and creates the file.
**Restriction on the REUSE Clause** You cannot specify `REUSE` unless you have specified *filename*.
Whenever Oracle uses an existing file, the previous contents of the file are lost.
**See Also:**   “Adding a Data File: Example” and “Adding a Log File: Example”
## *autoextend_clause*
The *autoextend_clause* is valid for data files and temp files but not for redo log files. Use this clause to enable or disable the automatic extension of a new or existing data file or temp file. If you omit this clause, then:
````
  - If you specify SIZE, then Oracle Database creates a file of the specified size with AUTOEXTEND disabled.
``````
  - If you do not specify SIZE, then the database creates a 100M file with AUTOEXTEND enabled. When autoextension is required, the database extends the file by its original size or 100MB, whichever is smaller. You can override this default behavior by specifying the NEXT clause.
````
- For user-managed files, with or without SIZE specified, Oracle creates a file with AUTOEXTEND disabled.
**ON**
Specify `ON` to enable autoextend.
**OFF**
Specify `OFF` to turn off autoextend if is turned on. When you turn off autoextend, the values of `NEXT` and `MAXSIZE` are set to zero. If you turn autoextend back on in a subsequent statement, then you must reset these values.
**NEXT**
Use the `NEXT` clause to specify the size in bytes of the next increment of disk space to be allocated automatically when more extents are required. The default is the size of one data block.
**MAXSIZE**
Use the `MAXSIZE` clause to specify the maximum disk space allowed for automatic extension of the data file.
**UNLIMITED**
Use the `UNLIMITED` clause if you do not want to limit the disk space that Oracle can allocate to the data file or temp file.
**Restriction on the** ***autoextend_clause***
You cannot specify this clause as part of the *datafile_tempfile_spec* in a `CREATE` `CONTROLFILE` statement or in an `ALTER` `DATABASE` `CREATE` `DATAFILE` clause.
## Examples
**Specifying a Log File: Example**
The following statement creates a database named `payable` that has two redo log file groups, each with two members, and one data file:
```
CREATE DATABASE payable LOGFILE GROUP 1 ('diska:log1.log', 'diskb:log1.log') SIZE 50K, GROUP 2 ('diska:log2.log', 'diskb:log2.log') SIZE 50K DATAFILE 'diskc:dbone.dbf' SIZE 30M;
```
The first file specification in the `LOGFILE` clause specifies a redo log file group with the `GROUP` value 1. This group has members named ‘`diska:log1.log`’ and ‘`diskb:log1.log`’, each 50 kilobytes in size.
The second file specification in the `LOGFILE` clause specifies a redo log file group with the `GROUP` value 2. This group has members named ‘`diska:log2.log`’ and ‘`diskb:log2.log`’, also 50 kilobytes in size.
The file specification in the `DATAFILE` clause specifies a data file named ‘`diskc:dbone.dbf`’, 30 megabytes in size.
Each file specification specifies a value for the `SIZE` parameter and omits the `REUSE` clause, so none of these files can already exist. Oracle must create them.
**Adding a Log File: Example**
The following statement adds another redo log file group with two members to the `payable` database:
```
ALTER DATABASE payable ADD LOGFILE GROUP 3 ('diska:log3.log', 'diskb:log3.log') SIZE 50K REUSE;
```
The file specification in the `ADD` `LOGFILE` clause specifies a new redo log file group with the `GROUP` value 3. This new group has members named ‘`diska:log3.log`’ and ‘`diskb:log3.log`’, each 50 kilobytes in size. Because the file specification specifies the `REUSE` clause, each member can (but need not) already exist.
The following statement adds a logfile group 5 with member log files on migration target disks `4k_disk_a` and `4k_disk_b`. After executing this statement, you can switch existing log files on disks with 512-byte block size to logs with 4K block size using the *switch_logfile_clause*.
```
ALTER DATABASE ADD LOGFILE GROUP 5 ('4k_disk_a:log5.log', '4k_disk_b:log5.log') SIZE 100M BLOCKSIZE 4096 REUSE;
```
**Specifying a Data File: Example**
The following statement creates a tablespace named `stocks` that has three data files:
```
CREATE TABLESPACE stocks DATAFILE 'stock1.dbf' SIZE 10M, 'stock2.dbf' SIZE 10M, 'stock3.dbf' SIZE 10M;
```
The file specifications for the data files specify files named ‘`diskc:stock1.dbf`’, ‘`diskc:stock2.dbf`’, and ‘`diskc:stock3.dbf`’.
**Adding a Data File: Example**
The following statement alters the `stocks` tablespace and adds a new data file:
```
ALTER TABLESPACE stocks ADD DATAFILE 'stock4.dbf' SIZE 10M REUSE;
```
The file specification specifies a data file named ‘`stock4.dbf`’. If the filename does not exist, then Oracle simply ignores the `REUSE` keyword.
**Using a Fully Qualified Oracle ASM Data File Name: Example**
When using Oracle ASM, the following syntax shows how to use the *fully_qualified_file_name* clause to bring online a data file in a hypothetical database, `testdb`:
```
ALTER DATABASE testdb DATAFILE '+dgroup_01/testdb/datafile/system.261.1' ONLINE;
```
