# Compound Expressions

A compound expression specifies a combination of other expressions.
## *compound_expression*::=
Description of the illustration compound_expression.eps You can use any built-in function as an expression (Function Expressions). However, in a compound expression, some combinations of functions are inappropriate and are rejected. For example, the `LENGTH` function is inappropriate within an aggregate function.
The `PRIOR` operator is used in `CONNECT` `BY` clauses of hierarchical queries.
The `COLLATE` operator determines the collation for an expression. This operator overrides the collation that the database would have derived for the expression using standard collation derivation rules.
**See Also:**
- Operator Precedence
- Hierarchical Queries
- COLLATE Operator
Some valid compound expressions are:
```
('CLARK' || 'SMITH')
LENGTH('MOOSE') * 57
SQRT(144) + 72
my_fun(TO_CHAR(sysdate,'DD-MMM-YY'))
name COLLATE BINARY_CI
```
