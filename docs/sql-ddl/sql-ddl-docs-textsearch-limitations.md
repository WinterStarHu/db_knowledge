# PostgreSQL: Documentation: 18: 12.11. Limitations

PostgreSQL: Documentation: 18: 12.11. Limitations Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
12.11. Limitations
Prev Up Chapter 12. Full Text Search Home Next
12.11. Limitations #
The current limitations of PostgreSQL's text search features are:
The length of each lexeme must be less than 2 kilobytes The length of a tsvector (lexemes + positions) must be less than 1 megabyte The number of lexemes must be less than 264 Position values in tsvector must be greater than 0 and no more than 16,383 The match distance in a  (FOLLOWED BY) tsquery operator cannot be more than 16,384 No more than 256 positions per lexeme The number of nodes (lexemes + operators) in a tsquery must be less than 32,768 For comparison, the PostgreSQL 8.1 documentation contained 10,441 unique words, a total of 335,420 words, and the most frequent word “postgresql” was mentioned 6,127 times in 655 documents.
Another example — the PostgreSQL mailing list archives contained 910,989 unique words with 57,491,343 lexemes in 461,020 messages.
Prev Up Next
12.10. psql Support
Home Chapter 13. Concurrency Control Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
