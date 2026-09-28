# PostgreSQL: Documentation: 18: SPI_modifytuple

PostgreSQL: Documentation: 18: SPI_modifytuple Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
SPI_modifytuple Prev Up
45.3. Memory Management
Home Next SPI_modifytuple SPI_modifytuple — create a row by replacing selected fields of a given row Synopsis HeapTuple SPI_modifytuple(Relation rel, HeapTuple row, int ncols, int * colnum, Datum * values, const char * nulls) Description SPI_modifytuple creates a new row by substituting new values for selected columns, copying the original row's columns at other positions. The input row is not modified. The new row is returned in the upper executor context.
This function can only be used while connected to SPI. Otherwise, it returns NULL and sets SPI_result to SPI_ERROR_UNCONNECTED.
Arguments Relation rel Used only as the source of the row descriptor for the row. (Passing a relation rather than a row descriptor is a misfeature.) HeapTuple row row to be modified int ncols number of columns to be changed int * colnum an array of length ncols, containing the numbers of the columns that are to be changed (column numbers start at 1) Datum * values an array of length ncols, containing the new values for the specified columns const char * nulls an array of length ncols, describing which new values are null If nulls is NULL then SPI_modifytuple assumes that no new values are null. Otherwise, each entry of the nulls array should be ' ' if the corresponding new value is non-null, or 'n' if the corresponding new value is null. (In the latter case, the actual value in the corresponding values entry doesn't matter.) Note that nulls is not a text string, just an array: it does not need a '\0' terminator.
Return Value new row with modifications, allocated in the upper executor context, or NULL on error (see SPI_result for an error indication) On error, SPI_result is set as follows:
SPI_ERROR_ARGUMENT if rel is NULL, or if row is NULL, or if ncols is less than or equal to 0, or if colnum is NULL, or if values is NULL.
SPI_ERROR_NOATTRIBUTE if colnum contains an invalid column number (less than or equal to 0 or greater than the number of columns in row) SPI_ERROR_UNCONNECTED if SPI is not active Prev Up Next SPI_returntuple Home SPI_freetuple Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
