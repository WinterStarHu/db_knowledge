# Regular Expression Operator Multilingual Enhancements

When applied to multilingual data, Oracle’s implementation of the POSIX operators extends beyond the matching capabilities specified in the POSIX standard. Table D-2 shows the relationship of the operators in the context of the POSIX standard.
- The first column lists the supported operators.
- The second and third columns indicate whether the POSIX standard (Basic Regular Expression—BRE and Extended Regular Expression—ERE, respectively) defines the operator
- The fourth column indicates whether Oracle’s implementation extends the operator’s semantics for handling multilingual data.
Oracle lets you enter multibyte characters directly, if you have a direct input method, or you can use functions to compose the multibyte characters. You cannot use the Unicode hexadecimal encoding value of the form ‘`\xxxx`’. Oracle evaluates the characters based on the byte values used to encode the character, not the graphical representation of the character. All accented characters are considered word characters.
Table 2 POSIX and Multilingual Operator Relationships

| Operator | POSIX BRE syntax | POSIX ERE Syntax | Multilingual Enhancement |
|---|---|---|---|
| \ | Yes | Yes | - |
| * | Yes | Yes | - |
| + | – | Yes | - |
| ? | - | Yes | - |
| \| | - | Yes | - |
| ^ | Yes | Yes | Yes |
| $ | Yes | Yes | Yes |
| . | Yes | Yes | Yes |
| [ ] | Yes | Yes | Yes |
| ( ) | Yes | Yes | - |
| {m} | Yes | Yes | - |
| {m,} | Yes | Yes | - |
| {m,n} | Yes | Yes | - |
| \n | Yes | Yes | Yes |
| [..] | Yes | Yes | Yes |
| [::] | Yes | Yes | Yes |
| [==] | Yes | Yes | Yes |
