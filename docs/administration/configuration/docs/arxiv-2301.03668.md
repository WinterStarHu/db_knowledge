# Consistent Query Answering without Repairs in Tables with Nulls and Functional D

> 来源: https://arxiv.org/pdf/2301.03668

Consistent Query Answering without Repairs in Tables with
Nulls and Functional Dependencies
Dominique Laurent
dominique.laurent@u-cergy.fr
ETIS Laboratory - ENSEA, CY Cergy Paris University, CNRS
F-95000 Cergy-Pontoise - FRANCE
Nicolas Spyratos
nicolas.spyratos@lri.fr
LISN Laboratory - University Paris-Saclay, CNRS
F-91405 Orsay - FRANCE
February 16, 2023
Abstract
In this paper, we study consistent query answering in tables with nulls and functional
dependencies. Given such a table T, we consider the set T of all tuples that can be built up
from constants appearing in T; and we use set theoretic semantics for tuples and functional
dependencies to characterize the tuples of T in two orthogonal ways: ﬁrst as true or false
tuples; and then as consistent or inconsistent tuples.
Queries are issued against T and
evaluated in T .
In this setting, we consider a query Q: select X from T where Condition over T and deﬁne its
consistent answer to be the set of tuples x in T such that: (a) x is a true and consistent tuple
with schema X and (b) there exists a true super-tuple t of x in T satisfying the condition.
We show that, depending on the ‘status’ that the super-tuple t has in T , there are diﬀerent
types of consistent answer to Q.
The main contributions of the paper are: (a) a novel approach to consistent query answering
not using table repairs; (b) polynomial algorithms for computing the sets of true/false tuples
and the sets of consistent/inconsistent tuples of T ; (c) polynomial algorithms in the size of
T for computing diﬀerent types of consistent answer for both conjunctive and disjunctive
queries; and (d) a detailed discussion of the diﬀerences between our approach and the
approaches using table repairs.
Keywords: database semantics, inconsistent database, functional dependency, null value, con-
sistent query answering
1
Introduction
In a relational database, each table is seen as a set of tuples that must satisfy a set of functional
dependencies. Moreover, each table is assumed to be consistent with the dependencies and its
tuples are assumed to be true when users query the table (these are basic assumptions in relational
databases). Consistency is veriﬁed during updates in the following sense: if the update to be
performed results in an inconsistent table then the update is rejected, otherwise it is accepted.
1
arXiv:2301.03668v2  [cs.DB]  15 Feb 2023

---

However, the consistency of a table in general is not always easy to verify, for example if the
table is the result of integrating data coming from independent sources (e.g., web sources). In
such cases the table may contain inconsistent tuples, and the problem is: how to answer user
queries so that the answers contain only tuples that are true and consistent. This kind of query
answering process is usually referred to as consistent query answering [1, 3].
T
Emp
Dept
Addr
1
e
d
a
2
e
d
a′
3
e′
d′
a
repairs
====⇒
R1
Emp
Dept
Addr
1
e
d
a
3
e′
d′
a
R2
Emp
Dept
Addr
2
e
d
a′
3
e′
d′
a
Figure 1: An inconsistent table and its two repairs
To see an example, consider the table T of Figure 1, with dependencies Emp →Dept and
Dept →Addr.
The table T is deﬁned over attributes Emp, Dept and Addr, standing for
‘employee identiﬁer’, ‘department identiﬁer’ and ‘department address’, respectively.
This table is inconsistent as the pair of tuples 1 and 2 violates the dependency Dept →Addr.
However, if we ask the SQL query Q : select Emp, Dept from T, it makes sense to return the
set of tuples {ed, e′d′} as the answer. Indeed, there is no reason to reject this answer as it is a
consistent answer, in the sense that it satisﬁes the dependency Emp →Dept. In other words,
an inconsistent table might contain some consistent parts (i.e., some useful information) which
can be extracted through queries.
The traditional approach to alleviate the impact of inconsistent data on query answers is to
introduce the notion of repair: a repair is a maximal consistent sub-set of the table, and a tuple t
is in the consistent answer if t is present in the answer from every repair [1, 19]. To illustrate this
approach, consider again the table T in Figure 1 with its two repairs, namely R1 = {eda, e′d′a}
and R2 = {eda′, e′d′a}.
Both these repairs are consistent with the given dependencies, and
maximal with respect to set-theoretic inclusion. The answer to Q from R1 is {ed, e′d′} and so is
the answer from R2. Therefore the consistent answer to Q is {ed, e′d′}. We note here that the
complexity of the query evaluation algorithm in the repairs approach is APX-complete1 [14].
Now, in several applications today we have to deal with tables containing nulls (i.e., missing
values) and having to satisfy a set of functional dependencies. The presence of nulls in a table is
due to various reasons such as: ‘value does not exist’ (e.g., the maiden name of a male employee);
‘value exists but is currently unknown’ (e.g., the department of a newly hired employee currently
following a training course before being assigned to a speciﬁc department); and so on. A survey
of the diﬀerent kinds of missing values considered in the literature can be found in [13]. In our
approach we assume that missing values are of the kind ‘value exists but is currently unknown’.
In the context of the previous example, let T = {ed, da, ea′} in which the Addr-value in ed,
the Emp-value in da and the Dept-value in ea′ are nulls that is they exist but are currently
unknown.
Considering the query Q : select Emp, Addr from T, if T is seen as a regular
table, the consistent answer to Q is {ea′}, as the tuples in T ‘seem’ to satisfy the functional
dependencies Emp →Dept and Dept →Addr.
However, these functional dependencies allow to infer the missing values: from tuples ed and
da, it can be inferred that eda is true, and from tuples ed, ea′ it can be inferred that eda′ is
true. This shows that Dept →Addr is not satisﬁed, and thus {ea′} should not be returned as a
1We recall that APX is the set of NP optimization problems that allow polynomial-time approximation algo-
rithms (source Wikipedia).
2

---

consistent answer. The process of inferring missing values in a table is known in the literature
as the chase procedure [10, 17, 18], and it is well-known that this procedure fails (i.e., stops and
returns no table) when encountering an inconsistency. Therefore, the repair-based approaches
do not work in the presence of nulls.
In the light of the previous example, we propose a novel approach to consistent query an-
swering that does not rely on repairs, but that works in the case where the given set of tuples
contains missing values.
In our approach one starts again with a set of tuples T that are not required to be all of them
deﬁned over the same set of attributes. Therefore T is represented as a table with nulls. However,
nulls simply act as place holders that may receive values implied by functional dependencies, as
shown in the previous example. What is signiﬁcant in our approach is the set T , called the
universe of discourse of T, containing all tuples that can be built up from values appearing in T.
In our previous example, T consists of the tuples eda and eda′ together with all their sub-tuples.
Queries are addressed to T and consistent answers are obtained from T . To achieve this
we associate every tuple t in T with a set of identiﬁers, referred to as the interpretation of t.
In doing so, we deﬁne set-theoretic semantics for tuples and for functional dependencies which
allows us to characterize the tuples of T along two orthogonal dimensions: a tuple of T can be
true or false on one hand and consistent or inconsistent on the other hand.
In this setting, we consider a query Q : select X from T where Condition over T and we
deﬁne its consistent answer as the set of tuples x in T such that: (a) x is a true and consistent
tuple with schema X and (b) there exists a true super-tuple t of x in T satisfying the condition.
We show that, depending on the ‘status’ that the super-tuple t has in T , there are diﬀerent types
of consistent answer to Q.
The important point to emphasize again is that, in our approach, queries are addressed to T
and evaluated using the universe of discourse T . As mentioned earlier, T is the set of all tuples
that one can deﬁne using values appearing in T. Actually, the fundamental diﬀerence between
our approach and all approaches based on repairs is that their universe of discourse is the table T
itself. Therefore our approach is simply not comparable to approaches based on repairs. To see
this, consider again our previous example but this time with Emp →Addr as the only functional
dependency.
Now suppose that T = {eda, eda′, e′da′} and that we ask for the set of all addresses. Then the
answer in the repairs approach is {a′} because there are only two repairs, R1 = {eda, e′da′} and
R2 = {eda′, e′da′}, and the answers from each repair are respectively {a, a′} and {a′}; whereas
in our approach, the answer is empty because a and a′ are both inconsistent tuples of T . On the
other hand, if T = {eda, ed′a′} and we ask for the set of all departments then the answer in the
repairs approach is empty because there are only two repairs, R1 = {eda} and R2 = {ed′a′} and
none of d, d′ is in the answer from both repairs; whereas, in our approach, the answer is {d, d′}
because both d and d′ are true and consistent tuples of T .
Our work builds upon earlier work on partition semantics [8, 17] and on inconsistent tables
with missing values [12]. The main contributions of this paper are as follows:
1. We propose a novel approach to consistent query answering in tables with nulls and func-
tional dependencies, without using table repairs.
2. We provide polynomial algorithms for computing (a) the sets of true/false tuples and the
sets of consistent/inconsistent tuples of T and (b) for computing the consistent answer to
any conjunctive or disjunctive query over T.
3. We oﬀer a detailed discussion of the diﬀerences between our approach and other approaches
including the approaches by table repairs.
3

---

The remaining of the paper is organized as follows. In Section 2 we ﬁrst introduce the basic
notions and notation of our approach, and we present our set-theoretic semantics for tuples
and functional dependencies; in Section 3 we address the issue of consistent query answering,
introducing the notion of consistency with respect to a selection condition; in Section 4 we ﬁrst
deﬁne the m-Chase algorithm, a chase-like algorithm for computing the sets of true/false tuples
and the sets of consistent/inconsistent tuples of T , and then we propose a polynomial algorithm
for computing consistent answers; in Section 5 we compare our approach to the repair approaches
and discuss other related work; and ﬁnally, in Section 6 we oﬀer concluding remarks and outline
current work and future perspectives.
2
The Semantics of our Model
In this section we recall basic deﬁnitions from the relational model regarding tuples and tables,
and we present the set-theoretic semantics that we use for tuples and functional dependencies.
Our approach builds upon the so-called “partition model” introduced in [17].
2.1
Terminology and Notation
Following [17], we consider a universe U = {A1, . . . , An} in which every attribute Ai is associated
with a set of atomic values called the domain of Ai and denoted by dom(Ai). An element of
S
A∈U dom(A) is called a constant.
We call relation schema (or simply schema) any nonempty sub-set of U and we denote it by
the concatenation of its elements; for example {A1, A2} is simply denoted by A1A2. Similarly,
the union of schemes S1 and S2 is denoted as S1S2 instead of S1 ∪S2.
We deﬁne a tuple t over U to be a partial function from U to S
A∈U dom(A) such that, for
every A in U, if t is deﬁned over A then t(A) belongs to dom(A). The domain of deﬁnition
of t is called the schema of t, denoted by sch(t). We note that tuples in our approach satisfy
the First Normal Form [18] in the sense that each tuple component is an atomic value from the
corresponding attribute domain.
Regarding notation, we follow the usual convention that, whenever possible, lower-case char-
acters denote domain constants and upper-case characters denote the corresponding attributes.
Following this convention, the schema of a tuple t = ab is AB and more generally, we denote the
schema of a tuple s as S.
Assuming that the schema of a tuple t is understood, t is denoted by the concatenation of
its values, that is: t = ai1 . . . aik means that for every j = 1, . . . , k, t(Aij) = aij, where aij is in
dom(Aij), and sch(t) = Ai1 . . . Aik.
As in [17], we assume that for any two distinct attributes A and B, we have dom(A) ∩
dom(B) = ∅. However, it might be relevant for attribute domains to share values. For instance, in
our introductory example, in the presence of attribute Mgr standing for ‘manager’, the domains
of Emp and Mgr are employee identiﬁers. In such cases, in order to avoid confusion, we denote
attribute values as pairs of the form ⟨attribute name, value⟩and comparisons are assessed with
respect to their value component only.
In order to keep the notation simple we shall omit
attribute names as preﬁxes whenever no ambiguity is possible.
We deﬁne a table T over U to be any ﬁnite set of tuples over U (therefore duplicates are not
allowed). As tuples over U are partial functions over U, it follows that T may contain nulls.
Given a table T over U, we denote by T the set of all tuples that can be built up from
constants appearing in T; and we call T the universe of discourse of T as it contains all tuples of
interest in query processing. Actually, as we shall see shortly, queries are issued against T and
4

---

consistent answers are obtained from T . For every relation schema X, we denote by T (X) the
set of all tuples in T whose schema is X. Formally, T (X) = {t ∈T | sch(t) = X}.
For every A in U, the set of all values from dom(A) occurring in T is referred to as the active
domain of A, denoted by adom(A). We denote by AD the set of all constants appearing in T
that is: AD = S
A∈U adom(A). We emphasize that even when attribute domains are inﬁnite,
active domains are always ﬁnite and therefore the sets AD and T are ﬁnite as well.
Given a tuple t, for every A in sch(t), t(A) is also denoted by t.A and more generally, for
every nonempty sub-set S of sch(t) the restriction of t to S, also called sub-tuple of t, is denoted
by t.S. In other words, if S ⊆sch(t), t.S is the tuple such that sch(t.S) = S, and for every A in
S we have (t.S).A = t.A.
Moreover, ⊑denotes the ‘sub-tuple’ relation, deﬁned over T as follows: for any tuples t1 and
t2, t1 ⊑t2 holds if t1 is a sub-tuple of t2. It is thus important to keep in mind that whenever
t1 ⊑t2 holds, it is understood that sch(t1) ⊆sch(t2) also holds. The relation ⊑is clearly a
partial order over T . Given a table T, the set of all sub-tuples of the tuples in T is called the
lower closure of T and it is deﬁned by: LoCl(T) = {q ∈T | (∃t ∈T)(q ⊑t)}.
2.2
Partition Semantics for Tuples
In this work, we consider tables T over a set U of attributes, possibly with nulls, and we assume
that every tuple t in T is associated with a unique identiﬁer, id(t). We denote by TID the set
of all identiﬁers of tuples in T ; that is: TID = {id(t) | t ∈T }. In our examples, for simplicity,
we assume that TID is a set of positive integers. Denoting by P(TID) the power-set of TID,
the following deﬁnition of interpretation is in the spirit of [17].
Deﬁnition 1 Let T be a table over U. We call interpretation of T any function I from T to
P(TID) such that:
• For every tuple t of T, I(t)̸ = ∅
• For every tuple t = a1a2 . . . an of T , I(t) = I(a1) ∩I(a2) ∩. . . ∩I(an)
We say that a tuple t in T is true in I if I(t)̸ = ∅; otherwise we say that t is false in I. We
denote by True(I) the set of tuples t that are true in I and by False(I) the set of tuples t that
are false in I.
2
Example 1 Let T = {ab, a′c} and let I be a function from T to P(TID) deﬁned as follows:
I(a) = {1, 2}, I(a′) = {2}, I(b) = {1, 2}, I(c) = {2}, I(ab) = {1, 2}, I(ac) = {2}, I(a′b) = {2},
I(a′c) = {2}, I(abc) = {2}, I(a′bc) = {2}. Then I is an interpretation of T as we have:
• I(ab)̸ = ∅and I(a′c)̸ = ∅that is the two tuples of T are true in I
• For every tuple t in T , I(t) is indeed the intersection of the interpretations of its compo-
nents. For example, I(ac) = I(a) ∩I(c) = {1, 2} ∩{2} = {2} and one can verify easily for
the remaining tuples of T .
2
It is important to note that the ﬁrst item in Deﬁnition 1 expresses a fundamental assumption
regarding a relational table T, namely that every tuple t of T is assumed to be true.
Two
immediate consequences are that (a) I(a)̸ = ∅, for all a in AD (i.e., every a in AD is true in I)
and (b) if a tuple t is true in I then so is every sub-tuple of t; and if t is false in I then so is
every super-tuple of t. As a consequence the set T is partitioned into true and false tuples that
is True(I) ∪False(I) = T and True(I) ∩False(I) = ∅.
The interpretations of T can be compared according to the following deﬁnition.
5

---

Deﬁnition 2 Let T be a table and I, I′ two interpretations of T. Then we say that I is less
than or equal to I′, denoted I ⪯I′ if for every t in T , I(t) ⊆I′(t).
2
It is easy to see that the relation ⪯is a partial ordering over the set of all interpretations of T.
Note that if we view the constants of AD as unary tuples then we have that: if I ⪯I′ then for
every a in AD, I(a) ⊆I′(a) holds; and in the opposite direction, if I(a) ⊆I′(a) holds for every
a in AD then for every t in T , I(t) ⊆I′(t) also holds that is I ⪯I′ holds. Therefore we have
that:
• I ⪯I′ holds if and only if for every a in AD, I(a) ⊆I′(a).
Based on this result, in order to verify whether I ⪯I′, it is suﬃcient to do so for every constant
in AD rather than for every tuple in T .
Now, to see the intuition behind the above deﬁnitions, think of the identiﬁers of TID as being
objects and of every a in AD as being an atomic property that each object may have. Then I(a)
is the set of objects having property a; and similarly, the intuitive idea behind the interpretation
of a tuple is that a tuple, say ab, is the ‘conjunction’ of the atomic properties a and b. Therefore
I(ab) is the set of objects each having both properties a and b, hence I(ab) = I(a)∩I(b). Clearly,
if I(ab) = ∅then no object has both properties a and b so the tuple ab is false in I.
As for the ordering of interpretations what I ⪯I′ means is that, for every property t of T ,
the set of objects having property t in I is included in the set of objects having property t in I′.
Another fundamental assumption made in the relational model is that the components of
every tuple be atomic. Actually such a tuple is said to satisfy the First Normal Form [18]. To
express this assumption using our deﬁnition of interpretation, suppose that there are a, a′ in
adom(A) such that a̸ = a′ and I(a)∩I(a′)̸ = ∅. Then every tuple whose identiﬁer is in I(a)∩I(a′)
violates the First Normal Form as its A-component is {a, a′}, therefore not atomic. In the light
of this observation we introduce the following deﬁnition of inconsistent tuple.
Deﬁnition 3 Let T be a table over U and I an interpretation of T. A tuple t in T is said
to be inconsistent in I if there exist A in sch(t) and a′ in adom(A) such that t.A̸ = a′ and
I(t) ∩I(a′)̸ = ∅.
The set of all inconsistent tuples in I is denoted by Inc(I). A tuple that is not inconsistent
in I is said to be consistent in I, and the set of all consistent tuples in I is denoted by Cons(I).
An interpretation I such that Inc(I) = ∅is said to be in First Normal Form.
2
For instance, in Example 1, the tuple t = abc is inconsistent in I as A is in sch(t), and a′ is in
adom(A) such that t.A̸ = a′ and I(t)∩I(a′) = {2}̸ = ∅. Therefore I is not in First Normal Form.
In view of the above deﬁnition, the set T is partitioned into inconsistent and consistent tuples
that is Inc(I) ∪Cons(I) = T and Inc(I) ∩Cons(I) = ∅. Roughly speaking, inconsistent tuples
are those that violate the First Normal Form. This relationship between inconsistency and First
Normal Form is stated formally in the following lemma.
Lemma 1 Let I be an interpretation of T. Then I is in First Normal Form if and only if I
satisﬁes the following constraint:
Partition constraint (PC): For all A in U and for all a, a′ in adom(A), if a̸ = a′ then
I(a) ∩I(a′) = ∅.
Proof. Assume that I satisﬁes PC and that Inc(I)̸ = ∅. Given t in Inc(I), using the notation
of Deﬁnition 3 and denoting by a the A-value occurring in t, we have I(a) ∩I(a′)̸ = ∅, because
I(t) ⊆I(a) ∩I(a′). Hence, I does not satisfy PC, which is a contradiction.
6

---

Conversely, if I does not satisfy PC, then there exist A in U and a and a′ such that I(a) ∩
I(a′)̸ = ∅. Therefore, by Deﬁnition 3, a and a′ are in Inc(I), thus implying that I is not in First
Normal Form. The proof is therefore complete.
2
Note that, as mentioned in [12], satisfaction of the partition constraint implies that, for all A in
U, the set {I(a) | a ∈adom(A)} is a partition of the set adom(A) (whence the term “partition
constraint”).
An important question remains regarding the deﬁnition of an interpretation: is there a sys-
tematic way for deﬁning an interpretation I of a given table T which is in First Normal Form?
The answer is yes, there is such a “canonical” interpretation for every table T; it is called the
basic interpretation of T, denoted by Ib and deﬁned as follows:
Basic Interpretation Ib: For every A in U and every a in adom(A), Ib(a) = {id(t) | t ∈
T and t.A = a}.
In the context of Example 1 where T = {ab, a′c}, if ab and a′c are respectively associated with
identiﬁers 1 and 2, the associated basic interpretation Ib is deﬁned by Ib(a) = Ib(b) = {1} and
Ib(a′) = Ib(c) = {2}. Considering T1 = {ab, bc, ac} with respective identiﬁers 1, 2 and 3, the
basic interpretation Ib
1 is deﬁned by Ib
1(a) = {1, 3}, Ib
1(b) = {1, 2} and Ib
1(c) = {2, 3}.
It is interesting to note that the deﬁnition of basic interpretation parallels that of inverted
ﬁle [22, 21]. Indeed, we ﬁrst recall that an inverted ﬁle is an index data structure that maps
content to its location within a database ﬁle, in a document or in a set of documents. Hence, if
we assume that each tuple of T is implemented as a record (possibly with missing values) then
we can view T as a ﬁle that is as a function I assigning to each value x appearing in the ﬁle
record the set I(x) of all identiﬁers of records in which x appears.
The following lemma summarizes important properties of the basic interpretation.
Lemma 2 Let T be a table and Ib its basic interpretation as deﬁned above. Then:
1. Ib is an interpretation satisfying the partition constraint.
2. True(Ib) = LoCl(T) and True(Ib) is the set of all tuples t that belong to True(I) for every
interpretation I of T.
3. Ib is minimal with respect to ⪯among all interpretations I of T such that for every t in
T, id(t) belongs to I(t).
Proof. 1. Assume that there exist A in U and a and a′ in adom(A) such that Ib(a)∩Ib(a′)̸ = ∅.
If i is in Ib(a) ∩Ib(a′)̸ = ∅, let ti be the tuple in T such that id(ti) = i. This implies that the
value of ti(A) is a and a′, which is impossible because, as ti is a function, ti(A) consists of at
most one value in adom(A). This part of the proof is thus complete.
2. Since for every t in T, Ib(t) contains id(t) and as for every t′ such that t′ ⊑t, we have
Ib(t) ⊆Ib(t′), it follows that LoCl(T) ⊆True(Ib). Conversely, let t not in LoCl(T) and assume
that Ib(t)̸ = ∅. Since t is not in T, it is not associated with an identiﬁer. Hence, Ib(t) contains
identiﬁers of other tuples, and if q is such a tuple, then by deﬁnition of Ib, this implies that
id(q) belongs to every component of t, that is that t is a sub-tuple of q. A contradiction showing
that True(Ib) ⊆LoCl(T).
Hence we have True(Ib) = LoCl(T).
Moreover, since for every
interpretation I of T, True(I) must at least contain all tuples in T along with their sub-tuples (as
argued just above), we have LoCl(T) ⊆True(I). Hence, True(Ib) ⊆True(I), which completes
this part of the proof.
3. Let I be an interpretation such that I ⪯Ib and I̸ = Ib. Thus, there exists a in AD such
that I(a) ⊂Ib(a). However, since I is an interpretation such that for every t in T, id(t) belongs
7

---

to I(t), if a occurs in t then id(t) belongs to I(a).
In other words, Ib(a) ⊆I(a) holds.
A
contradiction showing that Ib is minimal with respect to ⪯among all interpretations I of T such
that for every t in T, id(t) belongs to I(t). The proof is therefore complete.
2
By Deﬁnition 3 and Lemma 1, it turns out that, since Ib satisﬁes the partition constraint PC,
Ib is in First Normal Form, therefore Inc(Ib) = ∅.
From now on, in all our examples we shall use the following convention: the tuples of T will
receive successive integer identiﬁers in the order of their appearance in T, starting with number
1. For example, if T = {ab, a′c} as in Example 1, then it is understood that id(ab) = 1 and
id(a′c) = 2. Then, the basic interpretation of T is deﬁned as earlier stated, that is: Ib(ab) = {1},
Ib(a′c) = {2}, Ib(a) = {1}, Ib(a′) = {2}, Ib(b) = {1}, Ib(c) = {2}. Thus, Ib(ac) = ∅, Ib(abc) = ∅,
Ib(a′bc) = ∅. Therefore we have: True(Ib) = {a, a′, b, c, ab, a′c} and False(Ib) = {ac, abc, a′bc}.
Note that Ib is an interpretation that satisﬁes the partition constraint.
2.3
Partition Semantics for Functional Dependencies
Let T be a table over a set U of attributes together with a set FD of functional dependencies. As
usual in relational databases [18], a functional dependency is an expression of the form X →Y
where X and Y are relation schemes. The notion of functional dependency satisfaction in the
context of tables with nulls is stated in the literature [9, 10] in the following terms. A table T
satisﬁes X →Y if for all tuples t and t′ in T the following holds: if XY is a sub-set of sch(t)
and of sch(t′) then t.X = t′.X implies t.Y = t′.Y .
Moreover, it is well-known that a relation satisﬁes X →Y if and only if it satisﬁes the
functional dependencies X →A, for every A in Y . This justiﬁes that functional dependencies
are usually assumed to be of the form X →A, where X is a relation schema and A is an attribute
not in X. In what follows, we make this assumption.
Now, the question that we answer in this section is the following: how can an interpretation
I of T express the satisfaction of a functional dependency by T? The answer is provided by the
following lemma.
Lemma 3 Let I be an interpretation of table T in First Normal Form, and let X →A be a
functional dependency of FD. Then T satisﬁes X →A if I satisﬁes the following constraint:
Inclusion constraint (IC): For all t in T such that XA ⊆sch(t), I(t.X) ∩I(t.A)̸ = ∅
implies I(t.X) ⊆I(t.A).
Proof. Suppose that I satisﬁes the inclusion constraint and consider the relation f : adom(X) →
adom(A) deﬁned by: for every true tuple t in T, f(t.X) = t.A. We show that f is actually a
function. Indeed, suppose there is a true tuple t′ in T such that t′.X = t.X and t′.A̸ = t.A.
As I is in First Normal Form, by Lemma 1, I satisﬁes the partition constraint, and thus,
I(t.A)∩I(t′.A) = ∅. On the other hand, as I satisﬁes the inclusion constraint IC for X →A, we
have I(t.X) ⊆I(t.A) and I(t′.X) ⊆I(t′.A). As t.X = t′.X, we have I(t.X) ⊆I(t.A) ∩I(t′.A),
thus that I(t.X) ⊆∅. It follows that I(t.X) = ∅, which is a contradiction to the fact that t.X is
true, being a sub-tuple of t. The proof is therefore complete.
2
Example 2 Let T = {ab, bc} and FD = {A →B}. Then the basic interpretation Ib of T is
as follows: Ib(a) = {1}, Ib(b) = {1, 2}, Ib(c) = {2} and we have that Ib(a) ∩Ib(b) = {1}̸ = ∅
and Ib(a) ⊆Ib(b). As the only tuple of T to which the lemma applies is ab we conclude that T
satisﬁes A →B. In this case Ib satisﬁes the partition constraint PC and the inclusion constraint
IC.
As another example, let T = {ab, ac} and FD = {A →B}. Then the interpretation Ib of T
is as follows: Ib(a) = {1, 2}, Ib(b) = {1}, Ib(c) = {2} and we have Ib(a) ∩Ib(b) = {1}̸ = ∅but
8

---

Ib(a)̸ ⊆Ib(b), showing that Ib does not satisfy the inclusion constraint. Therefore, Ib satisﬁes
the partition constraint PC but not the inclusion constraint IC.
2
In view of Lemma 3, Ib satisﬁes the partition constraint, the set of true tuples of Ib is equal
to the set of true tuples of every interpretation I, and Ib satisﬁes a minimality property with
respect to ⪯among interpretations of T. Therefore the question that arises here is whether we
can “expand” Ib to an interpretation I′ that satisﬁes the inclusion constraint as well, so that I′
satisﬁes the same properties as Ib, along with the inclusion constraint IC.
In Example 2, the answer is yes. Indeed, if we add Ib(a) to Ib(b) then Ib(b) becomes Ib(a) ∪
Ib(b) and the resulting interpretation is: I′(a) = {1, 2}, I′(b) = {1, 2}, I′(c) = {2}; and I′ satisﬁes
the inclusion constraint for A →B. However, the following example shows that expanding Ib
may lead to non satisfaction of the partition constraint PC.
Example 3 Let T = {ab, bc, ac′} with FD = {A →C, B →C}.
Here, Ib is deﬁned by
Ib(a) = {1, 3}, Ib(b) = {1, 2}, Ib(c) = {2} and Ib(c′) = {3}. Thus, Ib does not satisfy the
constraint IC because Ib(a) ∩Ib(c) = {2}̸ = ∅but Ib(a)̸ ⊆Ib(c).
Notice that this example shows that the converse of Lemma 3 does not hold. It is so because
T satisﬁes A →C and B →C, although Ib is an interpretation of T in First Normal Form that
does not satisfy the inclusion constraint IC.
Expanding Ib as in Example 2 yields the interpretation I′ such that I′(c) = I′(c′) = {1, 2, 3},
I′(a) = Ib(a) and I′(b) = Ib(b). It should be clear that I′ satisﬁes the constraint IC, whereas
I′ does not satisfy the constraint PC since I′(c) ∩I′(c′)̸ = ∅. As a consequence, by Lemma 1,
Inc(I′)̸ = ∅. More precisely, as True(I′) is the set containing abc and abc′ along with their
sub-tuples, we have Inc(I′) = {abc, abc′, bc, bc′, ac, ac′, c, c′}.
2
In view of our discussion above, the following deﬁnition states how we can expand an interpre-
tation I so that it satisﬁes a given functional dependency X →A.
Deﬁnition 4 The expansion of I with respect to a functional dependency X →A and a tuple
xa in T (XA) is the interpretation Exp(I, xa) deﬁned as follows:
• If I(x)∩I(a)̸ = ∅and I(x)̸ ⊆I(a) then: Exp(I, xa)(a) = I(a)∪I(x), and Exp(I, xa)(α) =
I(α) for α in AD diﬀerent than a.
• Otherwise, Exp(I, xa) = I.
2
Of course, the expansion processing should be iterated when several tuples satisfy the above
condition and when several functional dependencies are considered. As will be seen next, starting
with the basic interpretation Ib and applying expansion repeatedly until a ﬁxed point is reached,
we obtain an interpretation I∗such that: (a) I∗satisﬁes the inclusion constraint IC (but not
necessarily the partition constraint PC) (b) a tuple t of T is true in I∗if and only if t is true in
every interpretation I of T satisfying IC and (c) a tuple t of T is inconsistent in I∗if and only
if t is inconsistent in every interpretation I of T satisfying IC.
2.4
The True and the Inconsistent Tuples
To deﬁne the limit interpretation I∗of T mentioned above, for a given a table T over universe
U with a set FD of functional dependencies, we consider the sequence of interpretations (Ij)j≥0
of T deﬁned by:
• For j = 0, we set I0 to be the basic interpretation Ib as deﬁned earlier.
• For j ≥0, let Ij+1 be deﬁned as follows:
9

---

– If there exist X →A, x and a such that Exp(Ij, xa)̸ = Ij, then Ij+1 = Exp(Ij, xa)
– Else Ij+1 = Ij.
The theorem below states that this sequence has a limit with important properties.
In this
theorem, given a nonempty sub-set S of AD and an interpretation I, we denote by I(S) the set
T
a∈S I(a).
Theorem 1 The sequence (Ij)j≥0 is increasing with respect to ⪯and bounded above, therefore
it has a limit that we denote by I∗. This limit has the following properties:
1. I∗is unique in the sense that it is independent of the order in which expansions are applied
(i.e., the construction of I∗has the Church-Rosser property).
2. I∗satisﬁes the inclusion constraint IC.
3. For every nonempty sub-set S of AD, I∗(S)̸ = ∅holds if and only if I(S)̸ = ∅holds for
every interpretation I of T satisfying IC.
Proof. First, it is clear that for j ≥0, Ij ⪯Ij+1 holds by deﬁnition of the sequence. Now, as
for every a in AD we have that: Ij(a) ⊆TID for every j ≥0, the sequence is bounded by the
interpretation IT ID deﬁned by: IT ID(a) = TID for every a in AD. Hence, the sequence has a
limit, denoted by I∗. The proof of the items in the theorem are as follows:
1. Uniqueness of the limit I∗is shown in Appendix A.
2. Suppose that I∗does not satisfy the inclusion constraint IC. It follows that there exist
X →A in FD and t in T such that XA ⊆sch(t), I∗(t.X) ∩I∗(t.A)̸ = ∅and I∗(t.X)̸ ⊆I∗(a).
Thus, assuming j is such that I∗= Ij, we have Ij+1̸ = Ij, which implies that I∗is not the limit
of the sequence, a contradiction.
3. Let S be a nonempty sub-set of AD such that I(S)̸ = ∅for every I satisfying IC. Since I∗is
an interpretation that satisﬁes IC, we also have I∗(S)̸ = ∅.
Conversely, if I∗(S)̸ = ∅, we prove by induction that I(S)̸ = ∅holds for every interpretation
I satisfying IC.
• If I0(S)̸ = ∅, then it follows from Lemma 2 that S does not contain two elements from the
same active domain (because Ib satisﬁes the partition constraint PC). Thus, the elements of S
form a tuple t that belongs to True(I0). It follows that t is a sub-tuple of a tuple q in T. Hence,
t belongs to True(I) for every interpretation I of T, thus for every interpretation of T satisfying
the inclusion constraint IC.
• Assume that for every nonempty sub-set Σ of AD, if Ij(Σ)̸ = ∅then I(Σ)̸ = ∅for every I
satisfying IC, and let S be such that Ij+1(S)̸ = ∅. If Ij(S)̸ = ∅, then Ij+1(S)̸ = ∅holds because
Ij ⪯IJ+1. Considering the case where Ij(S) = ∅, as Ij+1(S)̸ = Ij(S), S contains a constant
a such that Ij(a)̸ = Ij+1(a). Denoting S \ {a} by Sa, we have Ij(Sa) = Ij+1(Sa) (because
expansion changes the interpretation of only one constant, namely a in this case), and there
exist X →A in FD and x in T (X) such that Ij(x) ∩Ij(a)̸ = ∅and Ij(x)̸ ⊆Ij(a). In this case,
we have Ij+1(a) = Ij(a) ∪Ij(x), and thus
Ij+1(S)
=
Ij+1(a) ∩Ij+1(Sa)
=
(Ij(a) ∪Ij(x)) ∩Ij(Sa)
=
(Ij(a) ∩Ij(Sa)) ∪(Ij(x) ∩Ij(Sa))
Since Ij(S) = Ij(a) ∩Ij(Sa) is empty, it follows that Ij(x) ∩Ij(Sa)̸ = ∅and so, for every I
satisfying IC, I(x) ∩I(a)̸ = ∅and I(x) ∩I(Sa)̸ = ∅. Hence, I(x) ⊆I(a), and so I(x) ∩I(Sa) ⊆
I(a) ∩I(Sa). As this implies that I(a) ∩I(Sa)̸ = ∅, we obtain that I(S)̸ = ∅, and the proof is
complete.
2
10

---

We note that similar results have been obtained with a slightly diﬀerent formalism in [12].
Moreover, as a consequence of Theorem 1, for every tuple t in T , we have:
• t belongs to True(I∗) if and only if t belong to True(I) for every interpretation I of T
satisfying IC. We denote the set True(I∗) by True(T ) and its tuples are said to be true
in T . The set False(I∗) is denoted by False(T ) and its tuples are said to be false in T .
• t belongs to Inc(I∗) if and only if t belongs to Inc(I) for every interpretation I of T
satisfying IC. We denote the set Inc(I∗) by Inc(T ) and its tuples are said to be inconsistent
in T . The set Cons(I∗) is denoted by Cons(T ) and its tuples are said to be consistent in
T .
The following proposition lists basic properties of true, false, consistent and inconsistent tuples
in T .
Proposition 1 For every table T over universe U, the following holds:
1. If t is in True(T ) then every t′ such that t′ ⊑t belongs to True(T ).
2. Inc(T ) ⊆True(T ). However, the inclusions Cons(T ) ⊆True(T ) and Cons(T ) ⊆False(T )
do not hold.
3. Let t be in Inc(T ) and A in sch(t). Let a′ be in adom(A) such that a′̸ = t.A and I∗(t) ∩
I∗(a′)̸ = ∅. Then every tuple t′ such that t′ ⊑t and A belongs to sch(t′) is in Inc(T ).
4. It does not hold that for t in Inc(T ), every true super-tuple of t is in Inc(T ).
Proof. 1. Since t is in True(I∗), I∗(t)̸ = ∅. Thus, as I∗(t) ⊆I∗(t′) (because t′ ⊑t), we have
I∗(t)̸ = ∅, showing that t′ is in True(T ).
2. By Deﬁnition 3, if t is in Inc(T ) then there is A in sch(t) and a′̸ = t.A in adom(A) such that
I∗(t) ∩I∗(a′)̸ = ∅. Thus I∗(t)̸ = ∅, which implies that t belong to True(T ).
Regarding the two other inclusions in the item, for T = {ab, a′b′} and FD = ∅, we have
True(T ) = LoCl(T) and Inc(T ) = ∅. Thus, False(T ) = {ab′, a′b} and Cons(T ) = T , showing that
Cons(T )̸ ⊆True(T ) and Cons(T )̸ ⊆False(T ).
3. In this case, we have I∗(t) ⊆I∗(t′) (because t ⊑t′) and as I∗(t) ∩I∗(a′)̸ = ∅, we obtain that
I∗(t′) ∩I∗(a′)̸ = ∅. Since t′.A = t.A (because A ∈sch(t′) and t ⊑t′), we have a′̸ = t′.A, which
implies that t′ is in Inc(T ).
4. Let T = {ab, ab′, bc} with A →B. In this case I∗is deﬁned by I∗(a) = I∗(b′) = {1, 2},
I∗(b) = {1, 2, 3} and I∗(c) = {3}.
Thus b is inconsistent, because I∗(b) ∩I∗(b′)̸ = ∅, and
we argue that bc is not inconsistent although bc is a true super-tuple of b. This is so because
I∗(bc) = {3} but I∗(b′) ∩I∗(bc) = ∅.
2
We illustrate now the construction of I∗through the following example.
Example 4 Referring to Example 3, we recall that T = {ab, bc, ac′} with FD = {A →C, B →
C}, and that Ib was found to be deﬁned by Ib(a) = {1, 3}, Ib(b) = {1, 2}, Ib(c) = {2} and
Ib(c′) = {3}. The construction of I∗starts with I0 = Ib, and the following steps are performed:
(1) Considering A →C, we have I0(a) ∩I0(c)̸ = ∅but I0(a)̸ ⊆I0(c). Hence I1(c) = I0(c) ∪
I0(a) = {1, 2, 3}, I1(a) = {1, 3}, I1(b) = {1, 2} and I1(c′) = {3}.
(2) Considering again A →C, we have I1(a) ∩I1(c′)̸ = ∅but I1(a)̸ ⊆I1(c′). Hence I2(c′) is set
to I1(c′) ∪I1(a) = {1, 3}, and I2(a) = {1, 3}, I2(b) = {1, 2} and I2(c) = {1, 2, 3}.
(3) For B →C, we have I2(b)∩I2(c′)̸ = ∅but I2(b)̸ ⊆I2(c′). Hence I3(c′) is set to I2(c′)∪I2(b) =
{1, 2, 3}, and I3(a) = {1, 3}, I3(b) = {1, 2} and I3(c) = {1, 2, 3}.
11

---

Since I3 satisﬁes the inclusion constraint, we obtain I∗= I3. We notice that I∗is equal
to the expected interpretation I′ deﬁned in Example 3. Moreover, it can be seen that in this
example, True(T ) contains the tuples abc and abc′ along with all their sub-tuples, meaning that
True(T ) = T , and thus that False(T ) = ∅.
Regarding inconsistent tuples, as we have I∗(c) ∩I∗(c′)̸ = ∅, it turns out that Inc(T ) =
{abc, abc′, ac, ac′, bc, bc′, c, c′}, and thus that Cons(T ) = {ab, a, b}.
2
To further illustrate the impact of functional dependencies over true tuples and over inconsistent
tuples, we mention the following two properties: given a table T over U, X →A in FD and a
true tuple xa in T (XA), then:
1. For every tuple t in True(T ) such that X ⊆sch(t) and A̸ ∈sch(t), if t.X = x then the
tuple ta is in True(T ). In other words, writing t as qx this result expresses the well-known
property of relational lossless join: if qx and xa are true, the functional dependency X →A
implies that qxa is true as well.
This is so because I∗(x) ⊆I∗(a), I∗(t) ⊆I∗(x) (because x ⊑t) and I∗(ta) = I∗(t) ∩I∗(a).
Hence, I∗(t) ⊆I∗(a), implying that I∗(ta) = I∗(t).
Therefore, I∗(ta)̸ = ∅, because
I∗(t)̸ = ∅.
2. For every true super-tuple t of xa (i.e., t ∈True(T ), XA ⊆sch(t) and t.XA = xa) and for
every a′ in adom(A) diﬀerent than a such that xa′ is true (i.e., xa′ ∈True(T )), if we write
t as qxa then t′ = qxa′ also belongs to True(T ), and t and t′ both belong to Inc(T ).
Indeed, since I∗(xa) and I∗(xa′) are nonempty, and I∗satisﬁes the inclusion constraint,
we have I∗(x) ⊆I∗(a)∩I∗(a′) and I∗(x)̸ = ∅. It follows that I∗(a)∩I∗(a′)̸ = ∅. Moreover,
since t = qxa and I∗(t)̸ = ∅, we have I∗(qx)̸ = ∅and as I∗(qx) ⊆I∗(x), it follows that
I∗(qx) ⊆I∗(a) ∩I∗(a′), that is, I∗(qxa′) = I∗(qx). Consequently, I∗(qxa′)̸ = ∅, entailing
that t′ = qxa′ is in True(T ). Since I∗(t)̸ = ∅, I∗(a′) ∩I∗(xa)̸ = ∅and I∗(t) ⊆I∗(xa), t is
in Inc(T ) and a similar reasoning shows that t′ is also in Inc(T ).
3
Consistent Query Answering
In this section, we ﬁrst deﬁne the syntax of queries that we consider and then we deﬁne and
discuss four kinds of consistent answer to a query, based on the semantics presented in the
previous section.
3.1
Syntax of Queries
We use SQL as the query language and, as we query a single table T, the queries Q that we
consider have one of the following two forms:
Q : select X from T
or
Q : select X from T where Γ
In either of these forms, X is an attribute list seen as a relation schema, and in the second form
the where clause speciﬁes a selection condition Γ. As in SQL the where clause in a query is
optional, the generic form of a query Q is denoted by
Q : select X from T [where Γ]
The set of all attributes occurring in Γ is called the schema of Γ, denoted by sch(Γ); and the
attribute set X ∪sch(Γ) is called the schema of Q, denoted by sch(Q).
A selection condition Γ is a well-formed formula involving the usual connectors ¬, ∨and ∧
and built up from atomic Boolean comparisons of one of the following forms: A θ a or A θ A′,
12

---

where θ is a comparison predicate, A and A′ are attributes in U whose domain elements are
comparable through θ, and a is in dom(A).
Given a selection condition Γ, we denote by Sat(Γ) the set of all tuples in T (sch(Γ)) satisfying
Γ, as deﬁned below:
• if Γ is of the the form A θ a, Sat(Γ) = {t ∈T (sch(Γ)) | t.A θ a},
• if Γ is of the the form A θ B, Sat(Γ) = {t ∈T (sch(Γ)) | t.A θ t.B},
• if Γ is of the form Γ1 ∨Γ2, Sat(Γ) = Sat(Γ1) ∪Sat(Γ2),
• if Γ is of the form Γ1 ∧Γ2, Sat(Γ) = Sat(Γ1) ∩Sat(Γ2),
• if Γ is of the form ¬Γ1, Sat(Γ) = T (sch(Γ)) \ Sat(Γ1).
Moreover, the set of tuples that do not satisfy Γ is deﬁned by:
• Sat−(Γ) = T (sch(Γ)) \ Sat(Γ).
For example, if Sal is an attribute whose active domain is {s, s′}, we have:
• for Γ4 = (Sal = s′), Sat(Γ4) = {s′} and Sat−(Γ4) = {s},
• for Γ5 = (Sal = s ∨Sal = s′), Sat(Γ5) = {s, s′} and Sat−(Γ5) = ∅,
• for Γ6 = (Sal > 10K), if s = 5K and s′ = 20K, Sat(Γ6) = {s′} and Sat−(Γ6) = {s}, and
if s = 15K and s′ = 20K, Sat(Γ6) = {s, s′} and Sat−(Γ6) = ∅.
Next, we explain how, in our context, the above syntactic deﬁnition of satisfaction of a selection
condition can be ‘coupled’ with semantic considerations, when it comes to deﬁning the notion of
consistent answer to a query Q.
Intuitively, given Q : select X from T [where Γ], the least requirements for a tuple x to
belong to a consistent answer to Q are the following:
R1 x is in T (X), i.e., the schema of x is X,
R2 x is in True(T ), i.e., x is a true tuple,
R3 x is in Cons(T ), i.e., x is consistent, and
R4 if Q involves a selection condition Γ then there exists t in True(T ) such that sch(Q) ⊆
sch(t), x ⊑t, and t.sch(Γ) is in Sat(Γ) (that is, t is a true super-tuple of x whose restriction
to attributes in sch(Γ) satisﬁes Γ).
It is important to note that when all the above requirements are satisﬁed, then the consistent
answer coincides with the standard notion of answer to projection-selection queries against a
consistent table. Indeed, if T is a relational consistent table whose schema contains all attributes
in sch(Q), then the answer to a query Q : select X from T [where Γ] is the set of all tuples
x such that:
• the schema of x is X (see requirement R1), and
• T contains a tuple t such that t is a super-tuple of x and the restriction of t to all attributes
occurring in Γ satisﬁes Γ (see requirement R4, knowing that t is true since all tuples in T
are implicitly assumed to be true).
13

---

Moreover, in this case, requirement R2 is also satisﬁed because all tuples in a consistent relational
table are implicitly assumed to be true, and requirement R3 is trivial because in a consistent
table, every tuple is consistent.
On the other hand, in the presence of inconsistencies, it should be noticed that, based on our
semantics as earlier deﬁned, the status of any tuple x in the consistent answer to Q is clearly
deﬁned because x is then a true and consistent tuple of T whose schema is X. However, the
situation is less clear regarding the status of the super-tuple t in requirement R4. More precisely,
the question here is whether t should be consistent or not and whether t should satisfy other
criteria as well (e.g., is t required to be consistent or is t required to be maximal with respect to
⊑?). The following example illustrates this discussion, showing in particular that the status of t
has a signiﬁcant impact on the consistent answer.
Example 5 Consider the universe U = {Emp, Sal, Dept} with the functional dependency
Emp →Sal and the table T = {es, es′d, e′s′} over U whose tuples state that employee e has s
and s′ as salaries, employee e works in department d, and that employee e′ has salary s′. The
content of T clearly does not satisfy the functional dependency Emp →Sal as employee e is as-
signed two distinct salaries s and s′. The limit interpretation I∗of T is deﬁned by I∗(e) = {1, 2},
I∗(e′) = {3}, I∗(s) = {1, 2}, I∗(s′) = {1, 2, 3} and I∗(d) = {2}. Thus True(T ) consists of the
sub-tuples of esd, es′d and of e′s′, and Inc(T ) = {esd, es′d, es, es′, sd, s′d, s, s′}.
Let us now
consider the following queries Q1, Q2, Q3, Q4, Q5 and Q6:
Q1 : select Emp, Dept from T
Q2 : select Emp, Sal from T
Q3 : select Sal from T
Q4 : select Emp from T where Sal = s′
Q5 : select Emp from T where Sal = s ∨Sal = s′
Q6 : select Emp from T where Sal > 10K
Regarding Q1, since ed is the only true and consistent tuple in T (Emp, Dept), ed is the only
tuple satisfying the requirements R1, R2 and R3 above. Requirement R4 is irrelevant because
Q1 involves no selection condition. Hence ed is a candidate tuple to belong to the consistent
answer to Q1. Notice however that one could object that ed is not a good candidate since all its
maximal (with respect to ⊑) true super-tuples in T (namely esd and es′d) are inconsistent.
Regarding Q2, es, es′ and e′s′ are the only tuples satisfying requirements R1 (they all belong
to T (Emp, Sal)) and R2 (they all belong to True(T )). However, since es and es′ are in Inc(T ),
they do not satisfy requirement R3, whereas e′s′ does since this tuple is in Cons(T ). We moreover
notice that, contrary to Q1 above, e′s′ has no true strict super-tuple. Hence the consistent answer
to Q2 should be {e′s′}.
The case of Q3 is clearer because s and s′ are the only tuples satisfying requirements R1 and
R2, and since these two tuples are in Inc(T ), none of them can satisfy requirement R3. Therefore,
the consistent answer to Q3 should be ∅.
Let us now turn to queries involving a selection condition. Regarding Q4, the two tuples
satisfying requirements R1 and R2 are e and e′, and since e and e′ are in Cons(T ), they also satisfy
requirement R3. Moreover, we notice that es′ is a true super-tuple of e satisfying Γ4 = (Sal = s′),
showing that e satisﬁes requirement R4. However, it should be noticed that es′ is inconsistent
and that es is another true super-tuple of e not satisfying Γ4. Hence, it can thought that e
should not belong to the consistent answer to Q4. On the other hand, e′ has only one true super-
tuple, namely e′s′, and since this tuple is in Sat(Γ4), e′ satisﬁes requirement R4 and no further
information allows us to think that the salary of e′ could be diﬀerent than s′. As a consequence,
the consistent answer to Q4 is expected to contain e′ and possibly e.
14

---

Regarding Q5, for the same reasons as for Q4, e and e′ are the two possible tuples satisfying
requirements R1, R2 and R3. Now, and contrary to the case of Q4, the two true super-tuples
of e, namely es and es′, belong to Sat(Γ5), thus ensuring that whatever e’s salary it satisﬁes
the selection condition. This remark supports the fact that e is a candidate to belong to the
consistent answer to Q5. Of course, as for query Q1, one could object that since es and es′ are
inconsistent, e has not to belong to the consistent answer to Q5. It should be noticed here that
the case of e′ is treated as for Q4 above, because e′s′ is a true super-tuple of e′ such that s′ is
in Sat(Γ5). Hence, the consistent answer to Q5 is expected to be {e, e′} or {e′}, following the
choice made regarding inconsistency of the tuple t in requirement R4.
A reasoning similar to those for Q4 or Q5 applies to Q6, depending on the actual values of s
and s′. Assuming ﬁrst that s = 5K and s′ = 20K, as for Q4, the expected consistent answer is
{e′} or possibly {e, e′}, knowing that e’s unique salary may not satisfy the condition. However,
if s = 15K and s′ = 20K, the consistent answer to Q6 is expected to be as for Q5, that is, {e, e′}
or {e′}, following the choice made regarding inconsistency of the tuple t in requirement R4.
2
3.2
Consistent Answers
To account for some of the remarks regarding Q5 and Q6 in Example 5, we introduce the notion
of consistency with respect to a selection condition. To this end, for every relation schema X, we
denote by T (X↑) the set of all tuples t in T such that X ⊆sch(t). In other words, T (X↑) is the
set of all super-tuples of tuples over X, and it follows that T (X) is a sub-set of T (X↑).
Deﬁnition 5 Given a table T over U, and Γ a selection condition:
A tuple t in T (sch(Γ)↑) is said to be inconsistent with respect to Sat(Γ) if t.sch(Γ) is in
Sat(Γ) and there exists s in Sat−(Γ) such that I∗(t) ∩I∗(s)̸ = ∅. We denote by Inc(Γ, T ) the set
of all tuples inconsistent with respect to Sat(Γ).
A tuple t in T (sch(Γ)↑) is said to be consistent with respect to Sat(Γ) if t.sch(Γ) is in Sat(Γ)
and t is not in Inc(Γ, T ), that is if for every s in Sat−(Γ), I∗(t) ∩I∗(s) = ∅. We denote by
Cons(Γ, T ) the set of all tuples consistent with respect to Sat(Γ).
2
The following proposition states basic properties implied by Deﬁnition 5.
Proposition 2 Given a table T over U and a selection condition Γ, the following holds:
1. Inc(Γ, T ) is a sub-set of Inc(T ), and Cons(T ) ∩T (sch(Γ)↑) is a sub-set of Cons(Γ, T ). But
Cons(Γ, T ) ⊆Cons(T ) does not always hold.
2. For every t in Cons(Γ, T ), every super-tuple t′ of t is also in Cons(Γ, T ).
3. If I∗is in First Normal Form, then Inc(Γ, T ) = ∅and Cons(Γ, T ) is the set of all super-
tuples of tuples in Sat(Γ).
4. For a given tuple t, if Sat(Γ) = {t}, then t is in Inc(T ) if and only if t is in Inc(Γ, T ), and
t is in Cons(T ) if and only if t is in Cons(Γ, T ).
5. If Sat(Γ) = ∅then Cons(Γ, T ) = Inc(Γ, T ) = ∅. If Sat(Γ) = T (X), then Cons(Γ, T ) is the
set of all super-tuples of tuples in Sat(Γ), and Inc(Γ, T ) is empty.
Proof. 1. If t is in Inc(Γ, T ), there exists s in Sat−(Γ) such that I∗(t)∩I∗(s)̸ = ∅. Since t.sch(Γ)
is in Sat(Γ), t.sch(Γ) and s are distinct tuples in T (sch(Γ)). Hence, there exists A in sch(Γ)
such that t.A̸ = s.A. As I∗(s) ⊆I∗(s.A), I∗(t) ∩I∗(s)̸ = ∅implies that I∗(t) ∩I∗(s.A)̸ = ∅.
Therefore, by Deﬁnition 3, t is in Inc(T ).
15

---

As for the inclusion Cons(T )∩T (sch(Γ)) ⊆Cons(Γ, T ), given t in T (sch(Γ)), if t is in Cons(T )
then t is not in Inc(T ). Thus, t is not in Inc(Γ, T ), which implies by Deﬁnition 5 that t is in
Cons(Γ, T ).
To see that Cons(Γ, T ) ⊆Cons(T ) does not always hold, consider the earlier example where
T = {abc, ab′c, a′b′′c′} over U = {A, B, C} and C →B. In this case, b and b′ are clearly in Inc(T ),
thus, not in Cons(T ). For Γ = (B = b ∨B = b′), we have Sat(Γ) = {b, b′} and Sat−(Γ) = {b′′}.
Since I∗is deﬁned by I∗(a) = I∗(b) = I∗(b′) = I∗(c) = {1, 2}, I∗(a′) = I∗(b′′) = I∗(c′) = {3},
Deﬁnition 5 shows that b and b′ are in Cons(Γ, T ) (because I∗(b) ∩I∗(b′′) = I∗(b′) ∩I∗(b′′) = ∅).
2. If t′ is a super-tuple of t, t′ is in T (sch(Γ)↑) because so is t. Moreover, as t is in Cons(Γ, T ),
I∗(t)∩I∗(s) = ∅holds for every s in Sat−(Γ). As I∗(t′) ⊆I∗(t), it follows that I∗(t′)∩I∗(s) = ∅
holds as well, showing that t′ is in Cons(Γ, T ).
3. Assuming that I∗is in First Normal Form means that Inc(T ) = ∅. By (1) above, this implies
that Inc(Γ, T ) = ∅and thus, by Deﬁnition 5, Cons(Γ, T ) is the set of all super-tuples of tuples in
Sat(Γ).
4. By (1) above, we have Inc(Γ, T ) ⊆Inc(T ) always holds. Conversely, if t is in Inc(T ) then, by
Deﬁnition 3, there exist A in sch(t) and a′ in adom(A) such that a′̸ = t.A and I∗(t)∩I∗(a′)̸ = ∅.
Denoting t.A by a and writing t as qa, the tuple qa′ is such that sch(qa′) = sch(t) and qa′ ∈
Sat−(Γ). Hence, I∗(t) ∩I∗(qa′)̸ = ∅, showing that t is in Inc(Γ, T ).
If t is in Cons(Γ, T ), then Sat(Γ) = T (X) \ {t}, and for every s in Sat−(Γ), I∗(t) ∩I∗(s) = ∅,
implying that for every A in sch(Γ) and every a′ in adom(A) such that a′̸ = t.A, I∗(t)∩I∗(a′) = ∅.
By Deﬁnition 3, this implies that t is in Cons(T ). Conversely, if t is in Cons(T ), by (1) above,
as t belongs to T (sch(Γ)), t is in Cons(Γ, T ).
5. The results being immediate consequences of Deﬁnition 5, their proofs are omitted. The proof
of the proposition is therefore complete.
2
In what follows, in order to account for the remarks in Example 5, we propose four ways of
deﬁning the consistent answer to a query Q. These deﬁnitions are then illustrated by examples
and compared to each other.
Deﬁnition 6 Let T be a table over universe U, FD the set of associated functional dependencies.
Given a query Q : select X from T [where Γ], we deﬁne the following:
1. The weakly consistent answer to Q, denoted WC ans(Q), is the set of all tuples x in T (X)
such that
(a) x is in True(T ) ∩Cons(T ),
(b) there exists t is in True(T ) such that t is in T (sch(Q)↑), t.X = x, t.sch(Γ) is in
Sat(Γ).
2. The consistent answer to Q, denoted C ans(Q), is the set of all tuples x in T (X) such that
(a) x is in True(T ) ∩Cons(T ),
(b) there exists t is in True(T ) such that t is in T (sch(Q)↑), t.X = x, t is in Cons(Γ, T ).
3. The strongly consistent answer to Q, denoted SC ans(Q), is the set of all tuples x in T (X)
such that
(a) x is in True(T ) ∩Cons(T ),
(b) there exists t is in True(T ) ∩Cons(T ) such that t is in T (sch(Q)↑), t.X = x, and
t.sch(Γ) is in Sat(Γ).
16

---

4. The max-strongly consistent answer to Q, denoted MSC ans(Q), is the set of all tuples x
in T (X) such that
(a) x is in True(T ) ∩Cons(T ),
(b) there exists t is in True(T ) ∩Cons(T ) such that t is maximal with respect to ⊑in
True(T ), t is in T (sch(Q)↑), t.X = x, and t.sch(Γ) is in Sat(Γ).
2
The four kinds of consistent answer in Deﬁnition 6 relate to requirements R1, R2, R3 and R4 in
the following respects:
• Statements (1.a), (2.a), (3.a) and (4.a) clearly show that any tuple x in any of the four
kinds of consistent answer satisﬁes requirements R1 (x ∈T (X)), R2 (x ∈True(T )) and R3
(x ∈Cons(T )).
• Statements (1.b), (2.b), (3.b) and (4.b) show that any tuple x in any of the four kinds of
consistent answer satisﬁes the requirement R4 by ensuring the existence of a true super-
tuple t of x satisfying Γ.
Moreover, as announced in our earlier discussion, the status of the tuple t is clariﬁed in Deﬁni-
tion 6 as follows:
• in the case of the weakly consistent answer, t is only requested to be true (as stated in
requirement R4),
• in the case of the consistent answer, t is requested to be true and consistent with respect
to Γ (which does not disallow t to be inconsistent),
• in the case of the strongly consistent answer, t is requested to be true and consistent (which
of course disallows t to be inconsistent), and
• in the case of the max-strongly consistent answer, t is requested to be true, consistent and
maximal.
We also emphasize that when the query Q in Deﬁnition 6 involves no selection condition, then
statements (1.b), (2.b) and (3.b) are reduced to the existence of t such that t is in True(T ), t
is in T (X↑) and t.X = x. As statements (1.a), (2.a) and (3.a), ensure the existence of such
a tuple t, statements (1.b), (2.b) and (3.b) are redundant. However, such is not the case for
statement (4.b), because the true and consistent super-tuple of x needed to satisfy (4.a) might
not be maximal, and thus might not satisfy (4.b). We refer to query Q1 in the forthcoming
Example 6 for an illustration of this case.
Moreover, Deﬁnition 6 and the results in Proposition 2 lead to the following observations
when the query Q involves a selection condition Γ:
1. For every t in Inc(Γ, T ), the tuple t.sch(Γ) is such that its syntax satisﬁes the condition Γ
whereas its semantics meets that of a tuple whose syntax does not satisfy the condition Γ.
Since Inc(Γ, T ) is a sub-set of Inc(T ), this shows that the notion of satisfaction of a selection
condition might concern inconsistent tuples. It should be noticed that any super-tuple of
such tuples is discarded from max-strongly consistent answers and from strongly consistent
answers, whereas they may occur in consistent answers or in weakly consistent answers.
2. Since every super-tuple of a tuple in Cons(Γ, T ) is also in Cons(Γ, T ), C ans(Q) can be
computed by scanning maximal true tuples in T (sch(Q)↑). Obviously, MSC ans(Q) should
be computed by scanning only maximal true tuples in T (sch(Q)↑), whereas the scan should
17

---

concern true tuples in T (sch(Q)), when computing SC ans(Q) or WC ans(Q). It will how-
ever be seen in the next section, that all consistent answers are computed based on the
same scan.
3. If I∗is in First Normal Form, i.e., if Inc(T ) = ∅, then Cons(Γ, T ) is the set of all super-
tuples of tuples in Sat(Γ).
As moreover, t.X is in Cons(T ), t.X is in C ans(Q).
This
remark ﬁts the intuition that if T is consistent then the consistent answer to Q is equal to
the standard answer to Q, that is the set of projections over X of true tuples in T (sch(Q)↑)
that satisfy Γ. This comes in line with our earlier remark stating that requirements R1,
R2, R3 and R4 are satisﬁed by the tuples in the answer to Q when T is consistent.
4. If Sat(Γ) is reduced to one tuple s, then for every t in T (sch(Q)↑) ∩True(T ) such that t.X
is in Cons(T ) ∩True(T ) and t.sch(Γ) = s, t.X is in WC ans(Q), and moreover, t.X is in
SC ans(Q) and in C ans(Q) if and only if s is in Cons(T ). The case of MSC ans(Q) is more
involved because maximal true tuples must be considered. For example, it can happen
that, for Q : select A from T where B = b, a is in SC ans(Q) and in C ans(Q), but not
in MSC ans(Q) because ab is true and consistent, whereas abc is the only true super-tuple
of ab and abc is inconsistent.
5. If Sat(Γ) = ∅(i.e., if Γ is not satisﬁable in T ), then it is obvious that MSC ans(Q),
SC ans(Q) and WC ans(Q) are empty. As in this case, Cons(Γ, T ) = ∅, C ans(Q) is empty
as well.
On the other hand, if Sat(Γ) = T (sch(Γ)), it is easy to see that SC ans(Q) and WC ans(Q)
are equal to the set of all tuples in T (X) that belong to Cons(T ) ∩True(T ). Moreover,
since Cons(Γ, T ) = T (sch(Γ)↑), C ans(Q) is also the set of all tuples in T (X) that belong
to Cons(T ) ∩True(T ). However, as in the previous item, the case of MSC ans(Q) is more
involved because maximal true tuples must be considered.
The following proposition states an important relationship among the four kinds of consistent
answers, namely that they form an increasing chain of inclusions.
Proposition 3 Let T be a table over universe U, FD the set of associated functional depen-
dencies. Given a query Q : select X from T [where Γ], the following holds: MSC ans(Q) ⊆
SC ans(Q) ⊆C ans(Q) ⊆WC ans(Q).
Proof. To show that MSC ans(Q) ⊆SC ans(Q) holds, let x in MSC ans(Q). Then statements
(1.a) and (1.b) in Deﬁnition 6 hold, and thus, so does statement (2.a). The result comes form
the fact that it is easily seen that statement (1.b) implies statement (2.b).
Regarding the inclusion SC ans(Q) ⊆C ans(Q), we notice that for every x in SC ans(Q),
statements (2.a) and (2.b) in Deﬁnition 6 hold, and thus, that statement (3.a) holds as well.
Moreover, since statement (2.b) holds, there exists t in T (sch(Q)↑), such that t.X = x and
t.sch(Γ) is in Sat(Γ). Thus t is in Cons(T ) ∩T (sch(Γ)↑), which by Proposition 2(1) implies that
t is in Cons(Γ, T ). Hence statement (3.b) is satisﬁed, showing that x is in C ans(Q).
Regarding the last inclusion, for every x in C ans(Q), statement (4.a) clearly holds and
moreover, as the tuple t in Cons(Γ, T )∩True(T ) is obviously in True(T ) and in Sat(Γ), the proof
is complete.
2
We illustrate Deﬁnition 6 and Proposition 3 in the context of Example 5. Moreover, through
this example, we show that the inclusions in Proposition 3 might be strict.
Example 6 We recall that in Example 5, U = {Emp, Sal, Dept}, FD = {Emp →Sal} and
T = {es, es′d, e′s′}, which implies that True(T ) consists of the sub-tuples of esd, es′d and of e′s′
18

---

and that Inc(T ) = {esd, es′d, es, es′, sd, s′d, s, s′}. The queries we are interested in are Q1, Q2,
Q3, Q4, Q5 and Q6 as shown below:
Q1 : select Emp, Dept from T
Q2 : select Emp, Sal from T
Q3 : select Sal from T
Q4 : select Emp from T where Sal = s′
Q5 : select Emp from T where Sal = s ∨Sal = s′
Q6 : select Emp from T where Sal > 10K
In the case of Q1, the only possible true tuple in any answer is ed. As all maximal true super-
tuples of ed are esd and es′d, none of these tuples is consistent. Thus, we have MSC ans(Q1) = ∅.
However, SC ans(Q1) = C ans(Q1) = WC ans(Q1) = {ed}, because this tuple is true and consis-
tent and because no selection condition is involved. Regarding the inclusions in Proposition 3,
this case shows that the ﬁrst inclusion might be strict.
Considering now Q2, we have MSC ans(Q2) = {e′s′}, because this tuple is true and consistent,
and has no strict true super-tuple. For a similar reason, we also have SC ans(Q2) = C ans(Q2) =
WC ans(Q2) = {e′s′} because no selection condition is involved in Q2. In this case the inclusions
in Proposition 3 hold because MSC ans(Q2) = SC ans(Q2) = C ans(Q2) = WC ans(Q2) hold.
The case of Q3 is easy because as earlier mentioned, no Sal-value is consistent, implying that
statement (a) of the four consistent answers in Deﬁnition 6 can not be satisﬁed. As Q3 involves
no selection condition, we have MSC ans(Q3) = SC ans(Q3) = C ans(Q3) = WC ans(Q3) = ∅,
showing again that the inclusions in Proposition 3 hold.
Regarding Q4 involving the selection condition Γ4 = (Sal = s′), since e and e′ are both
true and consistent tuples over Emp, they satisfy statements (1.a), (2.a), (3.a) and (4.a) in
Deﬁnition 6. Since Sat(Γ3) = {s′}, es′ and e′s′ are the only tuples of interest regarding state-
ments (1.b), (2.b), (3.b) and (4.b) in Deﬁnition 6.
Thus WC ans(Q4) = {e, e′}.
As es′d is
maximal and inconsistent, statement (1b) is not satisﬁed and since es′ is also inconsistent, state-
ment (2.b) is not satisﬁed either. Now, regarding statement (3.b), we have s in Sat−(Γ4) and
I∗(es′) ∩I∗(s) = {1, 2} (see Example 5). Thus, by Deﬁnition 5, es′ is in Inc(Γ4, T ), and so, es′
does not satisfy statement (3.b). As a consequence, e is not in MSC ans(Q4), SC ans(Q4) nor in
C ans(Q4).
On the other hand, e′s′ does satisfy statements (1.b), (2.b) and (3.b) in Deﬁnition 6, because
e′s′ is a maximal true and consistent tuple such that s′ is in Sat(Γ4), and regarding (3.b),
e′s′ is in Cons(Γ4, T ) (because I∗(e′s′) ∩I∗(s) = ∅). Therefore, MSC ans(Q4) = SC ans(Q4) =
C ans(Q4) = {e′} and WC ans(Q4) = {e, e′}, showing that the inclusions in Proposition 3 hold,
and that the last one might be strict.
As for Q5 involving the selection condition Γ5 deﬁned by (Sal = s ∨Sal = s′), for the
same reasons as for Q4, the two possible tuples in the answer are e and e′ and WC ans(Q5) =
{e, e′}. Moreover, since Sat(Γ5) = {s, s′}, e′ is in MSC ans(Q5), SC ans(Q5) and C ans(Q5).
Regarding now e, the same arguments as for Q4 apply regarding the statements (1.b) and (2.b)
in Deﬁnition 6, showing that e is neither in MSC ans(Q5) nor in SC ans(Q5). However, contrary
to the case of Q4, es is in Cons(Γ5, T ), and thus, statement (3.b) of Deﬁnition 6 is satisﬁed. We
therefore obtain that MSC ans(Q5) = SC ans(Q5) = {e′} and C ans(Q5) = WC ans(Q5) = {e, e′},
which also shows that the second inclusion in Proposition 3 might be strict.
Consider now Q6 involving the selection condition Γ6 = (Sal > 10K) and suppose that
s = 5K and s′ = 20K. Then, we have Sat(Γ6) = {s′} and Sat−(Γ6) = {s}, and thus, as in the
case of Q4, MSC ans(Q4) = SC ans(Q4) = C ans(Q4) = {e′}, and WC ans(Q6) = {e, e′}. On the
other hand, if s = 15K and s′ = 20K, then Sat(Γ6) = {s, s′} and Sat−(Γ3) = ∅, and thus, as for
19

---

Q5 above, we have MSC ans(Q5) = SC ans(Q5) = {e′} and C ans(Q5) = WC ans(Q6) = {e, e′}.
2
To end this section, we would like to stress that proposing distinct consistent answers as done
in Deﬁnition 6 raises the question of which one should be chosen. Although we think that this
choice should be made by the ﬁnal user, the comparisons stated in Proposition 3 should help in
making this choice. Moreover, assuming the choice of C ans(Q) is made, the knowledge of the
answers MSC ans(Q), SC ans(Q) and WC ans(Q) are likely to be useful to the user, regarding
the quality of the provided consistent answer.
For instance, in Example 6 the fact that e is in C ans(Q5) but not in SC ans(Q5) implies
that the database contains an inconsistency regarding e’s salary. This information shows that
the presence of e in C ans(Q5) might be considered less reliable than that of e′ for which such
inconsistency does not exist as e′ is in SC ans(Q5) and in SC ans(Q5). On the other hand, a tuple
in WC ans(Q) but not in C ans(Q) shows that although this tuple occurs with values satisfying
the selection condition, it also systematically occurs in an inconsistency involving values not
satisfying the selection condition. This happens for e when answering Q4: although e occurs
associated with s′, it also occurs associated with s.
This example also shows that comparing the consistent answers MSC ans(Q), SC ans(Q) and
WC ans(Q) with C ans(Q) has an impact not only on the quality of the answers, but also allows
for explaining the presence or the absence of some tuples in a consistent answer. These issues
related to data quality and to answer explanation are among the subjects of our future work.
4
Computational Issues
In this section, we present algorithms ﬁrst for computing eﬃciently the sets Cons(T ) and Inc(T )
(see Section 4.1) and then the four consistent answers to a given query (see Section 4.2).
4.1
The Tabular Representation of I∗
In this section, we show how to compute True(T ) and Inc(T ), using a modiﬁed version of the
well-known chase algorithm [10, 18] that we call m-Chase. Our algorithm is based on the notion
of multi-valued tuple, or m-tuple for short, which generalizes that of usual tuple in the following
sense: instead of associating every attribute A with at most one value in adom(A), a multi-valued
tuple associates every attribute A with a sub-set of adom(A), possibly empty. Multi-valued tuples
are deﬁned as follows.
Deﬁnition 7 Given a universe U = {A1, . . . , An} and active domains adom(Ai), i = 1, . . . , n, a
multi-valued tuple σ over U, or m-tuple for short, is a total function from U to the cross product
XA∈UP(adom(A)), where P(adom(A)) denotes the power set of the active domain of attribute
A. The ‘empty’ m-tuple, denoted by ω, is deﬁned by ω(A) = ∅for every A in U.
The set of all attributes A such that σ(A)̸ = ∅, is called the schema of σ, denoted by sch(σ),
and the schema of ω is ∅. Given σ̸ = ω and a sub-set X of sch(σ), the restriction of σ to X,
denoted σ(X), is the m-tuple deﬁned by (σ(X))(A) = σ(A) for every A in X and (σ(X))(A) = ∅
for any A not in X.
Given an m-tuple σ, the set tuples(σ) denotes the set of all tuples t such that sch(t) = sch(σ)
and for every A in sch(t), t(A) is a value of adom(A) that belongs to σ(A). As for the empty
m-tuple ω, we have tuples(ω) = ∅.
The set of all m-tuples over U is denoted by MT , and a ﬁnite set of m-tuples is called an
m-table.
2
20

---

It is easy to see that for every t in T , it holds that sch(σt) = sch(t) and tuples(σt) = {t}. In
what follows, we use t and σt interchangeably, whenever no confusion is possible. To simplify
notation, given an m-tuple σ, the set σ(A) is denoted by the concatenation of its elements between
parentheses, and σ itself is denoted by the concatenation of all σ(A) such that σ(A)̸ = ∅.
Based on Deﬁnition 7, a tuple t in T yields an m-tuple σt in MT such that for every A
in sch(t), σt(A) = {t.A} (or σt(A) = (t.A) according to the notation just introduced), and
σt(B) = ∅for every B not in sch(t).
For example if U = {A, B, C, D}, the m-tuple σ such that σ(A) = {a, a′}, σ(B) = {b}, σ(C) =
∅and σ(D) = {d1, d2, d3} is denoted by (a, a′)(b)(d1d2d3) and we have sch(σ) = {A, B, D} (or
simply sch(σ) = ABD). Now, to ﬁnd the set tuples(σ) we make all combinations of values, one
from each of σ(A), σ(B) and σ(D). We ﬁnd tuples(σ) = {abd1, abd2, abd3, a′bd1, a′bd2, a′bd3}.
Moreover, we have σ(AB) = (aa′)(b). On the other hand, for t = abd1, we have σt = (a)(b)(d1),
and thus tuples(σt) = {abd1}.
We draw attention to the fact that, although m-tables can be seen as a particular case of
embedded relations [18], we do not intend to elaborate on such relations in our approach. We
rather use m-tuples as a tool to explicitly account for situations where the First Normal Form
(or equivalently the partition constraint) is not satisﬁed. We deﬁne the following operations for
m-tuples:
Comparison: σ1 ⊑σ2 holds if for every A in U, σ1(A) ⊆σ2(A)2.
Thus if σ1 ⊑σ2 then
sch(σ1) ⊆sch(σ2). Moreover, if sch(σ1) = sch(σ2) then tuples(σ1) ⊆tuples(σ2). It also
holds that ω ⊑σ, for every m-tuple σ.
Union: σ1 ⊔σ2 is the m-tuple σ such that for every A in U, σ(A) = σ1(A) ∪σ2(A). Thus,
sch(σ1 ⊔σ2) = sch(σ1) ∪sch(σ2).
Intersection: σ1 ⊓σ2 is the m-tuple σ such that for every A in U, σ(A) = σ1(A)∩σ2(A). Thus,
sch(σ1 ⊓σ2) ⊆sch(σi) for i = 1, 2.
We now introduce a new chase algorithm, called m-Chase whose deﬁnition is shown as Algo-
rithm 1. The m-Chase Algorithm works on sets of m-tuples to provide an m-table from which
true and inconsistent tuples can easily be retrieved. Roughly speaking, Algorithm 1 follows the
same idea as the standard chase, but when a functional dependency cannot be satisﬁed, our
algorithm does not stop, but rather collects all values inferred from the functional dependencies.
Consequently, it may happen that for a given row and a given column (i.e., for a given attribute
value) we may have to store more than one constant, which is achieved by means of m-tuples. It
is important to note that the output of Algorithm 1 (denoted by Σ∗) allows to explicitly ‘show’
all violations of the partition constraint PC. We illustrate how Algorithm 1 works using an
example.
Example 7 Let T = {ab, ab′, a′b′} over universe U = {A, B} with functional dependencies
A →B and B →A. The computation of Σ∗based on Algorithm 1 works as follows:
1. Considering tuples in T as m-tuples yields the following m-tuples: (a)(b), (a)(b′) and
(a′)(b′). Thus, Σ∗is set to {(a)(b), (a)(b′), (a′)(b′)} on line 1.
2. Considering A →B, with σ = (a)(b) and σ′ = (a)(b′), the m-tuples σ1 = (a)(bb′) and
σ′
1 = (a)(b′b) are generated. The variable change is set to true and since σ1 = σ′
1, Σ∗is
set to {(a)(bb′), (a′)(b′)}. Moreover, fail is set to true line 11 because we have (b)̸ = (b′).
2With a slight abuse of notation, we use here the same symbol ⊑introduced earlier for the sub-tuple relation
between usual tuples.
21

---

Algorithm 1 The m-Chase Algorithm
Input: A table T over U and a set FD of functional dependencies over U.
Output: An m-table denoted by Σ∗and the truth value of fail.
1: Σ∗:= {σt | t ∈T}
2: change := true
3: fail := false
4: while change = true do
5:
change := false
6:
for all σ in Σ∗do
7:
for all X →A in FD such that XA ⊆sch(σ) do
8:
for all σ′ in Σ∗such that X ⊆sch(σ′) do
9:
if for every B in X, σ(B) ∩σ′(B)̸ = ∅then
10:
if A ∈sch(σ) and A ∈sch(σ′) and σ(A)̸ = σ′(A) and fail = false then
11:
fail := true
12:
σ1 := σ ⊔σ′(A) ; σ′
1 := σ′ ⊔σ(A)
13:
if σ̸ = σ1 or σ′̸ = σ′
1 then
14:
change := true
15:
if σ1 ⊑σ′
1 then
16:
Σ∗:= (Σ∗\ {σ, σ′}) ∪{σ′
1}
17:
else if σ′
1 ⊑σ1 then
18:
Σ∗:= (Σ∗\ {σ, σ′}) ∪{σ1}
19:
else
20:
Σ∗:= (Σ∗\ {σ, σ′}) ∪{σ1, σ′
1}
21: return Σ∗and the truth value of fail
This means intuitively that when running the standard chase algorithm, a failure would be
reached at this step.
Considering B →A, since the B-value b′ occurs in (a)(bb′) and (a′)(b′), these m-tuples
generate respectively (aa′)(bb′) and (aa′)(b′). Moreover, since (aa′)(b′) ⊑(aa′)(bb′), Σ∗is
set to {(aa′)(bb′)}.
3. As the second execution of the while-loop line 4 does not change Σ∗, the variable change
has value false. Hence the processing stops, returning Σ∗= {(aa′)(bb′)} along with the
value true assigned to fail.
2
We now state a basic lemma based on which it will be shown how to compute True(T ) and Inc(T ).
In what follows, the notation LoCl is extended to Σ∗in a straightforward way: LoCl(Σ∗) = {t ∈
T | (∃σ ∈Σ∗)(t ⊑σ)}. Moreover, for every interpretation I and every m-tuple σ, I(σ) is deﬁned
by I(σ) = T
a⊑σ I(a). It should be noticed that, as for tuples in T , if σ ⊑σ′, then I(σ′) ⊆I(σ)
holds.
Lemma 4 Let T be a table over universe U. Then the following hold:
1. Algorithm 1 applied to T always terminates.
2. For every m-tuple s in MT , I∗(s)̸ = ∅holds if and only if there exists σ in Σ∗such that
s ⊑σ.
3. Inc(T ) = ∅if and only if fail = false.
4. For every σ in Σ∗and all t and t′ in tuples(σ), I∗(t) = I∗(t′).
Proof. See Appendix B.
2
Note that Algorithm 1 is an extension of the standard chase algorithm. Indeed, the standard
chase algorithm works on tuples (and not on m-tuples) which is the case for T. Moreover, as long
22

---

as σ and σ′ are usual tuples, our processing is similar to that of standard chase. In particular,
for every X →A in FD if XA is a sub-set of sch(σ) and sch(σ′) and if σ(X) and σ′(X) are
equal tuples, while σ(A) and σ′(A) are distinct values, then, in Algorithm 1, fail is set to true,
which is precisely a case of failure for the standard chase algorithm. Thus, based on Lemma 4,
the returned value for fail is true if and only if the standard chase algorithm fails.
Moreover, the statements lines 16, 18 and 20 in Algorithm 1 imply that when σ and σ′ are in
Σ∗, for every X →A in FD such that XA is a sub-set of sch(σ) and sch(σ′), if tuples(σ(X)) ∩
tuples(σ′(X))̸ = ∅, then σ(A) = σ′(A). This remark can be seen as an extension of the well-
known property of the output of the standard chase, by which all rows equal over X must have
the same A-value. As shown in the following proposition, the m-table Σ∗allows to compute the
sets True(T ) and Inc(T ).
Proposition 4 Let T be a table over U, FD the associated set of functional dependencies, and
Σ∗the output of Algorithm 1 run with T and FD as input. Then:
1. True(T ) = LoCl(Σ∗).
2. Inc(T ) = {t ∈T | (∃σ ∈Σ∗)(∃A ∈sch(t))(∃a, a′ ∈adom(A))(a ⊑t ∧t ⊑σ ∧(aa′) ⊑σ)}.
3. Cons(T ) ∩True(T ) = {t ∈True(T ) | (∀σ ∈Σ∗)(t ⊑σ ⇒tuples(σ(sch(t))) = {t})}.
Proof. 1. The result is an immediate consequence of Lemma 4(2).
2. The result follows from Lemma 4(2) and Deﬁnition 3.
3. The result follows from Deﬁnition 3 and the previous two items.
2
In order to assess the complexity of Algorithm 1, for every X →A in FD and every tuple x
in T (X), we let N(x) be the number of diﬀerent A-values a such that I∗(xa)̸ = ∅and a is
inconsistent, and we denote by δ the maximal value of all N(x) for all X →A in FD and all x
in True(T ); in other words δ = max({N(x) | X →A ∈FD ∧x ∈True(T )}).
Using this notation, the size of the m-tuples in Σ∗is bounded by |U|.δ, and as Σ∗contains
at most |T| m-tuples, a run of the core of loop line 4 is in O(|T|2.(|U|.δ)). Since the number of
runs of the loop line 4 is bounded by the changes in the sets in Σ∗, this number of runs is in
O(|T|.|FD|.δ) (that is the maximum number of constants that can be added in a set of Σ∗times
the size of Σ∗). Therefore, the computation of Σ∗is in O((|T|.|FD|.δ).(|T|2.(|U|.δ)), that is in
O(|T|3.|FD|.|U|.δ2) or even in O(|T|3.δ2), since |U| and |FD| are independent from |T|.
We draw attention to the following important points regarding this result:
1. When the database is consistent, δ is equal to 1, thus yielding a complexity in O(|T|3).
This result can be shown independently from the above computations as follows: In the
case of traditional chase the maximum of nulls in T being bounded by |U|.|T|, the number
of iterations when running the algorithm is also bounded by |U|.|T|.
Since the run of
one iteration is in |T|2, the overall complexity is in O(|U|.|T|3), or in O(|T|3), as |U| is
independent from |T|.
2. The above complexity study can be seen as a data complexity study as it relies on the size of
T. Thus, this study should be further investigated in order to provide more accurate results
regarding the estimation of the number of actual tests necessary to the computation of Σ∗.
The results in [8] are likely to be useful for such a more thorough study of this complexity.
4.2
Computing Consistent Answers
In this sub-section, we show how the consistent answers to a query can be computed based on
the m-table Σ∗. We stress that to state one of the results, it is assumed that Σ∗is not redundant,
23

---

that is for all σ1 and σ2 in Σ∗, neither σ1 ⊑σ2 nor σ2 ⊑σ1 holds. Notice that, if Σ∗is not
redundant then for all σ1 and σ2 in Σ∗, I∗(σ1) ∩I∗(σ2) = ∅.
Indeed, if I∗(σ1) ∩I∗(σ2)̸ = ∅, Lemma 4(2) implies that Σ∗contains σ such that σi ⊑σ
for i = 1, 2. As this entails that Σ∗contains redundancies, we obtain a contradiction. We also
notice in this respect that redundancies are eliminated at each step of the computation of Σ∗in
Algorithm 1 (see the statements lines 16 and 18). Thus, it turns out that if the table T contains
no redundancy, so does Σ∗.
Moreover, to state our results, we introduce the following additional notation. Let T be a non-
redundant table T over universe U, and Σ∗its associated non-redundant m-table, as computed
by Algorithm 1. Given a query Q : select X from T [where Γ], and a tuple x in T (X), we
respectively denote by Σ(x) and ΣQ(x), the sets deﬁned by Σ(x) = {σ ∈Σ∗| (x ⊑σ)} and
ΣQ(x) = {σ ∈Σ(x) | (∃s ∈Sat(Γ))(s ⊑σ)}.
Considering that ΣQ(x) = Σ(x) if Q involves no selection condition, the following proposition
characterizes the tuples in MSC ans(Q), SC ans(Q), C ans(Q) and WC ans(Q) in terms of m-
tuples as follows.
Proposition 5 Let T be a non-redundant table over universe U, FD the set of associated func-
tional dependencies and Σ∗the non-redundant m-table as computed by Algorithm 1. Given a
query Q : select X from T [where Γ], and a tuple x in T (X):
1. x is in MSC ans(Q) if and only if
(a) for every σ in Σ(x), tuples(σ(X)) = {x},
(b) there exists σ in ΣQ(x) such that |tuples(σ)| = 1.
2. x is in SC ans(Q) if and only if
(a) for every σ in Σ(x), tuples(σ(X)) = {x},
(b) there exists s in Sat(Γ) ∩True(T ) such that for every σ in ΣQ(x), if s is in σ(sch(Γ))
then tuples(σ(sch(Γ)))) = {s}.
3. x is in C ans(Q) if and only if
(a) for every σ in Σ(x), tuples(σ(X)) = {x},
(b) there exists σ in ΣQ(x) such that tuples(σ(sch(Γ))) ⊆Sat(Γ).
4. x is in WC ans(Q) if and only if
(a) for every σ in Σ(x), tuples(σ(X)) = {x},
(b) ΣQ(x) is not empty.
Proof. See Appendix C.
2
Example 8 We illustrate Proposition 5 in the context of Example 5 where U = {Emp, Sal, Dept},
FD = {Emp →Sal} and T = {es, es′d, e′s}. It is easy to see that Algorithm 1 returns truth
value true for fail and Σ∗= {σ1, σ2} where σ1 = (e)(ss′)(d) and σ2 = (e′)(s′).
We apply
Proposition 5 to the queries Q1, Q2, Q3, Q4, Q5 and Q6 shown below:
Q1 : select Emp, Dept from T
Q2 : select Emp, Sal from T
Q3 : select Sal from T
Q4 : select Emp from T where Sal = s′
24

---

Q5 : select Emp from T where Sal = s ∨Sal = s′
Q6 : select Emp from T where Sal > 10K
Since Q1 involves no selection condition, and since σ1 is the only m-tuple in Σ∗whose schema
contains Emp and Dept, the tests concern only this m-tuple. As tuples(σ1(Emp, Dept)) = {ed},
we have SC ans(Q1) = C ans(Q1) = {ed}. Moreover, as ΣQ1(ed) = {ed}, WC ans(Q1) = {ed}
and MSC ans(Q1) = ∅, because |tuples(σ1)| = 2.
For Q2, as tuples(σ1(Emp, Sal)) = {es, es′} and tuples(σ2(Emp, Sal)) = {e′s′}, it is immedi-
ate to see that SC ans(Q2) = C ans(Q2) = WC ans(Q2) = {e′s′}. Moreover, as e′s′ is a maximal
consistent and true tuple, we also have MSC ans(Q2) = {e′s′}. In the case of Q3, it is easily seen
that the four answers are empty because tuples(σ1(Sal)) = {s, s′}.
Considering Q4, as tuples(σ1(Emp)) = {e} and tuples(σ2(Emp)) = {e′}, and thus, these
two values satisfy statement (a) in the four items in Proposition 5. As Sat(Γ4) = {s′}, it is
easy to see that ΣQ4(e) = {σ1} and ΣQ4(e′) = {σ2}.
Thus, WC ans(Q4) = {e, e′}.
Then,
as |tuples(σ1(Emp, Sal))| = 2, e does not belong to MSC ans(Q4) nor to SC ans(Q4).
Since
tuples(σ1(Sal)) = {s, s′}, e is not in C ans(Q4) either, because statement (3.b) is not satisﬁed
(as s is not in Sat(Γ4)). On the other hand is is easy to see that σ2 satisﬁes statements (b),
entailing that we have MSC ans(Q4) = SC ans(Q4) = C ans(Q4) = {e′}.
Concerning Q5, the two candidate Emp-values are again e and e′. As Sat(Γ5) = {s, s′},
ΣQ5(e) = {σ1} and ΣQ5(e′) = {σ2}, thus WC ans(Q5) = {e, e′}. As for Q4, e does not belong to
MSC ans(Q5) and SC ans(Q5) because we have |tuples(σ1(Emp, Sal))| = 2. However, σ1 satisﬁes
item (3.b) in Proposition 5 because tuples(σ1(Sal)) is indeed a sub-set of Sat(Γ5).
Thus, e
belongs to C ans(Q5). The case of e′ and σ2 being similar to the previous query, we obtain
MSC ans(Q5) = SC ans(Q5) = {e′} and C ans(Q5) = {e, e′}.
Regarding Q6, if s = 15K and s′ = 20K, MSC ans(Q6) = SC ans(Q6) = {e′} and C ans(Q6) =
WC ans(Q6) = {e, e′} due to arguments similar to the previous case, and if s = 5K and s′ = 20K,
we have MSC ans(Q6) = SC ans(Q6) = C ans(Q6) = {e′} and WC ans(Q6) = {e, e′}, due to
arguments similar to the case of Q4 above.
2
Based on Proposition 5, it can be seen that, given a query Q, Algorithm 2 computes the consistent
answer to Q. Indeed, the test line 4 discards all m-tuples of Σ∗whose schema does not contain X,
because such m-tuples have no chance to provide an X-value. Then, the items in Proposition 5
are checked as follows:
• The test line 5 allows to store in the set ToRemove X all X-values of m-tuples σ such that
tuples(σ(X)) contains more than one tuple. All these tuples being inconsistent, are then
removed from the set of retrieved X-values in MSC ans(Q) (line 24), in SC ans(Q) (line 26),
in C ans(Q) (line 27) and in WC ans(Q) (line 28). Therefore, the statements (1.a), (2.a),
(3.a) and (4.a) in Proposition 5 are satisﬁed by the returned sets. In what follows, we
consider that the test line 5 fails, that is that tuples(σ(X)) = {x}.
• Statement (4.b) is concerned when the tests lines 9 and 10 succeed. Indeed, in this case,
there exists a tuple s in tuples(σ(sch(Γ))) such that s is in Sat(Γ), meaning that σ is in
ΣQ(x). Therefore, in this case, x is inserted in WC ans(Q) (line 11).
• Regarding the statement (1.b) in Proposition 5, on line 9 it is checked that the schema of Γ
is a sub-set of that of σ. If yes, when the tests lines 10 and 12 succeed, σ is in fact a tuple
t satisfying Γ. As moreover, Σ∗is not redundant, t occurs nowhere else in Σ∗, meaning by
Proposition 4(3) that t is in Cons(T ). Hence, x is inserted in MSC ans(Q) (line 13). Notice
that in this case, the inclusions stated in Proposition 3 justify that x be also inserted in
SC ans(Q) (line 14) and in C ans(Q) (line 15).
25

---

Algorithm 2 Consistent answers
Input: A query Q : select X from T [where Γ] and Σ∗
Output: The sets MSC ans(Q), SC ans(Q), C ans(Q) and WC ans(Q)
1: MSC ans(Q) := ∅; SC ans(Q) := ∅; C ans(Q) := ∅; WC ans(Q) := ∅
2: ToRemove X := ∅; Candidate SC := ∅; ToRemove SC := ∅
3: for all σ in Σ∗do
4:
if X ⊆sch(σ) then
5:
if |tuples(σ(X))| > 1 then
6:
ToRemove X := ToRemove X ∪tuples(σ(X))
7:
else
8:
Let x denote the unique tuple in σ(X)
9:
if sch(Γ) ⊆sch(σ) then
10:
if tuples(σ(sch(Γ))) ∩Sat(Γ)̸ = ∅then
11:
WC ans(Q) := WC ans(Q) ∪{x}
12:
if |tuples(σ)| = 1 then
13:
MSC ans(Q) := MSC ans(Q) ∪{x}
14:
SC ans(Q) := SC ans(Q) ∪{x}
15:
C ans(Q) := C ans(Q) ∪{x}
16:
else
17:
if |tuples(σ(sch(Γ)))| = 1 then
18:
Candidate SC := Candidate SC ∪tuples(σ(sch(Q)))
19:
C ans(Q) := C ans(Q) ∪{x}
20:
else
21:
ToRemove SC := ToRemove SC ∪tuples(σ(sch(Q)))
22:
if tuples(σ(sch(Γ))) ⊆Sat(Γ) then
23:
C ans(Q) := C ans(Q) ∪{x}
24: MSC ans(Q) := MSC ans(Q) \ ToRemove X
25: SC ans(Q) := SC ans(Q) ∪{x | (∃q ∈Candidate SC \ ToRemove SC)(q.X = x)}
26: SC ans(Q) := SC ans(Q) \ ToRemove X
27: C ans(Q) := C ans(Q) \ ToRemove X
28: WC ans(Q) := WC ans(Q) \ ToRemove X
29: return MSC ans(Q), SC ans(Q), C ans(Q), WC ans(Q)
• As for statement (2.b), assuming that the test line 9 succeeds, the case when the test
line 12 succeeds is as above.
Now, if this test fails, then, if the test line 17 succeeds,
then σ(sch(Q)) might be a consistent true tuple t satisfying Γ, unless t occurs in some
other tuples(σ′(sch(Q))) such that |tuples(σ′(sch(Q)))| > 1, meaning that t is inconsistent.
This is why t is inserted in the set Candidate SC when the test line 17 succeeds, and
when this test fails, the tuples in the set tuples(σ(sch(Q))) are stored in ToRemove SC.
Proposition 4(3) then ensures that the tuples in Candidate SC \ ToRemove SC are in-
deed consistent true tuples satisfying Γ (other than maximal ones earlier detected). The
statement line 25 adds the corresponding X-values in the set SC ans(Q).
• Considering now statement (3.b) when the test line 9 succeeds, we ﬁrst notice that, thanks
to Proposition 3, the insertions in C ans(Q) in statements lines 15 and 19 are correct.
Moreover, when the test line 22 succeeds, the condition in the statement (3.b) is satisﬁed,
and so, x is inserted in C ans(Q) as stated line 23.
We illustrate Algorithm 2 using the queries Q3 and Q4 of Example 8, respectively deﬁned by
Q3 : select Sal from T and Q5 : select Emp from T where Sal = s ∨Sal = s′.
Regarding Q3, when considering σ1, ToRemove X is set to {s, s′} because the test line 5
succeeds. Then, with σ2, the test line 5 fails and the test line 10 succeeds, entailing that s′ is
inserted in WC ans(Q3). Then, as the test line 12 succeeds, s′ is inserted in MSC ans(Q) (line 13),
SC ans(Q) (line 14) and in C ans(Q) (line 15). When processing the statements lines 24, 26 and
27, s′ is removed, thus producing empty answers, as expected.
26

---

As for Q5, when processing σ1, the test line 5 fails for σ1 and σ2 because |tuples(σi(Emp))| = 1
(i = 1, 2).
Thus ToRemove X remains empty in this case.
When processing σ1, the tests
line 12 and line 17 fail (because |tuples(σ1)| = 2 and |tuples(σ1(Sal))| = 2) and the test
line 22 succeeds (because tuples(σ1(Sal)) = Sat(Γ5) = {s, s′}).
Thus, ToRemove SC is set
to {es, es′} line 21 and C ans(Q) is set to {e} line 23.
Then, when processing σ2, all tests
succeed (because |tuples(σ2)| = |tuples(σ2(Sal))| = 1 and tuples(σ2(Sal)) = {s′}).
Thus,
e′ is inserted in WC ans(Q5), MSC ans(Q5), SC ans(Q5) and C ans(Q5).
The loop line 3 re-
turns ToRemove X = ∅, Candidate SC = ∅, ToRemove SC = ∅, along with WC ans(Q5) =
MSC ans(Q5) = SC ans(Q5) = C ans(Q5) = {e, e′}, which is not changed by the statements
lines 24-28. We thus obtain all four consistent answers equal to {e, e′}, as expected.
In the next example, we further illustrate the role of the sets Candidate SC and ToRemove SC
in Algorithm 2.
Example 9 Let U = {A, B, C, D} over which the functional dependencies C →B and C →
D are assumed. For T = {abcd, abcd′, abc′, ab′c′}, Algorithm 1 returns Σ∗= {(a)(b)(c)(dd′),
(a)(bb′)(c′)}, and the processing of SC ans(Q) for Q : select A from T where B = b, is as
follows:
• For σ = (a)(b)(c)(dd′), the tests line 4 and line 12 fail (as |tuples(σ(A))| = 1 and |tuples(σ)| =
2), whereas the test line 10 succeeds (because Sat(Γ) = {b}). Thus ToRemove X remains
empty and as the test line 17 succeeds (because tuples(σ(B)) = {b}), ab is inserted in
Candidate SC on line 18, and SC ans(Q) remains empty.
• For σ = (a)(bb′)(c′), as the test line 4 fails, ToRemove X remains empty, and as the tests
line 12 and line 17 also fail, ab and ab′ are inserted in ToRemove SC due to the statement
line 21.
Thus, the loop line 3 generates ToRemove X = ∅, Candidate SC = {ab} and ToRemove SC =
{ab, ab′}. Therefore, when processing the statement line 25, SC ans(Q) remains empty (because
Candidate SC \ ToRemove SC = ∅), as expected based on Deﬁnition 6(2), because ab is incon-
sistent.
Considering now T1 = {abcd, abcd′}, Algorithm 1 returns Σ∗
1 = {(a)(b)(c)(dd′)} and the com-
putations are as in the ﬁrst item above, implying that the loop line 3 generates ToRemove X = ∅,
Candidate SC = {ab}, ToRemove SC = ∅and SC ans(Q) = ∅. When processing the statement
line 25, SC ans(Q) is set to {a} (because Candidate SC \ ToRemove SC = {ab}), as expected
based on Deﬁnition 6(2), because ab is a consistent true tuple satisfying Γ.
2
To assess the complexity of Algorithm 2, we ﬁrst notice that this algorithm is clearly linear in the
size of Σ∗. Moreover, using the same notation as when assessing the complexity of Algorithm 1,
for σ in Σ∗, the size of tuples(σ) is in O(|FD|.δ), that is in O(δ), because |FD| is independent
from T. Hence, the complexity of computing the consistent answer to a query in our approach
is in O(|Σ∗|.δ). Since it has been shown that |Σ∗| ≤|T|, we state that the sizes of Σ∗and of T
are of the same order. Therefore, the complexity of computing all four consistent answers to a
query in our approach is in O(|T|.δ), that is linear in the size of the table T.
It is however important to stress that Algorithm 2 requires signiﬁcant extra storage due to
the sets ToRemove X, Candidate SC and ToRemove SC. It should be noticed that the storage
of ToRemove X and ToRemove SC can be avoided by implementing a second scan of Σ∗whose
role would be to detect the X-values to be removed (when |tuples(σ(X))| > 1) and the tuples
in Candidate SC to be removed (when |tuples(σ(sch(Q)))| > 1). As usual, this option saves
storage at the cost of further processing, namely an additional scan of Σ∗.
27

---

5
Related Work
The problem of consistent query answering has attracted considerable attention in the last two
decades [1] and continues to be an active area of research today [4]. The approach by repairs
is one that has attracted most attention in recent years and thus has been the subject of many
papers, whose overview lies outside the scope of this paper.
We refer to [5, 20] for detailed
surveys covering the topic. The fact that “deciding whether a candidate answer is a consistent
answer is most commonly intractable in data complexity” [7] generated several research eﬀorts
recently focusing on approximate consistent answers [6, 11], and on issues related to the counting
of repairs [7, 15].
Our approach to consistent query answering is radically diﬀerent as it does not rely on repairs
but rather on set theoretic semantics for tuples and functional dependencies. Consequently, to
compare our approach with repair-based approaches, we focus only on the basic diﬀerences
between the two approaches.
Our goal is to show that although the problem tackled is the
same, our approach is hardly comparable with those from the literature (see Section 5.1). We
then introduce in Section 5.2 the notion of strong repairs according to which some comparison is
possible, and in Section 5.3 we compare the approach presented in this paper and the approach
in our earlier work [12].
5.1
Comparison with Repair-Based Approaches
We ﬁrst point out that repair-based approaches assume a table T with no nulls. Therefore to
compare our approach to repair-based approaches we need to restrict our attention to tables with
functional dependencies but without nulls.
In this context, we identify and discuss three fundamental diﬀerences between our approach
and the approach by repairs, namely : (D1) the two approaches use diﬀerent universes of dis-
course, (D2) the two approaches use diﬀerent assumptions when evaluating queries, and (D3)
the two approaches use functional dependencies for diﬀerent purposes.
(D1) diﬀerent universes of discourse.
We recall from Section 2 that the universe of discourse of a table T is the space in which queries
are evaluated. The universe of discourse in our approach, denoted by T , is the set of all tuples
one can deﬁne using constants appearing in T. On the other hand, the universe of discourse in
the repairs approach, that we shall denote by Tr, is the set of all tuples of T together with all
their sub-tuples. For example, if T = {ab, a′b′} then T = {ab, a′b′, a′b, ab′, a, b, a′, b′} whereas
Tr = {ab, a′b′, a, b, a′, b′}.
(D2) diﬀerent assumptions when evaluating queries.
The repairs approach uses the Closed World Assumption [16] that is:
the only true tuples are those in Tr (implying that tuples not in Tr are false)
whereas our approach uses the Open World Assumption that is:
the only true tuples are those in T together with all tuples derived using the functional
dependencies (implying that all other tuples in T are false).
It follows that if a tuple t of Tr is true then t is true in T , that is True(Tr) ⊆True(T ), while the
opposite does not hold.
For example, consider the table T = {abc, ab′c′} with functional dependency A →B. In
this case, ac is in T and in True(T ), and ac is in True(Tr) as well. On the other hand, since
Σ∗= {(a)(bb′)(c), (a)(bb′)(c′)}, the tuple abc′ is in T but not in Tr. Thus abc′ is not in True(Tr),
whereas abc′ is in True(T ).
28

---

Regarding inconsistent tuples, the comparison not as easy since, to the best of our knowledge,
the notion of inconsistent tuple is not explicitly deﬁned in repair-based approaches. However, it
is clear that a table T is inconsistent if and only if there exists a functional dependency X →A
such that the two tuples xa and xa′ in T (XA) occur in T. The pair (xa, xa′) is usually called a
conﬂicting pair, and we deﬁne inconsistent tuples in this context as follows:
t is inconsistent if there exists a conﬂicting pair (xa, xa′) such that t is a super-tuple of xa.
Denoting the set of these tuples by Conf Inc(Tr), we argue that Conf Inc(Tr) ⊆Inc(T ) whereas
the inverse inclusion does not always hold. Indeed, based on Deﬁnition 3, it is easy to see that,
for every conﬂicting pair (xa, xa′), the tuples xa, xa′ and all their true super-tuples are in Inc(T ),
thus showing the inclusion Conf Inc(Tr) ⊆Inc(T ). The previous example with T = {abc, ab′c′}
and A →B, shows that the inverse inclusion does not always hold, because b is clearly not in
Conf Inc(Tr), whereas Deﬁnition 3 implies that b is in Inc(T ).
(D3) diﬀerent purposes in the use of functional dependencies.
The repair-based approaches use functional dependencies as a means for checking the consistency
of T (i.e., as a means of inference of inconsistent tuples).
In our approach, we also use the
functional dependencies as a means of inference of inconsistent tuples. However, additionally,
we use the functional dependencies as a means of inference of true tuples.
For example, if
T = {abc, ab′c′} and FD = {A →B}, our approach allows us to infer that abc is true and
inconsistent, as repair-based approaches do. However, additionally, our approach allows to infer
that the tuple ab′c is also true and inconsistent, which repair-based approaches fail to do since
ab′c is not even in Tr.
Now that we have stated the diﬀerences in the ways the two approaches operate, consider a
query Q : select X from T where Γ, and recall that in repair-based approaches, the consistent
answer to Q is deﬁned as the set of true tuples x in Tr such that, every repair contains a tuple
satisfying the condition Γ and whose restriction over X is x. Denoting this set by Rep ans(Q),
we recall that, by Deﬁnition 5, all consistent answers to Q in our approach are sets of true and
consistent tuples in T (X). It is thus not surprising that the two approaches to consistent query
answering are not comparable.
Summarising our discussion so far we cannot claim that either of the two approaches is
better or preferable than the other. They are simply diﬀerent as they have diﬀerent universes of
discourse, they operate under diﬀerent assumptions and they use the functional dependencies in
diﬀerent ways.
What we can reasonably claim in favor of our approach is that: (a) it provides a formal
framework based on which diﬀerent kinds of consistent answers can be deﬁned, (b) it oﬀers
a polynomial algorithm for evaluating the consistent answer to a query, whether conjunctive
or disjunctive, and (c) by allowing nulls in the table, our approach broadens the angle of its
application to other important areas of research as explained in the concluding Section 6.
5.2
Strong Repairs
As highlighted in the previous section, repair approaches do not compare to our approach.
Nevertheless, in this section, we propose a modiﬁed version of the notion of repair according to
which some comparison is possible.
First we recall that given a table T without nulls and a set FD of functional dependencies
over T, a repair of T is deﬁned to be a maximal consistent sub-set of T, where maximality is
understood with respect to set-theoretic inclusion. For example given T = {eda, eda′, e′d′a} and
FD = {Emp →Dept, Dept →Addr} as in our introductory example, we obtain two repairs
29

---

R1 = {eda, e′d′a} and R2 = {eda′, e′d′a} and so the consistent answer to Q :
select Emp
from T where Addr = a is {e, e′} ∩{e′}, that is {e′}. We refer to [3] for a theoretical account on
how to compute such consistent query answers when T is a table without nulls.
However, when the table T contains nulls then the question is: which table should be repaired?
In other words: what is the deﬁnition of a repair in this case? We illustrate this point in the
following example.
Example 10 Referring to Examples 3 and 4, let T = {ab, bc, ac′} and FD = {A →C, B →C}.
Considering that T shows no explicit violation of functional dependencies, repairing T is trivial,
and thus, the consistent answer to Q : select A, C from T would be {ac′}. However, according to
approaches related to universal relation [17, 18], the table T has to be chased before computing
the answer to Q. In this case, the traditional chase algorithm fails because of A →C and the
presence of abc and ac′ in the chased table. Consequently, the query cannot be answered.
We cope with this diﬃculty in our approach by computing Σ∗= {(a)(b)(cc′)}, and thus,
showing the inconsistency. In this context, it is possible to deﬁne R1 = {abc} and R2 = {abc′} as
the two repairs of T and then, to state that the consistent answer to Q is empty. The remainder
of the section elaborates on this idea and compares it to our approach explained earlier.
2
As suggested by Example 10, in the presence of nulls, the table to be repaired is not T itself,
but the table denoted by T ∗that contains all tuples in tuples(σ) for every σ in Σ∗. Formally,
T ∗= S
σ∈Σ∗tuples(σ).
Going one step further, as mentioned in the previous section, consistent answers to queries in
our approach and in the repair-based approach using T ∗are not comparable. To formalize this
statement, we denote by R cons(T) the set of all tuples occurring in every repair of T ∗, and we
give examples showing that R cons(T) and Cons(T ) ∩True(T ) are not comparable with respect to
set-theoretic inclusion.
First, for T = {ab, ab′, bc} over U = {A, B, C} and FD = {A →B}, we have Σ∗= {(a)(bb′),
(b)(c)}. We thus have two repairs R1 and R2 where R1 = {ab, bc} and R2 = {ab′, bc}. It follows
that b is in R cons(T) whereas it is obvious that b is in Inc(T ), thus not in Cons(T ) ∩True(T ).
Therefore, R cons(T) ⊆Cons(T ) ∩True(T ) does not hold in general.
Now, let U = {A, B, C, D}, FD = {A →C, B →C} and T = {acd, ac′d, bcd′, bc′d′, abc,
abc′}, in which case Σ∗= {(a)(c, c′)(d), (b)(c, c′)(d′), (a)(b)(c, c′)}. Thus, we obtain the four
repairs R1 = {acd, bcd′, abc}, R2 = {ac′d, bc′d′, abc′}, R3 = {acd, bc′d′} and R4 = {ac′d, bcd′}.
In this case, ab is clearly not in R cons(T), whereas, by Proposition 4(3), ab belongs to Cons(T )∩
True(T ). It therefore turns out that Cons(T ) ∩True(T ) ⊆R cons(T) does not hold in general.
The last counter-example suggests that, in repair-based approaches, an m-tuple in Σ∗might
have no ‘representatives’ in some repairs (e.g., no tuple of tuples((a)(b)(cc′)) is present in R3 or
in R4). This means that the repairs R3 or R4 do not convey the information that, in any repair
abc or abc′ must be true, as stated by Σ∗. In order to account for this remark, we restrict repairs
so as, for every σ in Σ∗, every repair contains at least one tuple of tuples(σ).
Deﬁnition 8 Given a table T over U, FD the associated set of functional dependencies, and
Σ∗the corresponding m-table, a table R over U is a strong repair of T if R is a repair of T ∗,
and if for every σ in Σ∗, R ∩tuples(σ) is nonempty. The set of all strong repairs of T is denoted
by S rep(T).
2
In the case of the last counter-example above, R1 and R2 are in S rep(T) whereas R3 and R4
are not. On the other hand, since in this case Cons(T ) ∩True(T ) = {ab, ad, bd′, a, b, d, d′}, it
should be observed that all tuples in Cons(T ) ∩True(T ) occur in R1 and in R2. To show that
this property always holds, we introduce the following terminology:
30

---

• The strong-repair-based consistent answer to Q, denoted by SRep ans(Q), is deﬁned as the
intersection of all answers to Q in every strong repair of T. Formally, if Ans(Q[R]) denotes
the answer to Q in R, SRep ans(Q) = T
R∈S rep(T ) Ans(Q[R]).
• The set of all strong-repair-based consistent tuples, denoted by S cons(T), is deﬁned as the
set of all tuples occurring in every strong repair.
Before showing the main result of this sub-section to compare Cons(T )∩True(T ) and S cons(T),
we show the following basic lemma.
Lemma 5 Given a table T over U and the associated set of functional dependencies FD, for
every t in T ∗, there exists R in S rep(T) such that t is in R.
Proof. The repair R considered here is built up as follows, based on the m-tuples of Σ∗. First
let σt be an m-tuple of Σ∗such that t ∈tuples(σt). For every A in sch(t) and every m-tuple σ
such that A is in sch(σ) and t.A in tuples(σ(A)), mark t.A in σ(A). Notice that at this stage, all
components of σt have a marked value. In this case, the tuple consisting of these marked values
is inserted in R and the process is iterated until there remains no unmarked components in any
m-tuple of Σ∗. That is, at each step, a ‘non-fully marked’ m-tuple in Σ∗is chosen and processed
similarly to t. When the process terminates, every component of every σ has one value marked,
which deﬁnes a tuple of tuples(σ) to be inserted in R.
We now prove that R satisﬁes all functional dependencies in FD. If not, let t and t′ in R
and X →A in FD such that t.X = t′X and t.A̸ = t′.A. It follows that there exist σ and σ′
in Σ∗such that t ∈tuples(σ) and t′ ∈tuples(σ′), t.X ∈tuples(σ(X)) ∩tuples(σ′(X)). Hence,
by construction of Σ∗, we have σ(A) = σ′(A), and thus, by construction of R, it must be that
t.A = t′.A, which is a contradiction. Thus R satisﬁes FD, and to end the proof, we notice
that, if R is not maximal with respect to set-theoretic inclusion, tuples from T ∗respecting the
functional dependencies are added, thus leading to a strong repair containing t. The proof is
therefore complete.
2
As a case of non-maximality of R in the proof above, consider Σ∗= {(aa′)(bb′)}, FD = {A →
B, B →A} and t = ab. Then a and b are marked and the process stops producing {ab} which
is not maximal since {ab, a′b′} is a repair of T ∗.
It is important to notice that, as a consequence of Lemma 5, the set S rep(T) can not be
empty, when T is nonempty. Moreover, given a selection condition Γ, Lemma 5 implies that if
Σ∗contains an m-tuple σ such that every t in tuples(σ) satisﬁes Γ, then every strong repair of T
contains a tuple satisfying Γ.
The following proposition shows that consistent true tuples are consistent with respect to
strong repairs, that is every consistent true tuple occurs in every strong repair.
Proposition 6 Let T be a table over U and FD its associated set functional dependencies. Then
Cons(T ) ∩True(T ) ⊆S cons(T) holds.
Moreover, every t in S cons(T) but not in Cons(T ) ∩True(T ) is in Inc(T ).
Proof.
Let t be in Cons(T ) ∩True(T ).
By Proposition 4(3), for every σ in Σ∗such that
tuples(σ(sch(t))) contains t, we have tuples(σ(sch(t))) = {t}. Thus, for every q in tuples(σ),
q.sch(t) = t, and so, as every R in S rep(T) contains at least one tuple of tuples(σ), t occurs in
R, meaning that t belongs to S cons(T).
Assume now that t is in S cons(T) but not in Cons(T ) ∩True(T ). Since t is in S cons(T),
then there exists σ in Σ∗such that t is in tuples(σ(sch(t))). Thus, by Proposition 4(1), t is in
True(T ). Since on the other hand, t is not in Cons(T ) ∩True(T ), t is in Inc(T ), and the proof is
complete.
2
31

---

Corollary 1 Let T be a table over U and FD its associated set of functional dependencies. For
every query Q, C ans(Q) ⊆SRep ans(Q) holds.
Proof. Given x in C ans(Q), by Proposition 5, there exists σ in Σ∗such that tuples(σ(X)) = {x}
and tuples(σ(sch(Γ))) ⊆Sat(Γ). As every strong repair R of T ∗contains a tuple in tuples(σ),
every strong repair R of T ∗contains a tuple q such that q.X = x and q.sch(Γ) ∈Sat(Γ).
Therefore, for every strong repair R of T ∗, x is in the answer to Q in R, meaning that x is in
SRep ans(Q), and the proof is complete.
2
As a consequence of Corollary 1 and Proposition 3, the following inclusions hold for every Q:
MSC ans(Q) ⊆SC ans(Q) ⊆C ans(Q) ⊆SRep ans(Q).
5.3
Comparison with the Approach in [12]
The approach presented in this paper and the approach in [12], both rely on partition semantics
[17]. However, the two approaches have important diﬀerences. First, although the limit inter-
pretation I∗as deﬁned in Section 2 is the same as the interpretation µ∗in [12], we have proved
here the uniqueness of I∗which is not done for µ∗.
Second, the notions of true/false tuples and of inconsistent/consistent tuples diﬀer between
the two approaches. More precisely, since in [12], truth values are deﬁned inspired by the Four-
valued logic of [2], it is not possible to have tuples that are, for instance, true and consistent, as
in the present work.
Third, the universe of discourse in [12], is potentially inﬁnite as it consists of all tuples that
can be built up using constants from the entire attribute domains; and this is an issue when it
comes to computing the set of all inconsistent tuples. In contrast, the universe of discourse in
the present work is ﬁnite as it consists of all tuples that can be built up using constants only
from the active attribute domains.
Fourth, the notion of inconsistent tuple is not deﬁned in the same way in the two approaches.
Indeed, in [12], a tuple is inconsistent if its interpretation is a sub-set of the interpretations of
two constants from the same domain. For example, consider the (true) tuples xa and xa′ in the
presence of X →A. These tuples are inconsistent in the present approach (see Deﬁnition 3), as
well as in the approach of [12]. However, the tuple x is also an inconsistent tuple according to
[12] (because its interpretation is a sub-set of those of a and a′), but is not inconsistent in the
present approach (because A is not in sch(x)). As a consequence, the consistent answer to a
query in [12] diﬀers from that in the present work.
Finally, the issue of consistent query answering has not been addressed in full details in [12]:
it is restricted to the case where the table T contains no nulls. We also note in this respect
that, based on the concept of m-table as introduced in Section 4, the present approach allows to
consider also disjunctive queries, an issue not addressed in [12], nor in repair-based approaches,
such as [5, 19].
6
Concluding Remarks and Future Work
In this paper, we have presented a novel approach to consistent query answering in tables with
nulls and functional dependencies. Given such a table T, we deﬁned T , the universe of discourse
of T, and using set-theoretic semantics for tuples and functional dependencies we partitioned
T in two orthogonal ways: into true and false tuples, on the one hand and into consistent and
inconsistent tuples on the other hand. Queries are addressed to T and evaluated in T in order
to obtain consistent answers. The consistent answer to a query Q : select X from T where
Condition over T was deﬁned to be the set of tuples x in T such that: (a) x is a true and
32

---

consistent tuple with schema X and (b) there exists a true super-tuple t of x in T satisfying
the condition. We have seen that, depending on the ‘status’ of the super-tuple t in T , there are
four diﬀerent types of consistent answer to Q and we have presented polynomial time algorithms
for computing these answers. We have also seen that our approach is not comparable to the
approaches based on table repairs or the approach of [12], as they have diﬀerent universes of
discourse and operate under diﬀerent assumptions.
By allowing the presence of nulls in the table, our approach opens the way for a number of im-
portant applications. We envisage three such applications of our approach. The ﬁrst is related to
universal relation interfaces [10, 17, 18]. Given a relational database with n tables T1, T2, . . . , Tn,
over schemes S1, S2, . . . , Sn and sets of functional dependencies FD1, FD2, . . . , FDn, respec-
tively, the universal relation is deﬁned to be a table T deﬁned as follows:
• The schema of T is S = S1 ∪S2 ∪. . .∪Sn and the associated set of functional dependencies
is FD = FD1 ∪FD2 ∪. . . ∪FDn.
• For each tuple t in Ti, t is placed in a new line of T with a new tuple identiﬁer, for all
i = 1, 2, . . . , n.
For example, if n = 2, T1 = {ab} and T2 = {bc} then the universal relation operates from a table
T with schema ABC and current instance T = {ab, bc} with two nulls, one under C and one
under A.
A prerequisite for deﬁning the table T is “name consolidation” that is (a) if an attribute name
appears in two diﬀerent database tables then it has the same meaning in the two tables and (b)
if two diﬀerent attribute names in the database have the same meaning then one is renamed to
the other (using the renaming operation of the relational model).
Once the table T is put in place querying the interface is straightforward: the system computes
a consistent answer using our polynomial Algorithm 2 and returns the result. However, updating
through such an interface poses several hard problems that we are currently investigating.
The second application that we envisage is query result explanation. As already mentioned,
the m-table Σ∗oﬀers a way to ‘display’ inconsistencies. We therefore plan to investigate how
m-tuples in Σ∗can be used to ‘explain’ to the user the presence or the absence of a given tuple
in a consistent answer. This issue seems particularly relevant in the context of data integration
and data exchange, where it is crucial to ‘explain’ consistent answers in reference to the sources
the data come from [4].
The third application that we envisage is related to data quality. Based on the two orthogonal
ways of characterizing tuples, namely consistent/inconsistent and true/false, we consider that the
inconsistent tuples are as good a source of information as they are the consistent tuples; and
similarly, we consider that the false tuples are as good a source of information as they are the
true tuples. In doing so we can develop a meaningful theory for the quality of data in a data-set
(whether the data-set is a table or a query result). To this end, we plan to consider various quality
measures such as percentages of consistent/inconsistent tuples in the data-set, percentages of true
or false tuples, or combinations thereof.
Acknowledgment
Work conducted while the second author was visiting at FORTH Institute of Computer Science,
Crete, Greece (https://www.ics.forth.gr/)
Declarations
The two authors contributed to the study, conception and design. Both read and approved the
manuscript.
No funds, grants, or other support was received for conducting this study.
33

---

References
[1] Marcelo Arenas, Leopoldo E. Bertossi, and Jan Chomicki.
Consistent query answers in
inconsistent databases. In Victor Vianu and Christos H. Papadimitriou, editors, Proceedings
of the Eighteenth ACM SIGACT-SIGMOD-SIGART Symposium on Principles of Database
Systems, Pennsylvania, USA, pages 68–79. ACM Press, 1999.
[2] Nuel D. Belnap. A useful four-valued logic. In J. Michael Dunn and George Epstein, editors,
Modern Uses of Multiple-Valued Logic, pages 5–37”, isbn=”978–94–010–1161–7, Dordrecht,
1977. Springer Netherlands.
[3] Leopoldo E. Bertossi.
Database Repairing and Consistent Query Answering.
Synthesis
Lectures on Data Management. Morgan & Claypool Publishers, 2011.
[4] Leopoldo E. Bertossi. Specifying and computing causes for query answers in databases via
database repairs and repair-programs. Knowl. Inf. Syst., 63(1):199–231, 2021.
[5] Leopoldo E. Bertossi and Jan Chomicki. Query answering in inconsistent databases. In Jan
Chomicki, Ron van der Meyden, and Gunter Saake, editors, Logics for Emerging Applica-
tions of Databases [outcome of a Dagstuhl seminar], pages 43–83. Springer, 2003.
[6] Marco Calautti, Sergio Greco, Cristian Molinaro, and Irina Trubitsyna. Query answering
over inconsistent knowledge bases: A probabilistic approach. Theor. Comput. Sci., 935:144–
173, 2022.
[7] Marco Calautti, Ester Livshits, Andreas Pieris, and Markus Schneider. Uniform operational
consistent query answering. In Leonid Libkin and Pablo Barcel´o, editors, PODS ’22: Inter-
national Conference on Management of Data, Philadelphia, PA, USA, June 12 - 17, 2022,
pages 393–402. ACM, 2022.
[8] Stavros S. Cosmadakis, Paris C. Kanellakis, and Nicolas Spyratos. Partition semantics for
relations. J. Comput. Syst. Sci., 33(2):203–233, 1986.
[9] Ronald Fagin, Phokion G. Kolaitis, Ren´ee J. Miller, and Lucian Popa.
Data exchange:
semantics and query answering. Theor. Comput. Sci., 336(1):89–124, 2005.
[10] Ronald Fagin, Alberto O. Mendelzon, and Jeﬀrey D. Ullman. A simpliﬁed universal relation
assumption and its properties. ACM Trans. Database Syst., 7(3):343–360, 1982.
[11] Floris Geerts, Fabian Pijcke, and Jef Wijsen. First-order under-approximations of consistent
query answers. In Christoph Beierle and Alex Dekhtyar, editors, Scalable Uncertainty Man-
agement - 9th International Conference, SUM 2015, Qu´ebec City, QC, Canada, September
16-18, 2015. Proceedings, volume 9310 of Lecture Notes in Computer Science, pages 354–367.
Springer, 2015.
[12] Dominique Laurent and Nicolas Spyratos. Handling inconsistencies in tables with nulls and
functional dependencies. J. Intell. Inf. Syst., 59(2):285–317, 2022.
[13] Mark Levene and George Loizou. A guided tour of relational databases and beyond. Springer,
1999.
[14] Ester Livshits, Benny Kimelfeld, and Sudeepa Roy. Computing optimal repairs for functional
dependencies. ACM Trans. Database Syst., 45(1):4:1–4:46, 2020.
34

---

[15] Ester Livshits, Benny Kimelfeld, and Jef Wijsen. Counting subset repairs with functional
dependencies. J. Comput. Syst. Sci., 117:154–164, 2021.
[16] R. Reiter. On closed World DataBases. Gallaire et Minker, Plenium Press, New York, 1978.
[17] Nicolas Spyratos. The partition model: A deductive database model. ACM Trans. Database
Syst., 12(1):1–37, 1987.
[18] Jeﬀrey D. Ullman. Principles of Databases and Knowledge-Base Systems, volume 1-2. Com-
puter Science Press, 1988.
[19] Jef Wijsen. Database repairing using updates. ACM Trans. Database Syst., 30(3):722–768,
2005.
[20] Jef Wijsen.
Foundations of query answering on inconsistent databases.
SIGMOD Rec.,
48(3):6–16, 2019.
[21] Justin Zobel and Alistair Moﬀat. Inverted ﬁles for text search engines. ACM Comput. Surv.,
38(2):6, 2006.
[22] Justin Zobel, Alistair Moﬀat, and Kotagiri Ramamohanarao. Inverted ﬁles versus signature
ﬁles for text indexing. ACM Trans. Database Syst., 23(4):453–490, 1998.
A
On the Church-Rosser Property of Expansion
We show that expansion has the Church-Rosser property, that is when iterating the process, the
order in which the steps are preformed is irrelevant. We ﬁrst recall the deﬁnition of expansion.
Deﬁnition 4
The expansion of an interpretation I with respect to a functional dependency
X →A and the tuple xa in T (XA) is the interpretation Exp(I, xa) deﬁned as follows:
• If I(x) ∩I(a)̸ = ∅and I(x)̸ ⊆I(a) then:
Exp(I, xa)(a) = I(a) ∪I(x), and Exp(I, xa)(α) = I(α) for α in AD diﬀerent than a.
• Otherwise, Exp(I, xa) = I.
We consider two expansions one with respect to the dependency X →A and the tuple xa
and the other one with respect to the dependency Y →B and the tuple yb. Starting with
an interpretation I1, let I2 = Exp(I1, xa) and I3 = Exp(I1, yb). Referring to Figure 2(a), the
problem is to ﬁnd sequences of expansions called E2 and E3 in the ﬁgure, such that I24 = E2(I2)
and I34 = E3(I3) are equal.
It should be clear that if I2 = I1 or I3 = I1, then the order in which the expansions are
processed is irrelevant. For example, if I2 = I1 and I3̸ = I1, we obtain I24 = I34 by setting
E3 = ϵ (where ϵ denotes the empty sequence) and E2 = Exp(I1, yb).
From now on, we assume that I2̸ = I1 and I3̸ = I1. Based on Deﬁnition 4, we have:
• I2(a) = I1(a) ∪I1(x) and for every α̸ = a, I2(α) = I1(α)
• I3(b) = I1(b) ∪I1(y) and for every β̸ = b, I2(β) = I1(β).
As a particular case, if it is assumed that a = b, we have:
• I2(a) = I1(a) ∪I1(x) and for every α̸ = a, I2(α) = I1(α)
35

---

• I3(a) = I1(a) ∪I1(y) and for every α̸ = a, I3(α) = I1(α).
Thus, as shown in Figure 2(b), for E2 = Exp(I2, ya) and E3 = Exp(I3, xa), I24 and I34 are such
that I24(a) = I34(a) = I1(a) ∪I1(x) ∪I1(y) and for every α̸ = a, I24(α) = I34(α) = I1(α). We
therefore have, in this case, I24 = I34.
 
 
I1
I3
I24 = I34
Exp xa
Exp yb
Exp yb
I1
I2
I3
I24 = I34
Exp xa
Exp xa
Exp yb
E2 ?
E3 ?
(a) Generic diagram
(b) (a = b) or (y ≠ y'a  and  x ≠ x'b)
I1
Exp xa
Exp xa
Exp yb
Exp yb
Exp yb
I2
I3
I31
I24 = I34
(c) y = y'a  and  x ≠ x'b
I2
Exp xa
Exp xa
Exp yb
Exp yb
Exp yb
Exp xa 
(d) y = y'a  and  x = x'b
I1
I2
I21
I31
I3
I24 = I34
Figure 2: Expansion Diagrams
Now assuming that I2̸ = I1 and I3̸ = I1 and a̸ = b, if a does not occur in y and b does not
occur in x, the two expansions are independent from each other. In this case, as illustrated in
Figure 2(b), the following lemma holds.
Lemma 6 If a̸ = b, if a does not occur in y and b does not occur in x, for E2 = Exp(I2, yb)
and E3 = Exp(I3, xa), denoting respectively by I24 and I34 the interpretations Exp(I2, yb) and
Exp(I3, xa), we have I24 = I34, that is:
Exp(Exp(I1, xa), yb) = Exp(Exp(I1, yb), xa).
Proof. Since a does not occur in y, we have I2(y) = I1(y) and similarly, since b does not
occur in x, we have I3(x) = I1(x).
Therefore, for a and b, I24 = Exp(Exp(I1, xa), yb) and
I34 = Exp(Exp(I1, yb), xa) are deﬁned by:
−I24(a) = Exp(I2, yb)(a) = I2(a) = I1(a) ∪I1(x) (because a̸ = b)
−I24(b) = Exp(I2, yb)(b) = I2(b) ∪I2(y) = I1(b) ∪I1(y)
−I34(a) = Exp(I3, xa)(a) = I3(a) ∪I3(x) = I1(a) ∪I1(x)
−I34(b) = Exp(I3, xa)(b) = I3(b) = I1(b) ∪I1(y) (because a̸ = b).
Hence, we have I24(a) = I34(a) and I24(b) = I34(b). Since no other symbol is changed by
expansions, we have shown the commutativity property in this case, namely I24 = I34.
2
We now switch to the most general case, namely when each expansion has an impact on the other.
This happens when a occurs in y and when b occurs in x. Indeed, as shown in Figure 2(d), in this
case, writing x and y respectively as bx′ and ay′, we notice the following: I2(y)̸ = I1(y) because
36

---

I2(y) = I2(a)∩I2(y′) and I2(a)̸ = I1(a), and similarly, I3(x)̸ = I1(x) because I3(x) = I3(b)∩I3(x′)
and I3(b)̸ = I1(b).
An important remark regarding x′ and y′ is that neither a nor b occurs is these tuples,
thus implying that, during the computations of the various expansions considered here, their
interpretation will not change, thus remaining equal to I1(x′) and I1(y′), respectively.
For
example, I2(y) = I2(a) ∩I2(y′) and I3(x) = I3(b) ∩I3(x′) can be respectively written as I2(y) =
I2(a) ∩I1(y′) and I3(x) = I3(b) ∩I1(x′). The following lemma holds in this case.
Lemma 7 If a̸ = b, and if y = ay′ and x = bx′, for E2 = Exp(Exp(I2, yb), xa) and E3 =
Exp(Exp(I3, xa), yb), denoting respectively by I24 and I34 the corresponding interpretations, we
have I24 = I34, that is:
Exp(Exp(Exp(I1, xa), yb), xa) = Exp(Exp(Exp(I1, yb), xa), yb).
Proof. Referring to Figure 2(d), we ﬁrst give the computations regarding I2, I21 and I24. In
each case the computations of the interpretations of a, x, b and y are shown.
• Interpretation I2 = Exp(I1, xa).
First, we have I2(a) = I1(a) ∪I1(x), due to expansion. Moreover, I2(b) = I1(b) and as I2(y) =
I2(a) ∩I2(y′), we obtain I2(y) = (I1(a) ∪I1(x)) ∩I1(y′). Since I1(y) = I1(a) ∩I1(y′), we have
I2(y) = I1(y)∪(I1(x)∩I1(y′)). Moreover, I2(x) = I2(b)∩I2(x′), and thus, I2(x) = I1(b)∩I1(x′) =
I1(x). Therefore I2 is deﬁned as shown below:
I2(a) = I1(a) ∪I1(x)
I2(x) = I1(x)
I2(b) = I1(b)
I2(y) = I1(y) ∪(I1(x) ∩I1(y′))
• Interpretation I21 = Exp(I2, yb).
Now, we have I21(b) = I2(b) ∪I2(y), due to expansion. It follows that I21(b) = I1(b) ∪I1(y) ∪
(I1(x) ∩I1(y′)). Moreover, I21(a) = I2(a), that is I21(a) = I1(a) ∪I1(x). As I21(x) = I21(b) ∩
I21(x′) and I21(x′) = I1(x′), we obtain
I21(x)
=
(I1(b) ∪I1(y) ∪(I1(x) ∩I1(y′))) ∩I1(x′)
=
(I1(b) ∩I1(x′)) ∪(I1(y) ∩I1(x′)) ∪(I1(x) ∩I1(y′) ∩I1(x′))
Considering that I1(b) ∩I1(x′) = I1(x) and that I1(x) ⊆I1(x′) (because x′ ⊑x), we obtain:
I21(x) = I1(x) ∪(I1(x′) ∩I1(y)) ∪(I1(x) ∩I1(y′)). Since (I1(x) ∩I1(y′)) ⊆I1(x) always holds,
we have: I21(x) = I1(x) ∪(I1(x′) ∩I1(y)).
On the other hand, I21(y) = I21(a) ∩I21(y′), and thus, I21(y) = I2(a) ∩I1(y′). Therefore,
I21(y) = (I1(a) ∪I1(x)) ∩I1(y′), which can be written as I21(y) = I1(y) ∪(I1(x) ∩I1(y′)). Hence
I21 is deﬁned as shown below:
I21(a) = I1(a) ∪I1(x)
I21(x) = I1(x) ∪(I1(x′) ∩I1(y))
I21(b) = I1(b) ∪I1(y) ∪(I1(x) ∩I1(y′))
I21(y) = I1(y) ∪(I1(x) ∩I1(y′))
• Interpretation I24 = Exp(I21, xa).
Here, we have I24(a) = I21(a) ∪I21(x), due to expansion. It follows that:
I24(a)
=
(I1(a) ∪I1(x)) ∪(I1(x) ∪(I1(x′) ∩I1(y)))
=
I1(a) ∪I1(x) ∪(I1(x′) ∩I1(y))
Moreover, I24(b) = I21(b), that is I24(b) = I1(b) ∪I1(y) ∪(I1(x) ∩I1(y′)). As I24(x) = I24(b) ∩
I24(x′) and I24(x′) = I1(x′), we have:
I24(x)
=
(I1(b) ∪I1(y) ∪(I1(x) ∩I1(y′))) ∩I1(x′)
=
(I1(b) ∩I1(x′)) ∪(I1(y) ∩I1(x′)) ∪(I1(x) ∩I1(y′) ∩I1(x′))
=
I1(x) ∪(I1(x′) ∩I1(y)) ∪(I1(x) ∩I1(y′))
(because I1(x) ⊆I1(x′) as x′ ⊑x)
=
I1(x) ∪(I1(x′) ∩I1(y)) (because (I1(x) ∩I1(y′)) ⊆I1(x))
37

---

As I24(y) = I24(a) ∩I24(y′), we obtain
I24(y)
=
(I1(a) ∪I1(x) ∪(I1(x′) ∩I1(y))) ∩I1(y′)
=
(I1(a) ∩I1(y′)) ∪(I1(x) ∩I1(y′)) ∪(I1(x′) ∩I1(y) ∩I1(y′))
=
I1(y) ∪(I1(x) ∩I1(y′)) ∪(I1(x′) ∩I1(y))
(because I1(y) ⊆I1(y′) as y′ ⊑y)
=
I1(y) ∪(I1(x) ∩I1(y′)) (because (I1(x′) ∩I1(y)) ⊆I1(y))
Hence I24 is deﬁned as shown below:
I24(a) = I1(a) ∪I1(x) ∪(I1(x′) ∩I1(y))
I24(x) = I1(x) ∪(I1(x′) ∩I1(y))
I24(b) = I1(b) ∪I1(y) ∪(I1(x) ∩I1(y′))
I24(y) = I1(y) ∪(I1(x) ∩I1(y′))
Referring again to Figure 2(d), we now turn to the computations regarding I3, I31 and I34. As
the computations are similar to those above, some details are skipped.
• Interpretation I3 = Exp(I1, yb).
Here, we have I3(b) = I1(b) ∪I1(y), due to expansion. Computations similar to those in the case
of I2 show that I3 is deﬁned as shown below:
I3(a) = I1(a)
I3(x) = I1(x) ∪(I1(x′) ∩I1(y))
I3(b) = I1(b) ∪I1(y)
I3(y) = I1(y)
• Interpretation I31 = Exp(I3, xa).
Here, we have I31(a) = I3(a) ∪I3(x), due to expansion. Computations similar to those for I24
show that I31 is deﬁned as shown below:
I31(a) = I1(a) ∪I1(x) ∪(I1(x′) ∩I1(y))
I31(x) = I1(x) ∪(I1(x′) ∩I1(y))
I31(b) = I1(b) ∪I1(y)
I31(y) = I1(y) ∪(I1(x) ∩I1(y′))
• Interpretation I34 = Exp(I31, yb).
Here, we have I34(b) = I31(b) ∪I31(y), due to expansion. It follows that computations similar to
those for I24 show that I34 is deﬁned as shown below:
I34(a) = I1(a) ∪I1(x) ∪(I1(x′) ∩I1(y))
I34(x) = I1(x) ∪(I1(x′) ∩I1(y))
I34(b) = I1(b) ∪I1(y) ∪(I1(x) ∩I1(y′))
I34(y) = I1(y) ∪(I1(x) ∩I1(y′))
It thus turns out that we indeed have I24 = I34, and the proof is complete.
2
The last case to be addressed is when y = ay′ and x̸ = bx′ or when x = bx′ and y̸ = ay′. We
only consider the former case since the latter can be dealt with in a similar way. Moreover,
as shown in Figure 2(c), this case is in fact a simpliﬁcation of the case of Lemma 7 where the
terms involving x′ are omitted. We thus omit the proof and just state that is this case again
I24 = I34. It can be checked that in case of Figure 2(c) (that is y = ay′ and x̸ = bx′), we obtain
the following interpretations:
I24(a) = I34(a) = I1(a) ∪I1(x)
I24(x) = I34(x) = I1(x)
I24(b) = I34(b) = I1(b) ∪I1(y) ∪(I1(x) ∩I1(y′))
I24(y) = I34(y) = I1(y) ∪(I1(x) ∩I1(y′))
We therefore state the following basic result regarding expansion:
The process of expanding an interpretation I with respect to a set FD of functional depen-
dencies satisﬁes the Church-Rosser property.
38

---

Hence, given T and FD, the process of expanding Ib until a ﬁxed point is reached does not
depend on the order the expansions are processed. Thus, the limit is indeed unique.
B
Proof of Lemma 4
Lemma 4 Let T be a table over universe U. Then the following holds:
1. Algorithm 1 applied to T always terminates.
2. For every m-tuple s in MT , I∗(s)̸ = ∅holds if and only if there exists σ in Σ∗such that
s ⊑σ.
3. Inc(T ) = ∅if and only if fail = false.
4. For every σ in Σ∗and all t and t′ in tuples(σ), I∗(t) = I∗(t′).
Proof. 1. The computation of Σ∗terminates because (i) the sets under construction for
a given attribute A are all bounded by the ﬁnite set adom(A), and (ii) the construction is
monotonous, in the sense that if Σk and Σk+1 are two consecutive states, for every σ in Σk+1,
there exists σ′ in Σk such that σ′ ⊑σ.
2. Given s in MT , we ﬁrst show that I∗(s) is nonempty if there exists σ in Σ∗such that s ⊑σ.
The proof is conducted by induction on the steps in the runs of the loop line 4. We show that
if (Σk)k≥0 denotes the sequence of the states of Σ∗during the computation, for every σ in Σk,
I∗(σ)̸ = ∅. We ﬁrst note in this respect that since Σ0 = T, for every σ in Σ0, we have I∗(σ)̸ = ∅.
Assuming now that for k ≥0, for every σ ∈Σk, I∗(σ)̸ = ∅, we prove the result for every
σ in Σk+1. Let σ in Σk+1 but not in Σk. Then σ occurs in Σk+1 because there exist X →A
in FD, σ1 and σ2 in Σk such that for every B in X, σ1.B ∩σ2.B̸ = ∅. Let σ′
1 = σ1 ⊔σ2(A)
and σ′
2 = σ2 ⊔σ1(A). Then, either σ = σ′
1 and σ′
1̸ = σ1 or σ = σ′
2 and σ′
2̸ = σ2. The two
cases being similar, we just consider the ﬁrst one, that is σ = σ′
1 and σ′
1̸ = σ1, which implies
that σ2(A)̸ = ∅and σ2(A)̸ ⊑σ1. By our induction hypothesis, we have I∗(σ2)̸ = ∅and thus
denoting by x an X-tuple occurring in tuples(σ1 ⊓σ2), we have I∗(x) ∩I∗(σ2(A))̸ = ∅. Since I∗
satisﬁes X →A, I∗(x) ⊆I∗(σ2(A)). As x ⊑σ1, I∗(σ1) ⊆I∗(x) and thus, I∗(σ1) ⊆I∗(σ2(A)).
Therefore, I∗(σ) = I∗(σ1) ∩I∗(σ2(A)) = I∗(σ1). As by our induction hypothesis, I∗(σ1)̸ = ∅, we
obtain that I∗(σ)̸ = ∅. Therefore, it holds that for every k ≥0, I∗(σ)̸ = ∅for every σ in Σk, and
so, it holds that I∗(σ)̸ = ∅for every σ in Σ∗. Thus, if s satisﬁes that there exists σ in Σ∗such
that s ⊑σ, we have I∗(σ) ⊆I∗(s). Hence I∗(s)̸ = ∅, and this part of the proof is complete.
Conversely, we show that for every s, if I∗(s)̸ = ∅then there exists σ in Σ∗such that s ⊑σ.
The proof is done by induction on the construction of I∗.
By deﬁnition of I0 = Ib, if I0(s)̸ = ∅then s is a sub-tuple of a tuple t in T, i.e., s ⊑t holds.
Since Σ0 = T, there exists σ in Σ0 such that t ⊑σ. By monotonicity of the construction of Σ∗
(i.e., for every σk+1 in Σk+1 there exists σk in Σk such that σk ⊑σk+1), there exists σ∗in Σ∗
such that σ ⊑σ∗, which shows that t ⊑σ∗, thus that s ⊑σ∗.
Now, assuming that for every k ≥0 and every s, if Ik(s)̸ = ∅then there exists σ in Σ∗such
that s ⊑σ, we prove that this result holds for Ik+1.
Let s be such that Ik(s) = ∅and Ik+1(s)̸ = ∅.
For every a in AD we have Ik+1(a) =
Ik(a) ∪Ik(x) if x and a are the tuples involved in Exp(Ik, xa) and Ik+1(a) = Ik(a) otherwise.
Since Ik+1(s)̸ = Ik(s) and since a is the only symbol for which Ik has changed, it must be that
a ⊑s. Therefore, writing s as s′ ⊔a, we have Ik+1(s) = Ik+1(s′)∩Ik+1(a) and Ik+1(s′) = Ik(s′).
It follows that Ik+1(s) = Ik(s′)∩(Ik(a)∪Ik(x)), thus that Ik+1(s) = (Ik(s′)∩(Ik(a))∪(Ik(s′)∩
Ik(x)), that is Ik+1(s) = Ik(s) ∪(Ik(s′) ∩Ik(x)). As Ik+1(s)̸ = ∅and Ik(s) = ∅, we have
39

---

Ik(s′) ∩Ik(x)̸ = ∅, in which case our induction hypothesis entails that there exists σ in Σ∗such
that (s′ ⊔x) ⊑σ. Since by deﬁnition of expansion, we also have Ik(x) ∩Ik(a)̸ = ∅, Σ∗contains
an m-tuple σ′ such that xa ⊑σ′. In this case, Algorithm 1 shows that there exists σ∗in Σ∗such
that (s′ ⊔a) ⊑σ∗, that is s ⊑σ∗. This part of the proof is therefore complete.
3. If the returned value for fail is false, the previous item shows that there exist X →A in FD,
x in T (X) and a and a′ in adom(A) such that I∗(a) ∩I∗(a′)̸ = ∅. Therefore in this case, Inc(T )
is not empty. Conversely, if Inc(T )̸ = ∅, for every t in Inc(T ), there exist A in U and a and a′
in adom(A) such that I∗(a) ∩I∗(a′)̸ = ∅, and the previous item shows that there exists σ in Σ∗
such that (aa′) ⊑σ. Hence, during the execution of Algorithm 1, the value of fail must have
been turned to true line 11.
4. The proof is by induction on the construction of Σ∗. As all m-tuples in Σ0 can be seen as
tuples, for every σ in Σ0, tuples(σ) consists of one tuple. The result thus trivially holds in this
case. Now assume that the result holds for Σk, and let σ be in Σk+1 obtained by steps lines 16-20
of Algorithm 1. Thus there exist σ′ in Σ∗, X →A in FD, x0 in T (X) and a0 in adom(A) such
that in Σk, x0 ∈tuples(σ(X)) ∩tuples(σ′(X)), a0 is in tuples(σ′(A)) \ tuples(σ(A)), and in Σk+1,
σ(A) becomes σ1(A) such that a0 ∈tuples(σ1(A)).
Let t1 be in tuples(σ1) such that t1.A = a0, and let x denote t1.X. Then, t1 is not in tuples(σ)
(because a0̸ ∈tuples(σ(A))), but tuples(σ) contains a tuple t such that t.X = x and a tuple t′
such that t′.X = x0. Thus tuples(σ1) contains t1 such that t1.XA = xa0 and a tuple t′
1 such that
t′
1.XA = x0a0.
On the other hand, the fact that x0a0 occurs in tuples(σ′) implies that I∗(x0a0)̸ = ∅, thus
that I∗(x0) ⊆I∗(a0). Hence, I∗(x0a0) = I∗(x0). We now argue that I∗(t′
1) = I∗(t′). Indeed, if
σ(A) = ∅, then t′
1 can be written as t′a0 in which case I∗(t′
1) = I∗(t′) ∩I∗(a0) holds. Since it
also holds that I∗(t′) ⊆I∗(x0) ⊆I∗(a0), we have I∗(t′)∩I∗(a0) = I∗(t′). Otherwise, if σ(A)̸ = ∅
then t′ is written as q′a′ and thus t′
1 is written as q′a0 (a′ has been replaced by a0 to obtain t′
1
from t′). In this case, I∗(t′
1) = I∗(q′) = I∗(t′).
As t and t′ are both in tuples(σ), by our induction hypothesis, in Σi we have I∗(t) = I∗(t′),
which implies that I∗(t) = I∗(t′
1) = I(t′). We therefore obtain that for every t1 in tuples(σ1),
there exists t in tuples(σ) such that I∗(t1) = I∗(t). As all tuples in t tuples(σ) have the same
I∗(t), all tuples t1 in tuples(σ1) have the same I∗(t1). The proof is therefore complete.
2
C
Proof of Proposition 5
Proposition 5
Let T be a non-redundant table over universe U, FD the set of associated
functional dependencies and Σ∗the non-redundant m-table as computed by Algorithm 1. Given
a query Q : select X from T [where Γ], and a tuple x in T (X):
1. x is in MSC ans(Q) if and only if
(a) for every σ in Σ(x), tuples(σ(X)) = {x},
(b) there exists σ in ΣQ(x) such that |tuples(σ)| = 1.
2. x is in SC ans(Q) if and only if
(a) for every σ in Σ(x), tuples(σ(X)) = {x},
(b) there exists s in Sat(Γ) ∩True(T ) such that for every σ in ΣQ(x), if s is in σ(sch(Γ))
then tuples(σ(sch(Γ)))) = {s}.
3. x is in C ans(Q) if and only if
40

---

(a) for every σ in Σ(x), tuples(σ(X)) = {x},
(b) there exists σ in ΣQ(x) such that tuples(σ(sch(Γ))) ⊆Sat(Γ).
4. x is in WC ans(Q) if and only if
(a) for every σ in Σ(x), tuples(σ(X)) = {x},
(b) ΣQ(x) is not empty.
Proof. In this proof, Q is assumed to involve a selection condition Γ, because the case where
no selection condition is involved is a simpliﬁcation, and thus, is omitted.
1. By Proposition 4(1) and (2), statement (a) in the proposition is equivalent to statement (1.a)
in Deﬁnition 6. Moreover, as Σ∗is assumed to be non-redundant, for every σ in Σ∗and every
t in tuples(σ), there exists no tuple t′ in True(T ) such that t < t′. Thus, by Proposition 4(2),
statement (b) in the proposition yields a tuple having the same properties as the tuple t in
statement (1.b) of Deﬁnition 6 (i.e., t is a maximal true and consistent tuple whose restriction
over sch(Γ) satisﬁes Γ). Therefore this part of the proof is complete.
2.
As above, by Proposition 4(1) and (2), statement (a) in the proposition is equivalent to
statement (2.a) in Deﬁnition 6. Moreover, statement (b) in the proposition yields a tuple t such
that t.X = x, t.sch(Γ) = s, which is in Sat(Γ). Moreover, Proposition 4(3) implies that this
tuple t is true and consistent, thus satisfying the statement (2.b) of Deﬁnition 6 (i.e., t is a true
and consistent tuple whose restriction over sch(Γ) satisﬁes Γ). Therefore this part of the proof
is complete.
3. Let us ﬁrst assume that x is in C ans(Q). As x is in Cons(T ) ∩True(T ), by Proposition 4,
Σ∗must contain at least one σ such that x ⊑σ and every such m-tuple must be such that
σ(X) = {x}. Hence Σ(x) is nonempty and the ﬁrst item in the proposition holds. Moreover, by
Deﬁnition 6, one of these m-tuples σ is also such that sch(Γ) ⊆sch(σ) and tuples(σ) contains
a tuple t of Cons(Γ, T ). By Deﬁnition 5, this implies that the following statement (*) holds:
t.sch(Γ) is in Sat(Γ) and for every s in Sat−(Γ), I∗(t) ∩I∗(s) = ∅. This in particular implies
that σ is in ΣQ(x), because t.(sch(Γ)) ⊑t ⊑σ holds.
As ΣQ(x) ⊆Σ(x), every σ in ΣQ(x) is such that σ(X) = {x}. Assume now that every σ
in ΣQ(x) is such that tuples(σ(sch(Γ))) contains q0 not in Sat(Γ). Then q0 is in Sat−(Γ) and
tuples(σ) contains a tuple t0 such that t0.sch(Γ) = q0. Thus we have two tuples t and t0 in
tuples(σ) such that t.X = t0.X = x, t.sch(Γ) ∈Sat(Γ) and t0.sch(Γ) ∈Sat−(Γ). Lemma 4(4)
implies that I∗(t) = I∗(t0) (because t and t0 are in tuples(σ)), and as I∗(t0) ⊆I∗(q0) (because
t0.sch(Γ) = q0), we have I∗(t0) ∩I∗(q0) = I∗(t0).
Thus I∗(t0) ∩I∗(q0)̸ = ∅, implying that
I∗(t) ∩I∗(q0)̸ = ∅, which is a contradiction with statement (*) above. We therefore have shown
that if x is in C ans(Q) then the items in the proposition hold.
Conversely, if the items in the proposition are satisﬁed, Proposition 4 implies that x is
in Cons(T ) ∩True(T ). Thus by Deﬁnition 5, we have to prove the existence of a tuple t in
Cons(Γ, T ) ∩True(T ) such that x ⊑t. Let σ be in ΣQ(x) as stated in item (3.b) of the propo-
sition, that is such that tuples(σ(sch(Γ))) ⊆Sat(Γ), and let t0 be in tuples(σ).
As t0 is in
True(T ), we have to show that t0 is in Cons(Γ, T ), that is that there exists q in Sat(Γ) such
that (i) q ⊑t0, and (ii) for every q′ in Sat−(Γ), I∗(t0) ∩I∗(q′) = ∅.
Since we know that
t0.sch(Γ) is in Sat(Γ), (i) holds for q = t0.sch(Γ). Regarding (ii), let q′
0 be in Sat−(Γ) such that
I∗(t0) ∩I∗(q′
0)̸ = ∅. As I∗(σ) = T
u∈tuples(σ) I∗(u), Lemma 4(4) implies that I∗(σ) = I∗(t0), and
thus that I∗(σ) ∩I∗(q′
0)̸ = ∅. Applying now Lemma 4(2), we obtain that Σ∗contains an m-tuple
σ′ involving all attribute values in σ or in q′
0. Since q′
0 is not in tuples(σ), we have σ′̸ = σ, and
thus σ < σ′ holds. This is a contradiction with our hypothesis that Σ∗contains no redundancy,
showing that t0 is in Cons(Γ, T ). This part of the proof is therefore complete.
41

---

4. As in cases (1) and (2) above, by Proposition 4(1) and (2), statement (4.a) in the proposition is
equivalent to statement (2.a) in Deﬁnition 6. Moreover, ΣQ(x)̸ = ∅is equivalent to the existence
of σ in Σ∗such that σ(X) = {x} and σ(sch(Γ)) contains a tuple s of Sat(Γ). Hence, ΣQ(x)̸ = ∅
is equivalent to the existence of a tuple t in True(T ) (due to Proposition 4(1)) such that t.X = x
and t.sch(Γ) is in Sat(Γ). The proof is therefore complete.
2
42

---

