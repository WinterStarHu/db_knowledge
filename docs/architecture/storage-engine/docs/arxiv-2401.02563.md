# Kairos: Efficient Temporal Graph Analytics on a Single Machine

> 来源: https://arxiv.org/pdf/2401.02563

Kairos: Efficient Temporal Graph Analytics
on a Single Machine
Joana M. F. da Trindade
MIT CSAIL
jmf@csail.mit.edu
Julian Shun
MIT CSAIL
jshun@csail.mit.edu
Samuel Madden
MIT CSAIL
madden@csail.mit.edu
Nesime Tatbul
Intel Labs / MIT CSAIL
tatbul@csail.mit.edu
Abstract
Many important societal problems are naturally modeled as
algorithms over temporal graphs. To date, however, most
graph processing systems remain inefficient as they rely on
distributed processing even for graphs that fit well within a
commodity server’s available storage. In this paper, we in-
troduce Kairos, a temporal graph analytics system that pro-
vides application developers a framework for efficiently im-
plementing and executing algorithms over temporal graphs
on a single machine. Specifically, Kairos relies on fork-join
parallelism and a highly optimized parallel data structure
as core primitives to maximize performance of graph pro-
cessing tasks needed for temporal graph analytics. Further-
more, we introduce the notion of selective indexing and show
how it can be used with an efficient index to speedup tem-
poral queries. Our experiments on a 24-core server show
that our algorithms obtain good parallel speedups, and are
significantly faster than equivalent algorithms in existing
temporal graph processing systems: up to 60x against a
shared-memory approach, and several orders of magnitude
when compared with distributed processing of graphs that
fit within a single server.
1
Introduction
The growing demand for temporal graph applications has
given rise to new challenges in temporal graph analytics. As
an increasing number of real-world systems and processes
can be modeled as temporal graphs, the need for effective
analysis tools and techniques has become more pressing.
These applications range from social networks and commu-
nication systems to transportation networks and biological
systems, where understanding the temporal dynamics is cru-
cial for uncovering meaningful insights and patterns [1, 2, 3,
4].
Temporal graphs offer a unique perspective as they can
capture the dynamics of interactions and relationships over
c
d
f
e
g
b
a
[1,2]
[2,4]
[3,6]
[5,8]
[7,14]
[9,10]
[11,12]
Figure 1: An example temporal graph representing ver-
tices {𝑎,𝑏,𝑐,𝑑,𝑒, 𝑓,𝑔}. Each edge is associated with a time
interval (start, end) denoting its validity.
time, which non-temporal graphs are unable to provide. Fur-
thermore, temporal graphs lend themselves to the explo-
ration of time-ordered events and the impact of such se-
quences in the network, creating an opportunity for more nu-
anced insights. For instance, being able to track the chronol-
ogy of friendship formations on a social network or com-
munication events can enhance our understanding of behav-
ioral patterns. Similarly, the ability to observe the evolution
of transportation routes or the progression of a biological
system over time can provide critical data for predictive
modeling and decision-making.
However, the temporal dynamics inherent in these graphs
also brings about new challenges. Existing graph frameworks
and query systems frequently encounter difficulties when
handling graph processing tasks required in temporal graph
analytics applications. The underlying reasons for these chal-
lenges are twofold. First, many of these systems were primar-
ily designed for traditional graph processing, and as a result,
they are not well-equipped to handle the unique characteris-
tics and requirements of temporal graphs. This shortcoming
leads to suboptimal performance and a limited ability to fully
leverage the available temporal information in the data. Sec-
ond, some systems [5, 6, 7] that specifically target temporal
graph processing rely on Pregel-like distributed computa-
tion models. These models can be highly inefficient due to
the message passing overhead across servers in a cluster,
especially when the input graph fits comfortably within the
memory resources of a single commodity machine. This lim-
itation leads to suboptimal performance and an inability to
fully exploit the temporal information available in the data.
Finally, existing shared-memory temporal graph processing
systems [8] do not have these limitations, but still rely on
arXiv:2401.02563v1  [cs.DB]  4 Jan 2024

---

J. M. F. da Trindade et al.
expensive pre-processing of the graph that increases the
original size of the dataset – a step which is not necessary
for correctness of the target algorithms.
Temporal graph applications typically require querying
small time slices of data. While existing systems can repre-
sent time as an attribute of nodes and edges, filtering by time
necessitates either an expensive scan or the use of a range in-
dex, resulting in poor performance. Furthermore, traditional
graph processing frameworks lack support for temporal al-
gorithms, leading to complex and costly implementations as
they require additional programming effort.
Temporal graphs also exhibit unique properties that are
not necessarily considered in existing systems. For exam-
ple, they tend to be large due to the increased number of
attributes and edges, resulting from the preservation of inter-
actions between vertices over time. Additionally, temporal
graphs exhibit skewed data distributions, both in terms of
degree distributions and their evolution over time [9, 1]. To
address these challenges, temporal graph analytics systems
must provide interactive response times for various use cases,
such as operational decisions, contact tracing, and routing.
Our Approach and Contributions. In response to the
challenges described above, we have developed Kairos, an
in-memory temporal graph analytics system that leverages a
highly-optimized parallel data structure for to efficiently exe-
cute temporal algorithms over temporal graphs on multi-core
machines. Kairos is designed to address the unique prop-
erties and requirements of temporal graphs, providing an
efficient solution for processing large-scale temporal graphs.
Specifically, it introduces programming primitives and APIs
that organize temporal graphs by time, as well as a novel
Temporal Graph Index designed for efficiently looking up
data in specific time ranges. This approach enables efficient
temporal graph algorithm implementations, treating tempo-
ral edge information as first-class citizens in the model. The
system also incorporates selective indexing, a query opti-
mization technique that relies on a novel cost model to speed
up query execution by choosing the best access method for
neighbors of a given vertex at runtime.
We have implemented a number of parallel temporal graph
algorithms for various application classes, including single-
source shortest paths (earliest arrival, latest departure, fastest,
and shortest duration), connectivity (temporal connected
components), and centrality (temporal betweenness central-
ity). Our system provides significant performance improve-
ments compared to existing state-of-the-art temporal graph
processing systems. We make the following contributions:
I. We present TGER, a novel “time-first” data structure
that acts as an index to enable efficient processing of
temporal graph queries and algorithms.
II. We introduce selective indexing, a technique that speeds
up query execution by choosing the best access method
for retrieving neighbors of a given vertex at runtime.
III. We present efficient shared-memory parallel algorithm
implementations for various temporal graph applica-
tion classes, offering significant performance improve-
ments compared to existing state-of-the-art temporal
graph processing systems.
IV. Our results show substantial speedup compared to ex-
isting systems and provide insights into the perfor-
mance characteristics and guarantees of our system.
2
Background
2.1
Temporal Graph Data Model
A temporal graph is represented by the tuple 𝐺= (𝑉, 𝐸,𝑇,𝜏):
• 𝑉denotes a set of vertices.
• 𝐸denotes a set of edges.
• 𝑇= [0, 1, ...,𝑡𝑚𝑎𝑥] ∈N represents a discrete time domain.
• 𝜏: 𝑉× 𝑉× 𝑇× 𝑇→{𝐹𝑎𝑙𝑠𝑒,𝑇𝑟𝑢𝑒} is a function that
determines for each pair of vertices 𝑢, 𝑣∈𝑉, and each pair
of timestamps 𝑡𝑠𝑡𝑎𝑟𝑡,𝑡𝑒𝑛𝑑∈𝑇where 𝑡𝑠𝑡𝑎𝑟𝑡≤𝑡𝑒𝑛𝑑, whether
(𝑢, 𝑣) ∈𝐸, i.e., whether the edge (𝑢, 𝑣) exists during the
discrete time period from 𝑡𝑠𝑡𝑎𝑟𝑡to 𝑡𝑒𝑛𝑑.
In other words, each edge in a temporal graph is associated
with a discrete time interval indicating its validity. For in-
stance, in interaction networks, this time interval indicates
the period during which two vertices have interacted.
A weighted temporal graph is represented by the tuple
𝐺= (𝑉, 𝐸,𝑇,𝜏,𝑤), where 𝑤is a function that maps a tem-
poral edge (as defined above) to a real value (its weight).
The number of vertices in a temporal graph is 𝑛𝑣= |𝑉|, and
the number of edges is 𝑛𝑒= |𝐸|. Vertices are assumed to be
labeled from 0 to 𝑛𝑣−1. For undirected temporal graphs,
we use 𝑑𝑒𝑔(𝑣) to denote the number of edges incident to a
vertex 𝑣∈𝑉. In directed temporal graphs, vertices contain
both incoming and outgoing edges. We use deg+(𝑣) to denote
the number of outgoing edges, and deg−(𝑣) to denote the
number of incoming edges that a vertex 𝑣has.
2.2
Allen’s Interval Algebra
We draw inspiration from Allen’s Intervala Algebra [24] to
specify the relationships that subsequent edges in the same
path must have. The following subset of this algebra defines
the validity of temporal paths:
• Succeeds: For two time intervals 𝐴and 𝐵, 𝐵succeeds 𝐴if
and only if the end time of 𝐴is smaller than or equal to
the start time of 𝐵, i.e., end(𝐴) ≤start(𝐵).
• Strictly succeeds: 𝐵strictly succeeds 𝐴if and only if the
end time of 𝐴is strictly smaller than the start time of B,
i.e., end(𝐴) < start(𝐵).

---

Kairos: Efficient Temporal Graph Analytics
on a Single Machine
Category
Specific instantiation
Temporal Graph Algorithms
Temporal Minimal Paths
[Provenance] Tracking the origin and flow of information in different systems [10, 11]
[Indoor Routing] Temporal shortest paths that consider different obstacles for correct navigation [12, 13]
[Transportation] Route planning that considers real-time traffic conditions in transportation networks [14]
[Epidemiology] Identifying infection transmission paths in contact tracing [2]
Temporal Connectivity
[Social Networks] Analyzing community evolution and detecting temporal clusters [15, 16, 17, 18]
Temporal Centrality
[Epidemiology] Identifying critical nodes in the spread of infections [19]
Temporal Graph Queries
Time-constrained reachability [Social Networks] Analyzing influence propagation and information cascades [20, 21, 22]
Temporal subgraph matching [Bioinformatics] Detecting conserved patterns in dynamic biological networks [23, 3]
Table 1: A Categorization of tasks commonly performed in temporal graph analytics.
• Overlaps: 𝐵overlaps 𝐴if and only if the start time of 𝐴
is less than the start time of 𝐵, and the end time of 𝐴is
less than the end time of 𝐵, i.e., start(𝐴) ≤end(𝐵) and
end(𝐴) ≤start(𝐵).
We refer to this subset as ordering predicates in Kairos,
and describe its application in Section 4.1.
2.3
Temporal Graph Analytics Tasks
In Section 1, we outlined several use cases for temporal graph
analytics. Here, we provide a survey of applications of tempo-
ral graph analytics algorithms and queries from the literature,
listed in Table 1. For each algorithm and query, we present
an example application that relies on it as a core primitive for
analysis. We focus on a core set of algorithms that address
the most common use cases in temporal graph analytics and
can serve as primitives for building more advanced analysis
tasks. The primary categories for these algorithms are tem-
poral paths, temporal connectivity, and temporal centrality.
Temporal Paths: A temporal path in graph 𝐺is a path
where every subsequent edge in the path must satisfy certain
temporal constraints. Examples of minimal temporal paths
include earliest arrival, latest departure, fastest path, and
shortest path [25, 26].
Temporal Connectivity: Temporal connectivity deals with
the temporal version of connected components. This involves
identifying sets of vertices that are connected through time.
Temporal Centrality: Temporal centrality measures the
importance of a vertex in a temporal graph. An example of
interest is temporal betweenness centrality, which quantifies
how frequently a vertex appears on temporal shortest paths
between that vertex and other vertices in the graph.
2.4
The Compressed Sparse Row (CSR) Format
In the context of parallel graph processing, a common data
structure used to store graph data is the Compressed Sparse
Row (CSR) format. This format is largely preferred over other
competing data structures as it allows for efficient storage
and manipulation of sparse graphs, in which the majority of
potential edges are absent [27].
The CSR representation of a graph is characterized by the
use of three arrays: an adjacency array, an offset array, and a
vertex array. The adjacency array serves as a storage mech-
anism for destination vertices of all edges in a graph. The
edges are placed in a contiguous block of memory, where
they are sorted by the source vertex for outgoing edges, and
sorted by the destination vertex for incoming edges. This
efficient organization supports the fast retrieval of adjacent
vertices in graph traversal operations, as all vertices in the
same 1-hop neighborhood are located contiguously in mem-
ory. The offset array then stores the indices of outgoing /
incoming edges into the adjacency array. These indices mark
the starting point of the adjacency list for each vertex, en-
abling quick access to the set of edges associated with any
given vertex. Lastly, if there is no metadata associated to
vertices, then the vertex id is implicit (i.e., offset[𝑖] contains
the offset for vertex 𝑖), and no separate vertex ids array is
needed, which is the case for Kairos.
2.5
Shared-memory Graph Processing: Ligra
Ligra is a lightweight graph processing framework designed
for shared-memory parallel systems [28]. It enables efficient
parallel graph processing by employing a simple and flexible
programming model, making it easy for developers to write
high-performance algorithms for large-scale graphs.
The programming model of Ligra is centered around two
primary operations: EdgeMap and VertexMap. These opera-
tions enable parallel traversal of the graph and are responsi-
ble for most of the computation in a Ligra-based algorithm.
EdgeMap is a higher-order function that takes as input a
graph 𝐺, a subset of vertices 𝑉′, and an edge function 𝑓. It
applies the edge function 𝑓to all edges (𝑢, 𝑣) in the graph,
where 𝑢∈𝑉′ and 𝑣∈𝑉. The edge function 𝑓is responsible
for implementing the logic of the specific graph algorithm
and can perform various operations, such as updating vertex
properties or computing edge weights. EdgeMap efficiently
handles parallelism by processing edges in parallel, allowing
for scalable performance on shared-memory systems.
VertexMap is another higher-order function that takes as
input a graph 𝐺, a subset of vertices𝑉′, and a vertex function
𝑔. It applies the vertex function 𝑔to all vertices in 𝑉′. Similar

---

J. M. F. da Trindade et al.
to the edge function, the vertex function is responsible for
implementing the algorithm-specific logic and can perform
operations such as updating vertex properties or aggregat-
ing information from neighboring vertices. VertexMap also
processes vertices in parallel, ensuring scalable performance.
By using these two core operations, Ligra enables devel-
opers to write graph algorithms that can efficiently exploit
the parallelism offered by shared-memory systems. In the
context of Kairos, we build upon the Ligra programming
model and extend it to support temporal graph operations,
as we will discuss in the following sections.
2.6
Problem Formulation
The primary challenge in designing a temporal graph ana-
lytics system is to efficiently process and analyze temporal
graphs while taking into account the unique characteristics
of such graphs, such as time-varying edges and vertices. The
problem can be stated as follows: given a temporal graph
𝐺= (𝑉, 𝐸,𝑇,𝜏), our goal is to efficiently support the execu-
tion of temporal graph analytics tasks, including temporal
paths, temporal connectivity, and temporal centrality.
The example queries and algorithms discussed above re-
quire different strategies for selecting, at runtime, the appro-
priate set of vertices and temporal edges to be explored in the
frontier being traversed by the graph processing engine. The
efficiency of these strategies is crucial for the performance of
temporal graph analytics algorithms. In this paper, we aim
to address this challenge by introducing selective indexing
and other design decisions that help significantly improve
the performance of executing different tasks over an input
temporal graph. To address this problem, we must fulfill the
following desiderata:
(1) Efficient storage and indexing of temporal graph data,
especially as it pertains to temporal edges.
(2) Design and implementation of efficient parallel algo-
rithms for temporal graph analytics tasks, such as tempo-
ral paths, temporal connectivity, and temporal centrality.
(3) Effective runtime selection of the edges to be explored in
the frontier to minimize the time and space complexity
of the operations involved in the analytics tasks.
(4) Provide a flexible and easy-to-use programming model to
support the implementation of various temporal graph
analytics tasks and queries.
By addressing these aspects, our goal with Kairos is to
provide an efficient temporal graph analytics system that
can handle large-scale temporal graphs and deliver appro-
priate programming primitives for writing temporal graph
applications.
3
Architectural Overview and Key Ideas
Kairos provides an API that is compatible with that of a state-
of-the-art high-performance graph processing system ([28]),
Cardinality Estimator
Vertex Indexer
TGER Indexes
In-memory Index
Temporal CSR
Temporal edgeMap
Input Query
Input Graph
B
A
C
Selective Indexing
Figure 2: Architectural overview and key ideas.
and extends it to the temporal setting. The API provides
methods to load graphs, perform operations such as traversal,
filtering, and allows computations to be expressed in terms
of an input temporal query.
In the subsequent sections, we will delve deeper into the
key ideas behind our approach, as outlined in Kairos’s ar-
chitecture diagram (Figure 2). We introduce Kairos’s core
data structures, the need to choose between different access
methods, as well as the types of information needed to make
this decision. First, we describe a high-specialized parallel
data structure for indexing temporal edges (Section 3.1). Sec-
ond, we introduce novel approach to selectively decide which
subset of vertices are benefitial to index, as well as how to
access each vertex at runtime (Section 3.2) and associated
cost model.
3.1
Temporal Graph Edge Registry (Key Idea A)
Temporal graphs introduce an additional layer of complexity
in graph computation due to the addition of time as a variable.
To process queries and algorithtms over temporal graphs, one
could consider a naive approach based on CSR (Section 2.4).
With this approach, the entire list of edges associated to
a given vertex is stored in the corresponding offset of the
CSR, and then a parallel filter is applied to retrieve neighbors
satisfying an input temporal predicate. This can become
expensive, however, particularly in graphs with high-degree
vertices, or when the output of this filtering is much smaller
than the degree of the vertex. This can decrease performance,
as a large number of edges that are not relevant to the specific
input temporal predicate might need to be processed.
Therefore, the efficient processing of queries and temporal
algorithms over temporal graphs demands specialized data
structures for storing and retrieving vertex neighbors. To
this end, we have designed and implemented TGER (Tempo-
ral Graph Edges Registry), a parallel data structure based on
priority search trees [29] for effectively processing queries
and temporal algorithms over temporal graphs. TGER lets
Kairos treat temporal edge information as first-class citizens

---

Kairos: Efficient Temporal Graph Analytics
on a Single Machine
c
d
f
e
g
b
a
[1,2]
[2,4]
[3,6]
[5,8]
[7,14]
[9,10]
[11,12]
Input Graph
Temporal CSR (in-edges omitted)
CSR extension for temporal edges
d
c
a
b
g
e
f
Vertex ids
Oﬀsets
4
3
1
2
7
5
7
c
d
e
e
f
g
g
Dest. id
Start time
1
2
3
5
9
7 11
End time
2
4
6
8 10 14 12
TGERs
[3, 6]: c
X
[5, 8]: d
e (in-edges):
[7, 14]: e
[9, 10]: f
X
g (in-edges):
[7, 14]: g
[9, 10]: f
X
e (out-edges):
Figure 3: Data layout for example temporal graph in Figure 1. Temporal CSR is available for all vertices in the
graph (incoming edges omitted for sake of clarity). In this example, TGER is used to index only the vertices with
out or in-degree of at least two edges. In practice, Kairos only indexes vertices with much larger degrees.
in the data model, enabling efficient temporal graph algo-
rithm implementations. Moreover, TGER is storage-efficient
(i.e., 𝑂(𝑚) space, where 𝑚is the number of temporal edges
stored in it) and can answer interval containment queries
efficiently (𝑂(log𝑚+ 𝑘) work, where 𝑘is the number of
results [29]). Finally, TGER makes efficient use of computa-
tional resources, employing fork-join parallelism in its im-
plementation of both construction and query operations. As
we show in our experiments, TGER can provide a substantial
advantage over the naive CSR-based approach.
3.2
Selective Indexing (Key Ideas B and C)
The efficient retrieval of vertices and edges of interest is cru-
cial for the performance of algorithms and queries in large
graphs. This is particularly true for large-scale real-world
graphs, where data is often skewed, and a small number of
vertices can account for most edges. The skewness is inten-
sified in real-world temporal graphs, where data can also be
unevenly distributed over time (e.g., seasonal data patterns,
or growth in popularity in the case of social networks). Fur-
thermore, the skew present in real-world temporal graphs
is a well studied phenomena, and which can be attributed
to inter-contact time distributions, burstiness, and even cir-
cadian or otherwise weekly rhythms that are inherent in
human activity [1]. For this reason, different approaches
have been proposed to generate temporal graphs that are
closer to real-world skewed distributions [30, 31], and more
recently data imputation [32] that can handle skew.
To address this challenge, we introduce a new class of
problems in query optimization for graph queries, as well as
a unique technique for selectively indexing different parts of
a graph relevant to query answering. As part of our approach,
we present a novel cost model and related algorithms for de-
termining the most suitable access method (e.g., index-based
vs. scan-based) for graph traversal. Our algorithms take into
account the characteristics of the underlying data (e.g., data
skew) and workload (e.g., selectivity of temporal predicates
present in the queries) to choose the most efficient access
method (index vs. scan) for each vertex at runtime. Section 5
(Selective Indexing) provides a description of our technique.
Vertex Indexer. This component is responsible for deciding
which vertices warrant a TGER index. First, a vertex size is
defined in terms of the size of their out-degree or in-degree
neighborhood (i.e., how many outgoing or incoming edges
it has). Based on a predefined vertex size threshold (heuristi-
cally obtained via experimental analysis), the indexer builds a
TGER only for those vertices whose size exceeds this thresh-
old. To quickly identify which vertices have a TGER, the
Vertex Indexer maintains an in-memory sparse associative
array where each entry maps a vertex id to the in-memory
location of its corresponding TGER. At runtime, Kairos em-
ploys a cost model ( Section 5) to evaluate whether it should
access the corresponding TGER for that vertex, or opt for a
linear scan using Temporal CSR (T-CSR, Section 4.2).
Cardinality Estimator. We introduce a cost model for de-
ciding at runtime which access method to use for retrieving
a vertex’s neighborhood. As part of this cost model, a cardi-
nality estimator plays a key role in determining whether a
query is selective enough to warrant index-based retrieval of
outgoing/incoming edges via TGER. We further describe it
and its associated algorithms in Section 5.1 and Section 5.2.
4
Kairos Framework
This section describes the interface and implementation of
Kairos framework, with focus on how it extends Ligra [28]
to the temporal setting. Table 2 summarizes its interface.
4.1
Interface
Kairos contains two key data structures: VertexSet and Tem-
poralEdgeSet, which are used respectively to represent sub-
set of vertices and subset of temporal edges. OrderingPred-
icate takes as input a pair of temporal edges, an Ordering-
PredicateType, and evaluates whether the given temporal
edges conform to that predicate (Section 4.3). Using these
as input, TemporalGraph constructs the temporal graph.
VertexMap is equivalent to Ligra’s (Section 2.5), with the
only difference that it takes a TemporalGraph as input.
Conversely, TemporalEdgeMap extends Ligra’s EdgeMap
to the temporal setting, and is described in more details in
Section 4.4).

---

J. M. F. da Trindade et al.
Interface
Description
VertexSet
Represents a subset of vertices 𝑉′ ⊆𝑉.
TemporalEdgeSet
Represents a subset of temporaledges 𝐸′ ⊆𝐸.
OrderingPredicate(𝐴: temporaledge, 𝐵: temporaledge, 𝑇: OrderingPredicate-
Type): bool
Evaluates the order between two temporal edges based on one of the three ordering
predicate types: Suceeds, StrictlySucceeds, or Overlaps (Section 4.1).
TemporalGraph(𝑉: VertexSet, 𝐸: TemporalEdgeSet, 𝑃: OrderingPredicate)
Constructs a temporal graph using given input vertices, temporaledges, and ordering
predicate.
VertexMap(𝑈: VertexSet, 𝐺: TemporalGraph, 𝐹: vertex →bool): VertexSet
Applies 𝐹(𝑢) for each 𝑢∈𝑈; returns a VertexSet {𝑢∈𝑈| 𝐹(𝑢) = true}.
TemporalEdgeMap(𝑈: TemporalEdgeSet, 𝐺: TemporalGraph, 𝐹: temporaledge
→bool): TemporalEdgeSet
Applies 𝐹(𝑢) for each 𝑢∈𝑈; returns a TemporalEdgeSet {𝑢∈𝑈| 𝐹(𝑢) = true}.
Table 2: Core primitives from Kairos framework programming model interface.
v1
v2
v3
v4
v5
[1, 2]
[3, 5]
[2, 4]
[4, 6]
v1
v3
v4
succeeds
v2
v3
v5
overlaps
v1
v3
v5
strictly succeeds
v2
v3
v4
invalid
Figure 4: Ordering predicates for each of the four pos-
sible two-hop directed paths on an example graph.
4.2
T-CSR: Temporal CSR
The Temporal CSR (T-CSR) data structure is an extension of
the traditional CSR representation (Section 2.4) designed to
accommodate temporal graph data. It retains the core con-
cepts of CSR, while incorporating additional arrays to store
the start and end times associated with each temporal edge,
as shown in Figure 3. Specifically, it extends the standard
CSR representation by adding two more arrays, the start
time array, and the end time array. As their name suggests,
these arrays store the start and end times of each temporal
edge in the graph, respectively. They are organized in the
same order as the adjacency array, such that the start and
end times of the temporal edge at position 𝑖in the adjacency
array can be found at position 𝑖in the start / end time arrays.
With this extended representation, the T-CSR can store
temporal graphs and support various temporal graph pro-
cessing tasks. The additional start time and end time arrays
enable the system to take into account the temporal infor-
mation of the graph when executing queries and algorithms
when used in conjunction with TemporalEdgeMap (Sec-
tion 4.4). The T-CSR representation retains the advantages of
the traditional CSR, such as cache efficiency and fast access
to adjacency lists. Furthermore, it can be easily incorporated
into existing CSR-based graph processing systems with min-
imal modifications, such as is the case for our extension of
Ligra to the temporal setting. Overall, the Temporal CSR
offers an effective and efficient solution for storing and pro-
cessing temporal graph data. Because of that, it is the default
representation used to store the neighbors of most vertices in
Kairos. A similar representation is also used in the Temporal
GNN literature [33] for sampling temporal edges.
4.3
TGER: Temporal Graph Edges Registry
While T-CSR offers valuable improvements over traditional
CSR for temporal graph data handling, its design is still
geared towards adjacency-oriented queries and operations.
For example, T-CSR does an excellent job when dealing with
questions of “who is connected to whom”. However, it is less
efficient when it comes to handling range-based temporal
queries such as “who was connected to whom within a spe-
cific time window”. This is because in T-CSR, the temporal
information is appended to the existing structure, which
is space-optimized for traditional graphs (i.e., where edges
do not have additional temporal information). As a result,
each temporal query needs to scan over the entire adjacency
list of a vertex and filter out the relevant edges based on
their timestamps. While this operation can be performed
in parallel, it can still be inefficient for large graphs, or for
queries with small time windows (i.e., queries that are highly
selective) relative to the total neighbors a vertex has.
To address this challenge, we propose TGER, an index
data structure which accommodates temporal information
(in the form of time intervals associated with edges) as a first-
class citizen. TGER is a dual index, meaning it indexes both
the start and end time attributes. Specifically, it combines
a priority queue (by defaullt over the start time attribute)
and a Binary Search tree (BST) (by default over the end
time attribute). This allows queries with predicates on either
start or end time to be answered efficiently. It is heavily
inspired by Priority Seach Trees (PST) [29], a data structure
traditionally used for storing intervals or 2D points in the
context of computational geometry. In TGER, all queries are
3-sided (Figure 5), meaning that only one bound is specified
for one of the dimensions. This allows temporal edges to be
queried in 𝑂(log𝑚+ 𝑘), where 𝑚is the number of temporal
edges stored in it and 𝑘is the number of results from the
query. Figure 3 shows a visual representation of TGER’s data
layout, contrasting it with T-CSR, and Algorithm 1 shows
the pseudocode for TGER’s parallel build operation.
Ordering Predicates and 3-sided queries. A key aspect
of TGER is that the application can specify which of the
two dimensions of the intervals should be mapped to the

---

Kairos: Efficient Temporal Graph Analytics
on a Single Machine
Algorithm 1 Pseudocode for TGER index parallel build.
Input: A temporal graph 𝐺= (𝑉, 𝐸).
Output: If applicable, the TGER for each vertex in 𝐺.
1: procedure IndexVertices(𝐺)
2:
parallel for each 𝑣∈𝑉do
3:
𝑑= out-degree of 𝑣// Omitted: in-neighbors processing.
4:
if 𝑑≥min cutoff then // (Section 5)
5:
out-index[𝑣] = BuildIndex(𝑒∈out-edges of 𝑣)
6: procedure BuildIndex(𝐸)
7:
sorted = parallel-sort(E, ByStartTime())
8:
return BuildIndexRecurse(sorted, 0, sorted.size())
9: procedure BuildIndexRecurse(sorted, start, end)
10:
size = end - start
11:
if size == 0 then return nullptr
12:
if size == 1 then return new TGERNode(sorted[start])
13:
TGERNode* root = new TGERNode(sorted[start])
14:
start = start + 1
15:
mid-idx = index of point with median "end time" in sorted
16:
root->y-mid = sorted[mid-idx].end-time
17:
root->left
=
spawn
BuildIndexRe-
curse(sorted, start, mid-idx)
18:
root->right = BuildIndexRecurse(sorted, mid-idx, end)
19:
sync
Q1: start ≤6, 6 ≤end ≤9
Q2: start ≤5, 5 ≤end ≤8
Q3: start ≤9, 10 ≤end ≤13
[2, 4]: v1
mid: 6
[3, 6]: v2
mid: 5
[4, 5]: v3
mid: 5
[5, 7]: v4
mid: 7
[6, 9]: v5
mid: 9
[8, 10]: v6
mid: 10
[9, 13]: v7
mid: 13
Figure 5: Queries in TGER are 3-sided. By default, an
upper bound (min-heap mode) is specified for start time,
and a lower plus upper bound is specified for end time.
priority queue (or “heap”) axis, and which dimension should
be mapped to the “BST” axis. In addition, TGER can also
be configured as either a min-heap, or a max-heap. Given
this flexibility, both Succeeds and StrictlySucceeds order-
ing predicates can be translated to an equivalent 3-sided
query by flipping the axis and/or using a max-heap. The
Overlaps ordering predicate, however, requires both ends of
the interval of two subsequent edges to be checked against
each other, as can be seen in Figure 4. In that case, Tempo-
ralEdgeMap (Section 4.4) performs one additional query to
match in-neighbors with corresponding out-neighbors.
4.4
Temporal Edge Map
We introduce TemporalEdgeMap, a programming primitive
inspired by Ligra’s EdgeMap (Section 2.5), and designed to
efficiently handle temporal information during parallel pro-
cessing of temporal graphs. The TemporalEdgeMap extends
Algorithm 2 Pseudocode for Earliest Arrival in Kairos.
Input: A temporal graph 𝐺= (𝑉, 𝐸), a target vertex 𝑥∈𝑉, and a
time interval [𝑡𝑎,𝑡𝑏].
Output: 𝑡[𝑉]: The earliest-arrival time from 𝑥to every vertex
𝑣∈𝑉within query time interval [𝑡𝑎,𝑡𝑏].
1: procedure Update(𝑠,𝑑, [𝑡𝑠,𝑡𝑒])
2:
if 𝑡𝑠>= 𝑡𝑎or 𝑡𝑒> 𝑡𝑏then return 0
3:
if 𝑡𝑠< 𝑡[𝑠] or 𝑡𝑒>= 𝑡[𝑑] then return 0
4:
return writeMin(𝑡[𝑑],𝑡𝑒) and CAS(Visited[𝑑], 0, 1)
5: procedure Cond(𝑖)
6:
return (Visited[𝑖] == 0)
7: procedure EarliestArrival(𝐺,𝑥, [𝑡𝑎,𝑡𝑏])
8:
𝑡[𝑥] = 𝑡𝑏, 𝑡[𝑣] = ∞for all 𝑣∈𝑉\ {𝑥}
9:
Visited[𝑣] = 0 for all 𝑣∈𝑉
10:
Frontier = {𝑥}
11:
while Size(Frontier) ≠0 do
12:
Frontier = TemporalEdgeMap(𝐺, [𝑡𝑎,𝑡𝑏], Frontier, Up-
date, Cond, OrdPred.StrictlySucceeds)
Ligra’s EdgeMap to the temporal setting by incorporating
selective indexing (seeSection 5.1) to dynamically switch
between different scanning strategies (Temporal CSR scan
vs. TGER) depending on the query. Moreover, the primary
distinction between TemporalEdgeMap’s programming in-
terface and that of Ligra’s EdgeMap is that it allows for
mapping over temporal edges while specifying an ordering
predicate (Section 4.1) as input. Combined with TGER, the
TemporalEdgeMap acts as a parallel mapping function that
enables temporal graph algorithms to efficiently retrieve only
the edges that satisfy temporal predicates of interest, while
still respecting user-defined constraints regarding the valid-
ity of temporal paths in their applications. In Algorithm 2,
we demonstrate the use of TemporalEdgeMap to update
vertex frontiers for a parallel implementation of the earliest-
arrival temporal path algorithm [25]. This example illustrates
how the TemporalEdgeMap can be used to define complex
suitable temporal graph processing logic in the context of
parallel graph processing applications.
5
Selective Indexing Optimization
In this section, we introduce the concept of selective indexing.
As we described Section 3.2, the Vertex Indexer builds a TGER
only for those vertices whose size (as out/in-degree) meets
an experimentally obtained predefined vertex size threshold
(as of writing, currently set to 2k edges). With selective index-
ing, we propose a novel cost model and related algorithms to
determine the most appropriate access method for each vertex
in a temporal graph during traversal. The unique aspect of
the cost estimation problem we address is that it selectively
assigns different access methods (e.g., index vs full scan) for
the same query at runtime. As an example, while a conven-
tional relational query optimizer may select an in-memory

---

J. M. F. da Trindade et al.
Vertex v
Fetch edges from
Temporal CSR
Fetch edges from
TGER Index
yes
no
yes
no
Query q
q is 
selective?
v has
index?
Figure 6: Selective indexing: decision tree for accessing
a vertex’s neighboring edges given an input query.
hash index for all primary keys satisfying a PrimaryKey-
ForeignKey join, our selective indexing approach considers
the estimated selectivity for the query based on the value
of each primary key, as well as the anticipated number of
matches it has in the corresponding foreign key table.
Figure 6 presents the decision tree used by Kairos’s Vertex
Indexer (Figure 2) to determine the optimal candidate data
structure for accessing a vertex’s neighboring edges, given
an input temporal query. The following sections provide a
description of our selective indexing approach’s cost model
and associated algorithms.
5.1
Cost Model
To define a cost model for deciding when it is beneficial to
use TGER compared to a parallel scan over the T-CSR, we
need to consider the following factors:
Vertex degree distribution. The distribution of the number
of outgoing edges for each vertex is important because TGER
is only built (and potentially accessed) for vertices with more
than a certain number of outgoing (or incoming) edges. If
a large portion of the vertices have a high degree, the cus-
tom index will be more frequently accessed and contribute
more to the overall query performance. Furthermore, more
memory will also be used to store index data.
Temporal edges distribution. This refers to the distribu-
tion of start times and end times present in these edges for a
given vertex. These distributions indicate the expected num-
ber of matches for a given temporal predicate query interval.
Even though TGER is balanced, skew in the distribution of
start times can lead to more levels being traversed to retrieve
all edges that satisfy a given input predicate.
Query workload. For a given input temporal predicate,
Kairos needs to estimate the expected number of results for
a specific vertex corresponding to that query.
In summary, the distribution of the start and end times of
the temporal edges affects the selectivity of the queries. If the
distribution is such that the queries have a high degree of se-
lectivity (i.e., they filter out a significant portion of the data),
using the TGER will be more efficient. Conversely, if the
distribution is such that the queries have low selectivity (i.e.,
they return a large portion of the data), TGER’s performance
advantage over the T-CSR access method is reduced.
Taking these factors into account, we define a cost model
that estimates the time required for each method (index-
based using TGER and T-CSR-based) to execute a given query.
The model acts as a proxy for the estimated query processing
time given what we know about the graph (e.g., cardinality of
a vertex’s neighborhood), the query workload (e.g., estimated
selectivity of input query), and characteristics of the data
structures used for access (e.g., parallelism potential and
asymptotic complexity). For the TGER-based access method,
the cost model relies on the time complexity for PSTs, which
is 𝑂(log𝑚+𝑘), where 𝑚is the number of elements stored in
the data structure, and 𝑘is the number of results matching
the input query. A TGER is created for each vertex (Figure 6),
so 𝑚= 𝑑𝑒𝑔(𝑣), where 𝑣∈𝑉, which yields
𝑇𝑣= 𝑐· [log(𝑑𝑒𝑔(𝑣)) + 𝑘]
(1)
where 𝑐acts as a constant factor representing the average
cost of performing a single operation using TGER. The value
for 𝑐captures the parallelism potential when using TGER,
and is derived experimentally.
For the T-CSR access method, Kairos needs to perform a
parallel scan to filter out edges that satisfy the input temporal
predicate. Despite this operation being highly parallelizable
and cache-friendly, the asymptotic time complexity for this
scan is still 𝑑𝑒𝑔(𝑣), as all edges for 𝑣need to be scanned, with
𝑆𝑣= 𝑐′ · 𝑑𝑒𝑔(𝑣)
(2)
where 𝑐′ is a constant factor representing the average cost of
performing a single operation using the T-CSR. It performs a
role similar to that of 𝑐for TGER, and like 𝑐, it too is derived
experimentally. To decide which method is more beneficial
for a given query, we compare the estimated time costs for
both methods using the cost model. If the estimated time cost
for TGER method (𝑇𝑣) is lower than the estimated time cost
for the T-CSR array method (𝑆𝑣), then it is more beneficial
to use TGER. Our cost model parameterizes the cardinality
estimator based on the factors described above, with
𝐶𝑣=
(
𝑇𝑣
if 𝛽≤𝜃sel
𝑆𝑣
otherwise
(3)

---

Kairos: Efficient Temporal Graph Analytics
on a Single Machine
𝐶𝑣= the estimated cost of accessing a vertex’s neighbors
𝑇𝑣
= the cost of querying for vertex 𝑣’s neighbors in
TGER
𝑆𝑣
= the cost of scanning vertex 𝑣’s neighbors in T-CSR
that satisfy the input temporal predicate
𝛽
= the selectivity of the input temporal predicate,
defined as 𝑘/𝑚
𝜃sel = the selectivity threshold
For example, assuming a selectivity threshold 𝜃sel = 0.3
(i.e., queries retrieving 30% of the neighboring edges of a
vertex 𝑣), if the estimated selectivity 𝛽is less than 0.3 (e.g.,
0.2), then Kairos chooses TGER as the access method for
vertex 𝑣given input query 𝑞.
In theory, the choice of threshold primarily depends on the
relationship between 𝑘and 𝑑𝑒𝑔(𝑣). As 𝑘approaches 𝑑𝑒𝑣(𝑣),
the cost of using TGER converges to 𝑂(𝑑𝑒𝑔(𝑣)), rather than
𝑂(log(𝑑𝑒𝑔(𝑣))). In this case, it becomes more beneficial to
use T-CSR due to its higher parallelism potential. Parallelism
is higher for queries over T-CSR because they are imple-
mented as highly parallelizable scans over a parallel array.
On the other hand, TGER queries rely on divide-and-conquer
recursive parallel operations over a data structure that resem-
bles a BST in one dimension and a heap in another, leading
to reduced parallelism behavior as 𝑘nears 𝑑𝑒𝑔(𝑣). In prac-
tice, however, we determine which threshold to use from
experimental results, and find that 2k edges strikes a good
performance vs estimator accuracy balance. By selecting an
appropriate threshold, Kairos can decide at runtime whether
to use the TGER index or T-CSR for accessing a vertex’s
neighbors, thereby improving query performance compared
to a baseline [34] that only uses T-CSR.
5.2
Cardinality Estimation Algorithm
Our cardinality estimation algorithm aims to help determine
the best access method for each vertex while taking into ac-
count the temporal predicates present in the query workload
and the characteristics of the temporal graph being queried.
During the index construction phase (i.e., when building
the TGER indices), Kairos creates a 2D density histogram
for each vertex that meets the threshold for TGER index con-
struction. The dimensions of the histogram are the start time
and duration (end time −start time) of the edges equally
divided into 100 buckets per dimension, for a total of 10000
buckets, capturing the temporal distribution of a vertex’s
edges. At runtime, Kairos uses the histogram to estimate the
density of a vertex’s edges that would satisfy the query’s tem-
poral predicates. Depending on the estimated density and a
selectivity threshold, Kairos selects the most efficient access
method. If the estimated density is above the threshold, the
query execution for that vertex employs the associated TGER
index; otherwise, a parallel scan on the T-CSR is performed.
This enables Kairos to adapt the access method according
to the unique features of the temporal graph and the specific
temporal predicates in the query, leading to improved query
performance, as demonstrated in Section 6.
6
Experimental Results
In this section, we present the results of an experimental
evaluation of Kairos’s query performance and scalability.
Setup. We use a 2nd Generation Intel® Xeon® Scalable Pro-
cessor (Cascade Lake) system with 24 physical (48 virtual)
cores on each of its two NUMA nodes. The socket has a total
of 192GiB of DDR4 2666 MhZ RAM. Our programs use Cilk
Plus [35] and are compiled with OpenCilk’s [36] clang ver-
sion 14 and -O3 flag. All of the parallel speedup numbers that
we report are based on the running time on 24-cores (single
socket) without hyper-threading compared to the running
time on a single thread.
Datasets. Table 3 shows the number of vertices (|𝑉|), num-
ber of edges (|𝐸|), maximum out-degree (max𝑣∈𝑉deg+(𝑣)),
maximum in-degree (max𝑣∈𝑉deg−(𝑣)), and average degree
(avg𝑣∈𝑉deg(𝑣)) for each of the datasets under use. The syn-
thetic data set comprises a temporal graph in which vertices
are log-normally distributed, the inter-arrival times of start
times follow a Poisson distribution, and the edge durations
follow an uniform distribution. If the temporal edges in a
dataset only have start times, then end time is sampled from
a uniform distribution, similar to what is done in [25, 26].
Name
|𝑉|
|𝐸|
max𝑣∈𝑉deg+(𝑣)
max𝑣∈𝑉deg−(𝑣)
avg𝑣∈𝑉deg(𝑣)
bitcoin [37]
4.80 × 107
1.13 × 108
2.66 × 106
2.53 × 106
4
netflow [38]
3.72 × 108
1.20 × 109
5.78 × 105
1.82 × 108
12
reddit-reply [37]
1.17 × 107
6.46 × 108
3.92 × 105
9.94 × 105
110
stackoverflow [39]
6.02 × 106
6.34 × 107
1.01 × 105
93143
20
transportation [40]
41794
7.93 × 107
50881
50625
3798
twitter-cache [41]
94226
8.55 × 108
5.21 × 106
2.31 × 105
36328
synthetic
107
109
5.65 × 107
3.08 × 107
99
Table 3: Temporal graphs used for evaluation
1
2
4
8
16
24
Number of threads
0
10
20
30
40
Runtime (seconds)
E. Arrival
Fastest
L. Departure
S. Duration
Figure 7: Running time vs number of threads on a
smaller synthetic dataset (500M edges).
6.1
Scalability
Table 4 shows the sequential and parallel running times of
our algorithms, as well as their parallel speedup. Runtimes
are reported as an average of ten runs. Except for T. BC, T.
CC, k-core, and PageRank, all algorithm runtimes use a single
source vertex. For algorithms requiring a single source, we se-
lected the top 100 vertices based on their out-degree, leading

---

J. M. F. da Trindade et al.
to 100 runs in a single execution. For PageRank, the reported
runtimes cover 100 iterations. T. BC uses the number of tem-
poral S. Duration paths when calculating centrality for each
vertex. The algorithms E. Arrival, L. Departure, Fastest, and
S. Duration inherently expect a start and end time in their
original definitions. For BC, BFS, CC, 𝑘-core, and PageRank,
we have adapted the original algorithms to accept a start
and end time as input. For every algorithm, we set the start
time to align with the 95th percentile of the latest start times
in the dataset. The end time is set to the maximum value,
representing the 100th percentile.
The algorithms overall get good parallel speedup, with
a maximum of 22.6x and mean speedup 8.7x. The lower
speedups are in general observed in the smaller datasets, as
they are too small to benefit from parallel processing. How-
ever, the larger speedups are not necessarily always observed
in the largest dataset. Rather, they seem to be influenced by
a number of factors, including how skewed the vertex de-
gree distribution is, as well as fraction of edges matching
the input temporal predicate. In other words, while we use
the same query interval size for all experiments, the edges
matching that input query predicate (i.e., its selectivity) may
not be evenly distributed over all vertices, and thus do not
offer the same parallelism potential. Furthermore, some co-
routines in Kairos are only parallelized if the minimum
number of interations meets an heuristic threshold (e.g., at
least 1000 iterations in parallel cilk_for loops), which again
may be influenced by skew in the underlying vertex-degree
and inter-arrival times distribution for a given dataset.
Figure 7 shows the running time vs. number of threads
for all of the minimal temporal paths over a smaller synthet-
ically generated dataset (500M edges). We see good parallel
scalability for all of these algorithms, with speedups ranging
from 5x to 8x, though see little benefit from 16 to 24 cores.
1%
2%
3%
4%
5%
6%
7%
8%
9%
10%
Query window size (% of most recent edges)
0
25
50
75
100
125
Runtime (ms)
1M edges
10M edges
100M edges
Figure 8: Runtimes vs. query window size (fraction of
most recent edges) for different TGER sizes.
6.2
Impact of Selective Indexing
Figure 9 shows a comparison against a Temporal Ligra base-
line [34], i.e., T-CSR is used for all vertices and no selective
indexing is present, as described in Section 4.2. As far as
we know, this is the fastest available shared-memory im-
plementation of graph processing algorithms (temporal and
traditional) over temporal graphs. The algorithms are config-
ured in the same manner as in Section 6.1, and here we show
the running times for a subset comprised mostly of temporal
minimal paths, and over one small (reddit-reply), and two
large datasets (twitter-cache and synthetic). Our results show
that the selective indexing approach does reasonably well,
with up to 8x improvement in some cases. As expected, the
highly selective queries are the ones with the most improve-
ment. Furthermore, between 10% and 20% selectivity, the
T-CSR approach starts being more advantageous.
6.3
Microbenchmark: TGER query runtimes
Figure 8 shows the time it takes to run a query over a single
TGER of various sizes (synthetically generated 1M, 10M and
100M edges). We note that each TGER in Kairos is associated
to a single vertex. In other words, the running times reported
in this experiment should be interpreted as the amount it
takes to retrieve edges of interest from a single vertex that has
been indexed with TGER. Similar to the results reported in
experiments above, input queries are sized to match a portion
of the most recent edges (by start time) in the input data (in
this case, a vertex’s neighboring edges). Results here show
that it takes less than 125 milliseconds to retrieve roughly
10% of a TGER with 100M edges.
6.4
Comparison to Alternatives
Distributed memory. Although a direct comparison with
Tink, ICM is challenging due to their distributed memory de-
sign, we offer a comparison based on the runtimes presented
in their papers [6, 5]. Using 8 cores, Tink processes the E.
Arrival algorithm for just one source vertex in 37s on a syn-
thetic graph of 25 million edges. In contrast, Kairos, with the
same number of cores, processes the same algorithm for the
100 source vertices (equivalent to 100 runs) on a synthetic
dataset of 500M edges, as shown in Figure 7 in less than 10s.
Put simply, for E. Arrival – the sole algorithm with reported
runtimes by Tink – Kairos handles data that’s 20 times larger,
addresses 100 times more source vertices, and completes the
task in a third of the time. We could not locate total runtimes
for ICM in its publication. However, in its “weak scaling”
analysis, it reports nearly 500 seconds to run E. Arrival on a
single source vertex for a graph segment with 100M edges,
using 8 cores. Kairos, in contrast, requires under 10 seconds
for 100 vertices on 500 million edge dataset (Figure 7). In
essence, when compared with ICM, Kairos operates 50 times
faster, handles 100 times more algorithm executions, processing
a dataset that is 50 times larger.
Shared memory. At the time of writing, the only other tem-
poral graph analytics system in this category is TeGraph [8].
We have contacted the authors, who shared an implementa-
tion of shortest paths with us, as well Delicious, one of the

---

Kairos: Efficient Temporal Graph Analytics
on a Single Machine
2%
3%
4%
5% 10% 20%
0.00
0.25
0.50
0.75
1.00
E. Arrival: synthetic
2%
3%
4%
5% 10% 20%
Fastest: synthetic
2%
3%
4%
5% 10% 20%
T. CC: synthetic
2%
3%
4%
5% 10% 20%
S. Duration: synthetic
2%
3%
4%
5% 10% 20%
0.00
0.25
0.50
0.75
1.00
E. Arrival: twitter-cache
2%
3%
4%
5% 10% 20%
Fastest: twitter-cache
2%
3%
4%
5% 10% 20%
T. CC: twitter-cache
2%
3%
4%
5% 10% 20%
S. Duration: twitter-cache
2%
3%
4%
5% 10% 20%
0.00
0.25
0.50
0.75
1.00
E. Arrival: reddit-reply
2%
3%
4%
5% 10% 20%
Fastest: reddit-reply
2%
3%
4%
5% 10% 20%
T. CC: reddit-reply
2%
3%
4%
5% 10% 20%
S. Duration: reddit-reply
Query window size (% of edges with most recent start times)
Normalized Average Runtime
T-CSR
Sel. Indexing
Figure 9: Normalized average runtime vs input query window size. Boundaries of the input query are varied so as
to match exactly against a fixed percentage of most recent edges present in the corresponding temporal graph
dataset. Runtimes are normalized against T-CSR as baseline [34].
datasets they used for evaluation. This dataset has around
300M edges, and 34M vertices. Unfortunately, we were not
able to reproduce the results in [8], which report around
one second as the total runtime for executing shortest path
on the aforementioned dataset using 100 source vertices. In-
stead, we find that their implementation of shortest path
takes around three seconds to process a single vertex, regard-
less of which vertex is provided as input. Extrapolating from
this result, we get around 300 seconds to process 100 source
vertices – as opposed to the one second reported in their
paper. Furthermore, the results for their “OnePass” baseline
(which is closer to our approach) are significantly slower
than Kairos. Specifically, for the same Delicious dataset,
their “OnePass” baseline takes close to 90 seconds for 100
vertices using 16 threads on a 8-core machine. Kairos, on the
other hand, takes around five seconds using 8 cores, which is
a 18x speedup compared to their “OnePass” baseline, and 60x
compared to our local results from their implementation.
6.5
Selective Indexing: Estimator Accuracy
In Section 5.1, we proposed a novel approach for selectively
indexing a subset of vertices in a temporal graph, as well as
cost model for deciding which access method to use for each
vertex at runtime. In this section, we present an experiment
assessing the accuracy of the cardinality estimator, a key
component of our proposed cost model. For this evaluation,
we vary the size of an input temporal predicate, and use a
selectivity threshold of 20% (the “q is selective?” decision in
Figure 6). As in the experiments we describe above, here we
also vary the size of an input query interval to purposefully
match against a percentage of the most recent edges (by start
time) in the dataset. To measure accuracy, we define true
positives as “should use TGER, and did” and true negatives
as “should not use TGER, and did not”. Specifically, “should”
here takes into account the estimated selectivity compared
to an oracle with the actual selectivity of the query. Further-
more, we only evaluate this decision for vertices that have
been large enough to be indexed with a TGER (otherwise,
no decision needs to be made, as T-CSR is used a 100% of the
time), and vary the minimum cutoff for indexing from 1k to
8k edges (multiples of 2). We find that for all datasets, the
accuracy of this decision stays consistently above 90% for
input query intervals sized under 1%, and above 95% for all
other input query interval sizes we assessed (2 through 5%,
10%, and 20%). Furthermore, the accuracy also increases as a
function the cutoff size. As expected, this increase is largely
due to the cardinality estimator’s 2D density histogram (Sec-
tion 5.2) having more samples in this case.
7
Related Work
Temporal Graph Analytics. While the authors of [25, 26]
have been the first to propose one-pass parallel versions
of temporal graph algorithms, as far as we know [8] is the

---

J. M. F. da Trindade et al.
bitcoin
netflow
reddit-reply stackoverflow transportation
twitter-cache
synthetic
Application 𝑇1
𝑇24
SU
𝑇1
𝑇24 SU
𝑇1
𝑇24 SU
𝑇1
𝑇24
SU
𝑇1
𝑇24
SU
𝑇1
𝑇24
SU
𝑇1
𝑇24 SU
E. Arrival
74.2 7.87 9.4
124.8 21.6 5.8 3.89 .76 5.1 17.1 1.99 8.6 58.8 6.49 9.1
246.9 16.11 15.3 440 31.7 13.9
L. Departure56.4 6.63 8.5
125.2 22
5.7
5.1 .76 3.9 11.2 1.53 7.3 45.4 5.22 8.7
214.2 15.15 14.1 391 30.6 12.8
Fastest
56.3 7.73 7.3
185.6 31.6 5.9 5.81 1.11 5.2 9.16 1.32 6.9 38.7 4.73 8.2
222.6 12.84 17.4 311 23.1 13.5
S. Duration 56.6 7.76 7.3
187 32.2 5.8 5.84 1.07 5.5 9.22 1.33 6.9
2.7 19.7 7.3
12.84 223.5 17.4 285 21.6 13.2
T. BFS
8.5 1.5
5.7
97.2 16.5 5.9
1.9
.4
4.8
.8
.2
4
.009 .002 4.5
9.8
1.4
7
19.6 3.2 6.2
T. CC
5.65 .59
9.6
24.4 2.2 11.1 3.99 .2 19.9 1.85 .11 16.8 6.83 .49 13.9
10.2
.71 14.4 5.41 4.57 1.2
T. k-core
13.7 1.22 11.4
38.9 3.6 10.8 32.4 4.2 7.7
2.2
.4
5.5
.02 .01
2
2.7
.9
3
2
.5 4
T. BC
10.8 .57 18.95 8.04 1.26 6.38 .032 .168 5.25 .085 .014 6.07 .005 .003 1.67
2.84 .692 4.1 4.57 3.76 1.22
T. PageRank 65.3 5.23 12.5
35.8 2.6 13.8 11.3 .50 22.6 8.51 .42 20.3 2.6 .21 12.4 17.22 1.2 14.4
11 4.62 2.4
Table 4: Running times (in seconds) of single-threaded (𝑇1), 24-core no hyper-threading (𝑇24), and parallel speedup
as single-thread time divided by 24-core time (SU).
only other shared-memory temporal graph analytics system.
Previous systems for temporal graph analytics have primarily
relied on distributed message passing, often building upon
programming paradigms like Pregel or stateful data stream
processing frameworks such as Apache Flink [5, 42, 6, 7]. The
large number of messages exchanged when relying on these
programming paradigms imposes considerable overhead on
graph processing. This becomes particularly noticeable in
the case of graphs that fit within available memory of current
commodity servers, as shown by the speedups we get when
compared against these systems.
Time-evolving Graph Engines. There has been significant
work on developing frameworks for processing of graphs
that evolve over time [43, 44, 45, 46, 47]. While these sys-
tems allow processing of snapshots, streaming graphs, or
dynamic graphs dynamic graphs, for their most part they do
not support temporal graphs. Rather, timestamps associated
to edges or vertices are treated as graph updates in these
systems. For this reason, we consider these orthogonal.
Range Query Data Structures. There has been extensive
work on data structures to handle range queries. Traditional
range query data structures often used in relational systems
include quad-trees, R-trees, kd-trees. Specifically aimed at
interval data – such as that present in temporal edges – are
interval trees, segment trees, and priority search trees [29].
All three of these data structures have runtime complexity of
𝑂(𝑙𝑜𝑔𝑛+ 𝑘), where 𝑘is the number of results for the range
query. Where they differ is on space complexity, which is
highest for segment trees at 𝑂(𝑛𝑙𝑜𝑔𝑛), as well as on prop-
erties relating to how they can be queried (e.g., stabbing
vs 3-sided queries). The index for storing temporal edges
that we introduce in this paper is a highly-optimized and
specialized version of a priority search tree.
GNNs. Graph Neural Networks (GNNs) have emerged as a
powerful framework for learning representations of graph-
structured data, tackling problems in various domains such
as social networks, molecular biology, and recommendation
systems [48, 33, 49]. GNNs rely on the underlying graph
structure and the attributes of nodes and edges to learn com-
plex patterns and make predictions, with recent increased
focus on temporal graphs [33, 4]. By employing efficient
graph analytics algorithms, these systems can compute a
wide range of graph properties, such as centrality measures,
graph motifs, or community structures, which can then be
used as additional input features for GNNs. In the context of
GNNs, most related to our work is the version of Temporal
CSR used for sampling temporal edges in [33]. While it does
not account for end time edges, as far as we know this is the
only other work that extends CSR to the temporal setting.
8
Conclusions
We presented Kairos, a temporal graph analytics system
that provides application developers a framework for effi-
ciently executing temporal algorithms over temporal graphs.
Specifically, it employs TGER, a highly-optimized parallel
data structure, as efficient index for temporal graph process-
ing. Kairos is built atop Ligra [28], a state-of-the-art parallel
graph processing system. With TGER, Ligra’s vertex-centric
computational model takes advantage of locality that is nat-
urally occurring on temporal graphs and queries over such
graphs. We show in our experiments that using Kairos, a
number of minimal temporal path algorithms are up to 8x
times faster than an already competitive baseline [34], which
we also provide. When compared with alternative shared-
memory system, it achieves up to 60x speedups.
Acknowledgments
This research is supported by DOE Early Career Award #DE-
SC0018947, NSF CAREER Award #CCF-1845763, and by Intel
as part of the MIT Data Systems and AI Lab (DSAIL) at MIT.
Joana M. F. da Trindade was partially supported by an Alfred
P. Sloan UCEM PhD Fellowship, and a Microsoft Research
PhD Fellowship.

---

Kairos: Efficient Temporal Graph Analytics
on a Single Machine
References
[1]
P. Holme and J. Saramäki. “Temporal networks.” In:
Physics Reports 519 (2012), pp. 97–125. url: http://
arxiv.org/abs/1108.1780.
[2]
M. Wu et al. “Use of temporal contact graphs to un-
derstand the evolution of COVID-19 through contact
tracing data.” In: Nature Commun. Phys 5 (2022).
[3]
R. Lambiotte, M. Rosvall, and I. Scholtes. “From net-
works to optimal higher-order models of complex sys-
tems.” In: Nature Phys. 15.4 (2019), pp. 313–320.
[4]
S. Huang et al. “Temporal Graph Benchmark for Ma-
chine Learning on Temporal Graphs.” In: (2023). arXiv:
2307.01026 [cs.LG].
[5]
S. Gandhi and Y. Simmhan. “An interval-centric model
for distributed computing over temporal graphs.” In:
ICDE. 2020, pp. 1129–1140.
[6]
W. Lightenberg, Y. Pei, G. Fletcher, and M. Pechenizkiy.
“Tink: A Temporal Graph Analytics Library for Apache
Flink.” In: WWW. 2018, pp. 71–72.
[7]
C. Rost, K. Gomez, M. Täschner, P. Fritzsche, L. Schons,
L. Christ, T. Adameit, M. Junghanns, and E. Rahm. “Dis-
tributed temporal graph analytics with GRADOOP.”
In: PVDLB (2022), pp. 375–401.
[8]
C. Huan, H. Liu, M. Liu, Y. Liu, C. He, K. Chen, J.
Jiang, Y. Wu, and S. L. Song. “TeGraph: A Novel
General-Purpose Temporal Graph Computing Engine.”
In: ICDE. 2022, pp. 578–592.
[9]
J. Leskovec, J. Kleinberg, and C. Faloutsos. “Graphs
over time: densification laws, shrinking diameters and
possible explanations.” In: KDD. KDD. 2005, pp. 177–
187.
[10]
B. Erb, D. Meißner, J. Pietron, and F. Kargl. “Chrono-
graph: A Distributed Processing Platform for Online
and Batch Computations on Event-Sourced Graphs.”
In: DEBS. 2017, pp. 78–87.
[11]
Q. Wang et al. “You Are What You Do: Hunting
Stealthy Malware via Data Provenance Analysis.” In:
NDSS. 2020.
[12]
C. Anastasiou, C. Costa, P. K. Chrysanthis, C. Sha-
habi, and D. Zeinalipour-Yazti. “ASTRO: Reducing
COVID-19 Exposure through Contact Prediction and
Avoidance.” In: ACM Trans. Spatial Algorithms Syst.
8.2 (2022), pp. 1–31.
[13]
T. Liu, H. Li, H. Lu, M. A. Cheema, and L. Shou. “To-
wards Crowd-Aware Indoor Path Planning.” In: PVLDB
(2021), pp. 1365–1377.
[14]
L. Li, S. Wang, and X. Zhou. “Time-Dependent Hop
Labeling on Road Network.” In: ICDE. 2019, pp. 902–
913.
[15]
H. Qin, R.-H. Li, Y. Yuan, G. Wang, L. Qin, and Z.
Zhang. “Mining Bursting Core in Large Temporal
Graphs.” In: PVLDB (2022), pp. 3911–3923.
[16]
J. Yang, M. Zhong, Y. Zhu, T. Qian, M. Liu, and J. X.
Yu. “Scalable Time-Range k-Core Query on Temporal
Graphs (Full Version).” In: PVLDB (2023), pp. 1168–
1180.
[17]
M. Yu, D. Wen, L. Qin, Y. Zhang, W. Zhang, and X. Lin.
“On querying historical k-cores.” In: PVLDB (2021),
pp. 2033–2045.
[18]
R.-H. Li, J. Su, L. Qin, J. X. Yu, and Q. Dai. “Persistent
community search in temporal networks.” In: ICDE.
2018, pp. 797–808.
[19]
M. Ciaperoni, E. Galimberti, F. Bonchi, C. Cattuto, F.
Gullo, and A. Barrat. “Relevance of temporal cores for
epidemic spread in temporal networks.” In: Scientific
reports 10.1 (2020), p. 12529.
[20]
M. G. Rodriguez, J. Leskovec, D. Balduzzi, and B.
Schölkopf. “Uncovering the structure and temporal
dynamics of information propagation.” In: Network
Science 2.1 (2014), pp. 26–65.
[21]
D. Notarmuzi, C. Castellano, A. Flammini, D. Mazzilli,
and F. Radicchi. “Universality, criticality and complex-
ity of information propagation in social media.” In:
Nature communications 13.1 (2022), p. 1308.
[22]
T. Zhang, Y. Gao, L. Chen, W. Guo, S. Pu, B. Zheng, and
C. S. Jensen. “Efficient distributed reachability query-
ing of massive temporal graphs.” In: PVLDB (2019),
pp. 871–896.
[23]
A. Paranjape, A. R. Benson, and J. Leskovec. “Motifs
in Temporal Networks.” In: WSDM. 2017, pp. 601–610.
[24]
J. F. Allen. “Maintaining knowledge about temporal
intervals.” In: Commun. ACM 26.11 (1983), pp. 832–
843.
[25]
H. Wu, J. Cheng, S. Huang, Y. Ke, Y. Lu, and Y. Xu.
“Path Problems in Temporal Graphs.” In: PVLDB (2014),
pp. 721–732.
[26]
H. Wu, J. Cheng, Y. Ke, S. Huang, Y. Huang, and H. Wu.
“Efficient Algorithms for Temporal Path Computation.”
In: TKDE 28.11 (2016), pp. 2927–2942.
[27]
B. Wheatman and H. Xu. “Packed Compressed Sparse
Row: A Dynamic Graph Representation.” In: HPEC.
2018, pp. 1–7.
[28]
J. Shun and G. E. Blelloch. “Ligra: A Lightweight Graph
Processing Framework for Shared Memory.” In: PPoPP.
2013, pp. 135–146.
[29]
M. d. Berg, O. Cheong, M. v. Kreveld, and M. Overmars.
Computational Geometry: Algorithms and Applications.
3rd ed. Springer-Verlag TELOS, 2008.
[30]
W. Fan, R. Jin, P. Lu, C. Tian, and R. Xu. “Towards Event
Prediction in Temporal Graphs.” In: PVLDB (2022),
pp. 1861–1874.

---

J. M. F. da Trindade et al.
[31]
Z. Wen and Y. Fang. “TREND: TempoRal Event and
Node Dynamics for Graph Representation Learning.”
In: WWW. 2022, pp. 1159–1169.
[32]
B. Han and B. Howe. “Adapting to Skew: Imputing Spa-
tiotemporal Urban Data with 3D Partial Convolutions
and Biased Masking.” In: (Jan. 2023). arXiv: 2301.04233
[cs.CV].
[33]
H. Zhou, D. Zheng, I. Nisa, V. Ioannidis, X. Song, and
G. Karypis. “TGL: A General Framework for Temporal
GNN Training on Billion-Scale Graphs.” In: PVLDB
(2022), pp. 1572–1580.
[34]
Temporal Ligra. url: https://github.com/jshun/ligra/
tree/temporal.
[35]
C. E. Leiserson. “The Cilk++ concurrency platform.”
In: DAC. 2009, pp. 522–527.
[36]
T. B. Schardl and I.-T. A. Lee. “OpenCilk: A Modular
and Extensible Software Infrastructure for Fast Task-
Parallel Code.” In: PPoPP. 2023, pp. 189–203.
[37]
P. Liu, A. R. Benson, and M. Charikar. “Sampling meth-
ods for counting temporal motifs.” In: WSDM. 2019.
[38]
M. J. M. Turcotte, A. D. Kent, and C. Hash. “Unified
Host and Network Data Set.” In: Data Science for Cyber-
Security. 2018, pp. 1–22.
[39]
SNAP StackOverflow dataset. url: https : / / snap .
stanford.edu/data/sx-stackoverflow.html.
[40]
R. Kujala, C. Weckström, R. K. Darst, M. N. Mladen-
ović, and J. Saramäki. “A collection of public transport
network data sets for 25 cities.” In: Nature Sci. Data 5
(2018).
[41]
J. Yang, Y. Yue, and K. V. Rashmi. “A large scale analy-
sis of hundreds of in-memory cache clusters at Twitter.”
In: OSDI. 2020, pp. 191–208.
[42]
S. Ramesh, A. Baranawal, and Y. Simmhan. “A Dis-
tributed Path Query Engine for Temporal Property
Graphs.” In: CoRR 2020 abs/2002.03274 (). Preprint,
https://arxiv.org/abs/2002.03274.
[43]
W. Han, Y. Miao, K. Li, M. Wu, F. Yang, L. Zhou, V. Prab-
hakaran, W. Chen, and E. Chen. “Chronos: A Graph En-
gine for Temporal Graph Analysis.” In: EuroSys. 2014,
1:1–1:14.
[44]
Y. Miao, W. Han, K. Li, M. Wu, F. Yang, L. Zhou, V. Prab-
hakaran, E. Chen, and W. Chen. “ImmortalGraph: A
System for Storage and Analysis of Temporal Graphs.”
In: TOS 11.3 (2015), 14:1–14:34.
[45]
R. Cheng et al. “Kineograph: taking the pulse of a
fast-changing and connected world.” In: EuroSys. 2012,
pp. 85–98.
[46]
A. Kyrola, G. E. Blelloch, and C. Guestrin. “GraphChi:
Large-scale graph computation on just a PC.” In: OSDI.
2012, pp. 31–46.
[47]
A. P. Iyer, L. E. Li, T. Das, and I. Stoica. “Time-evolving
Graph Processing at Scale.” In: GRADES. 2016, 5:1–5:6.
[48]
M. Y. Wang. “Deep Graph Library: towards efficient
and scalable deep learning on graphs.” In: ICLR (2019).
[49]
A. Longa, V. Lachi, G. Santin, M. Bianchini, B. Lepri,
P. Lio, franco scarselli, and A. Passerini. “Graph Neu-
ral Networks for Temporal Graphs: State of the Art,
Open Challenges, and Opportunities.” In: Transactions
on Machine Learning Research (2023). url: https://
openreview.net/forum?id=pHCdMat0gI.

---

