# REGEXP_SUBSTR

## Syntax
Description of the illustration regexp_substr.gif Description of the illustration regexp_substr.eps
## Purpose
`REGEXP_SUBSTR` extends the functionality of the `SUBSTR` function by letting you search a string for a regular expression pattern. It is also similar to `REGEXP_INSTR`, but instead of returning the position of the substring, it returns the substring itself. This function is useful if you need the contents of a match string but not its position in the source string. The function returns the string as `VARCHAR2` or `CLOB` data in the same character set as *source_char*.
This function complies with the POSIX regular expression standard and the Unicode Regular Expression Guidelines. For more information, refer to Oracle Regular Expression Support.
**````````````
- source_char is a character expression that serves as the search value. It is commonly a character column and can be of any of the data types CHAR, VARCHAR2, NCHAR, NVARCHAR2, CLOB, or NCLOB.
**````````**********
- pattern is the regular expression. It is usually a text literal and can be of any of the data types CHAR, VARCHAR2, NCHAR, or NVARCHAR2. It can contain up to 512 bytes. If the data type of pattern is different from the data type of source_char, then Oracle Database converts pattern to the data type of source_char. For a listing of the operators you can specify in pattern, refer to Oracle Regular Expression Support.
******
- position is a positive integer indicating the character of source_char where Oracle should begin the search. The default is 1, meaning that Oracle begins the search at the first character of source_char.
******** ****
- occurrence is a positive integer indicating which occurrence of pattern in source_char Oracle should search for. The default is 1, meaning that Oracle searches for the first occurrence of pattern. If occurrence is greater than 1, then the database searches for the second occurrence beginning with the first character following the first occurrence of pattern, and so forth. This behavior is different from the SUBSTR function, which begins its search for the second occurrence at the second character of the first occurrence.
**``````
- match_param is a character expression of the data type VARCHAR2 or CHAR that lets you change the default matching behavior of the function. The behavior of this parameter is the same for this function as for REGEXP_COUNT. Refer to REGEXP_COUNT for detailed information.
******
- For a pattern with subexpressions, subexpr is a nonnegative integer from 0 to 9 indicating which subexpression in pattern is to be returned by the function. This parameter has the same semantics that it has for the REGEXP_INSTR function. Refer to REGEXP_INSTR for more information.
**See Also:**
- SUBSTR and REGEXP_INSTR
- REGEXP_REPLACE, and REGEXP_LIKE Condition
******
- in Oracle Database Globalization Support Guide for the collation determination rules, which define the collation REGEXP_SUBSTR uses to compare characters from source_char with characters from pattern, and for the collation derivation rules, which define the collation assigned to the character return value of this function
## Examples
The following example examines the string, looking for the first substring bounded by commas. Oracle Database searches for a comma followed by one or more occurrences of non-comma characters followed by a comma. Oracle returns the substring, including the leading and trailing commas.
```
SELECT
  REGEXP_SUBSTR('500 Oracle Parkway, Redwood Shores, CA',
                ',[^,]+,') "REGEXPR_SUBSTR"
  FROM DUAL;
REGEXPR_SUBSTR
-----------------
, Redwood Shores,
```
The following example examines the string, looking for `http://` followed by a substring of one or more alphanumeric characters and optionally, a period (`.`). Oracle searches for a minimum of three and a maximum of four occurrences of this substring between `http://` and either a slash (`/`) or the end of the string.
```
SELECT
  REGEXP_SUBSTR('http://www.example.com/products',
                'http://([[:alnum:]]+\.?){3,4}/?') "REGEXP_SUBSTR"
  FROM DUAL;
REGEXP_SUBSTR
----------------------
http://www.example.com/
```
The next two examples use the *subexpr* argument to return a specific subexpression of *pattern*. The first statement returns the first subexpression in *pattern*:
```
SELECT REGEXP_SUBSTR('1234567890', '(123)(4(56)(78))', 1, 1, 'i', 1)
"REGEXP_SUBSTR" FROM DUAL;
REGEXP_SUBSTR
-------------------
123
```
The next statement returns the fourth subexpression in *pattern*:
```
SELECT REGEXP_SUBSTR('1234567890', '(123)(4(56)(78))', 1, 1, 'i', 4)
"REGEXP_SUBSTR" FROM DUAL;
REGEXP_SUBSTR
-------------------
78
```
**REGEXP_SUBSTR pattern matching: Examples** The following statements create a table regexp_temp and insert values into it:
```
CREATE TABLE regexp_temp(empName varchar2(20), emailID varchar2(20));
INSERT INTO regexp_temp (empName, emailID) VALUES ('John Doe', 'johndoe@example.com');
INSERT INTO regexp_temp (empName, emailID) VALUES ('Jane Doe', 'janedoe');
```
In the following example, the statement queries the email column and searches for valid email addresses:
```
SELECT empName, REGEXP_SUBSTR(emailID, '[[:alnum:]]+\@[[:alnum:]]+\.[[:alnum:]]+') "Valid Email" FROM regexp_temp;
EMPNAME  Valid Email
-------- -------------------
John Doe johndoe@example.com
Jane Doe
```
In the following example, the statement queries the email column and returns the count of valid email addresses:
```
SELECT empName, REGEXP_SUBSTR(emailID, '[[:alnum:]]+\@[[:alnum:]]+\.[[:alnum:]]+') "Valid Email", REGEXP_INSTR(emailID, '\w+@\w+(\.\w+)+') "FIELD_WITH_VALID_EMAIL" FROM regexp_temp;
EMPNAME		Valid Email			FIELD_WITH_VALID_EMAIL
--------	-------------------	----------------------
John Doe	johndoe@example.com	1
Jane Doe
```
In the following example, numbers and alphabets are extracted from a string:
```
with strings as (
  select 'ABC123' str from dual union all
  select 'A1B2C3' str from dual union all
  select '123ABC' str from dual union all
  select '1A2B3C' str from dual
)
  select regexp_substr(str, '[0-9]') First_Occurrence_of_Number,
         regexp_substr(str, '[0-9].*') Num_Followed_by_String,
         regexp_substr(str, '[A-Z][0-9]') Letter_Followed_by_String
  from strings;
FIRST_OCCURRENCE_OF_NUMB NUM_FOLLOWED_BY_STRING   LETTER_FOLLOWED_BY_STRIN
------------------------ ------------------------ ------------------------
1			 123			  C1
1			 1B2C3			  A1
1			 123ABC
1			 1A2B3C 		  A2
```
In the following example, passenger names and flight information are extracted from a string:
```
with strings as (
  select 'LHRJFK/010315/JOHNDOE' str from dual union all
  select 'CDGLAX/050515/JANEDOE' str from dual union all
  select 'LAXCDG/220515/JOHNDOE' str from dual union all
  select 'SFOJFK/010615/JANEDOE' str from dual
)
  SELECT regexp_substr(str, '[A-Z]{6}') String_of_6_characters,
         regexp_substr(str, '[0-9]+') First_Matching_Numbers,
         regexp_substr(str, '[A-Z].*$') Letter_by_other_characters,
         regexp_substr(str, '/[A-Z].*$') Slash_letter_and_characters
  FROM strings;
STRING_OF_6_CHARACTERS	FIRST_MATCHING_NUMBERS	LETTER_BY_OTHER_CHARACTERS	SLASH_LETTER_AND_CHARACTERS
----------------------	----------------------	--------------------------	---------------------------
LHRJFK	                010315	                LHRJFK/010315/JOHNDOE	      	/JOHNDOE
CDGLAX	                050515	                CDGLAX/050515/JANEDOE	      	/JANEDOE
LAXCDG	                220515	                LAXCDG/220515/JOHNDOE	      	/JOHNDOE
SFOJFK	                010615	                SFOJFK/010615/JANEDOE	      	/JANEDOE
```
