# Robust Attributed Graph Alignment via Joint Structure Learning and Optimal Trans

> 来源: https://arxiv.org/pdf/2301.12721

Robust Attributed Graph Alignment via Joint
Structure Learning and Optimal Transport
Jianheng Tang2†, Weiqi Zhang2, Jiajin Li3, Kangfei Zhao4, Fugee Tsung1,2, Jia Li1,2∗
1Hong Kong University of Science and Technology (Guangzhou),
2Hong Kong University of Science and Technology,
3Stanford University, 4Tencent AI Lab
{jtangbf,wzhangcd}@connect.ust.hk, jiajinli@stanford.edu, zkf1105@gmail.com, {season,jialee}@ust.hk
Abstract—Graph alignment, which aims at identifying cor-
responding entities across multiple networks, has been widely
applied in various domains. As the graphs to be aligned are usu-
ally constructed from different sources, the inconsistency issues
of structures and features between two graphs are ubiquitous
in real-world applications. Most existing methods follow the
“embed-then-cross-compare” paradigm, which computes node
embeddings in each graph and then processes node correspon-
dences based on cross-graph embedding comparison. However,
we ﬁnd these methods are unstable and sub-optimal when
structure or feature inconsistency appears. To this end, we
propose SLOTAlign, an unsupervised graph alignment frame-
work that jointly performs Structure Learning and Optimal
Transport Alignment. We convert graph alignment to an optimal
transport problem between two intra-graph matrices without the
requirement of cross-graph comparison. We further incorporate
multi-view structure learning to enhance graph representation
power and reduce the effect of structure and feature inconsistency
inherited across graphs. Moreover, an alternating scheme based
algorithm has been developed to address the joint optimization
problem in SLOTAlign, and the provable convergence result is
also established. Finally, we conduct extensive experiments on
six unsupervised graph alignment datasets and the DBP15K
knowledge graph (KG) alignment benchmark dataset. The pro-
posed SLOTAlign shows superior performance and strongest
robustness over seven unsupervised graph alignment methods
and ﬁve specialized KG alignment methods. 1
Index Terms—Graph alignment, Unsupervised learning, Struc-
ture learning, Optimal transport
I. INTRODUCTION
Graph alignment refers to the problem of identifying the
node correspondences (i.e., anchor links) across different
graphs. With graph data becoming ubiquitous in the Web
era, graph alignment establishes connections between multiple
networks and integrates them into a world-view network for
subsequent analysis and downstream applications. Thus, graph
alignment provides a comprehensive perspective for structured
data compared with mining each individual network. As a
well-established problem, graph alignment has received much
attention due to its vast applicable tasks, e.g., linking accounts
in different social network platforms [25], [26], [40], matching
entities across different knowledge graphs [34], [45], [63],
∗Corresponding author.
†Work done during an internship at Tencent AI Lab.
1Code and data are released at https://github.com/squareRoot3/SLOTAlign
[69], integrating protein-protein interactions of different species
[21], [35], merging scholar proﬁles of academic collaboration
networks [47], [67].
Graph alignment is usually treated as a supervised problem
[33], [36], [67], [68], in which a set of ground-truth node
correspondences is given. However, these correspondences
are usually unavailable and further suffer from the labor
expensiveness issue in real-world applications. Thus, unsu-
pervised graph alignment methods have attracted increasing
attention [4], [9], [14], [17], [19], [31], [72]. Also, graph
nodes are often associated with wealthy side information,
such as the user information of social network accounts
or the embedding of knowledge graph entities. These high-
dimensional node features/attributes can serve as an additional
source of knowledge in graph alignment, especially under the
unsupervised setting.
Most existing graph alignment methods rely on high-quality
and well-measured graph structures. They require that the
structure of the overlapped parts between two graphs is similar,
which is named structure consistency thereafter. However, real-
world graphs are often coupled with outliers [46] or with
missing/irrelevant edges [28], [54], [61], leading to structure
inconsistency across graphs. It is often observed that the same
entities in different networks have quite different neighbors
due to the structural noise [4], [72]. Figure 1 demonstrates an
example of graph alignment on two social network platforms.
Black dashed lines are anchor links that connect the same copies
of users across two networks. As can be seen, two circled nodes
are connected on Platform A, but their corresponding nodes
on Platform B are not connected.
Besides structure inconsistency, another largely overlooked
issue is that node features in different graphs are usually
unaligned and inconsistent. Due to various functionalities of
different networks (e.g., LinkedIn for job seeking and Twitter
for opinion sharing), the same user in different networks
commonly does not share the same features. Taking Figure 1
as an example, user information in Platform A includes the real
name, gender, and education experiences, while Platform B
contains the anonymized username, locations, posts, etc. Under
this situation, corresponding nodes across two networks are
not similar to each other and are incomparable. Likewise, in
cross-lingual knowledge graph alignment, entities in different
arXiv:2301.12721v2  [cs.DB]  20 Apr 2023

---

Platform A
Structure
Inconsistency
Username
Locations
Posts
…
Platform B
Name
Gender
Education
…
Corresponding 
Nodes
Feature
Inconsistency
?
Fig. 1. An example of graph alignment with structure and feature inconsistency.
languages are usually embedded into individual feature spaces.
Using machine translation [37], [44] can alleviate this issue,
but may bring additional noise and cost.
In previous works, a popular paradigm for unsupervised
graph alignment is the “embed-then-cross-compare” procedure
[4], [9], [14], [17], [23], [31], as shown in Figure 2(a).
As the name suggests, it ﬁrst embeds nodes in each graph
into a common feature space (e.g., using a graph neural
network), and then compares embeddings across two graphs
to obtain node correspondences. Nonetheless, we ﬁnd this
paradigm has the following limitations to deal with structure
and feature inconsistency. First, as the node embeddings are
calculated by aggregating information from the neighbors, it
may amplify noise when structure inconsistency exists. Second,
if features in two graphs are inconsistent, the corresponding
node embeddings are also typically inconsistent and can not
be compared directly [5], [14]. In knowledge graph alignment,
margin-based ranking losses [44], [45] and contrastive learning
[63] are frequently used to integrate embedding spaces across
graphs. However, without the supervision of ground-truth node
pairs, the process of embedding space integration is unstable
and unreliable.
Besides the “embed-then-cross-compare” paradigm, another
line of research is to reformulate the graph alignment problem
as ﬁnding the optimal probabilistic correspondence between
two probability measures on graphs. Speciﬁcally, Gromov-
Wasserstein (GW) distance serves as an effective tool in
modeling the correspondence problems between two graphs on
unaligned metric spaces [30], [43]. We show the procedure of
the resulting optimal transport based alignment in Figure 2(b). It
ﬁrst constructs two cost matrices Ds and Dt within each graph.
Then, it applies an optimal transport solver to ﬁnd the best
transportation plan π with minimal cost according to Ds and
Dt. The transportation plan π reveals node correspondences
across graphs.
However, previous optimal transport based methods mainly
consider the alignment between plain graphs without attributes
and rely on manually designed cost matrices (e.g., the original
graph adjacency matrix [30], [58], [60] or the heat kernel of
graph Laplacian matrix [1], [6], [27]). Thus, these methods
are potentially fragile to structure inconsistency. Moreover,
how to ﬁnd optimal cost matrices in attributed graphs for the
optimal transport based alignment has not been well explored
by existing methods. In summary, there is no satisfactory
𝓖𝑡
𝓖𝑠
Embed
Cross-Compare
𝓖𝑡
𝓖𝑠
Cost Matrix
OT Solver
𝑫𝑠
𝑫𝒕
min 𝑓(𝜋, 𝑫𝑠, 𝑫𝒕)
𝜋
𝓖𝑡
𝓖𝑠
Joint Optimization Scheme
min
𝑓(𝜋, 𝑫𝑠, 𝑫𝒕)
𝜋, 𝑫𝑠,𝑫𝒕
(a) The “Embed-Then-Cross-Compare” Alignment Paradigm 
(b) Optimal Transport Based Alignment
(c) Joint Structure Learning and Optimal Transport Alignment
𝜋
Fig. 2. Comparison between the existing graph alignment methods (top and
middle) and our proposed SLOTAlign framework (bottom).
solution for enhancing the robustness of graph alignment
against structure and feature inconsistency.
To address above issues, we propose a novel framework
for joint Structure Learning and Optimal Transport Alignment
(SLOTAlign). As shown in Figure 2(c), SLOTAlign simul-
taneously optimizes the intra-graph structure representation
(Ds,Dt) and cross-graph transportation plan π in a uniﬁed
manner, which can get rid of choosing cost matrices manually.
SLOTAlign models the multi-view structure representation
within each graph, which integrates the node-view, edge-view,
and subgraph-view to reduce the effect of noise and incon-
sistency in original graph structures. Moreover, SLOTAlign
is more robust to feature inconsistency as it only utilizes
intra-graph node relation and does not depend on cross-
graph node embedding comparison. Additionally, we show
that SLOTAlign is invariant to graph feature permutation,
which cannot be achieved by the “embed-then-cross-compare”
methods. Theoretically, we provide an alternating scheme
based algorithm to address the optimization problem arisen
from SLOTAlign, and establish the convergence result of the
proposed algorithm.
To sum up, our contributions are three-fold:
●We point out and analyze that existing attributed graph
alignment methods are susceptible to both structure and
feature inconsistency, and thus perform unstably in noisy
real-world graphs.
●A novel framework — SLOTAlign has been proposed for
joint structure learning and optimal transport alignment.
We prove the robustness guarantee of SLOTAlign against
2

---

feature permutation and develop a convergent alternating
scheme based algorithm to solve the optimization problem
in SLOTAlign.
●We conduct extensive experiments on six graph alignment
datasets and the DBP15K KG alignment benchmark dataset.
The proposed SLOTAlign shows superior performance over
seven general unsupervised graph alignment methods and
ﬁve specialized KG alignment methods. It also has strongest
robustness against multiple types of structure and feature
inconsistency.
The rest of the paper is organized as follows. Section II
introduces some preliminary knowledge about graph alignment
and Gromov-Wasserstein distance. Section III analyzes the
inconsistency issue for graph alignment. Section IV presents the
proposed unsupervised graph alignment framework SLOTAlign.
Section V reports the experimental results. Related works
and conclusion are presented in Section VI and Section VII
respectively.
II. PRELIMINARY
We denote an undirected attributed graph as G = {V,A,X},
where V = {v1,v2,⋯,vn} is the set of n nodes, A is the
adjacency matrix of the graph. Aij equals to 1 if there is an
unweighted edge between vi and vj, otherwise 0. X ∈Rn×d is
the node feature matrix. xi = X(i,∶) ∈Rd is the feature vector
of node vi.
A. Problem Statement
In this paper, we consider the problem of aligning two
attributed graphs in an unsupervised manner. We refer to
one graph as the source graph and the other as the target
graph, denoted with Gs and Gt respectively. For each node
in the source graph, graph alignment aims to identify, if
any, the corresponding node in the target graph. Moreover,
unsupervised alignment methods do not require any ground-
truth node correspondences. We formulate this problem as
follows.
Deﬁnition 1 (Unsupervised Attributed Graph Alignment).
Given two attributed graphs Gs = (Us,As,Xs) and Gt =
(Vt,At,Xt), without any observed node correspondences, the
unsupervised graph alignment algorithm returns a set of aligned
node pairs M = {(ui,vj)∣(ui,vj) ∈Us ×Vt}, where ui and vj
are corresponding nodes across two graphs.
B. Gromov-Wasserstein Distance for Alignment
Conventional optimal transport needs a ground cost C
to compare probability measures (µ,ν) and thus cannot be
used if the measures are not deﬁned on the same underlying
space [41]. To address this limitation, the Gromov-Wasserstein
(GW) distance was originally proposed in [39] for quantifying
the distance between two probability measures supported on
unaligned metric spaces. More precisely:
Deﬁnition 2 (GW Distance). Suppose that we are given
two unregistered compact metric spaces (X,dX), (Y,dY )
accompanied with Borel probability measures µ,ν respectively.
The GW distance between µ and ν is deﬁned as
inf
π∈Π(µ,ν)
x
∣dX(x,x′) −dY (y,y′)∣2dπ(x,y)dπ(x′,y′),
where Π(µ,ν) is the set of all probability measures on X × Y
with µ and ν as marginals.
Intuitively, the GW distance is trying to preserve the
isometric structure between two probability measures under
the optimal derivation. If a map pairs x →y and x′ →y′,
then the distance between x and x′ is supposed to be close
to the distance between y and y′. Notably, the GW distance
only requires modeling the topological or relational aspects
of the distributions within each domain. In view of these nice
properties, the GW distance has attracted intense research
over the last decade, especially for structured data analysis,
e.g., molecule analysis [48], [50], 3D shape matching [30],
[43], graph embedding and classiﬁcation [51], [53], generative
models [3], [59], to name a few.
To apply the GW distance on the graph alignment problem,
we consider the discrete case of Deﬁnition 2. Suppose µ is
a uniform distribution over all n nodes in the source graph
Gs and ν is a uniform distribution over all m nodes in the
target graph Gt, i.e., µ = 1
n ∑n
i=1 δui and ν = 1
m ∑m
j=1 δvj, where
δui and δvj are one-hot signals on node ui and vj. The GW
distance between µ and ν can be reformulated as:
min
π∈Π(µ,ν)
n
∑
i=1
n
∑
j=1
m
∑
k=1
m
∑
l=1
∣Ds(i,j) −Dt(k,l)∣2πikπjl,
s.t.
π1m = µ, πT 1n = ν, π ≥0,
(1)
where Ds(i,j) can be considered as the transportation cost
between ui and uj in Gs (e.g., the edge Aij), and Dt(k,l)
is the cost between vk and vl in Gt. In (1), if πik and πjl
are large which indicates (ui, vk) and (uj, vl) are likely to
be two node pairs, the difference of the corresponding intra-
graph transportation costs should be similar, i.e., ∣Ds(i,j) −
Dt(k,l)∣→0.
Accordingly, the GW distance optimization problem solves
the optimal transport π merely based on two intra-graph cost
matrices Ds and Dt. In graph alignment, πik indicates the
matching score between ui in Gs and vk in Gt, and the
alignment M can be derived from π:
M = arg max
M∈M
∑
(ui,vk)∈M
πik,
(2)
where M is the set of all legit alignments.
III. ANALYSIS OF THE INCONSISTENCY ISSUE
In this section, we discuss in-depth why structure incon-
sistency and feature inconsistency are challenging issues in
the task of unsupervised graph alignment. As we mentioned
before, a popular paradigm for solving graph alignment is
ﬁrst embedding nodes in two graphs as well as possible and
second converting it to a cross-graph computation problem
in the embedding space, i.e., an “embed-then-cross-compare”
procedure. More speciﬁcally, it ﬁrst calculates node embeddings
3

---

0
20
40
60
Structure Perturbation (%)
0
20
40
60
80
100
Alignment Accuracy (%)
0
10
20
30
40
50
60
70
Feature Permutation (%)
0
20
40
60
80
100
Alignment Accuracy (%)
WAlign
GWD
KNN
Fig. 3.
Performance comparison of three graph alignment methods under
different level of structure and feature inconsistency.
in each graph, for example, using a graph neural network. Then,
it computes a set of node pairs M based on the closeness of
node embeddings across two graphs by solving the following
embedding matching problem:
min
M∈M
∑
(ui,vj)∈M
∥zui −zvj∥,
(3)
where zui and zvj denote the embeddings of node ui in Gs
and node vj in Gt, respectively.
Nonetheless, this “embed-then-cross-compare” paradigm re-
quires that zui and zvj are in the same embedding space. When
structures and features across two graphs are inconsistent, the
corresponding node embeddings zui and zvj are also typically
unaligned and incomparable [5], [14]. Before matching node
embeddings across graphs, we need to align the embedding
spaces of two graphs, e.g., using a linear transformation Q:
min
M∈Mmin
Q
∑
(ui,vj)∈M
∥zuiQ −zvj∥.
In the unsupervised graph alignment task, as none of the
node correspondence is known, Q is difﬁcult to be calculated
directly. On the other hand, because Q is unknown, we are
unable to compare node embeddings across graphs to obtain
M. To resolve this “chicken-and-egg” paradox, the adversarial
learning framework is adopted [4], [14], [72] to generate pseudo
node correspondences or auxiliary learning signals. However,
these methods still require two embedding spaces to be partially
aligned, otherwise the stability of iterations is not guaranteed.
On another front, optimal transport based methods that use
Gromov-Wasserstein distance for graph alignment are more
resilient to feature inconsistency as they mainly consider the
intra-graph structural information. But as the price, they may
be more fragile to the inconsistency in graph structures.
To better illustrate the robustness issue of existing methods
under structure and feature inconsistency. We use the Cora
citation network [42], [62] with the ﬁrst 100 feature columns
as the source graph Gs and generate the target graph Gt by
producing different levels of inconsistency in Gs. To control
structure inconsistency, we randomly perturb p% edges in
Gt to other previous unconnected positions and keep node
features unchanged. For feature inconsistency, we ﬁx the edge
perturbation ratio to 25% and randomly permute the order of
p% feature columns in Gt.
We compare the alignment performance of WAlign [14], the
start-of-the-art unsupervised graph alignment method based
on adversarial training, with GWD [60], a GW distance
based method using graph adjacency matrices as cost matrices
for alignment, and K-Nearest Neighbor (KNN), a simple
baseline that directly matches nodes according to feature
similarity. In Figure 3, we observe that the performance of
WAlign is signiﬁcantly affected by both structure and feature
inconsistency. For example, when structure perturbation ratio
is larger than 40%, WAlign is beat by KNN. Likewise, when
feature permutation ratio is greater than 40%, the performance
of WAlign is also very close to KNN. As for GWD, it is not
inﬂuenced by any degree of feature inconsistency, but is more
vulnerable to structure inconsistency.
Due to the above robustness issues in previous methods, in
this work, we approach the graph alignment task via intra-
graph structure modeling and cross-graph optimal transport
alignment in a uniﬁed manner. We take the advantages of
both embedding-based methods and optimal transport based
methods, and show that it is more robust against structure and
feature inconsistency. We introduce the proposed approach in
the next section.
IV. METHODOLOGY
We propose a uniﬁed framework, SLOTAlign, that jointly
performs Structure Learning and Optimal Transport Alignment.
As introduced in section II, the Gromov-Wasserstein (GW)
distance is able to establish a connection between two graphs
on unaligned metric spaces. With the help of the GW distance,
the graph alignment task can be regarded as an optimal
transport problem between two intra-graph matrices without
the requirement of cross-graph comparison. However, most
existing optimal transport based methods only consider the
alignment between plain graphs and rely on a fundamental
assumption that original graph structure can be viewed as
ground-truth information for alignment. Unfortunately, such
assumption is usually violated in real-world scenarios as we
discussed in Section I and III. Although the Fused GW Distance
[48] attempts to take node attributes into consideration, the
cost matrices are still manually constructed which are fragile
to the structure and feature inconsistency in real-world graphs.
To navigate such a pitfall, we are motivated to learn an
optimal representation of the graph structure for alignment.
We design a multi-view structure representation, including the
node-view, edge-view, and subgraph-view, to model different
perspectives of the original graph. We then develop a joint
structure learning and alignment framework, which ﬁnds the
optimal structure representation and node correspondences si-
multaneously. Figure 4 illustrates the framework of SLOTAlign.
A. Multi-view Structure Modeling
Based on Equation (1), the optimization objective of the
GW distance can be rewritten by
F(π) = 1
n2
n
∑
i=1
n
∑
j=1
Ds(i,j)2 + 1
m2
m
∑
k=1
m
∑
l=1
Dt(k,l)2
−2tr(DsπDtπT ).
(4)
4

---

`
`
𝜋
෍
𝑞=1
𝐾
𝛽𝑡
(𝑞)𝑫𝑡
(𝑞)
min
𝜋∈𝐶
𝛽𝑠,𝛽𝑡∈Δ𝑘
𝐹(𝜋, 𝛽𝑠, 𝛽𝑡)
Update 𝜋
Update 𝛽𝑠, 𝛽𝑡
Multi-view Structure Modeling
Attributed Graphs
Joint Structure Learning and Alignment
෍
𝑞=1
𝐾
𝛽𝑠
(𝑞)𝑫𝑠
(𝑞)
Node Pairs ℳ
𝓖𝑡= (𝓥𝑡, 𝑨𝑡, 𝑿𝒕)
𝓖𝑠= (𝓤𝑠, 𝑨𝑠, 𝑿𝒔)
{𝑫𝑠
(𝑞)}𝑞=1
𝐾
{𝑫𝑡
(𝑞)}𝑞=1
𝐾
Update 𝜋
Fig. 4. The framework of SLOTAlign. Given two attribute graphs, it ﬁrst constructs a set of candidate structure views for each graph, and then optimizes the
integrated structure representations and node correspondences simultaneously in the joint structure learning and graph alignment framework.
Edge View
𝑫= ℎ(𝑨)
𝓖= (𝓥, 𝑨, 𝑿)
Input Graph
Node View
𝑫(𝒊, 𝒋) = 𝑑(𝐱𝒊, 𝐱𝒋)
Subgraph View 
𝑫(𝒊, 𝒋) = 𝑑(𝐳𝒊, 𝐳𝒋)
Parameter-Free GNN
𝑮𝑵𝑵(𝑨, 𝑿) = 𝒁
Structure Learning
෍
𝒒=𝟏
𝑲
𝜶(𝒒)𝑫(𝒒)
`
`
Fig. 5. The illustration of multi-view structure learning.
It is not hard to observe that the alignment quality from the
GW distance heavily depends on how to construct two intra-
graph cost matrices Ds and Dt. Instead of designing Ds and
Dt manually, we ﬁrst construct two sets of candidate graph
structure bases {D(q)
s }K
q=1 and {D(q)
t
}K
q=1 that enhance the
original structure from multiple different views. As shown in
Figure 5, we consider the following perspectives in multi-view
structure modeling:
(1) Edge-view. It models the new graph structure as a
function of the original adjacency matrix, i.e., D = h(A).
Here h ∶Rn×n →Rn×n can be any legit matrix mapping
function such as the power up operator h(A) = Ak. For
simplicity and efﬁciency in practice, we use the identity
mapping: D = h(A) = A.
(2) Node-view. It uses pairwise node feature similarity to
represent the new graph structure, i.e., D(i,j) = d(xi,xj)
where xi and xj are the feature vectors of node vi and vj,
and d can be any similarity metric such as cosine similarity.
Here we use the inner product to measure node similarity:
D(i,j) = d(xi,xj) = xT
i xj, which is equivalent to cosine
similarity after nodewise feature normalization.
Both the node-view and the edge-view consider the ﬁrst-
order relation between nodes. To model high-order interaction
on the graph, we further construct the subgraph-view:
(3) Subgraph-view. It ﬁrst integrates node features and
neighbor information in the original structure using a Graph
Neural Network (GNN), and then calculates the pairwise simi-
larity between node embeddings. However, the training process
of GNN may not be stable in unsupervised graph alignment,
as discussed in Section III. Thus, we adopt a parameter-free
GNN derived from the simpliﬁed graph convolutional network
[57]. Speciﬁcally, we remove the parameterized linear layer
and the activation function:
Z(k) = ˆ
AkX = (M −1
2 (A + I)M −1
2 )kX
(5)
where I is the identity matrix, M is the degree matrix of A+I,
and
ˆ
A = M −1
2 (A + I)M −1
2 is the symmetric normalized
adjacency matrix after adding self-loops for all nodes. After
feature propagation for k steps, the node embedding Z(k)
contains the k-hop neighborhood subgraph information of
each node. Suppose z(k)
i
is the embedding of node vi, we
also use the inner product to measure the k-order sub-graph
similarity between nodes vi and vj: D(i,j) = d(z(k)
i
,z(k)
j
) =
z(k)
i
T
z(k)
j
, k = 1,2,3,⋯.
To sum up, suppose K ≥3 is the maximum number of
candidate structure bases, SLOTAlign construct the following
bases {D(q)
s }K
q=1 for Gs:
D(1)
s
= As (edge-view),
D(2)
s
= XsXT
s (node-view),
D(q)
s
= ˆ
Aq−2
s
Xs( ˆ
Aq−2
s
Xs)T , 2 < q ≤K (subgraph-view).
(6)
For Gt, the construction process of {D(q)
t
}K
q=1 is the same.
B. Joint Structure Learning and Optimal Transport Alignment
After we construct multi-view graph structure bases
{D(q)
s }K
q=1 and {D(q)
t
}K
q=1, a natural question is how to inte-
5

---

grate these candidate bases and learn an optimal representation
of the graph structure. To this end, we model the new graph
structure Ds and Dt as a convex hull of candidate structure
bases. Speciﬁcally, we deﬁne
Ds =
K
∑
q=1
β(q)
s
D(q)
s ,
Dt =
K
∑
q=1
β(q)
t
D(q)
t
,
(7)
where βs,βt ∈∆K, i.e., ∑K
q=1 β(q)
s
= 1,β(q)
s
≥0,∀q ∈[K].
Subsequently, we target to optimize the weight vectors βs,βt
and the transportation policy π in a uniﬁed Gromov-Wasserstein
framework. More speciﬁcally, Equation (4) can be recast into
the resulting optimization problem, i.e.,
min
π∈C,βs,βt∈∆K F(π,βs,βt),
(8)
where C = {π ≥0 ∶π1m = µ,πT 1n = ν} and F(⋅,⋅) is a
bi-quadratic function, i.e.,
F(π, βs, βt) = 1
n2
n
∑
i=1
n
∑
j=1
⎛
⎝
K
∑
q=1
β(q)
s
D(q)
s (i, j)⎞
⎠
2
+ 1
m2
m
∑
k=1
m
∑
l=1
⎛
⎝
K
∑
q=1
β(q)
t
D(q)
t
(k, l)⎞
⎠
2
−2tr ⎛
⎝
⎛
⎝
K
∑
q=1
β(q)
s
D(q)
s
⎞
⎠π ⎛
⎝
K
∑
q=1
β(q)
t
D(q)
t
⎞
⎠πT ⎞
⎠.
(9)
Instead of purely ﬁnding the optimal probabilistic correspon-
dence relationship in the vanilla GW problem, the proposed
SLOTAlign is trying to learn the optimal structure represen-
tation and matching relationship simultaneously. To better
understand the proposed SLOTAlign, we can consider a simple
case — the weight vectors are vertices of the simplex, e.g.,
βs = βt = (1,0,⋯,0). Then, (8) will reduce to the vanilla
model studied in previous work [60]. As such, if we minimize
the GW objective on both βs,βt and π, the optimal solution
returned from (8) will be better than the original one.
Next, we shed light on the robustness of SLOTAlign against
feature inconsistency by a speciﬁc case — feature permutation.
Deﬁnition 3 (Permutation on graph features). Let P
∈
{0,1}d×d be any permutation matrix of order d, the feature
permutation P on a graph G = {V,A,X} is deﬁned as a
mapping of the node feature indices, i.e., P(G) = {V,A,XP }.
Feature permutation is very common in real-world cases,
which represents two graphs sharing the same feature types
but in different orders. Notably, methods based on “embed-
then-cross-compare” are unstable to feature permutation as the
feature space in Gt is changed and no more aligned with Gs.
In comparison, SLOTAlign would not be affected by feature
permutation according to the following proposition.
Proposition
4. SLOTAlign is invariant to feature per-
mutation P
on Gs
or Gt, e.g., SLOTAlign(Gs,Gt)
=
SLOTAlign(Gs,P(Gt))
Algorithm 1: SLOTAlign
Input: 1. Source graph Gs = (Us, As, Xs)
2. Target graph Gt = (Vt, At, Xt)
3. Maximum number of iterations kmax
4. Number of candidate structure bases K
5. Step size of structure learning τ
6. Step size in the Sinkhorn algorithm η
Output: Set of node correspondence pairs M
1 Initialize β(q)
s
←
1
K , β(q)
t
←
1
K (1 ≤q ≤K);
2 Initialize α1 ←[βs, βt];
3 Initialize π1
ij ←
1
nm(1 ≤i ≤n, 1 ≤j ≤m);
4 Construct candidate structure bases {D(q)
s }K
q=1 and
{D(q)
t
}K
q=1 according to Equation (6);
5 for k = 1...kmax do
6
Update αk+1 ←αk according to Equation (11);
7
Update πk+1 ←πk according to Equation (12);
8
if ∣αk+1 −αk∣< ϵ1 and ∣πk+1 −πk∣< ϵ2 then
9
Break;
10
end
11 end
12 Generate node pairs M according to Equation (2);
Assume that the structure bases of the permuted graph
P(Gt) = {V,At,XtP } are {D
(q)
t
}K
q=1, we have
D
(1)
t
= D(1)
t
,
D
(2)
t
= XtP P T XT
t = XtXT
t = D(2)
t
,
D
(q)
t
= ˆ
Aq−2
t
XtP P T XT
t ( ˆ
Aq−2
s
)T = D(q)
t
,
2 < q ≤K.
(10)
Therefore, we have {D
(q)
t
}K
q=1 = {D(q)
t
}K
q=1. As P(Gt) and
Gt have the same structure bases, the optimization problem (9)
in SLOTAlign is unchanged, and we complete the proof. The
robustness of the proposed SLOTAlign against more types of
inconsistency has been further demonstrated in the experiment
section.
C. Optimization Algorithm
In this subsection, we provide a theoretically sound opti-
mization algorithm to tackle (8). To proceed, we detect the
hidden structure of (8) at ﬁrst and further take it account
into the algorithmic development. We can observe that (8) is
a nonconvex bi-quadratic program with polytope constraints.
The basic strategy here is to optimize the weight βs,βt and the
matching matrix π in an alternating fashion. As βs and βt are
regarded as one block in our algorithm design, for simplicity,
we use α = [βs,βt] to represent the concatenation of βs and
βt, i.e., F(π,α) = F(π,βs,βt). More speciﬁcally, we adopt
the proximal alternating linearized minimization strategy [2]
here. To start with, we focus on the α update:
αk+1 = arg min
α∈Θ
{∇αF(πk,αk)T α + 1
2τ ∥α −αk∥2}
= ProjΘ (αk −τ∇αF(πk,αk)).
(11)
Here, Θ = {α ∶∑K
q=1 αq = ∑2K
q=K+1 αq = 1,αq ≥0,∀q ∈[2K]}.
Due to the separable structure over βs and βt, (11) can be
reduced to two simplex projection problems, which can be
solved efﬁciently [11].
6

---

The crux of our algorithm is the π-update. As the projection
onto the Birkhoff polytope (i.e., C) is rather computationally
demanding, we are motivated to apply the entropic regulariza-
tion to handle the π-update. Instead of the Euclidean distance
∥⋅∥2, we invoke the Kullback-Leibler divergence. As such, the
π-update is identical to the entropic optimal transport problem,
and thus we can invoke the Sinkhorn algorithm to tackle it
efﬁciently [8].
πk+1 = arg min
π∈C
{∇πF(πk,αk+1)T π + 1
η KL(π∣∣πk)},
(12)
where KL(⋅∣∣⋅) is the Kullback-Leibler divergence, i.e.,
KL(P∣∣K) def.
= ∑
i,j
Pi,j log ( Pi,j
Ki,j
) −Pi,j + Ki,j.
We illustrate the detailed initialization and iteration process
of SLOTAlign in Algorithm 1. Given two sets of intra-graph
structure bases, SLOTAlign solves the optimization problem
(8) by updating α and π alternatively via Equation (11) and
(12).
A further natural question is whether the proposed algorithm
will converge or not. We answer the question in the afﬁrmative.
Theorem 5. Suppose that 0 < τ <
1
Lα
f and 0 < ϵ < η <
1
Lπ
f ,
where Lπ
f and Lα
f are the gradient Lipschitz continuous
modulus of F(π,α) respectively. Then, any limit point of
the sequence {(πk,αk)}k≥0 converges to a critical point of
F(π,α), i.e.,
F(π,α) = F(π,α) + IC(π) + IΘ(α),
where IC(⋅) is the so-called indicator function on the set C.
Proof. As both C and Θ are bounded sets, then {(πk,αk)}
is a bounded sequence. Subsequently, we target at proving
the sufﬁcient decrease property. As F(⋅,⋅) is a bi-quadratic
function and the sequence {(πk,αk)}k≥0, F(π,α) is gradient
Lipschitz continuous with modulus Lπ
f and Lα
f . To proceed,
we revisit the α-update at ﬁrst,
αk+1 = arg min
α∈Θ
{∇αF(πk,αk)T α + 1
2τ ∥α −αk∥2}.
Since αk+1 is the optimal solution of a strongly convex problem,
we have
∇αF(πk,αk)T αk + IΘ(αk) ≥
∇αF(πk,αk)T αk+1 + IΘ(αk+1) + 1
2τ ∥αk+1 −αk∥2.
Based on the gradient Lipschitz continuous property, it is easy
to obtain,
F(πk,αk) + IΘ(αk) −F(πk,αk+1) −IΘ(αk+1)
≥( 1
2τ −
Lα
f
2 )∥αk+1 −αk∥2.
On another front, we recall the π-update:
πk+1 = arg min
π∈C
{∇πF(πk,αk+1)T π + 1
η KL(π∣∣πk)}.
Notably, KL(π∣∣πk) is 1-strongly convex on the Birkhoff
polytope constraint, i.e.,
KL(πk+1∣∣πk) ≥1
2∥πk+1 −πk∥2
F .
Similarly, we have
F(πk,αk+1) + IC(πk) −F(πk+1,αk+1) −IC(πk+1)
≥( 1
2η −
Lπ
f
2 )∥πk+1 −πk∥2
F .
To sum up, we get the desired result,
F(πk+1,αk+1) −F(πk,αk)
≤−κ1 (∥πk+1 −πk∥2
F + ∥αk+1 −αk∥2),
(13)
where κ1 = min(
Lα
f
2 −1
2τ ,
Lπ
f
2 −1
2η) > 0 if 0 < τ <
1
Lα
f and
0 < ϵ < τ <
1
Lπ
f . Summing up (13) from k = 0 to +∞, we
obtain
F(π∞,α∞) −F(π0,α0)
≤−κ1
∞
∑
k=0
(∥πk+1 −πk∥2
F + ∥αk+1 −αk∥2).
(14)
As the potential function F(⋅,⋅) is bi-quadratic and thus
coercive and {(πk,αk)}k≥0 is a bounded sequence, it means
the left-hand side is bounded, which implies
∞
∑
k=0
(∥πk+1 −πk∥2
F + ∥αk+1 −αk∥2) < +∞,
αk+1 −αk →0,πk+1 −πk →0.
Let (π∞,w∞) be a limit point of the sequence {(πk,αk)}k≥0.
Then,
there
exists
a
sequence
{nk}k≥0
such
that
{(πnk,αnk)}k≥0
converges
to
(π∞,α∞).
To
proceed,
we write down the optimality condition w.r.t (11) and (12),
0 ∈∇αF(πk,αk) + 1
τ (αk+1 −αk) + NΘ(αk),
(15)
0 ∈∇πF(πk,αk+1) + 1
η (log(πk+1) −log(πk)) + NC(πk+1),
(16)
where NC(x) is the normal cone of C at the point x. Replacing
k by nk in (15) and (16), taking limits on both sides as k →∞
0 ∈∇αF(π∞,α∞) + NΘ(α∞),
0 ∈∇πF(π∞,α∞) + NC(π∞),
we obtain the desired result.
Intuitively, the result in Theorem 5 guarantees that the
sequence {(πk,αk)} generated by SLOTAlign will converge
to a critical point of the nonconvex optimization problem (8).
7

---

D. Complexity Analysis
Suppose Gs has ns nodes, ls edges, and ds node attributes
while Gt has nt nodes, lt edges, and dt node attributes. We
ﬁrst consider the case of dense graphs. The complexity of
candidate bases construction in (6) is O(n2
sds + n2
tdt). The
cost of calculating F(π,α) in (9) is O(n2
snt +nsn2
t). The cost
of α-update in (11) and π-update in (12) is O(n2
snt + nsn2
t).
Therefore, the overall complexity is O(n2
sds + n2
tdt + n2
snt +
nsn2
t), which is the same order as other optimal transport
based alignment methods [6], [30], [48], [60].
If Gs and Gt are large-scale sparse graphs, i.e., n2
s ≫ls,
n2
t ≫lt, ns ≫ds, and nt ≫dt, SLOTAlign can take advantage
of the sparsity and low-rank properties of candidate structure
bases {D(q)
s }K
q=1 and {D(q)
t
}K
q=1 in calculating (9) and updating
α and π. In this case, SLOTAlign can be optimized to quadratic
time complexity O(nsnt(ds + dt) + nslt + ntls).
In the experiments, SLOTAlign is able to align graphs with
about 20,000 nodes efﬁciently (e.g., the DBP15K dataset). To
further scale up SLOTAlign linearly, recent divide-and-conquer
methods [15], [63] can be adopted. For example, LIME [63]
develops a bi-directional iterative graph partition strategy based
on METIS [20] to divide large-scale graph pairs into smaller
subgraph pairs, and then applies alignment methods for each
subgraph pair. It can preserve 80% links when partitioning two
graphs with millions of nodes into 75 subgraph pairs. Besides,
LargeEA [15] develops a mini-batch generation strategy to
partition large graphs into smaller mini-batches for alignment.
Therefore, SLOTAlign has great potential to be applied to
graphs with millions of nodes. As the main target of this paper
is to propose a more accurate and robust graph alignment
method, we leave the scalability issue as our future work.
V. EXPERIMENTS
In this section, we assess the effectiveness of the proposed
SLOTAlign model. We aim to answer the following questions:
●(Q1) Is SLOTAlign more robust to feature and structure
inconsistency compared with other alignment methods?
●(Q2) Does SLOTAlign outperform the state-of-the-art meth-
ods on noisy real-world graph alignment applications?
●(Q3) Does the joint structure learning and optimal trans-
port framework in SLOTAlign really beneﬁt the alignment
performance?
●(Q4) How sensitive is SLOTAlign to different hyperparame-
ters?
Our code and data are provided in the supplementary materials,
and will be publicly available upon acceptance.
A. Experimental Setup
We ﬁrst introduce the experimental settings, including
datasets, baseline methods, evaluation metrics, and implemen-
tation details.
Datasets. In Table I, we list the statistics of all datasets used
in the experiments. Four semi-synthetic datasets with different
degrees of structure and feature inconsistency are used to
evaluate the robustness of SLOTAlign and baselines. Besides,
three noisy real-world graph alignment datasets are used to
assess the overall performance of all methods. The four semi-
synthetic datasets are:
●Cora and Citeseer [42] are two citation networks in which
nodes correspond to scientiﬁc publications and edges are
citation links. Each publication node in the graph is described
by a 0/1-valued word vector indicating the absence/presence
of the corresponding word from the dictionary, i.e., the bag-
of-words feature.
●PPI [73] is a Protein-Protein Interaction network where
nodes are proteins and edges indicate the interaction between
proteins. Motif gene sets and immunological signatures are
node features.
●Facebook [24] is a social network where nodes represent
Facebook accounts and edges reﬂect relations between
accounts. Node features are extracted from user proﬁles.
For the above four datasets, we follow the experimental setup
in [5], [17]. We treat the original graph data as the source
graph Gs = {Us,As,Xs}, and perform node permutation to
generate the corresponding target graph Gt = {Vt,At,Xt}
for alignment. Speciﬁcally, we have At = P T AsP and
Xt = P T Xs. Then we generate different levels of structure
and feature inconsistency in Gs. We introduce the detailed
generation process in the next subsection.
Subsequently, we evaluate all methods on the following
noisy real-world graph alignment datasets without further
modiﬁcation:
●Douban Online-Ofﬂine. In this scenario, we align two social
network graphs, the online graph and the ofﬂine graph. In
the online graph, nodes represent users, and edges represent
the interaction between users (e.g., reply to a message) on
the website. The ofﬂine graph is constructed according to
the user’s co-occurrence in social gatherings. The location
of a user is used as node features in both graphs. The online
graph is larger and contains all the users in the ofﬂine graph.
In Douban, 1,118 users that appear in both graphs are used
as the ground truth alignments.
●ACM-DBLP. In this scenario, we align two co-author
networks ACM and DBLP, which are extracted from the
publication information in four research areas. In both
networks, nodes represent authors, and edges represent co-
author relations. Node features indicate the number of papers
that are published in different venues. There are 6,325
common authors across two networks used as the ground
truth alignments.
●DBP15K. DBP15K [44] is a widely used KG alignment
dataset. It consists of three cross-lingual entity alignment sce-
narios: DBP15KZH EN (Chinese to English), DBP15KJA EN
(Japanese to English), and DBP15KFR EN (French to English).
All three subsets are created from multi-lingual DBpedia, and
each contains 15,000 pairs of aligned entities. To preserve
the feature inconsistency between multi-lingual knowledge
graphs, we do not perform machine translation in data
preprocessing. Instead, we follow [34] and use LaBSE
[12], i.e., a multi-lingual BERT encoder, to extract 768-
8

---

0
20
40
60
80
Perturbation Ratio (%)
0
20
40
60
80
100
Hit@1 (%)
Cora
0
20
40
60
80
Perturbation Ratio (%)
0
20
40
60
80
100
Citeseer
0
20
40
60
80
Perturbation Ratio (%)
0
20
40
60
80
100
PPI
0
20
40
60
80
Perturbation Ratio (%)
0
20
40
60
80
100
Facebook
SLOTAlign
KNN
REGAL
GCNAlign
GATAlign
WAlign
GWD
FusedGW
SLOTAlign
KNN
REGAL
GCNAlign
GATAlign
WAlign
GWD
FusedGW
SLOTAlign
KNN
REGAL
GCNAlign
GATAlign
WAlign
GWD
FusedGW
SLOTAlign
KNN
REGAL
GCNAlign
GATAlign
WAlign
GWD
FusedGW
Fig. 6. Performance comparison of eight graph alignment methods under different levels of structure inconsistency.
TABLE I
DATA STATISTICS. ATTR. REPRESENTS THE NUMBER OF NODE ATTRIBUTES.
Dataset
# Nodes
# Edges
# Attr.
Description
Cora [42]
2,708
5,028
1,433
Citation Network
Citeseer [42]
3,327
4,732
3,703
Citation Network
PPI [73]
1,767
16,159
171
Protein Interaction
Facebook [24]
4,039
44,117
1,476
Social Network
Douban [65] -Online
3,906
16,328
538
Social Network
-Ofﬂine
1,118
3,022
538
Social Network
ACM-DBLP [66] -ACM
9,872
39,561
17
Co-Author Network
-DBLP
9,916
44,808
17
Co-Author Network
DBP15KZH EN [44] -ZH
19,388
70,414
768
Knowledge Graph
-EN
19,572
95,142
768
Knowledge Graph
DBP15KJA EN -JA
19,814
77,214
768
Knowledge Graph
-EN
19,780
93,484
768
Knowledge Graph
DBP15KFR EN -FR
19,661
105,998
768
Knowledge Graph
-EN
19,993
115,722
768
Knowledge Graph
dimensional node features from each entity name.
Baselines. We compare SLOTAlign with seven unsupervised
graph alignment baselines, including KNN, four methods
based on the “embed-then-cross-compare” paradigm (REGAL,
WAlign, GCNAlign, and GATAlign) and two optimal transport
based methods (GWD and FusedGW). We introduce these
baselines as follows:
●KNN. It is a simple baseline that directly matches nodes to
top-k nearest neighbors in the feature space.
●REGAL [17]. It is a fast embedding-based graph alignment
method that can be applied to graph with or without node
features.
●WAlign [14]. It is a lightweight Graph Convolutional Net-
work architecture with a Wasserstein distance discriminator
to identify candidate node correspondences. These pseudo
node correspondences are used to update network parameters
and node embeddings.
●GCNAlign [56]. It uses the Graph Convolutional Network
[22] to calculate node embeddings, and synthesizes pseudo
node correspondence pairs based on the cross-graph embed-
ding similarity. The network is trained by the margin-based
ranking loss, which makes corresponding nodes closer in the
embedding space.
●GATAlign [52]. Its architecture is similar to GCNAlign
mentioned above, but uses Graph Attention Network for
node embedding learning.
●GWD [60]. Similar to SLOTAlign, it invokes GW distance
for graph alignment. However, it merely considers the
structural information and uses the graph adjacency matrix
to represent the cost matrices.
●FusedGW [48]. It extends the GW distance to a new
framework that takes into account both structure and feature
information on graphs for the attributed graph alignment
problem.
Evaluation Metrics. We use Hit@k to evaluate the per-
formance of all graph alignment methods. It calculates the
percentage of the nodes in Vt whose ground-truth alignment
results in Vs is in the top-k candidates. We use all node
correspondences across two graphs in evaluation.
Implementation Details. For all mentioned baselines, we
run the code provided by the authors and keep the default
conﬁguration. For SLOTAlign, we set the step size in the
Sinkhorn algorithm η as 0.01 by default in all datasets. The
step size of structure learning τ is 0.1 in semi-synthetic datasets
and 1 in real-world datasets. The number of candidate structure
bases K is 2 in semi-synthetic datasets and 4 in real-world
datasets. Our model is implemented based on PyTorch and DGL
[55]. All experiments are performed on a high-performance
computing server running Ubuntu 20.04 with an AMD Ryzen9
5950X CPU and an NVIDIA GeForce RTX 3090 GPU.
B. (Q1) Alignment over Inconsistent Structures and Features
We ﬁrst evaluate the robustness of the proposed SLOTAlign
on four semi-synthetic datasets (Cora, Citeseer, PPI, and
Facebook) against different degrees of structure inconsistency.
To control the inconsistency level, we randomly perturb %p
edges in Gt to other previous unconnected positions. In this
setting, we only use the ﬁrst 100 feature columns in Cora,
Citeseer, and Facebook so that the models cannot only rely on
node features for alignment.
We show the results of all compared methods in Figure 6.
When the perturbation ratio is 0%, SLOTAlign has compara-
ble performance with other start-of-the-art graph alignment
methods. When the structure perturbation ratio p% gradually
increases from 0% to 70%, the performance of SLOTAlign
degrades more slowly than other algorithms and consistently
achieves the best in most cases. Note the maximum structure
9

---

0
20
40
60
Permutation (%)
0
20
40
60
80
100
Cora
0
20
40
60
Truncation (%)
0
20
40
60
80
100
0
20
40
60
Compression (%)
0
20
40
60
80
100
0
50
100
150
Time (s)
SLOTAlign
KNN
REGAL
GCNAlign
GATAlign
WAlign
GWD
FusedGW
0
20
40
60
Permutation (%)
0
20
40
60
80
100
Citeseer
0
20
40
60
Truncation (%)
0
20
40
60
80
100
0
20
40
60
Compression (%)
0
20
40
60
80
100
0
100
200
300
400
Time (s)
SLOTAlign
KNN
REGAL
GCNAlign
GATAlign
WAlign
GWD
FusedGW
0
20
40
60
Permutation (%)
0
20
40
60
80
100
PPI
0
20
40
60
Truncation (%)
0
20
40
60
80
100
0
20
40
60
Compression (%)
0
20
40
60
80
100
0
25
50
75
100 125
Time (s)
SLOTAlign
KNN
REGAL
GCNAlign
GATAlign
WAlign
GWD
FusedGW
0
20
40
60
Permutation (%)
0
20
40
60
80
100
Facebook
0
20
40
60
Truncation (%)
0
20
40
60
80
100
0
20
40
60
Compression (%)
0
20
40
60
80
100
0
200
400
600
800
Time (s)
SLOTAlign
KNN
REGAL
GCNAlign
GATAlign
WAlign
GWD
FusedGW
SLOTAlign
KNN
REGAL
GCNAlign
GATAlign
WAlign
GWD
FusedGW
SLOTAlign
KNN
REGAL
GCNAlign
GATAlign
WAlign
GWD
FusedGW
SLOTAlign
KNN
REGAL
GCNAlign
GATAlign
WAlign
GWD
FusedGW
SLOTAlign
KNN
REGAL
GCNAlign
GATAlign
WAlign
GWD
FusedGW
SLOTAlign
KNN
REGAL
GCNAlign
GATAlign
WAlign
GWD
FusedGW
SLOTAlign
KNN
REGAL
GCNAlign
GATAlign
WAlign
GWD
FusedGW
SLOTAlign
KNN
REGAL
GCNAlign
GATAlign
WAlign
GWD
FusedGW
SLOTAlign
KNN
REGAL
GCNAlign
GATAlign
WAlign
GWD
FusedGW
SLOTAlign
KNN
REGAL
GCNAlign
GATAlign
WAlign
GWD
FusedGW
SLOTAlign
KNN
REGAL
GCNAlign
GATAlign
WAlign
GWD
FusedGW
SLOTAlign
KNN
REGAL
GCNAlign
GATAlign
WAlign
GWD
FusedGW
SLOTAlign
KNN
REGAL
GCNAlign
GATAlign
WAlign
GWD
FusedGW
Fig. 7. Performance (Hit@1) and runtime comparisons of eight graph alignment methods under three types of feature inconsistency.
perturbation ratio in our setting is much larger compared with
previous studies [5], [14], [17]. It validates that SLOTAlign is
more resilient to structure inconsistency in graph alignment.
Subsequently, to evaluate the capability of each method in
dealing with feature inconsistency, we consider three types of
feature transformation on Gt:
●Feature Permutation. We randomly permute p% feature
columns in Gt, as deﬁned in Deﬁnition 3.
●Feature Truncation. We randomly delete p% feature columns
in Gt.
●Feature Compression: We use the Principal Component
Analysis (PCA) to compress features in Gt into a low-
dimensional representation with compression ratio p%.
These transformations can be regarded as three basic feature
inconsistency simulators in real-world applications. For ex-
ample, the Cora graph uses bag-of-words as node features
to indicate the presence of a word in the document. First,
consider that bag-of-words features in two graphs are built on
the same vocabulary set but in different orders. This unaligned
scenario can be fully characterized by the feature perturbation
simulator. Second, feature truncation simulates a scenario where
the vocabulary used in Gt is a subset of that in Gs. Third,
feature compression in this example can be interpreted as the
alignment between sparse bag-of-words features in Gs and
dense low-dimensional features in Gt.
For each transformation type, we gradually increase the
inconsistency ratio p% from 0% to 70%. We perturb 25%
edges simultaneously to ensure that the models cannot align two
graphs purely based on the structural information. We report
the experimental results of SLOTAlign and other baselines in
Figure 7 and analyze the model performance from the following
perspectives.
(1) Effect of Feature Permutation. In the ﬁrst column of
Figure 7, we observe that the feature permutation has no
inﬂuence on our proposed SLOTAlign, consistent with our
proof in Proposition 4. In comparison, other methods using
node features are signiﬁcantly affected. For example, the Hit@1
of all baselines except GWD decreases to lower than 50% on
10

---

TABLE II
EXPERIMENTAL RESULTS AND RUNTIME OF ALL COMPARED METHODS ON TWO REAL-WORLD GRAPH ALIGNMENT SCENARIOS.
Douban Online-Ofﬂine
ACM-DBLP
Model
Hit@1
Hit@5
Hit@10
Hit@30
Time(s)
Hit@1
Hit@5
Hit@10
Hit@30
Time(s)
KNN
3.31
10.38
16.64
30.05
0.9
49.25
59.46
63.42
69.61
4.5
REGAL
*30.32
*54.83
-
-
-
34.09
46.58
51.35
56.34
124.2
GCNAlign
20.93
34.44
39.62
50.72
248.3
38.43
68.46
77.64
86.89
5,821.3
GATAlign
23.70
36.94
44.01
57.16
264.5
14.21
34.07
42.12
49.00
7,298.2
WAlign
35.69
57.87
69.05
83.09
129.6
50.61
72.87
80.84
89.47
2,246.9
GWD
3.04
7.96
9.21
11.90
5.9
56.24
77.14
82.20
84.92
269.8
FusedGW
29.61
62.79
66.46
68.07
99.6
30.80
38.39
39.26
39.6
4,466.5
SLOTAlign
51.43
73.43
77.73
82.02
4.9
66.04
84.06
87.95
90.32
234.5
-w/o edge-view
2.42
10.02
16.37
32.11
4.1
30.42
48.16
53.26
58.59
224.6
-w/o node-view
36.23
56.17
60.82
65.65
4.1
0.35
1.19
1.85
4.16
228.9
-w/o subgraph-view
22.09
35.15
40.43
45.97
3.6
65.75
83.84
87.65
90.01
162.0
-ﬁxed βs and βk
3.67
12.61
18.96
31.22
4.8
26.56
46.43
54.42
64.16
187.9
-parameterized GNN
40.34
56.62
60.55
68.43
7.2
64.27
81.83
85.23
87.62
540.6
The results marked with * are obtained from [14]. The rest of the results are reproduced by running the source code.
the PPI dataset when the permutation ratio increases to 70%.
Although the structure-based approach GWD is not affected by
any type and degree of feature inconsistency, its performance
is also signiﬁcantly lower than SLOTAlign as the feature
information is not utilized.
(2) Effect of Feature Truncation and Compression. In the
second and third columns of Figure 7, the performance of
SLOTAlign keeps stable if the truncation or compression ratio
is less than 50%. Even though the ratio is greater than 50%,
SLOTAlign still outperforms the structure-based approach
GWD, which veriﬁes the robustness of SLOTAlign against
different types and levels of feature inconsistency. On the
contrary, other baselines using graph features fail to align two
graphs with any level of feature truncation or compression. As
we analyzed in Section III, these unsupervised methods are
unable to perform cross-graph node embedding comparison if
the embedding spaces of two graphs are not aligned.
(3) Efﬁciency Comparison. In the last column of Figure 7, we
compare the computational efﬁciency of each method. REGAL
has the shortest running time, but also the worst performance.
SLOTAlign, GWD, and fusedGW have comparable running
time as all of them are GW-based methods. Compared with
graph neural network based methods WAlign, GCNAlign, and
GCNAlign, SLOTAlign is more efﬁcient on all datasets.
C. (Q2) Alignment on Real-world Graphs
Next, we evaluate all methods on two noisy real-world
graph alignment datasets, namely Douban Online-Ofﬂine
and ACM-DBLP. The experimental results and runtime are
reported in Table II. Our proposed SLOTAlign achieves the
best performance in terms of the alignment accuracy on
two datasets. Speciﬁcally, SLOTAlign has 15.7% and 15.4%
absolutely improvement in Hit@1 on Douban and ACM-DBLP,
respectively, compared with the state-of-the-art unsupervised
alignment method WAlign. The performance improvement is
also very signiﬁcant compared with GW-based methods (GWD,
FusedGW), proving the superiority of SLOTAlign. Besides,
TABLE III
EVALUATION RESULTS OF ALL COMPARED KNOWLEDGE GRAPH
ALIGNMENT METHODS ON DBP15K.
DBP15KZH EN
DBP15KJA EN
DBP15KFR EN
Method
Hit@1
Hit@10
Hit@1
Hit@10
Hit@1
Hit@10
GCNAlign
43.4
76.2
42.7
76.2
41.1
77.2
LIME
87.4
-
90.9
-
97.8
-
MultiKE
50.9
57.6
39.3
48.9
63.9
71.2
EVA
75.2
89.5
73.7
89.0
73.1
90.9
SelfKG
74.5
86.6
81.6
91.3
95.7
99.2
SLOTAlign
89.0
94.4
93.0
96.5
99.2
99.8
0.1
0.2
0.5
1
2
Step Size  (×10
2)
60
70
80
90
100
Hit@1 (%)
0.2
0.5
1
2
5
Step Size 
60
70
80
90
100
3
4
5
6
7
Num of Proximity Bases
60
70
80
90
100
ACM-DBLP
Cora
DBP15KZH
EN
DBP15KFR
EN
Fig. 8. Sensitivity analysis of SLOTAlign on four datasets.
SLOTAlign is time-efﬁcient and only slower than two classic
methods, KNN and REGAL.
We also evaluate SLOTAlign on the DBP15K dataset for KG
alignment. To reduce the difﬁculty of large-scale optimization,
we initialize π1 with the node-wise feature similarity matrix
instead of the uniform distribution. We compare SLOTAlign
with two supervised methods — GCNAlign [56] and LIME [63],
and three unsupervised methods — MultiKE [64], EVA [32],
and SelfKG [34]. The experimental results are summarized in
Table III. Our proposed SLOTAlign achieves best performance
on all the metrics. It corroborates our theoretical insights that
SLOTAlign can better deal with the feature inconsistency issue
in multi-lingual KG alignment. Since SLOTAlign focuses on
the general attributed graph alignment problem, we do not
consider the additional information in KG (e.g., relation type,
entity description, and machine translation), even though they
may further boost the performance [10], [29].
11

---

D. (Q3, Q4) Analysis of SLOTAlign
Ablation Study. To validate the effectiveness of each com-
ponent in SLOTAlign, we compare it with several ablations.
After removing each of the three views in the multi-view
modeling, we obtain SLOTAlign without (w/o) edge-view, node-
view, and subgraph-view. Besides, we conduct the ablation that
does not perform structure learning, i.e., keep the weights of
candidate structure bases βs and βt ﬁxed in the optimization
process. As shown in the bottom block of Table II, SLOTAlign
consistently achieves the best performance compared with these
variants, which validates the effectiveness of the proposed multi-
view structure modeling and joint learning framework. In the
last row of Table II, we compare the parameter-free GNN
in subgraph-view with the original parameterized GNN [57]
with linear layers and the ReLU activation function. We use
the same loss in Equation (9) for GNN training. Although
the parameterized GNN may have better expressive power in
embedding-based alignment methods [34], [45], we ﬁnd that it
has inferior performance compared to the parameter-free GNN
in SLOTAlign.
Sensitivity Analysis of SLOTAlign. We investigate the sen-
sitivity of SLOTAlign to hyperparameters in Algorithm 1.
On four datasets including ACM-DBLP, Cora, DBP15KZH-EN,
and DBP15KFR-EN, we analyze the performance of SLOTAl-
ign with different step sizes of structure learning τ
∈
{0.2,0.5,1,2,5}, different step sizes in the Sinkhorn algorithm
η ∈{0.001,0.002,0.005,0.01,0.02}, and different number of
structure bases K = {3,4,5,6,7}. As shown in Figure 8, the
performance of SLOTAlign is typically robust to all these
hyperparameters. Without hyperparameter tuning, the default
conﬁguration (i.e., η = 0.01,τ = 1,K = 4) is sufﬁcient to get
competitive results on these datasets.
VI. RELATED WORK
Supervised graph alignment algorithms use a set of known
seed node pairs between graphs to infer node correspondences.
COSNET [68] uses an energy-based model to describe both
global and local consistency. In addition, many embedding-
based methods have been proposed to learn node embeddings
and then predict corresponding node pairs [33], [36], [70].
For example, CrossMNA [7] considers inter-vector and intra-
vector to combine graph and node embeddings, respectively.
[13] propose a two-stage neural architecture to learn node
embeddings and match nodes between graphs. ATTENT [71]
utilizes active learning to improve graph alignment with limited
seed pairs. BRIGHT [62] uses anchor links between seed
pairs as landmarks to construct a certain uniﬁed space for
matching by random walk. NEXTALIGN [67] reveals the
close connections between graph convolutional networks and
consistency-based alignment methods, and strikes a balance
between the alignment consistency and disparity. Most existing
knowledge graph (KG) alignment methods [12], [15], [32],
[34], [38], [44], [45], [49], [56], [63], [64] also follow the
“embed-then-cross-compare” paradigm. For example, AttrE
[49] proposes the attribute character embeddings which shifts
the entity embeddings from two KGs into the same space
for similarity calculation. LIME [63] learns the uniﬁed entity
representations using a reciprocal alignment inference strategy
to model the bi-directional entity interactions across graphs
Unsupervised graph alignment methods predict node
correspondences across graphs without the requirement of
any labeled node pairs. It has attracted increasing attention
as node pairs are usually unavailable in real-world scenarios
[14]. To solve this problem, FINAL [65] proposes the consis-
tency principle, i.e., if two pairs of nodes are similar, their
alignments should be consistent. HashAlign [16] leverages
locality sensitive hashing to help node matching based on
the node similarity obtained from graph structure and node
features. REGAL [17] jointly obtains node representations
from multiple graphs by factorizing matrix and matches the
most similar node embedding across graphs. CONE-Align [5]
proposes a proximity-preserving node embedding method to
make different graphs comparable. GRASP [18] considers the
graph alignment problem as a mapping between functions
on graphs, and the node embeddings are interpreted as the
linear combinations of eigenvectors. Kyster et al. [23] develop
an enhanced algorithm variant based on REGAL, CONE-
Align and GRASP. Karakasis et al. [19] propose to learn
the node embeddings and matches the nodes of two graphs
simultaneously. Considering the big success in various graph
mining tasks, graph neural networks are integrated in graph
alignment algorithms to acquire better node representations
[14], [31], and adversarial learning strategies are utilized to
further improve model performance [4], [9]. Besides, many
unsupervised methods have been proposed for KG alignment
[34], [37]. For example, SelfKG [34] uses the graph attention
network to aggregate entity embeddings of one-hot neighbors,
and proposes a relative similarity metric between the entities
of two KGs for self-supervised contrastive learning.
VII. CONCLUSION
In this paper, we propose SLOTAlign, the ﬁrst robust
unsupervised method tailored to tackle the structure and feature
inconsistency issues in graph alignment. Instead of following
the embed-then-cross-compare paradigm, we approach the
graph alignment task via intra-graph structure modeling and
cross-graph optimal transport alignment in a uniﬁed manner.
Then, we present a provably convergent alternating type
algorithm to address the joint optimization problem. Extensive
experiments demonstrate that SLOTAlign can outperform the
state-of-the-art graph alignment and KG alignment methods
by an up to 15% absolute improvement in Hit@1 with a
shorter running time, and is also the most robust model against
structure and feature inconsistency.
ACKNOWLEDGEMENTS
The research of Li was supported by NSFC Grant No.
62206067, Tencent AI Lab Rhino-Bird Focused Research
Program RBFR2022008 and Guangzhou-HKUST(GZ) Joint
Funding Scheme. The research of Tsung was supported by
the Hong Kong RGC General Research Funds 16216119 and
Foshan HKUST Projects FSUST20-FYTRI03B.
12

---

REFERENCES
[1] Am´elie Barbe, Marc Sebban, Paulo Gonc¸alves, Pierre Borgnat, and R´emi
Gribonval. Graph diffusion wasserstein distances. In Joint European
Conference on Machine Learning and Knowledge Discovery in Databases,
pages 577–592. Springer, 2020.
[2] J´erˆome Bolte, Shoham Sabach, and Marc Teboulle. Proximal alternat-
ing linearized minimization for nonconvex and nonsmooth problems.
Mathematical Programming, 146(1):459–494, 2014.
[3] Charlotte Bunne, David Alvarez-Melis, Andreas Krause, and Stefanie
Jegelka. Learning generative models across incomparable spaces. In
International Conference on Machine Learning, pages 851–861. PMLR,
2019.
[4] Chaoqi Chen, Weiping Xie, Tingyang Xu, Yu Rong, Wenbing Huang,
Xinghao Ding, Yue Huang, and Junzhou Huang. Unsupervised adversarial
graph alignment with graph embedding. arXiv preprint arXiv:1907.00544,
2019.
[5] Xiyuan Chen, Mark Heimann, Fatemeh Vahedian, and Danai Koutra.
Cone-align: Consistent network alignment with proximity-preserving
node embedding.
In Proceedings of the 29th ACM International
Conference on Information & Knowledge Management, pages 1985–
1988, 2020.
[6] Samir Chowdhury and Tom Needham. Generalized spectral clustering via
gromov-wasserstein learning. In International Conference on Artiﬁcial
Intelligence and Statistics, pages 712–720. PMLR, 2021.
[7] Xiaokai Chu, Xinxin Fan, Di Yao, Zhihua Zhu, Jianhui Huang, and
Jingping Bi. Cross-network embedding for multi-network alignment. In
The world wide web conference, pages 273–284, 2019.
[8] Marco Cuturi. Sinkhorn distances: Lightspeed computation of optimal
transport. Advances in neural information processing systems, 26, 2013.
[9] Tyler Derr, Hamid Karimi, Xiaorui Liu, Jiejun Xu, and Jiliang Tang.
Deep adversarial network alignment. In Proceedings of the 30th ACM
International Conference on Information & Knowledge Management,
pages 352–361, 2021.
[10] Qijie Ding, Daokun Zhang, and Jie Yin.
Conﬂict-aware pseudo
labeling via optimal transport for entity alignment.
arXiv preprint
arXiv:2209.01847, 2022.
[11] John Duchi, Shai Shalev-Shwartz, Yoram Singer, and Tushar Chandra.
Efﬁcient projections onto the l 1-ball for learning in high dimensions. In
Proceedings of the 25th international conference on Machine learning,
pages 272–279, 2008.
[12] Fangxiaoyu Feng, Yinfei Yang, Daniel Cer, Naveen Arivazhagan, and Wei
Wang. Language-agnostic bert sentence embedding. In Proceedings of the
60th Annual Meeting of the Association for Computational Linguistics,
pages 878–891, 2022.
[13] Matthias Fey, Jan E Lenssen, Christopher Morris, Jonathan Masci, and
Nils M Kriege.
Deep graph matching consensus.
In International
Conference on Learning Representations, 2019.
[14] Ji Gao, Xiao Huang, and Jundong Li. Unsupervised graph alignment
with wasserstein distance discriminator. In Proceedings of the 27th ACM
SIGKDD Conference on Knowledge Discovery & Data Mining, pages
426–435, 2021.
[15] Congcong Ge, Xiaoze Liu, Lu Chen, Yunjun Gao, and Baihua Zheng.
Largeea: aligning entities for large-scale knowledge graphs. Proceedings
of the VLDB Endowment, 15(2):237–245, 2021.
[16] Mark Heimann, Wei Lee, Shengjie Pan, Kuan-Yu Chen, and Danai Koutra.
Hashalign: Hash-based alignment of multiple graphs. In Paciﬁc-Asia
Conference on Knowledge Discovery and Data Mining, pages 726–739.
Springer, 2018.
[17] Mark Heimann, Haoming Shen, Tara Safavi, and Danai Koutra. Regal:
Representation learning-based graph alignment.
In Proceedings of
the 27th ACM international conference on information and knowledge
management, pages 117–126, 2018.
[18] Judith Hermanns, Anton Tsitsulin, Marina Munkhoeva, Alex Bronstein,
Davide Mottin, and Panagiotis Karras. Grasp: Graph alignment through
spectral signatures. arXiv preprint arXiv:2106.05729, 2021.
[19] Paris A Karakasis, Aritra Konar, and Nicholas D Sidiropoulos. Joint
graph embedding and alignment with spectral pivot. In Proceedings of
the 27th ACM SIGKDD Conference on Knowledge Discovery & Data
Mining, pages 851–859, 2021.
[20] George Karypis and Vipin Kumar. A fast and high quality multilevel
scheme for partitioning irregular graphs. SIAM Journal on scientiﬁc
Computing, 20(1):359–392, 1998.
[21] Ehsan Kazemi, Hamed Hassani, Matthias Grossglauser, and Has-
san Pezeshgi Modarres.
Proper: global protein interaction network
alignment through percolation matching. BMC bioinformatics, 17(1):1–
16, 2016.
[22] Thomas N. Kipf and Max Welling. Semi-supervised classiﬁcation with
graph convolutional networks. In ICLR, 2017.
[23] Alexander Frederiksen Kyster, Simon Daugaard Nielsen, Judith Her-
manns, Davide Mottin, and Panagiotis Karras. Boosting graph alignment
algorithms. In Proceedings of the 30th ACM International Conference
on Information & Knowledge Management, pages 3166–3170, 2021.
[24] Jure Leskovec and Julian Mcauley. Learning to discover social circles in
ego networks. Advances in neural information processing systems, 25,
2012.
[25] Chaozhuo Li, Senzhang Wang, Hao Wang, Yanbo Liang, Philip S Yu,
Zhoujun Li, and Wei Wang. Partially shared adversarial learning for
semi-supervised multi-platform user identity linkage. In Proceedings of
the 28th ACM International Conference on Information and Knowledge
Management, pages 249–258, 2019.
[26] Chaozhuo Li, Senzhang Wang, Philip S Yu, Lei Zheng, Xiaoming Zhang,
Zhoujun Li, and Yanbo Liang. Distribution distance minimization for
unsupervised user identity linkage. In Proceedings of the 27th ACM
International Conference on Information and Knowledge Management,
pages 447–456, 2018.
[27] Jia Li, Jiajin Li, Yang Liu, Jianwei Yu, Yueting Li, and Hong Cheng.
Deconvolutional networks on graph data. Advances in Neural Information
Processing Systems, 34:21019–21030, 2021.
[28] Jia Li, Mengzhou Liu, Honglei Zhang, Pengyun Wang, Yong Wen, Lujia
Pan, and Hong Cheng. Mask-gvae: Blind denoising graphs via partition.
In Proceedings of the Web Conference 2021, pages 3688–3698, 2021.
[29] Jia Li and Dandan Song. Uncertainty-aware pseudo label reﬁnery for
entity alignment. In Proceedings of the ACM Web Conference 2022,
pages 829–837, 2022.
[30] Jiajin Li, Jianheng Tang, Lemin Kong, Huikang Liu, Jia Li, Anthony Man-
Cho So, and Jose Blanchet. Fast and provably convergent algorithms for
gromov-wasserstein in graph learning. arXiv preprint arXiv:2205.08115,
2022.
[31] Zhehan Liang, Yu Rong, Chenxin Li, Yunlong Zhang, Yue Huang,
Tingyang Xu, Xinghao Ding, and Junzhou Huang. Unsupervised large-
scale social network alignment via cross network embedding.
In
Proceedings of the 30th ACM International Conference on Information
& Knowledge Management, pages 1008–1017, 2021.
[32] Fangyu Liu, Muhao Chen, Dan Roth, and Nigel Collier. Visual pivoting
for (unsupervised) entity alignment.
In Proceedings of the AAAI
Conference on Artiﬁcial Intelligence, volume 35, pages 4257–4266, 2021.
[33] Li Liu, William K Cheung, Xin Li, and Lejian Liao. Aligning users across
social networks using network embedding. In Ijcai, pages 1774–1780,
2016.
[34] Xiao Liu, Haoyun Hong, Xinghao Wang, Zeyi Chen, Evgeny Kharlamov,
Yuxiao Dong, and Jie Tang. Selfkg: Self-supervised entity alignment in
knowledge graphs. In Proceedings of the ACM Web Conference 2022,
pages 860–870, 2022.
[35] Yangwei Liu, Hu Ding, Danyang Chen, and Jinhui Xu. Novel geometric
approach for global alignment of ppi networks. In Thirty-First AAAI
Conference on Artiﬁcial Intelligence, 2017.
[36] Tong Man, Huawei Shen, Shenghua Liu, Xiaolong Jin, and Xueqi Cheng.
Predict anchor links across social networks via an embedding approach.
In Ijcai, volume 16, pages 1823–1829, 2016.
[37] Xin Mao, Wenting Wang, Yuanbin Wu, and Man Lan. From alignment
to assignment: Frustratingly simple unsupervised entity alignment. In
Proceedings of the 2021 Conference on Empirical Methods in Natural
Language Processing, 2021.
[38] Xin Mao, Wenting Wang, Huimin Xu, Yuanbin Wu, and Man Lan.
Relational reﬂection entity alignment. In Proceedings of the 29th ACM
International Conference on Information & Knowledge Management,
pages 1095–1104, 2020.
[39] Facundo M´emoli.
Gromov–wasserstein distances and the metric
approach to object matching. Foundations of computational mathematics,
11(4):417–487, 2011.
[40] Xin Mu, Feida Zhu, Ee-Peng Lim, Jing Xiao, Jianzong Wang, and Zhi-
Hua Zhou. User identity linkage by latent user space modelling. In
Proceedings of the 22nd ACM SIGKDD International Conference on
Knowledge Discovery and Data Mining, pages 1775–1784, 2016.
13

---

[41] Gabriel Peyr´e, Marco Cuturi, et al. Computational optimal transport:
With applications to data science. Foundations and Trends® in Machine
Learning, 11(5-6):355–607, 2019.
[42] Prithviraj Sen, Galileo Namata, Mustafa Bilgic, Lise Getoor, Brian
Galligher, and Tina Eliassi-Rad. Collective classiﬁcation in network data.
AI magazine, 29(3):93–93, 2008.
[43] Justin Solomon, Gabriel Peyr´e, Vladimir G Kim, and Suvrit Sra. Entropic
metric alignment for correspondence problems. ACM Transactions on
Graphics (TOG), 35(4):1–13, 2016.
[44] Zequn Sun, Wei Hu, and Chengkai Li. Cross-lingual entity alignment
via joint attribute-preserving embedding. In International Semantic Web
Conference, pages 628–644. Springer, 2017.
[45] Zequn Sun, Qingheng Zhang, Wei Hu, Chengming Wang, Muhao Chen,
Farahnaz Akrami, and Chengkai Li. A benchmarking study of embedding-
based entity alignment for knowledge graphs. Proceedings of the VLDB
Endowment, 13(12), 2020.
[46] Jianheng Tang, Jiajin Li, Ziqi Gao, and Jia Li. Rethinking graph neural
networks for anomaly detection. In International Conference on Machine
Learning, 2022.
[47] Jie Tang, Jing Zhang, Limin Yao, Juanzi Li, Li Zhang, and Zhong Su.
Arnetminer: extraction and mining of academic social networks. In
Proceedings of the 14th ACM SIGKDD international conference on
Knowledge discovery and data mining, pages 990–998, 2008.
[48] Vayer Titouan, Nicolas Courty, Romain Tavenard, and R´emi Flamary.
Optimal transport for structured data with application on graphs. In
International Conference on Machine Learning, pages 6275–6284. PMLR,
2019.
[49] Bayu Distiawan Trisedya, Jianzhong Qi, and Rui Zhang. Entity alignment
between knowledge graphs using attribute embeddings. In Proceedings
of the AAAI Conference on Artiﬁcial Intelligence, volume 33, pages
297–304, 2019.
[50] Titouan Vayer, Laetita Chapel, R´emi Flamary, Romain Tavenard, and
Nicolas Courty. Fused gromov-wasserstein distance for structured objects:
theoretical foundations and mathematical properties.
arXiv preprint
arXiv:1811.02834, 2018.
[51] Titouan Vayer, R´emi Flamary, Romain Tavenard, Laetitia Chapel, and
Nicolas Courty. Sliced gromov-wasserstein. In NeurIPS 2019-Thirty-
third Conference on Neural Information Processing Systems, volume 32,
2019.
[52] Petar Veliˇckovi´c, Guillem Cucurull, Arantxa Casanova, Adriana
Romero, Pietro Lio, and Yoshua Bengio. Graph attention networks.
arXiv:1710.10903, 2017.
[53] C´edric Vincent-Cuaz, Titouan Vayer, R´emi Flamary, Marco Corneli,
and Nicolas Courty. Online graph dictionary learning. arXiv preprint
arXiv:2102.06555, 2021.
[54] Bo Wang, Armin Pourshafeie, Marinka Zitnik, Junjie Zhu, Carlos D Bus-
tamante, Seraﬁm Batzoglou, and Jure Leskovec. Network enhancement
as a general method to denoise weighted biological networks. Nature
communications, 9(1):1–8, 2018.
[55] Minjie Wang, Da Zheng, Zihao Ye, Quan Gan, Mufei Li, Xiang Song,
Jinjing Zhou, Chao Ma, Lingfan Yu, Yu Gai, Tianjun Xiao, Tong He,
George Karypis, Jinyang Li, and Zheng Zhang. Deep graph library:
A graph-centric, highly-performant package for graph neural networks.
arXiv:1909.01315, 2019.
[56] Zhichun Wang, Qingsong Lv, Xiaohan Lan, and Yu Zhang.
Cross-
lingual knowledge graph alignment via graph convolutional networks.
In Proceedings of the 2018 conference on empirical methods in natural
language processing, pages 349–357, 2018.
[57] Felix Wu, Amauri Souza, Tianyi Zhang, Christopher Fifty, Tao Yu, and
Kilian Weinberger. Simplifying graph convolutional networks. In ICML,
pages 6861–6871, 2019.
[58] Hongteng Xu, Dixin Luo, and Lawrence Carin.
Scalable gromov-
wasserstein learning for graph partitioning and matching. Advances
in neural information processing systems, 32:3052–3062, 2019.
[59] Hongteng Xu, Dixin Luo, Lawrence Carin, and Hongyuan Zha. Learning
graphons via structured gromov-wasserstein barycenters. In Proceedings
of the AAAI Conference on Artiﬁcial Intelligence, volume 35, pages
10505–10513, 2021.
[60] Hongteng Xu, Dixin Luo, Hongyuan Zha, and Lawrence Carin Duke.
Gromov-wasserstein learning for graph matching and node embedding. In
International conference on machine learning, pages 6932–6941. PMLR,
2019.
[61] Jiarong Xu, Yang Yang, Chunping Wang, Zongtao Liu, Jing Zhang,
Lei Chen, and Jiangang Lu. Robust network enhancement from ﬂawed
networks. IEEE Transactions on Knowledge and Data Engineering,
2020.
[62] Yuchen Yan, Si Zhang, and Hanghang Tong. Bright: A bridging algorithm
for network alignment. In Proceedings of the Web Conference 2021,
pages 3907–3917, 2021.
[63] Weixin Zeng, Xiang Zhao, Xinyi Li, Jiuyang Tang, and Wei Wang. On
entity alignment at scale. The VLDB Journal, pages 1–25, 2022.
[64] Qingheng Zhang, Zequn Sun, Wei Hu, Muhao Chen, Lingbing Guo,
and Yuzhong Qu. Multi-view knowledge graph embedding for entity
alignment. In IJCAI, pages 5429–5435, 2019.
[65] Si Zhang and Hanghang Tong. Final: Fast attributed network alignment.
In Proceedings of the 22nd ACM SIGKDD International Conference on
Knowledge Discovery and Data Mining, pages 1345–1354, 2016.
[66] Si Zhang and Hanghang Tong. Attributed network alignment: Problem
deﬁnitions and fast solutions. IEEE Transactions on Knowledge and
Data Engineering, 31(9):1680–1692, 2018.
[67] Si Zhang, Hanghang Tong, Long Jin, Yinglong Xia, and Yunsong Guo.
Balancing consistency and disparity in network alignment. In Proceedings
of the 27th ACM SIGKDD Conference on Knowledge Discovery & Data
Mining, pages 2212–2222, 2021.
[68] Yutao Zhang, Jie Tang, Zhilin Yang, Jian Pei, and Philip S Yu.
Cosnet: Connecting heterogeneous social networks with local and global
consistency. In Proceedings of the 21th ACM SIGKDD international
conference on knowledge discovery and data mining, pages 1485–1494,
2015.
[69] Xiang Zhao, Weixin Zeng, Jiuyang Tang, Wei Wang, and Fabian
Suchanek. An experimental study of state-of-the-art entity alignment
approaches. IEEE Transactions on Knowledge & Data Engineering,
(01):1–1, 2020.
[70] Fan Zhou, Lei Liu, Kunpeng Zhang, Goce Trajcevski, Jin Wu, and Ting
Zhong. Deeplink: A deep learning approach for user identity linkage. In
IEEE INFOCOM 2018-IEEE Conference on Computer Communications,
pages 1313–1321. IEEE, 2018.
[71] Qinghai Zhou, Liangyue Li, Xintao Wu, Nan Cao, Lei Ying, and
Hanghang Tong.
Attent: Active attributed network alignment.
In
Proceedings of the Web Conference 2021, pages 3896–3906, 2021.
[72] Yang Zhou, Jiaxiang Ren, Ruoming Jin, Zijie Zhang, Jingyi Zheng,
Zhe Jiang, Da Yan, and Dejing Dou. Unsupervised adversarial network
alignment with reinforcement learning. ACM Transactions on Knowledge
Discovery from Data (TKDD), 16(3):1–29, 2021.
[73] Marinka Zitnik and Jure Leskovec. Predicting multicellular function
through multi-layer tissue networks. Bioinformatics, 33(14):i190–i198,
2017.
14

---

