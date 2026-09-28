# PostgreSQL: Documentation: 18: SPI_register_trigger_data

PostgreSQL: Documentation: 18: SPI_register_trigger_data Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11 / 10 SPI_register_trigger_data Prev Up
45.1. Interface Functions
Home Next SPI_register_trigger_data SPI_register_trigger_data — make ephemeral trigger data available in SPI queries Synopsis int SPI_register_trigger_data(TriggerData *tdata) Description SPI_register_trigger_data makes any ephemeral relations captured by a trigger available to queries planned and executed through the current SPI connection. Currently, this means the transition tables captured by an AFTER trigger defined with a REFERENCING OLD/NEW TABLE AS ... clause. This function should be called by a PL trigger handler function after connecting.
Arguments TriggerData *tdata the TriggerData object passed to a trigger handler function as fcinfo->context Return Value If the execution of the command was successful then the following (nonnegative) value will be returned:
SPI_OK_TD_REGISTER if the captured trigger data (if any) has been successfully registered On error, one of the following negative values is returned:
SPI_ERROR_ARGUMENT if tdata is NULL SPI_ERROR_UNCONNECTED if called from an unconnected C function SPI_ERROR_REL_DUPLICATE if the name of any trigger data transient relation is already registered for this connection Prev Up Next SPI_unregister_relation Home
45.2. Interface Support Functions
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
