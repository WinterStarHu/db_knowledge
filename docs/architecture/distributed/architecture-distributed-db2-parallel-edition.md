DB2 Parallel Edition by C. K. Baru G. Fecteau A. Goyal H. Hsiao A. Jhingran S. Padmanabhan G. P. Copeland W. G. Wilson The  rate  of  increase in database  size  and response-time  requirements  has  outpaced advancements in processor  and  mass  storage technology.  One way to satisf'y the  increasing demand  for  processing  power  and  inputloutput bandwidth in database  applications  is to have  a number  of  processors,  loosely  or  tightly  coupled, serving  database  requests  concurrently.
Technologies  developed  during  the  last  decade have  made  commercial  parallel  database  systems a  reality,  and  these  systems  have  made an inroad into the  stronghold of traditionally  mainframe- based  large  database  applications.  This  paper describes  the DB2@ Parallel  Edition  product  that evolved  from  a  prototype  developed at IBM Research in Hawthorne,  New  York,  and  now  is being jointly developed  with  the  IBM  Toronto laboratory- L arge-scale parallel processing  technology  has made giant strides in the past decade, and there  is  no  doubt  that it has  established  a place for itself. At  this time, however, almost all of the  ap- plications harnessing this technology are scientific or engineering applications. The  lack of commer- cial applications for  these parallel processors may in part be  due  to  the perceived  robustness  and  us- ability of these  systems.  Compared to mainframe systems, large-scale parallel processing  systems have not emphasized availability and reliability and have  not  been  supported with adequate  software for system management and application develop- ment.  However,  the  current  generation of mas- sively parallel processor  systems,  such as  the IBM Scalable PowERparallel Systems* (the sPl* and S P ~ * class of systems), are much  more  robust and easier to use.
Database management systems (DBMSS) provide important support for commercial applications.
Currently  there is a rapidly growing trend among businesses to analyze  their increasing volumes of transaction data for various  types of trends, includ- ing sales  and purchasing, inventory,  and budget.
This  class of applications, called decision  support applications, poses  complex  queries on the large volumes of data  that  have  been collected fromvar- ious  sources. Single-system (or serial) DBMSS can-, not handle the  capacity and the complexity require- ments of these applications. In addition to decision support  applications,  there  are  other new applica- tion classes  such as  data mining, digital libraries, and multimedia that  require  either large capacity or  the ability to handle complexity. The emergence of these applications has fueled the need for  par- allel DBMS software from commercial vendors.
In the  past,  a  number of research  prototypes, in- cluding Gamma, ' Bubba, ' and XPRS, have tried to understand the issues in parallel databases.
These  and  other  projects  addressed  important is- sues  such  as parallel algorithms for  execution of important database operations, query optimiza- tion  technique^,^,^ data placement,'@'3 and  data- base  performance. l~ The results of these  stud- Wopyright 1995 by International Business Machines Corpo- ration. Copying in  printed  form  for  private use  is permitted with- out payment of royalty provided that (1)  each reproduction is done without alteration and (2) theJoumal reference and  IBM copyright notice are included on the first page. The title and abstract, but no other portions, of this paper may be copied or distributed royalty free without further permission by computer- based and other information-service systems. Permission to re- publish any other portion of this paper must be obtained from the Editor.
0018-8670/95/$3.00 0 1995 IBM IBM SYSTEMS JOURNAL,

VOL 34, NO 2, 1995

---

ies form a basis for our knowledge of parallel database  issues today. However,  two major lim- itations with many of these  projects  were:
(1) Many of the  problems  were  considered in isolation, so the implementation tended to  be  very simple, and (2) in several  cases,  people  resorted to simulation and  analysis  because the implementation required enormous effort. Recognizing the  importance of an “industrial strength” parallel database  system,  we initiated a  project  at IBM Research  that  has now led to  the emergence of the  product DB2* Parallel Edition.
DB2 Parallel Edition (DB2 PE) is a parallel database software program that  currently  operates  on AIX*- based parallel processing  systems,  such  as  the IBM S P ~ system,  and will be available in the  future  on other  architecture and operating system platforms.
Its shared-nothing (SN) architecture and function shipping execution model (discussed later) provide two important assets: scalability and capacity. DB2 PE can  easily  accommodate  databases  with hun- dreds of gigabytes of data.  Likewise,  the  system model enables  databases  to  be  easily  scaled with the addition of system processor and disk re- sources.  The  architecture and implementation of DB2 PE provide  the  opportunity  for  the  best  query processing  performance.
The  query optimization technology  considers  a variety of parallel execution  strategies  for differ- ent  operations and queries  and  uses  cost in or- der  to  choose the  best possible execution  strat- e w - The execution time environment  is optimized to reduce  process  overhead,  synchronization  over- head, and  data  transfer  overhead.
The ACID (a term meaning atomicity, consis- tency, isolation, and durability-all properties of a transaction) transaction properties” are en- forced in a  very efficient manner in the  system to provide full transaction capabilities.
Utilities such  as  load,  import, reorganize data, and create  index  have  been efficiently structured to run in parallel.
A parallel reorganization utility (redistribute) is used to effectively correct  data  and  processing load imbalance across different nodes of the sys- tem.
It  must be noted  that  companies  such as Tandem Computers  Incorporated  and  Teradata  Corpora- tion have built and  sold parallel database  products for  a few years. 16,18~19 Teradata’s DBC/1012 system IEM SYSTEMS JOURNAL, VOL 34, NO 2, 1995 is targeted  for  decision  support  applications while most of the  Tandem  systems  target high-perfor- mance on-line transaction  processing (OLTP) ap- plications. Proprietary  hardware  increases  the  cost of such  systems  and also inhibits the development of a full set of application enablers  on them. Be- sides  the  fact  that DB2 PE does  not impose such  a limitation, we believe that  there  are  several novel aspects  that  are  addressed  by DB2 PE that  have  not been addressed elsewhere. Several of these  aspects are highlighted later in this  paper.
The  next  section in this  paper  describes the gen- eral architecture of the DB2 PE system and discusses the  merits of the  shared-nothing  architecture  and the  function shipping execution model. Following sections  discuss the  three  layers of the  system in detail: the  user-controlled  data  layout for optimal performance, the salient features of the DB2 PE query optimization, and  the run-time internals of the  system.  Next we discuss  database utilities such as load and unload that are  very useful for deci- sion support applications. Finally we present ini- tial performance  numbers of some  controlled  ex- periments. The  paper  ends with a discussion of our experience,  our conclusions, and  directions  for fu- ture  work.
Architecture overview Parallel database  systems  can  be built on top of different hardware  architectures,  and given a  spe- cific hardware architecture, they can be imple- mented using one  or  both of the  function shipping and I/O shipping paradigms. This  section  describes the specifics of each of these architecture and execution models and the  choices we  made for DB2 PE.
Hardware  architecture. Three different approaches can  be used in building high-performance parallel database  systems,” namely, shared-memory (shared  everything, tightly coupled),  shared-disk (data sharing, loosely coupled), and  shared-noth- ing (partitioned  data)  approaches.  Figure 1 illus- trates  the  three different parallel database  system architectures.
In shared-memory  systems, multiple processors share  a common central  memory. With this ap- proach,  communication among processors  is through shared  memory,  thus  there is little mes- sage overhead. In addition, the software  required to provide parallel database  processing is consid- EARU ET AL. 293

---

Figure 1 Shared-memory, shared-disk, and shared-nothing approaches SHARED-MEMORY  APPROACH t INTERCONNECTION NETWORK \ 1 I I a I 4 I. , GLOBAL  SHARED  MEMORY I I I SHARED-DISK  APPROACH MEMORY

!
I INTERCONNECTION NETWORK 1 I SHARED-NOTHING  APPROACH INTERCONNECTION  NETWORK D = DISK P - PROCESSOR 294 BARU ET AL.
IBM SYSTEMS JOURNAL, VOL 34, NO 2, 1995

---

erably less complex. Consequently, many com- mercial parallel database  systems available today are  based  on  the  shared-memory  architecture.
Although shared-memory systems  are  easier  to de- velop and support,  one major limitation is that  this approach cannot  be scaled to  a large number of pro- cessors.  Research  has  shown  that  beyond  a  cer- tain number of processors,  access to memory  be- comes  a  bottleneckz1  and  the  processing  speed  of the  system will be limited by memory  access and will not be  determined by  the  speed of the  proces- sors.  State-of-the-art  technology  can build mem- ory  to  support about 500 million instructions  per second (MIPS) of CPU power.  This implies that  a shared-memory  system  can  support  less  than 10 RISC System/6000* processors of the current gener- ation accessing the shared memory at the same time.
In shared-disk systems,” multiple processors, each with its local memory,  share  a pool of disks.
Shared-disk  systems avoid the  central  memory  ac- cess bottleneck,  but  introduce  the difficult prob- lem of connecting all processors  to all disks. This can be especially difficult  in the  case of a large num- ber of processors and disks. In addition, shared disks  present  the  most challenging task of trans- action management because of the  need  to  coor- dinate global locking activities  (without  the help of shared  memory)  and to synchronize log writing among all processors.
With the  shared-nothing  approach,  each  proces- sor  has  its  own  memory  as well as local disks. Ex- cept for the communication network,  no  other  re- sources are shared among processors. Shared nothing does  not  have  the  memory  access  bottle- neck problem, nor does it have  the problem of in- terconnecting  a large number of processors and disks. The major complexity in supporting the shared-nothing approach is the requirement of breaking a  Structured  Query  Language (SQL) re- quest  into multiple subrequests  sent  to different nodes in the  system  and merging the  results  gen- erated by multiple nodes. In addition, shared noth- ing requires distributed deadlock detection and multiphase commit protocol to  be implemented.
Researchers  and  developers  have argued that  the shared-nothing  approach is the most cost-effective alternative  and  the  most promising approach  for high-performance parallel database  systems.
20,23,24 Many  research  projects, including Gamma’  and Bubba,’ have  studied  various  aspects of parallel database  system design based  on  this  approach.
IBM SYSTEMS JOURNAL, VOL 34, NO 2, 1995 Because a shared-nothing system can easily be scaled  to  hundreds of processors, while shared- memory and shared-disk systems  are limited either by memory bus bandwidth or  by input/output chan- nel bandwidth,  and  because  a  shared-nothing sys- tem can grow gracefully, i.e., adding more diskca- pacity or processing power as needed, DB2 PE adopts  the  shared-nothing  approach.
Function shipping. Because resources are not shared in a shared-nothing  system, typical imple- mentations  use  function shipping, wherein  data- base operations are performed where the data reside. This minimizes network traffic by filtering out  unimportant  data and achieving good parallel- ism. A major task in a  shared-nothing implemen- tation is to split the incoming SQL request into  many subtasks;  these  subtasks  are  then  executed  on dif- ferent processors (if required, interprocess and interprocessor communication is used for  data  ex- changes). Typically, a  coordinator  serves as  the application interface, receiving the SQL request and associated host variables and returning the  answers to  the application.
Figure 2 shows some of the  task  structure for avery simple query.  The  table T1 is shown horizontally partitioned13 across all the nodes; thus,  based  on the function shipping paradigm, the  coordinator  re- quests  a  slave task-one on  each node-to fetch its  partition of T1 and send  the result to it. The  re- sults  are  then  returned to  the application. In  more complicated SQL statements,  the  task  structure is inherently  more complex; it is the  job of the  query compiler to derive the best (Le., optimal) task structure for the  execution of a  query.  The  query compiler determines  the  function to  be performed by each  task  at  run time; the  coordinator  task is typically instantiated  (or specifically determined) on  the  node  to which the application connects, and each  slave  task is instantiated on  the nodes  where the  data it accesses reside. Thus in Figure 2, there is one  coordinator,  and  there  are five instances of slave  tasks.  In  this  paper, we use  the  terms  slave task,subordinate  task,  subsection,  andsubplan in- terchangeably.
As an example of more complex function shipping, consider the following join query:
select T.A, S.A from T, S where T.B = S.B Figure 3A shows  a  serial  execution plan for this query. When tables T and S are horizontally par- BARU ET AL. 295

---

Figure 2 Task  structure  for a  simple  query Figure 3 Examples of a serial  and  a  parallel  execution  strategy JOIN SORT SORT I I SCAN SCAN I I T S I PARALLEL I NODE 1 NODE 2 NODE n JOIN SORT SORT I I SCAN SCAN TI si SORT SORT I I T2 52 c-, . . e SCAN SCAN Tn Sn 296 BARU ET AL.
IBM SYSTEMS JOURNAL,

VOL 34, NO 2, 1995

---

titioned, a possible parallel execution strategy could be  the  one  that  maintains  the  serial  struc- ture,  but  executes  each  operator in parallel. In Fig- ure 3B, circled Xs indicate  data  exchanges. (We show  later how in a large number of cases even such  exchanges  can be avoided.)  The parallel ex- ecution of this  query plan may  require  a  coordi- nator  (not  shown) and three  slave  tasks  (one  slave task  scans,  sorts, and ships  its  partition of T to a second  slave  task,  a  third  slave  task  does the same against S, and  the  second  slave  task  performs  the actual SQL join function).
One of the  advantages  that we realized from using function shipping was  that we could use much of the existing code; the scans, sorts, joins, etc., shown in Figure 3B are identical to  the  operators in Figure 3A. A fundamental  technology in Figure 3B is the mechanism that glues the  nodes  together to  provide  a single-system view to  the user. In ad- dition to function shipping, other technologies re- quired to  support an  environment  shown in Fig- ure 3 are (1) generation of parallel plans, (2) streaming of data and control flow, (3) process management, (4) parallel transaction and lockman- agement, and (5) parallel utilities.
Figure 4 describes the system  architecture of one node of a DB2 PE system at a  conceptual level. Op- erations  on a  node  are  either on behalf of external applications, or internal requests from other  nodes in the  system.  External  requests include SQL calls, utilities (load, unload, rebalance, etc.), or  other calls (commit, start using database, etc.). SQLCdlS can  be  broken  into  data definition language (DDL) and data manipulation language (DML). DDL is used to define and manipulate the  structure of the  data (meta-data), such  as creating databases, tables, and indices. DML is used for populating, querying, or modifying the  data in the database.
Execution of the  external  and  internal  requests  is primarily driven through the run-time layer. An ex- ample function of this  layer is to  traverse  the “op- erator”  graph of an optimized DML statement and to call lower-level functions  for executing each  op- erator.  The run-time system  is also responsible for allocating and deallocating processes  for  process- ing local and remote  requests.
Below this  layer  are two distinct components: data management services (DMS), which deal with op- erations on local data,  and  communication  serv- ices, which deal with operations on remote  data.
IBM SYSTEMS JOURNAL, VOL 34, NO 2, 1995 DB2 PE built upon and modified the DMS layer of the existing (nonparallel) IBM product ~~2/6000*, but the  changes  are relatively modest.  However,  the communication services  is an entirely new com- ponent.
The  communication  services  component  provides two types of interfaces, one for control  messages and the  other  for  data.  The  control  messages  can be either  synchronous or asynchronous. All mes- saging is through a communication manager, which is responsible for multiplexing, demultiplexing, and reliable delivery to  other DB2 PE processes.
In addition, the  data protection services (DPS) layer of DB2/6000, responsible  for locking, logging, and recovery, had to  be extended to account  for  the fact  that  a  transaction  can  activate  more  than one process  and  can  involve  more  than  one  node.  The extensions to DPS use the control message inter- face of the communication services for global dead- lock detection,  two-phase commit protocol, and recovery  from  system failures.
These building blocks of the DB2 PE system are dis- cussed  later in more detail. We discuss  changes to the DDL and  its processing, DML statements  and their optimization (including the new operators  re- quired to execute  them in a  function shipping par- adigm), changes in the run-time system and the DPS layer,  the  new communication component  and, fi- nally, some of the  new parallel database utilities.
Data  definition  language DB2 PE provides  extensions to SQL in the form of new data definition language (DDL) statements  that allow users  to control the placement of database tables  across  the  nodes of a parallel system. Be- fore describing the DDL extensions, we provide  a general discussion of data placement issues in shared-nothing parallel database  systems.
Data placement. The data placement problem is  the problem of determining the  best  storage  strategy for the  tables in a given database.  Data placement in parallel database  systems  is known to  be a dif- ficult  problem13 and several  approaches  have  been taken to solve it. 10~13,25,26 The  three  key  aspects of the  data  placement problem are declustering,  as- signment, and partitioning. l3 Declustering refers to the technique of distributing the  rows of a  sin- gle table  across multiple nodes. If the rows  are stored  across all the  nodes of the parallel database BARU ET AL. 297

---

Figure 4 Major  system  components  at  one  node UTILITIES OTHERS ~~.I;~:ar- RUN-TIME  FUNCTIONS n I u MANAGEMENT DATA SERVICES (DMS) MMMUNICATION SERVICES CONTROL MESSAGES SERVICES  (DPS) DATA  PROTECTION L 4 COMMUNICATION MANAGER I I / f NETWORK  (TO  OTHER  NODES) d system,  then  the table is said to be fully declus- tered. If the  rows  are distributed across  a  subset of the  nodes,  then  the table is said to be partially declustered. Partial declustering subsumes full de- clustering, and provides more flexibility for assign- ment of tables. The number of nodes  across which a  table  is  declustered  is referred to as the degree of declustering of the table. The  term tublepur- tition refers  to  the  set of rows of a given table that are all stored at  one node of the shared-nothing sys- tem (therefore, the number of table partitions equals degree of declustering).
After choosing the degree of declustering, it is nec- essary to solve the assignment problem, which is the problem of determining the particular set of nodes on which the table partitions are to be stored.
The following issues arise during assignment.
Given any two database tables, their assignment maybe nonoverlapped, i.e., the two tables  do not share  any common nodes. Conversely, their as- signment may be overlapped, in which case the two tables  share  at least one node. If both  tables  share exactly  the  same  set of nodes, then the tables are said to  be fully overlapped. Full declustering re- 298 BARU ET AL IBM SYSTEMS  JOURNAL,  VOL 34, NO 2, 1995

---

stricts assignment to  be fully overlapped,  whereas partial declustering allows for full freedom in as- signment of table partitions. Finally, the problem of partitioning refers to  the problem of choosing a  technique to assign each row of a  table  to  a  table partition. Common techniques are round-robin, hash, and range partitioning. In  the  last two, a  set of columns  (attributes) of the  table  are defined as the partitioning keys  and their values in each  row are used for  hash or range partitioning.
Nodegroup DDL. DB2 PE supports partial declus- tering, overlapped assignment, and hash partition- ing of database  tables using the notion of node- groups. A nodegroup is  a named subset of nodes in the parallel database  system.  The following ex- ample illustrates the use of the nodegroup DDL statement:
CREATE  NODEGROUP  GROUP -1 CREATE  NODEGROUP  GROUP  -2 CREATE  NODEGROUP  GROUP -3 ON  NODES (1 TO 32, 40, 45, 48) ON NODES (1, 3, 33) ON  NODES (1 TO 32, 40, 45, 48) In the  above example, GROUP -1 and GROUP -3 are two different nodegroups, even though they contain  the  same  set of nodes  (nodes 1 to 32, 40, 45, and  48). Nodegroup GROUP -2 is partially over- lapped with GROUP -1 and GROUP  3 (on  nodes 1 and 3).
To support scalability, a  data redistribution utility is provided to add and drop  nodes to  or from a nodegroup  (see  the  subsection  on  data redistribu- tion later in this  paper).
Extensions to CREATE  TABLE DDL. When cre- ating a  table, it is possible to specify the nodegroup on which the table will be  declustered.  The  car- dinality of the  nodegroup is the  degree of declus- tering of the table. In addition, it is possible to  spec- ify the  columns to  be used for the partitioning key.
The following example  illustrates  the  use of DDL extensions  to  the CREATE  TABLE statement:
CREATE TABLE PARTS (Partkey integer, PARTITIONING  KEY (Partkey) USING  HASHING CREATE TABLE PARTSUPP (Partkey integer, IN GROUP -1 PARTITIONING  KEY (Partkey) Partno integer) IN GROUP -1 Suppkey integer, PS-Descp  char(501) USING  HASHING IBM SYSTEMS JOURNAL,  VOL 34, NO 2, 1995 Figure 5 The  concept of partitioning  keys and maps TABLE CREATE  TABLE  CUSTOMERS (Custkey integer, PARTITIONING  KEY (Custkey) USING  HASHING CREATE  TABLE  SUPPLIERS (Suppkey integer, PARTITIONING  KEY (Suppkey) USING  HASHING CREATE  TABLE  ORDERS (Orderkey integer, PARTITIONING KEY (Orderkey) USING  HASHING C-Nation char[20]) IN GROUP -1 S-Nation char[20]) IN GROUP -1 Custkey integer, Orderdate date) IN GROUP -1 The partitioning key of tables PARTS and PART- SUPP is Partkey. All tables  are partitioned across the set of nodes identified by the nodegroup, GROUP -1.
For  each  row of a table, the hash partitioning strat- egy applies an internal hash function  to the par- titioning key  value to obtain  a  partition  (or  bucket) number. This partition number is used as an  index into  an internal data  structure  associated with each nodegroup (thepartitioning map), which is an  ar- ray of node numbers. Each  nodegroup is associ- ated with  a  distinct partitioning map. If a  partition- ing key  value  hashes  to  partition i in the map, then the  corresponding row will be  stored  at  the  node whose  node  number  appears in the  ith location in the map. Figure  5  shows  a  table with partitioning keyA . The hash  function H(A) is applied on a  tu- ple’sA value  and  that  is used as  an  index  into  the partition map  to  determine  the  actual  node  num- ber.
BARU ET AL. 299

---

If there arep partitions in the partitioning map  and if d is  the  degree of declustering of a table, then it is  necessary  that d 5 p . In DB2 PE, the  value of p is  chosen to  be 4096. Typically, d << 4096, thus several  partitions  are  mapped to  the same node.
Initially, the 4096 hash  partitions are assigned to nodes using a round-robin scheme. Thus, each node  has  at  most 4096/d partitions of a given ta- ble.
In  the above  example, all tables  use  the  same  par- titioning map  since  they  are defined in the  same nodegroup. In addition, if the  data  types of the  par- titioning keys  are  compatible,  then  the  tables  are said to  be collocated. Since  the  data  types of the partitioning keys of PARTS and PARTSUPP are  the same,  they  are  compatible  by definition. DB2 PE provides  a simple set of rules  that define compat- ibility of unequal data types. The partitioning strat- egy ensures  that  rows  from  collocated  tables  are mapped to  the same  partition  (and  therefore  the same node) if their partitioning key  values  are  the same.  This is the  primary  property of collocated tables.  Conversely, if rows from collocated  tables map to different nodes,  then  their partitioning key values  must  be different. Collocation is an impor- tant  concept  since  the equi-join of collocated  ta- bles  on  the  respective partitioning key attributes can  be  computed efficiently in parallel by execut- ing joins locally at  each  node  without requiring in- ternode  data  transfers.  Such  joins  are called col- bcatedjoins and  have the  property of being highly scalable (perfectly scalable in the ideal case). Thus, in the above  example,  the following is  a  collocated join:
select * from PARTS, PARTSUPP where PARTSPARTKEY = PARTSUPP.PARTKEY Query optimization The compiler component of DB2 Parallel Edition is  responsible for generating  the parallel query  ex- ecution strategies for the different types of SQL que- ries. The DB2 PE compiler is implemented on  the basis of a  number of unique principles:
Full-fledged cost-based optimization-The  optimi- zation  phase of the compiler generates different parallel execution  plans  and  chooses  the  execu- tion plan with  the  least  cost.  The  optimizer  ac- counts  for  the  inherent parallelism of different operations  and  the additional costs  introduced by messages while comparing different strate- 300 BARU ET AL.
gies. This  approach is similar to  the cost-based query  optimization performed by System R* for a  distributed  database  environment. 27 Comprehensive usage of data  distribution infor- mation-The optimizer makes full use of the  data distribution and partitioning information of the base  and  intermediate  tables involved in each query while trying to choose parallel execution strategies.
Transparent parallelism-The user  applications issuing data manipulation SQL statements  do  not have  to change in order  to  execute  on DB2 PE.
Hence,  the  investment  that  users  and  custom- ers have made already in generating applications is fully protected  and  the migration task for the DML applications is trivial. Application programs written  for the DB2/6000 product  do  not  even need to  be recompiled fully when  they are migrated to DB2 PE; the application only  requires  a rebind to  the parallel database, which generates  the least cost parallel plan for the different SQL statements, and, if appropriate,  stores  them.
The following subsections  describe  the  key  fea- tures of the  query compilation technology in DB2 PE. We describe  the important operator  extensions that are required for parallel processing,  the dif- ferent  types of operator  execution  strategies,  and finally, the  generation of the overall parallel exe- cution plan. We use  several  examples to illustrate these  concepts.
Operator extensions. For  the  most  part, parallel processing of database  operations implies replicat- ing the  basic relational operators  at different nodes.
Thus,  the  basic  set of operators (such as table  ac- cess,  join,  etc.)  are  used  without  much change.
However,  the  function shipping execution  para- digm introduces two new  concepts  that  are  not present in a  serial engine:
Query execution may require multiple logical tasks  and  each taskmay  be executed  across mul- tiple nodes.  Consequently, we need  operators that  the  coordinator  task  can  use to control  the run-time execution of slave  tasks.  This  operator, called distribute  subsection,  is described in more detail in a  later  section.
As a  consequence of multiple processes,  inter- process communication operators  (notably  send and receive)  are  required in DB2 PE. These  op- erators  can  have  attributes (e.g., send can be broadcast  or  directed;  receive  can  be  determin- istic or random).
IBM  SYSTEMS  JOURNAL,  VOL 34, NO 2, 1995

---

Partitioning  knowledge. In DB2 PE, we  are conscious about partitioning in the DDL, data manipulation SQL, and  at  run time. The partitioning methodol- ogy of DB2 PE can  be  viewed simply as a load bal- ancing tool (by changing the  key  and partition map, we can  adjust  the number of tuples  on  any  node);
however, by making the compiler and the run-time systems  understand  it, we have  succeeded in  im- proving SQL performance  beyond simply load bal- ancing. As mentioned before,  an  example of this is  collocated  joins.  The compiler, being fully cog- nizant of table partition keys, nodegroups, etc., can evaluate  the  costs of different operations (collocat- ed vs broadcast  joins,  for example, as described later)  and  thus  choose  the optimal execution  strat- egy for a given SQL statement. In the  case of cer- tain  directed  joins,  the run-time system  uses  the knowledge of partitioning to  correctly direct tuples to  the appropriate  nodes.
Query  optimization  and  execution  plan  generation.
In this section, we describe  the  query  execution plans as trees of operators  separated  into  tasks.
The  query  execution  can  be  viewed  as  a  data flow on  this  tree,  with  sends  and  receives being used for  intertask communication.
A query optimizer typically chooses: (1) the  op- timal join order and (2) the  best  method  to  access base  tables  and to compute  each join. This  task  is inherently exp~nential*~J~ and many optimizers use heuristics  such as postponing of cross products, left-deep  trees, etc., in order  to prune  the  search space.  In  the  case of a parallel database,  query  op- timization is further complicated by: (3) determin- ing the  nodes on which operations  need to  be done (this is called the repartitioning strategy and is  re- quired  because  the  inner  and  the  outer  tables  may not  be  on  the  same  set of nodes)  and (4) choosing between  system  resources  and  response time as the  appropriate  metric  for determining the  cost of a plan.
In DB2 PE, we have made a few simplifying assump- tions in order  to keep  the  query optimization prob- lem tractable:
We keep  track, on a  per-node basis, of the  total system resource accumulated during the bot- tom-up generation of a  query plan. The maximum resources  used  across all the  nodes  and  the  net- work is a measure of the response time of a query-
* Of all the possible subsets of nodes  that  can  be 
used to execute  a  join, we typically consider only a  few  subsets:
all the  nodes,  the  nodes on which the inner table is partitioned, the  nodes  on which the-outer table  is  partitioned,  and  a few others.
In keeping with the DB2/6000 query optimization strategy, we use agreedy heuristic while choos- ing between different parallel join execution strat- egies. The join execution strategies are described later. The best locally-optimized strategy  is  the one  that  survives.
In  some  queries, the optimal strategy  is obvious.
For example, consider  the following query:
select  S-NAME,  S-ADDRESS from SUPPLIERS where S-REGION= ' ASIA' If a  secondary  index  exists  on SUPPL1ERS.S-RE- GION, then  the  query plan will use it to restrict the tuples on  each node; otherwise  each  node will have to fetch all its SUPPLIERS tuples and eliminate those  that are not from I ASIA' . The run-time ex- ecution  strategy  is very similar to Figure 2.
In  a  more  complicated  query,  such as  one  shown in Figure 6A, the  coordinator  not  only  returns  the answer  to the application, but also binds in any in- formation required to  compute  the  answer  (pass- ing this information to  the slave  task if required).
In  this  case,  an additional feature  that DB2 PE sup- ports  is  to perform aggregation such as count(*) in two steps-the slave tasks compute their local counts  and  then  the  coordinator  sums  the  counts and  returns  the  result  to  the application. The ar- rows from the  coordinator to  the slave  task  rep- resent  the passing of all the information required for the  slave  task to correctly  execute (i.e., the query  subplan, including the input host variable), and the  arrows from the  slave  task to  the coordi- nator  indicate  return of their local counts.
In  these  two  examples,  the  query  optimizer had to do little; we now turn  to  some examples of joins where the optimizer has  to actually make decisions.
SELECT CUSTNAME from CUSTOMERS, ORDERS where 0-CUSTKEY = C-CUSTKEY and 0-ORDERDATE > '02/02/94' The  query  selects  the  names of all customers  who placed orders after a  certain  date. It requires  that the ORDERS and CUSTOMERS tables  be joined on their CUSTKEY attribute.  This  join  operation  can IBM SYSTEMS JOURNAL, VOL 34, NO 2, 1995 BARU ET AL. 301

---

Figure 6 Task structure  for a query and  join IQUERY SELECT  COUNT (*) FROM T1 WHERE T1 .bs:hvar APPLICATION ‘7 I’ GET DATA FROM RETURN TO APPLICATION COORDINATOR

SUM m SLAVE TASK MULTIPLE  INSTANCES @ 1 DIRECTED  AND  BROADCAST  JOIN TO APPLICATION ~E~RDERS CUSTOMERS I COLLOCATED JOIN I I be performed by  avariety of different strategies in them be in the  same nodegroup. Then,  the  records a parallel database environment.
of both

tables having a particular CUSTKEY value will reside on  the  same  node.  For example, CUST- Collocated join. Let  the partition keys of the OR- KEY value of 10 000 may be mapped to node 100 DERS and CUSTOMERS tables be CUSTKEY and let but is the  same for both tables. Thus,  the join op- 302 BAW ET AL.
IBM

SYSTEMS

JOURNAL,

VOL 34, NO 2, 1995

---

eration  can be performed on  the local partitions of the  two  tables.  The  execution  strategy  for  this is shown in Figure 3A except  that  the circled cross operators  are null operators-no data  exchange is required,  and the entire  operation  can be done in one  slave  process  that  scans  the  two  tables  and joins  them  and  then  ships  the result to  the coor- dinator. Figure 6B shows  the  task  structure for this join.
Directedjoin. Let the  partition key for CUSTOM- ERS be CUSTKEY and ORDERS be ORDERKEY.
Here,  we  cannot perform a  collocated join oper- ation since  records of the ORDERS table with a  par- ticular CUSTKEY value could reside on all nodes.
The compiler recognizes  this from the  partition- ing information of the CUSTOMERS and ORDERS tables. It then  considers  a few execution strategies, the  foremost of which is  the  directed join.
The optimizer recognizes that  the CUSTOMERS ta- ble is partitioned  on CUSTKEY. So, one efficient way  to match  the CUSTKEYs of ORDERS and CUS- TOMERS is  to hash the selected ORDERS rows us- ing its CUSTKEY attribute  and direct the  rows  to the  appropriate CUSTOMERS nodes. This  strategy localizes the  cost of the  join to partitions  at  each node  and  at  the  same time tries to minimize the data  transfer. Figure 6C shows  the compiled plan for  this  strategy.
Broadcastjoin. Consider  the following query  be- tween  the CUSTOMERS and SUPPLIERS table.
SELECT CUSTNAME, SUPPNAME, C-NATION from CUSTOMERS, SUPPLIERS where C-NATION = S-NATION The  query  tries  to find customers  and  suppliers in the same region. Let  the partitioning key  for CUS- TOMERS be CUSTKEY and  that of SUPPLIERS be SUPPKEY. Note that C-NATION and S-NATION could have  been  the  respective  partition  keys of the  two  tables;  however, CUSTKEY and SUPPKEY are used more  often in queries  and  are  more likely candidates. Given this,  the  optimizer  cannot try to localize the  join  operation on the C-NATION and S-NATION attributes.  Hence,  a  strategy of broad- casting  the  selected  rows of either  table to all the nodes of the  other  tables  is  considered.  The  broad- cast  essentially  causes  one  table to be materialized fully at each node containing a partition of the  other table.  Now,  a  join  at all nodes will produce  the IBM SYSTEMS JOURNAL, VOL 34, NO 2, 1995 complete result of the  query. Figure 6C also shows a  broadcast  join (with the ORDERS table being re- placed by SUPPLIERS) and  the  arrow  connecting slave  task 1 to slave  task 2 being of type  broadcast as opposed to directed.
The  broadcast join operation  is relatively expen- sive  both in terms of network  cost  and  join  pro- cessor  cost.  However,  there  are  instances  where this  strategy  is still very useful. These  instances include situations  where  one of the joining tables is  much smaller than  the  other,  when  there is an index  on  a joining attribute,  or in nonequijoin sit- uations.
Repartitioned joins. We  also  consider  a  reparti- tioned strategy of join  execution in cases  such  as the  query  described previously. In this  strategy, the optimizer decides to explicitly repartition  both tables on their joining attributes in order  to local- ize and minimize the join effort. In  the  example query  previously  described,  the  optimizer will re- partition the CUSTOMERS table on C-NATION and the SUPPLIERS table on S-NATION on  some com- mon set of nodes. The repartitioned tables  can  then be  joined in a  collocated  join  fashion  at  each  node.
Figure 6D shows  the  repartitioned  join  strategy.
The  repartitioned  join  requires  message traffic to redistribute rows of both tables involved in the join.
Once  redistributed,  the  join  processor  cost  is sim- ilar to  the collocated  join  case.
Cost-based  optimization. One of the  most impor- tant  features of the optimizer is  that it uses  cost estimates  when deciding among different execu- tion choices.  This  is to  be  contrasted with an  op- timization technique  that heuristically decides  to go with a  particular  strategy. For example, given a join operation, the optimizer  estimates  the  cost of each of the  join  strategies  previously  described and  chooses  the  one with the  least  cost  estimate for  a given join step.  The cost basis  makes  the  op- timizer decisions  more  robust  when  choosing  be- tween  strategies  such as broadcast or repartitioned joins.
Cost estimation also enables the optimizer to choose  the  best  query  execution plan in a parallel environment. It  accounts  for  the messaging costs incurred by operations. Most importantly, estima- tion tries to influence parallel processing of differ- ent  parts of the  query  whenever possible. Figure 7 shows  two different types of query  execution

---

Figure 7 Different  execution  strategies in serial and parallel  environments plans  for  a  four-way join query.  Assume  that  ta- bles T1 and T2 are collocated on a nodegroup, while T3 and T4 are  collocated  on  an  entirely dif- ferent nodegroup in a parallel environment. An op- timizer for a  serial DBMS could choose  the  strat- egy in Figure 7A, because all the  operations  are performed in the  same  node  and  that is the  best serial strategy (possibly influenced by indexes, sort orders, etc.). However,  the DB2 PE optimizer may try  to favor  the parallel plan represented by Fig- ure 7B since  more  work  can  be performed in par- allel and the partitioning of tables  for  the  two low- ermost  joins  are optimal. Thus  proper  “parallel cost  measures”  are critical for parallel query  op- timization.
Parallelism for all  operations. A guiding principle in the compiler design has  been  to  enable parallel processing  for all types of SQL constructs  and  op- erations. For  the  sake of brevity,  only  a list of other operations  and  constructs  where  we apply paral- lelism while generating  the  execution  strategies  is provided.
304 BARU ET AL.
Aggregation-The ability to perform aggregation is required at individual slave  tasks and may be required  at  a global level.
Set operations-We consider collocated, di- rected,  repartitioned, or a global strategy akin to  the join  strategies  previously  described.
Updates-The ability to perform inserts with subselect,  updates, and deletes in parallel is re- quired.
Subqueries-We consider  collocated,  directed, and broadcast  methods of returning subquery  re- sults  to  the  sites  where  the  subquery predicate is evaluated.
DB2 Parallel  Edition  run  time In order  to execute  a  query plan or a DDL state- ment in parallel, DB2/6000 run-time mechanisms had to  be augmented considerably. The following new components  were  added to provide  interprocess (processes  may  be  on different nodes) communi- cation:
Control services-These services deal with in- terprocess  control  message flow (start  and  stop of processes,  error reporting, interrupts,  paral- lel remote  procedure call, etc.).
Table  queue services-These services  deal  with exchange of rows  between DB2 PE agents  across or within a  node  and  are  responsible  for  the  cor- rect execution of the  data flow operators  connect- ing different slave  tasks.
Communication manager-This service  per- forms the  actual routing of messages using the underlying communications  protocol.
In addition, several existing components had to  be modified for DB2 PE. They include the interpreter (the component that drives the execution of a  query plan),  deadlock  detector,  lock manager, transac- tion manager,  etc. In this  section, we describe  the new components, as well as  the modifications to the existing ones.
Control  services. When  an application connects  to a  database  (see  Figure 8), a  special  process  (or  an agent) called the coordinator is  created.  This  pro- cess  is responsible for executing database  requests on behalf of the application, returning  any  results through  the  reply  queue  and  shared-memory  area.
In  the serial case  this is all there is; but in the  par- allel case multiple processes  need  to  be  created  to execute  requests.  These  processes (agents) are  or- ganized into  a  network of producer-consumer  pro- IBM SYSTEMS JOURNAL, VOL 34, NO 2, 1995

---

Figure 8 Application and coordinator agent SYSTEM CONTROLLER ALL OTHER REQUEETS i , “

* I

cesses.  The  data flow through table queues, which are described in the following section.
The  query  subtask  (subsection)  executed  by  the coordinator distributes the  other  subsections to the appropriate  nodes to  be executed. Along with  ev- ery request, it sends connection information for the table queues  and  any host variable information that may  be required. There  are  separate  distribute  op- erators in the coordinator for each subsection. Typ- ically, the compiler can make static decisions about where  a  particular  subsection  needs  to  be  instan- tiated (generally based  on  the  nodegroups of the tables that the particular slave task accesses).
However, DB2 PE is capable of choosing  nodes  at run time, based  either on the  query  structure (e.g., a  query  select * from T1,  where T1.a = host-vari- able with T1.a being the partitioning key of T1, al- lows  the  table  access  to  happen  only on the  node that  contains  the partition for T1.a = host-vari- able), or on the  current I/O and  processing  activity of the nodes (for those  subsections  that  are not tied to specific nodes, e.g., those  that  execute  repar- titioned joins).
Creating  a  process  can be an expensive  operation.
For long-running queries,  this  process is amortized over  many millions of instructions,  but  for  shorter queries  this  can  be  considerable  overhead.  There- fore  several  optimizations  have  been  done  to  de- crease  this  overhead.
IBM SYSTEMS JOURNAL, VOL 34, NO 2, 1995 The  purist  view of process management is that  the “abstract  database  process” is created to  execute its  subsection,  then  terminates  when  the  subsec- tion is finished. In DB2 PE a pool of processes is initiated when  the  database manager is started  at a  node, and any of the  processes  can  be  reused  by different subtasks of the  same application or dif- ferent applications. The  process pool can signif- icantly reduce  process  creation  overheads for short queries.
Certain sequences of sQL operations  have  a  por- tion that is inherently  state-based. For example, cursor-based  updates  depend on a  previous  state- ment to position the  cursor.  Therefore DB2 PE pro- videspersistent agents  that remain assigned until the application disconnects. After such  an agent starts working on behalf of a  request, it remains attached to  the request’s  state until the  request completes. An alternative we explored was discon- necting a  process from a  subsection during idle times,  such as when waiting for a message to  be received or  sent.  The  extra overhead of saving and restoring  state  seemed  to overwhelm the  system savings. The  parameters determining this trade-off may change as system  speed  increases  dispropor- tionately to  the disk swap time.
In addition to the  requests  to  start  or  stop  pro- cesses, the control component also handles re- quests  to  stop  or  interrupt  processes,  returns  con- BARU ET AL. 305

---

trol replies to applications, and  provides parallel remote  procedure call support for low-level data- base manager functions (such as “retrieve long field” or “load access plan from catalog”).
Table  queue  services. The  interprocess  data flow constructs  are called table queues, and are similar to Gamma’s split tables. However, they  are richer in functionality. Intuitively, they  can  be thought of as a  temporary table. The most important dif- ference  is  that  they  do not need to  be completely built before rows  can be fetched from them. They are in effect streams of rows for interprocess com- munication, controlled by  the receiver’s ability to handle the traffic (back pressure). They have a  send operator  (table  queue build) and a  receive  oper- ator  (table  queue  access).
Table  queues  are designed to provide maximum flexibility to the SQL compiler and optimizer in gen- erating the  most efficient parallel plan. The plan specifies that  a  certain  table  queue is to connect two subsections of a plan. However,  each  subsec- tion can be instantiated  on  more  than  one node.
Therefore  a single table  queue  can  have more than one sender and more than one receiver; thus  a com- munication path  exists  between multiple producer and multiple consumer  processes  (see  Figure 9A).
Although it should be thought of as  one  entity, it is implemented by multiple connections,  between each  senderheceiver pair. Each sending process can  send  each row to every receiver process,  or to  just  one  process depending on  the partitioning information associated with the table queue.
There  are many attributes  associated  with table queues. An important  one of them is  Broadcast vs directing-does one row at the sending end go to all the  receivers, or only to  one?  See  Figure 9B for an example of a  directed table queue. In this fig- ure, all “A” values  are  directed  to  the first receive node from all sending nodes, all “B” values  to  the second, and so on.
Communication subsystem. The parallel commu- nications component  is layered in a similar fash- ion to  the  rest of the run time. It  accepts messages (either  control messages or buffers of rows) and guarantees ordered delivery between nodes (or be- tween processes on the same node). It also performs multiplexing and demultiplexing of messages be- tween nodes of a DB2 PE system. Underneath this layer, it uses the delivery layer, which can be  the User Datagram Protocol/Internet Protocol (UDPDP), 306 BARU ET AL.
Transmission Control Protocolflnternet Protocol (TCPDP), or proprietary high-speed switch interface.
Because  a message can  be  sent before the  process waiting for it is  ready to receive it, the communi- cations layer must hold messages until the receiv- ing process is ready. Some of the  issues  that had to be  solved  here  were determining if the  process to which a message was  directed had already  ter- minated, in which case  the arriving (or “in-flight”) message should be  dropped; or whether  the pro- cess had not  yet been created and so the message should be kept. The solution to this question re- lied on the communication manager to guarantee order of arrival of messages. That is, if message A is  sent from sender S on node 1 to receiver R on  node 2, then it must be received by R before R can receive any  other message sent  later  by S to R. (Exceptions  are made for the  class of “in- terrupt” messages.) Interrupt  and  error  handling. The assumption in- herent in the serial database manager is that  either the application is  busy  or  the  database  system is busy,  but not both  at  the  same time. Further,  the database  system is busy handling only  one  request per application. In DB2 PE, not only  can  the  data- base  system be active  concurrently  with  the ap- plication, it can be processing more than  one  query on behalf of the  same application. Multiple cursors may be open  at  any given time. Each  fetch of a cursor  returns  a single row, but  there could be pro- cesses on many nodes working to retrieve rows for that  cursor. A process may be initiated at  a  node when a  cursor is opened (execution of an open cur- sor  statement  by  the application) and it remains until it has completed processing of all its data or until the  cursor is closed by  the application.
So although a  row  may  be  ready  to  be  fetched, an- other node may have had an error.  The  semantics had to be defined for when  the  error indication is returned to  the application, whether it should be returned as soon as possible, as late as possible, or in its  “natural”  order. DB2 PE implements the “as soon as possible” policy, but it is by no  means clear this  is always the  best.  There  are many other examples of similar problems, where serial seman- tics  just  cannot  be maintained, e.g., interrupt  han- dling, forward recovery to current time, etc.
Concurrency  control  and  recovery. A parallel da- tabase must ensure  that individual transactions can be serialized and that  recovery from software and IBM SYSTEMS JOURNAL, VOL 34. NO 2. 1995

---

Figure 9 Table queues @ TABLE  QUEUE  AS  SPECIFIED IN PLAN 3 I TABLE  QUEUE AS INSTANTIATED [ DIRECTED

TABLE

I I TABLE QUEUE II hardware  failures  are possible. Serializability (se- rialization of transactions)  is  obtained by using a standard  two-phase locking protocol,  and  recov- ery from failures (durability) is obtained by using a two-phase commit protocol. This section de- scribes  the specifics of each of these  subjects.
Two-phase commitprotocol. One  important prop- erty of database  systems  is  to  guarantee  that ei- ther all actions of a user  transaction  take effect or none  take effect. Since a transaction  can  be  exe- cuted  on multiple processors  concurrently in a par- allel database  system, it is  much  harder to provide IBM SYSTEMS JOURNAL, VOL 34, NO 2, 1995 the all or nothing property.  To  guarantee this prop- erty, most parallel systems  adapt a two-phase com- mit protocol  that  includes a prepare  phase  and a commit or abort phase. The two-phase commit pro- tocol may result in blockirtg if the  coordinator fails after it has  received  votes  but  before it sends  out an  outcome. When blocking occurs,  participants will hold or lock  resources for a long time, result- ing in significant degradation in system perfor- mance. Three-phase commit protocol30  has  been proposed  to  remedy  the blocking problem. But  be- cause a three-phase commit protocol imposes much higher overhead  than a two-phase  protocol,

---

Figure 10 Transaction state transition in DB2 PE and the blocking problem can be “resolved”  by system  administrators, none of the existing com- mercial systems currently supports  the three-phase protocol.
There  are  three  variations of the  two-phase com- mit protocol: presumed nothing, presumed com- mit, and presumed abort. 31 DB2 PE adopts  the  pre- sumed  abort protocol that  assumes  a  transaction has  aborted  when  the  state of the transaction  was inquired by any subordinate  nodes and the  state cannot  be found in the in-memory transaction  ta- ble. Figure 10 shows  the transition of transaction state in DB2 PE. When a  transaction  starts,  a  co- ordinator agent is activated to coordinate  the ex- ecution of the transaction. Subordinate agents (DB2 PE agents), if needed,  are activated by  the  requests sent from the  coordinator agent. Before process- ing a commit or rollback request,  the  transaction at both coordinator and subordinate nodes is in the active state.
DB2 PE maintains a  transaction node list for every active  transaction  that  contains  the  node  numbers of all nodes participating in executing the  trans- action. When a  coordinator agent receives  a com- mit request from an application, it sends  out  pre- pare-to-commit requests to the PDB request  queues of all nodes  recorded in the  transaction  node list, including the  coordinator  node itself. At this point, the  coordinator agent enters  the prepare state.
308 BARU ET AL.
Upon receiving the prepare-to-commit request, the DB2 PE agent controller  at the coordinator node is responsible for stopping active  agents  associated with the committing transaction. However,  the  co- ordinator itself is responsible for processing the prepare-to-commit locally. Notice that  there is no prepare log written  at  the  coordinator node before starting  the prepare phase in DB2 PE. At a  subor- dinate node,  a prepare-to-commit request  is  pro- cessed by an active agent associated with the trans- action if one exists. Otherwise, a new agent is selected by  the DB2 PE agent controller to process the request. The commit agent first checks the transaction  state  stored in the local transaction  ta- ble. If the transaction  encountered  any  error and thus  cannot  be  committed, it  will vote  “no”  to  the coordinator and enters  the abort state. Otherwise, it  will reply  “yes” and enters  the prepared state if it has modified its local database. If a participant does not update  its local database and is ready to commit, it  will reply “read-only” and enters  the commit state.
If everyone  votes  “yes” or read-only, the coor- dinator commits the  transaction and informs all participants  who  have  voted  “yes.” At this point, the  transaction  state  changes  to commit at  the  co- ordinator node. Otherwise, the  coordinator  aborts the transaction and forwards the decision to all sub- ordinate  nodes  that  voted  “yes.” All actions  per- formed for the  transaction  at all nodes  are rolled IBM SYSTEMS JOURNAL, VOL 34, NO 2,  1995

---

back  (undone) and the  transaction  state is changed to abort.
Concurrency control. Parallel database systems need to maintain consistent global locking across all nodes  because  a  database  object  (record,  table, index,  etc.)  may  be  accessed by multiple nodes concurrently and deadlocks may occur among nodes.  This  requirement  posts  a significant chal- lenge to parallel database system designers. In shared-memory and shared-disk  systems,  data  can be  accessed by multiple nodes  concurrently. In or- der  to maintain a  consistent global locking, a  node needs  to  obtain read and write permission either explicitly or implicitly from all other  nodes  before reading or writing a  data  object  for which it does not already own an appropriate access permis- sion-hence the requirement for some form of global lock management. In DB2 PE, each  proces- sor  accesses  only  the  portion of the  database  that it owns locally. Consequently,  a  processor  does not have  to  request  access permission from remote processors  before  accessing  its local data;  thus  a global lock table is not  required.  However, DB2 PE does require a distributed deadlock detector to check for global deadlocks.
In DB2 PE, a  lock table and local deadlock  detector are  created for each  database and node  to main- tain locking information and to  resolve conflicts among lock requests  for  a given database.  A  trans- action  may  have multiple processes  active  on  its behalf and  each  process  requesting  a  lock will be assigned a  separate lock request block. When two processes of the  transaction make a  lock  request to  the same  object,  the  one lock request block per process design uses  more  memory  space.  How- ever, it  simplifies the design in processing lock con- version  requests and lock  release  requests  before the  end of a  transaction.  The local deadlock  de- tector  is implemented as a  separate  process  and awakens periodically (becomes  active) to scan  the local lock table and to build the local wait-for graph.
It then  sends  the local wait-for graph  to  the global deadlock  detector (GDD) for processing.
Global deadlock  detection is also implemented as a  separate  process.  There is one global deadlock detector  per  database  opened  per DB2 PE system.
Currently,  a  transaction is not allowed to  access multiple databases  at  the  same  time and thus  one GDD per  database is the  most efficient method. The GDD process  resides  on  a preconfigured node. On a  user configurable time interval, local deadlock IBM SYSTEMS JOURNAL, VOL 34, NO 2, 1995 detectors  send  their local wait-for  graphs  to the GDD. The GDD merges the graphs received and builds a global wait-for graph based  on  the  trans- action identifier that  is unique across all nodes in a DB2 PE system.  After  the completion of building the global wait-for graph,  the GDD goes through it to find deadlock  cycles in the graph. When a  cycle is detected,  one or more  transactions  are  selected and rolled back to break  the cycle. When a  trans- action  has  been  selected as a  deadlock  “victim,” its  coordinator agent (process)  is informed by the agent requesting the lock and the coordinator agent will send a rollback request to its subordinate agents  (processes)  to  undo  the  action of the  trans- action.
Database utilities DB2 PE provides  a  variety of utilities to manage the parallel database  system.  Some of the  important utilities are described in the following subsections.
Data loading. The load utility allows bulk loading of database  tables from flat files. To  support ap- plications requiringvery large database  sizes (hun- dreds of gigabytes and higher), DB2 PE provides ef- ficient ways of loading large volumes of data  into the  database.  Data  can be loaded in parallel into a single table  by invoking the load utility at each of the  nodes  that  contains  a  table partition for  the given table. Typically, the input data  are  stored in a single flat  file. A  data partitioning utility as well as application programming interfaces provided with the  database  system  can  be used to partition an input file into multiple files, one  per  table  par- tition. The partitioned files can  then  be  loaded in parallel. In addition, at  each  node,  the load utility reads  the input data file and  creates  data  pages in the  internal  format used by  the  database engine.
These pages are  directly  appended to  the existing database file, thereby  greatly increasing the  speed of the load utility.
Adding nodes to  the system. DB2 PE supports  scal- ability by allowing incremental addition of nodes to  the shared-nothing parallel system.  Thus,  a  user can  start with a  system configuration that is suf- ficient to handle current  storage and performance requirements and add  new  nodes as  the size of the database grows. New  nodes  can  be  added to in- crease  storage  capacity as well as performance.
The command, Add Node, allows users to add nodes to  the parallel database  system configura- tion and to initialize the  node  for  use by  any da-

---

tabase. Once added,  a  node  can  be used by  a da- tabase by including it in one of the nodegroups in the  database (either the CREATE or REDISTRIBUTE NODEGROUP statements  can  be used for this pur- pose). Since DB2 PE supports partial declustering of tables, the set of all tables for a given database may reside  only on a  subset of the  nodes in the sys- tem. However,  an application can  connect to any database from any  node in the  system, regardless of whether  that node contains  data pertaining to that  database.
The  Drop  Node command can  be used to verify whether  a  node  can  be dropped from the  database configuration. If the node to be dropped is currently in use  by a  database,  then  the node should not be dropped.  The Redistribute Nodegroup command (described in the  later  subsection  on  data redistri- bution) should be used to remove any  data from this  node before dropping it.
Creating  a  database. Normally, issuing the  Create Database command ensures  that  the  database  is defined across all the  nodes  that  are  currently in the system. Similarly, the Drop Database com- mand drops  the  database definition from all nodes.
However,  there  are  situations in which one may wish to  create and drop  the  database  only  at  a sin- gle node. For example, the Add Node command described above implicitly performs a  create-da- tabase-at-node  operation for each existing data- base. Also, in case the database at a particular node happens to  be damaged, the Drop Database At Node command allows the  user to drop  only  the database  at  that  node  rather  than dropping the  en- tire database  across all the  nodes of the system.
Since DB2 PE supports node-level backup and re- store  (see  the  later  section  on  backup and restore), after dropping a  database  at  a  node,  the  database backup image can be used to restore  the  database at  that  node (and roll forward the logs, if neces- sary) - Data  reorganization. As a result of insert,  delete, and update activity, the physical layout of data- base  tables may change. Insertions may result in the  creation of overflow data blocks and, as a  re- sult,  the disk pages containing data belonging to the  table may no longer be stored contiguously.
On the  other  hand, deletions may create gaps in disk pages, thereby resulting in an inefficient uti- lization of disk space. If a table is partitioned across a set of nodes, insert and delete activity may also result in table partitions at some nodes having more 310 BARU ET AL.
data than those  at  other nodes, thus creating a skew in data distribution. Also, in many decision sup- port applications, the  database  size  increases  with time. Thus, it may be  necessary to increase  the de- gree of declustering of a  table in order  to accom- modate the additional data. Finally, even if the size of the  database remains the same, the workload may change, thereby requiring a change in data placement.
In all  of the  above  situations,  data reorganization utilities can  be used to manage the physical stor- age of the table. The following subsections describe the  data reorganization utilities available in DB2 PE.
Table reorganization. The Reorg utility can  be used for compaction and reclustering of database files at each node. The Reorg operation executes in par- allel across all the  nodes  that  contain  a table par- tition for a given table. The file  in which the da- tabase  table is stored  is reorganized by creating  a new file without any page gaps and overflow blocks. If the  operation completes successfully on some nodes  but  not  on  others,  then  the  table  par- titions remain successfullyreorganized at the nodes where Reorg succeeded.
This is an example of an operation where the atomic commit semantics of the database  opera- tion have been relaxed. If the  operation  were to be atomic, then upon failure, the Reorg would have to  be  undone  at all the  nodes  where it completed successfully. However,  the Reorg operation may be time-consuming and undoing it may be even more expensive. In addition, consider the case when Reorg succeeds on, say, 60 nodes  but fails on 1. It  is more beneficial not to undo  the  oper- ation. In  this  case,  the  operation  returns an error message but is not undone  since  there is no pen- alty if some  partitions  are reorganized while oth- ers are not. On the  other hand, the  nodes  at which the partitions were reorganized would benefit from the resulting file compaction.
Data redistribution. The partitioning strategy used to partition tables may, in some  situations,  cause a  skew in the distribution of data across nodes. This can  be  due to  avariety of factors, including the dis- tribution of attribute  values in a relation and the nature of the partitioning strategy itself. At initial placement time, it is possible to analyze the dis- tribution of input attributevalues and obtain a  data placement that minimizes skew. However,  data skew may be  reintroduced  over  the  database life- IBM SYSTEMS JOURNAL, VOL 34, NO 2, 1995

---

time due to insertion and deletion of data. DB2 PE provides  a  data redistribution utility to redistrib- ute  the  data in a  table in order  to minimize skew.
For a given nodegroup, the  data redistribution op- eration  determines  the  set of partitions of the  par- titioning map  that should be moved in order  to  ob- tain an  even  distribution of data  across  the  nodes of the nodegroup. The default assumption is that the  data  are  evenly  distributed  across  the 4K par- titions; thus, if the partitions are evenly distributed among the  set of nodes,  then  the  data are also  as- sumed to  be evenly  distributed  across  the  nodes.
The user may override  this default assumption by providing a distribution  file that assigns a weight to each of the 4K partitions.  In  this  case,  the  re- distribution  operation will attempt to redistribute partitions among nodes  such  that  the  sum of the weights at each node is  approximately  the  same.
If a  nodegroup  contains  several  tables,  then redis- tributing only one table and not  the  others will re- sult in a loss of collocation among the tables. In order  to  preserve  table collocation at all times, the redistribution  operation is applied to all the  tables in the nodegroup and each  table is redistributed in turn. If a  redistribute  operation  does not complete successfully, it is likely that some tables in the nodegroup  have  been  redistributed while others have not. In  this  case,  the  operation  can  be  com- pleted by issuing the  Redistribute command with the restart option. It is also possible to issue  the Redistribute command with  a rollback option, in order  to  undo  the effects of the failed redistribu- tion. The  Redistribute  Nodegroup command is an on-line operation  that  locks  only  the  table  that  is currently being redistributed. All other  tables in the  nodegroup  are normally accessible.
The  data redistribution utility also  permits  users to redistribute data  by specifying a targetpartition- ing map for  a given nodegroup. Data  redistribu- tion of all tables in the  nodegroup using the  target positioning map is initiated through the application programming interface. This  interface  can be used to achieve  “custom”  redistribution of tables, e.g., send all rows with a particular partitioning key value  to  a  particular  node,  create  skewed distri- butions,  etc.  The  current  data  distribution  across partitions and nodes  can be determined using two new SQL scalar  functions, namely, PARTITION and NODE. These  functions  return  the  partition num- ber  and  node number to which a given row in a table is mapped.
IBM SYSTEMS JOURNAL, VOL 34, NO 2, 1995 The following example illustrates how the new SQL functions  can  be  used to obtain  the  distribution of the  rows of a PARTS table:
Query 1:
CREATE  VIEW  Partition-Nums(Pnum)  AS SELECT  PARTITION(PARTS) FROM PARTS;
SELECT  Pnum, COUNT(*) FROM Partition-Nums GROUP BY Pnum ORDER BY Pnum;
Query 2:
CREATE  VIEW  Node-Nums(Nnum)  AS SELECT  NODENUMBER(PARTS) FROM PARTS;
SELECT  Nnum,  COUNT(*) FROM Node-Nums GROUP BY Nnum ORDER  BY  Nnum;
The  output of Query 1 is a  set of rows  where  each row  contains  the  partition number (0 to 4095) and the  number of rows of the  table  that  map to that partition.  The  output of Query 2 is  a  set of rows where  each row contains  the  node  number and the number of rows of the  table  that  map  to  that  node.
Backup and restore. The degree of parallelism achieved during backup  and  restore of a  database is  determined by  the number of backup  devices available. The DB2 PE backup  and  restore design allows each  node in the  system  to  be  backed up independently. Thus,  data from several  nodes  can be  backed  up  simultaneously, if multiple backup devices are available. The backup utility creates a  backup image of the  entire  database partition res- ident  at  a given node.
At  restore time, it is  necessary  to  ensure  that the database  partition  that  is being restored  is in a  con- sistent  state with respect to  the rest of the  nodes in the  system.  This  can be achieved by either  re- storing all nodes in the  system using backup im- ages that  are known to  be consistent, or  by restor- ing the single node  and rolling forward logs to  a point in time where  the  database  state is consis- tent  across all nodes. DB2 PE supports  the ability to roll forward logs across  nodes  to  a specific point in time.
BARU ET AL. 311

---

High availability. High availability is  supported by the  use of HACMP (highly available cluster multi- proce~sor)~’ software.  The HACMP software pro- vides  transparent  takeover of the disk and com- munications resources of the failed node. System nodes  are paired together  and  each pair has  access to twin-tailed disks (disks connected to two nodes).
If one of the  processors in a pair fails, the  other processor  can  take  over and the  system  can  con- tinue to operate. To enable use Of HACMP software, the  database engine has  been designed to allow the situation  where a single processor  executes mul- tiple copies of the  database engine. In other  words, multiple database nodes or logical nodes are mapped to the same physical node. While this method provides  quick  takeover of a failed node, there may be  an impact on performance due to in- creased load on  the  takeover  processor.  In  many decision support applications, it is  not essential to provide instant  takeover capability, whereas it is important not to degrade overall  system perfor- mance. Thus, it may be acceptable to have a par- ticular node  become inaccessible, for example for ten minutes, in order  to  be able to recover from a failure of that node without any  subsequent  per- formance penalty. This  can be achieved by con- figuring one  or more spare  nodes in the  system  that can  take  over on behalf of any failed node. When a node fails, its  database files are copied to  the spare node (access to the  disks  on  the failed node is available due to twin tailing) and the  spare  is now restarted as the original, failed node. In  this  sce- nario, only  the  node  that failed is inaccessible for a brief period of time while the remaining nodes in the  system  are still operational.
Performance  monitoring  and  configuration  manage- ment. Database monitoring tools allow users to identify performance bottlenecks and take  appro- priate action to relieve the bottlenecks. DB2 PE pro- vides a database monitoring facility that allows users to gather  data on resource  consumption at the  database manager, database, application, and individual process levels. These  data  are  collected at each  node and can be used to identify bottle- necks  at individual nodes. To obtain a global pic- ture of the  performance of the  entire  system, it is necessary to combine performance monitoring data across all nodes. A performance monitoring tool is being developed as a separate  product for this purpose.
The  database manager provides  several configura- tion parameters at  the  database manager and in- 312 BARU ET AL.
dividual database levels, that  can be used to  tune the performance of each  database and the  database manager as a whole. For example, users  can  con- trol the  size of buffers, maximum number of pro- cesses,  size of log  files, etc.  These  parameters  can be  set independently at each node, thereby allow- ing users  to  tune  the performance of each individ- ual node. Thus,  the configuration parameters  can be adjusted to account for differences in hardware capacities, database partition sizes, and workloads at each node.
Results We have performed a number of internal IBM and customer  benchmarks on DB2 PE and a brief syn- opsis of these  results  is presented here. The  results are divided into  three categories:
Stand-alone numbers-This basic metric in- cludes  capacity and load times.
Speedup-This metric measures the perfor- mance of queries and utilities as  we increase  the number of nodes in the  system while maintain- ing the  same  database size.
ScaleuyThis metric measures the performance of the  system as  the  database  size,  the number of concurrent  users, and the number of nodes are scaled proportionately.
The  system configuration for many of the  bench- marks  has  been  the IBM sP2 or sP1 systems.  The systems  have ranged from 8 nodes to 64 nodes  de- pending upon the  database  requirements of the in- dividual benchmarks. Typically, each node has 128 or 256 megabytes of memory and 2 to 48 gigabytes of disk capacity. The  nodes  are  interconnected us- ing a high-speed switch. In  some of the bench- marks, we have  only used the slower Ethernet as the  interconnect path.
The  results  that  are described in this  section  were measured using early untuned drivers of the DB2 PE software, and specific hardware configurations (of- ten having a single disk per node). As such, the re- sults obtained in a different hardware or software environment may vary significantly. Users of these results should verify if they are applicable for their environments. The absolute values of a number of different metrics are likely to be different  in the final product.
Stand-alone  metrics. Table 1 describes  the impor- tant stand-alone metrics based on results of bench- IBM SYSTEMS JOURNAL, VOL 34, NO 2, 1995

---

marks performed to-date. One of the foremost met- rics  we would like to present is system  capacity.
When stating  capacity,  we must differentiate be- tween  user  data  size  (the  size of flat  files contain- ing the  data in normalized form), database size (the space occupied once  the  data  have  been loaded in DBZ PE, relevant indexes  created, and any required denormalized tables  created), and disk capacity (the total disk space used to support  the  database workload, including internal work  areas, interim load files, etc.). We have benchmarked applica- tions  with  over 100 gigabytes (GB) of user  data,  da- tabases of over 250 GB, and systems with more than 600 GB of disk space. One of the  tables in the da- tabase  has  been as large as 84 GB and contained over  2 billion rows. We expect  to  support config- urations in the  terabyte size. To put this into per- spective, even mainframe relational databases  are rarely  over 200 GB in size. Some of the  measure- ments  were  done using tables larger than  the 64 GB limit of many relational database management systems.
Another  very important metric is data load times.
Our fastload utility is  able to load data  at  rates of up to 2 GB/per node/per hour. The dataload utility runs in parallel at all nodes, hence it demonstrates a completely linear speedup of load rates.  In  a 32- node  system,  one could load at  the  rate of 64 GB per hour.
Before loading, the data must be  declustered and sent  to  the  appropriate node. The utility used to decluster  data  (data  splitter)  is flexible and can  be modified by  the user in situations  where fine tun- ing is required. The  data  splitter  can  be  executed on  a  variety of IBM operating system platforms in- cluding Advanced  Interactive  Executive* (AIX), Multiple Virtual Storage (MVS), and VM. In most cases  we also divided the input data so as  to run the  splitter in parallel. The  output of the splitter must  then  be  sent  to  the  appropriate  node for load- ing. In certain  benchmarks  this  was  done by send- ing the data in  file format using FTP (File Transfer Protocol), while in other  benchmarks  the  output from the  splitter  was piped directly into  the load program. In most cases,  the  connectivity  between the  system containing the  source  data and the  tar- get database  system  was  the limiting factor  on  the entire  database load process.  For  a 100 GB data- base  on  a 46-node SPZ system,  the elapsed time for partitioning all the  data, loading the  data, and cre- ating indexes on the tables was  just 12 hours.
IBM SYSTEMS JOURNAL, VOL 34, NO 2. 1995 Table 1 Stand-alone metrics .
Data size 100 GB and larger Database size 250 GB and larger Table size 84 GB (2 OOO OOO OD0 rows) Total disk space over 600 GB Data splitting 2 GB per node per hour Data load rate 2 GB per node per hour Table 2 Database description for speedup experiments fable No. of Rows Row Size Total Sire 1 OOOo00 100 MB T2 1OOOo00 100 100 M 3 w1 1OOOooo loo0 1 GB The final stand-alone metric is availability. In  these benchmarks, we have tried to maintain several spare  nodes for replacement in the  event of node failures. Due to the decision support  nature of the benchmarks, only a few nodes  (those containing database catalogs) in the  system may need the  use of special availability mechanisms such as twin- tailing of disks. For all other  nodes, in the  event of failure, the  data residing on  the failed node can be reloaded onto  the  spare node and the  spare node is  then used as a replacement node. We have  been able to accomplish this  task in a time that  is  only dependent on the  data load rate for the node. For example, on the 100 GB database on 46 nodes, this task  was accomplished in less  than two hours.
Speedup results. For  speedup, we present  results from an internal benchmark performed on 4,8,16, and 32 node SPZ systems. 33 Table  2  describes  the database configuration used. The database consists of four main tables (Sl, T1, T2,  W1) and each  ta- ble contains  a primary key along with  other non- essential attributes.  The S1 table contains 100 000 rows, while the T1, T2, and W1 tables contain a million rows, respectively. S1, T1, and T2 tables contain  rows with a  size of 100 bytes, while the W1 table has  a maximum row size of 1000 bytes and an average row size of 560 bytes.
Scan  performance. Figure 11 shows  the  execution times and the  speedup of parallel scan  operations on  tables T1 and W1 returning 1 row to the appli- cation. They axis on  the left shows  the  execution times, while the y axis on the right measures speedup  that  can be a maximum of 8. The  scan of

---

Figure 11 Execution  times  and  speedup of parallel  scan  returning 1 row of T1 and W1 tables TABLE T1 TABLE W1 4

8 12 16 20 24 28 32 NUMBER OF NODES - SCAN EXECUTION TIME .""_" SPEEDUP FOR SCAN 4 8 12 16 20 24

28 32 NUMBER OF NODES - SCAN AND RETURN EXECUTION TIME . - - - - - - - SPEEDUP FOR SCAN AND RETURN the  T1 table  exhibits linear speedup, i.e., the  ratio of the execution times is auctly the  inverse of the ratio of the number of nodes,  when  the  number of nodes is increased from 4 to 8. Beyond this point, the speedup  becomes  sublinear,  due to  the smaller size of the table. In contrast,  the  scan of the  W1 table  exhibits linear speedup  up  to 16 nodes  and only  then  becomes slightly sublinear. If the  table scans had been performed using more  nodes, the execution times would eventually flatten out  when the table partitions at each node become small enough so that  the  overhead of initiating the  scans at  the different nodes offsets the performance gain from the parallel scan.  This figure illustrates  that the parallelism benefits are  bounded by  the  sizes of the  tables  for  any  operation.
Figure 12 illustrates the performance of a parallel scan  operation on  the W1 table  that  returns 10 per- cent of the  rows to  the application. The  execution times  improve as  the  system  size is increased  but the  speedup  is  quite  sublinear.  The  reason for this has  to  do with the processing performed at the  co- ordinator node in fetching 100 000 rows (10 percent) of the  data  and  returning it to  the application. Am- dahl's Law effectively limits the maximum perfor- mance  improvement  from  such  queries  due to  the serial bottleneck. To overcome this bottleneck,  the application must be parallelized. One simple way of doing this  on DB2 PE is to divide the application into multiple tasks,  each running on a  separate  co- ordinator. The division can either be based on range of data  or  be  such that  each  task  operates on a  subset of the  database nodes. The issue of par- allel applications is further  discussed in a  later  sec- tion on experiences  and  observations.
Insert, updatepe$ormance. Figure 13 shows  the execution times for performing insert  into  a  tem- porary  table of 1 row, 1 percent of the  rows, and 10 percent of the  rows of the T1 table.  The figure is plotted using a logarithmic scale  (base 2) on both thex  andy axes.  In  such  a  graph, linear execution time curves (with appropriate  slope)  indicate lin- ear speedup. All three curves show near linear speedup gains with increasing system size. We  are able to parallelize both  the insert as well as the  sub- select  operations of this  statement resulting in lin- ear speedup of the statement across different nodes.
314 BARU ET AL.
IBM  SYSTEMS  JOURNAL, VOL 34, NO 2, 1995

---

Figure 14 shows  the  execution times of update col- umn operations on 1 percent, 10 percent, and 100 percent of the rows of the S1 table. Once again, the  execution times decrease  linearlywith  increas- ing system size. The 1 percent and 10 percent up- date  curves  show  somewhat  anomalous  behavior at 32 nodes. We  conjecture  that  the relatively small number of updates at each  node of the 32-node sys- tem  (approximately 300 for 1 percent)  makes  the execution  times really dependent on the parallel scan times for 32 nodes. Both  these  results illus- trate  the  extremely parallel query  execution  strat- egies that DB2 PE is able  to  generate  for  insert, up- date, and delete SQL statements.  The parallel insert was particularly useful in benchmarks  when in- terim results  were  saved in tables  for  later anal- ysis .or when denormalized tables  were  created from normalized ones.
Indexcreatepegormance. Figure 15 shows  the  ex- ecution  times of a  secondary  index  creation on the 100  000-row S1 table  and  the 1000 000-row T1 ta- ble. Both curves illustrate close  to linear perfor- mance  improvement, indicating that  the  create in- dex operations  are very efficiently parallelized in DB2 PE. The  reader  should  note  that  there is no dif- ference  between primary indexes  and  secondary indexes in our  system  due to  the function shipping model of execution.  However,  the  same is not true for other parallel database processing systems, where  secondary  indexes  are global and  cannot be efficiently parallelized.
Scalability results. We present  three different types of scalability results:
1. Results from performance  experiments  as  the 
database  size  scales from 10 GB to 100 GB on the  same number of nodes
2. Results from performance  experiments as  the 
database size and the  system size are scaled pro- portionately
3. Results from performance  experiments as the 
number of concurrent  users on the  system is in- creased The  results for all three  cases  have  been  obtained from customer  benchmarks.
Table 3 shows  the  performance of DB2 PE on a 46- node SP2 system for 10 GB and 100 GB versions of a  scalable  database.  The  results  are  shown for a variety of complex  queries on the  database.  The scaling ratios for the different queries  varies  be- IBM  SYSTEMS  JOURNAL, VOL 34, NO 2, 1995 Figure 12 Execution times and speedup of parallel  scan returning 10 percent of the  rows on W1 table TABLE  W1 50 1 t -*""""""""""""""() 2 I ./' *""------- 0 - ~ : , , ~ , , , , 1 , , , , , , , , 1 , , , , , , , , , ~ 4 8 12

16

20 24 28 32 NUMBER  OF  NODES - SCAN AND RETURN EXECUTION TIME . - - - - - - - SPEEDUP  FOR  SCAN  AND  RETURN Figure 13 Execution times of 1 row, 1 percent, and 10 percent  insert  with  subselect  statements TABLE  T1 - 4 c 16 32 NUMBER OF NODES - 10 PERCENT OF THE ROWS - 1 ROW .""_" 1 PERCENT  OF  THE  ROWS

---

Figure 14 Execution times of 1 percent, 10 percent, and 100  percent  update  with  subselect  statements Figure 15 Execution  times of create  secondary  index statements  on  the  S1  and  T1  tables Table 3 Performance of complex  queries on  a 46-node SP2 for  database  sizes of 10  GB  and 100 GB Query Descrlptlon

Response

Times 10 GB 100

GB Ratio Six-way  join, 14 columns,  three  tables 22

132
5.0 
Insert/select of two-way join, select  temp 26

186
7.15 
Simple select, SUM, group  by,  order by 163

1

177
7.22 
Two-way join, not e q u a l predicate, in list 174 1 521
8.74 
Create  temp,  inserthelect  (four-way join), select  temp 694 7 234
10.42 
Union of two two-way  joins 253 2 647

10.46 
Three-way join, three  tables,  avg.,  group  by,  order by 240 3 340
13.91 
Two-way  join,  between  predicate,  group by, order  by 164 3

682

22.45 
Insert/select,  select,  three  tables,  distinct 157 4 147
26.4 
tween 5 and 26.4. Since the 100 GB table is  ten times (10 X ) as large as the 10 GB table, strictly linear scal- ability would result in response-time ratios of 10.
Response-time ratios of less  than 10 show  super- linear speedup;  thus for most of the  queries, DB2 PE is able to generate an equal or larger amount of parallelism on the 100 GB database  when compared to  the 10 GB database.  The scaling factor of the last three  queries in Table 3 is sublinear (ratio  greater than 10). These  three  queries include order  by  or distinct clauses that require sorting to be performed on  the intermediate results  at  the coordinator. This causes  a serial bottleneck and translates  into  a re- duction in the  scaleup ratio. Consider next  the fol- lowing complex  business  query:
SELECT Count(*) FROM  Customers WHERE Class IN ( ' l ' , '2', ' 4 ' , ' 6 ' ) AND  Cust-No  NOT IN (SELECT  0-CUST-NO  FROM  Offers WHERE 0-DATE IN (list of dates)) (SELECT  0-CUST-NO  FROM Offers AND  Cust-No IN WHERE 0-DATE IN (list of 2 dates) AND  Response = ' Y ' ) IBM SYSTEMS JOURNAL,  VOL 34, NO 2, 1995

---

Figure 16 shows the scalability results for this query, as the  system  size is increased from 4 to 64 nodes and the  database  size (which includes index files) is  proportionately  increased from 2.5 GB to 40 GB. This  is  an important result, since it indicates that  the  overhead  introduced by the function ship- ping model of execution is relatively small and does not affect the  execution times of complex queries.
Table 4 shows  the  results of a concurrent execu- tion scalability test on  the system. The  test was performed using a 23 GB database on an eight-node S P ~ system. In  this  test, we compare  the  response time of queries submitted by a single user to that of 20 and 30 concurrent  users.  First,  we measured the  execution times of the  query  suite consisting of 15 complex  queries  when  they  were submitted in a single stream  by  the single user.  These  exe- cution times  are shown in the  second column of Table 4. Next,  the  queries  were  concurrently  sub- mitted by 20 and 30 users, respectively. Each  user submitted  one of the 15 queries. In  order  to dis- tribute  the  coordinator  activity  over all nodes in the system, the  users  were connected to the 8 nodes in the S P ~ in a round-robin fashion. Columns three and four show  the scaling ratios of the  execution times of the different queries for the 20 and 30 users, respectively. The  results  show  that DB2 PE is able to scale superlinearly with respect to the concurrent users. There  are several reasons for the superlinear performance scaleup. Similar to serial databases, DB2 PE is able to make better  reuse of the  database buffers at  each  node  due to  the com- mon concurrent  requests.  This  reuse  occurs  at all nodes, thereby providing a significant benefit. An- other very big contributing factor  is  that  the  con- current  users  can  connect to all nodes in the  sys- tem and distribute  the application and coordinator load evenly  across  the nodes. In  this experiment, the last row of Table 4 shows  the  total elapsed time for completing the  entire  query  suite.  The  results show  that 30 queries (two executions of the  query suite)  were completed concurrently in a time that was only 1.5 times worse  than  the single user, sin- gle stream  test.  Not all parallel database  systems have this feature. Many of the parallel database systems  are backend machines that  have specific interfacing systems  for application entry, and their multiprogramming levels are limited by the  capa- bilities of this front-end system. DB2 PE does  not have  this restriction and  provides significant con- currency benefits to users.
IBM SYSTEMS JOURNAL,  VOL 34, NO 2, 1995 Figure 16 Performance of a  complex  query  as  both system  size  and  database  size  are proportionately  increased !I==- !$ 800
* O l 
200 k 8 16 32 64 NUMBER OF NODES (2.5GB) @GB) (1006) (2068) (aOGB) DATABASE  SIZE IN OIGABVES Table 4 Performance of queries  with  scaling of the number of concurrent  users Query

Slngle

User Scaling Ratios Exec. Tlmes 20 30 (sea) Users

Usen, QO1 2 5 8 Q02 15
3.4 
3.4 
Q03

45
7.1 
12.4 
Q04 68
12.4 
23.24 
Q05 93
1.34 
2.08 
Q06

331
10.6 
18.9 
Q07

447
3.53 
6.55 
Q08

493
4.84 
8.62 
Q09

541
4.77 
8.57 
Q10 722
4.9 
8.77 
Q11

755
4.69 
8.57 
Ql2 1140
4.75 
8.74 
Q13

1159
3.4 
6.17 
Q14

1557
4.24 
8.23 
Q15

1592
4.23 
7.95 
Total Elapsed Time 8491

8435

12828 BARU ET AL. 317

---

Discussion. We have  presented  a flavor of the  re- sults  obtained from several  internal  and  external benchmarks  performed so far using DB2 PE. The results  that are presented  here  have all been  ex- tremely positive on the performance of the  system.
The  speedup  and scalability results  have  been  con- sistently  excellent for most  types of queries  and utilities. The  results  vindicate  most of our design decisions in the  generation  and  execution of op- timal parallel strategies.
There  are  a few types of queries  that do not  result in linear speedup or scaleup. These  queries  are typ- ically those  that require significant serial workwith respect  to  the total  work in the queries.  The  per- formance of an  example  query  type, which returns a significant number of rows to  the application, was described in the section on scan  performance.  An- other example is a query requiring coordinator sorts  or distinct  operations. When the  coordina- tor  activity  is high  in proportion  to  the  total  activ- ity,  the  performance  improvement of the  system can  decrease.  We  are  working  on improving the execution  strategies  for  such  types of queries to improve  performance.
Also, the  performance of queries  that  are  executed in extremely  short  times on a  serial  database  can- not be  improved much further  by  the  use of par- allelism. This is because  the  serial  database  exe- cution  strategy is quite efficient, and parallelism is not going to provide  any  improvement on the ex- ecution of such  a  strategy. An example is index- only  selection of a single row of values.  Here, the result  is  a single row and  only  requires  access to the  appropriate  index  entry. Parallelism can  ben- efit such  a  query  only if the  index  happens to  be extremely large.
Overall, the  capacity,  speedup,  and  scaleup im- provements of DB2 PE for  a very high majority of the  queries  far outweigh the  very small class of que- ries described above with smaller performance gains.
Experiences  and  observations We  have  learned  much,  both  technically  and  or- ganizationally, during the four years we have worked  on  this project. The  Research Division pro- duced  an initial prototype, with function incremen- tally added.  This allowed us  to show “proof of con- cept,” and maintain project  momentum during the organizational changes that occurred. When the de- 318 BARU ET AL.
velopment  laboratories  became involved with the project, we continued in a closely allied joint de- velopment mode, with the product  development meeting ISO 9000 standards.  The  joint development worked  much  better  than  the alternatives-spec- ifying the  product in intimate  detail,  or  just  hand- ing over  the  prototype. It  has  certainly  been  a  re- markable experience that two teams-research and development-with such  disparate  backgrounds have  been  able  to  work so closely  together.
As  the  work progressed, it became increasingly clear that while the initial prototyping efforts in the project had given us a good understanding of the fundamental issues (section management, run time, initial query optimization, etc.),  the  work required to produce  an industrial strength parallel database manager was still sizeable.
In the  rest of this  section, we highlight some of our technical observations  about  the  product.
Function  shipping. At  the  onset,  we  made  a  tech- nical decision to use function shipping with shared- nothing hardware.  This decision provided multi- ple benefits. Because we were working on a  shared- nothing platform, we had to parallelize every database operation-query operator, DDL state- ment, and utility. While this resulted in a larger de- velopment effort, its positive impact was  that it dis- ciplined us  to  think in parallel concepts.  The  result is a  scalable  product  where parallelism is  the  cor- nerstone-not just in simple scans and joins,  but also in updates,  subqueries, utilities, etc.  Contrast this with some of the  alternatives, which build lim- ited parallelism on top of a shared-something envi- ronment and leave the more difficult operators (up- dates,  subqueries, etc.) single-threaded.
Another benefit of our initial decision has been that most of our  system limits scale linearly. Thus  our tables (base and intermediate) can be N times larger, a  query  can typically acquire N times the number of locks, etc.  This  is  a straightforward con- sequence of doing all operations in parallel.
Query  optimization. Our initial effort for  generat- ing parallel plans  was to transform  the optimized serial plan into  a parallel plan. This decision was a  matter of programming convenience, encouraged by initial studies  that indicated that  this  often  pro- duced the best parallel plan.3 However, as we explored  more and more  complex SQL, it became increasingly clear  that  our  approach,  far from min- IBM SYSTEMS JOURNAL, VOL 34, NO 2, 1995

---

imizing coding, was doing quite the opposite. For example, we  were making the  same  kinds of dis- covery  about  ordering  requirements in the  post- optimization phase  as  the optimizer had made. Fur- thermore, it was also clear  that  without knowledge of partitioning, the optimizer was likely to come up with some very inefficient  plans. For example, in select * from T1, T2, T3 where T1 .A = T2.B and T2.C = T3.D the optimizer might decide to join T2 and T3 first (because of its  internal  decisions on size,  etc.), whereas in the parallel environment, T1 and T2 might be  compatibly  partitioned and hence should be  joined first.
We  therefore rejected the  post-optimization ap- proach and developed an integrated cost-based op- timizer that  understands parallelism, partitioning, messages, etc.  This  has  been  a  sound decision re- sulting in a  quality  product.
Parallel  utilities. Database  literature  and  research in parallel databases  have generally concentrated on what is considered  the  hardest problem-join processing. However, as  we dug more  and  more into  the making of a  product, we realized that in a  true  decision  support  environment, we cannot operate on data until the  data  are  correctly in place.
We thus  put in a lot of effort to make sure  that  the data  can  be initially loaded,  balanced, and indexes created and generally prepared for subsequent que- ries, all at  speeds viable for hundreds  or  thousands of gigabytes that  are typical in these environments.
People have criticized the shared-nothing approach because  its  static  data partitionings can  be skewed.
We  have provided rebalancing tools  that  do  not bring database  operations to a grinding halt and work  one  table  at  a time. Overall, our parallel util- ities are  as important as our parallel query  process- ing, and we will strive to continuously  improve on them.
Serial  semantics. We have tried to provide  trans- parent parallelism by maintaining serial semantics.
Since we  try and  achieve  the maximum parallel- ism by invoking read-ahead  operations  wherever possible, the  users  can  see  behavior different from their serial applications. An example of such  be- havior can  happen  when  cursor-controlled  oper- ations  interact with read-ahead  operations.  Other examples  where  the  semantics  are different from a serial database engine include error reporting and IBM SYSTEMS JOURNAL,  VOL 34, NO 2, 1995 recovery triggered during blocked inserts. In se- rial machines  the  behavior is fairly predictable, since all operations are done by  one  process.  The same  cannot be said of the parallel product. In such cases,  the  user will have to  choose between  per- formance  and  deterministic  semantics.
Parallel  applications. Sometimes the amount of data crossing the database/application interface can overwhelm  the  improvements  due to parallelism (explained by Amdahl’s Law). We are  studying ways  to  improve  the  performance of such appli- cations by:
Providing for parallel application support  (pro- gramming model, SQL language extensions,  and DBMS extensions required to  transfer  data in par- allel) Examining means for pushing down some of the application logic into  the  database.  This could involve object-oriented  extensions  such as user- defined functions and extending SQL to  under- stand  statistical  issues  such as correlation  and sampling.
Summary  and  future. In summary,  our parallel da- tabase implementation on an open platform has been a successful one, especially for complex query  environments.  We  have  shown  that  a seal- able shared-nothing  database  system  can  be built by extending  a  serial  database  system with soft- ware  that glues nodes  together in order  to provide a single system image to  the  user.  The  key com- ponents of this software-query optimization and processing, run-time system and database utili- ties-have been  described in this  paper. We have also  shown  that  such  a  system  can handle decision support  applications on hundreds or thousands of gigabytes (thus  extending  them  beyond  the  reach of shared-memory  architectures).
In the  future we will be enhancing it to incorpo- rate  better technology, newer applications and  par- adigms (e.g., parallel applications); exploit fully other  hardware  platforms (e.g., SMPS); and ensure our  technology is best-of-breed in business-criti- cal environments.
Acknowledgments The  seeds for DB2 PE were  sown  at  the IBM T. J.
Watson Research Center, starting in 1989. We started  prototyping  work with IBM Austin,  and  our initial technology achievements were showcased BARU ET AL. 319

---

in the Fall Comdex 1990 industry  computer show.
For this  demonstration, a small number of local area  network- (LAN) connected PS/~* processors were used. Although much of the underlying run- time infrastructure had been  prototyped by then, the parallel query plans were hand-generated. The initial architecture design was led by Ambuj Goyal and Francis Parr from Research, and George Copeland from IBM Austin, with help from the IBM Almaden Research Center. Joint work  started with IBM’s Software  Solutions Division (then Program- ming Systems) in Toronto  when  the  latter got the DB2 clientherver mission in late 1992. A full de- velopment  team  under  Harry Chow was  put in place  starting mid-1993, when it became  clear  that the  market  was ripe for an  open massively parallel processing- (MPP) based  database  system.
This  product would not be possible without  the hard work  and  contributions of the  Toronto and Hawthorne development teams. Several of the  ar- chitectural  issues discussed in this paper  were  de- veloped by people on  these teams. In addition to the  core development team, a successful product involves testing, benchmarking, marketing and sales.  The  authors acknowledge the  contributions of the performance benchmarking teams from IBM Toronto and IBM Kingston (POWER Parallel Divi- sion)-several of their results  are  presented here.
In addition, initial versions of DB2 Parallel Edition have had success in the field, mainly because of the  tremendous  job  done by a number of D B ~ PE specialists, some from marketing and sales, and others from consultancy organizations like the IBM Issc. We have freely borrowed from their benchmark results and thank all the people in- volved.
*Trademark or registered trademark of International Business Machines Corporation.
Cited  references  and  note
1. D. DeWitt et al., “The Gamma Database Machine Proj- 
ect,”  IEEE Transactions on Knowledge and  Data Engi- neering 2, No. 1, 44-62 (March  1990).
2. H. Boral et al., “Prototyping Bubba: AHighly Parallel Da- 
tabase System,” IEEE Transactions on Knowledge and Data Engineering 2, No. 1, 4-24 (March 1990).
3.  W. Hong and M. Stonebraker, “Optimization of Parallel 
Query Execution Plans in  XPRS,” Proceedings of the 1st International Conference on Parallel  and Distributed In- formation Systems (PDIS) (1991), pp. 218-225.
4. C. Baru and S. Padmanabhan, “Join and Data Redistribu- 
tion Algorithms for Hypercubes,” IEEE Transactions on Knowledge and  Data Engineering 5, No. 1,161-168 (Feb- ruary 1993).
320 BARU ET AL.
5. M. Kitsuregawa and Y. Ogawa, “Bucket Spreading Par- 
allel Hash: A New, Robust, Parallel Hash-Join Method for Data Skew in the Super Database Computer (SDC),”Pro- ceedings of the 16th International Conference on Very Large  Data Bases, Brisbane, Australia, Morgan Kaufman, Palo Alto, CA (August 1990),  pp.  210-221.
6.  M. Lakshmi and P. Yu, “Effectiveness of Parallel Joins,” 
IEEE Transactions on Knowledge and  Data Engineering 2, No. 4,  41&424 (December 1990).
7.  D. Schneider  and D. DeWitt, “A Performance  Evaluation of 
Four Parallel  Join  Algorithms  in  a  Shared-Nothing  Multipro- cessor Environment,” Proceedings of the ACM SIGMOD Conference,  Portland,  Oregon  (May  1989),  pp. 110-121.
8. S. Khoshafian and  P. Valduriez, “Parallel Execution Strat- 
egies for Declustered Databases,” DatabaseMachines and Knowledge Base Machines, M. Kitsuregawa and H. Ta- naka, Editors, Kluwer Acad. Publishers, Boston, MA (1988), pp.  458-471.
9. D. Schneider and D. DeWitt, “Tradeoffs in Processing 
Complex Join Queries via Hashing in Multiprocessor Da- tabase Machines,” Proceedings of the 16th International Conference on Vey  Large  Data Bases, Brisbane, Austra- lia,  Morgan Kaufman (August 1990), pp. 469481.
10.  G. Copeland et al., “Data Placement in Bubba,”Proceed- 
ings of the 1988 ACM SIGMOD Conference, Chicago, IL (June 1988), pp. 99-108.
11. S. Ghandeharizadeh and D. Dewitt, “Performance Anal- 
ysis of Alternative Declustering Strategies,”Proceedings of 6th International Conference on Data Engineering, Los Angeles, CA (Feb. 1990),  pp.  466-475.
12. K. A. Hua and C. Lee, “An Adaptive Data Placement 
Scheme for Parallel Database Computer Systems,” Pro- ceedings of the 16th International Conference on Very Large  Data Bases, Brisbane, Australia, Morgan Kaufman (August 1990), pp. 493-506.
13. S. Padmanabhan, Data Placementin  Shared-NothingPar- 
allelDatabase Systems, Ph.D. thesis, EECS Department, University of Michigan, Ann Arbor, MI  48109-2122  (1992).
14.  D. DeWitt, S. Ghandeharizadeh, and D. Schneider, “APer- 
formance Analysis of the Gamma Database Machine”Pr0- ceedings of the 1988ACMSIGMOD Conference,  Chicago, IL (June 1988), pp. 350-360.
15.  D. DeWitt, M. Smith, and H. Boral, “A Single-User Per- 
formance Evaluation of the Teradata Database Machine,” Proceedings of the 2nd International Workshop on High Performance Transaction Systems (Lecture Notes in  Com- puterscience, No. 3591, Pacific Grove, CA, Springer-Ver- lag (September 1987),  pp. 244-269.
16. The Tandem Performance Group, “A Benchmark of Non- 
Stop SQL on the Debit Credit Transaction,”Proceedings of the ACM SIGMOD Conference, Chicago, IL (June 1988),  pp. 337-341.
17.  T. Haerder and A. Reuter, “Principles of Transaction-Ori- 
ented Database Recovery,”ACM Computing Surveys 15, No. 4, 287-317 (1983).
18. The Tandem Database Group, “Nonstop SQL A Distrib- 
uted, High-Performance,  High-Availability  Implementation of SQL,” Proceedings of the 2nd International Workshop on High Performance Transaction Systems (Lecture Notes in Computerscience, No. 359),  Pacific Grove, CA, Spring- er-Verlag (September 1987),  pp.  60-104.
19. DBCll012 Data Base Computer Concepts and Facilities, 
cO2-0001-05 Edition, Teradata Cop, CA (1988).
20. M. Stonebraker, “The Case for Shared Nothing,” Data- 
base Engineering 9, No. l (March 1986).
IBM SYSTEMS JOURNAL, VOL 34, NO 2, 1995

---

21.  A. Bhide  and M. Stonebraker, “A Performance Compar- 
ison of Two Architectures for Fast Transaction Process- ing,” Proceedings of the 1988lnternational Conference on Data Engineering, Los Angeles,  CA (February 1988),  pp.
536-545.
22. C. Mohan, H. Pirahesh, W. Tang, and Y. Wang, “Paral- 
lelism  in  Relational Database Management Systems,”lBM Systems Journal 33, No. 2,  349-371 (1994).
23.  D. DeWitt  and J. Gray, “Parallel Database Systems: The 
Future of High Performance Database Systems,” Commu- nications ofthe  ACM 35, No. 6,  85-98 (June 1992).
24.  D. Davis, “ORACLE’S Parallel Punch for OLTP,” Data- 
mation 38, No. 16, 67-71 (August 1992).
25. E. Ozkarahan and M. Ouksel, “Dynamic and Order Pre- 
serving Data Partitioning for Database Machines,” Pro- ceedings of the 1985 Very Large  Data Bases  International Conference  (1985),  pp. 358-368.
26. S. Ghandeharizadeh and D. J. DeWitt,  “Magic: A Multi- 
attribute Declustering Mechanism for Multiprocessor Da- tabase Machines,”lEEE Transactions on Paralleland Dis- tributed Systems 5, No. 5, 509-524 (May  1994).
27. C. Mohan  and  B. Lindsay, “Efficient  Commit Protocols 
for the Tree of Processes Model of Distributed Transac- tions,”Proceedings of the 2ndAnnual Symposium on Prin- ciples of Distributed Computing, ACM (August 1993),  pp.
76-88.
28.  P. Selinger et al., “Access Path Selection in a Relational 
Database Management System,” Proceedings of the 1979 ACM SIGMOD Conference  (1979),  pp. 23-34.
29. S. Ganguly,  W. Hasan, and  R. Krishnamurthy, “QueryOp- 
timization for Parallel Execution,”Proceedings of the 1992 ACM SIGMOD Conference  (May 1992), pp. 9-18.
30.  D. Skeen, “Non-Blocking Commit Protoco1,”Proceedings 
of the 1981 ACM SIGMOD Conference, Orlando, FL (i981), pp. 133-142.
31. G. Lohman. C.  Mohan.  L. Haas. D.  Daniels.  B. Lindsav, 
~~ P. Selinger,’ and P. Wilms, “Query Processing in R*:’ Query Processing in Database Systems, W. Kim, D. Reiner, and D. Batory, Editors, Springer-Verlag, Inc., New York (1985),  pp. 31-48.
32. AIXHighAvailability ClusterMulti-Processing/6000, 
Con- cepts and Facilities, SC23-2699,  IBM Corporation; avail- able through IBM branch offices.
33. SP2performance measurement data are available from the 
IBM POWERParallel Division,  P.O.  Box 100, Somers, NY
10589. 
Accepted for publication January 11,  1995.
Chaltanya K. Baru IBM Toronto Laboratory, 1150 Eglinton Ave. East, North York, Ontario, M3C lH7 Canada. Dr. Baru is currently an advisory development analyst in the Database Technology division at the IBM Toronto laboratory, and one of the team leaders in the DB2 Parallel Edition (DB2 PE) proj- ect.  He joined IBM Canada in  1992. He has been involved in the design  and development of the data manager extensions and some of the database utilities for DB2 PE. Prior to joining IBM,  he was Assistant Professor of Computer Science and En- gineering in the Electrical Engineering and Computer Science Department at the University of Michigan,  Ann Arbor, Mich- igan. He has published several papers related to parallel da- tabase systems in technical conferences and journals. Dr. Baru is a senior member of the IEEE and a member of the Computer and Information Sciences Grants Selection Committee of the Natural Sciences and Engineering Research Council (NSERC) of Canada. He received his B. Tech. degree from the Indian Institute of Technology, Madras, India in  1979, and  M.E.  and Ph.D. degrees in electrical engineering from the University of Florida, Gainesville, in 1983 and 1985, respectively.
Gilles Fecteau ZBM Toronto Laboratory, 1150 Eglinton Ave.
East, North York, Ontario, M3C lH7 Canada. Mr. Fecteau has been in information technology for 25 years,  as an IBM Canada employee. His experience includes application pro- gramming, systems programming, capacity planning, database design, operating systems, and database management systems design  and implementation. His primary technical focus for the past nine years has been IBM’s relational database systems de- sign, where he has focused on performance and manageability enhancements. He holds the degree of Bachelor of Engineer- ing Science (applied physic) from Lava1 University in Quebec city, Canada. Since 1990  Mr. Fecteau has been involved  in sev- eral advanced technology efforts in  IBM to bring to market a parallel database. In 1991  he joined the workstation database group in Toronto  as a lead designer on the implementation of a parallel version of the DB2 workstation database products (DB2/2  and DB216000).
Ambuj Goyal IBM Research Division, Thomas J. Watson Research Center, P. 0. Box 704,  Yorktown Heights, New York 10598 (electronic mail: ambuj@watson.ibm.com). Dr. Goyal joined IBM as a research staff member at the Thomas J. Wat- son Research Center in Yorktown Heights, New York, in  May 1982 and assumed a first-line  management  position in July 1988.
He became the senior manager of the Parallel and Fault-Tol- erant Computinggroup in October 1990, and thenwas promoted to his present position of Director, Servers and Parallel Sys- tems.  All of Dr. Goyal’s assignments have been with the IBM Research Division at the Yorktown Heights, New York, lo- cation. He received the B. Tech. degree from the Indian In- stitute of Technology, Kanpur, in  1978,  and the M.S. and  Ph.D.
degrees from The University of Texas at Austin, in  1979 and 1982, respectively. As director, he is responsible for setting Re- search Division strategy in servers and  parallel systems, includ- ing establishing a technical program in this area that is vital to IBM’s success and  is known for its technical innovations.
HUM HslaoIBM Research Division, Thomas J. Watson Research Center, P. 0.
Box 704,  Yorktown Heights, New York 10598 (electronic mail: hhsiao@watson.ibm.com). Dr. Hsiao has been a research staff member at the IBM Thomas J. Wat- son Reseach Center since 1990. Currently, he is a member of the parallel database project, working on the research and de- velopment of IBM’s  first  highly parallel database system. His research interests include parallel database architecture, par- allel query and transaction processing strategies, and database performance  analysis. Prior to joining  IBM,  he worked as a soft- ware engineer at Nicolet Instrument Corporation, where he re- ceived a Nicolet Associate Fellow Award. He was a member of the Gamma database machine project at the University of Wisconsin.  Dr. Hsiao received a B.S. degree from National Taiwan University, and  M.S.  and  Ph.D. degrees in computer science from the University of Wisconsin at Madison.
Anant  Jhlngran IBM Research Division, Thomas J. Watson Research Center, P. 0. Box 704,  Yorktown Heights, New York 10598 (electronic mail: anant@watson. ibm.  com) . Dr. Jhingran IBM SYSTEMS JOURNAL,  VOL 34, NO 2, 1995

---

is  currently  the manager of information systems  at  the IBM Thomas  J.  Watson Research Center.  His  group  is engaged in several  areas of database  research, including parallelism, avail- ability,  transaction  processing, data mining, and  warehousing.
Over  the last several  years, he has  been  workingwith  IBMTor- onto  on all aspects of DB2  Parallel  Edition. Dr. Jhingran has contributed significantly to  various  components of DB2 Par- allel Edition, including query optimization and processing,  run- time subsystem, data partitioning, and reliability and availablity.
He  has filed several invention disclosures  and  patents in sev- eral  areas of parallel database  systems,  and  has actively  pub- lished in leading conferences like ACM  SIGMOD, VLDB,  and Data Engineering. He has  also  served  on  the program  commit- tee of SIGMOD. He received  his Ph.D. and M.S. degrees in computer  science from the  University of California, Berkeley, in 1990 and 1987 respectively, and his  bachelor’s  degree in elec- trical engineering from the Indian Institute of Technology, Delhi, India, in 1985.
Sriram Padmanabhan IBM Research Division, Thomas J. Watson Research Center, P. 0.
Box  704, Yorktown Heights, New York 10598 (electronic mail: srp@watson.ibm.comj. Dr.
Padmanabhan  is a research staff member at  the IBM Thomas J. Watson  Research  Center,  Hawthorne,  New  York, which he joined in 1992. He is an  active  member of the  DB2  Parallel Edi- tion research  and development effort and  has  contributed  to several  architectural  aspects of the  system  and significantly to the  query optimization  and  parallel query  execution  areas.
Be- sides parallel databases, he is  interested in object-oriented  and distributed databases, information retrieval,  massive  data-stor- age  applications,  and parallel architectures  and algorithms.  Dr.
Padamanabhan received  his Ph.D. and M.S. degrees in com- puter  science from the  University of Michigan, Ann Arbor, in 1992 and 1990, respectively, and his B. Tech.  degree  from the Indian Institute of Technology,  Madras,  India in 1986.
George P. Copeland IBM Corporation, Personal Sojiware Products Division, 11400 Burnet Road, Austin, Texas 78758 (electronic mail: copeland@austin.ibm.com). Dr. Copeland is currently a Senior Technical Staff Member at IBM  Austin. He received his B.S. degree from Christian Brothers College, Mem- phis, in 1969, and his M.E. and Ph.D. degrees from  the  Uni- versity of Florida, Gainesville, in 1970 and 1974, respectively.
He  has  worked for NASA, the Bank of America, and Tektronix, and  was chief architect and  a founder of Servio  Corporation, an object-oriented database (OODB) vendor. At MCC, he served  as chief architect of the  Bubba parallel  OODB  project.
He joined  IBM in 1989 as chief architect of the OSi2 Database Manager, helping initiate and  contribute  to  projects  to  make it portable and parallel. He has  also  contributed  to  the IBM microkernel and file systems.  His major area of interest  is ap- plying to objects the same kinds of systems services that database  systems  apply  to  data,  such  as  persistence,  concur- rency,  recovery, transactions, distribution, security,  etc.  He is a  member of IEEE and  ACM, and  has  served  on  numerous conference program committees  and panels.
Walter G. Wilson Red Brick Systems, 485 Albert0 Way, Los Gatos, California  95032 (electronic mail: walter@redbrick com) .
Dr. Wilson is currently  Director, Parallel Systems, at Red Brick Systems. He received  his B.S. in mathematics  from Stanford University,  and his M.S. and Ph.D. in computer  science from Syracuse University.  Previous  experience  includes that of proj- 322 BARU ET AL.
ect  leader for the parallel database project at IBM’s Thomas J. Watson Research Center, manager of systems  ad- vanced technology at IBM’s Enterprise  Systems division, and manager of the Symbolic Programming department at the Thomas  J.  Watson  Research Center.
Reprint Order No. G321-5570.
IBM SYSTEMS JOURNAL, VOL 34, NO 2, 1995

---

