# Tight Fine-Grained Bounds for Direct Access on Join Queries

> 来源: https://arxiv.org/pdf/2201.02401

arXiv:2201.02401v6  [cs.DB]  12 Dec 2024
Tight Fine-Grained Bounds for Direct Access on Join Qeries
KARL BRINGMANN, Saarland University and Max Planck Institute for Informatics, Germany
NOFAR CARMELI, LIRMM, Inria, University of Montpellier, CNRS, France
STEFAN MENGEL, Univ. Artois, CNRS, Centre de Recherche en Informatique de Lens (CRIL), France
We consider the task of lexicographic direct access to query answers. That is, we want to simulate an array
containing the answers of a join query sorted in a lexicographic order chosen by the user. A recent dichotomy
showed for which queries and orders this task can be done in polylogarithmic access time after quasilinear
preprocessing, but this dichotomy does not tell us how much time is required in the cases classiﬁed as hard.
We determine the preprocessing time needed to achieve polylogarithmic access time for all join queries and
all lexicographical orders. To this end, we propose a decomposition-based general algorithm for direct access
on join queries. We then explore its optimality by proving lower bounds for the preprocessing time based
on the hardness of a certain online Set-Disjointness problem, which shows that our algorithm’s bounds are
tight for all lexicographic orders on join queries. Then, we prove the hardness of Set-Disjointness based on the
Zero-Clique Conjecture which is an established conjecture from ﬁne-grained complexity theory. Interestingly,
while proving our lower bound, we show that self-joins do not aﬀect the complexity of direct access (up to
logarithmic factors). Our algorithm can also be used to solve queries with projections and relaxed order
requirements, though in these cases, its running time is not necessarily optimal. We also show that similar
techniques to those used in our lower bounds can be used to prove that, for enumerating answers to Loomis-
Whitney joins, it is not possible to signiﬁcantly improve upon trivially computing all answers at preprocessing.
This, in turn, gives further evidence (based on the Zero-Clique Conjecture) to the enumeration hardness of
self-join free cyclic joins with respect to linear preprocessing and constant delay.
Additional Key Words and Phrases: join queries, ﬁne-grained complexity, direct access, enumeration
1
INTRODUCTION
Algorithms for direct access allow to access answers to a query on a database essentially as if
they are materialized and stored in an array: given an index 푗∈N, the algorithm returns the
푗th answer (or an out-of-bounds error) in very little time. To make this possible, the algorithm
ﬁrst runs a preprocessing on the database that then allows answering arbitrary access queries
eﬃciently. As the number of answers to a database query may be orders-of-magnitude larger than
the size of the database, the goal is to avoid materializing all the answers during preprocessing
and only simulate the array.
The direct access task (previously also called 푗th answer and random access) was introduced by
Bagan et al. [10]. They also mentioned that this task can be used for uniform sampling (by ﬁrst
counting and drawing a random index) or for enumerating all query answers (by consecutively
accessing all indices). They devised an algorithm that runs in only linear preprocessing time and
average constant time per access call for a large class of queries (ﬁrst-order queries) on databases
of bounded degree. Direct access algorithms were also considered for queries in monadic second
order logic on databases of bounded treewidth [9]. To reason about general databases and still
expect extremely eﬃcient algorithms, another approach is to restrict the class of queries instead.
Follow-up work gave linear preprocessing and logarithmic access algorithms for subclasses of
Karl Bringmann: This work is part of the project TIPEA that has received funding from the European Research Council
(ERC) under the European Unions Horizon 2020 research and innovation programme (grant agreement No. 850979). Nofar
Carmeli and Stefan Mengel: This work has been funded by the French government under management of Agence Nationale
de la Recherche as part of the “Investissements d’avenir” program, reference ANR-19-P3IA-0001 (PRAIRIE 3IA Institute)
and by the ANR project EQUUS ANR-19-CE48-0019.
Authors’ addresses: Karl Bringmann, Saarland University and Max Planck Institute for Informatics, Saarland Informatics
Campus, Saarbrücken, Germany; Nofar Carmeli, LIRMM, Inria, University of Montpellier, CNRS, France; Stefan Mengel,
Univ. Artois, CNRS, Centre de Recherche en Informatique de Lens (CRIL), Lens, France.

---

2
Karl Bringmann, Nofar Carmeli, and Stefan Mengel
conjunctive queries over general databases [13, 19, 26]. There, it was also explained how direct
access can be used to sample without repetitions [19].
Though all of the algorithms we mentioned above simulate storing the answers in a lexico-
graphic order (whether they state it or not), one shortcoming they have in common is that the
speciﬁc lexicographic order cannot be chosen by the user (but rather it depends on the query
structure). Allowing the user to specify the order is desirable because then direct access can be
used for additional tasks that are sensitive to the order, such as median ﬁnding and boxplot com-
putation. Progress in this direction was recently made by Carmeli et al. [18] who identiﬁed which
combinations of a conjunctive query and a lexicographic order can be accessed with linear pre-
processing time and logarithmic access time. They identiﬁed an easy-to-check substructure of the
query, called disruptive trios, whose (non-)existence distinguishes the tractable cases (w.r.t. the
time guarantees we mentioned) from the intractable ones. In particular, if we consider acyclic join
queries, they suggested an algorithm that works for any lexicographic order that does not have
disruptive trios with respect to the query. If the join query is also self-join free, they proved con-
ditional lower bounds stating that for all other variable orders, direct access with polylogarithmic
direct access requires superlinear time preprocessing. These hardness results assume the hardness
of Boolean matrix multiplication. Given the known hardness of self-join free cyclic joins, if we
also assume the hardness of hyperclique detection in hypergraphs, this gives a dichotomy for all
self-join free join queries and lexicographic orders: they are tractable if and only if the query is
acyclic with no disruptive trio with respect to the order.
What happens if the query and order we want to compute happen to fall on the intractable side
of the dichotomy? Also, what is the role of self-joins in the complexity of direct access to join
queries? These questions were left open by previous work, and we aim to understand how much
preprocessing is needed to achieve polylogarithmic access time for each combination of query,
potentially containing self-joins, and order. To this end, we introduce disruption-free decomposi-
tions of a query with respect to a variable order. These can be seen as hypertree decompositions
of the queries, induced by the desired variable orders, that resolve incompatibilities between the
order and the query. Practically, these decompositions specify which relations should be joined
at preprocessing in order to achieve an equivalent acyclic join query with no disruptive trios. We
can then run the known direct access algorithm [18] with linear time preprocessing on the result
of this preprocessing to get an algorithm for the query and order at hand with logarithmic access
time. The cost of our preprocesing phase is therefore dominated by the time it takes to join the
selected relations. We deﬁne the incompatibility number of a query and order and show that the
preprocessing time of our solution is polynomial where the exponent is this number. Intuitively,
the incompatibility number is 1 when the query is acyclic and the order is compatible, and this
number grows as the incompatibility between the query and order grows.
Next, we aspire to know whether our solution can be improved. We show that, somewhat sur-
prisingly, self-joins have no inﬂuence whatsoever on the complexity of direct access to join queries:
if we change some relation symbols in a join query, this leaves the preprocessing and access times
unchanged up to polylogarithmic factors. Note that this is completely diﬀerent than the situa-
tion for related query evaluation tasks, in particular enumeration, where self-joins are known to
change the complexity [11, 17]. The situation for direct access is instead similar to that for count-
ing, where it is known that the complexity depends only on the underlying hypergraph, and thus
self-joins play no role in the complexity analysis [22]. In fact, our results regarding the elimina-
tion of self-joins in the case of direct access are obtained by adapting similar proofs for counting
complexity [20, 22]. Having dealt with self-joins, for the rest of our proofs we can consider only
self-join free queries.

---

Tight Fine-Grained Bounds for Direct Access on Join Qeries
3
Though we can easily show that no other decomposition can be better than the speciﬁc decom-
position we propose, we can still wonder whether a better algorithm can be achieved using an
alternative technique. Thus, we set out to prove conditional lower bounds. Such lower bounds
show hardness independently of a speciﬁc algorithmic technique, but instead they assume that
some known problem cannot be solved signiﬁcantly faster than by the state-of-the art algorithms.
We show that the incompatibility number corresponds in a sense to the number of leaves of the
largest star query that can be embedded in our given query. We then prove lower bounds for
queries that allow embedding stars through a reduction from online 푘-Set-Disjointness. In this
problem, we are given during preprocessing 푘sets of subsets of the universe, and then we need to
answer queries that specify one subset from each set and ask whether these subsets are disjoint.
On a technical level, in case the query is acyclic, the link of these hardness results with the exis-
tence of disruptive trios is that the latter correspond exactly to the possibility to embed a star with
two leaves.
Using known hardness results for 2-Set-Disjointness, our reduction shows that the acyclic hard
cases in the known dichotomy need at least quadratic preprocessing, unless both the 3-SUM Con-
jecture and the APSP Conjecture fail. These are both central, well-established conjectures in ﬁne-
grained complexity theory, see e.g. the survey [38]. To have tighter lower bounds for the case that
the incompatibility number is not 2, we show the hardness of 푘-Set-Disjointness through a reduc-
tion from the Zero-푘-Clique Conjecture. This conjecture postulates that deciding whether a given
edge-weighted 푛-node graph contains a 푘-clique of total edge weight 0 has no algorithm running
in time 푂(푛푘−휀) for any 휀> 0. For 푘= 3 this conjecture is implied by the 3SUM Conjecture and the
APSP Conjecture, so it is very believable. For푘> 3 the Zero-푘-Clique Conjecture is a natural gener-
alization of the case 푘= 3, and it was recently used in several contexts [1, 2, 7, 8, 16, 30]. Assuming
the Zero-푘-Clique Conjecture, we prove that the preprocessing time of our decomposition-based
algorithm is (near-)optimal.
To conclude, our main result is as follows: a join query, potentially with self-joins, and an or-
dering of its variables with incompatibility number 휄admit a lexicographic direct access algorithm
with preprocessing time 푂(|퐷|휄) and logarithmic access time. Moreover, if the Zero-푘-Clique con-
jecture holds for all 푘, there is no lexicographic direct access algorithm for this query and order
with preprocessing time 푂(|퐷|휄−휖) and polylogarithmic access time for any 휀> 0.
We also consider several extensions of this main result: we show that if we require the answers
to be ordered in any lexicographic order—but do not specify which one—then the best running
time we can expect is determined by the fractional hypertree width of the query. However, if we
make no restriction on the order of the answers (i.e., not requiring it to be lexicographic), then
this complexity bound can be improved. We show this by considering the 4-cycle query that has
faster direct access than the one determined by its fractional hypertree width for lexicographic
order. Finally, we extend our setting to partial lexicographic orders and queries with projections
and show how our algorithm can handle these cases. However, we again show that this algorithm
is not optimal for certain queries, leaving the identiﬁcation of optimal runtime bounds open.
As we develop our lower bound results, we notice that our techniques can also be used in the con-
text of constant delay enumeration of query answers. We show that, assuming the Zero-푘-Clique
Conjecture, the preprocessing of any constant delay enumeration algorithm for the 푘-variable
Loomis-Whitney join is roughly at least Ω(|퐷|1+1/(푘−1)) which tightly matches the trivial algo-
rithm in which the answers are materialized during preprocessing using a worst-case optimal join
algorithm [33, 34, 37]. From the lower bound for Loomis-Whitney joins, we then infer the hard-
ness of other cyclic joins using a construction by Brault-Baron [13]. Speciﬁcally, we conclude that

---

4
Karl Bringmann, Nofar Carmeli, and Stefan Mengel
the self-join free join queries that allow constant delay enumeration after linear processing are ex-
actly the acyclic ones, unless the Zero-푘-Clique Conjecture fails for some 푘. This dichotomy was
already established based on the hardness of hyperclique detection in hypergraphs [11, 13]; we
here give more evidence for this dichotomy by showing it also holds under a diﬀerent complexity
assumption.
A preliminary version of this manuscript appeared in a conference proceedings [15]. The current
version contains full proofs omitted in the previous version, as well as two new sections: Section 6
and Section 8, discussing the implications of our main result for queries with self-joins, queries
with projections, and relaxed order requirements.
This manuscript is organized as follows. Preliminary deﬁnitions and results are given in Sec-
tion 2. Section 3 deﬁnes disruption-free decompositions and the incompatibility number and pro-
vides the direct-access algorithm. Section 4 proves the hardness of direct access for self-join free
join queries assuming the hardness of set-disjointness, while Section 5 proves the hardness of set-
disjointness assuming the more established Zero-푘-Clique Conjecture. Section 6 proves the equiv-
alence in direct-access complexity between queries with and without self-joins. Then, Section 7
puts the previous sections together, and summarizes tight complexity bounds for join queries. Re-
laxed order requirements and queries with projections are discussed in Section 8. Finally, Section 9
proves the enumeration lower bounds for cyclic queries, assuming the Zero-푘-Clique Conjecture.
2
PRELIMINARIES
2.1
Databases and Qeries
A join query 푄is an expression of the form 푄(®푢) :−푅1(®푣1), . . . , 푅ℓ(®푣푛), where each 푅푖is a relation
symbol, ®푣1, . . . , ®푣푛are tuples of variables, and ®푢is a tuple of all variables in Ð푛
푖=1 ®푣푖. Each 푅푖(®푣푖) is
called an atom of 푄. We also denote by var(푄) the set ®푢of all variables appearing in 푄. A query is
called self-join free if no relation symbol appears in two diﬀerent atoms. If the same relation symbol
appears in two diﬀerent atoms, 푅푖= 푅푗, then ®푣푖and ®푣푗must have the same arity. A conjunctive
query (or, for short, a query) is deﬁned as a join query, with the exception that ®푢may contain any
subset of the query variables. We say that the query variables that do not appear in ®푢are projected.
Deﬁned this way, join queries are simply conjunctive queries without projections.
The input to a query 푄is a database 퐷which assigns every relation symbol 푅푖in the query with
a relation 푅퐷
푖: a ﬁnite set of tuples of constants, each tuple having the same arity as ®푣푖. The domain
dom(퐷) of 퐷is the set of all constants appearing in tuples in the relations of 퐷. The size |퐷| of
퐷is deﬁned as the total number of tuples in all of its relations. (More generally, |퐸| denotes the
cardinality of a set 퐸.) An answer to a query 푄over a database 퐷is determined by a mapping 휇
from the variables of 푄to the constants of 퐷such that 휇(®푣푖) ∈푅퐷
푖for every atom 푅푖(®푣푖) in 푄. The
answer is then 휇(®푢). The set of all answers to 푄over 퐷is denoted 푄(퐷).
A lexicographic order of a join query 푄is speciﬁed by a permutation 퐿of the query variables. We
assume databases come with a linear order on their constants. Then, 퐿deﬁnes a linear order over
푄(퐷): the order between two distinct answers is deﬁned to be the order between their assignments
to the ﬁrst variable in 퐿on which their assignments diﬀer.
2.2
Qery Answering Tasks
The problems we consider are typically deﬁned by a query 푄, and the input is a database 퐷for
푄. We always work in the model of data complexity, meaning the size of the query is considered
constant. In particular, the 푂-notation may hide constant factors that depend on 푄. We consider
three types of tasks:

---

Tight Fine-Grained Bounds for Direct Access on Join Qeries
5
• Testing is the task where, after a preprocessing phase, the user can specify a tuple ®푎of
constants, and one has to determine whether it is a query answer (i.e., whether ®푎∈푄(퐷)).
• Enumeration is the task of listing all query answers in 푄(퐷). We measure the eﬃciency of
an enumeration algorithm with two parameters: the time before the ﬁrst answer, which
we call preprocessing time, and the time between successive answers, which we call delay.
• Direct-access in lexicographic order is a task deﬁned by a query 푄and a permutation 퐿of
its free variables. After a preprocessing phase, the user can specify an index 푗and expects
the 푗th answer in 푄(퐷) according to the lexicographic order corresponding to 퐿or an out-
of-bounds error if there are less than 푗answers. We call the time it takes to provide an
answer given an index the access time.
An exact reduction from a query 푄1 to a query 푄2 is a mapping computable in linear time which
associates to each database 퐷1 for 푄1 a database 퐷2 for 푄2 such that there is a bijection 휏from
푄2(퐷2) to 푄1(퐷1), and 휏can be computed in constant time. Consider two queries 푄1 and 푄2 with
the same free variables. An exact reduction via a bijection 휏from 푄1 to 푄2 is called lex-preserving
if, for every permutation 퐿of the free variables, and for every pair (푎1,푎2) of answers in 푄2(퐷2),
we have that 푎1 ≺푎2 if and only if 휏(푎1) ≺휏(푎2), where ≺represents the lexicographic order
speciﬁed by 퐿. Note that if there is a lex-preserving exact reduction from 푄1 to 푄2, and 푄2 has a
direct access algorithm for some lexicographic order 퐿with preprocessing time in Ω(|퐷2|), then
푄1 has a direct access algorithm for 퐿with the same preprocessing and access time complexities.
2.3
Hypergraphs
A hypergraph 퐻= (푉, 퐸) consists of a ﬁnite set 푉of vertices and a set 퐸of edges, i.e., subsets of
푉. Given a set 푆⊆푉, the hypergraph 퐻[푆] induced by 푆is (푆, 퐸푆) with 퐸푆= {푒∩푆| 푒∈퐸}. A
super-hypergraph 퐻′ of 퐻is a hypergraph (푉, 퐸′) such that 퐸⊆퐸′. By 푁퐻(푣) we denote the set
of neighbors of a vertex 푣in 퐻, i.e., 푁퐻(푣) := {푢∈푉| 푢≠푣, ∃푒∈퐸: 푢,푣∈푒}. For 푆⊆푉, we
deﬁne 푁퐻(푆) := Ð
푣∈푆푁퐻(푣) \ 푆. In this notation we sometimes leave out the subscript 퐻when it
is clear from the context.
A walk between vertices 푠and 푡in a hypergraph 퐻= (푉, 퐸) is a sequence 푠= 푣1, . . . , 푣ℓ= 푡of
vertices such that for every 푖∈[ℓ−1] we have that there is an edge 푒∈퐸with 푣푖푣푖+1 ∈퐸. Here we
allow 푠= 푡in which case the walk consists of the single vertex 푣1 = 푠= 푡. The set 푉푠of vertices
reachable from 푠in 퐻is deﬁned to consist of all vertices 푡such that there is a walk between 푠and
푡in 퐻. Note that 푠itself is reachable from 푠, so in any case 푠∈푉푠. The connected component of 푠is
deﬁned as 퐻[푉푠].
A hypergraph 퐻is called acyclic if we can eliminate all of its vertices by iteratively applying
the following two rules1:
• if there is an edge 푒∈퐸that is completely contained in another edge 푒′ ∈퐸, delete 푒from
퐻, and
• if there is a vertex 푣∈푉that is contained in a single edge 푒∈퐸, delete 푣from 퐻, i.e., delete
푣from 푉and from 푒.
An order in which the vertices can be eliminated in the above procedure is called an elimination
order for 퐻. Note that it might be possible to apply the above rules on several vertices or edges
at the same moment. In that case, the order in which they are applied does not change the ﬁnal
result of the process.
Given a hypergraph and a permutation of its vertices, a disruptive trio consists of three vertices
푣1, 푣2,푣3 such that 푣3 appears after 푣1 and 푣2, the vertices 푣1 and 푣2 are not neighbors, but 푣3 is a
1This is called the GYO-algorithm, see e.g. Algorithm 6.4.4 in the standard textbook [3].

---

6
Karl Bringmann, Nofar Carmeli, and Stefan Mengel
neighbor to both 푣1 and 푣2. A permuation 퐿of the vertices of a hypergraph 퐻is the reverse of an
elimination order for 퐻if and only if 퐻is acyclic and 퐿contains no disruptive trio with 퐻[13].
A fractional edge cover of 퐻= (푉, 퐸) is deﬁned as a mapping 휇: 퐸→[0, 1] such that for every
푣∈푉we have Í
푒:푣∈푒휇(푒) ≥1. The weight of 휇is deﬁned as 휇(퐸) := Í
푒∈퐸휇(푒). The fractional
edge cover number of 퐻is 휌∗(퐻) := min휇휇(퐸) where the minimum is taken over all fractional edge
covers of 퐻. We remark that 휌∗(퐻) and an optimal fractional edge cover of 퐻can be computed
eﬃciently by linear programming.
Every join query 푄has an underlying hypergraph 퐻, where the vertices of 퐻correspond to the
variables of 푄and the edges of 퐻correspond to the variable scopes of the atoms of 푄. We use 푄
and 퐻interchangeably in our notation.
2.4
Known Algorithms
Here, we state some results that we will use in the remainder of this paper. All running time
bounds are in the word-RAM model with 푂(log(푛))-bit words and unit-cost operations. Note that
the values stored in the registers are bounded by 푛푐for some constant 푐, and this model allows
sorting 푚such values in time 푂(푐(푚+ 푛)) using radix sort, see e.g. [21, Section 6.3].
Theorem 1 ([18]). If an acyclic join query 푄and an ordering 퐿of its variables have no disrup-
tive trios, then lexicographic direct access for 푄and 퐿can be solved with 푂(|퐷|) preprocessing and
푂(log(|퐷|)) access time.
A celebrated result by Atserias, Marx and Grohe [6] shows that join queries of fractional edge
cover number 푘, can, on any database 퐷, result in query results of size at most 푂(|퐷|푘), and this
bound is tight for every query for some databases. The upper bound is made algorithmic by so-
called worst-case optimal join algorithms.
Theorem 2 ([33, 34, 37]). There is an algorithm that for every join query 푄of fractional edge cover
number 휌∗(푄), given a database 퐷, computes 푄(퐷) in time 푂(|퐷|휌∗(푄)).
2.5
Fine-Grained Complexity
Fine-grained complexity theory aims to ﬁnd the exact exponent of the best possible algorithm for
any problem, see e.g. [38] for a recent survey. Since unconditional lower bounds of this form are
currently far out of reach, ﬁne-grained complexity provides conditional lower bounds that hold
when assuming a conjecture about some central, well-studied problem.
Some important reductions and algorithms in ﬁne-grained complexity are randomized, i.e., al-
gorithms are allowed to make random choices in their run and may return wrong results with a
certain probability, see e.g. [32] for an introduction. Throughout the paper, when we write “ran-
domized algorithm” we always mean a randomized algorithm with success probability at least 2/3.
It is well-known that the success probability can be boosted to any 1−훿by repeating the algorithm
푂(log(1/훿)) times and returning the majority result. In particular, we can assume to have success
probability at least 1−1/푛10, at the cost of only a factor푂(log(푛)). Our reductions typically worsen
the success probability by some amount, but using boosting it can be improved back to 1 −1/푛10;
we do not make this explicit in our proofs.
We stress that randomization is only used in our hardness reductions, while all our algorithmic
results are deterministic.
We will base our lower bounds on the following problem which is deﬁned for every ﬁxed con-
stant 푘∈N,푘≥3.
Deﬁnition 3. In the Zero-푘-Clique problem, given an 푛-node graph퐺= (푉, 퐸) with edge-weights
푤: 퐸→{−푛푐, . . . ,푛푐} for some constant 푐≥1, the task is to decide whether there are vertices

---

Tight Fine-Grained Bounds for Direct Access on Join Qeries
7
푣1, . . . , 푣푘∈푉such that they form a 푘-clique (i.e. {푣푖,푣푗} ∈퐸for all 1 ≤푖< 푗≤푘) and their total
edge-weight is 0 (i.e. Í
1≤푖<푗≤푘푤(푣푖, 푣푗) = 0). In this case we say that 푣1, . . . , 푣푘is a zero-clique.
We remark that by hashing techniques we can assume 푐≤10푘, see e.g. [1, Lemma 3.2]. Due to
this bound, we may assume that all numbers that we encounter in the remainder of this paper have
bit-size 푂(log(푛)) and thus ﬁt into a constant number of memory cells. As a further consequence,
all arithmetic operations on all numbers can be done in constant time in the RAM model. We thus
tacitly ignore the size of numbers and the cost of operations on them in the remainder of this
paper.
The following conjectures have been used in several places, see e.g. [1, 2, 7, 8, 16, 30]. The ﬁrst
conjecture is for a ﬁxed 푘, the second postulates hardness for all 푘.
Conjecture 1 (Zero-푘-Cliqe Conjecture). For no constant 휀> 0 Zero-푘-Clique has a ran-
domized algorithm running in time 푂(푛푘−휀).
Conjecture 2 (Zero-Cliqe Conjecture). For every 푘≥3 the Zero-푘-Clique Conjecture is true.
It is known that the Zero-3-Clique Conjecture, also called Zero-Triangle Conjecture, is implied
by two other famous conjectures: the 3SUM Conjecture [39] and the APSP Conjecture [40]. Since
we do not use these conjectures directly in this paper, we do not formulate them here and refer
the interested reader to the survey [38].
We remark that instead of Zero-푘-Clique some references work with the Exact-Weight-푘-Clique
problem, where we are additionally given a target weight 푡and want to ﬁnd a 푘-clique of weight
푡. Both problems are known to have the same time complexity up to constant factors, see e.g. [1].
A related problem is Min-푘-Clique, where we are looking for the 푘-clique of minimum weight.
The Min-푘-Clique Conjecture postulates that this problem also cannot be solved in time 푂(푛푘−휀).
It is known that the Min-푘-Clique Conjecture implies the Zero-푘-Clique Conjecture, see e.g. [1].
As common in ﬁne-grained complexity, we use e
푂-notation for many of our results which is simi-
lar to 푂-notation but suppresses polylogarithmic factors. More precisely, we say that an algorithm
runs in time e
푂(푔(푛)) if there is a constant 푐such that it runs in time 푂(log푐(푛) · 푔(푛)).
3
DISRUPTION-FREE DECOMPOSITIONS AND THE DIRECT-ACCESS ALGORITHM
In this section, we give an algorithm that, for every join query and desired lexicographic order,
provides direct access to the query result on an input database. In particular, we propose to add
new atoms to the query such that the resulting query has no disruptive trios with respect to the
order. Then, any direct-access algorithm that assumes acyclicity and no disruptive-trios can be
applied, provided we can compute a database for the new query that yields the same answers. We
show that the new query is essentially a generalized hypertree decomposition of optimal fractional
hypertree width out of all decompositions with the required properties. This shows that the sug-
gested solution here is the best we can achieve using a decomposition, but it does not mean we
cannot do better using a diﬀerent method—the latter question is studied in the later sections of
this paper.
3.1
Disruption-Free Decompositions
We describe a process that iteratively eliminates disruptive trios in a query by adding new atoms.
Deﬁnition 4 (Disruption-Free Decomposition). Let 푄be a join query and 퐿= (푣1, . . . ,푣ℓ) be an
ordering of its variables. Let 퐻ℓbe the hypergraph of 푄, and for 푖= ℓ, . . . , 1 construct hypergraph
퐻푖−1 from 퐻푖by adding an edge 푒푖:= {푣푖} ∪{푣푗| 푗< 푖and 푣푗∈푁퐻푖(푣푖)}. The disruption-free
decomposition of 푄for 퐿is then deﬁned to be 퐻0.

---

8
Karl Bringmann, Nofar Carmeli, and Stefan Mengel
푣1
푣5
푣3
푣4
푣2
Fig. 1. The hypergraph of Example 5. The original (hyper)graph of the query is drawn in full edges. The edges
that we add in the construction are dashed.
Example 5. Consider the query푄(푣1,푣2, 푣3, 푣4,푣5) :−푅1(푣1,푣5), 푅2(푣2, 푣4),푅3(푣3,푣4),푅4(푣3,푣5) with
the order (푣1, 푣2,푣3,푣4, 푣5) of its variables. Its hypergraph is shown in Figure 1. In the ﬁrst step of
the construction of Deﬁnition 4, we add the edge {푣5}∪푁(푣5) = {푣1,푣3,푣5}. Similarly, in the second
step, we add {푣2, 푣3,푣4}. For the third step, note that 푁(푣3) = {푣1, 푣2,푣4,푣5} due to the edges we
have added before. Out of these neighbors, only 푣1 and 푣2 come before 푣3 in the order. So we add
the edge {푣1, 푣2,푣3}. Finally, for 푣2, we add the edge {푣1, 푣2} and for 푣1 the singleton edge {푣1}.
Proposition 6. The disruption-free decomposition of a join query 푄for 퐿is an acyclic super-
hypergraph 퐻0 of the hypergraph of 푄without any disruptive trios with respect to 퐿.
Proof. Let 퐿= (푣1, . . . , 푣ℓ). We also use the notation 푒푖as deﬁned in Deﬁnition 4. To prove
that 퐻0 is acyclic, we will show that the reverse of 퐿is an elimination order. First, set 푖= ℓ. Since 푒푖
contains all neighbors of 푣푖(that were not yet eliminated), we have that 푒푖contains all other edges
containing 푣푖, and we can eliminate all of these edges. Afterwards, 푣푖appears only in 푒푖, so we can
eliminate 푣푖. Note that we did not eliminate any edges 푒푗with 푗< 푖since all edges we eliminated
contain 푣푖(and 푒푗does not contain 푣푖by construction when 푗< 푖). Thus, we can repeat these steps
with 푖−1 instead of 푖until all vertices are eliminated. It follows that, as claimed, the reverse of 퐿
is an elimination order for 퐻0, and thus 퐻0 is indeed acyclic.
We next show that 퐻0 has no disruptive trio with respect to 퐿. By way of contradiction, assume
퐻0 has a disruptive trio 푣푖,푣푗, 푣푘with 푖< 푗< 푘. Then, by deﬁnition, in 퐻0 the vertices 푣푖and 푣푗are
both neighbors of 푣푘, but 푣푖and 푣푗are not neighbors. In the construction of 퐻0 from Deﬁnition 4,
no edge containing 푣푘is added after introducing 푒푘, and 푒푘does not introduce new neighbors
to 푣푘. We conclude that 푣푖and 푣푗were already neighbors of 푣푘right before introducing 푒푘. But
then {푣푖,푣푗} ⊆푒푘, and thus 푣푖and 푣푗are neighbors in 퐻0. This contradicts the assumption that 푣푖,
푣푗, 푣푘forms a disruptive trio.
□
It will be useful in the remainder of this section to have a non-iterative deﬁnition of disruption-
free decompositions. Let 푆푖be the vertices in the connected component of 푣푖in 푄[{푣푖, . . . ,푣ℓ}]. In
particular, we have that 푣푖∈푆푖.
Lemma 7. The edges introduced in Deﬁnition 4 are 푒푖= {푣푖} ∪{푣푗| 푗< 푖and 푣푗∈푁푄(푆푖)} for
푖∈{1, . . . , ℓ}.

---

Tight Fine-Grained Bounds for Direct Access on Join Qeries
9
Example 8. Let us illustrate Lemma 7 with the query of Example 5: For the variable 푣5 we have
푆5 = {푣5}. Consequently, 푒5 = {푣5} ∪푁푄(푣5) = {푣1, 푣3,푣5} which is exactly the edge that is added
for 푣5. The case for 푣4 is analogous. For 푣3 we have 푆3 = {푣3,푣4, 푣5}. Consequently 푒3 := {푣3} ∪
푁푄({푣3, 푣4,푣5}) = {푣1, 푣2, 푣3}. We have 푆2 = {푣2,푣3, 푣4, 푣5}, so we add the edge 푒2 = {푣1, 푣2}. For 푣1
we add again the singleton edge {푣1}.
Proof of Lemma 7. Let 푒′
푖= {푣푖} ∪{푣푗| 푗< 푖and 푣푗∈푁푄(푆푖)}. We prove that 푒푖= 푒′
푖by
induction on decreasing 푖. The claim holds by deﬁnition for 푒ℓsince 푆ℓ= {푣ℓ}, and 퐻ℓis the
hypergraph of 푄, and so 푁푄(푆푖) = 푁퐻ℓ(푣ℓ).
For the induction step, we ﬁrst show 푒푖⊆푒′
푖. Let 푣푗∈푒푖. If 푗= 푖, we know that 푣푗= 푣푖∈푒′
푖by
deﬁnition. Otherwise, 푗< 푖and 푣푗∈푁퐻푖(푣푖). If 푣푗∈푁푄(푣푖), we have that 푣푗∈푁푄(푆푖) because
푣푖∈푆푖, and so 푣푗∈푒′
푖. Otherwise, the reason 푣푗is a neighbor of 푣푖in 퐻푖is because there is
some 푘> 푖> 푗such that {푣푖,푣푗} ⊆푒푘. From the induction hypothesis, we have that 푒′
푘= 푒푘,
and it follows that 푣푖, 푣푗∈푁푄(푆푘). Since 푣푖∈푁푄(푆푘), we have that 푆푘⊆푆푖. It follows that
푣푗∈푁푄(푆푘) ⊆푁푄(푆푖) and thus 푣푗∈푒′
푖. Since in all cases 푣푗∈푒′
푖, we get that 푒푖⊆푒′
푖.
It remains to show that 푒′
푖⊆푒푖. To this end, let 푣푗∈푒′
푖. If 푗= 푖, we know that 푣푗= 푣푖∈푒푖by
deﬁnition. Otherwise, 푗< 푖and 푣푗∈푁푄(푆푖). If 푣푗∈푁푄(푣푖), then also 푣푗∈푁퐻푖(푣푖), and so 푣푗∈푒푖.
Otherwise, if we remove 푣푖from 푆푖, it is split into connected components, one of them containing
a neighbor of 푣푗. Consider the smallest variable 푣푘in such a connected component. Then, this
connected component is 푆푘, and we have that 푣푖,푣푗∈푁푄(푆푘) where 푘> 푖> 푗. It follows that
{푣푖,푣푗} ⊆푒′
푘, and from the induction hypothesis we get that {푣푖,푣푗} ⊆푒푘. Thus, 푣푗is a neighbor
of 푣푖when introducing 푒푖, and so 푣푗∈푒푖. Consequently, 푒′
푖⊆푒푖.
□
3.2
The Direct-Access Algorithm
The idea of our direct access algorithm is to use the disruption-free decomposition. More precisely,
we deﬁne a new query 푄′ from 푄such that the hypergraph of 푄′ is the disruption-free decomposi-
tion of 푄. Then, given an input database 퐷for 푄, we compute a new database 퐷′ for 푄′ such that
푄(퐷) = 푄′(퐷′). Since 푄′ has no disruptive trio, we can then use the algorithm from [18] on 푄′
and 퐷′ to allow direct access. A key component to making this approach eﬃcient is the eﬃcient
computation of 퐷′. To measure its complexity, we introduce the following notion.
Deﬁnition 9 (Incompatibility Number). Let 푄be a join query with hypergraph 퐻and let 퐿=
(푣1, . . . , 푣ℓ) be an ordering of its variables. Let 휌∗(퐻[푒푖]) with 푖∈[ℓ] be the fractional edge cover
number of 퐻[푒푖], where 푒푖is as deﬁned in Deﬁnition 4. We call max푖=1,...,ℓ휌∗(퐻[푒푖]) the incompat-
ibility number of 푄and 퐿.
Note that we assume that queries have at least one atom, so the incompatibility number of any
query and any order is at least 1. The incompatibility number can also be seen as the fractional
width of the disruption-free decomposition, and we can show that this decomposition has the
minimum fractional width out of all decompositions with the properties we need, see Section 3.3
for details. We now show that the incompatibility number lets us state an upper bound for the
computation of a database 퐷′ with the properties claimed above.
Theorem 10. Given a join query 푄and an ordering 퐿of its variables with incompatibility num-
ber 휄, lexicographic direct access with respect to 퐿can be achieved with 푂(|퐷|휄) preprocessing and
logarithmic access time.
Proof. We construct 푄′ by adding for every edge 푒푖an atom 푅푖whose variables are those
in 푒푖. We compute a relation 푅퐷′
푖
as follows: let 휇be a fractional edge cover of 퐻[푒푖] of weight
휌∗(퐻[푒푖]) ≤휄. Let ¯푒1, . . . , ¯푒푟be the edges of 퐻[푒푖] that have positive weight in 휇. For every ¯푒푗there

---

10
Karl Bringmann, Nofar Carmeli, and Stefan Mengel
is an edge 푒′
푗of 퐻such that ¯푒푗= 푒′
푗∩푒푖. Let ¯푅푗( ¯푋푗) be the projection to 푒푖of an atom corresponding
to 푒′
푗. Let 퐷∗be the extension of 퐷that contains the corresponding projected relations for the
¯푅푗( ¯푋푗). We set 푅퐷′
푖
:= 푄푖(퐷∗) where 푄푖(푒푖) :−¯푅1(푋1), . . . , ¯푅푟(푋푟). Then clearly for all tuples ®푡
in 푄(퐷), the tuple we get by projecting ®푡to 푒푖lies in 푅퐷′
푖. As a consequence, we can construct
퐷′ by adding all relations 푅퐷′
푖
to 퐷to get 푄(퐷) = 푄′(퐷′). Moreover, the hypergraph of 푄′ is the
disruption-free decomposition of the hypergraph of 푄, so we can apply the algorithm from [18]
for direct access.
It remains to show that all 푅퐷′
푖
can be constructed in time 푂(|퐷|휄). To this end, consider the join
query 푄푖(푒푖) from before. By deﬁnition, its variable set is 푒푖, and 휇is a fractional edge cover of
weight 휌∗(퐻[푒푖]) ≤휄. Thus, we can use a worst-case optimal join algorithm from Theorem 2 to
compute 푅퐷′
푖
in time 푂(|퐷|휄).
□
3.3
Disruption-Free Decompositions and Fractional Hypertree Width
In this section, we will relate disruption-free decompositions to fractional hypertree decomposi-
tions and the incompatibility number to fractional width.
Let 퐻= (푉, 퐸) be a hypergraph. A hypertree decomposition D of 퐻is deﬁned to be an acyclic
hypergraph (푉, 퐵) such that for every edge 푒∈퐸there is a 푏∈퐵with 푒⊆푏.2 The sets 푏∈퐵
are called the bags of the decomposition. The fractional width of D is deﬁned as max푏∈퐵휌∗(퐻[푏]).
The fractional hypertree width of 퐻is deﬁned to be the minimal fractional width of any hypertree
decomposition of 퐻[25].
Note that the fractional edge cover number is monotone in the sense that 휌∗(퐻[푏]) ≤휌∗(퐻[푏′])
whenever 푏⊆푏′, and so the fractional width of a hypertree decomposition is determined by its
maximal edges with respect to set inclusion. Next, we observe that the incompatibility number is
the fractional width of the disruption-free decomposition seen as a hypertree decomposition.
Proposition 11. Let 푄be a join query and 퐿be an ordering of its variables. The disruption-
free decomposition of 푄and 퐿is a hypertree decomposition of 푄, and its fractional width is the
incompatibility number of 푄and 퐿.
Proof. Consider an edge 푒of the disruption-free decomposition 퐻0. First, we claim that 푒is
contained in some edge 푒푖from Deﬁnition 4. Let 푣푖be the latest vertex (according to 퐿) in an edge
푒of 퐻0. Then, 푒could not have been introduced after the introduction of 푒푖. Thus, either 푒= 푒푖
or 푒existed right before the introduction of 푒푖, and then 푒⊆푒푖by the deﬁnition of 푒푖. Due to the
monotonicity of the fractional edge cover number, 휌∗(퐻[푒]) ≤휌∗(퐻[푒푖]), and this is bounded by
the incompatibility number by its deﬁnition. We also have that 휄= 휌∗(퐻[푒푗]) for some 푗, and thus
휄is exactly the fractional width of 퐻0.
□
Observation 12. Let 푄be a join query and 퐿be an ordering of its variables. Then the incompati-
bility number of 푄and 퐿is at least the fractional hypertree width of 푄.
Of course there are other hypertree decompositions D of 푄that we could have used for a direct
access algorithm. The only property that we need is that D has no disruptive trio for 퐿. If this is
the case, then inspection of the proof of Theorem 10 shows that we get an alternative algorithm
whose preprocessing depends on the fractional width of D. We will see next that this approach
cannot yield a better running time than Theorem 10. To this end, we prove that any alternative
decomposition contains the disruption-free decomposition in a way.
2Hypertree decompositions appear in previous work under several names, such as generalized hypertree decompositions and
fractional hypertree decompositions depending on the way the bags get covered. Usually, the deﬁnitions are more involved
as they also contain a tree structure with the bags as nodes and an edge cover of the bags. This is a simpliﬁed deﬁnition
containing only what we need here.

---

Tight Fine-Grained Bounds for Direct Access on Join Qeries
11
Lemma 13. Let 푄be a join query, 퐿be an ordering of its variables, and D be a hypertree decom-
position of 푄without disruptive trios with respect to 퐿. Then, for every edge 푒of the disruption-free
decomposition of 푄, there exists a bag 푏of D such that 푒⊆푏.
Proof. Let 퐻be the hypergraph of 푄. Assume by way of contradiction that there is an edge
of the disruption-free decomposition 퐻0 of 푄for 퐿that is not contained in any bag of D. Since
D is a hypertree decomposition of 퐻, for every edge 푒of 퐻, the decomposition D contains, by
deﬁnition, a bag 푏such that 푒⊆푏. Thus, the edge of 퐻0 not contained in any bag of D must be
of the form 푃∪{푣} where 푃consists of the preceding neighbors of 푣at the moment of creation of
the edge; here, when we say ‘preceding’, we mean the neighbors that come before 푣in 퐿. Consider
the non-covered edge 푒with the largest 푣. We show next that every pair of vertices in 푒appears
in a common bag in D. It is known that acyclic hypergraphs are conformal [14]; that is, any set
of pairwise neighbors must be contained in an edge. Thus, D has a bag containing 푒, which is a
contradiction.
Since 푒is the largest non-covered edge, we know that D contains, for all edges 푒′ that were
present at the moment of creation of 푒, a bag 푏with 푒′ ⊆푏. Thus, for every vertex 푣′ in 푃, there
is a bag of D that contains both 푣and 푣′. Now consider 푣1,푣2 ∈푃. If 푣1, 푣2 are not in a common
bag 푏′ of D, then 푣1, 푣2,푣is a disruptive trio of D, which is a contradiction to the conditions of
the lemma. So 푣1,푣2 must appear in a common bag. It follows that the vertices of 푒are all pairwise
neighbors in D as we wanted to show.
□
Due to the monotonicity of the fractional edge cover number, we directly get that the disruption-
free decomposition is optimal in the following sense.
Proposition 14. Let 푄be a join query and 퐿be an ordering of its variables. The disruption-free
decomposition of 푄and 퐿has the minimal fractional width taken over all hypertree decompositions
of 푄that have no disruptive trio with respect to 퐿.
Note that, in general, ﬁnding an optimal fractional hypertree decomposition is known to be
hard [24]. However, in our case, decompositions are only useful if they eliminate disruptive trios.
If we restrict the decompositions in that way, it is much easier to ﬁnd a good decomposition com-
pared to the general case: since the optimal decomposition is induced by the order, we get it in
polynomial time using the procedure of Deﬁnition 4.
4
SET-DISJOINTNESS-BASED HARDNESS FOR SELF-JOIN FREE DIRECT ACCESS
In this section, we show lower bounds for lexicographically ranked direct access for all self-join
free queries and all variable orders. We ﬁrst reduce general direct access queries to the special
case of star queries, which we introduce in Section 4.1. Then we show that lower bounds for direct
access to star queries follow from lower bounds for 푘-Set-Disjointness, see Section 4.3. Later, in
Section 5 we prove a lower bound for 푘-Set-Disjointness based on the Zero-Clique Conjecture,
and in Section 6 we remove the assumption that 푄is self-join free.
4.1
From 풌-Star Qeries to Direct Access
A crucial role in our reduction is played by the 푘-star query 푄★
푘:
푄★
푘(푥1, . . . , 푥푘,푧) :−푅1(푥1,푧), . . . ,푅푘(푥푘,푧).
We say that a variable order 퐿is bad for 푄★
푘if 푧is the last variable in 퐿. We will also use the variant
푄
★
푘of this query in which the variable 푧is projected away:
푄
★
푘(푥1, . . . , 푥푘) :−푅1(푥1,푧), . . . ,푅푘(푥푘,푧).

---

12
Karl Bringmann, Nofar Carmeli, and Stefan Mengel
In the case that the query is acyclic, we can show that the incompatibility number is always
an integer, and then the reduction is simpler. We thus start with this case as a warm-up for the
general construction.
Lemma 15. Let 푄be an acyclic self-join-free join query and 퐿be an ordering of its variables with
incompatibility number 휄. Then 휄is an integer, and if 푄has a lexicographic direct access algorithm
according to 퐿with preprocessing time 푝(|퐷|) = Ω(|퐷|) and access time 푟(|퐷|), then so has 푄★
휄for a
bad lexicographic order.
Proof. We use the notation 푆푖and 푒푖for 푖∈[ℓ] as in Lemma 7. Recall that 푆푖is the vertex set
of the connected component of 푣푖in 퐻[{푣푖, . . . ,푣ℓ}] where 퐻is the hypergraph corresponding to
푄. Since every induced subhypergraph of an acyclic hypergraph is also acyclic (this is well known
and follows easily from the deﬁnition of acyclicity by elimination orders), we have that 퐻[푒푖] is
acyclic for all 푖∈{1, . . . , ℓ}. Let 푟be such that 휌∗(퐻[푒푟]) = 휄= max푖∈[ℓ] (휌∗(퐻(푒푖))). In acyclic
hypergraphs, the fractional edge cover number is an integer, and there is an independent set of this
size [23], i.e., a subset of vertices such that every edge contains at most one vertex of this subset.
Let {푢1, . . . ,푢휄} be such an independent set in 퐻[푒푟].
We construct a database 퐷for 푄, given an input database 퐷★for 푄★
휄. We ﬁrst give roles to the
variables of 푄that correspond to the variables of 푄★
휄. First, we assign for every 푖∈[휄] the role 푥푖
to every 푢푖. We next add the role 푧for every 푣∈푆푟. Note that when doing so, the variable 푣푟, the
only one in both 푒푟and 푆푟, may have both the role 푥푖for some 푖∈[휄] and the role 푧, while the
other variables have at most one role.
To deﬁne the relations of 퐷, consider an atom 푅( ®푤) of 푄. Since the variables with the roles of
the form 푥푖are an independent set, the roles of variables in this atom cannot contain 푥푖and 푥푗
with 푖≠푗, and so there is an atom 푅푗(푥푗,푧) in 푄★
휄whose variables contain all roles played by the
variables ®푤. We use 푅퐷★
푗
to deﬁne 푅퐷. For every tuple (푐푗,푐푧) ∈푅퐷★
푗
, we add a tuple ®푡to 푅퐷as
follows: for all 푤푖in ®푤, if the variable 푤푖has only the role 푥푗, then 푡푖= 푐푗; if it has only the role
푧, then 푡푖= 푐푧; if it has both roles 푥푗and 푧, then 푡푖= (푐푗,푐푧); if it has no role, then 푡푖is set to a
constant ⊥. Note that |퐷| = 푂(|퐷★|) and that the construction only requires linear time.
The construction yields a bijection 휏between 푄(퐷) and 푄★
푘(퐷★) as follows: if a variable with a
single role푦is assigned a value 푐in an answer 푎∈푄(퐷), then 휏(푎) assigned푦with 푐; similarly, if a
variable with two roles 푥푗, 푧is assigned a value (푐푗,푐푧), then 휏(푎) assigned 푥푗with 푐푗and 푧with 푐푧.
This bijection is well-deﬁned because all variables that have the role 푧must take the same value
on the corresponding coordinate by construction, since 푆푟is connected in 퐻and the construction
assigns diﬀerent coordinates with the role 푧in the same atom with the same value. Moreover, for
every atom 푅푗(푥푗,푧) of 푄★
휄, there is an atom of 푄containing (not necessarily diﬀerent) variables
푣푥and 푣푧such that 푣푥has the role 푥푗and 푣푧has the role 푧. By construction, it then follows that
the variables 푣푥and 푣푧take values that are consistent with the relation 푅퐷★
푗
. This directly gives
the desired bijection. Note that computing 휏(푎) given 푎∈푄(퐷) can be done in constant time.
Next we claim that this construction yields a bad lexicographic order for 푄★
휄(퐷★). That is, order-
ing the solutions to 푄(퐷) by 퐿and then applying 휏on each solution gives the solutions to 푄★
휄(퐷★)
sorted in a bad lexicographic order. This is the case since the variables with the role 푧appear in 퐿
after all variables with a role of the form 푥푖with some 푖∈[휄], with the exception of 푣푟that may
have two roles, in which case the construction assigns it the values corresponding to 푧after those
corresponding to 푥푖.
Using this construction, a lexicographic direct access for 푄and 퐿can be used for lexicographic
direct access for 푄★
휄and a bad lexicographic order.
□

---

Tight Fine-Grained Bounds for Direct Access on Join Qeries
13
Example 16. Let us illustrate the role assignment from the proof of Lemma 15 with the query of
Example 5. The incompatibility number here is 휄= 3, and it is witnessed by the edge푒3 = {푣1,푣2,푣3}.
An independent set of 퐻[푒3] of size 3 is {푣1, 푣2, 푣3}. Thus, the variables 푣1, 푣2 and 푣3 are assigned
the roles 푥1, 푥2, and 푥3 respectively. In addition, 푣3, 푣4 and 푣5 (these are the variables of 푆3) are each
assigned the role 푧. Using this role assignment, 푄★
3 is reduced to 푄.
In general, the incompatibility number may not be an integer; we will see such a case in Exam-
ple 18. We will next show how we can generalize the construction from Lemma 15 to also handle
this case.
Lemma 17. Let 푄be a self-join-free join query and 퐿= (푣1, . . . , 푣ℓ) be an ordering of its variables.
Let 휄be the incompatibility number of 푄and 퐿and assume 휄> 1. If there is an 휀> 0 such that for
all 훿> 0 there is a direct access algorithm for 푄and 퐿with preprocessing time 푂(|퐷|휄−휀) and access
time 푂(|퐷|훿), then there is a 푘∈N, 푘> 2 and 휀′ > 0 such that for all 훿′ > 0 there is a direct access
algorithm for 푄★
푘with respect to a bad ordering with preprocessing time 푂(|퐷★|푘−휀′) and access time
푂(|퐷★|훿′).
Proof. We use a reduction similar to that in the proof of Lemma 15, except we use a fractional
independent set in order to handle the fractional incompatibility number. A fractional independent
set in a hypergraph 퐻= (푉, 퐸) is a mapping 휙: 푉→[0, 1] such that for every 푒∈퐸we have that
Í
푣∈푒휙(푣) ≤1. The weight of 휙is deﬁned to be 휙(푉) = Í
푣∈푉휙(푣). The fractional independent set
number of 퐻is deﬁned as 훼∗(퐻) := max휙휙(푉) where the maximum is taken over all fractional
independent sets of 퐻. As already noted in [25], using linear programming duality, we have for
every hypergraph 퐻and every vertex set 푆that 훼∗(퐻[푆]) = 휌∗(퐻[푆]), see e.g. [36, Chapter 82.2]
for details. We use the same notation on join queries, with the meaning of applying it to the
underlying hypergraph.
Let푟be such that 휌∗(퐻[푒푟]) = 휄= max푖∈[ℓ] (휌∗(퐻(푒푖))). Then, we know that there is a fractional
independent set 휙: 푒푟→[0, 1] such that Í
푣∈푒푟휙(푣) = 휄. Since 휙is the solution of a linear
program with integer coeﬃcients and weights, all values 휙(푣) are rational numbers. Let 휆be the
least common multiple of the denominators of {휙(푣) | 푣∈푒푟}. Now deﬁne a new weight function
휙′ : 푒푟→{0, . . . , 휆} by 휙′(푣) := 휆휙(푣). Let 푘:= 휆휄, and consider the query 푄★
푘.
As in the proof of Lemma 15, we again assign variables of 푄with roles that correspond to the
variables of 푄★
푘. The diﬀerence in this proof is that now every variable may play several roles of
the form 푥푖. Indeed, every 푣∈푒푟takes 휙′(푣) roles out of the variables 푥1, . . . , 푥푘. More speciﬁcally,
let {푢1, . . . ,푢푚} ⊆푒푟be the variables that 휙′ assigns a non-zero value. Then, for each 푖∈[푚],
푢푖is assigned the roles {푥푗| Í
푡<푖휙′(푢푡) < 푗≤Í
푡≤푖휙′(푢푡)}. Note that the number of roles we
distributed so far is indeed Í
푣∈푒푟휙′(푣) = 휆Í
푣∈푒푟휙푣= 휆휄= 푘. We next add the role 푧for every
푣∈푆푟. Note that when doing so, the variable 푣푟, the only one in both 푒푟and 푆푟, may have both
roles of the form 푥푖and the role 푧. For an illustration of this role assignment, see Example 18.
We now construct a database 퐷for 푄given an input database 퐷★for 푄★
푘. For every variable
푦of 푄★
푘, denote by dom★(푦) its active domain in 퐷★. We ﬁx all variables of 푄that have no role
to a constant ⊥, and we will ignore these variables in the rest of the proof, so we only need to
consider variables in 푒푟∪푆푟. For each variable 푣∈푒푟∪푆푟we deﬁne the domain as follows: let
푦1, . . . ,푦푠be the roles of 푣given in the order deﬁned by 퐿. Then the domain of 푣is dom(푣) :=
dom★(푦1) × . . . × dom★(푦푠). We order dom(푣) lexicographically. To deﬁne the relations of 퐷, let
푥푗1, . . . ,푥푗푡be the roles of the form 푥푖played by variables in 푅(푣푖1, . . . ,푣푖푠). Then we compute the
sub-join 푄퐽(퐷★) where 푄퐽(푥푗1, . . . ,푥푗푡,푧) :−푅푗1(푥푗1,푧), . . . , 푅푗푡(푥푗푡,푧). Note that there is a function
휈: 푄퐽(퐷★) →dom(푣푖1) × . . . × dom(푣푖푠) that consists of “packing” the values for the diﬀerent
variables of 푄★
푘into the variables of 푄according to the roles in the following sense: for every tuple

---

14
Karl Bringmann, Nofar Carmeli, and Stefan Mengel
®푡, the function 휈maps each variable 푣푖with role set R to the tuple we get from ®푡by deleting the
coordinates not in R. The relation 푅퐷is then simply 휈(푄퐽(퐷★)).
The construction yields a bijection 휏between 푄(퐷) and 푄★
푘(퐷★): if a coordinate corresponding
to a role푦is assigned a value푐in an answer 푎∈푄(퐷), then휏(푎) assigns푐to푦. The same arguments
given in the proof of Lemma 15 show that 휏is well deﬁned and is indeed a bijection and that this
construction yields a bad lexicographic order. Note that the bijection 휏can again be computed in
constant time.
It remains to analyze the time complexity of the construction of 퐷. We show that the size of
퐷and the time required for its construction are in 푂(|퐷★|휆). For every atom 퐴in 푄, its variables
in total have at most 휆roles of the form 푥푖. To see this, let 푣푖1, . . . ,푣푖푠be the variables of 퐴. Then
the overall number of non-푧-roles is Í푠
푗=1 휙′(푣푖푗) = Í푠
푗=1 휆휙(푣푖푗) ≤휆, where the inequality comes
from the fact that 휙is a fractional independent set of 퐻and {푣푖1, . . . ,푣푖푠} is an edge of 퐻. Hence,
the join 푄퐽(퐷★) involves at most 휆atoms of 푄★
푘, and it can be computed in time 푂(|퐷★|휆).
Assume that for some 휀> 0 and all 훿> 0 there is a direct access algorithm for 푄and 퐿with
preprocessing time 푂(|퐷|휄−휀) and access time 푂(|퐷|훿). We set 휀′ := min(휆휀, 휆(휄−1)). Note that
indeed 휀′ > 0 since 휄> 1. Using the facts that |퐷| = 푂(|퐷★|휆) and 푘= 휆휄, we get that the
preprocessing is 푂(|퐷★|휆+ |퐷|휄−휀) = 푂(|퐷★|휆휄−휆(휄−1) + |퐷★|휆휄−휆휀) = 푂(|퐷★|푘−휀′). Then, given 훿′,
we set 훿:= 훿′/휆. We get that the access time is 푂(|퐷|훿) = 푂(|퐷★|휆훿) = 푂(|퐷★|훿′).
□
Example 18. Let us illustrate the role assignment from the proof of Lemma 17. Consider the
query obtained from that of Example 5 by adding the atoms 푅5(푣1,푣2), 푅6(푣2, 푣3),푅7(푣1, 푣3). This
query does not have disruptive trios, but it is cyclic. The edges 푒푖introduced by the distruption-
free decomposition are the same as in the previous example. The incompatibility number here is
휄= 3
2. One witness for this incompatibility number is the edge 푒3 = {푣1, 푣2,푣3} using the fractional
independent set of 퐻[푒3] that assigns each of its vertices a weight of 1
2. As a result, we take 휆= 2,
and the variables 푣1, 푣2 and 푣3 are assigned the roles {푥1, 푥2}, {푥3,푥4}, and {푥5,푥6} respectively. In
addition, 푣3, 푣4 and 푣5 (these are the variables of 푆3) are each assigned the role 푧. Using this role
assignment, 푄★
6 is reduced to 푄. An alternative choice of witness for the incompatibility number
is the edge 푒5 = {푣1, 푣3,푣5} using the fractional independent set of 퐻[푒5] that assigns each of its
vertices a weight of 1
2. Here the variables 푣1, 푣3 and 푣5 are assigned the roles {푥1, 푥2}, {푥3,푥4}, and
{푥5, 푥6,푧} respectively, while the variables 푣2 and 푣4 have no roles. This choice gives another way
of reducing 푄★
6 to 푄.
4.2
From Projected Stars to Star Qeries
Proposition 19. Let 퐿be a bad order on 푥1, . . . ,푥푘,푧. If there is an algorithm that solves the direct
access problem for 푄★
푘(푥1, . . . ,푥푘,푧) and 퐿with preprocessing time 푝(|퐷|) and access time 푟(|퐷|),
then there is an algorithm for the testing problem for 푄
★
푘(푥1, . . . , 푥푘) with preprocessing time 푝(|퐷|)
and query time 푂(푟(|퐷|) log(|퐷|)).
Proof. If an answer (푎1, . . . ,푎푘) is in 푄
★
푘(퐷), then answers of the form (푎1, . . . ,푎푘,푏) (for any
푏) form a contiguous sequence in the set 푄★
푘(퐷) ordered according to the 퐿-lexicographic order,
since the position of 푧is the last variable in 퐿. Thus, a simple binary search using the direct access
algorithm allows to test whether such a tuple (푎1, . . . ,푎푘,푏) ∈푄★
푘(퐷) exists, using a logarithmic
number of direct access calls.
□
4.3
From Set-Disjointness to Projected Stars
We observe (Lemma 22) that the testing problem for the projected star query 푄
★
푘is equivalent to
the following problem:

---

Tight Fine-Grained Bounds for Direct Access on Join Qeries
15
Deﬁnition 20. In the 푘-Set-Disjointness problem, we are given an instance I consisting of a
universe 푈and families A1, . . . , A푘⊆2푈of subsets of 푈. We denote the sets in family A푖by
푆푖,1, . . . , 푆푖,|A푖|. The task is to preprocess I into a data structure that can answer queries of the
following form: Given indices 푗1, . . . , 푗푘, decide whether 푆1,푗1 ∩. . . ∩푆푘,푗푘= ∅.
We denote the input size by ∥I∥:= Í
푖
Í
푆∈A푖|푆|.
Example 21. Since we will see several problems later on that have the same type of inputs, let
us take some time for an example. Fix the domain 푈:= {1, . . . , 5} and say 푘= 3. Let A1 consist
of the sets 푆1,1 := {1, 3, 5} and 푆1,2 := {1, 2, 4}. Let A2 consist of 푆2,1 := {1, 4}, 푆2,2 := {2, 4}, and
푆2,3 := {1, 2, 3, 4, 5}. Finally, let A3 consist of 푆3,1 := {3, 4, 5} and 푆3,2 := {4}. The size of the resulting
instance I is then ∥I∥= 19.
On input (2, 3, 2) we have to consider푆1,2∩푆2,3∩푆3,2 = {4}, so an algorithm for푘-Set-Disjointness
has to report that the queried set intersection is non-empty. For the input (1, 1, 1), we have that
푆1,1 ∩푆2,1 ∩푆3,1 = ∅, so the correct answer is that the queried set intersection is empty.
Lemma 22. If 푄
★
푘has a testing algorithm with preprocessing time 푝(|퐷|) = Ω(|퐷|) and access
time 푟(|퐷|), then 푘-Set-Disjointness has an algorithm with preprocessing time 푝(∥I∥) and query
time 푟(∥I∥).
Proof. For each family A푖, consider the relation
푅퐷
푖:= {(푗,푣) | 푣∈푆푖,푗}.
Let 퐷be the resulting database, and note that |퐷| = ∥I∥and that 퐷is computable from I in linear
time. The equivalence 푣∈푆푖,푗⇔(푗,푣) ∈푅퐷
푖implies the equivalence 푣∈푆1,푗1 ∩. . . ∩푆푘,푗푘⇔퐷|=
푅1(푗1,푣) ∧. . . ∧푅푘(푗푘,푣), and then for every query (푗1, . . . , 푗푘) of the 푘-Set-Disjointness problem,
we have that 푆1,푗1 ∩. . . ∩푆푘,푗푘≠∅if and only if (푗1, . . . , 푗푘) ∈푄
★
푘(퐷).
□
5
HARDNESS OF SET DISJOINTNESS
In this section, we will show lower bounds for 푘-Set Disjointness, as deﬁned in Deﬁnition 20. In
combination with the reductions from the previous section, this will give us lower bounds for
direct access in Section 7. The main result of this section is the following.
Theorem 23. If there is 푘∈N,푘≥2 and 휀> 0 such that for all 훿> 0 there is an algorithm for
푘-Set-Disjointness that, given an instance I, answers queries in time 푂(∥I∥훿) after preprocessing
time 푂(∥I∥푘−휀), then the Zero-(푘+ 1)-Clique Conjecture is false.
Case 풌= 2
Kopelowitz, Pettie, and Porat [29] established hardness of 2-Set-Disjointness under the 3-SUM
Conjecture, and Vassilevska Williams and Xu [41] showed that the same hardness holds under the
Zero-3-Clique Conjecture (and thus also under the APSP Conjecture).
Theorem 24 (Corollary 3.12 in [41]). Assuming the Zero-3-Clique Conjecture (or the 3-SUM or
APSP Conjecture), for any 0 < 훾< 1 and any 휀> 0, on 2-Set-Disjointness instances I with 푛sets,
each of size 푂(푛1−훾), and universe size |푈| = Θ(푛2−2훾), the total time of preprocessing and Θ(푛1+훾)
queries cannot be 푂(푛2−휀).
This implies Theorem 23 for 푘= 2.
Corollary 25. If there is 휀> 0 such that for all 훿> 0 there is an algorithm for 2-Set-Disjointness
that, given an instance I, answers queries in time 푂(∥I∥훿) after preprocessing time 푂(∥I∥2−휀), then
the Zero-3-Clique Conjecture is false (and thus also the 3-SUM and APSP Conjectures are false).

---

16
Karl Bringmann, Nofar Carmeli, and Stefan Mengel
Proof. Assume that we can solve 2-Set-Disjointness with preprocessing time 푂(∥I∥2−휀) and
query time 푂(∥I∥훿) where 훿:= 휀/10. Set 훾:= 1 −4훿, and consider an instance I consisting of
푛sets, each of size 푂(푛1−훾), so the input size is ∥I∥= 푂(푛2−훾). Over Θ(푛1+훾) queries, the total
query time is푂(푛1+훾∥I∥훿) ≤푂(푛1+훾+2훿) = 푂(푛2−2훿). The preprocessing time on I is푂(∥I∥2−휀) =
푂(푛(2−훾) (2−10훿)) = 푂(푛(1+4훿) (2−10훿)) = 푂(푛2−2훿). Hence, the total time of the preprocessing and
Θ(푛1+훾) queries on I is 푂(푛2−휀′) for 휀′ := 2훿. This contradicts Theorem 24 (for parameters 훾,휀′).
□
In particular, by combining our previous reductions, for 푄★
2 with a bad order 퐿there is no algo-
rithm with polylogarithmic access time and preprocessing 푂(|퐷|2−휀), assuming any of the three
conjectures mentioned above.
Generalization to 풌≥2
In the following, we show how to rule out preprocessing time 푂(∥I∥푘−휀) for 푘-Set-Disjointness
for any 푘≥2. To this end, we make use of the Zero-(푘+ 1)-Clique Conjecture. Our chain of
reductions closely follows the proof of the case 푘= 2 by Vassilevska Williams and Xu [41], but
also uses additional ideas required for the generalization to larger 푘.
5.1
푘-Set-Intersection
We start by proving a lower bound for the following problem of listing many elements in a set
intersection.
Deﬁnition 26. In the 푘-Set-Intersection problem, we are given an instance I consisting of a
universe 푈and families A1, . . . , A푘⊆2푈of subsets of 푈. We denote the sets in family A푖by
푆푖,1, . . . , 푆푖,|A푖|. The task is to preprocess I into a data structure that can answer queries of the
following form: Given indices 푗1, . . . , 푗푘and a number푇, compute the set 푆1,푗1 ∩. . . ∩푆푘,푗푘if it has
size at most 푇; if it has size more than 푇, then compute any 푇elements of this set.
We denote the number of sets by 푛:= Í
푖|A푖| and the input size by ∥I∥:= Í
푖
Í
푆∈A푖|푆|. We
call |푈| the universe size.
The main result of this section shows that푘-Set-Intersection is hard in the following sense. Later
we will use this result to show hardness for 푘-Set-Disjointness.
Theorem 27. Assuming the Zero-(푘+ 1)-Clique Conjecture, for every constant 휀> 0 there exists
a constant 훿> 0 such that no randomized algorithm solves 푘-Set-Intersection on 푛sets, universe size
|푈| = 푛, and 푇= Θ(푛1−휀/2) in preprocessing time 푂(푛푘+1−휀) and query time 푂(푇푛훿).
We prove Theorem 27 in the rest of this section. The idea of this proof is as follows. We take
a ﬁnite range that is big enough to contain all possible clique weights, and we spread the edge
weights evenly over this range using random choices in a way that maintains the zero-cliques. We
split this range into many intervals of small size, and we compute the set 푆of all tuples of 푘+ 1
intervals for which there exists a choice of an element from each interval such that all chosen
elements sum up to zero. We have that for every zero-clique (푣1, . . . ,푣푘+1), there exists an interval
tuple in 푆such that the weight of the clique formed by (푣1, . . . ,푣푘) falls within the ﬁrst interval, and
the weights of the edges between 푣푘+1 and the other vertices of the clique fall within the other 푘
intervals. In this way, all zero-cliques lie within a tuple of intervals in 푆. For every interval tuple in
푆, we use the 푘-Set-Intersection algorithm to ﬁnd many vertex tuples that fall within this interval
tuple. For each such candidate vertex tuple, we check whether it indeed forms a zero-clique. This
algorithm ﬁnds a zero-clique if one exists with a constant success probability. If the algorithm
does not detect a zero-clique, it declares that there are none. Repeating this process with diﬀerent

---

Tight Fine-Grained Bounds for Direct Access on Join Qeries
17
random choices yields an algorithm that succeeds with high probability. We next describe our
construction in more detail.
Preparations. First note that ﬁnding a zero-푘-clique in a general graph is equivalent to ﬁnding
a zero-푘-clique in a complete 푘-partite graph. This can be shown using a reduction in which each
vertex 푣is duplicated 푘times, giving vertices of the form (푣,푖) with 1 ≤푖≤푘, and each edge {푢, 푣}
is replaced by the 푘2 −푘edges {(푢,푖), (푣, 푗)} for 1 ≤푖, 푗≤푘and 푖≠푗; then, to make this 푘-partite
graph complete, edges of very large weight are added where needed.
Observation 28 ([1]). If the Zero-푘-Clique Conjecture is true, then it is also true restricted to
complete 푘-partite graphs.
Due to this observation, we can assume that we are given a complete (푘+ 1)-partite graph
퐺= (푉, 퐸) with 푛vertices and with color classes 푉1, . . . ,푉푘+1 and a weight function 푤on the edges.
We denote by 푤(푢, 푣) the weight of the edge from 푢to 푣, and more generally by 푤(푣1, . . . ,푣ℓ) :=
Í
1≤푖<푗≤ℓ푤(푣푖, 푣푗) the total weight of the clique (푣1, . . . ,푣ℓ).
For our construction it will be convenient to assume that the edge weights lie in a ﬁnite ﬁeld.
Recall that in the Zero-(푘+1)-Clique problem we can assume that all weights are integers between
−푛푐and 푛푐for some constant 푐. We ﬁrst compute a prime number between 10(푘+ 1)2푛푐and
100(푘+ 1)2푛푐by a standard algorithm: Pick a random number in that interval, check whether it is
a prime, and repeat if it is not. By the prime number theorem, a random number in that interval
is a prime with probability Θ(1/log(푛)). It follows that in expected time 푂(polylog(푛)) we ﬁnd a
prime 푝in that interval.
Having found the large prime 푝, we consider all edge weights as given in the ﬁnite ﬁeld F푝. Note
that 푝is bigger than the sum of weights of any (푘+ 1)-clique in 퐺, so the (푘+ 1)-cliques of weight
0 are the same over Z and F푝. Thus, in the remainder we assume all arithmetic to be done over F푝.
In our analysis, it will be necessary to assume that the input weights are evenly distributed in F푝.
This is generally of course not the case, so we have to distribute them more evenly. To this end, we
use a hashing technique that redistributes the weights close to randomly while maintaining the
zero-cliques. Concretely, we deﬁne a new weight function푤′ : 퐸→F푝by choosing independently
and uniformly at random from F푝:
• one value 푥,
• for all 푣∈푉푘+1 and all 푗∈[푘−1] a value 푦푗
푣.
We deﬁne a new weight function 푤′ by setting for every 푖, 푗∈[푘+ 1] with 푖≠푗and every 푣∈푉푖
and 푢∈푉푗:
푤′(푣,푢) = 푥· 푤(푣,푢) +


푦1
푢,
if 푖= 1, 푗= 푘+ 1
푦푖
푢−푦푖−1
푢
,
if 2 ≤푖< 푘, 푗= 푘+ 1
−푦푘−1
푢
,
if 푖= 푘, 푗= 푘+ 1
0,
otherwise
(1)
Note that in every (푘+ 1)-clique (푣1, . . . , 푣푘+1) ∈푉1 × . . . × 푉푘+1 the sum 푤′(푣1, . . . ,푣푘+1) contains
every term 푦푖
푣푘+1 for 푖∈[푘−1] once positively and once negatively, so for the overall weight we
have 푤′(푣1, . . . ,푣푘+1) = 푥· 푤(푣1, . . . ,푣푘+1). In particular, every zero-clique according to 푤is also a
zero-clique according to 푤′, and we continue the construction with the weight function 푤′.
We next split F푝into 푛휌disjoint intervals of size ⌈푝/푛휌⌉or ⌊푝/푛휌⌋, where 휌is a constant that
we will choose later such that 푝≥푛휌. In the following, 퐼푖always denotes an interval resulting
from this splitting of F푝. We denote by 푆the set of all tuples (퐼0, . . . , 퐼푘) of intervals in F푝such that
0 ∈Í푘
푖=0 퐼푖. Note that there are only 푂(푛휌푘) tuples in 푆and they can be enumerated eﬃciently:

---

18
Karl Bringmann, Nofar Carmeli, and Stefan Mengel
given 퐼0, . . . , 퐼푘−1, the set −Í푘−1
푖=0 퐼푖is covered by Θ(푘) = Θ(1) intervals 퐼푘, and these intervals can
be computed eﬃciently.
For any clique 퐶= (푣1, . . . ,푣푘+1) ∈푉1 × . . . ×푉푘+1 there is a unique tuple (퐼0, . . . , 퐼푘) of intervals
such that
∀푖∈[푘] : 푤′(푣푖, 푣푘+1) ∈퐼푖and 푤′(푣1, . . . , 푣푘) ∈퐼0.
(2)
We call (퐼0, . . . , 퐼푘) the weight interval tuple of 퐶. If퐶is a zero-clique, then its weight interval tuple
must be in 푆.
The Reduction. With these preparations, we are now ready to present our reduction. For every
weight interval tuple (퐼0, . . . , 퐼푘) ∈푆we construct an instance of 푘-Set-Intersection as follows. For
any 푖∈[푘] we construct
A푖:= {푆푖,푣| 푣∈푉푖} where 푆푖,푣:= {푢∈푉푘+1 | 푤′(푣,푢) ∈퐼푖}.
Note for every tuple (푣1, . . . ,푣푘) ∈푉1 × . . . 푉푘(which plays the role of 푗1, . . . , 푗푘) the equivalence
푢∈푆1,푣1 ∩. . . ∩푆푘,푣푘⇔∀푖∈[푘]푤′(푣푖,푢) ∈퐼푖.
Moreover, we consider the set of queries
푄:= {(푣1, . . . ,푣푘) ∈푉1 × . . . × 푉푘| 푤′(푣1, . . . , 푣푘) ∈퐼0}.
We ﬁrst run the preprocessing of 푘-Set-Intersection on the instance I = (A1, . . . , A푘) and then
query each (푣1, . . . ,푣푘) ∈푄with parameter 푇:= ⌈100 · 3푘푛1−푘휌⌉(so we compute the entire set
푆1,푣1 ∩. . . ∩푆푘,푣푘if it has at most 푇elements, and otherwise we compute 푇elements of this set).
For each answer 푣푘+1 returned by some query (푣1, . . . ,푣푘) ∈푄, we check whether (푣1, . . . ,푣푘+1) is
a zero-clique with respect to 푤, and if it is, then we return this zero-clique.
After repeating this construction for every weight interval tuple (퐼0, . . . , 퐼푘) ∈푆, if we never
found a zero-clique, then we return ‘no’.
Correctness. Let us show correctness of the reduction. Since we explicitly test for each query
answer whether it is a zero-clique, if 퐺contains no zero-clique then our reduction returns ‘no’.
We next show that if there exists a zero-clique then our reduction returns a zero-clique with
probability at least .99. To this end, we use the following claim.
Claim 1. Let (푣1, . . . ,푣푘+1) ∈푉1 × . . . × 푉푘+1 be a zero-clique. Then, with probability at least .99,
there are less than 100 · 3푘푛1−푘휌vertices 푢∈푉푘+1 such that (푣1, . . . ,푣푘,푢) is not a zero-clique and has
the same weight interval tuple as (푣1, . . . ,푣푘+1).
We ﬁrst ﬁnish the correctness proof and later prove the claim. Fix any zero-clique (푣1, . . . , 푣푘+1),
and denote its weight interval tuple by (퐼0, . . . , 퐼푘). Note that we query (푣1, . . . , 푣푘) in the instance
constructed for (퐼0, . . . , 퐼푘). With probability at least 0.99, this query has less than 100·3푘푛1−푘휌“false
positives”, that is, vertices 푢∈푉푘+1 such that (푣1, . . . ,푣푘,푢) has weight interval tuple (퐼0, . . . , 퐼푘)
and (푣1, . . . ,푣푘,푢) is not a zero-clique. Then by listing 푇= ⌈100 · 3푘푛1−푘휌⌉answers for the query
(푣1, . . . , 푣푘), at least one answer 푣must correspond to a zero-clique. (That is, we do not necessarily
ﬁnd 푣푘+1, but we ﬁnd some vertex 푣forming a zero-clique together with 푣1, . . . ,푣푘.)
Hence, with probability at least .99 we ﬁnd a zero-clique, if there exists one. This probability can
be boosted to high probability (that is, probability 1−1/푛푑for any desirable constant푑) by repeating
the reduction algorithm푂(푑log푛) times and returning a zero-clique if at least one repetition ﬁnds
a zero-clique. This repetition incurs a logarithmic factor in the runtime of our algorithm which we
will ignore later on since it is dominated by the polynomial terms we analyze there.

---

Tight Fine-Grained Bounds for Direct Access on Join Qeries
19
Proof of Claim 1. To ease notation, let 푣:= 푣푘+1. Let (퐼0, . . . , 퐼푘) be the weight interval tuple
of (푣1, . . . ,푣푘, 푣), that is, 푤′(푣푖, 푣) ∈퐼푖for 푖∈[푘], and 푤′(푣1, . . . , 푣푘) ∈퐼0. Let 푢∈푉푘+1 such that
(푣1, . . . , 푣푘,푢) is not a zero-clique. If (푣1, . . . ,푣푘,푢) has the same weight interval tuple, then for
every 푖∈[푘] we have 푤′(푣푖,푢) ∈퐼푖. It then follows that
∀푖∈[푘] : 푤′(푣푖,푣) −푤′(푣푖,푢) ∈[−푝푛−휌,푝푛−휌].
(3)
We want to bound the probability that this happens, over the random choices in the construction
of 푤′. To this end, write 푤′
푖:= 푤′(푣푖, 푣) −푤′(푣푖,푢) and 푤푖:= 푤(푣푖, 푣) −푤(푣푖,푢) for all 푖∈[푘].
Expanding the deﬁnition of 푤′ (see (1)) we obtain
푤′
1 = 푥· 푤1 + (푦1
푣−푦1
푢),
푤′
푖= 푥· 푤푖−(푦푖−1
푣
−푦푖−1
푢
) + (푦푖
푣−푦푖
푢) for each 푖∈{2, . . . ,푘−1}
푤′
푘= 푥· 푤푘−(푦푘−1
푣
−푦푘−1
푢
),
(4)
We claim that for ﬁxed 푤1, . . . ,푤푘and 푦1
푣, . . . ,푦푘−1
푣
the above equations induce a bijection send-
ing (푤′
1, . . . ,푤′
푘) to (푥,푦1
푢, . . . ,푦푘−1
푢
). Indeed, by the equations (4) we can compute (푤′
1, . . . ,푤′
푘)
given (푥,푦1
푢, . . . ,푦푘−1
푢
). For the other direction, we use that (푣1, . . . , 푣푘,푣) is a zero-clique (that is,
푤(푣1, . . . , 푣푘,푣) = 0), and (푣1, . . . ,푣푘,푢) is not a zero-clique (that is, 푤(푣1, . . . ,푣푘,푢) ≠0). This
implies
0 ≠푤(푣1, . . . , 푣푘,푣) −푤(푣1, . . . , 푣푘,푢) =
푘
Õ
푖=1
(푤(푣푖, 푣) −푤(푣푖,푢)) =
푘
Õ
푖=1
푤푖.
By adding up all equations (4), since each term 푦푖
푣and 푦푖
푢appears once positively and once nega-
tively, we obtain 푤′
1 + . . . + 푤′
푘= 푥· (푤1 + . . . + 푤푘). Hence, given (푤′
1, . . . ,푤′
푘), we can compute
푥= (푤′
1 + . . . + 푤′
푘)/(푤1 + . . . + 푤푘). Note that here we do not divide by 0 since Í푘
푖=1 푤푖≠0. Next
we can compute 푦1
푢= 푥· 푤1 + 푦1
푣−푤′
1 by rearranging the ﬁrst equation of (4) (recall that 푤1 and
푦1
푣are ﬁxed, we are given 푤′
1, and we just computed 푥, so each variable on the right hand side is
known). Similarly, from 푥and 푦푖−1
푢
we can compute 푦푖
푢= 푥· 푤푖−(푦푖−1
푣
−푦푖−1
푢
) +푦푖
푣−푤′
푖. Iterating
over all 푖computes (푥,푦1
푢, . . . ,푦푘−1
푢
) given (푤′
1, . . . ,푤′
푘).
Since we showed a bijection sending (푤′
1, . . . ,푤′
푘) to (푥,푦1
푢, . . . ,푦푘−1
푢
), and since 푥,푦1
푢, . . . ,푦푘−1
푢
are all chosen independently and uniformly random from F푝, we obtain that (푤′
1, . . . ,푤′
푘) is uni-
formly random in F푘
푝. In particular, each 푤′
푖= 푤′(푣푖,푣) −푤′(푣푖,푢) is independently and uniformly
at random distributed in F푝. Thus, since the intervals in expression (3) have size at most 2푝푛−휌+1,
the probability of expression (3) being true (which is greater than or equal to the probability that
(푣1, . . . , 푣푘,푣) and (푣1, . . . ,푣푘,푢) have the same weight interval tuple) is at most
2푝푛−휌+ 1
푝
푘
≤3푘푛−푘휌,
where we use the fact that 푝≥푛휌. Thus, given 푢∈푉푘+1 such that (푣1, . . . ,푣푘,푢) is not a zero-
clique, the probability that (푣1, . . . ,푣푘,푢) has the same weight interval tuple as (푣1, . . . , 푣푘+1) is at
most 3푘푛−푘휌.
Let 푋be the random variable that is the number of vertices 푢∈푉푘+1 satisfying the condi-
tions in the claim (i.e., (푣1, . . . , 푣푘,푢) is not a zero-clique and has the same weight interval tuple
as (푣1, . . . , 푣푘+1)). As |푉푘+1| ≤푛and the probability of each 푢∈푉푘+1 to satisfy the conditions is at
most 3푘푛−푘휌, the expectation of 푋is 퐸(푋) ≤3푘푛1−푘휌. We can apply Markov’s inequality to get
Pr(푋≥100퐸(푋)) ≤
1
100, implying that Pr(푋≥100 · 3푘푛1−푘휌) ≤
1
100. This proves the claim.
□

---

20
Karl Bringmann, Nofar Carmeli, and Stefan Mengel
Running Time. It remains to analyze the running time and to set the parameter 휌. Assume, to
the contrary of the theorem statement, that for some 휀> 0 푘-Set-Intersection on 푛sets, universe
size |푈| = 푛, and 푇= Θ(푛1−휀/2) can be solved with preprocessing time 푂(푛푘+1−휀) and query time
푂(푇푛훿) for 훿:=
휀
4푘. We assume w.l.o.g. that 휀≤1. Note that our constructed instances have
universe size |푈| = |푉푘+1| ≤푛(which can be embedded into a universe of size |푈| = 푛), and
푇= 푂(푛1−푘휌), so by setting 휌:=
휀
2푘the 푘-Set-Intersection algorithm can be applied. Note that
indeed 푝≥푛휌as we promised earlier.
Over 푂(푛푘휌) instances (one for every interval tuple in 푆), we have that the total preprocessing
time is 푂(푛푘+1+푘휌−휀) = 푂(푛푘+1−휀/2), since 휌=
휀
2푘.
Let us count the total number of queries. Note that (푣1, . . . ,푣푘) is queried in the instance for
(퐼0, . . . , 퐼푘) ∈푆if and only if 푤′(푣1, . . . ,푣푘) ∈퐼0. Recall that for every 퐼0, . . . , 퐼푘−1 there are 푂(1)
choices for 퐼푘such that (퐼0, . . . , 퐼푘) ∈푆. Hence, each (푣1, . . . ,푣푘) is queried in 푂(푛(푘−1)휌) instances,
as there are 푂(푛휌) choices for each of 퐼1, . . . , 퐼푘−1 and 푂(1) choices for 퐼푘. The total number of
queries is thus 푂(푛푘+(푘−1)휌). Each query runs in time 푂(푇푛훿) = 푂(푛1−푘휌+훿), so the total query
time over all our constructed instances is 푂(푛푘+(푘−1)휌· 푛1−푘휌+훿) = 푂(푛푘+1+훿−휌) = 푂(푛푘+1−휌/2)
since we set 훿= 휌/2.
In total, we obtain running time 푂(푛푘+1−휌/2) for Zero-(푘+ 1)-Clique, contradicting the Zero-
(푘+ 1)-Clique Conjecture. This concludes the proof of Theorem 27.
□
5.2
Unique-풌-Set-Intersection
As the next step, we show hardness of 푘-Set-Intersection for푇= 1, and even if we get the promise
that there is a unique answer to a query. We formally deﬁne this problem as follows.
Deﬁnition 29. The Unique-푘-Set-Intersection problem has the same input I = (A1, . . . , A푘)
with A푖= {푆푖,1, . . . ,푆푖,|A푖|} ⊆2푈as 푘-Set-Intersection (cf. Deﬁnition 26). In the query, we are
given indices 푗1, . . . , 푗푘, and if the set 푆1,푗1 ∩. . . ∩푆푘,푗푘consists of exactly one element, then we
return that element; otherwise we return the error element ⊥. Again we write 푛= Í
푖|A푖|.
We show how to reduce 푘-Set-Intersection to Unique-푘-Set-Intersection.
Lemma 30. For every 0 < 휃≤1, every 휀> 0 and every 훿> 0, if there is a randomized algorithm
for Unique-푘-Set-Intersection on 푛sets and universe size 푂(푛휃) with preprocessing time e
푂(푛푘−휀) and
query time e
푂(푛훿), then there is a randomized algorithm for 푘-Set-Intersection on 푛sets, universe size
|푈| = 푛, and 푇= Θ(푛1−휃) with preprocessing time e
푂(푇푛푘−휀) and query time e
푂(푇푛훿).
Proof. The proof idea is as follows. We create many instances of Unique-푘-Set-Intersection
by restricting the k-Set-intersection instance according to subsamples of the universe, and we
return the union of the answers returned by the Unique-푘-Set-Intersection algorithm over these
instances. By properly choosing the number of instances and the subsampling probability, we can
show that this process generates with high probability enough answers while maintaining the
required running time. We next describe this idea in more detail.
Let I be an instance of 푘-Set-Intersection with families A1, . . . , A푘of total size 푛= Í
푖|A푖|
over a universe 푈of size |푈| = 푛, and let 푇= Θ(푛1−휃) be the query size bound. For every
ℓ∈{log(푇), . . . , log(4푛)} and every 푗∈[100푇ln(푛)] we create an instance Iℓ,푗of Unique-푘-Set-
Intersection by subsampling with probability 2−ℓ, i.e., starting from I and keeping each element
in the universe 푈with probability 2−ℓand otherwise deleting it from all sets in A1, . . . , A푘.
Denote by푈ℓ,푗the surviving universe elements of Iℓ,푗. We want to show that with high probabil-
ity푈푗,ℓdoes not contain more than Θ(푛휃) elements. Clearly, the probability that푈ℓ,푗has more than
Θ(푛휃) elements only increases when the probability that an individual element survives increases,
so if ℓdecreases. Thus, we get Pr(|푈ℓ,푗| ≥푝) ≤Pr(|푈log(푇),푗| ≥푝) for any value 푝.

---

Tight Fine-Grained Bounds for Direct Access on Join Qeries
21
Note that in expectation the size of푈log(푇),푗is 퐸(|푈log(푇),푗|) = |푈|·2−log(푇) = 푛
푇= Θ(푛휃). We will
use the following basic Chernoﬀbound: let 푋1, . . . ,푋푟be independent Bernoulli random variables
and let 푋be their sum. Then we have Pr(푋≥(1+훿)퐸(푋)) ≤

푒훿
(1+훿)1+훿
퐸(푋)
for any 훿> 0. Setting
훿:= 1, we get in our case
Pr(|푈ℓ,푗| ≥2퐸(|푈log(푇),푗|)) ≤Pr(|푈log(푇),푗| ≥2퐸(|푈log(푇),푗|)) ≤
 푒
22
퐸(|푈log (푇),푗|)
≤0.7퐸(|푈log (푇),푗|).
Using a union bound over all 푂(푇log2(푛)) instances Iℓ,푗, we get that with high probability none
of the 푈ℓ,푗will have more than Θ(푛휃) elements. So in the remainder of this proof, we assume that
this is the case (if we ever encounter a universe that is too large in the subsampling, we simply let
the algorithm fail; since the probability is small, this is not a problem for the success probability).
After the subsampling, we use the assumed algorithm for Unique-푘-Set-Intersection to prepro-
cess all instances Iℓ,푗. Then, given a query (푗1, . . . , 푗푘), we run the algorithm for Unique-푘-Set-
Intersection on all instances Iℓ,푗, ﬁlter out ⊥-answers, remove duplicates, and return up to 푇of
the remaining answers.
Let us analyze this algorithm. Since we ﬁlter out wrong answers, all answers we return are
correct. It remains to show that with good probability we return enough answers. To this end,
ﬁx a query and assume that the instance I has 푟> 0 answers for that query. Pick ℓsuch that
푟+푇∈[2ℓ−1, 2ℓ] and consider what happens in the queries on the instances Iℓ,푗. For every answer
푣, consider the event E푣that 푣is isolated by instance Iℓ,푗, that is, 푣survives the subsampling, but
none of the other 푟−1 solutions survive the subsampling. This event has probability
Pr(E푣) = 1
2ℓ

1 −1
2ℓ
푟−1
≥
1
2(푟+푇)

1 −
1
푟+푇
푟+푇
≥
1
6(푟+푇),
where in the ﬁrst inequality we used that 푟+푇≤2ℓ≤2(푟+푇) and푇≥0, and for the last inequality
we assume that 푟+푇≥10 in which case  1 −
1
푟+푇
푟+푇≥1
3. Assume ﬁrst that 푟≤2푇, so the above
probability is at least
1
18푇≥
1
20푇. Then the probability that the answer 푣is not isolated in any
instance Iℓ,푗over all 푗∈[100푇ln(푛)] is at most (1−
1
20푇)100푇ln(푛) = 푛100푇ln(1−
1
20푇) ≤푛−5 (using the
fact ln(1−푥) ≤−푥). By a union bound over all푟≤|푈| = 푛answers, with probability ≥1−푛−4 each
of the 푟answers will be isolated in some instance Iℓ,푗, so the Unique-푘-Set-Intersection algorithm
will return each answer at least once. Hence, we see all answers and can correctly return min{푟,푇}
of them.
Now consider the case 푟> 2푇. We have 100푇ln(푛) rounds where in round 푗we make a random
experiment, creating an instance Iℓ,푗as above. This is essentially a coupon collector problem (see
e.g. [32] for more background) which we analyze next. We will show that with high probability we
found푇diﬀerent answers after all rounds are done. If the event E푣happens, we say that the answer
푣was found. Since the events E푣are disjoint, in each round we get an answer with probability at
least
푟
6(푟+푇) ≥
푟
6(푟+ 1
2푟) = 1
9 ≥1
10.
In case we get an answer, it is a uniformly random one. Since 푇< 푟/2, as long as we have seen
less than 푇distinct answers, the probability that the next answer is a fresh one is at least half. In
combination with the bound on getting an answer, in each round we ﬁnd an answer that we have
not seen before with probability at least 1
20. We next treat the 100푇ln(푛) rounds as 푇batches of
100 ln(푛) rounds. The probability of not getting a new answer in a batch of 100 ln(푛) rounds is

---

22
Karl Bringmann, Nofar Carmeli, and Stefan Mengel
at most (1 −1
20)100 ln(푛) ≤푛−5. Taking the union bound over 푇batches, we get at least 푇distinct
answers over all rounds with probability at least 1 −푇
푛5 ≥1 −1
푛4 .
In both cases, with high probability we return the correct answer.
To analyze the running time, note that we construct 100푇ln(푛) = e
푂(푇) instances Iℓ,푗, so the
preprocessing takes time e
푂(푇푛푘−휀). Also, each query to an instance Iℓ,푗takes time e
푂(푛훿) and
since we make e
푂(푇) of them, the total time of all queries is e
푂(푇푛훿). Finally, note that the diﬀerent
answers can easily be collected in, say, a binary search tree on which all operations are in time
푂(ln(푇)) = e
푂(1), so the queries to I can overall be answered in time e
푂(푇푛훿).
□
5.3
풌-Set-Disjointness
Recall that the 푘-Set-Disjointness problem is deﬁned similarly as 푘-Set-Intersection, except that
a query should just decide whether the intersection 푆1,푗1 ∩. . . ∩푆푘,푗푘is empty or not. Here an
instance I is given by a universe set 푈and families A1, . . . , A푘⊆2푈, where we write A푖=
{푆푖,1, . . . ,푆푖,|A푖|}. Again we denote the number of sets by 푛= Í
푖|A푖|.
Lemma 31. Let 휀,훿> 0 and 0 < 휃< 1 be constants. If there is a randomized algorithm for 푘-
Set-Disjointness on 푛sets and universe size |푈| = Θ(푛휃) with preprocessing e
푂(푛푘−휀) and query time
e
푂(푛훿), then there is a randomized algorithm for Unique-푘-Set-Intersection on 푛sets and universe size
|푈| = Θ(푛휃) with preprocessing time e
푂(푛푘−휀) and query time e
푂(푛훿).
Proof. The principle of our reduction is given by the following claim.
Claim 2. Let 퐸be a set of words over {0, 1} of length ℓ. For every 푗∈[ℓ] and 푏∈{0, 1}, let 퐸푗,푏
denote the set of words in 퐸whose 푗th bit is diﬀerent from 푏. Then 퐸contains exactly one word if and
only if for all 푗∈[ℓ] exactly one of 퐸푗,0 and 퐸푗,1 is empty. Moreover, if 퐸= {푎}, then the 푗th bit 푎푗of
푎is the (unique) 푏∈{0, 1} such that 퐸푗,푏= ∅.
Proof. There are three cases depending on whether 퐸contains a single word, is empty or con-
tains at least two words:
• If 퐸= {푎}, then for all 푗and 푏we have 퐸푗,푏= ∅if 푏= 푎푗, and 푎∈퐸푗,푏≠∅if 푏≠푎푗.
• If 퐸= ∅, then for all 푗and 푏we have 퐸푗,푏= ∅since 퐸푗,푏⊆퐸by construction.
• If 퐸contains two distinct words that diﬀer on the 푗th bit, then 퐸푗,0 and 퐸푗,1 are non-empty.
This proves the claim.
□
We now describe an algorithm for Unique-푘-Set-Intersection, using an algorithm for 푘-Set-
Disjointness, and whose correctness will be justiﬁed with the previous claim. Let I be an instance
of Unique-푘-Set-Intersection consisting of sets A1, . . . , A푘. Assume w.l.o.g. that the universe 푈of
A is the set [|푈|], so that each element of 푈can be written with ℓ= ⌊log(|푈|)⌋+ 1 = 푂(log(푛))
bits, since |푈| = Θ(푛휃).
We create 2ℓinstances I푗,푏of 푘-Set-Disjointness, for 푗∈[ℓ] and 푏∈{0, 1}, as follows. For
any 푗∈[ℓ] and 푏∈{0, 1}, remove every 푣∈푈whose 푗th bit is 푏from the universe and from
all sets in A1, . . . , A푘, and call the resulting sets A푗,푏
푖. Deﬁne I 푗,푏to contain the sets A푗,푏
푖
and
the same queries as the original instance I. Denote by 푆푗,푏
푖,ℎthe sets belonging to A푗,푏
푖. We run
the preprocessing of the 푘-Set-Disjointness algorithm on each instance I 푗,푏. Now, given a query
푞= (ℎ1, . . . ,ℎ푘), we ask the same query for each instance I 푗,푏, for all 푗∈[ℓ] and 푏∈{0, 1}. By
deﬁnition, each answer 훼푗,푏we obtain is the answer yes/no to the question whether 퐸푗,푏is empty,
where 퐸푗,푏:= 푆푗,푏
1,ℎ1 ∩. . . ∩푆푗,푏
푘,ℎ푘. With Claim 2, we get that the following (two cases of the) answer
to 푞for the original instand I of Unique-푘-Set-Intersection is correct:

---

Tight Fine-Grained Bounds for Direct Access on Join Qeries
23
• if for all 푗∈[ℓ], we have exactly one of 퐸푗,0or 퐸푗,1 is empty, i.e., either 훼푗,0 = yes or
훼푗,1 = yes, then 푆푗,푏
1,ℎ1 ∩. . . ∩푆푗,푏
푘,ℎ푘= {푎} where the 푗th bit of 푎is the unique 푏such that
훼푗,푏= yes and we return 푎;
• otherwise, 푆푗,푏
1,ℎ1 ∩. . . ∩푆푗,푏
푘,ℎ푘does not contain a single element, and we return ⊥.
We have thus justiﬁed that the algorithm is correct. It is clear that it satisﬁes the claimed time
bounds.
□
So far we measured running times in terms of the number of sets 푛. Next we show how to obtain
lower bounds in terms of the input size ∥I∥= Í
푖
Í
푆∈A푖|푆| which is at most Í
푖|A푖| · |푈|.
Lemma 32. For any constants 휀,훿> 0, if there is an algorithm that solves 푘-Set-Disjointness with
preprocessing time e
푂(∥I∥푘−휀) and query time e
푂(∥I∥훿), then for any constant 0 < 휃≤
휀
2푘there is an
algorithm that solves 푘-Set-Disjointness on 푛sets and universe size |푈| = Θ(푛휃) with preprocessing
time e
푂(푛푘−휀/2) and query time e
푂(푛훿(1+휃)).
Proof. For every instance I of 푘-Set-Disjointness on universe size |푈| = Θ(푛휃), we have that
∥I∥= 푂(푛1+휃) because ∥I∥≤Í
푖|퐴푖| · |푈| ≤푛|푈|. Now on I, the assumed algorithm for 푘-Set-
Disjointness takes preprocessing time
e
푂(∥I∥푘−휀) = e
푂(푛푘+푘휃−휀−휃휀) = e
푂(푛푘−휀/2),
where we used 휃≤
휀
2푘in the last step. Observing that the query time is e
푂(∥I∥훿) = e
푂(푛훿(1+휃))
completes the proof.
□
Finally we are ready to prove the main result of this section: the hardness of 푘-Set-Disjointness
for all 푘≥2 based on the Zero-(푘+ 1)-Clique Conjecture.
Proof of Theorem 23. Almost all algorithms discussed in this proof are randomized; we omit
this word for readability.
Assume that there is a constant 휀> 0 such that for all 훿> 0 there is an algorithm for 푘-Set-
Disjointness with preprocessing time 푂(∥I∥푘−휀) and query time 푂(∥I∥훿).
For 휀′ :=
휀
2푘, Theorem 27 shows that there is a constant 훿′ > 0 such that 푘-Set-Intersection
on 푛sets, universe size |푈| = 푛, and 푇= Θ(푛1−휀′/2) has no algorithm with preprocessing time
푂(푛푘+1−휀′) and query time 푂(푇푛훿′), if we assume the Zero-(푘+ 1)-Clique Conjecture.
Using this 훿′, we set 훿:=
훿′
2(1+휀′/2) . Since we can solve 푘-Set-Disjointness with preprocessing
time푂(∥I∥푘−휀) and query time푂(∥I∥훿), by Lemma 32 for휃:= 휀′/2 there is an algorithm for푘-Set-
Disjointnesson푛sets and universe size Θ(푛휀′/2) with preprocessing time e
푂(푛푘−휀/2) and query time
e
푂(푛훿(1+휀′/2)) = e
푂(푛훿′/2). By Lemma 31, we get an algorithm with the same time bounds for Unique-
푘-Set-Intersection on 푛sets and universe size Θ(푛휀′/2). Then, using Lemma 30, we get an algorithm
for 푘-Set-Intersection on 푛sets, universe size |푈| = 푛, and 푇= Θ(푛1−휀′/2) with preprocessing
time e
푂(푇푛푘−휀/2) and query time e
푂(푇푛훿′/2) = 푂(푇푛훿′). We simplify the preprocessing time to
e
푂(푇푛푘−휀/2) = e
푂(푛푘+1−휀′/2−휀/2) = 푂(푛푘+1−휀′), where we used 휀′
2 < 휀′ =
휀
2푘<
휀
2. The obtained
preprocessing time 푂(푛푘+1−휀′) and query time 푂(푇푛훿′) contradict the statement that we got from
Theorem 27 in the last paragraph, so the Zero-(푘+ 1)-Clique Conjecture is false.
□
6
REMOVING SELF-JOINS IN DIRECT ACCESS
In Section 4.1 we showed how to simulate a 푘-star query by embedding it into another query 푄
of high incompatibility number. The construction required that 푄was self-join free. However, we
would like to show lower bounds also for queries that have self-joins. To this end, in this section,

---

24
Karl Bringmann, Nofar Carmeli, and Stefan Mengel
we show how to simulate direct access to queries without self-joins by direct access to queries
with self-joins in such a way that the incompatibility number—and in fact also the underlying
hypergraph—does not change. This will allow us to show hardness of queries with self-joins later
on. To state our result formally, we start with a deﬁnition. Let 푄be a join query, possibly with
self-joins. We say that a query 푄sf is a self-join free version of a query 푄if it can be obtained from
푄by replacing the relation symbols such that each relation symbol appears at most once in 푄sf.
The main result of this section is the following.
Theorem 33. Let 푄sf be a self-join-free version of a join query 푄, and let 퐿be a variable order
for 푄and 푄sf. If there is a lexicographic direct access algorithm for 푄by 퐿with preprocessing time
푝(|퐷|) ∈Ω(|퐷|) and access time 푟(|퐷|), then there is a lexicographic direct access algorithm for 푄sf
by 퐿with preprocessing time 푂(푝(|퐷|)) and access time 푂(푟(|퐷|) log2 |퐷|). The same sentence holds
after exchanging 푄and 푄sf.
One of the directions of Theorem 33 is trivial as an algorithm for a self-join free query can be
used to solve queries with self-joins with only linear overhead at preprocessing by duplicating the
relevant relations, and the log2(|퐷|) factor of the access time is not required. However, the other
direction is by no means trivial. In particular, the same claim for the task of enumeration instead
of direct access does not hold [11, 17]. We devote the rest of this section to proving this direction.
6.1
Colored and Self-Join-Free Versions
To prove that direct access for 푄implies direct access for 푄sf, it will be convenient to work with an
intermediate query. We deﬁne the colored version 푄푐of a query 푄to be the query obtained from
푄by adding the unary atom 푅푥(푥) for each variable 푥. The colored version is useful because it is
equivalent to any self-join free version:
Lemma 34. Let 푄푐and 푄sf be the colored version and a self-join-free version of the same join query
푄. There are lex-preserving exact reductions in both directions between 푄푐and 푄sf.
Proof. Without loss of generality, let 푄sf denote the self-join free version of 푄obtained by
replacing each atom 푅(푥1, . . . , 푥푘) by 푅푥1,...,푥푘(푥1, . . . ,푥푘) (where 푅푥1,...,푥푘is a new relation symbol
associated to 푅and the list of variables 푥1, . . . ,푥푘). The easy direction is the following exact reduc-
tion from 푄푐to 푄sf. Given a database 퐷푐for 푄푐, we construct in linear time the database 퐷sf as
follows. For every atom 푅(푥1, . . . , 푥푘) of 푄, we set
푅퐷sf
푥1,...,푥푘:= {(푎1, . . . ,푎푘) | 퐷푐|= 푅(푎1, . . . ,푎푘) ∧
Û
푖∈[푘]
푅푥푖(푎푖)}.
Obviously, this entails the equality 푄푐(퐷푐) = 푄sf(퐷sf) which shows the ﬁrst direction.
Let us construct the reduction from 푄sf to 푄푐. (Note that this is the reduction we will need in
the following.) Given a database 퐷sf for 푄sf, we construct in linear time the database 퐷푐deﬁned
as follows. We take dom(퐷푐) := var(푄) × dom(퐷sf). For each 푥∈var(푄), we set
푅퐷푐
푥
:= {(푥,푏) | 푏∈dom(퐷sf)},
and for each atom 푅(푥1, . . . , 푥푘) of 푄, we include in 푅퐷푐
{((푥1,푎1), . . . , (푥푘,푎푘)) | 퐷sf |= 푅푥1,...,푥푘(푎1, . . . ,푎푘)}.
That is, 푅퐷푐is deﬁned by the union of the corresponding relations in 푄sf.
For every tuple (푎1, . . . ,푎푘) ∈(dom(퐷sf))푘, we get the equivalence
퐷sf |= 푅푥1,...,푥푘(푎1, . . . ,푎푘) ⇔퐷푐|= 푅((푥1,푎1), . . . , (푥푘,푎푘)) ∧
Û
푖∈[푘]
푅푥푖((푥푖,푎푖)).

---

Tight Fine-Grained Bounds for Direct Access on Join Qeries
25
This immediately implies for every assignment 푎of the variables of 푄sf in dom(퐷sf) the equiva-
lence 푎∈푄sf(퐷sf) ⇔¯푎∈푄푐(퐷푐) where ¯푎is the mapping that assigns to every 푥∈var(푄) the
value (푥,푎(푥)). It is easy to verify that the function 푎↦→¯푎is a bijection between 푄sf(퐷sf) and
푄푐(퐷푐), computable in constant time and preserving any lexicographic order.
□
Lemma 34 implies that if there is a direct-access algorithm for 푄푐in some lexicographic order 퐿,
then there is a direct-access algorithm for 푄sf in order 퐿with the same time guarantees. With this
at hand, it is left to prove that eﬃcient direct access for any query implies the same for its colored
version.
6.2
Counting Under Prefix Constraints and Direct Access
A natural approach for lexicographic direct access is to decide on the assignment to the variables
one at a time in the required order. This approach has a strong connection to the task of count-
ing the possible assignments when a preﬁx of the variables is already determined, and it will be
convenient in our proof to go through this intermediate task.
Consider the following notion of constraints on answers. Let 푄be a join query, 퐿an order of
its variables, and 퐷a database. We deﬁne a preﬁx constraint 픠on a preﬁx 푥1, . . . , 푥푟of 퐿to be a
mapping 픠on variables {푥1, . . . ,푥푟} such that for푖∈[푟−1] we have 픠(푥푖) ∈dom(퐷) and 픠(푥푟) is an
interval in dom(퐷). We denote by var(픠) the set {푥1, . . . ,푥푟} of variables on which 픠is deﬁned. To
make the notation for preﬁx constraints more symmetric, we treat elements of dom(퐷) as intervals
of length 1, so 픠maps all 푥푖in the preﬁx to intervals, but for 푖∈[푟−1] these intervals have length
1. We say that an answer 푎∈푄(퐷) satisﬁes the preﬁx constraint 픠if and only if for all 푖∈[푟]
we have 푎(푥푖) ∈픠(푥푖). Counting under preﬁx constraints is a task deﬁned by a query and an order
where, after a preprocessing phase on a database, the user can specify a preﬁx constraint 픠and
expect the number of query answers that satisfy 픠. We call the time it takes to provide an answer
given a preﬁx constraint the counting time.
Preﬁx constraints will be useful in the proof of Theorem 33 due to the following equivalence
between direct access and counting.
Proposition 35. Let 푄be a join query and 퐿an ordering of its variables.
• If lexicographic direct access for 푄and 퐿can be done with preprocessing time 푝(|퐷|) ∈Ω(|퐷|)
and access time 푟(|퐷|), then counting under preﬁx constraints for 푄and 퐿can be done with
preprocessing time 푂(푝(|퐷|)) and counting time 푂(푟(|퐷|) log |퐷|).
• If counting under preﬁx constraints for 푄and 퐿can be done with preprocessing time 푝(|퐷|) ∈
Ω(|퐷|) and counting time 푟(|퐷|), then lexicographic direct access for 푄and 퐿can be done
with preprocessing time 푂(푝(|퐷|)) and access time 푂(푟(|퐷|) log |퐷|).
Proof. To go from a direct access algorithm to a counting algorithm, note that the answers sat-
isfying a preﬁx constraint appear consecutively in the ordered list of query answers. We use binary
search to ﬁnd the indices of the ﬁrst and the last answers satisfying the given preﬁx constraint.
The diﬀerence between these indices is the count we are looking for.
For the other direction, given an index we want to access, we iteratively ﬁx the assignments
to the query variables in the speciﬁed order 퐿. For each variable, we perform binary search on
dom(퐷) by using preﬁx constraints to count the answers in the two halves of the interval and
choose the relevant half.
□
6.3
Counting Under Prefix Constraints for the Colored Version
The ﬁnal and most involved component of our proof of Theorem 33 is to use an algorithm for
counting under preﬁx constraints for any join query to solve the same task for its colored version.

---

26
Karl Bringmann, Nofar Carmeli, and Stefan Mengel
Lemma 36. Let 푄be a join query and 퐿an ordering of its variables. If there is an algorithm for
counting under preﬁx constraints for 푄and 퐿, then there is an algorithm for counting under preﬁx
constraints for the colored version 푄푐and 퐿with the same time guarantees.
Notice that, by combining Lemma 34 with Lemma 36, we get that an algorithm for counting
under preﬁx constraints for a join query implies an algorithm for counting under preﬁx constraints
for any of its self-join free versions.
We remark that Lemma 36 cannot simply be proven by constructing an equivalent database for
푄given a database for 푄푐by ﬁltering the original relations using the new unary relations and then
removing the unary relations, due to self-joins. As an example, if the query is 푄(푥,푦) :−푅(푥),푅(푦),
the colored version is 푄(푥,푦) :−푅(푥),푅(푦), 푅푥(푥),푅푦(푦), and we cannot simply eliminate the last
two atoms of the colored version by ﬁltering the other atoms because we cannot have two copies
of 푅each ﬁltered according to a diﬀerent variable. We next prove Lemma 36.
It will be convenient to have a more symmetric perspective on join queries. To this end, we
remind the reader of some basics on homomorphisms between ﬁnite structures. Let 퐴and 퐵be two
ﬁnite structures over the same vocabulary. Then ℎ: dom(퐴) →dom(퐵) is called a homomorphism
from 퐴to 퐵if and only if, for every relation 푅퐴of 퐴and every tuple (푎1, . . . ,푎푘) ∈푅퐴, we have
(ℎ(푎1), . . . ,ℎ(푎푘)) ∈푅퐵. To simplify notation, we make the convention ℎ(푎) := (ℎ(푎1), . . . ,ℎ(푎푘))
for 푎= (푎1, . . . ,푎푘). An automorphism of 퐴is a bijective homomorphism from 퐴to itself. We will
use the fact that homomorphisms compose, i.e., if ℎ1 is a homomorphism from 퐴to 퐵and ℎ2 is
a homomorphism from 퐵to 퐶, then (ℎ2 ◦ℎ1) deﬁned for every 푎∈dom(퐴) by (ℎ2 ◦ℎ1)(푎) :=
ℎ2(ℎ1(푎)) is a homomorphism from 퐴to 퐶.
Every query 푄is assigned a ﬁnite structure 퐴푄on domain var(푄) as follows: for every 푘-ary
relation symbol 푅of푄, the structure 퐴푄has a 푘-ary relation 푅퐴푄which contains exactly the tuples
(푥푖1, . . . , 푥푖푘) such that 푅(푥푖1, . . . , 푥푖푘) is an atom of 푄. Then ℎis an answer to 푄on a database 퐷if
and only if it is a homomorphism from 퐴푄to 퐷. The notions on preﬁx constraints carry over from
query answers to homomorphisms in the obvious way.
Example 37. Consider the join query 푄(푥,푦,푧) :−푅(푥),푅(푦), 푅(푧) which we will use as a running
example in this section. The associated structure 퐴푄has the domain {푥,푦,푧} and the single relation
푅퐴푄= {(푥), (푦), (푧)}. There are 33 homomorphisms from 퐴푄to itself (in this example, any variable
can map to any variable), but there are only 3! automorphisms. In particular, if we consider the
order 퐿= (푥,푦,푧) of the variables and we denote by (푎,푏,푐) the mapping {푥↦→푎,푦↦→푏,푧↦→푐}
for any values 푎,푏,푐, we get that the automorphisms correspond to the vectors of permutations of
the vertices.
Notation. For a join query 푄to a database 퐷, an order 퐿of var(푄), and a preﬁx constraint 픠,
we let hom(퐴푄, 퐷, 픠) denote the set of homomorphisms from 퐴푄to 퐷(corresponding to the set of
answers in 푄(퐷)) which satisfy 픠.
Let 퐷푐be a database on which we want to solve the counting problem for 푄푐. We construct
a new database 퐷over the relations of 푄(without the additional unary relations) as follows by
tagging the values of the database by variable names. For every relation symbol 푅of arity 푘of 푄,
the database 퐷contains the relation:
푅퐷:= {((푎1,푏1), . . . , (푎푘,푏푘)) | (푎1, . . . ,푎푘) ∈푅퐴푄, (푏1, . . . ,푏푘) ∈푅퐷푐, ∀푖∈[푘] : 푏푖∈푅퐷푐
푎푖}.
The domain is dom(퐷) = {(푎,푏) ∈var(푄)×dom(퐷푐) | 푏∈푅퐷푐
푎} which we order lexicographically,
so (푎,푏) ≺(푎′,푏′) ⇔푎≺퐿푎′ ∨(푎= 푎′ ∧푏≺푏′), where ≺퐿is the order relation of 퐿.
Example 38. Consider again the query from Example 37. The structure 퐴푄푐for the colored
version of the query has the relations 푅퐴푄푐= {(푥), (푦), (푧)}, 푅
퐴푄푐
푥
= {(푥)}, 푅
퐴푄푐
푦
= {(푦)}, and

---

Tight Fine-Grained Bounds for Direct Access on Join Qeries
27
푅
퐴푄푐
푧
= {(푧)}. Given a database 퐷푐with 푅퐷푐= {(푎), (푏), (푐)}, 푅퐷푐
푥
= {(푎), (푐)}, 푅퐷푐
푦
= {(푎), (푏)},
and 푅퐷푐
푧
= {(푎)}, we construct the database 퐷with 푅퐷= {(푥,푎), (푥,푐), (푦,푎), (푦,푏), (푧,푎)}.
Let 휋1 : dom(퐷) →var(푄) be the projection on the ﬁrst coordinate, i.e., for all (푎,푏) ∈dom(퐷)
we have 휋1(푎,푏) = 푎. Analogously, we deﬁne 휋2 : dom(퐷) →dom(퐷푐) as the projection to the
second coordinate. We will use the following simple observation throughout the remainder of this
proof.
Observation 39. Let ℎbe a homomorphism from 퐴푄to 퐷. Then we have (휋1 ◦ℎ)(var(푄)) =
var(푄) if and only if 휋1 ◦ℎis an automorphism.
Example 40. Consider ℎ1 = ((푦,푎), (푥,푎), (푧,푎)) and ℎ2 = ((푦,푎), (푦,푏), (푧,푎)) in our running
example, following the homomorphism notation given in Example 37. We have that 휋1 ◦ℎ1 is an
automorphism, while 휋1 ◦ℎ2 is not.
Now let 픠be a preﬁx constraint on a preﬁx 푥1, . . . , 푥푟of 퐿., i.e., we want to count the number
of answers ℎin 푄푐(퐷푐) which satisfy 픠. Note that this subset of the answers can equivalently
be seen as the set of homomorphisms ℎfrom 퐴푄푐to 퐷푐which satisfy 픠. We denote this set by
hom(퐴푄푐, 퐷푐,픠). We also denote by hom(퐴푄, 퐷, 픠)id the set of homomorphisms ℎ′ from 퐴푄to 퐷
for which 휋1 ◦ℎ′ is the identity, denoted id, on var(푄), and 휋2 ◦ℎ′ satisﬁes 픠. We show that there
is a bijection between these two sets of homomorphisms.
Claim 3.
| hom(퐴푄푐, 퐷푐, 픠)| = | hom(퐴푄, 퐷,픠)id|
Example 41. In our running example, consider the preﬁx constraint 픠assigning 푎to 푥. We have
that hom(퐴푄, 퐷,픠)id = {((푥,푎), (푦, 푎), (푧,푎)), ((푥,푎), (푦,푏), (푧,푎))}, and for the colored version we
have that hom(퐴푄푐, 퐷푐,픠) = {(푎, 푎,푎), (푎,푏,푎)}.
Proof of Claim 3. We show a bijection between hom(퐴푄푐, 퐷푐,픠) and hom(퐴푄, 퐷, 픠)id. For ev-
ery ℎ∈hom(퐴푄푐, 퐷푐, 픠), deﬁne 푃(ℎ) := ℎ′ where for every 푎∈var(푄) we set ℎ′(푎) := (푎,ℎ(푎)).
We claim that 푃is the required bijection.
We ﬁrst show that 푃is a mapping from hom(퐴푄푐, 퐷푐,픠) to hom(퐴푄, 퐷,픠)id. We show that ℎ′ is
a homomorphism from 퐴푄to 퐷. Consider any relation 푅퐴푄of 퐴푄and a tuple (푎1, . . . ,푎푘) ∈푅퐴푄.
Thenℎ′(푎1, . . . ,푎푘) = ((푎1,ℎ(푎1)), . . . , (푎푘,ℎ(푎푘))) by deﬁnition. We have that (ℎ(푎1), . . . ,ℎ(푎푘)) ∈
푅퐷푐, because ℎis a homomorphism. By deﬁnition of 푄푐, we have that 푎푖∈푅
퐴푄푐
푎푖
for all 1 ≤푖≤
푘. As ℎis a homomorphism from 퐴푄푐to 퐷푐, we have that ℎ(푎푖) ∈푅퐷푐
푎푖. By deﬁnition of 퐷, we
conclude that ℎ′(푎1, . . . ,푎푘) ∈푅퐷, and thus ℎ′ is indeed a homomorphism. By deﬁnition of ℎ′, we
have 휋1(ℎ′(푎)) = 푎for every 푎∈var(푄), so 휋1 ◦ℎ′ is the identity on var(푄). Moreover, since
ℎ∈hom(퐴푄푐, 퐷푐, 픠), we have that ℎsatisﬁes 픠and with ℎ= 휋2 ◦ℎ′ it follows that 휋2 ◦ℎ′ satisﬁes
픠. So we have that ℎ′ ∈hom(퐴푄, 퐷,픠)id.
It remains to show that 푃is a bijection. To show that 푃is injective, let ℎ1,ℎ2 ∈hom(퐴푄푐, 퐷푐,픠)
be two diﬀerent functions. There is 푎∈var(푄) such that ℎ1(푎) ≠ℎ2(푎). We get that 푃(ℎ1)(푎) =
(푎,ℎ1(푎)) ≠(푎,ℎ2(푎)) = 푃(ℎ2)(푎), so 푃(ℎ1) ≠푃(ℎ2), and thus 푃is indeed injective. To show
that 푃is surjective, let ℎ′ ∈hom(퐴푄, 퐷,픠)id. Then, by deﬁnition of 퐷, there is a function ℎ:
var(푄) →dom(퐷푐) such that for every 푎∈var(푄) we have ℎ′(푎) = (푎,ℎ(푎)). We claim that
ℎ∈hom(퐴푄푐, 퐷푐, 픠). This will prove surjectivity since 푃(ℎ) = ℎ′. First note that ℎ= 휋2 ◦ℎ′ and, by
deﬁnition of hom(퐴푄, 퐷,픠)id, 휋2 ◦ℎ′ satisﬁes 픠, so ℎsatisﬁes 픠. To see that ℎis a homomorphism,
consider ﬁrst the unary atoms of 푄푐of the form 푅푎(푎). Since for every 푎∈var(푄) we have ℎ′(푎) =
(푎,ℎ(푎)) ∈dom(퐷), we have by deﬁnition of dom(퐷) thatℎ(푎) ∈푅퐷푐
푎
and thus the requirement for
homomorphisms is veriﬁed for 푅푎. Now let 푅be one of the other relations of 퐴푄푐, so 푅is a relation

---

28
Karl Bringmann, Nofar Carmeli, and Stefan Mengel
of 퐴푄and 푅퐴푄푐= 푅퐴푄. Let (푎1, . . . ,푎푘) ∈푅퐴푄, thenℎ′(푎1, . . . ,푎푘) = ((푎1,ℎ(푎1)), . . . , (푎푘,ℎ(푎푘))) ∈
푅퐷. From the deﬁnition of 퐷, it follows then directly that ℎ(푎1, . . . ,푎푘) ∈푅퐷푐which shows that ℎ
is a homomorphism as claimed.
□
We conclude that it is enough to compute | hom(퐴푄, 퐷,픠)id| = | hom(퐴푄푐, 퐷푐, 픠)| to answer the
counting problem for 픠. To do this, we ﬁnd its connection to other counting tasks that we can
directly compute. Let aut(퐴푄, 픠) denote the set of automorphisms of 퐴푄that are the identity on
all 푎∈var(픠). Moreover, let hom(퐴푄, 퐷,픠)aut be the set of homomorphisms ℎ′ from 퐴푄to 퐷
such that 휋1 ◦ℎ′ ∈aut(퐴푄, 픠) and 휋2 ◦ℎ′ satisﬁes 픠. In particular, if ℎ′ ∈hom(퐴푄, 퐷, 픠)aut, then
(휋1 ◦ℎ′)(var(푄)) = var(푄).
Claim 4.
| hom(퐴푄, 퐷,픠)aut| = | hom(퐴푄, 퐷, 픠)id| · |aut(퐴푄,픠)|.
Example 42. We have seen that | hom(퐴푄, 퐷, 픠)id| = {((푥,푎), (푦,푎), (푧,푎)), ((푥,푎), (푦,푏), (푧,푎))}
in our running example. We also have that aut(퐴푄,픠) = {(푥,푦,푧), (푥,푧,푦)}, and hom(퐴푄, 퐷,픠)aut is
{((푥,푎), (푦,푎), (푧,푎)), ((푥,푎), (푦,푏), (푧,푎)), ((푥,푎), (푧,푎), (푦, 푎)), ((푥,푎), (푧,푎), (푦,푏))}. We get that
| hom(퐴푄, 퐷,픠)aut| = 4 = 2 · 2 = | hom(퐴푄, 퐷,픠)id| · |aut(퐴푄,픠)|.
Proof of Claim 4. We ﬁrst show hom(퐴푄, 퐷,픠)aut = {ℎ◦푔| ℎ∈hom(퐴푄, 퐷,픠)id,푔∈aut(퐴푄,픠)}.
For the containment “⊇”, let ℎ∈hom(퐴푄, 퐷,픠)id and 푔∈aut(퐴푄, 픠). Note ﬁrst that ℎ◦푔is a
homomorphism from 퐴푄to 퐷. Next, as 휋1 ◦ℎis the identity, we have that 휋1 ◦ℎ◦푔∈aut(퐴푄, 픠).
By deﬁnition of aut(퐴푄,픠), we have 푔|var(픠) = id, so (휋2 ◦ℎ◦푔)|var(픠) = (휋2 ◦ℎ)|var(픠), and 휋2 ◦
ℎ◦푔satisﬁes 픠because ℎ∈hom(퐴푄, 퐷,픠)id. Thus, ℎ◦푔∈hom(퐴푄, 퐷,픠)aut which proves the
containment.
For the direction “⊆”, letℎ′ ∈hom(퐴푄, 퐷,픠)aut. We deﬁne 푔:= 휋1◦ℎ′ ∈aut(퐴푄,픠), so푔−1 is well-
deﬁned, and 푔−1 ∈aut(퐴푄,픠) since the inverse of an automorphism is an automorphism as well.
Now deﬁneℎ:= ℎ′◦푔−1 = ℎ′◦(휋1◦ℎ′)−1. We claim thatℎ∈hom(퐴푄, 퐷,픠)id. First, as a composition
of homomorphisms,ℎis a homomorphism as well. Moreover, 휋1◦ℎ= (휋1◦ℎ′)◦(휋1◦ℎ′)−1 = id. Also,
we have that 푔−1 is the identity on var(픠), so (휋2 ◦ℎ)|var(픠) = (휋2 ◦ℎ′ ◦푔−1)|var(픠) = (휋2 ◦ℎ′)|var(픠).
Since 휋2 ◦ℎ′ satisﬁes 픠, we have that 휋2 ◦ℎdoes too. It follows that ℎ∈hom(퐴푄, 퐷,픠)id, as claimed,
which proves the containment in the second direction.
To prove the claim, we show that for ℎ1,ℎ2 ∈hom(퐴푄, 퐷,픠)id and 푔1,푔2 ∈aut(퐴푄,픠), whenever
ℎ1 ≠ℎ2 or 푔1 ≠푔2, then ℎ1 ◦푔1 ≠ℎ2 ◦푔2. Assume ﬁrst that 푔1 ≠푔2. Since 휋1 ◦ℎ1 = 휋1 ◦ℎ2 = id,
we have 휋1 ◦ℎ1 ◦푔1 = 푔1 ≠푔2 = 휋1 ◦ℎ2 ◦푔2. So ℎ1 ◦푔1 and ℎ2 ◦푔2 diﬀer in the ﬁrst coordinate.
Now assume that 푔1 = 푔2 = 푔but ℎ1 ≠ℎ2. Let 푎∈var(푄) be such that ℎ1(푎) ≠ℎ2(푎). Since 푔is
a bijection, the inverse 푔−1 exists and is a bijection as well. Set 푎′ := 푔−1(푎). Then (ℎ1 ◦푔)(푎′) =
(ℎ1 ◦푔◦푔−1)(푎) = ℎ1(푎) ≠ℎ2(푎) = (ℎ2 ◦푔◦푔−1)(푎) = (ℎ2 ◦푔)(푎′). So again ℎ1 ◦푔1 ≠ℎ2 ◦푔2.
□
Next we show that we can compute | hom(퐴푄, 퐷,픠)aut| eﬃciently.
Claim 5. Given an algorithm A for counting under preﬁx constraints for 푄, there is an algorithm
computing | hom(퐴푄, 퐷,픠)aut| with the following properties:
• The preprocessing phase is given 퐷(but not 픠) and runs in time 푂(|퐷|), making 푂(1) calls to
the preprocessing of A on databases of size 푂(|퐷|).
• The query phase is given a preﬁx constraint 픠and computes | hom(퐴푄, 퐷, 픠)aut| in time 푂(1),
making 푂(1) calls to the query of A.
Proof. Given 픠, let 픠∗be the preﬁx constraint on the same preﬁx 푥1, . . . 푥푟as 픠, deﬁned by
픠∗(푥푖) := [(푥푖,푦1
푖), (푥푖,푦2
푖)] where 픠(푥푖) = [푦1
푖,푦2
푖]. Note that, since we assume dom(퐷) to be lexico-
graphicallyordered, 픠∗is indeed a preﬁx constraint for the database 퐷. By deﬁnition, hom(퐴푄, 퐷,픠∗)

---

Tight Fine-Grained Bounds for Direct Access on Join Qeries
29
is the set of homomorphismsℎfrom퐴푄to 퐷that satisfy 픠∗, or, equivalently, such that 휋2◦ℎsatisﬁes
픠and 휋1 ◦ℎis the identity over var(픠).
Note that hom(퐴푄, 퐷,픠)aut ⊆hom(퐴푄, 퐷,픠∗) but there are homomorphismsℎ∈hom(퐴푄, 퐷, 픠∗)
that are not in hom(퐴푄, 퐷, 픠)aut because 휋1 ◦ℎis not a bijection (see Example 43). This motivates
for every subset var(픠) ⊆푇⊆var(푄) the deﬁnition
N푇:= {ℎ∈hom(퐴푄, 퐷,픠∗) | (휋1 ◦ℎ)(var(푄)) ⊆푇}.
The set hom(퐴푄, 퐷,픠)aut consists exactly of homomorphismsℎ∈hom(퐴푄, 퐷,픠∗) for which (휋1◦ℎ)
is a bijection, which by Observation 39 is equivalent to (휋1 ◦ℎ)(var(푄)) = var(푄).
Example 43. We continue our running example. Given 픠as before, we have that 픠∗is the preﬁx
constraint that assigns (푥,푎) to 푥. An example for a homomorphism in hom(퐴푄, 퐷,픠∗) but not in
hom(퐴푄, 퐷,픠)aut is ((푥,푎), (푦,푏), (푦,푐)). This homomorphism is also in N{푥,푦} and 푁{푥,푦,푧}.
Using the fact that for all ℎ∈hom(퐴푄, 퐷,픠∗), the restriction of 휋1 ◦ℎto var(픠) is by deﬁnition
the identity, we ﬁrst compute the value | hom(퐴푄, 퐷,픠)aut| based on the |N푇| values. To this end,
we use the abbreviations 푉:= var(푄) and 퐶:= var(픠), the obvious equality | hom(퐴푄, 퐷,픠)aut| =
N푉\ (Ð
푥∈푉\퐶N푉\{푥}) and the inclusion-exclusion principle. We obtain

Ø
푥∈푉\퐶
N푉\{푥}

=
|푉\퐶|
Õ
푖=1
Õ
푋⊆푉\퐶: |푋|=푖
(−1)푖−1|N푉\푋| =
Õ
퐶⊆푇⊊푉
(−1)|푉\푇|−1|N푇|
and
| hom(퐴푄, 퐷,픠)aut| = |N푉| −

Ø
푥∈푉\퐶
N푉\{푥}

=
Õ
퐶⊆푇⊆푉
(−1)|푉\푇||N푇|.
Setting 푣:= |var(푄)|, this gives
| hom(퐴푄, 퐷,픠)aut| =
Õ
var(픠)⊆푇⊆var(푄)
(−1)푣−|푇||N푇|.
(5)
(For the sake of simplicity in the rest of the proof, we will continue using the notation 푣:= |var(푄)|
and 푟:= |var(픠)|. Of course we have 0 ≤푟≤푣.)
The number of summands is bounded by an interger depending only on 푣:= |var(푄)|, so if we
can eﬃciently compute each |N푇| for 푇⊆var(푄) with var(픠) ⊆푇, we are done.
Now, for every 푖∈[0,푣], deﬁne N푇,푖to be the set of homomorphisms ℎ∈hom(퐴푄, 퐷, 픠∗) such
that for exactly 푖elements 푎∈var(푄) we have that (휋1 ◦ℎ)(푎) ∈푇. With this notation, N푇= N푇,푣.
Then, for every 푗∈[푣+ 1], construct a new database 퐷푇,푗over the same relation symbols as 퐷. To
this end, for every 푎∈푇, introduce 푗clones 푎(1), . . . ,푎(푗). Then the domain of 퐷푇,푗is
dom(퐷푇,푗) := {(푎(푘),푏) | (푎,푏) ∈dom(퐷),푎∈푇,푘∈[푗]} ∪{(푎,푏) ∈dom(퐷) | 푎∉푇}
where we assume the lexicographic order between the new elements as follows:
(푎(푖),푏) ≺(푐(ℓ),푑) ⇔푖< ℓ∨(푖= ℓ∧푎≺퐿푐) ∨(푖= ℓ∧푎= 푐∧푏≺푑).
We add the elements in {(푎,푏) ∈dom(퐷) | 푎∉푇} in an arbitrary way to this order.
We then deﬁne a mapping 퐵: dom(퐷) →P(dom(퐷푇,푗)) where P(dom(퐷푇,푗)) is the power set
of dom(퐷푇,푗) as follows:
퐵(푎,푏) :=
(
{(푎(푘),푏) | 푘∈[푗]},
if 푎∈푇
{(푎,푏)},
otherwise.

---

30
Karl Bringmann, Nofar Carmeli, and Stefan Mengel
Then, for every relation symbol 푅of 푄of arity 푠, deﬁne
푅퐷푇,푗:=
Ø
((푎1,푏1),...,(푎푠,푏푠))∈푅퐷
퐵(푎1,푏1) × . . . × 퐵(푎푠,푏푠).
Deﬁne a new preﬁx constraint 픠∗∗on the variables var(픠) by setting for every 푎∈var(픠) the
intervals 픠∗∗(푎) = [(푎(1),푦1), (푎(1),푦2)] where 픠(푎) = [푦1,푦2].
Note that for every ℎ∈N푇,푖, since (휋1 ◦ℎ)(var(픠)) = var(픠) ⊆푇, there are exactly 푖−푟
elements 푎∈var(푄) \ var(픠) with (휋1 ◦ℎ)(푎) ∈푇. For every 푖∈[0, 푣] and ℎ∈N푇,푖, each variable
푎∈var(푄)\var(픠) with (휋1◦ℎ)(푎) ∈푇can be mapped to one of 푗copies to get a homomorphism in
hom(퐴푄, 퐷푇,푗,픠∗∗). Thus, every ℎ∈N푇,푖corresponds to exactly 푗푖−푟homomorphisms ℎ푘1,...,푘푖−푟in
hom(퐴푄, 퐷푇,푗,픠∗∗) for (푘1, . . . ,푘푖−푟) ∈[푗]푖−푟, deﬁned by the following expression where ℓ∈[푖−푟]:
ℎ푘1,...,푘푖−푟(푥) :=


(푥(1),푏),
if 푥∈var(픠) and ℎ(푥) = (푥,푏),
(푎(푘ℓ),푏)
if 푥is the ℓ-th element of (휋1 ◦ℎ)−1(푇) \ var(픠) and ℎ(푥) = (푎,푏),
ℎ(푥),
otherwise, i.e., if 푥∉(휋1 ◦ℎ)−1(푇).
The following two points are immediate:
(1) for all homomorphisms ℎ,ℎ′ ∈N푇,푖and tuples (푘1, . . . ,푘푖−푟) and (푘′
1, . . . ,푘′
푖−푟) in [푗]푖−푟
such that (ℎ,푘1, . . . ,푘푖−푟) ≠(ℎ′,푘′
1, . . . ,푘′
푖−푟), the resulting homomorphisms ℎ푘1,...,푘푖−푟and
ℎ′
푘′
1,...,푘′
푖−푟in hom(퐴푄, 퐷푇,푗, 픠∗∗) are not equal;
(2) every homomorphism 퐻∈hom(퐴푄, 퐷푇,푗, 픠∗∗) is a homomorphism ℎ푘1,...,푘푖−푟for exactly
one 푖∈[푟,푣], one ℎ∈N푇,푖and one tuple (푘1, . . . ,푘푖−푟) ∈[푗]푖−푟. (To show this, we have
퐻= ℎ푘1,...,푘푖−푟, with each 푘ℓ, ℓ∈[푖−푟] determined as follows: if the ℓ-th element of (휋1 ◦
ℎ)−1(푇) \ var(픠) is 푥with 퐻(푥) = (푎(푘),푏), then 푘ℓ:= 푘.)
Together, the points (1) and (2) imply, for every 푗∈[푣−푟+ 1], the equality:
푣
Õ
푖=푟
푗푖−푟|N푇,푖| = | hom(퐴푄, 퐷푇,푗,픠∗∗)|.
(6)
This is a linear system of 푣−푟+ 1 equations with 푣−푟+ 1 unknowns |N푇,푖|; the coeﬃcients
푗푖−푟, for 푖∈[푟,푣] and 푗∈[푣−푟+ 1], form a square Vandermonde matrix which is therefore
invertible. For each ﬁxed 푇, this allows to compute the values |N푇,푖| (and in particular the value
|N푇,푣| = |N푇| which interests us) in time 푂((푣−푟+ 1)3), which is constant time, if the 푣−푟+ 1
values | hom(퐴푄, 퐷푇,푗, 픠∗∗)| are known.
Since the values | hom(퐴푄, 퐷푇,푗, 픠∗∗)| are just counting queries under a preﬁx constraint, we can
compute them using the algorithm A. We note that, by the deﬁnition of the relations 푅퐷푇,푗, each
database 퐷푇,푗with 푗∈[푣+1] has size at most 푗훼|퐷| where 훼is the maximum arity of the relations,
so that |퐷푇,푗| = 푂(|퐷|) and can be easily constructed from 퐷in linear time.
To summarize, we can compute the required value | hom(퐴푄, 퐷,픠)aut| by the following two-
phase algorithm:
• Preprocessing (independent of the preﬁx constraint): Compute the databases 퐷푇,푗for all
var(픠) ⊆푇⊆var(푄) and 푗∈[푣+ 1], and apply the preprocessing phase of A to each 퐷푇,푗;
• Query phase: Read the preﬁx constraint 픠and turn it into 픠∗∗; compute | hom(퐴푄, 퐷푇,푗, 픠∗∗)|
by applying the query phase of A to 퐷푇,푗and 픠∗∗for all 푗∈[푣−푟+ 1] and all var(픠) ⊆
푇⊆var(푄); for each such 푇, compute (from the | hom(퐴푄), 퐷푇,푗,픠∗∗)| values) the (unique)
solution |N푇,푣| = |N푇| of the linear system of equations (6); ﬁnally, from the |N푇| values,
compute | hom(퐴푄, 퐷, 픠)aut| by equation (5).

---

Tight Fine-Grained Bounds for Direct Access on Join Qeries
31
Let us analyze the complexity of the above algorithm: the number of calls to the preprocessing
phase and the query phase of A made by the above algorithm is the number of pairs (푇, 푗) involved,
which depends only on 푄. Therefore the preprocessing time of the algorithm is 푂(|퐷|) and its
query time is constant (both when ignoring the runtime of the calls to A).
□
We can now complete the proof of Lemma 36. From Claims 3 and 4 we get that what we need
to compute is
| hom(퐴푄푐, 퐷푐, 픠)| = | hom(퐴푄, 퐷,픠)id| = | hom(퐴푄, 퐷,픠)aut|
|aut(퐴푄, 픠)|
.
From Claim 5, | hom(퐴푄, 퐷, 픠)aut| can be computed eﬃciently. Since we work in data complexity,
we can easily compute aut(퐴푄,픠): the value only depends on 퐴푄and the length 푟of the preﬁx
that 픠is on, so we can simply compute it for every possible value of 푟. This completes the proof of
Lemma 36.
□
6.4
Assembling the Proof
With all the components at hand, we can now prove Theorem 33.
Proof of Theorem 33. By Proposition 35, a lexicographic direct access algorithm for 푄and 퐿
implies an algorithm for counting under preﬁx constraints for 푄and 퐿. By Lemma 36, this implies
an algorithm for counting under preﬁx constraints for 푄푐and 퐿. By Proposition 35, this implies
a lexicographic direct access algorithm for 푄푐and 퐿. By Lemma 34, this ﬁnally implies a lexico-
graphic direct access algorithm for 푄sf and 퐿. Each step increases the preprocessing time only by
constant factors, and the access/counting is increased by a logarithmic factor whenever we use
Proposition 35. This proves the non-trivial direction of the theorem.
□
7
TIGHT BOUNDS FOR DIRECT ACCESS
In this section, we formulate and prove the main result of this paper on direct access, showing that
the incompatibility number determines the required preprocessing time, even for queries with self-
joins.
Theorem 44. Let 푄be a join query, let 퐿be an ordering of its variables, and let 휄be the incompat-
ibility number of 푄and 퐿.
• There is an algorithm that allows lexicographic direct access with respect to the order induced
by 퐿with preprocessing time 푂(|퐷|휄) and logarithmic access time.
• Assuming the Zero-Clique Conjecture, there is no constant 휀> 0 such that for all 훿> 0 there
is an algorithm allowing lexicographic direct access with respect to the order induced by 퐿
with preprocessing time 푂(|퐷|휄−휀) and access time 푂(|퐷|훿).
Proof. The ﬁrst part was shown in Theorem 10. Let us now prove the second part ﬁrst for 휄> 1.
If there is an 휀> 0 such that for all 훿> 0 we have direct access for 푄and 퐿with preprocessing
time 푂(|퐷|휄−휀) and access time 푂(|퐷|훿), then by Theorem 33, there is a similar algorithm for a
self-join free version of 푄. By Lemma 17, there is a 푘≥2 and 휀′ > 0 such that for all 훿′ > 0 the star
query 푄★
푘with respect to a bad order admits direct access with preprocessing time 푂(|퐷|푘−휀′) and
access time 푂(|퐷|훿′). Combining Proposition 19 and Lemma 22, we obtain that 푘-Set-Disjointness
has an algorithm with preprocessing time 푂(∥퐼∥푘−휀′) and query time e
푂(∥I∥훿′) = 푂(∥I∥훿′′) for
훿′′ := 2훿′. The quantiﬁers on 휀′ and 훿′′ match Theorem 23, which implies that the Zero-(푘+ 1)-
Clique Conjecture is false, in particular the Zero-Clique Conjecture is false.
Since the incompatibility number is always at least 1, it remains to prove the second part for
휄= 1. Here we start from the well-known fact that searching in an unordered array requires

---

32
Karl Bringmann, Nofar Carmeli, and Stefan Mengel
linear time. More precisely, given an array 퐴[1..푛] with {0, 1}-entries, deciding whether 퐴contains
a 0 requires time Ω(푛), and this holds for deterministic algorithms as well as for randomized
algorithms (with success probability at least 2/3). We reduce this problem to direct access for 푄,
in order to show a linear lower bound on the preprocessing time. To this end, given an array
퐴[1..푛] with {0, 1}-entries we construct a database 퐷with dom(퐷) = [2푛]. Set 퐵:= {푖+ 퐴[푖] ·
푛| 푖∈[푛]}. For any relation symbol 푅of 푄, we set 푅퐷:= {(푏, . . . ,푏) | 푏∈퐵}. Note that
every (푏, . . . ,푏) with 푏∈퐵is a solution to 푄(퐷), but there can also be other solutions. In any
case, the lexicographically smallest solution to 푄(퐷) is the tuple (푏∗, . . . ,푏∗) with 푏∗:= min(퐵).
Observe that 푏∗≤푛if and only if 퐴[1..푛] has a 0-entry, so we can read oﬀwhether array 퐴has
a 0-entry from 푏∗. Hence, by preprocessing 퐷and then using one direct access to determine the
lexicographically smallest solution, we can decide whether the array 퐴[1..푛] contains a 0-entry.
Note that this reduction is implicit, meaning we do not need to explicitly compute the database
퐷. Instead, when the preprocessing or direct access algorithm reads an entry of a relation 푅퐷, we
can compute this entry on the ﬂy in constant time by reading an entry 퐴[푖]. Therefore, a direct
access algorithm for 푄with preprocessing time 표(|퐷|) and access time 표(|퐷|) would imply that
we can search in an unordered array in time 표(푛). Since the latter is impossible, there is no direct
access algorithm for 푄with preprocessing time 표(|퐷|) and access time 표(|퐷|). In particular, for
any 휀∈(0, 1) and 훿:= 1 −휀there is no direct access algorithm with preprocessing time 푂(|퐷|1−휀)
and access time 푂(|퐷|훿). This lower bound is unconditional, proving the second part for 휄= 1.
□
Note that for every 훿, 훿′ > 0 we have 푂((log |퐷|)훿) ≤푂(|퐷|훿′). Therefore, if for some 휀,훿> 0
there was an algorithm with preprocessing time 푂(|퐷|휄−휀) and access time 푂((log |퐷|)훿), then for
every 훿′ > 0 there would also be an algorithm with preprocessing time 푂(|퐷|휄−휀) and access time
푂(|퐷|훿′). Thus, Theorem 44 implies the lower bound for polylogarithmic query time stated in the
introduction.
8
RELAXED ORDERS AND PROJECTIONS
So far, we have considered the case where the underlying order of the results is lexicographic and
speciﬁed by the user as part of the problem deﬁnition. We now consider the relaxation of this
requirement, when the order is either: (1) completely ﬂexible; (2) has to be lexicographic, but the
ordering of the variables is ﬂexible; or (3) the answers must be ordered lexicographically by some
of the variables, and breaking ties originating from the assignments to the other variables can be
done in an arbitrary order. We will see that such relaxations allow to reduce the preprocessing
time. We also brieﬂy discuss how to support queries with projections.
8.1
Unconstrained Lexicographic Orders
From Theorem 44 we can also get a lower bound for direct access for unconstrained lexicographic
order based on fractional hypertree width.
Proposition 45. The fractional hypertree width of a hypergraph 퐻is the minimum incompatibil-
ity number of 퐻minimized over all orders 퐿.
Proof. First, we claim that for any hypertree decomposition D, there exists an order 퐿of the
variables, such that D and 퐿have no disruptive trio. Indeed, since D is acyclic, it has an elimination
order, and the reverse of an elimination order is known to not have disruptive trios. From this claim
we conclude that by considering all permutations 퐿and all hypertree decompositions that do not
have a disruptive trio with respect to 퐿, we get all hypertree decompositions of 퐻.
Denote the set of all permutations of the vertices by 푃and the set of all hypertree decompositions
of 퐻by 퐷. Given D ∈퐷and 퐿∈푃, denote the fractional width of 퐷by푤D, the set of all hypertree

---

Tight Fine-Grained Bounds for Direct Access on Join Qeries
33
decompositions of 퐻that have no diruptive trio with respect to 퐿by 퐷퐿, and the incompatibility
number of D and 퐿by 휄(D, 퐿). Denote also the fractional hypertree width of 퐻by 푤. Then,
푤= min
D∈퐷푤D = min
퐿∈푃min
D∈퐷퐿푤D =
min
퐿∈푃,D∈퐷휄(D, 퐿)
Here, the ﬁrst equality is the deﬁnition of fractional hypertree width, the second equality follows
from the claim we just proved, and the third equality follows from Proposition 14.
□
From Theorem 44 and Proposition 45, we get the following corollary that essentially says that if
we allow any lexicographic order for direct access, then the fractional hypertree width determines
the exponent of the preprocessing time.
Corollary 46. Let 푄be a join query of fractional hypertree width 푤.
• There is an ordering 퐿of the variables of 푄such that there is an algorithm that allows lexico-
graphic direct access with respect to the order induced by 퐿with preprocessing time 푂(|퐷|푤)
and logarithmic access time.
• Assuming the Zero-Clique Conjecture, there are no order 퐿and constant 휀> 0 such that for
all 훿> 0 there is an algorithm allowing lexicographic direct access with respect to the order
induced by 퐿with preprocessing time 푂(|퐷|푤−휀) and access time 푂(|퐷|훿).
8.2
Unconstrained Orders
As we have seen, the complexity of direct access for join queries depends strongly on the order
in which we want the query results to be represented. Moreover, we know from Corollary 46
that if we insist on lexicographic orders, then the preprocessing time necessarily degrades with
the fractional hypertree width. The next natural question is whether we can get a more eﬃcient
algorithm in case we have no constraints on the order at all.
Let us discuss a model in which we do not require any particular order on the answers in direct
access. That is, we only require that there is a bijection 푏: [푠] →푄(퐷) where 푠:= |푄(퐷)|
such that, given a query integer 푖∈[푠] we can eﬃciently compute the answer 푏(푖). We call this
model orderless direct access. It is again convenient to extend 푏to the domain N, deﬁning 푏(푖) to be
some ﬁxed error value whenever 푖∉[푠]. We again measure the preprocessing time, i.e., the time
to prepare suitable data structures given a database 퐷, and the query time, which is the time to
compute the answer 푏(푖) given 푖∈N using these data structures. We will see that there are queries
in which orderless direct access can be performed in a more eﬃcient manner than direct access
with a lexicographic order, proving the following proposition.
Proposition 47. Assuming the Zero-Clique Conjecture, there exists a query for which orderless
direct access can be done with a lower complexity compared to direct access in any lexicographic
order.
To prove this, we consider the 4-cycle query
푄◦(푥1,푥2,푥3,푥4) :−푅1(푥1, 푥2),푅2(푥2, 푥3),푅3(푥3,푥4),푅4(푥4,푥1).
It is easy to verify that the query 푄◦has fractional hypertree width 2. It follows from Corollary 46
that for any direct access algorithm with a lexicographic order and polylogarithmic access time,
the preprocessing time must be essentially quadratic. We next show that this preprocessing time
can be improved if we drop the requirement of having a lexicographic order.
Lemma 48. There is an algorithm for orderless direct access for 푄◦with logarithmic access time
and preprocessing time 푂(|퐷|3/2).

---

34
Karl Bringmann, Nofar Carmeli, and Stefan Mengel
Proof. We use a decomposition technique based on degree information as pioneered in [5]. To
this end, we split every relation 푅퐷
푖into a heavy part 푅ℎ
푖and a light part 푅ℓ
푖as follows:
푅ℓ
푖:= {(푎,푏) ∈푅퐷
푖| deg푅푖(푎) ≤|푅퐷
푖|1/2},
푅ℎ
푖:= {(푎,푏) ∈푅퐷
푖| deg푅푖(푎) > |푅퐷
푖|1/2},
where deg푅푖(푎) denotes the degree of 푎in 푅퐷
푖, i.e.,
deg푅푖(푎) := |{푏| (푎,푏) ∈푅퐷
푖}|.
Denote by 퐷∗the database we get from 퐷by adding all these relations. Note that |퐷∗| = Θ(|퐷|).
Clearly, 퐷∗can be computed in time푂(|퐷|) by sorting the tuples in 퐷in linear time and computing
the degrees.
We have that 푅퐷
푖= 푅ℓ
푖⊎푅ℎ
푖where ⊎denotes disjoint union. Thus, we can rewrite the query 푄◦
as follows, where ⊲⊳denotes a join:
푄◦≡

푅ℓ
1(푥1,푥2) ⊎푅ℎ
1 (푥1, 푥2)

⊲⊳

푅ℓ
2(푥2,푥3) ⊎푅ℎ
2 (푥2,푥3)

⊲⊳

푅ℓ
3(푥3,푥4) ⊎푅ℎ
3 (푥3,푥4)

⊲⊳

푅ℓ
4(푥4, 푥1) ⊎푅ℎ
4 (푥4,푥1)

≡
Ú
(표1,표2,표3,표4)∈{ℓ,ℎ}4
푅표1
1 (푥1,푥2) ⊲⊳푅표2
2 (푥2,푥3) ⊲⊳푅표3
3 (푥3, 푥4) ⊲⊳푅표4
4 (푥4, 푥1)
≡
Ú
(표1,표2,표3,표4)∈{ℓ,ℎ}4
푄(표1,표2,표3,표4) (푥1, 푥2,푥3, 푥4),
where for every tuple (표1,표2,표3,표4) ∈{ℓ,ℎ}4 we deﬁne
푄(표1,표2,표3,표4) (푥1,푥2, 푥3,푥4) := 푅표1
1 (푥1, 푥2) ⊲⊳푅표2
2 (푥2, 푥3) ⊲⊳푅표3
3 (푥3,푥4) ⊲⊳푅표4
4 (푥4,푥1).
We can evaluate each individual 푄(표1,표2,표3,표4) eﬃciently.
Claim 6. For all (표1,표2,표3,표4) ∈{ℓ,ℎ}4, there is an algorithm for direct access on 푄(표1,표2,표3,표4)
with logarithmic access time and preprocessing time 푂(|퐷|3/2).
Proof. The idea is to rewrite 푄(표1,표2,표3,표4) into an acyclic query on a database of size 푂(|퐷|3/2).
We consider three cases.
Case 1 – there exists 푖∈{1, 2} such that 표푖= 표푖+2 = ℓ: We assume that w.l.o.g. 푖= 1 since
the other case is completely analogous. We rewrite 푄(ℓ,표2,ℓ,표4) into an acyclic query as follows:
let 푆1(푥4,푥1, 푥2) :−푅ℓ
1(푥1,푥2),푅표4
4 (푥4,푥1) and 푆2(푥2, 푥3,푥4) :−푅표2
2 (푥2,푥3),푅ℓ
3(푥3,푥4) and deﬁne a new
database 퐷′ with two relations 푆퐷′
1
:= 푆1(퐷∗) and 푆퐷′
2
:= 푆2(퐷∗). Finally, we deﬁne the query
푄′(푥1,푥2, 푥3,푥4) :−푆1(푥4, 푥1,푥2),푆2(푥2, 푥3,푥4). Then, by deﬁnition, 푄(ℓ,표2,ℓ,표4) (퐷∗) = 푄′(퐷′), so it
suﬃces to have an algorithm with direct access for 푄′ such as those from [13, 19]. It only remains
to show that 퐷′ can be computed in time 푂(|퐷3/2|). We only show this for the computation of 푆퐷′
1 ,
as the case for 푆퐷′
2 is completely analogous. In the join 푅ℓ
1 ⊲⊳푅표4
4 , every tuple (푎,푏) ∈(푅표4
4 )퐷∗can by
construction of (푅ℓ
1)퐷∗only be extended in at most |푅퐷
1 |1/2 ways, so overall |푆퐷′
1 | ≤|푅퐷∗
4 |·|푅퐷∗
1 |1/2 ≤
|퐷|3/2 and the relation can again be computed eﬃciently.
Case 2 – there exists 푖∈{1, 2} such that 표푖= 표푖+2 = ℎ: We only consider the case 푖= 1;
the other case is analogous. As before, we show how 푄(ℎ,표2,ℎ,표4) can be rewritten into an acyclic
query, but we regroup the atoms diﬀerently. We deﬁne 푆′
1(푥1, 푥2,푥3) :−푅ℎ
1 (푥1,푥2),푅표2
2 (푥2,푥3) and
푆′
2(푥3,푥4, 푥1) :−푅ℎ
3 (푥3, 푥4),푅표4
4 (푥4, 푥1). Then we deﬁne 푄′(푥1,푥2, 푥3,푥4) :−푆′
1(푥1, 푥2,푥3),푆′
2(푥3, 푥4,푥1)
and construct a database 퐷′ by setting 푆′퐷′
1
:= 푆1(퐷∗) and 푆′퐷′
2
:= 푆2(퐷∗). Reasoning similarly to
before, it only remains to show that 퐷′ can be constructed in time 푂(|퐷|3/2). To this end, remark

---

Tight Fine-Grained Bounds for Direct Access on Join Qeries
35
that every element in 휋푥1 (푅ℎ
1)퐷∗appears in at least |푅퐷
1 |1/2 tuples of 푅퐷
1 , so |휋푥1 (푅ℎ
1)퐷∗| ≤|푅퐷
1 |1/2.
We get that |푆′퐷′
1
| ≤|휋푥1 (푅ℎ
1)퐷∗| · |푅퐷∗
2 | ≤|퐷|3/2 and the relation can easily be computed in the
claimed time.
Case 3 – there is no 푖∈{1, 2} such that 표푖= 표푖+2: In that case, (표1,표2,표3,표4) must be a cyclic
shift of (ℓ, ℓ,ℎ,ℎ), so we only consider that speciﬁc index tuple, as all other cases are completely
analogous. We decompose the same way as in Case 2. We only have to show that the relations
푆′퐷′
1
and 푆′퐷′
2
can be computed in time 푂(|퐷|3/2). For 푆′
2, this follows immediately as in Case 2
since 푆′
2(푥3,푥4, 푥1) :−푅ℎ
3 (푥3, 푥4),푅ℎ
4 (푥4, 푥1). For 푆′
1(푥1,푥2, 푥3) :−푅ℓ
1(푥1,푥2),푅ℓ
2(푥2,푥3), the reasoning
is analogous to Case 1.
Applying one of the direct-access algorithms from [13, 19] in all cases yields the claim for all
(표1,표2,표3,표4).
□
We now complete the proof of Lemma 48. We order {ℓ,ℎ}4 in an arbitrary way. Then we order
the answers in 푄◦(퐷) by ﬁrst ordering them with respect to which 푄(표1,표2,표3,표4) (퐷′) they appear
in and then with respect to the order of the algorithm from Claim 6. This is the order which our
algorithm for 푄◦uses, working in the following way: in the preprocessing phase, we ﬁrst compute
퐷′ and then perform the preprocessing for all 푄(표1,표2,표3,표4) on input 퐷′. We also compute the values
|푄(표1,표2,표3,표4) (퐷′)| for all queries 푄(표1,표2,표3,표4) which we can do with a simple binary search using the
respective direct access algorithms. Using these answer counts, given 푗∈N in the query phase, we
ﬁrst compute in which 푄(표1,표2,표3,표4) (퐷′) the 푗th answer lies and compute the corresponding index
푗′ for which the 푗′th answer in 푄(표1,표2,표3,표4) (퐷′) is the 푗th answer in 푄◦(퐷). Finally, we use the
direct access algorithm for 푄(표1,표2,표3,표4) to compute the desired answer.
□
We remark that the technique used in the proof of Lemma 48 has a rich history, comprised of
algorithms based on splitting using degree information. In fact, it is one of the basic techniques
for worst-case optimal join algorithms (see e.g. [34]). Notice that simply applying a worst-case
optimal algorithm during preprocessing is not possible in our setting since the output can be too
big to allow this in the desired runtime bounds. Thus the rewriting into an acyclic instance that
we do in Claim 6 is a second crucial ingredient.
For ﬁnding cycles of ﬁxed length in graphs, splitting on degree information was ﬁrst used in [5].
For conjunctive queries, the technique is also part of diﬀerent algorithms based on so-called sub-
modular width, which is a measure capturing more general classes of tractable queries than frac-
tional hypertree width for decision problems, see [28, 31]; for the special case of cycles, this is also
discussed in [35]. In this line of work, it is in particular also known that submodular width can
be used for eﬃcient enumeration algorithms [12]. Note that our splitting is slightly stronger than
that generally guaranteed by the techniques based on submodular width as it guarantees that the
subinstances that we split into are disjoint. For the algorithms in [12, 28, 31], this is generally not
the case, so they cannot directly be adapted to work for direct access as in the proof of Lemma 48.
In fact, it is an open question whether disjoint splitting is always possible for algorithms based on
submodular width, see [27], and in particular it is an open question to which extent submodular
width can be used for counting algorithms. Since direct access algorithms directly imply count-
ing algorithms by binary search, this means that the question to which extent Lemma 48 can be
generalized to additional queries is also open.
8.3
Projections and Partial Lexicographic Orders
In this section, we discuss two extensions. First, we would like to support conjunctive queries (with
projections) instead of only join queries. Second, we would like to support partial lexicographic
orders. These are speciﬁed by a permutation 퐿of a subset of the non-projected variables, and the

---

36
Karl Bringmann, Nofar Carmeli, and Stefan Mengel
answers are ordered lexicographically by this permutation as before; the order between answers
that agree on all variables in 퐿is not speciﬁed as part of the problem deﬁnition. This way, we deﬁne
a preorder on the query answers and turning it into a (complete) order is left to the discretion of
the algorithm. More formally, we say that an order ⪯of the query answers is compatible with a
partial lexicographic order if it is a reﬁnement of that preorder.
To achieve these extensions, we use the connection between our work and the notion of elimi-
nation orders. Since an order 퐿of the variables of a query 푞is the reverse of an elimination order
if and only if 푄is acyclic and 퐿contains no disruptive trio with 푄, the preprocessing we suggested
in Theorem 10 can be seen as constructing an equivalent query and corresponding database that
have the reverse of 퐿as an elimination order. For more information on the connection between
elimination orders and decompositions, see [4].
To support projections, we use a folklore construction that lets us eliminate any preﬁx of an
elimination order while constructing an equivalent corresponding database in linear time. One
way of doing that is to eliminate one variable at a time: ﬁrst, ﬁlter the one atom that contains this
variable and all its neighbors according to all other atoms that contain this variable (this is the
semijoin operator), and then remove the variable from the query and the corresponding columns
from the relations (this is the projection operation). To support partial orders, we can complete
them into a full order and use the previous algorithm. This leads us to the following deﬁnition of
the incompatibility number of conjunctive queries and partial lexicographic orders.
Deﬁnition 49. Let 푄be a conjunctive query and 퐿an ordering of a subset of the free variables
of 푄. Let L+
푄be the set of all orderings of the variables of 푄that start with 퐿and end with the
projected variables. The incompatibility number of 푄and 퐿, denoted 휄, is deﬁned as the minimum
over all incompatibility numbers of 푄and an ordering in L+
푄.
Using this deﬁnition, we get an extension of Theorem 10.
Theorem 50. Given a conjunctive query and an ordering 퐿of a subset of its free variables with
incompatibility number 휄, direct access with an order compatible with the partial lexicographic order
of 퐿can be achieved with 푂(|퐷|휄) preprocessing and logarithmic access time.
Proof. Let 퐿′ be the ordering of the query variables yielding the incompatibility number accord-
ing to Deﬁnition 49. We perform the preprocessing of the algorithm of Theorem 10 to construct
a database 퐷′ corresponding to a disruption-free decomposition for 푄with respect to 퐿′. This
takes 푂(|퐷|휄) time. We then eliminate the projected variables to be left with an equivalent join
query with no projections and no disruptive trios. This can be done in 푂(|퐷′|) since the projected
variables appear at the end of an elimination order. We can now use the existing direct-access
algorithm from Theorem 1 on the preﬁx of 퐿′ obtained by removing the projected variables. This
takes a further 푂(|퐷′|) during preprocessing followed by logarithmic access time.
□
The next natural question is whether this algorithm provides optimal time guarantees for the
task at hand. In contrast to queries without projections and complete lexicographic orders, the
answer is negative. An example for this is the 4-cycle query 푄◦from the previous section. There
we saw that if the partial lexicographic order is empty, then we can perform direct-access faster
than any completion to a full lexicographic order. If all variables of this query were projected,
it would have at most one answer, and the existence of this answer can be determined in time
푂(|퐷|3/2) since the algorithm of Lemma 48 in particular lets us decide the existence of an answer.
This runtime is again faster than any completion to a full order and so better than what we get
from Theorem 50.
We remark that, when only considering linear preprocessing and logarithmic delay, all queries
and partial orders that can be solved within this time guarantee, can be solved this way through

---

Tight Fine-Grained Bounds for Direct Access on Join Qeries
37
a completion to a full lexicographic order [18]. In contrast, as we have seen here, this is no longer
the case when considering larger preprocessing times.
9
LOWER BOUNDS FOR ENUMERATION OF CYCLIC JOINS
In this section we show another application of the Zero-Clique Conjecture. Speciﬁcally, we prove
enumeration lower bounds for cyclic (i.e. non-acyclic) joins, assuming the hardness of Zero-Clique.
These lower bounds reprove a dichotomy from [13] under a diﬀerent complexity assumption.
First, in Section 9.1 we prove a lower bound for a variation of 푘-Set-Intersection. In Section 9.2
we prove hardness of enumerating Loomis-Whitney joins, and then we use a reduction from
Loomis-Whitney joins to general cyclic joins in Section 9.3.
9.1
Hardness of Set-Intersection-Enumeration
We start by deﬁning an oﬄine variant of 푘-Set-Intersection, in which we want to enumerate all
elements of all queried intersections.
Deﬁnition 51. In the 푘-Set-Intersection-Enumeration problem, we are given an instance I con-
sisting of a universe 푈and families A1, . . . , A푘⊆2푈, where we denote the sets in family A푖by
푆푖,1, . . . , 푆푖,|A푖|. We are also given a set of queries 푄, where each query speciﬁes indices (푗1, . . . , 푗푘).
The goal is to enumerate all answers to all queries, that is, to enumerate all pairs (푞,푢) such that
푞= (푗1, . . . , 푗푘) ∈푄and 푢∈푆1,푗1 ∩. . . ∩푆푘,푗푘.
As usual for enumeration problems, we assume algorithms for 푘-Set-Intersection-Enumeration
work in two phases: in a ﬁrst phase, we preprocess the input into an index data structure. In
a second phase, we enumerate the answers one after the other, measuring the eﬃciency of the
algorithm in the delay, i.e., the time between two consecutive answers.
We prove the following analogue of Theorem 27.
Lemma 52. Assuming the Zero-(푘+ 1)-Clique Conjecture, for every constant 휀> 0 there exists a
constant 훿> 0 such that no randomized algorithm solves 푘-Set-Intersection-Enumeration on universe
size |푈| = 푛with at most 푛sets in preprocessing time 푂(푛푘+1−휀) and delay 푂(푛훿).
We prove Lemma 52 by contradiction in the rest of this subsection. So assume that 푘-Set-
Intersection-Enumeration on universe size |푈| = 푛can be solved in preprocessing time 푂(푛푘+1−휀)
and delay 푂(푛훿) for some 휀> 0 and 훿:= 휀
4푘.
We closely follow the proof of Theorem 27, and we only describe the diﬀerences. We need an
additional source of randomness in the new edge weights 푤′, therefore for every 푣∈푉1 we pick
a random 푦푣∈F푝, we subtract 푦푣from every edge weight 푤′(푣,푢) for each 푢∈푉푘+1, and we
add 푦푣to every edge weight 푤′(푣,푢) for each 푢∈푉2. This does not change the weight of a clique
(푣1, . . . , 푣푘+1) ∈푉1 × . . . × 푉푘+1. In more detail, we now choose uniformly and independently at
random from F푝:
• one value 푥,
• for all 푣∈푉푘+1 and all 푗∈[푘−1] a value 푦푗
푣, and
• for each 푣∈푉1 a value 푦푣.

---

38
Karl Bringmann, Nofar Carmeli, and Stefan Mengel
We then deﬁne the new weight function 푤′ by setting for any 푖, 푗∈[푘+ 1] and any 푣∈푉푖and
푢∈푉푗:
푤′(푣,푢) = 푥· 푤(푣,푢) +


푦1
푢−푦푣,
if 푖= 1, 푗= 푘+ 1
푦푖
푢−푦푖−1
푢
,
if 2 ≤푖< 푘, 푗= 푘+ 1
−푦푘−1
푢
,
if 푖= 푘, 푗= 푘+ 1
푦푣,
if 푖= 1, 푗= 2
0,
otherwise
(7)
With this minor modiﬁcation of 푤′, we follow the rest of the construction verbatim, in particular
we pick the same parameter 휌:=
휀
2푘, and for every weight interval tuple (퐼0, . . . , 퐼푘) ∈푆we
construct the instance of 푘-Set-Intersection-Enumeration given by
A푖:= {푆푖,푣| 푣∈푉푖} where 푆푖,푣:= {푢∈푉푘+1 | 푤′(푣,푢) ∈퐼푖}
for 푖∈[푘], and the set of queries
푄:= {(푣1, . . . ,푣푘) ∈푉1 × . . . × 푉푘| 푤′(푣1, . . . , 푣푘) ∈퐼0}.
Note that we have for every 푖∈[푘] that |A푖| = |푉푖|, so Í
푖|A푖| ≤푛. We then run the assumed
푘-Set-Intersection-Enumeration algorithm on I = (A1, . . . , A푘) and 푄. If this enumeration at
some point returns an index corresponding to a zero-clique, then we return this zero-clique. If the
enumeration ends without producing a zero-clique, then we return ’no’.
By the same arguments as in the proof of Theorem 27, since every zero-clique has a weight
interval tuple in 푆, every zero-clique appears as an answer to some query 푞∈푄. Thus, by enumer-
ating all answers we enumerate all zero-cliques. In particular, if there exists a zero-clique, then the
algorithm will ﬁnd one. Since we ﬁlter the results for zero-cliques, it also holds that if there is no
zero-clique then the algorithm will return ’no’. This proves correctness.
It remains to analyze the running time. In total over all |푆| = 푂(푛푘휌) instances, we need pre-
processing time 푂(푛푘+1−휀+푘휌) = 푂(푛푘+1−휀/2) for our choice of 휌=
휀
2푘. To analyze the total delay,
consider the following claim.
Claim 7. With probability at least .99, the number of cliques 퐶= (푣1, . . . ,푣푘+1) ∈푉1 × . . . × 푉푘+1
such that 퐶is not a zero-clique and the weight interval tuple of 퐶lies in 푆is bounded by 푂(푛푘+1−휌).
Let us ﬁrst ﬁnish the correctness proof, and later prove the claim. Each clique as in the claim
is a “false positive”, that is, an answer to our queries that does not correspond to a zero-clique. It
follows that with probability at least .99, all our푘-Set-Intersection-Enumerationinstances together
enumerate푂(푛푘+1−휌) answers before seeing the ﬁrst answer that corresponds to a zero-clique. The
total query time is then bounded by푂(푛푘+1−휌+훿) = 푂(푛푘+1−휌/2) for our choice of 휌=
휀
2푘and훿= 휀
4푘.
Together with the preprocessing, this solves Zero-(푘+1)-Cliquein time푂(푛푘+1−휀/2)+푂(푛푘+1−휌/2) =
푂(푛푘+1−휌/2), which contradicts the Zero-(푘+ 1)-Clique Conjecture.
Note that the time bound here only holds with probability .99. We can make the time bound
hold deterministically, by aborting the algorithm after an appropriate time 푂(푛푘+1−휌/2). Then the
running time is deterministic, and the algorithm still ﬁnds a zero-clique with probability at least
.99. We can boost the success probability by repeating this algorithm.
It remains to prove the claim.
Proof of Claim 7. The proof is similar to the one of Claim 1. Let (푣1, . . . ,푣푘,푣) ∈푉1 ×. . . ×푉푘+1
be a tuple that is not a zero-clique. We use the shorthand notation 푤′
푖:= 푤′(푣푖, 푣푘+1) for 푖∈[푘] and

---

Tight Fine-Grained Bounds for Direct Access on Join Qeries
39
푤′
0 := 푤′(푣1, . . . ,푣푘). The values 푤0, . . . ,푤푘are deﬁned analogously for the original edge weight
function 푤. Expanding the deﬁnition of 푤′ (see (7)) we obtain
푤′
0 = 푥· 푤0 + 푦푣1,
푤′
1 = 푥· 푤1 + 푦1
푣−푦푣1,
(8)
푤′
푖= 푥· 푤푖+ 푦푖
푣−푦푖−1
푣
for each 푖∈{2, . . . ,푘−1}
푤′
푘= 푥· 푤푘−푦푘−1
푣
,
We claim that for ﬁxed 푤0, . . . ,푤푘the above equations induce a bijection sending (푤′
0, . . . ,푤′
푘)
to (푥,푦푣1,푦1
푣, . . . ,푦푘−1
푣
). Indeed, by (4) we can compute (푤′
0, . . . ,푤′
푘) given (푥,푦푣1,푦1
푣, . . . ,푦푘−1
푣
). For
the other direction, we use that (푣1, . . . ,푣푘, 푣) is no zero-clique, that is, 0 ≠푤(푣1, . . . ,푣푘, 푣) =
푤0 + . . . + 푤푘. By adding up all equations (4), since each term 푦푖
푣and 푦푣1 appears once positively
and once negatively, we obtain 푤′
0 + . . . + 푤′
푘= 푥· (푤0 + . . . + 푤푘). Hence, given (푤′
0, . . . ,푤′
푘) we
can compute 푥= (푤′
0 + . . . + 푤′
푘)/(푤0 + . . . + 푤푘). Note that here we do not divide by 0, since
푤0 + . . . + 푤푘≠0. Next we can compute 푦푣1 = 푥· 푤0 −푤′
0 by rearranging the ﬁrst equation of
(4) (recall that 푤0 is ﬁxed, we are given 푤′
0, and we just computed 푥, so each variable on the right
hand side is known). Similarly, from 푥and 푦푣1 we can compute 푦1
푣= 푥· 푤1 −푦푣1 −푤′
1, and for
any 1 < 푖< 푘we can compute 푦푖
푣= 푥· 푤푖−푦푖−1
푣
−푤′
푖. This computes (푥,푦푣1,푦1
푣, . . . ,푦푘−1
푣
) given
(푤′
0, . . . ,푤′
푘).
Since we showed that there is a bijection sending (푤′
0, . . . ,푤′
푘) to (푥,푦푣1,푦1
푣, . . . ,푦푘−1
푣
), and since
푥,푦푣1,푦1
푣, . . . ,푦푘−1
푣
are all chosen independently and uniformly random from F푝, we obtain that
(푤′
0, . . . ,푤′
푘) is uniformly random in F푘+1
푝
. Since each weight interval 퐼푖is of length 푂(푝푛−휌), we
have that 푤′
푖∈퐼푖holds with probability 푂( 푝푛−휌
푝) = 푂(푛−휌), for each 푖∈{0, 1, . . . ,푘}. In total,
(푣1, . . . , 푣푘,푣) has a speciﬁc weight interval tuple (퐼0, . . . , 퐼푘) with probability 푂(푛−(푘+1)휌). Since
there are 푂(푛푘휌) tuples in 푆, it follows that (푣1, . . . ,푣푘,푣) has a weight interval tuple in 푆with
probability 푂(푛−휌).
Since there are 푂(푛푘+1) choices for (푣1, . . . ,푣푘, 푣), it follows that the expected number of non-
zero-cliques with a weight interval tuple in 푆is 푂(푛푘+1−휌). The claim now follows from an appli-
cation of Markov’s inequality.
□
9.2
Hardness of Loomis-Whitney Joins
In this section, we prove the hardness of enumerating answers to Loomis-Whitney joins based on
the hardness results from the previous section. Loomis-Whitney joins are queries of the form
퐿푊푘(푥1, . . . ,푥푘) :−푅1( ¯푋1), . . . , 푅푘( ¯푋푘)
where for each 푖∈[푘], we have that ¯푋푖= 푥1, . . . 푥푖−1,푥푖+1 . . . , 푥푘. When 푘= 3, 퐿푊3 is simply the
(edge-colored) triangle query:
퐿푊3(푥1, 푥2,푥3) :−푅1(푥2,푥3),푅2(푥1,푥3), 푅3(푥1, 푥2)
Loomis-Whitney joins are thus generalizations of the triangle join where instead of 3 nodes in
a graph where every 2 share an edge, we are looking for 푘nodes in a hypergraph where every
푘−1 nodes share an edge. Loomis-Whitney joins are of special interest because, as we explain in
Section 9.3, they are in a well-deﬁned sense the obstructions to a query being acyclic.
There is a naive way of designing constant delay algorithms for Loomis-Whitney joins: one can
materialize the query result during preprocessing and then simply read them from memory in the
enumeration phase. This solution requires preprocessing time 푂(|퐷|1+1/(푘−1)) using the algorithm
by Ngo et al. [34] for Loomis-Whitney joins or, since 퐿푊푘has fractional cover size 1+1/(푘−1), any

---

40
Karl Bringmann, Nofar Carmeli, and Stefan Mengel
worst-case optimal join algorithm from Theorem 2 will give the same guarantees. In this section,
we show that this naive approach is likely optimal for enumeration of Loomis-Whitney joins.
Theorem 53. For every 푘≥3 and every 휀> 0 there is a 훿> 0 such that there is no enumeration
algorithm for 퐿푊푘with preprocessing time 푂(|퐷|1+
1
푘−1 −휀) and delay 푂(|퐷|훿), assuming the Zero-푘-
Clique Conjecture.
Proof. We show that a fast enumeration algorithm for 퐿푊푘yields a fast algorithm for (푘−1)-
Set-Intersection-Enumeration, which by Lemma 52 breaks the Zero-푘-Clique Conjecture.
Assume that there are 푘≥3 and 휀> 0 such that for all 훿> 0 there is an enumeration al-
gorithm for 퐿푊푘with preprocessing time 푂(|퐷|1+1/(푘−1)−휀) and delay 푂(|퐷|훿). Consider an in-
stance I of (푘−1)-Set-Intersection-Enumeration with universe size |푈| = 푛and 푂(푛) sets as
in the statement of Lemma 52. That is, we are given families A1, . . . , A푘−1 ⊆2푈, where we
write A푖= {푆푖,1, . . . ,푆푖,|A푖|} and Í
푖|A푖| ≤푛, and a set of queries 푄, where each query is of
the form (푗1, . . . , 푗푘−1) with 푗푖∈[|A푖|]. We construct a database 퐷as follows. The domain of 퐷is
푈∪[max푖∈[푘−1] |A푖|]. Note that max푖∈[푘−1] |A푖| ≤Í
푖|A푖| ≤푛, so the overall domain size of 퐷
is 푂(푛).
For each 푖∈[푘−1], let 푖+ be the unique value in [푘−1] with 푖+ 1 ≡푖+ mod (푘−1). Note that
the atom 푅푖( ¯푋푖) of 퐿푊푘contains the variables 푥푖+ and 푥푘. We deﬁne the relations:
푅′퐷
푖
:= {(푗,푣) | 푣∈푆푖+,푗}
for each 푖∈[푘−1],
푅퐷
푘:= 푄.
When interpreted on 퐷, the join query
퐿푊′
푘:−푅′
1(푥1+,푥푘), . . . , 푅′
푘−1(푥(푘−1)+,푥푘),푅푘(푥1, . . . , 푥푘−1)
computes the conjunction 푥푘∈푆1+,푥1+ ∧. . . ∧푥푘∈푆(푘−1)+,푥(푘−1)+ and 푞= (푥1, . . . , 푥푘−1) ∈푄
because the join query (on 퐷) formally means Ó
푖∈[푘−1] 푥푘∈푆푖+,푥푖+ ∧(푥1, . . . ,푥푘−1) ∈푄. Therefore,
it computes exactly the answers to 푞∈푄for the (푘−1)-Set-Intersection-Enumeration instance.
To embed 퐿푊′
푘into 퐿푊푘, we create (푘−1)-ary relations 푅퐷
푗, for 푗∈[푘−1], by simply adding
the columns for the missing attributes 푥푖,푖∈[푘−1] \ {푗, 푗+} in the relations 푅′퐷
푗. To this end, we
extend each 2-tuple in 푅′
푗by all possible combinations of assignments to [푛] to the 푘−3 attributes
in [푘−1] \ {푗, 푗+}. Clearly,
퐿푊′
푘(퐷) = 퐿푊푘(퐷),
so running the assumed enumeration algorithm for 퐿푊푘on the instance 퐷solves (푘−1)-Set-
Intersection-Enumeration.
It remains to analyze the running time of the resulting algorithm. First observe that all relations
in 퐷have arity 푘−1. Since the domain size of 퐷is 푂(푛), the relation sizes are at most 푂(푛푘−1),
and so |퐷| = 푂(푛푘−1). Moreover, 퐷can easily be constructed in time 푂(푛푘−1). Thus, the overall
preprocessing time is 푂(푛푘−1) plus the preprocessing time of the algorithm for 퐿푊푘, which is
푂(푛푘−1 + |퐷|1+1/(푘−1)−휀) = 푂(푛푘−휀′),
for 휀′ := min{1, (푘−1)휀}. For any desired 훿′ > 0, by setting 훿:= 훿′/(푘−1) we obtain delay
푂(|퐷|훿) = 푂(푛(푘−1)훿) = 푂(푛훿′). By Lemma 52, this violates the Zero-푘-Clique Conjecture.
□
9.3
Hardness of Cyclic Joins
In this section, we describe the implication of hardness of Loomis-Whitney joins on the hardness
of other cyclic joins, and derive an enumeration lower bound for self-join free cyclic joins based
of Zero-푘-Clique. A known characterizarion of cyclic hypergraphs is that they contain a chordless

---

Tight Fine-Grained Bounds for Direct Access on Join Qeries
41
cycle or a non-conformal clique (i.e., a set of pairwise neighbors that are not contained in an edge),
see e.g. the survey [14]. By considering a minimal non-conformal clique, Brault-Baron [13] used
this property to claim that every cyclic query contains either a chordless cycle or a set of푘variables
such that there is no atom that contains all of them, but for every subset of size 푘−1 there is such
an atom. In other words, by removing all occurrences of some variables, and removing some atoms
whose variables are contained in other atoms, we can obtain either a Loomis-Whitney join or a
chordless cycle join. In case of a chordless cycle, we can always use it to solve a chordless cycle of
length 3 (also called a triangle), which can be seen as a Loomis-Whitney join of size 푘= 3. Stated
in diﬀerent words, Brault-Baron [13] essentially proved the following lemma:
Lemma 54. Let 푄be a self-join free cyclic join. There exists 푘≥3 such that there is an exact
reduction from 퐿푊푘to 푄.
Since enumeration in linear preprocessing time and constant delay is closed under exact reduc-
tions, by combining Lemma 54 with Theorem 53, we conclude the enumeration hardness of cyclic
joins based on the hardness of Zero-푘-Clique: they have no enumeration algorithm with linear
preprocessing time and constant delay.
Theorem 55. Let 푄be a self-join free cyclic join. Assuming the Zero-Clique Conjecture, there exists
an 휀> 0 such that there is no enumeration algorithm for 푄with preprocessing time 푂(|퐷|1+휀) and
delay 푂(|퐷|휀).
Proof. Let 푘be the constant from Lemma 54. Then apply Theorem 53 with 휀:= min

1
2(푘−1) ,훿

.
□
10
CONCLUSION
In this paper, we identiﬁed a parameter that we call the incompatibility number of a join query
and an order of its variables. We proposed an algorithm for direct access to the answers of a join
query in the lexicographic order induced by the variable order, using a reduction to the acyclic
case without disruptive trios which had been studied in [18]. The exponent of the preprocessing
phase of this algorithm is exactly the incompatibility number. We then complemented this upper
bound by a matching lower bound that shows that the incompatibility number cannot be beaten
as the exponent of the preprocessing for any join query, assuming the Zero-Clique Conjecture
from ﬁne-grained complexity theory. Due to the relationship of the incompatibility number and
fractional hypertree width, it follows that eﬃcient direct access in any lexicographic order requires
preprocessing that is exponential in the fractional hypertree width of the query. As part of the
lower bound proof, we established the complexity equivalence between queries with the same
structure with and without self-joins for direct access.
With only a minor change to the proof of our direct-access lower bounds, we also showed lower
bounds for enumeration. First, we showed that for Loomis-Whitney joins we cannot signiﬁcantly
improve upon a simple algorithm that computes all answers during preprocessing, assuming the
Zero-Clique Conjecture. Then, under the same assumption, we showed that acyclic queries are the
only self-join free join queries whose answers can be enumerated in constant delay after linear
preprocessing. This gives further evidence to a dichotomy that was already shown using a diﬀerent
complexity hypothesis.
We have also presented several extensions of our main results on direct access where we weak-
ened the order requirements or allowed projections. In these settings, we have seen that our ap-
proach does not yield optimal algorithms. It would be interesting to understand the complexity
landscape for these extensions better, and we leave this as an open question for future work.

---

42
Karl Bringmann, Nofar Carmeli, and Stefan Mengel
On a more technical level, we have seen that the Zero-Clique Conjecture is tightly linked to
푘-Set-Intersection and 푘-Set-Disjointness, which can be seen as variants of a join query. Thus, it
seems plausible that there are additional applications of the Zero-Clique Conjecture in database
theory, and it would be interesting to further explore such connections.
REFERENCES
[1] Amir Abboud, Karl Bringmann, Holger Dell, and Jesper Nederlof. 2018. More consequences of falsifying SETH and
the orthogonal vectors conjecture. In Proceedings of the 50th Annual ACM SIGACT Symposium on Theory of Computing,
STOC 2018, Los Angeles, CA, USA, June 25-29, 2018, Ilias Diakonikolas, David Kempe, and Monika Henzinger (Eds.).
ACM, 253–266. https://doi.org/10.1145/3188745.3188938
[2] Amir Abboud, Virginia Vassilevska Williams, and Oren Weimann. 2014. Consequences of Faster Alignment of Se-
quences. In Automata, Languages, and Programming - 41st International Colloquium, ICALP 2014, Copenhagen, Den-
mark, July 8-11, 2014, Proceedings, Part I (Lecture Notes in Computer Science, Vol. 8572), Javier Esparza, Pierre Fraigni-
aud, Thore Husfeldt, and Elias Koutsoupias (Eds.). Springer, 39–51. https://doi.org/10.1007/978-3-662-43948-7_4
[3] Serge Abiteboul, Richard Hull, and Victor Vianu. 1995.
Foundations of Databases.
Addison-Wesley.
http://webdam.inria.fr/Alice/
[4] Mahmoud Abo Khamis, Hung Q. Ngo, and Atri Rudra. 2016.
FAQ: Questions Asked Frequently. In Pro-
ceedings of the 35th ACM SIGMOD-SIGACT-SIGAI Symposium on Principles of Database Systems (San Fran-
cisco, California, USA) (PODS ’16). Association for Computing Machinery, New York, NY, USA, 13–28.
https://doi.org/10.1145/2902251.2902280
[5] Noga Alon, Raphael Yuster, and Uri Zwick. 1997. Finding and Counting Given Length Cycles. Algorithmica 17, 3
(1997), 209–223. https://doi.org/10.1007/BF02523189
[6] Albert Atserias, Martin Grohe, and Dániel Marx. 2013. Size Bounds and Query Plans for Relational Joins. SIAM J.
Comput. 42, 4 (2013), 1737–1767. https://doi.org/10.1137/110859440
[7] Arturs Backurs, Nishanth Dikkala, and Christos Tzamos. 2016. Tight Hardness Results for Maximum Weight Rectan-
gles. In 43rd International Colloquium on Automata, Languages, and Programming, ICALP 2016, July 11-15, 2016, Rome,
Italy (LIPIcs, Vol. 55), Ioannis Chatzigiannakis, Michael Mitzenmacher, Yuval Rabani, and Davide Sangiorgi (Eds.).
Schloss Dagstuhl - Leibniz-Zentrum für Informatik, 81:1–81:13. https://doi.org/10.4230/LIPIcs.ICALP.2016.81
[8] Arturs Backurs and Christos Tzamos. 2017. Improving Viterbi is Hard: Better Runtimes Imply Faster Clique Algo-
rithms. In Proceedings of the 34th International Conference on Machine Learning, ICML 2017, Sydney, NSW, Australia,
6-11 August 2017 (Proceedings of Machine Learning Research, Vol. 70), Doina Precup and Yee Whye Teh (Eds.). PMLR,
311–321. http://proceedings.mlr.press/v70/backurs17a.html
[9] Guillaume Bagan. 2009. Algorithmes et complexité des problèmes d’énumération pour l’évaluation de requêtes logiques.
(Algorithms and complexity of enumeration problems for the evaluation of logical queries). Ph. D. Dissertation. Univer-
sity of Caen Normandy, France. https://tel.archives-ouvertes.fr/tel-00424232
[10] Guillaume Bagan, Arnaud Durand, Etienne Grandjean, and Frédéric Olive. 2008. Computing the jth solution of a
ﬁrst-order query. RAIRO Theor. Informatics Appl. 42, 1 (2008), 147–164. https://doi.org/10.1051/ita:2007046
[11] Christoph Berkholz, Fabian Gerhardt, and Nicole Schweikardt. 2020. Constant delay enumeration for conjunctive
queries: a tutorial. ACM SIGLOG News 7, 1 (2020), 4–33.
[12] Christoph Berkholz and Nicole Schweikardt. 2019.
Constant Delay Enumeration with FPT-Preprocessing for
Conjunctive Queries of Bounded Submodular Width. In 44th International Symposium on Mathematical Founda-
tions of Computer Science, MFCS 2019, August 26-30, 2019, Aachen, Germany (LIPIcs, Vol. 138), Peter Rossmanith,
Pinar Heggernes, and Joost-Pieter Katoen (Eds.). Schloss Dagstuhl - Leibniz-Zentrum für Informatik, 58:1–58:15.
https://doi.org/10.4230/LIPIcs.MFCS.2019.58
[13] Johann Brault-Baron. 2013. De la pertinence de l’énumération: complexité en logiques propositionnelle et du premier
ordre. Ph. D. Dissertation. Université de Caen.
[14] Johann Brault-Baron. 2016.
Hypergraph Acyclicity Revisited.
ACM Comput. Surv. 49, 3 (2016), 54:1–54:26.
https://doi.org/10.1145/2983573
[15] Karl Bringmann, Nofar Carmeli, and Stefan Mengel. 2022.
Tight Fine-Grained Bounds for Direct Access on
Join Queries. In Proceedings of the 41st ACM SIGMOD-SIGACT-SIGAI Symposium on Principles of Database Sys-
tems (Philadelphia, PA, USA) (PODS ’22). Association for Computing Machinery, New York, NY, USA, 427–436.
https://doi.org/10.1145/3517804.3526234
[16] Karl Bringmann, Pawel Gawrychowski, Shay Mozes, and Oren Weimann. 2020.
Tree Edit Distance Cannot
be Computed in Strongly Subcubic Time (Unless APSP Can).
ACM Trans. Algorithms 16, 4 (2020), 48:1–48:22.
https://doi.org/10.1145/3381878

---

Tight Fine-Grained Bounds for Direct Access on Join Qeries
43
[17] Nofar Carmeli and Luc Segouﬁn. 2023.
Conjunctive Queries With Self-Joins, Towards a Fine-Grained Enu-
meration Complexity Analysis. In Proceedings of the 42nd ACM SIGMOD-SIGACT-SIGAI Symposium on Prin-
ciples of Database Systems (PODS ’23). Association for Computing Machinery, New York, NY, USA, 277–289.
https://doi.org/10.1145/3584372.3588667
[18] Nofar Carmeli, Nikolaos Tziavelis, Wolfgang Gatterbauer, Benny Kimelfeld, and Mirek Riedewald. 2021. Tractable
Orders for Direct Access to Ranked Answers of Conjunctive Queries. In Proceedings of the 40th ACM SIGMOD-SIGACT-
SIGAI Symposium on Principles of Database Systems. 325–341.
[19] Nofar Carmeli, Shai Zeevi, Christoph Berkholz, Benny Kimelfeld, and Nicole Schweikardt. 2020. Answering (unions
of) conjunctive queries using random access and random-order enumeration. In Proceedings of the 39th ACM SIGMOD-
SIGACT-SIGAI Symposium on Principles of Database Systems. 393–409.
[20] Hubie Chen and Stefan Mengel. 2015.
A Trichotomy in the Complexity of Counting Answers to Conjunctive
Queries. In 18th International Conference on Database Theory, ICDT 2015, March 23-27, 2015, Brussels, Belgium (LIPIcs,
Vol. 31), Marcelo Arenas and Martín Ugarte (Eds.). Schloss Dagstuhl - Leibniz-Zentrum für Informatik, 110–126.
https://doi.org/10.4230/LIPIcs.ICDT.2015.110
[21] Thomas H. Cormen, Charles E. Leiserson, Ronald L. Rivest, and Cliﬀord Stein. 2009. Introduction to Algorithms, 3rd
Edition. MIT Press. http://mitpress.mit.edu/books/introduction-algorithms
[22] Víctor Dalmau and Peter Jonsson. 2004. The complexity of counting homomorphisms seen from the other side. Theor.
Comput. Sci. 329, 1-3 (2004), 315–323. https://doi.org/10.1016/j.tcs.2004.08.008
[23] Arnaud Durand and Stefan Mengel. 2014. The complexity of weighted counting for acyclic conjunctive queries. J.
Comput. Syst. Sci. 80, 1 (2014), 277–296. https://doi.org/10.1016/j.jcss.2013.08.001
[24] Georg Gottlob, Matthias Lanzinger, Reinhard Pichler, and Igor Razgon. 2021. Complexity Analysis of Generalized and
Fractional Hypertree Decompositions. J. ACM 68, 5, Article 38 (sep 2021), 50 pages. https://doi.org/10.1145/3457374
[25] Martin Grohe and Dániel Marx. 2014. Constraint Solving via Fractional Edge Covers. ACM Trans. Algorithms 11, 1
(2014), 4:1–4:20. https://doi.org/10.1145/2636918
[26] Jens Keppeler. 2020.
Answering Conjunctive Queries and FO+MOD Queries under Updates.
Ph. D. Dissertation.
Humboldt-Universität zu Berlin, Mathematisch-Naturwissenschaftliche Fakultät. https://doi.org/10.18452/21483
[27] Mahmoud Abo Khamis, Ryan R. Curtin, Benjamin Moseley, Hung Q. Ngo, XuanLong Nguyen, Dan Olteanu, and
Maximilian Schleich. 2020. Functional Aggregate Queries with Additive Inequalities. ACM Trans. Database Syst. 45,
4 (2020), 17:1–17:41. https://doi.org/10.1145/3426865
[28] Mahmoud Abo Khamis, Hung Q. Ngo, and Dan Suciu. 2017. What Do Shannon-type Inequalities, Submodular Width,
and Disjunctive Datalog Have to Do with One Another?. In Proceedings of the 36th ACM SIGMOD-SIGACT-SIGAI
Symposium on Principles of Database Systems, PODS 2017, Chicago, IL, USA, May 14-19, 2017, Emanuel Sallinger, Jan Van
den Bussche, and Floris Geerts (Eds.). ACM, 429–444. https://doi.org/10.1145/3034786.3056105
[29] Tsvi Kopelowitz, Seth Pettie, and Ely Porat. 2016. Higher Lower Bounds from the 3SUM Conjecture. In Proceedings of
the Twenty-Seventh Annual ACM-SIAM Symposium on Discrete Algorithms, SODA 2016, Arlington, VA, USA, January
10-12, 2016, Robert Krauthgamer (Ed.). SIAM, 1272–1287. https://doi.org/10.1137/1.9781611974331.ch89
[30] Andrea Lincoln, Virginia Vassilevska Williams, and R. Ryan Williams. 2018.
Tight Hardness for Shortest Cy-
cles and Paths in Sparse Graphs. In Proceedings of the Twenty-Ninth Annual ACM-SIAM Symposium on Dis-
crete Algorithms, SODA 2018, New Orleans, LA, USA, January 7-10, 2018, Artur Czumaj (Ed.). SIAM, 1236–1252.
https://doi.org/10.1137/1.9781611975031.80
[31] Dániel Marx. 2013. Tractable Hypergraph Properties for Constraint Satisfaction and Conjunctive Queries. J. ACM
60, 6 (2013), 42:1–42:51. https://doi.org/10.1145/2535926
[32] Michael Mitzenmacher and Eli Upfal. 2017. Probability and computing: Randomization and probabilistic techniques in
algorithms and data analysis. Cambridge university press.
[33] Hung Q. Ngo, Ely Porat, Christopher Ré, and Atri Rudra. 2012. Worst-case optimal join algorithms: [extendedabstract].
In Proceedings of the 31st ACM SIGMOD-SIGACT-SIGART Symposium on Principles of Database Systems, PODS 2012,
Scottsdale, AZ, USA, May 20-24, 2012, Michael Benedikt, Markus Krötzsch, and Maurizio Lenzerini (Eds.). ACM, 37–48.
https://doi.org/10.1145/2213556.2213565
[34] Hung Q. Ngo, Ely Porat, Christopher Ré, and Atri Rudra. 2018. Worst-case Optimal Join Algorithms. J. ACM 65, 3
(2018), 16:1–16:40. https://doi.org/10.1145/3180143
[35] Francesco Scarcello. 2018. From Hypertree Width to Submodular Width and Data-dependent Structural Decompo-
sitions. In Proceedings of the 26th Italian Symposium on Advanced Database Systems, Castellaneta Marina (Taranto),
Italy, June 24-27, 2018 (CEUR Workshop Proceedings, Vol. 2161), Sonia Bergamaschi, Tommaso Di Noia, and Andrea
Maurino (Eds.). CEUR-WS.org. http://ceur-ws.org/Vol-2161/paper24.pdf
[36] Alexander Schrijver. 2003. Combinatorial optimization: polyhedra and eﬃciency. Springer.
[37] Todd L. Veldhuizen. 2014. Triejoin: A Simple, Worst-Case Optimal Join Algorithm. In Proc. 17th International Confer-
ence on Database Theory (ICDT), Athens, Greece, March 24-28, 2014, Nicole Schweikardt, Vassilis Christophides, and

---

44
Karl Bringmann, Nofar Carmeli, and Stefan Mengel
Vincent Leroy (Eds.). OpenProceedings.org, 96–106. https://doi.org/10.5441/002/icdt.2014.13
[38] Virginia Vassilevska Williams. 2018. On some ﬁne-grained questions in algorithms and complexity. In Proceedings of
the International Congress of Mathematicians: Rio de Janeiro 2018. World Scientiﬁc, 3447–3487.
[39] Virginia Vassilevska Williams and Ryan Williams. 2013. Finding, Minimizing, and Counting Weighted Subgraphs.
SIAM J. Comput. 42, 3 (2013), 831–854. https://doi.org/10.1137/09076619X
[40] Virginia Vassilevska Williams and R. Ryan Williams. 2018. Subcubic Equivalences Between Path, Matrix, and Triangle
Problems. J. ACM 65, 5 (2018), 27:1–27:38. https://doi.org/10.1145/3186893
[41] Virginia Vassilevska Williams and Yinzhan Xu. 2020.
Monochromatic Triangles, Triangle Listing and APSP.
In 61st IEEE Annual Symposium on Foundations of Computer Science, FOCS, Sandy Irani (Ed.). IEEE, 786–797.
https://doi.org/10.1109/FOCS46700.2020.00078

---

