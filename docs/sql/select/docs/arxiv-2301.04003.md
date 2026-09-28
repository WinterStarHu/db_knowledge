# Change Propagation Without Joins

> 来源: https://arxiv.org/pdf/2301.04003

Change Propagation Without Joins
Qichen Wang
Hong Kong Baptist University
qcwang@hkbu.edu.hk
Xiao Hu
University of Waterloo
xiaohu@uwaterloo.ca
Binyang Dai, Ke Yi
HKUST
{bdaiab,yike}@ust.hk
ABSTRACT
We revisit the classical change propagation framework for query
evaluation under updates. The standard framework takes a query
plan and materializes the intermediate views, which incurs high
polynomial costs in both space and time, with the join operator be-
ing the culprit. In this paper, we propose a new change propagation
framework without joins, thus naturally avoiding this polynomial
blowup. Meanwhile, we show that the new framework still supports
constant-delay enumeration of both the deltas and the full query
results, the same as in the standard framework. Furthermore, we
provide a quantitative analysis of its update cost, which not only
recovers many recent theoretical results on the problem, but also
yields an effective approach to optimizing the query plan. The new
framework is also easy to be integrated into an existing stream-
ing database system. Experimental results show that our system
prototype, implemented using Flink DataStream API, significantly
outperforms other systems in terms of space, time, and latency.
1
INTRODUCTION
We study the problem of query evaluation under updates, a.k.a.
incremental view maintenance. Given a query 𝑄, a database 𝐷, and
a sequence of updates, where each update is either the insertion or
deletion of a tuple, the goal is to maintain the query results 𝑄p𝐷q
continuously. More precisely, there are two modes to return the
updated𝑄p𝐷q to the user (an end user or an upper-level application):
full enumeration and delta enumeration. The former is pull-based,
i.e., the system returns 𝑄p𝐷q passively upon request of the user;
while in the latter case, we push the delta Δ𝑄p𝐷,𝑡q, i.e., the change
to 𝑄p𝐷q caused by the insertion/deletion of 𝑡, to the user after each
update 𝑡. These two modes are applicable to different scenarios.
Full enumeration cannot be done too frequently if 𝑄p𝐷q is large,
and it may miss some ephemeral events in between two requests.
Delta enumeration offers real-time responses with low latency, but
it requires the user to have the ability to “consume” the deltas in
a timely fashion. It can be considered as a stream-in-stream-out
operator, where the input is a stream of updates to the base tables,
while the output is a stream of updates to the query result (i.e.,
a stream of deltas). If the user wishes to always have a complete
and accurate 𝑄p𝐷q, it has to maintain 𝑄p𝐷q and update it with the
deltas as they are received. If approximation is acceptable, some
more efficient streaming algorithms can be used instead.
Change propagation. Change propagation [12, 27, 34] is a widely
used framework in database systems for solving this problem. It
can be instantiated with any query plan, which is a tree where the
leaves are the base relations and each internal node is a relational
operator. At each internal node, it maintains the results of the sub-
query corresponding to the subtree at this internal node, which
is often called a materialized view. Figure 1(a) shows a particular
𝑉4 “ 𝑉2 1 𝑉3
𝑉1 “ 𝑅2 1 𝑅3
𝑉3 “ 𝜋𝑥4𝑅4
𝑅4
𝑉2 “ 𝑅1 1 𝑉1
𝑅2
𝑅3
𝑅1
(a) Old plan
𝑉2 “ 𝑅1 1 𝑅2 1 𝑅3 1 𝑉1
𝑅1
𝑅2
𝑅3
𝑉1 “ 𝜋𝑥4𝑅4
(b) Another old plan
X : 𝑉𝑠pr𝑥3sq
𝜋: 𝑉𝑝p𝑅2q
𝜋: 𝑉𝑝p𝑅3q
˙ : 𝑉𝑠p𝑅2q
˙ : 𝑉𝑠p𝑅3q “ 𝑅3 ˙ 𝑉𝑝p𝑅4q
𝜋: 𝑉𝑝p𝑅1q
𝑅2
𝑅3
𝜋: 𝑉𝑝p𝑅4q
𝑉𝑠p𝑅1q “ 𝑅1
𝑉𝑠p𝑅4q “ 𝑅4
𝑅1
𝑅2
𝑅3
𝑅4
r𝑥3s
(c) Our new plan
Figure 1: For 𝑄“ 𝜋𝑥1,𝑥2,𝑥3,𝑥4𝑅1p𝑥1,𝑥2q 1 𝑅2p𝑥2,𝑥3q 1 𝑅3p𝑥3,𝑥4q
1 𝑅4p𝑥4,𝑥5q, 1(a) and 1(b) are two plans under the standard
change propagation framework and 1(c) is our new plan.
query plan for the query 4-Hop query from benchmark [30]
𝑄:“ 𝜋𝑥1,𝑥2,𝑥3,𝑥4𝑅1p𝑥1,𝑥2q 1 𝑅2p𝑥2,𝑥3q 1 𝑅3p𝑥3,𝑥4q 1 𝑅4p𝑥4,𝑥5q.
Under the standard change propagation framework, we maintain
four materialized views𝑉1,𝑉2,𝑉3,𝑉4 “ 𝑄(if only delta enumeration
is needed, then 𝑉4 need not be maintained). When a tuple 𝑡is
inserted or deleted in a relation, say 𝑅1, it follows the leaf-to-root
path to propagate the deltas to the root. More precisely, it first
computes Δ𝑉2 “ Δ𝑅1 1 𝑉1 “ 𝑡1 𝑉1, then computes Δ𝑄“ Δ𝑉4 “
Δ𝑉2 1 𝑉3. Note that with the help of the materialized views, it
avoids re-computing some of the sub-queries during updates.
However, the penalty is space: both𝑉1 and𝑉2 can have quadratic
size in the worst case [4]. To avoid space blowup, one can use a
different query plan, say, the one shown in Figure 1(b). This query
plan does not have any materialized views (except 𝑉1 “ 𝜋𝑥4𝑅4,
which has at most linear size), but it has to compute a multi-way
join, e.g., 𝑅1 1 𝑅2 1 𝑅3 1 𝑡upon each update in 𝑅4, which could
take quadratic time. Making things worse, this quadratic blowup
exacerbates for queries involving more relations [4].
Prior work has designed advanced techniques to address this
space or time blowup. The Dynamic Yannakakis algorithm [20–22]
has linear space and linear update time while supporting constant-
delay enumeration for free-connex queries1; the update time fur-
ther reduces to 𝑂p1q amortized2 for q-hierarchical queries. Concur-
rently, Berkholz et al. [8] designed a different algorithm for the
q-hierarchical case with the same space/time guarantees. However,
these algorithms have not been integrated into any full-fledged
database or data warehouse products, possibly due to the complica-
tions of the techniques and the use of non-standard operations not
routinely found in existing database systems.
1All technical terms in the introduction are formally defined in Section 3.
2All update time bounds are amortized in this paper.
arXiv:2301.04003v2  [cs.DB]  2 Dec 2023

---

Change propagation without joins. The main contribution of
this paper is to achieve (and improve for certain classes of queries
and/or update sequences) the results above, but still under the
standard change propagation framework. Our observation is that
the only relational operator that may cause a super-linear blowup
is join. Thus, if the query plan has no joins, then both space and
update time will be at most linear. To avoid joins, our high-level
strategy is to replace each join in the query plan by a semi-join
(or an intersection) plus a projection. However, not every query
plan is amenable to this replacement strategy. The key technical
contribution of this paper, therefore, is the construction of such a
query plan for every free-connex conjunctive query. For example,
such a join-free query plan for the earlier query is shown in Figure
1(c), which will be elaborated in Section 4.
Since our query plan has no joins, linear space and linear up-
date time follow straightforwardly. Still, two technical challenges
remain: (1) how to support constant-delay enumeration, and (2)
how to achieve an update time better than linear. (1) is trivial under
a traditional query plan where the root corresponds to the query
results 𝑄p𝐷q. Since our query plan is join-free, no node in the plan
corresponds to 𝑄p𝐷q. Instead, our query plan can be considered
as a compact, linear-size representation of a polynomially sized
𝑄p𝐷q. By borrowing ideas from the static case [5], we show how to
enumerate 𝑄p𝐷q with constant delay, by appropriately traversing
this compact representation. Supporting constant-delay enumera-
tion of the delta Δ𝑄p𝐷,𝑡q, on the other hand, is quite different from
the static case, and we need new techniques which exploit some
important properties of our query plan.
To address issue (2), Wang and Yi [36] introduced the notion of
enclosureness 𝜆of an update sequence, which captures the hardness
of the update sequence. It is linear in the worst case, but is often a
constant in many common cases, such as any first-in-first-out (FIFO)
update sequence. They also designed an algorithm with update cost
𝑂p𝜆q for foreign-key acyclic queries. Such queries are relatively easy
to handle since their result size is at most linear, so they are immune
to the polynomial blowup problem caused by non-key joins, such
as free-connex queries. Indeed, we show (c.f. Theorem 6.2) that
there is a simple free-connex query for which it is impossible to
achieve 𝑂p|𝐷|1{2´𝜀q update time even over FIFO update sequences,
which implies that the previous definition of 𝜆is not achievable
for free-connex queries. Nevertheless, we show that, after a simple
relaxation of the definition, 𝜆is still an appropriate measure of the
update complexity; in particular, we show that change propagation
under our query plan achieves 𝑂p𝜆q update time for every free-
connex query under the new definition. To further illustrate the
usefulness of our new definition of 𝜆, we show that for certain
queries (such as q-hierarchical queries) and/or update sequences
(such as FIFO or insertion-only), 𝜆is indeed a small constant. For
general queries, 𝜆also provides guidance on what would constitute
a good query plan for change propagation.
Our results. Specifically, this paper achieves the following results:
(1) We show how to construct a change propagation query plan
without joins for any free-connex conjunctive query, such that
the space needed by the query plan is linear and the update time
is 𝑂p𝜆q, for an appropriately defined notion of enclosureness 𝜆
of the update sequence.
(2) We show how to support constant-delay enumeration of both
full query results and each delta in our query plan.
(3) We show that 𝜆is a constant for certain classes of conjunctive
queries (such as q-hierarchical queries) and/or special update
sequences (such as FIFO or insertion-only). These results not
only recover the prior known result of [8, 20] on q-hierarchical
queries, but also extend it to cover many other cases commonly
encountered in practice.
(4) We show how our framework can handle various extensions
such as selections, aggregations, and non-free-connex queries.
(5) We demonstrate the practicality of our new framework by imple-
menting it on top of Flink and comparing it with state-of-the-art
view maintenance and SQL-over-stream systems.
2
RELATED WORK
Our new change propagation framework is inspired by several lines
of research. In the static case, the classical Yannakakis algorithm
[37] has runtime 𝑂p|𝐷| ` |𝑄p𝐷q|q for every free-connex query. It
consists of two stages. The first stage uses a series of semi-joins
to remove all the dangling tuples in 𝑂p|𝐷|q time, and the second
stage performs pairwise joins to compute 𝑄p𝐷q in 𝑂p|𝑄p𝐷q|q time.
The Dynamic Yannakakis algorithm [20] extends the algorithm
to the dynamic case, but it deviates from the change propagation
framework, making it harder to integrate into existing database
systems. Our algorithm can also be viewed as a dynamic version
of the Yannakakis algorithm, but it strictly follows the standard
change propagation framework while achieving a better runtime.
The Dynamic Yannakakis algorithm has an update cost of 𝑂p|𝐷|q
for free-connex queries, while our algorithm achieves 𝑂p𝜆q up-
date time, where 𝜆is the enclosureness of the update sequence. We
have 𝜆ď |𝐷| for all update sequences, while the former is usually
much smaller on real-world update sequences. Furthermore, Dy-
namic Yannakakis achieves𝑂p1q update time only for q-hierarchical
queries, while our algorithm also achieves 𝑂p1q update time for
non-q-hierarchical queries if the update sequences enjoy some spe-
cial properties, such as first-in-first-out or insertion-only (formally
defined in Section 6.1). The gap between Dynamic Yannakakis and
our algorithm can be as large as Θp|𝐷|q on some non-q-hierarchical
queries (see Example 6.12).
Bagan et al. [5] observe that, in the static case, the second stage
of the Yannakakis algorithm can be enhanced to support constant-
delay enumeration. We adapt their ideas to support enumeration
in the dynamic case for our query plan. However, as there is no
notion of delta in the static case, we need some new ideas to support
delta enumeration with constant delay, which non-trivially relies
on some nice features of our query plan.
Kara et al. [26] show that it is possible to increase the enumera-
tion delay in exchange for faster update time, on hierarchical (but
non-q-hierarchical) queries. We have not considered this trade-off,
as we believe the constant delay is important, and our update cost
𝜆is low enough for most queries and update sequences already.
Furthermore, their trade-off only applies to full enumeration, not
delta enumeration. Nevertheless, for cases where 𝜆is high, it would
be an interesting direction to explore such a trade-off.
In the standard change propagation framework, a single update
to a base relation may incur many changes in the intermediate
2

---

views. Higher-Order Incremental View Maintenance (HIVM) [3]
has been proposed to remedy this problem. It takes the changes to a
view as another query (delta query) and maintains this delta query
recursively. HIVM improves upon IVM for many complex queries
in practice, and it can also extend to accelerate several machine
learning tasks [32, 33], but there is no theoretical guarantee on its
update time. Furthermore, HIVM still uses super-linear space.
The problem is also related to stream joins. In particular, a cash-
register stream corresponds to an insertion-only update sequence,
while a turnstile stream is an update sequence with arbitrary inser-
tions and deletions. The sliding-window stream model is a special
case of a FIFO update sequence. Most stream processing systems
like Flink [9] and Trill [11] use standard change propagation for
multi-way stream joins, which we will compare against in Section
8. Some specialized systems are designed for two-way stream joins
[13, 16, 24, 29, 35], but they do not extend to multi-way joins.
3
PRELIMINARIES
3.1
Problem Definition
Conjunctive queries. We focus on conjunctive queries (CQ) of the
following form:
𝑄:“ 𝜋y p𝑅1p𝑒1q 1 𝑅2p𝑒2q 1 ¨ ¨ ¨ 1 𝑅𝑛p𝑒𝑛qq,
(1)
where each 𝑅𝑖is a relation with a set of attributes/variables 𝑒𝑖,
𝑖“ 1, . . . ,𝑛. Each tuple 𝑡P 𝑅𝑖assigns a value to each attribute in
𝑒𝑖. For any 𝑥P 𝑒𝑖, 𝑡r𝑥s “ 𝜋𝑥𝑡denotes the value of 𝑡on attribute 𝑥.
Similarly, for a subset of attributes 𝑒Ď 𝑒𝑖, 𝑡r𝑒s “ 𝜋𝑒𝑡denotes the
tuple formed by the values of 𝑡on the attributes in 𝑒.
Let V “ 𝑒1 Y ¨ ¨ ¨ Y 𝑒𝑛be the set of all attributes in the query.
We call y Ď V the output attributes, while ¯y “ V ´ y are the non-
output attributes, also known as the existential variables. If y “ V,
such a query is known as a full join query; otherwise, it is said to
be join-project query. For simplicity, we assume that each 𝑅𝑖in 𝑄
is distinct, i.e., the query does not have self-joins. Nevertheless,
self-joins can be taken care of easily: Suppose a relation 𝑅appears
twice in the query (with different attribute renamings). Then we
consider them as two identical copies of 𝑅, and for any update to 𝑅,
we apply the update to both copies of 𝑅.
Given a database 𝐷, we write 𝑄p𝐷q for the query results of 𝑄
on 𝐷. We use 𝑄p𝐷˙ 𝑡q to denote the query results that depend on
a given tuple 𝑡, and call 𝑄p𝐷˙ 𝑡q the query results witnessed by 𝑡.
Such a witness query will be frequently used in this paper. Given a
query 𝑄in the form of (1) and a tuple 𝑡P 𝑅𝑖, it is clear that
𝑄p𝐷˙ 𝑡q “ 𝜋y p𝑅1 1 ¨ ¨ ¨ 1 𝑅𝑖´1 1 t𝑡u 1 𝑅𝑖`1 1 ¨ ¨ ¨ 1 𝑅𝑛q .
Note that for a full join CQ, we have 𝑄p𝐷˙ 𝑡q “ 𝑄p𝐷` 𝑡q ˙ 𝑡; for
join-project queries, 𝑡itself may not appear in 𝑄p𝐷˙ 𝑡q due to the
projection on y. When analyzing the costs of algorithms, we adopt
the notion of data complexity, i.e., the size of the query 𝑄is taken
as a constant while |𝐷| is an asymptotic parameter.
Semi-joins. The semi-join 𝑅𝑖p𝑥𝑖q ˙ 𝑅𝑗p𝑥𝑗q is defined as
𝑅𝑖p𝑥𝑖q ˙ 𝑅𝑗p𝑥𝑗q “ t𝑡|𝑡P 𝜋𝑥𝑖𝑅𝑖1 𝑅𝑗u.
Updates and Deltas. An update to a database 𝐷is either the
insertion or deletion of a tuple 𝑡in some relation 𝑅𝑖of 𝐷. In this
paper, we adopt set semantics. We denote 𝐷`𝑡as the database after
inserting 𝑡and 𝐷´ 𝑡as the database after deleting 𝑡. In particular,
this means that if 𝑅𝑖already contains 𝑡, then inserting 𝑡into 𝑅𝑖will
not change 𝑅𝑖; if 𝑅𝑖does not contain 𝑡, deleting 𝑡from 𝑅𝑖has no
effect, either. We ignore these non-effective updates.
The delta of an update to 𝑄is defined as
Δ𝑄p𝐷,𝑡q “ 𝑄p𝐷` 𝑡q ´ 𝑄p𝐷q
in case of the insertion of 𝑡and
Δ𝑄p𝐷,𝑡q “ 𝑄p𝐷q ´ 𝑄p𝐷´ 𝑡q
in the case of deletion. For a full join query, Δ𝑄p𝐷,𝑡q “ 𝑄p𝐷˙ 𝑡q.
For join-project queries, Δ𝑄p𝐷,𝑡q Ď 𝑄p𝐷˙ 𝑡q. In particular, it is
possible to have Δ𝑄p𝐷,𝑡q “ H even if 𝑄p𝐷˙ 𝑡q ‰ H.
We target constant delay [5] for both full and delta enumeration,
i.e., the time between the start of the enumeration process to the first
tuple in 𝑄p𝐷q (or Δ𝑄p𝐷,𝑡q), the time between any consecutive pair
of tuples, and the time between the last tuple and the termination
of the enumeration process should all be bounded by a constant.
3.2
Classification of CQs
Acyclic CQs. There are several equivalent definitions of acyclic
queries [7, 15], and here we adopt one based on generalized join
tree [20]. A generalized relation 𝑅𝑒is defined on a subset of attributes
𝑒Ď V and is distinguished from the original relations.
Definition 3.1 (Acyclic queries). A CQ 𝑄“ pV, E, yq is acyclic
if there exists a tree T in which each node corresponds to a dis-
tinct input relation or a generalized relation, while satisfying the
following properties:
‚ (cover property) each input relation in E corresponds to a
distinct node in T; moreover, each leaf node of T corresponds
to an input relation in E;
‚ (connect property) for each attribute 𝑥P V, all nodes of T
containing 𝑥form a connected component of T;
T is called a generalized join tree for Q. If all nodes in T cor-
respond to relations in E, T is called a traditional join tree. An
example is given in Figure 2(c). In T, we use 𝑟to denote the root,
and T𝑒for the subtree rooted at node 𝑒, C𝑒for the set of children
of node 𝑒and 𝑝𝑒for the parent of node 𝑒. If 𝑒is a leaf, C𝑒“ H; for
the root 𝑟, 𝑝𝑟“ H. Let keyp𝑒q “ 𝑒X 𝑝𝑒be the join key between
node 𝑒and 𝑝𝑒.
Free-connex CQs. A CQ 𝑄“ pV, E, yq is free-connex if 𝑄and
pV, t𝑒1, . . . ,𝑒𝑛, yu, yq are both acyclic [5]. By definition, any free-
connex query must be acyclic, and an acyclic full join query must be
free-connex. For our development, we need an equivalent definition
based on free-connex tree (the equivalence is proved in Appendix A):
Definition 3.2 (Free-connex CQs). A CQ 𝑄“ pV, E, yq is free-
connex if there exists a tree T in which each node corresponds to
a distinct input relation or a generalized relation, while satisfying
the following properties:
‚ (cover property) each input relation in E corresponds to a
distinct node in T; moreover, each leaf node of T corresponds
to an input relation in E;
‚ (connect property) for each attribute 𝑥, all nodes of T contain-
ing 𝑥form a connected component of T;
3

---

𝑅2p𝑥2,𝑥3q
𝑅1p𝑥1,𝑥2q
r𝑥2s
(a) T1
𝑅1p𝑥1,𝑥2q
𝑅2p𝑥2,𝑥3q
r𝑥2s
(b) T2
𝑅2p𝑥2,𝑥3q
𝑅1p𝑥1,𝑥2q
r𝑥2s
(c) T3
Figure 2: Three free-connex join trees for 𝑄1 “ 𝑅1p𝑥1,𝑥2q 1
𝑅2p𝑥2,𝑥3q. In 2(c), node r𝑥2s is a generalized relation with one
attribute 𝑥2. The height of T1, T2 is 2 and that of T3 is 1.
‚ (guard property) if node 𝑒corresponds to a generalized relation,
𝑒Ď 𝑒1 holds for every child node 𝑒1 of 𝑒;
‚ (above property) any node corresponding to a generalized rela-
tion appears above any node corresponding to an input relation;
‚ (connex property) there exists a connected subtree Econ of
T such that (i) Econ contains the root of T; (ii) for any node
𝑒P Econ, keyp𝑒q Ď y; (iii) y Ď Ť
𝑒PEcon 𝑒.
T is called a free-connex join tree of Q, and Econ is called the
connex subtree. The height of T is defined as the maximum number
of relations on any leaf-to-root path, without counting generalized
relations. For example, for 𝑄1
1 :“ 𝜋𝑥2𝑅1p𝑥1,𝑥2q 1 𝑅2p𝑥2,𝑥3q, all
three free-connex join trees in Figure 2 are valid free-connex join
trees, with the connex substree tr𝑥2su.
Q-hierarchical CQs [8]. A CQ 𝑄is q-hierarchical if (1) for every
pair of attributes 𝑥1,𝑥2, either E𝑥1 Ď E𝑥2 or E𝑥2 Ď E𝑥1 or E𝑥1 X
E𝑥2 “ H; and (2) for every pair of attributes 𝑥1,𝑥2, if 𝑥1 P y and
E𝑥1 Ĺ E𝑥2, then 𝑥2 P y, where E𝑥denote the set of relations
containing attribute 𝑥. Interesting, a CQ is q-hierarchical if and
only if there is a height-1 free-connex join tree (see Appendix A).
Firstly, a full join query can be evaluated in linear time in terms of
input and output size if and only if it is acyclic; for join-project CQs,
this complete class extends to free-connex queries. Furthermore,
free-connex and q-hierarchical CQs have played important roles
in query enumeration. [5] showed that in static settings, constant-
delay enumeration after a linear-time preprocessing step is possible
for a CQ if and only if it is free-connex. Berkholz et al. [8] showed
that in dynamic settings, constant-delay enumeration is possible
for a CQ from a data structure that can be updated in constant time
if and only if it is q-hierarchical.
4
CHANGE PROPAGATION WITHOUT JOINS
4.1
A New Query Plan
Given a free-connex query 𝑄, our new query plan is guided by a
free-connex join tree T of 𝑄. We illustrate the construction using
the query in Figure 1 with the join tree highlighted in red (note that
the join tree is not unique). A normal query plan following this join
tree would compute a series of joins p𝑅1 1 𝑅2q 1 p𝑅3 1 𝜋𝑥4𝑅4q. In
our new query plan, we replace each join with a semi-join followed
by a projection. More precisely, we maintain two views for each
node 𝑒P T, a semi-join view 𝑉𝑠p𝑅𝑒q and a projection view 𝑉𝑝p𝑅𝑒q,
defined recursively as follows.
Algorithm 1: PlanGenerationp𝑄,𝑇q
Input
:A free-connex join tree 𝑇for query 𝑄;
Output:A new query plan 𝑇for 𝑄;
1 foreach node 𝑒in a postorder traversal of 𝑇do
2
Replace node 𝑒with 𝑉𝑠p𝑅𝑒q in 𝑇;
3
if 𝑒is not the root of 𝑇then
4
Add 𝑉𝑝p𝑅𝑒q between 𝑉𝑠p𝑅𝑒q and the parent of 𝑒;
5 Return 𝑇;
Every non-root node 𝑒P T has a projection view
𝑉𝑝p𝑅𝑒q :“ 𝜋keyp𝑒q𝑉𝑠p𝑅𝑒q.
(2)
Noted that the root node does not have a projection view.
To define the semi-join view 𝑉𝑠p𝑅𝑒q, we distinguish three cases.
(i) If 𝑒is a leaf, 𝑅𝑒is an input relation, and 𝑉𝑠p𝑅𝑒q :“ 𝑅p𝑒q.
(ii) If 𝑒is an internal node and 𝑅𝑒is an input relation, then
𝑉𝑠p𝑅𝑒q :“ 𝑅𝑒˙ 𝑉𝑝p𝑅𝑒1q ˙ ¨ ¨ ¨ ˙ 𝑉𝑝p𝑅𝑒𝑘q,
(3)
where C𝑒“ t𝑒1,𝑒2, . . . ,𝑒𝑘u are the children of 𝑒.
(iii) If𝑒is an internal node that corresponds to a generalized relation
𝑅𝑒, since all the 𝑉𝑝p𝑅𝑒𝑖q’s have the same attributes keyp𝑒𝑖q “
𝑒𝑖X𝑒“ 𝑒for every 𝑖P r𝑘s (by the guard property in Definition
3.1), (3) simplifies to an intersection:
𝑉𝑠p𝑅𝑒q :“ 𝑉𝑝p𝑅𝑒1q X ¨ ¨ ¨ X 𝑉𝑝p𝑅𝑒𝑘q.
(4)
Our query plan simply connects these views together using the
formulae above. Algorithm 1 takes as input a free-connex join tree,
and outputs a new query plan under our framework. Figure 1(c)
shows the new query plan for the example query. Note that 𝑅2 and
𝑅4 fall into case (ii), while the root node r𝑥3s is under case (iii).
As neither projection nor semi-join (including intersection as a
special case) enlarges the input relations, the following is straight-
forward:
Lemma 4.1. All views in our query plan have size 𝑂p|𝐷|q.
Example 4.2. Figure 3(a) shows the initial index built for the
query in Figure 1. For𝑅1 and𝑅4, both semi-join and projection views
are defined as themselves. 𝑉𝑠p𝑅2q contains tuples in 𝑅2 that can
join with 𝑉𝑝p𝑅1q, which include p2, 2q and p2, 4q. 𝑉𝑠p𝑅3q is defined
similarly including 4 tuples from 𝑅3. For the generalized node r𝑥3s,
we define the generalized relation 𝑅pr𝑥3sq “ 𝑉𝑝p𝑅2qY𝑉𝑝p𝑅3q. Only
tuple p4q belongs to 𝑅pr𝑥3sq, since every other tuple in 𝑅pr𝑥3sq fails
to join with 𝑉𝑝p𝑅2q and 𝑉𝑝p𝑅3q: their counters need to be 2.
4.2
Change propagation
Change propagation using our new query plan can be done using
standard (actually, even simpler for certain operators) propagation
formulae [12]. For completeness, we briefly describe them below,
which are also needed to understand the algorithms in Section 5.
S-Update When there is an update to 𝑉𝑠p𝑅𝑒q for some 𝑒, we use
an S-Update to update 𝑉𝑝p𝑅𝑒q by formula (2). This can be done
in 𝑂p1q time by derivation counting [12], a standard technique to
propagate changes through a projection. Specifically, we associate a
counter countr𝑡1s for each tuple 𝑡1 P 𝑉𝑝p𝑅𝑒q that stores the number
of tuples 𝑡P 𝑉𝑠p𝑅𝑒q such that 𝑡rkeyp𝑒qs “ 𝑡1. The detailed process,
4

---

Algorithm 2: S-Updatep𝑒,𝑡q
Input
:An update 𝑡from 𝑉𝑠p𝑅𝑒q;
Output:Updated 𝑉𝑝p𝑅𝑒q;
1 𝑡1 Ð 𝑡rkeyp𝑒qs;
2 if 𝑡is an insertion into 𝑉𝑠p𝑅𝑒q then
3
if 𝑡1 P 𝑉𝑝p𝑅𝑒q then countr𝑡1s Ð countr𝑡1s ` 1;
4
else
5
𝑉𝑝p𝑅𝑒q Ð 𝑉𝑝p𝑅𝑒q Y t𝑡1u, countr𝑡1s Ð 1,
P-Update(𝑝𝑒,𝑡1);
6 else
7
if countr𝑡1s “ 1 then
8
𝑉𝑝p𝑅𝑒q Ð 𝑉𝑝p𝑅𝑒q ´ t𝑡1u, P-Update(𝑝𝑒,𝑡1);
9
else countr𝑡1s Ð countr𝑡1s ´ 1;
which needs to distinguish between an insertion and a deletion, is
given in Algorithm 2. Note that for the algorithm to run in 𝑂p1q
time, we need a hash index on 𝑉𝑝p𝑅𝑒q.
P-Update Let 𝑒𝑖be a child of 𝑒. When there is an update to some
𝑉𝑝p𝑅𝑒𝑖q, we use a P-Update to update 𝑉𝑠p𝑅𝑒q by formula (3) in the
case where 𝑒is an input relation or (4) in case 𝑒is a generalized
relation. We consider the former case first; the latter case is similar.
The standard change propagation formula for a semi-join [18]
rewrites it as a join followed by a projection, e.g., 𝑅𝑒˙ 𝑅𝑒𝑖:“
𝜋𝑒p𝑅𝑒1 𝑅𝑒𝑖q. This defeats the whole purpose of avoiding joins.
However, observe that in our query plan, 𝑅𝑒𝑖has already been
projected onto keyp𝑒𝑖q “ 𝑒𝑖X 𝑒Ď 𝑒before the semi-join, thus this
allows a very simple and efficient way to maintain the whole multi-
way semi-join (3) as one operator, which can also be considered
as a “horizontal” version of derivation counting. More precisely,
we maintain a counter countr𝑡1s for every tuple 𝑡1 in 𝑅𝑒, storing
the number of child nodes 𝑒𝑖P C𝑒such that 𝑡1rkeyp𝑒𝑖qs P 𝑉𝑝p𝑅𝑒𝑖q.
A tuple 𝑡1 appears in 𝑉𝑠p𝑅𝑒q if and only if countr𝑡1s “ |C𝑒|. The
algorithm is then immediate, as shown in Algorithm 3. We also
need a hash index (that needs to support 𝑒X 𝑒𝑖as the key for each
𝑒𝑖P C𝑒) on 𝑅𝑒so that each counter change can be done in 𝑂p1q
time. However, unlike the S-Update, a P-Update may take more
than constant time since multiple tuples may change their counters.
In fact, this is the only place where the update time blows up during
change propagation in our query plan.
R-Update. The last case is when there is an update in an input
relation 𝑅𝑒, we also need to update 𝑉𝑠p𝑅𝑒q by formula (3). We call
this an R-Update. The detailed procedure, given in Algorithm 4,
simply maintains the counters in 𝑅𝑒, and then 𝑉𝑠p𝑅𝑒q, in a straight-
forward manner. It is obvious that an R-Update takes 𝑂p1q time
(also using the hash index on 𝑉𝑝p𝑅𝑒𝑖q).
Example 4.3. Figure 3(b) shows the index after inserting p1, 1q
into 𝑅1. This new tuple first triggers an insertion to 𝑉𝑝p𝑅1q, which
further increments counters of the three tuples in 𝑉𝑠p𝑅2q with
𝑥2 “ 1, which are then brought into 𝑉𝑠p𝑅2q. From here, the propa-
gation diverges into three paths. Tuple p1, 2q P 𝑅2 increments the
counter of p1q P 𝑉𝑝p𝑅2q but this propagation path stops here. Tuple
p1, 1q P 𝑉𝑠p𝑅2q first inserts a new tuple p1q to 𝑉𝑝p𝑅2q, which then
further increments the counter of tuple p1q in the root, bringing it to
Algorithm 3: P-Update(𝑒,𝑡)
Input
:An update 𝑡from 𝑉𝑝p𝑅𝑒𝑖q for some 𝑒𝑖P C𝑒;
Output:Updated 𝑉𝑠p𝑅𝑒q;
1 if 𝑡is an insertion into 𝑉𝑝p𝑅𝑒𝑖q then
2
foreach 𝑡1 P 𝑅𝑒with 𝑡1rkeyp𝑒𝑖qs “ 𝑡do
3
countr𝑡1s Ð countr𝑡1s ` 1;
4
if countr𝑡1s “ |C𝑒| then
5
𝑉𝑠p𝑅𝑒q Ð 𝑉𝑠p𝑅𝑒q Y t𝑡1u, S-Updatep𝑒,𝑡1q;
6 else
7
foreach 𝑡1 P 𝑅𝑒with 𝑡1rkeyp𝑒𝑖qs “ 𝑡do
8
countr𝑡1s Ð countr𝑡1s ´ 1;
9
if countr𝑡1s “ |𝐶𝑒| ´ 1 then
10
𝑉𝑠p𝑅𝑒q Ð 𝑉𝑠p𝑅𝑒q ´ t𝑡1u, S-Updatep𝑒,𝑡1q;
Algorithm 4: R-Update(𝑒,𝑡)
Input
:An update 𝑡from an input relation 𝑅𝑒;
Output:Updated 𝑉𝑠p𝑅𝑒q;
1 if 𝑡is an insertion into 𝑅𝑒then
2
countr𝑡s Ð 0;
3
foreach 𝑒𝑖P C𝑒do
4
if 𝑡rkeyp𝑒𝑖qs P 𝑉𝑝p𝑒𝑖q then
countr𝑡s Ð countr𝑡s ` 1;
5
if countr𝑡s “ |C𝑒| then
6
𝑉𝑠p𝑅𝑒q Ð 𝑉𝑠p𝑅𝑒q Y t𝑡u, S-Updatep𝑒,𝑡q;
7 else
8
if countr𝑡s “ |C𝑒| then
9
𝑉𝑠p𝑅𝑒q Ð 𝑉𝑠p𝑅𝑒q ´ t𝑡u, S-Updatep𝑒,𝑡q;
𝑉𝑠pr𝑥3sq. Tuple p1, 4q P 𝑅2 increments the counter of p4q P 𝑉𝑝p𝑅2q
and the propagation stops.
Figure 3(c) shows the index after deleting p1, 1q from𝑅4. This dele-
tion first decrements the counter of tuple p1q P 𝑉𝑝p𝑅4q, removing it
from 𝑉𝑝p𝑅4q, and further decrements the counter of p1, 1q P 𝑉𝑠p𝑅3q,
removing it from𝑉𝑠p𝑅3q as well. Finally, the counter of p1q P 𝑉𝑝p𝑅3q
decreases from 2 to 1, and the propagation stops here.
Lemma 4.4. All projection and semi-join views in our query plan
can be updated in 𝑂p|𝐷|q time.
5
ENUMERATION
5.1
Full Result Enumeration
We first consider how to perform constant-delay enumeration of
𝑄p𝐷q from our query plan. We need the following lemma:
Lemma 5.1. For any node 𝑒, 𝑉𝑠p𝑅𝑒q “ 𝜋𝑒p1𝑒1PT𝑒𝑅𝑒1q.
Proof of Lemma 5.1. We prove it by the induction on the height
of free-connex join tree T. First, it holds for any leaf node 𝑒, since
𝑉𝑠p𝑅𝑒q “ 𝑅𝑒. We next consider an arbitrary internal node 𝑒. Let
𝐶𝑒“ t𝑒1,𝑒2, ¨ ¨ ¨ ,𝑒𝑘u be the set of children of node 𝑒. By hypothesis,
we assume this lemma holds for every 𝑒𝑖P 𝐶𝑒, i.e.
𝑉𝑠p𝑅𝑒𝑖q “ 𝜋𝑒𝑖p1𝑒1PT𝑒𝑖𝑅𝑒1q
5

---

Algorithm 5: FullEnumpT,𝑒,𝑡q
Input: A free-connex join tree T with connex subtree Econ,
a node 𝑒P T and a key 𝑡P 𝜋keyp𝑒q𝑅𝑒;
Output: Query results over T that can be joined with 𝑡;
1 if 𝑒R Econ then
2
Yield xy
3 else
4
Let C𝑒“ t𝑒1,𝑒2, ¨ ¨ ¨ ,𝑒𝑘u;
5
foreach 𝑡0 P 𝜋yX𝑒𝑉𝑠p𝑅𝑒q such that 𝜋keyp𝑒q𝑡0 “ 𝑡do
6
foreach 𝑡1 P FullEnumpT𝑒1,𝑒1,𝑡0rkeyp𝑒1qsq do
7
foreach 𝑡2 P FullEnumpT𝑒2,𝑒2,𝑡0rkeyp𝑒2qs do
8
¨ ¨ ¨
9
foreach 𝑡𝑘P
FullEnumpT𝑒𝑘,𝑒𝑘,𝑡0rkeyp𝑒𝑘qsq do
10
Yield 𝑡0 1 𝑡1 1 𝑡2 1 ¨ ¨ ¨ 1 𝑡𝑘;
Then, we can rewrite 𝑉𝑠p𝑅𝑒q as follows:
ô 𝑅𝑒˙ 𝑉𝑝p𝑅𝑒1q ˙ ¨ ¨ ¨ ˙ 𝑉𝑝p𝑅𝑒𝑘q
ô 𝑅𝑒1 𝑉𝑝p𝑅𝑒1q 1 ¨ ¨ ¨ 1 𝑉𝑝p𝑅𝑒𝑘q
ô 𝑅𝑒1
´
𝜋keyp𝑒1q𝑉𝑠p𝑅𝑒1q
¯
1 ¨ ¨ ¨ 1
´
𝜋keyp𝑒𝑘q𝑉𝑠p𝑅𝑒𝑘q
¯
ô 𝑅𝑒1
´
𝜋keyp𝑒1qp1𝑒1PT𝑒1 𝑅𝑒1q
¯
1 ¨ ¨ ¨ 1
´
𝜋keyp𝑒𝑘qp1𝑒1PT𝑒𝑛𝑅𝑒1q
¯
ô 𝜋𝑒p𝑅1𝑒1PT𝑒𝑅𝑒1qq
where the first equation follows the definition of semi-join views,
the second equation follows the fact that keyp𝑒𝑖q “ 𝑒𝑖X 𝑒Ď 𝑒, the
third equation follows the definition of projection views, the fourth
equation follows the hypothesis, and the last equation follows the
facts that T𝑒“ t𝑒u Y T𝑒1 Y T𝑒2 Y ¨ ¨ ¨ Y T𝑒𝑘and keyp𝑒𝑖q is exactly
the set of join attributes shared by 𝑅𝑒and any relation in T𝑒𝑖.
□
In plain language, the semi-join view of node 𝑒is essentially the
projection of the join results of relations in the subtree rooted at 𝑒,
to attributes in 𝑒. An immediate corollary is
Corollary 5.2. 𝑉𝑠p𝑅𝑟q “ 𝜋𝑟𝑄p𝐷q.
This means that the semi-join view at the root 𝑟(recall that 𝑟
does not have a projection view) contains precisely all the query
results projected onto 𝑟. Using the notion of a witness query, this
leads to the following useful fact for full enumeration, where Ţ
denotes disjoint union:
Lemma 5.3. 𝑄p𝐷q “ Ţ
𝑡P𝑉𝑠p𝑅𝑟q 𝑄p𝐷˙ 𝑡q.
Lemma 5.1, Corollary 5.2, and Lemma 5.3 allow us to use essen-
tially the same algorithm from Bagan et al. [5] to achieve constant-
delay enumeration of 𝑄p𝐷q; see Algorithm 5, which takes as input
a node 𝑒P T and a key 𝑡P 𝜋keyp𝑒q𝑅𝑒, and yields the query results
over T𝑒that can be joined with 𝑡. To enumerate 𝑄p𝐷q, we simply
invoke FullEnumpT,𝑟, ¨q.
Lemma 5.4. Algorithm 5 enumerates 𝑄p𝐷q with 𝑂p1q delay.
Proof. We prove it by induction on the height of T. Algorithm 5
stops if 𝑟R Econ, which only happens when y “ H. For ease of
Algorithm 6: DeltaEnum(T,𝑡)
Input: A free-connex join tree T; an updated tuple 𝑡.
Output: Delta results induced by 𝑡.
1 Let 𝑒0,𝑒1, ¨ ¨ ¨ ,𝑒𝑘“ 𝑟be the nodes on 𝑡’s propagation path;
2 foreach witness tuple 𝑡1 of 𝑡do
3
Let 𝑒𝑖be the node such that 𝑡1 P 𝜋yX𝑒𝑖Δ𝑉𝑠p𝑅𝑒𝑖,𝑡q;
4
𝑆Ð 𝑡1 1 𝑉𝑙p𝑅𝑒𝑖`1q 1 ¨ ¨ ¨ 1 𝑉𝑙p𝑅𝑒𝑘q;
5
foreach 𝑞P 𝑆do
6
𝑆𝑖ÐFullEnumpT𝑒𝑖,𝑒𝑖,𝑞rkeyp𝑒𝑖qsq;
7
𝑆𝑗ÐFullEnumpT𝑒𝑗´ T𝑒𝑗´1,𝑒𝑗,𝑞rkeyp𝑒𝑗qsq, 𝑗P
r𝑖` 1,𝑘s;
8
Yield 𝑆𝑖1 𝑆𝑖`1 1 ¨ ¨ ¨ 1 𝑆𝑘;
expression, assume any node 𝑒with 𝑒R Econ is removed from T.
We first establish a based case, in which T contains only one node.
The algorithm returns 𝜋yX𝑒𝑉𝑠p𝑅𝑒q in 𝑂p|𝜋yX𝑒𝑉𝑠p𝑅𝑒q|q time, since
all tuples in 𝜋yX𝑒𝑉𝑠p𝑅𝑒q can be enumerated in 𝑂p1q delay. Hence,
this base case can be handled with 𝑂p1q delay.
In general, we have the hypothesis holds on all child nodes 𝑒𝑖of
𝑒(line 6-9): Algorithm 5 can enumerate all join results that agree
with values 𝜋keyp𝑒𝑖q𝑡over attributes keyp𝑒𝑖q in the subtree T𝑒𝑖if
keyp𝑒𝑖q Ď y, as long as 𝑒𝑖belongs to the connex subtree, making
keyp𝑒𝑖q Ď 𝑒X y. Let 𝑡𝑖be a join result returned from T𝑒𝑖. From the
properties of the connex subtree, line 10 will return a valid join
result. Emitting every combination of join results over all subtrees
of 𝑒just takes 𝑂p1q time.
□
5.2
Delta Enumeration
Delta enumeration is straightforward in a standard query plan, as
the root node corresponds to 𝑄p𝐷q, so all changes propagated to the
root are precisely Δ𝑄p𝐷,𝑡q. However, it becomes tricky in our new
query plan, as no node corresponds to 𝑄p𝐷q, which is necessarily
the case if a linear-size representation of 𝑄p𝐷q is desired. In our
query plan, one cannot just inspect the root, because not every
change propagates to the root, and many propagations stop mid-
way, which is actually the main reason why our query plan is
not only space-efficient but also time-efficient. Recall that the full
enumeration algorithm relies on Lemma 5.3. Then the key question
is, can we have an analogy of Lemma 5.3 for the delta Δ𝑄p𝐷,𝑡q? In
other words, can we identify a set of witness tuples 𝑡1 for 𝑡such that
the delta Δ𝑄p𝐷,𝑡q is the disjoint union of 𝑄p𝐷˙ 𝑡1q? Fortunately,
the answer is yes, but the answer is not as simple as Lemma 5.3.
Let’s first consider the insertion case. When we insert 𝑡into some
𝑅𝑒, the propagation follows the path from 𝑒to 𝑟, by (possibly) ap-
plying an R-Update first, then an S-Update, P-Update, S-Update,
P-Update, .... Recall that both S-update and R-update only propa-
gate a single change upward (see line 8, 12 in Algorithm 2 and Algo-
rithm 4), but P-update may propagate multiple changes upward (see
line 6, 12 in Algorithm 2. Hence, there could be multiple propagation
paths starting from 𝑡. To be more precise, we denote the nodes lying
on the path from 𝑒to 𝑟as 𝑒0 “ 𝑒,𝑒1,𝑒2, ¨ ¨ ¨ ,𝑒𝑘“ 𝑟. Every propaga-
tion path inserts a tuple into each of the views on the path, and we
denote the inserted tuples on such a path as p𝑡,𝑡𝑠
0,𝑡𝑝
0 ,𝑡𝑠
1,𝑡𝑝
1 , ¨ ¨ ¨ , q,
where 𝑡𝑠
𝑖P 𝑉𝑠p𝑅𝑖q and 𝑡𝑝
𝑖P 𝑉𝑝p𝑅𝑖q for 𝑖P t0, 1, 2, ¨ ¨ ¨ ,𝑘u.
6

---

Now, we distinguish three cases of a propagation path with
respect to its ending tuple: (1) 𝑡; (2) 𝑡𝑝
𝑗for some 𝑗P t0, 1, 2, ¨ ¨ ¨ ,𝑘u;
(3) 𝑡𝑠
𝑖for some 𝑖P t0, 1, 2, ¨ ¨ ¨ ,𝑘u.
Case (1) happens when the first update is an R-Update and does
not propagate any further change. This means that in Algorithm 4,
there exists some child node 𝑒1 of 𝑒such that 𝑡rkeyp𝑒1qs R 𝑉𝑝p𝑅𝑒1q,
i.e.,𝑡cannot join with T𝑒1. In this case,𝑡will not produce any change
to 𝑄p𝐷q, thus can be ignored.
Case (2) happens when P-Update(𝑒𝑗,𝑡𝑝
𝑗) does not propagate any
further change. Putting it into Algorithm 3, this means that either
there exists no tuple 𝑡1 P 𝑅𝑝𝑒𝑗that can join with 𝑡𝑝
𝑗, or if such a
tuple exists, but it cannot join with (or intersect with, if 𝑅𝑝𝑒𝑗is a
generalized relation) any query result over T 1𝑒for some child node
𝑒1 of 𝑝𝑒𝑗, since its counter is smaller than |C𝑝𝑒𝑗|. In either case, this
propagation path will not cause any change to 𝑄p𝐷q, thus can also
be ignored.
Case (3) happens when S-update(𝑒𝑖,𝑡𝑠
𝑖) does not propagate any
further change. Putting it into Algorithm 2, this means that either
we have reached the root, or there exists some other tuple 𝑡1 P
𝑉𝑝p𝑅𝑖q such that 𝑡1 ‰ 𝑡𝑠
𝑖and 𝑡𝑠
𝑖rkeyp𝑒𝑖qs “ 𝑡1rkeyp𝑒𝑖qs. Note that
𝑅𝑖can be either an input relation or a generalized relation. This is
the only case where changes to 𝑄p𝐷q can possibly happen. We will
give a more detailed characterization of this case later.
Live views. To support constant-delay delta enumeration, we
maintain a live view for each node 𝑒P Econ:
𝑉𝑙p𝑅𝑒q :“ 𝜋yX𝑒𝑄p𝐷q,
which are the “live” tuples (i.e., appearing in the query results)
projected onto 𝑒. Note that 𝑉𝑙p𝑅𝑒q Ď 𝜋yX𝑒𝑉𝑠p𝑅𝑒q, which means
for 𝑒Ď y, it can be implemented by simply adding an extra bit in
𝑉𝑠p𝑅𝑒q, indicating if the corresponding tuple is in 𝑉𝑙p𝑅𝑒q.
For the root 𝑟, there is no need to maintain 𝑉𝑙p𝑅𝑟q separately
since𝑉𝑙p𝑅𝑟q “ 𝑉𝑠p𝑅𝑟q by Corollary 5.2. For the leaf nodes, their live
views need not be maintained, either, since they will not be needed
by delta enumeration. The other live views can be maintained by
the following observation:
Lemma 5.5. For any non-root node 𝑒such that 𝑒P Econ and any
tuple 𝑡P 𝜋yX𝑒𝑉𝑠p𝑅𝑒q, 𝑡P 𝑉𝑙p𝑅𝑒q if and only if 𝑡1 𝑉𝑙p𝑅𝑝𝑒q ‰ H.
Based on the Lemma 5.5, the maintenance of 𝑉𝑙p𝑅𝑒q can pig-
gyback on the delta enumeration: After enumerating a result
𝑡1 P Δ𝑄p𝐷,𝑡q, we update the live views in a top-down fashion.
For every non-root 𝑒such that 𝑒Xy ‰ H, if the update is insertion,
then we always add 𝑡1r𝑒s to 𝑉𝑙p𝑅𝑒q; if the update is deletion, then
we delete 𝑡1r𝑒s from 𝑉𝑙p𝑅𝑒q if 𝑡1r𝑒s cannot join with 𝑉𝑙p𝑅𝑝𝑒q, which
can be done in 𝑂p1q time with a hash index on 𝑉𝑙p𝑅𝑝𝑒q (which is
physically the same hash index on 𝑉𝑠p𝑅𝑝𝑒q for 𝑒Ď y). This only
adds another constant to the delay of delta enumeration.
Witness tuples. We now are ready to give a more precise char-
acterization of the ending tuples falling into Case (3) that actually
cause changes to 𝑄p𝐷q, called witness tuples:
Definition 5.6 (Witness tuple). Suppose 𝑡is inserted into or
deleted from 𝐷. A tuple 𝑡1 is a witness of 𝑡if
𝑡1 P Δ𝑉𝑠p𝑅𝑟,𝑡q, or
(5)
𝑡1 P 𝜋yX𝑒Δ𝑉𝑠p𝑅𝑒,𝑡q ˙ 𝑉𝑙p𝑅𝑝𝑒q
(6)
for some non-root 𝑒such that 𝑒P Econ.
Here Δ𝑉𝑠p𝑅𝑒,𝑡q denotes the tuples to be inserted into (or deleted
from) 𝑉𝑠p𝑅𝑒q due to 𝑡and 𝑉𝑙p𝑅𝑝𝑒q is the live view before the up-
date. We give some intuition behind Definition 5.6. First, (5) is the
counterpart of Corollary 5.2 for delta enumeration and such a 𝑡1
is guaranteed to generate changes to 𝑄p𝐷q. (6) is specific for delta
enumeration, addressing the situation mentioned earlier, where
the propagation stops mid-way yet still causes changes to 𝑄p𝐷q.
Note that in this case, the attributes of 𝑡1 are 𝑒X y. Then (6) implies
that 𝑡1 P 𝜋yX𝑒Δ𝑉𝑠p𝑅𝑒,𝑡q and 𝑡1rkeyp𝑒qs P 𝜋keyp𝑒q𝑉𝑙p𝑅𝑝𝑒q. Since
𝑡1rkeyp𝑒qs P 𝜋keyp𝑒q𝑉𝑙p𝑅𝑝𝑒q, it must have 𝑡1rkeyp𝑒qs P 𝑉𝑝p𝑅𝑒q,
i.e. 𝑡1rkeyp𝑒qs R Δ𝑉𝑝p𝑅𝑒,𝑡q, which means that the propagation
stops at node 𝑒under case (3). In addition, each witness tuple 𝑡1
should (i) contribute to the delta over T𝑒induced by 𝑡, and (ii)
join with tuples from the remaining relations in T ´ T𝑒. For (i),
it suffices to require 𝑡1 P Δ
`
𝜋yX𝑒𝑉𝑠p𝑅𝑒q
˘
“ 𝜋yX𝑒Δ𝑉𝑠p𝑅𝑒,𝑡q, since
Δ
`
𝜋𝑒Xyp1𝑒1PT𝑒𝑅𝑒1q
˘
“ Δ
`
𝜋yX𝑒𝑉𝑠p𝑅𝑒q
˘
. For (ii), it suffices to re-
quire𝑡1˙𝑉𝑙p𝑅𝑝𝑒q ‰ H, and this is exactly the reason we introduced
𝑉𝑙p𝑅𝑒q in the first place.
Lemma 5.7. Δ𝑄p𝐷,𝑡q “ Ţ
𝑡1:a witness of 𝑡𝑄p𝐷˙ 𝑡1q.
We are now ready to state the counterpart of Lemma 5.3 for delta
enumeration, in Lemma 5.7. Unlike Lemma 5.3, the proof of Lemma
5.7 is nontrivial, and the details are given in Appendix B.
The algorithm. To perform delta enumeration using Lemma 5.7,
we still need to address two issues: (1) how to find all witness tuples
𝑡1, and (2) how to enumerate 𝑄p𝐷˙ 𝑡1q with constant delay.
To find all the witness tuples, we consider the two cases in
Definition 5.6: (5) can be computed easily after updating 𝑉𝑠p𝑅𝑟q;
for (6), just an extra check with 𝑉𝑙p𝑅𝑝𝑒q is needed, which can be
done in 𝑂p1q time using the hash index on 𝑉𝑙p𝑅𝑝𝑒q. These steps
only increase the update cost by a constant factor.
It remains to describe how to enumerate 𝑄p𝐷˙ 𝑡1q for each
witness 𝑡1. As before, let 𝑒0,𝑒1, . . . ,𝑒𝑘“ 𝑟be the nodes on the
propagation path, and suppose we are given a witness tuple 𝑡1 P
𝜋yX𝑒𝑖Δ𝑉𝑠p𝑅𝑒𝑖,𝑡q for some 𝑖. We first enumerate the query results
participated by 𝑡1 together with relations on the path from 𝑒𝑖`1
to the root 𝑟, denoted as 𝑆. This can be done by joining 𝑡with
the live views associated with these nodes. For each such result
𝑞P 𝑆, we enumerate the query results that participated by 𝑞. This
enumeration is done by partitioning the whole free-connex join
tree into disjoint subtrees T𝑒𝑖, T𝑒𝑖`1 ´ T𝑒𝑖, ¨ ¨ ¨ , T𝑒𝑘´ T𝑒𝑘´1, and
invoking FullEnum for each subtree separately. Finally, we join
these subtrees together. The detailed process is given in Algorithm 6.
Note that, as written, the algorithm does not achieve constant-delay
enumeration. However, this can be easily fixed. First, the join in
line 4 can be enumerated with constant delay using (a variant of)
FullEnum starting from𝑡1. Then we interleave the two enumeration
processes: After enumerating each 𝑞P 𝑆, we immediately call line
6–8. Finally, line 6–8 can be rewritten into nested loops so as to
enumerate the join 𝑆𝑖1 ¨ ¨ ¨ 1 𝑆𝑘with constant delay. In fact, this
join is more like a cross product (common attributes must have the
same value, the same as those in 𝑞), and a total of Π𝑘
𝑗“𝑖|𝑆𝑗| results
will be yielded.
7

---

r𝑥3s
𝑉𝑠pr𝑥3sq
𝑥3
𝑐r𝑡s
1
1
2
1
3
1
4
2
𝑅2
𝑉𝑝p𝑅2q
𝑥3
𝑐r𝑡s
4
1
2
1
Ô
𝑉𝑠p𝑅2q
𝑥2
𝑥3
𝑐r𝑡s
1
2
0
2
2
1
4
3
0
1
1
0
2
4
1
1
4
0
𝑅3
𝑉𝑝p𝑅3q
𝑥3
𝑐r𝑡s
1
2
3
1
4
1
Ô
𝑉𝑠p𝑅3q
𝑥3
𝑥4
𝑐r𝑡s
1
1
1
2
5
0
3
3
1
1
2
1
4
4
1
𝑅1
𝑉𝑝p𝑅1q
𝑥2
𝑐r𝑡s
2
2
3
1
Ò
𝑉𝑠p𝑅1q
𝑥1
𝑥2
1
2
2
2
3
3
𝑅4
𝑉𝑝p𝑅4q
𝑥4
𝑐r𝑡s
1
1
2
1
3
1
4
1
Ò
𝑉𝑠p𝑅4q
𝑥4
𝑥5
1
1
2
2
3
3
4
4
(a) Initialization.
r𝑥3s
𝑉𝑠pr𝑥3sq
𝑥3
𝑐r𝑡s
1*
2
2
1
3
1
4
2
𝑅2
𝑉𝑝p𝑅2q
𝑥3
𝑐r𝑡s
4
2
2
2
1
1
Ô
𝑉𝑠p𝑅2q
𝑥2
𝑥3
𝑐r𝑡s
1
2
1
2
2
1
4
3
0
1
1
1
2
4
1
1*
4*
1
𝑅3
𝑉𝑝p𝑅3q
𝑥3
𝑐r𝑡s
1
2
3
1
4
1
Ô
𝑉𝑠p𝑅3q
𝑥3
𝑥4
𝑐r𝑡s
1
1
1
2
5
0
3
3
1
1
2
1
4
4
1
𝑅1
𝑉𝑝p𝑅1q
𝑥2
𝑐r𝑡s
2
2
3
1
1
1
Ò
𝑉𝑠p𝑅1q
𝑥1
𝑥2
1
2
2
2
3
3
1
1
𝑅4
𝑉𝑝p𝑅4q
𝑥4
𝑐r𝑡s
1
1
2
1
3
1
4
1
Ò
𝑉𝑠p𝑅4q
𝑥4
𝑥5
1
1
2
2
3
3
4
4
(b) After the insertion of p1, 1q into 𝑅1.
r𝑥3s
𝑉𝑠pr𝑥3sq
𝑥3
𝑐r𝑡s
1
2
2
1
3
1
4
2
𝑅2
𝑉𝑝p𝑅2q
𝑥3
𝑐r𝑡s
4
2
2
2
1
1
Ô
𝑉𝑠p𝑅2q
𝑥2
𝑥3
𝑐r𝑡s
1
2
1
2
2
1
4
3
0
1
1
1
2
4
1
1
4
1
𝑅3
𝑉𝑝p𝑅3q
𝑥3
𝑐r𝑡s
1
1
3
1
4
1
Ô
𝑉𝑠p𝑅3q
𝑥3
𝑥4
𝑐r𝑡s
1*
1*
0
2
5
0
3
3
1
1
2
1
4
4
1
𝑅1
𝑉𝑝p𝑅1q
𝑥2
𝑐r𝑡s
2
2
3
1
1
1
Ò
𝑉𝑠p𝑅1q
𝑥1
𝑥2
1
2
2
2
3
3
1
1
𝑅4
𝑉𝑝p𝑅4q
𝑥4
𝑐r𝑡s

1

1
2
1
3
1
4
1
Ò
𝑉𝑠p𝑅4q
𝑥4
𝑥5
1
1
2
2
3
3
4
4
(c) After the deletion of p1, 1q from 𝑅4.
r𝑥3s
𝑉𝑠pr𝑥3sq
𝑥3
𝑐r𝑡s
1
2
2
1
3
1
4
2
𝑅2
𝑉𝑝p𝑅2q
𝑥3
𝑐r𝑡s
4
2
2
2
1
1
Ô
𝑉𝑠p𝑅2q
𝑥2
𝑥3
𝑐r𝑡s
1
2
1
2
2
1
4
3
0
1
1
1
2
4
1
1
4
1
𝑅3
𝑉𝑝p𝑅3q
𝑥3
𝑐r𝑡s
1
1
3
1
4
1
Ô
𝑉𝑠p𝑅3q
𝑥3
𝑥4
𝑐r𝑡s
1
1
0
2
5
0
3
3
1
1
2
1
4
4
1
𝑅1
𝑉𝑝p𝑅1q
𝑥2
𝑐r𝑡s
2
2
3
1
1
2
Ò
𝑉𝑠p𝑅1q
𝑥1
𝑥2
1
2
2
2
3
3
1
1
4*
1*
𝑅4
𝑉𝑝p𝑅4q
𝑥4
𝑐r𝑡s
2
1
3
1
4
1
Ò
𝑉𝑠p𝑅4q
𝑥4
𝑥5
2
2
3
3
4
4
(d) After the insertion of p4, 1q into 𝑅1.
Figure 3: A running instance for query in Figure 1 using the plan in Figure 1(c). Tuples in white are in 𝑉𝑠p𝑅q, in grey are in
𝑅z𝑉𝑠p𝑅q, in cyan are in 𝑉𝑙p𝑅q (live views for leaf nodes are not needed, but we still show them for clarity), with star symbols are
the witness tuples. Changes in each step are marked in red.
Example 5.8. In figure 3(a), there are two query results p1, 2, 4, 4q
and p2, 2, 4, 4q. In figure 3(b), when the propagation stops, we have
‚ Tuple p1, 2q P 𝑅2 is not a witness as it cannot join with any tuple
in 𝑉𝑙pr𝑥3sq, thus no delta is produced;
‚ Tuple p1q P r𝑥3s is a witness, which triggers delta enumeration.
For a witness in the root, DeltaEnum simply degenerates to
FullEnumpT𝑟,𝑟, p1qq, which outputs tp1, 1, 1, 1q, p1, 1, 1, 2qu.
‚ Tuple p1, 4q P 𝑅2 is a witness, which triggers delta enumeration.
DeltaEnum finds𝑆“ p1, 4q 1 𝑉𝑙pr𝑥3sq “ tp1, 4qu. For p1, 4q P 𝑆,
it invokes FullEnumpT𝑟´ T𝑅2,𝑟, p4qq with tp4, 4qu returned and
FullEnumpT𝑅2, 𝑅2, p1, 4qq with tp1, 1, 4qu returned. Joining them
yields the delta tp1, 1, 4, 4qu.
Finally, as each new result is enumerated, we update the live views.
In figure 3(c), tuple p1, 1q P Δ𝑉𝑠p𝑅3q is a witness. DeltaEnum
first finds 𝑆“ tp1, 1qu. For p1, 1q P 𝑆, it invokes FullEnumpT𝑟´
T𝑅3,𝑟, p1qq with tp1, 1, 1qu returned, and FullEnumpT𝑅3, 𝑅3, p1, 1qq
with tp1, 1, 4qu returned (delta enumeration upon a deletion is done
before the tuple deletion so as to find the delta). Joining them yields
the delta tp1, 1, 1, 1qu. Finally, we update live views with the delta.
Lemma 5.9. Algorithm 6 enumerates Δ𝑄p𝐷,𝑡q with constant delay.
We have now closed the loop: while enumerating Δ𝑄p𝐷,𝑡q, we
update the live views as described earlier, which are needed for
enumerating the next delta.
6
UPDATE COST ANALYSIS
We have shown that the enumeration delay of both full query
results and deltas is a constant, and this holds for the query plan
defined by any free-connex join tree as in Section 4.1. On the other
hand, the update cost differs for different query plans and can be
as large as 𝑂p|𝐷|q in the worst case. This is caused by P-Update,
which may trigger an S-Update to every tuple in its parent node.
However, such a worst-case behavior only happens on contrived
update sequences, and the actual update cost can be much better.
Characterizing the update cost will be important for constructing a
good query plan, as there can be many free-connex join trees for
a given free-connex query. As we will see, the height of the join
tree is an important parameter, and this is precisely the reason why
we make our framework applicable to any free-connex join tree,
as the height of a free-connex join tree can be lower than that of
any standard join tree. For example, the query in Figure 2 has a
free-connex join tree of height 1 while the two standard join trees
have height 2; the query in Figure 1 has a free-connex join tree of
height 2 while any standard join tree has height as least 3.
6.1
Enclosureness
Update sequences and lifespans. Given an update sequence 𝑆𝐷,
the lifespan of tuple 𝑡is an interval 𝐼p𝑡q “ r𝑡`,𝑡´s, where 𝑡`
denotes the timestamp when 𝑡is inserted into 𝐷and 𝑡´ denotes
the timestamp when 𝑡is deleted from 𝐷. We set 𝑡` “ ´8 to
indicate that 𝑡exists in the initial 𝐷and 𝑡´ “ `8 indicates that
𝑡still exists in 𝐷after the update sequence. Note that if a tuple is
repeatedly inserted and deleted, it will be treated as multiple tuples,
which have the same values but disjoint lifespans.
Although our algorithms will be able to handle arbitrary update
sequences, their performance can be better if the update sequences
possess some nice properties. In particular, the following two re-
strictive classes of update sequences are of practical importance:
8

---

‚ First-in-first-out (FIFO). A update sequence 𝑆𝐷is FIFO if for
any two tuples 𝑡1,𝑡2 P 𝑆𝐷, 𝑡`
1 ă 𝑡`
2 implies 𝑡´
1 ă 𝑡´
2 . FIFO se-
quences are commonly used in practice, such as sliding-window
or tumbling-window models over streaming data.
‚ Insertion-only or deletion-only. A update sequence 𝑆𝐷is
insertion-only (w.r.t. deletion-only) if for any tuple 𝑡P 𝑆𝐷, 𝑡´ “
`8 (w.r.t. 𝑡` “ ´8). The two cases are symmetric, so we will
only discuss the insertion-only case in this paper.
The notion of enclosureness was first introduced in [36] to give
an instance-specific characterization of the hardness of the update
sequence, which we briefly review next.
Definition 6.1 (Enclosureness). Given an update sequence 𝑆𝐷, the
enclosureness of a tuple 𝑡P 𝑆𝐷is
𝜆p𝑡q :“
max
JĎ𝑆𝐷
@𝑡1PJ,𝐼p𝑡1qĂ𝐼p𝑡q
@𝑡2,𝑡3PJ,𝐼p𝑡2qX𝐼p𝑡3q“H
|J|,
(7)
i.e., the largest number of disjoint lifespans in 𝑆𝐷contained in
𝐼p𝑡q. Then the enclosureness of the update sequence is the average
enclosureness of all the tuples (but at least 1), i.e.,
𝜆p𝑆𝐷q :“ max
˜ř
𝑡P𝑆𝐷𝜆p𝑡q
|𝑆𝐷|
, 1
¸
.
(8)
We often omit 𝑆𝐷and simply write 𝜆:“ 𝜆p𝑆𝐷q for the enclosure-
ness of an update sequence.
Then, they give an algorithm that can update any foreign-key
acyclic query in 𝑂p𝜆q time for any 𝑆𝐷while supporting 𝑂p1q-delay
enumeration. This is appealing, since while 𝜆can be as large as
𝑂p|𝑆𝐷|q in the worst case, it is often a small constant for many com-
mon update sequences, including FIFO, FILO (first-in-last-out), and
insertion-/deletion-only sequences. The worst-case situation only
happens when there are many tuples with long lifespans joining
with many tuples with short lifespans, something that is uncommon
in practice (i.e., many big but ephemeral changes to the query).
However, their analysis crucially relies on the nice property of
foreign-key acyclic queries, that their result size is at most linear,
which is not the case for non-key joins. In fact, we show below
that the 𝑂p𝜆q update time is unachievable for free-connex queries,
which follows from the negative result that we prove below:
Theorem 6.2. Consider the query 𝑄“ 𝑅1p𝑥1q 1 𝑅2p𝑥1,𝑥2q 1
𝑅3p𝑥2,𝑥3q 1 𝑅4p𝑥3,𝑥4q 1 𝑅5p𝑥4q over a FIFO update sequence. If
there is an algorithm for 𝑄with update time 𝑂p|𝐷|1{2´𝜖q while sup-
porting 𝑂p|𝐷|1´𝜖q-delay enumeration of full results for any constant
𝜖ą 0, then the OuMv conjecture3 fails.
Note that this theorem separates the difficulty of (at least one
of) free-connex queries from foreign-key acyclic queries, for which
𝑂p1q update time is possible for FIFO sequences [36].
3The OuMv conjecture [19] is that the following problem cannot be solved in𝑂p𝑛3´𝜖q
time for any constant𝜖ą 0: Given an𝑛ˆ𝑛matrix 𝑀and a sequence of𝑛-dimensional
vectors𝑢1, 𝑣1,𝑢2, 𝑣2, ¨ ¨ ¨ ,𝑢𝑛, 𝑣𝑛, compute𝑢𝑖𝑀𝑣𝑖for each𝑖over the Boolean semiring.
The algorithm must return 𝑢𝑖𝑀𝑣𝑖before 𝑢𝑖`1, 𝑣𝑖`1 are revealed.
6.2
Join-tree-specific Enclosureness
Hope is not all lost despite the negative result above. First, Theorem
6.2 only holds for a particular free-connex query; other queries may
still be updated in 𝑂p1q time. Secondly, the definition of enclosure-
ness in [36] only considers the time dimension while ignoring the
structure dimension, i.e., which relation each update is applied to.
These observations motivate a more refined definition of enclosure-
ness that also depends on the join tree (which nodes the updates
are applied to). As we will see, a hard query like the one in Theorem
6.2 can still be solved efficiently, when information from both the
structural dimension and the time dimension is taken into account.
Definition 6.3 (Effective lifespan of Tuples from Input Relations).
Given a free-connex query 𝑄, a free-connex join tree T of 𝑄, a
database 𝐷, and an update sequence 𝑆𝐷, the two effective lifespans
of an input tuple 𝑡1 P 𝑅𝑒with lifespan 𝐼p𝑡1q “ r𝑡`
1 ,𝑡´
1 s are
p𝐼p𝑡1q “
«
𝑡`
1 , min
˜
𝑡´
1 ,
min
𝑡2P𝑅𝑒1:𝑒1PT𝑒´t𝑒u,𝑡´
2 ą𝑡`
1
𝑡´
2
¸ff
;
q𝐼p𝑡1q “
«
max
˜
𝑡`
1 ,
max
𝑡2P𝑅𝑒1:𝑒1PT𝑒´t𝑒u,𝑡`
2 ă𝑡´
1
𝑡`
2
¸
,𝑡´
1
ff
.
where the minimum and maximum choices are taken over all tuples
𝑡2 from any input relation 𝑅𝑒1 residing in the subtree T𝑒.
In plain language, p𝐼p𝑡1q is obtained from 𝐼p𝑡1q by moving forward
its ending time to the first deletion of an input tuple from any
descendent of 𝑒, while to obtain q𝐼p𝑡1q, we move its starting to the
last insertion of an input tuple from any descendent of 𝑒.
We can now define the join-tree-specific enclosureness of a tuple:
Definition 6.4. Given a free-connex query 𝑄, a free-connex join
tree T of 𝑄, a database 𝐷, and an update sequence 𝑆𝐷, for a node
𝑒P T and a tuple 𝑡P 𝑅𝑒, its enclosureness is
𝜆Tp𝑡q “
max
@𝑡1PJ,D𝑒1PT𝑒´t𝑒u,𝑡1P𝑅𝑒1
@𝑡1PJ,9𝐼p𝑡1qĎ𝐼p𝑡q
@𝑡2,𝑡3PJ,9𝐼p𝑡2qX9𝐼p𝑡3q“H
|J|,
(9)
where each 9𝐼is either p𝐼or q𝐼, i.e., the largest number of disjoint
effective lifespans of tuples in the descendants of 𝑒, which are
contained in the lifespan of 𝑡. Then the enclosureness of the update
sequence is still the average:
𝜆Tp𝑆𝐷q :“ max
˜ř
𝑡P𝑆𝐷𝜆Tp𝑡q
|𝑆𝐷|
, 1
¸
.
We often write 𝜆T :“ 𝜆Tp𝑆𝐷q for the enclosureness of an update
sequence with respect to T.
Example 6.5. Consider 𝑄:“ 𝑅1p𝑥1,𝑥2q 1 𝑅2p𝑥2,𝑥3q in Figure 2
with T1, T2, T3. For the update sequence in Figure 4, 𝜆T1 “ 𝜆T2 “ 𝑛
and 𝜆T3 “ 1. In fact, 𝜆T3 “ 1 for any update sequence.
The main analytical result of this paper is the following theorem,
whose proof is quite technical given in Appendix C:
Theorem 6.6. For any free-connex query 𝑄, the update cost of the
query plan in Section 4 induced by any given free-connex join tree T
of 𝑄is 𝑂p𝜆Tq under any update sequence with enclosureness 𝜆T.
9

---

(1, 1)
· · ·
(n, 1)
(1, 2)
· · ·
Time
(n, 2)
(1, 1)
· · ·
(1, n)
(2, 1)
· · ·
(2, n)
R2
n/1/1
n/1/1
n/1/1
1/1/1
1/1/1
1/1/1
1/1/1
1/1/1
1/1/1
1/n/1
1/n/1
1/n/1
R1
Figure 4: As update sequence in Example 6.5. Each interval is
the lifespan of a tuple, and three numbers above each interval
are its enclosureness over T1, T2 and T3 in Figure 2.
This result is complemented with a matching lower bound, for
at least one particular query: 𝑄“ 𝜋𝑥1p𝑅1p𝑥1,𝑥2q 1 𝑅2p𝑥2qq, which
has one join tree as shown in Figure 2(a) (one could add a general-
ized relation r𝑥1s at the top, but it does not change the enclosure-
ness). Thus, for this query, 𝜆T does not really depend on T.
Theorem 6.7. [36] Suppose there is an algorithm for the query
𝑄“ 𝜋𝑥1p𝑅1p𝑥1,𝑥2q 1 𝑅2p𝑥2qq with update time 𝑂p𝜆1´𝜖q while
supporting𝑂p𝜆1´𝜖q-delay enumeration of full results for any constant
𝜖ą 0, then the OMv conjecture4 fails.
6.3
Implications of Enclosureness
We present some implications of our join-tree-specific enclosure-
ness and Theorem 6.6, exhibiting an interesting trade-off between
the hardness of update sequences and the complexity of queries.
Arbitrary update sequences. For arbitrary update sequences,
prior work [8, 20] has shown how to achieve 𝑂p1q update time
while supporting 𝑂p1q-delay enumeration for any q-hierarchical
query. It turns out that this is an easy consequence of Theorem 6.6,
plus the following structural property of q-hierarchical queries, as
well as the simple fact that 𝜆T “ 1 if the height of T is 1:
Lemma 6.8. Every q-hierarchical CQ has a height-1 free-connex
join tree.
For arbitrary update sequences, q-hierarchical queries are pre-
cisely the class of queries for which 𝑂p1q update time is possible
[8]. Thus, for queries outside this class, we must restrict the update
sequence in order to achieve 𝑂p1q update time. We consider the
following two classes of update sequences.
FIFO sequences. The update time is shown to be 𝑂p1q for foreign-
key acyclic joins over FIFO sequences [36], but nothing is known
for non-key joins (except for q-hierarchical queries which do not
rely on FIFO). We present the first extension in this direction:
Lemma 6.9. For any free-connex query 𝑄with a free-connex join
tree T of height at most 2, 𝜆T “ 1 for any FIFO sequence.
Note that the height limit of 2 is the best one can hope for, since
the query in Theorem 6.2 has a join tree of height 3 and the theorem
shows that it cannot be updated in 𝑂p1q time over FIFO sequences.
Although the height-2 limitation restricts the class of queries, this
4The OMv conjecture is similar to the OuMv conjecture, except that the algorithm
needs to compute 𝑀𝑣𝑖for every 𝑣𝑖.
already includes some fairly complex queries, such as the one in
Figure 1; more examples can be found in Section 8.
Insertion-only sequences. As we restrict the update sequence
further, we can handle more queries in 𝑂p1q time. For simplicity,
the following result only considers insertion-only sequences, but
the same result holds for deletion-only or FILO sequences as well.
Lemma 6.10. For any free-connex CQ 𝑄and free-connex join tree
T, 𝜆T “ 1 for any insertion-only update sequence.
Combining Theorem 6.6 and Lemma 6.10, the following theorem
is straightforward.
Theorem 6.11. For a free-connex query 𝑄, there is an index that
can be updated in 𝑂p1q amortized time under any insertion-only
update sequence, while supporting 𝑂p1q-delay enumeration.
Note that Lemma 6.10 incorporates the static result [5] as a
special case. Given a static database 𝐷, we can simply insert every
tuple from 𝐷into our query plan. By Lemma 6.10, this builds a data
structure in 𝑂p|𝐷|q time that supports 𝑂p1q-delay enumeration of
𝑄p𝐷q. Also, the dichotomy result of [5] states that 𝑂p|𝐷|q-time
preprocessing and 𝑂p1q-delay enumeration are possible only for
free-connex queries, thus Lemma 6.10 cannot be extended to beyond
free-connex queries, either, even over insertion-only sequences.
Example 6.12. Consider an insertion-only update sequence for
the query in Figure 1: (1) tuples p𝑖, 𝑗q P r𝑛s ˆ r𝑛s are inserted into
𝑅2, 𝑅3 and 𝑅4 initially; (2) tuples p𝑖, 𝑗q P r𝑛s ˆ r𝑛s are inserted into
𝑅1 later. Standard change propagation or HIVM needs to materi-
alize Δp𝑅1 1 𝑅2 1 𝑅3q, hence incurs 𝑂p𝑛3q cost; the Dynamic
Yannakakis algorithm [20] needs to scan all tuples p𝑖1, 𝑗1q P 𝑅2 for
𝑖1 “ 𝑗, once p𝑖, 𝑗q is inserted into 𝑅1, hence incurs Θp𝑛q cost; and
our framework only incurs 𝑂p1q cost.
Query plan optimization. If the given query and/or the update
sequence do not fall into any of the three cases above where 𝑂p1q
update time can be guaranteed, our enclosureness analysis still
yields an effective heuristic for choosing a good T, which in turn
determines the query plan. First, it is clear that T with a smaller
height is always preferred. Furthermore, Definition 6.4 suggests
that we should put nodes with more updates higher in T, as a tuple
in a node might increase the enclosureness of tuples in its ancestors.
Thus, in our implementation, we construct all join trees and use
the one that minimizes
ÿ
𝑒PT
𝑑p𝑒q𝑁p𝑒q, where 𝑑p𝑒q is the depth of 𝑒
in T (not counting generalized relations and itself) and 𝑁p𝑒q is the
number of updates to 𝑒. If 𝑁p𝑒q is unavailable, we can estimate it
by observing (and buffering) the first few updates.
7
EXTENSIONS TO GENERAL QUERIES
7.1
General CQs
Acyclic but non-free-connex queries. Consider such a query
𝜋𝑥1,𝑥3𝑅1p𝑥1,𝑥2q 1 𝑅2p𝑥2,𝑥3q. We simply add 𝑥2 as an output at-
tribute to turn it into a free-connex query, and then do a projection
over 𝑥1,𝑥3 during enumeration. Note that enumeration may con-
tain duplicates. Thus, if a DISTINCT keyword is declared explicitly,
duplicates need to be removed, hence making the delay more than
constant, but this is inevitable due to the lower bound [5].
10

---

𝑥1
𝑥2
𝑥3
𝑥4
𝑥5
𝑥6
𝑅1
𝑅2
𝑅3
𝑅4
𝑅5
𝑅6
𝑅7
(a) Hypergraph and a GHD
˙ : 𝑉𝑠p𝑅7q
𝜋: 𝑉𝑝p𝐵1q
𝑅7
𝜋: 𝑉𝑝p𝐵2q
𝑉𝑠p𝐵1q : 𝑅3 1 𝑉1
𝑉𝑠p𝐵2q : 𝑅6 1 𝑉2
𝑅3
𝑉1 : 𝑅2 1 𝑅1
𝑉2 : 𝑅4 1 𝑅5
𝑅6
𝑅2
𝑅1
𝑅4
𝑅5
𝐵1
𝐵2
(b) Query plan under new change propagation
𝑉6 “ 𝑉4 1 𝑉5
𝑉4 “ 𝑉2 1 𝑅7
𝑉5 “ 𝑉3 1 𝑅6
𝑉2 “ 𝑉1 1 𝑅3
𝑅7
𝑉3 “ 𝑅4 1 𝑅5
𝑅6
𝑅3
𝑉1 “ 𝑅2 1 𝑅3
𝑅5
𝑅4
𝑅1
𝑅2
(c) Query plan under standard change propagation
Figure 5: 5(a) is the hypergraph of the “dumbbell” query 𝑄“ 𝑅1p𝑥1,𝑥2q 1 𝑅2p𝑥1,𝑥3q 1 𝑅3p𝑥2,𝑥3q 1 𝑅4p𝑥5,𝑥6q 1 𝑅5p𝑥4,𝑥5q 1
𝑅6p𝑥4,𝑥6q 1 𝑅7p𝑥3,𝑥4q, with GHD illustrated in red circle. 5(c),5(b) are query plans under the standard, new change propagation
framework respectively. In 5(c), 𝐵1, 𝐵2 are treated as two basic relations, on which projection and semi-join views are constructed.
Cyclic queries. Cyclic queries can also be easily handled in our
framework by resorting to Generalized Hypertree Decomposition
(GHD) [17]. More specifically, by grouping several relations into a
bag, an arbitrary CQ can be converted into a free-connex one. For
example, Figure 5(a) shows a GHD for the “dumbbell” query with 3
bags.
We can use standard change propagation within each bag, and
apply our framework across the bags. This results in the query plan
in Figure 5(b), which has 𝑂p𝑁2q space and 𝑂p𝑁q update time while
supporting constant-delay enumeration. On the other hand, the
standard change propagation framework would use a query plan
like the one in Figure 5(c), which has 𝑂p𝑁3q space and update time.
Of course, all these are worst-case bounds; on realistic inputs, the
costs are lower, but our new query plan is still order-of-magnitude
better than the old plan, as shown in Section 8.
If one is interested in further improving the theoretical bounds,
the algorithm for maintaining the query results inside each bag
can be replaced by a better algorithm. For example, Kara et al. [25]
present an algorithm for maintaining the triangle join. Replacing
with the new algorithm can improve the space usage from 𝑂p𝑁2q
to 𝑂p𝑁
?
𝑁q. On the other side, although the algorithm [25] can
improve the update cost for each bag to 𝑂p
?
𝑁q, the “dumbbell”
query still suffers from 𝑂p𝑁q update cost. This is indeed unavoid-
able as a single tuple update can change as large as 𝑂p𝑁q results
materialized for one bag, which further propagates to the overall
framework. Hence, the update cost for this GHD-based change
propagation framework is determined by updates not only inside
each bag but also across bags.
Beyond the triangle join, not many results are known. This is
still an actively researched problem; any improvement here will
also improve general CQs when plugged into our framework.
Theorem 7.1. Given a CQ 𝑄with a free-connex GHD of width5
𝑤, there is an index of 𝑂p𝑁𝑤q size that can be updated in Ωp𝑁𝑤q
time while supporting 𝑂p1q-delay enumeration.
Proof. Maintaining any bag of relations requires Ωp𝑁𝑤q time,
and it needs 𝑂p𝑁𝑤q space to store all query results in the bag.
5The definition of width depends on the algorithm used for maintaining query results
inside each bag. If adopting the standard change propagation framework, the width is
defined as the maximum width over all bags, where the width of a bag is the optimal
integral edge covering number of the corresponding subquery derived for this bag.
After maintaining each bag of relations, the algorithms proposed
in Section 4 can use to maintain between each bag, which takes
𝑂p|𝐷|q time for maintenance. Noted that current database size |𝐷|
is bounded by the largest bag size, which will be 𝑁𝑤, makes the
total maintenance time to Ωp𝑁𝑤q and space cost to 𝑂p𝑁𝑤q.
□
The following lemma can be easily derived from the above theo-
rem.
Lemma 7.2. For the “dumbbell” query, there is an index of 𝑂p𝑁1.5q
size that can be updated in 𝑂p𝑁q time per tuple update, while sup-
porting 𝑂p1q-delay enumeration.
7.2
Selection, union, and set difference
The query plan in Section 4.1 works for CQs with joins and projec-
tions, but it can be equipped with other operators easily.
‚ If there is a selection 𝜎𝜙on an input relation 𝑅𝑒where 𝜙is a
predicate on 𝑒, then for an update with tuple 𝑡P 𝑅𝑒, we simply
check if 𝜙p𝑡q is true, and discard this update if not. This only
adds 𝑂p1q time to the update cost.
‚ For the union of CQs 𝑄“ 𝑄1 Y ¨ ¨ ¨ Y𝑄𝑘, we just maintain each
𝑄𝑖separately. Full enumeration can be supported with 𝑂p1q
delay using the technique in [10]. We note that [10] assumes that
the data structure on each 𝑄𝑖p𝐷q can check if 𝑡P 𝑄p𝐷𝑖q in 𝑂p1q
time for any given 𝑡, which is indeed supported by our query
plan. For delta enumeration, we can use the same technique to
enumerate Δ𝑄1p𝐷q Y ¨ ¨ ¨ Y Δ𝑄𝑘p𝐷q. However, this is not the
same as Δp𝑄1 Y ¨ ¨ ¨ Y 𝑄𝑘q, and we need to check, say, if some
new result 𝑡P Δp𝑄1q already exists in 𝑄2p𝐷q. Thus, while the
technique of [10] is still correct for delta enumeration, the delay
is not bounded by a constant. How to support 𝑂p1q-delay delta
enumeration for UCQs remains an interesting open problem.
‚ For a query like 𝑄“ 𝑄1 ´ 𝑄2, we can as above maintain 𝑄1
and 𝑄2 separately. For enumeration, we enumerate every 𝑡P
𝑄1p𝐷q and check if 𝑡P 𝑄2p𝐷q, although this does not guarantee
constant delay. In fact, even in the static case, it is an open
question whether 𝑄1p𝐷q ´ 𝑄2p𝐷q can be enumerated in 𝑂p1q
delay after linear-time preprocessing where 𝑄1 and 𝑄2 are both
free-connex.
11

---

7.3
Aggregations
Standard relational algebra can be extended to support aggregations,
and we adopt the following formalism [1, 23]. Let p𝑆, ‘, bq be a
commutative ring6. Every tuple 𝑡P 𝑅𝑒has an annotation 𝑤p𝑡q P 𝑆.
For a full CQ 𝑄in the form of p1q, the annotation for any join
result 𝑡P 𝑄p𝐷q is defined as 𝑤p𝑡q :“ b
𝑒P𝑄𝑤p𝑡r𝑒sq. For a non-full
query 𝜋y𝑄, the projection becomes GROUP BY y, and the annotation
for each result 𝑡P 𝜋y𝑄p𝐷q (i.e., the aggregate of each group) is
𝑤p𝑡q :“
‘
𝑡1P𝑄p𝐷q:𝜋y𝑡1“𝑡
𝑤p𝑡1q.
Our new change propagation framework can be extended to
support aggregations easily. For any relation 𝑒, let 𝑤p𝑡q be the an-
notation for tuple 𝑡P 𝑅𝑒, 𝑤𝑠p𝑡q be the annotation for 𝑡P 𝑉𝑠p𝑅𝑒q
and 𝑤𝑝p𝑡q be the annotation for 𝑡P 𝑉𝑝p𝑅𝑒q. Following the defini-
tions of semi-join view 𝑉𝑠and projection view 𝑉𝑝(see Section 4),
the annotation of 𝑡P 𝑉𝑠p𝑅𝑒q is defined as
𝑤𝑠p𝑡q :“
ˆ
b
𝑒1PC𝑒:𝑒1REcon
𝑤𝑝p𝜋keyp𝑒1q𝑡q
˙
b 𝑤p𝑡q.
(10)
The annotation of 𝑡P 𝑉𝑝p𝑅𝑒q is defined as
𝑤𝑝p𝑡q :“
‘
𝑡1P𝑉𝑠p𝑅𝑒q:𝜋keyp𝑒q𝑡1“𝑡
𝑤𝑠p𝑡1q.
(11)
To simplify the enumeration process, we define an additional
view 𝑉𝑎p𝑅𝑒q “ 𝜋𝑒Xy𝑉𝑠p𝑅𝑒q for each node 𝑒P Econ, where the
annotation for any tuple 𝑡P 𝑉𝑎p𝑅𝑒q is defined as
𝑤𝑎p𝑡q :“
‘
𝑡1P𝑉𝑠p𝑅𝑒q:𝜋𝑒Xy𝑡1“𝑡
𝑤𝑠p𝑡1q.
(12)
Moreover, if y “ H, we maintain a special annotation 𝑤𝑎p𝑟q on
top of the root 𝑟:
𝑤𝑎p𝑟q :“
‘
𝑡P𝑉𝑠p𝑅𝑟q
𝑤𝑠p𝑡q.
(13)
Update. We store these annotations alongside their counters in
the query plan. Then, the change propagation and enumeration
procedures should be modified according to the formulas above.
More precisely, whenever the counter of a tuple is updated, we also
update its annotation according to (10), (11), (12) and (13).
Enumeration. We distinguish two cases for enumeration. If y ‰
H, we compute the annotation 𝑤p𝑡q for each query result 𝑡P 𝑄as:
𝑤p𝑡q :“
b
𝑒PEcon
𝑤𝑎p𝜋𝑒Xy𝑡q.
(14)
within 𝑂p1q time, as long as 𝑉𝑎p¨q is well maintained for each node
𝑒P Econ. If y “ H, we simply return 𝑤𝑎p𝑟q.
Lemma 7.3. If y “ H, 𝑤𝑎p𝑟q is the final aggregation.
Lemma 7.4. If y ‰ H, (14) is the annotation of query result 𝑡P 𝑄.
Below, we prove the correctness via Lemma 7.3 and Lemma 7.4.
Given a free-connex join tree T, we define non-connex subtree for
node 𝑒as X𝑒, which is the largest subtree of T rooted at 𝑒such that
pX𝑒´t𝑒uqX Econ “ H. If 𝑒R Econ, C𝑒Ď X𝑒. It is straightforward
to see, for any pair of distinct nodes 𝑒,𝑒1 P Econ, X𝑒and X𝑒1 must
be node-disjoint. We further define Q𝑓p𝑒,𝑡q be the set of join results
1𝑒1PX𝑒𝑒1, such that for any 𝑡𝑖P Q𝑓p𝑒,𝑡q, 𝜋𝑒𝑡𝑖“ 𝑡.
6In the static case, p𝑆, ‘, bq is only required to be a semi-ring, but we need additive
inverses to support deletions.
Lemma 7.5. Given a free-connex query 𝑄with free-connex join
tree T, and an arbitrary node 𝑒R Econ, then for any tuple 𝑡P 𝑉𝑠p𝑅𝑒q
𝑤𝑠p𝑡q :“ ‘𝑡𝑖PQ𝑓p𝑒,𝑡q𝑤p𝑡𝑖q.
Proof of Lemma 7.5. We can prove it by induction on the size
of X𝑒. It trivially holds when X𝑒contains only 𝑒since there is only
one join result 𝑡with 𝑤𝑠p𝑡q “ 𝑤p𝑡q. In general case, we assume
that it holds for every child node of 𝑒. Then,
𝑤𝑠p𝑡q “ 𝑤p𝑡q b
˜
â
𝑒1PC𝑒
´
𝑤𝑝p𝜋keyp𝑒1q𝑡
¯¸
by (10)
“ 𝑤p𝑡q b
¨
˝ â
𝑒1PC𝑒
¨
˝
à
𝑡𝑗PQ𝑓p𝑒1,𝜋keyp𝑒1q𝑡q
𝑤𝑠p𝑡𝑗q
˛
‚
˛
‚
by (11),
The join between any pair of child nodes in C𝑒can be degenerated
to Cartesian product, because for any 𝑒1,𝑒2 P C𝑒, with any 𝑡1 P
𝜋𝑒1Q𝑓p𝑒,𝑡q and 𝑡2 P 𝜋𝑒2Q𝑓p𝑒,𝑡q, either 𝑒1 X𝑒2 “ H, or 𝑒1 X𝑒2 Ď 𝑒
and 𝜋𝑒1X𝑒2𝑡1 “ 𝜋𝑒1X𝑒2𝑡2 “ 𝜋𝑒1X𝑒2𝑡. In either case,
Q𝑓p𝑒,𝑡q “𝑡1 pˆ𝑒1PC𝑒Q𝑓p𝑒1, 𝜋keyp𝑒1q𝑡qq.
We further decompose 𝑡𝑖P Q𝑓p𝑒,𝑡q as 𝑡𝑖:“1𝑒1PX𝑒p𝜋𝑒1𝑡𝑖q, then
‘𝑡𝑖PQ𝑓p𝑒,𝑡q𝑤p𝑡𝑖q “ ‘𝑡𝑖PQ𝑓p𝑒,𝑡q
`
b𝑒1PX𝑒𝑤p𝜋𝑒1𝑡𝑖q
˘
Together with 𝑤𝑠p𝑡1q :“ ‘𝑡1
𝑖PQ𝑓p𝑒,𝑡q𝑤p𝑡1
𝑖q for every 𝑒1 P C𝑒, we
can further rewrite 𝑤𝑠p𝑡q as
“ 𝑤p𝑡q b
¨
˝ â
𝑒1PC𝑒
¨
˝
à
𝑡𝑗PQ𝑓p𝑒1,𝜋keyp𝑒1q𝑡q
𝑤𝑠p𝑡𝑗q
˛
‚
˛
‚
“ 𝑤p𝑡q b
¨
˝ â
𝑒1PC𝑒
¨
˝
à
𝑡𝑗PQ𝑓p𝑒1,𝜋keyp𝑒1q𝑡q
¨
˝ â
𝑒2PX𝑒1
𝑤p𝜋𝑒2𝑡𝑗q
˛
‚
˛
‚
˛
‚
“ 𝑤p𝑡q b
¨
˝
à
𝑡𝑖PQ𝑓p𝑒,𝑡q
¨
˝
â
𝑒1PX𝑒´t𝑒u
𝑤p𝜋𝑒1𝑡𝑖q
˛
‚
˛
‚
“
¨
˝
à
𝑡𝑖PQ𝑓p𝑒,𝑡q
¨
˝𝑤p𝑡q ˆ
â
𝑒1PX𝑒´t𝑒u
𝑤p𝜋𝑒1𝑡𝑖q
˛
‚
˛
‚“
à
𝑡𝑖PQ𝑓p𝑒,𝑡q
𝑤p𝑡𝑖q
which completes the proof.
□
Hence, if y “ H, X𝑟“ T. The correctness of Lemma 7.3 follows
the correctness of Lemma 7.5 on 𝑒“ 𝑟.
Lemma 7.6. Given a free-connex query 𝑄with free-connex join
tree T, and an arbitrary node 𝑒P Econ, then for any 𝑡P 𝑉𝑠p𝑅𝑒q
𝑤𝑠p𝑡q :“ ‘𝑡𝑖PQ𝑓p𝑒,𝑡q𝑤p𝑡𝑖q.
Proof of Lemma 7.6. Let t𝑒1,𝑒2, ¨ ¨ ¨ ,𝑒𝑘u “ C𝑒X X𝑒. From
Lemma 7.5, we know that for every tuple 𝑡𝑖P 𝑉𝑠p𝑅𝑒𝑖q,
𝑤𝑠p𝑡𝑖q “ ‘𝑡1PQ𝑓p𝑒,𝑡𝑖q𝑤p𝑡1q.
12

---

Given any 𝑡P 𝑉𝑠p𝑅𝑒q, we can rewrite 𝑤𝑠p𝑡q as follow:
“ 𝑤p𝑡q b
˜
â
𝑒1PC𝑒XX𝑒
´
𝑤𝑝p𝜋keyp𝑒1q𝑡
¯¸
“ 𝑤p𝑡q b
¨
˝
â
𝑒1PC𝑒XX𝑒
¨
˝
à
𝑡𝑗PQ𝑓p𝑒1,𝜋keyp𝑒1q𝑡q
𝑤𝑠p𝑡𝑗q
˛
‚
˛
‚
“ 𝑤p𝑡q b
¨
˝
â
𝑒1PC𝑒XX𝑒
¨
˝
à
𝑡𝑗PQ𝑓p𝑒1,𝜋keyp𝑒1q𝑡q
¨
˝ â
𝑒2PX𝑒1
𝑤p𝜋𝑒2𝑡𝑗q
˛
‚
˛
‚
˛
‚
“ 𝑤p𝑡q b
¨
˝
à
𝑡𝑖PQ𝑓p𝑒,𝑡q
¨
˝
â
𝑒1PX𝑒´t𝑒u
𝑤p𝜋𝑒1𝑡𝑖q
˛
‚
˛
‚
“
¨
˝
à
𝑡𝑖PQ𝑓p𝑒,𝑡q
¨
˝𝑤p𝑡q ˆ
â
𝑒1PX𝑒´t𝑒u
𝑤p𝜋𝑒1𝑡𝑖q
˛
‚
˛
‚“
à
𝑡𝑖PQ𝑓p𝑒,𝑡q
𝑤p𝑡𝑖q
□
Proof of Lemma 7.4. Give any query result 𝑡P Q and full join
results 𝑡1,𝑡2, ¨ ¨ ¨ ,𝑡ℓsuch that 𝜋y𝑡𝑖“ 𝑡for any 𝑖P rℓs. From the
definition of annotation,
𝑤p𝑡q :“ 𝑤p𝑡1q ‘ 𝑤p𝑡2q ‘ ¨ ¨ ¨ ‘ 𝑤p𝑡ℓq.
(15)
We start from the case where T “ Econ. In this case, for any
𝑒P Econ, we have 𝑤𝑠p𝑡q “ 𝑤p𝑡q for every tuple 𝑡P 𝑉𝑠p𝑅𝑒q. This
way, we can rewrite (15) as
𝑤p𝑡q :“
â
𝑒PE
¨
˝ à
𝑖Prℓs
𝑤p𝜋𝑒𝑡𝑖q
˛
‚,
(16)
and for any 𝑖P rℓs,
à
𝑖Prℓs
𝑤p𝜋𝑒𝑡𝑖q “ 𝑤𝑎p𝜋yX𝑒𝑡q
based on the definition. By replacing all terms, we can obtain equa-
tion (14).
On the other hand, if Econ Ĺ T, we note that T “ Z𝑒PEconX𝑒,
where ‘ denotes the disjoint union. Consider any query result 𝑡of
𝑄. This way, we have
𝑤p𝑡q
“ À
𝑖Prℓs 𝑤p𝑡𝑖q
“ À
𝑖Prℓs
´Â
𝑒PEcon
`Â
𝑒1PX𝑒𝑤p𝜋𝑒1𝑡𝑖q
˘¯
“ Â
𝑒PEcon
´À
𝑡𝑗PQ𝑓p𝑒,𝜋keyp𝑒q𝑡q 𝑤p𝑡𝑗q
¯
“ Â
𝑒PEcon
´À
𝑡𝑘P𝑉𝑠p𝑅𝑒q:𝜋𝑒X𝑦𝑡𝑘“𝜋𝑒X𝑦𝑡𝑤𝑠p𝑡𝑘q
¯
“ Â
𝑒PEcon
`
𝑤𝑎p𝜋𝑒X𝑦𝑡q
˘
which completes the whole proof.
□
8
EXPERIMENTS
8.1
Setup
Prototype implementation. We have implemented our algo-
rithms and built a system prototype called CROWN (Change
pROpagation Without joiNs) on top of Flink DataStream API. All
of our algorithms are implemented as DataStream functions, which
take as input an update stream. Each tuple in the update stream
CROWN
Flink
DBToaster
DBToaster
Trill
Spark
Distributed
✓
✓
✓
Full
✓
✓
✓
✓
enumeration
Delta
✓
✓
enumeration
Updates
Arbitrary
FIFO
Arbitrary
Batch
Arbitrary
Internal
This
Standard
HIVM
HIVM
Standard
paper
change
change
propagation
propagation
Table 1: Comparison of different query processing engines.
is associated with a flag indicating whether the update is an inser-
tion or deletion, as well as the name of the updated relation. After
processing an update, the DataStream function outputs the deltas
triggered by this update. Enumeration of full query results can be
invoked upon the user’s request. Implementing the prototype over
Flink allows us to inherit all the benefits of Flink, such as fault-
tolerance and the ability to work with a variety of data sources and
sinks. To dispatch tuples in a load-balanced fashion, we borrow a
similar idea from massively parallel algorithms, such as HyperCube
[2, 6, 36].
We have evaluated our algorithms in both centralized and dis-
tributed settings. The centralized version runs on a single machine
with a single thread, where we disable certain Flink features such
as false tolerance, serialization, and dispatching. This is for a fair
comparison with other centralized systems (DBToaster and Trill)
that do not support these features. The distributed version has all
these features enabled. It runs over two machines, each equipped
with two Intel Xeon 2.1GHz processors with 48 cores and 416 GB
memory. The machine runs Linux, with Scala 2.11.12, dotnet 5.0.403,
Flink 1.13.5, and Spark 2.2.3. Each query is evaluated 10 times on
each engine and we report the average runtime. We set a 4-hour
time limit for each run.
Query processing engines compared. We compare CROWN
with (1) DBToaster [3], the best HIVM engine that supports multi-
way joins over arbitrary update streams in centralized settings; (2)
DBToaster Spark [31], which can support IVM with batch updates
in a distributed/parallel setting; (3) Trill [11], a continuous query
evaluation system over streaming data using the standard change
propagation framework; and (4) the native Flink SQL engine over
streaming data.
Table 1 summarizes various features of these systems. Note that
only CROWN supports both full enumeration and delta enumera-
tion. Flink can support insertion-only update streams or window
streams, but not arbitrary update streams. We run every experiment
twice: one for delta enumeration, and the other for full enumera-
tion. For full enumeration, we request the full query results after
processing every 10% of the update sequence. As Trill does not
support full enumeration, we ask Trill to report the entire delta
stream for full enumeration.
Queries and updates. We evaluate all systems over two classes
of queries. The first class contains graph pattern queries from the
benchmark by Nguyen et al. [30], over the SNAP dataset (Stanford
Network Analysis Project) [28]. Such a benchmark evaluates the
performance of each system for join queries over static data, and
13

---

𝐴
𝐵
𝐶
𝐷
𝐺1
𝐺2
𝐺3
(a) 3-Hop Query
𝐴
𝐵
𝐶
𝐷
𝐺1
𝐺2
𝐺3
(b) 2-Comb Query
𝐴
𝐵
𝐶
𝐷
𝐸
𝐺1
𝐺2
𝐺4
𝐺3
(c) 4-Hop Query, SNB Q2
𝐵
𝐶
𝐴
𝐷
𝐸
𝐺1
𝐺2
𝐺4
𝐺3
(d) Star Query
𝑖𝑑2
𝑖𝑑1
𝑖𝑑3
𝑀𝑖𝑑
𝑇𝑖𝑑
𝐾1
𝐾2
𝑀
𝑀𝑇
𝑇
(e) SNB Q3
𝑖𝑑2
𝑖𝑑1
𝑀𝑖𝑑
𝑇𝑖𝑑
𝑛𝑎𝑚𝑒
𝐾
𝑀
𝑇
𝑀𝑇
(f) SNB Q4
Figure 6: The relational hypergraphs of queries. The solid dots are output attributes for join-project and aggregation queries.
1e+00
1e+01
1e+02
1e+03
1e+04
1e+05
3-Hop
4-Hop
2-Comb
SNB Q1
SNB Q2
SNB Q3
dumbbell
3-Hop
4-Hop
dumbbell
Star
SNB Q4
Processing Time (Sec)
 
CROWN
Flink
DBToaster CPP
DBToaster Spark
CROWN Delta
Trill
Aggregate Queries
Join-Project Queries
Full Join Queries
Figure 7: Processing times of CROWN, Flink, DBToaster, and Trill
1e-02
1e-01
1e+00
0.3
1
3
10
Avg. Processing Time (ms)
Scale Factor
CROWN
Flink
DBToaster
Trill
(a) SNB Q1
1e-02
1e-01
1e+00
1e+01
0.3
1
3
10
Avg. Processing Time (ms)
Scale Factor
CROWN
DBToaster
Trill
(b) SNB Q2
1e-03
1e-02
1e-01
1e+00
1e+01
0.3
1
3
10
Avg. Processing Time (ms)
Scale Factor
CROWN
DBToaster
Trill
(c) SNB Q4
Figure 8: Average Processing Time v.s. Scale Factor
1e+00
1e+01
1e+02
1e+03
1e+04
1
2
4
10
20
Processing Time (Sec)
λ
Epinion
Google
Bitcoin
BerkStan
Figure 9: Runtime v.s. enclosureness 𝜆.
1e+01
1e+02
1e+03
1e+04
1
2
4
8
16
32
Processing Time (Sec)
Parallelism
CROWN 4-Hop
CROWN SNB Q3
Flink 4-Hop
DBToaster SNB Q3
Figure 10: Runtime v.s. parallelism 𝑝.
1e+01
1e+02
1e+03
1e+04
25%
50%
75%
Latency (ms)
Percentage of stream being processed
CROWN
Trill
Figure 11: Average latency.
we modify it to adapt to the dynamic scenario. We test all acyclic
queries from the benchmark, such as hop (path) queries, star queries
and comb queries. We also test the dumbbell query, which is a
variant of the lollipop query. The detailed query definition is given
in the Appendix D and one example of the 3-Hop query is given
below, where we use a filter over to control the output size.
SELECT G1.src as A, G2.src as B, G3.src as C, G3.dst as D
FROM G G1, G G2, G G3
WHERE G1.dst = G2.src AND G2.dst = G3.src
AND FILTER OVER (G3.dst)
The second class includes more complex analytical queries over
the LDBC Social Network Benchmark (LDBC-SNB) [14], which
accesses the neighborhood of a given node in the graph with con-
tinuous updates. The following shows one example, which finds
the number of distinct messages associated with a particular tag
ID, while satisfying the filter conditions:
SELECT t_name, t_tagid, COUNT(DISTINCT m_messageid)
FROM tag, message, message_tag, knows
WHERE m_messageid = mt_messageid AND mt_tagid = t_tagid
AND m_creatorid = k_person2id AND m_c_replyof IS NULL
AND FILTER OVER (k_person1id)
GROUP BY t_name, t_tag_ids
Figure 6 shows the join hypergraphs of all queries. Except for
2-Comb, SNB Q3 and Q4, they have a height-2 free-connex join tree.
The star query (figure 6(d)) has a height-1 free-connex join tree,
14

---

so it is q-hierarchical. The 4-Hop query (figure 6(c)) and SNB Q4
query (figure 6(f)) have the same hypergraph structure but different
output attributes, and the 4-Hop query has a height-2 free-connex
join trees while SNB Q4 query does not.
We create FIFO streams with a parameter 𝑤. For graph queries,
we assign a distinct integer 𝑡𝑒to each edge 𝑒in the graph, where
𝑒has its lifespan r𝑡𝑒,𝑡𝑒` 𝑤s. For LDBC-SNB queries, each tuple 𝑡
in the benchmark already has an insertion timestamp 𝑡`, and we
set its deletion time as 𝑤days after its insertion, i.e., 𝑡´ “ 𝑡` ` 𝑤.
Note that the sliding window for graph queries is count-based, i.e.,
the window always contains the same number of tuples. On the
other hand, the window for LDBC-SNB queries is time-based, so
the number of tuples in a window fluctuates over time.
8.2
Experiment Results
Runtime. Figure 7 shows the total runtime of evaluating each
graph query over a mid-sized graph Epinions and each SNB query
in the centralized setting. The graph contains approximately 500K
edges and 76K vertices, as well as 3.7B 3-Hop paths and 378B 4-Hop
paths. On the other hand, we use the default scale factor of 1 for
all SNB queries. Under the scale factor, the total size of raw data is
1.5𝐺𝐵, and the largest relation contains 15 attributes. We set a filter
condition that only keeps 10% of the designated endpoints for all
queries. A missing bar in the figure indicates that the corresponding
system did not finish within the 4-hour limit or aborted with an
error (mostly out-of-memory errors and garbage collection timeout).
Only CROWN can finish all queries successfully. Trill only handles
a few graph queries. One possible explanation is that graph queries
tend to generate a large number of deltas. On the other hand, Flink
ran out of memory when evaluating SNB Q2, Q3, and Q4. For
those queries where the systems can finish, we see that CROWN
provides a speedup from 2x to 67x compared with Flink, 1.8x to
234x compared with DBToaster, and 2.7x to 523x compared with
Trill. Moreover, in handling join-project queries, CROWN requires
much less time than handling the corresponding full join queries,
while Flink requires more time. In addition, CROWN performs well
for both full and delta enumeration, and different modes of output
do not affect the overall performance of CROWN.
Enclosureness. To test the influences of enclosureness, we create
multiple update sequences with different 𝜆, over different graphs
from the SNAP dataset. We disable the output to see how the update
cost would change with different 𝜆. The experiment results are
shown in Figure 9. From the results, we can see the maintenance
cost of CROWN increases almost linear as 𝜆increases.
Distributed processing. To compare CROWN with DBToaster
Spark and Flink in a distributed setting, we built a small cluster
with 32 task slots, and tested 4-Hop as well as SNB Q3 query, on
which DBToaster and Flink cannot finish in a centralized setting.
Figure 10 shows the results; missing data points or lines indicate the
system cannot finish within the time limit. Although we adopt the
HyperCube algorithm to dispatch all tuples, CROWN can still obtain
linear speedup with 𝑝ă 16, where 𝑝is the number of workers.
When more workers are available, the margin gain becomes smaller.
This is as expected, since (1) speedup becomes sublinear when
adding more workers implied by HyperCube; (2) the processing
time is already short, causing the system’s overhead to dominate
the entire runtime. For all finished data points, CROWN can provide
a speedup from 45x to 324x.
As Flink and DBToaster cannot finish all experiments with 128GB
memory, so we increase the memory usage for these two systems
to 500GB, where these two systems still only complete a tiny por-
tion of the experiments. On the other hand, CROWN can finish
all experiments with only 128GB of memory. If we further limit
the memory usage of CROWN to 16GB, i.e., 500MB per worker,
CROWN still works well without much change in its performance.
Latency. Finally, we tested the latency of delta enumeration, i.e.,
the time between an update being received and its deltas being out-
putted. Figure 11 shows the result. The average latency of CROWN
is less than 90ms, while that of Trill is more than 6s. In addition,
the average latency is stable for CROWN, but it keeps growing for
Trill, making it infeasible to process streams for long periods.
1e+01
1e+02
1e+03
1e+04
0.1%
0.5%
1%
5%
10%
20%
50% 75% 1
1e+05
1e+06
1e+07
1e+08
1e+09
Processing Time (Sec)
Number of Results
Percentage of Input Size Compares with no Filter Condition
CROWN
Flink
DBToaster CPP
DBToaster Spark
Input
Output
Intermediate Join
(a) 3-Hop query
1e+01
1e+02
1e+03
1e+04
1e+05
0.1%
0.5%
1%
5%
10%
20%
50% 75% 1
1e+04
1e+05
1e+06
1e+07
1e+08
Processing Time (Sec)
Number of Results
Percentage of Input Size Compares with no Filter Condition
(b) 4-Hop query
Figure 12: Runtime v.s. selectivity
Scalability. To test the scalability of different platforms, we change
the scale factor of the SNB benchmark and compare the average
update cost between different platforms. The experiment results
are shown in Figure 8. The results show that the average processing
time of CROWN is stable under different data sizes. In contrast, the
data size will affect the average processing time of other platforms,
suggesting CROWN has better scalability than the competitors.
Selectivity. Figure 12(a) shows the runtime when varying selectiv-
ity of join conditions. For standard change propagation and HIVM,
the maintenance cost depends not only on the input and output
size, but also on the size of intermediate views. For the 3-Hop
query 𝐺1p𝐴, 𝐵q 1 𝐺2p𝐵,𝐶q 1 𝐺3p𝐶, 𝐷q for 𝐺1 “ 𝐺2 “ 𝐺and
𝐺3 “ Filterp𝐺q, the maintenance cost will be bounded by the size
of the view 𝐺1 1 𝐺2 even when 𝐺3 is empty. In the meantime,
15

---

the maintenance cost of CROWN only depends on the input and
output size. To better show such a property, we adjust the filter
condition in the 3-Hop query, which only changes |𝐺3| instead of
|𝐺1 1 𝐺2|. Trill is omitted here as it exceeded the 4-hour limit for
all data points except for the first one. When |𝐺3| ě 0.5%|𝐺|, the
output size exceeds the input size; and when |𝐺3| ě 20%|𝐺|, the
output size exceeds the intermediate join size |𝐺1 1 𝐺2|. From the
results, we can see the runtime of CROWN scales almost linearly as
|𝐺|`|𝑄|, which is as expected since the update sequence has 𝜆“ 1.
On the other hand, the runtime of the DBToaster and Flink scales
proportionally to |𝐺1 1 𝐺2|`|𝑄|, which leads to poor performance
when |𝐺3| ď 20%|𝐺|. A larger gap can be observed in Figure 12(b)
when evaluating the 4-Hop query with projection, where the inter-
mediate join size exceeds the size of the query results, even without
any filter conditions. The runtime of Flink and DBToaster on the
4-Hop query exceeds the 3-Hop query, even with a small output
size. Meanwhile, the runtime of CROWN is much smaller, which
only depends on the input and output size.
REFERENCES
[1] Mahmoud Abo Khamis, Hung Q Ngo, and Atri Rudra. 2016. FAQ: questions asked
frequently. In Proceedings of the 35th ACM SIGMOD-SIGACT-SIGAI Symposium
on Principles of Database Systems. 13–28.
[2] Foto N. Afrati and Jeffrey D. Ullman. 2011. Optimizing Multiway Joins in a Map-
Reduce Environment. IEEE Transactions on Knowledge and Data Engineering 23,
9 (2011), 1282–1298.
[3] Yanif Ahmad, Oliver Kennedy, Christoph Koch, and Milos Nikolic. 2012.
DBToaster: Higher-order delta processing for dynamic, frequently fresh views.
Proceedings of the VLDB Endowment 5, 10 (2012), 968–979.
[4] Albert Atserias, Martin Grohe, and Dániel Marx. 2013. Size bounds and query
plans for relational joins. SIAM J. Comput. 42, 4 (2013), 1737–1767.
[5] Guillaume Bagan, Arnaud Durand, and Etienne Grandjean. 2007. On Acyclic
Conjunctive Queries and Constant Delay Enumeration. In Computer Science
Logic. Springer Berlin Heidelberg, Berlin, Heidelberg, 208–222.
[6] Paul Beame, Paraschos Koutris, and Dan Suciu. 2017. Communication Steps
for Parallel Query Processing. J. ACM 64, 6, Article 40 (oct 2017), 58 pages.
https://doi.org/10.1145/3125644
[7] C. Beeri, R. Fagin, D. Maier, and M. Yannakakis. 1983. On the desirability of
acyclic database schemes. JACM 30, 3 (1983), 479–513.
[8] Christoph Berkholz, Jens Keppeler, and Nicole Schweikardt. 2017. Answering
Conjunctive Queries under Updates. In Proceedings of the 36th ACM SIGMOD-
SIGACT-SIGAI Symposium on Principles of Database Systems (Chicago, Illinois,
USA) (PODS ’17). Association for Computing Machinery, New York, NY, USA,
303–318. https://doi.org/10.1145/3034786.3034789
[9] Paris Carbone, Asterios Katsifodimos, Stephan Ewen, Volker Markl, Seif Haridi,
and Kostas Tzoumas. 2015. Apache Flink: Stream and Batch Processing in a
Single Engine. IEEE Data Engineering Bulletin 38, 4 (2015), 28–38.
[10] Nofar Carmeli and Markus Kröll. 2019. On the Enumeration Complexity of
Unions of Conjunctive Queries. In Proceedings of the 38th ACM SIGMOD-SIGACT-
SIGAI Symposium on Principles of Database Systems. ACM, 134–148.
[11] Badrish Chandramouli, Jonathan Goldstein, Mike Barnett, Robert DeLine, Danyel
Fisher, John C Platt, James F Terwilliger, and John Wernsing. 2014. Trill: A high-
performance incremental query processor for diverse analytics. Proceedings of
the VLDB Endowment 8, 4 (2014), 401–412.
[12] Rada Chirkova and Jun Yang. 2012. Materialized views. Foundations and Trends®
in Databases 4, 4 (2012), 295–405.
[13] Mohammed Elseidy, Abdallah Elguindy, Aleksandar Vitorovic, and Christoph
Koch. 2014. Scalable and Adaptive Online Joins. Proc. VLDB Endow. 7, 6 (feb
2014), 441–452. https://doi.org/10.14778/2732279.2732281
[14] Orri Erling, Alex Averbuch, Josep Larriba-Pey, Hassan Chafi, Andrey Gubichev,
Arnau Prat, Minh-Duc Pham, and Peter Boncz. 2015. The LDBC Social Net-
work Benchmark: Interactive Workload. In Proceedings of the 2015 ACM SIGMOD
International Conference on Management of Data (Melbourne, Victoria, Aus-
tralia) (SIGMOD ’15). Association for Computing Machinery, New York, NY, USA,
619–630. https://doi.org/10.1145/2723372.2742786
[15] R. Fagin. 1983. Degrees of acyclicity for hypergraphs and relational database
schemes. JACM 30, 3 (1983), 514–550.
[16] Buğra Gedik, Rajesh R Bordawekar, and Philip S Yu. 2009. CellJoin: a parallel
stream join operator for the cell processor. The VLDB journal 18, 2 (2009), 501–
519.
[17] Georg Gottlob, Nicola Leone, and Francesco Scarcello. 2002. Hypertree decom-
positions and tractable queries. J. Comput. System Sci. 64, 3 (2002), 579–627.
[18] Timothy Griffin and Bharat Kumar. 1998. Algebraic Change Propagation for
Semijoin and Outerjoin Queries. SIGMOD Rec. 27, 3 (Sept. 1998), 22–27. https:
//doi.org/10.1145/290593.290597
[19] Monika Henzinger, Sebastian Krinninger, Danupon Nanongkai, and Thatchaphol
Saranurak. 2015. Unifying and Strengthening Hardness for Dynamic Problems via
the Online Matrix-Vector Multiplication Conjecture. In Proceedings of the Forty-
Seventh Annual ACM Symposium on Theory of Computing (Portland, Oregon,
USA) (STOC ’15). Association for Computing Machinery, New York, NY, USA,
21–30. https://doi.org/10.1145/2746539.2746609
[20] Muhammad Idris, Martin Ugarte, and Stijn Vansummeren. 2017. The Dynamic
Yannakakis Algorithm: Compact and Efficient Query Processing Under Updates.
In Proceedings of the 2017 ACM International Conference on Management of Data
(Chicago, Illinois, USA) (SIGMOD ’17). Association for Computing Machinery,
New York, NY, USA, 1259–1274. https://doi.org/10.1145/3035918.3064027
[21] Muhammad Idris, Martín Ugarte, Stijn Vansummeren, Hannes Voigt, and Wolf-
gang Lehner. 2019. Efficient query processing for dynamically changing datasets.
ACM SIGMOD Record 48, 1 (2019), 33–40.
[22] Muhammad Idris, Martín Ugarte, Stijn Vansummeren, Hannes Voigt, and Wolf-
gang Lehner. 2020. General dynamic Yannakakis: conjunctive queries with theta
joins under updates. The VLDB Journal 29, 2 (2020), 619–653.
[23] Manas R. Joglekar, Rohan Puttagunta, and Christopher Ré. 2016. AJAR: Ag-
gregations and Joins over Annotated Relations. In Proceedings of the 35th ACM
SIGMOD-SIGACT-SIGAI Symposium on Principles of Database Systems (San Fran-
cisco, California, USA) (PODS ’16). Association for Computing Machinery, New
York, NY, USA, 91–106. https://doi.org/10.1145/2902251.2902293
[24] Jaewoo Kang, Jeffrey F Naughton, and Stratis D Viglas. 2003. Evaluating window
joins over unbounded streams. In Proceedings 19th International Conference on
Data Engineering (Cat. No. 03CH37405). IEEE, 341–352.
[25] Ahmet Kara, Hung Q. Ngo, Milos Nikolic, Dan Olteanu, and Haozhe Zhang. 2020.
Maintaining Triangle Queries under Updates. ACM Trans. Database Syst. 45, 3,
Article 11 (aug 2020), 46 pages. https://doi.org/10.1145/3396375
[26] Ahmet Kara, Milos Nikolic, Dan Olteanu, and Haozhe Zhang. 2020. Trade-offs
in static and dynamic evaluation of hierarchical queries. In Proceedings of the
39th ACM SIGMOD-SIGACT-SIGAI Symposium on Principles of Database Systems.
375–392.
[27] Ki Yong Lee, Jin Hyun Son, and Myoung Ho Kim. 2001. Efficient Incremental
View Maintenance in Data Warehouses. In Proceedings of the Tenth International
Conference on Information and Knowledge Management (Atlanta, Georgia, USA)
(CIKM ’01). Association for Computing Machinery, New York, NY, USA, 349–356.
https://doi.org/10.1145/502585.502644
[28] Jure Leskovec and Andrej Krevl. 2014. SNAP Datasets: Stanford Large Network
Dataset Collection. http://snap.stanford.edu/data.
[29] Qian Lin, Beng Chin Ooi, Zhengkui Wang, and Cui Yu. 2015. Scalable distributed
stream join processing. In Proceedings of the 2015 ACM SIGMOD International
Conference on Management of Data. 811–825.
[30] Dung Nguyen, Molham Aref, Martin Bravenboer, George Kollias, Hung Q Ngo,
Christopher Ré, and Atri Rudra. 2015. Join processing for graph patterns: An old
dog with new tricks. In Proceedings of the GRADES’15. 1–8.
[31] Milos Nikolic, Mohammad Dashti, and Christoph Koch. 2016. How to win a
hot dog eating contest: Distributed incremental view maintenance with batch
updates. In Proc. ACM SIGMOD International Conference on Management of Data.
ACM, 511–526.
[32] Milos Nikolic and Dan Olteanu. 2018. Incremental view maintenance with triple
lock factorization benefits. In Proc. ACM SIGMOD International Conference on
Management of Data. ACM, 365–380.
[33] Milos Nikolic, Haozhe Zhang, Ahmet Kara, and Dan Olteanu. 2020. F-IVM: learn-
ing over fast-evolving relational data. In Proceedings of the 2020 ACM SIGMOD
International Conference on Management of Data. 2773–2776.
[34] Kenneth A. Ross, Divesh Srivastava, and S. Sudarshan. 1996. Materialized View
Maintenance and Integrity Constraint Checking: Trading Space for Time. In
Proceedings of the 1996 ACM SIGMOD International Conference on Management
of Data (Montreal, Quebec, Canada) (SIGMOD ’96). Association for Computing
Machinery, New York, NY, USA, 447–458. https://doi.org/10.1145/233269.233361
[35] Pratanu Roy, Jens Teubner, and Rainer Gemulla. 2014. Low-latency handshake
join. Proceedings of the VLDB Endowment 7, 9 (2014), 709–720.
[36] Qichen Wang and Ke Yi. 2020. Maintaining Acyclic Foreign-Key Joins under
Updates. In Proceedings of the 2020 ACM SIGMOD International Conference on
Management of Data. 1225–1239.
[37] Mihalis Yannakakis. 1981. Algorithms for acyclic database schemes. In Proc.
International Conference on Very Large Data Bases. 82–94.
16

---

A
MISSING PROOFS IN SECTION 3
Lemma A.1. Given an acyclic CQ Q “ pV, E, yq, it is free-connex
if and only if it has a free-connex join tree T as defined in Section 3.
Proof. If Direction. Suppose there is a free-connex join tree T
as defined in Section 3. We simply add a node 𝑟containing exactly
all output attributes in y as the root of T, and start the following
procedure:
‚ We visit the root in a bottom-up way. For every node 𝑒with
𝑒P Tcon, we remove the edge between 𝑒and its parent, and then
move 𝑒together with the current subtree rooted at 𝑒as a child
of 𝑟. Let T 1 be the resulted tree.
It is obvious that every node in T 1 corresponds to a relation, or a
generalized relation of E Ytyu. Moreover, implied by the definition
of T, for every node 𝑒P Tcon and its parent node 𝑝𝑒, we have
𝑒X 𝑝𝑒Ď y. This way, the connect condition of output attribute
in y is preserved since y Ď 𝑟. Implied by the definition of acyclic
CQs in [20], there is a free-connex join tree for pV, E Y tyu, yq,
hence pV, E Y tyu, yq is also acyclic. Implied by the definition of
free-connex CQs in [5], Q is free-connex.
Only-If Direction. Suppose we are given a free-connex CQ Q “
pV, E, yq. We next show how to construct a free-connex join tree
as defined in Section 3. Let Ey “ t𝑒X y : 𝑒P Eu. We start the
following helper lemma:
Lemma A.2 ([5], Lemma 21). For any free-connex CQ Q “
pV, E, yq, there exists a traditional join tree T 1 for pV, E Y Ey, yq
and a subset of relations Econ Ď E Y Ey such that the corresponding
nodes of Econ form a connex subtree of T 1, i.e., Econ includes the root
of T 1, y “ Ť
𝑒PEcon 𝑒and the subtree is connected.
Let T 1 be such a traditional join tree for pV, E Y Ey, yq rooted
at node 𝑟. Note that 𝑟Ď y. We will transform T 1 into a free-connex
join tree for Q via the following steps:
Step 1: Remove all nodes 𝑒with 𝑒X y “ H. We start with one
observation. For any pair of 𝑒,𝑒1 P E Y Ey, such that 𝑒X y “ H
and 𝑒1 X y ‰ H, 𝑒cannot be an ancestor of 𝑒1 in T 1. Suppose not,
𝑒1 R Econ since 𝑒R Econ. Let 𝑥P 𝑒1 X y be an output attribute in
𝑒1. Implied by the property of Econ, there must exist some node
𝑒2 P Econ with 𝑥P 𝑒2. Moreover, 𝑒2 R T𝑒, implied by the facts
that 𝑒R Econ and Econ forms a connect subtree. Hence, all nodes
lying on the path between 𝑒2 and 𝑒2 (including 𝑒) must contain 𝑥,
implied by the connect property of 𝑥. This contradicts the fact that
𝑥R 𝑒since 𝑒X y “ H.
This way, we remove all relations 𝑒X y “ H from T 1 as follows.
For any relation 𝑒P E with 𝑒Xy “ H and 𝑝𝑒Xy ‰ H, we remove
the subtree root at 𝑒as a whole. From our observation above, all
relations residing in the subtree rooted at 𝑒do not contain any
output attribute. At last, we will put this subtree back as a child
of relation 𝑝𝑒if 𝑝𝑒´ y ‰ H, or as a child of arbitrary relation if
𝑝𝑒´ y “ H.
Step 2: Remove all nodes 𝑒1 P Ey such that 𝑒1 Ĺ 𝑒for some
𝑒P Econ. If there exists a pair of nodes 𝑒P Ey,𝑒1 P Econ such that
𝑒Ĺ 𝑒1, we can remove 𝑒and add each of its children nodes (not
including 𝑒1 if 𝑒1 is a child of 𝑒) as a new child node of 𝑒1. It can be
easily checked that the connect property is preserved. The reduced
Econ is still a valid connex subtree of the updated T 1. After this
step, we assume no pair of nodes 𝑒P Ey,𝑒1 P Econ with 𝑒Ĺ 𝑒1.
Lemma A.3. For any node 𝑒R Econ and its lowest ancestor 𝑒1 P
Econ, 𝑒X y Ď 𝑒1.
Proof. Suppose not, assume an output attribute 𝑥P 𝑒X y ´ 𝑒1.
Implied by the connect property, no other node in T 1 ´T 1
𝑒1 contains
𝑥. Let 𝑒2 be the child of 𝑒1 lying on the path from 𝑒1 to 𝑒. Moreover,
no other node in T 1
𝑒2 except belongs to Econ, since 𝑒1 is the lower
ancestor of 𝑒in Econ. Hence, no node in Econ contains 𝑥, violating
the property of Econ.
□
Lemma A.4. After step 2, Ey Ď Econ.
Proof. Suppose not, assume 𝑒1 P Ey ´ Econ. Let 𝑒P Econ be
the lowest ancestor of 𝑒1. Implied by Lemma A.3, 𝑒1 Ď 𝑒, hence 𝑒1
will be removed in step 2.
□
Step 3: Add a guard for every relation in Ey. Consider any node
𝑒P E ´ Econ and its parent node 𝑝𝑒with 𝑝𝑒Ď y and 𝑝𝑒‰ 𝑒X y.
We remove the subtree rooted at 𝑒and add it as a child node of
𝑒1 P Econ with 𝑒1 “ 𝑒X y if such a node 𝑒1 exists. We next show
that the connect property is preserved. Due to the connect property
of T 1 before transformation, 𝑒1 X 𝑝𝑒1 “ 𝑒1 X 𝑝𝑒1 X y Ď 𝑒, hence
this step preserves the connect property.
Lemma A.5. After step 3, for any node 𝑒1 P Ey, it has a child node
𝑒P E such that 𝑒1 “ 𝑒X y.
Proof. Consider an arbitrary node 𝑒1 P Ey. Note that 𝑒1 P Econ,
implied by Lemma A.4. By contradiction, assume that any node
𝑒P E such that 𝑒1 “ 𝑒X y is not the child of 𝑒1.
If 𝑒1 is an ancestor of 𝑒, let 𝑒2 be the child of 𝑒1 lying on the
path from 𝑒to 𝑒1. There must be 𝑒1 “ 𝑒1 X 𝑒Ď 𝑒2. If 𝑒2 P Econ,
𝑒1 Ď 𝑒2, coming to a contradiction of Step 2. If 𝑒2 R Econ, then
𝑒1 “ 𝑒1 X 𝑒“ 𝑒1 X 𝑒2 “ 𝑒2 X y implied by Lemma A.3, 𝑒2 is such
a child node for 𝑒1, coming to a contradiction.
Otherwise, 𝑒1 “ 𝑒1 X 𝑒Ď 𝑝𝑒1. As 𝑒P Econ, 𝑝𝑒1 P Econ. Together,
𝑒1 Ď 𝑝𝑒1, coming to a contradiction of Step 2.
□
Step 4: Replace nodes with generalized relations. At last,
we start visiting nodes in Ey in a top-down manner. Consider an
arbitrary node 𝑒1. Note that 𝑒1 Ď y. From Lemma A.5, it must have
some child node 𝑒P E with 𝑒X y “ 𝑒1 after Step 3. If 𝑒1 Ď 𝑒
holds for every child node 𝑒of 𝑒1, and 𝑝𝑒1 is a generalized relation
if 𝑝𝑒1 exists, we replace 𝑒1 as a generalized relation r𝑒1s. Otherwise,
we replace 𝑒1 with 𝑒. If 𝑒R Econ, we add it to Econ. For any child
node 𝑒2 P Econ of 𝑒1, which is now a child node of 𝑒, we have
𝑒2X𝑒1 “ 𝑒2X𝑒1 Xy “ 𝑒2X𝑒Ď y. It can be easily checked that the
connect property is preserved and the guard property is established
for every generalized relation. Moreover, the parent node of any
generalized relation if exists is also a generalized relation. Hence,
the above property is preserved.
After these four steps, the resulted tree is a free-connex join tree
with all properties satisfied.
□
17

---

B
MISSING PROOFS IN SECTION 5
Proof of Lemma 5.5. We first prove the “only if" direction. For
any 𝑡P 𝑉𝑙p𝑅𝑒q, there exists a 𝑡1 P 𝑄p𝐷q, such that 𝜋𝑒𝑡1 “ 𝑡. Mean-
while, it indicates that𝑡2 “ 𝜋𝑝𝑒𝑡1 must satisfy𝑡2 P 𝑉𝑙p𝑅𝑝𝑒q, because
𝑡2 P 𝜋𝑝𝑒𝑄p𝐷q. Hence, 𝑡2 can join 𝑡, indicates 𝑡1 𝑉𝑙p𝑅𝑝𝑒q ‰ H.
For the “if" direction. Let 𝑡1 P 𝑉𝑙p𝑅𝑝𝑒q be a tuple that can join
with 𝑡. We divide the join tree T into two subtrees pT𝑒, TzT𝑒q and
divide the output attributes y into two sets py𝑒, yzy𝑒q accordingly.
Because 𝑡1 P 𝑉𝑙p𝑅𝑝𝑒q, 𝜋yzy𝑒𝑄p𝐷˙ 𝑡1q ‰ H and we let 𝑡2 be one
tuple from 𝜋yzy𝑒𝑄p𝐷˙ 𝑡1q. On the other side, since 𝑡P 𝑉𝑠p𝑅𝑒q,
there also exists a tuple 𝑡𝑒in 𝜋y𝑒p1𝑒1PT𝑒𝑅𝑒1q. 𝑡𝑒can join with 𝑡2 as
𝑡can join with 𝑡1 and 𝜋𝑒𝑡𝑒“ 𝑡, 𝜋𝑝𝑒𝑡2 “ 𝑡1. Hence, 𝑡𝑒1 𝑡2 P 𝑄p𝐷q,
indicates that 𝑡P 𝑉𝑙p𝑅𝑒q.
□
Proof of Lemma 5.7. W.l.o.g, we assume that 𝑡is inserted. The
case that 𝑡is deleted follows the same argument.
Direction Ě. We show that each result in 𝑄p𝐷˙ 𝑡1q also appears
in Δ𝑄p𝐷,𝑡q, for every witness tuple 𝑡1 of 𝑡. Wlog, consider a query
result 𝑞P 𝑄p𝐷˙𝑡1q for some witness tuple 𝑡1, where either 𝑡1 P 𝑅𝑒
for 𝑒Ď y or 𝑡1 P 𝜋y𝑅𝑒for 𝑒X y ´ 𝑝𝑒‰ H.
First, 𝑄p𝐷˙ 𝑡1q Ď 𝑄p𝐷` 𝑡q since we have 𝑡1 P Δ
`
𝜋y𝑉𝑠p𝑅𝑒q
˘
and 𝜋keyp𝑒q𝑡1 P 𝑉𝑝p𝑅𝑒q after the insertion of 𝑡. Hence, all results
witnessed by 𝑡1 appear in 𝑄p𝐷` 𝑡q after the insertion of 𝑡, i.e.,
𝑞P 𝑄p𝐷` 𝑡q. We next show 𝑞R 𝑄p𝐷q. Now let’s go back to the
timestamp before the insertion of 𝑡. Implied by the definition of
witness tuple, 𝑡1 R 𝜋y𝑉𝑠p𝑅𝑒q then. We distinguish two more cases.
‚ Case 1: 𝑒Ď y, 𝑞R 𝑄p𝐷q since 𝜋𝑒𝑞“ 𝑡1 but 𝑡1 R 𝜋𝑒𝑄p𝐷q before
the insertion of 𝑡. This further indicates 𝑞R 𝑄.
‚ Case 2: 𝑒´ y ‰ H and 𝑒X y ´ 𝑝𝑒‰ H, 𝑡1 R 𝜋y𝑉𝑠p𝑅𝑒q before
the insertion of 𝑡1. This way, 𝑡1 R 𝜋y𝑄p𝐷q, thus 𝑞R 𝑄.
Combining the analysis above, we have 𝑞P 𝑄p𝐷` 𝑡q, and 𝑞R
𝑄p𝐷q i.e.,𝑞P Δ𝑄p𝐷,𝑡q. So, Ţ
𝑡1:a witness of 𝑡𝑄p𝐷˙𝑡1q Ď Δ𝑄p𝐷˙𝑡q.
Direction Ď. We next show that every result in Δ𝑄p𝐷,𝑡q belongs
to 𝑄p𝐷`𝑡q˙𝑡1 for some witness tuple 𝑡1 of 𝑡. Consider an arbitrary
query result 𝑞P 𝑄p𝐷` 𝑡q ´ 𝑄p𝐷q.
It suffices to show that there exists at least one node 𝑒P T such
that tuple 𝑡1 “ 𝜋𝑒𝑞if 𝑒Ď y, or tuple 𝑡1 P 𝜋y𝑅𝑒with 𝑡1 “ 𝜋𝑒Xy𝑞
if 𝑒X y ´ 𝑝𝑒‰ H, must be a witness. An important observation
is that 𝑡1 now belongs to Δ𝜋y𝑉𝑠p𝑅𝑒q; otherwise, 𝑞P 𝑄p𝐷q, coming
to a contradiction. Now consider the highest node 𝑒1 such that
𝑡1 “ 𝜋𝑒1Xy𝑞and 𝑡1 P Δ
`
𝜋y𝑉𝑠p𝑅𝑒1q
˘
. If 𝑒1 is the root, 𝑡1 must be a
witness of 𝑡, implied by the Definition 5.6. Otherwise, 𝑒1 is not the
root. Consider 𝑡2 “ 𝜋𝑝𝑒1Xy𝑞. As 𝑡2 R Δ𝑉𝑠p𝑅𝑒2q, 𝑡2 must in 𝑉𝑠p𝑅𝑒2q
and 𝑡2 P 𝜋𝑒2𝑄p𝐷q before the insertion of 𝑡, which indicates the
𝜋keyp𝑒1q𝑡1 “ 𝜋keyp𝑒1q𝑡2 P 𝑉𝑝p𝑅𝑒1q, and 𝜋keyp𝑒1q𝑡1 P 𝜋keyp𝑒1q𝑄p𝐷q.
In this way, 𝑡1 is a witness of 𝑡by definition.
Critical Property: Δ𝑄p𝐷,𝑡1q X Δ𝑄p𝐷,𝑡2q “ H holds for any
pair of witness tuples 𝑡1,𝑡2. It remains to show that there is no
duplicate results in Ť
𝑡1:a witness of 𝑡Δ𝑄p𝐷˙ 𝑡1q. By contradiction,
assume that there exists a query result 𝑞with at least two witness
tuples. Wlog, let 𝑡1,𝑡2 be two distinct witness tuples in 𝑞, where
𝑡1 P 𝑅𝑒1 for some 𝑒1 Ď y or 𝑒1 X y ´ 𝑝𝑒1 ‰ H, and some 𝑒2 Ď y or
𝑒2 X y ´ 𝑝𝑒2 ‰ H. First, 𝑒1 ‰ 𝑒2, as 𝑞contains at most one tuple
in each relation. Note that the insertion of 𝑡P 𝑅𝑒can only change
the status of tuples in the ancestors of 𝑒. Without loss of generality,
let 𝑒1 be the ancestor of 𝑒2. Let 𝑒3 be parent node of 𝑒2 (it could be
the case that 𝑒1 “ 𝑒3). Let 𝑡3 “ 𝜋𝑒3Xy𝑞. Implied by the definition of
witness tuples, 𝑡3 P 𝜋y𝑉𝑠p𝑅𝑒3q before the insertion of 𝑡. Implied by
𝑡3 R Δ𝜋y𝑉𝑠p𝑅𝑒3q, 𝑡1 P 𝜋y𝑉𝑠p𝑅𝑒1q before the insertion, contradicting
the fact that 𝑡1 is a witness tuple. This way, each result in Δ𝑄p𝐷,𝑡q
corresponds to one witness tuple, thus there is no duplicates across
the extended query results over different witness tuples.
□
Proof of Lemma 5.9. We first show the correctness of Algo-
rithm 6. Consider an arbitrary witness tuple 𝑡1 P 𝑅𝑒1. Denote the
nodes lying on the path from 𝑒1 to 𝑟as 𝑒1,𝑒2, ¨ ¨ ¨ ,𝑒𝑘p𝑟q sequentially.
We can first expand 𝑄p𝐷˙ 𝑡1q as follows:
𝑡1 1
´
1𝑘
𝑖“1 𝑉𝑟p𝑒𝑖q
¯
1 𝑄T𝑒1 1
´
1𝑘
𝑖“2 𝑄T𝑒𝑖´T𝑒𝑖´1
¯
(17)
where 𝑄T represents the query defined over relations in T. Implied
by the join operator and the properties of free-connex join tree, we
can further rewrite (17) =:
ď
𝑆P𝑡11p1𝑘
𝑖“1𝑉𝑟p𝑒𝑖qq
𝑆1 𝑄T𝑒1 1
´
1𝑘
𝑖“2 𝑄T𝑒𝑖´T𝑒𝑖´1
¯
“
ď
𝑆P𝑡11p1𝑘
𝑖“1𝑉𝑟p𝑒𝑖qq
𝑆ˆ p𝑄T𝑒1 ˙ t𝑆uq ˆ
´
1𝑘
𝑖“2 p𝑄T𝑒𝑖´T𝑒𝑖´1 ˙ t𝑆uq
¯
which is exactly followed by Algorithm 6. Together with Lemma 5.7,
all results of Δ𝑄p𝐷,𝑡q are enumerated without duplication.
We next analyze the time complexity. As all witness tuples can
be stored in a data structure (e.g., a linked list) supporting constant-
delay enumeration, every 𝑡1 (line 1) can be retrieved in 𝑂p1q delay.
It then suffices to show that 𝑄p𝐷˙ 𝑡1q can be enumerated with
𝑂p1q delay for every 𝑡1. Note that subquery 𝑡1 1
´
1𝑘
𝑖“1 𝑉𝑟p𝑒𝑖q
¯
(line 4) can be done in 𝑂p1q delay with our hashing index. For the
remaining subquery 𝑄T𝑒1 ˙ t𝑆u or 𝑄T𝑒𝑖´T𝑒𝑖´1 ˙ t𝑆u, we invoke
the procedure FullEnum (line 6-8) and all query results can be
enumerated with 𝑂p1q delay, proved by Lemma 5.4. Combing those
subqueries in a form of Cartesian product can yield query results
with 𝑂p1q delay, thus completing the whole proof.
□
C
MISSING MATERIALS IN SECTION 6
Proof of Theorem 6.2. Given an instance of OuMv, we encode
the matrix by 𝑅3 and vectors p𝑣𝑖,𝑢𝑖q by 𝑅2 and 𝑅4 separately. We
construct an update sequence 𝑆for 𝑄as follows: (1) we add a tuple
𝑅5p𝑥4q
𝑅4p𝑥3,𝑥4q
𝑅3p𝑥2,𝑥3q
𝑅2p𝑥1,𝑥2q
𝑅1p𝑥1q
(a) T1
𝑅4p𝑥3,𝑥4q
𝑅2p𝑥1,𝑥2q
𝑅3p𝑥2,𝑥3q
𝑅5p𝑥4q
𝑅1p𝑥1q
(b) T2
𝑅4p𝑥3,𝑥4q
𝑅2p𝑥1,𝑥2q
𝑅3p𝑥2,𝑥3q
𝑅5p𝑥4q
𝑅1p𝑥1q
(c) T3
Figure 13: Join trees for 𝑄“ 𝑅1p𝑥1q 1 𝑅2p𝑥1,𝑥2q 1 𝑅3p𝑥2,𝑥3q 1
𝑅4p𝑥3,𝑥3q 1 𝑅5p𝑥4q.
18

---

𝑡“ p𝑖, 𝑗q with lifespan 𝐼p𝑡q “ r´𝑘,𝑘s, for each pair p𝑖, 𝑗q P r𝑛sˆr𝑛s
if 𝑀𝑖𝑗‰ 0; (2) we add a tuple 𝑡“ p𝑖q with lifespan 𝐼p𝑡q “ r𝑖´2𝑘,𝑖s
into 𝑅1 and 𝑅5; (3) for each pair of vectors p𝑣𝑖,𝑢𝑖q, we add a tuple
𝑡“ p𝑖, 𝑣𝑖𝑗q with lifespan 𝐼p𝑡q “ r𝑖,𝑖` 2𝑘s to 𝑅2 if 𝑣𝑖𝑗‰ 0, and add
a tuple 𝑡“ p𝑢𝑖𝑗,𝑖q with lifespan 𝐼p𝑡q “ r𝑖,𝑖` 2𝑘s to 𝑅4 if 𝑢𝑖𝑗‰ 0;
(4) if a query result is enumerated, we output true for 𝑣𝑇
𝑖𝑀𝑢𝑖, and
false otherwise; (5) we repeat (3)-(4) for the next pair p𝑣𝑖`1,𝑢𝑖`1q,
until 𝑛pairs of vectors are all processed. Each tuple in 𝑆has the
same lifespan as 2𝑘, thus it is a FIFO sequence.
We note that in any free-connex join tree T of 𝑄, there always
exists a subtree in which either 𝑅1 ´ 𝑅2 ´ 𝑅3 or 𝑅5 ´ 𝑅4 ´ 𝑅3
is a leaf-to-root path. Wlog, assume 𝑅1 ´ 𝑅2 ´ 𝑅3 is a leaf-to-
root path. First, for each tuple 𝑡P 𝑅1, 𝜆p𝑡q “ 1 as 𝑅1 is a leaf
node. For 𝑡“ p𝑖, 𝑣𝑖𝑗q P 𝑅2, we observe that ˜𝐼p𝑡q “ r𝑖,𝑖s as 𝐼p𝑡q “
r𝑖,𝑖` 2𝑘s and 𝐼p𝑡1q “ r𝑖´ 2𝑘,𝑖s for some tuple 𝑡1 P 𝑅1. But in
this case, 𝜆p𝑡q “ 1 still holds, as there exists no tuple 𝑡1 P 𝑅1 with
˜𝐼p𝑡1q Ď r𝑖,𝑖s. However, for each tuple 𝑡P 𝑅3, 𝜆p𝑡q “ 𝑛as there
exists a tuple 𝑡1 P 𝑅2 such that ˜𝐼p𝑡1q “ r𝑖,𝑖s for every 𝑖P r𝑛s.
Hence, the enclosureness of 𝑆on every free-connex join tree is
𝜆“ 𝑛2¨𝑛`𝑛2¨1
𝑛2
“ 𝑛.
The correctness of this simulation is obvious. This way, if there
is a data structure that can be updated in 𝑂p𝜆1´𝜖q time while sup-
porting 𝑂p𝜆2´𝜖q-delay enumeration for 𝑄over any FIFO sequence,
then the OuMv problem can be solved in 𝑂p𝑛2 ¨𝜆1´𝜖`𝑛¨𝜆2´𝜖q “
𝑂p𝑛3´𝜖q time. Note that the construction above requires a database
of size at least 𝑛2 “ 𝜆2, thus 𝜆ď
a
|𝐷|.
□
Proof of Theorem 6.6. We next turn to the update cost of our
indexes. As mentioned at the beginning of Section 6, the total update
cost of the entire sequence is asymptotically dominated by that of
P-Update, which is further bounded by the number of times all the
counters countr𝑡s can change. The following lemma connects this
quantity with the enclosureness of the update sequence.
Lemma C.1. For any tuple 𝑡, countr𝑡s changes 𝑂p𝜆p𝑡qq times.
Proof. The status change of tuple 𝑡P 𝑅𝑒falls into one of the
following two cases: (1) tuple 𝑡is being inserted or deleted; (2) some
tuple 𝑡1 P 𝑅𝑒1 for 𝑒1 P T𝑒is inserted or deleted, and this update
propagates to 𝑡. Note that tuple 𝑡can be inserted and deleted once
in its lifespan, thus bounded by 𝑂p1q and the cost is reflected in
R-Update. Then, we will focus on the second case.
We start with the case that 𝑒has one child node in T. In this case,
countr𝑡s has its value changed between 0 and 1. Note that if an
insertion changes𝑡from𝑅𝑒{𝑉𝑠p𝑅𝑒q to𝑉𝑠p𝑅𝑒q, subsequent insertions
won’t change the status of 𝑡unless a deletion occurs. Consider a
set of 𝑘disjoint intervals ˜𝐼1, ˜𝐼2, ¨ ¨ ¨ , ˜𝐼𝑘in ordering, such that ˜𝐼𝑗P rI𝑒,
˜𝐼𝑗Ď 𝐼p𝑡q for each 𝑗P r𝑘s, and there exists no additional interval ˜𝐼
such that ˜𝐼Ĺ ˜𝐼𝑗or ˜𝐼1 Ď r˜𝐼`
𝑗, ˜𝐼´
𝑗`1s for any 𝑗P t1, 2, ¨ ¨ ¨ ,𝑘u. Each
of the 𝑘intervals can change the status of 𝑡at most twice, so they
together can change the status of 𝑡at most𝑂p𝑘q times. The effective
lifespan of 𝑡exactly captures such a quantity.
We next consider a case when 𝑒has two child nodes 𝑒1,𝑒2 P
T. Similarly, consider a set of 𝑘disjoint intervals ˜𝐼1, ˜𝐼2, ¨ ¨ ¨ , ˜𝐼𝑘in
ordering, such that ˜𝐼𝑗P rI𝑒, ˜𝐼𝑗Ď 𝐼p𝑡q for each 𝑗P r𝑘s, and there
exists no additional interval ˜𝐼such that ˜𝐼Ĺ ˜𝐼𝑗or ˜𝐼Ď r˜𝐼`
𝑗, ˜𝐼´
𝑗`1s for
any 𝑗P t1, 2, ¨ ¨ ¨ ,𝑘u. We can make the following two observations:
(1) For any ˜𝐼𝑗, countr𝑡s can change at most 2 times within ˜𝐼.
(2) For any two adjacent intervals ˜𝐼𝑗and ˜𝐼𝑗`1, countr𝑡s can change
at most 4 times in their gap.
Together, we can conclude that countr𝑡s can change at most 6 ¨𝑘“
𝑂p𝑘q times when there are two child nodes. We next go into details
of (1) and (2) separately.
For (1), we assume ˜𝐼𝑗P rI𝑒1 without loss of generality. By the
definition of effective lifespan, there cannot be any insertion or
deletion in any node of T𝑒1 within ˜𝐼𝑗. Nevertheless, updates may
still exist within ˜𝐼𝑗on some node of T𝑒2, which might further change
countr𝑡s. We distinguish two more cases. If countr𝑡s changes from
1 to 2, due to an insertion from T𝑒2, a deletion must not exist within
˜𝐼𝑗on any node of T𝑒2, implied by the fact that there exists no ˜𝐼such
that ˜𝐼Ĺ ˜𝐼𝑗. Hence, countr𝑡s can change at most once in ˜𝐼𝑗for this
case. Otherwise, countr𝑡s changes from 2 to 1, after a deletion from
T𝑒2. We then go into the first case and countr𝑡s can change at most
one more time. In total, countr𝑡s can change at most twice.
For (2), it is clear that at the right endpoint of ˜𝐼𝑗and the left
endpoint of ˜𝐼𝑗`1, countr𝑡s can change once as the deletion and
insertion of an effective lifespan. In the meantime, there does not
exist another effective lifespan within their gap, so for any 𝑒𝑖P
t𝑒1,𝑒2u, there exists no deletion on T𝑒𝑖in the gap following an
insertion in T𝑒𝑖. This way, countr𝑡s can change at most four times
(i.e. 2 Ñ 1 Ñ 0 Ñ 1 Ñ 2) within their gap.
At last, we consider the general case when 𝑒has multiple child
nodes in T. In this case, countr𝑡s has its value changed among
0, 1, ¨ ¨ ¨ , 𝑗, where 𝑗is the number of child nodes of 𝑒. By extend-
ing the previous two observations, we conclude that countr𝑡s can
change at most 3𝑗¨𝑘times, where 𝑗can be considered as a constant.
With respect to all possible choices of 𝑘, we observe that
𝑘ď
max
JĎ rI𝑒
@𝐼p𝑡1qPJ,𝐼p𝑡1qĎ𝐼p𝑡q
@𝐼p𝑡2q,𝐼p𝑡3qPJ,𝐼p𝑡2qX𝐼p𝑡3q“H
1 ` |J| “ 𝜆p𝑡q,
thus countr𝑡s can change at most 𝑂p𝜆p𝑡qq times.
□
The time cost of Algorithm 3 is determined by the number of iter-
ations of for-loop (line 2 or 7). One can easily observe that countr𝑡s
will be changed for some tuple 𝑡once in each iteration, therefore
the running time can be bounded by the number of changes to
countr𝑡s over all tuples 𝑡. Now consider an update sequence 𝑆with
enclosureness 𝜆. Implied by Lemma C.1 the total update cost is
𝑂
`ř
𝑡PI 𝜆p𝑡q
˘
, which is 𝑂
´ ř
𝑡PI 𝜆p𝑡q
|I|
¯
“ 𝑂p𝜆q amortized.
Putting everything together, we have completed the proof for
Theorem 6.6.
□
Proof of Lemma 6.8. In [20], it has been proved that a CQ is
q-hierarchical if and only if there is a “simple” generalized join tree,
such that all original relations are leaf nodes of T, and every internal
node 𝑒1, which corresponds to a generalized relation, must have
𝑒1 Ď 𝑒for every its child 𝑒. We note that such a simple generalized
join tree is essentially a height-1 free-connex join tree as defined
in Section 3.
□
Proof of Lemma 6.9. Given a height-2 free-connex join tree T
and consider an arbitrary tuple 𝑡P 𝑅𝑒. If 𝑒is a leaf node, ˜𝐼p𝑡q “
r𝑡`,𝑡´s and 𝜆Tp𝑡q “ 1. If 𝑒is an internal node, ˜𝐼p𝑡q Ď r𝑡`,𝑡´s.
19

---

But here, as the join tree is a height-2 free-connex join tree, every
𝑒’s child node must be a leaf node, hence every tuple 𝑡1 P 𝑅𝑒1 for
𝑒1 P T𝑒has ˜𝐼p𝑡1q “ r𝑡`
1 ,𝑡´
1 s, and there exists no tuple 𝑡2 such that
𝑡` ă 𝑡`
2 and 𝑡´
2 ă 𝑡´. As each tuple 𝑡has 𝜆Tp𝑡q “ 1, by definition,
𝜆Tp𝑆q “ 1.
□
Proof of Lemma 6.10. As there is no deletion for every tuple 𝑡,
˜𝐼p𝑡q “ r𝑡`, `8s. Hence, for every 𝑡, by definition, 𝜆Tp𝑡q “ 1.
□
D
SQL QUERIES
3-Hop Full Join Query.
SELECT G1.src as A, G2.src as B, G3.src as C, G3.dst as D
FROM G G1, G G2, G G3
WHERE G1.dst = G2.src AND G2.dst = G3.src
AND FILTER OVER (G3.dst)
4-Hop Full Join Query.
SELECT G1.src as A, G2.src as B, G3.src as C, G3.dst as D,
G4.dst as E
FROM G G1, G G2, G G3, G G4
WHERE G1.dst = G2.src AND G2.dst = G3.src AND G3.dst = G4.
src AND FILTER OVER (G4.dst)
3-Hop Join-Project Query.
SELECT G2.src as B, G3.src as C
FROM G G1, G G2, G G3
WHERE G1.dst = G2.src AND G2.dst = G3.src
4-Hop Join-Project Query.
SELECT G2.src as B, G3.src as C, G3.dst as D
FROM G G1, G G2, G G3, G G4
WHERE G1.dst = G2.src AND G2.dst = G3.src AND G3.dst = G4.
src
AND FILTER OVER (G4.dst)
2-Comb Query.
SELECT G1.src as A, G2.src as B, G3.src as C, G3.dst as D
FROM G G1, G G2, G G3, V1, V2
WHERE G1.dst = G2.src AND G2.dst = G3.src AND V1.v = G1.src
and V2.v = G3.dst
Star Query.
SELECT G1.src, COUNT(G1.dst, G2.dst, G3.dst, G4.dst)
FROM G G1, G G2, G G3, G G4
WHERE G1.src = G2.src AND G1.src = G3.src AND G1.src = G4.
src
GROUP BY G1.src;
Dumbbell Full Join Query.
SELECT *
FROM G G1, G G2, G G3, G G4, G G5, G G6, G G6
WHERE G1.dst = G2.src
AND G2.dst = G3.src
AND G3.dst = G1.src
AND G5.dst = G6.src
AND G6.dst = G7.src
AND G7.dst = G5.src
AND G4.src = G3.dst
AND G4.dst = G5.src
Dumbbell Join-Project Query.
SELECT G4.src, G4.dst
FROM G G1, G G2, G G3, G G4, G G5, G G6, G G6
WHERE G1.dst = G2.src
AND G2.dst = G3.src
AND G3.dst = G1.src
AND G5.dst = G6.src
AND G6.dst = G7.src
AND G7.dst = G5.src
AND G4.src = G3.dst
AND G4.dst = G5.src
SNB Query 1.
SELECT p_personid, p_firstname, p_lastname, m_messageid,
k_person1id
FROM person, message, knows
WHERE p_personid = m_creatorid
AND k_person2id = p_personid;
SNB Query 2.
SELECT k1.k_person1id, k1.k_person2id, k2.k_person2id,
t_tagid, m_messageid
FROM tag, message, message_tag, knows1 k1, knows2 k2
WHERE m_messageid = mt_messageid
AND mt_tagid = t_tagid
AND k1.k_person2id = k2.k_person1id
AND m_creatorid = k2.k_person2id
AND m_c_replyof is NULL
AND FILTER OVER (k1.k_person1id)
SNB Query 3.
SELECT k1.k_person1id, k1.k_person2id, k2.k_person2id,
t_tagid, m_messageid
FROM tag, message, message_tag, knows1 k1, knows2 k2
WHERE m_messageid = mt_messageid
AND mt_tagid = t_tagid
AND k1.k_person2id = k2.k_person1id
AND k2.k_person2id <> k1.k_person1id
AND m_creatorid = k2.k_person2id
AND m_c_replyof is NULL
AND FILTER OVER (k1.k_person1id)
SNB Query 4.
SELECT t_name, t_tagid, count(distinct m_messageid)
FROM tag, message, message_tag, knows
WHERE m_messageid = mt_messageid
AND mt_tagid = t_tagid
AND m_creatorid = k_person2id
AND m_c_replyof is NULL
AND FILTER OVER (k_person1id)
GROUP BY t_name, t_tagid
20

---

