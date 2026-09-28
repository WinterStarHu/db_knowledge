# PostgreSQL: Documentation: 18: SPI_prepare_params

PostgreSQL: Documentation: 18: SPI_prepare_params Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
SPI_prepare_params Prev Up
45.1. Interface Functions
Home Next SPI_prepare_params SPI_prepare_params — prepare a statement, without executing it yet Synopsis SPIPlanPtr SPI_prepare_params(const char * command, ParserSetupHook parserSetup, void * parserSetupArg, int cursorOptions) Description SPI_prepare_params creates and returns a prepared statement for the specified command, but doesn't execute the command. This function is equivalent to SPI_prepare_cursor, with the addition that the caller can specify parser hook functions to control the parsing of external parameter references.
This function is now deprecated in favor of SPI_prepare_extended.
Arguments const char * command command string ParserSetupHook parserSetup Parser hook setup function void * parserSetupArg pass-through argument for parserSetup int cursorOptions integer bit mask of cursor options; zero produces default behavior Return Value SPI_prepare_params has the same return conventions as SPI_prepare.
Prev Up Next SPI_prepare_extended Home SPI_getargcount Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
