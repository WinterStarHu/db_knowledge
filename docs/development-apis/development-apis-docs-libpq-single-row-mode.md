# PostgreSQL: Documentation: 18: 32.6. Retrieving Query Results in Chunks

PostgreSQL: Documentation: 18: 32.6. Retrieving Query Results in Chunks Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
32.6. Retrieving Query Results in Chunks
Prev Up Chapter 32. libpq — C Library Home Next
32.6. Retrieving Query Results in Chunks #
Ordinarily, libpq collects an SQL command's entire result and returns it to the application as a single PGresult. This can be unworkable for commands that return a large number of rows. For such cases, applications can use PQsendQuery and PQgetResult in single-row mode or chunked mode. In these modes, result row(s) are returned to the application as they are received from the server, one at a time for single-row mode or in groups for chunked mode.
To enter one of these modes, call PQsetSingleRowMode or PQsetChunkedRowsMode immediately after a successful call of PQsendQuery (or a sibling function). This mode selection is effective only for the currently executing query. Then call PQgetResult repeatedly, until it returns null, as documented in Section 32.4. If the query returns any rows, they are returned as one or more PGresult objects, which look like normal query results except for having status code PGRES_SINGLE_TUPLE for single-row mode or PGRES_TUPLES_CHUNK for chunked mode, instead of PGRES_TUPLES_OK. There is exactly one result row in each PGRES_SINGLE_TUPLE object, while a PGRES_TUPLES_CHUNK object contains at least one row but not more than the specified number of rows per chunk. After the last row, or immediately if the query returns zero rows, a zero-row object with status PGRES_TUPLES_OK is returned; this is the signal that no more rows will arrive. (But note that it is still necessary to continue calling PQgetResult until it returns null.) All of these PGresult objects will contain the same row description data (column names, types, etc.) that an ordinary PGresult object for the query would have. Each object should be freed with PQclear as usual.
When using pipeline mode, single-row or chunked mode needs to be activated for each query in the pipeline before retrieving results for that query with PQgetResult. See Section 32.5 for more information.
PQsetSingleRowMode # Select single-row mode for the currently-executing query.
int PQsetSingleRowMode(PGconn *conn);
This function can only be called immediately after PQsendQuery or one of its sibling functions, before any other operation on the connection such as PQconsumeInput or PQgetResult. If called at the correct time, the function activates single-row mode for the current query and returns 1. Otherwise the mode stays unchanged and the function returns 0. In any case, the mode reverts to normal after completion of the current query.
PQsetChunkedRowsMode # Select chunked mode for the currently-executing query.
int PQsetChunkedRowsMode(PGconn *conn, int chunkSize);
This function is similar to PQsetSingleRowMode, except that it specifies retrieval of up to chunkSize rows per PGresult, not necessarily just one row. This function can only be called immediately after PQsendQuery or one of its sibling functions, before any other operation on the connection such as PQconsumeInput or PQgetResult. If called at the correct time, the function activates chunked mode for the current query and returns 1. Otherwise the mode stays unchanged and the function returns 0. In any case, the mode reverts to normal after completion of the current query.
Caution While processing a query, the server may return some rows and then encounter an error, causing the query to be aborted. Ordinarily, libpq discards any such rows and reports only the error. But in single-row or chunked mode, some rows may have already been returned to the application. Hence, the application will see some PGRES_SINGLE_TUPLE or PGRES_TUPLES_CHUNK PGresult objects followed by a PGRES_FATAL_ERROR object. For proper transactional behavior, the application must be designed to discard or undo whatever has been done with the previously-processed rows, if the query ultimately fails.
Prev Up Next
32.5. Pipeline Mode
Home
32.7. Canceling Queries in Progress
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
