# PostgreSQL: Documentation: 18: 31.3. Variant Comparison Files

PostgreSQL: Documentation: 18: 31.3. Variant Comparison Files Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
31.3. Variant Comparison Files
Prev Up Chapter 31. Regression Tests Home Next
31.3. Variant Comparison Files #
Since some of the tests inherently produce environment-dependent results, we have provided ways to specify alternate “expected” result files. Each regression test can have several comparison files showing possible results on different platforms. There are two independent mechanisms for determining which comparison file is used for each test.
The first mechanism allows comparison files to be selected for specific platforms. There is a mapping file, src/test/regress/resultmap, that defines which comparison file to use for each platform. To eliminate bogus test “failures” for a particular platform, you first choose or make a variant result file, and then add a line to the resultmap file.
Each line in the mapping file is of the form testname:output:platformpattern=comparisonfilename The test name is just the name of the particular regression test module. The output value indicates which output file to check. For the standard regression tests, this is always out. The value corresponds to the file extension of the output file. The platform pattern is a pattern in the style of the Unix tool expr (that is, a regular expression with an implicit ^ anchor at the start). It is matched against the platform name as printed by config.guess. The comparison file name is the base name of the substitute result comparison file.
For example: some systems lack a working strtof function, for which our workaround causes rounding errors in the float4 regression test. Therefore, we provide a variant comparison file, float4-misrounded-input.out, which includes the results to be expected on these systems. To silence the bogus “failure” message on Cygwin platforms, resultmap includes:
float4:out:.*-.*-cygwin.*=float4-misrounded-input.out which will trigger on any machine where the output of config.guess matches .*-.*-cygwin.*. Other lines in resultmap select the variant comparison file for other platforms where it's appropriate.
The second selection mechanism for variant comparison files is much more automatic: it simply uses the “best match” among several supplied comparison files. The regression test driver script considers both the standard comparison file for a test, testname.out, and variant files named testname_digit.out (where the digit is any single digit 0-9). If any such file is an exact match, the test is considered to pass; otherwise, the one that generates the shortest diff is used to create the failure report. (If resultmap includes an entry for the particular test, then the base testname is the substitute name given in resultmap.) For example, for the char test, the comparison file char.out contains results that are expected in the C and POSIX locales, while the file char_1.out contains results sorted as they appear in many other locales.
The best-match mechanism was devised to cope with locale-dependent results, but it can be used in any situation where the test results cannot be predicted easily from the platform name alone. A limitation of this mechanism is that the test driver cannot tell which variant is actually “correct” for the current environment; it will just pick the variant that seems to work best. Therefore it is safest to use this mechanism only for variant results that you are willing to consider equally valid in all contexts.
Prev Up Next
31.2. Test Evaluation
Home
31.4. TAP Tests
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
