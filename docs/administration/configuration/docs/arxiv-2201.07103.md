# Simplified Algorithms for Order-Based Core Maintenance

> 来源: https://arxiv.org/pdf/2201.07103

Simplified Algorithms for Order-Based Core Maintenance
Bin Guo
McMaster University
Hamilton, Ontario, Canada
guob15@mcmaster.ca
Emil Sekerinski
McMaster University
Hamilton, Ontario, Canada
emil@mcmaster.ca
ABSTRACT
Graph analytics attract much attention from both research and
industry communities. Due to the linear time complexity, the 𝑘-
core decomposition is widely used in many real-world applications
such as biology, social networks, community detection, ecology,
and information spreading. In many such applications, the data
graphs continuously change over time. The changes correspond
to edge insertion and removal. Instead of recomputing the 𝑘-core,
which is time-consuming, we study how to maintain the 𝑘-core
efficiently. That is, when inserting or deleting an edge, we need to
identify the affected vertices by searching for more vertices. The
state-of-the-art order-based method maintains an order, the so-
called 𝑘-order, among all vertices, which can significantly reduce
the searching space. However, this order-based method is compli-
cated for understanding and implementation, and its correctness is
not formally discussed. In this work, we propose a simplified order-
based approach by introducing the classical Order Data Structure to
maintain the 𝑘-order, which significantly improves the worst-case
time complexity for both edge insertion and removal algorithms.
Also, our simplified method is intuitive to understand and imple-
ment; it is easy to argue the correctness formally. Additionally,
we discuss a simplified batch insertion approach. The experiments
evaluate our simplified method over 12 real and synthetic graphs
with billions of vertices. Compared with the existing method, our
simplified approach achieves high speedups up to 7.7x and 9.7x for
edge insertion and removal, respectively.
PVLDB Reference Format:
Bin Guo and Emil Sekerinski. Simplified Algorithms for Order-Based Core
Maintenance. PVLDB, 14(1): XXX-XXX, 2020.
doi:XX.XX/XXX.XX
PVLDB Artifact Availability:
The source code, data, and/or other artifacts have been made available at
https://github.com/Itisben/SimplifiedCoreMaint.
1
INTRODUCTION
Given an undirected graph 𝐺= (𝑉, 𝐸), the 𝑘-core decomposition
is to identify the maximal subgraph 𝐺′ in which each vertex has a
degree of at least 𝑘; the core number of each vertex 𝑢is defined as
the maximum value of 𝑘such that 𝑢is contained in the 𝑘-core of
𝐺[1, 10]. It is well-known that the core numbers can be computed
with linear running time 𝑂(|𝑉|+|𝐸|) [1]. Due to the linear time
This work is licensed under the Creative Commons BY-NC-ND 4.0 International
License. Visit https://creativecommons.org/licenses/by-nc-nd/4.0/ to view a copy of
this license. For any use beyond those covered by this license, obtain permission by
emailing info@vldb.org. Copyright is held by the owner/author(s). Publication rights
licensed to the VLDB Endowment.
Proceedings of the VLDB Endowment, Vol. 14, No. 1 ISSN 2150-8097.
doi:XX.XX/XXX.XX
complexity, the 𝑘-core decomposition is easily and widely used in
many real-world applications. In [10], Kong et al. summarize a large
number of applications in biology, social networks, community
detection, ecology, information spreading, etc. Especially in [3],
Lesser et al. investigate the 𝑘-core robustness in ecological and
financial networks.
In a survey [13], Malliaros et al. summarize the main research
work related to 𝑘-core decomposition from 1968 to 2019. In static
graphs, the computation of the core numbers has been extensively
studied [1, 4, 9, 15, 20]. However, in many real-world applications,
such as determining the influence of individuals in spreading epi-
demics in dynamic complex networks [14] and tracking the actual
spreading dynamics in dynamic social media networks [16], the
data graphs continuously change over time. The changes corre-
spond to the insertion and deletion of edges, which may have an
impact on the core numbers of some vertices in the graph. Graphs
of this kind are called dynamic graphs. When inserting or removing
an edge, it is time-consuming to recalculate the core numbers of
all vertices; a better approach is first to find the affected vertices
and then to update their corresponding core numbers. The problem
of maintaining the core numbers for dynamic graphs is called core
maintenance. To the best of our knowledge, little work is done on
the 𝑘-core maintenance [17, 18, 21, 24].
In this work, we focus on core maintenance. More formally, given
an undirected dynamic graph 𝐺= (𝑉, 𝐸), after inserting an edge
into or removing an edge from 𝐺, the problem is how to efficiently
update the core number for the affected vertices. To do this, we
first need to identify a set of vertices whose core numbers need to
be updated (denoted as 𝑉∗) by traversing a possibly larger set of
vertices (denoted as 𝑉+). Then it is easy to re-compute the new
core numbers of vertices in 𝑉∗. In [23], Zhang et al. prove that the
core maintenance is asymmetric: the edge removal is bounded for
𝑉∗= 𝑉+, but the edge insertion is unbounded for 𝑉∗⊆𝑉+. In
other words, to identify𝑉∗, the edge removal only needs to traverse
𝑉∗; however, the edge insertion may traverse a much larger set of
vertices than 𝑉∗. In practice, an edge removal algorithm for core
maintenance [18, 24] is easy to devise; but for edge insertion, it is
challenging. Clearly, an efficient edge insertion algorithm should
have a small cost for identifying 𝑉∗, which means a small ratio
|𝑉+|/|𝑉∗|. In this work, we mainly discuss the edge insertion algo-
rithms for core maintenance.
In [18], Sariyüce et al. propose a traversal algorithm. This in-
sertion algorithm searches 𝑉∗only in a local region near the edge
that is inserted, which can be much faster than recomputing the
core numbers for the whole graph. However, this insertion algo-
rithm has a high variation in terms of performance due to the high
variation of the ratio |𝑉+|/|𝑉∗|. In [24], Zhang et al. propose an
order-based approach, which is the state-of-the-art method for core
arXiv:2201.07103v1  [cs.DB]  18 Jan 2022

---

maintenance. The main idea is that a 𝑘-order is explicitly main-
tained among vertices such that 𝑢⪯𝑣for every two vertices in a
graph 𝐺. Here, a 𝑘-order, (𝑣1 ⪯𝑣2 ⪯.... ⪯𝑣𝑛), for each vertex 𝑣𝑖
in a graph 𝐺, is an order that the core number determined by a
core decomposition algorithm, the BZ algorithm [1]. When a new
edge (𝑢, 𝑣) is inserted, the potentially affected vertices are checked
with such 𝑘-order, by which numerous vertices are avoided to be
checked. In this case, the size of 𝑉+ is greatly reduced and so that
the ratio |𝑉+|/|𝑉∗| is typically much smaller and has less variation
compared with the traversal algorithm. Thus the computation time
is significantly improved.
However, this order-based approach has two drawbacks. First,
the order-based edge insertion algorithm is so complicated that
it is not intuitive for easy understanding. This complexity further
brings difficulties to the correctness and implementation; actually,
the proof of correctness for the edge-insert algorithm is not formally
discussed in [24]. Second, the 𝑘-order of the vertices in a graph is
maintained by two specific data structures: 1) A (double linked
lists combined with balanced binary search trees) for operations
like inserting, deleting, comparing the order of two vertices, all of
which requires worst-case 𝑂(log|𝑉|) time; and 2) B (double linked
lists combined with heaps) for searching the ordered vertices by
jumping unnecessary ones, which requires worst-case 𝑂(log|𝑉|)
time; both data structures are complicated to implement.
In this work, we try to overcome the above drawbacks in [24]
by proposing our simplified order-based approach. The idea behind
our new approach is that we introduce a well-known Order Data
Structure [2, 6] to maintain the 𝑘-order of vertices in a graph 𝐺.
By doing this, there are several benefits. First, this classical Order
Data Structure only requires amortized 𝑂(1) time for order opera-
tions, including inserting, deleting, and comparing the order of two
vertices; this is faster than the A data structure in [24] especially
when |𝑉| is large. Also, the original order-based insertion algorithm
can be introduced to maintain each affected vertex in 𝑘-order in
worst-case 𝑂(𝑙𝑜𝑔|𝐸+|) time (|𝐸+| is the number of edges adjacent
to vertices in 𝑉+); this is also faster than the B data structure
in [24] since normally we have |𝐸+|≪|𝑉|. Second, compared with
the method in [24], when introducing the Order Data Structures
and priority queues, the A and B data structures can be abandoned
and so that the order-based approach can be significantly simpli-
fied; also, our new approach simplifies the proof of correctness.
Finally, our simplified order-based insertion algorithm can be easily
extended to handle a batch of insertion edges without difficulties
since it is common that a great number of edges are inserted or
removed simultaneously; by doing this, the vertices in 𝑉+ \𝑉∗are
possibly avoided to be repeatedly traversed so that the total size of
𝑉+ is smaller compared to unit insertion. The main contributions
are summarized as below:
• We investigate the drawbacks of the state-of-the-art order-
based core maintenance algorithms in [24].
• Based on [24], by introducing the Order Data Structure [2, 6],
we propose a simplified order-based insertion algorithm. Not
only can the worst-case time complexity be improved, but
also the proof of correctness is simplified.
• We extend our simplified core insertion algorithm to handle
a batch of edges, with smaller size of 𝑉∗compared to unit
insertion.
• Finally, we conduct extensive experiments with different
kinds of real data graphs to evaluate different algorithms.
The rest of this paper is organized as follows. The preliminar-
ies are given in Section 2. The original order-based algorithm is
reviewed in Section 3. Our simplified order-based insertion and
removal algorithms are proposed in Section 4. Our simplified order-
based batch insertion is proposed in Section 5. Related work is
discussed in Section 6. We report on extensive performance studies
in Section 7 and conclude in Section 8.
2
PRELIMINARIES
Let 𝐺= (𝑉, 𝐸) be an undirected unweighted graph, where 𝑉(𝐺)
denotes the set of vertices and 𝐸(𝐺) represents the set of edges
in 𝐺. When the context is clear, we will use 𝑉and 𝐸instead of
𝑉(𝐺) and 𝐸(𝐺) for simplicity, respectively. Note that, as 𝐺is an
undirected graph, an edge (𝑢, 𝑣) ∈𝐸(𝐺) is equivalent to (𝑣,𝑢) ∈
𝐸(𝐺). We denote the number of vertices and edges of 𝐺by 𝑛and
𝑚, respectively. We define the set of neighbors of a vertex 𝑢∈𝑉
as 𝑢.adj, formally 𝑢.adj = {𝑣∈𝑉: (𝑢, 𝑣) ∈𝐸}. We denote the
degree of 𝑢in 𝐺as 𝑢.deg = |𝑢.adj |. Also, to analyze the time
complexity, we denote the maximal degree among all vertices in
𝐺as Deg(𝐺) = max{𝑣∈𝑉(𝐺) : 𝑣.deg}. We say a graph 𝐺′
is a subgraph of 𝐺, denoted as 𝐺′ ⊆𝐺, if 𝑉(𝐺′) ⊆𝑉(𝐺) and
𝐸(𝐺′) ⊆𝐸(𝐺). Given a subset 𝑉′ ⊆𝑉, the subgraph induced
by 𝑉′, denoted as 𝐺(𝑉′), is defined as 𝐺(𝑉′) = (𝑉′, 𝐸′) where
𝐸′ = {(𝑢, 𝑣) ∈𝐸: 𝑢, 𝑣∈𝑉′}.
Definition 2.1 (𝑘-Core). Given an undirected graph 𝐺= (𝑉, 𝐸)
and an integer 𝑘, a subgraph 𝐺𝑘of 𝐺is called a 𝑘-core if it satisfies
the following conditions: (1) for ∀𝑢∈𝑉(𝐺𝑘), 𝑢.deg ≥𝑘; (2) 𝐺𝑘is
maximal. Moreover, 𝐺𝑘+1 ⊆𝐺𝑘, for all 𝑘≥0, and 𝐺0 is just 𝐺.
Definition 2.2 (Core Number). Given an undirected graph 𝐺=
(𝑉, 𝐸), the core number of a vertex 𝑢∈𝐺(𝑉), denoted as 𝑢.core,
is defined as 𝑢.core = 𝑚𝑎𝑥{𝑘: 𝑢∈𝑉(𝐺𝑘)}. That means 𝑢.𝑐𝑜𝑟𝑒is
the largest 𝑘such that there exists a 𝑘-core containing 𝑢.
Definition 2.3 (Subcore). Given an undirected graph 𝐺= (𝑉, 𝐸),
a maximal set of vertices 𝑆⊆𝑉is called a 𝑘-subcore if (1) ∀𝑢∈
𝑆,𝑢.core = 𝑘; (2) the induced subgraph 𝐺(𝑆) is connected. The
subcore that contains vertex 𝑢is denoted as sc(𝑢).
Core Decomposition. Given a graph 𝐺= (𝑉, 𝐸), the problem
of computing the core number for each 𝑢∈𝑉(𝐺) is called core
decomposition. In [1], Batagelj and Zaversnik propose an algorithm
with a liner running time of 𝑂(𝑚+ 𝑛), the so-called BZ algorithm.
The general idea is the peeling process. That is, to compute the 𝑘-
core 𝐺𝑘of 𝐺, the vertices (and their adjacent edges) whose degrees
are less than 𝑘are repeatedly removed. When there are no more
vertices to remove, the resulting graph is the 𝑘-core of 𝐺.
Algorithm 1 shows the steps of the BZ algorithm. In initialization,
for each vertex 𝑢∈𝑉, the auxiliary degree 𝑢.𝑑is set to |𝑢.adj | and
the core number 𝑢.𝑐𝑜𝑟𝑒is not identified (line 1). The postcondition
is that for each vertex 𝑢∈𝑉, the 𝑢.𝑑equals to the core number,
formally 𝑢.𝑑= 𝑢.core. We state informally lines 3 - 8 as a loop
invariant: (1) the vertex𝑢always has the minimum degree𝑢.𝑑since
𝑢is removed from the min-priority queue 𝑄(line 4); and (2) if 𝑢
obtains its core number, 𝑢.𝑐𝑜𝑟𝑒equals to 𝑢.𝑑(line 5). The key step
is updating 𝑣.𝑑for all 𝑣∈𝑢.𝑎𝑑𝑗. That is, 𝑣.𝑑are decremented by
2

---

Algorithm 1: BZ algorithm for core decomposition
input :an undirected graph 𝐺= (𝑉, 𝐸)
output:the core number 𝑢.core for each 𝑢∈𝑉
1 for 𝑢∈𝑉do 𝑢.𝑑←|𝑢.adj |; 𝑢.𝑐𝑜𝑟𝑒= ∅
2 𝑄←a min-priority queue by 𝑢.𝑑for all 𝑢∈𝑉
3 while 𝑄̸ = ∅do
4
𝑢←𝑄.dequeue()
5
𝑢.core ←𝑢.𝑑; remove 𝑢from 𝐺
6
for 𝑣∈𝑢.adj do
7
if 𝑢.𝑑< 𝑣.𝑑then 𝑣.𝑑←𝑣.𝑑−1
8
update 𝑄
1 if 𝑢.𝑑is smaller than 𝑣.𝑑(lines 6 and 7). In this algorithm, the
min-priority queue 𝑄can be efficiently implemented by bucket
sorting [1], by which the total running time is optimized to linear
𝑂(𝑚+ 𝑛).
Core Maintenance. The problem of maintaining the core numbers
for dynamic graphs 𝐺is called core maintenance, when edges are
inserted into and removed from 𝐺continuously. The insertion and
removal of vertices can be simulated as a sequence of edge insertions
and removals. Hence, in this paper, we focus on maintaining the
core numbers when an edge is inserted into or removed from a
graph 𝐺.
Definition 2.4 (Candidate Set𝑉∗and Searching Set𝑉+). Given an
undirected graph 𝐺= (𝑉, 𝐸), when an edge is inserted or removed,
a candidate set of vertices, denoted as 𝑉∗, have to be computed
so that the core numbers of all vertices in 𝑉∗must be updated. In
order to identify 𝑉∗, a minimal set of searching vertices, denoted
as 𝑉+, is traversed by repeatedly accessing their adjacent edges.
Definition 2.4 says that 𝑉∗is identified by traversing all vertices
in𝑉+, so that𝑉∗has to belong to𝑉+, denoted as𝑉∗⊆𝑉+. Further,
the vertices in V + \ V ∗are traversed but not candidate vertices.
Efficient core maintenance algorithms should have a small ratio of
|V +|/|V ∗| in order to minimize the cost of computing 𝑉∗. After
𝑉∗is identified, the core number of vertices in 𝑉∗can be updated
accordingly.
2
2
1
1
1
1
1
2
:
,
,
,
,
, ...,
, ...,
O1 u1 u2 u3 u4 u5
u500
u1000
u2
u1
v2
u3
u4
u1000
v1
v3
1
u5
...
u500
1
:
,
,
O2 v1 v2 v3
...
Figure 1: A sample graph 𝐺with O = O1O2 in 𝑘-order.
Example 2.1. Consider the graph 𝐺in Figure 1. The numbers
inside the vertices are the core numbers. Three vertices, 𝑣1 to 𝑣3,
have same core numbers of 2; the other vertices, 𝑢1 to 𝑢1000, have
same core numbers of 1. The whole graph 𝐺is the 1-core of since
each vertex has a degree of at least 1; the subgraph induced by
{𝑣1, 𝑣2, 𝑣3} is the 2-core since each vertex in this subgraph has a
degree of at least 2. After inserting an edge, for example (𝑢1,𝑢500),
we observe that the core numbers of all vertices are not changed
according to the peeling process. In this case, the candidate set
𝑉∗= ∅. However, the searching set 𝑉+ is different for different
edge insertion method, e.g., the order-based algorithm may have
𝑉+ = {𝑢1,𝑢2,𝑢3} and the traversal algorithm traverse all vertices
in sc(𝑢1) with 𝑉+ = {𝑢1,𝑢2, . . . ,𝑢1000}.
We present two theorems given in [11, 18, 24] which are useful
to discuss the correctness of our insertion and removal algorithms.
Theorem 2.1. [11, 18, 24] After inserting an edge in or removing
an edge from 𝐺= (𝑉, 𝐸), the core number of a vertex 𝑢∈𝑉∗
increases or decreases by at most 1, respectively.
Theorem 2.2. [11, 18, 24] Suppose an edge (𝑢, 𝑣) with 𝐾=
𝑢.core ≤𝑣.core is inserted to (resp. removed from) 𝐺. Suppose 𝑉∗
is non-empty. We have the following: (1) if 𝑢.core < 𝑣.core, then
𝑢∈𝑉∗and𝑉∗⊆sc(𝑢) (as in Definition 2.3); (2) if 𝑢.core = 𝑣.core,
then both vertices 𝑢and 𝑣are in 𝑉∗(resp. at least one of 𝑢and
𝑣is in 𝑉∗) and 𝑉∗⊆sc(𝑢) ∪sc(𝑣); (3) the induced subgraph of
𝑉∗∈𝐺∪{(𝑢, 𝑣)} is connected.
Theorem 2.2 suggests that: (1) 𝑉∗only includes the vertices
𝑢∈𝑉with 𝑢.core = 𝐾; (2) 𝑉∗can be searched in a small local
region near the inserted or removed edge rather than in a whole
graph. That is, to identify 𝑉∗, all vertices in 𝑉+ are located in the
subcores containing 𝑢and 𝑣.
Order Data Structure. The well-know Order Data Structure [2, 6]
maintains a total order of subjects by following operations:
• ORDER(O,𝑥,𝑦): determine if 𝑥precedes𝑦in the total order O.
• INSERT(O,𝑥,𝑦): insert a new item 𝑦after 𝑥in the total or-
der O.
• DELETE(O,𝑥): remove an item 𝑥from the total order O.
In [2, 6], it is proved that all above three operations require
worst-case 𝑂(1) running time with linear space. The main idea is
that each item 𝑥in the total order is assigned a label to indicate
the order. In this way, an ORDER operation only requires 𝑂(1) time
for label comparisons and a DELETE operation only require 𝑂(1)
time for directly removing one item without affecting the labels
of other items. Significantly, an INSERT(O,𝑥,𝑦) is complicated: 1)
if there exists a valid label between two items 𝑥and 𝑥’s successor,
the new item 𝑦can be inserted between them by assigning a new
label, which requires 𝑂(1) time; 2) or else, a relabel operation is
triggered to rebalance the labels for adjacent items, which requires
𝑂(1) amortized running time.
In this work, our simplified order-based core maintenance algo-
rithms are based on this Order Data Structure. Our time complexity
analysis is based on the 𝑂(1) time for the above three order opera-
tions.
3
THE ORDER-BASED ALGORITHM
In this section, we discuss the state-of-the-art order-based core
maintenance approach in [24]. This algorithm is based on the 𝑘-
order, which can be generated by the BZ algorithm for core decom-
position [1] as in Algorithm 1. The 𝑘-order is defined as follows.
Definition 3.1 (𝑘-Order ⪯). [24] Given a graph 𝐺, the 𝑘-order
⪯is defined for any pairs of vertices 𝑢and 𝑣over the graph 𝐺as
follows: (1) when𝑢.core < 𝑣.core,𝑢⪯𝑣; (2) when𝑢.core = 𝑣.core,
3

---

𝑢⪯𝑣if 𝑢’s core number is determined before 𝑣’s by BZ algorithm
(Algorithm 1, line 5).
A 𝑘-order ⪯is an instance of all the possible vertex sequences
produced by Algorithm 1. For the 𝑘-order, transitivity holds, that is,
𝑢⪯𝑣if 𝑢⪯𝑤∧𝑤⪯𝑣. For each edge insertion and removal, the
𝑘-order will be maintained.
Here, O𝑘denotes the sequence of vertices in 𝑘-order whose core
numbers are 𝑘. A sequence O = O0O1O2 · · · over 𝑉(𝐺) can be
obtained, where O𝑖⪯O𝑗if 𝑖< 𝑗. It is clear that ⪯is defined over
the sequence of O = O0O1O2 · · ·. In other words, for all vertices
in graph, the sequence O indicates the 𝑘-order ⪯.
Example 3.1. Continually consider the graph 𝐺in Figure 1. The
numbers inside the vertices are the core numbers. The 𝑘-order of
𝐺is shown by O1 and O2, which is the order of core numbers
determined by the BZ algorithm (Algorithm 1 line 5); also, O1 is
determined before O2, so that we have O1 ⪯O2.
3.1
The Order-Based Insertion
The key step for the insertion algorithm is to determine 𝑉∗. To
do this, two degrees, 𝑢.𝑑+ and 𝑢.𝑑∗, for each vertex 𝑢∈𝑉(𝐺) are
maintained in order to identify whether 𝑢can be added into 𝑉∗or
not:
• remaining degree 𝑢.𝑑+: the number of the neighbors after
vertex 𝑢in O that can potentially support the increment of
the current core number.
• candidate degree 𝑢.𝑑∗: the number of the neighbors before
vertex 𝑢in O that can potentially have their core number
increased.
Assume that an edge (𝑢, 𝑣) is inserted with 𝐾= 𝑢.core ≤𝑣.core.
The intuition behind the order-based insertion algorithm is as fol-
lows. Starting from 𝑢, all affected vertices with the same core num-
ber 𝐾(Theorem 2.2) are traversed in O. For each visited vertex
𝑤∈𝑉+, the value of 𝑤.𝑑∗+ 𝑤.𝑑+ is maximal as 𝑤is visited by
𝑘-order. In this case, 𝑤will be added into 𝑉∗if 𝑤.𝑑∗+ 𝑤.𝑑+ > 𝐾;
otherwise, 𝑤is impossibly in𝑉∗, which may repeatedly cause other
vertices to be removed from𝑉∗. When all vertices with core number
𝐾are traversed, this process terminates and𝑉∗is identified. Finally,
the core numbers for all vertices in 𝑉∗are updated by increasing
by 1 (Theorem 2.1). Obviously, for all vertices 𝑢∈𝑉, the order O
along with 𝑢.𝑑+ and 𝑢.𝑑∗must be maintained accordingly.
Compared with the Traversal insertion algorithm [18], the bene-
fit of traversing with 𝑘-order is that a large number of unnecessary
vertices in 𝑉+ \ 𝑉∗can be avoided. This is why the order-based
insertion algorithm is generally more efficient.
The order-based insertion algorithm is not easy to implement
as it needs to traverse the vertices in O efficiently. There are three
cases. First, given a pair of vertices 𝑢, 𝑣∈O𝑘, the order-based in-
sertion algorithm needs to efficiently test whether 𝑢⪯𝑣or not.
For this, O𝑘is implemented as a double linked list associated with
a data structure A𝑘which is a binary search tree and each tree
node holds one vertex. For all 𝑢, 𝑣∈O𝑘, we can test the order
𝑢⪯𝑣in 𝑂(log|O𝑘|) time by using A𝑘. Second, the order-based
insertion algorithm needs to efficiently “jump” over a large num-
ber of non-affected vertices that have 𝑢.𝑑∗= 0. To do this, O𝑘
is also associated with a data structure B, which is a min-heap.
Here, B supports finding a affected vertex 𝑢with 𝑢.𝑑∗> 0 se-
quentially in O𝑘with 𝑂(1) time; but it requires 𝑂(log|O𝑘|) time
to maintain the min-heap. Therefore, when maintaining O, both A
and B requires to updated accordingly, which requires worst-case
𝑂(|𝑉+|· log|O𝑘|+𝑂(|𝑉∗|) log|O𝑘+1|) time for removing 𝑣∈𝑉∗
from O𝑘and then inserting 𝑣∈𝑉∗at the head of O𝑘+1.
As we can see, the A and B data structures are complicated,
which complicates understanding and implementation. Addition-
ally, the operations on A and B are time-consuming, especially
when handling a data graph with a large sizes of O𝑘or O𝑘+1.
3.2
The Order-Based Removal
The order-based removal algorithm adopts the same routine used
in the traversal removal algorithm [18] to compute 𝑉∗. This order-
based removal algorithm is based on the max-core degree.
Definition 3.2 (max-core degree mcd). [18, 24] Given a graph
𝐺= (𝑉, 𝐸), for each vertex 𝑣∈𝑉, the max-core degree, 𝑣.mcd, is
the number of 𝑣’s neighbors 𝑤such that 𝑤.𝑐𝑜𝑟𝑒≥𝑣.𝑐𝑜𝑟𝑒, defined
as 𝑣.mcd = |{𝑤∈𝑣.adj : 𝑤.core ≥𝑣.core}|.
As discussed, the edge removal is much simpler than the edge
insertion since edge removal is bounded for 𝑉∗= 𝑉+. Assuming
an edge (𝑢, 𝑣) is removed from the graph, both 𝑢.mcd and 𝑣.mcd
are updated accordingly. This may repeatedly affect other adjacent
vertices’ mcd. When the process terminates, all affected vertices
𝑢that have 𝑢.mcd < 𝑢.core can be added into 𝑉∗and then their
core numbers are off by 1. Obviously, for all vertices 𝑢∈𝑉∗, the
sequence O along with 𝑢.mcd must be maintained accordingly.
Compared with the Traversal removal algorithm, the difference
is that the order-based removal algorithm needs to maintain O
for all vertices in 𝑉∗. That is, all vertices in 𝑉∗with core number
𝑘are deleted from O𝑘and then appended to O𝑘−1 in the corre-
sponding 𝑘-order. Recall that two associated data structures, A
and B, are used for the order-based insertion algorithm. Both A
and B must be updated accordingly, which requires worst-case
𝑂(|𝑉∗|·(log|𝑂𝑘|+ log|𝑂𝑘−1|)) time for removing 𝑣∈𝑉∗from O𝑘
and appending 𝑣∈𝑉∗at the tail of O𝑘−1. Analogously to the order-
based insertion, the operations on A and B are time-consuming
when handling a data graph with a large size of O𝑘or O𝑘−1.
4
THE SIMPLIFIED ORDER-BASED
ALGORITHM
The main reason for the order-based algorithm being complicated
and inefficient is that two data structures, A and B, are used to
maintain O in 𝑘-order for all vertices in a graph. In this section, we
adopt the Order Data Structure [2, 6] to maintain the 𝑘-order for all
vertices. There are two benefits: one is that the 𝑘-order operations,
such as inserting, deleting, and comparing the order of two vertices,
can be optimized to 𝑂(1) amortized running time; the other is
that the original order-based method [24] can be simplified, which
makes it easier to implement and to discuss the correctness.
Before introducing the new method, we propose a constructed
Directed Acyclic Graph (DAG) to simplify the statement of our algo-
rithms. Given an undirected graph 𝐺= (𝑉, 𝐸) with O in 𝑘-order,
each edge (𝑢, 𝑣) ∈𝐸(𝐺) can be assigned a direction such that
𝑢⪯𝑣. By doing this, a direct acyclic graph (DAG) ®𝐺= (𝑉, ®𝐸) can
4

---

be constructed where each edge 𝑢↦→𝑣∈®𝐸( ®𝐺) satisfies 𝑢⪯𝑣.
Of course, the 𝑘-order of 𝐺is the topological order of ®𝐺. The post
of a vertex 𝑣in ®𝐺(𝑉, ®𝐸) is all its successors (outgoing edges), de-
fined by 𝑢( ®𝐺).𝑝𝑜𝑠𝑡= {𝑣| 𝑢↦→𝑣∈®𝐸( ®𝐺)}; the pre of a vertex 𝑣
in ®𝐺(𝑉, ®𝐸) is all its its predecessors (incoming edges), defined by
𝑢( ®𝐺).𝑝𝑟𝑒= {𝑣| 𝑣↦→𝑢∈®𝐸( ®𝐺)}. When the context is clear, we use
𝑢.𝑝𝑜𝑠𝑡instead of 𝑢( ®𝐺).𝑝𝑜𝑠𝑡and 𝑢.𝑝𝑟𝑒instead of 𝑢( ®𝐺).𝑝𝑟𝑒.
In other words, the constructed DAG ®𝐺= (𝑉, ®𝐸) is equivalent to
the undirected graph 𝐺(𝑉, 𝐸) by associating the direction for each
edge in 𝑘-order. This newly defined constructed DAG ®𝐺is conve-
nient for describing our simplified order-based insertion algorithm.
Lemma 4.1. Given a constructed DAG ®𝐺= (𝑉, ®𝐸), for each vertex
𝑣∈𝑉, the out-degree |𝑣.𝑝𝑜𝑠𝑡| is not greater than the core number,
|𝑣.post|≤𝑣.core.
Proof. Since the topological order of ®𝐺is the 𝑘-core of 𝐺, when
removing the vertex 𝑣by executing the BZ algorithm (Algorithm 1,
line 5) all the vertices in 𝑣.𝑝𝑟𝑒are already removed. In such a case,
the out-degree of 𝑣is its current degree. If there exist |𝑣.post|>
𝑣.core the value 𝑣.core should equal to |𝑣.post|, which leads to a
contradiction.
□
If inserting an edge into a constructed DAG ®𝐺does not violate
Lemma 4.1, no maintenance operations are required. Otherwise, ®𝐺
has to be maintained to re-establish Lemma 4.1.
Table 1 summarizes the notations that will be frequently used
when describing the algorithm.
Table 1: Notations.
Notation
Description
𝐺= (𝑉, 𝐸)
an undirected graph
®𝐺= (𝑉, ®𝐸)
an constructed DAG by the 𝑘-order
𝑢↦→𝑣∈®𝐸( ®𝐺)
a directed edge in an constructed DAG
O = O0O1 . . . O𝑘
a sequence indicates the 𝑘-order ⪯
𝑢( ®𝐺).d∗
in
the remaining in-degree of 𝑢
𝑢( ®𝐺).d+
out
the candidate out-degree of 𝑢
𝑢( ®𝐺).post
the successors of 𝑢in ®𝐺
𝑢( ®𝐺).pre
the predecessor of 𝑢in ®𝐺
𝑢.mcd
the max-core degree of 𝑢
𝑢.core
the core number of 𝑢
𝑉∗
candidate set
𝑉+
searching set
∆®𝐺= (𝑉, ∆®𝐸)
an inserted graph
4.1
The Simplified Order-Based Insertion
Theory Background. With the concept of the constructed DAG
®𝐺, we can introduce our simplified insertion algorithm to maintain
the core numbers after an edge is inserted to ®𝐺. For convenience,
based on the constructed DAG ®𝐺, we first redefine the two concepts
of candidate degree and remaining degree as in [24].
Definition 4.1 (candidate in-degree). Given a constructed DAG
®𝐺(𝑉, ®𝐸), the candidate in-degree 𝑣.d∗
in is the total number of its
predecessors located in 𝑉∗, denoted as
𝑣.d∗
in = |{𝑤∈𝑣.𝑝𝑟𝑒: 𝑤∈𝑉∗}|
Definition 4.2 (remaining out-degree). Given a constructed DAG
®𝐺(𝑉, ®𝐸), the remaining out-degree 𝑣.d+
out is the total number of its
successors without the ones that are confirmed not in 𝑉∗, denoted
as
𝑣.d+
out = |{𝑤∈𝑣.𝑝𝑜𝑠𝑡: 𝑤/∈V + \ V ∗}|
In other words, assuming that 𝐾= 𝑣.𝑐𝑜𝑟𝑒, the candidate in-
degree 𝑣.d∗
in counts the number of predecessors that are already in
the new (𝐾+ 1)-core; 𝑣.d+
out counts the number of successors that
can be in the new (𝐾+ 1)-core. Therefore, 𝑣.d∗
in + 𝑣.d+
out upper
bounds the number of 𝑣’s neighbors in the new (𝐾+ 1)-core.
Theorem 4.2. Given a constructed DAG ®𝐺= (𝑉, ®𝐸) by inserting
an edge 𝑢↦→𝑣with 𝐾= 𝑢.𝑐𝑜𝑟𝑒≤𝑣.𝑐𝑜𝑟𝑒, the candidate set 𝑉∗
includes all possible vertices that satisfy: 1) their core numbers equal
to 𝐾, and 2) their total numbers of candidate in-degree and remaining
out-degree are greater than 𝐾, denoted as
∀𝑤∈𝑉: 𝑤∈𝑉∗≡(𝑤.core = 𝐾∧𝑤.d∗
in + 𝑤.d+
out > 𝐾)
Proof. According to Theorem 2.1 and Theorem 2.2, for all ver-
tices in 𝑉∗, we have 1) their core numbers equal to 𝐾, and 2) their
core numbers will increase to 𝐾+ 1 and they can be added to new
(𝐾+1)-core. By the definition of 𝑘-core, for a vertex 𝑣∈𝑉∗, 𝑣must
have at least 𝐾+1 adjacent vertices that can be in the new (𝐾+1)-
core. As 𝑣.d∗
in + 𝑣.d+
out is the number of 𝑣’s adjacent vertices that
can be in the new (𝐾+ 1)-core, we get 𝑣.d∗
in + 𝑣.d+
out > 𝐾for all
vertices 𝑣∈𝑉∗.
□
Theorem 4.3. Given a constructed DAG ®𝐺= (𝑉, ®𝐸) by inserting
an edge 𝑢↦→𝑣with 𝑢in O𝐾, all affected vertices 𝑤are after 𝑢
in O𝐾. Starting from 𝑢, when 𝑤is traversed in O𝐾and the 𝑉+,
𝑉∗, 𝑤.d∗
in, 𝑤.d+
out are updated accordingly, each time the value of
𝑤.d∗
in + 𝑤.d+
out is maximal.
Proof. For all the vertices in the constructed DAG ®𝐺, O is the
topological order in ®𝐺according to the definition of ®𝐺. When
traversing affected vertices 𝑤in 𝐺in such topological order, each
time for 𝑤all the affected predecessors must have been traversed,
so that we get the value of 𝑤.d∗
in is maximal; also, all the related
successors are not yet traversed, so that the value of 𝑤.d+
out is also
maximal. Therefore, the total value of 𝑤.d∗
in + 𝑤.d+
out is maxi-
mal.
□
In other words, when traversing the affected vertices 𝑤in O,
𝑤.d∗
in + 𝑤.d+
out is the upper-bound. That means, when traversing
the vertices after 𝑤in O, 𝑤.d∗
in + 𝑤.d+
out only can be decrease as
some of vertices can be removed from𝑉∗. In this case, we can safely
remove 𝑤from 𝑉∗if 𝑤.d∗
in + 𝑤.d+
out ≤𝐾, since 𝑤is impossibly
in 𝑉∗according to Theorem 4.2. This is the key idea behind the
order-based insertion algorithm.
5

---

The Algorithm. Algorithm 2 shows the detailed steps when insert-
ing an edge 𝑢↦→𝑣. One issue is the implementation of traversing
the vertices in O𝑘. We propose to use a Min-Priority Queue com-
bined with the Order Data Structure (line 4). The idea is as follow: 1)
O𝑘is maintained by the Order Data Structure [2, 6], by which each
vertex is assigned a label (an integer number) to indicate the order,
and 2) all adjacent vertices are added into a Min-Priority Queue
by using such labels as their keys. By doing this, we can dequeue
a vertex from the Min-Priority Queue for each time to “jumping”
over not-affected vertices efficiently. Further, three colors are used
to indicate the different status for each vertex 𝑣in a graph:
• white: 𝑣has initial status, 𝑣/∈𝑉∗∧𝑣/∈𝑉+.
• black: 𝑣is traversed and identified as a candidate vertex,
𝑣∈𝑉∗∧𝑣∈𝑉+.
• gray: 𝑣is traversed and identified impossible to be a candi-
date vertex, 𝑣/∈𝑉∗∧𝑣∈𝑉+ ≡𝑣∈V + \ V ∗
Before executing, we assume that for all vertices 𝑣∈𝑉( ®𝐺)
their d+
out and d∗
in are correctly maintained, that is 𝑣.d+
out =
|𝑣.post| ∧𝑣.d∗
in = 0. Initially, both 𝑉∗and 𝑉+ are empty (all
vertices are white) and 𝐾is initialized to 𝑢.𝑐𝑜𝑟𝑒since 𝑢⪯𝑣for
𝑢↦→𝑣(line 1). After inserting an edge 𝑢↦→𝑣with 𝑢⪯𝑣in O, we
have 𝑢.d+
out increase by one (line 2). The algorithm will terminate
if 𝑢.d+
out ≤𝑢.core as Lemma 4.1 is satisfied (line 3). Otherwise, 𝑢
is added into the Min-Priority Queue 𝑄(line 4) for propagation
(line 5 to 8). For each 𝑤removed from 𝑄(line 6), we check the
value of 𝑤.d∗
in + 𝑤.d+
out. That is, if 𝑤.d∗
in + 𝑤.d+
out > 𝐾, vertex
𝑤can be added to 𝑉∗and may cause other vertices added in 𝑉∗,
which is processed by the Forward procedure (line 7). Otherwise,
𝑤cannot be added to 𝑉∗, which may cause some vertices to be
removed from 𝑉∗processed by the Backward procedure (line 8).
Here, 𝑤.d∗
in > 0 means 𝑤is affected, or else 𝑤can be omitted since
𝑤has no predecessors in 𝑉∗(line 8). When 𝑄is empty, this process
terminates and 𝑉∗is obtained (line 5). At the ending phase, for all
vertices 𝑉∗, their core numbers are increased by one (by Theorem
2.1) and their d∗
in are reset (line 9). Finally, the O is maintained (line
10).
Algorithm 2: EdgeInsert( ®𝐺, O,𝑢↦→𝑣)
input :A DAG ®𝐺(𝑉, ®𝐸); the corresponding O; an edge 𝑢↦→𝑣to
be inserted.
output:An updated DAG ®𝐺(𝑉, ®𝐸); the updated O.
1 𝑉∗,𝑉+, 𝐾←∅, ∅,𝑢.core
// all vertices are white
2 insert 𝑢↦→𝑣into ®𝐺with 𝑢.d+
out ←𝑢.d+
out + 1
3 if 𝑢.d+
out ≤𝐾then return
4 𝑄←a min-priority queue by O; 𝑄.enqueue(𝑢)
5 while 𝑄̸ = ∅do
6
𝑤←𝑄.𝑑𝑒𝑞𝑢𝑒𝑢𝑒()
7
if 𝑤.d∗
in + 𝑤.d+
out > 𝐾then Forward(𝑤,𝑄, 𝐾)
8
else if 𝑤.d∗
in > 0 then Backward(𝑤, O, 𝐾)
// Ending Phase
9 for 𝑤∈𝑉∗do 𝑤.core ←𝐾+ 1; 𝑤.d∗
in ←0
10 for 𝑤∈𝑉∗do remove 𝑤from O𝐾and insert 𝑤at the beginning
of O𝐾+1 in 𝑘-order (the order 𝑤added into 𝑉∗)
The detailed steps of the Forward procedure are shown in Al-
gorithm 3. At first, 𝑢is added to 𝑉∗and 𝑉+ (set from white to
black) since 𝑢has 𝑢.d∗
in + 𝑢.d+
out > 𝐾(line 1). Then, for each 𝑢’s
successors 𝑣whose core numbers equals to 𝐾(by Theorem 2.2),
𝑣.d∗
in is increased by one (lines 2 and 3). In this case, 𝑣is affected
and has to be added into 𝑄for subsequent propagation (line 4).
Algorithm 3: Forward(𝑢,𝑄, 𝐾)
1 𝑉∗←𝑉∗∪{𝑢}; 𝑉+ ←𝑉+ ∪{𝑢}
// 𝑢is white to black
2 for 𝑣∈𝑢.𝑝𝑜𝑠𝑡: 𝑣.core = 𝐾do
3
𝑣.d∗
in ←𝑣.d∗
in + 1
4
if 𝑣/∈𝑄then 𝑄.𝑒𝑛𝑞𝑢𝑒𝑢𝑒(𝑣)
The detail steps of the Backward procedure are shown in Algo-
rithm 4. In the DoPre(𝑢) procedure, for all 𝑢’s predecessors 𝑣that
are located in 𝑉∗(line 11), 𝑣.d+
out is decreased by one since 𝑢is set
to gray and cannot be added into𝑉∗any more (line 12); in this case,
𝑣has to be added into 𝑅for propagation if 𝑣.d∗
in + 𝑣.d+
out ≤𝐾(line
13). Similarly, in the DoPost(𝑢) procedure, for all 𝑢’s successors 𝑣
that have 𝑣.d∗
in > 0 (line 15), 𝑣.d∗
in is decreased by one (line 16)
and added into 𝑅for propagation if 𝑣.d∗
in + 𝑣.d+
out ≤𝐾(lines 17
and 18).
The detailed steps of the Backward procedure are shown in
Algorithm 4. The queue 𝑅is used for propagation (line 2). The
DoPre(𝑢) procedure updates the graph when setting 𝑢from white
to gray or from black to gray, that is, for all 𝑢’s predecessors in
𝑉∗, all d+
out are off by 1 and then added to 𝑅for propagation, if
its d∗
in + d+
out ≤𝐾since they can not be in 𝑉∗any more (lines
10 - 13). Similarly, the DoPost procedure updates the graph when
setting 𝑢from black to gray, that is, for all 𝑢’s successors with
d∗
in > 0, all d∗
in are off by 1 and then added to 𝑅for propagation
if it is in 𝑉∗and and its d∗
in + 𝑑𝑒𝑔𝑜𝑢𝑡≤𝐾(lines 14 - 18). Now,
we explain the algorithm step by step. At first, 𝑤is just added to
𝑉+ (set from white to gray) since 𝑤has 𝑤.d∗
in + 𝑤.d+
out ≤𝐾
(line 1). The queue 𝑅is initialized as empty for propagation (line 2)
and 𝑤is propagated by the DoPre procedure. Of course, 𝑤’s d+
out
and d∗
in are updated (line 3) since all black vertices causing 𝑤.d∗
in
increased will be moved after 𝑤in O eventually. All the vertices in
𝑅are black waiting to be propagated (lines 4 to 9). For each 𝑢∈𝑅,
vertex 𝑢is removed from 𝑅(line 5) and removed from 𝑉∗, which
sets 𝑢from black to gray (line 6). This may require d∗
in and d+
out
of adjacent vertices to be updated, which is done by the procedures
DoPre and DoPost, respectively (line 7). To maintain O𝐾, 𝑢is first
removed from O𝐾and then inserted after 𝑝in O𝐾, where 𝑝initially
is 𝑤or the previous moved vertices in O𝐾(line 8). Of course, 𝑢’s
d+
out and d∗
in are updated (line 3) since all black vertices causing
𝑢.d∗
in increased will be moved after 𝑤in O eventually. This process
is repeated until 𝑅is empty (lines 4 to 9).
Example 4.1. Consider inserting an edge to a constructed graph
in Figure 2 obtained from Figure 1. The number inside the vertices
are the core numbers, and the two numbers beside the vertices
𝑢1,𝑢2,𝑢3 and 𝑢500 are their d∗
in + d+
out. Initially, we have the min-
priority queue 𝑄= ∅and 𝐾= 1. In Figure 2(a), after inserting
an edge 𝑢1 ↦→𝑢500, we get 𝑢1.d+
out = 2
>
𝐾and therefore
𝑢1 is add to 𝑄as 𝑄= {𝑢1}. We begin to propagate 𝑄. First, in
6

---

Algorithm 4: Backward(𝑤, O, 𝐾)
1 𝑉+ ←𝑉+ ∪{𝑤}; 𝑝←𝑤
// 𝑤is white to gray
2 𝑅←an empty queue; DoPre(𝑤)
3 𝑤.d+
out ←𝑤.d+
out + 𝑤.d∗
in; 𝑤.d∗
in ←0
4 while 𝑅̸ = ∅do
5
𝑢←𝑅.𝑑𝑒𝑞𝑢𝑒𝑢𝑒()
6
𝑉∗←𝑉∗\ {𝑢}
// 𝑢is black to gray
7
DoPre(𝑢); DoPost(𝑢)
8
DELETE (O𝐾,𝑢); INSERT(O𝐾, 𝑝,𝑢); 𝑝←𝑢
9
𝑢.d+
out ←𝑢.d+
out + 𝑢.d∗
in; 𝑢.d∗
in ←0
10 procedure DoPre(𝑢)
11
for 𝑣∈𝑢.pre : 𝑣∈𝑉∗do
12
𝑣.d+
out ←𝑣.d+
out −1
13
if 𝑣.d∗
in + 𝑣.d+
out ≤𝐾∧𝑣/∈𝑅then 𝑅.𝑒𝑛𝑞𝑢𝑒𝑢𝑒(𝑣)
14 procedure DoPost(𝑢)
15
for 𝑣∈𝑢.post : 𝑣.d∗
in > 0 do
16
𝑣.d∗
in ←𝑣.d∗
in −1
17
if 𝑣∈𝑉∗∧𝑣.d∗
in + 𝑣.d+
out ≤𝐾∧𝑣/∈𝑅then
18
𝑅.𝑒𝑛𝑞𝑢𝑒𝑢𝑒(𝑣)
2
2
1
1
1
1
1
2
:
,
,
, ...
O1 u1 u2 u3
u2
u1
v2
u3
u4
u1000
v1
v3
1
u5
...
u500
1
:
,
,
O2 v1 v2 v3
...
(a)
2
2
1
1
1
1
1
2
:
,
,
,
,
, ...,
, ...,
O1 u3 u2 u1 u4 u5
u500
u1000
u2
u1
v2
u3
u4
u1000
v1
v3
1
u5
...
u500
1
:
,
,
O2 v1 v2 v3
...
(e)
0+2
1+1
0+0
0+1
0+1
0+1
1+1
0+1
1
1
1
u2
u1
u3
0+2
1+1
1+0
(b)
1
1
1
u2
u1
u3
0+2
1+0
0+1
(c)
Text
1
1
1
u2
u1
u3
(d)
0+2
0+1
0+1
:
,
,
,
,
, ...,
, ...,
O1 u1 u2 u3 u4 u5
u500
u1000
:
,
,
, ...
O1 u1 u2 u3
:
,
,
, ...
O1 u1 u3 u2
Figure 2: Insert one edge 𝑢1 ↦→𝑢500 to a constructed graph ®𝐺
obtained from Figure 1.
Figure 2(a), 𝑢1 is removed from 𝑄to do the Forward procedure
since 𝑢1.d+
out + 𝑢1.d∗
in = 0 + 2 > 𝐾, by which 𝑢1 is colored by
black, all 𝑢1.post’s d∗
in add by 1, and all 𝑢1.post are put into 𝑄as
𝑄= {𝑢2,𝑢500}. Second, in Figure 2(b), 𝑢2 is removed from 𝑄to do
the Forward procedure since 𝑢2.d+
out + 𝑢2.d∗
in = 1 + 1 > 𝐾, by
which 𝑢2 is colored by black, all 𝑢2.post’s d∗
in add by 1, and all
𝑢1.post are added into 𝑄as 𝑄= {𝑢3,𝑢500}. Third, in Figure 2(c),
however,𝑢3 is removed from 𝑄to do the Backward procedure since
𝑢3.d∗
in + 𝑢3.d+
out = 1 + 0 ≤𝐾, by which 𝑢3 is colored by gray
and we have 𝑄= {𝑢500}.
The Backward procedure continues. In Figure 2(d), we get𝑢2.d+
out
off by 1 and 𝑢2.d∗
in + 𝑢2.d+
out = 1 + 0 ≤𝐾, so that 𝑢2 is set to
gray, by which 𝑢2 is moved after 𝑢3 in O1. In Figure 2(e), we get
𝑢1.d+
out off by 1 and 𝑢1.d∗
in + 𝑢1.d+
out = 0 + 1
≤𝐾, so that
𝑢1 is also set to gray, by which 𝑢1 is moved after 𝑢3 in O1; also,
we get 𝑢500.d∗
in off by 1 and the Backward procedure terminate.
Finally, we still need to check the last 𝑢500 in 𝑄, which can be
safely omitted since its d∗
in is 0. In this simple example, we have
𝑉∗= ∅∧𝑉+ = {𝑢1,𝑢2,𝑢3} and only 4 vertices added to 𝑄. A
large number of vertices in O1, e.g. 𝑢4 . . .𝑢1000, are avoid to be
traversed.
Correctness. The key issue of the Algorithm 2 is to identify the
candidate set 𝑉∗. For the correctness, the algorithm has to be sound
and complete. The soundness implies that all vertices in 𝑉∗are
correctly identified,
𝑠𝑜𝑢𝑛𝑑(𝑉∗) ≡∀𝑣∈𝑉: 𝑣∈𝑉∗⇒𝑣.d∗
in+𝑣.d+
out > 𝐾∧𝑣.core = 𝐾
The completeness implies that all possible candidate vertices are
added into 𝑉∗,
𝑐𝑜𝑚𝑝𝑙𝑒𝑡𝑒(𝑉∗) ≡∀𝑣∈𝑉: 𝑣.d∗
in+𝑣.d+
out > 𝐾∧𝑣.core = 𝐾⇒𝑣∈𝑉∗
The algorithm has to ensure both the soundness and completeness
𝑠𝑜𝑢𝑛𝑑(𝑉∗) ∧𝑐𝑜𝑚𝑝𝑙𝑒𝑡𝑒(𝑉∗),
which is equivalent to
∀𝑣∈𝑉: 𝑣∈𝑉∗≡𝑣.d∗
in + 𝑣.d+
out > 𝐾∧𝑣.core = 𝐾.
To argue the soundness and completeness, we first define the
vertices in𝑉(𝐺) to have correct candidate in-degrees and remaining
out-degrees as
𝑖𝑛∗(𝑉) ≡∀𝑣∈𝑉: 𝑣.d∗
in = |{𝑤∈𝑣.𝑝𝑟𝑒: 𝑤∈𝑉∗}|
𝑜𝑢𝑡+(𝑉) ≡∀𝑣∈𝑉: 𝑣.d+
out = |{𝑤∈𝑣.𝑝𝑜𝑠𝑡: 𝑤/∈𝑉+ \ 𝑉∗}|.
We also define the sequence O for all vertices in 𝑉are in 𝑘-order as
∀𝑣𝑖∈𝑉: O(𝑉) = (𝑣1, 𝑣2, . . . , 𝑣𝑖) ⇒𝑣1 ⪯𝑣2 ⪯. . . ⪯𝑣𝑖
Theorem 4.4 (soundness and completeness). For any con-
structed graph ®𝐺(𝑉, ®𝐸), The while-loop in Algorithm 2 (lines 5 to 8)
terminates with 𝑠𝑜𝑢𝑛𝑑(𝑉∗) and 𝑐𝑜𝑚𝑝𝑙𝑒𝑡𝑒(𝑉∗).
Proof. The invariant of the outer while-loop (lines 5 to 8 in
Algorithm 2) is that all vertices in 𝑉∗are sound, but adding a vertex
to 𝑉∗(white to black) may lead to its successors to be incomplete;
for all vertices, their d∗
in and d+
out counts are correctly maintained.
All vertices in 𝑄have their core numbers as 𝐾and their d∗
in must
be greater or equal to 0, and all vertices 𝑣∈𝑉must be greater than
0 if 𝑣is located in 𝑄; also, the 𝑘-order for all the vertices not in 𝑉∗
is correctly maintained:
𝑠𝑜𝑢𝑛𝑑(𝑉∗) ∧𝑐𝑜𝑚𝑝𝑙𝑒𝑡𝑒(𝑉∗\ 𝑄) ∧𝑖𝑛∗(𝑉) ∧𝑜𝑢𝑡+(𝑉)
∧(∀𝑣∈𝑄: 𝑣.core = 𝐾∧𝑣.d∗
in ≥0)
∧(∀𝑣∈𝑉: 𝑣.d∗
in > 0 ⇒𝑣∈𝑄)
∧O(𝑉\ 𝑉∗)
The invariant initially holds as𝑉∗= ∅and for all vertices their d∗
in,
d+
out and 𝑘-order are correctly initialized; also 𝑢is first add to 𝑄for
propagation only when 𝑢.core = 𝐾∧𝑢.d+
out > 𝐾∧𝑢.d∗
in = 0. We
now argue that the while-loop preserves this invariant:
7

---

– 𝑠𝑜𝑢𝑛𝑑(𝑉∗) is preserved as 𝑣∈𝑉is added to 𝑉∗only if 𝑣.d∗
in +
𝑣.d+
out > 𝐾by the Forward procedure; also, 𝑣is safely removed
from 𝑉∗if 𝑣.d∗
in + 𝑣.d+
out ≤𝐾by the Backward procedure ac-
cording to Theorem 4.3.
– 𝑐𝑜𝑚𝑝𝑙𝑒𝑡𝑒(𝑉∗\𝑄) is preserved as all the affected vertices 𝑣, which
may have 𝑣.d∗
in + 𝑣.d+
out > 𝐾, are added to 𝑄by the Forward
procedure for propagation.
– 𝑖𝑛∗(𝑉) is preserved as each time when a vertex 𝑣is added to
𝑉∗, all its successors’ d∗
in are increased by 1 in the Forward
procedure; also each time when a vertex 𝑣cannot be added to
𝑉∗, the O may change Backward procedure.
– 𝑜𝑢𝑡∗(𝑉) is preserved as each time when a vertex 𝑣cannot be
added to 𝑉∗, the O may change and the corresponding d+
out are
correctly maintained by the Backward procedure.
– (∀𝑣∈𝑄: 𝑣.core = 𝐾∧𝑣.d∗
in ≥0) is preserved as in the Forward
procedure, the vertices 𝑣are added in 𝑄only if 𝑣.𝑐𝑜𝑟𝑒= 𝐾with
𝑣.d∗
in add by 1; but 𝑣.d∗
in may be reduced to 0 in the Backward
procedure when some vertices cannot in 𝑉∗.
– (∀𝑣∈𝑉: 𝑣.d∗
in > 0 ⇒𝑣∈𝑄) is preserved as 𝑣can be added in
𝑄only after adding 𝑣.d∗
in by 1 in the Forward procedure.
– O(𝑉\𝑉∗) is preserved as the 𝑘-order of all vertices 𝑣∈V + \ V ∗
is correctly maintained by the Backward procedure and the 𝑘-
order of all the other vertices 𝑣∈𝑉\ 𝑉+ is not affected.
We also have to argue the invariant of the inner while-loop in the
Backward procedure (lines 4 to 9 in Algorithm 4). The additional
invariant is that all vertices in 𝑅has to be located in 𝑉∗but not
sound as their d∗
in + d+
out ≤𝐾:
𝑠𝑜𝑢𝑛𝑑(𝑉∗\ 𝑅) ∧𝑐𝑜𝑚𝑝𝑙𝑒𝑡𝑒(𝑉∗\ 𝑄) ∧𝑖𝑛∗(𝑉) ∧𝑜𝑢𝑡+(𝑉)
∧(∀𝑣∈𝑅: 𝑣.𝑐𝑜𝑟𝑒= 𝐾∧𝑣∈𝑉∗∧𝑣.d∗
in + 𝑣.d+
out ≤𝐾)
∧(∀𝑣∈𝑄: 𝑣.𝑐𝑜𝑟𝑒= 𝐾∧𝑣.d∗
in ≥0)
∧(∀𝑣∈𝑉: 𝑣.d∗
in > 0 ⇒𝑣∈𝑄)
∧O(𝑉\ 𝑉∗)
The invariant initially holds as for 𝑤, all its predecessors’ d+
out
are off by 1 and added in 𝑅if their d∗
in + d+
out ≤𝐾since 𝑤is
identified in V + \ V ∗(gray). We have 𝑤⪯all vertices in 𝑉∗in
O, denoted as 𝑤⪯𝑉∗, as 1) 𝑣can be moved to the head of O𝐾+1
and 𝑣.core is add by 1 if 𝑣is still in 𝑉∗when the outer while-loop
terminated, and 2) 𝑣is removed from 𝑉∗and moved after 𝑤in
𝑂𝐾. In this case, 𝑤.d+
out and 𝑤.d∗
in are can be correctly updated
to (𝑤.d+
out + 𝑤.d∗
in) and 0, respectively. We now argue that the
while-loop preserves this invariant:
– 𝑠𝑜𝑢𝑛𝑑(𝑉∗\ 𝑅) is preserved as all 𝑣∈𝑉∗are added to 𝑅if 𝑣.d∗
in +
𝑣.d+
out ≤𝐾.
– 𝑖𝑛∗(𝑉) is preserved as each time for a vertex 𝑢∈𝑅setting from
black to gray, for all its affected successor, which have d∗
in > 0,
their d∗
in are off by 1; also, 𝑢.d∗
in is set to 0 when setting from
black to gray since 𝑢⪯all vertices in 𝑉∗in the changed O.
– 𝑜𝑢𝑡∗(𝑉) is preserved as each time for a vertex 𝑢∈𝑅setting from
black to gray, for all its affected predecessor, which are in 𝑉∗,
their d+
out are off by 1; also, 𝑢.d+
out is set to 𝑢.d+
out +𝑢.d∗
in since
𝑢⪯all vertices in 𝑉∗in the changed O.
– (∀𝑣∈𝑅: 𝑣.𝑐𝑜𝑟𝑒= 𝐾∧𝑣∈𝑉∗∧𝑣.d∗
in + 𝑣.d+
out ≤𝐾) is preserved
as each time for a vertex 𝑣∈𝑉∗, 𝑣is checked when 𝑣.d∗
in or
𝑣.d+
out is off by 1, and 𝑣is added to 𝑅if 𝑣.d∗
in + 𝑣.d+
out ≤𝐾.
– O(𝑉\ 𝑉∗) is preserved as each vertex 𝑣that removed from 𝑉∗
by pealing are moved following 𝑝in 𝑂𝐾, where 𝑝is 𝑤or the
previous vertex removed from 𝑉∗.
At the termination of the inner while-loop, we get 𝑅= ∅. At the
termination of the outer while-loop, we get 𝑄= ∅. The postcondi-
tion of the outer while-loop is 𝑠𝑜𝑢𝑛𝑑(𝑉∗) ∧𝑐𝑜𝑚𝑝𝑙𝑒𝑡𝑒(𝑉∗).
□
At the ending phase of Algorithm 2, the core numbers of all
vertices in 𝑉∗are add by 1, and O in 𝑘-order is maintained. On
the termination of Algorithm 2, the core numbers are correctly
maintained and also O(𝑉) ∧𝑖𝑛∗(𝑉) ∧𝑜𝑢𝑡+(𝑉), which provide
correct initial state for the next edge insertion.
Complexity.
Theorem 4.5. The time complexity of the simplified order-based
insertion algorithm is 𝑂(|𝐸+|· log|𝐸+|) in the worst case, where |𝐸+|
is the number of adjacent edges for all vertices in 𝑉+ defined as
|𝐸+|= P
𝑣∈𝑉+ 𝑣.deg.
Proof. As the definition of 𝑉+, it includes all traversed vertices
to identify 𝑉∗. In the Forward procedure, the vertices in 𝑉+ are
traversed at most once, so do in the Backward procedure, which
requires worst-case 𝑂(|𝐸+|) time. In the while-loop (Algorithm
2 lines 5 - 10), the min-priority queue 𝑄includes at most |𝐸+|
vertices since each related edge of vertices in 𝑉+ is added into
𝑄at most once. The min-priority queue can be implemented by
min-heap, which requires worst-case 𝑂(|𝐸+|· log|𝐸+|) time to de-
queue all the values. All the vertices in O are maintained with Order
Data Structure, so that manipulating the order of one vertex re-
quires amortized 𝑂(1) time; there are totally at most |𝑉+| vertices
whose order are manipulated, which requires worst-case 𝑂(|𝑉+|)
amortized time. Therefore, the total worst-case time complexity is
𝑂(|𝐸+|+|𝐸+|· log|𝐸+|+|𝑉+|) = 𝑂(|𝐸+|· log|𝐸+|).
□
Theorem 4.6. The space complexity of the simplified order-based
insertion algorithm is 𝑂(𝑛) in the worst-case.
Proof. Each vertex 𝑣is assigned three counters that are 𝑣.core,
𝑣.d∗
in and 𝑣.d+
out, which requires 𝑂(3𝑛) space. Both 𝑄and 𝑅have
at most 𝑛vertices, respectively, which require worst-case 𝑂(2𝑛)
space together. Two arrays are required for 𝑉+ and 𝑉∗, which
requires worst-case 𝑂(2𝑛) space. All vertices in O are maintained
by Order Data Structure. For this, all vertices are linked by double
linked lists, which requires 𝑂(2𝑛) space; also, vertices are assigned
labels (typically 64 bits integer) to indicate the order, which requires
𝑂(2𝑛) space. Therefore, the total worst-case space complexity is
𝑂(3𝑛+ 2𝑛+ 2𝑛+ 2𝑛+ 2𝑛) = 𝑂(𝑛).
□
4.2
The Simplified Order-Based Removal
Our simplified order-based removal Algorithm is mostly the same
as the original order-based removal Algorithm in [18, 24], so that
the details are omitted in this section. The only difference is that our
simplified order-based removal algorithm adopts the Order Data
Structure to maintain O, instead of the complicated A and B data
structures [24]. In this case, the worst-case time complexity can
8

---

be improved as the Order Data Structure only requires amortized
𝑂(1) time for each order operation.
Complexities.
Theorem 4.7. The time complexity of the simplified order-based
removal algorithm is 𝑂(Deg(𝐺) + |𝐸∗|) in the worst case, where
|𝐸∗|= P
𝑤∈V ∗𝑤.𝑑.
Proof. Typically, the data graph 𝐺is stored by adjacent lists.
For removing an edge (𝑢, 𝑣), all edges of the vertex 𝑢and 𝑣are
sequentially traversed, which require at most 𝑂(Deg(𝐺)) time.
We know that 𝑉+ includes all traversed vertices to identify the
candidate set 𝑉∗and 𝑉∗= 𝑉+ in this algorithm. The vertices in
𝑉∗are traversed at most once, which requires worst-case 𝑂(|𝐸∗|)
time. All vertices in 𝑉∗are removed from the O𝐾and appended
to O𝐾−1 in 𝑘-order, which require 𝑂(|𝑉∗|) time as each insert or
remove operation only needs amortized 𝑂(1) time by the Order
Data Structure. Since it is possible that Deg(𝐺) > |𝐸∗| in some cases
like 𝑉∗= ∅, the total worst-case time complexity is 𝑂(Deg(𝐺) +
|𝐸∗|+|𝑉∗|) = 𝑂(Deg(𝐺) + |𝐸∗|).
□
Theorem 4.8. The space complexity of the simplified order-based
removal algorithm is 𝑂(𝑛) in the worst-case.
Proof. For each vertex 𝑣in the graph, 𝑣.mcd is used to identify
the 𝑉∗, which requires 𝑂(𝑛) space. All vertices in O are maintained
by Order Data Structure, which requires 𝑂(4𝑛) space. A queue is
used for the propagation, which require worst-case 𝑂(𝑛) space.
One array is required for 𝑉∗, which requires 𝑂(𝑛) space. Therefore,
the total worst-case space is 𝑂(𝑛+ 4𝑛+ 𝑛+ 𝑛) = 𝑂(𝑛).
□
5
THE SIMPLIFIED ORDER-BASED BATCH
INSERTION
In practice, it is common that a great number of edges are inserted
into a graph together. If multiple edges are inserted one by one,
the vertices in V + \ V ∗may be repeatedly traversed. Instead of
inserting one by one, we can handle the edge insertion in batch. In
this section, we extend our simplified order-based unit insertion
algorithm to batch insertion.
Let ∆𝐺= (𝑉, ∆𝐸) be an inserted graph to a constructed DAG
®𝐺. That is, ∆𝐸(∆𝐺) contains a batch of edges that will be inserted
to ®𝐺. Each edge 𝑢↦→𝑣∈∆𝐸satisfies 𝑢⪯𝑣in the 𝑘-order of ®𝐺.
Theorem 5.1. After inserted a graph ∆𝐺= (𝑉, ∆𝐸) to con-
structed DAG ®𝐺= (𝑉, ®𝐸), the core number of a vertex 𝑣∈𝑉( ®𝐺)
increases by at most 1 if 𝑣satisfies |𝑣.𝑝𝑜𝑠𝑡|≤𝑣.core + 1.
Proof. For each 𝑣∈𝑉( ®𝐺), Lemma 4.1 proves that the out-
degree of 𝑣satisfies |𝑣.post|≤𝑣.core. Analogies, when inserting
∆𝐺into ®𝐺with |𝑣.post|≤𝑣.core + 1, the core number can be
increased by at most 1, as after inserting the new graph has to
satisfy 𝑣.𝑑𝑜𝑢𝑡≤𝑣.core for all vertices 𝑣∈𝑉( ®𝐺).
□
Theorem 5.1 suggests that each round we can insert multiples
edges 𝑢↦→𝑣∈∆𝐸into ®𝐺only if |𝑢( ®𝐺).post|≤𝑢( ®𝐺).𝑐𝑜𝑟𝑒+ 1;
otherwise, 𝑢↦→𝑣has to be inserted in next round until all edges
are inserted. In the worst-case, there are Deg(∆𝐺) round required
if each edges 𝑢↦→𝑣∈∆𝐸satisfy 𝑢( ®𝐺).d+
out = 𝑢( ®𝐺).core.
The Algorithm. Algorithm 5 shows the detailed steps. A batch of
edges 𝑢↦→𝑣∈∆𝐸can be inserted into ®𝐺only if 𝑢.d+
out ≤𝑢.core
(lines 3 and 4). When 𝑢.d+
out = 𝑢.core + 1, we can put 𝑢into
the Min-Priority Queue 𝑄for propagation (line 5). Of course, the
inserted edges are removed from ∆𝐺(line 6). After all possible
edges are inserted, the propagation is the same as in lines 5 - 10 of
Algorithm 2 (line 7), where 𝐾is the core numbers of local 𝑘-subcore
with 𝐾= 𝑢.core ≤𝑣.core for an inserted edge 𝑢↦→𝑣. This process
repeatedly continues until the ∆𝐺becomes empty (line 1).
Algorithm 5: BatchEdgeInsert( ®𝐺, O, ∆𝐺)
input :A constructed DAG ®𝐺= (𝑉, ®𝐸); the corresponding O; An
inserted graph Δ𝐺= (𝑉, Δ𝐸).
output:A updated DAG ®𝐺(𝑉, ®𝐸); A updated O.
1 while Δ𝐺̸ = ∅do
2
𝑉∗,𝑉+,𝑄←∅, ∅, a min-priority queue by O
3
for 𝑢↦→𝑣∈Δ𝐸(Δ𝐺) : 𝑢.d+
out ≤𝑢.core do
4
insert 𝑢↦→𝑣into ®𝐺with 𝑢.d+
out ←𝑢.d+
out + 1
5
if 𝑢.d+
out = 𝑢.core + 1 then 𝑄.𝑒𝑛𝑞𝑢𝑒𝑢(𝑢)
6
remove 𝑢↦→𝑣from Δ𝐺
7
same code as lines 5 - 10 in Algorithm 2 with 𝐾as the core
number of local subcore
2
2
1
1
1
2
:
,
,
,
, ...,
, ...,
O1 u1 u3 u2 u4
u500
u1000
u2
u1
v2
u3
v1
v3
:
,
,
O2 v1 v2 v3
(a)
2
2
2
2
1
1
1
2
:
,
,
, ...,
, ...,
O1 u3 u4 u5
u500
u1000
u2
u1
v2
u3
u4
u1000
v1
v3
1
v5
...
u500
1
:
,
,
,
,
O2 u1 u2 v1 v2 v3
...
(d)
Text
0+2
0+2
0+2
1+1
0+1
:
,
,
, ...
O1 u1 u2 u3
1
1
1
u2
u1
u3
0+2
1+2
0+0
(b)
1
1
1
u2
u1
u3
0+2
1+1
0+1
(c)
:
,
,
, ...
O1 u1 u2 u3
1
1
u4
u1000
1
v5
...
u500
1
...
Figure 3: Insert a batch of two edges 𝑢1 ↦→𝑣2 and 𝑢2 ↦→𝑣2 to
a constructed graph ®𝐺obtained from Figure 1.
Example 5.1. Consider inserting two edges in the constructed
graph in Figure 3. Initially, the Min-Priority Queue 𝑄is empty and
𝐾is the core number of the corresponding 𝑘-subcore. In Figure 3(a),
after inserting two edges, 𝑢1 ↦→𝑣2 and 𝑢2 ↦→𝑣2, we get 𝑢1.d+
out =
𝐾+ 1 = 2 and 𝑢2.d+
out = 𝐾+ 1 = 2, so that these two edges can
be inserted in batch and we put 𝑢1 and 𝑢2 in 𝑄as 𝑄= {𝑢1,𝑢2}.
We begin to propagate 𝑄. First, in Figure 3(a), 𝑢1 is removed from
9

---

𝑄to do the Forward procedure since 𝑢1.d∗
in + 𝑢1.d+
out = 0 + 2 >
𝐾= 1, by which 𝑢1 is colored by black; within subcore sc(𝑢1),
all 𝑢1.post’s d∗
in are added by 1, and all 𝑢1.post are put in 𝑄as
𝑄= {𝑢2}. Second, in Figure 3(b), 𝑢2 is removed from 𝑄to do the
Forward procedure since 𝑢2.d∗
in + 𝑢2.d+
out = 0 + 2 > 𝐾= 1, by
which 𝑢2 is colored by black; within subcore sc(𝑢2), all 𝑢2.post’s
d∗
in are added by 1, and all 𝑢2.post are put in 𝑄as 𝑄= {𝑢3}. Third,
in Figure 3(c), 𝑢3 is removed from 𝑄to do the Backward procedure
since 𝑢3.d∗
in + 𝑢3.d+
out = 1 + 0 ≤𝐾= 1, by which 𝑢3 is colored
by black and 𝑢2.d+
out off by 1; however, since 𝑢2.d∗
in +𝑢2.d+
out =
1+1 > 𝐾= 1, we have 𝑢2 still black and the Backward procedure
terminates. Finally, in Figure 3(d), two black vertices, 𝑢1 and 𝑢2,
have increased core numbers as 2; then, they are removed from O1
and inserted before the head of O2 to maintain the 𝑘-order.
In this example, we have 𝑉∗= {𝑢1,𝑢2} ∧𝑉+ = {𝑢1,𝑢2,𝑢3}
by batch inserting two edges together. If we insert 𝑢1 ↦→𝑣2 first
and then insert 𝑢2 ↦→𝑣2 second, the final 𝑉∗is same; but 𝑉+ is
{𝑢1,𝑢2,𝑢3} and {𝑢2,𝑢3} for two inserted edges, respectively. In
this case, both 𝑢2 and 𝑢3 are repeatedly traversed, which can be
avoided by batch insertion.
Correctness. For each round of the while-loop (lines 2 - 7), the
correctness argument is totally the same as the single edge insertion
in Algorithm 2.
Complexities. The total worst-case running time of line 7 is the
same as in Algorithm 2, which is 𝑂(|𝐸+|· log|𝐸+|). Typically, for
𝑄, the running time of enqueue and dequeue are larger than in
Algorithm 2 since each time numerous vertices can be initially
added into 𝑄for propagation (line 5). The outer while-loop (line 1)
run at most ∆𝐸rounds, so that ∆𝐸is checked at most𝑂(Deg(∆𝐺)·
|∆𝐸|) round as O can be changed and thus the directions of edges in
∆𝐸can be changed. Typically, the majority of edges can be inserted
in the first round of while-loop. Therefore, the time complexity
of Algorithm 5 is 𝑂(|𝐸+|· log|𝐸+|+Deg(∆𝐺) · |∆𝐸|) in the worst
case.
The space complexity of Algorithm 5 is the same as Algorithm 2.
6
RELATED WORK
Core Decomposition. In [4], Cheng et al. propose an external
memory algorithm, so-called EMcore, which runs in a top-down
manner such that the whole graph does not have to be loaded
into memory. In [20], Wen et al. provide a semi-external algorithm,
which requires 𝑂(𝑛) size memory to maintain the information of
vertices. In [9], Khaouid et al. investigate the core decomposition
in a single PC over large graphs by using GraphChi and WebGraph
models. In [15], Montresoret et al. consider the core decomposition
in a distributed system. In addition, Parallel computation of core
decomposition in multi-core processors is first investigated in [5],
where the ParK algorithm was proposed. Based on the main idea
of ParK, a more scalable PKC algorithm has been reported in [8].
Core Maintenance. In [11], an algorithm that similar to traversal
algorithm [18] is given, but this solution has quadratic time com-
plexity. In [20], a semi-external algorithm for core maintenance
is proposed in order to reduce the I/O cost, but this method is
not optimized for CUP time. In [7, 19], parallel approaches for
core maintenance is proposed for both edge insertion and removal.
There exists some research based on core maintenance. In [22], the
authors study computing all 𝑘-cores in the graph snapshot over
the time window. In [12], the authors explore the hierarchy core
maintenance.
7
EXPERIMENTS
In this section, we conduct experimental studies using 12 real and
synthetic graphs and report the performance of our algorithm by
comparing with the original order-based method:
– The order-based algorithm [24] with unit edge insertion (I) and
edge removal (R); Before running, we execute the initialization
(Init) step.
– Our simplified order-based with unit edge insertion (OurI) and
edge removal (OurR); Before running, we execute the initializa-
tion (OurInit) step.
– Our simplified order-based batch edge insertion (OurBI).
The experiments are performed on a desktop computer with an
Intel CPU (4 cores, 8 hyperthreads, 8 MB of last-level cache) and
16 GB main memory. The machine runs the Ubuntu Linux (18.04)
operating system. All tested algorithms are implemented in C++
and compiled with g++ version 7.3.0 with the -O3 option. All im-
plementations and results are available at github1.
Tested Graphs. We evaluate the performance of different meth-
ods over a variety of real-world and synthetic graphs, which are
shown in Table 2. For simplicity, directed graphs are converted to
undirected ones in our testing; all of the self-loops and repeated
edges are removed, that is, a vertex can not connect to itself and
each pair of vertices can connect with at most one edge. The livej,
patent, wiki-talk, and roadNet-CA graphs are obtained from SNAP2.
The dbpedia, baidu, pokec and wiki-talk-en wiki-links-en graphs are
collected from the KONECT3 project. The ER, BA, and RMAT graphs
are synthetic graphs; they are generated by the SNAP4 system us-
ing Erdös-Rényi, Barabasi-Albert, and the R-MAT graph models,
respectively. For these generated graphs, the average degree is fixed
to 8 by choosing 1,000,000 vertices and 8,000,000 edges.
Table 2: Tested real and synthetic graphs.
Graph
𝑛
𝑚
AvgDeg
Max 𝑘
livej
4,847,571
68,993,773
14.23
372
patent
6,009,555
16,518,948
2.75
64
wikitalk
2,394,385
5,021,410
2.10
131
roadNet-CA
1,971,281
5,533,214
2.81
3
dbpedia
3,966,925
13,820,853
3.48
20
baidu
2,141,301
17,794,839
8.31
78
pokec
1,632,804
30,622,564
18.75
47
wiki-talk-en
2,987,536
24,981,163
8.36
210
wiki-links-en
5,710,993
130,160,392
22.79
821
ER
1,000,000
8,000,000
8.00
11
BA
1,000,000
8,000,000
8.00
8
RMAT
1,000,000
8,000,000
8.00
237
In Table 2, we can see all graphs have millions of edges, their
average degrees are ranged from 2.1 to 22.8, and their maximal core
1https://github.com/Itisben/SimplifiedCoreMaint.git
2http://snap.stanford.edu/data/index.html
3http://konect.cc/networks/
4http://snap.stanford.edu/snappy/doc/reference/generators.html
10

---

numbers range from 3 to 821. For each tested graph, the distribution
of core numbers for all the vertices is shown in Figure 4, where the
x-axis is the core numbers, and the y-axis is the size of vertices. For
most graphs, many vertices have small core numbers, and few have
large core numbers. Specifically, wiki-link-en has the maximum
core numbers up to 821, so that for most of its O𝑘the sizes are
around 1000; BA has a single core number as 8 so that all vertices
are in the single O𝑘. Since all vertices with core number 𝑘in O𝑘are
maintained in 𝑘-order, the size of O𝑘is related to the performance
of different methods.
0
200
400
600
800
1000
core numbers
100
101
102
103
104
105
106
size of vertices
livej
wiki-talk-en
wiki-links-en
0
50
100
150
200
250
core numbers
101
102
103
104
105
106
size of vertices
baidu
wikitalk
RMAT
0
20
40
60
80
core numbers
100
101
102
103
104
105
106
size of vertices
patent
dbpedia
pokec
0
2
5
7
10
12
core numbers
101
102
103
104
105
106
size of vertices
roadNet-CA
ER
BA
Figure 4: The distribution of core numbers.
7.1
Running Time Evaluation
In this experiment, we compare the performance of our simplified
order-based method (OurI and OurR) with the original order-based
method (I and R). For each tested graph, we first randomly select
100,000 edges out of each tested graph. For each graph, we measure
the accumulated time for inserting or removal these 100,000 edges.
Each test runs at least 50 times, and we calculate the means with
95% confidence intervals.
The results for edge insertion are shown in Figure 5(a). We can
see OurI outperforms I over all tested graphs. Specifically, Table
3 shows the speedups of OurI vs. I, which ranges from 1.29 to
7.69. The reason is that the sequence O𝑘in 𝑘-order is maintained
separately for each core number𝑘. Each time insert 𝑣into or remove
𝑣from O𝑘, OurI only requires worst-case 𝑂(1) amortized time
while I requires worst-case 𝑂(log|O𝑘|) time. Therefore, over BA
we can see OurI gains the largest speedup as 7.69 since all vertices
have single one core number with |O8|= 8, 000, 000; over wiki-
links-en we can see OurI gains the smallest speedup as 1.29 since
vertices have core numbers ranging from 0 to 821 such that a large
portion of order lists has |O𝑘| around 1000.
Similarly, we can see that the edge removal has almost the same
trend of speedups in Figure 5(b), which ranges from 1.16 to 5.26 in
Table 3. However, we observe that the speedups of removal may be
less than the insertion over most of the graphs. The reason is that the
edge removal requires fewer order operations compared with the
edge insertion. That is, unlike the edge insertion, it is not necessary
to compare the 𝑘-order for two vertices by ORDER(O,𝑥,𝑦) when
livej
patent
wikitalk
roadNet-CA
dbpedia
baidu
pokec
wiki-talk-en
wiki-links-en
ER
BA
RMAT
0
200
400
600
800
1000
1200
running time (ms)
I
OurI
(a) Edge Insertion
livej
patent
wikitalk
roadNet-CA
dbpedia
baidu
pokec
wiki-talk-en
wiki-links-en
ER
BA
RMAT
0
200
400
600
800
1000
running time (ms)
R
OurR
(b) Edge Removal
Figure 5: Compare the running times of two methods.
reversing the vertices. The main order operations are REMOVE(O,𝑥)
and then INSERT(O,𝑥,𝑦), when the core numbers of vertices𝑥∈𝑉∗
are off by 1.
In Table 3, for the batch insertion, we can see the speedups of
OurBI vs. I is much less then the speedups of OurI vs. I, although
OurBI may have smaller size of 𝑉+ than OurI. One reason is that
OurBI have to traverse inserted graph ∆𝐺at most Deg(∆𝐺) round,
which is the maximum degree of the inserted graph ∆𝐺. The other
reason is that compared with OurI, OurBI has larger size of priority
queue 𝑄, which OurBI requires more running time on enqueue and
dequeue operations.
In Table 3, we also observe that the speedups of OurInit vs.
Init is a little larger than 1. The reason is that for initialization,
most of the running time is spent on computing the core number
for all vertices by the BZ algorithm. After running the BZ algorithm,
OurInit assigns labels for all vertices to construct O in 𝑘-order,
which requires worst-case 𝑂(𝑛) time. However, Init has to add all
vertices to binary search trees, which requires worst-case𝑂(𝑛log𝑛)
time.
7.2
Stability Evaluation
We test the stability of different methods over two selected graphs,
i.e. wikitalk and dbpedia as follows. First, we randomly sample
5, 000, 000 edges and partition into 50 groups, where each group
has totally different 100, 000 edges. Second, for each group, we
measure the accumulated running time of different methods. That
is, the experiments run 50 times and each time has totally different
inserted or removed edges.
11

---

Table 3: Compare the speedups of our method for all graphs.
Graph
OurI vs I
OurBI vs I
OurR vs R
OurInit vs Init
livej
2.04
1.66
1.87
1.02
patent
3.37
2.68
4.41
1.04
wikitalk
1.34
1.63
1.15
1.26
roadNet-CA
4.51
2.95
8.56
1.17
dbpedia
2.49
2.14
1.49
1.08
baidu
1.70
1.68
1.33
1.04
pokec
2.67
2.37
2.87
1.03
wiki-talk-en
1.36
1.45
1.04
1.20
wiki-links-en
1.31
1.16
1.09
1.02
ER
3.97
2.76
9.72
1.08
BA
7.69
5.26
7.42
1.15
RMAT
1.29
1.31
0.97
1.09
Figure 6 shows the results over two selected graphs. We can
see that OurI and OurR outperform I and R, respectively. More
important, the performance of OurI and OurR is as well-bounded
as I and R, respectively. The reason is that I and R are well-bounded
as the variation of 𝑉+ is small for different inserting or removal
edges; also, OurI and OurR have the same size of traversed vertices
𝑉+ and thus have similar well-bounded performance.
0
10
20
30
40
50
repeated times
200
250
300
350
400
running times (ms)
wikitalk
OurI
OurR
I
R
0
10
20
30
40
50
repeated times
200
400
600
800
running times (ms)
dbpedia
OurI
OurR
I
R
Figure 6: The stability of all methods over selected graphs.
7.3
Scalability Evaluation
We test the scalability of different methods over two selected graphs,
i.e., wikitalk and dbpedia. We vary the number of edges expo-
nentially by randomly sampling from 100,000 to 200,000, 400,000,
800,000, 1,600,000, etc. We keep incident vertices of edges for each
sampling to generate the induced subgraphs. Over each subgraph,
we further randomly selected 100,000 edges for insertion or re-
moval. For example, over wikitalk, the first subgraph has 100,000
edges, all of which can be inserted or removed; the last subgraph
has 3,200,000 edges, only 100,000 of which can be inserted or re-
moved. Over each subgraph, we measure the accumulated time for
insertion or removal these 100,000 edges. Each test runs at least 50
times, and we calculate the average running time.
We show the result in Figure 7, where the x-axis is the number
of sampled edges in subgraphs increasing exponentially, and the
y-axis is the running times (ms) for different methods by inserting
or removing 100,000 edges. Table 4 shows the details of scalability
evaluation, where 𝑚′ is the number of edges in subgraphs, #lb is
the number of updated labels used by the Order Data Structures of
our methods, and #rp is the number of outer while-loop repeated
rounds for OurBI. We make several observations as follows:
- In Figure 7, a first look reveals that the running time of OurI
grow more slowly compared with I. The reason is that OurI im-
proves the worst-case running time of each order operation of O𝑘
from 𝑂(log|O𝑘|) to 𝑂(1). In this case, the larger sampled graphs
have the larger size of O𝑘, which can lead to the higher speedups.
However, we can see that the running time of OurR always grows
with a similar trend compared with R. The reason is that a large
percentage of the running time is spent on removing edges from
the adjacent lists of vertices, which requires traversing all the cor-
responding edges. Because of this, even OurR has more efficient
order operations for O than R, the speedups are not obvious.
- In Figure 7, we observe that OurBI sometimes runs faster then
OurI. The reason is as follow. From Table 4, compared with OurI,
OurBI has less traversed vertices (𝑉+), as some repeated traversed
vertices can be avoided; also, OurBI has less number of updated
labels (#lb), as the number of relabel process can be reduced. How-
ever, compared with OurI, OurBI may add much more vertices into
priority queue 𝑄, which cost more running time of enqueue and
dequeue. Also, OurBI may require several times of repeated rounds
(#rp), which may cost extra running time. Typically, this extra
running time is acceptable as most of the edges can be inserted
in the first round, e.g., for dbpedia with 6.4M sampled edges, the
number of batch inserted edges is 100000, 1555, 12, and 0 in four
rounds, respectively. This is why OurBI sometimes runs faster but
sometimes slower compared with OurI.
- In Figure 7, we observe that OurR is always faster than OurI.
The reason is as follow. From Table 4, compared with OurI, OurR has
less number of traversed vertices (𝑉∗), as OurR has 𝑉∗= 𝑉+; OurR
has less number of updated labels (#lb), as vertices are removed
from𝑂𝐾and then appended after𝑂𝐾−1 and thus the relabel process
is not always triggered.
105
106
number of sampled edges
50
100
150
200
250
300
running time (ms)
wikitalk
I
R
OurI
OurR
OurBI
105
106
number of sampled edges
0
100
200
300
400
500
running time (ms)
dbpedia
I
R
OurI
OurR
OurBI
Figure 7: The scalability of all methods over selected graphs.
8
CONCLUSION AND FUTURE WORK
In this work, we study maintaining the 𝑘-core of graphs when in-
serting or removing edges. We simplify the state-of-the-art core
maintenance algorithm and also improve its worst-case time com-
plexity by introducing the classical Order Data Structure. Our sim-
plified approach is easy to understand, implement, and argue the
correctness. The experiments show that our approach significantly
outperforms the existing methods.
In future work, we can parallelize our approach to run on multi-
core machines. The key issue is how to implement the parallel
Order Data Structure efficiently. In particular, we can apply the
core maintenance to large data graphs with billions of vertices like
social networks.
12

---

Table 4: The details of scalability evaluation by varying the
number of sampled edges over wikitalk and dbpedia.
OurI
OurBI
OurR
𝑚′
|𝑉∗|
|𝑉+ |
#lb
|𝑉∗|
|𝑉+ |
#lb
#rp
|𝑉∗|
#lb
0.1M
107K
131K
1.5M
107K
123K
116K
10
107K
107K
0.2M
101K
118K
1.4M
101K
109K
111K
11
101K
101K
0.4M
101K
116K
1.3M
101K
107K
107K
9
101K
101K
0.8M
101K
113K
1.3M
101K
106K
104K
10
101K
101K
1.6M
100K
110K
1.2M
100K
106K
103K
11
100K
100K
3.2M
101K
110K
1.1M
101K
106K
103K
9
101K
101K
0.1M
146K
149K
2.6M
146K
151K
149K
4
146K
146K
0.2M
129K
136K
2.1M
129K
136K
132K
3
129K
129K
0.4M
117K
131K
1.8M
117K
130K
124K
3
117K
117K
0.8M
109K
127K
1.6M
109K
126K
118K
3
109K
109K
1.6M
105K
127K
1.4M
105K
125K
116K
4
105K
105K
3.2M
102K
124K
1.3M
102K
122K
113K
4
102K
102K
6.4M
100K
124K
1.2M
100K
122K
112K
4
100K
100K
REFERENCES
[1] Vladimir Batagelj and Matjaz Zaversnik. 2003. An O(m) Algorithm for Cores
Decomposition of Networks. CoRR cs.DS/0310049 (2003). http://arxiv.org/abs/
cs/0310049
[2] Michael A Bender, Richard Cole, Erik D Demaine, Martin Farach-Colton, and
Jack Zito. 2002. Two simplified algorithms for maintaining order in a list. In
European Symposium on Algorithms. Springer, 152–164.
[3] Kate Burleson-Lesser, Flaviano Morone, Maria S Tomassone, and Hernán A Makse.
2020. K-core robustness in ecological and financial networks. Scientific reports
10, 1 (2020), 1–14.
[4] James Cheng, Yiping Ke, Shumo Chu, and M Tamer Özsu. 2011. Efficient core
decomposition in massive networks. In 2011 IEEE 27th International Conference
on Data Engineering. IEEE, 51–62.
[5] Naga Shailaja Dasari, Ranjan Desh, and Mohammad Zubair. 2014. ParK: An
efficient algorithm for k-core decomposition on multicore processors. In 2014
IEEE International Conference on Big Data (Big Data). IEEE, 9–16.
[6] Paul Dietz and Daniel Sleator. 1987. Two algorithms for maintaining order in a list.
In Proceedings of the nineteenth annual ACM symposium on Theory of computing.
365–372.
[7] Hai Jin, Na Wang, Dongxiao Yu, Qiang Sheng Hua, Xuanhua Shi, and Xia Xie.
2018. Core Maintenance in Dynamic Graphs: A Parallel Approach Based on
Matching. IEEE Transactions on Parallel and Distributed Systems 29, 11 (nov 2018),
2416–2428. https://doi.org/10.1109/TPDS.2018.2835441 arXiv:1703.03900
[8] Humayun Kabir and Kamesh Madduri. 2017. Parallel k-core decomposition on
multicore platforms. In 2017 IEEE International Parallel and Distributed Processing
Symposium Workshops (IPDPSW). IEEE, 1482–1491.
[9] Wissam Khaouid, Marina Barsky, Venkatesh Srinivasan, and Alex Thomo. 2015.
K-core decomposition of large networks on a single PC. Proceedings of the VLDB
Endowment 9, 1 (2015), 13–23.
[10] Yi-Xiu Kong, Gui-Yuan Shi, Rui-Jie Wu, and Yi-Cheng Zhang. 2019. k-core:
Theories and applications. Technical Report. 1–32 pages. https://doi.org/10.1016/
j.physrep.2019.10.004
[11] Rong-Hua Li, Jeffrey Xu Yu, and Rui Mao. 2013. Efficient core maintenance in
large dynamic graphs. IEEE Transactions on Knowledge and Data Engineering 26,
10 (2013), 2453–2465.
[12] Zhe Lin, Fan Zhang, Xuemin Lin, Wenjie Zhang, and Zhihong Tian. 2021. Hi-
erarchical core maintenance on large dynamic graphs. Proceedings of the VLDB
Endowment 14, 5 (2021), 757–770.
[13] Fragkiskos D Malliaros, Christos Giatsidis, Apostolos N Papadopoulos, and
· Michalis Vazirgiannis. 2020. The core decomposition of networks: theory,
algorithms and applications.
The VLDB Journal 29 (2020), 61–92.
https:
//doi.org/10.1007/s00778-019-00587-4
[14] Daniele Miorandi and Francesco De Pellegrini. 2010. K-shell decomposition for
dynamic complex networks. In 8th International Symposium on Modeling and
Optimization in Mobile, Ad Hoc, and Wireless Networks. IEEE, 488–496.
[15] Alberto Montresor, Francesco De Pellegrini, and Daniele Miorandi. 2012. Dis-
tributed k-core decomposition. IEEE Transactions on parallel and distributed
systems 24, 2 (2012), 288–300.
[16] Sen Pei, Lev Muchnik, José S Andrade Jr, Zhiming Zheng, and Hernán A Makse.
2014. Searching for superspreaders of information in real-world social media.
Scientific reports 4 (2014), 5547.
[17] Ahmet Erdem Saríyüce, Buğra Gedik, Gabriela Jacques-Silva, Kun-Lung Wu,
and Ümit V Çatalyürek. 2013. Streaming algorithms for k-core decomposition.
Proceedings of the VLDB Endowment 6, 6 (2013), 433–444.
[18] Ahmet Erdem Sarıyüce, Buğra Gedik, Gabriela Jacques-Silva, Kun-Lung Wu, and
Ümit V Çatalyürek. 2016. Incremental k-core decomposition: algorithms and
evaluation. The VLDB Journal 25, 3 (2016), 425–447.
[19] Na Wang, Dongxiao Yu, Hai Jin, Chen Qian, Xia Xie, and Qiang-Sheng Hua.
2017. Parallel algorithm for core maintenance in dynamic graphs. In 2017 IEEE
37th International Conference on Distributed Computing Systems (ICDCS). IEEE,
2366–2371.
[20] Dong Wen, Lu Qin, Ying Zhang, Xuemin Lin, and Jeffrey Xu Yu. 2016. I/O efficient
core graph decomposition at web scale. In 2016 IEEE 32nd International Conference
on Data Engineering (ICDE). IEEE, 133–144.
[21] Huanhuan Wu, James Cheng, Yi Lu, Yiping Ke, Yuzhen Huang, Da Yan, and
Hejun Wu. 2015. Core decomposition in large temporal graphs. In 2015 IEEE
International Conference on Big Data (Big Data). IEEE, 649–658.
[22] Michael Yu, Dong Wen, Lu Qin, Ying Zhang, Wenjie Zhang, and Xuemin Lin.
2021. On querying historical k-cores. Proceedings of the VLDB Endowment 14, 11
(2021), 2033–2045.
[23] Yikai Zhang and Jeffrey Xu Yu. 2019. Unboundedness and efficiency of truss
maintenance in evolving graphs. In Proceedings of the ACM SIGMOD International
Conference on Management of Data. Association for Computing Machinery, 1024–
1041. https://doi.org/10.1145/3299869.3300082
[24] Yikai Zhang, Jeffrey Xu Yu, Ying Zhang, and Lu Qin. 2017. A fast order-based
approach for core maintenance. In Proceedings - International Conference on Data
Engineering. 337–348. https://doi.org/10.1109/ICDE.2017.93 arXiv:1606.00200
13

---

