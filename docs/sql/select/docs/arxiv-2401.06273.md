# Qrlew: Rewriting SQL into Differentially Private SQL

> 来源: https://arxiv.org/pdf/2401.06273

Qrlew: Rewriting SQL into Differentially Private SQL
Nicolas Grislain
ng@sarus.tech
Paul Roussel
pr@sarus.tech
Victoria de Sainte Agathe
vdsa@sarus.tech
Tuesday 21st November, 2023
Abstract
This paper introduces Qrlew, an open source library that can parse SQL queries into
Relations — an intermediate representation — that keeps track of rich data types, value
ranges, and row ownership; so that they can easily be rewritten into differentially-private
equivalent and turned back into SQL queries for execution in a variety of standard data
stores.
With Qrlew, a data practitioner can express their data queries in standard SQL; the data
owner can run the rewritten query without any technical integration and with strong privacy
guarantees on the output; and the query rewriting can be operated by a privacy-expert who
must be trusted by the owner, but may belong to a separate organization.
1
Introduction
In recent years, the importance of safeguarding privacy when dealing with personal data has
continuously increased.
Traditional anonymization techniques have proven vulnerable to re-
identification, as demonstrated by numerous works [AGKZ18, DSSU17, NS08, SAW13]. The total
cost of data breaches has also significantly increased [IBM23] and governments have introduced
stricter data protection laws.
Yet, the collection, sharing, and utilization of data holds the
potential to generate significant value across various industries, including healthcare, finance,
transportation, and energy distribution.
To realize these benefits while managing privacy risks, researchers have turned to differential
privacy (DP) [WAB+18, DR+14], which has become the gold standard for privacy protection
since its introduction by Dwork et al. in 2006 [DMNS06] due to its provable and automatic
privacy guarantees.
Despite the availability of powerful open-source tools [KTH+19, HBMAL19, The23, Goo22,
Ope23, Goo23b, JNHS20, BBD+22, YSS+21], DP adoption remained limited and many organi-
zations sticked to more manual and ad-hoc approaches. Reasons for this lack of adoption are
probably complex and multiple but one could name: the lack of awareness on privacy risks; the
loss of utility in the results; and the perceived complexity of the existing solutions considering
they all require, either some expertise in differential privacy, or the use of new interfaces to ex-
press data processing tasks, or even to integrate new execution engines in their data stack. Qrlew
[GdSACS23] has been designed to relieve these problems by providing the following features:
Qrlew provides automatic output privacy guarantees With Qrlew a data owner can let
an analyst (data practitioner) with no expertise in privacy protection run arbitrary SQL
queries with strong privacy garantees on the output.
1
arXiv:2401.06273v1  [cs.DB]  11 Jan 2024

---

Qrlew leverages existing infrastructures Qrlew rewrites a SQL query into a differentially
private SQL query that can be run on any data-store with a SQL interface: from lightweight
DB to big-data stores. This removes the need for a custom execution engine and enables
differentially private analytics with virtually no technical integration.
Qrlew leverages synthetic data Synthetic data are an increasingly popular way of privatiz-
ing a dataset [BS19, MMS21, CGLL22, SWK23, CGBR23]. Using jointly: differentially
private mechanisms and differentially private synthetic data can be a simple, yet powerful,
way of managing a privacy budget and reaching better utility-privacy tradeoffs.
2
Definitions
Datasets and Privacy Units (PU)
In this paper, datasets refer to a collection of elements in some domain X, labelled with an
identifier i ∈I identifying the entity whose privacy we want to protect. This entity will be called
Privacy Unit (PU) and the identifier will be referred to as Privacy ID (PID). Let D be the set
of datasets of arbitrary sizes with a privacy unit.
Differential Privacy (DP)
Let M be an algorithm that takes a dataset as input and produces a randomized output. The
algorithm M is said to satisfy ε, δ-differential privacy if, for all pairs of adjacent datasets D, D′ ∈
D, and for all measurable sets S in the range of M:
Pr[M(D) ∈S] ≤eε · Pr[M(D′) ∈S] + δ
Adjacent datasets
Datasets D, D′ ∈D are adjacent if they are equal up to the addition or removal of all entries
sharing the same PID. Note that this is a slightly unusual and restricted definition of adjacency,
suited to our practical needs. It is close to that used in the user-level differential privacy literature
[LSY+20, WZL+19] where one user can have many samples.
3
Assumptions and Design Goals
In this work, we assume the central model of differential privacy [Nea20], where a trusted central
organization: hospital, insurance company, utility provider, called the data owner, collects and
stores personal data in a secure database and whishes to let untrusted data practitioners run
SQL queries on its data.
At a high level we pursued the following requirements:
• Ease of use for the data practitioners. The data practitioners are assumed to be a data
experts but no privacy experts. They should be able to express their queries in a standard
way. We chose SQL as the query language as it is very commonly used for analytics tasks.
• Ease of integration for the data owner. As SQL is a common language to express data
analysis tasks, many data-stores support it from small embedded databases to big data
stores.
2

---

Data Owner
Data 
Practitioner
Qrlew - Query Rewriter
SQL Query
SQL Query
Unsafe 
Result
DP Result
DB
DB
Relation
Rewritten 
Relation
Rewritten 
SQL Query
The Data Practitioner can send 
exactly the same query to the Query 
Rewriter as in the unsafe scenario
The Data Owner cannot safely 
let anyone run queries on its 
privacy sensitive Database
The Data Owner can safely 
accept rewritten queries without 
changing its DB
The Query Rewriter may be 
operated by the Data Owner or 
simply act as a trusted 
third-party producing digitally 
signed rewritten queries 
The Data Practitioner wants to run a query on the DB
Figure 1: The rewriting process occurs in three stages: The data practitioner’s query is parsed
into a Relation, which is rewritten into a DP equivalent and finally executed by the the data
owner which returns the privacy-safe result.
• Simplicity for the data owner to setup privacy protection. Differential privacy is about
capping the sensitivity of a result to the addition or removal of an individual that we call
privacy unit. Qrlew assumes that the data owner can tell if a table is public and, if it
is not, that it can assign exactly one privacy unit to each row of data. In the case there
are multiple related tables, Qrlew enables to define easily the privacy units for each tables
transitively.
• Simple integration with other privacy enhancing technologies such as synthetic data. To
avoid repeated privacy losses or give result when a DP rewriting is not easily available (e.g.
when the query is: SELECT * FROM table) Qrlew can use synthetic data to blend in the
computation.
These requirements dictated the overall query rewriting architecture and many features, the
most important of which, are detailed below.
4
Architecture and main features of Qrlew
The Qrlew library, solves the problem of running a SQL query with DP guarantees in three steps.
First the SQL query submitted by the data practitioner is parsed and converted into a Relation,
this Relation is an intermediate representation that is designed to ease the tracking of data types
ranges or possible values, to ease the tracking of the privacy unit and to ease the rewriting into a
DP Relation. Then, the rewriting into DP happens. Once the relation is rewritten into a DP one,
it can be rendered as an SQL query string and submitted to the data store of the data owner.
The output can then safely be shared with the data practitioner. This process is illustrated in
figure 1.
3

---

MAP_QF6V size ∈ int[0 10]
a = field_e5_0 ∈ float{1, 2, 3} UNIQUE
x = field_pqi2 ∈ int[0 10]
REDUCE_M5QO size ∈ int[0 10]
field_pqi2 = count(field_nfbh) ∈ int[0 10]
field_e5_0 = first(field_s7n2) ∈ float{1, 2, 3} UNIQUE
GROUP BY (field_s7n2)
MAP_AWW3 size ∈ int[0 10]
field_nfbh = abs(((10 * a) + b)) ∈ float[9.9 11]∪[19.9 21]∪[29.9 31]
field_s7n2 = a ∈ float{1, 2, 3}
WHERE ((b > (- 0.1)) and (a in (1, 2, 3)))
TABLE_1 size ∈ int{10}
a = a ∈ float[0 10]
b = b ∈ option(float[-1 1])
c = c ∈ date[1980-12-06 2023-12-06]
d = d ∈ int[0 10]
This Relation is a Map, it 
takes a Reduce as input 
and renames its fields
This Reduce aggregates 
fields from its input
This Map 
transforms the 
rows of the input 
Table one by one
This Relation is the source 
Table as defined in the 
underlying database, with some 
metadata to refine value ranges
Figure 2: Relation (Map) associated to the query: SELECT a, count(abs(10*a+b)) AS x FROM
table 1 WHERE b>-0.1 AND a IN (1,2,3) GROUP BY a.
The arrows point to the inputs of
each Relation. Note the propagation of the data type ranges.
4.1
Qrlew Intermediate Representation
As the SQL language is very rich and complex, simply parsing a query into an abstract syntax
tree does not produce a convenient representation for our needs.
Therefore, it is converted
into a simpler normalized representation with properties well aligned with the requirements of
Differential Privacy: the Relation. A Relation is a collection of rows adhering to a given schema.
It is a recursively defined structure composed of:
Tables This is simply a data source from a database.
Maps A Map takes an input Relation, filters the rows and transform them one by one. The
filtering conditions and row transforms are expressed with expressions similar to those
of SQL. It acts as a SELECT exprs FROM input WHERE expr LIMIT value and therefore
preserve the privacy unit ownership structure.
Reduces A Reduce takes an input Relation and aggregates some columns, possibly group by
group. It acts as a SELECT aggregates FROM input GROUP BY expr. This is where the
rewriting into DP will happen as described in section 4.4.
Joins This Relation combines two input Relations as a SELECT * FROM left JOIN right ON
expr would do it. The privacy properties are more complex to propagate in this case.
It may also be a static list of values or a set operation between two Relations, but those are less
important for our uses.
4

---

This representation is central to Qrlew; all the features described below are built upon it. A
Relation, along with all the sub-Relations it depends on, will be called the computation graph or
the graph of a Relation.
4.2
Range Propagation
Most DP mechanisms aggregating numbers require the knowledge of some bounds on the values
(see [DR+14]). Even if some bounds are known for some Relations like source Tables, it is not
trivial to propagate these bounds through the steps of the computation.
To help with range propagation, Qrlew introduces two useful concepts:
• The concept of k-Interval, which are finite unions of at most k closed intervals. A k-Interval
can be noted:
I =
j≤k
[
i=1
[ai, bi]
Note that the union of k-Intervals may not be a k-Interval as it may be the union of more
than k intervals. Unions of many intervals can be simplified into their convex envelope
interval, which are often sufficient bounds approximations for our use cases:
J =
j>k
[
i=1
[ai, bi] ⊆
h
min
i
ai, max
i
bi
i
• And the concept of piecewise-monotonic-functions1, which are functions f : Rn →R
whose domain can be partitioned in cartesian products of intervals: Pj on which they
are coordinatewise-monotonic.
The image of a cartesian product of n k-Intervals by a
piecewise-monotonic-function can be easily computed as a k-Interval. Indeed, let I be:
I = I1 × I2 × . . . × In =
[
1≤i1≤k
...
1≤in≤k
[ai1, bi1] × . . . × [ain, bin]
If f is piecewise-monotonic, then one can show that on each partition Pj where it is
coordinatewise-monotonic, if we note:
Ij = I ∩Pj =
[
1≤j1≤k
...
1≤jn≤k
[aj1, bj1] × . . . × [ajn, bjn]
f(Ij) =
[
1≤i1≤k
...
1≤in≤k
Conv (f ({ai1, bi1} × . . . × {ain, bin}))
where Conv (f ({ai1, bi1} × . . . × {ain, bin})) can be efficiently computed in n steps, without
testing all the 2n combinations, thanks to the coordinatewise monotony of f on Pj. Then
f(I) = S
j f(Ij), of which we can derive the bounding: f(I) ⊆Conv
S
j f(Ij)

when the
number of terms in the union exceeds k.
The notion of k-Interval is convenient for tracking value bounds as it can express natural
patterns in SQL such as:
1Which is a shorthand name for what would be better called: piecewise-coordinatewise-monotonic-functions
5

---

Listing 1: Example of privacy unit definition for a database with three tables holding users,
orders and items records. Each user is protected individually by designating their ids as PID.
Orders are attached to a user through the foreign key: user id. Items’s ownership is defined the
same way by specifying the lineage: item -> order -> user.
1
privacy_unit = [
2
("users" ,[],"id"),
3
("orders" ,[
4
("user_id","users","id")
5
],"id"),
6
("items" ,[
7
("order_id","orders","id"),
8
("user_id", "users", "id")
9
],"id")
10
]
• WHERE x>0 AND x<=1, which translates into the implied x ∈[0, 1] ;
• WHERE x IN (1,2,3), which is also easily expressed as a k-Interval: x ∈[1, 1]∪[2, 2]∪[3, 3]
The idea of piecewise-monotonic-function is also very useful as in SQL many standard arith-
metic operators (+, -, *, /, <, >, =, !=, . . . ) and functions (EXP, LOG, ABS, SIN, COS, LEAST,
GREATEST, . . . ) are trivially piecewise-monotonic-function (in one, two or many variables).
Most of the range propagation in Qrlew is based on these concepts. It enables a rather simple
and efficient range propagation mechanism, leading to better utility / privacy tradeoffs.
4.3
Privacy Unit Definition
Tables in a database rarely come properly formatted for privacy-preserving applications. Many
rows in many tables may refer to the same individual, hence, adding or removing an individual
means adding or removing many rows. To help the definition of the privacy unit Qrlew introduces
a small Privacy Unit (PU) description language.
As exemplified in listing 1, PU definition
associates to each private table in a database a path defining the PID of each row.
For a
table containing the PU itself, like a users table for example, the PU definition will look like
("users",[],"id"), where id is the name of a column identifying the user, like its name. If the
database defines tables related to this tables, the way the tables are related should be specified
following this scheme: (tab1, path, pid) where tab1 is the name of the table for which the PID is
defined, pid is the name of the column defining the PID in the table referred by path and path
is a list of elements of the form [(ref1, tab2, id2), . . . , (refm−1, tabm, idm)] where refi−1 is a
column in tabi−1 — usually a foreign key — referring to tabi with a column of referred id idi
— usually a primary key. Following the path of tables referring to one another, we end up with
the table defining the PID (e.g. users).
This small PU description language allows for a variety of useful PID scenarii, beyond the
simple, but restrictive privacy per row.
4.4
Rewriting
Rewriting in Qrlew, refers to the process of altering the computation graph by substituting
computation sub-graphs to Relations (see figure 3) to alter the properties of the result. This sub-
stitution aims to achieve specific objectives, such as ensuring privacy through the incorporation
of differentially private mechanisms. The rewriting process (see figure 3) happens in two phases:
6

---

MAP_94NB size ∈ int[0 300]
order_id = field_z039 ∈ float{1, 2, 3, 4, 5, 6, 7, 8, 9, 10} UNIQUE
sum_price = field_1by4 ∈ float[0 15000]
count_price = field_lr4c ∈int[0 300]
mean_price = field_wm9y ∈ float[0 50]
REDUCE_X2CQ size ∈ int[0 300]
field_1by4 = sum(field_z650) ∈ float[0 15000]
field_z039 = first(field_08wv) ∈ float{1, 2, 3, 4, 5, 6, 7, 8, 9, 10} UNIQUE
field_lr4c = count(field_z650) ∈ int[0 300]
field_wm9y = mean(field_z650) ∈ float[0 50]
GROUP BY (field_08wv)
MAP_OQR1 size ∈ int[0 300]
field_z650 = price ∈ float[0 50]
field_08wv = order_id ∈ float{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
WHERE (order_id in (1, 2, 3, 4, 5, 6, 7, 8, 9, 10))
ITEMS size ∈ int{300}
order_id = order_id ∈ int[0 100]
item = item ∈ str
price = price ∈ float[0 50]
MAP_94NB
order_id, sum_price, count_price, mean_price
Rewriting Rules are 
assigned 
depending on the 
Rewriting Rules of 
the inputs 
DP
→
Pubd
REDUCE_X2CQ
field_1by4, field_z039, field_lr4c, field_wm9y
PUP
→
DP
MAP_OQR1
field_z650, field_08wv
PUP
→
PUP
ITEMS
order_id, item, price
PUP
MAP_94NB size ∈ int[0 60000000]
order_id = field_z039 ∈ float{1, 2, 3, 4, 5, 6, 7, 8, 9, 10} UNIQUE
sum_price = field_1by4 ∈ float[0 3000000000]
count_price = field_lr4c ∈ float[0 60000000]
mean_price = field_wm9y ∈ float[0 3000000000]
MAP_CWT3 size ∈ int[0 60000000]
field_1by4 = _SUM_field_z650 ∈ float[0 3000000000]
field_z039 = field_08wv ∈ float{1, 2, 3, 4, 5, 6, 7, 8, 9, 10} UNIQUE
field_lr4c = _COUNT_field_z650 ∈ float[0 60000000]
field_wm9y = (_SUM_field_z650 / greatest(1, _COUNT_field_z650)) ∈ float[0 3000000000]
MAP_9QFF size ∈ int[0 60000000]
field_08wv = field_08wv ∈ float{1, 2, 3, 4, 5, 6, 7, 8, 9, 10} UNIQUE
_COUNT_field_z650 = least(60000000, greatest(0, (coalesce(_ONE_, 0) + (16.50909392199704 * (sqrt((-2 * ln(random()))) * cos((...
_SUM_field_z650 = least(3000000000, greatest(0, (coalesce(field_z650, 0) + (825.454696099852 * (sqrt((-2 * ln(random()))) * c...
REDUCE_O4XR size ∈ int[0 60000000]
field_08wv = first(field_z039) ∈ float{1, 2, 3, 4, 5, 6, 7, 8, 9, 10} UNIQUE
_ONE_ = sum(field_dpi3) ∈ float[0 60000000]
field_z650 = sum(field_orpo) ∈ option(float[0 3000000000])
GROUP BY (field_z039)
MAP_B7WH size ∈ int[0 60000000]
field_dpi3 = _ONE_ ∈ float[0.000000000002151657414559676 1]
field_z039 = field_08wv ∈ float{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
field_orpo = field_z650 ∈ option(float[0 50])
MAP_QW8M size ∈ int[0 60000000]
_PRIVACY_UNIT_ = _PRIVACY_UNIT_ ∈ str
_PRIVACY_UNIT_WEIGHT_ = _PRIVACY_UNIT_WEIGHT_ ∈ float{0, 1}
field_08wv = field_08wv ∈ float{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
field_z650 = (field_z650 * _SCALE_FACTOR_field_z650) ∈ option(float[0 50])
_ONE_ = (_ONE_ * _SCALE_FACTOR__ONE_) ∈ float[0.000000000002151657414559676 1]
_SCALE_FACTOR__PRIVACY_UNIT_ = _SCALE_FACTOR__PRIVACY_UNIT_ ∈ str
_SCALE_FACTOR__ONE_ = _SCALE_FACTOR__ONE_ ∈ float[0.000000000002151657414559676 1]
_SCALE_FACTOR_field_z650 = _SCALE_FACTOR_field_z650 ∈ option(float[0.000000000002151657414559676 1])
JOIN_2U_X size ∈ int[0 60000000]
_PRIVACY_UNIT_ = _LEFT_._PRIVACY_UNIT_ ∈ str
_PRIVACY_UNIT_WEIGHT_ = _LEFT_._PRIVACY_UNIT_WEIGHT_ ∈ float{0, 1}
field_08wv = _LEFT_.field_08wv ∈ float{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
field_z650 = _LEFT_.field_z650 ∈ option(float[0 50])
_ONE_ = _LEFT_._ONE_ ∈ float{1}
_SCALE_FACTOR__PRIVACY_UNIT_ = _RIGHT_._PRIVACY_UNIT_ ∈ str
_SCALE_FACTOR__ONE_ = _RIGHT_._ONE_ ∈ float[0.000000000002151657414559676 1]
_SCALE_FACTOR_field_z650 = _RIGHT_.field_z650 ∈ option(float[0.000000000002151657414559676 1])
INNER ON (_LEFT_._PRIVACY_UNIT_ = _RIGHT_._PRIVACY_UNIT_)
MAP_VT4H size ∈ int[0 60000000]
_PRIVACY_UNIT_ = _PRIVACY_UNIT_ ∈ str UNIQUE
_ONE_ = (1 / greatest(1, (sqrt(_ONE_) / 1))) ∈ float[0.000000000002151657414559676 1]
field_z650 = (1 / greatest(1, (sqrt(field_z650) / 50))) ∈ option(float[0.000000000002151657414559676 1])
MAP_AYHD size ∈ int[0 60000000]
_PRIVACY_UNIT_ = coalesce(cast_as_text(_PRIVACY_UNIT_), _PRIVACY_UNIT_NULL_) ∈ str
_PRIVACY_UNIT_WEIGHT_ = coalesce(_PRIVACY_UNIT_WEIGHT_, 0) ∈ float{0, 1}
field_08wv = field_08wv ∈ float{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
field_z650 = field_z650 ∈ option(float[0 50])
_ONE_ = 1 ∈ float{1}
REDUCE_M0RO size ∈ int[0 60000000]
_PRIVACY_UNIT_ = first(field_6zur) ∈ str UNIQUE
_ONE_ = sum(field_dpi3) ∈ float[0 216000000000000000000000]
field_z650 = sum(field_orpo) ∈ option(float[0 540000000000000000000000000])
GROUP BY (field_6zur)
MAP_DCB8 size ∈ int[0 60000000]
field_dpi3 = _ONE_ ∈ float[0 3600000000000000]
field_6zur = _PRIVACY_UNIT_ ∈ str
field_orpo = field_z650 ∈ option(float[0 9000000000000000000])
MAP_SNSL size ∈ int[0 60000000]
_PRIVACY_UNIT_ = _PRIVACY_UNIT_ ∈ str
field_08wv = field_08wv ∈ float{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
_ONE_ = abs((_ONE_ * _ONE_)) ∈ float[0 3600000000000000]
field_z650 = abs((field_z650 * field_z650)) ∈ option(float[0 9000000000000000000])
REDUCE_TQO8 size ∈ int[0 60000000]
_PRIVACY_UNIT_ = first(field_6zur) ∈ str
field_08wv = first(field_z039) ∈ float{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
_ONE_ = sum(field_dpi3) ∈ int[0 60000000]
field_z650 = sum(field_orpo) ∈ option(float[0 3000000000])
GROUP BY (field_6zur, field_z039)
MAP_1B5A size ∈ int[0 60000000]
field_dpi3 = _ONE_ ∈ float{1}
field_6zur = _PRIVACY_UNIT_ ∈ str
field_z039 = field_08wv ∈ float{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
field_orpo = field_z650 ∈ option(float[0 50])
MAP_KK9F size ∈ int[0 60000000]
field_08wv = field_08wv ∈ float{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
_PRIVACY_UNIT_ = _PRIVACY_UNIT_ ∈ option(str)
_PRIVACY_UNIT_WEIGHT_ = _PRIVACY_UNIT_WEIGHT_ ∈ option(int{1})
field_z650 = field_z650 ∈ option(float[0 50])
JOIN__1WV size ∈ int[0 60000000]
field_08wv = _LEFT_.field_08wv ∈ float{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
_PRIVACY_UNIT_ = _RIGHT_._PRIVACY_UNIT_ ∈ option(str)
_PRIVACY_UNIT_WEIGHT_ = _RIGHT_._PRIVACY_UNIT_WEIGHT_ ∈ option(int{1})
field_z650 = _RIGHT_.field_z650 ∈ option(float[0 50])
left__ebqu = _RIGHT_.field_08wv ∈ option(float{1, 2, 3, 4, 5, 6, 7, 8, 9, 10})
LEFT ON (_LEFT_.field_08wv = _RIGHT_.field_08wv)
FIELD_08WV size ∈ int{10}
[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
MAP_OQR1 size ∈ int[0 6000000]
_PRIVACY_UNIT_ = _PRIVACY_UNIT_ ∈ str
_PRIVACY_UNIT_WEIGHT_ = _PRIVACY_UNIT_WEIGHT_ ∈ int{1}
field_z650 = price ∈ float[0 50]
field_08wv = order_id ∈ float{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
WHERE (order_id in (1, 2, 3, 4, 5, 6, 7, 8, 9, 10))
MAP_D_KY size ∈ int[0 6000000]
_PRIVACY_UNIT_ = md5(cast_as_text(field_1mai)) ∈ str
_PRIVACY_UNIT_WEIGHT_ = 1 ∈ int{1}
order_id = field_5zs7 ∈ int[0 100]
item = field_9oif ∈ str
price = field_pdz9 ∈ float[0 50]
JOIN_08FR size ∈ int[0 6000000]
field_uwvc = _LEFT_.id ∈ int[0 100]
field_1mai = _LEFT_.name ∈ str
field_n8a8 = _LEFT_.age ∈ option(float[0 200])
field_vckw = _LEFT_.city ∈ str{New-York, Paris}
field_v1p9 = _RIGHT_._PRIVACY_UNIT_ ∈ int[0 100]
field_5zs7 = _RIGHT_.order_id ∈ int[0 100]
field_9oif = _RIGHT_.item ∈ str
field_pdz9 = _RIGHT_.price ∈ float[0 50]
INNER ON (_RIGHT_._PRIVACY_UNIT_ = _LEFT_.id)
USERS size ∈ int{100}
id = id ∈ int[0 100]
name = name ∈ str UNIQUE
age = age ∈ option(float[0 200])
city = city ∈ str{New-York, Paris}
MAP_DOZ0 size ∈ int[0 60000]
_PRIVACY_UNIT_ = field_llat ∈ int[0 101]
order_id = field_5zs7 ∈ int[0 100]
item = field_9oif ∈ str
price = field_pdz9 ∈ float[0 50]
JOIN_QDCL size ∈ int[0 60000]
field_uwvc = _LEFT_.id ∈ int[0 100]
field_llat = _LEFT_.user_id ∈ int[0 101]
field_r8n6 = _LEFT_.description ∈ str
field_xyhh = _LEFT_.date ∈ date[2020-12-06 2023-12-06]
field_5zs7 = _RIGHT_.order_id ∈ int[0 100]
field_9oif = _RIGHT_.item ∈ str
field_pdz9 = _RIGHT_.price ∈ float[0 50]
INNER ON (_RIGHT_.order_id = _LEFT_.id)
ORDERS size ∈ int{200}
id = id ∈ int[0 100]
user_id = user_id ∈ int[0 101]
description = description ∈ str
date = date ∈ date[2020-12-06 2023-12-06]
ITEMS size ∈ int{300}
order_id = order_id ∈ int[0 100]
item = item ∈ str
price = price ∈ float[0 50]
Rewriting is done 
independently 
on each Relation 
Figure 3: The rewriting process happens in two phases: a rewriting rule allocation phase, where
each node in the computation graph gets allocated a rewriting rule (RR) compatible with its
input and with the desired output property; and a rule application phase, where each Relation
is rewritten according to its allocated RR.
• a rewriting rule allocation phase, where each Relation in the computation graph gets allo-
cated a rewriting rule (RR) compatible with its input and with the desired output property;
• a rule application phase, where each Relation is rewritten to a small computation graph
implementing the logic of the rewriting and stitched together with the other rewritten
Relations.
Before we decribe these phases into more details, let’s define the various properties we may
want to guarantee on each Relation and the ones we need for the output.
4.4.1
Privacy Properties and Rewriting Rules
Each Relation can have one of the following properties:
Privacy Unit Preserving (PUP) : A Relation is PUP if each row is associated with a PU.
In practice it will have a column containing the PID identifying the PU.
Differentially Private (DP) A Relation will be DP if it implements a DP mechanism. A DP
Relation can be safely executed on private data and the result be published. Note that the
privacy loss associated with the DP mechanism has to be accurately accounted for (see
section 5).
Synthetic Data (SD) In some contexts a synthetic data version of source tables is available.
Any Relation derived from other SD or Public Relations is itself SD.
Public (Pub) A relation derived from public tables is labeled as such and does not require any
further protection to be disclosed.
7

---

Published (Pubd) A relation is considered Published if its input relations are either Public,
DP, in some cases SD, or Published themselves. It can be considered as Published but with
some more care like the need to account for the privacy loss incurred by its DP ancestors.
These properties usually require some rewriting of the computation graph to be achieved.
The requirements for a specific Relation to meet some property are embodied in what we call:
rewriting rules. A rewriting rule has input requirements, and an achievable output property that
tells what property can be achieved by rewriting provided the input property requirements are
fulfilled. Each Relation can be assigned different rewriting rules depending on their nature: Map,
Reduce, etc. and the way they are parametrized.
Rewriting Rules can be — for instance — PU propagation rules of the form:
• ∅→PUP for private Tables with a simple rewriting consisting in taking the definition of
the privacy unit and computing the PID column.
• PUP →PUP for Maps (or for Reduce when the PID is in the GROUP BY part) with a
rewriting consisting in propagating the PID column from the input to the output.
• (PUP, PUP) →PUP (or its variants with one published input) for Join and a rewriting
consisting in adding the PID in the ON clause.
Another key Rewriting Rules is PUP →DP for Reduces, it simply means that if the parent of
the Relation can be rewritten as PUP, then we can rewrite the relation to be DP by substituting
DP aggregations to the original aggregations of the Reduce.
One easily see that by simply applying PUP →PUP and PUP →DP rules, one can
propagate the privacy unit across the computation graph of a Relation and compute some DP
aggregate such as a noisy sum or average.
4.4.2
Rewriting Rule Allocation
The first phase of the rewriting process consists in allocating one and only one rule to each
Relation. This is done in three steps illustrated in figure 4:
Rule Setting We assign the set of potential rewriting rules to each Relation in a computation
graph.
Rule Elimination Only feasible rewriting rules are preserved.
A rewriting rule that would
require a PUP input is only feasible if its input Relation has a feasible rule outputting a
PUP Relation.
Rule Selection All feasible allocations of one rewriting rule per Relation are listed, a score
depending on the desired ultimate output property is assigned to each allocation and the
highest scoring allocation is selected. Then, a simple split
  ε
n, δ
n

of the overall privacy
budget (ε, δ) depending on the number of PUP →DP rules: n is chosen.
In the computation graph, while each node’s multiple rewriting rules might suggest a com-
binatorial explosion in the number of possible feasible allocations, this is mitigated in practice.
The pruning of infeasible rules, dictated by the requirement for most relations to have a PUP
input for a DP or PUP outcome, significantly reduces the complexity. Hence, despite the theo-
retical breadth of possibilities, the actual number of feasible paths remains manageable, avoiding
substantial computational problems in practice.
8

---

4.4.3
Rule Application
Once the first phase of rule allocation is achieved, starts the second phase: rule application, as
illustrated in figure 3. In the allocation phase, a global rewriting scheme was set in the form of
an allocation satisfying a system of requirements; in the rewriting phase, each rewriting rule is
applied independently for each Relation. This is possible because once a rewriting rule is applied
to a Relation, the Relation is transformed into a computation graph of Relations whose ultimate
inputs are compatible (same schema, i.e. same columns with same types, plus the new columns
provided by the property achieved) with the inputs of the original Relation and the ultimate
output is also compatible with the output of the original Relation so that rewritten Relations
can be stitched together in a larger graph the same way the original Relations were connected:
see figure 3.
5
Privacy Analysis
When rewriting, a user can require the output Relation to have the Published property. All
rewriting rules with Published outputs require their inputs to be either Public, DP, SD or Pub-
lished themselves. We assume synthetic data provided to the system are differentially private,
so the privacy of the result depends on the way Qrlew rewrites Reduces into DP equivalent
Relations.
All rewriting rules with DP outputs require the input of the Reduce to be PUP so we can
assume a PID column clearly assign one and only one PU to each rows of the rewritten input.
The Reduce is made DP by:
• Making sure the aggregate columns of the Reduce are computed with differentially private
mechanisms.
• Making sure the grouping keys of the GROUP BY clause are either public or released through
a differentially private mechanism.
5.0.1
Protecting aggregation results
The protection of aggregation functions is carried out in two steps. Given that all currently
supported aggregations (COUNT, SUM, AVG, VARIANCE STDDEV) can be reduced to sums, our focus
will be on SUM aggregations, i.e. the computation of partial sums of a column for different groups:
j ∈{1, . . . , m}, of rows.
Let the column be a vector of N real numbers: x = (x1, . . . , xN) ∈RN. We note: πk =
i ∈{1, . . . , n} the PID and gk = j ∈{1, . . . , m} the grouping key associated to xk. We want to
compute all the sums:
Sj =
X
gk=j
xk
with some DP guarantees. To this end we:
1. Limit the contribution of each privacy unit to the sum: We represent the contribution of
each PU: i, by a vector: si whose components are the partial sums within each of the m
groups: si = (si,1, . . . , si,m), where:
si,j =
X
πk=i
gk=j
xk
9

---

The si’s ℓ2 norms are then clipped to c:
si = (si,j)j =


si,j
max

1, ∥si∥2
c



j
See section 8 for more details.
2. Add gaussian noise to each group: The clipped contributions are summed and perturbed
with gaussian noise ν = (ν1, . . . νm) ∼N
 0, σ2Im

:
f
Sj =
n
X
i=1
si,j + νj
With σ2 = 2 ln(1.25/δ)·c2
ε2
. Note that the vector of sums has ℓ2 Global Sensitivity of c, so
this is an application of the Gaussian Mechanism (see: theorem A.1. in [DR+14]) and the
mechanism is ε, δ-differentially private.
5.0.2
Protecting grouping keys
When the grouping keys from a are derived from the data, they are not safe for publication.
Following [KKMN09, WZL+19], we use a mechanism called τ-thresholding to safely release these
grouping keys. Note that, thanks to range propagation (see section 4.2), some groups are already
public and need no differentially private mechanism to be published. Ultimately, the rewriting
of: SELECT sum(x) FROM table GROUP BY g WHERE g IN (1, 2, 3) as a DP equivalent will
not use τ-thresholding, while SELECT sum(x) FROM table GROUP BY g will most certainly do if
nothing more is known about g beforehand.
To summarize the various mechanisms used in Qrlew to date: the rewriting of Reduces with
PUP →DP rules requires the use of gaussian mechanisms and τ-thresholding mechanisms;
then the DP mechanisms used in all the rewritings are aggregated by the Qrlew rewriter as a
composed mechanism. The overall privacy loss is aggregated in a RDP accountant [Mir17].
6
Comparison to other systems
There are a few existing open-source libraries for differential privacy.
Some libraries focus on deep learning and DP-SGD [ACG+16], such as: Opacus [YSS+21],
Tensorflow Privacy [Goo23c] or Optax’s DP-SGD [DBB+20]. Qrlew has a very different goal:
analytics and SQL.
GoogleDP [Goo23a] is a library implementing many differentially private mechanisms in var-
ious languages (C++, Go and Java). IBM’s diffprivlib [HBMAL19] is also a rich library im-
plementing a wide variety of DP primitives in python and in particular many DP versions of
classical machine learning algorithms. These libraries provide the bricks for experts to build DP
algorithms. Qrlew has a very different approach, it is a high level tool designed to take queries
written in SQL by a data practitioner with no expertise in privacy and to rewrite them into
DP equivalent able to run on any SQL-enabled data store. Qrlew implemented very few DP
mechanisms to date, but automated the whole process of rewriting a query, while these library
offer a rich variety of DP mechanism, and give full control to the user to use them as they wish.
Google built several higher-level tools on top of [Goo23a]. PrivacyOnBeam [Goo23b] is a
framework to run DP jobs written in Apache Beam with its Go SDK. PipelineDP [Goo22] is a
10

---

framework that let analysts write Beam-like or Spark-like programs and have them run on Apache
Spark or Apache Beam as back-end. It focuses on the Beam and Spark ecosystem, while Qrlew
tries to provide an SQL interface to the analyst and runs on SQL-enabled back-ends (including
Spark, a variety of data warehouses, and more traditional databases). [Ope23], gives the user a
way to write SQL-like queries and have them executed on tables using GoogleDB custom code,
so it is not compatible with any SQL data store and support relatively simple queries only.
OpenDP [The23] is a powerful Rust library with a python bindings. It offers many possibilities
of building complex DP computations by composing basic elements. Nonetheless, it require both
expertise in privacy and to learn a new API to describe a query. Also, the computations are
handled by the Rust core, so it does not integrate easily with existing data stores and may not
scale well either.
Tumult Analytics [BBD+22] shares many of the nice composable design of OpenDP, but runs
on Apache Spark, making it a scalable alternative to OpenDP. Still, it require the learning of a
specific API (close to that of Spark) and cannot leverage any SQL back-end.
SmartNoise SQL is a library that share some of the design choices of Qrlew. An analyst
can write SQL queries, but the scope of possible queries is relatively limited: no JOINs, no sub-
queries, no CTEs (WITH) that Qrlew supports. Also, it does not run the full computation in the
DB so the integration with existing systems may not be straightforward.
Other systems such as PINQ [McS09] and Chorus [JNHS20] are prototypes that do not seem
to be actively maintained. Chorus shares many of the design goals of Qrlew, but requires post-
processing outside of the DB, which can make the integration more complex on the data-owner
side (as the computation happens in two distinct places).
Beyond that, Qrlew brings unique functionalities, such as:
• advanced automated range propagation;
• the possibility to automatically blend in synthetic data;
• advanced privacy unit definition capabilities across many related tables;
• the possibility for the non-expert to simply write standard SQL, but for the DP aware
analyst to improve its utility by adding WHERE x < b or WHERE x IN (1,2,3) to give
hints to the Qrlew;
• all the compute happens in the DB.
This last point comes with some limitations (see section 7), but opens new possibilities like
the delegation of the rewriting to a trusted third party. The data practitioner could simply write
his desired query in SQL, send it to the rewriter that would keep track of the privacy losses and
use Qrlew to rewrite the query, sign it, and send it back to the data practitioner that can then
send the data-owner, who will check the signature certifying the DP properties of the rewritten
query2.
7
Known Limitations
Qrlew still implements a limited number of DP mechanisms, it is still lacking basic functionalities
such as: quantile estimation, exponential mechanisms.
Qrlew relies on the random number generator of the SQL engine used. It is usually not a
cryptographic secure random number generator.
2A proof of concept is available at: https://github.com/Qrlew/server
11

---

Qrlew uses the floating-point numbers of the host SQL engine, therefore it is liable to the
vulnerabilities described in [CSVW22].
8
Conclusion
Qrlew is a novel way of bringing DP to analytics. It brings both a unique set of features, an
extended coverage of standard SQL, and full execution in the SQL engine, which opens up new
ways to integrate a privacy layer in a data practitioner – data owner relationship. The code
is available on github: https://github.com/Qrlew/qrlew with a Python bindings: https:
//github.com/Qrlew/pyqrlew, a short description: https://qrlew.github.io/
and an interactive demo: https://qrlew.github.io/dp.
References
[ACG+16]
Martin Abadi, Andy Chu, Ian Goodfellow, H Brendan McMahan, Ilya Mironov,
Kunal Talwar, and Li Zhang. Deep learning with differential privacy. In Proceedings
of the 2016 ACM SIGSAC conference on computer and communications security,
pages 308–318, 2016.
[AGKZ18]
Maryam Archie, Sophie Gershon, Abigail Katcoff, and Aaron Zeng. Who’s watch-
ing? de-anonymization of netflix reviews using amazon reviews, 2018.
[BBD+22]
Skye Berghel, Philip Bohannon, Damien Desfontaines, Charles Estes, Sam Haney,
Luke Hartman, Michael Hay, Ashwin Machanavajjhala, Tom Magerlein, Gerome
Miklau, et al. Tumult analytics: a robust, easy-to-use, scalable, and expressive
framework for differential privacy. arXiv preprint arXiv:2212.04133, 2022.
[BS19]
Claire McKay Bowen and Joshua Snoke. Comparative study of differentially private
synthetic data algorithms from the nist pscr differential privacy synthetic data
challenge. arXiv preprint arXiv:1911.12704, 2019.
[CGBR23]
Rodrigo Castellon, Achintya Gopal, Brian Bloniarz, and David Rosenberg. Dp-
tbart: A transformer-based autoregressive model for differentially private tabular
data generation. arXiv preprint arXiv:2307.10430, 2023.
[CGLL22]
Luca Canale, Nicolas Grislain, Gr´egoire Lothe, and Johan Leduc. Generative mod-
eling of complex data. arXiv preprint arXiv:2202.02145, 2022.
[CSVW22]
S´ılvia Casacuberta, Michael Shoemate, Salil Vadhan, and Connor Wagaman.
Widespread underestimation of sensitivity in differentially private libraries and
how to fix it, 2022.
[DBB+20]
DeepMind, Igor Babuschkin, Kate Baumli, Alison Bell, Surya Bhupatiraju, Jake
Bruce, Peter Buchlovsky, David Budden, Trevor Cai, Aidan Clark, Ivo Danihelka,
Antoine Dedieu, Claudio Fantacci, Jonathan Godwin, Chris Jones, Ross Hems-
ley, Tom Hennigan, Matteo Hessel, Shaobo Hou, Steven Kapturowski, Thomas
Keck, Iurii Kemaev, Michael King, Markus Kunesch, Lena Martens, Hamza
Merzic, Vladimir Mikulik, Tamara Norman, George Papamakarios, John Quan,
Roman Ring, Francisco Ruiz, Alvaro Sanchez, Laurent Sartran, Rosalia Schneider,
Eren Sezener, Stephen Spencer, Srivatsan Srinivasan, Miloˇs Stanojevi´c, Wojciech
12

---

Stokowiec, Luyu Wang, Guangyao Zhou, and Fabio Viola. The DeepMind JAX
Ecosystem, 2020.
[DMNS06]
Cynthia Dwork, Frank McSherry, Kobbi Nissim, and Adam Smith. Calibrating
noise to sensitivity in private data analysis.
In Theory of Cryptography: Third
Theory of Cryptography Conference, TCC 2006, New York, NY, USA, March 4-7,
2006. Proceedings 3, pages 265–284. Springer, 2006.
[DR+14]
Cynthia Dwork, Aaron Roth, et al.
The algorithmic foundations of differential
privacy. Foundations and Trends® in Theoretical Computer Science, 9(3–4):211–
407, 2014.
[DSSU17]
Cynthia Dwork, Adam Smith, Thomas Steinke, and Jonathan Ullman. Exposed! a
survey of attacks on private data. Annual Review of Statistics and Its Application,
4:61–84, 2017.
[GdSACS23] Nicolas Grislain, Victoria de Sainte Agathe, Andi Cuko, and Sarus Technologies.
Qrlew, November 2023.
[Goo22]
Google. PipelineDP Library, 2022.
[Goo23a]
Google. Google’s differential privacy libraries, 2023.
[Goo23b]
Google. Privacy On Beam, 2023.
[Goo23c]
Google. TensorFlow Privacy, 2023.
[HBMAL19] Naoise Holohan, Stefano Braghin, P´ol Mac Aonghusa, and Killian Levacher. Diff-
privlib: the IBM differential privacy library. ArXiv e-prints, 1907.02444 [cs.CR],
July 2019.
[IBM23]
IBM. Cost of a data breach report 2023. 2023.
[JNHS20]
Noah Johnson, Joseph P Near, Joseph M Hellerstein, and Dawn Song. Chorus:
a programming framework for building scalable differential privacy mechanisms.
In 2020 IEEE European Symposium on Security and Privacy (EuroS&P), pages
535–551. IEEE, 2020.
[KKMN09]
Aleksandra Korolova, Krishnaram Kenthapadi, Nina Mishra, and Alexandros
Ntoulas. Releasing search queries and clicks privately. In Proceedings of the 18th
international conference on World wide web, pages 171–180, 2009.
[KTH+19]
Ios Kotsogiannis, Yuchao Tao, Xi He, Maryam Fanaeepour, Ashwin Machanava-
jjhala, Michael Hay, and Gerome Miklau. Privatesql: A differentially private sql
query engine. Proc. VLDB Endow., 12(11):1371–1384, jul 2019.
[LSY+20]
Yuhan Liu, Ananda Theertha Suresh, Felix Xinnan X Yu, Sanjiv Kumar, and
Michael Riley. Learning discrete distributions: user vs item-level privacy. Advances
in Neural Information Processing Systems, 33:20965–20976, 2020.
[McS09]
Frank D McSherry. Privacy integrated queries: an extensible platform for privacy-
preserving data analysis. In Proceedings of the 2009 ACM SIGMOD International
Conference on Management of data, pages 19–30, 2009.
13

---

[Mir17]
Ilya Mironov. R´enyi differential privacy. In 2017 IEEE 30th computer security
foundations symposium (CSF), pages 263–275. IEEE, 2017.
[MMS21]
Ryan McKenna, Gerome Miklau, and Daniel Sheldon. Winning the nist contest:
A scalable and general approach to differentially private synthetic data.
arXiv
preprint arXiv:2108.04978, 2021.
[Nea20]
Joseph Near. Threat models for differential privacy. 2020.
[NS08]
Arvind Narayanan and Vitaly Shmatikov. Robust de-anonymization of large sparse
datasets. In 2008 IEEE Symposium on Security and Privacy (sp 2008), pages 111–
125. IEEE, 2008.
[Ope23]
OpenMined and Google. ZetaSQL Library, 2023.
[SAW13]
Latanya Sweeney, Akua Abu, and Julia Winn.
Identifying participants in the
personal genome project by name (a re-identification experiment). arXiv preprint
arXiv:1304.7605, 2013.
[SWK23]
Alexandre Sablayrolles, Yue Wang, and Brian Karrer. Privately generating tabular
data using language models. arXiv preprint arXiv:2306.04803, 2023.
[The23]
The OpenDP Team. OpenDP Library, 2023.
[WAB+18]
Alexandra Wood, Micah Altman, Aaron Bembenek, Mark Bun, Marco Gaboardi,
James Honaker, Kobbi Nissim, David R O’Brien, Thomas Steinke, and Salil Vad-
han. Differential privacy: A primer for a non-technical audience. Vand. J. Ent. &
Tech. L., 21:209, 2018.
[WZL+19]
Royce J Wilson, Celia Yuxin Zhang, William Lam, Damien Desfontaines, Daniel
Simmons-Marengo, and Bryant Gipson. Differentially private sql with bounded
user contribution. arXiv preprint arXiv:1909.01917, 2019.
[YSS+21]
Ashkan Yousefpour, Igor Shilov, Alexandre Sablayrolles, Davide Testuggine,
Karthik Prasad, Mani Malek, John Nguyen, Sayan Ghosh, Akash Bharadwaj, Jes-
sica Zhao, et al. Opacus: User-friendly differential privacy library in pytorch. arXiv
preprint arXiv:2109.12298, 2021.
Appendix
Clipping value used to limit the contribution per user within
the aggregations
In our algorithm, the clipping value c is given by:
c = k · max(| min x|, | max x|),
(1)
where min x and max x are the known bounds of x and k is some parameter of the engine that
can be used to trade some lower noise for some extra bias.
14

---

DP evaluation
We’ve assessed the differential privacy of our code following the outlined procedure in [WZL+19].
Our tables were constructed using columns of Halton sequences. Two scenarii were tested:
• In the first scenario, each user possessed exactly one row.
• In the second scenario, a user could have several rows, with the number of rows owned by
one user following a normal distribution centered at half the size of the table.
Adjacent databases were created by removing one user compared to the reference database
containing all users. Privacy profiles of the underlying distributions were computed using the
formula:
δ(eε) = sup
k
sup
x∈R
fD(x) −eεfDk(x),
(2)
In this context, D represents the distribution of results when the query is executed on the
entire dataset, and Dk corresponds to the distribution when the query is run on the dataset
excluding the data owned by the user k. The algorithm inputting the (ε, δ) parameters is indeed
(ε, δ)-differentially private if δ(eε) in smaller than δ. We have verified this property holds true
for various queries.
15

---

MAP_94NB
order_id, sum_price, count_price, mean_price
Pub
→
Pub
Pubd
→
Pubd
DP
→
Pubd
PUP
→
PUP
SD
→
SD
REDUCE_X2CQ
field_1by4, field_z039, field_lr4c, field_wm9y
Pub
→
Pub
Pubd
→
Pubd
PUP
→
DP
SD
→
SD
SD
→
Pubd
MAP_OQR1
field_z650, field_08wv
Pub
→
Pub
Pubd
→
Pubd
DP
→
Pubd
PUP
→
PUP
SD
→
SD
ITEMS
order_id, item, price
Priv
SD
PUP
MAP_94NB
order_id, sum_price, count_price, mean_price
Pubd
→
Pubd
DP
→
Pubd
SD
→
SD
REDUCE_X2CQ
field_1by4, field_z039, field_lr4c, field_wm9y
PUP
→
DP
SD
→
SD
SD
→
Pubd
MAP_OQR1
field_z650, field_08wv
PUP
→
PUP
SD
→
SD
ITEMS
order_id, item, price
Priv
SD
PUP
MAP_94NB
order_id, sum_price, count_price, mean_price
SD
→
SD
REDUCE_X2CQ
field_1by4, field_z039, field_lr4c, field_wm9y
SD
→
SD
MAP_OQR1
field_z650, field_08wv
SD
→
SD
ITEMS
order_id, item, price
SD
MAP_94NB
order_id, sum_price, count_price, mean_price
DP
→
Pubd
REDUCE_X2CQ
field_1by4, field_z039, field_lr4c, field_wm9y
PUP
→
DP
MAP_OQR1
field_z650, field_08wv
PUP
→
PUP
ITEMS
order_id, item, price
PUP
Rule Elimination
Only Rewriting Rules that are 
compatible with the output properties 
of one of the input Rules are preserved
Rewriting Rule Setting
Each Relation gets assigned Rewriting 
Rules depending on their properties.
Map can usually easily be PUP and 
Reduces can become DP if their input is 
PUP.
Rule Selection
The selection consists in iterating over all 
the feasible allocations of Rewriting Rules 
and chose the one with the hichest score.
The score is computed using heuristic rules.
...
Figure 4: The rewriting happens in three steps: Rule Setting when we assign the set of potential
rewriting rules to each Relation in a computation graph; Rule Elimination, when only feasible
rewriting rules are preserved; and Rule Selection, when an actual allocation is selected.
16

---

