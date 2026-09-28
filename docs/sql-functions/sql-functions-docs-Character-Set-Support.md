# Character Set Support

Oracle supports most national, international, and vendor-specific encoded character set standards. A complete list of character sets supported by Oracle appears in *Oracle Database Globalization Support Guide*.
Unicode is a universal encoded character set that lets you store information from any language using a single character set. Unicode is required by modern standards such as XML, Java, JavaScript, and LDAP. Unicode is compliant with ISO/IEC standard 10646. For information on ISO standards, visit the Web site of the International Organization for Standardization:
```
http://www.iso.ch/
```
Oracle Database 18*c* complies with version 9.0 of the Unicode Standard. For up-to-date information on the Unicode Standard, visit the Web site of the Unicode Consortium:
```
http://www.unicode.org
```
Oracle supports the UTF-8 encoding scheme of the Unicode Standard through the AL32UTF8 character set, the UTF-16BE encoding scheme through the AL16UTF16 character set, and the UTF-16LE encoding scheme through the AL16UTF16LE character set. AL32UTF8 is valid as the client and database character set on ASCII-based platforms. AL16UTF16 is valid as the national (`NCHAR`) character set on all platforms. AL16UTF16LE is not valid as the client, database, or national character set.
Oracle implements two deprecated Unicode compatibility encoding forms: CESU-8 through the UTF8 character set and UTF-EBCDIC through the UTFE character set. The UTF8 and UTFE character sets are not guaranteed to include updates to the Unicode standard beyond version 3.0. UTF8 is valid as the client and database character set on ASCII-based platforms and as the national (`NCHAR`) character set on all platforms. UTFE is valid as the database character set on EBCDIC-based platforms.
All mentioned Oracle character sets are supported in conversion functions.
Oracle recommends that databases on ASCII-based platforms are created with the AL32UTF8 character set and the AL16UTF16 national (`NCHAR`) character set. Oracle recommends that you avoid the use of the `NCHAR` data types and the associated national character set as they are not supported by some RDBMS components, such as Oracle Text and Oracle XDB.
**See Also:**   *Oracle Database Globalization Support Guide* for details on Oracle character set support
