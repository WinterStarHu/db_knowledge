# COSH

## Syntax
Description of the illustration cosh.gif Description of the illustration cosh.eps
## Purpose
`COSH` returns the hyperbolic cosine of *n*.
This function takes as an argument any numeric data type or any nonnumeric data type that can be implicitly converted to a numeric data type. If the argument is `BINARY_FLOAT`, then the function returns `BINARY_DOUBLE`. Otherwise the function returns the same numeric data type as the argument.
**See Also:**   Table 2-8 for more information on implicit conversion
## Examples
The following example returns the hyperbolic cosine of zero:
```
SELECT COSH(0) "Hyperbolic cosine of 0"
  FROM DUAL;
Hyperbolic cosine of 0
----------------------
                     1
```
