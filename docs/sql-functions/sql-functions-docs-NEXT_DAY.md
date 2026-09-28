# NEXT_DAY

## Syntax
Description of the illustration next_day.gif Description of the illustration next_day.eps
## Purpose
`NEXT_DAY` returns the date of the first weekday named by *char* that is later than the date *date*. The return type is always `DATE`, regardless of the data type of *date*. The argument *char* must be a day of the week in the date language of your session, either the full name or the abbreviation. The minimum number of letters required is the number of letters in the abbreviated version. Any characters immediately following the valid abbreviation are ignored. The return value has the same hours, minutes, and seconds component as the argument *date*.
## Examples
This example returns the date of the next Tuesday after October 15, 2009:
```
SELECT NEXT_DAY('15-OCT-2009','TUESDAY') "NEXT DAY"
  FROM DUAL;
NEXT DAY
--------------------
20-OCT-2009 00:00:00
```
