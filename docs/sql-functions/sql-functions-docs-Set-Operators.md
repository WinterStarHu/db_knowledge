# Set Operators

Set operators combine the results of two component queries into a single result. Queries containing set operators are called compound queries. Table 4-5 lists SQL set operators. They are fully described, including examples and restrictions on these operators, in The UNION [ALL], INTERSECT, MINUS Operators.
Table 5 Set Operators

| Operator | Returns |
|---|---|
| UNION | All distinct rows selected by either query |
| UNION ALL | All rows selected by either query, including all duplicates |
| INTERSECT | All distinct rows selected by both queries |
| MINUS | All distinct rows selected by the first query but not the second |
