# Serializable HTAP with Abort-/Wait-free Snapshot Read

> 来源: https://arxiv.org/pdf/2201.07993

arXiv:2201.07993v2  [cs.DB]  21 Apr 2022
Serializable HTAP with Abort-/Wait-free Snapshot Read
Takamitsu Shioi
Department of Computer Science,
School of Computing in
Tokyo Institute of Technology
shioi@de.cs.titech.ac.jp
Takashi Kambayashi
Nautilus Technologies, Inc.
kambayashi@nautilus-
technologies.com
Suguru Arakawa
Nautilus Technologies, Inc.
arakawa@nautilus-technologies.com
Ryoji Kurosawa
Nautilus Technologies, Inc.
kurosawa@nautilus-
technologies.com
Satoshi Hikida
Tokyo Institute of Technology
hikida@de.cs.titech.ac.jp
Haruo Yokota
Tokyo Institute of Technology
yokota@de.cs.titech.ac.jp
ABSTRACT
Concurrency Control (CC) ensuring consistency of updated data is
an essential element of OLTP systems. Recently, hybrid transaction-
al/analytical processing (HTAP) systems developed for executing
OLTP and OLAP have attracted much attention. The OLAP side CC
domain has been isolated from OLTP’s CC and in many cases has
been achieved by snapshot isolation (SI) to establish HTAP systems.
Although more high isolation level is ideal, considering OLAP read-
only transactions in the context of OLTP scheduling achieving seri-
alizability forces aborts/waits and would be a potential performance
problem. Furthermore, executing OLAP without affecting OLTP as
much as possible is needed for HTAP systems.
The aim of this study was serializability without additional abort-
s/waits. We propose read safe snapshot (RSS) using multiversion
CC (MVCC) theory and introduce the RSS construction algorithm
utilizing serializable snapshot isolation (SSI). For serializability of
HTAP systems, our model makes use of multiversion and allows
more schedules with read operations whose corresponding write op-
erations do not participate in the dependency cycles. Furthermore,
we implemented the algorithm practically in an open-source data-
base system that offers SSI. Our algorithm was integrated into two
types of architecture as HTAP systems called as uniﬁed or decou-
pled storage (single-/multinode) architecture. We evaluate the per-
formance and abort rate of the single-node architecture where SSI
is applicable. The multi-node architecture was investigated for ex-
amining the performance overhead applying our algorithm.
1
INTRODUCTION
Most DBMSs have been traditionally divided into write-optimized
or read-optimized systems, and have focused on utilizing the sys-
tem architecture for each workload features. OLTP- or OLAP-style
applications are categorized as distinct characteristics, where short
period transactions update small data correctly in OLTP and long
period ad hoc queries aggregate large data in OLAP. Accommodat-
ing OLTP and OLAP components on one system is highly challeng-
ing for a long time because continuous OLTP update propagation
and fast aggregation containing the updated data are performance
tradeoffs that resulted from the difference of workload properties
and appropriate architectures. Moreover, merging OLAP read-only
transactions into OLTP transactions would cause an anomaly anal-
ysis result that contains inconsistent data [13].
In recent years, hybrid transactional/analytical processing (HTAP)
systems have been developed to support both OLTP and OLAP
workloads [3, 15, 17, 18, 20, 25]. There is considerable interest
in such systems for use in modern database applications such as
real-time data analysis [8, 22, 23]. In [29], a concrete use case of
the airline industry was shown. Moreover, HTAP systems are cate-
gorized into either uniﬁed (single-node) or decoupled (multinode)
storage architectures as the physical composition [25]. Multinode
architecture HTAP systems try to communicate continuously the
physical partitioned systems for solutions against batch propaga-
tion from daytime OLTP systems to OLAP data warehouses [21].
Recent studies have concentrated on improving data freshness for
analyzing the most recently changed data by connecting to a write-
optimized system.
Although performance improvement of HTAP systems has ma-
jor issues, concurrency control (CC) guaranteeing the consistency
of the updated data also has been a vital aspect. HyPer-Fork [15, 19]
has achieved serializability based on snapshot isolation (SI) [4] by
serial execution of OLTP transactions and snapshots obtained from
the gap where concurrent update transactions are absent. To design
serializability on both OLTP and OLAP engines, however, inten-
tionally creating the gap on the OLTP side would limit the con-
currency performance of OLTP write transactions. Thus, HyPer-
MVOCC [20] aborts OLTP write transactions only when they con-
currently modify the read-set of OLAP read-only transactions to
achieve serializability on OLAP. We consider the ideal HTAP sys-
tem should process OLAP without affecting OLTP performance.
Such performance problems would arise from enhancing not only
data freshness but also the isolation level as CC.
To achieve OLAP’s serializability with little impact on OLTP per-
formance, aborting write transactions on the OLTP engine would be
unrealistic. For utilization of a replicated system nondedicated to
HTAP, conﬂict-prevention with read-only optimization (CP-ROO)
[6, 14] allows all read-only transactions to commit and validate the
detected read-write conﬂicts (rw-conﬂicts) [2], satisfying the condi-
tions for executing aborts of write transactions (writer-aborts). In
the case of processing HTAP workloads, HTAP systems would de-
teriorate the OLTP performance because of many writer-aborts by
OLAP analytical queries scanning a larger read-set of data. Further-
more, communication overheads collecting read-write dependecies

---

Takamitsu Shioi, Takashi Kambayashi, Suguru Arakawa, Ryoji Kurosawa, Satoshi Hikida, and Haruo Yokota
(rw-dependencies) for writer-aborts affects OLTP and OLAP per-
formance on multinode architecture. Consequently, many single-
/multinode HTAP systems have executed OLAP read-only transac-
tions under SI for preserving OLTP performance instead of serializ-
ability using writer-abort or two-phase locking (2PL).
To achieve serializability as HTAP systems, some techniques
would be required. For example, PostgreSQL provides safe snap-
shots [24] by setting READ ONLY DEFERRABLE ﬂags in trans-
actions. The read-only deferrable transaction forces OLAP read-
only transactions to wait (reader-wait) for the arrival of serializable
snapshots that are taken intentionally by writer-abort or delaying
the concurrent write transaction starts (writer-wait) to obtain suc-
cessfully serializable snapshots (such as the absence of concurrent
writer on HyPer-Fork or Snapshot Epoch [28] ). However, the wait
time of read-only or write transactions depends on OLTP workloads
and degrades system performance.
This study focuses on accomplishing serializability for HTAP
systems. Moreover, our approach prevents read-only transactions
from waiting while executing transactions in real time on OLTP.
We introduce read safe snapshot (RSS) as the theoretical frame-
work on top of multiversion CC (MVCC) [2, 5] to achieve serial-
izability read-only transaction joins concurrently. RSS can execute
OLAP queries mapping previous versions without additional abort-
s/waits of read-only transaction participation. Furthermore, we pro-
pose an RSS construction algorithm and utilize SSI [12] to reduce
RSS construction overhead in tracking transactional dependencies.
Our proposed method was implemented in PostgreSQL as a sys-
tem offering SSI and the log-shipping replication technique for con-
structing an OLTP component and the read-only replica. We investi-
gated the performance of our implementation under CH-BenCHmark
[9, 11] as workloads for evaluation. The contributions of this study
are:
• Arranging a theoretical framework (RSS) to guarantee that a
multiversion scheduler can accept read operations targeting
shortly-previous-versions when read-only transactions par-
ticipated. The scheduler acceptability shows that additional
aborts or waits caused by read-only transaction participation
are not required to achieve serializability.
• Based on that, formalizing an algorithm reducing the cost
of tracking transactional dependencies to collect only rw-
dependency information in the case an OLTP engine applies
SSI in HTAP systems.
• Integrating the algorithm in two types of HTAP architectures
categorized as uniﬁed/decoupled (single-/multinode) storage
systems. It shows our theoretical framework can apply to a
wide range of HTAP architectures. Our implementation used
PostgreSQL and the log-shipping replication function for the
multinode architecture.
– No matter what RSS applies multinode architecture, RSS
can achieve serializable (abort-/wait-free) in read-only replica
by constructing RSS beforehand through log-shipping of
collected transactional dependency on the OLTP engine.
• Enhancing PostgreSQL’s OLTP throughput up to 20% com-
paring SSI + SafeSnapshots in uniﬁed architecture on the
situation that OLTP clients increased to 48. On the other
hand, RSS OLAP performance does not decrease in com-
parison with SSI, SSI+SafeSnapshots even if the number of
OLAP clients increases. In addition, compared with SSI+SI
multinode architecture that OLAP transactions executed un-
der SI on PostgreSQL, the demonstrations of multinode ar-
chitecture restrain OLTP throughput about 10% in compari-
son with SSI+SI. RSS OLAP performance on multinode ar-
chitecture about 10% lower than SSI+SI.
Outline. The rest of this paper is organized as follows. Section 2
describes related works achieving SI as CC on an OLAP engine. In
Section 3, we introduce the notations and an organization of read-
only transaction anomaly on HTAP. In Section 4, we consider the
basic model and algorithm for ensuring HTAP serializability un-
der the assumption that OLTP transaction history guarantees se-
rializable when read-only transactions join in real time. Section
5 presents the architecture implementing the presented algorithm
based on PostgreSQL. Section 6 investigates the performance over-
heads of the prototype implementation to achieve serializability. In
Section 7, we conclude this paper with future work.
2
BACKGROUND AND RELATED WORK
As mentioned in the previous section, the aim of this study was
the serializability of HTAP systems without deteriorating perfor-
mance and data freshness as much as possible. HTAP systems es-
tablished the compatibility of the performance and data freshness,
whereas the OLAP engine compromises serializability. In the sys-
tems adopting SI, a write transaction can update while a potentially
long-running read transaction of HTAP workload proceeds concur-
rently. Unfortunately, SI does not always guarantee serializable be-
havior; it leads to inconsistent data, for example, read-only transac-
tion anomaly [13]. A generic HTAP system that is realized by SI
has isolated the CC domain from OLAP: the OLTP engine should
be able to achieve serializability with traditional CC studies; how-
ever, the OLAP engine cannot achieve it.
2.1
SI-based HTAP systems
SAP HANA [17] produced a consistent view manager that sup-
ported SI in the distributed in-memory database. The transactions
accessing the consistent view manager reads the most recent com-
mitted versions at the time when the transaction began for ensur-
ing the consistent view of SAP HANA, and the two-phase commit
(2PC) protocol ensures atomicity of distributed multi-node update
transactions for SI. The write transactions would assure serializabil-
ity if the 2PC protocol checks additionally quasi rw-conﬂicts us-
ing lock and aborts the conﬂicting transaction. Although the short-
running read-only transactions can reuse a cached consistent view
to avoid performance bottleneck, reading only old data cannot en-
sure serializability. Long-running read-only transactions also can
ensure SI because of the two-phase commit protocol: the read-only
transactions are SI derived from a consistent view.
BatchDB [18] is primarily based on replication explored to achieve
performance isolation for OLTP and OLAP workloads and implied
SI to realize an HTAP system. Such architecture could isolate OLTP
and OLAP workloads across hardware boundaries, as a result from
each replica could apply systems dedicated for each workload; the

---

Serializable HTAP with Abort-/Wait-free Snapshot Read
OLTP replica implemented by Hekaton [10]. Hekaton MVOCC guar-
antees that the transactions can achieve serializability by aborts
with re-read validation and write-write conﬂicts (ww-conﬂicts) de-
tection [16]. Considering performance overheads of serializability,
the OLTP component in BatchDB was not used for Hekaton’s se-
rializable isolation. In contrast, the OLAP component attained un-
locking SI in the replicated system and maintained single version
data individually copied from one batch. To keep consistent views,
the OLAP replica executed transactions nonconcurrently while exe-
cuting the batch propagation.
2.2
SI-based serializability
HyPer [15, 19, 20] achieved SI-based serializability ﬁrmly consid-
ering the OLAP component. HyPer-Fork [15, 19] processed OLTP
transactions serially and OLAP queries on a consistent snapshot
that resulted from Copy-on-Write between two serial transactions.
HyPer-MVOCC [20] avoided write-write conﬂicts by lock and de-
termined the visible version of a record by comparing the transac-
tion’s start timestamp to the commit timestamp of the version delta
in the newest-to-oldest direction to achieve SI. Moreover, HyPer-
MVOCC executed writer-aborts to prevent rw-antidependencies [12]
from occuring to achieve serializability under SI. HTAP systems
largely utilize snapshot mechanisms for CC and can take advantage
of serializability like HyPer. Although some HTAP systems could
exploit serializability, degrading the OLTP performance would be
the cause of the supplementary OLAP transactions; in particular,
serial execution (writer-wait) or writer-abort may be expensive.
There are alternative ways of using snapshots to enable serializ-
able isolation. SSI [12] is known as a theory offering serializable
isolation under SI. the nonserializable state of SI transactions con-
tains two successive concurrent rw-antidependencies. If a system
that uses SI aborts one of the transactions consisting of two suc-
cessive rw-antidependencies, the system can achieve serializabil-
ity. However, applying SSI to HTAP systems leads to OLAP per-
formance deteriorating by the reader-abort. Because OLAP’s read-
only transactions tend to be huge read sets and have long lifetimes
based on the characteristics of scan-mostly and long-running analyt-
ical queries, detections of the concurrent rw-dependencies would be
time-consuming.
In particular, recent HTAP systems using replication need to send
transaction’s read sets from the read replica dedicated for OLAP
workload to the OLTP engine, and concurrent write transactions
with the long-running read transactions must keep track of (over-
)writes. If two short-running update transactions are committed as
the ﬁrst rw-dependency before the read-only transaction creates the
second rw-dependency, reader-abort of the second rw-dependency
would be executed. In addition, if s long-running read-only transac-
tion is retried, reader-abort would easily occur by validation. HyPer-
MVOCC [20] and CP-ROO [6, 14] would yield a greater OLAP
performance than a system that applied SSI because the validation
chooses writer-abort instead of reader-abort when it detects the rw-
conﬂicts. Therefore, applying SSI for the OLAP component is un-
suitable for processing OLTP and OLAP on multinode architecture.
In the read-only replica of log-shipping replication, Ports and
Grittner [24] proposed taking snapshots (safe snapshots) for serial-
izable isolation based on SI. Because read-only transactions under
SSI can read a snapshot without the need to track rw-conﬂicts, safe
snapshots were exploited in a system that offers SSI. [24] illustrated
the idea of taking reliably safe snapshots at read-only replica of
log-shipping replication by writer-abort/-wait on an OLTP engine
and reader-wait on the read-only replica. That is, such transactions
called deferrable transactions in the system must abort concurrent
write transactions, or must prevent new transactions from starting
while waiting for concurrent write transactions to ﬁnish; moreover,
read-only transactions on the replica must wait for safe snapshots
to arrive.
3
PRELIMINARY: PROBLEM STATEMENT
This section introduces the formalization that is necessary for our
study, and illustrates a concept that ensures global (conﬂict-) seri-
alizability [7, 27] under the theory of classical MVCC with the ad-
ditional restriction on OLAP read-only transactions: the read-only
transactions do not know the conﬂicts with Active transactions un-
til the write transactions are committed. In particular, waiting for
the conﬁrmed information would deteriorate the performance for
real-time analysis on HTAP systems; we deﬁne a problem struc-
ture caused from read-only transaction participation in Section 3.3.
In Section 4, by considering the problem structure, we suggest a
method identifying the committed transaction region that read-only
transactions can read the previous-versions guaranteed to achieve
serializability.
3.1
HTAP scheduler as a global serializability
Adya et al. [1, 2] have introduced Isolation Level PL-3 ensuring se-
rializability within the class of conﬂict-serializability (Bernstein et
al. [5] ). In this paper, we adopt the multiversion history formaliza-
tion in [2] and assume transaction schedules/histories are always
given with a version-order of writes. We call the class of multi-
version schedules satisfying serializability (PL-3 [2]) as version-
ordered conﬂict-serializability (VOCSR). The history of an OLTP
engine is assumed to be serializable in the meaning of VOCSR, and
OLTP engine assumes that read operations can read only commit-
ted versions. HTAP scheduler processes operations in transactions
as a dynamic scheduler that implies isolating each OLTP and OLAP
protocol. HTAP history (or complete schedule) is a sequence that
consists of the union of the operations from given transactions on
each OLTP and OLAP. The preﬁx of operations that have been exe-
cuted by now in the ongoing schedule is denoted the current preﬁx.
We design HTAP history acceptable to HTAP schedulers to be spon-
taneously global serializability, what we call serializable HTAP, en-
suring the following conditions;
• OLTP does not perceive the processing contents of OLAP:
when appending an OLTP operation, OLTP protocols know
only the OLTP operations in the current preﬁx of a history.
• OLAP can perceive the processing contents of OLTP (through
log-shipping or other processes) : when appending an OLAP
operation, OLAP protocols know the committed transactions
on the OLTP component as well as the OLAP component op-
erations in the current preﬁx of the history, including version-
order deﬁned by the ww-conﬂicts in VOCSR.
Note that the VOCSR can be considered to contain a history SSI
generates as serializability class, as the version-order is induced by

---

Takamitsu Shioi, Takashi Kambayashi, Suguru Arakawa, Ryoji Kurosawa, Satoshi Hikida, and Haruo Yokota
the order of the commit operations of the transactions that wrote the
versions (SI version order [26] ).
3.2
Notation
Let T = {푇1, . . . ,푇푛} be a set of transactions. A transaction 푇is
a (totally ordered) sequence of read and write operations on data
items. A write operation on data item 푋by transaction푇푎is denoted
by 푊푎(푋푎); if it is useful to indicate the value 푣being written into
푋푎, we use the notation,푊푎(푋푎,푣) [1]. When a transaction 푇푎reads
a version of 푋that was created by 푇푏, we denote this as 푅푎(푋푏). If
it is useful to indicate the value 푣being read, we use the notation
푅푎(푋푏,푣). Here, about a history ℎand such operations 표푖,표푗∈ℎ,
we denote 표푖≺ℎ표푗, if 표푖preceded 표푗in ℎ. For a transaction 푇∈T,
we write 퐵푒푔푖푛(푇) as an operation that appears in most preceded
operations of푇on a history. Similarly, we write 퐸푛푑(푇) as the most
successor in 푇on the history ℎ; 퐵푒푔푖푛(푇) ≺ℎ퐸푛푑(푇) always holds.
Schenkel and Weikum [26, 30] have deﬁned SI as a multiversion
scheduler that holds two conditions. For later explanation, we inter-
pret and describe the property of SI. The ﬁrst condition denoted
as SI-V (SI version function) is a read protocol that maps each
read operation 푅푎(푋푏) to the most recent committed write opera-
tion 푊푏(푋푏) that begins at 푇푎. The second condition deﬁned as SI-
W (disjoint writesets) is a commit or write protocol (called as First
Committer/Updater Wins Rule) where the writesets of two concur-
rent transactions are disjoint.
Adya et al. [2] have deﬁned the direct serialization graph (DSG)
arising from any given multiversion history ℎ. Each node in DSG(h)
corresponds to a committed transaction and directed edges corre-
spond to conﬂicts (write-write, write-read, read-write) under infor-
mation about committed transactions (a committed projection of
the current preﬁx in ℎ). Such a transaction order (partially ordered)
graph guarantees serializable from the given history if it is acyclic.
For transactions 푇푎,푇푏∈T, we write 푇푎→푇푏(dependency edge)
if there exists any of the direct conﬂicts (write-write, write-read,
read-write) from 푇푎to 푇푏. Let us write 푇푎→∗푇푏for the reﬂex-
ive and transitive dependency where 푇푏is reachable from 푇푎; note
that 푇→∗푇always holds for any transaction 푇, but it is not con-
sidered as a cycle. We say unreachable if no directly or transitive
dependency edge from 푇푎to 푇푏holds then we denote 푇푎̸ →∗푇푏.
3.3
The missing piece: read only anomaly on
OLAP
Here, we organize a problem resulting from read-only transaction
participation. To achieve serializability as HTAP in our precondi-
tion, we aim to deﬁne and remove a set of anomalies that include
read-only transaction anomalies [13] . Even if the OLTP side of an
HTAP scheduler is serializable, an anomaly situation would occur
on the OLAP side. We illustrate such problems on HTAP systems
in this section.
Deﬁnition 3.1. Read-Only Anomaly
We say A read-only anomaly occurs if a history 퐻over transactions
T contains nonserializable structure S ⊆T, where a set of transac-
tions S = {푆1, 푆2, 푆3, · · · , 푆푛} holds the following conditions;
• History 퐻restricted over transactions {푆1, · · · , 푆푛−1} is a
serializable history in VOCSR:
퐻(푆1, · · · , 푆푛−1) ⊆푉푂퐶푆푅,
• 푆푛is a read-only transaction, and
• S has the cycle of dependency edges 푃;
푃= {푆1 →∗푆2, 푆2 →∗푆3, · · · , 푆푛−2 →∗푆푛−1, 푆푛−1 →
푆푛, 푆푛→푆1}. Note that the last two edges 푆푛−1 →푆푛and
푆푛→푆1 are direct dependency.
In history ℎ푠under SI, we describe the example referred to as
read-only anomaly [13] :
ℎ푠: 푅2(푋0, 0) 푅2(푌0, 0) 푅1(푌0, 0) 푊1(푌1, 20)
푅3(푋0, 0) 푅3(푌1, 20) 푊2(푋2, −11)
Although the history over 푇1 and 푇2 is serializable under SI, nonse-
rializable history 퐻is caused by participating read-only transaction
푇3: ℎ푠is a read-only anomaly because of rw-dependency edges of
푇2 →푇1 and 푇3 →푇2 and transaction 푇3 is read-only transaction
arising write-read dependency (wr-dependency) edge푇1 →푇3. Ifℎ푠
arises under SSI, a transaction would be aborted because of danger-
ous structure in the rw-dependency edges of 푇2 →푇1 and 푇3 →푇2.
Transactions executed under SSI do not arise read-only anomalies.
In the case of an HTAP scheduler, let T be accepted under SSI
and푇3 be an OLAP read-only transaction. In the OLTP side, the pro-
tocols interpreted the sequence of operations in푇1 and푇2, {푅2(푋0) 푅2(푌0)
푅1(푌0)푊1(푌1) 푊2(푋2)} are accepted under SSI, and 푇1 and 푇2 can
commit without considering the OLAP side. In contrast, if the read-
only transaction 푇3 processes are on the OLAP side, where the cur-
rent preﬁx is between 퐸푛푑(푇1) (= 푊1(푌1) ) and 퐸푛푑(푇2) (= 푊2(푋2)
), then the read protocol SI-V reads the version 푌1 and 푋0. Hence,
푇3 would be reader-abort of the second rw-dependency in danger-
ous structures because the OLTP side would not writer-abort the al-
ready committed transactions 푇1 and 푇2 for performance by OLAP
circumstances. In fact, validating reader-abort on SSI must wait for
the information of 퐸푛푑(푇2) through committed log, and retrying the
read-only transaction while processing successively write transac-
tions would abort again: reader-abort and retry are inefﬁcient for
HTAP systems.
To achieve serializable isolation without aborts, there are two
types of approaches. In the ℎ푠, reading the most recent committed
version 푌1 on the current preﬁx of OLAP side resulted in a read-only
anomaly. If the read protocol of 푇3 chooses the previous version 푌0,
the scheduler cannot have led to the read-only anomaly nor aborted
a transaction for serializability. Otherwise, even if 푇3 read the suc-
cessor version of 푋2 instead of 푋0, 푇3 needed to (read-) wait the
commit of 푇2 not knowing when it will end. Moreover, concurrent
transactions is not aware of whether or not the successor version 푋2
is written, and the concurrent rw-dependency can arise after such
the validation similar to 퐸푛푑(푇3) (= 푅3(푌1) ) ≺ℎ푎푊2(푋2). There-
fore, we focus on constructing the model reading previous versions
ensuring serializability. We consider that the key of MVCC is read
protocols that can be free from restrictions on read versions (not
necessarily the most recent one).
4
READ SAFE SNAPSHOT (RSS)
Ideally DBMS would have little effect on performance to achieve se-
rializable isolation. As we described in Section. 2, previous studies
have provided SI to read-only transactions regardless of whether it
assures serializability. Traditionally, guaranteeing serializability is

---

Serializable HTAP with Abort-/Wait-free Snapshot Read
more desirable than tolerating read-only anomalies under SI, but the
methods were far from optimal as utilizations for read-only transac-
tion participation, because potential performance overhead comes
from aborts or waits to take and send the snapshot written noncon-
currently.
In this section, we improve a model for constructing a view (snap-
shot) assuring serializability whenever read-only transactions join.
The model uses the following concept;
• First, because a read-only transaction perceives beforehand
that read-only anomalies do not occur by reading the pre-
pared view, the read-only transaction does not need to do ad-
ditional validations like ﬁnding an rw-conﬂict, causing the
writer-/reader-abort.
• Second, the read-only transaction does not perceive what and
when concurrent transactions will write or commit. There-
fore, our model identiﬁes the boundary between the concur-
rent and ﬁnished transactions at any point (preﬁx) of the his-
tory, and creates in advance the view from unreachable de-
pendency edges. In fact, if the read-only transactions always
read the prepared view in transactional processing, they do
not make OLTP/OLAP transactions wait.
The features obtained from our model are serializability, with no
additional validations and the aborts/waits concurrently executing
write transactions, allowing read-only transactions to participate in
real-time analysis like the HTAP application.
4.1
Theoretical framework
In what follows, we introduce read safe snapshot (RSS) as a formal
deﬁnition, where we use the concept of conﬂicts on VOCSR derived
from the model of Adya et al. [2] as the prerequisite described in
the previous section. To obtain a set of transactions contained in the
serializability class, RSS is deﬁned as an unreachable transaction
region on the conﬂicts, as shown in Figure 1. Moreover, we deﬁne
a property with respect to the set of read-only transactions outside
RSS, where the operations make read-targets the most successor
versions in RSS. Finally, we claim that a multiversion scheduler
achieving serializability can correctly accept operations of the read-
only transactions in Theorem 4.4.
Deﬁnition 4.1. (Read Safe Snapshot, RSS)
Let T be a set of committed transactions, P be a set of transactions
contained in a history ⊆VOCSR, and P ⊆T. We say that P is RSS,
where P satisﬁes the following condition;
• for arbitrary transactions 푇푝∈P and 푇푞∉P (hereinafter
푇푞∈T for 푇푞), 푇푝is unreachable from 푇푞: 푇푞̸ →∗푇푝.
Deﬁnition 4.2. (Protected read-only transactions regarding to P,
푅(P) )
Let T be a set of committed transactions, P be RSS in T, and 푇∈T,
where 푇
• is not contained in P;
• has no write operations; and
• has only read operations that read the versions created by
write operations in most recent committed transactions in P.
then, we say that 푇is a protected read-only transaction (PRoT) re-
garding P and denote 푅(P) about this property.
Figure 1: Conceptual diagram of RSS. (a) represents depen-
dency edge. (b) represents transactions are unreachable in the
direction of the arrow because conﬂicts do not occur on the his-
tory preﬁx. From a read-only transaction point of view, 푇1 and
푇2 in RSS can be considered as a transaction region protected
against dependency paths through 푇3 or 푇4.
We now introduce lemma 4.3 to prove Theorem 4.4. The Lemma
4.3 claims that the transactions holding 푅(P) cannot have an incom-
ing write-read conﬂict with regard to transactions excluded from
the same set P. In addition, Theorem 4.4 claims that a scheduler
regarded as a hybrid as VOCSR and another scheduler can be cor-
rectly acceptable in one history as globally serializable.
LEMMA 4.3. For any푇푟holding 푅(P) and푇푞∉P,푇푟is unreach-
able from 푇푞: 푇푞̸ →∗푇푟.
PROOF. We assume that 푇푟is reachable from 푇푞, that is, there is
the chain 푇푞→∗푇′푞→푇푟. Here, 푇′푞∉P because otherwise, 푇′푞∈P
is reachable from 푇푞∉P, contradicting the fact that P is RSS. A
conﬂict with destination 푇푟only exists as a write-read conﬂict, be-
cause푇푟do not include write operations by deﬁnition 4.2. However,
transactions having the write-read conﬂict with destination 푇푟can
exist only on transactions contained in P. Thus, 푇푞̸ →∗푇푟holds.
□
THEOREM 4.4. For a history ℎthat applied committed projec-
tion, let ℎcontain P that compose RSS. If VOCSR scheduler 푠ac-
cepts a history ℎ′ that is the removal of the operations of 푇푟holding
푅(P) from ℎ, then ℎis also accepted.
PROOF. In ℎ′, because of Deﬁnition 4.2 and Lemma 4.3, the lost
conﬂicts from ℎare limited to any of the following;
(A) for a transaction 푇푝∈P, 푇푝→푇푟; or
(B) for a transaction 푇푞∉P, 푇푟→푇푞;
where we assume that a dependency graph from given ℎcontains a
cycle. The cycle contained a dependency edge of either (A) or (B)
on the dependency graph from ℎ, because a dependency graph from
ℎ′ does not contain cycles by the deﬁnition 4.1. In this case of (A),
then 푇푝∈P, and the cycle is 푇푝→푇푟→∗푇푝. Similarly, in the case
of (B), 푇푞∉P, and the cycle 푇푟→푇푞→∗푇푟exists. In both cases,
about a 푇′푝∈P and 푇′푞∉P, 푇′푞→푇′푝or 푇′푞→푇푟needs to appear in
the cycle, but that cannot hold by Deﬁnition 4.1 and 4.3: ℎcannot
create a cycle on a dependency graph. Thus, if ℎ′ is accepted by 푠,
then ℎis also acceptable.
□

---

Takamitsu Shioi, Takashi Kambayashi, Suguru Arakawa, Ryoji Kurosawa, Satoshi Hikida, and Haruo Yokota
COROLLARY 4.5. The opposite is also true: if ℎis accepted by
푠, then ℎ′ is also acceptable.
PROOF. Because ℎ′ is obtained by removing only some conﬂicts
from ℎ, if a conﬂict graph computed from given ℎhas no cycle, a
graph from ℎ′ is also acyclic. Thus, ℎ′ is accepted by 푠in the case
that ℎis accepted by 푠.
□
As we described in this Section 4.1, our model shows that a
history could not effect scheduler acceptability if the scheduler re-
moved transactions that hold 푅(P). Because this manipulation is re-
cursively applicable, it does not matter how many times such trans-
actions are eliminated from a history. In other words, as long as
a read-only replica perpetually reads any one of some RSS is con-
structed at the backend of transactional processing, the scheduler ac-
ceptability on the primary replica is not inﬂuenced. Finally, if a pri-
mary replica gives attention to the scheduler acceptability under tra-
ditional MVCC on OLTP, achieving global serializability on HTAP
(serializable HTAP) can be secured ﬁrmly. In fact, RSS would not
be capable of including the most recent committed versions, be-
cause OLTP that keeps processing transactions and reachable de-
pendencies against the versions would arise. However, read-only
transactions reading RSS could achieve serializability even if the
read-only transactions joined at all times while processing OLTP
transactions.
4.2
SSI-based RSS construction algorithm
In this section, we propose and inspect a construction method of
RSS. The model we denoted in Section 4.1 showed that read-only
transactions could read versions ensuring serializability. However,
a straightforward implementation requires information from each
conﬂict for tracking a dependency graph. Therefore, naively imple-
menting our model would cause potential performance problems
for OLTP or OLAP because it requires multiple complex steps; for
example, extracting conﬂicts included in the nonconcurrent state
on the OLTP component increases tracking paths in a dependency
graph and garbage collections of conﬂict information to clean up
stale RSS. We should consider how to implement our model with-
out affecting OLTP performance by OLAP participation.
As we described in Section 2, many previous systems have been
based on SI or implemented other isolation levels. Because our
model postulates serializability on the OLTP side, we focus on the
SSI of a representative example for the serializability that consists
of SI. For implementation, we propose an algorithm that optimizes
our model in SSI on OLTP. The algorithm has the characteristics of
extracting only concurrent rw-antidependency. In this section, we
make a premise on the property of SSI (dangerous structure [12] ,
SI-V and SI-W [26] ) to develop a tractable algorithm.
Let us write the algorithm with a deﬁnition in advance. We deﬁne
two types of a set of transactions and describe our algorithm as
follows;
Deﬁnition 4.6. (Transaction state; 퐷표푛푒(푝), 퐶푙푒푎푟(푝) )
Let ℎbe a history under SSI, 푝be its preﬁx, and T be a set of
transactions contained in ℎ. We denote
• 퐷표푛푒(푝) = {푇∈T | 퐸푛푑(푇) ∈푝}; and
• 퐶푙푒푎푟(푝) = {푇푎∈T | ∀푇푏∉퐷표푛푒(푝) such that 퐸푛푑(푇푎) ≺ℎ
퐵푒푔푖푛(푇푏) }.
Algorithm 1 RSS construction algorithm under SSI
(1) Contain entire 퐶푙푒푎푟(푝) in RSS.
(2) Pick up any 푇푐∈퐶푙푒푎푟(푝).
(3) Pick up 푇푢∉퐶푙푒푎푟(푝) and add to RSS if 푇푢→푇푐exists.
(4) Repeat Step (3) for all 푇푢
(5) Repeat steps (2)–(4) for all 푇푐
Algorithm 1 utilizes our theoretical framework to construct RSS
by SSI. In Figure 2, we show the relation between SSI properties
and the set of transactions we deﬁned. Here, Undone transactions
(a complementary set of Done transactions, 푇∈퐷표푛푒(푝)푐) are not
concurrent with Clear transactions 퐶푙푒푎푟(푝) by the read protocol SI-
V. On the other hand, possible concurrent transactions with Clear
transactions are contained in 퐷표푛푒(푝). We call such transactions in
퐷표푛푒(푝) Obscure transactions (푇∈퐷표푛푒(푝) ∧∉퐶푙푒푎푟(푝)). For
reaching from Undone transactions to Clear transactions, two de-
pendencies through Obscure transactions are essential. As shown
in Figure 2, such essential features cannot arise as dangerous struc-
tures under SSI. In summary, Undone transactions are unreachable
to Clear and Done transactions having rw-dependencies between
the Clear transactions. Thus, on any preﬁx of an SSI history, the
unreachable transactions can join RSS, and read-only transactions
can read the RSS to achieve serializability.
Figure 2: Conceptual diagram of RSS construction algorithm
under SSI. (a) represents rw-dependency edges. (b) represents
transactions are unreachable in direction of the arrow as rw-
conﬂicts; 푇1 and 푇2 show that the nonconcurrent relation be-
tween Clear and Undone cannot give rise to rw-dependencies.
푇4 and 푇5 show that dangerous structure cannot arise: if SSI
scheduler had accepted 푇3 ←푇4, ended (committed) transac-
tion 푇4 cannot be aborted/reachable. Similarly, if푇7 ←푇8 holds,
the SSI scheduler also should not have allowed 푇6 ←푇7, thus,
RSS cannot contain 푇7 in spite of being committed. 푇8 is an un-
committed transaction; as a result, even if푇7 ←푇8 did not arise,
RSS could have contain 푇6 because 푇6 had been unreachable as
Clear transactions.
4.3
Correctness of SSI-based algorithm
In what follows, we try to illustrate and inspect this algorithm. Here,
we denote notations for later explanation. Let us organize self-evident

---

Serializable HTAP with Abort-/Wait-free Snapshot Read
properties derived from Deﬁnition 4.6; 퐶푙푒푎푟(푝) ⊆퐷표푛푒(푝) holds:
for ∀푇푎∈퐶푙푒푎푟(푝),푇푏∉퐷표푛푒(푝), 퐸푛푑(푇푎) ≺ℎ퐵푒푔푖푛(푇푏) holds;
and for ∀푇푎∈퐶푙푒푎푟(푝),푇푏∉퐶푙푒푎푟(푝), 퐸푛푑(푇푎) ≺ℎ퐸푛푑(푇푏) holds.
Furthermore, we introduce deﬁnitions of dependency and danger-
ous structure in Fekete et al. [12]. For 푇푎,푇푏∈T, if operations
of 푇푎, 푇푏are concurrent ( 퐵푒푔푖푛(푇푎) ≺ℎ퐵푒푔푖푛(푇푏) ≺ℎ퐸푛푑(푇푎);
퐵푒푔푖푛(푇푎) ≺ℎ퐸푛푑(푇푏) ≺ℎ퐸푛푑(푇푎); 퐵푒푔푖푛(푇푏) ≺ℎ퐵푒푔푖푛(푇푎) ≺ℎ
퐸푛푑(푇푏); or 퐵푒푔푖푛(푇푏) ≺ℎ퐸푛푑(푇푎) ≺ℎ퐸푛푑(푇푏). ) and 푇푎, 푇푏sat-
isfy푇푎→푇푏, then we say that the conﬂict is vulnerable dependency.
Note that the conﬂict identiﬁed as a vulnerable dependency under
SSI only exists as concurrent rw-dependency. For 푇푎,푇푏,푇푐∈T, if
푇푎→푇푏→푇푐holds and both dependencies are vulnerable depen-
dencies, then this structure is dangerous structure. An SSI scheduler
does not accept the schedule composing this structure.
We now denote some lemmas for verifying the appropriateness
of an algorithm, where a history ℎis committed projection and ac-
cepted by an SSI scheduler. Lemma 4.7 claims that direct dependen-
cies do not arise from Active transactions to ﬁnished transactions
between nonconcurrent transactions.
LEMMA 4.7. (SSI-1)
For a history ℎand 푇푎,푇푏∈T included in ℎ, if 퐸푛푑(푇푎) ≺ℎ
퐵푒푔푖푛(푇푏) holds, then 푇푏̸ →푇푎holds.
PROOF. Considering each conﬂict, in the case of write-read con-
ﬂict, that holds because of SI-V: the SI read protocol SI-V can only
map each read operation to the most recent committed write op-
erations when the self-transaction begins. Thus, 푇푏→푇푎cannot
arise write-read conﬂicts by 퐸푛푑(푇푎) ≺ℎ퐵푒푔푖푛(푇푏). In the case of
write-write conﬂict, that holds because of SI-W: SI-W was deﬁned
so that the writesets of two concurrent transactions are disjoint, and
SSI uses SI-W and obtains practically write version orders by the
commit operation order; 푇푏→푇푎cannot hold on write-write con-
ﬂicts. In the case of read-write conﬂict, that holds because of SI-V:
if푇푏→푇푎had held, then 퐸푛푑(푇푎) ≺ℎ퐵푒푔푖푛(푇푏) must be contradic-
tion by reading the most recent committed versions. Therefore, for
each conﬂict, if 퐸푛푑(푇푎) ≺ℎ퐵푒푔푖푛(푇푏) holds, then the dependency
is unreachable from 푇푏to 푇푎.
□
In Lemma 4.8, we organize conﬂicts in the case that the begin
operation induced from processing any operations precedes (hap-
pens before) the end operation. If the case is nonconcurrent, each
direct conﬂict cannot occur against the commit operation order by
Lemma 4.7. Otherwise, read-write conﬂict only exists as the re-
verse direction of transaction order between concurrent transactions.
Moreover, we describe Lemma 4.9 , which claims the property of
Lemma 4.7 related with 퐶푙푒푎푟(푝) of Deﬁnition 4.6. The set of trans-
actions in 퐶푙푒푎푟(푝) is decided by the given preﬁx 푝of the history,
and an arbitrary preﬁx of the history can be used.
LEMMA 4.8. (SSI-2)
For a history ℎand 푇푎,푇푏∈T in ℎ, let 퐵푒푔푖푛(푇푎) ≺ℎ퐸푛푑(푇푏). If
푇푏→푇푎holds, then the dependency is vulnerable dependency.
PROOF. If 퐵푒푔푖푛(푇푎) ≺ℎ퐸푛푑(푇푎) ≺ℎ퐵푒푔푖푛(푇푏) ≺ℎ퐸푛푑(푇푏),
then 퐸푛푑(푇푎) ≺ℎ퐵푒푔푖푛(푇푏), here푇푏→푇푎does not hold by Lemma
4.7. By the deﬁnition of vulnerable dependency, dependencies ex-
cepting this case exist only as vulnerable dependencies. Therefore,
it holds.
□
LEMMA 4.9. (SSI-3)
For a historyℎand its preﬁx 푝, pick up an arbitrary푇푐∈퐶푙푒푎푟(푝)
and 푇푢∉퐶푙푒푎푟(푝). If 푇푢→푇푐holds, then it is a vulnerable depen-
dency.
PROOF. Because 퐸푛푑(푇푐) ≺ℎ퐸푛푑(푇푢) by 퐶푙푒푎푟(푝) in deﬁnition
4.6, 퐵푒푔푖푛(푇푐) ≺ℎ퐸푛푑(푇푢) holds. Thus, that holds from Lemma
4.8.
□
We showed that the transactions contained in 퐶푙푒푎푟(푝) are only
reachable from transactions outside 퐶푙푒푎푟(푝) through a vulnerable
dependency in Lemma 4.9. Although a vulnerable dependency can
exist in a dangerous structure (two successive vulnerable dependen-
cies), an SSI scheduler cannot accept the second vulnerable depen-
dency. If an SSI scheduler has accepted two successive dependen-
cies that include a vulnerable dependency as the ﬁrst dependency,
then the second dependency could not exist as a vulnerable depen-
dency: write-write or write-read conﬂicts can exist as the second
dependency. The ww-dependency and wr-dependency can arise on
nonconcurrent states and not reverse the direction of transaction or-
der. That is, on that occasion, transactions that created the outgoing
second dependency edge are also contained in 퐶푙푒푎푟(푝) by the def-
inition of 퐶푙푒푎푟(푝).
THEOREM 4.10. (SSI-4)
For the SSI history ℎand its preﬁx 푝, let 푇푐∈퐶푙푒푎푟(푝), 푇푢∉
퐶푙푒푎푟(푝),푇푣∈T. If 푇푣→푇푢→푇푐holds, then 푇푣∈퐶푙푒푎푟(푝).
PROOF. 푇푢→푇푐is a vulnerable dependency by Lemma 4.9 and
then a conﬂict exists. By contraposition of Theorem 4.7, 퐵푒푔푖푛(푇푢) ≺ℎ
퐸푛푑(푇푐) holds. Moreover, 푇푣→푇푢leads to 퐸푛푑(푇푣) ≺ℎ퐵푒푔푖푛(푇푢),
because the SSI scheduler does not accept a dangerous structure: if
푇푣→푇푢could exist, then an SSI scheduler must have accepted op-
erations of nonconcurrent transactions. Thus, 퐸푛푑(푇푣) ≺ℎ퐸푛푑(푇푐)
holds and such 푇푣can be contained in 퐶푙푒푎푟(푝) only.
□
We now prove the validity of our algorithm. Assume that P ⊆T
is a subset detected by the Algorithm 1. To say that P is RSS, for
any 푇푝∈P, 푇푞∉P, we need to show 푇푞̸ →∗푇푝. To prove by
contradiction, we assume 푇푞→∗푇푝. Then there must be at least
one direct dependency in the chain from a transaction outside P to
a transaction in P. By renaming the transaction if necessary, we as-
sume 푇푞→푇푝, where 푇푞∉P and 푇푝∈P. 푇푞∉퐶푙푒푎푟(푝) obviously
holds because of Step (1) in Algorithm 1. Considering two cases of
푇푝; (a) In the case of 푇푝∈퐶푙푒푎푟(푝), 푇푞→푇푝does not hold by
푇푞∈P in the step (3) of Algorithm 1; and (b) If 푇푝∉퐶푙푒푎푟(푝), for
푇푐∈퐶푙푒푎푟(푝), then 푇푐such that 푇푞→푇푝→푇푐must exist by Step
(3) of Algorithm 1, however, 푇푞∈퐶푙푒푎푟(푝) must hold by Lemma
4.10, and thus 푇푝∉퐶푙푒푎푟(푝) reached a contradiction. Such 푇푝, 푇푞
cannot exist and contradict the assumption because both cases of
(a); and (b) were dismissed. Therefore, P is shown to be RSS and
Algorithm 1 is appropriate.

---

Takamitsu Shioi, Takashi Kambayashi, Suguru Arakawa, Ryoji Kurosawa, Satoshi Hikida, and Haruo Yokota
5
IMPLEMENTATIONS
In this section, we introduce a prototype implementation that prac-
tically uses Algorithm 1. We implemented a prototype on top of
PostgreSQL providing SSI, because our algorithm assumes SSI for
serializability on OLTP. We implemented Algorithm 1 on single
and multinode architectures [25] because our model is applicable to
both. Although uniﬁed HTAP systems could have achieved OLAP’s
serializability derived from traditional transaction theories, writer-
/reader-abort or writer-/reader-wait (rw-conﬂict blocking or Safe
snapshots blocking) have occurred by read-only transaction partic-
ipation. As we described in Section 2, in the case of serializable
isolation for a multinode HTAP architecture, the modern architec-
ture must send the read-/write-set of concurrent transactions to each
OLTP and OLAP system and synchronously check the read-/write-
set, or need to stop starting write transactions at ﬁxed time intervals
and let OLAP replica the wait the consistent view. In fact, the idea
of safe snapshots for read-only replica is proposed in [24], but it has
not been implemented yet. PostgreSQL implementation uses the
safe snapshots in the single-node architecture only, but the method
cannot always complete within the ﬁxed time interval and have to
wait unexpectedly long times.
Our model proves that the additional read-only transactions can
participate in the existing set of transactions ensuring serializabil-
ity: systems adopting the model do not forcibly abort or wait OLTP
transactions and OLAP read-only transactions. We considered that
our HTAP-compatible model could refrain from deteriorating per-
formance of multinode storage HTAP systems. Hence, we imple-
mented the multinode architecture based on asynchronous log-shipping
replication PostgreSQL offers and illustrated the implementation in
Section 5.1.
5.1
Multinode architecture
Our implementation is based on PostgreSQL version 12.0 as shown
in Figure 3. We list in the following sections the components or cus-
tom logic that play important roles to integrate our model into Post-
greSQL SSI. To realize SSI theory, PostgreSQL detects rw-conﬂicts
between transactions while any concurrent transactions are alive.
Dependency information. Our implementation collects the de-
tected outgoing rw-dependencies and writes the dependencies as a
write-ahead log (WAL) record with self-transaction IDs to construct
RSS immediately after the reader transactions with outgoing edges
are committed; the log collector shown in Figure 3 extracts the out-
going rw-dependencies that are relevant for our algorithm. The col-
lected dependencies about a transaction were written by using logi-
cal messages that PostgreSQL offers as generic WAL records. Each
of the direct conﬂicts was expressed as an array of writer transaction
IDs in the generic WAL record.
Start/End information. In addition, commit, start and abort in-
formation about when each transaction had started (induced by the
ﬁrst operation) and ended was appended to WAL. The written com-
mit information was needed to construct the set 퐷표푛푒(푝) of trans-
action schedules from a regular WAL scan on the OLAP side. The
start/commit information was required to create 퐶푙푒푎푟(푝) on the
preﬁx from Active transactions that had started but not ended (com-
mitted or aborted) at the time when WAL inspection was executed.
For the management of Active transactions, the abort information
was used to exclude transactions from Active ones.
OLTP read-only transactions. Although PostgreSQL implemen-
tation does not require a read-only transaction to have the transac-
tion ID assigned, we assigned one for read transactions as well be-
cause the DBMS does not know beforehand if the transactions are
read-only. As a result, the OLTP side was implemented to collect de-
pendencies and start/end information about read-only transactions
as well as write transactions.
Versions Preservation. The logical messages we appended to
WAL for constructing RSS were sent by an asynchronous com-
mit option of streaming replication. PostgreSQL is implemented to
preserve multiversions from overwriting previous versions of data
items. To maintain the old version, updated transactions create a
new tuple adhered self-transaction ID and install the tuple in storage.
Stale tuples are deleted by two types of garbage collections called
vacuum and heap-only-tuple (HOT). The vacuum is explicitly ini-
tiated by a user’s call, but HOT is implicitly initiated despite the
user’s intention. Our implementation needed to maintain the stale
tuples from HOT by sending Active transaction alive information
from read-only replica called hot-standby-feedback in PostgreSQL
conﬁguration.
We use logical decoding that is offered by PostgreSQL for read-
ing the information in generic WAL records. We reformed the read
replica on the streaming replication environment to be able to use
the logical decoding. The logical decoding was executed from an
external processing module at ﬁxed intervals. RSS construction in-
voker is the external module that keeps snapshots and replaces them
with RSS as transactions. Regularly transaction module executes
UDFs that we created to decode the generic WAL, manage depen-
dency graph, and construct RSS.
RSS manager. The decoded information was used to construct
the brief transaction history on PostgreSQL shared memory. The
history sequence consists of start and commit times of transactions
that have been started or committed by the time the invoker trans-
actions are executed. The RSS manager constructs Active, Done,
Clear transactions using a hash table of transaction IDs by scanning
the history. Active transactions contain transactions having start in-
formation only, while on the previous preﬁx of the history, the pre-
vious Active transactions are transformed to Done or Clear when
commit information existed on the time scanning WAL. If abort info
had arrived at the time of WAL inspection, transaction IDs transfer
from Active transactions to the set of transaction IDs for garbage
collection. Clear and Done transactions are carefully managed for
the RSS construction algorithm.
In addition, decoded dependency information is required to con-
struct RSS, thus, we implemented a dependency graph on the shared
memory of PostgreSQL to preserve the sent dependency informa-
tion as a vertex of the transaction ID and a path of the dependencies.
If the dependency graph could discover paths from Clear transac-
tions to Done transactions, RSS contains the discovered transac-
tion IDs. Prepared as UDF, these RSS construction and dependency
graph operations are called in a snapshot replacing transaction RSS
construction invoker offers.
PRoT manager. To replace snapshots with RSS, the snapshot-
preserving transactions called from the RSS construction invoker
must keep executing by the time the next RSS construction ended.

---

Serializable HTAP with Abort-/Wait-free Snapshot Read
Figure 3: Multinode architecture overview. Twin Arrows ⇔represent clients. Arrow →represents existing processing ﬂows of Post-
greSQL. Open arrow ⇒represents newly implemented processing ﬂows.
The RSS and dependency graph construction operations were im-
plemented in PRoT manager as UDFs. The PRoT manager calls
RSS and dependency graph construction operations and receives the
current RSS information as a snapshot data of PostgreSQL from the
RSS manager. The RSS snapshot data are exported to transactions
on the read-only replica.
5.2
Single-node architecture
Although our algorithm can be efﬁciently applied to the multinode
architecture, comparative approaches achieving serializability have
not existed on the multinode architecture: HTAP systems are used to
put off serializable isolation for better performance. In addition, the
idea of safe snapshots on read replica in [24] was not implemented
in PostgreSQL. Because comparative methods like SSI and SSI
+ Safe Snapshots had been only applied in the single-node archi-
tecture, for evaluations of performance overheads from aborts and
waits for serializability, we implemented our algorithm in single-
node architecture.
The other system we implemented is summarized in Figure 4.
This single-node system was mostly based on the multi-node archi-
tecture in previous Section 5.1 without using log-shipping replica-
tion. Versions that RSS contained had been ﬁrmly preserved by the
snapshot-preserving transactions of RSS construction invoker until
the next RSS constructed. This architecture is needed to recognize
that transactions are read-only transactions for the use of RSS. Be-
cause analytical use queries like TPC-H benchmarks are known as
Figure 4: Single-node architecture overview
read-only in advance, we modiﬁed such benchmark queries by ap-
pending a PostgreSQL command that a transaction is speciﬁed as
read-only. In addition, this implementation was modiﬁed to execute
a transaction that could read RSS if a read-only ﬂag in PostgreSQL
exists. Regarding OLTP read-only transactions as presented in the
TPC-C benchmark, RSS is not used but read-only anomalies do
not arise by SSI as OLTP protocols, because we considered that the
OLTP side would be basically used as processing write transactions.

---

Takamitsu Shioi, Takashi Kambayashi, Suguru Arakawa, Ryoji Kurosawa, Satoshi Hikida, and Haruo Yokota
6
EVALUATION
In this section, we evaluate the two types of prototype systems
we proposed in Section 5. Our systems are evaluated under a CH-
BenCHmark [9] of OLTP-Benchmark 1 [11]. OLTP-Benchmark im-
plements CH-BenCHmark derived from TPC-C and TPC-H bench-
marks to evaluate DBMSs designed to serve both OLTP and OLAP
workloads. All experiments were conducted on scale factor 100
(SF100; 100 warehouses on CH-BenCHmark) in the benchmark
test. Each test duration was 5 minutes and the warmup duration
was 60 seconds after the initial data load of SF100 ﬁnished; the to-
tal run time was about 25 minutes. Comparison systems were set up
for each of evaluation purpose associated with our two systems as
follows:
• First, we investigated the abort rate and performance in com-
parison to both of PostgreSQL’s SSI and safe snapshots that
PostgreSQL can only support each serializable method in a
single-node architecture. We denote that applying safe snap-
shots (read-only deferrable transaction) in TPC-H queries
is "SSI+SafeSnapshots." Executing OLTP transactions and
OLAP queries under SSI is denoted by "SSI." Our prototype
system, where analytical queries derived from TPC-H were
executed under RSS, is denoted by "SSI+RSS."
• Second, we test the performance overhead of RSS construc-
tion against SI that PostgreSQL offers as repeatable read iso-
lation levels in a read-only replica. Each primary and read-
only replica was launched by PostgreSQL instances on two
servers as multinode architectures in this Section 6. We de-
note that applying SI in the read-only replica is "SSI+SI." On
the other hand, our system architecture, where the primary
node uses SSI and the replica node applies RSS, is denoted
by "SSI+RSS."
Environment. The experiments of single-node architectures were
run on a client server publishing transactions of the CH-BenCHmark
and a database server executing the transactions. The client server
was equipped with four Intel(R) Xeon(R) Platinum 8176 CPUs with
2.10 GHz processors, having 28 physical cores (32-KB L1i + 32-
KB L1d cache, 1024-KB L2 cache, and 39.424-MB L3 shared cache)
and 224 logical cores, 512 GB of DRAM and 440 GB of SSD. The
database server with two Intel(R) Xeon(R) Platinum 8176 CPUs
clocked at 2.10 GHz with 28 physical cores (32-KB L1i + 32-KB
L1d cache, 1024-KB L2 cache, and 39.424-MB L3 shared cache)
has 112 logical cores, 1 TB DRAM and 440 GB SSD. In the case
of the experiments of multinode architectures, PostgreSQL primary
and replica were constructed on two database servers. All the exper-
iments were run on these servers with the Ubuntu 18.04.3 OS and
PostgreSQL 12.0.
6.1
Serializability impact on HTAP
We experimentally compared with serializable methods of the SSI
and SSI+SafeSnapshots under the hybrid OLTP and OLAP work-
loads. The serializability of SSI+RSS implementation of Section
5.2 was conﬁrmed by reading the previous version and using the ex-
ample queries Ports and Grittner [24] illustrated read-only anomaly
in PostgreSQL. Reader-wait of safe snapshots (SSI+SafeSnapshots)
1https://github.com/oltpbenchmark/oltpbench
serializability was also conﬁrmed by the example of read-only anom-
alies: a read-only transaction waits to ﬁnish the concurrent transac-
tion in the example. Such read-only deferrable transactions might
affect concurrent write transactions in OLTP as much as OLAP. Al-
though these comparison methods might be affected by the valida-
tion cost of serializability, we considered that SSI+RSS can save
such costs derived from read-only transaction participation. There-
fore, we investigated the performance of OLTP and OLAP respec-
tively, while varying the number of OLTP and OLAP clients.
Figure 5 shows the transition of average OLTP performance ex-
ecuting CH-BenCHmark when OLTP and OLAP clients increased
to 48 from 1. The x-axis shows the number of OLTP clients. The
y-axis shows the OLTP transactions per second. Similarly, Figure
6 shows the transition of average OLAP performance when trans-
actional clients and analytical clients were increased to 48 from 1.
The y-axis shows the OLAP queries per hour. Figure 7 shows the
abort rate measured in the same experiments. In Figure 7, we ag-
gregated transactions of aborts and retries of serialization failures
that resulted from the benchmark log and summarized the rate as
the quotient of both OLTP transactions and OLAP queries.
As shown in Figure 5, the experiments show decreasing OLTP
throughput on increasing the number of OLAP clients. On the other
hand, OLAP throughput basically did not change in Figure 6 even
though the number of OLAP clients increased. Figure 7 also ex-
hibits a similar tendency. In particular, the SSI abort rate of 48
OLTP clients was about 35% as abort transactions occurred even
if one of the OLAP clients participated. Under CH-BenCHmark,
the OLAP read-only transactions were not aborted in exchange for
aborting OLTP write transactions. Because dangerous structure tends
to capture the long-running scan-heavy OLAP transactions as ﬁrst
reader transaction forming two successive rw-dependencies in con-
trast to the short-running OLTP write transactions. OLTP through-
put decreases by writer-aborts from read-only transaction partici-
pation. In addition, SSI is difﬁcult for multi-node HTAP systems
that cannot efﬁciently execute such writer-abort described in Sec-
tion 3.3.
Consequently, SSI+SafeSnapshots applying read-only optimized
SSI of PostgreSQL [24] could improve even better than SSI of
OLTP and OLAP throughput. Because read-only transactions could
avoid such writer-aborts and rw-dependency checks in SSI valida-
tion (taking the advantage of reducing the cost of SIRead Lock) by
reading snapshots ensuring beforehand serializable history, the over-
all abort rate under SSI+SafeSnapshots results was lower than SSI
that of SSI. In addition, the OLAP throughput was less affected in
the face of the reader-wait problem that read-only deferrable trans-
actions must wait by the time the safe snapshots are constructed.
Figure 6 shows that the OLAP throughput of SSI+RSS was about
10% higher on average than SSI+SafeSnapshots on the runs from 1
to 48 OLAP clients. To realize efﬁciently serializable HTAP appli-
cation, RSS can ensure serializability without reader-/writer-aborts
by read-only transaction participation in concepts that constructsa
serializable snapshot beforehand (wait-free snapshot read). How-
ever, the RSS OLAP throughput shows similar performance with
SSI+SafeSnapshots. Compared with safe snapshots construction meth-
ods, the RSS construction method described in Section 4.1 can exe-
cute OLAP read-only transactions, ensuring serializability while ex-
ecuting concurrently long-running write transactions on the OLTP

---

Serializable HTAP with Abort-/Wait-free Snapshot Read
Figure 5: OLTP throughput on single-node architecture
Figure 6: OLAP throughput on single-node architecture
Figure 7: Abort rate on single-node architecture
side. In the case of CH-BenCHmark having workload features of
TPC-C like short-running write transactions, the write transactions
started before the read-only deferrable transactions of SSI+SafeSnapshots
can ﬁnish within short time.
Although SSI+RSS collects rw-conﬂict and start/end informa-
tion of extended information, the snapshot construction overhead is
considered to be lower than SSI+SafeSnapshots. As shown in Fig-
ure 7, the SSI+RSS overhead was lower than SSI+SafeSnapshots
overhead in abort rate when OLTP clients increased. SSI+RSS OLTP
throughput was about 20% higher than SSI+SafeSnapshots in the
experiments. of 48 OLTP clients. SSI+RSS could improve OLTP
performance despite the overheads collecting extended information
for RSS construction.
6.2
RSS handling cost for SI-based replica
In the following experiment, we tested RSS construction overheads
in the case of a multinode architecture. In the same way as single-
node experiments, we examined the OLTP and OLAP throughput
of CH-BenCHmark. We evaluated our system that could achieve
serializability in comparison with SSI+SI, which could have not
achieve serializability of OLAP replica by read-only anomalies, for

---

Takamitsu Shioi, Takashi Kambayashi, Suguru Arakawa, Ryoji Kurosawa, Satoshi Hikida, and Haruo Yokota
investigation of our serializability assurance overhead. In the same
way as single-node experiments, Figure 8 shows the OLTP through-
put of SSI+SI and SSI+RSS, Figure 9 shows the OLAP throughput,
and Figure 10 shows the abort rate.
Figure 8: OLTP throughput of on multinode architecture
Figure 9: OLAP throughput on multi-node architecture
Figure 10: Abort rate on multinode architecture
As in the single-node case in Section 6.1, on the results of SSI+RSS
in Figure 8, show that even if the number of OLAP clients increases,
OLTP performance mostly does not fall. On the other hand, the
SSI+SI read-only replica executing OLAP queries under SI does
not need serialization cost. Nevertheless, OLAP performance of
SSI+RSS is almost the same performance of SSI+SI because of
wait-free snapshot read by constructing RSS beforehand.
On the OLTP side, SSI+SI is always better than the OLTP through-
put of SSI+RSS. We set hot_standby_feedback and replication slot
PostgreSQL offers the version preservation of replica for correct
evaluation of SSI+SI because OLAP query results in errors that
try to read deleted versions, and we make the same settings of
the replica equal to SSI+RSS. We consider OLTP degradations of
SSI+SI and SSI+RSS to be caused by preserving old versions, dis-
abling HOT mechanism utilization on PostgreSQL. In particular, by
reading the versioned tuples in the direction from the oldest to the
newest in the transaction processing of PostgreSQL, OLAP clients
would result in OLTP performance deterioration. Furthermore, the
OLTP side of SSI+RSS forces each write transaction to log ex-
tended information, which caused performance deterioration. These
factors show that the serialization cost of OLAP read-only transac-
tions would be bigger than nonserializable analysis of SI in real
time, because SSI+RSS OLTP average throughput is 10 % lower
than SSI+SI when experiments run on 48 OLTP clients. In contrast,
Figure 9 and Figure10 show that the OLAP throughput and abort
rate are almost the same in overall runs: these results are consid-
ered that RSS achieves wait-/abort-free read with serializability by
read-only transaction participation in real time.
7
CONCLUSION
This paper addresses a missing part of MVCC aspects of read-only
transactions and version selection. In particular, we considered that
serializability, where read-only transactions frequently participated,
will be needed for database applications like HTAP. We introduced
the concepts of RSS and the construction algorithm to achieve global
serializability meaning that OLAP read-only transactions can step
in OLTP transaction histories by choosing previous versions.
Our prototype systems based on PostgreSQL could apply the al-
gorithm for HTAP architectures categorized into two types called
uniﬁed (single-node) and decoupled (multinode) systems. We eval-
uated the performance of our systems under OLTP and OLAP work-
loads. In the single-node system where serializable methods (SSI
or SSI+SafeSnapshots) were offered, we improved OLTP through-
put by up to 20%. In addition, the RSS construction overhead on a
multinode system was restrained by 10% in comparison with SSI+SI
that causes anomalies on OLAP replica; SSI+SI cannot achieve se-
rializability. In contrast, SSI+RSS achieve serializability and the
OLTP/OLAP throughput did not degrade much against the compar-
ison methods on single-/multinode architecture, and the OLTP/O-
LAP abort rate also did not increase: these show that our approach
can read snapshots wait-/abort-free even if read-only transactions
were continuously executed. We will aim to handle workloads in-
cluding both OLTP and OLAP within a single transaction in fu-
ture work. Besides, we are going to study scale-out architecture and
tiering capabilities of multinode servers for the RSS-based perfor-
mance enhancement because RSS can reasonably add serializable
read-only replica nodes without consensus or synchronous commit
algorithms.
8
ACKNOLEDGEMENTS
This work is based on results obtained from project JPNP16007,
commissioned by the New Energy and Industrial Technology De-
velopment Organization (NEDO).
REFERENCES
[1] Atul Adya. 1999. Weak Consistency: A Generalized Theory and Optimistic Im-
plementations for Distributed Transactions. Ph.D. MIT, Cambridge, MA, USA.
Also as Technical Report MIT/LCS/TR-786.

---

Serializable HTAP with Abort-/Wait-free Snapshot Read
[2] A. Adya, B. Liskov, and P. O’Neil. 2000.
Generalized isolation level deﬁni-
tions. In Proceedings of 16th International Conference on Data Engineering (Cat.
No.00CB37073). 67–78.
[3] Raja Appuswamy, Manos Karpathiotakis, Danica Porobic, and Anastasia Aila-
maki. 2017. The case for heterogeneous HTAP. In 8th Biennial Conference on
Innovative Data Systems Research.
[4] Hal Berenson, Philip Bernstein, Jim Gray, Jim Melton, Elizabeth O’Neil, and
Patrick O’Neil. 2007.
A critique of ANSI SQL isolation levels.
CoRR ab-
s/cs/0701157 (01 2007). https://doi.org/10.1145/223784.223785
[5] Philip A. Bernstein, Vassos Hadzilacos, and Nathan Goodman. 1987. Concur-
rency Control and Recovery in Database Systems. Addison-Wesley.
[6] M. A. Bornea, O. Hodson, S. Elnikety, and A. Fekete. 2011.
One-
copy
serializability
with
snapshot
isolation
under
the
hood.
In
2011
IEEE
27th
International
Conference
on
Data
Engineering.
625–636.
https://doi.org/10.1109/ICDE.2011.5767897
[7] Yuri Breitbart, Hector Garcia-Molina, and Avi Silberschatz. 1992.
Overview
of Multidatabase Transaction Management. The VLDB Journal 1, 2, 181–240.
https://doi.org/10.1007/BF01231700
[8] Biswapesh Chattopadhyay, Priyam Dutta, Weiran Liu, Ott Tinn, Andrew Mc-
cormick, Aniket Mokashi, Paul Harvey, Hector Gonzalez, David Lomax, Sagar
Mittal, et al. 2019. Procella: Unifying serving and analytical data at YouTube.
Proceedings of the VLDB Endowment 12, 12 (2019), 2022–2034.
[9] Richard Cole, Florian Funke, Leo Giakoumakis, Wey Guy, Alfons Kemper, Ste-
fan Krompass, Harumi Kuno, Raghunath Nambiar, Thomas Neumann, Meikel
Poess, Kai-Uwe Sattler, Michael Seibold, Eric Simon, and Florian Waas. 2011.
The Mixed Workload CH-BenCHmark. In Proceedings of the Fourth Interna-
tional Workshop on Testing Database Systems (Athens, Greece) (DBTest ’11).
Association for Computing Machinery, New York, NY, USA, Article 8, 6 pages.
https://doi.org/10.1145/1988842.1988850
[10] Cristian Diaconu, Craig Freedman, Erik Ismert, Per-Ake Larson, Pravin Mit-
tal, Ryan Stonecipher, Nitin Verma, and Mike Zwilling. 2013. Hekaton: SQL
Server’s Memory-Optimized OLTP Engine. In Proceedings of the 2013 ACM
SIGMOD International Conference on Management of Data (New York, New
York, USA) (SIGMOD ’13). Association for Computing Machinery, New York,
NY, USA, 1243–1254. https://doi.org/10.1145/2463676.2463710
[11] Djellel Eddine Difallah, Andrew Pavlo, Carlo Curino, and Philippe Cudre-
Mauroux. 2013.
OLTP-Bench: An Extensible Testbed for Benchmarking
Relational Databases.
Proc. VLDB Endow. 7, 4 (Dec. 2013), 277–288.
https://doi.org/10.14778/2732240.2732246
[12] Alan Fekete, Dimitrios Liarokapis, Elizabeth O’Neil, Patrick O’Neil, and Dennis
Shasha. 2005. Making Snapshot Isolation Serializable. ACM Trans. Database
Syst. 30, 2 (June 2005), 492–528. https://doi.org/10.1145/1071610.1071615
[13] Alan Fekete, Elizabeth O’Neil, and Patrick O’Neil. 2004. A Read-Only Transac-
tion Anomaly under Snapshot Isolation. SIGMOD Rec. 33, 3 (Sept. 2004), 12–14.
https://doi.org/10.1145/1031570.1031573
[14] Hyungsoo
Jung,
Hyuck
Han,
Alan
Fekete,
and
Uwe
Röhm.
2011.
Serializable
Snapshot
Isolation
for
Replicated
Databases
in
High-
Update Scenarios.
Proc. VLDB Endow. 4, 11 (Aug. 2011), 783–794.
https://doi.org/10.14778/3402707.3402718
[15] A. Kemper and T. Neumann. 2011.
HyPer: A hybrid OLTP OLAP
main memory database system based on virtual memory snapshots. In
2011 IEEE 27th International Conference on Data Engineering. 195–206.
https://doi.org/10.1109/ICDE.2011.5767867
[16] Per-Åke Larson, Spyros Blanas, Cristian Diaconu, Craig Freedman, Jignesh M.
Patel, and Mike Zwilling. 2011. High-Performance Concurrency Control Mecha-
nisms for Main-Memory Databases. Proc. VLDB Endow. 5, 4 (Dec. 2011), 298–
309. https://doi.org/10.14778/2095686.2095689
[17] Juchang Lee, Michael Muehle, Norman May, Franz Faerber, Vishal Sikka, Hasso
Plattner, Jens Krüger, and Martin Grund. 2013.
High-Performance Transac-
tion Processing in SAP HANA.
IEEE Data Eng. Bull. 36, 2 (2013), 28–33.
http://sites.computer.org/debull/A13june/hana1.pdf
[18] Darko Makreshanski, Jana Giceva, Claude Barthels, and Gustavo Alonso.
2017.
BatchDB: Efﬁcient Isolated Execution of Hybrid OLTP+OLAP Work-
loads for Interactive Applications. In Proceedings of the 2017 ACM Inter-
national Conference on Management of Data (Chicago, Illinois, USA) (SIG-
MOD ’17). Association for Computing Machinery, New York, NY, USA, 37–50.
https://doi.org/10.1145/3035918.3035959
[19] Henrik Mühe, Alfons Kemper, and Thomas Neumann. 2011. How to Efﬁciently
Snapshot Transactional Data: Hardware or Software Controlled?. In Proceedings
of the Seventh International Workshop on Data Management on New Hardware
(Athens, Greece) (DaMoN ’11). Association for Computing Machinery, New
York, NY, USA, 17–26. https://doi.org/10.1145/1995441.1995444
[20] Thomas Neumann, Tobias Mühlbauer, and Alfons Kemper. 2015.
Fast
Serializable Multi-Version Concurrency Control for Main-Memory Database
Systems. In Proceedings of the 2015 ACM SIGMOD International Confer-
ence on Management of Data (Melbourne, Victoria, Australia) (SIGMOD
’15). Association for Computing Machinery, New York, NY, USA, 677–689.
https://doi.org/10.1145/2723372.2749436
[21] Fatma Özcan, Yuanyuan Tian, and Pinar Tözün. 2017.
Hybrid Transaction-
al/Analytical Processing: A Survey. In Proceedings of the 2017 ACM Interna-
tional Conference on Management of Data (Chicago, Illinois, USA) (SIGMOD
’17). Association for Computing Machinery, New York, NY, USA, 1771–1775.
https://doi.org/10.1145/3035918.3054784
[22] Oracle White Paper. 2015. Oracle GoldenGate 12 c : Real-Time Access to Real-
Time Information. (March 2015).
[23] Hasso Plattner. 2009. A Common Database Approach for OLTP and OLAP Using
an In-Memory Column Database. In Proceedings of the 2009 ACM SIGMOD
International Conference on Management of Data (Providence, Rhode Island,
USA) (SIGMOD ’09). Association for Computing Machinery, New York, NY,
USA, 1–2. https://doi.org/10.1145/1559845.1559846
[24] Dan R. K. Ports and Kevin Grittner. 2012.
Serializable Snapshot Isola-
tion in PostgreSQL.
Proc. VLDB Endow. 5, 12 (Aug. 2012), 1850–1861.
https://doi.org/10.14778/2367502.2367523
[25] Aunn Raza, Periklis Chrysogelos, Angelos Christos Anadiotis, and Anas-
tasia Ailamaki. 2020.
Adaptive HTAP through Elastic Resource Sched-
uling. In Proceedings of the 2020 ACM SIGMOD International Confer-
ence on Management of Data (Portland, OR, USA) (SIGMOD ’20). As-
sociation for Computing Machinery, New York, NY, USA, 2043–2054.
https://doi.org/10.1145/3318464.3389783
[26] Ralf Schenkel and Gerhard Weikum. 2000. Integrating Snapshot Isolation into
Transactional Federation. In Proceedings of the 7th International Conference on
Cooperative Information Systems (CooplS ’02). Springer-Verlag, Berlin, Heidel-
berg, 90–101.
[27] Ralf Schenkel, Gerhard Weikum, Norbert Weißenberg, and Xuequn Wu. 2000.
Federated Transaction Management with Snapshot Isolation. In Transactions and
Database Dynamics, Gunter Saake, Kerstin Schwarz, and Can Türker (Eds.).
Springer Berlin Heidelberg, Berlin, Heidelberg, 1–25.
[28] Stephen Tu, Wenting Zheng, Eddie Kohler, Barbara Liskov, and Samuel Mad-
den. 2013. Speedy Transactions in Multicore In-Memory Databases. In Proceed-
ings of the Twenty-Fourth ACM Symposium on Operating Systems Principles
(Farminton, Pennsylvania) (SOSP ’13). Association for Computing Machinery,
New York, NY, USA, 18–32. https://doi.org/10.1145/2517349.2522713
[29] P. Unterbrunner, G. Giannikis, G. Alonso, D. Fauser, and D. Kossmann. 2009.
Predictable Performance for Unpredictable Workloads. Proc. VLDB Endow. 2, 1
(Aug. 2009), 706–717. https://doi.org/10.14778/1687627.1687707
[30] Gerhard Weikum and Gottfried Vossen. 2001. Transactional Information Sys-
tems: Theory, Algorithms, and the Practice of Concurrency Control and Recov-
ery. Morgan Kaufmann Publishers Inc., San Francisco, CA, USA.

---

