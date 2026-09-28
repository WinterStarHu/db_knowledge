# COLLATE Operator

The `COLLATE` operator determines the collation for an expression. This operator enables you to override the collation that the database would have derived for the expression using standard collation derivation rules.
`COLLATE` is a postfix unary operator. It has the same precedence as other unary operators, but it is evaluated after all prefix unary operators have been evaluated.
You can apply this operator to expressions of type `VARCHAR2`, `CHAR`, `LONG`, `NVARCHAR`, or `NCHAR`.
The `COLLATE` operator takes one argument, *collation_name*, for which you can specify a named collation or pseudo-collation. If the collation name contains a space, then you must enclose the name in double quotation marks.
Table 4-3 describes the `COLLATE` operator.
Table 3 COLLATE Operator

| Operator | Purpose | Example |
|---|---|---|
| COLLATE collation_name | Determines the collation for an expression | SELECT last_name FROM employees ORDER BY last_name COLLATE GENERIC_M; |

**See Also:**
- Compound Expressions for information on using the COLLATE operator in a compound expression
**
- Oracle Database Globalization Support Guide for more information on the COLLATE operator
