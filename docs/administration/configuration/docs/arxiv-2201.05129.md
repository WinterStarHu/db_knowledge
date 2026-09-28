# Rewriting with Acyclic Queries: Mind Your Head

> 来源: https://arxiv.org/pdf/2201.05129

Logical Methods in Computer Science
Volume 19, Issue 4, 2023, pp. 17:1–17:35
https://lmcs.episciences.org/
Submitted
Oct. 18, 2022
Published
Nov. 29, 2023
REWRITING WITH ACYCLIC QUERIES: MIND YOUR HEAD
GAETANO GECK
, JENS KEPPELER, THOMAS SCHWENTICK
, AND CHRISTOPHER SPINRATH
TU Dortmund University, Germany
e-mail address: {gaetano.geck, jens.keppeler, thomas.schwentick, christopher.spinrath}@tu-dortmund.de
Abstract. The paper studies the rewriting problem, that is, the decision problem whether,
for a given conjunctive query Q and a set V of views, there is a conjunctive query Q′ over V
that is equivalent to Q, for cases where the query, the views, and/or the desired rewriting
are acyclic or even more restricted.
It shows that, if Q itself is acyclic, an acyclic rewriting exists if there is any rewriting.
An analogous statement also holds for free-connex acyclic, hierarchical, and q-hierarchical
queries.
Regarding the complexity of the rewriting problem, the paper identifies a border between
tractable and (presumably) intractable variants of the rewriting problem: for schemas of
bounded arity, the acyclic rewriting problem is NP-hard, even if both Q and the views
in V are acyclic or hierarchical. However, it becomes tractable if the views are free-connex
acyclic (i.e., in a nutshell, their body is (i) acyclic and (ii) remains acyclic if their head is
added as an additional atom).
1. Introduction
The query rewriting problem asks, for a query Q and a set V of views, whether there is a
query Q′ over V that is equivalent to Q, and to find such a rewriting Q′.
We emphasise that in the literature, various notions of rewriting are studied and that
the one above is sometimes called exact [CGLV05] or equivalent [AC19]. Since we are in
this paper exclusively interested in exact rewritings, we use the term rewriting in the sense
stated above.
Over the last decades, query rewriting has been studied in a wide range of settings with
varying database models (relational, XML, graph, . . . ), query languages, semantics (set, bag,
. . . ) and more. A particular well-known setting is formed by conjunctive queries (CQ) under
set semantics, which captures some core aspects of SQL queries. This is also the setting
studied in this paper. We refer to [AC19, CY12, Hal01] for an overview of the extensive
literature.
In this paper we are interested in a modified version of the query rewriting problem
which does not merely ask for any rewriting but rather for rewritings that are structurally
Key words and phrases: rewriting, acyclic rewriting, acyclic conjunctive queries, free-connex queries,
hierarchical queries, NP-hardness.
An abridged conference version of this paper without full proofs and with less detailed explanations
has been published in the proceedings of the 25th International Conference on Database Theory [GKSS22].
Besides Lemma 3.7, the results in this version and the conference version are identical.
LOGICAL METHODSl IN COMPUTER SCIENCE
DOI:10.46298/LMCS-19(4:17)2023
©
G. Geck, J. Keppeler, T. Schwentick, and C. Spinrath
CC
⃝
Creative Commons

---

17:2
G. Geck, J. Keppeler, T. Schwentick, and C. Spinrath
Vol. 19:4
simple and allow for efficient evaluation. This is relevant in a setting where access to the
database is only possible through the views, in which case the use of an efficient rewriting is
obvious. It can also be interesting in a scenario where multiple queries have to be evaluated:
by evaluating some of the queries and considering their results as views, some other queries
might be rewritable into acyclic queries over the database extended by these views, and
therefore they could possibly be evaluated more efficiently.
The forms of structural simplicity that we consider in this paper are acyclic (ACQ) and
hierarchical queries (HCQ), and their slightly stronger versions free-connex acyclic (CCQ)
and q-hierarchical queries (QHCQ). For a brief discussion of the origin and applications of
these classes, we refer to Section 8.
We are interested in two kinds of questions.
(1) Under which circumstances is it guaranteed that a structurally simple rewriting exists,
if there exists a rewriting at all?
(2) What is the complexity to decide whether such a rewriting exists and to compute one?
We study these questions depending on the structure of the given views and the given query
and we consider the same simplicity notions.
In particular, we study the decision problem Rewr(V, Q, R) that asks whether for a
given set of views from V and a query from Q, there is a rewriting from R, for various classes
V, Q and R, with an emphasis on the case where R is ACQ or a subclass. In the following
we refer to this case as the acyclic rewriting problem. To the best of our knowledge, there
has been no previous work dedicated to the study of questions (1) and (2).
The answer to Question (1) turns out to be very simple and also quite encouraging:
in the case that Q = ACQ, whenever a rewriting exists, there is also an acyclic rewriting.
And the same is true for the three subclasses of ACQ. That is, for every query in CCQ,
HCQ, or QHCQ, whenever a rewriting exists, there is also a rewriting in CCQ, HCQ, or
QHCQ, respectively. Thus, in these cases a rewriting with efficient evaluation exists, if
there is a rewriting at all. This answer to Question (1) simplifies the study of Question (2),
since it implies that for Q ∈{ACQ, CCQ, HCQ, QHCQ} and V ⊆CQ the decision problems
Rewr(V, Q, CQ) and Rewr(V, Q, Q)—and, thus, their complexities—coincide.
The study of Question (2) reveals that the complexity of the acyclic rewriting problem
may depend on two parameters: the arity of the underlying schema and the arity of the
views. We denote the restriction of Rewr(V, Q, R) to database schemas of arity at most k
by Rewrk(V, Q, R), and we indicate by Vk if the arity of views is at most k.
Our main findings regarding the complexity of the acyclic rewriting problem are as
follows (see Table 1 for an overview).
• If the query and the views are acyclic and the arity of the views is bounded by some fixed
k, then the acyclic rewriting problem is tractable, that is, for every k the decision problem
Rewr(ACQk, ACQ, ACQ) is in polynomial time (Corollary 5.5). Furthermore, an acyclic
rewriting can be computed in polynomial time (if it exists). This follows easily with the
help of the canonical rewriting approach (see [NSV10, Proposition 5.1]) and our answer
to Question (1).
• If the query and the views are acyclic and the arity of the views can be unbounded, then
the acyclic rewriting problem is intractable, even if the database schema has bounded
arity, more precisely: Rewr3(ACQ, ACQ, ACQ) is NP-complete (Theorem 5.7).

---

Vol. 19:4
REWRITING WITH ACYCLIC QUERIES: MIND YOUR HEAD
17:3
Table 1. Complexity results for the (acyclic) rewriting problem. Note that
QHCQ ⊆CCQ ⊆ACQ and QHCQ ⊆HCQ ⊆ACQ hold. The head arity of a
view V is the arity of its head atom head(V ). The weak head arity of a view
is defined in Definition 6.3. In a nutshell, a view with weak head arity ℓcan
be “split” into (multiple) views with head arity at most ℓ.
V
Views
Q
Query
R
Rewriting
Restriction
of views
Rewrk(V, Q, R) for every k ∈N
(bounded arity db-schema)
Rewr(V, Q, R)
(unbounded arity db-schema)
CQ
ACQ
CQ
Boolean views
NP-complete for k ≥3 (Proposition 3.11)
ACQ
CQ
CQ
Boolean views
NP-complete for k ≥3 (Proposition 3.11)
ACQ
ACQ
ACQ
no restriction
NP-complete for k ≥3 (Theorem 5.7)
ACQ
ACQ
ACQ
head arity ≤ℓ
ℓ∈N
in polynomial time (Corollary 5.5)
ACQ
ACQ
ACQ
weak head arity ≤ℓ
ℓ∈N
in polynomial time (Theorem 6.9)
CCQ
ACQ
ACQ
no restriction
in polynomial time (Theorem 6.2)
open
HCQ
HCQ
HCQ
no restriction
NP-complete for k ≥3 (Corollary 7.5)
QHCQ
HCQ
HCQ
no restriction
in polynomial time (Corollary 7.4)
open
QHCQ
QHCQ
QHCQ
no restriction
in polynomial time (Corollary 7.4)
open
• If the query is acyclic, the views are free-connex acyclic, and the arity of the database
schema is bounded by some fixed k, then the acyclic rewriting problem is tractable, that
is, for every k: Rewrk(CCQ, ACQ, ACQ) is in polynomial time (Theorem 6.2).
Many results use a characterisation of rewritability, based on the notion of cover
partitions, that might be interesting in its own right. Similar notions have been used in
earlier work, but ours is particularly suited for the study of exact (equivalent) rewritings.
Our paper is organised as follows: we introduce general basic notions in Section 2
and notions and observations related to rewritings in Section 3. The characterisation of
rewritability in terms of cover partitions is given in Section 4. The answer to Question (1) and
the complexity of the acyclic rewriting problem for acyclic queries and views are studied in
Section 5. The feasibility for free-connex acyclic views (and an additional class) is presented
in Section 6. Section 7 shows that the answer to Question (1) is the same for hierarchical
and q-hierarchical queries and views. Section 8 discusses related work and, in particular, the
relationship of our characterisation of rewritability with results in the literature. Section 9
concludes.
2. Preliminaries
In this section, we fix some notation and recall the basic concepts from relational databases
that are relevant for this paper. Let N0 denote the set of non-negative integers. Let dom
and var be countably infinite sets of data values (also called constants) and variables,
respectively. We use the natural extensions of mappings of variables onto tuples and sets
without notational distinction. That is, for a mapping f : X →Y , we write f(X′) for {f(x) |

---

17:4
G. Geck, J. Keppeler, T. Schwentick, and C. Spinrath
Vol. 19:4
x ∈X′} and f(x) for (f(x1), . . . , f(xk)) for sets X′ ⊆X and tuples x = (x1, . . . , xk) ∈Xk,
respectively. The composition f ◦g of two functions g: X →Y and f : Y →Z is the function
(f ◦g): X →Z defined by (f ◦g)(x) = f(g(x)) for all x ∈X. By id we denote the identity
mapping (on any set of variables).
Databases. Databases and queries are formulated over database schemas. A database
schema S is a finite set of relation schemas, each represented by a symbol R and associated
with a fixed arity ar(R) ∈N0.1 A fact or R-fact R(a1, . . . , ar) comprises a relation symbol R
with some arity r and data values a1, . . . , ar. A database D over schema S is a finite set of
R-facts for R ∈S.
Queries. In general, queries map databases to relations. In this paper, we consider conjunc-
tive queries and restrictions of them. Conjunctive queries are queries that can be expressed
syntactically as conjunctions of relation atoms as follows.
An atom is of the form R(x1, . . . , xr) with a relation symbol R with arity r, and variable
set {x1, . . . , xr}. We denote the variable set of an atom A by vars(A). Analogously to facts,
an atom with relation symbol R is called an R-atom if we want to stress the associated
relation (symbol). More generally, S-atoms are R-atoms for some symbol R in schema S.
We represent a conjunctive query (CQ for short) over schema S as a rule of the form
A ←A1, . . . , Am whose body {A1, . . . , Am} consists of a positive number of atoms and whose
head is a single atom A such that the following two conditions are satisfied. First, atoms
A1, . . . , Am refer to relation symbols from S and atom A, on the contrary, does not. Second,
the query is safe, that is, every variable in the head occurs in at least one atom of the body.
Let head(Q) and body(Q) denote the head and body of a query Q, respectively. Variables
that occur in the head of a query are called head variables; all other variables are called
quantified variables. A query without quantified variables is called a full query. Queries
with two or more body atoms that refer to the same relation are said to have self-joins. The
arity of a query Q is the arity of its head atom. Furthermore, a query Q is a Boolean query
if the arity of head(Q) is 0.
Like for sets and tuples, we also use the natural extension of mappings of variables
on atoms without difference in notation: for a mapping f : var →Y , let f(A) denote
R(f(x1), . . . , f(xr)) for an atom A = R(x1, . . . , xr).
A valuation is a mapping ϑ : var ⇀dom. A database D satisfies a set A of atoms
under a valuation ϑ, if ϑ(A) ⊆D, that is for every atom R(x1, . . . , xr) in A the fact
R(ϑ(x1), . . . , ϑ(xr)) is contained in D. The result of query Q on database D is defined as
Q(D) = {ϑ(head(Q)) | ϑ is a valuation and D satisfies body(Q) under ϑ}.
Relationships between queries. Queries over the same schema can be compared with
respect to the results they define. Let Q1 and Q2 be queries. We say that Q1 is contained
in Q2 (notation: Q1 ⊑Q2) if Q1(D) ⊆Q2(D) for every database D. We say that Q1 and Q2
are equivalent (notation: Q1 ≡Q2) if Q1 ⊑Q2 and Q2 ⊑Q1.
It is well-known that a conjunctive query Q1 is contained in a conjunctive query Q2 if
and only if there is a homomorphism from the latter query into the first [CM77]. Such a
homomorphism is a mapping h: vars(Q2) →vars(Q1) such that
(1) h(body(Q2)) ⊆body(Q1) and
1We refer to database schemas usually by schema.

---

Vol. 19:4
REWRITING WITH ACYCLIC QUERIES: MIND YOUR HEAD
17:5
(2) h(head(Q2)) = head(Q1) hold.
We call h a body homomorphism if it fulfils Condition (1).
A conjunctive query Q1 is minimal if there is no conjunctive query Q2 such that Q2 ≡Q1
and |body(Q2)| < |body(Q1)| holds.
Structurally simple queries. Despite their simplicity and restricted expressibility, several
interesting problems are intractable for conjunctive queries in general. Therefore, different
fragments have been studied in the literature. In this paper, we are particularly concerned
with “acyclic” queries, which allow, for instance, evaluation in polynomial time. We also
consider three subclasses of acyclic queries, namely, free-connex acyclic, hierarchical, and
q-hierarchical queries.
Acyclic and free-connex acyclic queries. A join tree for a query Q is a tree whose
vertices are the atoms in the query’s body that satisfies the following path property: for
two atoms A, A′ ∈body(Q) with a common variable x, all atoms on the path from A to A′
contain x. A query Q is acyclic if it has a join tree. It is free-connex acyclic if Q is acyclic and
the Boolean query whose body is body(Q) ∪{head(Q)} is acyclic as well [BDG07, BB13].
Hierarchical queries. For a fixed query Q and some variable x in Q, let atoms(x) denote
the set of atoms in body(Q) in which x appears.
Definition 2.1 [DS07], [BKS17, Definition 3.1]. A conjunctive query Q is hierarchical if,
for all variables x, y in Q, one of the following conditions is satisfied.
(1) atoms(x) ⊆atoms(y)
(2) atoms(x) ⊇atoms(y)
(3) atoms(x) ∩atoms(y) = ∅
Thus, the “hierarchy” is established by the query’s variables and the sets of atoms that
contain them.
A conjunctive query Q is q-hierarchical if it is hierarchical and for all variables x, y ∈
vars(Q) the following is satisfied: if atoms(x) ⊊atoms(y) holds and x is in the head of Q,
then y is also in the head of Q.
For brevity, we denote by CQ, ACQ, CCQ, HCQ, and QHCQ the classes of conjunctive
queries in general and those conjunctive queries that are acyclic, free-connex acyclic, hierar-
chical or q-hierarchical, respectively. We note that each q-hierarchical query is free-connex
acyclic [IUV17, Proposition 4.25] and each hierarchical query is acyclic.2
Views and rewritings. A view V over a schema S is just a query over schema S.3 A
set V = {V1, . . . , Vk} of views induces, for each database D over schema S, the V-defined
database V(D) = V1(D) ∪· · · ∪Vk(D).
In this paper, we consider only views that are conjunctive queries. We furthermore
assume that every view defines its own relation in the derived database. We denote the set
of relation schemas induced by the heads of the views in V by SV.
2The latter inclusion is mentioned in, e.g. [HY19, KNOZ20]; it also follows readily from the former
inclusion. For acyclicity the head of a query is of no concern, and the Boolean variant of a hierarchical query
is always q-hierarchical by definition, and, thus, free-connex acyclic which implies the existence of a join tree
for the body of the original query.
3They are called views due to their special role which distinguishes them from “normal” queries.

---

17:6
G. Geck, J. Keppeler, T. Schwentick, and C. Spinrath
Vol. 19:4
In a nutshell, a rewriting of a query Q over a set V of views is a query over SV that is
meant to yield, for each database D, the same result over V(D) as Q does over D.
Definition 2.2. Let Q be a query, V a set of views, and Q′ a query over SV. We call Q′ a
V-rewriting of Q if, for every database D, it holds that Q′(V(D)) = Q(D).
Formally, we only consider rewritings over SV. This is not a restriction, since database
relations can be replicated as view relations. In the literature, rewritings often only aim
at approximations of the query [PH01]. However, in this paper, we are only interested in
equivalent and complete rewritings, where Q′ ◦V ≡Q holds. Here Q′ ◦V denotes the query
with query result Q′(V(D)) for every database D.
We illustrate the above definitions by an example.
Example 2.3. Let V be a set of two views
V1(x1, w1) ←P(v1, v′
1, x1), R(x1, w1), S(w1),
V2(y2, z2) ←S(y2), T(y2, z2)
over schema S = {P, R, S, T} and let Q be the query
H(x, y, y′) ←P(u, u′, x), R(x, w), S(w), T(w, y), T(w, y′).
For each database D, query Q yields the same result on D as the following query Q′
H(x, y, y′) ←V1(x, w), V2(w, y), V2(w, y′)
on V(D). Therefore, Q′ is a V-rewriting of Q.
3. The Rewriting Problem
In this section, we define the rewriting problem, recall some known results about its
complexity and discuss some relevant concepts that were used to tackle it.
Definition 3.1. Let V, Q, and R be classes of conjunctive queries. The rewriting problem
for V, Q, and R, denoted Rewr(V, Q, R) asks, upon input of a query Q ∈Q and a (finite) set
V ⊆V of views, whether there is a V-rewriting of Q in the class R. We write Rewrk(V, Q, R)
for the restriction, where the arity of the database schema is bounded by k.
In general, the rewriting problem for conjunctive queries is NP-complete.
Theorem 3.2 [LMSS95, Theorem 3.10]. Rewr(CQ, CQ, CQ) is NP-complete.
There is a straightforward, albeit in general inefficient, way of finding a rewriting for a
conjunctive query and views. In fact, it can be shown that, for given Q and V, a rewriting Q′
over V exists, if and only if a certain canonical query canon(Q, V) exists and is a rewriting.
This canonical candidate canon(Q, V) can be obtained by evaluating V on the canonical
database canon(Q), which in turn is defined as the set of body atoms of Q viewed as facts,
in which the variables are considered as fresh constants. The canonical candidate has the
same head as Q and its body is just V(canon(Q)).4 If the canonical candidate turns out to
be a rewriting, then we often call it canonical rewriting.
An important detail should be mentioned here: the canonical candidate does not always
exist, e.g., if V(canon(Q)) does not contain all head variables of Q or it is outright empty.
In that case, there is no rewriting.
4Here the variables are considered as variables, not as constants.

---

Vol. 19:4
REWRITING WITH ACYCLIC QUERIES: MIND YOUR HEAD
17:7
Proposition 3.3 [NSV10, Proposition 5.1]. Let Q be a conjunctive query and V a set of
views. If there is a V-rewriting of Q, then the canonical candidate canon(Q, V) is such a
rewriting.
For conjunctive queries without self-joins this had been shown in [CR00, Lemma 7].
Example 3.4. Let us consider the query Q defined by
H(x, y, z) ←C(x, y, z), R(x, y), S(y, z), T(z, x)
and the views
V1(u1, v1, w1) ←C(u1, v1, w1)
and
V2(x2, y2, z2, u2) ←R(x2, y2), S(y2, z2), T(z2, u2).
Evaluating the views V1 and V2 on the canonical database canon(Q) of Q yields the result
{V1(x, y, z), V2(x, y, z, x)}. Thus, the query Q′ defined by
H(x, y, z) ←V1(x, y, z), V2(x, y, z, x)
is the canonical candidate, which happens to be an actual V-rewriting.
In this example it is easy to see that the canonical candidate is a V-rewriting, without
considering any (let alone all) databases.
In fact, in this particular case, this can be
established with the help of an expansion of the rewriting. Before we define expansions, we
need one more definition.
Definition 3.5 (View Application). An application of a view V is a substitution α: vars(V ) →
var that does not unify any quantified variable of V with another variable of V .
This definition reflects the fact that a rewriting can access a view only through its head
and therefore cannot unify any quantified variables.
We say that a collection α1, . . . , αm of applications for views V1, . . . , Vm fulfils quantified
variable disjointness, if for all i, j ∈{1, . . . , m}, each quantified variable x of Vi, and each
variable y of Vj with i̸ = j, it holds αi(x)̸ = αj(y). That is, beyond what is already required
by the definition of an application, a view application never maps a quantified variable of
a view to a variable in the range of any other view application. This ensures that, for all
i, j ∈{1, . . . , m} with i̸ = j, the bodies αi(body(Vi)) and αj(body(Vj)) only share variables
from vars(αi(head(Vi))) ∩vars(αj(head(Vj))).
An expansion of a V-rewriting Q′ is, intuitively, obtained by inlining the bodies of the
views from V in Q′.
Definition 3.6 (Expansion). Let V be a set of views over a schema S and let Q′ be a query
with body(Q′) = {A′
1, . . . , A′
m} over the schema SV. Furthermore, let, for each i ∈{1, . . . , m},
Vi be the view in V and αi be an application for Vi such that A′
i = αi(head(Vi)), such that
α1, . . . , αm fulfil quantified variable disjointness.
The expansion of Q′ w.r.t. V and α1, . . . , αm is the query that has the same head as Q′
and body Sm
i=1 αi(body(Vi)).
Since the applications α1, . . . , αm in Definition 3.6 are uniquely determined up to
renaming of quantified variables, we usually do not mention them explicitly and just speak
of an expansion of a query Q′ w.r.t. V.
Furthermore, because an expansion Q′′ of a V-rewriting Q′ is, intuitively, obtained by
inlining the bodies of the views, the expansion Q′′ is “equivalent” to Q′ in the following
sense.

---

17:8
G. Geck, J. Keppeler, T. Schwentick, and C. Spinrath
Vol. 19:4
Lemma 3.7. Let V be a set of views, Q′ be a query over the schema SV, and Q′′ be an
expansion of Q′ w.r.t. V. Then Q′′(D) = Q′(V(D)) holds for every database D.
Lemma 3.7 has been proved, e.g., as part of the proof of [AC19, Theorem 3.5]. For the
sake of convenience, we provide a short proof using our notation in the following.
Proof of Lemma 3.7. Following Definition 3.6, let {A′
1, . . . , A′
m} be the body of Q′, and let
α1, . . . , αm be applications fulfilling quantified variable disjointness, and V1, . . . , Vm ∈V views
such that A′
i = αi(head(Vi)) holds for all i ∈{1, . . . , m} and body(Q′′) = Sm
i=1 αi(body(Vi))
holds.
We first show the inclusion Q′′(D) ⊆Q′(V(D)). Let D be a database and ϑ be a
valuation such that D satisfies ϑ(body(Q′′)) = ϑ(Sm
i=1 αi(body(Vi))) under ϑ.
By the
definition of an expansion, ϑ(head(Q′′)) = ϑ(head(Q′)) holds. Thus, it suffices to show that
ϑ(body(Q′)) ⊆V(D) holds witnessing that ϑ(head(Q′)) ∈Q′(V(D)).
Since ϑ(body(Q′′) ⊆D, it holds ϑ(αi(body(Vi))) ⊆D, for all i ∈{1, . . . , m}. Interpret-
ing ϑ ◦αi as a valuation, it follows that ϑ(αi(head(Vi))) ∈Vi(D). But αi(head(Vi)) = A′
i for
all i ∈{1, . . . , m} and, therefore, we can conclude that ϑ(body(Q′)) = ϑ({A′
1, . . . , A′
m}) ⊆
V(D).
For the inclusion Q′′(D) ⊇Q′(V(D)) let ϑ be a valuation such that V(D) satisfies
body(Q′) under ϑ. Thus ϑ(A′
i) ∈V(D) and therefore ϑ(αi(head(Vi))) ∈Vi(D) holds, for all
i ∈{1, . . . , m}. The latter implies that there are valuations µi such that ϑ(αi(head(Vi))) =
µi(head(Vi)) such that µi(body(Vi)) ⊆D. That is, the µi map body(Vi) into D and agree
with ϑ ◦αi on all head variables of Vi. Moreover, since the application αi does not unify any
quantified variables with other variables, the valuation ϑ can be extended to a valuation ϑ+
i
such that ϑ+
i (αi(body(Vi))) ⊆D.
Lastly, thanks to the quantified variable disjointness of the αi, the extended mappings
ϑ+
i can be combined into a valuation ϑ+ which maps all αi(body(Vi)) into D.
We further note that the expansion of a rewriting Q′ can be directly compared with a
query Q since it is over the same schema. In fact, we will frequently use the following result
which follows readily from Lemma 3.7.
Proposition 3.8 [AC19, Theorem 3.5]. Let Q be a query over a schema S, V be a set of
views over S, Q′ be a query over the schema SV, and Q′′ be an expansion of Q′ w.r.t. V.
The expansion Q′′ of Q′ is equivalent to Q if and only if Q′ is a V-rewriting of Q.
In Example 3.4, the query Q′ is a V-rewriting of Q, because the views are full queries,
and, thus, there is only one (unique) expansion of Q′ w.r.t. V which even coincides with Q.
If there is no a priori bound on the arity of views, then the canonical candidate can be
of exponential size in |Q| + |V|. However, if there is a rewriting, then there always is one
of polynomial size. In fact, at most n view applications are needed if the body of query Q
contains n atoms [LMSS95, Lemma 3.5].
Example 3.9. Consider the query H() ←S(x, y), R(x), R(y) and the views
V1(x1, y1) ←S(x1, y1) and V2(x2,1, . . . , x2,n) ←R(x2,1), . . . , R(x2,n).
Evaluating the views on the canonical database canon(Q) yields the result
{V1(x, y)} ∪{V2(a1, . . . , an) | a1, . . . , an ∈{x, y}}.

---

Vol. 19:4
REWRITING WITH ACYCLIC QUERIES: MIND YOUR HEAD
17:9
This result, and thus, the body of the canonical candidate, has exponential size. There is,
however, a simple {V1, V2}-rewriting which has as many view atoms as Q has atoms, namely,
H() ←V1(x, y), V2(x, . . . , x), V2(y, . . . , y).
Therefore, an NP-algorithm for Rewr(CQ, CQ, CQ) can “guess” a rewriting of polyno-
mial size and test whether it yields an expansion that is equivalent to the given query. Since
equivalence of CQ can be tested in NP, this indeed shows that Rewr(CQ, CQ, CQ) is in
NP.
Due to their potentially exponential size, canonical candidates are, in general, not useful
as a starting point for polynomial time algorithms. However, in some cases their size is
only polynomial, in particular, if the views have bounded arity. In such cases, the above
characterisation can sometimes be used to obtain efficient algorithms. In particular, this
holds for acyclic views of bounded arity and acyclic queries. For a class V of views, we write
Vk for the restriction to views of arity at most k.
Proposition 3.10. For every k ≥0, Rewr(ACQk, ACQ, CQ) is in polynomial time.
Proof. We first observe that, if it exists, the canonical candidate always obeys Q ⊑
canon(Q, V) ◦V. Indeed, a homomorphism from an expansion of canon(Q, V) to Q can
be obtained by combining the valuations that yield V(canon(Q)) from canon(Q) as follows.
To improve readability and avoid technical clutter we identify the variables in Q with their
corresponding constants in canon(Q) in the following. Notably, this means that we identify
canon(Q) with body(Q), i.e. we write canon(Q) = body(Q).
Let A′
1, . . . , A′
m be the atoms of canon(Q, V) and, for each i ∈{1, ..., m}, let αi be
an application and Vi be a view such that A′
i = αi(head(Vi)), such that α1, . . . , αm fulfil
quantified variables disjointness. Furthermore, since the A′
i are also contained in V(canon(Q))
by definition of canon(Q, V), there are valuations ϑi such that A′
i = ϑi(head(Vi)) and
ϑi(body(Vi)) ⊆canon(Q) holds. In particular, we have that ϑi(head(Vi)) = αi(head(Vi)) for
all i ∈{1, . . . , m}.
Let y be a variable occuring in αi(body(Vi)) and x such that y = αi(x) for some
i ∈{1, . . . , m}.
Then the desired homomorphism h maps y to ϑi(x).
Note that h is
the identity on variables occuring in αi(head(Vi)) because αi(head(Vi)) = ϑi(head(Vi))
and, thus, y = αi(x) = ϑi(x) = h(y).
Hence, h is well-defined, since, if a variable y
occurs in αi(body(Vi)) and αj(body(Vj)) with i̸ = j then it also occurs in αi(head(Vi)) and
αj(head(Vj)) thanks to quantified variable disjointness.
It is easy to see that h is a homomorphism from the expansion of canon(Q, V) to Q,
because
h(αi(body(Vi))) = ϑi(body(Vi)) ⊆canon(Q)
holds for all i ∈{1, . . . , m} and h is the identity on all variables occuring in the head of
canon(Q, V).
Therefore, to test for rewritability, it suffices to check whether canon(Q, V) ◦V ⊑Q
holds.
Since the views are acyclic and their arity is bounded by a constant, the polynomial-sized
canonical candidate canon(Q, V) can be computed in polynomial time.5 It then suffices to
test whether a homomorphism from Q to an expansion of canon(Q, V) exists. This test can
be done in polynomial time because the query Q is acyclic.
5Evaluating and testing containment for acyclic conjunctive queries is in polynomial time [Yan81, AHV95].

---

17:10
G. Geck, J. Keppeler, T. Schwentick, and C. Spinrath
Vol. 19:4
Thus, overall, it can be tested efficiently whether canon(Q, V) ◦V ⊑Q holds if the query
and views are acyclic and the arity of the views is bounded by a constant.
Hence, the statement follows due to Proposition 3.3.
Chekuri and Rajaraman have shown that the rewriting problem is in P for acyclic
queries without self-joins and arbitrary views using a similar idea [CR00, Theorem 5].
However, even for Boolean views and databases over a small fixed schema, it does not
suffice to restrict only the query or only the views to acyclic queries.
Proposition 3.11. Rewrk(CQ0, ACQ, CQ) and Rewrk(ACQ0, CQ, CQ) are NP-complete,
for every k ≥3. This even holds for Boolean queries, view sets with only one Boolean view
and a schema with two relations of maximum arity 3.
Proof. The upper bound holds thanks to Theorem 3.2. For the lower bound, we first show,
by a reduction from the three-colouring problem, that it is NP-hard to test, for an acyclic
Boolean conjunctive query Q1 and a Boolean conjunctive query Q2, whether Q1 ⊑Q2 holds.6
To this end, let G be an undirected graph without isolated vertices and self-loops (i.e.
edges of the form (v, v)). With each vertex v of G we associate a variable xv. We define
Q2 to be the Boolean conjunctive query with head H() that consists of all atoms E(xv, xw)
such that (v, w) is an edge in G. The Boolean query Q1 is defined by the rule
H() ←E(b, r), E(r, y), E(y, b), E(r, b), E(y, r), E(b, y), C(b, r, y)
where b, r, y are variables representing the colours blue, red, and yellow. Observe that Q1 is
acyclic, because all variables are contained in the “cover-atom” C(b, r, y).
Towards the correctness of the reduction, if Q1 ⊑Q2 holds, there is a homomorphism
h from Q2 to Q1. This homomorphism represents a valid colouring, since two variables
xv and xw cannot be mapped to the same variable in Q1 if there is an edge (v, w) in G.
Conversely, every valid colouring of G gives rise to a homomorphism from Q2 to Q1 and
therefore witnesses Q1 ⊑Q2.
Since it is well-known that Q1 ⊑Q2 if and only if Q1 ≡Q2 ∧Q1, we conclude in the
second step that the equivalence problem for Boolean conjunctive queries Q1, Q2 is NP-hard,
even if Q1 is acyclic.
Finally, we reduce the equivalence problem with acyclic Q1 to the rewriting problem.
Let thus Q1 and Q2 be Boolean conjunctive queries. The input instance (Q1, Q2) for the
equivalence problem is mapped to an input instance for the rewriting problem by assigning
Q1 the role of the query and Q2 the role of (the sole) view.
The canonical rewriting, if it exists, consists only of the single atom Q2(), since Q2 is a
Boolean query. Thus, there is a Q2-rewriting of Q1 if and only if Q1 is equivalent to Q2.
This reduction establishes that Rewr3(CQ0, ACQ, CQ) is NP-hard. For the NP-hardness of
Rewr3(ACQ0, CQ, CQ), the roles of Q1 and Q2 are simply swapped in the last reduction.
By composing the three reductions, the proposition is established.
4. A Characterisation
In this section we give a characterisation of rewritability of a query Q with respect to a
set V of views. It is in terms of a partition of the atoms of body(Q), where each set of the
partition can be matched with a view in a specific way. We refer to such partitions as cover
6We think that this is folklore knowledge but could not find a reference for it.

---

Vol. 19:4
REWRITING WITH ACYCLIC QUERIES: MIND YOUR HEAD
17:11
partitions and the matches as cover descriptions. The characterisation is very similar to
other such characterisations in the literature [GKC06, AC19], in particular to “MiniCon
Descriptions” [PH01]. However, in its specific form and notation it is tailored for our needs
in the subsequent sections. We will discuss the relationship of our characterisation with
others further below in Section 8.
Next we define the notions of cover descriptions and cover partitions. Let Q be a
conjunctive query. For a set A ⊆body(Q) we define bvarsQ(A) as the set of bridge variables
of A, that occur in A as well as in the head of Q or in some atom of Q not in A. More
formally, bvarsQ(A) = vars(A) ∩(vars(head(Q)) ∪vars(body(Q) \ A)).
Example 4.1. Consider the query Q defined by H(x, y, z) ←R(x, u), S(u, y, w), T(y, w, z).
For the set A = {R(x, u), S(u, y, w)} of atoms from the body of Q, we have bvarsQ(A) =
{x, y, w} because x and y are head variables of Q and because w, and also y, occurs in the
atom T(y, w, z) that does not belong to A. The variable u in A is not a bridge variable
since it is quantified and does not occur in any atom outside of A.
Definition 4.2 (Cover Description). A cover description C for a query Q is a tuple
(A, V, α, ψ) where
• A is a subset of body(Q),
• V is a view,
• α is an application of V , and
• ψ is a mapping from vars(α(V )) to vars(Q),
such that
(1) A ⊆α(body(V )),
(2) bvarsQ(A) ⊆α(vars(head(V ))),
(3) ψ is a body homomorphism from α(V ) to Q, and
(4) ψ is the identity on vars(A).
Intuitively, the conditions of Definition 4.2 testify that the atoms of Q in A can be
“represented” or “covered” by a V -atom in a rewriting of Q—giving rise to the term
cover description: Condition (1) means that every atom in A has a matching atom in V .
Condition (3) ensures that every database which satisfies the query also satisfies the view
(under application α). Conditions (2) and (4) establish an “interface” to combine multiple
cover descriptions in a straightforward and compatible manner such that, overall, a rewriting
is described.
Example 4.3. Consider the query Q given by the rule
H(x, y, z) ←R(x, y, z), T(x, v), F(v), E(w), S(w, z)
and the following views.
V1(x1, y1, w1) ←R(x1, y1, u1), T(x1, v1), F(v1), E(w1), S(w1, u1)
V2(x2, y2, z2) ←R(x2, y2, z2), F(v2)
V3(w3, z3) ←S(w3, z3), E(w3)
The tuple C1 = (A1, V1, α1, ψ1) with A1 = {T(x, v), F(v)},
α1 = {x1 7→x, y1 7→y′, u1 7→u′, v1 7→v, w1 7→w′}, and
ψ1 = {x 7→x, y′ 7→y, u′ 7→z, v 7→v, w′ 7→w}

---

17:12
G. Geck, J. Keppeler, T. Schwentick, and C. Spinrath
Vol. 19:4
is a cover description for Q with bvarsQ(A1) = {x}. Although ψ1 could be chosen as id (by
adapting α1 accordingly), we will see in Example 4.5, that this is not always desirable.
Now we can simply characterise rewritability of a query Q by the existence of a partition
of body(Q) whose subsets have cover descriptions with views from V.
Definition 4.4. Let Q be a query and V be a set of views. A collection C = C1, . . . , Cm of
cover descriptions Ci = (Ai, Vi, αi, ψi) for Q with Vi ∈V is a cover partition for Q over V if
the sets A1, . . . , Am constitute a partition of body(Q).
We call a cover partition consistent if variables of any αj(Vj) are in the range of any other
αi only if they also appear in bvarsQ(Aj). We note that, since each αi is a view application,
in a consistent cover partition, the applications obey quantified variable disjointness.7
Example 4.5 (Continuation of Example 4.3). Let C1 = (A1, V1, α1, ψ1) be the cover
description defined in Example 4.3. In addition, we consider the cover descriptions C2 and
C3 with Ci = (Ai, Vi, αi, ψi) for i ∈{2, 3} where
A2 = {R(x, y, z)},
A3 = {E(w), S(w, z)},
α2 = {x2 7→x, y2 7→y, z2 7→z, v2 7→v},
α3 = {w3 7→w, z3 7→z},
and ψ2 = ψ3 = id. The cover descriptions C1, C2, C3 constitute a cover partition for Q over
{V1, V2, V3}. It is, however, not consistent, since v is in the range of α1 and α2, but not in
bvars(A1). Replacing α2 and ψ2 by mappings ˆα2 and ˆψ2 with ˆα2(v2) = ˆv and ˆψ2(ˆv) = v
that agree with α2 and ψ2 on all other variables, respectively, yields a consistent cover
partition. Note that there is no consistent cover partition with a cover description of the
form (A1, V1, α′
1, id) because necessarily α′
1(w1) = w would hold and thus w would be in the
range of α′
1 and α3.
A consistent cover partition C induces a query QC and an expansion Q′
C as follows. We
note first that each variable in head(Q) occurs in at least one of the sets Ai and thus in
some set bvarsQ(Ai). Therefore, Condition (2) of Definition 4.2 guarantees that each head
variable of Q occurs in some set αi(head(Vi)) and thus a cover partition C = C1, . . . , Cm
with Ci = (Ai, Vi, αi, ψi) induces a query QC with
head(QC) = head(Q) and body(QC) = {αi(head(Vi)) | 1 ≤i ≤m}.
Likewise, and thanks to quantified variable disjointness, it induces an expansion Q′
C with
head(Q′
C) = head(Q) and body(Q′
C) = {αi(body(Vi)) | 1 ≤i ≤m}.
Next, we show that the existence of a cover partition indeed characterises rewritability.
Theorem 4.6. Let Q be a minimal conjunctive query and V be a set of views. The following
three statements are equivalent.
(a) Q is V-rewritable.
(b) There is a cover partition C for Q over V.
(c) There is a consistent cover partition C for Q over V.
7For the sake of contradiction, assume a quantified variable x and a variable y are mapped to the same
variable z by two different view applications αi and αj, respectively. Then, due to consistency, z is in
bvars(Ai) and, thus, in αi(head(Vi)) due to Definition 4.2(2). It follows that αi unifies x with a head variable.
But this is a contradiction to αi being a view application.

---

Vol. 19:4
REWRITING WITH ACYCLIC QUERIES: MIND YOUR HEAD
17:13
If C is a consistent cover partition, then QC is a V-rewriting of Q. If C is a cover partition,
then there is a consistent cover partition with the same partition of body(Q) as C.
Proof. We first show that (c) implies (a). To this end, let C = C1, . . . , Cm be a consistent
cover partition for Q over V, where, for each i, Ci = (Ai, Vi, αi, ψi).
We prove that the query QC induced by C is a V-rewriting of Q: first, since A1, . . . , Am
partition body(Q) and thanks to Condition (1), id is a homomorphism from Q into the
expansion Q′
C.
Therefore, it suffices to show that the union of the mappings ψ1, . . . , ψm is a homomor-
phism h′ from Q′
C into Q.
We first show that h′ is well-defined: let us assume that a variable z occurs in αi(Vi)
and αj(Vj) with i̸ = j. Thanks to consistency, z is in bvars(Ai) and bvars(Aj) and therefore
ψi(z) = ψj(z) thanks to Condition (4).
That h′ is a homomorphism follows easily, because each ψi is a body homomorphism by
Condition (3) and h′ is the identity on head(Q) by Condition (4).
Next, we show that (a) implies (b). Let us assume that Q has a V-rewriting QR with
an expansion QE and let the equivalence of Q and QE be witnessed by homomorphisms h
from Q to QE and h′ from QE to Q.
Since Q is minimal, we can assume, thanks to Lemma 4.7, that h is injective and h′ is
the inverse of h on the atoms of h(body(Q)). Since h is injective, we can further assume,
without loss of generality, that h is the identity mapping on the variables in Q and that
h′(x) = x for every such variable.8
That is, we have head(Q) = head(QE) = head(QR) as well as body(Q) ⊆body(QE).
Let α1, . . . , αm be applications of views V1, . . . , Vm that result in expansion QE, that is,
body(QE) =
m
[
i=1
body(αi(Vi)),
where the applications fulfil the quantified variable disjointness property. These applications
induce a partition A1, . . . , Am of body(QE) in the following way: For every i ∈{1, . . . , m}
we define
Ai = {A ∈body(Q) | i is minimal such that A ∈αi(body(Vi))}.
Now, let Ci = (Ai, Vi, αi, h′
i), where h′
i is the restriction of h′ to the variables in αi(Vi),
for every i ∈{1, . . . , m}. To show that C1, . . . , Cm yield a cover partition, it only remains
to show that each Ci is a cover description.
To this end, we show that all four conditions in Definition 4.2 are satisfied for Ci, for
every i ∈{1, . . . , m}. Condition (1) holds by the definition of Ai. Condition (3) is true
because each h′
i is a restriction of the body homomorphism h′. Condition (4) follows since h′
is the identity on all variables in body(Q) and thus also on all variables of Ai ⊆body(Q).
Hence, it only remains to show that Condition (2) is satisfied. To this end, let x be an
arbitrary bridge variable in some Ai. If x occurs in a subset Aj where j̸ = i, then it is a
head variable in both αi(Vi) and αj(Vj) because of the quantified variable disjointness of
α1, . . . , αm. Otherwise, Ai is the only subset containing variable x, which thus has to be a
head variable of Q in order to be a bridge variable in Ai. Because of head(Q) = head(QR),
8This can be easily achieved by renaming the variables of QR and QE appropriately.

---

17:14
G. Geck, J. Keppeler, T. Schwentick, and C. Spinrath
Vol. 19:4
it is then also a head variable of QR. This, in turn, implies that x is a head variable of αi(Vi)
because the quantified variables of αi(Vi) do not occur in QR.
Finally, we show that (b) implies (c). Let thus C = C1, . . . , Cm be a cover partition for
Q over V, where, for each i, Ci = (Ai, Vi, αi, ψi). Let z be a variable that occurs in some
αi(Vi), but not in bvars(Ai), and also in some αj(Vj) with j̸ = i. Since z̸ ∈bvars(Ai) we
have z̸ ∈vars(Aj). We define α′
j like αj but, for some fresh variable z′, we set α′
j(x) = z′
whenever αj(x) = z. Accordingly, we define ψ′
j like ψj but with ψ′
j(z′) = ψj(z). It is easy to
verify that C′
j = (Aj, Vj, α′
j, ψ′
j) is a cover description, as well. By repeating this process, a
consistent cover partition for Q over V can be obtained.
The previous proof used the following lemma. It is similarly stated in the proof of
Lemma 2 in [CGLP20a], see also the proof of Lemma 9 in the full version [CGLP20b] of
[CGLP20a] for the proof idea. We give its short proof to keep the paper self-contained.
Lemma 4.7. Let Q1 be a minimal conjunctive query, Q2 a conjunctive query equivalent to
Q1 and h1 : Q1 →Q2 a homomorphism. Then, there is a homomorphism h2 : Q2 →Q1 that
is the inverse of h1 on h1(body(Q1)).
Proof. Since Q1 and Q2 are equivalent, there is a homomorphism h′
2 : Q2 →Q1.
The mapping h′
2 ◦h1 is an automorphism9 on Q1, because Q1 is minimal. Since the
automorphisms of Q1 constitute a group, there is some k > 0 such that (h′
2 ◦h1)k is the
identity on Q1. We choose h2 = (h′
2 ◦h1)k−1 ◦h′
2. Clearly, h2 is a homomorphism from Q2
to Q1 and h2 is the inverse of h1 on h1(Q).
Remark 4.8. We note that the requirement in Theorem 4.6 for Q to be minimal is only
seemingly a restriction in our setting, since we apply it only to acyclic queries. If Q is acyclic
but not minimal, an equivalent minimal query Q′ can be computed in polynomial time by
iteratively removing atoms from its body [CM77, CR00]. Moreover, it is guaranteed that
the minimal query Q′ is also acyclic (we believe this to be folklore, it follows readily from
more general results, cf. for instance [BPR17]).
The same is true for free-connex acyclic queries: every homomorphism from Q to Q′ is
also a homomorphism from body(Q) ∪{head(Q)} to body(Q′) ∪{head(Q′)} and vice versa,
since the relation symbol of head(Q) = head(Q′) does not occur in body(Q′). Thus, Q′ is
minimal if and only if the Boolean query whose body is body(Q′) ∪{head(Q′)} is minimal.
Therefore, if body(Q) ∪{head(Q)} is acyclic, so is body(Q′) ∪{head(Q′)}. In other words,
if Q is free-connex acyclic, then Q′ is free-connex acyclic as well.
For hierarchical and q-hierarchical queries the same holds: it is easy to see that removing
atoms does not change the conditions in their respective definitions.
5. Towards Acyclic Rewritings
In this section, we turn our focus to the main topic of this paper: acyclic rewritings and
the decision problem that asks whether such a rewriting exists. We study the complexity
of Rewr(V, Q, ACQ) for the case that V and Q are the class of conjunctive queries and for
various subclasses. It will be helpful to analyse the case that Q = ACQ and V = CQ first.
9We note that compositions of homomorphisms are applied from right to left.

---

Vol. 19:4
REWRITING WITH ACYCLIC QUERIES: MIND YOUR HEAD
17:15
5.1. A Characterisation of Acyclic Rewritability for Acyclic Queries. The following
example illustrates that, even if an acyclic rewriting exists, the canonical rewriting need not
be acyclic. Furthermore, it may be that each “sub-rewriting” of the canonical candidate is
cyclic or not a rewriting, and thus none of them is an acyclic rewriting.
Example 5.1. Consider the query Q given by the rule
H() ←R1(x), R2(y), S(x, z), T1(z), T2(y)
and the following views V = {V1, V2, V3}.
V1(u1, v1) ←R1(u1), R2(v1)
V2(u2, v2) ←S(u2, v2)
V3(u3, v3) ←T1(u3), T2(v3)
The canonical candidate QR = H() ←V1(x, y), V2(x, z), V3(z, y) is a V-rewriting, but it is
cyclic. Each query whose body is a proper subset of the body of QR is not a V-rewriting
for Q. However, an acyclic V-rewriting for Q exists. One such rewriting is the query Q′
R.
H() ←V1(x, y), V2(x, z), V3(z, y′), V3(z′, y)
Even though Example 5.1 suggests that general and acyclic rewritings can be seemingly
unrelated, it turns out that there is a close connection between them. In fact, we will
show next that an acyclic V-rewriting exists if and only if an arbitrary V-rewriting exists.
Furthermore, from an arbitrary rewriting an acyclic rewriting can always be constructed.
Towards a proof, we study the relationship between a query Q and the view applications
that can occur in any rewriting of Q more closely, to determine the circumstances under
which a decomposition of view atoms is possible.
Example 5.2 (Continuation of Example 5.1). We first have a closer look at the V3-atoms
in the rewritings of the previous example. The two V3-atoms in Q′
R can be understood as a
(sub-)query with body {V3(z, y′), V3(z′, y)} and head variables z, y, whereas the V3-atom in
QR can be understood as a (sub-)query with body {V (z, y)} and head variables z, y. The
expansions of these two (sub-)queries are equivalent. That is, the acyclic rewriting can
be obtained from the canonical rewriting by replacing an atom by a set of atoms that is
equivalent with respect to view expansions.10
In Example 5.1 the acyclic rewriting was obtained from the canonical rewriting by
replacing a view atom by a set that contained one view atom for each connected component of
(the hypergraph induced by) V3. The following example shows that the required modifications
can be more involved.
Example 5.3. Consider the query Q given by the rule
H(x, y, z) ←R(x, y, z), E1(x), E2(y), E3(w), S(w, z)
and the following views.
V1(x1, y1, w1) ←R(x1, y1, v1), E1(x1), E3(w1), S(w1, v1)
V2(x2, y2, z2) ←R(x2, y2, z2), E2(y2)
V3(w3, z3) ←S(w3, z3), E3(w3)
The canonical candidate H(x, y, z) ←V1(x, y, w), V2(x, y, z), V3(w, z) is a cyclic {V1, V2, V3}-
rewriting of Q. In contrast to Example 5.1, all view bodies are connected. Therefore,
replacing a view atom by a set of representatives of connected components of some views
10We note that one could also replace the V1-atom in QR.

---

17:16
G. Geck, J. Keppeler, T. Schwentick, and C. Spinrath
Vol. 19:4
does not yield an acyclic rewriting. However, there is an acyclic {V1, V2, V3}-rewriting of Q,
namely H(x, y, z) ←V1(x, y′, w′), V2(x, y, z), V3(w, z).
Now we turn to the main result of this section.
Theorem 5.4. Let Q be a conjunctive query and V be a set of views.
(a) If Q is acyclic and V-rewritable, then it has is an acyclic V-rewriting.
(b) If Q is free-connex acyclic and V-rewritable, then it has a free-connex acyclic V-rewriting.
Proof. Since Q is acyclic, we can assume that it is minimal (cf. Remark 4.8). Moreover, it
has a join tree JQ, and, thanks to Theorem 4.6, since Q is V-rewritable, there is a consistent
cover partition C = C1, . . . , Cm for Q over V and the query QC is a V-rewriting of Q. For
each i, let Ci = (Ai, Vi, αi, ψi).
We show first that QC is acyclic if each set Ai is connected in JQ. Afterwards we show
that a consistent cover partition with that property can always be constructed from C.
To this end, we show how to construct a join tree J for QC: we first cluster, for each j,
the nodes for Aj in JQ together into one node that is labelled by αj(head(Vj)). Since the
Aj are connected in JQ, the resulting graph J is a tree.
To verify that J is a join tree, let us consider two nodes u, v of J labelled by αj(head(Vj))
and αk(head(Vk)), respectively, and x be a variable that appears in αj(head(Vj)) and
αk(head(Vk)).
Thanks to consistency of C, variable x appears in bvarsQ(Aj) and in
bvarsQ(Ak). It follows that x appears in two atoms A ∈Aj and A′ ∈Ak. Moreover,
since JQ is a join tree, x appears in every node on the (shortest) path from A to A′ in JQ.
Again thanks to consistency, x is in bvarsQ(Aℓ) for every αℓ(head(Vℓ)) along the correspond-
ing contracted path in J from u to v. In particular, x appears in all sets αℓ(head(Vℓ)) on
the path from u to v. Thus, u and v are x-connected. We conclude that J is a join tree for
QC. Hence, QC is acyclic.
If Q is also free-connex acyclic, there is a join tree J+
Q for body(Q) ∪{head(Q)}. As we
show later, we can assume that the sets Ai of the cover partition C are also connected in
J+
Q. Clustering the nodes11 of J+
Q analogously as for JQ yields a join tree for body(QC) ∪
{head(QC)} since head(QC) = head(Q) and all head variables in a set Ai also occur in the
new label αi(head(Vi)) thanks to Condition (2) of Definition 4.2.
We now show how, from a consistent cover partition C, we can construct a consistent
cover partition C′ = C′
1, . . . , C′
m such that each set A′
i is connected. To this end, let us
assume that some set Aj is not connected in JQ. Let Bj ⊆Aj be a maximal connected
subset and let A′
j = Aj \ Bj. We observe that each variable x that appears in Bj and A′
j,
is also in bvarsQ(Aj), since x has to occur in at least one other atom in JQ (otherwise,
Bj and A′
j would be connected in JQ). Thus, bvarsQ(Bj) ⊆bvarsQ(Aj). We conclude
that CBj = (Bj, Vj, αj, ψj) is a cover description. Likewise, C′
j = (A′
j, Vj, αj, ψj) is a cover
description. By repeated application of this modification step, we eventually obtain a cover
partition C′ = C′
1, . . . , C′
m in which each set A′
i is connected. If Q is free-connex, then C′
can be further refined as described above but w.r.t. J+
Q instead of JQ. Refining the cover
partition iteratively w.r.t. JQ and J+
Q yields a cover partition C′′ = C′′
1 , . . . , C′′
p in which each
set A′′
i is connected in JQ and J+
Q. The number of iterations is bounded by the number of
atoms of Q.
Thanks to Theorem 4.6, C′′ can be turned into a consistent cover partition (and the
required renamings of variables do not affect the connectedness).
11The node labelled head(Q) is not clustered with any other node, since it does not occur in any Ai.

---

Vol. 19:4
REWRITING WITH ACYCLIC QUERIES: MIND YOUR HEAD
17:17
Theorem 5.4 delivers good news as well as bad news. The good news is that, since the
proofs of Theorem 5.4 and Theorem 4.6 are constructive, we altogether have a procedure
to construct an acyclic rewriting from an arbitrary rewriting QR if the query Q is acyclic.
Furthermore, if a homomorphism from an expansion of QR to Q can be computed in
polynomial time, the overall procedure can be performed in polynomial time. In particular,
we get the following collary.
Corollary 5.5. For every k, Rewr(ACQk, ACQ, ACQ) is in polynomial time, and an acyclic
rewriting can be computed in polynomial time (if it exists).
That the decision problem is in polynomial time follows immediately from Proposi-
tion 3.10 and Theorem 5.4. Moreover, the canonical candidate for an acyclic query Q and a
set V of acyclic views with bounded arity can be computed in polynomial time, since the size
of V(canon(Q)) is bounded by a polynomial and query evaluation for acyclic queries is in
polynomial time [Yan81, AHV95]. In case the canonical candidate is a rewriting, valuations
witnessing V(canon(Q)) can be computed in polynomial time [KS06] and combined into a
homomorphism from an expansion of the rewriting to Q. Thus, an acyclic rewriting can
then be efficiently constructed by the above procedure.
However, this leaves open the complexity of Rewr(ACQ, ACQ, ACQ) (as well as that
of Rewr(ACQ, ACQ, CQ)), and of their restrictions to schemas of bounded arity. The bad
news is that, since Rewr(V, ACQ, CQ) and Rewr(V, ACQ, ACQ) are basically the same
problem, lower bounds on Rewr(V, ACQ, CQ) transfer to Rewr(V, ACQ, ACQ). In fact,
we get the following, due to NP-hardness of Rewrk(CQ, ACQ, CQ) in the general case
(Proposition 3.11).12
Corollary 5.6. For every k ≥3, the problem Rewrk(CQ, ACQ, ACQ) and, therefore, also
Rewrk(CQ, CQ, ACQ) is NP-hard.
In the next part of this section, we resolve the complexity of Rewr(ACQ, ACQ, CQ) and
Rewr(ACQ, ACQ, ACQ) and their restrictions to schemas of bounded arity.
5.2. The Complexity of Acyclic Rewritability for Acyclic Queries. It may be
tempting to assume that, since acyclic queries are so well-behaved in general, it should
be tractable to decide whether for an acyclic query and a set of acyclic views there exists
an acyclic rewriting. However, as we show next, this is (probably) not the case, and this
surprising finding even holds for the even better behaved hierarchical queries as well.
Theorem 5.7. The problems Rewrk(ACQ, ACQ, CQ) and Rewrk(ACQ, ACQ, ACQ), as
well as Rewrk(HCQ, HCQ, CQ) are NP-complete, for k ≥3.13 The lower bounds even hold
for instances with a single view.
Of course, Theorem 5.7 immediately implies NP-hardness of Rewrk(V, Q, ACQ), for
all pairs V, Q of classes with ACQ ⊆V ⊆CQ and ACQ ⊆Q ⊆CQ.
We will see in Section 7 that Theorem 5.4 has an analogue for hierarchical queries from
which it can be concluded that deciding the existence of a hierarchical rewriting, given a
hierarchical query and hierarchical views, is still NP-complete (cf. Corollary 7.5).
12We note that Corollary 5.6 also follows from the proof of Proposition 3.11, since the canonical candidate
constructed in that proof is trivially acyclic. Indeed, NP-hardness of Rewr(ACQ, CQ, ACQ) is also implied.
13These results hold for schemas of unbounded arity, as well.

---

17:18
G. Geck, J. Keppeler, T. Schwentick, and C. Spinrath
Vol. 19:4
Theorem 5.7 will easily follow from NP-hardness of a seemingly simpler problem. From
the characterisation in Theorem 4.6, we already know that deciding the existence of a
rewriting is the same as deciding the existence of a cover partition. We show next that it is
even NP-hard to decide the existence of a cover description, given a query, a set of atoms,
and a single view.
Definition 5.8. Let V ⊆CQ and Q ⊆CQ be classes of conjunctive queries. The cover
description problem for V and Q, denoted CovDesc(V, Q) asks, upon input of a query
Q ∈Q, a subset A ⊆body(Q) and a view V ∈V, whether mappings α and ψ exist such
that (A, V, α, ψ) is a cover description.
Theorem 5.9. CovDesc(ACQ, ACQ) is NP-hard. Indeed, even CovDesc(HCQ, HCQ)
is NP-hard and even if the input is restricted to A = body(Q).
Proof. We reduce problem 3SAT to CovDesc(HCQ, HCQ). This lower bound directly
translates to CovDesc(ACQ, ACQ) since every hierarchical query is acyclic. For a formula f
in 3CNF, we describe how a query Q and a view V can be derived in polynomial time such
that both Q and V are hierarchical and such that f is satisfiable if and only if there are
mappings α and ψ such that (body(Q), V, α, ψ) is a cover description for Q. In the following
we will use the term proposition for propositional variables of a formula in order to easily
distinguish them from variables occurring in queries and views.
Construction. Let f = f1 ∧· · · ∧fk be a propositional formula in 3CNF over propositions
x1, . . . , xn in clauses f1, . . . , fk, where fj = (ℓj,1 ∨ℓj,2 ∨ℓj,3) for each j ∈{1, . . . , k}.
We start with the construction of query Q. This query is Boolean, with head H(), and
uses only three variables w0, w1 and u, where the first two are intended to represent the
truth values false and true. The structure of Q is depicted in Figure 1(a). The body of Q is
defined as the union
{Form(w0, w1, u)} ⊎C0 ⊎C1 ⊎N1 ⊎· · · ⊎Nn
of the following sets of atoms.
• Set C0 contains an atom Cj(w0, w1, u) for each clause fj in f.
Intuitively, these atoms represent unsatisfied clauses as opposed to the next atoms that
represent satisfied clauses. Note that these atoms differ in the order of variables w0 and w1
only.
• Set C1 contains an atom Cj(w1, w0, u) for each clause fj in f.
• There is a set Ni for each proposition xi in formula f. The sets differ only in the name of
the relation they address and contain two atoms Negi(w0, w1, u) and Negi(w1, w0, u) each.
Query Q is hierarchical since every atom in each of the sets above refers to all three
variables w0, w1 and u. Thus, query Q is acyclic in particular.
We now proceed with the construction of view V , which refers to the same relations
as query Q.
Like query Q, the view uses variables w0, w1 and u but also additional
variables for the propositions x1, . . . , xn in formula f. For each proposition xi, there are
two variables xi and ¯xi, intended to represent the positive and negated literal over the
proposition, respectively. With the exception of variable u, all other variables are in the
head H(w0, w1, x1, ¯x1, . . . , xn, ¯xn) of view V . The body of V , whose structure is depicted in
Figure 1(b), is defined as the union
{Form(w0, w1, u)} ⊎C0 ⊎
 X1 ⊎X +
1 ⊎X −
1

⊎· · · ⊎
 Xn ⊎X +
n ⊎X −
n


---

Vol. 19:4
REWRITING WITH ACYCLIC QUERIES: MIND YOUR HEAD
17:19
Form(w0, w1, u)
C0
C1
N1
. . .
Nn
(a) Structure of query Q, induced by formula f.
Form(w0, w1, u)
C0
X1
X +
1
X −
1
. . .
Xn
X +
n
X −
n
(b) Structure of view V , induced by formula f.
Figure 1. Structure of the query Q and the view V , induced by formula f.
of sets of atoms, where the first two sets {Form(w0, w1, u)} and C0 are the same as above.
The bodies of query Q and view V thus differ in the sets C1 and N1, . . . , Nn of atoms on the
one hand as well as X1, . . . , Xn and X +
1 , . . . , X +
n and X −
1 , . . . , X −
n on the other hand. Sets
N1, . . . , Nn and X1, . . . , Xn are intended to guide the assignment of propositions, while sets
X +
1 , . . . , X +
n and X −
1 , . . . , X −
n represent the occurrences of literals in the clauses of formula f,
and set C1 represents the aim to satisfy all of them. The new sets are defined as follows.
• For each proposition xi, set Xi contains atoms Negi(xi, ¯xi, u) and Negi(¯xi, xi, u), intended
to enforce the mapping of (xi, ¯xi) to either (w0, w1) or (w1, w0), that is, to “complementary
truth values”.
• For each positive literal xi and each clause fj that contains literal xi, set X +
i
contains an
atom Cj(xi, ¯xi, u).
• For each negated literal ¯xi and each clause fj that contains literal ¬xi, set X −
i
contains
an atom Cj(¯xi, xi, u).
Thus defined, the view is also hierarchical as shown in the following. Every atom in every
set contains variable u. Therefore, it follows that atoms(x) ⊆atoms(u) for all x ∈vars(V ).
Furthermore, all atoms in {Form(w0, w1, u)} and C0 additionally contain both variables w0
and w1 and they are the only atoms to contain these variables.
Thus, we have that
atoms(w0) = atoms(w1) and atoms(y) ∩atoms(w0) = ∅and atoms(y) ∩atoms(w1) = ∅for
all y ∈vars(V ) \ {u, w0, w1}. Similarly, for each i ∈{1, . . . , n}, all atoms in Xi ∪X +
i ∪X −
i
contain both variables xi and ¯xi, which do not occur in any other atom. It follows that
atoms(xi) = atoms(¯xi) and atoms(¯xi) ∩atoms(y) = ∅and atoms(xi) ∩atoms(y) = ∅for all
y ∈vars(V ) \ {xi, ¯xi, u} and i ∈{1, . . . , n}. Therefore, we obtain that each pair of variables
in V satisfies at least one of the conditions in Definition 2.1 and thus V is hierarchical—and
acyclic in particular.
For the correctness argument, however, the structure of the join tree of view V , depicted
in Figure 1(b) is probably more helpful. We close the description of the construction by
remarking that the query and view can be computed in polynomial time for any given
propositional formula in 3CNF.
Correctness. We prove now that formula f is satisfiable if and only if there are mappings α
and ψ such that (body(Q), V, α, ψ) is a cover description for Q.
First, we show that if formula f is satisfiable, then there are mappings α and ψ such that
(body(Q), V, α, ψ) is a cover description for Q.

---

17:20
G. Geck, J. Keppeler, T. Schwentick, and C. Spinrath
Vol. 19:4
To this end, let us assume that f is satisfiable and that this is witnessed by a satisfying
truth assignment β. From this assignment for propositions x1, . . . , xn, we derive the appli-
cation α of V . Let α be the mapping that is the identity on variables w0, w1 and u and
behaves as follows on the literal variables, for every i ∈{1, . . . , n}.
α(xi, ¯xi) =
(
(w0, w1)
if β(xi) = 0
(w1, w0)
if β(xi) = 1
We choose mapping ψ to be the identity on the variables of α(V ). Then (body(Q), V, α, ψ)
is a cover description for Q because application α establishes the following relationships
between the atoms of view V (on the left-hand side) and the atoms of query Q (on the
right-hand side).
(i) α(C0) = C0
(ii) α(X1) = N1, . . . , α(Xn) = Nn
(iii) α(X +
1 ∪X −
1 ∪· · · ∪X +
n ∪X −
n ) ⊆C0 ∪C1
(iv) α(X +
1 ∪X −
1 ∪· · · ∪X +
n ∪X −
n ) ⊇C1
Property (i) is rather obvious since the application α behaves like the identity on the vari-
ables w0, w1 and u in C0. Next, let us consider the set Xi = {Negi(w0, w1, u), Negi(w1, w0, u)}
for an arbitrary i ∈{1, . . . , n}. By definition, application α maps (xi, ¯xi) either to (w0, w1)
or (w1, w0). In each case, we get
α(Xi) = {Negi(w0, w1, u), Negi(w1, w0, u)} = Ni.
Hence, Property (ii) holds too. Again by definition of α, the atoms in X +
1 ∪· · · ∪X +
n ,
which are of the form Cj(xi, ¯xi, u), are mapped to Cj(w0, w1, u) or Cj(w1, w0, u), contained in
C0 ∪C1. An analogous argument holds for the atoms in X −
1 ∪· · · ∪X −
n . Thus, Property (iii)
is also satisfied. Finally, we show that Property (iv) holds. To this end, let Cj(w1, w0, u) be
an arbitrary atom in C1. By our assumption, clause fj in formula f is satisfied by truth
assignment β. Hence, there is a literal ℓj,h in clause fj such that β |= ℓj,h. Let us assume
ℓj,h = xi for some i ∈{1, . . . , n}; the argument for a negated literal is analogous. This
assumption implies α(xi) = w1 by the definition of α, which depends on β. Since literal xi
is a literal in clause fj, we have Cj(xi, ¯xi, u) ∈X +
i
and thus α(X +
i ) ∋Cj(w1, w0, u).
Since Properties (i) – (iv) consider all body atoms of query Q and view V , they imply
that the bodies are identical: body(Q) = α(body(V )). For ψ = id, this trivially implies
body(Q) ⊆α(body(V )) and ψ(α(body(V ))) ⊆body(Q), namely Conditions (1) and (3) in
Definition 4.2. Furthermore, since query Q is Boolean, set A = body(Q) has no bridge
variables. Thus, Conditions (4) and (2) are trivially satisfied.
Therefore, (A, V, α, ψ) is a cover description for Q.
Now, we show that formula f is satisfiable if there are mappings α and ψ such that
(body(Q), V, α, ψ) is a cover description for Q.
Consider the set B = α(body(V )) of atoms.
From Definition 4.2, we know that
body(Q) ⊆B and ψ(B) ⊆body(Q) hold. Since both sets body(Q) and B contain only
one Form-atom B = Form(w0, w1, u), we can conlude α(B) = B by Condition (1) and
ψ(α(B)) = ψ(B) = B by Condition (3). Therefore, each mapping α and ψ is the identity on
variables w0, w1 and u. Hence, application α induces unambiguously a truth assignment β
that maps proposition xi 7→1 if α(xi) = w1; and maps xi 7→0 otherwise.
It suffices to show that β satisfies formula f. Let fj be an arbitrary clause of the formula.
From body(Q) ⊆α(body(V )), we know that atom Cj(w1, w0, u) is in α(body(V )) because

---

Vol. 19:4
REWRITING WITH ACYCLIC QUERIES: MIND YOUR HEAD
17:21
Cj(w1, w0, u) is in C1 and, therefore, in body(Q). Since body(V ) does not contain atoms
from C1, it has to contain a different Cj-atom which is mapped to Cj(w1, w0, u) by α. This
atom cannot be Cj(w0, w1, u) from C0 because α is the identity on w0, w1, and u. Hence,
there has to be an atom Cj(xi, ¯xi, u) ∈X +
i
or Cj(¯xi, xi, u) ∈X −
i
for some i ∈{1, . . . , n} in
body(V ) that is mapped to Cj(w1, w0, u) by α. In the case that an atom Cj(xi, ¯xi, u) ∈X +
i
is mapped to Cj(w1, w0, u), it follows by construction that the literal xi occurs in clause fj.
Furthermore, from α(Cj(xi, ¯xi, u)) = Cj(w1, w0, u), we can infer α(xi) = w1. Hence, truth
assignment β satisfies literal xi in clause fj because β(xi) = 1 if α(xi) = w1. The other case
is analogous.
Thus, truth assignment β satisfies every clause of formula f and formula f is satisfiable
if a rewriting of query Q in terms of view V exists.
This concludes our proof.
The proof of Theorem 5.7 can now be stated easily.
Proof of Theorem 5.7. The upper bound follows from Theorem 3.2.
For the lower bound, we show that the reduction of Theorem 5.9 can be adapted to a
reduction from 3SAT to Rewrk(HCQ, HCQ, CQ). To this end, we show that the query Q
constructed in the proof of Theorem 5.9 has a {V }-rewriting if the formula f is satisfiable.
If the formula f is satisfiable then there are mappings α and ψ such that C =
(body(Q), V, α, ψ) is a cover description. Due to Theorem 4.6 it follows that Q is {V }-
rewritable, since C trivially constitutes a cover partition.
If Q is {V }-rewritable then there is a cover partition C for Q over {V } due to Theorem 4.6.
We will show that C consists of a single cover description C. Since C then necessarily has
the shape (body(Q), V, α′, ψ′), this implies that the formula f is satisfiable.
Suppose for the sake of contradiction that C consists of at least two cover descriptions.
Let C1 be a cover description from C. Since V is the only view and C1 is not the only cover
description in C, C1 has the shape C1 = (A1, V, α1, ψ1) with A1 ⊊body(Q). We observe
that the variable u is a bridge variable of A1 since it occurs in every atom of Q, and, thus, in
A1 and outside A1. Since u is always the last variable in every atom in Q and V , it follows
from Definition 4.2(1) that α1(u) = u. But then bvarsQ(A1) ⊈α1(vars(head(V ))), since u
does not occur in the head of V and α1 does not unify quantified variables. This contradicts
Definition 4.2(2), and, thus, C1 being a cover description. Therefore, C consists of a single
cover description.
To conclude, we have established that Q is {V }-rewritable if and only of formula f
is satisfiable. Hence, the NP-hardness shown for CovDesc(HCQ, HCQ) also holds for
Rewrk(HCQ, HCQ, CQ). It trivially transfers to Rewrk(ACQ, ACQ, CQ) and by Theorem 5.4
also to Rewrk(ACQ, ACQ, ACQ).
The fact that, for Theorem 5.7, a single view application is sufficient if there is any
rewriting, allows to draw yet another conclusion for a related problem, defined next.
Definition 5.10. Given a query class Q ⊆CQ, the select-full-project equivalence problem
for Q, denoted SelProjEquiv(Q), asks, upon input of a Boolean query Q ∈Q and a query
Q′ ∈Q whether there is a Boolean query Q′′ which is equivalent to Q and whose body can
be obtained from the body of Q′ by unifying head variables of Q′ in its body.14
14The problem is called the select-full-project equivalence problem because the query Q′′ can, if it exists, be
expressed in the relational algebra by applying select-operators and a (full) project-operator to an expression
for Q′.

---

17:22
G. Geck, J. Keppeler, T. Schwentick, and C. Spinrath
Vol. 19:4
Example 5.11. Consider the Boolean query Q defined by
H() ←R(x), S(y, x, y), T(y, z), T(z, x)
and the query Q′ defined by
H′(y, z, u, v) ←R(x), S(y, x, v), S(y, x, w), T(y, z), T(u, x).
The body of the Boolean query Q′′ given by
H() ←R(x), S(y, x, y), S(y, x, w), T(y, z), T(z, x)
can be obtained by unifying the head variables y and v as well as z and u in body(Q′). The
query Q′′ is equivalent to Q. Thus, (Q, Q′) ∈SelProjEquiv(CQ).
Interpreting the query Q′ in Definition 5.10 as a view, the unification of head variables
can be realised by an application α which does not unnecessarily rename variables. Whether
the desired Boolean query Q′′ exists then boils down to whether there is a {Q′}-rewriting
for Q whose body consists of a single view atom, i.e. α(head(Q′)).
Example 5.12 (Continuation of Example 5.11). Recall that the body of the Boolean query
Q′′ in Example 5.11 is obtained from body(Q′) by unifying the head variables y and v as
well as z and u. Let α be the application which maps v to y, u to z, and is the identity on
every other variable. The Boolean query with body {α(head(Q′))} = {H′(y, z, z, y)} is a
{Q′}-rewriting of Q. In fact, its expansion is Q′′ which is equivalent to Q.
Due to the relationship between the select-full-project equivalence problem and rewritabil-
ity explained above and Theorem 5.9 the following holds.
Corollary 5.13. SelProjEquiv(ACQ) and SelProjEquiv(HCQ) are NP-hard.
Proof. The proof is essentially the same as for Theorem 5.7.
Let Q and V be the Boolean query and the view constructed in the proof for Theorem 5.7,
respectively. If (body(Q), V, α, ψ), for some mappings α and ψ, is a cover description for Q,
then the Boolean query with body α(head(V )) is a rewriting of Q since the cover description
constitutes a consistent cover partition for Q (a cover partition consisting of a single cover
description is consistent by definition).
Thus, Q is equivalent to the Boolean query Q′′ whose body is obtained from body(V ) by
unifying exactly the (head) variables in body(V ) the application α unifies. In other words,
Q′′ equals α(V ) up to renaming variables.
Conversely, if Q is equivalent to a Boolean query Q′′ whose body can be obtained
from body(V ) by unifying head variables of V in body(V ), then there is an application α
with α(body(V )) = body(Q′′) and, thus, Q′′ is the expansion of a V -rewriting, namely the
Boolean query with body α(head(V )), for Q.
Hence, by choosing the second input query to be Q′ = V , Corollary 5.13 follows because
Q and Q′ are hierarchical.
We note that the restriction of the select-full-project equivalence problem to Boolean
queries Q′ is just the equivalence problem for Boolean queries which is in P for acyclic
queries [CR00].
But, surprisingly, the select-full-project equivalence problem is NP-hard not only for
hierarchical but even for q-hierarchical queries—while the rewriting problem for q-hierarchical
views is in P (Corollary 7.4).

---

Vol. 19:4
REWRITING WITH ACYCLIC QUERIES: MIND YOUR HEAD
17:23
Corollary 5.14. SelProjEquiv(QHCQ) is NP-hard, even over database schemas with
fixed arity.
Proof. To lift Corollary 5.13 to q-hierarchical queries, we have to adapt the query Q′ in the
proof of Corollary 5.13 since it is not q-hierarchical. Adding the variable u to the head of Q′
yields the desired q-hierarchical query, since every full hierarchical query is q-hierarchical. We
note that the query Q is a hierarchical Boolean query and, therefore, trivially q-hierarchical.
Note that, for the proof of Theorem 5.9, which builds upon the proof for Theorem 5.7,
it is required that u is not in the head of V . This ensures that the whole query has to be
covered by a single application of the view V . In other words, if there is a rewriting of Q,
there is a rewriting that consists only of a single atom. Since this restriction is not necessary
in the setting of the select-full-project equivalence problem, we can indeed simply add15 u
to the head of Q′.
6. A Tractable Case
In this section, we first show that the acyclic rewriting problem becomes tractable for
free-connex acyclic views and acyclic queries over database schemas of bounded arity. We
then define a slightly larger class of views, for which this statement holds as well. For the
first result, we mainly show that rewritability with respect to a set V of free-connex acyclic
views can be reduced to rewritability with respect to a set W of views of bounded arity.
Proposition 6.1. There is a polynomial-time algorithm that computes from each set V of
free-connex acyclic views a set W of acyclic16 views such that
(a) the arity of the views of W is bounded by the arity of the underlying schema, and
(b) every conjunctive query Q is V-rewritable if and only if it is W-rewritable.
Furthermore, given a W-rewriting of Q, a V-rewriting of Q can be computed in polynomial
time.
The proof splits each view V into a set of views obtained by the subtrees of the root
head(V ) of a join tree of body(V ) ∪{head(V )}. The arities of the children of head(V ) yield
the desired arity bound.
Proof. Let V be a set of free-connex acyclic views over a schema S with arity at most
k. Let V ∈V and J be a join tree for V including its head atom head(V ). Since a join
tree is undirected, we can assume that the root of J is the node labelled with head(V ).
Let A1, . . . , An be the labels of the children of the root node. Furthermore, let, for each
1 ≤i ≤n, Bi be the set of atoms in the subtree of J with root Ai. Since J is a join tree, each
variable that occurs in some atom of a set Bi and in head(V ) also occurs in Ai. Furthermore,
variables that occur in two sets Bi, Bj, i̸ = j, necessarily occur also in head(V ). Thus, the
following two conditions hold, for every i ∈{1, . . . , n} and every j < i,
(1) |vars(Bi) ∩vars(head(V ))| ≤k, and
(2) vars(Bi) ∩vars(Bj) ⊆head(V ).
15In fact, we could also remove u from Q′ altogether. In this case, we also have to remove it from Q.
16In fact, the views in W are even free-connex acyclic again. However, we do not claim it here, since it is
not needed in the following, and it does not need to hold for the subsequent generalisation.

---

17:24
G. Geck, J. Keppeler, T. Schwentick, and C. Spinrath
Vol. 19:4
For each 1 ≤i ≤n we define the view Vi as the projection of V to the variables that
occur in head(V ) and in Bi. That is, the body of Vi is just the body of V and the head of
Vi contains precisely those head variables of V that occur in Bi. By construction, the views
Vi have arity ar(Ai) ≤k. Furthermore, the views Vi are acyclic since they have the same
body as V which is acyclic.17
The desired set W of views can thus be obtained by replacing each view V ∈V by views
V1, . . . , Vn as constructed above. It is easy to see that W can be computed in polynomial
time.
It remains to show that an arbitrary CQ Q is V-rewritable if and only if it is W-
rewritable. For the direction from right to left, let CW be a cover partition witnessing that
Q is W-rewritable. Consider a cover description (A, Vi, α, ψ) where Vi is a view constructed
as above, originating from a view V ∈V. Since the only difference between V and Vi is
that V has more head variables, replacing Vi with V yields a cover description (A, V, α, ψ).
Analogous replacements in all cover descriptions in CW yield a cover partition witnessing
V-rewritability of Q. Moreover, given a W-rewriting of Q, a V-rewriting of Q can be obtained
by replacing every Vi-atom in the W-rewriting by a V -atom where V is, as above, the view
Vi originated from. Variables not occurring in Bi but in the head of V are replaced by fresh
variables (i.e. variables not occurring anywhere else) in the V -atom.
For the direction from left to right, let CV be a consistent cover partition witnessing
V-rewritability of Q. We replace the cover descriptions in CV to obtain a cover partition
witnessing W-rewritability of Q. To this end, let C = (A, V, α, ψ) be a cover description in
CV. Furthermore, let B1, . . . , Bn and V1, . . . , Vn be as in the construction of W above. For
each 1 ≤i ≤n, let Ai be the set of all atoms of A which are in α(Bi) but in no α(Bj), for
j < i. Since vars(A) ⊆α(body(V )), this yields a partition of A. We claim that, for each
1 ≤i ≤n, Ci = (Ai, Vi, α, ψ) is a cover description. Since Vi and V have the same body,
Conditions (1) and (3) of Definition 4.2 hold. Condition (4) of Definition 4.2 holds since
vars(Ai) ⊆vars(A).
In the remainder, we prove that Condition (2) of Definition 4.2 holds. Let x ∈bvars(Ai).
Then x is either in bvars(A) or it is a “new” bridge variable that also occurs in some Aj ⊆A,
j̸ = i. In the former case, x ∈α(head(V )) since Condition (2) holds for C. Thus, there are
variables y ∈head(V ) and y′ in Bi such that α(y) = x = α(y′). Since, thanks to quantified
variable disjointness, α maps quantified and head variables disjointly, it follows that y′ must
be from head(V ) as well. But then y′ occurs in head(Vi) since it is in head(V ) and in Bi.
Therefore, x = α(y′) ∈α(head(Vi)).
In the other case, let j̸ = i be such that x occurs in Aj and, hence, in α(Bj). Let y, z be
variables from Bi and Bj, respectively, such that α(y) = x = α(z). If y = z, then y is a head
variable of V , since Bi and Bj have only head variables of V in common. If y̸ = z, then both
y and z occur in the head of V thanks to quantified variable disjointness. In both cases, we
can conclude that x = α(y) occurs in α(head(Vi)). Thus, Condition (2) of Definition 4.2
holds for Ci.
Since the Ai form a partition of A, replacing C in CV with C1, . . . , Cn yields a cover
partition (with respect to V ∪W) and iterating this process for all cover descriptions in the
original partition CV yields a cover partition witnessing W-rewritability of Q.
The main result of this section is now a simple corollary to Proposition 6.1.
17We observe that, since all head variables of Vi occur in Ai, each Vi is even free-connex acyclic.

---

Vol. 19:4
REWRITING WITH ACYCLIC QUERIES: MIND YOUR HEAD
17:25
Theorem 6.2. For every fixed k, Rewrk(CCQ, ACQ, ACQ) is in polynomial time and an
acyclic rewriting can be computed in polynomial time, if it exists.
Proof. Let Q ∈ACQ be an acyclic query and V ⊆CCQ be a set of free-connex acyclic views
over a schema S with arity at most k. Thanks to Proposition 6.1, from V an equivalent set
W of acyclic views of arity at most k can be computed in polynomial time. The statements
of the theorem thus follow immediately from Corollary 5.5.
We leave the complexity of Rewr(CCQ, ACQ, ACQ) as an open problem.
A closer inspection of the proof of Proposition 6.1 reveals that it does not exactly
require that the views are free-connex acyclic. In fact, it suffices that each view has a
partition B1 ⊎· · · ⊎Bm of its body that obeys Conditions (1) and (2) defined in the proof of
Proposition 6.1. Therefore, we turn these two requirements into a new notion. We formulate
and study this notion for conjunctive queries Q, but we emphasise that we will use it for
queries that define views only.
Definition 6.3. The weak head arity of a query Q is the smallest k for which there is a
partition B1 ⊎· · · ⊎Bn of body(Q) such that, for every i ∈{1, . . . , n} and every j < i,
(1) |vars(Bi) ∩vars(head(Q))| ≤k, and
(2) vars(Bi) ∩vars(Bj) ⊆head(Q).
From the proof of Proposition 6.1 it follows that free-connex acyclic queries over a fixed
schema have bounded weak head arity. The following example illustrates that there are
indeed views over a fixed schema that have bounded weak head arity but are not free-connex
acyclic.
Example 6.4. Let us consider the family
 Vn

n∈N of views with
• head Vn(x, y1, . . . , yn, z1, . . . , zn), and
• body {R(x, ui, yi), S(x, ui, zi), T(yi) | 1 ≤i ≤n}.
For n ≥1 the view Vn is acyclic but not free-connex acyclic. It has, however, weak head
arity 3. This is witnessed by the sets Bi = {R(x, ui, yi), S(x, ui, zi), T(yi)} for 1 ≤i ≤n
which form a partition satisfying the conditions of Definition 6.3.
To generalise Theorem 6.2 for views of bounded weak head arity, we thus only need
to show that partitions obeying Conditions (1) and (2) of Definition 6.3 can be efficiently
computed. In the remainder of this section we design an algorithm that determines the weak
head arity of a given conjunctive query Q and computes a corresponding partition.
The algorithm relies on the concept of a cover graph for Q.
Definition 6.5. The cover graph G(Q) of a conjunctive query Q is the undirected graph
with node set body(Q) and edges (A, A′) for atoms A and A′ that share a variable that does
not belong to head(Q).
Example 6.6. The cover graph of the view V3 from Example 6.4 is depicted in Figure 2.
The following lemma states the relationship between weak head arity and cover graph.
Lemma 6.7. Let Q be a conjunctive query and B1, . . . , Bn the connected components of its
cover graph. The weak head arity of Q is the maximal number ℓof head variables of Q in a
set Bi. Moreover, the connected components B1, . . . , Bn witness that Q has weak head arity ℓ.

---

17:26
G. Geck, J. Keppeler, T. Schwentick, and C. Spinrath
Vol. 19:4
R(x, u1, y1)
S(x, u1, z1)
T(y1)
R(x, u2, y2)
S(x, u2, z2)
T(y2)
R(x, u3, y3)
S(x, u3, z3)
T(y3)
Figure 2. The cover graph G(V3) of the query Vn for n = 3 defined in
Example 6.4.
Proof. Let Q be a conjunctive query and let B′
1⊎· · ·⊎B′
m be a partition of body(Q) witnessing
that Q has weak head arity k.
Since by definition of the cover graph, two different sets Bi and Bj only share head
variables, B1 ⊎· · · ⊎Bn is a partition of body(Q) witnessing that Q has weak head arity at
most ℓ, hence it holds k ≤ℓ.
To show that ℓ≤k, it suffices to show that every connected component B in G(Q) is
contained in some atom set B′
i. Towards a contradiction we assume that there is a connected
component B with atoms from two different subsets of the partition. Since B is connected
there must be some A1, A2 ∈B, connected by an edge, such that A1 ∈B′
i and A2 ∈B′
j, for
some i̸ = j. By definition of G(Q), A1 and A2 share a variable that is not part of the head
of Q. But that contradicts Condition (2) in Definition 6.3. Thus, we can conclude ℓ≤k.
Lemma 6.7 offers an algorithm to compute the weak head arity of a conjunctive query
Q and a witness partition for it. It simply computes the cover graph G(Q) of Q and its
connected components. Then the weak head arity is the maximum number of head variables
that occur in any connected component. Furthermore, the connected components form the
desired partition satisfying the conditions of Definition 6.3. We thus have the following
corollary.
Corollary 6.8. There is an algorithm that, upon input of a conjunctive query Q, computes
in polynomial time the weak head arity of Q and a partition of body(Q) that witnesses it.
By combining Corollary 6.8 with the proofs of Proposition 6.1 and Theorem 6.2, we
obtain the following generalisation of Theorem 6.2.
Theorem 6.9. For each fixed k ∈N, the acyclic rewriting problem for acyclic queries and
acyclic views with weak head arity k is in polynomial time.
7. The Existence of Hierarchical and q-hierarchical Rewritings
In Section 5, we have shown that every acyclic query has an acyclic rewriting if it has
a rewriting at all. This gives us a guarantee that there is a rewriting that has the same
complexity benefits for query evaluation as the original query.
It is natural to ask whether other, stronger properties transfer in the same fashion. In
this section, we consider this question for hierarchical and q-hierarchical queries.
The following example illustrates that, as for acyclic rewritings, even if a hierarchical
rewriting for a hierarchical query exists, the canonical rewriting is not necessarily hierarchical.
Example 7.1. Consider the hierarchical query H(x, y) ←R(x), S(y), T(x), T(y) and the
views V1(x1, y1) ←R(x1), S(y1) and V2(z2) ←T(z2). The canonical rewriting
H(x, y) ←V1(x, y), V2(x), V2(y)

---

Vol. 19:4
REWRITING WITH ACYCLIC QUERIES: MIND YOUR HEAD
17:27
is not hierarchical, since atoms(x) and atoms(y) are neither disjoint nor subsets of one
another. However, a hierarchical rewriting exists, for instance
H(x, y) ←V1(x, y′), V1(x′, y), V2(x), V2(y)
is a hierarchical rewriting.
It turns out that Theorem 5.4 also holds for hierarchical and q-hierarchical queries.
Theorem 7.2. Let Q be a conjunctive query and V be a set of views.
(a) If Q is hierarchical and V-rewritable, then it has a hierarchical V-rewriting.
(b) If Q is q-hierarchical and V-rewritable, then it has a q-hierarchical V-rewriting.
Similarly as for Theorem 5.4, the proof of Theorem 7.2 partitions cover descriptions.
However, the strategy for doing so is different here: instead of defining the partition as the
connected components of an atom set with respect to a join tree of the query at hand, here
the partition guaranteed by the following lemma is used.
Lemma 7.3. Let Q be a hierarchical query and (A, V, α, ψ) a cover description for Q. There
is a partition A1 ⊎· · · ⊎An = A such that the following conditions hold.
(A) Each variable y /∈vars(α(head(V ))) appears in at most one set Ai.
(B) Each Ai is
(Ba) a singleton set or
(Bb) there is a variable x /∈vars(α(head(V ))) that appears in every atom in Ai.
Proof. The algorithm uses an undirected graph G similar to the cover graph of Section 6.
The graph G has vertex set A and an edge labelled by variable x between two atoms A1, A2,
if x /∈vars(head(α(V ))) and x occurs in A1 and A2. We note that there can be more than
one edge between two atoms.
Clearly, for each variable x /∈vars(head(α(V ))), the atoms that contain x constitute a
clique in G with edges labelled by x. In particular, each variable x /∈vars(head(α(V ))) can
occur in at most one connected component. Since Q is hierarchical, for two cliques Cx, Cy
induced by different variables x and y it holds that either they are disjoint or one contains
the other. It readily follows that for each connected component H of G there is a variable x,
such that Cx contains all atoms of H.
Therefore the partition A1 ⊎· · · ⊎An = A given by the connected components of G
fulfils the conditions of the Lemma.
Now we are prepared to prove Theorem 7.2.
Proof of Theorem 7.2. Towards (a), let Q be a V-rewritable hierarchical query. W.l.o.g. we
can assume that Q is minimal (cf. Remark 4.8). Thanks to Theorem 4.6, there is a cover
partition C′ = C′
1, . . . , C′
k for Q over V. We replace every cover description (A, V, α, ψ)
in C′ by (A1, V, α, ψ), . . . , (An, V, α, ψ) were A1 ⊎· · · ⊎An = A is the partition of A from
Lemma 7.3 and let C be the collection we obtain after the replacement. For each (Ai, V, α, ψ)
Condition (2) of Definition 4.2 is satisfied thanks to Condition (A) of Lemma 7.3. It is easy
to verify that the other conditions in Definition 4.2 are satisfied for each (Ai, V, α, ψ). All in
all, the collection C is a cover partition for Q over V. Thanks to Theorem 4.6 we can assume
that C is a consistent one with the same partition of body(Q).
Let R be the rewriting obtained from C, i.e., the query QC. In the remainder of the
proof we show that R is hierarchical, i.e., every pair of variables in x and y in R satisfies the
conditions in Definition 2.1. Let x and y be two variables in R.

---

17:28
G. Geck, J. Keppeler, T. Schwentick, and C. Spinrath
Vol. 19:4
If x occurs in only one atom of body(R) then there are two cases: (i) if in the only
atom in which x occurs, y occurs as well, then atomsR(x) ⊆atomsR(y), and (ii) otherwise,
atomsR(x) ∩atomsR(y) = ∅holds. Analogously, if y occurs in only one atom of body(R)
then either atomsR(y) ⊆atomsR(x) or atomsR(x) ∩atomsR(y) = ∅holds.
Let us finally assume that both x and y occur in at least two atoms of body(R) each.
Thanks to C being a consistent cover partition and Condition (2) of Definition 4.2, x and y
are bridge variables, and occur in atom sets of at least two different cover descriptions of C
each.
Since Q is hierarchical we have the following three cases.
Case 1: atomsQ(x) ⊆atomsQ(y). Let (A, V, α, ψ) in C be a cover description which fulfils
x ∈α(head(V )). In particular, x occurs in an atom A ∈A. Therefore, y also occurs
in A, since atomsQ(x) ⊆atomsQ(y). Since y is a bridge variable by assumption, it
follows that y ∈α(head(V )) thanks to Condition (2) of Definition 4.2. We conclude
that atomsR(x) ⊆atomsR(y) holds.
Case 2: atomsQ(y) ⊆atomsQ(x). This case is analogous to the first case.
Case 3: atomsQ(x) ∩atomsQ(y) = ∅. If there is no cover description in C, in which x and
y occur together, then atomsR(x) ∩atomsR(y) = ∅holds. Let us thus assume that
there is a cover description (A, V, α, ψ) in C in which both x and y occur. Thanks to
atomsQ(x) ∩atomsQ(y) = ∅, set A contains at least two atoms. Thanks to Lemma 7.3,
there is a variable u /∈vars(head(α(V ))) that appears in all atoms of A. Since Q is
hierarchical, we must have atomsQ(x) ⊊atomsQ(u). However, this yields a contradiction,
because x occurs in at least two cover descriptions, and therefore outside A, whereas u
does not.
This concludes the proof of Statement (a).
Towards (b), let us assume that Q is q-hierarchical. Our goal is to show that for all
variables x, y ∈vars(R), if atomsR(x) ⊊atomsR(y) holds and x is in the head of R, then y
is also in the head of R. Note that x and y are both bridge variables because x occurs in
the head of Q which is the same as the head of R, and y occurs in at least two atoms of
body(R) due to atomsR(x) ⊊atomsR(y). In particular, x and y both occur in Q. Since the
heads of Q and R are the same, whenever atomsQ(x) ⊊atomsQ(y) holds, we can conclude
that if x is in the head of R, then y is also in the head of R.
In the remainder we assume, for the sake of a contradiction, that atomsQ(x) ⊊atomsQ(y)
does not hold. Since Q is hierarchical this means that either atomsQ(x) ⊇atomsQ(y) or
atomsQ(x) ∩atomsQ(y) = ∅holds.18
If x also occurs in at least two atoms of body(R), then the preconditions for Case 2 and
Case 3 in the proof for Statement (a) above are met. Thus, atomsQ(x) ⊇atomsQ(y) and
atomsQ(x)∩atomsQ(y) = ∅imply atomsR(x) ⊇atomsR(y) and atomsR(x)∩atomsR(y) = ∅,
respectively. But this is a contradiction to atomsR(x) ⊊atomsR(y).
In the remainder, consider the case that x occurs in exactly one atom B of body(R).
Variable y occurs in B and outside B.
Since x and y are bridge variables, it follows
that x occurs in exactly one atom set A of C and y occurs in and outside A. Hence,
atomsQ(x) ∩atomsQ(y) = ∅holds because atomsQ(x) ⊇atomsQ(y) cannot. This implies
that A consists of at least two atoms, since x and y co-occur in A. Therefore, there is a
non-bridge variable u that occurs in all atoms of A thanks to Lemma 7.3(B). But then
18Note, that the case atomsQ(x) = atomsQ(y) is a special case of atomsQ(x) ⊇atomsQ(y).

---

Vol. 19:4
REWRITING WITH ACYCLIC QUERIES: MIND YOUR HEAD
17:29
atomsQ(x) ⊊atomsQ(u) holds, and, since u is a non-head variable, x is a non-head variable
as well, because Q is q-hierarchical. This is a contradiction to x being a head variable.
All in all, we can conclude that atomsQ(x) ⊊atomsQ(y) holds, and therefore, that y is
a head variable. Thus, R is q-hierarchical.
Similarly to Theorem 5.4, Theorem 7.2 delivers good news as well as bad news. The good
news is that, since QHCQ ⊆CCQ and QHCQ ⊆HCQ ⊆ACQ hold, the rewriting problem
for q-hierarchical views and hierarchical queries over a fixed schema is tractable thanks to
Theorem 6.2 and Theorem 7.2. The bad news is that Theorem 5.7 and Theorem 7.2 imply
NP-completeness for hierarchical queries and views.
Corollary 7.4. Rewrk(QHCQ, HCQ, HCQ) and Rewrk(QHCQ, QHCQ, QHCQ) are in poly-
nomial time for every k ∈N.
Corollary 7.5. Rewrk(HCQ, HCQ, HCQ) is NP-complete for every k ≥3.
Of course, Corollary 7.5 implies NP-hardness of Rewrk(V, Q, ACQ), for all pairs V, Q
of classes with HCQ ⊆V ⊆CQ and HCQ ⊆Q ⊆CQ.
8. Related Work
We already mentioned that our notion of cover partitions is similar to various notions from
the literature. We mention three of them here.
In [AC19] algorithms for finding exact rewritings with a minimal number of atoms
and (maximally) contained rewritings are presented. For this purpose triples (S, S′, h) are
considered which are comparable to cover descriptions [AC19, Definition 3.12]. Namely, S′
corresponds to the set A in a cover description, S = body(Q), and h is a homomorphism
from S′ into a view V . In our characterisation we can assume h = id (and, thus, omit it in the
specification of a cover description) thanks to the view application α. We note that h can be
assumed to be one-to-one for (equivalent) V-rewritings [AC19, Theorem 3.15]. Furthermore,
for (equivalent) rewritings, only candidates whose body is a proper subset of the canonical
rewriting’s body are considered (cf. [AC19, Section 3.2.3]). Note that the existence of body
homomorphisms ψi mapping the αi(Vi) into Q is guaranteed for such candidates and ψi
determines the application αi (in particular, the unification of variables in the head of a
view). This is, however, too restrictive for our purposes (cf., for instance, Example 5.1)
which is why α and ψ are part of a cover description. We emphasise that Condition (2)
is equivalent to the shared-variable property [AC19, Definition 3.12]. An analogue of the
implication (a) ⇒(b) of Theorem 4.6 is proven [AC19, Theorem 3.15] and, based on that,
an algorithm CoreCover for finding (equivalent) rewritings is derived. This algorithm,
however, considers only triples with maximal sets S′ (called tuple cores) and they are allowed
to overlap, i.e. they do not have to form a partition. In contrast, we consider non-maximal
sets, for instance in the proof of Theorem 5.4 which depends upon the possibility to split
these sets. For (maximally) contained rewritings, an analogue of (b) ⇒(a) is implied by
[AC19, Theorem 4.19]. Interestingly, the proof of this result (and the associated algorithm)
exploits triples with minimal sets S′ (that still satisfy the shared-variable property) and a
partition property. We discuss the relation of this minimality constraint with our results
below in more detail. An analogue of (b) ⇒(a) for (equivalent) V-rewritings, and, therefore,
a characterisation for V-rewritability, is not stated (nor implied).

---

17:30
G. Geck, J. Keppeler, T. Schwentick, and C. Spinrath
Vol. 19:4
In [GKC06] a characterisation for V-rewritability is employed to find rewritings efficiently.
It is in terms of tuple coverages and a partition condition corresponding to cover descriptions
and partitions, respectively [GKC06, Theorem 5, Theorem 6]. A tuple coverage, denoted
s(tV , Q), is a (non-empty) set G, where tV corresponds to α(V ) and G to the set A of a
cover description. Similar to [AC19] the most crucial differences in comparison with our
characterisation are that only rewritings whose body is contained in the canonical rewriting,
i.e. vars(α(V )) ⊆vars(Q) holds for all tuple coverages, are considered. Also the mappings
ψ and α and their associated conditions are not denoted explicitly, instead it is required
that G is isomorphic to a subset of α(V ) and Condition (2) holds. This is equivalent to our
conditions if restricted to the rewritings considered in [GKC06].
Lastly, in [PH01] MiniCon descriptions (MCDs) are used to compute (maximally)
contained rewritings (which are unions of conjunctive queries, in general). A MCD is a
tuple of the form (h, V, φ, G) which relates to a cover description (A, V, α, ψ) as follows: h
is called a head homomorphism and is basically the restriction of an application α to the
head variables of the view V , G corresponds to the set A, and φ is mapping embedding
G into h(V ). The component φ has no counterpart in a cover description because, thanks
to α being able to rename any variable in V , we can assume φ = id. We note that the
applications αi of a consistent cover partition C also allow us to conveniently denote the
expansion of the associated rewriting QC. On the other hand, there is no counterpart for the
body-homomorphism ψ in a MCD (since the ψi in a consistent cover partition ensure that
the query is contained in the associated expansion of the rewriting, there is also no need for
them if contained rewritings are considered). Condition (2) is stated as [PH01, Property 1]
and the idea of a cover partition in [PH01, Property 2].
Minimal cover descriptions. In [AC19], “minimal” triples are used to construct maximally
contained rewritings. In terms of cover descriptions, an analogous definition of minimality is
as follows.
Definition 8.1 (Minimal Cover Descriptions). A cover description (A, V, α, ψ) for a query
Q is called minimal if there is no partition A1 ⊎· · · ⊎Ak = A for k ≥2 with nonempty
subsets A1, . . . , Ak such that cover descriptions C1, . . . , Ck with Ci = (Ai, V, αi, ψi) for Q
exist.
It seems obvious to exploit such minimal cover description for the constructions in
Theorem 5.4 and Theorem 7.2, instead of partitioning the set A of a cover description
“manually”. However, in contrast to our constructions, this would (possibly) not result in
efficient algorithms to compute an acyclic or hierarchical rewriting from an arbitrary one,
since it turns out that deciding whether a cover description is minimal is coNP-hard.
Proposition 8.2. Let Q be a hierarchical conjunctive query. It is coNP-hard to decide
whether a cover description (A, Q, α, ψ) is minimal.
Proof. We reduce the problem Rewr(HCQ, HCQ, CQ), which is NP-hard due to Theorem 5.7,
to the complement of the minimisation problem. For a hierarchical query Q and a set of
hierarchical views V, we describe how we can derive a cover description CQ
V and a query Q′
such that CQ
V is not minimal for Q′ if and only if there is a V-rewriting for Q.
For convenience, we introduce some notation. For an atom A = R(x1, . . . , xr) and a
variable u we denote by Au the atom R(u, x1, . . . , xr) resulting from extending A by the

---

Vol. 19:4
REWRITING WITH ACYCLIC QUERIES: MIND YOUR HEAD
17:31
variable u. We lift this notation to sets A of atoms in the natural way, i.e.
Au = {R(u, x1, . . . , xr) | R(x1, . . . , xr) ∈A} .
If a set of atoms or a query consists of atoms extended by (possibly different) variables as
described above, we often signify this with a “+”-symbol in the superscript, e.g. we write A+.
Let V1, . . . , Vn be the views in V. We assume that the views in V and the query Q refer
to distinct variables, which is no restriction since the variables can be renamed accordingly
in polynomial time.
Construction. We start with the construction of the cover description CQ
V . To define a
view and a query for the cover description, we consider views V +
1 , . . . , V +
n that are copies
of the input views V1, . . . , Vn where each atom will be expanded by a special variable, that
only appears in the associated view, in the first component of each body atom and of the
head, i.e. for every i ∈{1, . . . , n} we define a view V +
i
with head(V +
i ) = head(Vi)vi and
body(V +
i ) = body(Vi)vi where v1, . . . , vn are distinct variables that do not occur in the
query or in any of the views in V. In the same fashion, we define a set of atoms for the
atoms in the query, but we add a new atom whose relation symbol does not occur in Q
or in any of the views in V. For a new variable u and a new relation symbol S, we define
A+
Q = body(Q)u ∪{S(u)}.
Let us now turn to the definition of the view W that is used in the cover description.
The view W contains the atoms in A+
Q, the atoms in body(V +
i ) for all i ∈{1, . . . , n}, and a
special atom S(vn+1) with a new variable vn+1 in the body. The head of W contains the
variables in the head of Q and variables in the heads of the views Vi for all i ∈{1, . . . , n} as
well as the variables v1, . . . , vn+1 , but not u. Let us emphasize that, for each view V +
i , the
set body(V +
i ) is contained in body(W).
The query Q′ is defined by the rule head(Q) ←body(W), that is Q′ has the head
variables of Q and the body of Q′ has the same atoms as the body of W.
The cover description CQ
V is defined as (A+
Q, W, id, id). Note that the bridge variables
of A+
Q with respect to Q′ are contained in the head variables in W. Hence, CQ
V is a cover
description for Q′.
Note that the views V +
i
are hierarchical since for the new variables vi we have that
atomsV +
i (vi) ⊇atomsV +
i (y) for all y ∈vars(Vi) and the input views are hierarchical. The
same is true for the set A+
Q (viewed as a Boolean query here). Moreover, W and Q′ are also
hierarchical since the views and the query, and, hence, the V +
i
and A+
Q do not share any
variable.
Correctness. In the following, we show that Q has a V-rewriting if and only if CQ
V for Q′
is not minimal.
For the only if-direction assume that Q has a V-rewriting. Then there is a consistent
cover partition C for Q. Note that by construction each cover description (A, Vj, α, ψ) in
C can be turned into a cover description (Au, V +
j , α ∪{vj 7→u}, ψ ∪{u 7→u}) for Q′ and,
furthermore into a cover description (Au, W, α′, ψ′) for Q′ where α′ and ψ′ coincide with
α ∪{vj 7→u} and ψ ∪{u 7→u} on their domain, respectively, and are the identity on all
other variables. Let C′ be the collection of cover descriptions we obtain by transforming
every cover description in C to a cover description as described above and the additional
cover description ({S(u)}, W, {vn+1 7→u}, id) for Q′.

---

17:32
G. Geck, J. Keppeler, T. Schwentick, and C. Spinrath
Vol. 19:4
Since C is a cover partition for Q and Q does not contain an S-atom, the atom sets
of the cover descriptions in C′ form a partition of A+
Q = body(Q)u ∪{S(u)}. But then
(A+
Q, W, id, id) is not minimal for Q′ because C′ consists of at least two cover descriptions.
For the if-direction assume that CQ
V is not minimal for Q′. Let
C′ = (A+
1, W, α1, ψ1), . . . , (A+
k, W, αk, ψk)
be a collection of cover descriptions witnessing that CQ
V = (A+
Q, W, id, id) is not minimal for
Q′. From C′ we will derive a cover partition C for Q witnessing that Q is indeed V-rewritable.
For this purpose, we first analyse to which atoms in αi(W) the atoms of a set A+
i are mapped
to and then associate views V +
j with (subsets of) the sets A+
i .
We can assume that the αi fulfil the quantified variable disjointness. Note, that k ≥2
since CQ
V is not minimal, and u is a bridge variable of each set A+
i since it occurs in
every atom in A+
Q. Therefore, no atom in A+
i can be mapped into the copy of αi(A+
Q)
in αi(W) because the variable u is not a head variable of W. Hence, A+
i is a subset of
αi(body(V1)v1) ∪. . . ∪αi(body(Vn)vn) ∪{αi(S(vn+1))}.
Since the sets αi(body(Vj)vj) do not share any variable that is not in the head(αi(W)),
each cover description in C′ can be partitioned into cover descriptions
(B+
i,1, W, αi, ψi), . . . , (B+
i,n, W, αi, ψi)
for Q′ where B+
i,j = A+
i ∩αi(body(Vj)vj) and, in case S(u) ∈A+
i , a cover description
({S(u)}, W, αi, ψi). For the sake of readability we assume that B+
i,j̸ = ∅holds for all i, j. If
not, the respective cover descriptions can just be removed from the sequence.
Note that the view W in a cover description (B+
i,j, W, αi, ψi) can be replaced by V +
j ,
because B+
i,j ⊆αi(body(V +
j )) by definition. Hence, each cover description (B+
i,j, W, αi, ψi)
can be transformed into a cover description (B+
i,j, V +
j , αi,j, ψi,j) where αi,j and ψi,j are the
restriction of αi and ψi resp. on vars(V +
j ). A cover description (B+
i,j, V +
j , αi,j, ψi,j) can, in
turn, be transformed into a cover description (Bi,j, Vj, bαi,j, bψi,j) for Q where Bi,j is the atom
set with Bvj
i,j = B+
i,j, and bαi,j and bψi,j are the restriction of αi,j and ψi,j on vars(Vj).
Let C be the collection of cover descriptions we obtain by applying the transformations
described above to all cover descriptions in C′ and removing cover descriptions with atom
set {S(u)}. Note, that by construction, the atom sets in C′ form a partition of body(Q).
Thus C′ is a cover partition and hence, Q is V-rewritable.
Applications of structurally simple queries. It is well known that many problems are
tractable for acyclic conjunctive queries but (presumably) not for conjunctive queries in
general. Notably, the evaluation, minimisation, and the containment problem are tractable
for acyclic queries [Yan81, CR00, GLS01] but NP-complete for the class of conjunctive
queries [CM77].
The class of free-connex conjunctive queries plays a central role in the enumeration
complexity of conjunctive queries. In [BDG07], Bagan, Durand and Grandjean showed that
the result of a free-connex acyclic conjunctive query can be enumerated with constant delay
after a linear time preprocessing phase. Moreover, they also showed that the result of an
acyclic conjunctive query without self-joins that is not free-connex cannot be enumerated
with constant delay after a linear time preprocessing, unless n×n matrices can be multiplied
in time O(n2).

---

Vol. 19:4
REWRITING WITH ACYCLIC QUERIES: MIND YOUR HEAD
17:33
Hierarchical queries play a central role in different contexts. On the one hand, Dalvi
and Suciu [DS07] showed that the class of hierarchical Boolean conjunctive queries without
self-joins characterises precisely the Boolean CQs without self-joins that can be answered in
polynomial time on probabilistic databases. This has been extended by Fink and Olteanu
[FO14] to the notion of non-Boolean queries and queries with negation. On the other hand,
Koutris and Suciu [KS11] studied hierarchical join queries in the context of query evaluation
on massively parallel architectures. We refer to [FO16] for further applications of hierarchical
queries.
The notion of q-hierarchical queries has played a central role in the evaluation of
conjunctive queries under single tuple updates [BKS17]. In [BKS17] it is shown that the
result of a q-hierarchical conjunctive query can be evaluated (by answering a Boolean CQ
in constant time, enumerating the result of a non-Boolean CQ with constant delay, or
outputting the number of results in constant time) with constant update time after a linear
time preprocessing. Moreover, they showed that the result of a conjunctive query without
self-joins that is not q-hierarchical cannot be evaluated with constant update time after
a linear time preprocessing, unless some algorithmic conjectures on Online Matrix-Vector
multiplication (see [HKNS15] for more information about the conjecture) do not hold. The
notion of q-hierarchical queries is also related to factorised databases [Kep20]. The notion of
factorised databases has already been considered in various contexts [OZ15, BKOZ13, SOC16].
A further recent source of information on structurally simple queries is [KNOZ20].
9. Conclusion
We studied rewritability by acyclic queries or queries from CCQ, HCQ, or QHCQ. Based on
a new characterisation of (exact) rewritability, we showed that acyclic queries have acyclic
rewritings, if they have any CQ rewriting. The same holds for the other three query classes.
We showed that for acyclic queries and views the decision problem, whether an acyclic
rewriting exists, is intractable, even for schemas with bounded arity, but becomes tractable if
views have a bounded arity (even with unbounded schema arity) or are free-connex acyclic.
We leave the case of free-connex acyclic views and unbounded schemas open. Another
interesting open question is the complexity of rewriting problems Rewr(V, Q, R) with R ⊊Q,
e.g. Rewr(ACQ, ACQ, QHCQ).
So far we have only NP-hardness results for problems
Rewr(V, Q, ACQ) and Rewr(V, Q, HCQ) where V and Q encompass all acyclic or all
hierarchical queries, respectively.
Finally, it would be interesting to study whether our results can be extended to other
classes of queries that can be evaluated efficiently like conjunctive queries of bounded
treewidth.
References
[AC19]
Foto N. Afrati and Rada Chirkova. Answering Queries Using Views, Second Edition. Syn-
thesis Lectures on Data Management. Morgan & Claypool Publishers, 2019. doi:10.2200/
S00884ED2V01Y201811DTM054.
[AHV95]
Serge Abiteboul, Richard Hull, and Victor Vianu. Foundations of Databases. Addison-Wesley,
1995. URL: http://webdam.inria.fr/Alice/.
[BB13]
Johann Brault-Baron. De la pertinence de l’´enum´eration : complexit´e en logiques propositionnelle
et du premier ordre. Theses, Universit´e de Caen, 2013. URL: https://hal.archives-ouvertes.
fr/tel-01081392.

---

17:34
G. Geck, J. Keppeler, T. Schwentick, and C. Spinrath
Vol. 19:4
[BDG07]
Guillaume Bagan, Arnaud Durand, and Etienne Grandjean. On acyclic conjunctive queries
and constant delay enumeration. In Jacques Duparc and Thomas A. Henzinger, editors,
Computer Science Logic, 21st International Workshop, CSL 2007, 16th Annual Conference
of the EACSL, Lausanne, Switzerland, September 11-15, 2007, Proceedings, volume 4646
of Lecture Notes in Computer Science, pages 208–222. Springer Berlin Heidelberg, 2007.
doi:10.1007/978-3-540-74915-8_18.
[BKOZ13]
Nurzhan Bakibayev, Tom´as Kocisk´y, Dan Olteanu, and Jakub Zavodny. Aggregation and
ordering in factorised databases. Proceedings of the VLDB Endowment, 6(14):1990–2001, 2013.
doi:10.14778/2556549.2556579.
[BKS17]
Christoph Berkholz, Jens Keppeler, and Nicole Schweikardt. Answering conjunctive queries under
updates. In Emanuel Sallinger, Jan Van den Bussche, and Floris Geerts, editors, Proceedings of the
36th ACM SIGMOD-SIGACT-SIGAI Symposium on Principles of Database Systems, PODS 2017,
Chicago, IL, USA, May 14-19, 2017, pages 303–318. ACM, 2017. doi:10.1145/3034786.3034789.
[BPR17]
Pablo Barcel´o, Andreas Pieris, and Miguel Romero. Semantic optimization in tractable classes of
conjunctive queries. ACM SIGMOD Record, 46(2):5–17, 2017. doi:10.1145/3137586.3137588.
[CGLP20a] Hubie Chen, Georg Gottlob, Matthias Lanzinger, and Reinhard Pichler. Semantic width and the
fixed-parameter tractability of constraint satisfaction problems. In Christian Bessiere, editor,
Proceedings of the Twenty-Ninth International Joint Conference on Artificial Intelligence, IJCAI
2020, pages 1726–1733. International Joint Conferences on Artificial Intelligence Organization,
2020. doi:10.24963/ijcai.2020/239.
[CGLP20b] Hubie Chen, Georg Gottlob, Matthias Lanzinger, and Reinhard Pichler. Semantic width and the
fixed-parameter tractability of constraint satisfaction problems. CoRR, abs/2007.14169, 2020.
URL: https://arxiv.org/abs/2007.14169, arXiv:2007.14169.
[CGLV05]
Diego Calvanese, Giuseppe De Giacomo, Maurizio Lenzerini, and Moshe Y. Vardi. View-based
query processing: On the relationship between rewriting, answering and losslessness. In Thomas
Eiter and Leonid Libkin, editors, Database Theory - ICDT 2005, 10th International Conference,
Edinburgh, UK, January 5-7, 2005, Proceedings, volume 3363 of Lecture Notes in Computer
Science, pages 321–336. Springer Berlin Heidelberg, 2005. doi:10.1007/978-3-540-30570-5_22.
[CM77]
Ashok K. Chandra and Philip M. Merlin. Optimal implementation of conjunctive queries in
relational data bases. In John E. Hopcroft, Emily P. Friedman, and Michael A. Harrison, editors,
Proceedings of the 9th Annual ACM Symposium on Theory of Computing, May 4-6, 1977, Boulder,
Colorado, USA, pages 77–90. ACM Press, 1977. doi:10.1145/800105.803397.
[CR00]
Chandra Chekuri and Anand Rajaraman. Conjunctive query containment revisited. Theor.
Comput. Sci., 239(2):211–229, 2000. doi:10.1016/S0304-3975(99)00220-0.
[CY12]
Rada Chirkova and Jun Yang. Materialized views. Foundations and Trends® in Databases,
4(4):295–405, 2012. doi:10.1561/1900000020.
[DS07]
Nilesh N. Dalvi and Dan Suciu. The dichotomy of conjunctive queries on probabilistic structures.
In Leonid Libkin, editor, Proceedings of the Twenty-Sixth ACM SIGACT-SIGMOD-SIGART
Symposium on Principles of Database Systems, June 11-13, 2007, Beijing, China, pages 293–302.
ACM, 2007. doi:10.1145/1265530.1265571.
[FO14]
Robert Fink and Dan Olteanu. A dichotomy for non-repeating queries with negation in prob-
abilistic databases. In Richard Hull and Martin Grohe, editors, Proceedings of the 33rd ACM
SIGMOD-SIGACT-SIGART Symposium on Principles of Database Systems, PODS’14, Snowbird,
UT, USA, June 22-27, 2014, pages 144–155. ACM, 2014. doi:10.1145/2594538.2594549.
[FO16]
Robert Fink and Dan Olteanu. Dichotomies for queries with negation in probabilistic databases.
ACM Transactions on Database Systems, 41(1):4:1–4:47, 2016. doi:10.1145/2877203.
[GKC06]
Gang Gou, Maxim Kormilitsin, and Rada Chirkova. Query evaluation using overlapping views:
completeness and efficiency. In Surajit Chaudhuri, Vagelis Hristidis, and Neoklis Polyzotis, editors,
Proceedings of the ACM SIGMOD International Conference on Management of Data, Chicago,
Illinois, USA, June 27-29, 2006, pages 37–48. ACM, 2006. doi:10.1145/1142473.1142479.
[GKSS22]
Gaetano Geck, Jens Keppeler, Thomas Schwentick, and Christopher Spinrath. Rewriting with
Acyclic Queries: Mind Your Head. In Dan Olteanu and Nils Vortmeier, editors, 25th International
Conference on Database Theory (ICDT 2022), volume 220 of Leibniz International Proceedings
in Informatics (LIPIcs), pages 8:1–8:20, Dagstuhl, Germany, 2022. Schloss Dagstuhl – Leibniz-
Zentrum f¨ur Informatik. doi:10.4230/LIPIcs.ICDT.2022.8.

---

Vol. 19:4
REWRITING WITH ACYCLIC QUERIES: MIND YOUR HEAD
17:35
[GLS01]
Georg Gottlob, Nicola Leone, and Francesco Scarcello. The complexity of acyclic conjunctive
queries. Journal of the ACM, 48(3):431–498, 2001. doi:10.1145/382780.382783.
[Hal01]
Alon Y. Halevy. Answering queries using views: A survey. The VLDB Journal, 10(4):270–294,
2001. doi:10.1007/s007780100054.
[HKNS15]
Monika Henzinger, Sebastian Krinninger, Danupon Nanongkai, and Thatchaphol Saranurak.
Unifying and strengthening hardness for dynamic problems via the online matrix-vector mul-
tiplication conjecture. In Rocco A. Servedio and Ronitt Rubinfeld, editors, Proceedings of the
Forty-Seventh Annual ACM on Symposium on Theory of Computing, STOC 2015, Portland,
OR, USA, June 14-17, 2015, pages 21–30. ACM, 2015. doi:10.1145/2746539.2746609.
[HY19]
Xiao Hu and Ke Yi. Instance and output optimal parallel algorithms for acyclic joins. In Dan
Suciu, Sebastian Skritek, and Christoph Koch, editors, Proceedings of the 38th ACM SIGMOD-
SIGACT-SIGAI Symposium on Principles of Database Systems, PODS 2019, Amsterdam, The
Netherlands, June 30 - July 5, 2019, pages 450–463. ACM, 2019. doi:10.1145/3294052.3319698.
[IUV17]
Muhammad Idris, Mart´ın Ugarte, and Stijn Vansummeren. The dynamic yannakakis algorithm:
Compact and efficient query processing under updates. In Semih Salihoglu, Wenchao Zhou,
Rada Chirkova, Jun Yang, and Dan Suciu, editors, Proceedings of the 2017 ACM International
Conference on Management of Data, SIGMOD Conference 2017, Chicago, IL, USA, May 14-19,
2017, pages 1259–1274. ACM, 2017. doi:10.1145/3035918.3064027.
[Kep20]
Jens Keppeler. Answering Conjunctive Queries and FO+MOD Queries under Updates. PhD
thesis, Humboldt University of Berlin, Germany, 2020. doi:10.18452/21483.
[KNOZ20]
Ahmet Kara, Milos Nikolic, Dan Olteanu, and Haozhe Zhang. Trade-offs in static and dynamic
evaluation of hierarchical queries. In Dan Suciu, Yufei Tao, and Zhewei Wei, editors, Proceedings
of the 39th ACM SIGMOD-SIGACT-SIGAI Symposium on Principles of Database Systems,
PODS 2020, Portland, OR, USA, June 14-19, 2020, pages 375–392. ACM, 2020. doi:10.1145/
3375395.3387646.
[KS06]
Benny Kimelfeld and Yehoshua Sagiv. Incrementally computing ordered answers of acyclic
conjunctive queries. In Opher Etzion, Tsvi Kuflik, and Amihai Motro, editors, Next Generation
Information Technologies and Systems, 6th International Workshop, NGITS 2006, Kibbutz
Shefayim, Israel, July 4-6, 2006, Proceedings, volume 4032 of Lecture Notes in Computer Science,
pages 141–152. Springer Berlin Heidelberg, 2006. doi:10.1007/11780991_13.
[KS11]
Paraschos Koutris and Dan Suciu. Parallel evaluation of conjunctive queries. In Maurizio Lenzerini
and Thomas Schwentick, editors, Proceedings of the 30th ACM SIGMOD-SIGACT-SIGART
Symposium on Principles of Database Systems, PODS 2011, June 12-16, 2011, Athens, Greece,
pages 223–234. ACM, 2011. doi:10.1145/1989284.1989310.
[LMSS95]
Alon Y. Levy, Alberto O. Mendelzon, Yehoshua Sagiv, and Divesh Srivastava. Answering queries
using views. In Mihalis Yannakakis and Serge Abiteboul, editors, Proceedings of the Fourteenth
ACM SIGACT-SIGMOD-SIGART Symposium on Principles of Database Systems, May 22-25,
1995, San Jose, California, USA, pages 95–104. ACM Press, 1995. doi:10.1145/212433.220198.
[NSV10]
Alan Nash, Luc Segoufin, and Victor Vianu. Views and queries: Determinacy and rewriting. ACM
Transactions on Database Systems, 35(3):21:1–21:41, 2010. doi:10.1145/1806907.1806913.
[OZ15]
Dan Olteanu and Jakub Z´avodn´y. Size bounds for factorised representations of query results.
ACM Transactions on Database Systems, 40(1):2:1–2:44, 2015. doi:10.1145/2656335.
[PH01]
Rachel Pottinger and Alon Y. Halevy. Minicon: A scalable algorithm for answering queries using
views. The VLDB Journal, 10(2-3):182–198, 2001. doi:10.1007/s007780100048.
[SOC16]
Maximilian Schleich, Dan Olteanu, and Radu Ciucanu. Learning linear regression models over
factorized joins. In Fatma ¨Ozcan, Georgia Koutrika, and Sam Madden, editors, Proceedings of
the 2016 International Conference on Management of Data, SIGMOD Conference 2016, San
Francisco, CA, USA, June 26 - July 01, 2016, pages 3–18. ACM, 2016. doi:10.1145/2882903.
2882939.
[Yan81]
Mihalis Yannakakis. Algorithms for acyclic database schemes. In Very Large Data Bases, 7th
International Conference, September 9-11, 1981, Cannes, France, Proceedings, pages 82–94.
IEEE Computer Society, 1981.
This work is licensed under the Creative Commons Attribution License. To view a copy of this
license, visit https://creativecommons.org/licenses/by/4.0/ or send a letter to Creative
Commons, 171 Second St, Suite 300, San Francisco, CA 94105, USA, or Eisenacher Strasse 2,
10777 Berlin, Germany

---

