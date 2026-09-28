# PostgreSQL: Documentation: 18: SPI_unregister_relation

PostgreSQL: Documentation: 18: SPI_unregister_relation Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11 / 10 SPI_unregister_relation Prev Up
45.1. Interface Functions
Home Next SPI_unregister_relation SPI_unregister_relation — remove an ephemeral named relation from the registry Synopsis int SPI_unregister_relation(const char * name) Description SPI_unregister_relation removes an ephemeral named relation from the registry for the current connection.
Arguments const char * name the relation registry entry name Return Value If the execution of the command was successful then the following (nonnegative) value will be returned:
SPI_OK_REL_UNREGISTER if the tuplestore has been successfully removed from the registry On error, one of the following negative values is returned:
SPI_ERROR_ARGUMENT if name is NULL SPI_ERROR_UNCONNECTED if called from an unconnected C function SPI_ERROR_REL_NOT_FOUND if name is not found in the registry for the current connection Prev Up Next SPI_register_relation Home SPI_register_trigger_data Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
