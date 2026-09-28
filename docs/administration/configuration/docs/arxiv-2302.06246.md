# Incremental Consistent Updating of Incomplete Databases

> 来源: https://arxiv.org/pdf/2302.06246

arXiv:2302.06246v1  [cs.DB]  13 Feb 2023
Incremental Consistent Updating of Incomplete Databases
(Extended Version - Technical Report)
Jacques Chabin
, Mirian Halfeld Ferrari
LIFO – Universit´e d’Orl´eans, INSA CVL – Orl´eans, France
Nicolas Hiot
LIFO – Universit´e d’Orl´eans, INSA CVL – Orl´eans, France
EnnovLabs – Ennov – Paris, France
Dominique Laurent
ETIS – CNRS, ENSEA, CY Universit´e – Cergy-Pontoise, France
February 14, 2023
Abstract
Eﬃcient consistency maintenance of incomplete and dynamic real-life databases is a quality
label for further data analysis.
In prior work, we tackled the generic problem of database
updating in the presence of tuple generating constraints from a theoretical viewpoint.
The
current paper considers the usability of our approach by (a) introducing incremental update
routines (instead of the previous from-scratch versions) and (b) removing the restriction that
limits the contents of the database to ﬁt in the main memory. In doing so, this paper oﬀers
new algorithms, proposes queries and data models inviting discussions on the representation of
incompleteness on databases. We also propose implementations under a graph database model
and the traditional relational database model. Our experiments show that computation times
are similar globally but point to discrepancies in some steps.
1
Introduction
Incremental update algorithms are essential for incomplete real-life databases, often large and con-
stantly updated. Modern applications usually involve the analysis of large amounts of data with
missing and changing values. The quality of this analysis depends on the consistency of the data,
the maintenance of which requires calculations whose cost needs to be reduced.
To address this problem, we build upon our prior work [9] where the generic problem of database
updating in the presence of constraints was tackled from a theoretical point of view, and under the
restriction that the database content was meant to ﬁt in main memory. Hence, for missing values, we
follow Reiter [28] who provides FOL (First-Order Logic) semantics to null values of type ‘value exists
but is currently unknown’. Constraints are expressed as tuple-generating dependencies (tgd), i.e.,
implications of the form (∀X, Y )(B(X, Y ) ⇒(∃Z)L(X, Z)) where X, Y , Z are vectors of variables,
B(X, Y ) is the conjunction of atoms of the form Li(Xi, Yi) where Xi and Yi are sub-vectors of X
and Y , respectively, and L(X, Z) is an atom.
1

---

In [9], our purpose was to allow for the insertions or the deletions of sets of tuples under the
following hypotheses:
• A ﬁxed set C of constraints as speciﬁed just above is assumed over a given set of predicates.
• The database D to be updated is a set of instantiated atoms, in which marked nulls may occur.
Moreover, the database contains no redundancies caused by these nulls.
• D satisﬁes the constraints in C, meaning that, for every c in C, whenever there exists an
instantiation h of X and Y such that D contains all atoms in h(B(X, Y )) then h can be
extended to Z so as D also contains h(L(X, Z)).
• The updated database D′ satisﬁes the constraints in C and is not redundant, while being such
that the updates are performed, that is, all atoms to be inserted are present in D′ and no
atoms to be deleted is present in D′.
In this paper, we improve our work in [9] in two main aspects: (1) we propose an incremental
version of the approach and (2) we deal with data stored in database systems, contrary to the
in-memory version of [9].
Given an update u over a database instance D, our approach consists in generating (by the
activation of constraints in C) a set of new updates, U ′, as necessary side-eﬀects to maintain the
database consistent. Contrary to from scratch algorithms, whereby the whole database instance and
the whole set C are involved in the generation of U ′, incremental algorithms minimize the amount
of data to be accessed and the constraints to be triggered.
Paper Organisation. We overview our approach and its evolution (from scratch towards an incre-
mental approach) through a motivating example in Section 2. Section 3 provides some background.
Section 4 introduces the operations over which the incremental core computation is built. Incre-
mental update algorithms, their implementation aspects and experimental results are introduced,
respectively in Sections 5, 6 and 7. After presenting related work in Section 8, Section 9 concludes
the paper.
2
Motivating Example
Figure 1 shows a set of constraints in the context of a university, researchers and students. Although
the intuitive meaning of these constraints should be clear, we point out that in the constraints c6,
c9, c10, c11 and c12, the right hand-side involves a variable not present in the left hand-side. Due
to such contraints, known in the literature as tuple generating dependencies (tgd), nulls values may
appear in the database instance, as explained below. Their intuitive meaning is as follows:
• the variable Z in PhDPaper(Y, P, Z) of c6 stands for the year the paper has been published;
• the variable Y in Cites(X, Y ) of c9 stands for a publication cited by publication X;
• the variable Y in Enrolled(X, Y ) of c10 stands for a course student X is enrolled in;
• the variable Z in Degree(Y, Z) of c11 stands for the degree course Y is part of;
• the variable Z in Language(X, Y, Z) of c12 stands for the language in which is taught course
X of degree Y .
2

---

c1 : Supervises(X, Y ) →Researcher(X)
c2 : Supervises(X, Y ) →Student(Y )
c3 : Authors(X, Y ) →Researcher(X)
c4 : Authors(X, Y ) →Publication(Y )
c5 : Researcher(X) →Authors(X, Y )
c6 : Supervises(X, Y ), Authors(X, P),
Authors(Y, P) →PhDPaper(Y, P, Z)
c7 : Cites(X, Y ) →Publication(X)
c8 : Cites(X, Y ) →Publication(Y )
c9 : Publication(X) →Cites(X, Y )
c10 : Student(X) →Enrolled(X, Y )
c11 : Enrolled(X, Y ) →Degree(Y, Z)
c12 : Degree(X,Y ) →Language(X, Y, Z)
c13 : Enrolled(X, Y ) →GrantEligible(X)
Figure 1: Set of (general) constraints
Constraints from this set are used in subsequent examples to illustrate our proposes throughout
the paper. Let us start with C = {c1, . . . , c6} over the following database instance D:
D = { Researcher(Elin), Authors(Elin, P269), Publication(P235), Authors(Sten, P269),
Publication(P269), Student(Sten), Supervises(Elin, Sten), Researcher(Nils),
PhDPaper(Sten, P269, 2022) }
(A) Constraint satisfaction. First, constraints c1 and c2 are satisﬁed, because Supervises(Elin,
Sten), Researcher(Elin) and Sudent(Sten) are in D. Constraint c4 is satisﬁed as well because
Publication(P269) is in D. Similarly, c6 is satisﬁed because D contains PhDPaper(Sten, P269, 2022).
However, c3 is not satisﬁed because Authors(Sten, P269) is in D and Researcher(Sten) is not.
Similarly, c5 is not satisﬁed because Researcher(Nils) has no matching fact over Authors in D.
Constraint satisfaction is obtained by adding facts, generated by a process called chase:
1. Researcher(Sten) is added to satisfy c3.
2. In order to satisfy c5 one fact over Authors must be added, but the value of the second argument
(i.e., the publication) is unknown. Despite that publications are present in D, those authored
by Nils are unknown. Marked nulls are used to account for this situation: Authors(Nils, N1)
is added, which is read as ‘Nils authored a publication, currently unknown but recognized as
N1’. The atom Publication(N1) is then inserted in order to satisfy c4.
In this case, we obtain D′ = D ∪{Researcher(Sten), Authors(Nils, N1), Publication(N1))}.
In the following items, we show diﬀerences between the from-scratch and incremental approaches
to updates.
(B) Updates.
Updates are insertions or deletions.
(B.1) Insertions.
Given a database instance D satisfying a set of constraints C, an updated
database is the result of inserting facts in D while maintaining constraint satisfaction.
Let C1 = {c1, c6, c7, c8}, D1 = {Researcher(Elin), Supervises(Elin, Sten), Authors(Elin, P269)},
and the set of required insertions iRequest = {Authors(Sten, P269)}.
From-scratch approach. To reinforce constraints, side-eﬀects are computed through a process called
chase, that applies the constraints in C1 on D1 ∪iRequest, to generate a new set chase(D1). In
doing so, facts already in D1 might be generated again.
Incremental approach. Side-eﬀects for insertions are computed based on iRequest as follows. In our
example, the only constraint to be triggered when inserting Authors(Sten, P269) is c6 because (i)
3

---

a query on D1 informs that the atoms Supervises(Elin, Sten) and Authors(Elin, P269) already
exist in D1, and (ii) c6 is impacted by the insertion. Then, the result of the insertion is D′
1 =
D1 ∪{Authors(Sten, P269), PhDPaper(Sten, P269, N2)}.
(B.2) Deletions. Consider D′ (from item (A) above) along with the constraints in C = {c1, . . . , c6}.
From-scratch approach. After removing from D′ a given set of facts dRequest, the deletion process
includes the computation of chase(D′ \dRequest) to check constraint satisfaction. Then, if one atom
to be deleted is re-generated (up to null renaming), a backward chase is activated to identify the
side-eﬀects of the deletion. This is illustrated through the following two cases.
Case 1. Let dRequest = {PhDPaper(Sten, P269, 2022)}. First the fact PhDPaper(Sten, P269, 2022)
is removed from D′ and then, constraint satisfaction is checked as done for insertions. Here, D′ \
{PhDPaper(Sten, P269, 2022)} does not satisfy c6 because Sten is still present as an author of paper
P269.
As above, consistency is restored by inserting PhDPaper(Sten, P269, N2).
The resulting
database D′′ = (D′\ {PhDPaper(Sten, P269, 2022)}) ∪{PhDPaper(Sten, P269, N2)} is consistent
and implements the deletion because it does not contain the atom to be deleted.
Case 2. Consider now dRequest = {PhDPaper(Sten, P269, N2)} on D′′. A processing similar to
the previous one would ﬁrst remove the atom from D′′ and then, insert PhDPaper(Sten, P269, N3)
to restore consistency with respect to the constraints. This result is not acceptable because the
generated set is equal to D′′ (up to a null renaming), meaning that the deletion has not been
implemented.
In this case, the processing is carried on by deleting all atoms responsible of the
generation of the atom to be deleted.
This amounts to apply the constraints backward (from the head to the body), removing one atom
from the body, to prevent the constraint from being triggered. To this end, for every constraint c, a
literal in its body is marked as the one to be deleted in such a situation (for the sake of simplicity,
let the leftmost literal in be the marked one). Here, Authors(Elin, P269) has to be deleted, due
to c6. Then, we proceed following the ideas already presented: the latter deletion, because of c5,
requires the insertion of Authors(Elin, N4) which in turn, because of c4, requires the insertion
Publication(N4), returning the database
D2 = (D′′ \ {PhDPaper(Sten, P269, N2), Authors(Elin, P269)}) ∪
{Authors(Elin, N4), Publication(N4)}.
Incremental approach. First, a backward chase is used to ﬁnd the constraints impacted by the
required update. In our example, constraint c6, and then c5 are the only ones concerned by deletions.
Second, the chase is applied only on the rules detected just above and its result is analyzed as done
in the from-scratch approach. It is worth noting that, as data is stored in a database, queries are
used to detect whether constraints can be applied for chasing (backward or forward).
(C) Avoiding too many nulls.
An important issue regarding side eﬀects is making sure that
the processing terminates. Considering the set of constraints C1 = C ∪{c7, c8, c9} on D′, it is clear
that D′′ does not satisfy c9, because Publication(P269) and Publication(P235) belong to D′′ with
no associated citation. In order to satisfy c9, Cites(P269, N6) and Cites(P235, N7) must be inserted,
which triggers the insertions of Publication(N6) and of Publication(N7), due to c7. Then, to satisfy
c9, Cites(N6, N8) and Cites(N7, N9) have to be inserted, and we are clearly entering an inﬁnite
loop, which is not acceptable.
To cope with this diﬃculty, every null N is associated with an integer called the degree of N and
denoted by δ(N). At each insertion, the degree of all nulls occurring in D are set to 0, and when a
constraint c is applied during the processing, all generated nulls are assigned a degree equal to δ + 1
where δ is the maximal degree of the nulls in the atoms of the constraint body, or 0 if no null occurs
in the constraint body. Moreover, assuming a ﬁxed maximal null degree δmax, insertion processing
4

---

is stopped as soon as a null N is such that δ(N) ≥δmax, and the insertion is rejected, that is D is
not changed.
For example, in the case just above, we have δ(N6) = δ(N7) = 0, δ(N8) = δ(N6) + 1 = 1 and
δ(N9) = δ(N7) + 1 = 1, etc. If, for example δmax is set to 2, the generation of nulls will stop at
the next round and the insertion will be rejected. The veriﬁcation of null degree is similar in both
From-scratch and incremental approaches (it was proven in [9] that by using δmax we accept only
consistent insertions).
(D) Avoiding redundancies (core). Side eﬀects have to be computed in a minimal way to reﬂect
as much as possible the so-called minimal change requirement. To illustrate this point consider the
insertion in D′ of Authors(Nils, P235). Adding this fact in D′ provokes redundancies, because the
presence of Authors(Nils, N1) and of Publication(N1) is no longer required to ensure constraint
satisfaction. The result of this insertion is the set D′′′ deﬁned by:
D′′′ = (D′ \ {Authors(Nils, N1), Publication(N1)}) ∪{Authors(Nils, P235)}
In our implementations, redundancies in D are eliminated through the computation of the core,
seeking for mapping nulls to constants or nulls so as to detect redundant atoms. In our example,
for h such that h(N1) = P235, we have:
−h(Authors(Nils, N1)) = Authors(Nils, P235) and
−h(Publication(N1)) = Publication(P235),
showing that Authors(Nils, N1) and Publication(N1) are redundant.
From-scratch approach. Once the updates are performed on the database, the whole instance is
considered for simpliﬁcations.
Incremental approach. This new proposal aims to retrieve only the facts involved in the update
operation. For instance, for D′ as in our example, in the incremental approach a query detects that
N1 is the only null value concerned by the update. No need to work with the whole instance D′.
From-scratch and incremental approaches at a glance.
Consider the update process that
includes the general ideas explained in items (B) and (C) above. Denote, respectively, by upd and
upd|U, its from-scratch and incremental versions. More precisely, when using the upd|U policy, only
the database portion impacted by U is concerned, while the whole database is concerned by upd
policy. The expression D♦U indicates the insertion/deletion of the required updates U in/from D.
In the from-scratch approach the new instance is denoted by D′ = core(upd(D♦U)), while in the
incremental approach, the new instance is denoted by D′ = core|NullBucket(upd|U(D♦U)), where
NullBucket, is the set of nulls impacted by the update policy (upd|U) applied to D♦U.
3
Preliminaries
We recall some formal deﬁnitions already used in [9]. We assume a standard FOL alphabet composed
of three pairwise disjoint sets, namely: const, a set of constants, var, a set of variables and pred,
a set of predicates, every predicate being associated with a positive integer called its arity. In this
setting, a term is a constant or a variable and an atomic formula, or an atom, is a formula of the
form P(t1, . . . , tn) where P is a predicate of arity n and t1, . . . , tn are terms. Every atom in which
no variables occur is called a fact.
A homomorphism from a set of atoms A1 to a set of atoms A2 is a mapping h from the terms of
A1 to the terms of A2 such that: (i) if t ∈const, then h(t) = t, and (ii) if P(t1, ..., tn) is in A1, then
P(h(t1), ..., h(tn)) is in A2. The set A1 is isomorphic to the set A2 if there exists a homomorphism
h1 from A1 to A2 which admits an inverse homomorphism (from A2 to A1).
5

---

We denote by Φ the set of all formulas of the form (∃X)(ϕ1(X1) ∧. . . ∧ϕn(Xn)) where X
is a vector of variables made of all variables occurring in Xi (i = 1, . . . , n), and where for every
i = 1, . . . , n, ϕi(Xi) is an atomic formula in which the free variables are those in Xi. If φ denotes
such a formula in Φ, the set {ϕ1(X1), . . . , ϕn(Xn)} is denoted by atoms(φ).
Given φ in Φ, a model M of φ is a set of facts such that there exists a homomorphism from
atoms(φ) to M. In such a setting, for all φ1 and φ2 in Φ, φ1 ⇒φ2 holds if each model of φ1 is a
model of φ2, and as usual, φ1 and φ2 in Φ are said to be equivalent, denoted by φ1 ⇔φ2, if φ1 ⇒φ2
and φ2 ⇒φ1 both hold, that is if φ1 and φ2 have the same models.
For all φ1 and φ2 in Φ, φ1 is said to be simpler than φ2, denoted by φ1 ⪯φ2, if (i) φ1 ⇔φ2
holds, and (ii) atoms(φ1) ⊆atoms(φ2). φ1 is also said to be a simpliﬁcation of φ2. A simpliﬁcation
φ1 of φ2 is said to be minimal if φ1 ⪯φ2 and there is no φ′
1 such that φ′
1 ≺φ1. For instance, let φ
be the formula (∃x, y)(P(a, x) ∧P(a, y)); then (∃x)(P(a, x)) and (∃y)(P(a, y)) are two distinct but
equivalent simpliﬁcations of φ.
It is shown in [9] that if φ is in Φ and φ1 and φ2 two minimal simpliﬁcations of φ, then atoms(φ1)
and atoms(φ2) are isomorphic (in the literature, we ﬁnd a similar result for graphs[22]). Minimal
simpliﬁcations are also called cores and the core of a given formula φ is denoted by core(φ).
Basically, a database instance is a formula φ in Φ that cannot be simpliﬁed, i.e., such that
core(φ) = φ.
Formulas in Φ are ‘skolemized’ by replacing the variables with speciﬁc constants
referred to as Skolem constants or as (marked) nulls and by omitting the existential quantiﬁer. We
thus assume an additional set of symbols in our alphabet, denoted by null, disjoint from the sets
const and var. Now a term can be of one of the following types: either a constant, or a null, or
a variable. Any atom of the form P(t1, . . . , tn) where for every i = 1, . . . , n, ti is in const ∪null,
is called an instantiated atom. Given an instantiated atom A, denote by null(A) the set of nulls
appearing in A. Moreover, as usual, the transformed conjunctive formula is written as the set of its
conjuncts. In other words, a database instance is a set of instantiated atoms that can be written as
atoms(Sk(φ)) where Sk(φ) is the Skolem version of a formula φ in Φ such that core(φ) = φ.
4
Simpliﬁcation with Respect to Nulls: a Basic Operation
In our approach, a database D is expected to be equal to its core to avoid data redundancy. It is
thus of paramount importance to enforce this property when updating. To this end, we propose
incremental algorithms, so as to deal with as few nulls as possible, based on those involved in the
update processing.
More formally, given a set of atoms I and a set of nulls ν occurring in I, we look for a homomor-
phism h such that for every N not in ν, h(N) = N and h(I) is minimal so as h(I) ⊆I. However,
the following example shows that the choice of ν cannot be arbitrary. Indeed, given a set of nulls
ν0, with respect to which I is to be simpliﬁed, the set ν0 has to be expanded to the set ν of all nulls
‘linked’ (directly or indirectly) to a null in ν0 in some atom of I.
Example 1 Let ν0 = {N1} and I deﬁned by:
I = { Student(Alice), Enrolled(Alice, N1), Degree(N1, N2), Enrolled(Alice, Math),
Degree(Math, N3), Degree(CS, N4), Degree(CS, BSc) }
To simplify I with respect to ν0, we should eliminate redundancies in I involving N1. As N1 occurs
in Degree(N1, N2) with the other null N2, the simpliﬁcation should deal with N1 and N2. Since N1
and N2 are not linked with any other null in the atoms of I, we have ν = {N1, N2}. For h such that
h1(N1) = Math and h1(N2) = N3, we obtain a non-redundant instance I′ = h(I) deﬁned by
I′ = { Student(Alice), Enrolled(Alice, Math), Degree(Math, N3),
Degree(CS, N4), Degree(CS, BSc) }.
6

---

Notice however that simpliﬁcations involving N3 or N4 have not to be considered.
□
As shown by the above example, given I and ν0, nulls ‘linked’ in I to nulls in ν0 have to identiﬁed.
We do so through the computation for every N in ν0, of the set LinkedNullI,N as explained next.
We ﬁrst deﬁne the sequence

LinkedNullk
I,N

k≥0 by:
(i) LinkedNull0
I,N = {Ai ∈I | N ∈null(Ai)}
(ii) LinkedNullk
I,N = {Ai ∈I | (∃Aj ∈LinkedNullk−1
I,N )(null(Ai) ∩null(Aj)̸ = ∅)}.
It is easy to see that for every k ≥0, we have LinkedNullk
I,N ⊆LinkedNullk+1
I,N and LinkedNullk
I,N ⊆I.
Thus, the sequence

LinkedNullk
I,N

k≥0 is bounded by I and is monotonic. As I is ﬁnite, the sequence
has a unique limit, which is precisely the sub-set of I denoted by LinkedNullI,N.
It therefore turns out that redundancy has only to be checked with respect to the atoms in
S
N∈ν0 LinkedNullI,N and the set ν of all nulls occurring in this set. Algorithm 1 shows how redun-
dancies are dealt with in this context.
Algorithm 1: Simplify(I, ν0)
1: PSet := {LinkedNullI,N | N ∈ν0}
2: for all P ∈PSet do
3:
Build the query qcore and compute its answer qcore(I)
4:
if | (qcore(I)) |> 1 then
5:
hm := ChooseMostSpec(qcore(I))
6:
I := (I \ P) ∪hm(P)
7: return I
Algorithm 1 receives as input a set I of instantiated atoms, and a set of nulls ν0. For each N
in ν0, the algorithm computes the set LinkedNullI,N (line 1), which is stored in a set called PSet.
Therefore, the nulls occurring in PSet constitute the set ν with respect to which I is simpliﬁed.
On line 3, for each P in PSet, a query qcore : ans(X) ←A1(X1), . . . , An(Xn) is built by replacing
each occurrence of Ni in P by xi. That is, Ai(Xi) is obtained from Ai in P by replacing the nulls
in Ai by the corresponding variables.
Thus, assuming that p nulls occur in P, when evaluating the answer qcore(I) of qcore, the tuple
(N1, . . . , Np) is obviously returned. However, it may happen that the answer contains other tuples,
each of which deﬁne a possible instantiation of the nulls in P. In this case, some atoms in P are
redundant, and thus can be removed. To implement these remarks, when the evaluation of qcore over
I returns more than one tuple (line 4), one most speciﬁc tuple is chosen (line 5), and denoting by
hm the associated homomorphism, I is simpliﬁed (line 6) by replacing all atoms A in P by hm(A).
Example 2 Considering I as in Example 1 and ν0 = {N1}, LinkedNullI,N1 consists of the atoms
Enrolled(Alice, N1) and Degree(N1, N2). Thus, the query qcore is deﬁned by:
ans(x1, x2) ←Enrolled(Alice, x1), Degree(x1, x2)
returning the answer {(N1, N2), (Math, N3)} with more than one tuple.
Hence, hm such that
hm(N1) = Math and hm(N2) = N3 is returned line 5, and I is simpliﬁed as illustrated in Ex-
ample 1.
□
To explain our method for computing the most speciﬁc homomorphism hm we introduce the notion
of P-homomorphism.
7

---

Deﬁnition 1 Given I a set of instantiated atoms and N a null occurring in I, let P = LinkedNullI,N.
A P-homomorphism is a homomorphism h such that h(I) ⊆I and for every null N ′ in null(I) \
null(P), h(N ′) = N ′.
I is said to be P-reducible if there exists a P-homomorphism h such that h(I) is a strict subset
of I.
□
In the following proposition, given a set I of instantiated atoms and a null N in ν0, we use the
following notation:
• P denotes the set of atoms LinkedNullI,N, and null(P) = {N1, . . . Np} denotes the set of nulls
occurring in P;
• qcore(I) is the answer to qcore computed against I. That is, qcore(I) is the set {h1, . . . , hq} of
all possible P-homomorphisms deﬁned over null(P). We suppose that h1 is the identity, i.e.,
for every j = 1, . . . , p, h1(Nj) = Nj;
• HP denotes the table with p columns and q rows such that HP [i, j] = hi(Nj).
• Given a set of atoms Q, we denote by cons null(Q) the set of all symbols σ such that σ is a
constant or a null not in null(Q).
We recall that given two homomorphisms h1 and h2 over the same set of symbols Σ, h1 is said to
be less speciﬁc than h2, denoted by h1 ⪯h2, if there exists a homomorphism h over Σ such that
h ◦h1 = h2. Using these notation, the following proposition holds.
Proposition 1 Given hi and hi′ in qcore(I), hi ⪯hi′ holds if and only if, for every j = 1, . . . , p,
we have:
1. If HP [i, j] is in cons null(P), then HP [i, j] = HP [i′, j];
2. If HP [i, j] is a null N in null(P), then for every j′̸ = j such that HP [i, j] = HP [i, j′] it holds
that HP [i′, j] = HP [i′, j′].
Proof. Let us ﬁrst assume that hi ⪯hi′ holds. In this case, there exists h such that h ◦hi = hi′. If
Nj is such that hi(Nj) is a constant or a null not in null(P), then for every P-homomorphism hP ,
hP (hi(Nj)) = hi(Nj). Hence, hi′(Nj) = h ◦hi(Nj) = hi(Nj), which shows item (1). If j and j′ are
such that hi(Nj) = hi(Nj′), then hi′(Nj) = hi′(Nj′) also holds, showing item (2).
Conversely, assume that for hi and hi′, items (1) and (2) hold.
Let h be deﬁned for every
j = 1, . . . , p as follows: if there exists Nk such that hi(Nk) = Nj then h(Nj) = hi′(Nk), otherwise
h(Nj) = Nj. We ﬁrst notice that h is well deﬁned. Indeed, if k and k′ are such that hi(Nk) = hi(Nk′),
then we have two expressions deﬁning h(Nj), namely h(Nj) = hi′(Nk) and h(Nj) = hi′(Nk′).
However, by item (2) we have hi′(Nk) = hi′(Nk′), and thus, these two expressions yield the same
value. We now prove that hi ⪯hi′, that is, that for every k = 1, . . . , p, then hi′(Nk) = h(hi(Nk)).
If hi(Nk) is not in null(P), then, we have hi(Nk) = hi′(Nk) = Nk, and by construction of h we also
have h(NK) = Nk. Therefore hi′(Nk) = h(hi(Nk)) = Nk. On the other hand, if hi(Nk) = Nj, by
deﬁnition of h, we have hi′(Nk) = h(Nj). Hence, hi′(Nk) = h(Nj) = h(hi(Nk)). Since for every
k = 1, . . . , p, we have hi′(Nk) = h(Nj) = h(hi(Nk)), it follows that hi ⪯hi′, and the proof is
complete.
□
Example 3 Let I = {B(N1, N2), B(N2, N1), C(N1, a), C(N2, a), C(N3, a)} and ν0 = {N1}.
In this case, P = {{B(N1, N2), B(N2, N1), C(N1, a), C(N2, a)}} and thus null(P) = {N1, N2}
and cons null(P) = {a, N3}. This implies that P-homomorphisms should not change N3, or in other
words, N3 should be treated as constant. The query qcore is thus written as follows:
8

---

qcore : ans(x1, x2) ←B(x1, x2), B(x2, x1), C(x1, a), C(x2, a)
and the table HP representing the answer qcore(I) is shown below.
HP x1 x2
1
N1 N2
2
N2 N1
HP has 2 columns (because null(P) contains two nulls), and 2 rows due to two answers in qcore(I).
It is easy to see that h1 ⪯h2, and h2 ⪯h1 meaning that there is no advantage in trying to simplify
the database instance in this case. Indeed, we have h1(I) = I, where h1 is the identity. We have
h2(I) = I as well, although h2 is not the identity. Remark that h2 does not satisfy h2 = h2 ◦h2
(i.e., h2 is not idempotent) because h2(h2(N1)) = h2(N2) = N1, whereas h2(N1) = N2. As will be
seen shortly, detecting such homomorphisms allows for computational optimizations.
□
The following corollary shows how to ﬁnd one most speciﬁc homomorphism, based on Proposition 1.
To state the corollary, we use the following notation for i = 1, . . . , q:
• γi is the number of nulls N in null(P) such that hi(N) is in cons null(P);
• µi = {k ∈{1, . . . , q} | (∀j = 1, . . . , p)(hi(Nj) ∈cons null(P) ⇒hk(Nj) = hi(Nj))};
• πi is the number of distinct nulls in null(P) in the set hi(null(P)).
Intuitively speaking, considering that HP is the tableau, then γi is the number of columns that,
at row i, contain a symbol in cons null(P). On the other hand, µi is the set of all rows in HP
containing the same symbols of cons null(P) in the same columns as row i does (i.e.,
if hi(Nj) = c
then hk(Nj) = c). Then πi is the number of distinct nulls in nulls(P) occurring in row i.
The corollary below formalizes the following informal remarks:
1. If hi̸ = hi ◦hi, then hi cannot be one of the most speciﬁc homomorphisms, because in this
case, hi ≺hi ◦hi. For instance, in Example 3, we have h2̸ = h2 ◦h2.
2. Most speciﬁc homomorphisms are among the rows of HP with the largest number of symbols
in cons null(P). Indeed, let hi and hj be such that row i contains strictly more symbols in
cons null(P) than row j and hi ≺hj. Then, there exists h such that h ◦hi = hj, and so,
if N in null(P) is such that hi(N) is in cons null(P), we have h(hi(N)) = hi(N), and so
hi(N) = hj(N). Thus, row j has at least as many symbols in cons null(P) as row i, which
implies a contradiction. Hence, for every N in null(P), hi(N) is also in null(P), in which case
rows i and j have no symbols in cons null(P), which is another contradiction.
3. Considering one of the rows deﬁned just above, say row i, among all rows having the same
symbols in cons null(P) in the same columns as row i, we argue that a row with as few distinct
nulls in null(P) deﬁnes one most speciﬁc homomorphism.
Corollary 1 Given I and P as above, denoting by {h1, . . . , hq} the set qcore(I), the following holds:
1. If hi is one of the most speciﬁc P-homomorphisms in qcore(I) then hi is idempotent, that is,
hi ◦hi = hi.
2. hi is one of the most speciﬁc P-homomorphisms in qcore(I) if (a) γi = max1≤j≤q(γj), and (b)
πi = mink∈µi(πk).
9

---

Proof. First, Proposition 1 implies that hi ⪯hi ◦hi holds for every hi. Moreover, as hi is a
P-homomorphism, we have hi(I) ⊆I.
Thus hi ◦hi(I) ⊆I, which implies that hi ◦hi is a P-
homomorphism as well. The proof of item (1) is therefore complete.
Assume that hi satisﬁes (2) and let hk be a P-homomorphism such that hi ⪯hk. By Proposi-
tion 1, if hi(Nj) is in cons null(P), then hi(Nj) = hk(Nj). Therefore, γi ≤γk, and as γk ≤γi, this
implies γi = γk. Thus, k is in µi, which implies that hi(Nj) is in null(P) if and only if so is hk(Nj).
By Proposition 1, if j and j′ are such that hi(Nj) = hi(Nj′) then we also have hk(Nj) = hk(Nj′). It
therefore follows that less nulls in null(P) occur for hk, that is πk ≤πi. As πi ≤πk must hold, we
obtain that πi = πk, meaning that hi and hk are equal up to a null renaming. The proof is therefore
complete.
□
Algorithm 2: ChooseMostSpecific(qcore(I))
1: Build HP as explained in Proposition 1
{HP has q rows and p columns}
2: row max := 1 ; count max := 0 ; i := 2
3: for all i = 2, . . . , q do
4:
idemPot := true
5:
count curr := 0 ; j := 1
6:
while idemPot = true and j ≤p do
7:
if HP [i, j] is in cons null(P) then
8:
count curr := count curr + 1
9:
else
10:
Let Nk = HP [i, j] {Nk is in null(P)}
11:
if HP [i, k]̸ = Nk then
12:
idemPot := false {hi is not idem-potent}
13:
Mark row HP [i]
14:
j := j + 1
15:
if idemPot = true then
16:
if count curr > count max then
17:
row max := i
18:
count max := count curr
19: row spec := row max
20: Let count min be the number of distinct nulls in null(P) occurring in HP [row max]
21: for all i = 2, . . . , q do
22:
if row HP [i] is not marked and i̸ = row max then
23:
match := true ; j := 1
24:
while match = true and j ≤p do
25:
if HP [row max, j] is in cons null(P) and HP [row max, j]̸ = HP [i, j] then
26:
match := false
27:
j := j + 1
28:
if match = true then
29:
Let count null be the number of distinct nulls in null(P) occurring in HP [i]
30:
if count null < count min then
31:
row spec := i
32:
count min := count null
33: return hm, the homomorphism deﬁned by HP [row spec]
10

---

As a consequence, ﬁnding a most speciﬁc P-homomorphism in qcore(I) amounts to (i) discard any
row not deﬁning an idem-potent homomorphism and (ii) among the remaining rows, identify one
homomorphism satisfying item 2 of Corollary 1. Algorithm 2 shows how to compute such a most
speciﬁc homomorphism, and we notice that this does not require data access. To end the section,
we illustrate Algorithm 2 as follows.
Example 4 We ﬁrst consider the context of Example 3, where I = {B(N1, N2), B(N2, N1), C(N1, a),
C(N2, a), C(N3, a)} and P = {B(N1, N2), B(N2, N1), C(N1, a), C(N2, a)}.
In this case, null(P) = {N1, N2}, cons null(P) = {N3}, and the associated table HP has been
shown already.
Applying Algorithm 2 based on the table HP , the following computations are
achieved.
The ﬁrst loop line 3 aims at marking rows deﬁning non idempotent P-homomorphisms (that is,
such that h◦h̸ = h) and mean-while to ﬁnd one unmarked row with as many symbols in cons null(P)
as possible, in reference to Corollary 1(2). These computations return the following:
• When processing row 2 of HP , we have HP [2, 1] = N2 where N2 is in null(P), and HP [i, 2] =
N1. Since N1̸ = N2, idemPot is set to false and row 2 is marked on line 13.
• Since there is no other row to process, the loop line 3 returns row max = 1 and count curr = 0.
Hence, Algorithm 2 returns row spec = 1 and so, hm is deﬁned by hm(N1) = N1 and hm(N2) = N2.
In other words, I is not simpliﬁed, which is indeed the expected result.
We now illustrate further Algorithm 2, using two more sophisticated cases.
First, let ν0 =
{N1} and I1 = {B(N1, N2), B(a, N2), B(a, N3), B(N4, N3), C(N2, N2), C(N3, N3)}. In this case,
LinkedNullI,N1 = {N1, N2} and thus, PSet = {P} where P = {B(N1, N2), B(a, N2), C(N2, N2)}.
Moreover, the query
qcore : ans(x1, x2) ←B(x1, x2), B(a, x2), C(x2, x2)
is generated and its answer against I1, qcore(I1), is deﬁned in the following table H1
P :
H1
P x1 x2
1
N1 N2
2
a N2
3
a N3
4
N4 N3
H1
P has 2 columns and 4 rows due to four possible answers in qcore(I1). Moreover, h1 ⪯h2, h2 ⪯h3
and h2 ⪯h4. Notice that h3 and h4 are not comparable because a, N3 and N4 are in cons null(P).
Applying Algorithm 2 based on the table H1
P , the ﬁrst loop line 3 achieves the following:
• No row is marked as non-idempotent on line 13. This is so because for every i = 1, . . . , 4, and
every j = 1, 2, if H1
P [i, j] = Nk where Nk is N1 or N2, H1
P [i, k] = Nk.
• Regarding the value of count curr, the computed value is 0 for the ﬁrst row, 1 for row 2, and 2
for rows 3 and 4 (because a, N3 and N4 are in cons null(P)). Thus, applying the test line 16,
count curr to set to 2, and on line 17, row max is set to 3. Indeed, although for row 4, we
have count curr = 2, the test line 16 fails, and thus the value of row max is not changed.
Then, row spec is set to 3 on line 19 and cont min is set to 0 on line 20.
Therefore, processing the loop line 21 yields no change and Algorithm 2 returns hm deﬁned by
hm(N1) = a and hm(N2) = N3, in which case, hm(I1) = {B(a, N3), B(N4, N3), C(N3, N3)}, which
is not redundant, when considering N3 and N4 as particular ‘constants’.
11

---

As a more sophisticated illustration of Algorithm 2, let ν0 = {N1} and I2 = {B(N1, N2),
B(a, N2), C(N2, N2), C(N2, N3)}.
Here, LinkedNullI,N1 = {N1, N2, N3} and thus, PSet = {P}
where P = {B(N1, N2), B(a, N2), C(N2, N2), C(N2, N3)}. Moreover, the query:
qcore : ans(x1, x2, x3) ←B(x1, x2), B(a, x2), C(x2, x2), C(x2, x3)
is generated and qcore(I2), is deﬁned in the following table H2
P :
H2
P x1 x2 x3
1
N1 N2 N3
2
N1 N2 N2
3
a N2 N3
4
a N2 N2
H2
P has 3 columns and 4 rows due to four possible answers in qcore(I2). Moreover, h1 ≺h2, h1 ≺h3,
h2 ≺h4 and h3 ≺h4. Applying Algorithm 2 based on the table H2
P , the loop line 3 achieves the
following:
• As above, no row is marked as non idempotent on line 13. This is so because for i = 1, . . . , 4,
and j = 1, 2, 3, if H2
P [i, j] = Nk where Nk is N1, N2 or N3, H2
P [i, k] = Nk.
• As above, on line 17, row max is set to 3 and thus, row spec is set to 3 on line 19. Here,
count min is set to 2 on line 20 because N2 and N3 are in null(P).
When processing the loop line 21, the only row to be considered is row 4, for which match is
true, thus implying that the test on line 28 succeeds. Since for row 4, the value of count null
is 1 (because row 4 contains the only null N2), the value of row spec is set to 4, line 31. Hence,
Algorithm 2 returns hm deﬁned by hm(N1) = a, hm(N2) = N2 and hm(N3) = N2. In this case,
hm(I2) = {B(a, N2), C(N2, N2)}, which is not redundant.
□
Homomorphisms have been used in database theory during the last decades, in the ﬁeld of query
optimization [4, 10] (we refer to [2] for an overview). We notice in this respect that, in [4], a partial
pre-ordering between homomorphisms is deﬁned using the same criteria as in Proposition 1, showing
that our approach to simpliﬁcation is closely related to the ﬁeld of query optimization. Roughly,
in our approach, we compare all the answers (h1, . . . hq) for qcore and chose one (hm) among the
most speciﬁc ones (which are incomparable). From another point of view, if we consider queries Q1,
Q2, . . . , Qq as the instantiations of qcore by h1, . . . hq, respectively, then hm is a homomorphism
such that hm(body(Qi)) = body(Q) for all Q ⊆Qi. Actually, our simpliﬁcation technique is based
on tableau optimization, as done in [4] for query optimization, where the sets of variables and
of distinguished variables are, respectively, called, in our approach, the null(P) and cons null.
However, the contexts and the expectations in our approach are fundamentally diﬀerent from those
summarized in [2]. Indeed:
• In [2], the tableau is built up from the query body, whereas in our approach, the tableau is
built up from the answer to a given query.
• Our approach generates one most speciﬁc homomorphism, where as the approach shown in [2]
aims at discarding all non most speciﬁc.
As a result, the problem we deal with can be seen as more speciﬁc than the general case considered
in [2, 4], thus resulting in a speciﬁc algorithm.
12

---

Query
Algo Purpose
qbucket(I)[S]
3, 5 retrieves all nulls in I appearing in an atom
p(...) such that p is a predicate in a given set S
qdegree(I)[S,δmax]
3
for each N in S, checks if N is in I and if
δ(N) < δmax
qδ(I)[S,d]
3
for each N in S, if N is in I, sets δ(N) to d
qIso(I)[S]
5
retrieves in I all atoms isomorphic to those in S
Figure 2: Queries used in our algorithms
5
Incremental Updating
In [9], update algorithms work on in-memory data, using no DataBase Management System (DBMS).
This version considers a DBMS, based on which data access is implemented through queries. In this
section, we show how to implement updates by restricting data access as much as possible.
5.1
Insertion
Algorithm 3 describes the insertion in D of the atoms in the set iRequest. On line 1, the side-eﬀects
of the insertion are computed and stored in the set ToIns, and then the instance D′ = D ∪T oIns is
simpliﬁed on line 3 through the computation of its core. If all nulls in the simpliﬁed instance have
a degree less than the speciﬁed maximal degree δmax (on line 4), null degrees are all set to 0 (on
line 5) and D′ is returned since, as shown in [9], it is always consistent; otherwise, the database is
not modiﬁed.
Algorithm 3: Insert(D, C, δmax, iRequest)
1: T oIns := Chase4Insert(D, C, δmax, iRequest)
2: NullBucket := {Nj | Nj is a null obtained by qbucket(D ∪T oIns)[T oIns]}
3: D′ := Simplify(D ∪T oIns, NullBucket)
4: if qdegree(D′)[NullBucket,δmax] then
5:
qδ(D′)[NullBucket,0]
6:
return D′
7: else
8:
return D
Contrary to the algorithms in [9], the main steps in Algorithm 3 are designed in an incremental
manner. First, to avoid generating any non necessary side eﬀect atoms, an incremental version of
the chase procedure considered. According to this procedure, a constraint c is activated only when
the following conditions hold:
(i) body(c) contains at least one atom that maps to one being inserted, and
(ii) atoms in body(c) that do not respect (i) map to atoms in the database instance D.
This new chase diﬀers from the one in [9] in the following aspects: (a) only the rules c concerned by
insertions are triggered and (b) queries are built to ﬁnd in D instantiations for atoms in body(c).
Algorithm 4, called on line 1, implements our incremental chase procedure.
The set T oIns
initially stores iRequest (line 1) and then, stores the generated side-eﬀects (line 3) through the while
loop on line 2, deﬁned by the following conditions:
13

---

Algorithm 4: Chase4Insert(D, C, δmax, iRequest)
1: T oIns := iRequest
2: while ∃c ∈C and ∃h such that h(body(c)) ⊆D ∪T oIns and h(body(c)) ∩T oIns̸ = ∅and
δ(h′(head(c)) ≤δmax, where h′ ⊇h maps to new nulls all existential variables in head(c),
and there does not exist h′′ such that h′′(h′(head(c)) ∈D ∪T oIns do
3:
T oIns := T oIns ∪{h′(head(c))}
{Degrees of new nulls in h′(head(c)) are set to dmax + 1, where dmax is the maximal
degree in h(body(c)), or 0 if h(body(c)) contains no null}
4: return T oIns
• A constraint c is triggered only if at least one atom in body(c) is instantiated to an atom in
T oIns.
• The condition δ(h′(head(c)) ≤δmax ensures that only (side-eﬀect) atoms whose degree is less
than the maximum null degree are kept. The instantiation h′ extends h by assigning new null
values to existential variables in head(c). When performing a chase step, the degree of new
nulls are also computed.
• The last condition ensures termination along with a simpliﬁcation. Indeed, if an instantiation
of h′(head(c)), referred to as h′′(h′(head(c))), exists in D ∪T oIns, the constraint is satisﬁed,
and no atom is inserted in T oIns. For instance, suppose D1 = {Authors(Elin, P2)}, C = {c5}
(Figure 1) and iRequest = {Researcher(Elin)}. The atom Authors(Elin, N1), generated by
c5, is not inserted since it maps to Authors(Elin, P2).
Another diﬀerence between the algorithm in [9] and Algorithm 3, is the simpliﬁcation step on line 3
to maintain the database instance irredundant. Indeed, based on our earlier discussion in Section 4,
D ∪T oIns is simpliﬁed with respect to the nulls in NullBucket, computed through the query qbucket
on line 2. Thus, only the nulls in NullBucket and their ‘linked’ nulls are considered, thus optimizing
the computation of the core of D ∪T oIns.
Example 5 Let C = {c1, c3, c4, c10, c11, c12}, δmax = 3 and the following database instance:
D = { Authors(N1, P2), Authors(Alice, N2), Publication(P2), Publication(N2),
Researcher(N1), Researcher(Alice), Supervises(N1, N3) }
Let iRequest = {Authors(Alice, P5), Student(Bob)}. Running Algorithm 3 in this case is as follows.
Constraint c4 is triggered due to the insertion of Authors(Alice, P5) and constraints c10, c11, c12 are
triggered due to the insertion of Student(Bob). Line 1 returns the following set T oIns, where null
degrees are shown as exponents:
T oIns = { Authors(Alice, P5), Publication(P5), Student(Bob), Enrolled(Bob, N 0
5),
Degree(N 0
4 , N 1
5 ), Language(N 0
4, N 1
5 , N 2
6 ) }.
To simplify D ∪T oIns, the query qBucket retrieves in D the nulls concerning Authors (i.e., N1
and N2), Publication (i.e., N2), Enrolled (i.e., N4), Degree (i.e., N4, N5) and Language (i.e.,
N4, N5, N6). Therefore, NullBucket = {N1, N2, N4, N5, N6}, and by Algorithm 1, we obtain
that LinkedNullsD,N1 = {N1, N3}, LinkedNullsD,N2 = {N2}, and for i = 4, 5, 6, LinkedNullsD,Ni =
{N4, N5, N6}. The simpliﬁcation of D ∪T oIns (line 3 of Algorithm 3) results in:
D′ = { Authors(N1, P2), Authors(Alice, P5), Publication(P2), Publication(P5), Researcher(N1),
Researcher(Alice), Supervises(N1, N3), Student(Bob), Enrolled(Bob, N4),
Degree(N4, N5), Language(N4, N5, N6) }.
14

---

Notice also that, since the degree of nulls is checked only during the chase, before returning the
updated instance, the degrees of all nulls are set to 0 on line 5 of Algorithm 3.
□
5.2
Deletion
Algorithm 5: Delete(D, C, δmax, dRequest)
1: isoDel := qIso(D)[dRequest] {isoDel contains atoms in D that have to be deleted}
2: T oDel, T oIns := Chase4Delete(D, C, δmax, isoDel)
3: D′ := (D ∪T oIns) \ T oDel
4: NullBucket := {Nj | Nj is a null obtained by qbucket(D′)[T oIns∪T oDel]}
5: D′ := Simplify(D′, NullBucket)
6: return D′
Our incremental algorithm for the deletion from D of atoms in dRequest is displayed as Algo-
rithm 5. On line 1, all atoms in D isomorphic to one in the set dRequest are retrieved through
the query qiso. For instance, if dRequest = {P(a, N1)} and D1 = {P(a, N5)}, then query qiso re-
turns {P(a, N5)}. The side-eﬀects are then computed on line 6, recalling from Section 2 that the
side eﬀects involve not only atoms to be deleted, but also atoms to be inserted as side-eﬀects. In
Algorithm 5, the corresponding sets are respectively denoted by T oDel and T oIns.
Once these side-eﬀects have been incorporated in D to produce D′ (line 3), this new instance
is simpliﬁed as in the case of insertion: impacted nulls are generated on line 4 and the simpliﬁed
instance is computed on line 5. We notice that, contrary to insertions, deletions are never rejected.
As for insertions, side eﬀects are computed incrementally through Algorithm 6. First, it may
happen that the deletion of an instantiated atom A makes the database inconsistent when it is a
consequence of a constraint c. To ﬁnd all such constraints c, we reason backward on C to ﬁnd an
instantiation h such that h(head(c)) = A. Then h is extended to verify, in a forward reasoning,
whether body(c) can be triggered and generate A again.
The idea is to check whether c generates an atom isomorphic to an atom being deleted (Algo-
rithm 6, line 3). If so, at least one atom in h(body(c)) should be deleted in order to prevent c from
being triggered. This atom is then inserted in T oDel (line 4). Notice that, to avoid non-determinism,
it is assumed that the atom to be deleted has been marked as ‘−’ during rule design.
If no atom isomorphic to an atom to be deleted is generated, a new set called NewT oIns is
generated as the side-eﬀects of inserting the new instance of head(c) and all atoms in T oIns (line 6).
If no atom in NewT oIns meets an atom to be deleted and if the degrees of the involved nulls are
less that δmax, then these atoms are inserted in T oIns (line 8). Otherwise, the marked atom from
h(body(c)) is inserted in T oDel (line 10).
Example 6 Let D0 = {GrantEligible(Sten), Student(Sten), Enrolled(Sten, CS)}, C = {c10, c13}
and dRequest = {GrantEligible(Sten)}.
On line 2, Algorithm 5 calls Algorithm 6 to perform an incremental chase. T oIns and T oDel
are respectively initialized to ∅and {GrantEligible(Sten)}, and a ﬁrst iteration of the loop on
line 2 is run. Constraint c13 is concerned by the deletion, because for h such that h(head(c13)) =
GrantEligible(Sten), as Enrolled(Sten, CS) is in D, c13 generates GrantEligible(Sten) (line 3).
Therefore, T oDel is set to {GrantEligible(Sten), Enrolled (Sten, CS)} and T oIns remains empty.
In the second iteration of the loop, c10 is detected to be concerned by the deletion of the
atom Enrolled(Sten, CS).
With Student(Sten) in D, c10 generates Enrolled(Sten, N1), which
15

---

Algorithm 6: Chase4Delete(D, C, δmax, isoDel)
1: T oIns := ∅and T oDel := isoDel
2: while there exist c ∈C and h such that h(head(c)) ∈T oDel and
h(body(c)) ⊂(D \ T oDel) ∪T oIns do
3:
if ∃h′ such that h′(body(c)) = h(body(c)) and h′(head(c)) is isomorphic
to h(head(c)) then
4:
T oDel := T oDel ∪{h′(body−(c))}
5:
else
6:
NewT oIns := Chase4Insert(D, C, δmax, T oIns ∪{h′(head(c))})
7:
if NewT oIns = Del = ∅and δ(N) < δmax for all nulls N in NewT oIns then
8:
T oIns = T oIns ∪NewT oIns
9:
else
10:
T oDel := T oDel ∪{h′(body−(c))}
11: return T oDel, T oIns
is not isomorphic to Enrolled(Sten, CS) (line 3). The next step consists in testing whether the
atom Enrolled(Sten, N1) should be added to T oIns. To this end, Algorithm 6 chases forward,
starting with Enrolled(Sten, N1) (line 6) to generate GrantEligible(Sten). This atom being in
T oDel (line 7), Student(Sten) is added to T oDel, and nothing is added in T oIns. Algorithm 6
returns T oDel = {Student(Sten), GrantEligible(Sten), Enrolled(Stem, CS), Enrolled(Sten, N1)},
and T oIns = ∅. Algorithm 5 then performs the deletions and the resulting database instance is
empty.
□
6
Queries for Incremental Processing
By implementing our method using graph and relational database models, our goal is to study
performance aspects, and to raise issues concerning the database design regarding queries.
6.1
Graph Data Model
The DBMS considered in this work is Neo4J, which deals with attributed graphs. Cypher is a well-
established language for querying and updating property graph databases. As explained in [16], ‘a
Cypher query takes as input a property graph and outputs a table. These tables can be thought of
as providing bindings for parameters that witness some patterns in a graph, with some additional
processing done on them’. The central concept in Cypher queries is pattern matching. The MATCH
clause searches for homomorphisms identifying a given pattern in the queried graph. The returned
result is an instance over a table where attributes correspond to the variables in the Cypher query.
Our approach involves managing null values that have to be retrieved based on their co-occurrences
as arguments of atoms (Section 4). Given a null N1 we need to eﬃciently detect atoms having N1
as one of its arguments, and then for every N occurring with N1, to recursively access the atoms
having N as argument. In doing so, the set of nulls is partitioned into blocks whose elements are
those nulls that have to be considered in the simpliﬁcation steps. To make such retrieval eﬃcient,
we adopt a model close to the logical formalism used in our previous explanations, composed of
three types of nodes. Given an atom P(t1, . . . , tn) our graph database represents P as a node, linked
to other nodes representing the terms t1, . . . , tn. In this context, nodes in our graph database are
16

---

of three possible types distinguished by labels, and all nodes have properties, among which one is
symbol. More precisely:
• Nodes of type Atom have one label :Atom representing the predicate symbol in an atom. This
predicate symbol is the value of property symbol of such a node.
• Nodes of type Constant representing constant values. Such nodes have two labels, :Element
and :Constant, and the value of their property symbol is the constant itself.
• Nodes of type Null reprensenting nulls. Such nodes have two labels, :Element and :Null,
and the value of their property symbol is the name of the null preﬁxed with ‘ ’.
An edge links nodes with label :Atom to nodes with label :Element. Moreover, an edge has the
property rank, allowing to refer to the terms of an atom by their positions.
Figure 3 illustrates the schema of the atom P(t1, . . . , tn) by representing constant terms by ti
and nulls by tj. Notation below edges indicates the cardinality of the relationship between an atom
and its terms: an element is connected to at least one atom and atoms may have no terms.
Figure 4 illustrates part of our database instance (rectangular nodes are atoms and circular nodes
are elements).
:Atom
symbol: P
terms: {t1, . . . , tn}
:Element
:Constant
symbol: ti
:Element
:Null
symbol: tj
0..∗
1..∗
{ rank: i }
0..∗
1..∗
{ rank: j }
Figure 3: Graph database schema.
As explained before, our model beneﬁts certain operations. However, it increases the cost of
conversions between the graph-format and the logic-format for an atom. Such conversions are essen-
tial for the communication between the database and the procedures performing some computations
locally. To optimize these conversions and graph traversals, we introduce the following redundancies
in our database model, which have signiﬁcantly improved our implementation (see Section 7).
• To avoid edge traversal.
For each node :Atom, we store, as its attribute, an ordered list containing all its terms.
In Figure 3, the rectangular node shows this new attribute: terms.
For example, to
obtain atom Authors(Elin, P269) from the instance in Figure 4 starting with the node
n117, instead of traversing edges r19 and r20, we just have to retrieve the attributes terms
of node n117.
• To allow eﬃcient access to nodes.
(a) A uniqueness constraint is added on the Element symbol (implying, e.g., that there is a
unique node in the database to represent Elin).
(b) An index is built on the symbol of each atom, and a uniqueness constraint is deﬁned on
the couple symbol/terms (implying, e.g., that there is a unique node in the database to
represent atom Authors(Elin, P269).
The algorithms presented in the previous sections involve the construction of queries in Cypher to
be evaluated on our Neo4J database. We now focus on two of them: one needed when chasing and
one that computes the set LinkedNull.
17

---

n6
Elin
n127
Supervises
n128
Supervises
n7
Sten
n8
Linda
n129
Supervises
n10
Thor
n102
Researcher
n103
Researcher
n104
Student
n105
Student
n116
Authors
n117
Authors
n118
Authors
n5
P240
n9
P269
n11
N1
n121
Cites
n124
Cites
n12
N2
n111
Publication
n112
Publication
r2
rank: 0
r3
rank: 0
r4
rank: 0
r5 rank: 0
r11
rank: 0
r12
rank: 0
r17
rank: 0
r18
rank: 1
r19
rank: 0
r20
rank: 1
r21
rank: 0
r22
rank: 1
r27 rank: 0
r28 rank: 1
r33 rank: 0
r34 rank: 1
r39
rank: 0
r40
rank: 1
r41
rank: 0
r42
rank: 1
r43
rank: 0
r44
rank: 1
Figure 4: Graph database instance (extract). Optimization labels and attributes are omitted.
Query for chasing.
Chasing means applying constraints. The application of a constraint happens
when its body can be instantiated by facts in the database. Thus, to decide on the application of a
constraint c, we need a query capable of :
(1) Verifying whether the database instance contains the facts necessary for the instantiation of
body(c) and
(2) returning a non-empty answer only if a corresponding instantiation for head(c) does not already
exist in the database.
In a logic formalism, if c is of the form c : L1(α1), . . . , Lm(αm) →L0(α0), we should write the
query qch : Q(α) ←L1(α1), . . . , Lm(αm), not L0(α0), where α is the list of variables corresponding
to variables in body(c), that is, variables universally quantiﬁed variables of c. The idea here is: if
ht is an instantiation such that ht(body(c)) ⊆D, the query qch has a non empty answer only if
h′
t(L0(α0))̸ ∈D for any extension h′
t of ht.
Figure 5 shows the Cypher template of query qch. We ﬁrst look for atoms that match body(c).
On the line 3 in Figure 5, the WHERE NOT EXISTS clause is used to check that no instance of the
head(c) exists.
Two expressions are built (expr1 and expr2).
Terms in α are treated orderly.
Notice that expr1 is built for dealing with atoms in body(c) and expr2 is built for dealing with the
18

---

1
MATCH (xk : Element { value :
ti })
2
MATCH (a1 : Atom {symbol :
‘L1 ‘}) ,
. . . ,
(am : Atom {symbol :
‘Lm ‘})
3
WHERE expr1
and NOT EXISTS {
4
MATCH (a : Atom {
symbol :
‘L0 ‘})
5
WHERE expr2
6
} RETURN {α|1 : x1, α|2 : x2, . . . , α|k : xk}}
Figure 5: Cypher template for chasing
1
MATCH ( x0 : Element : Constant
{ value :
’Bob ’ } ) ,
2
( x1 : Element : Constant
{ value :
’ P 1 ’ } )
3
MATCH ( a0 : Atom {symbol :
’ Authors ’
}) ,
4
( a1 : Atom {symbol :
’ Authors ’
}) ,
5
( a2 : Atom {symbol :
’ Supervise ’ } )
6
WHERE ( a0 ) −[: Authors
{rank :
0}]−>(x2 ) ,
7
( a0 ) −[: Authors
{rank :
1}]−>(x1 ) ,
8
( a1 ) −[: Authors
{rank :
0}]−>(x0 ) ,
9
( a1 ) −[: Authors
{rank :
1}]−>(x1 ) ,
10
( a2 ) −[: Supervise
{rank :
0}]−>(x2 ) ,
11
( a2 ) −[: Supervise
{rank :
1}]−>(x0 )
12
and NOT EXISTS {
13
MATCH ( a : Atom {symbol :
’PhDPaper ’ } )
14
WHERE ( a ) −[:PhDPaper { rank :
0}]−>(x0 ) ,
15
( a ) −[:PhDPaper { rank :
1}]−>(x1 )
16
} RETURN { ‘X‘ :
x2 . value ,
‘Y‘ :
x0 . value ,
‘P ‘ :
x1 . value} AS sub
Figure 6: Cypher template for Example 7
atom in head(c). The ﬁrst MATCH acts as a starting point of the graph traversal. It is built with
constants or nulls (e.g., (xk:Element:Constant {symbol:ti})) as we usually consider constraints
instantiated by insertions. Then the pattern, built with the second MATCH and the WHERE clause,
links the constants to the positions in the atoms of the body.
Separating the two MATCH allows us to guide the query planner to ﬁrst search the constants
(called node seeking) and then look for the connected nodes to ﬁnd the atoms. This is important
because, in doing so we drastically reduce the search space, because constants are unique values
retrieved in O(1), and only :Atom connected nodes are searched, thus avoiding to visit all instance
nodes of the predicate.
Example 7 Considering the insertion of Authors(Bob, P1) in the database instance
D = {Supervises(Alice, Bob), Authors(Alice, P1)}
with the only constraint c6 deﬁned by:
c6 : Authors(X, P), Authors(Y, P), Supervises(X, Y ) →PhDPaper(Y, P, Z)
Two instantiations h and h′ should be checked: one on the ﬁrst atom Authors (h(X) = Bob,
h(P) = P1) and one for the second atom Authors (h′(Y ) = Bob, h′(P) = P1). Figure 6 shows the
chase query for the instantiation h′ of the constraint c6.
□
Query to ﬁnd LinkedNull sets.
Figure 7 presents the Cypher query that implements the Linked-
Null deﬁnition (Section 4) for building partitions of atoms. The clause UNWIND can transform any list
into individual rows. For instance, if we consider a list [’Elin’, ’Sten’] of constant symbols, the
clause UNWIND over such a list gives a table with one column c and two rows whose values are ’Elin’
and ’Sten’. In Figure 7, the clause UNWIND (line 1) is used to set nulls from a given list to our initial
table with one row for each null. The goal of the ﬁrst MATCH (line 2) is to select sub-graphs with
19

---

atoms sharing the same null. On the line 3, the range of the relationship (*1..) indicates that node
nullValueNode can be connected to a node endNode by a path pathP of arbitrary length. Moreover,
the direction is ↔indicates that pathP can be composed by edges having any orientation.
The MATCH clause looks for paths starting with the null of the nullValueNode to any other node
representing an atom which is not nullValueNode itself (condition imposed by the WHERE clause).
On the line 6, the WITH clause performs a ‘group by’. It allows to structure our working table with
tuples where each null nullValueNode is associated to a list of endNodes (the nodes reached by
paths pathP). On the line 7 a new organisation is built: linkedNodes is divided into two lists, one
containing nodes that represent predicate symbols (linkedAtoms) and one for those representing
nulls (linkedNulls). Notice that we place the initial node nullValueNode in the ﬁrst position of
the latter. The resulting table partitions the atoms: each atom is associated to a list of nulls (those it
is concerned by). In the worst case, the former list contains all atoms having a null in the database.
1
UNWIND $ n u l l s
AS nullPredName
2
MATCH ( nullValueNode : Element : Null
{ value :
nullPredName}) ,
3
pathP = ( nullValueNode ) −[∗1.. maxPathLength] −(endNode )
4
WHERE endNode <> nullValueNode AND
5
ALL(n IN
nodes ( pathP) WHERE NOT ( n : Constant ) )
6
WITH COLLECT(DISTINCT endNode ) AS linkedNodes ,
nullValueNode
7
WITH
8
[ n IN
linkedNodes WHERE ( n : Atom) ]
AS linkedAtoms ,
9
[ nullValueNode ] + [ n IN
linkedNodes WHERE (n : Null ) ]
AS
l i n k e d N u l l s
10
UNWIND linkedAtoms AS a
11
RETURN a . symbol
as
a ,
a . terms
as
e ,
l i n k e d N u l l s
Figure 7: Cypher template to ﬁnd LinkedNull sets
Example 8 Considering the graph of Figure 4, if we search for atoms whose nulls are linked to N1,
i.e., $nulls = [’_N1’], after the ﬁrst MATCH in Figure 7, we have:
nullValueNode endNode pathP
n11
n111
[n11, r11, n111]
n11
n118
[n11, r22, n118]
n11
n124
[n11, r33, n124]
n11
n12
[n11, r33, n124, r34, n12]
n11
n112
[n11, r33, n124, r34, n12, r12, n112]
After the ﬁrst WITH line 6, we have:
nullValueNode
linkedNodes
n11
[n111, n118, n124, n12, n112]
After the second WITH line 7, we have:
linkedAtoms
linkedNulls
[n111, n118, n124, n112]
[n11, n12]
□
6.2
Relational Data Model
Given an instantiated atom P(t1, . . . , tn) in the logical representation oinf a database, our relational
model consists in deﬁning a table whose schema is RP [A1, . . . An] where all attributes are of type
20

---

text. Notice that P(t1, . . . , tn) represents a tuple on RP and, thus, (t1, . . . , tn) are values that can be
constants or nulls (nulls have the symbol
as a preﬁx). The translation of logical queries into SQL
is straightforward. However, some operations require the construction of procedures to implement
recursive queries. Algorithm 7 shows the implementation of LinkedNull in the relational context.
We argue in this respect that implementing Algorithm 7 using a recursive SQL query is not
eﬃcient. Indeed, to do so an additional table for storing the pairs of linked nulls is needed, and the
following steps are necessary: (a) a recursive SQL query to compute the transitive closure and (b)
a scan of the whole database to retrieve all corresponding atoms. Moreover, the additional table
needs to be maintained up to date after each update, which requires further processing.
Algorithm 7: FindLinkedNull(D, NullBucket)
1: newNull := ∅, allNulls := ∅, linkedNullSet := ∅
2: while NullBucket̸ = ∅do
3:
allNulls := allNulls ∪NullBucket
4:
for all table RP in the database schema do
5:
for all tuple u in (select ∗from RP where (A1 in NullBucket) or . . .
or (An in NullBucket)) do
6:
build atom P(u); add P(u) in linkedNullSet
7:
for all null value N ∈null(u) do
8:
if N̸ ∈allNulls then
9:
add
N in newNull
10:
NullBucket := newNull
11:
newNull := ∅
12: return linkedNullSet
We also notice that the implementation of an incremental chase in the relational model follows
the idea of setting up query qch (as explained in Section 6.1) which can be written as an SQL query
involving a NOT EXISTS clause.
6.3
Discussion
Querying graph database is signiﬁcantly impacted by graph schema design. The schema we have
chosen transforms nulls into ﬁrst-citizen elements and facilitates operations where, by ’picking’ a null,
we can easily detect all atoms connected (directly or indirectly) to it. For instance, in Figure 4, if we
’pick’ the null N1 (the gray node n11), we detect the atoms connected to it together with other nulls
(i.e., N2, the blue node n12). In other words, this model optimizes queries looking for linked nulls.
However, it may not be appropriate for other kinds of queries. For instance, in the chase query, our
model generates complex patterns that can be costly. The relational model is less ﬂexible than graph
models, and thus its impact on querying is weaker. However, relational model is not appropriate
for the implementation of recursion, and nulls cannot be set as ﬁrst-citizen element (identical null
values appear repeatedly in the database instance). Algorithm 7 shows that to implement LinkedNull
we have to check null values for each table, compromising the idea of an incremental approach. On
the other hand, the graph model is well suited for implementing incremental algorithms, because as
seen in Section 6.1, this model allows implementing LinkedNull by visiting only the atoms linked to
nulls in NullBucket, as expected when considering an incremental computation.
21

---

7
Experimental Results
We gauge the performance of our incremental updating approach by analysing experiment results
over a benchmark working on a graph (Neo4J) and a relational (MySQL) DBMS. A benchmark run
executes an update on a database instance.
To build our database instances, we ﬁrstly view the original data sets from a FOL point of view.
Roughly speaking, a node or a relationship in the original data sets corresponds to a predicate sym-
bol, while their properties are the terms. The conversion to our database models is straightforward,
as presented in Section 6. Nulls are inferred from already missing properties. Constraints are hand-
crafted, created from data observation and added to the databases we use for experiments. The
following three data sets are the basis of our instances:
• Movie1, available as a Neo4J instance, is a collection of data concerning movies, actors, directors.
This data set contains 7 predicate symbols (with arity 2-4).
• GOT 2, available as a Neo4J instance, deals with the interactions between diﬀerent characters in
the book Game of Throne. This data set contains 19 predicate symbols (artiy 2-14).
• LDBC 3, available as a data set of the Linked Data Benchmark Council, oﬀers synthetic data sets
for benchmarking. This data set contains 23 predicate symbols (artiy 1-2).
From the LDBC data sets we build several instances, by varying their size or the number of nulls. To
control the size of instances, their construction is the result of: (i) randomly selecting k facts, respect-
ing the distribution of the original data set and, then, (ii) applying the 39 hand-made constraints
on them. The result is a consistent database instance with nulls. Figure 8 presents a summary of
our database instances (or samples). It is worth noting that, for example, an instance denoted as
LDBC 1K, comes from a random selection of 1000 facts which evolves to 2248 after the chase and
core processing. To control the number of nulls, we proceed as follows: we take the largest LDBC
instance, i.e., with 10 000 facts, and replace all nulls with constants. Then, we choose, randomly,
some constants that are replaced by linked nulls. Figure 8 presents database instances used in our
runs, eight having nulls, and one non-null instance. All the database instances are generated just
once. By following this creation process, they are consistent and minimal.
Database
Nb of facts Nb of nulls Nb of rules Null/Facts (τ)
Movie
604
340
12
0.56
GameOfThrone
24818
17232
32
0.69
LDBC 1K
2248
190
39
0.08
LDBC 10K
16559
1183
39
0.07
LDBC 10K 0N
16559
0
39
0.00
LDBC 10K 50N
16559
50
39
0.00
LDBC 10K 100N
16559
100
39
0.01
LDBC 10K 500N
16559
500
39
0.03
LDBC 10K 1000N
16559
1000
39
0.06
Figure 8: Database instances (our samples).
1https://github.com/neo4j-graph-examples/movies
2https://github.com/neo4j-graph-examples/graph-data-science
3https://ldbcouncil.org/benchmarks/graphalytics/
22

---

Runs are built from instances in Figure 8 by (i) varying the update type (insertion or dele-
tion); (ii) altering the size of the update (1, 5, 10 and 20 atoms) and (iii) augmenting artiﬁcially the
number of facts in an instance. This latter step is done through the duplication of data n-times (1,
2 and 5), together with the renaming of the constants and the null names at each copy.
Each run performs 10 iterations plus 3 warm-up iterations (i.e., an ordinary iteration used to
preload the system and database cache) not counted in the execution time. Between each iteration,
the original database instance is restored, and the Java garbage collector is triggered for consistent
time measuring. The benchmarks are implemented in Java 16 with MySQL 8 and Neo4J 4.1 and
executed on a Rocky Linux 8.7 virtual server with 4 vCPU and 16 GB of memory (8 reserved for
the database and 5 for the Java program) through docker 20.10.21. In the docker container of a
database instance, the average of read/write on disk is 1 GB s−1. The same server hosts: (i) one
database server at the time and (ii) the benchmarks with only 4 vCPU.
Notice that, even if this conﬁguration allows us to assess our implementations over diﬀerent
DBMS, our experiment performances are not representative of real world situations, where more
powerful and dedicated hardware is available.
We ﬁrst compare the incremental approach presented in this paper to the from-scratch in-memory
approach in [9]. For this aspect, comparisons are performed only on the database Movie because
the from-scratch in-memory version requires a huge amount of memory for its computation. We
have an average of 9017 ms for an update with the in-memory version and scale of 1 (initial size of
the instance). MySQL has an average of 151 ms and Neo4J has 2380 ms. For this small instance,
the incremental approach is comparable with the from-scratch approach. Considering an instance
ﬁve times larger, we get an average of 888 966ms for the in-memory version, 595 ms for MySQL and
2706 ms for Neo4J. Thus, it should be clear that using a DBMS in which an incremental version of
update processing is implemented, allows for eﬃciently updating large databases that do not ﬁt in
main memory.
Next, we analyse the performance of incremental updating with respect to the number of atoms
(database size) and nulls of an instance. We denote by incompleteness degree the number of distinct
LinkedNull sets on a database. We also investigate the number of queries generated to interact with
the DBMS. Figure 10 presents our experiment results. On each plot, the right axis, indicates the
total number of facts in the instance. The curves show the average of resulting values for all runs
corresponding to the displayed abscissa.
We ﬁrst note that the update type (insertion or deletion) has no real impact on the performance
of our approach. Figure 10a shows that the number of queries is linear on the number of nulls,
except for three down spikes when the degree of incompleteness of the database instance is low.
This is the case for the database Movies, and the down spikes coincide to a situation where only
this database is concerned. Indeed, thanks to the use of multiple data sets, we observe here that
the predicate arity (i.e., the number of edges per node or the number of columns in a table) may
have an impact on our results. Linearity with respect to the number of nulls is explained by the
fact that consistency preservation implies the generation of new data linked by their nulls. Thus,
due to our construction method, bigger databases imply more linked nulls (i.e., bigger LinkedNull
sets). Incremental updates generate qBucket queries to retrieve impacted nulls. Bigger databases
likely have more impacted nulls willing to be simpliﬁed during the core computation, increasing the
number of necessary qcore queries.
Consequences of bigger LinkedNull sets are:
(i) in MySQL, Algorithm 7 generates a large amount of queries and
(ii) in Neo4J, the unique query needed to retrieve a LinkedNull set is more complex and, thus, more
time-consuming.
23

---

MySQL
Neo4J
5.35
910.9
46.95
30.73
194.05
7.63
166.8
161.3
Chase
Null bucket
LinkedNulls
Simpliﬁcations
Figure 9: Average time of each operation per DBMS (ms) removing outsiders with more than 30 s
diﬀerences
However, this augmentation is negligible as our model is designed to optimize such a query (Fig-
ure 10d).
Experimental results in terms of execution time of our updating approach is shown in Figures 10b
and 10c. In MySQL (Figure 10b), update execution time is linear in the number of nulls while the
database size has little impact. Indeed, as the number of queries increases with the number of nulls,
update execution time in MySQL increases accordingly. In Neo4J (Figure 10c), update execution
time is more signiﬁcantly impacted by the size of the instance.
The explanation of this discrepancy comes from the separate analysis of the performance of the
main operations of our approach (Figures 9 and 10d). The data model chosen in the Neo4J version
optimizes the retrieval of LinkedNull, but is not appropriate to operations involving simpliﬁcation
(Section 4). Such operations involve complex pattern matching which are known to be expensive.
The chase (Figure 9) is the most expensive operation for Neo4J, mainly due to the fact that it
includes a simpliﬁcation step (e.g., if A(a, b) ∈D and A(a, N1) is generated by a constraint, then
the insertion of A(a, N1) is canceled).
For the sake of readability, plots do not show results on GOT instances with more than 17 000
nulls. The results on this data set are similar: execution time evolves linearly with respect to nulls
in MySQL and follows the size of the database in Neo4J. With the GOT runs, we achieve a mean
execution time of 14 634ms with MySQL and 5216 ms with Neo4J for 24 818 facts and 17 232 nulls.
Increasing the size to 124 090 facts and 86 160 nulls rises run time to 156 132ms with MySQL and
to 203 140ms with Neo4J.
Reproducibility.
Results obtained by our experiments are reproducible through the use of the
benchmarks and implementation available in https://gitlab.com/jacques-chabin/UpdateChase.
24

---

0
500
1,000
1,500
2,000
2,500
3,000
3,500
4,000
4,500
5,000
5,500
0
1,000
2,000
3,000
4,000
5,000
6,000
Nb of nulls
Nb of queries
MySQL (INS)
MySQL (DEL)
Neo4J (INS)
Neo4J (DEL)
0
20,000
40,000
60,000
80,000
Nb of facts
Number of facts
(a) Number of queries per null
0
500
1,000
1,500
2,000
2,500
3,000
3,500
4,000
4,500
5,000
5,500
0
2,000
4,000
6,000
8,000
10,000
12,000
14,000
Nb of nulls
Time [ms]
Insert
Delete
0
20,000
40,000
60,000
80,000
Nb of facts
Number of facts
(b) Time per null for MySQL
Figure 10: Benchmarks results of 540 scenarios, average over 10 runs
25

---

0
500
1,000
1,500
2,000
2,500
3,000
3,500
4,000
4,500
5,000
5,500
0
1 · 105
2 · 105
3 · 105
4 · 105
5 · 105
6 · 105
Nb of nulls
Time [ms]
Insert
Delete
0
20,000
40,000
60,000
80,000
Nb of facts
Number of facts
(c) Time per null for Neo4J
0
500
1,000
1,500
2,000
2,500
3,000
3,500
4,000
4,500
5,000
5,500
0
1 · 105
2 · 105
3 · 105
4 · 105
Nb of nulls
Time [ms]
MySQL (chase)
MySQL (null bucket)
MySQL (linked nulls)
MySQL (simpliﬁcations)
Neo4J (chase)
Neo4J (null bucket)
Neo4J (linked nulls)
Neo4J (simpliﬁcations)
0
20,000
40,000
60,000
80,000
Nb of facts
Number of facts
(d) Time of operations per null
Figure 10: Benchmarks results of 540 scenarios, average over 10 runs
26

---

8
Related Works
Our work goals include four important features of modern applications: incompleteness, consistency
as a measure of quality, incremental tools for eﬃcient data processing and adaptability to graph
data models.
Solid basis have been established for treating incompleteness of relational databases
[12, 18,
23, 28, 32], particularly for querying. Much less attention has been given to updates on incom-
plete databases, although important work, such as [1, 13, 31] can be cited. Today, integrating and
exchanging data are very common, leading to the proliferation of applications involving dynamic
incomplete data on emerging data models that deal with more general graph-structured data. In-
completeness beyond the relational data model has received much less attention [30], and, in this
context, updating with respect to constraints is rarely considered. Indeed, consistency maintenance
is usually left aside in favour of eﬃciency, which can prove costly when we are concerned with the
quality of analytical results. Work such as [21, 25, 29] witnesses the complexity of the problem of
keeping a database consistent with respect to constraints in a dynamic environment. In [15, 19, 20]
we ﬁnd newer proposals, adapted to the RDF world, that considers constraints in our traditional
database viewpoint (i.e., not in the web semantic standard way, where constraints are just inference
rules [17, 24, 27]). It is worth noting that the use of tuple generating constraints (TGD) increases
expressiveness at the cost of diﬃculties that involve a chase procedure (cf. a survey in [26], a bench-
mark in [7]) to compute semantics and the generation of side eﬀects in an update context - imposing
extra insertions or deletions (with respect to those required by the user) to preserve consistency.
The literature oﬀers suﬃcient conditions to avoid a non-terminating chase which consist in limiting
the format of constraints. We instead introduce δmax, keeping the possibility of dealing with any
kind of constraints while avoiding inﬁnite processing. Furthermore, we use simpliﬁcations to keep
the database instance as small as possible and to avoid the presence of useless nulls, i.e., database
maintenance consists in keeping its core (which follows the ideas in [11]) whose implementation is
ensured by a simpliﬁcation routine performed in association to update routines.
In brief, data analytic tools become essential in diﬀerent application domains and their quality
relies on data consistency. But in order to deal with huge scale applications, we must aim at eﬃcient
data processing solutions [30], bringing incremental solutions to the front of the stage, particularly
when working with new data models (as done in the XML context [3, 6, 8]). In the context of
graph databases, the approach in [14] proposes a method for ‘incrementalizing’ graph algorithms
abstracted in a ﬁx-point model. Our approach cannot be summarized by that proposal. As seen
before, we can outline our method in the expression D′ = core|NullBucket(upd|U((D♦U)) where U is
the set of user’s required updates - this set is increased through an inference process that generates
side-eﬀects. The proposal in [14] needs a ’complete’ set of updates as input. In other words, our
ﬁx-point operation involves changes on the update set while in [14] the update set is ﬁxed. Their
goal is to incrementally compute new answers on an updated graph and not to incrementally update
the graph. As the core computation is not a ﬁx-point one, it is not in the scope of [14].
Finally, our experiments reinforce the idea that graph schema design has a signiﬁcant impact
on query performance. Our graph schema is designed to optimize one type of query and performs
badly to those that diﬀer widely. Schema optimization may be a solution: as in [5], in this paper, it
is done through techniques that reduce edge transversal.
9
Conclusions
This paper contributes to improve the maintenance of consistent incomplete databases by proposing
incremental routines that interact with database systems. It extends prior work in [9] where a from-
27

---

scratch in-memory method was proposed. Two implementations of our approach, one under a graph
database model and one under the traditional relational database model, are presented. Experiment
results raise questions about the representation of nulls in a graph database. Indeed, this work is
also a step towards incremental updating attributed graphs with incomplete data. It illustrates the
impact of schema graph design in querying and, consequently, in the performance of an incremental
updating approach that relies on two main queries: one that looks for linked nulls and another
that looks for redundant atoms willing to be simpliﬁed. Property graph model has an increasingly
important role today, the handling of nulls in such a model is related to schema deﬁnition and query
optimization issues that need to be further explored.
References
[1] Abiteboul, S., and Grahne, G. Mise-`a-jour des bases de donn´ees contenant de l’information
incompl`ete. In Journ´ees Bases de Donn´ees Avanc´es, 6-8 Mars 1985, St. Pierre de Chartreuse
(Informal Proceedings). (1985).
[2] Abiteboul, S., Hull, R., and Vianu, V. Foundations of databases, vol. 8. Addison-Wesley
Reading, 1995.
[3] Abr˜ao, M. A., Bouchou, B., Halfeld Ferrari, M., Laurent, D., and Musicante,
M. A. Incremental constraint checking for XML documents. In XSym (2004), no. 3186 in
LNCS, pp. 112–127.
[4] Aho, A. V., Sagiv, Y., and Ullman, J. D. Eﬃcient optimization of a class of relational
expressions. ACM Trans. Database Syst. 4, 4 (1979), 435–454.
[5] Alotaibi, R., Lei, C., Quamar, A., Efthymiou, V., and ¨Ozcan, F. Property graph
schema optimization for domain-speciﬁc knowledge graphs. In 37th IEEE International Con-
ference on Data Engineering, ICDE 2021, Chania, Greece, April 19-22, 2021 (2021), IEEE,
pp. 924–935.
[6] Balmin, A., Papakonstantinou, Y., and Vianu, V. Incremental validation of xml docu-
ments. ACM Trans. Database Syst. 29, 4 (2004), 710–751.
[7] Benedikt, M., Konstantinidis, G., Mecca, G., Motik, B., Papotti, P., Santoro,
D., and Tsamoura, E. Benchmarking the chase. In Proceedings of the 36th ACM SIGMOD-
SIGACT-SIGAI Symposium on Principles of Database Systems, PODS 2017, Chicago, IL,
USA, May 14-19, 2017 (2017), pp. 37–52.
[8] Bouchou, B., and Halfeld Ferrari Alves, M. Updates and incremental validation of
XML documents. In The 9th International Workshop on Data Base Programming Languages
(DBPL) (2003), Springer, Ed., no. 2921 in LNCS.
[9] Chabin, J., Halfeld Ferrari, M., and Laurent, D. Consistent updating of databases
with marked nulls. Knowl. Inf. Syst. 62, 4 (2020), 1571–1609.
[10] Chandra, A. K., and Merlin, P. M. Optimal implementation of conjunctive queries in
relational data bases. In Symposium on the Theory of Computing (1977).
[11] Fagin, R., Kolaitis, P. G., and Popa, L. Data exchange: getting to the core. ACM Trans.
Database Syst. 30, 1 (2005), 174–210.
28

---

[12] Fagin, R., Kuper, G. M., Ullman, J. D., and Vardi, M. Y. Updating logical databases.
Advances in Computing Research 3 (1986), 1–18.
[13] Fagin, R., Ullman, J. D., and Vardi, M. Y. On the semantics of updates in databases.
In Proceedings of the Second ACM SIGACT-SIGMOD Symposium on Principles of Database
Systems, Colony Square Hotel, Atlanta, Georgia, USA (1983), pp. 352–365.
[14] Fan, W., Tian, C., Xu, R., Yin, Q., Yu, W., and Zhou, J.
Incrementalizing graph
algorithms. In SIGMOD ’21: International Conference on Management of Data, Virtual Event,
China, June 20-25, 2021 (2021), G. Li, Z. Li, S. Idreos, and D. Srivastava, Eds., ACM, pp. 459–
471.
[15] Flouris, G., Konstantinidis, G., Antoniou, G., and Christophides, V. Formal foun-
dations for RDF/S KB evolution. Knowl. Inf. Syst. 35, 1 (2013), 153–191.
[16] Francis, N., Green, A., Guagliardo, P., Libkin, L., Lindaaker, T., Marsault, V.,
Plantikow, S., Rydberg, M., Selmer, P., and Taylor, A. Cypher: An evolving query
language for property graphs. In Proceedings of the 2018 International Conference on Man-
agement of Data, SIGMOD Conference 2018, Houston, TX, USA, June 10-15, 2018 (2018),
G. Das, C. M. Jermaine, and P. A. Bernstein, Eds., ACM, pp. 1433–1445.
[17] Gottlob, G., Orsi, G., and Pieris, A. Ontological queries: Rewriting and optimization. In
Proceedings of the 27th International Conference on Data Engineering, ICDE, Germany (2011),
pp. 2–13.
[18] Grahne, G.
The Problem of Incomplete Information in Relational Databases, vol. 554 of
Lecture Notes in Computer Science. Springer, 1991.
[19] Halfeld Ferrari, M., Hara, C. S., and Uber, F. R. RDF updates with constraints. In
Knowledge Engineering and Semantic Web - 8th International Conference, KESW, Szczecin,
Poland, Proceedings (2017), pp. 229–245.
[20] Halfeld Ferrari, M., and Laurent, D. Updating RDF/S databases under constraints. In
Advances in Databases and Information Systems - 21st European Conference, ADBIS, Nicosia,
Cyprus, Proceedings (2017), pp. 357–371.
[21] Halfeld Ferrari Alves, M., Laurent, D., and Spyratos, N. Update rules in datalog
programs. J. Log. Comput. 8, 6 (1998), 745–775.
[22] Hell, P., and Nesetril, J. The core of a graph. Discrete Mathematics 109, 1-3 (1992),
117–126.
[23] Imielinski, T., and Lipski Jr., W. Incomplete information in relational databases. J. ACM
31, 4 (1984), 761–791.
[24] Lausen, G., Meier, M., and Schmidt, M.
Sparqling constraints for RDF.
In EDBT,
11th International Conference on Extending Database Technology, France, Proceedings (2008),
pp. 499–509.
[25] Link, S., and Schewe, K. An arithmetic theory of consistency enforcement. Acta Cybern.
15, 3 (2002), 379–416.
29

---

[26] Onet, A. The chase procedure and its applications in data exchange. In Data Exchange,
Integration, and Streams. 2013, pp. 1–37.
[27] Patel-Schneider, P. F. Using description logics for RDF constraint checking and closed-
world recognition. In Proceedings of the Twenty-Ninth AAAI Conference on Artiﬁcial Intelli-
gence, USA. (2015), pp. 247–253.
[28] Reiter, R.
A sound and sometimes complete query evaluation algorithm for relational
databases with null values. J. ACM 33, 2 (1986), 349–370.
[29] Schewe, K., and Thalheim, B. Limitations of rule triggering systems for integrity mainte-
nance in the context of transition speciﬁcations. Acta Cybern. 13, 3 (1998), 277–304.
[30] Sirangelo, C. Representing and Querying Incomplete Information: a Data Interoperability
Perspective. 2014.
[31] Winslett, M. Updating Logical Databases. Cambridge University Press, New York, NY, USA,
1990.
[32] Zaniolo, C. Database relations with null values. J. Comput. Syst. Sci. 28, 1 (1984), 142–166.
30

---

