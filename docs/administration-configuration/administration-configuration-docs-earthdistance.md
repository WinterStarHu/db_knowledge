# PostgreSQL: Documentation: 18: F.14. earthdistance — calculate great-circle distances

PostgreSQL: Documentation: 18: F.14. earthdistance — calculate great-circle distances Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
F.14. earthdistance — calculate great-circle distances Prev Up Appendix F. Additional Supplied Modules and Extensions Home Next F.14. earthdistance — calculate great-circle distances # F.14.1. Cube-Based Earth Distances F.14.2. Point-Based Earth Distances The earthdistance module provides two different approaches to calculating great circle distances on the surface of the Earth. The one described first depends on the cube module. The second one is based on the built-in point data type, using longitude and latitude for the coordinates.
In this module, the Earth is assumed to be perfectly spherical. (If that's too inaccurate for you, you might want to look at the PostGIS project.) The cube module must be installed before earthdistance can be installed (although you can use the CASCADE option of CREATE EXTENSION to install both in one command).
Caution It is strongly recommended that earthdistance and cube be installed in the same schema, and that that schema be one for which CREATE privilege has not been and will not be granted to any untrusted users. Otherwise there are installation-time security hazards if earthdistance's schema contains objects defined by a hostile user. Furthermore, when using earthdistance's functions after installation, the entire search path should contain only trusted schemas.
F.14.1. Cube-Based Earth Distances # Data is stored in cubes that are points (both corners are the same) using 3 coordinates representing the x, y, and z distance from the center of the Earth. A domain earth over type cube is provided, which includes constraint checks that the value meets these restrictions and is reasonably close to the actual surface of the Earth.
The radius of the Earth is obtained from the earth() function. It is given in meters. But by changing this one function you can change the module to use some other units, or to use a different value of the radius that you feel is more appropriate.
This package has applications to astronomical databases as well. Astronomers will probably want to change earth() to return a radius of 180/pi() so that distances are in degrees.
Functions are provided to support input in latitude and longitude (in degrees), to support output of latitude and longitude, to calculate the great circle distance between two points and to easily specify a bounding box usable for index searches.
The provided functions are shown in Table F.4.
Table F.4. Cube-Based Earthdistance Functions Function Description earth () → float8 Returns the assumed radius of the Earth.
sec_to_gc ( float8 ) → float8 Converts the normal straight line (secant) distance between two points on the surface of the Earth to the great circle distance between them.
gc_to_sec ( float8 ) → float8 Converts the great circle distance between two points on the surface of the Earth to the normal straight line (secant) distance between them.
ll_to_earth ( float8, float8 ) → earth Returns the location of a point on the surface of the Earth given its latitude (argument 1) and longitude (argument 2) in degrees.
latitude ( earth ) → float8 Returns the latitude in degrees of a point on the surface of the Earth.
longitude ( earth ) → float8 Returns the longitude in degrees of a point on the surface of the Earth.
earth_distance ( earth, earth ) → float8 Returns the great circle distance between two points on the surface of the Earth.
earth_box ( earth, float8 ) → cube Returns a box suitable for an indexed search using the cube @> operator for points within a given great circle distance of a location. Some points in this box are further than the specified great circle distance from the location, so a second check using earth_distance should be included in the query.
F.14.2. Point-Based Earth Distances # The second part of the module relies on representing Earth locations as values of type point, in which the first component is taken to represent longitude in degrees, and the second component is taken to represent latitude in degrees. Points are taken as (longitude, latitude) and not vice versa because longitude is closer to the intuitive idea of x-axis and latitude to y-axis.
A single operator is provided, shown in Table F.5.
Table F.5. Point-Based Earthdistance Operators Operator Description point  point → float8 Computes the distance in statute miles between two points on the Earth's surface.
Note that unlike the cube-based part of the module, units are hardwired here: changing the earth() function will not affect the results of this operator.
One disadvantage of the longitude/latitude representation is that you need to be careful about the edge conditions near the poles and near +/- 180 degrees of longitude. The cube-based representation avoids these discontinuities.
Prev Up Next F.13. dict_xsyn — example synonym full-text search dictionary Home F.15. file_fdw — access data files in the server's file system Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
