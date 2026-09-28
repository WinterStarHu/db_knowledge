# Oracle Compliance with FIPS 127-2

Oracle complied fully with last Federal Information Processing Standard (FIPS), which was FIPS PUB 127-2. That standard is no longer published. However, for users whose applications depend on information about the sizes of some database constructs that were defined in FIPS 127-2, the details of our compliance are listed in Table C-4.
Table 4 Sizing for Database Constructs

| Database Constructs | FIPS | Oracle Database |
|---|---|---|
| Length of an identifier (in bytes) | 18 | 128 |
| Length of CHARACTER data type (in bytes) | 240 | 2,000 |
| Decimal precision of NUMERIC data type | 15 | 38 |
| Decimal precision of DECIMAL data type | 15 | 38 |
| Decimal precision of INTEGER data type | 9 | 38 |
| Decimal precision of SMALLINT data type | 4 | 38 |
| Binary precision of FLOAT data type | 20 | 126 |
| Binary precision of REAL data type | 20 | 63 |
| Binary precision of DOUBLE PRECISION data type | 30 | 126 |
| Columns in a table | 100 | 1,000 |
| Values in an INSERT statement | 100 | 1,000 |
| SET clauses in an UPDATE statement (Note 1) | 20 | 1,000 |
| Length of a row (Note2, Note 3) | 2,000 | 2,000,000 |
| Columns in a UNIQUE constraint | 6 | 32 |
| Length of a UNIQUE constraint (Note 2) | 120 | (Note 4) |
| Length of foreign key column list (Note 2) | 120 | (Note 4) |
| Columns in a GROUP BY clause | 6 | 255 (Note 5) |
| Length of GROUP BY column list | 120 | (Note 5) |
| Sort specifications in ORDER BY clause | 6 | 255 (Note 5) |
| Length of ORDER BY column list | 120 | (Note 5) |
| Columns in a referential integrity constraint | 6 | 32 |
| Tables referenced in a SQL statement | 15 | No limit |
| Cursors simultaneously open | 10 | (Note 6) |
| Items in a SELECT list | 100 | 1,000 |

**Note 1:** The number of `SET` clauses in an `UPDATE` statement refers to the number items separated by commas following the `SET` keyword.
**Note 2:** The FIPS PUB defines the length of a collection of columns to be the sum of: twice the number of columns, the length of each character column in bytes, decimal precision plus 1 of each exact numeric column, binary precision divided by 4 plus 1 of each approximate numeric column.
**Note 3:** The Oracle limit for the maximum row length is based on the maximum length of a row containing a `LONG` value of length 2 gigabytes and 999 `VARCHAR2` values, each of length 4000 bytes: 2(254) + 231 + (999(4000)).
**Note 4:** The Oracle limit for a `UNIQUE` key is half the size of an Oracle data block (specified by the initialization parameter `DB_BLOCK_SIZE`) minus some overhead.
**Note 5:** Oracle places no limit on the number of columns in a `GROUP` `BY` clause or the number of sort specifications in an `ORDER` `BY` clause. However, the sum of the sizes of all the expressions in either a `GROUP` `BY` clause or an `ORDER` `BY` clause is limited to the size of an Oracle data block (specified by the initialization parameter `DB_BLOCK_SIZE`) minus some overhead.
**Note 6:** The Oracle limit for the number of cursors simultaneously opened is specified by the initialization parameter `OPEN_CURSORS`. The maximum value of this parameter depends on the memory available on your operating system and exceeds 100 in all cases.
