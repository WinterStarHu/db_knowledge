# PostgreSQL: Documentation: 18: SPI_register_relation

PostgreSQL: Documentation: 18: SPI_register_relation Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11 / 10 SPI_register_relation Prev Up
45.1. Interface Functions
Home Next SPI_register_relation SPI_register_relation — make an ephemeral named relation available by name in SPI queries Synopsis int SPI_register_relation(EphemeralNamedRelation enr) Description SPI_register_relation makes an ephemeral named relation, with associated information, available to queries planned and executed through the current SPI connection.
Arguments EphemeralNamedRelation enr the ephemeral named relation registry entry Return Value If the execution of the command was successful then the following (nonnegative) value will be returned:
SPI_OK_REL_REGISTER if the relation has been successfully registered by name On error, one of the following negative values is returned:
SPI_ERROR_ARGUMENT if enr is NULL or its name field is NULL SPI_ERROR_UNCONNECTED if called from an unconnected C function SPI_ERROR_REL_DUPLICATE if the name specified in the name field of enr is already registered for this connection Prev Up Next SPI_saveplan Home SPI_unregister_relation Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
