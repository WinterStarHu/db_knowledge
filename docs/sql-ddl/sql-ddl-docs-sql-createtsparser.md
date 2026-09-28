# PostgreSQL: Documentation: 18: CREATE TEXT SEARCH PARSER

PostgreSQL: Documentation: 18: CREATE TEXT SEARCH PARSER Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
CREATE TEXT SEARCH PARSER Prev Up SQL Commands Home Next CREATE TEXT SEARCH PARSER CREATE TEXT SEARCH PARSER — define a new text search parser Synopsis CREATE TEXT SEARCH PARSER name ( START = start_function , GETTOKEN = gettoken_function , END = end_function , LEXTYPES = lextypes_function [, HEADLINE = headline_function ] ) Description CREATE TEXT SEARCH PARSER creates a new text search parser. A text search parser defines a method for splitting a text string into tokens and assigning types (categories) to the tokens. A parser is not particularly useful by itself, but must be bound into a text search configuration along with some text search dictionaries to be used for searching.
If a schema name is given then the text search parser is created in the specified schema. Otherwise it is created in the current schema.
You must be a superuser to use CREATE TEXT SEARCH PARSER. (This restriction is made because an erroneous text search parser definition could confuse or even crash the server.) Refer to Chapter 12 for further information.
Parameters name The name of the text search parser to be created. The name can be schema-qualified.
start_function The name of the start function for the parser.
gettoken_function The name of the get-next-token function for the parser.
end_function The name of the end function for the parser.
lextypes_function The name of the lextypes function for the parser (a function that returns information about the set of token types it produces).
headline_function The name of the headline function for the parser (a function that summarizes a set of tokens).
The function names can be schema-qualified if necessary. Argument types are not given, since the argument list for each type of function is predetermined. All except the headline function are required.
The arguments can appear in any order, not only the one shown above.
Compatibility There is no CREATE TEXT SEARCH PARSER statement in the SQL standard.
See AlsoALTER TEXT SEARCH PARSER, DROP TEXT SEARCH PARSER Prev Up Next CREATE TEXT SEARCH DICTIONARY Home CREATE TEXT SEARCH TEMPLATE Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
