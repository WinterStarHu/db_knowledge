# PostgreSQL: Documentation: 18: 3.3. Foreign Keys

PostgreSQL: Documentation: 18: 3.3. Foreign Keys Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
/
7.4
/
7.3
/
7.2
3.3. Foreign Keys
Prev Up Chapter 3. Advanced Features Home Next
3.3. Foreign Keys #
Recall the weather and cities tables from Chapter 2. Consider the following problem: You want to make sure that no one can insert rows in the weather table that do not have a matching entry in the cities table. This is called maintaining the referential integrity of your data. In simplistic database systems this would be implemented (if at all) by first looking at the cities table to check if a matching record exists, and then inserting or rejecting the new weather records. This approach has a number of problems and is very inconvenient, so PostgreSQL can do this for you.
The new declaration of the tables would look like this:
CREATE TABLE cities ( name     varchar(80) primary key, location point );
CREATE TABLE weather ( city      varchar(80) references cities(name), temp_lo   int, temp_hi   int, prcp      real, date      date );
Now try inserting an invalid record:
INSERT INTO weather VALUES ('Berkeley', 45, 53, 0.0, '1994-11-28');
ERROR:  insert or update on table "weather" violates foreign key constraint "weather_city_fkey" DETAIL:  Key (city)=(Berkeley) is not present in table "cities".
The behavior of foreign keys can be finely tuned to your application. We will not go beyond this simple example in this tutorial, but just refer you to Chapter 5 for more information. Making correct use of foreign keys will definitely improve the quality of your database applications, so you are strongly encouraged to learn about them.
Prev Up Next
3.2. Views
Home
3.4. Transactions
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
