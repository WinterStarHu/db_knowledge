# PostgreSQL: Documentation: 18: 43.4. Global Values in PL/Perl

PostgreSQL: Documentation: 18: 43.4. Global Values in PL/Perl Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
43.4. Global Values in PL/Perl
Prev Up Chapter 43. PL/Perl — Perl Procedural Language Home Next
43.4. Global Values in PL/Perl #
You can use the global hash %_SHARED to store data, including code references, between function calls for the lifetime of the current session.
Here is a simple example for shared data:
CREATE OR REPLACE FUNCTION set_var(name text, val text) RETURNS text AS $$ if ($_SHARED{$_[0]} = $_[1]) { return 'ok';
} else { return "cannot set shared variable $_[0] to $_[1]";
} $$ LANGUAGE plperl;
CREATE OR REPLACE FUNCTION get_var(name text) RETURNS text AS $$ return $_SHARED{$_[0]};
$$ LANGUAGE plperl;
SELECT set_var('sample', 'Hello, PL/Perl!  How''s tricks?');
SELECT get_var('sample');
Here is a slightly more complicated example using a code reference:
CREATE OR REPLACE FUNCTION myfuncs() RETURNS void AS $$ $_SHARED{myquote} = sub { my $arg = shift;
$arg =~ s/(['\\])/\\$1/g;
return "'$arg'";
};
$$ LANGUAGE plperl;
SELECT myfuncs(); /* initializes the function */ /* Set up a function that uses the quote function */ CREATE OR REPLACE FUNCTION use_quote(TEXT) RETURNS text AS $$ my $text_to_quote = shift;
my $qfunc = $_SHARED{myquote};
return &$qfunc($text_to_quote);
$$ LANGUAGE plperl;
(You could have replaced the above with the one-liner return $_SHARED{myquote}->($_[0]); at the expense of readability.) For security reasons, PL/Perl executes functions called by any one SQL role in a separate Perl interpreter for that role. This prevents accidental or malicious interference by one user with the behavior of another user's PL/Perl functions. Each such interpreter has its own value of the %_SHARED variable and other global state. Thus, two PL/Perl functions will share the same value of %_SHARED if and only if they are executed by the same SQL role. In an application wherein a single session executes code under multiple SQL roles (via SECURITY DEFINER functions, use of SET ROLE, etc.) you may need to take explicit steps to ensure that PL/Perl functions can share data via %_SHARED. To do that, make sure that functions that should communicate are owned by the same user, and mark them SECURITY DEFINER. You must of course take care that such functions can't be used to do anything unintended.
Prev Up Next
43.3. Built-in Functions
Home
43.5. Trusted and Untrusted PL/Perl
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
