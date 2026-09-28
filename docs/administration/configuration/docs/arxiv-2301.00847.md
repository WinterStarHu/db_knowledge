# Popularity Ranking of Database Management Systems

> 来源: https://arxiv.org/pdf/2301.00847

Popularity Ranking of Database Management
Systems
Aleem Akhtar
Dept. of Computer Science
Virtual University of Pakistan
aleem.akhtar@seecs.edu.pk
Abstract—Databases are considered to be integral part of mod-
ern information systems. Almost every web or mobile application
uses some kind of database. Database management systems are
considered to be a crucial element from both business and techno-
logical standpoint. This paper divides different types of database
management systems into two main categories (relational and
non-relational) and several sub categories. Ranking of various
sub categories for the month of July, 2021 are presented in the
form of popularity score calculated and managed by DB-Engines.
Popularity trend for each category is also presented to look at
the change in popularity since 2013. Complete ranking and trend
of top 20 systems has shown that relational models are still most
popular systems with Oracle and MySQL being two most popular
systems. However, recent trends have shown DBMSs like Time
Series and Document Store getting more and more popular with
their wide use in IOT technology and BigData, respectively.
Index Terms—DBMS, Ranking, NoSQL
I. INTRODUCTION
Databases are considered to be integral part of modern
information systems. Almost every web or mobile application
uses some kind of database. Databases are ubiquitously used in
data centers and to maintain records in educational institutes,
medical and healthcare systems, and all kinds of private and
government institutions. Database and database management
system (DBMS) are two distinct things. Organized collection
of data is called database while DBMS on the other hand is
a software which interacts with the database and acts as an
interface between the user and database. But database term is
usually used to refer to both the DBMS and database itself
[1].
The DBMSs with their accompanying data communications
systems, has made possible for users from all industries to
develop both batch and online applications in a cost effective
and timely manner. These database systems has served as base
for most of the applications in every government agency and
industry. These systems were driving force behind the sale
of mainframe computers during the 1970s. Historians and
industry analysts consider DBMS a crucial part from both
business and technological standpoint [2]. Some of the reasons
supplied by analysts are:
• An efﬁcient and cost effective method to program com-
plex applications is provided by DBMS without rewriting
the data retrieval and access functions for each applica-
tion.
• A simple and standard way is provided by them to share
data among multiple users and multiple applications.
• Specialized user-oriented languages were created.
• Standard interfaces are provided by DBMSs for data
communication programs so that the development, test-
ing, and maintenance of online transaction processing
applications could be done efﬁciently in terms of time
and cost.
• Databases are easily managed on various sequential and
random-access devices without the application program-
mer to think about difference between them.
• Portability is provided i.e. enabling users to move appli-
cations from one operating system or platform to other
with an ease.
• Companies marketing these systems became largest inde-
pendent software products companies in the late 1970s.
• A tremendous amount of hardware was sold by IBM and
many independent storage device and terminal compa-
nies.
Rest of the paper is divided into four sections. The ﬁrst
section provides a brief description on different types of
database systems followed by ranking and trends in the second
section. The third section presents analysis on ranking and
trends. The fourth and last section concludes the paper.
II. TYPES OF DATASE MANAGEMENT SYSTEMS
Database management systems can be generally divided into
two main categories: relational database management systems
or RDMBS that supports relational data model, and in case
it supports other data models are often subsumed as NoSQL
systems. However, there are different subcategories of each
DBMS and a complete hierarchy is given in Figure 1.
As mentioned earlier, DBMSs can be divided into two broad
categories i.e. relational and non-relational. Each category with
subcategory is explained below.
A. Relational DBMSs
Relational database management systems support the rela-
tional or table-oriented data model with a pre-deﬁned database
schema. Each table/relation has a unique name in the database
and ﬁxed number of attributes (columns) with ﬁxed data types.
Each row in the table deﬁnes a unique record. Normalization
is used to generate table schemas during the data modeling
process. Relational DBMS allows different types of operations
arXiv:2301.00847v1  [cs.DB]  2 Jan 2023

---

DBMSs
Relational
Traditional
RDBMS
Advanced
OODBMS
Multivalue
Non-Relational
Spatial
Temporal
Time Series
Event Stores
NoSQL
Key-
Value
Wide 
Column
Documen
t
Graph
RDF
Native 
XML
Content 
Stores
Search 
Engines
Fig. 1. Types of DBMSs
such as classical set operations (intersection, union, and differ-
ence), Selection, Projection, and Joins. Some other operations
to create, modify, delete table schemas, user management,
and transaction controlling are also performed. These basic
and advanced operations are performed using some kind of
database language, with Structured Query Language (SQL)
being well-established standard [3].
RDBMS have been most common types of DBMS type
since they were ﬁrst introduced in the early 1980s. Over the
years, relational databases have been expanded with advanced
non-relational concepts such as non-atomic values (multi-
valued), hierarchies, inheritance, and user-deﬁned data types
which are sometimes referred to as object-oriented database
management systems (OODBMS) [4].
Most popular examples of traditional RDBMS are: Oracle
[5][6], MySQL [7][8], Microsoft SQL Server [9][10], Post-
greSQL [11][12], and IBM Db2 [13][14].
1) Object Oriented DBMS: In the 1980s, common use of
object-oriented programming languages motivated the devel-
opment of object-oriented database management systems or
simply object databases. Main objective behind introduction
of OODBMS was to store the objects and their relationships
(inheritance) in the database in a way that relates to their rep-
resentation in the programming language, without converting
or decomposing them [15].
An OODBMS thus follows an object-oriented data model
with methods, properties, and classes (objects schema). An
object is always managed as a whole. In other words, insertion
or reading of object is done in one atomic operation which in
relational model will take multiple tables to store that object
and complex joins to retrieve it. To perform these operations,
a query language similar to SQL is used for manipulation of
objects in OODBMS.
Most popular examples of OODBMS are InterSystems
Cach´e [16], Db4o [17], InterSystems IRIS [18], ObjectStore
[19], and Actian NoSQL Database [20].
2) Multivalue DBMS: Multivalue DBMS are similar to
traditional relational systems and store data in tables. However,
major difference between multivalue DBMS and traditional
RDBMS is that they have ﬂexibility of storing multiple (non-
atomic) values to one attribute. These are often called non-ﬁrst
normal form or NF2 systems as storing non-atomic values
contradicts the condition for ﬁrst normal form.
Most popular examples of multivalue DBMS are Adabas
[21], UniData,UniVerse [22], jBASE [23], Model 204 [24],
and D3 [25].
B. Non-Relational DBMS
Non-relational DBMS are further divided into three subcat-
egories. Each of them is brieﬂy explained.
1) NoSQL: NoSQL database systems do not use a relational
data model like RDBMS and generally have no SQL interface.
NoSQL databases have been in existence for many years but
the term NoSQL was ﬁrst introduced in 2009 when many
new systems were developed in order to cope with the new
requirements for DBMS at that time e.g. scalability, Big Data,
and fault tolerance [26]. Big Data has been at the heart of
development of these types of databases. Apache Science
Foundation has played one of the most important role in Big
Data projects [27].
NoSQL systems are a heterogeneous group of very different
database systems. Therefore every effort of classiﬁcation fails
in classifying one or another system. However, the following
categories are well accepted:
• Search Engines
• Content Stores
• Native XML DBMS
• RDF Stores
• Graph DBMS
• Document Stores
• Wide Column Stores
• Key-Value Stores

---

Purpose of the paper is to look at the trends of database
systems, therefore explanation of each system is skipped.
2) Spatial DBMS:
Spatial DBMS is different type of
DBMS that can efﬁciently store, query, and manipulate spatial
data. Objects in geometric space such as polygons and points
are represented by spatial data. Dedicated data types and
spatial indices are provided by spatial DBMSs to optimize
the storing and access of spatial data [28].
Spatial DBMSs provide features of intersecting or merging
objects, computing distances, and calculating properties of
objects such as areas. Geospatial data are an important subset
of spatial data that deals with the locations on surface of Earth.
Geographic Information Systems (GIS) are able to work with
geospatial data [29]. In some cases, spatial data is combined
with temporal data to form spatio-temporal data that offers
more dimensions to store and manipulate data.
Most popular examples of Spatial DBMS are PostGIS [30],
SpatiaLite [31], and GeoMesa [32].
3) Temporal DBMS: Temporal DBMS deals with the data
related to timestamps or events. Temporal DBMS are classiﬁed
into two categories i.e. Time Series DBMS and Event Stores.
A Time Series DBMS is a database management system that
is optimized for handling time series data: each entry is as-
sociated with a timestamp [33]. For example, time series data
may be produced by smart meters, sensors, or RFIDs in the
IoT. Time Series DBMS are aimed to efﬁciently gather, save
and query various time series with high transaction volumes.
While time series data can be managed with other categories of
DBMS i.e. key-value stores or relational systems, specialized
systems are often required to handle speciﬁc challenges. Most
popular DBMSs in this subcategory are: InﬂuxDB [34], Kdb+
[35], and Prometheus [36].
Event stores are database management systems that imple-
ment the event sourcing concepts. All state changing events
for an object are preserved by these systems with a timestamp.
To inferred current state of an object, all the events from time
0 to current time are replayed. On the other hand, other types
of DBMS lose the history of previous states if not modelled
explicitly. IBM Db2 is most popular system in this category
[37].
III. RANKING AND TRENDS
A. Method to calculate score
DB-Engines website is used as source for all the ranking
and trends screenshots. DB-Engines uses a custom formula to
calculate a normalized score to rank popular database man-
agement systems [38]. Popularity ranking does not measure
the DBMSs use within IT systems or the total number of
installations on the systems. However, popularity score relate
to broad use of a certain system. Following parameters are
used by the DB-Engines ranking system to calculate popularity
score:
• Number of job offers in which system is mentioned on
Indeed and Simply Hired websites.
• Frequency of the searches in Google Trends
• Number of search results in the Google and Bing search
engines for particular system
• Frequency of the technical discussion on Stack Overﬂow
and DBA Stack Exchange
• Number of proﬁles on LinkedIn with the mention of
certain system
• Number of tweets where certain system is mentioned
using Hashtag
B. Ranking and Trends by Type
In this section, we present ranking of top 5 most popular
database management systems by each type for July, 2021.
Trends display popularity of these systems from November
2012 to July, 2021. Logarithmic scale is used to display
popularity score.
1) Relational DBMS: Table I presents ranking of top 5
relational DBMS for the month of July, 2021 [39]. Oracle
being the most popular system followed by MySQL at second
rank. Score for these two systems is very close to each other
showing how popular these two systems are.
TABLE I
RANKING OF RELATIONAL DBMS
Rank
DBMS
Score
1
Oracle
1262.66
2
MySQL
1228.38
3
Microsoft SQL Server
981.95
4
PostgreSQL
577.15
5
IBM Db2
165.15
Figure 2 shows popularity trend of top ﬁve relational
database management systems. Oracle, MySQL, and Microsoft
SQL Server have been competing for top spot since 2013.
Popularity of PostgreSQL has been on constant rise and is
getting closer to the top systems.
2) Object Oriented DBMS: Table II presents ranking of top
5 Object Oriented DBMS for the month of July, 2021 [40]. A
very low score of these systems show that they are still not
very popular as other relational systems and it might take a
long time to be globally adopted by industry and academia.
TABLE II
RANKING OF OBJECT ORIENTED DBMS
Rank
DBMS
Score
1
InterSystems Cach´e
2.86
2
Db4o
1.71
3
InterSystems IRIS
1.7
4
ObjectStore
1.48
5
Actian NoSQL Database
1.4
Figure 3 shows popularity trend of top ﬁve Object Oriented
database management systems. It can be clearly see in the
graph that all systems in this category have average popularity
score between 1 and 2, and nothing can be said sure about
which system is more popular than other.
3) Multivalue DBMS: Table III presents ranking of top 5
Multivalue DBMS for the month of July, 2021 [41]. Similar
to OODBMSs, a very low score of these systems show that

---

they are also not very popular as other relational systems and
it can be said that they are still in developmental phases.
TABLE III
RANKING OF MULTIVALUE DBMS
Rank
DBMS
Score
1
Adabas
4.46
2
UniData,UniVerse
3.87
3
jBASE
1.82
4
Model 204
1.24
5
D3
1.23
Figure 4 shows popularity trend of top ﬁve Multivalue
database management systems. It can be clearly see in the
graph that all systems in this category have average popularity
score between 1 and 2, and nothing can be said for sure about
which system is more popular than other.
4) Key-Value Stores: Table IV presents ranking of top 5
Key-Value Store DBMS for the month of July, 2021 [42].
Redis is most popular system from this category with popu-
larity score being more than double compared to second spot
Amazon DynamoDB. Score for last three systems is very close
to each other but difference between Redis and other systems
is very high at this time.
TABLE IV
RANKING OF KEY-VALUE STORES DBMS
Rank
DBMS
Score
1
Redis
168.31
2
Amazon DynamoDB
75.2
3
Microsoft Azure Cosmos DB
36.7
4
Memcached
25.34
5
etcd
10.1
Figure 5 shows popularity trend of top ﬁve Key-Value Store
database management systems. Even though Redis has been
on the top of popularity chart since 2013 but systems from the
Amazon and Microsoft have been on constant rise while on
the other hand Memcached is slowly decreasing in popularity.
5) Document Store: Table V presents ranking of top 5
Document Store DBMS for the month of July, 2021 [43]. Mon-
goDB is by far the most popular Document Store DBMS with
the popularity score of nearly 500. Amazon DynamoDB and
Microsoft Azure Cosmos DB which are also Key-Value Store
systems as well come at second and third place respectively.
TABLE V
RANKING OF DOCUMENT STORE DBMS
Rank
DBMS
Score
1
MongoDB
496.16
2
Amazon DynamoDB
75.2
3
Microsoft Azure Cosmos DB
36.7
4
Couchbase
28.46
5
Firebase Realtime Database
17.23
Figure 6 shows popularity trend of top ﬁve Document
Store database management systems. MongoDB has been on
constant rise in popularity since its introduction but other
Document Store DBs have started to gain popularity, Firebase
Realtime Database by Google is one of them.
6) Wide Column Store: Table VI presents ranking of top
5 Wide Column Store DBMS for the month of July, 2021
[44]. Cassandra being the most popular system followed by
HBase at second rank. Score of Cassandra is higher than next
four systems combined which shows how popular it is for this
category.
TABLE VI
RANKING OF WIDE COLUMN STORE DBMS
Rank
DBMS
Score
1
Cassandra
114
2
HBase
44.07
3
Microsoft Azure Cosmos DB
36.7
4
Datastax Enterprise
7.52
5
Microsoft Azure Table Storage
5.09
Figure 7 shows popularity trend of top ﬁve Wide Column
Store database management systems. Oracle and HBase have
been competing for top spot since 2013. Popularity of Mi-
crosoft Azure Cosmos DB has been on constant rise since its
introduction in 2015 and is getting closer to the top systems.
7) Graph DBMS: Table VII presents ranking of top 5 Graph
DBMS for the month of July, 2021 [45]. Neo4j is most popular
system from this category with popularity score being higher
than next four systems combined. Score for last three systems
is very close to each other but difference between Neo4j and
other systems is very high at this time.
TABLE VII
RANKING OF GRAPH DBMS
Rank
DBMS
Score
1
Neo4j
57.16
2
Microsoft Azure Cosmos DB
36.7
3
ArangoDB
4.73
4
OrientDB
4.16
5
Virtuoso
4.01
Figure 8 shows popularity trend of top ﬁve Graph database
management systems. Even though Neo4j has been on the top
of popularity chart since 2013 but system from the Microsoft
has been on constant rise and getting closer to the most popular
system in this category while on the other hand all other
systems are slowly decreasing in popularity.
8) Search Engines: Table VIII presents ranking of top
5 Search Engine DBMS for the month of July, 2021 [46].
ElasticSearch is by far the most popular Document Store
DBMS with the popularity score of nearly 156. Splunk and
Solr come at second and third place respectively followed by
MarkLogic and Sphnix at last two spots.
Figure 9 shows popularity trend of top ﬁve Search Engine
database management systems. Solr used to be most popular
system in this category but it was overtaken by ElasticSearch
at the start of 2016. Increase in popularity of Splunk made it
second most popular system in January 2018.
9) Ranking of Top 20: Table IX presents complete ranking
of top 20 database management systems for July, 2021 [55].
It can be seen that Oracle and MySQL are top 2 ranked
systems with the score of above 1200. Microsoft SQL Server

---

Fig. 2. Trend of Relational DBMS [47]
Fig. 3. Trend of Object Oriented DBMS [48]
Fig. 4. Trend of Multivalue DBMS [49]
Fig. 5. Trend of Key-Value Stores DBMS [50]
Fig. 6. Trend of Document Store DBMS [51]
Fig. 7. Trend of Wide Column Store DBMS [52]
Fig. 8. Trend of Graph DBMS [53]
Fig. 9. Trend of Search Engines DBMS [54]

---

TABLE VIII
RANKING OF SEARCH ENGINES DBMS
Rank
DBMS
Score
1
Elasticsearch
155.76
2
Splunk
90.05
3
Solr
51.79
4
MarkLogic
9.45
5
Sphinx
8
is ranked third followed by PostgreSQL at fourth. All of these
top 4 are relational systems which shows the importance of
this category. In fact, 12 of the top 20 are relational systems.
3 of them are Search Engines, and one each of Key-Value,
Document, Wide Column, and Graph. Amazon Dynamo DB
is one system which is a multi-model system. Popularity score
difference between MongoDB at 5 and Redis at 6 shows that
top 5 are solid at these positions for foreseeable future.
TABLE IX
RANKING OF TOP 20 DBMS
Rank
DBMS
Score
Type
1
Oracle
1262.66
Relational
2
MySQL
1228.38
Relational
3
Microsoft SQL Server
981.95
Relational
4
PostgreSQL
577.15
Relational
5
MongoDB
496.16
Document
6
Redis
168.31
Key-value
7
IBM Db2
165.15
Relational
8
Elasticsearch
155.76
Search engine
9
SQLite
130.2
Relational
10
Cassandra
114
Wide column
11
Microsoft Access
113.45
Relational
12
MariaDB
97.98
Relational
13
Splunk
90.05
Search engine
14
Hive
82.68
Relational
15
Microsoft Azure SQL Database
75.22
Relational
16
Amazon DynamoDB
75.2
Multi-model
17
Teradata
68.95
Relational
18
Neo4j
57.16
Graph
19
SAP HANA
53.81
Relational
20
Solr
51.79
Search engine
Figure 10 presents popularity trend of top 20 database
management systems since 2013. A close competition can
be seen between Oracle, MySQL, and Microsoft SQL Server
from the beginning of 2013. However, SQL Server has been
on slight decrease in popularity and the gap is getting wider.
Popularity of PostgreSQL is on constant rise and getting closer
to SQL Server. MongoDB has become one of the fasted
growing document store system which shows the interest from
the developers community in model different than relational.
IV. ANALYSIS
This section breaks down the popularity of database man-
agement systems by model and provides a brief analysis.
A. Number of systems per category
Figure 11 presents number of systems of per category.
There are total 373 database management systems of which
40% are relational systems followed by 17% of Key-value
Fig. 10. Trend of Top 20 DBMS [56]
stores. Relational DBMS, Document stores, and key-value
stores comprise of total 262 systems (70%) out of 373.
Fig. 11. Number of Systems Per Category [57]
B. Ranking score per category
Figure 12 shows ranking score per category in percentage
for July, 2021. Popularity score of all individual systems for
each category is used to calculate total percentage. As Table
IX showed that Oracle, MySQL, and MS SQL Server makes
highest score for all relational systems therefore this is also
depicted in Figure 12 where relational DBMS have 72.7%
of total popularity. Document stores are other set of systems
which are getting popular with MongoDB being most popular
of them all.
Fig. 12. Ranking Score Per Category [57]
C. Popularity Changes
The following set of charts show the historical trend of the
categories’ popularity. In the ranking of each month the best

---

three systems per category are chosen and the average of their
ranking scores is calculated. In order to allow comparisons,
the initial value is normalized to 100.
1) Complete Popularity Trend: The chart in 13 shows
that Graph DBMS has been on constant rise in popularity
because of their main use in social networking websites such
as Facebook, Twitter, and TikTok. Time Series systems are
another type of DBMSs which have gain popularity in recent
times due to advancements in IOT technology.
Fig. 13. Complete Popularity Trend [57]
2) Trend for last 24 months: This chart 14 shows change
in popularity trend for last 24 months. As mentioned earlier,
Time Series DBMS has seen rise in popularity in recent times
due to their use in Internet of Things. Relational systems on
the other hand are at the same level of popularity as in July
2019. However, DBMS like Native XML and RDF stores are
on decline.
Fig. 14. Trend for last 24 months [57]
V. CONCLUSION AND FUTURE WORK
Databases are considered to be integral part of modern
information systems. Almost every web or mobile application
uses some kind of database. Database management systems
are considered to be a crucial element from both business and
technological standpoint. This paper divided different types
of database management systems into two main categories
i.e. relational and non-relational and several sub categories.
Ranking of various sub categories for the month of July, 2021
are presented in the form of popularity score calculated and
managed by DB-Engines. Popularity trend for each category is
also presented to look at the change in popularity since 2013.
Complete ranking and trend of top 20 systems has shown that
relational models are still most popular systems comprising of
12 systems in the top 20 with top 4 all being relational systems.
Relational DBMS also make the most number of systems and
highest percentage in popularity. Oracle and MySQL being
two most popular systems. However, recent trends have shown
DBMSs like Time Series and Document Store getting more
and more popular with their wide use in IOT technology and
BigData, respectively.
Future work can include deep analysis of each category
with more focus on last 24 months. A comparative analysis
for Document Store systems versus Relational systems can
present with the results on whether systems like MongoDB
and Google Firebase can challenge hugely popular systems
like Oracle and MySQL. It will also be an interesting to divide
the systems into commercial and open-source categories and
then looking at popularity ranking and trends.
REFERENCES
[1] H. Alzahrani, “Evolution of object-oriented database systems,” Global
Journal of Computer Science and Technology, 2016.
[2] B. Grad and T. J. Bergin, “Guest editors’ introduction: History of
database management systems,” IEEE Annals of the History of Com-
puting, vol. 31, no. 4, pp. 3–5, 2009.
[3] S. Sumathi and S. Esakkirajan, Fundamentals of relational database
management systems.
Springer, 2007, vol. 47.
[4] B. Grad, “Relational database management systems: The formative years
[guest editor’s introduction],” IEEE Annals of the History of Computing,
vol. 34, no. 4, pp. 7–8, 2012.
[5] R. Greenwald, R. Stackowiak, and J. Stern, Oracle essentials: Oracle
database 12c.
” O’Reilly Media, Inc.”, 2013.
[6] “Oracle,”
last
Accessed:
July,
2021.
[Online].
Available:
https:
//www.oracle.com/database/
[7] M. Widenius, D. Axmark, and K. Arno, MySQL reference manual:
documentation from the source.
” O’Reilly Media, Inc.”, 2002.
[8] “Mysql,”
last
Accessed:
July,
2021.
[Online].
Available:
https:
//www.mysql.com/
[9] R. Mistry and S. Misner, Introducing Microsoft SQL Server 2014.
Microsoft Press, 2014.
[10] “Microsoft sql server,” last Accessed: July, 2021. [Online]. Available:
https://www.microsoft.com/en-us/sql-server/
[11] B. Momjian, PostgreSQL: introduction and concepts.
Addison-Wesley
New York, 2001, vol. 192.
[12] “Postgresql,” last Accessed: July, 2021. [Online]. Available: https:
//www.postgresql.org/
[13] J. S. Karlsson, A. Lal, C. Leung, and T. Pham, “Ibm db2 everyplace:
A small footprint relational database system,” in Proceedings 17th
International Conference on Data Engineering.
IEEE, 2001, pp. 230–
232.
[14] “Ibm db2,” last Accessed: July, 2021. [Online]. Available: https:
//www.ibm.com/analytics/db2
[15] K. L. Berg, T. Seymour, R. Goel et al., “History of databases,”
International Journal of Management & Information Systems (IJMIS),
vol. 17, no. 1, pp. 29–36, 2013.
[16] “Intersystems cach´e,” last Accessed: July, 2021. [Online]. Available:
https://www.intersystems.com/products/cache/
[17] “Db4o,”
last
Accessed:
July,
2021.
[Online].
Available:
https:
//sourceforge.net/projects/db4o/
[18] “Intersystems iris,” last Accessed: July, 2021. [Online]. Available:
https://www.intersystems.com/products/intersystems-iris/
[19] “Objectstore,” last Accessed: July, 2021. [Online]. Available: https:
//ignitetech.com/objectstore/
[20] Actian, “Actian nosql,” last Accessed: July, 2021. [Online]. Available:
https://www.actian.com/data-management/nosql-object-database/
[21] S. AG, “Adabas,” last Accessed: July, 2021. [Online]. Available:
https://www.softwareag.com/en corporate/platform/adabas-natural.html
[22] R. Software, “Unidata,universe,” last Accessed: July, 2021. [Online].
Available: https://www.rocketsoftware.com/products/rocket-u2
[23] Zumasys, “jbase,” last Accessed: July, 2021. [Online]. Available:
https://www.jbase.com/

---

[24] “Model 204,” last Accessed: July, 2021. [Online]. Available: https:
//www.rocketsoftware.com/products/rocket-m204
[25] “D3,” last Accessed: July, 2021. [Online]. Available: https://www.
rocketsoftware.com/products/rocket-d3
[26] R. P. Padhy, M. R. Patra, and S. C. Satapathy, “Rdbms to nosql:
reviewing some next-generation non-relational database’s,” International
Journal of Advanced Engineering Science and Technologies, vol. 11,
no. 1, pp. 15–30, 2011.
[27] A. Akhtar, “Role of apache software foundation in big data projects,”
arXiv preprint arXiv:2005.02829, 2020.
[28] S. Shekhar, Spatial databases.
Pearson Education India, 2007.
[29] P. Rigaux, M. Scholl, and A. Voisard, Spatial databases: with applica-
tion to GIS.
Elsevier, 2001.
[30] “Postgis,”
last
Accessed:
July,
2021.
[Online].
Available:
https:
//postgis.net/
[31] A. Furieri, “Spatialite,” last Accessed: July, 2021. [Online]. Available:
https://www.gaia-gis.it/fossil/libspatialite/index
[32] CCRi et al., “Geomesa,” last Accessed: July, 2021. [Online]. Available:
https://www.geomesa.org/
[33] D. Namiot, “Time series databases.” DAMDID/RCDL, vol. 1536, pp.
132–137, 2015.
[34] “Inﬂuxdb,” last Accessed: July, 2021. [Online]. Available: https:
//www.inﬂuxdata.com/products/inﬂuxdb-overview/
[35] a. d. o. F. D. p. Kx Systems, “Kdb+,” last Accessed: July, 2021.
[Online]. Available: https://kx.com/
[36] “Prometheus,” last Accessed: July, 2021. [Online]. Available: https:
//prometheus.io/
[37] C. Garcia-Arellano, H. Roumani, R. Sidle, J. Tiefenbach, K. Rakopoulos,
I. Sayyid, A. Storm, R. Barber, F. Ozcan, D. Zilio et al., “Db2 event
store: a purpose-built iot database engine,” Proceedings of the VLDB
Endowment, vol. 13, no. 12, pp. 3299–3312, 2020.
[38] DB-Engines, “Method of calculating the scores of the db-engines
ranking,” Jul. 2021, last Accessed: July, 2021. [Online]. Available:
https://db-engines.com/en/ranking deﬁnition
[39] “Db-engines ranking of relational dbms,” Jul. 2021, last Accessed: July,
2021. [Online]. Available: https://db-engines.com/en/ranking/relational+
dbms
[40] “Db-engines
ranking
of
object
oriented
dbms,”
Jul.
2021,
last
Accessed: July, 2021. [Online]. Available: https://db-engines.com/en/
ranking/object+oriented+dbms
[41] “Db-engines ranking of multivalue dbms,” Jul. 2021, last Accessed:
July,
2021.
[Online].
Available:
https://db-engines.com/en/ranking/
multivalue+dbms
[42] “Db-engines ranking of key-value stores,” Jul. 2021, last Accessed:
July,
2021.
[Online].
Available:
https://db-engines.com/en/ranking/
key-value+store
[43] “Db-engines ranking of document stores,” Jul. 2021, last Accessed:
July,
2021.
[Online].
Available:
https://db-engines.com/en/ranking/
document+store
[44] “Db-engines ranking of wide column stores,” Jul. 2021, last Accessed:
July,
2021.
[Online].
Available:
https://db-engines.com/en/ranking/
wide+column+store
[45] “Db-engines ranking of graph dbms,” Jul. 2021, last Accessed: July,
2021. [Online]. Available: https://db-engines.com/en/ranking/graph+
dbms
[46] “Db-engines ranking of search engines,” Jul. 2021, last Accessed: July,
2021. [Online]. Available: https://db-engines.com/en/ranking/search+
engine
[47] “Db-engines ranking - trend of relational dbms popularity,” Jul. 2021,
last Accessed: July, 2021. [Online]. Available: https://db-engines.com/
en/ranking trend/relational+dbms
[48] “Db-engines ranking - trend of object oriented dbms popularity,”
Jul. 2021, last Accessed: July, 2021. [Online]. Available: https:
//db-engines.com/en/ranking trend/object+oriented+dbms
[49] “Db-engines ranking - trend of multivalue dbms popularity,” Jul. 2021,
last Accessed: July, 2021. [Online]. Available: https://db-engines.com/
en/ranking trend/multivalue+dbms
[50] “Db-engines ranking - trend of key-value stores popularity,” Jul. 2021,
last Accessed: July, 2021. [Online]. Available: https://db-engines.com/
en/ranking trend/key-value+store
[51] “Db-engines ranking - trend of document stores popularity,” Jul. 2021,
last Accessed: July, 2021. [Online]. Available: https://db-engines.com/
en/ranking trend/document+store
[52] “Db-engines ranking - trend of wide column stores popularity,”
Jul. 2021, last Accessed: July, 2021. [Online]. Available: https:
//db-engines.com/en/ranking trend/wide+column+store
[53] “Db-engines ranking - trend of graph dbms popularity,” Jul. 2021, last
Accessed: July, 2021. [Online]. Available: https://db-engines.com/en/
ranking trend/graph+dbms
[54] “Db-engines ranking - trend of search engines popularity,” Jul. 2021,
last Accessed: July, 2021. [Online]. Available: https://db-engines.com/
en/ranking trend/search+engine
[55] “Db-engines ranking,” Jul. 2021, last Accessed: July, 2021. [Online].
Available: https://db-engines.com/en/ranking
[56] “Db-engines ranking - trend popularity,” Jul. 2021, last Accessed: July,
2021. [Online]. Available: https://db-engines.com/en/ranking trend
[57] “Dbms popularity broken down by database model,” Jul. 2021, last
Accessed: July, 2021. [Online]. Available: https://db-engines.com/en/
ranking categories

---

