# ONDA: ONline Database Architect

> 来源: https://arxiv.org/pdf/2401.16552

ONDA: ONline Database Architect
Nuno Laranjeiro
University of Coimbra, CISUC, DEI
Portugal
cnl@dei.uc.pt
Alexandre Miguel Pinto
Signal AI
London, United Kingdom
alexandre.pinto@signal-ai.com
ABSTRACT
Database modeling is a key activity towards the fulfillment of stor-
age requirements. Despite the availability of several database mod-
eling tools for developers, these often come with associated costs,
setup complexities, usability challenges, or dependency on specific
operating systems. In this paper we present ONDA, a web-based
tool developed at the University of Coimbra, that allows the creation
of Entity-Relationship diagrams, visualization of physical models,
and generation of SQL code for various database engines. ONDA
is freely available at https://onda.dei.uc.pt and was created with
the intention of supporting teaching activities at university-level
database courses. At the time of writing, the tool being used by
more than three hundred university students every academic year.
CCS CONCEPTS
• Information systems →Entity relationship models; Rela-
tional database model; Physical data models.
KEYWORDS
Entity-Relationship Diagram, Database Modeling, Database
1
INTRODUCTION
Database Management Systems have been evolving since the 60’s
[7]. At the time, only specific systems required some form of data
storage, nowadays most applications need some kind of data stor-
age and management mechanisms. Depending on the type of ap-
plication, simple storage mechanisms like the use of files may be
sufficient, others may require an in-memory database, a dedicated
database server with persistent storage, or, for instance, a cloud
storage service [6, 9].
Data may be organized according to different models, which
determine how data should be structured, and may be supported
by different architectures, which determine how data is physically
stored [6]. Over time, the field of data storage and management
has undergone numerous advancements [1, 7]. Figure 1 highlights
some of the most relevant developments, in the context of this
paper, which we describe in the following paragraphs.
In the 60’s two data models were popular, namely a tree-structure
model named IMS (1966) and a network model named CODASYL
(1969) [7]. In the 70’s Codd [5] published a paper which proposes a
relational model of data, separating the physical organization from
the logical organization, i.e., the schema. A key idea behind the
proposal was to safeguard users from disruptive changes in data
representation as a consequence of data growth. The first relational
database prototypes appeared in the mid 70’s named Ingres [10]
and System R [2].
A new database model named Entity-Relationship (ER) was pro-
posed by Chen in [4]. The ER model is based on the definition of
Entities and Relationships between them, which may be of various
types (e.g., different cardinalities). The model includes some seman-
tic information and can be viewed as a generalization or extension
of the existing models at the time, or even as a framework from
which other models (e.g., relational, entity set, or network models)
could be derived [4]. In the 80’s, in particular in 1986 the Structured
Query Language (SQL) became an ANSI standard and also an ISO
standard a few months later, acknowledging the importance of
relational databases and also further fostering their popularity [3].
In the 90’s we witnessed significant advances in database systems
and applications and in software for building database applications.
Such software includes programming environments but also tools
mostly centered on database modeling, such as Sybase Powerde-
signer, whose origins trace back to 1995, ERwin Data Modeler in
1998, or Enterprise Architect a bit later [12].
A relational database named NoSQL was made available in 1998
and did not expose an SQL interface, which was usual at the time
[11]. In the 00’s, in light of the emergence of non-relational and
distributed data stores (e.g., Google Bigtable, Amazon DynamoDB)
Johan Oskarsson reintroduced the term NoSQL in 2009, as a way
to label such storage systems [11]. The popularity of database sys-
tems that are using new architectures (e.g., document, key-value,
graph, time series) has been growing in recent years, due to their
overall effectiveness in particular contexts (e.g., the need for storing
unstructured data). Despite such advances, the maturity and wide
range of applications of relational databases make them a quite
popular solution, among the various options available nowadays
[8].
Tools for database modeling generally come associated with
various limitations [12], as follows. Many times such tools are in
the form of commercial software that needs to be paid in order to
be used. Often the software is to be run locally and supports one
or a reduced set of operating systems. The installation procedure
may not be trivial and, depending on the license, the application
may not allow for updates or upgrades. Especially important is the
type of diagrams supported. Sometimes just the physical design
of tables is supported, in some other times the tools provide a
slighlty higher level of abstraction and it is possible to draw a
logical representation of the data, but many tools do not allow
(or have additional constraints, such as paid licenses) representing
Entity-Relationship diagrams in the terms proposed by [4].
In this paper we present the ONline Database Architect
(ONDA), an open-source, web-based, and free tool for data-
base modeling. The concept of the tool has been created by the
authors of this paper and the tool has been developed by several
students of the Department of Informatics Engineering (DEI) of the
Faculty of Sciences and Technology of the University of Coimbra
in Portugal. The main idea behind the creation of the tool was to
support various courses at DEI in which the creation of Entity-
Relationship diagrams is required, while allowing students to have
arXiv:2401.16552v1  [cs.DB]  29 Jan 2024

---

N. Laranjeiro and A. M. Pinto
Codd, 1970
SQL Standardization
Cloud distributed
Chen, 1976
1970
1980
1990
2020
NoSQL
Modeling tools
2000
2010
1960
Ingres, System R
Big Data 
and NoSQL
New models, 
AI, ML
Client
server
Market
Expansion
Relational
data model
Early 
concepts
IMS, CODASYL
Figure 1: Timeline of advances in data storage and management.
Figure 2: Main ONDA screen and the creation of an Entity-Relationship diagram.
free access to a cross-platform tool that requires no setup. The tool
runs via a browser and is available at https://onda.dei.uc.pt. As a
quick overview, ONDA allows the following main functionalities:
• Creation of Entity-Relationship diagrams;
• Conversion of Entity-Relationship diagrams to physical
models;
• Generation of SQL based on the generated physical models
and supporting various database engines.
ONDA has been the subject of various iterations and the current
version (v4) is now being used by more than three hundred stu-
dents every academic year and across various BSc and MSc courses.
Despite a few existing limitations, it is sufficiently stable to be used
throughout each academic semester and has received generally
positive feedback from students.
The paper is organized as follows. Section II presents the main
functionalities provided by ONDA and Section III concludes the
paper and identifies planned future work.
2
THE ONDA APPLICATION
In this section, we overview the ONDA application, going through
the following three main features: i) ER diagram creation; ii) physi-
cal model generation; and iii) SQL generation.
2.1
Entity-Relationship Diagram Creation
Figure 2 shows ONDA’s main screen. In the top right-hand corner,
marked with a yellow rectangle, we are able to select the following
three options: i) ’Conceptual’ - displays the screen shown in Figure
2, allowing the user to draw an Entity-Relationship diagram; ii)

---

ONDA: ONline Database Architect
’Physical’ - generates and shows the physical diagram that corre-
sponds to the ER created in the ’Conceptual’ tab; and iii) ’Script’ -
generates the SQL corresponding to the created physical diagram.
The main drawing icons are marked with a green rectangle
in Figure 2. From the left to the right, the first icon allows the
placement of an entity on the canvas, the second icon allows to
connect two entities with a relationship, and the last icon allows to
define an inheritance relationship between two entities.
After adding an Entity to the canvas, it is possible to configure
it by setting its name, adding attributes and configuring these at-
tributes. This configuration is visible after selecting the Entity to
configure and it is marked with a blue rectangle at the right-hand
side of Figure 2. For each attribute it is possible to set the following
properties: attribute name; datatype; datatype configuration (e.g.,
maximum number of characters if it is a string, precision and scale
if it is a Number); identify it is a primary key; if it is mandatory; if
it is unique; or if its value should be automatically incremented by
the database management system. It is also possible to manually
add SQL constraints (e.g., to specify the valid domain of a certain
attribute), which are however not shown in Figure 2.
Marked with a red rectangle at the bottom right-hand side of
Figure 2, is an overlay image to represent the case where the user
wants to configure a relationship. Notice that, when using the ap-
plication, this configuration actually appears at a different position,
namely under the ’Properties’ header in ONDA. The screenshot
has been modified for presentation simplicity in this paper. After
clicking on the ’Enrol1’ line, the relationship can be configured in
the properties pane. We can configure the cardinality of the rela-
tionship at both ends of the relationship, with the different symbols
following the Crow’s Foot notation. In the case of the example
shown in Figure 2, a Student may perform none or various enroll-
ments, one enrollment belongs exactly to a single student. In this
particular case, Enrollment is also a Weak Entity, which means
it either does not have an identifier or it has a partial identifier
only, which is the case of the example. We can tick the ’is weak’
checkbox to identify this type of situation.
Finally, two entities may have an hierarchical relationship,
which is the case of Person (the super-entity) and Professor and
Student (the sub-entities). This type of relationship can be config-
ured to ’Complete’, ’Concrete’, or ’Single’ which essentially result
on the generation of different physical diagrams. The ’Complete’
configuration generally means that all sub-entities will have direct
correspondence to a table in the physical diagram. ’Concrete’ will
result in distribution of the attributes of the super-entity by the
sub-entities and in the removal of the table corresponding to the
super-entity. Finally, the ’Single’ configuration results in merging
the attributes of the super-entity and of the sub-entities in a single
table in the physical model.
2.2
Physical Model Generation
Figure 3 shows the physical data model that corresponds to the ER
diagram shown earlier.
There are basically two alternatives for configuring the physical
data model generation: ’Normal’ and ’Simplified’, which can be
selected from the drop-down list visible at the top of Figure 3. In
this case, the option selected is ’Normal’, which has the main effect
of generating one additional table professor_course where the
associations between professors and courses are to be stored. This
intermediate table does not admit null values and this is the main
idea behind the ’Normal’ generation mode. In the generated table
professor_course, we can see that a given course can only appear
once (course_designation is primary key) and a given employee
(referenced by its card identifier) can appear multiple times. This
means that the generated table will allow for an employee to be
associated with different courses, however a given course cannot
be associated with more than one employee, which is what has
been specified in the previous conceptual model shown in Figure 2.
2.3
SQL Generation
Figure 4 shows the SQL generated by ONDA, corresponding to the
physical data model presented in the previous subsection.
In the case of SQL generation, the only configuration possible is
the selection of one out of five different database engines, namely
PostgreSQL, Oracle, MySQL, MariaDB, SQLite. It is worthwhile
mentioning that PostgreSQL is the engine for which SQL generation
has been most thoroughly tested.
The generated SQL includes instructions for the creation of the
tables along with the necessary constraint definitions (e.g., foreign
keys, mandatory columns). We aimed at creating standard SQL, al-
though in certain circumstances the different database management
systems require some customization of the generated SQL.
3
CONCLUSION
This paper presented ONline Database Architect (ONDA), a web-
based application that allows users to create Entity-Relationship
diagrams, generate the corresponding physical data models, and
the corresponding SQL. ONDA is, at the time of writing, being used
by more than three hundred students every academic year. Our
future plans include extending the tool to support further modeling
notations or allowing it to edit and store PL/SQL code.
ACKNOWLEDGMENTS
The main driver behind the development of ONDA was the lack
of free, cross-platform, easy to use, applications that for drawing
Entity-Relationship diagrams. We aimed at a tool that could gener-
ate the physical diagram and also the corresponding SQL, which
would be particularly tailored for a university-level learning envi-
ronment.
We would like to thank the various students involved in the
development of the application throughout the years. We would also
like to thank the ’Project Management’ course offered in the Master
in Informatics Engineering at the University of Coimbra, which
allowed three teams of students to participate in this project. Also
we thank our colleague Marco Vieira for various key suggestions
in the initial stage of development of ONDA, many years ago. The
current version of ONDA (v4) has been polished with the help of
one additional student, for which we involved our colleague João
Campos who provided guidance for the work and to whom we
extend our thanks.

---

N. Laranjeiro and A. M. Pinto
Figure 3: Physical data model generation in ONDA.
Figure 4: SQL generation in ONDA.

---

ONDA: ONline Database Architect
This work has been supported by the FCT – Foundation for
Science and Technology, I.P./MCTES through national funds (PID-
DAC), within the scope of CISUC R&D Unit – UIDB/00326/2020 or
project code UIDP/00326/2020
REFERENCES
[1] Gary Anthes. 2010. Happy Birthday, RDBMS! Commun. ACM 53, 5 (May 2010),
16–17. https://doi.org/10.1145/1735223.1735231
[2] M. M. Astrahan, M. W. Blasgen, D. D. Chamberlin, K. P. Eswaran, J. N. Gray,
P. P. Griffiths, W. F. King, R. A. Lorie, P. R. McJones, J. W. Mehl, G. R. Putzolu,
I. L. Traiger, B. W. Wade, and V. Watson. 1976. System R: relational approach to
database management. ACM Transactions on Database Systems 1, 2 (June 1976),
97–137. https://doi.org/10.1145/320455.320457
[3] Donald D. Chamberlin. 2012. Early History of SQL. IEEE Annals of the History
of Computing 34, 4 (Oct. 2012), 78–82. https://doi.org/10.1109/MAHC.2012.61
Conference Name: IEEE Annals of the History of Computing.
[4] Peter Pin-Shan Chen. 1976. The entity-relationship model—toward a unified
view of data. ACM Trans. Database Syst. 1, 1 (mar 1976), 9–36. https://doi.org/
10.1145/320434.320440
[5] E. F. Codd. 1970. A relational model of data for large shared data banks. Commun.
ACM 13, 6 (jun 1970), 377–387. https://doi.org/10.1145/362384.362685
[6] Hector Garcia-Molina, Jeffrey D. Ullman, and Jennifer Widom. 2008. Database
Systems: The Complete Book (2 ed.). Prentice Hall Press, USA.
[7] Thomas P. Hughes and Jerry R. Sheehan. 1999. What Has Influenced Computing
Innovation? Computer 32, 2 (Feb. 1999), 33–43. https://doi.org/10.1109/2.745718
[8] Michael Kaufmann and Andreas Meier. 2023. SQL and NoSQL Databases: Modeling,
Languages, Security and Architectures for Big Data Management. Springer Nature
Switzerland, Cham. https://doi.org/10.1007/978-3-031-27908-9
[9] Feifei Li. 2023. Modernization of Databases in the Cloud Era: Building Databases
that Run Like Legos. Proceedings of the VLDB Endowment 16, 12 (Aug. 2023),
4140–4151. https://doi.org/10.14778/3611540.3611639
[10] Michael Stonebraker, Gerald Held, Eugene Wong, and Peter Kreps. 1976. The
design and implementation of INGRES. ACM Transactions on Database Systems
1, 3 (Sept. 1976), 189–222. https://doi.org/10.1145/320473.320476
[11] Christof Strauch, Ultra-Large Scale Sites, and Walter Kriha. 2011.
NoSQL
databases. Lecture Notes, Stuttgart Media University 20, 24 (2011), 79.
[12] Toby J. Teorey, Sam S. Lightstone, Tom Nadeau, and H. V. Jagadish. 2011. Database
Modeling and Design: Logical Design (5th ed.). Morgan Kaufmann Publishers Inc.,
San Francisco, CA, USA.

---

