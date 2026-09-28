# Probabilistic Query Evaluation with Bag Semantics

> 来源: https://arxiv.org/pdf/2201.11524

arXiv:2201.11524v3  [cs.DB]  17 Jul 2023
Probabilistic Qery Evaluation with Bag Semantics
Martin Grohe1, Peter Lindner2, and Christoph Standke1
1{grohe,standke}@informatik.rwth-aachen.de,
RWTH Aachen University, Aachen, Germany
2peter.lindner@epﬂ.ch,
École Polytechnique Fédérale de Lausanne (EPFL), Lausanne, Switzerland
July 18, 2023
Abstract
We study the complexity of evaluating queries on probabilistic databases under bag se-
mantics. We focus on self-join free conjunctive queries, and probabilistic databases where
occurrences of diﬀerent facts are independent, which is the natural generalization of tuple-
independent probabilistic databases to the bag semantics setting. For set semantics, the
data complexity of this problem is well understood, even for the more general class of
unions of conjunctive queries: it is either in polynomial time, or ♯P-hard, depending on
the query (Dalvi & Suciu, JACM 2012).
A reasonably general model of bag probabilistic databases may have unbounded multi-
plicities. In this case, the probabilistic database is no longer ﬁnite, and a careful treatment
of representation mechanisms is required. Moreover, the answer to a Boolean query is a
probability distribution over (possibly all) non-negative integers, rather than a probability
distribution over {true, false}. Therefore, we discuss two ﬂavors of probabilistic query eval-
uation: computing expectations of answer tuple multiplicities, and computing the proba-
bility that a tuple is contained in the answer at most 푘times for some parameter 푘. Subject
to mild technical assumptions on the representation systems, it turns out that expectations
are easy to compute, even for unions of conjunctive queries. For query answer probabil-
ities, we obtain a dichotomy between solvability in polynomial time and ♯P-hardness for
self-join free conjunctive queries.
1. Introduction
Probabilistic databases (PDBs) provide a framework for managing uncertain data. In database
theory, they have been intensely studied since the late 1990s [31, 32]. Most eﬀorts have been
directed towards tuple-independent relational databases under a set semantics. Many relational
database systems, however, use a bag semantics, where identical tuples may appear several
times in the same relation. Despite receiving little attention so far, bag semantics are also
a natural setting for probabilistic databases. For example, they naturally enter the picture
when aggregation is performed, or when statistics are computed (e.g., by random sampling,
1

---

say, without replacement). Either case might involve computing projections without duplicate
elimination ﬁrst. Even when starting from a tuple-independent probabilistic database with set
semantics, this typically gives rise to (proper) bags. Even in the traditional setting of a PDB
where only ﬁnitely many facts appear with non-zero probability, under a bag semantics we
have to consider inﬁnite probability spaces [20, 19], simply because there is no a priori bound
on the number of times a fact may appear in a bag. In general, while the complexity landscape
of query answering is well understood for simple models of PDBs under set semantics, the
picture for bag semantics is still mostly unexplored.
Formally, probabilistic databases are probability distributions over conventional database in-
stances. In a database instance, the answer to a Boolean query under set semantics is either true
(1) or false (0). In a probabilistic database, the answer to such a query becomes a {0, 1}-valued
random variable. The problem of interest is probabilistic query evaluation, that is, computing
the probability that a Boolean query returns true, when given a probabilistic database. The
restriction to Boolean queries comes with no loss of generality: to compute the probability of
any tuple in the result of a non-Boolean query, all we have to do is replace the free variables of
the query according to the target tuple, and solve the problem for the resulting Boolean query
[31].
Under a bag semantics, a Boolean query is still just a query without free variables, but the
answer to Boolean query can be any non-negative integer, which can be interpreted as the mul-
tiplicity of the empty tuple in the query answer, or more intuitively as the number of diﬀerent
ways in which the query is satisﬁed. In probabilistic query evaluation, we then get ℕ-valued
answer random variables. Still, the reduction from the non-Boolean to the Boolean case works
as described above. Therefore, without loss of generality, we only discuss Boolean queries in this
paper.
As most of the database theory literature, we study the data complexity of query evaluation
[33], that is, the complexity of the problem, when the query 푄is ﬁxed, and the PDB is the
input. The standard model for complexity theoretic investigations is that of tuple-independent
PDBs, where the distinct facts constitute independent events. Probabilistic query evaluation is
well-understood for the class of unions of conjunctive queries (UCQs) on PDBs that are tuple-
independent (see the related works section below). Most prior work, however, considers the
problem under plain set semantics or in ﬁnite and restricted settings. Here, on the contrary,
we discuss the probabilistic query evaluation under bag semantics.
For tuple-independent (set) PDBs, a variety of representation systems have been proposed
(cf. [18, 31]), although for complexity theoretic discussions, it is usually assumed that the input
is just given as a table of facts, together with their marginal probabilities[32]. In the bag version
of tuple-independent PDBs [19], diﬀerent facts are still independent. Yet, the individual facts
(or, rather, their multiplicities) are ℕ-valued, instead of Boolean, random variables. As this,
in general, rules out the naive representation through a list of facts, multiplicities, and proba-
bilities, it is necessary to ﬁrst deﬁne suitable representation systems before the complexity of
computational problems can be discussed.
Once we have settled on a suitable class of representations, we investigate the problem
of probabilistic query evaluation again, subject to representation system Rep. Under bag
semantics, there are now two natural computational problems regarding query evaluation:
EXPECTATIONRep(푄), which is computing the expected outcome, and PQERep(푄, 푘) which is
2

---

computing the probability that the outcome is at most 푘. Notably, these two problems coincide
for set semantics, because the expected value of a {0, 1}-valued random variables coincides with
the probability that the outcome is 1. Under a bag semantics, however, the two versions exhibit
quite diﬀerent properties (cf. [29, 14]).
Recall that using a set semantics, unions of conjunctive queries can either be answered in
polynomial time, or are ♯P-hard [12]. Interestingly, computing expectations using a bag seman-
tics is extraordinarily easy in comparison: with only mild assumptions on the representation,
the expectation of any UCQ can be computed in polynomial time. Furthermore, the variance of
the random variable can also be computed in polynomial time, which via Chebyshev’s inequal-
ity gives us a way to estimate the probability that the query answer is close to its expectation.
These results contrast the usual landscape of computational problems in uncertain data man-
agement, which are rarely solvable eﬃciently.
The computation of probabilities of concrete answer multiplicities, however, appears to be
less accessible, and in fact, in its properties is more similar to the set semantics version of prob-
abilistic query evaluation. Our main result states that for Boolean conjunctive queries without
self-joins, we have a dichotomy between polynomial time and ♯P-hardness of the query. This
holds whenever eﬃcient access to fact probabilities is guaranteed by the representation sys-
tem and is independent of 푘. Although the proof builds upon ideas and notions introduced
for the set semantics dichotomy [9, 10, 12], we are confronted with a number of completely
new and intricate technical challenges due to the change of semantics. On the one hand, the
bag semantics turns disjunctions and existential quantiﬁcation into sums. This facilitates the
computation of expected values, because it allows us to exploit linearity. On the other hand,
the new semantics (and the potential presence of inﬁnite multiplicity distributions) keep us
from directly applying some of the central ideas from [12] when analyzing PQERep(푄, 푘), thus
necessitating novel techniques. The bag semantics dichotomy for answer count probabilities
is, hence, far from being a simple corollary from the set semantics dichotomy. From the tech-
nical perspective, the most interesting result is the transfer of hardness from PQERep(푄, 0) to
PQERep(푄, 푘). In essence, we need to ﬁnd a way to compute the probability that 푄has 0 an-
swers, with only having access to the probability that 푄has at most 푘answers for any single
ﬁxed 푘. This reduction uses new non-trivial techniques: by manipulating the input table, we
can construct multiple instances of the PQERep(푄, 푘) problem. We then transform the solutions
to these problems, which are obtained through oracle calls, into function values of a polyno-
mial (with a priori unknown coeﬃcients) in such a way, that the solution to PQERep(푄, 0) on the
original input is hidden in the leading coeﬃcient of this polynomial. Using a technique from
polynomial interpolation, we can ﬁnd these leading coeﬃcients, and hence, solve PQERep(푄, 0).
Related Work
The most prominent result regarding probabilistic query evaluation is the
Dichotomy theorem by Dalvi and Suciu [12] that provides a separation between unions of con-
junctive queries for which probabilistic evaluation is possible in polynomial time, and such
where the problem becomes ♯P-hard. They started their investigations with self-join free con-
junctive queries [10] and later extended their results to general CQs [11] and then UCQs [12].
Beyond the queries they investigate, there are a few similar results for fragments with nega-
tions or inequalities[15, 27, 28], for homomorphism-closed queries [4], and on restricted classes
3

---

of PDBs [1]. Good overviews over related results are given in [32, 30]. In recent developments,
the original dichotomies for self-join free CQs, and for general UCQs have been shown to hold
even under severe restrictions to the fact probabilities that are allowed to appear [2, 23].
The bag semantics for CQs we use here is introduced in [7]. A detailed analysis of the
interplay of bag and set semantics is presented in [8]. Considering multiplicities as semi-ring
annotations [17, 21], embeds bag semantics into a broader mathematical framework.
In two closely related papers [29, 14], the authors study various aggregates (including,
in particular, Count and Sum) over select-project-join queries on semi-ring annotated tuple-
independent PDBs. This has direct implications for query evaluation with bag semantics and,
in particular, implies some of our results, at least for ﬁnite probability distributions. Speciﬁ-
cally, for full count aggregations, this is equivalent to the semantics of Boolean CQs that are
discussed in Section 2. In this sense, these papers discuss a variant of our PQE(푄, 푘) problem.
Neither of the papers discusses the impact of the representation of probability distributions
and restrictions thereof in greater detail. We explain the diﬀerences, and the contributions
with respect to PQE(푄, 푘) below and have added some additional remarks within the main part
of our paper.
In the work of Ré and Suciu [29], the input is just a tuple-independent PDB, and the anno-
tations for answering Count aggregate queries are ﬁxed to be 1 for all tuples, in the semi-ring
of integers modulo 푘+ 1. The value 푘itself is part of the input and assumed to be given in
binary encoding (rather than constant, as in our later discussion). In general, they do not
allow arbitrary semi-ring annotations, but have ﬁxed semi-ring annotations for a given tuple-
independent PDB , depending on and the query 푄. In this setting, they establish a di-
chotomy in [29, Theorem 2]: If the Boolean CQ 푄is non-hierarchical, then computing answer
count probabilities is ♯P-hard, otherwise, it can be solved in polynomial time (the latter being
extended by the results of [14], see below). They do not give the details for hardness of Count,
but the argument can be assumed to work similar to our proof of Proposition 5.10 for 푘= 0, and
does not easily extend to arbitrary constant 푘in our more general setting (see Theorem 5.12
and our surrounding discussion). In conclusion, concerning hardness, their techniques only
suﬃce to directly infer ♯P-hardness of our PQE(푄, 푘) problem for non-hierarchical Boolean
CQs 푄, 푘= 0, and their special, restricted class of representations. They do cover more general
annotations for Sum queries, but there is no direct way to transfer these results back to our
PQE(푄, 푘) problem.
Fink, Han and Olteanu [14] use a highly more general representation system, called pvc-
tables, in which tuples in the input tuple-independent PDB may have values and annotations
that are general semi-ring or semi-module expressions in independent random variables. In
contrast, our representation system in Section 3 would correspond to annotating each tuple
with a distinct (ℕ-valued) random variable. They establish tractability for a class of queries
covering self-join free, hierarchical Boolean CQs by compiling queries into 푑-trees. Such a
푑-tree encodes the probability distribution of answer counts in terms of the probability dis-
tributions of random variables in the annotations. They suggest to support distributions with
inﬁnite, even uncountable support (pointing to [24]), but do not discuss their encoding and its
impact on tractability. In particular, their statements about evaluating compiled 푑-trees [14, Re-
mark 1 & Theorem 2] assume ﬁnite distribution supports. Moreover, to obtain their tractability
result for Count, they go back to more restricted annotations similar to [29], see [14, Proposi-
4

---

tion 3]. Still, they essentially cover Theorem 5.8, and the algorithm we present in Appendix B.3
can be seen as a special case of theirs. The same algorithm is underlying [29, Theorem 1]. Fink
et al. do not discuss hardness beyond what is said in [29].
Finally, in recent work (independent of ours), Feng et al. [13] analyze the ﬁne-grained com-
plexity of computing expectations of queries in probabilistic bag databases, albeit assuming
ﬁnite multiplicity supports and hence still in the realm of ﬁnite probabilistic databases.
2. Preliminaries
We denote by ℕand ℕ+ the sets of non-negative, and of positive integers, respectively. We
denote open, closed and half open intervals of real numbers by (푎, 푏), [푎, 푏], [푎, 푏) and (푎, 푏],
respectively, where 푎≤푏. By (
푛
푘) we denote the binomial coeﬃcient and by (
푛
푛1,…,푛푘) the multi-
nomial coeﬃcient.
Let Ω be a non-empty ﬁnite or countably inﬁnite set and let 푃∶Ω →[0, 1] be a function
satisfying ∑휔∈Ω 푃(휔) = 1. Then (Ω, 푃) is a (discrete) probability space. Subsets 퐴⊆Ω are called
events. We write Pr휔∼Ω(휔∈퐴) for the probability of a randomly drawn 휔∈Ω (distributed
according to 푃) to be in 퐴. More generally, we may write Pr휔∈Ω(휔has property 휙) for the
probability of a randomly drawn element to satisfy some property 휙. All probability spaces
appearing in this paper are discrete.
Functions 푋∶Ω →ℝon a probability space are called random variables. The expected value
and variance of 푋are denoted by E(푋) and Var(푋), respectively. The values E(푋푘) for integers
푘≥2 are called the higher-order moments of 푋.
2.1. Probabilistic Bag Databases
We ﬁx a countable, non-empty set dom (the domain). A database schema 휏is a ﬁnite, non-empty
set of relation symbols. Every relation symbol 푅has an arity ar(푅) ∈ℕ+.
A fact over 휏and dom is an expression 푅(퐚) where 퐚∈domar(푅). A (bag) database instance 퐷
is a bag (i.e. multiset) of facts. Formally, a bag (instance) is speciﬁed by a function ♯퐷that maps
every fact 푓to its multiplicity ♯퐷(푓) in 퐷. The active domain adom(퐷) is the set of domain
elements 푎from dom for which there exists a fact 푓containing 푎such that ♯퐷(푓) > 0.
A probabilistic (bag) database (or, (bag) PDB) is a pair (픻, 푃) where 픻is a set of bag
instances and 푃∶2픻→[0, 1] is a probability distribution over 픻. Note that, even when
the total number of diﬀerent facts is ﬁnite, 픻may be inﬁnite, as facts may have arbitrarily
large multiplicities. We let ♯(푓) denote the random variable 퐷↦♯퐷(푓) for all facts 푓. If
= (픻, 푃) is a PDB, then adom() ∶= ⋃퐷∈픻adom(퐷). We call a PDB fact-ﬁnite if the set
{푓∶♯퐷(푓) > 0 for some 퐷∈픻} is ﬁnite. In this case, adom() is ﬁnite, too.
A bag PDB is called tuple-independent if for all 푘∈ℕ, all pairwise distinct facts 푓1, … , 푓푘,
and all 푛1, … , 푛푘∈ℕ, the events ♯퐷(푓푖) = 푛푖are independent, i. e.,
Pr
퐷∼(♯퐷(푓푖) = 푛푖for all 푖= 1, … , 푘) =
푘
∏
푖=1
Pr
퐷∼(♯퐷(푓푖) = 푛푖).
Unless it is stated otherwise, all probabilistic databases we treat in this paper are assumed to be
fact-ﬁnite and tuple-independent.
5

---

2.2. UCQs with Bag Semantics
Let 핍be a countably inﬁnite set of variables. An atom is an expression of the shape 푅(퐭) where
푅∈휏and 퐭∈(dom ∪핍)ar(푅). A conjunctive query (CQ) is a formula 푄of ﬁrst-order logic (over
휏and dom) of the shape
푄= ∃푥1 … ∃푥푚∶푅1(퐭1) ∧⋯∧푅푛(퐭푛),
in which we always assume that the 푥푖are pairwise diﬀerent, and that 푥푖appears in at least one
of 퐭1, … , 퐭푛for all 푖= 1, … , 푚. A CQ 푄is self-join free, if every relation symbol occurs at most
once within 푄. In general, the self-join width of a CQ 푄is the maximum number of repetitions of
the same relation symbol in 푄. If 푄is a CQ of the above shape, we let 푄∗denote the quantiﬁer-
free part 푅1(퐭1) ∧… 푅푛(퐭푛) of 푄, and we call 푅푖(퐭푖) an atom of 푄for all 푖= 1, … , 푛. A union of
conjunctive queries (UCQ) is a formula of the shape 푄= 푄1 ∨⋯∨푄푁where 푄1, … , 푄푁are CQs.
A query is called Boolean, if it contains no free variables (that is, there are no occurrences of
variables that are not bound by a quantiﬁer). From now on, and throughout the remainder of the
paper, we only discuss Boolean (U)CQs.
Recall that ♯퐷is the multiplicity function of the instance 퐷. The bag semantics of (U)CQs
extends ♯퐷to queries. For Boolean CQs 푄= ∃푥1 … ∃푥푚∶푅1(퐭1) ∧⋯∧푅푛(퐭푛) we deﬁne
♯퐷(푄) ∶=
∑
퐚∈adom(퐷)푚
푛
∏
푖=1
♯퐷(푅푖(퐭푖[퐱/퐚])),
(1)
where 퐱= (푥1, … , 푥푚) and 퐚= (푎1, … , 푎푚), and 푅푖(퐭푖[퐱/퐚]) denotes the fact obtained from 푅푖(퐭푖)
by replacing, for all 푗= 1, … , 푚, every occurrence of 푥푗by 푎푗. If 푄= 푄1 ∨⋯∨푄푁is a Boolean
UCQ, then each of the 푄푖is a Boolean CQ. We deﬁne
♯퐷(푄) ∶= ♯퐷(푄1) + ⋯+ ♯퐷(푄푁).
(2)
Whenever convenient, we write ♯퐷푄instead of ♯퐷(푄). We emphasize once more, that the query
being Boolean does not mean that its answer is 0 or 1 under bag semantics, but could be any
non-negative integer.
Remark 2.1. We point out that in (1), conjunctions should intuitively be understood as joins
rather than intersections. Our deﬁnition (1) for the bag semantics of CQs matches the one
that was given in [7]. This, and the extension (2) for UCQs, are essentially special cases of
how semiring annotations of formulae are introduced in the provenance semiring framework
[17, 21], the only diﬀerence being that we use the active domain semantics. For UCQs however,
this is equivalent since the value of (1) stays the same when the quantiﬁers range over arbitrary
supersets of adom(퐷).
Note that the result ♯퐷푄of a Boolean UCQ on a bag instance 퐷is a non-negative integer.
Thus, evaluated over a PDB = (픻, 푃), this yields a ℕ-valued random variable ♯푄with
Pr (♯푄= 푘) = Pr
퐷∼(♯퐷푄= 푘).
Example 2.2. Consider tuple-independent bag PDB over facts 푅(푎) and 푆(푎), where 푅(푎) has
multiplicity 2 or 3, both with probability 1
2, and 푆(푎) has multiplicity 1, 2 or 3, with probability
1
3 each. Then, the probability of the event ♯(푅(푎) ∧푆(푎)) = 6 is given by Pr (♯(푅(푎)) =
2) Pr (♯(푆(푎)) = 3) + Pr (♯(푅(푎)) = 3) Pr (♯(푆(푎)) = 2) = 1
3.
6

---

There are now two straight-forward ways to formulate the problem of answering a Boolean
UCQ over a probabilistic database. We could either ask for the expectationE (♯퐷푄), or compute
the probability that ♯푄is at most / at least / equal to 푘. These two options coincide for
set semantics, as ♯푄is {0, 1}-valued in this setting.1 For bag PDBs, these are two separate
problems to explore. Complexity-wise, we focus on data complexity [33]. That is, the query
(and for the second option, additionally the number 푘) is a parameter of the problem, so that
the input is only the PDB. Before we can start working on these problems, we ﬁrst need to
discuss how bag PDBs are presented as an input to an algorithm. This is the purpose of the
next section.
3. Representation Systems
For the set version of probabilistic query evaluation, the default representation system repre-
sents tuple-independent PDBs by specifying all facts together with their marginal probability.
The distinction between a PDB and its representation is then usually blurred in the literature.
This does not easily extend to bag PDBs, as the distributions of ♯퐷(푓) for facts 푓may have
inﬁnite support.
Example 3.1. Let = (픻, 푃) be a bag PDB over a single fact 푓with multiplicity distribution
♯(푓) ∼Geometric( 1
2), i.e., Pr퐷∼(♯퐷(푓) = 푘) = 2−푘. Then the instances of with positive
probability are {{}}, {{푓}}, {{푓, 푓}}, … , so is an inﬁnite PDB.
To use such PDBs as inputs for algorithms, we introduce a suitable class of representation
systems (RS) [18]. All computational problems are then stated with respect to an RS.
Deﬁnition 3.2 (cf. [18]). A representation system (RS) for bag PDBs is a pair (퐓, J ⋅K) where 퐓
is a non-empty set (the elements of which we call tables), and J⋅K is a function that maps every
푇∈퐓to a probabilistic database J푇K.
Given an RS, we abuse notation and also use 푇to refer to the PDB J푇K. Note that Deﬁni-
tion 3.2 is not tailored to tuple-independence yet and requires no independence assumptions.
For representing tuple-independent bag PDBs, we introduce a particular subclass of RS’s where
facts are labeled with the parameters of parameterized distributions over multiplicities. For
example, a fact 푓whose multiplicity is geometrically distributed with parameter 1
2 could be
annotated with (Geometric, 1/2), representing 1
2 using two integers.
Deﬁnition 3.3. A parameterized TI representation system (in short: TIRS) is a tuple Rep =
(Λ, 퐏, Σ, 퐓, ⟨⋅⟩, J⋅K) where Λ ≠∅is a set (the parameter set); 퐏is a family (푃휆)휆∈Λ of probability
distributions 푃휆over ℕ; Σ ≠∅is a ﬁnite set of symbols (the encoding alphabet); ⟨⋅⟩∶Λ →Σ∗
is an injective function (the encoding function); and (퐓, J ⋅K) is an RS where
• 퐓is the family of all ﬁnite sets 푇of pairs (푓, ⟨휆푓⟩) with pairwise diﬀerent facts 푓of a
given schema and 휆푓∈Λ for all 푓; and
1In fact, in the literature both approaches have been used to introduce the problem of probabilistic query evalua-
tion [31, 32].
7

---

Relation 푅
Parameter
푅(1, 1)
(Bernoulli, 1/2)
푅(1, 2)
(Binomial, 10, 1/3)
푅(2, 2)
(0 ↦1/4; 1 ↦1/4; 5 ↦1/2)
Relation 푆
Parameter
푆(1)
(Geometric, 1/3)
푆(2)
(Poisson, 3)
Figure 1: Example of a parameterized TI representation.
• J⋅K maps every 푇∈퐓to the tuple-independent bag PDB with multiplicity probabilities
Pr(♯푓= 푘) = 푃휆푓(푘) for all (푓, ⟨휆푓⟩) ∈푇.
Whenever a TIRS Rep is given, we assume Rep = (ΛRep, 퐏Rep, ΣRep, 퐓Rep, ⟨⋅⟩Rep, J ⋅KRep) by
default.
Example 3.4. Figure 1 shows a table 푇from a TIRS Rep, illustrating how the parameters can be
used to encode several multiplicity distributions. Four of the distributions are standard parame-
terized distributions, presented using their symbolic name together with their parameters. The
multiplicity distribution for 푅(2, 2) is a generic distribution with ﬁnite support {0, 1, 5}. The an-
notation (Binomial, 10, 1/3) of 푅(1, 2) in the table speciﬁes that ♯푇푅(1, 2) ∼Binomial (10, 1
3).
That is,
Pr (♯푇푅(1, 2) = 푘) =
{
(
10
푘)(1
3)푘(2
3)10−푘
if 0 ≤푘≤10 and
0
if 푘> 10.
The multiplicity probabilities of the other facts are given analogously in terms of the Bernoulli,
geometric, and Poisson distributions, respectively. The supports of the multiplicity distribu-
tions are {0, 1} for the Bernoulli, {0, … , 푛} for the Binomial, and ℕfor both the geometric and
Poisson distributions (and ﬁnite sets for explicitly encoded distributions). For the ﬁrst three
parameterized distributions, multiplicity probabilities always stay rational if the parameters
are rational. This is not the case for the Poisson distribution.
While Deﬁnition 3.2 seems abstract, this level of detail in the encoding of probability distri-
butions allows us to rigorously discuss computational complexity without resorting to a very
narrow framework that only supports some predeﬁned distributions. Our model also com-
prises tuple-independent set PDBs: The traditional representation system can be recovered
from Deﬁnition 3.3 using only the Bernoulli distribution. Moreover, we remark that we can al-
ways represent facts that are present with probability 0, by just omitting them from the tables
(for example, fact 푅(2, 1) in Fig. 1).
Remark 3.5. In this work, we focus on TIRS’s where the values needed for computation (mo-
ments in Section 4 and probabilitiesin Section 5) are rational. An extension to support irrational
values is possible through models of real complexity [26, 5]. A principled treatment requires
a substantial amount of introductory overhead that would go beyond the scope of this paper,
and which we therefore leave for future work.
8

---

4. Expectations and Variances
Before computing the probabilities of answer counts, we discuss the computation of the ex-
pectation and the variance of the answer count. Recall that in PDBs without multiplicities, the
answer to a Boolean query (under set semantics) is either 0 (i. e., false) or 1 (i. e., true). That
is, the answer count is a {0, 1}-valued random variable there, meaning that its expectation co-
incides with the probability of the answer count being 1. Because of this correspondence, the
semantics of Boolean queries on (set) PDBs are sometimes also deﬁned in terms of the expected
value [32]. For bag PDBs, the situation is diﬀerent, and this equivalence no longer holds. Thus,
computing expectations, and computing answer count probabilities have to receive a separate
treatment. Formally, we discuss the following problems in this section:
Problem EXPECTATIONRep(푄)
Parameter:
A Boolean UCQ 푄.
Input:
A table 푇∈퐓Rep.
Output:
The expectation E (♯푇푄).
Problem VARIANCERep(푄)
Parameter:
A Boolean UCQ 푄.
Input:
A table 푇∈퐓Rep.
Output:
The variance Var (♯푇푄).
4.1. Expected Answer Count
We have pointed out above that computing expected answer counts for set PDBs and set se-
mantics is equivalent to computing the probability that the query returns true. There are con-
junctive queries, for example, 푄= ∃푥∃푦∶푅(푥) ∧푆(푥, 푦) ∧푇(푦), for which the latter problem
is ♯P-hard [16, 9]. Under a set semantics, disjunctions and existential quantiﬁers semantically
correspond to taking maximums instead of adding multiplicities. Under a bag semantics, we
are now able to exploit the linearity of expectation to easily compute expected values, which
was not possible under a set semantics.
Lemma 4.1. Let be a tuple-independent PDB and let 푄be a Boolean CQ, 푄
=
∃푥1 … ∃푥푚∶푅1(퐭1) ∧⋯∧푅푛(퐭푛). For every 퐚∈adom()푚, we let 퐹(퐚) denote the set of facts
appearing in 푄∗[퐱/퐚], and for every 푓∈퐹(퐚), we let 휈(푓, 퐚) denote the number of times 푓appears
in 푄∗[퐱/퐚]. Then
E (♯푄) =
∑
퐚∈adom()푚
∏
푓∈퐹(퐚)
E ((♯푓)
휈(푓,퐚)
).
(3)
Proof. By deﬁnition, we have
♯퐷푄=
∑
퐚∈adom(퐷)푚
♯퐷(푄∗[퐱/퐚]) =
∑
퐚∈adom()푚
♯퐷(푄∗[퐱/퐚])
for every individual instance 퐷of . The last equation above holds because, as 푄∗is assumed
to contain every quantiﬁed variable, ♯퐷(푄∗[퐱/퐚]) = 0 whenever the tuple 퐚contains an element
9

---

that is not in the active domain of 퐷. By linearity of expectation, we have
E (♯푄) =
∑
퐚∈adom()푚
E (♯(푄∗[퐱/퐚])).
Recall, that 푄∗[퐱/퐚] is a conjunction of facts 푅푖(퐭푖[퐱/퐚]).
Thus, ♯( ⋀푛
푖=1 푅푖(퐭푖[퐱/퐚])) =
∏푛
푖=1 ♯(푅푖(퐭푖[퐱/퐚])). Because is tuple-independent, any two facts in 퐹(퐚) are either equal,
or independent. Therefore,
E(
푛
∏
푖=1
♯푅푖(퐭푖[퐱/퐚])) = ∏
푓∈퐹(퐚)
E ((♯푓)휈(푓,퐚)),
as the expectation of a product of independent random variables is the product of their expec-
tations. Together, this yields the expression from (3).
By linearity, the expectation of a UCQ is the sum of the expectations of its CQs.
Lemma 4.2. Let be a PDB and let 푄= ⋁푁
푖=1 푄푖be a Boolean UCQ. Then we have E (♯푄) =
∑푁
푖=1 E (♯푄푖).
Given that we can compute the necessary moments of fact multiplicities eﬃciently, Lem-
mas 4.1 and 4.2 yield a polynomial time procedure to compute the expectation of a UCQ. The
order of moments we need is governed by the self-join width of the individual CQs.
Deﬁnition 4.3. A TIRS Rep has polynomially computable moments up to order 푘, if for all
휆∈ΛRep, we have ∑∞
푛=0 푛퓁⋅푃휆(푛) < ∞and the function ⟨휆⟩↦∑∞
푛=0 푛퓁⋅푃휆(푛) can be computed
in polynomial time in |⟨휆⟩| for all 퓁≤푘.
Before giving the main statement, let us revisit Example 3.4 for illustration.
Example 4.4. Let Rep be the TIRS from Example 3.4. The moments of 푋∼Bernoulli(푝) are
E(푋푘) = 푝for all 푘≥1. Direct calculation shows that for 푋∼Binomial(푛, 푝), the moment
E(푋푘) is given by a polynomial in 푛and 푝. In general, for most of the common distributions, one
of the following cases applies. Either, as above, a closed form expression for E(푋푘) is known,
or, the moments of 푋are characterized in terms of the moment generating function (mgf)
E(푒푡푋) of 푋, where 푡is a real-valued variable. In the latter case, E(푋푘) is obtained by taking
the 푘th derivative of the mgf and evaluating it at 푡= 0 [6, p. 62]. An inspection of the mgfs
of the geometric, and the Poisson distributions [6, p. 621f] reveals that their 푘th moments are
polynomials in their respective parametersas well. Together, Rep has polynomially computable
moments up to order 푘for all 푘∈ℕ+.
Proposition 4.5. Let 푄= ⋁푁
푖=1 푄푖be a Boolean UCQ, and let Rep be a TIRS with polynomially
computable moments up to order 푘, where 푘is the maximum self-join width among the 푄푖. Then
EXPECTATIONRep(♯푇푄) is computable in polynomial time.
Proof. We plug (3) into the formula from Lemma 4.2. This yields at most ≤푁⋅|adom(푇)|푚⋅푛
terms (where 푚is the maximal number of variables, and 푛the maximum number of atoms
among the CQs 푄1, … , 푄푁). These terms only contain moments of fact multiplicities of order
at most 푘.
10

---

We emphasize that the number 푘from Proposition 4.5, that dictates which moments we need
to be able to compute eﬃciently, comes from the ﬁxed query 푄and is therefore constant. More
precisely, it is given through the number of self-joins in the query. In particular, if all CQs in
푄are self-join free, it suﬃces to have eﬃcient access to the expectations of the multiplicities.
4.2. Variance of the Answer Count
With the ideas from the previous section, we can also compute the variance of query answers
in polynomial time. Naturally, to be able to calculate the variance eﬃciently, we need moments
of up to the double order in comparison to the computation of the expected value.
Proposition 4.6. Let 푄= ⋁푁
푖=1 푄푖be a Boolean UCQ, and let Rep be a TIRS with polynomially
computable moments up to order 2푘, where 푘is the maximum self-join width among the 푄푖. Then
VARIANCERep(♯푇푄) is computable in polynomial time.
As before, the main idea is to rewrite the variance in terms of the moments of fact multiplic-
ities. This can be achieved by exploiting tuple-independence and linearity of expectation. The
proof of Proposition 4.6 can be found in Appendix A.1.
Despite the fact that the variance of query answers may be of independent interest, it can
be also used to obtain bounds for the probability that the true value of ♯푇푄is close to its
expectation, using the Chebyshev inequality [25, Theorem 5.11]. This can be used to derive
bounds on Pr(♯푇푄≤푘), when the exact value is hard to compute.
Remark 4.7. Proposition 4.6 extends naturally to higher-order moments: If Rep is a TIRS with
polynomially computable moments up to order 퓁⋅푘and 푄= ⋁푁
푖=1 푄푖a Boolean UCQ where the
maximum self-join width among the 푄푖is 푘, then all centralized and all raw moments of order
up to 퓁of ♯푇푄are computable in polynomial time. The proof can be found in Appendix A.2.
5. Answer Count Probabilities
In this section, we treat the alternative version of probabilistic query evaluation in bag PDBs
using answer count probabilities rather than expected values. Formally, we discuss the follow-
ing problem.
Problem PQERep(푄, 푘)
Parameter:
A Boolean (U)CQ 푄, and 푘∈ℕ.
Input:
A table 푇∈퐓Rep.
Output:
The probability Pr(♯푇푄≤푘).
This problem amounts to evaluating the cumulative distribution function of the random
variable ♯푇푄at 푘. The properties of this problem bear a close resemblance to the set version of
probabilistic query evaluation, and we hence name this problem “PQE”.
11

---

Remark 5.1. Instead of asking for Pr(♯푇푄≤푘), we could similarly deﬁne the problem of evalu-
ating the probability that ♯푇푄is at least, or exactly equal to 푘. For Boolean CQs, and the class of
representation systems we discuss next, it will turn out that PQERep(푄, 푘) (in the version with
≤) is in polynomial time or ♯P-hard, independent of 푘. This directly implies the correspond-
ing statement for ≥.2 It then also follows that if PQERep(푄, 푘) is in polynomial time, then the
equality version can be solved in polynomial time. However, if PQERep(푄, 푘) is ♯P-hard for all
푘, we can only immediately infer that there exists 푘′ such that computing the probability of
exact answer count 푘′ is ♯P-hard. Indeed, consider a representation system Rep in which every
possible multiplicity is even. Then Pr(♯푇푄= 푘′) = 0 whenever 푘is odd, even if 푄is hard.
If 푘were presented as a unary encoded input, then each of the three versions of the problem
(“≤푘”, “≥푘”, “= 푘”) can be solved in polynomial time using oracle accesses to any of the other
versions. In their restricted setting, a corresponding discussion for the case of binary encoded
푘can be found in [29, Lemma 2].
Throughout this section, calculations involve the probabilities for the multiplicities of indi-
vidual facts. However, we want to discuss the complexity of PQERep(푄, 푘) independently of
the complexity, in 푘, of evaluating the multiplicity distributions. This motivates the following
deﬁnition, together with taking 푘to be a parameter, instead of it being part of the input.
Deﬁnition 5.2. A TIRS Rep is called a p-TIRS, if for all 푘∈ℕthere exists a polynomial 푝푘such
that for all 휆∈ΛRep, the function ⟨휆⟩↦푃휆(푘) can be evaluated in time (푝푘(|⟨휆⟩|)).
Deﬁnition 5.2 captures reasonable assumptions for “eﬃcient” TIRS’s with respect to
the evaluation of probabilities: If the requirement from the deﬁnition is not given, then
PQERep(∃푥∶푅(푥), 푘) can not be solved in polynomial time, even on the class of tables that only
contain a single annotated fact 푅(푎). This eﬀect only arises due to the presence of unwieldy
probability distributions in Rep.
As it turns out, solving PQERep(푄, 푘) proves to be far more intricatecompared to the problems
of the previous section. For our investigation, we concentrate on self-join free conjunctive
queries. While some simple results follow easily from the set semantics version of the problem,
the complexity theoretic discussions quickly become quite involved and require the application
of a set of interesting non-trivial techniques.
Our main result in this section is a dichotomy for Boolean CQs without self-joins. From now
on, we employ nomenclature (like hierarchical) that was introduced in [11, 12]. If 푄is a Boolean
self-join free CQ, then for every variable 푥, we let at(푥) denote the set of relation symbols 푅
such that 푄contains an 푅-atom that contains 푥. We call 푄hierarchical if for all distinct 푥and
푦, whenever at(푥) ∩at(푦) ≠∅, then at(푥) ⊆at(푦) or at(푦) ⊆at(푥). This deﬁnition essentially
provides the separation between easy and hard Boolean CQs without self-joins. In the bag
semantics setting, however, there exists an edge case where the problem gets easy just due to
the limited expressive power of the representation system. This edge case is governed only by
the probabilities for multiplicity zero that appear in the representations. We denote this set by
zeroPr(Rep), i.e.,
zeroPr(Rep) = {푝∈[0, 1]∶푃휆(0) = 푝for some 휆∈Λ(Rep)}.
2Except for 푘= 0, which is always trivial for ≥.
12

---

If a p-TIRS satisﬁes zeroPr(Rep) ⊆{0, 1}, then it can only represent bag PDBs whose deduplica-
tion is deterministic. In this case, as we will show in the next subsection, the problem becomes
easy even for arbitrary UCQs.3
Theorem 5.3. Let 푄be a Boolean CQ without self-joins and let Rep be a p-TIRS.
1. If 푄is hierarchical or zeroPr(Rep) ⊆{0, 1}, then PQERep(푄, 푘) is solvable in polynomial time
for all 푘∈ℕ.
2. Otherwise, PQE(푄, 푘) is ♯P-hard for all 푘∈ℕ.
Remark 5.4. It is natural to reconsider what happens, if 푘is treated as part of the input. With
a reduction similar to the proof of Proposition 5 in [29, Proposition 5], it is easy to identify
situations in which the corresponding problem is ♯P-hard for binary encoded 푘. For example,
this is already the case for the simple query ∃푥∶푅(푥),4 if the p-TIRS supports all fair coin ﬂips
whose outcomes are either a positive integer, or zero. A full proof can be found in Appendix B.1.
Hardness for this simple query does not conﬂict with the tractability results of [29, 14], because
they come with strong restrictions to the annotations. These restrictions are violated by the
above construction.
The remainder of this section is dedicated to establishing Theorem 5.3.
5.1. Tractable Cases
Let us ﬁrst discuss the case of p-TIRS’s Rep with zeroPr(Rep) ⊆{0, 1}. Here, PQERep(푄, 0) is triv-
ial, because the problem essentially reduces to deterministic query evaluation. The following
lemma generalizes this to all values of 푘.
Lemma 5.5. If Rep is a p-TIRS with zeroPr(Rep) ⊆{0, 1}, then PQERep(푄, 푘) is solvable in poly-
nomial time for all Boolean UCQs 푄, and all 푘∈ℕ.
Proof. Let Rep be any p-TIRS with zeroPr(Rep) ⊆{0, 1} and let 푄be any Boolean UCQ. If
푃휆(0) = 1 for all 휆∈ΛRep, then Rep can only represent the PDB where the empty instance has
probability 1. In this case, ♯푇푄= 0 almost surely, so Pr(♯푇푄≤푘) = 1 for all 푘∈ℕ.
In the general case, suppose 푄= ⋁푁
푖=1 푄푖such that 푄1, … , 푄푁are CQs. Let 퐴be the set
of functions 훼that map the variables of 푄into the active domain of the input 푇. We call 훼
good, if there exists 푖∈{1, … , 푁} such that all the facts emerging from the atoms of 푄푖by
replacing every variable 푥with 훼(푥) have positive multiplicity in 푇(almost surely). If there are
at least 푘+ 1 good 훼in 퐴, then ♯푇푄> 푘with probability 1 and, hence, we return 0 in this case.
Otherwise, when there are at most 푘good 훼, we restrict 푇to the set of all facts that can be
obtained from atoms of 푄by replacing all variables 푥with 훼(푥) (and retaining the parameters
휆). The resulting table 푇′ contains at most 푘times the number of atoms in 푄many facts, which
is independent of the number of facts in 푇. Hence, we can compute Pr(♯푇푄≤푘) = Pr(♯푇′푄≤푘)
in time polynomial in 푇by using brute-force.
3Using the same deﬁnition in the set semantics version of the problem would come down to restricting the input
tuple-independent PDB to only use 0 and 1 as marginal probabilities, so the problem would collapse to traditional
(non-probabilistic) query evaluation. Under a bag semantics, there still exist interesting examples in this class,
as the probability distribution over non-zero multiplicities is not restricted in any way.
4The proof in [29] uses the same query but for a Sum aggregation over attribute values in their setting.
13

---

From now on, we focus on the structure of queries again. The polynomial time procedure
for Boolean CQs without self-joins is reminiscent of the original algorithm for set semantics
as described in [11]. Therefore, we need to introduce some more vocabulary from their work.
A variable 푥is called maximal, if at(푦) ⊆at(푥) for all 푦with at(푥) ∩at(푦) ≠∅. With every CQ
푄we associate an undirected graph 퐺푄whose vertices are the variables appearing in 푄, and
where two variables 푥and 푦are adjacent if they appear in a common atom. Let 푉1, … , 푉푚be the
vertex sets of the connected components of 퐺푄. We can then write the quantiﬁer-free part 푄∗
of 푄as 푄∗= 푄∗
0 ∧⋀푚
푖=1 푄∗
푖where 푄∗
0 is the conjunction of the constant atoms of 푄and 푄∗
1, … , 푄∗
푚
are the conjunctions of atoms corresponding to the connected components 푉1, … , 푉푚. We call
푄∗
1, … , 푄∗
푚the connected components (short: components) of 푄.
Remark 5.6. If 푄is hierarchical, then every component of 푄contains a maximal variable.5
Moreover, if 푥is maximal in a component 푄∗
푖, then 푥appears in all atoms of 푄∗
푖.
Remark 5.7. For every CQ 푄with components 푄∗
1, … , 푄∗
푚, and constant atoms 푄∗
0, the answer
on every instance 퐷is given by the product of the answers of the queries 푄0, … , 푄푚, where
푄푖= ∃퐱푖∶푄∗
푖(and 푄0 = 푄∗
0), and 퐱푖are exactly the variables appearing in the component 푄∗
푖.
That is, ♯퐷푄= ♯퐷푄∗
0 ⋅∏푚
푖=1 ♯퐷(∃퐱푖∶푄∗
푖). This is shown in Appendix B.2. If convenient, we
therefore use 푄0 ∧푄1 ∧⋯∧푄푚as an alternative representation of 푄.
The main result of this subsection is the following.
Theorem 5.8. Let Rep be a p-TIRS, and let 푄be a hierarchical Boolean CQ without self-joins.
Then PQERep(푄, 푘) is solvable in polynomial time for each 푘∈ℕ.
Proof Sketch. The theorem is established by giving a polynomial time algorithm that computes,
and adds up the probabilities Pr (♯푇푄= 푘′) for all 푘′ ≤푘. The important observation is that (as
under set semantics) the components 푄푖of the query (and the conjunction 푄0 of the constant
atom) yield independent events, which follows since 푄is self-join free. In order to compute
the probability of ♯푇푄= 푘′, we can thus sum over all decompositions of 푘′ into a product
푘′ = 푘0 ⋅푘1 ⋅⋯⋅푘푚, and reduce the problem to the computations of Pr (♯푇푄푖= 푘푖). Although the
cases 푘= 0, and the conjunction 푄0 have to be treated slightly diﬀerent for technical reasons,
we can proceed recursively: every component contains a maximal variable, and setting this
variable to any constant, the component potentially breaks up into a smaller hierarchical, self-
join free CQ. Investigating the expressions shows that the total number of operations on the
probabilities of fact probabilities is polynomial in the size of 푇.
Remark 5.9. The full proof of Theorem 5.8 is contained in Appendix B.2. As pointed out, the
proof borrows main ideas from the algorithm for the probabilistic evaluation of hierarchical
Boolean self-join free CQs on tuple-independent PDBs with set semantics, as presented in [12,
p. 30:15] (originating in [9, 10]). The extension to multiplicities is essentially the same as in
[29, Lemma 1] or [14, Theorem 3], see our discussion of related work.
5This is true, since the sets at(푥) for the variables of any component have a pairwise non-empty intersection,
meaning that they are pairwise comparable with respect to ⊆.
14

---

5.2. Intractable Cases
We now show that in the remaining case (non-hierarchical queries and p-TIRS’s with
zeroPr(Rep) ∩(0, 1) ≠∅), the problems PQERep(푄, 푘) are all hard to solve.
Let 푄be a ﬁxed query and let PQEset(푄) denote the traditional set version of the probabilistic
query evaluation problem. That is, PQEset(푄) is the problem to compute the probability that
푄evaluates to true under set semantics, on input a tuple-independent set PDB. We recall that
the bag version PQERep(푄, 푘) of the problem (introduced at the beginning of the section) takes
the additional parameter 푘, and depends on the representation system Rep. Let us ﬁrst discuss
PQERep(푄, 푘) for 푘= 0. In this case, subject to very mild requirements on Rep, we can lift
♯P-hardness from the set version [12], even for the full class of UCQs.
Proposition 5.10. Let 푆⊆[0, 1] be ﬁnite and let Rep be a p-TIRS such that 1 −푝∈zeroPr(Rep)
for all 푝∈푆. Let 푄be a Boolean UCQ. If PQEset(푄) is ♯P-hard on tuple-independent (set) PDBs
with marginal probabilities in 푆, then PQERep(푄, 0) is ♯P-hard.
Proof. Let be an input to PQEset(푄) with fact set 퐹where all marginal probabilities are in 푆,
given by the list of all facts 푓with their marginal probability 푝푓. For all 푝∈푆, pick 휆푝∈Λ
such that 푃휆(0) = 1 −푝. Let 푇= ⋃푓∈퐹
{
(푓, ⟨휆푝푓⟩)
}
, and let 훿be the function that maps every
instance 퐷of 푇to its deduplication 퐷′ (which is an instance of ). Then, by the choice of the
parameters, we have Pr퐷∼J푇K(훿(퐷) = 퐷′) = Pr({퐷′}) for all 퐷′. Moreover, ♯퐷푄> 0 if and
only if 훿(퐷) ⊧푄. Thus,
Pr
퐷∼J푇K(♯퐷푄> 0) =
Pr
퐷∼J푇K(훿(퐷) ⊧푄) = Pr
퐷′∼(퐷′ ⊧푄).
Therefore, PQEset(푄) over tuple-independent PDBs with marginal probabilities from 푆can be
solved by solving PQERep(푄, 0).
Remark 5.11. This is similar to the approach taken in [29, Theorem 2] where the authors estab-
lish a dichotomy for Count aggregations over block-independent disjoint set PDBs. They do
not give the proof details for the hardness part of Count, but it is to be assumed that the main
idea is the same.
Remarkably, [23, Theorem 2.2] show that Boolean UCQs for which PQEset(푄) is ♯P-hard are
already hard when the marginal probabilities are restricted to 푆= {푐, 1}, for any rational 푐∈
(0, 1). Hence, PQERep(푄, 0) is also ♯P-hard on these queries, as soon as {0, 1 −푐} ⊆zeroPr(Rep).
Our goal is now to show that if Rep is a p-TIRS, then for any Boolean CQ 푄without self-joins,
♯P-hardness of PQERep(푄, 0) transfers to PQERep(푄, 푘) for all 푘> 0.
Theorem 5.12. Let Rep be a p-TIRS and let 푄be a Boolean self-join free CQ. Then, if PQERep(푄, 0)
is ♯P-hard, PQERep(푄, 푘) is ♯P-hard for each 푘∈ℕ.
Proving Theorem 5.12 is quite involved, and is split over various lemmas in the remainder of
this subsection. Let Rep be any ﬁxed p-TIRS and let 푄be a Boolean CQ without self-joins. We
demonstrate the theorem by presenting an algorithm that solves PQERep(푄, 0) in polynomial
time, when given an oracle for PQERep(푄, 푘) for any positive 푘. In Appendix C, we illustrate
this procedure on a concrete example.
15

---

Clearly, we cannot simply infer Pr(♯푇푄= 0) from Pr(♯푇푄≤푘). Naively, we would want to
shift the answer count of 푄by 푘, so that the problem could be answered immediately. However,
this is not possible in general. Our way out is to use the oracle several times, on manipulated
inputs. Since the algorithms we describe are conﬁned to the p-TIRS Rep, we are severely re-
stricted in the ﬂexibility of manipulating the probabilities of fact multiplicities: unless further
assumptions are made, we can only work with the annotations that are already present in the
input 푇to the problem. We may, however, also drop entries from 푇or introduce copies of facts
using new domain elements.
For a given table 푇and a ﬁxed single-component query 푄, we exploit this idea in Algorithm 1
in order to construct a new table 푇(푚), called the inﬂation of 푇of order 푚. It has the property that
♯푇(푚)푄is the sum of answer counts of 푄on 푚independent copies of 푇. A small example for the
result of running Algorithm 1 for 푚= 2 is shown in Figure 3. We will later use oracle answers
on several inﬂations in order to interpolate Pr(♯푇푄푖= 0) per component 푄푖individually, and
then combine the results together.
Algorithm 1 inflate푄(푇, 푚)
Parameter: Boolean self-join free CQ 푄with a single component and no constant atoms
Input: 푇∈퐓Rep, 푚∈ℕ
Output: Inﬂation of order 푚of 푇: 푇(푚) = ⋃푚
푖=1 푇푚,푖∈퐓Rep such that
(O1) for all 푖≠푗we have 푇푚,푖∩푇푚,푗= ∅,
(O2) for all 푖= 1, … , 푚we have ♯푇푚,푖푄∼♯푇푄i.i.d., and
(O3) ♯푇(푚)푄= ∑푚
푖=1 ♯푇푚,푖푄.
1: Initialize 푇푚,1, … , 푇푚,푚to be empty.
2: For each domain element 푎, introduce new pairwise distinct elements 푎(1), … , 푎(푚).
3: for all relation symbols 푅appearing in 푄do
4:
Let 푅(푡1, … , 푡푟) be the unique atom in 푄with relation symbol 푅.
5:
for all pairs of the form (푅(푎1, … , 푎푟), ⟨휆⟩) ∈푇do
6:
for all 푖= 1, … , 푚do
7:
Add (푅(푎푖,1, … , 푎푖,푘), ⟨휆⟩) to 푇푚,푖where 푎푖,푗=
{
푎(푖)
푗, if 푡푗is a variable;
푎푗, if 푡푗is a constant.
8:
end for
9:
end for
10: end for
11: return 푇(푚) ∶= ⋃푚
푖=1 푇푚,푖
Lemma 5.13. For every ﬁxed Boolean self-join free CQ 푄with a single component and no constant
atoms, Algorithm 1 runs in time (|푇|⋅푚), and satisﬁes the output conditions (O1), (O2) and (O3).
The proof of Lemma 5.13 can be found in Appendix B.3. The assumption that the input to
Algorithm 1 is self-join free with just a single connected component and no constant atoms is
essential to establish (O1) and (O3), because it eliminates any potential co-dependencies among
the individual tables 푇푚,1, … , 푇푚,푚we create. The following example shows that this assumption
is inevitable, as the conditions of Lemma 5.13 can not be established in general.
16

---

Table 푇
Relation 푅
Parameter
푅(푎, 푎, 푎)
(Binomial, 10, 1/3)
푅(푎, 푏, 푐)
(Geometric, 1/2)
Table 푇(2)
Relation 푅
Parameter
푅(푎(1), 푎(1), 푎)
(Binomial, 10, 1/3)
푅(푎(1), 푏(1), 푐)
(Geometric, 1/2)
푅(푎(2), 푎(2), 푎)
(Binomial, 10, 1/3)
푅(푎(2), 푏(2), 푐)
(Geometric, 1/2)
Figure 3: Example of a table 푇and its inﬂation 푇(2) for the query ∃푥, 푦∶푅(푥, 푦, 푎).
Example 5.14. Let Rep be a TIRS with ΛRep = {휆} such that 푃휆(2) = 푃휆(3) = 1
2 (and 푃휆(푘) = 0
for all 푘∉{2, 3}). Consider 푄= ∃푥∃푦∶푅(푥) ∧푆(푦), and 푇= ((푅(1), ⟨휆⟩), (푆(1), ⟨휆⟩)) ∈퐓Rep.
Note that 푄has two components and, hence, does not satisfy the assumptions of Lemma 5.13.
Then ♯푇푄takes the values 4, 6 and 9, with probabilities 1
4, 1
2, 1
4. Thus, if 푋, 푌∼♯푇푄i.i.d., then
푋+ 푌is 13 with probability 1
16 + 1
16 = 1
8. However, for every 푇′ ∈퐓Rep, the random variable
♯푇′푄almost surely takes composite numbers, as it is equal to the sum of all multiplicities of
푅-facts, times the sum of all multiplicities of 푆-facts, both of these numbers being either 0 or
at least 2. Thus, there exists no 푇′ ∈퐓Rep such that ♯푇′푄= 푋+ 푌.
For this reason, our main algorithm will call Algorithm 1 independently, for each connected
component 푄푖of 푄. Then, Algorithm 1 does not inﬂate the whole table 푇, but only the part 푇푖
corresponding to 푄푖. If 푄= 푄′ ∧푄푖and we denote ♯푇푖푄푖by 푋and ♯푇⧵푇푖푄′ by 푌, then replacing
푇푖in 푇with its inﬂation of order 푛yields a new table with answer count (♯푇⧵푇푖푄′) ⋅(♯푇(푛)
푖푄푖) =
푌⋅∑푛
푖=1 푋푖, where 푋1, … , 푋푛∼푋i.i.d. Before further describing the reduction, we ﬁrst explore
some algebraic properties of the above situation in general.
Lemma 5.15. Let 푋and 푌be independent random variables with values in ℕand let 푘∈ℕ.
Suppose 푋1, 푋2, … are i.i.d. random variables with 푋1 ∼푋. Let 푝0 ∶= Pr(푋= 0) and 푞0 ∶=
Pr(푌= 0). Then, there exist 푧1, … , 푧푘≥0 such that for all 푛∈ℕwe have
Pr (푌⋅
푛
∑
푖=1
푋푖≤푘) = 푞0 + (1 −푞0) ⋅푝푛
0 +
푘
∑
푗=1 (
푛
푗) ⋅푝푛−푗
0
⋅푧푗.
This is demonstrated in Appendix B.3. We now describe how 푝0 = Pr(푋= 0) can be recov-
ered from the values of Pr (푌⋅∑푛
푖=1 푋푖≤푘) and 푞0 = Pr(푌= 0) whenever 푞0 < 1 and 푝0 > 0.
With the values 푧1, … , 푧푛from Lemma 5.15, and 푧0 ∶= 1 −푞0, we deﬁne a function
푔(푛) ∶= Pr (푌⋅
푛
∑
푖=1
푋푖≤푘) −푞0 =
푘
∑
푗=0 (
푛
푗) ⋅푝푛−푗
0
⋅푧푗.
(4)
Now, for 푚∈ℕand 푥= 0, 1 … , 푚, we deﬁne
ℎ푚(푥) ∶= 푔(푚+ 푥) ⋅푔(푚−푥) =
푘
∑
푗1,푗2=0 (
푚+ 푥
푗1
) ⋅(
푚−푥
푗2
) ⋅푝2푚−푗1−푗2
0
⋅푧푗1 ⋅푧푗2.
(5)
17

---

Then, for every ﬁxed 푚, ℎ푚is a polynomial in 푥with domain {0, … , 푚}. As it will turn out,
the leading coeﬃcient lc(ℎ푚) of ℎ푚can be used to recover the value of 푝0 as follows: Let 푗max
be the maximum 푗such that 푧푗≠0. Since for ﬁxed 푚, both (
푚+푥
푗) and (
푚−푥
푗) are polynomials
of degree 푗in 푥, the degree of ℎ푚is 2푗max and its leading coeﬃcient is
lc(ℎ푚) = (−1)푗max ⋅(푗max!)−2 ⋅푝2푚−2푗max
0
⋅푧2
푗max,
which yields
푝0 =
√
lc(ℎ푚+1)
lc(ℎ푚) .
(6)
Thus, it suﬃces to determine lc(ℎ푚) and lc(ℎ푚+1). However, we neither know 푗max, nor 푧푗max,
and we only have access to the values of ℎ푚and ℎ푚+1. To ﬁnd the leading coeﬃcients anyway,
we employ the method of ﬁnite diﬀerences, a standard tool from polynomial interpolation [22,
chapter 4]. For this, we use the diﬀerence operator Δ that is deﬁned as Δ푓(푥) ∶= 푓(푥+1)−푓(푥)
for all functions 푓. When 푓is a (non-zero) polynomial of degree 푛, the diﬀerence operator
reduces its degree by one and its leading coeﬃcient is multiplied by 푛. Therefore, after taking
diﬀerences 푛times, starting from subsequent values of a polynomial 푓, we are left with the
constant function Δ푛푓= 푛! ⋅lc(푓) ≠0. In particular, taking diﬀerences more than 푛times
yields the zero function. Hence, we can determine lc(푓) by ﬁnding the largest 퓁for which
Δ퓁푓(0) ≠0.
Algorithm 2 solveComponent푄(푇, 푖)
Parameter: Boolean self-join free CQ 푄= 푄0 ∧⋀푟
푖=1 푄푖with connected components 푄1 … , 푄푟.
Oracle Access: Oracle for PQERep(푄, 푘) that, on input̃ 푇, returns Pr(♯̃푇푄≤푘)
Input: 푇∈퐓Rep, 푖∈{1, … , 푟}
Output: Pr(♯푇푖푄푖= 0)
1: if 푃휆(0) = 1 for all 휆∈Λ then return 0 end if
2: Fix 휆with 푃휆(0) < 1 and suppose 푄= 푄′ ∧푄푖(cf. Remark 5.7).
3: if 푄′ is empty then
4:
Set 푞0 ∶= 0 and 푔(0) ∶= 1.
5: else
6:
Let 푇′ ∈퐓Rep be the canonical database for 푄′, with 휆푓∶= 휆for all facts 푓in 푇′.
7:
Calculate 푞0 ∶= Pr (♯푇′푄′ = 0) and set 푔(0) ∶= 1 −푞0.
8: end if
9: for 푛= 1, 2, … , 4푘+ 1 do
10:
Set 푇(푛)
푖
∶= inflate푄푖(푇푖, 푛).
11:
Set 푔(푛) ∶= Pr (♯푇′∪푇(푛)
푖푄≤푘) −푞0, using the oracle.
12: end for
13: if 푔(푘+ 1) = 0 then return 0 end if
14: for 푥= 0, 1, … , 2푘and 푚= 2푘, 2푘+ 1 do ℎ푚(푥) ∶= 푔(푚+ 푥) ⋅푔(푚−푥) end for
15: Initialize 퓁∶= 2푘.
16: while Δ퓁ℎ2푘(0) = 0 do 퓁∶= 퓁−1 end while
17: return
√
Δ퓁ℎ2푘+1(0)/Δ퓁ℎ2푘(0)
The full procedure that uses the above steps to calculate 푝0 yields Algorithm 2. Recall that it
focuses on a single connected component. To ensure easy access to the value of 푞0, we utilize a
18

---

table that encodes the canonical database of the remainder of the query.6 Note that 푘is always
treated as a ﬁxed constant, and our goal is to reduce PQERep(푄, 0) to PQERep(푄, 푘).
Lemma 5.16. Algorithm 2 runs in polynomial time and yields the correct result.
Proof. With the notation introduced in the algorithm, we let 푌= ♯푇′푄′ (or 푌= 1 if 푄′ is empty)
and 푋= ♯푇푄푖= ♯푇푖푄푖. Then, 푞0 = Pr(푌= 0) as in Lemma 5.15 and the aim of the algorithm is
to return 푝0.
First, line 1 covers the edge case that Rep can only represent the empty database instance.
In all other cases, we ﬁx 휆with 푃휆(0) > 0. As 푞0 = 1 −(1 −푃휆(0))푡where 푡is the number
of atoms of 푄′, we have 푞0 < 1. From Lemma 5.13, we see that ♯푇′∪푇(푛)
푖푄= 푌⋅∑푛
푖=1 푋푖, so we
are in the situation of Lemma 5.15. Hence, 푔and ℎ푚are as in (4) and (5). Now, as 푔(푘+ 1) =
푝0 ⋅∑푘
푗=0 (
푛
푗) ⋅푝푘−푗
0
⋅푧푗with 푧0 = 1 −푞0 > 0, we ﬁnd that 푝0 is zero if and only if 푔(푘+ 1) is
zero. This is checked in line 13. Finally, the paragraphs following Lemma 5.15 apply, and we
determine the degree of ℎ2푘using the method of ﬁnite diﬀerences by setting 퓁to the maximum
possible degree and decreasing it step-by-step as long as Δ퓁ℎ2푘(0) = 0 in lines 15 and 16. Then,
we have 퓁= 2푗max and return
√
Δ퓁ℎ2푘+1(0)
Δ퓁ℎ2푘(0)
=
√
퓁! lc(ℎ푚+1)
퓁! lc(ℎ푚)
(6)= 푝0.
Concerning the runtime, since Rep is a p-TIRS, all answers of the oracle calls are of polyno-
mial size in the input. Since 푘is ﬁxed, the algorithm performs a constant number of computa-
tion steps and each term in the calculations is either independent of the input or of polynomial
size, yielding a polynomial runtime.
Proof of Theorem 5.12. Let 푘> 0 and suppose that we have an oracle for PQERep(푄, 푘). Let
푄= 푄0 ∧⋀푚
푖=1 푄푖be the partition of 푄into components, with 푄0 being the conjunction of the
constant atoms. Then the ♯푇푄푖are independent and ♯푇푄= ♯푇푄0 ⋅∏푚
푖=1 ♯푇푄푖. Therefore,
Pr (♯푇푄= 0) = 1 −Pr(♯푇푄0 ≠0) ⋅
푚
∏
푖=1
(1 −Pr (♯푇푄푖= 0)).
As Pr(♯푇푄0 ≠0) is easy to compute and Algorithm 2 computes Pr (♯푇푄푖= 0) for 푖= 1, … , 푘with
oracle calls for PQERep(푄, 푘), this yields a polynomial time Turing-reduction from PQERep(푄, 0)
to PQERep(푄, 푘).
With the results from the previous subsections, this completes the proof of Theorem 5.3.
Proof of Theorem 5.3. For p-TIRS’s with zeroPr(Rep)
⊆
{0, 1}, the statement is given by
Lemma 5.5. By Theorem 5.8, PQERep(푄, 푘) is solvable in polynomial time for hierarchical
Boolean CQs without self-joins. For the case of 푄being non-hierarchical (and zeroPr(Rep) ∩
(0, 1) ≠∅), let 푝∈(0, 1) such that 푝∈zeroPr(Rep). By [2, Theorem 3.4], the set version
PQEset(푄) is already hard on the class of tuple-independent set PDBs where all probabilities
are equal to 1 −푝. It follows from Proposition 5.10 that PQERep(푄, 0) is ♯P-hard. By Theo-
rem 5.12, so is PQERep(푄, 푘) for all 푘∈ℕ+.
6The canonical database belonging to a self-join free CQ is the instance containing the atoms appearing in the
query, with all variables being treated as constants.
19

---

6. Conclusion
We extend the understanding of probabilistic query evaluation towards a model of tuple-
independent bag PDBs with potentially inﬁnite multiplicity supports. Our investigations cover
the two key manifestations of the problem: computing expectations, and computing the prob-
ability of answer counts. While these problems are equivalent for set semantics, their behavior
under bag semantics is disparate. On the one hand, we show that expectations, and more gen-
erally, moments are easy to compute, even for Boolean UCQs. Computing the probability of
answer counts not exceeding some constant 푘is a more diﬃcult problem, and we obtain a di-
chotomy between polynomial time and ♯P-hardness that aligns with prior work [12, 29, 14, 2].
There are several open questions of interest, like the complexity of computing answer count
probabilities beyond self-join free CQs; the properties of the problem on bag versions of other
well-representable classes of PDBs; or a reﬁned analysis of the complexity in terms of 푘as
part of the input or when accessing certain classes of multiplicity distributions. Moreover,
some practically relevant multiplicity distributions like the Poisson distribution naturally yield
irrational probabilities, which are not covered by our results on answer count probabilities.
Acknowledgments
The work of Martin Grohe and Christoph Standke has been funded by the German Research
Foundation (DFG) under grants GR 1492/16-1 and GRK 2236 (UnRAVeL).
References
[1] Antoine Amarilli, Pierre Bourhis, and Pierre Senellart. Tractable Lineages on Treelike
Instances: Limits and Extensions. In Proceedings of the 35th ACM SIGMOD-SIGACT-SIGAI
Symposium on Principles of Database Systems (PODS 2016), pages 355—-370. Association
for Computing Machinery, 2016. doi:10.1145/2902251.2902301.
[2] Antoine Amarilli and Benny Kimelfeld. Uniform Reliability of Self-Join-Free Conjunctive
Queries, 2021. Extended version of [3]. arXiv:https://arxiv.org/abs/1908.07093v6.
[3] Antoine Amarilli and Benny Kimelfeld. Uniform Reliability of Self-Join-Free Conjunc-
tive Queries. In 24th International Conference on Database Theory (ICDT 2021), volume
186 of Leibniz International Proceedings in Informatics (LIPIcs), pages 17:1–17:17. Schloss
Dagstuhl – Leibniz-Zentrum für Informatik, 2021. doi:10.4230/LIPIcs.ICDT.2021.17.
[4] Antoine Amarilli and İsmail İlkan Ceylan.
A Dichotomy for Homomorphism-
Closed Queries on Probabilistic Graphs.
In 23rd International Conference on Database
Theory (ICDT 2020), volume 155 of Leibniz International Proceedings in Informat-
ics (LIPIcs), pages 5:1–5:20, Dagstuhl, Germany, 2020. Schloss Dagstuhl–Leibniz-
Zentrum für Informatik.
URL: https://drops.dagstuhl.de/opus/volltexte/2020/11929,
doi:10.4230/LIPIcs.ICDT.2020.5.
[5] Mark Braverman and Stephen Cook. Computing over the Reals: Foundations for Scientiﬁc
Computing. Notices of the AMS, 53(3):318–329, 2006.
20

---

[6] George Casella and Roger L. Berger. Statistical Inference.
Thomson Learning, Paciﬁc
Grove, CA, USA, 2nd edition, 2002.
[7] Surajit Chaudhuri and Moshe Y. Vardi.
Optimization of Real Conjunctive Queries.
In Proceedings of the Twelfth ACM SIGACT-SIGMOD-SIGART Symposium on Prin-
ciples of Database Systems (PODS 1993), pages 59–70. ACM Press, 1993.
URL:
http://portal.acm.org/citation.cfm?doid=153850.153856, doi:10.1145/153850.153856.
[8] Sara Cohen. Equivalence of Queries That Are Sensitive to Multiplicities. The VLDB Jour-
nal, 18(3):765–785, 2009. doi:10.1007/s00778-008-0122-1.
[9] Nilesh Dalvi and Dan Suciu. Eﬃcient Query Evaluation on Probabilistic Databases. In
Proceedings of the Thirtieth International Conference on Very Large Data Bases (VLDB 2004),
volume 30, pages 864–875. VLDB Endowment, 2004.
[10] Nilesh Dalvi and Dan Suciu. Eﬃcient Query Evaluation on Probabilistic Databases. The
VLDB Journal, 16(4):523–544, 2007. doi:10.1007/s00778-006-0004-3.
[11] Nilesh Dalvi and Dan Suciu. The Dichotomy of Conjunctive Queries on Probabilistic
Structures. In Proceedings of the Twenty-Sixth ACM SIGMOD-SIGACT-SIGART Symposium
on Principles of Database Systems (PODS 2007), pages 293–302, New York, NY, USA, 2007.
Association for Computing Machinery. doi:10.1145/1265530.1265571.
[12] Nilesh Dalvi and Dan Suciu. The Dichotomy of Probabilistic Inference for Unions of Con-
junctive Queries. Journal of the ACM, 59(6):1 – 87, 2012. doi:10.1145/2395116.2395119.
[13] Su Feng, Boris Glavic, Aaron Huber, Oliver Kennedy, and Atri Rudra.
Com-
puting Expected Multiplicities for Bag-TIDBs with Bounded Multiplicities, 2022.
arXiv:https://arxiv.org/abs/2204.02758v3.
[14] Robert
Fink,
Larisa
Han,
and
Dan
Olteanu.
Aggregation
in
probabilis-
tic
databases
via
knowledge
compilation.
Proc.
VLDB
Endow.,
5(5):490–
501,
2012.
URL:
http://vldb.org/pvldb/vol5/p490_robertﬁnk_vldb2012.pdf,
doi:10.14778/2140436.2140445.
[15] Robert Fink and Dan Olteanu.
Dichotomies for Queries with Negation in Prob-
abilistic Databases.
ACM Transactions on Database Systems, 41(1):4:1–4:47, 2016.
doi:10.1145/2877203.
[16] Erich Grädel, Yuri Gurevich, and Colin Hirsch.
The Complexity of Query Relia-
bility.
In Proceedings of the Seventeenth ACM SIGACT-SIGMOD-SIGART Symposium
on Principles of Database Systems (PODS 1998), pages 227–234. ACM Press, 1998.
doi:10.1145/275487.295124.
[17] Todd J. Green, Grigoris Karvounarakis, and Val Tannen. Provenance Semirings. In Pro-
ceedings of the Twenty-Sixth ACM SIGMOD-SIGACT-SIGART Symposium on Principles of
Database Systems (PODS 2007), pages 31–40. Association for Computing Machinery, 2007.
doi:10.1145/1265530.1265535.
21

---

[18] Todd J. Green and Val Tannen. Models for Incomplete and Probabilistic Information. In
Current Trends in Database Technology – EDBT 2006, pages 278–296, Berlin, Germany,
2006. Springer-Verlag Berlin Heidelbeg. doi:10.1007/11896548_24.
[19] Martin Grohe and Peter Lindner. Independence in Inﬁnite Probabilistic Databases. J.
ACM, 69(5):37:1–37:42, 2022. doi:10.1145/3549525.
[20] Martin Grohe and Peter Lindner.
Inﬁnite Probabilistic Databases.
Logical Methods
in Computer Science, Volume 18, Issue 1, 2022. URL: https://lmcs.episciences.org/9137,
doi:10.46298/lmcs-18(1:34)2022.
[21] Erich Grädel and Val Tannen. Semiring Provenance for First-Order Model Checking, 2017.
arXiv:1712.01980v1.
[22] Francis Begnaud Hildebrand. Introduction to Numerical Analysis. Courier Corporation,
1987.
[23] Batya Kenig and Dan Suciu. A Dichotomy for the Generalized Model Counting Problem
for Unions of Conjunctive Queries. In Proceedings of the 40th ACM SIGMOD-SIGACT-SIGAI
Symposium on Principles of Database Systems (PODS 2021), pages 312–324, New York, NY,
USA, 2021. Association for Computing Machinery. doi:10.1145/3452021.3458313.
[24] Oliver Kennedy and Christoph Koch. PIP: A database system for great and small expecta-
tions. In 2010 IEEE 26th International Conference on Data Engineering (ICDE 2010), March
1–6, 2010, Long Beach, California, USA, pages 157–168, Los Alamitos, CA, USA, 2010. IEEE
Computer Society. doi:10.1109/ICDE.2010.5447879.
[25] Achim Klenke. Probability Theory: A Comprehensive Course. Universitext. Springer-Verlag
London, London, UK, 2nd edition, 2014. Translation from the German language edition.
doi:10.1007/978-1-4471-5361-0.
[26] Ker-I Ko. Complexity Theory of Real Functions. Progress in Theoretical Computer Science.
Birkhäuser Boston, 1991. doi:10.1007/978-1-4684-6802-1.
[27] Dan Olteanu and Jiewen Huang.
Using OBDDs for Eﬃcient Query Evaluation
on Probabilistic Databases.
In SUM 2008:
Scalable Uncertainty Management, Lec-
ture Notes in Computer Science, pages 326–340, Berlin, Heidelberg, 2008. Springer.
doi:10.1007/978-3-540-87993-0_26.
[28] Dan Olteanu and Jiewen Huang.
Secondary-Storage Conﬁdence Computation for
Conjunctive Queries with Inequalities.
In Proceedings of the 2009 ACM SIGMOD In-
ternational Conference on Management of data, pages 389–402. ACM, 2009.
URL:
https://dl.acm.org/doi/10.1145/1559845.1559887, doi:10.1145/1559845.1559887.
[29] Christopher Ré and Dan Suciu.
The Trichotomy Of HAVING Queries On
A
Probabilistic
Database.
The
VLDB
Journal,
18(5):1091–1116,
Jul
2009.
doi:10.1007/s00778-009-0151-4.
22

---

[30] Dan Suciu. Probabilistic Databases for All. In Proceedings of the 39th ACM SIGMOD-
SIGACT-SIGAI Symposium on Principles of Database Systems, pages 19–31. ACM, 2020.
URL: https://dl.acm.org/doi/10.1145/3375395.3389129, doi:10.1145/3375395.3389129.
[31] Dan Suciu, Dan Olteanu, Christopher Ré, and Christoph Koch. Probabilistic Databases,
volume 3.2 of Synthesis Lectures on Data Management. Morgan & Claypool, San Rafael,
CA, USA, 2011. Lecture ♯16. doi:10.2200/S00362ED1V01Y201105DTM016.
[32] Guy Van den Broeck and Dan Suciu. Query Processing on Probabilistic Data: A Survey.
Foundations and Trends® in Databases, 7(3–4):197–341, 2017. doi:10.1561/1900000052.
[33] Moshe Y. Vardi. The Complexity of Relational Query Languages. In Proceedings of the
Fourteenth Annual ACM Symposium on Theory of Computing (STOC 1982), pages 137–146,
New York, NY, USA, 1982. ACM Press. doi:10.1145/800070.802186.
23

---

A. Proofs Omited from Section 4
A.1. Computing the Variance
In this part of the appendix, we prove Proposition 4.6.
Proposition 4.6. Let 푄= ⋁푁
푖=1 푄푖be a Boolean UCQ, and let Rep be a TIRS with polynomially
computable moments up to order 2푘, where 푘is the maximum self-join width among the 푄푖. Then
VARIANCERep(♯푇푄) is computable in polynomial time.
Recall for (possibly correlated) random variables 푋1, … , 푋푛, the variance of their sum is equal
to
Var (
푛
∑
푖=1
푋푖) =
푛
∑
푖=1
Var(푋푖) + ∑
푖1≠푖2
Cov(푋푖1, 푋푖2)
=
푛
∑
푖=1 ( E(푋2
푖) −E(푋푖)2
) + ∑
푖1≠푖2 ( E (푋푖1푋푖2) −E (푋푖1) E (푋푖2)),
(7)
where the covariance part vanishes if the random variables are independent [25, Theorem 5.7].
Later on, we will need to apply the above for the case where the random variables 푋푖are
products of other random variables. We note that the well-known formula Var(푋) = E(푋2) −
E(푋)2 generalizes to products of independent random variables as follows:
Var (
푛
∏
푖=1
푋푖) = E ((
푛
∏
푖=1
푋푖)
2
) −E (
푛
∏
푖=1
푋푖)
2
=
푛
∏
푖=1
E (푋2
푖) −
푛
∏
푖=1
E (푋푖)
2.
(8)
We continue with an observation concerning the expected value of a product of CQ answers.
Lemma A.1. Let be a tuple-independent PDB, and suppose
푄1 = ∃푥1 … ∃푥푚1 ∶푅1(퐭1) ∧⋯∧푅푛1(퐭푛1)
and
푄2 = ∃푦1 … ∃푦푚2 ∶푆1(퐮1) ∧⋯∧푆푛2(퐮푛2)
are two Boolean CQs. For all 퐚∈adom()푚1 and 퐛∈adom()푚2, we let 퐹1(퐚) and 퐹2(퐛) be the sets
of facts appearing in 푄∗
1[퐱/퐚] and 푄∗
2[퐲/퐛], respectively. Moreover, for every 푓∈퐹1(퐚)∪퐹2(퐛), we
let 휈1(푓, 퐚) and 휈2(푓, 퐛) denote the number of times 푓appears in 푄∗
1[퐱/퐚], and in 푄∗
2[퐲/퐛]. Then
E (♯푄1 ⋅♯푄2) = ∑
퐚,퐛
∏
푓∈퐹1(퐚)∪퐹2(퐛)
E ((♯푓)
휈1(푓,퐚)+휈2(푓,퐛)
),
where 퐚∈adom()푚1 and 퐛∈adom()푚2.
Proof. Recall the observation from the equation at the beginning of the proof of Lemma 4.1.
Unfolding the deﬁnition of ♯, we get
E (♯푄1 ⋅♯푄2)
= E ((
∑
퐚∈adom()푚1
∏
푓∈퐹1(퐚)
(♯푓)
휈1(푓,퐚)
) ⋅(
∑
퐛∈adom()푚2
∏
푓∈퐹2(퐛)
(♯푓)
휈2(푓,퐛)
)).
24

---

Expanding the product, this is equal to
E ( ∑
퐚,퐛
∏
푓∈퐹1(퐚)∪퐹2(퐛)
(♯푓)
휈1(푓,퐚)+휈2(푓,퐛)
).
The claim then follows from the linearity of expectation, and using that the terms ♯푓are
independent for diﬀerent 푓.
For obtaining a polynomial time algorithm for the variance, we proceed similar to the previ-
ous section. In particular, we start with expressing the variance of a CQ in terms of moments
of fact multiplicities.
Lemma A.2. Let be a tuple-independent PDB and let 푄be a Boolean CQ, 푄
=
∃푥1 … ∃푥푚∶푅1(퐭1) ∧⋯∧푅푛(퐭푛). For all facts 푓, and all 퐚∈adom()푚, we let 푋푓,퐚denote the
random variable (♯푓)휈(푓,퐚). Then
Var (♯푄) = ∑
퐚
∏
푓∈퐹(퐚)
E (푋2
푓,퐚) −∏
푓∈퐹(퐚)
E (푋푓,퐚)
2
+ ∑
퐚1≠퐚2 (
∏
푓∈퐹(퐚1)∪퐹(퐚2)
E (푋푓,퐚1푋푓,퐚2) −∏
푓∈퐹(퐚1)
E (푋푓,퐚1) ∏
푓∈퐹(퐚2)
E (푋푓,퐚2)).
(9)
Proof. This is obtained by the direct calculation, starting from (7). For the left part of (7) (the
individual variances), we use (8) and the observations from the proof of Lemma 4.1. For the
right part of (7) (the covariances), we use Lemma A.1 and Lemma 4.1.
Another direct application of (7) yields the following.
Lemma A.3. Let be a PDB and let 푄= ⋁푁
푖=1 푄푖be a Boolean UCQ. Then
Var (♯푄) =
푁
∑
푖=1
Var(♯푄푖) + ∑
푖1≠푖2 ( E (♯푄푖1 ⋅♯푄푖2) −E (♯푄푖1) E (♯푄푖2))
(10)
Again, if we can compute the necessary moments of fact multiplicities eﬃciently, then
Lemma A.3 and Lemma 4.1 yield a polynomial time algorithm to compute the variance of a
UCQ.
Proof of Proposition 4.6. Plugging (9) into (10), we obtain a formula with a polynomial number
of terms in the input size. The individual terms are moments of fact multiplicities, possibly up
to order at most 2푘.
A.2. Higher-Order Raw and Central Moments
The ideas for computing the expectation and variance of query answer counts can be extended
to higher raw and central moments as follows.
25

---

Lemma A.4. Let be a tuple-independent PDB and let 푄1, … , 푄퓁be Boolean CQs of the shape
푄푖= ∃푥푖
1, … , 푥푖
푚푖∶푅푖
1(퐭푖
1) ∧⋯∧푅푖
푛푖(퐭푖
푛푖).
For all 퐚푖∈adom()푚푖, 푖= 1, … , 퓁, let 퐹푖(퐚푖) be the set of facts appearing in 푄∗
푖[퐱푖/퐚푖] where
퐱푖= (푥푖
1, … , 푥푖
푚푖), and for all 푓∈퐹푖(퐚푖) let 휈푖(푓, 퐚푖) denote the number of times 푓appears in
푄∗
푖[퐱푖/퐚푖]. Then
E (♯푄1 ⋅⋯⋅♯푄퓁) =
∑
퐚1∈adom()푚1
⋯
∑
퐚퓁∈adom()푚퓁
∏
푓∈퐹1(퐚1)∪⋯∪퐹퓁(퐚퓁)
E ((♯푓)휈1(푓,퐚1)+⋯+휈퓁(푓,퐚퓁)
).
The number of expected value terms appearing on the right-hand side above is polynomial in the
size of the active domain of .
Proof. By deﬁnition of ♯푄for Boolean CQs 푄, we get
E (♯푄1 ⋅⋯⋅♯푄퓁) = E (
퓁
∏
푖=1 (
∑
퐚푖∈adom()푚푖
∏
푓∈퐹푖(퐚푖)
(♯푓)휈푖(푓,퐚푖)
))
= E (
∑
퐚1∈adom()푚1
⋯
∑
퐚퓁∈adom()푚퓁
∏
푓∈퐹1(퐚1)∪⋯∪퐹퓁(퐚퓁)
(♯푓)∑퓁
푖=1 휈푖(푓,퐚푖)
).
The claim then follows from the linearity of expectation and using that the random variables
♯푓are independent for diﬀerent 푓.
Remark A.5. We treat queries as functions from the possible world of a probabilistic database
to ℕ. If 푄= 푄′, then 푄and 푄′ are the same function, deﬁned on the same probability
space , i.e., ♯푄and ♯푄′ are the same random variable. In our proofs, we manipulate the
functional deﬁnitions of the query semantics directly. In particular, Lemma A.4 applies to the
case 푄1 = … = 푄퓁= 푄, where it provides an expression for E ((♯푄)퓁).
Recall that by linearity
E((푋1 + ⋯+ 푋푛)
퓁
) =
∑
푖1,…,푖퓁∈{1,…,푛}
E(푋푖1 ⋅⋯⋅푋푖퓁),
(11)
E((푋−E(푋))
퓁
) =
퓁
∑
푖=0 (
퓁
푖) E(푋푖⋅(−E(푋))
퓁−푖
) =
퓁
∑
푖=0 (
퓁
푖) ⋅(−E(푋))
퓁−푖⋅E(푋푖).
(12)
for random variables 푋, 푋1, … , 푋푛(deﬁned on the same probability space) and 퓁∈ℕ.
Corollary A.6. Let 푄= 푄1 ∨푄2∨⋯∨푄푁be a Boolean UCQ such that 푘is the maximum self-join
width among 푄1, … , 푄푁. Let 퓁∈ℕ. If Rep is a TIRS with polynomially computable moments up
to order 퓁⋅푘, then E((♯푄)퓁) and E((♯푄−E(♯푄))
퓁
) is computable in polynomial time.
Proof. Using (11), we have
E((♯푄)퓁) =
∑
푖1,…,푖퓁∈{1,…,푁}
E(♯푄푖1 ⋅⋯⋅♯푄푖퓁)
26

---

which we can further rewrite using Lemma A.4. This results in a polynomial length sum of
products of terms
E(♯푓)휈푖1(푓,푎푖1)+⋯+휈푖퓁(푓,푎푖퓁),
in which each of the 퓁terms in the exponent has value at most 푘. Hence, E((♯푄)퓁) can be
computed in polynomial time if Rep has polynomially computable moments up to order 퓁⋅푘.
For higher-order central moments, by (12) we have
E((♯푄−E(♯푄))
퓁
) =
퓁
∑
푖=0 (
퓁
푖) ⋅(−E(♯푄))
퓁−푖⋅E((♯푄)푖).
Using the ﬁrst part of this proof, this expression can be evaluated in polynomial time, if Rep
has polynomially computable moments up to order 퓁⋅푘.
B. Proofs Omited from Section 5
B.1. 푘as Part of the Input
If Rep is a p-TIRS, then by PQERep(푄) we denote the probabilistic query evaluation problem
for Rep and a ﬁxed Boolean UCQ 푄, where 푘is treated as a (binary encoded) input instead of
a parameter. We show that if Rep supports all distributions of the shape (0 ↦1/2; 푥↦1/2)
for arbitrary positive integers 푥(see Fig. 1), then PQERep(푄) is ♯P-hard for 푄= ∃푥∶푅(푥). We
do so by using the idea from the proof of [29, Proposition 5], and reduce from ♯SUBSETSUM.
Let (푥1, … , 푥푛, 퐵) be an instance of ♯SUBSETSUM. That is, 푥1, … , 푥푛and 퐵are positive integers
(given in binary encoding), and we are asked to count the number of subsets 푆⊆{1, … , 푛} such
that ∑푖∈푆푥푖= 퐵. We construct a tuple-independent PDB over a unary relation 푅with possible
(independent) facts 푅(1), … , 푅(푛), where
Pr(♯(푅(푖))) =
{
푥푖
with probability 1
2,
0
with probability 1
2.
Let 퐷be a randomly drawn instance from . Such 퐷is drawn with probability 1
2푛, and we have
♯퐷(푄) = 퐵if and only if ∑푥푖= 퐵, where the sum ranges over all 푖such that 푅(푖) is present in
퐷with positive multiplicity. Hence,
Pr(♯퐷푄= 퐵) ⋅2푛= |||
{
푆⊆{1, … , 푛}∶∑
푖∈푆
푥푖= 퐵
}|||.
B.2. Hierarchical Self-Join Free CQs
The following lemma states how the answer count of a Boolean CQ is given in terms of the
answer counts of its individual connected components. Note that this does not require the
query to be self-join free.
27

---

Lemma B.1. Let 푄= ∃퐱∶푄∗be a Boolean CQ with constant atoms 푄∗
0 and connected components
푄∗
1, … , 푄∗
푚. Then for all instances 퐷we have
♯퐷푄= ♯퐷푄∗
0 ⋅
푚
∏
푖=1
♯퐷(∃퐱푖∶푄∗
푖),
where for all 푖= 1, … , 푚, the tuple 퐱푖only contains those variables from 퐱that appear in 푄∗
푖.
Proof. First, note that every variable from 퐱is contained in precisely one of the tuples 퐱푖. Thus,
♯퐷푄= ∑
퐚
♯퐷푄∗
0 ⋅
푚
∏
푖=1
♯퐷푄∗
푖[퐱/퐚] = ♯퐷푄∗
0 ⋅∑
퐚1
⋯∑
퐚푚
푚
∏
푖=1
♯퐷푄∗
푖[퐱푖/퐚푖]
= ♯퐷푄∗
0 ⋅
푚
∏
푖=1
∑
퐚푖
♯퐷푄∗
푖[퐱푖/퐚푖] = ♯퐷푄∗
0 ⋅
푚
∏
푖=1
♯퐷(∃퐱푖∶푄∗
푖),
as claimed.
In the remainder of this subsection, we develop an algorithm that establishes Theorem 5.8.
Theorem 5.8. Let Rep be a p-TIRS, and let 푄be a hierarchical Boolean CQ without self-joins.
Then PQERep(푄, 푘) is solvable in polynomial time for each 푘∈ℕ.
So let 푄= ∃퐱∶푄∗be a hierarchical, Boolean self-join free CQ, and let 푄∗
1, … , 푄∗
푚be its
connected components, and let 푄∗
0 be the conjunction of the constant atoms.
Let 푘∈ℕ. Since
Pr (♯푇푄≤푘) = ∑
푘′≤푘
Pr (♯푇푄= 푘′),
it suﬃces to show that Pr (♯푇푄= 푘) is computable in polynomial time. First, consider the case
푘≥1. We have
Pr (♯푇푄= 푘) = Pr (♯푇푄∗
0 ⋅
푚
∏
푖=1
♯푇(∃퐱푖∶푄∗
푖) = 푘)
=
∑
푘0,…,푘푚
∏푖푘푖=푘
Pr (♯푇푄∗
0 = 푘1 and ♯푇(∃퐱푖∶푄∗
푖) = 푘푖f. a. 푖= 1, … , 푚)
Since 푄is self-join free, the random variables appearing in the above products are independent.
Thus,
Pr (♯푇푄= 푘) =
∑
푘0,…,푘푚
∏푖푘푖=푘
Pr (♯푇푄∗
0 = 푘1) ⋅
푚
∏
푖=1
Pr (♯푇(∃퐱푖∶푄∗
푖) = 푘푖).
(13)
Recall, that 푄∗
0 is the conjunction of the constant atoms of 푄, say, such that the constant atoms
correspond to distinct facts 푓1, … , 푓퓁where 푓푖appears 푛푖times in 푄∗
0. Then
Pr (♯푇푄∗
0 = 푘1) = Pr (
퓁
∏
푖=1
♯푇푓푖= 푘1)
28

---

=
∑
푘1,1,…,푘1,퓁
∏푖푘1,푖=푘1
Pr ((♯푇푓푖)푛푖= 푘1,푖for all 푖= 1, … , 퓁)
Note that since 푘> 0, it follows that 푘1 > 0, so the sum appearing above has ﬁnitely many
terms, and the concrete number only depends on 푄. Since the random variables (♯푇푓푖)푛푖are in-
dependent, the last probability turns into a product, and the whole expression can be evaluated
in polynomial time.
For the other probabilities in (13), let̂ 푥푖be a maximal variable of 푄∗
푖and leť 퐱푖denote the
tuple 퐱푖witĥ 푥푖omitted. Then, we get
Pr (♯푇(∃퐱푖∶푄∗
푖) = 푘푖) = Pr ( ∑
푎
♯푇(∃̌퐱푖∶푄∗
푖[̂푥푖/푎]) = 푘푖)
= Pr (
⋃
(푘푎)푎∈adom(푇)
∑푎푘푎=푘푖
⋂
푎
♯푇(∃̌퐱푖∶푄∗
푖[̂푥푖/푎]) = 푘푎)
=
∑
(푘푎)푎∈adom(푇)
∑푎푘푎=푘푖
Pr ( ⋂
푎
♯푇(∃̌퐱푖∶푄∗
푖[̂푥푖/푎]) = 푘푎).
(14)
Recall that̂ 푥푖, as a maximal variable in the connected component 푄∗
푖, appears in every atom
of 푄∗
푖. Thus, the facts appearing in 푄∗
푖[퐱푖/퐚푖] are disjoint from the ones appearing in 푄∗
푖[퐱푖/퐚′
푖]
whenever 퐚푖and 퐚′
푖disagree on the value for̂ 푥푖. But this means that the intersection appearing
in (14) ranges over independent events. Therefore,
Pr (♯푇(∃퐱푖∶푄∗
푖) = 푘푖) = ∑
(푘푎)푎
∑푎푘푎=푘푖
∏
푎
Pr (♯푇(∃̌퐱푖∶푄∗
푖[̂푥푖/푎]) = 푘푎).
(15)
This can be evaluated in polynomial time, if the probabilities on the right-hand side can be
evaluated in polynomial time. For all 푎∈adom(푇), the Boolean query ∃̌푥푖∶푄∗
푖[̂푥푖/푎] again
decomposes into connected components and possibly some leftover constant atoms. If there are
only constant atoms left, then we are done, using the procedure for 푄∗
0 from above. Otherwise,
we proceed recursively on the connected components, grounding out a maximal variable in
each step. Note that the number of summation terms in (15) is at most
(
|adom(푇)|
푘푖
) ⋅|adom(푇)|푘푖,
and in each of the summation terms, the product has at most |adom(푇)| factors. That is, the
total number of subproblems we created from (13) is polynomial in adom(푇). When turned
into a recursive procedure, we remove one quantiﬁer per recursive call. As the query is ﬁxed,
this happens a constant number of times. Thus, Pr(♯푇푄= 푘) can be computed in polynomial
time for 푘≥1.
The case 푘= 0 receives a special treatment, because in this case, the sum in (13) would have
inﬁnitely many terms. However, ♯퐷푄≠0 in any individual instance 퐷if and only if all of ♯퐷푄∗
0
29

---

and ♯퐷(∃퐱푖∶푄∗
푖) for 푖= 1, … , 푚are diﬀerent from 0. Thus, going over the converse probability,
Pr (♯푇푄= 0) = 1 −Pr (♯푇푄∗
0 ≠0 and ♯푇(∃퐱푖∶푄∗
푖) ≠0 f. a. 푖)
= 1 −Pr(♯푇푄0 ≠0) ⋅
푚
∏
푖=1 (1 −Pr (♯푇푄푖= 0)).
(16)
As Pr(♯푇푄∗
0 ≠0) = ∏푓∈푄0(1 −푃휆푓(0)), it is computable in polynomial time. For the rest, note
that
Pr (♯푇(∃퐱푖∶푄∗
푖) = 0) = ∏
푎
Pr (♯푇(∃̌퐱푖∶푄∗
푖[̂푥푖/푎]) = 0),
using again that the random variables ♯푇(∃̌퐱푖∶푄∗
푖[̂푥푖/푎]) are independent for diﬀerent 푎. This
can be turned into a recursive procedure as before, which again runs in polynomial time. This
concludes the proof of Theorem 5.8.
B.3. Beyond Hierarchical Qeries
We ﬁrst analyze the correctness and runtime of Algorithm 1.
Lemma 5.13. For every ﬁxed Boolean self-join free CQ 푄with a single component and no constant
atoms, Algorithm 1 runs in time (|푇|⋅푚), and satisﬁes the output conditions (O1), (O2) and (O3).
Proof. The algorithm iterates over all entries of 푇and constructs 푚facts per entry, hence the
runtime. Every fact 푓that results in the construction of facts 푓1, … , 푓푚uses a relation symbol
that appears in an atom of 푄. As 푄contains no constant atoms, and is self-join free, this atom
is unique and contains a variable. The position of this variable has diﬀerent values in 푓1, … , 푓푚
according to the construction. Hence, 푇푚,푖and 푇푚,푗are disjoint in the end for 푖≠푗, showing (O1).
Note that the instances of 푇푚,푖are in one-to-one correspondence with the instances from 푇(after
removing from the latter all facts whose relation symbol does not appear in the query) and that
푄returns the same answer on two such corresponding instances. Thus, (O2) follows. Finally,
we obtain (O3) by unraveling the deﬁnition of ♯푇(푚), and noting that the relevant valuations of
the variables of 푄∗partition exactly into the sets of domain elements 푎푖,푗with 푖= 1, … , 푚. This
latter assertion is true because 푄has a single connected component.7
Next, we establish the algebraic properties of the output of the algorithm.
Lemma B.2. Let 푋be a random variable with values in ℕand let 푘∈ℕ. Suppose 푋1, 푋2, … are
i.i.d random variables with 푋1 ∼푋. Let 푝0 ∶= Pr(푋= 0). Then, there exist 푦1, … , 푦푘≥0 such
that for all 푛∈ℕwe have
Pr (
푛
∑
푖=1
푋푖≤푘) = 푝푛
0 +
푘
∑
푗=1 (
푛
푗) ⋅푝푛−푗
0
⋅푦푗.
7Otherwise, valuations in the deﬁnition of ♯푇(푚) would also include such that use domain elements 푎푖,푗for the
variables in one connected component, and elements 푎푖′,푗with 푖′ ≠푖for the variables of another component. In
this case, such valuations are not counted by ∑푚
푖=1 ♯푇푚,푖푄.
30

---

Proof. To simplify notation, we let 푝퓁∶= Pr(푋= 퓁) for all 퓁= 1, … , 푘. Then
Pr (
푛
∑
푖=1
푋푖≤푘) =
∑
(푥1,…,푥푛)∈ℕ푛
∑푖푥푖≤푘
Pr (푋1 = 푥1, … , 푋푛= 푥푛)
=
∑
(푥1,…,푥푛)∈ℕ푛
∑푖푥푖≤푘
푛
∏
푖=1
푝푥푖=
∑
(푥1,…,푥푛)∈ℕ푛
∑푖푥푖≤푘
푘
∏
퓁=0
푝|{푖∶푥푖=퓁}|
퓁
.
Note that the terms of the sum in the last line do not depend on the order of the 푥푖. Instead,
it only matters how often every possible value 퓁is attained among the 푥1, … , 푥푛. Denoting this
multiplicity by 푛퓁, this information is captured by a tuple (푛0, … , 푛푘) which turns the condition
∑푛
푖=1 푥푖≤푘into ∑푘
퓁=0 퓁⋅푛퓁≤푘. As the multinomial coeﬃcient (
푛
푛0,…,푛푘) gives exactly the number
of tuples (푥1, … , 푥푛) that correspond to a tuple (푛0, … , 푛푘) as above, we ﬁnd
∑
(푥1,…,푥푛)∈ℕ푛
∑푖푥푖≤푘
푘
∏
퓁=0
푝|{푖∶푥푖=퓁}|
퓁
=
∑
푛0,…,푛푘∈ℕ
∑퓁푛퓁=푛
∑퓁퓁⋅푛퓁≤푘
(
푛
푛0, … , 푛푘) ⋅
푘
∏
퓁=0
푝푛퓁
퓁
=
∑
푛0,…,푛푘∈ℕ
∑퓁푛퓁=푛
∑퓁퓁⋅푛퓁≤푘
(
푛
푛0) ⋅(
푛−푛0
푛0, … , 푛푘) ⋅푝푛0
0 ⋅
푘
∏
퓁=1
푝푛퓁
퓁.
The condition ∑푘
퓁=0 퓁⋅푛퓁≤푘enforces that 푛0 ≥푛−푘, or 푛−푛0 ≤푘. Thus, setting 푗∶= 푛−푛0,
we get
∑
푛0,…,푛푘∈ℕ
∑퓁푛퓁=푛
∑퓁퓁푛퓁≤푘
(
푛
푛0)(
푛−푛0
푛1, … , 푛푘)푝푛0
0
푘
∏
퓁=1
푝푛퓁
퓁=
푘
∑
푗=0
푝푛−푗
0
(
푛
푗)
∑
푛1,…,푛푘∈ℕ
∑퓁푛퓁=푗
∑퓁퓁푛퓁≤푘
(
푗
푛1, … , 푛푘)
푘
∏
퓁=1
푝푛퓁
퓁
⏟⏞⏞⏞⏞⏞⏞⏞⏞⏞⏞⏞⏞⏞⏞⏞⏞⏞⏞⏞⏞⏞⏞⏞⏞⏞⏞⏞⏞⏞⏞⏞⏞⏟⏞⏞⏞⏞⏞⏞⏞⏞⏞⏞⏞⏞⏞⏞⏞⏞⏞⏞⏞⏞⏞⏞⏞⏞⏞⏞⏞⏞⏞⏞⏞⏞⏟
=∶푦푗
.
As 푦0 = (
0
0,…,0) ⋅∏푘
퓁=1 푝0
퓁= 1, the claim follows.
Note that in the previous lemma, if 푋does not take all values from 0 to 푘with positive
probability, some (or even all) of the 푦푗may be zero.
As seen in Example 5.14, we usually cannot inﬂate the whole table 푇. Instead, we will only
inﬂate the part 푇푖corresponding to a single connected component 푄푖of 푄= 푄′ ∧푄푖. The fol-
lowing lemma shows that the structure of this answer count is still quite similar to Lemma B.2.
Lemma 5.15. Let 푋and 푌be independent random variables with values in ℕand let 푘∈ℕ.
Suppose 푋1, 푋2, … are i.i.d. random variables with 푋1 ∼푋. Let 푝0 ∶= Pr(푋= 0) and 푞0 ∶=
Pr(푌= 0). Then, there exist 푧1, … , 푧푘≥0 such that for all 푛∈ℕwe have
Pr (푌⋅
푛
∑
푖=1
푋푖≤푘) = 푞0 + (1 −푞0) ⋅푝푛
0 +
푘
∑
푗=1 (
푛
푗) ⋅푝푛−푗
0
⋅푧푗.
31

---

Proof. To simplify notation, we let 푆∶= ∑푛
푖=1 푋푖. First, we observe
Pr (푌⋅푆≤푘) = Pr(푌= 0) +
∞
∑
퓁=1
Pr(푌= 퓁) ⋅Pr (푆≤⌊
푘
퓁⌋).
From Lemma B.2, for every 푘∈ℕexist non-negative numbers 푦1,푘, … , 푦푘,푘such that for all
푛∈ℕholds
Pr(푆≤푘) = 푝푛
0 +
푘
∑
푗=1 (
푛
푗)푝푛−푗
0
푦푗,푘.
Together, this yields
Pr (푌⋅푆≤푘) = 푞0 +
∞
∑
퓁=1
푞퓁⋅(푝푛
0 +
⌊푘
퓁⌋
∑
푗=1 (
푛
푗)푝푛−푗
0
푦푗,⌊푘
퓁⌋)
= 푞0 + (1 −푞표) ⋅푝푛
0 +
푘
∑
퓁=1
⌊푘
퓁⌋
∑
푗=1
푞퓁⋅(
푛
푗)푝푛−푗
0
푦푗,⌊푘
퓁⌋
= 푞0 + (1 −푞표) ⋅푝푛
0 +
푘
∑
푗=1 (
푛
푗)푝푛−푗
0
⌊푘
푗⌋
∑
퓁=1
푞퓁⋅푦푗,⌊푘
퓁⌋
⏟⏞⏞⏞⏞⏞⏞⏞⏞⏞⏞⏞⏞⏟⏞⏞⏞⏞⏞⏞⏞⏞⏞⏞⏞⏞⏟
=∶푧푗
,
which completes the proof.
C. Example for the Reduction from Section 5.2
In this section, we illustrate the inner workings of the reduction described in Section 5.2 with
an example.
C.1. Setup
Let Rep be the p-TIRS we use, where we assume that zeroPr(Rep) ∩(0, 1) ≠∅. Consider the
following query
푄= ∃푥, 푦, 푧∶푅(푎) ∧푆(푧, 푎) ∧푈(푥) ∧푉(푥, 푦) ∧푊(푦).
This query has two components 푄1 = ∃푧∶푆(푧, 푎) and 푄2 = ∃푥, 푦∶푈(푥)∧푉(푥, 푦)∧푊(푦), and a
constant part 푄0 = 푅(푎). Our goal in this section is to solve PQERep(푄, 0) in polynomial time by
only using an oracle for the problem PQERep(푄, 2) (i.e. for 푘= 2). As an example, we work with
the following input table 푇(leaving the concrete parameters unspeciﬁed):
푅
푎
휆푅(푎)
푆
(푎, 푎)
휆푆(푎,푎)
(푏, 푎)
휆푆(푏,푎)
푈
푎
휆푈(푎)
푏
휆푈(푏)
푉
푎, 푏
휆푉(푎,푏)
푏, 푏
휆푉(푏,푏)
푊
푎
휆푊(푎)
32

---

Now according to the structure of 푄, we know that
♯푇푄= ♯푇푄0 ⋅♯푇푄1 ⋅♯푇푄2,
and, hence, with using independence, that
Pr(♯푇푄= 0) = Pr(♯푇푄0 = 0 or ♯푇푄1 = 0 or ♯푇푄2 = 0)
= 1 −(1 −Pr(♯푇푄0 = 0))(1 −Pr(♯푇푄1 = 0))(1 −Pr(♯푇푄2 = 0)).
(17)
The value Pr(♯푇푄0 = 0) is easy to to determine, as it is just 푃휆푅(푎)(0). For both of the other
two factors, we will have to use Algorithm 2.
C.2. Execution of Algorithm 2
We now follow the steps of Algorithm 2 for 푄1 = ∃푧∶푆(푧, 푎). The procedure works analogously
for 푄2.
Suppose that 휆is an arbitrary parameter in ΛRep with 푃휆(0) > 0. The auxiliary table belong-
ing to the canonical database for the remainder of the query is given by
푅
푎
휆
푈
푥
휆
푉
푥, 푦
휆
푊
푦
휆
Next, we calculate 푞0 ∶= Pr(♯푇′푄′ = 0). This is easy, since ♯푇′푄′ ≠0 if and only if all four
facts depicted above are present with positive multiplicity. Hence, 푞0 = 1 −(1 −푃휆(0))
4. The
algorithm then deﬁnes 푔(0) ∶= 1 −푞0.
In the central for loop, we let 푛take values from 1 up to 2푘+ 1 = 5. For every such 푛, we
compute the inﬂation 푇(푛)
1
∶= inflate푄1(푇1, 푛), recalling that 푇1 is the restriction of 푇to the facts
relevant for 푄1 (that is, the 푆-facts). For example, the inﬂation 푇(3)
1
is given as 푇(3)
1
= 푇3,1⊎푇3,2⊎푇3,3
where 푇3,푖is the following table:
푆
푎푖, 푎
휆푆(푎,푎)
푏푖, 푎
휆푆(푏,푎)
Note how the values of the ﬁrst attributes in the tuples are replaced with the new constants,
while the values of the second attribute remain unchanged, depending on which positions in
the 푆-atom of 푄1 are occupied by variables.
In this situation, the oracle is used to obtain Pr (♯푇′∪푇(푛)
1 푄≤푘), and we set 푔(푛) ∶=
Pr (♯푇′∪푇(푛)
1 푄≤푘) −푞0 (for all values of 푛in the aforementioned range 1, 2, … , 5).
We know that Pr (♯푇푄1 = 0) = 0 if and only if 푔(푘+ 1) = 푔(3) = 0 (cf. the proof of
Lemma 5.16). Thus, we check this special case separately. Before we continue, let us inspect
푔(푛) in more detail. We have
푔(푛) = Pr (♯푇′∪푇(푛)
1 푄≤2) −푞0
33

---

= Pr (♯푇′푄′ ⋅♯푇(푛)
1 푄1 ≤2) −푞0
= −푞0 + ∑
푗1,푗2∈ℕ
푗1⋅푗2≤2
Pr (♯푇′푄′ = 푗1 and ♯푇(푛)
1 푄1 = 푗2).
Writing 푞푗∶= Pr (♯푇′푄′ = 푗), we continue
푔(푛) = −푞0 + ∑
푗2∈ℕ
푞0 ⋅Pr (♯푇(푛)
1 푄1 = 푗2) + ∑
푗1∈ℕ+
푞푗1 ⋅Pr (♯푇(푛)
1 푄1 = 0)
+ 푞1 ⋅Pr (♯푇(푛)
1 푄1 = 1) + 푞1 ⋅Pr (♯푇(푛)
1 푄1 = 2) + 푞2 ⋅Pr (♯푇(푛)
1 푄1 = 1)
= (1 −푞0) ⋅Pr (♯푇(푛)
1 푄1 = 0)
+ 푞1 ⋅Pr (♯푇(푛)
1 푄1 = 1) + 푞1 ⋅Pr (♯푇(푛)
1 푄1 = 2) + 푞2 ⋅Pr (♯푇(푛)
1 푄1 = 1)
Now, writing 푝푗∶= Pr (♯푇1푄1 = 푗), we have
Pr (♯푇(푛)
1 푄1 = 0) = 푝푛
0,
Pr (♯푇(푛)
1 푄1 = 1) = (
푛
1)푝1푝(푛−1)
0
, and
Pr (♯푇(푛)
1 푄1 = 2) = (
푛
2)푝2
1푝(푛−2)
0
.
Thus,
푔(푛) = (1 −푞0) ⋅푝푛
0 + 푞1 ⋅(
푛
1) ⋅푝1 ⋅푝푛−1
0
+ 푞1 ⋅((
푛
2) ⋅푝2
1 ⋅푝푛−1
0
) + 푞2 ⋅(
푛
1) ⋅푝1 ⋅푝푛−1
0
= 푝푛
0 ⋅(
푛
0)(1 −푞0) + 푝(푛−1)
0
⋅(
푛
1)(푞1푝1 + 푞1푝2 + 푞2푝1) + 푝푛−2
0
⋅(
푛
2)푞1푝2
1,
which is the shape of 푔(푛) that we know from (4) (below Lemma 5.15).
We continue by deﬁning
ℎ4(푥) ∶= 푔(4 + 푥) ⋅푔(4 −푥)
and
ℎ5(푥) ∶= 푔(5 + 푥) ⋅푔(5 −푥)
for all 푥= 0, 1, 2, 3, 4 (since 2푘= 4). Using our expression for 푔(푛), we get
ℎ4(푥) = (푝4+푥
0
(
4+푥
0 )(1 −푞0) + 푝3+푥
0
(
4+푥
1 )(푞1푝1 + 푞1푝2 + 푞2푝1) + 푝2+푥
0
(
4+푥
2 )(푞1푝2
1))
⋅(푝4−푥
0
(
4−푥
0 )(1 −푞0) + 푝3−푥
0
(
4−푥
1 )(푞1푝1 + 푞1푝2 + 푞2푝1) + 푝2−푥
0
(
4−푥
2 )(푞1푝2
1)).
The function ℎ5 has the same shape, but with 푖± 푥replaced by 푖+ 1 ± 푥. When multiplying
this out, the occurrences of 푥in exponents vanish. Thus, both ℎ4 and ℎ5 are polynomials in 푥.
Moreover, they have the same, even degree.
Let us have a look at two examples. If 푝1 and 푞1 are both non-zero, then ℎ4 and ℎ5 have the
maximum possible degree 4. In this case, the leading coeﬃcient lc(ℎ4) of ℎ4 is 푝4
0 ⋅(−1)2 ⋅( 1
2)2 ⋅
(푞1푝2
1)2 (since (
4+푥
2 ) = (4+푥)(3+푥)
2
and (
4−푥
2 ) = (4−푥)(3−푥)
2
) and, similarly, lc(ℎ5) = 푝6
0 ⋅(−1)2 ⋅(1
2)2 ⋅
(푞1푝1)2. Here we see already that
√
lc(ℎ5)/ lc(ℎ4) = 푝0, as desired.
34

---

If instead we have, say, 푞1 = 0 but 푝1, 푞2 ≠0, then both ℎ4 and ℎ5 become polynomials of
degree 2, and their leading coeﬃcients contain 푝6
0 and 푝8
0, respectively.
In the next subsection, we illustrate how we computationally ﬁnd the leading coeﬃcients,
and thus, 푝0, using the ﬁnite diﬀerences method (cf. [22, Chapter 4]). After this has been
concluded, the value Pr (♯푇푄2 = 0) is calculated in the exact same fashion, and we can use (17)
to calculate Pr (♯푇푄= 0).
C.3. Finding 푝0 Using Finite Diﬀerences
Let ℎ4 and ℎ5 be as described above (for component 푄1). Recall that 푘= 2. We start with
ℎ4(0), … , ℎ4(4) (because 2푘= 4), and iteratively compute diﬀerences, yielding Δℎ4, Δ2ℎ4, Δ3ℎ4
and Δ4ℎ4. Our goal is to ﬁnd the largest 퓁for which Δ퓁ℎ4 is constant but non-zero.
Δ0ℎ4
Δ1ℎ4
Δ2ℎ4
Δ3ℎ4
Δ4ℎ4
ℎ4(0) 144
−4
ℎ4(1) 140
−8
−12
0
ℎ4(2) 128
−8
0
−20
0
ℎ4(3) 108
−8
−28
ℎ4(4)
80
Δ0ℎ5
Δ1ℎ5
Δ2ℎ5
Δ3ℎ5
Δ4ℎ5
ℎ5(0)
49
−1
ℎ5(1)
48
−2
−3
0
ℎ5(2)
45
−2
0
−5
0
ℎ5(3)
40
−2
−7
ℎ5(4)
33
Figure 4: Diﬀerences tables for ℎ4 (left) and ℎ5 (right) for the case (푞0, 푞1, 푞2) = (1
2, 0, 1
2) and
(푝0, 푝1, 푝2) = ( 1
2, 1
4, 1
4). For easier reading, all entries for are shown as multiples of
16384−1 = 2−14, for example, ℎ4(0) =
144
16384. The shaded columns indicate the columns
in which the values become constant for the ﬁrst time (darker shade), and 0 for the
ﬁrst time (lighter shade). The framed cell is the target cell we ﬁnd in the algorithm.
The algorithm returns
√
(−2)/(−8) = 1
2 = 푝0.
Again, consider two examples. First, suppose that (푞0, 푞1, 푞2) = (1
2, 0, 1
2) and (푝0, 푝1, 푝2) =
( 1
2, 1
4, 1
4) and recall that 푝0 is actually the unknown value that we want to ﬁnd. The algorithm
only has access to 푝0 through ℎ4. We have already argued that, ℎ4 has degree 2 then. Thus,
when calculating diﬀerences, Δ2ℎ4 will be constant (and non-zero) and Δ3ℎ4 and Δ4ℎ4 will be
zero. The constant non-zero value we ﬁnd for Δ2ℎ4 will be equal to the leading coeﬃcient of
ℎ4 times 2! by the properties of Δ (cf. Section 5.2). This is illustrated in Fig. 4.8
8The even degree justiﬁes skipping every second column when looking for the constant non-zero one.
35

---

Δ0ℎ4
Δ1ℎ4
Δ2ℎ4
Δ3ℎ4
Δ4ℎ4
ℎ4(0) 2704
−120
ℎ4(1) 2584
−228
−348
36
ℎ4(2) 2236
−192
24
−540
60
ℎ4(3) 1696
−132
−672
ℎ4(4) 1024
Δ0ℎ5
Δ1ℎ5
Δ2ℎ5
Δ3ℎ5
Δ4ℎ5
ℎ5(0) 1156
−38
ℎ5(1) 1118
−73
−111
9
ℎ5(2) 1107
−64
6
−175
15
ℎ5(3)
832
−49
−224
ℎ5(4)
608
Figure 5: Diﬀerences tables for ℎ4 (left) and ℎ5 (right) for the case (푞0, 푞1, 푞2) = (1
2, 1
2, 0) and
(푝0, 푝1, 푝2) = ( 1
2, 1
4, 1
4). For easier reading, all entries for are shown as multiples of
65536−1 = 2−16, for example, ℎ4(0) = 2704
65536. The algorithm returns
√
6/24 = 1
2 = 푝0.
Our second example (see Fig. 5) illustrates the setup (푞0, 푞1, 푞2) = ( 1
2, 1
2, 0) and (푝0, 푝1, 푝2) =
( 1
2, 1
4, 1
4). This is one of the cases where ℎ4 and ℎ5 have the maximum possible degree 4. Here
(when seen from the end), there are no zero columns, and the value we are looking for is
contained in the very last cell.
36

---

