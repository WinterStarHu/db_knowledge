# Diversity of Answers to Conjunctive Queries

> 来源: https://arxiv.org/pdf/2301.08848

Logical Methods in Computer Science
Volume 21, Issue 1, 2025, pp. 9:1–9:35
https://lmcs.episciences.org/
Submitted
Nov. 01, 2023
Published
Jan. 28, 2025
DIVERSITY OF ANSWERS TO CONJUNCTIVE QUERIES
TIMO CAMILLO MERKL
a, REINHARD PICHLER
a,b, AND SEBASTIAN SKRITEK
a
TU Wien, Vienna, Austria
e-mail address: timo.merkl@tuwien.ac.at, reinhard.pichler@tuwien.ac.at, sebastian.skritek@tuwien.ac.at
Abstract. Enumeration problems aim at outputting, without repetition, the set of so-
lutions to a given problem instance. However, outputting the entire solution set may be
prohibitively expensive if it is too big. In this case, outputting a small, sufficiently diverse
subset of the solutions would be preferable. This leads to the Diverse-version of the original
enumeration problem, where the goal is to achieve a certain level d of diversity by selecting
k solutions. In this paper, we look at the Diverse-version of the query answering problem
for Conjunctive Queries and extensions thereof. That is, we study the problem if it is
possible to achieve a certain level d of diversity by selecting k answers to the given query
and, in the positive case, to actually compute such k answers.
1. Introduction
The notion of solutions is ubiquitous in Computer Science and there are many ways of defining
computational problems to deal with them. Decision problems, for instance, may ask if the
set of solutions is non-empty or test for a given candidate if it indeed is a solution. Search
problems aim at finding a concrete solution and counting problems aim at determining the
number of solutions. In recent time, enumeration problems, which aim at outputting, without
repetition, the set of solutions to a given problem instance have gained a lot of interest, which
is, for instance, witnessed by two recent Dagstuhl seminars on this topic [BKPS19, FGS18].
Also in the Database Theory community, enumeration problems have played a prominent role
on the research agenda recently, see e.g., [AJMR22, KKW22, LP22, DST23, MR23, CS23].
Here, the natural problem to consider is query answering with the answers to a given query
constituting the “solutions” to this problem.
It is well known that even seemingly simple problems, such as answering an acyclic
Conjunctive Query, can have a huge number of solutions. Consequently, specific notions
of tractability were introduced right from the beginning of research on enumeration prob-
lems [JPY88] to separate the computational intricacy of a problem from the mere size of
the solution space. However, even with these refined notions of tractability, the usefulness of
flooding the user with tons of solutions (many of them possibly differing only minimally)
Key words and phrases: Query Answering, Diversity of Solutions, Complexity, Algorithms.
∗This is an extended and enhanced version of an article published at ICDT 2023 [MPS23].
∗This work was supported by the Austrian Science Fund (FWF) project P30930-N35 and by the Vienna
Science and Technology Fund (WWTF) [10.47379/ICT2201].
LOGICAL METHODSl IN COMPUTER SCIENCE
DOI:10.46298/LMCS-21(1:9)2025
©
T. Merkl, R. Pichler, and S. Skritek
CC
⃝
Creative Commons

---

9:2
T. Merkl, R. Pichler, and S. Skritek
Vol. 21:1
may be questionable. If the solution space gets too big, it would be more useful to provide
an overview by outputting a “meaningful” subset of the solutions. One way of pursuing
this goal is to randomly select solutions (also known as “sampling”) as was, for instance,
done in [ACJR19, CZB+22]. In fact, research on sampling has a long tradition in the Data-
base community [CM99] – above all with the goal of supporting more accurate cardinality
estimations [LRG+17, LWYZ19, ZCL+18].
A different approach to providing a “meaningful” subset of the solution space aims at
outputting a small diverse subset of the solutions. This approach has enjoyed considerable
popularity in the Artificial Intelligence community [BFJ+22, EEEF13, Nad11] – especially
when dealing with Constraint Satisfaction Problems (CSPs) [HHOW05, IdlBST20, PT15].
For instance, consider a variation of the car dealership example from [HHOW05]. Suppose
that I models the preferences of a customer and S(I) are all cars that match these restrictions.
Now, in a large dealership, presenting all cars in S(I) to the customer would be infeasible.
Instead, it would be better to go through a rather small list of cars that are significantly
different from each other. With this, the customer can point at those cars which the further
discussion with the clerk should concentrate on.
Due to the inherent hardness of achieving the maximal possible diversity [HHOW05],
the Database community – apart from limited exceptions [DF14] – focused on heuristic and
approximation methods to find diverse solutions (see [ZWQ+17] for an extensive survey).
Also, there, diversification is usually treated as a post-processing task that is applied to a
set of solutions after materializing it.
The goal of our work is therefore to broaden the understanding of the theoretical
boundaries of diverse query answering and develop complementary exact algorithms. More
specifically, we want to analyze diversity problems related to answering Conjunctive Queries
(CQs) and extensions thereof. As pointed out in [IdlBST20], to formalize the problems
we are thus studying, we, first of all, have to fix a notion of distance between any two
solutions and an aggregator to combine pairwise distances to a diversity measure for a set of
solutions. For the distance between two answer tuples, we will use the Hamming distance
throughout this paper, that is, counting the number of positions on which two tuples differ.
Our developed techniques naturally extend to weighted Hamming distances, i.e., where each
attribute is assigned a constant weight and we sum over the weights of those attributes the
two answers differ on. However, for the sake of simplicity, we stick to the unweighted version
in our discussion. As far as the choice of an aggregator f is concerned, we impose the general
restriction that it must be computable in polynomial time1. As will be detailed below, we
will sometimes also consider more restricted cases of aggregators. Formally, for a class Q of
queries and diversity measure δ that maps k answer tuples to an aggregated distance, we
will study the following problem Diverse-Q (δ is fixed and not part of the input):
Diverse-Q
Input: A database instance I, query Q ∈Q, and integers k and d.
Question: Do there exist pairwise distinct answers γ1, . . . , γk to Q over I such that
δ(γ1, . . . , γk) ≥d?
1The reason for this restriction is simply to not dilute our discussion of the complexity of the diversity
problem with the inherent complexity of computing the diversity of a set of answers itself. If we are content
with higher complexity classes, like FPT, the time required to compute the aggregator may also take longer,
e.g., FPT time.

---

Vol. 21:1
DIVERSITY OF ANSWERS TO CONJUNCTIVE QUERIES
9:3
That is, we ask if a certain level d of diversity can be achieved by choosing k pairwise distinct
answers to a given query Q over the database instance I. We refer to {γ1, . . . , γk} as the
desired diversity set. In the literature, one can find examples of duplicates being allowed and
disallowed in the diversity set. In the present work, we disallow duplicates if not mentioned
otherwise since it seems counter-intuitive to expect a user to get a broader picture of the
solution space when being presented with the same element multiple times. However, we
note that all results in this paper remain the same no matter whether we exclude duplicates
or not – with one single exception: for the query complexity of the Diversesum-ACQ (formally
defined below) problem, we manage to show P-membership if duplicates are allowed (see
Theorem 3.10), but only FPT-membership if duplicates are excluded (see Theorem 3.9).
As far as the notation is concerned, we will denote the Hamming distance between two
answers γ, γ′ by ∆(γ, γ′). With diversity measure δ, we denote the aggregated Hamming
distances of all pairs of k answer tuples for an arbitrary, polynomial-time computable
aggregate function f.
That is, let f : S
k≥1 N
k(k−1)
2
→R and let di,j = ∆(γi, γj) for
1 ≤i < j ≤k. Then we define δ(γ1, . . . , γk) := f((di,j)1≤i<j≤k). Sometimes it will be
necessary to restrict our attention to concrete aggregators or concrete classes of aggregators.
To that end, we write δsum if the aggregator f is the sum, δmon if the aggregator f is a
monotone function, i.e., f(d1, . . . , dN) ≤f(d′
1, . . . , d′
N) whenever di ≤d′
i holds for every
i ∈{1, . . . , N} with N = k(k−1)
2
, and δwsm if the aggregator f is weakly strictly monotone
(ws-monotone) in the sense that f(d1, . . . , dN) < f(d, . . . , d) whenever di ≤d holds for every
i ∈{1, . . . , N} and at least one di < d. Note that most natural measures of diversity are
ws-monotone, e.g., aggregating via sum or min but may not be strictly monotone, e.g.,
min. To emphasize the class of diversity measures in question, we denote the corresponding
diversity problems by Diversesum-Q, Diversemon-Q, and Diversewsm-Q, respectively.
When we prove upper bounds on the complexity of several variations of the Diverse-Q
problem (in the form of membership in some favorable complexity class), we aim at the most
general setting, i.e., membership for all polynomial-time computable aggregation functions.
However, in some cases, the restriction to Diversesum-Q or Diversemon-Q will be needed in
order to achieve the desired upper bound on the complexity. In contrast, to prove lower
bounds (in the form of hardness results), we consider arbitrary ws-monotone diversity
measures, i.e., Diversewsm-Q. This means that our hardness results do not just hold for a
particular diversity measure but for all fixed, ws-monotone diversity measures.
We will analyze the Diverse-Q problem for several query classes Q – starting with the
class CQ of Conjunctive Queries and then extending our studies to the classes UCQ and
CQ¬ of unions of CQs and CQs with negation. In one case, we will also look at the class FO
of all first-order queries. Recall that, for combined complexity and query complexity, even
the question, if an answer tuple exists at all, is NP-complete for CQs [CM77]. We therefore
mostly restrict our study to acyclic CQs (ACQs, for short) with the corresponding query
classes ACQ and UACQ, allowing only ACQs and unions of ACQs, respectively. For CQs
with negation, query answering remains NP-complete even if we only allow ACQs [Lan23].
Hence, for CQ¬ we have to impose a different restriction. We thus restrict ourselves to
CQs with bounded treewidth. Finally note that, even if we have formulated Diverse-Q as a
decision problem, we also care about actually computing k solutions in case of a yes-answer.
We aim at a thorough complexity analysis of the Diverse-Q problem from various angles.
For the most part, we consider the problem parameterized by the size k of the diversity
set. In the non-parameterized case (i.e., if k is simply part of the input) we assume k to

---

9:4
T. Merkl, R. Pichler, and S. Skritek
Vol. 21:1
be given in unary representation. This assumption is motivated by the fact that for binary
representation of k, the size k of the diversity set can be exponentially larger than the input:
this contradicts the spirit of the diversity approach which aims at outputting a small (not
an exponentially big) number of diverse solutions. As is customary in the Database world,
we will distinguish combined, query, and data complexity.
Summary of results.
• We start our analysis of the Diverse-Q problem with the class of ACQs and study data
complexity, query complexity, and combined complexity. With the size k of the diversity
set as the parameter, we establish XP-membership for combined complexity, which is
strengthened to FPT-membership for data complexity. The XP-membership of combined
complexity is complemented by a W[1]-lower bound of the Diversewsm-ACQ problem. For
the non-parameterized case, we show that even the data complexity is NP-hard.
• The FPT-result of data complexity is easily extended to unions of ACQs. Actually, it even
holds for arbitrary FO-queries. However, rather surprisingly, we show that the combined
complexity and even query complexity of the Diversewsm-UACQ problem is NP-complete
even when only looking for a pair of diverse answers. That is, the hardness still holds if
the size k of the diversity set is 2 and the UACQs are restricted to unions of 2 ACQs.
• Finally, we study the Diverse-Q problem for the class CQ¬. As was mentioned above, the
restriction to ACQs is not even enough to make the query answering problem tractable.
We, therefore, study the Diverse-CQ¬ problem by allowing only classes of CQs of bounded
treewidth.
The picture is then quite similar to the Diverse-ACQ problem, featuring
analogous XP-membership, FPT-membership, W[1]-hardness, and NP-hardness results.
Structure. We present some basic definitions and results in Section 2. In particular, we will
formally introduce all concepts of parameterized complexity (complexity classes, reductions)
relevant to our study. We then analyze various variants of the Diverse-Q problem, where Q
is the class of CQs in Section 3, the class of unions of CQs in Section 4, and the class of
CQs with negation in Section 5, respectively. Some conclusions and directions for future
work are given in Section 6.
2. Preliminaries
Basics. We assume familiarity with relational databases. For basic notions such as schema,
(arity of) relation symbols, relations, (active) domain, etc., the reader is referred to any
database textbook, e.g., [AHV95]. A CQ is a first-order formula of the form
Q(X) := ∃Y
ℓ^
i=1
Ai,
with free variables X = (x1, . . . , xm) and bound variables Y = (y1, . . . , yn) such that each
Ai is an atom with variables from x1, . . . , xm, y1, . . . , yn. An answer to such a CQ Q(X)
over a database instance (or simply “database”, for short) I is a mapping γ : X →dom(I)
which can be extended to a mapping ¯γ : (X ∪Y ) →dom(I) such that instantiating each
variable z ∈(X ∪Y ) to ¯γ(z) sends each atom Ai into the database I. We write dom(I) to
denote the (finite, active) domain of I. By slight abuse of notation, we also refer to the
tuple γ(X) = (γ(x1), . . . , γ(xm)) as an answer (or an answer tuple). A UCQ is a disjunction

---

Vol. 21:1
DIVERSITY OF ANSWERS TO CONJUNCTIVE QUERIES
9:5
WN
i=1 Qi(X), where all Qi’s are CQs with the same free variables. The set of answers of a
UCQ is the union of the answers of its CQs. In a CQ with negation, we allow the Ai’s to
be either (positive) atoms or literals (i.e., negated atoms) satisfying a safety condition, i.e.,
every variable has to occur in some positive atom. An answer to a CQ with negation Q(X)
over a database I has to satisfy the condition that each positive atom is sent to an atom
in the database while each negated atom is not. The set of answers to a query Q over a
database I is denoted by Q(I).
For two mappings α and α′ defined on variable sets Z and Z′, respectively, we write
α ∼= α′ to denote that the two mappings coincide on all variables in Z ∩Z′. If this is the case,
we write α ∩α′ and α ∪α′ to denote the mapping obtained by restricting α and α′ to their
common domain or by combining them to the union of their domains, respectively. That
is, (α ∩α′)(z) = α(z) for every z ∈Z ∩Z′ and (α ∪α′)(z) is either α(z) if z ∈Z or α′(z)
otherwise. For another variable set X and z ∈Z, we write α|X and α|z for the mappings
resulting from the restriction of α to the set X ∩Z or the singleton {z}, respectively. Also,
the Hamming distance between two mappings can be restricted to a subset of the positions
(or, equivalently, of the variables): by ∆X(α, α′) we denote the number of variables in X on
which α and α′ differ.
Acyclicity and widths. In a landmark paper [Yan81], Yannakakis showed that query evaluation
is tractable (combined complexity) if restricted to acyclic CQs. A CQ is acyclic if it has a
join tree. Given a CQ Q(X) := ∃Y Vℓ
i=1 Ai with At(Q(X)) = {Ai : 1 ≤i ≤ℓ}, a join tree
of Q(X) is a triple ⟨T, λ, r⟩such that T = (V (T), E(T)) is a rooted tree with root r and
λ: V (T) →At(Q(X)) is a node labeling function that satisfies the following properties:
(1) The labeling λ is a bijection.
(2) For every v ∈X ∪Y , the set Tv = {t ∈V (T) : v occurs in λ(t)} induces a subtree T[Tv]
of T.
As is common, for a graph T = (V (T), E(T)) and H ⊆V (T), we use T[H] to denote the
subgraph of T induced by H, i.e. the subgraph consisting of H and all edges in E(T) between
nodes in H.
Testing if a given CQ is acyclic and, in case of a yes-answer, constructing a join tree is
feasible in polynomial time by the GYO-algorithm, named after the authors of [Gra79, YO79].
Another approach to making CQ answering tractable is by restricting the treewidth (tw),
which is defined via tree decompositions [RS84]. Treewidth does not generalize acyclicity,
i.e., a class of acyclic CQs can have unbounded tw. We consider tw here only for CQs
with negation. Let Q(X) := ∃Y Vℓ
i=1 Li, be a CQ with negation, i.e., each Li is a (positive
or negative) literal. Moreover, let var(Li) denote the variables occurring in Li. A tree
decomposition of Q(X) is a triple ⟨T, χ, r⟩such that T = (V (T), E(T)) is a rooted tree with
root r and χ: V (T) →2X∪Y is a node labeling function with the following properties:
(1) For every Li, there exists a node t ∈V (T) with var(Li) ⊆χ(t).
(2) For every v ∈X ∪Y , the set Tv = {t ∈V (T) : v ∈χ(t)} induces a subtree T[Tv] of T.
The property (2) is called the connectedness condition for join trees and tree decomposition.
The sets χ(t) of variables are referred to as “bags” of the tree decomposition T. The width
of a tree decomposition is defined as maxt∈V (T)(|χ(t)| −1). The treewidth of a CQ with
negation Q is the minimum width of all tree decompositions of Q. For fixed ω, it is feasible
in linear time w.r.t. the size of the query Q to decide if tw(Q) ≤ω holds and, in case of a
yes-answer, to actually compute a tree decomposition of width ≤ω [Bod96].

---

9:6
T. Merkl, R. Pichler, and S. Skritek
Vol. 21:1
Tree decompositions can be extended to hypertree decompositions (HDs) [GLS02], gener-
alized hypertree decompositions (GHDs) [AGG07], and fractional hypertree decompositions
(FHDs) [GM14] by defining an integral edge cover number (in case of HDs and GHDs) or
a fractional edge cover number (in case of FHDs) for each bag. Then the width of such a
decomposition is the maximum size of all edge cover numbers in the HD, GHD, or FHD.
Analogously to treewidth, the hypertree width hw(Q), generalized hypertree width ghw(Q),
and fractional hypertree width fhw(Q) of a given query Q is defined as the minimum width
attainable over all HDs, GHDs, or FHDs of Q, respectively. Acyclic queries are the ones
with hw = ghw = fhw = 1.
Note that bounded treewidth and acyclicity are incomparable.
Indeed, in case of
unbounded arity, even the class of single-atom queries (clearly, all such queries are trivially
acyclic) has unbounded treewidth. On the other hand, for instance, the triangle query and
its generalization to any cycles has constant treewidth 2, but these queries are, of course,
not acyclic. However, the classes of queries with bounded hw, ghw, or fhw properly contain
the classes of queries with bounded tw. Moreover, query evaluation of queries with bounded
hw, ghw, or fhw can be reduced in polynomial time to query evaluation of acyclic queries.
Essentially, the relations of the resulting acyclic query are obtained by carrying out the joins
corresponding to each edge cover.
Complexity. We follow the categorization of the complexity of database tasks introduced
in [Var82] and distinguish combined/query/data complexity of the Diverse-Q problem. That
is, for data complexity, we consider the query Q as arbitrarily chosen but fixed, while for
query complexity, the database instance I is considered fixed. In case of combined complexity,
both the query and the database are considered as variable parts of the input.
We assume familiarity with the fundamental complexity classes P (polynomial time) and
NP (non-deterministic polynomial time). We study the Diverse-Q problem primarily from a
parameterized complexity perspective [DF99]. An instance of a parameterized problem is
given as a pair (x, k), where x is the actual problem instance and k is a parameter – usually
a non-negative integer. The effort for solving a parameterized problem is measured by a
function that depends on both, the size |x| of the instance and the value k of the parameter.
The asymptotic worst-case time complexity is thus specified as O(f(n, k)) with n = |x|.
The parameterized analogue of tractability captured by the class P is fixed-parameter
tractability captured by the class FPT of fixed-parameter tractable problems. A problem is in
FPT, if it can be solved in time O(f(k) · nc) for some computable function f and constant c.
In other words, the running time only depends polynomially on the size of the instance,
while a possibly exponential explosion is confined to the parameter. In particular, if for a
class of instances, the parameter k is bounded by a constant, then FPT-membership means
that the problem can be solved in polynomial time. This also applies to problems in the
slightly less favorable complexity class XP, which contains the problems solvable in time
O(nf(k)).
Parameterized complexity theory also comes with its own version of reductions (namely
“FPT-reductions”) and hardness theory based on classes of fixed-parameter intractable prob-
lems. An FPT-reduction from a parameterized problem P to another parameterized problem
P ′ maps every instance (x, k) of P to an equivalent instance (x′, k′) of P ′, such that k′
only depends on k (i.e., independent of x) and the computation of x′ is in FPT (i.e., in
time O(f(k) · |x|c) for some computable function f and constant c). For fixed-parameter
intractability, the most prominent class is W[1]. It has several equivalent definitions, for

---

Vol. 21:1
DIVERSITY OF ANSWERS TO CONJUNCTIVE QUERIES
9:7
instance, W[1] is the class of problems that allow for an FPT-reduction to the Indepen-
dent Set problem parameterized by the desired size k of an independent set. We have
FPT ⊆W[1] ⊆XP. It is a generally accepted assumption in parameterized complexity theory
that FPT̸ = W[1] holds – similar but slightly stronger than the famous P̸ = NP assumption
in classical complexity theory, i.e., FPT̸ = W[1] implies P̸ = NP, but not vice versa.
3. Diversity of Conjunctive Queries
3.1. Combined and Query Complexity. We start our study of the Diverse-ACQ problem
by considering the combined complexity and then, more specifically, the query complexity.
We will thus present our basic algorithm in Section 3.1.1, which allows us to establish the
XP-membership of this problem. We will then prove W[1]-hardness in Section 3.1.2 and
present some further improvements of the basic algorithm in Section 3.1.3.
3.1.1. Basic Algorithm. Our algorithm for solving Diverse-ACQ is based on a dynamic
programming idea analogous to the Yannakakis algorithm. Given a join tree ⟨T, λ, r⟩and
database I, the Yannakakis algorithm decides in a bottom-up traversal of T at each node
t ∈V (T) and for each answer α to the single-atom query λ(t) if it can be extended to
an answer to the CQ consisting of all atoms labeling the nodes in the complete subtree
T ′ rooted at t. It then stores this (binary) information by either keeping or dismissing α.
Our algorithm for Diverse-ACQ implements a similar idea. At its core, it stores k-tuples
(α1, . . . , αk) of answers to the single-atom query λ(t), each k-tuple describing a set of (partial)
diversity sets. We extend this information by the various vectors (di,j)1≤i<j≤k of Hamming
distances that are attainable by possible extensions (γ1, . . . , γk) to the CQ consisting of the
atoms labeling the nodes in T ′.
In the following, we consider an ACQ Q(X) := ∃Y Vℓ
i=1 Ai where each atom is of the form
Ai = Ri(Zi) for some relation symbol Ri and variables Zi ⊆X ∪Y . For an atom A = R(Z)
and a database instance I, define A(I) as the set of mappings {α: Z →dom(I) : α(Z) ∈RI}.
We extend the definition to sets (or conjunctions) ψ(Z) of atoms Ai(Zi) with Zi ⊆Z. Then
ψ(I) is the set of mappings {α: Z →dom(I) : α(Zi) ∈RI
i for all Ri(Zi) ∈ψ(Z)}. Let
⟨T, λ, r⟩be a join tree. For a subtree T ′ of T we define λ(T ′) = {λ(t) : t ∈V (T ′)} and,
by slight abuse of notation, we write t(I) and T ′(I) instead of λ(t)(I) and λ(T ′)(I). Now
consider T ′ to be a subtree of T with root t. For tuples
e ∈{(α1, . . . , αk, (di,j)1≤i<j≤k) : α1, . . . , αk ∈t(I), di,j ∈{0, . . . , |X|} for 1 ≤i < j ≤k},
we define
extT ′(e) = {(γ1, . . . , γk) : γ1, . . . , γk ∈T ′(I) s.t. αi ∼= γi for 1 ≤i ≤k and
∆X(γi, γj) = di,j for 1 ≤i < j ≤k}.
Intuitively, the algorithm checks for each such tuple e whether there exist extensions γi
of αi that
(1) are solutions to the subquery induced by T ′, and
(2) exhibit di,j as their pairwise Hamming distances. If this is the case, the tuple e is kept,
otherwise, e is dismissed.

---

9:8
T. Merkl, R. Pichler, and S. Skritek
Vol. 21:1
In doing so, the goal of the algorithm is to compute sets DT ′ that contain exactly those e
with extT ′(e)̸ = ∅. Having computed DT (i.e., for the whole join tree), Diverse-ACQ can now
be decided by computing for each e ∈DT the diversity measure from the values di,j.
To do so, in a first phase, at every node t ∈V (T), we need to compute and store the
set DT ′ (for T ′ being the complete subtree rooted in t). We compute this set by starting
with some set Dt and updating it until eventually, it is equal to DT ′. In addition, to every
entry e in every set Dt, we maintain a set ρDt(e) containing provenance information on e.
Afterwards, in the recombination phase, the sets DT ′ and ρDt(·) are used to compute a
diversity set with the desired diversity – if such a set exists.
Algorithm 3.1. Given Q(X), I, ⟨T, λ, r⟩, k, d, and a diversity measure δ defined via some
aggregate function f, the first phase proceeds in three main steps:
• Initialization: In this step, for every node t ∈V (T), initialize the set Dt as
Dt = {(α1, . . . , αk, (di,j)1≤i<j≤k) : αi ∈t(I), di,j = ∆X(αi, αj)}.
That is, Dt contains one entry for every combination α1, . . . , αk ∈t(I), and each value
di,j (1 ≤i < j ≤k) is the Hamming distance of the mappings αi|X and αj|X.
For every e ∈Dt, initialize ρDt(e) as the empty set.
Finally, set the status of all non-leaf nodes in T to “not-ready” and the status of all
leaf nodes to “ready”.
• Bottom-Up Traversal: Then repeat the following action until no “not-ready” node is
left: Pick any “not-ready” node t that has at least one “ready” child node t′. Update Dt
to Dnew
t
as
Dnew
t
= {(α1, . . . , αk, ( ¯di,j)1≤i<j≤k) : (α1, . . . , αk, (di,j)1≤i<j≤k) ∈Dt,
(α′
1, . . . , α′
k, (d′
i,j)1≤i<j≤k) ∈Dt′,
αi ∼= α′
i for 1 ≤i ≤k,
¯di,j = di,j + d′
i,j −∆X(αi ∩α′
i, αj ∩α′
j)
for 1 ≤i < j ≤k}.
Expressed in a more procedural style: Take every entry e ∈Dt and compare it to every
entry e′ ∈Dt′. If the corresponding mappings αi ∈Dt and α′
i ∈Dt′ agree on the shared
variables, the new set Dnew
t
contains an entry ¯e with the mappings αi from e and the
Hamming distances computed from e and e′ as described above.
Set ρDnew
t
(¯e) = ρDt(e) ∪{(t′, e′)}. If the same entry ¯e is created from different pairs
(e, e′), choose an arbitrary one of them for the definition of ρDnew
t
(¯e).
Finally, change the status of t′ from “ready” to “processed”. The status of t becomes
“ready” if the status of all its child nodes is “processed” and remains “not-ready” otherwise.
• Finalization: Once the status of root r is “ready”, remove all (α1, . . . , αk, (di,j)1≤i<j≤k)
∈Dr where f((di,j)1≤i<j≤k) < d. To ensure that all answers in the diversity set are
pairwise distinct, also remove all entries where di,j = 0 for some (i, j) with 1 ≤i < j ≤k.
If, after the deletions, Dr is empty, then there exists no diversity set of size k with a
diversity of at least d. Otherwise, at least one such diversity set exists.
Clearly, the algorithm is well-defined and terminates. In the following theorem, we show
that the algorithm decides Diverse-ACQ and we give an upper bound on its running time.

---

Vol. 21:1
DIVERSITY OF ANSWERS TO CONJUNCTIVE QUERIES
9:9
Theorem 3.2. The Diverse-ACQ problem is in XP in combined complexity when param-
eterized by the size k of the diversity set. More specifically, for an ACQ Q(X), a data-
base I, and integers k and d, Algorithm 3.1 decides the Diverse-ACQ problem in time
O
 |RI|2k · (|X| + 1)k(k−1) · poly(|Q|, k)

where RI is the relation from I with the most tuples
and poly(|Q|, k) is a polynomial in |Q| and k.
This result is a consequence of the correctness of Algorithm 3.1.
We show both, the
correctness of the algorithm and Theorem 3.2 using a sequence of lemmas, discussed and
proven next. Consider an ACQ Q(X) with join tree ⟨T, λ, r⟩, a database instance I, and
integers k (the number of elements in the diversity set) and d (the required diversity). For a
subtree T ′ of T with root t, let DT ′ be the set of tuples
e ∈{(α1, . . . , αk, (di,j)1≤i<j≤k) : α1, . . . , αk ∈t(I) and
di,j ∈{0, . . . , |X|} for 1 ≤i < j ≤k}
such that the set
extT ′(e) = {(γ1, . . . , γk) : γ1, . . . , γk ∈T ′(I) s.t. αi ∼= γi for 1 ≤i ≤k and
∆X(γi, γj) = di,j for 1 ≤i < j ≤k}
is not empty. To prove the correctness of Algorithm 3.1, it is sometimes more convenient to
work with the following, obviously equivalent, definition of DT ′:
DT ′ = {(α1, . . . , αk, (di,j)1≤i<j≤k): α1, . . . , αk ∈t(I),
γ1, . . . , γk ∈T ′(I),
γ1 ∼= α1, . . . , γk ∼= αk,
di,j = ∆X(γi, γj) for 1 ≤i < j ≤k}.
The overall goal of the following lemmas is to
(1) show that once the status of a node t ∈V (T) is “ready”, the equality Dt = DT ′ holds,
where T ′ is the complete subtree of T rooted in t (i.e., the subtree of T containing t and
all of its descendants). This proves the correctness of the algorithm.
(2) provide a bound on the running time of the different steps of the algorithm.
The first lemma, describing the size of the sets Dt, follows immediately from the definition
and the observation that the value of each of the entries di,j is at most |X|.
Lemma 3.3. Let Q(X) be an ACQ, I a database instance, and ⟨T, λ, r⟩a join tree for
Q(X). Throughout the running time of Algorithm 3.1, for every node t ∈V (T) the set Dt
contains at most |RI|k · (|X| + 1)
k(k−1)
2
tuples, where RI is the relation in I containing the
most tuples. The size of each tuple is polynomial in the size of the input.
Proof. The polynomial size of each tuple is immediate. For the number of entries, observe
that the number of different elements in every t(I) is |t(I)| ≤|RI| since λ(t) consists of a single
atom. Also, since each di,j describes the Hamming-Distance between two mappings with at
most |X| variables, its value is in {0, . . . , |X|}. The expression |RI|k · (|X| + 1)
k(k−1)
2
thus
describes the number of all possible combinations of these values for tuples of size k + k(k−1)
2
where the first k are elements of t(I) and the remaining elements from {0, . . . , |X|}.
The next lemma shows that the initialization correctly computes DT ′ for all subtrees T ′
of T consisting of a single node, and states the running time of this step.

---

9:10
T. Merkl, R. Pichler, and S. Skritek
Vol. 21:1
Lemma 3.4. Let Q(X) be an ACQ, I a database instance, and ⟨T, λ, r⟩a join tree for
Q(X). Once the “Initialization”-step of Algorithm 3.1 is complete, the equality Dt = DT ′
holds for all nodes t ∈V (T), where T ′ is the subtree of T consisting only of t. Furthermore,
Dt can be computed in time O(|t(I)|k · k2 · |var(t)|).
Proof. One helpful observation for both, correctness and the running time, is that no
collection α1, . . . , αk may occur twice, each time with different values (di,j)1≤i<j≤k and
(d′
i,j)1≤i<j≤k, in DT ′: because the subtree T ′ consists only of t, all (α1, . . . , αk) are their only
extension and thus determines the values (di,j)1≤i<j≤k. The equality Dt = DT ′ then follows
immediately from the definitions of Dt and DT ′.
For the time bound, observe that the given time allows one to iterate through all possible
tuples (α1, . . . , αk) with α1, . . . , αk ∈t(I) (|t(I)|k many), and for each such tuple to compute,
for each pair αi, αj with 1 ≤i < j ≤k (less than k2 many) the value di,j = ∆X(αi, αj)
(X ∩var(t) ⊆var(t) many variables to compare), which constitutes a naive implementation
of the “Initialization” step.
The next lemma will be essential in proving the “Bottom-Up Traversal” step of Algo-
rithm 3.1 being correct, and provides a bound on the running time for a single iteration of
this step.
Lemma 3.5. Let Q(X) be an ACQ, I a database instance, and ⟨T, λ, r⟩a join tree for Q(X).
Let ⟨T1, t1⟩and ⟨T2, t2⟩be two disjoint rooted subtrees of ⟨T, r⟩(i.e. V (T1) ∩V (T2) = ∅)
such that t1 is the parent node of t2 in ⟨T, r⟩, and for ˆT = T[V (T1) ∪V (T2)] consider the
rooted subtree ⟨ˆT, t1⟩of ⟨T, r⟩. Then
D ˆT = {(α1, . . . , αk, ( ˆdi,j)1≤i<j≤k) : (α1, . . . , αk, (di,j)1≤i<j≤k) ∈DT1,
(α′
1, . . . , α′
k, (d′
i,j)1≤i<j≤k) ∈DT2,
αi ∼= α′
i for 1 ≤i ≤k,
ˆdi,j = di,j + d′
i,j −∆X(αi ∩α′
i, αj ∩α′
j)
for 1 ≤i < j ≤k}. (3.1)
Also, given DT1 and DT2, the set D ˆT can be computed in time O(|D|2 · k2 · |Z|) where D is
the larger of the two sets DT1 and DT2, and Z is the larger of the sets var(t1) and var(t2).
Proof. For this proof, we will use D ˆT to describe the set of tuples according to the initial
definition, and ˆD ˆT for the set defined by the right hand side of Equation 3.1. We show
D ˆT = ˆD ˆT by proving D ˆT ⊆ˆD ˆT and ˆD ˆT ⊆D ˆT separately.
D ˆT ⊆ˆD ˆT :
Let e = (α1, . . . , αk, ( ˆdi,j)1≤i<j≤k)) ∈D ˆT . Consider an arbitrary (ˆγ1, . . . , ˆγk) ∈ext ˆT (e), and
define γi = ˆγi|var(T1) and γ′
i = ˆγi|var(T2) for all 1 ≤i ≤k. By definition, γi ∈T1(I) and
γ′
i ∈T2(I), thus we have
e1 = (γ1|var(t1), . . . , γk|var(t1), (∆X(γi, γj))1≤i<j≤k) ∈DT1 and
e2 = (γ′
1|var(t2), . . . , γ′
k|var(t2), (∆X(γ′
i, γ′
j))1≤i<j≤k) ∈DT2.
This is the case since clearly
(γ1, . . . , γk) ∈extT1((γ1|var(t1), . . . , γk|var(t1), (∆X(γi, γj))1≤i<j≤k)) and
(γ′
1, . . . , γ′
k) ∈extT2((γ′
1|var(t2), . . . , γ′
k|var(t2), (∆X(γ′
i, γ′
j))1≤i<j≤k)).

---

Vol. 21:1
DIVERSITY OF ANSWERS TO CONJUNCTIVE QUERIES
9:11
Now αi = γi|var(t1) and we define α′
i = γ′
i|var(t2). We get αi ∼= α′
i for all 1 ≤i ≤k. Next, for
1 ≤i < j ≤k, we have
ˆdi,j = ∆X(ˆγi, ˆγj) = ∆X∩
 var(T1)∪var(T2)
(ˆγi, ˆγj)
= ∆X∩
 var(T1)∪(var(T2)\var(T1))
(ˆγi, ˆγj) = ∆X∩var(T1)(ˆγi, ˆγj) + ∆X∩
 var(T2)\var(T1)
(ˆγi, ˆγj).
Now
∆X(γi, γj) = ∆X∩var(T1)(ˆγi, ˆγj) and
∆X(γ′
i, γ′
j) = ∆X∩var(T2)(ˆγi, ˆγj) = ∆X∩(var(T2)\var(T1))(ˆγi, ˆγj) + ∆X∩(var(T2)∩var(T1))(ˆγi, ˆγj).
We end up with ˆdi,j = ∆X(γi, γj) + ∆X(γ′
i, γ′
j) −∆X∩(var(T2)∩var(T1))(ˆγi, ˆγj). Given that γi
and γ′
i share exactly the variables from var(T1)∩var(T2), we get ∆X∩(var(T2)∩var(T1))(ˆγi, ˆγj) =
∆X(γi ∩γ′
i, γj ∩γ′
j). Because of the connectedness condition, all variables shared between any
γi and γ′
i are also contained in γi|var(t1) and γ′
i|var(t2) and therefore ∆X(γi ∩γ′
i, γj ∩γ′
j) =
∆X(αi ∩α′
i, αj ∩α′
j). Thus e ∈ˆD ˆT is verified by the tuples e1 and e2, which, together with e
satisfy all conditions stated on the right-hand side of Equation 3.1, which concludes this
direction of the proof.
ˆD ˆT ⊆D ˆT : Consider an arbitrary tuple ˆe = (α1, . . . , αk, ( ˆdi,j)1≤i<j≤k) ∈ˆD ˆT , and let
e1 = (α1, . . . , αk, (di,j)1≤i<j≤k) ∈DT1 and e2 = (α′
1, . . . , α′
k, (d′
i,j)1≤i<j≤k) ∈DT2 be two
tuples witnessing ˆe ∈ˆD ˆT (i.e. ˆe, e1, and e2 satisfy all conditions on the right-hand side of
Equation 3.1). Then extT1(e1) and extT2(e2) are both not empty. Choose (γ1, . . . , γk) ∈
extT1(e1) and (γ′
1, . . . , γ′
k) ∈extT2(e2) arbitrarily.
By definition, ∆X(γi, γj) = di,j and
∆X(γ′
i, γ′
j) = d′
i,j for all 1 ≤i < j ≤k. Because of the connectedness condition for join trees,
(1) the mapping ˆγi = γi ∪γ′
i is a valid mapping,
(2) ˆγi|var(t1) = αi, and
(3) ˆγi ∈ˆT(I) (and thus αi ∈t1(I)).
Thus (α1, . . . , αk, (∆X(ˆγi, ˆγj))1≤i<j≤k) ∈D ˆT , and proving ∆X(ˆγi, ˆγj) = ˆdi,j concludes the
proof. Towards this goal, by an equivalent development as for proving the other direction,
we get
∆X(ˆγi, ˆγj) = ∆X(γi, γj) + ∆X(γ′
i, γ′
j) −∆X(γi ∩γ′
i, γj ∩γ′
j)
= di,j + d′
i,j −∆X(αi ∩α′
i, αj ∩α′
j)
= ˆdi,j.
To prove that ˆD ˆT can in fact be computed within the stated time bound, consider
the following naive implementation: Iterate through all e1 ∈DT1, and for each such
e1 – in a nested loop – look at each e2 ∈DT2 (“Loop”).
For each such pair with
e1 = (α1, . . . , αk, (di,j)1≤i<j≤k) and e2 = (α′
1, . . . , α′
k, (d′
i,j)1≤i<j≤k), check whether αi ∼= α′
i
(“Check”). If αi ∼= α′
i, compute ˆdi,j as defined (“Compute”). “Check” requires to compare
the values of |Z| variables on k pairs (αi, α′
i) (possible in O(k · |Z|) time), and “Compute”
computes k(k−1)
2
many values (thus in O(k2)). These two steps are performed O(|DT1|·|DT2|)
times (number of iterations of “Loop”). Despite “Check” and “Compute” being sequential, for
simplicity we bound the running time by O(|D|2·k2·|Z|) instead of O(|D|2·(k2+k·|Z|)).
With this result at hand, we can show that the bottom-up traversal of the join tree is
correct.

---

9:12
T. Merkl, R. Pichler, and S. Skritek
Vol. 21:1
Lemma 3.6. Let Q(X) be an ACQ, I a database instance, and ⟨T, λ, t⟩a join tree for Q(X).
At the end of every iteration, the “Bottom-Up Traversal” step of Algorithm 3.1 guarantees
the following two properties:
(1) For all nodes t ∈V (T) with status “ready”, the equality Dt = DT ′ holds, where T ′ is the
subtree of T consisting of t and all its descendants.
(2) For a node t ∈V (T), let t1, . . . , tp be the child nodes with status “processed”. Then
Dt = DT ′ where T ′ is the subtree of T consisting of t and all ti and all their descendants,
for 1 ≤i ≤p.
Proof. We show both properties by induction on the number of steps in the bottom-up
traversal of the join tree. Throughout this proof, for a node t ∈V (T), we will use Tt to
denote the complete subtree of T rooted in t, i.e. the subtree of T containing t and all its
descendants.
For the base case, consider the situation before the first iteration of the bottom-up
traversal. At this point, the set of nodes with status “ready” are exactly the leaf nodes.
Since they have no child nodes, the statement Dt = DT ′ in property (1) is equivalent to
Dt = DT[{t}]. By Lemma 3.4, this equality holds for all nodes once the “Initialization” step
is finished. We next observe that there are no nodes with status “processed”. Thus for
all nodes t ∈V (T) property (2) also states Dt = DT[{t}], which again holds because of
Lemma 3.4.
For the induction step, consider the node t ∈V (T) for which Dt was updated to Dnew
t
in
the “Bottom-Up Traversal” step, and let t′ be the child node of t that was used to compute
the update. As induction hypothesis, we know that the first property holds for the child
node t′ (status before the step: “ready”), and the second property holds for t w.r.t. all the
child nodes t1, . . . , tp of t with status “processed” (possibly none). We have to show that
after the “Bottom-Up Traversal” step:
a) The second property holds for t and the child nodes t1, . . . , tp, t′.
b) If t′ was the only remaining child node of t with a status different from “processed”,
then the first property now holds for t.
To prove a), let T ′ = T[{t}∪V (Tt1)∪. . . V (Ttp)] and ˆT = T[{t}∪V (Tt1)∪· · ·∪V (Ttp)∪V (Tt′)].
The induction hypothesis guarantees that Lemma 3.5 applies (i.e. all the preconditions are
satisfied w.r.t. T ′, Tt′, and ˆT). Observe that the set described in Lemma 3.5 is exactly the
set Dnew
t
computed from Dt by the “Bottom-Up Traversal” step. We thus have Dt = DT ′ by
the induction hypothesis, and Dnew
t
= D ˆT by Lemma 3.5, which completes the proof of a).
For b), observe that the only node whose status can switch to “ready” is t. If this
happened at the end of the step, then t′ was the last child of t whose status was not
“processed”, and we now have ˆT = Tt.
Thus Dt = DTt follows immediately from a),
concluding the proof of the lemma.
We now have everything in place to prove Theorem 3.2.
Proof (of Theorem 3.2). We start by proving the correctness of the algorithm, before dis-
cussing its running time.
For the correctness, from Lemma 3.6 we know that once the “Bottom-Up Traversal”
step is finished (i.e. there is no more node with status “not-ready”; in other words, the
root has status “ready” and all other nodes have status “processed”), then Dr = DT
(r is the root of T). As a result, for any e = (α1, . . . , αk, (di,j)1≤i<j≤k) ∈Dr and every
(γ1, . . . , γk) ∈extT (e) we have γi ∈T(I) and γi|X ∈Q(I) for all 1 ≤i ≤k.
Hence

---

Vol. 21:1
DIVERSITY OF ANSWERS TO CONJUNCTIVE QUERIES
9:13
δ(γ1, . . . , γk) = f((∆X(γi, γj))1≤i<j≤k) = f((di,j)1≤i<j≤k) (with f being the polynomial
time computable function defining δ).
Thus the correctness of the “Finalization” step follows immediately from
max
γ1,...,γk∈Q(I)
γi̸=γj for i̸=j
δ(γ1, . . . , γk) =
max
γ1,...,γk∈T(I)
γi|X̸=γj|X for i̸=j
δ(γ1|X, . . . , γk|X)
=
max
γ1,...,γk∈T(I)
∆X(γi,γj)>0 for i̸=j
f((∆X(γi, γj))1≤i<j≤k)
=
max
(α1,...,αk,(di,j)1≤i<j≤k)∈Dr
di,j>0 for 1≤i<j≤k
f((di,j)1≤i<j≤k).
For the bound on the running time, by Lemma 3.4, the “Initialization” step takes time
in O(|t(I)|k · k2 · |var(t)|) for each node, i.e. O(|RI|k · k2 · |var(A)| · |Q|) in total (the join tree
contains one node for each atom in Q(X)), where RI is the relation in I with the highest
number of tuples, and A is the atom in Q with the highest number of variables.
By Lemma 3.5, one iteration of the “Bottom-Up Traversal” step takes time in O((|RI|k ·
(|X| + 1)
k(k−1)
2
)2 · k2 · |var(A)|) using the size bound on Dt from Lemma 3.3. Since every
node (except the root node) is merged into its parent node exactly once, we get O(|RI|2k ·
(|X| + 1)k(k−1) · k2 · |var(A)|) · |Q|) in total. The “Finalization“ step takes time O(|RI|2k ·
(|X| + 1)k(k−1) · polyf(|X|, k)), where polyf(|X|, k) is a polynomial describing the time
needed to compute the function f((di,j)1≤i<j≤k). Thus the running time of the “Bottom-Up
Traversal” dominates the running time of the “Initialization” step, which is why we can
omit it, providing the running time stated in the theorem.
Theorem 3.2 shows that the algorithm decides in XP the existence of a diversity set
with a given diversity. Computing a witness diversity set now means computing one element
(γ1, . . . , γk) ∈extT (e) for some e ∈DT with f((di,j)1≤i<j≤k) ≥d and di,j̸ = 0 for all i, j.
Similarly to the construction of an answer tuple by the Yannakakis algorithm for CQs, we
can compute an arbitrary element from extT (e) by making use of the information stored in
the final sets ρDt(e). By construction, for every node t ∈V (T) and every entry e ∈DT ′, the
final set ρDt(e) contains exactly one pair (t′, e′) for every child node t′ of t. Moreover, for the
mappings α1, . . . , αk from e and α′
1, . . . , α′
k from e′, αi ∼= α′
i holds for all 1 ≤i ≤k, hence
αi ∪α′
i are again mappings. Thus, to compute the desired witness (γ1, . . . , γk) ∈extT (e) for
the chosen e ∈DT , start with (α1, . . . , αk) from e, take all (t′, e′) from ρDr(e), extend each
αi with α′
i from e′, and repeat this step recursively.
Example 3.7. An example execution of the basic algorithm for k = 2 on the query
Q(x1, . . . , x8) : −R1(x1, x2, x3)∧R2(x2, x3, x4)∧R3(x4, x5)∧R4(x4)∧R5(x5, x6)∧R6(x7, x8)
which, together with a possible join tree, is shown in Figure 1. The database I consists of
(very small) relations RI
1, . . . , RI
6 and each relation RI
i is shown in the figure next to the node
Ri. For a node t, the set Dt is computed by considering the subtrees rooted at the children
of t from left to right. For the sake of succinctness, tuples (α1, α2, d1,2) ∈Dt are omitted
if there is a strictly better tuple, i.e., a (α1, α2, d′
1,2) ∈Dt such that d1,2 < d′
1,2. (Formally,
this is only justified if the aggregator is monotone.) We do not specify an aggregator
and skip the “Finalization” step as we are only looking for a diverse pair. This pair is
{(3, 2, 2, 0, 0, 1, 5, 7), (3, 2, 2, 0, 0, 2, 8, 8)}.

---

9:14
T. Merkl, R. Pichler, and S. Skritek
Vol. 21:1
We now discuss the “Initialization” and “Bottom-Up Traversal” of Algorithm 3.1 in
more detail: We first carry out the initialization step of Algorithm 3.1 for all nodes. That is,
we set up a table with all possible pairs of tuples from RI
i together with their Hamming
distance (recall that we are looking for pairs since we have k = 2 in this example). In
particular, if a pair consists of two identical tuples, then we get a distance of 0.
We next discuss the result of carrying out the bottom-up traversal. To this end, we
inspect the two internal nodes R3 and R2. First, look at the tables to the right of the node
R3: the tuple (3, 1) has no join partner in the leftmost child (= R4). Hence, in the table
to the right of the initial one, we delete all pairs that contain the tuple (3, 1). Therefore,
we only consider pairs built from the first two tuples in RI
3, i.e., (0, 0) and (1, 1). Clearly,
extending these pairs to the leftmost child does not add to the distance, since that node (=
R4) has no additional variable. In the left table below, we show the result of extending these
4 pairs of tuples to the second child. It turns out that, for the first 3 pairs, the maximum
achievable distance increases by 1 because we could extend the tuples of such a pair in
two different ways to x6. Now let us also look at the last pair in this table, i.e., combining
(1, 1) with (1, 1). That is, in both tuples, x5 is set to 1. But when we look at the table
corresponding to R5, it turns out that the only possible extension to x6 is 1. Hence, the
distance of this pair cannot be increased by an extension to R5 and it remains 2. We then
carry out the bottom-up step also from the child node R6 to R3. Now we can indeed extend
the tuples of each pair to different values of x7 and also x8, which leads to an increase of
the distance by 2. That is, we end up with (maximally achievable) distances 3, 5, 5, and 2,
respectively, for the node R3.
We finally also discuss the tables above the root node. The leftmost table is the result
of the initialization step. For the bottom-up step from the left child (= R1) to the root
node, we observe that only the tuple (2, 2, 0) of RI
2 has a join partner in RI
1. Moreover, if we
fix x2 = 2 and x3 = 2, then there exists only one possible extension to x1 in RI
1, namely
x1 = 3. Hence, the second table above node R2 consists of a single pair and its initial
distance (namely 0) cannot be increased by an extension to the left child. Now consider
also the right child of R2. We are only considering the pair from RI
2 where both tuples
are the same, namely (2, 2, 0). We see in the last table attached to R3 that the maximum
distance achievable by pairs where both tuples have x4 = 0 is 3. Hence, this is then also
the maximum distance achievable by the only pair in the last table attached to R2. By
tracing back top-down the pairs from the bottom-up traversal which contributed to the
maximally achievable distance at the parent node, we get the pair (3, 3, 2, 0, 0, 1, 5, 7) and
(3, 3, 2, 0, 0, 2, 8, 8) of query answers with maximum distance.
♢
3.1.2. W[1]-Hardness. Having proved XP-membership in combined complexity of the Diverse-
ACQ problem in Theorem 3.2, we now show that, for any ws-monotone diversity measure, a
stronger result in the form of FPT-membership is very unlikely to exist. More specifically,
we prove W[1]-hardness for combined complexity in these cases. The reduction we use only
takes polynomial time and, thus, we spontaneously prove NP-hardness of Diversewsm-ACQ in
combined complexity when considering the problem unparameterized
Theorem 3.8. The problem Diversewsm-ACQ, parameterized by the size k of the diversity
set, is W[1]-hard in combined complexity. It remains W[1]-hard even if all relation symbols
are of arity at most two and Q(X) contains no existential variables. Furthermore, viewed as
an unparameterized problem, Diversewsm-ACQ is NP-hard in combined complexity

---

Vol. 21:1
DIVERSITY OF ANSWERS TO CONJUNCTIVE QUERIES
9:15
R2(x2, x3, x4)
R3(x4, x5)
R1(x1, x2, x3)
R5(x5, x6)
R4(x4)
R6(x7, x8)
α1
α2
x4
x4
d1,2
0
0
0
0
1
1
1
0
1
1
1
0
α1
α2
x5
x6
x5
x6
d1,2
0
1
0
1
0
0
1
0
2
1
0
1
1
0
2
0
2
0
1
1
0
2
0
2
0
0
2
1
0
2
1
0
0
1
2
1
0
0
2
2
1
0
1
0
0
α1
α2
x4
x5
x4
x5
d1,2
0
0
0
0
0
0
0
1
1
2
0
0
3
1
2
1
1
0
0
2
1
1
1
1
0
1
1
3
1
1
3
1
0
0
2
3
1
1
1
1
3
1
3
1
0
α1
α2
x4
x5
x4
x5
d1,2
0
0
0
0
0
0
0
1
1
2
1
1
0
0
2
1
1
1
1
0
α1
α2
x4
x5
x4
x5
d1,2
0
0
0
0
1
0
0
1
1
3
1
1
0
0
3
1
1
1
1
0
α1
α2
x4
x5
x4
x5
d1,2
0
0
0
0
3
0
0
1
1
5
1
1
0
0
5
1
1
1
1
2
α1
α2
x7
x8
x7
x8
d1,2
5
7
5
7
0
5
7
8
8
2
8
8
5
7
2
8
8
8
8
0
α1
α2
x1
x2
x3
x1
x2
x3
d1,2
3
2
2
3
2
2
0
3
2
2
3
4
4
2
3
4
4
3
2
2
2
3
4
4
3
4
4
0
α1
α2
x2
x3
x4
x2
x3
x4
d1,2
2
2
0
2
2
0
0
2
2
0
2
4
1
2
2
4
1
2
2
0
2
2
4
1
2
4
1
0
α1
α2
x2
x3
x4
x2
x3
x4
d1,2
2
2
0
2
2
0
0
α1
α2
x2
x3
x4
x2
x3
x4
d1,2
2
2
0
2
2
0
3
⇝
⇝
⇝
⇝
⇝
RI
2
2
2
0
2
4
1
RI
3
0
0
1
1
3
1
RI
1
3
2
2
3
4
4
RI
4
0
1
RI
5
0
1
0
2
1
0
RI
6
5
7
8
8
Figure 1: Example Execution of the Basic Algorithm.

---

9:16
T. Merkl, R. Pichler, and S. Skritek
Vol. 21:1
Proof. We reduce from the Independent Set problem parameterized by the size of the
independent set.
Let (G, s) be an arbitrary instance of Independent Set with V (G) = {v1, . . . , vn} and
E(G) = {e1, . . . , em}. We define an instance ⟨I, Q, k, d⟩of Diversewsm-ACQ as follows. The
schema consists of a relation symbol R of arity one and m relation symbols R1, . . . , Rm of
arity two. The CQ Q(X) is defined as
Q(v, x1, . . . , xm) := R(v) ∧R1(v, x1) ∧· · · ∧Rm(v, xm)
and the database instance I with dom(I) = {0, 1, . . . , n} is
RI ={(i) : vi ∈V (G)} and
RI
j ={(i, i) : vi is not incident to ej} ∪{(i, 0) : vi is incident to ej} for all j ∈{1, . . . , m}.
Finally, set k = s and d = f(m+1, . . . , m+1), where f is the aggregator of δwsm aggregating
the value m + 1 exactly
 k
2

times. Clearly, this reduction is feasible in polynomial time
and the resulting problem instances satisfy all the restrictions stated in the theorem. The
correctness of this reduction depends on two main observations.
O1) For each i ∈{1, . . . , n}, independently of G, there exists exactly one solution γi ∈Q(I)
with γi(v) = i, and these are in fact the only solutions in Q(I). Thus, there is a natural
one-to-one association between vertices vi ∈V (G) and solutions γi ∈Q(I).
O2) Due to ws-monotonicity, the desired diversity d = f(m + 1, . . . , m + 1) can only be
achieved by k solutions that pairwisely differ on all variables.
Observation O1 is immediate: R(γ(v)) ∈RI if and only if γ(v) ∈{1, . . . , n}, and for every
i ∈{1, . . . , n} and j ∈{1, . . . , m}, there exists exactly one pair (i, b) ∈RI
j (with b being either
0 or i). For Observation O2, note that the Hamming distance between two answers is at most
m + 1. Thus, if two answers γi, γj are equal on some variable, ∆(γi, γj) < m + 1, and hence
due to ws-monotonicity, δwsm(γ1, . . . , γk) = f((∆(γi, γj))1≤i<j≤k) < f(m + 1, . . . , m + 1) = d.
Observation O2 allows us to prove the correctness of the reduction by showing that G
has an independent set of size s if and only if there exists a diversity set of size k where all
answers differ pairwise on all variables.
To do so, first assume that there exists an independent set S ⊆V (G) of size s in G.
We define the diversity set as D = {γi : vi ∈S}. By Observation O1, D is well-defined
and thus contains k answers. We show that for any two distinct solutions γi, γj ∈D we
have γi(x)̸ = γj(x) for all variables x ∈var(Q). To do so, first note that for all solutions
γ ∈Q(I) and all variables x ∈var(Q), the fact that γ(x)̸ = 0 implies γ(x) = γ(v). Because
of Observation O1, this implies that γi(x) = γj(x) is only possible if γi(x) = γj(x) = 0 (since
O1 implies that there do not exist any two distinct solutions γi, γj ∈Q(I) with γi(v) = γj(v)).
Thus, towards a contradiction, assume γi(xℓ) = γj(xℓ) = 0 for some ℓ∈{1, . . . , m}. Then
both, (i, 0) and (j, 0) must be contained in Rℓ, and by the definition of I this implies that
both, vi and vj are incident to eℓ. This however contradicts that vi and vj are both part of
the same independent set, which proves that any two solutions γi̸ = γj must differ on all
variables.
Next assume that there exists a diversity set D ⊆Q(I) of size k such that all distinct
answers in D differ on all variables. We define a set S = {vi : γi ∈D}. By Observation O1,
this set is well-defined and contains exactly k vertices. Towards a contradiction, assume that
S contains two adjacent vertices vi̸ = vj and let eℓbe the edge connecting vi and vj. By
definition of I, we get (i, 0) ∈RI and (j, 0) ∈RI. However, this implies γi(xℓ) = 0 = γj(xℓ).

---

Vol. 21:1
DIVERSITY OF ANSWERS TO CONJUNCTIVE QUERIES
9:17
This, however, contradicts the assumption that all solutions differ pairwise on all variables,
which concludes the proof.
3.1.3. Speeding up the Basic Algorithm. Algorithm 3.1 works for any polynomial-time
computable diversity measures δ. To compute the diversity at the root node, we needed to
distinguish between all the possible values for di,j (1 ≤i < j ≤k), which heavily increases
the size of the sets Dt. The reason we had to explicitly distinguish all these values in the
basic algorithm is that, in general, given two collections (γ1, . . . , γk) and (γ′
1, . . . , γ′
k) of
mappings that agree on the shared variables, we cannot derive δ( ˆγ1, . . . , ˆγk) for ˆγi = γi ∪γ′
i
from δ(γ1, . . . , γk) and δ(γ′
1, . . . , γ′
k). However, for specific diversity measures, this is possible.
As a result, significantly less information needs to be maintained, as will now be exemplified
for δsum.
Theorem 3.9. The Diversesum-ACQ problem is in FPT in query complexity when parameter-
ized by the size k of the diversity set. More specifically, Diversesum-ACQ for an ACQ Q(X), a
database instance I, and integers k and d, can be solved in time O(|RI|2k·2k(k−1)·poly(|Q|, k)),
where RI is the relation from I with the most tuples and poly(|Q|, k) is a polynomial in |Q|
and k.
Proof. Note that poly(|Q|, k) is the same as in Theorem 3.2. For query complexity, the
size |RI| of a relation in I is considered as constant. Hence, the above-stated upper bound
on the asymptotic complexity indeed entails FPT-membership. To prove this upper bound,
the crucial property is that for a collection of mappings γ1, . . . , γk over variables Z, the
equality δsum(γ1, . . . , γk) = P
z∈Z δsum(γ1|z, . . . , γk|z) holds. Hence, in principle, it suffices
to store in DT ′ for each collection (α1, . . . , αk) with αi ∈t(I) (t being the root of T ′) such
that there exists γi ∈T ′(I) with γi ∼= αi (for all 1 ≤i ≤k) the value
dT ′(α1, . . . , αk) =
max
γ1,...,γk∈T ′(I)
s.t. γi∼
=αi for all i
δsum(γ1|X, . . . , γk|X).
I.e., each entry in DT ′ now is of the form (α1, . . . , αk, v) with v = dT ′(α1, . . . , αk). In the
bottom-up traversal step of the algorithm, when updating some Dt to Dnew
t
by merging Dt′,
for every entry (α1, . . . , αk, v) ∈Dt there exists an entry (α1, . . . , αk, ¯v) ∈Dnew
t
if and only
if there exists at least one (α′
1, . . . , α′
k, v′) ∈Dt′ such that αi ∼= α′
i for 1 ≤i ≤k. Then ¯v is
¯v =
max
(α′
1,...,α′
k,v′)∈Dt′
s.t. αi∼
=α′
i for all i
(v + v′ −δsum((α1 ∩α′
1)|X, . . . , (αk ∩α′
k)|X)).
In order to make sure that the answer tuples in the final diversity set are pairwise
distinct, the following additional information must be maintained at each DT ′: from the
partial solutions α1, . . . , αk it is not possible to determine whether the set of extensions
γ1, . . . , γk contains duplicates or not. Thus, similar to the original values di,j describing the
pairwise diversity of partial solutions, we now include binary values bi,j for 1 ≤i < j ≤k
that indicate whether extensions γi and γj of αi and αj to var(T ′) differ on at least one
variable of X (bi,j = 1) or not in order to be part of extT ′(e). This increases the maximal size
of DT ′ to |RI|2k · 2k(k−1). The bottom-up traversal step can be easily adapted to consider
in the computation of ¯v for an entry in Dnew
t
only those entries from Dt and Dt′ that are
consistent with the values of bi,j, giving the stated running time.

---

9:18
T. Merkl, R. Pichler, and S. Skritek
Vol. 21:1
Actually, if we drop the condition that the answer tuples in the final diversity set must
be pairwise distinct, the query complexity of Diversesum-ACQ can be further reduced. Clearly,
in this case, we can drop the binary values bi,j for 1 ≤i < j ≤k from the entries in DT ′,
which results in a reduction of the asymptotic complexity to O(|RI|2k · poly(|Q|, k)). At first
glance, this does not seem to improve on the FPT-membership result. However, a further,
generally applicable improvement (not restricted to a particular aggregate function and
not restricted to query complexity) is possible via the observation that the basic algorithm
computes (and manages) redundant information: for an arbitrary node t ∈V (T) and set Dt,
if Dt contains an entry of the form (α1, . . . , αk, . . . ), then Dt also contains entries of the form
(απ(1), . . . , απ(k), . . . ) for all permutations π of (1, . . . , k). But we are ultimately interested
in sets of answer tuples and do not distinguish between permutations of the members inside
a set. Keeping these redundant entries made the algorithm conceptually simpler and had no
significant impact on the running times (especially since we assume k to be small compared
to the size of the relations in I). However, given the improvements for Diversesum-ACQ from
Theorem 3.9 and dropping the binary values bi,j for 1 ≤i < j ≤k from the entries in Dt,
we can get a significantly better complexity classification:
Theorem 3.10. The problem Diversesum-ACQ is in P in query complexity when the diversity
set may contain duplicates and k is given in unary.
Proof. We claim the number of rows in Dt for any t ∈V (T) to be in O(k|t(I)|−1). In the
following, we verify the claim.
To remove redundant rows from the sets Dt, we introduce some order ⪯on partial
solutions α ∈t(I) for each t ∈V (T) (e.g. based on some order on the domain elements), and
only consider such collections α1, . . . , αk ∈t(I) where α1 ⪯· · · ⪯αk together with the value
dT ′(α1, . . . , αk). Thus the number of such different collections is described by
 |t(I)|+k−1
k

.
Applying basic combinatorics we get
|t(I)| + k −1
k

=

|t(I)| + k −1
(|t(I)| + k −1) −k

=
|t(I)| + k −1
|t(I)| −1

.
By definition, this is the same as
(|t(I)| + k −1) · (|t(I)| + k −2) · . . . · (k + 1)
(|t(I)| −1)!
≤(|t(I)| + k)|t(I)|−1.
Since we assume query complexity, we consider the size of I to be a constant. Thus, since
λ(t) consists of a single atom, also |t(I)| can be considered to be a constant. As a result we
have that (|t(I)| + k)|t(I)|−1 is in O(k|t(I)|−1) as claimed.
3.2. Data Complexity. We now inspect the data complexity of Diverse-ACQ both from
the parameterized and non-parameterized point of view. For the parameterized case, we
will improve the XP-membership result from Theorem 3.2 (for combined complexity) to
FPT-membership for arbitrary monotone aggregate functions. Actually, by considering the
query as fixed, we now allow arbitrary FO-queries, whose evaluation is well-known to be
feasible in polynomial time (data complexity) [Var82]. Thus, as a preprocessing step, we
can evaluate Q and store the result in a table RI. We may therefore assume w.l.o.g. that
the query is of the form Q(x1, . . . , xm) := R(x1, . . . , xm) and the database I consists of a
single relation RI.

---

Vol. 21:1
DIVERSITY OF ANSWERS TO CONJUNCTIVE QUERIES
9:19
To show FPT-membership, we apply a problem reduction that allows us to iteratively
reduce the size of the database instance until it is bounded by a function of m and k, i.e.,
the query and the parameter. Let X = {x1, . . . , xm} and define
 X
s

:= {Z ⊆X : |Z| = s}
for s ∈{0, . . . , m}.
Moreover, for every assignment α: Z →dom(I) with Z ⊆X let
Q(I)α := {γ ∈Q(I): γ ∼= α}, i.e., the set of answer tuples that coincide with α on Z. The
key to our problem reduction is applying the following reduction rule Redt for t ∈{1, . . . , m}
exhaustively in order Red1 through Redm:
(Redt) If for some α: Z →dom(I) with Z ∈
  X
m−t

, the set Q(I)α has at least t!2 · kt
elements, then do the following: select (arbitrarily) t · k solutions Γ ⊆Q(I)α that pairwisely
differ on all variables in X \ Z. Then remove the tuples corresponding to assignments
Q(I)α \ Γ from RI.
The intuition of the reduction rule is best seen by looking at Red1. Our ultimate goal
is to achieve maximum diversity by selecting k answer tuples. Now suppose that we fix
all but 1 position – say x1 – in the answer relation RI to be equal to some assignment α.
Furthermore, let Q(I)α ⊆RI be the matching tuples and Γ ⊆Q(I)α be k-many of these
matching tuples, chosen arbitrarily. Now, given a diversity set D ⊆Q(I), we claim that
we can replace every element γ ∈D ∩(Q(I)α \ Γ) with an element in Γ while preserving
optimality. This means that it is safe to remove Q(I)α \ Γ from RI. The claim holds as γ
and Γ agree on all positions but x. Thus, we only need to find a γ′ ∈Γ that differs from
each element in D \ {γ} on x as then γ′ is at least as far away from those elements as γ is.
Such an element always exists due to Γ containing more elements than D \ {γ} has unique
x-values.
This can be generalized to fixing fewer positions but the intuition stays the same. When
fixing m −t positions, there is also no need to retain all different value combinations in the
remaining t positions. Concretely, if there exist at least t!2 · kt different value combinations
(possibly sharing values on some positions), there also exist t·k tuples with pairwise maximum
Hamming distance on the remaining t positions (no shared values pairwise) and it is sufficient
to only keep those. Note that here a recursive argument is needed to ensure the existence of
the t · k pairwise maximally distant tuples and, hence, it is necessary to first apply Redt−1
exhaustively before we can continue with Redt.
Formally, the crucial properties of the reduction rule Redt with t ∈{1, . . . , m} is as
follows:
Lemma 3.11. Let Q be a CQ of the form Q(x1, . . . , xm) := R(x1, . . . , xm), I a corresponding
database, t ∈{1, . . . , m} and suppose that all sets Q(I)α′ with α′ : Z′ →dom(I) and
Z′ ∈
 X
m−(t−1)

have cardinality at most (t −1)!2 · kt−1. Then the reduction rule Redt is
well-defined and safe. That is:
• “well-defined”. If for some α : Z →dom(I) with Z ∈
  X
m−t

, the set Q(I)α has at least
t!2 · kt elements, then there exist at least t · k solutions Γ ⊆Q(I)α that pairwisely differ on
all variables in X \ Z.
• “safe”. Let Iold denote the database instance before an application of Redt and let Inew
denote its state after applying Redt. Let γ1, . . . , γk be pairwise distinct solutions in Q(Iold).
Then there exist pairwise distinct solutions γ′
1, . . . , γ′
k in Q(Inew) with δ(γ′
1, . . . , γ′
k) ≥
δ(γ1, . . . , γk), i.e., the diversity achievable before deleting tuples from the database can still
be achieved after the deletion.

---

9:20
T. Merkl, R. Pichler, and S. Skritek
Vol. 21:1
Moreover, a set of t · k solutions Γ ⊆Q(I)α that pairwisely differ on all variables in X \ Z
can be computed by iteratively choosing solutions γi (for i ∈{1, . . . , t · k}) arbitrarily from
Q(I)α that differ from all solutions γ1, . . . , γi−1 on all variables in X \ Z.
Proof. Let t ∈{1, . . . , m} and suppose that all sets Q(I)α′ with α′ : Z′ →dom(I) and
Z′ ∈
 X
m−(t−1)

have cardinality at most (t −1)!2 · kt−1.
“well-defined”. Let α be of the form α : Z →dom(I) with Z ∈
  X
m−t

and assume that
|Q(I)α| > t!2 · kt. For arbitrary γ ∈Q(I)α, we define the set Cγ as
Cγ := {γ′ ∈Q(I)α : ∆(γ, γ′) < t},
i.e., Cγ contains the solutions whose distance from γ is less than t or, equivalently, that
agree with γ on at least one variable from X \ Z. Hence, we have
Cγ =
[
x∈X\Z
Q(I)α∪{x7→γ(x)}
and thus, the size of Cγ is at most t · (t −1)!2 · kt−1 by the assumption of the lemma.
Now, iteratively select elements γi for i ∈{1, . . . , t · k} with γi ∈Q(I)α \ Si−1
j=1 Cγj, i.e.,
arbitrarily choose γ1 ∈Q(I)α, then γ2 ∈Q(I)α \ Cγ1, then γ3 ∈Q(I)α \ (Cγ1 ∪Cγ2), etc.
We claim that such elements γi for i ∈{1, . . . , t · k} indeed exist, i.e., for every i ∈
{1, . . . , t · k}, |Q(I)α \ Si−1
j=1 Cγj| > 0. Indeed, by the assumption |Q(I)α| ≥t!2 · kt and the
above considerations on the size of Cγ for arbitrary γ, we have:
|Q(I)α \
i−1
[
j=1
Cγj| ≥t!2 · kt −(i −1) · t · (t −1)!2 · kt−1 > t!2 · kt −(t · k) · t · (t −1)!2 · kt−1 = 0.
Now set Γ = {γ1, . . . , γt·k} ⊆Q(I)α. By the construction, we have that γi differs from γj for
j < i on all variables X \ Z as γi̸ ∈Cγj. Hence, Redt is well-defined, i.e., the desired t · k
solutions indeed exist.
Moreover, the proof also demonstrates that the set Γ can be constructed by starting
with one solution γ1 and then iteratively adding arbitrary solutions γi that just need to
differ from all solutions γ1, . . . , γi−1 selected so far.
“safe”. Let Iold denote the database instance before applying Redt and let Inew denote its
state after an application of Redt, i.e., Q(Inew) = (Q(Iold) \ Q(Iold)α) ∪Γ. Now consider
arbitrary pairwise distinct solutions γ1, . . . , γk ∈Q(Iold). We have to show that there exist
pairwise distinct solutions γ′
1, . . . , γ′
k in Q(Inew) with δ(γ′
1, . . . , γ′
k) ≥δ(γ1, . . . , γk).
Assume that, for some i ∈{1, . . . , k}, γi gets removed by Redt, i.e., γi ∈Q(Iold)α\Γ. We
claim that there exists γ′
i ∈Γ ⊆Q(Inew) with δ(γ1, . . . , γi−1, γ′
i, γi+1, . . . , γk) ≥δ(γ1, . . . , γk)
and is different to γ1, . . . , γi−1, γi+1, . . . , γk.
For arbitrary j̸ = i, we define the set Γj ⊆Γ as Γj = {γ′ ∈Γ : ∆(γ′, γj) < ∆(γi, γj)},
i.e., Γj contains those elements of Γ whose distance from γj is smaller than the distance
between γi and γj. We will show below that |Γj| ≤t holds. In this case, we have
|Γ \
[
i̸=j
Γj| ≥t · k −t · (k −1) = t ≥1.
That is, Γ \ S
i̸=j Γj̸ = ∅.
In other words, we can choose a solution γ′
i from Γ that
differs from all γj at least as much as γi did. Hence, such γ′
i indeed has the property
δ(γ1, . . . , γi−1, γ′
i, γi+1, γk) ≥δ(γ1, . . . , γk) and is different to γ1, . . . , γi−1, γi+1, . . . , γk. By

---

Vol. 21:1
DIVERSITY OF ANSWERS TO CONJUNCTIVE QUERIES
9:21
iterating this argument for every i ∈{1, . . . , k}, we may conclude that there exist pairwise
distinct solutions γ′
1, . . . , γ′
k ∈Inew with δ(γ′
1, . . . , γ′
k) ≥δ(γ1, . . . , γk).
It only remains to show that |Γj| ≤t indeed holds. As γi and any element γ′ ∈Γ ⊆
Q(Iold)α agree on the variables Z, a lower diversity can only be achieved by γ′, if γj and γ′
agree on some variable x ∈X \ Z. We define
Γ(x)
j
= {γ′ ∈Γ : γ′(x) = γj(x)}.
Hence,
Γj ⊆
[
x∈X\Z
Γ(x)
j .
Now, if some γ′ is in Γ(x)
j , all other γ′′ ∈Γ, γ′̸ = γ′′ are not in Γ(x)
j
as γ′ and γ′′ differ on
x ∈X \ Z by construction of Γ. Therefore, |Γ(x)
j | ≤1 and
|Γj| ≤
X
x∈X\Z
|Γ(x)
j | ≤|X \ Z| = t.
This completes the proof of the claim.
With the reduction rule Redt at our disposal, we can design an FPT-algorithm (data
complexity) for Diversemon-ACQ and, more generally, for the Diversemon-FO problem:
Theorem 3.12. The problem Diversemon-FO is in FPT in data complexity when parameterized
by the size k of the diversity set. More specifically, an instance ⟨I, Q, k, d⟩of Diversemon-FO
with m-ary FO-query Q can be reduced in polynomial time (data complexity) to an equivalent
instance ⟨I′, Q′, k, d⟩of Diversemon-FO of size O(m!2 · km).
Proof. Recall that we may assume that query Q is of the form Q(x1, . . . , xm) := R(x1, . . . , xm)
and the database I consists of a single relation RI. We apply Red1 through Redm to I in
this order exhaustively. Initially, we have to check the preconditions of Lemma 3.11 for t = 1
for us to safely apply Red1. Thus, let us consider Z ∈
 X
m

. We have Z = X and hence, for
every α : Z →dom(I) ∈Q(I), we have Q(I)α = {α}. In particular, |Q(I)α| = 1 ≤0 · k + k0.
Hence, the preconditions of Lemma 3.11 are fulfilled and exhaustive application of Red1
does not alter the status of the Diversemon-FO problem.
After exhaustive application of
Red1, if now Red2 is applicable, then the preconditions of Lemma 3.11 are fulfilled and
exhaustive application of Red2 does not alter the status of the Diversemon-FO problem, etc.
Finally, after exhaustive application of Redm, let I∗denote the resulting database
instance.
Note that, for t = m, we have
 X
0

:= {Z ⊆X : |Z| = 0} = {∅}.
and
|Q(I∗)α| ≤m!2 · km for any α : ∅→dom(I∗). In particular, this means that such an α does
not bind any variables in X. Hence, Q(I∗)α = Q(I∗) and, therefore, |Q(I∗)| ≤m!2 · km. By
the form of Q (with a single atom) and I∗(with a single relation), this means I∗is of size
O(m!2 · km).
It remains to show that the exhaustive application of Red1 through Redm is feasible
in polynomial time data complexity. In total, we have to consider at most 2m sets Z ⊆X of
variables with |Z| = m −t for t ∈{1, . . . , m} and check if Redt is applicable.
For each Z, if the reduction rule is applicable, the following computation is carried
out. Let Z = {z1, . . . , zm−t} and X \ Z = {zm−t+1, . . . , zm}. Moreover, let S ⊆RI denote
the subset of answer tuples that are still left after previous applications of the reduction
rule. Then we order S lexicographically for this variable order. That is, tuples with the

---

9:22
T. Merkl, R. Pichler, and S. Skritek
Vol. 21:1
same value combination on Z occur in contiguous positions. In a single pass of the ordered
instance S we inspect, for each value combination α on Z, the set Sα ⊆S of tuples with
precisely this value combination α on Z. If |Sα| < t!2 ·kt, then we do nothing. Otherwise, we
select t · k tuples from Sα. By the last property of Lemma 3.11, we can apply the following
steps: choose the first tuple γ1 ∈Sα; then, for every i ∈{2, . . . , t · k}, further scan Sα until
a tuple γi ∈Sα is found that differs from all tuples γ1, . . . , γi−1 on all variables X \ Z. Since
Lemma 3.11 guarantees that we can just pick suitable solutions in an arbitrary order, this
approach is guaranteed to produce the required result. Let Γ = {γ1, . . . , γt·k}. We may then
delete all tuples in Sα \ Γ from S.
The total effort for the exhaustive application of the reduction rule Redt for t ∈
{1, . . . , m} is obtained by the following considerations:
• Evaluating the original, general FO-formula over the original database instance is feasible
in polynomial time data complexity. Also, the size of the resulting answer relation RI is
of course bounded by this polynomial. Let us denote it by p.
• There is an “outer loop” over subsets Z ⊆X. There are 2m subsets, where m depends
only on the query, which is considered as constant in data complexity.
• Inside this loop, we first sort the set of remaining answer tuples S ⊆RI. The effort for
this step is bounded by O(p · log(p) · m).
• One pass of (the ordered set) S has cost ≤p.
• For each Sα, we check if |Sα| ≥t!2 · kt. If this is the case, we select t · k tuples from Sα in
a single pass of Sα. This step is feasible in time O(p · t · k · m) – including also the cost for
checking if the currently scanned tuple in Sα differs on all variables in X \ Z from the
already selected tuples γi.
• The deletion of the tuples in Sα \ Γ from S can be done by first of all marking them as
deleted when constructing the set Γ. When all α’s have been processed, we can actually
delete the marked tuples from S by yet another pass of S, which clearly fits into O(p)
time.
We now study the data complexity of the Diverse-ACQ problem in the non-parameterized
case, i.e., the size k of the diversity set is part of the input and no longer considered as the
parameter. It will turn out that this problem is NP-hard for any ws-monotone diversity
measure. Our NP-hardness proof will be by reduction from the Independent Set problem,
where we restrict the instances to graphs of degree at most 3. It was shown in [AK97] that
this restricted problem remains NP-complete.
Theorem 3.13. The problem Diversewsm-ACQ is NP-hard in data complexity. It is NP-
complete if the size k of the diversity set is given in unary.
Proof. The NP-membership is immediate: compute Q(I) (which is feasible in polynomial
time when considering the query as fixed), then guess a subset S ⊆Q(I) of size k and check
in polynomial time that S has the desired diversity.
We prove hardness by reduction from a restricted version of the Independent Set
problem, where we assume all instances of graphs to be of degree at most 3. Before we
present the reduction, let us briefly look at this restriction.
It is easy to see that Independent Set remains NP-hard if we restrict the degree of
vertices to 4. This result is obtained by combining two classical results [Pap94]: first, 3-SAT
remains NP-hard even if every variable in the propositional formulas occurs at most 3 times
and each literal occurs at most 2 times. And second, we apply the reduction from 3-SAT to

---

Vol. 21:1
DIVERSITY OF ANSWERS TO CONJUNCTIVE QUERIES
9:23
Independent Set where each clause is represented by a triangle and any two dual literals
are connected by an edge. Hence, in the resulting graph, each vertex is adjacent two at
most 4 vertices (the other 2 vertices in the triangle plus at most 2 vertices corresponding to
dual literals). This result was strengthened in [AK97] where it was shown that we may even
further restrict the degree of vertices to 3. The idea of Alimonnti and Kann [AK97] is to
apply the following transformation for each vertex of degree greater than 3: suppose that
v has degree greater than 3; then replace v by a path v1, v2, v3, where 2 edges containing
v are connected to v1 and the remaining edges of v are connected to v3. Thus, v1 and v2
have degree less than or equal to 3 while the degree of v3 is strictly less than the degree
of v. Furthermore, the original graph has an independent set of size k if and only if the
new one has an independent set of size k + 1 as picking v1 and v3 corresponds to picking
v. Exhaustive application of this transformation yields an instance of Independent Set
where every vertex in the graph has degree ≤3.
For the NP-hardness, we define the query Q independently of the instance of the
Independent Set problem as Q(x1, x2, x3, x4, x5) := R(x1, x2, x3, x4, x5), i.e., the only
relation symbol R has arity 5. Now let (G, s) be an instance of Independent Set where
each vertex of G has degree at most 3.
Let V (G) = {v1, . . . , vn} and E(G) = {e1, . . . , em}. Then the database I consists of a
single relation RI with n tuples (= number of vertices in G) over the domain dom(I) =
{free1, . . . , freen, taken1, . . . , takenm}. The i-th tuple in RI will be denoted (ei,1, . . . , ei,5).
For each vi ∈V (G), the values ei,1, . . . , ei,5 ∈dom(I) are defined by an iterative process:
(1) The iterative process starts by initializing all ei,1, . . . , ei,5 to freei for each vi ∈V (G).
(2) We then iterate through all edges ej ∈E(G) and do the following: Let vi and vi′ be the
two incident vertices to ej and let t ∈{1, . . . , 5} be an index such that ei,t and ei′,t both
still have the values freei and freei′, respectively. Then set both ei,t and ei′,t to takenj.
In the second step above when processing an edge ej, such an index t must always exist. This
is due to the fact that, at the moment of considering ej, the vertex vi has been considered
at most twice (the degree of vi is at most 3) and thus, for at least three different values of
t ∈{1, . . . , 5}, the value ei,t is still set to freei. Analogous considerations apply to vertex
vi′ and thus, for at least 3 values of t ∈{1, . . . , 5}, we have ei′,t = freei′. Hence, by the
pigeonhole principle, there exists t ∈{1, . . . , 5} with ei,t = freei and ei′,t = freei′.
After the iterative process, the database I is defined by RI = {(ei,1, ei,2, ei,3, ei,4, ei,5) :
i = 1, . . . , n}. Moreover, the size of the desired diversity set is set to k = s and the target
diversity is set to d = f(5, . . . , 5), where f is the aggregator of δwsm aggregating the value 5
exactly
 k
2

times. The resulting problem instance is of the form ⟨I, Q, k, d⟩.
The reduction is clearly feasible in polynomial time. Its correctness, i.e., the graph
G = (V (G), E(G)) having an independent set of size s if and only if there exists S ⊆Q(I)
with |S| = k and diversity ≥d hinges on the observation that the desired diversity can
only be reached by k answer tuples that pairwisely differ in all 5 positions due to ws-
monotonicity. Furthermore, the answers Q(I) are trivially {γ1, . . . , γn} with γi(xt) = ei,t for
each t ∈{1, . . . , 5}. We thus have to show that these differ on all values if and only if G has
an independent set of size s = k.
First, suppose that G has such an independent set, say {vi1, . . . , vik}. We claim that
then {γi1, . . . , γik} is a subset of Q(I) with the desired diversity, i.e., any two answers γir
and γis differ on all 5 variables. Suppose to the contrary that γir(t) = γis(t) holds for
some t ∈{1, . . . , 5}. By our construction of RI, this can only happen if γir(t)̸ = freeir and

---

9:24
T. Merkl, R. Pichler, and S. Skritek
Vol. 21:1
γis(t)̸ = freeis. Hence, γir(t) = γis(t) = takenj for some j ∈{1, . . . , m} holds. Again by
our construction of RI, this means that both vir and vis are incident to the edge ej. This
contradicts the assumption that both vir and vis are contained in an independent set.
Conversely, suppose that there exists a subset S ⊆Q(I) of size k with the desired
target diversity. Let S = {γi1, . . . , γik}. We claim that then {vi1, . . . , vik} is an independent
set of G. Suppose to the contrary that it is not, i.e., two vertices vir and vis are incident
to the same edge ej. Then, by our construction of I, there exists t ∈{1, . . . , 5} with
γir(t) = γis(t) = takenj. This means that ∆(γir, γis) < 5 and hence, the target diversity
f(5, . . . , 5) cannot be reached by S due to ws-monotonicity, which is a contradiction.
4. Diversity of Unions of Conjunctive Queries
We now turn our attention to UCQs. Of course, all hardness results proved for CQs and
ACQs in Section 3 carry over to UCQs and UACQs, respectively. Moreover, the FPT-
membership result from Theorem 3.12 for general FO-formulas of course also includes UCQs.
It remains to study the query complexity and combined complexity of UACQs. It turns out
that the union makes the problem significantly harder than for ACQs and we are not able
to establish XP-membership. Instead, we show next that Diversewsm-UACQ is NP-hard even
in a very restricted setting, namely where we are looking for a pair of diverse answers to
a union of two ACQs over a fixed database. Put differently, Diversewsm-UACQ is NP-hard
in query complexity even when fixing the parameter to k = 2, making the existence of an
XP-algorithm unlikely.
The proof will be by reduction from a variant of the List Coloring problem, which
we introduce next: A list assignment C assigns each vertex v of a graph G a list of colors
C(v) ⊆{1, . . . , l}, l ∈N. Then a coloring is a function c : V (G) →{1, . . . , l} and it is called
C−admissible if each vertex v ∈V (G) is colored in a color of its list, i.e., c(v) ∈C(v), and
adjacent vertices u, v ∈E(G) are colored with different colors, i.e., c(u)̸ = c(v). Formally,
the problem is defined as follows:
List Coloring
Input: A graph G, an integer l ∈N, and a list assignment C : V (G) →2{1,...,l}.
Question: Does there exist a C-admissible coloring c : V (G) →{1, . . . , l}?
Clearly, List Coloring is a generalization of 3-Colorability and, hence, NP-complete.
It was shown in [CC06], that the List Coloring problem remains NP-hard even when
assuming that each vertex of G has degree 3, G is bipartite, and l = 3. This restriction will
be used in the proof of the following theorem. Note that these restrictions also imply that
both parts of the bipartition are of the same size.
Theorem 4.1. The problem Diversewsm-UACQ is NP-hard in query complexity (and hence,
also in combined complexity). It remains NP-hard even if the desired size of the diversity
set is bounded by 2 and the UACQs are restricted to containing at most two CQs and no
existential variables. The problem is NP-complete if the size k of the diversity set is given in
unary.
Proof. The NP-membership in case of k given in unary is immediate: guess k assignments
to the free variables of query Q, check in polynomial time that they are solutions, and verify
in polynomial time that their diversity is above the desired threshold.

---

Vol. 21:1
DIVERSITY OF ANSWERS TO CONJUNCTIVE QUERIES
9:25
For our problem reduction, we consider a fixed database I over a fixed schema, which
consists of the 4 domain elements dom(I) = {0, 1, 2, 3} and 9 relation symbols
R{1}, R{2}, R{3}, R{1,2}, R{1,3}, R{2,3}, R{1,2,3}, S, S′.
The relations of the database are defined as follows:
RI
{1} = {(1, 1, 1)},
RI
{1,2} = {(1, 1, 1), (2, 2, 2)},
RI
{2} = {(2, 2, 2)},
RI
{1,3} = {(1, 1, 1), (3, 3, 3)},
RI
{3} = {(3, 3, 3)},
RI
{2,3} = {(2, 2, 2), (3, 3, 3)},
RI
{1,2,3} = {(1, 1, 1), (2, 2, 2), (3, 3, 3)},
SI = {(0)},
S′I = {(1)}.
Now let ⟨G, l, C⟩be an arbitrary instance of List Coloring, where each vertex of G has
degree 3, G is bipartite, and l = 3. That is, G is of the form G = (V ∪V ′, E) for vertex
sets V, V ′ and edge set E with V = {v1, . . . , vn}, V ′ = {v′
1, . . . , v′
n}, and E = {e1, . . . , e3n}.
Note that |V | = |V ′| and |E| = 3 · |V | as each vertex in G has degree 3 and G is bipartite.
From this, we construct a UACQ Q as follows: we use the 3n + 1 variables x1, . . . , x3n, y
in our query. For each i ∈{1, . . . , n}, we write eji,1, eji,2, eji,3 to denote the three edges
incident to the vertex vi. Analogously, we write ej′
i,1, ej′
i,2, ej′
i,3 to denote the three edges
incident to the vertex v′
i.
The UACQ Q is then defined as Q(x1, . . . , x3n, y) := φ ∨ψ with
φ =
n^
i=1
RC(vi)(xji,1, xji,2, xji,3) ∧S(y),
ψ =
n^
i=1
RC(v′
i)(xj′
i,1, xj′
i,2, xj′
i,3) ∧S′(y).
Moreover, we set the target diversity to d = f(3n + 1), where f is the aggregator of δ, and
we are looking for k = 2 solutions to reach this diversity. Observe that each variable appears
exactly once in φ and once in ψ, which makes both formulas trivially acyclic. Furthermore,
Q contains no existential variables.
The intuition of the big conjunction in φ (resp. ψ) is to “encode” for each vertex vi (resp.
v′
i) the 3 edges incident to this vertex in the form of the 3 x-variables with the corresponding
indices. The relation symbol chosen for each vertex vi or v′
i depends on the color list for
this vertex. For instance, if C(v1) = {2, 3} and if v1 is incident to the edges e4, e6, e7, then
the first conjunct in the definition of φ is of the form R{2,3}(x4, x6, x7). Note that the order
of the variables in this atom is irrelevant since the R-relations contain only tuples with
identical values in all 3 positions. Intuitively, this ensures that a vertex (in this case v1) gets
the same color (in this case color 2 or 3) in all its incident edges (in this case e4, e6, e7).
It remains to prove the correctness of this reduction. For this, observe that diversity
d = f(3n + 1) can only be achieved by two answers γ, γ′ that differ on all variables due to
ws-monotonicity. Due to the y variable with possible values 0 and 1, one answer has to
satisfy φ while the other answer satisfies ψ. W.l.o.g., let γ satisfy φ and let γ′ satisfy ψ.
The intuition behind the reduction is that γ tells us how to color the vertices in V while γ′
tells us how to color the vertices in V ′.
We have to show that (G, l, C) is a positive instance of List Coloring if and only if
⟨Q, I, 2, f(3n + 1)⟩is a positive instance of Diversewsm-UACQ.

---

9:26
T. Merkl, R. Pichler, and S. Skritek
Vol. 21:1
For the “only if”-direction, suppose that (G, l, C) is a positive instance of List Coloring,
i.e., graph G has a C-admissible coloring c : V ∪V ′ →{1, 2, 3}. From this, we construct the
assignments γ and γ′ to the 3n + 1 variables in Q as follows:
γ(y) = 0 and γ(xji,1) = γ(xji,2) = γ(xji,3) = c(vi) for every i ∈{1, . . . , n} and, analogously,
γ′(y) = 1 and γ′(xj′
i,1) = γ′(xj′
i,2) = γ(xj′
i,3) = c(v′
i) for every i ∈{1, . . . , n}.
We first have to verify that γ is a solution of φ and γ′ is a solution of ψ. We only do this for
γ. The argumentation for γ′ is analogous. S(γ(y)) = S(0) is clearly contained in database
I. Now consider an arbitrary index i ∈{1, . . . , n}. The atom RC(vi)(xji,1, xji,2, xji,3) is
sent to RC(vi)(c(vi), c(vi), c(vi)) by γ. By the above construction of database I, the tuple
(c(vi), c(vi), c(vi)) is indeed contained in relation RI
C(vi).
It remains to show that the two assignments γ and γ′ differ on every variable. Let
xjr,t and xj′s,u with r, s ∈{1, . . . , n} and t, u ∈{1, 2, 3} denote the same variable. By our
construction of the R-atoms in φ and ψ, this means that ejr,t and ej′s,u denote the same edge
in G and vr and v′
s are the two endpoints of this edge. Since c is a C-admissible coloring,
we have c(vr)̸ = c(v′
s). Moreover, by our definition of γ and γ′, we have γ(xjr,t) = c(vr) and
γ′(xj′s,u) = c(v′
s). Hence, γ and γ′ indeed differ on an arbitrarily chosen variable and, thus,
on every variable.
For the “if”-direction, suppose that ⟨Q, I, 2, f(3n + 1)⟩is a positive instance of Diverse-
UACQ, i.e., there exist two solutions γ and γ′ with diversity f(3n + 1). This means that γ
and γ′ differ on every variable, in particular on y. Hence, one of the solutions is an answer
of φ and one of ψ. W.l.o.g., let γ be an answer of φ and let γ′ be an answer of ψ. From this,
we construct the following coloring c : V ∪V ′ →{1, 2, 3}:
c(vi) = γ(xji,1) and c(v′
i) = γ′(xj′
i,1) for every i ∈{1, . . . , n}.
We have to show that c is C-admissible. Consider an arbitrary edge e with endpoints vr and
vs for r, s ∈{1, . . . , n}. By our construction of Q, there exist indices t, u ∈{1, 2, 3}, such
that xjr,t and xj′s,u denote the same variable. Since γ and γ′ have diversity f(3n + 1), the
assignments γ and γ′ differ on every variable. In particular, we have γ(xjr,t)̸ = γ′(xj′s,u).
Moreover, by our definition of coloring c and the database I, we have c(vr) = γ(xjr,1) =
γ(xjr,t) and c(v′
s) = γ′(xj′
s,1) = γ′(xj′s,u).
Hence, c assigns different colors to the two
arbitrarily chosen, adjacent vertices vr and v′
s and, therefore, to any adjacent vertices of G.
That is, c is C-admissible.
5. Diversity of Conjunctive Queries with Negation
Lastly, we consider CQs¬. As was recalled in Section 1, the restriction to acyclicity is not
sufficient to ensure tractable answering of CQs¬ [Lan23]. In the following, we thus restrict
ourselves to queries of bounded treewidth when analyzing the Diverse-CQ¬ problem.
The data complexity case has already been settled for arbitrary FO-formulas in The-
orem 3.12. Hence, of course, also Diverse-CQ¬ is in FPT data complexity and NP-hard
in the non-parameterized case. Moreover, we observe that the query used in the proof of
Theorem 3.8 has a treewidth of one. Hence, it is clear that also Diversewsm-CQ¬ is W[1]-hard
combined complexity for queries with bounded treewidth. It remains to study the combined
complexity upper bound, for which we describe an XP-algorithm next.

---

Vol. 21:1
DIVERSITY OF ANSWERS TO CONJUNCTIVE QUERIES
9:27
Our algorithm is based on so-called nice tree decompositions – a normal form introduced
in [Klo94]. A nice tree decomposition only allows leaf nodes plus three types of inner nodes:
introduce nodes, forget nodes, and join nodes. An introduce node t has a single child t′ with
χ(t) = χ(t′) ∪{z} for a single variable z. Similarly, a forget node t has a single child t′ with
χ(t′) = χ(t) ∪{z} for a single variable z. Finally, a join node t has two child nodes t1, t2
with χ(t) = χ(t1) = χ(t2). It was shown in [Klo94] that every tree decomposition can be
transformed in linear time into a nice tree decomposition without increasing the width.
The intuition of the present algorithm is very similar to the intuition of Algorithm 3.1 pre-
sented in Section 3.1.1. That is, both algorithms maintain information on tuples of k partial
solutions in a set Dt. Concretely, these tuples are again of the form (α1, . . . , αk, (di,j)1≤i<j≤k).
This time, however, partial solutions αi are not assignments that satisfy concrete atoms but
arbitrary assignments defined on χ(t). Nevertheless, a tuple gets added to Dt if and only
if it is possible to extend the partial solutions to mappings γ1, . . . , γk that (a) satisfy the
query associated to the subtree rooted in t and (b) for 1 ≤i < j ≤k the distance between
γi and γj is exactly di,j.
Formally, for a CQ¬ Q(X) := ∃Y Vn
i=1 Li(X, Y ) and nice tree decomposition ⟨T, χ, r⟩
of Q we define for t ∈V (T) the subquery
Qt =
^
i=1,...,n
var(Li)⊆χ(t)
Li,
i.e., Qt contains those literals of Q whose variables are covered by χ(t).
Algorithm 5.1. Given Q(X), I, k, d, a nice tree decomposition ⟨T, χ, r⟩of minimum width,
and a diversity measure δ defined via some aggregate function f, the algorithm proceeds in
two main steps: First, sets Dt are computed bottom-up for each t ∈V (T), and then, it is
determined from Dr whether the diversity threshold d can be met. For the bottom-up step,
the type of t determines how Dt is computed:
• Leaf Node: For a leaf node t ∈V (T) we create Dt as
Dt = {(α1, . . . , αk, (di,j)1≤i<j≤k) : α1, . . . , αk : χ(t) →dom(I),
α1, . . . , αk satisfy Qt,
di,j = ∆X(αi, αj), 1 ≤i < j ≤k}.
Hence, we exhaustively go through all possible variable assignments α1, . . . , αk : χ(t) →
dom(I), keep those which satisfy the query Qt, and record their pairwise diversities.
• Introduce Node: For an introduce node t ∈V (T) with child c ∈V (T) which introduces
the variable z ∈χ(t) \ χ(c), we create Dt as
Dt = {(α1 ∪β1, . . . , αk ∪βk, (d′
i,j)1≤i<j≤k) : (α1, . . . , αk, (di,j)1≤i<j≤k) ∈Dc,
β1, . . . , βk : {z} →dom(I),
α1 ∪β1, . . . , αk ∪βk satisfy Qt,
d′
i,j = di,j + ∆X(βi, βj), 1 ≤i < j ≤k}.
Thus, we extend the domain of the local variable assignments in Dc by z. We do this by
exhaustively going through all e ∈Dc in combination with all β1, . . . , βk : {z} →dom(I),
check if the extensions α1 ∪β1, . . . , αk ∪βk satisfy all literals for which all variables are
covered, and, if this is the case, add the diversity achieved on the z-variable.

---

9:28
T. Merkl, R. Pichler, and S. Skritek
Vol. 21:1
• Forget Node: For a forget node t ∈V (T) with child c ∈V (T) we create Dt as
Dt = {(α1|χ(t), . . . , αk|χ(t), (di,j)1≤i<j≤k) : (α1, . . . , αk, (di,j)1≤i<j≤k) ∈Dc}.
• Join Node: For a join node t ∈V (T) with children c1, c2 ∈V (T) we create Dt as
Dt = {(α1, . . . , αk, (di,j)1≤i<j≤k) : (α1, . . . , αk, (d′
i,j)1≤i<j≤k) ∈Dc1,
(α1, . . . , αk, (d′′
i,j)1≤i<j≤k) ∈Dc2,
di,j = d′
i,j + d′′
i,j −∆X(αi, αj), 1 ≤i < j ≤k}.
In this step, we match rows of Dc1 with rows of Dc2 that agree on the local variable
assignments and simply combine the diversities achieved in the two child nodes while
subtracting the diversity counted twice.
For the second step, the algorithm goes through all (α1, . . . , αk, (di,j)1≤i<j≤k) ∈Dr and
removes those tuples where di,j = 0 for at least one 1 ≤i < j ≤k or f((di,j)1≤i<j≤k) < d.
Then, the algorithm returns “yes” if the resulting set is non-empty and otherwise “no”.
Clearly, the algorithm is well-defined and terminates. The next theorem states that the
algorithm decides Diverse-CQ¬, and discusses its running time.
Theorem 5.2. For a class of CQs¬ of bounded treewidth, the problem Diverse-CQ¬ is in
XP in combined complexity when parameterized by the size k of the diversity set. More
specifically, let Q(X) be from a class of CQs¬ which have treewidth ≤ω. Then, for a database
instance I and integers k, d, Algorithm 3.1 solves Diverse-CQ¬ in time O(dom(I)2·k·(ω+1) ·
(|X| + 1)k(k−1) · poly(|Q|, k)), where poly(|Q|, k) is a polynomial in |Q| and k.
To prove this statement, we show by a sequence of lemmas that Dt truly captures the
intended meaning. As before, let Q(X) be a CQ¬, ⟨T, χ, r⟩a nice tree decomposition of Q,
k the number of elements in the diversity set, and d the required diversity. Furthermore,
we extend the definition of χ and Qt to subtrees Tt of T rooted in t. To that end, let
χ(Tt) = S
t′∈V (Tt) χ(t′) and
QTt =
^
i=1,...,n
var(Li)⊆χ(Tt)
Li.
With this, for a tuple
e = (α1, . . . , αk, (di,j)1≤i<j≤k) ∈(χ(t) →dom(I))k × {0, . . . , |X|}
k(k−1)
2
we define a set of witnesses
witt(e) = {(γ1, . . . , γk) : γ1, . . . , γk ∈QTt(I),
γ1 ∼= α1, . . . , γk ∼= αk,
di,j = ∆X(γi, γj), 1 ≤i < j ≤k}.
The existence of such extensions (γ1, . . . , γk) ∈witt(e) are precisely guaranteed by e ∈Dt as
they satisfy the query corresponding to the subtree rooted in t and (di,j)1≤i<j≤k are their
pairwise distances. Thus, the algorithm should maintain the following invariant:
e ∈Dt if and only if witt(e)̸ = ∅.
(†)
We show next that the algorithm preserves the invariant when handling each node t ∈V (T).

---

Vol. 21:1
DIVERSITY OF ANSWERS TO CONJUNCTIVE QUERIES
9:29
Lemma 5.3. Let t be a leaf node of T. Then Invariant (†) holds for
Dt = {(α1, . . . , αk, (di,j)1≤i<j≤k) : α1, . . . , αk : χ(t) →dom(I),
α1, . . . , αk ∈Qt(I),
di,j = ∆X(αi, αj), 1 ≤i < j ≤k}.
Proof. Observe that χ(t) = χ(Tt) and α1, . . . , αk are the only extensions of α1, . . . , αk.
Hence,
e = (α1, . . . , αk, (di,j)1≤i<j≤k) ∈Dt ⇐⇒(α1, . . . , αk) ∈witt(e).
Lemma 5.4. Let t be an introduce node of T which introduces the variable z and let c be its
child. Then, if Invariant (†) holds for Dc, it also holds for
Dt = {(α1 ∪β1, . . . , αk ∪βk, (d′
i,j)1≤i<j≤k) : (α1, . . . , αk, (di,j)1≤i<j≤k) ∈Dc,
β1, . . . , βk : {z} →dom(I),
α1 ∪β1, . . . , αk ∪βk ∈Qt(I),
d′
i,j = di,j + ∆X(βi, βj), 1 ≤i < j ≤k}.
Proof. First notice that χ(Tc) ∪{z} = χ(Tt) and thus, every literal of QTc appears in QTt.
Furthermore, any variable of χ(Tc) that appears together with z in a literal has to appear in
χ(t) due to the properties of a tree decomposition. We can therefore also conclude that a
literal appears in QTt if and only if it appears in QTc or Qt.
Now, let the tuple e = (α1 ∪β1, . . . , αk ∪βk, (d′
i,j)1≤i<j≤k) be in Dt and let ec =
(α1, . . . , αk, (di,j)1≤i<j≤k) be a matching tuple in Dc. Thus there is a (γ1, . . . , γk) ∈witc(ec).
Importantly, γ1, . . . , γk ∈I(QTc), α1∪β1, . . . , αk ∪βk ∈I(Qt) and thus, γ1∪β1, . . . , γk ∪βk ∈
I(QTt). Furthermore, for 1 ≤i < j ≤k, we have:
d′
i,j = di,j + ∆X(βi, βj)
= ∆X(γi, γj) + ∆X(βi, βj)
= ∆X(γi ∪βi, γj ∪βj).
Thus, (γ1 ∪β1, . . . , γk ∪βk) ∈witt(e) by definition.
For the reverse direction, let e = (α1, . . . , αk, (d′
i,j)1≤i<j≤k) be such that there is a
(γ1, . . . , γk) ∈witt(e). Thus, we can immediately conclude that γ1|χ(t), . . . , γk|χ(t) ∈I(Qt)
while γ1|χ(Tc), . . . , γk|χ(Tc) ∈I(QTc). Furthermore, for 1 ≤i < j ≤k, we have:
d′
i,j −∆X(γi|{z}, γj|{z}) = ∆X(γi, γj) −∆X(γi|{z}, γj|{z})
= ∆X(γi|χ(Tt), γj|χ(Tt)).
Thus,
ec = (γ1|χ(c), . . . , γk|χ(c), (d′
i,j −∆X(γi|{z}, γj|{z}))1≤i<j≤k) ∈Dc.
as (γ1|χ(Tc), . . . , γk|χ(Tc)) ∈witc(ec). Defining β1 = γ1|{z}, . . . , βk = γk|{z} then ensures that
(γ1|χ(Tc) ∪β1, . . . , γk|χ(Tc) ∪βk, (d′
i,j)1≤i<j≤k) = (α1, . . . , αk, (d′
i,j)1≤i<j≤k) is in Dt.
Lemma 5.5. Let t be a forget node of T and c its child. Then, if Invariant (†) holds for
Dc, it also holds for
Dt = {(α1|χ(t), . . . , αk|χ(t), (di,j)1≤i<j≤k) : (α1, . . . , αk, (di,j)1≤i<j≤k) ∈Dc}.

---

9:30
T. Merkl, R. Pichler, and S. Skritek
Vol. 21:1
Proof. Let z be the forgotten variable. The claim follows from the fact that QTt = QTc and
χ(t) ⊆χ(c), and thus,
witt(α′
1, . . . , α′
k, (di,j)1≤i<j≤k) =
[
βi : {z}→dom(I)
l=1,...,k
witc(α′
1 ∪β1, . . . , α′
k ∪βk, (di,j)1≤i<j≤k).
Lemma 5.6. Let t be a join node of T with children c1 and c2. Then, if Invariant (†) holds
for Dc1 and Dc2, it also holds for
Dt = {(α1, . . . , αk, (di,j)1≤i<j≤k) : (α1, . . . , αk, (d′
i,j)1≤i<j≤k) ∈Dc1,
(α1, . . . , αk, (d′′
i,j)1≤i<j≤k) ∈Dc2,
di,j = d′
i,j + d′′
i,j −∆X(αi, αj), 1 ≤i < j ≤k}.
Proof. First notice that χ(Tc1) ∪χ(Tc2) = χ(Tt) and thus, literals that appear in QTc1 or
QTc2 also appear in QTt. Moreover, if two variables appear in the same literal in QTt but
they no longer jointly occur in χ(t), then these variables have to appear together in either
Tc1 or Tc2. We can, therefore, observe that a literal appears in QTt if and only if it appears
in QTc1 or QTc2.
We start with some
e1 = (α1, . . . , αk, (d′
i,j)1≤i<j≤k) ∈Dc1 and e2 = (α1, . . . , αk, (d′′
i,j)1≤i<j≤k) ∈Dc2.
Now let (γ′
1, . . . , γ′
k) ∈witc1(e1) and (γ′′
1, . . . , γ′′
k) ∈witc2(e2) witness this, respectively. By
the above observation, γ′
1 ∪γ′′
1, . . . , γ′
k ∪γ′′
k ∈QTt(I) and, for 1 ≤i < j ≤k, we have:
∆X(γ′
i ∪γ′′
i , γ′
j ∪γ′′
j ) = ∆X(γ′
i, γ′
j) + ∆X(γ′′
i , γ′′
j ) −∆X(γ′
i ∩γ′′
i , γ′
j ∩γ′′
j )
= d′
i,j + d′′
i,j −∆X(αi, αj).
Hence, e = (α1, . . . , αk, (d′
i,j +d′′
i,j −∆X(αi, αj))1≤i<j≤k) ∈Dt is justified as (γ′
1∪γ′′
k, . . . , γ′
1∪
γ′′
k) ∈witt(e).
Conversely, let e = (α1, . . . , αk, (di,j)1≤i<j≤k) be a tuple such that there is a (γ1, . . . , γk) ∈
witt(e). Thus, we can immediately conclude that the restrictions γ1|χ(Tc1), . . . , γk|χ(Tc1) are
in I(QTc1) while the restrictions γ1|χ(Tc2), . . . , γk|χ(Tc2) are in I(QTc2). This implies that
(γ1|χ(t), . . . , γk|χ(t), (∆X(γi|χ(Tc1), γk|χ(Tc1)))1≤i<j≤k) ∈Dc1,
(γ1|χ(t), . . . , γk|χ(t), (∆X(γi|χ(Tc2), γk|χ(Tc2)))1≤i<j≤k) ∈Dc2.
Lastly, we can compute for 1 ≤i < j ≤k:
di,j = ∆X(γi, γj)
= ∆X(γi|χ(Tc1), γj|χ(Tc1)) + ∆X(γi|χ(Tc2), γj|χ(Tc2)) −∆X(γi|χ(t), γj|χ(t)),
implying that e ∈Dt.
Importantly, Lemmas 5.3 through 5.6 ensure that after the bottom-up traversal of
Algorithm 5.1, Invariant (†) is satisfied for Dr. We now show that the algorithm correctly
determines from Dr if there is a diversity set of size k which has diversity exceeding d.
Lemma 5.7. If Invariant (†) holds for Dr then there exist solutions {γ1, . . . , γk} ⊆Q(I)
with δ(γ1, . . . , γk) ≥d if and only if there is a tuple (α1, . . . , αk, (di,j)1≤i<j≤k) ∈Dr such
that di,j > 0, 1 ≤i < j ≤k and f((di,j)1≤i<j≤k) ≥d

---

Vol. 21:1
DIVERSITY OF ANSWERS TO CONJUNCTIVE QUERIES
9:31
Proof. First observe that Q = ∃Y QTr and thus, Q(I) = {γ|X : γ ∈Q(Tr)}. Furthermore,
for γ, γ′ ∈Q(Tr) we have ∆(γ|X, γ|X) = ∆X(γ, γ′).
Now assume k solutions {γ1|X, . . . , γk|X} ⊆Q(I) with δ(γ1|X, . . . , γk|X) ≥d to exist.
Consider the tuple e = (γ1|χ(r), . . . , γk|χ(r), (∆X(γi, γj))1≤i<j≤k). By definition, we have
(γ1, . . . , γk) ∈witt(e) and hence, e ∈Dr. Furthermore, ∆X(γi, γj) = ∆(γi|X, γj|X) > 0 for
1 ≤i < j ≤k and
f((∆X(γi, γj))1≤i<j≤k) = f((∆(γi|X, γj|X))1≤i<j≤k) = δ(γ1|X, . . . , γk|X) ≥d.
For the reverse direction assume such a tuple e = (α1, . . . , αk, (di,j)1≤i<j≤k) ∈Dr
with di,j > 0, 1 ≤i < j ≤k, and f((di,j)1≤i<j≤k) ≥d to exist. Thus, there also exists
(γ1, . . . , γk) ∈witr(e) and we claim that {γ1|X, . . . , γk|X} is a diversity set as required. First
observe that γi|X is different to γj|X for 1 ≤i < j ≤k as ∆(γi|X, γj|X) = ∆X(γi, γj) = di,j >
0. Secondly, δ(γ1|X, . . . , γk|X) = f((∆(γi|X, γj|X))1≤i<j≤k) = f((∆X(γi, γj))1≤i<j≤k).
We now show that the bottom-up step is also possible in the required time bound.
Lemma 5.8. Let t be an arbitrary node in T, ω the width of the tree decomposition. Then,
Dt can be computed in time O(dom(I)2·k·(ω+1) · (|X| + 1)k(k−1) · (|Q| + k2 · ω)) given the sets
of its children.
Proof. This running time is achieved by a naive implementation. For a leaf node, we simply
have to iterate through the |dom(I)||χ(t)|·k options for α1, . . . , αk : χ(t) →dom(I), check
that all assignments are answers to Qt (each relevant table of I is at most of size dom(I)ω+1),
and compute the Hamming distances.
For an introduce node, we iterate through all elements of Dc and all |dom(I)|k possibilities
for β1, . . . , β2 : {z} →dom(I), again check whether all assignments are answers to Qt, and
update the distances. Note that the size of the set Dc is at most |dom(I)|k·(ω+1)·(|X|+1)
k(k−1)
2
by definition since |X| is an upper bound on the pairwise Hamming distance.
For a forget node, we simply need to perform a projection. Lastly, for a join node,
we iterate through Dc1 × Dc2, check whether the assignments α1, . . . , αk match, and then
update the distances.
All of the cases can therefore clearly be handled in the given time bound.
With this, we can now show Theorem 5.2.
Proof of Theorem 5.2. To prove the result, we only have to ensure that finding a suitable
tree decomposition and applying the algorithm is possible in the required time bound as the
correctness of this procedure follows directly from Lemmas 5.3 to 5.7.
Due to [Bod96] and [Klo94] computing a width optimal nice tree decomposition is
possible in linear time. Furthermore, the number of nodes in this tree decomposition is
linear in |Q| and, thus, performing the bottom-up traversal of the algorithm is possible in
the required time bound due to Lemma 5.8. Lastly, we also have to look at the running
time of the final step of the algorithm. There, we possibly have to evaluate f for each tuple
in Dr. But, since |Dr| ≤dom(I)k(ω+1) · (|X| + 1)
k(k−1)
2
and f is computable in polynomial
time (in k and |X|), also this step is possible in the required time bound.
We conclude this section by again stressing the analogy with Algorithm 3.1 for ACQs:
First, we have omitted from our description of Algorithm 5.1 how to compute a concrete
witnessing diversity set in the case of a yes-answer.
This can be done exactly as in
Algorithm 3.1 by maintaining the same kind of provenance information. And second, it is

---

9:32
T. Merkl, R. Pichler, and S. Skritek
Vol. 21:1
possible to speed up the present algorithm by applying the same kind of considerations as
in Section 3.1.3. It is thus possible to reduce the query complexity to FPT for the diversity
measure δsum and even further to P if we allow duplicates in the diversity set.
6. Conclusion and Future Work
In this work, we have had a fresh look at the Diversity problem of query answering. For
CQs and extensions thereof, we have proved a collection of complexity results, both for the
parameterized and the non-parameterized case. To get a chance of reaching tractability or
at least fixed-parameter tractability (when considering the size k of the diversity set as the
parameter), we have restricted ourselves to acyclic CQs and CQs with negation of bounded
treewidth, respectively. For the chosen settings, our complexity results are fairly complete.
The most obvious gaps left for future work are concerned with the query complexity of
ACQs and CQs with negation of bounded treewidth. For the parameterized case, we have
XP-membership but no fixed-parameter intractability result in the form of W[1]-hardness.
And for the non-parameterized case, it is open if the problems are also NP-hard as we have
shown for the data complexity.
It should be noted that the restriction to acyclic CQs is less restrictive than it may
seem at first glance. As was mentioned in Section 2, query evaluation of CQs with bounded
hypertree width (likewise, CQs with bounded generalized or fractional hypertree width)
can be efficiently reduced to query evaluation of acyclic CQs. Hence, our upper bounds
(in particular, the XP- and FPT-membership results in Section 3) are easily generalized to
CQs of bounded hypertree-width [GLS02]. Moreover, recent empirical studies of millions
of queries from query logs [BMT20] and thousands of queries from benchmarks [FGLP21]
have shown that CQs typically have hypertree-width at most 3.
A yet more powerful width measure than hw, ghw, and fhw is submodular-width
(smw) introduced in [Mar13]. In fact, Marx showed that bounded smw, in a sense, exactly
characterizes the class of CQs for which query evaluation is fixed-parameter tractable,
parameterized by the size of the query. In contrast to the other width measures, there is no
obvious extension of our results to CQs of bounded smw. Indeed, query evaluation based on
bounded smw works by partitioning the database via so-called “heavy-light splitting” (i.e.,
treating attribute values with high vs. low frequency differently). Clearly, this reduces the
problem of CQ-evaluation to a problem of UCQ-evaluation and we have seen in Section 4 that
the diversity problem for UACQs immediately leads to intractability. Hence, a completely
different approach would be needed to extend our results to CQs with bounded smw.
For CQs with negation, a stronger restriction than acyclicity (or bounded hw, ghw, fhw) is
needed to achieve tractability of query evaluation [Lan23]. Consequently, we have studied CQs
with negation of bounded treewidth. Another interesting restriction on the structure of CQs
with negation to achieve tractable query evaluation is β-acyclicity [Bra12, NNRR14, CI24]
or, more generally, bounded nest-set width [Lan23, CI24]. Both these properties are defined
via a form of variable elimination. In contrast to acyclic queries or queries of bounded tw
(and, likewise, bounded hw, ghw, fhw), there is no form of decomposition to characterize
β-acyclicity or bounded nest-set width. Hence, there is no obvious way how to extend our
results on CQs with negation to β-acyclic queries or queries with bounded nest-set width.
We leave both, the diversity study of CQs with bounded smw and of CQs with negation of
bounded nest-set width as interesting questions for future work.

---

Vol. 21:1
DIVERSITY OF ANSWERS TO CONJUNCTIVE QUERIES
9:33
Another direction for future work is motivated by a closer look at our FPT- and
XP-membership results: even though such parameterized complexity results are generally
considered as favorable (in particular, FPT), the running times are exponential in the
parameter k. As we allow larger values of k, these running times may not be acceptable
anymore. It would therefore be interesting to study the diversity problem also from an
approximation point of view – in particular, contenting oneself with an approximation of
the desired diversity.
A further modification of our settings is related to the choice of a different distance
measure between two answer tuples and different aggregators. As far as the distance measure
is concerned, we have so far considered data values as untyped and have therefore studied
only the Hamming distance between tuples. For numerical values, one might of course take
the difference between values into account. More generally, one could consider a metric on
the domain, which then induces a metric on tuples that can be used as a distance measure.
As far as the aggregator is concerned, we note that most of our upper bounds apply to
arbitrary (polynomial-time computable) aggregate functions. On the other hand, our lower
bounds hold for any (polynomial-time computable) ws-monotone aggregate functions. This
seems quite a natural choice as almost all natural aggregators in this setting – including sum
and min – are ws-monotone. A problem strongly related to Diversity is Similarity [EEEF13],
where one is interested in finding solutions close to each other. Parts of our approach can
naturally be adapted to this setting but we leave the in-depth study of Similarity for future
work.
References
[ACJR19]
Marcelo Arenas, Luis Alberto Croquevielle, Rajesh Jayaram, and Cristian Riveros. Efficient
logspace classes for enumeration, counting, and uniform generation. In Dan Suciu, Sebastian
Skritek, and Christoph Koch, editors, PODS 2019, pages 59–73. ACM, 2019. doi:10.1145/
3294052.3319704.
[AGG07]
Isolde Adler, Georg Gottlob, and Martin Grohe. Hypertree width and related hypergraph
invariants. Eur. J. Comb., 28(8):2167–2181, 2007. doi:10.1016/J.EJC.2007.04.013.
[AHV95]
Serge Abiteboul, Richard Hull, and Victor Vianu. Foundations of Databases. Addison-Wesley,
1995.
[AJMR22]
Antoine Amarilli, Louis Jachiet, Martin Mu˜noz, and Cristian Riveros. Efficient enumeration for
annotated grammars. In Leonid Libkin and Pablo Barcel´o, editors, PODS 2022, pages 291–300.
ACM, 2022. doi:10.1145/3517804.3526232.
[AK97]
Paola Alimonti and Viggo Kann. Hardness of approximating problems on cubic graphs. In
Gian Carlo Bongiovanni, Daniel P. Bovet, and Giuseppe Di Battista, editors, CIAC 1997, pages
288–298. Springer, 1997. doi:10.1007/3-540-62592-5\_80.
[BFJ+22]
Julien Baste, Michael R. Fellows, Lars Jaffke, Tom´as Masar´ık, Mateus de Oliveira Oliveira,
Geevarghese Philip, and Frances A. Rosamond. Diversity of solutions: An exploration through
the lens of fixed-parameter tractability theory. Artif. Intell., 303:103644, 2022. doi:10.1016/j.
artint.2021.103644.
[BKPS19]
Endre Boros, Benny Kimelfeld, Reinhard Pichler, and Nicole Schweikardt. Enumeration in
data management (dagstuhl seminar 19211). Dagstuhl Reports, 9(5):89–109, 2019. doi:10.4230/
DagRep.9.5.89.
[BMT20]
Angela Bonifati, Wim Martens, and Thomas Timm. An analytical study of large SPARQL query
logs. VLDB J., 29(2-3):655–679, 2020. doi:10.1007/s00778-019-00558-9.
[Bod96]
Hans L. Bodlaender. A linear-time algorithm for finding tree-decompositions of small treewidth.
SIAM J. Comput., 25(6):1305–1317, 1996. doi:10.1137/S0097539793251219.

---

9:34
T. Merkl, R. Pichler, and S. Skritek
Vol. 21:1
[Bra12]
Johann Brault-Baron. A negative conjunctive query is easy if and only if it is beta-acyclic. In
Patrick C´egielski and Arnaud Durand, editors, CSL 2012, pages 137–151. Schloss Dagstuhl -
Leibniz-Zentrum f¨ur Informatik, 2012. doi:10.4230/LIPIcs.CSL.2012.137.
[CC06]
Miroslav Chleb´ık and Janka Chleb´ıkov´a. Hard coloring problems in low degree planar bipartite
graphs. Discret. Appl. Math., 154(14):1960–1965, 2006. doi:10.1016/j.dam.2006.03.014.
[CI24]
Florent Capelli and Oliver Irwin. Direct access for conjunctive queries with negations. In Graham
Cormode and Michael Shekelyan, editors, ICDT 2024, pages 13:1–13:20. Schloss Dagstuhl -
Leibniz-Zentrum f¨ur Informatik, 2024. doi:10.4230/LIPICS.ICDT.2024.13.
[CM77]
Ashok K. Chandra and Philip M. Merlin. Optimal implementation of conjunctive queries in
relational data bases. In John E. Hopcroft, Emily P. Friedman, and Michael A. Harrison, editors,
STOC 1977, pages 77–90. ACM, 1977. doi:10.1145/800105.803397.
[CM99]
Surajit Chaudhuri and Rajeev Motwani. On sampling and relational operators. IEEE Data Eng.
Bull., 22(4):41–46, 1999.
[CS23]
Nofar Carmeli and Luc Segoufin. Conjunctive queries with self-joins, towards a fine-grained
enumeration complexity analysis. In Floris Geerts, Hung Q. Ngo, and Stavros Sintos, editors,
PODS 2023, pages 277–289. ACM, 2023. doi:10.1145/3584372.3588667.
[CZB+22]
Nofar Carmeli, Shai Zeevi, Christoph Berkholz, Alessio Conte, Benny Kimelfeld, and Nicole
Schweikardt. Answering (unions of) conjunctive queries using random access and random-order
enumeration. ACM Trans. Database Syst., 47(3):9:1–9:49, 2022. doi:10.1145/3531055.
[DF99]
Rodney G. Downey and Michael R. Fellows. Parameterized Complexity. Monographs in Computer
Science. Springer, 1999. doi:10.1007/978-1-4612-0515-9.
[DF14]
Ting Deng and Wenfei Fan. On the complexity of query result diversification. ACM Trans.
Database Syst., 39(2):15:1–15:46, 2014. doi:10.1145/2602136.
[DST23]
Shiyuan Deng, Francesco Silvestri, and Yufei Tao. Enumerating subgraphs of constant sizes in
external memory. In Floris Geerts and Brecht Vandevoort, editors, ICDT 2023, pages 4:1–4:20.
Schloss Dagstuhl - Leibniz-Zentrum f¨ur Informatik, 2023. doi:10.4230/LIPICS.ICDT.2023.4.
[EEEF13]
Thomas Eiter, Esra Erdem, Halit Erdogan, and Michael Fink. Finding similar/diverse solutions
in answer set programming. Theory Pract. Log. Program., 13(3):303–359, 2013. doi:10.1017/
S1471068411000548.
[FGLP21]
Wolfgang Fischl, Georg Gottlob, Davide Mario Longo, and Reinhard Pichler. Hyperbench:
A benchmark and tool for hypergraphs and empirical findings. ACM J. Exp. Algorithmics,
26:1.6:1–1.6:40, 2021. doi:10.1145/3440015.
[FGS18]
Henning Fernau, Petr A. Golovach, and Marie-France Sagot. Algorithmic enumeration: Output-
sensitive, input-sensitive, parameterized, approximative (dagstuhl seminar 18421). Dagstuhl
Reports, 8(10):63–86, 2018. doi:10.4230/DagRep.8.10.63.
[GLS02]
Georg Gottlob, Nicola Leone, and Francesco Scarcello. Hypertree decompositions and tractable
queries. J. Comput. Syst. Sci., 64(3):579–627, 2002. doi:10.1006/jcss.2001.1809.
[GM14]
Martin Grohe and D´aniel Marx. Constraint solving via fractional edge covers. ACM Trans.
Algorithms, 11(1):4:1–4:20, 2014. doi:10.1145/2636918.
[Gra79]
Marc H. Graham. On The Universal Relation. Technical report, University of Toronto, 1979.
[HHOW05] Emmanuel Hebrard, Brahim Hnich, Barry O’Sullivan, and Toby Walsh. Finding diverse and
similar solutions in constraint programming. In Manuela M. Veloso and Subbarao Kambhampati,
editors, AAAI 2005, pages 372–377. AAAI Press / The MIT Press, 2005.
[IdlBST20] Linnea Ingmar, Maria Garcia de la Banda, Peter J. Stuckey, and Guido Tack. Modelling diversity
of solutions. In AAAI 2020, pages 1528–1535. AAAI Press, 2020.
[JPY88]
David S. Johnson, Christos H. Papadimitriou, and Mihalis Yannakakis. On generating all maximal
independent sets. Inf. Process. Lett., 27(3):119–123, 1988. doi:10.1016/0020-0190(88)90065-8.
[KKW22]
Yasuaki Kobayashi, Kazuhiro Kurita, and Kunihiro Wasa. Linear-delay enumeration for minimal
steiner problems. In Leonid Libkin and Pablo Barcel´o, editors, PODS 2022, pages 301–313. ACM,
2022. doi:10.1145/3517804.3524148.
[Klo94]
Ton Kloks. Treewidth, Computations and Approximations, volume 842 of Lecture Notes in
Computer Science. Springer, 1994. doi:10.1007/BFb0045375.
[Lan23]
Matthias Lanzinger. Tractability beyond β-acyclicity for conjunctive queries with negation and
SAT. Theor. Comput. Sci., 942:276–296, 2023. doi:10.1016/J.TCS.2022.12.002.

---

Vol. 21:1
DIVERSITY OF ANSWERS TO CONJUNCTIVE QUERIES
9:35
[LP22]
Carsten Lutz and Marcin Przybylko. Efficiently enumerating answers to ontology-mediated
queries. In Leonid Libkin and Pablo Barcel´o, editors, PODS 2022, pages 277–289. ACM, 2022.
doi:10.1145/3517804.3524166.
[LRG+17]
Viktor Leis, Bernhard Radke, Andrey Gubichev, Alfons Kemper, and Thomas Neumann. Cardi-
nality estimation done right: Index-based join sampling. In CIDR, 2017.
[LWYZ19]
Feifei Li, Bin Wu, Ke Yi, and Zhuoyue Zhao. Wander join and XDB: online aggregation via
random walks. ACM Trans. Database Syst., 44(1):2:1–2:41, 2019. doi:10.1145/3284551.
[Mar13]
D´aniel Marx. Tractable hypergraph properties for constraint satisfaction and conjunctive queries.
J. ACM, 60(6):42:1–42:51, 2013. doi:10.1145/2535926.
[MPS23]
Timo Camillo Merkl, Reinhard Pichler, and Sebastian Skritek. Diversity of answers to conjunctive
queries. In Floris Geerts and Brecht Vandevoort, editors, ICDT 2023, pages 10:1–10:19. Schloss
Dagstuhl - Leibniz-Zentrum f¨ur Informatik, 2023.
[MR23]
Martin Mu˜noz and Cristian Riveros. Constant-delay enumeration for slp-compressed documents.
In Floris Geerts and Brecht Vandevoort, editors, ICDT 2023, pages 7:1–7:17. Schloss Dagstuhl -
Leibniz-Zentrum f¨ur Informatik, 2023. doi:10.4230/LIPICS.ICDT.2023.7.
[Nad11]
Alexander Nadel. Generating diverse solutions in SAT. In Karem A. Sakallah and Laurent Simon,
editors, SAT 2011, pages 287–301. Springer, 2011. doi:10.1007/978-3-642-21581-0\_23.
[NNRR14]
Hung Q. Ngo, Dung T. Nguyen, Christopher R´e, and Atri Rudra. Beyond worst-case analysis for
joins with minesweeper. In Richard Hull and Martin Grohe, editors, PODS 2014, pages 234–245.
ACM, 2014. doi:10.1145/2594538.2594547.
[Pap94]
Christos H. Papadimitriou. Computational complexity. Addison-Wesley, 1994.
[PT15]
Thierry Petit and Andrew C. Trapp. Finding diverse solutions of high quality to constraint
optimization problems. In Qiang Yang and Michael J. Wooldridge, editors, IJCAI 2015, pages
260–267. AAAI Press, 2015.
[RS84]
Neil Robertson and Paul D. Seymour. Graph minors. III. planar tree-width. J. Comb. Theory,
Ser. B, 36(1):49–64, 1984. doi:10.1016/0095-8956(84)90013-3.
[Var82]
Moshe Y. Vardi. The complexity of relational query languages (extended abstract). In Harry R.
Lewis, Barbara B. Simons, Walter A. Burkhard, and Lawrence H. Landweber, editors, STOC
1982, pages 137–146. ACM, 1982. doi:10.1145/800070.802186.
[Yan81]
Mihalis Yannakakis. Algorithms for acyclic database schemes. In VLDB 1981, pages 82–94. IEEE
Computer Society, 1981.
[YO79]
C. T. Yu and M. Z. ¨Ozsoyoglu. An algorithm for tree-query membership of a distributed query.
In COMPSAC 1979, pages 306–312, 1979.
[ZCL+18]
Zhuoyue Zhao, Robert Christensen, Feifei Li, Xiao Hu, and Ke Yi. Random sampling over joins
revisited. In SIGMOD Conference 2018, pages 1525–1539. ACM, 2018. doi:10.1145/3183713.
3183739.
[ZWQ+17] Kaiping Zheng, Hongzhi Wang, Zhixin Qi, Jianzhong Li, and Hong Gao. A survey of query result
diversification. Knowl. Inf. Syst., 51(1):1–36, 2017. doi:10.1007/s10115-016-0990-4.
This work is licensed under the Creative Commons Attribution License. To view a copy of this
license, visit https://creativecommons.org/licenses/by/4.0/ or send a letter to Creative
Commons, 171 Second St, Suite 300, San Francisco, CA 94105, USA, or Eisenacher Strasse 2,
10777 Berlin, Germany

---

