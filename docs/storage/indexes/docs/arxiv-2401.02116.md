# Starling: An I/O-Efficient Disk-Resident Graph Index Framework for High-Dimensio

> 来源: https://arxiv.org/pdf/2401.02116

Starling: An I/O-Efficient Disk-Resident Graph Index
Framework for High-Dimensional Vector Similarity Search
on Data Segment∗
MENGZHAO WANG†‡, Zhejiang University, China
WEIZHI XU‡, Zilliz, USA
XIAOMENG YI, Zhejiang Lab, China
SONGLIN WU†, Tongji University, China
ZHANGYANG PENG, Hangzhou Dianzi University, China
XIANGYU KE, Zhejiang University, China
YUNJUN GAO, Zhejiang University, China
XIAOLIANG XU, Hangzhou Dianzi University, China
RENTONG GUO, Zilliz, USA
CHARLES XIE, Zilliz, USA
High-dimensional vector similarity search (HVSS) is gaining prominence as a powerful tool for various data
science and AI applications. As vector data scales up, in-memory indexes pose a significant challenge due
to the substantial increase in main memory requirements. A potential solution involves leveraging disk-
based implementation, which stores and searches vector data on high-performance devices like NVMe SSDs.
However, implementing HVSS for data segments proves to be intricate in vector databases where a single
machine comprises multiple segments for system scalability. In this context, each segment operates with
limited memory and disk space, necessitating a delicate balance between accuracy, efficiency, and space cost.
Existing disk-based methods fall short as they do not holistically address all these requirements simultaneously.
In this paper, we present Starling, an I/O-efficient disk-resident graph index framework that optimizes data
layout and search strategy within the segment. It has two primary components: (1) a data layout incorporating
an in-memory navigation graph and a reordered disk-based graph with enhanced locality, reducing the
search path length and minimizing disk bandwidth wastage; and (2) a block search strategy designed to
minimize costly disk I/O operations during vector query execution. Through extensive experiments, we
validate the effectiveness, efficiency, and scalability of Starling. On a data segment with 2GB memory and
10GB disk capacity, Starling can accommodate up to 33 million vectors in 128 dimensions, offering HVSS
with over 0.9 average precision and top-10 recall rate, and latency under 1 millisecond. The results showcase
Starling’s superior performance, exhibiting 43.9× higher throughput with 98% lower query latency compared
to state-of-the-art methods while maintaining the same level of accuracy.
CCS Concepts: • Information systems →Record and block layout; Query optimization; Retrieval
efficiency.
Additional Key Words and Phrases: high-dimensional vector, approximate nearest neighbor search, range
search, disk-based graph index, block shuffling
∗This is the full version of the work being accepted for publication in Proc. of the ACM on Management of Data (SIGMOD
2024). https://doi.org/10.1145/3639269
†Work done while working with Zilliz.
‡Both authors contributed equally to this research.
Authors’ addresses: Mengzhao Wang, Zhejiang University, China, wmzssy@zju.edu.cn; Weizhi Xu, Zilliz, USA, Weizhi.
Xu@zilliz.com; Xiaomeng Yi, Zhejiang Lab, China, xiaomeng.yi@zhejianglab.com; Songlin Wu, Tongji University, China,
wusonglin@tongji.edu.cn; Zhangyang Peng, Hangzhou Dianzi University, China, pengzhangyang@hdu.edu.cn; Xiangyu Ke,
Zhejiang University, China, xiangyu.ke@zju.edu.cn; Yunjun Gao, Zhejiang University, China, gaoyj@zju.edu.cn; Xiaoliang
Xu, Hangzhou Dianzi University, China, xxl@hdu.edu.cn; Rentong Guo, Zilliz, USA, Rentong.Guo@zilliz.com; Charles Xie,
Zilliz, USA, charles.xie@zilliz.com.
, Vol. 1, No. 1, Article . Publication date: March 2024.
arXiv:2401.02116v3  [cs.DB]  2 Mar 2024

---

2
Mengzhao Wang, et al.
1
INTRODUCTION
The management of unstructured data, including video, image, and text, has become an urgent
requirement [66]. A notable advancement in this domain has been the widespread adoption of
learning-based embedding models, which leverage high-dimensional vector representations to
enable effective and efficient analysis and search of unstructured data [37, 61]. High-dimensional
Vector Similarity Search (HVSS) is a critical challenge in many domains, such as databases [25, 68],
information retrieval [28, 32], recommendation systems [19, 54], scientific computing [51, 78], and
large language models (LLMs) [7, 12, 44]. The computational complexity associated with exact query
answering in HVSS has spurred recent research efforts toward developing approximate search
methods [25, 49, 68]. While various compact index structures and intelligent search algorithms
have been proposed to achieve a balance between efficiency and accuracy [42, 45, 68], the majority
of these approaches assume that both the vector dataset and its corresponding index can be
accommodated in the main memory (DRAM). However, in practical scenarios, the sheer volume of
vector data often surpasses the capacity of the main memory, necessitating substantial expansion
of main memory resources [4, 16, 40] to support state-of-the-art in-memory HVSS algorithms
like NSG [25] and HNSW [49]. To illustrate, constructing an HNSW index based on one billion
floating-point vectors in 96 dimensions would require more than 350GB of memory, resulting in
out-of-memory failures [60] when executed on a typical single server [3]. Consequently, there
is a growing demand for disk-based methods that leverage solid-state disks (SSDs) as a storage
and retrieval medium for vector data, thereby circumventing the constraints imposed by main
memory [16, 35, 74]. This paradigm shift allows for handling massive-scale vector datasets on a
single machine, accommodating billions of vectors with improved efficiency and scalability.
However, maintaining a single large vector index on a solitary machine (Fig. 1(a)) proves imprac-
tical for vector databases, as it constrains many essential system features for industrial applications
[29]. For example, constructing a sole DiskANN index for a dataset at a billion-scale may demand
over five days and peak memory usage of 1,100GB [35], significantly impacting system availability.
Additionally, a large index exhibits poor migration capabilities, essential for scaling, load balancing,
and fault tolerance [29]. Consequently, vector databases consistently partition large-scale
data into multiple segments and assign an appropriate number of segments to a single
machine (Fig. 1(b)) [29, 41, 66]. Recent trends show that data fragmentation has become com-
monplace in mainstream vector databases [23, 29, 41]. Each segment operates with limited storage
capacity and computing resources [4, 29], and an independent medium-sized index is constructed
on each segment for autonomous searching. Leveraging specific data fragmentation strategies and
a query coordinator allows us to search only a few segments of a machine during vector query
execution [21, 29, 75]. This poses an open problem of efficient and accurate HVSS within a data
segment in vector databases [6, 29]. In general, we may manage tens of millions of vectors on a
typical segment with only several gigabytes of space [4, 29]. The space left for index storage is very
limited. Therefore, HVSS within the segment necessitates a meticulous equilibrium between search
performance (encompassing accuracy and efficiency) and space cost.
No existing work has achieved effective HVSS on the data segment, considering both search
performance and space cost. An immediate attempt is to use existing disk-based methods on the
segment to handle large-scale vector data. However, as reported in the literature [16, 60] and also
empirically verified in our experiments (§6.2), these techniques are in a quandary in this scenario.
For example, two state-of-the-art disk-based schemes—SPANN [16] and DiskANN [35]—lie in either
of the two following extremes. At one extreme, SPANN [16] requires huge disk space to support
efficient vector queries in the segment since each vector is copied multiple times (up to eight times
[16]). Moreover, in vector databases, a segment may have multiple replicas that are distributed on
, Vol. 1, No. 1, Article . Publication date: March 2024.

---

Starling: An I/O-Efficient Disk-Resident Graph Index Framework
3
...
(a) Strategy I 
(b) Strategy II
Distributed servers
Vector database system (e.g., Milvus)
Availability
Scaling
Load balancing
Fault tolerance
...
Too large!
Index
Distributed servers
Single machine
Index
Index
Index
Segment 0
Segment 1
Segment m–1
Single machine
Fig. 1. Two indexing strategies on a single machine for vector database system. In a distributed setting,
different machines share the same strategy [29].
different machines for fault tolerance [29]. This will further increase the disk space overhead for
SPANN. At the other extreme, the vector index of DiskANN [35] can fit the segment’s disk capacity
but DiskANN suffers from high latency due to the large number of random disk I/Os during the
search process [16, 35]. Therefore, it is particularly challenging to achieve a balance between search
performance and space cost for HVSS on data segments.
We find that current disk-based methods for HVSS still follow the paradigm of memory-based
solutions in their data layout and search strategy. This leads to numerous disk I/Os, which limit
search performance under a given space cost. We illustrate this with DiskANN [35], the state-
of-the-art disk-resident graph index algorithm1 (cf. §2.2). First, each hop along the search path
corresponds to a disk I/O request. The search procedure on the graph index executes a sequence of
disk I/O requests, which results in high search latency. Second, the disk bandwidth is underutilized
due to poor data locality. For each disk I/O in the search procedure, only one vertex’s information
(a vector and its neighbor IDs) is relevant, which typically takes a few hundred bytes. However, the
smallest disk I/O unit is a block, which is usually 4KB in size. Therefore, most of the data read from
the disk is wasted. According to our evaluation on the BIGANN dataset [3], DiskANN’s disk I/O
operation takes up to 92.5% of the time in the search procedure, and up to 94% of the vertices (they
are irrelevant) in each loaded block are wasted (i.e., the vertex utilization ratio is low). Thus, there
is much potential to achieve an I/O-efficient HVSS using graph index on the data segment.
In this paper, we introduce an I/O-efficient disk-resident graph index framework tailored for
high-dimensional vector similarity search on a data segment, called Starling. Starling optimizes
data layout and search strategy to improve the search performance without additional space cost.
The data layout consists of a sampled in-memory navigation graph and a reordered disk-based
graph, which help find query-aware dynamic entry points and improve data locality, respectively.
Based on this data layout, we design a search strategy that reduces disk I/Os by shortening the
search path and increasing the vertex utilization ratio. Specifically, Starling builds a navigation
graph in memory by sampling a small portion of vectors. This allows the search procedure to
quickly find some vertices that are close to the query vector without disk I/O, and then start
searching on the disk-based graph from these vertices. To improve data locality on disk, Starling
reorganizes the graph index layout by shuffling the vertices and storing them with their neighbors
in the same block (i.e., block shuffling). This way, one disk I/O can load information from multiple
relevant vertices in the search path. Based on this, we design a block search strategy that checks all
the data from disk I/O and adds the ones that are potentially useful to the search sequence. We
1We exclude SPANN as it duplicates each vector up to eight times, which far exceeds the capacity of the data segment when
serving tens of millions of vectors.
, Vol. 1, No. 1, Article . Publication date: March 2024.

---

4
Mengzhao Wang, et al.
further improve the strategy by three computation-specific optimizations. Finally, we also propose
efficient algorithms for approximate nearest neighbor search (ANNS) and range search (RS) queries
based on the optimized search procedure.
To the best of our knowledge, this is the first work that tackles the fundamental data locality
problem of disk-based graph index for the data segment by effective block shuffling algorithms. Our
evaluation shows that Starling achieves 43.9× higher throughput with 98% lower query latency
than state-of-the-art methods under the same accuracy. The main contributions of this work are:
• We present Starling, an I/O-efficient disk-resident graph index framework with excellent
universality that enhances the search efficiency of various graph index algorithms (e.g., Vamana
[35], NSG [25], and HNSW [49]) on a data segment (§3, §6.7).
• We design a data layout for the data segment that consists of two components: an in-memory
navigation graph (§4.2) and a reordered disk-based graph (§4.1). This data layout reduces the
search path length and increases the vertex utilization ratio of each loaded block when searching
on the disk-based graph index.
• We prove that the block shuffling problem is NP-hard and has no polynomial time approximation
algorithm with a finite approximation factor unless P=NP (§4.1). Hence, we devise three effective
heuristic shuffling algorithms that improve the locality of the disk-based graph index (§4.1).
• We propose a block search strategy that exploits the data locality of the reorganized index layout
to reduce disk I/Os (§5.1). Based on this strategy, we also provide three computation-specific
optimizations (§5.1) and develop search algorithms for two major types of queries in vector
databases (§5.2 and §5.3).
• We implement Starling and evaluate it on four real-world datasets to verify its effectiveness,
efficiency, and scalability (§6). We show that search efficiency can be improved significantly by
simply adjusting the index layout on the disk.
2
PRELIMINARIES
In this section, we formulate two critical queries in vector databases. Then we explain why current
methods are inefficient on the data segment and state our optimization goal in this paper.
2.1
Two Query Types for HVSS
K Nearest Neighbor Search (KNNS). Given a vector dataset 𝑋= {𝑥1,𝑥2, . . . ,𝑥𝑛} ⊂R𝐷, a query
vector 𝑞∈R𝐷, a distance function 𝑑𝑖𝑠𝑡(R𝐷, R𝐷) →R, and a positive integer 𝑘(0 < 𝑘< 𝑛), the
KNNS problem finds a set 𝑅𝑘𝑛𝑛of 𝑘vectors from 𝑋that are closest to 𝑞such that for any 𝑥𝑖∈𝑅𝑘𝑛𝑛
and 𝑥𝑗∈𝑋\ 𝑅𝑘𝑛𝑛,
𝑑𝑖𝑠𝑡(𝑥𝑖,𝑞) ≤𝑑𝑖𝑠𝑡(𝑥𝑗,𝑞)
.
(1)
The distance function can be Euclidean distance or others.
The KNNS problem requires scanning all the vectors in the dataset, which is impractical for large
vector datasets. Hence, most studies try to find approximate results that are close to the exact KNNS
results. This is the Approximate Nearest Neighbor Search (ANNS) problem [1, 24, 25, 49]. ANNS
uses 𝑅𝑒𝑐𝑎𝑙𝑙∈[0, 1] to measure the accuracy of approximate results. Let 𝑅′
𝑘𝑛𝑛be the approximate
results, then 𝑅𝑒𝑐𝑎𝑙𝑙is
𝑅𝑒𝑐𝑎𝑙𝑙=
|𝑅𝑘𝑛𝑛∩𝑅′
𝑘𝑛𝑛|
𝑘
.
(2)
A higher recall means a more accurate result. Many studies have designed different index structures
for vector data to improve the trade-off between search efficiency and accuracy.
, Vol. 1, No. 1, Article . Publication date: March 2024.

---

Starling: An I/O-Efficient Disk-Resident Graph Index Framework
5
Range Search (RS). Unlike the KNNS problem that returns a fixed number of results, the RS
problem retrieves all the vectors that are within a given distance 𝑟from the query vector 𝑞. Average
precision (𝐴𝑃) ∈[0, 1] is a metric to measure the accuracy of approximate RS results. Given the
exact result 𝑅𝑟𝑎𝑛𝑔𝑒and an approximate solution that ensures all the returned results 𝑅′
𝑟𝑎𝑛𝑔𝑒are
within 𝑟, then 𝐴𝑃can be computed as follows:
𝐴𝑃=
|𝑅′
𝑟𝑎𝑛𝑔𝑒|
|𝑅𝑟𝑎𝑛𝑔𝑒|
(3)
2.2
HVSS on Data Segment.
Vector databases divide large-scale data into multiple segments and distribute them across servers
[23, 29]. Each server may manage numerous segments, processing vector queries either in parallel
or serially through a query coordinator. Typically, each segment operates within strict memory
and disk space constraints [4, 29], often possessing less than 2GB of memory and under 10GB of
disk capacity. Data segment facilitates system scalability [29], yet it also poses challenges for HVSS
within a data segment. Within this context, our objective is to achieve high search accuracy and
efficiency within these space limitations. This necessitates a delicate equilibrium between search
performance and the space cost for HVSS. For instance, on the BIGANN dataset [3], each segment
might accommodate 33 million vectors, requiring 4GB of storage. Consequently, the remaining space
for index storage becomes exceedingly limited. Note that we consistently construct a substantial
index to achieve a better accuracy and efficiency trade-off. In the following, we delve into the
reasons why current HVSS advancements struggle within the context of data segments.
Mainstream in-memory algorithms such as HNSW [49], NSG [25], and HVS [46] encounter
challenges when handling tens of millions of vectors on a segment due to their approach of loading
all vectors and index into memory, exceeding memory limitations. While some vector compression
methods like LSH [33] and PQ [36] store compressed vectors in memory, the compression process
introduces significant errors that notably degrade search accuracy. For instance, the top-1 recall
rate of the leading compression method seldom surpasses 0.5 [35]. Disk-based solutions present
more promise as they require less memory and achieve high search accuracy. Traditional disk-based
methods based on trees are excluded due to their susceptibility to the “curse of dimensionality” when
addressing HVSS [45]. Instead, the focus is directed towards two state-of-the-art disk-based methods
for HVSS: SPANN [16] and DiskANN [35]. SPANN achieves high search accuracy and efficiency
but at the cost of substantial storage space. It may replicate each vector up to eight times, leading to
extensive disk overhead that far surpasses the capacity of the data segment when managing tens of
millions of vectors. On the other hand, DiskANN follows the graph index algorithm and achieves
superior search performance with less disk capacity. It has served as a baseline for HVSS on disk
[3]. However, its data layout and search strategy still align with the paradigm of memory-based
solutions, necessitating disk I/O for each vertex access. In summary, devising an efficient and
accurate solution for HVSS on a data segment remains challenging, involving the management of
tens of millions of high-dimensional vectors within limited space.
2.3
Our Optimization Objective
We draw two conclusions from our observations. First, the disk-resident graph index proves to
be the optimal choice for HVSS on the data segment, offering improved search performance with
minimal space overhead [60]. Second, the disk-based graph index can be further optimized for
I/O-efficiency in HVSS. Consequently, the HVSS problem on the data segment can be framed as
enhancing the I/O-efficiency of disk-resident graph index. Let 𝑇𝐼/𝑂, 𝑇𝑐𝑜𝑚𝑝, and 𝑇𝑜𝑡ℎ𝑒𝑟represent the
I/O time, computation time, and other times (such as data structure maintenance) when conducting
, Vol. 1, No. 1, Article . Publication date: March 2024.

---

6
Mengzhao Wang, et al.
Solution I (Baseline framework)
...
6
12
7
8
0
9
2
5
4
1
3
15
13
11
14
10
6
12
7
8
0
9
2
5
4
1
3
15
13
11
14
10
6
Segment m–1
Segment 1
Segment 0
6
12
7
8
0
9
2
5
4
1
3
15
13
11
14
10
6
12
7
8
0
9
2
5
4
1
3
15
13
11
14
10
6
8
9
4
8
9
4
Solution II (Starling)
Data layout
Search
(a) Original index layout
(c) Reordered index layout
Static entry 
point
Query point
Target 
vertex
6
12
8
2
5
3
15 6
12
8
2
5
3
15
0 7,8,14
0 7,8,14
0 7,8,14
Vector 
data
Neighbor 
IDs
...
Disk
Block ID Vertex ID
Block ID Vertex ID
0
1
2
3
0~3
4~7
8~11
12~15
Block ID Vertex ID
0
1
2
3
0~3
4~7
8~11
12~15
Block ID Vertex ID
0
1
2
3
0,7,8,12
2,5,9,14
1,4,10,13
3,6,11,15
Disk
Block shuffling
8
9
4
8
9
4
2 5,9,15
2 5,9,15
2 5,9,15
...
Target 
vertex
Dynamic entry point
Static entry 
point
6
12
0
9
3
6
12
0
9
3
6
12
0
9
3
Sampling
In-memory 
navigation graph
Entry point 
acquisition
(b) Vertex search procedure
(d) Block search procedure
Single machine
Index
Index
Index
Index
Index
Index
0
1
2
3
7,8,14
11,15
4,10
5,9,15
0
1
2
3
7,8,14
11,15
4,10
5,9,15
2
5
9
14
5,9,15
0,9
2,4,8
2,11,14
2
5
9
14
5,9,15
0,9
2,4,8
2,11,14
O
O
O
P
P
P
P
O
Fig. 2. Illustration of the data layouts and search strategies for the baseline and Starling, respectively.
searches on the disk-based graph, respectively. The total search time can be denoted as
𝑇𝑡𝑜𝑡𝑎𝑙= 𝑇𝐼/𝑂+𝑇𝑐𝑜𝑚𝑝+𝑇𝑜𝑡ℎ𝑒𝑟.
(4)
In Eq. 4, 𝑇𝐼/𝑂emerges as the dominant factor influencing the search efficiency. For instance, upon
visualizing the search time costs of DiskANN on BIGANN (Fig. 11(d)), it becomes evident that
𝑇𝐼/𝑂constitutes up to 92.5% of 𝑇𝑡𝑜𝑡𝑎𝑙, while 𝑇𝑐𝑜𝑚𝑝and 𝑇𝑜𝑡ℎ𝑒𝑟collectively occupy less than 7.5%.
This highlights the efficiency bottleneck as the cost of disk I/Os for HVSS on the disk-resident
graph index. Therefore, our objective is to improve search efficiency by minimizing 𝑇𝐼/𝑂. Note that
we must not introduce additional space overhead (including memory and disk), compared to the
original graph index, in order to adhere to the space capacity limitation of the data segment.
3
DESIGN PHILOSOPHY
We analyze two key factors that affect I/O time for existing graph index methods. Then we give an
overview of Starling, illustrating its data layout and search strategy on the data segment.
3.1
I/O-efficiency Analysis
When conducting searches on the disk-based graph, I/O-efficiency depends on two primary factors:
the vertex utilization ratio in each disk I/O and the length of the search path. The former indicates
the extent to which useful vertices are loaded in a given block, while the latter denotes the number
of hops required from the entry point to the result point. Both of these factors influence the
number of disk I/Os and thus determine the I/O time. A higher vertex utilization ratio signifies that
more relevant information is loaded in each disk I/O, leading to more effective utilization of disk
bandwidth and requiring fewer disk I/Os for each query. A longer search path implies an increased
number of disk I/Os during the search process. We delve into an analysis of the vertex utilization
ratio and the search path length within the baseline framework2 and reveal two underlying issues.
Problem 1: Poor data locality. Fig. 2(a) shows that the baseline assigns ID-consecutive vertices (a
vertex contains the vector data and neighbor IDs) to the same blocks. For example, block 0 stores
vertices 0∼3. Since a block is the smallest disk I/O unit, reading vertex 2 also reads vertices 0, 1,
and 3. This wastes disk bandwidth as the other three vertices are irrelevant to vertex 2. A naive
way to avoid the wastage is to check all the vertices in a block. However, a segment has up to
107× more vertices than a block in a real-world scenario. The probability of finding a near vertex
(w.r.t the target vertex) among the non-target vertices3 in the block is too low to improve efficiency
effectively. Therefore, the baseline only checks the target vertex and discards the rest. This means
a low vertex utilization ratio in each disk I/O. According to our evaluation on BIGANN (Tab. 2), up
2Unless specifically stated, we refer to DiskANN as the baseline framework.
3We load a block according to a target vertex. In this example, the target vertex is 2.
, Vol. 1, No. 1, Article . Publication date: March 2024.

---

Starling: An I/O-Efficient Disk-Resident Graph Index Framework
7
to 94% of data read from the disk is wasted. Obviously, ID-consecutive vertices in a block do not
imply spatial proximity (e.g., vertices of the same color are scattered on the graph topology in Fig.
2(a)). Therefore, the baseline has poor data locality.
Problem 2: Long search path. The I/O complexity of searching on a disk-based graph index is
proportional to the search path length. The baseline framework uses a fixed or random vertex as
the entry point for the search. However, a segment may have tens of millions of vertices, so the
entry point may be far from the query. In this case, only the last few vertices in the path are near
the query and likely to be in the final result. However, we need to read each vertex along the path
from the disk. Fig. 2(b) shows an extreme example where the entry point is the farthest vertex
from the query point. It takes five hops to search from 12 to 3. If we start from 9, we can reduce
the hops to two. For a dataset of tens of millions of vectors, even searching for only the top-10
nearest neighbors may generate a path of hundreds of hops to achieve high accuracy. Therefore,
the baseline has a long search path.
3.2
Framework Overview
We present Starling, a framework designed to enhance the I/O-efficiency of disk-based graph
index for HVSS on a data segment. While a single machine may encompass multiple segments, they
all share the same index layout and search strategy. Therefore, our primary focus is on one specific
segment. As depicted in Fig. 2(c), Starling preserves the graph’s topology while optimizing the
data layout to augment the vertex utilization ratio and diminish the search path length. Moreover,
it employs a block search strategy aimed at reducing disk I/Os. Below, we provide an overview of
the data layout and search strategy employed by Starling:
Data layout on disk. Starling improves data locality by shuffling the data blocks in accordance
with the graph topology (Fig. 2(c) left). This aligns the data layout with the search procedure, which
tends to visit neighboring vertices [68]. Specifically, Starling endeavors to store a vertex and its
neighbors in the same block, enabling a single disk read to fetch not only the target vertex but
also other likely candidates. This approach increases the vertex utilization ratio, as each disk I/O
operation brings multiple relevant vertices. Furthermore, the search procedure can more readily
jump to a closer vertex from the query, potentially reducing the number of required disk I/Os.
Data layout in memory. Starling identifies query-aware entry points for the disk-based graph
using an in-memory navigation graph (Fig. 2(c) right). This approach incorporates the concept
of multi-layered graphs [46, 49, 60] and involves sampling a small fraction of vectors from the
disk-based graph to construct the navigation graph. During this process, any in-memory graph
algorithm [24, 25] can be utilized. Given a query, Starling initially explores the in-memory
navigation graph to obtain query-close vertices as entry points. Subsequently, it initiates the disk-
based graph search from these identified points. This methodology effectively reduces the search
path length on the disk-based graph.
Search strategy. Starling uses a block search strategy to exploit data locality (Fig. 2(d)). Unlike
the baseline, which explores data on a vertex basis, this strategy processes data by blocks. This
way, it benefits from the optimized data layout. For each loaded block, Starling computes the
distance to the query for all vertices. Then, it selects the vertices that are close to the query and
checks their neighbors for new search candidates. This strategy lowers the disk operation cost by
exploring more relevant data per block but increases the computation cost. We further optimize
the performance with three computation-specific optimizations (§5.1).
Example 1 shows how Starling reduces disk I/Os.
Example 1. Fig. 2(b) shows a vertex search strategy that starts from vertex 12 and reaches the
result vertex 3 in five hops for a given query point. This strategy needs at least six disk I/Os to
, Vol. 1, No. 1, Article . Publication date: March 2024.

---

8
Mengzhao Wang, et al.
access the vertices in the path and their neighbors. This is inefficient, especially for large-scale
scenarios, because the probability of finding a vertex close to the query among the non-target
vertices in a loaded block is very low. Therefore, exploring data on a block basis with the original
index layout is more harmful than helpful. In contrast, Starling reduces the disk I/Os to three
with a reordered index layout, as shown in Fig. 2(d). The block search procedure works as follows:
(1) It loads block 0 and visits vertices 12, 0, 7, and 8 in the block. Then it computes their distance
to the query and selects 0 to visit its neighbors. (2) It loads block 1 with vertices {2, 5, 9, 14} and
chooses 9 as the next hop. Vertex 3 as the search result will be found when Starling loads the next
block according to vertex 11. With a navigation graph built on the vectors of {4, 8, 9} in memory, it
obtains 9 as the entry point for disk-based graph search. Since 9 is close to the query, it only takes
two disk I/Os (one to visit the entry point and one to visit its neighbors) to get the query result.
4
DATA LAYOUT
Fig. 2(c) shows how Starling organizes data on a segment. First, it builds a disk-based graph index
on the full dataset and rearranges it by block shuffling to improve data locality. We can use different
methods to construct Starling’s disk-based graph, such as NSG [25], HNSW [49], and Vamana
[35]. For more details on these methods, please refer to the original papers. We do not focus on
developing a specific graph index algorithm since existing ones are well-studied but not suitable
for disk deployment. Instead, we address the block shuffling problem on the disk-based graph
(§4.1). Second, Starling samples some data points from the full dataset and builds an in-memory
navigation graph (§4.2). This structure allows searching on the disk-based graph to begin from
some query-aware entry points, which reduces the search path length.
4.1
Block Shuffling on the Disk
Notations. Let 𝐺= (𝑉, 𝐸) represent a disk-based graph index, where 𝑉and 𝐸denote the sets of
vertices and edges, respectively. The Edges are directed and are stored as adjacency lists of vertices.
Each vertex necessitates 𝛾KB of storage to house its vector data, neighbor count 𝜆, and a list of
neighbor IDs (with a maximum length of Λ)4. The size of a disk block is 𝜂KB. Since we do not
split the data of a vertex into two blocks, each block can accommodate at most 𝜀= ⌊𝜂/𝛾⌋vertices.
Therefore, 𝜌= ⌈|𝑉|/𝜀⌉blocks are required to store the graph index.
Next, we give the definition of block-level graph layout:
Definition 1. Block-Level Graph Layout. The block-level graph layout of a graph index is a
scheme that assigns |𝑉| vertices to 𝜌blocks.
Example 2. Fig. 2(a) shows a graph index 𝐺= (𝑉, 𝐸) with 16 vertices (|𝑉| = 16), four vertices
per block (𝜀= 4), and four blocks in total (𝜌= 4). For DiskANN [5] on 33 million BIGANN dataset
(|𝑉| = 3.3 × 107) [3], each vector is 128-dimensional and one byte per value. If Λ is 31 and 𝜂is 4 KB,
then 𝛾= (128 + 4 + 31 × 4)/1, 024 KB (ID is unsigned integer type), 𝜀= 16, and 𝜌= 2, 062, 500. Thus,
DiskANN puts 16 ID-contiguous vertices in a block, such as 0 ∼15.
Fig. 2(a) and (c) show two different ways of organizing the graph index on disk block level. As
discussed in §3.1 (Problem 1), the graph layout affects disk I/Os during searching. Specifically, a
layout without data locality lowers the vertex utilization ratio and increases random disk I/Os. We
use the overlap ratio 𝑂𝑅(𝐺) of the graph index 𝐺to measure the locality of the graph layout. For
any vertex 𝑢∈𝑉, 𝑂𝑅(𝐺) is the average of 𝑂𝑅(𝑢) over 𝑉, where 𝑂𝑅(𝑢) is the proportion of vertices
4Each vertex is allocated Λ ID spaces for alignment, and padding is added when 𝜆< Λ. For simplicity, the neighbor count 𝜆
is omitted in Fig. 2 and 3.
, Vol. 1, No. 1, Article . Publication date: March 2024.

---

Starling: An I/O-Efficient Disk-Resident Graph Index Framework
9
that are 𝑢’s neighbors among all the vertices except 𝑢in the block. We can compute 𝑂𝑅(𝑢) by
𝑂𝑅(𝑢) =
(
|𝐵(𝑢)∩𝑁(𝑢)) |
|𝐵(𝑢) |−1
|𝐵(𝑢)| > 1
0
|𝐵(𝑢)| ≤1
,
(5)
where 𝐵(𝑢) is the set of vertices in the block that contains 𝑢and 𝑁(𝑢) is the set of 𝑢’s neighbors
(|𝑁(𝑢)| ≤Λ). In real-world datasets, the maximal vertex count 𝜀is about 10 in each block and
there is at most one block with a different 𝜀(i.e., |𝑉| is not divisible by 𝜀) in graph layout. We
use 𝑂𝑅(𝐵(𝑢)) = Í
𝑣∈𝐵(𝑢) (𝑂𝑅(𝑣)/|𝐵(𝑢)|) to denote the overlap ratio of the block 𝐵(𝑢). 𝑂𝑅(𝐺) is
calculated as Í
𝑢∈𝑉(𝑂𝑅(𝑢)/|𝑉|). A higher 𝑂𝑅(𝐺) means better data locality and a higher vertex
utilization ratio in a loaded block.
Example 3. A graph layout with optimal data locality has 𝑂𝑅(𝐺) = 1, meaning that every vertex
in a block is a neighbor of any other vertex in the block. However, we get 𝑂𝑅(𝐺) close to 0 for
the DiskANN [35] graph index on the 33 million BIGANN (Fig. 9(a)). This indicates the poor data
locality of the DiskANN graph layout.
To enhance data locality, we use block shuffling to adjust the graph layout, which is defined as:
Definition 2. Block Shuffling. Given a graph layout for a disk-based graph index 𝐺, the block
shuffling aims to get a new layout that maximizes the 𝑂𝑅(𝐺) while satisfying Def. 1.
In Def. 2, we aim to get a graph layout where every vertex in a block is a neighbor of other
vertices within the same block. However, the graph index built on high-dimensional vectors is
complex, as the neighborhood relationship encompasses both navigation and similarity aspects
[24, 45]. A vertex may have neighbors that belong to different clusters [49], and all vertices exhibit
a constant out-degree. Hence, it is challenging, if not impossible, to ensure that any two vertices in
a block are mutual neighbors. We prove that the block shuffling problem is NP-hard in Theorem
4.1. Furthermore, it lacks a polynomial time approximation algorithm with a finite approximation
factor. This motivates our block shuffling research, as the baseline framework merely populates a
block with ID-contiguous vertices.
Theorem 4.1. The block shuffling problem is NP-hard and does not have a polynomial time
approximation algorithm with a finite approximation factor unless P=NP.
Proof. (Sketch.) We reduce the block shuffling problem to the triple shuffling problem, which is
strongly NP-complete [10, 59]. The triple shuffling problem is defined as follows: given 𝑡= 3 · 𝜌
integers 𝛼0, 𝛼1, · · · , 𝛼𝑡−1 and a threshold Ω such that Ω/4 < 𝛼𝑖< Ω/2 and
𝑡−1
∑︁
𝑖=0
𝛼𝑖= 𝜌· Ω
,
(6)
the task is to partition the numbers into 𝜌triples and DECIDE if these triples can be shuffled by
swapping numbers between triples so that each triple sums up to Ω. We construct a graph 𝐺with
cliques of size 𝛼𝑖for each integer 𝛼𝑖. Let Ω and 𝜌be the number of vertices in a block and the
number of blocks in the graph layout of 𝐺, respectively. We demonstrate that the block shuffling
problem on 𝐺has a solution iff the triple shuffling problem can be solved. Consequently, the
block shuffling problem is NP-hard. Assuming the existence of a polynomial time approximation
algorithm with a finite approximation factor for the block shuffling problem, we could use it to
solve the triple shuffling problem. However, we establish that the triple shuffling problem cannot
be solved by such an approximation algorithm with a finite approximation factor. This contradicts
the assumption. (The detailed proof is available in Appendix A)
□
, Vol. 1, No. 1, Article . Publication date: March 2024.

---

10
Mengzhao Wang, et al.
OR(B(u))=0
OR(B(u))=1/2
OR(B(u))=1/2
OR(B(u))=2/3
Swap
(a) Algorithm I: BNP
(b) Algorithm II: BNF
(c) Algorithm III: BNS
u
OR(B(x))=0
OR(B(u))=1/2
OR(B(x))=1/6
OR(B(u))=2/3
0
1
2
3
7,8,14
11,15
4,10
5,9,15
0
1
2
3
7,8,14
11,15
4,10
5,9,15
0
7
8
14
7,8,14
0,9
0,12
0,5,12
0
7
8
14
7,8,14
0,9
0,12
0,5,12
u
0
7
8
14
7,8,14
0,9
0,12
0,5,12
0
7
8
14
7,8,14
0,9
0,12
0,5,12
0
7
8
12
7,8,14
7,8
0,12
0,5,12
0
7
8
12
7,8,14
7,8
0,12
0,5,12
6
9
12
13
15
4,15
2,11,14
7,8
6
9
12
13
15
4,15
2,11,14
7,8
0
7
8
14
7,8,14
0,9
0,12
0,5,12
0
7
8
14
7,8,14
0,9
0,12
0,5,12
6
9
14
13
15
4,15
2,11,14
0,9
6
9
14
13
15
4,15
2,11,14
0,9
0
7
8
12
7,8,14
7,8
0,12
0,5,12
0
7
8
12
7,8,14
7,8
0,12
0,5,12
x
u
Fig. 3. Block shuffling. Refer to Fig. 2 for graph topology.
We design three heuristic algorithms to handle the shuffling problem. We first describe a straight-
forward solution (Algorithm I), and then present two optimized algorithms (Algorithms II–III).
Algorithm I: Block Neighbor Padding (BNP). This algorithm fills disk blocks in a one-by-one
fashion. To fill blocks, it checks vertices in ascending order of IDs. If a vertex𝑢is not assigned to any
block yet, then the algorithm tries to assign the vertex and its neighbors to the current block. Once
a block is full the algorithm opens a new block and assigns vertices to it. BNP has a time complexity
of 𝑂(|𝑉|) and improves the overlap ratio 𝑂𝑅(𝐺) by assigning vertices and their neighbors to the
same block. However, the improvement is limited as some neighbors of 𝑢(denoted as 𝑧, 𝑣∈𝑁(𝑢))
may not be adjacent to each other, which lowers 𝑂𝑅(𝑧) or 𝑂𝑅(𝑣). Also, some neighbors of 𝑢may
have been assigned to other blocks earlier, such as 𝑧also being a neighbor of 𝑜with a smaller ID
than 𝑢. It cannot be stored with 𝑢as we store each vertex only once.
Example 4. In Fig. 3(a), we have 𝐵(𝑢) = { 0, 1, 2, 3 } and 𝑂𝑅(𝐵(𝑢)) = 0 for the original layout
(the ID of 𝑢is 0). BNP puts 0 and its neighbors 7, 8, 14 in 𝐵(𝑢), so that 𝐵(𝑢) = { 0, 7, 8, 14 } and
𝑂𝑅(𝐵(𝑢)) = 1/2. But vertex 12 cannot be in the same block with its neighbors 7 and 8, that is
𝑂𝑅(𝑣) = 0 for vertex 𝑣with ID 12.
Algorithm II: Block Neighbor Frequency (BNF). To further optimize 𝑂𝑅(𝐺), we propose BNF,
which aims to assign a vertex to the block that holds most of its neighbors, i.e., the block with the
highest neighbor frequency. The BNF takes the result of BNP as an initial layout and optimizes
𝑂𝑅(𝐺) iteratively. As illustrated in Algorithm 1: (1) It stores the current mapping of vertex IDs
to block IDs and clears all the blocks of 𝐺(lines 3–5). (2) For each 𝑢in 𝑉, BNF tries to assign it
to the blocks that hold its neighbors in the previous iteration (lines 6–14). The algorithm checks
blocks in descending order of neighbor count and assigns 𝑢to the first block that is not full yet.
If all the blocks are full, then BNF puts 𝑢in an empty block in B (lines 13–14). (3) It repeats this
process until it reaches the iteration limit 𝛽or the 𝑂𝑅(𝐺) gain between two iterations falls below a
given threshold (lines 15–16). Then a new layout of 𝐺is returned. BNF has a time complexity of
𝑂(𝛽·𝑜· |𝑉|), where 𝛽is the number of iterations, 𝑜is the average out-degree, and |𝑉| is the number
of vertices. This is because BNF needs to access the neighbors of all vertices in each iteration.
Example 5. As shown in Fig. 3(b), BNF replaces 14 with 12 in 𝐵(𝑢), since 12 has two neighbors,
7 and 8, in the block. Thus, 𝐵(𝑢) becomes { 0, 7, 8, 12 } and 𝑂𝑅(𝐵(𝑢)) = 2/3.
Algorithm III: Block Neighbor Swap (BNS). The design of BNS is inspired by the NN-Descent
method [22] in the literature of graph construction. BNS refines 𝑂𝑅(𝐺) from an initial layout,
which could be the result of BNP or BNF. In BNS, for a pair of vertices 𝑎and 𝑒that are neighbors of
vertex 𝑢and belong to different blocks 𝐵(𝑎) and 𝐵(𝑒), BNS swaps vertices with the lowest overlap
ratio (𝑂𝑅) in 𝐵(𝑎) and 𝐵(𝑒) to increase the sum of 𝑂𝑅(𝐵(𝑎)) and 𝑂𝑅(𝐵(𝑒)). Let 𝑜be the average
, Vol. 1, No. 1, Article . Publication date: March 2024.

---

Starling: An I/O-Efficient Disk-Resident Graph Index Framework
11
Algorithm 1: Block Shuffling by BNF
Input: block-level graph layout of 𝐺= (𝑉, 𝐸) from BNP, maximum iterations 𝛽, 𝑂𝑅(𝐺) gain
threshold 𝜏
Output: new block-level graph layout of 𝐺
1 B={𝐵0, · · · , 𝐵𝜌−1} ←all blocks
⊲𝜌is the number of blocks
2 while iterations ≤𝛽do
3
𝐷←mapping of vertex IDs to block IDs;
4
forall 𝐵𝑖∈B do
5
𝐵𝑖←∅;
⊲clear all blocks
6
forall 𝑢∈𝑉do
7
𝐻←Ð
𝑎∈𝑁(𝑢){𝐷(𝑎)};
⊲all neighbors’ block IDs
8
while 𝐻≠∅do
9
𝑥←block ID with the most neighbors in 𝐻;
10
if 𝐵𝑥is not full then
11
𝐵𝑥←𝐵𝑥∪{𝑢}; break;
12
𝐻= 𝐻\ {𝑥};
⊲remove the block that is full
13
if 𝐻= ∅then
14
add 𝑢to a empty block in B;
15
if 𝑂𝑅(𝐺) gain < 𝜏then
16
break;
17 return new layout of 𝐺
out-degree, then the number of swaps is 𝑜2 for each vertex in 𝑉. In each swap, the time complexity
of computing one block’s 𝑂𝑅is 𝑂(𝑜· 𝜀), where 𝜀is the number of vertices in a block. BNS operates
in an iterative manner, where each iteration checks vertex pairs among the neighbor set of all
vertices. Therefore, the time complexity of BNS is 𝑂(𝛽· 𝑜3 · 𝜀· |𝑉|), considering the number of
iterations 𝛽. We prove that 𝑂𝑅(𝐺) does not decrease with the number of iterations in Lemma 4.2.
Example 6. In Fig. 3(c), BNS identifies the blocks 𝐵(𝑢) and 𝐵(𝑥) that contain vertices 0 and 12,
respectively, from the neighbors of vertex 7. Then, it swaps vertices 12 and 14, which have the
lowest 𝑂𝑅in their blocks and can increase (𝑂𝑅(𝐵(𝑥)) + 𝑂𝑅(𝐵(𝑢))) by swapping. Finally, we get
𝑂𝑅(𝐵(𝑥)) = 1/6 and 𝑂𝑅(𝐵(𝑢)) = 2/3.
Lemma 4.2. In BNS, the 𝑂𝑅(𝐺) is a monotonically non-decreasing function of the number of
iterations 𝛽.
Proof. In each iteration, an update is local and affects only two blocks’ vertices. For any two
neighbors 𝑎and 𝑒of vertex 𝑢(𝐵(𝑎) ≠𝐵(𝑒)), we prove that swapping vertices does not lower
the sum of 𝑂𝑅(𝐵(𝑎)) and 𝑂𝑅(𝐵(𝑒)). Let 𝑂𝑅(𝐵(𝑎))𝑖, 𝑂𝑅(𝐵(𝑒))𝑖and 𝑂𝑅(𝐵(𝑎))𝑗, 𝑂𝑅(𝐵(𝑒))𝑗be the
values of 𝑂𝑅(𝐵(𝑎)), 𝑂𝑅(𝐵(𝑒)) before and after an iteration, respectively. We swap two vertices
in 𝐵(𝑎) and 𝐵(𝑒) only if 𝑂𝑅(𝐵(𝑎))𝑗+ 𝑂𝑅(𝐵(𝑒))𝑗> 𝑂𝑅(𝐵(𝑎))𝑖+ 𝑂𝑅(𝐵(𝑒))𝑖. Therefore, the sum of
𝑂𝑅(𝐵(𝑎)) and 𝑂𝑅(𝐵(𝑒)) is non-decreasing.
□
Analysis. Among our three block shuffling algorithms, BNP emerges as the fastest since it scans
all vertices just once. On the other hand, BNF’s efficiency is contingent on the number of iterations
and does not ensure the convergence of 𝑂𝑅(𝐺). However, BNF demonstrates proficiency, both in
terms of efficiency and effectiveness, particularly on numerous real-world datasets. Meanwhile,
, Vol. 1, No. 1, Article . Publication date: March 2024.

---

12
Mengzhao Wang, et al.
BNS, although possessing the highest time complexity, guarantees that 𝑂𝑅(𝐺) does not decrease
with iterations. In our implementation, we have parallelized BNF and BNS to enhance their speed.
All three algorithms notably improve 𝑂𝑅(𝐺) in contrast to the original graph layout, with BNS
exhibiting the most significant improvement, followed by BNF and then BNP. In our evaluation
(§6.5), higher 𝑂𝑅(𝐺) improves vertex utilization ratio and search performance. In practice, the
choice of algorithm can be tailored to specific requirements. Generally, we recommend BNF due to
its adept balance between efficiency and effectiveness.
Time cost. We analyze the extra time cost caused by block shuffling. A recent study of current graph
algorithms [68] shows that the graph index construction time complexity is always 𝑂(|𝑉| log(|𝑉|)).
The index construction involves high-dimensional vector distance calculation, which is very time-
consuming. However, block shuffling only scans vertices and performs simple statistics, without
any vector calculation. According to our evaluation, the block shuffling procedure introduces a
relatively low additional time cost compared to the graph index construction process. For example,
BNF only occupies 3%∼10% of the graph index construction cost (see Fig. 8(a)).
Space cost. The disk-based graph index is stored as adjacency lists of vertices. Each vertex contains
its vector data, neighbor count, and a list of neighbor IDs. Let Λ and 𝐷represent the maximum
number of neighbor IDs and the vector dimensionality, respectively. The space complexity of the
disk-based graph index is 𝑂(|𝑉| · (𝐷+ Λ)). In our experiments, we adjust Λ to conform to the disk
capacity constraint of a segment. Note that the space cost of the disk-based graph index remains
unchanged before and after block shuffling. This is because we only adjust the order of vertices
and do not add any extra information.
Remarks. (1) Our block shuffling methods can work with any block size, not just the default 4KB for
general disk. For example, we can extend to 8KB or 16KB blocks by modifying the block size. (2) Block
shuffling is similar to but not identical to graph partitioning. Graph partitioning has been extensively
studied for real-world graphs (e.g., Social Networks [55, 71]) in graph engines [48, 53, 63, 77], where
the out-degree follows a power-law distribution (neighbors tend to cluster together) [8]. However,
our graph index is based on high-dimensional vectors, where neighbors exhibit similarity and
navigation traits (with about 50% long links [68]) and the out-degree distribution is uniform
(neighbors may scatter across clusters) [68], making locality more challenging. Moreover, current
graph partitioning methods thrive on real-world graphs with clustering properties but may falter
in graph index for vectors. We evaluated some advanced graph partitioning methods for our block
shuffling task, but they only gave limited improvement. For example, BNF shows 40% higher 𝑂𝑅(𝐺)
than an advanced graph partitioning method—KGGGP [57] for graph index built on the SSNPP
dataset. Our block shuffling strategies are tailored for graph index with long navigation links
[49] and prove well-suited under our problem setting. (3) Some recent works use some graph
partitioning methods to reorder graph indexes [18, 34], but they only achieve limited improvement.
In contrast, we design the block shuffling algorithms based on block-level graph layout on the disk,
which leads to better disk-based HVSS performance.
4.2
In-Memory Navigation Graph
To reduce the search path length (ℓ), many in-memory graph-based algorithms use an additional
structure, such as multi-level Voronoi diagrams [46]. The disk I/O cost depends directly on ℓfor
searching on the disk-based graph index, so a shorter ℓis even more crucial.
Our in-memory navigation graph reduces ℓby finding better entry points for the disk-based
graph search. To obtain such a graph, we employ two steps: (1) sample data points and (2) build a
graph index. First, we randomly sample some data points from all the data in a segment, based on
the memory limit of a segment. Second, we use the same algorithm as the disk-based graph (such
, Vol. 1, No. 1, Article . Publication date: March 2024.

---

Starling: An I/O-Efficient Disk-Resident Graph Index Framework
13
as HNSW [49], NSG [25]) to build a navigation graph on the sampled data. The navigation graph is
memory-resident and can quickly return the dynamic entry points that are close to a query.
Time cost. Starling builds an in-memory graph only on a small data subset 𝑉′, lowering the
time complexity to 𝑂(|𝑉′| log(|𝑉′|)), where |𝑉′| is less than 10% of the total number of vertices in
a segment. This process is notably faster than constructing the graph on the entire dataset. In our
evaluation, the in-memory graph construction demonstrates a low time cost (e.g., only 5.5% of the
total index processing time in Fig. 8(a)).
Space cost. The in-memory graph and the disk-based graph share the same storage format. Let Λ′
and 𝐷denote the maximum number of neighbor IDs and the vector dimensionality, respectively.
The space complexity of the in-memory graph is 𝑂(|𝑉′| · (𝐷+ Λ′)). In our implementation, we
adjust |𝑉′| and Λ′ to adhere to the memory limitation of a segment.
5
SEARCH STRATEGY
The search strategy of Starling consists of two components: (1) vertex search on the in-memory
navigation graph and (2) block search on the disk-resident graph. The first component is designed to
quickly navigate to the query’s neighborhood without requiring disk access. It employs the same
vertex search strategy as existing graph algorithms. The vertex search results serve as the entry
points for the second component. To exploit the improved data locality, we utilize block search to
explore not only the target vertex but also other vertices in the same block for each disk I/O. Next,
we will outline the fundamental block search strategy and its optimizations. Following that, we
will show how we build the ANNS and RS algorithms based on the block search.
5.1
Block Search
Starling offline assigns vertices and their neighbors to the same block to improve data locality.
This way, one online block read from disk provides multiple relevant vertices. The block search
strategy efficiently explores all the useful data in a block. It updates the current search results by
calculating the distance from each vertex in the block to the query. It also checks the neighbor
IDs of the closer vertices for new search candidates. Starling further enhances this strategy with
three computation-specific optimizations.
Block pruning. We aim for a graph layout with 𝑂𝑅(𝐺) = 1, meaning every vertex accessed by
the block search is necessary. However, this ideal layout is very hard or impossible to achieve for
a graph index built on high-dimensional vectors. Usually, our block shuffling results in 𝑂𝑅(𝐺)
ranging from 0.3 to 0.6 on many real-world datasets (Fig. 9(a)). This implies that some vertices
in a block are irrelevant. To avoid exploring irrelevant data, Starling prunes each loaded block.
Specifically, it sorts the vertices in a block by their distance to the query vector in ascending order.
Then, it only checks the neighbor IDs of the top-((𝜀−1) · 𝜎) vertices for new search candidates,
where (𝜀−1) is the number of vertices excluding the target vertex in a block and 𝜎is pruning ratio
(0 < 𝜎≤1). This way, the neighbor IDs of distant vertices are discarded early. In our evaluation,
𝜎= 0.3 is always the optimal value for better performance.
I/O and computation pipeline. In the block search stage, disk read (DR) and distance computation
(DC) are two main operations. They occupy about 80% of the block search time (see Fig. 11(d)). A
naive implementation is to execute DR and DC serially—that is—load a block by DR and then select
the next hop by DC (as done in DiskANN [35]). However, this schedule is inefficient because DR
and DC are idle alternately. This wastes disk bandwidth and CPU. To avoid this, Starling uses an
I/O and computation pipeline that performs DR and DC concurrently (cf. Algorithm 2). Specifically,
Starling first executes DC for the target vertex 𝑢in the current loaded block (lines 6–7). Then, it
immediately conducts the next DR, while also performing DC of other vertices in the block that
, Vol. 1, No. 1, Article . Publication date: March 2024.

---

14
Mengzhao Wang, et al.
contains 𝑢(line 11). Although each current DR decision does not consider the non-target vertices
from the previous DR, it is acceptable as Starling fully utilizes the disk bandwidth and CPU. We
will show in §6.5, that I/O and computation pipeline reduces query latency significantly.
PQ-based approximate distance. Recall that we need to load the full-precision vectors of all
neighbors of the visited vertex to determine the next hop. Block shuffling mitigates such disk access
by filling a block with many neighboring vertices. However, the number of neighbor IDs of each
vertex is usually several times the number of vertices in a block, so many neighbors still require
extra disk I/Os. To address this issue, we use approximate distance instead of exact distance with
full-precision vectors. This is based on the observation that the next hop decision can be made by
approximate computation with little accuracy damage [15]. Specifically, Starling preprocesses
the full dataset by PQ [36] (like DiskANN [35]), a popular compression method. It encodes the
full-precision vectors into short codes that reside in the main memory. Indeed, Starling efficiently
obtains the approximate distances between the neighbors (whose full-precision vectors are not in
memory) and the query by the short codes without disk I/Os to make the next disk read decision.
Time cost analysis. Let 𝜉be the vertex utilization ratio and 𝜀be the number of vertices in a disk
block. Then 𝜉·𝜀(≥1) represents the number of vertices accessed in each disk I/O. The vertex access
complexity of the graph index is 𝑂(𝑜· ℓ) [68], where ℓis the search path length and 𝑜is the average
out-degree of visited vertices. Therefore, the I/O time complexity of searching on the disk-based
graph is 𝑂((𝑜· ℓ)/(𝜉· 𝜀)). In addition, the computation-specific block search optimizations further
enhance search efficiency.
5.2
Approximate Nearest Neighbor Search
The ANNS strategy in Starling uses two ordered lists to store the candidates and search results:
the candidate set and the result set. It starts the search by adding the entry points of the disk-based
graph to the candidate set. These entry points are obtained on the in-memory navigation graph.
Then it selects the unvisited vertex that is closest to the query from the candidate set and performs
a block search. It updates both sets with the block search outcome. The procedure ends when all
the vertices in the candidate set are visited. To improve efficiency, the strategy limits the size of the
candidate set to prevent too many candidate vertices. The result set has no size limit because it is
sorted only when the search terminates.
Starling performs ANNS for a query 𝑞as follows (cf. Algorithm 2). (1) It finds the entry points
𝑆of 𝑞on the in-memory navigation graph 𝐺𝑚(line 1). (2) It initializes a fixed-size candidate set 𝐶
and a result set 𝑅with 𝑆(lines 2–3). It sorts 𝐶by approximate distance using PQ short codes. (3)
It picks the top-1 unvisited vertex 𝑢in 𝐶as the target vertex and reads the block 𝐵containing 𝑢
from the disk (lines 4–5). (4) It adds 𝑢’s neighbor IDs to 𝐶and 𝑢to 𝑅(lines 6–7). (5) It prunes some
vertices that are far from 𝑞from 𝐵, adding the closer vertices into 𝐵′ (line 8). (6) It executes (3) for
the next top-1 unvisited vertex 𝑣and (4) for the vertices in 𝐵′ in parallel, then it executes (4)–(5)
for 𝑣(lines 10–12). (7) It terminates when 𝐶has no unvisited vertices. Finally, it sorts 𝑅by exact
distance using full-precision vectors and returns top-𝑘results in 𝑅.
5.3
Range Search
A range search (RS) query returns all the vectors within a search radius 𝑟. The result length depends
on the vector distribution and can vary a lot among queries. For a dataset with tens of millions
of vectors, the same 𝑟may give zero to thousands of results. So, the RS algorithm should handle
different result lengths. A simple RS strategy is to do ANNS repeatedly with different 𝑘values to
check the result length. However, this is inefficient because it will revisit the same vertices multiple
times, causing extra computation and disk I/Os.
, Vol. 1, No. 1, Article . Publication date: March 2024.

---

Starling: An I/O-Efficient Disk-Resident Graph Index Framework
15
Algorithm 2: ANNS
Input: in-memory navigation graph 𝐺𝑚, PQ short codes, disk-based graph 𝐺𝑑, query 𝑞,
candidate set 𝐶with fixed size, result set 𝑅, pruning ratio 𝜎
Output: top-𝑘results of 𝑞
1 𝑆←entry points of 𝑞by a vertex search strategy on 𝐺𝑚;
2 𝐶←𝑆;
⊲sort by PQ distance to 𝑞
3 𝑅←𝑆;
⊲compute exact distance to 𝑞
4 𝑢←top-1 unvisited vertex in 𝐶;
⊲target vertex
5 𝐵←load the block including 𝑢from 𝐺𝑑;
⊲DR
6 update 𝐶according to 𝑢’s neighbor IDs;
⊲DC
7 add 𝑢to 𝑅based on 𝑢’s full-precision vector;
⊲DC
8 𝐵′ ←top-((𝜀−1) · 𝜎) vertices in 𝐵\ {𝑢};
⊲block pruning
9 while 𝐶has unvisited vertex do
10
𝑣←top-1 unvisited vertex in 𝐶;
⊲PQ-based routing
11
conduct line 5 for 𝑣, and lines 6–7 for the vertices in 𝐵′ in parallel;
12
⊲I/O and computation pipeline
13
conduct lines 6–8 for 𝑣and the block including it;
14 return top-𝑘vertices in 𝑅
⊲sort by exact distance to 𝑞
Starling performs RS for a query 𝑞based on block search. It uses a candidate set 𝐶, a result set
𝑅, and a kicked set 𝑃to store candidate vertices, results, and vertices kicked out from 𝐶, respectively.
Starling changes the length limit of 𝐶dynamically to handle different result lengths. The steps
of RS are as follows. (1) It obtains the entry points from the in-memory navigation graph and
initializes 𝐶and 𝑅with them. (2) It iteratively explores 𝐶and updates 𝐶and 𝑅(like ANNS). It also
adds the unvisited vertices kicked out from 𝐶to 𝑃. (3) When all the vertices in 𝐶are visited, it
calculates the ratio of 𝑅’s length to 𝐶’s length. Given a ratio threshold 𝜑, if
|𝑅|
|𝐶| ≥𝜑
,
(7)
it doubles the size of 𝐶and restarts the search. This is because a high ratio means that most
candidates are results. In this case, exploring more vertices may find new results. (4) In the next
search, Starling adds the closer vertices (w.r.t 𝑞) in 𝑃to 𝐶and repeats (2)–(3) for unvisited
candidates in 𝐶. (5) The search stops when Eq. 7 is not met. After changing the length of 𝐶, it
resumes the search with the previous results in 𝑅, candidates in 𝐶, and some closer vertices (w.r.t 𝑞)
in 𝑃. This avoids extra computation and disk access. Our evaluation shows that 𝜑= 0.5 is optimal.
6
EXPERIMENTS
We evaluate the following aspects of Starling: (1) search performance (§6.2), (2) I/O-efficiency
(§6.3), (3) index cost (§6.4), (4) ablation study (§6.5), (5) parameter sensitivity (§6.6), (6) scalability
(§6.7), (7) query distribution (§6.8), (8) segment setup (§6.9), (9) large-scale search results (§6.10),
and (10) billion-scale data (§6.11). Our source code and datasets are available at: https://github.
com/zilliztech/starling. Kindly refer to Appendix for additional evaluations.
6.1
Experimental Setting
Datasets. We use four public real-world datasets [3] that vary in data type, dimensions, distance,
and query type. Tab. 1 shows their details. Unless specified, we limit the raw vectors per segment
, Vol. 1, No. 1, Article . Publication date: March 2024.

---

16
Mengzhao Wang, et al.
Table 1. Statistics of experimental datasets on a segment.
Dataset
Data type Dimensions Distance function # Base vector per segment # Query Query type
BIGANN
uint8
128
L2
33M
104
ANNS/RS
DEEP
float
96
L2
11M
104
ANNS/RS
SSNPP
uint8
256
L2
16M
105
RS
Text2image float
200
IP
5M
105
ANNS
to under 4GB and adjust the data scale accordingly for each dataset. We randomly select vectors
from standard datasets for a segment. We perform a brute-force search on the selected vectors to
get the ground truth. The query sets are the same for a given dataset.
Query workloads. The query workloads’ details are provided in Tab. 1. By default, all query sets
are derived from real-world scenarios and are not-in-database, meaning they do not have any
intersection with the base data. The queries are executed in a random order, and a batch of queries
is served using a pool of threads. Each thread is assigned to handle one query at a time.
Compared methods. We compare Starling with two state-of-the-art disk-based HVSS methods
that are able to process up to 4GB vector data within the 2GB memory constraint. We do not include
in-memory methods (e.g., HNSW [49] and IVFPQ [36]) in the evaluation, because they either run
out of memory or have very low accuracy, as reported in previous works [16, 35, 60].
• DiskANN [35] is the state-of-the-art disk-based graph index method, which we use as the
baseline framework.
• SPANN [16] is a disk-based inverted index method that achieves better performance than
DiskANN but requires more disk space.
• Starling is our framework, which implements all the optimizations proposed in this paper.
Unless otherwise specified, we use the Vamana algorithms as the default option in Starling,
denoted as Starling-Vamana or simply Starling.
Evaluation protocol. We use queries per second (QPS), mean latency, and mean I/Os to evaluate
the search performance of all competitors. By default, we use eight threads on the server to serve
queries and report the QPS based on the wall clock time from the query input to the result output.
For the latency and I/Os, we record the response time and number of disk I/Os for each query and
compute the mean latency and mean I/Os over all queries. For ANNS, we measure its accuracy by
𝑅𝑒𝑐𝑎𝑙𝑙(Eq. 2). Unless otherwise stated, we set 𝑘= 10 in Recall. For RS, 𝐴𝑃(Eq. 3) is a more suitable
accuracy metric. We fix a search radius 𝑟for each dataset following [64]. We evaluate two popular
similarity metrics, 𝐿2 and inner product (𝐼𝑃).
Segment configuration. We follow the configuration of a mainstream open-source vector database,
Milvus [6, 29], with at most 2GB memory space and 10GB disk capacity for each segment by default.
Setup. We execute the C++ codes of all methods using different instances for both index building
and search to align with the protocols of current vector databases [29] and related research [25, 68].
For index building, we employ a n2-standard-64 instance (ubuntu-2004-focal-v20221121, 2 TB SSD
Persistent Disk) with 64 vCPUs—this facilitates fast construction and segment sharing. In terms of
search functionality, vector databases typically leverage multiple smaller instances to improve query
performance and promote fine-grained load balancing and scaling. In our experiments, all segments
share a n2-standard-8 instance (ubuntu-2004-focal-v20221121, 375 GB NVMe Local SSD Scratch
Disk) with 8 vCPUs. We use the o_direct option to read data from the disk for all competitors,
circumventing operating system caching. We optimize all approaches’ hyper-parameters for the
segment’s configuration. We report the average results of three trials on the optimum configuration.
6.2
Search Performance
RS performance. Current disk-based HVSS methods largely ignore RS, except for a baseline in a
competition [3]. RS support is provided by calling ANNS iteratively on DiskANN (referred to as
, Vol. 1, No. 1, Article . Publication date: March 2024.

---

Starling: An I/O-Efficient Disk-Resident Graph Index Framework
17
0
20
40
Latency (ms)
0.85
0.90
0.95
AP
DiskANN
Starling
(a) BIGANN
0
20
40
Latency (ms)
0.92
0.94
0.96
0.98
AP
(b) DEEP
2
4
6
8
Latency (ms)
0.80
0.85
0.90
AP
(a) SSNPP
Fig. 4. RS performance (AP vs Latency).
0.80
0.85
0.90
0.95
1.00
AP
0
5000
10000
QPS
(a) BIGANN
0.90 0.92 0.94 0.96 0.98 1.00
AP
0
5000
10000
QPS
DiskANN
Starling
(b) DEEP
Fig. 5. RS performance (QPS vs AP).
DiskANN) [5]. Fig. 4 and 5 compare the RS performance of DiskANN and Starling. Under the same
AP, Starling reduces query latency by up to 98% compared to DiskANN. On SSNPP, Starling
exhibits a slight performance boost. We observed that most query results are near the centroid
for that dataset. DiskANN’s cache policy loads the data near the centroid, covering most query
results. However, Starling still achieves better RS performance. Fig. 5 shows that Starling has a
significantly higher throughput than DiskANN under the same AP. For example, it is 43.9× faster
than DiskANN when 𝐴𝑃= 0.9 on BIGANN. Further investigation reveals that DiskANN requires
numerous disk I/Os for some queries with long RS results (e.g., 1,000). In that case, Starling
achieves greater gains as it avoids more redundant disk I/Os.
10
20
Latency (ms)
0.90
0.92
0.94
0.96
0.98
Recall (k=10)
(a) BIGANN
5
10
15
Latency (ms)
0.90
0.92
0.94
0.96
0.98
Recall (k=10)
Starling
DiskANN
SPANN
(b) Text2image
10
20
Latency (ms)
0.90
0.92
0.94
0.96
0.98
Recall (k=10)
(a) DEEP
Fig. 6. ANNS performance (Recall vs Latency).
0.90 0.92 0.94 0.96 0.98 1.00
Recall (k=10)
1000
2000
QPS
Starling
DiskANN
SPANN
(a) BIGANN
0.90 0.92 0.94 0.96 0.98 1.00
Recall (k=10)
0
1000
2000
QPS
(b) DEEP
Fig. 7. ANNS performance (QPS vs Recall).
ANNS performance. Fig. 6 contrasts the Recall and Latency of assorted methods. SPANN on
Text2image is omitted, as its latency exceeds 20ms when 𝑅𝑒𝑐𝑎𝑙𝑙> 0.9. Starling consistently
delivers lower latency compared to two rivals under similar Recall conditions. For example, at
𝑅𝑒𝑐𝑎𝑙𝑙= 0.95 on BIGANN, Starling (5ms) achieves over 2× more speed than DiskANN (10ms) and
10× more than SPANN (50ms). Fig. 7 delineates the QPS and Recall of various methods. Starling
continually exhibits superior performance over its competitors. SPANN presents lackluster results,
worse than anticipated. The reason is that SPANN relies heavily on data duplication (up to eight-
fold the base data size [16]). Given the segment configuration, the number of data replications is
restrained, leading to a performance dip (for additional analysis, see §6.9).
6.3
I/O-efficiency
Table 2. Vertex utilization ratio (𝜉) and search path length (ℓ).
Framework↓
Metric↓
BIGANN
DEEP
SSNPP
Text2image
DiskANN
𝜉
0.0625
0.1429
0.1111
0.2500
Starling
0.3438
0.4429
0.4111
0.8760
DiskANN
ℓ
362
341
127
269
Starling
182
240
100
167
Vertex utilization ratio (𝜉). We calculate 𝜉for each block loaded in the queries and average
these to obtain the overall 𝜉for the loaded blocks. As displayed in Tab. 2, Starling consistently
outperforms DiskANN across all datasets. This superior performance is credited to Starling’s
data locality enhancement through block shuffling, which permits a single block from the disk to
encompass multiple relevant vertices. This approach heightens 𝜉, thereby mitigating disk bandwidth
wastage. Hence, Starling exhibits higher I/O-efficiency. Nonetheless, 𝜉is not the exclusive factor
that influences query performance–other factors such as data distribution and optimizations like
the in-memory navigation graph also impact overall performance, potentially causing a non-linear
relationship between 𝜉and query performance metrics such as latency.
, Vol. 1, No. 1, Article . Publication date: March 2024.

---

18
Mengzhao Wang, et al.
Search path length (ℓ). We undertake an evaluation of ℓfor all queries, subsequently reporting
the average ℓunder specified search accuracy. As denoted in Tab. 2, Starling exhibits a shorter ℓ
compared to DiskANN. Within Starling, the in-memory navigation graph yields query-aware
dynamic entry points that are in closer proximity to the query, thus reducing ℓ. Consequently, the
IO-efficiency of Starling sees further improvement.
6.4
Index Cost
9.5% 5.5% 6.8%
6.7%
Tdisk_graph
Tshuffling
Tmemory_graph
Thot
TPQ
Tdisk_graph
Tshuffling
Tmemory_graph
Thot
TPQ
78.2%
78.2%
76.6%
76.6%
16.7%
76.6%
16.7%
= 1189 s
= 1189 s
= 1214 s
9.5% 5.5% 6.8%
6.7%
Tdisk_graph
Tshuffling
Tmemory_graph
Thot
TPQ
78.2%
76.6%
16.7%
= 1189 s
= 1214 s
(a) Index processing time
13.3%
Cgraph
Cmapping
Chot
CPQ&others
Cgraph
Cmapping
Chot
CPQ&others
58.9%
58.9%
41.1%
44.2%
42.5%
44.2%
42.5%
= 1895 MB
= 1925 MB
13.3%
Cgraph
Cmapping
Chot
CPQ&others
58.9%
41.1%
44.2%
42.5%
= 1895 MB
= 1925 MB
(b) Memory cost
Fig. 8. Index cost of two different frameworks on BIGANN.
Index processing time. The offline index process for Starling encompasses four components:
disk-based graph construction time 𝑇𝑑𝑖𝑠𝑘_𝑔𝑟𝑎𝑝ℎ, block shuffling time 𝑇𝑠ℎ𝑢𝑓𝑓𝑙𝑖𝑛𝑔, in-memory graph
construction time 𝑇𝑚𝑒𝑚𝑜𝑟𝑦_𝑔𝑟𝑎𝑝ℎ, and preprocessing time for PQ short codes 𝑇𝑃𝑄(cf. §5.1) Conse-
quently, the aggregate offline index procession time for Starling can be calculated as:
I𝑆𝑡𝑎𝑟𝑙𝑖𝑛𝑔= 𝑇𝑑𝑖𝑠𝑘_𝑔𝑟𝑎𝑝ℎ+𝑇𝑠ℎ𝑢𝑓𝑓𝑙𝑖𝑛𝑔+𝑇𝑚𝑒𝑚𝑜𝑟𝑦_𝑔𝑟𝑎𝑝ℎ+𝑇𝑃𝑄
.
(8)
The offline index process for DiskANN comprises three parts: disk-based graph construction time
𝑇𝑑𝑖𝑠𝑘_𝑔𝑟𝑎𝑝ℎ, hot vertices acquisition time 𝑇ℎ𝑜𝑡, and preprocessing time for PQ short codes 𝑇𝑃𝑄. As
per this structure, the total offline index processing for DiskANN is:
I𝐷𝑖𝑠𝑘𝐴𝑁𝑁= 𝑇𝑑𝑖𝑠𝑘_𝑔𝑟𝑎𝑝ℎ+𝑇ℎ𝑜𝑡+𝑇𝑃𝑄
.
(9)
Fig. 8(a) exposes the breakdown of index processing time on BIGANN. Despite the additional
shuffling and construction time, Starling is substantially more efficient compared to DiskANN
since the summation of 𝑇𝑠ℎ𝑢𝑓𝑓𝑙𝑖𝑛𝑔and 𝑇𝑚𝑒𝑚𝑜𝑟𝑦_𝑔𝑟𝑎𝑝ℎin Starling is less than 𝑇ℎ𝑜𝑡in DiskANN.
DiskANN necessitates the generation of hot vertices which involves the sampling of a large pool of
queries and executing a slow disk-based graph search to tally vertex visit frequency. This procedure
can be extremely time-consuming without hot vertices in memory. In contrast, Starling’s approach
of building an in-memory navigation graph proves to be faster and more effective. It is also worth
noting that both Starling and DiskANN have an equal 𝑇𝑑𝑖𝑠𝑘_𝑔𝑟𝑎𝑝ℎand 𝑇𝑃𝑄.
Memory cost. In the main memory, Starling manages an in-memory navigation graph (C𝑔𝑟𝑎𝑝ℎ),
the mapping of vertex IDs to block IDs (C𝑚𝑎𝑝𝑝𝑖𝑛𝑔), and PQ short codes along with other data
structures (C𝑃𝑄&𝑜𝑡ℎ𝑒𝑟𝑠). Hence, the total memory cost of Starling is
M𝑆𝑡𝑎𝑟𝑙𝑖𝑛𝑔= C𝑔𝑟𝑎𝑝ℎ+ C𝑚𝑎𝑝𝑝𝑖𝑛𝑔+ C𝑃𝑄&𝑜𝑡ℎ𝑒𝑟𝑠
.
(10)
DiskANN, on the other hand, houses a set of hot vertices (Cℎ𝑜𝑡) and the PQ short codes along with
other data structures (C𝑃𝑄&𝑜𝑡ℎ𝑒𝑟𝑠). The memory cost is hence:
M𝐷𝑖𝑠𝑘𝐴𝑁𝑁= Cℎ𝑜𝑡+ C𝑃𝑄&𝑜𝑡ℎ𝑒𝑟𝑠
.
(11)
DiskANN does not maintain 𝐶𝑚𝑎𝑝𝑝𝑖𝑛𝑔as a group of ID-contiguous vertices are allocated into a
block (it locates a block by vertex ID).
Fig. 8(b) offers a comparison of the memory costs of both frameworks when handling the same
set of queries with the same accuracy on BIGANN. The results reveal Starling has lower memory
overhead compared to DiskANN. The reason for this is as follows. Starling requires an extra
, Vol. 1, No. 1, Article . Publication date: March 2024.

---

Starling: An I/O-Efficient Disk-Resident Graph Index Framework
19
mapping of vertex IDs to block IDs post block shuffling as vertex IDs within a block are non-
consecutive. In DiskANN, each hot vertex comprises vector data and the neighbor IDs of the
disk-based index. Starling’s in-memory graph also includes vector data and neighbor IDs but it
contains 20% fewer neighbor IDs than the disk-based graph since it possesses 10% less vector data.
Resultingly, C𝑔𝑟𝑎𝑝ℎ+ C𝑚𝑎𝑝𝑝𝑖𝑛𝑔in Starling is less than Cℎ𝑜𝑡in DiskANN.
Disk cost. Starling and DiskANN undergo the same disk cost as they utilize the same disk-based
graph, albeit in different layouts.
6.5
Ablation Study
DiskANN
BNP
BNF
Data Layout
0
500
1000
Block Counts
1000
739
698
0.00
0.25
0.50
OR(G)
0
0.283
0.427
 
Block Counts
OR(G)
(a) Block shuffling
0.90 0.92 0.94 0.96 0.98 1.00
Recall
1000
2000
QPS
DiskANN
BNP
BNF
(b) Search performance
Fig. 9. Effect of block shuffling.
0.90 0.92 0.94 0.96 0.98 1.00
Recall
100
200
Mean I/Os
w/o mem. graph
w. mem. graph
(a) Disk I/Os
0.90 0.92 0.94 0.96 0.98 1.00
Recall
1000
2000
QPS
(b) Throughput
Fig. 10. Effect of in-memory graph.
Block shuffling. Fig. 9(a) reports the average number of blocks containing the top-1,000 nearest
neighbors for each query within a given set (blue bar), as well as the overlap ratio 𝑂𝑅(𝐺) (red
bar) on DEEP. We limit our discussion to BNP and BNF, as BNS has slow processing times on
a full-size segment. For BNF, we set the iteration parameter 𝛽to eight for an optimal balance
between efficiency and efficacy. DiskANN’s 𝑂𝑅(𝐺) is found to be nearly zero, as the majority of
vertices within a block are irrelevant. Both BNP and BNF consistently register higher 𝑂𝑅(𝐺) than
DiskANN, indicating the positive impact of our shuffling algorithms on data locality. BNF further
amplifies 𝑂𝑅(𝐺) on BNP, incurring a minor additional time cost, which is negligible about the total
index processing time (∼9.5%). Due to DiskANN’s poor locality, almost all of the top-1,000 nearest
neighbors are stored across disparate blocks, necessitating the checking of a minimum of 1,000
blocks for the retrieval of top-1,000 results. In comparison, BNP and BNF cut down the number of
blocks by over 30%, enabling Starling to search through fewer blocks. Fig. 9(b) evidences BNP
and BNF’s exceptional performance in search tasks over DiskANN, with BNF outdoing BNP owing
to its superior locality. By default, BNF is utilized for block shuffling in Starling.
In-memory navigation graph. To ascertain the impact of the in-memory navigation graph, we
turn it on/off within Starling, ensuring all other settings remain identical. As depicted in Fig. 10,
this analysis highlights the changes in disk I/Os and throughput on BIGANN. The activation of the
in-memory graph leads to a reduction in disk I/Os by approximately 20% for the same Recall. This
outcome stems from initiating our search on the disk-based graph from entry points positioned
closer to the query, which effectively shortens the search path length (refer to §3.1 for further
details). Fig. 10(b) reveals that the in-memory graph notably elevates throughput. Importantly, the
in-memory graph implementation does not alter the vertex utilization ratio.
0.90 0.92 0.94 0.96 0.98 1.00
Recall
1000
2000
QPS
w. pruning
w/o pruning
(a) Block pruning
0.90 0.92 0.94 0.96 0.98 1.00
Recall
1000
1500
2000
QPS
w. pipeline
w/o pipeline
(b) I/O-computation pipeline
0.9
1.0
Recall
0
1000
Mean I/Os
w. PQ distance
w/o PQ distance
(c) PQ distance
92.5%
TI/O
Tcomp (4.2%)
Tother (3.3%)
57.7%
22.3%
20.0%
TI/O
Tcomp
Tother
57.7%
22.3%
20.0%
TI/O
Tcomp
Tother
92.5%
TI/O
Tcomp (4.2%)
Tother (3.3%)
57.7%
22.3%
20.0%
TI/O
Tcomp
Tother
(d) Search profile
Fig. 11. Effect of the block search optimizations.
, Vol. 1, No. 1, Article . Publication date: March 2024.

---

20
Mengzhao Wang, et al.
Block pruning. We assess the influence of block pruning on BIGANN by comparing Starling
both with and without the implementation of pruning. The trade-off between QPS and Recall is
presented for both scenarios. Fig. 11(a) demonstrates that Starling, when equipped with block
pruning, exhibits superior performance. This can be attributed to the negation of unnecessary
computations by pruning vertices that are distant from the query. Note that achieving an ideal
graph layout with a perfect overlap ratio 𝑂𝑅(𝐺) = 1 is a challenging task (refer to §4.1 for details).
Some vertices located within a loaded block are not neighbors of the target vertex. Block pruning
aids in filtering out these non-neighbor vertices, effectively circumventing unnecessary visits.
I/O and computation pipeline. Fig. 11(d) delineates the breakdown of search time for two
frameworks with an identical Recall on BIGANN. For DiskANN, disk I/O is accountable for as
much as 92.5% of the total search time, thus establishing itself as the bottleneck for HVSS on the
disk-based graph. On the contrary, Starling enhances the vertex utilization ratio by leveraging
superior data locality, thereby diminishing the I/O time (𝑇𝐼/𝑂) ratio to 57.7%. However, Starling
also escalates the distance computation time 𝑇𝑐𝑜𝑚𝑝since more vertices are examined in each loaded
block. As a result, both I/O and computation are dominant and need to be executed in parallel for
optimal performance. Fig. 11(b) outlines the impact of the I/O and computation pipeline, illustrating
that the pipeline boosts QPS for the same Recall. This implementation may result in additional
computations, as some vertex visitations within the current loaded block are deferred (see §5.1
for more information). Despite this, the trade-off proves to be beneficial, enabling more efficient
utilization of both the disk bandwidth and CPU, thereby improving the overall search performance.
PQ-based approximate distance. Fig. 11(c) depicts the average disk I/Os before and after the
implementation of the PQ-based approximate distance optimization on BIGANN for a given batch
of queries. It is clear that the number of disk I/Os is significantly reduced by applying this form of
optimization, while maintaining the same level of accuracy. This optimization ranks the candidate
set by approximate distance, which is calculated using PQ short codes in the main memory, thereby
circumventing the need for expensive disk I/O operations. Although employing the exact distance
might theoretically result in enhanced upper bound accuracy, the increased disk I/O cost can be
prohibitively high. With the employment of this optimization, it is possible to maintain high levels
of accuracy by adjusting other parameters (such as the size of the candidate set) while limiting the
amount of disk I/Os, thus making it more suitable for practical applications.
6.6
Parameter Sensitivity
0.90 0.92 0.94 0.96 0.98 1.00
Recall
500
1000
QPS
DiskANN
Starling
(a) Threads = 4
0.90 0.92 0.94 0.96 0.98 1.00
Recall
1000
2000
3000
QPS
(b) Threads = 16
Fig. 12. Effect of different threads.
0.90 0.92 0.94 0.96 0.98 1.00
Recall
1000
2000
3000
QPS
DiskANN
Starling
(a) 𝑘= 1
0.90 0.92 0.94 0.96 0.98 1.00
Recall
250
500
750
QPS
(b) 𝑘= 50
Fig. 13. Effect of different 𝑘in ANNS.
Number of threads. We carry out an evaluation of the parallelism of both Starling and DiskANN,
employing various thread settings ranging from 4 to 16 on BIGANN. Fig.12 highlights the QPS
vs Recall relationship. In both frameworks, the Recall remains constant with thread variations as
the number of threads does not influence the search path. Notably, irrespective of the number of
threads used, the QPS of Starling consistently proves to be twice as fast as DiskANN.
Number of search results. We conduct an examination on the effect of varying 𝑘from 1 to 50
on BIGANN. In Fig.13, it is clear that Starling exhibits a higher QPS than DiskANN for different
values of 𝑘. This observation showcases the robustness of Starling in managing ANNS problems.
, Vol. 1, No. 1, Article . Publication date: March 2024.

---

Starling: An I/O-Efficient Disk-Resident Graph Index Framework
21
0.90
0.92
0.94
0.96
0.98
AP
2500
5000
7500
QPS
DiskANN
Starling
(a) 𝑟= 3,400
0.90
0.92
0.94
0.96
0.98
AP
2000
4000
6000
QPS
(b) 𝑟= 3,920
Fig. 14. Effect of different 𝑟in RS.
Search radius. Fig. 14 presents a comparison of the RS performance with different radii 𝑟on
BIGANN. The results unequivocally demonstrate that Starling surpasses DiskANN across different
𝑟. This stark contrast highlights the superior performance of Starling in handling various 𝑟.
6.7
Scalability
Table 3. QPS of different number of segments on BIGANN.
Query →
RS (𝐴𝑃= 0.90)
ANNS (𝑅𝑒𝑐𝑎𝑙𝑙= 0.99)
# Seg. ↓
DiskANN
Starling
DiskANN
Starling
1
181
8,690 (48.0×)
239
538 (2.3×)
2
42
1,040 (24.8×)
161
321 (2.0×)
3
31
687 (22.2×)
131
257 (2.0×)
4
23
472 (20.5×)
98
193 (2.0×)
5
19
204 (10.7 ×)
79
163 (2.1×)
Number of segments. We set a fixed segment size and manipulate the number of segments needed
to process a batch of queries. Tab. 3 displays the scalability of Starling on a single machine. We
report the QPS of both frameworks maintaining equivalent accuracy for ANNS and RS. The findings
illustrate that Starling persistently surpasses DiskANN in performance for both ANNS and RS,
testifying to its superior scalability in relation to the number of segments.
33
66
100
132
165
Dataset size (Million)
2500
5000
7500
QPS
DiskANN
Starling
(a) RS (𝐴𝑃= 0.90)
33
66
100
132
165
Dataset size (Million)
200
400
QPS
DiskANN
Starling
(b) ANNS (𝑅𝑒𝑐𝑎𝑙𝑙= 0.99)
Fig. 15. Different data segment sizes.
0.90 0.92 0.94 0.96 0.98 1.00
Recall
500
1000
1500
QPS
Disk-NSG
Starling-NSG
(a) NSG
0.90 0.92 0.94 0.96 0.98 1.00
Recall
250
500
750
QPS
Disk-HNSW
Starling-HNSW
(b) HNSW
Fig. 16. Different graph algorithms.
Segment size. For other experiments, we establish a fixed dataset size of 4GB within a segment.
We test Starling’s performance on varying segment sizes via distinct dataset volumes. Remember,
each segment’s memory and disk space increase proportionately. Fig. 15 demonstrates the impact
of data segment sizes. Starling sustains a higher QPS than DiskANN for both RS and ANNS across
varying data volumes. This emphasizes that Starling scales efficiently with segment size.
Graph algorithms. By default, Starling employs the Vamana algorithm [35] to construct the
disk-based graph index. Here, we assess search performance on disk with two other graph indexes,
NSG [25] and HNSW [49]. We follow DiskANN to implement NSG and HNSW, but substitute NSG
and HNSW (layer-0) for Vamana, resulting in Disk-NSG and Disk-HNSW. We also adapt Starling
to use NSG and HNSW, obtaining Starling-NSG and Starling-HNSW. Notably, Starling-HNSW
has a multi-layered in-memory navigation graph with HNSW’s upper-layered graphs. Fig. 16 shows
the QPS vs Recall comparison. We find that the two graph indexes on Starling perform better than
the baseline framework. For example, Starling-HNSW’s QPS is over 2× higher than Disk-HNSW.
This shows Starling’s generality to support other graph algorithms.
, Vol. 1, No. 1, Article . Publication date: March 2024.

---

22
Mengzhao Wang, et al.
0.90 0.92 0.94 0.96 0.98 1.00
Recall
1000
2000
3000
QPS
DiskANN(In)
Starling(In)
DiskANN(Out)
Starling(Out)
(a) Query distribution
0.90 0.92 0.94 0.96 0.98 1.00
Recall
1000
2000
QPS
DiskANN
Starling
SPANN(10GB)
SPANN(20GB)
SPANN(32GB)
(b) Segment setup
Fig. 17. Different queries and segments.
0.90 0.92 0.94 0.96 0.98 1.00
Recall
0
200
400
QPS
Starling
DiskANN
SPANN
(a) 8GB
0.90 0.92 0.94 0.96 0.98 1.00
Recall
0
100
200
QPS
Starling
DiskANN
SPANN
(b) 16GB
Fig. 18. Different data sizes.
6.8
In- and Not-in-Database Queries
We compare different methods on in-database and not-in-database queries on BIGANN. In-database
queries are vectors that exist in the graph index, while not-in-database queries are not. We randomly
sample 10,000 vectors from the base data as in-database queries and execute the search on two
frameworks. Fig. 17(a) shows that Starling consistently outperforms DiskANN for both types of
queries. Moreover, in-database queries achieve higher throughput than not-in-database queries for
both frameworks. This is because in-database queries can leverage some better query-aware entry
points, which may be the query points themselves. However, the in-memory navigation graph
can also find some entry points close to the not-in-database queries to shorten their search path.
Notably, both types of query workloads benefit from data locality through offline block shuffling.
6.9
Evaluation on Other Segment Setups
Effect of disk capacity. We fix the dataset size at 4GB and memory size at 2GB, and test different
segment setups with the disk capacity from 10GB to 32GB. Fig. 17(b) shows the search performance
on BIGANN. DiskANN and Starling exhibit the best QPS-Recall trade-off with an index size of
less than 10GB, so we only plot one curve for each of them. SPANN improves its performance as
the disk space increases, because it can duplicate more boundary data points, thereby reducing
disk I/Os. However, Starling still performs much better than SPANN, with a smaller disk setup.
Effect of dataset size. We employ a fixed segment space with a memory of 2GB and a disk capacity
of 32GB to test diverse dataset sizes of 4GB, 8GB, and 16GB. Fig. 18 shows the search performance
of different methods on BIGANN (see Fig. 17(b) for the 4GB dataset). We tune the parameters of
all methods to get the best QPS-Recall trade-off under the segment space constraint. The results
conclusively depict the superior performance of Starling over rival methods across all dataset
sizes. Importantly, the performance gap increases as the dataset size magnifies. SPANN suffers from
a larger dataset size because it cannot replicate enough data to minimize disk I/Os.
6.10
Large-scale Search Results
We set the number of search results (𝑘) to less than 50 for other experiments. In some cases, we
may need much more results, such as thousands. For example, in recommendation systems, a large
number of candidates are first recalled and then filtered to get the final recommendations [17, 67].
Fig. 19(a) shows the search performance with 𝑘= 5, 000 on BIGANN. We can see that Starling
has a much lower Mean I/Os than DiskANN. For instance, with a Recall of 0.99, Starling saves
more than 20,000 disk I/Os per query than DiskANN. This shows that Starling is more efficient
and effective in scenarios with large-scale search results.
6.11
Evaluation on Billion-scale Data
We evaluate our method on the one billion BIGANN dataset. We split the dataset into 31 segments,
each with 2GB memory and 10GB disk. One query node has only 32GB of memory in our experi-
ments, so we assigned 31 segments to two query nodes. We merge candidates from each segment
to get the final results. We use the same setting for Starling and DiskANN to ensure fairness. Fig.
, Vol. 1, No. 1, Article . Publication date: March 2024.

---

Starling: An I/O-Efficient Disk-Resident Graph Index Framework
23
0.90 0.92 0.94 0.96 0.98 1.00
Recall
10000
20000
30000
Mean I/Os
DiskANN
Starling
(a) 𝑘= 5000
0.90 0.92 0.94 0.96 0.98 1.00
Recall
50
100
150
QPS
DiskANN
Starling
(b) Billion-scale data
Fig. 19. Large-scale search results and Billion-scale data.
19(b) shows that Starling is more than 2× faster than DiskANN in the high recall regime (e.g.,
Recall > 0.96 ). Note that current vector databases use some data segmentation strategies and a
query coordinator, which can avoid scanning all segments for a query [29]. Our method can work
well with these strategies. For more details on data segmentation strategies, please refer to [23, 75].
7
DISCUSSION
Memory-based related work. Memory-based HVSS often involves preprocessing data to strike
a balance between efficiency and accuracy. Existing algorithms fall into four categories: tree-
[20, 47, 50]; quantization- [9, 30, 36]; hashing- [27, 33, 43]; and graph-based [24, 25, 49]. Tree-based
and hashing-based methods are not prevalent in HVSS due to the “curse of dimensionality” and low
accuracy [45]. Quantization-based methods (e.g., IVFPQ) prove efficient and memory-saving but
tend to suffer from a poor recall rate[35, 60]. Graph-based methods (e.g., HNSW) exhibit leading
efficiency-accuracy trade-offs. However, they necessitate both raw vector data and the graph
index to be in the main memory, elevating memory consumption and impeding scalability for
large-scale vectors [16]. Starling is a universal and I/O-efficient framework capable of integrating
different graph algorithms (e.g., HNSW) into the disk-index component. For example, Starling
accommodates HNSW seamlessly without sacrificing functionality (cf. Fig. 16(b)).
Comparison analysis with SPANN. While both Starling and SPANN leverage in-memory
graphs and locality-centric disk indexes, they address varying challenges and utilize unique strate-
gies. SPANN, a clustering-based disk index, partitions data utilizing k-means, thereby achieving an
inherent locality allowing clustered data to be stored and accessed synchronously. Furthermore, it
builds an in-memory graph for fast cluster retrieval. In contrast, Starling addresses disk-based
graph search by optimizing data layout and search strategy. When residing in memory, graph-based
methods excel in terms of accuracy and efficiency. However, once placed on disk, they incur many
I/Os due to long search path and poor data locality. Starling mitigates these issues by building an
in-memory graph to shorten the search path and using block shuffling to enhance locality. Note that
the graph index neighborhood exhibits both similarity and navigation traits [68]. This implies that
a vertex may have neighbors from different clusters [49], posing a major challenge for the locality
of the graph index. We compare block shuffling with a naive strategy that assigns vertices to blocks
by k-means on SSNPP. The results show that block shuffling achieves a 12× higher overlap ratio.
In-memory graph. Our in-memory graph serves as an index directing query routes, instead of
acting as a cache for frequently accessed data. We initially used memory mapping (mmap) instead
of direct I/O (o_direct) but found more disk I/Os linked to a memory-mapped graph. This lowers
efficiency compared to the hot points strategy in the baseline framework. Our evaluation showed
that the in-memory graph outperforms the hot points strategy in search performance and memory
overhead. In Starling, we have the flexibility to utilize any graph algorithm like HNSW [49] or
NSG [25] for the in-memory graph. We typically use the same algorithm for both in-memory and
disk-based graphs. In HNSW, the upper-layer graphs are a subset of the layer-0 graph. Thus, we
can keep the higher layers in memory as a multi-layered in-memory graph and store the layer-0
graph on disk. This makes HNSW easy to implement in Starling (see Fig. 16(b)).
, Vol. 1, No. 1, Article . Publication date: March 2024.

---

24
Mengzhao Wang, et al.
Central assumption. With modern SSD (high IOPS), recent methods like DiskANN can fetch
multiple blocks simultaneously in each disk round-trip. This is because fetching a small number of
random blocks from a disk takes almost the same time as one block [35]. We keep this feature in
Starling while increasing the vertex utilization ratio in each loaded block by enhancing locality.
This reduces the total I/Os for a query by minimizing round-trips.
Data update. Starling, primarily emphasizing query optimization for static indexes, can handle
incremental updates at the database level [29]. Some vector databases (e.g., ADBV [70]) segregate
dynamic and static indexes to facilitate updates. The dynamic index, residing in memory, is built
incrementally and uses a bitset to monitor deleted data. As incoming data continues to grow, the
dynamic index expands correspondingly. Consequently, an asynchronous merging process transfers
the burgeoning dynamic index to the disk-based static index, necessitating a comprehensive index
reconstruction. Then, the block shuffling and in-memory graph techniques come into play.
Applications of range search (RS). RS is widely used in vector analytics, such as face recognition
[62], near-duplicate detection [2], and various applications on general embeddings [58, 65, 69]. In
some retrieval systems [14, 56], ANNS is followed by RS with seed vertices and similarity thresholds
[31] to obtain a similar cluster and offer more comprehensive results [39]. For example, users can
choose a seed vertex to get all related results. Several vector databases (e.g., PASE [72], VBase [76],
Milvus [66]) and memory-based works [11, 46] support both ANNS and RS on the same dataset.
8
CONCLUSION
We conduct a study on HVSS for the data segment, which is an essential component in vector
databases. HVSS for the data segment needs to meet strict requirements in terms of accuracy,
efficiency, memory usage, and disk capacity. However, existing methods only address some of these
aspects. Our framework, called Starling, adopts a disk-based graph index approach and considers
all these requirements simultaneously. It optimizes the data layout and search strategy to minimize
costly disk I/O operations. Experimental results demonstrate that Starling achieves significant
performance improvements compared to state-of-the-art methods while maintaining a small space
overhead. In the future, we plan to apply our methods to cache and GPU optimizations. We will
also integrate Starling into Milvus for distributed optimization.
ACKNOWLEDGMENTS
This work was supported in part by the NSFC under Grants No. (62025206, U23A20296), the
Primary R&D Plan of Zhejiang (2023C03198 and 2021C03156). Xiaomeng Yi and Xiaoliang Xu are
the corresponding authors of the work.
REFERENCES
[1] 2018.
A
Library
for
Efficient
Similarity
Search
and
Clustering
of
Dense
Vectors.
https://github.com/facebookresearch/faiss.
[2] 2020. Using AI to detect COVID-19 misinformation and exploitative content. https://ai.meta.com/blog/using-ai-to-
detect-covid-19-misinformation-and-exploitative-content/.
[3] 2021. Billion-Scale Approximate Nearest Neighbor Search Challenge: NeurIPS’21 competition track. https://big-ann-
benchmarks.com/.
[4] 2021. Milvus Was Built for Massive-Scale (Think Trillion) Vector Similarity Search. https://milvus.io/blog/Milvus-Was-
Built-for-Massive-Scale-Think-Trillion-Vector-Similarity-Search.md.
[5] 2021. Scalable graph based indices for approximate nearest neighbor search. https://github.com/microsoft/DiskANN.
[6] 2022. Building a Vector Database for Scalable Similarity Search. https://milvus.io/blog/deep-dive-1-milvus-architecture-
overview.md.
[7] 2023. The ChatGPT Retrieval Plugin lets you easily search and find personal or work documents by asking questions
in everyday language. https://github.com/openai/chatgpt-retrieval-plugin.
, Vol. 1, No. 1, Article . Publication date: March 2024.

---

Starling: An I/O-Efficient Disk-Resident Graph Index Framework
25
[8] Zainab Abbas, Vasiliki Kalavri, Paris Carbone, and Vladimir Vlassov. 2018. Streaming graph partitioning: an experi-
mental study. PVLDB 11, 11 (2018), 1590–1603.
[9] Fabien André, Anne-Marie Kermarrec, and Nicolas Le Scouarnec. 2015. Cache locality is not enough: High-Performance
Nearest Neighbor Search with Product Quantization Fast Scan. PVLDB 9, 4 (2015), 288–299.
[10] Konstantin Andreev and Harald Räcke. 2004. Balanced graph partitioning. In Proceedings of the sixteenth annual ACM
symposium on Parallelism in algorithms and architectures. 120–124.
[11] Kazuo Aoyama, Kazumi Saito, Hiroshi Sawada, and Naonori Ueda. 2011. Fast approximate similarity search based on
degree-reduced neighborhood graphs. In SIGKDD. 1055–1063.
[12] Akari Asai, Sewon Min, Zexuan Zhong, and Danqi Chen. 2023. ACL 2023 Tutorial: Retrieval-based LMs and Applications.
ACL (2023).
[13] Amel Awadelkarim and Johan Ugander. 2020. Prioritized restreaming algorithms for balanced graph partitioning. In
SIGKDD. 1877–1887.
[14] Kai Uwe Barthel, Nico Hezel, Konstantin Schall, and Klaus Jung. 2019. Real-time visual navigation in huge image sets
using similarity graphs. In ACM MM. 2202–2204.
[15] Patrick H Chen, Chang Wei-cheng, Yu Hsiang-fu, Inderjit S Dhillon, and Hsieh Cho-jui. 2022. FINGER: Fast Inference
for Graph-based Approximate Nearest Neighbor Search. arXiv:2206.11408 (2022).
[16] Qi Chen, Bing Zhao, Haidong Wang, Mingqin Li, Chuanjie Liu, Zengzhong Li, Mao Yang, and Jingdong Wang. 2021.
SPANN: Highly-efficient Billion-scale Approximate Nearest Neighborhood Search. In NeurIPS 2021. 5199–5212.
[17] Rihan Chen, Bin Liu, Han Zhu, Yaoxuan Wang, Qi Li, Buting Ma, Qingbo Hua, Jun Jiang, Yunlong Xu, Hongbo
Deng, and Bo Zheng. 2022. Approximate Nearest Neighbor Search under Neural Similarity Metric for Large-Scale
Recommendation. In CIKM. 3013–3022.
[18] Benjamin Coleman, Santiago Segarra, Anshumali Shrivastava, and Alex Smola. 2021. Graph Reordering for Cache-
Efficient Near Neighbor Search. arXiv:2104.03221 (2021).
[19] Paul Covington, Jay Adams, and Emre Sargin. 2016. Deep neural networks for youtube recommendations. In Proceedings
of the 10th ACM conference on recommender systems. 191–198.
[20] Sanjoy Dasgupta and Yoav Freund. 2008. Random Projection Trees and Low Dimensional Manifolds. In SOTC. 537–546.
[21] Shiyuan Deng, Xiao Yan, KW Ng Kelvin, Chenyu Jiang, and James Cheng. 2019. Pyramid: A general framework for
distributed similarity search on large-scale datasets. In IEEE International Conference on Big Data. 1066–1071.
[22] Wei Dong, Moses Charikar, and Kai Li. 2011. Efficient K-nearest Neighbor Graph Construction for Generic Similarity
Measures. In WWW. 577–586.
[23] Ishita Doshi, Dhritiman Das, Ashish Bhutani, Rajeev Kumar, Rushi Bhatt, and Niranjan Balasubramanian. 2022. LANNS:
A Web-Scale Approximate Nearest Neighbor Lookup System. PVLDB 15, 4 (2022).
[24] Cong Fu, Changxu Wang, and Deng Cai. 2021. High Dimensional Similarity Search with Satellite System Graph:
Efficiency, Scalability, and Unindexed Query Compatibility. TPAMI (2021).
[25] Cong Fu, Chao Xiang, Changxu Wang, and Deng Cai. 2019. Fast Approximate Nearest Neighbor Search With The
Navigating Spreading-out Graph. PVLDB 12, 5 (2019), 461–474.
[26] Tiezheng Ge, Kaiming He, Qifa Ke, and Jian Sun. 2013. Optimized Product Quantization for Approximate Nearest
Neighbor Search. In CVPR. 2946–2953.
[27] Long Gong, Huayi Wang, Mitsunori Ogihara, and Jun Xu. 2020. iDEC: Indexable Distance Estimating Codes for
Approximate Nearest Neighbor Search. PVLDB 13, 9 (2020), 1483–1497.
[28] Mihajlo Grbovic and Haibin Cheng. 2018. Real-time personalization using embeddings for search ranking at airbnb. In
SIGKDD. 311–320.
[29] Rentong Guo, Xiaofan Luan, Long Xiang, Xiao Yan, Xiaomeng Yi, Jigao Luo, Qianya Cheng, Weizhi Xu, Jiarui Luo,
Frank Liu, Zhenshan Cao, Yanliang Qiao, Ting Wang, Bo Tang, and Charles Xie. 2022. Manu: A Cloud Native Vector
Database Management System. PVLDB 15, 12 (2022), 3548–3561.
[30] Ruiqi Guo, Philip Sun, Erik Lindgren, Quan Geng, David Simcha, Felix Chern, and Sanjiv Kumar. 2020. Accelerating
Large-Scale Inference with Anisotropic Vector Quantization. In ICML. 3887–3896.
[31] Nico Hezel, Kai Uwe Barthel, Konstantin Schall, and Klaus Jung. 2023. Fast Approximate Nearest Neighbor Search
with a Dynamic Exploration Graph using Continuous Refinement. arXiv:2307.10479 (2023).
[32] Jui-Ting Huang, Ashish Sharma, Shuying Sun, Li Xia, David Zhang, Philip Pronin, Janani Padmanabhan, Giuseppe
Ottaviano, and Linjun Yang. 2020. Embedding-based retrieval in facebook search. In SIGKDD. 2553–2561.
[33] Qiang Huang, Jianlin Feng, Yikai Zhang, Qiong Fang, and Wilfred Ng. 2015. Query-Aware Locality-Sensitive Hashing
for Approximate Nearest Neighbor Search. PVLDB 9, 1 (2015), 1–12.
[34] Shikhar Jaiswal, Ravishankar Krishnaswamy, Ankit Garg, Harsha Vardhan Simhadri, and Sheshansh Agrawal. 2022.
OOD-DiskANN: Efficient and Scalable Graph ANNS for Out-of-Distribution Queries. arXiv:2211.12850 (2022).
[35] Suhas Jayaram Subramanya, Fnu Devvrit, Harsha Vardhan Simhadri, Ravishankar Krishnawamy, and Rohan Kadekodi.
2019. DiskANN: Fast Accurate Billion-point Nearest Neighbor Search on a Single Node. In NeurIPS, Vol. 32.
, Vol. 1, No. 1, Article . Publication date: March 2024.

---

26
Mengzhao Wang, et al.
[36] Hervé Jégou, Matthijs Douze, and Cordelia Schmid. 2011. Product Quantization for Nearest Neighbor Search. TPAMI
33, 1 (2011), 117–128.
[37] Quoc Le and Tomas Mikolov. 2014. Distributed representations of sentences and documents. In ICML. 1188–1196.
[38] Conglong Li, Minjia Zhang, David G. Andersen, and Yuxiong He. 2020. Improving Approximate Nearest Neighbor
Search through Learned Adaptive Early Termination. In SIGMOD. 2539–2554.
[39] Hao Li, Xiaojie Liu, Tao Li, and Rundong Gan. 2020. A novel density-based clustering algorithm using nearest neighbor
graph. PR 102 (2020), 107206.
[40] Hongzheng Li, Yingxia Shao, Junping Du, Bin Cui, and Lei Chen. 2022. An I/O-Efficient Disk-based Graph System for
Scalable Second-Order Random Walk of Large Graphs. PVLDB 15, 8 (2022), 1619–1631.
[41] Jie Li, Haifeng Liu, Chuanghua Gui, Jianyu Chen, Zhenyuan Ni, Ning Wang, and Yuan Chen. 2018. The Design
and Implementation of a Real Time Visual Search System on JD E-commerce Platform. In Proceedings of the 19th
International Middleware Conference. 9–16.
[42] Mingjie Li, Yuan-Gen Wang, Peng Zhang, Hanpin Wang, Lisheng Fan, Enxia Li, and Wei Wang. 2022. Deep Learning
for Approximate Nearest Neighbour Search: A Survey and Future Directions. IEEE Transactions on Knowledge and
Data Engineering (2022).
[43] Mingjie Li, Ying Zhang, Yifang Sun, Wei Wang, Ivor W. Tsang, and Xuemin Lin. 2020. I/O Efficient Approximate
Nearest Neighbour Search based on Learned Functions. In ICDE. 289–300.
[44] Nan Li, Bo Kang, and Tijl De Bie. 2023. SkillGPT: a RESTful API service for skill extraction and standardization using a
Large Language Model. arXiv:2304.11060 (2023).
[45] Wen Li, Ying Zhang, Yifang Sun, Wei Wang, Mingjie Li, Wenjie Zhang, and Xuemin Lin. 2020. Approximate Nearest
Neighbor Search on High Dimensional Data - Experiments, Analyses, and Improvement. TKDE 32, 8 (2020), 1475–1488.
[46] Kejing Lu, Mineichi Kudo, Chuan Xiao, and Yoshiharu Ishikawa. 2022. HVS: hierarchical graph structure based on
voronoi diagrams for solving approximate nearest neighbor search. PVLDB 15, 2 (2022), 246–258.
[47] Kejing Lu, Hongya Wang, Wei Wang, and Mineichi Kudo. 2020. VHP: Approximate Nearest Neighbor Search via
Virtual Hypersphere Partitioning. PVLDB 13, 9 (2020), 1443–1455.
[48] Grzegorz Malewicz, Matthew H. Austern, Aart J. C. Bik, James C. Dehnert, Ilan Horn, Naty Leiser, and Grzegorz
Czajkowski. 2010. Pregel: a system for large-scale graph processing. In SIGMOD. 135–146.
[49] Yury A. Malkov and D. A. Yashunin. 2020. Efficient and Robust Approximate Nearest Neighbor Search Using Hierarchical
Navigable Small World Graphs. TPAMI 42, 4 (2020), 824–836.
[50] Marius Muja and David G. Lowe. 2014. Scalable Nearest Neighbor Algorithms for High Dimensional Data. TPAMI 36,
11 (2014), 2227–2240.
[51] Ramzi Nasr, Daniel S Hirschberg, and Pierre Baldi. 2010. Hashing algorithms and data structures for rapid searches of
fingerprint vectors. Journal of chemical information and modeling 50, 8 (2010), 1358–1368.
[52] Thomas Neumann. 2011. Efficiently compiling efficient query plans for modern hardware. PVLDB 4, 9 (2011), 539–550.
[53] Donald Nguyen, Andrew Lenharth, and Keshav Pingali. 2013. A lightweight infrastructure for graph analytics. In
SOSP. 456–471.
[54] Shumpei Okura, Yukihiro Tagami, Shingo Ono, and Akira Tajima. 2017. Embedding-based news recommendation for
millions of users. In SIGKDD. 1933–1942.
[55] Anil Pacaci and M Tamer Özsu. 2019. Experimental analysis of streaming algorithms for graph partitioning. In SIGMOD.
1375–1392.
[56] Youngki Park, Sungchan Park, Woosung Jung, and Sang-goo Lee. 2015. Reversed CF: A fast collaborative filtering
algorithm using a k-nearest neighbor graph. Expert Systems with Applications 42, 8 (2015), 4022–4028.
[57] Maria Predari and Aurélien Esnard. 2016. A k-way greedy graph partitioning with initial fixed vertices for parallel
applications. In 2016 24th Euromicro International Conference on Parallel, Distributed, and Network-Based Processing
(PDP). 280–287.
[58] Jianbin Qin, Yaoshu Wang, Chuan Xiao, Wei Wang, Xuemin Lin, and Yoshiharu Ishikawa. 2018. GPH: Similarity search
in hamming space. In ICDE. 29–40.
[59] Michael r. garey and david s. johnson. 1980. Computers and Intractability: A Guide to the Theory of NP-Completeness.
[60] Jie Ren, Minjia Zhang, and Dong Li. 2020. HM-ANN: Efficient Billion-Point Nearest Neighbor Search on Heterogeneous
Memory. In NeurIPS.
[61] Amaia Salvador, Nicholas Hynes, Yusuf Aytar, Javier Marin, Ferda Ofli, Ingmar Weber, and Antonio Torralba. 2017.
Learning cross-modal embeddings for cooking recipes and food images. In CVPR. 3020–3028.
[62] Florian Schroff, Dmitry Kalenichenko, and James Philbin. 2015. Facenet: A unified embedding for face recognition and
clustering. In CVPR. 815–823.
[63] Julian Shun and Guy E. Blelloch. 2013. Ligra: a lightweight graph processing framework for shared memory. In PPoPP.
135–146.
, Vol. 1, No. 1, Article . Publication date: March 2024.

---

Starling: An I/O-Efficient Disk-Resident Graph Index Framework
27
[64] Harsha Vardhan Simhadri, George Williams, Martin Aumüller, Matthijs Douze, Artem Babenko, Dmitry Baranchuk, Qi
Chen, Lucas Hosseini, Ravishankar Krishnaswamy, Gopal Srinivasa, Suhas Jayaram Subramanya, and Jingdong Wang.
2021. Results of the NeurIPS’21 Challenge on Billion-Scale Approximate Nearest Neighbor Search. In NeurIPS, Vol. 176.
177–189.
[65] Yang Song, Yu Gu, Rui Zhang, and Ge Yu. 2021. ProMIPS: Efficient high-dimensional C-approximate maximum inner
product search with a lightweight index. In ICDE. 1619–1630.
[66] Jianguo Wang, Xiaomeng Yi, Rentong Guo, Hai Jin, Peng Xu, Shengjun Li, Xiangyu Wang, Xiangzhou Guo, Chengming
Li, Xiaohai Xu, Kun Yu, Yuxing Yuan, Yinghao Zou, Jiquan Long, Yudong Cai, Zhenxiang Li, Zhifeng Zhang, Yihua
Mo, Jun Gu, Ruiyi Jiang, Yi Wei, and Charles Xie. 2021. Milvus: A Purpose-Built Vector Data Management System. In
SIGMOD. 2614–2627.
[67] Mengzhao Wang, Lingwei Lv, Xiaoliang Xu, Yuxiang Wang, Qiang Yue, and Jiongkang Ni. 2023. An Efficient and
Robust Framework for Approximate Nearest Neighbor Search with Attribute Constraint. In NeurIPS.
[68] Mengzhao Wang, Xiaoliang Xu, Qiang Yue, and Yuxiang Wang. 2021. A Comprehensive Survey and Experimental
Comparison of Graph-Based Approximate Nearest Neighbor Search. PVLDB 14, 11 (2021), 1964–1978.
[69] Yifan Wang, Haodi Ma, and Daisy Zhe Wang. 2022. LIDER: An Efficient High-dimensional Learned Index for Large-scale
Dense Passage Retrieval. PVLDB 16, 2 (2022), 154–166.
[70] Chuangxian Wei, Bin Wu, Sheng Wang, Renjie Lou, Chaoqun Zhan, Feifei Li, and Yuanzhe Cai. 2020. AnalyticDB-V:
A Hybrid Analytical Engine Towards Query Fusion for Structured and Unstructured Data. PVLDB 13, 12 (2020),
3152–3165.
[71] Hao Wei, Jeffrey Xu Yu, Can Lu, and Xuemin Lin. 2016. Speedup Graph Processing by Graph Ordering. In SIGMOD.
1813–1828.
[72] Wen Yang, Tao Li, Gai Fang, and Hong Wei. 2020. PASE: PostgreSQL Ultra-High-Dimensional Approximate Nearest
Neighbor Search Extension. In SIGMOD. 2241–2253.
[73] Erfan Zamanian, Carsten Binnig, and Abdallah Salama. 2015. Locality-aware partitioning in parallel database systems.
In SIGMOD. 17–30.
[74] Minjia Zhang and Yuxiong He. 2019. Grip: Multi-store capacity-optimized high-performance nearest neighbor search
for vector search engine. In CIKM. 1673–1682.
[75] Pengcheng Zhang, Bin Yao, Chao Gao, Bin Wu, Xiao He, Feifei Li, Yuanfei Lu, Chaoqun Zhan, and Feilong Tang. 2022.
Learning-based query optimization for multi-probe approximate nearest neighbor search. VLDBJ (2022), 1–23.
[76] Qianxi Zhang, Shuotao Xu, Qi Chen, Guoxin Sui, Jiadong Xie, Zhizhen Cai, Yaoqi Chen, Yinxuan He, Yuqing Yang, Fan
Yang, et al. 2023. VBASE: Unifying Online Vector Similarity Search and Relational Queries via Relaxed Monotonicity.
In OSDI.
[77] Da Zheng, Disa Mhembere, Randal C. Burns, Joshua T. Vogelstein, Carey E. Priebe, and Alexander S. Szalay. 2015.
FlashGraph: Processing Billion-Node Graphs on an Array of Commodity SSDs. In FAST. 45–58.
[78] Chun Jiang Zhu, Minghu Song, Qinqing Liu, Chloé Becquey, and Jinbo Bi. 2020. Benchmark on indexing algorithms
for accelerating molecular similarity search. Journal of Chemical Information and Modeling 60, 12 (2020), 6167–6184.
, Vol. 1, No. 1, Article . Publication date: March 2024.

---

28
Mengzhao Wang, et al.
APPENDIX
A
PROOF OF THEOREM 4.1
We recall the triple shuffling problem. Given 𝑡= 3 · 𝜌integers 𝛼0, 𝛼1, · · · , 𝛼𝑡−1 and a threshold Ω
such that Ω/4 < 𝛼𝑖< Ω/2 and
𝑡−1
∑︁
𝑖=0
𝛼𝑖= 𝜌· Ω
,
(12)
the task is to partition the numbers into 𝜌triples and decide if these triples can be shuffled by
swapping numbers between triples so that each triple sums up to Ω. This problem is strongly
NP-complete [10, 59].
We construct a graph 𝐺with cliques of size 𝛼𝑖for each integer 𝛼𝑖. This graph has polynomial
size 𝜌· Ω since the integers are bounded by Ω/4 < 𝛼𝑖< Ω/2.
1. The block shuffling problem is NP-hard.
In the following, we prove that the block shuffling problem on 𝐺has a solution iff the triple
shuffling problem can be solved, which implies that the block shuffling problem is NP-hard. Note
that Ω is the number of vertices in a block and 𝜌is the number of blocks in the graph layout of 𝐺.
(⇒): If there is a block shuffling of 𝐺with the largest 𝑂𝑅(𝐺) (let 𝑐be the largest 𝑂𝑅(𝐺)), then each
block contains three cliques, and the sum of their sizes is Ω. We can map each clique size in a block
to an integer and get a solution to the triple shuffling problem.
(⇐): If there is a solution to the triple shuffling problem, then the integers can be grouped into
triples that sum up to Ω. We can map each triple to a block and each integer to a clique size in that
block, resulting in a block shuffling of 𝐺with 𝑂𝑅(𝐺) = 𝑐.
2. The block shuffling problem does not have a polynomial time approximation algorithm
with a finite approximation factor unless P=NP.
Suppose that we have a polynomial time approximation algorithm with a finite approximation
factor for the block shuffling problem. We can use it to solve the triple shuffling problem. Case 1:
If there is a block shuffling of 𝐺with the largest 𝑂𝑅(𝐺), then the triple shuffling problem has a
solution. Case 2: If there is no block shuffling of 𝐺with the largest 𝑂𝑅(𝐺), then 𝑂𝑅(𝐺) is less
than 𝑐and the triple shuffling problem has no solution. Any approximation algorithm with a finite
approximation factor for the block shuffling problem must be able to tell these two cases apart
to solve the triple shuffling problem. Since we know that checking whether it returns the largest
𝑂𝑅(𝐺) or not is NP-hard, which contradicts the assumption.
B
DISK-BASED GRAPH INDEX METHOD
Graph-based vector search methods are more efficient and accurate than other solutions [25, 35].
Fig. 20 shows how they build a graph index 𝐺= (𝑉, 𝐸) for the vector dataset. Each data point (i.e.,
vector) is a vertex in 𝑉and each edge in 𝐸connects close vertices [46, 68]. A block is the smallest
unit for disk I/O operations. The disk stores the adjacency list of each vertex with its vector data,
and packs data of multiple vertices into one block. This way, one disk access can read both vector
data and neighbor IDs for a vertex. In the example, each block stores data of four vertices. The
entire block is loaded into the main memory when accessing data of any vertex in it.
Most graph index methods [24, 46, 49] use a similar search strategy, called the greedy search
strategy (we call it as the vertex search strategy in this paper) [25]. Fig. 20 shows an example of
finding the nearest vertex to a query vector. The search starts from a random/fixed vertex and
traverses the graph. In the example, vertex 12 is the entry point. Its neighbors are visited to measure
their distance to the query vector. Then vertex 8 is chosen as the closest visited vertex to the query
, Vol. 1, No. 1, Article . Publication date: March 2024.

---

Starling: An I/O-Efficient Disk-Resident Graph Index Framework
29
Vector dataset
Search on disk-based graph
0
1
2
3
0
1
2
3
Disk read
12
2
Target 
vertex
Neighbor IDs
Vector data
Data layout on disk
Vertex IDs: 12~15
Vertex IDs: 8~11
Vertex IDs: 4~7
Vertex IDs: 0~3
Vertex IDs: 12~15
Vertex IDs: 8~11
Vertex IDs: 4~7
Vertex IDs: 0~3
Block 3:
Block 2:
Block 1:
Block 0:
Vertex IDs: 12~15
Vertex IDs: 8~11
Vertex IDs: 4~7
Vertex IDs: 0~3
Block 3:
Block 2:
Block 1:
Block 0:
0
1
2
3
7,8,14
11,15
4,10
5,9,15
0
1
2
3
7,8,14
11,15
4,10
5,9,15
Neighbor IDs
Vector data
Data layout on disk
Vertex IDs: 12~15
Vertex IDs: 8~11
Vertex IDs: 4~7
Vertex IDs: 0~3
Block 3:
Block 2:
Block 1:
Block 0:
0
1
2
3
7,8,14
11,15
4,10
5,9,15
Hops: 5
Entry point
3
15
5
8
0
1
15
...
6
12
7
8
0
9
2
5
4
1
3
15
13
11
14
10
6
12
7
8
0
9
2
5
4
1
3
15
13
11
14
10
6
Query vector
Result point
Disk
Fig. 20. Illustration of a disk-based graph index: logical topology (left), physical data layout (right).
vector. This process repeats iteratively. In each iteration, it finds a neighbor of the current vertex
that is closer to the query vector. In the example, the search visits vertices 8, 5, 2, 15 in order, until
it reaches vertex 3 who has no closer neighbors to the query vector than itself. In practice, a priority
queue maintains candidate vertices. In each iteration, we pop one vertex from the queue, visit its
neighbors, and add the neighbors that may update the current result to the queue. In the example,
we set the queue length as 1 for simplicity.
The vertex search strategy has a computational cost of 𝑂(𝑜· ℓ), where ℓis the search path length
(i.e., the number of hops) and 𝑜is the average out-degree of visited vertices. This is because we
need to calculate the distance to the query vector for all the vertices in the search path and their
neighbors. Let 𝜉be the vertex utilization ratio and 𝜀be the number of vertices in a disk block.
Then 𝜉· 𝜀represents the number of vertices accessed in each disk I/O. The I/O complexity is then
𝑂((𝑜· ℓ)/(𝜉· 𝜀)). The current disk-based graph index method only checks the target vertex and
discards the rest for a loaded block, so 𝜉· 𝜀is 1. The average disk I/O complexity is then 𝑂(𝑜· ℓ),
since each vertex data access requires one disk I/O operation. A recent study [35] reduced the I/O
complexity by keeping the compressed vector data of all vertices in memory. It uses compressed
data to calculate the approximate distance to the query before accessing a vertex. It skips vertices
that are unlikely to be closer to the query without reading data from disk. However, this strategy
trades accuracy for efficiency. Many disk I/Os are still needed for high accuracy. Modern storage
media have relatively high performance on latency and peak bandwidth, but they are much slower
than processors. Therefore, disk I/O operation is the main cost of the disk-based vector search
procedure.
C
PARAMETERS OF BNF
BNF has two hyper-parameters: maximum iterations 𝛽and 𝑂𝑅(𝐺) gain threshold 𝜏. They affect
the 𝑂𝑅(𝐺) of the graph layout. We evaluate their effect below. We set the maximum number of
neighbors Λ to 48 and block size 𝜂to 4 KB. The experimental dataset is BIGANN, where each vector
is 128-dimensional and one byte per value. So, each vertex takes 𝛾= (128 + 4 + 48 × 4)/1, 024 KB
(ID is unsigned integer type), and a block can hold at most 𝜀= 12 vertices. Tab. 4 shows the number
of blocks (𝜌) and the number of edges of 𝐺(|𝐸|) on different datasets. We use 64 threads for block
shuffling.
Results. Tab. 5 and 6 show the 𝑂𝑅(𝐺) and execution time results on BIGANN with different data
volumes. We can see that BNF reaches a stable 𝑂𝑅(𝐺) after a few iterations and 𝜏is always 0.01.
A smaller 𝜏gives a higher 𝑂𝑅(𝐺) but takes more time. A larger 𝜏gives a lower 𝑂𝑅(𝐺). So, we
use 𝜏= 0.01 by default in other experiments. Also, we observe that the 𝑂𝑅(𝐺) increases slowly
and the time increases sharply as 𝛽increases. 𝛽= 8 is enough to get a high 𝑂𝑅(𝐺). So, we use
𝛽= 8 by default. We note that the 𝑂𝑅(𝐺) is lower and the time is higher for a larger dataset. In
, Vol. 1, No. 1, Article . Publication date: March 2024.

---

30
Mengzhao Wang, et al.
Table 4. 𝜌and |𝐸| on BIGANN with different volumes.
BIGANN10K
BIGANN1M
BIGANN10M
BIGANN100M
𝜌
834
83,334
833,334
8,333,334
|𝐸|
48×104
48×106
48×107
48×108
Table 5. 𝑂𝑅(𝐺) of graph layout generated by BNF.
𝛽→
4
8
16
32
64
BIGANN10K
0.4763
0.4979
0.5015
0.5048
0.5056
BIGANN1M
0.3312
0.3462
0.3542
0.3587
0.3612
BIGANN10M
0.2951
0.3103
0.3183
0.3230
0.3256
BIGANN100M
0.2640
0.2792
0.2876
-
-
Table 6. Execution time (seconds) of BNF under different 𝛽.
𝛽→
4
8
16
32
64
BIGANN10K
0.0158
0.0303
0.0637
0.1393
0.2819
BIGANN1M
2.508
4.850
9.759
20.15
39.31
BIGANN10M
35.68
70.64
140.7
280.2
554.8
BIGANN100M
451.0
887.2
1760.5
-
-
1
2
3
4
5
6
7
8
Iterations
0.60
0.62
OR(G)
(a) Text2image
1
2
3
4
5
6
7
8
Iterations
10
20
Exection time(s)
(b) Text2image
1
2
3
4
5
6
7
8
Iterations
0.375
0.400
0.425
OR(G)
(c) DEEP
1
2
3
4
5
6
7
8
Iterations
20
40
60
Exection time(s)
(d) DEEP
1
2
3
4
5
6
7
8
Iterations
0.20
0.22
OR(G)
(e) SSNPP
1
2
3
4
5
6
7
8
Iterations
50
100
Exection time(s)
(f) SSNPP
1
2
3
4
5
6
7
8
Iterations
0.16
0.18
OR(G)
(g) BIGANN
1
2
3
4
5
6
7
8
Iterations
50
100
Exection time(s)
(h) BIGANN
Fig. 21. The effect of different iterations (𝛽) on 𝑂𝑅(𝐺) and execution time for a data segment on different
datasets.
vector databases, each segment has about tens of millions of vectors and BNF is efficient on a data
segment. We evaluate the 𝑂𝑅(𝐺) of graph layout on a data segment based on BNF in Appendix D.
D
BNF EVALUATION ON DATA SEGMENT
In our experiment study, we use BNF for block shuffling by default. We show the 𝑂𝑅(𝐺) and
execution time of BNF with different iterations 𝛽on a data segment in Fig. 21. We use 𝛽= 8 by
default. See Appendix C for parameters evaluation.
E
BNS ALGORITHM
Algorithm 2 shows the detailed procedure of BNS. First, we obtain the input graph layout based
on BNP or BNF. Then, for each 𝑢in 𝑉, we optimize the blocks where 𝑢’s neighbors are located by
swapping the vertices with the lowest 𝑂𝑅in these blocks. This refinement can also be repeated
iteratively like BNF (Algorithm 1), to get a better graph layout. Let 𝑜be the average out-degree. For
each vertex 𝑢in 𝑉, the number of swaps is 𝑜2. In each swap, the time complexity of computing one
block’s 𝑂𝑅is 𝑂(𝑜· 𝜀), where 𝜀is the number of vertices in a block. Therefore, the time complexity
of BNS is 𝑂(𝛽· 𝑜3 · 𝜀· |𝑉|) for 𝛽iterations, or 𝑂(𝛽· 𝑜2 · 𝜀· |𝐸|) (|𝐸| = 𝑜· |𝑉|).
, Vol. 1, No. 1, Article . Publication date: March 2024.

---

Starling: An I/O-Efficient Disk-Resident Graph Index Framework
31
Algorithm 3: Block Shuffling by BNS
Input: block-level graph layout of 𝐺= (𝑉, 𝐸) returned by BNP or BNF, number of iterations
𝛽, 𝑂𝑅(𝐺) gain threshold 𝜏
Output: new block-level graph layout of 𝐺
1 while iterations ≤𝛽do
2
forall 𝑢∈𝑉do
3
forall 𝑎,𝑒∈𝑁(𝑢) and 𝑎≠𝑒do
4
/* vertex that has minimal 𝑂𝑅in 𝐵(𝑎) */
5
𝑥←arg min𝑥∈𝐵(𝑎) 𝑂𝑅(𝑥);
6
/* vertex that has minimal 𝑂𝑅in 𝐵(𝑒) */
7
𝑦←arg min𝑦∈𝐵(𝑒) 𝑂𝑅(𝑦);
8
/* 𝑂𝑅before swapping */
9
𝑂𝑅𝑜𝑙𝑑←𝑂𝑅(𝐵(𝑎)) + 𝑂𝑅(𝐵(𝑒));
10
/* 𝑂𝑅after swapping */
11
𝑂𝑅𝑛𝑒𝑤←𝑂𝑅(𝐵(𝑎)) \ {𝑥} ∪{𝑦}) + 𝑂𝑅(𝐵(𝑒)) \ {𝑦} ∪{𝑥});
12
if 𝑂𝑅𝑜𝑙𝑑< 𝑂𝑅𝑛𝑒𝑤then
13
/* update 𝐵(𝑎) and 𝐵(𝑒) */
14
𝐵(𝑎) ←𝐵(𝑎) \ {𝑥} ∪{𝑦};
15
𝐵(𝑒) ←𝐵(𝑒) \ {𝑦} ∪{𝑥};
16
if 𝑂𝑅(𝐺) gain < 𝜏then
17
break;
18 return new layout of 𝐺
Table 7. BNF vs. BNS on BIGANN1M.
Algorithm↓
𝛽
Execution time (s) for each iteration
𝑂𝑅(𝐺)
BNF
64
0.627
0.361
BNS
6
1,877
0.401
F
BNF VS. BNS
Tab. 7 shows the block shuffling performance of BNF and BNS on BIGANN1M (which contains one
million vectors in 128 dimensions). We use 64 threads for block shuffling. The results show that
BNS achieves better 𝑂𝑅(𝐺) with fewer iterations, but it is much slower than BNF in each iteration.
This makes BNS impractical on larger datasets, unless we can speed up BNS. We leave this as future
work. In our experiments, we use BNF for block shuffling by default.
G
GRAPH PARTITIONING EVALUATION
We evaluate how three existing graph partitioning methods perform on our block shuffling task for
disk-based graph index. We summarize the three methods below.
• GP1 [16]. This method partitions 𝑉by hierarchical balanced clustering. It iteratively splits the
vertices in a large cluster into smaller clusters until each cluster has a limit number of vertices.
• GP2 [57]. This method is based on K-way greedy graph growing algorithm (KGGGP). The main
idea is a standard greedy approach for bipartitioning. It starts with two random “seed” vertices in
the two parts. Then, it adds vertices alternately to the parts, choosing the vertex that minimizes
a selected criterion.
, Vol. 1, No. 1, Article . Publication date: March 2024.

---

32
Mengzhao Wang, et al.
Table 8. GP1 vs. BNF on BIGANN10K.
Algorithm↓
𝛽
Total execution time (s)
𝑂𝑅(𝐺)
GP1
-
6.8
0.3130
BNF
64
0.2819
0.5056
Table 9. GP1 vs. BNF on BIGANN1M.
Algorithm↓
𝛽
Total execution time (s)
𝑂𝑅(𝐺)
GP1
-
192.24
0.2060
BNF
64
39.31
0.3612
Table 10. GP1 vs. BNF on SSNPP10M.
Algorithm↓
𝛽
Total execution time (s)
𝑂𝑅(𝐺)
GP1
-
234.0
0.0200
BNF
16
200.3
0.2374
Table 11. GP2 vs. BNF on DEEP10M.
Algorithm↓
𝛽
Total execution time (s)
𝑂𝑅(𝐺)
GP2
-
300.0
0.3100
BNF
64
306.8
0.4290
Table 12. GP3 vs. BNF on BIGANN10M.
Algorithm↓
𝛽
𝑂𝑅(𝐺)
GP3
4
0.2666
GP3
8
0.2801
BNF
4
0.2951
BNF
8
0.3103
Table 13. 𝑇𝑑𝑖𝑠𝑘_𝑔𝑟𝑎𝑝ℎand 𝑇𝑠ℎ𝑢𝑓𝑓𝑙𝑖𝑛𝑔on four datasets.
Dataset↓
𝑇𝑑𝑖𝑠𝑘_𝑔𝑟𝑎𝑝ℎ(s)
𝑇𝑠ℎ𝑢𝑓𝑓𝑙𝑖𝑛𝑔(s)
BIGANN
930
113
DEEP
668
59
SSNPP
1,055
130
Text2image
519
28
• GP3 [13]. This method is from prioritized restreaming algorithms for balanced graph partitioning.
It can partition graphs into balanced subsets, which is important for many distributed computing
applications. It also prioritizes the gain order of nodes.
Results. We compare the three graph partitioning methods with BNF using 64 threads to perform
all methods. Tab. 8–12 show the efficiency and effectiveness results. GP1 and GP2 are not iterative
algorithms, so they do not have 𝛽data. We implement GP3 by adding the gain order [13] to BNF,
so the time of GP3 is slower than BNF (it is at least equal to BNF). The results show that BNF
outperforms the three graph partitioning methods in time and 𝑂𝑅(𝐺) over different datasets.
Therefore, existing graph partitioning methods are not suitable for our block shuffling task. We
analyze the reasons below. Graph partitioning usually targets real-world social networks [55, 71],
which have natural clustering and power-law degree distribution [8]. But block shuffling handles
proximity graph index built on high-dimensional vectors, where the edge needs both navigation
and similarity [24, 45] and follows a uniform degree distribution [68].
H
BLOCK SHUFFLING COST
We report the disk-based graph index construction time (𝑇𝑑𝑖𝑠𝑘_𝑔𝑟𝑎𝑝ℎin §6.4) and block shuffling
time (𝑇𝑠ℎ𝑢𝑓𝑓𝑙𝑖𝑛𝑔in §6.4) in Tab. 13. From the results, we can see that 𝑇𝑠ℎ𝑢𝑓𝑓𝑙𝑖𝑛𝑔is only 3%∼12% of
𝑇𝑑𝑖𝑠𝑘_𝑔𝑟𝑎𝑝ℎ.
, Vol. 1, No. 1, Article . Publication date: March 2024.

---

Starling: An I/O-Efficient Disk-Resident Graph Index Framework
33
Table 14. Search performance and memory overhead under different 𝜇values.
Sample ratio
Recall(𝑘= 10)
QPS
Memory overhead (MB)
𝜇= 0.001
0.9916
3,914
521
𝜇= 0.01
0.9917
3,991
558
𝜇= 0.1
0.9919
4,303
918
0.90 0.92 0.94 0.96 0.98 1.00
Recall (k=10)
5000
10000
QPS
Navigation graph
Cache
(a) 𝜇= 0.001
2
4
6
Latency (ms)
0.90
0.92
0.94
0.96
0.98
1.00
Recall (k=10)
Navigation graph
Cache
(b) 𝜇= 0.001
0.90 0.92 0.94 0.96 0.98 1.00
Recall (k=10)
5000
10000
QPS
Navigation graph
Cache
(a) 𝜇= 0.01
2
4
6
Latency (ms)
0.90
0.92
0.94
0.96
0.98
1.00
Recall (k=10)
Navigation graph
Cache
(b) 𝜇= 0.01
0.90 0.92 0.94 0.96 0.98 1.00
Recall (k=10)
5000
10000
QPS
Navigation graph
Cache
(a) 𝜇= 0.1
2
4
6
Latency (ms)
0.90
0.92
0.94
0.96
0.98
1.00
Recall (k=10)
Navigation graph
Cache
(b) 𝜇= 0.1
Fig. 22. Search performance comparison under different 𝜇values for two data layouts in memory.
I
PARAMETERS OF IN-MEMORY NAVIGATION GRAPH
In in-memory navigation graph, we have parameter of sample ratio 𝜇and parameters of graph index.
For graph index parameters, we follow the current proximity graph algorithms [68] and consider
the memory limit of a segment. For example, given a sample ratio 𝜇, we adjust the maximum
number of neighbors in in-memory navigation graph to keep the memory overhead less than 2
GB on a segment. We analyze the effect of 𝜇on search performance with the same graph index
parameters below.
Results. Tab. 14 shows the search performance and memory overhead with different 𝜇values. We
can see that the Recall and QPS increase with 𝜇. This is because more data in memory may provide
better entry points that are closer to query vector. These entry points can reduce disk I/Os and
increase the chance of finding true nearest vectors. But a larger sample ratio also increases the
memory overhead. We need to balance search performance and memory overhead on a segment
due to the limited memory capacity.
J
IN-MEMORY NAVIGATION GRAPH VS. CACHING HOT VERTICES
DiskANN [35] (the baseline framework) caches some hot vertices and their neighbor IDs of disk-
based graph in memory. We evaluate the effect of in-memory navigation graph on the BIGANN10M
dataset, compared to DiskANN’s cache strategy. We implement DiskANN’s cache strategy on
Starling by replacing the in-memory navigation graph with it. We keep the sample ratio 𝜇of two
in-memory data layouts the same. We use 64 threads for the search procedure.
, Vol. 1, No. 1, Article . Publication date: March 2024.

---

34
Mengzhao Wang, et al.
Table 15. Memory overhead (MB) under different 𝜇values for two data layouts in memory.
Strategy→
Navigation graph
Cache
𝜇= 0.001
521
661
𝜇= 0.01
558
1,039
𝜇= 0.1
918
5,122
0.9
1.0
Recall (k=10)
1000
2000
QPS
= 0
= 0.1
= 0.3
= 0.4
= 0.5
(a) QPS
0.9
1.0
Recall (k=10)
100
200
Mean I/Os
(b) Mean I/Os
Fig. 23. QPS and Mean I/Os under different pruning ratios.
Efficiency and accuracy. Fig. 22 shows the QPS vs. Recall and Recall vs. Latency comparison with
different sample ratios 𝜇on BIGANN10M. We can see that the in-memory navigation graph is
always better than the cache strategy, especially when Recall is between 0.90 and 0.97. We also see
that when Recall is above 0.97, two strategies are similar. The reason is that a higher Recall needs
more disk I/Os, and the I/Os reduction with the cache data or in-memory navigation graph is small
compared to the total I/Os. So, the difference between the cache data and in-memory navigation
graph becomes insignificant.
Memory overhead. Tab. 15 shows the memory overheads of two in-memory data layouts with the
same Recall (Recall=0.99). We can see that the in-memory navigation graph has a lower memory
cost than the cache strategy of DiskANN. This is because our in-memory graph keeps a light-weight
graph index built on sample data in memory, but the cache strategy loads the vector data of vertices
and their neighbor IDs of disk-based graph (they are always larger than in-memory graph index)
into memory. We note that the memory overhead gap between navigation graph and cache strategy
is larger as the sample ratio increases.
K
PRUNING RATIO FOR BLOCK PRUNING
Fig. 23 shows how different pruning ratios 𝜎affect the search performance on BIGANN10M. We use
8 threads to execute a batch of queries. The results show that increasing 𝜎from 0 to 0.3 improves
the QPS under the same Recall. This is because a higher 𝜎allows us to check more neighbors and
reach the vertices closer to the query with a high probability. This exploits the data locality and
reduces the disk I/Os. When 𝜎= 0, we only visit the target vertex, which is equivalent to the vertex
search strategy of the baseline framework. This does not benefit from the data locality from block
shuffling, so it has the worst performance. However, when 𝜎exceeds a threshold (from 0.3 to 0.5),
the QPS under the same Recall declines. This is because a larger 𝜎causes redundant computation.
The mean I/Os decrease as 𝜎increases, because visiting more neighbors helps us find a vertex
closer to the query and reduce disk I/Os. Therefore, there is an optimal pruning ratio that we can
obtain by grid search. For example, the optimal 𝜎for the BIGANN dataset is 0.3. Tab. 18 shows the
optimal 𝜎for other datasets.
L
PARAMETERS FOR INDEX PROCESS
Please refer to the DiskANN paper [35] for details on disk-based graph index construction. We
explain the main parameters for building the index. Λ is the maximum degree of the disk-based
graph. A higher Λ leads to larger indexes and longer construction time, but also better search
accuracy. 𝐿is the size of candidate neighbors during index construction. A larger 𝐿takes more
, Vol. 1, No. 1, Article . Publication date: March 2024.

---

Starling: An I/O-Efficient Disk-Resident Graph Index Framework
35
Table 16. Parameter values of the disk-based graph used in our experiments.
Parameter↓
BIGANN
DEEP
SSNPP
Text2image
Λ
31
48
48
54
𝐿
128
128
128
128
𝐵
0.500
0.256
0.960
0.470
𝛾
0.250
0.566
0.441
0.996
𝜂
4
4
4
4
𝜀
16
7
9
4
𝜌
2,062,500
1,571,429
1,777,778
1,250,000
Table 17. Parameter values of in-memory navigation graph used in our experiments.
Parameter↓
BIGANN
DEEP
SSNPP
Text2image
Λ
20
10
48
100
𝐿
128
128
128
128
𝜇
0.09
0.10
0.10
0.09
Table 18. Pruning ratio used in our experiments.
Parameter↓
BIGANN
DEEP
SSNPP
Text2image
𝜎
0.3
0.3
0.3
1.0
200
400
0.90
0.92
0.94
0.96
0.98
1.00
Recall
(a) Recall
0
100
200
0.90
0.92
0.94
0.96
AP
(b) AP
200
400
1000
2000
QPS
(c) QPS
200
400
5
10
15
Latency (ms)
(d) Latency
200
400
100
200
300
Mean I/Os
(e) Mean I/Os
200
400
1880
1900
Memory (MB)
(f) Memory overhead
Fig. 24. Effect of candidate set size Γ on search performance
time to construct but produces indexes with higher Recall for the same search efficiency. 𝐿should
be at least as large as Λ. 𝐵is the limit on the memory footprint of PQ short codes. This determines
how much we compress the vector data to maintain in memory. A smaller 𝐵reduces the memory
overhead for the PQ short codes. Tab. 16 shows the parameter values we used in our experiments
(see §4.1 for more parameter description). In-memory navigation graph uses the same proximity
graph, but it has smaller Λ and 𝐿. Tab. 17 provides the parameter values of in-memory navigation
graph.
, Vol. 1, No. 1, Article . Publication date: March 2024.

---

36
Mengzhao Wang, et al.
Table 19. Memory overhead and search performance under different datasets.
Dataset↓
Method
Recall(𝑘= 10)
Memory overhead (MB)
QPS
BIGANN
Starling
0.9920
1,910
475
DiskANN
0.9827
1,925
340
DEEP
Starling
0.9950
1,213
504
DiskANN
0.9927
1,244
379
M
PARAMETERS FOR SEARCHING
We modify the candidate set size Γ to obtain different Recall or AP when searching. Fig. 24 shows
the effect of Γ on the BIGANN dataset. The results indicate that a larger Γ increases the accuracy but
also slows down the search and consumes more memory. This parameter applies to both in-memory
navigation graph and disk-based graph. Tab. 18 lists the pruning ratio on different datasets we used
in our experiments.
N
MEMORY COST AND SEARCH PERFORMANCE
DiskANN keeps PQ short codes, hot vertices and their neighbor IDs in memory. For Starling, we
mainly store in-memory navigation graph, PQ short codes, and the mapping of vertex IDs to block
IDs. Our evaluation in Appendix J shows that navigation graph uses less memory than caching hot
vertices and achieves better search performance. In one segment, the memory limit is 2 GB. We
adjust the memory overhead by sample ratio for both Starling and DiskANN (see Appendix I and
J). Tab. 19 shows the memory overhead for similar Recall. Starling has lower memory overhead
and higher QPS for higher Recall.
0.90 0.92 0.94 0.96 0.98 1.00
Recall
0
1000
Mean I/Os
DiskANN
Starling
SPANN (10GB)
SPANN (20GB)
SPANN (32GB)
(a) BIGANN (4GB)
0.90 0.92 0.94 0.96 0.98 1.00
Recall
0
5000
10000
Mean I/Os
Starling
DiskANN
SPANN
(b) BIGANN (8GB)
0.90 0.92 0.94 0.96 0.98 1.00
Recall
5000
10000
Mean I/Os
Starling
DiskANN
SPANN
(c) BIGANN (16GB)
Fig. 25. Mean I/Os of search on different segments and data sizes.
0.90 0.92 0.94 0.96 0.98 1.00
Recall
100
200
QPS
DiskANN
Starling
DEEP (310GB)
Fig. 26. Effect of big data.
O
RELATED WORK
Vector search algorithms. High-dimensional vector similarity search (HVSS) is a well-studied
topic, and most works aim to find an algorithm that balances efficiency and accuracy by prepro-
cessing data [68]. We can roughly categorize current algorithms into four common groups based
on how they process the data: tree-based [20, 47, 50]; quantization-based [9, 30, 36]; hashing-based
[27, 33, 43]; and graph-based [24, 25, 49]. Graph-based methods have shown to be very effective
for HVSS in many empirical studies [25, 38, 45]. However, existing graph-based algorithms require
both raw vector data and graph index to be stored in main memory. This leads to high memory
consumption and limits the scalability to hundreds of millions of vectors [16]. Starling builds
, Vol. 1, No. 1, Article . Publication date: March 2024.

---

Starling: An I/O-Efficient Disk-Resident Graph Index Framework
37
Table 20. Parameter values of SPANN in our experiments.
Parameter↓
BIGANN
DEEP
Text2image
𝜖
2
3
5
𝛼(KB)
12
48
48
𝜖1
10.0
10.0
10.0
𝜖2
8.0
8.0
8.0
a disk-based graph index and optimizes the block-level graph layout by block shuffling. It also
maintains an in-memory navigation graph based on sampled data. Thus, Starling solves the high
memory overhead problem while achieving the state-of-the-art efficiency and accuracy trade-off.
Most of the research has focused on million-scale datasets in main memory. For web-scale vector
search scenarios, existing vector search algorithms are limited by the main memory-served indexes
[35]. Current solutions include large-scale methods and distributed vector databases.
Large-scale solutions. Large-scale solutions aim to reduce memory consumption from two per-
spectives: vector quantization and hybrid storage. On one hand, FAISS [1] uses vector quantization
techniques (e.g., IVFPQ [36], OPQ [26]) to compress the vector data and store them in memory.
However, the compression introduces quantization error, which lowers the search quality. On the
other hand, some methods working on disk and heterogeneous memory (HM), such as GRIP [74],
DiskANN [35], HM-ANN [60], SPANN [16], BBAnn [29], allocate vector data or index to persistent
storage. They use some hardware-oriented optimizations to alleviate the I/O bottleneck and support
billion-scale vectors on a single machine. However, as data volume grows, it becomes harder to
scale to distributed vector database systems for system features purpose [21]. Moreover, applying
current disk-based solutions to the data segment of vector databases causes huge disk overhead
or high I/O complexity. Starling solves this problem by optimizing the data layout and search
strategy following the state-of-the-art disk-based graph index paradigm.
Vector database systems. Vector database research has gained more interest recently [29, 41, 66].
AnalyticDB-V [70], PASE [72], and VBase [76] extend relational databases to support vector data
with the one-size-fits-all strategy. However, those systems require optimization for either transaction
or analytical workloads and are not specialized for vector data management. Some purpose-built
vector data management systems, such as Vearch [41] and Milvus [29, 66], store and search large-
scale vector data efficiently by organizing data with segments for industrial applications. There
are also some distributed solutions, e.g., Pyramid [21], LANNS [23], LEQAT [75]. They focus on
data segmentation strategies or query dispatching optimizations. They assign the vectors that are
close to each other to the same segment and probe only a few segments when searching based on
the query dispatching optimizations. However, they ignore the search optimization opportunities
within the data segment of vector databases. In contrast, Starling addresses the problem of how
to search efficiently in the data segment by optimizing the data layout and search strategy.
P
MAIN PARAMETERS OF SPANN AND DISKANN
Here, we discuss the key parameters in SPANN and DiskANN.
SPANN. SPANN assigns a vector to multiple closest clusters if the distance between the vector
and these clusters is nearly the same. The closure replica parameter (𝜖) indicates the number of
replicas for each vector in the closure clustering assignment. The posting list size (𝛼) reflects the
length of each posting list (each posting list corresponds to a cluster). SPANN uses the RNG rule to
reduce the similarity of two close posting lists, and the distance coefficient 𝜖1 adjusts the RNG rule.
In the search procedure, SPANN employs the query-aware dynamic pruning technique to reduce
the number of posting lists to be searched based on the distance between the query and centroids,
where 𝜖2 is the pruning coefficient. In our experiments, we increase the maximum number of
, Vol. 1, No. 1, Article . Publication date: March 2024.

---

38
Mengzhao Wang, et al.
Table 21. Parameter values of DiskANN in our experiments.
Parameter↓
BIGANN
DEEP
SSNPP
Text2image
Λ
31
48
48
54
𝐿
128
128
128
128
𝐵
0.500
0.256
0.960
0.470
𝜋
0.06
0.07
0.12
0.10
Table 22. Index size of SPANN on 4GB BIGANN dataset.
𝜖
1
2
3
4
5
6
7
8
Index size (GB)
5.9
8.4
12
16
19
23
26
28
posting lists to be searched to obtain different recall quality. The eventual parameters used by
SPANN are provided in Tab. 20.
DiskANN. We explain the main parameters used in building the index and executing a query for
DiskANN. The parameter Λ represents the maximum degree of the disk-based graph. Increasing
Λ results in larger indexes and longer construction time, but it also improves search accuracy.
Another parameter, 𝐿, denotes the size of candidate neighbors during index construction. A larger
value of 𝐿requires more time for construction, but it produces indexes with higher Recall while
maintaining the same search efficiency. It is important to note that 𝐿should be at least as large as
Λ. The parameter 𝐵sets the limit on the memory footprint of PQ short codes. This determines the
level of compression applied to the vector data stored in memory. A smaller value of 𝐵reduces the
memory overhead for the PQ short codes. In DiskANN, certain hot vertices and their corresponding
neighbor IDs from the disk-based graph are loaded into memory. The ratio of loaded vertices is
denoted by 𝜋. The specific parameters used by DiskANN in our experimental datasets are provided
in Tab. 21. We adjust the size of the candidate set to achieve different levels of recall quality when
searching.
Q
DIFFERENT SEGMENT AND DATA SIZE SETUPS
In Fig. 25, we present an evaluation of the Mean I/Os for search operations using different segment
and data size configurations.
Varying disk capacity under the same memory space. In this experiment, we maintain a fixed
dataset size of 4GB and evaluate different segment setups while keeping the memory space at 2GB.
The disk capacities vary as 10GB, 20GB, and 32GB, respectively. Fig. 25(a) illustrates the Mean I/Os
for the BIGANN dataset. For DiskANN and Starling, we choose parameter configurations that
provide the best trade-off between Mean I/Os and Recall, resulting in an index size of less than 10GB
for the 4GB BIGANN dataset. Therefore, we only plot one Mean I/Os-Recall curve for DiskANN and
Starling each. In the case of SPANN, the Mean I/Os decreases as the disk capacity increases. This
is due to the larger disk space allowing for more duplication of boundary data points (which are
shared by multiple clusters), thereby reducing disk I/Os required to access these boundary points.
We observe that the Mean I/Os of SPANN gradually approaches that of DiskANN as the disk space
increases. However, Starling consistently maintains significantly lower disk I/Os compared to
DiskANN and SPANN. Tab. 22 presents the index size of SPANN for the 4GB BIGANN dataset at
different 𝜖values.
Varying dataset size under the same memory and disk space. In this experiment, we maintain
a fixed memory space of 2GB and disk capacity of 32GB. We evaluate different dataset sizes,
specifically 4GB, 8GB, and 16GB. Fig. 25(a) and (c) depict the search performance of different
methods on the 8GB and 16GB BIGANN datasets, respectively (refer to Fig. 25(a) for the 4GB
dataset size). We adjust the parameters of all methods to achieve the best trade-off between Mean
I/Os and Recall within the limitation of the segment space. From the results, we observe that
Starling consistently outperforms the competing methods in terms of Mean I/Os. Furthermore,
the performance gain of Starling compared to the competitors increases as the dataset size grows.
, Vol. 1, No. 1, Article . Publication date: March 2024.

---

Starling: An I/O-Efficient Disk-Resident Graph Index Framework
39
For SPANN, a larger dataset size limits its ability to duplicate data, resulting in numerous Mean
I/Os.
R
EVALUATION ON 341M DEEP DATASET
We divide the 341M DEEP dataset into 31 data segments. Each segment was configured with 2GB
of memory and 10GB of disk space. Since each query node has only 32GB of memory available,
we assign 31 segments to two query nodes. The final search results are obtained by continuously
merging candidates from each segment. Both Starling and DiskANN adopt this setting to ensure
fairness in the comparison. According to the results shown in Fig. 26, Starling achieves up to 56%
higher QPS than DiskANN in the same high recall regime, such as Recall > 0.96.
S
DISCUSSION ON DATA LOCALITY
Data locality, a coveted trait in various domains, presents a unique challenge for graph indexes
constructed on high-dimensional vectors. Relational databases naturally achieve data locality
through diverse partitioning strategies grouping relevant data into the same cluster [52, 73] and
storing them in the same disk sector. Graph engines like Pregel [48] and Ligra [63] exhibit inherent
data locality for real-world graphs (e.g., social networks [55, 71]) since their degree follows a
power-law distribution, and neighbors tend to cluster [8]. However, the nature of graph indexes
introduces a distinct scenario where neighbors exhibit similarity and navigation traits (long links),
and the degree is uniform (constant for all vertices) [68]. Hence, the neighbors of a vertex may
scatter across clusters, as reported in the HNSW paper [49], making data locality more challenging.
Received July 2023; revised October 2023; accepted November 2023
, Vol. 1, No. 1, Article . Publication date: March 2024.

---

