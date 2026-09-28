# Scalable Time-Range k-Core Query on Temporal Graphs(Full Version)

> 来源: https://arxiv.org/pdf/2301.03770

arXiv:2301.03770v3  [cs.DB]  18 Mar 2023
Scalable Time-Range 푘-Core Qery on Temporal Graphs
Junyong Yang
Wuhan University
Wuhan, China
thomasyang@whu.edu.cn
Ming Zhong∗
Wuhan University
Wuhan, China
clock@whu.edu.cn
Yuanyuan Zhu
Wuhan University
Wuhan, China
yyzhu@whu.edu.cn
Tieyun Qian
Wuhan University
Wuhan, China
qty@whu.edu.cn
Mengchi Liu
South China Normal University
Guangzhou, China
liumengchi@scnu.edu.cn
Jeﬀrey Xu Yu
The Chinese University of Hong
Kong
Hong Kong, China
yu@se.cuhk.edu.hk
ABSTRACT
Querying cohesive subgraphs on temporal graphs with various
time constraints has attractedintensive research interests recently.
In this paper, we study a novel Temporal 푘-Core Query (TCQ)
problem: given a time interval, ﬁnd all distinct 푘-cores that exist
within any subintervals from a temporal graph, which general-
izes the previous historical 푘-core query. This problem is chal-
lenging because the number of subintervals increases quadrati-
cally to the span of time interval. For that, we propose a novel
Temporal Core Decomposition (TCD) algorithm that decremen-
tally induces temporal 푘-cores from the previously induced ones
and thus reduces “intra-core” redundant computationsigniﬁcantly.
Then, we introduce an intuitive concept named Tightest Time
Interval (TTI) for temporal 푘-core, and design an optimization
technique with theoretical guarantee that leverages TTI as a key
to predict which subintervals will induce duplicated푘-cores and
prunes the subintervals completely in advance, thereby eliminat-
ing “inter-core” redundant computation. The complexity of op-
timized TCD (OTCD) algorithm no longer depends on the span
of query time interval but only the scale of ﬁnal results, which
means OTCD algorithm is scalable. Moreover, we propose a com-
pact in-memory data structure named Temporal Edge List (TEL)
to implement OTCD algorithm eﬃciently in physical level with
bounded memory requirement. TEL organizes temporal edges
in a “timeline” and can be updated instantly when new edges ar-
rive, and thus our approach can also deal with dynamic temporal
graphs. We compare OTCD algorithm with the incremental his-
torical 푘-core query on several real-world temporal graphs, and
observe that OTCD algorithm outperforms it by three orders of
magnitude, even though OTCD algorithm needs none precom-
puted index.
1
INTRODUCTION
1.1
Motivation
Discovering communities or cohesive subgraphs from temporal
graphs has great values in many application scenarios, thereby
attracting intensive research interests [1, 5, 12, 19, 25, 27, 34,
∗The corresponding author.
This work is licensed under the Creative Commons BY-NC-ND 4.0 International
License. Visit https://creativecommons.org/licenses/by-nc-nd/4.0/ to view a copy
of this license. For any use beyond those covered by this license, obtain
permission by emailing info@vldb.org. Copyright is held by the owner/author(s).
Publication rights licensed to the VLDB Endowment.
Proceedings of the VLDB Endowment, Vol. 14, No. 1 ISSN 2150-8097.
doi:XX.XX/XXX.XX
v10
v1
v2
v3
v4
v5
v6
v7
v8
v9
1
1
6
6
6
6
5
5
2
2
2
2
7
7
2
6
5
5
4
3
5
5
5
5
3
2
2
8
4
1
2-core of time interval [1,8]
2-core of time interval [5,6]
2-core of time interval [2,4]
2-core of time interval [2,6]
Figure 1: A running example of temporal graph.
36] in recent years. Here, a temporal graph refers to an undi-
rected multigraph in which each edge has a timestamp to indi-
cate when it occurred, as illustrated in Figure 1. For example,
consider a graph consisting of bank accounts as vertices and
fund transfer transactions between accounts as edges with natu-
ral timestamps. For applications such as anti-money-laundering,
we would like to search communities like 푘-cores that contain
a known suspicious account and emerge within a speciﬁc time
interval like the World Cup, and investigate the associated ac-
counts.
To address the community query/search problem for a ﬁxed
time interval, the concept of historical 푘-core [36] is proposed
recently, which is the 푘-core induced from the subgraph of a
temporal graph in which all edges occurred out of the time in-
terval have been excluded and the parallel edges between each
pair of vertices have been merged. Also, the PHC-Query method
is proposed to deal with historical 푘-core query/search by using
a precomputed index eﬃciently.
However, we usually do not know the exact time interval of
targeted historical 푘-core in real-world applications. Actually, if
we can know the exact time interval, a traditional core decom-
position on the projected graph over the given time interval is
eﬃcient enough to address the problem. Thus, it is more reason-
able to assume that we can only oﬀer a ﬂexible time interval
and need to induce cores from all its subintervals. For example,
for detecting money laundering by soccer gambling during the
World Cup, the 푘-cores emerged over a few of hours around one
of the matches are more valuable than a large 푘-core emerging
over the whole month.
Therefore, we aim to generalize historical 푘-core query by al-
lowing the result 푘-cores to be induced by any subinterval of a
given time interval, like “ﬂexible versus ﬁxed”. The historical 푘-
core query can be seen as a special case of our problem that only
evaluates the whole interval. Consider the following example.

---

Junyong Yang, Ming Zhong, Yuanyuan Zhu, Tieyun Qian, Mengchi Liu, and Jeﬀrey Xu Yu
Example 1. As illustrated in Figure 1, given a time interval
[1,8], historical 푘-core query only returns the largest core marked
by the grey dashed line. In contrast, our temporal 푘-core query re-
turns four cores marked by dashed lines with diﬀerent colors. These
cores can reveal various insights unseen by the largest one. For ex-
ample, some cores like red and blue that emerge in bursty periods
may be caused by special events. Also, some persistent or periodic
cores may be found. Further, we can analyze the interaction be-
tween cores and how they evolve over time, such as the small cores
like red and blue are merged to the large cores like yellow. Lastly,
some underlying details may be found. During the merge, the ver-
tex 푣5 may play a vital role because it appears in all the cores.
Overall, our general and ﬂexible query model can support many
interesting temporal community analytics applications.
The general and ﬂexible temporal k-core query we study is
naturally a generalization of existing query models like histori-
cal 푘-core and also potentially a common technique for various
temporal graph mining tasks mentioned in the above example.
1.2
Contribution
In this paper, we study a novel temporal 푘-core query problem:
given a time interval, ﬁnd all distinct 푘-cores that exist within
any subintervals from a temporal graph. Although the existing
PHC-Query returns the historical 푘-core of a ﬁxed time inter-
val eﬃciently, it cannot be trivially applied to deal with the new
problem. Because inducing 푘-cores for each subinterval individ-
ually from scratch is not scalable, since the number of subinter-
vals increases quadratically with the span of time interval. More-
over, PHC-Query suﬀers from two other intrinsic shortcomings.
Firstly, it relies on a PHC-Index that precomputes the coreness
of all vertices over all time intervals, thereby incurring heavy of-
ﬂine time and space overheads. Secondly, due to its sophisticated
construction, it is unclear if PHC-Index can be updated dynami-
cally. It is against the dynamic nature of temporal graphs.
In order to overcome the above challenges, we present a novel
temporal core decomposition algorithm and auxiliary optimiza-
tion and implementation techniques. Our contributions can be
summarized as follows.
• We formalize a general time-range cohesive subgraph query
problem on ubiquitous temporal graphs, namely, tempo-
ral푘-core query. Many previous typical푘-core query mod-
els on temporal graphs can be equivalently represented
by temporal 푘-core query with particular constraints.
• To address temporal 푘-core query, we propose a simple
and yet eﬃcient algorithm framework based on a novel
temporal core decomposition operation. By using tempo-
ral core decomposition, our algorithm always decremen-
tally induces a temporal k-core from the previous induced
temporal k-core except the initial one, thereby reducing
redundant computation signiﬁcantly.
• Moreover, we propose an intuitive concept named tight-
est time interval for temporal k-core. According to the
properties of tightest time intervals, we design three prun-
ing rules with theoretical guarantee to directly skip subin-
tervals that will not induce distinct temporal 푘-core. As
a result, the optimized algorithm is scalable in terms of
the span of query time interval, since only the necessary
subintervals are enumerated.
• For physical implementation of our algorithm, we pro-
pose a both space and time eﬃcient data structure named
temporal edge list to represent a temporal graph in mem-
ory. It can be manipulated to perform temporal core de-
composition and tightest time interval based pruning rapidly
with bounded memory. More importantly, temporal edge
list can be incrementally updated with evolving temporal
graphs, so that our approach can support dynamic graph
applications naturally.
• Lastly, we evaluate the eﬃciency and eﬀectiveness of our
algorithm on real-world datasets. The experimental re-
sults demonstrate that our algorithm outperforms the im-
proved PHC-Query by three orders of magnitude.
The rest of this paper is organized as follows. Section 2 for-
mally introduces the data model and query model, and also gives
a baseline algorithm. Sections 3-5 present our algorithm, opti-
mization and implementation techniques respectively. Section
6 brieﬂy discusses some meaningful extension of our approach.
Section 7 presents the experiments and analyzes the results. Sec-
tion 8 investigates the related work. Section 9 concludes our
work.
2
PRELIMINARY
In this section, we propose a generalized 푘-core query problem
on temporal graphs, which facilitates various temporal commu-
nity query/search demands. The previous historical푘-core query [36]
can be seen as a special case of the proposed problem. Speciﬁ-
cally, we introduce the data model and query model of the pro-
posedproblem in Section 2.1 and 2.2 respectively, and then present
a nontrivial baseline that addresses the proposed problem based
on the existing PHC-Query.
2.1
Data Model
A temporal graph is normally an undirected graph G = (V, E)
with parallel temporal edges. Each temporal edge (푢,푣,푡) ∈E is
associated with a timestamp 푡that indicates when the interac-
tion happened between the vertices 푢,푣∈V. For example, the
temporal edges could be transfer transactions between bank ac-
counts in a ﬁnance graph. Without a loss of generality, we use
continuous integers that start from 1 to denote timestamps. Fig-
ure 1 illustrates a temporal graph as our running example.
There are two useful concepts derived from the temporal graph.
Given a time interval [푡푠,푡푒], we deﬁne the projected graph of G
over [푡푠,푡푒] as G[푡푠,푡푒] = (V[푡푠,푡푒], E[푡푠,푡푒]), where V[푡푠,푡푒] =
V and E[푡푠,푡푒] = {(푢,푣,푡)|(푢,푣,푡) ∈E, 푡∈[푡푠,푡푒]}. Moreover,
we deﬁne the detemporalized graph of G[푡푠,푡푒] as a simple graph
퐺[푡푠,푡푒] = (푉[푡푠,푡푒], 퐸[푡푠,푡푒]), where 푉[푡푠,푡푒]=V[푡푠,푡푒] and 퐸[푡푠,푡푒]
= {(푢,푣)|(푢,푣,푡) ∈E[푡푠,푡푒] }.
2.2
Query Model
For revealing communities in graphs, the 푘-core query is widely
adopted. Given an undirected graph 퐺and an integer 푘, 푘-core
is the maximal induced subgraph of 퐺in which all vertices have
degrees at least 푘, which is denoted by C푘(퐺). The coreness of
a vertex 푣in a graph 퐺is the largest value of 푘such that 푣∈
C푘(퐺).
For temporal graphs, the Historical 푘-Core Query (HCQ) [36]
is proposed recently. It aims to ﬁnd a 푘-core that appears during
a speciﬁc time interval. Formally, a historical 푘-core H푘
[푡푠,푡푒] (G)
is a 푘-core in the detemporalized projected graph 퐺[푡푠,푡푒] of G.
Thus, HCQ can be deﬁned as follows.

---

Scalable Time-Range 푘-Core Qery on Temporal Graphs
Definition 1 (Historical 푘-Core Qery). For a temporal
graph G, given an integer 푘and a time interval [푡푠,푡푒], return
H푘
[푡푠,푡푒] (G) = C푘(퐺[푡푠,푡푒]).
In this paper, we propose a novel query model called Tempo-
ral 푘-Core Query (TCQ) that generalizes HCQ. The main diﬀer-
ence is that the query time interval [푇푠,푇푒] of TCQ is a range
but not ﬁxed query condition like [푡푠,푡푒] of HCQ. In TCQ,푇푠and
푇푒are the minimum start time and maximum end time of query
time interval respectively, and thereby the 푘-cores induced by
each subinterval [푡푠,푡푒] ⊆[푇푠,푇푒] are all potential results of
TCQ. Moreover, TCQ directly returns the maximal induced sub-
graphs of G in which all vertices have degrees (note that, the
number of neighbor vertices but not neighbor edges) at least 푘
as results. We call these subgraphs as temporal 푘-cores and de-
note by T 푘
[푡푠,푡푒] (G) a temporal 푘-core that appears over [푡푠,푡푒]
on G. Obviously, a historical 푘-core H푘
[푡푠,푡푒] (G) is the detempo-
ralized temporal 푘-core T 푘
[푡푠,푡푒] (G). Therefore, TCQ can be seen
as a group of HCQ and HCQ can be seen as a special case of
TCQ.
The formal deﬁnition of TCQ is as follows.
Definition 2 (Temporal푘-Core Qery). For a temporalgraph
G, given an integer 푘and a time interval [푇푠,푇푒], return all dis-
tinct T 푘
[푡푠,푡푒] (G) with [푡푠,푡푒] ⊆[푇푠,푇푒].
Note that, TCQ only returns the distinct temporal 푘-cores
that are not identical to each other, since multiple subintervals
of [푇푠,푇푒] may induce an identical subgraph of G. For brevity,
T 푘
[푡푠,푡푒] (G) is abbreviated as T 푘
[푡푠,푡푒] if the context is self-evident.
2.3
Baseline Algorithm
A straightforward solution to TCQ is to enumerate each subin-
terval [푡푠,푡푒] ⊆[푇푠,푇푒] and induce T 푘
[푡푠,푡푒] respectively, which
takes 푂(|푇푒−푇푠|2|E|) time. However, the span of query time in-
terval (namely,푇푒−푇푠) can be extremely large in practice, which
results in enormous time consumption for inducing all temporal
푘-cores from scratch independently. Therefore, we start from a
non-trivial baseline based on the existing PHC-Query.
2.3.1
A Short Review of PHC-Qery. PHC-Query relies on a heavy-
weight index called PHC-Index that essentially precomputes the
coreness of all vertices in the projected graphs over all possible
time intervals. The index is logically a table that stores a set of
timestamp pairs for each vertex 푣∈V (column) and each rea-
sonable coreness 푘(row). Given a value of 푘, the coreness of a
vertex 푣is exactly 푘in the projected graph over [푡푠,푡푒] for each
timestamp pair 푡푠and 푡푒in the cell (푘, 푣). In particular, due to
the monotonicity of coreness of a vertex with respect to 푡푒when
푡푠is ﬁxed, PHC-Index can reduce its space cost signiﬁcantly by
only storing the necessary but not all possible timestamp pairs.
Speciﬁcally, for a vertex 푣, a coreness 푘and a start time 푡푠, only a
discrete set of core time need to be recorded, since the coreness
of the vertex over [푡푠,푡푒] will not change with the increase of
푡푒until 푡푒is a core time. Consequently, given an HCQ instance,
PHC-Query leverages PHC-Index to directly determine whether
a vertex has the coreness no less than the required 푘, by compar-
ing the query time interval with the retrieved timestamp pairs,
and then induces historical 푘-cores with qualiﬁed vertices.
2.3.2
Incremental PHC-Qery Algorithm. The main idea of our
baseline algorithm is to induce temporal 푘-cores incrementally,
Algorithm 1: Baseline iPHC-Query algorithm.
Input: G, 푘, 푇푠, 푇푒
Output: all distinct T 푘
[푡푠,푡푒] (G) with [푡푠,푡푒] ⊆[푇푠,푇푒]
1 for 푡푠←푇푠to 푇푒do
2
V ←∅, E ←∅, H푣←∅, H푒←∅
3
for 푘and 푡푠, retrieve the core time of each vertex in
G from PHC-Index and push them into H푣
4
push the temporal edges with timestamps in [푡푠,푇푒]
in G into H푒
5
for 푡푒←푡푠to 푇푒do
6
pop a vertex from H푣and add it to V, until the
min core time of H푣exceeds 푡푒
7
pop an edge from H푒and add it to E if both
vertices linked by this edge are in V, until the
min timestamp of H푒exceeds 푡푒
8
push all edges that have been popped from H푒
and are not added to E back to H푒
9
collect T 푘
[푡푠,푡푒] = (V, E) if it is neither empty nor
identical to other existing results
thereby reducing redundant computation. With a temporal 푘-
core T 푘
[푡푠,푡푒], we induce T 푘
[푡푠,푡푒+1] simply by appending new ver-
tices to T 푘
[푡푠,푡푒], whose coreness has become no less than푘due to
the expand of time interval. Those vertices can be directly iden-
tiﬁed by using core time retrieved from PHC-Index since 푡푠is
ﬁxed. The correctness of baseline algorithm is guaranteed while
the correctness of PHC-Query holds.
The pseudo code of incremental PHC-Query (iPHC-Query) al-
gorithm is presented in Algorithm 1. It enumerates all subinter-
vals of a given [푇푠,푇푒] in a particular order for fulﬁlling eﬃcient
incremental temporal 푘-core induction. Speciﬁcally, it anchors
the value of 푡푠(line 1), and increases the value of 푡푒from 푡푠to
푇푒(line 5), so that T 푘
[푡푠,푡푒+1] can always be incrementally gen-
erated from an existing T 푘
[푡푠,푡푒]. For each 푡푠anchored and the
input 푘, the algorithm ﬁrstly retrieves the core time of all ver-
tices from PHC-Index, and pushes the vertices into a minimum
heap H푣ordered by their core time (line 3). Moreover, all tem-
poral edges with timestamps in [푡푠,푇푒] are pushed into another
minimum heap H푒ordered by their timestamp (line 4). Then, the
algorithm maintains a vertex set V and an edge set E, which rep-
resent the vertices and edges of T 푘
[푡푠,푡푒] respectively, whenever
푡푒is increased by the following steps. It pops remaining vertices
with core time no greater than 푡푒from H푣and adds them to V
(line 6), since the corenesss of these vertices are no less than
푘according to PHC-Index. Also, it pops remaining edges with
timestamp no greater than 푡푒from H푒and adds them to E if
both vertices linked by the edges are in V (line 7). Then, it puts
back the popped edges that are not in E into H푒(line 8), because
they could still be contained by other temporal 푘-cores induced
later. Lastly, a temporal푘-core comprised of V and E that are not
empty is collected if it has not been induced before (line 9).
The complexity of baseline mainly depends on the mainte-
nance of both V and E. For the maintenance of V, each ver-
tex in T 푘
[푡푠,푇푒]is added to V from H푣at most once in the inner
loop (lines 5-9), which takes logarithmic time for a heap. There-
fore, the total cost is bounded by Í푇푒
푡=푇푠|V[푡,푇푒]| log |V[푡,푇푒]|.
The case is more complicated for the maintenance of E, since

---

Junyong Yang, Ming Zhong, Yuanyuan Zhu, Tieyun Qian, Mengchi Liu, and Jeﬀrey Xu Yu
each edge with a timestamp within [푡,푇푒] is likely to be trans-
ferred between H푒and E (lines 7-8), until both its endpoints are
contained by V. In the worst case, the total cost is bounded by
Í푇푒
푡=푇푠|푇푒−푡||E[푡,푇푒]| log |E[푡,푇푒]|. While, the real cost in prac-
tice can be much lower since the |푇푒−푡| part should be a more
reasonable value.
Although the baseline algorithm can achieve incremental in-
duction of temporal k-core for each start time, PHC-Index incurs
a huge amount of extra space and time overheads. Moreover, its
incremental induction only oﬀers a kind of “intra-core” optimiza-
tion that reduces the redundant computation in each temporal
푘-core induction, and lacks of a kind of “inter-core” optimization
that can directly avoids inducing some temporal 푘-cores. In the
following sections, we ﬁrst propose a novel algorithm that can
outperform baseline algorithm without any precomputation and
index, and then optimize it signiﬁcantly to further improve the
eﬃciency by at least three orders of magnitude.
3
ALGORITHM
In this section, we propose a novel eﬃcient algorithm to address
TCQ. Our algorithm leverages a fundamental operation called
temporal core decomposition to induce T 푘
[푡푠,푡푒] from T 푘
[푡푠,푡푒+1] decre-
mentally. More importantly, our algorithm does not require any
precomputation and index space, and can still outperform the
baseline algorithm. Next, Section 3.1 introduces the temporal
core decomposition operation, and Section 3.2 presents our al-
gorithm.
3.1
Temporal Core Decomposition (TCD)
Firstly, we introduce Temporal Core Decomposition (TCD) as
a basic operation on temporal graphs, which is derived from
the traditional core decomposition [2] on ordinary graphs. TCD
refers to a two-step operation of inducing a temporal 푘-core
T 푘
[푡푠,푡푒] of a given time interval [푡푠,푡푒] from a given temporal
graph G. The ﬁrst step is truncation: remove temporal edges with
timestamps not in [푡푠,푡푒] from G, namely, induce the projected
graph G[푡푠,푡푒]. The second step is decomposition: iteratively peel
vertices with degree (the number of neighbor vertices but not
neighbor edges) less than 푘and the edges linked to them to-
gether. The correctness of TCD is as intuitive as core decom-
position.
An excellent property of TCD operation is that, it can induce
a temporal푘-core T 푘
[푡푠,푡푒] from another temporal푘-core T 푘
[푡푠′,푡푒′]
with [푡푠,푡푒] ⊂[푡푠′,푡푒′], so that we can develop a decremental al-
gorithm based on TCD operation to achieve eﬃcient processing
of TCQ. To prove the correctness of this property, let us consider
the following Theorem 1.
Lemma 1. Given time intervals [푡푠,푡푒] and [푡푠′,푡푒′] such that
[푡푠,푡푒] ⊂[푡푠′,푡푒′], we have T 푘
[푡푠,푡푒] is a subgraph of T 푘
[푡푠′,푡푒′].
Proof. For each vertex in T 푘
[푡푠,푡푒], its coreness in G[푡푠′,푡푒′] is
certainly no less than in G[푡푠,푡푒] (namely, ⩾푘), because G[푡푠,푡푒]
is a subgraph of G[푡푠′,푡푒′]. Thus, all vertices in T 푘
[푡푠,푡푒] will be
contained by T 푘
[푡푠′,푡푒′] that is a temporal 푘-core of G[푡푠′,푡푒′].
□
Theorem 1. Given a time interval [푡푠, 푡푒] and a temporal 푘-
core T 푘
[푡푠′,푡푒′] with [푡푠,푡푒] ⊂[푡푠′,푡푒′], the subgraph induced by
using TCD operation from T 푘
[푡푠′,푡푒′] for [푡푠,푡푒] is T 푘
[푡푠,푡푒].
v3
v4
v5
v6
v7
v8
6
6
6
6
5
5
2
2
2
6
5
5
5
5
5
5
3
2
4
v3
v4
v5
v6
6
6
6
6
5
5
6
5
5
5
5
5
5
v7
v8
v3
v4
v5
v6
6
6
6
6
5
5
5
5
5
5
truncation
decomposition
Figure 2: Temporal core decomposition from T 2
[2,6] to
T 2
[5,6].
Proof. Firstly, we prove for any temporal graph G′ satisfy-
ing that T 푘
[푡푠,푡푒] is a subgraph of G′ and G′ is a subgraph of
G, we can induce T 푘
[푡푠,푡푒] from G′ by using TCD operation. For
each vertex in T 푘
[푡푠,푡푒], its coreness is not less than 푘in G′ over
[푡푠,푡푒], because this temporal 푘-core is a subgraph of G′. Mean-
while, for each vertex in G′ but not in T 푘
[푡푠,푡푒], its coreness in G′
is not greater than in G, because G′ is a subgraph of G. Thus,
its coreness in G′ over [푡푠,푡푒] is less than 푘, because it is not
in the temporal 푘-core T 푘
[푡푠,푡푒] of G. As a result, T 푘
[푡푠,푡푒] is also
a temporal 푘-core of G′, and thereby can be induced by using
TCD operation from G′.
Then, consider two temporal 푘-cores T 푘
[푡푠,푡푒] and T 푘
[푡푠′,푡푒′] with
[푡푠,푡푒] ⊆[푡푠′,푡푒′]. Due to Lemma 1, we have T 푘
[푡푠,푡푒] is a sub-
graph of T 푘
[푡푠′,푡푒′]. Let G′
[푡푠,푡푒] be the temporal graph induced by
the ﬁrst step of TCD from T 푘
[푡푠′,푡푒′], which is certainly a subgraph
of T 푘
[푡푠′,푡푒′]. Since G′
[푡푠,푡푒] only removes the temporal edges not
in [푡푠,푡푒], which means these edges are not contained by T 푘
[푡푠,푡푒],
it is obviously T 푘
[푡푠,푡푒] is a subgraph of G′
[푡푠,푡푒]. Thus, the correct-
ness of this theorem holds.
□
For example, Figure 2 illustrates the procedure of TCD from
T 2
[2,6] to T 2
[5,6] on our running example graph in Figure 1. The
edges with timestamps not in [5, 6] (marked by dashed lines)
are ﬁrstly removed from T 2
[2,6] by truncation, which results in
the decrease of degrees of vertices 푣5, 푣7 and 푣8. Then, the ver-
tices with degree less than 2 (marked by dark circles), namely, 푣7
and 푣8 are further peeled by decomposition, together with their
edges. The remaining temporal graph is T 2
[5,6].
3.2
TCD Algorithm
We propose a TCD algorithm to address TCQ by using temporal
core decomposition. In general, given a TCQ instance, the TCD
algorithm enumerates each subinterval of [푇푠,푇푒] in a particu-
lar order, so that the temporal 푘-cores of each subinterval are in-
duced decrementally from previously induced temporal 푘-cores
except the initial one.
Speciﬁcally, we enumerate a subinterval [푡푠,푡푒] of [푇푠,푇푒] as
follows. Initially, let 푡푠= 푇푠and 푡푒= 푇푒. It means we induce
the largest temporal 푘-core T 푘
[푇푠,푇푒] at the beginning. Then, we
will anchor the start time 푡푠= 푇푠and decrease the end time 푡푒
from 푇푒until 푡푠gradually. As a result, we can always leverage
TCD to induce the temporal푘-core of current subinterval [푡푠,푡푒]
from the previously induced temporal 푘-core of [푡푠, 푡푒+ 1] but
not from G[푡푠,푡푒] or even G. Whenever the value of 푡푒is de-
creased to 푡푠, the value of 푡푠will be increased to 푡푠+ 1 until
푡푠= 푇푒, and the value of 푡푒will be reset to 푇푒. Then, we in-
duce T 푘
[푡푠+1,푡푒] from T 푘
[푡푠,푡푒], and start over the decremental TCD

---

Scalable Time-Range 푘-Core Qery on Temporal Graphs
Algorithm 2: TCD algorithm.
Input: G, 푘, [푇푠,푇푒]
Output: all distinct T 푘
[푡푠,푡푒] with [푡푠,푡푒] ⊆[푇푠,푇푒]
1 for 푡푠←푇푠to 푇푒do
// anchor a new start time
2
푡푒←푇푒
// reset the end time
3
if 푡푠= 푇푠then
4
T 푘
[푡푠,푡푒] ←TCD(G[푇푠,푇푒], 푘, [푡푠,푡푒])
5
else
6
T 푘
[푡푠,푡푒] ←TCD(T 푘
[푡푠−1,푡푒], 푘, [푡푠,푡푒])
7
collect T 푘
[푡푠,푡푒] if it is distinct
8
for 푡푒←푇푒−1 to 푡푠do
// iteratively
decremental induction
9
T 푘
[푡푠,푡푒] ←TCD(T 푘
[푡푠,푡푒+1], 푘, [푡푠,푡푒])
10
collect T 푘
[푡푠,푡푒] if it is distinct
procedure. The pseudo code of TCD algorithm is given in Algo-
rithm 2. Note that, the details of TCD(G, 푘, [푡푠,푡푒]) function is
left to Section 5.2, in which we design a speciﬁc data structure
to implement TCD operation eﬃciently in physical level.
Figure 3 gives a demonstration of TCD algorithm for ﬁnding
temporal 2-cores of time interval [1,8] on our running example
graph. The temporal 푘-cores are induced line by line and from
left to right. Each arrow between temporal 푘-cores represents
a TCD operation from tail to head. We can see that, compared
with inducing each temporal 푘-core independently, the TCD al-
gorithm reduces the computational overhead signiﬁcantly. For
most induced temporal 푘-cores, a number of vertices and edges
have already been excluded while inducing the previous tempo-
ral 푘-cores. Moreover, with the increase of 푡푠and the decrease of
푡푒when 푡푠is ﬁxed, the size of T 푘
[푡푠,푡푒] will be reduced monotoni-
cally until no temporal푘-core exists over [푡푠,푡푒], so that the time
and space costs of TCD operation will also be reduced gradually.
Lastly, we compare TCD algorithm with Baseline algorithm
abstractly. When 푡푠is ﬁxed, Baseline algorithm conducts an in-
cremental procedure, in which each vertex is popped once and
each edge may be popped and pushed back many times, and in
contrast, TCD algorithm conducts a decremental procedure, in
which each vertex is peeled once and each edge is also removed
once due to Lemma 1. Therefore, TCD algorithm that is well im-
plemented in physical level (see Section 5.2) can be even more
eﬃcient than Baseline algorithm, though it does not need any
precomputed index.
4
OPTIMIZATION
In this section, we dive deeply into the procedure of TCD al-
gorithm and optimize it dramatically by introducing an intu-
itive concept called tightest time interval for temporal 푘-cores.
In a nutshell, we directly prune subintervals without inducing
their temporal 푘-cores if we can predict that the temporal 푘-
cores are identical to other induced temporal 푘-cores, and tight-
est time interval is the key to fulﬁll prediction. In this way, the
optimized TCD algorithm only performs TCD operations that
are necessary for returning all distinct answers to a given TCQ
instance. Conceptually, the new pruning operation of optimized
algorithm eliminates the “inter-core” redundant computation, and
v10
v3
v4
v5
v6
v7
v8
v9
6
6
6
6
5
5
2
2
2
2
7
7
6
5
5
5
5
5
5
3
2
2
8
4
1
v10
v3
v4
v5
v6
v7
v8
v9
6
6
6
6
5
5
2
2
2
2
7
7
6
5
5
5
5
5
5
3
2
4
1
v3
v4
v5
v6
v7
v8
6
6
6
6
5
5
2
2
2
6
5
5
5
5
5
5
3
2
4
2
v3
v4
v5
v6
v7
v8
5
5
2
2
5
5
5
5
5
3
4
v5
v7
v8
2
2
3
4
v5
v7
v8
2
2
2
3
v5
v7
v8
2
2
2
2
2
2
2
2
2
5
v3
v4
v5
v6
6
6
6
6
5
5
5
5
5
5
v3
v4
v5
v6
6
6
6
5
5
5
5
5
56
v3
v4
v5
v6
5
5
5
5
5
5
v3
v4
v5
v6
6
6
6
6
v3
v4
v5
v6
5
5
5
5
5
5
v10
v3
v4
v5
v6
v7
v8
v9
6
6
6
6
5
5
2
2
2
7
6
5
5
5
5
5
5
3
2
2
8
4
2
v10
v3
v4
v5
v6
v7
v8
v9
6
6
6
6
5
5
2
2
2
7
6
5
5
5
5
5
5
3
2
2
4
2
7
7
v3
v4
v5
v6
v7
v8
6
6
6
6
5
5
2
2
2
6
5
5
5
5
5
5
3
2
4
v3
v4
v5
v6
v7
v8
5
5
2
2
5
5
5
5
5
3
4
v5
v7
v8
2
2
3
4
v5
v7
v8
2
2
2
3
v5
v7
v8
2
2
2
2
2
2
2
2
2
5
v3
v4
v5
v6
v7
6
6
6
6
5
5
6
5
5
5
5
5
5
3
v3
v4
v5
v6
v7
5
5
5
5
5
5
5
5
3
v3
v4
v5
v6
v7
6
6
6
6
5
5
6
5
5
5
5
5
5
3
v3
v4
v5
v6
v7
6
6
6
6
5
5
6
5
5
5
5
5
5
3
v3
v4
v5
v6
6
6
6
6
5
5
5
5
5
5
v3
v4
v5
v6
6
6
6
6
5
5
5
5
5
5
v3
v4
v5
v6
6
6
6
5
5
5
5
5
56
v3
v4
v5
v6
6
6
6
5
5
5
5
5
56
v3
v4
v5
v6
6
6
6
6
v3
v4
v5
v6
6
6
6
6
ts
te
1
2
3
4
5
6
1
2
3
4
5
6
8
7
7
8
Figure 3: A demonstration of TCD algorithm for ﬁnding
temporal 2-cores of time interval [1,8].
the original TCD operation eliminates the “intra-core” redun-
dant computation. Thus, the computational complexity of opti-
mized algorithm no longer depends on the span of query time in-
terval [푇푠,푇푒] like the baseline algorithm and the original TCD
algorithm but only depends on the scale of ﬁnal results.
Next, we introduce the concept and properties of tightest time
interval in Section 4.1, present three pruning rules based on tight-
est time interval for TCD algorithm in Section 4.2, and brieﬂy
conclude and discuss the optimized TCD algorithm in Section 4.3.
4.1
Tightest Time Interval (TTI)
We have such an observation, a temporal 푘-core of [푡푠,푡푒] may
only contain edges with timestamps in a subinterval [푡푠′,푡푒′] ⊂
[푡푠,푡푒], since the edges in [푡푠, 푡푠′) and (푡푒′,푡푒] have been re-
moved by core decomposition. For example, consider a tempo-
ral 푘-core T 2
[4,8] illustrated in Figure 3. We can see that it does
not contain edges with timestamps 4, 7 and 8. As a result, if
we continue to induce T 2
[4,7] from T 2
[4,8] and to induce T 2
[4,6]
from T 2
[4,7], the returned temporal 푘-cores remain unchanged.
The sameness of temporal 푘-cores induced by diﬀerent subinter-
vals inspires us to further optimize TCD algorithm by pruning
subintervals directly. As illustrated in Figure 3, the subintervals
such as [4,7], [4,6], [5,8], [5,7] and [5,6] all induce the identical
temporal 푘-cores to [4,8], so that they can be potentially pruned
in advance.
For that, we propose the concept of Tightest Time Interval
(TTI) for temporal 푘-cores. Given a temporal 푘-core of [푡푠,푡푒],
its TTI refers to the minimal time interval [푡푠′,푡푒′] that can in-
duce an identical temporal 푘-core to T 푘
[푡푠,푡푒], namely, there is no
subinterval of [푡푠′,푡푒′] that can induce an identical temporal 푘-
core to T 푘
[푡푠,푡푒]. We formalize the deﬁnition of TTI as follows.
Definition 3 (Tightest Time Interval). Given a temporal
푘-core T 푘
[푡푠,푡푒], its tightest time interval T 푘
[푡푠,푡푒].TTI is [푡푠′,푡푒′], if
and only if
1) T 푘
[푡푠′,푡푒′] is an identical temporal 푘-core to T 푘
[푡푠,푡푒];
2) there does not exist [푡푠′′,푡푒′′] ⊂[푡푠′,푡푒′], such that T 푘
[푡푠′′,푡푒′′]
is an identical temporal 푘-core to T 푘
[푡푠,푡푒].

---

Junyong Yang, Ming Zhong, Yuanyuan Zhu, Tieyun Qian, Mengchi Liu, and Jeﬀrey Xu Yu
It is easy to prove the TTI of a temporal 푘-core of [푡푠,푡푒] is
surely a subinterval of [푡푠,푡푒]. To evaluate the TTI of a given
T 푘
[푡푠,푡푒], we have the following theorem.
Theorem 2. Given a temporal 푘-core T 푘
[푡푠,푡푒], T 푘
[푡푠,푡푒].TTI =
[푡푚푖푛,푡푚푎푥], where 푡푚푖푛and 푡푚푎푥are the minimum and maxi-
mum timestamps in T 푘
[푡푠,푡푒] respectively.
Proof. On one hand, T 푘
[푡푚푖푛,푡푚푎푥] is identical to T 푘
[푡푠,푡푒]. Be-
cause we can induce T 푘
[푡푚푖푛,푡푚푎푥] by TCD operation from T 푘
[푡푠,푡푒]
due to [푡푚푖푛,푡푚푎푥] ⊆[푡푠,푡푒]. Meanwhile, during the operation,
none edge is actually removed since there is no edge with times-
tamp outsides [푡푚푖푛,푡푚푎푥] in T 푘
[푡푠,푡푒], and thus the temporal 푘-
core T 푘
[푡푠,푡푒] will remain unchanged. On the other hand, any time
interval [푡푠′,푡푒′] ⊂[푡푚푖푛,푡푚푎푥] cannot induce a temporal푘core
that is identical to T 푘
[푡푠,푡푒], since the edges with timestamp either
푡푚푖푛or 푡푚푎푥in T 푘
[푡푠,푡푒] are excluded at least.
□
With Theorem 2, we can evaluate the TTI of a given tempo-
ral 푘-core instantly (by 푂(1) time, see Section 5), which guar-
antees the following optimization based on TTI will not incur
extra overheads.
Moreover, there are the following important properties of TTI
that support our pruning strategies.
Property 1 (Uniqeness). Given a temporal 푘-core T 푘
[푡푠,푡푒],
there exists no other time interval than T 푘
[푡푠,푡푒].TTI evaluated by
Theorem 2 that is also a TTI of T 푘
[푡푠,푡푒].
Proof. Let T 푘
[푡푠,푡푒].TTI be [푡푠′,푡푒′], and [푡푠′′,푡푒′′] ≠[푡푠′,푡푒′]
be any other time interval. There are only two possibilities. Firstly,
[푡푠′,푡푒′] ⊄[푡푠′′,푡푒′′]. However, the edges with timestamp 푡푠′
and 푡푒′ are contained by T 푘
[푡푠,푡푒] according to Theorem 2, and
thereby [푡푠′′,푡푒′′] that does not cover [푡푠′,푡푒′] cannot induce
T 푘
[푡푠,푡푒]. Thus, the ﬁrst possibility does not satisfy the ﬁrst con-
dition in Deﬁnition 3. Secondly, [푡푠′,푡푒′] ⊂[푡푠′′,푡푒′′]. However,
since [푡푠′,푡푒′] can induce T 푘
[푡푠,푡푒], [푡푠′′,푡푒′′] is certainly not the
tightest even if it can also induce T 푘
[푡푠,푡푒]. Thus, the second possi-
bility does not satisfy the second condition in Deﬁnition 3. Con-
sequently, [푡푠′′,푡푒′′] ≠[푡푠′,푡푒′] is not a TTI of T 푘
[푡푠,푡푒].
□
Property 2 (Eqivalence). Given two temporal푘-cores T 푘
[푡푠,푡푒]
and T 푘
[푡푠′,푡푒′], they are identical temporal graphs if and only if
T 푘
[푡푠,푡푒].TTI = T 푘
[푡푠′,푡푒′].TTI.
Proof. If T 푘
[푡푠,푡푒].TTI = T 푘
[푡푠′,푡푒′].TTI, T 푘
[푡푠,푡푒] and T 푘
[푡푠′,푡푒′] are
both identical to the temporal 푘-core of the TTI according to
Deﬁnition 3, and thus are identical to each other. Conversely, if
T 푘
[푡푠,푡푒] and T 푘
[푡푠′,푡푒′] are identical, they must have a same unique
TTI according to Theorem 2 and Property 1.
□
Property 3 (Inclusion). Given two temporal 푘-cores T 푘
[푡푠,푡푒]
and T 푘
[푡푠′,푡푒′], we have T 푘
[푡푠,푡푒].TTI ⊆T 푘
[푡푠′,푡푒′].TTI, if [푡푠,푡푒] ⊆
[푡푠′,푡푒′].
Proof. Since [푡푠,푡푒] ⊆[푡푠′,푡푒′], we have T 푘
[푡푠,푡푒] is a sub-
graph of T 푘
[푡푠′,푡푒′] according to Lemma 1. Thus, the minimum
timestamp in T 푘
[푡푠,푡푒] is certainly no earlier than the the min-
imum timestamp in T 푘
[푡푠′,푡푒′], and the maximum timestamp in
T 푘
[푡푠,푡푒] is certainly no later than the the maximum timestamp in
T 푘
[푡푠′,푡푒′]. Then, according to Theorem 2, we have T 푘
[푡푠,푡푒].TTI ⊆
T 푘
[푡푠′,푡푒′].TTI.
□
Figure 4a abstracts Figure 3 as a schedule table of subinter-
val enumeration, and TCD algorithm will traverse the cells row
by row and from left to right. For example, the cell in row 1
and column 6 represents a subinterval [1, 6], in which [2, 6] is
the TTI of T 2
[1,6]. In particular, the grey cells indicate that the
temporal 푘-cores of the corresponding subintervals do not exist.
Figure 4a clearly reveals that TCD algorithm suﬀers from induc-
ing a number of identical temporal 푘-cores (with the same TTIs).
For example, the TTI [5, 6] repeats six times, which means six
cells will induce identical temporal 푘-cores.
4.2
Pruning Rules
The main idea of optimizing TCD algorithm is to predict the in-
duction of identical temporal푘-cores by leveraging TTI, thereby
skipping the corresponding subintervals during the enumera-
tion. Speciﬁcally, whenever a temporal 푘-core of [푡푠,푡푒] is in-
duced, we evaluate its TTI [푡푠′,푡푒′]. If 푡푠′ > 푡푠or/and 푡푒′ < 푡푒,
it is triggered that a number of subintervals on the schedule can
be pruned in advance. According to diﬀerent relations between
[푡푠,푡푒] and [푡푠′,푡푒′], our pruning technique can be categorized
into three rules which are not mutually exclusive. In other words,
the three rules may be triggered at the same time, and prune dif-
ferent subintervals respectively. Next, we present these pruning
rules in Section 4.2.1, Section 4.2.2 and Section 4.2.3, respectively.
4.2.1
Rule 1: Pruning-on-the-Right. Consider the schedule illus-
trated in Figure 4a. For each row, TCD algorithm traverses the
cells (namely, subintervals) from left to right. If the TTI [푡푠′,푡푒′]
in the current cell [푡푠,푡푒] meets such a condition, namely, 푡푒′ <
푡푒, a pruning operation will be triggered, and the following cells
in this row from [푡푠,푡푒−1] until [푡푠,푡푒′] will be skipped be-
cause these subintervals will induce identical temporal 푘-cores
to T 푘
[푡푠,푡푒]. Since the pruned cells are on the right of trigger cell,
we call this rule Pruning-On-the-Right (PoR). The pseudo code
of PoR is given in lines 2-4 of Algorithm 3. The correctness of
PoR is guaranteed by the following lemma.
Lemma 2. Given a temporal푘-core T 푘
[푡푠,푡푒] whose TTI is [푡푠′,푡푒′],
for any time interval [푡푠,푡푒′′] with 푡푒′′ ∈[푡푒′,푡푒], T 푘
[푡푠,푡푒′′].TTI =
[푡푠′,푡푒′].
Proof. On one hand, since [푡푠,푡푒′′] ⊆[푡푠,푡푒], T 푘
[푡푠,푡푒′′].TTI
⊆T 푘
[푡푠,푡푒].TTI = [푡푠′,푡푒′] according to Inclusion (Property 3).
On the other hand, we can prove [푡푠′,푡푒′] ⊆T 푘
[푡푠,푡푒′′].TTI. If
we induce T 푘
[푡푠′,푡푒′] from T 푘
[푡푠,푡푒] by TCD operation, it is easy
to know T 푘
[푡푠,푡푒] will remain unchanged, because it only con-
tains the edges with timestamps in [푡푠′,푡푒′] according to Theo-
rem 2. Thus, we have T 푘
[푡푠′,푡푒′].TTI = [푡푠′,푡푒′] according to Equiv-
alence (Property 2). Also, since [푡푠′,푡푒′] ⊆[푡푠,푡푒′′], [푡푠′,푡푒′] =
T 푘
[푡푠′,푡푒′].TTI ⊆T 푘
[푡푠,푡푒′′].TTI according to Inclusion (Property 3).
□
With Lemma 2, we can predict that the TTIs in the cells [푡푠,푡푒−
1], · · · , [푡푠,푡푒′] are the same as the trigger cell [푡푠,푡푒], when the

---

Scalable Time-Range 푘-Core Qery on Temporal Graphs
ts te
1
2
3
4
5
6
1
2
3
4
5
6
8
7
7
8
[6,6]
[5,6]
[5,6]
[3,6]
[2,8]
[1,8]
[6,6]
[5,6]
[5,6]
[3,6]
[2,7]
[1,7]
[6,6]
[5,6]
[5,6]
[3,6]
[2,6]
[2,6]
[5,5]
[5,5]
[3,5]
[2,5]
[2,5]
[2,4]
[2,4]
[2,3]
[2,3]
[2,2]
[2,2]
(a) Without pruning.
ts te
1
2
3
4
5
6
1
2
3
4
5
6
8
7
7
8
[5,6]
[3,6]
[2,8]
[1,8]
[2,7]
[1,7]
[6,6]
[2,6]
[5,5]
[3,5]
[2,5]
[2,4]
[2,3]
[2,2]
Cell without core induced
Pruning-on-the-Right
Pruning-on-the-Underside
Pruning-on-the-Left
[x,y]
Cell with core induced, TTI = [x,y]
Pruning triggered by cell [1,6]
Pruning triggered by cell [3,8]
Pruning triggered by cell [4,8]
(b) With pruning.
Figure 4: Examples of subinterval pruning based on tightest time interval.
PoR rule is satisﬁed. Thus, the temporal푘-cores induced by these
subintervals are all identical to the induced T 푘
[푡푠,푡푒] according to
Equivalence (Property 2).
For example, Figure 4b illustrates two instances of PoR (the
cells in orange and blue colors with left arrow). When T 2
[3,8] has
been induced, we evaluate its TTI as [3, 6], and thus PoR is trig-
gered. PoR immediately excludes the following two cells [3, 7]
and [3, 6] from the schedule. As a proof, we can see the TTIs in
these two cells are both [3, 6] in Figure 4a.
4.2.2
Rule 2: Pruning-on-the-Underside. We now consider 푡푠′ >
푡푠, which causes pruning in the following rows but not the cur-
rent row. So we call this rule Pruning-On-the-Underside (PoU).
Speciﬁcally, if 푡푠′ > 푡푠, for each row 푟∈[푡푠+ 1,푡푠′], the cells
[푟,푡푒], [푟,푡푒−1], · · · , [푟,푟] will be skipped. The pseudo code of
PoU is given in lines 5-8 of Algorithm 3. The correctness of PoU
is guaranteed by the following lemmas.
Lemma 3. Given a temporal푘-core T 푘
[푡푠,푡푒] whose TTI is [푡푠′,푡푒′],
for any time interval [푡푠′′,푡푒] with푡푠′′ ∈[푡푠,푡푠′], we have the TTI
of T 푘
[푡푠′′,푡푒] is [푡푠′,푡푒′].
Proof. The proof of this lemma is similar to Lemma 2 and
thus is omitted.
□
Lemma 4. Given a temporal푘-core T 푘
[푡푠,푡푒] whose TTI is [푡푠′,푡푒′],
for any time interval [푟,푐] with 푟∈[푡푠+ 1,푡푠′] and 푐∈[푡푠,푡푒],
we have T 푘
[푟,푐] is identical to T 푘
[푡푠,푐].
Proof. For 푟∈[푡푠+ 1,푡푠′], we have T 푘
[푟,푡푒].TTI = [푡푠′,푡푒′]
according to Lemma 3. Thus, T 푘
[푟,푡푒] is identical to T 푘
[푡푠,푡푒] ac-
cording to the Equivalence (Property 2). Then, we have T 푘
[푟,푐] is
identical to T 푘
[푡푠,푐] when 푐= 푡푒−1 since them are induced by
the same TCD operation from identical temporal graphs, and so
on for the rest [푟,푐] with the decrease of 푐until 푐= 푡푠.
□
Lemma 4 indicates that, PoU safely prunes some cells in the
following rows, since these cells contain the same TTIs as their
upper cells, which even have not been enumerated yet except
the trigger cell. For example, Figure 4b illustrates two PoU in-
stances (the cells in yellow and blue colors with up arrow). On
enumerating the cell [1, 6], since the contained TTI is [2, 6], the
cells [2, 6], · · · , [2, 2] are pruned by PoU, because the TTIs in
these cells are the same as the cells [1, 6], · · · , [1, 2] respectively,
though the TTIs of cells [1, 5], · · · , [1, 2] have not been evalu-
ated.
4.2.3
Rule 3: Pruning-on-the-Lef. Lastly, if both 푡푠′ > 푡푠and
푡푒′ < 푡푒, for each row 푟∈[푡푠′+1, 푡푒′], the cells [푟,푡푒], [푟,푡푒−1],
· · · , [푟,푡푒′ + 1] will also be skipped, besides the cells pruned by
PoR and PoU. Although these cells are in the rows under the
current row 푡푠, the temporal 푘-core of each of them is identical
to the temporal 푘-core of a cell (namely, [푟,푡푒′]) on the right in
the same row but not its upper cell like PoU. So we call this rule
Pruning-On-the-Left (PoL). The pseudo code of PoL is given in
lines 9-12 of Algorithm 3. The correctness of PoL is guaranteed
by the following lemma.
Lemma 5. Given a temporal푘-core T 푘
[푡푠,푡푒] whose TTI is [푡푠′,푡푒′],
for any time interval [푟,푐] with 푟∈[푡푠′ + 1,푡푒′] and 푐∈[푡푒′ +
1,푡푒], we have T 푘
[푟,푐] is identical to T 푘
[푟,푡푒′].
Proof. Assume T 푘
[푟,푐].TTI = [푟′,푐′]. According to Inclusion
(Property 3), we have [푟′,푐′] ⊆[푡푠′,푡푒′] since [푟,푐] ⊆[푡푠,푡푒].
Thus,푐′ ⩽푡푒′. Then, according to Lemma 2, we have T 푘
[푟,푡푒′].TTI
= [푟′,푐′] since 푡푒′ ∈[푐′,푐]. Lastly, according to Equivalence
(Property 2), we have T 푘
[푟,푐] is identical to T 푘
[푟,푡푒′].
□
For example, Figure 4b illustrates a PoL instance (the cells
in blue color with right arrow). On enumerating the cell [4, 8],
PoL is triggered since the contained TTI is [5, 6]. Then, the cells
[6, 8] and [6, 7] are pruned by PoL because the TTIs contained
in them are the same as the cell [6, 6] on the right of them. PoL
is more tricky than PoU because the cells are pruned for contain-
ing the same TTIs as other cells that are scheduled to traverse
after them by TCD algorithm. Note that, the cell [4, 8] triggers
all three kinds of pruning. In fact, a cell may trigger PoL only,
PoU only, or all three rules.
4.3
Optimized TCD Algorithm
Compared with TCD algorithm, the improvement of Optimized
TCD (OTCD) algorithm is simply to conduct a pruning opera-
tion whenever a temporal 푘-core has been induced. Speciﬁcally,
we evaluate the TTI of this temporal 푘-core, check each pruning
rule to determine if it is triggered, and prune the speciﬁc subin-
tervals on the schedule in advance. The pseudo code of pruning
operation is given in Algorithm 3. Note that, the “prune” in Al-
gorithm 3 is a logical concept, and can have diﬀerent physical
implementations.

---

Junyong Yang, Ming Zhong, Yuanyuan Zhu, Tieyun Qian, Mengchi Liu, and Jeﬀrey Xu Yu
Algorithm 3: Pruning operation.
Input: [푡푠, 푡푒] and T 푘
[푡푠,푡푒]
1 [푡푠′,푡푒′] ←T 푘
[푡푠,푡푒].TTI // Theorem 2
2 if 푡푒′ < 푡푒then
// Rule 1: PoR
3
for 푐←푡푒- 1 to 푡푒′ do
4
prune the subinterval [푡푠,푐]
5 if 푡푠′ > 푡푠then
// Rule 2: PoU
6
for 푟←푡푠+ 1 to 푡푠′ do
7
for 푐←te to r do
8
prune the subinterval [푟,푐]
9 if 푡푠′ > 푡푠and 푡푒′ < 푡푒then
// Rule 3: PoL
10
for r ←ts’+1 to te’ do
11
for c ←te to te’+1 do
12
prune the subinterval [푟,푐]
As illustrated in Figure 4b, OTCD algorithm completely elim-
inates repeated inducing of identical temporal 푘-cores, namely,
each distinct temporal 푘-core is induced exactly once during the
whole procedure. It means, the real computational complexity
of OTCD algorithm is the summation of complexity for induc-
ing each distinct temporal 푘-core but not the temporal 푘-core
of each subinterval of [푇푠,푇푒]. Therefore, we say OTCD algo-
rithm is scalable with respect to the query time interval [푇푠,푇푒].
For many real-world datasets, the span of [푇푠,푇푒] could be very
large, while there exist only a limited number of distinct tem-
poral 푘-cores over this period, so that OTCD algorithm can still
process the query eﬃciently.
5
IMPLEMENTATION
In this section, we address the physical implementation of pro-
posed algorithm. We ﬁrst introduce a data structure for temporal
graph representation in Section 5.1, based on which we explain
the details of TCD Operation implementation in Section 5.2.
5.1
Temporal Edge List (TEL)
We propose a novel data structure called Temporal Edge List
(TEL) for representing an arbitrary temporal graph (including
temporal 푘-cores that are also temporal graphs), which is both
the input and output of TCD operation. Conceptually, TEL(G)
preserves a temporal graph G = (V, E) by organizing its edges
in a 3-dimension space, each dimension of which is a set of bidi-
rectional linked lists, as illustrated in Figure 5. The ﬁrst dimen-
sion is time, namely, all edges in E are grouped by their times-
tamps. Each group is stored as a bidirectional linked list called
Time List (TL), and TL(푡) denotes the list of edges with a times-
tamp 푡. Then, TEL(G) uses a bidirectional linked list, in which
each node represents a timestamp in G, as a timeline in ascend-
ing order to link all TLs, so that some temporal operations can
be facilitated. Moreover, the other two dimensions are source
vertex and destination vertex respectively. We use a container
to store the Source Lists (SL) or Destination Lists (DL) for each
vertex 푣∈V, where SL(푣) or DL(푣) is a bidirectional linked list
that links all edges whose source or destination vertex is 푣. Ac-
tually, an SL or DL is an adjacency list of the graph, by which
we can retrieve the neighbor vertices and edges of a given vertex
eﬃciently. Given a temporal graph G, TEL(G) is built in mem-
ory by adding its edges iteratively. For each edge (푢,푣,푡) ∈E,
it is only stored once, and TL(푡), SL(푢) and DL(푣) will append its
pointer at the tail respectively.
Figure 5 illustrates a partial TEL of our example graph. The
SLs and DLs other than SL(푣5) and DL(푣3) are omitted for con-
ciseness. Basically, TL, SL and DL oﬀer the functionality of re-
trieving edges by timestamp and linked vertex respectively. For
example, for removing all neighbor edges of a vertex 푣with de-
gree less than 푘in TCD operation, we can locate SL(푣) and DL(푣)
to retrieve these edges. Moreover, the linked list of TL can oﬀer
eﬃcient temporal operations. For example, for truncating G to
G[푡푠,푡푒] in TCD operation, we can remove TL(푡) with 푡< 푡푠or
푡> 푡푒from the linked list of TL conveniently. To get the TTI
of a temporal 푘-core, we only need to check the head and tail
nodes of the linked list of TL in its TEL to get the minimum
and maximum timestamps respectively. The superiority of TEL
is summarized as follows.
• By TCD operation, a TEL will be trimmed to a smaller
TEL, and there is none intermediate TEL produced. Thus,
the memory requirement of (O)TCD algorithm only de-
pends on the size of initial TEL(G[푇푠,푇푒]).
• TEL consumes 푂(|E|) space for storing a temporal graph,
which is optimal because at least 푂(|E|) space is required
for storing a graph (e.g., adjacency lists). Although there
are 6|E|+2|V|+3푛pointers of TLs, SLs and DLs stored ad-
ditionally, TEL is still compact compared with PHC-Index,
where 푛is the number of timestamps in the graph.
• TEL supports the basic manipulations listed in Table 1 in
constant time, which are cornerstones of implementing
our algorithms and optimization techniques.
• For dynamic graphs, when a new edge coming, TEL sim-
ply appends a new node representing the current time at
the end of linked list of TL, and then adds this edge as
normal. Thus, TEL can also deal with dynamic graphs.
5.2
Implement TCD Operation on TEL
Given a TCQ instance, our algorithm starts to work on a copy
of TEL(G[푇푠,푇푒]) in memory, which is obtained by truncating
TEL(G). Then, our algorithm only needs to maintain an instance
of TEL(T 푘
[푡푠,푇푒]) and another instance of TEL(T 푘
[푡푠,푡푒]) with [푡푠,푡푒]
⊆[푇푠,푇푒] in memory. The ﬁrst instance is used to induce the
ﬁrst temporal 푘-core T 푘
[푡푠+1,푇푒] by TCD for each row in Figure 3.
The second instance is used to induce the following temporal
푘-cores T 푘
[푡푠,푡푒−1] by TCD in each row. Each TCD operation is
decomposed to a series of TEL manipulations, and trims the in-
put TEL without producing any intermediate data.
To assist the implementation of TCD operation, our algorithm
uses a global data structure H푣that organizes all vertices in the
maintained TEL into a minimum heap ordered by their degree,
so that the vertices with less than 푘neighbors can be retrieved
directly. Note that, whenever an edge is deleted from the main-
tained TEL, H푣will also be updated due to the possible decrease
of vertex degrees. The trivial details of updating H푣is omitted.
Algortithm 4 gives the implementation of TCD operation on
TEL. The algorithm takes as input the TEL of a given graph G,
along with the parameters 푘, 푡푠and 푡푒specifying the target tem-
poral 푘-core T 푘
[푡푠,푡푒]. In truncation phase, TEL(G) is projected
to TEL(G[푡푠,푡푒]) (lines 1-14). Speciﬁcally, the linked list of TL
is traversed from the head and tail bidirectionally until meet-
ing 푡푠and 푡푒respectively. For each node representing the times-
tamp 푡traversed, the edges in TL(푡) are removed from TEL, and

---

Scalable Time-Range 푘-Core Qery on Temporal Graphs
SL(v1)
SL(v2)
SL(v10)
DL(v1)
DL(v2)
DL(v3)
DL(v10)
…
(v1,v3)
(v1,v3)
TL(1)
(v2,v3)
(v7,v10)
(v5,v7)
(v5,v8)
(v5,v8)
(v7,v8)
(v7,v9)
(v7,v9)
(v2,v3)
(v5,v7)
(v1,v3)
(v7,v8)
(v3,v4)
(v3,v4)
(v3,v5)
(v3,v6)
(v4,v6)
(v4,v7)
(v4,v7)
(v5,v6)
(v5,v7)
(v3,v4)
(v3,v6)
(v4,v5)
(v4,v7)
(v5,v6)
(v7,v10)
(v9,v10)
(v9,v10)
SL(v5)
…
…
Time Lists
Destination
Lists
Source
Lists
TL(2)
TL(3)
TL(4)
TL(5)
TL(6)
TL(7)
TL(8)
Figure 5: The conceptual illustration of a partial TEL of our running example graph.
Table 1: The basic manipulations of TEL.
Name
Functionality
Complexity
next_TL(푇퐿) / prev_TL(푇퐿)
get the next or previous TL in the linked list of TL
푂(1)
get_SL(푣) / get_DL(푣)
get the SL or DL of a given vertex 푣from a hash map
푂(1)
del_TL(푇퐿)
remove the given TL node from the linked list of TL
푂(1)
del_edge(푒)
delete a given edge 푒= (푢, 푣, 푡) and update TL(푡), SL(푢) and DL(푣) respectively
푂(1)
get_TTI()
return the timestamps of head and tail nodes of linked list of TL
푂(1)
H푣is updated for each edge removed. In decomposition phase,
TEL(G[푡푠,푡푒]) is further transformed to TEL(T 푘
[푡푠,푡푒]) (lines 15-24).
Speciﬁcally, the algorithm pops the vertex with the least neigh-
bors from H푣iteratively until the remaining vertices all have at
least 푘neighbors or the heap is empty. For each popped vertex
푣, it removes the linked edges of 푣preserved in SL(푣) and DL(푣)
from TEL respectively and updates H푣accordingly. In particular,
a TL will be removed from the linked list of TL after the last edge
in it has been removed (lines 19 and 23).
To clarify the procedure of Algorithm 4, Figure 6 illustrates an
example of inducing T 2
[4,5] from T 2
[3,6]. The edges are going to be
deleted are marked in red color. We can see that, the procedure
is actually a stream of edge deletion, while TEL maintains the
entries to retrieve the remaining edges.
5.3
Complexity
TCD.Theoretically, the complexity of TCD algorithm is bounded
by Í푇푒
푡=푇푠{(|V[푡,푇푒]|+|E[푡,푇푒]|) log |V[푡,푇푒]|+푚|E[푡,푇푒]|}, where
푚is a small constant. For each anchored푡, TCD algorithm gradu-
ally peels T 푘
[푡,푇푒] like an onion by TCD operation until it contains
none temporal 푘-core. In the process, there are at most |E[푡,푇푒]|
edges deleted, and deleting each edge takes a small constant time
푂(푚) for TEL updating and at most 푂(log |V[푡,푇푒]|) time for
H푣maintenance. Similarly, there are at most |V[푡,푇푒]| vertices
deleted, and deleting each vertex takes 푂(log |V[푡,푇푒]|) time for
H푣maintenance. Therefore, The total time overhead is the sum
of edge and vertex deleting costs.
Note that, the complexity of TCD algorithm can also be rep-
resented by 푂((푇푒−푇푠)2퐵) according to Algorithm 2, where 퐵
is the average time overhead of TCD operation. However, 퐵can-
not be estimated precisely, since each TCD operation may delete
zero to |E[푡,푇푒]| edges. Therefore, we bound the complexity by
the maximum deleting cost according to Algorithm 4, which is
more reasonable.
OTCD. The complexity of OTCD algorithm is simply bounded
by Í(|푉∗| + |퐸∗|) log |푉∗| +푚|퐸∗|, where 푉∗and 퐸∗refer to the
sets of vertices and edges that have to be deleted for inducing the
result temporal 푘-cores respectively. Due to the pruning rules,
there are much less temporal 푘-cores induced by OTCD algo-
rithm. Thus, |푉∗| and |퐸∗| are orders of magnitude less than the
total number of vertices and edges deleted in TCD algorithm,
most of which are actually used for inducing identical temporal
푘-cores, though they cannot be really estimated.
6
EXTENSION
To demonstrate the wide applicability of our approach in prac-
tice, we present several typical scenarios that extends the data
model or query model of TCQ, and sketch how to address them
based on our data structure and algorithm in this section.
6.1
Data Model Extension
Dynamic Graph. Since most real-world graphs are evolving
over time, it is signiﬁcant to fulﬁll TCQ on dynamic graphs. Ben-
eﬁtted from its design in “timeline” style, our data structure TEL
can deal with new edges naturally in memory through two new
manipulations add_TL(푡) and add_edge(푢,푣,푡). When a new edge
(푢,푣,푡) arrived, we ﬁrstly create an empty TL(푡), and append it
at the end of the linked list of TL since 푡is obviously greater
than the existing timestamps. Then, we create a new edge node
for (푢,푣,푡) and append it to TL(푡), SL(푢) and DL(푣) respectively.

---

Junyong Yang, Ming Zhong, Yuanyuan Zhu, Tieyun Qian, Mengchi Liu, and Jeﬀrey Xu Yu
DL(v1)
DL(v2)
DL(v4)
SL(v1)
SL(v2)
SL(v3)
SL(v4)
DL(v3)
TL(3)
TL(4)
TL(5)
TL(6)
v2
v1
v4
v3
5
3
6
5
5
4
(v1,v4)
(v1,v2)
(v1,v3)
(v3,v4)
(v2,v3)
(v2,v4)
DL(v1)
DL(v2)
DL(v4)
SL(v1)
SL(v2)
SL(v3)
SL(v4)
DL(v3)
TL(4)
TL(5)
(v1,v2)
(v1,v3)
(v2,v3)
(v2,v4)
DL(v1)
DL(v2)
DL(v4)
SL(v1)
SL(v2)
SL(v3)
SL(v4)
DL(v3)
TL(4)
TL(5)
(v1,v2)
(v1,v3)
(v2,v3)
decomposition
truncation
v2
v1
v4
v3
5
5
5
4
v2
v1
v3
5
5
4
Figure 6: An example of TCD operation on TEL.
Algorithm 4: TCD operation in Algorithm 2
Input: TEL(G), [푡푠,푡푒], 푘
Output: TEL(T 푘
[푡푠,푡푒])
1 푇퐿←the head of linked list of TL in TEL(G)
2 while 푇퐿.timestamp ≠푡푠do
3
for edge 푒in 푇퐿do
4
del_edge(푒)
5
udpate H푣
6
del_TL(푇퐿)
7
푇퐿←next_TL(푇퐿)
8 푇퐿←the tail of linked list of TL in TEL(G)
9 while 푇퐿.timestamp ≠푡푒do
10
for edge 푒in 푇퐿do
11
del_edge(푒)
12
udpate H푣
13
del_TL(푇퐿)
14
푇퐿←prev_TL(푇퐿)
15 while H푣is not empty and H푣.peek < 푘do
16
vertex 푣←H푣.pop()
17
for edge 푒in SL(푣) do
18
del_edge(푒)
19
del_TL(TL(푒.timestamp)) if the TL is empty
20
update H푣
21
for edge 푒in DL(푣) do
22
del_edge(푒)
23
del_TL(TL(푒.timestamp)) if the TL is empty
24
update H푣
Both manipulations are ﬁnished in constant time. The mainte-
nance of a dynamic TEL is actually consistent with the construc-
tion of a static TEL. Therefore, our (O)TCD algorithm can run
on the dynamic TEL anytime.
In contrast, updating PHC-Index is a non-trivial process. Al-
though there are previous work [20, 29] on coreness updating
for dynamic graphs, the update is only valid for the whole life
time of graph. While, for an arbitrary start time, it is uncertain
whether the coreness of a vertex will be changed by a new edge.
6.2
Query Model Extension
The existing graph mining tasks regarding 푘-core introduce var-
ious constraints. For temporal graphs, we only focus on the tem-
poral constraints. In the followings, we present two of them
that can be integrated into TCQ model and also be addressed
by our algorithm directly, which demonstrate the generality of
our model and algorithm.
Link Strength Constraint. In the context of temporal graph,
link strength usually refers to the number of parallel edges be-
tween a pair of linked vertices. Obviously, the minimum link
strength in a temporal 푘-core represents some important prop-
erties like validity, since noise interaction may appear over time
and a pair of vertices with low link strength may only have oc-
casional interaction during the time interval. Actually, the previ-
ous work [34] has studied this problem without the time interval
constraint. Therefore, it is reasonable to extend TCQ to retrieve
푘-cores with a lower bound of link strength during a given time
interval. It can be achieved by trivially modifying the TCD Oper-
ation. Speciﬁcally, the modiﬁed TCD Operation will remove the
edges between two vertices once the number of parallel edges
between them is decreased to be lower than the given lower
bound of link strength, while the original TCD operation will
do this when the number becomes zero. Thus, the modiﬁcation
brings almost none extra time and space consumption.
Time Span Constraint. In many cases, we prefer to retrieve
temporal 푘-cores with a short time span (between their earliest
and latest timestamps), which is similar to the previous work on
density-bursting subgraphs [5]. Because such a kind of short-
term cohesive subgraphs tend to represent the occurrence of
some special events. TCQ can be conveniently extended for re-
solving the problem by specifying a constraint of time span. Since
the time span of a temporal푘-core is preserved in its TEL, which
is actually the length of its TTI, we can abandon the tempo-
ral 푘-cores returned by TCD operation that cannot satisfy the
time span constraint on the ﬂy. It brings almost no extra time
and space consumption. Moreover, we can also extend TCQ to
ﬁnd the temporal 푘-core with the shortest or top-푛shortest time
span.

---

Scalable Time-Range 푘-Core Qery on Temporal Graphs
Table 2: Datasets.
Name
|V|
|E|
Span(days)
Youtube
3.2M
9.4M
226
DBLP
1.8M
29.5M
17532
Flickr
2.3M
33M
198
CollegeMsg
1.8K
20K
193
email-Eu-core-temporal
0.9K
332K
803
sx-mathoverﬂow
24.8K
506K
2350
sx-stackoverﬂow
2.6M
63.5M
2774
Table 3: Selected temporal 푘-core queries.
id
G
푡푠(sec)
푡푒(sec)
푘
result #
1
CollegeMsg
554400
565200
2
61
2
CollegeMsg
558000
568800
2
21
3
CollegeMsg
561600
572400
2
27
4
CollegeMsg
565200
576000
2
26
5
CollegeMsg
568800
579600
2
10
6
email-Eu-core-temporal
36000
46800
3
2
7
email-Eu-core-temporal
39600
50400
3
3
8
email-Eu-core-temporal
284400
295200
3
7
9
email-Eu-core-temporal
288000
298800
3
25
10
email-Eu-core-temporal
291600
302400
3
16
11
sx-mathoverﬂow
864000
867600
2
8
12
sx-mathoverﬂow
1116000
1119600
2
4
13
sx-mathoverﬂow
1389600
1393200
2
5
14
sx-mathoverﬂow
1483200
1486300
2
2
15
sx-mathoverﬂow
1738800
1742400
2
8
16
sx-stackoverﬂow
378000
381600
2
6
17
sx-stackoverﬂow
417600
421200
2
37
18
sx-stackoverﬂow
421200
424800
2
5
19
sx-stackoverﬂow
424800
428400
2
5
20
sx-stackoverﬂow
486000
489600
2
10
7
EXPERIMENT
In this section, we conduct experiments to verify both eﬃciency
and eﬀectiveness of the proposed algorithm on a Windows ma-
chine with Intel Core i7 2.20GHz CPU and 64GB RAM. The al-
gorithms are implemented through C++ Standard Template Li-
brary. Our source codes are shared on GitHub1.
7.1
Dataset
We choose seven temporal graphs with diﬀerent sizes and do-
mains for our experiments. The ﬁrst three graphs are obtained
from KONECT Project [16], and the other four graphs are ob-
tained from the SNAP [17]. The basic statistics of these graphs
are given in Table 2. All timestamps are uniﬁed to integers in
seconds.
7.2
Eﬃciency
To evaluate the eﬃciency of our algorithm, we ﬁrstly manually
select twenty temporal푘-core queries from tested random queries
with a time span (namely, 푇푒−푇푠) of 1-3 days, which have been
veriﬁed to be valid, namely, there is at least one temporal 푘-core
returned for each query. The setting of time span is moderate,
otherwise other algorithms than OTCD can hardly stop success-
fully. Table 3 gives the details of query parameters, so that other
1https://github.com/ThomasYang-algo/Temporal-k-Core-Query-Project
Table 4: Eﬀect of pruning rules.
id
Triggered Times
Pruned Cell Percentage (%)
PoR
PoU
PoL
PoR
PoU
PoL
Total
1
54
72
2
0.02
72
23.6
95.62
6
2
4
1
0.01
51.8
32.1
83.91
11
8
10
1
0.04
57.1
24.5
81.64
16
5
9
1
0.04
56.9
33.5
90.44
1
2
3
4
5
0.1
1
10
100
1000
0.01
3600
Response Time(s)
Query Id
 Baseline 
 TCD 
 OTCD
(a) CollegeMsg
6
7
8
9
10
0.1
1
10
100
1000
0.01
3600
Response Time(s)
Query Id
 Baseline 
 TCD 
 OTCD
(b) email-Eu-core-temporal
11
12
13
14
15
0.1
1
10
100
1000
0.01
3600
Response Time(s)
Query Id
 Baseline 
 TCD 
 OTCD
(c) sx-mathoverﬂow
16
17
18
19
20
0.1
1
10
100
1000
0.01
3600
Response Time(s)
Query Id
 Baseline 
 TCD 
 OTCD
(d) sx-stackoverﬂow
Figure 7: The comparison of response time for selected
queries on SNAP graphs.
researchers can reverify our experimental results or compare
with our approach with the same queries.
Figure 7 compares the response time of Baseline (iPHC-Query),
TCD and OTCD algorithms for each selected query respectively,
which clearly demonstrates the eﬃciency of ouralgorithm. Firstly,
TCD performs better than baseline for all twenty queries due to
the physical eﬃciency of TEL, though they both decrementally
or incrementally induce temporal푘-cores. Speciﬁcally, TCD spends
around 100 sec for each query. In contrast, baseline spends more
than 1000 sec on CollegeMsg and even cannot ﬁnish within an
hour on two other graphs, though it uses a precomputed in-
dex. Furthermore, OTCD runs two or three orders of magnitude
faster than TCD, and only spends about 0.1-1 sec for each query,
which veriﬁes the eﬀectiveness of our pruning method based on
TTI.
To compare the eﬀect of three pruning rules in OTCD algo-
rithm, Table 4 lists their triggered times and the percentage of
subintervals pruned by them for several queries respectively. PoR
and PoU are triggered frequently because their conditions are
more easily to be satisﬁed. However, PoR actually contributes
pruned subintervals much less than the other two. Because it
only prunes subintervals in the same row, and in contrast, PoU
and PoL can prune an “area” of subintervals. Overall, the three
pruning rules can achieve signiﬁcant optimization eﬀect together

---

Junyong Yang, Ming Zhong, Yuanyuan Zhu, Tieyun Qian, Mengchi Liu, and Jeﬀrey Xu Yu
TCD
OTCD
0.01
0.1
1
10
100
1000
Response Time(s)
 TCD- 25%~75%
 OTCD- 25%~75%
 Range within 1.5IQR
 
 Median Line
 
 Mean 
 Outliers
(a) Youtube
TCD
OTCD
0.1
1
10
100
1000
Response Time(s)
 TCD- 25%~75%
 OTCD- 25%~75%
 Range within 1.5IQR
 Median Line
 Mean
 Outliers
(b) Flickr
Figure 8: The statistical distribution of response time for
random queries on KONECT graphs.
Table 5: Memory consumption of (O)TCD algorithm.
Dataset
Process Memory (GB)
CollegeMsg
0.02
sx-mathoverﬂow
0.06
Youtube
1.7
DBLP
3.1
Flickr
3.5
sx-stackoverﬂow
6.5
by enabling OTCD algorithm to skip more than 80 percents of
subintervals.
To evaluate the stability of our approach, we conduct statis-
tical analysis of one hundred valid random queries on two new
graphs, namely, Youtube and Flickr. We visualize the distribution
of response time of TCD and OTCD algorithms for these random
queries as boxplots, which are shown by Figure 8. The boxplots
demonstrate that the response time of OTCD varies in a very
limited range, which indicates that the OTCD indeed performs
stable in practice. The outliers represent some queries that have
exceptionally more results, which can be seen as a normal phe-
nomenon in reality. They may reveal that many communities of
the social networks are more active during the period.
Moreover, Table 5 reports the process memory consumption
for diﬀerent datasets, which depends on the size of TEL mostly.
We can observe that, 1) for the widely-used graphs like Youtube,
DBLP, Flickr and stackoverﬂow, several gigabytes of memory
are needed for storing TEL, which is acceptable for the ordinary
hardware; and 2) for the very large graphs with billions of edges,
the size of TEL is hundreds of gigabytes approximately, which
would require the distributed memory cluster like Spark.
To verify the scalability of our method with respect to the
query parameters, we test the three algorithms with varing min-
imum degree 푘and time span (namely, 푇푒−푇푠) respectively.
Impact of 푘. We select a typical query with span ﬁxed and
푘ranging from 2 to 6 for diﬀerent graphs. The response time of
tested algorithms are presented in Figure 9, from which we have
an important observation against common sense. That is, diﬀer-
ent from core decomposition on non-temporal graphs, when the
value of 푘increases, the response time of TCD and OTCD algo-
rithms decreases gradually. For OTCD, the behind rationale is
clear, namely, its time cost is only bounded by the scale of re-
sults, which decreases sharply with the increase of 푘. To sup-
port the claim, Figure 10 and Figure 11 show the trend of the
amount of result cores and connected components in the result
cores changing with 푘. Intuitively, a greater value of k means
a stricter constraint and thereby ﬁlters out some less cohesive
2
3
4
5
6
0.1
1
10
100
1000
0.01
3600
Response Time(s)
k
 Baseline 
 TCD 
 OTCD
(a) CollegeMsg
2
3
4
5
6
0.1
1
10
100
1000
0.01
3600
Response Time(s)
k
 Baseline 
 TCD 
 OTCD
(b) sx-mathoverﬂow
2
3
4
5
6
0.1
1
10
100
1000
0.01
3600
Response Time(s)
k
 Baseline 
 TCD 
 OTCD
(c) sx-stackoverﬂow
Figure 9: Trend of response time under a range of 푘.
2
3
4
5
6
10
1
10
2
10
3
10
4
10
5
10
6
10
0
Quantity of Core
k
(a) CollegeMsg
2
3
4
5
6
10
1
10
2
10
3
10
4
Quantity of Core
k
(b) sx-mathoverﬂow
2
3
4
5
6
10
0
10
1
10
2
10
3
10
4
10
5
10
6
Quantity of Core
k
(c) sx-stackoverﬂow
Figure 10: Trend of amount of distinct temporal 푘-cores
under a range of 푘.
2
3
4
5
6
10
0
10
1
10
2
10
3
10
4
10
5
10
6
Connected Component
k
(a) CollegeMsg
2
3
4
5
6
10
1
10
2
10
3
10
4
10
5
10
0
10
6
Connected Component
k
(b) sx-mathoverﬂow
2
3
4
5
6
10
0
10
1
10
2
10
3
10
4
10
5
10
6
Connected Component
k
(c) sx-stackoverﬂow
Figure 11: Trend of amount of connected components in
temporal 푘-cores under a range of 푘.
cores. We can see the trend of runtime decrease for OTCD in
Figure 9 is almost the same as the trend of core amount decrease
in Figure 10, which also conﬁrms the scalability of OTCD algo-
rithm. For TCD, the behind rationale is complicated, since it enu-
merates all subintervals and each single decomposition is more
costly with a greater value of 푘. It is just like peeling an onion
layer by layer, which has less layers with a greater value of 푘, so
that the maintenance between layers become less.
Impact of span. Similarly to the test of 푘, we also evalu-
ate the scalability of diﬀerent algorithms when the query time
span increases. The results are presented in Figure 12. Although
the number of subintervals increases quadratically, the response
time of OTCD still increases moderately following the scale of
query results. In contrast, TCD runs dramatically slower when
the query time span becomes longer.
The above results demonstrate that the eﬃciency of OTCD
is not sensitive to the change of query parameters, so that it is
scalable in terms of query time interval.
Lastly, for a large graph with a long time span like Youtube,
we test OTCD algorithm by querying temporal 10-cores over
the whole time span. The result is, to ﬁnd all 19,146 temporal
10-cores within 226 days, the OTCD algorithm spent about 55
minutes, which is acceptable for such a “full graph scan” task.

---

Scalable Time-Range 푘-Core Qery on Temporal Graphs
24
36
48
60
72
0.1
1
10
100
1000
0.01
3600
Response Time(s)
Span(h)
 Baseline 
 TCD 
 OTCD
(a) CollegeMsg
24
36
48
60
72
0.1
1
10
100
1000
0.01
3600
Response Time(s)
Span(h)
 Baseline 
 TCD 
 OTCD
(b) sx-mathoverﬂow
24
36
48
60
72
0.1
1
10
100
1000
0.01
3600
Response Time(s)
Span(h)
 Baseline 
 TCD 
 OTCD
(c) sx-stackoverﬂow
Figure 12: Trend of response time under a range of span.
7.3
Eﬀectiveness
The eﬀectiveness of TCQ is two-fold. Firstly, by given a ﬂexible
time interval, we can ﬁnd many temporal 푘-cores of diﬀerent
subintervals, each of which represents a community emerged in
a speciﬁc period. Consider the above test on Youtube. Although
it is not feasible to exhibit all 19,146 cores, Figure 13 shows their
distribution by time span. The number of cores generally de-
creases with the increase of time span, which makes sense be-
cause there are always a lot of small communities emerged dur-
ing short periods and then they will interact with each other and
be merged to larger communities within a longer time span.
Secondly, we can continue to ﬁlter and analyse the result cores
to gain insights. For example, we record the date in GMT time
for nine of the result cores with a time span less than one day in
Youtube, and try to ﬁgure out if they emerged for some special
reasons. Table 6 lists the date and size of the nine cores. We can
see that there is a large core emerged on Dec 10, 2006, which
means more than 40,000 accounts had nearly one million inter-
actions with each other in just a day. That is deﬁnitely caused
by a special event. While, most of the rest cores emerged during
summer vacation, which may mean people have more interac-
tions on Youtube in the period.
0
50
100
150
200
226
0
20
40
60
80
100
120
140
160
180
Number of core
Time span(days)
Figure 13: Distribution of
all
temporal
10-cores
in
Youtube by time span.
Table 6: The date and size
of nine temporal 10-cores
emerged within one day in
Youtube.
Date
|V|
|E|
Dec 10 2006
46499
885128
Feb 08 2007
1268
12054
Mar 25 2007
21
139
Jun 15 2007
98
713
Jun 18 2007
20
100
Jun 20 2007
124
1012
Jun 30 2007
21
110
Jul 02 2007
21
110
Jul 06 2007
12
66
7.4
Case Study
For case study, we employ OTCD algorithm to query tempo-
ral 10-cores on DBLP. The query interval is set as 2010 to 2018,
which spans over 8 years. By statistics, there exist 43 temporal
10-cores during that period, with 39 of them containing the au-
thor Jian Pei, for whom we further build an ego network from
three selected cores in deﬀerent years. Figure 14 shows the ego
network. The authors in the three cores emerged in 2010, 2012
and 2014 are shaded by red, yellow and blue respectively. By ob-
serving the evolution of ego network over years, we can infer
the change of author’s research interests or aﬃliations.
22 vertices of a 10-core 
arising in 2010
14 vertices of a 10-core 
arising in 2012
15 vertices of a 10-core 
arising in 2014
Figure 14: Case Study in DBLP coauthorship network.
A friendship community with 32 members arising in 2007
114  newly added members on the ﬁrst day after
124  newly added members on the second day after
Figure 15: Case Study in Youtube friendship network.
To further demonstrate the potential of TCQ, we also employ
TCQ to ﬁnd temporal 푘-cores that expand quickly over time.
This topic has been addressed in [5]. Since OTCD returns all
distinct cores eﬃciently, we can conveniently achieve the goal
by identifying the cores contained by other larger cores within
a few of days from the results. Figure 15 shows such a bursting
community on Youtube friendship network. The 32 central ver-
tices colored in red comprise an initial temporal 10-core within
two days. This core is contained by another core about four
times larger, while the TTI of the larger core only expands by
one day. The new vertices in the larger core are colored in or-
ange. Then, the new vertices colored in yellow join them to com-
prise a twice larger new core in the next day. Clearly, these three
temporal 10-cores together represent a community that grows
remarkably fast. In the real world, with more concrete informa-
tion of graphs, such usages of TCQ will facilitate applications
like recommendation, disease control, etc.
7.5
Discussion on the value of 푘
TCQ achieves relaxing the constraint on query time interval when
composing푘-core queries on temporal graphs. However, the value
of 푘is still needed as an input parameter. We give a simple and
rational criteria here for selecting the proper푘value on diﬀerent
graphs, though many potential factors have diﬀerent impacts on
the selection. The criteria is based on two intuitive facts. Firstly,
the number of distinct temporal 푘-cores over a given time in-
terval will decrease with the increase of 푘. Secondly, the size

---

Junyong Yang, Ming Zhong, Yuanyuan Zhu, Tieyun Qian, Mengchi Liu, and Jeﬀrey Xu Yu
3
5
2
4
6
10
1
10
2
10
3
10
4
10
5
10
6
10
0
CollegeMsg
Quantity of Core
k 
 Quantity of Core
 Average Size
25
50
75
100
125
150
Average Core Size
Figure 16: A statistical chart for selecting the value of 푘.
of returned temporal 푘-cores will shrink with the increase of
푘. Normally, we expect the result cores to be concise and non-
overlapping, especially when detecting the suspicious commu-
nities that are inherently small and isolated, thereby preferring
a greater value of 푘. However, the number of result cores also
matters, which requires the value of 푘not being too great, oth-
erwise there could be too few results. Therefore, the selection of
푘should take both size and number of result cores into account,
just like the trade-oﬀbetween precision and recall.
For example, with 푘ranging from 2 until 6, Figure 16 shows
the falling curves of both number and average size of result cores
over a speciﬁc time interval on CollegeMsg. We can observe that,
setting 푘= 5 should be a good choice, since the core size has
declined to a relatively small level while the number of results
is still fairly suﬃcient.
8
RELATED WORK
Recently, a variety of 푘-core query problems have been stud-
ied on temporal graphs, which involve diﬀerent temporal objec-
tives or constraints in addition to cohesiveness. The most rele-
vant work to ours is historical 푘-core query [36], which gives a
ﬁxed time interval as query condition. In contrast, our tempo-
ral 푘-core query ﬂexibly ﬁnd cores of all subintervals. Moreover,
Galimberti et al [12] proposed the span-core query, which also
gives a time interval as query condition. However, the span-core
requires all edges to appear in every moment within the query
interval, which is too strict in practice. Actually, historical푘-core
relaxes span-core, and temporal 푘-core further relaxes historical
푘-core.
Besides, there are the following related work. Wu et al [34]
proposed (푘,ℎ)-core and studied its decomposition algorithm,
which gives an additional constraint on the number of parallel
edges between each pair of linked vertices in the 푘-core, namely,
they should have at least ℎparallel edges. Li et al [19] proposed
the persistent community search problem and gives a compli-
cated instance called (휃,휏)-persistent 푘-core, which is a 푘-core
persists over a time interval whose span is decided by the pa-
rameters. Similarly, Li et al [21] proposed the continual cohe-
sive subgraph search problem. Chu et al [5] studied the prob-
lem of ﬁnding the subgraphs whose density accumulates at the
fastest speed, namely, the subgraphs with bursting density. Qin
et al [27, 28] proposed the periodic community problem to re-
veal frequently happening patterns of social interactions, such
as periodic 푘-core. Wen et al [1] relaxed the constraints of (푘,ℎ)-
core and proposed quasi-(푘,ℎ)-core for better support of main-
tenance. Lastly, Ma et al [25] studied the problem of ﬁnding
dense subgraph on weighted temporal graph. These works all
focus on some speciﬁc patterns of cohesive substructure on tem-
poral graphs, and propose sophisticated models and methods.
Compared with them, our work addresses a fundamental query-
ing problem, which ﬁnds the most general 푘-cores on temporal
graphs with respect to two basic conditions, namely, 푘and time
interval. As discussed in Section 6.2, we can extend TCQ to ﬁnd
the more speciﬁc 푘-cores by importing the constraints deﬁned
by them, because most of the deﬁnitions are special cases of tem-
poral 푘-core, but not vice versa.
Lastly, many research work on cohesive subgraph query for
non-temporal graphs also inspire our work. We categorize them
by the types of graphs as follows: undirected graph [3, 9, 13, 23,
35, 37], directed graph [4, 24, 30], labeled graph [6, 18, 31], attrib-
uted graph [7, 14, 15, 26], spatial graph [8, 10, 39], heterageneous
information network [11]. Besides, many work speciﬁc to bipar-
tite graph [22, 32, 33, 38] also contain valuable insights.
9
CONCLUSION AND FUTURE WORK
For querying communities like푘-cores on temporal graphs, spec-
ifying a time interval in which the communities emerge is the
most fundamental query condition. To the best knowledge we
have, we are the ﬁrst to study a temporal 푘-core query that al-
lows the users to give a ﬂexible interval and returns all distinct 푘-
cores emerging in any subintervals. Dealing with such a query in
brute force is obviously costly due to the possibly large number
of subintervals. Thus, we propose a novel decremental 푘-core
inducing algorithm and the auxiliary optimization and imple-
mentation methods. Our algorithm only enumerates the neces-
sary subintervals that can induce a ﬁnal result and reduces re-
dundant computation between subintervals signiﬁcantly. More-
over, the algorithm is physically decomposed to a series of ef-
ﬁcient data structure manipulations. As a result, although our
algorithm does not use any precomputed index, it still outper-
forms an incremental version of the latest index-based approach
by a remarkable margin. In conclusion, our algorithm is scalable
with respect to the span of given time interval.
In the future, we will study how to leverage our algorithm
as a framework to integrate various temporal 푘-core analytics.
There are a number of related work have considered diﬀerent
temporal constraints of 푘-cores, most of which can be combined
with the time interval condition to oﬀer more powerful function-
ality. However, their query processing algorithms are essentially
diverse. Therefore, we need to bridge the gap based on a general
and scalable algorithm like ours.
REFERENCES
[1] Wen Bai, Yadi Chen, and Di Wu. 2020. Eﬃcient temporal core maintenance
of massive graphs. Information Sciences 513 (2020), 324–340.
[2] Vladimir Batagelj and Matjaz Zaversnik. 2003. An O (m) algorithm for cores
decomposition of networks. arXiv preprint cs/0310049 (2003).
[3] Francesco Bonchi, Arijit Khan, and Lorenzo Severini. 2019.
Distance-
generalized core decomposition. In Proceedings of the 2019 International Con-
ference on Management of Data. 1006–1023.
[4] Yankai Chen, Jie Zhang, Yixiang Fang, Xin Cao, and Irwin King. 2021. Ef-
ﬁcient community search over large directed graphs: An augmented index-
based approach. In Proceedings of the Twenty-Ninth International Conference
on International Joint Conferences on Artiﬁcial Intelligence. 3544–3550.
[5] Lingyang Chu, Yanyan Zhang, Yu Yang, Lanjun Wang, and Jian Pei. 2019. On-
line density bursting subgraph detection from temporal graphs. Proceedings
of the VLDB Endowment 12, 13 (2019), 2353–2365.
[6] Zheng Dong, Xin Huang, Guorui Yuan, Hengshu Zhu, and Hui Xiong.
2021. Butterﬂy-core community search over labeled graphs. arXiv preprint

---

Scalable Time-Range 푘-Core Qery on Temporal Graphs
arXiv:2105.08628 (2021).
[7] Yixiang Fang, Reynold Cheng, Yankai Chen, Siqiang Luo, and Jiafeng Hu.
2017. Eﬀective and eﬃcient attributed community search. The VLDB Journal
26, 6 (2017), 803–828.
[8] Yixiang Fang, Reynold Cheng, Xiaodong Li, Siqiang Luo, and Jiafeng Hu. 2017.
Eﬀective community searchover large spatialgraphs. Proceedings of the VLDB
Endowment 10, 6 (2017), 709–720.
[9] Yixiang Fang, Xin Huang, Lu Qin, Ying Zhang, Wenjie Zhang, Reynold Cheng,
and Xuemin Lin. 2020. A survey of community search over big graphs. The
VLDB Journal 29, 1 (2020), 353–392.
[10] Yixiang Fang, Zheng Wang, Reynold Cheng, Xiaodong Li, Siqiang Luo, Ji-
afeng Hu, and Xiaojun Chen. 2018. On spatial-awarecommunity search. IEEE
Transactions on Knowledge and Data Engineering 31, 4 (2018), 783–798.
[11] Yixiang Fang, Yixing Yang, Wenjie Zhang, Xuemin Lin, and Xin Cao. 2020. Ef-
fective and eﬃcient community search over large heterogeneous information
networks. Proceedings of the VLDB Endowment 13, 6 (2020), 854–867.
[12] Edoardo Galimberti, Alain Barrat, Francesco Bonchi, Ciro Cattuto, and
Francesco Gullo. 2018. Mining (maximal) span-coresfrom temporal networks.
In Proceedings of the 27th ACM international Conference on Information and
Knowledge Management. 107–116.
[13] Xin Huang, Hong Cheng, Lu Qin, Wentao Tian, and Jeﬀrey Xu Yu. 2014.
Querying k-truss community in large and dynamic graphs. In Proceedings
of the 2014 ACM SIGMOD international conference on Management of data.
1311–1322.
[14] Xin Huang and Laks VS Lakshmanan. 2017. Attribute-driven community
search. Proceedings of the VLDB Endowment 10, 9 (2017), 949–960.
[15] Md Saiful Islam, Mohammed Eunus Ali, Yong-Bin Kang, Timos Sellis,
Farhana M Choudhury, and Shamik Roy. 2022. Keyword aware inﬂuential
community search in large attributed graphs. Information Systems 104 (2022),
101914.
[16] Jérôme Kunegis. 2013. Konect: the koblenz network collection. In Proceedings
of the 22nd international conference on world wide web. 1343–1350.
[17] Jure Leskovec and Andrej Krevl. 2014. SNAP Datasets: Stanford Large Net-
work Dataset Collection. http://snap.stanford.edu/data.
[18] Rong-Hua Li, Lu Qin, Jeﬀrey Xu Yu, and Rui Mao. 2015. Inﬂuential commu-
nity search in large networks. Proceedings of the VLDB Endowment 8, 5 (2015),
509–520.
[19] Rong-Hua Li, Jiao Su, Lu Qin, Jeﬀrey Xu Yu, and Qiangqiang Dai. 2018. Persis-
tent community search in temporal networks. In 2018 IEEE 34th International
Conference on Data Engineering (ICDE). IEEE, 797–808.
[20] Rong-Hua Li, Jeﬀrey Xu Yu, and Rui Mao. 2014. Eﬃcient core maintenance in
large dynamic graphs. IEEE Transactions on Knowledge and Data Engineering
26, 10 (2014), 2453–2465.
[21] Yuan Li, Jinsheng Liu, Huiqun Zhao, Jing Sun, Yuhai Zhao, and Guoren Wang.
2021. Eﬃcient continual cohesive subgraph search in large temporal graphs.
World Wide Web 24, 5 (2021), 1483–1509.
[22] Boge Liu, Long Yuan, Xuemin Lin, Lu Qin, Wenjie Zhang, and Jingren Zhou.
2019. Eﬃcient (훼, 훽)-core computation: An index-based approach. In The
World Wide Web Conference. 1130–1141.
[23] Qing Liu, Xuliang Zhu, Xin Huang, and Jianliang Xu. 2021. Local algorithms
for distance-generalized core decomposition over large dynamic graphs. Pro-
ceedings of the VLDB Endowment 14, 9 (2021), 1531–1543.
[24] Chenhao Ma, Yixiang Fang, Reynold Cheng, Laks VS Lakshmanan, Wenjie
Zhang, and Xuemin Lin. 2020. Eﬃcient algorithms for densest subgraph dis-
covery on large directed graphs. In Proceedings of the 2020 ACM SIGMOD
International Conference on Management of Data. 1051–1066.
[25] Shuai Ma, Renjun Hu, Luoshu Wang, Xuelian Lin, and Jinpeng Huai. 2019. An
eﬃcient approach to ﬁnding dense temporal subgraphs. IEEE Transactions on
Knowledge and Data Engineering 32, 4 (2019), 645–658.
[26] Shohei Matsugu, Hiroaki Shiokawa, and Hiroyuki Kitagawa. 2019. Flexible
community search algorithm on attributed graphs. In Proceedings of the 21st
International Conference on Information Integration and Web-based Applica-
tions & Services. 103–109.
[27] Hongchao Qin, Ronghua Li, Ye Yuan, Guoren Wang, Weihua Yang, and Lu
Qin. 2020. Periodic communities mining in temporal networks: Concepts and
algorithms. IEEE Transactions on Knowledge and Data Engineering (2020).
[28] Hongchao Qin, Rong-Hua Li, Guoren Wang, Lu Qin, Yurong Cheng, and Ye
Yuan. 2019. Mining periodic cliques in temporal networks. In 2019 IEEE 35th
International Conference on Data Engineering (ICDE). IEEE, 1130–1141.
[29] Ahmet Erdem Sarıyüce, Buğra Gedik, Gabriela Jacques-Silva, Kun-Lung Wu,
and Ümit V. Çatalyürek. 2016. Incremental k-core decomposition: algorithms
and evaluation. The VLDB Journal 25 (2016), 425–447.
[30] Mauro Sozio and Aristides Gionis. 2010. The community-search problem
and how to plan a successful cocktail party. In Proceedings of the 16th ACM
SIGKDD international conference on Knowledge discovery and data mining.
939–948.
[31] Renjie Sun, Chen Chen, Xiaoyang Wang, Ying Zhang, and Xun Wang. 2020.
Stable community detection in signed social networks. IEEE Transactions on
Knowledge and Data Engineering (2020).
[32] Kai Wang, Wenjie Zhang, Xuemin Lin, Ying Zhang, Lu Qin, and Yuting Zhang.
2021. Eﬃcient and eﬀective community search on large-scalebipartite graphs.
In 2021 IEEE 37th International Conference on Data Engineering (ICDE). IEEE,
85–96.
[33] Kai Wang, Wenjie Zhang, Ying Zhang, Lu Qin, and Yuting Zhang. 2021. Dis-
covering signiﬁcant communities on bipartite graphs: An index-based ap-
proach. IEEE Transactions on Knowledge and Data Engineering (2021).
[34] Huanhuan Wu, James Cheng, Yi Lu, Yiping Ke, Yuzhen Huang, Da Yan, and
Hejun Wu. 2015. Core decomposition in large temporal graphs. In 2015 IEEE
International Conference on Big Data (Big Data). IEEE, 649–658.
[35] Kai Yao and Lijun Chang. 2021. Eﬃcient size-bounded community search
over large networks. Proceedings of the VLDB Endowment 14, 8 (2021), 1441–
1453.
[36] Michael Yu, Dong Wen, Lu Qin, Ying Zhang, Wenjie Zhang, and Xuemin Lin.
2021. On querying historical k-cores. Proceedings of the VLDB Endowment 14,
11 (2021), 2033–2045.
[37] Chen Zhang, Fan Zhang, Wenjie Zhang, Boge Liu, Ying Zhang, Lu Qin, and
Xuemin Lin. 2020. Exploring ﬁner granularity within the cores: Eﬃcient (k,
p)-core computation. In 2020 IEEE 36th International Conference on Data En-
gineering (ICDE). IEEE, 181–192.
[38] Yuting Zhang, Kai Wang, Wenjie Zhang, Xuemin Lin, and Ying Zhang. 2021.
Pareto-optimal community search on large bipartite graphs. In Proceedings of
the 30th ACM International Conference on Information & Knowledge Manage-
ment. 2647–2656.
[39] Qijun Zhu, Haibo Hu, Cheng Xu, Jianliang Xu, and Wang-Chien Lee. 2017.
Geo-social group queries with minimum acquaintance constraints. The VLDB
Journal 26, 5 (2017), 709–727.

---

