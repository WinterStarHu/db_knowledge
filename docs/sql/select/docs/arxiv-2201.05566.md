# Ranked Enumeration of Join Queries with Projections

> 来源: https://arxiv.org/pdf/2201.05566

Ranked Enumeration of Join Queries with Projections
Shaleen Deep
University of Wisconsin - Madison
shaleen@cs.wisc.edu
Xiao Hu
Duke University
xh102@cs.duke.edu
Paraschos Koutris
University of Wisconsin - Madison
paris@cs.wisc.edu
ABSTRACT
Join query evaluation with ordering is a fundamental data pro-
cessing task in relational database management systems. SQL and
custom graph query languages such as Cypher offer this functional-
ity by allowing users to specify the order via the ORDER BY clause. In
many scenarios, the users also want to see the first 𝑘results quickly
(expressed by the LIMIT clause), but the value of 𝑘is not predeter-
mined as user queries are arriving in an online fashion. Recent work
has made considerable progress in identifying optimal algorithms
for ranked enumeration of join queries that do not contain any
projections. In this paper, we initiate the study of the problem of
enumerating results in ranked order for queries with projections.
Our main result shows that for any acyclic query, it is possible to
obtain a near-linear (in the size of the database) delay algorithm af-
ter only a linear time preprocessing step for two important ranking
functions: sum and lexicographic ordering. For a practical subset
of acyclic queries known as star queries, we show an even stronger
result that allows a user to obtain a smooth tradeoff between faster
answering time guarantees using more preprocessing time. Our re-
sults are also extensible to queries containing cycles and unions. We
also perform a comprehensive experimental evaluation to demon-
strate that our algorithms, which are simple to implement, improve
up to three orders of magnitude in the running time over state-of-
the-art algorithms implemented within open-source RDBMS and
specialized graph databases.
PVLDB Reference Format:
Shaleen Deep, Xiao Hu, and Paraschos Koutris. Ranked Enumeration of
Join Queries with Projections. PVLDB, 15(5): XXX-XXX, 2022.
doi:10.14778/3510397.3510401
PVLDB Artifact Availability:
The source code, data, and/or other artifacts have been made available at
https://github.com/shaleen/rankedenumprojections.
1
INTRODUCTION
Join processing is one of the most fundamental problems in database
research with applications in many areas such as anomaly and
community detection in social media, fraud detection in finance, and
health monitoring. In many data analytics tasks, it is also required
to rank the query results in a specific order. This functionality is
supported by the ORDER BY clause in SQL, Cypher and SPARQL.
We demonstrate a practical example use-case.
This work is licensed under the Creative Commons BY-NC-ND 4.0 International
License. Visit https://creativecommons.org/licenses/by-nc-nd/4.0/ to view a copy of
this license. For any use beyond those covered by this license, obtain permission by
emailing info@vldb.org. Copyright is held by the owner/author(s). Publication rights
licensed to the VLDB Endowment.
Proceedings of the VLDB Endowment, Vol. 15, No. 5 ISSN 2150-8097.
doi:10.14778/3510397.3510401
Example 1. Consider the DBLP dataset as a single relation 𝑅(𝐴, 𝐵),
indicating that 𝐴is an author of paper 𝐵. Given an author 𝑎, the
function h-index(𝑎) returns the h-index of 𝑎. A popular analytical task
asks to find all co-authors who authored at least one paper together.
Additionally, the pairs of authors should be returned in decreasing
order of the sum of their h-indexes, since users are only interested in
the top-100 results. The following SQL query captures this task.
SELECT DISTINCT 𝑅1.𝐴, 𝑅2.𝐴FROM 𝑅AS 𝑅1, 𝑅AS 𝑅2
WHERE 𝑅1.𝐵= 𝑅2.𝐵
ORDER BY h_index(𝑅1.𝐴) + h_index(𝑅2.𝐴) LIMIT 100;
The above task is an example of a join query with projections
(join-project queries) because attribute 𝐵has been projected out
(i.e. it is not present in the selection clause). The DISTINCT clause
ensures that there are no duplicate results.
Importance of joins with projections. Join queries containing
projections appear in several practical applications such as recom-
mendation systems [32, 49], similarity search [71], and network
reachability analysis [14, 28]. In fact, as Manegold et al. [51] re-
marked, joins in real-life queries almost always come with pro-
jections over certain attributes. Matrix multiplication [8], path
queries (equivalent to sparse matrix multiplication), and reachabil-
ity queries [34] are all examples of join-project queries that have
widespread applications in linear and relational algebra. Other data
models such as SPARQL [57] also support the projection operator
and evaluation of join-project queries has been a subject of research,
both theoretically [9] and practically [22]. In fact, as SPARQL sup-
ports ORDER BY/LIMIT operator, ranked enumeration for queries
(that include projections) and top-k over knowledge bases in the
SPARQL model has also been explicitly studied recently [20, 45].
As many practical SPARQL evaluation systems [35, 62] evaluate
queries using RDBMS, it is important to develop efficient algorithms
for such queries in the relational model. Similarly, [68] argued that
since a large fraction of the data of interest resides in RDBMS, ef-
ficient execution of graph queries (such as path and reachability
queries that contain projections and ranking) using RDBMS as the
backend is valuable. In the relational setting, join-project queries
also appear in the context of probabilistic databases (see Section
2.3 in [23]). This motivates us to develop efficient algorithms, both
in theory and practice, that address the challenge of incorporating
the ranked enumeration paradigm for join-project queries.
Prior Work. Efficient evaluation of join queries in the presence
of ranking functions has been a subject of intense research in the
database community. Recent work [18, 26, 65, 67, 69] has made
significant progress in identifying optimal algorithms for enumer-
ating query results in ranked order. In each of these works, the key
idea is to perform on-the-fly sorting of the output via the use of
priority queues by taking into account the query structure. [18]
1
arXiv:2201.05566v2  [cs.DB]  22 Jan 2022

---

considered the problem of top-k tree matching in graphs and pro-
posed optimal algorithms by combining Lawler’s procedure [44]
with the ranking function. [65] introduced multiple dynamic pro-
gramming algorithms that lazily populate the priority queues. [69]
took a different approach where all possible candidates were ea-
gerly inserted into the priority queues and [26] generalized these
ideas to present a unified theory of ranked enumeration for full join
queries. Very recently, [67] was able to extend some of these results
to non equi-joins as well. The performance metric for enumerating
query results is the delay [10], defined as the time difference be-
tween any two consecutive answers. Prior work was able to obtain
logarithmic delay guarantees, which were shown to be optimal.
However, all prior work in this space suffer from one fundamental
limitation: it assumes that the join query is full, i.e. there are no
non-trivial projections involved. In fact, [67] explicitly remarks that
in presence of projections, the strong guarantees obtained for full
queries do not hold anymore. Their suggestion to handle this limita-
tion is to convert the query with projections into a projection-free
result, i.e. materialize the join query result, apply the projection
filter, and then rank the resulting output. However, this conversion
requires an expensive materialization step. An alternate approach
is to modify the weights of the tuples/attribute values to allow re-
use of existing algorithms (we describe this approach in Section 2).
As we show later, this approach also does not fare any better and
requires enumerating the full output of the join query, which can
be polynomially slower than the optimal solution.
On the practical side, all RDBMS and graph processing engines
evaluate join-project queries in the presence of ranking functions
by performing three operations in serial order: (𝑖) materializing
the result of the full join query, (𝑖𝑖) de-duplicating the query result
(since the query has DISTINCT clause), and (𝑖𝑖𝑖) sorting the de-
duplicated result according to the ranking function. The first step
in this process is a show-stopper. Indeed, the size of the full join
query result can be orders of magnitude larger than the size of
the final output after applying projections and de-duplicating it.
Thus, the materialization and the de-duplication step introduces
significant overhead since they are blocking operators. Further, if
the user is interested in only a small fraction of the ordered output,
the user still has to wait until the entire query completes even to
see the top-ranked result.
1.1
Our Contribution and Key Ideas
In this paper, we initiate the study of ranked enumeration over
join-project queries. We focus on two important ranking functions:
SUM (𝑓(𝑥,𝑧) = 𝑥+ 𝑧) and LEXICOGRAPHIC (𝑓(𝑥,𝑧) = 𝑥,𝑧) for two
reasons. First, both of these functions are very useful in practice [37].
Second, extending the algorithmic ideas to other functions, such
as MIN, MAX, AVG and circuits that use sum and products, is quite
straightforward. More specifically, we make three contributions.
1. Enumeration with Formal Delay Guarantees. Our first main
result shows that for any acyclic query (the most common fragment
of queries in practice [15]) with arbitrary projection attributes, it is
possible to develop efficient enumeration algorithms (Section 3).
Theorem 1. For an acyclic join-project query 𝑄, an instance 𝐷, and
a ranking function rank ∈{SUM, LEXICOGRAPHIC}, the query result
𝑄(𝐷) can be enumerated according to rank with worst-case delay
𝑂(|𝐷| log |𝐷|), after 𝑂(|𝐷|) preprocessing time.
This result implies that top-𝑘results in 𝑄(𝐷) can be enumerated
in 𝑂(𝑘|𝐷| log |𝐷|) time. Theorem 1 is able to recover the prior
results for ranked enumeration of full queries as well [26]. The
key idea of our algorithm is to develop multiway join plans [55]
by exploiting the properties of join trees. Embedding the priority
queues in the join tree strategically allows us to generate the sorted
output on-the-fly and avoid the binary join plans that all state-
of-the-art systems use. Further, since we formulate the problem
in terms of delay guarantees, it allows our techniques to be limit-
aware: for small 𝑘, the answering time is also small.
2. Faster Enumeration with More Preprocessing. Our second
contribution is an algorithm that allows for a smooth tradeoff be-
tween preprocessing time and delay guarantee for a subset of join-
project queries known as star queries over binary relations of the
form 𝑅𝑖(𝐴𝑖, 𝐵) (denoted as 𝑄★𝑚) (Section 4):
SELECT DISTINCT 𝐴1, . . . ,𝐴𝑚FROM 𝑅1, . . . , 𝑅𝑚
WHERE 𝑅1.𝐵= · · · = 𝑅𝑚.𝐵ORDER BY 𝐴1 + · · · + 𝐴𝑚LIMIT k;
Theorem 2. For a star join-project query 𝑄★𝑚, an instance 𝐷, and
a ranking function rank ∈{SUM, LEXICOGRAPHIC}, the query result
𝑄(𝐷) can be enumerated according to rank with worst-case delay
𝑂 |𝐷|1−𝜖log |𝐷|, using 𝑂

|𝐷|1+(𝑚−1)𝜖
preprocessing time and
𝑂

|𝐷|𝑚(1−𝜖)
space, for any 0 ≤𝜖≤1.
Theorem 2 enables users to carefully control the space usage, pre-
processing time and delay. For both Theorem 1 and Theorem 2, we
can show that the delay guarantee is optimal subject to a conjecture
about the running time of star join-project queries in Subsection 4.2.
3. Experimental Evaluation. Our final contribution is an exten-
sive experimental evaluation for practical join-project queries on
real-world datasets (Section 6). To the best of our knowledge, this is
the first comprehensive evaluation of how existing state-of-the-art
relational and graph engines execute join-project queries in the
presence of ranking. We choose MariaDB, PostgreSQL, two popular
open-source RDBMS, and Neo4j as our baselines. We highlight two
key results. First, our experimental evaluation demonstrates the bot-
tleneck of serially performing materialization, de-duplicating, and
sorting. Even with LIMIT 10 (i.e. return the top-10 ranked results),
the engines are orders of magnitude slower than our algorithm.
For some queries, they cannot finish the execution in a reasonable
time since they run out of main memory. On the other hand, our
algorithm has orders of magnitude smaller memory footprint that
allows for faster execution. The second key result is that all baseline
engines are agnostic of the ranking function. The execution time of
the queries is identical for both the sum and lexicographic ranking
function. However, our algorithm uses the additional structure of
lexicographical ordering and can execute queries 2 −3× faster than
the sum function. For queries with unions and cycles, our algorithm
maintains its performance improvement over the baselines.
2
PROBLEM SETTING
In this section we present the basic notions and terminology, and
then discuss our framework. We focus on the class of join-project
2

---

R3(C, D)
R1(A, B)
R2(B, C)
R4(D, E)
root
anchor(R1) = {B}
A⇡
1 = {A}
node 1
node 2
node 3 =
node 4
anchor(R2) = {C}
A⇡
2 = {A}
anchor(R4) = {D}
A⇡
4 = {E}
Figure 1: Illustration of join tree for a join-project query 𝑄=
𝜋𝐴,𝐸(𝑅1(𝐴, 𝐵) Z 𝑅2(𝐵,𝐶) Z 𝑅3(𝐶, 𝐷) Z 𝑅4(𝐷, 𝐸)).
queries, which are defined as
𝑄= 𝜋A(𝑅1(A1) Z 𝑅2(A2) Z . . . Z 𝑅𝑚(A𝑚))
Here, each relation has schema 𝑅𝑖(A𝑖), where A𝑖is an ordered
set of attributes. Let A = A1 ∪A2 ∪· · · ∪A𝑚. The projection
operator 𝜋A only keeps a subset of the attributes from A. The join
we consider is natural join, where tuples from two relations can be
joined if they share the same value on the common attributes. A
join-project query is full if A = A. Unlike prior work on ranked
enumeration, in this paper we place no restriction on the set of
attributes in the projection operator. For simplicity of presentation,
we do not consider selections; these can be easily incorporated
into our algorithms. As an example, the SQL query in Example 1
corresponds to the following query: 𝜋𝐴,𝐵(𝑅1(𝐴,𝐶) Z 𝑅2(𝐵,𝐶)).
A database 𝐷is a set of relations, whose size is defined as the
total number of tuples in all relations denoted as |𝐷|. For tuple 𝑡, we
will use the shorthand 𝑡[𝐴] to denote 𝜋𝐴(𝑡). We use E to denote
the set of all relations in the database.
Acyclic Queries and Join Trees. A join-project query 𝑄is acyclic
if and only if it admits a join tree T. In a join tree, each relation is a
node, and for each attribute 𝐴, all nodes in the tree containing 𝐴
form a connected subtree. For simplicity, we will use node 𝑖to refer
to the node corresponding to relation 𝑅𝑖in T. Given a join tree T,
pick any node to be the root, and then orient each edge towards the
root. Let T𝑖be the subtree rooted at node 𝑅𝑖. Let parent(𝑅𝑖) be the
(unique) parent of 𝑅𝑖, and anchor(𝑅𝑖) = 𝑅𝑖∩parent(𝑅𝑖) to be the
anchor attributes between 𝑅𝑖and its parent. Let child(𝑅𝑖) be the set
of children nodes of 𝑅𝑖. Finally, we fix the ordering of the projection
attributes in A to be the order of visiting them in the in-order
traversal of T. Finally, we define A𝜋
𝑖as the ordered set of projection
attributes in subtree rooted at node𝑖(including projection attributes
of node 𝑖). As a convention, we define anchor(𝑟) = ∅,𝐴𝜋𝑟= ∅for
the root 𝑟and child(𝑅𝑖) = ∅for a leaf node 𝑅𝑖.
Example 2. Consider a join-project query 𝑄= 𝜋𝐴,𝐸(𝑅1(𝐴, 𝐵) Z 𝑅2
(𝐵,𝐶) Z 𝑅3(𝐶, 𝐷) Z 𝑅4(𝐷, 𝐸)) under the ranking function SUM
defined over attributes 𝐴, 𝐸. In other words, for every output tuple 𝑡,
the score of the tuple is 𝑡[𝐴] + 𝑡[𝐸]. Figure 1 shows the join tree for
the query. We fix 𝑅3 as the root with 𝑅2 as the left child and 𝑅4 (a leaf
node) as the right child. 𝑅1, as a leaf node, is also the only child of 𝑅2.
. . .
. . .
A1, A2, A3
A1, A3, A4
A1, A2, A3
A1, A3, A4
A1, An−1, An
A1, B1, B2, . . . , Bm
A2, B1, B2, . . . , Bm
Am, B1, B2, . . . , Bm
Figure 2: Examples of GHD and fhw. The leftmost is the min-
imal GHD of a cycle join 𝑄= 𝑅1(𝐴1,𝐴2) Z 𝑅2(𝐴2,𝐴3) Z
· · · Z 𝑅𝑛−1(𝐴𝑛−1,𝐴𝑛) Z 𝑅𝑛(𝐴𝑛,𝐴1) with fhw = 2. The mid-
dle is the minimal GHD of a bi-clique join 𝑄=Z𝑖∈[𝑛],𝑗∈[𝑚]
𝑅(𝑖−1)𝑚+𝑗(𝐴𝑖, 𝐵𝑗) with fhw = 𝑚. The rightmost is the mini-
mal GHD of a butterfly join 𝑄= 𝑅1(𝐴1,𝐴2) Z 𝑅2(𝐴2,𝐴3) Z
𝑅3(𝐴1,𝐴4) Z 𝑅4(𝐴4,𝐴3) with fhw = 2.
Generalized Hypertree Decompositions. A weight assignment
u = (𝑢𝐹)𝐹∈E is said to be a fractional edge cover if (𝑖) for every
𝐹∈E, 𝑢𝐹≥0; and (𝑖𝑖) for every 𝑋∈A, Í
𝐹:𝑋∈𝐹𝑢𝐹≥1. The
fractional edge cover number for A, denoted 𝜌∗(A) is the minimum
of Í
𝐹∈E 𝑢𝐹over all possible edge covers. A generalized hypertree
decomposition (GHD) of a query𝑄is a tuple (T, (B𝑡)𝑡∈𝑉(T)) where
T is a tree and every B𝑡(called the bag of 𝑡) is a subset of A for
each node 𝑡of the tree such that: (𝑖) each variables of each 𝐹∈E
is contained in some bag; and (𝑖𝑖) for each 𝐴∈A, the set of nodes
{𝑡| 𝐴∈B𝑡} is connected in T. The fractional hypertree width of
a decomposition is defined as max𝑡∈𝑉(T) 𝜌∗(B𝑡), where 𝜌∗(B𝑡)
is the fractional edge cover number of the attributes in B𝑡. The
fractional hypertree width of a query 𝑄, denoted fhw(𝑄), is the
minimum fractional hypertree width over all possible GHDs of
𝑄. Figure 2 gives examples of GHDs of popular queries and their
width. For an acyclic query, it holds that fhw = 1 and any join tree
is a valid GHD.
Computational Model. To measure the running time of our algo-
rithms, we use the uniform-cost RAM model [36], where data values
as well as pointers to databases are of constant size. Throughout
the paper, all complexity results are with respect to data complexity,
where the query is assumed fixed. It is important to note that we
focus on the main memory setting. We further assume existence of
perfect hashing that allows constant time lookups in hash tables.
2.1
Ranking Functions
The ordering of query results in 𝑄(𝐷) can be specified by a ranking
function, or through the ORDER BY clause of a SQL query in practice.
Formally, a total order ⪰on the tuples in 𝑄(𝐷) defined over the
attributes A, is induced by a ranking function rank that maps each
tuple 𝑡∈𝑄(𝐷) to a real number rank(𝑡) ∈R. In particular, for two
tuples 𝑡1,𝑡2, we have 𝑡1 ⪰𝑡2 if and only if rank(𝑡1) ≥rank(𝑡2). We
assume that dom(𝐴) for any 𝐴∈A is also equipped with a total
order ⪰. We present an example of a ranking function below.
Example 3. Consider a function 𝑤: dom(𝐴) →R for any attribute
𝐴∈A. For each query result 𝑡, we define its rank as rank(𝑡) =
Í
𝐴∈A 𝑤(𝑡[𝐴]), the total sum of the weights over all attributes in A.
3

---

We will focus on SUM and LEXICOGRAPHIC in this paper. We
note that both functions are instantiations of a more general class
of decomposable functions [26]. The ideas introduced for SUM and
LEXICOGRAPHIC are readily applicable to more complicated func-
tions including products, a combination of sum and products, etc.
2.2
Problem Parameters
Given a join-project query 𝑄and a database 𝐷, an enumeration
query asks to enumerate the tuples of 𝑄(𝐷) according to some
specific ordering defined by rank. We study this problem in a similar
framework as [61], where an algorithm is decomposed into:
• a preprocessing phase that takes time 𝑇𝑝and computes a
data structure of size 𝑆𝑝, and
• an enumeration phase (i.e. the online query phase) that
outputs 𝑄(𝐷) without duplicates under the specified order-
ing whenever a user query is issued. This phase has full
access to any data structures constructed in the preprocess-
ing phase. The time between outputting any two consecutive
tuples (and also the time to output the first tuple, and the
time to notify that the enumeration has completed after the
last tuple) is at most 𝛿.
Prior work [26] has shown that for acyclic joins without pro-
jections, there exists an algorithm with 𝑇𝑝= 𝑆𝑝= 𝑂(|𝐷|) that can
achieve 𝛿= 𝑂(log |𝐷|) delay under ranking. However, the problem
of ranked enumeration when projections are involved is wide open.
Using Existing Algorithms. One possible solution to the problem
is to set the weights of non-projection attributes to 0. This will
ensure that for SUM function, only the projection attributes are
considered in the ranking and existing algorithms for full join
queries could be used. However, this proposal gives poor delay
guarantees and is as expensive as enumerating the full join result.
For example, for the four path query in Example 2, the output of the
query could be constant in size but the full join can be as large as
Ω(|𝐷|2) which is prohibitively expensive, but our algorithm would
only require 𝑂(|𝐷|) in this case. In general, a join with ℓrelations
may require as much as Ω(|𝐷|ℓ−1) time to output the smallest tuple.
We describe more details and the formal proof in Appendix B.
3
GENERAL ACYCLIC QUERIES
We first describe the main algorithm of enumerating acyclic join-
project queries for SUM ordering in Subsection 3.1, followed by
a specialized algorithm for LEXICOGRAPHIC ordering in Subsec-
tion 3.2. Before we describe the algorithm, we introduce two key
data structures that will be used: cell and priority queues.
Definition 1. A cell, denoted as𝑐= ⟨𝑡, [𝑝1, . . . , 𝑝𝑘],𝑞⟩, is a vector
consisting of three values: (i) a tuple 𝑡∈𝑅𝑖for node 𝑖in the join tree
T, (ii) an array of pointers [𝑝1, . . . , 𝑝𝑘] where the ℓ𝑡ℎpointer points
to a cell defined for ℓ𝑡ℎchild of node 𝑖in T, (iii) a pointer 𝑞that can
only point to another cell defined for node 𝑖.
Given a cell 𝑐defined for node 𝑖, one can reconstruct the tuple
over A𝜋
𝑖in constant time (dependent only on the query size, which
is a constant) by traversing the pointers recursively. We will use
output(c) to denote the utility method that performs this task. Note
that the time and space complexity of creating a cell is 𝑂(1) since
the size of the query and the database schema is assumed to be
a constant. This implies that we only need to insert/access a con-
stant number of entries in the vector representing a cell. Similarly,
output(c) also takes 𝑂(1) time since the join tree size is a constant.
Priority queue. A priority queue is a data structure for maintain-
ing a set 𝑆of elements, each with an associated value called a key.
The space complexity of a priority queue containing |𝑆| elements
is 𝑂(|𝑆|). We will use an implementation of a priority queue (e.g., a
Fibonacci heap [33]) with the following properties: (i) an element
can be inserted in 𝑂(1) time, (ii) the min element can be obtained
in 𝑂(1) time, and (iii) the min element can be popped and deleted
in 𝑂(log |𝐷|) time. We will use the priority queue in conjunction
with a cell in the following way: for two cells 𝑐1 and 𝑐2, the pri-
ority queue uses rank(output(c1)) and rank(output(c2)) in the
comparator function to determine the relative ordering of 𝑐1 and
𝑐2. If rank(output(c1)) = rank(output(c2)), then we break ties
according to the lexicographic order of output(c1) and output(c2).
The choice of lexicographic ordering is not driven by any specific
consideration; as long as the ties are broken consistently, we can
use other tie-breaking criteria too. Once again, the comparator func-
tion only takes a 𝑂(1) time to compare since the ranking function
rank(output(c)) can be evaluated in constant time.
3.1
General Algorithm
In this section, we present the algorithm for Theorem 1. At a high
level, each node 𝑖in the join tree will materialize, in an incremental
fashion, all tuples over the attributes A𝜋
𝑖∪anchor(𝑅𝑖) in sorted
order. In order to efficiently store the materialized output, we will
use the cell data structure. Since we need to sort the materialized
output, each node in the join tree maintains a set of priority queues
indexed by 𝜋anchor(𝑅𝑖) (𝑢),𝑢∈𝑅𝑖. The values of the priority queue
are the cells of node 𝑖. For example, given the join tree from Exam-
ple 2, node 2 containing 𝑅2 will incrementally materialize the sorted
result of the subquery 𝜋𝐶,𝐴(𝑅2(𝐵,𝐶) Z 𝑅1(𝐴, 𝐵)) that is indexed
by the values 𝜋𝐶(𝑅2(𝐵,𝐶)) since A𝜋
2 = {𝐴} and anchor(𝑅2) = {𝐶}.
Note that there may be multiple possible join trees for a given
acyclic query. Our algorithm is applicable to all join trees. In fact,
any node in the join tree can be chosen as the root without any
impact on the time and space complexity.
Preprocessing Phase. We begin by describing the algorithm for
preprocessing in Algorithm 1. We assume that a join tree has been
fixed and the input instance 𝐷does not contain any dangling tuples,
i.e., tuples that will not contribute in the join; otherwise, we can
invoke the Yannakakis algorithm [70] to remove all dangling tuples.
We initialize a set of empty priority queues for every node in the join
tree. We proceed in a bottom up fashion and perform the following
steps. For each leaf relation 𝑅𝑖∈T, we create a cell ⟨𝑡, [], ⊥⟩
for each tuple 𝑡∈𝑅𝑖and insert it into PQ𝑖[𝜋anchor(𝑅𝑖) (𝑡)]. For
each non-leaf relation 𝑅𝑗∈T, we create a cell for 𝑡∈𝑅𝑗, which
points to the top of the priority queue in each child node of 𝑅𝑗that
can be joined with 𝑡. This cell is then added to the priority queue
PQ𝑖[𝜋anchor(𝑅𝑖) (𝑡)]. Note that we only have one priority queue for
the root relation 𝑟since anchor(𝑟) = ∅by definition.
Example 4. Continuing with the 4-path query running example,
consider the following instance 𝐷as shown below.
4

---

h(1, 1), [], ?i
1
h(2, 1), [], ?i
2
h(1, 2), [], ?i
1
h(1, 1), [100], ?i
1
h(2, 1), [200], ?i
1
100
101
200
201
300
301
400
401
h(1, 1), [], ?i
1
h(1, 2), [], ?i
2
h(3, 2), [], ?i
3
h(1, 1), [300, 400], ?i
2
500
R3(C, D)
R2(B, C)
R1(A, B)
R4(D, E)
PQ3[]
PQ4[1]
PQ2[1]
PQ1[1]
PQ1[2]
(a) Data structure state after the preprocessing phase. Each mem-
ory location has a cell and the partial score of the partial answer
R3(C, D)
R2(B, C)
R1(A, B)
R4(D, E)
h(2, 1), [], ?i
2
100
101
200
201
h(3, 2), [], ?i
3
h(1, 1), [], 101i
1
h(1, 2), [], 201i
1
h(2, 1), [200], ?i
1
h(1, 1), [101], ?i
2
h(2, 1), [201], ?i
3
300
301
h(1, 1), [100], 302i
1
h(2, 1), [200], 303i
1
302
303
400
401
h(1, 2), [], ?i
2
h(1, 1), [], 401i
1
h(1, 1), [302, 400], ?i
3
h(1, 1), [300, 401], ?i
3
500
501
502
h(1, 1), [300, 400], ?i
2
PQ3[]
PQ4[1]
PQ2[1]
PQ1[1]
PQ1[2]
(b) Data structure after one iteration of procedure Enum()
Figure 3: Example to demonstrate the preprocessing and enumeration phase of the general algorithm
Algorithm 1: PreprocessAcyclic
Input
:Input query 𝑄, database instance 𝐷; join tree T;
ranking function rank.
Output:Priority Queues PQ
1 foreach 𝑅𝑖∈T in post order traversal do
2
foreach 𝑡∈𝑅𝑖do
3
𝑢←𝜋anchor(𝑅𝑖) (𝑡);
4
if PQ𝑖[𝑢] does not exist then
5
PQ𝑖[𝑢] ←∅;
/* Initialize a priority queue */
6
𝐿←∅;
7
foreach 𝑅𝑗is the child of 𝑅𝑖do
8
𝐿.insert(PQ 𝑗[𝜋anchor(𝑅𝑗) (𝑢)].top());
9
PQ𝑖[𝑢].insert(⟨𝑡, 𝐿, ⊥⟩);
𝐴
𝐵
1
1
2
1
1
2
3
2
𝑅1
𝐵
𝐶
1
1
2
1
𝑅2
𝐶
𝐷
1
1
1
2
𝑅3
𝐷
𝐸
1
1
1
2
𝑅4
As we saw before, Figure 1 shows the join tree along with the anchor
attributes in each relation. Figure 3a shows the state of priority queues
after the preprocessing step. After the full reducer pass, tuple (1, 2)
is removed from 𝑅3 because there is no join tuple that can be formed
using it. Then, we start constructing the cells for each node starting
with the leaf nodes. Since 𝐵is the anchor for relation 𝑅1, we create two
priority queues PQ1[1] and PQ1[2]. For PQ1[1], we create the cells
for tuples (1, 1) and (2, 1). For convenience, the cells are followed by
the partially aggregated score. Consider relation 𝑅2(𝐵,𝐶). The cell for
tuple (1, 1) in PQ2[1] points to the top of PQ1[1] (shown as pointer
with address 100). The root bag consists of a single tuple entry which
points to the cells at locations 300 and 400. The output tuple that can
be formed by the root bag is (𝐴= 1, 𝐸= 1).
Enumeration Phase. We describe the enumeration procedure
in Algorithm 2. The high-level idea is to output answers by re-
peatedly popping elements from the root priority queue. It may be
Algorithm 2: EnumAcyclic
Input
:Input query 𝑄, database instance 𝐷; join tree T;
ranking function rank; Priority queues PQ
Output:𝑄(𝐷) in ranked order
1 procedure Enum()
2
last ←∅;
3
while PQ𝑟[∅] ≠∅do
4
𝑜←PQ𝑟[∅].top();
5
if is_equal(𝑜, last) = false then
6
print output(𝑜), last ←𝑜;
/* new output */
7
Topdown (𝑜,𝑟);
8 procedure Topdown(𝑐, 𝑗) /* 𝑐= ⟨𝑡, [𝑝1, . . . , 𝑝𝑘], next⟩*/
9
𝑢←𝜋anchor(𝑅𝑗) (𝑐.𝑡);
10
if 𝑐.next = ⊥then
11
while true do
12
temp ←pop(PQ 𝑗[𝑢]);
13
foreach 𝑅𝑖is a child of 𝑅𝑗do
14
𝑝′
𝑖←Topdown(𝑐.𝑝𝑖,𝑖) ;
15
if 𝑝′
𝑖≠⊥then
16
PQ 𝑗[𝑢].insert(⟨𝑡, [𝑐.𝑝1, . . . , 𝑝′
𝑖, . . .𝑐.𝑝𝑘], ⊥⟩)
17
if 𝑅𝑗is not the root then
18
𝑐.next ←addressof(PQ 𝑗[𝑢].top());
19
if is_equal(temp, PQ 𝑗[𝑢].top()) = false
then break;
20
return 𝑐.next;
21 procedure is_equal(𝑐1,𝑐2)
22
if rank(output(𝑐1))≠rank(output(𝑐2)) then return
false
23
foreach 𝐴∈A do
24
if output(𝑐1)[𝐴] < output(𝑐2)[𝐴] then return
false
25
return true;
5

---

possible that multiple tuples of the root priority queue output the
same final result. In order to deduplicate answers, we compare the
answer at the current top of the priority queue with the previous
answer (line 5), and output it only if they are different. Then, we
invoke the procedure Topdown to insert new candidates into the
priority queue. This procedure will be recursively propagated over
the join tree until it reaches the leaf nodes. Observe that once the
new candidates have been inserted, the next pointer of a cell is
updated by pointing to the topmost element in the priority queue.
This chaining materializes the answers for a particular node that
can be reused and is key to avoiding repeated computation.
Example 5. Continuing our running example, Figure 3b shows the
state of the priority queues after one complete iteration of procedure
Enum(). We first pop the only element in root priority queue and note
that the output tuple (𝐴= 1, 𝐸= 1) is enumerated. Then we call
Topdown with cell at memory 500 and root (node 3) as arguments
(denoted as Topdown(∗500, 3)). The next for the cell is ⊥so we pop
the cell at 500 from the priority queue (shown as greyed out in the
figure) and recursively call Topdown(∗300, 2). The cell at memory
location 300 has next = ⊥. Therefore, we enter the while loop, pop the
cell and recursively call Topdown(∗100, 1). We have now reached the
leaf node. The anchor attribute value for cell at 100 is 𝑢= 1, so we
pop the current cell from PQ1[1] (greyed out cell at 100), find the next
candidate at the top of PQ1[1] (which is cell at 101), chain it to the
cell at 100 by assigning next = 101 and return the cell at 101 to the
parent. When the program control returns from the recursive call back
to node 2, we create a new cell (at memory address 302) that points to
101 and insert it into the priority queue. However, observe that the cell
at memory location 301 also generates 𝐴= 1, a duplicate since cell at
300 also generated it. This is where the equality check at line 19 comes
in. Since both cells at 300 and 301 generate the same value, we also
pop off the cell at 301 in the subsequent while loop iteration, find its
next candidate and create the cell at 303, and insert into the priority
queue. This ensures that all elements in PQ2[1] generating the same
𝐴value are removed, ensuring no duplicates at the root level. Finally,
the control returns to the root level Topdown call. The recursive call
to the right child (node 4) create a new cell 401 and we insert two cells
at the root priority queue, cell 501 and 502 that correspond to output
tuple (𝐴= 2, 𝐸= 1) and (𝐴= 1, 𝐸= 2) respectively.
We are now ready to formally prove Theorem 1.
Lemma 1. The delay guarantee of EnumAcyclic is at most𝑂(|𝐷| log |𝐷|).
Lemma 2. PreprocessAcyclic running in𝑂(|𝐷| log |𝐷|) time, gen-
erates a data structure of size 𝑂(|𝐷|).
Lemma 3. EnumAcyclic enumerates the query result 𝑄(𝐷) in
ranked order correctly.
Together, the above lemmas establish Theorem 1. We defer the
full proofs to Appendix C. We also show how we can recover loga-
rithmic delay guarantee for full queries from [26, 65].
3.2
Improvement for Lexicographic Ranking
The algorithm from last section is also applicable to LEXICOGRAPHIC
ranking function. In fact, we can transform LEXICOGRAPHIC with
an attribute ordering of 𝐴1,𝐴2, · · · ,𝐴𝑚, into SUM by defining a
ranking function rank(𝑡) = Í𝑚
𝑖=1 10𝑚−𝑖· 𝑤(𝜋𝐴𝑖(𝑡)) for tuple 𝑡,
while preserving the LEXICOGRAPHIC ordering. In this section, we
present an alternative algorithm by exploiting the special structural
properties of LEXICOGRAPHIC, that the global ranking also implies
local ranking over every output attribute. Moreover, it admits to
enumerate query results not only in lexicographic order as given
by ORDER BY 𝐴1,𝐴2, · · · ,𝐴𝑚but also arbitrary ordering on each
attribute (for instance, ORDER BY 𝐴1 ASC, 𝐴2 DESC . . . ).
Preprocessing Phase. In this phase, we perform the full reducer
pass to remove all dangling tuples and create hash indexes for the
base relations in sorted order. We also sort dom(𝐴𝑖).
Enumeration Phase. Given an attribute order of output attributes
A = {𝐴1,𝐴2, · · · ,𝐴𝑚}, we start by fixing the minimum value in
dom(𝐴1) as 𝑎1. Then, we perform the two-phase semi-joins to re-
move tuples that cannot be joined with value 𝑎1, and find the values
in dom(𝐴2) that survive after semi-joins, denoted as L𝐴2 (𝑎1). Sim-
ilarly, we fix the minimum value in L𝐴2 (𝑎1) as 𝑎2, and perform
the two-phase semi-joins for finding the values in dom(𝐴3) that
can be joined with both 𝑎1,𝑎2. We continue this process until all
attributes in A have been fixed, and end up with enumerating such
a query result (with fixed values). Then, we backtrack and continue
the process until all values in attribute 𝐴1 are exhausted.
Algorithm 3: EnumAcyclicLexi(𝑡, L, 𝑖)
Input
:Input query 𝑄, database 𝐷
Output:𝑄(𝐷) ⋉𝑡in lexicographic order of 𝐴𝑖, · · · ,𝐴𝑚
1 if 𝑖= 𝑚then output 𝑡and return;
2 foreach 𝑎∈L do
3
L′ ←𝜋𝐴𝑖+1 (𝜎𝐴𝑖=𝑎(𝑅𝑖+1 ⋉𝑡)) ;
/* by semi-joins */
4
𝑡′ ←(𝑡,𝑎);
/* create new tuple */
5
EnumAcyclicLexi(𝑡′, L′,𝑖+ 1);
Algorithm 3 takes as input an acyclic query 𝑄, an database
𝐷, an integer 𝑖∈{1, · · · ,𝑚}, a tuple 𝑡defined over attributes
𝐴1, · · · ,𝐴𝑖−1, and a set of values L ⊆dom(𝐴𝑖) that can be joined
with 𝑡in 𝐷. The original problem can be solved by invokingbreak
EnumAcyclicLexi(∅, dom(𝐴1), 1) for sorted dom(𝐴1).
Lemma 4. EnumAcyclicLexi enumerates 𝑄(𝐷) correctly in lexico-
graphic order with delay guarantee 𝑂(|𝐷|) after preprocessing time
𝑇𝑝= 𝑂(|𝐷| log |𝐷|) and space complexity 𝑂(|𝐷|).
4
STAR QUERIES
In this section, we present a specialized data structure for the star
query, which is represented as: 𝑄★𝑚= 𝜋A(𝑅1(𝐴1, 𝐵) Z 𝑅(𝐴2, 𝐵) Z
· · · Z 𝑅𝑚(𝐴𝑚, 𝐵)). where A = {𝐴1, · · · ,𝐴𝑚}. All relations in a star
query join on exactly the same attribute(s). In this following, we
present a specialized data structure on ranked enumeration for 𝑄★𝑚
in Section 4.1, and prove the optimality in Section 4.2.
4.1
The Algorithm
Consider the star query 𝑄★𝑚, a database 𝐷and a ranking function
rank. Now we present a data structure for Theorem 2.
6

---

Algorithm 4: PreprocessStar
Input
:Input star query 𝑄★𝑚, ranking function rank and
database 𝐷; degree threshold 𝛿≥1
Output:Heavy output O𝐻and priority queue PQ
1 foreach 𝑖∈{1, 2, · · · ,𝑚} do
2
𝑅𝐻
𝑖
←{𝑡∈𝑅𝑖: |𝜎𝐴𝑖=𝜋𝐴𝑖(𝑡) | ≥𝛿};
3
𝑅𝐿
𝑖←{𝑡∈𝑅𝑖: |𝜎𝐴𝑖=𝜋𝐴𝑖(𝑡) | < 𝛿};
4 Compute O𝐻←𝜋A

𝑅𝐻
1 Z · · · Z 𝑅𝐻𝑚

;
5 Sort O𝐻by rank;
6 for 𝑖∈{0, 1, . . . ,𝑚−1} do
7
𝑄𝑖←𝑅𝐻
1 Z · · · Z 𝑅𝐻
𝑚−1 Z 𝑅𝐿
𝑖Z 𝑅𝑖+1 Z · · · Z 𝑅𝑚;
8
T𝑖←a join tree for 𝑄with 𝑅𝑖as root and all other
relations as children of 𝑅𝑖;
9
PreprocessAcyclic(𝑄𝑖, T𝑖);
10
next ←EnumAcyclic(𝑄𝑖, T𝑖);
11
PQ.insert(next); /* insert the smallest tuple into PQ */
Preprocessing Phase. Without loss of generality, assume that
there is no dangling tuples in 𝐷. Moreover, if A does not include an
attribute 𝐴, we can remove efficiently 𝑅𝑖using a semi-join. We first
fix a degree threshold 𝛿≥1 (whose value will be determined later).
For each 𝑖∈{1, 2, · · · ,𝑚}, a value 𝑎𝑖∈dom(𝐴) is heavy if it has de-
gree larger than 𝛿in 𝑅𝑖, i.e., |𝜎𝐴=𝑎𝑖(𝑅𝑖)| ≥𝛿, and light otherwise. A
tuple 𝑡= (𝑎𝑖,𝑏) ∈𝑅𝑖is heavy if 𝑎𝑖is heavy. For 𝑅𝑖, let 𝑅𝐻
𝑖, 𝑅𝐿
𝑖be the
set of heavy and light tuples in 𝑅𝑖. An output 𝑡= (𝑎1,𝑎2, . . . ,𝑎𝑚) ∈
𝑄★𝑚(𝐷) is heavy if 𝑎𝑖is heavy in 𝑅𝑖for each 𝑖∈{1, 2, · · · ,𝑚}, and
light otherwise. In this way, we can divide the output 𝑄★𝑚(𝐷) into
O𝐻and O𝐿, containing all heavy and light output tuples sepa-
rately. In the preprocessing phase, our goal is to materialize all
heavy output tuples (O𝐻) ordered by rank. Details are described
in Algorithm 4. We compute O𝐻= 𝜋A

𝑅𝐻
1 Z 𝑅𝐻
2 Z · · · Z 𝑅𝐻𝑚

by invoking the Yannakakis algorithm [70], and then sort O𝐻by
rank. Next, we insert the smallest query result from O𝐻into the
priority queue. Then, we define 𝑚different subqueries as 𝑄𝑖=
𝜋A

𝑅𝐻
1 Z · · · Z 𝑅𝐻
𝑖−1 Z 𝑅𝐿
𝑖Z 𝑅𝑖+1 Z · · · Z 𝑅𝑚

where tuples in
relation 𝑅𝑗are heavy for any 𝑗< 𝑖and tuples in relation 𝑅𝑖are
light. For such 𝑄𝑖, we consider a join tree T𝑖in which 𝑅𝑖is the
root and all other relations are children of 𝑅𝑖. We preprocess a data
structure for 𝑄𝑖with T𝑖, by invoking Algorithm 1.
Enumeration Phase. As described in Algorithm 5, the high-level
idea in the enumeration is to perform a (𝑚+1)-way merge over O𝐻
and 𝑄𝑖’s. Specifically, we maintain a priority queue PQ with one
entry for each subquery 𝑄𝑖and one entry for O𝐻. Once the smallest
element is extracted from PQ (say 𝑡generated by 𝑄𝑖), we extract
the next smallest candidate from 𝑄𝑖(if there is any) and insert it
into PQ. Moreover, finding the smallest candidate output result
from O𝐻is trivial since O𝐻have been materialized in a sorted way
in the preprocessing phase. We conclude this subsection with the
formal statement of the result.
Algorithm 5: EnumStar
Input
:Star query 𝑄★𝑚, ranking function rank and
database 𝐷; Output of O𝐻and priority queue PQ
Output:𝑄★𝑚(𝐷) in ranked order
1 while PQ ≠∅do
2
𝑡←PQ.pop();
3
output 𝑡;
/* enumerate the result */
4
if 𝑡∉O𝐻then
5
𝑖←smallest positive index such that 𝜋𝐴𝑗(𝑡) is
heavy for all 𝑗< 𝑖and 𝜋𝐴𝑖(𝑡) is light;
6
next ←EnumAcyclic(𝑄𝑖, T𝑖);
7
PQ.insert(next);
8
else PQ.insert(O𝐻.pop());
Lemma 5. Algorithm 4 runs in time 𝑇= 𝑂(|𝐷| · (|𝐷|/𝛿)𝑚−1) and
requires space 𝑆= 𝑂((|𝐷|/𝛿)𝑚). Algorithm 5 correctly enumerates
the result of the query in ranked order with delay 𝑂(|𝐷| log |𝐷|/𝛿).
4.2
Tradeoff Optimality
We next present conditional optimality for our tradeoff achieved in
Theorem 2. Before showing the proof, we first revisit a result on
unranked evaluation for 𝑄★𝑚in [8]:
Lemma 6 ([8]). There exists a combinatorial1 algorithm that can
evaluate 𝑄★𝑚on any database 𝐷in time 𝑂

|𝐷| · |𝑄★𝑚(𝐷)|1−1
𝑚

.
This result was presented over a decade ago without any im-
provement since then. Thus, it is not unreasonable to conjecture
that Lemma 6 is optimal. Based on its conjectured optimality, we
can show the following result for unranked enumeration.
Lemma 7. Consider star query 𝑄★𝑚, database 𝐷and some constant
𝜖∈[0, 1]. If there exists an algorithm that supports𝑂(|𝐷|1−𝜖log |𝐷|)-
delay enumeration after 𝑂(|𝐷|1+(𝑚−1)𝜖−𝜖′) preprocessing time for
some constant 𝜖′ > 0, the optimality of Lemma 6 will be broken.
The lower bound holds for any ranking function. Lemma 7 im-
plies that for star queries, both Theorem 1 and Theorem 2 are
optimal. Before concluding this section, we also remark on the
question of whether the logarithmic factor that we obtain in the
delay guarantee is removable. Prior work [26] showed that for the
following simple join query 𝑄= 𝑅(𝑥) Z 𝑆(𝑦) over SUM, there
exists no algorithm supporting constant-delay enumeration after
linear preprocessing time. Note that this does not rule out a sub-
logarithmic delay guarantee, which remains an open problem.
5
GENERAL QUERIES
In this section, we will describe how to extend the algorithm for
acyclic queries to handle cyclic queries. The key idea is to transform
the cyclic query into an acyclic one, by constructing a GHD as
defined in Section 2. A GHD automatically implies an algorithm
for cyclic joins. After materializing the results of the subquery
induced by each node in the decomposition, the residual query
1An algorithm is called combinatorial if it does not use algebraic techniques such as
fast matrix multiplication.
7

---

becomes acyclic. Hence, we can apply our algorithm for acyclic
queries directly obtaining the following:
Theorem 3. For a join-project query 𝑄, a database instance 𝐷and
a ranking function rank ∈{SUM, LEXICOGRAPHIC}, the query results
𝑄(𝐷) can be enumerated according to rank with 𝑂(|𝐷|fhw log |𝐷|)
delay, after 𝑂(|𝐷|fhw log |𝐷|) preprocessing time.
We now go one step further and extend our algorithm to queries
that are unions of join-project queries (UCQs) using an idea intro-
duced by [26, 65]. A UCQ query is of the form𝑄= 𝑄1∪𝑄2∪· · ·∪𝑄𝑚,
where each 𝑄𝑖is a join-project query defined over the same projec-
tion attributes A. Semantically, 𝑄(𝐷) = Ð
𝑖𝑄𝑖(𝐷). Recent work by
Abo Khamis et al. [5] presents an improved algorithm (called PANDA)
that constructs multiple GHDs by partitioning the input database
into disjoint pieces and build a GHD for each piece. In this way,
the size of materialized subquery can be bounded by 𝑂(|𝐷|subw),
where subw is the submodular width [52] of input query 𝑄. More-
over, subw ≤fhw holds generally for query 𝑄, thus improving the
previous result on fhw. By using Theorem 1 in conjunction with
data-dependent decompositions from PANDA we can immediately
obtain the following result:
Theorem 4. For a join-project query 𝑄, a database instance 𝐷and
a ranking function rank ∈{SUM, LEXICOGRAPHIC}, the query results
𝑄(𝐷) can be enumerated according to rank with 𝑂(|𝐷|subw log |𝐷|)
delay, after 𝑂(|𝐷|subw log |𝐷|) preprocessing time.
Example 6. Consider the 4-cycle (butterfly) query 𝜋𝐴,𝐶(𝑅1(𝐴, 𝐵) Z
𝑅2(𝐵,𝐶) Z 𝑅3(𝐶, 𝐷) Z 𝑅4(𝐷,𝐴)) with ranking function rank(𝑡) =
𝜋𝐴(𝑡) + 𝜋𝐶(𝑡). With fhw = 2, Theorem 4 implies that the query
results can be enumerated according to rank with 𝑂(|𝐷|2 log |𝐷|)
delay, after 𝑂(|𝐷|2) preprocessing time. With subw = 3
2, Theorem 4
implies that query results can be enumerated according to rank with
delay 𝑂(|𝐷|3/2 log |𝐷|), after 𝑂(|𝐷|3/2 log |𝐷|) preprocessing time.
A note on optimality. The reader may wonder whether the expo-
nent of fhw and subw in Theorem 3 and Theorem 4 are truly neces-
sary. For the triangle query 𝑄△(𝑥,𝑦) = 𝑅(𝑥,𝑦) Z 𝑆(𝑦,𝑧) Z 𝑇(𝑧,𝑥)
which is the simplest cyclic query, fhw = subw = 3/2 and even after
30 years, the original AYZ algorithm [7] that detects the existence
of a triangle in 𝑂(|𝐷|3/2) time still remains the best known combi-
natorial algorithm. It is widely conjectured [2, 3, 42, 53] that there
exists no better algorithm. As noted in [5], the notion of submod-
ular width was suggested as the yardstick for optimality. Indeed,
the groundbreaking results by Marx [52] rules out algorithms with
better dependence than subw in the exponent for a small of class of
queries but a general unconditional lower bound still remains out of
reach. Thus, any improvement in the exponent would automatically
imply a better algorithm for cycle detection since ranked enumer-
ation is at least as hard. In Appendix F, we formally show that
the exponential dependence of subw in Theorem 4 is unavoidable
subject to popular conjectures.
6
EXPERIMENTAL EVALUATION
In this section, we perform an extensive evaluation of our pro-
posed algorithm. Our goal is to evaluate three aspects: (𝑎) how fast
our algorithm is compared to state-of-the-art implementations for
both SUM and LEXICOGRAPHIC ranking functions on various queries
and datasets, (𝑏) test the empirical performance of the space-time
tradeoff in Theorem 2, (𝑐) investigate the performance of our algo-
rithm on various cyclic queries based on different shapes and (𝑑)
test the scalability behavior of our algorithm.
6.1
Experimental Setup
We use Neo4j 4.2.3 community edition, MariaDB 10.1.472 and Post-
greSQL 11.12 for our experiments. All experiments are performed
on a Cloudlab machine [27] running Ubuntu 18.04 equipped with
two Intel E5-2630 v3 8-core CPUs@2.40 GHz and 128 GB RAM. We
focus only on the main memory setting and all experiments run
on a single core. Since the join queries are memory intensive, we
take special care to ensure that only one DBMS engine is running
at a time, restart the session for each query to ensure temp tables
in main memory are flushed out to avoid any interference, and also
monitor that no temp tables are created on the disk. We only keep
one database containing a single relation when performing experi-
ments. We switch off all logging to avoid any performance impact.
For PostgreSQL and MariaDB, we allow the engines to use the full
main memory to ensure all temp tables are resident in the RAM
and sorting (if any) happens without any disk IOs by increasing the
sort buffer limit. For Neo4j, we allow the JVM heap to use the full
main memory at the time of start up. We also build bidirectional
B-tree indexes for each relation ahead of time and create named
indexes in Neo4j. All of our algorithms are implemented in C++
and compiled using the GNU C++ 7.5.0 compiler that ships with
Ubuntu 18.04. Each experiment is run 5 times and we report the
median after removing the slowest and the fastest run.
6.1.1
Small-Scale Datasets. We use two real world small scale
datasets for our experiments: the DBLP dataset, containing relation-
ship between authors and papers, and the IMDB dataset, containing
relationship between actors, directors, and movies. We use these
datasets for two reasons: (𝑖) both datasets have been found to
be useful and studied extensively in practical problems such as
similarity search [71], citation graph analysis [59], and network
analysis [14, 28]. (𝑖𝑖) small-scale datasets allow experiments to
finish for all systems allowing us to make a fair comparison and
develop a fine-grained understanding. In line with prior work [40],
for each tuple we assign the weight attribute (and add it to the table
schema) in two ways: first, we assign a randomly chosen value,
and second, logarithmic weights in which the weight of the entity
(author and paper in DBLP) 𝑣is log2(1 +𝑑𝑒𝑔𝑣), where 𝑑𝑒𝑔𝑣denotes
its degree in the relation. The schema for both datasets is as shown
below (underlined attributes are primary keys for the relation):
(1) DBLP: AuthorPapers(𝑎𝑖𝑑, 𝑝𝑖𝑑), Author(𝑎𝑖𝑑,𝑛𝑎𝑚𝑒,𝑤𝑒𝑖𝑔ℎ𝑡),
Paper(𝑎𝑖𝑑,𝑡𝑖𝑡𝑙𝑒, 𝑣𝑒𝑛𝑢𝑒,𝑦𝑒𝑎𝑟,𝑤𝑒𝑖𝑔ℎ𝑡,𝑖𝑠_𝑟𝑒𝑠𝑒𝑎𝑟𝑐ℎ).
(2) IMDB: PersonMovie(𝑝𝑖𝑑,𝑚𝑖𝑑), Company(𝑐𝑖𝑑,𝑛𝑎𝑚𝑒,𝑛𝑎𝑡𝑖𝑜𝑛),
Person(𝑝𝑖𝑑,𝑛𝑎𝑚𝑒,𝑟𝑜𝑙𝑒,𝑤𝑒𝑖𝑔ℎ𝑡),
Movie(𝑚𝑖𝑑,𝑛𝑎𝑚𝑒,𝑦𝑒𝑎𝑟,𝑔𝑒𝑛𝑟𝑒,𝑐𝑖𝑑,𝑤𝑒𝑖𝑔ℎ𝑡)
Queries. We consider 4 acyclic join queries as shown in Figure 4
for the small-scale datasets, which are commonly seen in prac-
tice [15, 63]. Intuitively, the first three queries find all the top-k
weighted 2-hops, 3-hops and 4-hops reachable attribute pairs within
2Compared with MySQL, MariaDB performed better in our experiments, hence we
report the results for MariaDB
8

---

DBLP2hop = SELECT DISTINCT A1.name, A2.name FROM Author AS A1, Author AS A2, AuthorPapers AS AP1, AuthorPapers as AP2,
Paper AS P WHERE AP1.pid = AP2.pid AND AP1.aid = A1.aid AND AP2.aid = A2.aid AND P.is_research =true ORDER BY
A1.weight + A2.weight LIMIT k;
DBLP3hop = SELECT DISTINCT A.name, P.name FROM Author AS A, Paper AS P, AuthorPapers AS AP1, AuthorPapers as AP2,
AuthorPapers as AP3 WHERE AP1.pid = AP2.pid AND AP2.aid = AP3.aid AND AP1.aid = A.aid AND AP3.pid = P.pid AND P.is_research =
true ORDER BY A.weight + P.weight LIMIT k;
DBLP4hop = SELECT DISTINCT A1.name, A2.name FROM Author AS A1, Author AS A2, AuthorPapers AS AP1, AuthorPapers as AP2,
AuthorPapers as AP3, AuthorPapers as AP4, Paper AS P1, Paper AS P2 WHERE AP1.pid = AP2.pid AND AP2.aid = AP3.aid AND
AP3.pid = AP4.pid AND AP3.pid = P2.pid AND AP1.pid = P1.pid AND AP1.aid = A1.aid AND AP4.aid = A2.aid AND P1.is_research =true
AND P2.is_research =true ORDER BY A1.weight + A2.weight LIMIT k;
DBLP3star = SELECT DISTINCT A1.name, A2.name, A3.name FROM Author AS A1, Author AS A2, Author AS A3, AuthorPapers AS AP1,
AuthorPapers as AP2, AuthorPapers as AP3, Paper AS P WHERE AP1.pid = AP2.pid = AP3.pid AND AP1.aid = A1.aid AND
AP2.aid = A2.aid AND AP3.aid = A3.aid AND AP3.pid = P.pid AND P.is_research =true ORDER BY A1.weight + A2.weight + A3.weight
LIMIT k;
Figure 4: Network analysis queries for DBLP. Queries for IMDB are defined similarly (see [25]).
the DBLP network. As remarked by in [19, 43, 63], these queries
are of immense practical interest (e.g., see Table 4 in [63]). Queries
for IMDB dataset are defined similarly in Appendix G. In Subsec-
tion 6.2.2, we also investigate the performance for cyclic queries.
6.1.2
Large-Scale Datasets. We also perform experiments on two
real-world large scale relational datasets and one relational bench-
mark. The first dataset is from the Friendster [46] online social
network that contains 1.8𝐵tuples. In the social network each, user
is associated with multiple groups. The second dataset is the Meme-
tracker [46] dataset which describes user generated memes and
which users have interacted with the meme. The dataset contains
418𝑀tuples. For both Friendster and Memetracker, we use weights
for users as the number of groups they belong to and the num-
ber of memes they create respectively. Finally, we also use the
queries containing a ranking function from the LDBC Social Net-
work Benchmark [29] with scale factor SF = 10, a publicly available
benchmark, to perform scalability experiments.
Queries. For Friendster and Memetracker, we use two popular
queries that are used in network analysis. Similar to the DBLP
queries, we identify the ranked user pairs in the two hop and three
hop neighborhoods for all users. The ranking is the sum of weights
of the user pair. These queries have widespread application in
understanding information flow in a network [54] and are used in
recommendation systems [32, 49]. For LDBC benchmark, we use
the multi-source version of Q3, Q10 and Q11. Each of these queries
are variants of the neighborhood analysis and contains UNION.
6.2
Small Scale Experiments
In this section, we compare the empirical performance of the al-
gorithm given by Theorem 1 (labeled as LinDelay in all figures)
against the baselines for each query. In order to perform a fair com-
parison, we materialize the top-𝑘answers in-memory since other
engines also do it. However, a strength of our system is that if a
downstream task only requires the output as a stream, we are able
to enumerate the result instead of materializing it, which is not
possible with other engines.
Sum ordering. Figure 5 shows the main results for the DBLP and
IMDB datasets when the ranking function is the sum function
and the weights are chosen randomly. Let us first review the re-
sults for the DBLP dataset. Figure 5a shows the running time for
different values of 𝑘in the limit clause. The first observation is
that all engines materialize the join result, followed by dedupli-
cating and sorting according to the ranking function which leads
to poor performance for all baselines. This is because all engines
treat sorting and distinct clause as blocking operators, verified by
examining the query plan. On the other hand, our approach is limit-
aware. For small values of 𝑘, we are up to two orders of magnitude
faster and as the value of 𝑘increases, the total running time of
our algorithm increases linearly. Even when our algorithm has to
enumerate and materialize the entire result, it is still faster than
asking the engines for the top-10 results. This is a direct benefit
of generating the output in deduplicated and ranked order. As the
path length increases from two to three and four path (Figure 5b
and Figure 5c), the performance gap between existing engines and
our approach also becomes larger. We also point out that all en-
gines require a large amount of main memory for query execution.
For example, MariaDB requires about 40GB of memory for exe-
cuting DBLP4hop. In contrast, the space overhead of our algorithm
is dominated by the size of the priority queue. For DBLP dataset,
our approach requires a measly 1.3GB, 4GB, 3GB and 2.7GB total
space for DBLP2hop, DBLP3hop, DBLP4hop and DBLP3star respec-
tively. For DBLP3hop, DBLP4hop and DBLP3star, we also implement
breadth first search (BFS) followed by a sorting step using the idea
of Algorithm 3. As it can be seen from the figures, BFS and sort pro-
vides an intermediate strategy which is faster than our algorithm
for large values of 𝑘but at the cost of expensive materialization
of the entire result, which may not be always possible (and is the
case for IMDB dataset). However, deciding to use BFS and sort
requires knowledge of the output result size, which is unknown
apriori and difficult to estimate. For the IMDB dataset, we observe
a similar trend of our algorithm displaying superior performance
compared to all other baselines. In this case, BFS and sorting even
for DBLP4hop is not possible since the result is almost 0.5 trillion
items. For DBLP3star, none of the engines were able to compute
9

---

the result after running for 5 hours when main memory ran out.
BFS and sort also failed due to the size being larger than the main
memory limit. Lastly, Neo4j was consistently the best performing
(albeit marginally) engine among all baselines. While there is little
scope for rewriting the SQL queries to try to obtain better perfor-
mance, Neo4j has graph-specific operators such as variable length
expansion. We tested multiple rewritings of the query to obtain the
best performance (although this is the job of the query optimizer),
which is finally reported in the figures. Regardless of the rewritings,
Neo4j still treats materializing and sorting as a blocking operator
which is a fundamental bottleneck.
Lexicographic ordering. Figures 6a,6b,6c and 6d show the run-
ning time for different values of 𝑘in the limit clause for lexico-
graphic ranking function on DBLP (i.e. we replace A1.weight +
A2.weight with A1.weight, A2.weight in the ORDER BY clause) for
random weights. The first striking observation here is that the
running time for all baseline engines is identical to that of sum
function. This demonstrates that existing engines are also agnostic
to the ranking function in the query and fail to take advantage
of the additional structure. However, lexicographic functions are
easier to handle in practice than sum because we can avoid the use
of a priority queue altogether. This in turn leads to faster running
time since push and pops from the priority queue are expensive
due to the logarithmic overhead and need for re-balancing of the
tree structure. Thus, we obtain a 2× improvement for lexicographic
ordering as compared to the sum function.
Join ordering. At this point, the reader may wonder what is the
impact of different join orderings on the query execution time for
DBMS engines in the presence of ORDER BY. To investigate this, we
supply join order hints to each of the engines. We run the queries
on all possible join order hints to find the best possible running
time. We found that the join order hints had virtually no impact on
execution time. For instance, DBLP4hop on Neo4J takes 5521.61𝑠
without any join hints and the best possible join ordering reduces
the time to 5418.23𝑠, a mere 1.8% reduction. This is not surprising
since the bottleneck for all engines is the materialization of the
unsorted output, which is orders of magnitude larger than the final
output and ends up being the dominant cost. In fact, for queries
containing only self-joins, join order hints do not have any impact
on the query plan because all relations are identical. Further, the
number of possible join orderings that may need to be explored
is exponential in the number of relations. On the other hand, our
algorithm has the advantage of bypassing the materialization due
to the delay based problem formulation and use of multi-way joins.
Logarithmic weights. Instead of choosing the weights randomly,
we also investigate the behavior when the weights scale logarithmi-
cally w.r.t. to the degree. We observed that all systems as well as our
algorithm had identical execution times. This is not surprising con-
sidering that no algorithm takes into account the actual distribution
of the weights. This observation points to an additional opportunity
for optimization where one could use the weight distribution to
allow for fine-grained, data-dependent processing. We leave the
study of this problem for future work.
6.2.1
Enumeration with Preprocessing. We next investigate the em-
pirical performance of the preprocessing step and its impact on the
result enumeration as described by Theorem 2. For all experiments
in this section, we fix 𝑘to be large enough to enumerate the entire
result (which is equivalent to having no limit clause at all).
Sum ordering. Figure 7a and Figure 7b show the tradeoff between
space used by the data structure constructed in the preprocessing
phase and running time of the enumeration algorithm for DBLP2hop
and IMDB2hop repectively. We show the tradeoff for 6 different
space budgets but the user is free to choose any space budget in
the entire spectrum. As expected, the time required to enumerate
the result is large when there is no preprocessing and it gradually
drops as more and more results are materialized in the preprocess-
ing phase. The sum of preprocessing time and enumeration time
is not a flat line: this is because as an optimization, we do not use
priority queues in the preprocessing phase. Instead, we can simply
use the BFS and sort algorithm for all chosen nodes which need to
be materialized. This is a faster approach in practice as we avoid use
of priority queues but priority queues cannot be avoided for enu-
meration phase. We observe similar trend for DBLP3star, IMDB3star
on both datasets as well.
6.2.2
Cyclic Queries. We also compare the performance of our
algorithm to other systems for cyclic queries. We choose four cyclic
queries found commonly in practice inspired by [65]: four cycle, six
cycle, eight cycle and bowtie query (two four cycles joined at a com-
mon attribute). Figure 10 shows the performance of our algorithm
on the DBLP dataset for the sum function. As the table shows, our
algorithm is able to process all queries within 200 seconds, with the
bowtie query being the most computationally intensive. In contrast,
for 𝑘= 10 the fastest performing engine Neo4J required 240s (450s)
for four cycle (six cycle). It did not finish execution for eight cycle
and bowtie query due to an out of memory error. For the IMDB
dataset, our algorithm was able to process all queries, while Neo4J
was not able to process any query (except four cycle) due to its large
memory requirement. We defer those experiments to Appendix G.
6.3
Large Scale Experiments and Scalability
In this section, we investigate the performance of our techniques
on the large scale datasets. Figure 8a and 8b shows the time to find
the top-𝑘answers for the Memetracker dataset on two neighbor-
hood and three neighborhood queries. Compared to the small scale
datasets, the execution time increases rapidly even for low values
of 𝑘. This is attributed to the high duplication of answers, which
leads to a rapidly increasing priority queue size. None of MariaDB,
Postgres and Neo4J were able to finish, or even to find the top-10
answers, within 5 hours in our experiments. The same trend is also
observed for the Friendster dataset as shown in Figure 8d and 8c.
Similar to the small-scale datasets, lexicographic functions were
faster than the sum function for our algorithm but DBMS engines
were unable to finish query execution. We also conduct scalability
experiments on LDBC benchmark queries that contain the ORDER
BY clause. Figure 9 shows the scalability of our algorithm for finding
answers of queries Q3, Q10, Q11. As the scale factor increases, the
execution time also increases linearly. For each of these queries,
all engines require more than 3 hours to compute the result even
for SF = 10 and 𝑘= 10. This is because of the serial execution
plan generated by the engines, forcing the materialization of the
unsorted result before sorting and filtering for top-𝑘.
10

---

101
102
103
104
105
106 3.3 · 107
k in limit clause
10−1
100
101
Time in sec.
(a) DBLP2hop
101
102
103
104
105
106
5 · 107
k in limit clause
100
101
102
Time in sec.
MariaDB
PostgreSQL
Neo4J
LINDELAY
BFS and sort
(b) DBLP3hop
102
103
104
105
106
107
1.5 · 108
k in limit clause
100
101
102
103
Time in sec.
(c) DBLP4hop
101
102
103
104
105
106 6 · 107
k in limit clause
10−1
100
101
102
Time in sec.
(d) DBLP3star
102
103
104
105
106
107 1.8 · 108
k in limit clause
100
101
102
Time in sec.
(e) IMDB2hop
102
103
104
105
106
107 7.6 · 108
k in limit clause
101
102
103
Time in sec.
(f) IMDB3hop
102
103
104
105
106
107
108
k in limit clause
101
102
Time in sec.
(g) IMDB4hop
102
103
104
105
106
k in limit clause
100
101
102
Time in sec.
(h) IMDB3star
Figure 5: Comparing our algorithm with state-of-the-art engines for sum function
101
102
103
104
105
106 3.3 · 107
k in limit clause
10−1
100
101
Time in sec.
(a) DBLP2hop
101
102
103
104
105
106
5 · 107
k in limit clause
10−1
100
101
102
Time in sec.
(b) DBLP3hop
102
103
104
105
106
107 1.5 · 108
k in limit clause
100
101
102
103
Time in sec.
(c) DBLP4hop
101
102
103
104
105
106
6 · 107
k in limit clause
100
101
Time in sec.
(d) DBLP3star
Figure 6: Comparing our linear delay algorithm with state-of-the-art engines for lexicographic function.
396
193
41
7
3
0.1
Extra Space used in MB
0.0
0.5
1.0
1.5
2.0
2.5
3.0
Time in sec.
(a) DBLP2hop
0.01
0.10
1.00
10.00
Extra Space used in GB
0
20
40
60
80
100
120
Time in sec.
Preprocessing Time
Enumeration Time
Total Time
(b) IMDB2hop
5300
1966
677
94
1
0.1
Extra Space used in MB
0
20
40
60
80
100
120
Time in sec.
(c) DBLP3star
96
50
25
10
5
0
Extra Space used in GB
0
200
400
600
800
1000
1200
Time in sec.
(d) IMDB3star
Figure 7: Comparing the preprocessing and enumeration tradeoff for sum function when enumerating the entire result
101
102
103
104
k in limit clause
30
35
40
45
50
55
60
65
70
Time in sec.
(a) Memetracker 2-neighborhood
101
102
103
104
k in limit clause
102
103
Time in sec.
(b) Memetracker 3-neighborhood
101
102
103
104
k in limit clause
50
60
70
80
90
100
Time in sec.
(c) Friendster 2-neighborhood
101
102
103
104
k in limit clause
101
102
103
Time in sec.
(d) Friendster 3-neighborhood
Figure 8: LinDelay performance on large-scale datasets
11

---

SF = 10
SF = 20
SF = 30
SF = 40
SF = 40
Q3
5.91s
9.63s
13.47s
18.23s
22.18s
Q10
2.82s
3.47s
4.65s
5.23s
6.46s
Q11
0.78s
1.07s
1.56s
1.82s
2.36s
Figure 9: Scalability for different scale factors (SF) in LDBC
k = 10
k = 102
k = 103
k = 104
four cycle
0.85s
0.95s
1.2s
1.8s
six cycle
13.1s
17.7s
25.6s
38.2s
eight cycle
33.4s
48.7s
63.9s
77.8s
bowtie
112s
125s
156s
192s
Figure 10: Cyclic query performance on the DBLP dataset
for different values of 𝑘in the LIMIT clause.
7
RELATED WORK
Top-𝑘. Top-k ranked enumeration of full join queries has been
studied extensively by the database community for both certain [6,
13, 37, 38, 47, 48, 58, 64] and uncertain databases [60, 72]. Most of
these works exploit the monotonicity property of scoring functions,
building offline indexes and integrate the function into the cost
model of the query optimizer in order to bound the number of op-
erations required per answer tuple. We refer the reader to [37] for a
comprehensive survey. We note that none of these works consider
non-trivial join-project queries (see Appendix A for more discus-
sion). Ours is the first work to consider the ranked enumeration of
arbitrary join-project queries.
Rank aggregation algorithms. Top-k processing over ranked
lists of objects has a rich history. The problem was first studied by
Fagin et al. [30, 31] where the database consists of 𝑁objects and 𝑚
ranked streams, each containing a ranking of the 𝑁objects with
the goal of finding the top-𝑘results for coordinate monotone func-
tions. The authors proposed Fagin’s algorithm (FA) and Threshold
algorithm (TA), both of which were shown to be instance optimal
for database access cost under sorted list access and random access
model. A key limitation of these works is that it expects the input
to be materialized, i.e., 𝑄(𝐷) must already be computed and stored
for the algorithm to perform random access.
Unranked enumeration of query results. Recent work by Kara
et al. [39] showed that for a small but important fragment of CQs
known as hierarchical queries, it is possible to obtain a tradeoff be-
tween preprocessing and delay guarantees. Importantly, this result
is applicable even in the presence of arbitrary projection. However,
the authors did not investigate how to add ranking because adding
priority queues at different location in the join tree leads to dif-
ferent complexities. In fact, follow up work [24] showed that the
same unranked enumeration could be performed with better delay
guarantees under certain settings. Our work considers the class of
CQs with arbitrary projections and we are also able to extend the
main result to UCQs, an even broader class of queries. Naturally,
our algorithm automatically recovers the existing results for full
CQs as well [26, 65], in addition to the first extensive empirical
evidence on how ranked enumeration can be performed for CQs
containing projections beyond free-connex queries.
Factorization and Aggregation. Factorized databases [12, 21, 56]
exploit the distributivity of product over union to represent query
results compactly and generalize the results on bounded fhwto
the non-Boolean case [56]. [4] captures a wide range of aggre-
gation problems over semirings. Factorized representations can
also enumerate the query results with constant delay according to
lexicographic orders of the variables [11]. For that to work, the lexi-
cographic order must "agree" with the factorization order. However,
it was shown in [26] that the algorithm for lexicographic ordering
is not optimal. Further, since all prior work in this space using the
concept of variable ordering, adding projections to the query forces
the building of a GHD that can materialize the entire join query
result, which is expensive and an unavoidable drawback.
Ranked enumeration. Both Chang et al. [18] and Yang et al. [69]
provide any-𝑘algorithms for graph queries instead of the more
general CQs; Kimelfeld and Sagiv [41] give an any-𝑘algorithm for
acyclic queries with polynomial delay. Recent work on ranked enu-
meration of MSO logic over words is also of particular interest [16].
None of these existing works give any non-trivial guarantees for
CQs with projections. Ours is the first work in this space that pro-
vides non-trivial guarantees.
8
CONCLUSION
In this paper, we study the problem of ranked enumeration for
CQs with projections. We present a general algorithm that can
enumerate query results according to two commonly-used ranking
functions (SUM, LEXICOGRAPHIC) with near-linear delay after near-
linear preprocessing time. We also show how to extend our results
to a broader class of queries known as UCQs. For star queries, an
important and practical fragment of CQs, we further show how to
achieve a smooth tradeoff between the delay, preprocessing time
and space used for data structure. Extensive experiments demon-
strate that our methods are up to three orders of magnitude better
when compared to popular open-source RDBMS and specialized
graph engines. This work opens up several exciting future work
challenges. The first important problem is to extend our results
from main memory setting to the distributed setting. Since the cost
of I/O must also be taken into account, it becomes important to
identify the optimal priority queue storage layout to ensure that
access cost is low. It would also be interesting to develop output bal-
anced algorithms. The second exciting challenge is to incorporate
approximation into the ranking. For some applications, it may be
sufficient to get an approximately ordered output which could lead
to improved running time guarantees. Finally, it would be useful to
re-rank the query results when the ranking function is changed by
the user and extend our ideas to non-monotone ranking functions.
Acknowledgments. This research was supported in part by Na-
tional Science Foundation grants CRII-1850348 and III-1910014. We
would like to thank the anonymous reviewers for their careful read-
ing and valuable comments that contributed greatly in improving
the manuscript. We also thank Wim Martens for the reference [15]
that motivates the study of star queries.
12

---

REFERENCES
[1] Amir Abboud, Arturs Backurs, and Virginia Vassilevska Williams. 2018. If the
current clique algorithms are optimal, so is Valiant’s parser. SIAM J. Comput. 47,
6 (2018), 2527–2555.
[2] Amir Abboud and Virginia Vassilevska Williams. 2014. Popular conjectures imply
strong lower bounds for dynamic problems. In 2014 IEEE 55th Annual Symposium
on Foundations of Computer Science. IEEE, 434–443.
[3] Amir Abboud, Virginia Vassilevska Williams, and Huacheng Yu. 2018. Matching
triangles and basing hardness on an extremely popular conjecture. SIAM J.
Comput. 47, 3 (2018), 1098–1122.
[4] Mahmoud Abo Khamis, Hung Q Ngo, and Atri Rudra. 2016. FAQ: questions asked
frequently. In Proceedings of the 35th ACM SIGMOD-SIGACT-SIGAI Symposium
on Principles of Database Systems. 13–28.
[5] Mahmoud Abo Khamis, Hung Q Ngo, and Dan Suciu. 2017. What do Shannon-
type Inequalities, Submodular Width, and Disjunctive Datalog have to do with
one another?. In Proceedings of the 36th ACM SIGMOD-SIGACT-SIGAI Symposium
on Principles of Database Systems. 429–444.
[6] Reza Akbarinia, Esther Pacitti, and Patrick Valduriez. 2011. Best position algo-
rithms for efficient top-k query processing. Information Systems 36, 6 (2011),
973–989.
[7] Noga Alon, Raphael Yuster, and Uri Zwick. 1994. Finding and counting given
length cycles. In European Symposium on Algorithms. Springer, 354–364.
[8] Rasmus Resen Amossen and Rasmus Pagh. 2009. Faster join-projects and sparse
matrix multiplications. In Proceedings of the 12th International Conference on
Database Theory. ACM, 121–126.
[9] Renzo Angles and Claudio Gutierrez. 2011. Subqueries in SPARQL. AMW 749
(2011), 12.
[10] Guillaume Bagan, Arnaud Durand, and Etienne Grandjean. 2007. On acyclic
conjunctive queries and constant delay enumeration. In International Workshop
on Computer Science Logic. Springer, 208–222.
[11] Nurzhan Bakibayev, Tomáš Kočisk`y, Dan Olteanu, and Jakub Závodn`y. 2013.
Aggregation and ordering in factorised databases. Proceedings of the VLDB
Endowment 6, 14 (2013), 1990–2001.
[12] Nurzhan Bakibayev, Dan Olteanu, and Jakub Závodn`y. 2012. FDB: A query
engine for factorised relational databases. Proceedings of the VLDB Endowment 5,
11 (2012), 1232–1243.
[13] Holger Bast, Debapriyo Majumdar, Ralf Schenkel, Christian Theobalt, and Ger-
hard Weikum. 2006. Io-top-k: Index-access optimized top-k query processing.
(2006).
[14] Maria Biryukov. 2008. Co-author network analysis in DBLP: Classifying personal
names. In International Conference on Modelling, Computation and Optimization
in Information Systems and Management Sciences. Springer, 399–408.
[15] Angela Bonifati, Wim Martens, and Thomas Timm. 2020. An analytical study of
large SPARQL query logs. The VLDB Journal 29, 2 (2020), 655–679.
[16] Pierre Bourhis, Alejandro Grez, Louis Jachiet, and Cristian Riveros. 2021. Ranked
enumeration of MSO logic on words. ICDT (2021).
[17] Nofar Carmeli and Markus Kröll. 2019. On the enumeration complexity of unions
of conjunctive queries. In Proceedings of the 38th ACM SIGMOD-SIGACT-SIGAI
Symposium on Principles of Database Systems. 134–148.
[18] Lijun Chang, Xuemin Lin, Wenjie Zhang, Jeffrey Xu Yu, Ying Zhang, and Lu Qin.
2015. Optimal enumeration: Efficient top-k tree matching. Proceedings of the
VLDB Endowment 8, 5 (2015), 533–544.
[19] Jinpeng Chen, Yu Liu, Guang Yang, and Ming Zou. 2018.
Inferring tag co-
occurrence relationship across heterogeneous social networks. Applied Soft
Computing 66 (2018), 512–524.
[20] Philipp Christmann, Rishiraj Saha Roy, and Gerhard Weikum. 2021. Efficient Con-
textualization using Top-k Operators for Question Answering over Knowledge
Graphs. arXiv preprint arXiv:2108.08597 (2021).
[21] Radu Ciucanu and Dan Olteanu. 2015. Worst-case optimal join at a time. Technical
Report. Technical report, Oxford.
[22] Olivier Corby and Catherine Faron-Zucker. 2007. Implementation of SPARQL
query language based on graph homomorphism. In International Conference on
Conceptual Structures. Springer, 472–475.
[23] Nilesh Dalvi and Dan Suciu. 2007. Efficient query evaluation on probabilistic
databases. The VLDB Journal 16, 4 (2007), 523–544.
[24] Shaleen Deep, Xiao Hu, and Paraschos Koutris. 2021. Enumeration Algorithms
for Conjunctive Queries with Projection. In 24th International Conference on
Database Theory (ICDT 2021). Schloss Dagstuhl-Leibniz-Zentrum für Informatik.
[25] Shaleen Deep, Xiao Hu, and Paraschos Koutris. 2022. Ranked Enumeration of
Join Queries with Projections. arXiv preprint arXiv:2201.05566 (2022).
[26] Shaleen Deep and Paraschos Koutris. 2021. Ranked Enumeration of Conjunctive
Query Results. In 24th International Conference on Database Theory.
[27] Dmitry Duplyakin, Robert Ricci, Aleksander Maricq, Gary Wong, Jonathon
Duerig, Eric Eide, Leigh Stoller, Mike Hibler, David Johnson, Kirk Webb, et al.
2019. The design and operation of CloudLab. In 2019 {USENIX} Annual Technical
Conference ({USENIX}{ATC} 19). 1–14.
[28] Ergin Elmacioglu and Dongwon Lee. 2005. On six degrees of separation in
DBLP-DB and more. ACM SIGMOD Record 34, 2 (2005), 33–40.
[29] Orri Erling, Alex Averbuch, Josep Larriba-Pey, Hassan Chafi, Andrey Gubichev,
Arnau Prat, Minh-Duc Pham, and Peter Boncz. 2015. The LDBC social net-
work benchmark: Interactive workload. In Proceedings of the 2015 ACM SIGMOD
International Conference on Management of Data. 619–630.
[30] Ronald Fagin. 2002. Combining fuzzy information: an overview. ACM SIGMOD
Record 31, 2 (2002), 109–118.
[31] Ronald Fagin, Amnon Lotem, and Moni Naor. 2003. Optimal aggregation al-
gorithms for middleware. Journal of computer and system sciences 66, 4 (2003),
614–656.
[32] Chenyuan Feng, Zuozhu Liu, Shaowei Lin, and Tony QS Quek. 2019. Attention-
based graph convolutional network for recommendation system. In ICASSP
2019-2019 IEEE International Conference on Acoustics, Speech and Signal Processing
(ICASSP). IEEE, 7560–7564.
[33] Michael L Fredman and Robert Endre Tarjan. 1987. Fibonacci heaps and their
uses in improved network optimization algorithms. Journal of the ACM (JACM)
34, 3 (1987), 596–615.
[34] Todd J Green, Shan Shan Huang, Boon Thau Loo, Wenchao Zhou, et al. 2013.
Datalog and recursive query processing. Now Publishers.
[35] Stephen Harris and Nigel Shadbolt. 2005. SPARQL query processing with conven-
tional relational database systems. In International Conference on Web Information
Systems Engineering. Springer, 235–244.
[36] John E Hopcroft, Jeffrey D Ullman, and AV Aho. 1975. The design and analysis
of computer algorithms.
[37] Ihab F Ilyas, George Beskales, and Mohamed A Soliman. 2008. A survey of top-k
query processing techniques in relational database systems. ACM Computing
Surveys (CSUR) 40, 4 (2008), 11.
[38] Ihab F Ilyas, Rahul Shah, Walid G Aref, Jeffrey Scott Vitter, and Ahmed K Elma-
garmid. 2004. Rank-aware query optimization. In Proceedings of the 2004 ACM
SIGMOD international conference on Management of data. ACM, 203–214.
[39] Ahmet Kara, Milos Nikolic, Dan Olteanu, and Haozhe Zhang. 2020. Trade-offs
in static and dynamic evaluation of hierarchical queries. In Proceedings of the
39th ACM SIGMOD-SIGACT-SIGAI Symposium on Principles of Database Systems.
375–392.
[40] Mehdi Kargar, Lukasz Golab, Divesh Srivastava, Jaroslaw Szlichta, and Morteza
Zihayat. 2020. Effective Keyword Search over Weighted Graphs. IEEE Transactions
on Knowledge and Data Engineering (2020).
[41] Benny Kimelfeld and Yehoshua Sagiv. 2006. Incrementally computing ordered an-
swers of acyclic conjunctive queries. In International Workshop on Next Generation
Information Technologies and Systems. Springer, 141–152.
[42] Tsvi Kopelowitz, Seth Pettie, and Ely Porat. 2016. Higher lower bounds from
the 3SUM conjecture. In Proceedings of the twenty-seventh annual ACM-SIAM
symposium on Discrete algorithms. SIAM, 1272–1287.
[43] Onur Küçüktunç, Erik Saule, Kamer Kaya, and Ümit V Çatalyürek. 2012. Recom-
mendation on academic networks using direction aware citation analysis. arXiv
preprint arXiv:1205.1143 (2012).
[44] Eugene L Lawler. 1972. A procedure for computing the k best solutions to
discrete optimization problems and its application to the shortest path problem.
Management science 18, 7 (1972), 401–405.
[45] Jyoti Leeka, Srikanta Bedathur, Debajyoti Bera, and Medha Atre. 2016. Quark-X:
An efficient top-k processing framework for RDF quad stores. In Proceedings of the
25th ACM International on Conference on Information and Knowledge Management.
831–840.
[46] Jure Leskovec and Andrej Krevl. 2014. SNAP Datasets: Stanford Large Network
Dataset Collection. http://snap.stanford.edu/data.
[47] Chengkai Li, Kevin Chen-Chuan Chang, Ihab F Ilyas, and Sumin Song. 2005.
RankSQL: query algebra and optimization for relational top-k queries. In Pro-
ceedings of the 2005 ACM SIGMOD international conference on Management of
data. ACM, 131–142.
[48] Chengkai Li, Mohamed A Soliman, Kevin Chen-Chuan Chang, and Ihab F Ilyas.
2005. RankSQL: supporting ranking queries in relational database management
systems. In Proceedings of the 31st international conference on Very large data
bases. VLDB Endowment, 1342–1345.
[49] Xiaoming Li, Hui Fang, and Jie Zhang. 2019. Supervised user ranking in signed
social networks. In Proceedings of the AAAI Conference on Artificial Intelligence,
Vol. 33. 184–191.
[50] Andrea Lincoln, Virginia Vassilevska Williams, and Ryan Williams. 2018. Tight
hardness for shortest cycles and paths in sparse graphs. In Proceedings of the
Twenty-Ninth Annual ACM-SIAM Symposium on Discrete Algorithms. SIAM, 1236–
1252.
[51] Stefan Manegold, Martin L Kersten, and Peter Boncz. 2009. Database architecture
evolution: Mammals flourished long before dinosaurs became extinct. Proceedings
of the VLDB Endowment 2, 2 (2009), 1648–1653.
[52] Dániel Marx. 2013. Tractable hypergraph properties for constraint satisfaction
and conjunctive queries. Journal of the ACM (JACM) 60, 6 (2013), 1–51.
[53] Dániel Marx. 2021. Modern Lower Bound Techniques in Database Theory and
Constraint Satisfaction. In Proceedings of the 40th ACM SIGMOD-SIGACT-SIGAI
Symposium on Principles of Database Systems. 19–29.
13

---

[54] Seth A Myers, Aneesh Sharma, Pankaj Gupta, and Jimmy Lin. 2014. Informa-
tion network or social network? The structure of the Twitter follow graph. In
Proceedings of the 23rd International Conference on World Wide Web. 493–498.
[55] Hung Q Ngo, Ely Porat, Christopher Ré, and Atri Rudra. 2012. Worst-case
optimal join algorithms. In Proceedings of the 31st ACM SIGMOD-SIGACT-SIGAI
symposium on Principles of Database Systems. ACM, 37–48.
[56] Dan Olteanu and Jakub Závodn`y. 2015. Size bounds for factorised representations
of query results. ACM Transactions on Database Systems (TODS) 40, 1 (2015),
1–44.
[57] Jorge Pérez, Marcelo Arenas, and Claudio Gutierrez. 2009. Semantics and com-
plexity of SPARQL. ACM Transactions on Database Systems (TODS) 34, 3 (2009),
1–45.
[58] Yan Qi, K Selçuk Candan, and Maria Luisa Sapino. 2007. Sum-max monotonic
ranked joins for evaluating top-k twig queries on weighted data graphs. In
Proceedings of the 33rd international conference on Very large data bases. VLDB
Endowment, 507–518.
[59] Erhard Rahm and Andreas Thor. 2005. Citation analysis of database publications.
ACM Sigmod Record 34, 4 (2005), 48–53.
[60] Christopher Re, Nilesh Dalvi, and Dan Suciu. 2007. Efficient top-k query eval-
uation on probabilistic data. In Data Engineering, 2007. ICDE 2007. IEEE 23rd
International Conference on. IEEE, 886–895.
[61] Luc Segoufin. 2015. Constant Delay Enumeration for Conjunctive Queries. SIG-
MOD Record 44, 1 (2015), 10–17. https://doi.org/10.1145/2783888.2783894
[62] Juan F Sequeda and Daniel P Miranker. 2013. Ultrawrap: SPARQL execution on
relational data. Journal of Web Semantics 22 (2013), 19–39.
[63] Yizhou Sun and Jiawei Han. 2013. Mining heterogeneous information networks:
a structural analysis approach. Acm Sigkdd Explorations Newsletter 14, 2 (2013),
20–28.
[64] Panayiotis Tsaparas, Themistoklis Palpanas, Yannis Kotidis, Nick Koudas, and
Divesh Srivastava. 2003. Ranked join indices. In Proceedings 19th International
Conference on Data Engineering (Cat. No. 03CH37405). IEEE, 277–288.
[65] Nikolaos Tziavelis, Deepak Ajwani, Wolfgang Gatterbauer, Mirek Riedewald, and
Xiaofeng Yang. 2020. Optimal algorithms for ranked enumeration of answers
to full conjunctive queries. In Proceedings of the VLDB Endowment. International
Conference on Very Large Data Bases, Vol. 13. NIH Public Access, 1582.
[66] Nikolaos Tziavelis, Deepak Ajwani, Wolfgang Gatterbauer, Mirek Riedewald, and
Xiaofeng Yang. 2020. Optimal Algorithms for Ranked Enumeration of Answers
to Full Conjunctive Queries. arXiv:1911.05582v3 [cs.DB]
[67] Nikolaos Tziavelis, Wolfgang Gatterbauer, and Mirek Riedewald. 2021. Beyond
Equi-joins: Ranking, Enumeration and Factorization. In Proceedings of the VLDB
Endowment. International Conference on Very Large Data Bases, Vol. 14. 2599–2612.
[68] Konstantinos Xirogiannopoulos and Amol Deshpande. 2017. Extracting and
Analyzing Hidden Graphs from Relational Databases. In Proceedings of the 2017
ACM International Conference on Management of Data. ACM, 897–912.
[69] Xiaofeng Yang, Deepak Ajwani, Wolfgang Gatterbauer, Patrick K Nicholson,
Mirek Riedewald, and Alessandra Sala. 2018. Any-k: Anytime Top-k Tree Pattern
Retrieval in Labeled Graphs. In Proceedings of the 2018 World Wide Web Confer-
ence on World Wide Web. International World Wide Web Conferences Steering
Committee, 489–498.
[70] Mihalis Yannakakis. 1981. Algorithms for acyclic database schemes. In VLDB,
Vol. 81. 82–94.
[71] Xiao Yu, Yizhou Sun, Brandon Norick, Tiancheng Mao, and Jiawei Han. 2012.
User guided entity similarity search using meta-path selection in heterogeneous
information networks. In Proceedings of the 21st ACM international conference on
Information and knowledge management. 2025–2029.
[72] Zhaonian Zou, Jianzhong Li, Hong Gao, and Shuo Zhang. 2010. Finding top-k
maximal cliques in an uncertain graph. (2010).
14

---

Algorithm 6: UseExistingAlgorithm
Input
:Join-project query 𝑄, ranking function SUM and database 𝐷
Output:𝑄(𝐷) in ranked order
1 𝑄′ ←full query obtained by dropping the projection operator from 𝑄
2 Provide 𝑄′, ranking function SUM that assigns weight zero to all values of attributes A \ A, and 𝐷to A for pre-processing;
3 last ←∅
4 while A.hasNext() do
5
𝑜←A.getNext()
/* enumerate the answer from A */
6
if last ≠𝑜[A] then
7
output 𝑜[A], last ←𝑜[A]
8 return
/* Enumeration complete */
A
OTHER ENUMERATION SEMANTICS
[66] discussed a more fine-grained approach to ranked enumeration over joins queries with projections. The goal is to enumerate the ranked
output 𝑄(𝐷) where 𝑄contains projections and the ranking function is defined over all the attributes (A). Since the weights are placed on
the attributes/relations and the output tuple 𝑡does not contain all the attributes, each answer could have multiple weights associated with
it. In this case, one option is to return 𝑡with the list of all the weights. Our algorithm for ranked enumeration can be extended to handle
this trivially. The second semantics identified is the min-weight-projection semantics. In this case, 𝑡is returned with the smallest possible
weight. [66] showed how their algorithm for full join can be extended to incorporate min-weight-projection semantics. We note here that
the results for projection queries in [66] can only handle acyclic free-connex queries, a restricted subclass of acyclic CQs (see Appendix E for
the definition). Further, in our problem formulation, the ranking function depends only on the projection attributes and not all the attributes.
B
USING EXISTING ALGORITHMS
Given a blackbox algorithm A for ranked enumeration of full join queries, we can obtain an algorithm for ranked enumeration of join-project
queries. Algorithm 6 shows how A can be used for enumeration of join-project queries. The key idea here is that A can assign a weight of
zero to all values of non-projection attributes. This will guarantee that tuples enumerated by A will be sorted only over the sum of attribute
values of A. The while loop contains a variable that stores the last tuple output A. This helps in ensuring that no duplicates are output for
the join-project query. Intuitively, Algorithm 6 is performing a ranked group by over the attributes A and outputs an answer when the
grouping value changes. We now show that there exist queries where the dealy for this algorithm could be large. Consider the query
𝑄= 𝜋𝑋1 (Z𝑖∈[ℓ] 𝑅𝑖(𝑋𝑖,𝑌))
.
Suppose that each relation 𝑅𝑖has 𝑁attribute value for 𝑋𝑖that is connected one 𝑌attribute value 𝑦★for each 𝑖∈{1, . . . , ℓ}. Then, the
smallest answer of 𝑄𝐷) will be output 𝑁ℓ−1 times by A on line 5. This is because the join of 𝑅2 Z · · · Z 𝑅ℓhas a size of 𝑁ℓ−1. This directly
implies that the delay guarantee is Ω(𝑁ℓ−1).
C
MISSING PROOFS
Lemma 1. The delay guarantee of EnumAcyclic is at most 𝑂(|𝐷| log |𝐷|).
Proof. In order to prove the delay guarantee, we analyze the worst-case running time that can happen in each iteration. Without loss of
generality, we assume that there exists at least one non-anchor projection attribute in all leaf nodes (otherwise, we can simply remove the
node from the join tree after the full reducer pass).
Let us first analyze the procedure Enum. The root priority queue (denoted PQ𝑟) can contain at most |𝐷| entries for each output result.
Indeed, in the worst-case, the output tuple emitted to the user on line 6 may join with every tuple in the root node relation. Therefore, in the
worst-case, for every tuple outputted to the user, we invoke the Topdown procedure |𝐷| times.
We now argue that Topdown takes at most 𝑂(|𝐷| log |𝐷|) time. There are two key observations to be made. First, Topdown takes 𝑂(1)
time if 𝑐.next is already populated. Intuitively, this means that in a previous iteration, there was a recursive call made to Topdown that
populated the next and we are now simply reusing the computation. Thus, for every tuple output to the user, it suffices to count how many
times Topdown is invoked in total, such that next is not empty. We say that such invocations of Topdown are non-trivial. Our claim is that
the number of non-trivial Topdown calls is at most 𝑂(|𝐷|). Consider the set of all anchor attribute values for some node 𝑗(denoted L𝑅𝑗).
We fix some 𝑢∈L𝑅𝑗. In the worst-case, Topdown(𝑐, 𝑗) such that 𝑢= 𝜋anchor(𝑅𝑗) (𝑐.𝑡) is invoked by all tuples 𝑡′ in the parent relation of
node 𝑗such that 𝜋anchor(𝑅𝑗) (𝑡′) = 𝑢but only the first call will be non-trivial since the first call populates the 𝑐.next. Therefore, it follows
that for each 𝑢∈L𝑅𝑗, there is at most one non-trivial call to Topdown(𝑐, 𝑅𝑗) for a fixed node 𝑅𝑗. Since the size of the join tree is at most
𝑂(1), the total number of non-trivial calls over all nodes in the join tree is Í
𝑗
Í
𝑢∈L𝑅𝑗1 = Í
𝑗|𝐷| = 𝑂(|𝐷|). Finally, we perform one pop
15

---

operation and a constant number of inserts into the priority queue in every non-trivial invocation which adds another log |𝐷| factor in the
running time, giving us the claimed delay guarantee of 𝑂(|𝐷| log |𝐷|).
□
Lemma 2. PreprocessAcyclic running in 𝑂(|𝐷| log |𝐷|) time, generates a data structure of size 𝑂(|𝐷|).
Proof. For a node 𝑅𝑖∈T, we initialize an empty priority queue for each possible value in anchor(𝑅𝑖). The for loop on line 7 takes 𝑂(1)
time as each node has 𝑂(1) children in the decomposition and all operations on line 8-12 also take 𝑂(log |𝐷|) time. Overall, since each node
has at most 𝑂(|𝐷|) tuples, the claim readily follows.
□
Lemma 3. EnumAcyclic enumerates the query result 𝑄(𝐷) in ranked order correctly.
Proof. We will prove our claim by induction on height of the tree. We will show that at each relation 𝑅, the priority queue PQ𝑅[𝑢]
correctly computes the answers over all projection attributes in the subtree rooted at 𝑅(denoted A𝜋
𝑅) in ranked order.
Base Case. Correctness for ranked output of leaf relations is trivial. For all tuples 𝑡in the relation at a leaf node with the same anchor
attribute value 𝑢, PQ𝑅[𝑢] contains all tuples 𝑡and the priority queue (whose implementation is assumed to be correct) will pop out 𝑡[A𝜋
𝑅] in
the correct order since the score rank(𝑡[A𝜋
𝑅]) is used as the priority queue comparator function and all projection attributes A𝜋
𝑅are present
in 𝑡already. It also follows that 𝑅[A𝜋
𝑅] will be materialized by chaining the cells popped from the priority queue since the leaf relation
already contains all the attributes in A𝜋
𝑅.
Inductive Case. Consider a relation 𝑅with children relations 𝑅1, . . . 𝑅𝑠. Let 𝑐be the cell that was the input to the TopDown procedure call
under consideration. Let 𝑢= 𝑐.𝑡[anchor(𝑅)] and 𝑢𝑖= 𝑐.𝑡[anchor(𝑅𝑖)]. Let 𝑡𝜋= output(𝑐next) be the next tuple and let 𝑐next be the cell that
is to be returned to the parent of 𝑅by the recursive call to 𝑅(i.e. 𝑐next follows 𝑐in the ranked output of the subtree rooted at 𝑅). Our goal is
to show that 𝑡𝜋is generated correctly and 𝑐next is inserted in PQ𝑅[𝑢]. This will guarantee the correct ordering of the tuples over attribute
set A𝜋
𝑅. From the induction hypothesis, we have that the ranked output, over the attributes A𝜋
𝑖, from each 𝑅𝑖is generated correctly. For the
sake of contradiction, suppose that 𝑡′𝜋is the next smallest candidate, i.e. rank(𝑡′𝜋) < rank(𝑡𝜋).
Lines 13-16 in Algorithm 2 generates 𝑠possible candidate cells (and is the only way to generate new candidates) that could generate 𝑡𝜋.
Let ˆ𝑐𝑖be the cell returned from the recursive call to TopDown for relation 𝑅𝑖. Then, there are 𝑠possible cells that are generated by TopDown
for relation 𝑅whose array of pointers will be one of:
ˆ𝑐1,𝑐2,𝑐3, . . . ,𝑐𝑠,
𝑐1, ˆ𝑐2,𝑐3, . . . ,𝑐𝑠,
. . . ,
𝑐1,𝑐2,𝑐3, . . . , ˆ𝑐𝑠
Here, 𝑐𝑖is 𝑖th pointer in the pointer array of 𝑐and rank(output(ˆ𝑐𝑖)) ≥rank(output(𝑐𝑖)) since the priority queue of the 𝑅𝑖will generate
answers in increasing order (from the induction hypothesis). Assume for the sake of contradiction that 𝑐′
next = ⟨𝑐.𝑡, [𝑐′
1,𝑐′
2, . . . ,𝑐′𝑠], ⊥⟩is the
cell such that 𝑡′𝜋= output(𝑐′
next) and is not one of the 𝑠candidate cells generated above. Since 𝑡′𝜋has a smaller score than 𝑡𝜋, it follows that
𝑐′
next has not been inserted in the priority queue yet (otherwise the priority queue will return 𝑐′
next correctly). We will show that such a
scenario will violate the monotonicity property of the sum ranking function.
Case 1. rank(output(𝑐𝑖)) ≥rank(output(𝑐′
𝑖)) for 𝑖∈[𝑠]. This scenario implies that 𝑡′𝜋has been generated before 𝑡𝜋, which would violate
our assumption that 𝑡′𝜋has not been inserted in the priority queue. Indeed, since rank(output(𝑐𝑖)) ≥rank(output(𝑐′
𝑖)) and lines 13-16
in Algorithm 2 generate cells that are monotonically increasing, there exists a sequence of generations that generate 𝑐next from 𝑐′
next which
would mean that 𝑐′
next was present in the priority queue at some point.
Case 2. rank(output(𝑐𝑖)) < rank(output(𝑐′
𝑖)) for𝑖∈[𝑠]. This scenario implies that Í
𝑖rank(output(𝑐𝑖)) = rank(𝑡𝜋) < Í
𝑖rank(output(𝑐′
𝑖)) =
rank(𝑡′𝜋) which contradicts our assumption that 𝑡′𝜋has a smaller score than 𝑡𝜋.
Case 3. rank(output(𝑐𝑖)) and rank(output(𝑐′
𝑖)) are incomparable. If 𝑐′
next has not been inserted in the priority queue yet, there are
two possible scenarios. Either 𝑐′
next will be generated by some cell 𝑐′′
next that is already in the priority queue. Clearly, rank(output(𝑐′
next)) >
rank(output(𝑐′′
next)) > rank(output(𝑐next)) using the same reasoning as Case 1 which contradicts our assumption. The second possibility
is that 𝑐′
next and 𝑐next are generated in the same loop. But this would again imply that 𝑐′
next is in the priority queue, a contradiction to our
assumption.
Therefore, it cannot be the case that rank(𝑡′𝜋) < rank(𝑡𝜋) which proves that for relation 𝑅, all tuples generated over the attributes A𝜋
𝑅are
in the correct order and consequently, the claim holds for all relations in the join tree, including the root.
In the second part of the proof, we will show that every result enumerated must belong to 𝑄(𝐷). This is a direct consequence of the
properties of the join tree. Indeed, if some tuple 𝑡∉𝑄(𝐷) is enumerated, that would violate the join condition on some attribute 𝑋∈A.
Next, we will show that every query result in 𝑄(𝐷) will be enumerated using induction on the join tree. In the base case, for some leaf
16

---

node 𝑅in T, every query result over attributes A𝜋
𝑅will be enumerated from Topdown because the relation is materialized. By the induction
hypothesis, for each 𝑖∈[𝑠],
𝑄𝑖= (Z𝑗∈nodes in subtree rooted at 𝑖𝑅𝑗)[A𝜋
𝑖]
is enumerated completely generated. For each tuple 𝑡in 𝑅, lines 13-16 guarantees that,
((×𝑖∈[𝑠]𝑄𝑖) Z 𝑡)[A𝜋
𝑅]
must be inserted into PQ[𝜋anchor(𝑅) (𝑡)], and thus enumerated. In other words, the projection of cartesian product between each subquery
rooted at 𝑅𝑖(i.e. 𝑄𝑖as defined above) and 𝑡over A𝜋
𝑅is generated. This implies that the subquery induced by the subtree rooted at 𝑅enumerates
all join result over A𝜋
𝑅. In the preprocessing phase, all tuples in 𝑅are put into the entries of PQ[𝜋anchor(𝑅) (𝑡)], thus every query result in
𝑄(𝐷) will necessarily be enumerated.
□
Lemma 4. EnumAcyclicLexi enumerates 𝑄(𝐷) correctly in lexicographic order with delay guarantee 𝑂(|𝐷|) after preprocessing time 𝑇𝑝=
𝑂(|𝐷| log |𝐷|) and space complexity 𝑂(|𝐷|).
Proof. We will prove that the algorithm enumerates the query result in the correct lexicographic order using induction on the parameter
𝑖in Algorithm 3.
Base case. 𝑖= 1. Note that since dom(𝐴1) is sorted 𝑡′, will be initialized with 𝑎∈dom(𝐴1) in sorted order which guarantees that all
output tuples with 𝑎as the attribute value for 𝐴1 will be enumerated before tuples with 𝑎′ as the attribute value for 𝐴1 if 𝑎≤𝑎′, thus
respecting the lexicographic order for 𝐴1.
Inductive case. 𝑖= 𝑘. From the induction hypothesis, we get that the algorithm will enumerate correctly for the first 𝑘−1 attributes
including 𝐴𝑘−1. From the previous iteration, L′ is set to be the sorted list of attribute values for 𝐴𝑘that join with 𝑅𝑘(𝐴𝑘,𝐴𝑘+1). Therefore, it
follows that for the recursive call where 𝑖= 𝑘, 𝑡′ will have a attribute values set in sorted order for 𝐴𝑘, ensuring that all answers containing
𝑎= 𝜋𝐴𝑘(𝑡′) will be enumerated before answers containing 𝑎′ as attribute value for 𝐴𝑘for all 𝑎≤𝑎′. Thus, the argument holds for 𝑖= 𝑚as
well, concluding the proof.
Next, we analyze the time complexity. The preprocessing phase takes 𝑂(|𝐷| log |𝐷|) time in total for sorting and building hashing tables
for each relation. Observe that after fixing a value in dom(𝐴𝑖), it takes at most 𝑂(|𝐷|) time to perform the semi-joins and find the set of
candidate values in dom(𝐴𝑖+1). Whenever 𝑖reaches 𝑚, a valid query result will be enumerated. As the query size as well as 𝑚is a constant,
the delay between two consecutive query results is at most 𝑂(|𝐷|), which improves Lemma 1 by a log factor.
□
Lemma 5. Algorithm 4 runs in time 𝑇= 𝑂(|𝐷| · (|𝐷|/𝛿)𝑚−1) and requires space 𝑆= 𝑂((|𝐷|/𝛿)𝑚). Algorithm 5 correctly enumerates the result
of the query in ranked order with delay 𝑂(|𝐷| log |𝐷|/𝛿).
Proof. Time and Space complexity. First, we analyze its time complexity. Computing data statistics for each relation 𝑅𝑖takes 𝑂(|𝐷|)
time. As the degree threshold is 𝛿, there are at most 𝑂( |𝐷|
𝛿) heavy values for each 𝐴𝑖. The size of O𝐻can be bounded by 𝑂(|𝐷| · ( |𝐷|
𝛿)𝑚−1),
as well as the time cost for computing O𝐻by the Yannakakis algorithm. At last, initializing data structures for each 𝑄𝑖takes linear time in
terms of 𝑂(|𝐷|). As the number of such queries is 𝑂(𝑚), the time cost for line 3-6 is 𝑂(|𝐷| · 𝑚). Overall, the time complexity of Algorithm 4
is 𝑂(|𝐷| · ( |𝐷|
𝛿)𝑚−1). For the space usage, storing O𝐻takes 𝑂(( |𝐷|
𝛿)𝑚) space since its size can be bounded by 𝑂(( |𝐷|
𝛿)𝑚) using the AGM
bound.
Delay guarantee. Note that min-extraction and update of the priority queue takes 𝑂(log |𝐷|) time. The expensive part is the invocation of
EnumAcyclic for each 𝑄𝑖. In the join tree T𝑖, each node contains at least one projection attribute. Plugging in Lemma 1 and the observations
in Appendix D, the delay of enumerating query result from 𝑄𝑖is at most the degree of values of attribute 𝐴𝑖, i.e., 𝛿, since tuples in 𝑅𝑖are
light in this case, by construction of 𝑄𝑖. Together, the delay of Algorithm 5 is 𝑂(𝛿log |𝐷|). By setting 𝛿= |𝐷|1−𝜖for arbitrary constant
0 < 𝜖< 1, we can achieve the result in Theorem 2.
Correctness. Recall that 𝑂𝐻is already materialized and sorted order and since the enumeration of each subquery 𝑄𝑖is performed
using EnumAcyclic (which enumerated the query result correctly), the output of each 𝑄𝑖is enumerated in the correct order. It remains to be
shown that EnumStar can also combine the answers from 𝑂𝐻and 𝑄𝑖correctly. Suppose that 𝑡was the last answer output to the user. If 𝑡
was generated by some 𝑄𝑖(which can be checked in constant time), then we find the next smallest candidate from 𝑄𝑖and insert it into PQ.
Otherwise, if 𝑡∈𝑂𝐻, we find the next tuple in the materialized output and insert it into PQ. Thus, since the smallest candidates for each 𝑄𝑖
and 𝑂𝐻are present in the PQ, the smallest answer that must be output to the user necessarily has to be from the priority queue. Thus, the
priority queue performs the 𝑚+ 1-way merge correctly. This concludes the proof.
□
Lemma 7. Consider star query 𝑄★𝑚, database 𝐷and some constant 𝜖∈[0, 1]. If there exists an algorithm that supports 𝑂(|𝐷|1−𝜖log |𝐷|)-delay
enumeration after 𝑂(|𝐷|1+(𝑚−1)𝜖−𝜖′) preprocessing time for some constant 𝜖′ > 0, the optimality of Lemma 6 will be broken.
17

---

Proof. For a star query 𝑄★𝑚and database 𝐷, assume there is an algorithm that supports 𝑂(|𝐷|1−𝜖log |𝐷|)-delay enumeration after
𝑂(|𝐷|1+(𝑚−1)𝜖−𝜖′) preprocessing time. Then, there is an algorithm evaluating 𝑄★𝑚(𝐷) in (big-Oh of)
|𝐷|1+(𝑚−1)𝜖−𝜖′ + |𝐷|1−𝜖log |𝐷| · |𝑄★
𝑚(𝐷)|
time. Let 𝛼= 𝑚𝜖−𝜖′ for some constant 𝜖′ < 𝜖. Consider an instance 𝐷′ for 𝑄★𝑚with output size 𝑁𝛼/log 𝑁. The running time of the
algorithm is (big-Oh of)
|𝐷′|1+(𝑚−1)𝜖−𝜖′ + |𝑄★
𝑚(𝐷′)| · (|𝐷′|1−𝜖log |𝐷′|)
=|𝐷′|1−𝜖′
𝑚· |𝑄★
𝑚(𝐷′)|(1−1
𝑚)
which breaks the optimality of Lemma 6.
□
Lemma 8. The delay guarantee of Lemma 1 is optimal up to polylogarithmic factors subject to the combinatorial BMM conjecture.
D
MORE FINE GRAINED RESULTS
In this section, we show tighter delay guarantees for Theorem 1 under certain settings. Consider a query where each relation contains at least
one projection attribute (for instance, 𝑄★𝑚). Let’s fix a relation 𝑅and let the projection attributes in 𝑅be B. Denote Δ𝑅= max𝑢∈dom(B) |𝜎B=𝑢𝑅|
and Δ = maxnon-leaf relations 𝑅Δ𝑅. Then, the delay guarantee obtained by Theorem 1 is at most 𝑂(Δ log |𝐷|). A trivial upper bound for
Δ = |𝐷| since the size of all relations is |𝐷|. However, if there are constraints known about the degree of the tuples in the relations, we can
improve our results. We give two concrete scenarios below.
Bounded Degree Database. For each relation, if every attribute value is present in at most 𝛿tuples, it implies that the degree is at most 𝛿.
In this case, it can be shown that Δ = 𝛿and we get improved delay guarantees since the duplication is bounded when each relation has
projection attributes.
Bounded Degree By Preprocessing. Consider the star query 𝑄★𝑚. Recall that in Algorithm 4, we preprocess to reduce the degree of all 𝑎𝑖
from |𝐷| to 𝛿= |𝐷|1−𝜖. Thus, the discussion above applies and we can achieve 𝑂(|𝐷|1−𝜖log |𝐷|) delay.
Improved delay guarantee is obtained in Algorithm 2 only when the while loop can terminate in 𝑜(|𝐷|) time. For any anchor attribute
value 𝑢for some relation 𝑅in the join-tree, this can only happen when the tuples generated over A𝑅are not duplicated more than a certain
number of times. Since every relation contains a projection attribute and has bounded degree Δ, it means that PQ𝑅[𝑢] can have at most Δ
duplicates which gives the better bound.
E
RECOVERING RESULTS FOR FULL QUERIES
Next, we outline how Algorithm 2 achieves delay 𝑂(log |𝐷|) after 𝑂(|𝐷|) preprocessing for full acyclic queries. The key observation is that
when the query is full, the while loop always terminates after a constant number of operations. This is because no two answer tuples over
A𝜋
𝑅are the same, i.e, the attribute values for any two answer tuples cannot be identical. Further, any answer tuple at 𝑅is inserted at most a
constant number of times. This guarantees that is_equal procedure will return false after popping an answer constant number of times and
the while loop terminates. Thus, in the worst-case, TopDown visits each relation of the join tree at most once and each iteration takes only
𝑂(log |𝐷|) time due to the priority queue operations.
Free-connex queries. A join query 𝑄is said to be free-connex if 𝑄is acyclic and the hypergraph containing edges of 𝑄and a new edge
containing only the projection variables is also acyclic. Free-connex is an interesting class of queries which allows constant delay enumeration
for a variety of problems [10, 17]. If a join-project query is free-connex, then our actually algorithm achieves 𝑂(log |𝐷|) delay enumeration
(instead of the general 𝑂(|𝐷| log |𝐷|) bound) after linear time preprocessing. It can be shown that for free-connex queries, all projection
attributes are connected and must be at the top of the tree and all non-projection attributes are connected and at the bottom of the tree.
This observation allows us to remove all relations that do not contain any projection attributes or relation where only anchor attributes are
projection attributes, transforming the free-connex query into a full join query.
F
SUBMODULAR WIDTH LOWER BOUND
Abboud, Backurs and, Vassilevska Williams present the Combinatorial 𝑘−Clique Hypothesis [1].
Definition 2. Let 𝐶be the smallest constant such that a combinatorial algorithm running in 𝑂(𝑛𝐶𝑘/3) time exists for detecting a 𝑘−clique in
a 𝑛node 𝑂(𝑛2) edge graph, for all sufficiently large constants 𝑘. The Combinatorial 𝑘−Clique Hypothesis states that 𝐶= 3.
Next, we recall a cycle detection hypothesis from [50] that depends on the combinatorial 𝑘−clique hypothesis.
Theorem 5 (Combinatorial Sparse k-Cycle Lower Bound). Detecting a directed odd 𝑘−cycle in a graph with 𝑛nodes and 𝑚= 𝑛(𝑘+1)/(𝑘−1) in
time 𝑂(𝑚(1−𝜖)2𝑘/(𝑘+1)) for any constant 𝜖> 0 violates the Combinatorial 𝑘−Clique Hypothesis.
18

---

IMDB2hop = SELECT DISTINCT P1.name, P2.name FROM Person AS P1, Person AS P1, PersonMovie AS PM1, PersonMovie as PM2
WHERE PM1.pid = PM2.pid AND PM1.aid = P1.aid AND PM2.aid = P2.aid AND P1.role = 'ACTOR' AND P2.role = 'ACTOR' ORDER BY
A1.weight + A2.weight LIMIT k;
IMDB3hop = SELECT DISTINCT P.name, M.name FROM Person AS P, Person AS P′, Movie AS M, PersonMovie AS PM1, PersonMovie
as PM2, PersonMovie as PM3 WHERE PM1.mid = PM2.mid AND PM2.pid = PM3.pid AND PM2.pid = P′.pid AND PM1.pid = P.pid AND
PM3.mid = M.mid AND P.role = 'ACTOR' AND P′.role = 'ACTOR' ORDER BY P.weight + M.weight LIMIT k;
IMDB4hop = SELECT DISTINCT P1.name, P2.name FROM Person AS P1, Person AS P2, Person AS P3, PersonMovie AS PM1,
PersonMovie as PM2, PersonMovie as PM3, PersonMovie as PM4 WHERE PM1.mid = PM2.mid AND PM2.pid = PM3.pid AND
PM3.mid = PM4.mid AND PM1.pid = P2.pid AND P3.role = 'ACTOR' AND PM2.pid = P3.pid AND P1.role = 'ACTOR' AND
PM4.pid = P2.aid AND P2.role = 'ACTOR' ORDER BY P1.weight + P2.weight LIMIT k;
IMDB3star = SELECT DISTINCT P1.name, P2.name, P3.name FROM FROM Person AS P1, Person AS P2, Person AS P3, PersonMovie AS
AP1, PersonMovie as AP2, PersonMovie as AP3 WHERE PM1.mid = PM2.mid = PM3.mid AND PM1.pid = P1.pid AND
PM2.pid = P2.pid AND PM3.pid = P3.pid AND P1.role = 'ACTOR' AND P2.role = 'ACTOR' AND P3.role = 'ACTOR' ORDER BY
P1.weight + P2.weight + P3.weight LIMIT k;
Figure 11: Network analysis queries for IMDB.
Consider an odd 𝑘−cycle CQ over binary relations of the form 𝑄⟳(𝑥1,𝑥2) = 𝑅1(𝑥1,𝑥2) Z 𝑅2(𝑥2,𝑥3) Z · · · Z 𝑅𝑘(𝑥𝑘,𝑥1). Then, we can
show the following straightforward result.
Lemma 9. For some odd 𝑘cycle query 𝑄⟳with 𝑘> 3, an algorithm that enumerates the query result with delay 𝑂(|𝐷|2𝑘/𝑘+1 −𝜖) after
𝑂(|𝐷|2𝑘/(𝑘+1) −𝜖) preprocessing violates the Combinatorial Sparse 𝑘−Cycle Lower Bound.
Proof. If the algorithm has delay guarantee 𝛿= 𝑂(|𝐷|2𝑘/𝑘+1 −𝜖), then in 𝛿time, we can decide whether there exists a cycle or not since
the preprocessing time is also 𝑂(|𝐷|2𝑘/𝑘+1 −𝜖), a contradiction.
□
Note that the submodular width for the odd 𝑘−cycle query is subw = 2 −2/(𝑘+ 1) = 2𝑘/(𝑘+ 1). Thus, there exist queries for which the
exponential dependence of subw in Theorem 4 cannot be avoided assuming the Combinatorial 𝑘−Clique Hypothesis.
G
DEFERRED EXPERIMENTS
In this section, we present the experimental results for settings that were not covered in the main paper due to lack of space.
G.1
Small Scale Experiments
Lexicographic ordering. Figures 12a, 12a, 12c, 12d show the running time for different values of 𝑘in the limit clause for lexicographic
function for IMDB dataset. Our conclusions remain the same as they were for DBLP dataset.
Choice of different root of the join tree. For the DBLP dataset, we test the choice of different root nodes for DBLP3hop and DBLP4hop
queries since these queries have a large choice of root nodes to pick from. We observed that for any choice of root node in the join tree, the
difference in total execution time for 𝑘ranging from 10 to 104 was less than 3%. This demonstrates that as long as the join tree or GHD is of
the minimal width, the actual orientation of the GHD has no meaningful impact on the execution times.
Measuring the delay. Our final experiment in this subsection evaluates how many priority queue operations are required for each answer
tuple. Recall that for each answer, our algorithm performs 𝑂(|𝐷|) priority queue operations in the worst-case (Theorem 1). Thus, the number
of priority queue operations is a proxy for the delay between any two answers. Figure 14a plots the fraction of answers that require a certain
number of PQ operations for DBLP2hop. Nearly 70% of answers require only one PQ push and pop operation and 99% of the output requires
at most 22 push and pop operations. However, there are some outliers as well. The largest number of push and pops over all answers is 306.
This is not particularly surprising given the fact that DBLP is a sparse dataset but dense matrix datasets can easily have a large duplication in
practice. For the IMDB dataset, we found that 95% of answers require one priority queue operation and 99% of answers needed at most three
operations.
G.2
Large Scale Experiments
Lexicographic ordering. Figure 12e, 12f, 12g, 12h show the execution time of the ranked two and three hop queries on Friendster and
Memetracker datasets. Similar to the small-scale datasets, lexicographic function is faster to evaluate than sum function but all baselines
engines were unable to complete execution in the cutoff time.
19

---

101
102
103
104
105
106
107
k in limit clause
100
101
102
Time in sec.
(a) IMDB2hop
101
102
103
104
105
106
107
k in limit clause
100
101
102
103
Time in sec.
(b) IMDB3hop
101
102
103
104
105
106
107
k in limit clause
100
101
102
103
Time in sec.
(c) IMDB4hop
101
102
103
104
105
106
107
k in limit clause
100
101
102
Time in sec.
(d) IMDB3star
101
102
103
104
k in limit clause
20
25
30
35
40
45
50
Time in sec.
(e) Friendster2hop
101
102
103
104
k in limit clause
30
35
40
45
50
55
60
Time in sec.
(f) Friendster3hop
101
102
103
104
k in limit clause
10
15
20
25
30
35
40
45
50
Time in sec.
(g) Memetracker2hop
101
102
103
104
k in limit clause
10
15
20
25
30
35
40
45
50
Time in sec.
(h) Memetracker3hop
Figure 12: Comparing our linear delay algorithm with state-of-the-art engines for lexicographic function.
aid
aid
pid
pid
is_research
= true
name
is_research
= true
aid
name
pid
pid
name
is_research
= true
is_research
= true
Author
Author
Author
Paper
Paper
Paper
Paper
AuthorPaper
AuthorPaper
AuthorPaper
AuthorPaper
AuthorPaper
AuthorPaper
AuthorPaper
AuthorPaper
pid
Paper
aid
aid
is_research
= true
(a) Four cycle query for DBLP (left) and Six cycle query for DBLP (right)
aid
name
pid
pid
is_research
= true
is_research
= true
Author
Paper
Paper
AuthorPaper
AuthorPaper
aid
aid
pid
pid
aid
is_research
= true
is_research
= true
Author
name
AuthorPaper
AuthorPaper
Paper
Paper
AuthorPaper
AuthorPaper
(b) Eight cycle query for DBLP
Figure 13: Hypergraphs for cyclic queries
0
5
10
15
20
Number of push/pops in priority queue
0.0
0.2
0.4
0.6
0.8
1.0
Fraction of output
(a) DBLP2hopPQ operations per answer
k = 10
k = 102
k = 103
k = 104
four cycle
25.2s
26.8s
29.6s
37.4s
six cycle
323.8s
325.7s
339.2s
360.4s
eight cycle
595.6s
605.3s
609.4s
620.8s
bowtie
598.2s
604.7s
610.89s
625.8
(b) Cyclic query performance on IMDB dataset for different values of
𝑘in LIMIT clause. Ranking function is sum.
Figure 14: (left) DBLP empirical delay; (right) cyclic query performance on IMDB
G.3
Cyclic Query Description
In this subsection, we describe the cyclic queries used in the experimental evaluation. Figure 13 shows the hypergraphs for the cyclic queries
on DBLP dataset. The queries are defined in a very similar way for all other real-world datasets as well.
Four cycle. Find all co-author pairs who have been on at least two research papers together ranked by sum of weights/lexicographic
ordering.
20

---

Six cycle. For every author, find all research paper such that the there exist at least two co-authors and the research paper contains both
the co-authors. Rank all the output author, research paper pairs by sum of weights/lexicographic ordering.
Eight cycle. Find all co-author of co-author pairs who have been on at least two different research papers together ranked by sum of
weights/lexicographic ordering.
Bowtie. Consider the materialized view 𝑉(𝑎1,𝑎2) for the eight cycle query. The bowtie query enumerates 𝑄= 𝜋𝑎1,𝑎3 (𝑉(𝑎1,𝑎2) Z
𝑉(𝑎2,𝑎3)) ranked by sum of weights/lexicographic ordering.
21

---

