# TO_UTC_TIMESTAMP_TZ

## Syntax
Description of the illustration to_utc_timestamp_tz.eps
## Purpose
The SQL function `TO_UTC_TIMESTAMP_TZ` takes an ISO 8601 date format string as the `varchar` input and returns an instance of SQL data type `TIMESTAMP WITH TIMEZONE`. It normalizes the input to UTC time (Coordinated Universal Time, formerly Greenwich Mean Time). Unlike SQL function `TO_TIMESTAMP_TZ` , the new function assumes that the input string uses the ISO 8601 date format, defaulting the time zone to UTC 0.
A typical use of this function would be to provide its output to SQL function `SYS_EXTRACT_UTC`, obtaining a UTC time that is then passed as a SQL bind variable to SQL/JSON condition `JSON_EXISTS`, to perform a time-stamp range comparison.
This is the allowed syntax for dates and times:
- Date (only): YYYY-MM-DD
- Date with time: YYYY**-**MM**-**DD**T**hh**:**mm**:**ss[**.**s[s[s[s[s[s]]]]][**Z**|(**+**|**-**)hh**:**mm]
where:
**
- **YYYY** specifies the year, as four decimal digits.
**````
- **MM** specifies the month, as two decimal digits, 00 to 12.
**````
- **DD** specifies the day, as two decimal digits, 00 to 31.
**````
- **hh** specifies the hour, as two decimal digits, 00 to 23.
**````
- **mm** specifies the minutes, as two decimal digits, 00 to 59.
**````
- **ss**[**.s**[**s**[**s**[**s**[**s**]]]]] specifies the seconds, as two decimal digits, 00 to 59, optionally followed by a decimal point and 1 to 6 decimal digits (representing the fractional part of a second).
**````
- **Z** specifies UTC time (time zone 0). (It can also be specified by +00:00, but not by -00:00.)
**````
- (**+**|**-**)hh**:**mm specifies the time-zone as difference from UTC. (One of + or - is required.)
For a time value, the time-zone part is optional. If it is absent then UTC time is assumed.
No other ISO 8601 date-time syntax is supported. In particular:
- Negative dates (dates prior to year 1 BCE), which begin with a hyphen (e.g. **-**2018-10-26T21:32:52), are not supported.
- Hyphen and colon separators are required: so-called “basic” format, YYYYMMDDThhmmss, is not supported.
- Ordinal dates (year plus day of year, calendar week plus day number) are not supported.
- Using more than four digits for the year is not supported.
Supported dates and times include the following:
- 2018-10-26T21:32:52
- 2018-10-26T21:32:52+02:00
- 2018-10-26T19:32:52Z
- 2018-10-26T19:32:52+00:00
- 2018-10-26T21:32:52.12679
Unsupported dates and times include the following:
- 2018-10-26T21:32 (if a time is specified then all of its parts must be present)
- 2018-10-26T**25**:32:52+02:00 (the hours part, 25, is out of range)
- 18-10-26T21:32 (the year is not specified fully)
## Examples
```
SELECT TO_UTC_TIMESTAMP_TZ('1998-01-01') FROM DUAL;
TO_UTC_TIMESTAMP_TZ('1998-01-01')
---------------------------------------------------------------------------
01-JAN-98 12.00.00.000000000 AM +00:00
```
```
SELECT TO_UTC_TIMESTAMP_TZ('2000-01-02T12:34:56.789') FROM DUAL;
TO_UTC_TIMESTAMP_TZ('2000-01-02T12:34:56.789')
---------------------------------------------------------------------------
02-JAN-00 12.34.56.789000000 PM +00:00
```
```
SELECT TO_UTC_TIMESTAMP_TZ('2016-05-05T00:00:00.000Z') FROM DUAL;
TO_UTC_TIMESTAMP_TZ('2016-05-05T00:00:00.000Z')
---------------------------------------------------------------------------
05-MAY-16 12.00.00.000000000 AM +00:00
```
```
SELECT TO_UTC_TIMESTAMP_TZ('2016-05-05T02:04:35.4678Z') FROM DUAL;
TO_UTC_TIMESTAMP_TZ('2016-05-05T02:04:35.4678Z')
---------------------------------------------------------------------------
05-MAY-16 02.04.35.467800000 AM +00:00
```
**See Also:**
- ISO 8601 standard
- ISO 8601 at Wikipedia
