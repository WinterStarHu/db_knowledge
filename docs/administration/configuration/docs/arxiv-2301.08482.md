# A Simple Algorithm for Consistent Query Answering under Primary Keys

> 来源: https://arxiv.org/pdf/2301.08482

Logical Methods in Computer Science
Volume 21, Issue 1, 2025, pp. 18:1–18:43
https://lmcs.episciences.org/
Submitted
Dec. 12, 2023
Published
Feb. 21, 2025
A SIMPLE ALGORITHM FOR CONSISTENT QUERY
ANSWERING UNDER PRIMARY KEYS
DIEGO FIGUEIRA a, ANANTHA PADMANABHA b, LUC SEGOUFIN c, AND CRISTINA SIRANGELO d
a Univ. Bordeaux, CNRS, Bordeaux INP, LaBRI, UMR 5800, Talence, France
e-mail address: diego.figueira@cnrs.fr
b Indian Institute of Technology Madras, Chennai, India
e-mail address: ananthap@cse.iitm.ac.in
c INRIA, ENS-Paris, PSL University, France
e-mail address: luc.segoufin@inria.fr
d Universit´e Paris Cit´e, CNRS, IRIF, F-75013, Paris, France
e-mail address: cristina@irif.fr
Abstract. We consider the dichotomy conjecture for consistent query answering under
primary key constraints. It states that, for every fixed boolean conjunctive query q, testing
whether q is certain (i.e., whether it evaluates to true over all repairs of a given inconsistent
database) is either polynomial time or coNP-complete. This conjecture has been verified
for self-join-free and path queries.
We propose a simple inflationary fixpoint algorithm for consistent query answering
which, for a given database, naively computes a set ∆of subsets of facts of the database of
size at most k, where k is the size of the query q. The algorithm runs in polynomial time
and can be formally defined as:
(1) Initialize ∆with all sets S of at most k facts such that S |= q.
(2) Add any set S of at most k facts to ∆if there exists a block B (i.e., a maximal set of
facts sharing the same key) such that for every fact a ∈B there is a set S′ ⊆S ∪{a}
such that S′ ∈∆.
For an input database D, the algorithm answers “q is certain” iff ∆eventually contains
the empty set. The algorithm correctly computes certainty when the query q falls in the
polynomial time cases of the known dichotomies for self-join-free queries and path queries.
For arbitrary boolean conjunctive queries, the algorithm is an under-approximation: the
query is guaranteed to be certain if the algorithm claims so. However, there are polynomial
time certain queries (with self-joins) which are not identified as such by the algorithm.
 This pdf contains internal links: clicking on a notion leads to its definition.1
Key words and phrases: consistent query answering, primary keys, conjunctive queries.
Journal version of the paper presented at ICDT 2023 [FPSS23], see Section 1.3 for a summary of the
added material.
1https://ctan.org/pkg/knowledge
LOGICAL METHODSl IN COMPUTER SCIENCE
DOI:10.46298/LMCS-21(1:18)2025
©
D. Figueira, A. Padmanabha, L. Segoufin, and C. Sirangelo
CC
⃝
Creative Commons

---

18:2
D. Figueira, A. Padmanabha, L. Segoufin, and C. Sirangelo
Vol. 21:1
Contents
1.
Introduction
2
1.1.
Contributions
3
1.2.
Related work
4
1.3.
Conference paper
5
2.
Preliminaries
5
3.
Polynomial time algorithm
7
4.
Tractable self-join-free queries
10
5.
Lower bounds
16
5.1.
The case of q4
17
5.2.
The case of q5
25
5.3.
The case of all self-join-free queries falsifying PCond: coNP-hardness
28
5.4.
The case of all self-join-free queries falsifying PCond: Certk fails
30
6.
Path queries
31
6.1.
Tractable path queries
32
6.2.
Inexpressiblity results for path queries
34
7.
First order definability
39
7.1.
Self-join-free case
39
7.2.
Path queries
40
8.
Conclusion
41
Acknowledgment
42
References
42
1. Introduction
A database often comes with integrity constraints. Such constraints are helpful in many
ways, for instance in order to help optimizing query evaluation. When the database violates
its integrity constraints we are faced with several possibilities. A first possibility is to
clean the data until all integrity constraints are satisfied. This task is not easy as it is
inherently non-deterministic: there could be many equally good ways to “repair” a database.
A repair can be understood as a minimal way to change the database in order to satisfy the
constraints.
Another possibility is to keep the database in its inconsistent state, postponing the
problem until a query is issued. In order to evaluate the query on the inconsistent database
D, the classical solution is to consider all possible repairs of D and return all the answers
which are “certain”, i.e., the answers that are returned by the query when evaluated on every
repair of D [ABC99]. However, this method usually has an impact on the complexity of the
query evaluation problem. The impact will of course depend on the type of the integrity
constraints and on the definition of a repair, but most often the worst case complexity
increases at least by a factor which is exponential in the size of the database, since there
could be exponentially many ways to repair a database.
Depending on the type of integrity constraints, what should be considered as a “good”
notion of repair may be controversial. In this paper we consider primary key constraints,
which are arguably the most common kind of integrity constraints in databases. For primary

---

Vol. 21:1
A SIMPLE ALGORITHM FOR CQA UNDER PRIMARY KEYS
18:3
keys, there is a unanimously accepted notion of repair. Primary key constraints identify,
for each relation, a set of attributes which are considered to be the key of this relation. An
inconsistent database is therefore a database that has distinct tuples sharing the same key
within a relation. For such constraints, the standard notion of a repair is any maximal subset
of the database satisfying all the primary key constraints. This amounts to keeping exactly
one tuple for each group of tuples having the same key, in each relation. A simple analysis
shows that there can be exponentially many repairs of a given database, and therefore a
naive evaluation algorithm would have to evaluate the query on each of these exponentially
many repairs.
As query language, we consider boolean conjunctive queries, which can be evaluated in
polynomial time in data complexity. With the certain answer semantics described above,
a query is “certain” on an inconsistent database if it is true on all its repairs. The data
complexity of certain answers for conjunctive queries over inconsistent databases in the
presence of primary key constraints is therefore in coNP. Indeed, in order to test whether
the query is not certain, it is enough to guess a subset of the database which is a repair
and which makes the query false. Further, it has been observed that for some conjunctive
queries the certain query answering problem is coNP-hard [FM07] while, for other queries,
it can be solved in polynomial time. The main conjecture for inconsistent databases in the
presence of primary key constraints is that there are no intermediate cases: for any boolean
conjunctive query, the certain answering problem is either solvable in polynomial time or it
is coNP-complete.
The conjecture has been proved for self-join-free boolean conjunctive queries [KW17] and
for path queries [KOW21]. However, the conjecture remains open for arbitrary conjunctive
queries (with self-joins). In this paper we revisit the two cases above where the conjecture is
known to hold: self-join-free queries and path queries.
1.1. Contributions. Our main contribution is the design of a simple fixpoint algorithm
for computing certain answers of boolean conjunctive queries over inconsistent databases in
the presence of primary key constraints. For every k ≥1, we describe a fixpoint algorithm
parameterized by k. The algorithm is always an under-approximation of the certain answers:
on boolean queries, if it outputs ‘yes’ then the query is certain, i.e., it is true on all repairs
of the database. But there could be “false negatives”, that is, queries which are certain but
on which the algorithm outputs ‘no’.
In this paper we investigate the expressive power of our fixpoint algorithm, trying to
understand when it solves the certain answering problem.
Our first result shows that in the case of self-join-free queries and path boolean queries,
we can characterize the cases when our fixpoint algorithm computes the certain answers
via a semantic condition. In other words, when the condition holds there exists k (namely,
the number of atoms of the query) such that the corresponding fixpoint algorithm correctly
computes the certain answer (taking k as parameter); and conversely when the condition
does not hold, for every k there exists a database instance D such that the fixpoint algorithm
parameterized by k outputs a false negative on D.
We then show that when our algorithm fails to compute the certain answers, i.e.,
when our semantic condition fails, the certain answering problem is actually coNP-hard.
Hence, for self-join-free queries and path queries and assuming PTime̸ = coNP, our simple
fixpoint algorithm solves the certain answering problem in all the cases where it is solvable in
polynomial time. The current approaches for PTime solvable queries for these two classes are

---

18:4
D. Figueira, A. Padmanabha, L. Segoufin, and C. Sirangelo
Vol. 21:1
mutually orthogonal and our result provides a uniform algorithm to solve all the polynomial
time solvable queries known in the literature.
A natural question is then to wonder whether our algorithm always correctly computes
the certain answering problem on all queries for which this problem is polynomial time
computable. Our second result answers negatively to this question. There is a simple
two-atom query, named q4 in the paper, with self-joins, whose certain answering problem is
equivalent to bipartite matching under LogSpace reductions, and cannot be solved with our
fixpoint algorithm. Recall that the bipartite matching problem can be solved in polynomial
time and is NL-hard. This shows that in the presence of self-joins, the classification of the
complexity of the certain answering problem is richer than in the self-join free case when it
is either in LogSpace or coNP-complete [KW21] .
Our fixpoint algorithm is based on a function that is expressible in first-order logic (FO).
Hence, when the fixpoint is bounded, the certain answering problem is expressible in FO.
Our last result shows that for self-join-free and path queries the converse is true: whenever
the certain answering problem is expressible in FO, the fixpoint algorithm is bounded and
the certain answering problem is expressible by some bounded unfolding of the fixpoint
algorithm.
Though our greedy fixpoint computation algorithm is simple, the proof of correctness
when the semantic condition holds is non-trivial. In the case of self-join-free queries satisfying
our semantic condition, to prove that the algorithm always computes the correct answer,
we proceed by contradiction: if the algorithm fails to give the correct answer, we use the
fixpoint definition of the algorithm in order to produce an infinite sequence of distinct facts
of the database, contradicting its finiteness.
The situation is a bit simpler in the case of path queries, where we show that our
fixpoint algorithm can simulate the polynomial time algorithm of [KOW21] for computing
certain answers for a path query q, assuming that certain answering for q is polynomial time
solvable.
For the lower bounds, we first show that our fixpoint algorithm fails to compute the
certain answering problem for q4 by constructing for every number k, a database such that
all its repairs satisfy q4 but the algorithm outputs ‘no’. In the second step we reduce this
query q4 to all queries that falsify the semantic condition: if the fixpoint algorithm would
work for such queries, it would also work for q4. The reduction relies on the (syntactic)
condition of [KW17] characterizing the class of queries having a coNP-complete certain
answering problem.
1.2. Related work. Our work is inspired by the results of Koutris and Wijsen [KW21,
KW17]. For self-join-free queries, the authors prove the polynomial time case via a long
sequence of reductions eventually producing a simple query whose certain answers can
be solved efficiently. When unfolding the sequence of reductions this gives a complicated
polynomial time algorithm with a complex proof of correctness. We have basically simplified
the algorithm and pushed all the difficulty into the proof of correctness. Our algorithm
is simple, but the proof of correctness is arguably as complex as theirs.
Further, our
algorithm does not give, a priori, the optimal LogSpace complexity result of [KW21]
as we know that some of the path queries that can be solved with our algorithm are
PTime complete [KOW21]. The semantic condition that we provide for characterizing the
polynomial case in the self-join-free case can be effectively tested, but not efficiently, unlike

---

Vol. 21:1
A SIMPLE ALGORITHM FOR CQA UNDER PRIMARY KEYS
18:5
the simple syntactic characterization of [KW17] based on the so-called “attack graph” of
the query.
In the case of path queries, [KOW21] also provides a simple fixpoint algorithm for
solving the polynomial cases. Though it seems that their algorithm is different in spirit from
ours, the two algorithms have some similarities that we use in order to “simulate” their
fixpoint computation using ours.
For both self-join-free and path queries the cases where the certain answering problem is
expressible in FO is also characterized in [KOW21, KW17]. In fact, our boundedness results
use their characterizations.
Recently, the dichotomy conjecture has been proved for queries with two atoms [PSS24]
and for “rooted tree-queries” [KOW23].
Certain answers for two-atom queries in the
polynomial time cases is computed using a combination of our fixpoint algorithm and
bipartite matching. Bipartite matching hardness has also been obtained for the consistent
query answering problem in the presence of key constraints [KW20, Lemma 6.4] or in the
presence of negated atoms [KW18].
1.3. Conference paper. The current article is based on the conference paper [FPSS23].
While the main results are essentially the same, though with improved explanations and
figures, we have also added new material:
• We have added the complete characterization of the cases where our fixpoint algorithm
works (Section 5.4 and Section 6.2).
• We show the link between boundedness of our algorithm and expressibility in FO of the
certain answering problem (Section 7).
2. Preliminaries
A relational signature is a finite set of relation symbols associated with an arity. A finite
relational structure D over a relational signature σ is composed of: a finite set, the domain
adom(D) of D, and a function associating to each symbol R of σ a relation R(D) of the
appropriate arity over adom(D). A database is a finite relational structure.
An R-fact of a database D over a relational signature σ is a term of the form R(¯a) where
R is a symbol of σ and ¯a a tuple in R(D). A fact u is an R-fact for some R if u = R(¯a)
where R is the symbol associated to the fact u and ¯a the tuple associated to u. A database
can then be viewed as a finite collection of facts. The size of a database is the number of
facts it contains. Assuming σ is fixed (which we will implicitly do in this paper) this is
equivalent to the usual notion of size for a database, up to some polynomial function.
A key constraint over a relational signature σ specifies for every relation symbol R of σ
a certain set of indices (columns) of R as a key. A database satisfies the key constraint if
for every relation R over σ, whenever two R-facts agree on the key indices they must be
equal. A set of primary key constraints has, for each relation of σ, a unique key constraint.
Notice that if the primary key constraint associated to the relation symbol R contains all
the columns of R, then it induces no constraints on R. As all the sets of constraints we
consider are primary key constraints we will henceforth omit the ‘primary’ prefix. We use
the letter Γ to denote the corresponding set of key constraints.
Given two facts u and v and a set Γ of key constraints, we say that u and v are
Γ-equivalent, denoted by u ∼Γ v, if u and v have the same associated symbol R and agree on

---

18:6
D. Figueira, A. Padmanabha, L. Segoufin, and C. Sirangelo
Vol. 21:1
the key of R as specified by Γ. Γ-equivalence is an equivalence relation and the equivalence
classes are called Γ-blocks. We will omit Γ in our notations whenever it is clear from the
context. A database is then a finite collection of blocks, each block being a maximal (finite)
collection of equivalent facts. When writing a query q we will always underline in an atom
R(¯x) the positions that are part of the key of R as specified by Γ. This will avoid explicitly
describing Γ. For instance R(x y) says that the first position is the key for the binary
relational symbol R; and R′(yz y) says that the first two positions form the key for the
ternary relational symbol R′.
If a database D satisfies the key constraints Γ, denoted by D |= Γ, then each block of D
has size one. If not, then a repair of D is a subset of the facts of D such that each block of
D has exactly one representative in the repair. In particular a repair always satisfies the key
constraints. Notice that there could be exponentially many repairs of a given database D.
A boolean conjunctive query over a relational signature σ is a collection of atoms where
an atom is a term R(¯x) where R is a relation symbol from σ and ¯x is a tuple of variables
of the appropriate arity. The query being boolean, all variables are implicitly existentially
quantified. We will consider atoms of a conjunctive query to appear in an arbitrary but
fixed order. In this paper a “query” is always a boolean conjunctive query. A database D
satisfies a query q having atoms A1, . . . , Ak, denoted by D |= q, if there is a mapping µ from
the variables of q to the elements of the domain of D such that the fact µ(Ai) ∈D for all i.
In this case the sequence (µ(A1), . . . , µ(Ak)) of (not necessarily distinct) facts of D is called
a solution to q in D. Different mappings yield different solutions. The set of solutions to q
in D is denoted by q(D). We will also write D |= q(¯u) to denote that the sequence of facts
¯u is a solution to q in D. If ¯u = (u1, . . . , uk) is a solution to q we also say that ui matches
Ai in this solution, and that any subsequence ui1, . . . , uil matches Ai1, . . . , Ail.
Let r be a repair of D. By |q(r)| we denote the number of solutions to q in r, i.e.,
the cardinality of q(r). We say that a repair r is minimal if there is no repair s such that
|q(s)| < |q(r)|.
We say that a query q is certain for a database D if all repairs of D satisfy q. We study
the complexity of determining whether a query is certain for a database D. We adopt the
data complexity point of view. For each query q and set of key constraints Γ, we denote
by certainΓ(q) (or simply certain(q) when Γ is understood from the context) the problem of
determining, given a database D, whether q is certain for D. Clearly the problem is in coNP
as one can guess a (polynomially sized) repair and test whether it does not satisfy q. It is
known that for some queries q the problem certain(q) is coNP-complete [FM07]. However,
there are queries q for which certain(q) is in PTime or even expressible in first-order logic
(denoted by FO in the sequel) [KP12, Wij10]. In this context, the following dichotomy has
been conjectured (cf [FM07, AK09]):
Conjecture 2.1 (Dichotomy conjecture). For each boolean conjunctive query q, the problem
certain(q) is either in PTime or coNP-complete.
The conjecture has been proved in the case of self-join-free queries [KW17] and of path
queries [KOW21]; however, it remains open in the general case. A boolean conjunctive query
is self-join-free if all its atoms involve different relational symbols, otherwise, it is a self-join
query. A path query is a boolean conjunctive query with n + 1 distinct variables x0, x1, · · · xn
and n atoms A1 · · · An such that each atom Ai = Ri(xi−1 xi) for some symbol Ri of σ of
arity two. The path query may contain self-joins, in other words it may be the case that
Ri = Rj for some i̸ = j.

---

Vol. 21:1
A SIMPLE ALGORITHM FOR CQA UNDER PRIMARY KEYS
18:7
Example 2.2. Consider the following example queries taken from [KP12, KOW21] (recall
that all variables are implicitly existentially quantified). For the self-join-free boolean query
q1 ˆ= R1(x y) ∧R2(y z)
it is easy to see that the problem certain(q1) can be solved in polynomial time [KP12]. In
fact, the first-order formula ϕ := ∃xyz

R1(xy) ∧R2(yz) ∧∀y′ R1(xy′) →∃z′R2(y′z′)
is
such that for every database instance D, q1 is certain for D iff D |= ϕ.
For the self-join-free query and the path query
q2 ˆ= R1(x y) ∧R2(y x)
q′
2 ˆ= R(x1 x2) ∧X(x2 x3) ∧R(x3 x4) ∧Y (x4 x5) ∧R(x5 x6) ∧Y (x6 x7)
it has been shown, in [Wij10] and [KOW21] respectively, that certain(q2) and certain(q2′) can
be solved in polynomial time but cannot be expressed in first-order logic, unlike certain(q1).
The polynomial time algorithm described in the next section computes certain for q1, q2 and
q′
2 (see also Example 3.4).
Finally, for the self-join-free query and the path query
q3 ˆ= R1(x y) ∧R2(z y)
q′
3 ˆ= R(x1 x2) ∧X(x2 x3) ∧R(x3 x4) ∧X(x4 x5) ∧
R(x5 x6) ∧Y (x6 x7) ∧R(x7 x8) ∧Y (x8 x9)
both certain(q3) and certain(q′
3) are known to be coNP-complete [FM07, KOW21].
△
3. Polynomial time algorithm
To solve certain(q), we describe a family of algorithms Certk(q), where k ≥1 is a parameter.
For a fixed k and query q, Certk(q) takes a database as input and runs in time polynomial
in the size of the database, in such a way that Certk(q) is always an under-approximation
of certain(q), i.e., whenever Certk(q) says ‘yes’ then q is certain for the input database.
However, Certk(q) could give false negative answers.
In Section 4 and Section 5 we will show that for self-join-free queries either Certk(q)
computes certain(q) (where k is the number of atoms occurring in q) or certain(q) is coNP-
complete in which case Certk(q) fails to compute certain(q) for every k ≥1. In Section 6 we
show an analogous result for path queries.
The algorithm inductively computes sets of facts maintaining the invariant that every
repair containing one of these sets makes the query true. The algorithm returns ‘yes’ if the
empty set is eventually derived (since all repairs contain the empty set).
We now describe the algorithm. Assume q, Γ and k are fixed. Let D be a database. A
k-set over D is a set S of facts of D of size at most k.
We denote by Certk(q) the Algorithm 1. On a database input D, the algorithm Certk(q)
inductively computes a set ∆k(q, D) of k-sets over D while maintaining the following
invariant:
For every repair r of D and every S ∈∆k(q, D), if S ⊆r then r |= q.
(Inv)
Initially ∆k(q, D) contains all k-sets S such that S |= q. In other words, we start with
all solutions to q in all repairs of D. Clearly, this satisfies the invariant (Inv). Now we
iteratively add a k-set S to ∆k(q, D) if there exists a block B of D such that for every fact

---

18:8
D. Figueira, A. Padmanabha, L. Segoufin, and C. Sirangelo
Vol. 21:1
Algorithm 1 Certk(q)
1: Input: database D
2: initialize ∆k(q, D) with all k-sets S of D such that S |= q
3: while there is a k-set S̸ ∈∆k(q, D) and a block B of D such that for every fact u ∈B
there exists S′ ⊆S ∪{u} where S′ ∈∆k(q, D) do
4:
update ∆k(q, D) ←∆k(q, D) ∪{S}
5: end while
6: if ∅∈∆k(q, D) then
7:
return YES
8: else
9:
return NO
10: end if
u ∈B there exists S′ ⊆S ∪{u} such that S′ ∈∆k(q, D). Again, it is immediate to verify
that the invariant (Inv) is maintained.
This is an inflationary fixpoint algorithm. Note that both the initial and induction steps
can be expressed in FO because all sets of facts S computed by the fixpoint have size at
most k, and each set can be represented by a tuple of k elements. A relation of arity k can
then encode ∆k. The initial condition adds any k-set that contains a solution to q, and the
induction step again adds only k-sets. Thus, if n is the number of facts of D, the fixpoint
is reached in O(nk) steps. In the end, Certk(q) returns ‘yes’ iff the empty set belongs to
∆k(q, D). Equivalently, Certk(q) returns ‘yes’ if there is a block B of D such that for all
facts u of B the set {u} belongs to ∆k(q, D). We write D |= Certk(q) or D ∈Certk(q) to
denote that Certk(q) returns ‘yes’ upon input D.
The following properties are now immediate.
Proposition 3.1. For all q, Γ, k, Certk(q) runs in time polynomial in the size of its input
database D and, if D |= Certk(q) then D |= certain(q).
Proposition 3.2. For all q, Γ, k, k′ if k′ ≥k then for every database D, if D |= Certk(q)
then D |= Certk′(q).
In order to simplify the notations, as we will mostly consider the case where k is the
number of atoms in q, we write ∆(q, D) and Cert(q) to denote ∆k(q, D) and Certk(q)
respectively, where k is the number of atoms of q. Also, for a fact u, we sometimes write
u ∈∆k(q, D) instead of {u} ∈∆k(q, D).
We denote ∆k(q, D, i) to be the set ith step of
the computation of ∆k(q, D). The following proposition is immediate from the definitions.
Proposition 3.3. For all q, Γ, k, i if S ∈∆k(q, Γ, i) and S′ ⊇S such that |S′| ≤k then
S′ ∈∆k(q, Γ, i).
Example 3.4. Consider again the query q2 : R1(x y) ∧R2(y x) from Example 2.2. Let
k = 2 and consider the execution of Cert2(q2). For a given input database D, initially
∆(q2, D) contains all pairs of facts {R1(ab), R2(ba)} such that both R1(ab) and R2(ba) are
in D. The first iterative step adds to ∆(q2, D) (i) all singletons {R1(ab)} such that R2(ba)
is a fact of D whose block contains only R2(ba), and (ii) analogously all {R2(ab)} such that
the block of R1(ba) is a singleton.
In subsequent steps, the empty set is added to ∆(q2, D) if at some point, there is some
block B such that for every fact u ∈B we have u ∈∆(q2, D). At this point the algorithm

---

Vol. 21:1
A SIMPLE ALGORITHM FOR CQA UNDER PRIMARY KEYS
18:9
outputs ‘yes’ and if ∆(q2, D) saturates without the empty set as its member, then the
algorithm outputs ‘no’.
We show that Cert2(q2) computes certain(q2) or, in other words, D |= certain(q2) iff
D |= Cert2(q2).
Observe that, for every repair r and fact α therein, there is at most one other fact α′ in
r such that {α, α′} |= q2. This is because in any repair the first atom of q2 determines the
second atom and vice-versa. This “mutual determinacy” is, in fact, what makes Cert2(q2) a
complete procedure, as we shall see next.
In view of Proposition 3.1, it remains to show that if q2 is certain for D then ∆(q2, D)
contains the empty set. Towards this we use the following observation about q2.
Claim 3.5. If r is a minimal repair and both facts R1(ab) and R2(ba) are in r then
R1(ab) ∈∆(q2, D).
Assume that the claim is true. Now suppose q2 is certain for D, then for any minimal
repair r, we must have r |= q and this is witnessed by two facts R1(ab) and R2(ba) of r. Let
B be the block of R1(ab). Let us show that all facts of B are in ∆(q2, D) as singleton sets
and hence ∅∈∆(q2, D). Let R1(ab′) be such a fact and consider the repair r′ obtained by
replacing R1(ab) with R1(ab′). As r is minimal it follows immediately that r′ is minimal and
must contain R2(b′a) (again, this is ensured by the mutual determinacy of q2). From the
claim it follows that R1(ab′) ∈∆(q2, D), as desired. Thus it remains to prove the Claim 3.5.
Proof of Claim 3.5. Assume that r is a minimal repair containing both R1(ab) and R2(ba).
Towards a contradiction, suppose R1(ab)̸ ∈∆(q2, D) then we shall construct an infinite
sequence u1, u2, . . . of distinct facts of D, contradicting the finiteness of D. Towards this we
additionally construct an infinite sequence v1, v2, . . . of facts of D and an infinite sequence
of minimal repairs r1, r2, . . . maintaining the following invariants for every i:
(1) the ui’s are pairwise distinct;
(2) ui̸ ∈∆(q2, D);
(3) if ui = R1(cd) then vi = R2(dc) and if ui = R2(cd) then vi = R1(dc);
(4) ui+1 ∼vi and ui+1̸ = vi;
(5) ri is minimal and contains vi and each uj for all j ≤i.
Initially r1 = r, u1 = R1(ab) and v1 = R2(ba) and all the invariant conditions are met:
(1) is trivial, (2) and (5) follow from the assumption, (3) is true by construction and (4)
does not apply.
Consider step i. Consider the block Bi of vi. As {ui}̸ ∈∆(q2, D) it means that we
cannot use any block B as a witness to add ui to ∆(q2, D) (i.e., for every block B there
is some fact w ∈B such that {ui, w}̸ ∈∆(q2, D)). Hence, in particular, Bi must contain
an element ui+1 such that both ui+1̸ ∈∆(q2, D) and {ui, ui+1}̸ ∈∆(q2, D). In particular
ui+1 ∼vi but ui+1̸ = vi and items (2) and (4) of our induction hypothesis are met. Towards
the first item of our induction hypothesis, if ui+1 = uj for some j ≤i then by item (5) the
repair ri would contain two equivalent facts, vi and ui+1 = uj, which is not possible since
we have already established that ui+1̸ = vi.
Consider the repair ri+1 resulting from replacing vi with ui+1. Let vi+1 be the dual fact
of ui+1 as required by the third item of the invariant. As uivi forms a solution to q in ri
and ri is minimal, we must have vi+1 ∈ri+1 (otherwise ri+1 has strictly fewer solutions than
ri). Finally, notice that ri+1 is minimal as its solutions to q are exactly the same as for ri

---

18:10
D. Figueira, A. Padmanabha, L. Segoufin, and C. Sirangelo
Vol. 21:1
except for uivi that has been removed and ui+1vi+1 that has been added (by the mutual
determinacy of the atoms of q2).
Here is a depiction of how the ui’s and vi’s are defined, where the full and hollow arrows
correspond to R1 and R2 respectively.
a
<latexit sha1_b
ase64="KwZiepZD+LmRGetR/NeQHz
UhN4=">AB6HicbZDLSgNBEVrfMb
4irp0xgUV2FGgroz4MZlAuYByRB6O
jVJm54H3T1CGPIFblwoEpf+hb/hzr+
xJ8lCEy80HO6toqvKiwVX2ra/rZXVt
fWNzdxWfntnd2+/cHDYUFEiGdZJCL
Z8qhCwUOsa64FtmKJNPAENr3hbZY3H
1EqHoX3ehSjG9B+yH3OqDZWzesWinb
JnosgzOH4s3nJN7tVv46vQilgQYa
iaoUm3HjrWbUqk5EzjOdxKFMWVD2s
e2wZAGqNx0OuiYnBqnR/xImhdqMnV/
d6Q0UGoUeKYyoHqgFrPM/C9rJ9q/dl
MexonGkM0+8hNBdESyrUmPS2RajAxQ
JrmZlbABlZRpc5u8OYKzuPIyNC5Kzm
WpXCsXK2cwUw6O4QTOwYErqMAdVKEO
DBCe4AVerQfr2XqzJrPSFWvecwR/ZH
38AOE+kWI=</latexit>b
u1
v1
u2
v2
u3
v3
u4
v4
u5
v5
. . .
This concludes the construction of the infinite sequence, showing that R1(ab) ∈∆(q2, D)
for any minimal repair containing both R1(ab) and R2(ba) which proves claim.
This concludes our Example 3.4.
△
Certk does not always compute the certain answers. For instance, the query q3 from
Example 2.2 is so that certain(q3) is coNP-complete, and hence Certk(q3) must have false
negatives for all k, under the hypothesis that coNP̸ = PTime. Proving this without relying
on complexity theoretic assumptions is the goal of Section 5 for self-join-free queries and
Section 6.2 for path queries.
4. Tractable self-join-free queries
In this section we consider the case of self-join-free queries. We exhibit a condition named
PCond (for Polynomial time Condition) and show that any self-join-free query q satisfying
PCond is such that Certk computes certain(q), where k is the number of atoms in q. When
PCond fails, we will see that for all values of k, Certk fails to compute certain(q) and
moreover, certain(q) is coNP-hard.
We start by defining PCond, which will require some extra definitions. Fix, for the rest
of this section, a set Γ of primary key constraints. Let D be a database and r a repair of D.
For a fact u of r, and for an equivalent fact v ∼u from D, we denote by r[u →v] the repair
obtained from r by replacing the fact u with v.
Consider a self-join-free query q with k atoms. Recall that we write D |= q(¯u) when ¯u is
a solution to q in D. As q is self-join-free, for each fact a in a solution ¯u there is a unique
atom of q that a can match, namely the only fact of q having the same relation symbol as a.
Hence, the order on both ¯u and the atoms of q are not relevant. With some abuse of notation
we will therefore often treat a solution ¯u, or the sequence of atoms of q, as a set rather than
a sequence; we will often use different orders among the facts of a solution, placing up front
the most relevant facts. Also we shall write, for a tuple ¯u of facts, ¯u ∈∆k(q, D) to denote
that the set formed by the facts of ¯u is a k-set and belongs to ∆k(q, D).
Let A be an atom of q whose associated symbol is R. We denote by vars(A) the set
of variables of A and by key(A) the set of variables of A occurring in a position belonging
to the primary key of R. For instance key(R(x y)) is {x}, key(R′(yz x)) is {y, z} and
key(R′′(xzx y )) is {x, z}.
Given a set X of variables of q and a sequence A1 . . . An of atoms of q, we say that
X A1 . . . An is a Γ-derivation from X to An in q if for each 1 ≤i ≤n we have that
key(Ai) ⊆X ∪
[
1≤j<i
vars(Aj).

---

Vol. 21:1
A SIMPLE ALGORITHM FOR CQA UNDER PRIMARY KEYS
18:11
If X = vars(A0), for some atom A0 of q, we say that the Γ-derivation is from A0 to An,
and write it as A0A1 . . . An. We say that an atom A′ is Γ-determined by the atom A if there
exists a Γ-derivation from A to A′. Moreover, A and A′ are mutually Γ-determined if A′ is
Γ-determined by A and A is Γ-determined by A′. This is an equivalence relation among
atoms. A set S of atoms of q is called stable if every two distinct facts of S are mutually
Γ-determined. Note that if an atom A is in a stable set S then S need not contain all the
atoms that are mutually Γ-determined by A. So a partition of the atoms of q into stable sets
is a refinement of the partition induced by mutual Γ-determinacy. Notice also that if two
atoms A and B are in a stable set S, we do not require that S contains the atoms witnessing
their mutual determinacy. As usual, we will omit Γ when it is clear from the context.
The main intuition on how we will use Γ-derivations is the following. Suppose there is a
query q with atoms A1, . . . , An which has solutions in two repairs r, r′ of a database, witnessed
by valuations µ, µ′. If there is a (one-step) derivation “X A1”, this means that key(A1) ⊆X,
so if µ, µ′ agree on X, in particular they agree on key(A1) (that is, the corresponding atoms
µ(A1) and µ′(A1) are Γ-equivalent). Further, if µ(A1) ∈r′, we can actually say that µ, µ′
agree on all the variables in vars(A1), since the repairs must necessarily have the same
A1-fact under the key µ(key(A1)) = µ′(key(A1)). Now if we were to add another step in
the derivation “X A1 A2”, we further have key(A2) ⊆X ∪vars(A1). Since µ, µ′ agree on
X ∪vars(A1), we now have µ(A2) and µ′(A2) are Γ-equivalent. This key property relating
Γ-derivations and query solutions (and extended to arbitrary length derivations) is formally
stated in the lemma below.
Lemma 4.1. Let q be a self-join-free query. Let D be a database instance and r, r′ be two
repairs of D. Let X be a set of variables of q and let X A1 . . . An be a Γ-derivation from
X to An in q. Let q(r) contain a solution witnessed by a valuation µ of variables of q, and
q(r′) contain a solution witnessed by a valuation µ′. If µ and µ′ agree on X and µ(Ai) ∈r′
for all i < n, then:
1) µ(Ai) = µ′(Ai) for each i < n and
2) µ(An) ∼µ′(An) (and therefore µ(An) = µ′(An) if moreover µ(An) ∈r′).
Proof. The proof is by induction on n.
For n = 1 the statement trivially holds since
key(A1) ⊆X thus µ(A1) ∼µ′(A1).
Now consider a sequence XA1 . . . An, n > 1 satisfying the hypotheses. The induction
hypothesis applied to the sequence XA1 . . . An−1 implies µ(Ai) = µ′(Ai), for all 1 ≤i ≤n−1.
Then µ and µ′ agree on vars(A1) ∪· · · ∪vars(An−1).
Since XA1 . . . An is a Γ-derivation sequence, we have key(An) ⊆X ∪vars(A1) ∪· · · ∪
vars(An−1); hence µ and µ′ agree on key(An), or in other words µ(An) ∼µ′(An).
Corollary 4.2. Let q be a self-join-free query and S be a stable set of atoms of q. Let D be
a database instance and r be a repair of D. Assume r |= q(¯α¯a¯β) and r |= q(¯α′¯a′ ¯β′), where ¯a
and ¯a′ match S. If ¯a ∩¯a′̸ = ∅then ¯a = ¯a′.
Proof. The statement follows directly from Lemma 4.1 using r = r′. Take a1 as any fact in
¯a∩¯a′, A1 being the atom matched by a1, X being vars(A1) and A1 . . . Ak being a Γ-derivation
sequence containing all S (which exists by stability).
We are now ready to define PCond. A Γ-sequence τ of q is a sequence τ = S1S2 · · · Sn
where each Si is a stable set of atoms of q, and the Si’s form a partition of q. In this context,
we denote by S≤i the set S
j≤i Sj. We define S0 to be the empty set.

---

18:12
D. Figueira, A. Padmanabha, L. Segoufin, and C. Sirangelo
Vol. 21:1
Let τ = S1S2 · · · Sn be a Γ-sequence of q. Let 1 ≤i < n and let A be an atom of Si+1.
We say that the query q satisfies PCondτ(A) and write q |= PCondτ(A) if the following is
true for all databases D, all repairs r of D and all solutions ¯αu¯β and ¯α′u′ ¯β′ to q in D such
that ¯α and ¯α′ match S≤i and u and u′ match A:
If





r |= q(¯αu¯β),
u ∼u′, and
r[u →u′] |= q(¯α′u′ ¯β′)





then r |= q(¯α′u¯δ) for some sequence of facts ¯δ.
Note that, by symmetry, we also have r[u →u′] |= q(¯αu′¯δ′) for some sequence of facts δ′.
We write q |= PCondτ(i) if q satisfies PCondτ(A) for all A of Si+1, and we write q |= PCondτ
if q satisfies PCondτ(i) for all 1 ≤i < n. Since the condition is restricted to indices i < n,
PCondτ trivially holds for any τ having only one stable set. Finally, we write q |= PCond if
there is a Γ-sequence τ of q such that q |= PCondτ. Again, if q has only one Γ-determinacy
class (for instance the query q2 of Example 3.4) then q |= PCond in a trivial way.
We illustrate the definition of PCond with the following examples.
Example 4.3. We recall the three queries from Example 2.2. The query q2 = R1(x y) ∧
R2(y x) satisfies PCond since it has only one maximal stable set.
The query q1 = R1(x y) ∧R2(y z) has two stable sets: R1(x y) determines R2(y z) but
the converse is false. For τ = {R2(y z)}{R1(x y)} we have q̸ |= PCondτ because we have
the solutions q1(R2(bc)R1(ab)) and q1(R2(b′c)R1(ab′)) but not q1(R2(bc)R1(ab′)). However
for τ = {R1(x y)}{R2(y z)} it is easy to verify that q1 |= PCondτ. Hence, q1 |= PCond.
The query q3 = R1(x y) ∧R2(z y) has also two stable sets, but no possible sequence
τ makes PCondτ true. This is because (i) q3(R1(ab) R2(cb)) and q3(R1(a′b′) R2(cb′)) hold,
but not q3(R1(ab) R2(cb′)), and (ii) q3(R2(ab) R1(cb)) and q3(R2(a′b′) R1(cb′)) hold, but
not q3(R2(ab) R1(cb′)). Therefore, q3̸ |= PCond.
△
Our goal for the remaining part of this section is to show that q |= PCond implies that
Cert(q) computes certain(q) (Recall that Cert(q) denotes Certk(q) where k is the number of
atoms in q) which is given by Theorem 4.4. In Section 5 we will see that when q̸ |= PCond
then certain(q) cannot be computed by Certk for any choice of k and that certain(q) is
actually coNP-hard.
Theorem 4.4. Let q be a self-join-free query with k atoms. If q |= PCond, then Certk(q)
computes certain(q).
Suppose q has k atoms. Let τ = S1 · · · Sn be a Γ-sequence of q such that q |= PCondτ.
We show that Certk(q) computes precisely certain(q).
If q has only one stable set (and thus it trivially satisfies PCond), the proof is similar
to the proof of Example 3.4, starting with a minimal repair and exploiting the mutual
determinacy of the atoms of q. If q has more stable sets, then the condition of minimality
needs to be more fine-grained and we proceed by induction on the index of the stable sets,
in the order described by τ.
We start with some extra notations. Recall that q(r) denotes the set of solutions to q in
a repair r; we additionally denote by q≤i(r) the projection of q(r) on the first i stable sets
of τ. More precisely
q≤i(r) = {¯v | ∃¯u ∈q(r) s.t. ¯v is the subset of ¯u matching S≤i},

---

Vol. 21:1
A SIMPLE ALGORITHM FOR CQA UNDER PRIMARY KEYS
18:13
and if ¯v ∈q≤i(r) we write equivalently r |= q≤i(¯v). Let D be a database and r a repair of D.
We say that r is i-minimal if there is no repair r′ such that q≤i(r′) ⊊q≤i(r). We say that a
fact u of a database D is i-compatible, if it matches some atom of Si. We will need the limit
case when i = 0. In that case both S0 as well as S≤0 are empty sets (and hence PCondτ(0)
is always true), q≤0(r) contains only the empty sequence ε for all r, and therefore all repairs
are 0-minimal. The proof of the theorem makes use of an induction based on the following
invariant property of the database, for each 0 ≤i ≤n:
Indi = For all i-minimal repairs s and facts ¯u s.t. s |= q≤i(¯u), we have ¯u ∈∆k(q, D).
Lemma 4.5. Given q, D and a Γ-sequence τ for q, for every 0 ≤i < n, if Indi+1 and
PCondτ(i), then Indi.
We first show how this statement already implies Theorem 4.4.
Proof of Theorem 4.4. From Proposition 3.1, we know that if D is a database such that
D |= Certk(q) then all repairs of D satisfy q. It remains to show the converse.
Assume all repairs satisfy q and that q |= PCondτ for some sequence τ of length n,
which means that PCondτ(i) holds for all i. Observe that Indn holds true by the base
case definition of ∆k(q, D). Hence by n repeated applications of Lemma 4.5 we obtain that
Ind0 holds true. Now take any repair r. By definition r is 0-minimal and by hypothesis it
satisfies the query q. By Ind0 it follows that the empty set (denoted by the empty tuple) is
in ∆k(q, D), and hence D |= Certk(q).
We are now left with the proof of Lemma 4.5, which is the main technical content of
the section. Towards this, we define a stronger version of i-minimality. For 1 ≤i < n,
we say that an i-minimal repair s is strong i-minimal if there exists no repair s′ such that
q≤i(s′) = q≤i(s) and |q≤i+1(s′)| < |q≤i+1(s)|. Note that if q≤i+1(s′) ⊊q≤i+1(s) then either
q≤i(s′) ⊊q≤i(s) or q≤i(s′) = q≤i(s) but |q≤i+1(s′)| < |q≤i+1(s)|. In particular, every strong
i-minimal repair is (i + 1)-minimal.
Claim 4.6. If there exists an i-minimal repair s such that s |= q≤i(¯u), then there exists a
strong i-minimal repair s′ such that s′ |= q≤i(¯u).
Proof. Among all repairs s′′ having q≤i(s′′) = q≤i(s), choose s′ as having minimal |q≤i+1(s′)|.
In other words, s′ is a repair having q≤i(s′) = q≤i(s) and for every repair s′′ with q≤i(s′′) =
q≤i(s) we have |q≤i+1(s′)| ≤|q≤i+1(s′′)|. Hence, s′ is strong i-minimal.
For a given database D, for a repair r of D, we denote by r|i+1 the set of facts of r
which are not (i + 1)-compatible. A sequence ¯p of facts of the database is connected with
respect to D′ ⊆D if for every repair r containing ¯p and D′, and for every two consecutive
facts a b of ¯p, if r |= q(¯αa¯β) for some ¯α, ¯β, then b ∈¯α¯β. Note that if ¯p is the empty tuple
(or a tuple of size 1), then ¯p is trivially connected with respect to every D′ ⊆D.
Proof of Lemma 4.5. By contradiction, suppose the statement of the lemma is false. Then,
there is some i such that Indi+1 and PCondτ(i) holds, but for some i-minimal repair s and
tuple ¯u we have
s |= q≤i(¯u) but ¯u̸ ∈∆k(q, D).
(h1)
From Claim 4.6, we can assume that s is strong i-minimal. We will build an infinite
sequence of pairwise distinct facts p1, p2, . . . from D, contradicting the finiteness of D. We

---

18:14
D. Figueira, A. Padmanabha, L. Segoufin, and C. Sirangelo
Vol. 21:1
also maintain another sequence of repairs r1, r2, . . . . We set r0 = s. For all l > 0, we define
¯pl = p1, . . . , pl with ¯p0 as the empty fact sequence.
The sequence is constructed by induction with the following invariant for every l ≥0,
assuming ¯p = ¯pl and r = rl:
(a) ¯p contains only (i + 1)-compatible facts of D;
(b) the elements of ¯p are pairwise distinct;
(c) ¯p is connected with respect to r|i+1;
(d) r is strong i-minimal, r |= q≤i(¯u) and, if ¯p is not empty and v is the last fact of ¯p, then
r |= q(¯uv¯δ), for some ¯δ;
(e) ¯u¯c̸ ∈∆k(q, D), where ¯c is the maximal suffix of ¯p satisfying r′ |= q(¯u¯c¯β) for some ¯β and
strong i-minimal repair r′ containing ¯p and r|i+1.
Base case. When l = 0, we have r0 = s and ¯p is the empty sequence. Hence (a), (b) and (c)
are trivially true by emptiness of ¯p; (d) holds since s |= q≤i(¯u) (note that we have assumed
s to be strong i-minimal); finally (e) holds with empty ¯c since ¯u /∈∆k(q, D) by (h1).
Induction step. Assume we have r = rl−1 and ¯pl−1 = p1, . . . , pl−1 (possibly empty) satisfying
the five properties above (for the rest of the proof we denote ¯pl−1 as ¯p for brevity). Consider
the maximal suffix ¯c concerned by property (e). That is, for some ¯β and strong i-minimal
repair r′ containing ¯p and r|i+1 we have:
¯u¯c̸ ∈∆k(q, D) and r′ |= q(¯u¯c¯β)
(h2)
First let ¯β = d1d2, . . . dt. Since ¯u¯c̸ ∈∆k(q, D), by definition of ∆k(q, D) there exists some
d′
1 ∼d1 such that ¯u¯cd′
1̸ ∈∆k(q, D). This again implies that there exists some d′
2 ∼d2 such
that ¯u¯cd′
1d′
2̸ ∈∆k(q, D). Since k is the number of atoms in q, we can continue this to obtain
¯β′ = d′
1d′
2 . . . d′
t where d′
i ∼di but ¯u¯c¯β′ contains no k-set in ∆k(q, D).
We now show that ¯c cannot match the entire set Si+1. Suppose, by means of contradiction,
that r′ |= q≤i+1(¯u¯c). As r′ is strong i-minimal, it is (i + 1)-minimal. Hence by (h1), since
Indi+1 holds by hypothesis, ¯u¯c ∈∆k(q, D), which is in contradiction with (h2). Then,
r′ |= ¬q≤i+1(¯u¯c).
(h3)
This means that, since r′ |= q(¯u¯c¯β) by (h2), and ¯c matches a subset of Si+1, there must
be an atom C of Si+1 that is not matched by any fact of ¯c. Consider the atom A of Si+1
matching the last element of ¯c. If instead ¯c is empty, choose A as an arbitrary atom of Si+1.
Since A and C are both in Si+1, which is stable, there exists a Γ-derivation σ from A to
C. (Notice that σ may contain atoms outside Si+1.) Consider the first atom B of σ which
is in Si+1 and which is not matched by any fact of ¯c. The following depiction may help to
see the situation:
Si+1
¯c =
¯β0 =
¯β =
RpdEAsyGTXn1BUY0Y28=">AB6HicbVBNS8NAEJ3Ur1q/qh69LC2Cp5K
IqMeCF48t2A9oQ9lsJ+3azSbsboQS+gu8eFDEqz/Jm/GbZuDtj4YeLw3
w8y8IBFcG9f9dgobm1vbO8Xd0t7+weFR+fikreNUMWyxWMSqG1CNgktsG
W4EdhOFNAoEdoLJ3dzvPKHSPJYPZpqgH9GR5CFn1FipGQzKVbfmLkDWiZe
TKuRoDMpf/WHM0gilYJq3fPcxPgZVYzgbNSP9WYUDahI+xZKmE2s8W
h87IuVWGJIyVLWnIQv09kdFI62kU2M6ImrFe9ebif14vNeGtn3GZpAYlWy
4KU0FMTOZfkyFXyIyYWkKZ4vZWwsZUWZsNiUbgrf68jpX9a865rXvKr
WK3kcRTiDClyABzdQh3toQAsYIDzDK7w5j86L8+58LFsLTj5zCn/gfP4A
vTmMzA=</latexit>b
b0
FOiGmxXWotAxLFdaI8A=">AB6HicbVBNS8NAEJ34WetX1aOXpUXwVBI
R9Vjx4rEF+wFtKJvtpF272YTdjVBCf4EXD4p49Sd589+4bXPQ1gcDj/dm
mJkXJIJr47rfztr6xubWdmGnuLu3f3BYOjpu6ThVDJsFrHqBFSj4BKbh
huBnUQhjQKB7WB8N/PbT6g0j+WDmSToR3QoecgZNVZq3PZLFbfqzkFWiZe
TCuSo90tfvUHM0gilYJq3fXcxPgZVYzgdNiL9WYUDamQ+xaKmE2s/m
h07JmVUGJIyVLWnIXP09kdFI60kU2M6ImpFe9mbif143NeGNn3GZpAYlWy
wKU0FMTGZfkwFXyIyYWEKZ4vZWwkZUWZsNkUbgrf8ipXVS9q6rXuKz
UynkcBTiFMpyDB9dQg3uoQxMYIDzDK7w5j86L8+58LFrXnHzmBP7A+fwB
izWMqw=</latexit>A
mjcTrq82WCeVNuJMG2JE=">AB6HicbVBNS8NAEJ34WetX1aOXpUXwVBI
R9Vj04rEF+wFtKJvtpF272YTdjVBCf4EXD4p49Sd589+4bXPQ1gcDj/dm
mJkXJIJr47rfztr6xubWdmGnuLu3f3BYOjpu6ThVDJsFrHqBFSj4BKbh
huBnUQhjQKB7WB8N/PbT6g0j+WDmSToR3QoecgZNVZq3PZLFbfqzkFWiZe
TCuSo90tfvUHM0gilYJq3fXcxPgZVYzgdNiL9WYUDamQ+xaKmE2s/m
h07JmVUGJIyVLWnIXP09kdFI60kU2M6ImpFe9mbif143NeGNn3GZpAYlWy
wKU0FMTGZfkwFXyIyYWEKZ4vZWwkZUWZsNkUbgrf8ipXVS9q6rXuKz
UynkcBTiFMpyDB9dQg3uoQxMYIDzDK7w5j86L8+58LFrXnHzmBP7A+fwB
jLmMrA=</latexit>B
ed2LDC+oedrzaHyfwcs=">AB6HicbVBNS8NAEJ34WetX1aOXpUXwVBI
R9VjoxWML9gPaUDbSbt2swm7G6GE/gIvHhTx6k/y5r9x2+agrQ8GHu/N
MDMvSATXxnW/nY3Nre2d3cJecf/g8Oi4dHLa1nGqGLZYLGLVDahGwSW2D
DcCu4lCGgUCO8GkPvc7T6g0j+WDmSboR3QkecgZNVZq1gelilt1FyDrxMt
JBXI0BqWv/jBmaYTSMEG17nluYvyMKsOZwFmxn2pMKJvQEfYslTRC7WeL
Q2fkwipDEsbKljRkof6eyGik9TQKbGdEzVivenPxP6+XmvDOz7hMUoOSLR
eFqSAmJvOvyZArZEZMLaFMcXsrYWOqKDM2m6INwVt9eZ20r6reTdVrXld
q5TyOApxDGS7Bg1uowT0oAUMEJ7hFd6cR+fFeXc+lq0bTj5zBn/gfP4A
j2MrQ=</latexit>C
¯u =
Si
Si+2
S1
· · ·
· · ·
· · ·
· · ·
· · ·
· · ·
· · ·
· · ·
In the picture directed edges connecting atoms of the query represent the successor
relation in the Γ-derivation from A to C.

---

Vol. 21:1
A SIMPLE ALGORITHM FOR CQA UNDER PRIMARY KEYS
18:15
Let b be the fact of ¯β matching B and b′ ∼b be the corresponding fact in ¯β′. We show
that
b̸ ∈¯p.
(h4)
Suppose b is in ¯p. By construction, b is not in ¯c, thus it must occur before ¯c in ¯p and hence
the suffix ¯b of ¯p starting with b strictly contains ¯c. By connectedness of ¯p with respect to
r|i+1, as b ∈¯β is part of the solution ¯u¯c¯β, we must have r′ |= q(¯u¯b¯γ) for some ¯γ. This
contradicts the maximality of ¯c imposed by (e), thus proving that (h4) holds. Note that this
also implies b′̸ ∈¯p, otherwise if b′ ∈¯p, we have that b′ ∼b are both in r′, thus b = b′ ∈¯p,
contradicting (h4).
Assign pl = b′, so we have ¯p′ = ¯p · pl and let rl = r′[b →b′]. (To avoid many subscripts,
let rl = s′). Observe that
s′ contains ¯p′ and r|i+1.
(h5)
In fact s′ contains ¯p, as observed earlier, and s′ contains b′ by construction; moreover s′
contains r′
|i+1 which contains r|i+1 by (e). We now show that ¯p′ and s′ have all the desired
properties.
(a) By construction b′ is (i + 1)-compatible.
(b) The elements of ¯p′ are pairwise distinct, as b′̸ ∈¯p.
(c) By our choice of b we show that ¯p′ is connected with respect to s′
|i+1. Without loss of
generality assume that ¯p′ has at least size 2 (otherwise it is trivially connected). Therefore,
¯p is not empty. Since s′
|i+1 contains r|i+1 by (h5), the connectedness property of ¯p with
respect to r|i+1 implies that for every repair containing ¯p′ and s′
|i+1 and for every pair of
consecutive facts a b in ¯p, every solution in s′ containing a also contains b.
It remains to show the same property for the last fact a of ¯p. Consider a repair t
containing ¯p′ and s′
|i+1 and suppose t |= q(¯γa¯δ) for some ¯γ and ¯δ. We have to show b′ ∈¯γ¯δ.
Let σAB be the prefix of the Γ-derivation σ going from A to B in the Γ-derivation from A
to C. (Notice that, since ¯p is not empty we have A̸ = B.) By property (d) of ¯p, since ¯p
is not empty, a is the last fact in ¯c. Recall that by (h2) r′ |= q(¯u¯c¯β); thus in this solution
the atom A is matched by a. So we can apply Lemma 4.1 to r′ and t with solutions (¯u¯c¯β)
and (¯γa¯δ) respectively, and Γ-derivation vars(A) σAB. The hypotheses of Lemma 4.1 are
satisfied since:
• in both solutions A is matched by a;
• by construction of B, for each atom D strictly preceding B in σAB, the fact matching
D in (¯u¯c¯β) is either in ¯c or in r′
|i+1, both contained in t (in fact t ⊇¯p′ ⊇¯p ⊇¯c and
t ⊇s′
|i+1 ⊇r′
|i+1).
We conclude, by Lemma 4.1, that the facts matching B in the two solutions are equivalent,
i.e., the fact matching B in (¯γa¯δ) is equivalent to b (which is the fact matching B in ¯u¯c¯β).
In t the unique fact equivalent to b is b′ (since b′ ∈¯p′ ⊆t), thus the fact matching B in
(¯γa¯δ) is b′. We have thus proved that any solution in t containing the last fact a of p also
contains b′.
(d) The following claim, together with strong i-minimality of r′ and r′ |= q(¯ub¯γ) for some
¯γ, shows that
(I) s′ is also strong i-minimal,
(II) s′ |= q≤i(¯u), and

---

18:16
D. Figueira, A. Padmanabha, L. Segoufin, and C. Sirangelo
Vol. 21:1
(III) s′ |= q(¯ub′¯δ) for some ¯δ.
Claim 4.7. Assume PCondτ(i). Let s be a strong i-minimal repair such that s |= q(¯αa¯β)
where ¯α matches S≤i and a is (i + 1)-compatible. Then for any a′ ∼a we have that
s′ = s[a 7→a′] is strong i-minimal and s′ |= q(¯αa′¯δ) for some ¯δ.
Proof. Notice that s and s′ agree on all their solutions to q that contain neither a nor
a′. Hence, if a′ is in no solution for q in s′, we have q≤i+1(s′) ⊊q≤i+1(s) and therefore
|q≤i+1(s′)| < |q≤i+1(s)| and q≤i(s′) ⊆q≤i(s). The latter implies q≤i(s′) = q≤i(s) by i-
minimality of s. This contradicts strong i-minimality of s. Hence s′ |= q(¯α′a′ ¯β′), for some
¯α′, ¯β′. By PCondτ(i) this implies that s′ |= q(¯αa′¯δ) for some ¯δ.
It remains to prove that s′ is strong i-minimal. To this end, we exhibit a bijection from
q≤i+1(s) to q≤i+1(s′) preserving the (S1 ∪· · · ∪Si)-projection of the solutions. The existence
of such bijection implies q≤i(s) = q≤i(s′) and |q≤i+1(s)| = |q≤i+1(s′)|, thus showing that s′
is strong i-minimal, provided s is too.
The mapping is the identity for the solutions that do not contain the fact a.
It remains to map bijectively solutions in s containing the fact a to solutions in s′
containing the fact a′. Let ¯a (resp. ¯a′) be the facts matching Si+1 in ¯αa¯β (resp. ¯α′a′ ¯β′).
By Corollary 4.2 in all solutions of s containing a, Si+1 is matched by ¯a. Similarly in all
solutions of s′ containing a′, Si+1 is matched by ¯a′.
Moreover, by PCondτ(i) for each ¯u, ¯u¯a ∈q≤i+1(s) iff ¯u¯a′ ∈q≤i+1(s′). Hence mapping
each ¯u¯a ∈q≤i+1(s) to ¯u¯a′ ∈q≤i+1(s′) forms a bijection.
(e) Let ¯e be the maximal suffix of ¯p′ such that, for a strong i-minimal repair t containing ¯p′
and s′
|i+1 we have t |= q(¯u¯e¯δ) for some ¯δ. Since s′ |= q(¯ub′¯δ′) for some ¯δ′ by Item (III) above,
¯e cannot be empty. Then let ¯e = ¯db′, where ¯d is a suffix of ¯p.
Since s′
|i+1 contains r|i+1 by (h5), in particular t is a strong i-minimal repair containing
¯p and r|i+1. Then, by maximality of ¯c, ¯d must be a suffix of ¯c, implying that ¯u ¯db′ is a
subset of ¯u¯c¯β′. Since by definition ¯u¯c¯β′ does not contain any k-set in ∆k(q, D), we have
¯u ¯db′̸ ∈∆k(q, D) as needed.
This completes the proof of Lemma 4.5.
5. Lower bounds
Now we turn to the lower bounds. In particular, we consider the self-join-free queries q
falsifying PCond and show that for such queries, certain(q) is coNP-hard. Towards proving
this we also obtain other results of independent interest. The results can be summarized as
follows.
(1) We first consider the query with self-join
q4 ˆ= R(x yz) ∧R(z xy).
We first show, in Theorem 5.1, via a combinatorial argument, that there is no k
such that certain(q4) can be computed using Certk(q4) (i.e., for every k there exists a
database D such that D |= certain(q) but Certk(q4) ouputs a false negative for D).

---

Vol. 21:1
A SIMPLE ALGORITHM FOR CQA UNDER PRIMARY KEYS
18:17
On the other hand we prove, in Theorem 5.9, that certain(q4) is equivalent (modulo
LogSpace reductions) to a matching problem whose precise complexity is a long-
standing open problem. This confirms the difficulty to obtain a complete complexity
classification of certain(q) for self-join queries q even on two atoms.2
(2) In Section 5.2 we show that for the self-join-free query
q5 ˆ= R1(x y) ∧S1(yz x),
certain(q5) cannot be computed using Certk(q5) for any choice of k. This is shown by
reducing the case of q5 to the case of q4.
(3) In Section 5.3 we describe some of the techniques developed in [KW17] and show that
they imply that for self-join-free queries q, certain(q) is coNP-hard when PCond fails
for q. In particular, assuming PTime̸ = coNP, this implies that when q̸ |= PCond,
certain(q) cannot be solved using Certk(q), for any choice of k.
(4) Finally, in Section 5.4 we prove, without any complexity theoretic hypothesis, that for
any self-join-free query q such that q̸ |= PCond, that certain(q) cannot be computed
using Certk(q) for any choice of k by reducing the case of q5 to such query q.
5.1. The case of q4. Note that the query q4 is not a self-join-free query. In particular, we
can have D |= q4(aa) for some fact a ∈D. We call such solutions self-loops.
To prove that Certk(q4) does not compute certain(q4) for any choice of k, we actually
prove a stronger statement: not even an extension “Cert+
k(q4)” of Certk(q4) can capture
certain(q4). This stronger form will be needed later for reducing q5 to q4.
Let us first explain the extension, which is tailored to two-atom queries (thus, strictly
speaking, it ‘extends’ Certk(q4) only in this context). Recall that the definition of Certk(q)
iteratively adds a k-set S to ∆k(q, D) if there exists a block B of D such that for every fact
u ∈B there exists S′ ⊆S ∪{u} such that S′ ∈∆k(q, D). This rule is henceforth called the
first derivation rule.
The algorithm Cert+
k(q) initializes the set ∆+
k(q, D) of k-sets as in Certk(q), and inherits
the aforementioned derivation rule of Certk(q), but it also contains the following second
derivation rule. A k-set S is also added to ∆+
k(q, D) if there exists a fact a of D which is
not a self-loop and for every fact u ∈{b ∈D : D |= q(ab) ∨q(ba) ∨a = b} there exists
S′ ⊆S ∪{u} such that S′ ∈∆+
k(q, D). As before, we define Cert+
k(q) to accept if the empty
set is eventually derived and denote it by D ∈Cert+
k(q).
Note that, like Certk(q), Cert+
k(q) also runs in polynomial time but it no longer satisfies
the inductive property (Inv) and may therefore give false positive answers. However, since
the first derivation rule is present in both Certk(q) and Cert+
k(q), whenever ∅∈Certk(q) we
also have ∅∈Cert+
k(q), i.e., if D ∈Cert+
k(q) then D ∈Certk(q). We now formally state the
first result of this subsection:
Theorem 5.1. For every choice of k, there exists a database D such that D |= certain(q4)
but D̸ ∈Cert+
k(q4) (and hence D̸ ∈Certk(q4)).
Before proving Theorem 5.1 we discuss some special properties of the query q4. Note
that q4 is a self-join two-atom query. We define the solution graph of D, denoted by GD,
to be an undirected graph whose vertices are the facts of D and it contains an edge {a, b}
2The dichotomy for two-atom queries has recently been proved in [PSS24]. Remarkably, the polynomial
cases are solved via a combination of the Certk algorithm and the bipartite matching algorithm.

---

18:18
D. Figueira, A. Padmanabha, L. Segoufin, and C. Sirangelo
Vol. 21:1
<latexit sha1_b
ase64="Ock96GzSURcCYgs8rQItxz2
kWME=">AB6nicbZDLSgMxFIbPeK
31VnXpJlgFV2VGirqz6MZlRXuBdi
ZNOGZpIhyQhl6CO4caFUt76Er+HOt
zHTdqGtPwQ+/v8cs4JYs60cd1vZ2
l5ZXVtPbeR39za3tkt7O3XtUwUoTUi
uVTNAGvKmaA1wynzVhRHAWcNoLBT
ZY3HqnSTIoHM4ypH+GeYCEj2Fjr/r
jdQpFt+ROhBbBm0Hx6nOc6a3aKXy1
u5IkERWGcKx1y3Nj46dYGUY4HeXbi
aYxJgPcoy2LAkdU+lk1BE6sU4XhVL
ZJwyauL87UhxpPYwCWxlh09fzWb+
l7USE176KRNxYqg04/ChCMjUbY36j
JFieFDC5goZmdFpI8VJsZeJ2+P4M2
vAj1s5J3XirflYuVY5gqB4dwBKfgw
QVU4BaqUAMCPXiCF3h1uPsjJ3ae
mSM+s5gD9yPn4A1SCR5A=</latex
it>B1
<latexit sha1_b
ase64="+qBImYMYvDUjE3nL3KUf8g
ODQY=">AB6nicbZDLSsNAFIZP6q
3W9Slm8EquCpJKerOohuXFe0F2lA
m0k7dDIJMxOhD6CGxdKdetL+Bruf
BsnbRfa+sPAx/+fw5xz/JgzpR3n28
qtrK6tb+Q3C1vbO7t79v5BQ0WJLRO
Ih7Jlo8V5UzQuma01YsKQ59Tpv+8
CbLm49UKhaJBz2KqRfivmABI1gb6/6
6W+7aRafkTIWwZ1D8epzkumt1rW/
Or2IJCEVmnCsVNt1Yu2lWGpGOB0XO
omiMSZD3KdtgwKHVHnpdNQxOjVODwW
RNE9oNHV/d6Q4VGoU+qYyxHqgFrPM
/C9rJzq49FIm4kRTQWYfBQlHOkLZ3q
jHJCWajwxgIpmZFZEBlphoc52COYK
7uPIyNMol97xUuasUqycwUx6O4BjOw
IULqMIt1KAOBPrwBC/wanHr2ZpY7
PSnDXvOYQ/sj5+ANakeU=</latex
it>B2
<latexit sha1_b
ase64="4VEGWlEG1X6TNTbIf1XozHV
i64=">AB6nicbZC7TsMwFIZPyq
2UW4CRxaIgMVUJVMBGBQtjEfQitVH
luE5r1XEi20Gqoj4CwOosPISvAYb
4PTdoCWX7L06f/Pkc85fsyZ0o7zbe
WldW1/LrhY3Nre0de3evrqJEloj
EY9k08eKciZoTPNaTOWFIc+pw1/c
JPljUcqFYvEgx7G1AtxT7CAEayNdX/
dOevYRafkTIQWwZ1B8epznOmt2rG/
2t2IJCEVmnCsVMt1Yu2lWGpGOB0V2
omiMSYD3KMtgwKHVHnpZNQROjZOFwW
RNE9oNHF/d6Q4VGoY+qYyxLqv5rPM
/C9rJTq49FIm4kRTQaYfBQlHOkLZ3q
jLJCWaDw1gIpmZFZE+lphoc52COYI
7v/Ii1E9L7nmpfFcuVo5gqjwcwCGcg
AsXUIFbqEINCPTgCV7g1eLWszW23q
elOWvWsw9/ZH38ANgokeY=</latex
it>B3
<latexit sha1_base64="MwXhCYCU
AJiswf/f8yTq5UyXjbE=">AB6nicbZDLSgMxFIbPeK31VnXpJlgFV2VGi
rqz6MZlRXuBdiZNOGJpkhyQhl6CO4caFUt76Er+HOtzHTdqGtPwQ+/v8c
cs4JYs60cd1vZ2l5ZXVtPbeR39za3tkt7O3XdZQoQmsk4pFqBlhTziStGW
Y4bcaKYhFw2gGN1neKRKs0g+mGFMfYF7koWMYGOt+tOuVMouiV3IrQI3
gyKV5/jTG/VTuGr3Y1Iqg0hGOtW54bGz/FyjDC6SjfTjSNMRngHm1ZlFhQ
7aeTUfoxDpdFEbKPmnQxP3dkWKh9VAEtlJg09fzWb+l7USE176KZNxYqg
k04/ChCMToWxv1GWKEsOHFjBRzM6KSB8rTIy9Tt4ewZtfeRHqZyXvFS+Kx
crxzBVDg7hCE7BgwuowC1UoQYEevAEL/DqcOfZGTv09IlZ9ZzAH/kfPwA2
ayR5w=</latexit>B4
<latexit sha1_base64="R8ROUht
d92UZlSItIXHSkxM=">AB6nicbZDLSgMxFIbPeK31VnXpJlgFV2VGi
rqz6MZlRXuBdiZNOGZpIhyQhl6CO4caFUt76Er+HOtzHTdqGtPwQ+/v8c
cs4JYs60cd1vZ2l5ZXVtPbeR39za3tkt7O3XtUwUoTUiuVTNAGvKmaA1w
ynzVhRHAWcNoLBTZY3HqnSTIoHM4ypH+GeYCEj2Fjr/rojOoWiW3InQovgz
aB49TnO9FbtFL7aXUmSiApDONa65bmx8VOsDCOcjvLtRNMYkwHu0ZFgSOq
/XQy6gidWKeLQqnsEwZN3N8dKY60HkaBrYyw6ev5LDP/y1qJCS/9lIk4MVS
Q6UdhwpGRKNsbdZmixPChBUwUs7Mi0scKE2Ovk7dH8OZXoT6Wck7L5Xvys
XKMUyVg0M4glPw4AIqcAtVqAGBHjzBC7w63Hl2xs7tHTJmfUcwB85Hz8xo
5Ih</latexit>Bn
<latexit sha1_base64="1Vf2BVSO
KlOjqUme3uIBPy+VA84=">AB7nicbZDLSgMxFIbPeK31VnXpJlgFN5YZK
erOohuXFewF2qFk0kwbmkmGJCOUoQ/hRrAibn0FX8Odb2Om7UJbfwh8/P85
5JwTxJxp47rfztLyuraem4jv7m1vbNb2Nuva5koQmtEcqmaAdaUM0Frh
lOm7GiOAo4bQSD2yxvPFKlmRQPZhTP8I9wUJGsLFW46aTijNv1CkU3ZI7E
VoEbwbF68+XTONqp/DV7kqSRFQYwrHWLc+NjZ9iZRjhdJRvJ5rGmAxwj7Ys
ChxR7aeTcUfoxDpdFEplnzBo4v7uSHGk9TAKbGWETV/PZ5n5X9ZKTHjlp0z
EiaGCTD8KE46MRNnuqMsUJYPLWCimJ0VkT5WmBh7obw9gje/8iLUz0veRa
l8Xy5WjmGqHBzCEZyCB5dQgTuoQg0IDOAJxvDqxM6z8+a8T0uXnFnPAfyR8
/ED0gqTnw=</latexit>Bn−1
<latexit sha1_base64="OTE4BzU9
7xIJvyBAHZ2qvtDrwXo=">AB7nicbZDLSsNAFIZP6q3W9Slm8EquLEkp
ag7i25cVrAXaEOZTCft0MkzEyEvoQbgQr4tZX8DXc+TZO2i609YeBj/8/
hzn+DFnSjvOt5VbWV1b38hvFra2d3b37P2DhoSWidRDySLR8rypmgdc
0p61YUhz6nDb94W2WNx+pVCwSD3oUy/EfcECRrA2VvOm4rz8rhrF52SM
xVaBncOxevPl0yTWtf+6vQikoRUaMKxUm3XibWXYqkZ4XRc6CSKxpgMcZ+2
DQocUuWl03H6NQ4PRE0jyh0dT93ZHiUKlR6JvKEOuBWswy87+snejgyku
ZiBNBZl9FCQc6Qhlu6Mek5RoPjKAiWRmVkQGWGKizYUK5gju4srL0CiX3I
tS5b5SrJ7ATHk4gmM4AxcuoQp3UIM6EBjCE0zg1YqtZ+vNep+V5qx5zyH8k
fXxA9OPk6A=</latexit>Bn−2
<latexit sha1_b
ase64="QeRUV/9RunJIUioabpA+V6P
Azv4=">AB7HicbZDNSsNAFIVv6l
+tf1WXbgar4KokUqo7CyK4rGDaQhv
LZDph04mYWYilNBncOPCKm59B1/Dn
W/jpO1CWw8MfJxzL3Pv9WPOlLbtby
u3srq2vpHfLGxt7+zuFfcPGipKJKEu
iXgkWz5WlDNBXc0p61YUhz6nDb94
XWNx+pVCwS93oUy/EfcECRrA2lnv
z4HSdbrFkl+2p0DI4cyhdfU4yvda7
xa9OLyJSIUmHCvVduxYeymWmhFOx
4VOomiMyRD3adugwCFVXjodoxOjdN
DQSTNExpN3d8dKQ6VGoW+qQyxHqjF
LDP/y9qJDi69lIk40VSQ2UdBwpGOUL
Y56jFJieYjA5hIZmZFZIAlJtrcp2C
O4CyuvAyN87JTLVfuKqXaCcyUhyM4h
jNw4AJqcAt1cIEAgyd4gYklrGfrzX
qfleasec8h/JH18QP+VZK</latex
it>
E1
1
<latexit sha1_b
ase64="dw3JscUnyc5hE3ZLcfCy2w
qmUM=">AB7HicbZDNSsNAFIVv6l
+tf1WXbgar4Kokpag7CyK4rGDaQhv
LZDph04mYWYilNBncOPCKm59B1/Dn
W/jpO1CWw8MfJxzL3Pv9WPOlLbtby
u3srq2vpHfLGxt7+zuFfcPGipKJKEu
iXgkWz5WlDNBXc0p61YUhz6nDb94
XWNx+pVCwS93oUy/EfcECRrA2lnv
z4HQr3WLJLtToWVw5lC6+pxkeq13
i1+dXkSkApNOFaq7dix9lIsNSOcj
gudRNEYkyHu07ZBgUOqvHQ67BidGqe
HgkiaJzSaur87UhwqNQp9UxliPVCL
Wb+l7UTHVx6KRNxoqkgs4+ChCMdoW
xz1GOSEs1HBjCRzMyKyABLTLS5T8E
cwVlceRkalbJzXq7eVUu1E5gpD0dwD
GfgwAXU4Bbq4AIBk/wAhNLWM/Wm/
U+K81Z85D+CPr4wf/2ZKL</latex
it>
E1
2
<latexit sha1_base64="zeP4JLyh
my+fp2t0zQeY7aycsuM=">AB7HicbZDNSsNAFIVv6l+tf1WXbgar4KokW
tSdBRFcVjBtoY1lMp20QyeTMDMRSugzuHFhFbe+g6/hzrdx0nahrQcGPs65
l7n3+jFnStv2t5VbWl5ZXcuvFzY2t7Z3irt7dRUlklCXRDySTR8rypmgrm
a02YsKQ59Thv+4DrLG49UKhaJez2MqRfinmABI1gby715cDpnWLJLtsTo
UVwZlC6+hxneq1il/tbkSkApNOFaq5dix9lIsNSOcjgrtRNEYkwHu0ZB
gUOqvHQy7AgdG6eLgkiaJzSauL87UhwqNQx9Uxli3VfzWb+l7USHVx6KRN
xoqkg04+ChCMdoWxz1GWSEs2HBjCRzMyKSB9LTLS5T8EcwZlfeRHqp2XnvF
y5q5SqRzBVHg7gE7AgQuowi3UwAUCDJ7gBcaWsJ6tN+t9WpqzZj378EfWx
w8BbJKM</latexit>
E1
3
<latexit sha1_base64="L2W9kilW
3t72TawkdJ75SfEQUD4=">AB8HicbZDLSgMxFIbPeK31VnXpJlgFN5YZK
erOguK9iLtGPJpGkbmSGJCOUoU/hRkURt76Br+HOtzHTdqGtPwQ+/v8c
cs4JIs60cd1vZ25+YXFpObOSXV1b39jMbW1XdRgrQisk5KGqB1hTziStG
Y4rUeKYhFwWgv6F2leu6dKs1DemEFEfYG7knUYwcZat5d3XiuR8VhK5d3C
+5IaBa8CeTP59SPZdbua9mOySxoNIQjrVueG5k/AQrwinw2wz1jTCpI+7
tGFRYkG1n4wGHqID67RJ1T2SYNG7u+OBAutByKwlQKbnp7OUvO/rBGbzpm
fMBnFhkoy/qgTc2RClG6P2kxRYvjAiaK2VkR6WGFibE3ytojeNMrz0L1uO
CdFIrXxXxpH8bKwC7swSF4cAoluIyVICAgAd4gVdHOY/Om/M+Lp1zJj078
EfOxw8CNZRI</latexit>
E1
n−4
<latexit sha1_base64="5NBS8tYM
EmvHe9vebgzxiYr6hEM=">AB8HicbZDLSgMxFIbP1Fut6pLN4NVcGOZ0
aLuLIjgsoK9SDuWTJpQ5PMkGSEMvQp3Kgo4tY38DXc+TZm2i609YfAx/+f
Q845fsSo0o7zbWXm5hcWl7LuZXVtfWN/OZWTYWxKSKQxbKho8UYVSQq
akUYkCeI+I3W/f5Hm9XsiFQ3FjR5ExOoK2hAMdLGur28c9uJODwetvMFp
+iMZM+CO4HC+edTqudKO/V6oQ45kRozJBSTdeJtJcgqSlmZJhrxYpECPdR
lzQNCsSJ8pLRwEN73zgdOwileULbI/d3R4K4UgPum0qOdE9NZ6n5X9aMdXD
mJVREsSYCjz8KYmbr0E63tztUEqzZwADCkpZbdxDEmFtbpQzR3CnV56F2l
HRPSmWrkuF8h6MlYUd2IUDcOEUynAFagCBg4P8AKvlrQerTfrfVyasSY92
/BH1scPALCURw=</latexit>
E1
n−3
<latexit sha1_base64="hdxi86DR
Dul27CFlz37XRf/Gy4c=">AB8HicbZDLSgMxFIbP1Fut6pLN4NVcGOZq
UXdWRDBZQV7kXYsmThiaZIckIZehTuFRxK1v4Gu4823MtF1o9YfAx/+f
Q845fsSo0o7zZWXm5hcWl7LuZXVtfWN/OZWXYWxKSGQxbKpo8UYVSQmq
akWYkCeI+Iw1/cJ7mjTsiFQ3FtR5GxOoJ2hAMdLGurm4LXUScXg06uQLT
tEZy/4L7hQKZx+PqZ6qnfxnuxvimBOhMUNKtVwn0l6CpKaYkVGuHSsSITxA
PdIyKBAnykvGA4/sfeN07SCU5gltj92fHQniSg25byo50n01m6Xmf1kr1sG
pl1ARxZoIPkoiJmtQzvd3u5SbBmQwMIS2pmtXEfSYS1uVHOHMGdXfkv1E
tF97hYvioXKnswURZ2YBcOwIUTqMAlVKEGDjcwzO8WNJ6sF6t0lpxpr2b
MvWe/fAjqUSA=</latexit>
E2
n−3
<latexit sha1_base64="yK/2aJog
zoONKg7whjmMOSa4QE=">AB8HicbZDLSgMxFIbP1Fut6pLN8EquLHMl
KLuLIjgsoK9SDuWTJpQzOZIckIZehTuFRxK1v4Gu4823MtF1o6w+Bj/8/
h5xzvIgzpW3728osLC4tr2RXc2vrG5tb+e2dugpjSWiNhDyUTQ8rypmgNc
0p81IUhx4nDa8wUWaN+6pVCwUN3oYUTfAPcF8RrA21u3lXamTiOPyqJMv2
EV7LDQPzhQK59PqZ6rnfxXuxuSOKBCE46Vajl2pN0ES80Ip6NcO1Y0wmSA
e7RlUOCAKjcZDzxCh8bpIj+U5gmNxu7vjgQHSg0Dz1QGWPfVbJa/2WtWPt
nbsJEFGsqyOQjP+ZIhyjdHnWZpETzoQFMJDOzItLHEhNtbpQzR3BmV56Heq
nonBTL1+VC5QAmysIe7MROHAKFbiCKtSAQAP8AKvlrQerTfrfVKasaY9u
/BH1scPA7+USQ=</latexit>
E2
n−4
<latexit sha1_base64="lKX0WRj3
4Her5YN85iUjHXhpQ3Y=">AB7nicbZDLSgMxFIbP1Fut6pLN8EquCozb
VF3FkRwWcFeoB1LJs20oZnMkGSEMvQh3AhWxK2v4Gu4823MtF1o6w+Bj/8/
h5xzvIgzpW3728qsrK6tb2Q3c1vbO7t7+f2DhgpjSWidhDyULQ8rypmgdc
0p61IUhx4nDa94XWaNx+pVCwU93oUTfAfcF8RrA2VvPmodRNyuNuvmAX7
anQMjhzKFx9vqSa1Lr5r04vJHFAhSYcK9V27Ei7CZaEU7HuU6saITJEPdp
26DAVuMh13jE6N0N+KM0TGk3d3x0JDpQaBZ6pDLAeqMUsNf/L2rH2L92
EiSjWVJDZR37MkQ5RujvqMUmJ5iMDmEhmZkVkgCUm2lwoZ47gLK68DI1S0T
kvVu4qheoJzJSFIziGM3DgAqpwCzWoA4EhPMEXq3IerberPdZaca9xzCH
1kfP8hMk5k=</latexit>
E2
3
<latexit sha1_b
ase64="YXxvrjfspMhUi/xFv1Z50bu
Wfl8=">AB7nicbZDLSsNAFIZP6q
3W9Slm8EquCpJKerOguK9gLtLF
MpN26GQSZiZCX0IN4IVcesr+Bruf
BsnbRfa+sPAx/+fw5xz/JgzpR3n28
qtrK6tb+Q3C1vbO7t79v5BQ0WJLRO
Ih7Jlo8V5UzQuma01YsKQ59Tpv+8
DrLm49UKhaJez2KqRfivmABI1gbq3n
zUO6m5XHXLjolZyq0DO4cilefL5km
ta791elFJAmp0IRjpdquE2svxVIzw
um40EkUjTEZ4j5tGxQ4pMpLp+O0al
xeiIpHlCo6n7uyPFoVKj0DeVIdYD
tZhl5n9ZO9HBpZcyESeaCjL7KEg40h
HKdkc9JinRfGQAE8nMrIgMsMREmws
VzBHcxZWXoVEuelyl2lWD2BmfJwB
MdwBi5cQBVuoQZ1IDCEJ5jAqxVbz9
ab9T4rzVnznkP4I+vjB8bHk5g=</l
atexit>
E2
2
<latexit sha1_b
ase64="AsM196nSB7dBteyA89ODlup
Ki7s=">AB7nicbZDLSsNAFIZP6q
3W9Slm8EquCpJKerOguK9gLtLF
MpN26GQSZiZCX0IN4IVcesr+Bruf
BsnbRfa+sPAx/+fw5xz/JgzpR3n28
qtrK6tb+Q3C1vbO7t79v5BQ0WJLRO
Ih7Jlo8V5UzQuma01YsKQ59Tpv+8
DrLm49UKhaJez2KqRfivmABI1gbq3n
zUO6m7rhrF52SMxVaBncOxavPl0yT
Wtf+6vQikoRUaMKxUm3XibWXYqkZ4
XRc6CSKxpgMcZ+2DQocUuWl03H6NQ
4PRE0jyh0dT93ZHiUKlR6JvKEOuB
Wswy87+snejg0kuZiBNBZl9FCQc6Q
hlu6Mek5RoPjKAiWRmVkQGWGKizYU
K5gju4srL0CiX3PNS5a5SrJ7ATHk4g
mM4AxcuoAq3UIM6EBjCE0zg1YqtZ+
vNep+V5qx5zyH8kfXxA8VCk5c=</l
atexit>
E2
1
<latexit sha1_b
ase64="DrBigyEyJ5O5+eAoSwoyHbu
AI6A=">AB7XicbZDLSgMxFIYz9V
brerSTbAKrsqMFHVnwY3LCvYC7VA
ymUwbm0mG5IxQhr6DGxct4tZn8DXc+
Taml4W2/hD4+P9zyDknSAQ34LrfTm
5tfWNzK79d2Nnd2z8oHh41jEo1ZXWq
hNKtgBgmuGR14CBYK9GMxIFgzWBwN
82bz0wbruQjDBPmx6QnecQpAWs1OiJ
UYLrFklt2Z8Kr4C2gdPs5nmpS6xa/
OqGiacwkUEGMaXtuAn5GNHAq2KjQS
Q1LCB2QHmtblCRmxs9m047wuXVCHCl
tnwQ8c393ZCQ2ZhgHtjIm0DfL2dT8
L2unEN34GZdJCkzS+UdRKjAoPF0dh1
wzCmJogVDN7ayY9okmFOyBCvYI3vL
Kq9C4LHtX5cpDpVQ9Q3Pl0Qk6RfIQ
9eoiu5RDdURU/oBY3RxFHOq/PmvM
9Lc86i5xj9kfPxA9fik7I=</latex
it>. . .
<latexit sha1_b
ase64="DrBigyEyJ5O5+eAoSwoyHbu
AI6A=">AB7XicbZDLSgMxFIYz9V
brerSTbAKrsqMFHVnwY3LCvYC7VA
ymUwbm0mG5IxQhr6DGxct4tZn8DXc+
Taml4W2/hD4+P9zyDknSAQ34LrfTm
5tfWNzK79d2Nnd2z8oHh41jEo1ZXWq
hNKtgBgmuGR14CBYK9GMxIFgzWBwN
82bz0wbruQjDBPmx6QnecQpAWs1OiJ
UYLrFklt2Z8Kr4C2gdPs5nmpS6xa/
OqGiacwkUEGMaXtuAn5GNHAq2KjQS
Q1LCB2QHmtblCRmxs9m047wuXVCHCl
tnwQ8c393ZCQ2ZhgHtjIm0DfL2dT8
L2unEN34GZdJCkzS+UdRKjAoPF0dh1
wzCmJogVDN7ayY9okmFOyBCvYI3vL
Kq9C4LHtX5cpDpVQ9Q3Pl0Qk6RfIQ
9eoiu5RDdURU/oBY3RxFHOq/PmvM
9Lc86i5xj9kfPxA9fik7I=</latex
it>. . .
<latexit sha1_b
ase64="DrBigyEyJ5O5+eAoSwoyHbu
AI6A=">AB7XicbZDLSgMxFIYz9V
brerSTbAKrsqMFHVnwY3LCvYC7VA
ymUwbm0mG5IxQhr6DGxct4tZn8DXc+
Taml4W2/hD4+P9zyDknSAQ34LrfTm
5tfWNzK79d2Nnd2z8oHh41jEo1ZXWq
hNKtgBgmuGR14CBYK9GMxIFgzWBwN
82bz0wbruQjDBPmx6QnecQpAWs1OiJ
UYLrFklt2Z8Kr4C2gdPs5nmpS6xa/
OqGiacwkUEGMaXtuAn5GNHAq2KjQS
Q1LCB2QHmtblCRmxs9m047wuXVCHCl
tnwQ8c393ZCQ2ZhgHtjIm0DfL2dT8
L2unEN34GZdJCkzS+UdRKjAoPF0dh1
wzCmJogVDN7ayY9okmFOyBCvYI3vL
Kq9C4LHtX5cpDpVQ9Q3Pl0Qk6RfIQ
9eoiu5RDdURU/oBY3RxFHOq/PmvM
9Lc86i5xj9kfPxA9fik7I=</latex
it>. . .
<latexit sha1_b
ase64="DrBigyEyJ5O5+eAoSwoyHbu
AI6A=">AB7XicbZDLSgMxFIYz9V
brerSTbAKrsqMFHVnwY3LCvYC7VA
ymUwbm0mG5IxQhr6DGxct4tZn8DXc+
Taml4W2/hD4+P9zyDknSAQ34LrfTm
5tfWNzK79d2Nnd2z8oHh41jEo1ZXWq
hNKtgBgmuGR14CBYK9GMxIFgzWBwN
82bz0wbruQjDBPmx6QnecQpAWs1OiJ
UYLrFklt2Z8Kr4C2gdPs5nmpS6xa/
OqGiacwkUEGMaXtuAn5GNHAq2KjQS
Q1LCB2QHmtblCRmxs9m047wuXVCHCl
tnwQ8c393ZCQ2ZhgHtjIm0DfL2dT8
L2unEN34GZdJCkzS+UdRKjAoPF0dh1
wzCmJogVDN7ayY9okmFOyBCvYI3vL
Kq9C4LHtX5cpDpVQ9Q3Pl0Qk6RfIQ
9eoiu5RDdURU/oBY3RxFHOq/PmvM
9Lc86i5xj9kfPxA9fik7I=</latex
it>. . .
<latexit sha1_b
ase64="DrBigyEyJ5O5+eAoSwoyHbu
AI6A=">AB7XicbZDLSgMxFIYz9V
brerSTbAKrsqMFHVnwY3LCvYC7VA
ymUwbm0mG5IxQhr6DGxct4tZn8DXc+
Taml4W2/hD4+P9zyDknSAQ34LrfTm
5tfWNzK79d2Nnd2z8oHh41jEo1ZXWq
hNKtgBgmuGR14CBYK9GMxIFgzWBwN
82bz0wbruQjDBPmx6QnecQpAWs1OiJ
UYLrFklt2Z8Kr4C2gdPs5nmpS6xa/
OqGiacwkUEGMaXtuAn5GNHAq2KjQS
Q1LCB2QHmtblCRmxs9m047wuXVCHCl
tnwQ8c393ZCQ2ZhgHtjIm0DfL2dT8
L2unEN34GZdJCkzS+UdRKjAoPF0dh1
wzCmJogVDN7ayY9okmFOyBCvYI3vL
Kq9C4LHtX5cpDpVQ9Q3Pl0Qk6RfIQ
9eoiu5RDdURU/oBY3RxFHOq/PmvM
9Lc86i5xj9kfPxA9fik7I=</latex
it>. . .
<latexit sha1_b
ase64="DrBigyEyJ5O5+eAoSwoyHbu
AI6A=">AB7XicbZDLSgMxFIYz9V
brerSTbAKrsqMFHVnwY3LCvYC7VA
ymUwbm0mG5IxQhr6DGxct4tZn8DXc+
Taml4W2/hD4+P9zyDknSAQ34LrfTm
5tfWNzK79d2Nnd2z8oHh41jEo1ZXWq
hNKtgBgmuGR14CBYK9GMxIFgzWBwN
82bz0wbruQjDBPmx6QnecQpAWs1OiJ
UYLrFklt2Z8Kr4C2gdPs5nmpS6xa/
OqGiacwkUEGMaXtuAn5GNHAq2KjQS
Q1LCB2QHmtblCRmxs9m047wuXVCHCl
tnwQ8c393ZCQ2ZhgHtjIm0DfL2dT8
L2unEN34GZdJCkzS+UdRKjAoPF0dh1
wzCmJogVDN7ayY9okmFOyBCvYI3vL
Kq9C4LHtX5cpDpVQ9Q3Pl0Qk6RfIQ
9eoiu5RDdURU/oBY3RxFHOq/PmvM
9Lc86i5xj9kfPxA9fik7I=</latex
it>. . .
<latexit sha1_b
ase64="DrBigyEyJ5O5+eAoSwoyHbu
AI6A=">AB7XicbZDLSgMxFIYz9V
brerSTbAKrsqMFHVnwY3LCvYC7VA
ymUwbm0mG5IxQhr6DGxct4tZn8DXc+
Taml4W2/hD4+P9zyDknSAQ34LrfTm
5tfWNzK79d2Nnd2z8oHh41jEo1ZXWq
hNKtgBgmuGR14CBYK9GMxIFgzWBwN
82bz0wbruQjDBPmx6QnecQpAWs1OiJ
UYLrFklt2Z8Kr4C2gdPs5nmpS6xa/
OqGiacwkUEGMaXtuAn5GNHAq2KjQS
Q1LCB2QHmtblCRmxs9m047wuXVCHCl
tnwQ8c393ZCQ2ZhgHtjIm0DfL2dT8
L2unEN34GZdJCkzS+UdRKjAoPF0dh1
wzCmJogVDN7ayY9okmFOyBCvYI3vL
Kq9C4LHtX5cpDpVQ9Q3Pl0Qk6RfIQ
9eoiu5RDdURU/oBY3RxFHOq/PmvM
9Lc86i5xj9kfPxA9fik7I=</latex
it>. . .
<latexit sha1_b
ase64="DrBigyEyJ5O5+eAoSwoyHbu
AI6A=">AB7XicbZDLSgMxFIYz9V
brerSTbAKrsqMFHVnwY3LCvYC7VA
ymUwbm0mG5IxQhr6DGxct4tZn8DXc+
Taml4W2/hD4+P9zyDknSAQ34LrfTm
5tfWNzK79d2Nnd2z8oHh41jEo1ZXWq
hNKtgBgmuGR14CBYK9GMxIFgzWBwN
82bz0wbruQjDBPmx6QnecQpAWs1OiJ
UYLrFklt2Z8Kr4C2gdPs5nmpS6xa/
OqGiacwkUEGMaXtuAn5GNHAq2KjQS
Q1LCB2QHmtblCRmxs9m047wuXVCHCl
tnwQ8c393ZCQ2ZhgHtjIm0DfL2dT8
L2unEN34GZdJCkzS+UdRKjAoPF0dh1
wzCmJogVDN7ayY9okmFOyBCvYI3vL
Kq9C4LHtX5cpDpVQ9Q3Pl0Qk6RfIQ
9eoiu5RDdURU/oBY3RxFHOq/PmvM
9Lc86i5xj9kfPxA9fik7I=</latex
it>. . .
<latexit sha1_b
ase64="DrBigyEyJ5O5+eAoSwoyHbu
AI6A=">AB7XicbZDLSgMxFIYz9V
brerSTbAKrsqMFHVnwY3LCvYC7VA
ymUwbm0mG5IxQhr6DGxct4tZn8DXc+
Taml4W2/hD4+P9zyDknSAQ34LrfTm
5tfWNzK79d2Nnd2z8oHh41jEo1ZXWq
hNKtgBgmuGR14CBYK9GMxIFgzWBwN
82bz0wbruQjDBPmx6QnecQpAWs1OiJ
UYLrFklt2Z8Kr4C2gdPs5nmpS6xa/
OqGiacwkUEGMaXtuAn5GNHAq2KjQS
Q1LCB2QHmtblCRmxs9m047wuXVCHCl
tnwQ8c393ZCQ2ZhgHtjIm0DfL2dT8
L2unEN34GZdJCkzS+UdRKjAoPF0dh1
wzCmJogVDN7ayY9okmFOyBCvYI3vL
Kq9C4LHtX5cpDpVQ9Q3Pl0Qk6RfIQ
9eoiu5RDdURU/oBY3RxFHOq/PmvM
9Lc86i5xj9kfPxA9fik7I=</latex
it>. . .
<latexit sha1_b
ase64="DrBigyEyJ5O5+eAoSwoyHbu
AI6A=">AB7XicbZDLSgMxFIYz9V
brerSTbAKrsqMFHVnwY3LCvYC7VA
ymUwbm0mG5IxQhr6DGxct4tZn8DXc+
Taml4W2/hD4+P9zyDknSAQ34LrfTm
5tfWNzK79d2Nnd2z8oHh41jEo1ZXWq
hNKtgBgmuGR14CBYK9GMxIFgzWBwN
82bz0wbruQjDBPmx6QnecQpAWs1OiJ
UYLrFklt2Z8Kr4C2gdPs5nmpS6xa/
OqGiacwkUEGMaXtuAn5GNHAq2KjQS
Q1LCB2QHmtblCRmxs9m047wuXVCHCl
tnwQ8c393ZCQ2ZhgHtjIm0DfL2dT8
L2unEN34GZdJCkzS+UdRKjAoPF0dh1
wzCmJogVDN7ayY9okmFOyBCvYI3vL
Kq9C4LHtX5cpDpVQ9Q3Pl0Qk6RfIQ
9eoiu5RDdURU/oBY3RxFHOq/PmvM
9Lc86i5xj9kfPxA9fik7I=</latex
it>. . .
<latexit sha1_b
ase64="DrBigyEyJ5O5+eAoSwoyHbu
AI6A=">AB7XicbZDLSgMxFIYz9V
brerSTbAKrsqMFHVnwY3LCvYC7VA
ymUwbm0mG5IxQhr6DGxct4tZn8DXc+
Taml4W2/hD4+P9zyDknSAQ34LrfTm
5tfWNzK79d2Nnd2z8oHh41jEo1ZXWq
hNKtgBgmuGR14CBYK9GMxIFgzWBwN
82bz0wbruQjDBPmx6QnecQpAWs1OiJ
UYLrFklt2Z8Kr4C2gdPs5nmpS6xa/
OqGiacwkUEGMaXtuAn5GNHAq2KjQS
Q1LCB2QHmtblCRmxs9m047wuXVCHCl
tnwQ8c393ZCQ2ZhgHtjIm0DfL2dT8
L2unEN34GZdJCkzS+UdRKjAoPF0dh1
wzCmJogVDN7ayY9okmFOyBCvYI3vL
Kq9C4LHtX5cpDpVQ9Q3Pl0Qk6RfIQ
9eoiu5RDdURU/oBY3RxFHOq/PmvM
9Lc86i5xj9kfPxA9fik7I=</latex
it>. . .
<latexit sha1_b
ase64="DrBigyEyJ5O5+eAoSwoyHbu
AI6A=">AB7XicbZDLSgMxFIYz9V
brerSTbAKrsqMFHVnwY3LCvYC7VA
ymUwbm0mG5IxQhr6DGxct4tZn8DXc+
Taml4W2/hD4+P9zyDknSAQ34LrfTm
5tfWNzK79d2Nnd2z8oHh41jEo1ZXWq
hNKtgBgmuGR14CBYK9GMxIFgzWBwN
82bz0wbruQjDBPmx6QnecQpAWs1OiJ
UYLrFklt2Z8Kr4C2gdPs5nmpS6xa/
OqGiacwkUEGMaXtuAn5GNHAq2KjQS
Q1LCB2QHmtblCRmxs9m047wuXVCHCl
tnwQ8c393ZCQ2ZhgHtjIm0DfL2dT8
L2unEN34GZdJCkzS+UdRKjAoPF0dh1
wzCmJogVDN7ayY9okmFOyBCvYI3vL
Kq9C4LHtX5cpDpVQ9Q3Pl0Qk6RfIQ
9eoiu5RDdURU/oBY3RxFHOq/PmvM
9Lc86i5xj9kfPxA9fik7I=</latex
it>. . .
<latexit sha1_base64="DrBigyEy
J5O5+eAoSwoyHbuAI6A=">AB7XicbZDLSgMxFIYz9VbrerSTbAKrsqMF
HVnwY3LCvYC7VAymUwbm0mG5IxQhr6DGxct4tZn8DXc+Taml4W2/hD4+P9z
yDknSAQ34LrfTm5tfWNzK79d2Nnd2z8oHh41jEo1ZXWqhNKtgBgmuGR14C
BYK9GMxIFgzWBwN82bz0wbruQjDBPmx6QnecQpAWs1OiJUYLrFklt2Z8Kr4
C2gdPs5nmpS6xa/OqGiacwkUEGMaXtuAn5GNHAq2KjQSQ1LCB2QHmtblCRm
xs9m047wuXVCHCltnwQ8c393ZCQ2ZhgHtjIm0DfL2dT8L2unEN34GZdJCkz
S+UdRKjAoPF0dh1wzCmJogVDN7ayY9okmFOyBCvYI3vLKq9C4LHtX5cpDpV
Q9Q3Pl0Qk6RfIQ9eoiu5RDdURU/oBY3RxFHOq/PmvM9Lc86i5xj9kfPxA
9fik7I=</latexit>. . .
. . .
<latexit sha1_base64="DrBigyEy
J5O5+eAoSwoyHbuAI6A=">AB7XicbZDLSgMxFIYz9VbrerSTbAKrsqMF
HVnwY3LCvYC7VAymUwbm0mG5IxQhr6DGxct4tZn8DXc+Taml4W2/hD4+P9z
yDknSAQ34LrfTm5tfWNzK79d2Nnd2z8oHh41jEo1ZXWqhNKtgBgmuGR14C
BYK9GMxIFgzWBwN82bz0wbruQjDBPmx6QnecQpAWs1OiJUYLrFklt2Z8Kr4
C2gdPs5nmpS6xa/OqGiacwkUEGMaXtuAn5GNHAq2KjQSQ1LCB2QHmtblCRm
xs9m047wuXVCHCltnwQ8c393ZCQ2ZhgHtjIm0DfL2dT8L2unEN34GZdJCkz
S+UdRKjAoPF0dh1wzCmJogVDN7ayY9okmFOyBCvYI3vLKq9C4LHtX5cpDpV
Q9Q3Pl0Qk6RfIQ9eoiu5RDdURU/oBY3RxFHOq/PmvM9Lc86i5xj9kfPxA
9fik7I=</latexit>. . .
<latexit
 sha1_base64="y
lNqoy4oLBqGnSH
9jy4/T4h5cE=">
AB7HicbZDNSsN
AFIVv6l+tf1WXb
gar4KokUq4saAL
lxVMW2hDmUwn7dD
JMxMhBL6DG5cWM
Wt7+BruPNtnLRd
aOuBgY9z7mXuvX7
MmdK2/W3lVlbX1j
fym4Wt7Z3dveL+
QUNFiSTUJRGPZMv
HinImqKuZ5rQVS4
pDn9OmP7zJ8uYjl
YpF4kGPYuqFuC9
YwAjWxnJvuwJdY
slu2xPhZbBmUPp+
nOS6bXeLX51ehF
JQio04ViptmPH2k
ux1IxwOi50EkVjT
Ia4T9sGBQ6p8tLp
sGN0apweCiJpnt
Bo6v7uSHGo1Cj0T
WI9UAtZpn5X9ZO
dHDpUzEiaCzD
4KEo50hLNUY9JS
jQfGcBEMjMrIgMs
MdHmPgVzBGdx5WV
onJedarlyXynVT
mCmPBzBMZyBAxdQ
gzuogwsEGDzBC0w
sYT1b9b7rDRnz
XsO4Y+sjx8JOpKR
</latexit>Dn :
Figure 1: Solution graph for database Dn. Black dots denote facts, rectangles denote blocks,
and three-pointed edges denote triangles (i.e., 3-cliques) in the solution graph of
Dn. There are n −1 facts in each block Bi and two facts in each block Ej
k.
whenever D |= q4(ab) holds. In the context of solution graphs, a triangle is just a clique on
three vertices (without self-loops).
Remark 5.2. We first state some key properties of q4 for any database D and facts
a, b, c ∈D, which are easy to verify:
(1) if D |= q4(ab) ∧q4(ac) then b = c,
(2) if D |= q4(ba) ∧q4(ca) then b = c,
(3) if D |= q4(ab) ∧q4(bc) then D |= q4(ca),
(4) hence, every connected component of GD is either a triangle, a 2-clique (without self-
loops), or a single vertex (with or without a self-loop).
Towards proving Theorem 5.1, for every n ≥4 we exhibit a database Dn such that
• Dn |= certain(q4) (Proposition 5.3), and
• Dn̸ ∈Cert+
n−2(q4) (Proposition 5.4).
Intuitively, the database Dn has two kinds of blocks. The first kind has n blocks denoted by
B1, · · · , Bn where each Bi consists of n −1 facts denoted b1
i , · · · , bn−1
i
. The second kind has
(n −1)(n −3) blocks denoted by Ej
l for every 1 ≤j ≤n −1 and 1 ≤l ≤n −3, where each
Ej
l has two facts denoted by uj
l and vj
l . The solution graph of Dn is depicted in Figure 1.
Definition of Dn. We now formally define the facts of the database Dn. Fix some n ≥4.
Define n blocks of the form B1, · · · , Bn in Dn where each Bi consists of n −1 facts denoted
b1
i , · · · , bn−1
i
and (n −1)(n −3) blocks of the form Ej
l for 1 ≤j ≤n −1, 1 ≤l ≤n −3,
where each Ej
l have two facts denoted by uj
l and vj
l . All facts in Dn are R-facts, and for
this reason we shall henceforth drop the R from facts R(¯c) and simply write ¯c.
Let a1, · · · , an and ej
i where 1 ≤j ≤n−1, 1 ≤i ≤n−3 be fresh active domain elements.
The facts of Dn are defined as follows.
• bj
1 = (a1 a2ej
1), bj
2 = (a2 ej
1a1);
• for every 3 ≤i ≤n −2: bj
i = (ai ej
i−2ej
i−1);
• bj
n−1 = (an−1 ej
n−3an) and bj
n = (an an−1ej
n−3);
• uj
1 = (ej
1 a1a2) and vj
n−3 = (ej
n−3 anan−1);

---

Vol. 21:1
A SIMPLE ALGORITHM FOR CQA UNDER PRIMARY KEYS
18:19
(ej
l ej
l+1 al+2)
|
{z
}
vj
l
(ej
l+1 al+2 ej
l )
|
{z
}
uj
l+1
(al+2 ej
l ej
l+1)
|
{z
}
bj
l+2
<latexit sha1_base
64="DQx84OqenIGWk18nmPUIUWsR3MA=">A
AB7HicbZDNSsNAFIVv6l+tf1WXbgar4KokU
tSdBRFcVjBtoY1lMp20YyeTMDMRSugzuHFhF
be+g6/hzrdx0nahrQcGPs65l7n3+jFnStv2
t5VbWl5ZXcuvFzY2t7Z3irt7dRUlklCXRDyS
TR8rypmgrma02YsKQ59Thv+4CrLG49UKhaJ
Oz2MqRfinmABI1gby72+f+jwTrFkl+2J0CI
4Myhdfo4zvdY6xa92NyJSIUmHCvVcuxYeym
WmhFOR4V2omiMyQD3aMugwCFVXjoZdoSOjd
NFQSTNExpN3N8dKQ6VGoa+qQyx7qv5LDP/y1
qJDi68lIk40VSQ6UdBwpGOULY56jJieZDA
5hIZmZFpI8lJtrcp2CO4MyvAj107JzVq7cV
krVI5gqDwdwCfgwDlU4QZq4AIBk/wAmNL
WM/Wm/U+Lc1Zs59+CPr4weupL+</latexi
t>
Ej
l
<latexit sha1_base64="op59Yx0vgdjOPq
QgXx7eZ3uW1no=">AB8HicbZDLSgMxFIbP1Fut6pLN8EqCEKZkaLuLIjgsoK9SDuWTJp
pY5OZIckIZehTuFRxK1v4Gu4823MtF1o6w+Bj/8/h5xzvIgzpW3728rMzS8sLmWXcyura+
sb+c2tmgpjSWiVhDyUDQ8rylAq5pThuRpFh4nNa9/nma1+pVCwMrvUgoq7A3YD5jGBtr
JuL27t2wg+dYTtfsIv2SGgWnAkUzj6fUj1X2vmvVicksaCBJhwr1XTsSLsJlpoRToe5Vqxo
hEkfd2nTYIAFVW4yGniI9o3TQX4ozQs0Grm/OxIslBoIz1QKrHtqOkvN/7JmrP1TN2FBFGsa
kPFHfsyRDlG6PeowSYnmAwOYSGZmRaSHJSba3ChnjuBMrzwLtaOic1wsXZUK5T0YKws7sAs
H4MAJlOESKlAFAgIe4AVeLWk9Wm/W+7g0Y016tuGPrI8fT0aUeg=</latexit>
Ej
l+1
<latexit sha1_base64="mHtLn9muNHVCIh
fg4Kb/Jm6AtLs=">AB7nicbZDLSsNAFIZP6q3W9Slm8EqCEJSlF3Ft24rGAv0IYymU7
aoZNJmJkIJfQh3AhWxK2v4Gu482ctF1o6w8DH/9/DnPO8WPOlHacbyu3srq2vpHfLGxt7+
zu2fsHDRUlktA6iXgkWz5WlDNB65pTluxpDj0OW36w9sbz5SqVgkHvQopl6I+4IFjGBtr
OZN+Xn5XHXLjolZyq0DO4citefL5kmta791elFJAmp0IRjpdquE2svxVIzwum40EkUjTEZ
4j5tGxQ4pMpLp+O0alxeiIpHlCo6n7uyPFoVKj0DeVIdYDtZhl5n9ZO9HBlZcyESeaCjL7
KEg40hHKdkc9JinRfGQAE8nMrIgMsMREmwsVzBHcxZWXoVEuRelyn2lWD2BmfJwBMdwBi5
cQhXuoAZ1IDCEJ5jAqxVbz9ab9T4rzVnznkP4I+vjB81k5w=</latexit>Bl+2
<latexit sha1_base64="1Vf2BVSOKlOjqU
me3uIBPy+VA84=">AB7nicbZDLSgMxFIbPeK31VnXpJlgFN5YZKerOohuXFewF2qFk0kw
bmkmGJCOUoQ/hRrAibn0FX8Odb2Om7UJbfwh8/P85JwTxJxp47rfztLyuraem4jv7m1vb
Nb2Nuva5koQmtEcqmaAdaUM0FrhlOm7GiOAo4bQSD2yxvPFKlmRQPZhTP8I9wUJGsLFW4
6aTijNv1CkU3ZI7EVoEbwbF68+XTONqp/DV7kqSRFQYwrHWLc+NjZ9iZRjhdJRvJ5rGmAxw
j7YsChxR7aeTcUfoxDpdFEplnzBo4v7uSHGk9TAKbGWETV/PZ5n5X9ZKTHjlp0zEiaGCTD8K
E46MRNnuqMsUJYPLWCimJ0VkT5WmBh7obw9gje/8iLUz0veRal8Xy5WjmGqHBzCEZyCB5d
QgTuoQg0IDOAJxvDqxM6z8+a8T0uXnFnPAfyR8/ED0gqTnw=</latexit>Bn−1
<latexit sha1_base64="s6EbWFWSIlJQb9
I5dfh+MZUoQbc=">AB7HicbZDNSsNAFIVv6l+tf1WXbgar4KokUtSdRTcuK5i20IYymU7
aoZNJmJkIfQZ3Liwilvfwdw59s4abvQ1gMDH+fcy9x7/ZgzpW372yqsrK6tbxQ3S1vbO7
t75f2DpoSahLIh7Jto8V5UxQVzPNaTuWFIc+py1/dJvnrUcqFYvEg05j6oV4IFjACNbGc
m96mRj3yhW7ak+FlsGZQ+X6c5LrtdErf3X7EUlCKjThWKmOY8fay7DUjHA6LnUTRWNMRnhA
OwYFDqnysumwY3RqnD4KIme0Gjq/u7IcKhUGvqmMsR6qBaz3Pwv6yQ6uPIyJuJEU0FmHwUJ
RzpC+eaozyQlmqcGMJHMzIrIEtMtLlPyRzBWVx5GZrnVeiWruvVeonMFMRjuAYzsCBS6j
DHTABQIMnuAFJpawnq03631WrDmPYfwR9bHD/YKky0=</latexit>Bn
<latexit sha1_base
64="1LQUSfKos80CsQpIa4muAZoKRwg=">A
AB7HicbZDNSsNAFIVv6l+tf1WXbgar4KokU
tSdRTcuK5i20IYymU7aoZNJmJkIfQZ3Liwi
lvfwdw59s4abvQ1gMDH+fcy9x7/ZgzpW37
2yqsrK6tbxQ3S1vbO7t75f2DpoSahLIh7J
to8V5UxQVzPNaTuWFIc+py1/dJvnrUcqFYvE
g05j6oV4IFjACNbGcm96mTPulSt21Z4KLYM
zh8r15yTXa6NX/ur2I5KEVGjCsVIdx461l2G
pGeF0XOomisaYjPCAdgwKHFLlZdNhx+jUOH
0URNI8odHU/d2R4VCpNPRNZYj1UC1muflf1k
l0cOVlTMSJpoLMPgoSjnSE8s1Rn0lKNE8NY
CKZmRWRIZaYaHOfkjmCs7jyMjTPq85FtXZfq
9RPYKYiHMExnIEDl1CHO2iACwQYPMELTCxh
PVtv1vustGDNew7hj6yPH5lZkvA=</latexi
t>B1
<latexit sha1_base
64="5U3KWRAzhRt9BinYl1wLRue2lRQ=">A
AB7HicbZDNTsJAFIVv8Q/xD3XpZiKauCItI
ehOohuXmFgYZMhylMmE6bmakJaXgGNy5E4
9Z38DXc+TZOgYWCJ5nkyzn3Zu69fsyZ0rb9
beXW1jc2t/LbhZ3dvf2D4uFRU0WJNQlEY9k
28eKciaoq5nmtB1LikOf05Y/us3y1iOVikXi
QY9j6oV4IFjACNbGcm96aWXSK5bsj0TWgV
nAaXrz2m10av+NXtRyQJqdCEY6U6jh1rL8V
SM8LpNBNFI0xGeEB7RgUOKTKS2fDTtC5cf
oiKR5QqOZ+7sjxaFS49A3lSHWQ7WcZeZ/WS
fRwZWXMhEnmgoy/yhIONIRyjZHfSYp0XxsA
BPJzKyIDLHERJv7FMwRnOWV6FZKTu1cvW+W
qfwVx5OIFTuAHLqEOd9AFwgweIXmFrC
erberPd5ac5a9BzDH1kfP5rekvE=</latexi
t>B2
(ej
1 a1 a2)
|
{z
}
uj
1
(a2 ej
1 a1)
|
{z
}
bj
2
(a1 a2 ej
1)
|
{z
}
bj
1
(an−1 ej
n−3 an)
|
{z
}
bj
n−1
(an an−1 ej
n−3)
|
{z
}
bj
n
(ej
n−3 an an−1)
|
{z
}
vj
n−3
<latexit sha1_base
64="9lp6hpQASBtXrzLcREIo9SXJYug=">A
AB7HicbZDNSsNAFIVv6l+tf1WXbgar4KokU
tSdBRFcVjBtoY1lMp20YyeTMDMRSugzuHFhF
be+g6/hzrdx0nahrQcGPs65l7n3+jFnStv2
t5VbWl5ZXcuvFzY2t7Z3irt7dRUlklCXRDyS
TR8rypmgrma02YsKQ59Thv+4CrLG49UKhaJ
Oz2MqRfinmABI1gby72+f+g4nWLJLtsToUV
wZlC6/Bxneq1il/tbkSkApNOFaq5dix9lI
sNSOcjgrtRNEYkwHu0ZBgUOqvHQy7AgdG6
eLgkiaJzSauL87UhwqNQx9Uxli3VfzWb+l7
USHVx4KRNxoqkg04+ChCMdoWxz1GWSEs2HB
jCRzMyKSB9LTLS5T8EcwZlfeRHqp2XnrFy5r
ZSqRzBVHg7gE7AgXOowg3UwAUCDJ7gBcaW
sJ6tN+t9WpqzZj378EfWxw9VOpLD</latexi
t>
Ej
1
Ej
n−3
Figure 2: Triangles in the database Dn.
• for every 1 ≤l < n −3: vj
l = (ej
l ej
l+1al+2) and uj
l+1 = (ej
l+1 al+2ej
l ).
As shown in Figure 2, it can be verified that for every 1 ≤j ≤n −1 we have the
triangles {bj
1, bj
2, uj
1} and {bj
n−1, bj
n, vj
n−3} and for every 1 ≤l < n −3 we have a triangle
{vj
l , uj
l+1, bj
l+2}. Thus we get the solution graph described in Figure 1. Notice that Dn is
defined in such a way that every fact of Dn is part of a triangle.
Proposition 5.3. For every n ≥4, Dn |= certain(q4).
Proof. Fix some n ≥4 and consider the database Dn. Let B1, . . . Bn be the blocks of Dn.
Now for every 1 ≤j ≤n −1 if a repair r contains two indices i, i′ such that i̸ = i′ and
bj
i, bj
i′ ∈r then it is easy to verify that r |= q (cf. Figure 1).
Now since each Bi contains exactly n−1 facts of the form b1
i , . . . , bn−1
i
, by the pigeonhole
principle, every repair r must contain two i, i′ such that i̸ = i′ and bj
i, bj
i′ ∈r. Hence, every
repair r of Dn verifies r |= q.
It remains to prove the following:
Proposition 5.4. Let k ≥2. Dk+2̸ ∈Cert+
k(q4).
For showing this, we first need to set up some definitions and prove some useful properties.
When Dn is clear from the context, we denote B ˆ= {B1, . . . Bn} and, for every 1 ≤j ≤n−1,
we denote Ej ˆ= {Ej
l | 1 ≤l ≤n −3} where the Bi’s and Ej
l ’s are the blocks of Dn defined
above.
If X = {X1, . . . , Xk} is a set of blocks of Dn, a set of facts W = {w1, . . . wk} is called a
partial repair of X if wi ∈Xi for every 1 ≤i ≤k. We denote by W[Ej] to be the set of facts
from W in the blocks X ∩Ej (for 1 ≤j ≤n −1), and W[B] to be the set of facts from W in
the blocks X ∩B.
Recall that for every 3 ≤l ≤n −2 and every 1 ≤j ≤n −1 we have bj
l ∈Bl and the
triangle {bj
l , uj
l−1, vj
l−2}. For each such j and l we define U(j, l) ˆ= {uj
k | 1 ≤k ≤l −2} and
V (j, l) ˆ= {vj
k | l −1 ≤k ≤n −3}, which are depicted in Figure 3.
Intuitively, U(j, l) and V (j, l) represent the facts that need to be picked in blocks of Ej
if one wants to construct a repair of Dn containing bj
l and having no query solutions. In
fact note that U(j, l) ∪V (j, l) picks exactly one fact for every block in Ej. But uj
l−1, vj
l−2̸ ∈
U(j, l)∪V (j, l). Consequently, there are no solutions in the set of facts U(j, l)∪V (j, l)∪{bj
l }
(Figure 3).

---

18:20
D. Figueira, A. Padmanabha, L. Segoufin, and C. Sirangelo
Vol. 21:1
<latexit sha1_ba
se64="DrBigyEyJ5O5+eAoSwoyHbuA
I6A=">AB7XicbZDLSgMxFIYz9Vbr
rerSTbAKrsqMFHVnwY3LCvYC7VAymU
wbm0mG5IxQhr6DGxct4tZn8DXc+Tam
l4W2/hD4+P9zyDknSAQ34LrfTm5tfW
NzK79d2Nnd2z8oHh41jEo1ZXWqhNKt
gBgmuGR14CBYK9GMxIFgzWBwN82bz0
wbruQjDBPmx6QnecQpAWs1OiJUYLrF
klt2Z8Kr4C2gdPs5nmpS6xa/OqGiac
wkUEGMaXtuAn5GNHAq2KjQSQ1LCB2Q
HmtblCRmxs9m047wuXVCHCltnwQ8c3
93ZCQ2ZhgHtjIm0DfL2dT8L2unEN34
GZdJCkzS+UdRKjAoPF0dh1wzCmJogVD
N7ayY9okmFOyBCvYI3vLKq9C4LHtX5
cpDpVQ9Q3Pl0Qk6RfIQ9eoiu5RDdU
RU/oBY3RxFHOq/PmvM9Lc86i5xj9k
fPxA9fik7I=</latexit>. . .
<latexit sha1_ba
se64="DrBigyEyJ5O5+eAoSwoyHbuA
I6A=">AB7XicbZDLSgMxFIYz9Vbr
rerSTbAKrsqMFHVnwY3LCvYC7VAymU
wbm0mG5IxQhr6DGxct4tZn8DXc+Tam
l4W2/hD4+P9zyDknSAQ34LrfTm5tfW
NzK79d2Nnd2z8oHh41jEo1ZXWqhNKt
gBgmuGR14CBYK9GMxIFgzWBwN82bz0
wbruQjDBPmx6QnecQpAWs1OiJUYLrF
klt2Z8Kr4C2gdPs5nmpS6xa/OqGiac
wkUEGMaXtuAn5GNHAq2KjQSQ1LCB2Q
HmtblCRmxs9m047wuXVCHCltnwQ8c3
93ZCQ2ZhgHtjIm0DfL2dT8L2unEN34
GZdJCkzS+UdRKjAoPF0dh1wzCmJogVD
N7ayY9okmFOyBCvYI3vLKq9C4LHtX5
cpDpVQ9Q3Pl0Qk6RfIQ9eoiu5RDdU
RU/oBY3RxFHOq/PmvM9Lc86i5xj9k
fPxA9fik7I=</latexit>. . .
<latexit sha1_ba
se64="DrBigyEyJ5O5+eAoSwoyHbuA
I6A=">AB7XicbZDLSgMxFIYz9Vbr
rerSTbAKrsqMFHVnwY3LCvYC7VAymU
wbm0mG5IxQhr6DGxct4tZn8DXc+Tam
l4W2/hD4+P9zyDknSAQ34LrfTm5tfW
NzK79d2Nnd2z8oHh41jEo1ZXWqhNKt
gBgmuGR14CBYK9GMxIFgzWBwN82bz0
wbruQjDBPmx6QnecQpAWs1OiJUYLrF
klt2Z8Kr4C2gdPs5nmpS6xa/OqGiac
wkUEGMaXtuAn5GNHAq2KjQSQ1LCB2Q
HmtblCRmxs9m047wuXVCHCltnwQ8c3
93ZCQ2ZhgHtjIm0DfL2dT8L2unEN34
GZdJCkzS+UdRKjAoPF0dh1wzCmJogVD
N7ayY9okmFOyBCvYI3vLKq9C4LHtX5
cpDpVQ9Q3Pl0Qk6RfIQ9eoiu5RDdU
RU/oBY3RxFHOq/PmvM9Lc86i5xj9k
fPxA9fik7I=</latexit>. . .
<latexit sha1_ba
se64="DrBigyEyJ5O5+eAoSwoyHbuA
I6A=">AB7XicbZDLSgMxFIYz9Vbr
rerSTbAKrsqMFHVnwY3LCvYC7VAymU
wbm0mG5IxQhr6DGxct4tZn8DXc+Tam
l4W2/hD4+P9zyDknSAQ34LrfTm5tfW
NzK79d2Nnd2z8oHh41jEo1ZXWqhNKt
gBgmuGR14CBYK9GMxIFgzWBwN82bz0
wbruQjDBPmx6QnecQpAWs1OiJUYLrF
klt2Z8Kr4C2gdPs5nmpS6xa/OqGiac
wkUEGMaXtuAn5GNHAq2KjQSQ1LCB2Q
HmtblCRmxs9m047wuXVCHCltnwQ8c3
93ZCQ2ZhgHtjIm0DfL2dT8L2unEN34
GZdJCkzS+UdRKjAoPF0dh1wzCmJogVD
N7ayY9okmFOyBCvYI3vLKq9C4LHtX5
cpDpVQ9Q3Pl0Qk6RfIQ9eoiu5RDdU
RU/oBY3RxFHOq/PmvM9Lc86i5xj9k
fPxA9fik7I=</latexit>. . .
. . .
<latexit sha1_ba
se64="DrBigyEyJ5O5+eAoSwoyHbuA
I6A=">AB7XicbZDLSgMxFIYz9Vbr
rerSTbAKrsqMFHVnwY3LCvYC7VAymU
wbm0mG5IxQhr6DGxct4tZn8DXc+Tam
l4W2/hD4+P9zyDknSAQ34LrfTm5tfW
NzK79d2Nnd2z8oHh41jEo1ZXWqhNKt
gBgmuGR14CBYK9GMxIFgzWBwN82bz0
wbruQjDBPmx6QnecQpAWs1OiJUYLrF
klt2Z8Kr4C2gdPs5nmpS6xa/OqGiac
wkUEGMaXtuAn5GNHAq2KjQSQ1LCB2Q
HmtblCRmxs9m047wuXVCHCltnwQ8c3
93ZCQ2ZhgHtjIm0DfL2dT8L2unEN34
GZdJCkzS+UdRKjAoPF0dh1wzCmJogVD
N7ayY9okmFOyBCvYI3vLKq9C4LHtX5
cpDpVQ9Q3Pl0Qk6RfIQ9eoiu5RDdU
RU/oBY3RxFHOq/PmvM9Lc86i5xj9k
fPxA9fik7I=</latexit>. . .
<latexit sha1_ba
se64="DrBigyEyJ5O5+eAoSwoyHbuA
I6A=">AB7XicbZDLSgMxFIYz9Vbr
rerSTbAKrsqMFHVnwY3LCvYC7VAymU
wbm0mG5IxQhr6DGxct4tZn8DXc+Tam
l4W2/hD4+P9zyDknSAQ34LrfTm5tfW
NzK79d2Nnd2z8oHh41jEo1ZXWqhNKt
gBgmuGR14CBYK9GMxIFgzWBwN82bz0
wbruQjDBPmx6QnecQpAWs1OiJUYLrF
klt2Z8Kr4C2gdPs5nmpS6xa/OqGiac
wkUEGMaXtuAn5GNHAq2KjQSQ1LCB2Q
HmtblCRmxs9m047wuXVCHCltnwQ8c3
93ZCQ2ZhgHtjIm0DfL2dT8L2unEN34
GZdJCkzS+UdRKjAoPF0dh1wzCmJogVD
N7ayY9okmFOyBCvYI3vLKq9C4LHtX5
cpDpVQ9Q3Pl0Qk6RfIQ9eoiu5RDdU
RU/oBY3RxFHOq/PmvM9Lc86i5xj9k
fPxA9fik7I=</latexit>. . .
. . .
<latexit sha1_base64="DrBigyEyJ
5O5+eAoSwoyHbuAI6A=">AB7XicbZDLSgMxFIYz9VbrerSTbAKrsqMFHV
nwY3LCvYC7VAymUwbm0mG5IxQhr6DGxct4tZn8DXc+Taml4W2/hD4+P9zyDk
nSAQ34LrfTm5tfWNzK79d2Nnd2z8oHh41jEo1ZXWqhNKtgBgmuGR14CBYK9G
MxIFgzWBwN82bz0wbruQjDBPmx6QnecQpAWs1OiJUYLrFklt2Z8Kr4C2gdPs
5nmpS6xa/OqGiacwkUEGMaXtuAn5GNHAq2KjQSQ1LCB2QHmtblCRmxs9m047
wuXVCHCltnwQ8c393ZCQ2ZhgHtjIm0DfL2dT8L2unEN34GZdJCkzS+UdRKjA
oPF0dh1wzCmJogVDN7ayY9okmFOyBCvYI3vLKq9C4LHtX5cpDpVQ9Q3Pl0Qk6
RfIQ9eoiu5RDdURU/oBY3RxFHOq/PmvM9Lc86i5xj9kfPxA9fik7I=</la
texit>. . .
<latexit sha1_ba
se64="DrBigyEyJ5O5+eAoSwoyHbuA
I6A=">AB7XicbZDLSgMxFIYz9Vbr
rerSTbAKrsqMFHVnwY3LCvYC7VAymU
wbm0mG5IxQhr6DGxct4tZn8DXc+Tam
l4W2/hD4+P9zyDknSAQ34LrfTm5tfW
NzK79d2Nnd2z8oHh41jEo1ZXWqhNKt
gBgmuGR14CBYK9GMxIFgzWBwN82bz0
wbruQjDBPmx6QnecQpAWs1OiJUYLrF
klt2Z8Kr4C2gdPs5nmpS6xa/OqGiac
wkUEGMaXtuAn5GNHAq2KjQSQ1LCB2Q
HmtblCRmxs9m047wuXVCHCltnwQ8c3
93ZCQ2ZhgHtjIm0DfL2dT8L2unEN34
GZdJCkzS+UdRKjAoPF0dh1wzCmJogVD
N7ayY9okmFOyBCvYI3vLKq9C4LHtX5
cpDpVQ9Q3Pl0Qk6RfIQ9eoiu5RDdU
RU/oBY3RxFHOq/PmvM9Lc86i5xj9k
fPxA9fik7I=</latexit>. . .
. . .
. . .
<latexit sha1_base64="DrBigyEyJ
5O5+eAoSwoyHbuAI6A=">AB7XicbZDLSgMxFIYz9VbrerSTbAKrsqMFHV
nwY3LCvYC7VAymUwbm0mG5IxQhr6DGxct4tZn8DXc+Taml4W2/hD4+P9zyDk
nSAQ34LrfTm5tfWNzK79d2Nnd2z8oHh41jEo1ZXWqhNKtgBgmuGR14CBYK9G
MxIFgzWBwN82bz0wbruQjDBPmx6QnecQpAWs1OiJUYLrFklt2Z8Kr4C2gdPs
5nmpS6xa/OqGiacwkUEGMaXtuAn5GNHAq2KjQSQ1LCB2QHmtblCRmxs9m047
wuXVCHCltnwQ8c393ZCQ2ZhgHtjIm0DfL2dT8L2unEN34GZdJCkzS+UdRKjA
oPF0dh1wzCmJogVDN7ayY9okmFOyBCvYI3vLKq9C4LHtX5cpDpVQ9Q3Pl0Qk6
RfIQ9eoiu5RDdURU/oBY3RxFHOq/PmvM9Lc86i5xj9kfPxA9fik7I=</la
texit>. . .
<latexit sha1_ba
se64="DrBigyEyJ5O5+eAoSwoyHbuA
I6A=">AB7XicbZDLSgMxFIYz9Vbr
rerSTbAKrsqMFHVnwY3LCvYC7VAymU
wbm0mG5IxQhr6DGxct4tZn8DXc+Tam
l4W2/hD4+P9zyDknSAQ34LrfTm5tfW
NzK79d2Nnd2z8oHh41jEo1ZXWqhNKt
gBgmuGR14CBYK9GMxIFgzWBwN82bz0
wbruQjDBPmx6QnecQpAWs1OiJUYLrF
klt2Z8Kr4C2gdPs5nmpS6xa/OqGiac
wkUEGMaXtuAn5GNHAq2KjQSQ1LCB2Q
HmtblCRmxs9m047wuXVCHCltnwQ8c3
93ZCQ2ZhgHtjIm0DfL2dT8L2unEN34
GZdJCkzS+UdRKjAoPF0dh1wzCmJogVD
N7ayY9okmFOyBCvYI3vLKq9C4LHtX5
cpDpVQ9Q3Pl0Qk6RfIQ9eoiu5RDdU
RU/oBY3RxFHOq/PmvM9Lc86i5xj9k
fPxA9fik7I=</latexit>. . .
<latexit sha1_ba
se64="DrBigyEyJ5O5+eAoSwoyHbuA
I6A=">AB7XicbZDLSgMxFIYz9Vbr
rerSTbAKrsqMFHVnwY3LCvYC7VAymU
wbm0mG5IxQhr6DGxct4tZn8DXc+Tam
l4W2/hD4+P9zyDknSAQ34LrfTm5tfW
NzK79d2Nnd2z8oHh41jEo1ZXWqhNKt
gBgmuGR14CBYK9GMxIFgzWBwN82bz0
wbruQjDBPmx6QnecQpAWs1OiJUYLrF
klt2Z8Kr4C2gdPs5nmpS6xa/OqGiac
wkUEGMaXtuAn5GNHAq2KjQSQ1LCB2Q
HmtblCRmxs9m047wuXVCHCltnwQ8c3
93ZCQ2ZhgHtjIm0DfL2dT8L2unEN34
GZdJCkzS+UdRKjAoPF0dh1wzCmJogVD
N7ayY9okmFOyBCvYI3vLKq9C4LHtX5
cpDpVQ9Q3Pl0Qk6RfIQ9eoiu5RDdU
RU/oBY3RxFHOq/PmvM9Lc86i5xj9k
fPxA9fik7I=</latexit>. . .
<latexit sha1_ba
se64="DrBigyEyJ5O5+eAoSwoyHbuA
I6A=">AB7XicbZDLSgMxFIYz9Vbr
rerSTbAKrsqMFHVnwY3LCvYC7VAymU
wbm0mG5IxQhr6DGxct4tZn8DXc+Tam
l4W2/hD4+P9zyDknSAQ34LrfTm5tfW
NzK79d2Nnd2z8oHh41jEo1ZXWqhNKt
gBgmuGR14CBYK9GMxIFgzWBwN82bz0
wbruQjDBPmx6QnecQpAWs1OiJUYLrF
klt2Z8Kr4C2gdPs5nmpS6xa/OqGiac
wkUEGMaXtuAn5GNHAq2KjQSQ1LCB2Q
HmtblCRmxs9m047wuXVCHCltnwQ8c3
93ZCQ2ZhgHtjIm0DfL2dT8L2unEN34
GZdJCkzS+UdRKjAoPF0dh1wzCmJogVD
N7ayY9okmFOyBCvYI3vLKq9C4LHtX5
cpDpVQ9Q3Pl0Qk6RfIQ9eoiu5RDdU
RU/oBY3RxFHOq/PmvM9Lc86i5xj9k
fPxA9fik7I=</latexit>. . .
<latexit sha1_ba
se64="DrBigyEyJ5O5+eAoSwoyHbuA
I6A=">AB7XicbZDLSgMxFIYz9Vbr
rerSTbAKrsqMFHVnwY3LCvYC7VAymU
wbm0mG5IxQhr6DGxct4tZn8DXc+Tam
l4W2/hD4+P9zyDknSAQ34LrfTm5tfW
NzK79d2Nnd2z8oHh41jEo1ZXWqhNKt
gBgmuGR14CBYK9GMxIFgzWBwN82bz0
wbruQjDBPmx6QnecQpAWs1OiJUYLrF
klt2Z8Kr4C2gdPs5nmpS6xa/OqGiac
wkUEGMaXtuAn5GNHAq2KjQSQ1LCB2Q
HmtblCRmxs9m047wuXVCHCltnwQ8c3
93ZCQ2ZhgHtjIm0DfL2dT8L2unEN34
GZdJCkzS+UdRKjAoPF0dh1wzCmJogVD
N7ayY9okmFOyBCvYI3vLKq9C4LHtX5
cpDpVQ9Q3Pl0Qk6RfIQ9eoiu5RDdU
RU/oBY3RxFHOq/PmvM9Lc86i5xj9k
fPxA9fik7I=</latexit>. . .
<latexit sha1_ba
se64="DrBigyEyJ5O5+eAoSwoyHbuA
I6A=">AB7XicbZDLSgMxFIYz9Vbr
rerSTbAKrsqMFHVnwY3LCvYC7VAymU
wbm0mG5IxQhr6DGxct4tZn8DXc+Tam
l4W2/hD4+P9zyDknSAQ34LrfTm5tfW
NzK79d2Nnd2z8oHh41jEo1ZXWqhNKt
gBgmuGR14CBYK9GMxIFgzWBwN82bz0
wbruQjDBPmx6QnecQpAWs1OiJUYLrF
klt2Z8Kr4C2gdPs5nmpS6xa/OqGiac
wkUEGMaXtuAn5GNHAq2KjQSQ1LCB2Q
HmtblCRmxs9m047wuXVCHCltnwQ8c3
93ZCQ2ZhgHtjIm0DfL2dT8L2unEN34
GZdJCkzS+UdRKjAoPF0dh1wzCmJogVD
N7ayY9okmFOyBCvYI3vLKq9C4LHtX5
cpDpVQ9Q3Pl0Qk6RfIQ9eoiu5RDdU
RU/oBY3RxFHOq/PmvM9Lc86i5xj9k
fPxA9fik7I=</latexit>. . .
<latexit sha1_ba
se64="DrBigyEyJ5O5+eAoSwoyHbuA
I6A=">AB7XicbZDLSgMxFIYz9Vbr
rerSTbAKrsqMFHVnwY3LCvYC7VAymU
wbm0mG5IxQhr6DGxct4tZn8DXc+Tam
l4W2/hD4+P9zyDknSAQ34LrfTm5tfW
NzK79d2Nnd2z8oHh41jEo1ZXWqhNKt
gBgmuGR14CBYK9GMxIFgzWBwN82bz0
wbruQjDBPmx6QnecQpAWs1OiJUYLrF
klt2Z8Kr4C2gdPs5nmpS6xa/OqGiac
wkUEGMaXtuAn5GNHAq2KjQSQ1LCB2Q
HmtblCRmxs9m047wuXVCHCltnwQ8c3
93ZCQ2ZhgHtjIm0DfL2dT8L2unEN34
GZdJCkzS+UdRKjAoPF0dh1wzCmJogVD
N7ayY9okmFOyBCvYI3vLKq9C4LHtX5
cpDpVQ9Q3Pl0Qk6RfIQ9eoiu5RDdU
RU/oBY3RxFHOq/PmvM9Lc86i5xj9k
fPxA9fik7I=</latexit>. . .
<latexit sha1_base64="4SxW2zXAv
7j1Q8+c2kiO1rgVmNI=">AB6HicbZDLSgNBEVrfMb4irp0xgUV2FGgro
z4MZlAuYByRB6OjVJm54H3T1CGPIFblwoEpf+hb/hzr+xJ8lCEy80HO6toqv
KiwVX2ra/rZXVtfWNzdxWfntnd2+/cHDYUFEiGdZJCLZ8qhCwUOsa64FtmK
JNPAENr3hbZY3H1EqHoX3ehSjG9B+yH3OqDZWTXQLRbtkT0WwZlD8eZzkum
92i18dXoRSwIMNRNUqbZjx9pNqdScCRznO4nCmLIh7WPbYEgDVG46HXRMTo3
TI34kzQs1mbq/O1IaKDUKPFMZUD1Qi1lm/pe1E+1fuykP40RjyGYf+YkgOiL
Z1qTHJTItRgYok9zMStiASsq0uU3eHMFZXHkZGhcl57JUrpWLlTOYKQfHcALn
4MAVOAOqlAHBghP8AKv1oP1bL1Zk1npijXvOYI/sj5+APBmkWw=</latexi
t>l
<latexit
 sha1_base64="t
fMdsLUz3YCAmaLQ
jKGCfyUJ9fQ=">A
AB6HicbZDLTsJA
FIZP8YZ4Q126aSQ
aV6Q1RN1J4sYlJH
JoCHT4QAD02kzM
zUhDU/gxoXG4NK3
8DXc+TZOgYWCfzL
Jl/8/J3PO8SPOlH
acbyuztr6xuZXdz
u3s7u0f5A+P6iqM
JcUaDXkomz5RyJnA
maYzOSAKfY8M
f3aV54xGlYqF40O
MIvYD0BesxSrSxq
sNOvuAUnZnsVXAX
ULj9nKZ6r3TyX+1
uSOMAhacKNVynU
h7CZGaUY6TXDtWG
BE6In1sGRQkQOUl
s0En9plxunYvlOY
Jbc/c3x0JCZQaB7
6pDIgeqOUsNf/LW
rHu3XgJE1GsUdD5
R72Y2zq063tLpN
INR8bIFQyM6tNB0
QSqs1tcuYI7vLKq
1C/LpXxVK1VCif
w1xZOIFTuAXrqE
M91CBGlBAeIXeL
WG1rP1Zk3npRlr0
XMf2R9/ADtXpFq
</latexit>j
U(j,l)
z
}|
{
<latexit sha1_base64="7oDR04sWA
vFhGfMPhBriNbCWTWQ=">ACO3icpVDLSsNAFJ34rPUVdelmsCgVpCRS1J0
FNy6r2Ae0sUymk3bsZBJmJkIJ8T/0S3ThT7hz48aFIm7dO2m70NadBy4czrm
Xe+9xQ0alsqxnY2p6ZnZuPrOQXVxaXlk19arMogEJhUcsEDUXSQJo5xUFW
M1ENBkO8yUnN7J6lfuyZC0oBfqH5IHB91OPUoRkpLfO8GWjbFQiT+OY/SC7
jav5qj+0mLTNnFawB4CSxRyR3/HCb4q7cMp+a7QBHPuEKMyRlw7ZC5cRIKIo
ZSbLNSJIQ4R7qkIamHPlEOvHg9wRua6UNvUDo4goO1J8TMfKl7Pu7vSR6sp
xLxX/8hqR8o6cmPIwUoTj4SIvYlAFMA0StqkgWLG+JgLqm+FuIt0kErHndUh
2OMvT5LqfsE+KBTPirnSDhgiAzbBFsgDGxyCEjgFZVABGNyDF/AG3o1H49X4
MD6HrVPGaGYD/ILx9Q1l4bpt</latexit>
V (j,l)
z
}|
{
Figure 3: Depiction of U(j, l) as green solid discs, and V (j, l) as blue solid discs.
In the same spirit, recall that for every 1 ≤j ≤n −1, Dn contains the triangle
{bj
1, bj
2, uj
1}, so if a repair contains either bj
1 or bj
2 and contains no solution to q4, this repair
must pick no uj
i fact in the blocks of Ej.
Thus, we define U(j, 1) = U(j, 2) = ∅and
V (j, 1) = V (j, 2) = {vj
k | 1 ≤k ≤n −3}, so that there are no solutions in the set of facts
U(j, l) ∪V (j, l) ∪{bj
l }, for l ∈{1, 2}.
Dually, {bj
n−1, bj
n, vj
n−3} forms a triangle, so define U(j, n) = U(j, n −1) = {uj
k | 1 ≤
k ≤n −3} and V (j, n) = V (j, n −1) = ∅. Again there are no solutions in the set of facts
U(j, l) ∪V (j, l) ∪{bj
l }, for l ∈{n −1, n}.
Overall, for every 1 ≤l ≤n and every 1 ≤j ≤n −1 we have:
U(j, l) ∪V (j, l) ∪{bj
l } forms a partial repair over the blocks {Bj} ∪Ej, and
U(j, l) ∪V (j, l) ∪{bj
l } contains no solution.
A set of facts W of size k is called a k-obstruction set if W is a partial repair of some
X = {X1, . . . Xk} and if X∩B = {Bi1, Bi2 . . . Bil} for some l ≤k with W[B] = {bj1
i1, bj2
i2 . . . bjl
il},
then the following conditions hold:
(1) j1, j2, . . . jl are pairwise distinct.
(Informally: elements of W in B are in different ‘rows’ in Figure 1.)
(2) For every 1 ≤m ≤l we have W[Ejm] ⊆U(jm, im) ∪V (jm, im).
(Informally: if W contains an element at row jm connected to the block Bim then it
must be painted green or blue in Figure 3, under the renaming j 7→jm and l 7→im.)
(3) For every 1 ≤j ≤n −1 there exists 1 ≤l ≤n such that W[Ej] ⊆U(j, l) ∪V (j, l).
(Informally: all the elements of W at a row j must be painted green or blue in Figure 3,
for some choice of indices.)
Lemma 5.5. If b is a fact in Dk+2 then there always exists a k-obstruction set that contains b.
Proof. Let B be the block such that b ∈B. Now if B is of the form Bi then let b = bj
i and
we can choose the k −1 other blocks of the form Bi′ and pick bj
i from Bi and pick bj′
i′ from
each chosen Bi′ such that Item 1 is satisfied which forms a k-obstruction set (this is always
possible since each Bl has k + 1 facts).
Suppose B is of the form Ej
i then if b = uj
i then we can pick V (j, l−1)∪U(j, l−1)∪{bj
l−1}
that forms an obstruction set for {Bj} ∪Ej. If b = vj
i then we can pick V (j, l + 1) ∪U(j, l +
1) ∪{bj
l+1} that again forms an obstruction set for {Bj} ∪Ej.

---

Vol. 21:1
A SIMPLE ALGORITHM FOR CQA UNDER PRIMARY KEYS
18:21
Lemma 5.6. If W is a k-obstruction set, then there are no solutions to the query q4 within
W.
Proof. Let W be a partial repair of X = {X1, . . . Xk}. By Condition (3), for every 1 ≤j ≤
n −1 there are no solutions within W[Ej]. By construction, it is also not possible to have
solutions involving one fact from W[Ej] and another from W[Ej′] for j̸ = j′ (cf. Figure 1).
So if a solution exists, it has to involve some fact of the form bj
l ∈W[B]. By construction
of Dn this solution must involve either uj
l−1 or vj
l−2. But by Condition (2) none of them are
in W.
We are now in shape to prove Proposition 5.4, which is a consequence of the following
two claims.
Claim 5.7. For every set of k blocks X = {X1, . . . Xk} of Dk+2, there exists a partial repair
W of X such that W is a k-obstruction set.
Claim 5.8. For every set of facts W, if W is a k-obstruction set, then W̸ ∈∆+
k(q4, Dk+2).
Proof of Proposition 5.4. Assuming that the two claims are true, they together imply that
for every set of blocks {X1, . . . , Xk} of Dk+2 there exists a partial repair W for {X1, . . . , Xk}
such that W̸ ∈∆+
k(q4, Dk+2).
Suppose ∅∈∆+
k(q4, Dk+2) was obtained by using the first derivation rule. Then, there
is some block B such that for every fact a ∈B we have {a} ∈∆+
k(q4, Dk+2). Let X be an
arbitrary set of blocks of size k such that B ∈X (such X can always be picked since Dk+2
has sufficiently many blocks). By Claim 5.7 there exists a k-obstruction set W which is a
partial repair of X and by Claim 5.8 W̸ ∈∆+
k(q4, Dk+2). This is a contradiction for the fact
a ∈B ∩W. Thus, Dk+2̸ |= Cert+
k(q4).
If, on the other hand, ∅∈∆+
k(q4, Dk+2) was obtained by using the second derivation rule,
then there is a fact a such that for every a′ ∈A = {b ∈Dk+2 : Dk+2 |= q(ab)∨q(ba)∨a = b}
we have {a′} ∈∆+
k(q4, Dk+2). But from Lemma 5.5 there is a k-obstruction set W such
that a ∈W. Moreover, from the two rules to compute ∆+
k(q4, Dk+2), it follows that if S ∈
∆+
k(q4, Dk+2) and S ⊆S′ where |S′| ≤k then S′ ∈∆+
k(q4, Dk+2). Hence, W ∈∆+
k(q4, Dk+2)
which contradicts Claim 5.8.
Hence, we are only left with the proofs of Claims 5.7 and 5.8.
Proof of Claim 5.7. Recall that Dk+2 has k + 2 blocks of the form Bi and each Bi has k + 1
facts. Further, for every 1 ≤j ≤k + 1 we have the sets of blocks of the from Ej
1 . . . Ej
k−1.
First let X ∩B = {Bi1, . . . Bim} for some m ≤k and i1, i2 . . . im ≤k + 2. We let W to
contain {b1
i1, b2
i2, . . . bm
im}. Moreover for every 1 ≤j ≤m we add to W the partial repair
induced by U(j, ij) ∪V (j, ij). Formally, we add (U(j, ij) ∪V (j, ij)) ∩SX to W (i.e., all facts
of U(j, ij) ∪V (j, ij) that are in a block of X). This ensures that conditions (1) and (2) are
satisfied.
Now for all m < j ≤k + 1 we add to W the partial repair induced by V (j, 1) (i.e.,
V (j, 1) ∩SX). Hence, condition (3) is also satisfied and W is a k-obstruction set.
Proof of Claim 5.8. Let ∆+
k(q4, Dk+2, i) be the set computed by the algorithm of Cert+
k(q4)
at step i of the fixpoint computation.
Suppose the claim is false, and let n be the least index such that W ∈∆+
k(q4, Dk+2, n)
for some k-obstruction set W over the blocks X = {X1, . . . , Xk}.

---

18:22
D. Figueira, A. Padmanabha, L. Segoufin, and C. Sirangelo
Vol. 21:1
<latexit sha1_b
ase64="DrBigyEyJ5O5+eAoSwoyHbu
AI6A=">AB7XicbZDLSgMxFIYz9V
brerSTbAKrsqMFHVnwY3LCvYC7VA
ymUwbm0mG5IxQhr6DGxct4tZn8DXc+
Taml4W2/hD4+P9zyDknSAQ34LrfTm
5tfWNzK79d2Nnd2z8oHh41jEo1ZXWq
hNKtgBgmuGR14CBYK9GMxIFgzWBwN
82bz0wbruQjDBPmx6QnecQpAWs1OiJ
UYLrFklt2Z8Kr4C2gdPs5nmpS6xa/
OqGiacwkUEGMaXtuAn5GNHAq2KjQS
Q1LCB2QHmtblCRmxs9m047wuXVCHCl
tnwQ8c393ZCQ2ZhgHtjIm0DfL2dT8
L2unEN34GZdJCkzS+UdRKjAoPF0dh1
wzCmJogVDN7ayY9okmFOyBCvYI3vL
Kq9C4LHtX5cpDpVQ9Q3Pl0Qk6RfIQ
9eoiu5RDdURU/oBY3RxFHOq/PmvM
9Lc86i5xj9kfPxA9fik7I=</latex
it>. . .
<latexit sha1_b
ase64="DrBigyEyJ5O5+eAoSwoyHbu
AI6A=">AB7XicbZDLSgMxFIYz9V
brerSTbAKrsqMFHVnwY3LCvYC7VA
ymUwbm0mG5IxQhr6DGxct4tZn8DXc+
Taml4W2/hD4+P9zyDknSAQ34LrfTm
5tfWNzK79d2Nnd2z8oHh41jEo1ZXWq
hNKtgBgmuGR14CBYK9GMxIFgzWBwN
82bz0wbruQjDBPmx6QnecQpAWs1OiJ
UYLrFklt2Z8Kr4C2gdPs5nmpS6xa/
OqGiacwkUEGMaXtuAn5GNHAq2KjQS
Q1LCB2QHmtblCRmxs9m047wuXVCHCl
tnwQ8c393ZCQ2ZhgHtjIm0DfL2dT8
L2unEN34GZdJCkzS+UdRKjAoPF0dh1
wzCmJogVDN7ayY9okmFOyBCvYI3vL
Kq9C4LHtX5cpDpVQ9Q3Pl0Qk6RfIQ
9eoiu5RDdURU/oBY3RxFHOq/PmvM
9Lc86i5xj9kfPxA9fik7I=</latex
it>. . .
<latexit
 sha1_base64="g
p4XbjsJSjrMvCm
ZAxVRazHNG0=">
AB8HicdVDLSgN
BEJz1GeMr6tHLY
BT0szGjSYnA148
RjAPSUKYnUySIbM
PZnrFsOQrvKgo4t
U/8De8+TdOEgUV
LWgoqrp6vYiKTQ
Q8m7NzM7NLymlt
LK6tr65mNzaoO
Y8V4hYUyVHWPai5
FwCsgQPJ6pDj1Pc
lr3uB07NeuNIiD
C5gGPGWT3uB6Ap
GwUiXTeDXkNCDUT
uTJXaxSFy3gImdJ
7mcmzeEHOYKBQc
7Npkge/J6N8Z9uZ
15a3ZCFvs8ACap1
g2HRNBKqALBJB+l
m7HmEWUD2uMNQw
Pqc91KJoFHeM8oH
dwNlakA8ET9PpFQ
X+uh75lOn0Jf/
bG4l9eI4ZuoZWI
IqB2y6qBtLDCEe
X487QnEGcmgIZUq
YrJj1qaIMzI/S5
glfl+L/STVnO0e2
e+5mS7toihTaRjt
oHznoGJXQGSqjC
mLIRzfoAT1ayrq1
nqznaeuM9TmzhX7
AevkAcVGVOw=</
latexit>a)
<latexit sha1_b
ase64="1nwriNcJjQoXfTtgB/Dq5+8
ShwM=">AB8HicdVDLSgNBEJz1Ge
Mr6tHLYBT0szGjSYnA148RjAPSUK
YnUySIbMPZnrFsOQrvKgo4tU/8De8+
TdOEgUVLWgoqrp6vYiKTQ8m7NzM
7NLymltLK6tr65mNzaoOY8V4hYUy
VHWPai5FwCsgQPJ6pDj1Pclr3uB07
NeuNIiDC5gGPGWT3uB6ApGwUiXTeD
XkHgHo3YmS+xikbhuARM7T3I5N28I
OcwVCg52bDJB9uT1boz7cjvz1uyEL
PZ5AExSrRsOiaCVUAWCST5KN2PNI8o
GtMcbhgbU57qVTAKP8J5ROrgbKlMB
4In6fSKhvtZD3zOdPoW+/u2Nxb+8Rg
zdQisRQRQD9h0UTeWGEI8vh53hOI
M5NAQypQwWTHrU0UZmB+lzRO+LsX/k
2rOdo5s9zNlnbRFCm0jXbQPnLQMS
qhM1RGFcSQj27QA3q0lHVrPVnP09Y
Z63NmC/2A9fIBcteVPA=</latexit
>b)
<latexit sha1_base64="/mtam1q4
Tj6Pe9tksqNhBz9Vto=">AB8HicdVDLSgNBEJz1GeMr6tHLYBT0szGj
SYnA148RjAPSUKYnUySIbMPZnrFsOQrvKgo4tU/8De8+TdOEgUVLWgoqrp
6vYiKTQ8m7NzM7NLymltLK6tr65mNzaoOY8V4hYUyVHWPai5FwCsgQP
J6pDj1Pclr3uB07NeuNIiDC5gGPGWT3uB6ApGwUiXTeDXkLCDUTuTJXaxS
Fy3gImdJ7mcmzeEHOYKBQc7Npkge/J6N8Z9uZ15a3ZCFvs8ACap1g2HRNBK
qALBJB+lm7HmEWUD2uMNQwPqc91KJoFHeM8oHdwNlakA8ET9PpFQX+uh75l
On0Jf/bG4l9eI4ZuoZWIqB2y6qBtLDCEeX487QnEGcmgIZUqYrJj1qa
IMzI/S5glfl+L/STVnO0e2e+5mS7toihTaRjtoHznoGJXQGSqjCmLIRzfoA
T1ayrq1nqznaeuM9TmzhX7AevkAdF2VPQ=</latexit>c)
<latexit sha1_base64="LKCnSwM+
Lc2RsLo+bn52itWlIFI=">ACB3icbVDLSgNBEJz1GeNr1aMg4ngKexKU
PFiwIvHCOYBSQizk9lkyOzOMtMrhiU3L36CfoIXD4ro0V/w5t84m+SgiQUN
RVU3V1eJLgGx/m25uYXFpeWMyvZ1bX1jU17a7uqZawoq1ApKp7RDPBQ1
YBDoLVI8VI4AlW8/oXqV+7YUpzGV7DIGKtgHRD7nNKwEhte68J7BaSM+wJS
fsaSx/nmwGBnufhen7YtnNOwRkBzxJ3QnLnHw8pHst+6vZkTQOWAhUEK0b
rhNBKyEKOBVsmG3GmkWE9kmXNQwNScB0Kxn9McQHRulgXypTIeCR+nsiIYH
Wg8AznemJetpLxf+8Rgz+aSvhYRQDC+l4kR8LDBKnoeAOV4yCGBhCqOLmVk
x7RBEKJrqsCcGdfnmWVI8K7nGheFXMlfJojAzaRfvoELnoBJXQJSqjCqLoD
j2hF/Rq3VvP1pv1Pm6dsyYzO+gPrM8fmb2c4Q=</latexit>: blocks of X
: elements of W
<latexit sha1_base64="GpXaLVQD
LzN0DW07E7uR2PZLy18=">AB+nicbVBNS0JBFJ3Xp9nXs5ZthjQwCHkvp
KJNQpuWBj0VGTeOrkvA9m7qvk5Q8paNOiLZt+hvt+jfNUxelHbhwOde
7r3HDQVXYFnfxtz8wuLScmolvbq2vrFpZrYqKogkZQ4NRCBrLlFMcJ85wE
GwWigZ8VzBqm7/PGrN0wqHvhXMAhZ0yNdn3c4JaClplpALuD+BTnPz1g
djPDVtm1ipYI+BZYk9I9uzIcFjuWV+NdoBjTzmAxVEqbpthdCMiQROBRum
G5FiIaF90mV1TX3iMdWMR6cP8Z5W2rgTSF0+4JH6eyImnlIDz9WdHoGemvY
S8T+vHkHnpBlzP4yA+XS8qBMJDAFOcsBtLhkFMdCEUMn1rZj2iCQUdFpHY
I9/fIsqRwW7KNC8bKYLeXQGCm0g3ZRHtnoGJXQBSojB1F0i57QC3o17o1n4
814H7fOGZOZbfQHxscPbRaXMg=</latexit>: U(j, l)
<latexit sha1_base64="xviGaUfc
UguRgarjIlkM+Sas/NQ=">AB+nicbVDLSgNBEJz1GeNro0cvg4kQcKuB
BUvBrx4jGAekCxhdjJxsw+mOlVw5oPUfDiQRGvXvwNb/6Ns0kOmljQUFR1
093lhoIrsKxvY25+YXFpObWSXl1b39g0M1tVFUSsgoNRCDrLlFMcJ9VgI
Ng9VAy4rmC1dz+eLXbphUPCvYBAyxyNdn3c4JaClplpAruD+BTnqvnrA
7GfG7bMrFWwRsCzxJ6Q7NnQ4LHcsv8arYDGnMByqIUg3bCsGJiQROBRum
m5FiIaF90mUNTX3iMeXEo9OHeE8rbdwJpC4f8Ej9PRET6mB5+pOj0BPTXu
J+J/XiKBz4sTcDyNgPh0v6kQCQ4CTHCbS0ZBDQhVHJ9K6Y9IgkFnVZah2
BPvzxLqocF+6hQvCxmSzk0RgrtoF2URzY6RiV0gcqogi6RU/oBb0a98az8
Wa8j1vnjMnMNvoD4+MHbqGXMw=</latexit>: V (j, l)
<latexit sha1_base64="ah0IcQ7D
/VITzngDwj932CS2FQ=">AB+3icbVC7SgNBFJ31GeNrjaXNYCJYhV0JK
jZGbCwjmAckS5idzCZDZh/M3JWEZT9ECxsLRWwt/A07/8bZJIUmHrhwOde
7r3HjQRXYFnfxtLyuraem4jv7m1vbNr7hUaKowlZXUailC2XKY4AGrAw
fBWpFkxHcFa7rD68xv3jOpeBjcwThijk/6Afc4JaClrlnoABtBcoFdEdIhL
l2V0q5ZtMrWBHiR2DNSvPx8yPBY65pfnV5IY58FQAVRqm1bETgJkcCpYGm+
EysWETokfdbWNCA+U04yuT3FR1rpYS+UugLAE/X3REJ8pca+qzt9AgM172X
if147Bu/cSXgQxcACOl3kxQJDiLMgcI9LRkGMNSFUcn0rpgMiCQUdV16HYM
+/vEgaJ2X7tFy5rRSrJTRFDh2gQ3SMbHSGqugG1VAdUTRCT+gFvRqp8Wy8G
e/T1iVjNrOP/sD4+AHFRZgA</latexit>: block A
Figure 4: Database Dk+2 in the proof of Claim 5.8, with k-obstruction set W over blocks X.
Dotted-line boxes depict the block A in cases a) b) and c) of the proof.
Note that n = 0 is not possible since W does not contain any solution (cf. Lemma 5.6);
hence n > 0. By definition of ∆+
k(q4, Dk+2, n), this implies that there exists a set of facts A
such that either
• (first derivation rule) A is a block in Dk+2, or
• (second derivation rule) for some fact a we have D̸ |= q(aa) and A = {a} ∪{b | D |=
q(ab) ∪a(ba)},
and for all a′ ∈A there is a subset W ′ ⊆W ∪{a′} of size at most k such that W ′ ∈
∆+
k(q4, Dk+2, n −1) and further W ′ is not a k-obstruction set, nor a subset thereof.
Let X ∩B = {Bi1, . . . Bim} for some m ≤k and W[B] = {bj1
i1, bj2
i2, . . . bjm
im}. So there
exists k + 1 −m many distinct indices j that are not in {j1, . . . , jm}. Let jm+1, . . . , jk, jk+1
be those indices. Since X is of size k, among those indices there can be at most k −m
many indices s such that X ∩Es̸ = ∅. Thus, there exists at least one index s such that
s̸ ∈{j1, . . . jm} and X ∩Es = ∅.
Now we consider various candidates for A and show that each case leads to a contradic-
tion.
• If A = Bl for some 1 ≤l ≤k + 2 then consider bs
l ∈Bl. Observe that every k-set of size k
over W ∪{bs
l } forms a k-obstruction set since condition (2) holds vacuously for s. Hence,
there must exist a k-obstruction set inside ∆+
k(q4, Dk+2, n −1), which is in contradiction
with the minimality of n.
• If, otherwise, A = Eλ
l for some 1 ≤λ ≤k + 1 and 1 ≤l ≤k −1, there are three cases to
consider depending on where A lies in relation to X (see Figure 4):
a) If λ ∈{j1, . . . jm}, say λ = jt, then by condition (2) W[Eλ] ⊆U(jt, it) ∪V (jt, it). Let w
be the fact in Eλ
l picked by U(jt, it) ∪V (jt, it). Then every k-sized subset of W ∪{w} is
a k-obstruction set (all conditions follow since W is already a k-obstruction set). This
is in contradiction with the minimality of n.
b) If λ̸ ∈{j1, . . . jm} but X ∩Er̸ = ∅then by condition (3), W[Eλ] ⊆U(λ, λ′) ∪V (λ, λ′)
for some 1 ≤λ′ ≤k + 2. Let w be the fact in Eλ
l picked by U(λ, λ′) ∪V (λ, λ′). Then,

---

Vol. 21:1
A SIMPLE ALGORITHM FOR CQA UNDER PRIMARY KEYS
18:23
again every k-size subset of W ∪{w} is a k-obstruction set (all conditions follow since
W is already a k-obstruction set). This is a contradiction.
c) Otherwise, λ̸ ∈{j1, . . . jm} and X∩Eλ = ∅. In this case, pick vλ
l ∈Eλ
l for some arbitrary
l. We have {vλ
l } ⊆U(λ, 1) ∪V (λ, 1). Hence, it can be verified that every k-sized subset
of W ∪{vλ
l } is a k-obstruction set, which again is a contradiction.
• Otherwise A = {b ∈D : D |= q(ab) ∨q(ba) ∨a = b} for some fact a ∈Dk+2 which implies
that A is of the form {bλ
l , uλ
l−1, vλ
l−2} or {bλ
1, bλ
2, uλ
1} or {bλ
n−1, bλ
n, vλ
n−3}. We only prove the
case where A = {bλ
l , uλ
l−1, vλ
l−2} and the other two cases are analogous. The argument is
similar to the previous case.
a) If λ ∈{j1, . . . jm}, say λ = jt, then by condition (2) W[Eλ] ⊆U(jt, it) ∪V (jt, it). Let w
be the fact in A picked by U(jt, it) ∪V (jt, it). Then every k-sized subset of W ∪{w} is
a k-obstruction set (all conditions follow since W is already a k-obstruction set). This
is in contradiction with the minimality of n.
b) If λ̸ ∈{j1, . . . jm} but X ∩Er̸ = ∅then by condition (3), W[Eλ] ⊆U(λ, λ′) ∪V (λ, λ′)
for some 1 ≤λ′ ≤k + 2. Let w be the fact in A picked by U(λ, λ′) ∪V (λ, λ′). Then,
again every k-size subset of W ∪{w} is a k-obstruction set (all conditions follow since
W is already a k-obstruction set). This is a contradiction.
c) Otherwise, λ̸ ∈{j1, . . . jm} and X ∩Eλ = ∅. In this case, pick vλ
l−2 ∈A. We have
{vλ
l−2} ⊆U(λ, 1) ∪V (λ, 1).
Hence, it can be verified that every k-sized subset of
W ∪{vλ
l } is a k-obstruction set, which again is a contradiction.
As we have seen, certain(q4) cannot be computed using our fixpoint algorithm. We will
next show that certain(q4) is complete for the Saturating Bipartite Matching problem (or
SBM problem for short). This is the problem of, given bipartite graph (V1 ∪V2, E), whether
there is an injective function f : V1 →V2 such that (v, f(v)) ∈E for every v ∈V1. The SBM
problem3 is known to be in PTime [HK73], hence certain(q4) can be solved in polynomial
time, although its precise complexity class is open.
Theorem 5.9. certain(q4) is complete for the (complement of the) SBM problem under
LogSpace-reductions. In particular certain(q4) is in PTime.
Proof. First we prove that there is a LogSpace-reduction from certain(q4) to the (comple-
ment of the) SBM problem. Fix an input database D. We reduce certain(q4, D) to the SBM
problem.
First we check for self-loops in D. If there is a fact a ∈D such that D |= q(aa) then we
first check if a is a singleton block. If so, then D |= certain(q4). Otherwise, D |= certain(q4)
iff D \ {a} |= certain(q4), so we can consider a smaller database and repeat the argument.
Moreover this pre-processing can be performed in LogSpace. So assume that there is no
fact a ∈D such that D |= q4(aa).
Now consider the bipartite graph G = (V1 ∪V2, E) where V1 is the set of all blocks of D
and V2 is the set of all maximal cliques in the solution graph GD. Note that, by property (4)
(in page 18), V2 forms a partition of D, namely the set of all maximal connected components
of GD. Let (v1, v2) ∈E if the block v1 contains a fact which is in the clique v2.
Suppose that there is a V1-saturating matching, that is, an injective function f : V1 →V2
such that (v1, f(v1)) ∈E for every v1 ∈V1. We construct a repair r where for every block B
of D, we pick the fact (or one of the facts, if there are more than one) which is in f(B). In
3In turn, the SBM problem is equivalent to the Bipartite Perfect Matching problem under LogSpace
reductions, which corresponds to the restriction to instances in which |V1| = |V2|.

---

18:24
D. Figueira, A. Padmanabha, L. Segoufin, and C. Sirangelo
Vol. 21:1
this way, no two chosen facts will be in the same clique, and also since there is no solution
of the form q4(aa) in D, no two chosen facts will form a solution to q4. Thus, r̸ |= q4.
Conversely, if q4 is not certain in D, let r be a repair such that r̸ |= q4. For each block
B of D let r(B) be the fact of B belonging to r. Note that, since V2 is a partition of D,
each r(B) belongs to a unique clique in V2. Define f : V1 →V2 such that each block B ∈V1
is mapped to the clique in V2 where r(B) lies. To verify that f is a witness function of a
V1-saturating matching for G, note that for every B ∈V1 we have (B, f(B)) ∈E, as B and
f(B) both contain r(B). Moreover, f is injective, otherwise if f maps two distinct blocks to
the same clique, this clique must contain at least two facts a, b from r. These two facts are
neighbors in GD, and then r |= q4(ab) or r |= q4(ba), contradicting the hypothesis r̸ |= q4.
Thus, to check if D ∈certain(q4), it is sufficient to check if there is a V1-saturating
matching for GD.
For the other direction, given a bipartite graph G = (V1 ∪V2, E), let V1 = {s1, . . . sn}
and V2 = {t1, . . . tm}. We will define a database DG such that there exists a V1-saturating
matching in G iff q4 is not certain in DG.
For all sj ∈V1 let N(sj) ⊆V2 denote the neighbours of sj and similarly for all ti ∈V2
let N(ti) ⊆V1 denote the neighbours of tj.
First note that if there is some sj ∈V1 such that N(sj) = ∅, then clearly there cannot
be a V1-saturating matching. Similarly, if there is some ti ∈V2 such that N(ti) = ∅, then ti
does not contribute to any matching and hence can be removed from the input. Further,
suppose there is some ti ∈V2 such that |N(ti)| = 1, let sj be the single neighbour of ti. In
this case, in every V1-saturating matching maps sj to ti. So we can remove the vertices
sj and ti from the input graph and conside a smaller instance. Note that all these checks
can be done in LogSpace. Hence we assume that for every u ∈V1 ∪V2, N(u)̸ = ∅and
|N(sj)| ≥1 for all sj ∈V1 and |N(ti)| ≥2 for all ti ∈V2.
Now we define the database DG. Note that this construction is very similar to the
construction of Dn that we used to prove Theorem 5.1.
• For every vertex in sj ∈V1 create a block Bj in DG.
• For every sj ∈V1 and ti ∈V2, if ti ∈N(sj) then there is a fact denoted by bi
j in the block
Bj. By assumption N(sj) ≥1 and hence every block Bj is non-empty.
• For every ti ∈V2 if |N(ti)| = l then let si1, . . . sil ∈V1 be the neighbours of t. By the
above construction, for every j ≤l, there is a fact of the form bi
ij in Bij that corresponds
to the vertex ti.
Now if l = 2 then define bi
i1 and bi
i2 such that they form a solution to q4. Otherwise, if
l = 3 then define bi
i1, bi
i2 and bi
i3 such that they pair-wise form a solution to q4 (the three
facts form a triangle).
If l ≥4 then create l −3 new blocks denoted by Ei
1, . . . Ei
l−3 where each Ei
j contains
exactly two facts ui
j and vi
j. Moreover, in the same way as described in the definition of
Dn earlier (cf. Figures 1 and 2), define the facts appropriately such that {bi
i1, bi
i2, ui
1} and
{bi
il−1, bi
il, vi
l−3} form triangles and for every 1 ≤j < l−3 we have a triangle {vi
j, ui
j+1, bi
j+2}.
The reader can verify that this is exactly the construction used to define Dn. Again, this
construction is in LogSpace. For each such j and l define the analogous U(i, l) ˆ= {ui
k | 1 ≤
k ≤l −2} and V (i, l) ˆ= {vi
k | l −1 ≤k ≤l −3}.

---

Vol. 21:1
A SIMPLE ALGORITHM FOR CQA UNDER PRIMARY KEYS
18:25
Now suppose there is a V1-saturating matching then let us show that q4 is not certain
for DG. Consider the repair r where for each block Bj we pick bi
j if sj is matched with ti.
Further, pick U(i, l) ∪V (i, l) which gives a partial repair over Ei
1 . . . Ei
l.
If some ti ∈V2 is not matched with any vertex in V1 then pick U(i, 1) ∪V (i, 1) which
gives a partial repair over Ei
1 . . . Ei
l. It can be verified that the obtained repair does not
contain any solution.
Conversely, suppose there is a repair r of DG that falsifies q4, and let us show that there
is a V1-saturating matching in G. For any such repair r, note that if bi
j is picked in block Bj
then for all other blocks Bj′, the fact bi
j′ cannot be in r since that would make q4 true. Also
bi
j ∈Bj only if there is an edge between sj and ti. Hence, we can define the V1-saturating
matching that maps every sj ∈V1 to ti ∈V2, where bi
j is the fact in r from the block Bj.
5.2. The case of q5.
We now show that certain(q5) cannot be computed by Certk(q5). This is shown by
reduction to the case of q4 based on the following construction:
Proposition 5.10. For every database D over the signature of q4 we can construct a
database D′ over the signature of q5 such that:
(1) if D |= certain(q4) then D′ |= certain(q5);
(2) for every k ≥2, if D′ |= Certk(q5) then D |= Cert+
k(q4).
Proof. Let D be a database over the signature of q4. Consider the solution graph GD of D.
Recall that by property (4), every connected component in GD is always a clique of size at
most 3. Thus, every fact of D can be part of exactly one maximal clique.
Let B1, B2 . . . Bm be the set of all blocks of D and C1, C2 . . . Cl be the set of cliques in
GD. Let e1, e2 . . . em, f1, f2 . . . fl be fresh and pairwise distinct domain elements. Define D′
as follows:
• For every fact u occurring in a block Bi of D and in the clique Cn add the fact uR1 =
R1(ei fn) to D′. Notice that there could be two distinct facts occurring in the same block
of D and in the same clique. They are then both associated to the same fact of D′.
• For every two facts u, v from a clique Cn such that D |= q4(uv) and u, v are in two distinct
blocks Bi and Bj, create two new facts in D′ as uv
S1 = S1(fng ei) and vu
S1 = S1(fng ej),
where g is a fresh element depending only on u and v.
• For every fact u from a clique Cn and a block Bi such that D |= q4(uu) add a fact in D′
as uu
S1 = S1(fng ei), where g is a fresh element depending only on u.
See Figure 5 for an example.
Notice that for any two facts u, v ∈D if D |= q4(uv) and u, v are in two distinct
blocks, then uv
S1 ∼vu
S1, D′ |= q5(uR1uv
S1) ∧q5(vR1vu
S1), and the block containing uv
S1, vu
S1
in D′ does not contain any other fact. Moreover if for some fact u ∈D, D |= q4(uu) then
D′ |= q5(uR1uu
S1) and the block containing uu
S1 in D′ does not contain any other fact. Finally,
the only solutions in D′ for q5 are of the form q5(uR1uv
S1) for some facts u, v ∈D such that
D |= q4(uv) and u̸ ∼v or u = v. Now we prove both claims of the statement.
(1) Suppose D |= certain(q4). To verify that D′ |= certain(q5), pick any repair r′ of D′. By
construction, every R1-fact a of r′ is of the form uR1 for some fact u in D. Recall that there

---

18:26
D. Figueira, A. Padmanabha, L. Segoufin, and C. Sirangelo
Vol. 21:1
B1
B2
B3
B4
R1 :
ase64="YdgnJY2z6QEwP17dgq8N/
nvw/AY=">AB63icdZDLSgMxFIY
z9VbrerSTbAorkqmaG3dWHDjsqK
9QDuUTJpQ5PMkGSEMvQV3LhQi1sf
wtdw59uYaRVU9IfAx/+fQ845fsSZ
Ngi9O5mFxaXlexqbm19Y3Mrv73T
1GsCG2QkIeq7WNOZO0YZjhtB0p
ioXPacsfXaR565YqzUJ5Y8YR9QeS
BYwgk1qXfcs16+gIrIqlyGKbgV5
FqoViulUhW6swihwvnrU6pvZd/6
/ZDEgsqDeFY646LIuMlWBlGOJ3ku
rGmESYjPKAdixILqr1kNusEHlinD4
NQ2ScNnLnfOxIstB4L31YKbIb6d5
af2Wd2AQVL2Eyig2VZP5REHNoQp
guDvtMUWL42AImitlZIRlihYmx58
nZI3xtCv+HZqnolosnV8eF2iGYKwv
2wD4Ai4BTVwCeqgAQgYgjvwAB4
d4dw7U+d5XpxPnt2wQ85Lx/E+ZJ
5</latexit> S1 :
C1
C2
ase64="CV0GD827aLlMofbsWKQ4k
KPQ7zw=">AB6nicdZDNTgIxFIX
v4B/iH+rSTSPRuCIzqAgrSdi4xCh
gAhPSKR1o6HQmbceETHgENy406NaX
8DXc+TZ2QBM1epImX865N73ehFn
Stv2u5VZWFxaXsmu5tbWNza38ts7
LRXGktAmCXkobzysKGeCNjXTnN5E
kuLA47Ttjep3r6lUrFQXOtxRN0AD
wTzGcHaWFf13nEvX7CLtlG5jFJwK
rZjoFqtlEpV5Mwi2y6cv05TPTV6+
bduPyRxQIUmHCvVcexIuwmWmhFOJ
7lurGiEyQgPaMegwAFVbjIbdYIOjN
NHfijNExrN3O8dCQ6UGgeqQywHq
rfWr+lXVi7VfchIko1lSQ+Ud+zJ
EOUbo36jNJieZjA5hIZmZFZIglJt
pcJ2eO8LUp+h9apaJTLp5enhRqhzB
XFvZgH47AgTOowQU0oAkEBnAHD/B
ocevemlrP89KM9dmzCz9kvXwAMe6
SJw=</latexit> C3
79vNV8+3eSpE97mGD9GQ=">AB6nicdZDNTgIxFIXv4B/iH+rSTSPRu
CIzBFWkrBxiVHABCakUzrQ0OlM2o4JmfAIblxo0K0v4Wu4823sgCZq9C
RNvpxzb3rv9SLOlLbtdyuztLyupZdz21sbm3v5Hf32iqMJaEtEvJQ3n
hYUc4EbWmOb2JMWBx2nHGzfSvHNLpWKhuNaTiLoBHgrmM4K1sa4a/XI
/X7CLtlGlglJwqrZjoFarlko15Mwj2y6cv85SPTX7+bfeICRxQIUmHCv
VdexIuwmWmhFOp7lerGiEyRgPadegwAFVbjIfdYqOjDNAfijNExrN3e8d
CQ6UmgSeqQywHqnfWr+lXVj7VfdhIko1lSQxUd+zJEOUbo3GjBJieYT
A5hIZmZFZIQlJtpcJ2eO8LUp+h/apaJTKZ5elgv1Y1goCwdwCfgwBnU4
QKa0AICQ7iDB3i0uHVvzaznRWnG+uzZhx+yXj4AM3KSKA=</latexit
> C4
S2Rhx4ACf8n6z+Nm2lqc=">AB/nicbVDLSgMxFM3UV62vUXHlJlgUF
1Jmiq+dBTcuK9gHtGXIpHfa0ExmSDJCGQr+hu7cuFDErf6GO/GTNuFVg
8EDufcw705fsyZ0o7zZeXm5hcWl/LhZXVtfUNe3OrqJEUqjRiEey6R
MFnAmoaY5NGMJPQ5NPzBZeY3bkEqFokbPYyhE5KeYAGjRBvJs3faiei
CzOIpeOVR+wgHnuvZRafkjIH/EndKihcf9xkeqp792e5GNAlBaMqJUi3
XiXUnJVIzymFUaCcKYkIHpActQwUJQXS8fkjvG+ULg4iaZ7QeKz+TKQk
VGoY+mYyJLqvZr1M/M9rJTo476RMxIkGQSeLgoRjHeGsC9xlEqjmQ0MI
lczcimfSEK1axgSnBnv/yX1Msl97R0cn1crBygCfJoF+2hQ+SiM1RBV
6iKaoiFD2iZ/Ri3VlP1qv1NhnNWdPMNvoF6/0boPuZqA=</latexit
> e2 f1
e2 f2
dJIDjzNtlKnlc2TnuOA=">AB/nicbVDLSgMxFM3UV62vUXHlJlgUF
1JmpD52Fty4rGAf0JYhk95pQzOZIckIZSj4G7pz40IRt/ob7vwbM20XWj
0QOJxzD/fm+DFnSjvOl5Wbm19YXMovF1ZW19Y37M2tuoSaFGIx7Jpk
8UcCagpnm0IwlkNDn0PAHl5nfuAWpWCRu9DCGTkh6gWMEm0kz95pJ6I
LMoun4JVH7SMceK5nF52SMwb+S9wpKV583Gd4qHr2Z7sb0SQEoSknSrV
cJ9adlEjNKIdRoZ0oiAkdkB60DBUkBNVJx+eP8L5RujiIpHlC47H6M5GS
UKlh6JvJkOi+mvUy8T+vlejgvJMyEScaBJ0sChKOdYSzLnCXSaCaDw0h
VDJzK6Z9IgnVprGCKcGd/fJfUj8uaelk+tysXKAJsijXbSHDpGLzlAFX
aEqiGKUvSIntGLdWc9Wa/W2Q0Z0z2+gXrPdvpBGZqg=</latexit
> e4 f1
e4 f4
e1 f1
e1 f3
C5
ase64="53cLKFs4t+NS8OdRN3OR
WnujoY=">AB/nicbVDLSgMxFM3
UV62vqrhyEyKCykz1tfOghuXFew
D2jJk0jtaCYzJBmhDAV/Q3duXCji
Vn/DnX9jpu1CWw8EDufcw705XsSZ
0rb9bWXm5hcWl7LuZXVtfWN/OZW
TYWxpFClIQ9lwyMKOBNQ1UxzaEQS
SOBxqHv9q9Sv34FULBS3ehBOyBdw
XxGiTaSm9pxaIDMo0n4JaGrSPsu
yU3X7CL9gh4ljgTUrj8fEjxWHzX
61OSOMAhKacKNV07Ei3EyI1oxyGu
VasICK0T7rQNFSQAFQ7GZ0/xPtG6W
A/lOYJjUfq70RCAqUGgWcmA6J7at
pLxf+8Zqz9i3bCRBRrEHS8yI851i
FOu8AdJoFqPjCEUMnMrZj2iCRUm8
ZypgRn+suzpHZcdM6KpzcnhfIBGiO
LdtEeOkQOkdldI0qIoStATekG
v1r31bL1Z7+PRjDXJbKM/sD5+AKW
Omas=</latexit> e3 f3
ase64="WDq/z8Lv5aoZGIkHZpU0B
EzDMU=">AB/nicbVDLSgMxFM3
UV62vqrhyEyKCykzatWdBTcuK9g
HtGXIpHfa0ExmSDJCGQr+hu7cuFDE
rf6GO/GTNuFth4IHM65h3tzvIgz
pW3728rMzS8sLmWXcyura+sb+c2t
mgpjSaFKQx7KhkcUcCagqpnm0Igk
kMDjUPf6V6lfvwOpWChu9SCdkC6g
vmMEm0kN7/TikUHZBpPwD0Zto6w7
5bcfMEu2iPgWeJMSOHy8yHFY8XNf
7U6IY0DEJpyolTsSPdTojUjHIY5
lqxgojQPulC01BAlDtZHT+EO8bpY
P9UJonNB6pvxMJCZQaBJ6ZDIjuqW
kvFf/zmrH2L9oJE1GsQdDxIj/mWI
c47QJ3mASq+cAQiUzt2LaI5JQbR
rLmRKc6S/Pktpx0Tkrlm5OC+UDNEY
W7aI9dIgcdI7K6BpVUBVRlKAn9IJ
erXvr2Xqz3sejGWuS2UZ/YH38AKi
Wma0=</latexit> e3 f5
z+70HIS74vO6midEhYo=">ACAXicbVDLSgMxFM3UV62vqhvBTbAoI
lJmxNfOghuXFewD2jJk0jtaCYzJBmhDHXjV+jajQtF3Il/4c6/MdN2oa
0HAodz7uHmHi/iTGnb/rYyM7Nz8wvZxdzS8srqWn59o6rCWFKo0JCHsu
4RBZwJqGimOdQjCSTwONS83mXq125BKhaKG92PoBWQjmA+o0Qbyc1vNWP
RBpnGE918AEeNA8xuI6bL9hFewg8TZwxKVx8PKR4Lv5r2Y7pHEAQlN
OlGo4dqRbCZGaUQ6DXDNWEBHaIx1oGCpIAKqVDC8Y4F2jtLEfSvOExkP1
dyIhgVL9wDOTAdFdNeml4n9eI9b+eSthIo1CDpa5Mc6xCndeA2k0A1
7xtCqGTmr5h2iSRUm9JypgRn8uRpUj0qOqfFk+vjQmkPjZBF2gH7SMHn
aESukJlVEU3aEn9IJerXvr2Xqz3kejGWuc2UR/YH3+AMO+mi8=</lat
exit> f1⇤e1
UtZdCG/27G37fxlIhx0=">ACAXicbVDLSgMxFM3UV62vqhvBTbAoI
lJmiq+dBTcuK9gHtGXIpHdqaCYzJBmhDHXjV+jajQtF3Il/4c6/MdN2oa
0HAodz7uHmHi/iTGnb/rYyM7Nz8wvZxdzS8srqWn59o6bCWFKo0pCHsu
ERBZwJqGqmOTQiCSTwONS93kXq129BKhaKa92PoB2QrmA+o0Qbyc1vtWL
RAZnGE918AEetA4xuCU3X7CL9hB4mjhjUj/eEjxWHzX61OSOMAhKa
cKNV07Ei3EyI1oxwGuVasICK0R7rQNFSQAFQ7GV4wLtG6WA/lOYJjYfq
70RCAqX6gWcmA6Jv1KSXiv95zVj7Z+2EiSjWIOhokR9zrEOc1oE7TALV
vG8IoZKZv2J6QySh2pSWMyU4kydPk1qp6JwUj6+OCuU9NEIWbaMdtI8cd
IrK6BJVUBVRdIe0At6te6tZ+vNeh+NZqxZhP9gfX5A8VCmjA=</lat
exit> f1⇤e2
ase64="let0RVDcQR8p458L1bFCl
gvM4W8=">ACAXicbVDLSsNAFJ3
UV62vqhvBzWBRKQkvncW3LisYK3
QhDCZ3ujgZBJmJkIJdeNX6NqNC0Xc
iX/hzr9x0nahrQcGDufcw517goQz
pW372yqMjU9MThWnSzOzc/ML5cWl
CxWnkKDxjyWlwFRwJmAhmaw2Ui
gUQBh2Zwc5L7zVuQisXiXHcS8CJyJ
VjIKNFG8srbiraIPN4Fvr7eAt3
W0M/q5frthVuwc8SpwBqRx/POR4r
PvlL7cd0zQCoSknSrUcO9FeRqRml
EO35KYKEkJvyBW0DBUkAuVlvQu6eN
0obRzG0jyhcU/9nchIpFQnCsxkRP
S1GvZy8T+vlerwyMuYSFINgvYXhS
nHOsZ5HbjNJFDNO4YQKpn5K6bXRB
KqTWklU4IzfPIoudipOgfV/bO9Sm0
D9VFEq2gNbSIHaIaOkV1EAU3aE
n9IJerXvr2Xqz3vujBWuQWUZ/YH3
+AMz+mjU=</latexit> f5⇤e3
ase64="rXhdWlhDhOsm/60qf6a
bGDR4E=">ACAXicbVDLSsNAFJ3
Ud31F3QhuBosiIiWxvnYKblwqWCs
0IUymNzp0MgkzE6GEuvErdO3GhSLu
xL9w5984aV1o64GBwzn3cOeMOVM
acf5skojo2PjE5NT5emZ2bl5e2Hx
QiWZpFCnCU/kZUgUcCagrpnmcJlK
IHIoRG2jwu/cQNSsUSc604KfkyuB
IsYJdpIgb3sZaIFsojnUVDm7jrb
WEIaoFdcapOD3iYuD+kcvh+X+DhN
LA/vVZCsxiEpwo1XSdVPs5kZpRD
t2ylylICW2TK2gaKkgMys97F3Txml
FaOEqkeULjnvo7kZNYqU4cmsmY6G
s16BXif14z09GBnzORZhoE7S+KMo
51gos6cItJoJp3DCFUMvNXTK+JF
Sb0sqmBHfw5GFysV196q7ZzuVo3X
UxyRaQatoA7loHx2hE3SK6oiW/S
IntGLdWc9Wa/W3+0ZP1kltAfWB/
fyeKaMw=</latexit> f3⇤e3
ase64="ftkWCV2eu7zU+Mfs3UcQN
lWrVuM=">ACAXicbVDLSgMxFM3
UV62vqhvBTbAoIlJmfO8suHFZwT6
gLUMmvVNDM5khyQhlqBu/QtduXCji
TvwLd/6NmbYLbT0QOJxzDzf3eBFn
Stv2t5WZmp6ZncvO5xYWl5ZX8qtr
VRXGkKFhjyUdY8o4ExARTPNoR5J
IHoeZ1L1K/dgtSsVBc614ErYB0B
PMZJdpIbn6jGYs2yDSe+O4h3sP95
j4G13HzBbtoD4AniTMihfOPhxSPZ
Tf/1WyHNA5AaMqJUg3HjnQrIVIzy
qGfa8YKIkK7pAMNQwUJQLWSwQV9vG
2UNvZDaZ7QeKD+TiQkUKoXeGYyIP
pGjXup+J/XiLV/1kqYiGINg4X+T
HOsRpHbjNJFDNe4YQKpn5K6Y3RB
KqTWk5U4IzfvIkqR4UnZPi8dVRobS
DhsiTbSFdpGDTlEJXaIyqiCK7tA
TekGv1r31bL1Z78PRjDXKrKM/sD5
/AMbamjE=</latexit> f3⇤e1
UtZdCG/27G37fxlIhx0=">ACAXicbVDLSgMxFM3UV62vqhvBTbAoI
lJmiq+dBTcuK9gHtGXIpHdqaCYzJBmhDHXjV+jajQtF3Il/4c6/MdN2oa
0HAodz7uHmHi/iTGnb/rYyM7Nz8wvZxdzS8srqWn59o6bCWFKo0pCHsu
ERBZwJqGqmOTQiCSTwONS93kXq129BKhaKa92PoB2QrmA+o0Qbyc1vtWL
RAZnGE918AEetA4xuCU3X7CL9hB4mjhjUj/eEjxWHzX61OSOMAhKa
cKNV07Ei3EyI1oxwGuVasICK0R7rQNFSQAFQ7GV4wLtG6WA/lOYJjYfq
70RCAqX6gWcmA6Jv1KSXiv95zVj7Z+2EiSjWIOhokR9zrEOc1oE7TALV
vG8IoZKZv2J6QySh2pSWMyU4kydPk1qp6JwUj6+OCuU9NEIWbaMdtI8cd
IrK6BJVUBVRdIe0At6te6tZ+vNeh+NZqxZhP9gfX5A8VCmjA=</lat
exit> f1⇤e2
Ln0xhIRfD61Jh1CRyrs=">ACAXicbVDLSgMxFM3UV62vqhvBTbAoI
lJmpD52Fty4rGAf0JYhk96poZnMkGSEMtSNX6FrNy4UcSf+hTv/xkzbhb
YeCBzOuYebe7yIM6Vt+9vKzMzOzS9kF3NLyura/n1jZoKY0mhSkMeyo
ZHFHAmoKqZ5tCIJDA41D3ehepX78FqVgornU/gnZAuoL5jBJtJDe/1Yp
FB2QaT3zXwQd40DrE4JbcfMEu2kPgaeKMSeH84yHFY8XNf7U6IY0DEJp
yolTsSPdTojUjHIY5FqxgojQHulC01BAlDtZHjBAO8apYP9UJonNB6q
vxMJCZTqB56ZDIi+UZNeKv7nNWPtn7UTJqJYg6CjRX7MsQ5xWgfuMAlU
874hEpm/orpDZGEalNazpTgTJ48TWpHRekeHxVKpT30AhZtI120D5y0
Ckqo0tUQVE0R16Qi/o1bq3nq03630mrHGmU30B9bnD8hKmjI=</lat
exit> f1⇤e4
Ln0xhIRfD61Jh1CRyrs=">ACAXicbVDLSgMxFM3UV62vqhvBTbAoI
lJmpD52Fty4rGAf0JYhk96poZnMkGSEMtSNX6FrNy4UcSf+hTv/xkzbhb
YeCBzOuYebe7yIM6Vt+9vKzMzOzS9kF3NLyura/n1jZoKY0mhSkMeyo
ZHFHAmoKqZ5tCIJDA41D3ehepX78FqVgornU/gnZAuoL5jBJtJDe/1Yp
FB2QaT3zXwQd40DrE4JbcfMEu2kPgaeKMSeH84yHFY8XNf7U6IY0DEJp
yolTsSPdTojUjHIY5FqxgojQHulC01BAlDtZHjBAO8apYP9UJonNB6q
vxMJCZTqB56ZDIi+UZNeKv7nNWPtn7UTJqJYg6CjRX7MsQ5xWgfuMAlU
874hEpm/orpDZGEalNazpTgTJ48TWpHRekeHxVKpT30AhZtI120D5y0
Ckqo0tUQVE0R16Qi/o1bq3nq03630mrHGmU30B9bnD8hKmjI=</lat
exit> f1⇤e4
z+70HIS74vO6midEhYo=">ACAXicbVDLSgMxFM3UV62vqhvBTbAoI
lJmxNfOghuXFewD2jJk0jtaCYzJBmhDHXjV+jajQtF3Il/4c6/MdN2oa
0HAodz7uHmHi/iTGnb/rYyM7Nz8wvZxdzS8srqWn59o6rCWFKo0JCHsu
4RBZwJqGimOdQjCSTwONS83mXq125BKhaKG92PoBWQjmA+o0Qbyc1vNWP
RBpnGE918AEeNA8xuI6bL9hFewg8TZwxKVx8PKR4Lv5r2Y7pHEAQlN
OlGo4dqRbCZGaUQ6DXDNWEBHaIx1oGCpIAKqVDC8Y4F2jtLEfSvOExkP1
dyIhgVL9wDOTAdFdNeml4n9eI9b+eSthIo1CDpa5Mc6xCndeA2k0A1
7xtCqGTmr5h2iSRUm9JypgRn8uRpUj0qOqfFk+vjQmkPjZBF2gH7SMHn
aESukJlVEU3aEn9IJerXvr2Xqz3kejGWuc2UR/YH3+AMO+mi8=</lat
exit> f1⇤e1
GD :
 sha1_base64="
7hToaXU2/3RkHg
zXjbs5uz5T2WY=
">AB6XicbZDJ
TsMwEIYnZStlK3
DkYlGxnKoEsd2o
BAeOBdFaqPKcZ
zWquNEtoNURX0DL
hxA0CtPwWtw421
w2h6g5Zcsfr/G
XlmvJgzpW3728o
tLC4tr+RXC2vrG
5tbxe2duoSWi
NRDySTQ8rypmgN
c0p81YUhx6nDa
8/nWNx6pVCwSD3
oQUzfEXcECRrA2
1v3NUadYsv2WG
genCmUrj7fM42q
neJX249IElKhCc
dKtRw71m6KpWaE
02GhnSgaY9LHXd
oyKHBIlZuOJx2i
A+P4KIikeUKjsfu
7I8WhUoPQM5Uh1
j01m2Xmf1kr0cG
lmzIRJ5oKMvkoS
DjSEcrWRj6TlGg
+MICJZGZWRHpY
qLNcQrmCM7syvN
QPyk75+Wzu9NS5
RAmysMe7MxOHAB
FbiFKtSAQABP8A
KvVt96t6s0aQ0
Z017duGPrI8fFG
uRdg=</latexi
t>
D0
ase64="S6FS4x6Tq9vT2OeYFDXM
ZaUSOo=">ACD3icdVDLSsNAFJ3
UV62vqEs3wWJxVRLxtbPgxmUF+4A
2lMnkph06mYSZiVBC/QI3LvUz3Igo
4tatO/GSduFtnrgwuGce7n3Hi9m
VCrb/jJyc/MLi0v5cLK6tr6hrm5
VZdRIgjUSMQi0fSwBEY51BRVDJqx
ABx6DBpe/zG9cgJI34lRrE4Ia4y
2lACVZa6pildsJ9EJ7ABNKb/zDsm
EW7bI9gzRJnQopnz/cZHqod87PtR
yQJgSvCsJQtx46Vm2KhKGEwLQTC
TEmfdyFlqYchyDdPTP0NrTim8Fkd
DFlTVSf06kOJRyEHq6M8SqJ6e9TP
zLayUqOHVTyuNEASfjRUHCLBVZWT
iWTwUQxQaYCKovtUiPayzUTrCg
7BmX5ltQPys5x+ejysFgpoTHyaAf
ton3koBNUQReoimqIoFv0iF7Qq3F
nPBlvxvu4NWdMZrbRLxgf30GdpGE
=</latexit> |
{z
}
Figure 5: Example of construction of D′ from D in the proof of Proposition 5.10. The
symbols “∗” stand for the necessary constants “g” used in order to obtain the
depicted blocks. D has 4 blocks and 5 cliques. Observe that neither the edge-
less singleton clique C2 nor the clique C4 —which is internal to the block B4—
intervene in the relation S1. Light gray edges depict the pairs of facts from D′
which form a solution to q5.
could be two such facts u. We arbitrarily select one of them that we denote by fR(a), and
we consider the set r = {u | ∃a ∈r′ u = fR(a)}.
First, we prove that r is a repair of D, that is: (i) it contains no two distinct facts u ∼v,
and (ii) it contains at least one fact for each block Bi.
(i) By means of contradiction, suppose r contains two facts u, v ∈r such that u ∼v. By
definition of r, u = fR(a) and v = fR(b) for some facts a, b of r′. By construction of
D′, it follows from u ∼v that a ∼b and therefore a = b since we assumed r to be a
repair. Hence, u = v.
(ii) Further, for every block Bi in D there is a R1-block in D′ whose facts have primary
key ei and one of those facts is selected in r′, which gives rise (via fR) to a fact of Bi.
Since D |= certain(q4) by hypothesis, there are u, v ∈r such that D |= q4(uv), let us
show that this implies r′ |= q5:
• If u = v then, by definition of r, we have uR1 ∈r′. Since uu
S1 belongs to a singleton
S1-block of D′, it is in every repair of D′, and thus r′ |= q5(uR1uu
S1) as desired.
• If u̸ = v then, by definition of r, we have uR1, vR1 ∈r′, and {uv
S1, vu
S1} form a S1-block of
D′. Hence, r′ contains one of {uv
S1, vu
S1}. If uv
S1 ∈r′ we have r′ |= q5(uR1uv
S1); otherwise,
if vu
S1 ∈r′, we have r′ |= q5(vR1vu
S1).
This concludes the proof for item (1).
(2) Fix some k ≥2. Let ∆+
k(q4, D, i) and ∆k(q5, D′, i) be the sets computed at step i of
Cert+
k(q4) and Certk(q5) respectively. First we prove the following claim.

---

Vol. 21:1
A SIMPLE ALGORITHM FOR CQA UNDER PRIMARY KEYS
18:27
uR1
vR1
wR1
uv
S1 vu
S1
vw
S1
wv
S1
wu
S1
uw
S1
. . .
. . .
. . .
ase64="86ytEAtqfYtkEnikKd8Re
1inZrs=">AB6HicbZDJTgJBEIZ
rcEPcUI9eOhKNJzJj3G6SePEIiSw
JTEhPUwMtPUu6ezSE8ARePGgMHn0L
X8Ob2MPcFDwTzr58v9V6aryYsGV
tu1vK7O0vLK6l3PbWxube/kd/dq
KkokwyqLRCQbHlUoeIhVzbXARiyR
Bp7Aute/SfP6A0rFo/BOD2J0A9oNu
c8Z1caqPLbzBbtoT0QWwZlB4fpzn
Oq93M5/tToRSwIMNRNUqaZjx9odU
qk5EzjKtRKFMWV92sWmwZAGqNzhZ
NAROTJOh/iRNC/UZOL+7hjSQKlB4J
nKgOqems9S87+smWj/yh3yME40hm
z6kZ8IoiOSbk06XCLTYmCAMsnNrI
T1qKRMm9vkzBGc+ZUXoXZadC6K5
WzQukYpsrCARzCThwCSW4hTJUgQH
CE7zAq3VvPVtv1nhamrFmPfvwR9b
HDwFzkXg=</latexit> w
uR1
vR1
wR1
uv
S1 vu
S1
wu
S1
uw
S1
. . .
. . .
ase64="ZBr+UErLT2e/V6XHG6TQE
NZFE5o=">AB6HicbZDLSsNAFIZ
P6q3W9Wlm2BRXJVEvO0suHZgr1
AG8pketKOnUzCzEQoU/gxoUidelb
+BrufBsnrQt/WHg4/PYc45fsyZ
0o7zZeWldW1/LrhY3Nre2d4u5e
Q0WJpFinEY9kycKORNY10xzbMUS
SehzbPrDmyxvPqBULBJ3ehSjF5K+Y
AGjRBurlnSLJafsTGUvgvsDpeuPS
a3arf42elFNAlRaMqJUm3XibWXE
qkZ5TgudBKFMaFD0se2QUFCVF46H
XRsHxmnZweRNE9oe+r+7khJqNQo9E
1lSPRAzWeZ+V/WTnRw5aVMxIlGQW
cfBQm3dWRnW9s9JpFqPjJAqGRmVp
sOiCRUm9sUzBHc+ZUXoXFadi/K57
WzUuUYZsrDARzCbhwCRW4hSrUgQL
CIzDi3VvPVmv1mRWmrN+evbhj6z
3b/5ckXY=</latexit> u
ase64="ARqU0ZKx4M7N1rYZoZnA/
kWu1u8=">AB6HicbZDJTgJBEIZ
rcEPcUI9eOhKNJzJj3G6SePEIiSw
JTEhPUwMtPUu6e0gI4Qm8eNAYPoW
voY38Ye4KDgn3Ty5f+r0lXlxYIr
bdvfVmZldW19I7uZ29re2d3L7x/U
VJRIhlUWiUg2PKpQ8BCrmuBjVgi
DTyBda9/l+b1AUrFo/BD2N0A9oNu
c8Z1caqDNr5gl20pyL4MyhcPs5S
fVebue/Wp2IJQGmgmqVNOxY+2Oq
NScCRznWonCmLI+7WLTYEgDVO5oO
uiYnBinQ/xImhdqMnV/d4xoNQw8E
xlQHVPLWap+V/WTLR/454GCcaQz
b7yE8E0RFJtyYdLpFpMTRAmeRmVs
J6VFKmzW1y5gjO4srLUDsvOlfFy8
pFoXQKM2XhCI7hDBy4hLcQxmqwAD
hCV7g1Xq0nq03azIrzVjznkP4I+v
jB/gkXc=</latexit> v
ase64="ZBr+UErLT2e/V6XHG6TQE
NZFE5o=">AB6HicbZDLSsNAFIZ
P6q3W9Wlm2BRXJVEvO0suHZgr1
AG8pketKOnUzCzEQoU/gxoUidelb
+BrufBsnrQt/WHg4/PYc45fsyZ
0o7zZeWldW1/LrhY3Nre2d4u5e
Q0WJpFinEY9kycKORNY10xzbMUS
SehzbPrDmyxvPqBULBJ3ehSjF5K+Y
AGjRBurlnSLJafsTGUvgvsDpeuPS
a3arf42elFNAlRaMqJUm3XibWXE
qkZ5TgudBKFMaFD0se2QUFCVF46H
XRsHxmnZweRNE9oe+r+7khJqNQo9E
1lSPRAzWeZ+V/WTnRw5aVMxIlGQW
cfBQm3dWRnW9s9JpFqPjJAqGRmVp
sOiCRUm9sUzBHc+ZUXoXFadi/K57
WzUuUYZsrDARzCbhwCRW4hSrUgQL
CIzDi3VvPVmv1mRWmrN+evbhj6z
3b/5ckXY=</latexit> u
ase64="/huARia+UH0KQneywuA71
VAG5SA=">AB6nicbZDLTgIxFIb
P4A3xhrp0g0rsiMwcvGSOLGJUa
5JDAhndKBhk5n0nYwZMIjuHGhQbe+
hK/hzrexAywU/JMmX/7/nPSc40Wc
KW3b31ZmaXldS27ntvY3Nreye/u
1VQYS0KrJOShbHhYUc4ErWqmOW1E
kuLA47Tu9W/SvD6gUrFQPOhRN0Ad
wXzGcHaWPeDq8d2vmAX7YnQIjgzK
Fx/jlO9Vdr5r1YnJHFAhSYcK9V07
Ei7CZaEU5HuVasaIRJH3dp06DA
VuMhl1hI6M0F+KM0TGk3c3x0JDp
QaBp6pDLDuqfksNf/LmrH2L92EiS
jWVJDpR37MkQ5RujfqMEmJ5kMDmE
hmZkWkhyUm2lwnZ47gzK+8CLXTon
NePLsrFcrHMFUWDuAQTsCBCyjDLVS
gCgS68AQv8Gpx69kaW+/T0ow169m
HP7I+fgBbwZI/</latexit> v = w
w
ase64="ZBr+UErLT2e/V6XHG6TQE
NZFE5o=">AB6HicbZDLSsNAFIZ
P6q3W9Wlm2BRXJVEvO0suHZgr1
AG8pketKOnUzCzEQoU/gxoUidelb
+BrufBsnrQt/WHg4/PYc45fsyZ
0o7zZeWldW1/LrhY3Nre2d4u5e
Q0WJpFinEY9kycKORNY10xzbMUS
SehzbPrDmyxvPqBULBJ3ehSjF5K+Y
AGjRBurlnSLJafsTGUvgvsDpeuPS
a3arf42elFNAlRaMqJUm3XibWXE
qkZ5TgudBKFMaFD0se2QUFCVF46H
XRsHxmnZweRNE9oe+r+7khJqNQo9E
1lSPRAzWeZ+V/WTnRw5aVMxIlGQW
cfBQm3dWRnW9s9JpFqPjJAqGRmVp
sOiCRUm9sUzBHc+ZUXoXFadi/K57
WzUuUYZsrDARzCbhwCRW4hSrUgQL
CIzDi3VvPVmv1mRWmrN+evbhj6z
3b/5ckXY=</latexit> u
v
=
SYk4ldGyAlLo0EQlEq5Q=">AB6HicbZDJSgNBEIZr4hbjFvXopTEon
sKMuF3EgBePCZgFkiH0dGqSNj0L3T1CHkCLx4UiUfwtfw5tvYk+SgiT
80fPx/FV1VXiy40rb9bWldW17LruY3Nre2d/O5eTUWJZFhlkYhkw6
MKBQ+xqrkW2Igl0sATWPf6t2lef0SpeBTe60GMbkC7Ifc5o9pYlet2vmA
X7YnIjgzKNx8jlO9l9v5r1YnYkmAoWaCKtV07Fi7Qyo1ZwJHuVaiMKa
sT7vYNBjSAJU7nAw6IkfG6RA/kuaFmkzc3x1DGig1CDxTGVDdU/NZav6X
NRPtX7lDHsaJxpBNP/ITQXRE0q1Jh0tkWgwMUCa5mZWwHpWUaXObnDmC
M7/yItROi85F8bxyVigdw1RZOIBDOAEHLqEd1CGKjBAeIXeLUerGfrz
RpPSzPWrGcf/sj6+AGpfJE+</latexit> =
=
uR1
vR1
wR1
uv
S1 vu
S1
wu
S1
uw
S1
. . .
. . .
. . .
or
or
Figure 6: Schema for proof of Claim 5.11.
Claim 5.11. Let u, v, w be facts of D in the same clique of the solution graph GD. Possibly
v ∼w or v = w but we assume u̸ ∼v and u̸ ∼w. In particular D |= q4(uv) ∨q4(vu). Then
for every k-set S over D′ if S ∪{uv
S1} ∈∆k(q5, D′, i) then S ∪{vR1} ∈∆k(q5, D′, i + 1) and
S ∪{wR1} ∈∆k(q5, D′, i + 1).
Note that in the case where vR1 ∈S the claim implies S ∈∆k(q5, D′, i + 1). Similarly
for wR1.
Proof of Claim 5.11. We assume that D |= q4(uv), since the case where D |= q4(vu) is
symmetric. To facilitate the understanding of the following proof, refer to Figure 6.
Assume S ∪{uv
S1} ∈∆k(q5, D′, i). If S ∈∆k(q5, D′, i) then the conclusion is immediate
since S ∪{u} ∈∆k(q5, D′, i) for every fact u such that S ∪{u} is a k-set. So, let us assume
S̸ ∈∆k(q5, D′, i).
• The base case i = 0 implies S ∪{uv
S1} ∈∆k(q5, D′, 0) and S̸ ∈∆k(q5, D′, 0). This can only
happen if uR1 ∈S, since {uv
S1, uR1} is the only q5-solution of D′ involving uv
S1. Let B be
the block B = {uv
S1, vu
S1}. Since {uR1, uv
S1} and {vu
S1, vR1} are q5-solutions (cf. Figure 6), a

---

18:28
D. Figueira, A. Padmanabha, L. Segoufin, and C. Sirangelo
Vol. 21:1
simple analysis shows that the block B is a witness for S ∪{vR1} ∈∆k(q5, D′, 1). Similarly
the block B′ = {uw
S1, wu
S1} witnesses the fact that S ∪{wR1} ∈∆k(q5, D′, 1).
• For the induction step, suppose S ∪{uv
S1} ∈∆k(q5, D′, i) and i > 0. As i > 0, let B be
the block of D′ used as the witness. By definition, for all fact b ∈B, there is a subset Sb of
S such that Sb ∪{uv
S1, b} ∈∆k(q5, D′, i −1). By induction this implies that for all b ∈B,
Sb ∪{vR1, b} ∈∆k(q5, D′, i). Hence B witnesses the fact that S ∪{vR1} ∈∆k(q5, D′, i+1),
as desired. The proof that S ∪{wR1} ∈∆k(q5, D′, i + 1) is similar.
With Claim 5.11 in place, assume that D′ |= Certk(q5) and let us show D |= Cert+
k(q4).
Let S be a k-set of D′. Let ˜S be any k-set of D containing every fact u such that either
uR1 ∈S or vu
S1 ∈S for some fact v.
We will prove, by induction on i, that if S ∈∆k(q5, D′, i) then ˜S ∈∆+
k(q4, d, i + 1)
(hence, in particular, D′ |= Certk(q5) implies D |= Cert+
k(q4), concluding the proof of (2)).
• For the base case i = 0, if S ∈∆k(q5, D′, 0) then it contains a solution to q5 of the
form uR1uv
S1 for some facts u, v of D. By construction D |= q4(uv) and u, v ∈˜S. Hence
˜S ∈∆+
k(q4, d, 0).
• For the induction step, assume S ∈∆k(q5, D′, i) as witnessed by a block B′ of D′.
– If B′ is an R1-block then the block ˜B = {u | uR1 ∈B′} is a witness for ˜S ∈∆+
k(q4, D, i).
– If B′ is an S1-block of the form {uv
S1, vu
S1}. Set w to the third fact in the clique of u, v
in the solution graph GD (set w = v if the clique has size two). From Claim 5.11 we
get that each of S ∪{uR1}, S ∪{vR1}, S ∪{wR1} contains a k-set in ∆k(q5, D′, i −1).
Hence, by induction each of ˜S ∪{u}, ˜S ∪{v}, ˜S ∪{w} contains a k-set in ∆+
k(q4, D, i).
Hence, by ∆+
k’s second derivation rule on the fact u, ˜S ∈∆+
k(q4, D, i + 1).
– It remains to consider the case where B′ is an S1-block of the form {uu
S1}. But then u
is a self-loop and is contained in ˜S. By definition we then have ˜S ∈∆+
k(q4, D, 0).
Theorem 5.12. certain(q5) cannot be computed by Certk(q5), for any choice of k.
Proof. By means of contradiction, assume that certain(q5) is equivalent to Certk(q5) for some
k ≥2. We show that this implies that certain(q4) is equivalent to Cert+
k(q4), contradicting
Theorem 5.1.
It is enough to show that if a database D is such that D |= certain(q4) then D |=
Cert+
k(q4).
To this end, assume D is a database such that D |= certain(q4).
Let D′
be the database constructed from D given by Proposition 5.10. As D |= certain(q4), we
get from Proposition 5.10-(1) that D′ |= certain(q5). From our hypothesis it follows that
D′ |= Certk(q5). By Proposition 5.10-(2) this implies that D |= Cert+
k(q4) as desired.
5.3. The case of all self-join-free queries falsifying PCond: coNP-hardness.
We
describe in this section techniques from [KW17], together with their immediate consequence:
certain(q) is coNP-hard as soon as q̸ |= PCond. We build on the dichotomy result of [KW17]
based on their notion of an “attack graph”. First we recall this notion using our notation.
Let q be a query, let Γ be a set of primary key constraints. Given an atom A of q let
A+ ˆ= {B atom of q | there exists a Γ-derivation X B1 . . . Bn
where X = key(A), Bn = B, and for all i, Bi̸ = A}

---

Vol. 21:1
A SIMPLE ALGORITHM FOR CQA UNDER PRIMARY KEYS
18:29
Let vars(A+) = S
B∈A+ vars(B). Given two atoms A and B of q we say that A attacks
B if there exists a sequence F0, F1, . . . , Fn of atoms of q and x1, x2, . . . , xn of variables not
in vars(A+) such that A = F0, B = Fn and for all i > 0, xi is a variable occurring both in
Fi−1 and Fi. The attack from A to B is said to be weak if B is Γ-determined by A. The
attack graph of q and Γ is the graph whose vertices are the atoms of q and whose edges are
the attacks. A cycle in this graph is weak if all the attacks involved are weak, otherwise it is
a strong cycle.
The dichotomy result of [KW17] can be stated as:
Theorem 5.13 [KW17, Theorem 3.2]. Let q be a self-join-free query and Γ a set of primary
key constraints. If every cycle in the attack graph of q and Γ is weak, then certain(q) can be
computed in polynomial time; otherwise certain(q) is coNP-complete.
We prove that if the attack graph of q and Γ contains only weak cycles, then PCond
holds. It then follows from Theorem 5.13 then whenever q̸ |= PCond then certain(q) is
coNP-hard as desired:
Theorem 5.14. Assume q is a self-join-free query and Γ a set of primary key constraints.
If q̸ |= PCond, then certain(q) is coNP-hard.
In view of Theorem 5.13, the proof of Theorem 5.14 is an immediate consequence of the
following lemma.
Lemma 5.15. Assume q is a self-join-free query and Γ a set of primary key constraints. If
the attack graph of q and Γ contains only weak cycles then q |= PCond.
Proof. Let X be the set of all the strongly connected components of the attack graph of q
and Γ. We define the core graph of q and Γ as the directed graph whose vertices are the
elements of X and there is an edge from S to S′ if S contains an atom A attacking an atom
B of S′. Note that, by definition, a core graph is always acyclic. Let τ be any topological
ordering of this graph, that is, τ = S1, . . . , Sn is an ordering on X, and for every i, j, if
there is an edge from Si to Sj in the core graph, then i < j. Note that since the attack
graph contains only weak cycles, any two facts belonging to the same strongly connected
component are mutually Γ-determined. Hence, every S ∈X is a stable set. In particular τ
is a Γ-sequence. We claim that q |= PCondτ.
To prove q |= PCondτ, we need to show that q |= PCondτ(i) for every i < n. So, fix
some i and consider an arbitrary atom A of Si+1. Let D be some database with repair r
such that r |= q(¯αa¯β), where a matches A and ¯α matches S≤i. Let µ be the valuation of
the variables of q witnessing the solution ¯αa¯β. By abuse of notation, for each atom B of q,
we write µ(B) to denote the fact of the database witnessing the solution for the relation
symbol of B. In particular, a = µ(A).
Let a′ ∼a, r′ = r[a →a′], and assume that r′ |= q(¯α′a′ ¯β′) as witnessed by the valuation
µ′. We need to show that r′ |= q(¯αa′¯δ) for some ¯δ. Notice that the hypotheses of Lemma 4.1
are satisfied by r, r′, µ, µ′ and there is a Γ-derivation from X = key(A) to every atom in
A+. Hence, from Lemma 4.1 it follows that
for any variable x ∈vars(A+) we have µ(x) = µ′(x).
(†)
To show r′ |= q(¯αa′¯δ), we define a satisfying valuation ν as follows: If x is a variable
occurring in an atom B̸ = A that is not attacked by A, then set ν(x) = µ(x); otherwise, set
ν(x) = µ′(x). We show that ν witnesses the solution ¯αa′¯δ in r′.

---

18:30
D. Figueira, A. Padmanabha, L. Segoufin, and C. Sirangelo
Vol. 21:1
For this it suffices to show that for all atom B of q, ν(B) is a fact of r′. If B is different
from A and not attacked by A then this is clear as ν(B) = µ(B) and µ(B) belongs to both
r and r′. If B is A or attacked by A then we show that ν(B) = µ′(B). To see this consider
a variable x occurring in B such that ν(x) = µ(x). By definition of ν, this is because x
also belongs to some atom C that is not attacked by A. Hence, by definition of attack, this
implies that x ∈vars(A+). By (†) this implies that µ(x) = µ′(x) as desired.
5.4. The case of all self-join-free queries falsifying PCond: Certk fails.
We finally reduce the case of q5 to any arbitrary query falsifying PCond. Let q be a
self-join-free query such that q̸ |= PCond. We show that for all k, if certain(q) is equivalent
to Certk(q) then certain(q5) is equivalent to Certk(q5), a contradiction with Theorem 5.12.
The following is the analog of Proposition 5.10.
Proposition 5.16. For every database D over the signature of q5 we can construct a
database D′ over the signature of q such that:
(1) if D |= certain(q5) then D′ |= certain(q);
(2) For every k ≥2, if D′ |= Certk(q) then D |= Certk(q5).
Proof. The construction of D′ from D is actually taken from [KW17, proof of Theorem 6.1].
Since q̸ |= PCond, it follows from Theorem 5.14 that the attack graph of q contains a strong
cycle. Then the following result follows from [KW17, proof of Theorem 6.1].
Claim 5.17 [KW17, proof of Theorem 6.1]. Let q be a self-join-free query such that the
attack graph of q contains a strong cycle. Then q contains two atoms A1 and A2 such that
for every database D over the signature of q5 there is a database D′ over the signature of q
and functions f and g such that:
(i) If D |= certain(q5), then D′ |= certain(q).
(ii) f is a bijection from the R1-facts of D to the A1-facts of D′ such that u ∼v iff
f(u) ∼f(v).
(iii) g is a function that maps a pair of the form (C, u) where C is an atom of q such that
C̸ = A1 and u is an S1-fact of D to a C-fact of D′ such that:
(a) {u 7→v | g(A2, u) = v} is a bijection from S1-facts to A2-facts such that u ∼v iff
g(A2, u) ∼g(A2, v);
(b) for every atom C̸ ∈{A1, A2} and S1-fact u in D the block of g(C, u) contains
only one fact in D′.
(iv) If f(u) and g(A2, v) are part of a solution to q in D′ then D |= q5(uv).
Given a database D over the signature of q5, let D′ be the database constructed in
Claim 5.17. Note that Claim 5.17-(i) already proves our first item (1). It remains to show
that if D′ |= Certk(q) then D |= Certk(q5).
For any k-set S, let ˆS = {u | f(u) ∈S} ∪{v | g(A2, v) ∈S}.
We show that if
S ∈∆k(q, D′, i) then ˆS ∈∆k(q5, D, i), by induction on i.
For i = 0, S contains necessarily a solution to q and therefore an A1-fact u′ and an
A2-fact v′. Let u and v be such that v′ = g(A2, v) and u′ = f(u). By construction of ˆS,
both u and v are in ˆS. By Claim 5.17-(iv) this implies that D |= q5(uv) and therefore
ˆS ∈∆k(q5, D, 0).
For the induction step, let B′ be the block witnessing the membership of S into
∆k(q, D′, i).

---

Vol. 21:1
A SIMPLE ALGORITHM FOR CQA UNDER PRIMARY KEYS
18:31
• Assume first that B′ is a A1-block. Let B = {u | f(u) ∈B′}. By Claim 5.17-(ii) B
is a block of D. Moreover, it witnesses the membership of ˆS in ∆k(q5, D, i). Indeed,
consider an element b ∈B. Let b′ = f(b). By hypothesis, S ∪{b′} contains a k-set T
in ∆k(q, D′, i −1). By induction ˆT ∈∆k(q5, D, i −1) and ˆT is a subset of ˆS ∪{b}. The
result follows.
• Assume now that B′ is a A2-block. We conclude as above using B = {v | g(A2, v) ∈B′}
and Claim 5.17-(iii)-(a).
• Finally, if B′ is a C-block for some atom C̸ ∈{A1, A2}, then B′ contains only one element
by Claim 5.17-(iii)-(b). Therefore, S was actually in ∆k(q, D′, i −1) and we can conclude
by induction hypothesis.
Theorem 5.18. Let q be a self-join-free query such that q̸ |= PCond. Then certain(q) cannot
be computed by Certk(q), for any choice of k.
The proof of Theorem 5.18 is identical to the proof of Theorem 5.12 using Proposition 5.16
instead of Proposition 5.10.
6. Path queries
The dichotomy conjecture has also been shown to hold for path queries [KOW21]. In this
section we show that the Certk algorithm works for PTime solvable path queries and if
Certk does not compute certain(q) for k = |q| then the problem is coNP-hard.
For this section, assume that the relational signature σ contains only symbols of arity
two and that the set Γ of constraints assigns to each symbol R of σ its first component
as the primary key. Recall that a path query is a Boolean conjunctive query of the form
R1(x1 x2)∧R2(x2 x3)∧R3(x3 x4)∧· · ·∧Rn(xnxn+1) that may contain self-join, i.e., Ri = Rj
for some i̸ = j. Note that a path query can be described by a word over the alphabet
of relation names of σ (e.g., the word describing q as R1 · · · Rn). For simplicity, we will
henceforth blur the distinction between path queries and words over σ.
Following [KOW21] we define the language L↬(q) as the regular language defined by
the following finite state automaton Aq with ε-transitions4 (we use s, t, . . . to denote words
over σ). The set of states of Aq is the set of all prefixes of q, including the empty prefix ε,
which is the initial state. There is only one accepting state, which is q. There is a transition
reading R from state s to the state sR. Moreover, there is an ε-transition in Aq from any
state sR to any state tR such that tR is a prefix of s.
We say that the query q satisfies FactorCond and write q |= FactorCond if q is a factor
of all the words in the language L↬(q).
The dichotomy result of [KOW21] can be formulated as follows5:
Theorem 6.1 [KOW21, Theorem 3.2]. Let q be a path query. If q |= FactorCond, then
certain(q) can be evaluated in PTime; otherwise, certain(q) is coNP-complete.
Thus, certain(q′
2) and certain(q′
3) for the queries described in Example 2.2 are in PTime
and coNP-complete respectively (refer to [KOW21] for detailed explanation). As in the
self-join-free case we will show that, for path queries, there is some k such that Certk(q)
4An ε-transition in an automata makes a transition from one state to the other without reading any
symbol.
5[KOW21] provides a much finer ‘tetrachotomy’ between FO, NL-complete, PTime-complete and coNP-
complete. In this section we restrict our attention to the dichotomy between PTime and coNP-complete.

---

18:32
D. Figueira, A. Padmanabha, L. Segoufin, and C. Sirangelo
Vol. 21:1
captures certain(q) iff q |= FactorCond. In view of Theorem 6.1 this implies that when
Certk(q) fails to capture certain(q), then certain(q) is coNP-complete.
6.1. Tractable path queries. In this section we show the first part of our result: if the
path query q satisfies FactorCond, then certain(q) can be computed via Certk.
Theorem 6.2. Let q be a path query of length k. If q |= FactorCond, then certain(q) =
Certk(q).
The rest of this section is devoted to the proof of Theorem 6.2. We will make use of the
following fixpoint computation introduced by [KOW21, Fig. 5]. For a fixed path query q
and database D, let N(q, D) be the set of pairs of the form ⟨c, s⟩, where c ∈adom(D) and s
is a prefix of q, computed via the following fixpoint algorithm.
Initialization Step: N(q, D) ←{⟨c, q⟩| c ∈adom(D)}
Iterative Step: If s is a prefix of q, add ⟨c, s⟩to N(q, D) if one of the following holds:
(1) sR is a prefix of q and there is a fact R(c a) of D such that for every fact R(c b)
of D we have ⟨b, sR⟩∈N(q, D);
(2) There is an ε-transition from s to t in Aq and there is a fact R(c a) of D such
that for every fact R(c b) of D we have ⟨b, tR⟩∈N(q, D).
Let N(q) be the set of all databases D such that there exists c ∈adom(D) with
⟨c, ε⟩∈N(q, D).
Lemma 6.3 [KOW21, (proof of) Lemma 6.4]. For every path query q, if q |= FactorCond,
then certain(q) = N(q).
In view of Lemma 6.3, Theorem 6.2 is a direct consequence of the following proposition.
Proposition 6.4. For every path query q of length k such that q |= FactorCond, we have
N(q) = Certk(q).
Note that Certk(q) ⊆N(q) follows from Certk(q) ⊆certain(q) (Proposition 3.1) combined
with certain(q) = N(q) (Lemma 6.3). So we are left with proving N(q) ⊆Certk(q). Let
D ∈N(q). We will prove that D ∈Certk(q).
For all l ≥0 let sl be the prefix of q of length l (i.e., s0 = ε and sk = q).
For
every database D and fact u = R(a b) in D, let us define trace(u) ˆ= R, key(u) = a, and
last(u) = b. For a sequence of (possibly repeating) facts Π = u1, . . . , ul of a database D, we
define trace(Π) ˆ= trace(u1) · · · trace(ul) ∈σ∗and, if Π is not the empty sequence, we define
last(Π) ˆ= last(ul). Also we let SΠ = {u1, . . . , ul} be the set of facts in the sequence. Further,
Π is called a valid path if the following conditions hold:
(i) SΠ is a partial repair of D,
(ii) for all i < l we have last(ui) = key(ui+1), and
(iii) trace(Π) is a prefix of q.
In particular, for any valid path Π of length l, we have trace(Π) = sl. Moreover, for any
prefix sL of q we write trace(Π) ≈sL if there exists a run of the automaton Aq on trace(Π)
ending in state sL.
For any D ∈N(q), let N(q, D, i) and ∆k(q, D, i) be the fixpoint computations of N(q, D)
and ∆k(q, D) at step i respectively. To prove that D ∈Certk(q), we will use the following
claim:

---

Vol. 21:1
A SIMPLE ALGORITHM FOR CQA UNDER PRIMARY KEYS
18:33
Claim 6.5. For all i ≥0, For c ∈adom(D) and for all non-empty prefix sl of q if
⟨c, sl⟩∈N(q, D, i) then for all non-empty valid path Π where last(Π) = c and trace(Π) ≈sl,
we have SΠ ∈∆k(q, D, i).
Let us show that the claim implies D ∈Certk(q). As D ∈N(q), there exists c ∈adom(D)
such that ⟨c, ε⟩∈N(q, D, m) for some step m. But note that ⟨c, ε⟩∈N(q, D, m) can only
be produced by application of Rule 1 in the Iteration step (Rule 2 is not possible since
ε-transitions do not start at the state ε). This implies that if R is the first relation occurring
in q then there exists a fact of the form R(c a) and for all facts of the form R(c b) in D we
have ⟨b, R⟩∈N(q, D, m −1). For each such b we can apply the claim with the valid path
Π = R(c b), obtaining R(c b) ∈∆k(q, D, m −1) for every R(c b). Hence, ∅∈∆k(q, D, m)
which implies D ∈Certk(q).
The proof of the claim will make use of the following consequence of q |= FactorCond.
Lemma 6.6. Let q be a path query such that q |= FactorCond. Then for any prefix of
q of the form s1PRs2PR′ where s1, s2 ∈σ∗and R̸ = R′, we have that s1P is a suffix of
s1PRs2P.
Proof. Assume q = s1PRs2PR′t and consider the word w = s1PRs2PRs2PR′t. A simple
observation shows that w ∈L↬(q). Hence, by hypothesis, w contains q as factor. Let w(i)
denote the symbol of σ occurring at the i-th position of w, for any 1 ≤i ≤|w|. Note that
by definition of w, for all positions l such that |s1| < l ≤|s1| + |s2| + 3 we have:
w(l) = w(l + |s2| + 2)
(⋆)
Let w(i), w(i + 1), . . . , w(i + n −1) be the factor of w that matches q, and observe that
1 ≤i ≤|w|−|q|+1 = |s2|+3. If q is a suffix of w, it follows that s1P is a suffix of s1PRs2P and
we are done. If q is not a suffix of w, then i < |s2| + 3. Observe that w((i−1) +|s1PR|) = R
and w((i −1) + |s1PRs2PR′|) = R′. Hence, setting l = (i −1) + |s1PR| ≤|s1| + |s2| + 3,
we have w(l) = R and w(l + |s2| + 2) = R′. But then by (⋆) we would obtain R = R′, which
is in contradiction with our hypothesis.
Proof of Claim 6.5. The proof is by induction on i. For the base case i = 0, we have
N(q, D, 0) = {⟨c, q⟩: c ∈adom(D)}. Note that Aq has no ε-transitions from a prefix of q to
q. Hence, for any valid path Π = u1, . . . , ul such that trace(Π) ≈q we must have k = l and
trace(Π) = q. In this case (u1, . . . , ul) forms a solution to q and hence SΠ ∈∆k(q, D, 0).
For the induction step, let Π = u1, . . . , ul be any valid path such that trace(Π) ≈sL
and last(ul) = c. Assuming ⟨c, sL⟩∈N(q, D, i + 1), we will prove SΠ ∈∆k(q, D, i + 1). If
⟨c, sL⟩∈N(q, D, i) then by induction hypothesis we have SΠ ∈∆k(q, D, i) and we are done
since ∆k(q, D, i) ⊆∆k(q, D, i + 1). So assume that ⟨c, sL⟩is newly added into N(q, D, i + 1).
By definition of the iterative step (regardless of which rule is applied), there is a state
s′, a partial run of Aq from state sL to state s′ reading R ∈σ, and a fact R(c a) of D such
that for every fact R(c b) of D we have ⟨b, s′⟩∈N(q, D, i).
Let sl = trace(Π). Since Π ≈sL, there is a run of Aq on trace(Π) that ends at sL. We
consider three cases depending on the successor of sl in q.
(1) Case sl = q. This case is similar to the base case. Since (u1, . . . , ul) forms a solution to
q, we have SΠ ∈∆k(q, D, 0) ⊆∆k(q, D, i + 1).
(2) Case sl+1 = slR.
Note that if there is already a fact of the form ui = R(c b) in Π then the new path
Π′ = u1, u2, . . . , ul, ui is also a valid path where last(Π′) = b. Otherwise, for every fact

---

18:34
D. Figueira, A. Padmanabha, L. Segoufin, and C. Sirangelo
Vol. 21:1
ui in Π if trace(ui) = R then key(ui)̸ = c. Take any arbitrary fact of the form v = R(c b)
of D. The new path Π′ = u1, u2, . . . , ul, v is also a valid path.
So in both cases we have last(Π′) = b. Also, since there is a run of Aq on trace(Π)
that ends at sL, there is a run of Aq on trace(Π′) that ends at s′. Hence, trace(Π′) ≈s′.
Thus, by induction hypothesis, if there is already a fact of the form ui = R(c b) in Π
then SΠ′ ∈∆k(q, D, i). But since ui is already present in Π, we obtain SΠ = SΠ′, and
therefore SΠ ∈∆k(q, D, i) ⊆∆k(q, D, i + 1).
Otherwise, by induction hypothesis we have SΠ′ = SΠ ∪{R(c b)} ∈∆k(q, D, i). Since
this holds for any fact of the form R(c b) we obtain, by definition of ∆k(q, D), that
SΠ ∈∆k(q, D, i + 1).
(3) Case sl+1 = slR′ for some R′̸ = R.
Since trace(Π) = sl, there is a run of Aq on sl that ends in state sL. Let P be the last
symbol of sL (since sL is non-empty by assumption). Observe that, by definition of Aq,
a run on a word cannot end at sL unless the word also ends with P; therefore, sl has to
end with P. Altogether we have sl+1 =
sl
z
}|
{
wP
|{z}
sL
R w′P R′ for some w, w′ ∈σ∗and R̸ = R′.
Applying Lemma 6.6, we obtain that sL is a suffix of sl. Let Π′ = ul−L+1, . . . , ul be the
suffix of Π such that trace(Π′) = sL. Note that Π′ is a valid path and SΠ′ ⊆SΠ. Hence,
it is sufficient to prove that SΠ′ ∈∆k(q, D, i + 1). We are then in the situation of the
already treated Case 2 above, since sL+1 = sLR. Hence, SΠ′ ∈∆k(q, D, i + 1).
6.2. Inexpressiblity results for path queries. In this section we show our second main
result for path queries: if there exists a word w ∈L↬(q) such that q is not a factor of w,
then for all k, Certk fails to capture certain(q).
Together with Theorem 6.2 this gives a complete characterization of when our fixpoint
algorithm computes certain(q) for path queries q. Note that from Theorem 6.1 we already
know that for such queries, certain(q) is coNP-complete. So assuming PTime̸ = coNP no
polynomial time algorithm can compute certain(q). Our result is unconditional but only
applies for the Certk algorithm.
Theorem 6.7. Let q be a path query such that q̸ |= FactorCond. Then for all k, certain(q)
is not computed by Certk(q).
From the existence of a word in L↬(q) that does not have q as a factor, it follows that q
is of the form uTvTw but q is not a factor of uTvTvTw [KOW21, Lemma 5.4]. The proof
of Theorem 6.7 is again a reduction to the case of the query q4 (refer to Theorem 5.1) using
the following proposition.
Proposition 6.8. Let q be a path query of the form uTvTw and q is not a factor of
uTvTvTw. For every database D over the signature of q4 we can construct a database D′
over the signature of q such that:
(1) If D |= certain(q4) then D′ |= certain(q).
(2) For every k ≥2, if D′ |= Certk(q) then D |= Cert+
k(q4).
Before we prove the proposition we show why it implies Theorem 6.7.
Proof of Theorem 6.7. Recall that, since q is not a factor of every word in L↬(q), we have
that q is of the form uTvTw but q is not a factor of uTvTvTw [KOW21, Lemma 5.4].

---

Vol. 21:1
A SIMPLE ALGORITHM FOR CQA UNDER PRIMARY KEYS
18:35
Assume towards a contradiction that there is a k such that certain(q) = Certk(q). We
then show that certain(q4) = Cert+
k(q4), contradicting Theorem 5.1. To prove this it is
enough to show that if a database D is such that D |= certain(q4) then D |= Cert+
k(q4).
Consider such a database D and let D′ be the database constructed by Proposition 6.8.
From our hypothesis on D and the first item of Proposition 6.8, it follows that D′ |=
certain(q). From our hypothesis on q it follows that D′ |= Certk(q). From the second item
of Proposition 6.8, it follows that D |= Cert+
k(q4), and the desired contradiction.
We now turn to the proof of Proposition 6.8.
Proof of Proposition 6.8. From the hypotheses we have that u̸ = ε (otherwise q = TvTw is
a factor of TvTvTw). So let u = A0u′ and let us denote q as
A0(x x1) u′ T(y y0) v T(z z0) w,
where





u′
= A1(x1 x2) . . . Ai(xi y),
v
= A′
0(y0 y1)A′
1(y1 y2) . . . A′
j(yj z),
w
= A′′
0(z0 z1)A′′
1(z1 z2) . . . A′′
k(zk zk+1),
and u′, v, w are possibly empty. Note that if v = ε then y0 = z.
Let D be a database for q4. Consider the solution graph GD of D. Recall that every
connected component in GD is always a clique of size less than or equal to 3 and that every
fact of D can be part of exactly one maximal clique (cf. Remark 5.2).
Let B1, B2 . . . Bm be the set of all blocks of D and C1, C2 . . . Cl be the set of maximal
cliques in the solution graph GD. Notice that a clique may contain two facts in the same
block. For instance the facts R(a ba) and R(a ab) form a solution to q4. Recall that a clique
Ct is called self-loop if it contains only one fact h such that D |= q4(hh).
Define D′ as follows:
If the block Bs of D contains a fact in a non-self-loop clique Ct then we add the following
facts to D′, (all domain elements are fresh):
A0(αs αst
1 ) A1(αst
1 αst
2 ) . . . Ai(αst
i βst)
|
{z
}
u′
T(βst βst
0 ) A′
0(βst
0 βst
1 )A′
1(βst
1 βst
2 ) . . . A′
j(βst
j γst)
|
{z
}
v
T(γst δst
0 ) A′
0(δst
0 δst
1 )A′
1(δst
1 δst
2 ) . . . A′
j(δst
j ηst)
|
{z
}
v
T(ηst ηst
0 ) A′′
0(ηst
0 ηst
1 )A′′
1(ηst
1 ηst
2 ) . . . A′′
k(ηst
k ηst
k+1)
|
{z
}
w
If the block Bs of D contains a fact in the self-loop clique Ct then then we add the
following facts to D′.
A0(αs αst
1 ) A1(αst
1 αst
2 ) . . . Ai(αst
i βst)
|
{z
}
u′
T(βst βst
0 ) A′
0(βst
0 βst
1 )A′
1(βst
1 βst
2 ) . . . A′
j(βst
j γst)
|
{z
}
v
T(γst γst
0 ) A′′
0(γst
0 γst
1 )A′′
1(γst
1 γst
2 ) . . . A′′
k(γst
k γst
k+1)
|
{z
}
w

---

18:36
D. Figueira, A. Padmanabha, L. Segoufin, and C. Sirangelo
Vol. 21:1
C1
C2
sha1_base64="eIv
zBnFGZsKhdUxfM3
YDy829kI=">AB+
3icbVC7SgNBFJ2Nr
xhfayxtBoNiIWFXf
HUGbCwjmAdkQ5id3
CRDZmeXmVkxLPshW
thYKGJr4W/Y+TfOJi
k08cDA4Zx7uHeOH3
GmtON8W7mFxaXlf
xqYW19Y3PL3i7WVR
hLCjUa8lA2faKAMw
E1zTSHZiSBD6Hhj
+8yvzGHUjFQnGrRx
G0A9IXrMco0Ubq2E
UvFl2QWTwhqXeEfdq
xS07ZGQPE3dKSpe
fDxkeqx37y+uGNA5
AaMqJUi3XiXQ7IVI
zyiEteLGCiNAh6UP
LUECUO1kfHuK943
Sxb1Qmic0Hqu/Ewk
JlBoFvpkMiB6oWS8
T/Nase5dtBMmoliD
oJNFvZhjHeKsCNxl
EqjmI0MIlczciumA
SEK1qatgSnBnvzxP
6sdl96x8enNSqhyg
CfJoF+2hQ+Sic1RB
16iKaoie/SEXtCr
lVrP1pv1PhnNWdPM
DvoD6+MH7+6YxA=<
/latexit> a bc
sha1_base64="iQ2
VgNFwcN1MyFaDo4S
OPU3SKBY=">AB+
3icbVC7SgNBFJ2Nr
xhfMZY2g0GxkLArv
joDNpYRzAOyS5idv
UmGzM4uM7NiWPIhW
thYKGJr4W/Y+TfOJi
k08cDA4Zx7uHeOH3
OmtG1/W7mFxaXlf
xqYW19Y3OruF1qC
iRFOo04pFs+UQBZw
LqmkOrVgCX0OTX
9wlfnNO5CKReJWD2
PwQtITrMso0UbqFE
tuIgKQWTwlI/cI+0G
nWLYr9h4njhTUr7
8fMjwWOsUv9wgok
IQlNOlGo7dqy9lEj
NKIdRwU0UxIQOSA/
ahgoSgvLS8e0jvG+
UAHcjaZ7QeKz+TqQ
kVGoY+mYyJLqvZr1
M/M9rJ7p74aVMxIkG
QSeLugnHOsJZEThg
EqjmQ0MIlczcimf
SEK1qatgSnBmvzxP
GscV56xyenNSrh6g
CfJoF+2hQ+Sgc1RF
16iG6oie/SEXtCr
NbKerTfrfTKas6aZ
HfQH1scP8XKYxQ=<
/latexit> a bd
e64="MgcELvUwVbJAdowABLiqb4ENIc
=">AB+3icbVC7SgNBFJ2NrxhfMZY2g
0GxkLArvjoDNpYRzAOyS5idvUmGzM4uM
7NiWPIhWthYKGJr4W/Y+TfOJik08cDA4Z
x7uHeOH3OmtG1/W7mFxaXlfxqYW19Y3
OruF1qCiRFOo04pFs+UQBZwLqmkOrV
gCX0OTX9wlfnNO5CKReJWD2PwQtITrM
so0UbqFEtuIgKQWTz1R+4RDkinWLYr9h
4njhTUr78fMjwWOsUv9wgokIQlNOlGo
7dqy9lEjNKIdRwU0UxIQOSA/ahgoSgvL
S8e0jvG+UAHcjaZ7QeKz+TqQkVGoY+mY
yJLqvZr1M/M9rJ7p74aVMxIkGQSeLugnH
OsJZEThgEqjmQ0MIlczcimfSEK1qatg
SnBmvzxPGscV56xyenNSrh6gCfJoF+2h
Q+Sgc1RF16iG6oie/SEXtCrNbKerTfr
fTKas6aZHfQH1scP8XqYxQ=</latexit
> b da
e64="obZChuYepuCRPU6K/J1k5Q0fRfs
=">AB+3icbVC7SgNBFJ2NrxhfayxtB
oNiIWFXfHUGbCwjmAdkQ5id3CRDZmeXm
VkxLPshWthYKGJr4W/Y+TfOJik08cDA4Z
x7uHeOH3GmtON8W7mFxaXlfxqYW19Y3
PL3i7WVRhLCjUa8lA2faKAMwE1zTSHZi
SBD6Hhj+8yvzGHUjFQnGrRxG0A9IXrM
co0Ubq2EUvFl2QWTzxU+8IU9KxS07ZGQP
PE3dKSpefDxkeqx37y+uGNA5AaMqJUi3
XiXQ7IVIzyiEteLGCiNAh6UPLUECUO1
kfHuK943Sxb1Qmic0Hqu/EwkJlBoFvpk
MiB6oWS8T/Nase5dtBMmoliDoJNFvZhj
HeKsCNxlEqjmI0MIlczciumASEK1qatg
SnBnvzxP6sdl96x8enNSqhygCfJoF+2h
Q+Sic1RB16iKaoie/SEXtCrlVrP1pv1
PhnNWdPMDvoD6+MH7/WYxA=</latexit
> b ca
c ab
B1
e64="M3iDasGUWtlXgfHv8a9C/j14PcQ
=">AB6nicbZDLTsJAFIZP8YZ4Q126m
Ug0rkhLvO0kunGJ0QIJNGQ6TGHCdNrMT
E1IwyO4caFBt76Er+HOt3EKLBT8k0m+/P
85mXOH3OmtG1/W7ml5ZXVtfx6YWNza3
unuLtXV1EiCXVJxCPZ9LGinAnqaqY5bc
aS4tDntOEPbrK8UilYpF40MOYeiHuCR
YwgrWx7q87lU6xZJftidAiODMoX2OM73
VOsWvdjciSUiFJhwr1XLsWHsplpoRTke
FdqJojMkA92jLoMAhV46GXWEjozTRUE
kzRMaTdzfHSkOlRqGvqkMse6r+Swz/8t
aiQ4uvZSJONFUkOlHQcKRjlC2N+oySYnm
QwOYSGZmRaSPJSbaXKdgjuDMr7wI9UrZ
OS+f3Z2WqscwVR4O4BOwIELqMIt1MAF
Aj14ghd4tbj1bI2t92lpzpr17MfWR8/
15CR6A=</latexit> B2
sha1_base64="qLf
r/sWpWG53G/wHlWK
7/86J2k4=">AB6
nicbZC7TsMwFIZPy
q2UW4GRxaICMVUJ9
40KFsYi6EVqo8pxn
daq40S2g1RFfQWB
lBh5SV4DTbeBiftAC
2/ZOnT/58jn3O8iD
Olbfvbyi0sLi2v5F
cLa+sbm1vF7Z26Cm
NJaI2EPJRNDyvKma
A1zTSnzUhSHicNr
zBTZo3HqlULBQPeh
hRN8A9wXxGsDbW/X
XnpFMs2WU7E5oHZwq
lq89xqrdqp/jV7oY
kDqjQhGOlWo4daTf
BUjPC6ajQjhWNMBn
gHm0ZFDigyk2yUf
owDhd5IfSPKFR5v7
uSHCg1DwTGWAdV/
NZqn5X9aKtX/pJkx
EsaCTD7yY450iNK9
UZdJSjQfGsBEMjMr
In0sMdHmOgVzBGd2
5XmoH5ed8/LZ3Wmp
cgT5WEP9uEIHLiA
CtxCFWpAoAdP8AKv
FrerbH1PinNWdOe
Xfgj6+MH2RSR6Q=
</latexit> B3
e64="yoBqo+MdgDtP1/RJgtheCD5a/9Y
=">AB73icbZDJSgNBEIZrXGPcoh69N
AbFU5gRt5sBLx4jmAWSMdR0epImPYvdP
UIY8hJexAXx6iP4Gt58G3uSHDTxh4aP/6
+iq8qLBVfatr+tufmFxaXl3Ep+dW19Y7
OwtV1TUSIpq9JIRLhoWKCh6yquRasEU
uGgSdY3etfZn9nknFo/BGD2LmBtgNuc
8pamM1WijiHt467ULRLtkjkVlwJlC8+Hz
K9FxpF75anYgmAQs1FahU07Fj7aYoNae
CDfOtRLEYaR+7rGkwxIApNx3NOyT7xuk
QP5LmhZqM3N8dKQZKDQLPVAaoe2o6y8z
/smai/XM35WGcaBbS8Ud+IoiOSLY86XDJ
qBYDA0glN7MS2kOJVJsT5c0RnOmVZ6F2
VHJOSyfXx8XyAYyVg13Yg0Nw4AzKcAUV
qAIFAQ/wAq/WnfVovVnv49I5a9KzA39k
fwAz/uUOA=</latexit>
↵1
2x6Ht1ul6rkAx9o=">AB+HicbVDLSsNAFJ34rPXRqEs3g0VxISUjvnYW3LisY
B/QxDCZTtqhk0mYmQg19EPUjQtF3PoXbt35N07aLrT1wIXDOfdy7z1BwpnSjvNtzc
0vLC4tF1aKq2vrGyV7c6uh4lQSWicxj2UrwIpyJmhdM81pK5EURwGnzaB/mfvNOy
oVi8WNHiTUi3BXsJARrI3k2yUX86SHfXSbIfcQDX27FScEeAsQRNSvh8yPFY8+0
vtxOTNKJCE46VaiMn0V6GpWaE02HRTRVNMOnjLm0bKnBElZeNDh/CPaN0YBhLU0L
Dkfp7IsORUoMoMJ0R1j017eXif1471eG5lzGRpJoKMl4UphzqGOYpwA6TlGg+MAQT
ycytkPSwxESbrIomBDT98ixpHFXQaeXk+rhc3QdjFMAO2AUHAIEzUAVXoAbqgIAU
PIEX8GrdW8/Wm/U+bp2zJjPb4A+sjx/mkpcA</latexit>
↵1 1
1
4kbQavjhI62BDzWM=">AB+HicbVDLSsNAFL2pr1ofjbp0EyKCylJ8bWz4MZlB
fuANobJdNIOnUzCzESoR+iblwo4ta/cOvOv3HSdqGtBy4czrmXe+/xY0alsu1vI7
ewuLS8kl8trK1vbBbNre2GjBKBSR1HLBItH0nCKCd1RUjrVgQFPqMNP3BZeY374
iQNOI3ahgTN0Q9TgOKkdKSZxY7iMV95Dm3qdM5qow8s2SX7TGseJMSeni8yHDY80
zvzrdCch4QozJGXbsWPlpkgoihkZFTqJDHCA9QjbU05Col0/HhI2tfK10riIQ
urqyx+nsiRaGUw9DXnSFSfTnrZeJ/XjtRwbmbUh4ninA8WRQkzFKRlaVgdakgWLGh
JgLqm+1cB8JhJXOqBDcGZfnieNStk5LZ9cH5eqBzBHnZhDw7BgTOowhXUoA4Y
EniCF3g17o1n4814n7TmjOnMDvyB8fED6BeXAQ=</latexit>
↵1 2
1
A0
e64="9vDKlSgw/VsvW38AUYwnXpc7dMA
=">AB73icbZDJSgNBEIZr4hbjFvXop
TEonsJMcLsZ8OIxglkgGUNp5M06Vns7
hHCkJfwIi6IVx/B1/Dm29iT5KCJPzR8/H
8VXVeJLjStv1tZRYWl5ZXsqu5tfWNza
389k5NhbGkrEpDEcqGh4oJHrCq5lqwRi
QZ+p5gdW9wmeb1eyYVD4MbPYyY62Mv4F
1OURur0UIR9fG21M4X7KI9FpkHZwqFi8+
nVM+Vdv6r1Qlp7LNAU4FKNR070m6CUnM
q2CjXihWLkA6wx5oGA/SZcpPxvCNyYJw
O6YbSvECTsfu7I0FfqaHvmUofdV/NZqn
5X9aMdfcTXgQxZoFdPJRNxZEhyRdnS4
ZFSLoQGkptZCe2jRKrNiXLmCM7syvNQ
KxWd0+LJ9XGhfAgTZWEP9uEIHDiDMlxB
BapAQcADvMCrdWc9Wm/W+6Q0Y017duGP
rI8f0X+UOQ=</latexit>
↵2
s5lkuLbj3lXVI4Zc=">AB+XicbVDLSsNAFL3xWesr6tLNYFcSEmKr50FNy4r2
Ac0MUymk3bo5MHMpFBCP0Rx40IRt36FW3f+jZO2C209cOFwzr3ce4+fcCaVZX0bC4
tLyurhbXi+sbm1ra5s9uQcSoIrZOYx6LlY0k5i2hdMcVpKxEUhz6nTb9/nfvNAR
WSxdGdGibUDXE3YgEjWGnJM0H86SHPfs+qzgnyB5ZskqW2OgeWJPSenq8yHY80
zv5xOTNKQRopwLGXbthLlZlgoRjgdFZ1U0gSTPu7StqYRDql0s/HlI3SolQ4KYqE
rUmis/p7IcCjlMPR1Z4hVT856ufif105VcOlmLEpSRSMyWRSkHKkY5TGgDhOUKD7U
BPB9K2I9LDAROmwijoEe/bledKolO3z8tntal6BMUYB8O4BhsuIAq3EAN6kBg
AE/wAq9GZjwb8b7pHXBmM7swR8YHz9CjZcr</latexit>
↵2 1
1
PTVj1NoIWjelf40c=">AB+XicbVDLSsNAFJ34rPUVdelmsCgupCTF186CG5cV7
AOaG6mk3bo5MHMpFBCP0Rx40IRt36FW3f+jZO2C209cOFwzr3ce4+fcCaVZX0bC4
tLyurhbXi+sbm1ra5s9uQcSoIrZOYx6Llg6ScRbSumOK0lQgKoc9p0+9f535zQI
VkcXSnhgl1Q+hGLGAElJY803SAJz3w7Pus4pzgysgzS1bZGgPE3tKSlefDzkea57
5XRikoY0UoSDlG3bSpSbgVCMcDoqOqmkCZA+dGlb0whCKt1sfPkIH2qlg4NY6Io
UHqu/JzIpRyGvu4MQfXkrJeL/3ntVAWXbsaiJFU0IpNFQcqxinEeA+4wQYniQ02A
CKZvxaQHAojSYRV1CPbsy/OkUSnb5+Wz29NS9QhNUED76AdIxtdoCq6QTVURwQN
0BN6Qa9GZjwb8b7pHXBmM7soT8wPn4ARBKXLA=</latexit>
↵2 2
1
e64="1OtwlKUJRBoqCgAIZnw/8xsjDoQ
=">AB73icbZDJSgNBEIZr4hbjFvXop
TEonsKM+82AF48RzALJGo6naRJz2J3j
xCGvIQXcUG8+gi+hjfxp4kB038oeHj/6
voqvIiwZW27W8rMze/sLiUXc6trK6tb+
Q3t6oqjCVlFRqKUNY9VEzwgFU014LVI8
nQ9wSref3LNK/dM6l4GNzoQcRcH7sB73
CK2lj1Joqoh7dHrXzBLtojkVlwJlC4+Hx
K9Vxu5b+a7ZDGPgs0FahUw7Ej7SYoNae
CDXPNWLEIaR+7rGEwQJ8pNxnNOyR7xm
TijNCzQZub87EvSVGvieqfR9R0lpr
/ZY1Yd87dhAdRrFlAx91YkF0SNLlSZtL
RrUYGEAquZmV0B5KpNqcKGeO4EyvPAvV
w6JzWjy5Pi6U9mGsLOzALhyA2dQgiso
QwUoCHiAF3i17qxH6816H5dmrEnPNvyR
9fED0wOUOg=</latexit>
↵3
vE30YFQrA5Mpn0E=">AB+XicbVDLSsNAFJ34rPUVdelmsCgupCS+dxbcuKxgH
9DEcDOdtEMnD2YmhRL6IYobF4q49SvcuvNvnLRdaOuBC4dz7uXe/yEM6ks69uYm1
9YXFourBRX19Y3Ns2t7bqMU0FojcQ8Fk0fJOUsojXFKfNRFAIfU4bfu869xt9Ki
SLozs1SKgbQidiASOgtOSZpgM86YJn32cnzhG2h5ZsrWCHiW2BNSuvp8yPFY9cw
vpx2TNKSRIhykbNlWotwMhGKE02HRSVNgPSgQ1uaRhBS6Wajy4d4XytHMRCV6T
wSP09kUEo5SD0dWcIqiunvVz8z2ulKrh0MxYlqaIRGS8KUo5VjPMYcJsJShQfaAJE
MH0rJl0QJQOq6hDsKdfniX147J9Xj67PS1VDtAYBbSL9tAhstEFqAbVEU1RFAf
PaEX9GpkxrPxZryPW+eMycwO+gPj4wdEFpcs</latexit>
↵3 1
1
1QMudSUxasBlI=">AB+HicbVDLSsNAFJ34rPXRqEs3g0VxISURXzsLblxWs
A9oY7mZTtqhM0mYmQg19EPUjQtF3LrzN9z5N07aLrT1wIXDOfdy7z1+zJnSjvNtzc
0vLC4t51byq2vrGwV7c6umokQSWiURj2TDB0U5C2lVM81pI5YUhM9p3e9fZn79jk
rFovBGD2LqCeiGLGAEtJHadqHVBSHgNnVx6xC7w7ZdErOCHiWuBNSvPh8yPBYadt
frU5EkFDTgo1XSdWHspSM0Ip8N8K1E0BtKHLm0aGoKgyktHhw/xnlE6OIikqVD
jkfp7IgWh1ED4plOA7qlpLxP/85qJDs69lIVxomlIxouChGMd4SwF3GSEs0HhgCR
zNyKSQ8kEG2ypsQ3OmXZ0ntqOSelk6uj4vlfTRGDu2gXSAXHSGyugKVAVEZSg
J/SCXq1769l6s97HrXPWZGYb/YH18QNSHpad</latexit>
γ1 1
EdPSPjzRZE4PyfxY=">AB+HicbVDLSgMxFM3UV62Pjrp0EyKCykzxdfOghuXF
ewDOmPJpJk2NMkMSUaoQz9E3bhQxK07f8Odf2Om7UJbD1w4nHMv94TxIwq7TjfVm
5hcWl5Jb9aWFvf2CzaW9sNFSUSkzqOWCRbAVKEUHqmpGWrEkiAeMNIPBZeY374
hUNBI3ehgTn6OeoCHFSBupYxe9HuIc3aYu9I5gZdSxS07ZGQPOE3dKShefDxkeax3
7y+tGOFEaMyQUm3XibWfIqkpZmRU8BJFYoQHqEfahgrEifLT8eEjuG+ULgwjaUp
oOFZ/T6SIKzXkgenkSPfVrJeJ/3ntRIfnfkpFnGgi8GRmDCoI5ilALtUEqzZ0BCE
JTW3QtxHEmFtsiqYENzZl+dJo1J2T8sn18el6gGYIA92wR4BC4A1VwBWqgDjBI
wBN4Aa/WvfVsvVnvk9acNZ3ZAX9gfwAU6OWng=</latexit>
γ1 2
dGY3Mxp9ujqAnIhk=">AB9XicbVDLSgNBEJyNrxhfUY9eBoPiQcJu8HUz4MVjB
POAZBN6J7PJkJndZWZWCUv+QwUPinj17G9482+cTXLQxIKGoqb7i4v4kxp2/62Mg
uLS8sr2dXc2vrG5lZ+e6emwlgSWiUhD2XDA0U5C2hVM81pI5IUhMdp3RtcpX79jk
rFwuBWDyPqCugFzGcEtJHarR4IAe2k1DrGzqiTL9hFew8T5wpKVx+PqZ4qnTyX61
uSGJBA04KNV07Ei7CUjNCKejXCtWNAIygB5tGhqAoMpNxleP8IFRutgPpalA47H
6eyIBodRQeKZTgO6rWS8V/OasfYv3IQFUaxpQCaL/JhjHeI0AtxlkhLNh4YAkczc
ikfJBtgsqZEJzZl+dJrVR0zoqnNyeF8iGaIv20D46Qg46R2V0jSqoigiS6AG9
oFfr3nq23qz3SWvGms7soj+wPn4AglyWQw=</latexit>
γ2 1
γ2 2
γ3 1
dgOHwtUpMgBTcG8=">AB6XicdZDLSgMxFIYz9VbrerSTbB4WQ2Zamu7suDGZ
RV7gXYomThmYyQ5IRytA3cONC0W59Cl/DnW9jplVQ0R8CH/9/DjneBFnSiP0bm
UWFpeWV7KrubX1jc2t/PZOU4WxJLRBQh7KtocV5UzQhma03YkKQ48Tlve6CLNW7
dUKhaKGz2OqBvgWA+I1gb6zo+6uULyEblUhVIbJLyKnMAKFypXgCHQOpCuevz6m
m9V7+rdsPSRxQoQnHSnUcFGk3wVIzwuk140VjTAZ4QHtGBQ4oMpNZpNO4IFx+tA
PpXlCw5n7vSPBgVLjwDOVAdZD9TtLzb+yTqz9ipswEcWaCjL/yI851CFM14Z9JinR
fGwAE8nMrJAMscREm+PkzBG+NoX/Q7NoO2W7dHVaqB2CubJgD+yDY+CAM1ADl6AO
GoAH9yB/Bojax768mazksz1mfPLvgh6+UDxdOR7g=</latexit>
u0
✓3 1
1
✓1 2 1
✓1 3 1
✓2 3 1
A0
9rAkYVMFWuTfJ2Eg=">AB7XicbZDLTgIxFIbP4A3xhrp0i8rMiMehOEjcuM
eGWwIR0SoFKp520HRIy4R3cuIAYtz6LW3e+jR1goeifNPny/+ek5wg4kwb1/1yMm
vrG5tb2e3czu7e/kH+8KiuZawIrRHJpWoGWFPOBK0ZjhtRoriMOC0EQzv07wxok
ozKapmHFE/xH3BeoxgY616fIGqaNTJF9yiOxf6C94SCncf01SzSif/2e5KEodUGMK
x1i3PjYyfYGUY4XSa8eaRpgMcZ+2LAocUu0n82kn6Mw6XdSTyj5h0Nz92ZHgUOt
xGNjKEJuBXs1S87+sFZverZ8wEcWGCrL4qBdzZCRKV0dpigxfGwBE8XsrIgMsMLE
2APl7BG81ZX/Qv2q6JWKpcfrQvkcFsrCZzCJXhwA2V4gArUgMATPMUZo50XpxX
521RmnGWPcfwS87N59kuo=</latexit>
u0Tv
9rAkYVMFWuTfJ2Eg=">AB7XicbZDLTgIxFIbP4A3xhrp0i8rMiMehOEjcuM
eGWwIR0SoFKp520HRIy4R3cuIAYtz6LW3e+jR1goeifNPny/+ek5wg4kwb1/1yMm
vrG5tb2e3czu7e/kH+8KiuZawIrRHJpWoGWFPOBK0ZjhtRoriMOC0EQzv07wxok
ozKapmHFE/xH3BeoxgY616fIGqaNTJF9yiOxf6C94SCncf01SzSif/2e5KEodUGMK
x1i3PjYyfYGUY4XSa8eaRpgMcZ+2LAocUu0n82kn6Mw6XdSTyj5h0Nz92ZHgUOt
xGNjKEJuBXs1S87+sFZverZ8wEcWGCrL4qBdzZCRKV0dpigxfGwBE8XsrIgMsMLE
2APl7BG81ZX/Qv2q6JWKpcfrQvkcFsrCZzCJXhwA2V4gArUgMATPMUZo50XpxX
521RmnGWPcfwS87N59kuo=</latexit>
u0Tv
F0XG6CcmzUp08WqM=">AB+nicbVDLSgMxFM3UV62vqS7dBIviQsqM+NpZcOyg
n1AOw6ZNOGJpkhyShl7IcouHGhiFs3/oY7/8ZM24W2HrhwOde7r0niBlV2nG+rd
zc/MLiUn65sLK6tr5hFzfrKkokJjUcsUg2A6QIo4LUNWMNGNJEA8YaQT9i8xv3B
KpaCSu9SAmHkdQUOKkTaSbxfbXcQ58p2b1IXtA+gOfbvklJ0R4CxJ6R0/vmQ4bH
q21/tToQToTGDCnVcp1YeymSmJGhoV2okiMcB91SctQgThRXjo6fQh3jdKBYSR
NCQ1H6u+JFHGlBjwnRzpnpr2MvE/r5Xo8MxLqYgTQeLwoTBnUEsxgh0qCNRsY
grCk5laIe0girE1aBROCO/3yLKkflt2T8vHVUamyB8bIg2wA/aBC05BVyCKqgB
DO7AE3gBr9a9Wy9We/j1pw1mdkCf2B9/AB/TZdA</latexit>
γ1 1
0
9V79lwz9cmqtDewU=">AB+nicbVDLSsNAFJ3UV62vVJduBoviQkoivnYW3LisY
B/QxDCZTNqhk0mYmSgl9kMU3LhQxK0bf8Odf+Ok7UJbD1w4nHMv97jJ4xKZVnfRm
FufmFxqbhcWldW98wy5tNGacCkwaOWSzaPpKEU4aipG2okgKPIZafn9i9xv3R
Ihacyv1SAhboS6nIYUI6Ulzyw7AWEKedZNZkPnANpDz6xYVWsEOEvsCamcfz7keKx
75pcTxDiNCFeYISk7tpUoN0NCUczIsOSkiQI91GXdDTlKCLSzUanD+GuVgIYxkI
XV3Ck/p7IUCTlIPJ1Z4RUT057ufif10lVeOZmlCepIhyPF4UpgyqGeQ4woIJgxQa
ICyovhXiHhIK51WSYdgT78S5qHVfukenx1VKntgTGKYBvsgH1g1NQA5egDhoA
gzvwBF7Aq3FvPBtvxvu4tWBMZrbAHxgfP4o7l0c=</latexit>
δ1 1
0
δ1 2
0
PHEcd/Jy5z3ni8kA=">AB+nicbVDLSsNAFJ34rPWV6tLNYFcSEmKr50FNy4r2
Ac0MUwmk3boZBJmJkqJ/RAFNy4UcevG3Dn3zhpu9DWAxcO59zLvf4CaNSWda3MT
e/sLi0XFgprq6tb2yapa2mjFOBSQPHLBZtH0nCKCcNRUj7UQFPmMtPz+Re63bo
mQNObXapAQN0JdTkOKkdKSZ5acgDCFPOsmq0LnENpDzyxbFWsEOEvsCSmfz7keKx
75pcTxDiNCFeYISk7tpUoN0NCUczIsOikiQI91GXdDTlKCLSzUanD+GeVgIYxkI
XV3Ck/p7IUCTlIPJ1Z4RUT057ufif10lVeOZmlCepIhyPF4UpgyqGeQ4woIJgxQa
ICyovhXiHhIK51WUYdgT78S5rVin1SOb46Ktf2wRgFsAN2wQGwSmogUtQBw2A
wR14Ai/g1bg3no0343cOmdMZrbBHxgfP4vFl0g=</latexit>
δ2 1
0
hQsVvU53rtnuQUSM=">AB+nicbVDLSsNAFJ34rPWV6tLNYFcSEmKr50FNy4r2
Ac0MUwmk3boZBJmJkqJ/RAFNy4UcevG3Dn3zhpu9DWAxcO59zLvf4CaNSWda3MT
e/sLi0XFgprq6tb2yapa2mjFOBSQPHLBZtH0nCKCcNRUj7UQFPmMtPz+Re63bo
mQNObXapAQN0JdTkOKkdKSZ5acgDCFPOsmq0LnEFaHnlm2KtYIcJbYE1I+/3zI8Vj
3zC8niHEaEa4wQ1J2bCtRboaEopiRYdFJUkQ7qMu6WjKUSkm41OH8I9rQwjIU
uruBI/T2RoUjKQeTrzgipnpz2cvE/r5Oq8MzNKE9SRTgeLwpTBlUM8xgQAXBig0
QVhQfSvEPSQVjqtog7Bn5ljSrFfukcnx1VK7tgzEKYAfsgNg1NQA5egDhoA
gzvwBF7Aq3FvPBtvxvu4dc6YzGyDPzA+fgCNSpdJ</latexit>
δ2 2
0
δ3 1
0
iE3nPY+mkqjnka8U=">AB+nicbVDLSgMxFM34rPU1aWbYFcSJkpvnYW3LisY
B/QGYdMmlDk8yQZJQy9kMU3LhQxK0bf8Odf2P6WGjrgQuHc+7l3nvChFGlHefbmp
tfWFxazq3kV9fWNzbtwlZdxanEpIZjFstmiBRhVJCapqRZiIJ4iEjbB3MfQbt0
QqGotr3U+Iz1FH0IhipI0U2AWvgzhHgXOTudA7hOVBYBedkjMCnCXuhBTPx+GeKw
G9pfXjnHKidCYIaVarpNoP0NSU8zIO+liQI91CHtAwViBPlZ6PTB3DPKG0YxdK
U0HCk/p7IEFeqz0PTyZHuqmlvKP7ntVIdnfkZFUmqicDjRVHKoI7hMAfYpJgzfqG
ICypuRXiLpIa5NW3oTgTr8S+rlkntSOr46Klb2wRg5sAN2wQFwSmogEtQBTWA
wR14Ai/g1bq3nq0363cOmdNZrbBH1gfP4DSl0E=</latexit>
γ1 2
0
γ2 1
0
Jy1ZnaqHzRnmVldw=">AB+XicbVDLSsNAFJ34rPUVdelmsCgupCTF186CG5cV7
AOaGCbTSTt0ZhJmJoUS+iGKGxeKuHXlb7jzb5y0XWjrgQuHc+7l3nvChFGlHefbWl
hcWl5ZLawV1zc2t7btnd2GilOJSR3HLJatECnCqCB1TUjrUQSxENGmH/OvebAy
IVjcWdHibE56graEQx0kYKbNvrIs5R4NxnFe8EVkaBXLKzhwnrhTUr6fMjxWAv
sL68T45QToTFDSrVdJ9F+hqSmJFR0UsVSRDuoy5pGyoQJ8rPxpeP4KFROjCKpSm
h4Vj9PZEhrtSQh6aTI91Ts14u/ue1Ux1d+hkVSaqJwJNFUcqgjmEeA+xQSbBmQ0MQ
ltTcCnEPSYS1CatoQnBnX54njUrZPS+f3Z6WqkdgLYBwfgGLjgAlTBDaiBOsBg
AJ7AC3i1MuvZerPeJ60L1nRmD/yB9fEDKCKXGA=</latexit>
γ2 2
0
γ3 1
0
T
3rKzXRQGa+eW/G+8=">AB6HicdZDLSsNAFIYn9VbrerSzWBRXIU0rWldWXDjs
oXeoA1lMp20YyeTMDMRSugTuHGhSF36Nm7d+TZOWgUV/WHg5/vPYc45XsSoVJb1bm
RWVtfWN7Kbua3tnd29/P5BW4axwKSFQxaKrockYZSTlqKkW4kCAo8Rjre5CrNO7
dESBrypGxA3QiFOfYqQ0ajQH+YJlXlQd+9yGlmlZFbvkpMaulO0SLGqSqnD5Ok/
1XB/k3/rDEMcB4QozJGWvaEXKTZBQFDMy/VjSKEJ2hEetpyFBDpJotBZ/BEkyH
0Q6EfV3Bv3ckKJByGni6MkBqLH9nKfwr68XKr7oJ5VGsCMfLj/yYQRXCdGs4pIJg
xabaICyonhXiMRIK32bnD7C16bwf9O2zaJjOo1yoXYKlsqCI3AMzkARVEANXIM6
aAEMCLgD+DRuDHujSdjvizNGJ89h+CHjJcPRVKRqg=</latexit>
T
w
3rKzXRQGa+eW/G+8=">AB6HicdZDLSsNAFIYn9VbrerSzWBRXIU0rWldWXDjs
oXeoA1lMp20YyeTMDMRSugTuHGhSF36Nm7d+TZOWgUV/WHg5/vPYc45XsSoVJb1bm
RWVtfWN7Kbua3tnd29/P5BW4axwKSFQxaKrockYZSTlqKkW4kCAo8Rjre5CrNO7
dESBrypGxA3QiFOfYqQ0ajQH+YJlXlQd+9yGlmlZFbvkpMaulO0SLGqSqnD5Ok/
1XB/k3/rDEMcB4QozJGWvaEXKTZBQFDMy/VjSKEJ2hEetpyFBDpJotBZ/BEkyH
0Q6EfV3Bv3ckKJByGni6MkBqLH9nKfwr68XKr7oJ5VGsCMfLj/yYQRXCdGs4pIJg
xabaICyonhXiMRIK32bnD7C16bwf9O2zaJjOo1yoXYKlsqCI3AMzkARVEANXIM6
aAEMCLgD+DRuDHujSdjvizNGJ89h+CHjJcPRVKRqg=</latexit>
T
3rKzXRQGa+eW/G+8=">AB6HicdZDLSsNAFIYn9VbrerSzWBRXIU0rWldWXDjs
oXeoA1lMp20YyeTMDMRSugTuHGhSF36Nm7d+TZOWgUV/WHg5/vPYc45XsSoVJb1bm
RWVtfWN7Kbua3tnd29/P5BW4axwKSFQxaKrockYZSTlqKkW4kCAo8Rjre5CrNO7
dESBrypGxA3QiFOfYqQ0ajQH+YJlXlQd+9yGlmlZFbvkpMaulO0SLGqSqnD5Ok/
1XB/k3/rDEMcB4QozJGWvaEXKTZBQFDMy/VjSKEJ2hEetpyFBDpJotBZ/BEkyH
0Q6EfV3Bv3ckKJByGni6MkBqLH9nKfwr68XKr7oJ5VGsCMfLj/yYQRXCdGs4pIJg
xabaICyonhXiMRIK32bnD7C16bwf9O2zaJjOo1yoXYKlsqCI3AMzkARVEANXIM6
aAEMCLgD+DRuDHujSdjvizNGJ89h+CHjJcPRVKRqg=</latexit>
T
w
A0
e64="Co4/ITWXbgxq/cNjAeb1+gK1Vg
=">AB6nicbZDLSgMxFIbPeK31VnXpJ
lgUV2VGvO2suHFZ0V6gHUomzbShSWZIM
kIZ+ghuXCjVrS/ha7jzbcy0XWjrD4GP/z
+HnHOCmDNtXPfbWVhcWl5Zza3l1zc2t7
YLO7s1HSWK0CqJeKQaAdaUM0mrhlOG7
GiWASc1oP+TZbXH6nSLJIPZhBTX+CuZC
Ej2Fjr/rtgtFt+SOhebBm0Lx6nOU6a3
SLny1OhFJBJWGcKx103Nj46dYGUY4HeZ
biaYxJn3cpU2LEguq/XQ86hAdWqeDwkj
ZJw0au787Uiy0HojAVgpseno2y8z/smZ
iwks/ZTJODJVk8lGYcGQilO2NOkxRYvjA
AiaK2VkR6WGFibHXydsjeLMrz0PtpOSd
l87uTovlI5goB/twAMfgwQWU4RYqUAUC
XiCF3h1uPsjJz3SemCM+3Zgz9yPn4A
0wKR5Q=</latexit> A0
u0Tv
9rAkYVMFWuTfJ2Eg=">AB7XicbZDLTgIxFIbP4A3xhrp0i8rMiMehOEjcuM
eGWwIR0SoFKp520HRIy4R3cuIAYtz6LW3e+jR1goeifNPny/+ek5wg4kwb1/1yMm
vrG5tb2e3czu7e/kH+8KiuZawIrRHJpWoGWFPOBK0ZjhtRoriMOC0EQzv07wxok
ozKapmHFE/xH3BeoxgY616fIGqaNTJF9yiOxf6C94SCncf01SzSif/2e5KEodUGMK
x1i3PjYyfYGUY4XSa8eaRpgMcZ+2LAocUu0n82kn6Mw6XdSTyj5h0Nz92ZHgUOt
xGNjKEJuBXs1S87+sFZverZ8wEcWGCrL4qBdzZCRKV0dpigxfGwBE8XsrIgMsMLE
2APl7BG81ZX/Qv2q6JWKpcfrQvkcFsrCZzCJXhwA2V4gArUgMATPMUZo50XpxX
521RmnGWPcfwS87N59kuo=</latexit>
u0Tv
T
3rKzXRQGa+eW/G+8=">AB6HicdZDLSsNAFIYn9VbrerSzWBRXIU0rWldWXDjs
oXeoA1lMp20YyeTMDMRSugTuHGhSF36Nm7d+TZOWgUV/WHg5/vPYc45XsSoVJb1bm
RWVtfWN7Kbua3tnd29/P5BW4axwKSFQxaKrockYZSTlqKkW4kCAo8Rjre5CrNO7
dESBrypGxA3QiFOfYqQ0ajQH+YJlXlQd+9yGlmlZFbvkpMaulO0SLGqSqnD5Ok/
1XB/k3/rDEMcB4QozJGWvaEXKTZBQFDMy/VjSKEJ2hEetpyFBDpJotBZ/BEkyH
0Q6EfV3Bv3ckKJByGni6MkBqLH9nKfwr68XKr7oJ5VGsCMfLj/yYQRXCdGs4pIJg
xabaICyonhXiMRIK32bnD7C16bwf9O2zaJjOo1yoXYKlsqCI3AMzkARVEANXIM6
aAEMCLgD+DRuDHujSdjvizNGJ89h+CHjJcPRVKRqg=</latexit>
T
T
3rKzXRQGa+eW/G+8=">AB6HicdZDLSsNAFIYn9VbrerSzWBRXIU0rWldWXDjs
oXeoA1lMp20YyeTMDMRSugTuHGhSF36Nm7d+TZOWgUV/WHg5/vPYc45XsSoVJb1bm
RWVtfWN7Kbua3tnd29/P5BW4axwKSFQxaKrockYZSTlqKkW4kCAo8Rjre5CrNO7
dESBrypGxA3QiFOfYqQ0ajQH+YJlXlQd+9yGlmlZFbvkpMaulO0SLGqSqnD5Ok/
1XB/k3/rDEMcB4QozJGWvaEXKTZBQFDMy/VjSKEJ2hEetpyFBDpJotBZ/BEkyH
0Q6EfV3Bv3ckKJByGni6MkBqLH9nKfwr68XKr7oJ5VGsCMfLj/yYQRXCdGs4pIJg
xabaICyonhXiMRIK32bnD7C16bwf9O2zaJjOo1yoXYKlsqCI3AMzkARVEANXIM6
aAEMCLgD+DRuDHujSdjvizNGJ89h+CHjJcPRVKRqg=</latexit>
T
NkFo23ys0SQn3kCA=">AB7HicbZDNTgIxFIXv4B/iH+rSTSPRuCIzxqA7Sdy4x
IQBEpiQTulAQ6czaTsYMuEZ3LgQjVvfxa0738YOsFDwJE2+nHNveu/1Y86Utu1vK7
e2vrG5ld8u7Ozu7R8UD48aKkokoS6JeCRbPlaUM0FdzTSnrVhSHPqcNv3hXZY3R1
QqFom6HsfUC3FfsIARrI3ljlAdPXaLJbtsz4RWwVlA6fZzmum1i1+dXoRSUIqNOF
YqbZjx9pLsdSMcDopdBJFY0yGuE/bBgUOqfLS2bATdGacHgoiaZ7QaOb+7khxqNQ
49E1liPVALWeZ+V/WTnRw46VMxImgsw/ChKOdISyzVGPSUo0HxvARDIzKyIDLDHR
5j4FcwRneVaFyWnUq58nBVqp7DXHk4gVO4AeuoQr3UAMXCDB4gheYWsJ6t6s
93lpzlr0HMfWR8/QVeSuw=</latexit>
vTw
NkFo23ys0SQn3kCA=">AB7HicbZDNTgIxFIXv4B/iH+rSTSPRuCIzxqA7Sdy4x
IQBEpiQTulAQ6czaTsYMuEZ3LgQjVvfxa0738YOsFDwJE2+nHNveu/1Y86Utu1vK7
e2vrG5ld8u7Ozu7R8UD48aKkokoS6JeCRbPlaUM0FdzTSnrVhSHPqcNv3hXZY3R1
QqFom6HsfUC3FfsIARrI3ljlAdPXaLJbtsz4RWwVlA6fZzmum1i1+dXoRSUIqNOF
YqbZjx9pLsdSMcDopdBJFY0yGuE/bBgUOqfLS2bATdGacHgoiaZ7QaOb+7khxqNQ
49E1liPVALWeZ+V/WTnRw46VMxImgsw/ChKOdISyzVGPSUo0HxvARDIzKyIDLDHR
5j4FcwRneVaFyWnUq58nBVqp7DXHk4gVO4AeuoQr3UAMXCDB4gheYWsJ6t6s
93lpzlr0HMfWR8/QVeSuw=</latexit>
vTw
w
kEnikKd8Re1inZrs=">AB6HicbZDJTgJBEIZrcEPcUI9eOhKNJzJj3G6SePEIi
SwJTEhPUwMtPUu6ezSE8ARePGgMHn0LX8Ob2MPcFDwTzr58v9V6aryYsGVtu1vK7
O0vLK6l3PbWxube/kd/dqKkokwyqLRCQbHlUoeIhVzbXARiyRBp7Aute/SfP6A0
rFo/BOD2J0A9oNuc8Z1caqPLbzBbtoT0QWwZlB4fpznOq93M5/tToRSwIMNRNUqaZ
jx9odUqk5EzjKtRKFMWV92sWmwZAGqNzhZNAROTJOh/iRNC/UZOL+7hjSQKlB4Jn
KgOqems9S87+smWj/yh3yME40hmz6kZ8IoiOSbk06XCLTYmCAMsnNrIT1qKRMm9vk
zBGc+ZUXoXZadC6K5WzQukYpsrCARzCThwCSW4hTJUgQHCE7zAq3VvPVtv1nha
mrFmPfvwR9bHDwFzkXg=</latexit> w
NkFo23ys0SQn3kCA=">AB7HicbZDNTgIxFIXv4B/iH+rSTSPRuCIzxqA7Sdy4x
IQBEpiQTulAQ6czaTsYMuEZ3LgQjVvfxa0738YOsFDwJE2+nHNveu/1Y86Utu1vK7
e2vrG5ld8u7Ozu7R8UD48aKkokoS6JeCRbPlaUM0FdzTSnrVhSHPqcNv3hXZY3R1
QqFom6HsfUC3FfsIARrI3ljlAdPXaLJbtsz4RWwVlA6fZzmum1i1+dXoRSUIqNOF
YqbZjx9pLsdSMcDopdBJFY0yGuE/bBgUOqfLS2bATdGacHgoiaZ7QaOb+7khxqNQ
49E1liPVALWeZ+V/WTnRw46VMxImgsw/ChKOdISyzVGPSUo0HxvARDIzKyIDLDHR
5j4FcwRneVaFyWnUq58nBVqp7DXHk4gVO4AeuoQr3UAMXCDB4gheYWsJ6t6s
93lpzlr0HMfWR8/QVeSuw=</latexit>
vTw
NkFo23ys0SQn3kCA=">AB7HicbZDNTgIxFIXv4B/iH+rSTSPRuCIzxqA7Sdy4x
IQBEpiQTulAQ6czaTsYMuEZ3LgQjVvfxa0738YOsFDwJE2+nHNveu/1Y86Utu1vK7
e2vrG5ld8u7Ozu7R8UD48aKkokoS6JeCRbPlaUM0FdzTSnrVhSHPqcNv3hXZY3R1
QqFom6HsfUC3FfsIARrI3ljlAdPXaLJbtsz4RWwVlA6fZzmum1i1+dXoRSUIqNOF
YqbZjx9pLsdSMcDopdBJFY0yGuE/bBgUOqfLS2bATdGacHgoiaZ7QaOb+7khxqNQ
49E1liPVALWeZ+V/WTnRw46VMxImgsw/ChKOdISyzVGPSUo0HxvARDIzKyIDLDHR
5j4FcwRneVaFyWnUq58nBVqp7DXHk4gVO4AeuoQr3UAMXCDB4gheYWsJ6t6s
93lpzlr0HMfWR8/QVeSuw=</latexit>
vTw
A0
9rAkYVMFWuTfJ2Eg=">AB7XicbZDLTgIxFIbP4A3xhrp0i8rMiMehOEjcuM
eGWwIR0SoFKp520HRIy4R3cuIAYtz6LW3e+jR1goeifNPny/+ek5wg4kwb1/1yMm
vrG5tb2e3czu7e/kH+8KiuZawIrRHJpWoGWFPOBK0ZjhtRoriMOC0EQzv07wxok
ozKapmHFE/xH3BeoxgY616fIGqaNTJF9yiOxf6C94SCncf01SzSif/2e5KEodUGMK
x1i3PjYyfYGUY4XSa8eaRpgMcZ+2LAocUu0n82kn6Mw6XdSTyj5h0Nz92ZHgUOt
xGNjKEJuBXs1S87+sFZverZ8wEcWGCrL4qBdzZCRKV0dpigxfGwBE8XsrIgMsMLE
2APl7BG81ZX/Qv2q6JWKpcfrQvkcFsrCZzCJXhwA2V4gArUgMATPMUZo50XpxX
521RmnGWPcfwS87N59kuo=</latexit>
u0Tv
kEnikKd8Re1inZrs=">AB6HicbZDJTgJBEIZrcEPcUI9eOhKNJzJj3G6SePEIi
SwJTEhPUwMtPUu6ezSE8ARePGgMHn0LX8Ob2MPcFDwTzr58v9V6aryYsGVtu1vK7
O0vLK6l3PbWxube/kd/dqKkokwyqLRCQbHlUoeIhVzbXARiyRBp7Aute/SfP6A0
rFo/BOD2J0A9oNuc8Z1caqPLbzBbtoT0QWwZlB4fpznOq93M5/tToRSwIMNRNUqaZ
jx9odUqk5EzjKtRKFMWV92sWmwZAGqNzhZNAROTJOh/iRNC/UZOL+7hjSQKlB4Jn
KgOqems9S87+smWj/yh3yME40hmz6kZ8IoiOSbk06XCLTYmCAMsnNrIT1qKRMm9vk
zBGc+ZUXoXZadC6K5WzQukYpsrCARzCThwCSW4hTJUgQHCE7zAq3VvPVtv1nha
mrFmPfvwR9bHDwFzkXg=</latexit> w
NkFo23ys0SQn3kCA=">AB7HicbZDNTgIxFIXv4B/iH+rSTSPRuCIzxqA7Sdy4x
IQBEpiQTulAQ6czaTsYMuEZ3LgQjVvfxa0738YOsFDwJE2+nHNveu/1Y86Utu1vK7
e2vrG5ld8u7Ozu7R8UD48aKkokoS6JeCRbPlaUM0FdzTSnrVhSHPqcNv3hXZY3R1
QqFom6HsfUC3FfsIARrI3ljlAdPXaLJbtsz4RWwVlA6fZzmum1i1+dXoRSUIqNOF
YqbZjx9pLsdSMcDopdBJFY0yGuE/bBgUOqfLS2bATdGacHgoiaZ7QaOb+7khxqNQ
49E1liPVALWeZ+V/WTnRw46VMxImgsw/ChKOdISyzVGPSUo0HxvARDIzKyIDLDHR
5j4FcwRneVaFyWnUq58nBVqp7DXHk4gVO4AeuoQr3UAMXCDB4gheYWsJ6t6s
93lpzlr0HMfWR8/QVeSuw=</latexit>
vTw
3rKzXRQGa+eW/G+8=">AB6HicdZDLSsNAFIYn9VbrerSzWBRXIU0rWldWXDjs
oXeoA1lMp20YyeTMDMRSugTuHGhSF36Nm7d+TZOWgUV/WHg5/vPYc45XsSoVJb1bm
RWVtfWN7Kbua3tnd29/P5BW4axwKSFQxaKrockYZSTlqKkW4kCAo8Rjre5CrNO7
dESBrypGxA3QiFOfYqQ0ajQH+YJlXlQd+9yGlmlZFbvkpMaulO0SLGqSqnD5Ok/
1XB/k3/rDEMcB4QozJGWvaEXKTZBQFDMy/VjSKEJ2hEetpyFBDpJotBZ/BEkyH
0Q6EfV3Bv3ckKJByGni6MkBqLH9nKfwr68XKr7oJ5VGsCMfLj/yYQRXCdGs4pIJg
xabaICyonhXiMRIK32bnD7C16bwf9O2zaJjOo1yoXYKlsqCI3AMzkARVEANXIM6
aAEMCLgD+DRuDHujSdjvizNGJ89h+CHjJcPRVKRqg=</latexit>
T
3rKzXRQGa+eW/G+8=">AB6HicdZDLSsNAFIYn9VbrerSzWBRXIU0rWldWXDjs
oXeoA1lMp20YyeTMDMRSugTuHGhSF36Nm7d+TZOWgUV/WHg5/vPYc45XsSoVJb1bm
RWVtfWN7Kbua3tnd29/P5BW4axwKSFQxaKrockYZSTlqKkW4kCAo8Rjre5CrNO7
dESBrypGxA3QiFOfYqQ0ajQH+YJlXlQd+9yGlmlZFbvkpMaulO0SLGqSqnD5Ok/
1XB/k3/rDEMcB4QozJGWvaEXKTZBQFDMy/VjSKEJ2hEetpyFBDpJotBZ/BEkyH
0Q6EfV3Bv3ckKJByGni6MkBqLH9nKfwr68XKr7oJ5VGsCMfLj/yYQRXCdGs4pIJg
xabaICyonhXiMRIK32bnD7C16bwf9O2zaJjOo1yoXYKlsqCI3AMzkARVEANXIM6
aAEMCLgD+DRuDHujSdjvizNGJ89h+CHjJcPRVKRqg=</latexit>
T
q8oOmZkJRSbSOu0s=">AB6nicdZDLSgMxFIYz9VbrerSTbAoroZMtbVdWXHjs
qK9QDuUTJpQzOZIckIZegjuHGhVLe+hK/hzrcx0yqo6A+Bj/8/h5xzvIgzpRF6tz
ILi0vLK9nV3Nr6xuZWfnunqcJYEtogIQ9l28OKciZoQzPNaTuSFAcepy1vdJHmrV
sqFQvFjR5H1A3wQDCfEayNdX3eQ718AdmoXKqiKkR2CTmVGSBUrhSPoWMgVeHsdZr
qd7Lv3X7IYkDKjThWKmOgyLtJlhqRjid5LqxohEmIzygHYMCB1S5yWzUCTwTh/
6oTRPaDhzv3ckOFBqHimMsB6qH5nqflX1om1X3ETJqJYU0HmH/kxhzqE6d6wzyQl
mo8NYCKZmRWSIZaYaHOdnDnC16bwf2gWbadsl65OCrVDMFcW7IF9cAQcApq4BLU
QMQMAB34AE8Wty6t6bW87w0Y327Ifsl4+ADoEkiw=</latexit> A0
A0
q8oOmZkJRSbSOu0s=">AB6nicdZDLSgMxFIYz9VbrerSTbAoroZMtbVdWXHjs
qK9QDuUTJpQzOZIckIZegjuHGhVLe+hK/hzrcx0yqo6A+Bj/8/h5xzvIgzpRF6tz
ILi0vLK9nV3Nr6xuZWfnunqcJYEtogIQ9l28OKciZoQzPNaTuSFAcepy1vdJHmrV
sqFQvFjR5H1A3wQDCfEayNdX3eQ718AdmoXKqiKkR2CTmVGSBUrhSPoWMgVeHsdZr
qd7Lv3X7IYkDKjThWKmOgyLtJlhqRjid5LqxohEmIzygHYMCB1S5yWzUCTwTh/
6oTRPaDhzv3ckOFBqHimMsB6qH5nqflX1om1X3ETJqJYU0HmH/kxhzqE6d6wzyQl
mo8NYCKZmRWSIZaYaHOdnDnC16bwf2gWbadsl65OCrVDMFcW7IF9cAQcApq4BLU
QMQMAB34AE8Wty6t6bW87w0Y327Ifsl4+ADoEkiw=</latexit> A0
q8oOmZkJRSbSOu0s=">AB6nicdZDLSgMxFIYz9VbrerSTbAoroZMtbVdWXHjs
qK9QDuUTJpQzOZIckIZegjuHGhVLe+hK/hzrcx0yqo6A+Bj/8/h5xzvIgzpRF6tz
ILi0vLK9nV3Nr6xuZWfnunqcJYEtogIQ9l28OKciZoQzPNaTuSFAcepy1vdJHmrV
sqFQvFjR5H1A3wQDCfEayNdX3eQ718AdmoXKqiKkR2CTmVGSBUrhSPoWMgVeHsdZr
qd7Lv3X7IYkDKjThWKmOgyLtJlhqRjid5LqxohEmIzygHYMCB1S5yWzUCTwTh/
6oTRPaDhzv3ckOFBqHimMsB6qH5nqflX1om1X3ETJqJYU0HmH/kxhzqE6d6wzyQl
mo8NYCKZmRWSIZaYaHOdnDnC16bwf2gWbadsl65OCrVDMFcW7IF9cAQcApq4BLU
QMQMAB34AE8Wty6t6bW87w0Y327Ifsl4+ADoEkiw=</latexit> A0
✓2 1
1
q8oOmZkJRSbSOu0s=">AB6nicdZDLSgMxFIYz9VbrerSTbAoroZMtbVdWXHjs
qK9QDuUTJpQzOZIckIZegjuHGhVLe+hK/hzrcx0yqo6A+Bj/8/h5xzvIgzpRF6tz
ILi0vLK9nV3Nr6xuZWfnunqcJYEtogIQ9l28OKciZoQzPNaTuSFAcepy1vdJHmrV
sqFQvFjR5H1A3wQDCfEayNdX3eQ718AdmoXKqiKkR2CTmVGSBUrhSPoWMgVeHsdZr
qd7Lv3X7IYkDKjThWKmOgyLtJlhqRjid5LqxohEmIzygHYMCB1S5yWzUCTwTh/
6oTRPaDhzv3ckOFBqHimMsB6qH5nqflX1om1X3ETJqJYU0HmH/kxhzqE6d6wzyQl
mo8NYCKZmRWSIZaYaHOdnDnC16bwf2gWbadsl65OCrVDMFcW7IF9cAQcApq4BLU
QMQMAB34AE8Wty6t6bW87w0Y327Ifsl4+ADoEkiw=</latexit> A0
A0
u0
u0
dgOHwtUpMgBTcG8=">AB6XicdZDLSgMxFIYz9VbrerSTbB4WQ2Zamu7suDGZ
RV7gXYomThmYyQ5IRytA3cONC0W59Cl/DnW9jplVQ0R8CH/9/DjneBFnSiP0bm
UWFpeWV7KrubX1jc2t/PZOU4WxJLRBQh7KtocV5UzQhma03YkKQ48Tlve6CLNW7
dUKhaKGz2OqBvgWA+I1gb6zo+6uULyEblUhVIbJLyKnMAKFypXgCHQOpCuevz6m
m9V7+rdsPSRxQoQnHSnUcFGk3wVIzwuk140VjTAZ4QHtGBQ4oMpNZpNO4IFx+tA
PpXlCw5n7vSPBgVLjwDOVAdZD9TtLzb+yTqz9ipswEcWaCjL/yI851CFM14Z9JinR
fGwAE8nMrJAMscREm+PkzBG+NoX/Q7NoO2W7dHVaqB2CubJgD+yDY+CAM1ADl6AO
GoAH9yB/Bojax768mazksz1mfPLvgh6+UDxdOR7g=</latexit>
u0
✓1 1
1
QKC3pvfR03H/WJG4=">AB+3icdVBNS0JBFJ1nX2ZfZs2Q1K0CJlnabpKaNPSI
D9ATeaNow7O+2Dmvkge/pBatGlRNt+RNt2/ZvmaUFHbhwOde7r3HCaTQMi7lZ
ibX1hcSi6nVlbX1jfSm5m69kPFeI350ldNh2ouhcdrIEDyZqA4dR3JG87oNPYbV1
xp4XsXMA54x6UDT/QFo2CkbjrThiEHehnZ7QOcj2vSTWdJjhQLZVLGJFcgdmlKCm
W8ofYNiRG9uT1JsZtZt+a/d8FrcAyap1i2bBNCJqALBJ+k2qHmAWUjOuAtQz3
qct2JprdP8K5RerjvK1Me4Kn6fSKirtZj1zGdLoWh/u3F4l9eK4R+qRMJLwiBe2y2
qB9KD6Og8A9oTgDOTaEMiXMrZgNqaIMTFwpE8LXp/h/Us/n7GKucH6UreyhGZJo
G+2gfWSjY1RBZ6iKaoiha3SHtCjNbHurSfredasD5ntAPWC8fhwiX4A=</lat
exit>
✓1 2 2
uLm3C58hCltZvCkU=">AB+XicdVDLSgNBEOz1GeNr1aOXwaB4kDAbTUxOCl48K
hgNJDHMTibJkNkHM72BsORPvHhQxKt/4s2/8BOcJAoqWtBQVHXT3eXHShqk9M2ZmZ
2bX1jMLGWXV1bX1t2NzWsTJZqLKo9UpGs+M0LJUFRohK1WAsW+Erc+P2zsX8zEN
rIKLzCYSyaAeuGsiM5Qyu1XLeBPYGs5d2mhcYBKYxabo7malYoRVC80XqlSeE0lK
5cEg8S8bInbzDBct97XRjngSiBC5YsbUPRpjM2UaJVdilG0kRsSM91lX1C0NWSB
M51cPiK7VmTqRthUgm6veJlAXGDAPfdgYMe+a3Nxb/8uoJdsrNVIZxgiLk0Wd
RBGMyDgG0pZacFRDSxjX0t5KeI9pxtGlbUhfH1K/ifXhbxXyhcvj3Kne9M0IAPb
sAP74MExnMI5XEAVOAzgDh7g0Umde+fJeZ62zjifM1vwA87LByeilBM=</latexit
>
✓2 2
1
A0
A0
dgOHwtUpMgBTcG8=">AB6XicdZDLSgMxFIYz9VbrerSTbB4WQ2Zamu7suDGZ
RV7gXYomThmYyQ5IRytA3cONC0W59Cl/DnW9jplVQ0R8CH/9/DjneBFnSiP0bm
UWFpeWV7KrubX1jc2t/PZOU4WxJLRBQh7KtocV5UzQhma03YkKQ48Tlve6CLNW7
dUKhaKGz2OqBvgWA+I1gb6zo+6uULyEblUhVIbJLyKnMAKFypXgCHQOpCuevz6m
m9V7+rdsPSRxQoQnHSnUcFGk3wVIzwuk140VjTAZ4QHtGBQ4oMpNZpNO4IFx+tA
PpXlCw5n7vSPBgVLjwDOVAdZD9TtLzb+yTqz9ipswEcWaCjL/yI851CFM14Z9JinR
fGwAE8nMrJAMscREm+PkzBG+NoX/Q7NoO2W7dHVaqB2CubJgD+yDY+CAM1ADl6AO
GoAH9yB/Bojax768mazksz1mfPLvgh6+UDxdOR7g=</latexit>
u0
u0
C3
e64="yDygtg7+reBxLIEtXsv6nPHJlrE
=">AB/HicbVC7SgNBFJ2NrxhfqyltB
oNiIWFXfHUGbCwjmAdklzA7uUmGzM4uM
7NCWOJ/aGNjoYit/2Br5984m6TQxAMDh3
Pu4d45QcyZ0o7zbeUWFpeWV/KrhbX1jc
0te3unrqJEUqjRiEeyGRAFnAmoaY5NG
MJAw4NILBVeY37kAqFolbPYzBD0lPsC
6jRBupbRe9RHRAZvGUjrB3hClt2yWn7Iy
B54k7JaXLz4cMj9W2/eV1IpqEIDTlRKm
W68TaT4nUjHIYFbxEQUzogPSgZagISg
/HR8/wvtG6eBuJM0TGo/V34mUhEoNw8B
MhkT31ayXif95rUR3L/yUiTjRIOhkUTfh
WEc4awJ3mASq+dAQiUzt2LaJ5JQbfoq
mBLc2S/Pk/px2T0rn96clCoHaI82kV7
6BC56BxV0DWqohqiaIie0At6te6tZ+vN
ep+M5qxpoj+wPr4AWYImQE=</latexit
> c cc
↵3 3
1
e64="Co4/ITWXbgxq/cNjAeb1+gK1Vg
=">AB6nicbZDLSgMxFIbPeK31VnXpJ
lgUV2VGvO2suHFZ0V6gHUomzbShSWZIM
kIZ+ghuXCjVrS/ha7jzbcy0XWjrD4GP/z
+HnHOCmDNtXPfbWVhcWl5Zza3l1zc2t7
YLO7s1HSWK0CqJeKQaAdaUM0mrhlOG7
GiWASc1oP+TZbXH6nSLJIPZhBTX+CuZC
Ej2Fjr/rtgtFt+SOhebBm0Lx6nOU6a3
SLny1OhFJBJWGcKx103Nj46dYGUY4HeZ
biaYxJn3cpU2LEguq/XQ86hAdWqeDwkj
ZJw0au787Uiy0HojAVgpseno2y8z/smZ
iwks/ZTJODJVk8lGYcGQilO2NOkxRYvjA
AiaK2VkR6WGFibHXydsjeLMrz0PtpOSd
l87uTovlI5goB/twAMfgwQWU4RYqUAUC
XiCF3h1uPsjJz3SemCM+3Zgz9yPn4A
0wKR5Q=</latexit> A0
u0Tv
γ3 3
kEnikKd8Re1inZrs=">AB6HicbZDJTgJBEIZrcEPcUI9eOhKNJzJj3G6SePEIi
SwJTEhPUwMtPUu6ezSE8ARePGgMHn0LX8Ob2MPcFDwTzr58v9V6aryYsGVtu1vK7
O0vLK6l3PbWxube/kd/dqKkokwyqLRCQbHlUoeIhVzbXARiyRBp7Aute/SfP6A0
rFo/BOD2J0A9oNuc8Z1caqPLbzBbtoT0QWwZlB4fpznOq93M5/tToRSwIMNRNUqaZ
jx9odUqk5EzjKtRKFMWV92sWmwZAGqNzhZNAROTJOh/iRNC/UZOL+7hjSQKlB4Jn
KgOqems9S87+smWj/yh3yME40hmz6kZ8IoiOSbk06XCLTYmCAMsnNrIT1qKRMm9vk
zBGc+ZUXoXZadC6K5WzQukYpsrCARzCThwCSW4hTJUgQHCE7zAq3VvPVtv1nha
mrFmPfvwR9bHDwFzkXg=</latexit> w
c db
3rKzXRQGa+eW/G+8=">AB6HicdZDLSsNAFIYn9VbrerSzWBRXIU0rWldWXDjs
oXeoA1lMp20YyeTMDMRSugTuHGhSF36Nm7d+TZOWgUV/WHg5/vPYc45XsSoVJb1bm
RWVtfWN7Kbua3tnd29/P5BW4axwKSFQxaKrockYZSTlqKkW4kCAo8Rjre5CrNO7
dESBrypGxA3QiFOfYqQ0ajQH+YJlXlQd+9yGlmlZFbvkpMaulO0SLGqSqnD5Ok/
1XB/k3/rDEMcB4QozJGWvaEXKTZBQFDMy/VjSKEJ2hEetpyFBDpJotBZ/BEkyH
0Q6EfV3Bv3ckKJByGni6MkBqLH9nKfwr68XKr7oJ5VGsCMfLj/yYQRXCdGs4pIJg
xabaICyonhXiMRIK32bnD7C16bwf9O2zaJjOo1yoXYKlsqCI3AMzkARVEANXIM6
aAEMCLgD+DRuDHujSdjvizNGJ89h+CHjJcPRVKRqg=</latexit>
T
γ3 3
0
C4
↵3 4
1
A0
γ3 4
u0Tv
δ3 4
0
T
NkFo23ys0SQn3kCA=">AB7HicbZDNTgIxFIXv4B/iH+rSTSPRuCIzxqA7Sdy4x
IQBEpiQTulAQ6czaTsYMuEZ3LgQjVvfxa0738YOsFDwJE2+nHNveu/1Y86Utu1vK7
e2vrG5ld8u7Ozu7R8UD48aKkokoS6JeCRbPlaUM0FdzTSnrVhSHPqcNv3hXZY3R1
QqFom6HsfUC3FfsIARrI3ljlAdPXaLJbtsz4RWwVlA6fZzmum1i1+dXoRSUIqNOF
YqbZjx9pLsdSMcDopdBJFY0yGuE/bBgUOqfLS2bATdGacHgoiaZ7QaOb+7khxqNQ
49E1liPVALWeZ+V/WTnRw46VMxImgsw/ChKOdISyzVGPSUo0HxvARDIzKyIDLDHR
5j4FcwRneVaFyWnUq58nBVqp7DXHk4gVO4AeuoQr3UAMXCDB4gheYWsJ6t6s
93lpzlr0HMfWR8/QVeSuw=</latexit>
vTw
✓1 2
1
✓3 1
1
u0
✓1 1
1
u0
\2 1
1
Figure 7: Illustration of the reduction from q4 to q. The black arrows starting from the
same node correspond to a block of the first kind. The red arrows and the green
arrows correspond to the blocks of the second and third kind respectively. Some
domain elements are represented twice (with the same name, like θ21
1 ) to declutter
the figure.
Further, for every maximal clique Ct containing at least two facts in different blocks, and
for every facts h, g ∈Ct where h, g are in blocks Bs1, Bs2, with s1̸ = s2, add the following
facts to D′:
A0(θs1s2t θs1t
1 ) A1(θs1t
1
θs1t
2 ) . . . Ai(θs1t
i
γs1t)
|
{z
}
u′
T(γs1t γs1t
0 ) A′′
0(γs1t
0
γs1t
1 )A′′
1(γs1t
1
γs1t
2 ) . . . A′′
k(γs1t
k
γs1t
k+1)
|
{z
}
w
A0(θs1s2t θs2t
1 ) A1(θs2t
1
θs2t
2 ) . . . Ai(θs2t
i
γs2t)
|
{z
}
u′
T(γs2t γs2t
0 ) A′′
0(γs2t
0
γs2t
1 )A′′
1(γs2t
1
γs2t
2 ) . . . A′′
k(γs2t
k
γs2t
k+1)
|
{z
}
w
This concludes the constructions of D′, we refer to Figure 7 for an illustration. Notice
that most blocks of D′ have size one except for three kinds. The first kind are A0-blocks

---

Vol. 21:1
A SIMPLE ALGORITHM FOR CQA UNDER PRIMARY KEYS
18:37
with key αs for some block Bs of D. These blocks are in one-to-one correspondence with the
blocks of D and contain as many facts as there are cliques in D intersecting the block. The
second kind are T-blocks whose key is γst for some block Bs and maximal clique Ct where
Ct is not a self-loop. These blocks contain at most two facts, one that starts a path TvTw
and one that starts a path Tw. The third and last kind are A0-blocks whose key is θs1s2t
where two facts from Bs1 and Bs2, s1̸ = s2, form a solution and belong to the non-self-loop
clique Ct. These blocks have two facts, each of them starting a path u reaching a block of
the second kind. The blocks of size one play no role in the rest of this proof.
We now prove that D′ has the desired properties.
(1) Suppose D |= certain(q4). Now pick any repair r′ of D′. Define the following repair r on
D:
For any A0-block in D′ of the first kind, pick a corresponding fact in D. i.e., if
A0(αs αst
1 ) ∈r′ then choose R(a bc) for r, where R(a bc) is any fact in block Bs that
belongs to the maximal clique Ct.
Now r is a repair of D since every R-block Bs in D corresponds to an A0-block of the
first kind. By assumption r |= q4 hence there exists facts h, g that belong to blocks Bs1
and Bs2 and also belong to the same clique Ct such that h, g ∈r.
Assume first that h = g, hence s1 = s2 and Ct is a self-loop. By construction of r this
implies that A0(αs αst
1 ) belongs to r′ and by construction of D′, as Ct is a self-loop all
repairs of D containing A0(αs αst
1 ) have a solution to q.
Assume now that h̸ = g. As r is a repair this implies s1̸ = s2. This implies that
both A0(αs1 αs1t
1 ) and A0(αs2 αs2t
1 ) are in r′. Consider now the block of the third kind
whose key is θs1s2t. The repair r′ must contain a fact from this block. Without loss of
generality we assume that it is the fact that starts a path u reaching γs1t, the key of
a block of the second kind. The repair r′ must contain a fact from this block, either
starting a path Tw or a path TvTw. In the first case the query q is true because of the
path starting with A0(αs1 αs1t
1 ); in the second case the query q is true because of the
path starting with the A0-fact of key θs1s1t.
(2) Assume that for some k, D′ |= Certk(q). We show that D |= Cert+
k(q4).
In order to show this, for every k-set S of facts of D′ we relate k-set bS of D such that
the following conditions hold:
(a) If A0(αsαst
1 ) ∈S then bS contains a fact h that belongs to both the block Bs and
the clique Ct.
(b) If T(γstδst
0 ) ∈S then bS contains a fact h that belongs to both the block Bs and
the clique Ct.
(c) If T(γstγst
0 ) ∈S and h is the fact that belongs to both the block Bs and the clique Ct
then bS contains one fact g that belongs the clique Ct such that D |= q4(gh)∨q4(hg).
By construction this is always possible.
(d) If A0(θs1s2tθst
1 ) ∈S. Recall that this can only happen if s1̸ = s2 and s = s1 or
s = s2. Let h1 be one fact that belongs to both the block Bs1 and the clique Ct,
and h2 be one fact that belongs to both the block Bs2 and the clique Ct. Then bS
contains h1 if s = s2 and h2 if s = s1.
Note that for every k-set S of facts of D′ there may be several k-set bS of D that
satisfy the conditions.

---

18:38
D. Figueira, A. Padmanabha, L. Segoufin, and C. Sirangelo
Vol. 21:1
We claim that if S ∈∆k(q, D′) then all associated bS are in ∆+
k (q4, D). In particular, as
D′ |= Certk(q) then by definition the empty set is in ∆k(q, D′), and therefore it is also in
∆+
k (q4, D), hence D |= Cert+
k(q4) as desired.
The proof of the claim is by induction on the iteration where S is added to ∆k(q, D′).
The base case is when S ∈∆k(q, D′, 0). Then S contains a solution in q(D′). By
construction, as q is not a factor of uTvTvTw, this can only happen if S contains both
A0(αsαst
1 ) and T(γstγst
0 ) or S contains both A0(θs1s2tθst
1 ) and T(γstδst
0 ). In the first case
any associated bS by definition contains two facts h and g (possibly equal) of D such that h
is in the block Bs and clique Ct and g also belongs to the clique Ct and D |= q4(hg) ∨q4(gh)
(by properties (a) and (c)). In either case, we have bS ∈∆+
k (q4, D, 0).
In the second case, by definition, all associated bS contain two distinct facts h and g
of D such that h is in the block Bs1 and clique Ct and g belongs to the “block” Bs2 and
also to the clique Ct (using properties (b) and (d)). In particular D |= q4(hg) ∨q4(gh) and
bS ∈∆+
k (q4, D, 0).
Assume now that S ∈∆k(q, D′, i) for some i > 0. By definition this is because there
exists a block B′ of D′ such that for all b ∈B′, S ∪{b} contains a k-set in ∆k(q, D′, i −1).
By induction, this implies that for all b′ ∈B′, ÿ S ∪{b′} contains a k-set in ∆+
k (q4, D, i −1).
We do a case analysis depending on B′.
(1) B′ is a block of the first kind: it contains all elements A0(αsαst
1 ) for some block B = Bs.
Then B can be used to show that bS belongs to ∆+
k (q4, D, i). Indeed consider b ∈B,
let t be such that b ∈Ct and consider b′ = A0(αsαst
1 ). From the fact that ÿ S ∪{b′}
contains a k-set in ∆k(q4, D, i −1) it follows by induction that bS ∪{b} contains a k-set
in ∆+
k (q4, D, i −1). Hence, bS ∈∆+
k (q4, D, i) as desired.
(2) B′ is a block of the second kind: it contains T(γstγst
0 ) and T(γstδst
0 ). Let h be a fact of D
in block Bs and clique Ct and let g, p be the other facts in Ct (possibly g = p, but as Ct
cannot be a self-loop we assume g and h to be in distinct blocks). Notice that by definition
{T(γstγst
0 )} is associated to both {g} and {p} while {T(γstδst
0 )} is associated to {h}. Now
since S ∪{T(γstγst
0 )} ∈∆k(q, D, i −1) we have by induction, ˆS ∪{g} ∈∆+
k (q4, D, i −1)
and ˆS ∪{p} ∈∆+
k (q4, D, i −1). Further, S ∪{T(γstδst
0 )} ∈∆k(q, D, i −1) implies that
ˆS ∪{h} ∈∆+
k (q4, D, i −1). Thus the clique Ct is a witness for bS ∈∆+
k (q4, D, i) by
application of the new rule.
(3) B′ is a block of the third kind: it contains A0(θs1s2tθs1t
1 ) and A0(θs1s2tθs2t
1 ). Let h, g and
p be the facts that are in clique Ct and respectively in the blocks Bs1 and Bs2 and Bs3
(possibly g = p). Notice that by definition {A0(θs1s2tθs1t
1 )} is associated to both g and
p, while {A0(θs1s2tθs2t
1 )} is associated to h and p. As in the previous case, we obtain by
induction that bS ∪{x} ∈∆k(q4, D′) for all x ∈{h, g, p}. Therefore, the clique Ctis a
witness for bS ∈∆+
k (q4, D, i) by application of the new rule.
(4) B′ is a block of size one, i.e., containing one fact b′. By induction hypothesis ÿ S ∪{b′}
contains a k-set in ∆k(q4, D). Moreover, by construction ÿ S ∪{b′} = bS. Hence bS ∈
∆k(q4, D) as desired.
This concludes the induction step, hence the proof.

---

Vol. 21:1
A SIMPLE ALGORITHM FOR CQA UNDER PRIMARY KEYS
18:39
7. First order definability
Let q be a query. We say that certain(q) is in FO if there is a first-order sentence φ such
that for all database D, D |= certain(q) iff D |= φ. For instance, the query certain(q1) is in
FO where q1 is described in Example 2.2.
The goal of this section is to provide a characterization of queries whose certainty can
be expressed in FO in terms of the Certk algorithm, assuming q is either self-join-free or a
path query. Notice that if certain(q) is in FO then in particular it can be solved in AC0 and
therefore cannot be coNP-hard. It then follows from our results that it can be solved by
our fixpoint algorithm Certk(q) for some k.
Recall the definition of Certk(q). It computes in an inflationary way a set ∆k(q, D) of
k-sets satisfying a certain property, where the property can be specified in first-order logic.
Starting from the solutions to q in D, at each step it adds to ∆k(q, D) a new set of k-sets
satisfying a first-order property. Let ∆k(q, D, i) be the set of k-sets computed this way after
i iterations. Hence ∆k(q, D, 0) the set of solutions to q in D and S
i ∆k(q, D, i) is the set of
k-sets obtained when the fixpoint is reached. By definition, Certk(q) returns ‘yes’ if this set
contains the empty set.
As every step can be defined in first-order logic, each set ∆k(q, D, i) can be defined using
a first-order formula. Let ψi,k(q) be the first-order sentence such that D |= ψi,k(q) if and
only if ∆k(q, D, i) contains the empty set. It is clearly an under-approximation of Certk(q)
and therefore of certain(q). Whenever Certk(q) is equivalent to ψi,k(q) for some i depending
only on q and k, we say that Certk(q) is bounded.6 We show that whenever certain(q) is in
FO then Certk(q), with k the number of atoms of q, is bounded and computes certain(q).
Example 7.1. Recall the query q1 = R1(x y) ∧R2(y z) from Example 2.2. We showed
there that certain(q1) can be expressed in FO. We verify that for k = 2, for any database D,
if D |= certain(q1) then ∅∈∆2(q1, D, 2).
First note that ∆2(q1, D, 0) contains sets of the form {R1(a b), R2(b c)} which are the
solutions to q1. Notice that if {R1(a b), R2(b c)} ∈∆2(q1, D, 0) then for all R2(b c′) ∼R2(b c)
we have {R1(a b), R2(b c′)} ∈∆2(q1, D, 0). Hence for every {R1(a b), R2(b c)} ∈∆2(q1, D, 0)
we have {R1(a b)} ∈∆2(q1, D, 1).
In particular for every minimal repair r if r |= q(uv) then u ∈∆2(q1, D, 1). Now since r
is minimal, for every u′ ∼u there exists some v′ ∈r such that r[u →u′] |= q(u′v′). This
implies that for every u′ ∼u we have u′ ∈∆2(q1, D, 1). Hence ∅∈∆2(q1, D, 2) as required.
△
7.1. Self-join-free case. In this case we make use of the following characterization
of [KW17] based on the notion of attack graph.
Theorem 7.2 [KW17, Theorem 3.2]. Let q be a self-join-free query and Γ a set of primary
key constraints. The attack graph of q and Γ is acyclic iff certain(q) is in FO.
We obtain the following:
Proposition 7.3. Let q be a self-join-free query and Γ a set of primary key constraints.
Let k be the number of atoms of q. The following are equivalent:
(1) The attack graph of q and Γ is acyclic.
6This notion is sometimes referred to in the literature as “goal bounded”.

---

18:40
D. Figueira, A. Padmanabha, L. Segoufin, and C. Sirangelo
Vol. 21:1
(2) Certk(q) is bounded and Certk(q) = certain(q).
(3) certain(q) is in FO.
Proof. (2) ⇒(3) This is an immediate consequence of boundedness.
(3) ⇒(1) This follows from Theorem 7.2.
(1) ⇒(2) Assume that the attack graph of q and Γ is acyclic. Let τ = A1, . . . , Ak be
any topological ordering of the atoms of q, i.e., if there is an attack from Ai to Aj then
i < j. As argued in the proof of Theorem 5.14, τ is a Γ-sequence and q |= PCondτ, therefore
Certk(q) = certain(q). Notice that τ is a Γ-sequence where all stable sets have size one.
We show that whenever we have such a Γ-sequence then Certk(q) is bounded. In order to
show this, we revisit the proof of Theorem 4.4. The key property that we used to prove
Theorem 4.4 was Lemma 4.5 showing that if Indi+1 and PCondτ(i) holds, then Indi also
holds, where
Indi = For all i-minimal repair s and facts ¯u s.t. s |= q≤i(¯u), we have ¯u ∈∆k(q, D).
When all stable sets in the Γ-sequence have size one, we can have a stronger version of
the induction step where Indi becomes
Ind+
i = For all i-minimal repair s and facts ¯u s.t. s |= q≤i(¯u), we have ¯u ∈∆k(q, D, k −i)
(recall that k is the number of atoms in q), and Lemma 4.5 becomes:
Claim 7.4. Given q, D and a Γ-sequence τ for q such that all stable sets of τ have size one.
Then for every 0 ≤i < k, if Ind+
i+1 and PCondτ(i), then Ind+
i .
Proof of claim. The proof is similar to the proof of Lemma 4.5, but simpler.
By means of contradiction, assume that Ind+
i+1 and PCondτ(i) hold but Ind+
i fails.
By definition, there is a i-minimal repair s and a tuple ¯u such that s |= q≤i(¯u) but
¯u̸ ∈∆k(q, D, k −i).
From Claim 4.6, we can assume that s is strong i-minimal.
As
s |= q≤i(¯u), there is a fact a matching Si+1 such that s |= q≤i+1(¯ua).
As ¯u̸ ∈∆k(q, D, k−i) there is by definition a fact a′ ∼a such that ¯ua′̸ ∈∆k(q, D, k−i−1).
By Claim 4.7 the repair s′ = s[a →a′] is strong i-minimal and s′ |= q(¯ua′ ¯β) for some tuple ¯β.
By assumption, the stable set Si+1 of τ contains only one atom hence a′ matches Si+1 hence
s′ |= q≤i+1(¯ua′). By Ind+
i+1 this implies that ¯ua′ ∈∆k(q, D, k −i −1), a contradiction.
◁
Therefore, by Claim 7.4 we conclude that Ind+
0 holds. This immediately implies that
whenever the empty set is derived, it is derived within k-steps. Then Certk(q) is equivalent
to ψk,k(q) and is therefore bounded; this proves Item (2).
7.2. Path queries. For path queries we rely on the following result of [KOW21].
Theorem 7.5 [KOW21, Theorem 3.2 & Lemma 7.1]. Let q be a path query. If q is a prefix
of all the words in the language L↬(q), then certain(q) is in FO. Otherwise, certain(q) is
NL-hard under FO reductions.
We obtain the following:
Proposition 7.6. Let q be a path query of length k. The following are equivalent.
(1) q is a prefix of all the words in the language L↬(q)
(2) Certk(q) is bounded and Certk(q) = certain(q).

---

Vol. 21:1
A SIMPLE ALGORITHM FOR CQA UNDER PRIMARY KEYS
18:41
(3) certain(q) is in FO.
To prove the proposition, we use the following result, which is a restatement of [KOW21,
Corollary 5.9] in the case where Item 1 holds.7
Proposition 7.7 [KOW21, Corollary 5.9]. Let q be a path query such that q is a prefix of
all the words in L↬(q). The following are equivalent for all database D.
• D |= certain(q)
• there exists a block B such that for all repair r of D, there exists a sequence of facts ¯v of
r such that r |= q(a¯v), where a is the fact of r in B.
Proof of Proposition 7.6. Item 2 ⇒Item 3 This is a consequence of boundedness.
Item 3 ⇒Item 1 Follows from Theorem 7.5.
Item 1 ⇒Item 2 . Assume Item 1 and assume that D |= certain(q), we show that ∅∈
∆k(q, D, k). This is a consequence of the following lemma that we show by induction on i.
Let B be the block of D given by Proposition 7.7. For a sequence of fact ¯v we denote by ¯vi
the first i facts of the sequence and ¯v[i] denotes the i-th fact of ¯v:
Lemma 7.8. For all i ∈[0, k −1], for all repair r and for all ¯v if r |= q(a¯v) with a ∈B
then a¯vi ∈∆k(q, D, k −i −1).
Proof. For i = k−1, this is clear (since q(a¯v) holds and ¯v = ¯vk−1). Assume now the property
shown for i + 1. We show it for i.
Consider a repair r. Let a = B ∩r. Let ¯v be such that r |= q(a¯v). Let b = ¯v[i + 1]. Let
b′ ∼b and r′ = r[b →b′]. By Proposition 7.7 there exists ¯v′ such that r′ |= q(a¯v′). As q is a
path query we have ¯v′
i = ¯vi. By induction we get that a¯vib′ ∈∆k(q, D, k −i −2). As b′ is
arbitrary, the block of b witnesses the fact that a¯vi ∈∆k(q, D, k −i −1).
Consider now an arbitrary fact a ∈B and any repair r containing a. By Proposition 7.7,
since D |= certain(q), there exists ¯v such that r |= q(a¯v). From Lemma 7.8, applied with
i = 0, we get that a ∈∆k(q, D, k −1). This implies that ∅∈∆k(q, D, k) as desired.
We have proved that D |= certain(q) implies ∅∈∆k(q, D, k).
On the other hand
∅∈∆k(q, D, k) implies ∅∈∆k(q, D) which in turn implies D |= certain(q). Then we
have D |= certain(q) iff ∅∈∆k(q, D) iff ∅∈∆k(q, D, k); the first equivalence implies
certain(q) = Certk(q), the second implies that Certk(q) is equivalent to ψk,k(q), and is
therefore bounded.
8. Conclusion
We have presented a simple polynomial time algorithm for certain query answering over
inconsistent databases under primary key constraints. The query is always certain when
the algorithm outputs “yes”, but it may produce false negative answers. For path queries
and self-join-free queries we have characterized the cases when our algorithm computes all
certain answers. In particular, when certainty is in polynomial time, the algorithm correctly
computes the answer. We have also shown that our fixpoint algorithm is bounded if, and
only if, the certainty of the query can be expressed in first-order logic.
7In fact, the condition assumed in Corollary 5.9 in [KOW21] is implied by Item 1.

---

18:42
D. Figueira, A. Padmanabha, L. Segoufin, and C. Sirangelo
Vol. 21:1
Throughout the paper we have only considered boolean queries. The algorithm can be
extended to the non-boolean setting as follows: if ¯x are the free variables of q, we compute
∆(q, D, ¯a) as for ∆(q, D) but always assigning ¯x to ¯a. The algorithm returns ¯a if ∆(q, D, ¯a)
eventually contains the empty set and if this happens ¯a is a certain answer. This still takes
polynomial time in data complexity. In the presence of constants we can use a similar
technique where the interpretation of the constants ¯c are fixed to ¯a (and we only need
one iteration if there are no free variables). Thus, the algorithm can be adapted to the
non-boolean setting as well.
Even though recent progress has been made, the Dichotomy Conjecture remains a
challenging problem. We add to the list of challenges a (decidable) characterization of
when our fixpoint algorithm correctly computes the certain answers. We believe this is an
interesting problem.
It is interesting to note that a similar fixpoint algorithm can be obtained for other kinds
of constraints. For instance for key constraints or “denial constraints” as defined in [CM05]
one can define a “conflict hypergraph” where each hyperedge is a minimal set of facts making
the constraint false. A “repair” in this context is a maximal independent set of the conflict
hypergraph and certainty can be computed in coNP. Notice that in the case of primary key
constraints, the conflict hypergraph is just a graph connecting any two facts that share the
same key. The connected components of this graph are then cliques, which correspond to
blocks. The inductive rule of the fixpoint then produces a new k-set S if there is a connected
component C of the conflict hypergraph such that for all facts b of C, S ∪{b} contains a
previously produced k-set. This clearly generalizes the current definition. However, the
properties of this algorithm under non-primary key constraints are yet to be studied.
It would also be interesting to see if the simplicity of our algorithm can be combined
with an optimal computational cost. For instance, for self-join-free queries satisfying PCond,
it is known that the complexity of the certain answering problem is in LogSpace. However
our fixpoint algorithm – which works for arbitrary queries, with or without self-joins – cannot
be evaluated in LogSpace. It is however plausible that, assuming self-join-freeness, simpler
rules can be used, providing a lower evaluation complexity. This is left for future work.
Acknowledgment
This work is supported by ANR QUID, grant ANR-18-CE40-0031.
References
[ABC99]
Marcelo Arenas, Leopoldo E. Bertossi, and Jan Chomicki. Consistent query answers in inconsistent
databases. In Victor Vianu and Christos H. Papadimitriou, editors, Proceedings of the Eighteenth
ACM SIGACT-SIGMOD-SIGART Symposium on Principles of Database Systems, May 31 - June
2, 1999, Philadelphia, Pennsylvania, USA, pages 68–79. ACM Press, 1999. doi:10.1145/303976.
303983.
[AK09]
Foto N. Afrati and Phokion G. Kolaitis. Repair checking in inconsistent databases: algorithms and
complexity. In Ronald Fagin, editor, Database Theory - ICDT 2009, 12th International Confer-
ence, St. Petersburg, Russia, March 23-25, 2009, Proceedings, volume 361 of ACM International
Conference Proceeding Series, pages 31–41. ACM, 2009. doi:10.1145/1514894.1514899.
[CM05]
Jan Chomicki and Jerzy Marcinkowski. Minimal-change integrity maintenance using tuple deletions.
Inf. Comput., 197(1-2):90–121, 2005. doi:10.1016/J.IC.2004.04.007.
[FM07]
Ariel Fuxman and Ren´ee J. Miller. First-order query rewriting for inconsistent databases. J.
Comput. Syst. Sci., 73(4):610–635, 2007. doi:10.1016/j.jcss.2006.10.013.

---

Vol. 21:1
A SIMPLE ALGORITHM FOR CQA UNDER PRIMARY KEYS
18:43
[FPSS23] Diego Figueira, Anantha Padmanabha, Luc Segoufin, and Cristina Sirangelo. A simple algorithm
for consistent query answering under primary keys. In 26th International Conference on Database
Theory, ICDT 2023, March 28-31, 2023, Ioannina, Greece, volume 255 of LIPIcs, pages 24:1–24:18.
Schloss Dagstuhl - Leibniz-Zentrum f¨ur Informatik, 2023. doi:10.4230/LIPICS.ICDT.2023.24.
[HK73]
John E. Hopcroft and Richard M. Karp. An n5/2 algorithm for maximum matchings in bipartite
graphs. SIAM J. Comput., 2(4):225–231, 1973. doi:10.1137/0202019.
[KOW21] Paraschos Koutris, Xiating Ouyang, and Jef Wijsen. Consistent query answering for primary keys
on path queries. In Leonid Libkin, Reinhard Pichler, and Paolo Guagliardo, editors, PODS’21:
Proceedings of the 40th ACM SIGMOD-SIGACT-SIGAI Symposium on Principles of Database
Systems, Virtual Event, China, June 20-25, 2021, pages 215–232. ACM, 2021. doi:10.1145/
3452021.3458334.
[KOW23] Paraschos Koutris, Xiating Ouyang, and Jef Wijsen. Consistent query answering for primary keys
on rooted tree queries. CoRR, abs/2310.19642, 2023. arXiv:2310.19642, doi:10.48550/ARXIV.
2310.19642.
[KP12]
Phokion G. Kolaitis and Enela Pema. A dichotomy in the complexity of consistent query answering
for queries with two atoms. Inf. Process. Lett., 112(3):77–85, 2012. doi:10.1016/j.ipl.2011.10.
018.
[KW17]
Paraschos Koutris and Jef Wijsen. Consistent query answering for self-join-free conjunctive
queries under primary key constraints. ACM Trans. Database Syst., 42(2):9:1–9:45, 2017. doi:
10.1145/3068334.
[KW18]
Paraschos Koutris and Jef Wijsen. Consistent query answering for primary keys and conjunctive
queries with negated atoms. In Jan Van den Bussche and Marcelo Arenas, editors, Proceedings of
the 37th ACM SIGMOD-SIGACT-SIGAI Symposium on Principles of Database Systems, Houston,
TX, USA, June 10-15, 2018, pages 209–224. ACM, 2018. doi:10.1145/3196959.3196982.
[KW20]
Paraschos Koutris and Jef Wijsen. First-order rewritability in consistent query answering with
respect to multiple keys. In Dan Suciu, Yufei Tao, and Zhewei Wei, editors, Proceedings of the
39th ACM SIGMOD-SIGACT-SIGAI Symposium on Principles of Database Systems, PODS
2020, Portland, OR, USA, June 14-19, 2020, pages 113–129. ACM, 2020. doi:10.1145/3375395.
3387654.
[KW21]
Paraschos Koutris and Jef Wijsen. Consistent query answering for primary keys in datalog. Theory
Comput. Syst., 65(1):122–178, 2021. doi:10.1007/s00224-020-09985-6.
[PSS24]
Anantha Padmanabha, Luc Segoufin, and Cristina Sirangelo. A dichotomy in the complexity of
consistent query answering for two atom queries with self-join. Proc. ACM Manag. Data, 2(2):74,
2024. doi:10.1145/3651137.
[Wij10]
Jef Wijsen. A remark on the complexity of consistent conjunctive query answering under primary
key violations. Inf. Process. Lett., 110(21):950–955, 2010. doi:10.1016/j.ipl.2010.07.021.
This work is licensed under the Creative Commons Attribution License. To view a copy of this
license, visit https://creativecommons.org/licenses/by/4.0/ or send a letter to Creative
Commons, 171 Second St, Suite 300, San Francisco, CA 94105, USA, or Eisenacher Strasse 2,
10777 Berlin, Germany

---

