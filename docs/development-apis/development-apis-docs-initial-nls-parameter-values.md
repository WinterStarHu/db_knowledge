# About Initial NLS Parameter Values

Except in SQL Developer, the initial values of NLS parameters are set by database initialization parameters.
The DBA can set the values of initialization parameters in the initialization parameter file, and they take effect the next time the database is started.
In SQL Developer, the initial values of NLS parameters are as shown in the following table.
**Initial Values of NLS Parameters in SQL Developer**

| Parameter | Initial Value |
|---|---|
| NLS_CALENDAR | GREGORIAN |
| NLS_CHARACTERSET | AL32UTF8 |
| NLS_COMP | BINARY |
| NLS_CURRENCY | $ |
| NLS_DATE_FORMAT | DD-MON-RR |
| NLS_DATE_LANGUAGE | AMERICAN |
| NLS_DUAL_CURRENCY | $ |
| NLS_ISO_CURRENCY | AMERICA |
| NLS_LANGUAGE | AMERICAN |
| NLS_LENGTH_SEMANTICS | BYTE |
| NLS_NCHAR_CHARACTERSET | AL16UTF16 |
| NLS_NCHAR_CONV_EXCP | FALSE |
| NLS_NUMERIC_CHARACTERS | ., |
| NLS_SORT | BINARY |
| NLS_TERRITORY | AMERICA |
| NLS_TIMESTAMP_FORMAT | DD-MON-RR HH.MI.SSXFF AM |
| NLS_TIMESTAMP_TZ_FORMAT | DD-MON-RR HH.MI.SSXFF AM TZR |
| NLS_TIME_FORMAT | HH.MI.SSXFF AM |
| NLS_TIME_TZ_FORMAT | HH.MI.SSXFF AM TZR |

**See Also:**   *Oracle Database Administrator’s Guide* for information about initialization parameters and initialization parameter files
