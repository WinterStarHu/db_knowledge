# About SQL Operators

Operators manipulate individual data items called **operands** or **arguments**. Operators are represented by special characters or by keywords. For example, the multiplication operator is represented by an asterisk (*).
If you have installed Oracle Text, then you can use the `SCORE` operator, which is part of that product, in Oracle Text queries. You can also create conditions with the built-in Text operators, including `CONTAINS`, `CATSEARCH`, and `MATCHES`. For more information on these Oracle Text elements, refer to *Oracle Text Reference*.
## Unary and Binary Operators
The two general classes of operators are:
****- unary: A unary operator operates on only one operand. A unary operator typically appears with its operand in this format:
```
operator operand
```
****- binary: A binary operator operates on two operands. A binary operator appears with its operands in this format:
```
operand1 operator operand2
```
Other operators with special formats accept more than two operands. If an operator is given a null operand, then the result is always null. The only operator that does not follow this rule is concatenation (||).
## Operator Precedence
**Precedence** is the order in which Oracle Database evaluates different operators in the same expression. When evaluating an expression containing multiple operators, Oracle evaluates operators with higher precedence before evaluating those with lower precedence. Oracle evaluates operators with equal precedence from left to right within an expression.
Table 4-1 lists the levels of precedence among SQL operators from high to low. Operators listed on the same line have the same precedence.
Table 1 SQL Operator Precedence

| Operator | Operation |
|---|---|
| +, -(as unary operators), PRIOR, CONNECT_BY_ROOT, COLLATE | Identity, negation, location in hierarchy |
| *, / | Multiplication, division |
| +, -(as binary operators), \|\| | Addition, subtraction, concatenation |
| SQL conditions are evaluated after SQL operators | See “Condition Precedence” |

**Precedence Example** In the following expression, multiplication has a higher precedence than addition, so Oracle first multiplies 2 by 3 and then adds the result to 1.
```
1+2*3
```
You can use parentheses in an expression to override operator precedence. Oracle evaluates expressions inside parentheses before evaluating those outside.
SQL also supports set operators (`UNION`, `UNION` `ALL`, `INTERSECT`, and `MINUS`), which combine sets of rows returned by queries, rather than individual data items. All set operators have equal precedence.
**See Also:**   Hierarchical Query Operators and Hierarchical Queries for information on the `PRIOR` operator, which is used only in hierarchical queries
