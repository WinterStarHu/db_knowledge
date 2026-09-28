# PostgreSQL: Documentation: 18: 64.2. Custom WAL Resource Managers

PostgreSQL: Documentation: 18: 64.2. Custom WAL Resource Managers Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 Development Versions:
19 / devel
64.2. Custom WAL Resource Managers
Prev Up Chapter 64. Write Ahead Logging for Extensions Home Next
64.2. Custom WAL Resource Managers #
This section explains the interface between the core PostgreSQL system and custom WAL resource managers, which enable extensions to integrate directly with the WAL.
An extension, especially a Table Access Method or Index Access Method, may need to use WAL for recovery, replication, and/or Logical Decoding.
To create a new custom WAL resource manager, first define an RmgrData structure with implementations for the resource manager methods. Refer to src/backend/access/transam/README and src/include/access/xlog_internal.h in the PostgreSQL source.
/*
* Method table for resource managers.
*
* This struct must be kept in sync with the PG_RMGR definition in
* rmgr.c.
*
* rm_identify must return a name for the record based on xl_info (without
* reference to the rmid). For example, XLOG_BTREE_VACUUM would be named
* "VACUUM". rm_desc can then be called to obtain additional detail for the
* record, if available (e.g. the last block).
*
* rm_mask takes as input a page modified by the resource manager and masks
* out bits that shouldn't be flagged by wal_consistency_checking.
*
* RmgrTable[] is indexed by RmgrId values (see rmgrlist.h). If rm_name is
* NULL, the corresponding RmgrTable entry is considered invalid.
*/ typedef struct RmgrData { const char *rm_name;
void        (*rm_redo) (XLogReaderState *record);
void        (*rm_desc) (StringInfo buf, XLogReaderState *record);
const char *(*rm_identify) (uint8 info);
void        (*rm_startup) (void);
void        (*rm_cleanup) (void);
void        (*rm_mask) (char *pagedata, BlockNumber blkno);
void        (*rm_decode) (struct LogicalDecodingContext *ctx, struct XLogRecordBuffer *buf);
} RmgrData;
The src/test/modules/test_custom_rmgrs module contains a working example, which demonstrates usage of custom WAL resource managers.
Then, register your new resource manager.
/*
* Register a new custom WAL resource manager.
*
* Resource manager IDs must be globally unique across all extensions. Refer
* to https://wiki.postgresql.org/wiki/CustomWALResourceManagers to reserve a
* unique RmgrId for your extension, to avoid conflicts with other extension
* developers. During development, use RM_EXPERIMENTAL_ID to avoid needlessly
* reserving a new ID.
*/ extern void RegisterCustomRmgr(RmgrId rmid, const RmgrData *rmgr);
RegisterCustomRmgr must be called from the extension module's _PG_init function. While developing a new extension, use RM_EXPERIMENTAL_ID for rmid. When you are ready to release the extension to users, reserve a new resource manager ID at the Custom WAL Resource Manager page.
Place the extension module implementing the custom resource manager in shared_preload_libraries so that it will be loaded early during PostgreSQL startup.
Note The extension must remain in shared_preload_libraries as long as any custom WAL records may exist in the system. Otherwise PostgreSQL will not be able to apply or decode the custom WAL records, which may prevent the server from starting.
Prev Up Next
64.1. Generic WAL Records
Home Chapter 65. Built-in Index Access Methods Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
