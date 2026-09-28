# Scheduling Space Expander: An Extension of Concurrency Control for Data Ingestio

> 来源: https://arxiv.org/pdf/2301.10440

Scheduling Space Expander: An Extension of Concurrency
Control for Data Ingestion Queries
Sho Nakazono
NTT Computer and Data Science Laboratories
Tokyo, Japan
syou.nakazono.nu@hco.ntt.co.jp
Hiroyuki Uchiyama
Recruit Co., Ltd.
Tokyo, Japan
hiroyuki-uchiyama@recruit.co.jp
Yasuhiro Fujiwara
NTT Communication Science Laboratories
Kanagawa, Japan
yasuhiro.hujiwara.kh@hco.ntt.co.jp
Hideyuki Kawashima
Faculty of Environment and Information Studies, Keio
University
Kanagawa, Japan
river@sfc.keio.ac.jp
ABSTRACT
With the continuing advances of sensing devices and IoT appli-
cations, database systems needs to process data ingestion queries
that update the sensor data frequently. To process data ingestion
queries with transactional correctness, we propose a novel protocol
extension method, scheduling space expander (SSE). The key idea
of SSE is that we can safely omit an update if the update becomes
outdated and unnecessary. SSE adds another control flow to conven-
tional protocols to test the transactional correctness of an erasing
version order, which assumes that a transactions’ updates are all
outdated and unnecessary. In addition, we present an optimization
of SSE called epoch-based SSE (ESSE), which generates, tests, and
maintains the erasing version order more efficiently than SSE. Our
approach makes the performance of data ingestion queries more
efficient. Experimental results demonstrate that our ESSE exten-
sions of Silo and MVTO improve 2.7× and 2.5× performance on
the TATP benchmark on a 144-core machine, and the extensions
achieved performance comparable to that of the original protocol
for the TPC-C benchmark.
1
INTRODUCTION
Modern internet of things (IoT) or mobile telecommunication ser-
vices use billions of sensors, connected cars, or mobile devices to
ingest the data from these sources continuously through a network.
These services read the real-time ingested data to operate real-world
actuators such as the assembly factory machines, robotic highway
construction markers, or location-based digital signage [7]. This
pair of data ingestion queries and real-time operations is becoming
common process in network service providers. These queries have
long been operated in non-transactional systems such as streaming
databases [13, 19]. However, in recent years, the importance of the
transactional correctness has been studied [1, 28, 39], since reading
Permission to make digital or hard copies of all or part of this work for personal or
classroom use is granted without fee provided that copies are not made or distributed
for profit or commercial advantage and that copies bear this notice and the full citation
on the first page. Copyrights for components of this work owned by others than ACM
must be honored. Abstracting with credit is permitted. To copy otherwise, or republish,
to post on servers or to redistribute to lists, requires prior specific permission and/or a
fee. Request permissions from permissions@acm.org.
Conference’17, July 2017, Washington, DC, USA
© 2023 Association for Computing Machinery.
ACM ISBN 978-x-xxxx-xxxx-x/YY/MM...$15.00
https://doi.org/10.1145/nnnnnnn.nnnnnnn
Silo+ESSE
Silo
MVTO+ESSE
MVTO
20
40
60
80
100
Data ingestion query ratio
1.0
1.5
2.0
2.5
3.0
3.5
4.0
Throughput (txns/s)
1e7
Figure
1:
TATP
benchmark
throughput
with
respect
to the data ingestion query ratio. The percentage of
UPDATE_LOCATION in TATP was varied to represent the data
ingestion query ratio, and the throughput was measured
with 144 worker threads. The original percentage is 14%.
The band of each line indicates the variance in five runs of
the experiment.
inconsistent or outdated data causes a malfunction, accident, or
opportunity loss [6, 7, 28] in real-world actuators.
The Telecom Application Transaction Processing Benchmark
(TATP) [27, 30] is an example of the transactional workload which
includes data ingestion and real-time operation queries. In TATP,
tremendous mobile devices update the subscribers’ current loca-
tions or profiles. Concurrently, telecom base stations read the in-
gested data as the online transaction to operate the migration of
Home Location Register databases. A key feature of data ingestion
queries in TATP is blind updates. It is not read-modify-write; each
mobile device updates its own location information, but it does not
need to read the previous information written by the device itself.
In addition, it is not inserts; we cannot even handle the query as
“unique timestamped inserts”. Although this approach is suitable
for time-series analytical systems, for real-time operations, we need
to guarantee that each data item has only one latest version, and
that the consistent results hold for multiple data items [1, 7, 28].
arXiv:2301.10440v1  [cs.DB]  25 Jan 2023

---

Protocol
Transactional correctness
Omit write operations
Version storage
Timestamp Ordering (T/O) with Thomas Write Rule (TWR)
Not strictly serializable
Yes
1VCC
Silo OCC
Strictly serializable
No
1VCC
Cicada MVTO
Not strictly serializable
No
MVCC
Silo + ESSE
Strictly serializable
Yes
1VCC
MVTO + ESSE
Strictly serializable
Yes
MVCC
Table 1: Differences between conventional protocols and our proposal
Blind update is the most significant difference between our in-
tended applications and traditional applications. Traditional work-
loads such as TPC-C [38], which models wholesale warehouse
management, also generate a large number of writes in the form
of new orders, but these workloads request inserts, not blind up-
dates. Inserts are scalable by partitioning since they write distinct
items, but updates must write to the same data item in principle,
and thus it is difficult to scale. In our experiments, as the rate of
data ingestion queries increases, existing protocols have exhibited
degraded performance for TATP benchmark as shown in Figure 1.
This is because they have to use a lock mechanism to order the
update requests serially into the same data item, to preserve the
transactional correctness. Such serial execution of updates causes
performance degradation. If the throughput becomes less than
the data velocity, we cannot operate the system and services of
IoT/Telecom applications.
To process massive amounts of data in real-time, there exist
methods to omit updates without lock mechanisms by using load
shedding or backpressure[13, 14]. However, these methods do not
have enough guarantee of the transactional correctness. For ex-
ample, when a sensor updates information of two nearby moving
objects but the system omits one of them partially, actuators only
obtain one moving object data and thus some actuators might cause
an accident such as a collision. To guarantee the transactional cor-
rectness, databases need to use concurrency control (CC) protocols.
CC protocols handles the interleaving of concurrent operations
by ensuring the transactional correctness as two essential prop-
erties: serializability (guarantee of consistent data snapshot) [12]
and linearizability (guarantee of non-stale data snapshot) [21]. In
theory, we can decide whether an omission of an update satisfies
the correctness by finding version order [2] related to all update. If
a version order found and its correctness is verified by a protocol,
we can skip locking, buffer updates, and persistent logging while
preserving the transactional correctness. However, to the best of
our knowledge, no existing methods leverage the notion of version
orders. It is because the naïve approach requires the expensive
acyclicity checking of all possible dependency graphs based on all
transactions and all possible version orders, which has been proven
as the NP-Complete problem [12].
In this paper, we propose a versatile protocol extension method,
scheduling space expander (SSE). The contributions of SSE are
threefold.
C1: SSE reduce the verification cost in a polynomial-time by
testing only a single erasing version order which is generated
by SSE’s data structure. With erasing version order, the verifica-
tion needs only for a single subgraph of concurrent transactions.
SSE also keeps a version order and its testing algorithm by con-
ventional protocols; if an erasing version order does not found or
failed correctness testing, then SSE delegates the control flow to
conventional protocols. Thus, SSE can omit updates but does not
directly abort any transaction. It indicates that SSE purely expands
the scheduling space of conventional protocols.
C2: We developed epoch-based SSE (ESSE) to introduce opti-
mizations for SSE. With the epoch framework, ESSE reduces the
number of target transactions in the SSE’s verification and encodes
the footprints of these target transactions into a 64-bits data struc-
ture. As a result, a protocol expanded by ESSE can generate an
erasing version order and execute correctness testing in a latch-free
manner. If a transaction passes the testing, it can omit its write
operations with a bit of atomic operations such as Compare-And-
Swap.
C3: We demonstrated that SSE and ESSE are applicable to vari-
ous protocols. We applied ESSE to two state-of-the-art 1VCC and
MVCC protocols (Silo [11] and Cicada-based MVTO [26]); then,
we evaluated the performance on the TATP, YCSB [5], and TPC-C
benchmarks in a 144-core environment. Figure 1 shows that ESSE
successfully mitigates the performance problem of data ingestion
queries and improved the performance on the TATP benchmark.
This is because ESSE appropriately omitted unnecessary versions,
as illustrated in the experiment (Figure 8c in Section 6.1). In Ta-
ble 1 we present the difference between conventional protocols
and our proposal. ESSE extends various state-of-the-art protocols
such as Silo and MVTO to enable omitting write operations while
presesrving the transactional correctness.
The rest of this paper is organized as follows. Section 2 describes
the preliminaries. Section 3 proposes the notion of safely omit-
table transactions and its correctness testing algorithm. Section 4
presents the scheduling space expander (SSE) scheme, which can
generate safely omittable transactions. Section 5 presents ESSE,
which is the optimization technique for SSE based on the epoch
framework. Section 6 reports our evaluation of the proposed scheme.
Finally, Section 7 describes related work, and Section 8 concludes
the paper.
2
PRELIMINARIES
We mainly use the notations derived from Weikum et al. [12]. Ta-
ble 2 shows frequently used symbols and notations. Let 𝑡𝑖,𝑥𝑖,𝑤𝑖(𝑥𝑖),
and 𝑟𝑖(𝑥𝑗) be 𝑖-th transaction, a version of data item 𝑥, a write op-
eration, and a read operation, respectively. 𝑡𝑖has an ordered set of
operations. 𝑤𝑖(𝑥𝑖) means 𝑡𝑖writes 𝑥𝑖. 𝑟𝑖(𝑥𝑗) means 𝑡𝑖reads 𝑥𝑗. 𝑤𝑠𝑖
2

---

𝑟!(𝑥")
 𝑡!:
𝑡𝑖𝑚𝑒
 𝑡":
𝑡!
𝑡"
Arrival order: 𝑥# < 𝑥!
Generated version order: 𝑥# <$ 𝑥!
𝑤!(𝑥!)
𝑤#(𝑥#)
≪(𝑟𝑤)
≪(𝑤𝑤)
(a) 𝑥2 <𝑣𝑥1: violates serializability
𝑟!(𝑥")
 𝑡!:
𝑡𝑖𝑚𝑒
 𝑡":
≪(𝑤𝑤)
𝑡!
𝑡"
Arrival order: 𝑥# < 𝑥!
Generated version order: 𝑥! <$ 𝑥#
𝑤!(𝑥!)
𝑤#(𝑥#)
(b) 𝑥1 <𝑣𝑥2: safely omittable
𝑤!(𝑥!)
𝑐!
 𝑡!:
𝑡𝑖𝑚𝑒
 𝑡":
𝑤"(𝑥")
Arrival order: 𝑥" < 𝑥!
Generated version order: 𝑥" <# 𝑥!
𝑡!
𝑡"
(c) 𝑥2 <𝑣𝑥1: violates linearizability
𝑤!(𝑥!)
𝑐!
 𝑡!:
𝑡𝑖𝑚𝑒
 𝑡":
𝑤"(𝑥")
𝑡!
𝑡"
Arrival order: 𝑥" < 𝑥!
Generated version order: 𝑥" <# 𝑥!
(d) 𝑥2 <𝑣𝑥1: safely omittable
Figure 2: Examples of schedules with version orders. The dotted operations depicted with wastebaskets omit its versions. Only
cases (b) and (d) has safely omittable transactions (i.e., ensure the transactional correctness of unpublished transactions).
Notation
Definition
𝑡𝑖
𝑖-th transaction; an ordered set of operations
𝑥𝑖
a version of data item 𝑥
𝑤𝑖(𝑥𝑖)
a write operation; 𝑡𝑖writes 𝑥𝑖
𝑟𝑖(𝑥𝑗)
a read operation; 𝑡𝑖reads 𝑥𝑗
𝑐𝑖
a commit operation of 𝑡𝑖
𝑎𝑖
a abort operation of 𝑡𝑖
𝑟𝑠𝑖
a set of versions read by 𝑡𝑖
𝑤𝑠𝑖
a set of versions written by 𝑡𝑖
Table 2: Frequently used symbols and notations
and 𝑟𝑠𝑖represent the set of read and write operations of 𝑡𝑖, respec-
tively. 𝑐𝑖and 𝑎𝑖represents 𝑡𝑖’s termination operation; commits and
aborts, respectively.
2.1
Transactional Correctness
We define the transactional correctness of our intended services
as recoverability [20] and strict serializability [21]. We assume no
transaction reads any value written by uncommitted transactions.
This constraint ensures recoverability. Strict serializability consists
of serializability and linearizability [21]. Serializability is necessary
to provide consistent data snapshots for real-time operations of
our intended IoT/Telecom applications, i.e., readings results with-
out inconsistent or partial updates. Among multiple notions of
serializabilities, we use multiversion view serializability (MVSR)
because this property provides the widest scheduling space [12].
Linearizability refers to the wall-clock ordering constraints among
non-concurrent transactions. If a database has the guarantee of lin-
earizability, it ensures to prevent stale reads and writes, i.e., reading
and writing of outdated versions.
Bernstein et al. proposed the multiversion serialization graph
(MVSG) [2] and proved that a schedule is MVSR if and only if there
exists an acyclic MVSG. An MVSG has nodes for all committed trans-
actions in the schedule. The edges are added by a given schedule
and a version order for the schedule. There are two types of version
orders: version order for a data item and for a schedule. A version
order for a schedule is a union of all version orders for data items.
When 𝑥𝑖precedes 𝑥𝑗in a schedule, we denote 𝑥𝑖<𝑣𝑥𝑗and we
refer it to as a version order for a data item. With a version order
for a schedule, the edges of MVSG are added for each triple of
1In the original MVSG definition [2], all edges were denoted as →, and the version
orders for the schedule and for each data item had the same notation ≪; thus, when
𝑥𝑖preceded 𝑥𝑗, it was denoted as “𝑥𝑖≪𝑥𝑗in ≪.”
distinct operations 𝑤𝑗(𝑥𝑗), 𝑟𝑖(𝑥𝑗), and 𝑤𝑘(𝑥𝑘), where 𝑡𝑖≠𝑡𝑘≠𝑡𝑗.
There are three types of edges: (1) 𝑡𝑗
𝑤𝑟
→𝑡𝑖indicates that 𝑡𝑗writes a
version 𝑥𝑗and 𝑡𝑖reads it. (2) If 𝑥𝑗<𝑣𝑥𝑘, then 𝑡𝑖
≪(𝑟𝑤)
→
𝑡𝑘indicates
that 𝑡𝑖reads a version 𝑥𝑗and its version order precedes 𝑡𝑘’s version
𝑥𝑘. (3) Otherwise, 𝑡𝑘
≪(𝑤𝑤)
→
𝑡𝑗indicates that 𝑡𝑘writes a version 𝑥𝑘
and its version order precedes 𝑡𝑗’s version 𝑥𝑗. Note that the original
notation1 of the MVSG does not include the dependency types for
transaction orders. Of course, Bernstein’s definition has no problem.
However, we introduce the above notations to clarify our proof of
correctness theorems.
2.2
Data Ingestion Queries and Write Omission
Technique
The data ingestion queries are used to aggregate updates from sen-
sors and mobile devices in IoT/Telecom applications. This query has
long been discussed in non-transactional systems such as streaming
databases [13, 14]. The data ingestion query does not need to be
transactional if it ingest data for historical analysis. However, if
the data is used in real-time operations that manipulate real-world
actuators, we need to use CC protocols because such operations re-
quire the transactional correctness [1, 28]. Unfortunately, for write
contended workloads such as data ingestion queries, it has been
studied that existing state-of-the-art CC protocols do not exhibit
high throughput [40, 41] since they need to use locking to satisfy
serializability.
To solve the performance degradation problem on data inges-
tion queries, non-transactional streaming databases uses the write
omission technique such as load shedding [13]. In transaction pro-
cessing, such write omission technique is as known as the Thomas
write rule (TWR) [36], which is an optimization rule for the times-
tamp ordering (T/O) CC protocol. With the TWR, a transaction
can avoid installing a write of a data item 𝑥when the transaction’s
timestamp is less than the 𝑥’s timestamp, which has already been
installed. However, it is unclear whether or not an omission satisfies
the transactional correctness, and it is also unclear whether or not
this rule can apply to other modern protocols.
3
SAFELY OMITTABLE TRANSACTIONS
In this section, we introduce the definition of safe omittable trans-
actions for any protocol to utilize the technique of write omission,
and its validation algorithm with MVSG.
3

---

We first provide the following definition:
Definition 1 (Unpublished). An unpublished transactions is
a transaction which does not execute installing and logging of its write
set into storage.
Definition 2 (Safely Omittable). An unpublished transaction
𝑡𝑗is safely omittable if 𝑐𝑗does not affect the correctness.
The key aspects of the Definition 2 is that the transaction can
commit without publishing its write set. It’s versions must be un-
read by concurrent transactions and also future transactions. There-
fore, 𝑡𝑗is unnecessary for other transactions; we can skip both
buffer updates and persistent logging for safely omittable transac-
tions.
To test whether a transaction 𝑡𝑗is safely omittable, we need to
verify the correctness. It achieved by the notion of MVSG. Specif-
ically, we have to generate a version order for the schedule, and
then test 1) the MVSG’s acyclicity and 2) the wall-clock ordering
among non-concurrent transactions. Figure 2 illustrates these test-
ing with two example schedules and four version orders. Safely
omittable transactions are grayed out and unpublished updates are
marked with a trash box. The pairs of (a)-(b) and (c)-(d) have the
same schedule, but have different version orders and transaction
lifetimes, respectively. These difference result in (b) and (d) include
safely omittable transactions, while (a) violates serializability and
(c) violate linearizability. Note that the operations arrives in order of
wall-clock time depicted as left-to-right, but we draws MVSGs with
version orders that are generated regardless of the arrival order.
Serializability. In (a) and (b), 𝑡1 executes read-modify-write
into 𝑥(reads 𝑥0 and writes 𝑥1 as the next version) and 𝑡2 executes
blind write (writes 𝑥2 as any version) over the same data item. If
we generate a version order 𝑥2 <𝑣𝑥1 and omit 𝑡2 as seen in (a), the
edges of MVSG represent a cycle 𝑡1 →𝑡2 →𝑡1. This is because
𝑡1 read-modify-writes to the just next version of 𝑥0 and thus, any
transaction can place a version as the middle of 𝑥0 and 𝑥1. However,
if we generate a version order 𝑥1 <𝑣𝑥2 as seen in (b), 𝑡1 is safely
omittable since the MVSG has the acyclic form.
Linearizability. In (c) and (d), there exists only blind updates.
Therefore, both MVSGs are edgeless and acyclic. However, if we
generate improper version order and omit wrong versions, data-
base violates linearizability. In the case (c) we generate the version
order 𝑥2 <𝑣𝑥1. This version order does not match the wall-clock
ordering of transactions; 𝑡1 and 𝑡2 are non-concurrent transactions
and thus the order of these transactions’ versions must be 𝑥1 <𝑣𝑥2.
Hereafter, the transactional correctness of database is lost by write
omission.
We can see the rules and limitations for creating safely omittable
transactions from the above examples. Examples (a) and (b) indicate
that there must be at least one blind update [12]. If there is no blind
update but we omit an update, the correctness testing will not pass
regardless of what version order we create. In addition, examples
(c) and (d) indicate that the blind update must be written by a
concurrent transaction. Hence, to create safely omittable versions,
we have three questions that have never been comprehensively
studied to the best of our knowledge:
Q1: How to find concurrent blind updates to generate
a version order?
Index
Indirection
𝑥
𝑦
𝑧
Data Item
𝑥!
𝑥"
𝑥#
𝑦!
𝑧"
𝑧#
Pivot Version
Pivot Version
Pivot Version
Figure 3: Overall structure of SSE implementation.
Q2: How to test the correctness?
In this paper, we package the solutions to these three problems
into a single CC protocol extension called SSE.
4
SSE: SCHEDULING SPACE EXPANDER
In this section, we propose the scheduling space expander (SSE)
which adds another control flow to conventional protocols for gen-
erating safely omittable transactions. SSE solve the problems shown
in the previous section as followings:
A1: SSE selects and manages concurrent blind updates
as the pivot versions to generate an erasing version
order which assumes there exists safely omittable
transactions (Section 4.1).
A2: SSE uses MVSG to test the correctness of erasing
version order efficiently (Section 4.2).
We first introduce an erasing version order, which is a version
order generated by SSE to reduce the computational cost of the
correctness testing (Section 4.1). We next outline how tests an
erasing version order (Section 4.2). We then show the SSE’s control
flow to expand a protocol and improve its performance on data
ingestion queries (Section 4.3).
4.1
SSE’s Version Order Generation
The serializability theory indicates a write is safely omittable if
there exists a version order which draws acyclic MVSG. However,
it is impractical to try the testing with all possible version orders
since the testing with all version orders is proven as NP-complete [2,
12, 31]. To perform the test efficiently, SSE incorporates heuristic
restrictions in generating candidate version orders. When an active
transaction 𝑡𝑗arrives, SSE generates an erasing version order. It
is a version order which assumes that all writes in 𝑡𝑗are safely
omittable. Formally, an erasing version order satisfies the following
three conditions: (1) SSE changes the version order only for data
items that 𝑡𝑗is updating. From this condition, SSE’s correctness
testing can focus on the MVSG’s subsets that include the node of
𝑡𝑗; if correctness is violated, it will be due to a change of a version
order for a data item related to 𝑤𝑠𝑗. (2) Each version 𝑥𝑗is the just
before version of a blind update. We add this condition to hold
the unread condition of safely omittable versions; the non-latest
versions become stale and not requested by subsequent transactions.
In addition, we enforce that the following version must be blind
update. As described at Figure 2-(a) in Section 3, if 𝑥𝑗is placed on
the middle of read-modify-write, then MVSG always become cyclic.
4

---

As a concrete way to create an erasing version order, SSE selects
a blind update as pivot version for each data item. A pivot version is
a landmark for generating the erasing version order; it tells other
transactions to “place your version just before this pivot version”.
For example, in SSE, a transaction 𝑡𝑗generates an erasing version
order such that all its versions are located immediately before the
pivot versions. If there exists pivot versions 𝑥𝑝𝑣,𝑦𝑝𝑣, ..., then 𝑡𝑗
creates an erasing version order 𝑥𝑗<𝑣𝑥𝑝𝑣,𝑦𝑗<𝑣𝑦𝑝𝑣. Figure 3
shows the overall structure of our prototype implementation of
the pivot versions. We implemented the pivot versions by adding
a single indirect reference for each data item. We assume that
database has a tree-like index, and that every data item is accessed
from its leaf nodes. In SSE, every index leaf node has a pointer to a
pivot version, which is the indirection object to data item. Each data
item is represented as a singly linked list starting from the pivot
version. SSE completes the correctness testing of erasing version
order only with pivot versions; a pivot version includes footprints
of reachable transactions, as described in the later Section 4.2.
4.2
Correctness Testing
With an erasing version order, SSE tests the transactional correct-
ness efficiently. To test serializability, it is sufficient to test only the
MVSG paths that include a node of 𝑡𝑗. To ensure linearizability, all
of 𝑡𝑗’s reachable nodes that appear in the serializability test must
be concurrent with 𝑡𝑗. We define two types of node sets, successors,
and overwriters (abbreviate as 𝑠𝑗and 𝑜𝑗), in accordance with the
outgoing edge from 𝑡𝑗as follows:
Definition 3 (Type of Reachable Transactions). For the
transactions directly reachable from a transaction 𝑡𝑗, we define the
following two sets:
𝑠𝑗:= {𝑡𝑘|𝑡𝑗
≪(𝑤𝑤)
→
𝑡𝑘}, 𝑜𝑗:= {𝑡𝑘|𝑡𝑗
≪(𝑟𝑤)
→
𝑡𝑘}
The following theorem is derived from this definition:
Theorem 1 (Directly Reachable Transactions). If a schedule
satisfies recoverability and an edge 𝑡𝑗→𝑡𝑘exists, then the directly
reachable transaction 𝑡𝑘is in either 𝑜𝑗or 𝑠𝑗.
Proof. An MVSG has only three types of edges:𝑡𝑗
𝑤𝑟
→𝑡𝑘,𝑡𝑗
≪(𝑟𝑤)
→
𝑡𝑘, and 𝑡𝑗
≪(𝑤𝑤)
→
𝑡𝑘. Because recoverability is satisfied and 𝑡𝑗is
active, edge 𝑡𝑗
𝑤𝑟
→𝑡𝑘does not exist.
□
From Theorem 1, SSE can test correctness by testing all paths
starting from these two sets of transactions. Therefore, SSE sepa-
rates the procedure of correctness testing into two sub-testings as
described below.
Testing of successors. No studies have focused on the testing
of successors because conventional protocols always write the in-
coming 𝑡𝑗’s versions as the latest versions, so the set of successors
is empty. Algorithm 1 provides a testing procedure for 𝑠𝑗. Let 𝑟𝑠𝑖
be a set of versions read by 𝑡𝑖, and let 𝑤𝑠𝑖be a set of versions
wrtten by 𝑡𝑖. In step (A), it collects transactions that are included
in or reachable from 𝑠𝑗. In step (B), for linearizability, it tests the
concurrency between 𝑡𝑗and each transaction 𝑡𝑚in the collected
transactions. In steps (C) and (D), the algorithm tests serializability.
Because each 𝑡𝑚is a transaction included in or reachable from 𝑠𝑗, a
Algorithm 1: Correctness testing for 𝑠𝑗
Input: 𝑡𝑗
Output: whether or not 𝑐𝑗keeps serializability
1 𝑇:= {𝑡𝑘,𝑡𝑖|𝑡𝑘∈𝑠𝑗∧𝑡𝑖is reachable from 𝑡𝑘in MVSG }
// (A)
2 forall 𝑡𝑚in 𝑇do
3
if 𝑡𝑚commits before 𝑡𝑗’s beginning then
// (B)
4
return strict serializability is not satisfied
5
forall 𝑦𝑚in 𝑤𝑠𝑚do
6
forall 𝑦𝑛in 𝑟𝑠𝑗do
7
if 𝑦𝑚= 𝑦𝑛then
// (C)
𝑤𝑟
→
to 𝑡𝑗
8
return MVSG is cyclic
9
forall 𝑦𝑔in 𝑟𝑠𝑚do
10
forall 𝑦𝑗in 𝑤𝑠𝑗do
11
if 𝑦𝑔<𝑣𝑦𝑗then
// (D)
≪(𝑟𝑤)
→
to 𝑡𝑗
12
return MVSG is cyclic
13 return MVSG is acyclic
path 𝑡𝑗
≪(𝑤𝑤)
→
..., →𝑡𝑚already exists. Therefore, if there is no path
𝑡𝑚→𝑡𝑗for each 𝑡𝑚, the MVSG is acyclic; steps (C) and (D) thus fo-
cus on the last such edge 𝑡𝑚→𝑡𝑗. Note that transaction 𝑡𝑚does not
have a path 𝑡𝑚
≪(𝑤𝑤)
→
𝑡𝑗. This type of edge is added to the MVSG
only if some committed transactions read some version in 𝑤𝑠𝑗, and
such a read operation is not permitted to enforce recoverability;
because 𝑡𝑗is an active transaction, no committed transaction can
read version 𝑥𝑗. Therefore, we only need to check the types of the
last edges 𝑡𝑚
𝑤𝑟
→𝑡𝑗and 𝑡𝑚
≪(𝑟𝑤)
→
𝑡𝑗. Accordingly, in step (C), the al-
gorithm checks the last edges 𝑡𝑚
𝑤𝑟
→𝑡𝑗. It checks whether 𝑦𝑛in 𝑟𝑠𝑗
is the same with 𝑦𝑚in 𝑤𝑠𝑚. This is because, if this condition holds,
then there exists a cyclic path 𝑡𝑗
≪(𝑤𝑤)
→
... →𝑡𝑚
𝑤𝑟
→𝑡𝑗. Similarly,
in step (D), the algorithm checks the last edges 𝑡𝑚
≪(𝑟𝑤)
→
𝑡𝑗by con-
firming that there exists𝑦𝑗in 𝑤𝑠𝑗that is newer than𝑦𝑔in 𝑟𝑠𝑚. This
is because there exists a cyclic path 𝑡𝑗
≪(𝑤𝑤)
→
... →𝑡𝑚
≪(𝑟𝑤)
→
𝑡𝑗if
the condition holds. Consequently, if the testing of steps (C) and
(D) are passed, then no transaction in 𝑠𝑗can reach 𝑡𝑗.
Testing of overwriters. The detailed algorithms of this subsets
are beyond the scope of this paper since we can use existing al-
gorithms, such as anti-dependency validation, from conventional
protocols. For example, Silo [11] has one of the simplest approaches:
it checks 𝑜𝑗= 𝜙by testing whether each version in 𝑟𝑠𝑗has been
overwritten and a newer version exists. If both testings of succes-
sors and overwriters are succeeded, we can commit 𝑡𝑗without
any correctness violation since 𝑡𝑗’s all write operations are safely
omittable.
An important fact is that the set of transactions 𝑡𝑝𝑣that wrote the
pivot versions, is equivalent to the successors,𝑠𝑗. This is because the
pivot versions are the just next versions for 𝑡𝑗’s updates. Therefore,
we can implement the Algorithm 1 by using the read/write sets of
the transactions 𝑡𝑚, that includes 𝑡𝑝𝑣and reachable transactions
from some 𝑡𝑝𝑣. To this end, each pivot version hold the footprints
of transactions that have read or written a version greater than or
equal to this pivot version.
5

---

Request to commit 𝑡!
Commit 𝑡!
Abort 𝑡!
Generate SSE’s erasing version order
𝑡! and related txns are concurrent
MVSG is acyclic
Omit all 𝑡!’s writes
Conventional protocols
Serializability testing
Linearizability testing
SSE’s version order
violates correctness
true
false
Some pivot version is not found
Figure 4: Control flow of SSE with conventional protocols.
4.3
Control Flow
We revealed that an erasing version order helps to confirm that a
write is safely omittable, and we also revealed the algorithm to test
it. The next challenge is how to apply this version order and testing
algorithm to conventional CC protocols. It is desirable for us not
to change the performance characteristics and the specifications
of conventional CC protocols drastically. However, if we simply
change a conventional protocol to generate an erasing version order,
the changed protocol will be useless; since erasing version order
always try to write non-latest versions, we would not successfully
update the latest versions. Even if contended updates occur into
the same data item, practical applications need to update the latest
version periodically. Rather than such changes, we propose SSE,
an extension method that purely extends the scheduling space of
conventional protocols. SSE is not a protocol, but an extension of
the protocol; instead of changing the version order and correct-
ness testing algorithms of conventional protocols, SSE adds erasing
version order and tests its correctness independently.
Figure 4 shows the control flow of an extended protocol. SSE
starts its processing upon the commit request of an active trans-
action 𝑡𝑗. In the first step, SSE generates an erasing version order
as described in Section 4.1. If any version order is not be found,
SSE delegates the processing of 𝑡𝑗to a conventional protocol. If an
erasing version order is found, SSE then checks correctness. For
linearizability, it checks concurrency between 𝑡𝑗and all related
transactions. For serializability, it checks whether MVSG has no
cycle. If both tests are passed, SSE omits all of 𝑡𝑗’s versions and
commits 𝑡𝑗. Otherwise, it delegates the processing of 𝑡𝑗to a conven-
tional protocol. Note that SSE does not change the version order
generated by the conventional protocol, and SSE can commit 𝑡𝑗
but does not directly abort 𝑡𝑗. Even if SSE cannot commit 𝑡𝑗with
its erasing version order, it may be possible to commit 𝑡𝑗with a
version order from the conventional protocol. It indicates that SSE
purely expands the scheduling space of conventional protocols.
In the best case, we can omit updates of 𝑡𝑗only by accessing
the pivot versions since these indirection data structures have all
the necessary data for correctness testing. Otherwise, if an update
𝑤𝑗(𝑥𝑗) does not find a pivot version of 𝑥or some testing fails,
then we delegate the control and quit to execute testing of SSE.
In this case, pivot versions have almost negligible overhead for
conventional protocols; it adds only a single indirection references
for each data item.
5
ESSE: EPOCH-BASED SSE
In this section we introduce the optimization method of SSE, called
epoch-based SSE (ESSE). We first explain that the naïve imple-
mentation of SSE has performance problems in the correctness
testing of successors. As described in Section 3, this testing requires
both a read set (𝑟𝑠𝑚) and a write set (𝑤𝑠𝑚) for all reachable trans-
actions 𝑡𝑚; it leads a huge overhead. Specifically, in step (A) of
Algorithm 1, the memory consumption from the footprints 𝑟𝑠𝑚
and 𝑤𝑠𝑚increases as the number of testing target transactions
𝑡𝑚increases. In addition, steps (C) and (D) have the synchroniza-
tion problem: footprints 𝑟𝑠𝑚and 𝑤𝑠𝑚must be a concurrent data
structure to commit transactions in parallel.
To solve these two performance problems, we propose ESSE,
which is an optimized SSE implementation using epoch-based group
commits [4, 11]. An epoch-based group commit divides the wall-
clock time into epochs and assigns each transaction to an epoch.
The commit operations for the transactions in an epoch are simul-
taneously delayed. Because they have the same commit point, they
can be regarded as concurrent, whereas transactions in different
epochs are not concurrent. ESSE heavily utilizes this nature of con-
currency in epochs. Specifically, ESSE selects pivot versions as the
first blind updates of data items for each epoch. Then the lineariz-
ability testing become simple; we can test it easily by checking that
the pivot versions are written in the same epoch with 𝑡𝑗’s one. This
tight coupling of epochs and pivot versions helps to mitigate the
former performance problem of SSE, the huge memory consump-
tion. There is no need to retain the footprints of the transactions in
old epochs because SSE fails the linearizability testing before the
serializability testing for these transactions.
ESSE also includes two optimizations, as follows. (1) It creates an
optimization rule by using epochs to reduce the number of testing
target transactions 𝑡𝑚(Section 5.1). (2) It provides a reachability
flag for testing of successors efficiently; it is a latch-free imple-
mentation of SSE’s pivot versions to solve the latter performance
problem of SSE, the necessity of synchronization (Section 5.2). After
these explanation of ESSE, we show the actual application of ESSE
to conventional protocols, and explain what kind of protocols are
preferable for ESSE (Section 5.3).
5.1
Optimization Rule
To reduce the number of testing target transactions, we add the
optimization rules by using ESSE’s pivot versions. For an epoch, we
define a set of pivot versions as a pivot barrier. Using the pivot
barrier, we obtain the following theorem, which provides important
properties for reducing the target transactions.
Theorem 2 (Pivot Barrier Violation). Let𝑡𝑗be an active trans-
action in epoch 𝑒1, attempting to commit on ESSE. Let 𝑒𝑡1 be the trans-
actions that wrote the pivot barrier (pivot versions in the epoch) of
𝑒1. The correctness testing of 𝑠𝑢𝑐𝑐𝑒𝑠𝑠𝑜𝑟𝑠𝑗passes if 𝑡𝑗is not reachable
from any transaction in 𝑒𝑡1.
Proof. To prove by contradiction, we first assume that no trans-
action exists that satisfies both conditions of Theorem 2 and that the
6

---

𝑥"
𝑥#$ in 𝑒&
𝑥&
𝑥'
<$
<$
𝑦*
𝑦#$ in 𝑒&
𝑦'
<$
Epoch 1 𝒆𝟏
Epoch 2 𝒆𝟐
𝑥.
𝑥#$ in 𝑒"
<$
…
Pivot barrier of 𝑒&
Pivot barrier of 𝑒"
Figure 5: Pivot versions and pivot barriers of two epochs.
All versions are not omittable and installed in memory. An
epoch’s pivot barrier consists of its pivot versions. The gray
boxes depict the pivot versions, and the dashed lines depict
the pivot barriers of each epoch. 𝑡3 fails SSE’s correctness
testing and installs versions for both the right and left side
of the pivot barrier. Such a transaction causes an MVSG cycle
for subsequent transactions.
testing of 𝑠𝑢𝑐𝑐𝑒𝑠𝑠𝑜𝑟𝑠𝑗detects an MVSG cycle. Because the MVSG
has a cycle, there exists a transaction 𝑡𝑖from which 𝑡𝑗is directly
reachable, which satisfies the direct reachability condition in The-
orem 2. By the assumption, 𝑡𝑖does not satisfy the right side of
the pivot barrier condition; thus, 𝑡𝑖is not reachable from any 𝑡𝑝𝑣.
Therefore, the MVSG cycle is completed by the left side of the
pivot barrier in the form 𝑡𝑗→..., →𝑡𝑖→𝑡𝑗→𝑡𝑝𝑣. We focus
on the first edge outgoing from 𝑡𝑗. Because all versions in 𝑤𝑠𝑗are
immediate predecessors of the pivot versions, no transaction can
write a version that is larger than a version belonging to 𝑡𝑗but
smaller than the pivot version. Therefore, to form the cycle on the
left side of the pivot barrier, the type of edge in the cycle outgoing
from 𝑡𝑗must not be
≪(𝑤𝑤)
→
. In addition, the type of edge must
not be
𝑤𝑟
→since 𝑡𝑗is an active transaction and it is attempting to
omit its writes. Therefore, the edge type must be
≪(𝑟𝑤)
→
. Then,
from Theorem 1 and the assumption, 𝑡𝑖is not in 𝑠𝑢𝑐𝑐𝑒𝑠𝑠𝑜𝑟𝑠𝑗and
its reachable transactions. Therefore, 𝑡𝑖is not a target transaction
of the correctness testing of 𝑠𝑢𝑐𝑐𝑒𝑠𝑠𝑜𝑟𝑠𝑗, and 𝑡𝑗cannot detect an
MVSG cycle.
□
Theorem 2 clarifies the type of transactions introducing MVSG
cycles during the testing of successors. Because an MVSG cycle
always includes the transactions that read or write a version on
the right side of the pivot barrier and that 𝑡𝑗is reachable from,
ESSE only needs to store the footprints of such transactions. If 𝑡𝑗
detects the existence of such transactions in the saved footprints,
ESSE does not commit 𝑡𝑗; on the contrary, the existence of other
transactions does not matter for 𝑡𝑗. Therefore, we only need to
manage the footprints of transactions that satisfy the two conditions
in Theorem 2. Specifically, we store the footprints of transactions
that satisfy the first condition (right side of pivot barrier) since we
cannot test whether a transaction satisfies the second condition
without incoming transaction 𝑡𝑗. Transactions that satisfy the first
64 bits
MergedRS
(mRS)
16 bits
16 bits
32 bits
Epoch of pivot version
MergedWS
(mWS)
Figure 6: Layout of a reachability tracker
y
x
z
…
𝑤! 𝑥!
𝑤"(𝑦"), 𝑤"(𝑧")
ℎ𝑎𝑠ℎ
16 bits
Figure 7: An example of mergedWS
condition assumes that they are reachable to incoming 𝑡𝑗and thus
they store their read/write sets into pivot version.
Figure 5 shows examples of pivot versions and their version
order in each epoch. All versions are installed in shared memory,
and all transactions 𝑡1,𝑡2,𝑡3,𝑡4, and 𝑡5 are committed. Let 𝑡𝑗be an
active transaction that belongs to epoch 𝑒1 and requests to write 𝑥𝑗
and 𝑦𝑗. For 𝑡𝑗’s correctness testing of successors, the existence of
𝑡3 is essential: because 𝑡3 satisfies both the right-side and directly
reachable conditions in Theorem 2, it generates a cycle in the MVSG
and violates serializability in committing 𝑡𝑗with ESSE’s erasing
version order. Therefore, before committing 𝑡𝑗, ESSE has to detect
such an MVSG cycle from the footprint of 𝑡3. In contrast, because
𝑡1 does not satisfy the right-side condition, by Theorem 2, it is
unnecessary to save its footprint. In addition, by using epochs, ESSE
reduces the number of necessary footprints and enables periodic
garbage collection. There is no need to manage the pivot versions
and pivot barriers of old epochs. Specifically, by linearizability, it is
unnecessary to manage the footprints of any transactions except 𝑡5
after all of 𝑒1’s transactions are terminated; after 𝑒1 finishes, we do
not start any transactions belonging to 𝑒1, and it is thus unnecessary
to manage the pivot versions and footprints of 𝑒1.
5.2
Latch-free Implementation
In ESSE, a pivot version for each data item is represented as a
reachability tracker, which is a 64-bit data structure. It is the
detailed implementation of the pivot version as described in Figure 3.
A reachability tracker consists of an epoch and two fields (MergedRS
and MergedWS). Figure 6 shows the reachability tracker’s layout.
• Epoch. This field stores the epoch of the pivot version as a
32-bit integer. Each transaction fetches and assigns its own
epoch from the global epoch at the beginning of the trans-
action. When a transaction executes a blind update and it
becomes a pivot version, ESSE stores the transaction’s epoch
to this field. This field is used for the correctness testing. Lin-
earizability is satisfied if the epochs of all collected reachabil-
ity trackers have the same epoch as the active transaction’s
epoch.
7

---

Algorithm 2: Correctness testing for 𝑠𝑢𝑐𝑐𝑒𝑠𝑠𝑜𝑟𝑠𝑗by using
reachability trackers
Input: 𝑡𝑗
Output: whether or not 𝑐𝑗keeps serializability
1 forall 𝑥𝑗in 𝑤𝑠𝑗do
2
RT := get_reachability_tracker_of(𝑥)
// (A)
3
if RT.epoch ≠𝑡𝑗’s epoch then
4
return strict serializability is not satisfied
// (B)
5
if any key in 𝑟𝑠𝑗exists in RT.mWS then
// (C)
6
return MVSG may not be acyclic
7
if any key in 𝑤𝑠𝑗exists in RT.mRS then
// (D)
8
return MVSG may not be acyclic
9 return strict serializability is satisfied
• MergedRS (mRS) and MergedWS (mWS). These fields
represent 16-bit bloom filters. Each filter stores all footprints
of the transactions that satisfy the two conditions in Theo-
rem 2; it stores the union of the keys of the read or write set
for all transactions that read or write the greater or equal
versions of pivot versions. Figure 7 illustrates an example
layout of the mWS. Each data item 𝑥,𝑦,𝑧is mapped into
the corresponding slot by a hash function ℎ. ESSE uses this
structure to test the serializability of successors.
The reachability tracker encapsulates the functionalities of the
SSE’s pivot version into the 64-bit data structure; it has a scheme
for transactions’ concurrency detector and footprints for reachable
transactions. Through this compression, ESSE accesses the reacha-
bility trackers in a latch-free manner by using atomic operations
such as a compare-and-swap (CAS).
Algorithm 2 is a detailed implementation of Algorithm 1 that is
based on using reachability trackers. All steps (A-D) are equivalent
in the two algorithms. In step (A), it collects the reachability trackers
for the data items in the 𝑤𝑠𝑗in order to generate erasing version
order. In step (B), the algorithm checks linearizability by testing
whether 𝑡𝑗and the reachability trackers have the same epoch. If it
detects different epochs, the correctness testing for linearizability
fails. In steps (C) and (D), the algorithm checks serializability by
testing whether 𝑡𝑗has an incoming edge. The reachability tracker
exploits the bloom filter and thus it may produce false positives
though it produces no false negatives. When a hash function assigns
different keys to the same slot, it may return that a non-existent
cycle exists.
To use reachability trackers for correctness testing, we need to
update them to maintain the MergedRS/WS of reachable transac-
tions from the pivot version. Thus, we add this updating before the
commit of each transaction. Algorithm 3 describes the ESSE commit
protocol2 of an active transaction 𝑡𝑗. In step (1), it tests the strict
serializability of the 𝑜𝑗and 𝑠𝑗sets. If the testing fails, the algorithm
quits processing 𝑐𝑗by using ESSE’s version order and delegates
subsequent processing to conventional protocols. In step (2), if 𝑡𝑗
does not satisfy the conditions of Theorem 2, ESSE does not store a
footprint. Otherwise, ESSE stores 𝑡𝑗’s footprint in the reachability
2Here, the “commit protocol” refers to the processing at the time when a user applica-
tion does not add any operation into the transaction. It does not refer to the “commit
phase” in optimistic concurrency control (OCC).
Algorithm 3: Commit protocol of ESSE
Input: 𝑡𝑗
Output: commit or abort
1 𝑡𝑗.omittable := true
2 # Begin atomic section
3 if no write of 𝑡𝑗is a blind update then
4
𝑡𝑗.omittable := false
5 if correctness testing fails then
6
𝑡𝑗.omittable := false
// (1)
7 if 𝑡𝑗.omittable == false then
8
# Try the conventional protocol
9
if the conventional protocol aborts 𝑡𝑗then
10
return abort
11 if 𝑡𝑗satisfies the first conditions of Theorem 2 then
// (2)
12
forall 𝑥𝑖in 𝑟𝑠𝑗do
13
RT := get_reachability_tracker_of(𝑥)
14
RT.mRS.merge(𝑟𝑠𝑗.keys)
15
RT.mWS.merge(𝑤𝑠𝑗.keys)
// (3)
16
forall 𝑥𝑗in 𝑤𝑠𝑗do
17
RT := get_reachability_tracker_of(𝑥)
18
if RT.epoch ≠𝑡𝑗.epoch then
19
if 𝑤𝑗(𝑥𝑗) is blind update then
// (4)
20
RT.epoch := 𝑡𝑗.epoch
21
init RT.mRS with 𝑟𝑠𝑗
22
init RT.mWS with 𝑤𝑠𝑗
23
else
24
RT.mRS.set(𝑟𝑠𝑗.keys)
25
RT.mWS.set(𝑤𝑠𝑗.keys)
// (5)
26 # End atomic section
27 if 𝑡𝑗.omittable then
28
clear(𝑤𝑠𝑗)
29 return commit
trackers. In step (3), it stores all edges from the pivot barrier to 𝑡𝑗
to the mergedRS of the data item. Specifically, the algorithm sets a
bit flag in mergedRS and mergedWS for each data item in 𝑟𝑠𝑗and
𝑤𝑠𝑗, respectively. It also sets bit flags for all bits in the reachability
trackers of 𝑟𝑠𝑗. In step (4), it updates the mergedWS. If 𝑥𝑗is the first
blind update of the epoch, the algorithm resets the pivot version
of data item 𝑥to 𝑥𝑗. Otherwise, it adds 𝑡𝑗’s footprint and all edges
from the versions in the pivot barrier to the mergedWS of the data
item. Note that steps (3) and (5) merge the bits in mRS/mWS of
reachability trackers accessed by 𝑡𝑗to keep reachability from the
pivot versions; when 𝑡𝑗accesses 𝑥and 𝑦and commits, there exist
paths from the pivot versions of 𝑥and 𝑦to 𝑡𝑗respectively, and thus
reachability trackers of both data items should store these paths by
merging.
Throughout the algorithm, we access the reachability trackers
atomically in a latch-free manner by using the 64-bit data layout.
ESSE copies all reachability trackers to another location at the
beginning of the commit protocol. After testing and modification of
mRS/mWS, it performs the CAS operation for all locations to update
8

---

Protocol
Epoch-based group commit
Read/Write set
Testing method of overwriters
Optimistic CC
Silo OCC
Yes
Yes
Yes
Yes
Cicada MVTO
No
Yes
No
Yes
2PL
No
No
No
No
Required for ESSE
Yes
Yes
Yes
Preferable
Table 3: A list of components required by ESSE, and the comparison of protocols. In order to extend a protocol with ESSE,
we need to add lacking components. Although OCC is not a requirement, it is a preferable property for ESSE in terms of
performance.
all fields atomically. If a CAS operation fails, ESSE retries the commit
protocol from the beginning. If the bit arrays in the reachability
tracker match exactly before and after the modifications, we can
guarantee atomicity in a lightweight way via load instead of CAS
to verify that no changes occurred concurrently.
5.3
Extension Details
To apply ESSE to a conventional protocol, we need to add some
components: epoch-based group commit, a read/write set of each
transaction, reachability tracker, and the correctness testing of over-
writers. Table 3 summarizes the components required for the ESSE
extension to a protocol. If the protocol already has the necessary
components, ESSE can use them straightforwardly. For example,
Silo has everything ESSE needs, and thus it is one of the preferable
protocols. Note that Table 3 does not include reachability tracker,
but ESSE adds it for all protocols as described in Figure 3. In contrast
with Silo, the traditional two-phase locking protocol (2PL) [18] has
none of the necessary components. In addition, 2PL cannot utilize
the version omission technique of ESSE since it writes a version to
the data item immediately before the commit of transactions. More-
over, if 2PL is used with some logging algorithms such as ARIES [29],
it persists the log immediately. The protocol of ESSE starts when
the uncommitted versions are already installed and persist. In this
case, if the erasing version order is accepted, 2PL+ESSE must undo
the uncommitted installed versions before unlocking. Therefore,
OCC is a desirable property for ESSE in terms of performance.
We extended two optimistic protocols: Silo and MVTO to Silo+ESSE
and MVTO+ESSE, respectively. We chose these protocols since they
are modern fast protocols of the 1VCC and MVCC types, respec-
tively. In addition to 2PL, we did not include T/O with TWR for
the experiments. T/O inherently requires a centralized counter to
generate monotonically increasing timestamps. It is known that pro-
tocols with such a counter incur serious performance degradation
in a many-core environment [41].
Silo and Silo+ESSE. Silo [11] is an optimistic protocol that ob-
tains state-of-the-art performance on read-intensive workloads.
When an application requests a transaction to commit, Silo ac-
quires locks for all data items in the transaction’s write set before
installing new versions. We ported Silo’s correctness testing of
overwriters to Silo+ESSE. Silo’s testing checks 𝑜𝑗= 𝜙; if a data item
in 𝑟𝑠𝑗is overwritten, Silo and Silo+ESSE abort 𝑡𝑗. Note that the
original Silo stores records in the leaf nodes of the index directly.
Our implementation of Silo and Silo+ESSE may cause an overhead
of a cache miss due to ESSE’s reachability tracker indirection.
MVTO and MVTO+ESSE. MVTO [3, 26] is a timestamp-based
CC protocol that has multiversion storage. We implemented MVTO
on the basis of Cicada [26], the state-of-the-art MVTO protocol. It
uses per-thread distributed timestamp generation with adaptive
backoff, read/write sets for optimistic multi-versioning, and rapid
garbage collection. Note that the original Cicada does not guar-
antee strict serializability but causal consistency [33]. We applied
epoch-based group commit to this protocol to ensure strict serializ-
ability; the original has the 64-bit per-transaction timestamp, but
we shortened it to 32-bit and added an epoch number to the upper
32 bits to synchronize between epochs and avoid stale reads. To
test overwriters, we ported Silo’s implementation to MVTO+ESSE;
when a version 𝑥𝑖in 𝑟𝑠𝑗was not the latest version of data item 𝑥,
MVTO+ESSE failed to test 𝑜𝑗with its erasing version order and
delegate its control to MVTO.
6
EVALUATION
Our experiments used a lightweight, non-distributed, embedded,
transactional key-value storage prototype written in C++. It con-
sists of in-memory storage, CC protocols (Silo, Silo+ESSE, MVTO,
and MVTO+ESSE), a tree index forked by Masstree [24], and a
parallel-logging manager according to the SiloR [42]specification.
The experiments were run on a 72-core machine with four Intel
Xeon E7-8870 CPUs and 1 TB of DRAM. Each CPU socket had
18 physical cores and 36 logical cores with hyperthreading. The
results for over 72 threads showed sublinear scaling due to con-
tention within the physical cores; in the result figures, we use a
gray background color to indicate this situation. Each socket had
a 45-MB L3 shared cache. The transaction logs were separated for
each worker thread and flushed into a single solid-state drive. Be-
cause all queries were compiled at build time, neither networked
clients nor SQL interpreters were used. Each worker thread had a
thread-local workload generator that enabled it to input its own
transactions.
We selected three workloads generated by benchmark specifi-
cations: TATP [27], YCSB [5], and TPC-C [38] benchmarks. We
selected TATP as the benchmark for our intended application such
as IoT/Telecom applications, including data ingestion queries. We
selected YCSB as the ideal scenario for ESSE in terms of perfor-
mance because it includes a tremendous number of blind updates.
Finally, we selected TPC-C as a counterpoint benchmark with the
least performance benefit because it includes no blind updates.
TATP benchmark. TATP represents the workload for a telecom-
munication company. It includes 16% data ingestion queries that
9

---

Silo+ESSE
Silo
MVTO+ESSE
MVTO
0
25
50
75
100
125
Worker threads
0
1
2
3
4
Throughput (txns/s)
1e7
(a) Original TATP
0
25
50
75
100
125
Worker threads
0
1
2
3
4
5
Throughput (txns/s)
1e7
(b) Update-intensive modification
0
25
50
75
100
125
Worker threads
0
2
4
6
8
Number of updates
1e7
(c) Number of updates in (b)
20
40
60
80
100
Data ingestion query ratio
1.0
1.5
2.0
2.5
3.0
3.5
4.0
Throughput (txns/s)
1e7
(d) Data ingestion query ratio
Figure 8: TATP benchmark results
generate a flood of blind updates for managing changes in a sub-
scriber’s current location or the profile data. 70% of the rest of
queries consist of GET_SUBSCRIBER_DATA and GET_ACCESS_DATA.
They both retrieve the latest and correct data snapshot updated
by data ingestion queries to operate the telecom base station. We
implemented the benchmark in accordance with its specifications.
In addition to the workload obeying the original specifications,
we added workloads with various percentages of blind updates
from the original’s 16% to emulate our intended IoT/Telecom ap-
plications. The query for which we varied the percentage was
UPDATE_LOCATION.
YCSB benchmark. This workload generator is representative
of conventional large-scale online benchmarks. Because the origi-
nal YCSB does not support a transaction with multiple operations,
we implemented a YCSB-like workload generator in our prototype,
similarly to DBx1000 [41]. Specifically, each transaction accessed
four data items chosen randomly according to a Zipfian distribution
with parameter 𝜃. Each data item had a single primary key and an
8-byte additional column. We populated our prototype implemen-
tation as a single table with 100K data items.
TPC-C benchmark. This is an industry-standard for online
transaction processing. It consists of six tables and five transactions
that simulate the information system of a wholesaler. Note that
the TPC-C benchmark does not have any blind updates; all write
operations are inserts or read-modify writes. Thus, SSE could not
commit any transactions with its erasing version order. We imple-
mented TPC-C full mix including all five transactions. Phantom
anomalies were prevented by the same method with Silo: we scan
the tree index again at the commit of each transaction.
6.1
TATP Benchmark Results
Figures 8a and 8b show the results for the original TATP and its
update-intensive modification, respectively. In both cases, ESSE
improved the performance of the original protocols, and the im-
provement for the update-intensive modification was particularly
remarkable. Because most of the blind updates are safely omittable
versions and thus were not installed in physical memory, Silo+ESSE
and MVTO+ESSE achieved 2.7× and 2.5× performance improve-
ments, respectively. In contrast, the performance of Silo for the
0
500
1000
1500
2000
2500
3000
3500
4000
Ticks spent per single transaction
Silo
Silo+ESSE
MVTO
MVTO+ESSE
(a) With 1 thread
0
2000
4000
6000
8000
10000
12000
14000
16000
Ticks spent per single transaction
Silo
Silo+ESSE
MVTO
MVTO+ESSE
(b) With 144 threads
INDEX
TS_ALLOC
LOCKWAIT
LOG
BUFFER_UPDATE
VALIDATION
ESSE_OVERHEAD
GC
Figure 9: Runtime breakdowns of Figure 8a
update-intensive modification was drastically degraded by lock
contention. Although Silo is a read-lock-free protocol, Silo’s write
operations require lockings that reduce parallelism. MVTO exhib-
ited the poorest performance on both the original TATP and the
modification. Although MVTO does not acquire locks for write
operations, its throughput degrades because it allocates memory to
create new versions. SSE overcame these weaknesses of Silo and
MVTO and thus improved the performance drastically.
Figure 8c shows the number of updates for TATP with the update-
intensive modification. For Silo and Silo+ESSE, we counted the num-
ber of in-place updates with locks. For MVTO and MVTO+ESSE,
we counted the number of out-of-place creating new versions. The
10

---

0
25
50
75
100
125
Worker threads
0
1
2
3
4
5
6
Throughput (txns/sec)
1e7
Silo+ESSE
Silo+ESSE+NoLog
Silo
Silo+NoLog
MVTO+ESSE
MVTO+ESSE+NoLog
MVTO
MVTO+NoLog
Figure 10: TATP results with logging-disabled protocols
results indicate that the two ESSE protocols rarely performed ac-
tual updates, because most of the writes generated safely omittable
versions.
Figure 8d shows the results for the TATP benchmark with various
data ingestion query rates and 144 fixed worker threads. As the
percentage of data ingestion queries became larger than the original
16%, the throughputs of Silo and MVTO dropped. The reasons
were that Silo suffered from lock contention on the same data item
and MVTO suffered from the management of multiple versions in
physical memory. In contrast, the ESSE protocols outperformed the
originals and their throughput was not degraded as the percentage
increased. Furthermore, when the percentage exceeded 80%, the
performance of these extended protocols improved. This is because
SSE provides cache efficiency; in this setting, the clients requested
to execute blind writes into almost the same data items, and ESSE
thus generated a tremendous number of safely omittable versions.
As a result, it rarely installed new versions, and almost all read
operations received the same versions that are rarely evicted from
the CPU caches.
Figure 9 shows the runtime breakdown for the results shown in
Figure 8a. With a single thread, the top consumers of CPU ticks were
the INDEX block for Silo and Silo+ESSE and the BUFFER_UPDATE
block for MVTO and MVTO+SSE. The overhead of ESSE was negli-
gible for both ESSE protocols. With 144 threads, the primary con-
sumers of CPU ticks were still the same as with a single thread,
and the overhead of ESSE was again negligible. Note that ESSE dra-
matically reduced the number of CPU ticks spent waiting for the
LOCKING and BUFFER_UPDATE blocks. These two overheads were
reduced by using the reachability trackers. When a transaction is
committed using ESSE’s erasing version order, the write operations
avoid locks and access only the reachability trackers in a latch-free
manner.
As described in Section 1, our intended applications consist of
data ingestion queries and real-time operations. However, there is
sometimes a need to support historical analysis [8] for all submit-
ted versions. To support such historical analysis queries, we need
to flush the persistent logs for each version as accumulated data.
Even if we omit some versions in CC protocols, we also require
log persistence for safely omittable versions. Figure 10 shows the
performance results on the TATP benchmark for the protocols with
the logging feature disabled. We set the percentage of data ingestion
queries to 80%. We can see that the performance of the “NoLog”
protocols was almost the same as that of the protocols with logging.
This indicates that the performance improvement of the SSE does
not come from avoiding log persistence; rather, SSE improves the
performance by reducing memory consumption and avoiding lock
mechanisms.
6.2
YCSB Benchmark Results
Figure 11a shows the results for the YCSB-A workload with a
medium contention rate (𝜃= 0.6). YCSB-A defines the propor-
tion of operations as 50% reads and 50% blind writes. Prior works
showed that conventional protocols perform poorly on such write-
contended workloads [16, 23, 40, 41]. Note that YCSB requests
the database population before benchmarking; all data items are
inserted before measurements. Therefore, in YCSB, all write opera-
tions are blind writes. Thus, once the pivot versions for each 40-ms
epoch are marked, ESSE’s correctness testing rarely fails. We ex-
pect that ESSE protocols can avoid installing a tremendous number
of blind updates and to improve the performance accordingly. In
fact, as shown in Figure 11a, the ESSE protocols achieved higher
throughput than the original ones. In the best case with 144 threads,
the throughput of MVTO+ESSE was more than 20× better than
that of the original protocol. As this workload produces more WAW
conflicts than TATP, the length of the linked lists of MVTO tends to
be longer. Because the longer linked lists increased the overhead of
version traversing for both reads and writes, MVTO’s performance
was degraded. In contrast, MVTO+ESSE reduced the length of the
linked lists because it avoided unnecessary version allocation by
omitting blind updates with ESSE.
Figures 11b and 11c show the results for YCSB-A when we varied
the two influential parameters for ESSE. We tested these workloads
with 72 threads and 𝜃= 0.6. Figure 11b shows the results for various
epoch sizes. As described in Section 5.2, ESSE uses epoch-based
group commits and tests the concurrency among transactions by
using epochs. Hence, a longer epoch duration makes more trans-
actions concurrent and reduces the number of ESSE correctness
testing failures. Therefore, to investigate the effect of the epoch
duration, we tested the YCSB-A with various durations. As shown
in Figure 11b, the throughput of the ESSE protocols increased with
the duration. As a result, we can improve the performance by in-
creasing the epoch duration as much as the application allows. Next,
Figure 11c shows the results for various sizes of the read/write sets.
As the read/write set size increased, the performance of the ESSE
protocols decreased to the level of the original protocols. Because
the reachability tracker described in Section 5.2 has two bloom
filters (mRS/mWS) with a size of only 16 bits, as the number of op-
erations in a transaction increases, the more often the correctness
testing of successors fails because of false positives in the filters.
Figure 11d shows the resuls for the read-mostly YCSB-B work-
load under low contention rate (𝜃= 0.2). There are almost no safely
omittable versions in this workload since most of the operations
are read operations, and contention rarely occurs. Therefore, there
is little benefit from the ESSE’s performance improvement; on the
contrary, the overhead of ESSE may be painful factor for the perfor-
mance. However, Figure 11d shows that ESSE protocols performs
similar performance to the original protocols. It indicates the low
overhead property of ESSE. In such workloads, a transaction gives
up the ESSE protocol quickly generating an erasing version order,
11

---

Silo+ESSE
Silo
MVTO+ESSE
MVTO
0
25
50
75
100
125
Worker threads
0.0
0.5
1.0
1.5
2.0
2.5
Throughput (txns/s)
1e7
(a) YCSB-A: scalability
0
200
400
600
800
1000
Epoch duration (ms)
0.0
0.5
1.0
1.5
2.0
Throughput (txns/s)
1e7
(b) YCSB-A: epochs
0
5
10
15
20
25
30
Size of working set
0
1
2
3
4
5
Throughput (txns/s)
1e7
(c) YCSB-A: size of read/write set
0
25
50
75
100
125
Worker threads
0.0
0.5
1.0
1.5
2.0
2.5
Throughput (txns/s)
1e7
(d) YCSB-B: scalability on low con-
tention rate (𝜃= 0.2)
Figure 11: YCSB benchmark results
0
25
50
75
100
125
Worker threads
0.0
0.5
1.0
1.5
2.0
2.5
Throughput (txns/s)
1e7
0
1
2
3
4
5
Aborts (txns/s)
1e4
Silo+ESSE
Silo
Figure 12: YCSB-B: scalability under high contention (𝜃=
0.9) with throughputs (solid lines) and number of aborts
(dashed lines)
and thus it does not execute the correctness testing. As in men-
tioned in Section 4.3, a transaction first checks the epoch number in
the indirection of each data item. ESSE requires all epoch numbers
and the transaction’s epoch are the same; however, it is rarely sat-
isfied in this workload. Therefore, the transaction gives up ESSE’s
protocol quickly and delegated the control to the baseline protocol.
Figure 12 shows the performance results of YCSB-B under high
contention rate (𝜃= 0.9). The dashed lines represent the through-
put and the solid lines represent the number of aborts. The YCSB-B
workload was expected to be unsuitable for testing our approach
because it specifies the proportion of read operations as 95% [5];
SSE and ESSE can improve the performance on blind updates, but
YCSB-B rarely executes them. Nevertheless, the ESSE protocols
exhibited performance comparable to that of the original proto-
cols, and surprisingly, Silo+ESSE outperformed the original Silo.
This improvement indicates that the version omission technique is
beneficial for other transactions. In this case, Silo+ESSE changed
overwriting operations for the latest versions to omission for stale
versions, thus reducing the abort rate because its validation fails
when the latest versions are overwritten. In Figure 12, the number
of aborts for Silo was higher than the throughput with 25 threads.
This was because only 5% of write operations forced Silo to abort
the 95% of read operations. In contrast, Silo+ESSE kept a lower
abort rate than the original Silo, and it improved its performance
on this read-mostly workload, because ESSE prevented writes of
the latest versions.
6.3
TPC-C Benchmark Results
None of the five queries in the TPC-C benchmark contained blind
writes except inserts. This means that there were no transaction
commits with SSE’s erasing version order for this workload. Al-
though our target is IoT/Telecom applications and their data inges-
tion queries containing a tremendous number of blind updates, we
also tested our approach on this benchmark in order to illustrate
ESSE’s low-overhead property.
To analyze this low-overhead property, we ran the TPC-C bench-
mark with a single warehouse. This high-contention scenario rep-
resents the worst case for ESSE because the reachability tracker for
each data item must be frequently updated even though it is never
used. Figure 13 shows the throughput with respect to the number
of threads. Both Silo and Silo+ESSE scale up to 32 cores, similar
to the experimental results in the original paper. MVTO+ESSE’s
overhead was negligible, yet its performance was comparable to
that of the original protocol. MVTO’s performance bottleneck on
TPC-C was version traversing or buffer update, so the overhead
of the reachability tracker did not affect performance. In contrast,
the throughput of Silo+ESSE was about 0.75× lower than that of
the original protocol 3. This was because most of the queries in
TPC-C lead to read-modify-writes into the latest versions. Because
transactions that perform a read-modify-write operation into a ver-
sion larger than the pivot version may satisfy the two conditions
of Theorem 2, their footprints must be stored in the reachability
tracker for each data item.
7
RELATED WORK
The data ingestion queries are used to aggregate updates from sen-
sors and mobile devices in IoT/Telecom applications. This query has
long been discussed in non-transactional systems such as streaming
databases [13, 19]. In recent years, however, the importance of trans-
actional processing (strict serializability) has been studied [1, 28, 39],
since reading inconsistent or outdated data causes serious prob-
lems in real-world actuators. We need to process ingested data from
sensors and mobile devices efficiently and consistently. In order to
12

---

0
25
50
75
100
125
Worker threads
0.0
0.5
1.0
1.5
2.0
Throughput (txns/s)
1e5
Silo+ESSE
Silo
MVTO+ESSE
MVTO
Figure 13: TPC-C: single warehouse
process such a massive number of updates efficiently, it is essential
to omit updates that are unnecessary for read operations. Streaming
systems use load shedding [13] or backpressure [14] to put a rate
limit of submitting data. However, these techniques do not ensure
transactional correctness; they omit the data before submitting it to
databases. Then we cannot use CC protocols to choose the version
order to provide correct data snapshot. In transaction processing,
Thomas’s write rule [36] can omit the data and ensure serializability.
However, to the best of our knowledge, TWR does not guarantee
strict serializability. In addition, TWR is applicable only for single-
version timestamp ordering protocol, which is obsolete on modern
in-memory databases. SSE also performs the write omission and
these methods while preserving the transactional correctness and
it is applicable to various CC protocol.
The commutative theory is another example to increase the paral-
lelism on write operations. Commutative systems such as CRDT [9]
and Doppel [10], define a commutative operation set such as ADD
or INCR. Under commutative systems, these operations can be ex-
ecuted in parallel with preserving consistency. In contrast, SSE
focuses on non-commutative operations on the basis of the tra-
ditional page-model interface with only READ and WRITE. As a
result, SSE can optimize the performance of IoT/Telecom applica-
tions that do not include commutative operations.
Another example of a protocol that generates omittable ver-
sions is deterministic databases [35, 37]. A deterministic database
uses the batching approach for concurrency control: centralized
transaction managers collect transactions and separate them into
batches. Faleiro et al. devised lazy transaction execution [15], in
which a deterministic database can generate omittable versions.
By delaying the execution of operations, they executes only blind
writes that eventually become the latest versions in each batch.
After that, database removes other versions. In contrast with lazy
evaluation, however, SSE is applicable to non-deterministic proto-
cols because it does not require a centralized transaction manager
or prior knowledge of the transactions.
Multi-version concurrency control protocols [17, 25, 26] can hold
multiple versions for each data item. Multiversion read avoids the
high abort rates of single-version protocols, especially for work-
loads that include long transactions [23, 40, 41]. All MVCC protocols
can theoretically generate multiple version orders by using MVSG.
However, conventional protocol [22, 23, 25, 26, 34] generates only
a single version order. This is because the decision process to find a
suitable one from all possible orders is NP-complete [2, 32], as men-
tioned in Section 4.2. SSE also does not give the exact solution, but
it reduces the computational cost by adding only a single candidate
version order, which is preferable for generating safely omittable
versions.
8
CONCLUSION
We presented a protocol extension method, scheduling space ex-
pander (SSE), and its optimized implementation named ESSE. SSE
and ESSE can extend various protocol so that it can, in theory, test
an additional version order for the purpose of generating safely
omittable versions while preserving both strict serializability and
recoverability. To evaluate the performance gain with our approach,
we extended two existing protocols, Silo and MVTO to include ESSE.
We expect that SSE and ESSE can help accelerate emerging systems
with data ingestion queries.
REFERENCES
[1] Ronald Barber, Matt Huras, Guy Lohman, C. Mohan, Rene Mueller, Fatma Özcan,
Hamid Pirahesh, Vijayshankar Raman, Richard Sidle, Oleg Sidorkin, Adam Storm,
Yuanyuan Tian, and Pinar Tözun. 2016. Wildfire: Concurrent Blazing Data Ingest
and Analytics. In SIGMOD Conf. 2077–2080.
[2] Philip A Bernstein and Nathan Goodman. 1983. Multiversion concurrency control-
theory and algorithms. TODS 8, 4 (1983), 465–483.
[3] Philip A Bernstein, Vassos Hadzilacos, and Nathan Goodman. 1987. Concurrency
control and recovery in database systems. Addison-Wesley Pub. Co. Inc., Reading,
MA.
[4] Badrish Chandramouli, Guna Prasaad, Donald Kossmann, Justin Levandoski,
James Hunter, and Mike Barnett. 2018. FASTER: A concurrent key-value store
with in-place updates. In SIGMOD Conf. 275–290.
[5] Brian F Cooper, Adam Silberstein, Erwin Tam, Raghu Ramakrishnan, and Russell
Sears. 2010. Benchmarking Cloud Serving Systems with YCSB. In SoCC. 143–154.
[6] Feilong Tang et al. 2011. Towards Context-Aware Ubiquitous Transaction Pro-
cessing: A Model and Algorithm. In ICC. IEEE. https://doi.org/10.1109/icc.2011.
5963475
[7] Murat Demirbas et al. 2008. TRANSACT: A Transactional Framework for Pro-
gramming Wireless Sensor/Actor Networks. In IPSN. https://doi.org/10.1109/
IPSN.2008.44
[8] M. Poess et al. 2018. Analysis of TPCx-IoT: The First Industry Standard Bench-
mark for IoT Gateway Systems. In ICDE. 1519–1530.
[9] Marc Shapiro et al. 2011. Conflict-Free Replicated Data Types. In SSS. https:
//doi.org/10.1007/978-3-642-24550-3_29
[10] Neha Narula et al. 2014. Phase Reconciliation for Contended In-Memory Trans-
actions. In OSDI, Jason Flinn and Hank Levy (Eds.). https://www.usenix.org/
conference/osdi14/technical-sessions/presentation/narula
[11] Tu Stephen et al. 2013. Speedy transactions in multicore in-memory databases.
In SOSP.
[12] Weikum Gerhard et al. 2001. Transactional information systems: theory, algorithms,
and the practice of concurrency control and recovery. Elsevier.
[13] Yi-Cheng Tu et al. 2006. Load Shedding in Stream Databases: A Control-Based
Approach. In PVLDB. http://dl.acm.org/citation.cfm?id=1164195
[14] Yad Tahir et al. 2018. BRPL: Backpressure RPL for High-Throughput and Mobile
IoTs. IEEE Trans. Mob. Comput. (2018). https://doi.org/10.1109/TMC.2017.2705680
[15] Jose M Faleiro, Alexander Thomson, and Daniel J Abadi. 2014. Lazy evaluation
of transactions in database systems. In SIGMOD Conf. 15–26.
[16] Hua Fan and Wojciech Golab. 2019. Ocean Vista: Gossip-based Visibility Control
for Speedy Geo-distributed Transactions. PVLDB 12, 11 (2019), 1471–1484.
[17] Alan Fekete, Dimitrios Liarokapis, Elizabeth O’Neil, Patrick O’Neil, and Dennis
Shasha. 2005. Making snapshot isolation serializable. TODS 30, 2 (2005), 492–528.
[18] Jim Gray and Andreas Reuter. 1992. Transaction processing: concepts and tech-
niques. Elsevier.
[19] Raman Grover and Michael J. Carey. 2015. Data Ingestion in AsterixDB. In
Proceedings of the 18th International Conference on Extending Database Technology,
EDBT 2015, Brussels, Belgium, March 23-27, 2015, Gustavo Alonso, Floris Geerts,
Lucian Popa, Pablo Barceló, Jens Teubner, Martín Ugarte, Jan Van den Bussche,
and Jan Paredaens (Eds.). OpenProceedings.org, 605–616.
https://doi.org/10.
5441/002/edbt.2015.61
[20] Vassos Hadzilacos. 1988. A theory of reliability in database systems. JACM 35, 1
(1988), 121–145.
[21] Maurice P Herlihy and Jeannette M Wing. 1990. Linearizability: A correctness
condition for concurrent objects. TOPLAS 12, 3 (1990), 463–492.
[22] Alfons Kemper and Thomas Neumann. 2011. HyPer: A hybrid OLTP&OLAP
main memory database system based on virtual memory snapshots. In ICDE.
195–206.
13

---

[23] Kangnyeon Kim, Tianzheng Wang, Ryan Johnson, and Ippokratis Pandis. 2016.
Ermia: Fast memory-optimized database system for heterogeneous workloads.
In SIGMOD Conf. 1675–1687.
[24] Eddie Kohler. 2020. Code of masstree. https://github.com/kohler/masstree-beta.
[25] Larson, Per-Åke and Blanas, Spyros and Diaconu, Cristian and Freedman, Craig
and Patel, Jignesh M and Zwilling, Mike. 2011. High-performance concurrency
control mechanisms for main-memory databases. PVLDB 5, 4 (2011), 298–309.
[26] Hyeontaek et al Lim. 2017. Cicada: Dependably fast multi-core in-memory
transactions. In SIGMOD Conf. 21–35.
[27] IBM Software Group Information Management. 2009. Specification of TATP
Benchmark. http://tatpbenchmark.sourceforge.net/index.html.
[28] John Meehan, Cansu Aslantas, Stan Zdonik, Nesime Tatbul, and Jiang Du. 2017.
Data Ingestion for the Connected World.. In CIDR.
[29] C Mohan, Don Haderle, Bruce Lindsay, Hamid Pirahesh, and Peter Schwarz. 1992.
ARIES: a transaction recovery method supporting fine-granularity locking and
partial rollbacks using write-ahead logging. TODS 17, 1 (1992), 94–162.
[30] Thomas Neumann, Tobias Mühlbauer, and Alfons Kemper. 2015. Fast Serializable
Multi-Version Concurrency Control for Main-Memory Database Systems. In
SIGMOD Conference. ACM, 677–689.
[31] Christos Papadimitriou. 1986. The theory of database concurrency control. Com-
puter Science Press Inc., Rockville, MD.
[32] Christos H Papadimitriou and Paris C Kanellakis. 1982. On Concurrency Control
by Multiple Versions. In PODS. 76–82.
[33] Karin Petersen, Mike Spreitzer, Douglas B. Terry, Marvin Theimer, and Alan J.
Demers. 1997. Flexible Update Propagation for Weakly Consistent Replication.
In Proceedings of the Sixteenth ACM Symposium on Operating System Principles,
SOSP 1997, St. Malo, France, October 5-8, 1997, Michel Banâtre, Henry M. Levy, and
William M. Waite (Eds.). ACM, 288–301. https://doi.org/10.1145/268998.266711
[34] Dan R K Ports and Kevin Grittner. 2012. Serializable snapshot isolation in Post-
greSQL. PVLDB 5, 12 (2012), 1850–1861.
[35] Kun Ren, Alexander Thomson, and Daniel J Abadi. 2014. An evaluation of the
advantages and disadvantages of deterministic database systems. PVLDB 7, 10
(2014), 821–832.
[36] Robert H Thomas. 1977. A majority consensus approach to concurrency control for
multiple copy data bases. Technical Report. BOLT BERANEK AND NEWMAN
INC CAMBRIDGE MA.
[37] Alexander Thomson, Thaddeus Diamond, Shu-Chun Weng, Kun Ren, Philip Shao,
and Daniel J Abadi. 2012. Calvin: fast distributed transactions for partitioned
database systems. In SIGMOD Conf. 1–12.
[38] Transaction Processing Performance Council (TPC). 2010. Transaction Processing
Performance Council (TPC): Standard specification. TPC Benchmark C Version
5.11.0 (2010). http://www.tpc.org/tpc_documents_current_versions/pdf/tpc-c_
v5.11.0.pdf.
[39] Xikui Wang and Michael J. Carey. 2019. An IDEA: An Ingestion Framework for
Data Enrichment in AsterixDB. Proc. VLDB Endow. 12, 11 (2019), 1485–1498.
[40] Yingjun Wu, Joy Arulraj, Jiexi Lin, Ran Xian, and Andrew Pavlo. 2017. An
Empirical Evaluation of In-memory Multi-version Concurrency Control. PVLDB
10, 7 (2017), 781–792.
[41] Xiangyao Yu, George Bezerra, Andrew Pavlo, Srinivas Devadas, and Michael
Stonebraker. 2014. Staring into the abyss: An evaluation of concurrency control
with one thousand cores. PVLDB 8, 3 (2014), 209–220.
[42] Wenting Zheng, Stephen Tu, Eddie Kohler, and Barbara Liskov. 2014.
Fast
Databases with Fast Durability and Recovery Through Multicore Parallelism. In
OSDI. 465–477.
14

---

