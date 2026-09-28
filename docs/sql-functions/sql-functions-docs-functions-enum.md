# PostgreSQL: Documentation: 18: 9.10. Enum Support Functions

PostgreSQL: Documentation: 18: 9.10. Enum Support Functions Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11 / 10 /
9.6
/
9.5
/
9.4
/
9.3
/
9.2
/
9.1
/
9.0
/
8.4
/
8.3
9.10. Enum Support Functions
Prev Up Chapter 9. Functions and Operators Home Next
9.10. Enum Support Functions #
For enum types (described in Section 8.7), there are several functions that allow cleaner programming without hard-coding particular values of an enum type. These are listed in Table 9.35. The examples assume an enum type created as:
CREATE TYPE rainbow AS ENUM ('red', 'orange', 'yellow', 'green', 'blue', 'purple');
Table 9.35. Enum Support Functions Function Description Example(s) enum_first ( anyenum ) → anyenum Returns the first value of the input enum type.
enum_first(null::rainbow) → red enum_last ( anyenum ) → anyenum Returns the last value of the input enum type.
enum_last(null::rainbow) → purple enum_range ( anyenum ) → anyarray Returns all values of the input enum type in an ordered array.
enum_range(null::rainbow) → {red,orange,yellow,​green,blue,purple} enum_range ( anyenum, anyenum ) → anyarray Returns the range between the two given enum values, as an ordered array. The values must be from the same enum type. If the first parameter is null, the result will start with the first value of the enum type. If the second parameter is null, the result will end with the last value of the enum type.
enum_range('orange'::rainbow, 'green'::rainbow) → {orange,yellow,green} enum_range(NULL, 'green'::rainbow) → {red,orange,​yellow,green} enum_range('orange'::rainbow, NULL) → {orange,yellow,green,​blue,purple} Notice that except for the two-argument form of enum_range, these functions disregard the specific value passed to them; they care only about its declared data type. Either null or a specific value of the type can be passed, with the same result. It is more common to apply these functions to a table column or function argument than to a hardwired type name as used in the examples.
Prev Up Next
9.9. Date/Time Functions and Operators
Home
9.11. Geometric Functions and Operators
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
