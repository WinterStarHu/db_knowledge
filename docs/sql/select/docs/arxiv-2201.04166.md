# Degree Sequence Bound For Join Cardinality Estimation

> 来源: https://arxiv.org/pdf/2201.04166

Degree Sequence Bound For Join Cardinality
Estimation
Kyle Deeds ! 
University of Washington Seattle, WA, USA
Dan Suciu ! 
University of Washington Seattle, WA, USA
Magda Balazinska ! 
University of Washington Seattle, WA, USA
Walter Cai ! 
University of Washington Seattle, WA, USA
Abstract
Recent work has demonstrated the catastrophic eﬀects of poor cardinality estimates on query
processing time. In particular, underestimating query cardinality can result in overly optimistic
query plans which take orders of magnitude longer to complete than one generated with the true
cardinality. Cardinality bounding avoids this pitfall by computing a strict upper bound on the
query’s output size using statistics about the database such as table sizes and degrees, i.e. value
frequencies. In this paper, we extend this line of work by proving a novel bound called the Degree
Sequence Bound which takes into account the full degree sequences and the max tuple multiplicity.
This work focuses on the important class of Berge-Acyclic queries for which the Degree Sequence
Bound is tight. Further, we describe how to practically compute this bound using a functional
approximation of the true degree sequences and prove that even this functional form improves upon
previous bounds.
2012 ACM Subject Classiﬁcation Information systems →Query optimization; Information systems
→Query planning; Theory of computation →Database query processing and optimization (theory);
Theory of computation →Data modeling
Keywords and phrases Cardinality Estimation, Cardinality Bounding, Degree Bounds, Functional
Approximation, Query Planning, Berge-Acyclic Queries
Digital Object Identiﬁer 10.4230/LIPIcs.CVIT.2016.23
Funding This work is supported by National Science Foundation grants NSF IIS 1907997 and
NSF-BSF 2109922.
1
Introduction
The weakest link in a modern query processing engine is the cardinality estimator. There
are several major decisions where the system needs to estimate the size of a query’s output:
the optimizer uses the estimate to compute an eﬀective query plan; the scheduler needs the
estimate to determine how much memory to allocate for a hash table and to decide whether
to use a main-memory or an out-of-core algorithm; a distributed system needs the estimate
to decide how many servers to reserve for subsequent operations. Today’s systems estimate
the cardinality of a query by making several strong and unrealistic assumptions, such as
uniformity and independence. As a result, the estimates for multi-join queries commonly
have relative errors up to several orders of magnitude. An aggravating phenomenon is that
cardinality estimators consistently underestimate (this is a consequence of the independence
assumption), and this leads to wrong decisions for the most expensive queries [16, 3, 9].
A signiﬁcant amount of eﬀort has been invested in the last few years into using machine
learning for cardinality estimation [21, 23, 25, 28, 22, 17, 18], but this approach still faces
© CC-BY;
licensed under Creative Commons License CC-BY 4.0
42nd Conference on Very Important Topics (CVIT 2016).
Editors: John Q. Open and Joan R. Access; Article No. 23; pp. 23:1–23:49
Leibniz International Proceedings in Informatics
Schloss Dagstuhl – Leibniz-Zentrum für Informatik, Dagstuhl Publishing, Germany
arXiv:2201.04166v2  [cs.DB]  30 Mar 2022

---

23:2
Degree Sequence Bound For Join Cardinality Estimation
several formidable challenges, such as the need for large training sets, the long training time
of complex models, and the lack of guarantees about the resulting estimates.
Name
...
Alice
...
Alice
...
Bob
...
Carlos
...
Carlos
...
Carlos
...
David
...
Eseah
...
Eseah
...
Eseah
...
Eseah
...
Eseah
...
Vivek
...
Vivek
...
Vivek
...
Gael
...
Hans
...
Hans
...
John
...
Karl
...
Lee
...
0
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
7
8
9
10
Degree Sequence
Functional Representation
Compressed Representation
Figure 1 The degree sequence of Name. The
ﬁrst rank represents Eseah whose degree is 5, the
next two ranks are for Carlos and Vivek whose
degrees are 3. The degree sequence can be repres-
ented compactly using a staircase functions, and
even more compactly using lossy compression.
An alternative approach to estimating
the cardinality is to compute an upper bound
for the size of the query answer. This ap-
proach originated in the database theory
community, through the pioneering results
by Grohe and Marx [7] and Atserias, Grohe,
and Marx [1]. They described an elegant
formula, now called the AGM bound, that
gives a tight upper bound on the query res-
ult in terms of the cardinalities of the input
tables. This upper bound was improved by
the polymatroid bound, which takes into ac-
count both the cardinalities, and the degree
constraints and includes functional depend-
encies as a special case [6, 13, 15, 19]. In
principle, an upper bound could be used by a
query optimizer in lieu of a cardinality estim-
ator and, indeed, this idea was recently pur-
sued by the systems community, where the
upper bound appears under various names
such as bound sketch or pessimistic cardin-
ality estimator [3, 10]. In this paper, we will
call it a cardinality bound. As expected, a
cardinality bound prevents query optimizers from choosing disastrous plans for the most
expensive queries [3], however, their relative error is often much larger than that of other
methods [20, 5]. While the appeal of a guaranteed upper bound is undeniable, in practice
overly pessimistic bounds are unacceptable.
In this paper, we propose a new upper bound on the query size based on degree sequences.
By using a slightly larger memory footprint, this method has the potential to achieve much
higher accuracy than previous bounds. Given a relation R, an attribute X, and a value
u ∈ΠX(R), the degree of u is the number of tuples in R with u in the X attribute, formally
d(u) = |σX=u(R)|. The degree sequence of an attribute X in relation R is the sorted sequence
of all degrees for the values of that attribute, d(u1) ≥d(u2) ≥· · · ≥d(un). Going forward, we
drop any reference to values and instead refer to degrees by their index in this sequence,
also called their rank, i.e. d1 ≥· · · ≥dn.1 A degree sequence can easily be computed
oﬄine, and can be compressed eﬀectively, with a good space/accuracy tradeoﬀdue to its
monotonicity; see Fig. 1 for an illustration. Degree sequences oﬀer more information on the
database instance than the statistics used by previous upper bounds. For example, the AGM
bound uses only the cardinality of the relations, which is P
i di, while the extension to degree
constraints [15] uses the cardinality, P
i di, and the maximum degree, d1.
For this new bound we had to develop entirely new techniques over those used for the
AGM and the polymatroid bounds. Previous techniques are based on information theory. If
some relation R(X, Y ) has cardinality N, then any probability space over R has an entropy
1 Note that the degree sequence is very similar to a rank-frequency distribution in the probability literature
and has been extensively used in graph analysis [2, 8].

---

K. Deeds, D. Suciu, M. Balazinska, W. Cai
23:3
that satisﬁes H(XY ) ≤log N; if the degree sequence of the attribute X is d1 ≥d2 ≥. . ., then
H(Y |X) ≤log d1. Both the AGM and the polymatroid bound start from such constraints
on the entropy. Unfortunately, these constraints do not extend to degree sequences, because
H is ignorant of d2, d3, . . . Information theory gives us only three degrees of freedom, namely
H(XY ), H(X), H(Y ), while the degree sequence has an arbitrary number of degrees of
freedom. Rather than using information theory, our new framework models relations as
tensors, and formulates the upper bound as a linear optimization problem. This framework
is restricted to Berge-acyclic, fully conjunctive queries [4] (reviewed in Sec. 2); throughout
the paper we will assume that queries are in this class. As we explain in appendix A.1 these
are the most common queries found in applications.
The Worst-Case Instance Our main result (Theorems 3.2 and 4.1) is a tight cardinality
bound given the degree sequences of all relations. This bound is obtained by evaluating
the query on a worst-case instance that satisﬁes those degree constraints.2 Intuitively, each
relation of the worst-case instance is obtained by matching the highest degree values in
the diﬀerent columns, and the same principle is applied across relations. For example,
consider the join R(X, . . .) ⋊⋉S(X, . . .), where the degree sequences of R.X and S.X are
a1 ≥a2 ≥· · · and b1 ≥b2 ≥· · · respectively. The true cardinality of the join is P
i aibτ(i) for
some unknown permutation τ , while the maximum cardinality is3 P
i aibi, and is obtained
when the highest degree values match. Our degree sequence bound holds even when the
input relations are allowed to be bags. Furthermore, we prove (Theorem 4.6) that this bound
is always below the AGM and polymatroid bounds, although the latter restrict the relations
to be sets. To prove this we had to develop a new, explicit formula for the polymatroid
bound for Berge-acyclic queries, which is of independent interest (Theorem 4.3).
Compact Representation A full degree sequence is about as large as the relation
instance, while cardinality estimators need to run in sub-linear time. Fortunately, a degree
sequence can be represented compactly using piece-wise constant function, called a staircase
function, as illustrated in Fig. 1. Our next result, Theorem 5.2, is an algorithm for the degree
sequence bound that runs in quasi-linear time (i.e. linear plus a logarithmic factor) in the
size of the representation, independent of the size of the instance. The algorithm makes some
rounding errors (Lemma 5.1), hence its output may be slightly larger than the exact bound,
however we prove that it is still lower than the AGM and polymatroid bounds (Theorem 5.5).
The algorithm can be used in conjunction with a compressed representation of the degree
sequence. By using few buckets and upper-bounding the degree sequence one can trade oﬀ
the memory size and estimation time for accuracy. At one extreme, we could upper bound
the entire sequence using a single bucket with the constant d1, at the other extreme we could
keep the complete sequence. Neither the AGM bound nor the polymatroid bound have this
tradeoﬀability.
Max Tuple Multiplicity Despite using more information than previous upper bounds,
our bound can still be overly pessimistic, because it needs to match the most frequent
elements in all attributes. For example, suppose a relation has two attributes whose highest
degrees are a1 and b1 respectively. Its worst-case instance is a bag and must include some
tuple that occurs min(a1, b1) times. Usually, a1 and b1 are large, since they represent the
frequencies of the worst heavy hitters in the two columns, but in practice they rarely occur
together min(a1, b1) times. To avoid such worst-case matchings, we use one additional piece
2 In graph theory, the problem of computing a graph satisfying a given degree sequence is called the
realization problem.
3 For example, if a1 ≥a2, b1 ≥b2, then a1b1 + a2b2 ≥a1b2 + a2b1.
CVIT 2016

---

23:4
Degree Sequence Bound For Join Cardinality Estimation
of information on each base table: the max multiplicity over all tuples, denoted B. Usually,
B is signiﬁcantly smaller than the largest degrees, and, by imposing it as an additional
constraint, we can signiﬁcantly improve the query’s upper bound; in particular, when B = 1
then the relation is restricted to be a set. Our main results in Theorems 3.2 and 4.1 extend
to max tuple multiplicities, but in some unexpected ways. The worst-case relation, while
still tight, is not a conventional relation: it may have tuples that occur more than B times,
and, when the relation has 3 or more attributes it may even have tuples with negative
multiplicities. Nevertheless, these rather unconventional worst-case relations provide an even
better degree sequence bound than by ignoring B.
▶Example 1.1. To give a taste of our degree-sequence bound, consider the full conjunctive
query Q(· · · ) = R(X, · · · ) ⋊⋉S(X, Y, · · · ) ⋊⋉T(Y, · · · ), where we omit showing attributes
that appear in only one of the relations. Alternatively, we can write Q(X, Y ) = R(X) ⋊⋉
S(X, Y ) ⋊⋉T(Y ) where R, S, T are bags rather than sets. Assume the following degree
sequences:
d(R.X) = (3, 2, 2)
d(T.Y ) = (2, 1, 1, 1)
d(S.X) = (5, 1)
d(S.Y ) = (3, 2, 1)
(1)
The AGM bound uses only the cardinalities, which are:
|R| = 7
|S| = 6
|T| = 5
The AGM bound4 is |R| · |S| · |T| = 210. The extension to degree constraints in [15] uses in
addition the maximum degrees:
deg(R.X) = 3
deg(S.X) = 5
deg(S.Y ) = 3
deg(T.Y ) = 2
and the bound is the minimum between the AGM bound and the following quantities:
|R| · deg(S.X) · deg(T.Y ) = 7 · 5 · 2 = 70
deg(R.X) · |S| · deg(T.Y ) = 3 · 6 · 2 = 36
deg(R.X) · deg(S.Y ) · |T| = 3 · 3 · 5 = 45
Thus, the degree-constraint bound is improved to 36.
Our new bound is given by the answer to the query on the worst-case instance of the
relations R, S, T, shown here together with their multiplicities (recall that they are bags):
R =
a
3
b
2
c
2
,
S =
a
u
3
a
v
2
b
w
1
,
T =
u
2
v
1
w
1
z
1
,
The three relations have the required degree sequences, for example S.X consists of 5 a’s
and 1 b, thus has degree sequence (5, 1). Notice the matching principle: we assumed that the
most frequent element in R.X and S.X are the same value a, and that the most frequent
values in S.X and in S.Y occur together. On this instance, we compute the query and obtain
the answer Q.
Q =
a
u
3 · 3 · 2 = 18
a
v
3 · 2 · 1 = 6
b
w
2 · 1 · 1 = 2
S′ =
a
u
2
a
v
2
a
w
1
b
u
1
4 Recall that each of the three relations has private variables, e.g. R(X, U), S(X, Y, V, W), T(Y, Z). The
only fractional edge cover is 1, 1, 1.

---

K. Deeds, D. Suciu, M. Balazinska, W. Cai
23:5
The upper bound is the size of the answer on this instance, which is 18 + 6 + 2 = 26, and
it improves over 36. Here, the improvement is relatively minor, but this is a consequence
of the short example. In practice, degree sequences often have a long tail, i.e. with a few
large leading degrees d1, d2, . . . followed by very many small degrees dm, dm+1, . . . , dn (with
a large n). In that case the improvements of the new bound can be very signiﬁcant.
Suppose now that we have one additional information about S: every tuple occurs at
most B = 2 times. Then we need to reduce the multiplicity of (a, u), and the new worst-case
instance, denoted S′, is the following relation which decreases the cardinality bound to 25.
2
Problem Statement
Tensors In this paper, it is convenient to deﬁne tensors using a named perspective, where each
dimension is associated with a variable. We write variables with capital letters X, Y, . . . and
sets of variables with boldface, X, Y , . . . We assume that each variable X has an associated
ﬁnite domain DX
def
= [nX] for some number nX ≥1. For any set of variables X we denote
by DX
def
= Q
Z∈X DZ. We use lower case for values, e.g. z ∈DZ and boldface for tuples, e.g.
x ∈DX. An X-tensor, or simply a tensor when X is clear from the context, is M ∈RDX.
We say that M has |X| dimensions. Given two X-tensors M, N, we write M ≤N for
the component-wise order (Mx ≤Nx, for all x). If X, Y are two sets of variables, then we
denote their union by XY . If, furthermore, X, Y are disjoint, and x ∈DX, y ∈DY , then
we denote by xy ∈DXY the concatenation of the two tuples.
▶Deﬁnition 2.1. Let M, N be an X-tensor, and a Y -tensor respectively. Their tensor
product is the following XY -tensor:
∀z ∈DXY :
(M ⊗N)z
def
=MπX(z) · NπY (z)
(2)
If X, Y are disjoint and M is an XY -tensor then we deﬁne its X-summation to be the
following Y -tensor:
∀y ∈DY :
(SUMX(M))y
def
=
X
x∈DX
Mxy
(3)
If M, N are XY and Y Z tensors, where X, Y , Z are disjoint sets of variables, then their
dot product is the XZ-tensor:
∀x ∈DX, z ∈DZ :
(M · N)xz
def
=SUMY (M ⊗N)xz =
X
y∈DY
MxyNyz
(4)
In other words, in this paper we use ⊗like a natural join. For example, if M is an
IJ-tensor (i.e. a matrix) and N is an KL-tensor, then M ⊗N is the Kronecker product;
if P is an IJ-tensor (like M) then M ⊗P is the element-wise product. The dot product
sums out the common variables, for example if a is a J-tensor, then M · a is the standard
matrix-vector multiplication, and its result is an I-tensor. The following is easily veriﬁed. If
M is an X-tensor, N is an Y -tensor and X, Y are disjoint sets of variables, then:
∀X0 ⊆X, ∀Y0 ⊆Y :
SUMX0Y0(M ⊗N) =SUMX0(M) ⊗SUMY0(N)
(5)
Permutations A permutation on D = [n] is a bijective function σ : D →D; the set of
permutations on D is denoted SD, or simply Sn. If D = D1 × · · · × Dk then we denote by
CVIT 2016

---

23:6
Degree Sequence Bound For Join Cardinality Estimation
SD
def
= SD1 × · · · × SDk. Given an X-tensor M ∈RDX and permutations σ ∈SDX, the
σ-permuted X-tensor is M ◦σ ∈RDX:
∀x ∈DX :
(M ◦σ)x
def
=Mσ(x)
Sums are invariant under permutations, for example if a, b ∈RDZ are Z-vectors and σ ∈SDZ,
then (a ◦σ) · (b ◦σ) = a · b, because P
i∈DZ aσ(i)bσ(i) = P
i∈DZ aibi.
Queries A full conjunctive query Q is:
Q(X) = ⋊⋉R∈R R(XR)
(6)
where R
def
= R(Q) denotes the set of its relations, X is a set of variables, and XR ⊆X
for each relation R ∈R. The incidence graph of Q is the following bipartite graph: T
def
=
(R∪X, E
def
= {(R, Z) | Z ∈XR}). It can be shown that Q is Berge-acyclic [4] iﬀits incidence
graph is an undirected tree (see appendix A.1). Unless otherwise stated, all queries in this
paper are assumed to be full, Berge-acyclic conjunctive queries. We use bag semantics for
query evaluation, and represent an instance of a relation R ∈R by an XR-tensor, M (R),
where M (R)
t
is deﬁned to be the multiplicity of the tuple t ∈DXR in the bag R. The number
of tuples in the answer to Q is:
|Q| = SUMX
 O
R∈R
M (R)
!
(7)
▶Example 2.2. Consider the following query:
Q(X, Y, Z, U, V, W) =R(X, Y ) ⋊⋉S(Y, Z, U) ⋊⋉T(U, V ) ⋊⋉K(Y, W)
Its incidence graph is T = ({R, . . . , K} ∪{X, . . . , W}, {(R, X), (R, Y ), (S, Y ), . . . , (K, W)})
and is an undirected tree. An instance of R(X, Y ) is represented by a matrix M (R) ∈
RDX×DY , where M (R)
xy
= the number of times the tuple (x, y) occurs in R. Similarly, S is
represented by a tensor M (S) ∈RDY ×DZ×DU . The size of the query’s output is:
|Q| =
X
x,y,z,u,v,w
M (R)
xy M (S)
yzuM (T )
uv M (K)
yw
Degree Sequences We denote by R+
def
= {x | x ∈R, x ≥0} and we say that a vector
f ∈R[n]
+ is non-increasing if fr−1 ≥fr for r = 2, n.
▶Deﬁnition 2.3. Fix a set of variables X, with domains DZ, Z ∈X. A degree sequence
associated with the dimension Z ∈X is a non-increasing vector f (Z) ∈RDZ
+ . We call the
index r the rank, and f (Z)
r
the degree at rank r. An X-tensor M is consistent w.r.t. f (Z) if:
SUMX−{Z}(M) ≤f (Z)
(8)
M is consistent with a tuple of degree sequences f (X) def
= (f (Z))Z∈X, if it is consistent with
every f (Z). Furthermore, given B ∈R+ ∪{∞}, called the max tuple multiplicity, we say
that M is consistent w.r.t. B if Mt ≤B for all t ∈DX. We denote:
Mf (X),B
def
={M ∈RDX | M is consistent with f (X), B}
M+
f (X),B
def
={M ∈RDX
+
| M is non-negative and consistent with f (X), B}
(9)

---

K. Deeds, D. Suciu, M. Balazinska, W. Cai
23:7
For a simple illustration consider two degree sequences f ∈R[m], g ∈R[n]. Mf,g,∞is the
set of matrices M whose row-sums and column-sums are ≤f and ≤g respectively; M+
f,g,∞
is the subset of non-negative matrices; M+
f,g,B is the subset of matrices that also satisfy
Mij ≤B, ∀i, j.
Problem Statement Fix a query Q. For each relation R, we are given a set of degree
sequences f (R,XR) def
=
 f (R,Z)
Z∈XR, and a tuple multiplicity B(R) ∈R+ ∪{∞}. We are
asked to ﬁnd the maximum size of Q over all database instances consistent with all degree
sequences and tuple multiplicities. To do this, we represent a relation instance R by an
unknown tensor M (R) ∈M+
f (R,XR),B(R) and an unknown set of permutations σ(R) ∈SDXR ,
and solve the following problem:
▶Problem 1 (Degree Sequence Bound). Solve the following optimization problem:
Maximize: |Q| = SUMX
 O
R∈R
(M (R) ◦σ(R))
!
(10)
Where: ∀R ∈R, σ(R) ∈SDXR , M (R) ∈M+
f (R,XR),B(R)
This is a non-linear optimization problem: while the set M+ deﬁned in Eq. (9) is a set
of linear constraints, the objective (10) is non-linear. In the rest of the paper we describe an
explicit formula for the degree sequence bound, which is optimal (i.e. tight) when B(R) = ∞,
for all R, and is optimal in a weaker sense in general.
▶Example 2.4. Continuing Example 1.1, the four degree sequences in (1) correspond to the
variables in each relation R.X, S.X, S.Y , and T.Y . Since S.X has a shorter degree sequence
than R.X, we pad it with a 0, so it becomes d(S.X) = (5, 1, 0); similarly for d(S.Y ). Instead
of values c, b, a, we use indices 1, 2, 3, similarly u, v, w, z becomes 1, 2, 3, 4. For example,
S =
3
1
3
3
2
2
2
3
1
is isomorphic to the instance in Example 1.1. It is represented by M ◦(σ, τ)
where the matrix M =
 
3
2
0
0
0
0
1
0
0
0
0
0
!
, (its row-sums are 5, 1, 0 and column-sums are 3, 2, 1, 0,
as required) and the permutations are, in two-line notation, σ
def
=
1
2
3
3
2
1

and τ
def
= the
identity. Similarly, the relations R, T, are represented by vectors a, b and permutations θ, ρ.
The bound of Q is the maximum value of P
i=1,3
P
j=1,4 Mσ(i)τ(j)aθ(i)bρ(j), where M, a, b
are consistent with the given degree sequences, and σ, τ, θ, ρ are permutations. This is a
special case of Eq. (10).
3
The Star Query
We start by computing the degree sequence bound for a star query, which is deﬁned as:
Qstar =S(X1, . . . , Xd) ⋊⋉R(1)(X1) ⋊⋉· · · ⋊⋉R(d)(Xd)
(11)
Assume that the domain of each variable Xp is [np] for some np > 0, and denote by
[n]
def
= [n1] × · · · × [nd]. Later, in Sec. 4, we will use the bound for Qstar as a building block
to compute the degree sequence bound of a general query Q. There, S will be one of the
relations of the query, for which we know the degree sequences f (Xp) ∈R[np]
+ , p = 1, . . . , d
and tuple bound B, while the unary relations R(1), . . . , R(d) will be results of subqueries,
which are unknown. The instance of each R(p) is given by an unknown vector a(p) ∈R[np]
+ ,
CVIT 2016

---

23:8
Degree Sequence Bound For Join Cardinality Estimation
which we can assume w.l.o.g. to be non-increasing, by permuting the domain of Xp in both
S and in R(p). Therefore, S will be represented by M ◦σ, where M ∈M+
f (X),B is some
tensor and σ some permutation, and the size of Qstar is:
|Qstar| =
X
(i1,...,id)∈[n]
(M ◦σ)i1···id · a(X1)
i1
· · · a(Xd)
id
(12)
Equivalently: |Qstar| = SUMX

(M ◦σ) ⊗N
p a(Xp)
= (M ◦σ) · a(X1) · · · a(Xd).
Our goal is to ﬁnd the unknown M ◦σ for which |Qstar| is maximized, no matter what
the unary relations are. It turns out that σ can always be chosen the identity permutation,
thus it remains to ﬁnd the optimal M, which we denote by C. This justiﬁes:
▶Problem 2 (Worst-Case Tensor). Fix f (X), B. Find a tensor C ∈Mf (X),∞such that, for
all σ ∈S[n], M ∈M+
f (X),B, and all non-increasing vectors a(X1) ∈R[n1]
+ , . . . , a(Xd) ∈R[nd]
+
:
(M ◦σ) · a(X1) · · · a(Xd) ≤C · a(X1) · · · a(Xd)
(13)
In the rest of this section we describe the solution C. If all entries in C are ≥0 and ≤B,
then C ∈M+
f (X),B and, by setting M
def
= C and σ
def
= the identity permutations, the relation
S represented by M ◦σ maximizes |Qstar|, achieving our goal. But, somewhat surprisingly,
we found that sometimes this worst-case C has entries > B or < 0, yet it still achieves our
goal of a tight upper bound for |Qstar|. This is why we allow C ∈Mf (X),∞.
Let ∆Z denote the discrete derivative of a X-tensor w.r.t. a variable Z ∈X, and ΣZ
denote the discrete integral. Formally, if a ∈R[n] is an Z-vector, then, setting a0
def
= 0:
∀i ∈[n] :
(∆Za)i
def
=ai −ai−1
(ΣZa)i =
X
j=1,i
aj
(14)
Notice that:
ΣZ(∆Za) =∆Z(ΣZa) = a
SUMZ(∆Za) = an
(15)
The subscript in ∆, Σ indicates on which variable they act. For example, if M is an XY Z-
tensor, then (∆Y M)xyz
def
= Mxyz −Mx(y−1)z. One should think of the three operators
∆X, ΣX, SUMX as analogous to the continuous operators d···
dx ,
R
· · · dx,
R n
0 · · · dx.
▶Deﬁnition 3.1. The value tensor, V f (X),B ∈R[n]
+ , is deﬁned by the following linear
optimization problem:
∀m ∈[n] :
V f (X),B
m
def
= Maximize:
X
s≤m
Ms
(16)
Where: M ∈M+
f (X),B
The worst-case tensor, Cf (X),B ∈R[n], is deﬁned as:
Cf (X),B def
=∆X1 · · · ∆XdV f (X),B
(17)
We will drop the superscripts when clear from the context, and write simply V , C. Our
main result in this section is:
▶Theorem 3.2. Let f (X), B be given as above, and let V , C deﬁned by (16)-(17). Then:

---

K. Deeds, D. Suciu, M. Balazinska, W. Cai
23:9
1. C is a solution to Problem 2, i.e. C ∈Mf (X),∞and it satisﬁes Eq. (13). Furthermore,
it is tight in the following sense: there exists a tensor M ∈M+
f (X),B and non-increasing
vectors a(p) ∈R[np]
+
, p = 1, d, such that inequality (13) (with σ the identity) is an equality.
2. If there exists any solution C′ ∈M+
f (X),B to Problem 2, then C′ = C.
3. When the number of dimensions is d = 2 then C is integral and non-negative. If d ≥3,
C may have negative entries.
4. If B < ∞, then C may not be consistent with B, even if d = 2.
5. For any non-increasing vectors a(Xp) ∈R[np]
+ , p = 2, d, the vector C · a(X2) · · · a(Xd) is
in R[n1]
+
and non-increasing.
6. Assume B = ∞. Then the following holds:
∀m ∈[n] :
Vm = min

F (X1)
m1
, . . . , F (Xd)
md

(18)
where F (Xp)
r
def
= P
j≤r f (Xp)
j
is the CDF associated to the PDF f (Xp), for p = 1, d.
Moreover, C can be computed by Algorithm 1, which runs in time O(P
p np). This further
implies that C ≥0, in other words C ∈M+
f (X),∞.
Algorithm 1 Eﬃcient construction of C when B = ∞
∀p = 1, d : sp ←1;
C = 0;
while ∀p : sp < np do
pmin ←arg minp(f (Xp)
sp
)
dmin ←minp(f (Xp)
sp
)
Cs1,...,sd ←dmin
∀p = 1, d : f (Xp)
sp
←f (Xp)
sp
−dmin
spmin ←spmin + 1
end while
return C
In a nutshell, the theorem asserts that the tensor C deﬁned in (17) is the optimal solution
to Problem 2; this is stated in item 1. Somewhat surprisingly, C may be inconsistent w.r.t.
B, and may even be negative. When that happens, then, by item 2, no consistent solution
exists to Problem 2, hence we have to make do with C. In that case C may not represent
a traditional bag S, for example if it has entries < 0. However, this will not be a problem
for computing the degree sequence bound in Sec. 4, because all we need is to compute the
product C · a(X2) · · · a(Xd), which we need to be non-negative, and non-increasing: this is
guaranteed by item 5. The last item gives more insight into V and, by extension, into
C. Recall that Vm, deﬁned by (16), is the largest possible sum of values of a consistent
m1 × m2 × · · · × md tensor M. Since the sum in each hyperplane X1 = r of M is ≤f (X1)
r
,
it follows that P
s≤m Ms ≤P
r=1,m1 f (X1)
r
def
= F (X1)
m1
. Repeating this argument for each
dimension Xp implies that Vm ≤minp=1,d(F (Xp)
mp
). Item 6 states that this becomes an
equality, when B = ∞.
▶Example 3.3. Suppose that we want to maximize aT · M · b, where M is a 3 × 4 matrix
with degree sequences f = (6, 3, 1) and g = (4, 3, 2, 1); assume B = ∞. The vectors a, b are
non-negative and non-increasing, but otherwise unknown. The theorem asserts that this
product is maximized by the worst-case matrix C. We show here the matrices C and V
deﬁned by (16) and (17), together with degree sequences f, g next to C, and the cumulative
CVIT 2016

---

23:10
Degree Sequence Bound For Join Cardinality Estimation
sequences F = Σf, G = Σg next to V :
C =


4
3
2
1
6
4
2
0
0
3
0
1
2
0
1
0
0
0
1


V =


4
7
9
10
6
4
6
6
6
9
4
7
9
9
10
4
7
9
10


We can check that Vm1m2 = min(Fm1, Gm2); for example V31 = min(10, 4) = 4. The
worst-case matrix C is deﬁned as the second discrete derivative of V , more precisely
Cm1m2 = Vm1m2 −Vm1−1,m2 −Vm1,m2−1 + Vm1−1,m2−1. Alternatively, C can be computed
greedily, using Algorithm 1: start with C11 ←min(f1, g1) = 4, decrease both f1, g1 by 4,
set the rest of column 1 to 0 (because now g1 = 0) and continue with C12, etc. Another
important property, which we will prove below in the Appendix (Eq. (35)), is that, for all
m1, m2, P
i≤m1,j≤m2 Cij = Vm1m2; for example P
i≤2,j≤3 Cij = 4 + 2 + 1 + 2 = 9 = V23.
While the proof of Theorem 3.2 provides interesting insight into the structure of the
degree sequence bound, it is not necessary for understanding the remainder of the paper and
requires the introduction of additional notation and machinery. Therefore, for the sake of
space and clarity, we omit it from the main text and instead include a proof of each item in
the appendix section A.2.
4
The Berge-Acyclic Query
We now turn to the general problem 1. Fix a Berge-acyclic query Q with relations R
def
= R(Q),
degree sequences f R,Z, and max tuple multiplicities B(R) as in problem 1.
4.1
The Degree Sequence Bound
▶Theorem 4.1. For any tensors M (R) ∈M+
f (R,XR),B(R) and permutations σ(R), for R ∈R,
the following holds:
SUMX
 O
R∈R
(M (R) ◦σ(R))
!
≤SUMX
 O
R∈R
Cf (R,XR),B(R)
!
def
= DSB(Q)
(19)
where Cf (R,XR),B(R) is the worst-case tensor from Def. 3.1.
The theorem simply says that the upper bound to the query Q can be computed by
evaluating Q on the worst case instances, represented by the worst case tensors Cf (R,XR),B(R).
We call this quantity the degree sequence bound and denote it by DSB(Q). When all max
tuple multiplicities B(R) are ∞, then the bound is tight, because in that case every worst-case
tensor Cf (R,XR),∞is in M+
f (R,XR),∞(by Th. 3.2 item 6); otherwise the bound may not be
tight, but it is locally tight, in the sense of Th. 3.2 item 1.
Before we sketch the main idea of the proof, we note that an immediate consequence is that
the degree sequence bound can be computed using a special case of the FAQ algorithm [12]. We
describe this brieﬂy in Algorithm 2. Recall that the incidence graph of Q is a tree T. Choose
an arbitrary relation ROOT ∈R(Q) and designate it as root, then make T a directed tree by
orienting all its edges away from the root. Denote by parent(R) ∈XR the parent node of a
relation R̸ = ROOT, associate an X-vector a(X) to each variable X, and a parent(R)-vector
w(R) to each relation name R, then compute these vectors by traversing the tree bottom-up,
as shown in Algorithm 2. Notice that, when X is a leaf variable, then children(X) = ∅and
a(X) = (1, 1, . . . , 1)T ; similarly, if R(X) is leaf relation of arity 1 with variable X, then w(R)

---

K. Deeds, D. Suciu, M. Balazinska, W. Cai
23:11
Algorithm 2 Computing DSB(Q) = SUMX
N
R∈R Cf(R,XR),B(R)
for each variable X ∈X and non-root relation R ∈R, R̸ = root, in bottom-up order do
a(X) def
= N
R∈children(X) w(R)
// element-wise product
w(R) def
= Cf (R,XR),B(R) · a(X2) · · · a(Xk) // where XR = (X1, . . . , Xk), X1 = parent(R)
end for
return Cf (root,XROOT),B(ROOT) · a(X1) · a(X2) · · · a(Xk)
is the degree sequence of its variable, because w(R) = C(f (R,X),B(R)) = f (R,X). We provide
an example in Sec. A.3. It follows:
▶Corollary 4.2. The degree sequence bound DSB(Q) can be computed in time polynomial
in the size of the largest domain (data complexity).
In the rest of this section we sketch the proof of Theorem 4.1, mostly to highlight the
role of item 5 of Theorem 3.2, and defer the formal details to Appendix A.3. Fix tensors
M (R) and permutations σ(R), for each R ∈R. Choose one relation, say S ∈R, assume it
has k variables X1, . . . , Xk, then write the LHS of (19) as:
SUMXS

M (S) ◦σ(S)
⊗b1 ⊗· · · ⊗bk

(20)
where each bp is a tensor expression sharing only variable Xp with S, where we sum out all
variables except Xp (using Eq. (5)). Compute the vectors bp ﬁrst, sort them in non-decreasing
order, let τp be the permutation that sorts bp, and τ
def
= (τ1, . . . , τk). Then (20) equals:
SUMXS

M (S) ◦σ(R) ◦τ

⊗(b1 ◦τ1) ⊗· · · ⊗(bk ◦τk)

(21)
because sums are invariant under permutations. Since each bp ◦τp is sorted, by item 1 of
Theorem 3.2, the expression above is ≤to the expression obtained by replacing M (S)◦σ(S)◦τ
with the worst-case tensor Cf (S,XS ),B(S). Thus, every tensor could be replaced by the worst-
case tensor, albeit at the cost of applying some new permutations τp to other expressions.
To avoid introducing these permutations, we proceed as follows. We choose an orientation of
the tree T, as in Algorithm 2, then prove inductively, bottom-up the tree, that each tensor
M ◦σ can be replaced by the worst-case tensor C without decreasing the LHS of (19),
and that the resulting vector (in the bottom-up computation) is sorted. To prove this, we
re-examine Eq. (20), assuming X1 is the parent variable of S. By induction, all the tensors
occurring in b2, . . . , bk have already been replaced with worst-case tensors, and their results
are non-increasing vectors. Then, in Eq. (21) it suﬃces to apply the permutation τ to the
parent expression b1 (which still has the old tensors M ◦σ), use item 1 of Theorem 3.2 to
replace M (S) ◦σ(S) ◦τ by Cf (S,XS ),B(S), and, ﬁnally, use item 5 of Theorem 3.2 to prove
that the result returned by the node S is a non-decreasing vector, as required.
4.2
Connection to the AGM and Polymatroid Bounds
We prove now that DSB(Q) is always below the AGM [1] and the polymatroid bounds [15, 19].
The AGM bound is expressed in terms of the cardinalities of the relations. For each
relation R, let NR be an upper bound on its cardinality. Then the AGM bound is AGM(Q)
def
=
minw
Q
R N wR
R , where the vector w = (wR)R∈R ranges over the fractional edge covers of the
hypergraph associated to Q. If a database instance satisﬁes |R| ≤NR for all R, then the
CVIT 2016

---

23:12
Degree Sequence Bound For Join Cardinality Estimation
size of the query is |Q| ≤AGM(Q), and this bound is tight, i.e. there exists an instance for
which we have equality.
The polymatroid bound uses both the cardinality constraints NR and the maximum
degrees. The general bound in [15] considers maximum degrees for any subset of variables, but
throughout this paper we restrict to degrees of single variables, in which case the polymatroid
bound is expressed in terms of the quantities NR and f (R,X)
1
, one for each relation R and
each of its variables X. The AGM bound is the special case when f (R,X)
1
= NR for all R. We
review the general deﬁnition of the polymatroid bound in Sec. A.4, but will mention that no
closed formula is known for polymatroid bound, similar to the AGM formula. We give here
the ﬁrst such closed formula, for the case of Berge-acyclic queries. Let Q be a Berge-acyclic
query with incidence graph T (which is a tree). Choose an arbitrary relation ROOT ∈R(Q)
to designate as the root of T, and for each other relation R, denote by ZR
def
= parent(R), i.e.
its unique variable pointing up the tree. Denote by:
PB(Q, ROOT)
def
=NROOT
Y
R̸=ROOT
f (R,ZR)
1
(22)
One can immediately check that the query answer on any database instance consistent with
the statistics satisﬁes |Q| ≤PB(Q, ROOT). A cover of Q is set W = {Q1, Q2, . . . , Qm}, for
some m ≥1, where each Qi is a connected subquery of Q, and each variable of Q occurs in
at least one Qi, and we denote by:
PB(W )
def
=
Y
i=1,m
min
ROOT∈R(Qi) PB(Qi, ROOTi)
(23)
Since |Q| ≤|Q1| · |Q2| · · · |Qm|, we also have |Q| ≤PB(W ). We prove in Sec. A.4:
▶Theorem 4.3. The polymatroid bound of a Berge-acyclic query Q is PB(Q)
def
= minW PB(W ),
where W ranges over all covers.
▶Example 4.4. Let Q = R(X, Y ), S(Y, Z), T(Z, U), K(U, V ). Then PB(Q, S) = f (R,Y )
1
NSf (T,Z)
1
f (K,U)
1
,
PB({R, TK}) = NR · min
 NT f (K,U), f (T,U)Nk

, and PB({R, T, K}) = NRNT NK.
If we restrict the formula to the AGM bound, i.e. all max degrees are equal to the
cardinalities, f (R,X)
1
= NR, then Eq. (22) becomes Q
R∈R(Q) NR, while the polymatroid
bound (23) becomes minW
Q
R∈W NR, where W ranges over integral covers of Q.
In
particular, the AGM bound of a Berge-acyclic query can be obtained by restricting to integral
edge covers, although this property fails for α-acylic queries. For example, consider the query
R(X, Y ), S(Y, Z), T(Z, X), K(X, Y, Z); when |R| = |S| = |T| = |K| then the AGM bound is
obtained by the edge cover 0, 0, 0, 1, but when |R| = |S| = |T| ≪|K| one needs the fractional
cover 1/2, 1/2, 1/2, 0. Next, we prove next that the degree sequence bound is always better.
▶Lemma 4.5. (1) For any choice of root relation, ROOT ∈R(Q): DSB(Q) ≤PB(Q, ROOT).
(2) For any cover Q1, . . . , Qm of Q, DSB(Q) ≤DSB(Q1) · · · DSB(Qm)
Proof. (1) Referring to Algorithm 2, we prove by induction on the tree that, for all R̸ = ROOT,
and every index i, w(R)
i
≤Q
S∈tree(R) f (S,ZS)
1
. In other words, each element of the vector
w(R) is ≤the product of all max degrees in the subtree rooted at R. Assuming this holds for
all children of R, consider the deﬁnition of w(R) in Algorithm 2. By induction hypothesis,
for each vector a(Xp) we have a(Xp)
ip
≤Q
S∈tree(Xp) f (S,ZS)
1
, a quantity that is independent of
the index ip, and therefore we obtain the following:
w(R)
i1
=

Cf (R,XR),B(R) · a(X2) · · · a(Xk)
i1 ≤
 X
i2i3···ik
Cf (R,XR),B(R)
i1i2i3···ik
!
·
Y
S∈tree(R),S̸=R
f (S,ZS)
1

---

K. Deeds, D. Suciu, M. Balazinska, W. Cai
23:13
and we use the fact that P
i2i3···ik Cf (R,XR),B(R)
i1i2···ik
≤f (R,X1)
i1
because, by Theorem 3.2 item 1,
Cf (R,XR),B(R) is consistent with the degree sequence f (R,X1)
1
, and, ﬁnally, f (R,X1)
i1
≤f (R,X1)
1
.
This completes the inductive proof.
The algorithm returns Cf (root,XROOT),B(ROOT) · a(X1) ·
a(X2) · · · a(Xk) ≤SUM(Cf (root,XROOT),B(ROOT)) · Q
R̸=ROOT f (R,ZR)
1
≤|ROOT| · Q
R̸=ROOT f (R,ZR)
1
, which
is = PB(Q, ROOT), as required.
(2) We prove the statement only for m = 2 (the general case is similar) and show
that DSB(Q) ≤DSB(Q1) · DSB(Q2). Since DSB is the query answer on the worst case
instance, we need to show that |Q1 ⋊⋉Q2| ≤|Q1| · |Q2|. This is not immediately obvious
because the worst case instance may have negative multiplicities. Let X be the unique
common variable of Q1, Q2, and let a, b be the X-vectors representing the results of Q1 and
Q2 respectively. It follows from Theorem 3.2 item 5 that a, b are non-negative, therefore,
|Q| = P
i aibi ≤(P
i ai)(P
i bi) = |Q1| · |Q2|.
◀
Our discussion implies:
▶Theorem 4.6. Let Q be a Berge-acyclic query. We denote by DSB(Q, f, B) the DSB
computed on the statistics f
def
= (f R,Z)R∈R(Q),Z∈XR and B
def
= (B(R))R∈R(Q). Then:
|Q| ≤DSB(Q, f, 1) ≤DSB(Q, f, B) ≤DSB(Q, f, ∞) ≤PB(Q) ≤AGM(Q)
(24)
where |Q| is the answer to the query on an database instance consistent with the given
statistics.
Recall that both AGM and PB bounds are deﬁned over set semantics only. While the
AGM bound is tight, the PB bound is known to not be tight in general, and it is open
whether it is tight for Berge-acyclic queries. Our degree sequence bound under either set or
bag semantics improves over PB and, in the case of bag semantics (B = ∞) DSB is tight.
5
Functional Representation
A degree sequence requires, in general, Ω(n) space, where n = maxX∈X nX is the size of the
largest domain, while cardinality estimators require sublinear space and time. However, a
degree sequence can be represented compactly, using a staircase function as illustrated in
Fig. 1. In this section we show how the degree sequence bound, DSB, be approximated in
quasi-linear time in the size of the functional representation. We call this approximate bound
FDSB, show that DSB ≤FDSB ≤PB, and show that the staircase functions can be further
compressed, allowing a tradeoﬀbetween the memory size and computation time on one hand,
and accuracy of the FDSB on the other hand. We restrict our discussion to B(R) = ∞.
In this section we denote a vector element by F(i) rather than Fi. For a non-decreasing
vector F ∈R[n]
+ , we denote by F −1 : R+ →R+ any function satisfying the following, for all
v, 0 ≤v ≤F(n): if F(i) < v then i < F −1(v), and if F(i) > v then i > F −1(v). Such a
function always exists5, but is not unique. Then:
▶Lemma 5.1. Let F1 ∈R[n1]
+ , . . . , Fd ∈R[nd]
+
be non-decreasing vectors satisfying F1(0) = 0
and, for all p = 1, d, F1(n1) ≤Fp(np). Let a1 ∈R[n1]
+ , . . . , ad ∈R[nd]
+
be non-increasing
5 E.g. deﬁne it as follows: if ∃i s.t. F(i −1) < v < F(i) then set F −1(v)
def
= i −1/2, otherwise set
F −1(v) = i for some arbitrary i s.t. F(i) = v.
CVIT 2016

---

23:14
Degree Sequence Bound For Join Cardinality Estimation
Algorithm 3 FDSB(Q, ROOT)
for each variable X ∈X and non-root relation R ∈R, R̸ = root, in bottom-up order do
ˆa(X) def
= N
R∈children(X) ˆ
w(R)
∀i1 :
ˆw(R)(i1)
def
=

ˆf (R,X1)(i1)
 Q
p∈[2,d] a(Xp) 
max(1, ( ˆF (R,Xp))−1( ˆF (R,X1)(i1 −1)))

end for
return P
i=1,|ROOT|
Q
p=1,k a(Xp)(max(1, (F ROOT,Xp)−1(i −1)))
vectors. Denote by C, w the following tensor and vector:
Ci1···id
def
=∆i1 · · · ∆id max(F1(i1), . . . , Fd(id))
(25)
w(i1)
def
=
n2
X
i2=1
. . .
nd
X
id=1
Ci1···id
Y
p∈[2,d]
ap(ip)
(26)
Then the following inequalities hold:
w(i1) ≥(∆i1F1(i1))
Y
p∈[2,d]
ap
 
F −1
p
(F1(i1))

+ 1

(27)
w(i1) ≤(∆i1F1(i1))
Y
p∈[2,d]
ap
 
F −1
p
(F1(i1 −1))

(28)
We give the proof in Appendix A.5. The lemma implies that, in Algorithm 2, we can
use inequality (28) to upper bound the computation w(R) = C · a(X2) · · · a(Xk). Indeed, in
that case each Fp(r)
def
= P
i=1,r fp(r) is the cdf of a degree sequence fp, hence Fp(0) = 0 and
Fp(np) = the cardinality of R, while the tensor C is described in item 6 of Theorem 3.2,
hence the assumptions of the lemma hold.
We say that a vector f ∈Rn
+ is represented by a function ˆf : R+ →R+ if f(i) = ˆf(i) for
all i = 1, n. A function ˆf is a staircase function with s steps, in short an s-staircase, if there
exists dividers m0
def
= 0 < m1 < · · · < ms
def
= n such that ˆf(x) is a nonnegative constant on
each interval {x | mq−1 < x ≤mq}, q = 1, s. The sum or product of an s1-staircase with
an s2-staircase is an (s1 + s2)-staircase. We denote the summation of a staircase ˆf(x) as
ˆF(x) =
R x
0 ˆf(t)dt which is then an increasing piecewise-linear function. Its standard inverse
ˆF −1 : R+ →R+ is also increasing and piecewise-linear. If ˆF represents the vector F, then
ˆF −1 is an inverse F −1 of that vector (as discussed above).
Fix a Berge-acyclic query Q, and let each degree sequence f (R,Z) be represented by some
sR,Z-staircase ˆf R,Z, and we denote by ˆF (R,Z) its summation. Fix any relation ROOT ∈R(Q)
to designated as root. The Functional Degree Sequence Bound at ROOT, FDSB(Q, ROOT),
is the value returned by Algorithm 3. This algorithm is identical to Algorithm 2, except
that it replaces both w(R) with a functional upper bound justiﬁed by the inequality 28 of
Lemma 5.1, and similarly for the returned result. All functions ˆa(X) and ˆ
w(R) are staircase
functions, and can be computed in linear time, plus a logarithmic time need for a binary
search to lookup a segment in a staircase. Using this, we prove the following in Appendix A.6:
▶Theorem 5.2. (1) FDSB(Q, ROOT) ≥DSB(Q). (2) FDSB(Q, ROOT) can be computed
in time TFDSB
def
= ˜O(m · P
R,Z(arity(R) · sR,Z)), where ˜O hides a logarithmic term, and
m = |R(Q)| is the number of relations in Q.
The theorem says that FDSB(Q, ROOT) is still an upper bound on |Q|, and can be
computed in quasi-linear time in the size of the functional representations of the degree

---

K. Deeds, D. Suciu, M. Balazinska, W. Cai
23:15
sequences. Next, we check if FDSB is below the polymatroid bound. Consider the computa-
tion of ˆw(R)(i1) by the algorithm. On one hand ˆf (R,X1)(i1) ≤ˆf (R,X1)(1); on the other hand
a(Xp)(max(1, . . .)) ≤a(Xp)(1). This allows us to prove (inductively on the tree, in A.7):
▶Lemma 5.3. FDSB(Q, ROOT) ≤PB(Q, ROOT), where PB is deﬁned in (22).
When we proved DSB ≤PB in Lemma 4.5, we used two properties of DSB: DSB(Q, ROOT)
is independent of the choice of ROOT, and DSB(Q1 ⋊⋉· · · ⋊⋉Qm) ≤DSB(Q1) · · · DSB(Qm),
for any cover W = {Q1, . . . , Qm}. Both hold because DSB(Q) is standard query evaluation:
it is independent of the query plan (i.e. choice of ROOT) and it can only increase if we remove
join conditions. But FDSB is no longer standard query evaluation and these properties may
fail. For that reason we introduce a stronger functional degree sequence bound:
FDSB(Q) = min
W
Y
i=1,m
min
ROOT ∈R(Q) FDSB(Qi, ROOT)
(29)
where W range over the covers of Q. We prove in Appendix A.6.1:
▶Theorem 5.4. FDSB(Q) can be computed in time O(2m · (2m + m · TF DSB)) (where
TF DSB is deﬁned in Theorem 5.2).
Mirroring our results from Theorem 4.6, we prove the following in Appendix A.8:
▶Theorem 5.5. Suppose Q is a Berge-acyclic query. Then the following hold:
|Q| ≤FDSB(Q) ≤PB(Q) ≤AGM(Q)
(30)
Together, Theorems 5.4 and 5.5 imply that we can compute in quasi-linear time in the
size of the representation an upper bound to the query Q that is guaranteed to improve over
the polymatroid bound. In practice, we expect this bound to be signiﬁcantly lower than the
polymatroid bound, because it accounts for the entire degree sequence f, not just f1.
Finally, we show that one can tradeoﬀthe size of the representation for accuracy, by
simply choosing more coarse staircase approximations of the degree sequences. They only
need to be non-increasing, and lie above the true degree sequences.
▶Theorem 5.6. Fix a query Q, let f (R,Z), B(R) be statistics as in Problem 1, and let U be
the cardinality bound deﬁned by (10). Let ˆf (R,Z), ˆB(R) be a new set of statistics, and ˆU the
resulting cardinality bound. If f (R,XR) ≤ˆf (R,XR) and B(R) ≤ˆB(R) for all R, Z ∈XR, then
U ≤ˆU.
Proof. The proof follows immediately from the observation that the set of feasible solutions
can only increase (see Def. 2.3): M+
f (R,XR),B(R) ⊆M+
ˆ
f (R,XR), ˆ
B(R).
◀
6
Conclusions
We have described the degree sequence bound of a conjunctive query, which is an upper bound
on the size of its answer, given in terms of the degree sequences of all its attributes. Our
results apply to Berge-acyclic queries, and strictly improve over previously known AGM
and polymatroid bounds [1, 15]. On one hand, our results represent a signiﬁcant extension,
because they account for the full degree sequences rather than just cardinalities or just the
maximum degrees. On the other hand, they apply only to a restricted class of acyclic queries,
although, we argue, this class is the most important for practial applications. While the full
degree sequence can be as large as the entire data, we also described how to approximate
the cardinality bound very eﬃciently, using compressed degree sequences. Finally, we have
argued for using the max tuple multiplicity for each relation, which can signiﬁcantly improve
the accuracy of the cardinality bound.
CVIT 2016

---

23:16
Degree Sequence Bound For Join Cardinality Estimation
References
1
Albert Atserias, Martin Grohe, and Dániel Marx. Size bounds and query plans for relational
joins. In 49th Annual IEEE Symposium on Foundations of Computer Science, FOCS 2008,
October 25-28, 2008, Philadelphia, PA, USA, pages 739–748. IEEE Computer Society, 2008.
doi:10.1109/FOCS.2008.43.
2
Douglas Bauer, Haitze J Broersma, Jan van den Heuvel, Nathan Kahl, A Nevo, E Schmeichel,
Douglas R Woodall, and Michael Yatauro.
Best monotone degree conditions for graph
properties: a survey. Graphs and combinatorics, 31(1):1–22, 2015.
3
Walter Cai, Magdalena Balazinska, and Dan Suciu. Pessimistic cardinality estimation: Tighter
upper bounds for intermediate join cardinalities. In Peter A. Boncz, Stefan Manegold, Anastasia
Ailamaki, Amol Deshpande, and Tim Kraska, editors, Proceedings of the 2019 International
Conference on Management of Data, SIGMOD Conference 2019, Amsterdam, The Netherlands,
June 30 - July 5, 2019, pages 18–35. ACM, 2019. doi:10.1145/3299869.3319894.
4
Ronald Fagin. Degrees of acyclicity for hypergraphs and relational database schemes. J. ACM,
30(3):514–550, 1983. doi:10.1145/2402.322390.
5
Amir Gilad, Shweta Patwa, and Ashwin Machanavajjhala. Synthesizing linked data under
cardinality and integrity constraints. In Guoliang Li, Zhanhuai Li, Stratos Idreos, and Divesh
Srivastava, editors, SIGMOD ’21: International Conference on Management of Data, Virtual
Event, China, June 20-25, 2021, pages 619–631. ACM, 2021. doi:10.1145/3448016.3457242.
6
Georg Gottlob, Stephanie Tien Lee, Gregory Valiant, and Paul Valiant. Size and treewidth
bounds for conjunctive queries.
J. ACM, 59(3):16:1–16:35, 2012.
doi:10.1145/2220357.
2220363.
7
Martin Grohe and Dániel Marx. Constraint solving via fractional edge covers. In Proceedings
of the Seventeenth Annual ACM-SIAM Symposium on Discrete Algorithms, SODA 2006,
Miami, Florida, USA, January 22-26, 2006, pages 289–298. ACM Press, 2006. URL: http:
//dl.acm.org/citation.cfm?id=1109557.1109590.
8
S Louis Hakimi and Edward F Schmeichel. Graphs and their degree sequences: A survey. In
Theory and applications of graphs, pages 225–235. Springer, 1978.
9
Yuxing Han, Ziniu Wu, Peizhi Wu, Rong Zhu, Jingyi Yang, Liang Wei Tan, Kai Zeng, Gao
Cong, Yanzhao Qin, Andreas Pfadler, et al. Cardinality estimation in dbms: A comprehensive
benchmark evaluation. arXiv preprint arXiv:2109.05877, 2021.
10
Axel Hertzschuch, Claudio Hartmann, Dirk Habich, and Wolfgang Lehner. Simplicity done
right for join ordering. In 11th Conference on Innovative Data Systems Research, CIDR
2021, Virtual Event, January 11-15, 2021, Online Proceedings. www.cidrdb.org, 2021. URL:
http://cidrdb.org/cidr2021/papers/cidr2021_paper01.pdf.
11
Mahmoud Abo Khamis, Phokion G. Kolaitis, Hung Q. Ngo, and Dan Suciu. Bag query
containment and information theory. In Dan Suciu, Yufei Tao, and Zhewei Wei, editors,
Proceedings of the 39th ACM SIGMOD-SIGACT-SIGAI Symposium on Principles of Database
Systems, PODS 2020, Portland, OR, USA, June 14-19, 2020, pages 95–112. ACM, 2020.
doi:10.1145/3375395.3387645.
12
Mahmoud Abo Khamis, Hung Q. Ngo, and Atri Rudra. FAQ: questions asked frequently. In
Tova Milo and Wang-Chiew Tan, editors, Proceedings of the 35th ACM SIGMOD-SIGACT-
SIGAI Symposium on Principles of Database Systems, PODS 2016, San Francisco, CA, USA,
June 26 - July 01, 2016, pages 13–28. ACM, 2016. doi:10.1145/2902251.2902280.
13
Mahmoud Abo Khamis, Hung Q. Ngo, and Dan Suciu. Computing join queries with functional
dependencies. In Tova Milo and Wang-Chiew Tan, editors, Proceedings of the 35th ACM
SIGMOD-SIGACT-SIGAI Symposium on Principles of Database Systems, PODS 2016, San
Francisco, CA, USA, June 26 - July 01, 2016, pages 327–342. ACM, 2016. doi:10.1145/
2902251.2902289.
14
Mahmoud Abo Khamis, Hung Q. Ngo, and Dan Suciu. What do shannon-type inequalities, sub-
modular width, and disjunctive datalog have to do with one another? CoRR, abs/1612.02503,
2016. URL: http://arxiv.org/abs/1612.02503, arXiv:1612.02503.

---

K. Deeds, D. Suciu, M. Balazinska, W. Cai
23:17
15
Mahmoud Abo Khamis, Hung Q. Ngo, and Dan Suciu. What do shannon-type inequalities,
submodular width, and disjunctive datalog have to do with one another? In Emanuel Sallinger,
Jan Van den Bussche, and Floris Geerts, editors, Proceedings of the 36th ACM SIGMOD-
SIGACT-SIGAI Symposium on Principles of Database Systems, PODS 2017, Chicago, IL,
USA, May 14-19, 2017, pages 429–444. ACM, 2017. doi:10.1145/3034786.3056105.
16
Viktor Leis, Andrey Gubichev, Atanas Mirchev, Peter A. Boncz, Alfons Kemper, and Thomas
Neumann. How good are query optimizers, really? Proc. VLDB Endow., 9(3):204–215, 2015.
URL: http://www.vldb.org/pvldb/vol9/p204-leis.pdf, doi:10.14778/2850583.2850594.
17
Jie Liu, Wenqian Dong, Dong Li, and Qingqing Zhou. Fauce: Fast and accurate deep ensembles
with uncertainty for cardinality estimation. Proc. VLDB Endow., 14(11):1950–1963, 2021.
URL: http://www.vldb.org/pvldb/vol14/p1950-liu.pdf.
18
Parimarjan Negi, Ryan C. Marcus, Andreas Kipf, Hongzi Mao, Nesime Tatbul, Tim Kraska,
and Mohammad Alizadeh. Flow-loss: Learning cardinality estimates that matter. Proc. VLDB
Endow., 14(11):2019–2032, 2021. URL: http://www.vldb.org/pvldb/vol14/p2019-negi.pdf.
19
Hung Q. Ngo. Worst-case optimal join algorithms: Techniques, results, and open problems.
In Jan Van den Bussche and Marcelo Arenas, editors, Proceedings of the 37th ACM SIGMOD-
SIGACT-SIGAI Symposium on Principles of Database Systems, Houston, TX, USA, June
10-15, 2018, pages 111–124. ACM, 2018. doi:10.1145/3196959.3196990.
20
Yeonsu Park, Seongyun Ko, Sourav S. Bhowmick, Kyoungmin Kim, Kijae Hong, and Wook-
Shin Han. G-CARE: A framework for performance benchmarking of cardinality estimation
techniques for subgraph matching. In David Maier, Rachel Pottinger, AnHai Doan, Wang-Chiew
Tan, Abdussalam Alawini, and Hung Q. Ngo, editors, Proceedings of the 2020 International
Conference on Management of Data, SIGMOD Conference 2020, online conference [Portland,
OR, USA], June 14-19, 2020, pages 1099–1114. ACM, 2020. doi:10.1145/3318464.3389702.
21
Ji Sun, Guoliang Li, and Nan Tang. Learned cardinality estimation for similarity queries.
In Guoliang Li, Zhanhuai Li, Stratos Idreos, and Divesh Srivastava, editors, SIGMOD ’21:
International Conference on Management of Data, Virtual Event, China, June 20-25, 2021,
pages 1745–1757. ACM, 2021. doi:10.1145/3448016.3452790.
22
Xiaoying Wang, Changbo Qu, Weiyuan Wu, Jiannan Wang, and Qingqing Zhou. Are we
ready for learned cardinality estimation? Proc. VLDB Endow., 14(9):1640–1654, 2021. URL:
http://www.vldb.org/pvldb/vol14/p1640-wang.pdf.
23
Peizhi Wu and Gao Cong. A uniﬁed deep model of learning from both data and queries for
cardinality estimation. In Guoliang Li, Zhanhuai Li, Stratos Idreos, and Divesh Srivastava,
editors, SIGMOD ’21: International Conference on Management of Data, Virtual Event,
China, June 20-25, 2021, pages 2009–2022. ACM, 2021. doi:10.1145/3448016.3452830.
24
Ziniu Wu, Amir Shaikhha, Rong Zhu, Kai Zeng, Yuxing Han, and Jingren Zhou. Bayescard:
Revitilizing bayesian frameworks for cardinality estimation. arXiv e-prints, pages arXiv–2012,
2020.
25
Zongheng Yang, Amog Kamsetty, Sifei Luan, Eric Liang, Yan Duan, Xi Chen, and Ion Stoica.
Neurocard: One cardinality estimator for all tables. Proc. VLDB Endow., 14(1):61–73, 2020.
URL: http://www.vldb.org/pvldb/vol14/p61-yang.pdf, doi:10.14778/3421424.3421432.
26
Zongheng Yang, Amog Kamsetty, Sifei Luan, Eric Liang, Yan Duan, Xi Chen, and Ion Stoica.
Neurocard: one cardinality estimator for all tables. arXiv preprint arXiv:2006.08109, 2020.
27
Rong Zhu, Ziniu Wu, Yuxing Han, Kai Zeng, Andreas Pfadler, Zhengping Qian, Jingren Zhou,
and Bin Cui. Flat: fast, lightweight and accurate method for cardinality estimation. arXiv
preprint arXiv:2011.09022, 2020.
28
Rong Zhu, Ziniu Wu, Yuxing Han, Kai Zeng, Andreas Pfadler, Zhengping Qian, Jingren Zhou,
and Bin Cui. FLAT: fast, lightweight and accurate method for cardinality estimation. Proc.
VLDB Endow., 14(9):1489–1502, 2021. URL: http://www.vldb.org/pvldb/vol14/p1489-zhu.
pdf.
CVIT 2016

---

23:18
Degree Sequence Bound For Join Cardinality Estimation
A
Appendix
A.1
Discussion the Framework
Throughout this paper we restricted the discussion to Berge-acyclic queries. In this section
we brieﬂy review their standard deﬁnition, and comment on their utility in practice.
We begin by reviewing the deﬁnition of a Berge-cycle, following [4]. Fix an arbitrary
conjunctive query Q, which we view as a hypergraph, and consider its incidence graph, deﬁned
as the following bipartite graph: T
def
= (R ∪X, E
def
= {(R, Z) | Z ∈XR}). A Berge-Cycle is
a sequence (R1, X1, R2, X2, . . . , Rm, Xm, Rm+1) such that,
1. Ri ∀1 ≤i ≤m is a unique relation in R.
2. R1 = Rm+1
3. Xi ∀1 ≤i ≤m is a unique variable in X.
4. m ≥2
5. Xi ∈XRi and Xi ∈XRi+1 ∀1 ≤i ≤m
It follows immediately that a Berge-cycle is a cycle in the incidence graph, and vice versa. A
Berge-Acyclic query is one that does not contain a Berge-Cycle, or, equivalently, one whose
incidence graph is a tree. This coincides with our deﬁnition in Sec. 2.
Berge-acyclic queries capture many traditional ﬂavors of queries found in practice, such
as chain, star, and snowﬂake queries. As an illustration of this, we note that many modern
cardinality estimation benchmarks include exclusively Berge-Acyclic queries, for example
the JOB benchmark [16] and the STATS-CEB benchmark [9]. Additionally, many state
of the art approaches to cardinality estimation have this limitation as well. For example,
NeuroCard, FLAT, and BayesCard cannot produce estimates for cyclic queries [26, 27, 24].
While rare, cyclic queries do occur in practice, and, in that case, the degree sequence
bound is still useful, as follows. Consider all possible spanning trees of the incidence graph.
The query deﬁned by each such spanning tree must produce a larger output than the original
query. This can be seen by viewing joins as a set of ﬁlters on the Cartesian product of the
input tables. A spanning tree operates on the same Cartesian product, but it applies a
subset of the cyclic query’s ﬁlters, and, therefore, it must produce at least as many rows.
This means that we can produce a bound on cyclic queries by taking the minimum of the
degree sequence bound for each spanning tree. In general, this bound is not tight, but is
still an upper bound, and still useful. In contrast, cardinality estimation frameworks like
NeuroCard, FLAT, BayesCard aim at estimating the cardinality, but an estimate on the
cardinality of a spanning tree is useless for estimating the cardinality of the cyclic query.
In other words, while our degree sequence bound makes similar restrictions on the queries
as other state-of-the-art cardinality estimators, the latter cannot be used on cyclic queries,
while ours is still useful.
A.2
Proof of Theorem 3.2
In this section we prove each of the items in the theorem and restate them at each point for
convenience.
A.2.1
Permutations σ Are the Identity
We start by proving that it suﬃces to restrict σ in Problem 2 to be the identity permutations.
More precisely, we prove:

---

K. Deeds, D. Suciu, M. Balazinska, W. Cai
23:19
▶Lemma A.1. For any tensor M ∈M+
f (X),B and any tuple of permutations σ ∈S[n] there
exists a tensor N ∈M+
f (X),B such that, for all non-increasing vectors a(Xp) ∈R[np]
+
, p = 1, d,
the following holds:
(M ◦σ) · a(X1) · · · a(Xd) ≤N · a(X1) · · · a(Xd)
The lemma implies that σ can be chosen to be the identity in Problem 2, because we
can simply replace M and σ, with N and the identity permutation. In other words that,
in order to compute the upper bound to Qstart, it suﬃces to restrict the relation instance
S to have the highest degrees aligned with the highest degrees of the unary relations R(p),
p = 1, d.
To prove Lemma A.1, we establish the following:
▶Lemma A.2. Let M ∈R[n]
+
be an X-tensor s.t. M ◦σ−1 ∈M+
f (X),B for some σ. Then
there exists an X-tensor N ∈R[n]
+
satisfying:
||M||∞= ||N||∞.
For every variable Xp, SUMX−{Xp}(N) is non-increasing, and is equal, up to a permuta-
tion, to SUMX−{Xp}(M). In particular, N ∈M+
f (X),B.
For any non-increasing vectors a(Xp) ∈R[np]
+
:
M · a(X1) · · · a(Xd) ≤N · a(X1) · · · a(Xd)
(31)
We ﬁrst show that Lemma A.2 implies Lemma A.1. Let M, σ be given as in Lemma A.1.
We apply Lemma A.2 to M ◦σ, and obtain some tensor N ∈M+
f (X),B such that (M ◦σ) ·
a(X1) · · · a(Xd) ≤N · a(X1) · · · a(Xd). Thus, it remains to prove Lemma A.2.
The proof of Lemma A.2 consists of modifying M by sorting each dimension Xp separately.
To sort the dimension Xp, we cannot simply switch some hyperplane Xp = i with another
hyperplane Xp = j, because that doesn’t guarantee (31). Instead, we move mass “up” in the
tensor along the dimension Xp. We ﬁrst illustrate the proof idea with an example.
▶Example A.3. We want to maximize the product aT · M · b, for some 2 × 3 matrix M,
constraint by the degree sequences f = (16, 12) and g = (14, 11, 3), and element bound
B = 10. Our current candidate is
M =
14
3
11
12
10
1
1
16
4
2
10

We will modify M to a new matrix N, whose row-sums are 16, 12, while aT ·M ·b ≤aT ·N ·b,
for all ab. Simply switching rows 1 and 2 doesn’t work: indeed, if we set aT def
= (1, 0)T ,
bT
def
= (1, 0, 0) then aT · M · b = 10, but after we switch the two rows, aT · N · b = 4.
Instead, we move positive mass up, separately in each column. The maximum we can move
in each column k is vk
def
= (Mk2 −Mk1)+, where x+ def
= max(x, 0). Denoting by v the vector
(v1, v2, v3), we have:
v =
 0
1
9

The row-sum in v is 10, but we only need to move a total mass of 4 (the diﬀerence 16 −12),
hence we will move only a θ = 4/10-fraction of v, namely θ · v =
 0
0.4
3.6

, and obtain:
N
def
=
14
3
11
16
10
1.4
4.6
12
4
1.6
7.4

CVIT 2016

---

23:20
Degree Sequence Bound For Join Cardinality Estimation
Finally, we check that the quantity aT · M · b has not decreased:
aT · N · b−aT · M · b =
 aT · (N −M)

· b =
=θ ·
 (a1 −a2)v1
(a1 −a2)v2
(a1 −a2)v3

· b
This quantity is ≥0 because a1 ≥a2 and b ≥0. Observe that N has exactly the same
column-sums as M, and ||M||∞= ||N||∞, while its rows are sorted in non-increasing order
of their sums. If we repeat the same argument for the columns 2 and 3, then we obtain
a matrix whose row-sums and column-sums are (16, 12), and (14, 11, 3), and which upper
bounds the quantity aT · M · b for all non-increasing a, b.
Before we prove Lemma A.2 we need some notations. An inversion in a vector f ∈R[n]
is a pair i < j such that fi ≥fj. The vector is non-increasing iﬀit has the maximum number
of inversions, n(n −1)/2. If (i, j) is not an inversion, then f ◦τij has strictly more inversions,
where τij is the permutation swapping i and j. The proof of Lemma A.2 follows from the
following Proposition:
▶Proposition A.4. Let M ∈R[n]
+
be X-tensor, q ∈[d] be one of its dimensions, and
f
def
= SUMX−{Xq}(M). If f as no inversion at (i, j), then there exists a X-tensor N ∈Rn
+
with the following properties:
||M||∞= ||N||∞.
SUMX−{Xp}(M) = SUMX−{Xp}(N) for all p̸ = q.
SUMX−{Xq}(N) = f ◦τij.
Inequality (31) holds for any vectors a(Xp) ∈R[np]
+
such that a(Xq) is non-increasing,
By repeatedly applying the proposition to dimension q we can ensure that SUMX−{Xq}(M)
is non-increasing; the proof of Lemma A.2 follows by repeating this for each dimension q.
Proof. (of Proposition A.4) Deﬁne:
δ
def
=fj −fi
The idea of the proof is to modify M by pushing a total mass of δ from the hyperplane j to
the hyperplane i. When doing so we must ensure that the new values in hyperplane i don’t
exceed B, those in hyperplane j don’t become < 0, and we don’t push more mass than δ.
Denote by x+ def
= max(x, 0) and deﬁne the following quantities, where k ∈Q
p=1,d;p̸=q[np],
and ki denotes the tuple (k1, . . . , kq−1, i, kq+1, . . . kd):
δk
def
=Mkj −Mki
θ
def
=
δ
P
k δ+
k
εk
def
=θ · δ+
k
Intuitively, δ+
k is the maximum amount of mass we could move from Mkj to Mki without
causing Mkj < 0 or Mki > B (when δk < 0 then we cannot move any mass in coordinate k),
while θ represents the fraction of maximum mass that equals to the desired δ.
To deﬁne N formally, we introduce some notations. For each variable Xp ∈X and t ∈[np],
let e(X,t) def
= (0, . . . , 0, 1, 0, . . . , 0) where the sole 1 is on position t. Given t = (t1, . . . , td) ∈[n]
denote by D(t) def
= N
p=1,d e(Xp,tp). This tensor has value 1 on position (t1, . . . , td) and 0
everywhere else. Then, we deﬁne:
N
def
=M +
X
k
εk(D(ki) −D(kj))

---

K. Deeds, D. Suciu, M. Balazinska, W. Cai
23:21
Notice that δ = P
k δk > 0, by the assumption that f has no inversion at i, j, and 0 < θ ≤1.
We start by checking that all entries in N are ≥0 and ≤B. The only entries that have
decreased are those in the hyperplane Xq = j:
Nkj =Mkj −θδ+
k ≥Mkj −δ+
k
=Mkj −max(Mkj −Mki, 0) = min(Mki, Mk,j) ≥0
The only entries that have increased are in hyperplane Xp = i:
Nki =Mki + θδ+
k ≤Mki + δ+
k
=Mki + max(Mkj −Mki) = max(Mkj, Mki) ≤B
By Eq. (5) we have:
SUMX−{Xp}
 Dt
=SUMX−{Xp}

O
ℓ=1,d
e(Xℓ,tℓ)

= e(Xp,tp) ⊗
O
ℓ=1,d;ℓ̸=p
SUMXℓ(e(Xℓ,tℓ)) = e(Xp,tp)
because SUMX
 e(Xℓ,tℓ)
= 1. Therefore, SUMX−{Xp}
 D(ki)
is eXp,kp when p̸ = q, and is
eXq,i when p = q, and we obtain:
p̸ = q :
SUMX−{Xp}(N −N) =
X
k
εkSUMX−{Xp}

D(ki) −D(kj)
= 0
p = q :
SUMX−{Xq}(N −N) =
X
k
εkSUMX−{Xq}

D(ki) −D(kj)
=
 X
k
εk
!
(eXq,i −eXq,j) = δ(eXq,i −eXq,j)
proving that SUMX−{Xq}(N) = f ◦τij.
Finally, we check Inequality (31). First, we use the deﬁnition of dot product in Def. 2.1
and Eq. (5) to derive:
D(t) · a(X1) · · · a(Xd) =SUMX

D(t) ⊗a(X1) ⊗· · · ⊗a(Xd)
=SUMX

(e(X1,t1) ⊗a(X1)) ⊗· · · ⊗(e(Xd,td) ⊗a(Xd))

=SUMX1(e(X1,t1) ⊗a(X1)) · · · SUMXd(e(Xd,td) ⊗a(X))
=a(X1)
t1
× · · · × a(Xd)
td
=
Y
p=1,d
a(Xp)
tp
This implies:
(N −M) · a(X1) · · · a(Xd) =
X
k
εk(D(ki) −D(kj)) · a(X1) · · · a(Xd)
=
X
k

εka(Xq)
i
Y
p=1,d;p̸=q
a(Xp)
kp

−
X
k

εka(Xq)
j
Y
p=1,d;p̸=q
a(Xp)
kp


=

a(Xq)
i
−a(Xq)
j
 X
k
εk
Y
p=1,d;p̸=q
a(Xp)
kq
This quantity is ≥0 because i < j and a(Xq) is non-increasing by assumption.
◀
CVIT 2016

---

23:22
Degree Sequence Bound For Join Cardinality Estimation
A.2.2
Proof of Item 1 (a)
Item 1: C is a solution to Problem 2, i.e. C ∈Mf (X),∞and it satisﬁes Eq. (13). Further-
more, it is tight in the following sense: there exists a tensor M ∈M+
f (X),B and non-increasing
vectors a(p) ∈R[np]
+
, p = 1, d, such that inequality (13) (with σ the identity) is an equality.
We split Item 1 into two parts:
(a) C satisﬁes inequality (13) and there exists tensors M, a(p) such that the inequality
becomes an equality, and
(b) C ∈Mf (X),∞.
Here we prove item (a), and defer item (b) to Sec. A.2.6.
We have seen in Lemma A.1 that it suﬃces to take σ to be the identity. Therefore, in
order to C satisﬁes inequality (13), it suﬃces to show that, for all non-decreasing vectors
a(Xp) ∈R[np]
+
, p = 1, d, and for every tensor M ∈M+
f (X),B, the following holds:
M · a(X1) · · · a(Xd) ≤C · a(X1) · · · a(Xd)
(32)
Call a ∈Rn a one-zero vector if a = (1, 1, . . . , 1, 0, . . . , 0). For m = 1, n, denote by b(m)
the one-zero vector with exactly m 1’s. Every non-increasing a ∈Rn
+ is a positive linear
combination of b(m)’s.
a =(a1 −a2)b(1) + (a2 −a3)b(2) + · · · + (an−1 −an)b(n−1) + anb(n)
This implies that, in order to prove inequality (32), it suﬃces to check it when each vector
a(Xp) is some one-zero vector b(Xp,m), where we include Xp in the superscript to indicate
that this is an Xp-vector. We start by observing that the LHS of (32) is:
M · b(X1,m1) · · · b(Xd,md) = (ΣX1 · · · ΣXdM)m
(33)
and similarly for the RHS. Next, by the deﬁnition of Vm in Eq. (16), (ΣX1 · · · ΣXdM)m =
P
s≤m Ms ≤Vm, therefore:
(ΣX1 · · · ΣXdM)m ≤Vm
(34)
Recall that C
def
= ∆X1 · · · ∆XdV . By repeatedly applying Eq. (15), we derive:
ΣX1 · · · ΣXdC = V
(35)
Therefore, we obtain that, for all M ∈M+
f (X),B:
M · b(X1,m1) · · · b(Xd,md) (33),(34)
≤
Vm
(35)
= (ΣX1 · · · ΣXdC)m
(33)
= C · b(X1,m1) · · · b(Xd,md)
which proves (32). Furthermore, if M is the optimal solution to the optimization problem
deﬁning Vm, then (34) is an equality, and so is (32), proving that C is tight. This completes
the proof of item 1.

---

K. Deeds, D. Suciu, M. Balazinska, W. Cai
23:23
A.2.3
Proof of Item 2
Item 2: If there exists any solution C′ ∈M+
f (X),B to Problem 2, then C′ = C.
Assume that C′ satisﬁes the assumptions in item 2. We will use again one-zero vectors. On
one hand, C is a solution to Problem 2, and C′ ∈M+
f (X),B, therefore:
C′ · b(X1,m1) · · · b(Xd,md) ≤C · b(X1,m1) · · · b(Xd,md)
(36)
This implies ΣX1 · · · ΣXdC′ ≤ΣX1 · · · ΣXdC.
On the other hand, C′ is a solution to
Problem 2, therefore, ∀M ∈M+
f (X),B:
M · b(X1,m1) · · · b(Xd,md) ≤C′ · b(X1,m1) · · · b(Xd,md)
We choose M to maximize the LHS, then the LHS becomes Vm:
Vm ≤C′ · b(X1,m1) · · · b(Xd,md) = (ΣX1 · · · ΣXdC′)m
(37)
We have obtained ΣX1 · · · ΣXdC = V
≤ΣX1 · · · ΣXdC′.
The two inequalities imply
ΣX1 · · · ΣXdC = ΣX1 · · · ΣXdC′, therefore C = C′. This completes the proof of item 2.
A.2.4
Linear Algebra Background
For the next four items, 3, 4, 5, and 6, we need to take a deeper look at the structure of
the tensors V , C, through the lens of the dual linear program associated with the primal
linear program that deﬁnes V in Equation (16). Therefore, we introduce a few deﬁnitions
and theorems from linear algebra theory.
Recall that a linear program has the form:
Maximize: cT X
Where: A · X ≤b
X ≥0
The dual has the form:
Minimize: Y T b
Where: Y T A ≥cT
Y T ≥0
Intuitively, each variable in the dual can be thought of as representing a constraint in the
primal. For example, it is known that when variable in the dual is nonzero, then the constraint
that it represents in the primal is tight. More importantly, the dual is important due to the
following Strong Duality Theorem,
▶Theorem A.5. Let X∗and Y ∗be optimal solutions to the primal and dual program,
respectively. Then, the following holds,
cT X∗= Y ∗T b
▶Deﬁnition A.6. A matrix A is totally unimodular iﬀevery square submatrix has a
determinant equal to 0, +1 or −1.
CVIT 2016

---

23:24
Degree Sequence Bound For Join Cardinality Estimation
To prove that a matrix is totally unimodular we state the following known fact:
▶Theorem A.7. If the rows of a matrix A can be separated into sets S1, S2 and satisfy the
following conditions, then A is totally unimodular,
1. Every entry in A is either 0 or 1
2. Every column in A has at most two non-zero entries.
3. If there are two non-zero entries in a column of A, then one entry is in a row in S1 and
the other is in a row in S2.
This unimodularity property is useful because of the following fact,
▶Theorem A.8. If the constraint matrix A of an LP (linear program) is totally unimodular
and b is integral, then there exists an optimal solution X to the primal LP that is integral.
If cT is also integral, then the optimal value is integral.
A.2.5
Proof of Item 3
Item 3 (Formally):
1. If d = 2 then C ≥0; if f (X1), f (X2), B are integral, then C is integral.
2. If d ≥3 and B < ∞then C may be < 0.
We start by proving the positive statement: When d = 2 then C ≥0 and, if the degree
sequences are integral, then so is C.
If A is the matrix of an LP, then the matrix of dual LP is its transpose, AT ; one is totally
unimodular iﬀthe other is. We will prove that, when d = 2 then the LP in Eq. (16) that
deﬁnes V has a matrix that is totally unimodular: this implies that, if both degree sequences
are integral, then V is integral, hence so is C (by Eq. (17)). We review here both the primal
and the dual LP deﬁning V , specialized to the case when d = 2. We denote the two degree
sequences by f ∈R[n1]
+
and g ∈R[n2]
+
(rather than f (X1), f (X2)). For every (p, q) ≤(n1, n2),
the primal and dual LPs are the following:
The primal LP:
Vpq
def
= Maximize:
X
(i,j)≤(p,q)
Mij
(38)
Where: ∀i ≤p :
X
j=1,q
Mij ≤fi
∀j ≤q :
X
i=1,p
Mij ≤gj
∀(i, j) ≤(p, q) : Mij ≤B
The dual LP:
Vpq
def
= Minimize:
X
i≤p
αifi +
X
j≤q
βjgj + B
X
(i,j)≤(p,q)
µij
(39)
Where: ∀(i, j) ≤(p, q) : αi + βj + µij ≥1

---

K. Deeds, D. Suciu, M. Balazinska, W. Cai
23:25
▶Lemma A.9. The matrix A of the LP deﬁning V in (38) is totally unimodular. It follows
that there exists an integral optimal solution α, β, γ of the dual LP. Furthermore, if the two
degree sequences f, g are also integral, then V and C
def
= ∆I∆JV are integral as well.
Proof. Let A be the matrix of the primal LP (38). We show that this matrix is unimodular
by showing that it satisﬁes the conditions of Thm. A.7. We describe the three important
sets of rows in A: (1) Rows that arise from row-sum constraints of the form P
j Mij ≤fi;
let S1 denote this set of rows: |S1| = n1. (2) Rows that arise from column-sum constraints
of the form P
i Mij ≤gj; let S2 denote this set of rows, |S2| = n2. (3) Rows that arise from
pairwise bounds of the form Mij ≤B: there are n1n2 such rows. This can be visualized as
follows where the groups appear in order,
A =




























. . .
0
1
1
1
0
0
0
0
. . .
. . .
0
0
0
0
1
1
1
0
. . .
...
. . .
0
1
0
0
1
0
0
0
. . .
. . .
0
0
1
0
0
1
0
0
. . .
...
1
0
0
0
0
0
0
. . .
0
0
...
0
0
. . .
0
1
0
0
. . .
0
0
...
0
0
. . .
0
0
0
0
0
0
1




























The third group of rows form the n1n2 × n1n2 identity matrix, which has 1 on the
diagonal and 0 everywhere else, because there is one constraint Mij ≤B for every variable
Mij. Consider any square submatrix A0 of A. If it contains any row from the third group of
rows, then that row is either entirely 0 (hence det A0 = 0) or it contains a single value 1,
hence the determinant is equal to that obtained by removing the row and column of that
value 1. Therefore, it suﬃces to prove that the submatrix of A consisting of the ﬁrst two
groups of rows is totally unimodular.
So consider the matrix consisting of the rows in the sets S1 and S2 above. Looking at
our conditions from Theorem A.7, the ﬁrst condition holds immediately (all entries in A
are 0 or 1). The second condition holds because every Mij occurs exactly in one row and
in one column, hence it occurs in exactly two constraints. Lastly, the last condition holds
because the set of rows S1 contain all row-wise constraints for Mij and the rows S2 contain
all column-wise constraints for Mij, hence the two 1-entries will occur one in a row in S1 and
the other in a row in S2. This proves that the conditions Theorem A.7 are satisﬁed, hence A
is totally unimodular.
◀
Next, we will prove that C ≥0, and for that we need a deeper look at the dual LP (39).
Before we do that, we build some intuition by considering a simple example:
▶Example A.10. Consider the 2×2 problem given by the degree sequences f = g = (2B, 1),
where B is some large number, representing the max tuple multiplicity. To compute V
and C, we observe that the following are optimal solutions to the primal LP (38) and dual
CVIT 2016

---

23:26
Degree Sequence Bound For Join Cardinality Estimation
LP (39) respectively:
Primal:
M11 =B
Mij =1
for (1, 1) < (i, j) < (2, 2)M22 = 0
Dual:
α1 = β1 =0
α2 = β2 =1
µ11 = 1µij = 0 for (1, 1) < (i, j) ≤(2, 2)
To check that these are optimal solutions it suﬃces to observe that the objective function
of the primal, P
ij Mij = B + 2, is equal to the objective function of the dual, P
i αifi +
P
j βjgj + B P
ij µij = 1 + 1 + B = B + 2 Notice that the pessimistic matrix is:
C =
2B
1
2B
B
1
1
1
0

The proof of C ≥0 follows from several lemmas. First:
▶Lemma A.11. There exists an optimal solution, α, β, µ, to the dual LP (39) satisfying:
αi ≤αi+1
βj ≤βj+1 ∀i, j
Proof. Suppose that there exists an optimal solution such that αi > αi+1. Let α′, µ′ be an
alternative solution where we swap the values at i and i + 1, i.e. α′
i = αi+1, α′
i+1 = αi, µ′
ij =
µi+1,j, µ′
i+1,j = µij. We can quickly check that this is a valid solution, i.e. it satisﬁes the
constraints for all j,
αi+1 + βj + µi+1,j ≥1 →α′
i + βj + µ′
i,j ≥1
αi + βj + µi,j ≥1 →α′
i+1 + βj + µ′
i+1,j ≥1
Further, we argue that the alternative solution produces at least as large an objective value.
Because the values of µ have simply been swapped at i and i + 1, the sum of the µ values is
the same between the two solutions. Therefore, the diﬀerence in their objective values is the
following,
αifi + αi+1fi+1 −(α′
if(i) + αi+1fi+1) = (αi −αi+1)fi + (αi+1 −αi)fi+1
= (αi −αi+1)(fi −fi+1) ≤0
The ﬁnal inequality comes from the fact that f is non-increasing and αi > αi+1. Therefore,
from any unsorted solution, you can generate an equal or better solution from sorting the
α’s (the same logic holds identically for the β’s). This implies that there exists an optimal
solution with sorted values, proving the lemma.
◀
The combination of Lemmas A.9 and A.11 implies that the solutions to the dual have
the following form:
α =(
0, . . . , 0
| {z }
s values = 0
, 1, . . . , 1)
β =(
0, . . . , 0
| {z }
t values = 0
, 1, . . . , 1)
(i, j) ≤(s, t) : µij = 1 (i, j)̸ ≤(s, t) : µij = 0
In other words, both α, β are 0-1 vectors with 0 ≤s ≤p and 0 ≤t ≤q values equal to 0
respectively, followed by the remainder 1’s. Note that there is a unique optimal s, t for each
sub-matrix problem Vp,q which we denote sp,q, tp,q. As in Theorem 3.2 item 6 we denote by
F = Σf and G = Σg the cumulative degree sequences, i.e. Fk = P
i≤k fi and Gℓ= P
j≤ℓgj.
Therefore the expression for Vpq becomes:
Vp,q = Fp −Fsp,q + Gq −Gtp,q + sp,qtp,qB
(40)

---

K. Deeds, D. Suciu, M. Balazinska, W. Cai
23:27
▶Lemma A.12. If we ﬁx a value of sp,q, the optimal value of tp,q is the smallest t such
that gt+1 ≤sp,q ∗B ≤gt. Similarly, if we ﬁx tp,q, then the optimal value of sp,q is such that
fsp,q+1 ≤tp,q ∗B ≤fsp,q.
Proof. This can be seen by taking the discrete derivative of the above expression with respect
to tp,q,
∆tp,qVp,q = sp,qB −gtp,q
(41)
This demonstrates that if we set t as before, it is the smallest value of t such that increasing
it by 1 would increase Vp,q. This directly implies that it is the optimal integral value of t.
The same logic applies directly to sp,q when tp,q is ﬁxed.
◀
▶Lemma A.13. Using the notation of sp,q, tp,q for the optimal solution to the dual for Vp,q,
sp,q ∈{sp−1,q, p}
tp,q ∈{tp,q−1, q}
(42)
Proof. We ﬁrst note the following. If, s, s′ ≤p −1, and t, t′ ≤q −1, then,
Vp−1,q(s, t) ≤Vp−1,q(s′, t′) ↔Vp,q(s, t) ≤Vp,q(s′, t′)
This is easily checked by noticing Vp,q(s, t) = Vp−1,q(s, t) + fp and similarly Vp,q(s′, t′) =
Vp−1,q(s′, t′) + fp. This implies that if some s < p −1 is optimal for the (p, q) sub-problem,
then it must be optimal for the (p −1, q) sub-problem. Therefore, a new optimal value can
only come from the new
◀
At this point, we list a few useful facts about this structure which are easily checked.
▶Lemma A.14. The following are facts about sp,q, tp,q, Vp,q,
1. sp,q ≥sp−1,q, tp,q ≥tp,q−1
2. tp,q ≤tp−1,q, sp,q ≤sp,q−1
3. Vp,q −Vp−1,q ≤fp, Vp,q −Vp,q−1 ≤gq
Proof. The ﬁrst item comes directly from applying the previous lemma. The second comes
from applying ﬁrst fact and Lmm. A.12. If sp,q ≥sp−1,q and g is non-increasing, then the
description of t for a ﬁxed s immediately implies tp,q ≤tp−1,q. The third comes from the fact
that you could always transition from p −1, q to p, q by setting αp = 1, similarly for q.
◀
Okay, we are now prepared to prove that C > 0 when d = 2.
▶Theorem A.15. In two dimensions, C will have non-negative entries. This is equivalent
to the following two statements,
Vp,q −Vp−1,q ≥Vp,q−1 −Vp−1,q−1
(43)
Vp,q −Vp,q−1 ≥Vp−1,q −Vp−1,q−1
(44)
Proof. We will do this by breaking the problem down into a series of cases based on the
values of sp,q,sp,q−1, and tp,q.
CASE 1: sp,q−1 = sp−1,q−1
This directly implies Vp,q−1 −Vp−1,q−1 = fp. Further, because sp,q ≤sp,q−1 ≤p −1, this
also implies Vp,q −Vp−1,q = fp, proving the ﬁrst inequality.
CASE 2: sp,q−1 = p and sp,q = sp−1,q
CVIT 2016

---

23:28
Degree Sequence Bound For Join Cardinality Estimation
From fact 3, we know Vp,q−1 −Vp−1,q−1 ≤fp, and from sp,q = sp−1,q we know Vp,q −Vp−1,q =
fp, proving the ﬁrst inequality.
CASE 3: sp,q−1 = sp,q = p and tp,q = tp,q−1
From fact 3, we know Vp−1,q −Vp−1,q−1 ≤gq, and from tp,q = tp,q−1 we know Vp,q −Vp,q−1 =
gq, proving the second inequality.
CASE 4: sp,q−1 = sp,q = p and tp,q = q
Because Vp,q = p ∗q ∗B and Vp,q−1 ≤p ∗(q −1) ∗B, we can lower bound the ﬁrst diﬀerence
as Vp,q −Vp,q−1 ≥p · B.
Looking at Vp−1,q −Vp−1,q−1, setting mui,q = 1, βq = 0 and keeping all other variables
consistent with the optimal solution to Vp−1,q−1 is a valid solution to Vp−1,q. This solution
has value Vp−1,q−1 + (p −1)B, so Vp−1,q ≤Vp−1,q−1 + (p −1)B. Therefore, we can upper
bound the diﬀerence Vp−1,q −Vp−1,q−1 ≤(p −1)B. Therefore, the second inequality is true.
Lmm A.13 directly implies that our cases are complete.
◀
Now we prove the negative result.
▶Example A.16. Consider d = 3 dimensions, the degree constraints f = g = (∞, ∞),
h = (∞, 2B) and the max tuple multiplicity B > 0. (Here ∞means “a very large number”,
much larger than B.) Deﬁne:
Here C222 = −B, proving the claim in item 4. It remains to check that C is the pessimistic
tensor, which we do as in Example A.18. Each sub-tensor m1 × m2 × m3, other than the full
tensor 2 × 2 × 2, has all entries = B. Therefore, it is consistent tensor, and the sum of all its
elements is a tight upper bound on the sum all elements of any consistent tensor of that size.
It remains to check the full tensor 2 × 2 × 2. Here the sum is = 6B. Every consistent tensor
M has a sum ≤6B, because:
X
i,j,k=1,2
Mijk =
X
i,j=1,2
Mij1 +
X
i,j=1,2
Mij2
≤4B (because of the bound B) + 2B (because of h2 = 2B) = 6B
The tensor N shown above is a consistent tensor that has the sum = 6B. This proves that
C is the pessimistic tensor.

---

K. Deeds, D. Suciu, M. Balazinska, W. Cai
23:29
A.2.6
Proof of Item 1 (b)
Item 1: C is a solution to Problem 2, i.e. C ∈Mf (X),∞and it satisﬁes Eq. (13). Further-
more, it is tight in the following sense: there exists a tensor M ∈M+
f (X),B and non-increasing
vectors a(p) ∈R[np]
+
, p = 1, d, such that inequality (13) (with σ the identity) is an equality.
We have already proven part of it in Sec. A.2.2. Here, it remains to show the second part,
that C ∈Mf (X),∞. To simplify the notations, we will restrict the proof to d = 3 dimensions,
both here and in the proof of items 4, 5, and 6. This is meant to keep the notations readable
and intuitive, and our discussion generalizes to arbitrary dimensions in a straightforward
manner. We will rename the variables X1, X2, X3 to I, J, K, and the degree sequences to
f ∈Rn1
+ , g ∈Rn2
+ , h ∈Rn3
+ .
We repeat here the linear program (16) deﬁning V , by specializing it to d = 3. For
(m1, m2, m3) ≤(n1, n2, n3), the value Vm1m2m3 is the solution to the following linear program
(all indices i, j, k range over [m1], [m2], [m3] respectively):
Vm1m2m3 = Maximize:
X
(i,j,k)∈[m1]×[m2]×[m3]
Mijk,
Where Mijk ≥0 and:
∀i :
X
jk
Mijk ≤fi, ∀j :
X
ik
Mijk ≤gj, ∀k :
X
ij
Mijk ≤hk, ∀ijk : Mijk ≤B
Equivalently, Vm1m2m3 is the solution to the dual linear program:
Vm1m2m3 = Minimize:
X
i
αifi +
X
j
βjgj +
X
k
γkhk + B
X
ijk
µijk
(45)
Where: αi, βj, γk, µijk ≥0 and: ∀i, j, k : αi + βj + γk + µijk ≥1
In order to prove C ∈Mf (X),∞, we show a stronger result: any sub-tensor of C is
consistent with the degree sequences f (X).
▶Lemma A.17. For any (m1, m2, m3) ≤(n1, n2, n3), let C′ be the [m1] × [m2] × [m3]-
subtensor of C. Then C′ is consistent with the degree sequences f, g, h.
Proof. We will show that SUMJK (C′) ≤f, which proves that C is consistent with f;
consistency with g, h is proven similarly. Let V ′ be the [m1] × [m2] × [m3]-subtensor of V :
SUMJK(C′)
(17)
= SUMJK(∆I∆J∆KV ′) = ∆I (SUMJK (∆J∆kV ′))
(15)
= ∆I ((Vim2m3)i=1,m1) = (Vim2m3 −V(i−1)m2m3)i=1,m1
Consider an optimal dual solution α, β, γ, µ to the (i −1) × m2 × m3 problem (45), which
deﬁnes the value of V(i−1)m2m3. We extended it to a solution to the i × m2 × m3 problem,
by setting αi
def
= 1, γijk
def
= 0 for all j ∈[m2], k ∈[m3]. The expression (45) has increased
by fi. At minimality, the value of Vim2m3 is therefore ≤V(i−1)m2m3 + fi, proving that
(SUMJK(C′))i ≤fi.
◀
A.2.7
Proof of Item 4
Item 4: f B < ∞, then C may not be consistent with B, even if d = 2.
To prove item 4, we given an example where C is inconsistent.
CVIT 2016

---

23:30
Degree Sequence Bound For Join Cardinality Estimation
▶Example A.18. Consider d = 2 dimensions. Let the degree sequences be f = g =
(2B, 2B, B + 1), where B is some large number representing the max tuple multiplicity.
Consider the two matrices below:
C =


2B
2B
B + 1
2B
B
B
0
2B
B
B
0
B + 1
0
0
B + 1


N =


2B
2B
B + 1
2B
B
B
0
2B
B
B −1
1
B + 1
0
1
B


We claim C is the worst-case matrix for the given f, g, B: since C33 > B, this represents an
example of a worst-case matrix that is inconsistent. It suﬃces to check that P
i≤m1,j≤m2 Cij =
Vm1m2 for all m1, m2 ≤3 (see Eq. (35)), i.e. we will show that the sum of the m1 × m2
submatrix of C is the maximum value of the sum of any consistent m1 × m2 submatrix
M. One can check directly that P
i≤m1,j≤m2 Cij = min(P
i≤m1 fi, P
j≤m2 gj), which proves
that any consistent M has P
ij Mij ≤P
ij Cij. To prove equality, we notice that, when
(m1, m2)̸ = (3, 3), the submatrix of C is consistent, hence we have equality. For m1 = m2 = 3,
the full matrix C is not consistent (because C33 > B), but the matrix N shown above is
consistent and has the same sum as C, namely 5B + 1.
A.2.8
Proof of Item 5
Item 5: For any non-increasing vectors a(Xp) ∈R[np]
+
, p = 2, d, the vector C ·a(X2) · · · a(Xd)
is in R[n1]
+
and non-increasing.
Recall that we continue to restrict the discussion to d = 3, in order to simplify the
notation and reduce clutter. The general case is similar, and omitted. The proof of this item
requires two lemmas. First:
▶Lemma A.19. For any vectors x, y ∈Rn, the following “summation-by-parts” holds:
X
i=1,n
(∆x)i · yi =xnyn −
X
i=1,n−1
xi · (∆y)i+1
(46)
The formula is analogous with integration by parts:
R n
0 f ′gdx = fg |n
0 −
R n
0 fg′dx. The
proof follows immediately by expanding and rearranging the LHS as follows:
X
i=1,n
(∆x)i · yi =
X
i=1,n
xiyi −
X
i=1,n
xi−1yi
=
X
i=1,n
xiyi −
X
i=1,n−1
xiyi+1
=xnyn −


X
i=1,n−1
xiyi+1 −
X
i=1,n−1
xiyi


=xnyn −
X
i=1,n−1
xi(∆y)i+1
The second lemma assets that the second discrete derivative of V on any variable is
always ≤0. Recall that V is the value tensor, introduced in Def. 3.1, and we have described
it in terms of a primal linear program, and a dual linear program (45).
▶Lemma A.20. ∆2
IV ≤0, ∆2
JV ≤0, and ∆2
KV ≤0.

---

K. Deeds, D. Suciu, M. Balazinska, W. Cai
23:31
Proof. ∆2
KV ≤0 is equivalent to the statement:
∀(m1, m2, k) ≤(n1, n2, n3)
2Vm1m2(k−1) ≥Vm1m2(k−2) + Vm1m2k
(47)
Consider an optimal dual solution α, β, γ, µ to the m1 × m2 × (k −1) problem. Then
Vm1m2(k−1) is given by the objective function of the dual linear program, i.e. by expres-
sion (45). Denote by w
def
= αk−1fk−1 + B P
ij µij(k−1), i.e. the contribution to (45) of all
terms in the plane K = k −1. On one hand, we derive from this solution a solution to
the m1 × m2 × (k −2) problem by simply removing the variables in the plane K = k −1:
expression (45) decreases by the quantity w, which proves Vm1m2(k−2) ≤Vm1m2(k−1) −w.
On the other hand we can extend the solution to a solution of the m1 × m2 × k problem,
by setting the variables in the plane K = k to those in the plane K = k −1, more precisely
αk
def
= αk−1, µijk
def
= µij(k−1): it is obvious that all new constraints are satisﬁed, and the
expression (45) has increased by w. This implies Vm1m2k ≤Vm1m2(k−1) + w. By adding
these two inequalities we prove (47), as required.
◀
To prove item 5, let a ∈Rn1
+ , b ∈Rn2
+ be non-increasing, and let v
def
= C · a · b. We
need to prove that v ≥0 and that v is non-increasing. We start by proving that v ≥0
and for that it suﬃces to assume that both a and b are one-zero vectors, because any
non-decreasing vector is a non-negative linear combination of one-zero vectors (see Sec. 3).
Suppose the ﬁrst m1 values in a are 1 and the others are 0, and similarly the ﬁrst m2 values
in b are 1 and the others are 0. Then, using an argument similar to that in Eq. (33) we have
(C · a · b)k = P
(i,j)≤(m1,m2) Cijk and therefore:
vk =(C · a · b)k = (ΣIΣJC)m1m2k = (ΣIΣJ∆I∆J∆KV )m1m2k = (∆KV )m1m2k = Vm1m2k −Vm1m2(k−1)
The value Vm1m2(k−1) is deﬁned by a m1 × m2 × (k −1) linear program in Eq. (16). Let
M be the optimal solution, such that Vm1m2(k−1) = P
(i,j,p)≤(m1,m2,k−1) Mijp. We deﬁne a
new tensor M ′ obtained from M by setting M ′
ijk
def
= 0 and setting M ′
ijp = Mijp when p̸ = k.
Then M ′ is a feasible solution to the m1 × m2 × k-linear program Eq. (16), proving that, at
optimality, Vm1m2k ≥P
(i,j,p)≤(m1,m2,k) M ′
ijp = Vm1m2(k−1), proving that vk ≥0.
Next we prove that v is non-increasing, or, equivalently, that ∆Kv is ≤0. By deﬁnition,
vk
def
= (C·a·b)k = P
ij Cijkaibj. Since C = ∆I∆J∆KV , the summation-by parts formula (46)
allows us to move the derivatives ∆I∆J from V to a, b and obtain the following:
∆K

X
ij
Cijkaibj

(17)
= ∆K

X
ij
(∆I∆J∆KVijk) aibj

= ∆2
K

X
j
 
∆J
X
i
(∆IVijk)ai
!
bj


X
j
 
∆J
X
i
(∆IVijk)ai
!
bj
(46)
=

X
j
 
∆J
 
Vn1jkan1 −
X
i
Vijk(∆Ia)i+1
!!
bj


=

X
j
(∆J (Vn1jkan1)) bj

−

X
j
 
∆J
 X
i
Vijk(∆Ia)i+1
!!
bj


(46)
= (Vn1n2kan1bn2) −

X
j
Vn1jkan1(∆Jb)j+1

−
 X
i
Vin2k(∆Ia)i+1bn2
!
+
(48)

X
ij
Vijk(∆Ia)i+1(∆Jb)j+1


(49)
CVIT 2016

---

23:32
Degree Sequence Bound For Join Cardinality Estimation
(In general, for d ≥3, this expression is a sum of 2d−1 terms.) Therefore:
∆K

X
ij
Cijkaibj

=
 ∆2
K(Vn1n2k)an1bn2

−

X
j
∆2
K(Vn1jk)an1(∆Jb)j+1


(50)
−
 X
i
∆2
K(Vin2k)(∆Ia)i+1bn2
!
+

X
ij
∆2
K(Vijk)(∆Ia)i+1(∆Jb)j+1


(51)
Since a, b are non-increasing, we have ∆Ia ≤0 and ∆Jb ≤0. By Lemma A.20 each term
∆2
KV is ≤0, which proves that the expression (51) is ≤0.
A.2.9
Proof of Item 6
Finally, we prove item 6, and continue to restrict the discussion to d = 3 dimensions.
Item 6:
Assume B = ∞. Then the following holds:
∀m ∈[n] :
Vm = min

F (X1)
m1
, . . . , F (Xd)
md

(52)
where F (Xp)
r
def
= P
j≤r f (Xp)
j
is the CDF associated to the PDF f (Xp), for p = 1, d. Moreover,
C can be computed by Algorithm 1, which runs in time O(P
p np). This further implies that
C ≥0, in other words C ∈M+
f (X),∞.
We start by showing Eq. (18): for all (m1, m2, m3) ≤(n1, n2, n3), Vm1m2m3 = min(Fm1, Gm2, Hm3).
Assume w.l.o.g. that Fm1 = min(Fm1, Gm2, Hm3). We claim that the following is an optimal
solution to the dual program (45): α = (1, 1, · · · , 1), β = 0, γ = 0, µ = 0: the claim
implies that the value of Vm1m2m3 given by Eq. (45) is Vm1m2m3 = P
i=1,m1 αifi = Fm1, as
required. To prove the claim, let α, β, γ be any optimal solution to the dual; obviously,
µ = 0, because B = ∞. We ﬁrst ﬁnd another optimal solution where γ = 0. Denoting
ε
def
= minij(αi + βj), we have γk ≥1 −ε for all k. Deﬁne α′
i
def
= αi + (1 −ε) for all i, and
γ′
k
def
= 0. Then α′, β, γ′ is also a feasible solution, and the value of (45) is no larger, because:
P
i α′
ifi = P
i αifi + (1 −ε) P
i fi ≤P
i fiαi + (1 −ε) P
k hk ≤P
i fiαi + P
k γkhk. We
repeat this for β (and omit the details, for lack of space) and obtain a new feasible solution
α′′, β′(= 0), γ′(= 0) where the value of Eq. (45) is still optimal, proving the claim.
It remains to prove that Algorithm 1 is correct. We show that if f, g, h are any 3
vectors (not necessarily decreasing) then the tensor C computed by the algorithm satisﬁes
ΣIΣJΣKC = min(F , G, H), i.e. P
i=1,m1
P
j=1,m2
P
k=1,m3 Cijk = min(Fm1, Gm2, Hm3)
(correctness follows from (34)). Assume w.l.o.g. that f1 = min(f1, g1, h1); then the algorithm
sets C111 = f1 and leaves C1m2m3 = 0 for all (m2, m3)̸ = (1, 1) (since C is initially 0).
Therefore the claim holds for m1 = 1: P
j=1,m2
P
k=1,m3 C1ij = f1. For m1 > 1, denote
by C′ the rest of the tensor produced by the algorithm, i.e. using f ′ def
= (f2, f3, . . . , fn1),
g′ def
= (g1 −f1, g2, . . . , gn2) and h′ def
= (h1 −f1, h2, . . . , hn3). Then:
X
i=1,m1
X
j=1,m2
X
k=1,m3
Cijk = f1 +
X
i=2,m1
X
j=1,m2
X
k=1,m3
C′
ijk
=f1 + min(F ′
m1, G′
m2, H′
m3)
/* by induction on C′ */
= min(f1 + F ′
m1, f1 + G′
m2, f1 + H′
m3) = min(Fm1, Gm2, Hm3)

---

K. Deeds, D. Suciu, M. Balazinska, W. Cai
23:33
because f1 + F ′
m1 = f1 + P
i=2,m1 fi = Fm1, f1 + G′
m2 = f1 + (g1 −f1) + P
j=2,m2 gj = Gm2
and similarly f1 + H′
m3 = Hm3.
A.3
Proof of Theorem 4.1
We ﬁrst illustrate Algorithm 2 with an example.
▶Example A.21. Let:
Q(X, Y, Z, U) := R(X, Y ) ⋊⋉S(Y, Z) ⋊⋉T(Z, U) ⋊⋉K(U)
Assume we are given degree sequences for each attribute of each relation, and compute the
corresponding worst case tensors (one for each relation): C(R), C(S), C(T ), C(K): the ﬁrst
three are matrices, the last is a vector. The degree sequence bound is:
SUMXY ZU

C(R) ⊗C(S) ⊗C(T ) ⊗C(K)
=
X
xyzu
C(R)
xy C(S)
yz C(T )
zu C(K)
u
Algorithm 2 allows us to compute this expression as follows. We choose any relation to desig-
nate as root: we will chose (arbitrarily) S as the root, associate a vector a(X), a(Y ), a(Z), a(U)
to each variable, and a vector w(R), w(S), w(T ), w(K) to each relation. Then, we compute
the degree sequence bound as follows, where we show the type of each vector, assuming that
the domains of the variables X, Y, Z, U are [nX], [nY ], [nZ], [nU] respectively:
a(U) :=C(K)
∈R[nU]
+
w(T ) :=C(T ) · a(U)
∈R[nZ]
+
a(Z) :=w(T )
∈R[nZ]
+
a(X) :=1
∈R[nX]
+
= the column vector (1, 1, · · · , 1)T , since X has no children
w(R) :=C(R) · a(X)
∈R[nY ]
+
a(Y ) :=w(R)
∈R[nY ]
+
return

C(S) · a(Y ) · a(Z)
We now turn to the proof of Theorem 4.1, and begin by making two observations. Let T
be the incidence graph of the query (Sec. 2), and recall that in this paper we always assume
that T is an undirected tree. First, consider any relation R ∈R, and assume w.l.o.g. that
its variables are XR = {X1, . . . , Xk}. By removing the node R from the tree, we partition
the tree into k disjoint connected components, each containing one of the variables Xi. Then
we can group the products in Eq. (10) into k + 1 factors::
Eq. (10) =SUMX

M (R) ◦σ(R)
⊗E1 ⊗· · · ⊗Ek

where Ei is the tensor expression containing all relations in the i’th component. Let the
variables of Ei be {Xi} ∪Yi, therefore X = XR ∪Y1 ∪· · · ∪Yk, and deﬁne bi
def
= SUMYi(Ei),
i.e. we sum out all variables other than Xi to obtain a vector bi. Using Eq. (5) we derive:
Eq. (10) =SUMXR

M (R) ◦σ(R)
⊗(SUMY1E1) ⊗· · · ⊗(SUMYkEk)

(53)
= SUMXR

M (R) ◦σ(R)
⊗b1 ⊗· · · ⊗bk

(54)
CVIT 2016

---

23:34
Degree Sequence Bound For Join Cardinality Estimation
Second, we will compute the expression (10) bottom-up on the tree, following Algorithm 2.
Recall that the algorithm works by choosing arbitrarily a variable X0 ∈X to designate as
root of the tree T, then orienting the tree such that all edges point away from the root. Each
relation R has a unique parent variable, call it X1, and zero or more children, call them
X2, . . . , Xk. Algorithm 2 computes the expression (10) bottom up, by computing a Z-vector
a(Z) for each variable Z, and an X1-vector w(R) for each relation R with parent X1. Then,
expression (10) is equal to SUMX0(a(X0)).
We can now describe the proof formally. Call a subset S ⊆X ∪R closed if, for any node
in S, all its children (in the directed tree T) are also in S.
▶Deﬁnition A.22. A set S ⊆X ∪R is good if it is closed and satisﬁes the following two
conditions:
1. The following inequality holds:
Eq. (10) = SUMX
 O
R∈R
(M (R) ◦σ(R))
!
≤SUMX
  O
R∈S
Cf (R,XR),B(R)
!
⊗
 O
R∈R−S
(M (R) ◦σ(R))
!!
(55)
In other words, the value of the expression (10) does not decrease if we substitute each
tensor
 M (R) ◦σ(R)
for R ∈S, with Cf (R,XR),B(R).
2. Consider running Algorithm 2 to compute the RHS of Eq. (55). Then for every variable
Z ∈S, the vector a(Z) is non-negative and non-increasing.
We will prove that the entire set X ∪R is good, and for that we prove the following claim.
▷Claim 1.
Suppose S is good, and let X̸ ∈S (or R̸ ∈S) be any variable (or a relation
name) that is not in S such that all its children are in S. Then S ∪{X} (or S ∪{R}
respectively) is also good.
The claim immediately implies that X ∪R is good, because we start with S = ∅, which
is trivially good, then add one by one each variable and each relation name to S, until
S = X ∪R. It remains to prove the claim.
Proof. (Of Claim 1) We consider two cases, depending on whether the node that we want to
add to S is a relation name or a variable.
Case 1. There exists a relation R̸ ∈S that is not yet in S, such that all its children
X2, . . . , Xk are in S. We partition the expression (10) as before:
Eq. (10) =SUMX

M (R) ◦σ(R)
⊗E1 ⊗· · · ⊗Ek

For each i = 2, k let ˆEi be the expression obtained by substituting every tensor

M (R′) ◦σ(R′)
occurring in Ei with Cf (R′,XR′ ),B(R′). Since all children X2, . . . , Xk of R are in are S, it
follows that reach relation name that occurs in E2, . . . , Ek is in S. Since S is good, this
implies:
SUMX

M (R) ◦σ(R)
⊗E1 ⊗· · · ⊗Ek

≤SUMX

M (R) ◦σ(R)
⊗E1 ⊗ˆE2 ⊗· · · ⊗ˆEk

We now use the argument in Eq. (54):
SUMX

M (R) ◦σ(R)
⊗E1 ⊗ˆE2 ⊗· · · ⊗ˆEk

=
SUMXR

M (R) ◦σ(R)
⊗(SUMY1E1) ⊗

SUMY2 ˆE2

⊗· · · ⊗

SUMYk ˆEk


---

K. Deeds, D. Suciu, M. Balazinska, W. Cai
23:35
As before we denote by b1 = SUMY1E1, but notice that, for all i = 2, k, the expression
SUMYi ˆEi is precisely the vector a(Xi) used in the bottom-up computation of Algorithm 2:
SUMXR

M (R) ◦σ(R)
⊗(SUMY1E1) ⊗

SUMY2 ˆE2

⊗· · · ⊗

SUMYk ˆEk

=
SUMXR

M (R) ◦σ(R)
⊗b1 ⊗a(X2) ⊗· · · ⊗a(Xk)
Since S is good, it follows that the vectors a(X2), . . . , a(Xk) are already sorted. We sort b1
as well, by applying some permutation τ, and obtain:
SUMXR

M (R) ◦σ(R)
⊗b1 ⊗a(X2) ⊗· · · ⊗a(Xk)
=
SUMXR

M (R) ◦σ(R) ◦(τ, id, . . . , id)

⊗(b1 ◦τ) ⊗a(X2) ⊗· · · ⊗a(Xk)
Since all vectors b1 ◦τ, a(X2), . . . , a(Xk) are sorted, we can use item 1 of Theorem 3.2 to
derive:
SUMXR

M (R) ◦σ(R) ◦(τ, id, . . . , id)

⊗(b1 ◦τ) ⊗a(X2) ⊗· · · ⊗a(Xk)
≤
SUMXR

Cf (R,XR),B(R) ⊗(b1 ◦τ) ⊗a(X2) ⊗· · · ⊗a(Xk)
Combining all inequalities above implies:
Eq. (10) ≤SUMXR

Cf (R,XR),B(R) ⊗(b1 ◦τ) ⊗a(X2) ⊗· · · ⊗a(Xk)
which proves that S ∪{R} is good. This completes the proof of Case 1.
Case 2 Suppose there exists a variable X̸ ∈S such that all its children relations
R1, R2, . . . , Rm are in S. Let Ri be one of its children. Since Ri is in S, by induction
hypothesis its tensor in the RHS of Eq. (55) is the pessimistic tensor C
def
= Cf
(Ri,XRi ),B(Ri).
Let X2, . . . , XK be the other variables of Ri (i.e. other than its parent variable X). Since
S is closed, we have X2, . . . , Xk ∈S, and, since S is good, it follows that the vectors
a(X2), . . . , a(Xk) are non-negative, and non-increasing. Algorithm 2 computes w(Ri), as
follows:
w(Ri) :=C · a(X2) · · · a(Xk)
Item 1 of Theorem 3.2 implies that w(Ri) is also non-negative and non-decreasing. Next, the
algorithm computes a(X) as:
a(X) :=w(R1) ⊗· · · ⊗w(Rm)
where the tensor product is an element-wise product. Since each w(Ri) is non-negative and
non-decreasing, their product a(X) will also be non-negative and non-decreasing, as required.
Thus, S ∪{X} is also good, which completes the proof of case 2.
◀
A.4
Chain Bound for Berge Acyclic Queries (Theorem 4.3)
In this section we review the polymatroid bound, then prove its closed form expression for
Berge-acyclic queries stated in Theorem 4.3.
Background on Information Theory We need to review some notions from informa-
tion theory. Fix a set of variables X. A polymatroid is a function h : 2X →R+ satisfying
the following three conditions, where X, Y are sets of variables.
CVIT 2016

---

23:36
Degree Sequence Bound For Join Cardinality Estimation
h(∅) =0
h(X ∪Y ) ≥h(X)
h(X) + h(Y ) ≥h(X ∪Y ) + h(X ∩Y )
The last two conditions are called monotonicity and submodularity. We follow standard
convention and write XY for the union X ∪Y . A conditional expression is deﬁned
h(Y |X)
def
=h(XY ) −h(X)
Given a joint distribution over random variables X, we denote by H its entropy. Then
the mapping Z(⊆X) 7→H(Z) is a polymatroid. When X has 4 or more variables, then
there exists polymatroids h that are not entropic functions.
The polymatroid Bound The polymatroid bound was introduced in [15, 14]. A good
overview can be found in [19]. We review it here brieﬂy.
Fix a general conjunctive query Q, not necessarily Berge-acyclic. Recall that NR and
f (R,Z)
1
denote the upper bound on the cardinality of R and of the maximum degree of its
variable Z. The original deﬁnition also considers max degrees for sets of variables, but in
this paper we restrict to a single variable. Denote by HDC (“degree constraints applied to
h”) the following set of constraints on a polymatroid h:
HDC :
∀R ∈R(Q) :
h(XR) ≤log NR
∀Z ∈XR :
h(XR|Z) ≤log f (R,Z)
1
(56)
The polymatroid bound of a query Q, which we denote here by PB(Q), is deﬁned in [14,
Theorem 1.5] by specifying its logarithm:
log(PB(Q))
def
= max{h(X) | h is a polymatroid that satisﬁes HDC}
(57)
More precisely, PB(Q) is the exponent of the RHS of the expression above. Since HDC,
the monontonicity, and the submodularity constraints are all linear inequalities, it follows
that log(PB(Q)) can be computed by solving a linear optimization problem. When the
query has 4 or more variables, then the polymatroid bound is not tight in general.
Linear Inequalities An alternative way to describe the polymatroid bound uses linear
inequalities, which we describe next.
Fix a vector c ∈R2X.
We view the vector as deﬁning a linear expression E over
polymatroids, namely:
E(h)
def
=
X
V ⊆X
cV h(V )
(58)
We will assume that c has integer coeﬃcients, and consider linear inequalities of the form:
E(h) ≥0
(59)
We say that the inequality (59) is valid for all polymatroids, or valid for all entropic functions,
if it holds for all polymatroids h, or for all entropic functions H respectively.
The Polymatroid Bound through Inequalities Given a conjunctive query Q, we
say that a linear expression E(h) is associated to the query Q if it has the form:
E(h)
def
=
X
R∈R(Q)
aRh(XR) +
X
R∈R(Q),Z∈XR
bR,Zh(XR|Z)
(60)

---

K. Deeds, D. Suciu, M. Balazinska, W. Cai
23:37
where all coeﬃcients aR, bR,Z, k are natural numbers. In other words the linear expression
contains only the terms h(XR) and h(XR|Z) that are also used in the HDC constraints. If
the inequality E(h) ≥k · h(X) is valid for all polymatroids h, then the following holds for
the polymatroid bound PB(Q):
k · log PB(Q) ≤
X
R
aR log NR +
X
R,Z∈XR
bR,Z log(f (R,Z)
1
)
(61)
By applying Farkas’ lemma one can prove that there exists a valid inequality for which (61)
becomes an inequality. In other words, one could compute PB(Q) by trying out all (inﬁnitely
many) linear expressions E(h) associated to Q, trying all numbers k, then take the minimum
of the expression (61) where the inequality E(h) ≥k · h(X) is valid.
▶Example A.23. We continue with the query Q = R(X, Y ), S(Y, Z), T(Z, U), K(U, V ) in
Example 4.4. The following are valid inequalities associated to Q:
h(Y Z) + h(X|Y ) + h(U|Z) + h(V |U) ≥h(XY ZU)
h(XY ) + h(ZU) + h(V |U) ≥h(XY ZU)
h(XY ) + h(UV ) + h(Z|U) ≥h(XY ZU)
h(XY ) + h(ZU) + h(UV ) ≥h(XY ZU)
3h(XY ) + h(Y Z) + h(ZU) + h(UV ) + h(X|Y ) + h(U|Z) + h(Z|U) + 2h(V |U) ≥4h(XY ZU)
All ﬁve are valid inequalities for polymatroids. The ﬁrst four are easy to check directly, and
the ﬁfth is simply the sum of the ﬁrst four (and thus is also valid). These inequalities lead to
the following upper bounds on PB(Q):
PB(Q) ≤f (R,Y )
1
NSf (T,Z)
1
f (K,U)
1
PB(Q) ≤NR · NT f (K,U)
PB(Q) ≤NR · f (T,U)Nk
PB(Q) ≤NR · NT · NK
PB(Q) ≤

N 3
RNSNT NUf (R,Y )
1
f (T,Z)
1
f (T,U)
1

f (K,U)
1
21/4
Notice that the last expression is the geometric mean of the ﬁrst four.
Term Cover We describe a simple necessary (but not suﬃcient) condition for an
inequality to be valid for all entropic functions. We say that a term h(V ) in E(h) covers a
set of variables U ⊆X, if U ∩V̸ = ∅. For any linear expression E(h) = P
V cV h(V ) deﬁne
the coverage of U by E as:
cover(U, E)
def
=
X
V :V ∩U̸=∅
cV
Once can check that, if E(h) ≥0 holds for all entropic functions, then ∀U ⊆X, if U̸ = ∅,
then cover(U, E) ≥0, by observing that cover(U, E) is the value of E(h) computed on
the following polymatroid, called a step function: h(V )
def
= 0 if V ∩U = ∅and h(V )
def
= 1
otherwise. In fact, h is an entropy, namely it is the entropy of the following probability space:
U
X −U
0 · · · 0
0 · · · 0
1/2
1 · · · 1
0 · · · 0
1/2
CVIT 2016

---

23:38
Degree Sequence Bound For Join Cardinality Estimation
Simple Inequalities While a characterization of general information-theoretic inequal-
ities is still open, a complete characterization was described in [11] for a restricted class.
We present here a slightly more general version than stated in Theorem 3.9 (ii) [11], which
follows immediately by using the same Lemma 3.10 as done in [11].
A simple expression is a linear expression of the form:
E(h)
def
=
X
V ⊆X
aV h(V ) −
X
Z∈X
bZh(Z)
(62)
where all coeﬃcients are natural numbers. In other words, E must have only non-negative
coeﬃcients, except for singleton terms h(Z), where Z is a single variable, which may be
negative. A simple inequality is an inequality of the form:
E(h) ≥k · h(X)
(63)
where E is a simple inequality. The following was proven in [11].
▶Theorem A.24. Consider a simple expression E(h), as in Eq. (62).Then the following are
equivalent:
1. The inequality E(h) ≥kh(X) is valid for all polymatroids.
2. The inequality E(h) ≥kh(X) is valid for all entropic functions.
3. For every set of variables U̸ = ∅, cover(U,E) ≥k.
In other words, the suﬃcient condition mentioned earlier becomes a necessary condition,
in the case of simple inequalities.
We are interested in simple expression of a special form. A conditional simple expression
is:
E(h)
def
=
X
U,Y ⊆X
cV |Y h(V |Y )
(64)
where cV |Y ≥0 and whenever cV |Y > 0 then Y is either ∅or a single variable. We prove:
▶Lemma A.25. Consider a simple expressions E as in (62), and suppose that for every
set of variables U, cover(U, E) ≥0. Then E can be written (not uniquely) as a conditional
simple expression, i.e. as in (64).
Every linear expression E associated to a Berge-acyclic query, as in Equation (60) is
a conditional simple expression and, therefore, it is also a simple expression, once we
expand the conditionals. The lemma provides a simple test for the converse to hold: take
a simple expression and regroup it so it becomes associated to a query.
For example,
h(XY ) + h(Y Z) + h(ZU) −h(Y ) −h(Z) can be rearranged as h(X|Y ) + h(Y Z) + h(U|Z),
and is associated to a Berge-acyclic query R(X, Y ), S(Y, Z), T(Z, U), but the expression
E = h(XY )+h(Y Z)+h(UV )−h(X)−h(Y )−h(Z) cannot, because cover(XY Z, E) = −1.
Proof. (of Lemma A.25) Recall that the coeﬃcients aV , bZ of E are natural numbers.
Consider the following bipartite graph G = (Nodes1, Nodes2, Edges). For the set Nodes1
we create, for Z ∈X, bZ nodes labeled h(Z). For the set Nodes2 we create, for each
V ⊆X, aV nodes labeled h(V ). Finally, we connect two nodes h(Z), h(V ) if Z ∈V .
Next, we use Hall’s theorem to prove that this bipartite graph has a maximal matching,
and, for that, it suﬃces to check that, for each subset S ⊆Nodes1, |N(S)| ≥|S|, where
N(S) are the neighbors of the nodes in S. If S includes some node labeled h(Z), then we

---

K. Deeds, D. Suciu, M. Balazinska, W. Cai
23:39
can assume w.l.o.g. that it includes all bZ copies, otherwise we simply add them, which
only increases S but does not aﬀect N(S). Therefore, S is uniquely deﬁned by a set of
variables U ⊆X, and |S| = P
Z∈U bZ, while |N(S)| = P
V ⊆X,U∩V̸ =∅aV . It follows that
|N(S)| −|S| = cover(U, E) ≥0. By Hall’s theorem, the graph admits a maximal matching,
in other words every node h(Z) is uniquely matched with some h(V ) where Z ∈V , hence we
combine the two terms h(V ) −h(Z) = h(V |Z). The lemma follows from here.
◀
Chain Expressions We deﬁne a connected, simple chain expression an expression of
the form:
E(h)
def
=h(U0) + h(U1|Z1) + · · · + h(Uk|Zk)
(65)
where U0, U1, . . . , Uk form a partition of the variables X, for all i = 1, k, Zi is a single
variable, and Zi ∈U0 ∪U1 ∪. . . ∪Ui−1.
A chain expression is the simplest linear expression we can associate to a Berge-acyclic
query Q. Namely, choose arbitrarily a root relation ROOT ∈R(Q), orient its tree and, as in
Section 4.2, denote by ZR ∈XR the parent variable of the relation R, i.e. connecting R to
ROOT. The connected, simple chain expression associated to Q is:
EQ(h)
def
=h(XROOT) +
X
R∈R(Q),R̸=ROOT
h(XR −{ZR}|ZR)
(66)
The inequality EQ(h) ≥h(XR) is valid, and deﬁnes the following bound on PB(Q) (see
Equation (61)):
PB(Q) ≤NROOT ·
Y
R̸=ROOT
f (R,ZR)
1
= PB(Q, ROOT)
where is precisely the expression PB(Q, ROOT) deﬁned in Sec. 4. We also observe that EQ
does not depend on the choice of the root relation R (but the bound PB(Q, ROOT) does
depend!). To see this, denote by atomsQ(Z) the set of atoms R ∈R(Q) that contain the
variable Z, and observe that:
EQ(h) =
X
R∈R(Q)
h(XR) −
X
Z∈X
(|atomsQ(Z)| −1) · h(Z)
Recall from Sec. 4 that a cover of Q is a set W = {Q1, . . . , Qm} where each Qi is a connected
subquery of Q, and each variable of Q occurs in at least one Qi. The simple chain expression
associated to W is:
EW (h) =EQ1(h) + · · · + EQm(h)
(67)
One can check that EW (h) ≥h(X) is a valid inequality, and that EW is an expression
associated to Q, in the sense that it is of the form (60). If we write each EQi as a conditional
simple expression, i.e. as in (66), by choosing some root relation ROOTi, then it deﬁnes the
following bound on PB(Q) (see Equation (61)):
PB(Q) ≤
Y
i=1,m
PB(Qi, ROOTi)
(68)
where PB(Qi, ROOTi) was deﬁned in Equation (22), and the form |ROOTi| Q
R f (R,ZR)
1
, i.e. the
cardinality of ROOTi times the max degrees of the other relations in the i’th component. We
prove that every valid inequality associated to the query is some combination of inequalities
of this form:
CVIT 2016

---

23:40
Degree Sequence Bound For Join Cardinality Estimation
▶Theorem A.26 (Chain Decomposition). Let Q be a Berge-acyclic query, and let E(h) be
an expression associated to Q, as shown in Equation (60), where all coeﬃcients aR, bR,Z are
natural numbers. If E(h) ≥k · h(X), then there exists k covers W1, . . . , Wk, not necessarily
distinct, such that:
E(h) =
X
i
EWi(h) + (· · · )
where (· · · ) represents a sum of positive terms (i.e. some h(V )’s or some h(V |Z)’s).
In other words, the inequality E(h) ≥k · h(X) is (implied by) the sum of k chain
inequalities EWi(h) ≥h(X). Theorem 4.3 follows immediately from here. Indeed, each chain
inequality EWi(h) ≥h(X) deﬁnes a bound on PB(Q) of the form (68), and this is precisely
the form used in Theorem 4.3. The original inequality E(h) ≥k · h(X) deﬁnes a bound that
is no better than their geometric means, which, in turn, is no better than the smallest of
these bounds. It follows that the minimum bound over everything we can derive from a valid
inequality E(h) ≥k · h(X), can be already derived from a chain inequality, and that leads
to a bound of the form (68). It remains to prove Theorem A.26.
Proof of Theorem A.26 Consider any valid inequality E(h) ≥kh(X) associated to
the query Q (Equation (60)), i.e. all terms in E(h) correspond to atoms in the query,
possibly conditioned by one of their variables.
After expanding the conditional terms,
h(XR|Z) = h(XR) −h(Z), we can write the expression as:
E(h) =
X
R∈R(Q)
aRh(XR) −
X
Z∈X
bZh(Z)
where aR, bZ are natural numbers. Since E(h) is a simple expression, the inequality E(h) ≥
k · h(X) is valid iﬀcover(U, E) ≥k for all sets of variables U.
Let Z be some private variable, in other words it occurs in only one relation R, and
suppose bZ > 0. In that case we must also have aXR ≥bZ, otherwise cover(Z, E) < 0.
Write aR · h(XR) −bZ · h(Z) = (aR −bZ) · h(XR) + bZh(XR) −bZ · h(Z) = (aR −bZ) ·
h(XR) + bZ · h(XR|Z).
We claim that we can remove bZ · h(XR|Z) from E, and the
resulting expression E0 still satisﬁes the inequality E0(h) ≥k · h(X). To prove the claim
it suﬃces to check cover(U, E0) ≥k for all U ⊆X. If Z ∈U or U ∩XR = ∅, then
cover(U, E0) = cover(U, E) ≥k, hence it suﬃces to assume Z̸ ∈U, and U ∩XR̸ = ∅. In
that case we prove that cover(W, E0) = cover(WZ, E0), and the latter is ≥k as we saw.
The only term in E0 that covers Z is (aXR −bZ) · h(XR), and this also covers W, which
proves cover(W, E0) = cover(WZ, E0). Therefore, we can assume w.l.o.g. that no isolated
variables Z occur in the expression E.
We prove now the theorem by induction on the number of relations in Q. If Q has a
single relation R(X), then all variables are isolated, hence E must be aXh(X), and since
every variable is covered ≥k times, we have aX ≥k.
Assume Q has > 1 atoms, let R be a leaf relation, and let Q′ be the query without the
relation R; we assume that the theorem holds for Q′. Since Q is Berge-acyclic, there exists a
single variable Z ∈XR that also occurs in Q′. Therefore, E(h) can be written as:
E(h) =aXR · h(XR) −bZ · h(Z) + E′(h)
where E′(h) contains the remaining terms of the expression E(h), and thus, is an
expression associated to the query Q′, i.e. it only contains terms that correspond to atoms

---

K. Deeds, D. Suciu, M. Balazinska, W. Cai
23:41
and variables in Q′. Let X′ be the variables of Q′. Our plan is to apply induction hypothesis
to Q′, and for that we check the coverage in E′ of sets of variables U ′ ⊆X′. If Z̸ ∈U ′, then
cover(U ′, E′) = cover(U ′, E) ≥k. If Z ∈U ′, then we may have cover(U ′, E′) < k. Deﬁne:
k′ def
= min
U ′⊆X′ cover(U ′, E′)
and let U ′ ⊆X′ a set s.t. cover(U ′, E′) = k′ (i.e. argmin of the expression above). Assuming
k′ < k, we must have Z ∈U ′ (the case when k′ ≥k is simple, because in that case E′ already
satisﬁes E′(h) ≥k · h(X′), and we omit it).
We use the fact that cover(U ′, E) = aXR −bZ + cover(U ′, E′) = aXR −bZ + k′ ≥k and
derive that aXR = δ + (k −k′) + bZ, for some δ ≥0. This implies:
E(h) =aXR · h(XR) −bZ · h(Z) −(k −k′) · h(Z) + ((k −k′) · h(Z) + E′(h))
(69)
=δ · h(XR) + ((k −k′) + bZ) · h(XR|Z) +



(k −k′) · h(Z) + E′(h)
|
{z
}
def
= E′′(h)




(70)
Let X′ denote the variables of the query Q′, including Z. Once can check that, for all
U ⊆X′, cover(U, E′′) ≥k. Indeed, if Z̸ ∈U then cover(U, E′′) = cover(U, E′) ≥k as we
argued earlier, and if Z ∈U then:
cover(U, E′′) = (k −k′) + cover(U, E′) ≥(k −k′) + k′ = k
Therefore, E′′(h) ≥kh(X′) is a valid simple inequality, and, by induction on the query Q′,
we can write E′′ as:
E′′(h) =
X
i=1,k
EW ′
i (h) + (· · · )
(71)
where each W ′
i is a cover of Q′ and (· · · ) hides some positive terms. In other words, E′′(h)
is written as a sum of simple chain expressions associated to covers W ′
i of Q′. We prove now
that E(h) can also be written as a sum of simple chain expressions associated to covers of
Q. For that, we take the ﬁrst terms in (70), argue that there are at least k of them, and
combine each with one of the covers W ′
i .
More precisely, we consider two cases. First, if the relation we have eliminated, R, has no
private variables. In other words XR = {Z}. In that case E′′(h) is already of the required form
by the theorem, since it contains all variables of Q. Second, suppose R has at least one private
variable, call it Y . Then, from Eq. (70) we obtain cover(Y, E) = δ + ((k −k′) + bZ) ≥k.
This means that we can produce k terms, either h(XR) or h(XR|Z), and write E(h) as a
sum of k terms, where each term has one of these two forms:
h(XR) + EW ′
i (h)
h(XR|Z) + EW ′
i (h)
In the ﬁrst case we extend the cover W ′
i with one new set {R}, and denote the resulting
cover of Q by Wi. In the second case we extended the cover by including R in the set
containing some other relation that contains Z (if there are multiple such sets, we choose
one arbitrarily) and denote Wi the resulting cover of Q. In both bases, the expression above
becomes EWi(h), and therefore E(h) = P
i EWi(h) + (· · · ) as required.
CVIT 2016

---

23:42
Degree Sequence Bound For Join Cardinality Estimation
A.5
Proof of Lemma 5.1
We start by proving:
▷Claim 2.
For all p = 2, d, the following hold:
If F1(i1 −1) ≥Fp(ip) then Ci1···ip = 0.
If Fp(ip −1) ≥F1(i1) then Ci1···ip = 0.
Proof. We prove the ﬁrst implication only; the second implication is similar and omitted.
Assume that F1(i1 −1) ≥Fp(ip). We also have F1(i1) ≥Fp(ip) (because F1 is non-
decreasing), and therefore the following hold:
min(F1(i1 −1), F2(i2), . . . , Fd(id)) = min(F2(i2), . . . , Fd(id))
min(F1(i1), F2(i2), . . . , Fd(id)) = min(F2(i2), . . . , Fd(id))
This implies:
∆1 min(F1(i1), . . . , Fd(id)) =0
(72)
On the other hand, F1(i1) ≥Fp(ip −1) (because Fp is non-decreasing), and therefore we can
repeat the argument above for ip −1 instead of ip, and obtain:
∆1 min(F1(i1), . . . , Fp(ip −1), . . . Fd(id)) =0
(73)
Combining (72) and (73) we obtain:
∆p∆1 min(F1(i1), . . . , Fd(id)) =0
Since this holds for all indices iq, q̸ = 1, q̸ = p, it follows that:
Ci1···id =∆1 · · · ∆d min(F1(i1), . . . , Fd(id)) = 0
The second implication of the claim is proven similarly.
◀
We now prove Lemma 5.1. Assume that Ci1···id̸ = 0. The claim implies the following two
conditions:
Fp(ip) >F1(i1 −1)
Fp(ip −1) <F1(i1)
By our deﬁnition of F −1 in Sec. 5, this implies:
ip >F −1
p
(F1(i1 −1))
def
= j
ip <F −1
p
(F1(i1)) + 1
def
= k
(Notice that j, k may be real values.) This means that in the sum below we can restrict ip to
range between j and k only:
X
ip=1,np
Ci1···id · ap(ip) =
X
ip=⌈j⌉,⌊k⌋
Ci1···id · ap(ip)
(74)
Since ap is non-increasing we have
X
ip=⌈j⌉,⌊k⌋
Ci1···id · ap(ip) ≥


X
ip=⌈j⌉,⌊k⌋
Ci1···id

· ap(⌊k⌋) =

X
ip=1,np
Ci1···id

· ap(

F −1
p
(F1(i1))

+ 1)

---

K. Deeds, D. Suciu, M. Balazinska, W. Cai
23:43
and similarly:
X
ip=⌈j⌉,⌊k⌋
Ci1···id · ap(ip) ≤


X
ip=⌈j⌉,⌊k⌋
Ci1···id

· ap(⌈j⌉) =

X
ip=1,np
Ci1···id

· ap(

F −1
p
(F1(i1 −1))

)
Inequalities (27) and (28) follow by repeating the argument above for all p = 2, d, then
observing that
X
i2=1,n2
· · ·
X
id=1,nd
Ci1i2···id =∆1 min(F1(i1), F2(n2), . . . , Fd(nd)) = ∆1F1(i1)
by Eq. (14) and F1(i1) ≤F1(n1) ≤Fp(np).
A.6
Proof of Theorem 5.2
We begin by proving item (1) of the theorem: FDSB(Q, f) ≥DSB(Q, f). To do this, we
ﬁrst prove the following lemma.
▶Lemma A.27.
DSB(Q, f) ≤FDSB(Q, f, ROOT)
(75)
Proof. Let Q∗be an alteration of the query Q where everything is identical except for
the addition of a variable X0 which is only present in relation ROOT. Additionally, we
set the degree sequence equal to 1, i.e. f ROOT,X0(i) = 1 ∀i ∈[1, |ROOT|]. We claim
that DSB(Q∗, f, ∞) = DSB(Q, f, ∞).
To see this, consider the ﬁnal summation for
DSB(Q∗, f, ∞), DSB(Q, f, ∞), and FDSB(Q, f, ROOT) in algorithm 2,
DSB(Q∗, f) =
X
i1=1,D1
. . .
X
ik=1,Dk
X
i0=1,|ROOT |
Ci1,...,ik,i0 · a(X0)(i0) ·
Y
p=1,k
a(Xp)
ip
DSB(Q, f) =
X
i1=1,D1
. . .
X
ik=1,Dk
X
i0=1,|ROOT |
Ci1,...,ik,i0 · a(X0)(i0) ·
Y
p=1,k
a(Xp)
ip
FDSB(Q, f, ROOT) =
X
i=1,|ROOT|
Y
p=1,k
ap(max(1, F −1
p
(i)))
Because X0 is not shared by any other relations, we have a(X0)(i0) = 1. Further, we can
break P
i0=1,|ROOT | Ci1,...,ik,i0 into P
i0=1,|ROOT | ∆i0∆i1 . . . ∆ikVi1,...,ik,i0. Here, the summa-
tion and delta cancel out to leave us with ∆i1 . . . ∆ikVi1,...,ik,|ROOT |. Because B = ∞, we know
from Thm. 3.2 item 6 that V is a minimum of the form ∆i1 . . . ∆ik min F1(i1), . . . , Fk(ik), |ROOT|.
Therefore, we can remove this ﬁnal term and we get back to our expression for DSB(Q, f).
We now prove that DSB(Q∗, f) ≤FDSB(Q, f, ROOT).
To do this, we rewrite the
expression for DSB(Q∗, f) as follows,
DSB(Q∗, f) =
X
i0=1,|ROOT |
w(ROOT)(i)
This is possible because the root relation now has a parent variable X0. Further, according
to Lemma 5.1, w ≤ˆw, so replacing w for ˆw throughout the algorithm will only increase the
result. Doing this replacement, we get,
DSB(Q∗, f) ≤
X
i0=1,|ROOT |
ˆw(ROOT)(i)
DSB(Q∗, f) ≤
X
i0=1,|ROOT |
f0(i) ·
Y
i=1,p
ap(max(1, F −1
p
(F0(i))))
CVIT 2016

---

23:44
Degree Sequence Bound For Join Cardinality Estimation
Because the degree sequence of X0 is equal to 1, we know f0(i) = 1 and F0(i) = i.
DSB(Q∗, f) ≤
X
i0=1,|ROOT |
1 ·
Y
i=1,p
ap(max(1, F −1
p
(i)))
Recognizing the RHS as the summation for FDSB, we get the result.
DSB(Q∗, f) ≤FDSB(Q, f, ROOT)
◀
Therefore, for any cover Q1, . . . , Qm, we have Q
i=1,m DSB(Qi, f) ≤Q
i=1,m minROOT ∈R(Qi) FDSB(Qi, f, ROOT).
To ﬁnish the proof of part 1, we simply note the result from 4.5 that DSB(Q, f) ≤
DSB(Q1) · · · DSB(Qm) for any cover Q1, . . . , Qm.
We prove the second part of the theorem in three steps. First, we prove some basic facts
about the complexity of computing the composition and multiplication of piece-wise functions.
Second, we bound the complexity of computing ˆw(R) given its inputs are piece-wise functions.
Lastly, we extend this bound to fully computing Alg. 2 which proves the theorem.
We start by proving the tractability of piece-wise composition,
▶Lemma A.28. Let F(x), G(x) be non-decreasing piece-wise linear functions with the set
of separators SF = [m1, . . . , msF ], SG = [n1, . . . , nsG] with cardinalities sF , sG. Then, their
composition, F(G(x)), is a piece-wise linear function with separators S′ = G−1(SF ) ∪SG =
[l1, . . . , l|S′|] and has the following complexity:
Ccomp = O((sF + sG)(log(sF ) + log(sG)))
Proof. Because S′ reﬁnes the separators of SG, G(x) is a simple linear function when
restricted to one interval of S′. Further, consider a interval deﬁned by this new set of
separators (li, li+1], then this interval is contained within an interval of SG because otherwise
there would be a separator of SG which is not within S′. Further, (G(li), G(li+1)] is within
an interval of SF . Suppose the latter were not true, then there would be a separator mj such
that li < G−1(mj) < li+1. Because G−1(mj) is in the set S′, this is impossible. Therefore,
the function F(G(x)) can be fully deﬁned by simply looking up the linear function at G(m)
and at F(G(m)) and composing them for every interval (li, li+1] in S′.
Looking at the computational time piece-by-piece, we have to compute the result of G−1
sF times and lookup the linear functions of F and G at a particular point sF + sG times.
Each of these computations/lookups takes log(sG), log(sF ) operations, respectively, so the
overall computational complexity is O((sF + sG)(log(sG) + log(sF ))).
◀
The lemma for multiplication proceeds very similarly,
▶Lemma A.29. Let f1(x), ..., fd(x) be non-decreasing si-staircase functions with the set of
separators denoted SFi. Then, their multiplication, Q
p∈[1,d] Fp(x), is an Pd
i=1 si-staircase
function with divisors S′ = S
p∈[1,d] SFp = [l1, . . . , l|S′|] and has the following complexity:
Cmult = O((
d
X
p=1
sFp)(
d
X
p=1
log(sFp)))
Proof. Because the joint set of separators S′ reﬁnes each factor’s separators SFp, within a
particular interval (li, li+1] each function is a simple polynomial. Therefore, the function

---

K. Deeds, D. Suciu, M. Balazinska, W. Cai
23:45
Qd
p=1 Fp(x) can be fully deﬁned by simply looking up each function’s constant at li and
multiplying them for each interval (li, li+1] in S′.
Considering the computational time, computing the product requires looking up each
factor’s constant and computing these constant’s product within each interval of S′. Each
of these lookups takes log(sFp) operations. So, the overall computational complexity is
O((Pd
p=1 sFp)(Pd
p=1 log(sFp)).
◀
Given these lemmas, we can bound the computational time of computing ˆw(R) and
describe the resulting function,
▶Lemma A.30. Let each vector fp
def
= f (R,Xp) be an sR,Xp-staircase and ap
def
= a(Xp) be
tXP -staircases with dividers SFp and Sap, respectively. Then, the vector ˆw(R) as deﬁned in
Alg. 3 is a (Pd
p=1 sR,Xp + Pd
p=2 tXp)-staircase and can be computed in time.
Ctotal,R = O((dsR,X1+
d
X
p=2
sR,Xp+
d
X
p=2
tXp)·(d log(sR,X1)+
d
X
p=2
log(sR,Xp)+
d
X
p=2
log(tXp)+(
d
X
p=2
kXp)2))
Proof. We start by restating the expression for ˆw(R),
ˆw(R) def
= (∆i1F1(i1))
Y
p∈[2,d]
ap
 F −1
p
(F1(i1 −1))

We can now calculate the set of separators of ˆw(R) using the previous two lemmas’. First,
we consider the separators for each factor of the product. Based on Lemma A.28 and the
fact that F −1
p
◦F1 = F −1
1
◦Fp, we get the following expression for their separators,
Sap◦F −1
p
◦F1 = F −1
1
(Fp(Sap)) ∪F −1
1
(SF −1
p ) ∪SF1
At this point, we take the union of the factors’ separators to get the full set of separators for
ˆw(R),
S ˆ
w(R) = SF1 ∪
 d[
p=2
F −1
1
(Fp(Sap)) ∪F −1
1
(SF −1
p ) ∪SF1
!
= SF1 ∪
 d[
p=2
F −1
1
(Fp(Sap))
!
∪
 d[
p=2
F −1
1
(SF −1
p )
!
Therefore, ˆw(R) has at most Pd
p=1 sR,Xp + Pd
p=1 tXp separators.
Next, we consider the computational complexity and degree in two steps: 1) Ccomp,R,
deﬁned as the time to calculate all of the ap(F −1
p
(F1(i1))) expressions and 2) Cmult,R, deﬁned
as the time to calculate the product of these expressions. Starting with the compositions,
calculating a single expression of the form ap(F −1
p
(F1(i1))) requires calculating two composi-
tions F −1
p
◦F1 and ap ◦(F −1
p
◦F1). This ﬁrst composition takes the following operations by
Lmm. A.28,
O((sR,Xp + sR,X1)(log(sR,Xp) + log(sR,X1)))
The second composition takes,
O((tXp + sR,Xp + sR,X1)(log(tXp) + log(sR,Xp + sR,X1)))
Because log(sR,Xp + s1) ≤log(sR,Xp) + log(s1), the sum of these two times is upper bounded
by,
O((tXp + sR,Xp + sR,X1)(log(tXp) + log(sR,Xp) + log(sR,X1)))
CVIT 2016

---

23:46
Degree Sequence Bound For Join Cardinality Estimation
So, the ﬁrst step has the following complexity and results in a staircase function because
composition with a constant function results in a constant function,
Ccomp,R = O
 d
X
p=2
(tXp + sR,Xp + sR,X1)(log(sR,Xp) + log(sR,X1) + log(tXp))
!
The product of these functions then takes the following operations by Lmm. A.29,
Cmult,R = O
  
sR,X1 + (
d
X
p=2
sR,Xp + tXp + sR,X1)
! 
log(sR,X1) +
d
X
p=2
log(sR,Xp + tXp + sR,X1)
!!
Splitting the logarithms results in the following cleaner expression,
Cmult,R = O
  
dsR,X1 +
d
X
p=2
sR,Xp +
d
X
p=2
tXp
! 
d log(sR,X1) +
d
X
p=2
log(sR,Xp) +
d
X
p=2
log(tXp)
!!
Because Ccomp,R ≤Cmult,R (the sum of a product is less than the product of sums), we can
then say that the whole computation has complexity:
Ctotal,R = O
  
dsR,X1 +
d
X
p=2
sR,Xp +
d
X
p=2
tXp
! 
d log(sR,X1) +
d
X
p=2
log(sR,Xp) +
d
X
p=2
log(tXp)
!!
◀
Next, we extend this analysis to the full bound computation for a given root,
▶Theorem A.31. Let Q be a Berge-acyclic query with M relations (as in Eq. (6)), whose
degree sequences are represented by sR,Z-staircase functions. Then, (1) FDSB(Q, ROOT) ≥
DSB(Q), and (2) it can be computed in the following polynomial time combined complexity,
TF DSB = O(M(s +
max
R∈R,Z∈XR(Arity(R) · sR,Z))(slog +
max
R∈R,Z∈XR(Arity(R) · log(sR,Z))))
where s = P
R,Z sR,Z and slog = P
R,Z log(sR,Z).
Proof. To produce this bound, we bound the maximum computation necessary to compute
any ˆw(R) then we multiply that bound by |R|, i.e. the number of w(R) expressions that we
have to compute. To produce this ﬁrst bound, we start with the complexity of computing an
arbitrary ˆw(R),
Ctotal,R = O
  
dsR,X1 +
d
X
p=2
sR,Xp +
d
X
p=2
tXp
! 
d log(sR,X1) +
d
X
p=2
log(sR,Xp) +
d
X
p=2
log(tXp)
!!
First, we replace P
p sR,Xp + P
p tXp with the sum of all segments in the database, similarly
for the log terms. To see why this is valid, we note that tXp is equal to the number of
segments in relations in the sub-tree of the incidence graph rooted at Xp. By the same logic,
P
p sR,Xp + P
p tXp is equivalent to the sum of all segments in relations in the subtree of
the incidence graph rooted at R. Therefore, this expression must be upper bounded by the
number of segments in the entire incidence graph, i.e. P
R∈R
P
Z∈XR sR,Z). This gives us
the following expression,
Ctotal,R = O((d · sR,X1 +
X
R∈R
X
Z∈XR
sR,Z) · (d log(sR,X1) +
X
R∈R
X
Z∈XR
log(sR,Z)))

---

K. Deeds, D. Suciu, M. Balazinska, W. Cai
23:47
Next, we need to remove the reliance on dSR,X1 as it refers to the particular table R. We do
so by replacing it with its maximum over all relations,
Ctotal,R = O(( max
R,Z∈XR(Arity(R) · sR,Z) +
X
R∈R
X
Z∈XR
sR,Z)
( max
R,Z∈XR(Arity(R) · log(sR,Z)) +
X
R∈R
X
Z∈XR
log(sR,Z)))
Therefore, we can bound the overall computation by this maximum per-table-computation
multiplied by the number of tables,
Ctotal = O(
X
R∈R
Ctotal,R)
Ctotal = O(|R| · ( max
R,Z∈XR(Arity(R) · sR,Z) +
X
R∈R
X
Z∈XR
sR,Z)·
( max
R,Z∈XR(Arity(R) · log(sR,Z)) +
X
R∈R
X
Z∈XR
log(sR,Z)))
◀
A.6.1
Proof of Theorem 5.4
▶Theorem A.32. Let Q be a Berge-acyclic query with M relations (as in Eq. (6)), whose de-
gree sequences are represented by sR,Z-staircase functions. Then, (1) FDSB(Q) ≥DSB(Q),
and (2) it can be computed in polynomial time combined complexity O(2m ·(2m +M ·TF DSB)).
Proof. Claim 1 follows directly from part 2 of Lemma 4.5 and part 1 of Theorem 5.2, i.e.
for all covers Q1, . . . , Qk and roots ROOT,
DSB(Q) ≤DSB(Q1) · · · DSB(Qk)
(76)
DSB(Q) ≤FDSB(Q, ROOT
(77)
Let Q1, . . . , Qk be the partitions of the optimal cover used in FDSB(Q) and let ROOTi ∀1 ≤
i ≤k be the optimal roots. Combining the above statements, we get the ﬁrst part of our
theorem,
DSB(Q) ≤FDSB(Q1, ROOT1) · · · FDSB(Qk, ROOTk) = FDSB(Q)
(78)
Claim 2 is the result of the dynamic programming algorithm 4 which uses FDSB(Q, ROOT)
as a sub-routine.
CVIT 2016

---

23:48
Degree Sequence Bound For Join Cardinality Estimation
Algorithm 4 Computing FDSB(Q)
FDSB(Q) = ∞
for i ∈1, |R| do
for subset S in all size i subsets of R do
S1, . . . , Sl = ConnectedComponents(S)
COST(S) = Q
p=1,l minROOT∈Sp FDSB(Sp, ROOT)
for Q1, Q2 in Partitions of S do
COST(S) = min(COST(S), COST(Q1) ∗COST(Q2))
end for
if S is cover then
FDSB(Q) = min(FDSB(Q), COST(S))
end if
end for
end for
return FDSB(Q)
This algorithm runs in time O(·2m(2m + mTF DSB)). This is because the number of
subsets of R is 2m, so the outer two for loops will only result in 2m iterations. Within
each of those iterations, computing the minimum FDSB for each root within connected
component requires checking at most m roots, resulting in O(mTF DSB). Further, you need to
consider every partition of S into two sub-queries which can occur at most 2m ways. However,
constant work is done for each of those sub-queries because COST(Q1) and COST(Q2) have
already been calculated in previous iterations.
We now show that this algorithm is correct, i.e. it returns FDSB(Q). Because it returns
a multiplication of FDSB’s calculated over partitions in coverings of Q, it is immediate to
see that the return value is greater than or equal to FDSB(Q). Therefore, we just need to
show that its return value is less than or equal to FDSB(Q). Let Q1, . . . , Qk be the optimal
partition of Q, ROOT1, . . . , ROOTk be the optimal roots, and S∗= R1, . . . , Rr be the relations
in the optimal covering. Lastly, let P (S) represent the set of disjoint partitions of S.
We proceed inductively on the iterations of the outer loop with the following hypothesis,
COST(S) ≤
min
S1,...,Sk∈P (S′)
Y
i=1,k
min
ROOT FDSB(Si, ROOT)∀S ⊆R
Therefore, the following is our inductive assumption,
COST(S′) ≤
min
S1,...,Sk∈P (S′)
Y
i=1,k
min
ROOT FDSB(Si, ROOT)∀|S′| < i, S′ ⊂R
Let S ⊆R be a subset of size i. We note that any partition of S can be described as a
series of binary partitions. From this, we can see immediately that COST(S) satisﬁes our
inductive hypothesis because it is the minimum over all binary partitions as well as the
trivial partition, Q1 = S, Q2 = {}. Lastly, our base case of i = 1 is immediate as the trivial
partition is the only available partition. This inductive proof immediately gives us that
COST(S) is less than or equal to the product of minimum FDSB over all roots for each
partition which is equivalent to the deﬁnition of FDSB(Q).
◀

---

K. Deeds, D. Suciu, M. Balazinska, W. Cai
23:49
A.7
Proof of Lemma 5.3
▶Lemma A.33. Suppose Q is a Berge-acyclic query with degree sequences f, then the
following is true,
FDSB(Q, f, ROOT) ≤PB(Q, ROOT)
(79)
Proof. We prove by induction on the tree that, for all R̸ = ROOT, and every value i ≥1,
ˆw(R)(i) ≤Q
S∈tree(Xp) f (S,ZS)(1). Assuming this holds for all children of R, we consider the
deﬁnition of ˆw(R). Because the functions ap are non-increasing and the maximum restricts
their input to ≥1, we know that ˆw(i) ≤f1(i) · Q
i=2,p ap(1). By induction hypothesis, for
each function ap, we know ap(1) ≤Q
S∈tree(Xp) f (S,ZS)
1
. Therefore, we immediately get,
ˆw(i) ≤f1(i) ·
Y
i=2,p
Y
S∈tree(XP )
f (S,Zs)(1) ≤
Y
S∈tree(R)
f (S,ZS)(1)
As before, this completes the proof of our inductive step. The base case of a leaf relation is
trivial as in that case w(i) = f1(i) ≤f1(1). Lastly, we consider the expression for the ﬁnal
sum and see that the lemma holds.
X
i=1,|ROOT|
Y
p=1,k
ap(max(1, F −1
p
(i))) ≤
X
i=1,|ROOT|
Y
p=1,k
Y
S∈tree(Xp)
f (S,ZS)(1)
≤|ROOT|
Y
S̸=ROOT∈tree(ROOT)
f (S,ZS)(1) = PB(Q, ROOT)
◀
A.8
Proof of Theorem 5.5
▶Theorem A.34. Suppose Q is a Berge-acyclic query. Then the following hold:
|Q| ≤FDSB(Q) ≤PB(Q) ≤AGM(Q)
(80)
Proof. The theorem follows directly from lemma 5.3 and the deﬁnitions of FDSB(Q) and
PB(Q) which we restate below,
PB(Q)
def
= min
W
Y
i=1,m
min
ROOT∈R(Qi) PB(Qi, ROOTi)
FDSB(Q)
def
= min
W
Y
i=1,m
min
ROOT∈R(Qi) FDSB(Qi, ROOTi)
Because we know FDSB(Qi, ROOTi) ≤PB(Qi, ROOTi) from lemma 5.3, our result immedi-
ately follows.
PB(Q) ≤min
W
Y
i=1,m
min
ROOT∈R(Qi) FDSB(Qi, ROOTi) = FDSB(Q)
◀
CVIT 2016

---

