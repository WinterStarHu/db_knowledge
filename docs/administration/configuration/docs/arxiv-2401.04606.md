# The Importance of Parameters in Database Queries

> 来源: https://arxiv.org/pdf/2401.04606

arXiv:2401.04606v2  [cs.DB]  14 Nov 2024
THE IMPORTANCE OF PARAMETERS IN DATABASE QUERIES ∗
AMIR GILAD
a, MARTIN GROHE
b, BENNY KIMELFELD
c, PETER LINDNER
d,
AND CHRISTOPH STANDKE
b
a The Hebrew University, Jerusalem, Israel
e-mail address: amirg@cs.huji.ac.il
b RWTH Aachen University, Aachen, Germany
e-mail address: grohe@informatik.rwth-aachen.de, standke@informatik.rwth-aachen.de
c Technion – Israel Institute of Technology, Haifa, Israel
e-mail address: bennyk@cs.technion.ac.il
d École Polytechnique Fédérale de Lausanne, Lausanne, Switzerland
e-mail address: peter.lindner@epﬂ.ch
Abstract. We propose and study a framework for quantifying the importance of the
choices of parameter values to the result of a query over a database. These parameters
occur as constants in logical queries, such as conjunctive queries. In our framework, the im-
portance of a parameter is its Shap score – a popular instantiation of the game-theoretic
Shapley value to measure the importance of feature values in machine learning models.
We make the case for the rationale of using this score by explaining the intuition behind
Shap, and by showing that we arrive at this score in two diﬀerent, apparently opposing,
approaches to quantifying the contribution of a parameter. The application Shap requires
two components in addition to the query and the database: (a) a probability distribution
over the combinations of parameter values, and (b) a utility function that measures the
similarity between the result for the original parameters and the result for hypothetical
parameters. The main question addressed in the paper is the complexity of calculating
the Shap score for diﬀerent distributions and similarity measures. In particular, we de-
vise polynomial-time algorithms for the case of full acyclic conjunctive queries for certain
(natural) similarity functions. We extend our results to conjunctive queries with parame-
terized ﬁlters (e.g., inequalities between variables and parameters). We also illustrate the
application of our results to “why-not” explanations (aiming to explain the absence of a
query answer), where we consider the task of quantifying the contribution of query com-
ponents to the elimination of a non-answer in consideration. Finally, we discuss a simple
approximation technique for the case of correlated parameters.
∗A conference version of the manuscript appeared in the 2024 International Conference on Database Theory
(ICDT’24) [GKLS24].
Preprint submitted to
Logical Methods in Computer Science
©
A. Gilad, M. Grohe, B. Kimelfeld, P. Lindner, and C. Standke
CC
⃝
Creative Commons

---

2
A. GILAD, M. GROHE, B. KIMELFELD, P. LINDNER, AND C. STANDKE
1. Introduction
The parameters of a database query may aﬀect the result in a way that misrepresents the
importance of the parameters, or the arbitrariness in their chosen values. For example, when
searching for products in commercial applications (for clothing, travel, real estate, etc.), we
may ﬁll out a complex form of parameters that produce too few answers or overly expensive
ones; what is the responsibility of our input values to this deﬁcient outcome? We may phrase
a database query to select candidates for awards for job interviews; to what extent is the
choice of parameters aﬀecting people’s fate?
Considerable eﬀort has been invested in exploring the impact of parameters on query
outcomes. In the empty-answer problem, the goal is typically to explore a space of small
changes to the query that would yield a nonempty result [KLTV06, MMR+13]. In that vein,
reasoning about small parameter changes, or perturbations, has been applied to providing
explanations to non-answers, that is, tuples that are missing from the result [CJ09a, TC10a].
From a diﬀerent angle, the analysis of sensitivity to parameters has been applied to fact
checking, and particularly, the detection of statements that are cherry picked in the sense that
they lead to conclusions that overly rely on allegedly arbitrary parameter values. This may
come in over-restriction to a database fragment that serves the intended claim [WAL+17],
or over-generalization that masks the situation in substantial subgroups that oppose the
claim [LYM+21].
In this work, we aim to establish a principled quantitative measure for the importance
of individual parameter values to the result Q(D) of a query Q over a database D. To this
end, we begin with the basic idea of observing how the result changes when we randomly
change the parameter of interest. Alternatively, we can observe the change in the result
when the parameter keeps its value while all others randomly change. Yet, these deﬁnitions
ignore dependencies among parameters; changing a parameter may have no impact in the
presence of other parameter values (e.g., the number of connecting ﬂights does not matter
if we restrict the travel duration), or it may lead to an overestimation of the value’s im-
portance (e.g., changing the number of semesters empties the result since we restrict the
admission year). This can be viewed as a special case of a challenge that has been stud-
ied for decades in game theory: How to attribute individual contributions to the gains of a
team? Speciﬁcally, we can view the parameter values as players of a cooperative game where
each coalition (set of parameter values in our case) has a utility, and we wish to quantify
the contribution of each parameter value to the overall utility. We then adopt a conven-
tional formula for contribution attribution, namely the Shapley value [Sha53], as done in
many domains, including economics, law, bioinformatics, crime analysis, network analysis,
machine learning, and more (see, e.g., the Handbook of the Shapley value [AFSS19]). The
Shapley value is theoretically justiﬁed in the sense that it is unique under several elemen-
tary axioms of rationality for proﬁt sharing [Sha53]. In the context of databases, this value
has been studied recently for measuring the contribution of individual tuples to query an-
swers [LBKS20, DFKM22, ADF22, BFL24] and to database inconsistency [LK22], as well
as the contribution of constraints to the decisions of cleaning systems [DFGS21].
Our challenge then boils down to one central question: What game are we playing? In
other words, what is the utility of a set J of parameter values? Following up on the two basic
ideas discussed above, we can think of two analogous ways. In the ﬁrst way, we measure
the change in the query result when we randomly change the values of the parameters in J;
the parameter values in J are deemed important if we observe a large change. This change

---

THE IMPORTANCE OF PARAMETERS IN DATABASE QUERIES ∗
3
is random, so we take the expected change. (We later discuss the way that we measure
the change in the result.) In the second way, we again measure the change in the result,
but now we do so when we ﬁx the values of the parameters in J and randomly change the
rest; now, however, the values in J are deemed important if we observe a small change,
indicating that the other parameters have little impact once we use the values of J. This
second way is known as the Shap score [LL17, LEC+20] in machine learning, and it is one
of the prominent score-attribution methods for features (in addition to alternatives such
as LIME [RSG16] and Anchor [RSG18]).1 This score quantiﬁes the impact of each feature
value on the decision for a speciﬁc given instance. Interestingly, we show that the ﬁrst way
described above also coincides with the Shap score, so the two ways actually deﬁne the
same measure (Theorem 3.3). We prove it in a general setting and, hence, this equivalence
is of independent interest as it shows an alternative, apparently diﬀerent way of arriving at
Shap in machine learning.
Basic setup. To materialize the framework in the context of a query Q and a database
D, one needs to provide some necessary mechanisms for reasoning about Q(D) and Q′(D),
where Q′ is the same as Q up to the parameters: it uses the same values as Q for the
parameters of J, but the remaining parameter values are selected randomly. Speciﬁcally, to
this aim, we need two mechanisms:
(1) A probability distribution Γ of possible parameterizations of the query;
(2) A similarity function s between relations to quantify how close Q′(D) is to Q(D).
The distribution Γ may include any feasible combination of parameter values, and they
can be either probabilistically independent or correlated. For s, one can use any similarity
between sets (see, e.g., surveys on similarity measures such as [LRB08, SG19]) or measures
that account for the distance between attributes values (e.g., as done in the context of
database repairs [BBFL08]). We give examples in Section 3.
A central challenge in the framework is the computational complexity, since the direct
deﬁnition of the Shap score (like the general Shapley value) involves summation over an
exponential space of coalitions. Indeed, the calculation can be a hard computational prob-
lem, #P-hard to be precise, even for simple adaptations of the Shap score [ABBM21] and
the Shapley value [FK92, DP94, LBKS20]. Hence, instantiations of our framework require
specialized complexity analyses and nontrivial algorithms that bypass the exponential time
of the naïve computation.
We begin the complexity analysis of the framework by establishing some general in-
sights for ﬁnite fully factorized distributions, i.e., where the parameters are probabilistically
independent and each is given as an explicit collection of value-probability pairs. First, the
Shap score can be computed in polynomial time if we can evaluate the query, compute
the similarity measure, and enumerate all parameter combinations in polynomial time. We
prove this using a recent general result by Van den Broeck et al. [VdBLSS22] showing that,
under tractability assumptions, the Shap score is reducible to the computation of the ex-
pected value under random parameter values. Second, under reasonable assumptions, the
computation of the Shap score is at least as hard as testing for the emptiness of the query,
for every nontrivial similarity function; this is expected, as the deﬁnition of the Shap scores
requires, conceptually, many applications of the query.
1For background on attribution scores see textbooks on explanations in machine learning, e.g., Mol-
nar [Mol23].

---

4
A. GILAD, M. GROHE, B. KIMELFELD, P. LINDNER, AND C. STANDKE
Next, we focus on the class of conjunctive queries, where the parameters are constants
in query atoms. Put diﬀerently, we consider Select-Project-Join queries where each selection
predicate has the form x = p where x is an attribute and p is a parameter. It follows from
the above general results that this case is tractable under data complexity. Hence, we focus
on combined complexity. As the emptiness problem is intractable, we consider the tractable
fragment of acyclic queries, and show that Shap scores can be #P-hard even there.
We then focus on the class of full acyclic queries and establish that the Shap score can
be computed in polynomial time for three natural, set-based similarity functions between
Q(D) and Q′(D). Interestingly, this gives us nontrivial cases where the Shap score can be
computed in polynomial time even if Q(D) and Q′(D) can be exponential in the size of the
input, and hence, it is intractable to materialize them.
Extensions. Next, we extend our results to conjunctive queries with ﬁlters (Section 6). A
ﬁlter in a conjunctive query can be considered a conjunct that can be any Boolean condition
on the assignments of an ordinary (ﬁlter-free) conjunctive query, such as a Boolean com-
bination of built-in relations (e.g., inequalities). Filters may include parameters (e.g., the
inequality x ≥p where x is a variable and p is a parameter) and, as usual, we are interested
in their Shap score. We show that this addition can make the Shap score intractable to
compute, even if there is a single relational atom in addition to simple inequality ﬁlters. Nev-
ertheless, we identify cases where tractability properties are retained when adding ﬁlters to
classes of parameterized queries (e.g., full acyclic conjunctive queries), relying on structural
assumptions on the variables and parameters involved in the ﬁlters. We show an application
of this extension to measure the importance of query operators in “why not” questions (also
called provenance for non-answers) in query answering [CJ09b, BHT15, HCDN08, HH10,
Her15, MGMS10, TC10b, HL14, LGC+16]. The questions arises in scenarios where a tuple
is expected to appear in the result set of a query, but is nevertheless absent from it. To
explain this absence, previous work has considered several models of explanations. Our work
aligns with the operator-based approach [CJ09b, BHT14, BHT15] that focuses on discover-
ing operators that disqualify the tuple. Our contribution is a study of the Shapley value of
the ﬁlters in the game of eliminating the answer. For that matter, we examine two plausible
games and explore their associated complexity. We show how the results established in the
manuscript can be used for this analysis.
Given that the computation of the exact Shap score is often intractable, we also study
the complexity of approximate evaluation (Section 7). We show that using sampling, we can
obtain an eﬃcient approximation scheme (FPRAS) with additive guarantees. Moreover, the
tractability of approximation generalizes to allow for parameters that are correlated through
Bayesian networks (and actually any distribution) that provide(s) polynomial-time sampling
while conditioning on assignments to arbitrary subsets of the random variables.
Comparison to a conference version. An abridged version of this work appeared in a
conference version [GKLS24]. In comparison to that version, this manuscript includes several
new additions. First, the manuscript includes the full proofs of all of the results. Second, the
study of ﬁlters (Section 6) is new. (The conference version included a restricted discussion
on the addition of inequalities to parametrized conjunctive queries.) Third, also entirely
new is the application to why-not questions, including the problem deﬁnition, variants, and
analysis (Section 6.2).

---

THE IMPORTANCE OF PARAMETERS IN DATABASE QUERIES ∗
5
Organization. In brief, the manuscript is organized as follows. After preliminary deﬁni-
tions in Section 2, we introduce and carefully motivate our framework in Section 3. In Sec-
tion 4, we present some general insights on the complexity of the associated computational
problem. We focus on the special case of conjunctive queries and independent parameters
in Section 5. We discuss the extension to ﬁlters and why-not questions in Section 6. In Sec-
tion 7, we discuss the complexity of approximate computation and correlated parameters.
We conclude the manuscript in Section 8.
2. Preliminaries
We begin with basic terminology and notation that we use throughout the manuscript.
2.1. General Notation. We write 2S for the power set of S. Vectors, tuples and sequences
are denoted by boldface letters. If x = (xi)i∈I and J ⊆I, then xJ = (xj)j∈J. Moreover,
|x| = |I| is the number of entries of x. We let [n] = {1, . . . , n}. Truth values are denoted by
true and false. Whenever x refers to an input for a computational problem, we write ∥x∥to
refer to the encoding length of x as represented in the input.
A (discrete) probability distribution is a function Γ: S →[0, 1], where S is a non-empty
countable set, and P
s∈S Γ(s) = 1. The support of Γ is supp(Γ) = {s ∈S : Γ(s) > 0}. We
use Pr for generic probability distributions and, in particular, PrX∼Γ to refer to probabilities
for a random variable or random vector X being drawn from the distribution Γ. Likewise,
EX∼Γ refers to the expectation operator with respect to the distribution Γ of X.
2.2. Schemas and Databases. A relation schema is a sequence A = (A1, . . . , Ak) of
distinct attributes Ai, each with an associated domain dom(Ai) of values. We call k the
arity of A.
If A = (A1, . . . , Ak) is a relation schema and S = {i1, . . . , iℓ} ⊆[k] with
i1 < i2 < · · · < iℓ, then AS denotes the relation schema (Ai1, . . . , Aiℓ).
A tuple over A is an element a = (a1, . . . , ak) ∈dom(A1) × · · · × dom(Ak). The set
of tuples over A is denoted by Tup[A]. A relation over A is a ﬁnite set of tuples over A.
We denote the space of relations over A by Rel[A]. We typically denote relations by T,
possibly with a subscript or superscript. By default, we assume that all attribute domains
are countably inﬁnite.
A database schema is a ﬁnite set of relation symbols, where every relation symbol is
associated with a relation schema. For example, if R is a relation symbol with associated
relation schema A = (A1, . . . , Ak), we may refer to R by R(A) or R(A1, . . . , Ak), and call k
the arity of R. A fact f over a database schema S is an expression of the form R(a) with
R = R(A), where a is a tuple over A. A database over the schema S is a ﬁnite set of facts
over S. We denote the space of databases over some schema S by DB[S].
2.3. Queries and Parameters. A relational query (or just query) is a function that maps
databases to relations. More precisely, a query q has a database schema In(q) for its valid
input databases (called the input schema), and a relation schema Out(q) for its output
relation (called the output schema). Then q is a function that maps databases over In(q) to
relations over Out(q). We write q = q(R) to denote that Out(q) = R.
We focus on queries that are expressed in variants of ﬁrst-order logic without equality.
In this case, Out(q) is the domain of the free variables of q. Whenever we discuss queries

---

6
A. GILAD, M. GROHE, B. KIMELFELD, P. LINDNER, AND C. STANDKE
in this paper, it is assumed that they are queries in First-Order logic (FO), unless explicitly
stated otherwise. Moreover, we always assume that no variable appears both free and bound
by a quantiﬁer in the same query. We can then write q = q(x) where x = (x1, . . . , xn) lists
the free variables of q. If a = (a1, . . . , an) ∈Tup[R], then q(a) denotes the Boolean query
obtained from q by substituting every occurrence of xi with ai for all i ∈[n]. If D is a
database over In(q), then q(D) := {a ∈Tup[R]: D |= q(a)}.
A parameterized query Q is a relational query in which some of the free variables are
distinguished as parameters. We then write Q(x; y) to denote that x are the non-parameter
(free) variables of Q, and that y are the parameters of Q. A parameterized query Q has
a parameter schema Par(Q), such that Tup[Par(Q)] is the set of valid tuples of parameter
values for Q. If Q = Q(x; y) is a parameterized query, and p ∈Tup[Par(Q)], then Qp(x) :=
Q(x; p) is the (non-parameterized) relational query obtained from Q by substituting the
parameters y with the constants p.
The input and output schemas of Q coincide with
In(Qp) and Out(Qp), respectively, which is independent of the choice of p ∈Tup[Par(Q)].
By this deﬁnition, in particular, parameter values are not part of the query output, and a
parameterized query is considered Boolean, if it has no non-parameter free variables.
We write Q = Q(R; P ) to denote that Out(Q) = R and Par(Q) = P . If Q = Q(R; P ),
then for every database D over In(Q) and every p ∈Tup[P ] we have
Qp(D) :=

a ∈Tup[R]: D |= Qp(a)
	
∈Rel[R].
(2.1)
Example 2.1. For illustration, consider a parameterized query over ﬂights data, assuming
access to a database with relations Flight(Id, Date, AirlineName, From, To, Departure, Arrival)
and Airline(Name, CountryOfOrigin). Then
Q(x, tdep, tarr; d, c) = ∃a: Flights(x, d, a, CDG, JFK, tdep, tarr) ∧Airline(a, c)
is a parameterized conjunctive query. For parameters d and c, it asks for departure and
arrival times tdep and tarr of ﬂights x from Paris (CDG) to New York City (JFK) on date d
operated by an airline from country c.
To highlight a possible choice of parameters, consider d0 = 2025-01-31 and c0 = France.
Then
Qd0,c0(x, tdep, tarr) = ∃a: Flights(x, 2025-01-31, a, CDG, JFK, tdep, tarr)∧Airline(a, France). ⌟
The notion of a Conjunctive Query (CQ) extends to parameterized queries in the
straightforward way, as illustrated in Example 2.1.
2.4. The Shapley Value. A cooperative game is a pair (I, ν) where I is a non-empty set
of players, and ν : 2I →R is a utility function that assigns a “joint wealth” ν(J) to every
coalition ν(J) ⊆I. Without loss of generality, and unless explicitly stated otherwise, we
will consistently assume that I = [ℓ] for some ℓ∈N.
The Shapley value of player i ∈[ℓ] in a cooperative game ([ℓ], ν) measures the importance
(or, contribution) of player i among coalitions. Formally, it is deﬁned as
Shapley([ℓ], ν, i) := 1
ℓ!
X
σ∈S[ℓ]
 ν(σi ∪{i}) −ν(σi)

=
E
σ∼S[ℓ]

ν(σi ∪{i}) −ν(σi)

,
(2.2)
where S[ℓ] is the set of permutations of [ℓ], and σi is the set of players appearing before i in
the permutation σ ∈S[ℓ], and σ ∼S[ℓ] indicates that σ is drawn according to the uniform

---

THE IMPORTANCE OF PARAMETERS IN DATABASE QUERIES ∗
7
distribution on S[ℓ]. An equivalent, alternative formulation is
Shapley([ℓ], ν, i) =
X
J⊆[ℓ]\{i}
Πi(J) ·
 ν(J ∪{i}) −ν(J)

=
E
J∼Πi

ν(J ∪{i}) −ν(J)

,
(2.3)
where Πi is the probability distribution on [ℓ] \ {i} with
Πi(J) = |J|! · (ℓ−|J| −1)!
ℓ!
=
1
ℓ·
 ℓ−1
|J|
.
(2.4)
As proved by Shapley [Sha53], the Shapley value is the only way of quantifying the
contribution of the players, subject to a few natural assumptions (“axioms”) and the technical
requirement that ν is zero on the empty set.2 Let us brieﬂy review these axioms. (For details
and a proof of Shapley’s theorem, we refer to the literature, e.g., [Sha53, Rot88, AFSS19].)
The ﬁrst axiom, symmetry, says that if any two players i and j have the same contribution
to any coalition J ⊆[ℓ] \ {i, j}, then Shapley([ℓ], ν, i) = Shapley([ℓ], ν, j).
The second
axiom, eﬃciency, says that the sum of Shapley([ℓ], ν, j) for all players j ∈[ℓ] is ν([ℓ])−ν(∅),
that is, the contribution of the “grand coalition” [ℓ] minus the contribution of the empty
coalition ∅. Thus, the Shapley values “distribute” ν([ℓ]) among the individual players. The
third axiom, null player, says that if a player j makes no contribution to any coalition,
then Shapley([ℓ], ν, j) = 0. The fourth axiom, additivity, says that if we have two diﬀerent
functions ν1, ν2 : 2[ℓ] →R measuring the value of a coalition, then Shapley([ℓ], ν1 + ν2, j) =
Shapley([ℓ], ν1, j) + Shapley([ℓ], ν2, j).
3. The Shap Score of Query Parameters
In this section, we give our exact deﬁnition of the Shap score of a query parameter, and
argue that it measures in a natural way the contribution of the parameter to the outcome
of the query. We start with a database D over In(Q); a parameterized query Q(R; P ); and
a reference parameter p∗= (p∗
1, . . . , p∗
ℓ) over P . We want to quantify the contribution of
each parameter p∗
i to the query answer Qp(D).
3.1. Intuition. A basic idea is to see what happens to the answer if we either modify p∗
i and
keep all other parameters ﬁxed or, conversely, keep p∗
i ﬁxed but modify the other parameters.
The following example shows that neither of these two approaches is suﬃcient.
Example 3.1. We let Q(x; y1, y2, y3) := R(y1, y2, y3, x) for a relation R(B1, B2, B3, A). Let
D be the database where the tuple set of R is
  {1} × [n]

∪
 [n] × {1}

× [n] × [n].
Let p∗= (p∗
1, p∗
2, p∗
3) = (1, 1, 1). Then Qp∗(D) = [n].
Let us try to understand the contribution of each parameter p∗
i . Intuitively, the param-
eter p∗
3 is completely irrelevant. Whatever value it takes in any conﬁguration of the other
two parameters, the query answer remains the same. Parameters p∗
1 and p∗
2 are important,
though. If we change both of their values to values p1, p2 ∈[n] \ {1}, the query answer
becomes empty. However, for this change to take eﬀect, we need to change both values at
2We drop the requirement that ν is zero on the empty set throughout the manuscript. This is commonly
done in literature on the Shap score, since the requirement can be achieved by considering ν′(J) := ν(J)−ν(∅)
instead of ν and both valuation functions ν and ν′ yield the same Shapley values.

---

8
A. GILAD, M. GROHE, B. KIMELFELD, P. LINDNER, AND C. STANDKE

D
Qp∗
Qp
Qp′
Result
a
1
b
5
Result
a
1
b
3
Result
a
9
p ∼Γ
p′ ∼Γ
s(Qp(D), Qp∗(D))
s(Qp′(D), Qp∗(D))
≥
Figure 1. On a given database D, we evaluate a parameterized query Q
with respect to a reference parameter p∗. The result is compared (using a
similarity function s) against diﬀerent parameterizations of Q, according to
a probabilistic model Γ.
the same time. If we change only p1 keeping p∗
2 and p∗
3 ﬁxed, the query answer does not
change. This is also the case, if we keep p∗
1 ﬁxed and modify p2 and p3. The same holds for
the second parameter.
⌟
What this example shows is that even if we just want to understand the contribution
of the individual parameters, we need to look at the contributions of sets of parameters.
This will immediately put us in the realm of cooperative game theory with the parameters
acting as players in a coalitional game: Assume for a moment that we have a function
ν : 2[ℓ] →R such that, for J ⊆[ℓ], the function value ν(J) quantiﬁes the combined impact
of the parameters with indices in J. (We discuss in the next section how to obtain such a
function.) Given ν, we now quantify the contribution of every individual parameter j ∈[ℓ].
This is exactly what the Shapley value Shapley([ℓ], ν, j) does.
Concluding the discussion so far, to understand the contribution of individual param-
eters, we need to look at sets of parameters, and the method of choice to retrieve this
contribution from a valuation for sets is the Shapley value.
3.2. The Utility Function. What remains to be done is constructing a natural valuation
for sets of parameters, that is, a function ν : 2[ℓ] →R such that, for J ⊆[ℓ] the value ν(J)
quantiﬁes the combined contribution of the parameters p∗
j, for j ∈J, to the query answer.
The requires a way of measuring the similarity between query answers, that is, a function s
that takes two relations of the schema of our query answer and assigns a similarity value to
them. Formally, a similarity function is just an arbitrary function s : Rel[R] × Rel[R] →R.
We make no restrictions on this function, similarity can have diﬀerent meanings depending
on the application.
Let us just note that the intended use of this function is always to
quantify similarity: the higher s(Q, Q∗), the more similar Q and Q∗are.
Examples 3.2. (a) Prime examples of similarity functions are set-similarity measures such
as the Jaccard index, the Sørensen index, and Tverski’s index, which attempt to capture
the degree of similarity between two sets [Ont20]. If Q and Q∗are two relations of the

---

THE IMPORTANCE OF PARAMETERS IN DATABASE QUERIES ∗
9
same relation schema R, then, e.g., their Jaccard index is given by
Jaccard(Q, Q∗) := |Q ∩Q∗|
|Q ∪Q∗| = 1 −|Q △Q∗|
|Q ∪Q∗| ,
and Jaccard(∅, ∅) = 0 by convention.
(b) In the same spirit, but somewhat simpler, are similarities based on cardinalities and
basic set operations, for example:
Int(Q, Q∗) := |Q ∩Q∗|,
(size of the interesection)
NegSymDiﬀ(Q, Q∗) := −|Q △Q∗|,
(negative symmetric diﬀerence)
NegSymCDiﬀ(Q, Q∗) := −
|Q| −|Q∗|
.
(negative symmetric cardinality diﬀerence)
Note that we do not require similarity to be non-negative, thus both NegSymDiﬀand
NegSymCDiﬀare well-deﬁned. Intuitively, the negative sign makes sense because two
relations get more similar as their symmetric diﬀerence gets smaller.
(c) In our applications, Q and Q∗have diﬀerent roles: Q∗is always a ﬁxed “reference
relation”, and Q is a modiﬁcation of Q∗, obtained by changing some parameters in
the query.
In some situations, it can be useful to use similarity measures that are
not symmetric. For example, we may only care about not losing any tuples from Q∗,
whereas additional tuples may be irrelevant. This leads to an asymmetric similarity
measure:
NegDiﬀ(Q, Q∗) := −|Q∗\ Q|.
(negative diﬀerence)
We can also use similarity functions that are specialized to the application at hand. For
example, we can use a similarity function that accounts for diﬀerences of attribute values,
such as, e.g., arrival time minus departure time:
MinDiﬀA,B(Q, Q∗) := −
min(Q.A −Q.B) −min(Q∗.A −Q∗.B)
.
where Q.A is the vector obtained from the numerical column A of Q (hence, Q.A −Q.B is
the vector of diﬀerences between the A and B attributes). Alternatively, we can use
ExpMinDiﬀA,B(Q, Q∗) := exp
 min(Q.A −Q.B) −min(Q∗.A −Q∗.B)

.
which uses the exponential function instead of the absolute value.
⌟
Suppose now that we have a subset J ⊆[ℓ]. We need a value ν(J) quantifying how
important the subtuple p∗
J = (pj)j∈J is to obtain a query answer similar to Qp∗(D). The
crucial idea of the Shap score in a very similar setting in machine learning [LL17] was to
see what happens if we ﬁx the parameters p∗
J and change the other parameters: the value of
J is high if changing the other parameters has no big eﬀect on the query answer. In other
words, the value of J is large if for parameter tuples p with pJ = p∗
J the relations Qp(D)
and Qp∗(D) are similar, that is, s(Qp(D), Qp∗(D)) is large. We use the shorthand notation
s(p, p∗) = s(Qp(D), Qp∗(D))
in case that Q and D are clear from the context.
But this, of course, depends on how
exactly we change the other parameters. The idea is to change them randomly and take
the expected value, as illustrated in Figure 1. So, we assume that we have a probability
distribution Γ on the space of all possible parameter values, and we deﬁne
ν(J) := E
p∼Γ

s(p, p∗)
 pJ = p∗
J

.
(3.1)

---

10
A. GILAD, M. GROHE, B. KIMELFELD, P. LINDNER, AND C. STANDKE
With the above, we can quantify the contribution of any individual parameter i as
Shapley
 [ℓ], ν, i

. In using diﬀerent probability distributions, we can incorporate various
assumptions about the usage of parameters. For example, Γ may apply to only a subset of
interesting parameters and be deterministic (ﬁxed) on the others; it can also be concentrated
on certain values (e.g., locations of a reasonable distance to the original value) or describe
any other statistical model on the parameter space.
There is a diﬀerent approach, in some way a complementary approach, to quantify the
contribution of a set J of parameters: instead of measuring what happens if we ﬁx p∗
J and
randomly change the other parameters, we can also ﬁx the other parameters and randomly
change the parameters in J. Then the contribution of J is the higher, the more the query
answer changes.
Thus, now instead of our similarity measure s we need a dissimilarity
measure s. We simply let s(p, p′) := c −s(p, p′), where c ∈R is an arbitrary constant. (We
will see that this constant is completely irrelevant, but it may have some intuitive meaning;
for example, if our similarity measure is normalized to take values in the interval [0, 1], as
Jaccard similarity, then it would be natural to take c = 1.) Letting J := [ℓ] \ J for every
J ⊆[ℓ], our new value functions for sets of indices is
ν(J) := E
p∼Γ

s(p, p∗)
 pJ = p∗
J

.
We could have started our treatment with introducing ν instead of ν; indeed, the only
reason that we did not is that the analogue of ν is what is used in machine learning theory
and applications (e.g., [MHB19, ME20, BGH22, GG21, KK22]). Both ν and ν strike us as
completely natural value functions for sets of parameters, and we see no justiﬁcation for
preferring one over the other. Fortunately, we do not have to, because they both lead to
exactly the same Shapley values for the individual parameters.
Theorem 3.3. For all i ∈[ℓ] we have Shapley
 [ℓ], ν, i

= Shapley
 [ℓ], ν, i

.
Proof. From the linearity of expectation we get
ν(J) = E
p∼Γ

s(p, p∗)
 pJ = p∗
J

= E
p∼Γ

c −s(p, p∗)
 pJ = p∗
J

= c −E
p∼Γ

s(p, p∗)
 pJ = p∗
J

= c −ν(J)
(3.2)
By applying (2.3), we have
Shapley
 [ℓ], ν, i

=
X
J⊆[ℓ]\{i}
Πi(J) ·
 ν(J ∪{i}) −ν(J)

=
X
J⊆[ℓ]\{i}
Πi(J) ·
 c −ν(J ∪{i}) −c + ν(J)

=
X
J⊆[ℓ]\{i}
Πi(J) ·
 ν(J) −ν(J ∪{i})

.
Letting J′ = J ∪{i} and observing that
Πi(J) = |J|! · (ℓ−|J| −1)!
ℓ!
= (ℓ−|J′| −1)! · |J′|!
ℓ!
= Πi(J′).
we get
Shapley
 [ℓ], ν, i

=
X
J⊆[ℓ]\{i}
Πi(J′) ·
 ν(J′ ∪{i}) −ν(J′)

.

---

THE IMPORTANCE OF PARAMETERS IN DATABASE QUERIES ∗
11
Finally, observe that summing up over J is the same as summing up over J′, and, thus,
Shapley
 [ℓ], ν, i

=
X
J′⊆[ℓ]\{i}
Πi(J′) ·
 ν(J′ ∪{i}) −ν(J′)

= Shapley
 [ℓ], ν, i

,
as claimed.
Deﬁnition 3.4. For a given parameterized query Q, a database D over In(Q), a reference
parameter p∗over Par(Q), and a probability distribution over Tup[Par(Q)], the Shap score
of parameter i is given as
ShapQ,D,p∗,s,Γ(i) = Shapley([ℓ], ν, i),
where ℓ= |p∗| is the number of parameters in Q, ν is deﬁned as in (3.1), and i ∈[ℓ].
⌟
The full expression for the Shap score of parameter i is, hence,
ShapQ,D,p∗,s,Γ(i) =
E
J∼Πi
h
E
p∼Γ

s(Qp(D), Qp∗(D))
 pJ∪{i} = p∗
J∪{i}

−E
p∼Γ

s(Qp(D), Qp∗(D))
 pJ = p∗
J
i
.
When Q, D, p∗, s, Γ are clear from the context, we write Shap(i) instead of ShapQ,D,p∗,s,Γ.
We illustrate this framework using our previous examples.
Example 3.5. In Example 2.1, we considered a ﬂights database D and a query Q, parame-
terized with a date d and an airline country c, asking for ﬂights between Paris and New York
City. We assess the importance of Q’s parameters with respect to the reference parameter
d = 02/24/2024 and c = USA.
In specifying the parameter distribution Γ, we can tune the exploration of the parameter
space. For example, we may choose to only take local parameter perturbations into account.
For this, we can specify Γ to be a product distribution whose support is restricted to dates in
the vicinity of 02/24/2024, and to the countries USA and France. If the similarity function
NegSymCDiﬀis used, e.g., then it is measured how close Qp and Qp∗are in terms of the
number of given ﬂight options. If NegDiﬀis used, it is measured how many of Qp∗’s ﬂight
options are lost when the parameters are changed. With MinDiﬀArrival,Departure, the diﬀerence
in duration of the shortest ﬂight options is assessed.
⌟
Now that we have illustrated the intuition, we revisit Example 3.1 to show how Shap
scores are computed.
Example 3.6. In Example 3.1, we considered the query Q(x; y1, y2, y3) = R(y1, y2, y3, x)
on a database D in which the relation R contains the tuples (b1, 1, b3, a) and (1, b2, b3, a) for
all a, b1, b2, b3 ∈[n]. For simplicity, we discuss the case n = 2. Then the relation R in D has
the following tuples:
(1, 1, 1, 1), (1, 2, 1, 1), (2, 1, 1, 1),
(1, 1, 1, 2), (1, 2, 1, 2), (2, 1, 1, 2),
(1, 1, 2, 1), (1, 2, 2, 1), (2, 1, 2, 1),
(1, 1, 2, 2), (1, 2, 2, 2), (2, 1, 2, 2).
We had already picked a reference parameter p∗= (1, 1, 1), which yields Qp∗(D) = {1, 2},
coming from the two underlined tuples above. In using the similarity function NegDiﬀfrom
Examples 3.2, we measure how many output values are lost when using some diﬀerent p

---

12
A. GILAD, M. GROHE, B. KIMELFELD, P. LINDNER, AND C. STANDKE
instead of p∗. Observe that for any p = (p1, p2, p3), we get Qp(D) = {1, 2} if (p1, p2)̸ = (2, 2),
and Qp(D) = ∅otherwise. Hence,
NegDiﬀ(p, p∗) =
(
0
if (p1, p2)̸ = (2, 2),
−2
if (p1, p2) = (2, 2).
A simple calculation then shows
ν(J) = E
p∼Γ

NegDiﬀ(p, p∗) | pJ = p∗
J

= 0 · Pr
p∼Γ
 NegDiﬀ(p, p∗) = 0 | pJ = p∗
J

+ (−2) · Pr
p∼Γ
 NegDiﬀ(p, p∗) = −2 | pJ = p∗
J

= (−2) · Pr
p∼Γ
 (p1, p2) = (2, 2) | pJ = p∗
J

Suppose that Γ is the uniform distribution on {1, 2}3, i.e., each of the three parameters takes
values 1 or 2 with probability 1
2. Then
Pr
p∼Γ
 (p1, p2) = (2, 2) | pJ = p∗
J

=
(
0
if 1 ∈J or 2 ∈J
1
4
otherwise,
and, hence,
ν(J) =
(
−1
2
if J = ∅or J = {3},
0
otherwise.
As Shap(i) = EJ∼Πi[ν(J ∪{i}) −ν(J)], we compute
Shap(1) =
1
3 ·
 ν({1}) −ν(∅)

+ 1
6 ·
 ν({1, 2}) −ν({2})

+ 1
6 ·
 ν({1, 3}) −ν({3})

+ 1
3 ·
 ν({1, 2, 3}) −ν({2, 3})

= 1
3 ·
 0 −(−1
2)

+ 1
6 ·
 0 −0

+ 1
6 ·
 0 −(−1
2)

+ 1
3 ·
 0 −0

= 1
4.
Similarly, we obtain Shap(2) = 1
4 and Shap(3) = 0, meaning that the ﬁrst two parameters
are of equal importance, whereas the last parameter has no impact with respect to NegDiﬀ
and p∗= (1, 1, 1) under the uniform distribution.
For general n and uniform Γ, we observe the same behavior for the Shap scores, as
Shap(1) = Shap(2) =
(n−1)2
2n
and Shap(3) = 0.
Instead of going through the whole
computation again, we can get this directly by exploiting the symmetry axiom for parameters
y1 and y2, the null player axiom for y3, and the observation that ν(∅) = (−n) · (n−1)2
n2
and
ν({1, 2, 3}) = 0, which means that the sum of the Shapley values of the three parameters is
(n−1)2
n
by the eﬃciency axiom.
⌟

---

THE IMPORTANCE OF PARAMETERS IN DATABASE QUERIES ∗
13
3.3. Formal Problem Statement. We now have all the ingredients to formulate the com-
putation of Shap scores as a formal computational problem. It can be phrased concisely as
follows.
Problem 3.7. SHAP(Q, P, s) is the following computational problem:
On input (Q, p∗, D, Γ), compute Shap(i) for all i ∈[ℓ].
⌟
Table 1 presents an overview of the problem speciﬁcations and inputs. For technical
reasons (which we explain next), the problem is parameterized with a class of parameterized
queries Q, a class of parameter distributions P, and a (class of) similarity function(s) s.
Table 1. Problem speciﬁcations and inputs for Shap score computation.
Problem speciﬁcations
Problem inputs
Q
class of parameterized queries
Q(R; P )∈Q
parameterized query
P
class of parameter distributions
D ∈DB[In(Q)]
database
s
similarity function
p∗= (p∗
1, . . . , p∗
ℓ) ∈P
reference parameter
Γ ∈PP , Γ(p∗) > 0
parameter distribution
Parameter distributions. For simplicity, we only consider parameter distributions with
ﬁnite support and rational probabilities.
A class of parameter distributions will always
mean a class P = S
P PP where P are relation schemas, and PP is a set of functions
Γ : Tup[P ] →[0, 1] such that P
p Γ(p) = 1.
One of the simplest classes of parameter distributions is the class PIND of fully factorized
distributions, where all parameters are stochastically independent.
Deﬁnition 3.8. A probability distribution Γ over Tup[P ] is called fully factorized if
Γ(p1, . . . , pℓ) = Γ1(p1) · . . . · Γℓ(pℓ)
for all (p1, . . . , pℓ) ∈Tup[P ] where Γi is the marginal distribution of pi under Γ. To represent
Γ, it suﬃces to provide the ℓlists of all pairs (pi, Γi(pi)) where Γi(pi) > 0.
⌟
Technically, P is a class of representations of probability distributions in our the SHAP
problem. For convenience, we do not distinguish between a distribution and (one of) its
representation.
Similarity functions. In Problem 3.7, the deﬁnition of the SHAP problem, we chose to ﬁx
the similarity function s as part of the problem speciﬁcation. Diﬀerent similarity functions
greatly diﬀer in their behavior and complexity, and since there is no clear, uniform way of
encoding such functions, it is inconvenient to have them as an input to the problem.
For SHAP(Q, P, s), s is technically a collection of functions sR for every output schema
Out(Q) for queries in Q, rather than a single function. We later abuse notation and just
write s(T1, T2) instead of sR(T1, T2) if T1 and T2 are relations over schema R.
Parameterized queries. The parameterized queries we consider are formulated in ﬁrst-
order logic, unless explicitly stated otherwise. The encoding size of Qp can be larger than
that of the parameterized query Q.
By our assumptions on Γ, this blow-up is at most
polynomial in ∥Q∥and ∥Γ∥if p ∈supp(Γ).

---

14
A. GILAD, M. GROHE, B. KIMELFELD, P. LINDNER, AND C. STANDKE
Complexity. We abuse notation and use s ◦Q to denote the class of functions mapping
(Q, p, p∗, D) to s(Qp(D), Qp∗(D)) where Q = Q(R; P ) ∈Q, where D ∈DB[In(Q)], and
where p, p∗∈Tup[P ].
Deﬁnition 3.9. Let Q be a class of parameterized queries, s a similarity function. We call
• Q tractable, if (Q, p, D) 7→Qp(D) can be computed in polynomial time.
• s tractable, if (T1, T2) 7→s(T1, T2), can be computed in polynomial time.
• s ◦Q tractable, if (Q, p, p∗, D) 7→s(Qp(D), Qp∗(D)) can be computed in polynomial time.
⌟
Tractability of both s and Q imply tractability of s ◦Q, but the converse is not true
in general (see [GS89]). For illustration of this phenomenon, consider the query answering
problem for (non-parameterized) acyclic conjunctive queries without quantiﬁcation: The
query answer may be exponentially large, but the answer count can be computed eﬃciently
[PS13, Theorem 1].
Deﬁnition 3.10. Let Q be a class of parameterized queries, P a class of parameter distri-
butions, and s a similarity function, and let C be a complexity class.
• If the complexity of solving SHAP(Q, P, s), as a function of ∥Q∥+ ∥p∗∥+ ∥D∥+ ∥Γ∥, is
in C, then we say that SHAP(Q, P, s) is in C in combined complexity.
• If for every ﬁxed Q ∈Q, the complexity of solving SHAP({Q}, P, s), as a function of
∥p∗∥+ ∥D∥+ ∥Γ∥, is in C, then we say that SHAP(Q, P, s) is in C in data complexity.
⌟
That is, we discuss the computational complexity in terms of variants of the classical
combined, and data complexity [Var82]. If not indicated otherwise, our statements about
the complexity of SHAP(Q, P, s) always refer to combined complexity.
4. General Insights for Fully Factorized Distributions
We ﬁrst discuss fully factorized distributions. We start by showing that for tractable similar-
ity functions, tractability of SHAP(Q, PIND, s) in terms of data complexity is guided by the
data complexity of Q. This contrasts other query evaluation settings involving probabilities,
like query evaluation in probabilistic databases [SORK11, VdBS17]. The intuitive reason is
that here, the probability distributions are tied to the parameterized query instead of the
database.
Proposition 4.1. Let s be a tractable similarity function and let Q(R; P ) be a ﬁxed parame-
terized query such that Qp(D) can be computed in polynomial time in ∥D∥for all p ∈Tup[P ].
Then SHAP({Q}, PIND, s) can be solved in polynomial time.
Proof. Let Q(R; P ) be a ﬁxed parameterized query, and let (p∗, D, Γ) be an input to
SHAP({Q}, PIND, s), where s is a tractable similarity function. As Q is ﬁxed, the number ℓ
of parameter positions in Q is constant. This means that
(a) the probability spaces Πi, i ∈[ℓ], are of constant size, and
(b) |supp(Γ)| is at most polynomial in ∥Γ∥(and can be computed in polynomial time in
∥Γ∥).
By (b), and since s is tractable, we can compute
E
p∼Γ

s(p, p∗)
 pJ = p∗
J

=
X
p∈supp(Γ)
s(p, p∗) · Pr
p′∼Γ
 p′ = p
 p′
J = p∗
J


---

THE IMPORTANCE OF PARAMETERS IN DATABASE QUERIES ∗
15
in polynomial time in ∥Γ∥+ ∥p∗∥+ ∥D∥for all J ⊆[ℓ] by brute force. By (a), computing
Shap(i) by evaluating (2.3) takes, at most, time polynomial in ∥Γ∥+ ∥p∗∥+ ∥D∥.
For this reason, in the remainder of the paper, we will focus on the combined complexity
of the computation of SHAP(Q, PIND, s).
Next, we point out two relationships with other computational problems. First, we see
that SHAP(Q, PIND, s) is at least as hard as deciding whether the output of a parameter-
ized query is non-empty. To be precise, let Q be a class of parameterized queries and let
NONEMPTY(Q) be the problem that takes inputs (Q, p∗, D), and asks to decide whether
Qp∗(D)̸ = ∅. In order to establish a relationship to the SHAP(Q, PIND, s) problem, we need
two more ingredients.
Deﬁnition 4.2. A similarity function s is left-sensitive, if for all possible output schemas
R, one of the following is satisﬁed:
(s1) for all non-empty T ∈Rel[R] we have sR(∅, ∅)̸ = sR(T, ∅); or
(s2) for all non-empty T ∈Rel[R] we have sR(∅, T)̸ = sR(T, T).
⌟
Most natural similarity functions satisfy these, or at least one of these conditions. For
example, all the similarity functions from Examples 3.2(a)–(c) satisfy (s2), whereas a version
of NegDiﬀthat swaps the roles of Q and Q∗would always satisfy (s1).
As a special case, we will also consider classes of Boolean parameterized queries. If R
is a Boolean relation schema, then the only possible inputs to a similarity function sR are
pairs of true and false. In particular, sR is always tractable. In addition, the properties from
Deﬁnition 4.2 become
(s1′) sR(false, false)̸ = sR(true, false) for (s1);
(s2′) sR(false, true)̸ = sR(true, true) for (s2).
This means for Boolean relational schemas R that sR is left-sensitive if and only if it is
dependent on its ﬁrst argument: there are x1, x2 and y such that sR(x1, y)̸ = sR(x2, y).
This condition is necessary for a meaningful notion of Shap scores: if it does not hold, then
sR is determined by its second argument and hence the Shap score w.r.t. to sR is always 0.
Theorem 4.3. Let s be left-sensitive. Let Q be a class of parameterized queries such that for
all Q(R; P ) ∈Q there exists i0 ∈[ℓ] (which we can ﬁnd in polynomial time) such that, for all
D ∈DB[In(Q)] and all p = (p1, . . . , pℓ) ∈Tup[P ] with pi0 /∈adom(D), we have Qp(D) = ∅.
Then NONEMPTY(Q) ≤P
T SHAP(Q, PIND, s).
The restriction imposed on Q in Theorem 4.3 expresses that for every Q ∈Q, one of
the parameters of Q immediately renders the query result on any D empty, if it is chosen
outside the active domain of D, and that this parameter can easily be identiﬁed. This is
fulﬁlled, for example, for unions of conjunctive queries for which there exists a parameter
that appears in each of its conjunctive queries, and can be extended to Datalog queries for
which there exists a parameter that appears in the body of every rule.
Proof. Let Q and s be given as in the statement.
Let (Q(R; P ), p∗, D) be an input of
NONEMPTY(Q) with p∗= (p∗
1, . . . , p∗
ℓ).
Without loss of generality, let i0 = 1.
First,
assume that s = sR satisﬁes property (s1).
Fix some a /∈adom(D) ∪{p∗
1} and let pa = (a, p∗
2, p∗
2, . . . , pℓ). Then Qpa(D) = ∅. Let
Γ be the parameter distribution over Tup[P ] with Γ(p∗) = Γ(pa) = 1
2. Then Γ ∈PIND,
because it factorizes into the marginal distributions (Γj)j∈[ℓ] where Γ1(p∗
1) = Γ1(a) = 1
2 and
Γ2(p∗
2) = · · · = Γℓ(p∗
ℓ) = 1.

---

16
A. GILAD, M. GROHE, B. KIMELFELD, P. LINDNER, AND C. STANDKE
We consider the SHAP(Q, PIND, s) instance (Q, pa, D, Γ). Let J ⊆[ℓ] be arbitrary. If
1 ∈J, then Prp∼Γ(p = pa  pJ = pa
J) = 1 and, hence,
E
p∼Γ[s(p, pa)
 pJ = pa
J] = s(Qpa(D), Qpa(D)) = s(∅, ∅).
If 1 /∈J, then Prp∼Γ(p = pa  pJ = pa
J) = Prp∼Γ(p = p∗ pJ = pa
J) = 1
2, and, therefore,
E
p∼Γ

s(p, pa)
 pJ = pa
J

= 1
2s
 Qp∗(D), ∅

+ 1
2s(∅, ∅).
Thus, by (2.3), we have Shap(1) = 1
2(s(∅, ∅) −s(Qp∗(D), ∅). Since s satisﬁes (s1), we get
Shap(1) = 0 ⇔Qp∗(D) = ∅.
(4.1)
That is, we can decide Qp∗(D) = ∅, by solving the SHAP(Q, PIND, s) instance (Q, pa, D, Γ).
The proof is analogous for the case that s = sR satisﬁes condition (s2) instead of (s1).
In this case, we use the SHAP(Q, PIND, s) instance (Q, p∗, D, Γ) with the same distribution Γ
as above. This leads to Shap(1) = 1
2(s(p∗, p∗) −s(pa, p∗)) and, thus, by (s2), to (4.1).
Van den Broeck et al. [VdBLSS22] have shown a reduction from computing Shap to
computing the expected similarity. The latter problem, ESIM(Q, P, s), takes the same pa-
rameters and inputs as SHAP(Q, P, s), but asks for Ep∼Γ[s(p, p∗)] instead of Shap(i).
Theorem 4.4 [VdBLSS22, Theorem 2]. For any class of parameterized queries Q and any
similarity function s such that s ◦Q is tractable, SHAP(Q, PIND, s) ≡P
T ESIM(Q, PIND, s).
Remark 4.5. The paper [VdBLSS22] discusses a more general setting, in which Shap scores
are computed for tractable functions F over ℓ-ary domains. They provide an algorithm that
computes Shap scores of F using oracle calls to the expected value of F with diﬀerent
parameter distributions Γ ∈PIND. This algorithm runs in polynomial time in ∥Γ∥and is
independent of the choice of F (apart from the oracle, of course). For our version of the
theorem, we use this algorithm on functions FQ,p∗,D(p) = s(Qp(D), Qp∗(D)).
⌟
The key property we needed for Proposition 4.1 was the manageable size of the param-
eter distributions. This can be formulated as a property of a class of queries.
Deﬁnition 4.6. Let Q(R; P ) be a parameterized query and D ∈DB[In(Q)], and denote
psupp(Q, D) := {p ∈Tup[P ]: Qp(D)̸ = ∅}.
A class Q of parameterized queries has
polynomially computable parameter support if there exists a polynomial time algorithm (in
∥Q∥+ ∥D∥) which, on input Q(R; P ) ∈Q and D ∈DB[In(Q)], outputs a set P(Q, D) ⊇
psupp(Q, D).
⌟
There are simple, yet relevant classes with this property, e.g., parameterized CQs with
a bounded number of joins, or where parameters only appear in a bounded number of atoms.
This property allows the eﬃcient computation of expected similarities.
Proposition 4.7. Let Q have polynomially computable parameter support, and suppose s◦Q
is tractable. Then SHAP(Q, PIND, s) can be solved in polynomial time.
Proof. Let (Q, p∗, D, Γ) be an input to SHAP(Q, PIND, s).
As Q has polynomially com-
putable parameter support, we can eﬃciently compute a set P = P(Q, D) ⊇psupp(Q, D).
Then
E
p∼Γ

s(Qp(D), Qp∗(D))] =
X
p∈P
Γ(p) · s(Qp(D), Qp∗(D)) +
 1 −Γ(P)

· s(∅, Qp∗(D)).

---

THE IMPORTANCE OF PARAMETERS IN DATABASE QUERIES ∗
17
This value can be computed in polynomial time: As s ◦Q is tractable, all function values
of s in this formula can be computed eﬃciently. Moreover, since P is of polynomial size,
Γ(P) = P
p∈P Γ(p) can be computed eﬃciently. Thus, ESIM(Q, PIND, s) can be solved in
polynomial time. This transfers to SHAP(Q, PIND, s) by Theorem 4.4.
5. Parameterized Conjunctive Queries with Independent Parameters
The goal of this section is to identify concrete classes of queries and similarity functions on
which the problem of Shap score computation becomes tractable. Theorem 4.3 suggests that
we should restrict our attention to query classes that are tractable in combined complexity.
A natural class of such queries are subclasses of acyclic conjunctive queries.
Recall that the parameters in a parameterized query take an intermediate role between
being treated as variables (we allow the parameters to take diﬀerent values) and constants (in
the queries we are really interested in, each parameter will be replaced by a ﬁxed parameter
value). This makes the deﬁnition of acyclicity ambiguous, as it is not clear, whether the
parameters should appear as vertices in the query hypergraph or not. However, a simple
complexity-theoretic argument shows that the structure induced by the parameters should
not be ignored.
Proposition 5.1. Consider the class Qclique of parametrized conjunctive queries of the form
Qℓ(; y1, . . . , yℓ) =
ℓ^
i=1
V (yi) ∧
^
1≤i<j≤ℓ
E(yi, yj)
with ℓ∈N and let s be left-sensitive. Then, SHAP(Qclique, PIND, s) is #P-hard.
Proof. First, we observe that Qclique is tractable since Qp only contains constants. Thus,
s◦Q is tractable, and we show that computing ESIM(Qclique, PIND, s) is #P-hard by reduction
from #Clique and obtain the desired result by Theorem 4.4. The problem #Clique, given
an undirected graph G = (VG, EG) and a natural number k, asks for the number of cliques
of size k in G.
Now, given G and k, we ﬁrst construct a new graph G′ = (VG′, EG′) as follows: VG′
contains all vertices of VG, and k new vertices v′
1, . . . , v′
k. If s fulﬁlls (s1′), then EG′ := EG.
If s does not fulﬁll (s1′) but (s2′), then EG′ := EG ∪{(v′
i, v′
j) : i̸ = j}. In both cases, we can
easily deduce the number of k-cliques in G from the number of k-cliques in G′.
To deﬁne D, let V be a unary relation consisting of the vertices in VG′, and let E be a
binary relation consisting of both orientations of edges in EG′. Let Q = Qk, each Γi be a
uniform distribution over the vertices in VG′, and let p∗= (v′
1, . . . , v′
k). Then Qp(D) = true
if and only if the vertices p1, . . . , pk are pairwise distinct and form a clique in G′. For each
clique in G′, each of the k! permutations of the set of clique vertices forms a parameter
vector p with Qp(D) = true. As all (n + k)k mappings from (y1, . . . , yk) to VG′ have the
same probability, in the case of s fulﬁlling (s1′), we obtain:
E
p∼Γ

s(p, p∗)

· (n + k)k = #(k-cliques in G′) · k! · s(true, false)
+
 (n + k)k −#(k-cliques in G′) · k!

· s(false, false),

---

18
A. GILAD, M. GROHE, B. KIMELFELD, P. LINDNER, AND C. STANDKE
which is equivalent to
#(k-cliques in G′) = (n + k)k Ep∼Γ

s(p, p∗)

−s(false, false)

k!
 s(true, false) −s(false, false)

.
For the other case, we only need to swap the second arguments of s from false to true
so in each of the cases, we can eﬃciently compute the number of k-cliques in G from
Ep∼Γ

s(p, p∗)

.
From Proposition 5.1, we see that the structure induced by the parameters may have
a big impact on the computational complexity of the problem. If we choose not to include
the parameter structure in our notion of acyclicity of parameterized queries, the query
hypergraph of each query in Qclique would be empty, and, in particular, acyclic. However, by
Proposition 5.1, computing Shap scores is hard for this class. This motivates the following
deﬁnition.
Deﬁnition 5.2. We call a parameterized query Q p-acyclic (or, a pACQ), if its parameter-
including query hypergraph is acyclic. Put diﬀerently, Q is p-acyclic, if it is acyclic (in the
traditional sense) when parameters are just treated as variables.
⌟
Example 5.3. Consider the parameterized CQ
Q(x; y1, y2) = R(x, y1) ∧U(y1, y2) ∧V (y2, x).
The queries Qp are acyclic for every choice of parameter values p. However, Q is not
p-acyclic since the (non-parameterized) query
Q′(x, x1, x2) = R(x, x1) ∧U(x1, x2) ∧V (x2, x)
is not acyclic. In contrast, the conjunctive query from Example 2.1 is p-acyclic.
⌟
If the employed similarity function is based on counting tuples in the query output, a
relationship between Shap score computation for pACQs and the problem of (weighted)
counting of answers to ACQs can be drawn. A central insight for the latter problems is,
intuitively, that projection (i.e., the presence of existential quantiﬁcation) easily renders
them intractable, while tractability can be obtained for full ACQs (see [PS13] and [DM14]).
In the remainder of this section, we observe a similar phenomenon for the problem of Shap
score computation: First, we establish #P-hardness for a simple class of star-shaped ACQs
as in [PS13, Theorem 4] (with non-trivial similarity functions). Next, we contrast this by
a tractability result for full pACQs for certain similarity functions based on counts, by
leveraging results of [PS13, Theorem 1] and [DM14, Corollary 4].
Proposition 5.4. Let Q be the class of Boolean parameterized queries of the form
Q(; y1, . . . , yℓ) = ∃x: R1(x, y1) ∧· · · ∧Rℓ(x, yℓ)
(5.1)
with ℓ∈N and let s be left-sensitive. Then SHAP(Q, PIND, s) is #P-hard.
Proof. Let Q and s be given as described in the statement. Then Q is tractable: to answer Qp
on a database D ∈In(Q), it suﬃces to scan the relations of D from R1 to Rℓwhile keeping
track of a set of good values for x. However, Q does not have polynomially computable
parameter support already if every yj can take at least two possible values.
From the
tractability of Q, it follows that s ◦Q is tractable.
We show that computing ESIM(Q, PIND, s) is #P-hard by reduction from #posDNF
which, given a positive formula in disjunctive normal form, asks for the number of satisfying

---

THE IMPORTANCE OF PARAMETERS IN DATABASE QUERIES ∗
19
assignments. This problem is #P-hard ([PB83]) and we then obtain the desired result from
Theorem 4.4.
Let ϕ be a positive DNF formula in propositional variables X1, . . . , Xℓwith disjuncts
ϕ1, . . . , ϕn. Deﬁne
D =

Ri(j, 1): i ∈[ℓ] and j ∈[n]
	
∪

Ri(j, 0): i ∈[ℓ] and Xi does not appear in ϕj
	
,
and let Q be the parameterized query from (5.1). Moreover, let Γi(0) = Γi(1) = 1
2 for all
i ∈[ℓ], and let Γ ∈PIND be the product distribution of Γ1, . . . , Γℓ.
Every p ∈{0, 1}ℓcorresponds to a truth assignment αp of X1, . . . , Xℓvia αp(Xi) = true
if pi = 1, and αp(Xi) = 0 if pi = 0, for all i ∈[ℓ].
We claim Qp(D) = true if and only if αp(ϕ) = true. If this claim holds, we are done:
Suppose that s satisﬁes (s2′), i.e., s(false, true)̸ = s(true, true), and let p∗= (1, . . . , 1). (If s
only satisﬁes (s1′), then the proof is done similarly with p∗= (0, . . . , 0).) We obtain
E
p∼Γ

s(p, p∗)

= #ϕ
2ℓ· s(true, false) +

1 −#ϕ
2ℓ

· s(false, false),
where #ϕ denotes the number of satisfying assignments of ϕ. Hence, #ϕ can be computed
eﬃciently from Ep∼Γ

s(p, p∗)

.
It only remains to prove our claim: Qp(D) = true if and only if αp(ϕ) = true, for all
p = (p1, . . . , pℓ) ∈{0, 1}ℓ. Fix an arbitrary p ∈{0, 1}ℓ.
If Qp(D) = true, there exists j ∈[n] such that D ⊇{R1(j, p1), R2(j, p2), . . . , Rℓ(j, pℓ)}.
For those i with pi = 0, by deﬁnition of D, the variable Xi does not appear in ϕj. Hence, if
pi = 1, then Xi appears in ϕj. Therefore, αp(ϕj) = true, so αp satisﬁes ϕ.
For the other direction, let αp(ϕ) = true. Then αp satisﬁes a disjunct, say, ϕj. By
deﬁnition, D contains Ri(j, pi) for all i ∈[ℓ] with pi = 1. If pi = 0, then Xi cannot appear
in ϕj (since αp(ϕj) = true) and, hence, D contains Ri(j, pi). Together, Qp(D) = true.
Remark 5.5. This, and our remaining hardness results, are stated for the class PIND of
fully factorized distributions. Inspection of our proofs, however, reveals that these hardness
results hold even for the much more restricted subclass of PIND where every parameter takes
one of two possible values with probability 1
2.
⌟
Next, we show a tractability result for parameterized full ACQs.
In contrast, by
Proposition 5.4, even a single existential quantiﬁer can make the problem diﬃcult. A simi-
lar observation has been made for the (weighted) counting for ACQ answers [PS13, DM14]
(which we use to establish tractability here).
Proposition 5.6. Let Q be the class of full pACQs, and let s be any of Int, NegSymDiﬀ,
or NegDiﬀ. Then SHAP(Q, PIND, s) can be solved in polynomial time.
Remark 5.7. The previous proposition is stated for speciﬁc similarity functions s because
it does not hold for arbitrary similarity functions. For example, computing Shap scores
for MinDiﬀA,B and ExpMinDiﬀA,B are #P-hard on full pACQs as they may project out
variables, so we mimic the proof of Proposition 5.4 to obtain #P-hardness on queries of the
form Q(x1, x2, x3) = S(x1, x2) ∧R1(x3, y1) ∧. . . ∧Rℓ(x3, yℓ) where Q.A and Q.B attributes
corresponding to x1 and x2, respectively.
⌟
Before we come to the proof of Proposition 5.6, let us do some preparation. We introduce
an artiﬁcial “similarity” function Count with Count(T1, T2) = |T1| for all T1, T2 ∈Rel[R].

---

20
A. GILAD, M. GROHE, B. KIMELFELD, P. LINDNER, AND C. STANDKE
Then for all parameterized queries Q(R; P ), all p ∈Tup[P ], and D ∈DB[In(Q)] we have
NegSymDiﬀ(p, p∗) = 2 · Int(p, p∗) −Count(p, p∗) −|Qp∗(D)|,
NegDiﬀ(p, p∗) = Int(p, p∗) −Count(p, p∗),
where again s(p, p∗) is shorthand for s(Qp(D), Qp∗(D)). The value −|Qp∗(D)| is a constant
additive term (depending neither on p nor on J) in every utility value ν(J) for NegSymDiﬀ,
and therefore cancels out in the Shapley value. For all i ∈[ℓ], linearity of expectation yields
ShapNegSymDiﬀ(i) = 2 · ShapInt(i) −ShapCount(i),
ShapNegDiﬀ(i) = ShapInt(i) −ShapCount(i).
Hence, the tractability for NegSymDiﬀand NegDiﬀfollows, once we have established the
tractability for both Count and Int.
In the proof of Proposition 5.6 we will use a reduction to the weighted answer counting
problem for ACQs, denoted by #wACQ: A #wACQ instance is a triple (Q′, D′, w), con-
sisting of a (non-parameterized) ACQ Q′, a database D′, and a weight function w on the
domain elements. The problem consists in computing the sum of the values w(a1, . . . , an) =
Q
i∈[n] w(ai), for all (a1, . . . , an) that fulﬁll D′ |= Q′(a1, . . . , an).
Proof of Proposition 5.6. We ﬁrst show tractability of SHAP(Q, PIND, Count).
By [PS13,
Theorem 1], Count ◦Q is tractable. Hence,
SHAP(Q, PIND, Count) ≡P
T ESIM(Q, PIND, Count)
by Theorem 4.4, and it suﬃces to show that ESIM(Q, PIND, Count) can be computed in
polynomial time.
We ﬁrst show that from an ESIM(Q, PIND, Count) instance (Q, p∗, D, Γ), we can con-
struct, in polynomial time, a #wACQ instance (Q′, D′, w) such that
E
p∼Γ

|Qp(D)|

=
X
a: D′|=Q′(a)
w(a),
(5.2)
where Q′ is a full ACQ. Since, by [DM14, Corollary 4], #wACQ can be solved in polynomial
time for the class of full ACQs, this claim entails tractability of ESIM(Q, PIND, Count).
So let (Q, p∗, D, Γ) be an instance of ESIM(Q, PIND, Count), where Q = Q(x; y) with
parameter variables y = (y1, . . . , yℓ). We now deﬁne an input (Q′, D′, w) of #wACQ as
follows:
• For every i ∈[ℓ], let Ri be a new binary relation symbol, and let y′
i be a new variable.
Deﬁne
Q′(x, y, y′) = Q ∧R1(y1, y′
1) ∧· · · ∧Rℓ(yℓ, y′
ℓ).
This is a normal relational query with variables x, y and y′. Since Q is a full pACQ,
Q′ is a full ACQ (the hypergraph of Q′ diﬀers from that of Q by having ℓadditional,
independent ears).
• For all i ∈[ℓ] let Ai be the set of active domain elements a of D such that there exists an
R-atom in Q, and an R-tuple t in D, such that a appears in t in the same position as yi
appears in the R-atom of Q. For every a ∈Ai, we introduce a new domain element a(i),
and let
D′ = D ∪

Ri(a, a(i)): a ∈Ai, i ∈[ℓ]
	
.
• We deﬁne a weight function w on domain elements by letting w(a(i)) = Γi(a) for all a ∈Ai
and i ∈[ℓ]. We let w(a) = 1 for all other a.

---

THE IMPORTANCE OF PARAMETERS IN DATABASE QUERIES ∗
21
For our claim, it remains to show that (5.2) holds.
The output schema of Q′ is Out(Q′) = R × P × P ′. The elements of Tup[P ′] are tuples
of the shape (p(1)
1 , . . . , p(ℓ)
ℓ) for (p1, . . . , pℓ) ∈Tup[P ]. We let α be the function that maps
(p1, . . . , pℓ) ∈A1 × · · · × Aℓto (p(1)
1 , . . . , p(ℓ)
ℓ). Let
S =

(c, p, p′) ∈Tup[Out(Q′)]: D′ |= Q′(c, p, p′)
	
.
Then from the construction of Q′ and D, it follows that for all (c, p, p′) ∈S, we have
p ∈A1 × · · · × Aℓand p′ = α(p). Further, for all p ∈Tup[P ], we deﬁne
Sp =

c ∈Tup[R]: (c, p, α(p)) ∈S
	
,
and, moreover, let P := {p ∈Tup[P ]: Sp̸ = ∅}.
Generally, for all c ∈Tup[R] and all p ∈P, we have
D |= Qp(c) ⇔D′ |= Q′ c, p, α(p)

⇔c ∈Sp.
(If p /∈P, then both Qp(D) and Sp are empty.) We obtain
|Sp| = |{c ∈Tup[R]: D |= Qp(c)}| = |Qp(D)|.
Now, we calculate
X
(c,p,p′)∈S
w(c, p, p′) =
X
p∈P
w(α(p))
X
c∈Sp
w(p) · w(c)
|
{z
}
=1
=
X
p∈P
Γ(p) · |Sp|
=
X
p∈P
Γ(p) · |Qp(D)| = E
p∼Γ

|Qp(D)|

.
As per our discussion from before, this establishes tractability for SHAP(Q, PIND, Count).
For Int, we reduce to SHAP(Q, PIND, Count) as follows.
For a given pACQ Q, and
reference parameter p∗, we deﬁne
Q∩(x; y) := Q(x; y) ∧Qp∗(x).
Since Q is a full pACQ, so is Q∩: The hypergraph for Q∩contains all the hyperedges of
the hypergraph of Q, and from the second conjunct we additionally get subhyperedges of
hyperedges of Q. In the hypergraph of Q∩, the latter are thus immediately ears and can be
removed by the GYO algorithm [Gra79, YO79]. Since Q is a full pACQ, this entails that so
is Q∩. Moreover, we have
Int(Qp(D), Qp∗(D)) =
Qp(D) ∩Qp∗(D)
 =
Q∩
p(D)
 = Count(Q∩
p(D), Q∩
p∗(D)).
Thus, the Shap scores for (Q, p∗, D, Γ) using Int coincide with those of (Q∩, p∗, D, Γ) using
Count. The remaining claims follow, since the associated Shap scores are multilinear in
those of Int and Count.
The tractability in Proposition 5.6 for Int may seem surprising, given that [DM14, Propo-
sition 5] states that counting the answers in the intersection of two full ACQs is #P-complete.
However, the queries we intersect in our proof are of a very special shape, as they only con-
cern diﬀerent parameterizations of the same parameterized query, one of them being ﬁxed.
From this we get that our intersection query is acyclic too. When two arbitrary acyclic
queries are intersected like this, acyclicity can be lost.

---

22
A. GILAD, M. GROHE, B. KIMELFELD, P. LINDNER, AND C. STANDKE
Table 2. Further examples of ﬁlters
Filter concept
Examples
(Linear) (in)equalities
f(x) = [x = c]
f(x, y) = [x ≤y]
f(x1, x2, y) = [x1 + 2x2 ≥y]
Other comparisons
f(x, y) = true if and only if x and y are
strings with the same ﬁrst character
Views
f(x1, x2) = true if and only if the input
satisﬁes ¬∃z : R(x1, z) ∧R(z, x2)
6. Extending Conjunctive Queries with Filters
In this section we investigate parameterized conjunctive queries Q which contain conjuncts of
the shape f(x, y), called ﬁlters, where for every valuation (a, b) of (x, y), we have f(a, b) ∈
{true, false}. This value may depend on the input database D on which Q is evaluated.
Deﬁnition 6.1. A parameterized CQ with ﬁlters is an expression of the shape
Q(xf; y) = ∃xb : α1(x1, y1) ∧· · · ∧αn(xn, yn) ∧f1(x′
1, y′
1) ∧· · · ∧fm(x′
m, y′
m),
(6.1)
where
• xf and xb are all variables in the query (bound or free), hence, all xi and all x′
j consists
of variables appearing among xf or xb;
• y is the tuple of all parameters in the query, hence, all yi and all y′
j consist of parameters
from y;
• each αi(xi, yi) is a relational atom containing the variables xi and the parameters in yi
(and no other variables or parameters); and
• all variables x appearing among x′
1, . . . , x′
m are guarded by the relational part of the query,
i.e., appear among x1, . . . , xn.
⌟
We call Q a p-acylic CQ (or pACQ) with ﬁlters, if its query hypergraph (including the
parameters) is acyclic, when fi(x′
i, y′
i) is interpreted as a relation Fi(x′
i, y′
i). Moreover, we
say that a class Q of parameterized CQs with ﬁlters has uniformly tractable ﬁlters, if there
exist a constant r and a polynomial ϕ such that
• the arity of its ﬁlters is bounded r, and
• the function (x′, y′, D) 7→f(x′, y′) can be computed time ϕ
 ∥x′∥+ ∥y′∥+ ∥D∥

for every
ﬁlter f that appears among queries in Q.
Some examples of ﬁlters are shown in Table 2. For example, f(x, y) = true if and only
if x ≤y, is a ﬁlter. In practice, we would often just directly write x ≤y in our query
expressions, and write f = [x ≤y] for the ﬁlter.
Example 6.2. Let us revisit our ﬂights example (Example 2.1). Consider the following
parameterized query with ﬁlters, Q(x1, x2, tarr; d, tdep, Lmin, Lmax, T):
∃h, a1, a2, t1, t2 : Flights(x1, d, a1, CDG, h, tdep, t1) ∧Flights(x2, d, a2, h, JFK, t2, tarr)
∧(t1 + Lmin < t2) ∧(t2 < t1 + Lmax) ∧(tarr ≤T).

---

THE IMPORTANCE OF PARAMETERS IN DATABASE QUERIES ∗
23
This query is asking for 2-hop ﬂights between CDG and JFK. It is parameterized with the
date d, a desired departure time tdep, a desired layover time interval (Lmin, Lmax) and a latest
local arrival time T. It returns the ﬂight IDs f1, f2, as well as the intermediate stop h, and
the ﬁnal arrival time tarr.
The query has three ﬁlters making use of inequalities:
f1 = [t1 + Lmin<t2],
f2 = [t2 < t1 + Lmax],
f3 = [tarr ≤T].
To highlight that the concept of ﬁlters is rather general, imagine another ﬁlter stipulating
that the airlines a1 and a2 are from the same country. That is,
f(a1, a2) = true
if and only if
∃c: Airline(a1, c) ∧Airline(a2, c).
⌟
6.1. Parameter Importance in Conjunctive Queries with Filters. Our tractability
result from the previous section can be transferred to computing Shap scores for full pACQs
with uniformly tractable ﬁlters. The idea is simple: We just have to materialize the relations
represented by the ﬁlters, and apply Proposition 5.6.
Proposition 6.3. Let Q be a class of full pACQs with uniformly tractable ﬁlters, and let s be
any of Int, NegSymDiﬀ, or NegDiﬀ. Then SHAP(Q′, PIND, s) can be computed in polynomial
time.
Remark 6.4. Of course, this result relies on Proposition 5.6 and, in principle, also holds for
any similarity function to which Proposition 5.6 can be extended. In particular, it extends to
the artiﬁcial similarity function Count which was introduced for the proof of Proposition 5.6.
This will prove useful in the second part of this section.
⌟
Proof. Let (Q, p∗, D′, Γ) be an input to SHAP(Q, PIND, s) where s is one of Int, NegSymDiﬀ,
or NegDiﬀ. Suppose Q = Q(x; y) with x = (x1, . . . , xn) and y = (y1, . . . , yℓ).
We construct a pACQ Q′ without ﬁlters by replacing every fi(x′
i, y′
i) with a relational
atom Fi(x′
i, y′
i), where Fi is a new relation symbol. Then, by deﬁnition, Q′ is a full pACQ.
Next, we construct a new database instance D′ which materializes the relevant tuples
which pass every ﬁlter:
D′ := D ∪
m
[
i=1

Fi(a, b) : fi(a, b) = true and
a is a valuation of x′
i over the active domain of D and
b is a valuation of y′
i over S
j∈[ℓ] supp(Γj)
	
The database D′ can be computed in time polynomial in ∥Q∥+ ∥D∥+ ∥Γ∥because Q has
uniformly tractable ﬁlters: By the bounded arity of the ﬁlters, there are only polynomially
many tuples a and b to consider in the construction of D′, and we can evaluate fi(a, b) = true
for every such tuple in polynomial time as well.
Let p = (p1, . . . , pℓ) ∈Tup[P ] have positive probability in Γ. Recall that if fi(x′
i, y′
i)
is a ﬁlter in Q, then all variables of x′
i appear among the relational atoms of Q. Hence, if
a ∈Qp(D), then a consists of constants appearing in D. Because D′ coincides with D on
the relations which are present in Q, this also holds for all a ∈Q′
p(D′).
Moreover, by construction, for any valuation a of x′
i over the active domain of D, we
have that fi(a, p′
i) = true if and only if Fi(a, p′
i) holds in D′. Hence, Qp(D) = Q′
p(D′).
Therefore, (Q′, p∗, D, Γ) and (Q′, p∗, D′, Γ) yield the same Shap scores. Since Q′ is a full
pACQ, the claim follows from Proposition 5.6.

---

24
A. GILAD, M. GROHE, B. KIMELFELD, P. LINDNER, AND C. STANDKE
Again, projection can easily complicate computation. In Proposition 5.4, we have seen
a class of very simple star-shaped pACQs (without ﬁlters) on which computing Shap scores
becomes hard. With ﬁlters, even very simple inequality ﬁlters, this may already happen
when there is only a single relational atom apart from the ﬁlters.
Proposition 6.5. Let Q be the class of pACQs with ﬁlters of the shape
Q(; y1, . . . , yℓ) = ∃x1, . . . , xℓ: R(x1, . . . , xℓ) ∧(x1 ≤y1) ∧· · · ∧(xℓ≤yℓ).
(6.2)
with ℓ∈N, and let s be left-sensitive. Then SHAP(Q, PIND, s) is #P-hard.
Proof. The class Q above is tractable: To answer Qp on D, it suﬃces to check, for every
R(a1, . . . , aℓ) in D, whether ai ≤pi holds for all i ∈[ℓ]. However, Q does not have polyno-
mially computable parameter support. Tractability of Q implies tractability of s ◦Q, and
we can use Theorem 4.4 again to discuss ESIM(Q, PIND, s) instead of SHAP(Q, PIND, s).
Similar to the proof of Proposition 5.4, we show hardness by reduction from #posDNF.
Let ϕ be a positive DNF formula in propositional variables X1, . . . , Xℓwith disjuncts
ϕ1, . . . , ϕn. For all i ∈[n], let ai = (ai
1, . . . , ai
ℓ) ∈{0, 1}ℓwith
ai
j =
(
1
if Xj appears in ϕi,
0
otherwise,
(6.3)
for all j ∈[ℓ], and deﬁne D = {R(a1), . . . , R(an)}. Let Γj(0) = Γj(1) = 1
2 for all j ∈[ℓ], and
let Γ ∈PIND be the product distribution of Γ1, . . . , Γℓ. Moreover, let Q be the parameterized
query from (6.2). With every p ∈{0, 1}ℓwe associate a truth assignment αp that sets Xi
to true if and only if pi = 1, for all i ∈[ℓ].
We claim that, then, for all p ∈{0, 1}ℓ, we have Qp(D) = true if and only if αp(ϕ) = true.
Once this is established, we are done, since we can proceed exactly like in the proof of
Proposition 5.4. We therefore now just prove the claim.
First, suppose that αp is a satisfying assignment for ϕ. Then αp(ϕi) = 1 for some i ∈[ℓ].
In particular, pj = 1 whenever Xj appears in ϕi. By construction, ai
j ≤pj for all j ∈[ℓ].
As R(ai) ∈D, we have Qp(D) = true.
Second, suppose Qp(D) = true. Then one of the R(ai) in D satisﬁes ai
j ≤pj for all
j ∈[ℓ].
The positions j for which ai
j = 1 belong to the variables of ϕi and, from the
inequalities, we have pj = 1 for these positions j as well. This entails αp(ϕi) = 1, i.e., αp
satisﬁes ϕ.
Remark 6.6. In practice, inequality-based ﬁlters would typically be used for attributes
with continuous domains, like R. Continuous parameter values would require a treatment
of continuous parameter distributions. Our framework can handle continuous parameter
distributions as follows.
On the technical side, the deﬁnition of the Shap score needs to be changed to avoid
conditional probabilities. This is because for continuous parameter distributions, the events
pJ = p∗
J which appear as conditions in the deﬁnition of the Shap score always have probabil-
ity 0 for J̸ = ∅. However, for fully factorized distributions, this issue can be easily resolved,
since the distribution p[ℓ]\J is given by the factorization, independently of pJ.
On the algorithmic side, we can discretize the continuous distribution into intervals
deﬁned by the values in the database to obtain a discrete distribution with ﬁnite support
that yields the same output. This construction works for inequality ﬁlters such as in (6.2),
and many others, but, of course, not for all types of ﬁlters.
⌟

---

THE IMPORTANCE OF PARAMETERS IN DATABASE QUERIES ∗
25
6.2. Application: Why-Not Questions. In this section, we consider the application of
our framework to the problem of explaining why-not questions. A why-not question speciﬁes
a tuple t absent from the result set of a query Q, despite being expected to appear. A
prominent paradigm for answering such questions is the operator-based (or query-based)
model, where the explanation consists of query operators that contributed to the absence of
the tuple [CJ09b, BHT14, BHT15].
In the case of conjunctive queries (with projection), an explanation E is a collection
of Boolean operators from the query (what we later call “ﬁlters”) that invalidate all tuples
u whose projection is t, and, moreover, the removal of E leads to the survival of at least
one such u (hence t). Note that many explanations E may exist. Prior work studied the
generation of the latest explanation based on the query structure [CJ09b] or a representation
(via a polynomial) of the space of all all explanations [BHT14, BHT15]. The former is concise
but can be arbitrary and overly uninformative, and the latter gives the general picture but
can be overwhelming due to many explanations. We discuss a third and complementary
approach: assign to each operator an attribution score based on its contribution to the
absence of t. This gives a perspective that is general and yet concise. As usual, we adopt
the Shapley value as the scoring model for the contribution of an operator to a collective
operation.
To this aim, we take a step back and ﬁrst consider conjunctive queries with ﬁlters without
any kind of parameterization. The queries we consider are shaped as in Deﬁnition 6.1 but
without parameters (i.e., the parameter tuple y from (6.1) is empty), that is,
Q(xf) = ∃xb : α1(x1) ∧· · · ∧αn(xn) ∧f1(x′
1) ∧· · · ∧fm(x′
m),
(6.4)
requiring that all variables in x′
1, . . . , x′
m are guarded by the relational part, i.e., they all
also appear among x1, . . . , xn.
Given a database D and a conjunctive query Q with ﬁlters as above, any tuple t over
the output schema of Q but with t /∈Q(D) raises the why-not question “why does tuple t
not appear in Q(D)?”.
Example 6.7. Consider again the query Q of Example 6.2, but assume that the parameters
(d, tdep, Lmin, Lmax, T) have been turned into constants (d, tdep, Lmin, Lmax), i.e.,
Q(x1, x2, tarr): ∃h, a1, a2, t1, t2 : Flights(x1, d, a1, CDG, h, tdep, t1)
∧Flights(x2, d, a2, h, JFK, t2, tarr)
∧(t1 + Lmin < t2) ∧(t2 < t1 + Lmax) ∧(tarr ≤T).
Now let t be a why-not question, where we require that t /∈Q(D). The intermediate tuples
for t are, in this case, tuples in the self-join of Flights, and the intermediate tuples relevant
for t are those which project to t via the existential quantiﬁers. The “operators” causing such
intermediate tuples to disappear are our ﬁlters f1 = [t1+Lmin < t2] and f2 = [t2 < t1+Lmax]
and f3 = [tarr ≤T].
This way, the set of intermediate tuples with respect to t, and the set of operators is
uniquely determined. Rewriting our query, however, allows us to modify these notions: The
instantiation of variables with constants can also cause tuples to disappear, and we could
also start from a Cartesian product of Flights with itself to deﬁne the notion of intermediate
tuple. To analyze these eﬀects as well, we can choose to include them explicitly as ﬁlters.
Moreover, instead of two separate ﬁlters [t1 + Lmin < t2] and [t2 < t1 + Lmax], we could have
a single ﬁlter [t1 + Lmin < t2 < t1 + Lmax].

---

26
A. GILAD, M. GROHE, B. KIMELFELD, P. LINDNER, AND C. STANDKE
The ﬁlter f ∈{f1, f2, f3} contributes to the absence of t in the query output, if there is
an intermediate tuple relevant for t which does not satisfy the ﬁlter condition of f.
For example, any intermediate tuple relevant for t, in which we have t1 > t2, is removed
by either of the ﬁlters f1 and f2. Some of these intermediate tuples may, additionally, also
be removed by f3.
⌟
This highlights that multiple ﬁlters can aﬀect the presence of t, and they can do so
in diﬀerent ways.
In general, it can happen that every ﬁlter only removes some of the
intermediate tuples projecting to a given tuple t, but the collection of all ﬁlters removes all
of them. This interpretation of a joint contribution of a set of ﬁlters to the absence of t
naturally suggests modeling ﬁlters as players in a cooperative game. Subject to a suitable
utility function, the Shapley values of the ﬁlters then reveal their impact on the absence of
t in the query output. Answering why-not questions then becomes a problem of computing
Shapley values in this model. Next, we introduce and analyze this problem for two natural
utility functions.
6.2.1. A Cooperative Game for Why-Not Questions. Let Q be a CQ with ﬁlters, let D be a
database over In(Q) and let t be a tuple over Out(Q) such that t /∈Q(D). A cooperative
game for the ﬁlter contribution consists the set of players IQ, such that {fi : i ∈IQ} are
the ﬁlters appearing in Q, together with a utility function νQ,D,t assigning a real number to
each subset of IQ. If Q, D, and t are clear from the context, we omit the subscripts and
just write (I, ν) instead of (IQ, νQ,D,t).
The following two utility functions are natural:
(1) a qualitative utility function ν0-1, where ν0-1(J) ∈{0, 1} indicates whether t is removed
due to the ﬁlters in J alone; and
(2) a quantitative utility function νsize, where ν0-1(J) reports how many tuples projecting
to t are removed by the ﬁlters in J.
To deﬁne ν0-1 and νsize formally, we let QJ denote the full CQ with ﬁlters which is
obtained from Q by removing all ﬁlters fi with i /∈J, and by removing all existential
quantiﬁers. That is, if Q is of the shape (6.4), then
QJ(x) = α1(x1) ∧· · · ∧αn(xn) ∧
^
i∈J
fi(x′
i).
(6.5)
Moreover, we let QJ[t] denote the query obtained from QJ by replacing the variables
which were free in Q by their valuation according to t. Note that QJ[t] still has variables if
Q contained existential quantiﬁers.
Our utility functions can now be formally deﬁned as
ν0-1(J) :=
(
1
if
QJ[t](D)
 = 0
0
otherwise,
(6.6)
and
νsize(J) :=
Q∅[t](D) \ QJ[t](D)
.
(6.7)
For a why-not question t, the Shapley values for the associated cooperative games then
map each ﬁlter to its contribution to the absence of t in the query output. Hence, we get
two computational problems, one using ν0-1, and one using νsize.
Problem 6.8. Let Q be a class of CQs with ﬁlters. We have two computational problems,

---

THE IMPORTANCE OF PARAMETERS IN DATABASE QUERIES ∗
27
(1) WhyNotShapley0-1(Q): Given (Q, D, t), compute Shapley(I, ν0-1, i) for all i ∈I; and
(2) WhyNotShapleysize(Q): Given (Q, D, t), compute Shapley(I, νsize, i) for all i ∈I;
where Q ∈Q is a CQ with ﬁlters {fj : j ∈I}, D is a database over the input schema of Q,
t is a tuple over the output schema of Q with t /∈Q(D), and ν0-1 and νsize are deﬁned from
Q, D, and t as in (6.6) and (6.7).
⌟
Remark 6.9. In the literature, t does not necessarily need to be a full tuple in the output
schema, but rather a tuple pattern that may contain undeﬁned values [BHT15]. This can
also be modelled in our framework by adding existential quantiﬁers to Q for the undeﬁned
values in t. By that, all of our results naturally extend to tuple patterns in the output
schema.
⌟
Example 6.10. Let us pick up a shortened version of Example 6.7 where we already ma-
terialized the self-join of the Flights-relation and, for better readability, project out the
attributes x1, x2, h, a1, a2 to obtain a relation TwoHopConnections(tarr, t1, t2), i.e.,
TwoHopConnections(tarr, t1, t2) = ∃h, a1, a2 : Flights(x1, d, a1, CDG, h, tdep, t1)
∧Flights(x2, d, a2, h, JFK, t2, tarr)
For simplicity, assume that timestamp attributes take integer values and are ordered natu-
rally, and assume that the constants Lmin, Lmax, and T are given as 1, 4, and 8, respectively.
The query, thus, becomes
Q(tarr) = ∃t1, t2 : TwoHopConnections(tarr, t1, t2) ∧(t1 + 1 < t2) ∧(t2 < t1 + 4) ∧(tarr ≤8),
with the three ﬁlters, f1 = [t1 + 1 < t2], f2 = [t2 < t1 + 4], and f3 = [tarr ≤8].
Suppose our input database D (the materialization of TwoHopConnections) consists of
the three tuples (7, 1, 5), (7, 1, 2) and (7, 2, 6), as shown in Table 3. Then the output of Q
on D is empty, and we can ask “Why 7 /∈Q(D)?”
Table 3. An input database D
Arrival (tarr)
HopArrival (t1)
HopDeparture (t2)
7
1
5
7
1
2
7
2
6
We observe that f1 removes the second tuple in TwoHopConnections, f2 removes the
ﬁrst and third tuple and f3 does not remove any tuple. Hence, the Shapley values of the
ﬁlters with respect to ν0-1 are 1
2, 1
2, and 0. In contrast, for νsize, the Shapley values are
1, 2 and 0. Thus, under the qualitative utility function ν0-1, f1 and f2 are deemed equally
important to the absence of 7, whereas under the quantitative utility function νsize, f2 is
deemed more important than f1.
⌟
To get a feeling for the behavior of ν0-1 and νsize, we ﬁrst consider the highly restricted
class of CQs with ﬁlters which contain only a single relational atom. Even on this simple
class, they behave quite diﬀerently.
Theorem 6.11. Let Q be the class of CQs with ﬁlters of shape
Q() = ∃x1, . . . , xn : R(x1, . . . , xn) ∧
^
i∈I
x′
i = c,

---

28
A. GILAD, M. GROHE, B. KIMELFELD, P. LINDNER, AND C. STANDKE
where c is a constant. Then WhyNotShapley0-1(Q) is #P-hard to compute.
Note that for Boolean CQs with ﬁlters, the only possible why-not question that can be
asked is “why ε /∈Q(D)?”, where ε = () is the empty tuple. This is equivalent to asking
why the query returns false on D.
Proof. We show this by giving a Turing reduction from the #SetCover problem: On input a
number m and a family S = (S1, . . . , Sn) of subsets of [m], #SetCover asks for the number
of ways to cover [m] with a subfamily of the subsets, i.e.,
{J ⊆[n] | S
i∈J Si = [m]}
. The
#P-hardness of this problem follows from [PB83].
For a given instance (m, S) of #SetCover, we construct a ﬁltered query Q and a single
relation R such that
(1) R = {tj : j ∈[m]}, where tj encodes which sets Si cover j; and such that
(2) each ﬁlter fi removes exactly those tj with j ∈Si.
To do that, let R be of arity n and let tj be deﬁned by
tj
i :=
(
1
if j ∈Si,
0
otherwise.
That is, the ith attribute column in R represents the indicator function of the set Si ⊆[m].
We deﬁne
Q() = ∃x1 . . . xn : R(x1, . . . , xn) ∧(x1 = 0) ∧· · · ∧(xn = 0),
and let fi = [xi = 0] for i = 1, . . . , n. With this setup, for any subset J ⊆[n] of ﬁlters,
we have ν0-1(J) = 1 if and only if the corresponding (Si)i∈J cover [m], and counting these
subsets of ﬁlters solves the #SetCover instance.
In general, however, a single oracle call to WhyNotShapley0-1 will not be suﬃcient to
count these subsets. Instead, we will deﬁne n diﬀerent instances (m1, S1), . . . , (mn, Sn) of
#SetCover, call the oracle on each of the corresponding relations and ﬁltered queries, and
use these n values combined to solve the original #SetCover instance (m, S). To this end,
for ℓin [n], we deﬁne
mℓ= m + ℓ,
Sℓ=

S1, . . . , Sn, {m + 1}, . . . , {m + ℓ}
	
.
To cover [mℓ] = [m + ℓ] with sets from Sℓwe need a set cover of [m] from S, since the
numbers ≤m are not contained in the added sets, and all the sets {m + j} for 1 ≤j ≤ℓ,
since each of them contains a number that is contained in no other set. Just as we deﬁned
R and Q from (m, S), we deﬁne a relation Rℓand a query Qℓfor every instance (mℓ, Sℓ),
ℓ∈[n] in the exact same way.
Let (Iℓ, ν0-1
ℓ
) be the cooperative game for the empty why-not question ε with respect
to Qℓon Rℓusing the qualitative utility function. In this game, the Shapley value for ﬁlter
fn+1 is given as follows: In any permutation σ of the ﬁlters, the ﬁlter fn+1 makes a diﬀerence
if and only if it is last to complete a set cover of [m + ℓ], so the indices of ﬁlters before i in
σ correspond to a set cover of [m] in S and the elements m + 2, . . . , m + ℓin any order. If
we ﬁx those elements and assume that the size of the set cover is k, then these are k + ℓ−1
elements before fn+1 in σ and n −k after. Thus, we have
w(ℓ) := Shapley(Iℓ, ν0-1
ℓ
, n + 1) =
n
X
k=1
(k + ℓ−1)!(n −k)!
(n + ℓ)!
· sk,

---

THE IMPORTANCE OF PARAMETERS IN DATABASE QUERIES ∗
29
where
sk :=
{J ⊆[n] | |J| = k and
[
i∈J
Si = [m]}

is the number of set covers of [m] with exactly k sets. This yields the following system of
linear equations:





1!(n −1)!
2!(n −2)!
. . .
n!0!
2!(n −1)!
3!(n −2)!
. . .
(n + 1)!0!
...
...
...
...
n!(n −1)!
(n + 1)!(n −2)!
. . .
(2n + 1)!0!




·





s1
s2
...
sn




=





(n + 1)!w(1)
(n + 2)!w(2)
...
(2n)!w(ℓ)




.
The values w(ℓ) can be obtained by calling the oracle for WhyNotShapley0-1 on input
(Qℓ, Rℓ, ε, n + 1) for ℓ= 1, . . . , n.
The matrix ai,j = (i + j −1)!(n −j)! is invertible,
as shown by [Bac02, proof of Theorem 1.1.], so we can determine s1, . . . , sn in polynomial
time and return Pn
k=1 sk. By deﬁnition of the values sk, this is the solution of the #SetCover
instance (m, S).
Fortunately, the quantitative utility function νsize can be evaluated eﬃciently, even on
much more expressive classes than that of Theorem 6.11. We ﬁrst prove a simple closed-form
expression for solutions to WhyNotShapleysize on a simple class of queries. After that, we
will generalize our tractability results to acyclic CQs with ﬁlters.
Proposition 6.12. Let Q() = ∃x1 . . . xn : R(x1, . . . , xn) ∧V
i∈IQ fi(x′
i) and let R be a rela-
tion. For each tuple t ∈R, let kt denote the number of ﬁlters fi that remove t. Then for
query Q, database (relation) R, the empty why-not question ε, and ﬁlter index i, we get
Shapley(IQ, νsize
Q,R,ε, i) =
X
t∈R,
t ﬁltered out by fi
1
kt
.
(6.8)
Proof. The idea of the proof is to exploit additivity by rewriting the utility function as a sum
of indicator utility functions that are easy to evaluate. For t ∈R, we deﬁne the indicator
utility function
νt(J) :=
(
1
if t ∈Q∅(D) \ QJ(D), and
0
otherwise,
which enables us to rewrite the quantitative utility function as
νsize
Q,R,ε(J) =
Q∅(D) \ QJ(D)
 =
X
t∈R
νt(J).
Additivity of the Shapley value yields
Shapley(IQ, νsize
Q,R,ε, i) =
X
t∈R
Shapley(IQ, νt, i).
Now, we observe that νt(J ∪{i}) −νt(J) = 1 if and only if fi removes the tuple t
and none of the ﬁlters fj for j ∈J removes t. Otherwise, νt(J ∪{i}) −νt(J) = 0. Thus,
Shapley(IQ, νt, i) is simply the probability of fi being the ﬁrst ﬁlter removing t in a random
permutation of the ﬁlters. This is the probability of fi being picked ﬁrst among the kt ﬁlters
removing t. Hence, Shapley(IQ, νt, i) = 1
kt if t is ﬁltered out by fi, and 0 otherwise, implying
the claim.

---

30
A. GILAD, M. GROHE, B. KIMELFELD, P. LINDNER, AND C. STANDKE
If Q is a class of queries matching the shape of the query Q in the above proposition,
and it has uniformly tractable ﬁlters, the identity (6.8) allows us to compute the Shapley
values to solve WhyNotShapleysize(Q) eﬃciently. We may even allow the queries in this class
to have some free variables (and, hence, more general why-not questions t̸ = ε): All we need
to do is to plug in the values of t into the free variables in Q and use (6.8).
Corollary 6.13. Let Q be a class of CQs with uniformly tractable ﬁlters of the shape
Q(xf) = ∃xb : α(x) ∧V
i∈I fi(x′
i) where x are all variables appearing in the query, and xf
and xb are the free and bound ones, and α(x) is a relational atom containing all variables.
Then WhyNotShapleysize(Q) can be computed in polynomial time.
In the remainder of this section, we show that Corollary 6.13 can be lifted to acyclic
conjunctive queries. Instead of giving an explicit Yannakakis-style algorithm, we want to
show how to use our framework for the importance of query parameters in this setting. We
do this by ﬁrst connecting Shapley values and Shap scores from a very general point of
view, and then by representing ﬁltered queries with parametrized queries. That allows us to
derive the statement we aim for from our previous results and shows connections between
seemingly unrelated questions.
6.2.2. Shapley values and Shap scores for binary decisions. The goal of this section is to
show how we can compute Shapley values using an oracle that computes Shap scores. For
that, let us take a step back to the basic setting for the Shapley value, as described in
section 2.4: Consider the set of players I = [ℓ] and a utility function ν : 2[ℓ] →R. Using
characteristic vectors, we can also see ν as a function from {0, 1}ℓto R, where the ith bit
indicates whether player i is part of the coalition. This interpretation allows us to introduce
the Shap score in this setting.
To this end, let π = (π1, . . . , πℓ) be a vector of probabilities, and assume that the
player’s memberships in the coalition are independent and such that player i is part of the
coalition with probability πi. This yields a fully factorized distribution Γπ on {0, 1}ℓ.
We consider two computational problems:
(1) Shapley: On input ([ℓ], ν), compute Shapley([ℓ], ν, i) for all i ∈[ℓ].
(2) binarySHAP: On input ([ℓ], ν, π) with πj > 0 for all j ∈[ℓ], compute the Shap scores
of all players i ∈[ℓ] w.r.t. ν and Γπ and reference parameter 1 = (1, . . . , 1); that is,
compute Shapley([ℓ], νSHAP[π], i) for all i ∈[ℓ], where
νSHAP[π](J) :=
E
x∼Γπ

ν({i | xi = 1}) | ∀i ∈J : xi = 1

.
(6.9)
At this point, we do not need to worry about the encoding of the utility function in the
inputs of the problems. We later specialize both problems in a way that the encoding of ν
is clear, and unproblematic.
The diﬀerence between ν and νSHAP[π] in (6.9) is the role of players not belonging to the
coalition J: In ν, they are simply not part of the coalition, while in νSHAP[π], they randomly
join the coalition with probability πi. This immediately implies the following observation:
Observation 6.14. For 0 = (0, . . . , 0), we have νSHAP[0] = ν and, hence,
Shapley([ℓ], ν, i) = Shapley([ℓ], νSHAP[0], i).
Our goal is to reduce Shapley to binarySHAP.
If π = 0 were a valid input to the
binarySHAP problem, this would now be immediate.
However, under Γ0, the reference
parameter 1 does not have positive probability. We resolve this by using interpolation.

---

THE IMPORTANCE OF PARAMETERS IN DATABASE QUERIES ∗
31
Theorem 6.15. Shapley([ℓ], ν, i) can be computed with polynomial overhead by using ℓoracle
calls to binarySHAP on inputs of the shape ([ℓ], ν, (x, . . . , x)), where x > 0.
Proof. For x ∈(0, 1], let π = (x, . . . x). With this probability vector, the utility function of
the binarySHAP problem becomes
νSHAP[(x, . . . , x)](J) =
X
J′⊆[ℓ]\J
ν(J ∪J′) ·
Y
j∈J′
x ·
Y
j∈[ℓ]\(J∪J′)
(1 −x),
which is a polynomial in x of degree at most ℓ−|J|.
Now, consider the map ϕ : x 7→Shapley([ℓ], νSHAP[(x, . . . , x)], i). As the Shapley value
is a linear combination of the values that the utility function attains, ϕ is a polynomial in
the variable x of degree at most ℓ. The constant term of this polynomial is ϕ(0), which
is, by the previous observation, equal to Shapley([ℓ], ν, i). We can interpolate this value
by evaluating ϕ for ℓpairwise diﬀerent arguments x1, . . . , xℓ∈(0, 1], using oracle calls to
binarySHAP on inputs ([ℓ], ν, (xj, . . . , xj)) for j ∈[ℓ]. Multiplying the resulting vector, from
the left, with the inverse of the corresponding Vandermonde matrix yields the coeﬃcients
of ϕ, in particular, ϕ(0) = Shapley([ℓ], ν, i).
6.2.3. The Connection to Shap Scores. We are ﬁnally able to state and prove the main
result of this section.
Theorem 6.16. Let Q be a class of acyclic ﬁltered queries with uniformly tractable ﬁlters.
Then WhyNotShapleysize(Q) can be computed in polynomial time.
Proof. We want to prove this theorem by combining Theorem 6.15 and Proposition 6.3.
For that, note that WhyNotShapleysize(Q) is a special version of Shapley where the utility
function ν is not given explicitly but rather encoded in Q, D and t. In the same way, we
deﬁne a special version WhyNotSHAPsize(Q) of binarySHAP. This is the problem that, on
input Q, D, t, and π ∈[0, 1]I (assigning a probability πi to each ﬁlter fi of the ﬁltered
query Q), asks for the Shap scores of all ﬁlters fi rather than their Shapley values; that is,
to compute Shapley(I, νsize
SHAP[π], i) for all i ∈I where
νsize
SHAP[π](J) :=
E
x∼Γπ

νsize({i | xi = 1}) | ∀i ∈J : xi = 1

.
By Theorem 6.15, WhyNotShapleysize(Q) can be solved using a linear number of oracle
calls to WhyNotSHAPsize(Q). Now, we are looking for a class of full pACQ with uniformly
tractable ﬁlters Q′ and a similarity function s from Proposition 6.3 that allow reducing
WhyNotSHAPsize(Q) to SHAP(Q′, PIND, s).
Towards this goal, let (Q, D, t, π) be an input to WhyNotSHAPsize(Q) and consider the
following construction: From the ﬁltered query Q ∈Q of the form Q(xf) = ∃xb : α1(x1) ∧
· · · ∧αn(xn) ∧f1(x′
1) ∧· · · ∧fm(x′
m) and the tuple t over Out(Q), we construct Q′ as
follows. We ﬁrst extend each ﬁlter fj(x′
j) with a new Boolean parameter yj to obtain a ﬁlter
f ′
j(x′
j, yj). Then, we substitute all free variables xf with their corresponding values from t
and remove the existential quantiﬁers. Hence,
Q′(xb; y) = α1(x1)[xf/t] ∧· · · ∧αn(xn)[xf/t]
∧f ′
1(x′
1, y1)[xf/t] ∧· · · ∧f ′
m(x′
m, ym)[xf/t].

---

32
A. GILAD, M. GROHE, B. KIMELFELD, P. LINDNER, AND C. STANDKE
Then Q′ is a full pACQ and the class Q′ of Q′ which are constructed this way from queries
of Q is a class of full pACQ with uniformly tractable ﬁlters. Furthermore, by construction,
we obtain for all J ⊆I:
QJ[t](D) = Q′
χ(J)(D),
(6.10)
where χ(J) is the characteristic vector of the set J. To recall, the left-hand side of (6.10)
is evaluating the unquantiﬁed version of Q which has been restricted to the ﬁlters in J and
where the free variables have been replaced by t, as deﬁned in (6.5). The right-hand side is
evaluating our parameterized query Q′ with parameter χ(J) as deﬁned in (2.1).
We now want to use (6.10) to relate νsize
SHAP[π] to a utility function corresponding to
SHAP(Q′, PIND, s) for some similarity function s as in (3.1). First, we observe
νsize
Q,D,t(J) = |Q∅[t](D) \ QJ[t](D)| = |Q∅[t](D)| −|QJ[t](D)| = |Q∅[t](D)| −|Q′
χ(J)(D)|,
where the ﬁrst equality holds, since Q∅[t](D) ⊇QJ[t](D). Then, since the value |Q∅[t](D)|
does not depend on J, we have
νsize
SHAP[π](J) =
E
x∼Γπ

νsize({i | xi = 1}) | ∀i ∈J : xi = 1

=
E
x∼Γπ

|Q∅[t](D)| −|Q′
χ({i | xi=1})(D)| | ∀i ∈J : xi = 1

= |Q∅[t](D)| −
E
x∼Γπ

|Q′
χ({i | xi=1})(D)| | ∀i ∈J : xi = 1

.
(6.11)
Finally, let
ν′(J) :=
E
x∼Γπ

|Q′
χ({i | xi=1})(D)| | ∀i ∈J : xi = 1

=
E
x∼Γπ

|Q′
x(D)| | xJ = 1J

.
From (6.11), we immediately get
Shapley([m], νsize
SHAP[π], i) = −Shapley([m], ν′, i).
We also observe that ν′(J) is the utility function from (3.1) with s = Count on input
(Q′, 1, D, Γπ).
Hence, we have constructed an instance of SHAP(Q′, PIND, Count) whose
Shap scores are equal to the Shap scores of WhyNotSHAPsize up to a sign ﬂip.
Since
Q′ is a class of full pACQ with uniformly tractable ﬁlters, we can apply our results of
section 6.1: Proposition 6.3, and its extension to the Count “similarity”. Hence, we can solve
our constructed instance (Q′, t, D, Γπ) of SHAP(Q′, PIND, Count) in polynomial time, which
completes our reduction.
7. Correlated Parameters and Approximability
In this section, we allow classes P of parameter distributions with correlations. We only
need to make the following tractability assumptions (which are trivially satisﬁed by PIND).
(1) For every ﬁxed ℓ, and every Γ ∈PP with |P | = ℓ, the support supp(Γ) can be computed
in polynomial time in ∥Γ∥.
(2) For all p and J, we can compute Prp′∼Γ(p′
J = pJ) in polynomial time in ∥Γ∥.

---

THE IMPORTANCE OF PARAMETERS IN DATABASE QUERIES ∗
33
For example, the ﬁrst property holds for distributions encoded by Bayesian networks.
The second one holds for structurally restricted classes of Bayesian networks, like polytrees
[KF09]. The following result states that given these assumptions, the data complexity of the
SHAP problem remains in polynomial time even for parameter distributions with correlations.
This is shown exactly as in the proof of Proposition 4.1.
Proposition 7.1. Let s be a tractable similarity function and let Q(R; P ) be a ﬁxed parame-
terized query such that Qp(D) can be computed in polynomial time in ∥D∥for all p ∈Tup[P ].
Moreover, let P be a class of distributions as described above. Then SHAP({Q}, P, s) can be
solved in polynomial time.
Next, we explain how SHAP can be approximated via sampling.
Consider an input
(Q, p∗, D, Γ) of SHAP(Q, P, s), where Q = Q(R; P ) and |p∗| = ℓ. We rewrite Shap(i) as an
expectation in a single probability space, instead of nested expectations in diﬀerent spaces.
Let {i}0 = ∅and {i}1 = {i}. Consider the following two-step random process, for b ∈{0, 1}:
(1) Draw J ⊆[ℓ] \ i according to Πi.
(2) Draw p according to Γ, conditioned on having p agree with p∗on J ∪{i}b.
This process deﬁnes two joint probability distributions on pairs (p, J), one for b = 0, and
one for b = 1. By Γi,b, we denote the corresponding marginal distribution over parameter
tuples p.
Proposition 7.2. We have
Shap(i) =
E
p∼Γi,1

s(p, p∗)

−
E
p∼Γi,0

s(p, p∗)

.
(7.1)
Proof. Recall the two-step random process described at the beginning of section 7. We have
Γi,b(p) =
X
J⊆[ℓ]\{i}
Πi(J) · Pr
p′∼Γ
 p′ = p
 p′
J∪{i}b = p∗
J∪{i}b

(7.2)
Using Γi,b, we can rewrite the terms of (2.3) (after using linearity) as follows:
E
J∼Πi[ν(J)] =
X
J⊆[ℓ]\{i}
Πi(J) · E
p∼Γ[s(p, p∗) | pJ = p∗
J]
=
X
p
s(p, p∗)
X
J⊆[ℓ]\{i}
Πi(J) Pr
p′∼Γ(p′ = p | p′
J = p∗
J)
=
X
p
s(p, p∗) · Γi,0(p) =
E
p∼Γi,0[s(p, p∗)],
and, analogously,
E
J∼Πi[ν(J ∪{i})] =
E
p∼Γi,1[s(p, p∗)].
We say that P admits eﬃcient conditional sampling if there exists a polynomial ϕ such
that for all Γ ∈P, all p∗∈supp(Γ), and all J ⊆[ℓ], the conditional distribution of Γ subject
to pJ = p∗
J can be sampled in time ϕ(∥Γ∥+ ∥p∗∥). This is again the case, for example, for
structurally restricted classes of Bayesian networks. By the structure of the two-step process
deﬁning Γi,b, we can eﬃciently sample from Γi,b if we can eﬃciently sample from conditional
distributions of Γ:

---

34
A. GILAD, M. GROHE, B. KIMELFELD, P. LINDNER, AND C. STANDKE
Proposition 7.3. If all conditional distributions of Γ subject to conditions pJ = p∗
J can be
sampled in time polynomial in ∥Γ∥, ∥p∗∥, then the distributions Γi,b can be sampled in time
polynomial in ∥Γ∥, ∥p∗∥.
Proof. The distribution Γi,b was introduced as a two-step sampling process, ﬁrst sampling
J from Πi, and then sampling a parameter tuple from Γ conditional on it agreeing with p∗
on J ∪{i}b. These two steps yield joint distributions on 2[ℓ]\{i} × Tup[P ] for b ∈{0, 1}, and
Γi,b is the corresponding marginal distribution on Tup[P ].
Observe that
Γi,b(p) =
X
J⊆[ℓ]\[i]
Pr(J, p) =
X
J⊆[ℓ]\[i]
Pr(J) · Pr(p
 J) =
X
J⊆[ℓ]\[i]
Πi(J) · Pr
p′∼Γ(p′ = p
 p′
J = p∗
J).
The distribution Γi,b can thus be sampled by the two steps mentioned in the beginning, and
returning only the sampled p from the second step.
The distribution Πi can also be described by a two-step sampling process: First, sample
k ∈[ℓ] \ {i} uniformly at random. Next, sample a subset J of cardinality exactly k from
[ℓ] \ {i}, uniformly at random. For the second step, to sample uniformly from the k-element
subsets of [ℓ] \ {i}, we can proceed as follows: Initially, let J = ∅and J = [ℓ] \ {i}. Then,
repeat the following k times:
(1) Let j be a uniform sample from J (the uniform probability is
1
|J|).
(2) Remove j from J and add it to J.
Finally, return J.
To see that this yields the correct distribution, consider any ﬁxed set K ⊆[ℓ] \ {i} of
size k. By summing over all permutations j1, . . . , jk of K, we get
Pr(J = K) =
X
j1,...,jk
Pr(j1) Pr(j2 | j1) Pr(j3 | j1, j2) · · · Pr(jk | j1, . . . , jk−1)
=
X
j1,...,jk
1
ℓ−1
1
ℓ−2 · · ·
1
ℓ−1 −(k −1) = k!(l −1 −k)!
(ℓ−1)!
=
1
 ℓ−1
k
.
Going back to the distribution Γi,b, we have just seen that the ﬁrst step of the sampling
process is possible in time polynomial in ℓ(and independent of any other inputs). Together
with the precondition of the statement, it follows that sampling from Γi,b is possible in
polynomial time.
A similarity function s is bounded for a class of parameterized queries Q if there are
a ≤b such that for all (Q, p1, p2), Q ∈Q, we have a ≤s(p1, p2) ≤b. For example, similarity
measures, like Jaccard, are usually [0, 1]-valued. The following theorem states that, under
the assumptions of eﬃcient conditional sampling and boundedness, we have an additive
FPRAS for the Shap score of a parameter.
Theorem 7.4. Let Q be a class of tractable parameterized queries, let s a tractable similarity
function such that the value range of s is bounded for Q, and let P be a class of parameter
distributions that admits eﬃcient conditional sampling. Then, for all inputs (Q, p∗, D, Γ)
and all i ∈[ℓ], we can compute a value S satisfying Pr(|S −Shap(i)| < ε) ≥1 −δ in time
polynomial in 1
ε, log 1
δ , and the size of the input.
Proof. Let N be some large enough number, the value of which we ﬁx later.
We draw
a total of 2N independent samples: N samples p(1)
1 , . . . , p(N)
1
from Γi,1, and N samples

---

THE IMPORTANCE OF PARAMETERS IN DATABASE QUERIES ∗
35
p(1)
0 , . . . , p(N)
0
from Γi,0. By Proposition 7.3, these samples can be obtained eﬃciently. Let
bs1 and bs0 be the two sample means
bs1 = 1
N
N
X
i=1
s(p(i)
1 , p∗)
and
bs0 = 1
N
N
X
i=1
s(p(i)
0 , p∗).
Then E
bs1

= Ep∼Γi,1

s(p, p∗)

and, likewise, E
bs0

= Ep∼Γi,0

s(p, p∗)

, where the unanno-
tated expectations relate to the sampling procedure. Hence, E
bs1

−E
bs0

= Shap(i) via
(7.1), and we therefore return the diﬀerence S = bs1 −bs0 as an approximation to Shap(i).
Let a ≤b be the constant bounds on s. By a corollary of Hoeﬀding’s inequality (see
[Hoe63, Inequality (2.7)]), for all ε > 0 we have
Pr
S −Shap(i)
 < ε

≥1 −2 · exp

−
Nε2
(b −a)2

.
Thus, in order for our approximation to be in the interval (Shap(i) −ε, Shap(i) + ε) with
probability at least 1 −δ, it is suﬃcient to have
δ ≥2 · exp

−
Nε2
(b −a)2

⇔(b −a)2
ε2
log 2
δ ≤N.
That is, it is suﬃcient to use ⌈(b−a)2
ε2
log 2
δ⌉samples from each distribution.
8. Conclusions
We proposed a framework for measuring the responsibility of parameters to the result of a
query using the Shap score. We studied the computational problem of calculating the Shap
score of a given parameter value. We gave general complexity lower and upper bounds, and
presented a complexity analysis for the restricted case of conjunctive queries and independent
parameters. We also studied the extension of the study to conjunctive queries with ﬁlters,
and showed an application of this extension to the analysis of why-not questions with the
objective of quantifying the contribution of ﬁlters to the elimination of a non-answer. Finally,
we discussed the complexity of approximate calculation and correlated parameters.
The rich framework we introduced here oﬀers many opportunities for future research.
Especially important is the direction of aggregate queries, where the similarity between re-
sults accounts for the numerical values such as sum, average, median, and so on. For such
queries, it is important to study numerical parameter distributions, which are typically con-
tinuous probability measures. It is also important to identify general tractability conditions
for similarity measures and parameter distributions in order to generalize the upper bounds
beyond the special cases that we covered here. Finally, we plan to explore the applicability
of Shap to measuring parameters in various queries and datasets, such as those studied in
the context of fact checking.

---

36
A. GILAD, M. GROHE, B. KIMELFELD, P. LINDNER, AND C. STANDKE
Acknowledgment
The work of Martin Grohe, Benny Kimelfeld, and Christoph Standke was supported by the
German Research Foundation (DFG) grants GR 1492/16-1 and KI 2348/1-1 (DIP Program).
The work of Martin Grohe and Christoph Standke was supported by the German Research
Foundation (DFG) grant GRK 2236/2 (UnRAVeL). The work of Amir Gilad was supported
by the Israel Science Foundation (ISF) under grant 1702/24 and the Alon Scholarship.
References
[ABBM21]
Marcelo Arenas, Pablo Barceló, Leopoldo E. Bertossi, and Mikaël Monet. The tractability of
shap-score-based explanations for classiﬁcation over deterministic and decomposable boolean
circuits. In AAAI, pages 6670–6678. AAAI Press, 2021.
[ADF22]
Dana Arad, Daniel Deutch, and Nave Frost. LearnShapley: Learning to predict rankings of
facts contribution based on query logs. In CIKM, pages 4788–4792. ACM, 2022.
[AFSS19]
Encarnación Algaba, Vito Fragnelli, and Joaquín Sánchez-Soriano, editors. Handbook of the
Shapley Value. CRC Press, 2019. doi:10.1201/9781351241410.
[Bac02]
Roland Bacher. Determinants of matrices related to the pascal triangle. J. Theorie Nombres
Bordeaux, 14(1):9–41, 2002.
[BBFL08]
Leopoldo E. Bertossi, Loreto Bravo, Enrico Franconi, and Andrei Lopatenko. The complexity
and approximation of ﬁxing numerical attributes in databases under integrity constraints. Inf.
Syst., 33(4-5):407–434, 2008.
[BFL24]
Meghyn Bienvenu, Diego Figueira, and Pierre Lafourcade. When is shapley value computation
a matter of counting? Proc. ACM Manag. Data, 2(2):105, 2024. doi:10.1145/3651606.
[BGH22]
Marcia Lourenco Baptista, Kai Goebel, and Elsa M. P. Henriques. Relation between prognostics
predictor evaluation metrics and local interpretability SHAP values. Artif. Intell., 306:103667,
2022.
[BHT14]
Nicole Bidoit, Melanie Herschel, and Katerina Tzompanaki. Query-based why-not prove-
nance with nedexplain. In Sihem Amer-Yahia, Vassilis Christophides, Anastasios Kementsi-
etsidis,
Minos N. Garofalakis,
Stratos Idreos,
and Vincent Leroy, editors,
Proceedings
of the 17th International Conference on Extending Database Technology,
EDBT 2014,
Athens,
Greece,
March 24-28,
2014,
pages 145–156. OpenProceedings.org,
2014. URL:
https://doi.org/10.5441/002/edbt.2014.14, doi:10.5441/002/EDBT.2014.14.
[BHT15]
Nicole Bidoit, Melanie Herschel, and Aikaterini Tzompanaki. Eﬃcient computation of polyno-
mial explanations of why-not questions. In James Bailey, Alistair Moﬀat, Charu C. Aggarwal,
Maarten de Rijke, Ravi Kumar, Vanessa Murdock, Timos K. Sellis, and Jeﬀrey Xu Yu, editors,
Proceedings of the 24th ACM International Conference on Information and Knowledge Man-
agement, CIKM 2015, Melbourne, VIC, Australia, October 19 - 23, 2015, pages 713–722. ACM,
2015. doi:10.1145/2806416.2806426.
[CJ09a]
Adriane Chapman and H. V. Jagadish. Why not? In SIGMOD Conference, pages 523–534.
ACM, 2009.
[CJ09b]
Adriane Chapman and H. V. Jagadish. Why not?
In Ugur Çetintemel, Stanley B. Zdonik,
Donald Kossmann, and Nesime Tatbul, editors, Proceedings of the ACM SIGMOD International
Conference on Management of Data, SIGMOD 2009, Providence, Rhode Island, USA, June 29
- July 2, 2009, pages 523–534. ACM, 2009. doi:10.1145/1559845.1559901.
[DFGS21]
Daniel Deutch, Nave Frost, Amir Gilad, and Oren Sheﬀer. Explanations for data repair through
shapley values. In CIKM, pages 362–371. ACM, 2021.
[DFKM22]
Daniel Deutch, Nave Frost, Benny Kimelfeld, and Mikaël Monet. Computing the shapley value
of facts in query answering. In SIGMOD Conference, pages 1570–1583. ACM, 2022.
[DM14]
Arnaud Durand and Stefan Mengel. The complexity of weighted counting for acyclic conjunctive
queries. J. Comput. Syst. Sci., 80(1):277–296, 2014. doi:10.1016/j.jcss.2013.08.001.
[DP94]
Xiaotie Deng and Christos H. Papadimitriou. On the complexity of cooperative solution con-
cepts. Math. Oper. Res., 19(2):257–266, 1994.

---

THE IMPORTANCE OF PARAMETERS IN DATABASE QUERIES ∗
37
[FK92]
U. Faigle and W. Kern. The shapley value for cooperative games under precedence constraints.
Int. J. Game Theory, 21(3):249–266, sep 1992. doi:10.1007/BF01258278.
[GG21]
Alex Gramegna and Paolo Giudici. SHAP and LIME: an evaluation of discriminative power in
credit risk. Frontiers Artif. Intell., 4:752558, 2021.
[GKLS24]
Martin Grohe, Benny Kimelfeld, Peter Lindner, and Christoph Standke. The importance of pa-
rameters in database queries. In Graham Cormode and Michael Shekelyan, editors, 27th Interna-
tional Conference on Database Theory, ICDT 2024, March 25-28, 2024, Paestum, Italy, volume
290 of LIPIcs, pages 14:1–14:17. Schloss Dagstuhl - Leibniz-Zentrum für Informatik, 2024. URL:
https://doi.org/10.4230/LIPIcs.ICDT.2024.14, doi:10.4230/LIPICS.ICDT.2024.14.
[Gra79]
Marc H. Graham. On the universal relation. Technical report, University of Toronto, 1979.
[GS89]
Yuri Gurevich and Saharon Shelah. Time polynomial in input or output. J. Symb. Log.,
54(3):1083–1088, 1989. doi:10.2307/2274767.
[HCDN08]
Jiansheng Huang, Ting Chen, AnHai Doan, and Jeﬀrey F. Naughton. On the provenance of
non-answers to queries over extracted data. Proc. VLDB Endow., 1(1):736–747, 2008. URL:
http://www.vldb.org/pvldb/vol1/1453936.pdf, doi:10.14778/1453856.1453936.
[Her15]
Melanie Herschel. A hybrid approach to answering why-not questions on relational query results.
ACM J. Data Inf. Qual., 5(3):10:1–10:29, 2015. doi:10.1145/2665070.
[HH10]
Melanie
Herschel
and
Mauricio
A.
Hernández.
Explaining
miss-
ing
answers
to
SPJUA
queries.
Proc.
VLDB
Endow.,
3(1):185–196,
2010.
URL:
http://www.vldb.org/pvldb/vldb2010/pvldb_vol3/R16.pdf,
doi:10.14778/1920841.1920869.
[HL14]
Zhian He and Eric Lo. Answering why-not questions on top-k queries. IEEE Trans. Knowl.
Data Eng., 26(6):1300–1315, 2014. doi:10.1109/TKDE.2012.158.
[Hoe63]
Wassily Hoeﬀding. Probability inequalities for sums of bounded random variables. Journal of
the American Statistical Association, 58(301):13–30, 1963. doi:10.2307/2282952.
[KF09]
Daphne Koller and Nir Friedman. Probabilistic Graphical Models: Principles and Techniques.
Adaptive Computation and Machine Learning. MIT Press, Cambridge, MA, 2009.
[KK22]
Yesuel Kim and Youngchul Kim. Explainable heat-related mortality with random forest
and shapley additive explanations (shap) models. Sustainable Cities and Society, 79:103677,
2022.
URL:
https://www.sciencedirect.com/science/article/pii/S2210670722000117,
doi:https://doi.org/10.1016/j.scs.2022.103677.
[KLTV06]
Nick Koudas, Chen Li, Anthony K. H. Tung, and Rares Vernica. Relaxing join and selection
queries. In VLDB, pages 199–210. ACM, 2006.
[LBKS20]
Ester Livshits, Leopoldo E. Bertossi, Benny Kimelfeld, and Moshe Sebag. The Shapley value
of tuples in query answering. In ICDT, volume 155 of LIPIcs, pages 20: 1–20: 19. Schloss
Dagstuhl, 2020.
[LEC+20]
Scott M. Lundberg, Gabriel G. Erion, Hugh Chen, Alex J. DeGrave, Jordan M. Prutkin, Bala
Nair, Ronit Katz, Jonathan Himmelfarb, Nisha Bansal, and Su-In Lee. From local explanations
to global understanding with explainable AI for trees. Nat. Mach. Intell., 2(1):56–67, 2020.
[LGC+16]
Qing Liu, Yunjun Gao, Gang Chen, Baihua Zheng, and Linlin Zhou. Answering why-
not and why questions on reverse top-k queries. VLDB J., 25(6):867–892, 2016. URL:
https://doi.org/10.1007/s00778-016-0443-4, doi:10.1007/S00778-016-0443-4.
[LK22]
Ester Livshits and Benny Kimelfeld. The shapley value of inconsistency measures for functional
dependencies. Log. Methods Comput. Sci., 18(2), 2022.
[LL17]
Scott M. Lundberg and Su-In Lee. A uniﬁed approach to interpreting model predictions. In
NIPS, pages 4765–4774, 2017.
[LRB08]
Marie-Jeanne Lesot, Maria Rifqi, and Hamid Benhadda. Similarity measures for binary
and numerical data:
a survey. International Journal of Knowledge Engineering and Soft
Data Paradigms, 1(1):63–84, December 2008. URL: https://hal.inria.fr/hal-01072737,
doi:10.1504/ijkesdp.2009.021985.
[LYM+21]
Yin Lin, Brit Youngmann, Yuval Moskovitch, H. V. Jagadish, and Tova Milo. On detecting
cherry-picked generalizations. Proc. VLDB Endow., 15(1):59–71, 2021.
[ME20]
Wilson Estécio Marcílio and Danilo Medeiros Eler. From explanations to feature selection:
assessing SHAP values as feature selection mechanism. In SIBGRAPI, pages 340–347. IEEE,
2020.

---

38
A. GILAD, M. GROHE, B. KIMELFELD, P. LINDNER, AND C. STANDKE
[MGMS10]
Alexandra Meliou,
Wolfgang Gatterbauer,
Katherine F. Moore,
and Dan Suciu. The
complexity
of
causality
and
responsibility
for
query
answers
and
non-answers.
Proc.
VLDB Endow., 4(1):34–45, 2010. URL: http://www.vldb.org/pvldb/vol4/p34-meliou.pdf,
doi:10.14778/1880172.1880176.
[MHB19]
Karim El Mokhtari, Ben Peachey Higdon, and Ayse Basar. Interpreting ﬁnancial time series
with SHAP values. In CASCON, pages 166–172. ACM, 2019.
[MMR+13]
Davide Mottin, Alice Marascu, Senjuti Basu Roy, Gautam Das, Themis Palpanas, and Yannis
Velegrakis. A probabilistic optimization framework for the empty-answer problem. Proc. VLDB
Endow., 6(14):1762–1773, 2013.
[Mol23]
Christoph
Molnar.
Interpretable
machine
learning:
A
guide
for
mak-
ing
black
box
models
explainable,
2023.
Version
2023-08-21.
URL:
https://christophm.github.io/interpretable-ml-book.
[Ont20]
Santiago Ontañón. An overview of distance and similarity functions for structured data. Artif.
Intell. Rev., 53(7):5309–5351, 2020. doi:10.1007/s10462-020-09821-w.
[PB83]
J. Scott Provan and Michael O. Ball. The complexity of counting cuts and of computing the
probability that a graph is connected. SIAM J. Comput., 12(4):777–788, 1983.
[PS13]
Reinhard Pichler and Sebastian Skritek. Tractable counting of the answers to conjunctive
queries. J. Comput. Syst. Sci., 79(6):984–1001, 2013. doi:10.1016/j.jcss.2013.01.012.
[Rot88]
Alvin E. Roth. The Shapley value: essays in honor of Lloyd S. Shapley. Cambridge University
Press, 1988.
[RSG16]
Marco Tulio Ribeiro, Sameer Singh, and Carlos Guestrin. “Why should I trust you?”: Explaining
the predictions of any classiﬁer. In KDD, pages 1135–1144. ACM, 2016.
[RSG18]
Marco Tulio Ribeiro, Sameer Singh, and Carlos Guestrin. Anchors: High-precision model-
agnostic explanations. In Proceedings of the AAAI conference on artiﬁcial intelligence, vol-
ume 32, 2018.
[SG19]
B. Sathiya and T. V. Geetha. A review on semantic similarity measures for ontology. J. Intell.
Fuzzy Syst., 36(4):3045–3059, 2019.
[Sha53]
Lloyd S. Shapley. A value for n-person games. In Harold W. Kuhn and Albert W. Tucker,
editors, Contributions to the Theory of Games II, pages 307–317. Princeton University Press,
Princeton, 1953.
[SORK11]
Dan Suciu, Dan Olteanu, Christopher Ré, and Christoph Koch. Probabilistic Databases.
Synthesis
Lectures
on
Data
Management.
Morgan
&
Claypool
Publishers,
2011.
doi:10.2200/S00362ED1V01Y201105DTM016.
[TC10a]
Quoc Trung Tran and Chee-Yong Chan. How to conquer why-not questions. In SIGMOD
Conference, pages 15–26. ACM, 2010.
[TC10b]
Quoc Trung Tran and Chee-Yong Chan. How to conquer why-not questions. In Ahmed K.
Elmagarmid and Divyakant Agrawal, editors, Proceedings of the ACM SIGMOD International
Conference on Management of Data, SIGMOD 2010, Indianapolis, Indiana, USA, June 6-10,
2010, pages 15–26. ACM, 2010. doi:10.1145/1807167.1807172.
[Var82]
Moshe Y. Vardi. The complexity of relational query languages (extended abstract). In Harry R.
Lewis, Barbara B. Simons, Walter A. Burkhard, and Lawrence H. Landweber, editors, Pro-
ceedings of the 14th Annual ACM Symposium on Theory of Computing, May 5-7, 1982, San
Francisco, California, USA, pages 137–146. ACM, 1982. doi:10.1145/800070.802186.
[VdBLSS22] Guy Van den Broeck, Anton Lykov, Maximilian Schleich, and Dan Suciu. On the tractabil-
ity of SHAP explanations. Journal of Artiﬁcial Intelligence Research, 74:851–886, Jun 2022.
doi:10.1613/jair.1.13283.
[VdBS17]
Guy Van den Broeck and Dan Suciu. Query processing on probabilistic data: A survey. Found.
Trends Databases, 7(3-4):197–341, 2017. doi:10.1561/1900000052.
[WAL+17]
You Wu, Pankaj K. Agarwal, Chengkai Li, Jun Yang, and Cong Yu. Computational fact check-
ing through query perturbations. ACM Trans. Database Syst., 42(1):4:1–4:41, 2017.
[YO79]
C. T. Yu and M. Z. Ozsoyoglu. An algorithm for tree-query membership of a distributed query.
In The IEEE Computer Society’s Third International Computer Software and Applications
Conference, COMPSAC 1979, 6-8 November, 1979, Chicago, Illinois, USA, pages 306–312.
IEEE, 1979. doi:10.1109/CMPSAC.1979.762509.
This work is licensed under the Creative Commons Attribution License. To view a copy of this
license, visit https://creativecommons.org/licenses/by/4.0/ or send a letter to Creative
Commons, 171 Second St, Suite 300, San Francisco, CA 94105, USA, or Eisenacher Strasse 2,
10777 Berlin, Germany

---

