# Weighted Random Sampling over Joins

> 来源: https://arxiv.org/pdf/2201.02670

Weighted Random Sampling over Joins
Michael Shekelyan∗
michael.shekelyan@kcl.ac.uk
King’s College London
UK
Graham Cormode
g.cormode@warwick.ac.uk
University of Warwick
Coventry, UK
Peter Triantafillou, Ali
Shanghooshabad, Qingzhi Ma
P.Triantafillou@warwick.ac.uk
University of Warwick, UK
... too many rows ...
(2nd Scan) Inversion Sampling
(Streamed) Online Multinomial Sampling
(1st Scan) Group Weights
Very Large Table
Output: Sample over Join Result
×1
×2
×1
×3
⋈
⋈
Input: Join Query & UDF for Weights
analysing sample ...
Multistage Multinomial Sampling
Figure 1: The user provides a join query and weight function, the proposed stream sampler processes the largest table in one
sequential scan and the other tables in two sequential scans and then outputs a weighted random sample over the join.
ABSTRACT
Joining records with all other records that meet a linkage condition
can result in an astronomically large number of combinations due to
many-to-many relationships. For such challenging (acyclic) joins, a
random sample over the join result is a practical alternative to work-
ing with the oversized join result. Whereas prior works are limited
to uniform join sampling where each join row is assigned the same
probability, the scope is extended in this work to weighted sampling
to support emerging applications such as scientific discovery in ob-
servational data and privacy-preserving query answering. Notwith-
standing some naive methods, this work presents the first approach
for weighted random sampling from join results. Due to a lack of
baselines, experiments over various join types and real-world data
sets are conducted to show substantial memory savings and com-
petitive performance with main-memory index-based approaches
in the equal-probability setting. In contrast to existing uniform
sampling approaches that require prepared structures that occupy
contested resources to squeeze out slightly faster query-times, the
proposed approaches exhibit qualities that are urgently needed in
practice, namely reduced memory footprint, streaming operation,
support for selections, outer joins, semi joins and anti joins and
unequal-probability sampling. All pertinent code and data can be
found at: https://github.com/shekelyan/weightedjoinsampling
1
INTRODUCTION
Collecting random samples has long been a vital tool to un-
derstand and analyse an underlying data population. The role of
random sampling (unlike some quick-and-dirty heuristic sampling
techniques [19, 21, 32, 33]) is to provide a representative surrogate
∗While at University of Warwick: development/analysis/evaluation of proposed ap-
proaches, writing/editing the manuscript and writing/running all the implemented
code. While at King’s College London: rewriting Section 3 and revising the manuscript.
for the data population of interest with well-understood statisti-
cal properties that can be handed off directly to any systems or
users. Obtaining representative surrogates has become particularly
pressing in the era of big data, where complex operations over
massive data sets become prohibitively expensive. Within the data-
base literature, sampling is the key underpinning technology of
approximate query processing (AQP) engines such as VerdictDB
[40] and QuickR [27]. Similarly, random samples are used for more
advanced inferential analytics tasks, such as for training statistical
and machine learning models, e.g., learned AQP engines depend on
such samples [23, 34] and optimal subsampling [54, 56–58, 61] for
tasks like logistic regression rely on unequal-probability samples.
Why random sampling over joins? Joins of tables are a fundamen-
tal operator in relational database management systems, NoSQL
databases, and in many analytics applications where data is spread
across a variety of heterogeneous data sources. Unfortunately, multi-
way joins can become excessively expensive, especially for very
large tables, when join attributes are not keys and when they fea-
ture many-to-many relations. Fortunately, a random sample of the
join result would be more than sufficient for many applications, for
the reasons outlined above. The natural question that arises is then:
Is sampling able to avoid the high costs of computing join queries?
Although efficiently collecting random samples for a single base
table is trivial, collecting a random sample over a join of tables
remains a formidable challenge.
Why weighted random sampling over joins?
Weighted random sampling allows users and systems to weigh
potential join results such that if a row in the join result has twice
the weight of another, it is twice as likely to be included in the
sample. Sampling with probabilities proportional to weights is not
just some exotic variation of the sampling problem, but rather the
arXiv:2201.02670v1  [cs.DB]  7 Jan 2022

---

Shekelyan et al.
inevitable response to a large variety of modern day requirements
that cannot be meet with uniform probability sampling:
• Privacy-Protection. In privacy-preservation frameworks for
query-answering such as differential privacy [14] with vari-
ous database applications [13, 30, 35, 37], any non-random
selections based on user-derived selection predicates violate
the formal privacy requirements. In contrast, weighted sam-
pling satisfies the requirements as long as the weights are
sufficiently robust to individual users 1
• Stratified Sampling / Join over Selections. Join rows violating
column-wise selection predicates can be assigned a weight of
zero via column-based weights. Hence, weighted sampling
can be used to collect stratified samples, e.g., as needed by
AQP systems [7, 27, 40].
• Probability proportional to size (PPS) sampling. A common
sampling design samples larger groups proportionally more
likely [39, 44, 50] which is needed for sampling over groups
of records.
• Data exploration. Weighted sampling allows smoother types
of selection as a function of data values with no hard cut-off,
which allows to prioritise more relevant entries, e.g., featur-
ing larger sales volumes, more recent sales or sales closer
to a location. Similarly, it makes it easier to sample outliers
as instead of having to know the parameters of an outlier,
it suffices to weigh expected entries lower. Thus, weighted
sampling is utilised for scientific discovery in observational
data [48].
• Aggregations. Weighted sampling can be more accurate for
aggregations on attribute values. For instance, a random
sample biased towards larger values is more accurate for
aggregation functions such as SUM, since they have a bigger
impact on the SUM aggregate. Unequal sampling probabili-
ties are widely used for statistical estimators [6, 46].
How are the weights expressed? It is assumed in this work that the
join result weights come from functions provided by the user that
typically map each column value to a weight and the total weight
is then the product of these column value weights. For instance, for
a join of a table that keeps track of sales with a table that details
everything about the sold items, the user can decide to weigh the
sample based on number of sales multiplied by the price of the items.
While the proposed approach also supports the less common case,
where rows of base tables are given weights that are not products of
column-based weights, it does not go as far as supporting arbitrary
weights for join rows.
1Differentially private selections over joins: Suppose the joined tables are non-secret,
while weights are sensitive, because they are based on private user information. In
outline, suppose each column value 𝑥has a utility value 𝑢(𝑥) s.t. each join row
𝑥1𝑥2 . . . 𝑥𝑛has a utility value 𝑢(𝑥1) + 𝑢(𝑥2) + . . . + 𝑢(𝑥𝑛). Suppose the utility
values are based on a set of private data records and that adding/removing a user’s
record from the set changes the sum 𝑢(𝑥1) + 𝑢(𝑥2) + . . . + 𝑢(𝑥𝑛) by at most Δ.
The sampling weight is then determined using the exponential mechanism [36], i.e.,
𝑤(𝑥1𝑥2 . . . 𝑥𝑛) = exp( 𝜀
2Δ
Í𝑛
𝑖=1 𝑢(𝑥𝑖)). Generating a multinomial join sample of size
𝑘is then (𝑘𝜀)-differentially private via sequential composition [15], which means
the probability of observing a particular join sample increases/decreases at most by a
multiplicative factor exp(𝑘𝜀) due to the presence/absence of an individual user record.
1.1
Contributions.
An overview of the proposed approach can be found in Figure 1.
Weighted random sampling over the join rows is formalised through
a multinomial sampling design [5, 12, 18, 24, 29, 45], which sam-
ples with-replacement with probabilities proportional to weights.
This means each sampled join row is sampled independently and
there can be repetitions of join rows. In order to compute aggregate
weights of by-table-groups the problem is formulated as a graph
problem that can be solved with an approach akin to dynamic pro-
gramming. Unlike prior work [8, 47, 62], the proposed framework
for multi-way joins (cf. Section 3) is sufficiently expressive to also
support outer joins and semi/anti-joins and only requires stream-
based access to the tables. The aggregate weights are then plugged
into a multinomial sampler. For this purpose an online multinomial
sampler is proposed (cf. Section 5) to collect multiple sampled join
rows at once without requiring multiple passes over the main table.
The online multinomial sampler faces a unique set of problems and
although some works deal with simpler instances of the problem
[26, 51], the problem has not been previously solved apart from
some naive methods. Finally it is shown how to correctly and ef-
ficiently utilise statistical methods to check if a sample follows
the intended distribution (cf. Section 6), discuss how everything
ties together with existing works (cf. Section 7) and conduct an
extensive experimental evaluation (cf. Section 8).
The experimental findings are that the proposed sampling ap-
proaches require much less memory than building indexes, typically
by a factor of 10. Even if one is fortunate enough to have indices
already in place, then the proposed approach is actually not much
slower. However, in the more likely case that pre-built indexes are
not available, the proposed approaches are up to two times faster.
1.2
Limitations.
As an open problem remain general cyclic joins that might be
insurmountable due to their relationship with other hard problems
such as triangle counting (see also [10]). Essentially, the state-of-
the-art as in [47, 62] is to reduce the problem to acyclic joins and
then purge rows violating the cyclic join. Clearly, this presupposes
that a reasonable fraction of the rows from some acyclic join does
not violate the cyclic join. Hence, if this gamble works out or not is
completely data-dependent. For sake of completeness, strategies for
cyclic joins are also laid out and evaluated (see Section 3.4), but as
there is only limited benefit to solving some handpicked problem
instances that are unlikely to be representative, the focus of this
work lies primarily on acyclic joins. Such joins are challenging on
their own in case of many-to-many relations (cf. Figure 2) that can
lead to a vast increase in the join size (cf. Table 2).
1.3
Background on Join Sampling
The naive approach to first compute the join and then sample
from the join result (either using inversion sampling or weighted
reservoir sampling [17]) largely defeats the purpose. To first sample
and then join only produces a (simple) random sample if all join
attribute values are distinct, but even then it is typically not useful
as the resulting sample is too small (see also [1, 8]).
Inversion sampling (popularised by Smirnov [49] over 80 years
ago) is as simple as uniformly drawing a random number between 0

---

Weighted Random Sampling over Joins
and 1 and plugging it into the inverse of the cumulative distribution
function (cf. Figure 4). The uniformly drawn random number is used
as a normalised rank and the join row at that rank is retrieved using
the inverse function. While for joins with just a single join attribute
one could sort all base tables by that attribute and systematically
jump through the join results, it is not clear if this could be done
for multi-way joins.
Rejection sampling (popularised almost 70 years ago by Von Neu-
mann [55]) modifies the ratios between selection probabilities by
rejecting each element with an individual probability. For instance,
suppose one element is twice as likely as the other one, but one
would like to reverse this ratio, one could always accept the initially
less likely one and reject the other with probability 3/4. Similarly, if
one wants to go from simple random sampling to weighted random
sampling, one could always accept the element with the maximal
weight and accept an element with half the maximal weight half
the time. The acceptance rate is then roughly the ratio between
average and maximal weight, which is often very small.
Join synopses (introduced by Achyara et al. [1] over 20 years ago)
focus on so-called foreign key joins where one can order the tables,
such that each row in the first table joins with exactly one row in
the second table and so on. Thus, one can just sample from the first
table of that order and follow the links (see also Linked Bernoulli
Synopses [20]). As user-defined weights (or even selections) can
destroy these links and become known at query time, this approach
would need to be used with very large sample sizes and augmented
with rejection sampling to utilise it in the weighted setting.
Zhao et al’s recent approach [62] has been the first method for
random sampling over multi-way joins. The basic idea is to start
out with an approximate distribution (or the exact distribution as in
the “exact weights” method) generalising ideas from Chaudhuri [8]
and then applying rejection sampling as in Olken’s method [38] to
obtain the correct distribution. While this generalises both Chaud-
huri’s and Olken’s method into a single framework for multi-way
joins, the approach heavily depends on indexes for join attributes,
solely focusing on sampling times, while other key practical consid-
erations (such as memory usage and index availability and building
time/space costs) are overlooked. The single other approach is [47]
which interestingly links the problem to probabilistic graphical
models, but is again limited to uniform weights with a singular
focus on query-time. Critically, as published these methods are
limited to simple random sampling.
Another important concept is superset sampling. In this context
the superset would contain all join results, but also additional cross
product rows that violate some join conditions. As non-join rows
are dropped later-on, the final probability of selecting them is zero
and any proportions between join row probabilities are maintained.
For instance, the results of a cyclic join are a subset of results of an
acyclic join that satisfies an additional join condition. As pointed
out in [62], one can sample from a superset acyclic join and then
drop any non-cyclic results. In this work, this idea is used for acyclic
joins to reduce the memory footprint. If join conditions over equal
attribute values are replaced with join conditions over equal hash
values of attribute values, one can reduce the bookkeeping from per-
attribute-value to per-hash-value and vastly reduce the memory
footprint.
(a) Many-to-One
𝐴𝐵
𝐵𝐶
𝐶𝐷
𝜋𝐴,𝐵(𝐴𝐵⊲⊳𝐵𝐶⊲⊳𝐶𝐷) = 𝐴𝐵
(b) Many-to-Zero/One
𝐴𝐵
𝐵𝐶
𝐶𝐷
𝜋𝐴,𝐵(𝐴𝐵⊲⊳𝐵𝐶⊲⊳𝐶𝐷) ⊆𝐴𝐵
(c) Many-to-Many with Keys
𝐴𝐵
𝐵𝐶
𝐶𝐷
(d) Many-to-Many
𝐴𝐵
𝐵𝐶
𝐶𝐷
Figure 2: Taxonomy of different types of joins
𝐴𝐵
𝐵𝐶
𝐶𝐷
𝐵𝐺
𝐺𝐻
𝐴𝐹
𝐴
𝐵
weights
𝑎1 𝑏1 𝑤(𝑎1𝑏1)
𝑎1 𝑏2 𝑤(𝑎1𝑏2)
𝑎3 𝑏3 𝑤(𝑎3𝑏3)
𝑎2 𝑏4 𝑤(𝑎1𝑏1)
𝑤(∅𝐴𝐵)
NULL
𝐹
𝐴
weights
𝑓1 𝑎1 𝑤(𝑓1𝑎1)
𝑓2 𝑎2 𝑤(𝑓2𝑎2)
𝑓3 𝑎2 𝑤(𝑓3𝑎2)
𝑓4 𝑎4 𝑤(𝑓4𝑎4)
𝑤(∅𝐹𝐴)
NULL
𝐶
𝐷
weights
𝑐1 𝑑1 𝑤(𝑐1𝑑1)
𝑐2 𝑑2 𝑤(𝑐2𝑑2)
𝑐2 𝑑3 𝑤(𝑐2𝑑3)
𝑐4 𝑑4 𝑤(𝑐4𝑑4)
𝑤(∅𝐶𝐷)
NULL
𝐵
𝐶
weights
𝑏1 𝑐1 𝑤(𝑏1𝑐1)
𝑏2 𝑐1 𝑤(𝑏2𝑐1)
𝑏3 𝑐2 𝑤(𝑏3𝑐2)
𝑏4 𝑐3 𝑤(𝑏4𝑐3)
𝑤(∅𝐵𝐶)
NULL
Figure
3:
Running
example:
Acyclic
six-way
join
(𝐹𝐴d|><|d𝐴𝐵|><|d 𝐵𝐶|><𝐶𝐷) |><|𝐴𝐺|><|𝐺𝐻where 𝐵from 𝐴𝐵’s 𝐵is
a foreign key in 𝐵𝐺and 𝐵𝐺’s 𝐺is a foreign key in 𝐺𝐻. 𝐵𝐶’s
𝐵is simply a key.
0
1
0.0
0.2
0.4
0.6
0.8
1.0
𝐹(𝑎) = Í𝑎
𝑖=1 𝑝𝑖
events
𝑋= 𝛽1
𝑋= 𝛽2
𝑋= 𝛽3
𝑋= 𝛽4
𝑋= 𝛽5
𝑋. . .
𝑋= 𝛽𝐴−1
𝑋= 𝛽𝐴
𝑋= 𝛽𝐴+1
𝑋. . .
𝑋= 𝛽𝑁
𝑢∼𝑈(0, 1)
𝑝𝐴
𝑋= 𝐹−1(𝑢)
Figure 4: Inversion sampling draws from a distribution with
distribution function 𝐹by generating a random value 𝑢∈
[0, 1] and then selecting 𝐹−1(𝑢) = arg min𝑥{𝐹(𝑥)|𝐹(𝑥) ≥𝑢}.
2
PROBLEM SETTING
The running example throughout the paper can be found in Figure 3,
where the foreign-key appendages 𝐵𝐺and 𝐺𝐻are often omitted
as they can be thought of as additional columns of 𝐴𝐵. Since the

---

Shekelyan et al.
example also features outer joins, null values are treated like special
rows that can be assigned different weights for each table. The table
𝐴𝐵will serve as the main table throughout this work, which is
typically picked as the largest table. In the proposed stream method
(Section 3), only one sequential scan over the main table is needed,
while two scans are needed for the other tables.
2.1
Formal Definition
Definition 2.1 (user-defined weight function). A user-defined weight
function 𝑤maps any base table row (vector) 𝜌to a user-defined
positive real 𝑤(𝜌) and for any combination of base table rows
𝑤(𝜌× 𝜏× . . . × 𝛾) = 𝑤(𝜌) · 𝑤(𝜏) · . . . · 𝑤(𝛾).
It is often convenient to express the weights over base table
rows as products of per-column weights, which if not specified are
simply set to 1. Some care is required to not “double-count” join
columns as they appear in multiple base tables. Selection operators
over base tables can be expressed as weight functions, i.e., selected
rows are mapped to 1 and non-selected rows are mapped to 0.
Definition 2.2 (weighted random sample (with-replacement) over
join queries). A weighted sample (with-replacement) of size𝑛from a
set of rows {𝛽1, 𝛽2, . . . , 𝛽𝑁} with weighting function𝑤is a (sparsely
represented) frequency vector [𝑥1,𝑥2, . . . ,𝑥𝑁] that follows a multi-
nomial distribution with 𝑛trials and normalised weights as event
probabilities 𝑝1, 𝑝2, . . . , 𝑝𝑁, i.e., 𝑝𝑖= 𝑤(𝛽𝑖)/Í𝑁
𝑗=1 𝑤(𝛽𝑗).
The rows {𝛽1, 𝛽2, . . . , 𝛽𝑁} are in this case the result of the join
query. If there are just two rows, the multinomial distribution has
just two events and becomes simply a binomial distribution. Simple
random sampling is a special case with 𝑝𝑖= 1/𝑁. An acyclic/cyclic
join query is in this work defined via a graph where each node is a
table and each edge indicates that two tables are joined. In case of
an acyclic join query, the join graph is a tree wheres in case of a
cyclic join query, the join graph has a cycle (e.g., in Figure 9 “QX”
is acyclic, whereas “QY” is cyclic.).
2.2
Desiderata
Weighted: A weighted sampler independently samples join rows
with probability proportional to the product of arbitrary base table
row weights.
Note that this definition is limited to weights that can be fac-
torised over base tables, because sampling decisions otherwise
would have to be postponed until a join row is completed. Ar-
bitrary weights can still be achieved in post-processing through
rejection sampling, but the effectiveness of the post-processing
technique will depend on how close the existing probabilities come
to the needed ones. One would expect this gap to be significantly de-
creased for factorised weights that aim to approximate the complex
weighting functions.
Efficient: An efficient sampler performs for acyclic joins 𝑂(𝑇+ 𝑛)
operations and stores at most 𝑂(𝑇) values, where 𝑇is the maximal
table size and 𝑛is the sample size.
As any sampler needs to process all base tables and generate
all samples, 𝑂(𝑇+ 𝑛) is optimal. While storing 𝑂(𝑇) values is not
optimal, it is not an onerous requirement. The restriction to acyclic
Table 1: Desiderata Checklist
Approach
Weighted
Efficient
Ad-Hoc
Streaming
only two-way joins
Olken’93 [38]
✓
✓
✓
Chaudhuri’99 [8]
✓
✓
multi-way joins
With-Index [47, 62]
✓
Rejection [55]
✓
✓
Inversion [49]
✓
Proposed
✓
✓
✓
✓
join queries is needed, as it is not known (and one might conjecture
the opposite) if such a sampler can exist for cyclic join queries.
Ad-hoc: An ad-hoc sampler behaves as if the data is generated at
query time.
While the data likely exists in some form before query-time, in
many cases it is only brought into the query-relevant form at query
time, as it either needs to be assembled or modified. For instance,
different users might have different access to the data and some
sensitive parts might have to be masked before it is handed over
to the user. The ad-hoc property excludes precomputed indexes
or other data preprocessing techniques. In this way, the “ad hoc”
desideratum avoids the time/space costs related to building and
storing indexes.
Streaming: A streaming sampler stores no previously seen rows
completely unless they are sampled, accesses all tables at most
twice as an unordered stream of rows and accesses one of the tables
at most once.
The streaming setting typically implies just one pass over the
data with insufficient memory to record the stream. When joining
streams of rows, this is generally not possible as each new streamed
row can turn any previous non-join row of another stream into
a join row. For this reason, the single-pass condition only applies
to one stream and allows other streams to be passed twice, which
is optimal. Multi-pass streaming is still desirable as stream access
is a universal interface and lends itself to embarrassingly parallel
algorithms.
In this work, a “practical sampler” is sought after that satisfies all
these outlined properties, practical in the sense of a fully functional
implementation with an empirical performance that is reflective
of the asymptotic complexities, i.e., no large hidden constants. As
shown in Table 1 none of the existing works manages to satisfy
all of these properties even for equal probabilities. Prior works
do not support weighted sampling as published2. As mentioned,
[47, 62] are efficient samplers, but assume memory-resident data
with pre-computed indexes.
2In the experimental section of this work one can find an implementation that modifies
the proposed methods to use an index. While it comes fairly close to generalising [62]
to weighted sampling, it admittedly is more of a generalisation of proposed methods to
using an index. Thus, it could be speculated that it should not be too hard to generalise
prior works, but it has not been rigorously explored in this work.

---

Weighted Random Sampling over Joins
join node
row node
null node
𝐴𝐵
𝐵𝐶
𝑤(𝑎1𝑏1)
𝑤(𝑎2𝑏1)
𝑤(𝑎3𝑏3)
𝑤(𝑎3𝑏5)
𝑤(∅𝐴𝐵)
1
1
1
1
1
𝐵𝐶
𝑤(𝑏1𝑐1)
𝑤(𝑏3𝑐2)
𝑤(𝑏3𝑐3)
𝑤(𝑏4𝑐3)
𝑤(∅𝐵𝐶)
(a) Each join node is the root of
a sub-tree (left to right).
𝐴𝐵
𝑤(𝑎1𝑏1)
𝑤(𝑎2𝑏1)
𝑤(𝑎3𝑏3)
𝑤(𝑎3𝑏5)
𝑤(∅𝐴𝐵)
𝑤(𝑏1𝑐1)
𝑤(∅𝐵𝐶)
𝑤(𝑏3𝑐2) + 𝑤(𝑏3𝑐3)
𝑤(𝑏4𝑐3)
𝑤(∅𝐵𝐶)
(b) Weights of each sub-tree can
be transferred into join node.
Figure 5: Graph formulation for two-way join
3
STREAM JOIN SAMPLER
3.1
Introduction
The basic idea of join sampling approaches is to extend a tuple
table-by-table. For a uniform sample, the extension must be drawn
with probability proportional to the size of the (sub)join of a tu-
ple with the tables downstream [8, 62]. This insight carries over
to weighted join sampling, where the probability must be propor-
tional to the total weight of the subjoin. In [62] a tuple-oriented
approach is taken to satisfy this constraint, where tuples are indi-
vidually extended table-by-table, which is reliant on random access
and index structures. Note that despite the use of indices [62] still
requires time linear in the size of the tables to collect the full sam-
ple. Hence, this work instead proposes a table-oriented approach,
i.e., tables are scanned sequentially one-by-one. Intuitively, this is
achieved by processing all extensions by one single table in one
go akin to bread-first-search, rather than extending each tuple by
all tables akin to depth-first-search. The foundation of such an
approach is a proposed multipartite graph formulation that adds
support to weighted sampling, non-equi joins, outer joins, selec-
tions, semi- and anti-joins (none of which are supported in prior
work [8, 38, 47, 62]).
Notation. Throughout this section, table names are used that match
the columns, e.g., if a table has columns 𝐴and 𝐵the table will be
called 𝐴𝐵. If two tables have the same column name and are joined
together, the join conditions will be to enforce equality across all
columns with the same name as in a natural join. For attribute
values of table rows for a column instead the lower case 𝑥1,𝑥2, . . .
is used to denote various independent values of a column 𝑋.
3.2
Multipartite Graph Formulation
Graph formulation. In order to more easily reason about not just
inner joins, but also outer joins, it is useful to formulate the join
operation through a graph, where rows and join attribute values
form a multipartite graph with one partition of nodes per table and
join column.
An example of such a multipartite graph for a two-way join can
be found in Figure 5. The nodes of the graph are:
• Row nodes: Each table is a set of nodes, one node for each
row, e.g., there is a node for row 𝑎1𝑏1.
• Null nodes: “NULL” values for a table are presumed to be an
additional row of the table, e.g., ∅𝐴𝐵.
• Row node labels: Each row node is labelled with the row
weight, e.g., 𝑤(𝑎1𝑏1), even null nodes, e.g., 𝑤(∅𝐴𝐵).
• Join nodes: Each join column is a set of nodes, one node for
each attribute value, e.g., 𝑏1.
• Join node labels: Each join node is initially labelled with the
value 1, e.g., the node for 𝑏1 has a label 1.
As join operators are not necessarily symmetrical, there is a “left”
and a “right” side. The edges of the graph potentially connect join
nodes with row nodes with matching join attribute value, but it
depends on the join operator if they do:
• Each join node for d|><| , |><|d , d|><|d and |><| is connected to each
matching row node.
• Each join node for |><|d and d|><|d that is not connected to any
row node on the left side is connected to the left null node.
• Each join node for d|><| and d|><|d that is not connected to any
row node on the left side is connected to the right null node.
• Each join node for |>< has label 0 if there is no match on the
right side.
• Each join node for |> has label 0 if there is a match on the
right side.
This simply means left outer joins ( d|><| ) allow null values on the
left side and right outer joins ( |><|d ) on the right side, while full outer
joins allow them on either side ( d|><|d ). Semijoins ( |>< ) and antijoins
( |> ) are filters that change the weight of a join node depending on
if there is a match on the right side.
The main motivation for this formulation, is that in such a graph,
the trees spanning all partitions corresponds to join rows:
• Result trees: Each tree that contains exactly one node from
each reachable partition corresponds to a join row (right side
partitions of semijoins or antijoins are unreachable).
• Trivial rule: A result tree cannot contain join nodes that are
only connected to null nodes.
The weighted sampling problem can then be posed via the mul-
tipartite graph formulation:
Definition 3.1 (Weighted Sampling over Joins). Select a random
result tree 𝑅(corresponding to a join row) comprised of nodes with
labels 𝑤1, . . . ,𝑤𝑘with probabilities proportional to the tree’s total
weight Î𝑘
𝑖=1 𝑤𝑖.
As there are as many result trees as join rows, some method is
needed to reduce the complexity noticeably below the number of
join rows. As each tree is sampled with probabilities proportional to
their weight, any group of trees will be sampled with probabilities
proportional to their sum of weights. Thus, one can sample the
result tree step by step rather than in one go, which will be shown
in the following to allow for sub-linear complexity.
Efficient solution to graph problem. The basic idea is to group all
result trees that have the same root and then sample such a root-
group. The challenge left to solve is how to compute the sum of
weights of each root-group. The right side of Figure 5 shows the
most crucial primitive for this purpose. The operation sums the
weights of all sub-trees of each join node and adds it as a new label

---

Shekelyan et al.
join node
row node
null node
|><|d
𝐴𝐵
𝐵𝐶
d|><|d
𝐹𝐴
|><
𝐶𝐷
0
0
(a) Graph Formulation for Running Example
|><|d
𝐴𝐵
𝐵𝐶
d|><|d
𝐹𝐴
|><
0
0
(b) after 1 iteration
|><|d
𝐴𝐵
𝐵𝐶
><|d
|><
0
0
(c) after 2 iterations
|><|d
𝐴𝐵
><|d
(d) completed
Figure 6: Algorithm 1’s iterations (Lines 7-22) preserve the weight of result trees, but simplify the graph by removing partitions
of the join node. Such an operation can be implemented through
a linear-time sequential scan of 𝐵𝐶and generating a hash table
of 𝐵-values contained in 𝐵𝐶where each entry holds the sum of
observed weights of each 𝐵-value. In SQL-terms, one can think of
such an operation as something along the lines of Select SUM(W)
from BC group by B where 𝑊is presumed to be some column
holding the weights of 𝐵𝐶. As a second step, one can scan 𝐴𝐵,
which holds the root nodes. Now, for each row 𝑎𝑖𝑏𝑗of 𝐴𝐵one can
look up the sum of sub-tree weights 𝑊(𝑏𝑗) in the hash table entry
of the key 𝑏𝑗. The total weight of all groups that contain 𝑎𝑖𝑏𝑗is
then 𝑤(𝑎𝑖𝑏𝑗)𝑊(𝑏𝑗). If 𝐵𝐶is not a leaf node, one simply recursively
continues this procedure to compute the weights of 𝐵𝐶until the
leaf nodes are reached. Once a group with 𝑎𝑖𝑏𝑗as a root node is
sampled with probability proportional to its total weight, one can
continue in a similar fashion with the children nodes (adjacent
nodes in the graph facing away from the main table), until the
full tree is obtained. Semi-joins, anti-joins and selections can be
supported through weights, which is detailed later.
Algorithm. It is described in Algorithm 1 how the group weights
can be obtained for general multi-way joins. Figure 6 applies the
algorithm for the running example. 𝐴𝐵serves as the main table
(see Line 2), such that the parent moves closer to 𝐴𝐵(Line 3) and
children node move further away from 𝐴𝐵(Line 4), while leafs such
as 𝐶𝐷are on the outskirts furthest away from 𝐴𝐵(Line 5). The
algorithm processes a new table in each iteration (Lines 7-22). It
makes a single stream pass over the rows of the new table (Lines 11-
18, computes the total weight of the sub-trees rooted at the row
(Lines 12-15) and add this sub-tree weight multiplied by its own
weight 𝑤(𝜌) to the parent join node (Lines 16-18). After the new
table has been processed it is removed from further consideration
(Lines 19-21) and the algorithm goes back to Line 7 and terminates
when no more tables are left for consideration. After termination,
each row node 𝜌of the main table is linked to multiple join nodes
and the product of the join node labels multiplied by 𝑤(𝜌) yields
the total weight of all results trees / join rows containing 𝜌.
The algorithm can be implemented with a hash table 𝐻J for
each join node partition J that allows an efficient lookup of the
linked join node for a row node based on the join attribute value.
Note that if all join nodes except a few have the same label, one
only keeps entries for the exceptions and maintains a default value
for the rest.
The hash table entries for a table can be computed in one scan
that skips any rows that do not satisfy the selection predicates.
Algorithm 1: Group Weights
1 Let 𝐺= (𝑉, 𝐸) be a multipartite graph corresponding to the
join query and 𝑤(𝜌) be a node 𝜌’s label.
2 Let root(𝑉) = A ⊆𝑉be the row node partition of the join
query’s main table.
3 Let parentA (T,𝑉′) be all neighbouring join node
partitions in 𝑉′ closer to A than T.
4 Let childrenA (T,𝑉′) be all neighbouring join node
partitions in 𝑉′ further away from A than T.
5 Let leafsA (𝑉′) be all row node partitions in 𝑉′ furthest
away from A, excluding A.
6 Initiate 𝑉′ as 𝑉.
7 while |leafsA (𝑉′)| > 0 do
8
Pick a row node partition T ∈leafsA (𝑉′)
9
Let J0 = parentA (T,𝑉′).
10
Set the label of all nodes in J0 to −∞
11
foreach row node 𝜌∈T do
12
Initiate 𝑊as 1
13
foreach join node part. J ∈childrenA (T,𝑉′) do
14
Let 𝑊J be the label of 𝑗∈J connected to 𝜌
15
Multiply 𝑊by 𝑊J.
16
Let 𝑊J0 be the label of 𝑗∈J0 connected to 𝜌
17
if 𝑊J0 = −∞then Set 𝑊J0 to 0
18
Add 𝑤(𝜌)𝑊to 𝑊J0.
19
Remove row node partition T from 𝑉′
20
foreach join node partition J ∈childrenA (T,𝑉′) do
21
Remove join node partition J from 𝑉′
22
Replace all labels −∞with 𝑤(∅T) for nodes in J0
In case of a semi-join, the default value is 0 and only entries are
1 for results of the semi join. While an anti-join can be as large as a
table, for sampling it can be supported via semi-join: For anti-joins
the default value is 1 and only entries are 0 for results of the semi
join.
Theta/non-equi-joins can also be easily supported. If the link
condition is ≠, then in addition to the hash-table one needs to
maintain the total weight of all hash-table entries. Then the weight
for equi-joins can simply be subtracted from the total weight, to
obtain the ≠-join weight. For theta joins with a binary operator

---

Weighted Random Sampling over Joins
⊙∈{<, ≤, ≥, >} for the link condition, one can first obtain the equi-
join hash table and then replace the values with cumulatives. This
means that the entry for each join attribute value 𝑥holds the sum
of weights of any equi-join entry 𝑦that satisfies 𝑦⊙𝑥. Additionally
a binary search tree needs to be constructed to efficiently find the
last value 𝑦⊙𝑥where 𝑥is the queried value from a joining table.
Then the queried value can be rewritten as the last hash table value.
It is also possible to obtain some limited support for Group by’s,
as they can be performed after the sample is collected. In order to
obtain a better coverage of groups, the weights should ideally be
chosen inversely proportional to the size of the groups.
3.3
Multistage Multinomial Sampling
In the previous section weighted join sampling has been mapped
to the problem of sampling result trees with probabilities propor-
tional to their weight (in simple cases they are paths). In a usual
implementation, each join node partition is implemented as a hash
map, such that by going each row 𝜌in the main table one can look
up matching entries in the hash maps and compute the product of
the looked up values and 𝑤(𝜌) to obtain the total weight 𝑊(𝜌) of
all result trees that contain 𝜌. After executing Algorithm 1 which
brings the graph into the state of Figure 6d, the total weight 𝑊(𝜌)
of each 𝜌can therefore be computed using at most one hash-table
look-up per table.
As the task is to sample with probabilities proportional to𝑊(𝜌),
one can in a first stage perform a stream pass over the main table
and collect a sample using the proposed online multinomial sampler
from Section 5. After collecting the main table sample, this yields
the sampled groups of result trees grouped by the main table row
and it is left sampling within the groups. In the graph formulation
(see Figure 5), each row 𝜌in the main table sample is on the “left”
side, linked to a join node in the “middle” that links to multiple row
nodes on the ”right side. The task is then to sample for each sampled
main table row, a row node on the “right” side with probabilities
proportional to the rest of the result tree weight. Luckily, the total
weights of the sub-trees have been previously computed and are
readily available in the hash maps for the join nodes. As the total
weight 𝑊of the right side is known, one can use here inversion
sampling (see Figure 4), i.e., draw a random number 𝑢between 0
and 𝑊and go through the right side table until the total weight of
observed rows is more than𝑢and then pick the preceding row. This
allows to collect all sample continuations of the main table sample
in one stream pass. Thus, in each stage the rows in the sample are
extended by the row of another table until all tables that participate
in the join have been reached. The main table due to the online
multinomial sampler from Section 5 is only scanned once, while
all other tables are scanned twice. In the general case, the second
scans of the other tables cannot be avoided. Hence, this approach
is optimal with regards to the number of sequential scans.
3.4
Handling Cyclic Joins
While the main focus of this paper are the more common acyclic
joins, this section discusses the more exotic cyclic joins that some-
times receive some academic interest. As in the literature, cyclic
joins are treated as a selection predicate over the join rows of an
acyclic join.
For a join graph where each node is a table and each edge is a
join condition, a join query is called cyclic if the join graph features
at least one cyclic path that passes through at least two edges and
three nodes.
Rewriting as Selection over Acyclic Join Query. Any cyclic join query
such as 𝐴𝐵⊲⊳𝐵𝐶⊲⊳𝐶𝐴can be rewritten into a selection over
an acyclic join, e.g., 𝜎𝐴1=𝐴2𝐴1𝐵⊲⊳𝐵𝐶⊲⊳𝐶𝐴2. If a join query
has multiple cycles, each cycle adds one equality predicate to the
selection operator. Note that here a natural join formalisation is
used and join conditions are removed by renaming attributes.
If the selection has high selectivity, i.e., selects most of the
records, then one can first sample from 𝐴1𝐵⊲⊳𝐵𝐶⊲⊳𝐶𝐴2 and
then drop any samples that do not satisfy the selection predicate
𝜎𝐴1=𝐴2. The acceptance rate is then on expectation equal to the
selectivity, i.e., |𝜎𝐴1=𝐴2𝐴1𝐵⊲⊳𝐵𝐶⊲⊳𝐶𝐴2| / |𝐴1𝐵⊲⊳𝐵𝐶⊲⊳𝐶𝐴2|. As
the acceptance rate can vary wildly depending on which join con-
ditions are outsourced as selections, this leads to an interesting
problem of an optimal rewriting, i.e., one that maximises the selec-
tivity. A simple heuristic to select which edge to remove from the
cycle is to pick the join link 𝑋⊲⊳𝑌that maximises the probability
|𝑋⊲⊳𝑌|/(|𝑋| · |𝑌|) that two independently drawn random records
from both tables are linked. This is in principle very similar to the
Chow-Liu algorithm [11] that aims to break links where the mutual
information is lowest.
The rewriting of a cyclic join query into a selection over an
acyclic join is described in the following. One goes through each
node (table) and follows each of its adjacent edges (join conditions)
to a neighbouring node. For each adjacent edge one looks for the
shortest path between its two end nodes that is not allowed to pass
the adjacent edge. If no such path can be found then the node does
not participate in a cycle. If such a path can be found, the node
participates in at least one cycle and one can pick an edge in that
cycle that one wants to outsource as a selection predicate. After the
removal of an edge, one can check for cycles again until the node
no longer participates in a cycle. For a join graph with |𝑉| nodes
and |𝐸| edges such a procedure performs at most |𝑉|2C shortest
path searches where C is the number of cycles. As join graphs
are very small and the number of cycles is at most 2|𝑉|2−|𝑉|, the
searches only takes a couple of milliseconds to perform. A more
challenging problem is how to pick which edge to remove. While
one could estimate the selectivity for each candidate, that can be
quite expensive and take more time than the subsequent sampling
step.
4
ECONOMICAL JOIN SAMPLER
The previous section presented the fundamentals for stream sam-
pler. It will now be considered how one can obtain an economic
sampler with a reduced memory footprint for various types of joins.
4.1
Exploiting Foreign Key Joins
Many-to-one relations allow to first sample from the “many” table
and then look-up the “one” entity in the other table(s). If the weights
are all equal, then this reduces to sampling from one table and then
joining the sample with the other tables. If the weights are not equal,
one can either first proceed as if they were equal and afterwards
employ rejection sampling to rectify inclusion probabilities, or one

---

Shekelyan et al.
equi join
equi-hash join
cross join
Figure 7: Hierarchy of join results. Samples from any equi-
hash join with superflous elements purged (depicted in red)
are ordinary samples from the equi join
needs to find the group weights and treat the foreign-key join like a
many-to-many join. The former is more memory efficient, whereas
the latter is reliably fast. For the economical sampler one picks the
more memory efficient variant.
4.2
Simplifying Cyclic Joins
While some join queries can look like a challenging cyclic join on
first glance, it is sometimes possible to reduce it to a much sim-
pler query, e.g., an acyclic one. If a subgraph of the join graph is
a foreign-key join, one can efficiently join the subgraph together
and the join result can only have as many rows as the largest of
the joined tables. To automate and generalise this process without
knowledge of foreign key constraints, one can simply join all ta-
bles together where the join result is at most slightly larger than
the tables itself. For table sizes up to 𝑁, this simplification step
requires 𝑂(𝑁) expected time and 𝑂(𝑁) space using hash joins
or 𝑂(𝑁log 𝑁) worst-case time and 𝑂(𝑁) space using sort-merge
joins.
4.3
Novel Hashed Join Method: Handling
High-Cardinality Join Attributes without
Approximations
In case there are many distinct attribute values over join attributes
within very large base tables, additional techniques are needed to
reduce the memory footprint. A good way to think about join rows,
is as a subset of cross product rows that satisfy join conditions. By
relaxing the equi-join condition to a equi-hash-join conditions, one
obtains a superset:
Definition 4.1 (Equi-Hash Join). The equi-hash join along some
join column between two tables 𝐴𝐵and 𝐵𝐶is the subset of the
crossproduct of rows where the hash value in the join column
matches for a shared hash function.
Note that any result in the equi-join also must be in the equi-hash
join, because if two attribute values are equal, so are their hashes
(see also Figure 7). Thus, equi-hash joins reduce the number of
join attribute values in a controlled way (controlled by the chosen
hash function) by allowing to operate over the smaller number
of hash values. While the reduced domain leads to collisions, all
those collisions only lead to some extraneous results that can be
purged later on without any negative impact on precision. More
specifically, the collisions cause additional rows from the cross
product that violate the join conditions, but are easy to identify
during the post-processing of the sample.
As the number of purged rows is not fully predictable, it can
be necessary to generate more samples than expected. To avoid
this when possible, one can choose a sufficiently large sample.
A common source for a large number of distinct values are join
columns that are database keys. In that particular case, one can
predict:
Lemma 4.2. Let 𝑇1,𝑇2, . . . ,𝑇𝑘be 𝑘tables with unique values along
the join columns. The hash-relaxed equi-join 𝑇1 ⊲⊳𝑢𝑇2 ⊲⊳𝑢. . . ⊲⊳𝑢𝑇𝑘
using a universal hash function with universe of size 𝑢is expected to
have at most 2𝑚( 𝑚
𝑢)𝑘−1 superfluous results that are not present in
𝑇1 ⊲⊳𝑇2 ⊲⊳. . . ⊲⊳𝑇𝑘where 𝑚= max(|𝑇1|, |𝑇2|, . . . , |𝑇𝑘|).
Thus, as a heuristic, it is proposed to collect a 2( 𝑚
𝑢)𝑘−1 times
larger sample for the hash-relaxed superset (𝑚and 𝑢as defined
in Lemma 4.2) if that does not exceed the memory limit, because
the join size is expected to be at least as large as the tables. As the
number 𝑘counts the tables where 𝑢is much smaller than 𝑚, it is
dependent on the choice of 𝑢. Thus, different choices of 𝑢can be
tried out find the best choice within the formula before the sampling
commences. When the memory limit does not allow the needed
sample size, or the join has many distinct values without joining
keys, then the hashing algorithm can be run multiple times with
different random seeds to collect the targeted amount of samples.
5
ONLINE MULTINOMIAL SAMPLER
This section solves how to draw a multinomial sample for an un-
known population size where multinomial probabilities are only
given indirectly through weights that are proportional to the prob-
abilities. Each population item is only seen once (one-pass) and
only memory proportional to the sample size is available, such that
storing all population items it not feasible. The online multino-
mial sampling problem (equivalent to the online weighted with-
replacement problem) has been alluded to in the literature [16],
but appears to not have been explicitly solved. Note that unlike
in [26] the weights here are real-valued and unlike in [51] only
weights proportional to probabilities are available. The baseline
technique from the literature would be to maintain an independent
sampler for each element of the with-replacement sample, which
does not scale with larger sample sizes. This section proposes an
online multinomial sampler based on an adaption of an existing
sampling technique [17].
The basic idea of the proposed approach is to draw an indepen-
dent element with probabilities proportional to weights at each
step. Observe that after the first item is drawn, the probability of
drawing one of the previous items again is simply proportional to
the weights of those previous items. Thus, one needs to consider
two cases. In one case the previously selected item is drawn again
and in the other case a new random element is selected from the
remaining population without previously selected items. For the
first case only need the previously selected items are needed and
for the second case only items are needed from an equally small
ordered sample that can be obtained using existing techniques [17]
which will serve as a proxy for the population items.
Ordered sampling brings the population items into an order such
that one can pick the first (or last) items as the sample. Using this

---

Weighted Random Sampling over Joins
Algorithm 2: Online Multinomial Sampler
1 Initiate 𝑆1,𝑆2, . . . ,𝑆𝑛as weighted reservoir sample
2 Initiate 𝑊P as 0 and multiset 𝑅as {}
3 foreach stream item 𝑥with weight 𝑤(𝑥) do
4
Consider 𝑥for inclusion in 𝑆and add 𝑤(𝑥) to 𝑊P
5 Initiate 𝑊𝑀as 0, 𝑗as 1 and ℓas 1
6 foreach 𝑗∈{1, . . . ,𝑛} do
7
Draw 𝑢∈[0, 1] with 𝑃𝑟(𝑢) ∝1
8
if 𝑢< 𝑊𝑀/𝑊then
9
Set 𝑀𝑗to a randomly drawn 𝑀𝑖∈{𝑀1, . . . , 𝑀𝑖−1}
with 𝑃𝑟(𝑀𝑖) ∝𝑤(𝑀𝑖)
10
else
11
Add 𝑤(𝑆ℓ) to 𝑊𝑀, set 𝑀𝑗to 𝑆ℓand set ℓto ℓ+ 1
12 Return multinomial sample 𝑀1, . . . , 𝑀𝑛
idea, one can generate for each item with weight 𝑤𝑖an independent
exponential variate 𝑣𝑖∼𝐸𝑥𝑝(𝑤𝑖) and order them by these variates.
It follows then from well-known properties of exponential vari-
ates that 𝑃𝑟(𝑣𝑖= min({𝑣1, 𝑣2, . . . , 𝑣𝑁}) =
𝑤𝑖
𝑤1+𝑤2+...+𝑤𝑁. Thus, the
minimum is chosen with probability proportional to weights, the
second-smallest item with probability proportional to weights if the
minimum item did not exist, and so on. Efraimidis & Spirakis [17]
(E&S) analogously use 𝑘𝑖= 𝑒−𝑣𝑖∼𝑈(0, 1)1/𝑤𝑖as random “keys”,
which flips the order by applying the strictly decreasing function
𝑒−𝑥, but otherwise yields the same properties and probabilities just
for the maximum. E&S then define the 𝑛items with the largest 𝑘𝑖as
a “weighted sample” of size 𝑛, although only the largest-key item is
chosen proportional to weights in the final sample [53]. Thus, E&S
do not use the weights to decide probabilities of the overall sam-
pling process, but only in relation to rounds of without-replacement
draws in the urn model. Meanwhile, here the 𝑛largest-key items
are only used as an intermediary for the population. Weighted with-
replacement sampling has a very simple interpretation, i.e., each
item is independently selected into the sample with probability
proportional to its weight.
Now, the proposed approach can be described in Algorithm 2.
The first step of the proposed approach is to find the total weight
𝑊P of all population items P and the𝑛largest-key items𝑆1,𝑆2, . . . ,𝑆𝑛
from P still sorted by the keys, i.e., 𝑘1 ≥𝑘2 ≥. . . ≥𝑘𝑛(Lines 1-4).
From that, it follows that all other population items P/{𝑆1,𝑆2, . . . ,𝑆𝑛}
have a smaller key than 𝑘𝑛and will not make it into the multino-
mial sample. To find the largest-key items one can employ the
weighted reservoir sampler by E&S [17] with the exponential jump
algorithm. In the next steps of the proposed approach (Lines 7-11),
one draws in each step an independent element 𝑀𝑗with 𝑗≥1
and maintains at each moment the total weight 𝑊𝑀of all distinct
elements {𝑀1, 𝑀2, . . . , 𝑀𝑗−1} that were previously selected. Note
that for 𝑀𝑗= 𝑀1 the “abuse of notation” {𝑀1, 𝑀2, . . . , 𝑀𝑗−1} is
used to denote an empty set and for 𝑀𝑗= 𝑀2 it is equal to {𝑀1}.
With probabilities proportional to weights, 𝑀𝑗is either in the set
of previously chosen item or a previously unchosen item:
𝑀𝑗∈
(
{𝑀1, 𝑀2, . . . , 𝑀𝑗−1}
with probability 𝑊𝑀/𝑊P
P/{𝑀1, 𝑀2, . . . , 𝑀𝑗−1}
otherwise
0.0
0.2
0.4
0.6
0.8
1.0𝑃𝑟(𝑋≤𝑎)
𝑎∈N
(a) Discrete Distribution
0.0
0.2
0.4
0.6
0.8
1.0𝑃𝑟(𝑋≤𝑥)
𝑥∈R+
(b) Continuous Distribution
Figure 8: Converting discrete distribution into continuous
one by adding uniform variates (cf. Lemma 6.1) to apply con-
tinuous goodness-of-fit tests such as the K-S Test
A (biased) coin flip determines according to these probabilities
from which set one random element is selected with probabilities
according to weights. Observe that it is exploited here that {𝑆1} is
a one-item weighted sample from P, {𝑆2} is a one-item weighted
sample from P/{𝑆1}, {𝑆3} is a one-item weighted sample from
P/{𝑆1,𝑆2} and so on. All these one-item samples are also indepen-
dent from each other, since they are selected based on independent
keys. Thus, this algorithm offers a simple way to obtain a multi-
nomial sample in a challenging setting of an unknown population
where just one stream pass is allowed.
6
GOODNESS-OF-FIT TESTS FOR
MULTINOMIAL DISTRIBUTIONS
In this section it is shown how to apply Kolmogorov-Smirnov (KS)
testing when the reference distribution is discrete, as an alterna-
tive to goodness-of-fit tests for multinomial distributions such as
the likelhood ratio test[12, 24]. Multinomial tests ignore the order-
ing unlike KS-tests that were originally designed for continuous
distributions. There exist discrete variants of KS-tests [4, 42], but
they lose a lot of desirable properties of the continuous one such
as distribution-free statistics, which is why it is here instead pro-
posed to use the (conventional) continuous KS-test after turning
the discrete distribution into a continuous one in a straightforward
way:
Lemma 6.1 (continuous conversion). Let [𝑥1,𝑥2, . . . ,𝑥𝑁] be a
multinomially distributed frequency vector with event probabilities
𝑝1, . . . , 𝑝𝑁. Let X be a set obtained by drawing for the 𝑖-th event 𝑥𝑖
independent uniform variates between (𝑖−1) and 𝑖. Then X’s distri-
bution is continuous with a piecewise-linear cumulative distribution
function (CDF), i.e., 𝐹(𝑥) = 𝑝⌈𝑥⌉(𝑥−⌈𝑥⌉) + Í⌈𝑥⌉
𝑖=1 𝑝𝑖.
Proof. As shown in Figure 8, the steps of the discrete CDF are
smoothed by adding uniform variates, which have a continuous
uniform distribution with a linear CDF. As a result one obtains
a CDF that interpolates linearly between the steps without any
jumps.
□
The suggested continuous conversion describes how both sam-
ples and reference distributions have to be modified and is a clean
way of applying continuous goodness-of-fit tests. While this comes

---

Shekelyan et al.
with the disadvantage of slightly diluting the original distribution
with additional randomness, this is needed to extend the distribu-
tion’s finite support to an infinite one. Luckily, the impact of the
added randomness quickly dissipates with larger discrete support
size in this application.
7
RELATED WORK
All previous works on join sampling are proposed for simple ran-
dom sampling (equi-weighted) or employ heuristics to sample from
static joins [2, 9, 21, 22, 25, 28, 32, 33, 41] or joins of streams
[3, 19, 43, 59]. Samples collected using heuristics do not follow
any well-defined distribution. In what follows simple random sam-
pling techniques are discussed (see a more detailled discussion in
Section 1.3), which are a special case of weighted sampling with
equal weights.
Foreign key joins that reunite tables from a normalised schema
are equivalent to sampling from one table and then extending the
sample using the other tables [1, 20]. As a result, it is sufficient to
maintain one random sample, i.e., a join synopsis. In essence it is
therefore more akin to conventional rather than join sampling. In-
terestingly, if weights or selections are introduced these approaches
face new challenges that are not so easily addressed.
In [63] a join sample is maintained for one particular𝜃-join query
over an evolving data stream (akin to monitoring queries), which
means interactive user queries are not supported.
Acyclic joins have a tree-like structure where each node corre-
sponds to a tuple’s (sub)join with the tables downstream, which
allows decompositions akin to Yannakakis’s work on acyclic con-
junctive queries [60]. This is useful when reasoning about join
sampling algorithms. Zhao et al. [62] were first to uncover the con-
straint that the extension of a uniformly sampled tuple must be
drawn with probability proportional to the size of the (sub)join
of a tuple with the tables downstream, which generalises the in-
sights from [8] from binary joins to multi-way joins. The key idea
of the algorithm in [62] is a tuple-oriented approach that first ap-
proximates this probability and then later rectifies it via rejection
sampling, which is inspired by Olken’s method [38]. Rejections are
avoided if approximations are exact. As the approach extends each
tuple individually table-by-table, it mandates an index for efficient
operation as explained by the authors of [62] in the “Remarks and
Extensions” section3. This was the first work on multi-way join
sampling, and it reinvigorated interest in random sampling over
joins after a long dormant period. The approach of [62] to cyclic
joins relies heavily on breaking the cycles near-optimally, but it is
not clearly described how this optimisation problem can be solved
efficiently. For sample validation, Zhao et al. [62] propose to utilise
conventional KS-testing to validate samples over join rows. This is
at odds with the statistics literature on (conventional) KS-testing,
which requires a continuous reference distribution4, and appears
to confuse type-I and type-II errors. Hence, in Section 6, a simpler
3Quote from [62]: "as with most random sampling techniques, our random sampling
framework relies on efficient random access to the underlying data. Hence, we do
require index on the join attribute when going from one relation to another. This
means that our framework is mostly useful for an in-memory database where index
structures are often built and maintained for join attributes."
4While KS-testing can be adopted to the discrete setting [4, 42], the work [62] reports
distribution-free critical values which do not exist in the discrete case. The range
of the reported 𝐷-statistics would also (almost certainly) not occur for the reported
TPC-H
𝑆𝐹=10
𝑆𝐹=100
Real-World Data Sets
(W)Q3
6.0 · 107
6.0 · 108
DBLP
4.5 · 107
(W)QX
2.4 · 1012
2.4 · 1013
Twitter QT
4.8 · 1010
(W)QY
5.3 · 1011
5.2 · 1013
Twitter QF
2.7 · 1021
Table 2: Join sizes of queries used in the experiments . Q3 and
DBLP are foreign-key joins, QX and QF are acyclic many-to-
many joins and QY and QT are cyclic joins.
and correct approach to goodness-of-fit testing is proposed. The
experimental evaluation compares against sampling over a materi-
alized join, and assumes that all data resides in memory, including
pre-computed indices. The results in this work show that index-free
solutions based on scans are not much slower, and are well-known
to be more amenable to parallelisation. Critically, none of discussed
works support weighted random sampling over joins.
The major takeaway is that while existing solutions such as
[47, 62] solve the problem for equal-probability sampling over in-
ner joins, but do so at the cost of expensive indexing techniques,
while in this work index-free methods are proposed that offer sub-
stantial memory savings that can also support selections, outer
joins, semi/anti-joins and operate over streams, which is crucial for
heterogeneous data sources.
8
EXPERIMENTS
This section compares the novel stream sampler (minimising scans)
and economic sampler (minimising memory) to existing approaches.
Very large numbers that may be troublesome in practice are high-
lighted in red to draw the attention of the reader.
All experiments are performed on a single thread of a dedicated
machine using Ubuntu 18.04.4 LTS, an Intel(R) Xeon(R) W-2145 CPU
@ 3.70GHz with 16 cores and 512GB RAM. Memory measurements
are taken using the unix primitive /usr/bin/time -v that provides
the “maximum resident set size". All code has been written in C++11
by the same author and was compiled using GCC 7.5.0 with the
compiler flags -O3 and -std=c++11.
8.1
Join Queries
The experiments feature join queries over three datasets with join
sizes shown in Table 2. The dataset used in the TPC-H benchmark, a
social network of twitter users and a citation network using records
from DBLP. Over the TPC-H benchmark the same queries are used
as in [62] (cf. Figure 9), but additionally define weights. The scale
factor corresponds roughly to the size of the dataset in GBs. As
a user-defined weighting function o_totalprice (1-l_discount)
l_extendedprice is used. For QY, the values of both instances
of lineitem and order are multiplied with each other. Weighted
queries are referred to as WQ3 (foreign-key join), WQX (many-to-
many join) and WQY (cyclic join). Over the (raw) twitter dataset
[31] the snowflake query QF and the triangle query QT is used
as posed in [62] (cf. Table 6 and Table 5). For the DBLP data from
Arnet Miner [52] a sample is collected over the citations, weighted
by the year in which the citing paper was published (cf. Figure 11).
sample sizes, if the join result had sufficiently many distinct results to approximate a
continuous distribution.

---

Weighted Random Sampling over Joins
lineitem 𝑙
order 𝑜
customer 𝑐
custkey
orderkey
(a) Q3
nation 𝑛
supplier 𝑠
customer 𝑐
order 𝑜
lineitem 𝑙
nationkey
nationkey
custkey
orderkey
(b) QX
supplier 𝑠
customer 𝑐1
customer 𝑐2
order 𝑜1
order 𝑜2
lineitem 𝑙1
lineitem 𝑙2
nationkey
custkey
custkey
orderkey
orderkey
partkey
(c) QY
Figure 9: Join queries over TPC-H data.
Table 3: Comparison of potential baselines
considered baselines
naive
[62] code
index
Q3 𝑆𝐹=100 memory
26.0 GB
142.0 GB
88.2 GB
Q3 𝑆𝐹=100 query-time
20.2 mins
5.7 mins
7.1 mins
Q3 𝑆𝐹=100 adhoc-time
20.2 mins
64.2 mins
18.2 mins
QX 𝑆𝐹=100 memory
52.0 GB
169.7 GB
95.2 GB
QX 𝑆𝐹=100 query-time
1236.2 mins
5.7 mins
7.9 mins
QX 𝑆𝐹=100 adhoc-time
1236.2 mins
91.5 mins
20.3 mins
QY 𝑆𝐹=10 memory
7.6 GB
36.1 GB
30.6 GB
QY 𝑆𝐹=10 query-time
23.4 mins
5.0 mins
5.8 mins
QY 𝑆𝐹=10 adhoc-time
23.4 mins
14.4 mins
9.8 mins
QY 𝑆𝐹=100 memory
77.6 GB
384 GB
277.5 GB
QY 𝑆𝐹=100 query-time
895.1 mins
42 mins
52.9 mins
QY 𝑆𝐹=100 adhoc-time
895.1 mins
116 mins
102.7 mins
8.2
Compared Approaches
Naive. This approach is a slightly more sophisticated version of
first joining and then sampling. The approach joins together tables
in a greedy fashion that reduces the sizes of the remaining tables
until only one join column remains. Then a merge-sort type of
approach is used to retrieve the inverse of uniform variates. While
this approach is not explicitly proposed in the literature, it seems
fairly straightforward and is a clearly superior baseline to naive
join-then-sample as it avoids materialising the full join result.
As shown in Table 3 it is very slow and it is therefore not used
as a general baseline.
Index Baseline. This approach attempts to implement [62] with exact
weights and generalises it to weighted sampling. As several details
are not clear from the paper, many aspects are reverse engineered
or simplified and generalised. The main goal of this implementation
is to exploit indices in the same way as [62], but ideas from this
work are used to fill in the gaps and streamline the approach. Note
102
103
104
105
106
10−4
10−3
10−2
10−1
sample size
K-S-Test D-Statistic
index baseline
stream
economic
approx10% baseline
approx50% baseline
Figure 10: K-S goodness-of-fit-test (Section 6) on cyclic WQY
query (𝑆𝐹= 1) with over 1012 result rows.
that while the authors of [62] have made their code available, it is
a bare bones research prototype that only supports integer-valued
data, does not allow for non-join columns, is mostly optimised for
speed without any way of outputting or validating samples. As
Table 3 shows, our code is comparably fast. Moreover, it can run
on raw data, additionally supports weighted sampling and can be
validated. Hence, the index-based implementation is used as the
baseline to represent the state-of-the-art technique [62].
Stream (Proposed). The stream-approach implements the proposed
approach from Section 3 and prioritises a stream-like access over
the data and limited number of scans for acyclic join queries. To
only take one pass over the largest (or user-chosen) table it uses
the online multinomial sampler from Section 5.
Economic (Proposed). The economic sampler implements the ideas
from Section 4 and prioritises low memory usage. For foreign-key
joins it first generates a uniform sample and then uses rejection
sampling. For general acyclic joins, it uses the hashed-join tech-
nique to deal with high-cardinality attributes. For cyclic joins it
attempts to simplify the join graph by greedily joining tables that
have a small join size.
8.3
Goodness-of-fit testing
Figure 10 demonstrates that the author’s implementations produce
samples that follow the multinomial distributions based on the
user-defined weights. This experiment uses a weighted cyclic query
to make the test challenging, and also features approximations
based on first sampling the base tables. The Kolmogorov-Smirnov
test statistic is obtained for each returned sample, and shading is
used to indicate the critical region. The considered approaches all
stay with 99% probability below the shaded region. For constrant,
“approximate” solutions which evaluate the query based on samples
of the tables (i.e., the “sample then join” approach) forare shown as
well. Even very large samples (as large as 50% of the base tables)
step into the shaded region, which means they have a statistically
significant deviation from the target distribution.

---

Shekelyan et al.
1.0−𝑌
1.1−𝑌
1.2−𝑌
1.3−𝑌
1.4−𝑌
1 min
10min
1h
10h
weighting function (with year of publication 𝑌)
runtime (mins)
economic
stream
index baseline
Figure 11: Drastic impact of weighting on runtimes of a mil-
lion samples over foreign-key joins on the DBLP dataset.
8.4
Many-To-One Joins (Foreign-Key Joins)
For many-to-one joins, one can first sample from the “many” side
of the relationships and will have exactly one extension on the
other side. This makes the problem a lot easier to solve, but still
poses some challenges in the weighted sampling case. To support
weighted sampling, one can obtain an upper bound for the user-
defined weights by computing the product of maximal base table
weights and then accept uniformly sampled rows with probability
equal to the ratio with the weight upper bound. As can be seen
in Table 4, this works well for linear weight functions. Here, the
economic sampler uses less memory by assuming group weights
being equal to one, which is then rectified through rejections. An-
ticipating some rejections, it collects a ten times larger sample.
However, for exponential weight functions as in Figure 11 the
approach becomes very slow as it has to repeatedly restart the
process to collect more samples. In this example using the DBLP
query, one sets the weights to be a varying exponential function
based on the year of citations. Pre-computed indices do not seem
beneficial in this case. It is therefore better to switch to the stream
sampler if the rejection rate grows too large, as it does not appear
to be affected by the weight distribution.
8.5
Cyclic joins (For Sake of Completeness)
While the main focus of this work are acyclic joins, results for cyclic
joins are shown in in Table 5. Not shown in the table is QT due to
Table 4: Runtime and memory comparison for a million
samples over foreign-key joins
baseline
proposed
index
stream
economic
WQ3 𝑆𝐹=10 memory
10.6 GB
1.6 GB
1.9 GB
WQ3 𝑆𝐹=10 query-time
0.7 mins
1.3 mins
1.4 mins
WQ3 𝑆𝐹=10 adhoc-time
1.8 mins
1.3 mins
1.4 mins
WQ3 𝑆𝐹=100 memory
94.6 GB
9.8 GB
2.6 GB
WQ3 𝑆𝐹=100 query-time
7.9 mins
12.3 mins
7.5 mins
WQ3 𝑆𝐹=100 adhoc-time
20.5 mins
12.3 mins
7.5 mins
102
103
104
105
106
10MB
100MB
1GB
10GB
100GB
sample size
memory usage (GB)
index baseline
stream
economic
Figure 12: Memory for different sample sizes over QX
(SF=100)
Table 5: Runtime and memory comparison for a million
samples over cyclic (many-to-many) joins.
baseline
proposed
index
stream
economic
WQY 𝑆𝐹=10 memory
31.8 GB
28.5 GB
11.7 GB
WQY 𝑆𝐹=10 query-time
6.1 mins
18.9 mins
15.9 mins
WQY 𝑆𝐹=10 adhoc-time
10.6 mins
18.9 mins
15.9 mins
WQY 𝑆𝐹=100 memory
290.1 GB
73.7 GB
41.6 GB
WQY 𝑆𝐹=100 query-time
55.9 mins
100.5 mins
68.4 mins
WQY 𝑆𝐹=100 adhoc-time
110.9 mins
100.5 mins
68.4 mins
reasons outlined in the following. For the cyclic QY query over the
TPC-H dataset, the economic sampler can reduce the query to an
acyclic join and thereby achieve some memory savings, but this
is not possible for the triangle query QT over the Twitter dataset.
For QT there exists an acyclic join that is not a lot larger than
the cyclic join and the proposed samplers can efficiently find it.
Still, the rejection rate is too large for anything but an index-based
sampler to complete it in a competitive amount of time. The index-
based sampler occupies for this task 454.8 GB of main memory
and needs 341.7 mins from scratch and 277.5 mins for just the
query-answering.
8.6
General (Many-To-Many) Acyclic Joins
The query QX over the TPC-H dataset used in Figure 12 does not
have many distinct values, yet the economic sampler can vastly
reduce the memory footprint if one only needs to collect a smaller
sample, using the hashed-join technique.
The intuition is that for small samples one can choose to collect a
larger set of tuples for the hashed-join technique, and then discard
the false positives.
For the query QF over the Twitter dataset (cf. Table 6), one can
also see vast memory savings for a million of sampled rows using
the economic sampler method. This is because it needs far less
memory when the number of distinct join attribute values is large.

---

Weighted Random Sampling over Joins
Table 6: Runtime and memory comparison for a million
samples over acyclic (many-to-many) joins.
baseline
proposed
index
stream
economic
WQX 𝑆𝐹=10 memory
10.7 GB
1.6 GB
2.2 GB
WQX 𝑆𝐹=10 query-time
0.7 mins
1.4 mins
1.8 mins
WQX 𝑆𝐹=10 adhoc-time
1.9 mins
1.4 mins
1.8 mins
WQX 𝑆𝐹=100 memory
95.0 GB
9.8 GB
7.2 GB
WQX 𝑆𝐹=100 query-time
7.9 mins
13.1 mins
14.0 mins
WQX 𝑆𝐹=100 adhoc-time
20.6 mins
13.1 mins
14.0 mins
QF memory
428.4 GB
91.5 GB
16.2 GB
QF query-time
63.1 mins
36.0 mins
47.0 mins
QF adhoc-time
126.5 mins
36.0 mins
47.0 mins
9
CONCLUSION
In this paper two new samplers for join queries were proposed that
offer multiple novel features such as support for user-defined sam-
pling weights and memory-efficient ad-hoc operation over stream-
accessed tables, which is very useful as most data management
systems offer some type of streaming interface to the data. First, a
stream-based sampler, which is the first join sampler that only needs
stream access and can collect a join sample by passing once over one
table and two times over the other tables. Second, an economical
sampler, which uses various strategies to exploit foreign-key joins,
simpler instances of cyclic joins and can handle high-cardinality
join attributes through a novel hashed join technique that adheres
to the targeted sampling probabilities without any approximations.
The basic idea of replacing equi-joins with equi-hash joins to re-
duce the number of considered join attribute values is not present
in the literature and offers here a crucial instrument to deal with
common cases such as join attributes that are database keys. In
the experiments it is shown that these new ideas translate to im-
proved practical performance and show that indices are only useful
cyclic joins heuristics that need to generate a very large number
of samples to find valid join rows. The open problems that remain
are cyclic joins, non-factorisable weights with a very unequal dis-
tribution of weights, non-equi joins and other more complicated
relational expressions.
ACKNOWLEDGMENTS
This work is supported by European Research Council grant ERC-
2014-CoG 647557 and The Alan Turing Institute under the EPSRC
grant EP/N510129/1.
REFERENCES
[1] Swarup Acharya, Phillip B. Gibbons, Viswanath Poosala, and Sridhar Ramaswamy.
1999. Join Synopses for Approximate Query Answering. In SIGMOD 1999, Proceed-
ings ACM SIGMOD International Conference on Management of Data, June 1-3, 1999,
Philadelphia, Pennsylvania, USA. 275–286. https://doi.org/10.1145/304182.304207
[2] Sameer Agarwal, Barzan Mozafari, Aurojit Panda, Henry Milner, Samuel Madden,
and Ion Stoica. 2013. BlinkDB: queries with bounded errors and bounded response
times on very large data. In Eighth Eurosys Conference 2013, EuroSys ’13, Prague,
Czech Republic, April 14-17, 2013. 29–42. https://doi.org/10.1145/2465351.2465355
[3] Mohammed Al-Kateb, Byung Suk Lee, and Xiaoyang Sean Wang. 2007. Reservoir
Sampling over Memory-Limited Stream Joins. In 19th International Conference
on Scientific and Statistical Database Management, SSDBM 2007, 9-11 July 2007,
Banff, Canada, Proceedings. 23. https://doi.org/10.1109/SSDBM.2007.40
[4] Taylor B Arnold and John W Emerson. 2011. Nonparametric goodness-of-fit tests
for discrete null distributions. R Journal 3, 2 (2011).
[5] Daniel A Bloch and Geoffrey S Watson. 1967. A Bayesian study of the multinomial
distribution. The Annals of Mathematical Statistics (1967), 1423–1435.
[6] Ken RW Brewer and Muhammad Hanif. 2013. Sampling with unequal probabilities.
Vol. 15. Springer Science & Business Media.
[7] Surajit Chaudhuri, Gautam Das, and Vivek Narasayya. 2007. Optimized stratified
sampling for approximate query processing. ACM Transactions on Database
Systems (TODS) 32, 2 (2007), 9–es.
[8] Surajit Chaudhuri, Rajeev Motwani, and Vivek R. Narasayya. 1999. On Random
Sampling over Joins. In SIGMOD 1999, Proceedings ACM SIGMOD International
Conference on Management of Data, June 1-3, 1999, Philadelphia, Pennsylvania,
USA. 263–274. https://doi.org/10.1145/304182.304206
[9] Yu Chen and Ke Yi. 2017. Two-Level Sampling for Join Size Estimation. In
Proceedings of the 2017 ACM International Conference on Management of Data,
SIGMOD Conference 2017, Chicago, IL, USA, May 14-19, 2017. 759–774.
https:
//doi.org/10.1145/3035918.3035921
[10] Yu Chen and Ke Yi. 2020. Random Sampling and Size Estimation Over Cyclic Joins.
In 23rd International Conference on Database Theory, ICDT 2020, March 30-April 2,
2020, Copenhagen, Denmark (LIPIcs, Vol. 155), Carsten Lutz and Jean Christoph
Jung (Eds.). Schloss Dagstuhl - Leibniz-Zentrum für Informatik, 7:1–7:18. https:
//doi.org/10.4230/LIPIcs.ICDT.2020.7
[11] C. K. Chow and C. N. Liu. 1968. Approximating discrete probability distributions
with dependence trees. IEEE Trans. Inf. Theory 14, 3 (1968), 462–467.
https:
//doi.org/10.1109/TIT.1968.1054142
[12] Noel Cressie and Timothy RC Read. 1984. Multinomial goodness-of-fit tests.
Journal of the Royal Statistical Society: Series B (Methodological) 46, 3 (1984),
440–464.
[13] Wei Dong and Ke Yi. 2021. Residual Sensitivity for Differentially Private Multi-
Way Joins. In Proceedings of the 2021 International Conference on Management of
Data. 432–444.
[14] Cynthia Dwork. 2008. Differential privacy: A survey of results. In International
conference on theory and applications of models of computation. Springer, 1–19.
[15] Cynthia Dwork, Aaron Roth, et al. 2014. The algorithmic foundations of differ-
ential privacy. Found. Trends Theor. Comput. Sci. 9, 3-4 (2014), 211–407.
[16] Pavlos S Efraimidis. 2015. Weighted random sampling over data streams. In
Algorithms, Probability, Networks, and Games. Springer, 183–195.
[17] Pavlos S. Efraimidis and Paul G. Spirakis. 2006. Weighted random sampling with
a reservoir. Inf. Process. Lett. 97, 5 (2006), 181–185. https://doi.org/10.1016/j.ipl.
2005.11.003
[18] Ted H Emigh. 1983. On the number of observed classes from a multinomial
distribution. Biometrics (1983), 485–491.
[19] Raphaël Féraud, Fabrice Clérot, and Pascal Gouzien. 2010. Sampling the join of
streams. In Classification as a Tool for Research. Springer, 307–314.
[20] Rainer Gemulla, Philipp Rösch, and Wolfgang Lehner. 2008. Linked Bernoulli
Synopses: Sampling along Foreign Keys. In Scientific and Statistical Database
Management, 20th International Conference, SSDBM 2008, Hong Kong, China, July
9-11, 2008, Proceedings. 6–23. https://doi.org/10.1007/978-3-540-69497-7_4
[21] Peter J. Haas and Joseph M. Hellerstein. 1999. Ripple Joins for Online Aggre-
gation. In SIGMOD 1999, Proceedings ACM SIGMOD International Conference on
Management of Data, June 1-3, 1999, Philadelphia, Pennsylvania, USA, Alex Delis,
Christos Faloutsos, and Shahram Ghandeharizadeh (Eds.). ACM Press, 287–298.
https://doi.org/10.1145/304182.304208
[22] Marios Hadjieleftheriou, Xiaohui Yu, Nick Koudas, and Divesh Srivastava. 2008.
Hashed samples: selectivity estimators for set similarity selection queries. Proc.
VLDB Endow. 1, 1 (2008), 201–212. https://doi.org/10.14778/1453856.1453883
[23] Benjamin Hilprecht, Andreas Schmidt, Moritz Kulessa, Alejandro Molina, Kristian
Kersting, and Carsten Binnig. 2020. DeepDB: learn from data, not from queries!
Proceedings of the VLDB Endowment 13, 7 (2020), 992–1005.
[24] Wassily Hoeffding. 1965. Asymptotically optimal tests for multinomial distribu-
tions. The Annals of Mathematical Statistics (1965), 369–401.
[25] Dawei Huang, Dong Young Yoon, Seth Pettie, and Barzan Mozafari. 2019. Join on
Samples: A Theoretical Guide for Practitioners. Proc. VLDB Endow. 13, 4 (2019),
547–560. https://doi.org/10.14778/3372716.3372726
[26] Rajesh Jayaram, Gokarna Sharma, Srikanta Tirthapura, and David P Woodruff.
2019. Weighted reservoir sampling from distributed streams. In Proceedings of the
38th ACM SIGMOD-SIGACT-SIGAI Symposium on Principles of Database Systems.
218–235.
[27] Srikanth Kandula, Anil Shanbhag, Aleksandar Vitorovic, Matthaios Olma, Robert
Grandl, Surajit Chaudhuri, and Bolin Ding. 2016. Quickr: Lazily Approximat-
ing Complex AdHoc Queries in BigData Clusters. In Proceedings of the 2016
International Conference on Management of Data. 631–646.
[28] Srikanth Kandula, Anil Shanbhag, Aleksandar Vitorovic, Matthaios Olma, Robert
Grandl, Surajit Chaudhuri, and Bolin Ding. 2016. Quickr: Lazily Approximating
Complex AdHoc Queries in BigData Clusters. In Proceedings of the 2016 Interna-
tional Conference on Management of Data, SIGMOD Conference 2016, San Francisco,

---

Shekelyan et al.
CA, USA, June 26 - July 01, 2016. 631–646. https://doi.org/10.1145/2882903.2882940
[29] Harry Kesten and Norman Morse. 1959. A property of the multinomial distribu-
tion. The Annals of Mathematical Statistics 30, 1 (1959), 120–127.
[30] Ios Kotsogiannis, Yuchao Tao, Xi He, Maryam Fanaeepour, Ashwin Machanava-
jjhala, Michael Hay, and Gerome Miklau. 2019. Privatesql: a differentially private
sql query engine. Proceedings of the VLDB Endowment 12, 11 (2019), 1371–1384.
[31] Haewoon Kwak, Changhyun Lee, Hosung Park, and Sue B. Moon. 2010. What is
Twitter, a social network or a news media?. In Proceedings of the 19th International
Conference on World Wide Web, WWW 2010, Raleigh, North Carolina, USA, April
26-30, 2010, Michael Rappa, Paul Jones, Juliana Freire, and Soumen Chakrabarti
(Eds.). ACM, 591–600. https://doi.org/10.1145/1772690.1772751
[32] Viktor Leis, Bernhard Radke, Andrey Gubichev, Alfons Kemper, and Thomas
Neumann. 2017. Cardinality Estimation Done Right: Index-Based Join Sam-
pling. In CIDR 2017, 8th Biennial Conference on Innovative Data Systems Research,
Chaminade, CA, USA, January 8-11, 2017, Online Proceedings. www.cidrdb.org.
http://cidrdb.org/cidr2017/papers/p9-leis-cidr17.pdf
[33] Feifei Li, Bin Wu, Ke Yi, and Zhuoyue Zhao. 2016. Wander Join: Online Aggrega-
tion via Random Walks. In Proceedings of the 2016 International Conference on
Management of Data, SIGMOD Conference 2016, San Francisco, CA, USA, June 26
- July 01, 2016, Fatma Özcan, Georgia Koutrika, and Sam Madden (Eds.). ACM,
615–629. https://doi.org/10.1145/2882903.2915235
[34] Qingzhi Ma, A.M. Shanghooshabad, Mehrdad Almasi, Meghdad Kurmanji, and
Peter Triantafillou. 2021. Dbest++: Learned Approximate Query Processing: Make
it Light, Accurate and Fast. In Proceedings of the 2021 Conference on Innovative
Data Research. 1553–1570.
[35] Ashwin Machanavajjhala, Daniel Kifer, John Abowd, Johannes Gehrke, and Lars
Vilhuber. 2008. Privacy: Theory meets practice on the map. In 2008 IEEE 24th
international conference on data engineering. IEEE, 277–286.
[36] Frank McSherry and Kunal Talwar. 2007. Mechanism design via differential
privacy. In 48th Annual IEEE Symposium on Foundations of Computer Science
(FOCS’07). IEEE, 94–103.
[37] Arjun Narayan and Andreas Haeberlen. 2012. DJoin: Differentially private join
queries over distributed databases. In 10th {USENIX} Symposium on Operating
Systems Design and Implementation ({OSDI} 12). 149–162.
[38] Frank Olken. 1993. Random sampling from databases. Ph. D. Dissertation. Uni-
versity of California, Berkeley.
[39] Frank Olken and Doron Rotem. 1995. Random sampling from databases: a survey.
Statistics and Computing 5, 1 (1995), 25–42.
[40] Yongjoo Park, Barzan Mozafari, Joseph Sorenson, and Junhao Wang. 2018. Ver-
dictdb: Universalizing approximate query processing. In Proceedings of the 2018
International Conference on Management of Data. 1461–1476.
[41] Yongjoo Park, Barzan Mozafari, Joseph Sorenson, and Junhao Wang. 2018. Ver-
dictDB: Universalizing Approximate Query Processing. In Proceedings of the
2018 International Conference on Management of Data, SIGMOD Conference 2018,
Houston, TX, USA, June 10-15, 2018. 1461–1476. https://doi.org/10.1145/3183713.
3196905
[42] Anthony N Pettitt and Michael A Stephens. 1977. The Kolmogorov-Smirnov
goodness-of-fit statistic with discrete and grouped data. Technometrics 19, 2
(1977), 205–210.
[43] Jiadong Ren, Wanchang Jiang, and Cong Huo. 2007. Random sampling over
streaming window joins. In The First International Symposium on Data, Privacy,
and E-Commerce (ISDPE 2007). IEEE, 53–55.
[44] Bengt Rosén. 1997. On sampling with probability proportional to size. Journal of
statistical planning and inference 62, 2 (1997), 159–191.
[45] M Ruiz, FJ Girón, CJ Pérez, J Martín, and C Rojano. 2008. A Bayesian model for
multinomial sampling with misclassified data. Journal of Applied Statistics 35, 4
(2008), 369–382.
[46] MR Sampford. 1967. On sampling without replacement with unequal probabilities
of selection. Biometrika 54, 3-4 (1967), 499–513.
[47] Ali Mohammadi Shanghooshabad, Meghdad Kurmanji, Qingzhi Ma, Michael
Shekelyan, Mehrdad Almasi, and Peter Triantafillou. 2021. PGMJoins: Random
Join Sampling with Graphical Models. In Proceedings of the 2021 International
Conference on Management of Data. 1610–1622.
[48] Lefteris Sidirourgos, Martin Kersten, and Peter Boncz. 2013. Scientific discovery
through weighted sampling. In 2013 IEEE International Conference on Big Data.
IEEE, 300–306.
[49] Nikolai V Smirnov. 1939. On the estimation of the discrepancy between empirical
curves of distribution for two independent samples. Bull. Math. Univ. Moscou 2,
2 (1939), 3–14.
[50] Utkarsh Srivastava and Jennifer Widom. 2004. Memory-limited execution of
windowed stream joins. In VLDB, Vol. 4. 324–335.
[51] Michał Startek. 2016. An asymptotically optimal, online algorithm for weighted
random sampling with replacement. arXiv preprint arXiv:1611.00532 (2016).
[52] Jie Tang, Jing Zhang, Limin Yao, Juanzi Li, Li Zhang, and Zhong Su. 2008. Arnet-
Miner: extraction and mining of academic social networks. In Proceedings of the
14th ACM SIGKDD International Conference on Knowledge Discovery and Data
Mining, Las Vegas, Nevada, USA, August 24-27, 2008, Ying Li, Bing Liu, and Sunita
Sarawagi (Eds.). ACM, 990–998. https://doi.org/10.1145/1401890.1402008
[53] Yves Tillé. 2019. A general result for selecting balanced unequal probability
samples from a stream. Inform. Process. Lett. 152 (2019), 105840.
[54] Daniel Ting and Eric Brochu. 2018. Optimal subsampling with influence functions.
In Advances in neural information processing systems. 3650–3659.
[55] John Von Neumann. 1951. 13. various techniques used in connection with random
digits. Appl. Math Ser 12, 36-38 (1951), 5.
[56] HaiYing Wang. 2019. More efficient estimation for logistic regression with
optimal subsamples. Journal of machine learning research 20 (2019).
[57] Haiying Wang and Yanyuan Ma. 2021. Optimal subsampling for quantile regres-
sion in big data. Biometrika 108, 1 (2021), 99–112.
[58] HaiYing Wang and Jiahui Zou. 2021. A comparative study on sampling with
replacement vs Poisson sampling in optimal subsampling. In International Con-
ference on Artificial Intelligence and Statistics. PMLR, 289–297.
[59] Junyi Xie and Jun Yang. 2007. A Survey of Join Processing in Data Streams. In
Data Streams - Models and Algorithms. 209–236. https://doi.org/10.1007/978-0-
387-47534-9_10
[60] Mihalis Yannakakis. 1981. Algorithms for Acyclic Database Schemes. In Very
Large Data Bases, 7th International Conference, September 9-11, 1981, Cannes,
France, Proceedings. IEEE Computer Society, 82–94.
[61] Yaqiong Yao and HaiYing Wang. 2019. Optimal subsampling for softmax regres-
sion. Statistical Papers 60, 2 (2019), 585–599.
[62] Zhuoyue Zhao, Robert Christensen, Feifei Li, Xiao Hu, and Ke Yi. 2018. Random
Sampling over Joins Revisited. In Proceedings of the 2018 International Conference
on Management of Data, SIGMOD Conference 2018, Houston, TX, USA, June 10-15,
2018. 1525–1539. https://doi.org/10.1145/3183713.3183739
[63] Zhuoyue Zhao, Feifei Li, and Yuxi Liu. 2020. Efficient Join Synopsis Mainte-
nance for Data Warehouse. In Proceedings of the 2020 International Conference
on Management of Data, SIGMOD Conference 2020, online conference [Portland,
OR, USA], June 14-19, 2020, David Maier, Rachel Pottinger, AnHai Doan, Wang-
Chiew Tan, Abdussalam Alawini, and Hung Q. Ngo (Eds.). ACM, 2027–2042.
https://doi.org/10.1145/3318464.3389717

---

