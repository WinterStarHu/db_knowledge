# PostgreSQL: Documentation: 18: CREATE COLLATION

PostgreSQL: Documentation: 18: CREATE COLLATION Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
CREATE COLLATION Prev Up SQL Commands Home Next CREATE COLLATION CREATE COLLATION — define a new collation Synopsis CREATE COLLATION [ IF NOT EXISTS ] name ( [ LOCALE = locale, ] [ LC_COLLATE = lc_collate, ] [ LC_CTYPE = lc_ctype, ] [ PROVIDER = provider, ] [ DETERMINISTIC = boolean, ] [ RULES = rules, ] [ VERSION = version ] ) CREATE COLLATION [ IF NOT EXISTS ] name FROM existing_collation Description CREATE COLLATION defines a new collation using the specified operating system locale settings, or by copying an existing collation.
To be able to create a collation, you must have CREATE privilege on the destination schema.
Parameters IF NOT EXISTS Do not throw an error if a collation with the same name already exists. A notice is issued in this case. Note that there is no guarantee that the existing collation is anything like the one that would have been created.
name The name of the collation. The collation name can be schema-qualified. If it is not, the collation is defined in the current schema. The collation name must be unique within that schema. (The system catalogs can contain collations with the same name for other encodings, but these are ignored if the database encoding does not match.) locale The locale name for this collation. See Section 23.2.2.3.1 and Section 23.2.2.3.2 for details.
If provider is libc, this is a shortcut for setting LC_COLLATE and LC_CTYPE at once. If you specify locale, you cannot specify either of those parameters.
If provider is builtin, then locale must be specified and set to either C, C.UTF-8 or PG_UNICODE_FAST.
lc_collate If provider is libc, use the specified operating system locale for the LC_COLLATE locale category.
lc_ctype If provider is libc, use the specified operating system locale for the LC_CTYPE locale category.
provider Specifies the provider to use for locale services associated with this collation. Possible values are builtin, icu (if the server was built with ICU support) or libc. libc is the default. See Section 23.1.4 for details.
DETERMINISTIC Specifies whether the collation should use deterministic comparisons. The default is true. A deterministic comparison considers strings that are not byte-wise equal to be unequal even if they are considered logically equal by the comparison. PostgreSQL breaks ties using a byte-wise comparison. Comparison that is not deterministic can make the collation be, say, caseor accent-insensitive. For that, you need to choose an appropriate LOCALE setting and set the collation to not deterministic here.
Nondeterministic collations are only supported with the ICU provider.
rules Specifies additional collation rules to customize the behavior of the collation. This is supported for ICU only. See Section 23.2.3.4 for details.
version Specifies the version string to store with the collation. Normally, this should be omitted, which will cause the version to be computed from the actual version of the collation as provided by the operating system. This option is intended to be used by pg_upgrade for copying the version from an existing installation.
See also ALTER COLLATION for how to handle collation version mismatches.
existing_collation The name of an existing collation to copy. The new collation will have the same properties as the existing one, but it will be an independent object.
Notes CREATE COLLATION takes a SHARE ROW EXCLUSIVE lock, which is self-conflicting, on the pg_collation system catalog, so only one CREATE COLLATION command can run at a time.
Use DROP COLLATION to remove user-defined collations.
See Section 23.2.2.3 for more information on how to create collations.
When using the libc collation provider, the locale must be applicable to the current database encoding. See CREATE DATABASE for the precise rules.
Examples To create a collation from the operating system locale fr_FR.utf8 (assuming the current database encoding is UTF8):
CREATE COLLATION french (locale = 'fr_FR.utf8');
To create a collation using the ICU provider using German phone book sort order:
CREATE COLLATION german_phonebook (provider = icu, locale = 'de-u-co-phonebk');
To create a collation using the ICU provider, based on the root ICU locale, with custom rules:
CREATE COLLATION custom (provider = icu, locale = 'und', rules = '&V << w <<< W');
See Section 23.2.3.4 for further details and examples on the rules syntax.
To create a collation from an existing collation:
CREATE COLLATION german FROM "de_DE";
This can be convenient to be able to use operating-system-independent collation names in applications.
Compatibility There is a CREATE COLLATION statement in the SQL standard, but it is limited to copying an existing collation. The syntax to create a new collation is a PostgreSQL extension.
See AlsoALTER COLLATION, DROP COLLATION Prev Up Next CREATE CAST Home CREATE CONVERSION Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
