# About Globalization Support Features

Globalization support features enable you to develop multilingual applications that can be run simultaneously from anywhere in the world. An application can render the content of the user interface, and process data, using the native language and locale preferences of the user.
**Note:** In the past, Oracle called globalization support **National Language Support (NLS)**, but NLS is actually a subset of globalization support. NLS is the ability to choose a national language and store data using a specific character set. NLS is implemented with NLS parameters.
**See Also:**   *Oracle Database Globalization Support Guide* for more information about globalization support features
## About Language Support
Oracle Database enables you to store, process, and retrieve data in native languages. The languages that can be stored in a database are all languages written in scripts that are encoded by Oracle-supported character sets. Through the use of Unicode databases and data types, Oracle Database supports most contemporary languages.
Additional support is available for a subset of the languages. The database can, for example, display dates using translated month names, and can sort text data according to cultural conventions.
In this document, the term **language support** refers to the additional language-dependent functionality, and not to the ability to store text of a specific language. For example, language support includes displaying dates or sorting text according to specific locales and cultural conventions. Additionally, for some supported languages, Oracle Database provides translated server messages and a translated user interface for the database utilities.
**See Also:**
- “About the NLS_LANGUAGE Parameter”
**
- Oracle Database Globalization Support Guide for a complete list of languages that Oracle Database supports
**
- Oracle Database Globalization Support Guide for a list of languages into which Oracle Database messages are translated
## About Territory Support
The default local time format, date format, and numeric and monetary conventions depend on the local territory setting.
Oracle Database supports cultural conventions that are specific to geographical locations. The default local time format, date format, and numeric and monetary conventions depend on the local territory setting. Setting different NLS parameters enables the database session to use different cultural settings. For example, you can set the euro (`EUR`) as the primary currency and the Japanese yen (`JPY`) as the secondary currency for a given database session, even when the territory is `AMERICA`.
**See Also:**
- “About the NLS_TERRITORY Parameter”
**
- Oracle Database Globalization Support Guide for a complete list of territories that Oracle Database supports
## About Date and Time Formats
Different countries have different conventions for displaying the hour, day, month, and year.
For example, this table shows the local date and time format for five countries and gives an example of each format:

| Country | Date Format | Example | Time Format | Example |
|---|---|---|---|---|
| China | yyyy-mm-dd | 2005-02-28 | hh24:mi:ss | 13:50:23 |
| Estonia | dd.mm.yyyy | 28.02.2005 | hh24:mi:ss | 13:50:23 |
| Germany | dd.mm.rr | 28.02.05 | hh24:mi:ss | 13:50:23 |
| UK | dd/mm/yyyy | 28/02/2005 | hh24:mi:ss | 13:50:23 |
| US | mm/dd/yyyy | 02/28/2005 | hh:mi:ssxff am | 1:50:23.555 PM |

**See Also:**
- “About the NLS_DATE_FORMAT Parameter”
- “About the NLS_DATE_LANGUAGE Parameter”
- “About NLS_TIMESTAMP_FORMAT and NLS_TIMESTAMP_TZ_FORMAT Parameters”
**
- Oracle Database Globalization Support Guide for information about date/time data types and time zone support
**
- Oracle Database SQL Language Reference for information about date and time formats
## About Calendar Formats
Different countries use different calendars.
Oracle Database stores this calendar information for each territory:
****
- First day of the week Sunday in some cultures, Monday in others. Set by the NLS_TERRITORY parameter.
****
- First week of the calendar year Some countries use week numbers for scheduling, planning, and bookkeeping. In the ISO standard, this week number can differ from the week number of the calendar year. For example, 1st Jan 2005 is in ISO week number 53 of 2004. An ISO week starts on Monday and ends on Sunday. To support the ISO standard, Oracle Database provides the IW date format element, which returns the ISO week number. The first calendar week of the year is set by the NLS_TERRITORY parameter.
****
  - Japanese Imperial Has the same number of months and days as the Gregorian calendar, but the year starts with the beginning of each Imperial Era.
  - ROC Official Has the same number of months and days as the Gregorian calendar, but the year starts with the founding of the Republic of China.
  - Persian The first six months have 31 days each, the next five months have 30 days each, and the last month has either 29 days or (in leap year) 30 days.
  - Thai Buddha uses a Buddhist calendar.
  - Arabic Hijrah has 12 months and 354 or 355 days.
  - English Hijrah has 12 months and 354 or 355 days.
The calendar system is specified by the NLS_CALENDAR parameter.
****
- First year of era The Islamic calendar starts from the year of the Hegira. The Japanese Imperial calendar starts from the beginning of an Emperor's reign (for example, 1998 is the tenth year of the Heisei era).
**See Also:**
- “About the NLS_TERRITORY Parameter”
- “About the NLS_CALENDAR Parameter”
**
- Oracle Database Globalization Support Guide for information about calendar formats
## About Numeric and Monetary Formats
Different countries have different numeric and monetary conventions.
This table shows the local numeric and monetary format for five countries and gives an example of each format:

| Country | Numeric Format | Monetary Format |
|---|---|---|
| China | 1,234,567.89 | ©1,234.56 |
| Estonia | 1 234 567,89 | 1 234,56 kr |
| Germany | 1.234.567,89 | 1.234,56€ |
| UK | 1,234,567.89 | £1,234.56 |
| US | 1,234,567.89 | $1,234.56 |

**See Also:**
- “About the NLS_NUMERIC_CHARACTERS Parameter”
- “About the NLS_CURRENCY Parameter”
- “About the NLS_ISO_CURRENCY Parameter”
- “About the NLS_DUAL_CURRENCY Parameter”
**
- Oracle Database Globalization Support Guide for information about numeric and list parameters
**
- Oracle Database Globalization Support Guide for information about monetary parameters
**
- Oracle Database SQL Language Reference for information about number format models
## About Linguistic Sorting and String Searching
Different languages have different sort orders (collating sequences). Also, different countries or cultures that use the same alphabets sort words differently. For example, in Danish, Æ is after Z, and Y and Ü are considered to be variants of the same letter.
**See Also:**
- “About the NLS_SORT Parameter”
- “About the NLS_COMP Parameter”
**
- Oracle Database Globalization Support Guide for more information about linguistic sorting and string searching
## About Length Semantics
To calculate the number of characters in a string, using byte length, you must know the number of bytes in each character in the character set.
In single-byte character sets, the number of bytes and the number of characters in a string are the same. In multibyte character sets, a character or code point consists of one or more bytes. Calculating the number of characters based on byte length can be difficult in a variable-width character set. Calculating column length in bytes is called **byte semantics** , while measuring column length in characters is called **character semantics**.
Character semantics is useful for specifying the storage requirements for multibyte strings of varying widths. For example, in a Unicode database (AL32UTF8), suppose that you must have a VARCHAR2 column that can store up to five Chinese characters with five English characters. Using byte semantics, this column requires 15 bytes for the Chinese characters, which are 3 bytes long, and 5 bytes for the English characters, which are 1 byte long, for a total of 20 bytes. Using character semantics, the column requires 10 characters.
**See Also:**
- “About the NLS_LENGTH_SEMANTICS Parameter”
**
- Oracle Database Globalization Support Guide for information about character sets and length semantics
## About Unicode and SQL National Character Data Types
**Unicode** is a character encoding system that defines every character in most of the spoken languages in the world. In Unicode, every character has a unique code, regardless of the platform, program, or language.
You can store Unicode characters in an Oracle Database in two ways:
- You can create a Unicode database that enables you to store UTF-8 encoded characters as SQL character data types (CHAR, VARCHAR2, CLOB, and LONG).
- You can declare columns and variables that have SQL national character data types.
The **SQL national character data types** are NCHAR, NVARCHAR2, and NCLOB. They are also called **Unicode data types** , because they are used only for storing Unicode data.
The national character set, which is used for all SQL national character data types, is specified when the database is created. The national character set can be either UTF8 or AL16UTF16 (default).
When you declare a column or variable of the type NCHAR or NVARCHAR2, the length that you specify is the number of characters, not the number of bytes.
**See Also:** **
- Oracle Database Globalization Support Guide for more information about Unicode
**
- Oracle Database Globalization Support Guide for more information about storing Unicode characters in an Oracle Database
**
- Oracle Database Globalization Support Guide for more information about SQL national character data types
