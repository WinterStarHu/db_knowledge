# PostgreSQL: Documentation: 18: 54.6. Message Data Types

PostgreSQL: Documentation: 18: 54.6. Message Data Types Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
/
8.2
/
8.1
/
8.0
/
7.4
/
7.3
/
7.2
/
7.1
54.6. Message Data Types
Prev Up Chapter 54. Frontend/Backend Protocol Home Next
54.6. Message Data Types #
This section describes the base data types used in messages.
Intn(i) An n-bit integer in network byte order (most significant byte first). If i is specified it is the exact value that will appear, otherwise the value is variable. Eg. Int16, Int32(42).
Intn[k] An array of k n-bit integers, each in network byte order. The array length k is always determined by an earlier field in the message. Eg. Int16[M].
String(s) A null-terminated string (C-style string). There is no specific length limitation on strings. If s is specified it is the exact value that will appear, otherwise the value is variable. Eg. String, String("user").
Note There is no predefined limit on the length of a string that can be returned by the backend. Good coding strategy for a frontend is to use an expandable buffer so that anything that fits in memory can be accepted. If that's not feasible, read the full string and discard trailing characters that don't fit into your fixed-size buffer.
Byten(c) Exactly n bytes. If the field width n is not a constant, it is always determinable from an earlier field in the message. If c is specified it is the exact value. Eg. Byte2, Byte1('\n').
Prev Up Next
54.5. Logical Streaming Replication Protocol
Home
54.7. Message Formats
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
