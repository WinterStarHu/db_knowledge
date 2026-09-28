# ASIN

## Syntax
Description of the illustration asin.gif Description of the illustration asin.eps
## Purpose
`ASIN` returns the arc sine of *n*. The argument *n* must be in the range of -1 to 1, and the function returns a value in the range of -*pi*/2 to *pi*/2, expressed in radians.
This function takes as an argument any numeric data type or any nonnumeric data type that can be implicitly converted to a numeric data type. If the argument is `BINARY_FLOAT`, then the function returns `BINARY_DOUBLE`. Otherwise the function returns the same numeric data type as the argument.
**See Also:**   Table 2-8 for more information on implicit conversion
## Examples
The following example returns the arc sine of .3:
```
SELECT ASIN(.3) "Arc_Sine"
  FROM DUAL;
 Arc_Sine
----------
.304692654
```
