# Pattern-matching Conditions

The pattern-matching conditions compare character data.
## LIKE Condition
The `LIKE` conditions specify a test involving pattern matching. Whereas the equality operator (=) exactly matches one character value to another, the `LIKE` conditions match a portion of one character value to another by searching the first value for the pattern specified by the second. `LIKE` calculates strings using characters as defined by the input character set. `LIKEC` uses Unicode complete characters. `LIKE2` uses UCS2 code points. `LIKE4` uses UCS4 code points.
***like_condition*::=** Description of the illustration like_condition.gif Description of the illustration like_condition.eps In this syntax:
******
- char1 is a character expression, such as a character column, called the search value.
******
- char2 is a character expression, usually a literal, called the pattern.
******
- esc_char is a character expression, usually a literal, called the escape character.
The `LIKE` condition is the best choice in almost all situations. Use the following guidelines to determine whether any of the variations would be helpful in your environment:
````
- Use LIKE2 to process strings using UCS-2 semantics. LIKE2 treats a Unicode supplementary character as two characters.
````
- Use LIKE4 to process strings using UCS-4 semantics. LIKE4 treats a Unicode supplementary character as one character.
````
- Use LIKEC to process strings using Unicode complete character semantics. LIKEC treats a composite character as one character.
For more on character length see the following:
**
- Oracle Database Globalization Support Guide
**
- Oracle Database SecureFiles and Large Objects Developer’s Guide
If *esc_char* is not specified, then there is no default escape character. If any of *char1*, *char2*, or *esc_char* is null, then the result is unknown. Otherwise, the escape character, if specified, must be a character string of length
1.
All of the character expressions (*char1*, *char2*, and *esc_char*) can be of any of the data types `CHAR`, `VARCHAR2`, `NCHAR`, or `NVARCHAR2`. If they differ, then Oracle converts all of them to the data type of *char1*.
The pattern can contain special pattern-matching characters:
- An underscore (_) in the pattern matches exactly one character (as opposed to one byte in a multibyte character set) in the value.
- A percent sign (%) in the pattern can match zero or more characters (as opposed to bytes in a multibyte character set) in the value. The pattern ‘%’ cannot match a null.
You can include the actual characters `%` or `_` in the pattern by using the `ESCAPE` clause, which identifies the escape character. If the escape character precedes the character `%` or `_` in the pattern, then Oracle interprets this character literally in the pattern rather than as a special pattern-matching character. You can also search for the escape character itself by repeating it. For example, if @ is the escape character, then you can use @@ to search for @.
  **Note:**   Only ASCII-equivalent underscore (_) and percent (%) characters are recognized as pattern-matching characters. Their full-width variants, present in East Asian character sets and in Unicode, are treated as normal characters.
Table 6-8 describes the `LIKE` conditions.
Table 8 LIKE Condition

| Type of Condition | Operation | Example |
|---|---|---|
| x [NOT] LIKE y [ESCAPE 'z'] | TRUE if x does [not] match the pattern y. Within y, the character % matches any string of zero or more characters except null. The character _ matches any single character. Any character can follow ESCAPE except percent (%) and underbar (_). A wildcard character is treated as a literal if preceded by the escape character. | SELECT last_name FROM employees WHERE last_name LIKE '%A\_B%' ESCAPE '\' ORDER BY last_name; |

To process the `LIKE` conditions, Oracle divides the pattern into subpatterns consisting of one or two characters each. The two-character subpatterns begin with the escape character and the other character is %, or _, or the escape character.
Let P1, P2, …, Pn be these subpatterns. The like condition is true if there is a way to partition the search value into substrings S1, S2, …, Sn so that for all *i* between 1 and *n*:
- If Pi is _, then Si is a single character.
- If Pi is %, then Si is any string.
- If Pi is two characters beginning with an escape character, then Si is the second character of Pi.
- Otherwise, Pi = Si.
With the `LIKE` conditions, you can compare a value to a pattern rather than to a constant. The pattern must appear after the `LIKE` keyword. For example, you can issue the following query to find the salaries of all employees with names beginning with `R`:
```
SELECT salary FROM employees WHERE last_name LIKE 'R%' ORDER BY salary;
```
The following query uses the = operator, rather than the `LIKE` condition, to find the salaries of all employees with the name ‘R%’:
```
SELECT salary FROM employees WHERE last_name = 'R%' ORDER BY salary;
```
The following query finds the salaries of all employees with the name ‘SM%’. Oracle interprets ‘SM%’ as a text literal, rather than as a pattern, because it precedes the `LIKE` keyword:
```
SELECT salary FROM employees WHERE 'SM%' LIKE last_name ORDER BY salary;
```
**Collation and Case Sensitivity**
The `LIKE` condition is collation-sensitive. Oracle Database compares the subpattern Pi to the substring Si in the processing algorithm above using the collation determined from the derived collations of *char1* and *char2*. If this collation is case-insensitive, the pattern-matching is case-insensitive as well.
**See Also:**   *Oracle Database Globalization Support Guide* for more information on caseand accent-insensitive collations and on collation determination rules for the `LIKE` condition
**Pattern Matching on Indexed Columns**
When you use `LIKE` to search an indexed column for a pattern, Oracle can use the index to improve performance of a query if the leading character in the pattern is not `%` or `_`. In this case, Oracle can scan the index by this leading character. If the first character in the pattern is `%` or `_`, then the index cannot improve performance because Oracle cannot scan the index.
**LIKE Condition: General Examples**
This condition is true for all `last_name` values beginning with `Ma`:
```
last_name LIKE 'Ma%'
```
All of these `last_name` values make the condition true:
```
Mallin, Markle, Marlow, Marvins, Mavris, Matos
```
Case is significant, so `last_name` values beginning with `MA`, `ma`, and `mA` make the condition false.
Consider this condition:
```
last_name LIKE 'SMITH_'
```
This condition is true for these `last_name` values:
```
SMITHE, SMITHY, SMITHS
```
This condition is false for `SMITH` because the special underscore character (`_`) must match exactly one character of the `last_name` value.
**ESCAPE Clause Example**
The following example searches for employees with the pattern `A_B` in their name:
```
SELECT last_name FROM employees WHERE last_name LIKE '%A\_B%' ESCAPE '\' ORDER BY last_name;
```
The `ESCAPE` clause identifies the backslash () as the escape character. In the pattern, the escape character precedes the underscore (_). This causes Oracle to interpret the underscore literally, rather than as a special pattern matching character.
**Patterns Without % Example**
If a pattern does not contain the `%` character, then the condition can be true only if both operands have the same length. Consider the definition of this table and the values inserted into it:
```
CREATE TABLE ducks (f CHAR(6), v VARCHAR2(6));
INSERT INTO ducks VALUES ('DUCK', 'DUCK');
SELECT '*'||f||'*' "char", '*'||v||'*' "varchar" FROM ducks;
char     varchar
-------- --------
*DUCK  * *DUCK*
```
Because Oracle blank-pads `CHAR` values, the value of `f` is blank-padded to 6 bytes. `v` is not blank-padded and has length 4.
## REGEXP_LIKE Condition
`REGEXP_LIKE` is similar to the `LIKE` condition, except `REGEXP_LIKE` performs regular expression matching instead of the simple pattern matching performed by `LIKE`. This condition evaluates strings using characters as defined by the input character set.
This condition complies with the POSIX regular expression standard and the Unicode Regular Expression Guidelines. For more information, refer to Oracle Regular Expression Support.
***regexp_like_condition*::=**
Description of the illustration regexp_like_condition.gif
Description of the illustration regexp_like_condition.eps
**````````````
- source_char is a character expression that serves as the search value. It is commonly a character column and can be of any of the data types CHAR, VARCHAR2, NCHAR, NVARCHAR2, CLOB, or NCLOB.
******````````**********
- pattern is the regular expression. It is usually a text literal and can be of any of the data types CHAR, VARCHAR2, NCHAR, or NVARCHAR2. It can contain up to 512 bytes. If the data type of pattern is different from the data type of source_char, Oracle converts pattern to the data type of source_char. For a listing of the operators you can specify in pattern, refer to Oracle Regular Expression Support.
**````
**
  - 'i' specifies case-insensitive matching, even if the determined collation of the condition is case-sensitive.
  - 'c' specifies case-sensitive and accent-sensitive matching, even if the determined collation of the condition is case-insensitive or accent-insensitive.
  - 'n' allows the period (.), which is the match-any-character wildcard character, to match the newline character. If you omit this parameter, then the period does not match the newline character.
````
  - 'm' treats the source string as multiple lines. Oracle interprets ` ^ and $` as the start and end, respectively, of any line anywhere in the source string, rather than only at the start or end of the entire source string. If you omit this parameter, then Oracle treats the source string as a single line.
  - 'x' ignores whitespace characters. By default, whitespace characters match themselves.
If the value of *match_param* contains multiple contradictory characters, then Oracle uses the last character. For example, if you specify `'ic'`, then Oracle uses case-sensitive and accent-sensitive matching. If the value contains a character other than those shown above, then Oracle returns an error.
If you omit *match_param*, then:
  - The default case and accent sensitivity are determined by the determined collation of the REGEXP_LIKE condition.
  - A period (.) does not match the newline character.
  - The source string is treated as a single line.
Similar to the `LIKE` condition, the `REGEXP_LIKE` condition is collation-sensitive.
```

```
**Examples** The following query returns the first and last names for those employees with a first name of Steven or Stephen (where `first_name` begins with `Ste` and ends with `en` and in between is either `v` or `ph)`:
```
SELECT first_name, last_name
FROM employees
WHERE REGEXP_LIKE (first_name, '^Ste(v|ph)en$')
ORDER BY first_name, last_name;
FIRST_NAME           LAST_NAME
-------------------- -------------------------
Steven               King
Steven               Markle
Stephen              Stiles
```
The following query returns the last name for those employees with a double vowel in their last name (where `last_name` contains two adjacent occurrences of either `a`, `e`, `i`, `o`, or `u`, regardless of case):
```
SELECT last_name
FROM employees
WHERE REGEXP_LIKE (last_name, '([aeiou])\1', 'i')
ORDER BY last_name;
LAST_NAME
-------------------------
De Haan
Greenberg
Khoo
Gee
Greene
Lee
Bloom
Feeney
```
