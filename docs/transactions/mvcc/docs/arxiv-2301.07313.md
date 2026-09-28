# Efficient Black-box Checking of Snapshot Isolation in Databases

> 来源: https://arxiv.org/pdf/2301.07313

Efficient Black-box Checking of Snapshot Isolation in Databases
Kaile Huang†
State Key Laboratory for Novel
Software Technology
Nanjing University
Si Liu†
ETH Zurich
Zhenge Chen
Hengfeng Wei∗
State Key Laboratory for Novel
Software Technology
Software Institute
Nanjing University
David Basin
ETH Zurich
Haixiang Li
Anqun Pan
Tencent Inc.
ABSTRACT
Snapshot isolation (SI) is a prevalent weak isolation level that avoids
the performance penalty imposed by serializability and simultane-
ously prevents various undesired data anomalies. Nevertheless, SI
anomalies have recently been found in production cloud databases
that claim to provide the SI guarantee. Given the complex and often
unavailable internals of such databases, a black-box SI checker is
highly desirable.
In this paper we present PolySI, a novel black-box checker that
efficiently checks SI and provides understandable counterexamples
upon detecting violations. PolySI builds on a novel characterization
of SI using generalized polygraphs (GPs), for which we establish its
soundness and completeness. PolySI employs an SMT solver and
also accelerates SMT solving by utilizing the compact constraint
encoding of GPs and domain-specific optimizations for pruning con-
straints. As demonstrated by our extensive assessment, PolySI suc-
cessfully reproduces all of 2477 known SI anomalies, detects novel
SI violations in three production cloud databases, identifies their
causes, outperforms the state-of-the-art black-box checkers under a
wide range of workloads, and can scale up to large-sized workloads.
PVLDB Reference Format:
Kaile Huang†, Si Liu†, Zhenge Chen, Hengfeng Wei, David Basin, Haixiang
Li, and Anqun Pan. Efficient Black-box Checking of Snapshot Isolation in
Databases. PVLDB, 16(6): 1264 - 1276, 2023.
doi:10.14778/3583140.3583145
PVLDB Artifact Availability:
The source code, data, and/or other artifacts have been made available at
https://github.com/hengxin/PolySI-PVLDB2023-Artifacts.
∗Corresponding author.
This work is licensed under the Creative Commons BY-NC-ND 4.0 International
License. Visit https://creativecommons.org/licenses/by-nc-nd/4.0/ to view a copy of
this license. For any use beyond those covered by this license, obtain permission by
emailing info@vldb.org. Copyright is held by the owner/author(s). Publication rights
licensed to the VLDB Endowment.
Proceedings of the VLDB Endowment, Vol. 16, No. 6 ISSN 2150-8097.
doi:10.14778/3583140.3583145
†Joint first authors.
1
INTRODUCTION
Database systems are an essential building block of many software
systems and applications. Transactional access to databases sim-
plifies concurrent programming by providing an abstraction for
executing concurrent computations on shared data in isolation [6].
The gold-standard isolation level, serializability (SER) [37], ensures
that all transactions appear to execute serially, one after another.
However, providing SER, especially in geo-replicated environments
like modern cloud databases, is computationally expensive [2, 35].
Many databases provide weaker guarantees for transactions to
balance the trade-off between data consistency and system perfor-
mance. Snapshot isolation (SI) [5] is one of the prevalent weaker
isolation levels used in practice, which avoids the performance
penalty imposed by SER and simultaneously prevents undesired
data anomalies such as fractured reads, causality violations, and
lost updates [11]. In addition to classic centralized databases such as
Microsoft SQL Server [41] and Oracle Database [19], SI is supported
by numerous production cloud database systems like Google’s Perco-
lator [38], MongoDB [36], TiDB [48], YugabyteDB [52], Galera [14],
and Dgraph [21].
Unfortunately, as recently reported in [31, 46, 47], data anomalies
have been found in several production cloud databases that claim to
provide SI.1 This raises the question of whether such databases ac-
tually deliver the promised SI guarantee in practice. Given that their
internals (e.g., source code) are often unavailable to the outsiders
or hard to digest, a black-box SI checker is highly desirable.
A natural question then to ask is “What should an ideal black-
box SI checker look like?” The SIEGE principle [31] has already
provided a strong baseline: an ideal checker would be sound (return
no false positives), informative (report understandable counterex-
amples), effective (detect violations in real-world databases), general
(compatible with different patterns of transactions), and efficient
(add modest checking time even for workloads of high concur-
rency). Additionally, (i) we expect an ideal checker to be complete,
thus missing no violations; and (ii) we also augment the general-
ity criterion by requiring the checker to be compatible not only
with general (read-only, write-only, and read-write) transaction
1These anomalies, which we are also concerned with in this paper, are isolation
violations purely in database engines. They may be tolerated by end users or higher-
level applications, depending on their business logic [23, 50].
arXiv:2301.07313v2  [cs.DB]  25 Oct 2023

---

workloads but also with standard key-value/SQL APIs. We call this
extended principle SIEGE+.
None of the existing SI checkers, to the best of our knowledge,
satisfies SIEGE+ (see Section 7 for the detailed comparison). For
example, dbcop [7] is incomplete, incurs exponentially increasing
overhead under higher concurrency (Section 5.4), and returns no
counterexamples upon finding a violation; Elle [31] relies on spe-
cific database APIs such as lists and the (internal) timestamps of
transactions to infer isolation anomalies, thus not conforming to
our black-box setting.
The PolySI Checker. We present PolySI, a novel, black-box SI
checker designed to achieve all the SIEGE+ criteria. PolySI builds
on three key ideas in response to three major challenges.
First, despite previous attempts to characterize SI [1, 5, 51], its
semantics is usually explained in terms of low-level implementation
choices invisible to the database outsiders. Consequently, one must
guess the dependencies (aka uncertain/unknown dependencies)
between client-observable data, for example, which of the two
writes was first recorded in the database.
We introduce a novel dependency graph, called generalized poly-
graph (GP), based on which we present a new sound and complete
characterization of SI. There are two main advantages of a GP: (i)
it naturally models the guesses by capturing all possible depen-
dencies between transactions in a single compacted data structure;
and (ii) it enables the acceleration of SMT solving by compacting
constraints (see below) as demonstrated by our experiments.
Second, there have been recent advances in SAT and SMT solv-
ing for checking graph properties such as the MonoSAT solver [4]
and its successful application to the black-box checking of SER [44].
The idea is to search for an acyclic graph where the nodes are trans-
actions in the history2 and the edges meet certain constraints. We
show that SMT techniques can also be applied to build an effective
SI checker. This application is nontrivial as a brute-force approach
would be inefficient due to the high computational complexity of
checking SI [7]: the problem is NP-complete in general and 𝑂(𝑛𝑐)
with 𝑐(resp. 𝑛) a fixed, yet in practice large, number of clients (resp.
transactions), even for a single transaction history. In fact, checking
SI is known to be asymptomatically more complex than checking
SER [7]. In the context of SMT solving over graphs, SI leads to much
larger search space due to its specific anomaly patterns [11] while
checking SER simply requires finding a cycle.
Thanks to our GP-based characterization of SI, we leverage its
compact encoding of constraints on transaction dependencies to ac-
celerate MonoSAT solving. Moreover, we develop domain-specific
optimizations that further prune constraints, thereby reducing the
search space. For example, PolySI prunes a constraint if an asso-
ciated uncertain dependency would result in an SI violation with
known dependencies.
Finally, although MonoSAT outputs cycles upon detecting a vio-
lation, they are still uninformative with respect to understanding
how the violation actually occurred. Locating the actual causes of
violations would facilitate debugging and repairing the defective
implementations. For example, if an SI checker were to identify a
lost update anomaly from the returned counterexample, developers
2A history collected from dynamically executing a system records the transactional
requests to and responses from the database. See Section 2.2 for its formal definition.
could then focus on investigating the write-write conflict resolution
mechanism. Hence, we design and integrate into PolySI a novel in-
terpretation algorithm that explains the counterexamples returned
by MonoSAT. More specifically, PolySI (i) recovers the violating
scenario by bringing back any potentially involved transactions
and dependencies eliminated during pruning and solving and (ii)
finalizes the core participants to highlight the violation cause.
Main Contributions. In summary, we provide:
(1) a new GP-based characterization of SI that both facilitates
the modeling of uncertain transaction dependencies inher-
ent to black-box testing and also enables the acceleration
of constraint solving (Section 3);
(2) a sound and complete GP-based checking algorithm for SI
with domain-specific optimizations for pruning constraints
(Section 4);
(3) the PolySI tool comprising both our new checking algo-
rithm and the interpretation algorithm for debugging; and
(4) an extensive assessment of PolySI that demonstrates its
fulfilment of SIEGE+ (Section 5). In particular, PolySI suc-
cessfully reproduces all of 2477 known SI anomalies, de-
tects novel SI violations in three production cloud databases,
identifies their causes, outperforms the state-of-the-art black-
box checkers under a wide range of workloads, and can
scale up to large-sized workloads.
2
PRELIMINARIES
2.1
Snapshot Isolation in a Nutshell
Snapshot isolation (SI) [5] is one of the most prominent weaker
isolation levels that modern (cloud) databases usually provide to
avoid the performance penalty imposed by serializability (SER). Fig-
ure 1 shows a hierarchy of isolation levels where SI sits inbetween
transactional causal consistency [34] and SER, and is not comparable
to repeatable read [1].
RC
CI
RA
TCC
SI
RR
SER
Figure 1: A hierarchy of isolation levels. 𝐴→𝐵: 𝐴is strictly
weaker than 𝐵. CI: cut isolation [2]; RC: read committed [5];
RA: read atomicity [3]; RR: repeatable read [1]; TCC: trans-
actional causal consistency [34]; SI: snapshot isolation [11];
SER: serializability [5].
A transaction with SI always reads from a snapshot that reflects
a single commit ordering of transactions and is allowed to commit
if no concurrent transaction has updated the data that it intends to
write. SI prevents various undesired data anomalies such as frac-
tured reads, causality violations, lost updates, and long fork [5, 11].
The following examples illustrate two kinds of anomalies disal-
lowed by SI. As we will see in Section 5, both anomalies have been
detected by our PolySI checker in production cloud databases.
Example 1 (Causality Violation). Alice posts a photo of her birth-
day party. Bob writes a comment to her post. Later, Carol sees Bob’s
comment but not Alice’s post.

---

Table 1: Notation
Category
Notation
Meaning
KV Store
Key
set of keys
Val
set of values
Op
set of operations
Relations
𝑅?
reflexive closure of 𝑅
𝑅+
transitive closure of 𝑅
𝑅; 𝑆
composition of 𝑅with 𝑆
Dependency
SO, WR, WW, RW
dependency relations/edges
Graph
𝐺= (𝑉, 𝐸,𝐶)
(generalized) polygraph
𝑉𝐺, 𝐸𝐺, 𝐶𝐺
components of 𝐺
𝐺|𝐹
digraph with set 𝐹of edges
Algorithm
H = (T, SO)
history to check
I
SI induced graph
BV
set of Boolean variables
CL
set of clauses
Example 2 (Lost Update). Dan and Emma share a banking ac-
count with 10 dollars. Both simultaneously deposit 50 dollars. The
resulting balance is 60, instead of 110, as one of the deposits is lost.
In this paper we focus on the prevalent strong session variant of
SI [11, 20], which additionally requires a transaction to observe all
the effects of the preceding transactions in the same session [45].
Many production databases, including DGraph [21], Galera [14],
and CockroachDB [15], provide this isolation level in practice.
2.2
Snapshot Isolation: Formal Definition
We recall the formalization of SI over dependency graphs, which
serves as the theoretical foundation of PolySI. The following ac-
count is standard, see for example [11], and Table 1 summarizes
the notation used throughout the paper.
We consider a distributed key-value store managing a set of keys
Key = {x, y, z, . . . }, which are associated with values from a set
Val.3 We denote by Op the set of possible read or write operations
on keys: Op = {R𝜄(x, v), W𝜄(x, v) | 𝜄∈OpId, x ∈Key, v ∈Val},
where OpId is the set of operation identifiers. We omit operation
identifiers when they are unimportant.
2.2.1
Relations, Orderings, Graphs, and Logics. A binary relation
𝑅over a given set 𝐴is a subset of 𝐴× 𝐴, i.e., 𝑅⊆𝐴× 𝐴. For
𝑎,𝑏∈𝐴, we use (𝑎,𝑏) ∈𝑅and 𝑎
𝑅−→𝑏interchangeably. We use 𝑅?
and 𝑅+ to denote the reflexive closure and the transitive closure
of 𝑅, respectively. A relation 𝑅⊆𝐴× 𝐴is acyclic if 𝑅+ ∩𝐼𝐴= ∅,
where 𝐼𝐴≜{(𝑎,𝑎) | 𝑎∈𝐴} is the identity relation on 𝐴. Given two
binary relations 𝑅and 𝑆over set 𝐴, we define their composition as
𝑅; 𝑆= {(𝑎,𝑐) | ∃𝑏∈𝐴: 𝑎
𝑅−→𝑏
𝑆−→𝑐}. A strict partial order is an
irreflexive and transitive relation. A strict total order is a relation
that is a strict partial order and total.
For a directed labeled graph 𝐺= (𝑉, 𝐸), we use 𝑉𝐺and 𝐸𝐺to
denote the set of vertices and edges in 𝐺, respectively. For a set 𝐹
of edges, 𝐺|𝐹denotes the directed labeled graph that has the set 𝑉
of vertices and the set 𝐹of edges.
3We discuss how to support SQL queries in Section 6. However, we do not support
predicates in this work.
In logical formulas, we write _ for irrelevant parts that are implic-
itly existentially quantified. We use ∃! to mean “unique existence.”
2.2.2
Transactions and Histories.
Definition 3. A transaction is a pair (O, po), where O ⊆Op is a
finite, non-empty set of operations and po ⊆O × O is a strict total
order called the program order.
For a transaction 𝑇, we let 𝑇⊢W(x, v) if 𝑇writes to x and the
last value written is v, and 𝑇⊢R(x, v) if 𝑇reads from x before
writing to it and v is the value returned by the first such read. We
also use WriteTxx = {𝑇| 𝑇⊢W(x, _)}.
Clients interact with the store by issuing transactions during
sessions. We use a history to record the client-visible results of such
interactions. For conciseness, we consider only committed transac-
tions in the formalism [11]; see further discussions in Section 4.5.
Definition 4. A history is a pair H = (T, SO), where T is a
set of transactions with disjoint sets of operations and the session
order SO ⊆T × T is the union of strict total orders on disjoint
sets of T, which correspond to transactions in different sessions.
2.2.3
Dependency Graph-based Characterization of SI. A depen-
dency graph extends a history with three relations (or typed edges,
in terms of graphs): WR, WW, and RW, representing three possibil-
ity of dependencies between transactions in this history [11]. The
WR relation associates a transaction that reads some value with the
one that writes this value. The WW relation stipulates a strict total
order (aka the version order [1]) among the transactions on the
same key. The RW relation is derived from WR and WW, relating
a transaction that reads some value to the one that overwrites this
value, in terms of the version orders specified by the WW relation.
Definition 5. A dependency graph is a tuple G = (T, SO, WR,
WW, RW), where (T, SO) is a history and
(1) WR : Key →2T×T is such that
• ∀x ∈Key. ∀𝑆∈T . 𝑆⊢R(x, _) =⇒∃!𝑇∈T . 𝑇
WR(x)
−−−−−−→𝑆
• ∀x ∈Key. ∀𝑇,𝑆∈T . 𝑇
WR(𝑥)
−−−−−−→𝑆
=⇒𝑇≠𝑆∧∃v ∈
Val. 𝑇⊢W(x, v) ∧𝑆⊢R(x, v).
(2) WW : Key →2T×T is such that for every x ∈Key, WW(x) is
a strict total order on the set WriteTxx;
(3) RW : Key →2T×T is such that∀𝑇,𝑆∈T . ∀x ∈Key. 𝑇
RW(x)
−−−−−−→
𝑆⇐⇒𝑇≠𝑆∧∃𝑇′ ∈T . 𝑇′ WR(x)
−−−−−−→𝑇∧𝑇′ WW(x)
−−−−−−−→𝑆.
We denote a component of G, such as WW, by WWG. We write
𝑇
WR/WW/RW
−−−−−−−−−−−−→𝑆when the key x in 𝑇
WR(x)/WW(x)/RW(x)
−−−−−−−−−−−−−−−−−−−−→𝑆is
irrelevant or the context is clear.
Intuitively, a history satisfies SI if and only if it can be extended
to a dependency graph that contains only cycles (if any) with at
least two adjacent RW edges. Formally,
Theorem 6 (Dependency Graph-based Characterization of
SI (Theorem 4.1 of [11])). For a history H = (T, SO),
H |= SI ⇐⇒H |= Int ∧
∃WR, WW, RW. G = (H, WR, WW, RW) ∧
(((SOG ∪WRG ∪WWG) ; RWG?) is acyclic).

---

W(x, 2)
Tk
W(x, 1)
Ti
R(x, 1)
Tj
WR(x)
WW(x)
RW(x)
(a) A polygraph
W(x, 1)
T
R(x, 1)
T ′
W(x, 2)
S
R(x, 2)
S′
WR(x)
WR(x)
WW(x)
RW(x)
WW(x)
RW(x)
(b) A generalized polygraph
Figure 2: Examples of polygraphs and generalized poly-
graphs. WR, WW, and RW relations are represented by solid,
dashed, and dotted arrows, respectively.
The internal consistency axiom Int ensures that, within a trans-
action, a read from a key returns the same value as the last write to
or read from this key in the transaction.
2.3
The SI Checking Problem
Definition 7. The SI checking problem is the decision problem of
determining whether a given history H satisfies SI, i.e., is H |= SI?
We take the common “UniqueValue” assumption on histories [1,
7, 9, 17, 44]: for each key, every write to the key assigns a unique
value. For database testing, we can produce such histories by ensur-
ing the uniqueness of the values written on the client side (or work-
load generator) using, e.g., the client identifier and local counter.
Under this assumption, each read can be associated with the trans-
action that issues the corresponding write [11].
Theorem 6 provides a brute-force approach to the SI checking
problem: enumerate all possible WW relations and check whether
any of them results in a dependency graph that contains only cycles
with at least two adjacent RW edges. This approach is, however,
prohibitively expensive.
2.4
Polygraphs
A dependency graph extending a history represents one possibility
of dependencies between transactions in this history. To capture all
possible dependencies between transactions in a single structure,
we rely on polygraphs [37]. Intuitively, a polygraph can be viewed
as a family of dependency graphs.
Definition 8. A polygraph 𝐺= (𝑉, 𝐸,𝐶) associated with a his-
tory H = (T, SO) is a directed labeled graph (𝑉, 𝐸) called the
known graph, together with a set 𝐶of constraints such that
• 𝑉corresponds to all transactions in the history H;
• 𝐸= {(𝑇,𝑆, SO) | 𝑇
SO
−−→𝑆} ∪{(𝑇,𝑆, WR) | 𝑇
WR
−−−→𝑆},
where SO and WR, when used as the third component of
an edge, are edge labels (i.e., types); and
• 𝐶= {⟨(𝑇𝑘,𝑇𝑖, WW), (𝑇𝑗,𝑇𝑘, RW)⟩| (𝑇𝑖
WR(x)
−−−−−−→𝑇𝑗) ∧𝑇𝑘∈
WriteTxx ∧𝑇𝑘≠𝑇𝑖∧𝑇𝑘≠𝑇𝑗}.
As shown in Figure 2a, for a pair of transactions 𝑇𝑖and 𝑇𝑗such
that 𝑇𝑖
WR(x)
−−−−−−→𝑇𝑗and a transaction 𝑇𝑘that writes x, the constraint
⟨(𝑇𝑘,𝑇𝑖, WW), (𝑇𝑗,𝑇𝑘, RW)⟩captures the unknown dependencies
that “either 𝑇𝑘happened before 𝑇𝑖or 𝑇𝑘happened after 𝑇𝑗.”
3
CHARACTERIZING SI USING GENERALIZED
POLYGRAPHS
In this section we introduce generalized polygraphs with general-
ized constraints and use them to characterize SI. By compacting
several constraints together, using generalized constraints leads
to a compact encoding which in turn helps accelerate the solving
process (see Section 5.4.3).
3.1
Generalized Polygraphs
In a polygraph, a constraint involves only a single pair of transac-
tions related by WR, like 𝑇𝑖and 𝑇𝑗on x in Figure 2a. Thus, several
constraints are needed when there are multiple transactions reading
the value of x from 𝑇𝑖. To compact these constraints, we introduce
generalized polygraphs with generalized constraints.
Definition 9. A generalized polygraph 𝐺= (𝑉, 𝐸,𝐶) associated
with a history H = (T, SO) is a directed labeled graph (𝑉, 𝐸) called
the known graph, together with a set 𝐶of generalized constraints
such that
• 𝑉corresponds to all transactions in the history H;
• 𝐸⊆𝑉×𝑉× L is a set of edges with labels (i.e., types) from
L = {SO, WR, WW, RW}; and
• 𝐶=

either ≜{(𝑇,𝑆, WW)} ∪
Ð
𝑇′∈WR(x) (𝑇)
{(𝑇′,𝑆, RW)},
or ≜{(𝑆,𝑇, WW)}
∪
Ð
𝑆′∈WR(x) (𝑆)
{(𝑆′,𝑇, RW)}

| 𝑇∈
WriteTxx ∧𝑆∈WriteTxx ∧𝑇≠𝑆
	
.
A generalized constraint is a pair of sets of edges of the form
⟨either, or⟩. The either part handles the possibility of 𝑇being or-
dered before 𝑆via a WW edge. This forces each transaction 𝑇′ that
reads the value of x from 𝑇to be ordered before 𝑆via an RW edge.
Symmetrically, the or part handles the possibility of 𝑆being ordered
before 𝑇via a WW edge. This forces each transaction 𝑆′ that reads
the value of x from 𝑆to be ordered before 𝑇via an RW edge.
Example 10 (Generalized Polygraphs vs. Polygraphs). In Figure 2b,
both transactions 𝑇and 𝑆write to x, and 𝑇′ and 𝑆′ read the values
of x from𝑇and 𝑆, respectively. The possible dependencies between
these transactions can be compactly expressed as a single general-
ized constraint ⟨{(𝑇,𝑆, WW), (𝑇′,𝑆, RW)}, {(𝑆,𝑇, WW), (𝑆′,𝑇, RW)}⟩,
which corresponds to two constraints: ⟨(𝑇,𝑆, WW), (𝑆′,𝑇, RW)⟩
and ⟨(𝑆,𝑇, WW), (𝑇′,𝑆, RW)⟩.
Note that a generalized polygraph may contain edges of any type
in 𝐸such that a “pruned” generalized polygraph (Section 4.3) is still
a generalized polygraph. For a generalized polygraph 𝐺= (𝑉, 𝐸,𝐶)
and a label 𝐿∈L, we use𝑉𝐺, 𝐸𝐺, 𝐶𝐺, and 𝐿𝐺to denote the set𝑉of
vertices, the set 𝐸of known edges, the set 𝐶of constraints, and the
set of known edges with label 𝐿in 𝐸, respectively. For a generalized
polygraph 𝐺= (𝑉, 𝐸,𝐶) and a set 𝐹of edges, we use 𝐺|𝐹to denote
the directed labeled graph that has the set𝑉of vertices and the set 𝐹
of edges. For any two subsets 𝑅,𝑆⊆𝐸, we define their composition
as 𝑅; 𝑆= {(𝑎,𝑐, 𝐿1 ; 𝐿2) | ∃𝑏∈𝑉: (𝑎,𝑏, 𝐿1) ∈𝑅∧(𝑏,𝑐, 𝐿2) ∈𝑆},
where 𝐿1 ; 𝐿2 is a newly introduced label used when composing
edges. In the sequel, we use generalized polygraphs, but sometimes
we still refer to them as polygraphs.

---

3.2
Characterizing SI
According to Theorem 6, we are interested in the induced graph of
a generalized polygraph G, obtained by composing the edges of G
according to the rule ((SO ∪WR ∪WW) ; RW?).
Definition 11. The induced SI graph of a polygraph G = (𝑉, 𝐸,𝐶)
is the graph 𝐺′ = (𝑉, 𝐸,𝐶, R), where R = (SO∪WR∪WW) ; RW?
is the induce rule.
The concept of compatible graphs gives a meaning to polygraphs
and their induced SI graphs. A graph is compatible with a polygraph
when it is a resolution of the constraints of the polygraph. Thus, a
polygraph corresponds to a family of its compatible graphs.
Definition 12. A directed labeled graph 𝐺′ = (𝑉′, 𝐸′) is compat-
ible with a generalized polygraph 𝐺= (𝑉, 𝐸,𝐶) if
• 𝑉′ = 𝑉;
• 𝐸′ ⊇𝐸; and
• ∀⟨either, or⟩∈𝐶. (either ⊆𝐸′ ∧or ∩𝐸′ = ∅) ∨(or ⊆
𝐸′ ∧either ∩𝐸′ = ∅).
By applying the induce rule R to a compatible graph of a poly-
graph, we obtain a compatible graph with the induced SI graph of
this polygraph.
Definition 13. Let 𝐺′ = (𝑉′, 𝐸′) be a compatible graph with a
polygraph 𝐺. Then 𝐺′|(SO𝐺′ ∪WR𝐺′ ∪WW𝐺′ ) ; RW𝐺′? is a compat-
ible graph with the induced SI graph of 𝐺.
Example 14 (Compatible Graphs). There are two compatible graphs
with the generalized polygraph of Figure 2b: one is with the edge set
{(𝑇,𝑇′, WR), (𝑆,𝑆′, WR), (𝑇,𝑆, WW), (𝑇′,𝑆, RW)}, and the other is
with {(𝑇,𝑇′, WR), (𝑆,𝑆′, WR), (𝑆,𝑇, WW), (𝑆′,𝑇, RW)}.
Accordingly, there are also two compatible graphs with the in-
duced SI graph of the polygraph of Figure 2b: one is with the edge set
{(𝑇,𝑇′, WR), (𝑆,𝑆′, WR), (𝑇,𝑆, WW), (𝑇,𝑆, WR ; RW)}. The edge
(𝑇,𝑆, WR ; RW) is obtained from (𝑇,𝑇′, WR) ; (𝑇′,𝑆, RW). It is
identical to (𝑇,𝑆, WW) if the edge types are ignored. The other is
with {(𝑇,𝑇′, WR), (𝑆,𝑆′, WR), (𝑆,𝑇, WW), (𝑆,𝑇, WR ; RW)}. Sim-
ilarly, (𝑆,𝑇, WR ; RW) is identical to (𝑆,𝑇, WW) if the edge types
are ignored.
We are concerned with the acyclicity of polygraphs and their
induced SI graphs.
Definition 15. An induced SI graph is acyclic if there exists an
acyclic compatible graph with it, when the edge types are ignored. A
polygraph is SI-acyclic if its induced SI graph is acyclic.
Finally, we present the generalized polygraph-based characteri-
zation of SI. Its proof can be found in Appendix B. The key lies in
the correspondence between compatible graphs of polygraphs and
dependency graphs.
Theorem 16 (Generalized Polygraph-based Characteriza-
tion of SI). A history H satisfies SI if and only if H |= Int and the
generalized polygraph of H is SI-acyclic.
4
THE CHECKING ALGORITHM FOR SI
Given a history H, PolySI encodes the induced SI graph of the
generalized polygraph of H into an SAT formula and utilizes the
MonoSAT solver [4] to test its acyclicity. We choose MonoSAT
mainly because, compared to conventional SMT solvers such as Z3,
it is more efficient in checking graph properties [4].
The main challenge is that the size (measured as the number of
variables and clauses) of the resulting SAT formula may be too large
for MonoSAT to solve in reasonable time. Hence, PolySI prunes
constraints of the generalized polygraph of H before encoding.
As we will see in Section 5.4, this pruning process is crucial to
PolySI’s high performance. Additionally, solving is accelerated by
utilizing, instead of original polygraphs, generalized polygraphs
with compact generalized constraints.
4.1
Overview
The procedure CheckSI (line 1 of Algorithm 1) outlines the check-
ing algorithm. First, if H does not satisfy the Int axiom, the check-
ing algorithm terminates and returns false (line 2; see Section 4.5
for the predicates AbortedReads and IntermediateReads). The
algorithm proceeds otherwise in the following three steps:
• construct the generalized polygraph G of H (lines 4 and 5);
• prune constraints in the polygraph G (line 6); and
• encode the induced SI graph, denoted I, of G after pruning
into an SAT formula (line 8), and call MonoSAT to test
whether I is acyclic (line 9).
Algorithm 1 depicts the core procedures of pruning and encoding.
The remaining procedures are given in Appendix A.
Before diving into details, we illustrate our algorithm using the
example history in Figure 3a, which exemplifies the well-known
“long fork” anomaly in SI [11, 43]. Specifically, transaction𝑇0 writes
to both keys x and y. Transactions 𝑇1 and 𝑇2 concurrently write to
x and y, respectively. Transaction 𝑇3 sees the write by 𝑇1, but not
the write by 𝑇2, while 𝑇4 sees the write by 𝑇2, but not the write by
𝑇1. The session committing 𝑇0 then issues 𝑇5 to update x.
Pruning Constraints. To check whether this history satisfies SI,
we must determine the order between 𝑇0, 𝑇1, and 𝑇5 (on x) and the
order between 𝑇0 and 𝑇2 (on y). Consider first the constraint on the
order between 𝑇0 and 𝑇5 shown in Figure 3b. Due to 𝑇0
SO
−−→𝑇5, the
𝑇5
WW(x)
−−−−−−−→𝑇0 case would introduce an undesired cycle. Therefore,
this case can be safely pruned and the other case of 𝑇0
WW(x)
−−−−−−−→𝑇5,
along with the edge 𝑇4
RW(x)
−−−−−−→𝑇5, become known.
Figure 3c shows the constraint on the order between 𝑇0 and 𝑇1:
⟨either = {(𝑇1,𝑇0, WW), (𝑇3,𝑇0, RW}, or = {(𝑇0,𝑇1, WW), (𝑇4,𝑇1, RW)}⟩.
Consider first the either case. Note that the edge 𝑇3
RW(x)
−−−−−−→𝑇0 is in
an undesired cycle 𝑇3
RW(x)
−−−−−−→𝑇0
WR(y)
−−−−−−→𝑇3, which contains only
a single RW edges. Hence, the either case could be safely pruned,
without SAT encoding and solving. Conversely, the or case does not
introduce undesired cycles. Thus, the edges in the or case become
known, before SAT encoding and solving.
Similarly, the either case of the constraint on the order between
𝑇0 and 𝑇2, namely ⟨either = {(𝑇2,𝑇0, WW), (𝑇4,𝑇0, RW}, or =
{(𝑇0,𝑇2, WW), (𝑇4,𝑇2, RW)}⟩, could be safely pruned (not shown
in Figure 3d), and the edges in the or case become known.
SAT Encoding. The order between 𝑇1 and 𝑇5 is still uncertain
after pruning in Figure 3d. We encode the constraint ⟨either =

---

W(x, 0) W(y, 0)
T0
W(x, 2) T5
W(x, 1)
T1
W(y, 1)
T2
R(x, 1) R(y, 0)
T3
R(x, 0) R(y, 1)
T4
WR(y)
WR(x)
SO
WR(x)
WR(y)
(a) A “long fork” history with SO and
WR edges. 𝑇0 and 𝑇5 are on the same ses-
sion.
W(x, 0) W(y, 0)
T0
W(x, 2) T5
W(x, 1)
T1
W(y, 1)
T2
R(x, 1) R(y, 0)
T3
R(x, 0) R(y, 1)
T4
WR(y)
WR(x)
SO
WW(x)
!
RW(x)
!
WW(x)
%
WR(x)
WR(y)
(b) The 𝑇5
WW(x)
−−−−−→𝑇0 case is pruned due to
the cycle 𝑇0
SO
−−→𝑇5
WR(x)
−−−−−→𝑇0.
W(x, 0) W(y, 0)
T0
W(x, 2) T5
W(x, 1)
T1
W(y, 1)
T2
R(x, 1) R(y, 0)
T3
R(x, 0) R(y, 1)
T4
WR(y)
WR(x)
SO
WW(x)
RW(x)
WR(x)
WR(y)
WW(x)
%
RW(x)
%
WW(x)
!
RW(x)
!
(c) The 𝑇1
WW(x)
−−−−−→𝑇0 case is pruned due to
the cycle 𝑇3
RW(x)
−−−−−→𝑇0
WR(y)
−−−−−→𝑇3.
W(x, 0) W(y, 0)
T0
W(x, 2) T5
W(x, 1)
T1
W(y, 1)
T2
R(x, 1) R(y, 0)
T3
R(x, 0) R(y, 1)
T4
WR(y)
WR(x)
SO
WW(x)
RW(x)
WR(x)
WR(y)
WW(x)
RW(x)
WW(y)
!
RW(y)
!
(d) The𝑇2
WW(y)
−−−−−→𝑇0 case is pruned and the
𝑇0
WW(y)
−−−−−→𝑇2 case become known.
W(x, 1)
T1
W(y, 1)
T2
R(x, 1) R(y, 0)
T3
R(x, 0) R(y, 1)
T4
WR(x)
WR(y)
RW(x)
RW(y)
(e) The undesired and violat-
ing cycle found by MonoSAT.
Figure 3: The “long fork” anomaly: an illustrating example of PolySI.
{(𝑇1,𝑇5, WW), (𝑇3,𝑇5, RW)}, or = {(𝑇5,𝑇1, WW)}⟩on the order as
a SAT formula
(BV1,5 ∧BV3,5 ∧¬BV5,1) ∨(BV5,1 ∧¬BV1,5 ∧¬BV3,5),
where BV𝑖,𝑗is a Boolean variable indicating the existence of the
edge from 𝑇𝑖to 𝑇𝑗in the pruned polygraph. We then encode the
induced SI graph, denoted I. Since 𝑇2
WR(y)
−−−−−−→𝑇4
RW(x)
−−−−−−→𝑇5, we
have BVI
2,5 = BV2,4 ∧BV4,5, where BVI
𝑖,𝑗is a Boolean variable
indicating the existence of the edge from 𝑇𝑖to 𝑇𝑗in I. Similarly, we
have BVI
1,2 = BV1,3 ∧BV3,2 and BVI
2,1 = BV2,4 ∧BV4,1. In contrast,
since it is possible that𝑇3
RW(x)
−−−−−−→𝑇5, we have BVI
1,5 = BV1,3∧BV3,5.
MonoSAT Solving. Finally, we feed the SAT formula to MonoSAT
for an acyclicity test of the graph I. MonoSAT successfully finds
an undesired cycle 𝑇1
WR(x)
−−−−−−→𝑇3
RW(y)
−−−−−−→𝑇2
WR(y)
−−−−−−→𝑇4
RW(x)
−−−−−−→𝑇1,
which contains two non-adjacent RW edges; see Figure 3e. There-
fore, this history violates SI.
4.2
Constructing the Generalized Polygraph
We construct the generalized polygraph G of the history H in
two steps. First, we create the known graph of G by adding the
known edges of types SO and WR to EG. Second, we generate the
generalized constraints of G on possible dependencies between
transactions. Specifically, for each key x and each pair of transac-
tions𝑇and 𝑆that both write x, we generate a generalized constraint
of the form ⟨either, or⟩according to Definition 9.
from
to
WW
in KI
(a) (from, to) is a WW edge.
from
to
prec
RW
in Dep
in KI
in KI
(b) (from, to) is an RW edge.
Figure 4: Two cases for pruning constraints.
4.3
Pruning Constraints
To accelerate MonoSAT solving, we prune as many constraints as
possible before encoding (line 10). A constraint can be pruned if
either of its two possibilities, represented by either or or, cannot hap-
pen, i.e., adding the edges in one of the two possibilities would create
a cycle in the reduced SI graph. If neither of the two possibilities
in a constraint can happen, PolySI immediately returns False. This
process is repeated until no more constraints can be pruned (line 31).
In each iteration, we first construct the currently known part
of the induced SI graph, denoted KI, of G. To do this, we de-
fine two auxiliary graphs, namely Dep ←G|SOG∪WRG∪WWG and
AntiDep ←G|RWG. By Definition 13, KI is Dep ∪(Dep ; AntiDep)
(line 14). Then, we compute the reachability relation of KI. Next, for
each constraint cons of the form ⟨either, or⟩, we check if either or or
would create cycles in KI (line 16). Consider an edge (from, to, type)
in either (line 17). By construction, it must be of type WW or RW.
Note that KI does not contain any RW edges by definition. There-
fore, an RW edge from from to to, together with a path from to to

---

Algorithm 1 The PolySI algorithm for checking SI
1: procedure CheckSI(H)
2:
if H̸ |= Int ∨AbortedReads ∨IntermediateReads
3:
return false
4:
CreateKnownGraph(H)
⊲see Appendix A
5:
GenerateConstraints(H)
⊲see Appendix A
6:
if ¬PruneConstraints()
7:
return false
8:
SAT-Encode()
9:
return MonoSAT-Solve()
⊲see Appendix A
10: procedure PruneConstraints()
11:
repeat
12:
Dep ←G|SOG∪WRG∪WWG
13:
AntiDep ←G|RWG
14:
KI ←Dep ∪(Dep ; AntiDep)
15:
reachability ←Reachability(KI ) ⊲using Floyd-Warshall algorithm [16].
16:
for all cons ←⟨either, or⟩∈CG
17:
for all (from, to, type) ∈either
⊲for the “either” possibility
18:
if type = WW
19:
if (to, from) ∈reachability
20:
CG ←CG \ {cons}
21:
EG ←EG ∪or
22:
break the “for all (from, to, type) ∈either” loop
23:
else
⊲type = RW
24:
for all prec ∈VDep such that (prec, from, _) ∈EDep
25:
if (to, prec) ∈reachability
26:
CG ←CG \ {cons}
27:
EG ←EG ∪or
28:
break the “for all (from, to, type) ∈either” loop
29:
for all (from, to, type) ∈or
⊲for the “or” possibility
30:
the same with the “either” possibility except that it returns False
if both either and or possibilities of a constraint are pruned
31:
until CG remains unchanged
32:
return True
33: procedure SAT-Encode()
34:
for all v𝑖, v𝑗∈VG such that 𝑖≠𝑗
35:
BV ←BV ∪{BV𝑖,𝑗, BVI
𝑖,𝑗}
36:
for all (v𝑖, v𝑗) ∈EG
⊲encode the known graph of G
37:
CL ←CL ∪{BV𝑖,𝑗= True}
38:
for all ⟨either, or⟩∈CG
⊲encode the constraints of G
39:
CL ←CL ∪
n Ó
(v𝑖,v𝑗,_) ∈either
BV𝑖,𝑗∧
Ó
(v𝑖,v𝑗,_) ∈or
¬BV𝑖,𝑗
 ∨ Ó
(v𝑖,v𝑗,_) ∈or
BV𝑖,𝑗∧
Ó
(v𝑖,v𝑗,_) ∈either
¬BV𝑖,𝑗
o
40:
Dep ←G|SOG∪WRG∪WWG
41:
EDep ←EDep ∪{(_, _, WW) ∈either ∪or | ⟨either, or⟩∈CG }
42:
AntiDep ←G|RWG
43:
EAntiDep ←EAntiDep ∪{(_, _, RW) ∈either ∪or | ⟨either, or⟩∈CG }
44:
CL ←CL ∪
n
BVI
𝑖,𝑗=  BV𝑖,𝑗∧(v𝑖, v𝑗, _) ∈EDep
 ∨ Ô
(v𝑖,v𝑘,_) ∈EDep
(v𝑘,v𝑗,_) ∈EAntiDep
BV𝑖,𝑘∧
BV𝑘,𝑗
  v𝑖, v𝑗∈VG
o
⊲encode the induced SI graph I of G
from in KI, does not necessarily create a cycle in KI. This fails the
simple reachability-based strategy used in Cobra [44].
Suppose first that (from, to) is a WW edge; see Figure 4a. If there
is already a path from to to from in KI (line 19), adding the WW
edge would create a cycle in KI. Thus, we can prune the constraint
cons and the edges in the other possibility or become known.
Now suppose that (from, to) is an RW edge; see Figure 4b. We
check if there is a path in KI from to to any immediate predecessor
prec of from in Dep (line 24). If there is a path, adding this RW edge
would introduce, via composition with the edge from prec to from,
an edge from prec to to in KI (the dashed arrow in Figure 4b). Then,
with the path from to to prec, we obtain a cycle in KI.
The pruning process of the or possibility is same with that for
either, except that it returns False if both either and or possibilities
of a constraint are pruned.
The following theorem states that PruneConstraints is cor-
rect in that (1) it preserves the SI-(a)cyclicity of polygraphs; and (2)
it does not introduce new undesired cycles, which ensures that any
violation found in the pruned polygraph using MonoSAT later also
exists in the original polygraph. This is crucial to the informative-
ness of PolySI. The theorem’s proof can be found in Appendix B.
Theorem 17 (Correctness of PruneConstraints). Let 𝐺and
𝐺𝑝be the generalized polygraphs before and after PruneConstraints,
respectively. Then,
(1) 𝐺is SI-acyclic if and only if PruneConstraints returns True
and 𝐺𝑝is SI-acyclic.
(2) Suppose that 𝐺𝑝is not SI-acyclic. Let C be a cycle in a compatible
graph with the induced SI graph of 𝐺𝑝. Then there is a compatible
graph with the induced SI graph of 𝐺that contains C.
Combining Theorems 16 and 17, we prove PolySI’s soundness.
Theorem 18 (Soundness of PolySI). PolySI is sound, i.e., if
PolySI returns False, then the input history indeed violates SI.
4.4
SAT Encoding
In this step we encode the induced SI graph, denoted I, of the pruned
polygraph G into an SAT formula (line 33). We use BV and CL to
denote the set of Boolean variables and the set of clauses of the SAT
formula, respectively. For each pair of vertices v𝑖and v𝑗, we create
two Boolean variables BV𝑖,𝑗and BVI
𝑖,𝑗: one for the polygraph 𝐺,
and the other for its induced SI graph I. An edge (v𝑖, v𝑗) is in the
compatible graph with I (resp., G) if and only if BVI
𝑖,𝑗(resp., BV𝑖,𝑗)
is assigned to True by MonoSAT in testing the acyclicity of I.
We first encode the polygraph G. For each edge (v𝑖, v𝑗) in the
known graph of G, we add a clause BV𝑖,𝑗= True. For each constraint
⟨either, or⟩, the clause  Ó
(v𝑖,v𝑗,_)∈either
BV𝑖,𝑗∧
Ó
(v𝑖,v𝑗,_)∈or
¬BV𝑖,𝑗

∨
 Ó
(v𝑖,v𝑗,_)∈or
BV𝑖,𝑗∧
Ó
(v𝑖,v𝑗,_)∈either
¬BV𝑖,𝑗
 expresses that exactly one
of either or or happens.
Then we encode the induced SI graph I of G. The auxiliary graph
Dep contains all the known and potential SO, WR, and WW edges
of G (lines 40 and 41), while AntiDep contains all the known and
potential RW edges of G (lines 42 and 43). The clauses defined on
BVI at line 44 state that I is the union of Dep and the composition
of Dep with AntiDep.
4.5
Completing the SI Checking
Theorem 6 assumes histories with only committed transactions
and considers the WR, WW, and RW relations over transactions
rather than read/write operations inside them. This would miss
non-cycle anomalies. Hence, for completeness, PolySI also checks
whether a history exhibits AbortedReads or IntermediateReads
anomalies [1, 31] (line 2):
• Aborted Reads: a committed transaction cannot read a value
from an aborted transaction.

---

• Intermediate Reads: a transaction cannot read a value that
was overwritten by the transaction that wrote it.
Note that PolySI’s completeness relies on a common assumption
about determinate transactions [1, 7, 10, 11, 17, 31], i.e., the status of
each transaction, whether committed or aborted, is legitimately de-
cided. Indeterminate transactions are inherent to black-box testing:
it is difficult for a client to justify the status of a transaction due to
the invisibility of system internals. Together with the completeness
of the dependency-graph-based characterization of SI in Theorem 6,
we prove PolySI’s completeness.
Theorem 19 (Completeness of PolySI). PolySI is complete with
respect to a history that contains only determinate transactions, i.e.,
if such a history indeed violates SI, then PolySI returns false.
5
EXPERIMENTS
We have presented our SI checking algorithm PolySI and established
its soundness and completeness. In this section, we conduct a com-
prehensive assessment of PolySI to answer the following questions
with respect to the remaining criteria of SIEGE+ (Section 1):
(1) Effective: Can PolySI find SI violations in (production) databases?
(2) Informative: Can PolySI provide understandable counterex-
amples for SI violations?
(3) Efficient: How efficient is PolySI (and its components)? Can
PolySI outperform the state of the art under various workloads and
scale up to large-sized workloads?
Our answer to (1) is twofold (Section 5.2): (i) PolySI successfully
reproduces all of 2477 known SI anomalies in production databases;
and (ii) we use PolySI to detect novel SI violations in three cloud
databases of different kinds: the graph database Dgraph [21], the
relational database MariaDB-Galera [14], and YugabyteDB [52]
supporting multiple data models. To answer (2) we provide an algo-
rithm that recovers the violating scenario, highlighting the cause
of the violation found (Section 5.3). Regarding (3), we (i) show that
PolySI outperforms several competitive baselines including the
most performant SI and serializability checkers to date; (ii) mea-
sure the contributions of its different components/optimizations
to the overall performance under both general and specific trans-
action workloads (Section 5.4); and (iii) demonstrate its scalability
for large-sized workloads with one billion keys and one million
transactions. Note that we demonstrate PolySI’s generality along
with the answers to questions (1) and (3).
5.1
Workloads, Benchmarks, and Setup
5.1.1
Workloads and Benchmarks. To evaluate PolySI on general
read-only, write-only, and read-write transaction workloads, we
have implemented a parametric workload generator. Its parameters
are: the number of client sessions (#sess; 20 by default), the number
of transactions per session (#txns/sess; 100 by default), the number
of read/write operations per transaction (#ops/txn; 15 by default),
the percentage of reads (%reads; 50% by default), the total number
of keys (#keys; 10k by default), and the key-access distribution (dist)
including uniform, zipfian (by default), and hotspot (80% operations
touching 20% keys). Note that the default 2k transactions with 30k
operations issued by 20 sessions are sufficient to distinguish PolySI
from competing tools (see Section 5.4.1).
Among such general workloads, we also consider three repre-
sentatives, each with 10k transactions and 80k operations in total
(#sess=25, #txns/sess=400, and #ops/txn=8), in the comparison with
Cobra and the decomposition and differential analysis of PolySI:
(i) GeneralRH, read-heavy workload with 95% reads; (ii) Gener-
alRW, medium workload with 50% reads; and (iii) GeneralWH,
write-heavy workloads with 30% reads.
We also use three synthetic benchmarks with only serializable
histories of at least 10k transactions (which also satisfy SI):
• RUBiS [40]: an eBay-like bidding system where users can,
for example, register and bid for items. The dataset archived
by [44] contains 20k users and 200k items.
• TPC-C [49]: an open standard for benchmarking online
transaction processing with a mix of five different types of
transactions (e.g., for orders and payment) portraying the
activity of a wholesale supplier. The dataset includes one
warehouse, 10 districts, and 30k customers.
• C-Twitter [30]: a Twitter clone where users can, for example,
tweet and follow or unfollow other users (following the
zipfian distribution).
To assess PolySI’s scalability, we also consider large-sized work-
loads with one billion keys and one million transactions (#sess=20;
#txns/sess=50k). The workloads contain both short and long trans-
actions; the default sizes are 15 and 150, respectively.
5.1.2
Setup. We use a PostgreSQL (v15 Beta 1) instance to produce
valid histories without isolation violations: for the performance
comparison with other SI checkers and the decomposition and
differential analysis of PolySI itself, we set the isolation level to
repeatable read (implemented as SI in PostgreSQL [39]); for the
runtime comparison with Cobra (Section 5.4.1), we use the serializ-
ability isolation level to produce serializable histories. We co-locate
the client threads and PostgreSQL (or other databases for testing;
see Section 5.2.2) on a local machine. Each client thread issues a
stream of transactions produced by our workload generator to the
database and records the execution history. All histories are saved
to a file to benchmark each tool’s performance.
We have implemented PolySI in 2.3k lines of Java code, and the
workload generator, including the transformation from generated
key-value operations to SQL queries (for the interactions with rela-
tional databases such as PostgreSQL), in 2.2k lines of Rust code. We
ensure unique values written for each key using counters. We use
a simple database schema of a two-column table storing keys and
values, which is effective to find real violations in three production
databases (see Section 5.2).
We conducted all experiments with a 4.5GHz Intel Xeon E5-2620
(6-core) CPU, 48GB memory, and an NVIDIA K620 GPU.
5.2
Finding SI Violations
5.2.1
Reproducing Known SI Violations. PolySI successfully repro-
duces all known SI violations in an extensive collection of 2477
anomalous histories [7, 18, 29]. These histories were obtained from
the earlier releases of three different production databases, i.e.,
CockroachDB, MySQL-Galera, and YugabyteDB; see Table 2 for

---

Table 2: Summary of tested databases. Multi-model refers to
relational DBMS, document store, and wide-column store.
Database
GitHub Stars
Kind
Release
New violations found:
Dgraph
18.2k
Graph
v21.12.0
MariaDB-Galera
4.4k
Relational
v10.7.3
YugabyteDB
6.7k
Multi-model
v2.11.1.0
Known bugs [7, 18, 29]:
CockroachDB
25.1k
Relational
v2.1.0
v2.1.6
MySQL-Galera
381
Relational
v25.3.26
YugabyteDB
6.7k
Multi-model
v1.1.10.0
details. This set of experiments provides supporting evidence for
PolySI’s soundness and completeness, established in Section 4.
5.2.2
Detecting New Violations. We use PolySI to examine recent
releases of three well-known cloud databases (of different kinds)
that claim to provide SI: Dgraph [21], MariaDB-Galera [14], and Yu-
gabyteDB [52]. See Table 2 for details. We have found and reported
novel SI violations in all three databases which, as of the time of
writing, are being investigated by the developers. In particular, as
communicated with the developers, (i) our finding has helped the
DGraph team confirm some of their suspicions about their latest
release; and (ii) Galera has confirmed the incorrect claim on prevent-
ing lost updates for transactions issued on different cluster nodes
and thereafter removed any claims on SI or “partially supporting
SI” from the previous documentation.4
5.3
Understanding Violations
MonoSAT reports cycles, constructed from its output logs, upon
detecting an SI violation. However, such cycles are uninformative
with respect to understanding how the violation actually occurred.
For instance, Figure 5(a) depicts the original cycle returned by
MonoSAT for an SI violation found in MariaDB-Galera, where it is
difficult to identify the cause of the violation.
Hence, we have designed an algorithm to interpret the returned
cycles. The key idea is to (i) bring back any potentially involved
transactions and the associated dependencies, (ii) restore the violat-
ing scenario by identifying the core participants and dependencies,
and (iii) remove the “irrelevant” dependencies to simplify the sce-
nario. We have integrated into PolySI the algorithm written in 300
lines of C++ code. The pseudocode is given in Appendix C. We have
also integrated the Graphviz tool [24] into PolySI to visualize the
final counterexamples (e.g., Figure 5).
Minimal Counterexample. A “minimal” counterexample would
facilitate understanding how the violation actually occurred. We
define a minimal violation as a polygraph where no dependency
can be removed; otherwise, the resulting polygraph would pass
the verification of PolySI. Given a polygraph 𝐺(constructed from
a collected history) and a cycle 𝐶(returned by MonoSAT), there
may however be more than one minimal violation with respect to
𝐺and 𝐶due to different interpretations of uncertain dependencies.
4https://github.com/codership/documentation/commit/
cc8d6125f1767493eb61e2cc82f5a365ecee6e7a
and
https://github.com/codership/
documentation/commit/d87171b0d1b510fe59973cb7ce5892061ce67b80
We call the one with the least number of dependencies the minimal
counterexample with respect to 𝐺and 𝐶.
PolySI guarantees the minimality of returned counterexample:
Theorem 20 (Minimality). PolySI always returns a minimal
counterexample with respect to 𝐺and 𝐶, with 𝐺the polygraph built
from a history and 𝐶the cycle output by MonoSAT.
We defer to Appendix E for the formal definitions of the minimal
violation and counterexample and the proof of Theorem 28.
Violation Found in MariaDB-Galera. We present an example vi-
olation detected in MariaDB-Galera. In particular, we illustrate how
the interpretation algorithm helps us locate the violation cause: lost
update. We defer the Dgraph and YugabyteDB anomalies (causality
violations) to Appendix D. In the following example, we use T:(𝑠,𝑛)
to denote the 𝑛th transaction issued by session 𝑠.
Given the original cycles returned by MonoSAT in Figure 5(a),
PolySI first finds the (only) “missing” transaction T:(1,4) (colored
in green) and the associated dependencies, as shown in Figure
5(b). Note that some of the dependencies are uncertain at this mo-
ment, e.g., the WW dependency between T:(1,4) and T:(1,5) (in
red). PolySI then restores the violating scenario by resolving such
uncertainties. For example, as depicted in Figure 5(c), PolySI deter-
mines that W(0,4) was actually installed first in the database, i.e.,
T:(1,4)
WW
−−−−→T:(1,5), because there would otherwise be an undesired
cycle with the known dependencies, i.e., T:(1,5)
WW
−−−−→T:(1,4)
WR
−−−→T:(1,5).
The same reasoning applies to determine the WW dependency be-
tween T:(1,4) and T:(2,13) (in blue). Finally, PolySI finalizes the
violating scenario by removing any remaining uncertainties includ-
ing those dependencies not involved in the actual violation (the
WW dependency between T:(1,5) and T:(2,13) in this case).
The violating scenario now becomes informative and explain-
able: transaction T:(1,4) writes value 4 on key 0, which is read by
transactions T:(2,13) and T:(1,5). Both transactions subsequently
commit their writes on key 0 by W(0,13) and W(0,5), respectively,
which results in a lost update anomaly.
5.4
Performance Evaluation
In this section, we conduct an in-depth performance analysis of
PolySI and compare it to the following black-box checkers:
• dbcop [7] is, to the best of our knowledge, the most effi-
cient black-box SI checker that does not use an off-the-shelf
solver. Note that, unlike our PolySI tool, dbcop does not
check aborted reads or intermediate reads (see Section 4.5).
• Cobra [44] is the state-of-the-art SER checker utilizing both
MonoSAT and GPUs to accelerate the checking procedure.
Cobra serves as a baseline because (i) checking SI is more
complicated than checking SER in general [7], and con-
straint pruning and the MonoSAT encoding for SI are more
challenging in particular due to more complex cycle pat-
terns in dependency graphs (Theorem 6, Section 2.2.3); and
(ii) Cobra is the most performant SER checker to date.
• CobraSI: We implement the incremental algorithm [7, Sec-
tion 4.3] for reducing checking SI to checking serializability
(in polynomial time) to leverage Cobra. We consider two
variants: (i) CobraSI without GPU for a fair comparison

---

R(0, 4) W(0, 5)
T : (1, 5)
R(0, 4) W(0, 13)
T : (2, 13)
WW
RW
WW
RW
(a) Original output
R(0, 4) W(0, 5)
T : (1, 5)
W(0, 4)
T : (1, 4)
R(0, 4) W(0, 13)
T : (2, 13)
WR
WW
WW
WW
RW
WW
RW
WR
WW
WW
(b) Missing participants
R(0, 4) W(0, 5)
T : (1, 5)
W(0, 4)
T : (1, 4)
R(0, 4) W(0, 13)
T : (2, 13)
WR
WW
WW
WW
RW
WW
RW
WR
WW
WW
(c) Recovered scenario
R(0, 4) W(0, 5)
T : (1, 5)
W(0, 4)
T : (1, 4)
R(0, 4) W(0, 13)
T : (2, 13)
WR
WW
RW
RW
WR
WW
(d) Finalized scenario
Figure 5: Lost update: the SI violation found in MariaDB-Galera. The original output dependencies are represented by dotted
black arrows. The recovered dependencies are colored in red/blue with dashed and solid arrows representing uncertain and
certain dependencies, respectively. The missing transaction is colored in green. We omit key 0, associated with all dependencies.
10
20
30
0
50
100
150
#sessions
Time (s)
(a)
CobraSI w/ GPU
CobraSI w/o GPU
dbcop
PolySI
0
50
100
150
200
250
0
50
100
#txns/session
Time (s)
(b)
CobraSI w/ GPU
CobraSI w/o GPU
dbcop
PolySI
10
20
30
0
50
100
#ops/txn
Time (s)
(c)
CobraSI w/ GPU
CobraSI w/o GPU
dbcop
PolySI
0
20
40
60
80
100
0
50
100
150
read proportion %
Time (s)
(d)
CobraSI w/ GPU
CobraSI w/o GPU
dbcop
PolySI
0.2
0.4
0.6
0.8
1
·104
0
50
100
#keys
Time (s)
(e)
CobraSI w/ GPU
CobraSI w/o GPU
dbcop
PolySI
uniform
zipfian
hotspot
0
20
40
60
80
100
Time (s)
(f)
CobraSI w/ GPU
CobraSI w/o GPU
dbcop
PolySI
Figure 6: Performance comparison with the competing SI
checkers under various workloads. Experiments time out at
180s; data points are not plotted for timed-out experiments.
with PolySI and dbcop, which do not employ GPU or multi-
threading; and (ii) CobraSI with GPU as a strong competitor.
5.4.1
Performance Comparison with State of the Art. Our first set
of experiments compares PolySI with the competing SI checkers
under a wide range of workloads. The input histories extracted
from PostgreSQL (with the repeatable read isolation level) are all
valid with respect to SI. The experimental results are shown in Fig-
ure 6: PolySI significantly surpasses not only the state-of-the-art SI
checker dbcop but also CobraSI with GPU. In particular, with more
concurrency, such as more sessions (a), transactions per session
(b), and operations per transaction (c), CobraSI with GPU exhibits
exponentially increasing checking time5 while PolySI incurs only
5Two major reasons are: (i) Cobra has already been shown to exhibit exponential
verification time under general workloads [44]; and (ii) the incremental algorithm
10
20
30
0
200
400
#sessions
Memory (MB)
(a)
CobraSI w/ GPU
CobraSI w/o GPU
dbcop
PolySI
0
50
100
150
200
250
0
500
1,000
#txns/session
Memory (MB)
(b)
CobraSI w/ GPU
CobraSI w/o GPU
dbcop
PolySI
10
20
30
0
200
400
600
800
#ops/txn
Memory (MB)
(c)
CobraSI w/ GPU
CobraSI w/o GPU
dbcop
PolySI
0
20
40
60
80
100
0
500
1,000
read proportion %
Memory (MB)
(d)
CobraSI w/ GPU
CobraSI w/o GPU
dbcop
PolySI
0.2
0.4
0.6
0.8
1
·104
0
200
400
600
800
#keys
Memory (MB)
(e)
CobraSI w/ GPU
CobraSI w/o GPU
dbcop
PolySI
uniform
zipfian
hotspot
0
200
400
600
Memory (MB)
(f)
CobraSI w/ GPU
CobraSI w/o GPU
dbcop
PolySI
Figure 7: Comparison on memory overhead with competing
SI checkers under various workloads.
RUBiS
TPC-C
C-Twitter
GeneralRH
GeneralRW
GeneralWH
0
20
40
60
80
Time (s)
(a)
Cobra w/ GPU
PolySI
RUBiS
TPC-C
C-Twitter
GeneralRH
GeneralRW
GeneralWH
0
500
1,000
1,500
Memory (MB)
(b)
Cobra w/ GPU
PolySI
Figure 8: Comparison on time and memory overhead with Co-
bra with GPU acceleration under representative workloads.
moderate overhead. The result depicted in Figure 6(f) is also consis-
tent: with the skewed key accesses representing high concurrency
as in the zipfian and hotspot distributions, both dbcop and CobraSI
for reducing checking SI to checking serializability typically doubles the number of
transactions in a given history [7], rendering the checking even more expensive.

---

RUBiS
TPC-C
C-Twitter
GeneralRH
GeneralRW
GeneralWH
0
20
40
Time (s)
Solving
Encoding
Pruning
Constructing
Figure
9:
Decomposing
PolySI’s checking time into
stages.
RUBiS
TPC-C
C-Twitter
GeneralRH
GeneralRW
GeneralWH
102
104
Time (s) in log scale
PolySI
PolySI w/o P
PolySI w/o CP
Figure 10: Diff. analysis of
PolySI. Memory-exhausted
runs are colored in red.
without GPU acceleration time out. Moreover, even with the GPU
acceleration, CobraSI takes 6x more time than PolySI. Finally, un-
like the other SI checkers, PolySI’s performance is fairly stable with
respect to varying read/write proportions (d) and keys (e).
In Figure 8(a) we compare PolySI with the baseline serializability
checker Cobra. We present the checking time on various bench-
marks. PolySI outperforms Cobra (with its GPU acceleration en-
abled) in five of the six benchmarks with up to 3x improvement (as
for GeneralRH). The only exception is TPC-C, where most of the
transactions have the read-modify-write pattern,6 for which Cobra
implements a specific optimization to efficiently infer dependencies
before pruning and encoding.
We also measure the memory usage for all the checkers under
the same settings as in Figure 6 and Figure 8(a). As shown in Fig-
ure 7, PolySI consumes less memory (for storing both generated
graphs and constraints) than the competitors in general. Note that
dbcop, the only checker that does not rely on solving and stores no
constraints, is not competitive with PolySI for most of the cases.
Regarding the comparison on specific benchmarks (Figure 8(b)),
PolySI and Cobra with GPU acceleration have similar overheads,
while PolySI (resp. Cobra) requires less memory for read-heavy
workloads (resp. TPC-C).
Table 3: Number of constraints and unknown dependencies
before and after pruning (P) in the six benchmarks.
Benchmark
#cons.
#cons.
#unk. dep.
#unk. dep.
before P
after P
before P
after P
TPC-C
386k
0
3628k
0
GeneralRH
4k
29
39k
77
RUBiS
14k
149
171k
839
C-Twitter
59k
277
307k
776
GeneralRW
90k
2565
401k
5435
GeneralWH
167k
6962
468k
14376
5.4.2
Decomposition Analysis of PolySI. We measure PolySI’s check-
ing time in terms of stages: constructing, which builds up a gen-
eralized polygraph from a given history; pruning, which prunes
constraints in the generalized polygraph; encoding, which encodes
the graph and the remaining constraints; and solving, which runs
the MonoSAT solver.
Figure 9 depicts the results on six different datasets. Constructing
a generalized polygraph is relatively inexpensive. The overhead
6In a read-modify-write transaction each read is followed by a write on the same key.
20
40
60
80
0
2
4
6
read proportion %
Time (h)
(a)
PolySI
20
40
60
80
30
35
40
45
read proportion %
Memory (GB)
(b)
PolySI
200
300
400
2
3
4
5
6
#ops per long transaction
Time (h)
(c)
PolySI
200
300
400
34
35
36
37
38
#ops per long transaction
Memory (GB)
(d)
PolySI
Figure 11: PolySI’s overhead on large-sized workloads with
one billion keys and one million transactions.
of pruning is fairly constant, regardless of the workloads; PolySI
can effectively prune (resp. resolve) a huge number of constraints
(resp. unknown dependencies) in this phase. See Table 3 for details.
In particular, for TPC-C which contains only read-only and read-
modify-write transactions, PolySI is able to resolve all uncertainties
on WW relations and identify the unique version chain for each
key. The encoding effort is moderate; TPC-C incurs more overhead
as the number of operations in total is 5x more than the others.
The solving time depends on the remaining constraints and un-
known dependencies after pruning, e.g., the left four datasets incur
negligible overhead (see Table 3).
5.4.3
Differential Analysis of PolySI. To investigate the contribu-
tions of PolySI’s two major optimizations, we experiment with three
variants: (i) PolySI itself; (ii) PolySI without pruning (P) constraints;
and (iii) PolySI without both compacting (C) and pruning the con-
straints. Figure 10 demonstrates the acceleration produced by each
optimization. Note that the two variants without optimization ex-
hibit (16GB) memory-exhausted runs on TPC-C, which contain
considerably more uncertain dependencies (3628k) and constraints
(386k) without pruning than the other datasets (see Table 3).
5.4.4
Scalability. To assess PolySI’s scalability, we generate trans-
action workloads with one billion keys and one million transactions
with hundreds of millions of operations. We experiment with vary-
ing read proportions and long transaction sizes (up to 450 operations
per transaction). As shown in Figure 11, PolySI consumes less than
40GB memory in all cases and at most 4 hours for checking one
million transactions. We also observe that the time used increases
linearly with larger-sized transactions while the memory overhead
is fairly stable. To conclude, large-sized workloads are quite man-
ageable for PolySI on modern hardware. Note that the competing
checkers, as expected, fail to handle such workloads.
6
DISCUSSION
Fault Injection. We have found SI violations in three production
databases without injecting faults, such as network partition and
clock drift. Since PolySI is an off-the-shelf checker, it is straight-
forward to integrate it into existing testing frameworks with fault

---

injection such as Jepsen [28] and CoFI [12]; both have been demon-
strated to effectively trigger bugs in distributed systems.
Database Schema. In our testing of production databases, we used
a simple, yet effective, database schema adopted by most of black-
box checkers [7, 44, 53, 54]: a two-column table storing key-value
pairs. Extending it to multi-columns or even the column-family
data model could be done by: (i) representing each cell in a table as
a compound key, i.e., “TableName:PrimaryKey:ColumnName”, and a
single value, i.e., the content of the cell [8, 34]; and (ii) utilizing the
compiler in [8] to rewrite (more complex) SQL queries to key-value
read/write operations.
Predicates. To the best of our knowledge, none of the state-of-
the-art black-box checkers [7, 8, 31, 44, 53, 54] considers predicates
nor can they detect predicate-specific anomalies. Given the non-
predicate violations found by PolySI (as well as dbcop [7] and
Elle [31]), we conjecture that more anomalies would arise with
predicates. It is therefore interesting future work to extend our SI
characterization to represent predicates and to explore optimiza-
tions with respect to encoding and pruning.
Unique Value. As demonstrated in our experiments, guaranteeing
“unique value” is a pragmatic, purely black-box technique, and
effective in detecting anomalies. When this assumption is broken,
the complexity of the checking problem would become higher due
to inferring uncertain WR dependencies (a single read may be
related to multiple “false” writes). Accordingly, we could add the
encoding in PolySI for unique existence of WR dependency among
all uncertainties prior to SAT solving.
Optimization for Long Histories. PolySI’s overhead when check-
ing one million transactions with 450 operations per long transac-
tion is manageable for modern hardware. Still, optimizing PolySI for
long transaction histories would help to reduce checking overhead,
especially for online transactional processing workloads. We could
consider periodically taking snapshots (via read-only transactions)
across all sessions in a history using an additional client session.
Such snapshots carry the summary of write dependencies thus far,
which discards prior transactions in the history. As a result, at any
point of time, one only needs to consider a segment of the history
consisting of the latest snapshot and its subsequent transactions.
7
RELATED WORK
Characterizing Snapshot Isolation. Many frameworks and for-
malisms have been developed to characterize SI and its variants.
Berenson et al. [5] considers SI as a multi-version concurrency con-
trol mechanism (described also in Section 2.1). Adya [1] presents
the first formal definition of SI using dependency graphs, which,
as pointed out by [11], still relies on low-level implementation
choices such as how to order start and commit events in trans-
actions. Cerone et al. [10] proposes an axiomatic framework to
declaratively define SI with the dual notions of visibility (what
transactions can observe) and arbitration (the order of installed
versions/values). The follow-up work [11] characterizes SI solely
in terms of Adya’s dependency graphs, requiring no additional
information about transactions. Crooks et al. [17] introduces an
alternative implementation-agnostic formalization of SI and its
variants based on client-observed values read/written.
Driven by black-box testing of SI, we base our GP-based charac-
terization on Cerone and Gotsman’s formal specification [11]. In
particular, our new characterization:
(i) targets the prevalent strong session variant of SI [11, 20], where
sessions, advocated by Terry et al. [45], have been adopted by many
production databases in practice (e.g., DGraph [21], Galera [14],
and CockroachDB [15]);
(ii) does not rely on implementation details such as concurrency
control mechanism as in [5] and timestamps as in [1], and the
operational semantics of the underlying database as in [51], which
are usually invisible to the outsiders; and
(iii) naturally models uncertain dependencies inherent to black-box
testing using generalized constraints (Section 3) and enables the
acceleration of SMT solving by compacting constraints (Section 5.4).
Regarding the comparison with [17], despite its promising char-
acterization of SI suitable for black-box testing, we are unaware of
any checking algorithm based on it. A straightforward (suboptimal)
implementation would require enumerating all permutations of the
transactions in a history, e.g., 10k transactions in our experiment
would require checking 10k-factorial permutations.
Dynamic Checking of SI. This technique determines whether a
collected history from dynamically executing a database satisfies SI.
We are unaware of any black-box SI checker that satisfies SIEGE+.
dbcop [7] is the most efficient black-box SI checker to date. The
underlying checking algorithm runs in time 𝑂(𝑛𝑐), with 𝑛and 𝑐
the number of transactions and clients involved in a single history,
respectively. The authors devise both a polynomial-time algorithm
for checking serializabilty (also with a fixed number of client ses-
sions) and a polynomial-time algorithm for reducing checking SI
to checking serializabilty. However, as demonstrated in Section 5.4,
dbcop is practically not as efficient as our PolySI tool under vari-
ous workloads. Moreover, dbcop is incomplete as it does not check
non-cycle anomalies such as aborted reads and intermediate reads
(Section 4.5). Finally, dbcop provides no details upon a violation;
only a “false” answer is returned.
Elle [31] is a state-of-the-art checker for a variety of isolation
levels, including strong session SI,7 which is part of the Jepsen [28]
testing framework. Elle requires specific data models like lists in
workloads to infer the WW dependencies and specific APIs to per-
form list-specific operations such as “append”. In contrast, PolySI
is compatible with general and production workloads and uses
standard key-value and SQL APIs. Elle builds upon Adya’s formal-
ization of SI [1], thus relying on the start and commit timestamps of
transactions for completeness. Such information may not always be
available, e.g., MongoDB [36] and TiDB [48] have no timestamps in
their logs for read-only transactions. Nonetheless, the underlying
SI characterization for PolySI does not rely on any implementation
details. Finally, Elle’s actual implementation is incomplete8 for effi-
ciency reasons and there are anomalies it cannot detect. We have
confirmed this with the developer [27].
7Despite the claim to support checking strong session SI, we have confirmed with
the developer that Elle does not fulfill this functionality in its latest release [27]. The
developer has fixed the issue by adding the checking of “g-nonadjacent-process”.
8This was “unsound” in the previous version (also in [26, Section 7]). As clarified by
the developer, it is actually “incomplete”.

---

ConsAD [53] is a checker tailored to application servers as op-
posed to black-box databases in our setting. Its SI checking algo-
rithm is also based on dependency graphs. To determine the WW
dependencies, ConsAD enforces the commit order of update trans-
actions using, e.g., artificial SQL queries, to acquire exclusive locks
on the database records, resulting in additional overhead [42, 53].
Moreover, ConsAD is incapable of detecting non-cycle anomalies.
CAT [33] is a dynamic white-box checker for SI (and several
other isolation levels). The current release is restricted to distributed
databases implemented in the Maude formal language [13]. CAT
must capture the internal transaction information, e.g., start/commit
times, during a system run.
8
CONCLUSION
We have presented the design of PolySI, along with a novel char-
acterization of SI using generalized polygraphs. We have estab-
lished the soundness and completeness of our new characterization
and PolySI’s checking algorithm. Moreover, we have demonstrated
PolySI’s effectiveness by reproducing all of 2477 known anomalies
and by finding new violations in three popular production databases,
its efficiency by experimentally showing that it outperforms the
state-of-the-art tools and can scale up to large-sized workloads,
and its generality, operating over a wide range of workloads and
databases of different kinds. Finally, we have leveraged PolySI’s
interpretation algorithm to identify the causes of the violations.
PolySI is the first black-box SI checker that satisfies the SIEGE+
principle. The obvious next step is to apply SMT solving to build
SIEGE+ black-box checkers for other data consistency properties
such as transactional causal consistency [22, 34] and the recently
proposed regular sequential consistency [25]. Moreover, we will
pursue the research directions discussed in Section 6.
ACKNOWLEDGMENTS
We would like to thank the anonymous reviewers for their helpful
feedback. This work was supported by the CCF-Tencent Open Fund
(Tencent RAGR20200201).

---

REFERENCES
[1] Atul Adya. 1999. Weak Consistency: A Generalized Theory and Optimistic Imple-
mentations for Distributed Transactions. Ph.D. Dissertation. USA.
[2] Peter Bailis, Aaron Davidson, Alan Fekete, Ali Ghodsi, Joseph M. Hellerstein, and
Ion Stoica. 2013. Highly Available Transactions: Virtues and Limitations. Proc.
VLDB Endow. 7, 3 (nov 2013), 181–192. https://doi.org/10.14778/2732232.2732237
[3] Peter Bailis, Alan Fekete, Ali Ghodsi, Joseph M. Hellerstein, and Ion Stoica. 2016.
Scalable Atomic Visibility with RAMP Transactions. ACM Trans. Database Syst.
41, 3, Article 15 (jul 2016), 45 pages. https://doi.org/10.1145/2909870
[4] Sam Bayless, Noah Bayless, Holger H. Hoos, and Alan J. Hu. 2015. SAT modulo
Monotonic Theories. In Proceedings of the Twenty-Ninth AAAI Conference on
Artificial Intelligence (AAAI’15). AAAI Press, 3702–3709.
[5] Hal Berenson, Phil Bernstein, Jim Gray, Jim Melton, Elizabeth O’Neil, and Patrick
O’Neil. 1995. A Critique of ANSI SQL Isolation Levels. In SIGMOD ’95. ACM,
1–10. https://doi.org/10.1145/223784.223785
[6] Philip A Bernstein, Vassos Hadzilacos, and Nathan Goodman. 1986. Concurrency
Control and Recovery in Database Systems. Addison-Wesley Longman Publishing
Co., Inc., USA.
[7] Ranadeep Biswas and Constantin Enea. 2019. On the Complexity of Checking
Transactional Consistency. Proc. ACM Program. Lang. 3, OOPSLA, Article 165
(Oct. 2019), 28 pages. https://doi.org/10.1145/3360591
[8] Ranadeep Biswas, Diptanshu Kakwani, Jyothi Vedurada, Constantin Enea, and
Akash Lal. 2021. MonkeyDB: Effectively Testing Correctness under Weak Iso-
lation Levels. Proc. ACM Program. Lang. 5, OOPSLA, Article 132 (oct 2021),
27 pages. https://doi.org/10.1145/3485546
[9] Ahmed Bouajjani, Constantin Enea, Rachid Guerraoui, and Jad Hamza. 2017. On
verifying causal consistency. In POPL’17. ACM, 626–638.
[10] Andrea Cerone, Giovanni Bernardi, and Alexey Gotsman. 2015. A Framework
for Transactional Consistency Models with Atomic Visibility. In CONCUR’15
(LIPIcs), Vol. 42. Schloss Dagstuhl–Leibniz-Zentrum fuer Informatik, 58–71.
[11] Andrea Cerone and Alexey Gotsman. 2018. Analysing Snapshot Isolation. J.
ACM 65, 2, Article 11 (Jan. 2018), 41 pages. https://doi.org/10.1145/3152396
[12] Haicheng Chen, Wensheng Dou, Dong Wang, and Feng Qin. 2020.
CoFI:
Consistency-Guided Fault Injection for Cloud Systems. In ASE 2020. IEEE.
https://doi.org/10.1145/3324884.3416548
[13] Manuel Clavel, Francisco Durán, Steven Eker, Patrick Lincoln, Narciso Martí-
Oliet, José Meseguer, and Carolyn Talcott. 2007. All about Maude - a High-
Performance Logical Framework: How to Specify, Program and Verify Systems in
Rewriting Logic. Springer-Verlag, Berlin, Heidelberg.
[14] MariaDB Galera Cluster. Accessed August, 2022. https://mariadb.com/kb/en/
what-is-mariadb-galera-cluster/.
[15] CockroachDB. Accessed August, 2022. https://www.cockroachlabs.com/.
[16] Thomas H. Cormen, Charles E. Leiserson, Ronald L. Rivest, and Clifford Stein.
2009. Introduction to Algorithms, Third Edition (3rd ed.). The MIT Press.
[17] Natacha Crooks, Youer Pu, Lorenzo Alvisi, and Allen Clement. 2017. Seeing
is Believing: A Client-Centric Specification of Database Isolation. In PODC ’17.
ACM, 73–82. https://doi.org/10.1145/3087801.3087802
[18] Ben Darnell. Accessed August, 2022. Lessons Learned from 2+ Years of Nightly
Jepsen Tests. https://www.cockroachlabs.com/blog/jepsen-tests-lessons/.
[19] Oracle Database. Accessed August, 2022. https://www.oracle.com/database/.
[20] Khuzaima Daudjee and Kenneth Salem. 2006. Lazy Database Replication with
Snapshot Isolation. In VLDB’06. VLDB Endowment, 715–726.
[21] Dgraph. Accessed August, 2022. https://dgraph.io/.
[22] Diego Didona, Rachid Guerraoui, Jingjing Wang, and Willy Zwaenepoel. 2018.
Causal Consistency and Latency Optimality: Friend or Foe? Proc. VLDB Endow.
11, 11 (2018), 1618–1632.
[23] Yifan Gan, Xueyuan Ren, Drew Ripberger, Spyros Blanas, and Yang Wang. 2020.
IsoDiff: Debugging Anomalies Caused by Weak Isolation. Proc. VLDB Endow. 13,
12 (July 2020), 2773–2786. https://doi.org/10.14778/3407790.3407860
[24] Graphviz. Accessed December, 2022. Open source graph visualization software.
https://graphviz.org/.
[25] Jeffrey Helt, Matthew Burke, Amit Levy, and Wyatt Lloyd. 2021. Regular Se-
quential Serializability and Regular Sequential Consistency. In SOSP’21. ACM,
163–179.
[26] Kaile Huang, Si Liu, Zhenge Chen, Hengfeng Wei, David Basin, Haixiang Li,
and Anqun Pan. 2023. Efficient Black-Box Checking of Snapshot Isolation in
Databases. Proc. VLDB Endow. 16, 6 (apr 2023), 1264–1276. https://doi.org/10.
14778/3583140.3583145
[27] Kaile Huang, Si Liu, Zhenge Chen, Hengfeng Wei, David Basin, Haixiang Li, and
Anqun Pan. Accessed December, 2022. Issue #17. https://github.com/jepsen-
io/elle/issues/17.
[28] Jepsen. Accessed August, 2022. https://jepsen.io.
[29] Jepsen. Accessed August, 2022. Issue #824.
https://github.com/YugaByte/
yugabyte-db/issues/824.
[30] Nick Kallen. Accessed August, 2022. Big Data in Real Time at Twitter. https:
//www.infoq.com/presentations/Big-Data-in-Real-Time-at-Twitter/.
[31] Kyle Kingsbury and Peter Alvaro. 2020. Elle: Inferring Isolation Anomalies from
Experimental Observations. Proc. VLDB Endow. 14, 3 (Nov. 2020), 268–280.
[32] Leslie Lamport. 1978. Time, Clocks, and the Ordering of Events in a Distributed
System. Commun. ACM 21, 7 (1978), 558–565.
[33] Si Liu, Peter Csaba Ölveczky, Min Zhang, Qi Wang, and José Meseguer. 2019.
Automatic Analysis of Consistency Properties of Distributed Transaction Systems
in Maude. In TACAS 2019 (LNCS), Vol. 11428. Springer, 40–57.
[34] Wyatt Lloyd, Michael J. Freedman, Michael Kaminsky, and David G. Andersen.
2013. Stronger semantics for low-latency geo-replicated storage. In NSDI’ 13.
USENIX Association, 313–328.
[35] Haonan Lu, Siddhartha Sen, and Wyatt Lloyd. 2020. Performance-Optimal Read-
Only Transactions. In OSDI 2020. USENIX Association, 333–349.
[36] MongoDB. Accessed August, 2022. https://www.mongodb.com/.
[37] Christos H. Papadimitriou. 1979. The Serializability of Concurrent Database
Updates. J. ACM 26, 4 (oct 1979), 631–653. https://doi.org/10.1145/322154.322158
[38] Daniel Peng and Frank Dabek. 2010. Large-Scale Incremental Processing Using
Distributed Transactions and Notifications. In OSDI’10. USENIX Association,
USA, 251–264.
[39] PostgreSQL. Accessed August, 2022. Transaction Isolation.
https://www.
postgresql.org/docs/current/transaction-iso.html.
[40] RUBiS. Accessed August, 2022. Auction Site for e-Commerce Technologies
Benchmarking. https://projects.ow2.org/view/rubis/.
[41] Microsoft SQL Server. Accessed August, 2022. https://www.microsoft.com/en-
us/sql-server/.
[42] Zechao Shang, Jeffrey Xu Yu, and Aaron J. Elmore. 2018. RushMon: Real-Time
Isolation Anomalies Monitoring. In SIGMOD ’18. ACM, 647–662.
https://doi.
org/10.1145/3183713.3196932
[43] Yair Sovran, Russell Power, Marcos K. Aguilera, and Jinyang Li. 2011. Transac-
tional Storage for Geo-Replicated Systems. In SOSP ’11. ACM, 385–400. https:
//doi.org/10.1145/2043556.2043592
[44] Cheng Tan, Changgeng Zhao, Shuai Mu, and Michael Walfish. 2020. COBRA:
Making Transactional Key-Value Stores Verifiably Serializable. In OSDI’20. Article
4, 18 pages.
[45] Douglas B. Terry, Alan J. Demers, Karin Petersen, Mike Spreitzer, Marvin Theimer,
and Brent B. Welch. 1994. Session Guarantees for Weakly Consistent Replicated
Data. In PDIS. IEEE Computer Society, 140–149.
[46] Jepsen testing of MongoDB 4.2.6. Accessed August, 2022.
http://jepsen.io/
analyses/mongodb-4.2.6.
[47] Jepsen testing of TiDB 2.1.7. Accessed August, 2022. https://jepsen.io/analyses/
tidb-2.1.7.
[48] TiDB. Accessed August, 2022. https://en.pingcap.com/tidb/.
[49] TPC. Accessed August, 2022. TPC-C: On-Line Transaction Processing Benchmark.
https://www.tpc.org/tpcc/.
[50] Todd Warszawski and Peter Bailis. 2017. ACIDRain: Concurrency-Related Attacks
on Database-Backed Web Applications. In SIGMOD 2017. ACM, 5–20.
https:
//doi.org/10.1145/3035918.3064037
[51] Shale Xiong, Andrea Cerone, Azalea Raad, and Philippa Gardner. 2020. Data
Consistency in Transactional Storage Systems: A Centralised Semantics. In
ECOOP’20, Vol. 166. 21:1–21:31. https://doi.org/10.4230/LIPIcs.ECOOP.2020.21
[52] YugabyteDB. Accessed August, 2022. https://www.yugabyte.com/.
[53] Kamal Zellag and Bettina Kemme. 2014. Consistency anomalies in multi-tier
architectures: automatic detection and prevention. VLDB J. 23, 1 (2014), 147–172.
https://doi.org/10.1007/s00778-013-0318-x
[54] Rachid Zennou, Ranadeep Biswas, Ahmed Bouajjani, Constantin Enea, and
Mohammed Erradi. 2019. Checking Causal Consistency of Distributed Databases.
In NETYS 2019 (LNCS), Vol. 11704. Springer, 35–51. https://doi.org/10.1007/978-
3-030-31277-0_3

---

A
THE CHECKING ALGORITHM FOR SI
The full version of the checking algorithm is given in Algorithm 2.
In the following, we reference pseudocode lines using the format
algorithm#:line#.
B
PROOFS
B.1
Proof of Theorem 16
Proof. The proof proceeds in two directions.
(“ =⇒”) Suppose that H satisfies SI. By Theorem 6, H satisfies
Int and there exist WR, WW, and RW relations with which H can
be extended to a dependency graph 𝐺such that (SOG ∪WRG ∪
WWG) ; RWG? is acyclic. We show that the generalized polygraph
𝐺′ of H is SI-acyclic by constructing a compatible graph𝐺′′ with𝐺′
such that𝐺′′|R is acyclic when the edge types are ignored: Consider
a constraint ⟨either, or⟩in 𝐺′ and any WW edge 𝑇
WW
−−−−→𝑆in 𝐺. If
(𝑇,𝑆, WW) ∈either, add all the edges in either into 𝐺′′. Otherwise,
add all the edges in or into 𝐺′′.
(“ ⇐= ”) Suppose that H |= Int and the generalized polygraph
𝐺′ of H is SI-acyclic. By Definition 15, there exists a compatible
graph 𝐺′′ with 𝐺′ such that 𝐺′′|R is acyclic when the edge types
are ignored. We show that H satisfies SI by constructing suitable
WR, WW, and RW relations with which H can be extended to a
dependency graph 𝐺such that (SOG ∪WRG ∪WWG) ; RWG?
is acyclic: We simply take 𝐺to be 𝐺′′ by defining, e.g., WW =
{(𝑎,𝑏) | (𝑎,𝑏, WW) ∈𝐸𝐺′′}.
□
B.2
Proof of Theorem 17
Proof. We prove (1) by induction on the number of iterations
of pruning. Consider an arbitrary iteration of pruning P (lines 2:36–
2:68) and denote the generalized polygraphs just before and after
P by 𝐺1 and 𝐺2, respectively. We should show that 𝐺1 is SI-acyclic
if and only if P does not return False from line 2:57 or line 2:65 and
𝐺2 is SI-acyclic. The following proof proceeds in two directions.
(“ =⇒”) Suppose that 𝐺1 is SI-acyclic. We then proceed by
contradiction.
• Suppose that P returns False from line 2:57 or line 2:65. This
happens when some constraint in 𝐺1 constructed based on
two write transactions, say𝑇and 𝑆, on the same key cannot
be resolved appropriately: every compatible graph with the
induced SI graph of 𝐺1 contains a cycle without adjacent
RW edges, no matter whether 𝑇
WW
−−−−→𝑆or 𝑆
WW
−−−−→𝑇is in
it. That is, 𝐺1 is not SI-acyclic. Contradiction.
• Suppose that 𝐺2 is not SI-acyclic. 𝐺1 is not SI-acyclic be-
cause the set of constraints in 𝐺2 is a subset of that in 𝐺1
and P prunes a constraint only if one of its two possibilities
cannot happen. Contradiction.
(“ ⇐= ”) Suppose that P does not return False from line 2:57
or line 2:65 and 𝐺2 is SI-acyclic. Therefore, there exists an acyclic
compatible graph with the induced SI graph of 𝐺2. This is also an
acyclic compatible graph with the induced SI graph of 𝐺1. Hence,
𝐺1 is SI-acyclic.
The second part of the theorem holds because any compatible
graph with the induced SI graph of 𝐺𝑝is also a compatible graph
with the induced SI graph of 𝐺.
□
C
THE INTERPRETATION ALGORITHM
In this section, we describe the interpretation algorithm, called
Interpret, that helps locate the causes of violations found by
PolySI; see Algorithm 3. The algorithm takes as input the undesired
cycles constructed from the log generated by MonoSAT, and outputs
a dependency graph demonstrating the cause of the violation.
It is often difficult to locate the cause of a violation based solely
on the original cycles because the cycles may miss some crucial
information such as the core participating transactions and the
dependencies between transactions. Therefore, Interpret first re-
stores such information from the generalized polygraph of the his-
tory to reproduce the whole violating scenario (line 3:2). This may
bring uncertain dependencies to the resulting polygraph, which
are then resolved via pruning (line 3:3). Finally, Interpret final-
izes the violating scenario by removing any remaining uncertain
dependencies, as they are the “effect” of the violation instead of the
“cause” (line 3:4).
Restore Transactions and Dependencies. The procedure Restore
restores dependencies and the transactions involved in these depen-
dencies in two steps (line 3:6). First, it checks each RW dependency
in the input undesired cycles and restores its associated WW and
WR dependencies if they are missing (lines 3:8 – 3:11). Then, for
each WW dependency in an undesired cycle, it restores the other di-
rection of this WW dependency (if missing) which may be involved
in another undesired cycle (line 3:17 - line 3:34). Now it has recov-
ered the minimal counter example. To help understand the violation
more clearly, it checks each RW dependency in the input undesired
cycles and restore its associated WW and WR dependencies if they
are missing ((line 3:8 – 3:11).
Resolve Uncertain Dependencies. The restored violating scenario
may contain WW and RW dependencies that are still uncertain at
this moment. For an uncertain dependency to be part of the cause
of a violation, it must be resolved. The procedure Resolve resolves
as many uncertain dependencies as possible using the same idea
of pruning (Section 4.3). Specifically, if an uncertain dependency
from either (resp. or) in a constraint would create an undesired
cycle with other certain dependencies, it, along with its associated
dependencies in either (resp. or) is removed and the dependencies
in or (resp. either) become certain (lines 3:42 - 3:48).
Finalize the Violating Scenario. The procedure Finalize finalizes
the violating scenario by removing all the remaining uncertain
dependencies, as they are the “effect” of the violation instead of the
“cause” (line 3:49).
D
CAUSALITY VIOLATIONS FOUND
D.1
A Causality Violation Found in Dgraph
There might be multiple “missing” transactions that together con-
tribute to a violation. As depicted in Figure 12(b), PolySI restores
the potentially involved five transactions (in green) and the associ-
ated dependencies from the original output cycle in Figure 12(a).
In particular, two sub-scenarios are involved: the left subgraph
concerns the RW(656) dependency on key 656 (in blue) while
the right subgraph concerns the dependency WW(402) on key

---

Algorithm 2 The PolySI algorithm for checking SI (the full version)
1: procedure CheckSI(H)
2:
if H̸ |= Int ∨AbortedReads ∨IntermediateReads
3:
return false
4:
CreateKnownGraph(H)
5:
GenerateConstraints(H)
6:
if ¬PruneConstraints()
7:
return false
8:
SAT-Encode()
9:
return MonoSAT-Solve()
10: procedure CreateKnownGraph(H)
11:
for all 𝑇,𝑆∈T such that 𝑇
SO
−−→𝑆
12:
EG ←EG ∪(𝑇,𝑆, SO)
13:
for all 𝑇,𝑆∈T such that 𝑇
WR
−−→𝑆
14:
EG ←EG ∪(𝑇,𝑆, WR)
15: procedure GenerateConstraints(H)
16:
for all x ∈Key
17:
for all 𝑇,𝑆∈WriteTxx such that 𝑇≠𝑆
18:
either ←{(𝑇,𝑆, WW)} ∪
Ð
𝑇′ ∈WR(x) (𝑇)
{(𝑇′,𝑆, RW)}
19:
or ←{(𝑆,𝑇, WW)} ∪
Ð
𝑆′ ∈WR(x) (𝑆)
{(𝑆′,𝑇, RW)}
20:
CG ←CG ∪{⟨either, or⟩}
21: procedure SAT-Encode()
22:
for all v𝑖, v𝑗∈VG such that 𝑖≠𝑗
23:
Create two Boolean variables BV𝑖,𝑗and BVI
𝑖,𝑗
24:
BV ←BV ∪{BV𝑖,𝑗, BVI
𝑖,𝑗}
25:
for all (v𝑖, v𝑗) ∈EG
⊲encode the known graph G
26:
CL ←CL ∪{BV𝑖,𝑗= True}
27:
for all ⟨either, or⟩∈CG
⊲encode the constraints G
28:
CL
←
CL
∪
 Ó
(v𝑖,v𝑗,_) ∈either
BV𝑖,𝑗∧
Ó
(v𝑖,v𝑗,_) ∈or
¬BV𝑖,𝑗

∨
 Ó
(v𝑖,v𝑗,_) ∈or
BV𝑖,𝑗∧
Ó
(v𝑖,v𝑗,_) ∈either
¬BV𝑖,𝑗

29:
Dep ←G|SOG∪WRG∪WWG
30:
EDep ←EDep ∪{(_, _, WW) ∈either ∪or | ⟨either, or⟩∈CG }
31:
AntiDep ←G|RWG
32:
EAntiDep ←EAntiDep ∪{(_, _, RW) ∈either ∪or | ⟨either, or⟩∈CG }
33:
CL ←CL ∪

BVI
𝑖,𝑗=  BV𝑖,𝑗∧(v𝑖, v𝑗, _) ∈EDep
 ∨ Ô
(v𝑖,v𝑘,_) ∈EDep
(v𝑘,v𝑗,_) ∈EAntiDep
BV𝑖,𝑘∧
BV𝑘,𝑗
  v𝑖, v𝑗∈VG

⊲encode the induced SI graph I of G
34: procedure PruneConstraints()
35:
repeat
36:
Dep ←G|SOG∪WRG∪WWG
37:
AntiDep ←G|RWG
38:
KI ←Dep ∪(Dep ; AntiDep)
39:
reachability ←Reachability(KI )
40:
for all cons ←⟨either, or⟩∈CG
41:
for all (from, to, type) ∈either
⊲for the “either” possibility
42:
if type = WW
43:
if (to, from) ∈reachability
44:
CG ←CG \ {cons}
45:
EG ←EG ∪or
46:
break the “for all (from, to, type) ∈either” loop
47:
else
⊲type = RW
48:
for all prec ∈VDep such that (prec, from, _) ∈EDep
49:
if (to, prec) ∈reachability
50:
CG ←CG \ {cons}
51:
EG ←EG ∪or
52:
break the “for all (from, to, type) ∈either” loop
53:
for all (from, to, type) ∈or
⊲for the “or” possibility
54:
if type = WW
55:
if (to, from) ∈reachability
56:
if cons ∉CG
⊲neither “either” nor “or” is possible
57:
return False
58:
CG ←CG \ {cons}
59:
EG ←EG ∪either
60:
break the “for all (from, to, type) ∈or” loop
61:
else
⊲type = RW
62:
for all prec ∈VDep such that (prec, from, _) ∈EDep
63:
if (to, prec) ∈reachability
64:
if cons ∉CG ⊲neither “either” nor “or” is possible
65:
return False
66:
CG ←CG \ {cons}
67:
EG ←EG ∪either
68:
break the “for all (from, to, type) ∈or” loop
69:
until CG remains unchanged
70:
return True
71: procedure MonoSAT-Solve()
72:
solver ←MonoSAT-Solver(BV, CL)
73:
return Solve(solver, I is acyclic)
402 (in red). Following the same procedure as in the MariaDB-
Galera example, PolySI resolves the outstanding dependencies if
no undesired cycles arise; see Figure 12(c). For example, we have
T:(4,172)
WW
−−−−→T:(10,471) (in blue) as there would otherwise be a cy-
cle T:(10,471)
WW
−−−−→T:(4,172)
WR
−−−→T:(10,467)
SO
−−→T:(10,471). The final
violating scenario is shown in Figure 12(d) where two impossible
(dashed) dependencies in Figure 12(c) have been eliminated.
This violation occurs as the causality order is violated, which
is a happens-before relationship between any two transactions in
a given history [32, 34].9 More specifically, transaction T:(9,428)
causally depends on transaction T:(10,471) (via the counterclock-
wise path in the right subgraph) and transaction T:(10,471) causally
9Intuitively, transaction 𝑇causally depends on transaction 𝑆if any of the following
conditions holds: (i) 𝑇and 𝑆are issued in the same session and 𝑆is executed before
𝑇; (ii) 𝑇reads the value written by 𝑆; and (iii) there exists another transaction 𝑅such
that 𝑇causally depends on 𝑅which in turn causally depends on 𝑆.
depends on transaction T:(4,172) (via the clockwise path in the left
subgraph). Hence, transaction T:(9,428) should have fetched the
value 7 of key 656 written by transaction T:(10,471), instead of the
value 3 of transaction T:(4,172), to respect the causality order.
D.2
A Causality Violation Found in YugabyteDB
Figure 13 shows how Algorithm 3 interprets a causality violation
found in YugabyteDB. MonoSAT reports an undesired cycle 𝑇:
(0, 7)
WW(10)
−−−−−−−→𝑇: (1, 15)
WR(13)
−−−−−−−→𝑇: (0, 6)
SO
−−→𝑇: (0, 7);
see Figure 13a. In this scenario, no transactions observe values
that have been causally overwritten; consider the only transaction
𝑇: (0, 6) in Figure 13a that reads. To locate the cause of the causality
violation, PolySI first finds the (only) “missing” transaction𝑇: (0, 9)
(colored in green) and the associated dependencies, as shown in
Figure 13b. The WW and RW dependencies are uncertain at this
moment (represented by dashed arrows), while the WR dependency

---

Algorithm 3 The interpretation algorithm.
H = (T, SO): the original history
𝐺= (V_1, E_1, C_1): the polygraph
C = (V_2, E_2): The cycle found by PolySI
1: procedure Interpret(H,𝐺, C)
2:
Graphrecovered ←Restore(H,𝐺, C)
3:
Graphtagged ←Resolve(Graphrecovered, H,𝐺, C)
4:
Graphfinalized ←Finalize(Graphtagged )
5:
return Graphrecovered, Graphtagged, Graphfinalized
6: procedure Restore(H,𝐺, C)
7:
Graphrecovered ←Find_ACS(C)
8:
for all (𝑢
RW
−−→𝑣) ∈E_2
9:
for all 𝑐∈C_1
10:
if ((𝑢
RW
−−→𝑣) ∈c) ∧(∃𝑤, (𝑤
WW
−−−→𝑣) ∈c)
11:
Graphrecovered ←Graphrecovered ∪{𝑤
WW
−−−→𝑣} ∪{𝑤
WR
−−→𝑢}
12:
return Graphrecovered
13: procedure Find_ACS(Graphacs,𝐺)
14:
graph_size ←number of edges in Graphacs
15:
minimal_extend_deps ←+∞
16:
minimal_acs ←empty
17:
for all dep ∈(E_2 ∩c.𝑒𝑖𝑡ℎ𝑒𝑟), where c ∈C_1
18:
if (∃dep′ ∈c.𝑜𝑟, dep′ ∈Graphrecovered) continue
19:
for all dep′ ∈c.𝑜𝑟
20:
for all ( cycle (V ′, E′) ⊆𝐺) ∧(dep′ ∈E′ )
21:
Graphtested ←Graphrecovered ∪(V ′, E′)
22:
(extendDeps, extendDeps) ←Find_ACS(Graphtested,𝐺)
23:
if extendDeps < minimal_extend_deps
24:
minimal_extend_deps ←extendDeps
25:
minimal_acs ←graphextended
26:
for all dep ∈(E_2 ∩c.𝑜𝑟), where c ∈C_1
27:
if (∃dep′ ∈c.𝑒𝑖𝑡ℎ𝑒𝑟, dep′ ∈Graphrecovered) continue
28:
for all dep′ ∈c.𝑒𝑖𝑡ℎ𝑒𝑟
29:
for all ( cycle (V ′, E′) ⊆𝐺) ∧(dep′ ∈E′ )
30:
Graphtested ←Graphrecovered ∪(V ′, E′)
31:
(extendDeps, extendDeps) ←Find_ACS(Graphtested,𝐺)
32:
if extendDeps < minimal_extend_deps
33:
minimal_extend_deps ←extendDeps
34:
minimal_acs ←graphextended
return (minimal_extend_deps, minimal_acs + graph_size)
35: procedure Resolve(Graphrecovered, H,𝐺, C)
36:
Graphtagged ←Graphrecovered
37:
for all dep ∈Graphtagged
38:
if dep ∈E_1
39:
dep.𝑡𝑎𝑔←‘certain’
40:
else
41:
dep.𝑡𝑎𝑔←‘uncertain’
42:
while Graphtagged was changed in the last loop
43:
for all dep ∈Graphtagged
44:
if (dep.𝑡𝑎𝑔= ‘uncertain’) ∧(dep in a cycle (V ′, E′))
45:
if ∀dep′ ∈E′ ∧dep′ ≠dep, dep′.𝑡𝑎𝑔= certain
46:
dep.𝑡𝑎𝑔←‘uncertain’
47:
for all dep𝑜𝑝𝑝𝑜𝑠𝑖𝑡𝑒, where {dep/dep𝑜𝑝𝑝𝑜𝑠𝑖𝑡𝑒} ∈C_1
48:
dep𝑜𝑝𝑝𝑜𝑠𝑖𝑡𝑒.𝑡𝑎𝑔←‘certain’
return Graphtagged
49: procedure Finalize(Graphtagged)
50:
Graphfinalized ←Graphtagged
51:
for all dep ∈Graphfinalized
52:
if dep.𝑡𝑎𝑔= ‘uncertain’
53:
Graphfinalized ←Graphfinalized \ {dep}
54:
return Graphfinalized
is certain (represented by solid arrows, colored in blue). PolySI
then restores the violating scenario by resolving such uncertainties.
Specifically, as shown in Figure 13c, PolySI determines that𝑊(10, 3)
of transaction 𝑇: (0, 7) was actually installed before 𝑊(10, 26) of
transaction𝑇: (1, 15), i.e.,𝑇: (0, 7)
WW(10)
−−−−−−−→𝑇: (1, 15). Otherwise,
the other direction of dependency 𝑇: (1, 15)
WW(10)
−−−−−−−→𝑇: (0, 7)
would enforce the dependency 𝑇: (0, 9)
RW(10)
−−−−−−−→𝑇: (0, 7), which
would create an undesired cycle with the known dependency 𝑇:
(0, 7)
SO
−−→𝑇: (0, 9). Finally, PolySI finalizes the violating scenario
by removing the remaining uncertainties from Figure 13c to obtain
Figure 13d.
Thanks to the participation of transaction 𝑇: (0, 9), the cause
of the causality violation becomes clear: Transaction 𝑇: (0, 7)
causally depends on transaction 𝑇: (1, 15), via 𝑇: (1, 15)
WR(13)
−−−−−−−→
𝑇: (0, 6)
SO
−−→𝑇: (0, 7). However, transaction 𝑇: (0, 9) following
transaction 𝑇: (0, 7) on the same session reads the value 26 of key
10 from transaction𝑇: (1, 15), which should have been overwritten
by transaction 𝑇: (0, 7).
E
MINIMALITY OF COUNTEREXAMPLES
In this section we show that our interpretation algorithm actu-
ally returns a minimal counterexample which contains the cycle
found by MonoSAT and is just informative to help understand the
violation.
E.1
Definitions
Definition 21. A violation is a polygraph that fails the checking
of PolySI.
Let𝐶be the cycle found by MonoSAT in polygraph𝐺= {𝑉, 𝐸,𝐶𝑜𝑛𝑠}.
Consider the violation 𝑣𝑖𝑜= {𝑉′, 𝐸′,𝐶𝑜𝑛𝑠′} returned by the inter-
pretation algorithm. It satisfies the following properties:
• 𝑣𝑖𝑜⊆𝐺, which means 𝑉′ ⊆𝑉, 𝐸′ ⊆𝐸,𝐶𝑜𝑛𝑠′ ⊆𝐶𝑜𝑛𝑠
• 𝐶⊆𝑣𝑖𝑜.
• 𝑣𝑖𝑜fails the checking of PolySI.
We call 𝑣𝑖𝑜a violation with respect to {𝐺,𝐶}.
Definition 22. A violation 𝑣𝑖𝑜is minimal, if removing any de-
pendency edge from 𝑣𝑖𝑜makes it no longer a violation.
There may be more than one minimal violation with respect
to {𝐺,𝐶}. And we name the one who has the least number of

---

W(443, 10) W(402, 7)
T : (10, 472)
W(402, 6) R(656, 3)
T : (9, 428)
W(656, 7)
T : (10, 471)
WW(402)
RW(656)
SO
(a) Original output
W(443, 10) W(402, 7)
T : (10, 472)
W(402, 6) R(656, 3)
T : (9, 428)
W(656, 7)
T : (10, 471)
W(656, 3) W(753, 1)
T : (4, 172)
R(753, 1)
T : (10, 467)
R(443, 10)
T : (8, 380)
W(248, 11)
T : (8, 383)
R(248, 11)
T : (9, 423)
WW(402)
RW(656)
SO
WR(656)
WR(753)
SO
WR(443)
SO
WR(248)
SO
WW(656)
WW(656)
WW(402)
(b) Missing participants
W(443, 10) W(402, 7)
T : (10, 472)
W(402, 6) R(656, 3)
T : (9, 428)
W(656, 7)
T : (10, 471)
W(656, 3) W(753, 1)
T : (4, 172)
R(753, 1)
T : (10, 467)
R(443, 10)
T : (8, 380)
W(248, 11)
T : (8, 383)
R(248, 11)
T : (9, 423)
WW(402)
RW(656)
SO
WR(656)
WR(753)
SO
WR(443)
SO
WR(248)
SO
WW(656)
WW(656)
WW(402)
(c) Recovered scenario
W(443, 10) W(402, 7)
T : (10, 472)
W(402, 6) R(656, 3)
T : (9, 428)
W(656, 7)
T : (10, 471)
W(656, 3) W(753, 1)
T : (4, 172)
R(753, 1)
T : (10, 467)
R(443, 10)
T : (8, 380)
W(248, 11)
T : (8, 383)
R(248, 11)
T : (9, 423)
WW(402)
RW(656)
SO
WR(656)
WR(753)
SO
WR(443)
SO
WR(248)
SO
WW(656)
(d) Finalized scenario
Figure 12: Causality violation: the SI anomaly found in Dgraph. Dashed and solid arrows represent uncertain and certain
dependencies, respectively. Recovered transactions are colored in green. The core dependencies involved in the two sub-
scenarios are colored in red and blue, respectively.
W(10,3)
T:(0,7)
R(13,21)
T:(0,6)
W(10,26) W(13,21)
T:(1,15)
WW(10)
SO
WR(13)
(a) Original output
W(10,3)
T:(0,7)
R(13,21)
T:(0,6)
W(10,26) W(13,21)
T:(1,15)
R(10,26)
T:(0,9)
WW(10)
SO
WR(13)
SO
WR(10)
RW(10)
WW(10)
(b) Missing participants
W(10,3)
T:(0,7)
R(13,21)
T:(0,6)
W(10,26) W(13,21)
T:(1,15)
R(10,26)
T:(0,9)
WW(10)
SO
WR(13)
SO
WR(10)
RW(10)
WW(10)
(c) Recovered scenario
W(10,3)
T:(0,7)
R(13,21)
T:(0,6)
W(10,26) W(13,21)
T:(1,15)
R(10,26)
T:(0,9)
WW(10)
SO
WR(13)
SO
WR(10)
(d) Finalized scenario
Figure 13: Causality violation: the SI anomaly found in YugabyteDB. The recovered dependencies are colored in blue with
dashed and solid arrows indicating uncertain and certain dependencies, respectively. The (only) missing transaction is colored
in green.
dependencies the minimal counter example with respect to
{𝐺,𝐶}, which we expect to get.
Definition 23. Given a polygraph 𝐺and a cycle 𝐶, there may
be more than one minimal violations based on {𝐺,𝐶}. We name
the one which has the least number of dependencies the minimal
counterexample with respect to {𝐺,𝐶}.
E.2
Patterns of Minimal Counterexamples
A minimal counter example is a special polygraph, which consists
of several cycles. We define a data structure called "adjoining cycle
set", and prove that a minimal counterexample is exactly a minimal
complete adjoining cycle set.
Definition 24. A set of cycles 𝑎𝑐𝑠is called adjoining cycle set,
if ∀cycle 𝐶1 ∈𝑎𝑐𝑠, ∃a constraint 𝑐𝑜𝑛𝑠= {𝑑𝑒𝑝1, .../𝑑𝑒𝑝2, ...} and a
cycle 𝐶2 ∈𝑎𝑐𝑠, s.t. 𝑑𝑒𝑝1 ∈𝐶1 and 𝑑𝑒𝑝2 ∈𝐶2.
• 𝐶1 is the adjoining cycle of 𝐶2, while 𝐶2 is the adjoining
cycle of 𝐶1.
• If ∀constraint 𝑐𝑜𝑛𝑠, the two choice of 𝑐𝑜𝑛𝑠both have de-
pendencies in 𝑎𝑐𝑠or neither have dependencies in 𝑎𝑐𝑠, then
𝑎𝑐𝑠is complete.
Definition 24 describes the data structure called adjoining cycle
set. Figure 14 gives an example of adjoining cycle set. When we
say a adjoining cycle set is complete, it means no more cycles can
be added to the set and each constraint included in the set has
two choices. {𝐶1,𝐶3} is an adjoining cycle set, but it is incomplete
because there exists a constraint (the green one) that has only one

---

choice in {𝐶1,𝐶3}. {𝐶1,𝐶2,𝐶3} is a complete adjoining cycle set,
since each constraint has two choices in {𝐶1,𝐶2.𝐶3}.
C1
C2
C3
Figure 14: Complete and incomplete adjoining cycle sets.
{𝐶1,𝐶2,𝐶3} is a complete adjoining cycle set. {𝐶1,𝐶2} and
{𝐶1,𝐶3} are incomplete cycle sets.
Lemma 25. A minimal violation is exactly a complete adjoining
cycle set.
Proof. If there exists a violation 𝑣𝑖𝑜, which do not contain any
complete adjoining cycle set. It contain at least one incomplete
cycle set 𝑎𝑐𝑠1, because a violation must have at least one cycle. So
there exist a cycle 𝐶1 ∈𝑎𝑐𝑠1 and a constraint 𝑐𝑜𝑛𝑠= {𝑑𝑒𝑝1..., /...},
where 𝑑𝑒𝑝1 ∈𝑎𝑐𝑠1 and all dependencies in the other choice of 𝑐𝑜𝑛𝑠
do not contained by 𝑎𝑐𝑠1. Then we let 𝑐𝑜𝑛𝑠choose the other choice,
and then 𝑑𝑒𝑝1 will disappear and 𝐶1 will not be a cycle any more.
Next we focus on 𝑎𝑐𝑠1 −{𝐶1}, (if 𝑎𝑐𝑠1 has more than one cycle), we
will get another incomplete cycle group 𝑎𝑐𝑠2 = 𝑎𝑐𝑠1 −{𝐶1}. Keep
doing this recurisely, all cycles in 𝑎𝑐𝑠1 will be broken. And this
polygraph will not be a violation.
If there exists two complete adjoining cycle group in 𝑣𝑖𝑜, then
we can delete one complete adjoining cycle group and the left
polygraph is still a violation. So it is not a minimal violation.
In conclusion, a minimal violation 𝑣𝑖𝑜contains exactly one com-
plete adjoining cycle set 𝑎𝑐𝑠. Since both choices of each constraint
are in one cycle, 𝑎𝑐𝑠is a violation that cannot pass the verification
of PolySI. 𝑣𝑖𝑜is a minimal violation, 𝑎𝑐𝑠⊆𝑣𝑖𝑜and 𝑎𝑐𝑠is a violation,
then it is trivial that 𝑣𝑖𝑜= 𝑎𝑐𝑠.
□
Definition 26. A complete adjoining cycle set 𝑎𝑐𝑠is called mini-
mal complete adjoining cycle set containing cycle 𝐶if
• 𝐶∈𝑎𝑐𝑠
• ∀complete adjoining cycle set 𝑎𝑐𝑠′ containing 𝐶, the num-
ber of dependencies in 𝑎𝑐𝑠′ ≥that in 𝑎𝑐𝑠
Theorem 27 (Minimal counterexample). A minimal complete
adjoining cycle set containing cycle 𝐶is exactly the minimal counter
example with respect to {𝐺,𝐶}.
Proof. A minimal complete adjoining cycle set containing 𝐶is
one of complete adjoining cycle sets containing 𝐶which has the
least number of dependencies. By lemma 25, it is the smallest mini-
mal violation containing cycle 𝐶. So it is one of minimal violations
with respect to {𝐺,𝐶}, and has the least number of dependencies.
By definition 23, it is exactly the minimal counter example with
respect to {𝐺,𝐶}.
□
E.3
Restoring Minimal Patterns
The core idea of our interpretation algorithm is to restore the
minimal complete adjoining cycle set containing 𝐶. Function
𝐹𝑖𝑛𝑑_𝐴𝐶𝑆is designed to do this task. (line 3:13)
For each WW or RW dependency in an undesired cycle, it checks
each dependency in the other direction (if missing), and restores the
undesired cycles containing these dependencies (line 3:17 - line 3:34).
Doing this recursively (line 3:22 and line 3:31), the function will
detect all of the adjoining cycle sets that contain Graphacs. The
minimal one will be returned.
The algorithm uses the brute force and sounds inefficient. How-
ever, it works well in practical experiments. From our experience
of verification, when it tries to detect a cycle, there usually exists a
small cycle with only one WW or RW dependency. For example,
in the violation we found in figure 12 a, we first need to find a ad-
joining cycle from the dependency 𝑇: (9, 428) −→𝑇: 10, 471. There
exists a simple cycle 𝑇: (10, 471) −→𝑇: (4, 172) −→𝑇: (10, 467) −→
𝑇: (10, 471). This cycle has a small size and only has one WW
dependency, which means the function does not need to detect
more cycles recursively in order to restore a complete adjoining
cycle set, and can pay no attention to other possible adjoining cycle
sets that contain more than 3 dependencies.
However, there still exist the worst cases that the interpretation
algorithm cannot return the minimal counter example quickly. But
in this case, we can be more patient to wait for it. Since we have
already known the result that there exists a violation, and we just
need to wait for the minimal counter example. And if it still costs
too much time, we can interrupt it and output a minimal violation
we have found instead of the smallest one, after the interpretation
algorithm has run enough time.
Theorem 28 (Minimality). PolySI always returns a minimal
counterexample with respect to 𝐺and 𝐶, with 𝐺the polygraph built
from a history and 𝐶the cycle output by MonoSAT.
Proof. Our interpretation algorithm will return a ‘minimal com-
plete adjoining cycle set’ containing cycle 𝐶, which is exactly the
minimal counter example.
□
Now we have restored the minimal counter example. However,
to help understand the violation, we still restore some more de-
pendencies. For each 𝑟𝑤dependency appears in violations, it is
caused by a 𝑤𝑟dependency and a 𝑤𝑤dependency. If we delete the
𝑤𝑟dependency and 𝑤𝑤dependency, it is difficult to understand
the 𝑟𝑤dependency. So for each 𝑟𝑤dependency in a minimal coun-
terexample, we recover the related 𝑤𝑟and 𝑤𝑤dependencies to the
violation (Alg3:line8-11). This is very useful in our experiments.
For example, in the violation we found in figure 5, the transaction
𝑇: (1, 4) is recovered from two 𝑟𝑤dependencies. Without the
recovered transaction, it is difficult to understand the violation.

---

F
PERFORMANCE EVALUATION OF
POLYSI-LIST
Figure 15 shows the performance evaluation of PolySI-List, the
extension to PolySI for handling Elle-like logs/histories with the
“list” data structure.
10
20
30
0.5
1
1.5
#sessions
Time (s)
(a)
PolySI-List
50
100
150
200
250
1
2
3
#txns/session
Time (s)
(b)
PolySI-List
10
20
30
1
1.5
#ops/txn
Time (s)
(c)
PolySI-List
20
40
60
80
100
0.4
0.6
0.8
1
1.2
read proportion %
Time (s)
(d)
PolySI-List
0.2
0.4
0.6
0.8
1
·104
0.8
1
1.2
1.4
#keys
Time (s)
(e)
PolySI-List
uniform
zipfian
hotspot
0
0.5
1
Time (s)
(f)
PolySI-List
Figure 15: Performance evaluation of PolySI-List.

---

