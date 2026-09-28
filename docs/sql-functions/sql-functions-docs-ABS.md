# ABS

## Syntax
Description of the illustration abs.gif Description of the illustration abs.eps
## Purpose
`ABS` returns the absolute value of *n*.
This function takes as an argument any numeric data type or any nonnumeric data type that can be implicitly converted to a numeric data type. The function returns the same data type as the numeric data type of the argument.
**See Also:**   Table 2-8 for more information on implicit conversion
## Examples
The following example returns the absolute value of -15:
```
SELECT ABS(-15) "Absolute"
  FROM DUAL;
  Absolute
----------
        15
```
