# SpotLess: Concurrent Rotational Consensus Made Practical through Rapid View Sync

> 来源: https://arxiv.org/pdf/2302.02118

SpotLess: Concurrent Rotational Consensus Made Practical
through Rapid View Synchronization
Dakai Kang, Sajjad Rahnama, Jelle Hellings†, Mohammad Sadoghi
Exploratory Systems Lab, Department of Computer Science, University of California, Davis
†Department of Computing and Software, McMaster University
ABSTRACT
The emergence of blockchain technology has renewed the interest
in consensus-based data management systems that are resilient to
failures. To maximize the throughput of these systems, we have
recently seen several prototype consensus solutions that optimize
for throughput at the expense of overall implementation complexity,
high costs, and reliability. Due to this, it remains unclear how these
prototypes will perform in real-world environments.
In this paper, we present SpotLess, a novel concurrent rotational
consensus protocol made practical. Central to SpotLess is the com-
bination of (1) a chained rotational consensus design for replicating
requests with a reduced message cost and low-cost failure recovery
that eliminates the traditional complex, error-prone view-change
protocol; (2) the novel Rapid View Synchronization protocol that
enables SpotLess to work in more general network assumptions,
without a need for a Global Synchronization Time to synchronize
view, and recover valid earlier views with the aid of non-faulty repli-
cas without the need to rely on the primary; (3) a high-performance
concurrent consensus architecture in which independent instances
of the chained consensus operate concurrently to process requests
with high throughput, thereby avoiding the bottlenecks seen in
other rotational protocols.
Due to the concurrent consensus architecture, SpotLess greatly
outperforms traditional primary-backup consensus protocols such
as Pbft (by up to 430%), Narwhal-HS (by up to 137%), and Hot-
Stuff (by up to 3803%). Due to its reduced message cost, SpotLess
is even able to outperform RCC, a state-of-the-art high-throughput
concurrent consensus protocol, by up to 23%. Furthermore, Spot-
Less is able to maintain a stable and low latency and consistently
high throughput even during failures.
1
INTRODUCTION
The emergence of Bitcoin [49] and blockchain technology has
renewed the interest in consensus-based resilient data management
systems (RDMSs) [10, 18, 21, 41, 50, 52] that can provide resilience
to failures and can manage data between fully-independent parties
(federated data management). Due to these qualities, there is wide-
spread interest in RDMSs with applications in finance, health care,
IoT, agriculture, fraud-prevention, and other industries [36, 42, 54,
57, 65].
Although Bitcoin builds on many pre-existing techniques, the
novel way in which Bitcoin used these techniques was a major
breakthrough for resilient systems, as Bitcoin showed that re-
silient systems with thousands of participants can solve large-scale
problems [35, 50]. Furthermore, Bitcoin did so in a permissionless
way without requiring a known set of participants and allowing
participants to join and leave the system at any time. The highly-
flexible permissionless design of blockchains such as Bitcoin and
Ethereum [69] is not suitable for high-performance RDMSs, how-
ever: their abysmal transaction throughput, high operational costs,
and per-transaction costs make them unsuitable for typical data-
based applications [15, 20, 35, 49, 50, 68, 69]. Instead, data-based
applications often are deployed in an environment with a set of
identifiable participants (who may behave arbitrarily) due to which
they can use permissioned designs using primary-backup consensus
protocols [10, 23, 39, 51, 70] such as the Practical Byzantine Fault
Tolerance consensus protocol (Pbft) [10].
RDMSs with fine-tuned primary-backup consensus implementa-
tions can process hundreds-of-thousands client requests per sec-
ond [28]. Such high-throughput implementations come with severe
limitations, however. First, in primary-backup consensus, a sin-
gle replica (the primary) coordinates the replication of requests.
Due to this central role of the primary, performance is usually bot-
tlenecked by the network bandwidth or computational resources
available to that primary [29, 62, 63]. Furthermore, the central
role of the primary is detrimental to scalability, due to which high
throughput can only be achieved on small-scale deployments. Fi-
nally, the techniques necessary in primary-backup consensus to
reach high throughput (e.g., out-of-order processing [10, 28]) re-
quire complex implementations that keep track of many partially-
processed rounds of consensus. When recovering from failures,
this normal-case complexity necessitates complex and costly (in
terms of message size and duration) view-change protocols to figure
out which of these partially-processed consensus rounds can con-
tribute to a consistent recovered state. Recently, we have seen two
significant developments to address these limitations in isolation.
First, the introduction of concurrent consensus protocols such as
RCC [29], MirBFT [62] and ISS [63] have significantly improved the
scalability and performance of high-throughput consensus. These
concurrent consensus protocols do so by taking a primary-backup
consensus protocol such as Pbft as their basis and then run mul-
tiple instances (each with a distinct primary, e.g., each non-faulty
replica is a primary of its own instance) at the same time, this to
remove any single-replica bottlenecks. On the one hand, the concur-
rent consensus is able to eliminate bottlenecks, improve scalability,
and improve performance. On the other hand, existing concurrent
consensus protocols do so by further increasing both the implemen-
tation complexity and the cost of recovery. For example, RCC shuts
down faulty primaries for an exponentially increasing number of
rounds after receiving sufficient complaints.
Second, the introduction of the chained consensus protocol Hot-
Stuff [71] has provided a simplified and easier-to-implement con-
sensus protocol with low communication costs. To achieve this,
arXiv:2302.02118v6  [cs.DB]  20 Dec 2023

---

Environment
Concurrent
Chained
Threshold
Communication Complexity
Protocol
Safety
Liveness
Consensus
Consensus Signatures Phases Messages (at primary) (per decision)
SpotLess
Asynchronous Partial Synchrony
yes
yes
no
6
𝑐(3n2)
𝑐(3n)
n2
Pbft [10]
Asynchronous Partial Synchrony
no
no
no
3
2n2
3n
2n2
RCC [29]
Asynchronous Partial Synchrony
yes
no
no
3
𝑐(2n2)
𝑐(3n)
2n2
HotStuff [71] Asynchronous Partial Synchrony
no
yes
yes
8
8n
4n
2n
Figure 1: Comparison of SpotLess with three state-of-the-art consensus protocols. Here, n is the number of replicas, 𝑐, 1 ≤𝑐≤n,
is the number of concurrent instances, and the per decision cost is the amortized cost of a single consensus decision.
HotStuff chains consecutive consensus decisions, which allows
HotStuff to overlap communication costs for consecutive consen-
sus decisions and minimize the cost of recovery. HotStuff uses
low-cost recovery to change primaries after each consensus de-
cision, thereby reducing the impact of any malicious primaries.
Finally, HotStuff uses threshold signatures [6] to make all com-
munication phases linear in cost. The commendable simplicity and
low cost of HotStuff do come at the expense of performance and
resilience, however. First, the rotational design of HotStuff, which
disables out-of-order processing, inherently bounds performance by
message delays and makes HotStuff incapable of fully utilizing
computing and network resources, which causes the low through-
put of HotStuff. The negative impact of message delays is further
compounded by the reliance on threshold signatures, which incur
additional rounds of communication and have high computational
costs. Furthermore, the low-cost design of recovery in HotStuff
reduces the resilience compared to Pbft, as HotStuff relies on a
black-box Pacemaker for view synchronization, which is essential
to the liveness of rotational protocols. [1, 74].
In this paper, we present SpotLess, the first practical consensus
protocol that combines simplicity with high performance. SpotLess
does so by combining a novel chained rotational consensus design
that is optimized toward simplicity, resilience, low message com-
plexity, and latency with a high-performance concurrent consensus
architecture. Central to the chained rotational consensus design
of SpotLess is Rapid View Synchronization (RVS), which provides
continuous low-cost primary rotation to deal with malicious be-
havior. RVS enables SpotLess to work in more general network
assumptions, without a need for a Global Synchronization Time to
synchronize view, and recover valid earlier views with the aid of
non-faulty replicas without the need to rely on the primary.
The rotational design of SpotLess eliminates the need for the
traditional complex and error-prone view-change protocols found
in Pbft and its variants: due to the rotational design of SpotLess,
only information on a single round is used during recovery. In
addition, RVS provides strong view synchronization, resolving the
liveness issues of previous works. Furthermore, RVS does not re-
quire costly threshold signatures and provides robust failure re-
covery steps even when communication is unreliable. Finally, by
combining the chained rotational consensus design with a concur-
rent consensus architecture, we remove the bottleneck of message
delays typically seen in rotational designs without having to resort
to highly-complex implementation techniques such as out-of-order
processing.
To evaluate the performance of SpotLess in practice, we have
implemented SpotLess in Apache ResilientDB (Incubating), our
high-performance resilient blockchain database that serves as a
testbed for future RDMS technology. Our evaluation shows that
SpotLess greatly outperforms existing consensus protocols such
as Pbft [10] by up to 430%, Narwhal-HS [13] by up to 137%, and
HotStuff [70] by up to 3803%. Furthermore, due to the low mes-
sage complexity of SpotLess, it is even able to outperform RCC [29]
by up to 23% in normal conditions while serving client requests
with lower latency in all cases. Finally, due to the robustness of
RVS, SpotLess is able to maintain a stable latency and consistently
high throughput even during failures.
Our contributions are as follows:
(1) In Section 3, we present the single-instance chained consen-
sus design of SpotLess that provides the consensus replica-
tion using rapid view synchronization.
(2) In Section 4, we provide the concurrent consensus architec-
ture employed by SpotLess to run multiple instances of the
chained consensus in parallel, due to which SpotLess has
highly-scalable throughput akin to RCC.
(3) In Section 6, we empirically evaluate SpotLess in Apache
ResilientDB and compare its performance with state-of-
the-art consensus protocols such as HotStuff [70], Pbft [10],
RCC [29], and Narwhal-HS [13]. In our evaluation, we
show the excellent properties of SpotLess, which is even
able to achieve higher throughput than the concurrent con-
sensus protocol RCC, while providing a low and stable
latency in all cases.
In addition, we introduce the terminology and notation used
throughout this paper in Section 2, discuss related work in Sec-
tion 7, and conclude on our findings in Section 8. Finally, we have
summarized the properties of SpotLess and how they compare
with other common and state-of-the-art consensus protocols in
Figure 1.
2
PRELIMINARIES
System. We model our system as a fixed set of replicas ℜ. We
write n = |ℜ| to denote the number of replicas and we write f
to denote the number of faulty replicas. Each replica 𝑅∈ℜhas
a unique identifier id(𝑅) with 0 ≤id(𝑅) < n. We assume n > 3f
(a minimal requirement to provide consensus in an asynchronous
environment [28]), that non-faulty replicas behave in accordance
with the protocols they are executing, and that faulty replicas can
behave arbitrarily, possibly coordinated and malicious ways. We do
2

---

not make any assumptions about clients: all clients can be malicious
without affecting SpotLess.
Consensus. SpotLess is a consensus protocol that decides the se-
quence of client requests executed by all non-faulty replicas in the
system ℜ. To do so, SpotLess provides three consensus guaran-
tees [28, 64]:
(1) Termination. If non-faulty replica 𝑅∈ℜdecides upon an
𝜌-th client request, then all non-faulty replicas 𝑄∈ℜwill
decide upon an 𝜌-th client request;
(2) Non-Divergence. If non-faulty replicas 𝑅1, 𝑅2 ∈ℜmake 𝜌-th
decisions 𝜏1 and 𝜏2, respectively, then 𝜏1 = 𝜏2 (they decide
upon the same 𝜌-th client request).
(3) Service. Whenever a non-faulty client 𝑐requests execution
of 𝜏, then all non-faulty replicas will eventually decide on
a client request of 𝑐.
We note that we use SpotLess in a setting of a replicated service that
executes client requests. Hence, instead of the abstract non-triviality
guarantee typically associated with consensus [28], SpotLess guar-
antees service. Adapting SpotLess to settings where other versions
of non-triviality are required is straightforward.
Communication. We assume asynchronous communication: mes-
sages can get lost or arbitrarily delayed. As consensus cannot be
solved in asynchronous environments [21], we adopt the partial syn-
chrony model of Pbft [10]: we always guarantee non-divergence
(referred to as safety), while only guaranteeing termination and
service during periods of reliable communication with a bounded
message delay (referred to as liveness). We assume that periods of
unreliable communication are always followed by sufficiently-long
periods of synchronous communication (during which SpotLess
can complete a limited number of steps to restore liveness).
Authentication. We assume authenticated communication: faulty
replicas are able to impersonate each other, but replicas cannot
impersonate non-faulty replicas. Authenticated communication is
a minimal requirement to deal with malicious behavior [28]. To
enforce authenticated communication, we use two mechanisms:
message authentication codes (MACs) and digital signatures (DSs) [37].
As MACs do not guarantee tamper-free message forwarding, we only
use MACs (which are cheaper than DSs) to authenticate those mes-
sages that are not forwarded. For all other messages, we use DSs.
We write L𝑣M𝑝to denote a value 𝑣signed by participant 𝑝(a client or
a replica). Finally, we write digest(𝑣) to denote the message digest
of a value 𝑣constructed using the same secure cryptographic hash
function as the one used when signing 𝑣[37].
3
SPOTLESS DESIGN PRINCIPLES
SpotLess combines a chained consensus design with a high-performance
concurrent architecture. To maximize resilience in practical net-
work environments in which communication can become unreliable
and messages can get lost, the chained consensus instances of Spot-
Less use Rapid View Synchronization (RVS) to assure that each
instance can always recover and resume consensus.
Our presentation of individual SpotLess instance is broken up
into five parts. Each chained consensus instance of SpotLess oper-
ates in views 𝑣←0, 1, 2, 3, . . . . First, in Section 3.1, we show the two
steps in every view. Second, in Section 3.2, we present the normal-
case replication steps and the three-phase commit algorithm used
by each chained consensus instance. Third, in Section 3.3, we for-
malize the guarantees provided by the normal-case replication steps
and prove the safety of SpotLess. Then, in Section 3.4, we present
the design of RVS. RVS bootstraps the guarantees provided by the
normal-case replication toward providing per-instance consensus.
Next, in Section 3.5, we describe how SpotLess assures per-instance
consensus in an asynchronous environment and formally prove the
liveness of SpotLess.
3.1
Steps in Every View: Propose and Synch
Primitives
View 𝑣is coordinated by the replica P ∈ℜwith id(P) = 𝑣mod n.
We say that P is the primary of view 𝑣and all other replicas act
as backups. In view 𝑣, primary P will be able to propose the next
client request 𝜏upon which the system aims to achieve consensus.
To do so, the system proceeds in two steps i.e. Propose and Synch.
First, the primary inspects the existing chain and decides from
which proposal it extends a new proposal, then the primary picks
a valid client request 𝜏, wraps and broadcasts a new proposal and
broadcasts. Second, the backup replicas decide whether to vote for
the new proposal and broadcast their decisions, where the new
proposal is conditionally prepared by a replica if it receives n −f
concurring votes. Now, we explain the two steps in detail below.
First, primary P inspects the results of the preceding views to
determine the highest extendable proposal P′ past view 𝑣−1, such
that P believes that at least n−f replicas will vote for a new proposal
extending P′. We will explore how P′ is chosen in Section 3.3. Then,
primary P picks a client request 𝜏from some client 𝑐that it has not
yet proposed and proposes 𝜏by broadcasting a Propose message
of the form P := Propose(𝑣,𝜏, cert(P′)) to all backups, in which
cert(P′) is a certificate for the preceding proposal P′ that P chooses.
The certificate is either a list of n −f digital signatures, and we will
explain how certificates are used in Section 3.3. To assure that 𝜏
cannot be forged by the primary, we assume that all client requests
are digitally signed by the client 𝑐. To assure that the authenticity
of P can be established and that P can be forwarded, the primary P
will digitally sign the message P.
Second, the backups establish whether the primary P correctly
proposed a unique proposal to them. Specifically, the backups will
exchange Sync messages between them via which they can deter-
mine whether P is the only proposal that can collect enough en-
dorsements to generate a certificate in the current view (necessary
to provide non-divergence) and to ensure that enough non-faulty
replicas received the same well-formed proposal P to assure that P
can be recovered in any future view (independent of any malicious
behavior). To do so, each backup 𝑅∈ℜperforms the following
steps upon receiving message P := Propose(𝑣,𝜏, cert(P′)) with
digital signature LP′MP:
(S1) 𝑅checks whether LP′MP is a valid digital signature;
(S2) 𝑅checks whether 𝜏is a valid client request;
(S3) 𝑅checks whether view 𝑣is the current view; and
(S4) 𝑅checks whether cert(P′) is valid if 𝑅has not conditionally
prepared P′.
3

---

Primary 𝑅2 determines proposal to extend
based on incoming Sync messages.
𝑅4
𝑅3
𝑅2
𝑅1
Propose
Propose
Propose
Sync
Sync
Sync
view 𝑣−1,
proposal P1,
conditional prepare P1
P′ ←P1
view 𝑣,
proposal P2,
conditional commit P1
P′ ←P2
P𝑙𝑜𝑐𝑘←P1
view 𝑣+ 1,
proposal P3,
commit P1
P′ ←P3
Figure 2: A schematic representation of the normal-case repli-
cation protocol in a chained consensus instance of SpotLess
in three consecutive views 𝑣−1 (primary 𝑅1), 𝑣(primary 𝑅2),
and 𝑣+ 1 (primary 𝑅3). P′ refers to the highest extendable
proposal. We have not visualized those messages one can
eliminate (see Remark 3.1).
Only if the proposal P passes all these checks, the replica 𝑅
will consider P to be well-formed. In this case, backup 𝑅records
P. If P is the first acceptable proposal 𝑅receives in view 𝑣(we
detail the conditions of acceptable proposals in Section 3.3), 𝑅will
broadcast the message ms𝑅:= Sync(𝑣, claim(P), CP), in which
claim(P) := (𝑣, digest(P), LPMP) is a claim that P is the well-formed
proposal that backup 𝑅received in view 𝑣, and CP is a set of pairs in
the form of (view, digest) for the proposals that 𝑅has conditionally
prepared. We will explore the details of CP in Section 3.3.
Otherwise, if backup 𝑅determines a failure in view 𝑣(𝑅did
not receive any valid proposals in view 𝑣while it should have
received one), then 𝑅will end up broadcasting the message ms𝑅:=
Sync(𝑣, claim(∅), CP) to all backup replicas, claiming to have not
received any valid proposals in view 𝑣.
To assure that the authenticity of ms𝑅can be established with-
out verifying digital signatures and that ms𝑅can be forwarded, the
replica 𝑅will include both a message authentication code and the
digital signature Lms𝑅M𝑅. To reduce computational costs, the mes-
sage authentication codes of Sync messages are always verified,
whereas digital signatures are only verified in cases where recovery
is necessary, we refer to Section 3.4 for the exact verification rules.
Remark 3.1. To simplify presentation, all replicas broadcast mes-
sages to all replicas (including themselves). Doing so, we simplify
the claims and proofs made in this paper. Without affecting the
correctness of SpotLess, one can eliminate sending messages to
oneself. In addition, the primary broadcasts the proposal P together
with a matching Sync message.
3.2
Chained Three-Phase Commit Algorithm in
Normal Case
SpotLess adopts a three-phase commit algorithm. Each phase takes
one view, and SpotLess rotates the primary view by view, to elim-
inate complex failure detection and recovery. A successful first
phase of SpotLess establishes a conditional prepare that ensures
non-divergence of proposals within the view; a successful second
phase of SpotLess establishes a conditional commit; and a success-
ful third phase achieves a commit that ensures the preservation of
proposals across views. We explain the conditions to establish these
three proposal states (i.e., conditional prepare, conditional commit,
and commit) later in Definition 3.3. In Figure 2, we have visualized
three consecutive operations of a chained rotational consensus in-
stance in views 𝑣−1, 𝑣, and 𝑣+1 with respect to a proposal P and in
Figure 3, we present the pseudo-code of the normal-case operations
of the chained consensus.
The normal-case replication protocol of SpotLess only estab-
lishes a minimal guarantee on the overall state of the system that
can be proven with a straightforward quorum-based argument [28]:
Theorem 3.2. Consider view 𝑣of the normal-case replication of a
chained consensus instance of SpotLess and consider two replicas
𝑅1, 𝑅2 ∈ℜ. If n > 3f and replica 𝑅𝑖, 𝑖∈{1, 2}, receives a set of
authenticated messages {Sync(𝑣, claim(P𝑖,𝑄)) | 𝑄∈𝔔𝑖} from a set
𝔔𝑖⊆ℜof |𝔔𝑖| = n −f replicas, and all claim(P𝑖,𝑄), 𝑖∈{1, 2},
represent proposal P𝑖, then P1 = P2.
Proof. We prove the theorem by contradiction. Assume P1 ≠P2.
Replica 𝑅𝑖received claims representing P𝑖from the n −f in 𝔔𝑖. As
there are at most f faulty replicas, at-least n −2f replicas in 𝔔𝑖are
non-faulty. Let 𝑆𝑖⊆𝔔𝑖be all non-faulty replicas in 𝔔𝑖.
As the non-faulty replicas in 𝑆1 made claims representing P1, the
non-faulty replicas in 𝑆2 made claims representing P2, P1 ≠P2, and
non-faulty replicas only make a single claim in view 𝑣(see Figure 3),
we must have 𝑆1 ∩𝑆2 = ∅. Hence, we have |𝑆1 ∪𝑆2| ≥2(n −2f). As
all replicas in 𝑆1 ∪𝑆2 are non-faulty, we also have |𝑆1 ∪𝑆2| ≤n −𝑓.
Hence, 2(n −2f) ≤n −f must hold, which implies n ≤3f, a
contradiction. Hence, by contradiction, we conclude P1 = P2.
□
3.3
Rules Guaranteeing Safety
Beside the minimal guarantee in Theorem 3.2, SpotLess ensures
the safety of the system via a set of rules that non-faulty replicas
must follow. In the meantime, the rules play an important role in
helping restore liveness while ensuring safety. Before exploring the
rules, we first introduce the necessary terminology.
Definition 3.3. Let P := Propose(𝑣,𝜏, cert(P′)) be a well-formed
proposal in view 𝑣. We say that P′ is the preceding proposal of P.
For any two proposals P1 and P2, we say that P1 precedes P2 if P1
is the preceding proposal of P2 or if there exists a proposal P∗such
that P1 precedes P∗and P∗is the preceding proposal of P2. Let
precedes(P) be the set of all proposals that precede P. The depth of
proposal P is defined by depth(P) = |precedes(P)|.
We say that a replica records P if it determines that P is well-
formed (Line 17 in Figure 3) and say that it accepts P if it broadcasts
Sync messages with claim(P).
We say that a replica conditionally prepares P if the replica re-
ceived P and, during view 𝑣, the replica receives n −f concur-
ring votes for P, i.e. a set of messages {Sync(𝑣, claim(P𝑄), CP) |
𝑄∈𝔔} with P𝑄= P from a set 𝔔⊆ℜof |𝔔| = n −f replicas.
We say that a replica conditionally commits P if, in a future view
𝑤> 𝑣, the replica conditionally prepares a proposal of the form
P′ := Propose(𝑤,𝜏′, cert(P)) that extends P. We say that a replica
locks P if P is the highest proposal that it conditionally commits,
denoted by Plock. Also, we say that a replica commits P if, in a
future view 𝑢> 𝑣, the replica conditionally prepares a proposal
of the form P′′ := Propose(𝑢,𝜏′′, cert(P′)) that extends P′, with
4

---

1: Let P ∈ℜbe the replica with 𝑣= id(P) mod n (the primary).
2: function Acceptable(P := Propose(𝑣,𝜏, cert(P′))) do
3:
Let Plock := Propose(𝑣lock,𝜏lock, cert(P∗)) be the highest proposal
that this replica conditionally committed.
4:
return 𝑅conditionally prepared proposal P′ and either
𝑣′ < 𝑣lock or Plock ∈({P′} ∪𝑝𝑟𝑒𝑐𝑒𝑑𝑒𝑠(P′)).
5: function HighestExtendable() do
6:
for 𝑣from CurrentView down to 0 do
7:
if P conditionally prepared proposal P′ of view 𝑣then
8:
if P has a valid cert(P′) then
9:
return P′, cert(P′).
10:
else if P receives Sync(𝑣𝑖, claim()𝑖, CP𝑖) from
n −f replicas 𝑅𝑖with claim(P′) ∈CP𝑖then
11:
return P′, claim(P′).
Primary role (running at the primary P of view 𝑣) :
12: P, cc := HighestExtendable().
13: Awaits receipt of a valid client request L𝜏M𝑐.
14: Broadcasts Propose(𝑣,𝜏, cc) to all replicas.
Backup role (running at each replica 𝑅∈ℜ) :
15: event 𝑅receives a well-formed proposal P do
16:
if 𝑅has not sent Sync message in view 𝑣and
Acceptable(P) then
17:
Broadcasts Sync(𝑣, claim(P), CP) to all replicas.
18: event 𝑅determines a failure in view 𝑣do
19:
Broadcasts Sync(𝑣, claim(∅), CP) to all replicas.
20: event 𝑅receives Sync(𝑣, claim(P), CP) from
n −f replicas do
21:
Conditionally prepares P.
22: event 𝑅receives Sync(𝑣′, claim(), CP) messages with
𝑣′ > 𝑣and claim(P) ∈CP from f + 1 replicas do
23:
Conditionally prepares P.
24: event 𝑅receives Sync(𝑣, claim(P), CP) from
f + 1 replicas do
25:
if 𝑅has not sent Sync message in view 𝑣then
26:
Broadcasts Sync(𝑣, claim(P), CP) to all replicas.
27:
if 𝑅does not know P then
28:
Send Ask(𝑣, claim(P)) to the f + 1 replicas.
29: event 𝑅receives Ask(𝑣, claim(P)) from 𝑅′ and
𝑅has recorded P do
30:
Send P to 𝑅′.
Figure 3: The replication protocol in a SpotLess instance.
𝑢= 𝑤+ 1 = 𝑣+ 2. We say that two proposals are conflicting if the
preceding proposals of these two proposals are disjoint.
The proposal states conditionally committed and committed are
analogous to the proposal states prepared and committed in tra-
ditional non-chained protocols such as Pbft [10]. In Figure 2, we
show how a proposal establishes the three states in the normal case.
Using this terminology, we can specify the safety guarantee that
individual SpotLess instances will maintain on the system: no two
conflicting proposals P𝑖and P𝑗can be both committed, each by a
non-faulty replica, which we will prove in Theorem 3.5.
To guarantee safety, central to the design principle are the rules
that non-faulty replicas follow when deciding whether to extend,
accept, or conditionally prepare a proposal.
The primary P can construct a certificate for proposal P after P
recorded P and received n −f Sync messages with valid signatures
for P, i.e.
𝑆= {Sync(𝑣−1, claim(P𝑄), CP) | 𝑄∈𝔔}
with P𝑄= P and a valid signature from a set 𝔔⊆ℜof |𝔔| = n −f
replicas. The set 𝑆will be used to construct the certificate. Even if
𝑅fails to receive sufficient Sync messages to conditionally prepare
P in view 𝑣−1, 𝑅will conditionally prepare P if it receives a valid
certificate cert(P).
Each Sync message includes CP that consists of the views and
digests of the sender’s Plock and all conditionally prepared proposals
with a higher view than the view 𝑣lock of proposal Plock:
CP := {𝑣P, digest(P) | P is conditionally prepared ∧𝑣lock ≤𝑣P}.
𝑅conditionally prepares P if it receives a set 𝑆′of Sync messages
from f + 1 replicas claiming to have conditionally prepared P, which
implies at least one non-faulty replicas have conditionally prepared
P after receiving n −f concurring votes, where
𝑆′ = {Sync(𝑤𝑄′, claim(P𝑄′), CP𝑄′) | 𝑄′ ∈𝔔′}
with 𝑤𝑄′ ≥𝑣, P ∈CP𝑄′, and 𝔔′ ⊆ℜwith |𝔔′| = f + 1.
A non-faulty primary of view 𝑣considers a proposal P′ to be
extendable if either of the following conditions is met:
E1 P has a valid certificate for P′;
E2 P has received a set of Sync messages from n −f replicas
that claim to have conditionally prepared P′, i.e.
{Sync(𝑤𝑄, claim(P𝑄), CP𝑄) | 𝑄∈𝔔}
with 𝑤𝑄<𝑣and P′ ∈CP𝑄′ and 𝔔⊆ℜwith |𝔔| = n −f.
The primary P backtracks to earlier views to find the highest
extendable proposal P′ and then sets the preceding proposal to P′.
If P′ satisfies E1, then P broadcasts P := Propose(𝑣,𝜏, cert(P′)).
Otherwise, P broadcasts P := Propose(𝑣,𝜏, claim(P′)).
When receiving a well-formed new proposal of the form P :=
Propose(𝑣,𝜏, cert(P′)) or Propose(𝑣,𝜏, claim(P′)), a replica 𝑅de-
termines whether to accept P based on the following rules:
A1 Validity Rule: 𝑅has conditionally prepared P′.
A2 Safety Rule: P′ extends 𝑅’s locked proposal Plock, i.e.
Plock ∈({P′} ∪precedes(P′)).
A3 Liveness Rule: P′ has a higher view than Plock.
If A1 holds and either A2 or A3 holds, then𝑅broadcasts Sync(𝑣, claim(P), CP).
Otherwise, 𝑅keeps waiting for a proposal satisfying the acceptance
requirement until its timer expires.
Due to unreliable communication or faulty behavior, non-faulty
replica 𝑅may fail to receive any acceptable proposal from primary
P𝑣but receive a set 𝑀′ consisting of f + 1 Sync messages with the
same claim(P), formally, 𝑅receives
𝑀′ = {Sync(𝑣, claim(P𝑄𝑀), CP𝑄𝑚) | 𝑄𝑀∈𝔔𝔐}
5

---

with P𝑄𝑀= P from a set 𝔔𝔐⊆ℜof |𝔔𝔐| = f + 1 replicas.
For easier restoration of liveness, SpotLess allows 𝑅to broadcast
Sync(𝑣, claim(P), CP) if 𝑅considers P as acceptable.
In such a case, 𝑅is unaware of the full information of P and
needs to catch up. To do so, 𝑅sends a := Ask(𝑣, claim(P)) to the
f + 1 replicas in 𝔔𝔐. After a good replica 𝑅′ ∈𝔔𝔐receives a, the
replica 𝑅′ will forward P to 𝑅if it has recorded a well-formed P. To
reduce the overhead of this mechanism in practical implementa-
tions, replicas can choose to first send Ask messages to replicas
they already trust (e.g., based on previous behavior).
Based on the design principles above, we can prove the safety
property of SpotLess step by step:
Lemma 3.4. If a non-faulty replica 𝑅conditionally prepares P =
Propose(𝑣,𝜏, cert(P′)), then for each proposal P∗∈precedes(P)
that precedes P, at least n −2f ≥f + 1 non-faulty replicas have
conditionally prepared P∗and sent Sync messages with P∗∈CP.
Proof. Assume that 𝑅is the first non-faulty replica that condi-
tionally prepares P. The only way for 𝑅to conditionally prepare P is
to receive n −f Sync messages of the form Sync(𝑣, claim(P), CP),
of which n −2f ≥f + 1 are from non-faulty replicas. Hence, at
least n −2f non-faulty replicas must have conditionally prepared
the preceding proposal P′ of P, as non-faulty replica only accept
P if they conditionally prepared P′. From the definition of CP we
know that these n −2f non-faulty replicas must have send Sync
messages with P′ ∈CP after they conditionally prepare P′. Next,
we can bootstrap this argument to show that the above statement
holds for each proposal P∗∈precedes(P).
□
Using Lemma 3.4, we are able to prove safety:
Theorem 3.5. No two non-faulty replicas can commit conflicting
proposals P𝑖and P𝑗.
Proof. We shall prove this theorem by contradiction. Assume
that both P𝑖and P𝑗are committed by (possibly distinct) non-faulty
replicas and that P𝑖and P𝑗are conflicting. Without loss of gener-
ality, we can assume that proposal P𝑖is from view 𝑣𝑖, proposal P𝑗
is from view 𝑣𝑗, and depth(P𝑗) ≥depth(P𝑖). As P𝑖is committed,
there must exist proposals P𝑖+1 and P𝑖+2 of the form
P𝑖+1 = Propose(𝑣𝑖+ 1,𝜏𝑖+1, cert(P𝑖)); and
P𝑖+2 = Propose(𝑣𝑖+ 2,𝜏𝑖+2, cert(P𝑖+1))
that have been conditionally prepared by non-faulty replicas. Like-
wise, as P𝑗is committed, there must exists proposals P𝑗+1 and P𝑗+2
that have been conditionally prepared by non-faulty replicas.
Since P𝑗conflicts P𝑖and depth(P𝑗) ≥depth(P𝑖), there must
exists a depth𝑑and proposals P𝑑,𝑖∈{P𝑖}∪precedes(P𝑖) and P𝑑,𝑗∈
{P𝑗} ∪precedes(P𝑗) such that precedes(P𝑑,𝑖) = precedes(P𝑑,𝑗)
and P𝑑,𝑖≠P𝑑,𝑗(hence, the first proposals that precede P𝑖and P𝑗,
respectively, that are in conflict). As both P𝑖and P𝑗are committed,
some non-faulty replicas must have conditionally prepared P𝑑,𝑖and
P𝑑,𝑗.
From Lemma 3.4 and the fact that P𝑖+2 and P𝑗+2 are condition-
ally prepared by a non-faulty replica, we conclude that n −2f ≥
f + 1 non-faulty replicas conditionally prepared all proposals in
precedes(P𝑖+2) and in precedes(P𝑗+2). Let P′ ∈precedes(P𝑗+2)
be the proposal with depth(P𝑖+1) = depth(P′). By construction,
P𝑑∈precedes(P′). hence, P′ and P𝑖+1 are in conflict and are both
conditionally prepared by n −2f ≥f + 1 non-faulty replicas. Hence,
by a similar quorum argument as used to prove Theorem 3.2, we
conclude there must be at least one non-faulty replica that condi-
tionally prepared both P′ and P𝑖+1. This non-faulty replica must
have also locked on either P𝑖(when it accepted P𝑖+1) or the proposal
P′′ preceding P′ (when it accepted P′). By construction, P′′ ≠P′.
Hence, one of these accept steps would violate the safety rule A2, a
contradiction.
□
Theorem 3.5 proves SpotLess can ensure safety if we have three-
consecutive-view requirement for committing a proposal. Next, we
illustrate the necessity of the three-consecutive-view requirement
(over a two-consecutive-view requirement) for SpotLess.
Example 3.6. Assume a system with n = 3f + 1 replicas and
that all replicas have conditionally prepared P0. We describe events
that happen in the next six views to illustrate how two conflicting
proposals can get committed if we relax the three-consecutive-view
requirement.
(1) Primary P1 broadcasts proposal P1 extending P0. All repli-
cas accept P1 and then conditionally prepare P1.
(2) Primary P2 broadcasts proposal P2 extending P0. All repli-
cas accept P2 and then conditionally prepare P2.
(3) Faulty primary P3 sends proposal P3 extending P2 to f +
1 non-faulty replicas including 𝑅0 and sends proposal P′
3
extending P2 to the other f non-faulty replicas. All f faulty
replicas only send Sync messages with claim(P3) to 𝑅0,
due to which only 𝑅0 conditionally prepares P3, while other
non-faulty replicas cannot conditionally prepare it.
(4) P4 broadcasts proposal P4 extending P1. All non-faulty
replicas except 𝑅0 conditionally prepare P4.
(5) Faulty primary P5 sends proposal P5 extending P4 to f + 1
non-faulty replicas including 𝑅1 and not including 𝑅0 and
sends proposal P5 extending P4 to the other f non-faulty
replicas. All f faulty replicas only send Sync messages with
claim(P5) to 𝑅1, due to which only 𝑅1 conditionally pre-
pares P5 and commits P1, while others cannot conditionally
prepares P5.
(6) P6 broadcasts proposal P6 extending P3 and all replicas
except 𝑅1 broadcast Sync messages with claim(P6). Then,
all non-faulty replicas except 𝑅1 conditionally prepare P6
and commit P2 that conflicts with P1, which was committed
by 𝑅1.
In this setting, using a two-consecutive-view requirement for
committing, P1 and P2 are conflicting proposals but are both com-
mitted by non-faulty replicas.
3.4
Bootstraping Liveness with Rapid View
Synchronization
Rapid View Synchronization (RVS) bootstraps the guarantees pro-
vided by normal-case replication toward providing consensus. RVS
does so by dealing with asynchronous communication and by
strengthening the guarantees on proposals of preceding views. In
specific, the main services provided by RVS are a best-effort and
quick view synchronization to assure that replicas end up in the
same views whenever communicaiton is sufficiently reliable and
6

---

low-cost state recovery to enable cheap primary rotation to deal with
failures of previous primaries.
To enable Rapid View Synchronization, for each view 𝑣, a replica
must go through three states one by one:
ST1 Recording: waiting for a well-formed P that satisfies A1
and either A2 or A3 until state timer t𝑅expires;
ST2 Syncing: waiting for a set of Sync messages with view 𝑣
from a set 𝔔⊆ℜwith |𝔔| = n −f replicas;
ST3 Certifying: waiting for a set of messages
𝑆= {Sync(𝑣, claim(P𝑄𝐴), CP) | 𝑄𝐴∈𝔔𝔄}
with the same claimed proposal P𝑄𝐴from a set 𝔔𝔄⊆ℜ
of |𝔔𝔄| = n −f replicas until timer state t𝐴expires.
Note that there is no timer for Syncing (ST2) and receiving sufficient
Sync messages is the only way to proceed to Certifying (ST3) of
the same view. Some replicas may fall behind due to unreliable
communication, failing to receive sufficient Sync messages while
other replicas have reached higher views. To quickly synchronize
views, a replica 𝑅in view 𝑣is allowed to proceed to Syncing (ST2)
of view 𝑤directly after receiving a set of messages 𝐷with views
higher than or equal to 𝑤:
𝐷= {Sync(𝑣′, claim(P𝑄𝐷), CP𝑄𝑑) | 𝑄𝐷∈𝔔𝔇}
with 𝑣′ ≥𝑤> 𝑣from a set 𝔔𝔇⊆ℜof |𝔔𝔇| = f + 1 replicas.
Receiving such f+1 messages implies that one non-faulty replica has
moved to view 𝑤after receiving n −f Sync messages of view 𝑤−1,
then 𝑅can skip to view 𝑤directly knowing that at least majority of
non-faulty replicas have observed the higher view 𝑤−1. To catch
up, replica 𝑅broadcasts message 𝑆𝑢= Sync(𝑢, claim(∅), CP, Υ) for
each view 𝑢, 𝑣≤𝑢≤𝑤, in which Υ is a flag that asks replicas that
receive 𝑆𝑢to retransmit the Sync messages to 𝑅they broadcast
in view 𝑢. With such a design, in SpotLess, as long as network
remains synchronous, replicas falling behind are capable of catching
up actively and immediately, while in previous rotational work such
as HotStuff, view synchronization is assumed by relying on the
black-box Pacemaker. In Figure 4, we present the pseudo-code of the
Rapid View Synchronization part of SpotLess. Due to Lemma 3.4,
we have the following:
Lemma 3.7. Assume reliable communication. If replica 𝑅condi-
tionally prepares proposal P by receiving f + 1 Sync messages with
claim(P) ∈CP, then eventually 𝑅will record and conditionally
prepare all proposals in precedes(P).
Proof. Let P′ ∈precedes(P). Due to Lemma 3.4, at least n−2f ≥
f + 1 non-faulty replicas have sent Sync messages that claim P′.
As such, at-least f + 1 non-faulty replicas will reply to the message
𝑆𝑢= Sync(𝑢, claim(∅), CP, Υ) sent by replica 𝑅. Hence, eventually,
𝑅will receive f + 1 corresponding Sync messages with claim(P′),
due to which 𝑅will record and conditionally prepare P′.
□
Using Lemma 3.7, we can prove:
Theorem 3.8. Let Pℎbe the highest proposal that any replica con-
ditionally committed. All non-faulty replicas will eventually record
and conditionally prepare all proposals in precedes(Pℎ), when com-
munication becomes synchronous for sufficiently long.
Backup role (running at each replica 𝑅∈ℜin view 𝑣) :
1: event 𝑅enters view 𝑣do
2:
state := recording (ST1).
3:
Set timer t𝑅.
4: event 𝑅receives an acceptable proposal P or t𝑅expires do
5:
Broadcast Sync(𝑣, claim(P), CP).
6:
state := Syncing (ST2).
7: event 𝑅receives n −f Sync messages of view 𝑣do
8:
state := Certifying (ST3).
9:
Sets timer t𝐴.
10: event 𝑅receives n −f Sync(𝑣, claim(P), CP) of the same P or t𝐴
expires do
11:
Enters view 𝑣+ 1.
12: event 𝑅receives f + 1 Sync messages with views higher than or equal
to 𝑤, 𝑤> 𝑣do
13:
Let 𝑣be the current view of 𝑅.
14:
for each view 𝑢, 𝑣≤𝑢≤𝑤do
15:
Broadcasts Sync(𝑢, claim(∅), CP, Υ).
Figure 4: Rapid View Synchronization in instance.
Proof. Since Pℎis locked by a non-faulty replica, at least n−2f ≥
f +1 non-faulty replicas have conditionally prepared Pℎ(Lemma 3.4).
These n −2f non-faulty replicas either locked Pℎor some pro-
posal with a lower view. Hence, all these replicas will broadcast
Sync messages with claim(Pℎ) ∈CP to convince other replicas
to conditionally prepare Pℎ. Hence, when communication becomes
synchronous, Lemma 3.7 completes this proof.
□
From Theorem 3.8 we know that all non-faulty replicas will
learn the same conditionally committed chain. However, the replicas
may not execute several proposals on the chain until they learn
full information of the proposal via the Ask-recovery mechanism
detailed in Section 3.3.
3.5
Mechanism Guaranteeing Liveness
In some cases, replica 𝑅cannot make any progress unless it receives
some specific messages from other replicas:
(1) 𝑅cannot switch from Syncing (ST2) to Certifying (ST3)
unless it receives n −f Sync messages of its current view.
(2) 𝑅cannot catch up to learn a path from a conditionally pre-
pared proposal to the genesis proposal unless at least f + 1
other replicas reply to its Sync messages with flag Υ, which
requires the receivers to retransmit the Sync messages that
they broadcast before.
(3) 𝑅cannot record a proposal it did not receive from the pri-
mary, unless any replica replies to its Ask message by for-
warding the corresponding Propose message.
However, due to unreliable communication, 𝑅may fail to receive
messages, e.g., replies to Sync messages with flag Υ or replies to
Ask messages. To deal with this case, 𝑅will periodically retransmit
the messages until it receives the necessary replies.
7

---

In an asynchronous environment, one cannot reliably distinguish
between communication failure (e.g., due to long and unpredictable
message delays) and replica failure. Hence, consensus protocols
such as HotStuff [70] and many others [11, 43] simply assume to
be operating after a Global Synchronization Time, at which point all
communication is bound by some message delay such that all repli-
cas can always reliably determine in which view they operate [70].
Such a design is inflexible in the presence of true asynchronous
communication, however.
Instead, SpotLess instances use our Rapid View Synchronization
mechanism to allow replicas to figure out in which view they should
operate. To adapt to fluctuations in message delays, SpotLess will
adjust the timeout interval used by individual replicas to detect
replica failures. As message delays in typical deployments do not
often change drastically, we choose to not use a traditional expo-
nential backoff mechanism [28], but instead to adjust the timeout
interval of replicas 𝑅in a more moderate way. For consecutive
timeouts of the same timer in consecutive views, we only increase
the timeout interval by a constant 𝜀(after each consecutive view).
If a replica receives an expected message for which the timeout
interval was Δ before 0.5Δ, then the replica reduces the timeout by
half. We have the following technical result.
Lemma 3.9. Let 𝑣be the highest view reached by a non-faulty
replica after communication enters a period of synchronous commu-
nication. Non-faulty primary P𝑤with 𝑣+2 ≤𝑤is capable of finding
a proposal P′ such that all non-faulty replicas will accept a proposal
P extending from P′, P := Propose(𝑤,𝜏, claim(P′)).
Proof. Let P′ be the highest proposal locked by any non-faulty
replicas after view𝑤−1 (in the worst case, P′ is the genesis proposal).
As P′ was locked by a non-faulty replica, at least n −2f ≥f + 1
non-faulty replicas have conditionally prepared P′ before view 𝑤−1.
For any replica 𝑅among these n −2f replicas, either 𝑅locked on
P′ or P′ is from a newer view than the locked proposal of 𝑅.
Hence, in view 𝑤−1, the Sync messages of the n−2f ≥f +1 non-
faulty replicas would include P′ in CP. As such, all non-faulty repli-
cas would conditionally prepare P′ and inform other replicas, and
primary P𝑤would learn that at least n−2f non-faulty replicas have
conditionally prepared P′ before entering view 𝑤. As such, primary
P𝑤can propose a new proposal P := Propose(𝑤,𝜏, claim(P∗)),
with P∗= P′ or with P∗being some proposal with a higher view
than P′ (if primary P𝑤knows such an extendable higher proposal).
All non-faulty replicas will consider P as acceptable since their
locked proposal is either P′ or a proposal from an lower view.
□
As a direct consequence, we have the following corollary.
Corollary 3.10. Let 𝑣be the highest view reached by a non-
faulty replica after communication enters a period of synchronous
communication. If all non-faulty replicas have internal timers that are
higher than the current maximum message delay, then the proposals
of any non-faulty primary P𝑤during view 𝑤, 𝑤≥𝑣+ 2, will be
conditionally prepared after view 𝑤by all non-faulty replicas.
Proof. We denote to be 𝑡the time that P𝑤enters Certifying
(3) of view 𝑤. From Lemma 3.9 we know that all non-faulty repli-
cas will accept. By 𝑡, at least f + 1 non-faulty replicas have sent
Sync(𝑤, claim(𝑚), CP). By 𝑡+ 𝛿, non-faulty replicas falling behind
will have received at least f +1 such Sync messages, entered view 𝑤
and voted for 𝑚. By 𝑡+ 2𝛿, all non-faulty replicas will have received
at least n −f such Sync messages and conditionally prepare 𝑚.
□
Corollary 3.10 is at the basis of proving termination: consensus
decisions are eventually made when communication is synchro-
nous.
Theorem 3.11. All non-faulty replicas will eventually commit
new proposals after communication enters a sufficiently-long period
of synchronous communication.
Proof. First, we note that all non-faulty replicas will eventu-
ally satisfy the internal timer requirements, as they will increase
their internal timer until they can successfully participate in the
replication protocol. Hence, by Corollary 3.10 a non-faulty primary
P𝑤of view 𝑤will eventually be able to propose a message P that
will be conditionally prepared. As there are n > 3f replicas, after
view 𝑤, there will eventually be a sequence of three consecutive
non-faulty primaries. These primaries will be able to make propos-
als satisfying the conditions of Definition 3.3 to assure a proposal
will get committed.
□
4
CONCURRENT CONSENSUS
The main benefit of chained consensus, as used by SpotLess and
HotStuff [70], is that a single proposal represents the entire chain
of preceding proposals. This greatly reduces the message complex-
ity of view-changes when compared to traditional non-chained
consensus protocols such as Pbft [10].
Unfortunately, chained consensus requires that consecutive con-
sensus decisions are made one-at-a-time, thereby preventing the us-
age of out-of-order processing to maximize throughput. This makes
HotStuff and individual chained consensus instances of SpotLess
significantly slower than traditional consensus protocols such as
Pbft in practical deployments: primaries in Pbft can use out-of-
order processing to propose client requests for future views while
waiting on the current consensus round to finish, thereby maxi-
mizing the utilization of the network bandwidth available at the
primary independent of any message delays (which dominate the
time it takes to finish a single consensus round).
As an alternative to out-of-order processing, SpotLess will adopt
concurrent consensus [29, 62]. By running multiple concurrent in-
stances, SpotLess is able to effectively utilize all network band-
width and computational resources available: when one SpotLess
instance is waiting for a proposal to be processed (e.g., waiting for
Sync messages), other SpotLess instances use the available net-
work bandwidth and computational resources to propose additional
requests.
4.1
Concurrent Instances in SpotLess
In SpotLess, the system runs m, 1 ≤m ≤n, SpotLess instances
concurrently. Instances do not interfere with each other. Each in-
stance independently deals with any malicious behavior. To enforce
that each instance is coordinated by a distinct primary, the primary
of I𝑖in view 𝑣is predetermined: id(P𝑖,𝑣) = (𝑖+ 𝑣) mod n. Figure 5
shows how SpotLess assigns and rotates primary in each SpotLess
instance. As all instances rotate over all primaries, all instances
are equally affected by malicious behavior. When given the choice,
8

---

𝑅0
𝑅1
𝑅2
𝑅3
View 0
View 1
View 2
P0,0
P1,0
P2,0
P3,0
P3,1
P0,1
P1,1
P2,1
P2,2
P3,2
P0,2
P1,2
Figure 5: Primary rotation in SpotLess with four replicas and
four instances. The circles in the form of P𝑖,𝑣on the arrow of
𝑅𝑟represent that 𝑅𝑟is the primary of instance I𝑖in view 𝑣,
where 𝑟= (𝑖+ 𝑣) mod n.
non-faulty replicas will prioritize instances that are in older views
over other instances. Due to primary rotation and this instance
prioritization, the view of all instances will remain roughly-in-sync.
Each SpotLess instance determines a local order of proposals.
All committed proposals on the chains are totally ordered and then
executed. We order the committed proposals among different in-
stances by their view and instance identifier. We order all proposals
from low view to high view and from instance I0 to instance Im−1.
Figure 6 shows the total ordering in SpotLess. Finally, each replica
executes the committed proposals in order and informs the clients
of the outcome of their requested transactions.
As individual SpotLess instances provide consensus and combin-
ing consensus decisions of instances is deterministic, we conclude
Theorem 4.1. All instances of SpotLess will eventually commit
new proposals after communication enters a sufficiently-long period
of synchronous communication.
4.2
Benefits of Concurrent Processing
Theoretically, if we run m, 1 ≤m ≤n instances concurrently, Spot-
Less could achieve m times the throughput of a single instance. As
the number of replicas n and instances m scales, the throughput of
SpotLess will keep growing until the throughput reaches resource
bottlenecks (e.g., limited computational power or network band-
width). Scaling beyond these resource bottlenecks, the throughput
of SpotLess decreases as the system scales further due to the added
communication cost to reach consensus among more replicas.
Next, we shall theoretically model the benefits of concurrent
consensus in SpotLess. Assume the message delay is Δ and the
network bandwidth is 𝐵, and that proposal includes a batch of 𝛽in-
dividual transactions. Hence, the best-case throughput of individual
SpotLess instances with n replicas is
TSpotLess1 =
𝛽
𝑡primary + 2Δ;
𝑡primary =
𝑆primary
𝐵
In the above, 𝑆primary is the size of all n −f Sync messages the
primary receives and of all n −f Propose messages the primary
sends and 𝑡primary is the time the primary is busy sending and
receiving.
If network bandwidth is not the bottleneck, then the maximum
performance of n SpotLess instances is n𝑇SpotLess1. If we run n
P0,0
P1,0
P2,0
P3,0
P0,1
P1,1
P2,1
P3,1
P0,2
P1,2
P2,2
P3,2
Figure 6: Total ordering of the twelve proposals of Figure 5
made among four concurrent instances in three consecutive
views.
SpotLess instances concurrently, one for each replica, the commu-
nication complexity per instance is 𝑂(n2) in each round. Thus, as
the system reaches resource bottlenecks, adding more instances
will cause no gains in throughput. If we assume that network band-
width is the bottleneck, the best-case throughput of SpotLess with
n instances and n replicas is upper-bounded by
TSpotLessbw =
n𝐵𝛽
𝑆primary + (n −1)𝑆backup
In the above, 𝑆backup is the size of all messages a replica sends
and receives as part of the backup role in one view, and 𝑆primary +
(n −1)𝑆backup is the sum of all bandwidth usage by a single replica
during n instances of a single view. Due to the chained design of
SpotLess, SpotLess instances end up sending fewer messages per
consensus decision than Pbft. Consequently, when scaling up to
many replicas (and many instances), the best-case throughput of
SpotLess will be higher than concurrent consensus based on Pbft
(e.g., RCC [29]).
5
CLIENTS AND TRANSACTION EXECUTION
Lastly, we discuss how SpotLess provides service to clients. Observe
that to maximize throughput, it is beneficial to assure that no two
instances propose the same transactions. In addition, it is important
to balance all requests over all instances. Furthermore, we must
also consider malicious primary behavior aimed at refusing service
to some non-faulty clients.
Unlike systems such as RCC [29], which initially assigns every
client to a single primary (that coordinates a single instance), Spot-
Less assigns every client request to a single instance based on its
digest: instance I𝑖, 1 ≤𝑖≤m, can only propose transactions with
digest 𝑑such that (𝑖−1) = 𝑑mod m. Hence, multiple requests
by the same client will be handled by different instances. Since
we adopt a cryptographically strong hash algorithm to compute
digests, this allocation of transactions to instances also ensures load
balance among instances.
When a non-faulty replica commits a transaction, it will execute
that transaction in an order consistent with the total ordering of
all transactions (across all instances). After executing a transaction,
the replica informs the client of the result via an Inform message. A
client 𝑐randomly sends a transaction 𝜏to a replica 𝑅𝑗, starts a timer
𝑡𝐶, and awaits for f + 1 identical Inform responses. If 𝑐fails to get
these f+1 responses before 𝑡𝐶expires, it sends the transaction to the
next replica 𝑅𝑗+1 and doubles the timeout interval. The client keeps
doing so until it receive f +1 identical Inform responses confirming
that the transaction has been executed. Due to primary rotation,
every replica will eventually be the primary of an instance that
9

---

can propose 𝜏, including a non-faulty replicas that will eventually
propose 𝜏.
Note that transaction execution in view 𝑣requires that all in-
stances finished view 𝑣(hence, we know the total ordering of the
transactions successfully proposed in view 𝑣and that need to be
executed). In cases where system load is low, an instance primary
P can end up not receiving any client transactions while other
primaries are already proposing transactions for their instances. To
prevent that executing of the proposals of other instances has to
wait until P is able to propose a transaction, primary P can propose
a no-op transaction if no other transactions are available. As we
already proved termination (Theorem 4.1) and non-divergence (The-
orem 3.5) and the mechanisms outlined above guarantee service,
we finally conclude
Theorem 5.1. SpotLess provides consensus.
6
EVALUATION
Previously, we detailed and analyzed the design of SpotLess, show-
ing several theoretical advantages when compared to its peers.
Next, to show the practical advantages of SpotLess, we will ex-
perimentally evaluate its performance, both in the normal case
and during Byzantine failures. In our evaluation, we compare the
performance of SpotLess in Apache ResilientDB (Incubating),
our high-performance open-source blockchain database, with the
well-known primary-backup consensus protocols Pbft [10], Hot-
Stuff [70], Narwhal-HS [13], and our Pbft-based concurrent
consensus paradigm RCC [29]. We focus on answering the follow-
ing questions:
Q1 Scalability: does SpotLess deliver on the promises to pro-
vide better scalability than other consensus protocols?
Q2 Latency: does SpotLess provide low client latency while
providing high throughput? What factors affect latency and
throughput?
Q3 What is the impact of batching client transactions on the
performance of SpotLess?
Q4 How does SpotLess perform in presence of Byzantine fail-
ures?
Q5 How does concurrent consensus improve performance?
To study the practical performance of SpotLess and other con-
sensus protocols, we implemented SpotLess and other protocols
in Apache ResilientDB. To generate experimental workloads, we
used the Yahoo Cloud Serving Benchmark [12] provided by the Block-
bench macro benchmarks [17]. In the generated workload, each
client transaction queries a YCSB table with half a million active
records and 90% of the transactions write and modify records. Be-
fore the experiments, each replica is initialized with an identical
copy of the YCSB table. We perform all experiments on Oracle
Cloud, using up to 128 machines for replicas and 32 machines for
clients. Each replica and client is deployed on a e3-machine with a
16-core AMD EPYC 7742 processor, running at 3.4 GHz, and with
32 GB memory.
6.1
The Apache ResilientDB Blockchain
Database
The architecture of Apache ResilientDB is heavily multi-threaded
and pipelined and is optimized for maximizing throughput [25–
27, 32, 53]. To further maximize throughput and minimize the
overhead of any consensus protocol, Apache ResilientDB has
built-in support for batching client transactions. We typically group
100 txn/batch. In this case, the size of a proposal is 5400 B and of
a client reply (for 100 transactions) is 1748 B. The other messages
exchanged between replicas during the replication algorithm have
a size of 432 B.
To maximize performance of Pbft-like protocols, Apache Re-
silientDB supports out-of-order processing of transactions (see Sec-
tion 4) in which primaries can propose future transactions before
current transactions are executed. The chained designs of SpotLess
and HotStuff cannot utilize out-of-order processing, however.
In Apache ResilientDB, each replica maintains an immutable
blockchain ledger that holds an ordered copy of all executed trans-
actions. The ledger not only stores all transactions, but also strong
cryptographic proofs of their acceptance by a consensus protocol.
This ledger can be used to provide strong data provenance.
In our experiments, replicas not only perform consensus but
also communicate with clients and execute transactions. In this
practical setting, performance is not fully determined by the cost
of consensus, but also by the cost of communicating with clients, of
sequential execution of all committed transactions, of cryptography,
and of other steps involved in processing messages and transactions.
The sequential execution bottleneck of Apache ResilientDB in our
deployments, the maximum speed by which Apache ResilientDB
can execute transactions without performing any other tasks, is
340 ktxn/sec.
To reduce the overhead of sending individual messages, Apache
ResilientDB uses message buffering: Apache ResilientDB collects
messages intended for specific receiver in a buffer and sends all
messages at-once when the buffer reaches a threshold value. For
each consensus protocol we study, the threshold value used has
been configured to maximize throughput.
In addition, to better utilize the computing and network re-
sources, Apache ResilientDB optimizes SpotLess in the following
two ways. First, primaries broadcast the actual content of client
requests in advance, and during the proposal step, they only operate
on the digests of the requests. Second, in the geo-scale experiments
that will be discussed later, primaries can broadcast a new proposal
optimistically in a fast path before receiving 2f+1 votes for the pro-
posal in the previous view. If any Byzantine behavior is detected,
replicas switch back to the slow original path the next time they
become the rotated primary.
6.2
The Consensus Protocols
We evaluate the performance of SpotLess by comparing it with a
representative selection of four efficient practical consensus proto-
cols implemented in Apache ResilientDB:
Pbft [10]. We use heavily optimized out-of-order implementa-
tion that uses message authentication codes.
RCC [29]. RCC turns Pbft into a concurrent consensus protocol.
10

---

HotStuff [70]. HotStuff uses threshold signatures to minimize
communication. Since existing threshold signature algorithms are
expensive and quickly become the bottleneck, we use a list of n −f
secp256k1 digital signatures to represent a threshold signature,
which improves our throughput. In our experiments, we implement
the pipelined Chained HotStuff.
Narwhal-HS [13]. Narwhal-HS separates the replication of
transactions and ordering transactions, enabling concurrent trans-
action dissemination. We simulate the communication complexity
and computational overhead of Narwhal-HS by running Hot-
Stuff and requring replicas to broadcast messages consisting of a
client batch and 2f + 1 digital signatures.
We run the concurrent protocols RCC and SpotLess with n
instances unless stated otherwise.
6.3
Experiments
To be able to answer Questions Q1–Q5, we perform fifteen exper-
iments in which we measure the performance of SpotLess and
other consensus protocols. We measure throughput as the number
of transactions that are executed per second and latency as the
average duration between when the client sends a transaction and
when the client receives f + 1 corresponding responses. Unless
stated otherwise, all replicas are non-faulty. We run each experi-
ment for 130 s (except the seventh experiment): the first 10 s are
warm-up, and measurement results are collected over the next 120 s.
We average our results over three runs.
In the scalability experiment, we measure throughput as a func-
tion of the number of replicas. We vary the number of replicas
between n = 4 and n = 128 and we use a batch size of 100 txn/batch.
The results can be found in Figure 7(a).
In the batching experiment, we measure the throughput as a
function of the number of replicas. We use n = 128 replicas and
we vary batch size between 10 txn/batch and 400 txn/batch. The
results can be found in Figure 7(b).
In the throughput-latency experiment, we measure the latency
as a function of the throughput. We use n = 128 replicas, set the
batch size to 100 txn/batch, and we vary the speed by which each
primary receives client requests to affect throughput and latency.
The results can be found in Figure 7(c).
In the transaction-size experiment, we measure the throughput
of SpotLess as a function of the individual YCSB transaction size.
We use n = 128 replicas and vary the transaction size from 48 B to
1600 B. The results can be found in Figure 7(d).
In the all-throughput-failures experiment, we measure the through-
put as a function of the number of malicious replicas that do not
participate in consensus. We use n = 128 replicas, and we vary the
number of faulty replicas between 0 and 10 or between 0 and f. We
make the faulty replicas non-responsive at the same time point and
measure throughput afterward for 120 s. We set the timeout length
in SpotLess, HotStuff, and Narwhal-HS based on the calculated
average view duration and set the timeout length in RCC and Pbft
based on the average client latency. The results can be found in
Figure 7(e) and (f).
In the SpotLess-throughput-failures experiment, we further mea-
sure the throughput of SpotLess as a function of the number of
SpotLess
HotStuff
RCC
Pbft
Narwhal-HS
4
16
32
64
96
128
0.0
1.0
2.0
3.0
·105
Number of replicas (n)
Throughput (txn/s)
(a) Scalability (no failures)
10
50
100
200
400
0.0
1.0
2.0
3.0
·105
Batch size
Throughput (txn/s)
(b) Batching (no failures)
0
0.5
1
1.5
2
2.5
·105
0.0
2.0
4.0
6.0
8.0
Throughput (txn/s)
Latency (s)
(c) Throughput-Latency
48 200
400
600
800
1,600
0.0
0.5
1.0
1.5
2.0
·105
Transaction size (B)
Throughput (txn/s)
(d) Larger Transaction Size
0
1
2
3
4
6
8
10
0.0
0.5
1.0
1.5
2.0
·105
Number of malicious replicas
Throughput (txn/s)
(e) Impact of Failures
0
0.2
0.4
0.6
0.8
1
0.0
0.5
1.0
1.5
2.0
·105
Ratio of malicious replicas (out-of-f)
Throughput (txn/s)
(f) Impact of Failures
Figure 7: Performance of SpotLess and other protocols. The
number of replicas is 128 except in (a).
SpotLess32
SpotLess64
SpotLess96
SpotLess128
0
1
2
3
4
6
8
10
0.0
0.5
1.0
1.5
2.0
2.5
·105
Number of malicious replicas
Throughput (txn/s)
0
0.2
0.4
0.6
0.8
1
0.0
0.5
1.0
1.5
2.0
2.5
·105
Ratio of malicious replicas (out-of-f)
Throughput (txn/s)
Figure 8: Performance of SpotLess during failures as a func-
tion of the number of replicas and faulty replicas.
replicas and the number of malicious replicas that do not par-
ticipate in consensus. We vary the number of replicas between
n ∈{32, 64, 96, 128} and we perform two measurements for each n.
We vary the number of faulty replicas between 0 and 10 or between
0 and f. Based on the calculated average view duration, we have
set the timeout length in SpotLess appropriately. The results can
be found in Figure 8.
In the throughput-latency-failure experiment, we measure the
latency of SpotLess and RCC as a function of throughput in the
presence of malicious replicas. We use n = 128 replicas and set the
number of faulty, non-responsive, replicas to be 1 or f. We vary the
number of client batches that each primary receives in the same
way as described in the throughput-latency experiment. We only
11

---

SpotLess
RCC
0
0.5
1
1.5
2
·105
0.0
10.0
20.0
30.0
Throughput (txn/s)
Latency (s)
(1 failure)
0
0.5
1
1.5
2
·105
0.0
10.0
20.0
30.0
Throughput (txn/s)
Latency (s)
(f failures)
Figure 9: System throughput-latency of SpotLess and RCC in
the presence of failures (128 replicas).
SpotLess
SpotLess1
SpotLess𝑓
RCC
RCC1
RCC𝑓
12 25
50
100
200
0.0
0.5
1.0
1.5
2.0
·105
Client Batches per Primary receives
Throughput (txn/s)
12 25
50
100
200
0.0
5.0
10.0
15.0
20.0
25.0
Client Batches per Primary receives
Latency (s)
Figure 10: Throughput and latency of SpotLess and RCC as
a function of the amount of parallel transaction processing
(128 replicas).
count the latency of proposals that are sent to non-faulty replicas.
The results can be found in Figure 9.
In the parallel transaction processing experiment, we measure the
performance of SpotLess and RCC as a function of the amount of
concurrent (both protocols) and out-of-order (RCC) processing. To
do so, we measure the throughput and latency of SpotLess and
RCC as a function of the number of client batches that each primary
receives. We use n = 128 replicas and we vary the number of client
batches between 12 and 200. The results can be found in Figure 10.
In the throughput-Byzantine experiment, we measure the through-
put of SpotLess in the presence of attacks as a function of the
number of Byzantine replicas. We consider four types of attacks:
A1 faulty replicas are non-responsive;
A2 faulty replicas act malicious when they are the primary by
keeping f non-faulty replicas in the dark (by not sending
proposals to them);
A3 faulty replicas act malicious by sending conflicting concur-
ring votes in an attempt to cause divergence: they send one
message to f non-faulty replicas and a different one to the
other non-faulty replicas; and
A4 faulty replicas act malicious by refusing to participate in
the consensus of proposals from non-faulty primaries, this
in an attempt to subvert non-faulty primaries (and make
them look faulty).
For comparison, we include RCC. The victims of these attacks are
the replicas that are kept in the dark (A2), receive a proposal that
is received by not more than f non-faulty replicas (A3), or are not
responded to (A4). The throughput of RCC is not influenced by A2,
SpotLess
SPL𝐴1
SPL𝐴2
SPL𝐴3
SPL𝐴4
RCC
RCC𝐴1
0
1
2
3
4
6
8
10
0.0
0.5
1.0
1.5
2.0
·105
Number of malicious replicas
Throughput (txn/s)
0
0.2
0.4
0.6
0.8
1
0.0
0.5
1.0
1.5
2.0
·105
Ratio of Byzantine failures (out-of-f)
Throughput (txn/s)
Figure 11: Performance of SpotLess and RCC during Byzan-
tine failures (128 replicas, four attack scenarios for SpotLess).
Note: SPL is the abbreviation for SpotLess here.
A3, and A4 as long as the number of victims is not greater than f.
Hence, we only include the normal-case (failure-free) throughput of
RCC and the throughput during A1 for comparison. We use n = 128
replicas and we vary the number of malicious replicas between 0
and 10 or between 0 and f. The results can be found in Figure 11.
In the real-time-throughput-failure experiment, we measure the
real-time throughput of SpotLess and RCC after making malicious
replicas non-responsive as a function of time. We use n = 128
replicas, and we set the number of faulty replicas to 1 or f. We run
the experiments for 140 s, record throughput every 5 seconds, and
have the failures happen at the 10th second. The results can be
found in Figure 12.
In the concurrent-consensus experiment, we measure the through-
put of SpotLess and RCC as a function of the number of replicas
and concurrent instances. We use n ∈{32, 128} replicas and we
vary the number of concurrent instances between 1 and n. The
results can be found in Figure 13.
In the computing-power-impact experiment, we measure the
throughput of SpotLess and other protocols as a function of the
number of CPU cores in each replica. We use n = 128 replicas and
we vary the number of CPU cores between 4 and 32. The results
can be found in Figure 14(a).
In the network-bandwidth-impact experiment, we measure the
throughput of SpotLess and other protocols as a function of the
bandwidth. We use n = 128 replicas and vary the bandwidth be-
tween 500 Mbit/s and 4000 Mbit/s using FireQOS [66], a program
that helps configure traffic shaping on Linux. The results can be
found in Figure 14(b).
In the global-regions experiment, we measure the throughput of
SpotLess and other protocols as a function of the number of regions.
We use n = 128 replicas and vary the number of regions between
1 and 4. For each run, the 128 replicas are uniformly distributed
in the regions Oregon, North Virginia, London, and Zurich. The
results can be found in Figure 14(c) and (d).
In the non-concurrent-failure experiment, we measure the through-
put of single-instance SpotLess and HotStuff as a function of the
number of faulty replicas. We use n = 128 replicas and vary the
number of malicious replicas between 0 and f. The results can be
found in Figure 15.
12

---

6.4
Experiment Analysis
The experimental results presented in the previous sections allows
us to answer the research questions Q1–Q5. First, we observe that
increasing the batch size, increases the performance of all consen-
sus protocols, thereby answering Q3 as expected. Since the gains
brought by increased the batch size are small after 100 txn/batch,
we used 100 txn/batch in all other experiments.
SpotLess outperforms all other protocols in failure-free condi-
tions (Q1, Q2). As Figure 1 shows, the amortized message complexity
per decision is n2 for SpotLess, while it is 2n2 for RCC. Hence, as
SpotLess has fewer messages to process, SpotLess can even out-
perform RCC by up to 23%. Due to the message buffer mechanism,
SpotLess and RCC require sufficient batches of client requests to fill
the system pipeline. Otherwise, the two protocols may get stalled
since no messages are sent and processed. When the pipeline is full,
the latency of both SpotLess and RCC in Apache ResilientDB is
dominated by the maximum throughput, as Figure 7(c), 9, and 10
show. The higher throughput is, the shorter a client request waits
to be proposed and then the lower latency is. Thus, even though
SpotLess needs more communication phases than RCC to commit
a proposal, SpotLess has a lower latency by up to 32% than RCC.
Also, SpotLess outperforms Narwhal-HS because, for each com-
mitted block, SpotLess verifies 𝑂(𝑛) MACs while Narwhal-HS
verifies 𝑂(𝑛) digital signatures.
By introducing concurrent processing, SpotLess is able to out-
perform HotStuff, the other chained consensus protocol, by up
to 3803%. In this situation, the performance of HotStuff is bot-
tlenecked by the message delay due to the lack of out-of-order
processing. From Figure 7(d) we conclude that RCC and SpotLess
are able to sustain high throughput even if we increase the transac-
tion size to 1600 B per YCSB transaction, whereas the throughput of
Pbft and HotStuff decreases greatly. This is easily explained: the
concurrent design of RCC and SpotLess load-balances the primary
task to all replicas, whereas in Pbft and HotStuff the performance
is bottlenecked by the bandwidth available to the single proposing
primary.
As Figure 8 shows, non-responsive faulty replicas negatively
affect the performance of SpotLess in all cases (Q4): indeed, non-
responsive faulty replicas do not perform their primary role, due
to which the non-faulty replicas can only wait until their timers
expire to switch out these faulty primaries. The larger the number
of replicas, the smaller the relative influence of faulty replicas on
performance. For example, when there are f faulty replicas, the
throughput of SpotLess128 decreases by 41% while that of Spot-
Less32 decreases by 54%. Due to concurrent consensus, a larger num-
ber of replicas implies more SpotLess instances with non-faulty
primaries that utilize CPU resources while waiting for the instances
with non-responsive primaries.
From Figure 7, 9, and 10, we also know that SpotLess shows
great resilience to non-responsive faulty replicas when compared
with other protocols (Q4). In a deployment with 128 replicas, the
first 120 s after failures happen, SpotLess shows a gain in through-
put over other protocols and a lower latency (Q1, Q2) despite the
number of faulty replicas.
Thanks to the Ask-recovery mechanism and Rapid View Synchro-
nization, described in Section 3, SpotLess shows strong resilience
0
20
40
60
80
100 120 140
0
50K
100K
150K
200K
250K
Time(s)
Throughput(txn/s)
SpotLess with 1 failure
0
20
40
60
80
100 120 140
0
50K
100K
150K
200K
250K
Time(s)
RCC with 1 failure
0
20
40
60
80
100 120 140
0
50K
100K
150K
200K
250K
Time(s)
Throughput(txn/s)
SpotLess with f failures
0
20
40
60
80
100 120 140
0
50K
100K
150K
200K
250K
Time(s)
RCC with f failures
Figure 12: Throughput timeline of SpotLess and RCC after
injecting failures.
SpotLess
RCC
1
8
16
32
64
0.0
1.0
2.0
3.0 ·105
Number of concurrent instances
Throughput (txn/s)
(64 replicas)
1
16
32
64
128
0.0
1.0
2.0
3.0 ·105
Number of concurrent instances
Throughput (txn/s)
(128 replicas)
Figure 13: Performance of SpotLess and RCC as a function of
the number of concurrent instances.
to Byzantine attacks, as we can observe from the results in Fig-
ure 11. No matter the type of attack, the victims can quickly detect
the failure and catch up by receiving f + 1 Sync messages from
other non-faulty replicas and sending Ask messages. When facing
non-responsive faulty replicas, the two mechanisms are useless,
however, as timing out instances is the only way to advance view
in this case.
The results of Figure 12 show obvious fluctuations in the real-
time throughput of RCC after injecting failures. This is due to
the usage of an exponential back-off penalty algorithm to ignore
instances with faulty primaries. Eventually, the throughput of RCC
gradually recovers to the original level and then keeps stable. This
is the best case for RCC, however, as all f failures happen at the
same time. If the failures appear one by one, RCC will suffer from
these low-throughput fluctuations (the yellow columns in Figure 12)
during each failure. In contrast, SpotLess presents a more stable
throughput timeline after failures happen (Q4).
Figure 13 shows that SpotLess benefits more from concurrent
consensus than RCC, especially when there are many instances.
(Q5). When there are 32 or fewer instances, RCC outperforms Spot-
Less because RCC enables out-of-order processing in individual
instances, which is not supported by the chained design of Spot-
Less instances. As the number of concurrent instances increases,
the throughput of RCC reaches a message processing bottleneck
when there are 16 instances and then remains stable, whereas the
13

---

SpotLess
HotStuff
RCC
Pbft
Narwhal-HS
4
8
16
32
0.0
0.5
1.0
1.5
2.0
2.5
·105
Number of CPU Cores
Throughput (txn/s)
(a) Impact of Computing Power
500
1,000
2,000
3,000
4,000
0.0
0.5
1.0
1.5
2.0
·105
Network Bandwidth (Mbit/s)
Throughput (txn/s)
(b) Impact of Bandwidth
1
2
3
4
0.0
0.5
1.0
1.5
·105
Number of regions
Throughput (txn/s)
(c) Impact of Latency (100 txn/batch)
1
2
3
4
0.0
1.0
2.0
·105
Number of regions
Throughput (txn/s)
(d) Impact of Latency (400 txn/batch)
Figure 14: Impact of computing and network resources on
the performance with 128 replicas.
throughput of SpotLess can increase further due to the lower
message complexity and reaches its peak value when there are n
instances, higher than RCC by up to 23%.
The performance of consensus protocols is significantly influ-
enced by computing and network resources. First, Figure 14(a)
shows that the performance of all protocols decreases when com-
pute power is restrictd (fewer CPU cores in each replica). Second,
Figure 14(b) shows that decreasing the network bandwidth nega-
tively impacts the performance of all protocols in which network
is a bottleneck. We note that Narwhal-HS is barely affected, how-
ever, as it is limited by computing resources as it has to verify n −f
digital signatures per block. Similarly, Figure 14(c) and (d), show
that increasing the number of regions, which not only decreases net-
work bandwidth but also increases latency, negatively impacts the
performance of all protocols. We notice that in all cases, SpotLess
maintains a higher performance than RCC, even thoug SpotLess is
affected by decreasing bandwidth. Finally, the comparison between
Figure 14(c) and (d), shows that that increasing the batch size can
partially mitigates bandwidth bottlenecks.
Figure 15 shows that the presence of Byzantine failures has simi-
lar negative effects on the performance of single-instance SpotLess
and HotStuff. In all cases, the throughput of single-instance Spot-
Less is higher than that of HotStuff due to the lower computation
costs of verifying signatures in SpotLess (as compared to dealing
with the threshold signatures used in HotStuff). Hence, compared
with HotStuff, replicas in SpotLess are able to respond more
quickly, lowering the per-round latency and increasing throughput.
Based on our findings, we conclude that SpotLess makes full
use of concurrent consensus (Q5), provides higher throughput and
better scalability than any other consensus protocol (Q1), and does
so with low latency (Q2). Moreover, client batching does benefit the
performance of SpotLess (Q3). Finally, we conclude that SpotLess
can efficiently deal with failures (Q4) thanks to concurrent consensus,
the Ask-recovery mechanism, and Rapid View Synchronization.
A1
A2
A3
A4
0
0.2
0.4
0.6
0.8
1
0.0
2.0
4.0
6.0
·1,000.0
Ratio of Byzantine failures (out-of-f)
Throughput (txn/s)
SpotLess
0
0.2
0.4
0.6
0.8
1
0.0
2.0
4.0
6.0
·1,000.0
Ratio of Byzantine failures (out-of-f)
Throughput (txn/s)
HotStuff
Figure 15: Performance of single-instance SpotLess and Hot-
Stuff with failures.
7
RELATED WORK
There is abundant literature on consensus and primary-backup
consensus in specific (e.g., [3–5, 7, 9, 16, 23, 39, 45, 46, 55, 56, 60, 62,
73]), to reduce the communication cost and improve performance
and resilience of the consensus systems [8, 11, 38, 40, 43, 47, 58, 59,
61, 72]. In previous sections, we already discussed how SpotLess
relates to Pbft [10], RCC [29], HotStuff [71], and Narwhal-
HS [13]. Next, we shall focus on other works that deal with either
improving throughput and scalability or with simplifying consensus,
the two strengths of SpotLess.
Trusted Hardware There is a large body of work on improving
and simplifying primary-backup consensus by employing trusted
hardware. A representative example is MinBFT [67], which uses
trusted hardware to prevent malicious primaries from proposing
conflicting client requests in a round. Via the usage of trusted hard-
ware, one can reduce the impact of Byzantine behavior and simplify
both the normal case and the recovery process, e.g., MinBFT elimi-
nates one round of communication from Pbft and can operate in
deployments in which n > 2f (instead of the typical n > 3f) holds.
Protocols that require trusted hardware place significant restric-
tions on the environment in which they can run, due to which their
practical usage is limited. As such, these protocols are not a replace-
ment for a general-purpose consensus such as SpotLess. [31]
Leader-Less Consensus. Leader-less protocols such as HoneyBad-
ger [48] and Dumbo [24] eliminate the limitations of Pbft and
other primary-backup consensus protocols via a fully decentralized
and fully asynchronous design. In these protocols, all replicas have
the same responsibilities, due to which the cost of consensus is
equally spread-out over all replicas. These leader-less protocols
claim to improve resilience over Pbft in asynchronous environ-
ments. Due to the high complexity of fully asynchronous consensus,
their practical performance is limited, however.
Sharding. Recently, there have been several approaches toward
scalability of RDMSs by sharding them, e.g., [2, 14, 19, 33, 34]. Al-
though sharding has the potential to drastically improve scalability
for certain workloads, it does so at a high cost for complex work-
loads. Furthermore, sharding impacts resilience, as sharded systems
put requirements on the number of failures in each individual shard
(instead of putting those requirements on all replicas in the system).
Finally, sharding is orthogonal to consensus, as proposed sharded
systems all require a high-performance consensus protocol to run
individual shards. For this task, SpotLess is an excellent candidate.
14

---

Reducing Primary Costs. There are several approaches toward
reducing the cost for the primary to coordinate consensus in Pbft-
style primary-backup consensus protocols, thereby reducing the
limitations of primary-backup designs. Examples include (1) proto-
cols such as FastBFT [44] and the geo-scale aware GeoBFT [30] that
use a hierarchical communication architecture to offload the cost for
a primary to propose client requests to other replicas; (2) protocols
such as Narwhal-HS [13] that use a gossip-based communica-
tion protocol to replicate client requests, thereby sharply reducing
the cost for primaries to propose these requests; and (3) protocols
such as Algorand [22] that restrict consensus to a small subset
of the replicas in the system (whom then enforce their decisions
upon all other replicas), thereby reducing the cost of the primary
to coordinate consensus. Unfortunately, each of these protocols
introduces its own added complexity or environmental restrictions
to the design of consensus, e.g., FastBFT requires trusted hard-
ware, the design of GeoBFT impacts resilience in a similar way
as sharded designs do, and Algorand relies on complex crypto-
graphic primitives due to which it can only guarantee to work with
high probability.
8
CONCLUSION
In this paper, we proposed SpotLess, a high-performance robust
consensus protocol. SpotLess combines the high throughput of
concurrent consensus architectures with the reduced complexity pro-
vided by chained consensus. Furthermore, SpotLess improves on
the resilience of existing chained consensus designs by introduc-
ing the Rapid View Synchronization protocol, which guarantees a
continuous low-cost recovery path that is robust during unreliable
communication and does not require costly threshold signatures.
We have put the design of SpotLess to the test by implementing
it in Apache ResilientDB, our high-performance resilient fabric,
and we compared SpotLess with existing consensus protocols.
Our experiment results show that the performance of SpotLess
is excellent: SpotLess greatly outperforms traditional primary-
backup consensus protocols such as Pbft by up to 430%, Narwhal-
HS by up to 137%, and HotStuff by up to 3803%. SpotLess is
even able to outperform RCC, a state-of-the-art high-throughput
concurrent consensus protocol, by up to 23% in optimal conditions,
while providing lower latency in all cases. Furthermore, SpotLess
can maintain a stable latency and consistently high throughput,
even during failures.
ACKNOWLEDGMENTS
This work was supported in part by (1) Oracle Cloud Credits and
related resources provided by the Oracle for Research program and
(2) the NSF STTR under Award Number 2112345 provided to Moka
Blox LLC.
REFERENCES
[1] Ittai Abraham, Natacha Crooks, Neil Giridharan, Heidi Howard, and Florian
Suri-Payer. 2022. It’s not easy to relax: liveness in chained BFT protocols. https:
//arxiv.org/abs/2205.11652
[2] Mohammad Javad Amiri, Divyakant Agrawal, and Amr El Abbadi. 2019. SharPer:
Sharding Permissioned Blockchains Over Network Clusters. https://arxiv.org/
abs/1910.00765v1
[3] Karolos Antoniadis, Antoine Desjardins, Vincent Gramoli, Rachid Guerraoui,
and Igor Zablotchi. 2021. Leaderless Consensus. In 41st IEEE International Con-
ference on Distributed Computing Systems. IEEE, 392–402.
https://doi.org/10.
1109/ICDCS51616.2021.00045
[4] Claudio A Ardagna, Marco Anisetti, Barbara Carminati, Ernesto Damiani, Elena
Ferrari, and Christian Rondanini. 2020. A Blockchain-based Trustworthy Certi-
fication Process for Composite Services. In 2020 IEEE International Conference
on Services Computing (SCC). IEEE, 422–429. https://doi.org/10.1109/SCC49832.
2020.00062
[5] Pierre-Louis Aublin, Rachid Guerraoui, Nikola Knezevic, Vivien Quéma, and
Marko Vukolic. 2015. The Next 700 BFT Protocols. ACM Trans. Comput. Syst. 32,
4 (2015), 12:1–12:45. https://doi.org/10.1145/2658994
[6] Yuliang Baek, Joonsang Zheng. 2003. Simple and efficient threshold cryptosystem
from the Gap Diffie-Hellman group. In GLOBECOM ’03. IEEE Global Telecommu-
nications Conference, Vol. 3. IEEE, 1491–1495. https://doi.org/10.1109/GLOCOM.
2003.1258486
[7] Christian Berger and Hans P. Reiser. 2018. Scaling Byzantine Consensus: A
Broad Analysis. In Proceedings of the 2nd Workshop on Scalable and Resilient
Infrastructures for Distributed Ledgers. ACM, 13–18.
https://doi.org/10.1145/
3284764.3284767
[8] Erik-Oliver Blass and Florian Kerschbaum. 2020. BOREALIS: Building Block
for Sealed Bid Auctions on Blockchains. In ASIA CCS ’20: The 15th ACM Asia
Conference on Computer and Communications Security. ACM, 558–571. https:
//doi.org/10.1145/3320269.3384752
[9] Christian Cachin and Marko Vukolic. 2017. Blockchain Consensus Protocols in
the Wild (Keynote Talk). In 31st International Symposium on Distributed Com-
puting, Vol. 91. Schloss Dagstuhl–Leibniz-Zentrum fuer Informatik, 1:1–1:16.
https://doi.org/10.4230/LIPIcs.DISC.2017.1
[10] Miguel Castro and Barbara Liskov. 2002. Practical Byzantine Fault Tolerance
and Proactive Recovery. ACM Trans. Comput. Syst. 20, 4 (2002), 398–461. https:
//doi.org/10.1145/571637.571640
[11] Pierre Civit, Muhammad Ayaz Dzulfikar, Seth Gilbert, Vincent Gramoli, Rachid
Guerraoui, Jovan Komatovic, and Manuel Vidigueira. 2022. Byzantine Consensus
Is Θ(n2): The Dolev-Reischuk Bound Is Tight Even in Partial Synchrony!. In
36th International Symposium on Distributed Computing (DISC 2022) (Leibniz
International Proceedings in Informatics (LIPIcs)), Vol. 246. Schloss Dagstuhl, 14:1–
14:21. https://doi.org/10.4230/LIPIcs.DISC.2022.14
[12] Brian F. Cooper, Adam Silberstein, Erwin Tam, Raghu Ramakrishnan, and Russell
Sears. 2010. Benchmarking Cloud Serving Systems with YCSB. In Proceedings of
the 1st ACM Symposium on Cloud Computing. ACM, 143–154. https://doi.org/10.
1145/1807128.1807152
[13] George Danezis, Lefteris Kokoris-Kogias, Alberto Sonnino, and Alexander
Spiegelman. 2022. Narwhal and Tusk: a DAG-based mempool and efficient BFT
consensus. In Proceedings of the Seventeenth European Conference on Computer
Systems. ACM, 34–50. https://doi.org/10.1145/3492321.3519594
[14] Hung Dang, Tien Tuan Anh Dinh, Dumitrel Loghin, Ee-Chien Chang, Qian Lin,
and Beng Chin Ooi. 2019. Towards Scaling Blockchain Systems via Sharding. In
Proceedings of the 2019 International Conference on Management of Data. ACM,
123–140. https://doi.org/10.1145/3299869.3319889
[15] Alex de Vries. 2018. Bitcoin’s Growing Energy Problem. Joule 2, 5 (2018), 801–805.
https://doi.org/10.1016/j.joule.2018.04.016
[16] Tien Tuan Anh Dinh, Rui Liu, Meihui Zhang, Gang Chen, Beng Chin Ooi, and
Ji Wang. 2018. Untangling Blockchain: A Data Processing View of Blockchain
Systems. IEEE Trans. Knowl. Data Eng. 30, 7 (2018), 1366–1385. https://doi.org/
10.1109/TKDE.2017.2781227
[17] Tien Tuan Anh Dinh, Ji Wang, Gang Chen, Rui Liu, Beng Chin Ooi, and Kian-Lee
Tan. 2017. BLOCKBENCH: A Framework for Analyzing Private Blockchains. In
Proceedings of the 2017 ACM International Conference on Management of Data.
ACM, 1085–1100. https://doi.org/10.1145/3035918.3064033
[18] Cynthia Dwork, Nancy Lynch, and Larry Stockmeyer. 1988. Consensus in the
presence of partial synchrony. J. ACM 35, 2 (1988), 288–323. https://doi.org/10.
1145/42282.42283
[19] Muhammad El-Hindi, Carsten Binnig, Arvind Arasu, Donald Kossmann, and
Ravi Ramamurthy. 2019. BlockchainDB: A Shared Database on Blockchains. Proc.
VLDB Endow. 12, 11 (2019), 1597–1609. https://doi.org/10.14778/3342263.3342636
[20] Ittay Eyal and Emin Gün Sirer. 2018. Majority is not enough: Bitcoin mining is
vulnerable. Commun. ACM 61, 7 (2018), 95–102. https://doi.org/10.1145/3212998
[21] Michael J. Fischer, Nancy A. Lynch, and Michael S. Paterson. 1985. Impossibility
of Distributed Consensus with One Faulty Process. J. ACM 32, 2 (1985), 374–382.
https://doi.org/10.1145/3149.214121
[22] Yossi Gilad, Rotem Hemo, Silvio Micali, Georgios Vlachos, and Nickolai Zel-
dovich. 2017. Algorand: Scaling Byzantine Agreements for Cryptocurrencies. In
Proceedings of the 26th Symposium on Operating Systems Principles (SOSP). ACM,
51–68. https://doi.org/10.1145/3132747.3132757
[23] Guy Golan Gueta, Ittai Abraham, Shelly Grossman, Dahlia Malkhi, Benny Pinkas,
Michael Reiter, Dragos-Adrian Seredinschi, Orr Tamir, and Alin Tomescu. 2019.
SBFT: A Scalable and Decentralized Trust Infrastructure. In 49th Annual IEEE/IFIP
15

---

International Conference on Dependable Systems and Networks (DSN). IEEE, 568–
580. https://doi.org/10.1109/DSN.2019.00063
[24] Bingyong Guo, Zhenliang Lu, Qiang Tang, Jing Xu, and Zhenfeng Zhang. 2020.
Dumbo: Faster Asynchronous BFT Protocols. In Proceedings of the 2020 ACM
SIGSAC Conference on Computer and Communications Security. ACM, 803–818.
https://doi.org/10.1145/3372297.3417262
[25] Suyash Gupta, Jelle Hellings, Sajjad Rahnama, and Mohammad Sadoghi. 2019. An
In-Depth Look of BFT Consensus in Blockchain: Challenges and Opportunities. In
Proceedings of the 20th International Middleware Conference Tutorials, Middleware.
ACM, 6–10. https://doi.org/10.1145/3366625.3369437
[26] Suyash Gupta, Jelle Hellings, Sajjad Rahnama, and Mohammad Sadoghi. 2020.
Blockchain consensus unraveled: virtues and limitations. In Proceedings of the
14th ACM International Conference on Distributed and Event-based Systems. ACM,
218–221. https://doi.org/10.1145/3401025.3404099
[27] Suyash Gupta, Jelle Hellings, Sajjad Rahnama, and Mohammad Sadoghi. 2020.
Building High Throughput Permissioned Blockchain Fabrics: Challenges and
Opportunities. Proc. VLDB Endow. 13, 12 (2020), 3441–3444. https://doi.org/10.
14778/3415478.3415565
[28] Suyash Gupta, Jelle Hellings, and Mohammad Sadoghi. 2021. Fault-Tolerant
Distributed Transactions on Blockchain. Morgan & Claypool. https://doi.org/10.
2200/S01068ED1V01Y202012DTM065
[29] Suyash Gupta, Jelle Hellings, and Mohammad Sadoghi. 2021. RCC: Resilient
Concurrent Consensus for High-Throughput Secure Transaction Processing. In
37th IEEE International Conference on Data Engineering, ICDE 2021, Chania, Greece,
April 19-22, 2021. IEEE, 1392–1403. https://doi.org/10.1109/ICDE51399.2021.00124
[30] Suyash Gupta, Sajjad Rahnama, Jelle Hellings, and Mohammad Sadoghi. 2020.
ResilientDB: Global Scale Resilient Blockchain Fabric. Proc. VLDB Endow. 13, 6
(2020), 868–883. https://doi.org/10.14778/3380750.3380757
[31] Suyash Gupta, Sajjad Rahnama, Shubham Pandey, Natacha Crooks, and Mo-
hammad Sadoghi. 2022. Dissecting BFT Consensus: In Trusted Components we
Trust! https://arxiv.org/abs/2202.01354
[32] Suyash Gupta, Sajjad Rahnama, and Mohammad Sadoghi. 2020. Permissioned
Blockchain Through the Looking Glass: Architectural and Implementation
Lessons Learned. In 40th International Conference on Distributed Computing
Systems. IEEE, 754–764. https://doi.org/10.1109/ICDCS47774.2020.00012
[33] Jelle Hellings and Mohammad Sadoghi. 2021. ByShard: Sharding in a Byzantine
Environment. Proceedings of the VLDB Endowment 14, 11 (2021), 2230–2243.
https://doi.org/10.14778/3476249.3476275
[34] Jelle Hellings and Mohammad Sadoghi. 2023. ByShard: sharding in a Byzantine
environment. The VLDB Journal 32, 6 (2023), 1343–1367. https://doi.org/10.1007/
s00778-023-00794-0
[35] Maurice Herlihy. 2019. Blockchains from a Distributed Computing Perspective.
Commun. ACM 62, 2 (2019), 78–85. https://doi.org/10.1145/3209623
[36] Maged N. Kamel Boulos, James T. Wilson, and Kevin A. Clauson. 2018. Geospa-
tial blockchain: promises, challenges, and scenarios in health and healthcare.
International Journal of Health Geographics 17, 1 (2018), 1211–1220.
https:
//doi.org/10.1186/s12942-018-0144-x
[37] Jonathan Katz and Yehuda Lindell. 2014. Introduction to Modern Cryptography
(2nd ed.). Chapman and Hall/CRC.
[38] Eleftherios Kokoris-Kogias, Philipp Jovanovic, Nicolas Gailly, Ismail Khoffi, Linus
Gasser, and Bryan Ford. 2016. Enhancing Bitcoin Security and Performance with
Strong Consistency via Collective Signing. In Proceedings of the 25th USENIX
Conference on Security Symposium. USENIX, 279–296.
[39] Ramakrishna Kotla, Lorenzo Alvisi, Mike Dahlin, Allen Clement, and Edmund
Wong. 2009. Zyzzyva: Speculative Byzantine Fault Tolerance. ACM Trans.
Comput. Syst. 27, 4 (2009), 7:1–7:39. https://doi.org/10.1145/1658357.1658358
[40] Lucas Kuhring, Zsolt István, Alessandro Sorniotti, and Marko Vukolić. 2021.
StreamChain: Building a Low-Latency Permissioned Blockchain For Enterprise
Use-Cases. In 2021 IEEE International Conference on Blockchain (Blockchain). IEEE,
130–139.
[41] Leslie Lamport, Robert Shostak, and Marshall Pease. 2019. The Byzantine generals
problem. In Concurrency: the works of leslie lamport. 203–226.
[42] Laphou Lao, Zecheng Li, Songlin Hou, Bin Xiao, Songtao Guo, and Yuanyuan
Yang. 2020. A Survey of IoT Applications in Blockchain Systems: Architecture,
Consensus, and Traffic Modeling. ACM Comput. Surv. 53, 1, Article 18 (2020),
32 pages. https://doi.org/10.1145/3372136
[43] Andrew Lewis-Pye. 2022. Quadratic worst-case message complexity for State
Machine Replication in the partial synchrony model. https://arxiv.org/abs/2201.
01107
[44] Jian Liu, Wenting Li, Ghassan O. Karame, and N. Asokan. 2019. Scalable Byzantine
Consensus via Hardware-Assisted Secret Sharing. IEEE Trans. Comput. 68, 1
(2019), 139–151. https://doi.org/10.1109/TC.2018.2860009
[45] Shengyun Liu, Paolo Viotti, Christian Cachin, Vivien Quéma, and Marko Vukolic.
2016. XFT: Practical Fault Tolerance beyond Crashes. In Proceedings of the 12th
USENIX Conference on Operating Systems Design and Implementation. USENIX
Association, USA, 485–500.
[46] Dumitrel Loghin, Tien Tuan Anh Dinh, Aung Maw, Chen Gang, Yong Meng Teo,
and Beng Chin Ooi. 2022. Blockchain Goes Green? Part II: Characterizing the
Performance and Cost of Blockchains on the Cloud and at the Edge.
https:
//arxiv.org/abs/2205.06941
[47] Mads Frederik Madsen, Mikkel Gaub, Malthe Ettrup Kirkbro, and Søren Debois.
2019. Transforming Byzantine Faults using a Trusted Execution Environment.
In 15th European Dependable Computing Conference. IEEE, 63–70. https://doi.
org/10.1109/EDCC.2019.00022
[48] Andrew Miller, Yu Xia, Kyle Croman, Elaine Shi, and Dawn Song. 2016. The
Honey Badger of BFT Protocols. In Proceedings of the 2016 ACM SIGSAC Confer-
ence on Computer and Communications Security. ACM, 31–42. https://doi.org/10.
1145/2976749.2978399
[49] Satoshi Nakamoto. 2009. Bitcoin: A Peer-to-Peer Electronic Cash System. https:
//bitcoin.org/bitcoin.pdf
[50] Arvind Narayanan and Jeremy Clark. 2017. Bitcoin’s Academic Pedigree. Com-
mun. ACM 60, 12 (2017), 36–45. https://doi.org/10.1145/3132259
[51] Faisal Nawab and Mohammad Sadoghi. 2023. .
[52] Marshall Pease, Robert Shostak, and Leslie Lamport. 1980. Reaching agreement
in the presence of faults. Journal of the ACM (JACM) 27, 2 (1980), 228–234.
[53] Sajjad Rahnama, Suyash Gupta, Thamir M. Qadah, Jelle Hellings, and Mohammad
Sadoghi. 2020. Scalable, Resilient, and Configurable Permissioned Blockchain
Fabric. Proc. VLDB Endow. 13, 12 (2020), 2893–2896. https://doi.org/10.14778/
3415478.3415502
[54] Abderahman Rejeb, John G. Keogh, Suhaiza Zailani, Horst Treiblmaier, and
Karim Rejeb. 2020. Blockchain Technology in the Food Industry: A Review of
Potentials, Challenges and Future Research Directions. Logistics 4, 4 (2020), 26.
https://doi.org/10.3390/logistics4040027
[55] Christian Rondanini, Barbara Carminati, Federico Daidone, and Elena Ferrari.
2020. Blockchain-based controlled information sharing in inter-organizational
workflows. In 2020 IEEE International Conference on Services Computing (SCC).
IEEE, 378–385. https://doi.org/10.1109/SCC49832.2020.00056
[56] Pingcheng Ruan, Tien Tuan Anh Dinh, Qian Lin, Meihui Zhang, Gang Chen,
and Beng Chin Ooi. 2021. LineageChain: a fine-grained, secure and efficient
data provenance system for blockchains. VLDB J. 30, 1 (2021), 3–24.
https:
//doi.org/10.1007/s00778-020-00646-1
[57] Pingcheng Ruan, Tien Tuan Anh Dinh, Dumitrel Loghin, Meihui Zhang, and
Gang Chen. 2022. Blockchains: Decentralized and Verifiable Data Systems. Springer.
https://doi.org/10.1007/978-3-031-13979-6
[58] Vasily A. Sartakov, Stefan Brenner, Sonia Ben Mokhtar, Sara Bouchenak, Gaël
Thomas, and Rüdiger Kapitza. 2018. EActors: Fast and flexible trusted computing
using SGX. In Proceedings of the 19th International Middleware Conference, Paulo
Ferreira and Liuba Shrira (Eds.). ACM, 187–200. https://doi.org/10.1145/3274808.
3274823
[59] Youren Shen, Hongliang Tian, Yu Chen, Kang Chen, Runji Wang, Yi Xu, Yubin
Xia, and Shoumeng Yan. 2020. Occlum: Secure and Efficient Multitasking Inside
a Single Enclave of Intel SGX. In Proceedings of the Twenty-Fifth International
Conference on Architectural Support for Programming Languages and Operating
Systems (ASPLOS ’20). ACM, 955–970. https://doi.org/10.1145/3373376.3378469
[60] Peiyao Sheng, Gerui Wang, Kartik Nayak, Sreeram Kannan, and Pramod
Viswanath. 2021. BFT Protocol Forensics. In CCS ’21: 2021 ACM SIGSAC Con-
ference on Computer and Communications Security. ACM, 1722–1743.
https:
//doi.org/10.1145/3460120.3484566
[61] Man-Kit Sit, Manuel Bravo, and Zsolt István. 2021. An experimental frame-
work for improving the performance of BFT consensus for future permissioned
blockchains. In DEBS ’21: The 15th ACM International Conference on Distributed
and Event-based Systems, Virtual Event, Italy, June 28 - July 2, 2021. ACM, 55–65.
https://doi.org/10.1145/3465480.3466922
[62] Chrysoula Stathakopoulou, Tudor David, and Marko Vukolic. 2019. Mir-BFT:
High-Throughput BFT for Blockchains. http://arxiv.org/abs/1906.05552
[63] Chrysoula Stathakopoulou, Matej Pavlovic, and Marko Vukolić. 2022. State
machine replication scalability made simple. In Proceedings of the Seventeenth
European Conference on Computer Systems. ACM, 17–33. https://doi.org/10.1145/
3492321.3519579
[64] Gerard Tel. 2001. Introduction to Distributed Algorithms (2nd ed.). Cambridge
University Press.
[65] Horst Treiblmaier and Roman Beck (Eds.). 2019. Business Transformation through
Blockchain. Springer. https://doi.org/10.1007/978-3-319-98911-2
[66] Costa Tsaousis and Phil Whineray. 2023. FireHOL–Linux firewalling and traffic
shaping for humans. https://firehol.org/
[67] Giuliana Santos Veronese, Miguel Correia, Alysson Neves Bessani, Lau Cheuk
Lung, and Paulo Verissimo. 2013. Efficient Byzantine Fault-Tolerance. IEEE Trans.
Comput. 62, 1 (2013), 16–30. https://doi.org/10.1109/TC.2011.221
[68] Harald Vranken. 2017. Sustainability of bitcoin and blockchains. Current Opinion
in Environmental Sustainability 28 (2017), 1–9. https://doi.org/10.1016/j.cosust.
2017.04.011
[69] Gavin Wood. 2016. Ethereum: a secure decentralised generalised transaction
ledger. https://gavwood.com/paper.pdf EIP-150 revision.
[70] Maofan Yin, Dahlia Malkhi, Michael K. Reiter, Guy Golan Gueta, and Ittai Abra-
ham. 2019. HotStuff: BFT Consensus with Linearity and Responsiveness. In
Proceedings of the ACM Symposium on Principles of Distributed Computing. ACM,
16

---

347–356. https://doi.org/10.1145/3293611.3331591
[71] Maofan Yin, Dahlia Malkhi, Michael K. Reiter, Guy Golan Gueta, and Ittai Abra-
ham. 2019. HotStuff: BFT Consensus with Linearity and Responsiveness. In
Proceedings of the 2019 ACM Symposium on Principles of Distributed Computing.
ACM, 347–356. https://doi.org/10.1145/3293611.3331591
[72] Rui Yuan, Yubin Xia, Haibo Chen, Binyu Zang, and Jan Xie. 2018. ShadowEth:
Private Smart Contract on Public Blockchain. J. Comput. Sci. Technol. 33, 3 (2018),
542–556. https://doi.org/10.1007/s11390-018-1839-y
[73] Ce Zhang, Cheng Xu, Jianliang Xu, Yuzhe Tang, and Byron Choi. 2019. GEM2-
Tree: A Gas-Efficient Structure for Authenticated Range Queries in Blockchain.
In 2019 IEEE 35th International Conference on Data Engineering (ICDE). IEEE,
842–853. https://doi.org/10.1109/ICDE.2019.00080
[74] Gengrui Zhang, Fei Pan, Sofia Tijanic, and Hans-Arno Jacobsen. 2023. Pres-
tigeBFT: Revolutionizing View Changes in BFT Consensus Algorithms with
Reputation Mechanisms. arXiv:2307.08154 [cs.DC]
17

---

