# PostgreSQL: Documentation: 18: 9.23. Merge Support Functions

PostgreSQL: Documentation: 18: 9.23. Merge Support Functions Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 Development Versions:
19 / devel
9.23. Merge Support Functions
Prev Up Chapter 9. Functions and Operators Home Next
9.23. Merge Support Functions #
PostgreSQL includes one merge support function that may be used in the RETURNING list of a MERGE command to identify the action taken for each row; see Table 9.68.
Table 9.68. Merge Support Functions Function Description merge_action ( ) → text Returns the merge action command executed for the current row. This will be 'INSERT', 'UPDATE', or 'DELETE'.
Example:
MERGE INTO products p USING stock s ON p.product_id = s.product_id WHEN MATCHED AND s.quantity > 0 THEN UPDATE SET in_stock = true, quantity = s.quantity WHEN MATCHED THEN UPDATE SET in_stock = false, quantity = 0 WHEN NOT MATCHED THEN INSERT (product_id, in_stock, quantity) VALUES (s.product_id, true, s.quantity) RETURNING merge_action(), p.*;
merge_action | product_id | in_stock | quantity
--------------+------------+----------+----------
UPDATE       |       1001 | t        |       50 UPDATE       |       1002 | f        |        0 INSERT       |       1003 | t        |       10 Note that this function can only be used in the RETURNING list of a MERGE command. It is an error to use it in any other part of a query.
Prev Up Next
9.22. Window Functions
Home
9.24. Subquery Expressions
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
