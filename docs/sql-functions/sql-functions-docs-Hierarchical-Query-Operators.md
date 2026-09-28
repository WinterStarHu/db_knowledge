# Hierarchical Query Operators

Two operators, `PRIOR` and `CONNECT_BY_ROOT`, are valid only in hierarchical queries.
## PRIOR
In a hierarchical query, one expression in the `CONNECT` `BY` *condition* must be qualified by the `PRIOR` operator. If the `CONNECT` `BY` *condition* is compound, then only one condition requires the `PRIOR` operator, although you can have multiple `PRIOR` conditions. `PRIOR` evaluates the immediately following expression for the parent row of the current row in a hierarchical query.
`PRIOR` is most commonly used when comparing column values with the equality operator. (The `PRIOR` keyword can be on either side of the operator.) `PRIOR` causes Oracle to use the value of the parent row in the column. Operators other than the equal sign (=) are theoretically possible in `CONNECT` `BY` clauses. However, the conditions created by these other operators can result in an infinite loop through the possible combinations. In this case Oracle detects the loop at run time and returns an error. Refer to Hierarchical Queries for more information on this operator, including examples.
## CONNECT_BY_ROOT
`CONNECT_BY_ROOT` is a unary operator that is valid only in hierarchical queries. When you qualify a column with this operator, Oracle returns the column value using data from the root row. This operator extends the functionality of the `CONNECT` `BY` [`PRIOR`] condition of hierarchical queries.
**Restriction on CONNECT_BY_ROOT** You cannot specify this operator in the `START` `WITH` condition or the `CONNECT` `BY` condition.
**See Also:**   CONNECT_BY_ROOT Examples
