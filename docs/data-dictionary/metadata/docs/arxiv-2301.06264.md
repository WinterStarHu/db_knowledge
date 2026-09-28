# An Efficient Approach for Discovering Graph Entity Dependencies (GEDs)

> 来源: https://arxiv.org/pdf/2301.06264

Highlights
An Efficient Approach for Discovering Graph Entity Dependencies
(GEDs)
Dehua Liu, Selasi Kwashie, Yidi Zhang, Guangtong Zhou, Michael Bewong,
Xiaoying Wu, Xi Guo, Keqing He, Zaiwen Feng
• A study of the discovery problem of Graph Entity Dependencies (GEDs).
• A new and efficient approach for the discovery of GEDs in property
graphs.
• A minimum description length inspired definition of interestingness of
GEDs to rank discovered rules.
• A thorough empirical evaluation of the proposed technique, with exam-
ples of useful rules (mined) that are relevant in data quality/management
applications.
arXiv:2301.06264v2  [cs.DB]  1 Jul 2023

---

An Efficient Approach for Discovering Graph Entity
Dependencies (GEDs)
Dehua Liua, Selasi Kwashieb, Yidi Zhanga, Guangtong Zhoua, Michael
Bewongc, Xiaoying Wud, Xi Guoa, Keqing Hed, Zaiwen Fenga,∗
aCollege of Informatics, Huazhong Agric. University, Wuhan, Hubei, China
bAI & Cyber Futures Institute, Charles Sturt University, Bathurst, NSW, Australia
cSchool of Computing & Mathematics, Charles Sturt University, Wagga
Wagga, NSW, Australia
dSchool of Computer, Wuhan University, Wuhan, Hubei, China
Abstract
Graph entity dependencies (GEDs) are novel graph constraints, unifying keys
and functional dependencies, for property graphs. They have been found use-
ful in many real-world data quality and data management tasks, including
fact checking on social media networks and entity resolution. In this paper,
we study the discovery problem of GEDs – finding a minimal cover of valid
GEDs in a given graph data. We formalise the problem, and propose an effec-
tive and efficient approach to overcome major bottlenecks in GED discovery.
In particular, we leverage existing graph partitioning algorithms to enable
fast GED-scope discovery, and employ effective pruning strategies over the
prohibitively large space of candidate dependencies. Furthermore, we de-
fine an interestingness measure for GEDs based on the minimum description
length principle, to score and rank the mined cover set of GEDs. Finally, we
demonstrate the scalability and effectiveness of our GED discovery approach
∗Corresponding author
URL: Zaiwen.Feng@mail.hzau.edu.cn (Zaiwen Feng)
Preprint submitted to Knowledge-Based Systems
July 4, 2023

---

through extensive experiments on real-world benchmark graph data sets; and
present the usefulness of the discovered rules in different downstream data
quality management applications.
Keywords:
Graph entity dependencies, Graph entity dependency
discovery, Efficient algorithm, Data Dependencies
1. Introduction
In recent years, integrity constraints (e.g., keys [1] and functional depen-
dencies (FDs) [2]) have been proposed for property graphs to enable the
specification of various data semantics, and tackling of graph data quality
and management problems. Graph entity dependencies (GEDs) [4, 5] are
new fundamental constraints unifying keys and FDs for property graphs.
A GED φ over a graph G is a pair, φ = (Q[¯u], X →Y ), specifying the
dependency X →Y over homomorphic matches of the graph pattern Q[¯u] in
G. Intuitively, since graphs are schemaless, the graph pattern Q[¯u] identifies
which the set of entities in G on which the dependency X →Y should hold.
In general, GEDs are capable of expressing and encoding the semantics of
relational FDs and conditional FDs (CFDs), as well as subsume other graph
integrity constraints (e.g., GKeys [1] and GFDs [2]).
GEDs have numerous real-world data quality and data management ap-
plications (cf. [4, 5] for more details). For example, they have been extended
and used for: fact checking in social media networks [20], entity resolution
in graphs and relations [3, 6, 22], consistency checking [21], knowledge graph
generation [51], amongst others.
In this work, motivated by the expressivity and usefulness of GEDs in
2

---

many downstream applications, we study the problem of automatically learn-
ing GEDs from a given property graph. To the best of our knowledge, at
the moment, no discovery algorithm exists in the literature for GEDs, albeit
discovery solutions have been proposed for graph keys and GFDs in [12] and
[16] respectively. However, the GFD mining solutions in [16] mine a special
class of GEDs (without any id-literals, using isomorphic matching seman-
tics). Further, [16, 12] considers the discovery of key constraints in RDFs.
Thus, the need for effective and efficient techniques for mining rules that
capture the full GED semantics still exists.
Discovering data dependencies is an active and long-standing research
problem within the database and data mining communities.
Indeed, the
problem is well-studied for the relational data setting, with volumes of con-
tributions for functional dependencies (FDs) [8, 19, 44, 18] and its numerous
extensions (e.g., conditional FDs [7, 26, 24], distance-based FDs [10, 9, 14,
15, 13], etc).
The general goal in data dependency mining is to find an irreducible set
(aka. minimal cover set) of valid dependencies (devoid of all implications
and redundancies) that hold over the given input data. This is a challeng-
ing and often intractable problem for most dependencies, and GEDs are not
an exception. In fact, the problem is inherently more challenging for GEDs
than it is for other graph constraints (e.g. GFDs and GKeys) and tradi-
tional relational dependencies.
The reason is three-fold: a) the presence
of graph pattern as topological constraints (unseen in relational dependen-
cies); b) the attribute sets of GED dependency have three possible literals
(e.g., GFDs have 2, GKeys have 1, CFDs have 2); c) the implication and
3

---

validation analyses—key tasks in the discovery process—of GEDs are shown
NP-complete and co-NP-complete respectively (see [5] for details).
This paper proposes an efficient and effective GED mining solution. We
observe that, two major efficiency bottlenecks in mining GEDs are on pattern
discovery in large graphs, traversal of the prohibitively large search space of
candidate dependencies. Thus, we leverage existing graph partitioning algo-
rithms to surmount the first challenge, and employ several effective pruning
rules and strategies to resolve the second.
We summarise our main contributions as follows. 1) We formalise the
GED discovery problem (in Section 3). We extend the notions of trivial,
reduced, and minimal dependencies for GEDs; and introduce a formal cover
set finding problem for GEDs. 2) We develop a new two-phase approach
for efficiently finding GEDs in large graphs (Setion 4). The developed solu-
tion leverages existing graph partitioning algorithms to mine graph patterns
quickly, and find their matches. Further, we design a comprehensive attribute
(and entity) dependency discovery architecture with effective candidate gen-
eration, search space pruning and validation strategies. Moreover, we intro-
duce a new interestingness score for GEDs, for ranking the discovered rules.
3) We perform extensive experiments on real-world graphs to show that GED
discovery can be feasible in large graphs, and demonstrate the effectiveness,
scalability and efficiency of our proposed approach (Section 5).
2. Preliminaries
This section presents preliminary concepts and definitions. We use A, L, C
to be denote universal sets of attributes, labels and constants respectively.
4

---

The definitions of graph, graph pattern, and matches follow those in [4, 5].
Graph. We consider a directed property graph G = (V, E, L, FA), where:
(1) V is a finite set of nodes; (2) E is a finite set of edges, given by E ⊆
V × L × V , in which (v, l, v′) is an edge from node v to node v′ with label
l ∈L; (3) each node v ∈V has a special attribute id denoting its identity,
and a label L(v) drawn from L; (4) every node v, has an associated list
FA(v) = [(A1, c1), ..., (An, cn)] of attribute-value pairs, where ci ∈C is a
constant, Ai ∈A is an attribute of v, written as v.Ai = ci, and Ai̸ = Aj if
i̸ = j.
Graph Pattern. A graph pattern, denoted by Q[¯u], is a directed graph
Q[¯u] = (VQ, EQ, LQ), where: (a) VQ and EQ represent the set of pattern
nodes and pattern edges respectively; (b) LQ is a label function that assigns
a label to each node v ∈VQ and each edge e ∈EQ; and (c) ¯u is all the nodes,
called (pattern) variables in VQ. All labels are drawn from L, including the
wildcard “*” as a special label. Two labels l, l′ ∈L are said to match, denoted
l ≍l′ iff: (a) l = l′; or (b) either l or l′ is “*”.
A match of a graph pattern Q[¯u] in a graph G is a homomorphism h
from Q to G such that: (a) for each node v ∈VQ, LQ(v) ≍L(h(v)); and (b)
each edge e = (v, l, v′) ∈EQ, there exists an edge e′ = (h(v), l′, h(v′)) in G,
such that l ≍l′. We denote the list of all matches of Q[¯u] in G by H(¯u). An
example of a graph, graph patterns and their matches are presented below
in Example 1.
Example 1 (Graph, Graph Pattern & Matching). Figure 1(a) depicts
a simple graph; and (b)–(e) are examples of four graph patterns. Q1[x, y] de-
scribes an “is a” relationship between two generic (“*” labelled) nodes x
5

---

y'
y
x
y
x
8
x'
x
y
product
c
c
hs
hl
c
7
3
6
2
1
4
c
c
c
c
hl
Relation Legend::	 	
c: creates	
	
hs: has_shares_in	 	
hl: has_license_to
(b) Q1
(c) Q2
(d) Q3
(a) G
hs

is_a
5
0
c
9
is_a
y
x

c
(e) Q4
c
11
10
12
generic '*' label
company
hs
hl
c
is_a
13
11
10
14
hs
hl
c
15
hl
private entity
Node Legend::
Figure 1: Example: (a) graph; (b)–(d) graph patterns
and y. The list of matches of this pattern in the example graph is H1(x, y) =
[{1, 0}, {2, 0}]. Q2[x, y] depicts a company node x with a create relation with
a product node y, its matches in G : H2(x, y) = [{1, 4}{1, 5}{2, 6}, {3, 7}, {3, 8},
{3, 9}, {11, 12}, {11, 14}]. Q3[x, y, y′] specifies a company node x with a create
relation with two product nodes y, y′. Thus, matches in G are H3(x, y, y′) =
[{1, 4, 5}, {3, 7, 8}, {3, 7, 9}, {3, 8, 9}]. Q4[x, x′, y] describes a company x with
a has shares in relation with another company x′, and a has license to
relation with a product y created by x′. H4(x, x′, y) = [{2, 4, 7}, {10, 11, 12}, {10,
11, 14}].
Graph Entity Dependencies. A graph entity dependency (GED) [4]
φ is a pair (Q[¯u], X →Y ), where Q[¯u] is a graph pattern, and X, Y are
two (possibly empty) sets of literals in ¯u.
A literal w of ¯u is one of the
following three constraints: (a) x.A = c, (b) x.A = y.A′, (c) x.id = y.id,
where x, y ∈¯u, are pattern variables, A, A′ ∈A, are non-id attributes, and
c ∈C is a constant. Q[¯u], and X →Y are referred to as the pattern/scope
6

---

and dependency of φ respectively.
Given a GED φ = (Q[¯u], X →Y ), a match h(¯u) of Q[¯u] in G satisfies
a literal w of ¯u, denoted by h(¯u) |= w, if: (a) when w is x.A = c, then the
attribute h(x).A exists, and h(x).A = c; (b) when w is x.A = y.A′, then the
attributes h(x).A and h(y).A′ exist and have the same value; (c) when w is
x.id = y.id, then h(x).id = h(y).id.
A match h(¯u) satisfies a set X of literals if h(¯u) satisfies every literal
w ∈X, (similarly defined for h(¯u) |= Y ).
We write h(¯u) |= X →Y if
h(¯x) |= X implies h(¯x) |= Y .
A graph G satisfies GED φ, denoted by G |= φ, if for all matches h(¯u) of
Q[¯u] in G, h(¯x) |= X →Y . A graph, G, satisfies a set Σ of GEDs, denoted
by G |= Σ, if for all φ ∈Σ, G |= φ.
We illustrate the semantics of GEDs via the sample graph and graph
patterns in Figure 1 below.
Example 2 (GEDs). We define exemplar GEDs over the sample graph in
Figure 1(a), using the graph patterns in Figure 1(b)–(e). 1) φ1 : (Q1[x, y], y.A =
y.A →x.A = y.A) – this GED states that for any match h(x, y) of the
pattern Q1[x, y] in G (i.e., x is_a y), if the node h(y) has property A,
then h(x) must have same values as h(y) on A.
2) φ2 : (Q2[x, y], ∅→
y.creator = x.name) – for every match h(x, y) of Q2 in G (i.e., company
h(x) create product h(y)), then h(y.creator) and h(x.name) must have
the same value. 3) φ3 : (Q3[x, y, y′], ∅→y.creator = y′.creator) – this states
for any match h(x, y, y′) in G (i.e., the company h(x) create two products
h(y, y′)), then y, y′ must have same value on their property/attribute creator.
4) φ4 : (Q4[x, x′, y], x′.country = USA→x.country = USA) – for every match
7

---

h(x, x′, y) of Q4 in G, if h(x′.country) is USA, then h(x.country) must also
be USA. Note that, φ4 over G restricts share/license ownership in any USA
company to only USA companies.
3. Problem Formulation
Given a property graph G, the general GED discovery problem is to
find a set Σ of GEDs such that G |= Σ. However, like other dependency
discovery problems, such a set can be large and littered with redundancies
(cf. [16, 22, 44]). Thus, in line with [16], we are interested in finding a cover set
of non-trivial and non-redundant dependencies over persistent graph patterns.
In the following, we formally introduce the GEDs of interest, and present our
problem definition.
Persistent Graph Patterns. Graph patterns can be seen as “loose
schemas” in GEDs [5]. It is therefore crucial to find persistent graph patterns
in the input graph data for GED discovery. However, counting the frequency
of sub-graphs is a non-trivial task, and can be intractable depending on the
adopted count-metric (e.g., harmful overlap [30], and maximum independent
sets [29]).
We adopt the minimum image based support (MNI) [45] metric to count
the occurrence of a graph pattern in a given graph, due to its anti-monotone
and tractability properties.
Let I = {i1, · · · , im} be the set of isomorphisms of a pattern Q[¯u] to a
graph G. Let M(v) = {i1(v), · · · , im(v)} be the set containing the (distinct)
nodes in G whose functions i1, · · · , im map a node v ∈V . The MNI of Q in
8

---

G, denoted by mni(Q, G), is defined as:
mni(Q, G) = min{x | x = |M(v)|, ∀v ∈V }.
(3.1)
We say a graph pattern Q[¯u] is persistent (i.e., frequent) in a graph G, if
mni(Q, G) ≥τ, where τ is a user-specified minimum MNI threshold.
Representative Graph Patterns. For many real-world graphs, it is
prohibitively inefficient to mine frequent graph patterns with commodity
computational resources largely due to their sizes (cf. [31, 32]). To alleviate
this performance bottleneck, in our pipeline, we consider graph patterns that
are frequent within densely-connected communities within the input graph.
We term such graph patterns representative, and adopt the Constant Potts
Model (CPM) [35] as the quality function for communities in a graph.
Formally, the CPM of a community c is given by
H =
X
c

ec −γ
nc
2

(3.2)
where ec and nc are the number of edges and nodes in c respectively; and
γ > 0 is a (user-specified) resolution parameter—higher γ leads to more com-
munities, and vice versa. Intuitively, the resolution parameter, γ, constrains
the intra- and inter-community densities to be no less than and no more than
the value of γ respectively.
Thus, we say a graph pattern Q[¯u] is representative or (γ, τ)-frequent if
it is τ-frequent within at least one γ-dense community c ∈G.
Trivial GEDs. We say a GED φ : (Q[¯u], X →Y ) is trivial if: (a) the
set of literals in X cannot be satisfied (i.e., X evaluates to false); or (b) Y
is derivable from X (i.e., ∀w ∈Y , w can be derived from X by transitivity
of the equality operator). We consider non-trivial GEDs.
9

---

Reduced GEDs.
Given two patterns Q[¯u] = (VQ, EQ, LQ), Q′[ ¯u′] =
(V ′
Q′, E′
Q′, L′
Q′), Q[¯u] is said to reduce Q′[ ¯u′], denoted as Q ≪Q′ if: (a)
VQ ⊆V ′
Q′, EQ ⊆E′
Q′; or (b) LQ upgrades some labels in L′
Q′ to wildcards.
That is, Q is a less restrictive topological constraint than Q′.
Given two GEDs, φ = (Q[¯u], X →w) and φ′ = (Q′[ ¯u′], X′ →w′). φ is
said to reduce φ′, denoted by φ ≪φ′, if: (a) Q ≪Q′; and (b) X ⊆X′ and
w = w′.
Thus, we say a GED φ is reduced in a graph G if: (a) G |= φ; and for
any φ′ such that φ′ ≪φ, G̸ |= φ′. We say a GED φ is minimal if it is both
non-trivial and reduced.
Cover of GEDs. Given a set Σ of GEDs such that G |= Σ. Σ is minimal
iff: for all φ ∈Σ, we have Σ̸ ≡Σ \ φ. That is, Σ contains no redundant
GED. We say Σc is a cover of Σ on G if: (a) Σc ⊆Σ; (b) Σc ≡Σ; (c) all
φ ∈Σc are minimal; and (d) Σc is minimal.
We study the following GED discovery problem.
Definition 1 (Discovery of GEDs). Given a property graph, G, and user-
specified resolution parameter and MNI thresholds γ, τ: find a cover set Σc
of all valid minimal GEDs that hold over (γ, τ)-frequent graph patterns in G.
4. The Proposed Discovery Approach
This section introduces a new and efficient GED discovery approach. Fig-
ure 2 presents the overall pipeline of our solution, consisting of two main
components for: (a) finding representative and reduced graph patterns (i.e.,
“scopes”) and their (homomorphic) matches in the graph; and (b) finding
10

---

B) Dependency Mining
A) Scope Discovery
Graph
Data
Community
Detector
Frequent
Subgraph Miner
Graph 
Pattern Matcher
Matches
Preprocessor
Partitioner
Candidate
Generator
Validator
Rank 
GEDs
meta
data
Figure 2: The Overall GED Discovery Pipeline.
minimal attribute (entity) dependencies that holds over the graph patterns.
A snippet of the pseudo-code for the proposed GED discovery process is pre-
sented Algorithm 1, requiring two main procedures for the above-mentioned
tasks (cf. lines 2 and 3–5 of Algorithm 1 respectively). The required input
to the algorithm includes: a property graph, G; a user-specified resolution
parameter γ and minimum MNI threshold τ.
4.1. Graph Pattern Discovery & Matching
The first task in the discovery process is finding representative graph
patterns, and their matches in the given graph. We present a three-phase
process for the task, viz.: (i) detection of dense communities within the input
graph; (ii) mining frequent graph patterns in communities; and (iii) finding
matches of the discovered (and reduced) graph patterns in the input graph.
Procedure 1, mineScopes(G, γ, τ), presents the pseudo-code for this task
(with workflow depicted in Figure 2 A).
11

---

Algorithm 1 DisGEDs
Require: A graph, G; CPM resolution-parameter, γ; MNI threshold, τ.
Ensure: A cover set Σc of GEDs (with τ-frequent graph patterns) in G
1: Σc := ∅; Σ := ∅; S := ∅
2: S ←mineScopes(G, γ, τ)
▷find graph patterns & their matches
3: for each (Qi, H(Qi, G)) ∈S do
▷mine minimal GEDs
4:
Σi ←mineDependencies(Qi, H(Qi, G))
5:
Σ ←Σ ∪Σi
6: Σc ←findCover(Σ)
▷remove all transitively implied GEDs
7: return Σc
4.1.1. Dense communities detection
The first step in our approach is straightforward: division of the input
8
7
3
6
2
1
4
c
c
c
c
hl
C1
hs
5
0
c
9
is_a
c
11
10
12
hs
hl
c
is_a
13
11
10
14
hs
hl
c
15
hl
C1
C3
C2
Figure 3: 0.01-dense communities in ex-
ample graph G : C1, C2, C3
graph G into multiple dense communi-
ties, C = {c1, · · · , ck}.
In particular,
we employ the quality function in Equa-
tion 3.2 to ensure that the density of
each community ci ∈C, (i ∈[1, k]) is
no less than γ. In general, any efficient
graph clustering algorithm can be em-
ployed for this task; and we adopt the
Leiden graph clustering algorithm [37]
with the CPM quality function to partition the input graph into γ-dense
communities (cf. line 2 in Procedure 1).
As an example, consider our sample graph in Figure 1 (a). For a resolution
value of γ = 0.01, three dense communities are produced as show in Figure 3.
12

---

This includes: c1, portion of the graph enclosed by the dotted blue lines; c2,
a single node 13; and c3, the remaining graph.
Procedure 1 mineScopes(G, γ, τ)
Require: Graph, G; CPM resolution-parameter, γ; MNI threshold, τ
Ensure: Set S = {(Q1, H(Q1, G)), · · · } of reduced patterns Qi and their
homomorphic matches H(Qi, G) in G
1: C := ∅; Q := ∅; S := ∅; G′ = ∅
2: C ←Leiden(G, γ)
▷mine dense communities
3: for ci ∈C do
▷mine frequent sup-graph patterns
4:
Qi ←GraMi(ci, τ)
5:
Q ←Q ∪Qi
6: Q′ ←reduceGraphPatterns(Q)
7: for Q ∈Q′ do
▷find homomorphic matches
8:
G′ ←filter(G, Q)
▷filter G w.r.t. edges/nodes in Q
9:
H(Q, G) ←match(Q, G′)
10:
S ←S ∪(Q, H(Q, G))
11: return S
4.1.2. Representative Graph Patterns Mining
Next, we take the discovered γ-dense communities, C = {c1, · · · , ck} as
input, and return a set of frequent and reduced graph patterns, using iso-
morphic matching and the MNI metric (in Equation 3.1) to count patterns
occurrences in the communities (cf. lines 3–6 of Procedure 1).
We adapt the GraMi graph patterns mining algorithm [28] to find the set,
Q, of all τ-frequent patterns across c1, · · · , ck. As will be expected, Q may
13

---

contain redundant patterns. Therefore, we designed a simple and effective
algorithm, Function 1, to prune all redundancies in Q, and return a set Q′ of
representative and reduced patterns in G (i.e., there does not exist any pair
of patterns Q, Q′ ∈Q′ such that Q ≪Q′ or Q′ ≪Q).
Function 1 reduceGraphPatterns(Q)
1: n ←|Q|; Q′ := ∅;⃗T ←[false, false, ..., false]
2: Sort(Q)
▷in descending order of pattern sizes
3: for i ←0 to n −1 do
4:
if⃗T[i] == false then
5:
for j ←i + 1 to n −1 do
6:
if⃗T[j] == false then
7:
if count(VF2U(Q(i), Q(j))) > 0 then
8:⃗
T[j] ←true
9:
Q′ ←Q′ ∪Q(i)
10: return Q′
The input to Function 1 is a set Q of τ-frequent graph patterns in γ-dense
communities (ie., (γ, τ)-frequent or representative graph patterns); and the
output is a set Q′ of graph patterns without any redundancies.
Let n be the size, |Q|, of Q; and⃗T be an n-length vector where each
location⃗T[i] at index i ∈[0, n −1] holds a Boolean value. Each entry⃗T[i]
is associated with a graph pattern Qi ∈Q, and denotes whether or not the
associated graph pattern is redundant.
The variables, n, Q′ and⃗T are initialised in line 1 of Function 1. The
graph patterns in Q are then sorted from largest to smallest by the num-
14

---

ber of edges in every graph pattern (in line 2).
Thereafter, we evaluate
d
b
c
c
hl
a
hs
c
c
b
d
c
a
hs
c
b
c
c
hl
a
3
2
1
0
(a) Examples of 2-frequent patterns in sample 
graph G (of Figure 1(a))
(b) Illustration of redundancy pruning of 
frequent graph patterns
d
b
c
c
hl
a
hs
c
c
b
d
c
a
hs
c
b
c
c
hl
a
3
2
1
T[0]: false
T[2]: false
T[4]: false
Sort Pattens in Decreasing Order; Initialise Indexes
d
b
c
c
hl
a
hs
c
c
b
d
c
a
hs
c
b
c
c
hl
a
3
2
2
T[0]: false
T[2]: true
T[4]: true
Check Redundancy
Figure 4: Frequent subgraph pruning
pairs of graph patterns for redun-
dancy (in lines 3–9). In particular,
the functions VF2U and count are
used to check isomorphic matches
between patterns at index i, j of Q,
and compute the number of isomor-
phic matches returned respectively.
We extended an efficient implemen-
tation1 of the VF2 algorithm[43]
through the relaxation of some crite-
ria as VF2U. The main difference be-
ing, in VF2U, instead of induced sub-
graphs, the query graph pattern sim-
ply queries subgraphs in the target
graph pattern which are isomorphic
to it.
For the pairwise comparison of
the graph patterns, the pattern at
index j is considered as the query
pattern whiles that at index i is the
target pattern. The algorithm iterates from the largest pattern in Q (line 3).
In the round of iteration i, the largest pattern indexed i is used as the Q(i) if
1https://github.com/MorvanHua/VF2
15

---

it is tagged with false. As Q(j), every pattern indexed from i+1 to n−1 is
checked to observe if it is isomorphic to Q(i). VF2U returns the isomorphisms
from Q(j) to Q(i), and count returns the size of the resulting set.
During every iteration, the pattern indexed j (j > i) is tagged as true
(i.e., line 8) if the Q(j) is isomorphic to the Q(i), and the Q(j) will not
be a target graph in the following iterations. After all the patterns indexed
from i + 1 to n −1 are checked, the Q(i) is added into Q′ and the round of
iteration i ends. Finally, when all graph patterns have been processed, the
set Q′ which stores all graph patterns without redundancies is returned as
the output.
We present a brief illustration of the reduction process in Example 3.
Example 3 (Representative Patterns). Given the 0.01-dense three com-
munities discovered in Figure 3, let the minimum support be τ = 2 for mining
frequent subgraphs in the respective communities. Figure 4 (a) shows a list of
three (3) frequent but redundant subgraphs. We illustrate the pruning strategy
as follows, using the diagram in Figure 4 (b).
First, we sort the subgraphs in increasing order (of edges) and initialise
the corresponding index i in the vector⃗T[i] as false. Next, we iterate over
the vector, from the largest subgraph at i and the next at j = i + 1, to check
the containment of the pattern at j in the pattern at i. We set the index at⃗
T[j] to true if it contained in the patern at i.
Finally, we return all patterns at index k if⃗T[k] is false (in this case,
pattern 3 at index 0). □
16

---

4.1.3. Homomorphic Pattern Matching
Given the set, Q′, of reduced representative graph patterns from the
previous step, we find their homomorphic matches in the input graph (cf.
lines 7–10 of Procedure 1).
To ensure efficient matching of any pattern
Q ∈Q′, we prune the input graph w.r.t. the node and edge types in Q
to produced a simplified/filtered version of the input graph; then perform
homomorphic sub-graph matching on the simplified graph with Q.
A simplified graph, G′, based on a given graph pattern Q is a graph in
which nodes and edges types (labels) that do not appear in Q are removed
8
7
3
6
2
1
4
c
c
c
c
G'
5
c
9
c
11
12
c
11
10
14
c
15
Figure 5: Simplified G, wrt Q3
from the original graph, G.
The simplifi-
cation of the input graph w.r.t.
a graph
pattern reduces the search space of can-
didate matches significantly, and improves
the efficiency of the matching process. We
adopt the efficient worst-case optimal join
(WCOJ) based algorithm introduced in [38]
to find all homomorphic matches of Q in G′.
For our running example, for brevity, suppose we want to simplify sample
graph G, w.r.t. pattern Q3[x, y, y′] in Figure 1 (a) and (d), respectively. The
resulting simplified graph, G′, is as shown in Figure 5.
For each set of subgraph matched records based on a graph pattern, a
large attributes’ relationship data table is generated by combining all at-
tributes of entities in the graph pattern and the values of all attributes of
entities in every matched subgraph. This pseudo-relation table stores the
values of all attributes of entities in a graph pattern. The first row repre-
17

---

sents all attributes of entities contained in the graph pattern, and each of
the remaining rows is information about a matching subgraph, representing
the values of all attributes of entities in a matched subgraph. An exam-
ple of pseudo-relations over graph pattern Q3 (from the running example in
Figure 1) is presented in Figure 6.
4.2. Attribute (Entity) Dependency Discovery
Here, we mine dependencies over the pseudo-relational tables produced
from the matches of the discovered graph patterns in the previous step. As
depicted in Figure 2(B), the dependency discovery architecture consists of
four key modules, namely: (a) Matches Preprocessor, (b) Partitioner, (c)
Candidate Generator, and (d) the Validator.
In the following, we discuss the function of each module (in order), illus-
trating the overall dependency mining algorithm over matches H(Q, G) of a
pattern Q in a graph G (as captured in Procedure 2).
4.2.1. Pre-processing matches of patterns
This is an important (but optional) first step in the dependency mining
process. In the presence of any domain-knowledge (e.g., in the form of meta
data) about the input graph, one may leverage such knowledge to enhance
the discovery process. For instance, given any graph pattern and its list of
matches, based on available meta data, we can determine: (a) which sets of
attributes to consider for each pattern variable; (b) which pairs of pattern
variables to consider for the generation of variable and id literals.
That is, this phase allows any relevant pre-processing of the pseudo-
relational table of the matches of a graph pattern for efficient downstream
18

---

Procedure 2 mineDependencies(Q, H(Q, G))
Require: A graph pattern Q, and its homomorphic matches H(Q, G) in G
Ensure: A set Σ of minimal GEDs over Q in G
1: Σ := ∅; L[0] := ∅; N := no. of unique attributes in Q
2: T ←form pseudo-relation of H(Q, G) over Q
3: L[1] ←generateLiteralSetPartitions(Q[¯u], T )
4: LHS ←L[0]; RHS ←L[1]
5: Σ ←validateDependencies(LHS, RHS)
6: for i = 2 to i = N −1 do
7:
if |L[i −1]| > 1 then
8:
for each pair (n1, n2) ∈L[i −1] × L[i −1] do
9:
n = n1 ∪n2
10:
if n is permissible then
▷Lemma 2
11:
L[i] := L[i] ∪n
12:
LHS ←L[i −1]; RHS ←L[i]
13:
Σ := Σ ∪validateDependencies(LHS, RHS)
14: return Σ
mining tasks.
4.2.2. Partitioning
Next, we transform the input table into structures for efficient mining
of rules. In the following, we extend the notions of equivalence classes and
partitions [25] of attribute value pairs over pattern matches. This enables
the adaption and use of relevant data structures, and efficient validation of
candidate dependencies.
19

---

Figure 6: Example of pseudo-relation over pattern Q3 in Figure 1(d)
Definition 2 (Equivalence classes, partitions). Let H be the set of all
matches of a graph pattern Q[¯u] in G, and X be a set of literals in ¯u. The
partition of H by the set X of literals, denoted by π(X, H), is the set of non-
empty disjoint subsets, where each subset contains all matches that satisfy X
with same value. For brevity, we write π(X, H) as π(X), when the context
is clear.
Given X, H: π(X, H) = T
w∈X π(w, H), where w 2 is a literal over pattern
variable(s) in Q[¯u]. Two sets of literals X, X′ are equivalent w.r.t. H, iff:
π(X, H) = π(X′, H). □
From the semantics of GED satisfaction and Definition 2, the following
Lemma holds.
Lemma 1. A dependency X →Y holds over the pattern Q[¯u] in G iff:
π(X, H) = π(X ∪Y, H).
In Function 2, we presents the process of partitioning pattern variables
in Q[¯u] of a given pseudo-relational table T . Lines 2–5 generates constant
2for x, y ∈¯u, w can be: (x.A = c), or (x.A = y.A′), or (x.id = y.id)
20

---

(b) Equivalence Classes of Single Itemsets
(a) Single Attribute Literal (Itemset) Generation 
x: 
a1 = (name, EA),  { {h2, h3, h4} }
a2 = (name, GL), { {h1} }
y: 
b1 = (name, F20), { {h2, h3, h4} }
b2  = (name, AF9), { {h1} }
c1 = (genre, racing), { {h1} }
c2 = (genre, soccer), { {h2, h3, h4} }
d1 = (year, 2018), { {h1} }
d2 = (year, 2019), { {h2, h3, h4} }
e1 = (price, 50), { {h1} }
e2 = (price, 55), { {h2, h3} }
e3 = (price, 60), { {h4} }
y': 
b3 = (name, AF11), { {h1} }
b4 = (name, F20), { {h2} }
b5 = (name, F21), { {h3, h4} }
c3 = (genre, racing), { {h1} }
c4 = (genre, soccer), { {h2, h3, h4} }
d3 = (year, 2018), { {h1} }
d4 = (year, 2019), { {h2} }
d5 = (year, 2020), { {h3, h4} }
y, y': 
b6 = (name), { {h2} }
c5 = (genre), { {h1}, {h2, h3, h4} } 
d6 = (year), { {h1}, {h2} }
P1:: { {h1} }
a2 = (x, name, GL)
b2 = (y, name, AF9)
c1 = (y, genre, racing)
d1 = (y, year, 2018)
e1 = (y, price, 50)
b3 = (y', name AF11)
c3 = (y', genre, racing)
d3 = (y', year, 2018)
P2:: { {h2, h3, h4} }
a1 = (x, name, EA)
b1 = (y, name, F20)
c2 = (y, genre, soccer)
d2 = (y, year, 2019)
c4 = (y', genre, soccer)
P5: { {h2} }
b4 = (y', name, F20)
d4 = (y', year, 2019)
b6 = (y, y', name)
P6: { {h2, h3} }

e2 = (y, price, 55)
P8:: { {h4} }

e3 = (y, price, 60)
P4: { {h3, h4} }
b5 = (y', name, F21)
d5 = (y', year, 2020)
P7: { {h1}, {h2} }
d6 = (y, y', year)
P3: { {h1}, {h2, h3, h4} }
c5 = (y, y', genre)
A1
A2
A3
A4
A5
A2
A2
A3
A4
A3
A4
Figure 7: Example of Pattern Variable Partitions & Equivalence Classes.
Function 2 generateLiteralSetPartitions(Q[¯u], T )
1: L[1] = ∅
2: for each pattern variable x ∈Q[¯u] do
▷constant literals
3:
for each attribute x.A ∈T do
4:
L := {X = (c, x.A) | ∀c ∈adom(x.A) ∧π(X, H(Q, G))̸ = ∅}
5:
L[1].add(n): n = (X, π(X, H))
6: for each pair x, y ∈Q[¯u] do
▷variable literals
7:
L := {X = (x.A = y.A′) | A, A′ ∈T ∧π(X, H(Q, G))̸ = ∅}
8:
L[1].add(n): n = (X, π(X, H))
9: return L[1]
literals, whereas Lines 6–8 of the function generates variable and id literals.
We remark that appropriate preprocessing (based on domain knowledge)
from the previous step ensures only semantically meaningful pattern variable
pairs are considered for variable literals.
21

---

In the following example, we show the partitions and equivalence classes
of a toy example.
Example 4. Suppose pseudo-relational in Figure 6 captures the attributes
of the homomorphic matches of pattern Q3 in Figure 1. Figure 7 shows the
resulting partitions and equivalence classes. We remark that, in this example,
no id literals are produced due to unique node identities in Figure 6.
4.2.3. Candidate dependency generation
Here, we discuss the data structures and strategies for generating candi-
date dependencies. We extend and model the search space of the possible
dependencies with the attribute lattice [39]. We adopt a level-wise top-down
search approach for generating candidate rules, testing/validating them and
using the valid rules to prune the search space.
In general, a node n in the lattice is a pair n = (X, π(X)). However, for
non-redundant generation and pruning of candidate sets X, Y , we organise
literal sets of each node under their respective pattern variable(s). For ex-
ample, Figure 8 (a) shows a snapshot of the lattice for generating candidate
dependencies (for the running example in Figure 6 and Figure 7). Further,
parts (b), (c) and (d) of Figure 8 show all nodes in level 1, and some of the
nodes for level 2 and 3 respectively.
To generate the fist level, L[1], nodes in the lattice, we use the single at-
tribute partition of variables in the previous step (i.e., output of Function 2).
Further, to derive nodes for higher levels of the lattice, we follow the fol-
lowing principles in Lemma 2 to ensure redundancy-free and valid literal set
generation.
22

---

{}
A1
A2
A3
A5
A4
A2
A1
A3
A1
A5
A4
A2
A1
A3
A4
A3
A5
A4
A1
A2
A1
A4
A2
A1
A3
A4
A2
A1
A3
A5
A2
A1
A3
A4
A5
A4
A3
A5
A2
. . .
. . .
. . .
A5
A1
A2
A1
A5
a1
a2
b4
b5
b1
b2
b3
x
y
y'
(y, y')
b6
c4
c1
c2
c3
y
y'
(y, y')
c5
d4
d5
d1
d2
d3
y
y'
(y, y')
d6
e2
e3
e1
y
a2
b4
a2
b5
a1
b1
a1
b2
a2
b3
x + y
x + y'
x + (y, y')
a1
b6
a2
b1
a2
b2
a1
b4
a1
b5
a1
b3
a2
b6
a1
c1
a1
c2
a2
c4
x + y
x + y'
x +(y, y')
a1
c5
a2
c1
a2
c2
a1
c4
a2
c3
a1
c3
a2
c5
a1 b2
c1
a2 b1
c2
x + y
x + y' + (y, y')
a1 b4
c5
a1 b5
c5
a1 b2
c3
a2 b1
c4
x + y + y'
a1 b2
c5
a2 b1
c5
x + y + (y, y')
a1 b6
c5
x + (y, y')
won't be generated - intersection 
of the partitions empty (only shown
for illustration)
won't be generated - dependency 
exists from previous level (only 
shown for illustration)
won't be generated - literals 
have empty partition (only shown 
for illustration)
valid candidate literals
must be generated
Legend for Generating Candidate Nodes
a) Model of Entire Lattice Search Space
b) Level 1 Candidate Literals
c) Some Level 2 Candidate Literals
d) Some Level 3 Candidate Literals
A1:
A1A2:
A2:
A4:
A3:
A1A2A3:
A1A3:
A5:
Figure 8: GED Lattice: Generation, Search & Traversal (best viewed in colour)
Lemma 2 (Permissible Node). Let L[i] be the list of nodes at a current
level i of the lattice, with at least two nodes L[i] = [n1 = (X1, π(X1)), n2 =
(X2, π(X2))].
We generate a new node n = (X, π(X)) ∈L[i + 1] using
n1, n2, with the following properties: (a) X = X1 ∪X2; and (b) π(X) =
π(X1) ∩π(X2). We say n is permissible iff: (i) |X| > i, (ii) ∄w, w′ ∈
X, such that x.A ∈w, w′ and (iii) π(X)̸ = ∅. □
For every node pair n1, n2 ∈L[i] that results in a permissible node n ∈
L[i + 1], we establish the edges n1 →n and n2 →n representing candidate
dependencies. All candidate dependencies are tested for validity in the next
step. We illustrate the candidate dependency generation with our running
example below.
23

---

Function 3 validateDependencies(LHS, RHS)
1: Σ := ∅
2: for each node ni = (Xi, π(Xi)) ∈LHS do
3:
for each node nj = (Yj, π(Yj)) ∈RHS do
4:
if Xi ⊂Yj and π(Xi) = π(Yj) then
5:
σ := (Q[¯u], Xi →(Yj \ Xi))
6:
Σ := Σ ∪σ
7:
RHS := RHS \ nj
8: return Σ
Example 5 (Generating and searching the lattice space). Figure 8 shows
the general attribute lattice (left) and the extended literal set nodes associated
with some of attribute sets (right). For brevity and clarity of presentation, we
omit the partition set of nodes, and colour-code the non-permissible nodes.
Candidate rules in L[0], L[1] are of the form: ∅→Y , where Y is a
single-attribute literal in L[1] (i.e., every level 1 node). The set of candidate
rules in L[1], L[2] over the edge A1 →A1A2 take the form: X →Y , where
X ∈{{a1}, {a2}} and Y ∈{{a1, b1}, {a1, b2}, · · · , {a1, b6}, {a2, b6}}. □
4.2.4. Validation of dependencies
We use a level-wise traversal of search space to validate the generated
candidate rules between two successive levels in the lattice. That is, for any
two levels L[i] and L[i + 1], correspond to the set of LHS, RHS candidates
respectively. For any edge X →Y within LHS, RHS, we test the dependency
X →Y \X. Function 3 performs this task, and its process is self-explanatory.
In Line 4, Xi ⊂Yj is true for all candidate dependencies (i.e., the edge
24

---

Xi →Yj exists). If the dependency holds (i.e., π(Xi) = π(Yj) by Lemma 1),
we add the GED to the set, and prune the node search space accordingly
(Lines 5–7).
In Example 6, we show the validation of some candidate GEDs in our
running example.
Example 6 (Validation of candidate GEDs). Consider the candidate GEDs
in L[0], L[1] in level 1 of the lattice, from Example 5. It is easy to verify none
of the candidates are valid, since the only literal set X ∈L[0], has the property
X = (∅, π(∅, H)). Note that (π(∅, H) = {h1, h2, h3, h4}. More specifically,
π(X)̸ = π(X ∪Y ), ∀Y ∈L[1].
Similarly, we can verify the GED X →Y holds in L[1], L[2], where X =
({b1}, π({b1})), Y
= ({a1, b1}, π({a1, b1})), since π({b1}) = π({a1, b1}).
Therefore, we can form the GED (Q3[x, y, y′], y.name = F20 →x.name =
EA), and prune the node n = ({a1, b1}, π({a1, b1})) ∈L[2]. □
4.3. Minimal cover set discovery and ranking of GEDs
In this phase of the GED mining process, we perform further analysis
of all mined rules in Σ from the previous step to determine and eliminate
all redundant or implied rules. Furthermore, we introduce a measuure of
interestingness to score and rank the resulting cover set Σc of GEDs.
4.3.1. Minimal cover set
From the foregoing, every GED φ ∈Σ is minimal (cf., Section 3). How-
ever, Σ may not be minimal as there may exist redundant GEDs due to
the transitivity property of GEDs.
More specifically, consider the follow-
ing dependencies in Σ := {φ1, φ2, φ3}; where φ1 = (Q[¯u], X →Y ), φ2 =
25

---

Function 4 findCover(Σ)
1: Σc := ∅, Γ := ∅
2: for each φ = (Q[¯u], X →Y ) ∈Σ do
3:
create the edge e : X →Y in Γ
4:
if e completes a triangle t ∈Γ then
5:
analyse transitivity and prune t
6: for each remaining edge e ∈Γ do
7:
add the corresponding GED of e to Σc
8: return Σc
(Q[¯u], Y →Z) and φ3 = (Q[¯u], X →Z). We say φ3 is transitively implied in
Σ, denoted by φ3 ⊨Σ as Σ \ φ3 ≡Σ. That is, the set Σ′ := {φ1, φ2} ≡Σ,
and Σ′ is minimal.
Thus, it suffices to eliminate all transitively implied GEDs in Σ to produce
a minimal cover Σc of Σ. We use a simple, but effective process in Function 4
to eliminate all transitively implied GEDs in Σ, and produce Σc. We create
a graph Γ with all GEDs in Σ such that each node corresponds to unique
literal sets of the dependencies (i.e., Lines 2, 3). We remark that, if there
exists transitivity in Σ, triangles (aka. 3-cliques) will be formed in Γ (cf.,
Lines 4–5), and a minimal set Σc be returned (Lines 6–8).
4.3.2. Ranking GEDs
We present a measure to score the interestingness of GEDs as well as a
means to rank rules in a given minimal cover Σc. We adopt the minimum
description length (MDL) principle[46] to encode the relevance of GEDs. The
26

---

MDL of a model m is given by:
mdl(m, data) = cost(data|m) + α × cost(m),
where cost(data|m), cost(m) represent the cost of encoding errors by the
model, and cost of encoding the model itself, and α is a hyper-parameter for
trade-off between the two costs.
We propose in Equation 4.1 below a measure for scoring the interesting-
ness, rank(φ, G), of a GED φ = (Q[¯u], X →Y ) in a graph G as:
rank(φ, G) = α × (1 −ς(φ)) + (1 −α) × k
N ,
(4.1)
where: 1) ς(φ) is the ratio |π(X∪Y )|
|H|
∈[0, 1], 2) k is the number of unique
attributes in X ∪Y ∈[0, N], 3) N is the total number of attributes over
all matches H of Q[¯u], and 4) α ∈[0, 1] is a user-specified parameter to
manipulate the trade-off between the two terms.
In line with MDL, the lower the rank of a GED, the more interesting it
is. We perform an empirical evaluation of the score in the following section.
4.4. Complexity of Proposed Solution.
Here, we present sketch of the time complexity of our GED mining ap-
proach.
The key tasks in our solution are: the frequent subgraph min-
ing (FSM), and the attribute (entity) dependency mining (ADM) over the
matches of the frequent subgraphs. Thus, we present the theoretical and
practical complexity of both tasks below.
FSM Complexity. Let |G| and k denote the number of nodes in a given graph
and the largest graph pattern size respectively. Overall, in the worse case,
27

---

the complexity of the FSM process is O(2|G|2 ·|G|k) (cf. details in [28]). This
exponential time complexity w.r.t. |G| is a major performance bottleneck,
as stated in Section 1. Hence the graph splitting heuristic strategy to reduce
|G| via dense community detection (cf. subsection 4.1). Thus, in practice,
our FSM time is O(C ·2|N|2 ·|N|k) ≈O(2|N|2 ·|N|k), where C << |N| << |G|
is the largest community size and C is the total number of communities.
Further, performing a homomorphic matching from a k-sized subgraph
to G, can be done, in the worse case, in O(|G|2 · k) time (cf. [38] and [50]).
Thus, overall time complexity for FSM is roughly O(2|N|2 · |N|k + |G|2).
ADM Complexity. Here we examine the complexity of searching and validat-
ing all dependencies over the graph patterns. Let |¯u|, m, |H| be the number
of nodes in a given graph pattern Q[¯u], maximum number of attributes per
pattern variable x ∈¯u, and the total number of matches of Q[¯u] in G.
Then, the complexity of generating partitions of H by literals of ¯u is
O(|¯u|2 · m · |H|) ≈O(m|H|); since in practice, |¯u| << m << |H| (cf.
Function 2). Moreover, the search space of candidate GEDs is 2m·|¯u|2. Thus,
to generate, search & validate, and reduce candidate GEDs over Q[¯u] in H,
requires O(|¯u|2m|H| + 2m|¯u|2|H| + |Σ| + |E(Γ)|) ≈O(mH + 2m|H| + |Σ|) in
the worse case (cf. Functions 3 and 4), where |Σ| is the number of valid rules,
and |E(Γ)| ≤|Σ| is the total edges in the rules graph Γ.
5. Empirical Study
In this section, we present an evaluation of the proposed discovery ap-
proach using real-world graph data sets. In the following, we discuss the
28

---

Table 2: Summary of the data sets
Data Set
#Nodes
#Edges
#Node Types
#Edge Types
Density
DBLP
300K
800K
3
3
8.65 × 10−6
IMDB
300K
1.3M
5
8
1.25 × 10−5
YAGO4
4.37M
13.3M
7764
83
8.70 × 10−6
setting of the experiments, examine the scalability of the proposed algo-
rithm, compared our solution to relevant related works in the literature, and
demonstrate the usefulness of some of the mined GEDs in various down-
stream applications.
5.1. Experimental Setting
Here, we cover the data sets used and the setting of experiments.
Data Sets. We used three real-world benchmark data sets with different
features and sizes, summarised in Table 2.
The DBLP [40] is a citation
network with 0.3M nodes of 3 types and 0.8M edges of 3 types; IMDB [41]
is a knowledge graph with 0.3M nodes of 5 types and 1.3M edges of 8 types;
and YAGO4 [42] is a knowledge graph with 4.37M nodes with 7764 types
and 13.3M edges with 83 types. In line with [27], we use the top five most
frequent attribute values in the active domain of each attribute to construct
constant literals.
Experiments.
All the proposed algorithms in this work were imple-
mented in Java; and the experiments were conducted on a 2.20GHz Intel
Xeon processor computer with 128GB of memory running Linux OS. We
experimentally evaluated our proposed method to show its: (1) the scal-
ability, (2) relative performance w.r.t.
mining other (related) graph con-
29

---

straints/dependencies in the literature, (3) the potential usefulness of the
mined GEDs. Unless otherwise specified, we fix the resolution parameter γ
to 1.0, and the minimum MNI threshold τ to 5000 in all experiments. All
experiments were conducted twenty-five (25) times, and report the average
of all results.
5.2. Scalability of proposal
Based on the complexity analysis of our proposition in Section 4.4, the
key parameters that impact the time performance include: the size of the
input graph |G|, size of graph patterns k, and number of attributes m per
pattern variable. Thus, in this set of experiments, we investigate the time
performance of the proposed solution on all three data sets with respect to
varying: a) input graph sizes |G| (Exp-1a), b) graph pattern sizes k (Exp-1b),
and c) number of attributes m on nodes (Exp-1c).
Exp-1a. In this experiment, we fix the number of attributes on every
node to seven (7) in all three data sets. We used the full graph of DBLP,
sampled comparable sizes of IMDB and YAGO4 graphs. Figure 9 (a) presents
a plot of the discovery time (in seconds, on a log-scale) against different sizes
of the three data sets, with their corresponding standard deviations (SD) in
Table 3.
Table 3: SD of Times in Figure 9 (a)
100K
200K
300K
DBLP
2.927
5.266
7.236
YAGO4
0.095
0.413
6.741
IMDB
4.491
0.749
23.066
Table 4: SD of Times in Figure 9 (c)
2
3
4
5
DBLP
0.09
2.16
1.90
2.67
YAGO4
5.12
11.94
10.76
19.0
IMDB
7.06
14.30
23.07
20.95
30

---

1
16
256
4096
100K
200K
300K
(a) Discovery Time vs No. Graph Nodes
DBLP
IMDB
YAGO4
log scale
Time (s)
# Nodes
1
201
401
601
801
DBLP
IMDB
YAGO4
Hundreds
(b) No. of GEDs Mined in Various Sizes of 
Data Sets
300K
200K
100K
1
16
256
4096
2
3
4
5
6
7
(d) Discovery Time vs No. of Attributes
DBLP
YAGO4
IMDB
No. of Attributes
log scale
Time (s)
16
512
16384
2
3
4
5
(c) Discovery Time vs Pattern Sizes
DBLP
IMDB
YAGO4
log scale
Time (s)
Pattern Size
Figure 9: Scalability of proposed approach
In general, GED discovery in the DBLP data is the most efficient as it
produces the least number of matches for its frequent patterns compared to
the other data sets. This characteristics is captured by the density of the
graphs (in Table 2). In other words, the more dense/connected a graph is,
the more likely it is to find more matches for graph patterns. Consequently,
the longer the GED discovery takes.
The distribution of discovered GEDs, for different sizes of the three data
sets is presented in Figure 9 (b) – with the YAGO4 and DBLP data sets
producing the most and least number of GEDs in almost all cases respectively.
Exp-1b.
Here, we examine the impact of graph pattern sizes on the
discovery time. We use the number of nodes in a graph pattern as its size –
considering patterns of size 2 to 5. For each data set, we mine GEDs over
31

---

patterns size 2 to 5, using the full graph with up to seven (7) attributes per
node.
The result of the time performance for different sizes of patterns are pre-
sented in Figure 9 (c), with corresponding standard deviations in Table 4. In
this experiment, the IMDB and YAGO4 data sets produced comparable time
performances, except for the case of patterns with size 5. In the exceptional
case, we found significantly more matches of size-5 patterns in the IMDB
data, which is reflected in the plot.
Exp-1c.
This set of experiments examine the impact of the number
of attributes on the discovery time in all data sets, varying the number of
attributes on each node in the graphs from 2 to 7. The time performance
of graph patterns of all sizes on the three datasets is averaged as the final
result.
The plots in Figure 9 (d) show the discovery average time characteristics
Table 5: SD of Times in Figure 9 (d)
2
3
4
5
6
7
DBLP
0.04
0.02
0.03
0.07
0.04
0.27
YAGO4
0.02
0.07
0.06
0.13
0.27
0.60
IMDB
0.05
0.12
0.88
2.76
2.03
2.32
for all three data sets with in-
creasing number of attributes
(for patterns with sizes from 2
to 5), with standard deviations
in Table 5. As can be seen from
all three line graphs, the number of attributes directly affects the time per-
formance, as expected by the analysis of the characteristics (cf. Section 4.4).
5.3. Comparison to mining other graph constraints
The notion of GEDs generalises and sunbsumes graph functional depen-
dencies (GFDs) and graph keys (GKeys). Thus, we show in this group of
experiments that our proposal can be used for mining GFDs and GKeys via
32

---

two simple adaptions. First, we replace the graph pattern matching seman-
tics from homomorphism to isomorphism in accordance with the definitions
of GFDs and GKeys. Second, we consider only id-literal RHSs for GKey
mining, and no id-literals in GFD mining.
1
4
16
64
256
1024
4096
16384
DBLP
YAGO4
IMDB
(a) Relative Performance: GED, GFD, GKey
GKey
GFD
GED
log-scale Time (s)
1
16
256
4,096
65,536
1,048,576
DBLP
YAGO4
IMDB
(b) Relative No. of Rules: GED, GFD, GKey
GED
GFD
GKey
log-scale
#Rules
Figure 10: The performance comparison of mining GED, GFD and Gkey
In Figure 10, we present a summary of the comparative analysis of mining
GEDs, GFDs and GKeys. Parts (a) of the plot represents the relative time
performance of mining the three different graph constraints over the DBLP,
YAGO4 and IMDB data sets respectively. In each experiment, we show the
performance for up to the five (5) graph patterns (using the top five most
frequent patterns in each data set).
Table 6: SD of Times in Figure 10 (a)
GED
GFD
GKey
DBLP
0.71
0.35
0.60
YAGO4
1.92
0.86
0.87
IMDB
15.67
14.85
16.20
As expected, the differences in the
time performances are minimal in all
cases, as we have optimised: a) the match-
ing efficiency of homomorphism vs. iso-
morphism; and b) the number of literals
considered for each dependency/constraint type. Table 6 presents the stan-
dard deviation of the time performance on all datasets.
33

---

Q5
x1
x2
x3
parent
parent
person
person
person
Q6
x1
x2
parent
child
person
person
Q7
x
y1
y2
sub_eventsub_event
sport 
event
event series
sport 
event
Q8
z
y1
y2
award
movie
person
x
won
won
won
won
director
award
Figure 11: Graph patterns for some GEDs in YAGO4
Furthermore, we show in Figure 10 (b) the number of discoveries for each
constraint over all datasets. In particular, the number of GEDs versus GFDs
is consistently similar in all datasets; and GKeys are the smallest sized rules
as the RHSs are restricted to onlyid-literals.
5.4. Usefulness of mined rules
In this section, we present some examples of the discovered GEDs with a
discussion of their potential use in real-world data quality and data manage-
ment applications. Further, we discuss interestingness ranking of the mined
GEDs.
Examples of discovered GEDs. We manually inspected the mined
GEDs and validated their usefulness. We present 3 GEDs found in the YAGO4
data, with patterns shown in Figure 11 as follows:
σ1 : Q5[x1, x2, x3], {x1.dob = 1777-04-24, x2.dod = 1792-03-01, x3.name =
‘Leopold II, Holy Roman Emperor’} →x2.id = x3.id.
σ2 : Q6[x1, x2], ∅→x1.surname = x2.surname.
σ3 : Q7[x, y1, y2], x.name = ‘2018 Wuhan Open’ →x1.prefixname = x2.prefixname.
34

---

σ4 : Q8[x, y1, y2, z], x.name = ‘Akira Kurosawa’∧y1.name = ‘Golden Lion’∧
y2.url = ‘http:www.labiennale.org’ ∧z.name = ‘Rashomon’ →
y1.id = y2.id
The GED σ1 states that for any match of the pattern Q5 in the
YAGO4 graph, if the person x1 is born on 1777-04-24, and has a
parent x2 whose date of death is 1792-03-01 with another parent x3
named ‘Leopard II, Holy Roman Emperor’, then x2, x3 refer to the same
person.
This GED is verifiable true (see the Wikipedia record here3)
– as person x1 is the ‘Archduchess Maria Clementina of Austria’
a
child
of
‘Leopard II, Holy Roman
Emperor’.
The
discovery
of
σ1
in
the
YAGO4
data
signifies
duplicate
person
entities
for
‘Leopard II, Holy Roman Emperor’. Thus, a potential use for this GED
can be for the disambiguation or de-duplication (entity linkage) of said enti-
ties in the graph.
Furthermore, σ2 states that for any matches of the parent-child pattern
Q6, the child x1 and parent x2 must share the same last name. The GED σ3
claims that for any two sport events y1, y2 in the 2018 Wuhan Open event se-
ries x; y1, y2 must share the same event prefixName. Indeed, these GED are
straightforward and understandable; and can be used for violation or incon-
sistency detection in the graph through the validation of the dependencies.
For example, σ2 can be used to check all parent-child relationships that do
not have the same surname, whiles σ3 can be employed to find any sub-event
in the ‘2018 Wuhan Open’ that violate the prefix-naming constraints. The
3https://en.wikipedia.org/wiki/Archduchess_Maria_Clementina_of_Austria
35

---

0
0.2
0.4
0.6
0.8
1
1 2 3 4 5 6 7 8 9 1011121314151617181920
(b) IMDB: Top GED Ranks
𝝰=0
𝝰=0.5
𝝰=1
Rank
0
0.2
0.4
0.6
0.8
1
1 2 3 4 5 6 7 8 9 1011121314151617181920
(c) YAGO4: Top GED Ranks
𝝰= 0
𝝰=0.5
𝝰=1
Rank
0
0.2
0.4
0.6
0.8
1
1 2 3 4 5 6 7 8 9 1011121314151617181920
(a) DBLP: Top GED Ranks
𝝰=0
𝝰=0.5
𝝰=1
Figure 12: Top ranked GEDs w.r.t. α settings
GED σ4, like σ1, is an example of a GKey (i.e., have RHS id-literals). Thus,
useful for entity resolution or de-duplication.
The rank of GEDs. In the following, we show a plot of the interest-
ingness scores of the discovered GEDs, for three different α values (i.e. 0,0.5
and 1, respectively). For brevity, and lack of space, we show the results for
only the top K = 20 GEDs in Figure 12. A lower interestingness score is
representative of better GED, and vice versa. The plot shows the interest-
ingness score is effected by the value of α, and ranking GEDs makes it easier
for users to find meaningful GEDs. For α = 0, the rank score reflects the
complexity of the GED, whereas α = 1 reflects the persistence of the rule in
data. And, α = 0.5 combines both with equal weight.
6. Related Work
In this section, we review related works in the literature on the discovery
of graph data constraints. Mining constraints in graph data has received in-
creasing attention in recent years. In the following, we present some relevant
related works in two broad categories.
36

---

6.1. Rule discovery in non-property graphs.
Most research on profiling and mining of non-property graph data focus
on XML and RDF data (cf. [47]). For instance, [48, 49, 52] investigate the
problem of mining (path) association rules in RDF data and knowledge bases
(KBs), whereas [53, 54, 55, 56] present inductive logic programming based
rule miners over RDF data and KBs.
In contrast to the above-mentioned works, this paper studies the mining
of functional (both conditional and entity) dependencies in property graphs.
However, our proposed method can be adapted for mining rules in RDF data,
particularly, GEDs with constant literals.
6.2. Rule discovery in property graphs.
More related to this work, are techniques for rule discovery in prop-
erty graphs.
Examples of some notable works in this area include:
1) [17, 27, 57, 58, 59], which investigated the discovery of association rules
in property graphs; and 2) [12, 16, 22, 60] on mining keys and dependen-
cies in property graphs—closest to this work. In particular, [12] presents
a frequent sub-graph expansion based approach for mining keys in prop-
erty RDFs, whiles [16] proposes efficient sequential and parallel graph func-
tional dependency discovery for large property graphs. The main distinction
between the GFD discovery approach in [16] and our work is on how the
efficiency bottlenecks are handled. Specifically, [16] employs fixed parame-
terization to bound the sized of patterns to be mined, whereas we modulate
the graph and mine graph patterns from dense communities in the graph.
Furthermore, we devise a level-wise search strategy to find and validate rules
37

---

via an itemset lattice, while the sequential technique in [16] finds GFDs via
a vertical and horizontal spawning of generation trees.
Moreover, the work in [60] studies the discovery of temporal GFDs –
GFDs that hold over property graphs over periods of time; and [22] studies
the discovery of graph differential dependencies (GDDs)—GEDs with dis-
tance semantics—over property graphs. Although related, this work differs
from mining temporal GFDs as we consider only one time period of graphs.
And, we do not consider the semantics of difference in data as captured in
GDDs. Essentially, GEDs can be considered a special case of GDDs, where
the distance is zero over all attributes.
7. Conclusion
In this paper, we presented a new approach for mining GEDs.
The
developed discovery pipeline seamlessly combines graph partitioning, non-
redundant and frequent graph pattern mining, homomorphic graph pattern
matching, and attribute/entity dependencies mining to discover GEDs in
property graphs. We develop effective pruning strategies and techniques to
ensure the returned set of GEDs is minimal, without redundancies. Further-
more, we propose an effective MDL-based measure to score the interesting-
ness of GEDs. Finally, we performed experiments on large real-world graphs,
to demonstrate the feasibility, effectiveness and scalability of our proposal.
Indeed, the empirical results are show our method is effective, salable and
efficient; and finds semantically meaningful rules.
38

---

Acknowledgment
This work was supported in part by Inner Mongolia Key Scientific and
Technological Project under Grant 2021ZD0046, and in part by Innovation
fund of Marine Defense Technology Innovation Center under Grant JJ-2021-
722-04, and in part by the Major Project of Hubei Hongshan Laboratory un-
der Grant 2022HSZD031, and in part by the open funds of the National Key
Laboratory of Crop Genetic Improvement, Huzhong Agricultural University,
and in part by the open funds of the State Key Laboratory of Agricultural
Microbiology, Huzhong Agricultural University, and in part by 2021 Open
Project of State Key Laboratory of Hybrid Rice, Wuhan University, and in
part by the Fundamental Research Funds for the Chinese Central Universities
under Grant 2662020XXQD01 and 2662022JC004.
References
[1] Fan, W., Fan, Z., Tian, C. and Dong, X.L., 2015. Keys for graphs.
Proceedings of the VLDB Endowment, 8(12), pp.1590-1601.
[2] Fan, W., Wu, Y. and Xu, J., 2016, June. Functional dependencies for
graphs. In Proceedings of the 2016 International Conference on Man-
agement of Data (pp. 1843-1857).
[3] Ma, H., Alipourlangouri, M., Wu, Y., Chiang, F. and Pi, J., 2019.
Ontology-based entity matching in attributed graphs. Proceedings of
the VLDB Endowment, 12(10), pp.1195-1207.
[4] Fan, W. and Lu, P., 2017, May. Dependencies for Graphs. In 36th ACM
SIGMOD-SIGACT-SIGAI Symposium on PODS (pp. 403-416). ACM.
39

---

[5] Fan, W. and Lu, P., 2019. Dependencies for graphs. ACM Transactions
on Database Systems (TODS), 44(2), pp.1-40.
[6] Fan, W., Geng, L., Jin, R., Lu, P., Tugay, R. and Yu, W., 2022, May.
Linking Entities across Relations and Graphs. In 2022 IEEE 38th Inter-
national Conference on Data Engineering (ICDE) (pp. 634-647). IEEE.
[7] Liu, J., Li, J., Liu, C. and Chen, Y., 2010. Discover dependencies from
data—a review. IEEE Transactions on Knowledge and Data Engineer-
ing, 24(2), pp.251-264.
[8] Abedjan, Ziawasch, Lukasz Golab, and Felix Naumann. ”Profiling rela-
tional data: a survey.” The VLDB Journal 24, no. 4 (2015): 557-581.
[9] Caruccio, Loredana, Vincenzo Deufemia, and Giuseppe Polese. ”Relaxed
functional dependencies—a survey of approaches.” IEEE Transactions
on knowledge and data engineering 28, no. 1 (2015): 147-165.
[10] Vezvaei, A., Golab, L., Kargar, M., Srivastava, D., Szlichta, J. and Zi-
hayat, M., 2022. Fine-Tuning Dependencies with Parameters. In EDBT
(pp. 2-393).
[11] Zada MS, Yuan B, Anjum A, Azad MA, Khan WA, Reiff-Marganiec
S. Large-scale Data Integration Using Graph Probabilistic Dependen-
cies (GPDs). In 2020 IEEE/ACM International Conference on Big Data
Computing, Applications and Technologies (BDCAT) 2020 Dec 7 (pp.
27-36). IEEE.
[12] Alipourlangouri, M. and Chiang, F., 2018. Keyminer: Discovering keys
for graphs. In VLDB workshop TD-LSG.
40

---

[13] Kwashie, S., Liu, J., Li, J. and Ye, F., 2015, September. Conditional
Differential Dependencies (CDDs). In East European Conference on
Advances in Databases and Information Systems (pp. 3-17). Springer,
Cham.
[14] Kwashie, S., Liu, J., Li, J. and Ye, F., 2014, July. Mining differential
dependencies: a subspace clustering approach. In Australasian Database
Conference (pp. 50-61). Springer, Cham.
[15] Kwashie, S., Liu, J., Li, J. and Ye, F., 2015, June. Efficient discovery
of differential dependencies through association rules mining. In Aus-
tralasian Database Conference (pp. 3-15). Springer, Cham.
[16] Wenfei Fan, Chunming Hu, Xueli Liu, and Ping Lu. 2020. Discover-
ing Graph Functional Dependencies. ACM Trans. Database Syst. 45, 3,
Article 15 (September 2020), 42 pages.
[17] Wenfei Fan, Xin Wang, Yinghui Wu, and Jingbo Xu. 2015. Association
rules with graph patterns. Proc. VLDB Endow. 8, 12 (August 2015),
1502–1513.
[18] Thorsten Papenbrock and Felix Naumann. 2016. A Hybrid Approach to
Functional Dependency Discovery. In Proceedings of the 2016 Interna-
tional Conference on Management of Data (SIGMOD ’16). Association
for Computing Machinery, New York, NY, USA, 821–833.
[19] Papenbrock, Thorsten, Sebastian Kruse, Jorge-Arnulfo Quian´e-Ruiz,
and Felix Naumann. ”Divide & conquer-based inclusion dependency dis-
covery.” Proceedings of the VLDB Endowment 8, no. 7 (2015): 774-785.
41

---

[20] Lin, P., Song, Q. and Wu, Y., 2018. Fact checking in knowledge graphs
with ontological subgraph patterns. Data Science and Engineering, 3(4),
pp.341-358.
[21] Fan, W., Lu, P., Tian, C. and Zhou, J., 2019. Deducing certain fixes to
graphs. Proceedings of the VLDB Endowment, 12(7), pp.752-765.
[22] Kwashie S, Liu L, Liu J, Stumptner M, Li J, Yang L. Certus: An effective
entity resolution approach with graph differential dependencies (GDDs).
Proceedings of the VLDB Endowment. 2019 Feb 1;12(6):653-66.
[23] Jixue Liu, Selasi Kwashie, Jiuyong Li, Feiyue Ye, and Millist Vincent.
Discovery of Approximate Differential Dependencies. cs.DB. 2013.
[24] Chiang, Fei, and Ren´ee J. Miller. “Discovering data quality rules.” Pro-
ceedings of the VLDB Endowment 1, no. 1 (2008): 1166-1177.
[25] Cosmadakis, Stavros S., Paris C. Kanellakis, and Nicolas Spyratos. “Par-
tition semantics for relations.” Journal of Computer and System Sciences
33, no. 2 (1986): 203-233.
[26] Rammelaere, Joeri, and Floris Geerts. “Revisiting conditional functional
dependency discovery: Splitting the “C” from the “FD”.” In Joint Eu-
ropean Conference on Machine Learning and Knowledge Discovery in
Databases, pp. 552-568. Springer, Cham, 2018.
[27] Fan, W., Fu, W., Jin, R., Lu, P. and Tian, C., 2022. Discovering as-
sociation rules from big graphs. Proceedings of the VLDB Endowment,
15(7), pp.1479-1492.
42

---

[28] Mohammed Elseidy, Ehab Abdelhamid, Spiros Skiadopoulos, and Panos
Kalnis. 2014. GraMi: frequent subgraph and pattern mining in a single
large graph. Proc. VLDB Endow. 7, 7 (March 2014), 517–528.
[29] Fiedler, M. and Borgelt, C., 2007, October. Subgraph support in a single
large graph. In Seventh IEEE International Conference on Data Mining
Workshops (ICDMW 2007) (pp. 399-404). IEEE.
[30] Kuramochi, M. and Karypis, G., 2005. Finding frequent patterns in a
large sparse graph. Data mining and knowledge discovery, 11(3), pp.243-
271.
[31] Ribeiro, P., Paredes, P., Silva, M.E., Aparicio, D. and Silva, F., 2021. A
survey on subgraph counting: concepts, algorithms, and applications to
network motifs and graphlets. ACM Computing Surveys (CSUR), 54(2),
pp.1-36.
[32] Jiang, C., Coenen, F., & Zito, M. (2013). A survey of frequent subgraph
mining algorithms. The Knowledge Engineering Review, 28(1), 75-105.
doi:10.1017/S0269888912000331
[33] Kasra Jamshidi, Rakesh Mahadasa, & Keval Vora. 2020. Peregrine: a
pattern-aware graph mining system. In Proceedings of the Fifteenth Eu-
ropean Conference on Computer Systems (EuroSys ’20). Association for
Computing Machinery, New York, NY, USA, Article 13, 1–16.
[34] Vinicius Dias, Carlos H. C. Teixeira, Dorgival Guedes, Wagner Meira,
and Srinivasan Parthasarathy. 2019. Fractal: A General-Purpose Graph
43

---

Pattern Mining System. In Proceedings of the 2019 International Confer-
ence on Management of Data (SIGMOD ’19). Association for Computing
Machinery, New York, NY, USA, 1357–1374.
[35] Traag, V. A., Van Dooren, P. & Nesterov, Y. Narrow scope for
resolution-limit-free community detection. Phys. Rev. E 84, 016114,
https://doi.org/10.1103/PhysRevE.84.016114 (2011).
[36] Xifeng Yan and Jiawei Han, “gSpan: graph-based substructure pattern
mining,” 2002 IEEE International Conference on Data Mining, 2002.
Proceedings., 2002, 721-724.
[37] Traag, V.A., Waltman, L. & van Eck, N.J. From Louvain to Lei-
den: guaranteeing well-connected communities. Sci Rep 9, 5233 (2019).
https://doi.org/10.1038/s41598-019-41695-z
[38] Mhedhbi, A. and Salihoglu, S., 2019. Optimizing subgraph queries
by combining binary and worst-case optimal joins. Proceedings of the
VLDB Endowment, 12(11), pp.1692-1704.
[39] R. Agrawal and R. Srikant. Fast algorithms for mining association rules
in large databases. In Proceedings of the 20th International Conference
on Very Large Data Bases, VLDB ’94, pages 487–499, San Francisco,
CA, USA, 1994. Morgan Kaufmann Publishers Inc.
[40] DBLP dataset. https://dblp.uni-trier.de/xml/
[41] IMDB dataset. http://www.imdb.com/interfaces.
44

---

[42] YAGO4 dataset. https://www.mpi-inf.mpg.de/departments/databases-
and-information-systems/research/yago-naga/yago/
[43] Luigi P. Cordella, Pasquale Foggia, Carlo Sansone, and Mario Vento, A
(Sub)Graph Isomorphism Algorithm for Matching Large Graphs, IEEE
Transactions on Pattern Analysis and Machine Intelligence, Vol. 26, NO.
10, 2004.
[44] Huhtala, Yka, Juha K¨arkk¨ainen, Pasi Porkka, and Hannu Toivonen.
“TANE: An efficient algorithm for discovering functional and approxi-
mate dependencies.” The computer journal 42, no. 2 (1999): 100-111.
[45] Bringmann B, Nijssen S. What is frequent in a single graph?. In Pacific-
Asia Conference on Knowledge Discovery and Data Mining 2008 May
20 (pp. 858-863). Springer, Berlin, Heidelberg.
[46] Peter D. Grunwald and Jorma Rissanen, The minimum description
length principle, MIT Press, 2022.
[47] Abedjan, Z., Golab, L., Naumann, F. and Papenbrock, T., 2018. Data
profiling. Synthesis Lectures on Data Management, 10(4), pp.1-154.
[48] Barati, M., Bai, Q. and Liu, Q., 2017. Mining semantic association rules
from RDF data. Knowledge-Based Systems, 133, pp.183-196.
[49] Abedjan, Z. and Naumann, F., 2013. Improving rdf data through asso-
ciation rule mining. Datenbank-Spektrum, 13(2), pp.111-120.
[50] Bi, F., Chang, L., Lin, X., Qin, L. and Zhang, W., 2016, June. Efficient
subgraph matching by postponing cartesian products. In Proceedings of
45

---

the 2016 International Conference on Management of Data (pp. 1199-
1214).
[51] Feng, Z., Mayer, W., He, K., Kwashie, S., Stumptner, M., Grossmann,
G., Peng, R. and Huang, W., 2020. A Schema-Driven Synthetic Knowl-
edge Graph Generation Approach With Extended Graph Differential
Dependencies (GDDxs). IEEE Access, 9, pp.5609-5639.
[52] Sasaki,
Y.,
2022. Path association rule mining. arXiv preprint
arXiv:2210.13136.
[53] Gal´arraga, L.A., Teflioudi, C., Hose, K. and Suchanek, F., 2013, May.
AMIE: association rule mining under incomplete evidence in ontological
knowledge bases. In Proceedings of the 22nd international conference on
World Wide Web (pp. 413-422).
[54] Chen, Y., Wang, D.Z. and Goldberg, S., 2016. ScaLeKB: scalable learn-
ing and inference over large knowledge bases. The VLDB Journal, 25(6),
pp.893-918.
[55] Lajus, J., Gal´arraga, L. and Suchanek, F., 2020, May. Fast and exact
rule mining with AMIE 3. In European Semantic Web Conference (pp.
36-52). Springer, Cham.
[56] Ortona, S., Meduri, V.V. and Papotti, P., 2018, April. Robust discovery
of positive and negative rules in knowledge bases. In 2018 IEEE 34th
International Conference on Data Engineering (ICDE) (pp. 1168-1179).
IEEE.
46

---

[57] Namaki, M.H., Wu, Y., Song, Q., Lin, P. and Ge, T., 2017, November.
Discovering graph temporal association rules. In Proceedings of the 2017
ACM on Conference on Information and Knowledge Management (pp.
1697-1706).
[58] Fan, W., Jin, R., Liu, M., Lu, P., Tian, C. and Zhou, J., 2020. Capturing
associations in graphs. Proceedings of the VLDB Endowment, 13(12),
pp.1863-1876.
[59] Huang, C., Zhang, Q., Guo, D., Zhao, X. and Wang, X., 2022. Dis-
covering Association Rules with Graph Patterns in Temporal Networks.
Tsinghua Science and Technology, 28(2), pp.344-359.
[60] Noronha, L. and Chiang, F., 2021. Discovery of Temporal Graph Func-
tional Dependencies. In Proceedings of the 30th ACM International Con-
ference on Information & Knowledge Management (pp. 3348-3352).
47

---

