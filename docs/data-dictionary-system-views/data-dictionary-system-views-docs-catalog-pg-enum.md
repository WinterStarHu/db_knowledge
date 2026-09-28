# PostgreSQL: Documentation: 18: 52.20. pg_enum

PostgreSQL: Documentation: 18: 52.20. pg_enum Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
52.20. pg_enum
Prev Up Chapter 52. System Catalogs Home Next
52.20. pg_enum #
The pg_enum catalog contains entries showing the values and labels for each enum type. The internal representation of a given enum value is actually the OID of its associated row in pg_enum.
Table 52.20. pg_enum Columns Column Type Description oid oid Row identifier enumtypid oid (references pg_type.oid) The OID of the pg_type entry owning this enum value enumsortorder float4 The sort position of this enum value within its enum type enumlabel name The textual label for this enum value The OIDs for pg_enum rows follow a special rule: even-numbered OIDs are guaranteed to be ordered in the same way as the sort ordering of their enum type. That is, if two even OIDs belong to the same enum type, the smaller OID must have the smaller enumsortorder value. Odd-numbered OID values need bear no relationship to the sort order. This rule allows the enum comparison routines to avoid catalog lookups in many common cases. The routines that create and alter enum types attempt to assign even OIDs to enum values whenever possible.
When an enum type is created, its members are assigned sort-order positions 1..n. But members added later might be given negative or fractional values of enumsortorder. The only requirement on these values is that they be correctly ordered and unique within each enum type.
Prev Up Next
52.19. pg_description
Home
52.21. pg_event_trigger
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
