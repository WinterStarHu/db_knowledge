# PostgreSQL: Documentation: 18: 50.2. Initialization Functions

PostgreSQL: Documentation: 18: 50.2. Initialization Functions Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) Development Versions:
19 / devel
50.2. Initialization Functions
Prev Up Chapter 50. OAuth Validator Modules Home Next
50.2. Initialization Functions #
OAuth validator modules are dynamically loaded from the shared libraries listed in oauth_validator_libraries. Modules are loaded on demand when requested from a login in progress. The normal library search path is used to locate the library. To provide the validator callbacks and to indicate that the library is an OAuth validator module a function named _PG_oauth_validator_module_init must be provided. The return value of the function must be a pointer to a struct of type OAuthValidatorCallbacks, which contains a magic number and pointers to the module's token validation functions. The returned pointer must be of server lifetime, which is typically achieved by defining it as a static const variable in global scope.
typedef struct OAuthValidatorCallbacks { uint32        magic;            /* must be set to PG_OAUTH_VALIDATOR_MAGIC */ ValidatorStartupCB startup_cb;
ValidatorShutdownCB shutdown_cb;
ValidatorValidateCB validate_cb;
} OAuthValidatorCallbacks;
typedef const OAuthValidatorCallbacks *(*OAuthValidatorModuleInit) (void);
Only the validate_cb callback is required, the others are optional.
Prev Up Next
50.1. Safely Designing a Validator Module
Home
50.3. OAuth Validator Callbacks
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
