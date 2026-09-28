# Parallel Acyclic Joins with Canonical Edge Covers

> 来源: https://arxiv.org/pdf/2201.03832

Parallel Acyclic Joins with Canonical Edge Covers
Yufei Tao
Department of Computer Science and Engineering
Chinese University of Hong Kong
taoyf@cse.cuhk.edu.hk
January 12, 2022
Abstract
In PODS’21, Hu presented an algorithm in the massively parallel computation (MPC) model
that processes any acyclic join with an asymptotically optimal load. In this paper, we present an
alternative analysis of her algorithm. The novelty of our analysis is in the revelation of a new
mathematical structure — which we name canonical edge cover — for acyclic hypergraphs. We
prove non-trivial properties for canonical edge covers that oﬀer us a graph-theoretic perspective
about why Hu’s algorithm works.
Keywords: Joins, Conjunctive Queries, MPC Algorithms, Parallel Computing.
Acknowledgments: This work was partially supported by GRF projects 142078/20 and 142034/21
from HKRGC.
1
arXiv:2201.03832v1  [cs.DB]  11 Jan 2022

---

1
Introduction
Massively parallel join processing has attracted considerable attention in recent years. This line of
research makes two types of contributions. The ﬁrst consists of algorithms that promise excellent
performance.
The second, more subtle, type of contributions comprises knowledge revealing
mathematical structures in the underlying problems. The latter is a necessary side-product of the
former. In general, as human beings switch to a more generic setting, their knowledge from restrictive
settings often proves insuﬃcient, which then necessitates deeper investigation into the problem
characteristics. Traditional studies have focused on joins in the RAM computation model [4,14,16,18,
19], a degenerated “parallel” setup having only one machine. Designing algorithms to work with any
number of machines poses serious challenges and demands novel ﬁndings [3,7,8,10,12,13,15,20,21]
beyond the RAM literature.
This paper will focus on acyclic joins, a class of joins with profound importance in database
systems [1,7–9,11,22]. Recently, Hu [8] developed a worst-case optimal massively parallel algorithm
for acyclic joins. In the current work, we will provide an alternative, hopefully more accessible,
analysis of her elegant algorithm. The real excitement from our analysis is the identiﬁcation of
a new mathematical structure — we call “canonical edge cover” — for acyclic hypergraphs. The
structure reveals a unique characteristic of acyclic joins and is a core reason why Hu’s algorithm
works.
1.1
Problem Deﬁnition
Acyclic Joins. Let att be a set where each element is called an attribute. Let dom be another set
where each element is called a value. We assume a total order on dom; if not, manually impose one
by ordering the values arbitrarily.
A tuple over a set U ⊆att is a function u : U →dom. For each attribute X ∈U, we refer to
u(X) as the value of u on X. Given a subset U′ ⊆U, deﬁne u[U′] — the projection of u on U′ —
as the tuple u′ over U′ such that u′(X) = u(X) for every X ∈U′. A relation is a set R of tuples
over the same set U of attributes. We call U the scheme of R, a fact denoted as scheme(R) = U. If
U is the empty set ∅, then R is also ∅.
We represent a join query (henceforth, simply a “join” or “query”) as a set Q of relations. Deﬁne
attset(Q) = S
R∈Q scheme(R). The query result — denoted as Join(Q) — is the following relation
over attset(Q)
Join(Q) =
n
tuple u over attset(Q)
 ∀R ∈Q, u[scheme(R)] ∈R
o
.
If the relations in Q are R1, R2, ..., R|Q|, we may represent Join(Q) also as R1 ▷◁R2 ▷◁... ▷◁R|Q|.
Q can be characterized by a hypergraph G = (V, E) where each vertex in V is a distinct attribute
in attset(Q), and each hyperedge in E is the scheme of a distinct relation in Q. E may contain
identical hyperedges because two (or more) relations in Q can have the same scheme. The term
“hyper” suggests that a hyperedge can have more than two attributes.
A query is acyclic if its hypergraph is acyclic. Speciﬁcally, a hypergraph G = (V, E) is acyclic if
we can create a tree T where
• every node in T stores (and, hence, “corresponds to”) a distinct hyperedge in E;
• (connectedness requirement) for every attribute X ∈V , the set S of nodes whose corre-
sponding hyperedges contain X forms a connected subtree in T.
2

---

HK
EHJ
CEJ
BCE
ABC
BD
CEF
HI
EFG
KL
LM
HN
BO
Figure 1: A hyperedge tree example
We will call T a hyperedge tree of G (also known as the join tree of Q in the literature).
Example 1.1. Consider the hypergraph G = (V, E) where V = {A, B, ..., O} and E = {ABC, BD, BO,
EFG, BCE, CEF, CEJ, HI, LM, EHJ, KL, HK, HN}. Figure 1 shows a hyperedge tree T of G. To understand
the connectedness requirement, observe the connected subtree formed by the ﬁve hyperedges
involving E.
As G and T both contain “vertices” and “edges”, for better clarity we will obey several conventions
throughout the paper. A vertex in G will always be referred to as an attribute, while the term node
is reserved for the vertices in T. Furthermore, to avoid confusion with hyperedges, we will always
refer to an edge in T as a link.
We use m to denote the input size of Q, deﬁned as P
R∈Q |R|, namely, the total number of tuples
in the relations participating in the join.
Computation Model. We assume the massively parallel computation (MPC) model which is
popular in designing massively parallel algorithms [3, 7, 8, 10, 12, 13, 15, 20, 21]. In this model,
we have p machines, each storing Θ(m/p) tuples from the relations of a query Q initially. An
algorithm executes in rounds, each having two phases: in the ﬁrst phase, each machine performs
local computation; in the second, the machines exchange messages (every message must have been
generated at the end of the ﬁrst phase). An algorithm must ﬁnish in a constant number of rounds,
and when it does, every tuple in Join(Q) must reside on at least one machine. The load of a round
is the largest number of words received by a machine in that round. The load of an algorithm is the
maximum load of all the rounds. The objective is to design an algorithm with the smallest load.
Math Conventions. The number p of machines is considered to be at most m1−ϵ, for some
arbitrarily small constant ϵ > 0. Every value in dom can be represented with O(1) words. Our
discussion focuses on data complexities, namely, we are interested in the inﬂuence of m on algorithm
performance. For that reason, we assume that the hypergraph G of Q has O(1) vertices. Given an
integer x ≥1, the notation [x] represents the set {1, 2, ..., x}.
1.2
Previous Results
Fractional Edge Coverings and the AGM bound. Consider a query Q (which may or may not
be acyclic) with hypergraph G = (V, E). Associate every hyperedge e ∈E with a real-valued weight
we, which falls between 0 and 1. Impose a constraint on every attribute X ∈V : P
e∈E:X∈e we ≥1,
i.e., the total weight of all the hyperedges covering X must be at least 1. A set of weights {we | e ∈E}
fulﬁlling all the constraints is a fractional edge covering of G. If we deﬁne P
e∈E we as the total
weight of the fractional edge covering, the fractional edge covering number of G — denoted as ρ —
3

---

is the minimum total weight of all possible fractional edge coverings. A fractional edge covering is
optimal if its total weight equals ρ.
The AGM bound, proved by Atserias, Grohe, and Marx [5], states that the size of Join(Q) is
always bounded by O(mρ); recall that m is the input size of Q. Furthermore, the bound is tight: in
the worst case, |Join(Q)| can indeed reach Ω(mρ) [5].
Simpliﬁcation for Acyclic Queries: Edge Covers. When Q is acyclic, G = (V, E) always
admits an optimal fractional edge covering with integral weights [8]. Recall that all the weights
we (e ∈E) must fall between 0 and 1. Hence, every weight in an optimal fractional edge covering
must be either 0 or 1. This pleasant property allows the reader to connect ρ to edge “covers”. A
subset S ⊆E is an edge cover1 of G if every attribute of V appears in at least one hyperedge of S.
Thus, the value of ρ is simply the minimum size of all edge covers, namely, the smallest number of
hyperedges that we must pick to cover all the attributes.
Join Algorithms in RAM. An algorithm able to answer Q using O(mρ) time in the RAM model
is worst-case optimal. Indeed, as |Join(Q)| can be Ω(mρ), we need Θ(mρ) time just to output
Join(Q) in the worst case. Ngo et al. [17] designed the ﬁrst algorithm that guarantees a running time
of O(mρ) for all queries. Since then, the community has discovered more algorithms [4,14,16,18,19]
that are all worst-cast optimal (sometimes up to a polylogarithmic factor) but diﬀer in their own
features. For an acyclic Q, an algorithm due to Yannakakis [22] achieves a stronger sense of
optimality: his algorithm runs in O(m + |Join(Q)|) time, which is clearly the best regardless of
|Join(Q)|.
Join Algorithms in MPC. Koutris, Beame, and Suciu [15] showed that, in the MPC model, the
AGM bound implies a worst-case lower bound of Ω(m/p1/ρ) on the load of any algorithm that
answers a query Q, where m is the input size of Q and ρ is the fractional edge covering number of
the hypergraph G = (V, E) deﬁned by Q.
The above negative result has motivated considerable research looking for MPC algorithms
whose loads are bounded by O(m/p1/ρ), ignoring polylogarithmic factors; such algorithms are
worst-case optimal. The goal has been realized only on four query classes. The ﬁrst consists of all
the cartesian-product queries (i.e., the relations in Q have disjoint schemes); see [3,6,13] for several
optimal algorithms on such queries. The second is the so-called Loomis-Whitney join, where E
consists of all the |V | possible hyperedges of |V | −1 attributes; see [15] for an optimal algorithm
for such joins. The third class includes every query where all the hyperedges in G contain at most
two attributes; see [12,13,21] for the optimal algorithms. The fourth class comprises all the acyclic
queries, which were recently solved by Hu [8] optimally. It is worth pointing out that Hu’s algorithm
subsumes an earlier algorithm of [9] which is worst-case optimal on a subclass of acyclic queries.
Although it still remains elusive what other query classes can be settled with load O(m/p1/ρ),
now we know that this is unachievable for certain queries. In [8], Hu constructed a class of queries for
which every algorithm must incur a load of ω(m/p1/ρ) in the worst case. The result of [8] suggests
that additional parameters — other than m, p, and ρ — are needed to describe the worst-case
optimality of an ideal MPC algorithm. We will not delve into the issue further because it does not
apply to acyclic queries (the focus of this paper), but the reader may consult the recent works [8,20]
for the latest development on that issue. Finally, we remark that several algorithms [2,9,10] are
able to achieve a load sensitive to the join size |Join(Q)|.
1In case the reader is wondering, the literature uses the words “covering” and “cover” exactly the way they are
used in our paper.
4

---

1.3
Our Contributions
The ﬁrst, easy-to-discern, contribution of our paper is a new analysis of Hu’s algorithm [8] for acyclic
queries. Our second contribution is the introduction of canonical edge cover as a mathematical
structure inherent in acyclic queries. We prove a suite of graph-theoretic properties for canonical
edge covers and use them to give a more fundamental interpretation of the design choices in Hu’s
algorithm. The rest of the section will provide an overview of our results and techniques.
Clustering, k-Groups, k-Products, and Induced Loads. We ﬁrst create a conceptual frame-
work to state Hu’s and our results on a common ground. Deﬁne a clustering of E (the hyperedge
set of G) as a set {E1, E2, ..., Es} for some s ≥1 where (i) each Ei is a subset of E, i ∈[s], and (ii)
S
i Ei = E. We call each Ei a cluster; note that the clusters need not be disjoint.
Fix an arbitrary clustering C = {E1, E2, ..., Es}. Given an integer k ≥1, deﬁne a k-group of C
as a collection of k hyperedges, each taken from a distinct cluster.
Example 1.2. Let G = (V, E) be the hypergraph in Example 1.1 (Figure 1). C = {{BO, BCE,
CEJ}, {ABC, BCE, CEJ}, {BD, BCE, CEJ}, {EFG, CEF, CEJ}, {HI}, {EHJ}, {LM, KL}, {HK}, {HN}} is a
clustering of E. A 3-group example is {ABC, BD, EFG}. Note that the hyperedges in a k-group need
not be distinct. For example, {CEJ, CEJ, CEJ} is also a 3-group: the ﬁrst CEJ is taken from the
cluster {ABC, BCE, CEJ}, the second from {BD, BCE, CEJ}, and the third from {EFG, CEF, CEJ}. For a
non-example, {ABC, LM, KL} is not a 3-group.
For each hyperedge e ∈E, let R(e) represent the relation in Q whose scheme is e. Given a
k-group K of the clustering C, we deﬁne the Q-product of K as Q
e∈K |R(e)| (i.e., the cartesian-
product size of all the relevant relations). Given an integer k, we deﬁne the max (k, Q)-product of C
— denoted as Pk(Q, C) — as the maximum Q-product of all the k-groups of C.
Example 1.3. Continuing on the previous example, the Q-product of the 3-group {ABC, BCE, CEJ}
is |R(ABC)| · |R(BCE)| · |R(CEJ)|, while that of the 3-group {CEJ, CEJ, CEJ} is |R(CEJ)|3.
Deﬁne the Q-induced load of C as
s
max
k=1 (Pk(Q, C)/p)1/k
(1)
As Pk(Q, C) ≤mk for any k ∈[s], it must hold that (1) ≤m/p1/s.
We can now give a more detailed account of Hu’s result [8]. She proved that the load of her
algorithm is bounded by O(L), where L is the Q-induced load of a certain clustering with size s = ρ,
and ρ is the fractional edge covering number of G. It thus follows immediately that L ≤m/p1/s.
In [8], Hu presented a recursive procedure to identify the clustering C whose Q-induced load equals
the target L. The procedure, however, is somewhat sophisticated, making it diﬃcult to describe
the target C in a succinct manner. Such diﬃculty is unjustiﬁed, especially given the algorithm’s
elegance, and indicates the existence of a hidden mathematical structure.
Our Results and Techniques. A hypergraph G can have many optimal edge covers (all of which
must have size ρ). While Hu’s analysis [8] assumes an arbitrary optimal edge cover, we will be
choosy about what we work with. In Figure 1, the 9 circled nodes constitute a canonical edge cover
F of G. Let us give an informal but intuitive explanation of how to construct this F. After rooting
the tree in Figure 1 at HN, we add to F all the leaf nodes: BO, ABC, BD, EFG, HI, LM. Then, we process
the non-leaf nodes bottom up. In processing BCE, we ask: which attributes will disappear as we
5

---

ascend further in the tree? The answer is B, which is thus a “disappearing” attribute of BCE. Then,
we ask: does F already cover B? The answer is yes, due to the existence of BO; we therefore do
not include BCE in F. We process BCE, CEF, and CEJ similarly, none of which enters F. At EHJ, we
ﬁnd disappearing attributes E and J. In general, as long as one disappearing attribute has not been
covered by F, we pick the node; this is why EHJ is in F. The other nodes HK and HN in F are chosen
based on the same reasoning.
We show that a canonical edge cover determined this way has appealing properties which ﬁt
the recursive strategy behind Hu’s algorithm very well. At a high level, Hu’s algorithm works by
simplifying G into a number of “residual” hypergraphs to be processed recursively. Interestingly,
with trivial modiﬁcations (such as removing the attributes that have become irrelevant), a canonical
edge cover of G remains canonical on every residual hypergraph. This is the most crucial property
we utilize to relate the load of the original query to those of the “residual queries” in forming up a
working recurrence.
Our techniques also provide a simple and natural way to pinpoint a clustering C that can be
used to bound the algorithm’s load. Consider the canonical edge cover F shown in Figure 1 (the
circled nodes). For each node in F, take a “signature path” by walking up and stopping right before
reaching its lowest proper ancestor in F. For example, the signature path of ABC is {ABC, BCE, CEJ}
(note: the path does not contain EHJ). Likewise, the signature path of LM is {LM, KL}. The signature
paths of all the nodes in F together produce the clustering C given in Example 1.2. Our main result
(Theorem 9) states that the Q-induced load of C is an upper bound on the load of Hu’s algorithm.
Because C has a size at most ρ, the algorithm’s load is thus bounded by O(m/p1/ρ).
2
Canonical Edge Covers for Acyclic Hypergraphs
This section is purely graph theoretic: we will establish several new properties for acyclic hypergraphs.
Let G = (V, E) be an acyclic hypergraph. A hyperedge e1 ∈E is subsumed if it is a subset of
another hyperedge e2 ∈E, i.e., e1 ⊆e2. If an attribute X appears in only a single hyperedge, we
call X an exclusive attribute; otherwise, X is non-exclusive. Unless otherwise stated, we allow G
to be an arbitrary acyclic hypergraph. In particular, this means that E can contain two or more
hyperedges with the same attributes (nonetheless, they are still distinct hyperedges) and may even
have empty hyperedges (i.e., with no attributes at all). G is clean if E has no subsumed edges.
Some of our results will apply only to clean hypergraphs.
Denote by T a hyperedge tree of G (the existence of T is guaranteed; see Section 1.1). By
rooting T at an arbitrary leaf, we can regard T as a rooted tree. Make all the links2 of T point
downwards, i.e., from parent to child. This way, T becomes a directed acyclic graph.
Now that there are two views of T (i.e., undirected and directed), we ought to be careful with
terminology. By default, we will treat T as a directed tree. Accordingly, a leaf of T is a node with
out-degree 0, a path is a sequence of nodes where each node has a link pointing to the next node,
and a subtree rooted at a node e is the directed tree induced by the nodes reachable from e in T.
Sometimes, we may revert back to the undirected view of T. In that case, we use the term raw leaf
for a leaf in the undirected T (i.e., a raw leaf can be a leaf or the root under the directed view)
2Remember that we refrain from saying “edges” of T; see Section 1.1.
6

---

2.1
Fundamental Deﬁnitions and Properties
Summits and Disappearing Attributes. We say that the root of T is the highest node in T
and, in general, a node is higher (or lower) than any of its proper descendants (or ancestors). For
each attribute X ∈V , we deﬁne the summit of X as the highest node (a.k.a. a hyperedge) that
contains X. If node e is the summit of X, we call X a disappearing attribute in e. By acyclicity’s
connectedness requirement (Section 1.1), X can appear only in the subtree rooted at e and hence
“disappears” as soon as we leave the subtree.
Example 2.1. Let G = (V, E) be the hypergraph in Example 1.1 whose (rooted) hypergraph tree
T is shown in Figure 1. The summit of C is node CEJ. Thus, C is a disappearing attribute of CEJ.
Node EHJ is the summit of E and J. Hence, both E and J are disappearing attributes of EHJ.
Canonical Edge Cover. We say that a subset S ⊆E covers an attribute X ∈V if S has a
hyperedge containing X. Recall that an optimal edge cover of G is the smallest S covering every
attribute in V . Optimal edge covers are not unique. Some are of particular importance to us; and we
will identify them as “canonical”. Towards a procedural deﬁnition, consider the following algorithm:
edge-cover (T) /* T is rooted */
1. Ftmp = ∅
2. obtain a reverse topological order e1, e2, ..., e|E| of the nodes (i.e., hyperedges) in T
3. for i = 1 to |E| do
4.
if ei has a disappearing attribute not covered by Ftmp then add ei to Ftmp
5. return Ftmp
Lemma 1. The output of edge-cover — denoted as F — is an optimal edge cover of G, and does
not depend on the reverse topological order at Line 2. Furthermore, if G is clean, F includes all the
raw leaves of T.
All the missing proofs can be found in the appendix. We refer to F as the canonical edge cover
(CEC) of G induced by T. The size of F is precisely the fractional edge covering number ρ of Q.
Example 2.2. Continuing on the previous example, consider the reverse topological order of T:
ABC, BD, BO, BCE, EFG, CEF, CEJ, HI, EHJ, LM, KL, HK, HN. When processing ABC, edge-cover adds
it to Ftmp because ABC has a disappearing attribute A and yet Ftmp = ∅. When processing BCE,
Ftmp = {ABC, BD, BO}. BCE has a disappearing attribute B, which, however, has been covered by
Ftmp. Thus, B is not added to Ftmp. The ﬁnal output of the algorithm is F = {ABC, BD, BO, EFG,
HI, LM, EHJ, HK, HN}, which is the CEC of G induced by T.
Signature Paths. Whenever F includes the root of T, we can deﬁne a signature path — denoted
as sigpath(f, T) — for each node (i.e., hyperedge) f ∈F. Speciﬁcally, sigpath(f, T) is a set of nodes
deﬁned as follows:
• If f is the root of T, sigpath(f, T) = {f}.
• Otherwise, let ˆf be the lowest node in F that is a proper ancestor of f. Then, sigpath(f, T)
is the set of nodes on the path from ˆf to f, except ˆf.
Example 2.3. Consider the set F obtained in the previous example. If f = HN, then the signature
path of f is {HN}. If f = ABC, then ˆf = EHJ; and the signature path of f is {ABC, BCE, CEJ}.
7

---

(Clean G) Clustering, Anchor Leaf, and Anchor Attribute. Consider G = (V, E) now as a
clean hypergraph. Let F be the CEC of G induced by a hyperedge tree T of G. As F contains the
root and leaves of T (Lemma 1), {sigpath(f, T) | f ∈F} is a clustering of E. If f is not the root of
T, we call sigpath(f, T) a non-root cluster.3
Let f◦be a leaf node in F, and ˆf be the lowest proper ancestor of f◦in F. We call f◦an anchor
leaf of T if two conditions are satisﬁed:
• ˆf has no non-leaf proper descendants in F.
• f◦has an attribute A◦such that A◦/∈ˆf but A◦∈e for every node e ∈sigpath(f◦, T).
A◦will be referred to as an anchor attribute of f◦.
Lemma 2. If G is clean, F always contains an anchor leaf.
Example 2.4. From the F constructed earlier, we obtain the clustering C = {{BO, BCE, CEJ},
{ABC, BCE, CEJ}, {BD, BCE, CEJ}, {EFG, CEF, CEJ}, {HI}, {EHJ}, {LM, KL}, {HK}, {HN}}. Other than
{HN}, all the clusters in C are non-root clusters. ABC is an anchor leaf of T with an anchor attribute
C. HI is another anchor leaf with an anchor attribute I. For a non-example, BD is not an anchor
leaf because it does not have an attribute that exists in all the nodes in sigpath(BD, T) = {BD, BCE,
CEJ}. Furthermore, LM is not an anchor leaf because HK, the lowest proper ancestor of LM in F, has
a non-leaf proper descendant in F (i.e., EHJ).
2.2
(Clean G) Properties on Residual Hypergraphs
This subsection assumes G = (V, E) to be clean. Let T be a hyperedge tree of G and F be the
CEC induced by T. Fix an arbitrary anchor leaf f◦of T and an anchor attribute A◦of f◦. We will
analyze how the CEC changes as G is simpliﬁed based on f◦and A◦.
2.2.1
Simpliﬁcation 1
The ﬁrst simpliﬁcation is based on removing attribute A◦from G.
Residual Hypergraph. Let G′ = (V ′, E′) be the residual hypergraph obtained by eliminating A◦
from G: V ′ = V \ {A◦}, and E′ collects a hyperedge e′ = e \ {A◦} for every e ∈E.4 We characterize
the one-one correspondence between E′ and E by introducing a function map(e) = e′ and its inverse
function map−1(e′) = e. Let T ′ be the hyperedge tree of G′ obtained by discarding A◦from every
node in T (note: G′ is not necessarily clean).
Canonical Edge Cover. Deﬁne
F ′
=
 F \ {f◦}
if map(f◦) is subsumed in G′
{map(f) | f ∈F}
otherwise
(2)
Example 2.5. Continuing on the previous example, if we choose f◦= ABC with A◦= C and
eliminate C from the tree T in Figure 1, we obtain the hyperedge tree T ′ in Figure 2a, where the
circled nodes constitute the set F ′. Similarly, if we choose f◦= HI with A◦= I, then T ′ and F ′ are
as demonstrated in Figure 2b.
3If f is the root of T, sigpath(f, T) contains just f itself.
4If e = {A◦}, E′ collects e′ = ∅.
8

---

HK
EHJ
EJ
BE
AB
BD
EF
HI
EFG
KL
LM
HN
BO
HK
EHJ
CEJ
BCE
ABC
BD
CEF
H
EFG
KL
LM
HN
BO
(a) T ′ and F ′ after removing C
(b) T ′ and F ′ after removing I
Figure 2: Residual hypergraphs
ebig
ebig
esmall
esmall
ebig
ebig
(a) ebig parents esmall
(b) esmall parents ebig
Figure 3: Two cases of cleansing
Lemma 3. If G is clean, F ′ is the CEC of G′ induced by T ′. Furthermore, if map(f◦) is subsumed
in G′, then A◦must be an exclusive attribute in f◦.
As a corollary, if map(f◦) is subsumed in G′, then every hyperedge of G, except f◦, is directly
retained in G′; furthermore, map(f◦) is the only subsumed edge in G′. The next lemma gives
another property of F ′ that holds no matter if G is clean.
Lemma 4. If a hyperedge e′ of G′ is subsumed, then e′ /∈F ′
Cleansing. Even though G is clean, the residual hypergraph G′ may contain subsumed hyperedges.
Next, we describe a cleansing procedure which converts G′ into a clean hypergraph G∗= (V ′, E∗)
(note that G∗has the same vertices as G′) and converts T ′ into a rooted hyperedge tree T ∗of G∗.
Cleansing is simple if map(f◦) is subsumed in G′. In this case, G∗is the hypergraph obtained
by removing map(f◦) from G′, and T ∗is the tree obtained by removing the leaf map(f◦) from T ′.
If map(f◦) is not subsumed, the cleansing algorithm is:
cleanse (G′, T ′) /* condition: map(f◦) not subsumed */
1. G∗= G′, T ∗= T ′
2. while G∗has hyperedges esmall and ebig such that esmall ⊆ebig and they are connected by
a link in T ∗do
3.
remove esmall from G∗and T ∗
/* esmall /∈F ′ by Lemma 4 */
4.
if ebig was the parent of esmall in T ∗then
5.
make ebig the new parent for all the child nodes of esmall; see Figure 3a
else
6.
make ebig the new parent for the child nodes of esmall, and
make ebig a child of the (original) parent of esmall in T ∗; see Figure 3b
7. return G∗and T ∗
At the end of cleansing, we always set F ∗= F ′, regardless of whether map(f◦) is subsumed.
9

---

HK
EHJ
KL
LM
HN
BE
AB
BD
EF
EFG
HI
BO
HK
EHJ
KL
LM
HN
BE
AB
BD
EFG
HI
BO
(a) After removing EJ
(b) After removing EF
Figure 4: Simpliﬁcation 1
Lemma 5. After cleansing, F ∗is the CEC of G∗induced by T ∗.
Example 2.6. In Example 2.5, the residual hypergraph G′ in Figure 2a has two subsumed
hyperedges EJ and EF, each removed by an iteration of cleanse. Suppose that the ﬁrst iteration sets
esmall = EJ and ebig = EHJ (this is a case of Figure 3a). Figure 4a illustrates the T ∗after removing
EJ. The next iteration sets esmall = EF and ebig = EFG (a case of Figure 4b). Figure 4b illustrates
the T ∗after removing EF. In both Figure 4a and 4b, the circled nodes constitute the CEC of G∗
induced by T ∗.
Distinct Clusters Lemma. The next property concerns the hypergraph G∗= (V ′, E∗) after
cleansing and the original hypergraph G = (V, E). Recall that T ∗and T are hyperedge trees of
G∗and G, respectively. Before proceeding, the reader should recall that every hyperedge e∗∈E∗
corresponds to a distinct hyperedge e ∈E, which is the hyperedge given by map−1(e∗).
Consider once again the CEC F of G, i.e., the original hypergraph, induced by T. As mentioned
in Section 2.1, C = {sigpath(f, T) | f ∈F} is a clustering of E. By the same reasoning, because F ∗
is the CEC of G∗induced by T ∗(Lemma 5), C∗= {sigpath(f∗, T ∗) | f∗∈F ∗} must be a clustering
of E∗. The following lemma draws a connection between C and C∗:
Lemma 6 (Distinct Clusters Lemma). For any 1 ≤k ≤|F ∗|, if {e∗
1, ..., e∗
k} is a k-group of C∗, then
{map−1(e∗
1), ..., map−1(e∗
k)} is a k-group of C.
By deﬁnition of k-group, e∗
1, ..., e∗
k originate from k distinct clusters in C∗. The lemma promises
k diﬀerent clusters in C each containing a distinct hyperedge in {map−1(e∗
1), ..., map−1(e∗
k)}.
Example 2.7. Consider the T ∗(and hence G∗) and F ∗illustrated in Figure 4b. The clustering C∗
is {{AB, BE}, {BO, BE}, {BD, BE}, {EFG}, {EHJ}, {HI}, {LM, KL}, {HK}, {HN}}. Because {BE, EFG, KL}
is a 3-group of C∗, Lemma 6 asserts that {map−1(BE), map−1(EFG), map−1(KL)} = {BCE, EFG, KL}
must be a 3-group of the clustering C in Example 2.4.
2.2.2
Simpliﬁcation 2
The second simpliﬁcation decomposes G into multiple hypergraphs based on sigpath(f◦, T).
Decomposition. Deﬁne Z to be the set of nodes z in T satisfying: z is not in sigpath(f◦, T) but
the parent of z is. For each z ∈Z, deﬁne a rooted tree T ∗
z as follows:
• The root of T ∗
z is the parent of z in T.
• The root of T ∗
z has only one child in T ∗
z , which is z.
10

---

HK
EHJ
CEJ
BCE
ABC
BD
CEF
HI
EFG
KL
LM
HN
BO
CEJ
CEF
EFG
BCE
BO
BCE
BD
HK
EHJ
HI
KL
LM
HN
(a) The dotted path is sigpath(ABC, T)
(b) T ∗
CEF
(c) T ∗
BO
(d) T ∗
BD
(e) ¯T ∗
Figure 5: Decomposition
• The subtree rooted at z in T ∗
z is the same as the subtree rooted at z in T.
Separately, deﬁne ¯T ∗as the rooted tree obtained by removing from T the subtree rooted at the
highest node in sigpath(f◦, T).
From each T ∗
z , generate a hypergraph G∗
z = (V ∗
z , E∗
z). Speciﬁcally, E∗
z includes all and only the
nodes (each being a hyperedge) in T ∗
z , and V ∗
z is the set of attributes appearing in at least one
hyperedge in E∗
z. Likewise, from ¯T ∗, generate a hypergraph ¯G∗= ( ¯V ∗, ¯E∗) where ¯E∗includes all
and only the nodes in ¯T ∗, and ¯V ∗is the set of attributes appearing in at least one hyperedge in ¯E∗.
Because G is clean, so must be all the generated hypergraphs. Furthermore, each of them has
fewer edges than G.5 For each z ∈Z, T ∗
z is a hyperedge tree of G∗
z; similarly, ¯T ∗is a hyperedge tree
of ¯G∗.
Example 2.8. In our running example, f◦= ABC, whose signature path is sigpath(f◦, T) =
{ABC, BCE, CEJ}; see Figure 5a. Z = {BO, BD, CEF}. Figure 5b, 5c, and 5d illustrate T ∗
z for z = CEF,
BO, and BD, respectively. Figure 5e gives ¯T ∗
z .
Canonical Edge Covers. Recall that F is the CEC of G induced by T. Next, we derive the
CECs of the hypergraphs generated from the decomposition. For each z ∈Z, deﬁne
F ∗
z
=
{parent of z} ∪(F ∩E∗
z).
(3)
Also, deﬁne
¯F ∗
=
F ∩¯E∗.
(4)
Lemma 7. For each node z ∈Z, F ∗
z is the CEC of G∗
z induced by T ∗
z . Furthermore, ¯F ∗is the CEC
of ¯G∗induced by ¯T ∗.
Example 2.9. We have circled the nodes in F ∗
z in Figure 5b, 5c, and 5d for z = CEF, BO, and BD,
respectively. Similarly, the circled nodes in Figure 5e constitute ¯F ∗
z .
Distinct Clusters Lemma 2. We close the section with a property resembling Lemma 6.
Consider any z ∈Z. Because G∗
z = (V ∗
z , E∗
z) is clean and F ∗
z is the CEC of G∗
z induced by
T ∗
z , C∗
z = {sigpath(f∗, T ∗
z ) | f∗∈F ∗
z } is a clustering of E∗
z. Similarly, regarding ¯G∗= ( ¯V ∗, ¯E∗),
¯C∗= {sigpath(f∗, ¯T ∗) | f∗∈¯F ∗} is a clustering of ¯E∗.
Deﬁne a super-k-group to be a set of hyperedges K = {e1, e2, ..., ek} satisfying:
5Because f ◦does not appear in any of the generated hypergraphs.
11

---

• Each ei, i ∈[k], is taken from a cluster of ¯C∗or a non-root cluster6 of C∗
z for some z ∈Z.
• No two hyperedges in K are taken from the same cluster.
Before delving into the next lemma, the reader should recall that {sigpath(f, T) | f ∈F} is a
clustering of E.
Lemma 8 (Distinct Clusters Lemma 2). If {e1, e2, ..., ek} is a super-k-group, then {e1, e2, ..., ek}
must be a k-group of the clustering {sigpath(f, T) | f ∈F}.
Example 2.10. In Figure 5, C∗
CEF
=
{{EFG, CEF}, {CEJ}}, C∗
BO
=
{{BO}, {BCE}}, C∗
BD
=
{{BD}, {BCE}}, ¯C∗= {{HI}, {EHJ}, {HK}, {HN}, {LM, KL}}. A super-4-group is {CEF, BO, BD, KL}.
Lemma 8 assures us that {CEF, BO, BD, KL} must be a 4-group in the clustering C given in Exam-
ple 2.4.
3
An MPC Algorithm
The rest of the paper will apply the theory of CECs to solve acyclic queries in the MPC model. We
will describe a variant of Hu’s algorithm [8] in this section7 and present our analysis in the next
section. Denote by Q the acyclic query to be answered. Let G = (V, E) be the hypergraph of Q.
We assume G to be clean; otherwise, Q can be converted to a clean query having the same result
with load O(m/p) [8]. We will also assume that Q has at least two relations; otherwise, the query is
trivial and requires no communication.
3.1
Conﬁgurations
Let T be a hyperedge tree of G and F be the CEC of G induced by T. The size of F is precisely
ρ, the fractional edge covering number of Q (Section 1.2). As explained in Section 2.1, when G is
clean,
C
=
{sigpath(f, T) | f ∈F}
(5)
is a clustering of E. Let f◦be an anchor leaf of T and A◦an anchor attribute of f◦(Section 2.1);
remember that A◦appears in all the hyperedges of sigpath(f◦, T). Deﬁne
L
=
the Q-induced load of C.
(6)
The reader can review Equation (1) for the deﬁnition of “Q-induced load”.
For each hyperedge e ∈E, as before R(e) denotes the relation in Q corresponding to e. Fix a
value x ∈dom. Given an e ∈sigpath(f◦, T), we deﬁne the A◦-frequency of x in R(e) as the number
of tuples u ∈R(e) such that u(A◦) = x. Further deﬁne the signature-path A◦-frequency of x as the
sum of its A◦-frequencies in the R(e) of all e ∈sigpath(f◦, T). A value x ∈dom is
• heavy, if its signature-path A◦-frequency is at least L;
• light, otherwise.
6Namely, ei cannot be the root of T ∗
z .
7Our algorithm follows Hu’s ideas [8] but diﬀers in certain details. For example, Hu’s algorithm takes an arbitrary
optimal edge cover of G as the input, while we insist on working with a CEC.
12

---

Divide dom into disjoint intervals such that the light values in each interval have a total signature-
path A◦-frequency of Θ(L). We will refer to those intervals as the light intervals of A◦. The total
number of heavy values and light intervals is at most
X
e∈sigpath(f◦,T)
|R(e)|
L
= O

max
e∈sigpath(f◦,T)
|R(e)|
L

= O
max (1, Q)-product of C
L

= O(p)
(7)
where the ﬁrst equality used the fact that sigpath(f◦, T) has O(1) edges and the second equality
applied the deﬁnition of max (k, Q)-product (see Section 1.3).
A conﬁguration η is either a heavy value or a light interval. Equation (7) implies that the number
of conﬁgurations is O(p). For each hypergraph e ∈E, deﬁne a relation R(e, η) as follows:
• if η is a heavy value, R(e, η) includes all and only the tuples u ∈R(e) satisfying u(A◦) = η;
• if η is a light interval, R(e, η) includes all and only the tuples u ∈R(e) where u(A◦) is a light
value in η.
Note that R(e, η) = R(e) if A◦/∈e. Let Qη be the query deﬁned by {R(e, η) | e ∈E}. Our objective
is to compute Join(Qη) for all η in parallel. The ﬁnal result Join(Q) is simply S
η Join(Qη).
The rest of the section will explain how to solve Join(Qη) for an arbitrary η. We allocate
pη
=
Θ

1 +
|F|
max
k=1
Pk(Qη, C)
Lk

(8)
machines for this purpose, where Pk(Qη, C) is the max (k, Qη)-product of C.
3.2
Solving Qη When η is a Heavy Value
Deﬁne the residual hypergraph G′ = (V ′, E′) after removing A◦, and also functions map(.) and
map−1(.) as in Section 2.2.1. We compute Join(Qη) in ﬁve steps.
Step 1. Send the tuples of R(e, η), for all e ∈E, to the pη allocated machines such that each
machine receives Θ( 1
pη
P
e∈E |R(e, η)|) tuples.
Step 2. For each e ∈E, convert R(e, η) to R∗(e′, η) where e′ = map(e) = e \ {A◦}. Speciﬁcally,
R∗(e′, η) is a copy of R(e, η) but with A◦discarded, or formally, R∗(e′, η) = {u[e′] | tuple u ∈
R(e, η)}. No communication occurs as each machine simply discards A◦from every tuple u ∈R(e, η)
in the local storage.
Step 3. Cleanse G′ into G∗= (V ′, E∗). As explained in Section 2.2.1, this may or may not require
calling algorithm cleanse. If called, cleanse identiﬁes in each iteration two hyperedges esmall and ebig
in the current G∗and removes esmall. Accordingly, we perform a semi-join between R∗(esmall, η)
and R∗(ebig, η), which removes every tuple u from R∗(ebig, η) with the property that u[esmall] is
absent from R∗(esmall, η). R∗(esmall, η) is discarded after the semi-join.
Step 4. Let Q∗
η be the query deﬁned by the relation set {R∗(e∗, η) | e∗∈E∗}. Compute Join(Q∗
η)
using pη machines recursively. Note that the number of participating attributes has decreased by 1
for the recursion.
Step 5. We output Join(Qη) by augmenting each tuple u ∈Join(Q∗
η) with u(A◦) = η. No
communication is needed.
13

---

3.3
Solving Qη When η is a Light Interval
Deﬁne Z, G∗
z = (V ∗
z , E∗
z) (for each z ∈Z), C∗
z, ¯G∗= ( ¯V ∗, ¯E∗), and ¯C∗all in the way described in
Section 2.2.2. We compute Join(Qη) in four steps.
Step 1. Same as Step 1 of the algorithm in Section 3.2.
Step 2. For each e ∈sigpath(f◦, T), broadcast R(e, η) to all pη machines. By deﬁnition of light
interval, the size of R(e, η) is at most L.
Step 3. For each z ∈Z, deﬁne a query Q∗
η,z = {R(e, η) | e ∈E∗
z}. Similarly, for ¯G∗, deﬁne
a query ¯Q∗
η = {R(e, η) | e ∈¯E∗}. Next, we compute the cartesian product of Join( ¯Q∗
η) and the
Join(Q∗
η,z) of all the z ∈Z — namely
 ×z∈ZJoin(Q∗
η,z)

× Join( ¯Q∗
η) — using pη machines. Towards
that purpose, deﬁne for each z ∈Z
pη,z
=
Θ

1 +
|F ∗
z |
max
k=1
Pk(Q∗
η,z, C∗
z)
Lk

(9)
where Pk(Q∗
η,z, C∗
z) is the max (k, Q∗
η,z)-product of the clustering C∗
z. Similarly, deﬁne
¯pη
=
Θ
 
1 +
| ¯F ∗|
max
k=1
Pk( ¯Q∗
η, ¯C∗)
Lk
!
(10)
where Pk( ¯Q∗
η, ¯C∗) is the max (k, ¯Q∗
η)-product of the clustering ¯C∗. We will prove later that each
Q∗
η,z can be answered with load O(L) using pη,z machines, and ¯Q∗
η can be answered with load O(L)
using ¯pη machines. Therefore, applying the cartesian product algorithm given in Lemma 6 of [12]
(see also Lemma 4 of [13]), we can compute
 ×z∈ZJoin(Q∗
η,z)

× Join( ¯Q∗
η) with load O(L) using
¯pη · Q
z∈Z pη,z machines. As proved later, we can adjust the constants in (9) and (10) to make sure
¯pη · Q
z∈Z pη,z ≤pη, where pη is given in (8).
Step 4.
We combine the cartesian product
 ×z∈ZJoin(Q∗
η,z)

× Join( ¯Q∗
η) with the tuples
broadcast in Step 2 to derive Join(Qη) with no more communication. Speciﬁcally, for each tuple u
in the cartesian product, the machine where u resides outputs {u} ▷◁
 ▷◁e∈sigpath(f◦,T) R(e, η)

. It
is rudimentary to verify that all the tuples of Join(Qη) will be produced this way.
4
Analysis of the Algorithm
This section will establish:
Theorem 9. Consider any join query Q deﬁned in Section 1.1 whose hypergraph is G. The
algorithm of Section 3 answers Q with load O(L), where L (given in (6)) is the Q-induced load of
the clustering obtained from a canonical edge cover of G.
We will prove the theorem by induction on the number of participating attributes (i.e., |V |)
and the number of participating relations (i.e., |Q|). If |Q| = 1, the theorem trivially holds. If
|V | = 1, Q has only one relation (because Q is clean) and the theorem also holds. Next, assuming
that the theorem holds on any query with either strictly less participating attributes or strictly less
participating relations than Q, we will prove the theorem’s correctness on Q.
Our analysis will answer three questions. First, why do we have enough machines to handle all
conﬁgurations in parallel? In particular, we must show that P
η pη ≤p, where pη is given in (8).
Second, why does each step in Section 3.2 and 3.3 entail a load of O(L)? Third, why do we have
14

---

¯pη · Q
z∈Z pη,z ≤pη in Step 3 of Section 3.3? Settling these questions will complete the proof of
Theorem 9.
All the notations in this section follow those in Section 3.
4.1
Total Number of Machines for All Conﬁgurations
It suﬃces to prove P
η pη = O(p) because adjusting the hidden constants then ensures P
η pη ≤p.
For every k ∈[|F|], we will show
1
Lk
X
η
Pk(Qη, C)
=
O(p)
(11)
which will yield
X
η
pη
=
X
η
O

1 +
|F|
max
k=1
Pk(Qη, C)
Lk

=
X
η
O

1 +
|F|
X
k=1
Pk(Qη, C)
Lk

= O(p) +
|F|
X
k=1
O
 X
η
Pk(Qη, C)
Lk
!
=
O(p)
where the second equality used |F| = O(1) and the third equality used P
η 1 = O(p).8
Henceforth, ﬁx the value of k. For any η, the hypergraph of Qη is always G (i.e., the hypergraph
of Q). Consider an arbitrary k-group K of the clustering C (given in Equation 5). The Qη-product
of K is Q
e∈K |R(e, η)|.9 For any K, we will prove
1
Lk
X
η
Y
e∈K
|R(e, η)|
=
O(p).
(12)
As C has O(1) k-groups K, the above yields
X
η
Pk(Qη, C)
Lk
=
X
η
1
Lk max
K
Y
e∈K
|R(e, η)|
=
O
 X
η
1
Lk
X
K
Y
e∈K
|R(e, η)|
!
= O
 X
K
1
Lk
X
η
Y
e∈K
|R(e, η)|
!
=
X
K
O(p) = O(p)
as claimed in (11).
Let us ﬁrst consider the case where K ∩sigpath(f◦, T)̸ = ∅, namely, K has a hyperedge e0 picked
from the cluster sigpath(f◦, T). We have:
X
η
Y
e∈K
|R(e, η)|
=
X
η

|R(e0, η)| ·
Y
e∈K\{e0}
|R(e, η)|

(13)
8P
η 1 is the number of conﬁgurations which is O(p) as shown in (7).
9For the deﬁnition of “a k-group’s Q-product”, review Section 1.3.
15

---

For each e ∈K \ {e0}, obviously |R(e, η)| ≤|R(e)|. Regarding e0, because A◦must be an attribute
of e0, the relations R(e0, η) of all the conﬁgurations η form a partition of R(e0).10 Hence:
(13)
≤

Y
e∈K\{e0}
|R(e)|
 X
η
|R(e0, η)|

=

Y
e∈K\{e0}
|R(e)|

· |R(e0)| =
Y
e∈K
|R(e)|
≤
max (k, Q)-product of C.
Therefore, the left hand side of (12) is bounded by max (k, Q)-product of C
Lk
, which is at most p (by
deﬁnition of L).
Next, we consider K ∩sigpath(f◦, T) = ∅. In this case, we must have k = |K| ≤|F| −1, because
the hyperedges in K need to come from distinct clusters of C, and C has |F| clusters (one of them
is sigpath(f◦, T), which now must be excluded). Applying the trivial fact |R(e, η)| ≤|R(e)| (for any
e) and the fact that P
η 1 is bounded by (7), we have
1
Lk
X
η
Y
e∈K
|R(e, η)|
≤
1
Lk
X
η
Y
e∈K
|R(e)| = O
 
1
Lk
Y
e∈K
|R(e)| ·
max
e∈sigpath(f◦,T)
|R(e)|
L
!
=
O
max (k + 1, Q)-product of C
Lk+1

which is at most p. This completes the proof of P
η pη = O(p).
4.2
Heavy Qη
This subsection will prove that the algorithm in Section 3.2 has load O(L). Step 2 and 5 demand
no communication. The loads of Step 1 and 3 can all be bounded11 by O( 1
pη
P
e∈E |R(e, η)|) =
O( 1
pη maxe∈E |R(e, η)|) = O(P1(Qη, C)/pη) = O(L).
To analyze Step 4, let T ∗be the hyperedge tree of G∗(produced by cleansing) and F ∗be the
CEC of G∗. By deﬁnition, the Q∗
η-induced load of the clustering C∗= {sigpath(f∗, T ∗) | f∗∈F ∗}
is
L∗
η
=
|F ∗|
max
k=1
Pk(Q∗
η, C∗)
pη
1/k
(14)
where Pk(Q∗
η, C∗) is the max (k, Q∗
η)-product of C∗. By our inductive assumption (that Theorem 9
holds on Q∗
η), Step 4 incurs load O(L∗
η). We will prove Pk(Q∗
η, C∗) ≤Pk(Qη, C) for every k which,
together with (8) and (14), will tell us L∗
η = O(L).
Before proceeding, the reader should recall that, for any hyperedge e∗of G∗, map−1(e∗) gives a
hyperedge in G. We must have |R∗(e∗, η)| ≤|R(map−1(e∗), η)|. To see why, note that this is true
when |R∗(e∗, η)| is created in Step 2, whereas R∗(e∗, η) can only shrink in Steps 3-5.
To prove Pk(Q∗
η, C∗) ≤Pk(Qη, C), consider any k-group K∗of C∗.
By Lemma 6, K =
{map−1(e∗) | e∗∈K∗} must be a k-group of C. Since |R∗(e∗, η)| ≤|R(map−1(e∗), η)| for any
e∗∈K∗, we have Q
e∗∈K∗|R∗(e∗, η)| ≤Q
e∈K |R(e, η)| ≤Pk(Qη, C). Therefore:
Pk(Q∗
η, C∗) = max
K∗
Y
e∗∈K∗
|R∗(e∗, η)| ≤Pk(Qη, C).
10The R(e0, η) of all the η are mutually disjoint and their union equals R(e0).
11Step 3 performs O(1) semi joins, each of which can be performed by sorting. For sorting in the MPC model, see
Section 2.2.1 of [10]. The stated bound for Step 1 and 3 requires the assumption p ≤m1−ϵ.
16

---

4.3
Light Qη
This subsection will concentrate on the algorithm of Section 3.3.
Load. Step 1 incurs load O(L) (same analysis as in Section 3.2). Step 2 also requires a load of
O(L) because every broadcast relation has a size of at most L. Step 4 needs no communication.
To analyze Step 3, let us ﬁrst consider ¯Q∗
η. The ¯Q∗
η-induced load of the clustering ¯C∗is
¯L∗
η
=
| ¯C∗|
max
k=1
 
Pk( ¯Q∗
η, ¯C∗)
¯pη
!1/k
where Pk( ¯Q∗
η, ¯C∗) as the max (k, ¯Q∗
η)-product of ¯C∗. By our inductive assumption (that Theorem 9
holds on ¯Q∗
η), answering ¯Q∗
η with ¯pη machines requires load O(¯L∗
η), which is O(L) given the ¯pη in
(10). A similar argument shows that answering each Q∗
η,z with pη,z machines — with pη,z given in
(9) — incurs a load of O(L). Thus, the cartesian product at Step 3 can be computed with load
O(L).
Number of machines in Step 3. Next, we will prove that ¯pη · Q
z∈Z pη,z ≤pη always holds in
Step 3. It suﬃces to show ¯pη · Q
z∈Z pη,z = O(pη) which, as we will see, relies on Lemma 8 and the
fact that |R(e, η)| ≤L for every node e ∈sigpath(f◦, T).
Consider an arbitrary z ∈Z. The root of T ∗
z — denoted as eroot — must belong to sigpath(f◦, T).
Recall that a k-group K of C∗
z takes a hyperedge from a distinct cluster in C∗
z. Call K a non-root
k-group if eroot /∈K, or a root k-group, otherwise. Deﬁne
Pk(Q∗
η,z, C∗
z)
=
max (k, Q∗
η,z)-product of C∗
z
P non
k
(Q∗
η,z, C∗
z)
=
max (k, Q∗
η,z)-product of all the non-root k-groups of C∗
z.
As a special case, deﬁne P non
0
(Q∗
η,z, C∗
z) = 1. For any k, we observe
Pk(Q∗
η,z, C∗
z)
≤
max{P non
k
(Q∗
η,z, C∗
z), L · P non
k−1(Q∗
η,z, C∗
z)}.
(15)
To prove the inequality, ﬁx K to the k-group with the largest Q∗
η,z-product (= Pk(Q∗
η,z, C∗
z)). If
K is a non-root k-group, (15) obviously holds. Consider, instead, that K is a root k-group. Since
eroot ∈sigpath(f◦, T), we know |R(eroot, η)| ≤L and hence Q
e∈K |R(e, η)| ≤L·Q
e∈K\{eroot} |R(e, η)|.
As K \ {eroot} is a non-root (k −1)-group, Pk(Q∗
η,z, C∗
z) ≤L · P non
k−1(Q∗
η,z, C∗
z) holds.
Equipped with (15), we can now derive from (9):
pη,z
=
O

1 +
|F ∗
z |
max
k=1
max{P non
k
(Q∗
η,z, C∗
z), L · P non
k−1(Q∗
η,z, C∗
z)}
Lk

=
O

1 +
|F ∗
z |−1
max
k=1
P non
k
(Q∗
η,z, C∗
z)
Lk

(16)
where the second equality used the fact that, when k = |F ∗
z |, a k-group must be a root k-group.
We are now ready to prove ¯pη · Q
z∈Z pη,z = O(pη). For each z ∈Z, deﬁne integer kz and a set
Kz of hyperedges as follows:
• If (16) = Θ(P non
k
(Q∗
η,z, C∗
z)/Lk) for some k ∈[1, |F ∗
z | −1], set kz = k and Kz to the non-root
k-group whose Q∗
η,z-product equals P non
k
(Q∗
η,z, C∗
z).
17

---

• Otherwise (we must have pη,z = Θ(1)), set kz = 0 and Kz = ∅; furthermore, deﬁne the
Q∗
η,z-product of Kz to be 1.
Similarly, regarding ¯pη in (10), deﬁne integer ¯k and a set ¯K of hyperedges as follows:
• If (10) = Θ(Pk( ¯Q∗
η, ¯C∗)/Lk) for some k ∈[1, | ¯F ∗|], set ¯k = k and ¯K to the k-group of the
clustering ¯C∗whose ¯Q∗
η-product equals Pk( ¯Q∗
η, ¯C∗).
• Otherwise, set ¯k = 0 and ¯K = ∅; furthermore, deﬁne the ¯Q∗
η-product of ¯K to be 1.
Deﬁne Ksuper = ¯K ∪
 S
z∈Z Kz

. If Ksuper = ∅, then pη,z = Θ(1) for all z ∈Z and ¯pη = Θ(1),
which leads to
¯pη ·
Y
z∈Z
pη,z = O(1) = O(pη).
If Ksuper̸ = ∅, Ksuper is a super-|Ksuper|-group12. By Lemma 8, Ksuper is a |Ksuper|-group of T. We
thus have:
¯pη ·
Y
z∈Z
pη,z
=
¯Q∗
η-product of ¯K
L¯k
Y
z∈Z
Q∗
η,z-product of Kz
Lkz
=
Q
e∈Ksuper |R(e)|
L|Ksuper|
≤max (|Ksuper|, Qη)-product of C
L|Ksuper|
= O(pη).
This completes the whole proof of Theorem 9.
References
[1] Serge Abiteboul, Richard Hull, and Victor Vianu. Foundations of Databases. Addison-Wesley,
1995.
[2] Foto N. Afrati, Manas R. Joglekar, Christopher R´e, Semih Salihoglu, and Jeﬀrey D. Ullman.
GYM: A multiround distributed join algorithm. In Proceedings of International Conference on
Database Theory (ICDT), pages 4:1–4:18, 2017.
[3] Foto N. Afrati and Jeﬀrey D. Ullman. Optimizing multiway joins in a map-reduce environment.
IEEE Transactions on Knowledge and Data Engineering (TKDE), 23(9):1282–1298, 2011.
[4] Kaleb Alway, Eric Blais, and Semih Salihoglu. Box covers and domain orderings for beyond
worst-case join processing. In Proceedings of International Conference on Database Theory
(ICDT), pages 3:1–3:23, 2021.
[5] Albert Atserias, Martin Grohe, and Daniel Marx. Size bounds and query plans for relational
joins. SIAM Journal of Computing, 42(4):1737–1767, 2013.
[6] Paul Beame, Paraschos Koutris, and Dan Suciu. Communication steps for parallel query
processing. Journal of the ACM (JACM), 64(6):40:1–40:58, 2017.
[7] Christoph Berkholz, Jens Keppeler, and Nicole Schweikardt. Answering conjunctive queries
under updates. In Proceedings of ACM Symposium on Principles of Database Systems (PODS),
pages 303–318, 2017.
12For the deﬁnition of super-k-group, review Section 2.2.2.
18

---

[8] Xiao Hu. Cover or pack: New upper and lower bounds for massively parallel joins. In Proceedings
of ACM Symposium on Principles of Database Systems (PODS), pages 181–198, 2021.
[9] Xiao Hu and Ke Yi. Instance and output optimal parallel algorithms for acyclic joins. In
Proceedings of ACM Symposium on Principles of Database Systems (PODS), pages 450–463,
2019.
[10] Xiao Hu, Ke Yi, and Yufei Tao. Output-optimal massively parallel algorithms for similarity
joins. ACM Transactions on Database Systems (TODS), 44(2):6:1–6:36, 2019.
[11] Muhammad Idris, Mart´ın Ugarte, and Stijn Vansummeren. The dynamic yannakakis algorithm:
Compact and eﬃcient query processing under updates. In Proceedings of ACM Management of
Data (SIGMOD), pages 1259–1274. ACM, 2017.
[12] Bas Ketsman and Dan Suciu. A worst-case optimal multi-round algorithm for parallel compu-
tation of conjunctive queries. In Proceedings of ACM Symposium on Principles of Database
Systems (PODS), pages 417–428, 2017.
[13] Bas Ketsman, Dan Suciu, and Yufei Tao. A near-optimal parallel algorithm for joining binary
relations. CoRR, abs/2011.14482, 2020.
[14] Mahmoud Abo Khamis, Hung Q. Ngo, Christopher R´e, and Atri Rudra. Joins via geometric
resolutions: Worst-case and beyond. In Proceedings of ACM Symposium on Principles of
Database Systems (PODS), pages 213–228, 2015.
[15] Paraschos Koutris, Paul Beame, and Dan Suciu. Worst-case optimal algorithms for parallel
query processing. In Proceedings of International Conference on Database Theory (ICDT),
pages 8:1–8:18, 2016.
[16] Hung Q. Ngo, Dung T. Nguyen, Christopher Re, and Atri Rudra. Beyond worst-case analysis
for joins with minesweeper. In Proceedings of ACM Symposium on Principles of Database
Systems (PODS), pages 234–245, 2014.
[17] Hung Q. Ngo, Ely Porat, Christopher Re, and Atri Rudra. Worst-case optimal join algorithms:
[extended abstract]. In Proceedings of ACM Symposium on Principles of Database Systems
(PODS), pages 37–48, 2012.
[18] Hung Q. Ngo, Ely Porat, Christopher Re, and Atri Rudra. Worst-case optimal join algorithms.
Journal of the ACM (JACM), 65(3):16:1–16:40, 2018.
[19] Hung Q. Ngo, Christopher Re, and Atri Rudra. Skew strikes back: new developments in the
theory of join algorithms. SIGMOD Rec., 42(4):5–16, 2013.
[20] Miao Qiao and Yufei Tao. Two-attribute skew free, isolated CP theorem, and massively parallel
joins. In Proceedings of ACM Symposium on Principles of Database Systems (PODS), pages
166–180, 2021.
[21] Yufei Tao. A simple parallel algorithm for natural joins on binary relations. In Proceedings of
International Conference on Database Theory (ICDT), pages 25:1–25:18, 2020.
[22] Mihalis Yannakakis. Algorithms for acyclic database schemes. In Proceedings of Very Large
Data Bases (VLDB), pages 82–94, 1981.
19

---

Appendix
A
Proof of Lemma 1
We ﬁrst show that F is an edge cover of G. Each attribute X ∈V is a disappearing attribute of
some hyperedge e ∈E. When e is processed at Line 4 of edge-cover, either X is already covered or
e itself will be added to Ftmp (which will then cover X).
Next, we argue that F is an optimal edge cover (i.e., having the smallest size). Let F ′ be an
arbitrary optimal edge cover of G. We will establish a one-one mapping between F and F ′, which
implies the optimality of F.
Fix an arbitrary hyperedge e ∈F. If e also belongs to F ′, we map e to its copy in F ′. Consider
the opposite case where e /∈F ′. The fact e ∈F indicates that when edge-cover processes e, e
must contain a disappearing attribute X that has not been covered by Ftmp. Let e′ ∈F ′ be an
arbitrary hyperedge containing X; we map e to e′. As explained in Section 2.1, e′ must be a proper
descendant of e in T.
We argue that no two e and ˆe in F can be mapped to the same hyperedge e′ ∈F. If this
happens, e′ is a descendant of both e and ˆe. Assume, without loss of generality, that e is a proper
descendant of ˆe. Since ˆe is mapped to e′, there is an attribute Y such that
• Y is a disappearing attribute in ˆe not covered by Ftmp when edge-cover adds ˆe to Ftmp;
• Y ∈e′.
Because e is on the path from ˆe to e′ in T, connectedness of acyclicity guarantees Y ∈e. On the
other hand, e ∈F and e is processed before ˆe (reverse topological order). Thus, when ˆe is processed,
e ∈Ftmp and hence Y must be covered by Ftmp, giving a contradiction.
We now proceed to show that F does not depend on the reverse topological order at Line 2.
Recall that, when processing a node e, edge-cover adds it to Ftmp if and only if Ftmp does not
cover a disappearing attribute X of e. All the nodes containing X must appear in the subtree of T
rooted at e and thus must be processed before e. Hence, whether e ∈F is determined by which of
those nodes are selected into Ftmp. The observation gives rise to an inductive argument. First, if
e is a leaf, e enters Ftmp if and only if it has a disappearing attribute (which must be exclusive),
independent of the reverse topological order used. For a non-leaf node e, inductively, once we have
decided whether e′ ∈Ftmp for every proper descendent e′ of e, whether e ∈Ftmp has also been
decided. We thus conclude that the reverse topological order has no inﬂuence on the output.
It remains to show that when G is clean, F must include all the raw leaf nodes e of T. If e is
not the root of T, it must have an attribute X absent from the parent node of e (otherwise, e is
subsumed by its parent and G is not clean). Similarly, if e is the root of T, it must have an attribute
X absent from its child (there is only one child because e is a raw leaf). In both cases, the attribute
X is exclusive at e and will force edge-cover to add e to Ftmp.
B
Proof of Lemma 2
Identify an arbitrary non-leaf node ˆf ∈F such that no other non-leaf node in F is lower than ˆf.
The existence of ˆf is guaranteed because F includes the root of T. Consider any child node e of ˆf
in T. Since G is clean, e must have an attribute A◦that does not appear in ˆf. Let f◦be any node
20

---

in F that contains A◦. By the connectedness requirement of acyclicity, f◦must be in the subtree of
T rooted at e and, therefore, must be a leaf.
We argue that f◦is an anchor leaf. The signature path of f◦includes all the nodes on the
path from e to f◦. Because A◦∈e and A◦∈f◦, A◦must appear in all the nodes on the path
(connectedness requirement) and is thus an anchor attribute of f◦.
C
Proof of Lemma 3
C.1
map(f ◦) Subsumed in G′
Let ˆe be the parent of f◦in T. If map(f◦) = f◦\ {A◦} is subsumed in G′, then map(f◦) must be a
subset of map(ˆe), which indicates A◦/∈ˆe (otherwise, f◦⊆ˆe and G is not clean). Because A◦needs
to appear in all the nodes of sigpath(f◦, T), A◦/∈ˆe indicates that sigpath(f◦, T) has only a single
node f◦. It thus follows that ˆe ∈F and A◦is an exclusive attribute in f◦. Hence, the removal of
A◦does not aﬀect any hyperedge except f◦.
Next, we show that F ′ = F \ {f◦} is the CEC of G′ induced by T ′. It suﬃces to prove that F ′
is the output of edge-cover(T ′) on some reverse topological order of T ′. For this purpose, consider
σ0 as an arbitrary reverse topological order of T where ˆe succeeds f◦. Let σ1 be the sequence
obtained by removing f◦from σ0; σ1 must be a reverse topological order of T ′. Let ebefore be the
node preceding f◦in σ0 (and hence preceding ˆe in σ1); deﬁne ebefore to be a dummy node if f◦is
the ﬁrst in σ0.
Let us compare the execution of edge-cover(T) on σ0 to that of edge-cover(T ′) on σ1. The
two executions are identical till the moment when ebefore has been processed. By the fact that
edge-cover(T) adds ˆe to Ftmp (we have proved earlier ˆe ∈F), ˆe has a disappearing attribute not
covered by Ftmp when ˆe is processed. Hence, when ˆe is processed by edge-cover(T ′), it must also
have a disappearing attribute not covered by Ftmp and thus is added to Ftmp. The rest execution of
edge-cover(T) is the same as that of edge-cover(T ′) because every non-exclusive attribute of f◦is in
ˆe. Therefore, the output of edge-cover(T ′) is the same as that of edge-cover(T), except that the
former does not include f◦.
C.2
map(f ◦) Not Subsumed in G′
Let σ0 = (e1, e2, ..., e|E|) be an arbitrary reverse topological order of T. Deﬁne e′
i = map(ei) =
ei \ {A◦} for i ∈[|E|]. The sequence σ1 = (e′
1, e′
2, ..., e′
|E|) is a reverse topological order of T ′. We
will compare the execution of edge-cover(T) on σ0 to that of edge-cover(T ′) on σ1. Deﬁne F0(ei)
(resp., F1(e′
i)) as the content of Ftmp after edge-cover(T) (resp., edge-cover(T ′)) has processed ei
(resp., e′
i).
Claim 1: For any leaf e of T, edge-cover(T ′) must add e′ = map(e) to Ftmp.
Let us prove the claim. Because e is a leaf of T and G is clean, e must have an exclusive attribute
X. If edge-cover does not add e′ to Ftmp, e′ has no exclusive attributes in T ′. This implies X = A◦,
which further implies f◦= e (otherwise, A◦appears in two distinct nodes and cannot be exclusive).
However, in that case, e′ must contain an exclusive attribute in T ′ (e′ = map(f◦) is not subsumed
in G′). We thus have reached a contradiction.
To establish Lemma 3, it suﬃces to prove:
21

---

Claim 2: For each i, ei ∈F0(ei) if and only if e′
i ∈F1(e′
i).
We prove the claim by induction on i. Because e1 is a leaf of T, Lemma 1 and Claim 1 guarantee
e1 ∈F0(e1) and e′
1 ∈F1(e′
1), respectively. Thus, Claim 2 holds for i = 1.
Next, we prove the correctness on i > 1, assuming that it holds on ei−1 and e′
i−1. The inductive
assumption implies that F0(ei−1) covers an attribute X̸ = A◦if and only if F1(e′
i−1) covers X. If
ei /∈F0(ei), every disappearing attribute of ei must be covered by F0(ei−1). Hence, F1(e′
i−1) must
cover all the disappearing attributes of e′
i and thus e′
i /∈F1(e′
i).
The rest of the proof assumes ei ∈F0(ei), i.e., ei has a disappearing attribute X not covered
by F0(ei−1). If X̸ = A◦, X is a disappearing attribute in e′
i not covered by F1(e′
i−1) and thus
e′
i ∈F1(e′
i). It remains to discuss the scenario X = A◦. As A◦is disappearing at ei, A◦cannot exist
in the parent of ei. On the other hand, because A◦∈f◦, acyclicity’s connectedness requirement
forces f◦to be a descendant of ei. We can safely conclude that f◦= ei; otherwise, the leaf f◦is
processed before ei and must exist in F0(ei−1) (Lemma 1), contradicting the fact that A◦is not
covered by F0(ei−1). Then, e′
i ∈F1(e′
i) follows from Claim 1.
D
Proof of Lemma 4
Deﬁne e = map−1(e′). Because e′ is subsumed, we know that e must contain A◦(otherwise, e
is subsumed and G is not clean). In other words, e = e′ ∪{A◦}. Furthermore, if e = f◦, then
map(f◦) = map(e) = e′ is subsumed in G′, in which case we must have e′ /∈F ′ (by the way we
deﬁne F ′ in (2)). Next, we assume e̸ = f◦. To complete the proof, it suﬃces to show that e /∈F,
where F is the CEC of G induced by T.
Let ˆf be the lowest proper ancestor of f◦in F (here, “ancestor” is deﬁned with respect to T).
By deﬁnition of A◦, A◦/∈ˆf. Because A◦∈f◦and A◦∈e, e must be a proper descendant of ˆf in T.
Assume, for contradiction purposes, that e ∈F. As ˆf (by deﬁnition of f◦) cannot have any non-leaf
proper descendant in F, e must be a leaf of T.
Because A◦appears in two distinct nodes e and f◦, acyclicity’s connected requirement demands
that A◦should also exist in the parent ˆe of e. Because G is clean, we know that e must have at
least one attribute X that does not appear in ˆe and thus must be exclusive. It follows that X̸ = A◦.
However, in that case e′ = e \ {A◦} contains X and thus cannot be subsumed in G′ (X remains
exclusive in G′), giving a contradiction.
E
Proof of Lemma 5
We discuss only the scenario where map(f◦) is not subsumed in G′ (the opposite case is easy and
omitted). Our proof will establish a stronger claim:
Claim: F ∗= F ′ is the CEC of G∗induced by T ∗every time Line 2 of cleanse is executed.
G∗= G′ and T ∗= T ′ at Line 1. F ∗= F ′ is the CEC of G∗induced by T ∗at this moment
(Lemma 3). Hence, the claim holds on the ﬁrst execution of Line 2.
Inductively, assuming that the claim holds currently, we will show that it still does after cleanse
deletes the next esmall from G∗. Let G∗
0 and T ∗
0 (resp., G∗
1 and T ∗
1 ) be the G∗and T ∗before (resp.,
after) the deletion of esmall, respectively. The fact esmall being subsumed in G∗suggests esmall being
subsumed in G′. By Lemma 4, esmall /∈F ′ = F ∗.
22

---

Case 1: ebig parents esmall. Let σ0 be a reverse topological order of T ∗
0 where ebig succeeds esmall.
As F ∗is the CEC of G∗
0 induced by T ∗
0 , edge-cover(T ∗
0 ) produces F ∗if executed on σ0 (Lemma 1).
Let σ1 be a copy of σ0 but with esmall removed; σ1 is a reverse topological order of T ∗
1 . Every
node in T ∗
1 retains the same disappearing attributes as in T ∗
0 (see Figure 3a). For every node
e̸ = esmall, running edge-cover(T ∗
1 ) on σ1 has the same eﬀect as running edge-cover(T ∗
0 ) on σ0.
Therefore, edge-cover(T ∗
1 ) also outputs F ∗.
Case 2: esmall parents ebig. Let σ0 be a reverse topological order of T ∗
0 where esmall succeeds
ebig. Let σ1 be a copy of σ0 but with esmall removed; σ1 is a reverse topological order of T ∗
1 . We
will argue that running edge-cover(T ∗
1 ) on σ1 returns F ∗.
The reader should note several preliminary facts about disappearing attributes. If an attribute
has esmall as the summit in T ∗
0 , the attribute’s summit in T ∗
1 becomes ebig (see Figure 3b). If an
attribute has e̸ = esmall as the summit in T ∗
0 , its summit in T ∗
1 is still e. Hence, every node in T ∗
1
except ebig retains the same disappearing attributes as in T ∗
0 , whereas the disappearing attributes
of ebig in T ∗
1 contain those of ebig and esmall in T ∗
0 .
For each node e in σ0 (resp. σ1), denote by F0(e) (resp. F1(e)) the content of Ftmp after edge-
cover(T ∗
0 ) (resp. edge-cover(T ∗
1 )) has processed e. Let ebefore be the node before ebig in σ0.13 It is
easy to see that edge-cover(T ∗
0 ) and edge-cover(T ∗
1 ) behave the same way until ﬁnishing with ebefore,
which gives F0(ebefore) = F1(ebefore). It must hold that esmall /∈F0(esmall).14 Two possibilities apply
to ebig:
1. ebig ∈F0(ebig). Hence, ebig has a disappearing attribute in T ∗
0 not covered by F0(ebefore). This
means that ebig also has a disappearing attribute in T ∗
1 not covered by F1(ebefore) = F0(ebefore).
It follows that ebig ∈F1(ebig), meaning F1(ebig) = F0(ebig) = F0(esmall).
2. ebig /∈F0(ebig). All the disappearing attributes of ebig and esmall in T ∗
0 are covered by F0(ebefore).
Hence, the disappearing attributes of ebig in T ∗
1 are covered by F1(ebefore) = F0(ebefore).
Therefore, ebig /∈F1(ebig), meaning F0(esmall) = F0(ebefore) = F1(ebefore) = F1(ebig).
We now conclude that F1(ebig) = F0(esmall) always holds. Every remaining node in σ0 and σ1
has the same disappearing attributes in T ∗
0 and T ∗
1 . The rest execution of edge-cover(T ∗
0 ) is identical
to that of edge-cover(T ∗
1 ).
F
Proof of Lemma 6
We will discuss only the scenario where map(f◦) is not subsumed (the opposite scenario is easy and
omitted).
Departing from acyclic queries, let us consider a more general problem on a rooted tree T where
(i) every node is colored black or white, and (ii) the root and all the leaves are black. Denote by B
the set of black nodes. Each black node b ∈B is associated with a signature path:
• If b is the root of T , its signature path contains just b itself.
• Otherwise, let ˆb be the lowest ancestor of b among all the nodes in B; the signature path of b
is the set of nodes on the path from ˆb to b, except ˆb.
13In the special case where ebig is the ﬁrst in σ0, deﬁne ebefore as a dummy node with F0(ebefore) = F1(ebefore) = ∅.
14Otherwise, esmall ∈F ∗, contradicting Lemma 4.
23

---

v1
v2
v1
v1
v2
v2
(a) Type 1
(b) Type 2
v1
v2
v1
v1
v2
v2
(c) Type 3
(d) Type 4
Figure 6: Four types of contraction
We deﬁne four types of contractions:
• Type 1: We are given two white nodes v1 and v2 such that v1 parents v2. The contraction
removes v2 from T and makes v1 the new parent for all the child nodes of v2. See Figure 6a.
• Type 2: We are given two white nodes v1 and v2 such that v1 parents v2. The contraction
removes v1 from T , makes v2 the new parent for all the child nodes of v1, and makes v2 a
child of the original parent of v1. See Figure 6b.
• Type 3: Same as Type 1, except that v1 is black and v2 is white. See Figure 6c.
• Type 4: Same as Type 2, except that v1 is white and v2 is black. See Figure 6d.
The facts below are evident:
• The number of black nodes remains the same after a contraction.
• After a contraction, each signature path either remains the same or shrinks.
We now draw correspondence between a contraction and a hyperedge deletion in cleanse. T
corresponds to the current hyperedge tree T ∗in cleanse. The set B of black nodes equals F ∗= F ′ for
the entire execution of cleanse. The set {v1, v2} corresponds to {esmall, ebig}. As shown in Lemma 4,
esmall cannot exist in F ∗and thus cannot correspond to a black node. If we denote by C (resp.,
C∗) the set of signature paths at the beginning (resp., end) of cleanse, each signature path in C∗is
obtained by continuously shrinking a distinct signature path in C. This implies Lemma 6, noticing
that C = {sigpath(f, T) | f ∈F} and C∗= {sigpath(f∗, T ∗) | f∗∈F ∗}.
G
Proof of Lemma 7
We will ﬁrst prove that, for any z ∈Z, F ∗
z is the CEC of G∗
z induced by T ∗
z . Let ˆz be the parent
of z. Recall that F is the CEC of G induced by T. Consider a reverse topological order σz of T
satisfying the following condition: a preﬁx of σz is a permutation of the nodes in the subtree of
T rooted at z. In other words, in σz, every node in the aforementioned subtree must rank before
every node outside the subtree. Deﬁne σ∗
z to be the sequence obtained by deleting from σz all the
24

---

nodes e such that e̸ = ˆz and e is outside the subtree of T rooted at z. It is clear that σ∗
z is a reverse
topological order of T ∗
z .
Let us compare the execution of edge-cover(T) on σ to that of edge-cover(T ∗
z ) on σ∗
z. They are
exactly the same until z has been processed. Hence, every node in the Ftmp of edge-cover(T) at this
moment must have been added to Ftmp by edge-cover(T ∗
z ). This means that all the nodes in F ∗
z ,
except ˆz, must appear in the ﬁnal Ftmp output by edge-cover(T ∗
z ). Finally, the ﬁnal Ftmp must also
contain ˆz as well due to Lemma 1 (notice that ˆz is a raw leaf of T ∗
z ). This shows that F ∗
z is the
CEC of G∗
z induced by T ∗
z .
Next, we prove that ¯F ∗is the CEC of ¯G∗induced by ¯T ∗.
Let ¯e be the highest node in
sigpath(f◦, T). Consider a reverse topological order ¯σ of T satisfying the following condition: a
preﬁx of ¯σ is a permutation of the nodes in the subtree of T rooted at ¯e. Deﬁne ¯σ∗to be the
sequence obtained by deleting that preﬁx from ¯σ. It is clear that ¯σ∗is a reverse topological order of
¯T ∗. Deﬁne ˆ¯e to be the parent of ¯e in T. Note that ˆ¯e must belong to F due to the deﬁnitions of ¯e
and sigpath(f◦, T)
We will compare the execution of edge-cover(T) on σ to that of edge-cover( ¯T ∗) on ¯σ∗. For each
e in σ, deﬁne F0(e) as the content of Ftmp after edge-cover(T) has ﬁnished processing e. Similarly,
for each e in ¯σ∗, deﬁne F1(e) as the content of Ftmp after edge-cover( ¯T ∗) has ﬁnished processing e.
Divide σ into three segments: (i) σ1, which includes the preﬁx of σ ending at (and including) ¯e,
(ii) σ2, which starts right after σ1 and ends at (and includes) ˆ¯e, and (iii) σ3, which is the rest of σ.
Note that ¯σ∗is the concatenation of σ2 and σ3.
Claim 1: For any e in σ2, e ∈F0(e) if and only if e ∈F1(e).
We prove the claim by induction. As the base case, consider e as the ﬁrst element in σ2. In ¯T ∗,
e must be a leaf and, by Lemma 1, must be in F1(e). In T, e is either a leaf or ˆ¯e. In the former
case, Lemma 1 assures us e ∈F0(e). In the latter case, e is also in F0(e) because ˆ¯e ∈F.
Next, we prove the claim on every other node e in σ2, assuming the claim’s correctness on the node
ebefore preceding e in σ2. This inductive assumption implies F1(ebefore) ⊆F0(ebefore). If e ∈F0(e),
then e has a disappearing attribute X not covered by F0(ebefore). As F1(ebefore) ⊆F0(ebefore),
F1(ebefore) does not cover X, either. Hence, edge-cover( ¯T ∗) adds e to Ftmp, namely, e ∈F1(e).
Let us now focus on the case where e ∈F1(e). If e = ˆ¯e, the fact ˆ¯e ∈F indicates e ∈F0(e). Next,
we consider e̸ = ˆ¯e, meaning that e is a proper descendant of ˆ¯e. The fact e ∈F1(e) suggests that
e has a disappearing attribute X not covered by F1(ebefore). If e /∈F0(e), F0(ebefore) must have
a node e′ containing X. Node e′ must come from σ1 (the inductive assumption prohibits e′ from
appearing in σ2) and hence must be a descendant of ¯e. By acyclicity’s connectedness requirement,
X appearing in both e and e′ means that X must belong to ˆ¯e. But this contradicts X disappearing
at e. We thus conclude that e ∈F0(e).
Claim 2: For any e in σ3, e ∈F0(e) if and only if e ∈F1(e).
Claim 1 assures us that F1(ˆ¯e) ⊆F0(ˆ¯e). Note also that ˆ¯e belongs to F0(ˆ¯e) (as explained before,
ˆ¯e ∈F) and hence also to F1(ˆ¯e) (Claim 1). Any node e′ ∈F0(ˆ¯e) \ F1(ˆ¯e) must appear in the
subtree rooted at ˆ¯e in T, whereas any node e in σ3 must be outside that subtree. By acyclicity’s
connectedness requirement, if e′ contains an attribute X in e, then X ∈ˆ¯e for sure. This means that
F1(ˆ¯e) covers a disappearing attribute of e if and only if F0(ˆ¯e) does so. Therefore, edge-cover( ¯T ∗)
processes each node of σ3 in the same way as edge-cover(T). This proves the correctness of Claim 2.
25

---

By putting Claim 1 and 2 together, we conclude that edge-cover( ¯T ∗) returns all and only
the attributes in σ2 ∪σ3 output by edge-cover(T). Therefore, the output of edge-cover( ¯T ∗) is
F ∩¯E∗= ¯F ∗.
H
Proof of Lemma 8
For any f∗∈F ∗
z and any z ∈Z that is not the root of T ∗
z , it holds that sigpath(f∗, T ∗
z ) ⊆
sigpath(f∗, T). Similarly, for any f∗∈¯F ∗, it holds that sigpath(f∗, ¯T ∗) ⊆sigpath(f∗, T). To
prove the lemma, it suﬃces to show that, given a super-k-group K = {e1, ..., ek}, we can always
assign each ei, i ∈[k], to a distinct cluster in {sigpath(f, T) | f ∈F}. This is easy: if ei is picked
from sigpath(f∗, T ∗
z ) for some z ∈F and f∗∈F ∗
z , assign ei to sigpath(f∗, T); if ei is picked from
sigpath(f∗, ¯T ∗) for some f∗∈¯F ∗, assign ei to sigpath(f∗, T).
26

---

