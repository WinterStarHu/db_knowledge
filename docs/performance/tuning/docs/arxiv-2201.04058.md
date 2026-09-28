# Atrapos: Real-time Evaluation of Metapath Query Workloads

> 来源: https://arxiv.org/pdf/2201.04058

Atrapos: Evaluating Metapath Query Workloads in Real Time
Serafeim Chatzopoulos
Univ. of the Peloponnese &
IMSI, “Athena” RC
Greece
schatzop@uop.gr
Thanasis Vergoulis
IMSI, “Athena” RC
Greece
vergoulis@athenarc.gr
Dimitrios Skoutas
IMSI, “Athena” RC
Greece
dskoutas@athenarc.gr
Theodore Dalamagas
IMSI, “Athena” RC
Greece
dalamag@athenarc.gr
Christos Tryfonopoulos
Univ. of the Peloponnese
Greece
trifon@uop.gr
Panagiotis Karras
Aarhus University
Denmark
piekarras@gmail.com
ABSTRACT
Heterogeneous information networks (HINs) represent different types
of entities and relationships between them. Exploring, analysing,
and extracting knowledge from such networks relies on metapath
queries that identify pairs of entities connected by relationships
of diverse semantics. While the real-time evaluation of metapath
query workloads on large, web-scale HINs is highly demanding in
computational cost, current approaches do not exploit interrela-
tionships among the queries. In this paper, we present Atrapos,
a new approach for the real-time evaluation of metapath query
workloads that leverages a combination of efficient sparse matrix
multiplication and intermediate result caching. Atrapos selects
intermediate results to cache and reuse by detecting frequent sub-
metapaths among workload queries in real time, using a tailor-made
data structure, the Overlap Tree, and an associated caching policy.
Our experimental study on real data shows that Atrapos acceler-
ates exploratory data analysis and mining on HINs, outperforming
off-the-shelf caching approaches and state-of-the-art research pro-
totypes in all examined scenarios.
1
INTRODUCTION
Heterogeneous information networks (HINs), also known as labeled
property graphs, offer an intuitive and generic model to encapsulate
complex semantic information via different types of nodes and
edges [49]. By this model, each node (or edge) has internal structure,
including a set of properties. By virture of the compactness of this
model compared to those of other types of Knowledge Graphs like
RDF triple stores [34, 66], HINs are increasingly supported by data
systems, e.g., Neo4j1 [4], and investigated in research studies [14,
17, 18, 22, 29, 43, 55–57, 64, 67, 69].
An example HIN capturing scholarly data, along with its implied
schema2 that represents the involved entity types, relationship
types, and properties, is illustrated in Figure 1. It consists of nodes
representing papers (P), authors (A), venues (V), and topics (T) and
(bidirectional) edges of three types: authors – papers (AP / PA),
papers – topics (PT / TP), and papers – venues (PV / VP).
Indirect relationships between entities are implicitly encoded by
paths in the HIN. In particular, all paths that correspond to the same
1https://neo4j.com/
2It is worth mentioning that HINs are naturally schemaless, i.e., there is not any
technical requirement for a schema to be predetermined. However, the current ‘schema’
can be implied from the data and it can be conceptually useful in some cases (e.g., this
is why Neo4j gives this option with the call db.schema() command.
sequence of node and edge types (i.e., the same ‘metapath’ [57])
encode latent relationships of the same interpretation between the
starting and ending nodes. For example, in the HIN of Figure 1,
the metapath ⟨𝐴𝑃𝑇𝑃𝐴⟩relates authors that have published papers
on the same topic (e.g., both ‘J. Doe’ and ‘H. Jekyll’ have
papers about ‘DL’). It is also worth mentioning that each metapath
corresponds to a path on the schema of the HIN.
Metapaths are instrumental for HIN exploration and analysis
from multiple perspectives, as a means to derive different views
of such a network. For example, the metapath-based connectivity
can be used to define node similarity measures [46, 47, 57, 68]
or to rank nodes based on their centrality in a metapath-defined
network [27, 30, 35, 48]. In the previous example, using the TPT
metapath to perform a similarity join could reveal that topics ‘ML’
and ‘DL’ are very related since they are involved in two common
papers. Moreover, to further elaborate the analysis, it is often useful
to apply property-based constraints to a given metapath (e.g., in the
previous example, to consider only metapath instances involving
papers published later than ‘2020’). Motivated by the above, we
have recently developed prototypes for supporting metapath-based
exploration and mining of HINs [11, 12].
The first step in any metapath-based analysis is to generate a
transformed network that contains edges between all pairs of nodes
connected with one or more paths of the specified type. This prepro-
cessing step is computationally expensive. While various methods
aim to speed up the computation of a single metapath query, which
typically involves a series of matrix multiplications [48], the prob-
lem becomes even more severe in scenarios calling for the real-time
evaluation of multiple metapath queries. In metapath-based feature
selection [33, 44], different metapaths reveal different associations
among entities, informing tasks like recommendation and link pre-
diction [8, 13, 45]. Such a task requires a large number of metapath
queries (i.e., a query workload), leading to a significant bottleneck
in the data analysis process. Yet, in such a multi-query evalua-
tion scenario, significant overlaps typically occur among metapath
queries [19, 24, 40–42]; such overlaps are translated into repetitive
matrix multiplications. We may thus avoid a large portion of the
heavy computations involved using query materialization; yet, to
the best of our knowledge, no existing approach does so.
In this paper, we introduce Atrapos,3 a metapath query evalua-
tion approach that detects, in real time, frequent metapath overlaps
3From Greek ἀτραπός, ‘path’, what is frequently trodden.
arXiv:2201.04058v2  [cs.DB]  25 May 2023

---

Chatzopoulos and Vergoulis, et al.
name: Digital Libraries (DL)
name: Data Management (DM)
name: J . Doe
name: Y. Vuvuli
name: H. J ekyll
name: L. Salander
name: Machine Learning (ML)
name: J CDL
name: VLDB
Α
P
V
T
HIN
HIN schema
name
name
id
year
name
id: P1
year: 2020
id: P2
year: 2021
id: P 3
year: 2021
id: P4
year: 2021
id: P5
year: 2021
(Author)
(Paper)
(Venue)
(Topic)
AP/PA
PV/VP
PT/TP
Figure 1: An example HIN and its implied schema.
within a sequence of queries. To do so, it uses: (i) sparse matrix
representations, which leverage the fact that the matrices involved
in metapath computations are largely sparse, especially for con-
strained metapaths; and (ii) a tailored data structure with a cus-
tomised caching policy to materialise reoccurring intermediate re-
sults. Our experimental evaluation demonstrates that Atrapos out-
performs traditional, single-query approaches in the evaluation of
metapath query workloads, while it is considerably faster than base-
line approaches that we implemented. To the best of our knowledge,
this work is the first to study the problem of optimizing the real-
time evaluation of metapath query workloads. Our contributions
can be summarised as follows:
• We show how metapath computations can be accelerated
using matrix multiplication algorithms tailored for sparse
matrices along with an appropriate cost model, especially
when dealing with constrained metapaths.
• We introduce a new data structure, the Overlap Tree, that
reveals overlaps among metapaths and a cache insertion
policy using this structure to cache and reuse intermedi-
ate results in real-time while running a metapath query
workload.
• We propose a tailored, effective cache replacement policy
that exploits cache item interdependence.
• We conduct a thorough evaluation on real data showcasing
the efficiency of our approach.
The rest of the paper is structured as follows. In Section 2, we
formally define the problem. Section 3 introduces our approach,
Atrapos. In Section 4, we discuss our experimental evaluation.
Section 5 reviews related work and Section 6 concludes the paper.
2
PROBLEM DEFINITION
Here, we introduce the basic concepts and notations we use, and
define the problem of metapath query workload evaluation (MQWE).
A heterogeneous information network (HIN) [49, 57], also known
as knowledge graph, is a directed multigraph that contains multiple
types (or labels) of nodes and edges:
Definition 1 (HIN). A HIN is a tuple H = ⟨𝑉, 𝐸,𝑂, 𝑅,𝜙,𝜓⟩,
where 𝑉and 𝐸are the nodes and edges of a directed multigraph,
respectively; 𝑂and 𝑅(|𝑂| > 1, |𝑅| > 1) are the sets of distinct node
and edge types, respectively, while 𝜙: 𝑉→𝑂and 𝜓: 𝐸→𝑅are the
mapping functions that determine the type of each node 𝑣∈𝑉and
each edge 𝑒∈𝐸, respectively.
J . Doe
L. Salander
Y. Vuvuli
H. J ekyll
P
P
P
P
P
1 1 0 0 0
0 1 1 0 0 
0 1 1 1 0
0 0 0 1 1
PT
1
2
3
4
5
1 0 0
1 1 0
0 1 1
1 0 0
0 1 1
DL ML DM
P
P
P
P
P
1
2
3
4
5
A
0 0 0 0 0
0 1 0 0 0
0 0 1 0 0
0 0 0 1 0
0 0 0 0 1
M
.
.
.
P
P
P
P
P
1
2
3
4
5
.
P
P
P
P
P
1
2
3
4
5
=
=
1 1 0 
1 2 1
2 2 1
1 1 1
J . Doe
L. Salander
Y. Vuvuli
H. J ekyll
A
DL ML DM
A
AP
P.year>2020
m
Figure 2: Evaluation of the𝑚= (⟨𝐴𝑃𝑇⟩, {𝑃.𝑦𝑒𝑎𝑟> 2020}) query
on the HIN of Figure 1.
It is often useful to consider that each node type comes with a set
of properties, which capture useful information for the nodes of that
type.4 Given a node 𝑣∈𝑉, we use the notation 𝑣.𝑝𝑟𝑜𝑝to refer to the
value of the property 𝑝𝑟𝑜𝑝on 𝑣. All distinct node and edge types,
along with the respective properties, can be easily derived by the
HIN data and we often refer to them as the HIN’s schema. Finally, it
is often convenient (for various types of analysis) to represent the
edges of a particular type 𝑟= ˙oö, where ˙o,ö ∈𝑂and 𝑟∈𝑅, using
the respective adjacency matrix 𝐴𝑟, i.e., a ˙o × ö matrix for which
𝐴𝑟[𝑖, 𝑗] = 1 if the 𝑖𝑡ℎnode of type ˙o is connected with the 𝑗𝑡ℎnode
of type ö, and 𝐴𝑟[𝑖, 𝑗] = 0 otherwise.
A metapath is a sequence of node types connected by appropriate
edge types, hence corresponds to a path on a HIN schema. Given a
metapath 𝑚, every path in the HIN that complies to the sequence
of node and edge types specified by 𝑚is an instance of 𝑚. Formally:
Definition 2 (Metapath & Metapath instance). Given a HIN
H = ⟨𝑉, 𝐸,𝑂, 𝑅,𝜙,𝜓⟩, a metapath𝑚on H is a sequence𝑚= ⟨𝑜1
𝑟1
−−→
𝑜2 . . .
𝑟𝑛−1
−−−−→𝑜𝑛⟩, where 𝑜𝑖∈𝑂, 𝑟𝑗∈𝑅∀𝑖, 𝑗, and 𝑛is the metapath
length. An instance of 𝑚is any path ⟨𝑣1
𝑒1
−−→𝑣2 . . .
𝑒𝑛−1
−−−−→𝑣𝑛⟩for
which 𝑣𝑖∈𝑉, 𝑒𝑗∈𝐸, 𝜙(𝑣𝑖) = 𝑜𝑖, and 𝜓(𝑒𝑗) = 𝑟𝑗∀𝑖, 𝑗.
By a common simplification [48, 57], we denote a metapath as
𝑚= ⟨𝑜1𝑜2 . . .𝑜𝑛⟩, without edge types, when there is only a single
edge type between any pair of node types. It should be highlighted
that this convention is followed here solely for the sake of sim-
plicity; all approaches can easily accommodate edges of different
types among the same pairs of nodes (e.g., since they employ sep-
arate adjacency matrices for distinct edge types). Figure 1 shows
an example HIN comprising 14 nodes of 4 types (𝐴, 𝑃, 𝑉and 𝑇)
and 3 edge types (𝐴𝑃/𝑃𝐴, 𝑃𝑉/𝑉𝑃, and 𝑃𝑇/𝑇𝑃). A simplified meta-
path of length 3 is 𝑚= ⟨𝐴𝑃𝑉⟩, and an instance of 𝑚is the path
⟨‘𝑌.𝑉𝑢𝑣𝑢𝑙𝑖’ ‘𝑃3’ ‘𝑉𝐿𝐷𝐵’⟩.
We also consider metapaths enhanced with constraints on node
type properties, which restrict the nodes that may participate in
a metapath instance. We refer to such metapaths as constrained
metapaths. The set of instances of a constrained metapath is a subset
of those of the corresponding unconstrained metapath. Formally:
Definition 3 (Constrained metapath). A constrained metap-
ath is a pair 𝑚′ = (𝑚,𝐶) where 𝑚= ⟨𝑜1𝑜2 . . .𝑜𝑛⟩is a metapath and
𝐶= {𝑐1, . . . ,𝑐𝑛} is a set of constraints on the nodes in 𝑚.
Recall the metapath ⟨𝐴𝑃𝑇𝑃𝐴⟩of the HIN in Figure 1, which
connects two authors that have published a paper on the same
topic. A data scientist working with this HIN may need to examine
4It may be useful to assign properties to edges, as well, however for notation simplicity
in this work we do not consider edge properties.

---

Atrapos: Evaluating Metapath Query Workloads in Real Time
only recent papers, e.g., papers published after 2000, may use the
constrained metapath 𝑚′ = (⟨𝐴𝑃𝑇𝑃𝐴⟩, {𝑃.𝑦𝑒𝑎𝑟> 2000}).
We now define the metapath query evaluation (MQE) problem.
Problem 1 (MQE). Given a HIN H = ⟨𝑉, 𝐸,𝑂, 𝑅,𝜙,𝜓⟩and a
(constrained) metapath𝑚= (⟨𝑜1𝑜2 . . .𝑜𝑛⟩,𝐶), MQE retrieves all node
pairs ⟨𝑣𝑜, 𝑣𝑑⟩, such that 𝑣𝑜∈𝑜1, 𝑣𝑑∈𝑜𝑛, and 𝑣𝑜is connected to 𝑣𝑑
based on at least one instance of 𝑚. We refer to each such pair, along
with the respective number of instances, as an MQE result for 𝑚.
A conventional approach to evaluate a metapath query𝑚is to cal-
culate the matrix product 𝐴𝑚= 𝐴𝑜1𝑜2𝐴𝑜2𝑜3...𝐴𝑜𝑛−1𝑜𝑛, where 𝐴𝑜𝑖𝑜𝑗
is the adjacency matrix for the relation 𝑟= 𝑜𝑖𝑜𝑗. Each non-zero
element in 𝐴𝑚is a response to the corresponding metapath query.
Given a constraint 𝑐𝑖∈𝐶on object 𝑜𝑖in relation 𝑟= 𝑜𝑖𝑜𝑗, we
apply 𝑐𝑖in the matrix product via the constrained adjacency ma-
trix 𝐴𝑐𝑖𝑜𝑖𝑜𝑗= 𝑀𝑐𝑖· 𝐴𝑜𝑖,𝑜𝑗, where 𝑀𝑐𝑖is a |𝑜𝑖| × |𝑜𝑖| diagonal ma-
trix that has element 1 in the diagonal only for nodes 𝑜𝑖satisfy-
ing 𝑐𝑖. Figure 2 shows an example for the metapath query 𝑚=
(⟨𝐴𝑃𝑇⟩, {𝑃.𝑦𝑒𝑎𝑟> 2020}). Based on the MQE problem, we define
the metapath query workload evaluation (MQWE) problem:
Problem 2 (MQWE). Given a HIN H = ⟨𝑉, 𝐸,𝑂, 𝑅,𝜙,𝜓⟩and a
metapath query workload 𝑊= {𝑚1, . . . ,𝑚𝑞}, MQWE is the task of
efficiently computing all 𝑀𝑄𝐸s for the metapaths in 𝑊.
We focus on MQWE and elaborate our approach in the following.
3
THE ATRAPOS APPROACH
Atrapos, our approach for efficiently evaluating metapath query
workloads, (a) translates metapath query evaluation into a sequence
of multiplications between the adjacency matrices of the edge types
contributing to the respective metapaths, and (b) applies dynamic
programming to identify an efficient order of multiplications (Sec-
tion 3.1). Going beyond the state of the art [48], Atrapos takes
into account the inherent sparsity of the adjacency matrices to
exploit fast sparse matrix multiplication algorithms, and identifies
improved execution plans for each metapath using matrix mul-
tiplication cost models tailored for sparse matrices (Section 3.2).
Lastly, Atrapos identifies sub-metapaths that reoccur due to meta-
path overlaps in a workload and caches the corresponding matrix
multiplication results to avoid repeating them. To do so, it uses a
specialized data structure, the Overlap Tree, which keeps track of
metapath overlaps, occurrence frequencies, and cache entries (Sec-
tion 3.3); Atrapos’s cache management policy exploits the Overlap
Tree to avoid undesirable cache replacements (Section 3.4).
3.1
Efficient Multiplication Plan Selection
Given a metapath query, Atrapos generates a set of alternative
execution plans, each comprising a different sequence of multipli-
cations between the adjacency matrices of the edge types involved,
as in [48]. Due to associativity, there are many such orderings that
produce the same result, and their computational costs may differ.
For example, consider the query 𝑚= {⟨𝐴𝑃𝑇⟩, 𝑃.𝑦𝑒𝑎𝑟> 2020} in
Figure 2. The result 𝐴𝑚= 𝐴𝐴𝑃· 𝑀𝑃.𝑦𝑒𝑎𝑟>2020 · 𝐴𝑃𝑇can be calcu-
lated as (𝐴𝐴𝑃· 𝑀𝑃.𝑦𝑒𝑎𝑟>2020) · 𝐴𝑃𝑇or 𝐴𝐴𝑃· (𝑀𝑃.𝑦𝑒𝑎𝑟>2020 · 𝐴𝑃𝑇).
Since 𝐴𝐴𝑃, 𝑀𝑃.𝑦𝑒𝑎𝑟>2020, and 𝐴𝑃𝑇are of size [4 × 5], [5 × 5], and
[5 × 3], respectively, and a standard multiplication of two matrices
of size 𝑚× 𝑛and 𝑛× 𝑙requires 𝑚· 𝑛· 𝑙operations, the first option
yields 160 operations, while the second 135, which is preferable.
By this standard implementation of matrix multiplication, the
cost 𝐶𝐴𝑖...𝑗of the optimal plan for a multiplication series 𝐴𝑖...𝑗=
𝐴𝑖· ... · 𝐴𝑗, 1 ≤𝑖< 𝑗via dynamic programming (DP) [16], is:
𝐶𝐴𝑖...𝑗= min
𝑖≤𝑘<𝑗{𝐶𝐴𝑖...𝑘+ 𝐶𝐴𝑘+1...𝑗+ 𝑐𝐴𝑖...𝑘·𝐴𝑘+1...𝑗}
(1)
where 𝐶is a 𝑝× 𝑝matrix of optimal costs and 𝑐𝐴𝑖...𝑘·𝐴𝑘+1...𝑗the cost
of multiplying the results of sub-series 𝐴𝑖...𝑘and 𝐴𝑘+1...𝑗, estimated
by matrix dimensions in the case of standard matrix multiplication.
3.2
Sparse Matrix Representation
The technique of Section 3.1 has been used to identify the opti-
mal matrix multiplication plan for single metapath query evalua-
tion [48]. However, most adjacency matrices in HINs are sparse (i.e.,
have few non-zero elements). Using a general-purpose matrix mul-
tiplication method on sparse matrices is inefficient. This sparsity is
amplified if there are constraints in the metapath queries, which
are represented by extra diagonal matrices with a small number of
non-zero elements in the diagonal, whose multiplication with other
matrices yields an even sparser result. Unfortunately, previous work
opted for dense matrix representations [48].
By contrast, we use sparse matrix structures to represent ad-
jacency matrices and multiply such matrices taking advantage of
these structures. Still, the cost to multiply sparse matrices cannot
be adequately estimated from their dimensions, as it also depends
on the number of non-zero elements in input and result matri-
ces, implementation details, and memory accesses. An approxima-
tion model [25] estimates the cost of multiplying sparse matrices
𝑋[𝑚× 𝑛] and 𝑌[𝑛× 𝑙] to yield 𝑍= 𝑋· 𝑌as:
ˆ
𝑐𝑋·𝑌≈𝛼· (𝑚· 𝑛· 𝜌𝑋)
|        {z        }
𝑛𝑜𝑛𝑍𝑒𝑟𝑜(𝑋)
+𝛽· (𝑚· 𝑛· 𝜌𝑋· 𝑙· 𝜌𝑌)
|                  {z                  }
ˆ
𝑁𝑜𝑝
+𝛾· (𝑚· 𝑙· ˆ𝜌𝑍)
|       {z       }
ˆ
𝑛𝑜𝑛𝑍𝑒𝑟𝑜(𝑍)
(2)
where 𝜌𝑋and 𝜌𝑌are the densities of 𝑋and 𝑌, 𝑛𝑜𝑛𝑍𝑒𝑟𝑜(𝑋) the
number of non-zero elements in 𝑋,
ˆ
𝑁𝑜𝑝the estimated number of
operations, ˆ𝜌𝑍the estimated density of 𝑍, and
ˆ
𝑛𝑜𝑛𝑍𝑒𝑟𝑜(𝑍) the
estimated number of non-zero elements in 𝑍. Coefficients 𝛼, 𝛽,𝛾
are determined by multilinear regression using least squares fit.
Assuming that the non-zero elements in 𝑋and 𝑌are uniformly
distributed, we compute ˆ𝜌𝑍= 1 −(1 −𝜌𝑋· 𝜌𝑌)𝑛as indicated by
the average-case density estimator 𝐸𝑎𝑐[25, 53]. There exist more
accurate estimation algorithms [15, 25, 53, 71], taking into con-
sideration the pattern of non-zero elements in 𝑋and 𝑌, yet they
incur a higher computational cost. We found experimentally that
cost estimation techniques do not provide significant benefits in
our application scenario. Figure 3 illustrates the execution time
breakdown of 𝐸𝑎𝑐against the MNC estimator [53], which builds
sketches to estimate the sparsity of the result. This experiment con-
siders 2 000 randomly selected metapath queries with their length
varying from 3 to 5 for the Scholarly and News article HINs (see
Sections 4.1.1 and 4.1.2). Both estimators achieve very compara-
ble results for the actual matrix multiplication execution, with 𝐸𝑎𝑐
requiring a negligible amount of time for planning compared to

---

Chatzopoulos and Vergoulis, et al.
Figure 3: MNC vs the average-case density estimator 𝐸𝑎𝑐(log
scale on y-axis).
MNC. Interestingly, both estimators produce the same multiplica-
tion plans for over 70% of the examined queries. As we consider
constrained metapath queries, very sparse matrices arise in the
multiplication, and the plans produced by 𝐸𝑎𝑐are on par with those
of more sophisticated solutions without the added cost of planning.
Since the added cost of more accurate estimators does not pay off
in terms of cost savings for the query types we examine, we settled
for the former best-effort estimation.
In a nutshell, our sparsity-aware method produces a multipli-
cation plan for a metapath query by the dynamic programming
approach of Equation 1, while estimating sparse-matrix multiplica-
tion costs by Equation 2. We use an additional 𝑝× 𝑝matrix 𝐷to
hold the densities ˆ𝜌𝑍of intermediate results needed to compute
this cost in each step. Besides, since Atrapos caches intermediate
matrix multiplication results (Section 3.4), we substitute these esti-
mates with the (negligible) cost of retrieving a result matrix from
the cache, or the cost of recomputing a result matrix if that had been
previously cached and then evicted from the cache (Section 3.3).
3.3
The Overlap Tree
The hitherto discussed techniques focus on a single metapath query.
We further enhance the evaluation of a metapath query workload by
avoiding redundant computations that arise due to query overlaps.
To do so, we introduce the Overlap Tree, a dynamic data structure
that organizes information about frequent metapath overlaps in the
workload and their dependencies. We use this data structure, along
with a cache memory that stores matrix multiplication results for
the indexed overlaps, to further reduce the workload evaluation
time. We provide details on cache management in Section 3.4.
3.3.1
The structure. The Overlap Tree is a dynamic data structure
that keeps track of overlaps and dependencies between the already
evaluated and new queries during the evaluation of a metapath
query workload. It is progressively constructed by parsing query
metapaths, accompanied by a cache memory that stores matrix mul-
tiplication results. At any time, it encodes the overlaps of hitherto
evaluated queries, their constraints, their occurrence frequencies,
and pointers to any corresponding cache entries. We first describe
the structure of the Overlap Tree ignoring query constraints; we
explain how the tree considers constraints in Section 3.3.4.
ICPAL
ICPAT
ICPAO
q
q
q
0
1
2
Workload
f = 3
c = 1s
ρ =0.011
p: xxx
f = 1
c = 1.2s
ρ = 0.012
p: xxx
f = 1
c = 1.1s
ρ = 0.011
p: xxx
root
f = 1
c = 1.4s
ρ = 0.015
p: xxx
…
ICPA
T
L
O
Cache
…
A
A
IC
CP
.
ICPA
A
f = 3
c = 0.9
ρ = 0.010
p: xxx
CPA
.
APA
(
)
Figure 4: Example workload and Overlap Tree.
Each internal node of the tree represents an observed metapath
overlap and contains the following information:
• Frequency (𝑓): The number of occurrences of the respective
overlap in the query workload until the given time point.
• Cache entry pointer (𝑝): A pointer to the cache entry con-
taining the result of the multiplication represented by the
overlap. If this result is not in the cache (i.e., has never been
cached or has been cached and evicted), the pointer is null.
• Multiplication cost (𝑐): The time required to perform the
matrix multiplication that corresponds to the overlap.
• Matrix sparsity (𝜌): The number of non-zero elements in
the multiplication result matrix for that overlap.
In addition, the Overlap Tree contains one leaf node for each
suffix of the metapaths of already evaluated queries (considering
the metapath as a string5); the internal structure of each leaf is
identical to that of internal nodes.6 Each edge of the tree is labelled
with a non-empty string, such that the concatenation of edge labels
on a tree traversal from the root to a node gives the string that
encodes the respective metapath overlap (or suffix in the case of
leaves).
The Overlap Tree is inspired from the generalised suffix tree [7,
61], which captures the substrings of a given collection of strings; it
adds pointers to cached items and information on overlap frequency,
query constraints, and matrix multiplication costs. We emphasize
that, as its name suggests, the Overlap tree produces a cache entry,
and, for that matter, a node, only if an overlap is detected.
Figure 4 depicts an Overlap Tree for a workload of three metapath
queries (𝑞0, 𝑞1, and 𝑞2), defined on the News Articles HIN (used
in Section 4). The highlighted node represents the overlap sub-
metapath 𝐼𝐶𝑃𝐴, occurring in all three queries, points to a cache
entry for the multiplication result 𝐴𝐼𝐶· (𝐴𝐶𝑃·𝐴𝑃𝐴), and stores the
sparsity 𝑠of this cached result and the cost 𝑐to calculate it.
3.3.2
Update. We construct an Overlap Tree from a metapath
query workload𝑊= {𝑚1,𝑚2, ...,𝑚𝑞} by sequentially inserting into
the tree all metapath queries𝑚𝑖∈𝑊. For each𝑚𝑖of length𝑙𝑖= |𝑚𝑖|,
5A query-specific character is added at the end of each metapath string to guarantee the
correspondence of leaves to query suffixes in case of common prefixes. For simplicity,
in all the examples we ignore this special character.
6Note that 𝑓= 1 always for leaves.

---

Atrapos: Evaluating Metapath Query Workloads in Real Time
we7 insert the entire 𝑚𝑖and all its suffixes 𝑠𝑖= 𝑚𝑖[𝑘: 𝑙𝑖] with
0 < 𝑘< 𝑙𝑖. Starting from the root, we find the longest path that
matches a prefix of 𝑠𝑖; the match ends either at an existing node
or in the middle of an edge. In both cases, we let an internal node
represent the detected overlap after the last matching character at
position 𝑐, corresponding to sub-metapath 𝑚𝑖[𝑘: 𝑐]; if the match
ends on a leaf node, that node becomes internal, assigned dummy
leaves if necessary. In case that occurs on an edge, we break that
edge in two edges labelled with 𝑚𝑖[𝑘: 𝑐] and 𝑚𝑖[𝑐+ 1 : 𝑙𝑖], and
create a new internal node. Lastly, we create a new leaf node that
corresponds to 𝑠𝑖and is connected to the last traversed internal
node with a new edge. In this procedure, node frequencies are
updated so as to reflect sub-metapath occurrences.
After this traversal, the cache pointers of the involved nodes
may be updated. In particular, for the node representing the whole
query 𝑚𝑖, the update algorithm will attempt to cache the respective
multiplication result, if the node’s cache item pointer is currently
null; cache insertion depends on the cache replacement policy (Sec-
tion 3.4.2). Similarly, a cache insertion will be attempted for any
traversed internal node in case the respective intermediate matrix
multiplication result is calculated according to the selected multi-
plication plan (see Sections 3.1 & 3.2). Yet even if the corresponding
intermediate result is produced, it is not guaranteed to be cached,
as that depends on the cache insertion policy (Section 3.4.1).
3.3.3
Space Complexity. Consider a metapath query workload𝑊=
{𝑚1,𝑚2, ...,𝑚𝑞} and the respective Overlap Tree 𝑇𝑊. The exact
number of leaves in 𝑇𝑊is 𝜆= |𝑚1| + |𝑚2| + ... + |𝑚𝑞|, since each
𝑚𝑖∈𝑊has exactly |𝑚𝑖| suffixes. As an internal tree node is created
when and only when detecting an overlap among queries, each
internal node has at least two children; in the worst case, all internal
nodes have exactly two children, hence the Overlap Tree is a full
binary tree having 2𝜆−1 = 𝑂(𝜆) nodes.
Based on the internal structure of the Overlap Tree nodes, all
leaves have the same memory footprint: the aggregated size of
integer 𝑓, two floating point numbers,𝑐and 𝜌, and one pointer 𝑝. All
internal nodes, on the other hand, have the same memory footprint
plus the size of the pointers to their children. Since in the worst
case each internal node has two such pointers, the respective worst-
case size can be easily calculated. Finally, the root has a memory
footprint equal to that of two pointers, since none of the four node
variables (𝑓,𝑐, 𝜌, 𝑝) are included in this node.
It is worth to highlight that for most practical scenarios, like
those examined in our experiments, the size of the Overlap Tree is
negligible compared to the size of the available main memory of
a contemporary server. This means that the structure allows for a
large size of cache to be determined, benefiting the performance of
the workload evaluation process.
3.3.4
Handling constrained queries. We have described Overlap
Tree operations without considering query constraints (see Defini-
tion 3 for details on constrained metapaths). To support constraints,
we modify the internal structure of the tree nodes enriching them
with a key-value data structure, called the constraints index, that
holds a given constraint in the form of a string (e.g., 𝑃.𝑦𝑒𝑎𝑟> 2000)
7This process is described due to its simplicity and it is not the most efficient approach to
build an Overlap Tree. Approaches based on Ukkonen’s algorithm [63] are significantly
faster, yet their description is beyond the scope of this work.
ICPAL
ICPAT
ICPAO
ICPALA
q
q
q
q
0
1
2
Workload
f = 4
c = 1s
ρ = 0.011
p: xxx
f = 1
c = 1.2s
ρ = 0.012
p: xxx
f = 2
c = 0.6s
ρ = 0.011
p: xxx
f = 1
c = 1.4s
ρ = 0.015
p: xxx
T
L
O
Cache
…
ΙCPA
A
ΙCPA
A
AAL
.
ΙCPAL
A
f = 1
c = 1.1s
ρ = 0.012
p: xxx
3
A
A
A
IC
CP
.
.
APA
(
)
root
ICPA
f = 4
c = 0.9
ρ = 0.010
p: xxx
CPA
…
Figure 5: Overlap Tree with cache entry dependencies.
as key and the respective variables (𝑓, 𝑝, 𝑐, and 𝜌) as a composite
value. The constraint index of each node can be implemented as
a suitable data structure, such as a hash table index. We adapt the
respective operations accordingly to accommodate this change.
Specifically, upon probing the Overlap Tree for a constrained
pattern, we traverse the tree starting from the root following the
exact same process described in Section 3.3.2 until we reach the
ending node. Then, we probe the constraints index of the node to
retrieve the respective entry (or to create it, if there is not one) and
we update the corresponding constraints index counters accord-
ingly; if we select to cache the result, the cache entry pointer should
also be updated.
Regarding space complexity, the calculations in Section 3.3.3
remain valid, yet we should also take into consideration the number
of constraints each node accommodates in the constraint index.
Since each leaf node represents a single, non-overlapping metapath
suffix (i.e., 𝑓= 1), each leaf stores only one key-value pair. By
contrast, each internal node represents a metapath query overlap
(i.e., 𝑓> 1); in the worst case, each overlapping metapath query
has a different constraint, hence the number of key-value pairs in a
node equals the node’s frequency 𝑓.
3.4
Atrapos-OTree Cache Management
Evaluating a metapath query workload can benefit from caching and
reusing any reappearing intermediate matrix multiplication results.
However, such results are unlikely to all fit in a typical machine’s
main memory. We thus need a cache management policy.
We exploit the Overlap Tree to obtain a two-fold benefit: first, we
use the Overlap Tree to inform a cache insertion policy favoring the
insertion of frequent multiplication results; thereby we avoid caching
matrix multiplications that appear rarely, hence reduce unnecessary
cache evictions (Section 3.4.1); secondly, we use the Overlap Tree
to obtain information on cached items (such as computational cost
to produce, size, and dependencies) for a tailored cache replacement
policy (Section 3.4.2). In the following, we elaborate on these two
uses of the Overlap Tree by Atrapos’s cache management policy,
the Atrapos-OTree policy.
3.4.1
Atrapos-OTree Cache Insertion Policy. In any domain of
knowledge, certain informative sub-metapaths are bound to occur

---

Chatzopoulos and Vergoulis, et al.
Algorithm 1: Atrapos-OTree cache replacement policy
1 𝐿= 0
2 foreach request of cache item 𝑝do
3
𝑓𝑝= 𝑓𝑝+ 1
4
if 𝑝is in cache then
5
𝑝𝑙= 𝐿
6
ℎ𝑝= 𝑓𝑝· 𝑐𝑝/𝑠𝑝+ 𝑝𝑙
7
else
8
while not enough space for 𝑝in cache do
9
𝐿= 𝑚𝑖𝑛{ℎ𝑞|𝑞∈𝑐𝑎𝑐ℎ𝑒}
10
evict 𝑞that satisfies ℎ𝑞= 𝐿
11
foreach cache entry 𝑒in the subtree of 𝑞do
12
𝑐𝑒= 𝑐𝑒+ 𝑐𝑞
13
ℎ𝑒= 𝑓𝑒· 𝑐𝑒/𝑠𝑒+ 𝑒𝑙
14
insert 𝑝in cache
15
𝑝𝑙= 𝐿
16
ℎ𝑝= 𝑓𝑝· 𝑐𝑝/𝑠𝑝+ 𝑝𝑙
17
foreach cache entry 𝑒in the subtree of 𝑝do
18
𝑐𝑒= 𝑐𝑒−𝑐𝑝
19
ℎ𝑒= 𝑓𝑒· 𝑐𝑒/𝑠𝑒+ 𝑒𝑙
frequently in a query workload. Such metapath repetitions may
lead to redundant matrix multiplications during the evaluation of a
workload. Materializing intermediate multiplication results in cache
can reduce the number of redundant computations, hence improve
performance. However, as there are numerous intermediate results,
we need a cache insertion policy to select which ones to insert.
The Overlap Tree is helpful to that end, as each internal node
thereof encodes a sub-metapath occurring at least twice in the work-
load (Section 3.3.2). Our cache insertion policy attempts to insert a
cache entry for (i) the whole of 𝑚and (ii) the longest part of 𝑚that
matches an internal tree node (i.e., has occurred at least twice) and
an intermediate result calculated by the matrix multiplication plan.
Our cache replacement policy (Section 3.4.2) determines whether
this attempt succeeds. Thereby, Atrapos reduces cache insertion
attempts, focusing on frequent overlaps, which are likely to reoc-
cur. Moreover, it selects to cache longest qualifying sub-metapath,
which usually has the largest computational cost. For instance, in
Figure 5 although 𝐶𝑃𝐴and 𝐼𝐶𝑃𝐴are equally frequent and their
intermediate results are available, only the latter is cached.
3.4.2
Atrapos-OTree Cache Replacement Policy. A straightforward
way to cache matrix multiplication results is to use a generic policy,
like LRU [3], which discards the least recently used cached item first.
LRU works well when all items have similar (a) cost to fetch and
(b) size. However, neither of these conditions holds for metapath
query workloads, as (i) fetching an item in the cache involves ma-
trix multiplications, whose cost differs among items, and (ii) item
size varies depending on the result matrix density. In effect, one
may adopt a size- and cost-aware cache replacement policy, as in
web server caching [5, 23, 52]. Popularity-aware Greedy Dual-Size
(PGDS) [52] measures the utility of a cache entry 𝑒as 𝑢𝑒= 𝑓𝑒· 𝑐𝑒
𝑠𝑒,
where 𝑓𝑒is the frequency of 𝑒, 𝑐𝑒its cost, and 𝑠𝑒its size. We may
obtain 𝑓𝑒of each cache entry from the corresponding tree counter,
𝑐𝑒as the estimated cost of the corresponding matrix multiplica-
tion, and 𝑠𝑒as its size. Let 𝐸be all cache entries. Initially, each
entry 𝑒𝑖∈𝐸has utility value ℎ𝑒𝑖= 𝑢𝑒𝑖. In case of cache saturation,
we evict the entry with min{ℎ𝑒𝑖}, denoted as 𝐻min and reduce
the utility values of all other cache items by 𝐻min . Thus, recently
cached items retain a higher fraction of their initial utility and are
hence less likely to be evicted. To avoid subtracting 𝐻min from
items in the cache, PGDS uses an inflation variable 𝐿: it adds 𝐻min
to 𝐿at each eviction, and increases the utility of any cache hit by 𝐿.
We employ an enhanced cache policy that builds on PGDS by
considering cache entry interdependence: the cost 𝑐𝑒to re-calculate
and re-fetch an entry 𝑒in the cache may be smaller than what
PGDS estimates, because part of the calculation may be obtained by
another cache entry, 𝑒′, as cache entries follow a hierarchy: given
an internal Overlap Tree node 𝑛𝑝and the set of nodes in its sub-tree,
𝑆(𝑛𝑝), the cache entry of each 𝑛𝑖∈𝑆(𝑛𝑝) can exploit that of 𝑛𝑝.
Thus, each time we insert a cache entry 𝑝in an internal node, we
subtract its cost 𝑐𝑝from that of cached items in its sub-tree, as these
are cheaper to recompute given 𝑝. In reverse, when we evict an
entry 𝑞from the cache, we reinstate its cost 𝑐𝑞to that of items in
its sub-tree. Algorithm 1 outlines this approach.
Figure 5 shows the Overlap Tree of Figure 4 after inserting
a new metapath, 𝐼𝐶𝑃𝐴𝐿𝐴. Assuming that the pointer 𝑝in the
highlighted node for 𝐼𝐶𝑃𝐴𝐿was previously null, we insert a new
cache item, containing the respective multiplication result, and
update 𝑝to point to it. Still, since the traversal passed through the
node for 𝐼𝐶𝑃𝐴, we can use its cached result to calculate the result
for 𝐼𝐶𝑃𝐴𝐿. In case the cached item for 𝐼𝐶𝑃𝐴is evicted, we reinstate
its cost to that of cached items in its sub-tree, i.e., to 𝐼𝐶𝑃𝐴𝐿, to
reflect the cost of its calculation without using the entry for 𝐼𝐶𝑃𝐴.
4
EXPERIMENTAL EVALUATION
In this section, we present an extensive experimental evaluation
of Atrapos. We describe the experimental setup in Section 4.1,
showcase the performance of Atrapos against state-of-the-art ap-
proaches for single metapath query evaluation in Section 4.2, and
present experiments against two baselines that take advantage of
a caching mechanism for metapath workloads in Section 4.3; we
investigate various cache replacement policies in Section 4.4.
4.1
Setup
4.1.1
Datasets. We use the following data sets:
• Scholarly HIN. A dataset based on AMiner’s DBLP Cita-
tion Dataset [62], enriched with projects funded by the EU
under the Horizon 2020 programme, taken from Cordis8, in-
cluding entities for Papers (P), Authors (A), Organisations (O),
Venues (V), Topics (T), and Research Projects (R). Fig-
ure 6(a) shows the implied schema.
• News articles HIN. This is based on news articles pub-
lished on April 2016 and their associated entities from the
GDELT Project [28], enriched with information for people
involved in the Panama Papers scandal and their related
8https://data.europa.eu/euodp/en/data/dataset/cordisH2020projects

---

Atrapos: Evaluating Metapath Query Workloads in Real Time
Paper
Author
Venue
Topic
Research
Projects
Organi-
sation
(a) Scholarly HIN
Article
Person
Organi-
sation
Theme
Location
Company
Interme-
diary
Source
(b) News articles HIN
Figure 6: Implied schemas of experimental HINs.
companies and intermediaries from the Offshore Leaks data-
base9). The integration was performed by linking Panama
Papers officers with persons in GDELT. The resulting HIN
comprises Articles (A), Organisations (O), Persons (P),
Locations (L), Sources (S), Themes (T), Companies (C), and
their Intermediaries (I). Its implied schema is shown
in Figure 6b.
To assess scalability, we consider two additional splits of different
sizes for the aforementioned HINs, containing 60% and 80% of their
core entities, i.e. papers and articles, while preserving nodes and
edges connected with them. On News articles HIN, we first keep
across splits all articles connected with companies, as otherwise
few or no companies may be present in the final dataset, and we
then augment this core set to reach the number of articles needed.
Table 1 shows their statistics, i.e., number of nodes and edges, while
Table 2 collects the number of nodes and edges per type for each
dataset split. Note that, in all cases, we consider bi-directional rela-
tionships between entities. These HINs are two orders of magnitude
larger than those considered in previous recent studies (e.g. [48]).
4.1.2
Query Workloads. Due to the lack of available real-world
workloads, we create synthetic query workloads simulating the
query patterns of multiple data scientists posing queries, each ex-
ploring different aspects of a certain entity (e.g., a particular author
in the Scholarly HIN) via consecutive metapath queries related to
it. The entity of interest is determined by an equality constraint.
We refer to such a set of constrained metapath queries as a query
session. We generate such queries by randomly choosing a metapath
and a constraint applied on it. In each step, we either (a) randomly
pick a new constraint and start a new session, with session restart
probability 𝑝, or (b) continue using the same constraint and pick
a different metapath, with probability 1 −𝑝. Indicatively, 𝑝= 0.1
9https://offshoreleaks.icij.org/pages/database
Table 1: Details of experimental HINs.
Dataset
Contained Core
Nodes
Edges
Avg. Degree
Entity Nodes
(in millions)
(in millions)
60%
8.65
108.43
25.06
Scholarly HIN
80%
10.44
148.09
28.36
100%
12.15
190.99
31.43
60%
7.71
173.38
44.92
News articles HIN
80%
10.06
233.33
46.37
100%
12.43
298.11
47.95
Table 2: Number of nodes/edges per type.
Node
Million nodes per split
Edge
Million edges per split
Type
(60% / 80% / 100%)
Type
(60% / 80% / 100%)
Scholarly HIN
P
2.936/3.915/4.894
PP
16.367/29.236/455.641
A
3.100/3.781/4.398
AP/PA
17.916/23.898/29.869
O
2.488/2.608/2.706
OA/AO
14.921/15.976/16.832
V
0.009/0.009/0.010
VP/PV
5.247/6.994/8.743
T
0.117/0.125/0.132
TP/PT
53.977/71.974/89.974
R
0.001/0.001/0.001
RP/PR
0.008/0.010/0.013
News articles HIN
A
4.394/5.859/7.324
IC/CI
0.010/0.010/0.010
O
1.153/1.486/1.829
OA/AO
25.786/35.186/45.584
P
1.953/2.465/2.995
PA/AP
32.902/44.334/57.125
L
0.172/0.202/0.229
LA/AL
31.767/42.985/55.319
T
0.014/0.016/0.17
TA/AT
73.184/97.618/122.750
S
0.022/0.025/0.030
SA/AS
9.714/13.185/17.306
C
0.005/0.005/0.005
CP/PC
0.014/0.014/0.014
I
0.001/0.001/0.001
results in sessions each containing on average 10 metapath queries,
which is a reasonable length. Eventually, we shuffle all queries in
a workload to simulate a real-world environment. For all random
selections we used a uniform or a zipfian probability distribution,
the former as default. Each query workload contains 500 metapath
queries with length ranging from 3 to 5. We repeat each experi-
ment with 10 different query workloads, and report the average
evaluation time. All the query workloads are openly available.10
4.1.3
Methods. We juxtapose the following methods:
• HRank: the approach of [48] in its original configuration.
• Neo4j [65]: a well-established graph database. We convert
each metapath query to its corresponding Cypher11 query,
using the parameters’ syntax12 to express query constraints,
enabling Neo4j to cache query execution plans.
• HRank Sparse (HRank-S): a version of HRank adjusted to ex-
ploit sparse matrix representations and the cost estimation
for sparse matrix multiplications of Section 3.2.
• Cache-based Baseline-1 (CBS1): an adaptation of HRank-S
using an LRU cache to store final metapath query results.
• Cache-based Baseline-2 (CBS2): an extension of CBS1 that
caches all intermediate matrix multiplication results.
• Atrapos: our approach that uses the Overlap Tree to detect
frequent query overlaps and cache entry dependencies.
HRank and Neo4j are state-of-the-art approaches for single meta-
path query evaluation which we apply on query workloads. Neo4j
has its own internal caching mechanism. As discussed in Section 4.2,
these approaches perform poorly even for small datasets and do
not scale to large HINs. Therefore, we also use the three baselines
(HRank-S, CBS1, and CBS2), which take advantage of sparse matrix
representations and simple caching mechanisms. Note that, all in-
termediate results evicted from the cache could, in theory, be stored
on disk instead of discarding them, acting like a second level cache
mechanism. However, this applies to all cache-based methods and,
hence, does not impact their relative comparison.
10https://github.com/atrapos-hin/artifacts/tree/main/workloads
11Neo4j’s
native
query
language:
https://neo4j.com/developer/cypher-query-
language/
12https://neo4j.com/docs/cypher-manual/current/syntax/parameters/

---

Chatzopoulos and Vergoulis, et al.
Table 3: Experimental parameters.
Parameter
Range of values
Cache size (MB)
1024, 2048, 4096, 8128, 16256
Dataset size (core entity nodes)
60%, 80%, 100%
Session restart probability
0.04, 0.06, 0.08, 0.1, 0.12
Workload distribution
Uniform, Zipfian
4.1.4
Evaluation Setting. We implemented13 all methods in C++,
using the Eigen Linear Algebra Library [21] for matrix multipli-
cations. We opted for one of the most popular sparse matrix data
structures, which stores non-zero values and their positions in a
column-major order, the compressed sparse column layout (CSC).14
All source codes were compiled with the GNU Compiler (G++ ver-
sion 9.3.0) with o3 optimization enabled and the NDEBUG pre-
processor directive that suppresses assertions to reduce execution
time. All cache-based implementations are set to never store items
that exceed a size threshold equal to 80% of the available cache
size. This rule safeguards against evicting many useful results to
store just a single large one (indicatively, the rule applied in less
than 0.1% of the queries for all cache-based approaches in both
datasets considering the default setup with 4GB cache).
All experiments ran on an AMD Ryzen Threadripper 3960X CPU
machine @ 3.50GHz with 256GB RAM on Ubuntu 20.04 LTS. All
considered approaches were able to utilise all the available memory.
Specifically, the Neo4j approach runs on the Neo4j 4.2.5 Community
Edition, configured to allocate 31GB of JVM heap size and 205GB
of page size, as recommended.15 The remaining memory can be
allocated by Neo4j from the OS (native memory) hence all 256GB
of memory could be utilised in total (alternative configurations had
no significant impact on performance). In addition, Atrapos and
its competitors load data from CSV files into the main memory; this
ingestion time is not included in the reported query execution time.
Table 3 lists the parameters we investigate and the range of values
for each parameter, with default values in bold.
4.2
Evaluation against single-query methods
First, we assess Atrapos against the dense-matrix HRank and
Neo4j, using subsets of the Scholarly HIN (37𝑘nodes, 120𝑘edges)
and the News articles HIN (37𝑘nodes, 210𝑘edges), as HRank and
Neo4j cannot handle the full datasets due to their memory require-
ments. Figure 7a presents our results on execution time per query in
logarithmic scale. Atrapos surpasses contestants on both datasets.
Neo4j is over one order of magnitude slower than Atrapos, while
HRank is over two orders of magnitude slower than Neo4j.
Then, we examine Atrapos against HRank-S, using full size
HINs; HRank-S is a variant of HRank that takes advantage of sparse
matrix representations. Both Atrapos and HRank-S use the same
sparse matrix representations and the respective multiplication cost
estimation described in Section 3.2. However, Atrapos leverages
metapath query overlaps using a 4GB cache. Figure 7b presents
our findings on execution time per query. Atrapos outperforms
13Code available at https://github.com/atrapos-hin/artifacts
14CSC is the recommended sparse matrix layout in Eigen: https://eigen.tuxfamily.org/
dox/group__TopicStorageOrders.html
15https://neo4j.com/docs/operations-manual/current/tools/neo4j-admin-memrec/
(a) Vs. HRank & Neo4j
(dataset subsets, log scale).
(b) Vs. HRank-S (full dataset
sizes, linear scale)
Figure 7: Evaluation against single-query methods.
(a) Scholarly HIN
(b) News articles HIN
Figure 8: Evaluation against baseline caching approaches
with varying cache size.
HRank-S in both datasets with a speedup of 27% on the Scholarly
HIN and 23% in the News articles HIN.
4.3
Evaluation against baseline caching
While no existing approach exploits a caching mechanism to ac-
celerate the evaluation of a metapath query workload, evaluating
Atrapos solely against non-caching approaches cannot be fair.
Thus, we introduce CBS1 and CBS2, two HRank-S variants that
employ basic caching mechanisms (Section 4.1) and assess Atrapos
against them. We include HRank-S in the same experiment for ref-
erence. We first study performance vs. cache size and dataset size.
Then, we investigate workload parameters, i.e., the session restart
probability 𝑝and the selection of metapaths and constraints.
4.3.1
Varying cache size. Figure 8 presents the average execution
time per query vs. cache size. As HRank-S is oblivious to caching,
its execution time is independent of cache size. All cache-based
approaches outperform HRank-S in both datasets, while their ad-
vantage grows with cache size. CBS1 achieves faster times than
HRank-S by virtue of exploiting repetitive metapath queries; as
it caches only query results, it is slower than CBS2 and Atrapos.
Atrapos outperforms other contestants on both datasets, as it lever-
ages the Overlap Tree to identify frequent metapath overlaps and

---

Atrapos: Evaluating Metapath Query Workloads in Real Time
(a) Scholarly HIN
(b) News articles HIN
Figure 9: Evaluation against baseline caching approaches
with varying dataset size.
(a) Scholarly HIN
(b) News articles HIN
Figure 10: Evaluation against baseline caching approaches
varying session restart probability.
select matrix multiplication results for caching. Its cache manage-
ment policy refrains from inserting all intermediate results into the
cache, therefore its advantage over CBS2 is accentuated in small
cache sizes (2GB and 4GB).
4.3.2
Varying dataset size. Figure 9 illustrates the average execu-
tion time per query vs. network size. The 𝑥axis contains the number
of edges (in millions) for each dataset split (Section 4.1.1). All meth-
ods scale linearly with the number of edges. All three cache-based
approaches outperform HRank-S, with the difference being more
prominent in the Scholarly HIN. Atrapos clearly outperforms CBS1
and CBS2 on all dataset sizes.
4.3.3
Varying session restart probability 𝑝. Figure 10 shows the
improvement in execution time over HRank-S for CBS1, CBS2 and
Atrapos as the session restart probability 𝑝falls. As 𝑝grows, the
performance of all cache-based methods degrades, as there are fewer
queries per session on average, hence fewer overlaps to exploit.
Overall, Atrapos outperforms its competitors. Among the rival
methods, CBS2 surpasses CBS1, as it exploits intermediate results.
4.3.4
Zipfian query workloads. Figure 11 shows execution times
per query as we vary the distribution from which we select metap-
aths and constraints. Apart from the uniform distribution, used in
other experiments, we consider Zipfian distributions varying the
scaling parameter 𝛼. HRank-S achieves comparable execution times
(a) Scholarly HIN
(b) News articles HIN
Figure 11: Evaluation against baseline caching approaches
with the queries following the Zipf distribution.
(a) Scholarly HIN
(b) News articles HIN
Figure 12: Evaluation against baseline caching approaches
considering cumulative time per query.
in all settings as it does not take advantage of repetitions, while
cache-based approaches improve as 𝛼grows. As 𝛼rises, the proba-
bility of queries being repeated also increases, while smaller values
indicate a heavier tail in the probability distribution. Atrapos
outperforms competitors in all scenarios: it outperforms CBS1 by
exploiting query overlaps on top of the result that CBS1 caches. The
difference is more notable with 𝛼= 1.2 and 𝛼= 1.6, yet Atrapos
surpasses CBS1 even with 𝛼= 2, whereby a few queries are re-
peated in the workload. CBS2 exhibits significantly larger execution
times with Zipfian distributions, as caching intermediate results
bars it from exploiting all query repetitions.
4.3.5
Execution time per query. In our previous experiments, we
presented the average execution time per query across all query
workloads. Here, we investigate the performance of individual
queries, averaging the reported execution times by query posi-
tion across 10 workflows. Figure 12 shows the cumulative time
during workload execution; cache-based approaches are noticeably
faster than HRank-S, especially for the Scholarly HIN. Atrapos is
also considerably faster than CBS1 and CBS2 with the difference
increasing with the number of queries. Then, we investigate the
skewness of the query execution times for the same workloads.
Specifically, Figures 13a-b illustrate the execution time per query;
it is highlighted that Atrapos achieves considerable gains in some
of the slower queries. Figures 13c-d reconfirm previous findings as

---

Chatzopoulos and Vergoulis, et al.
(a) Scholarly HIN
(b) News articles HIN
(c) Scholarly HIN
(d) News articles HIN
Figure 13: Evaluation against baseline caching approaches
considering query execution time skewness.
(a) Scholarly HIN
(b) News articles HIN
Figure 14: Evaluation against cache replacement policies with
varying cache size.
each quartile of Atrapos starts lower than the respective ones of
the competitor approaches in both box plots.
4.4
Effect of cache replacement policies
We now benchmark our cache replacement policy against the Least
Recently Used (LRU) [3] and Popularity-aware Greedy Dual-Size
(PGDS) [52] policies (Section 3.4). We examine performance under
varying cache size (Section 4.4.1), dataset size (Section 4.4.2), session
restart probability 𝑝(Section 4.4.3) and distributions for selecting
metapath queries (Section 4.4.4). All methods utilise the Overlap
Tree to identify query overlaps; their difference lies solely in the
underlying cache replacement policy.
(a) Scholarly HIN
(b) News articles HIN
Figure 15: Evaluation against cache replacement policies with
varying dataset size.
(a) Scholarly HIN
(b) News articles HIN
Figure 16: Evaluation against cache replacement policies
varying session restart probability.
4.4.1
Varying cache size. Figure 14 shows our findings with vary-
ing cache size. Standard Atrapos outperforms PGDS, the best
performer among the rest on most scenarios; its advantage is more
prominent on Scholarly HIN. Yet, Atrapos is marginally faster than
the PGDS policy on News articles HIN; the most notable difference
appears with cache size equal to 8GB; at the same time, both cache
policies incorporating frequency and item size outperform LRU.
4.4.2
Varying dataset size. Figure 15 presents our results for all
policies as we vary the dataset size. We observe a linear increase in
execution time per query for all approaches as dataset size grows.
LRU performs poorly compared to the other approaches in both
datasets. Atrapos is faster than PGDS in most examined settings;
it is marginally faster in the Scholarly HIN, with performance gains
being more apparent when using the full News articles HIN dataset
that comprises 298.11 million edges.
4.4.3
Varying session restart probability 𝑝. Figure 16 presents per-
formance when varying the session restart probability𝑝. The speedup
falls for all methods as 𝑝grows, which is reasonable, as a larger 𝑝
results in sessions containing fewer queries and thus fewer overlaps
to exploit. Atrapos attains larger gains than other contestants in
most examined configurations. More noteworthy differences ap-
pear on the Scholarly HIN, especially for 𝑝equal to 0.04, 0.06 and
0.08. In the News articles HIN, Atrapos is faster for small values

---

Atrapos: Evaluating Metapath Query Workloads in Real Time
(a) Scholarly HIN
(b) News articles HIN
Figure 17: Evaluation against cache replacement policies with
the queries following the Zipf distribution.
(a) Scholarly HIN
(b) News articles HIN
Figure 18: Evaluation against cache replacement policies con-
sidering cumulative time per query.
of 𝑝i.e. 0.04 and 0.06, while PGDS achieves comparable results
with Atrapos for larger 𝑝. Both of them outperform LRU, with
significant differences in both datasets.
4.4.4
Zipfian query workloads. Figure 17 illustrates the perfor-
mance of the examined cache replacement policies while using a
Zipfian distribution for query workload generation. We observe a
notable performance improvement with all approaches when gener-
ating the query workload by a Zipfian distribution compared to that
when using a uniform distribution. Moreover, as parameter 𝛼of the
Zipfian distribution grows, the gains for all methods become more
prominent. A larger 𝛼indicates a higher probability for query rep-
etitions in the workload. PGDS and Atrapos achieve comparable
results on both datasets, with Atrapos being marginally faster with
the uniform distribution and the Zipfian with 𝛼equal to 1.6 and 2
on the Scholarly HIN. Still, both of these approaches outperform
the LRU on both datasets.
4.4.5
Execution time per query. Figure 18 shows the cumulative
times for the different cache replacement policies during work-
load execution. Atrapos and PGDS achieve comparable times, yet
Atrapos is slightly faster on the Scholarly HIN, as evident in Fig-
ure 18a. LRU is slower than its competitors in both datasets; the
difference is visible in the second half of both query workload ex-
ecutions. Figures 19a-b plot the execution time of each metapath
(a) Scholarly HIN
(b) News articles HIN
(c) Scholarly HIN
(d) News articles HIN
Figure 19: Evaluation against cache replacement policies con-
sidering query execution time skewness.
query for the same workloads. We discern some slower queries in
the Scholarly HIN (Figure 19a) in which LRU achieves considerably
higher execution times that the other two approaches. Last but not
least, Figures 19c reconfirms that PGDS and Atrapos are faster
than the LRU as each quartile in their box plots starts lower than
the respective quartile for LRU for the Scholarly HIN. Of course,
all considered approaches in this section utilise the Overlap Tree,
differing only in terms of the cache replacement policy. Therefore,
the difference in performance is small, confirming what someone
would expect.
5
RELATED WORK
Here, we review related work in HIN analysis, metapath query
evaluation, multi-query optimisation, and cache replacement.
5.1
HIN analysis
Heterogeneous information networks (HINs) are subject to grow-
ing attention, as they afford a convenient model to represent infor-
mation in several domains. Metapaths are instrumental in many
data mining tasks in HINs and are widely used to capture com-
plex semantics among HIN nodes. Several works rank HIN nodes
based on their centrality in a metapath-defined network [27, 30, 35].
HRank [48] co-ranks HIN nodes and relations based on the intu-
ition that important nodes are connected to other nodes through
important relations. Other works propose metapath-based simi-
larity measures among HIN nodes that encode different similarity
semantics and are used in a variety of similarity search and join
scenarios [46, 47, 57, 68]. As different metapaths reveal different

---

Chatzopoulos and Vergoulis, et al.
associations among HIN nodes, recent works incorporate metapath-
based connectivity in link prediction and recommendation HIN
analysis tasks [8, 13, 45]. Furthermore, several community detec-
tion algorithms have been proposed for HINs; some approaches
detect clusters that contain nodes of different types [50, 55, 60],
while others generate homogeneous clusters [58, 59, 72]. In par-
ticular, Pathselclus [58] uses user-defined metapaths as seeds and
automatically adjusts their weights during the clustering process.
As community detection algorithms take long time to form all
communities for large networks, [18] detects the community of a
given node in a HIN extending traditional metrics for community
cohesiveness to take metapaths into acccount.
5.2
Metapath query evaluation
A recent line of work focuses on metapath query evaluation. Shi et
al. [48] apply dynamic programming [16] to reorganize the order
of matrix multiplications required for metapath query evaluation,
thereby reducing computational cost. When small errors can be
tolerated, truncation strategies [10, 26] can be applied in each step
of matrix multiplication, zeroing values below a certain threshold.
Another approach follows a Monte Carlo strategy [31] to approxi-
mate the query result via random walkers; the number of which
strikes a balance in the tradeoff between accuracy and computation
cost. Unlike Atrapos, these techniques focus on the performance
of single-query evaluation, incognizant of data exploration work-
loads with naturally emerging overlapping queries. Finally, Sun et
al. [57] propose the offline materialisation of short metapaths in a
preprocessing stage and concatenate them at query time to make
the online evaluation of a single query more efficient.
5.3
Multi-query optimisation
Multi-query optimisation (MQO) has been heavily studied, in partic-
ular for relational databases [19, 24, 40–42]. These works generate
a globally optimal plan by computing common sub-expressions
within query batches once and reuse them. In addition, MQO tech-
niques have also been introduced in structural graph pattern search
using graph isomorphism [38]. Although these works share the
same principles as Atrapos, they do not focus on HINs while
they greatly differ assuming queries are evaluated in batches; this
requires that query workloads are known a priori to determine com-
mon computations across queries, which is not the case in real-time
applications. Atrapos, on the other hand, identifies query overlaps
in real-time and automatically caches the respective results if it is
beneficial (according to their occurrence frequency and their utility
for the evaluation of other queries). Lastly, MQO techniques for
RDF-triple stores have been proposed [32, 36]. However, apart from
the fact that RDF graphs are less compact than HINs and hence
likely to result in increased memory footprint and execution times,
such works consider graph pattern queries rather than metapaths;
thus, Atrapos is customized for metapath-based HIN analysis.
5.4
Cache replacement policies
There is a vast literature on cache replacement, especially in web
server caching [6, 37]. Much of that work follows the Least Re-
cently Used (LRU) policy [3]; LRU-MIN [1] favors retaining smaller
items in the cache, while LRU-S [54] incorporates the size of cached
items into a randomized caching mechanism. Size-adjusted LRU
(SLRU)[2], considers both the size and cost of cached items. Greedy
Dual-based approaches [9, 70] form another class of cache re-
placement policies. Notably, Popularity-aware GreedyDual-Size
(PGDS) [52] utilizes the frequency, size, and cost of cached items.
GreedyDual* (GD*) [23] adaptively adjusts the significance of re-
cency and frequency information over time. Other policies take into
consideration the size and frequency of cached items [20, 39, 51].
An interesting approach [5] balances the recency and frequency of
cached items with different costs with the help of a user-defined pa-
rameter. Nevertheless, none of the aforementioned policies consid-
ers the interdependence among cached items that inevitably appears
in a metapath query workload, as Atrapos does.
6
CONCLUSIONS
We introduced Atrapos, a method to evaluate metapath query
workloads in semantic knowledge graph and heterogeneous in-
formation network analysis tasks that exploits overlaps among
query patterns. Atrapos accelerates metapath computations us-
ing matrix multiplication algorithms tailored for sparse matrices
along with an appropriate cost model. Furthermore, it introduces an
overlap-aware cache replacement policy leveraging a tailor-made
data structure, the Overlap Tree, that identifies overlapping metap-
aths among queries. Our thorough experimental evaluation on two
large real-world HINs shows that Atrapos outperforms existing
approaches in efficiency across all examined scenarios.
ACKNOWLEDGMENTS
This work was partially funded by the EU H2020 project Smart-
DataLake (GA: 825041) and the EU Horizon Europe projects SciLake
(GA: 101058573) and STELAR (GA: 101070122).
REFERENCES
[1] Marc Abrams, Charles R Standridge, Ghaleb Abdulla, Stephen Williams, and
Edward A Fox. 1995. Caching proxies: Limitations and potentials. Technical
Report. Department of Computer Science, Virginia Polytechnic Institute & State.
[2] Charu Aggarwal, Joel L Wolf, and Philip S. Yu. 1999. Caching on the world wide
web. TKDE 11, 1 (1999), 94–107.
[3] Alfred V Aho, Peter J Denning, and Jeffrey D Ullman. 1971. Principles of optimal
page replacement. JACM 18, 1 (1971), 80–93.
[4] Matt Asay. [n.d.].
Neo4j’s $325 million venture suggests databases are cool
again.
https://www.techrepublic.com/article/neo4js-325-million-venture-
suggests-databases-are-cool-again/
[5] Hyokyung Bahn, Kern Koh, Sam H Noh, and SM Lyul. 2002. Efficient replacement
of nonuniform objects in web caches. Computer 35, 6 (2002), 65–73.
[6] Abdullah Balamash and Marwan Krunz. 2004. An overview of web caching
replacement algorithms. IEEE Communications Surveys & Tutorials 6, 2 (2004),
44–56.
[7] Paul Bieganski, John Riedl, John V Carlis, and Ernest F Retzel. 1994. Generalized
suffix trees for biological sequence data: applications and implementation. In
HICSS. 35–44.
[8] Bokai Cao, Xiangnan Kong, and Philip S. Yu. 2014. Collective Prediction of
Multiple Types of Links in Heterogeneous Information Networks. In ICDM.
50–59.
[9] Pei Cao and Sandy Irani. 1997. Cost-aware www proxy caching algorithms.. In
Usenix, Vol. 12. 193–206.
[10] Soumen Chakrabarti. 2007. Dynamic personalized pagerank in entity-relation
graphs. In WWW. 571–580.
[11] Serafeim Chatzopoulos, Kostas Patroumpas, Alexandros Zeakis, Thanasis Ver-
goulis, and Dimitrios Skoutas. 2020. SPHINX: a system for metapath-based
entity exploration in heterogeneous information networks. VLDB 13, 12 (2020),
2913–2916.
[12] Serafeim Chatzopoulos, Thanasis Vergoulis, Panagiotis Deligiannis, Dimitrios
Skoutas, Theodore Dalamagas, and Christos Tryfonopoulos. 2021. SciNeM:

---

Atrapos: Evaluating Metapath Query Workloads in Real Time
A Scalable Data Science Tool for Heterogeneous Network Mining.. In EDBT.
654–657.
[13] Hongxu Chen, Hongzhi Yin, Weiqing Wang, Hao Wang, Quoc Viet Hung Nguyen,
and Xue Li. 2018. PME: Projected Metric Embedding on Heterogeneous Networks
for Link Prediction. In SIGKDD. 1177–1186.
[14] Hsi-Wen Chen, Hong-Han Shuai, De-Nian Yang, Wang-Chien Lee, Chuan Shi,
S Yu Philip, and Ming-Syan Chen. 2021. Structure-Aware Parameter-Free Group
Query via Heterogeneous Information Network Transformer. In ICDE. 2075–
2080.
[15] Edith Cohen. 1998. Structure Prediction and Computation of Sparse Matrix
Products. Journal of Combinatorial Optimization 2, 4 (1998), 307–332.
[16] Thomas H. Cormen, Charles E. Leiserson, Ronald L. Rivest, and Clifford Stein.
2009. Introduction to Algorithms, 3rd Edition. MIT Press. http://mitpress.mit.
edu/books/introduction-algorithms
[17] Yixiang Fang, Kai Wang, Xuemin Lin, and Wenjie Zhang. 2021. Cohesive Sub-
graph Search over Big Heterogeneous Information Networks: Applications, Chal-
lenges, and Solutions. In SIGMOD. 2829–2838.
[18] Yixiang Fang, Yixing Yang, Wenjie Zhang, Xuemin Lin, and Xin Cao. 2020.
Effective and efficient community search over large heterogeneous information
networks. VLDB 13, 6 (2020), 854–867.
[19] Sheldon Finkelstein. 1982. Common expression analysis in database applications.
In SIGMOD. 235–245.
[20] Annie P Foong, Yu-Hen Hu, and Dennis M Heisey. 1999. Adaptive web caching
using logistic regression. In SSP. 515–524.
[21] Gaël Guennebaud, Benoît Jacob, et al. 2010. Eigen v3. http://eigen.tuxfamily.org.
[22] Xun Jian, Yue Wang, and Lei Chen. 2020. Effective and efficient relational
community detection and search in large dynamic heterogeneous information
networks. VLDB 13, 10 (2020), 1723–1736.
[23] Shudong Jin and Azer Bestavros. 2001. GreedyDual* Web caching algorithm:
exploiting the two sources of temporal locality in Web request streams. Computer
Communications 24, 2 (2001), 174–183.
[24] Tarun Kathuria and S Sudarshan. 2017. Efficient and provable multi-query
optimization. In Symposium on Principles of Database Systems (ACM SIGMOD-
SIGACT-SIGAI). 53–67.
[25] David Kernert, Frank Köhler, and Wolfgang Lehner. 2015. SpMacho - Optimizing
Sparse Linear Algebra Expressions with Probabilistic Density Estimation. In
EDBT.
[26] Ni Lao and William W Cohen. 2010. Fast query execution for retrieval models
based on path-constrained random walks. In SIGKDD. 881–888.
[27] Sangkeun Lee, Sungchan Park, Minsuk Kahng, and Sang Goo Lee. 2012. PathRank:
a novel node ranking measure on a heterogeneous graph for recommender
systems. CIKM.
[28] Kalev Leetaru and Philip A Schrodt. 2013. Gdelt: Global data on events, location,
and tone, 1979–2012. In ISA annual convention, Vol. 2. Citeseer, 1–49.
[29] Xiang Li, Danhao Ding, Ben Kao, Yizhou Sun, and Nikos Mamoulis. 2021. Lever-
aging Meta-path Contexts for Classification in Heterogeneous Information Net-
works. In ICDE. 912–923.
[30] Yitong Li, Chuan Shi, S Yu Philip, and Qing Chen. 2014. Hrank: a path based
ranking method in heterogeneous information network. In WAIM. 553–565.
[31] Jun S Liu. 2008. Monte Carlo strategies in scientific computing. Springer Science
& Business Media.
[32] Amgad Madkour, Ahmed M Aly, and Walid G Aref. 2018. Worq: Workload-driven
rdf query processing. In International Semantic Web Conference (ISWC). 583–599.
[33] Changping Meng, Reynold Cheng, Silviu Maniu, Pierre Senellart, and Wangda
Zhang. 2015. Discovering Meta-Paths in Large Heterogeneous Information
Networks. In WWW. 754–764.
[34] Thomas Neumann and Gerhard Weikum. 2010. The RDF-3X engine for scalable
management of RDF data. VLDB 19, 1 (2010), 91–113.
[35] Michaek Kwok-Po Ng, Xutao Li, and Yunming Ye. 2011. Multirank: co-ranking
for objects and relations in multi-relational data. In SIGKDD. 1217–1225.
[36] Nikolaos Papailiou, Dimitrios Tsoumakos, Panagiotis Karras, and Nectarios
Koziris. 2015. Graph-aware, workload-adaptive SPARQL query caching. In
SIGMOD. 1777–1792.
[37] Stefan Podlipnig and Laszlo Böszörmenyi. 2003. A survey of web cache replace-
ment strategies. CSUR 35, 4 (2003), 374–398.
[38] Xuguang Ren and Junhu Wang. 2016. Multi-query optimization for subgraph
isomorphism search. VLDB 10, 3 (2016), 121–132.
[39] Luigi Rizzo and Lorenzo Vicisano. 2000. Replacement policies for a proxy cache.
IEEE/ACM Transactions on Networking 8, 2 (2000), 158–170.
[40] Prasan Roy, Srinivasan Seshadri, S Sudarshan, and Siddhesh Bhobe. 2000. Efficient
and extensible algorithms for multi query optimization. In SIGMOD. 249–260.
[41] Timos Sellis and Subrata Ghosh. 1990. On the multiple-query optimization
problem. Transactions on Knowledge and Data Engineering (TKDE) 2, 02 (1990),
262–266.
[42] Timos K Sellis. 1988. Multiple-query optimization. TODS 13, 1 (1988), 23–52.
[43] Wei Shen, Jiawei Han, and Jianyong Wang. 2014. A probabilistic model for
linking named entities in web text with heterogeneous information networks. In
SIGMOD. 1199–1210.
[44] Baoxu Shi and Tim Weninger. 2014. Mining Interesting Meta-Paths from Complex
Heterogeneous Information Networks. In ICDM. 488–495.
[45] Chuan Shi, Binbin Hu, Wayne Xin Zhao, and Philip S. Yu. 2019. Heterogeneous
Information Network Embedding for Recommendation. TKDE 31, 2 (2019),
357–370.
[46] Chuan Shi, Xiangnan Kong, Yue Huang, S Yu Philip, and Bin Wu. 2014. Hetesim:
A general framework for relevance measure in heterogeneous networks. TKDE
26, 10 (2014), 2479–2492.
[47] Chuan Shi, Xiangnan Kong, Philip S Yu, Sihong Xie, and Bin Wu. 2012. Relevance
search in heterogeneous networks. In EDBT. 180–191.
[48] Chuan Shi, Yitong Li, Philip S. Yu, and Bin Wu. 2016. Constrained-meta-path-
based ranking in heterogeneous information network. Knowledge and Informa-
tion Systems 49, 2 (2016), 719–747.
[49] Chuan Shi, Yitong Li, Jiawei Zhang, Yizhou Sun, and S Yu Philip. 2016. A survey
of heterogeneous information network analysis. TKDE 29, 1 (2016), 17–37.
[50] Chuan Shi, Ran Wang, Yitong Li, Philip S Yu, and Bin Wu. 2014. Ranking-
based clustering on general heterogeneous information networks by network
projection. In CIKM. 699–708.
[51] Junho Shim, Peter Scheuermann, and Radek Vingralek. 1999. Proxy cache algo-
rithms: Design, implementation, and performance. TKDE 11, 4 (1999), 549–562.
[52] Shudong Jin and A. Bestavros. 2000. Popularity-aware greedy dual-size Web
proxy caching algorithms. In ICDCS. 254–261.
[53] Johanna Sommer, Matthias Boehm, Alexandre V. Evfimievski, Berthold Reinwald,
and Peter J. Haas. 2019. MNC: Structure-Exploiting Sparsity Estimation for
Matrix Expressions. In SIGMOD. 1607–1623.
[54] David Starobinski and David Tse. 2001. Probabilistic methods for web caching.
Performance Evaluation 46, 2-3 (2001), 125–137.
[55] Yizhou Sun, Charu C Aggarwal, and Jiawei Han. 2012. Relation strength-aware
clustering of heterogeneous information networks with incomplete attributes.
arXiv preprint arXiv:1201.6563 (2012).
[56] Yizhou Sun, Jiawei Han, Xifeng Yan, and Philip S Yu. 2012. Mining knowl-
edge from interconnected data: a heterogeneous information network analysis
approach. VLDB 5, 12 (2012), 2022–2023.
[57] Yizhou Sun, Jiawei Han, Xifeng Yan, Philip S. Yu, and Tianyi Wu. 2011. Path-
Sim: Meta Path-Based Top-𝑘Similarity Search in Heterogeneous Information
Networks. PVLDB 4, 11 (2011), 992–1003.
[58] Yizhou Sun, Jiawei Han, Peixiang Zhao, Zhijun Yin, Hong Cheng, and Tianyi
Wu. 2009. Rankclus: integrating clustering with ranking for heterogeneous
information network analysis. In EDBT. 565–576.
[59] Yizhou Sun, Brandon Norick, Jiawei Han, Xifeng Yan, Philip S Yu, and Xiao
Yu. 2013. Pathselclus: Integrating meta-path selection with user-guided object
clustering in heterogeneous information networks. TKDD 7, 3 (2013), 1–23.
[60] Yizhou Sun, Yintao Yu, and Jiawei Han. 2009. Ranking-based clustering of
heterogeneous information networks with star network schema. In SIGKDD.
797–806.
[61] Wojciech Szpankowski. 1993. A generalized suffix tree and its (un) expected
asymptotic behaviors. SICOMP 22, 6 (1993), 1176–1198.
[62] Jie Tang, Jing Zhang, Limin Yao, Juanzi Li, Li Zhang, and Zhong Su. 2008. Ar-
netMiner: Extraction and Mining of Academic Social Networks. In SIGKDD.
990–998.
[63] Esko Ukkonen. 1995. On-line construction of suffix trees. Algorithmica 14, 3
(1995), 249–260.
[64] Yue Wang, Zhe Wang, Ziyuan Zhao, Zijian Li, Xun Jian, Lei Chen, and Jianchun
Song. 2020. HowSim: A General and Effective Similarity Measure on Heteroge-
neous Information Networks. In ICDE. 1954–1957.
[65] Jim Webber. 2012. A programmatic introduction to neo4j. In SPLASH. 217–218.
[66] Cathrin Weiss, Panagiotis Karras, and Abraham Bernstein. 2008. Hexastore:
sextuple indexing for semantic web data management. VLDB 1, 1 (2008), 1008–
1019.
[67] Tao Xie, Yangjun Xu, Liang Chen, Yang Liu, and Zibin Zheng. 2021. Sequential
Recommendation on Dynamic Heterogeneous Information Network. In ICDE.
2105–2110.
[68] P. Yu Y. Xiong, Y. Zhu. 2014. Top-k Similarity Join in Heterogeneous Information
Networks. TKDE 27, 6 (2014), 1710–1723.
[69] Yixing Yang, Yixiang Fang, Xuemin Lin, and Wenjie Zhang. 2020. Effective and
efficient truss computation over large heterogeneous information networks. In
ICDE. 901–912.
[70] Neal Young. 1994. Thek-server dual and loose competitiveness for paging. Algo-
rithmica 11, 6 (1994), 525–541.
[71] Yongyang Yu, Mingjie Tang, Walid G. Aref, Qutaibah M. Malluhi, Mostafa Ab-
bas, and Mourad Ouzzani. 2017. In-memory distributed matrix computation
processing & optimization. In ICDE. 1047–1058.
[72] Yang Zhou and Ling Liu. 2013. Social influence based clustering of heterogeneous
information networks. In SIGKDD. 338–346.

---

