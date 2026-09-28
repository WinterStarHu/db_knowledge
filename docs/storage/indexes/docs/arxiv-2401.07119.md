# Curator: Efficient Indexing for Multi-Tenant Vector Databases

> 来源: https://arxiv.org/pdf/2401.07119

Curator: Efficient Indexing for Multi-Tenant Vector Databases
Yicheng Jin
Duke University
Yongji Wu
Duke University
Wenjun Hu
Yale University
Bruce M. Maggs
Duke University
Emerald Innovations
Xiao Zhang
Duke University
Danyang Zhuo
Duke University
ABSTRACT
Vector databases have emerged as key enablers for bridging intelli-
gent applications with unstructured data, providing generic search
and management support for embedding vectors extracted from the
raw unstructured data. As multiple data users can share the same
database infrastructure, multi-tenancy support for vector databases
is increasingly desirable. This hinges on an efficient filtered search
operation, i.e., only querying the vectors accessible to a particular
tenant. Multi-tenancy in vector databases is currently achieved
by building either a single, shared index among all tenants, or a
per-tenant index. The former optimizes for memory efficiency at
the expense of search performance, while the latter does the op-
posite. Instead, this paper presents Curator, an in-memory vector
index design tailored for multi-tenant queries that simultaneously
achieves the two conflicting goals, low memory overhead and high
performance for queries, vector insertion, and deletion. Curator
indexes each tenant’s vectors with a tenant-specific clustering tree
and encodes these trees compactly as sub-trees of a shared clus-
tering tree. Each tenant’s clustering tree adapts dynamically to
its unique vector distribution, while maintaining a low per-tenant
memory footprint. Our evaluation, based on two widely used data
sets, confirms that Curator delivers search performance on par with
per-tenant indexing, while maintaining memory consumption at
the same level as metadata filtering on a single, shared index.
1
INTRODUCTION
Vector similarity search has become a fundamental building block of
wide-ranging intelligent applications, including search engines [35,
57], recommendation systems [11, 34, 58], and retrieval-based AI
chatbots [27, 38]. This rise is driven by two factors. The first is the
recent surge in volume and diversity of unstructured data, such
as images, videos, and sensor logs, from sources like social media,
e-commerce, streaming services, and IoT devices. According to
IDC’s estimate, 80% of the world’s data will be unstructured by
2025 [24]. At the same time, advancement in deep learning has
made it possible to encode the semantics of such data into high-
dimensional embedding vectors [26, 33, 42], facilitating complex
semantic analyses and information retrieval on unstructured data.
The need to query and manage vector data has naturally led to
the development of vector databases [41, 50, 51]. Due to the inher-
ent difficulty of exact vector similarity search in high-dimensional
spaces, vector databases usually opt for approximate nearest neigh-
bor (ANN) search using specialized data structures known as vector
indexes [23, 30]. The main advantage of this approach is that it can
greatly improve search performance, with only a minor degradation
in query accuracy.
Better
Figure 1: Current multi-tenancy strategies incur inherent
inefficiency in either query latency or memory usage, while
Curator aims to optimize both simultaneously.
As vector databases become indispensable software infrastruc-
ture, multi-tenancy support is increasingly needed. For example, in
a shared enterprise knowledge base with a semantic search engine,
each document is converted into an embedding vector reflecting its
semantics, which is recomputed whenever the document is updated.
Document access within the knowledge base is contingent on the
specific roles of users — certain documents may be accessible to spe-
cific departments or levels of management, while others are more
widely available. Furthermore, the system provides flexible sharing
options, enabling users to dynamically grant access to documents to
other users as needed, which is particularly useful for collaborative
projects or cross-departmental interactions. This role-based, flexible
access control is key to maintaining both security and functionality
in the enterprise environment. This means when a user issues a
vector similarity search in the database, the search result should
only return vectors that a user has access to. Several leading vector
databases, such as Pinecone [40], Milvus [50], Weaviate [51] and
Qdrant [41], have recently announced support for multi-tenancy.
Currently, multi-tenancy support in vector databases is predom-
inantly implemented via two strategies: (1) per-tenant indexing
and (2) metadata filtering on a single, shared index. Per-tenant in-
dexing creates individual indexes for each tenant in the database.
This approach enhances search performance by enabling unfiltered
queries specific to each tenant and adjusting the index structure
to match the vector distribution particular to each tenant. How-
ever, this approach can significantly increase memory usage due
to the overhead of per-tenant indexes and duplication of vector
data among tenants when data sharing exists (detailed in 2.2). Con-
versely, metadata filtering uses a shared index with access lists
attached to each vector as metadata. While this method is more
arXiv:2401.07119v1  [cs.DB]  13 Jan 2024

---

memory-efficient and offers flexible access control, it can compro-
mise search performance due to runtime permission checks and the
mismatch between the shared index structure and tenant-specific
vector distribution. Fig. 1 illustrates this trade-off by comparing
per-tenant indexing and metadata filtering in terms of search speed
and memory usage to manage vectors generated by using the CLIP
embedding model [42] on the YFCC100M dataset. Each indexing ap-
proach generates multiple data points in Fig. 1 because we explore
different combinations of configurations (in terms of the vector
index’s parameters) using parameter sweep. §6.1 contains details
hardware description of this experiment. On average, per-tenant
indexing is 37.2× faster than metadata filtering but has to consume
10.1× more memory.
In this paper, we argue that this trade-off is not fundamental.
The inherent limitations of the two existing approaches are due
to them “patching” single-tenant indexes to support multi-tenant
vector databases. Instead, if we design from first principle an index
for multi-tenant vector databases, the index can achieve high search
performance and low memory overhead at the same time.
To achieve this, we must address the key requirements and chal-
lenges below. (1) An efficient vector index must adapt its structure
to accommodate the unique vector distribution of each tenant. (2)
The index should minimize memory overhead by eliminating redun-
dant data and minimizing the size of tenant-specific data structures.
(3) The index must facilitate fast tenant-specific queries. In con-
trast to the metadata filtering strategy, the search algorithm must
efficiently narrow the search scope to vectors accessible to the
querying tenant.
Curator addresses these challenges with the following design.
(1) It indexes each tenant’s vectors with a hierarchical k-means
clustering tree, whose structure dynamically adapts to the ten-
ant’s unique vector distribution. (2) The clustering trees for each
tenant are compactly encoded with Bloom filters as sub-trees of
a shared clustering tree, thereby minimizing per-tenant memory
footprint. (3) Curator stores the access information of vectors in the
index in a new format called shortlists, which facilitates fast search
with no additional memory overhead. Our evaluation based on the
YFCC100M and arXiv datasets shows that, Curator delivers search
performance on par with per-tenant indexing, while maintaining a
memory footprint at the same level as metadata filtering.
This paper makes the following contributions:
• We design and implement Curator, an in-memory multi-
tenant vector index that simultaneously achieves high search
performance and a low memory footprint.
• We introduce a novel index structure that captures the
unique data distributions of individual tenants with mini-
mal memory overhead.
• We evaluate Curator on real-world text and image vector
datasets. Our results confirm that Curator successfully de-
livers search performance on par with per-tenant indexing,
while maintaining memory consumption at the same level
as metadata filtering.
2
BACKGROUND
We first cover the common vector indexes used to accelerate vector
similarity search. We then discuss the multi-tenancy strategies
employed by existing vector databases and how their limitations
motivate the design of Curator.
2.1
Vector Indexes
Vector similarity search is fundamental to numerous modern ap-
plications, including search engines [35, 57], recommendation sys-
tems [11, 34, 58], and retrieval-augmented generation with large
language models [27, 38]. Vector similarity search aims to find the
nearest neighbors to a given point in a high-dimensional vector
space. The curse of dimensionality, however, makes efficient ex-
act similarity search inherently infeasible in terms of search time.
Consequently, real-world vector databases typically opt for approxi-
mate 𝑘-nearest neighbor search (𝑘-ANN search), which compromises
search quality slightly in favor of higher search speed. A vector
index is a core component in vector databases to support efficient
ANN search.
The vector indexes that support ANN and that are currently
widely adopted can be categorized into two families: graph-based
and partition-based. Graph-based vector indexes represent vectors
as vertices in a proximity graph, where each edge represents the
neighboring relationship between the vectors it connects. At query
time, the search algorithm efficiently traverses this graph towards
the neighborhood of the query vector. Among many variants in
this category, HNSW (Hierarchical Navigable Small World graph)
index [30] is one of the most popular solutions. HNSW search starts
from a fixed entry point and iteratively moves to the neighbor that
is closer to the query vector. This greedy routing process continues
until it reaches a local minima, when no neighbor is closer to the
query vector. In order to find the top-k nearest neighbors to the
query vector, the search algorithm then performs a best-first graph
search starting from the local minima, and maintains a running
queue of the top-𝑘candidates in this process. In HNSW, the length
of the search path scales logarithmically with the size of the graph
and the average degree of each node is bounded by a constant,
thus allowing fast queries with logarithmic complexity. Storing
the proximity graph, however, can significantly increase memory
usage, making it less scalable to massive datasets [14].
Partition-based vector indexes, on the other hand, divide the
vector space into sub-spaces using such techniques as clustering,
locality sensitive hashing and space partitioning trees. During a
search, these indexes first reduce the search scope to the sub-spaces
closest to the query vector, followed by scanning vectors within
these sub-spaces. The IVF (Inverted File) index [23] is a widely-
adopted member of this family, which uses clustering to partition
the vector space and represents the vectors within each cluster by
its centroid. The distance between a query vector and a cluster is
determined by the distance to its centroid, which helps the search
algorithm to focus on the most promising clusters. Although IVF
does not offer the same logarithmic search complexity as HNSW, it
still achieves reasonable search performance in practice. Moreover,
IVF is usually much more memory efficient than HNSW, because it
only needs to store the centroid of each cluster, instead of an edge
list for each vector.
2

---

2.2
Multi-Tenancy Support in Vector Databases
A multi-tenant database accommodates diverse clients within a
shared database infrastructure to reduce the total cost of owner-
ship, while ensuring minimal performance degradation and strict
data isolation. In current vector databases, there are two common
strategies for implementing multi-tenancy: (1) per-tenant indexing
and (2) metadata filtering. Per-tenant indexing creates a separate
index for each tenant within the same database instance and simply
routes search queries from each tenant to its corresponding index at
runtime. One key strength of this approach is its simplicity, because
it does not alter the index structure or search algorithm. On the
other hand, the metadata filtering strategy stores all vectors in a
shared index and associates each vector with an access list contain-
ing the IDs of the tenants with access rights to the vector. During
search, queries are transformed to incorporate binary predicates
that filter out vectors by checking if the querying tenant is included
in the access list.
In the metadata filtering strategy, there are various ways to ex-
ecute predicated queries in vector indexes, depending on when
the predicate filter is applied in the search process. In pre-filtering,
filtering happens before vector search. It can either pre-partition
the index offline according to attribute values and perform regu-
lar index scan on relevant partitions during searches [16, 50], or
it can construct a bitmap at runtime using traditional attribute
filtering techniques and filter out vectors during the scan based
on the bitmap [50, 52]. Despite the simplicity of this approach, of-
fline pre-filtering assumes predicates to be known in advance, and
constructing bitmaps at runtime requires evaluating every vector
against the predicate. Post-filtering first performs a regular index
scan to generate an intermediate candidate set that contains clos-
est neighbors to the query vector and then filters out inaccessible
vectors [50, 52]. For example, to compute top-𝑘with the filter, we
can first use traditional ANN algorithms to find the top 2𝑘vectors
(the size of the candidate set is 2𝑘), and then use the filter to find
the top-𝑘which pass the filter. Determining an appropriate size
for the candidate set can be challenging, however, as the filter se-
lectivity is typically unknown beforehand. If the size is too large,
the search will become excessively costly; conversely, if it is too
small, the result set may contain fewer items than expected by the
query. In contrast to the approaches above, single-stage filtering in-
tegrates attribute information into the scan operator and evaluates
each visited vector against the predicate [16, 54]. This approach
eliminates the need for exhaustive permission checking as seen in
pre-filtering, and can adaptively stop index scanning once a suffi-
cient number of vectors have been found. Single-stage filtering is
best known method for metadata filtering and is adopted by major
vector databases already [40, 41, 51]. Therefore, we use single-stage
filtering as our evaluation baseline for metadata filtering.
Trade-off between search speed and memory footprint. Unfor-
tunately, these multi-tenancy strategies present a difficult trade-off
for developers between search performance and memory usage.
Per-tenant indexing offers better search performance, because each
query only involves an unfiltered search within the querying ten-
ant’s index. Creating many small indexes, however, can result in
high memory usage when vectors can be shared among tenants.
The reasons for this are twofold: (1) The redundancy among the
(a) Distribution of the 
number of vectors 
accessible to each tenant
(b) Distribution of the 
number of tenants with 
access to each vector
Figure 2: Statistics of the YFCC100M dataset. (a) Most tenants
have access to only a small portion of all vectors. (b) On aver-
age, each vector is accessible to around 10 tenants, although
some vectors are shared among up to 100 tenants.
(b) Shared IVF Index
A
B
(a) Per-Tenant IVF Index
A
B
Figure 3: Shared index fails to capture the unique vector
distribution of individual tenants, compromising search effi-
ciency. Vectors of the querying tenant are highlighted in red,
while others are in gray.
metadata stored in per-tenant indexes, e.g., cluster centroids in IVF
and neighborhood graphs in HNSW. Take HNSW for example: If
each vector is shared by 5 tenants and connects to 10 neighbors in
each per-tenant index, we would need to store 50 edges per vector
in total, a 5× increase in index size compared to storing a single
index. (2) The overhead of duplicated vector data across per-tenant
indexes. Taking the same example when each vector is shared by 5
tenants, this means we need 5 total copies of vector data stored in
the index for per-tenant indexing. Both problems come from the
fact that data sharing is common. Similar sharing patterns exist
in file systems, traditional multi-tenant databases [4], as well as
the applications involving vector similarity search for unstructured
data, such as recommendation systems. Empirically, we observe
significant data sharing in our evaluation datasets: As shown in
Fig. 2b, most vectors in the YFCC100M dataset (detailed in §6.1)
are shared by at least 10 tenants. In a multi-tenant environment
where memory resources are shared, such memory overhead can
significantly limit the degree of consolidation and diminish the
benefits of economy of scale.
Metadata filtering, on the other hand, introduces low memory
overhead. By storing all vectors in a shared index, it avoids the
overhead caused by redundancy as seen in per-tenant indexes. The
only information it stores to implement multi-tenancy is the access
list associated with each vector, which can be stored compactly in
memory. The search performance of metadata filtering, however,
can be negatively affected by the following two aspects. (1) The
3

---

overhead of runtime permission checking can significantly slow
down search, especially when the filter is highly selective, i.e., each
tenant only has access to a small portion of vectors. For instance,
in the YFCC100M dataset (Fig. 2a), most tenants can access less
than 5% of all vectors. In this case, most vectors visited in the
search process are irrelevant to the querying tenant, and checking
each of them against the filter predicate can consume a significant
portion of the search time. (2) Compared to per-tenant indexing, the
structure of a shared index is not optimized for the unique vector
distribution of individual tenants. Intuitively, a vector index should
be constructed according to the underlying vector distribution, and
a mismatch between the index structure and the vector distribution
will undermine its efficiency.
To illustrate the latter point, we compare how a shared index
with metadata filtering supports 𝑘-ANN search against per-tenant
indexing in Fig. 3. For this motivation example, we transform the
arXiv dataset into vectors using the all-MiniLM-L6-v2 [18] em-
bedding model and reduce them to 2D using PCA. Readers can
easily observe the clear discrepancy between the overall vector dis-
tribution (gray points) and the querying tenant’s vector distribution
(red points): The vectors accessible to the querying tenant form
a distinct cluster, while the overall vector distribution is evenly
spread across a broader region. In contrast to the shared index
(Fig 3a) that is constructed based on the overall vector distribution,
the tenant-specific index (Fig 3b) adapts to the unique vector dis-
tribution of the querying tenant by partitioning the dense regions
with finer granularity. This allows the search to explore different
regions in the vector space with adaptive resolution. For example,
assuming both indexes scan the three closest clusters to the query
vector, the per-tenant index allows query A to explore a broader
area with coarse-grained partitioning, while the shared index may
fail to find 𝑘vectors due to limited search scope. When executing
query B in a dense region, the per-tenant index focuses search in a
smaller neighborhood with higher resolution, thereby reducing the
number of distance computations.
We attribute the inefficiency of both multi-tenancy strategies to
the fact that neither the index structure nor the search algorithm is
optimized for multi-tenant scenarios. As a result, we aim to design
a vector index with native support for multi-tenancy that achieves
the following goals simultaneously: (1) achieve similar search per-
formance as per-tenant indexing, which involves adapting index
structure to the unique vector distribution of each tenant and avoid-
ing the overhead of metadata filtering; (2) achieve similar memory
consumption as a single shared index, which requires minimizing
data redundancy and arranging the access metadata in a way that
allows fast search with minimal memory overhead.
3
CURATOR DESIGN OVERVIEW
Our high-level idea is the following: we would like to have a sin-
gle vector index that stores each tenant’s access information and
at the same time have each tenant’s view of the index be depen-
dent on the data distribution of the tenant. If we can store the
access information in a succinct matter, we can achieve small mem-
ory footprint (as does today’s metadata filtering approach). We
make the index dependent on each tenant’s data distribution which
(a) Global Clustering Tree
A
D
I
H
F
M
L
E
K
J
G
O
N
B
C
1
8
3
2
5
4
6
7
TCT Node of 
Tenant t1
TCT Node of 
Tenant t2
TCT Node of 
Both t1 and t2
* TCT: Tenant 
Clustering Tree
A
D
I
H
F
M
L
E
K
J
G
O
N
B
C
1
8
3
2
5
4
6
7
(b) Tenant Clustering Tree of t1
Internal nodes
BF: ✓
SL: ✕
Leaf nodes
BF: ✓
SL: ✓
External nodes
BF: ✕
SL: ✕
A
D
I
H
F
M
L
E
K
J
G
O
N
B
C
1
8
3
2
5
4
6
7
(c) Tenant Clustering Tree of t2
Internal nodes
BF: ✓
SL: ✕
Leaf nodes
BF: ✓
SL: ✓
External nodes
BF: ✕
SL: ✕
Figure 4: Overview of Curator. For simplicity, we represent
the high-dimensional vector space as a line and restrict the
branching factor of each tree node to 2. For a tree node 𝑛
in the Tenant Clustering Tree of tenant 𝑡, BF and SL in the
legend stand for whether the Bloom filter of 𝑛contains 𝑡and
whether 𝑛contains a shortlist for 𝑡, respectively.
makes search query efficient(as does today’s per-tenant indexing
approach [7, 9, 12, 37, 43]).
Curator is composed of a shared Global Clustering Tree (Fig. 4a)
and per-tenant Tenant Clustering Trees (Fig. 4b and 4c) that en-
code each tenant’s access control information in a compact fashion.
The Global Clustering Tree, abbreviated as GCT, is a hierarchical
k-means clustering tree that partitions vector space with multiple
levels of granularity. This partitioning is with respect to the overall
vector distribution and shared by all tenants. The Tenant Cluster-
ing Trees, abbreviated as TCTs, are sub-trees of GCT that index
the vectors accessible to each tenant and adapt their structures to
tenant-specific vector distributions.
As shown in Fig. 4a, the GCT recursively bisects the vector space,
illustrated in 1D for simplicity, into 8 non-overlapping clusters, la-
beled Clusters 1 to 8. Each leaf node in the GCT represents one of
these clusters, while each internal node represents the union of the
clusters represented by its child nodes. For example, node C repre-
sents the union of Clusters 5 through 8. Fig. 4a also shows the TCTs
of two tenants, 𝑡1 and 𝑡2, as well as the probability density functions
(PDF) of their vector distributions. The TCT of each tenant shares
the same tree structure as the GCT, but partitions the vector space
4

---

differently: They grow deeper in regions where the correspond-
ing tenant’s vectors are densely distributed, thus creating a more
fine-grained partition in these regions. For instance, as shown in
Fig. 4b, the vectors of 𝑡1 exhibit a typical bimodal distribution. The
left peak at Cluster 2-3, where vectors are densely concentrated, is
divided by the TCT to the finest level of granularity, with nodes
I and J corresponding to the two leaf clusters. For the right peak,
with lower probability density, the TCT stops partitioning at level 1,
grouping all vectors within a single cluster represented by node C.
Note that nodes H and K are excluded from the TCT, because their
corresponding clusters do not contain any vector from 𝑡1. Overall,
the leaf nodes of the TCT for tenant 𝑡gives rise to a tenant-specific
partition of the vector space (excluding the empty clusters), which
we refer to as the implied IVF index of 𝑡, denoted 𝐼𝑉𝐹(𝑡).
Now, the remaining questions are (1) how to compactly encode
the structure of the TCTs so as to reduce the per-tenant memory
footprints and (2) how to avoid the overhead of permission checking
in a mostly-shared index. Regarding the first question, since the
TCTs share the same tree structure as the GCT, we only need to
keep track of the nodes that belong to each TCT. To do so, we attach
a Bloom filter, a highly space-efficient data structure, to each GCT
node to record the set of tenants whose TCT includes that node.
For each TCT, the Bloom filters of its internal and leaf nodes should
contain the corresponding tenant, while external nodes should not.
To address the second question, we need to rethink how access
information is maintained in the index. Rather than storing an
access list for each vector, which necessitates expensive list traversal
during permission checking, we store a list of vectors accessible to
a specific tenant at each leaf node of the corresponding TCT. These
lists, which we refer to as shortlists, are pre-computed filtering
results for each cluster of 𝐼𝑉𝐹(𝑡). It is worth noting that storing
access information in shortlists does not increase memory usage,
as it essentially represents the same access matrix in a different
layout. For example, in Fig. 4a, the Bloom filter at node B contains
𝑡1 and 𝑡2 because it is shared by both TCTs. However, node B is not
associated with any shortlist because it is not a leaf node in either
TCT. On the other hand, node F’s Bloom filter contains only 𝑡2,
and node F also contains a shortlist for 𝑡2 that contains all vectors
accessible to 𝑡2 within Clusters 5 and 6.
As shown in Fig. 4b and 4c, Bloom filters and shortlists together
define the TCTs of tenant 𝑡1 and 𝑡2. For each tenant 𝑡, the GCT is
divided into three regions. A node with a shortlist for 𝑡must be a
leaf node (shown in black) in the TCT. Otherwise, we examine the
attached Bloom filter. If it contains tenant 𝑡, then the node is an
internal node of the TCT (shown in gray). If not, the node must be
outside the TCT, which we refer to as an external node (grayed out
in the figure for contrast).
As depicted in Fig. 4b and 4c, the TCTs of tenant 𝑡1 and 𝑡2 are
defined by Bloom filters and shortlists. For each tenant 𝑡, the GCT
is divided into three regions by these filters and shortlists. A node
with a shortlist for 𝑡must be a leaf node (shown in black) in the
TCT. If it’s not, we examine the attached Bloom filter. If the filter
contains tenant 𝑡, then the node is an internal node of the TCT. If
it doesn’t, the node is omitted from the TCT and is considered an
external node.
Curator addresses the limitations inherent in existing multi-
tenancy strategies as follows. Unlike the metadata filtering strategy,
Table 1: Notations used in the paper
Notation
Description
General
𝑣∈𝑉
Set of vectors
𝑡∈𝑇
Set of tenants
𝑉(𝑡)
Accessible vectors of 𝑡
𝑇(𝑣)
Access list of 𝑣
Curator-Specific
𝐺𝐶𝑇
Global clustering tree
𝑛∈𝑁
Nodes of GCT
𝐷𝑒𝑠𝑐(𝑛)
Descendants of 𝑛
𝑉(𝑛)
Subset of vectors within 𝑛
𝑉(𝑛,𝑡) = 𝑉(𝑛) ∩𝑉(𝑡)
Vectors in 𝑛accessible to 𝑡
𝑙𝑒𝑎𝑓(𝑣)
Assigned leaf node of 𝑣
𝑆𝐿(𝑛,𝑡)
Shortlist for 𝑡at 𝑛
𝑆𝐿(𝑛) = {𝑡∈𝑇| 𝑆𝐿(𝑛,𝑡) ≠∅}
Tenants with shortlists at 𝑛
𝐵𝐹(𝑛) = Ð
𝑚∈𝐷𝑒𝑠𝑐(𝑛) 𝑆𝐿(𝑚)
Bloom filter at 𝑛
𝑇𝐶𝑇(𝑡) = {𝑛∈𝑁| 𝑡∈𝐵𝐹(𝑛)}
Tenant clustering tree of 𝑡
A
B
C
D
E
F
G
H
I
J
K
L
M
N
O
P
Q
R
S
T
neighborhood of 
query vector x
Visited internal nodes
Visited leaf nodes
Unvisited nodes
Figure 5: 𝑘-ANN similarity search on Curator.
Curator avoids the overhead of permission checking by reorganiz-
ing access lists into shortlists, which allows the search algorithm to
efficiently determine the subset of accessible vectors. Moreover, the
structure of each tenant’s TCT is aligned with its unique vector dis-
tribution for higher search efficiency. Compared to the per-tenant
indexing strategy, Curator stores the TCT of each tenant in a space-
efficient way, thereby significantly reducing memory usage.
4
DETAILS OF CURATOR
We first describe how similarity search works in Curator. We then
describe how the index is constructed and how the index is main-
tained during data update (i.e., vector insertion/deletion, changes
in the tenant access permissions).
4.1
Similarity Search
Curator conducts a k-ANN search in two stages: (1) Traverse the
tenant clustering tree 𝑇𝐶𝑇(𝑡) of the querying tenant 𝑡to identify
the clusters in 𝐼𝑉𝐹(𝑡) that are closest to the query vector 𝑥. (2)
Examine these candidate clusters in order of increasing distance to
𝑥, and scan the shortlists of 𝑡within these clusters until a sufficient
number of candidate vectors have been found.
When traversing the index tree 𝐼starting from the root node, we
rely on the Bloom filters and shortlists associated with each node
to determine whether we have reached the boundary of 𝑇𝐶𝑇(𝑡). If
𝐵𝐹(𝑛) indicates that the node does not contain any vectors acces-
sible to the querying tenant (case 1), we determine that we have
stepped outside of 𝑇𝐶𝑇(𝑡) and backtrack immediately. If the node
contains a shortlist of the querying tenant (case 2), then this node
5

---

Algorithm 1: 𝑘-ANN Search Algorithm
Input
:query vector 𝑥, number of nearest neighbors to
return 𝑘, tenant 𝑡, search radius 𝛾1, 𝛾2
Output:approximate top-𝑘nearest neighbors of 𝑥
1 /* Stage 1. Identify candidate clusters with
best-first search
*/
2 𝑓𝑟𝑜𝑛𝑡𝑖𝑒𝑟←{(𝐺𝐶𝑇.𝑟𝑜𝑜𝑡, 0)}
// Search frontier
3 𝑐𝑎𝑛𝑑𝐶𝑙𝑢𝑠←∅
// Candidate clusters
4 𝑛𝑉𝑒𝑐𝑠←0
// Total size of shortlists
5 while 𝑓𝑟𝑜𝑛𝑡𝑖𝑒𝑟≠∅and 𝑛𝐶𝑎𝑛𝑑< 𝛾1 · 𝛾2 · 𝑘do
6
(𝑛𝑜𝑑𝑒,𝑑) ←nearest element to 𝑥in 𝑓𝑟𝑜𝑛𝑡𝑖𝑒𝑟
7
if 𝑡∉𝐵𝐹(𝑛𝑜𝑑𝑒) then
// Case 1
8
continue
9
else if 𝑡∈𝑆𝐿(𝑛𝑜𝑑𝑒) then
// Case 2
10
𝑐𝑎𝑛𝑑𝐶𝑙𝑢𝑠←𝑐𝑎𝑛𝑑𝐶𝑙𝑢𝑠∪(𝑛𝑜𝑑𝑒,𝑑)
11
𝑛𝑉𝑒𝑐𝑠←𝑛𝑉𝑒𝑐𝑠+ |𝑆𝐿(𝑛𝑜𝑑𝑒,𝑡)|
12
else
// Case 3
13
foreach 𝑐ℎ𝑖𝑙𝑑∈𝑛𝑜𝑑𝑒.𝑐ℎ𝑖𝑙𝑑𝑟𝑒𝑛do
14
𝑑←Distance(𝑐ℎ𝑖𝑙𝑑.𝑐𝑒𝑛𝑡𝑟𝑜𝑖𝑑,𝑥)
15
𝑓𝑟𝑜𝑛𝑡𝑖𝑒𝑟←𝑓𝑟𝑜𝑛𝑡𝑖𝑒𝑟∪(𝑐ℎ𝑖𝑙𝑑,𝑑)
16 /* Stage 2. Scanning shortlists in candidate
clusters in distance order
*/
17 𝑐𝑎𝑛𝑑𝑉𝑒𝑐𝑠←∅
// Candidate vectors
18 while 𝑐𝑎𝑛𝑑𝐶𝑙𝑢𝑠≠∅do
19
(𝑛𝑜𝑑𝑒,𝑑) ←nearest cluster to 𝑥in 𝑐𝑎𝑛𝑑𝐶𝑙𝑢𝑠
20
foreach 𝑣∈𝑆𝐿(𝑛𝑜𝑑𝑒,𝑡) do
21
𝑐𝑎𝑛𝑑𝑉𝑒𝑐𝑠←𝑐𝑎𝑛𝑑𝑉𝑒𝑐𝑠∪(𝑣, Distance(𝑣,𝑥))
22
if |𝑐𝑎𝑛𝑑𝑉𝑒𝑐𝑠| ≥𝛾1 · 𝑘then
23
break
24 return TopK(𝑐𝑎𝑛𝑑𝑉𝑒𝑐𝑠,𝑘)
should be a leaf of 𝑇𝐶𝑇(𝑡) and will be put into the queue of can-
didate clusters for scanning in the second stage. Otherwise, we
must be visiting an internal node of 𝑇𝐶𝑇(𝑡) (case 3), so we just
expand the search frontier with its children. Note that while Bloom
filters are susceptible to occasional false positives, this does not
compromise the correctness of the search, but only has a minor
effect on search efficiency. In instances where a false positive leads
the search algorithm to a subtree outside of 𝑇𝐶𝑇(𝑡), it is highly
probable that the Bloom filters of the child nodes will correctly
return False, thereby halting further unnecessary traversal.
We have already narrowed the search scope from the entire
clustering tree 𝐼to the nodes within 𝑇𝐶𝑇(𝑡) by using Bloom filters
and shortlists. However, it is still costly to traverse the 𝑇𝐶𝑇(𝑡)
exhaustively to identify all 𝐼𝑉𝐹(𝑡) clusters, especially when the
search algorithm only needs to scan a few of them to achieve high
recall. To address this issue, we leverage the tree structure of𝑇𝐶𝑇(𝑡)
to further reduce the traversal footprint with a best-first search,
prioritizing nodes with centroids closer to the query vector. In this
way, the search algorithm quickly locates the nearest cluster to
the query vector, and then progressively move away from it to
explore other neighboring clusters. The search terminates as soon
as a sufficient number of candidate vectors are discovered, often
A
B
C
D
E
Initial State
A
B
C
D
E
Case 1
A
B
C
D
E
Case 2
A
B
C
D
E
Case 3
Split
Shortlist
Figure 6: Vector Insertion.
after traversing only a fraction of the 𝑇𝐶𝑇(𝑡). Fig. 5 illustrates this,
where the colored nodes represent the querying tenant’s TCT, with
only the non-grayed nodes being traversed.
We introduce two hyper-parameters, 𝛾1 and 𝛾2, to control the
trade-off between search quality and speed.1 The imprecision in
the search process arises primarily from two factors: (1) k-means
clustering intrinsically incurs quantization error, as it represents
each vector by the centroid of its assigned cluster; (2) best-first
search is not exhaustive for candidate clusters may not return
exactly the closest clusters. To mitigate the first source of error, the
search algorithm inspects𝛾1·𝑘candidate vectors during the shortlist
scanning phase before finalizing the top-𝑘results. To address the
second, we expand the search radius during the best-first search
phase by allowing tree traversal to continue until the cumulative
number of vectors within the shortlists found has reached 𝛾1 ·𝛾2 ·𝑘.
While increasing 𝛾1 could also compensate for the second source
of error, this approach tends to be much more costly because it
involves traversing a greater number of shortlists.
4.2
Index Training
Similar to the IVF index, Curator requires an initial training phase
to construct the GCT, following the same training procedure as the
existing literature on hierarchical 𝑘-means clustering trees [25, 31].
In this process, we assume a collection of vectors is provided as
the training set, which should represent the overall distribution of
vectors. After the training phase, the structure of GCT remains fixed
as vectors are inserted to or deleted from the index. The per-tenant
TCTs are constructed incrementally as tenants are granted/revoked
accesses to vectors, as we will describe below.
Here, fixing the structure of the GCT makes Curator unable to
adapt to the drift in the overall distribution of vectors. This is not
a fundamental limitation in the design of Curator, but a design
choice for the sake of simplicity, assuming the vector distribution
will remain relatively stable or re-training will be performed in
a batched fashion periodically. These is a rich body of literature
on incremental 𝑘-means [29], and these techniques could also be
applied to Curator. For example, our evaluation baseline, faiss [23]
(one of the most popular IVF implementations), also has a fixed IVF
tree structure and requires retraining to change the tree structure.
4.3
Vector Insertion and Access Granting
In Curator, inserting a vector 𝑣involves both storing the vector
data in the index and granting access to the tenant 𝑡. The algorithm
starts from the root node and greedily traverses toward the nearest
1Note that having hyper-parameters is a standard practice in other vector indexes
as well in order to control this search quality and search speed trade-off. Similar
to other vector indexes, we use grid search on subsampled data to determine the
hyper-parameters in Curator.
6

---

leaf node in GCT, where the vector is stored. We refer to this leaf
node as the assigned leaf of 𝑣and denote it as 𝑙𝑒𝑎𝑓(𝑣). Because
the leaf nodes of GCT represents the most fine-grained partition of
the vector space, any cluster in TCTs containing 𝑣must be either
𝑙𝑒𝑎𝑓(𝑣) or its ancestor. Granting access to 𝑡requires updating the
structure of 𝑇𝐶𝑇(𝑡), which is determined by the auxiliary data
structured associated with nodes in GCT, including the Bloom
filters and shortlists for 𝑡.
Updating Shortlists During the greedy traversal toward 𝑙𝑒𝑎𝑓(𝑣),
the algorithm determines at each node if it has reached the boundary
of 𝑇𝐶𝑇(𝑡). This boundary is identified as either an external node
where the Bloom filter does not contain 𝑡, or a leaf node with a
shortlist for 𝑡. If it is the former, a new shortlist is created with 𝑣as
the only item; Otherwise, 𝑣is appended to the existing shortlist.
If a shortlist at node 𝑛reaches its maximum capacity during
an access granting operation, 𝑇𝐶𝑇(𝑡) is expanded by splitting the
shortlist among the children of 𝑛. This step conceptually represents
a subdivision of the corresponding cluster in 𝐼𝑉𝐹(𝑡) to ensure
balanced vector space partitioning. Specifically, each vector in the
original shortlist is assigned to the nearest child node, and new
shortlists for 𝑡are allocated for the child nodes responsible for any
vectors. After this step, node 𝑛turns into an internal node, and
some of its child nodes become new leaf nodes of𝑇𝐶𝑇(𝑡). There are
two edge cases we must consider: (1) If node 𝑛is a leaf node of GCT
and has no child nodes, shortlist splitting is not feasible. Hence, we
do not impose a size limit on the shortlists at GCT’s leaf nodes. (2)
All vectors within the original shortlist might be assigned to the
same child node, which means it is simply moved to the child node
and remains overfull. In this case, we recursively split it until either
it is successfully divided or a leaf node of GCT is reached.
Updating Bloom Filters Recall that the Bloom filter at node 𝑛
represents the set of tenants who have shortlists in the sub-tree
rooted at 𝑛. Since shortlists for a specific tenant only exist at the
leaf nodes of its corresponding TCT, the output of Bloom filter
equivalently determines whether node 𝑛belongs to TCT. To uphold
such property, when a new shortlist for 𝑡is created at a node,
turning it into a leaf node of 𝑇𝐶𝑇(𝑡), the Bloom filters at that node
must be updated to include 𝑡. By induction, this step ensures that
the Bloom filter at every node of 𝑇𝐶𝑇(𝑡) includes 𝑡.
Fig. 6 illustrates an example of granting access to vector 𝑣for
tenant 𝑡. Fig. 6a shows the initial state of 𝑇𝐶𝑇(𝑡) and GCT. In
case 1, the greedy traversal process reaches node 𝐵, an external
node of 𝑇𝐶𝑇(𝑡). Thus, the algorithm creates a new shortlist for 𝑡
and updates its Bloom filter. In case 2, a leaf node 𝐶with a non-
full shortlist is reached, so the algorithm simply appends 𝑣to the
shortlist. In case 3, the shortlist at 𝐶is at capacity, so the algorithm
performs shortlist splitting after appending 𝑣to it. This splitting
step distributes the vectors in the shortlist among two children 𝐷
and 𝐸, which become new leaf nodes of 𝑇𝐶𝑇(𝑡).
4.4
Vector Deletion and Access Revocation
Deleting a vector in Curator involves revoking access from all
tenants on its access list in a batched fashion, and then removing the
vector data from the index. The access revocation operation updates
the corresponding TCT, which, as discussed in §3, is defined by the
Bloom filters and shortlists associated with each node of the GCT.
Tenant Clustering Tree of t1
Tenant Clustering Tree of t2
A
B
C
D
E
G
H
I
J
F
A
B
C
D
E
G
H
I
J
F
A
B
C
D
E
G
H
I
J
F
(a)
(b)
A
B
C
D
E
G
H
I
J
F
A
B
C
D
E
G
H
I
J
F
Merge
Shortlists
(c)
(d)
(e)
Global Clustering Tree
Figure 7: Vector Deletion.
In this section, we first explain how Bloom filters and shortlists are
updated during an access revocation operation, and then describe
how a vector deletion operation carries out batch access revocation
and vector data removal. For a clearer demonstration, we will use
the example shown in Fig. 7 throughout this section. In this example,
we are deleting a vector 𝑣assigned to leaf node 𝐼of GCT. On the
left side of the figure, we illustrate the process of revoking access
from two tenants 𝑡1 and 𝑡2; On the right side (Fig. 7e), we show how
we perform batch access revocation.
Updating Bloom Filters The primary goal of the access revoca-
tion operation is to keep the corresponding tenant 𝑡’s TCT up-to-
date. This goal can be further broken down into two sub-tasks: (1)
Maintaining an correct structure of the TCT, i.e., how 𝐼𝑉𝐹(𝑡) parti-
tions the vector space; (2) Updating the content of shortlists at the
TCT’s leaves, i.e., the set of vectors within each cluster of 𝐼𝑉𝐹(𝑡).
Since every TCT shares tree structure with GCT and grows from
the same root, maintaining the structure of a TCT is equivalent
to maintaining its boundary. Recall that the boundary of a TCT is
determined by two scenarios: (1) The Bloom filter returns false for
𝑡, suggesting this node is outside of the TCT; (2) The node contains
a shortlist for tenant 𝑡, indicating this node is a leaf node of the
TCT. Ensuring correctness in these two scenarios require correctly
updating the Bloom filters and shortlists, respectively.
Updating Bloom filters is only necessary when the access revo-
cation operation deletes the last vector from a shortlist, leading to
the shortlist’s removal. In this case, the node containing the short-
list, denoted as 𝑛, turns from a leave node into an external node
of the TCT, and tenant 𝑡should be removed from the associated
Bloom filter by definition. Eliminating an element from Bloom fil-
ters generally involves re-computation from scratch, which, in our
situation, requires locating all shortlists in descendant nodes. How-
ever, the hierarchical structure of the index allows us to efficiently
re-compute the Bloom filter by merging the Bloom filters of child
nodes and adding the remaining shortlists in 𝑛. Additionally, we
also need to recursively update the Bloom filters of the ancestors of
𝑛, which can also be implemented through merging Bloom filters.
The recursive update process ends when an ancestor node’s Bloom
filter remains unchanged after re-computation.
For example, Fig. 7a and Fig. 7b illustrates an access revocation
operation that involves updating Bloom filters. The algorithm starts
by traversing from 𝐼to the root node to find a shortlist for tenant
𝑡1. It then locates the shortlist at node 𝐵and removes 𝑣from it.
7

---

Following the removal, it finds out the shortlist is empty, so it
removes the shortlist from 𝐵and re-computes the Bloom filter of 𝐵
as 𝐵𝐹(𝐸) ∪𝐵𝐹(𝐹) ∪𝑆𝐿(𝐵). It continue by re-computing the Bloom
filter of the parent node 𝐴as 𝐵𝐹(𝐵) ∪𝐵𝐹(𝐶) ∪𝐵𝐹(𝐷) ∪𝑆𝐿(𝐴). The
Bloom filter of node 𝐴will remain unchanged after re-computation
because its other sub-trees contain shortlists for 𝑡1, so the recursive
update process will end.
To further reduce the overhead of updating Bloom filters, the
Bloom filter at a node can be re-computed only once in several
consecutive updates. Each re-computation refreshes the Bloom
filter to reflect all delayed updates, effectively batching them. The
impact of batched updates on other operations is similar to the false
positives in Bloom filters as discussed in prior sections, i.e., it only
slightly affects performance while preserving correctness.
Updating Shortlists After identifying the target shortlist for
tenant 𝑡, we typically only need to remove vector 𝑣from it. How-
ever, sometimes additional work is required to maintain the index
structure. Recall that a shortlist will be divided if its size exceeds a
certain threshold after an insertion or access granting operation.
Conversely, when the total size of shortlists for tenant 𝑡within
a sub-tree falls below the threshold after a deletion or access re-
vocation operation, these shortlists should be merged back into
one. At first sight, checking this condition appears complicated:
(1) Computing the total size of shortlists in a sub-tree requires a
tree traversal to locate all the shortlists; (2) There could be several
nested sub-trees that meet the condition, and the shortlists should
be merged up to the root of the largest one.
To address the first issue, we rely on the hierarchical structure
of the index. Instead of traversing the entire sub-tree, we can de-
termine the total size of shortlists just from the direct children.
Suppose we are trying to merge the shortlists of 𝑡in a sub-tree
rooted at node 𝑛. In this case, we need to calculate the total number
of vectors accessible to 𝑡in node 𝑛, which is equivalent to the total
size of 𝑡’s shortlists in its descendants. Given that the child nodes of
𝑛represents a further partition of the cluster represented by 𝑛, we
can calculate the total number of vectors in 𝑛by adding up those in
the children nodes. A node’s type inherently indicates the number
of 𝑡’s vectors it contains: external nodes contain no vectors, leaf
nodes contain fewer than threshold vectors (otherwise it would
be split and become an internal node), and internal nodes contain
more than threshold vectors (otherwise, merging shortlists would
have turned it into a leaf node). Hence, an eligible node 𝑛should
meet two criteria: (1) None of child nodes is internal; (2) The total
size of shortlists in its direct children is below the threshold.
We address the second issue by merging shortlists recursively.
Assume node𝑛contains the updated shortlist. We begin by checking
the sub-tree rooted at the parent node of 𝑛, which we denote as 𝑝.
If it is deemed eligible, we merge the updated shortlist along with
the shortlists in 𝑛’s sibling nodes into the parent node. Following
this, we proceed to examine the parent node of 𝑝, and if it meets
the criteria, we execute the merging process again. This procedure
is repeated until the condition is no longer met.
As shown in Fig. 7c and Fig. 7d, shrinking the TCT of tenant
𝑡2 during access revocation requires shortlist merging. After 𝑣is
removed from 𝑆𝐿(𝐹,𝑡), the shortlists in node E and F are merged
into node B. Since the total size of the merged shortlist and 𝑆𝐿(𝐶,𝑡)
is larger than the threshold, the recursive merging process stops.
5
IMPLEMENTATION
We develop Curator in approximately 1000 lines of C++ on top
of the faiss library [23]. We rely on OpenMP [8] to implement
multi-threaded search and the C++ Bloom Filter Library [39] for
Bloom filter implementation.
5.1
API Design
Curator provides the same set of APIs as today’s vector indexes
besides a few changes to consider multi-tenancy. During setup, the
train_index (vector[], params) API takes a representative
set of vectors to construct the clustering tree. The construction
parameters constrain the shape of the clustering tree, such as tree
depth and branching factor.
Once the index is trained, the application can insert vectors into
the index using the insert_vector(vector, label, tenant)
function. The insertion operation associates each vector in the
index with a unique label, which acts as a reference for stored
vectors, and assigns ownership to the specified tenant. Conversely,
the delete_vector(label) removes a vector from the index based
on its label and also implicitly revokes access for all tenants in the
access list. Curator further provide get_vector(label) to retrieve
the vector data using the associated label.
For permission management, Curator provides grant_access
(label, tenant) and revoke_access(label, tenant) to grant
and revoke access of a vector to/from a tenant. These two functions
modify the access list associated with the vector, which initially
contains only the owner. The application can check whether a ten-
ant has access or ownership for a vector using has_access(label,
tenant) and has_ownership(label,tenant).
To perform k-NN queries for a tenant, the application can call
the knn_search(vector, k, tenant, params) function. Here,
params represents the hyper-parameters that controls the search
radius, including 𝛾1 and 𝛾2, as discussed in §4.1.
5.2
Parallel Vector Search on Multiple Cores
We support multi-threaded search in Curator in two modes, namely
inter-query parallelism and intra-query parallelism. In the inter-
query parallelism mode, a batch of search queries is dynamically
scheduled among a pool of worker threads in a first-come-first-
serve manner. This mode can parallelize the entire query execution
process, but cannot reduce query latency. On the other hand, the
intra-query parallelism mode focuses on reducing the latency of
a single query. In this mode, worker threads work in parallel to
scan different candidate clusters. To further increase parallelism
and improve load balance, we divide vectors in each cluster into
fixed-size chunks and distribute them among workers. A chunk
size of 16 works best in most cases. Due to the overhead of multi-
threading and implementation complexity, we do not parallelize
the first stage of the search process, where the search algorithm
traverses the clustering tree to identify candidate clusters.
8

---

Table 2: Characteristics of Evaluation Datasets
YFCC100M
arXiv
Number of Vectors
1M
2M
Vector Dimensions
192
384
Number of Tenants
1000
100
Avg Sharing Degree
13.37
9.93
6
EVALUATION
In this section, we first evaluate the overall system performance
for key database operations like search, insertion, and deletion. We
then examine how Curator scales to different query selectivities
and numbers of tenants. Finally, we analyze the contribution of
individual system components.
6.1
Experimental Setup
We use a server with an Intel Xeon Gold 5215 @2.5GHz processor
and 256GB memory, running Linux Ubuntu 20.04 LTS.
Baselines. We compare the performance of our index against two
of the most widely used vector indexes: the partition-based IVF-Flat
index [23] and the graph-based HNSW index [30].
We implemented Curator and the IVF baselines based on faiss
v1.7.4 [23], and HNSW baselines based on hnswlib v0.7.0 [56].
Both faiss and hnswlib support single-stage metadata filtering, so
we only need to provide a permission checking predicate to these
two libraries. For per-tenant baselines, we used the original IVF-Flat
and HSNW indexes and added logic that route queries to the index
of the querying tenant. For all indexes, we store vector in their
original representation without scalar or product quantization.
In the following sections, we refer to these baselines as PT-
IVF/HNSW and MF-IVF/HNSW. PT and MF are abbreviations for
per-tenant indexes and metadata filtering, respectively.
Workloads. Since existing vector search benchmarks do not have
information about tenant-specific access permissions, we generate
vectors and access metadata from some well-known datasets.
The YFCC100M dataset comprises 1M images randomly chosen
from the original YFCC100M dataset [49]. This dataset contains
a hybrid of vector and scalar data, with images embedded using
the CLIP model [42] and annotated with tags that denote entities,
locations, etc. To create a access matrix that reflects the natural
characteristics in each tenant’s vector distribution, we grant each
tenant the access to all images associated with a specific tag. For
instance, a tenant specializing in landscape photography only has
access to photos tagged as “landscape”. We consider only the 1000
tags that appear most frequently in the dataset so that both Curator
and the baseline systems’ indexes can fit into the memory of our
server.
The arXiv dataset [10] contains metadata of 2.3M arXiv papers.
This includes information such as titles, authors, abstracts, and
paper categories (e.g., cs.DB denotes the field of database systems).
We generate embedding vectors by transforming the abstract of
each paper using the all-MiniLM-L6-v2 [18] model. The access
matrix is created similarly to the YFCC100M dataset, where we
assume each tenant only access papers from a few categories. This
is typical in a realistic scenario, because most researchers typically
YFCC100M
arXiv
10
1
100
101
102
103
Avg query latency (ms)
MF-IVF
MF-HNSW
PT-IVF
PT-HNSW
Curator
Figure 8: Performance comparison of k-NN queries. MF de-
notes metadata filtering and PT denotes per-tenant indexing.
The top of the error bar represents the P99 latency.
(a) 
(b) 
Figure 9: Multi-threaded query performance on YFCC100M.
Since HNSW baselines does not support intra-query paral-
lelism, single-threaded latencies are plotted for reference.
only search papers in the fields most related to their interests. We
use only the 100 largest categories in the dataset as tenants.
6.2
System Evaluation
We first evaluate the performance of standard manipulation and
search queries of Curator compared to the previously described
baselines. Unless otherwise specified, in each experiment below, we
select index configurations that achieve the best search performance
while maintaining a recall of at least 95% through grid search.
We conduct the benchmark experiment as follows. First, we ran-
domly split each dataset into a training set and a test set of size
10000. For indexes that require an initial training process (including
Curator and the IVF-based baselines), we use all vectors in the
training set to train the index. Once the index has been initiated, we
sequentially insert vectors in the training set into the index. Each
insertion operation involves adding a new vector to the index and
granting access permissions to every tenant in its access list. To
evaluate search performance, we execute search queries for every
⟨𝑣𝑒𝑐𝑡𝑜𝑟,𝑡𝑒𝑛𝑎𝑛𝑡⟩pair in the test set. Finally, vectors are gradually
removed from the index. Each deletion operation involves revok-
ing access for all tenants in the access list and eventually erasing
the vector data. All operations are executed sequentially without
batching, with the exception of multi-threaded search.
Query Performance As shown in Fig. 8, Curator significantly
outperforms the metadata filtering baselines in query latency on
both datasets. For the YFCC100M dataset, Curator executes queries
9

---

YFCC100M
arXiv
10
1
100
101
Avg insert latency (ms)
MF-IVF
MF-HNSW
PT-IVF
PT-HNSW
Curator
Figure 10: Performance comparison of insertion operations.
Each insertion operation involves adding a new vector to the
index and granting accesses to all tenants in the access list.
The top of the error bar represents the P99 latency.
32.9× faster than MF-IVF and 7.7× faster than MF-HNSW. The per-
formance advantage generalizes to the arXiv dataset, where Curator
achieves query latencies that are 54.6× and 40.3× lower than MF-IVF
and MF-HNSW, respectively. When compared to per-tenant index
baselines, Curator shows comparable performance to the PT-IVF
index, but is a factor of 3.3 to 4.7 slower compared to the PT-HNSW
baseline. We attribute this performance gap to the inherent trade-
off between memory consumption and query speed — while the
PT-HNSW baseline prioritizes fast querying at the expense of much
higher memory usage (as shown below), Curator achieves a better
balance between resource efficiency and performance, catering to
the real-world deployment scenarios where memory overhead is a
critical consideration. P99 latency has the same overall trends as
average latency when comparing Curator to baselines.
In latency-critical scenarios, intra-query parallelism can be ap-
plied to bridge the latency gap, as shown in Fig. 9a. Since intra-query
parallelism is challenging for graph-based vector indexes and not
supported by open-sourced HNSW implementations, we only plot
single-thread search latency for HNSW baselines as a reference. For
the Curator and IVF baselines, we distribute the task of scanning IVF
clusters among multiple threads, which reduces the query latency
significantly. By using 16 threads, the performance gap between
Curator and PT-HNSW can be narrowed to just 20% (16us).
We next evaluate the query throughput via inter-query paral-
lelism. For all indexes, we input queries from each tenant in a single
batch and dynamically schedule these queries among a pool of
worker threads. Fig. 9b shows the search throughput of Curator
and IVF baselines scales better with the number of threads com-
pared to the HNSW variants, with the performance gap between
Curator and PT-HNSW quickly diminishing for > 8 threads.
Memory Consumption. Fig. 11 shows how much memory is
needed for different indexes to store the YFCC100M and arXiv
datasets. The memory usage of Curator is 7.9-8.7× lower than sep-
arate HNSW and 5.9-7.6× lower than separate IVF-Flat. This reduc-
tion is mostly due to eliminating duplicate vector data in per-tenant
indexes. In addition, separate HNSW also suffers from the overhead
of redundant edges, where each occurrence of a shared vector in
different indexes maintains its own unique set of edges to adjacent
nodes. Compared to metadata filtering baselines, Curator incurs
minimal memory overhead, by eliminating vector duplication and
introducing minimal auxiliary data structures to speed up queries.
YFCC100M
arXiv
101
Index size (GB)
MF-IVF
MF-HNSW
PT-IVF
PT-HNSW
Curator
Figure 11: Index size comparison
(a) 
(b) 
Figure 12: Performance comparison of deletion operations.
We compare the update performance against HNSW base-
lines, because in HNSW indexes, data associated with a
deleted vector remains in the index until it is overwritten by
a newly inserted vector occupying the same slot. The top of
the error bar represents the P99 latency.
Insertion/Deletion Performance. Fig. 10 compares the inser-
tion latency of Curator to the baselines. Each insertion operation
involves introducing a new vector to the index and granting ac-
cesses to tenants. For both metadata filtering and per-tenant index
strategies, HNSW achieves much lower performance than IVF due
to the overhead of incremental graph construction. Besides, per-
tenant indexes are much slower because each insertion operation
needs to update multiple indexes. The insertion speed of Curator is
even higher than the MF-IVF baseline, as the hierarchical clustering
tree allows us to minimize the number of distance computations
required to find the cluster that the new vector belongs to.
Unlike other indexes that remove vector information instantly
during a deletion operation, the HNSW index typically defers this
process. Rather than immediately erasing the vector data and its
connected edges, the index marks the vector as deleted and ex-
cludes it from future searches. When a new vector is introduced
to the index, the slot of the old vector may be reused. When this
occurs, the outdated vector data will be overwritten by the new
one, and the edges in the neighborhood of the old vector will be
updated to reflect the removal. To ensure fairness, we compare the
performance of vector deletion with IVF baselines, and the perfor-
mance of vector update with HNSW baselines. For all indexes, the
vector update operation is implemented as a deletion followed by
an insertion. As shown in Fig. 12a, all three indexes achieve high
deletion performance since distance computation is not required in
this process. Among them, the deletion latency of Curator is close
10

---

(a) 
(b) 
Figure 13: Curator demonstrates high scalability across vari-
ous dataset sizes and numbers of tenants. In our experimental
setup, a larger dataset size leads to lower query selectivity,
and more tenants correspond to a higher sharing degree.
to PT-IVF but higher than MF-IVF, as both Curator and PT-IVF
need to update all tenants in the access list. Fig. 12b shows that the
overhead of updating vectors in HNSW baselines is much higher
than Curator. This is because HNSW indexes need to repair the
graph structure in the neighborhood of the deleted vector, which
involves many distance computations. Note that P99 latency for in-
sertion and deletion is significantly higher than the average across
Curator and other baselines. This is because some updates requires
significant modifications to the index at runtime (e.g., merging and
spliting of shortlists in Curator).
6.3
Scalability
In this section, we create synthetic datasets to have better control
over their characteristics. These datasets borrow vectors from the
YFCC100M dataset, but randomly assign the vectors to tenants. We
use the same configuration for all indexes, as in §6.2.
Query Selectivity. For the sake of simplicity, we refer to the pro-
portion of vectors a certain tenant can access in all vectors as "query
selectivity". This is a slight abuse of terminology, because multi-
tenant vector search is not necessarily implemented with metadata
filtering. A well-designed multi-tenant index should maintain sta-
ble search performance for each tenant, regardless of how much
the total number of vectors increases. In other words, the search
performance experienced by one tenant should not be significantly
impacted by the data growth of another. This can be seen as a
limited form of performance isolation.
To evaluate how Curator performs at different query selectivity
levels, we keep the number of tenants and the number of vectors
each tenant can access constant, while increasing the total number
of vectors. Fig. 13a shows that both Curator and the per-tenant
indexes maintain roughly the same query latency across all query
selectivities. In contrast, indexes based on metadata filtering experi-
ence a significant drop in search performance when the selectivity
is low, due to the overhead of examining irrelevant vectors.
Number of Tenants. As a multi-tenant vector database has more
tenants, the per-tenant memory overhead limits the maximum num-
ber of tenants that can be hosted on the same machine. To assess
how the index size of Curator scales with the number of tenants, we
generate a series of synthetic datasets with an increasing number of
tenants, while keeping the total number of vectors and the number
MF-IVF +BF
+SL
+BFS
100
101
Avg query latency (ms)
YFCC100M
MF-IVF +BF
+SL
+BFS
100
101
102
arXiv
Figure 14: How each component contributes to Curator’s
search performance. The terms +BF, +SL and +BFS refer to
MF-IVF augmented with Bloom filters, Curator without the
best-first search, and Curator, respectively.
of vectors each tenant can access constant. This is equivalent to
increasing the sharing degree of each vector.
As shown in Fig. 13b, the memory usage of Curator and the
indexes based on metadata filtering increases slowly in relation to
the number of tenants, as they only maintain minimal information
for each tenant. In contrast, the per-tenant indexes quickly bloats
the total memory consumption due to the overhead of creating a
standalone vector index for each new tenant.
6.4
Ablation Study
Drilling Down into Components. We now evaluate each com-
ponent’s contribution to Curator’s search performance. Starting
with the MF-IVF baseline, we gradually extend it until it becomes
equivalent to Curator:
Flat IVF-BF (+BF). Flat IVF-BF associates each cell of the MF-IVF
index with a Bloom filter. During a search, it skips the cells that
do not contain any accessible vectors using the Bloom filters. The
remaining cells are then scanned with metadata filtering in the
same way as MF-IVF.
Flat IVF-BF w/ shortlists (+SL). In addition to Bloom filters, this
index also maintains shortlists in each cell to reduce the cost of
examining access lists during metadata filtering.
Curator (+BFS). Curator further enhances search performance
by using best-first search to approximately determine the nearest
clusters. As the search halts immediately when a sufficient number
of candidate vectors are found, it avoids the overhead of traversing
the entire clustering tree.
Fig. 14 shows the search latency of the above indexes. Both short-
lists and best-first search boost performance significantly by avoid-
ing scanning access lists and exhaustive tree traversal. However,
Bloom filters alone provide limited contribution to search perfor-
mance. This is because the number of cells that can be skipped
depends on the data distribution of the querying tenant. In the
scenarios where it is low, the cost of querying Bloom filters may
outweigh the advantages of cell skipping.
Recall-vs-Latency Trade-off. In this section, we evaluate Cura-
tor’s search latency against various baseline indexes at different
recall levels. The results, as shown in Fig. 15, reveal that Cura-
tor consistently outperforms metadata filtering baselines across
all recalls. When compared to per-tenant index baselines, Curator
11

---

0.7
0.8
0.9
1.0
Recall@10
10
1
100
101
102
Query latency (ms)
MF-IVF
MF-HNSW
PT-IVF
PT-HNSW
Curator
Figure 15: Recall-vs-latency trade-off on YFCC100M dataset.
Lower and further to the right is better.
delivers comparable results to PT-IVF and maintains a small per-
formance gap against PT-HNSW, without incurring the significant
memory overhead of per-tenant index baselines.
7
RELATED WORK
Vector indexes. As vector similarity search becomes an increas-
ingly important operation in various modern applications, many ef-
ficient vector indexes have been proposed, including graph-based in-
dexes [13, 14, 17, 20, 21, 30] and partition-based indexes, which can
be further subdivided into clustering-based [5, 6, 23, 59], hashing-
based [1, 15, 36, 43, 44, 55] and tree-based [31, 32, 47]. Different
types of vector indexes represent different trade-offs in terms of
search speed, index size and construction time, etc. Another key
difference is different index design can require significant consid-
erations when executing on multi-core machines. Partition-based
index (e.g., Curator, IVF) can be easily executed in parallel on multi-
ple cores for intra-query parallelism. This can significantly reduce
the query latency (as shown in §6.2). However, graph-based indexes
(e.g., HNSW) are much harder to be parallelized to reduce query
latency. Inter-query parallelism (i.e., running different queries on
multiple cores) is easy for both types of indexes, however, it only in-
creases query throughput but does not reduce query latency. These
traditional index design tries to adapt to data distribution to facility
efficient search. Our approach to adapt the index to data distribution
is different. These approaches build the index from scratch, while
we let each TCT fit a tenant’s distribution by choosing different
subset of the GCT. Our approach is the key to enable encoding
many TCTs on a single GCT with a low memory footprint.
While the primary goal of these indexes is to accelerate vector
similarity search by reducing the number of distance computations,
typical vector indexes also optimize for other practical objectives.
For example, vector indexes may employ compressed vector repre-
sentations [22] and disk-oriented design [21] to cater for limited
memory; some indexes are specialized for write-heavy workloads
by supporting real-time updates [45, 48]. However, these works
focus on single-tenant use cases, where Curator targets at efficient
index design for multi-tenant vector databases.
Multi-tenant databases. In recent years, the rise of the Software-
as-a-Serivce (SaaS) model has led to growing interest in multi-tenant
database systems. Research in this field focus on several key themes:
the extensibility and flexibility of multi-tenant architectures that
allows for tenant-specific modifications [2–4, 53]; the scalability
to an increasing number of tenants with bounded query perfor-
mance degradation [19]; robust security and access control mech-
anisms [28, 46]; facilitating data sharing among tenants, which is
crucial for collaboration and integration [4].
There are overall three approaches to implementing multi-tenant
databases [19]: (1) running independent database instances to serve
different tenants, (2) creating private tables for each tenant in a
shared instance, and (3) storing tuples of all tenants in a shared
table and differentiate them with a special TenantID attribute. The
first approach achieves best data isolation and security, but con-
sumes much more memory and computation resources and incurs
high maintenance cost; The second approach trades data isolation
for lower maintenance cost, but the high resource consumption
limits its scalability to a large number of tenants; The last approach
achieves highest scalability because its memory footprint is inde-
pendent of the number of tenants, but the shared index could be
inefficient for individual tenants with diverse attributes and access
patterns.
Current vector databases [40, 41, 50, 51] generally provide the
same set of multi-tenancy strategies and leave it to the users to
navigate the trade-offs. In our discussion, we categorize both of
the first two approaches into the per-tenant indexing strategy and
refer to the last one as the metadata filtering strategy. To the best
of our knowledge, no vector database has attempted to improve the
trade-off by redesigning the vector index.
8
CONCLUSION
This paper introduces Curator, an innovative in-memory vector
index design optimized for multi-tenant queries. It offers low mem-
ory usage, along with high search, insertion, and deletion efficiency.
Curator indexes each tenant’s vectors with a tenant-specific cluster-
ing tree and encodes these trees compactly as sub-trees of a shared
clustering tree. Each tenant’s clustering tree adapts dynamically
to the tenant’s unique vector distribution. Our evaluations using
two popular datasets demonstrate that Curator matches the search
efficiency of individual tenant indexing while keeping memory
usage as low as with metadata filtering approaches. Our code is
open-sourced at https://github.com/hatsu3/curator.
ACKNOWLEDGEMENT
We thank Jun Yang for helpful discussion and feedback. This re-
search was partially supported by NSF grants CNS-2238665 and
CNS-2112562, and by gifts from Adobe, Amazon, Meta, and IBM.
REFERENCES
[1] Alexandr Andoni, Piotr Indyk, Thijs Laarhoven, Ilya Razenshteyn, and Ludwig
Schmidt. 2015. Practical and optimal LSH for angular distance. Advances in
neural information processing systems 28 (2015).
[2] Stefan Aulbach, Torsten Grust, Dean Jacobs, Alfons Kemper, and Jan Rittinger.
2008. Multi-tenant databases for software as a service: schema-mapping tech-
niques. In Proceedings of the 2008 ACM SIGMOD international conference on
Management of data. 1195–1206.
[3] Stefan Aulbach, Dean Jacobs, Alfons Kemper, and Michael Seibold. 2009. A
comparison of flexible schemas for software as a service. In Proceedings of the
2009 ACM SIGMOD International Conference on Management of data. 881–888.
12

---

[4] Stefan Aulbach, Michael Seibold, Dean Jacobs, and Alfons Kemper. 2011. Exten-
sibility and data sharing in evolving multi-tenant databases. In 2011 IEEE 27th
international conference on data engineering. IEEE, 99–110.
[5] Artem Babenko and Victor Lempitsky. 2014. The inverted multi-index. IEEE
transactions on pattern analysis and machine intelligence 37, 6 (2014), 1247–1260.
[6] Dmitry Baranchuk, Artem Babenko, and Yury Malkov. 2018. Revisiting the
inverted indices for billion-scale approximate nearest neighbors. In Proceedings
of the European Conference on Computer Vision (ECCV). 202–216.
[7] Jon Louis Bentley. 1975. Multidimensional binary search trees used for associative
searching. Commun. ACM 18, 9 (1975), 509–517.
[8] Rohit Chandra, Leo Dagum, David Kohr, Ramesh Menon, Dror Maydan, and Jeff
McDonald. 2001. Parallel programming in OpenMP. Morgan kaufmann.
[9] Chih-Yi Chiu, Amorntip Prayoonwong, and Yin-Chih Liao. 2019. Learning to
index for nearest neighbor search. IEEE transactions on pattern analysis and
machine intelligence 42, 8 (2019), 1942–1956.
[10] Colin B Clement, Matthew Bierbaum, Kevin P O’Keeffe, and Alexander A Alemi.
2019. On the use of arxiv as a dataset. arXiv preprint arXiv:1905.00075 (2019).
[11] Paul Covington, Jay Adams, and Emre Sargin. 2016. Deep neural networks
for youtube recommendations. In Proceedings of the 10th ACM conference on
recommender systems. 191–198.
[12] Sanjoy Dasgupta and Kaushik Sinha. 2013. Randomized partition trees for exact
nearest neighbor search. In Conference on learning theory. PMLR, 317–337.
[13] Cong Fu and Deng Cai. 2016. Efanna: An extremely fast approximate nearest
neighbor search algorithm based on knn graph. arXiv preprint arXiv:1609.07228
(2016).
[14] Cong Fu, Chao Xiang, Changxu Wang, and Deng Cai. 2019. Fast approximate
nearest neighbor search with the navigating spreading-out graph. Proceedings of
the VLDB Endowment 12, 5 (2019), 461–474.
[15] Aristides Gionis, Piotr Indyk, Rajeev Motwani, et al. 1999. Similarity search in
high dimensions via hashing. In Vldb, Vol. 99. 518–529.
[16] Siddharth Gollapudi, Neel Karia, Varun Sivashankar, Ravishankar Krishnaswamy,
Nikit Begwani, Swapnil Raz, Yiyong Lin, Yin Zhang, Neelam Mahapatro, Premku-
mar Srinivasan, et al. 2023. Filtered-DiskANN: Graph Algorithms for Approx-
imate Nearest Neighbor Search with Filters. In Proceedings of the ACM Web
Conference 2023. 3406–3416.
[17] Ben Harwood and Tom Drummond. 2016. Fanng: Fast approximate nearest
neighbour graphs. In Proceedings of the IEEE Conference on Computer Vision and
Pattern Recognition. 5713–5722.
[18] Hugging Face. 2021. sentence-transformers/all-MiniLM-L6-v2 - Hugging Face.
https://huggingface.co/sentence-transformers/all-MiniLM-L6-v2.
Accessed:
2023-11-26.
[19] Mei Hui, Dawei Jiang, Guoliang Li, and Yuan Zhou. 2009. Supporting database
applications as a service. In 2009 IEEE 25th International Conference on Data
Engineering. IEEE, 832–843.
[20] Masajiro Iwasaki and Daisuke Miyazaki. 2018. Optimization of indexing based on
k-nearest neighbor graph for proximity search in high-dimensional data. arXiv
preprint arXiv:1810.07355 (2018).
[21] Suhas Jayaram Subramanya, Fnu Devvrit, Harsha Vardhan Simhadri, Ravishankar
Krishnawamy, and Rohan Kadekodi. 2019. Diskann: Fast accurate billion-point
nearest neighbor search on a single node. Advances in Neural Information
Processing Systems 32 (2019).
[22] Herve Jegou, Matthijs Douze, and Cordelia Schmid. 2010. Product quantization
for nearest neighbor search. IEEE transactions on pattern analysis and machine
intelligence 33, 1 (2010), 117–128.
[23] Jeff Johnson, Matthijs Douze, and Hervé Jégou. 2019. Billion-scale similarity
search with GPUs. IEEE Transactions on Big Data 7, 3 (2019), 535–547.
[24] Timothy King. 2021.
80 percent of your data will be unstructured in five
years.
https://solutionsreview.com/data-management/80-percent-of-your-
data-will-be-unstructured-in-five-years/
[25] Sid Lamrous and Mounira Taileb. 2006. Divisive hierarchical k-means. In 2006
International Conference on Computational Inteligence for Modelling Control and
Automation and International Conference on Intelligent Agents Web Technologies
and International Commerce (CIMCA’06). IEEE, 18–18.
[26] Quoc Le and Tomas Mikolov. 2014. Distributed representations of sentences and
documents. In International conference on machine learning. PMLR, 1188–1196.
[27] Patrick Lewis, Ethan Perez, Aleksandra Piktus, Fabio Petroni, Vladimir
Karpukhin, Naman Goyal, Heinrich Küttler, Mike Lewis, Wen-tau Yih, Tim Rock-
täschel, et al. 2020. Retrieval-augmented generation for knowledge-intensive nlp
tasks. Advances in Neural Information Processing Systems 33 (2020), 9459–9474.
[28] Feifei Li, Marios Hadjieleftheriou, George Kollios, and Leonid Reyzin. 2006.
Dynamic authenticated index structures for outsourced databases. In Proceedings
of the 2006 ACM SIGMOD international conference on Management of data. 121–
132.
[29] James MacQueen et al. 1967. Some methods for classification and analysis of
multivariate observations. In Proceedings of the fifth Berkeley symposium on
mathematical statistics and probability, Vol. 1. Oakland, CA, USA, 281–297.
[30] Yu A Malkov and Dmitry A Yashunin. 2018. Efficient and robust approximate
nearest neighbor search using hierarchical navigable small world graphs. IEEE
transactions on pattern analysis and machine intelligence 42, 4 (2018), 824–836.
[31] Marius Muja and David G Lowe. 2009. Fast approximate nearest neighbors with
automatic algorithm configuration. VISAPP (1) 2, 331-340 (2009), 2.
[32] Marius Muja and David G Lowe. 2014. Scalable nearest neighbor algorithms
for high dimensional data. IEEE transactions on pattern analysis and machine
intelligence 36, 11 (2014), 2227–2240.
[33] Annamalai Narayanan, Mahinthan Chandramohan, Rajasekar Venkatesan, Lihui
Chen, Yang Liu, and Shantanu Jaiswal. 2017. graph2vec: Learning distributed
representations of graphs. arXiv preprint arXiv:1707.05005 (2017).
[34] Maxim Naumov, Dheevatsa Mudigere, Hao-Jun Michael Shi, Jianyu Huang,
Narayanan Sundaraman, Jongsoo Park, Xiaodong Wang, Udit Gupta, Carole-
Jean Wu, Alisson G Azzolini, et al. 2019. Deep learning recommendation model
for personalization and recommendation systems. arXiv preprint arXiv:1906.00091
(2019).
[35] Pandu Nayak. 2019. Understanding searches better than ever before.
https:
//blog.google/products/search/search-language-understanding-bert/ Accessed:
2023-11-26.
[36] Behnam Neyshabur and Nathan Srebro. 2015. On symmetric and asymmetric
lshs for inner product search. In International Conference on Machine Learning.
PMLR, 1926–1934.
[37] Stephen M Omohundro. 1989. Five balltree construction algorithms. International
Computer Science Institute Berkeley.
[38] OpenAI. 2023. ChatGPT Retrieval Plugin. https://github.com/openai/chatgpt-
retrieval-plugin. Accessed: 2023-11-26.
[39] Arash Partow. 2019. C++ Bloom Filter Library. https://github.com/ArashPartow/
bloom. Accessed: 2023-11-26.
[40] Pinecone. 2023. Pinecone. https://www.pinecone.io/. Accessed: 2023-11-26.
[41] Qdrant. 2023. Qdrant. https://github.com/qdrant/qdrant. Accessed: 2023-11-26.
[42] Alec Radford, Jong Wook Kim, Chris Hallacy, Aditya Ramesh, Gabriel Goh, Sand-
hini Agarwal, Girish Sastry, Amanda Askell, Pamela Mishkin, Jack Clark, et al.
2021. Learning transferable visual models from natural language supervision. In
International conference on machine learning. PMLR, 8748–8763.
[43] Anshumali Shrivastava and Ping Li. 2014. Asymmetric LSH (ALSH) for sublinear
time maximum inner product search (MIPS). Advances in neural information
processing systems 27 (2014).
[44] Anshumali Shrivastava and Ping Li. 2014. Improved asymmetric locality sensitive
hashing (ALSH) for maximum inner product search (MIPS). arXiv preprint
arXiv:1410.5410 (2014).
[45] Aditi Singh, Suhas Jayaram Subramanya, Ravishankar Krishnaswamy, and Har-
sha Vardhan Simhadri. 2021. FreshDiskANN: A Fast and Accurate Graph-Based
ANN Index for Streaming Similarity Search. arXiv preprint arXiv:2105.09613
(2021).
[46] Radu Sion. 2005. Query execution assurance for outsourced databases. In Pro-
ceedings of the 31st international conference on Very large data bases. 601–612.
[47] Spotify. 2013. Annoy (Approximate Nearest Neighbors Oh Yeah). https://github.
com/spotify/annoy. Accessed: 2023-11-26.
[48] Narayanan Sundaram, Aizana Turmukhametova, Nadathur Satish, Todd Mostak,
Piotr Indyk, Samuel Madden, and Pradeep Dubey. 2013. Streaming similarity
search over one billion tweets using parallel locality-sensitive hashing. Proceed-
ings of the VLDB Endowment 6, 14 (2013), 1930–1941.
[49] Bart Thomee, David A Shamma, Gerald Friedland, Benjamin Elizalde, Karl Ni,
Douglas Poland, Damian Borth, and Li-Jia Li. 2016. YFCC100M: The new data in
multimedia research. Commun. ACM 59, 2 (2016), 64–73.
[50] Jianguo Wang, Xiaomeng Yi, Rentong Guo, Hai Jin, Peng Xu, Shengjun Li, Xi-
angyu Wang, Xiangzhou Guo, Chengming Li, Xiaohai Xu, et al. 2021. Milvus:
A purpose-built vector data management system. In Proceedings of the 2021
International Conference on Management of Data. 2614–2627.
[51] Weaviate. 2023. Weaviate. https://github.com/weaviate/weaviate. Accessed:
2023-11-26.
[52] Chuangxian Wei, Bin Wu, Sheng Wang, Renjie Lou, Chaoqun Zhan, Feifei Li,
and Yuanzhe Cai. 2020. Analyticdb-v: A hybrid analytical engine towards query
fusion for structured and unstructured data. Proceedings of the VLDB Endowment
13, 12 (2020), 3152–3165.
[53] Craig D Weissman and Steve Bobrowski. 2009. The design of the force. com
multitenant internet application development platform. In Proceedings of the
2009 ACM SIGMOD International Conference on Management of data. 889–896.
[54] Wei Wu, Junlin He, Yu Qiao, Guoheng Fu, Li Liu, and Jin Yu. 2022. HQANN:
Efficient and Robust Similarity Search for Hybrid Queries with Structured and
Unstructured Constraints. In Proceedings of the 31st ACM International Conference
on Information & Knowledge Management. 4580–4584.
[55] Hao Xu, Jingdong Wang, Zhu Li, Gang Zeng, Shipeng Li, and Nenghai Yu. 2011.
Complementary hashing for approximate nearest neighbor search. In 2011 Inter-
national Conference on Computer Vision. IEEE, 1631–1638.
[56] Malkov Yury et al. 2018. hnswlib. https://github.com/nmslib/hnswlib. Accessed:
2023-11-26.
[57] Belinda Zeng. 2022. Go beyond the search box: Introducing multisearch. https:
//blog.google/products/search/multisearch/
13

---

[58] Shuai Zhang, Lina Yao, Aixin Sun, and Yi Tay. 2019. Deep learning based recom-
mender system: A survey and new perspectives. ACM computing surveys (CSUR)
52, 1 (2019), 1–38.
[59] Ting Zhang, Chao Du, and Jingdong Wang. 2014. Composite quantization for
approximate nearest neighbor search. In International Conference on Machine
Learning. PMLR, 838–846.
14

---

