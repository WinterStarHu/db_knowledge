# PostgreSQL: Documentation: 18: 49.1. Initialization Functions

PostgreSQL: Documentation: 18: 49.1. Initialization Functions Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 Development Versions:
19 / devel
49.1. Initialization Functions
Prev Up Chapter 49. Archive Modules Home Next
49.1. Initialization Functions #
An archive library is loaded by dynamically loading a shared library with the archive_library's name as the library base name. The normal library search path is used to locate the library. To provide the required archive module callbacks and to indicate that the library is actually an archive module, it needs to provide a function named _PG_archive_module_init. The result of the function must be a pointer to a struct of type ArchiveModuleCallbacks, which contains everything that the core code needs to know to make use of the archive module. The return value needs to be of server lifetime, which is typically achieved by defining it as a static const variable in global scope.
typedef struct ArchiveModuleCallbacks { ArchiveStartupCB startup_cb;
ArchiveCheckConfiguredCB check_configured_cb;
ArchiveFileCB archive_file_cb;
ArchiveShutdownCB shutdown_cb;
} ArchiveModuleCallbacks;
typedef const ArchiveModuleCallbacks *(*ArchiveModuleInit) (void);
Only the archive_file_cb callback is required. The others are optional.
Prev Up Next Chapter 49. Archive Modules Home
49.2. Archive Module Callbacks
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
