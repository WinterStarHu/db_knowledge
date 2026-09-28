# Reliable Transactions in Serverless-Edge Architecture

> 来源: https://arxiv.org/pdf/2201.00982

Reliable Transactions in Serverless-Edge
Architecture
Suyash Gupta∗,
Sajjad Rahnama,
Erik Linsenmayer,
Faisal Nawab†,
Mohammad Sadoghi
Exploratory Systems Lab
University of California, Davis
†University of California, Irvine
∗University of California, Berkeley
Abstract—Modern edge applications demand novel solutions
where edge applications do not have to rely on a single cloud
provider (which cannot be in the vicinity of every edge device) or
dedicated edge servers (which cannot scale as clouds) for process-
ing compute-intensive tasks. A recent computing philosophy, Sky
computing, proposes giving each user ability to select between
available cloud providers.
In this paper, we present our serverless-edge co-design, which
extends the Sky computing vision. In our serverless-edge co-
design, we expect edge devices to collaborate and spawn required
number of serverless functions. This raises several key challenges:
(1) how will this collaboration take place, (2) what if some
edge devices are compromised, and (3) what if a selected
cloud provider is malicious. Hence, we design SERVERLESSBFT,
the ﬁrst protocol to guarantee Byzantine fault-tolerant (BFT)
transactional ﬂow between edge devices and serverless functions.
We present an exhaustive list of attacks and their solutions on
our serverless-edge co-design. Further, we extensively benchmark
our architecture on a variety of parameters.
Index Terms—edge computing, serverless, IoT
I. INTRODUCTION
This paper introduces SERVERLESSBFT, the ﬁrst protocol
to guarantee Byzantine fault-tolerant (BFT) transactional ﬂow
between edge devices and serverless functions. The design of
SERVERLESSBFT is motivated from the recent introduction
of Sky Computing, which envisages utility computing in a
multi-cloud environment [1], [2]. Sky computing propounds
the design of an inter-cloud broker that takes as input a client
program and output speciﬁcations and selects the best cloud
providers to execute the client program. Such a broker is
extremely desirable for the edge and Internet of Things (IoT)
applications, which run on edge devices, such as smart devices,
sensors, UAVs, and phones, that have limited compute power
and memory [3].
On the one hand, existing edge applications expect response
latency in the order of tens of milliseconds [4], [5], [6]. On
the other hand, they are forced to delegate compute-intensive
tasks to a speciﬁc third-party cloud provider such as AWS and
Azure [7], [8]. A recent way to solve this dilemma is to install
dedicated edge-servers that are closer to the edge devices [9],
[10]. These edge servers are installed and maintained by the
enterprise behind the application [11], [12]. If any hardware
crashes, then the enterprise may need to purchase new hard-
ware. Moreover, with ever-growing application needs, these
servers are impossible to seamless scale as third-party clouds.
SERVERLESSBFT realizes the Sky computing vision in
edge computing by giving the edge applications ﬂexibility to
select any of the available cloud providers. As a result, the
edge application can select different cloud providers based on
the location of its users.1 However, moving data across cloud
providers degrades system performance and is expensive. So,
we take a step further and permit edge applications to make
use of serverless technology, which (i) decouples storage,
compute, and network, (ii) supports pay-as-you-go model
where the enterprise pays only for the resources used, and
(iii) supports auto-scaling policies [14], [15]. We refer to
this interaction as serverless-edge co-design as it promotes
light-weight tasks at the edge while compute-intensive tasks
are done at the serverless cloud. Our serverless-edge co-
design targets low latency by allowing edge devices to spawn
serverless functions at the nearest cloud.
Our serverless-edge co-design also presents several research
challenges, which we enlist next.
(1) Task distribution between edge and serverless. Our
SERVERLESSBFT protocol requires an edge application to
push its compute-intensive task to the cloud by spawning
serverless functions (for simplicity, we refer to these functions
as executors). To do so, we need to design a compatibility
layer. We build this compatibility layer on top of edge devices
and refer to it as a shim. At shim, the edge devices collab-
orate and spawn serverless executors for executing compute-
intensive client requests.
(2) Lack of Trust at Shim. As edge devices may belong
to different parties, which may not trust each other, it is hard
for these devices to collaborate. Hence, our SERVERLESSBFT
protocol runs a traditional BFT protocol to allow these edge
devices reach a consensus [16], [17]. This consensus decides
which edge device will spawn the desired number of executors
and the order in which client requests are processed. For
consensus, we opt for BFT protocols as they are resilient
to malicious attacks. Further, depending on the location and
nature of edge devices, SERVERLESSBFT permits various
shim designs: a single shim of all devices running PBFT [16]
1At present, switching cloud providers is common for most applications
due to geo-political reasons and government regulations [13].
arXiv:2201.00982v2  [cs.DB]  27 Aug 2022

---

consensus, multiple dependent shims of devices spread glob-
ally, running GeoBFT [17], and multiple independent shims
running AHL [18], Sharper [19], or RingBFT [20]. For sim-
plicity, in this paper, we assume a single shim of 3f+1 devices
where up to f devices can act malicious.
(3) Lack of Trust at Serverless cloud. Depending on the
application requirement, shim may spawn serverless executors
at one or more available cloud providers in the vicinity. Hence,
there is again a lack of trust: some cloud providers may
have mal-intent or may have poor QoS (crashed or failed
executors) [21], [22]. As a result, SERVERLESSBFT requires
the shim to spawn 2f + 1 executors and permits up to f of
them to fail. This extra spawning is not new; Yahoo’s Hadoop
also executes the same code multiple times to reduce latency
due to stragglers [23].
(4) Private Data access and retrieval. Recent reports illus-
trate that around 90% of the industries are not only sticking
with their existing on-premise servers, but also scaling them
up [24], [25]. For at least 65% of these industries, the key
reason for maintaing on-premise servers is to protect their
consumer data from data-breaches and attacks [24]. In our
serverless-edge co-design, we adhere to this design choice
and assume that all the client data is stored in an on-premise
storage at the enterprise. As a result, the enterprise can control
access to the data. Hence, edge devices or executors lack rights
to update the storage, but may request read access to the same.
For updates to the storage, we write a lightweight wrapper
(veriﬁer) around the storage that collects execution results,
updates the data-store, and forwards the results to the clients.
Furthermore, we observe several other new challenges with
our architecture: (i) Byzantine shim devices may spawn less
executors, for which we need to hold them accountable. (ii)
During execution, executors may need to read data from the
storage. (iii) If the client transactions are conﬂicting and their
read-write sets are unknown until execution, we may have to
abort such transactions.
We envision our serverless-edge architecture to seamlessly
integrate with existing edge applications.
To realize this
goal experimentally, we design a shim of nodes and require
them to spawn AWS Lambda functions as executors. On each
shim node, we install RESILIENTDB’s light-weight and multi-
threaded consensus framework
[17], [26], [27], [28], [29].
We evaluate our SERVERLESSBFT protocol on eight distinct
parameters. Our results illustrate that SERVERLESSBFT can
facilitate shims of up to 128 devices in 11 global regions.
Further, in our experiments, we are easily able to spawn 21
executors in parallel (could not scale further due to limits
by cloud provider), and the peak throughput achieved by our
SERVERLESSBFT protocol is 240 k txns/s while the minimum
latency incurred is 30 ms.
In this paper, we make the following contributions:
• We design of a novel serverless-edge co-design that meets
the vision of Sky computing and helps design low latency
reliable edge applications where edge devices can select cloud
providers based on desired output speciﬁcations.
>
>
>
>
g
,
22,
2
ü 2
Client
Shim
Executors
Veriﬁer
Storage
(1) Client txn
(2) Consensus
between
edge nodes
(3) Spawn executors
(5) Send Results
(4) Fetch data
>
>
> >
g
,
2
2 2
(1) Client txn
(2) Collect and Process
Client
Edge Servers
(b)
(a)
Fig. 1. Illustration of (a) Serverless-Edge architecture employing the SERVER-
LESSBFT protocol and (b) architecture prevalent in existing edge applications.
• In our serverless-edge architecture, we neither trust the
edge devices nor the serverless executors. Hence, we introduce
a novel protocol SERVERLESSBFT that manages the ﬂow of
a client request in our serverless-edge architecture and shields
the system against arbitrary results and malicious attacks.
• We enlist possible attacks in our serverless-edge architec-
ture and present solutions to recover the system.
• Our SERVERLESSBFT protocol presents algorithms to
handle conﬂicting transactions with or without the knowledge
of read-write available to shim nodes prior to execution.
II. MOTIVATION AND USE CASE
The motivations behind our serverless-edge co-design are
the emerging use cases of edge-computing, such as AR/VR
video-streaming and Unmanned Aerial Vehicles (UAVs).
These applications require massive data-processing as they
need to run ML models to train data on-ﬂight or provide the
user useful insights. The key challenge these applications face
is the rapidly changing user characteristics.
We consider a real-world use case of UAVs as a motivating
example for this work [30]. In recent years, UAVs have
been adopted by e-commerce industries, such as Amazon and
Walmart, for product deliveries. These UAVs help to securely
and quickly transport user goods in a cost-efﬁcient manner.
During the delivery process, each UAV travels over multiple
geographical locations and performs an array of tasks, such as
navigation, image recognition, and live video-streaming.
In Figure 1(b), we illustrate the traditional way of computing
for UAVs, where each UAV ofﬂoads all the collected data to
the dedicated edge servers for processing. In this model, UAVs
are forced to communicate with dedicated servers. When the
server is in the vicinity, the communication round-trip costs are
low; otherwise, they are high. Each edge server executes the

---

requests from various UAVs in an ordered-fashion. Moreover,
these servers need to be continuously scaled, new software
needs to be installed, and OS needs to be updated, which
makes them a ﬁnancially expensive choice.
In Figure 1(a), we reimagine the UAV delivery operation
in our serverless-edge co-design. Switching to our serverless-
edge model, allows UAVs in the vicinity to interact with each
other and act as a shim that spawns serverless executors to
process collected data. To alleviate concerns regarding round-
trip costs, the shim is permitted to opt for services from local
cloud providers. In fact, shim can spawn executors at multiple
clouds and wait for whichever responds earliest. As there is
a lack of trust among shim devices and executors, we have
our SERVERLESSBFT protocol to manage all the transactional
ﬂow in a byzantine fault-tolerant manner.
Byzantine failures in the wild. Do real-world systems face
more than just crash failures? Unfortunately, yes.
Exist-
ing systems suffer from omission failures where nodes can
crash [31], and arbitrary failures where nodes can act in an
unexpected manner [21]. Almost all real-world applications
handle omission failures using protocols based on Paxos-
family [32], [33]. However, the true challenge is to bulwark
the system system against often overlooked arbitrary fail-
ures: Google’s UpRight [21] provides fault-tolerance against
byzantine failures, Google has also observed corrupt execution
errors [22], and Cloudﬂare observed a misbehaving switch
sending incorrect messages [34]. Hence, it is better to guard
system against these failures.
III. PRELIMINARIES
We make standard assumptions as made by any BFT sys-
tem [16], [17], [19], [26]. We represent our serverless-edge
architecture A through a quintuple, A = {C, R, E, S, V},
where we use C to denote the set of clients, R to denote
the shim of edge devices or nodes, E to denote the serverless
executors, V and S to denote the veriﬁer and data-store. As
described in Section I, we assume an on-premise data-store
maintained by the enterprise, while the veriﬁer is a lightweight
wrapper around the data-store. Hence, both veriﬁer and storage
are assumed to be honest and trusted.
Fault-Tolerance Requirement at Shim. We use the notation
nR = |R| to represent total number of edge nodes in A. At
most fR of these nodes are byzantine and can crash-fail or act
arbitrarily; nR ≥3fR + 1. The remaining 2fR + 1 nodes are
honest and follow the protocol.
Authenticated
Communication.
To
exchange
messages
among different components, we employ Digital Signatures
(DS) and Message Authentication Codes (MAC) [35]. To
represent a message m signed by a component R using DS, we
use the notation ⟨m⟩R. Anyone who has the signer’s public-
key can verify this signature. One of the common ways to
exchange public-keys is through a public-key certiﬁcates [36].
For MACs, signer and veriﬁer use a common key, which is
kept secret. We use Difﬁe-Hellman key exchange for securely
sharing secret keys. In rest of the text, any message m that
does not indicate the identity of the signer implies the use
of MAC. Although MACs offer higher throughput than DS,
DS guarantee non-repudiation [16], [37]. We also employ
a collision-resistant hash function H(·) to map a value v
to a constant-sized digest H(v). We use a function id() to
assign an identiﬁer to each node R ∈R and each executor
E ∈E. We assume that byzantine components can neither
impersonate honest components, nor subvert cryptographic
constructs. We do not make any assumptions on the behavior
of the clients. We term a message as well-formed if it passes
all the cryptographic and other necessary checks.
A. Serverless Cloud Assumptions
We expect access to one or more serverless clouds such as
AWS Lambda and Google Functions. These serverless cloud
should permit edge nodes to seamlessly upload the desirable
code or transactions for processing as per the application
speciﬁcations. For simplicity, in rest of the text, we assume
that the shim nodes access only one cloud provider for
spawning executors to execute client transactions. However,
there is no free food as these serverless clouds follow a pay-
per-use model where whoever spawns executors also pays for
their use [38]. We expect these clouds to meet the following:
• Fault-Tolerance: To handle arbitrary faults at the server-
less cloud, we spawn nE ≥2fE +1 executors, and assume that
at most fE are byzantine. Prior works have shown that 2fE +1
executors guarantee successful execution of a transaction in the
byzantine setting [39]. This leads us to observe the following:
1) The values for fE and fR may or may not be same.
2) In Section VI, we illustrate that if the transactions are
conﬂicting, then we need an additional fE executors to prevent
an indistinguishable byzantine attack.
• Identity: We expect each spawned executor to be assigned
a unique pair of public-private key, which it uses to digitally
sign a message.
• Accountability: Each executor is spawned by some shim
node that pays for this service. Hence, we expect that no
executor can spawn more executors. Further, the expected
number of executors to be spawned by shim nodes is known
to all the components of our architecture.
• Payment. As executors are spawned by shim nodes, it
implies that the spawner will be billed by the cloud provider.
Hence, post successful consensus of a transaction, the edge
application’s enterprise pays the spawner a ﬁxed amount to
cover its expenses.
IV. ARCHITECTURE
We now discuss in detail the BFT transactional ﬂow guaran-
teed by our SERVERLESSBFT protocol in the serverless-edge
co-design. In Figure 2, we schematically present this ﬂow; the
shim consists of nR = 4 edge nodes and nE = 3 executors
are spawned per transaction. For understandability, we will
periodically refer to the UAV use case of Section II.
As stated earlier, shim can have different abstractions and
can run any BFT protocol. In this paper, we assume a single
shim of 3fR + 1 and require shim nodes to run the PBFT [16]
protocol. PBFT is considered as a representative BFT protocol

---

R3
R2
R1
P
C
E1
E2
E3
V
T
Three-phases of PBFT
EXECUTE VERIFY
REPLY
Fig. 2. Schematic representation of the transactional ﬂow in SERVERLESS-
BFT protocol. Given a client transaction T, the nodes of the shim work
together to order this transaction, following which the primary P invokes the
executors at the serverless cloud to execute T. Post execution, the executors
send their results to the veriﬁer, which replies to the client.
as all the other protocols follow its design. PBFT protocol
works in views. For each view, one node is designated as
the primary and is responsible for successful completion of
consensuses in that view. If the primary acts malicious, the
view is changed and the primary is replaced.
A. Client Request and Response
Any user that accesses the edge application becomes a client
in our system. E.g., each UAV that requires data-processing
from the cloud acts as a client and packages its request as a
transaction. A client C send a message ⟨T⟩C to the primary
node P2 of the current view v of the shim when it wants to
process a transaction T. Notice that C employs DS to sign
this message (refer to Figure 3, Line 1). The client C marks
⟨T⟩C as processed when it receives a RESPONSE message from
the veriﬁer V. As C knows that V is a trusted entity in our
infrastructure, it readily accepts the response (Line 3).
B. Shim Ordering
SERVERLESSBFT assigns each shim node (e.g. UAV) an
identiﬁer, 0, 1, 2, ..., nR. Initially, the shim node with identiﬁer
0 is designated as the primary P of the shim. On receiving a
client request ⟨T⟩C, P checks if ⟨T⟩C is well-formed. If this is
the case, P initiates the PBFT protocol as follows.
• Pre-prepare. The primary P assigns a sequence number
k to the well-formed client message m := ⟨T⟩C and sends it
as a PREPREPARE message to all the nodes of the shim. This
PREPREPARE message also includes a digest ∆= H(m),
which is used in future communication to save space. Notice
that the primary signs this message using MAC, which provide
sufﬁcient guarantees for this phase. When a node R ∈R
receives a PREPREPARE message from the primary P of view
v, it runs the message through a series of checks. If the checks
are successful, then R agrees to support the order k for this
client request by broadcasting a PREPARE message.
• Prepare. When a node R receives identical PREPARE
messages from 2fR + 1 distinct nodes (can include its own
message to reach the count), it marks the request m as
prepared and broadcasts a COMMIT message. We require each
node R to use DS to sign the COMMIT message.
2Some BFT protocols require a client request to be sent to all the nodes.
• Commit. When R receives identical COMMIT messages
from 2fR + 1 nodes, it marks m as committed.
Remark. PBFT requires two phases of quadratic communi-
cation complexity. Instead, shim can employ BFT protocols
like POE [40] and SBFT [41] that guarantee linear commu-
nication with the help of advanced cryptographic schemes
like threshold signatures. Note: in our architecture, the edge
devices are acting as both clients and shim nodes.
C. Serverless Optimistic Execution
Once P commits a request, SERVERLESSBFT requires P to
connect with the serverless cloud and spawn nE executors. P
sends each of these executors an EXECUTE message (Line 9),
which includes a certiﬁcate C; a set of signatures of 2fR + 1
distinct shim nodes and proves that these nodes agreed to order
this request (Line 8). Prior to executing the transaction T, each
executor E ∈E checks if the certiﬁcate C is valid.
During execution, E may need to access the value of read-
write sets (rw). Hence, it connects with the storage S and
fetches the required data (Lines 17-18). However, executors do
not write to the storage. Any intermediate results are stored
locally. Further, these executors do not communicate with
each other. Post execution, each executor E sends a VERIFY
message to the veriﬁer V, which includes the computed result
r, certiﬁcate C, and accessed read-write sets rw.
Remark. We allow shim to spawn either stateless or stateful
executors [38], [42]. Stateful executors have memory and
remember the results of last execution. By deﬁnition, severless
executors are “ﬂeeting” and return after execution; a common
way to assign these executors memory is by having a layer that
stores computed results [14]. To employ stateful executors in
our model, we would need BFT guarantees on the additional
layer. Hence, we focus on stateless executors. Including C in
the EXECUTE and VERIFY messages helps to detect byzantine
attacks (§ VI-B). Further, by employing threshold signatures,
we can reduce the size of the certiﬁcate. Threshold signatures
allow combining 2fR + 1 signatures into a single signature.
D. Veriﬁer and Concurrency Control
The veriﬁer V is a lightweight wrapper around the data-
store S and is assumed to be correct and trusted. The veriﬁer
collects well-formed VERIFY messages from the executors (in
set V) and once it has a quorum of matching results that do
not violate the concurrency control constraints, it updates the
data-store. It performs these tasks in the following order:
1) If set V has at least fE +1 matching VERIFY messages,
V marks the transaction as matched. Following this, V ignores
any other VERIFY message for ⟨T⟩C (Line 23).
2) If k is the sequence number for ⟨T⟩C and kmax is the
sequence number of last validated request, then if kmax̸ = k,
V places the k-th request in the list π (Line 29).
3) If kmax = k, V checks if the value of the read-write sets
rw of the k-th request is same as that in the data-store S
(Lines 31-32). If the read sets match, V sends the client and
the shim primary RESPONSE messages and updates the write

---

sets at the storage in accordance with the result r (Lines 33-
34). Note: matching read-write sets is only required when the
transactions are conﬂicting. We discuss this in Section VI.
4) Next, V increments kmax and checks if π includes the
transaction with sequence number kmax. If so, it removes the
kmax-th transaction from π and runs steps in Lines 26-27.
These concurrency control checks ensure that consistent
updates are written to the storage.
E. System Guarantees
We now state the guarantees offered by our different com-
ponents of our serverless-edge architecture.
Shim Consistency. If an honest node commits a transaction
T, then all the honest nodes commit T.
Shim Non-Divergence. If two honest nodes order a transac-
tion T at sequence number k and k′, then k = k′.
Shim Termination. If an honest client sends a transaction T,
then an honest node will eventually commit T.
Executor Termination. If
an
honest
primary
sends
an
EXECUTE message for transaction T, then an honest
executor will execute T.
Veriﬁer Non-Divergence. If the shim commits a transaction
T at sequence k, then the veriﬁer will eventually update
the corresponding result at the storage at order k.
Together, shim consistency, shim non-divergence, and veri-
ﬁer non-divergence imply safety, while shim termination and
executor termination imply liveness. Our SERVERLESSBFT
protocol guarantees safety in an asynchronous environment
where the messages can get lost, delayed, or duplicated, and
byzantine components can collude or act arbitrarily. To guaran-
tee liveness, our SERVERLESSBFT protocol expects periods of
synchrony. Note: our SERVERLESSBFT offers standard safety
and liveness guarantees, also offered by other systems [16],
[40], [17], [18], [19].
V. TACKLING BYZANTINE ATTACKS
In our architecture, at most fR shim nodes and fE serverless
executors can act byzantine. If the primary of shim is honest,
then byzantine nodes cannot affect the ongoing transactional
ﬂow. Similarly, byzantine executors can either provide incor-
rect result or ignore execution, but as there are at least fE + 1
honest executors, EXECUTE messages sent by honest primaries
will be processed. Hence, following is an exhaustive list of
attacks on our design.
(i) Request Suppression. If the primary of shim is byzantine,
it can try to prevent consensus on some client requests.
(ii) Nodes in Dark. If shim’s primary is byzantine, it can
keep up to fR honest shim nodes in dark by not involving
them in consensuses.
(iii) Veriﬁer Flooding. Byzantine components can ﬂood the
veriﬁer with requests that have been already veriﬁed.
Next, we present algorithms to recover from these attacks.
A. Request Suppression
In the serverless-edge architecture, byzantine components
can work together to deny service to one or more clients. This
request suppression attack can take three different forms:
Initialization:
// kmax := sequence number of the next request to be veriﬁed by V.
// π := ∅(list of requests marked matched at veriﬁer)
Client-role (used by client C to request transaction T) :
1: Sends ⟨T⟩C to the primary P.
2: Awaits receipt of message RESPONSE(⟨T⟩C , k, r) from V.
3: Considers T executed, with result r, as the k-th transaction.
Primary-role (running at the primary node P) :
4: event P receives ⟨T⟩C do
5:
Calculate digest ∆:= H(⟨T⟩C ).
6:
Broadcast PREPREPARE(⟨T⟩C , ∆, k) to all nodes (order at sequence k).
7: event P receives nf R m := ⟨COMMIT(∆, k)⟩R messages such that:
1) each message m is well-formed and is sent by a distinct node R ∈R.
do
8:
C := set of DS of these nf R messages. // Certiﬁcate
9:
Send ⟨EXECUTE(⟨T⟩C , C, m, ∆)⟩P to all executors E ∈E. // Serverless access
Non-Primary role (running at a node R ∈R) :
10: event R receives PREPREPARE(⟨T⟩C , ∆, k) from P such that:
1) message is well-formed, and R did not accept a k-th proposal from P.
do
11:
Broadcast PREPARE(∆, k) to all nodes in R.
All nodes role (running at the node R) :
12: event R receives PREPARE(∆, k) messages from nf R nodes such that:
1) each message is well-formed and is sent by a distinct node, R∗∈R.
do
13:
Broadcast ⟨COMMIT(∆, k)⟩R to all nodes in R.
Executor-role (running at the executor E ∈E) :
14: event E receives ⟨EXECUTE(⟨T⟩C , C, m, ∆)⟩P from P such that:
1) message is well-formed,
2) m := COMMIT(∆, k), and
3) Certiﬁcate C includes nf R distinct DS on m.
do
15:
while T not executed do
16:
rw := Read-write sets for T.
17:
if Need the current state of rw // Storage access then
18:
Fetch rw state (values) from storage S
19:
r := Result of executing T
20:
Send VERIFY(⟨T⟩C , C, m, rw, r) to veriﬁer V. // Communication with veriﬁer
Veriﬁer-role (running at the veriﬁer V) :
21: event V receives m′ := VERIFY(⟨T⟩C , A, m, rw, r) message from an executors
such that:
1) m′ is well-formed and is sent by a distinct executor E ∈E, and
2) m := COMMIT(∆, k).
do
22:
Add m′ to V.
23: event Set V has fE + 1 identical m′ :=VERIFY(⟨T⟩C , A, m, rw, r) messages
do
24:
if k = kmax // Next request in order. then
25:
Run function ccheck(π)
26:
while kmax-th transaction is in π // Other requests do
27:
Run function ccheck(π)
28:
else
29:
Store m′ in π.
30: function ccheck (list: π)
31:
rw′ := Current state of rw fetched from storage S.
32:
if rw′ = rw // Concurrency control check then
33:
Send ⟨RESPONSE(∆, r)⟩V to the client C and primary P. // Reply to client.
34:
Update corresponding rw with r at the storage S.
35:
kmax = kmax + 1.
Fig. 3. Byzantine Fault-Tolerant transaction processing by SERVERLESSBFT
protocol in the serverless-edge architecture.
(i) Request Ignorance. If the shim’s primary node P is
byzantine, it can willfully drop a request m from a client C,
or indeﬁnitely delay consensus on m.
(ii) Unsuccessful Consensus. A byzantine primary P may
involve less than 2fR+1 nodes in consensus on a client request

---

Client-role (running at the client C) :
1: event C’s timer τm for request m := ⟨T⟩C timeouts do
2:
Sends ⟨T⟩C to the veriﬁer V.
3:
Restarts τm.
4:
if Figure 3, Lines 2 and 3 are successful // Receives fR + 1 matching responses
then
5:
Cancel τm
Veriﬁer-role (running at the veriﬁer V) :
6: event V receives a well-formed request m := ⟨T⟩C from client C do
7:
if Previously sent RESPONSE for m then
8:
Resends message ⟨RESPONSE(∆, r)⟩V to C.
9:
else if m exists in list π // Waiting for consensus of kmax-th request then
10:
Broadcasts ⟨ERROR(kmax)⟩V to all shim nodes.
11:
else if Did not receive any VERIFY message for ⟨T⟩C then
12:
Broadcasts ⟨ERROR(⟨T⟩C )⟩V to all shim nodes. // Missing Request
13:
else
14:
Broadcasts ⟨REPLACE(⟨T⟩C )⟩V to all shim nodes. // Byzantine Primary
Node-role (running at the node R) :
15: event R receives ⟨ERROR(⟨T⟩C )⟩V or ⟨ERROR(kmax)⟩V from V do
16:
Start a timer Υ.
17:
Forward the ERROR message to the primary P.
18: event R’s timer τm or Υm timeout or R receives ⟨REPLACE(⟨T⟩C )⟩V from V
do
19:
Run the view-change protocol to replace P
Fig. 4.
Actions performed by various participants of the serverless-edge
infrastructure in response to a request suppression attack.
m. As a result, these nodes will not reach consensus on m.
(iii) Less Executors. A byzantine primary P may permit
consensus on a client request m, but disallow its execution
by spawning less than nE serverless executors. In such a case,
the veriﬁer V will not receive fE+1 matching execution results.
To detect these attacks, we setup three distinct timers at
various components of our architecture.
• Client timer. Our SERVERLESSBFT protocol requires
each client C to start a timer τm prior to sending its request
m to the primary P. When C receives a RESPONSE message
for m from the veriﬁer V, it stops τm.
• Node timer. Our SERVERLESSBFT protocol requires each
node R ∈R to start a timer τm when it receives a well-formed
PREPREPARE message for a client request m from the primary
P. When R marks m as committed, it stops τm.
• Node re-transmission timer. If a non-primary node R ∈R
receives an ERROR message from the veriﬁer V (see Sec-
tion V-A2) then R forwards the ERROR message to the primary
P and starts the re-transmission timer Υ. When R receives a
corresponding ACK message from V, it stops Υ.
In the case the timers of C or R expire, the respective
component detects a request suspension attack and initiates
the following mechanisms for recovery from this attack.
1) Client action on timeout: If a client C’s timer τm
timeouts, then C forwards its request to the veriﬁer V and
restarts its timer (refer to Figure 4). In speciﬁc, each time C’s
timer expires, after some exponential backoff, it re-sends its
request to V until it receives a RESPONSE message from V.
2) Veriﬁer action on receiving client request: When the
veriﬁer V receives a request m := ⟨T⟩C from client C, it
ﬁrst determines if it has seen ⟨T⟩C till now or not. If V
has not received any VERIFY messages for ⟨T⟩C, it sends
⟨ERROR(⟨T⟩C)⟩V message to all the nodes in the shim. Oth-
erwise, there can be only three cases:
(i) V did send a RESPONSE message for ⟨T⟩C, so it simply
resends the RESPONSE message.
(ii) ⟨T⟩C resides in π. Further, assume that it was ordered
by shim at some sequence number k. So kmax < k, and V is
waiting for the request with sequence number kmax. Unless the
kmax-th request is validated by V, succeeding requests cannot
be processed. So, V needs to notify shim nodes about the
missing request at sequence kmax, and it does so by sending
⟨ERROR(kmax)⟩V to all the shim nodes. Note: this gap between
kmax and k could have been created by byzantine primary.
(iii) V did not receive fE + 1 matching VERIFY messages
for ⟨T⟩C. This can only occur if the primary is byzantine. So,
V sends ⟨REPLACE(⟨T⟩C)⟩V to all the shim nodes.
Once V successfully veriﬁes the request at sequence number
kmax or ⟨T⟩C, V creates a corresponding ⟨ACK(kmax)⟩V or
⟨ACK(⟨T⟩C)⟩V message and broadcasts it to shim.
3) Node action on ERROR message: When a shim node
R ∈R receives an ERROR message from the veriﬁer, it can
only conclude the following:
• R received ⟨ERROR(kmax)⟩V message and has either com-
mitted or not committed the request at sequence number kmax.
• R received ⟨ERROR(⟨T⟩C)⟩V message and has either
committed or not committed the request ⟨T⟩C.
Irrespective of these cases, the node R starts a re-transmit
timer Υ to track the behavior of the primary. Next, it forwards
the received ERROR message to the primary. If the timer Υ
expires before R receives a corresponding acknowledgment
message (⟨ACK(kmax)⟩V or ⟨ACK(⟨T⟩C)⟩V) from the veriﬁer
V, R concludes that the primary is byzantine and requests a
view-change. Hence, the onus is on the primary to guarantee
consensus and execution.
4) Node action on timeout: When the timer τm for a node
R ∈R expires, R concludes that the shim’s primary for
view v is byzantine, and it requests primary replacement by
broadcasting a VIEWCHANGE message. We employ PBFT’s
view-change protocol to replace a byzantine primary. A node
R’s request for change of view from v to v + 1 is only
successful if it receives support of at least 2fR +1 nodes, that
is, at least 2fR +1 shim nodes must broadcast VIEWCHANGE
messages. Replacing the current primary requires designating
another shim node as the next primary. Like PBFT, we assume
nodes have a pre-decided order of becoming the primary. As
a result, when the replica designated as the primary for view
v + 1 receives VIEWCHANGE requests from at least 2fR + 1
nodes, it assumes the role of the primary and broadcasts a
NEWVIEW message to bring all the nodes to the same state.
Similarly, when a node R receives a REPLACE message from
the veriﬁer V, it initiates the view-change protocol to replace
the primary P to view v. We defer the details for the exact
view-change protocol to the original PBFT paper [16].
B. Shim Nodes in Dark
If the primary P is byzantine, it may attempt to only include
2fR +1 nodes in consensus as only 2fR +1 nodes are needed
to mark any request as prepared and committed. As a result,

---

the remaining fR nodes will be in dark. Next, we explain what
we mean by being in dark.
(i) Node Exclusion. A byzantine primary P can exclude up
to fR honest nodes from consensuses by not sending them the
PREPREPARE messages for client requests.
(ii) Equivocation. A byzantine primary P can equivocate
by associating two client requests with the same sequence
number k. If P is clever, it will ensure that one of these client
requests is committed by at least fR + 1 honest nodes while
the remaining fR honest nodes do not commit any request at
sequence number k.
The key challenge to resolving the attack (i) is that it is
impossible to detect. In this attack, the byzantine primary P
is clever and does not want to risk replacement. Hence, P
facilitates continuous consensus on incoming client requests
by at least fR +1 honest nodes. As a result, the remaining fR
nodes are unable to trigger view-change by themselves.
Lemma V.1. If at most fR shim nodes are in dark, then it is
impossible to detect such an attack and replace the primary.
Proof. Let D be the set of shim nodes in dark, such that
|D| ≤fR. We start with the assumption that the nodes in D
are able to prove that they are under an attack by the byzantine
primary P and ensure P’s replacement by convincing a majority
of nodes to participate in the view-change protocol.
For a view-change to take place at least 2fR + 1 nodes
need to support such an event. As P is clever, it ensures that
at least U ≥fR + 1 honest nodes continuously participate
in consensus. Clearly, U > D, which implies that a majority
of honest nodes will not request view-change. The remaining
nR −U −D = fR nodes are byzantine and will support the
primary in this attack. Moreover, the nodes in set U cannot
distinguish between the nodes in set D and the up to fR actual
byzantine nodes, as the byzantine nodes can always request a
view-change in an attempt to derail the system progress by
replacing an honest primary. Hence, the view-change request
by nodes in D will never be successful.
Featherweight Checkpoints. To recover from nodes in dark
attacks, we design a featherweight variant of existing check-
point protocols [16], [43]. Existing BFT protocols require
nodes to periodically construct and exchange CHECKPOINT
messages, but these messages are expensive as they include
all the client requests and the proof that they are committed
(COMMIT messages from 2fR+1 distinct nodes) since the last
checkpoint. As our shim nodes neither execute client requests
nor store any data, during our featherweight checkpoint proto-
col, these nodes only send the signed proofs (certiﬁcates) for
each committed request since last checkpoint.
Remark. The nodes in dark attacks do not make the system
unsafe but put it at the mercy of the byzantine nodes, which
can stop responding after several consensuses have passed; the
system suffers from massive communication during recovery.
C. Veriﬁer Flooding
As the veriﬁer manages all updates to the data-store, it
is a desirable target by byzantine components. Speciﬁcally,
byzantine components can try the following ways to disrupt
the system by ﬂooding the veriﬁer with redundant requests.
(i) Duplicate Spawning by Primary. If the shim’s primary
node is byzantine, it can spawn more executors than necessary.
(ii) Duplicate Spawning by Non-primary. A byzantine non-
primary node that was once the primary node of shim has
access to old certiﬁcates and EXECUTE messages. It can use
these messages to spawn new executors at the serverless cloud.
(iii) Duplicate Messages by Executors. A byzantine execu-
tor can send duplicate VERIFY messages to the veriﬁer.
Although ﬂooding attacks seem trivial to perform, they have
monetary impacts on the byzantine components. Spawning
each serverless executor requires the spawner to pay a ﬁxed
amount of money. As a result, any ﬂooding attack performed
by a byzantine component will be self-penalizing. For exam-
ple, in our architecture, each primary is paid a ﬁxed amount
per consensus by the edge application organization. Hence, a
rational byzantine component will avoid this attack.
Moreover, all of these attacks are trying to ﬂood the veriﬁer
with the VERIFY messages. To mitigate the impact of these
ﬂooding attacks: we require the veriﬁer V to ignore any
VERIFY message for a client request m, once it has received
matching VERIFY messages for m from fE + 1 executors.
Finally, it is a common practice to connect different entities
on the network via sockets. If ﬂooding attacks take place, the
veriﬁer can block communication from such connections.
VI. TRANSACTIONAL CONFLICTS
Two client transactions T and T′ are termed as conﬂicting
if T and T′ require access to a common data-item x and
at least one of these operations writes to x [44]. In our
SERVERLESSBFT protocol, transactional conﬂicts arise from
the following set of transactions: two transactions T and T′
ordered at sequences k and k′, respectively, and k < k′ and
T writes to x, which T′ reads.
Example VI.1. For ensuing discussions, we assume two
conﬂicting transactions T and T′. Let the sequence number
for T be 3 and sequence number for T′ be 4. Further, assume
T needs to write to data-item x and T′ needs to read x.
A. Concurrent Spawning
On a close inspection of Figure 3, one can observe that the
primary P does not wait for consensus of the k-th request to
ﬁnish before initiating consensus for the (k + 1)-th request.
This process of concurrently invoking multiple consensuses
has been employed by prior works to increase the system
throughput as it reduces the idle times for nodes [17], [45].
To further boost the throughput, we permit the primary
to spawn the nE executors for the (k + 1)-th request prior
to spawning executors for k-th request. We term this as
concurrent spawning. If the client requests are non-conﬂicting,
concurrent spawning helps to parallelize execution.
In the case transactions are conﬂicting, like T and T′ of
Example VI.1, we can have two cases: the read-write sets
a transaction accesses are either known or unknown to the
shim nodes prior to execution. Depending on the knowledge

---

of read-write sets, transactions may or may not abort in our
architecture. A naive way would be to ask the shim primary
to sequentially spawn executors for each client request, but
that will signiﬁcantly reduce the throughput attained by our
SERVERLESSBFT protocol. Hence, we design algorithms to
handle either cases, which we discuss next.
B. Unknown Read-Write Sets
If the shim nodes cannot determine the read-write sets of
a transaction during consensus, we require the shim nodes
to continue following the algorithm in Figure 3. The only
change is that the shim’s primary should spawn an additional
fE executors; the shim primary now spawns nE ≥3fE + 1
executors instead of nE ≥2fE + 1 as stated earlier. We prove
the need for these additional executors later.
However, due to the conﬂicting transactions like T and T′
of Example VI.1, the veriﬁer V may observe the following: (i)
it did not receive fE + 1 matching VERIFY messages for T′,
or (ii) the read sets of T′ are stale. In such cases, the veriﬁer
would have to abort transaction T′.
Byzantine Aborts and Decentralized Spawning. A big chal-
lenge to permitting the veriﬁer to abort transactions is a byzan-
tine primary that can intentionally delay spawning executors
for some of the committed transactions to get them aborted.
Moreover, this attack is impossible to detect by other shim
nodes or the veriﬁer. Prior works have shown that there are
no easy solutions to prevent byzantine aborts for conﬂicting
transactions with unknown read-write sets [46]. One way to
prevent this attack in our serverless-edge architecture is to
require each node of the shim to spawn some executors at the
serverless cloud. In speciﬁc, once a node R ∈R commits a
client request m, it spawns e executors.
e =



1,
if nE ≤nR

nE
2fR + 1

,
otherwise
(1)
If nE is less than nR, then each node R ∈R needs to spawn
only one executor. This will guarantee that of all the spawned
executors at least fE + 1 are honest. Otherwise, each node R
needs to spawn

nE
2fR + 1

executors. Why? Because up to fR
nodes are byzantine and may avoid spawning any executors.
Hence, the remaining 2fR +1 honest nodes need to spawn nE
executors. Clearly, the total number of spawned executors (e×
nR) is much larger than the required number of executors nE.
This is a trade-off we need to pay if we want to decentralize
the spawning of serverless executors. Another major trade-off
of this decentralized spawning is that if the read-write sets are
known, then each node needs to sequentially spawn executors.
Hence, like primary (refer to Section VI-C), each node has to
track the dependencies. Moreover, the proposed value of e is
only valid if each honest node commits the client request. If
up to fR honest nodes are in dark, then e changes as follows:
e =



1,
if nE ≤nR

nE
fR + 1

,
otherwise
(2)
Conservatively, we can set e = nE, but that will lead to
spawning nE × nR executors in the worst case.
Veriﬁer Abort Detection. With the addition of byzantine
aborts, the veriﬁer needs to determine when to abort a trans-
action T′ and if possible, the cause for abort. As a result, the
veriﬁer needs to wait for fE+1 matching VERIFY messages for
T′. For this purpose, our SERVERLESSBFT protocol requires
the veriﬁer V to start a timer τm when it receives the ﬁrst
VERIFY message for the transaction m := T′. V stops τm
when it receives fE + 1 matching VERIFY messages, or it
receives VERIFY messages from all the 3fE + 1 executors.
Like in Figure 3, say the veriﬁer collects all the incoming
VERIFY messages for m in a set V. If the veriﬁer’s timer
expires while waiting, it takes one of the following actions:
• |V| < 2fE + 1 : This case implies that the veriﬁer V
received less than 2fE + 1 VERIFY messages for transaction
T′. As a result, V concludes that the primary P is byzantine
and it creates and broadcasts a REPLACE message to the shim
nodes. Receiving less than 2fE + 1 VERIFY messages implies
that either the primary P spawned less than nE executors or
some messages got dropped; at most fE executors can act
byzantine and can decide to not send VERIFY messages to V,
In either case, it is safe to conservatively blame the primary.
Note: even existing BFT protocols decide to blame the primary
if messages get dropped [16], [41], [43].
• nE > |V| ≥2fE +1 : This case implies that the veriﬁer V
received more than 2fE + 1 VERIFY messages for transaction
T′. As a result, the veriﬁer V cannot conclude that the shim’s
primary is byzantine as V has received VERIFY message from
at least 2fE +1 distinct executors. Observing responses from at
least 2fE +1 executors is a guarantee that at least fE +1 honest
executors tried to execute T′ to the best of their ability. Hence,
even if the shim’s primary is byzantine and intentionally delays
spawning executors for T′, there is no way that the veriﬁer can
prove this (due to concurrent spawning).
This forces the veriﬁer to abort this transaction. Assume k
is the sequence number for T′. If kmax = k, then V sends the
client an ⟨ABORT(T′)⟩V message. Otherwise, V adds T′ to the
list π, but tags it as abort. Later, when T′ is extracted from
the list π, the veriﬁer V aborts it.
We now describe the indistinguishable attack, which forces
us to require primary to spawn nE ≥3fE + 1.
Theorem VI.2. If client transactions are conﬂicting and
the primary P spawns nE < 3fE + 1 executors, then the
SERVERLESSBFT protocol faces an indistinguishable attack.
Proof. Assume that P spawns only 2fE+1 executors. We know
that up to fE of these executors can act byzantine. As a result,
for any client request, the veriﬁer V may receive only fE + 1
VERIFY messages. Further, due to transactional conﬂicts, these
fE +1 VERIFY messages may not match. Eventually, V’s timer
will expire and it needs to take some action. V can decide to
abort this transaction, but this would lead to a new problem—
a byzantine primary P may never spawn more than fE + 1
executors and up to fE of those executors may be byzantine.
Hence, all subsequent conﬂicting transactions may abort.

---

Alternatively, V can blame the primary for receiving less
than fE + 1 matching VERIFY messages, but such a decision
could be wrong as P may not be byzantine and the lack of
sufﬁcient matching messages could be a result of conﬂicts
and byzantine executors.
C. Best Effort Conﬂict Avoidance
In database literature, several works have employed the
concept of deterministic databases for efﬁcient conﬂict res-
olution [47], [48], [49]. In these databases, the order in which
transactions are applied to the database is determined prior to
its execution, which is only possible if the read-write sets of
the transactions are known to the participating nodes.
In our SERVERLESSBFT protocol, we learn from these
databases. If the primary has any knowledge of the read-
write sets, it uses the queuing strategy of these databases,
to create plans that allow running non-conﬂicting transactions
in parallel [47], [48], [50], [49], [51]. Such a strategy would
require us to make straightforward modiﬁcations to the algo-
rithm presented in Figure 3. We would need the shim primary
to maintain a logical map of all data-items. This map does
not store any values of the data-items, but helps the primary
to locally lock different data-items. Further, the primary can
no longer concurrently spawn executors for a transaction until
it has determined its conﬂicts. Next, we list the steps.
1) The primary P adds the k′-th transaction to the execution
queue after it has added (or spawned executors for) all the k-th
transactions in the queue, where k < k′.
2) If the k′-th transaction does not conﬂict with any k-th
transaction (k < k′), P spawns serverless executors for the k′-
th transaction after it has logically locked all the data-items
that are written by the k′-th transaction.
3) Next, P dequeues a non-conﬂicting transaction at the
head of some queue and repeats Step 2.
4) When P is notiﬁed by the veriﬁer V that T has been
executed, it unlocks the data-items accessed by T and follows
Step 3. We believe these steps can help to reduce aborts.
VII. SAFETY AND LIVENESS GUARANTEES
We now prove that SERVERLESSBFT guarantees safety and
liveness. As the shim nodes employ PBFT protocol, we borrow
the following proposition guaranteed by PBFT.
Proposition VII.1. Let Ri, i ∈{1, 2}, be two honest shim
nodes that committed ⟨Ti⟩Ci as the k-th transaction of view
v. If nR > 3fR, then ⟨T1⟩C1 = ⟨T2⟩C2.
Theorem VII.2. Given an architecture A = {C, R, E, S, V},
if the number of byzantine shim nodes and byzantine server-
less executors are bounded by fR and fE, respectively, then
SERVERLESSBFT protocol guarantees safety.
Proof. Prior to proving this, we note that as the veriﬁer V
is trusted, storage S will be updated in the order agreed by
2fR + 1 of shim nodes. We prove the rest as follows:
Non-conﬂicting transactions. If the primary P is honest,
then from Proposition VII.1, we can conclude that no two
shim nodes will commit different transactions at the same
sequence number and P will spawn 2fE + 1 executors. These
transactions will persist across views as in any view-change
quorum of 2fR + 1 replicas, there will be one honest replica
that has executed this request. If P is byzantine and assigns
two or more requests the same sequence number k, then from
Proposition VII.1, we know that P will not be successful. If the
byzantine P sends the PREPREPARE for some T to less than
2fR +1 replicas, this transaction will not commit. As a result,
at least fR + 1 replicas will timeout and a VIEWCHANGE
will take place. The new primary waits for VIEWCHANGE
messages from 2fR + 1 replicas, and uses these messages
to create a NEWVIEW message. This NEWVIEW message
includes a list of requests for each sequence number present
in the VIEWCHANGE message. Each replica on receiving the
NEWVIEW message can verify its contents and update its state.
Conﬂicting transactions with unknown read-write sets. In
the case of conﬂicting transactions, the only additional attack
a byzantine primary P can do is to get a transaction aborted by
delaying spawning executors. However, as P does not know,
which transactions are conﬂicting, this is all based on a guess.
Note: this attack does not make the data-store unsafe.
Theorem VII.3. Given an architecture A = {C, R, E, S, V},
if the network is reliable and the number of byzantine shim
nodes and serverless executors are bounded by fR and fE,
respectively, then SERVERLESSBFT guarantees liveness.
Proof. Prior to proving this, we note that as the veriﬁer V is
trusted, so if it receives 2fE + 1 matching VERIFY messages
with correct read-write sets, it will send a reply to the client.
We prove the rest as follows:
Non-conﬂicting transactions. If the primary P is honest, then
every transaction will be committed by at least 2fR + 1 shim
nodes. P will use this to create a certiﬁcate and spawn 2fE +1
executors and V will receive fE + 1 matching responses.
If P is byzantine, it can perform one of the many types of
request suspension attacks described in Section V-A. For each
such attack, either the client C or the nodes in R will timeout.
This will force P to either ensure consensus of C’s transaction,
or be replaced through the view-change protocol. Post view-
change, if the subsequent primary is also byzantine, then it
will also be eventually replaced. This process can happen at
most fR consecutive times, after which the system will be
live. In the case a byzantine primary P attempts to keep up
to fR nodes in dark, then using the featherweight checkpoint
protocol these nodes will be brought to the same state.
Conﬂicting transactions with unknown read-write sets. In
the case of conﬂicting transactions, the only additional attack
a byzantine primary P can do is to spawn less than 3fE +1. In
such a case, if the veriﬁer V receives less than 2fE +1 VERIFY
messages, such that less than fE+1 are matching, V’s timer τm
will timeout and it will send a REPLACE message to the shim
nodes. For other cases, V will send the client a RESPONSE or
ABORT message depending on if it receives fE + 1 matching
VERIFY messages.

---

VIII. IMPLEMENTATION
To gauge the practicality of our vision of a BFT serverless-
edge architecture, we implement and evaluate our design.
Shim. As the shim nodes represent edge devices, which
may have access to limited resources, we want the shim
nodes to have a lightweight BFT implementation. So, on each
shim node, we install RESILIENTDB’s node architecture [17],
[26], [27], [40], [52], [53]. RESILIENTDB provides access
to a multi-threaded, pipelined, and modular architecture for
designing BFT applications.3 The codebase is written in C++
and we deploy RESILIENTDB’s PBFT protocol at the shim.
Clients also employ C++ to create YCSB transactions (refer
Section IX) and use NNG [54] sockets for communication.
Invoker. At each shim node, we deploy an invoker to
spawn nE executors when indicated by the node’s consensus
instance. RESILIENTDB provides at each node an execute-
thread, which calls invoker as soon as a request is committed.
Our implementation of the invoker is written in Go [55] using
the AWS SDK for Go. Further, our invoker does not wait for
the spawned executors to ﬁnish and proceeds to spawn the
executors for the next client request.
Serverless Function. Each AWS Lambda executor receives
a function written in C++ that includes the client transaction.
This function instructs the executor to: (i) verify the certiﬁcate
C, (ii) execute the transaction, (iii) fetch necessary read-write
sets from the storage database, and (iv) send the result to the
veriﬁer. We encode the communication between the Lambda
function and the veriﬁer in a stateless HTTP request. We use
CryptoPP[56] library for digital signatures and veriﬁcation and
use CPR[57] to create and send HTTP requests.
Veriﬁer. We implement the veriﬁer in Go and install a simple
HTTP/Net webserver at the veriﬁer for receiving the executor
responses. Further, our veriﬁer includes a hashmap to count
the matching responses for each transaction. Post validation,
the veriﬁer uses NNG to send a response to the client.
IX. EVALUATION
Our evaluation aims to answer following questions regard-
ing our SERVERLESSBFT protocol.
(Q1) Impact of client congestion?
(Q2) Impact of increasing the number of executors?
(Q3) Impact of batching client requests?
(Q4) Impact of expensive execution?
(Q5) Impact of spawning executors across globe?
(Q6) Impact of resource limitations at edge devices?
(Q7) Impact of conﬂicting transactions?
(Q8) Baseline comparison of SERVERLESSBFT?
(Q9) Impact of task ofﬂoading?
Setup. We deploy the veriﬁer, shim nodes, and clients on
the Oracle Cloud Infrastructure (OCI). These components use
VM.Standard.E3.Flex architecture with 10 GiB NICs. Each
shim node has 16 cores and 16 GiB RAM and the veriﬁer has 8
cores. We use AWS Lambda Functions for spawning serverless
executors in up to 11 regions in the following order: North
3RESILIENTDB is open-sourced at https://resilientdb.com/.
0.2
0.4
0.6
0.8
1
1.2
1.4
1.6
0
40K
80K
120K
160K
Latency (s)
Throughput (txn/s)
SERVBFT-8
SERVBFT-32
Fig. 5. Comparing latency against throughput on varying the number of clients
sending requests to the shim.
California, Oregon, Ohio, Canada, Frankfurt, Ireland, London,
Paris, Stockholm, Seoul, and Singapore. In our experiments,
we use up to 128 shim nodes and 21 executors. We run each
experiment for 180 seconds with 60 seconds warmup time and
report the average results over three runs.
Unless explicitly stated, we use the following setup. We
require the primary node to spawn 3 AWS Lambda executors,
each of which is spawned in a distinct region. Further, we
deploy up to 80 k clients on 4 OCI machines to concurrently
issue requests. Each client waits for a response prior to sending
its next request. We also require clients and edge nodes to
employ batching and run consensuses on batches of 100 client
transactions. The size of each type of message communi-
cated is: PREPREPARE (5392 B), PREPARE (216 B), COMMIT
(220 B), EXECUTE (3320 B), and RESPONSE (2270 B).
Benchmark. To evaluate our serverless-edge architecture
across different parameters, for some experiments, we need
to ﬁx the number of shim nodes. We learn from existing
database literature, speciﬁcally the Blockbench [58] paper, and
select two conﬁgurations. SERVBFT-8: Medium size shim
with 8 nodes. SERVBFT-32: Large size shim with 32 nodes
(maximum number of nodes in any Blockbench experiment).
Similarly, we adopt the popular Yahoo Cloud Serving
Benchmark (YCSB) from Blockbench suite, which has also
been used by several prior works in database literature for
designing transactions [17], [49], [58], [59], [60].
We use
YCSB to create key-value transactions that access a database
of 600 k records. Speciﬁcally, our transactions perform read
and write operations. With regards to edge applications, these
transactions represent user transactions that require access to
existing records in the storage.
A. Impact of Client Congestion
In Figure 5, we vary the number of deployed clients from
2 k to 88 k. For the ﬁrst ﬁve data-points on the graph, we
double the number of clients and for succeeding points, we
increase the number of clients by 8 k. Initially, an increase in
the number of clients causes an increase in system throughput,
post which the throughput saturates. This happens because
each entity in our serverless-edge architecture has to now do
more work than before, which causes an increase in com-
putational and communication costs. As a result, the latency
keeps increasing as each request spends a longer time in the
architecture. Hence, SERVBFT-8 outperforms SERVBFT-32
as fewer nodes are involved in each consensus, which implies
smaller wait time for each request. Summary: We observe that

---

SERVBFT-8
SERVBFT-32
3
5
11
15
21
0
30K
60K
90K
120K
150k
Number of Executors
Throughput (txn/s)
(i) Scaling Executors (Throughput)
3
5
11
15
21
0.0
0.5
1.0
Number of Executors
Latency (s)
(ii) Scaling Executors (Latency)
10 100 200
1000
5000
8000
0
40K
80K
120K
160K
200K
240K
Batch size
Throughput (txn/s)
(iii) Batching (Throughput)
10 100 200
1000
5000
8000
0.0
1.0
2.0
Batch size
Latency (s)
(iv) Batching (Latency)
0
1
2
4
8
0
30K
60K
90K
120K
150k
Execution Length (seconds)
Throughput (txn/s)
(v) Expensive Execution (Throughput)
0
1
2
4
8
0.0
2.0
4.0
6.0
8.0
10.0
Execution Length (seconds)
Latency (s)
(vi) Expensive Execution (Latency)
5
7
9
11
20K
40K
60K
80K
Number of Regions
Throughput (txn/s)
(vii) Executor Distribution (Throughput)
5
7
9
11
0.4
0.6
0.8
1.0
Number of Regions
Latency (s)
(viii) Executor Distribution (Latency)
2
4
8
12
16
0
30K
60K
90K
120K
150k
Number of Cores
Throughput (txn/s)
(ix) Computing Power (Throughput)
2
4
8
12
16
0.0
0.5
1.0
1.5
2.0
Number of Cores
Latency (s)
(x) Computing Power (Latency)
0
10
20
30
40
50
0
30K
60K
90K
120K
150k
Conﬂict Percentage
Throughput (txn/s)
(xi) Conﬂicting Transactions (Throughput)
0
10
20
30
40
50
0.0
0.2
0.4
0.6
0.8
Conﬂict Percentage
Latency (s)
(xii) Conﬂicting Transactions (Latency)
Fig. 6. Benchmarking throughput attained and latency incurred by the BFT Serverless-Edge architecture.
initially SERVBFT-8 attains up to 1.6× more throughput and
1.2× less latency than SERVBFT-32. However, on increas-
ing the number of clients, the gap increases to 2.8× more
throughput and 2.71× less latency.
B. Impact of Executors
In Figures 6(i) and 6(ii), we vary the number of serverless
executors spawned by the primary node: 3, 5, 11, 15, and 21.
For these experiments, we spawned executors in up to seven
regions and tried to evenly split these executors across these
regions. These ﬁgures illustrate that an increase in the number
of executors causes a decrease in throughput and an increase
in latency. Although all the executors process the requests in
parallel, there is an increase in the task of spawning at the
primary and increase in validation at the veriﬁer. Further,
as executors are spread across distinct regions, the reduced
bandwidth and increased ping costs delays communication.
Summary: At 3 executors, SERVBFT-8 attains 2.59× more
throughput and 43% less latency than SERVBFT-32, while at
15 executors, 47% more throughput and 5% less latency.
C. Impact of Batching
In Figures 6(iii) and 6(iv), we vary the size of batch of
client requests from 10 to 8 k. With an increase in batch
size, we ﬁrst observe an increase in the system throughput
followed by an eventual decrease. Although larger batches
imply a corresponding decrease in the number of runs of
the SERVERLESSBFT protocol, it substantially increases the
costs of communicating batches across the shim nodes and
executors. Further, larger batches are much more expensive to
process for shim nodes and executors.
Summary: From batch size 10 to 5 k, SERVBFT-8 observes
an increase in throughput by 11.42× and SERVBFT-32 ob-
serves an increase in throughput by 18.5×.
D. Impact of Expensive Execution
In Figures 6(v) and 6(vi), we test with transactions that
require large execution time; we vary the time required for
execution from few milliseconds to 8 seconds. As the time
required to execute a transaction increases, the time required
by the shim and the veriﬁer to process this request becomes
insigniﬁcant. Prior works show that such transactions or codes,
which bottleneck the system throughput and latency are preva-
lent [61]. This experiment also proves that our serverless-
edge architecture introduces minimal costs to the applications
that require large execution times. Summary: From execu-
tion length of few milliseconds to 8 seconds, SERVBFT-8’s
throughput reduces by 74.5% and latency increases by 21×,
while SERVBFT-32’s throughput reduces by 51% and latency
increases by 13.6×.
E. Impact of Spawning Executors across Globe
In Figures 6(vii) and (viii), we require the primary node to
spawn 11 executors in 5, 7, 9, and 11 regions; we vary the
number of regions while spawning same number of executors.
The primary node uses the round-robin protocol to spawn
executors in each region. In this experiment, we want to
observe the impact of system performance on increasing the

---

SERVERLESSBFT
SERVERLESSCFT
PBFT
NOSHIM
4
8
16
32
64
128
0
40K
80K
120K
160K
200K
250K
Number of Replicas (n)
Throughput (txn/s)
4
8
16
32
64
128
0.0
0.5
1.0
1.5
Number of Replicas (n)
Latency (s)
Fig. 7.
Comparing SERVERLESSBFT against our three baseline designs:
SERVERLESSCFT, PBFT and NOSHIM.
number of regions. We observe that the throughput and latency
remain constant. The primary node spawns 11 executors
(fE = 5), so the veriﬁer needs to wait for only fE + 1 = 6
matching VERIFY messages. The ﬁrst 6 messages received by
the veriﬁer (deployed at North California) are from nearby
regions: North American and European.
F. Impact of Computing Power
We use Figures 6(ix) and 6(x) to limit the available com-
puting resources at shim nodes. As shim nodes represent edge
devices, these devices may have limited cores and memory. So
we test the impact of this restricted hardware om SERVER-
LESSBFT. Unsurprisingly, as we increase the number of
available cores, the protocols achieve higher throughputs and
lower latencies. This is the case because our shim nodes adopt
the multi-threaded pipelined architecture of RESILIENTDB,
which performs better with an increase in available cores.
Summary: From experiments at 2 cores to 16 cores,
SERVBFT-8’s throughput increases by 6× and latency de-
creases by 70%, while SERVBFT-32’s throughput increases
by 5× and latency decreases by 64%.
G. Impact of Conﬂicting Transactions
We now vary the degree of transactional conﬂicts from 0 to
50% and illustrate our ﬁndings in Figures 6(xi) and 6(xii). As
the read-write sets are unknown, the primary node cannot lock
the conﬂicting data-items. As a result, some transactions get
aborted at the veriﬁer. This leads to an expected observation–a
decrease in throughput with an increase in the rate of conﬂicts.
However, the latency remains unchanged as the response time
for the client remains the same.
Summary: From 0% conﬂicting transactions to 50% con-
ﬂicting, SERVBFT-8’s throughput decreases by 43%, and
SERVBFT-32’s throughput decreases by 46%.
H. Shim Scalability
Until now, in all the experiments, we ran the PBFT protocol
at the shim. So, we create three baseline designs to compare
against SERVERLESSBFT:
(a) NOSHIM– Represents the experiment where there is no
shim; no BFT consensus takes place. All the clients send their
requests to a node, which instantaneously spawns executors.
(b) SERVERLESSCFT– Represents the experiment where
the shim nodes employ a crash fault-tolerant (CFT) like
Paxos [32] for consensus. As CFT protocols do not protect
SERVBFT-32
PBFT-1-ET
PBFT-8-ET
PBFT-16-ET
0 50 100
500 1000 1500 2000
100
1K
10K
50K
Increase in Execution Time (milliseconds)
Throughput (txn/s)
0 50 100
500 1000 1500 2000
1
10
100
Increase in Execution Time (milliseconds)
Cost (cents/ktxn)
Fig. 8. Comparing our serverless-edge model against PBFT. Here, ET refers
to number of execution threads assigned to speciﬁc PBFT implementation.
against byzantine attacks, they do not require cryptographic
signatures, which in turn reduces the amount of work done
per consensus. Further, unlike PBFT, Paxos is linear.
(c) PBFT– We also test our SERVERLESSBFT protocol
against a BFT system (e.g. RESILIENTDB) running the PBFT
protocol. In this system, we assume each node is a replica and
executes the request in the agreed order post consensus [16],
[17]. As a result, there are no costs associated with spawning
executors and waiting for veriﬁer to validate the requests.
In these experiments, we also gauge how the shim scales
with an increase in the number of edge devices. For this
purpose, we vary the number of shim nodes from 4 to 128. We
use Figure 7 to illustrate the throughput and latency metrics
and observe the following order for throughput attained:
SERVERLESSBFT < PBFT < SERVERLESSCFT < NOSHIM
NOSHIM has a constant throughput because there is no change
in the number of shim nodes. Moreover, PBFT performs
slightly better than our SERVERLESSBFT protocol. This im-
plies that the veriﬁer and executors do not adversely impact the
throughput of PBFT. Finally, SERVERLESSCFT outperforms
PBFT, which implies that the throughput of the serverless-
edge architecture can be increased by replacing PBFT with
faster consensus protocols. Summary: SERVERLESSBFT and
SERVERLESSCFT achieve up to 22% less throughput and
1.25× more throughput than PBFT, respectively.
I. Impact of Task Ofﬂoading
We use Figure 8 to illustrate the beneﬁts of employing our
serverless-edge model. Speciﬁcally, we introduce compute-
intensive tasks (increasing execution time) and compare the
peak throughput and monetary costs against setups where all
the computations (PBFT consensus and transaction execution)
are done on the edge devices (no serverless). For this ex-
periment, we compare our SERVBFT-32 with 3 serverless
executors against a PBFT shim with 32 nodes.
We make two observations: (1) If transactions can be exe-
cuted in parallel, our serverless-edge model is only bounded
by the rate of consensus and the number of executors that
can be spawned in parallel. This is in contrast to setups where
shim performs all tasks and becomes resource-bounded, which
adversely decreases the throughput. To further validate this
resource-boundedness, we calculate monetary costs of these
experiments (in cents/ktxn) and use the precise costs for

---

spawning serverless executors at AWS Lambda and running
machines on OCI. Resource-boundedness increases monetary
costs as machines need to be run for a larger period of
time to complete the same set of transactions. (2) Serverless
clouds permit selecting optimal hardware. To illustrate this, for
experiments where shim does all tasks, we vary the number of
execution threads (ET) at shim nodes (1, 8, 16). If the available
hardware has few cores, then a smaller set of transactions
(1 or 8) can execute in parallel, which impacts throughput.
Alternatively, an enterprise can require edge devices to have
more cores (16), which may be underutilized if there is less
available parallelism.
X. RELATED WORK
Edge computing is a decade old problem for which prior
works have presented several interesting solutions [62], [63],
[64], [65], [66]. These solutions aim to reduce latency for
edge applications, but they cannot handle byzantine attacks
and require developers to perform managerial tasks.
In recent years, Serverless computing has also gained a lot
of interest with the aim of ofﬂoading the managerial tasks
such as server provisioning and resource scaling to the cloud
provider while the developer only uploads the code required
to be executed [15], [38]. Prior works have presented novel
solutions in this direction: AFT [14] introduces a shim to make
stateful executors consistent; and Faasm [67] aims to design
efﬁcient stateful executors. However, neither these works target
edge applications, nor they consider byzantine attacks.
To design applications that can handle byzantine attacks,
existing works have employed Byzantine Fault-Tolerant con-
sensus protocols in the context of blockchain technology [19],
[46], [68], [69], [70], [71], [72], [73], [74], [75], [76]. These
applications assume that a set of nodes holding the same data
run a BFT protocol. Each committed transaction is noted in an
append-only ledger, blockchain, which can be queried in future
to track transactions. EdgeChain [4] introduces a blockchain
layer in the edge-compute model, which allocates the resources
to edge devices. However, it does not tackle byzantine attacks
from edge-clouds. Bajoudah et al [77] introduce a blockchain-
based edge model where IOT devices maintain the blockchain.
Blockene [78] wants to allow mobile devices to participate in
blockchain consensus by delegating all the storage, computa-
tion, and communication tasks to a set of powerful servers.
Aslanpur et al. [79] present the vision of a serverless-
edge framework. Their proposal does not assign tasks to edge
devices and delegates all jobs to the serverless cloud. Further,
there is no discussion on handling byzantine failures. More-
over, their vision is neither implemented nor does their paper
present any evaluation. Baresi et al. [80] present a similar
design, but their design focusses on mobile computing. They
do present a small evaluation of their design, but neither is
their code available, nor do they make use of actual serverless
cloud providers (like AWS). Their design delegates everything
to the mobile edge servers (where they create a serverless
cloud) and does not handle byzantine failures. Our NoShim
experiment (Figure 7) approximates their architecture.
In
comparison,
our
serverless-edge
co-design
handles
byzantine attacks, permits edge devices to select any serverless
provider in vicinity, ofﬂoads compute-intensive tasks to cloud
while allowing light-weight ordering on edge devices.
XI. CONCLUSIONS
In this paper, we presented SERVERLESSBFT, the ﬁrst
protocol to guarantee Byzantine Fault-Tolerant transactional
ﬂow among edge devices and serverless functions. SERVER-
LESSBFT facilitates collaboration among edge devices, which
spawn serverless executors at one or more cloud providers
in their vicinity to process compute-intensive operations. Our
proposed architecture ensures that only consistent updates are
written to the database. We also present solutions to resolve
various attacks on our proposed architecture. Our extensive
evaluation illustrates that our architecture is scalable and is a
good ﬁt for the emerging edge applications.
ACKNOWLEDGMENTS
We would like to thank anonymous reviewers who helped
improve this paper. This work was supported in part by (1)
Oracle Cloud Credits & Research Program, and (2) the NSF
STTR Award #2112345 through Moka Blox LLC.
REFERENCES
[1] I. Stoica and S. Shenker, “From Cloud Computing to Sky Computing,”
in Proceedings of the Workshop on Hot Topics in Operating Systems,
ser. HotOS ’21.
New York, NY, USA: Association for Computing
Machinery, 2021, p. 26–32.
[2] S. Chasins, A. Cheung, N. Crooks, A. Ghodsi, K. Goldberg, J. E.
Gonzalez, J. M. Hellerstein, M. I. Jordan, A. D. Joseph, M. W. Mahoney,
A. Parameswaran, D. Patterson, R. A. Popa, K. Sen, S. Shenker, D. Song,
and I. Stoica, “The Sky Above The Clouds,” 2022.
[3] Cisco, “Cisco Annual Internet Report (2018–2023),” 2020. [Online].
Available: https://www.cisco.com/c/en/us/solutions/collateral/executive-
perspectives/annual-internet-report/white-paper-c11-741490.html
[4] J. Pan, J. Wang, A. Hester, I. Alqerm, Y. Liu, and Y. Zhao, “Edgechain:
An edge-iot framework and prototype based on blockchain and smart
contracts,” IEEE Internet of Things Journal, vol. 6, no. 3, pp. 4719–
4732, 2019.
[5] X. Chen, H. Song, J. Jiang, C. Ruan, C. Li, S. Wang, G. Zhang,
R. Cheng, and H. Cui, “Achieving low tail-latency and high scalability
for serializable transactions in edge computing,” in EuroSys ’21: Six-
teenth European Conference on Computer Systems.
ACM, 2021, pp.
210–227.
[6] D. O’Keeffe, T. Salonidis, and P. R. Pietzuch, “Frontier: Resilient edge
processing for the internet of things,” Proc. VLDB Endow., vol. 11,
no. 10, pp. 1178–1191, 2018.
[7] J. Pan, L. Ma, R. Ravindran, and P. TalebiFard, “Homecloud: An edge
cloud framework and testbed for new application delivery,” in 23rd In-
ternational Conference on Telecommunications, ICT 2016, Thessaloniki,
Greece, May 16-18, 2016.
IEEE, 2016, pp. 1–6.
[8] M. Satyanarayanan, P. Bahl, R. Caceres, and N. Davies, “The case for
vm-based cloudlets in mobile computing,” IEEE Pervasive Computing,
vol. 8, no. 4, pp. 14–23, 2009.
[9] R. Bhardwaj, Z. Xia, G. Ananthanarayanan, J. Jiang, Y. Shu, N. Kar-
ianakis, K. Hsieh, P. Bahl, and I. Stoica, “Ekya: Continuous learning
of video analytics models on edge compute servers,” in 19th USENIX
Symposium on Networked Systems Design and Implementation (NSDI
22).
Renton, WA: USENIX Association, Apr. 2022, pp. 119–135.
[10] M. S. Aslanpour, A. N. Toosi, R. Gaire, and M. A. Cheema, “Wattedge:
A holistic approach for empirical energy measurements in edge com-
puting,” in Service-Oriented Computing - 19th International Conference,
ICSOC, ser. Lecture Notes in Computer Science, vol. 13121.
Springer,
2021, pp. 531–547.

---

[11] S. Martin, “Flying high again: Airplane turnarounds take a spin with
ai,” 2018. [Online]. Available: https://blogs.nvidia.com/blog/2018/12/
21/airplane-turnarounds-gpu-ai-assaia/
[12] M.
Froese,
“How
the
industrial
internet
of
things
is
beneﬁting
wind
operators,”
2019.
[Online].
Available: https://www.windpowerengineering.com/how-the-industrial-
internet-of-things-is-beneﬁting-wind-operators/
[13] OneTrust, “French Government Announce National Strategy for Cloud
Technology,” 2021. [Online]. Available: https://www.onetrust.com/blog/
french-government-announce-national-strategy-for-cloud-technology/
[14] V. Sreekanti, C. Wu, S. Chhatrapati, J. E. Gonzalez, J. M. Hellerstein,
and J. M. Faleiro, “A Fault-Tolerance Shim for Serverless Computing,”
in Proceedings of the Fifteenth European Conference on Computer
Systems, ser. EuroSys ’20.
New York, NY, USA: Association for
Computing Machinery, 2020.
[15] I. Baldini, P. Castro, K. Chang, P. Cheng, S. Fink, V. Ishakian,
N. Mitchell, V. Muthusamy, R. Rabbah, A. Slominski, and P. Suter,
Serverless Computing: Current Trends and Open Problems. Singapore:
Springer Singapore, 2017, pp. 1–20.
[16] M. Castro and B. Liskov, “Practical byzantine fault tolerance,” in
Proceedings of the Third Symposium on Operating Systems Design and
Implementation.
USA: USENIX, 1999, pp. 173–186.
[17] S. Gupta, S. Rahnama, J. Hellings, and M. Sadoghi, “ResilientDB:
Global scale resilient blockchain fabric,” Proc. VLDB Endow., vol. 13,
no. 6, pp. 868–883, 2020.
[18] H. Dang, T. T. A. Dinh, D. Loghin, E.-C. Chang, Q. Lin, and B. C. Ooi,
“Towards scaling blockchain systems via sharding,” in Proceedings of
the 2019 International Conference on Management of Data.
ACM,
2019, pp. 123–140.
[19] M. J. Amiri, D. Agrawal, and A. El Abbadi, SharPer: Sharding Per-
missioned Blockchains Over Network Clusters.
New York, NY, USA:
Association for Computing Machinery, 2021, p. 76–88.
[20] S. Rahnama, S. Gupta, R. Sogani, D. Krishnan, and M. Sadoghi, “Ring-
BFT: Resilient Consensus over Sharded Ring Topology,” in Proceedings
of the 25th International Conference on Extending Database Technology,
EDBT.
OpenProceedings.org, 2022, pp. 2:298–2:311.
[21] A. Clement, M. Kapritsos, S. Lee, Y. Wang, L. Alvisi, M. Dahlin, and
T. Riche, “Upright cluster services,” in Proceedings of the ACM SIGOPS
22nd Symposium on Operating Systems Principles.
ACM, 2009, pp.
277–290.
[22] P. H. Hochschild, P. Turner, J. C. Mogul, R. Govindaraju, P. Ran-
ganathan, D. E. Culler, and A. Vahdat, “Cores that don’t count,” in
Proceedings of the Workshop on Hot Topics in Operating Systems. New
York, NY, USA: Association for Computing Machinery, 2021, p. 9–16.
[23] K. Shvachko, H. Kuang, S. Radia, and R. Chansler, “The hadoop
distributed ﬁle system,” in IEEE 26th Symposium on Mass Storage
Systems and Technologies (MSST), 2010, pp. 1–10.
[24] K. Kashyap, “92% of Companies Say On-Premises Software Sales Are
Growing: Dimensional Research Report,” 2021. [Online]. Available:
https://www.spiceworks.com/tech/enterprise-software/news/92-of-
companies-say-on-premises-software-sales-are-growing-dimensional-
research-report/
[25] N.
Eide,
“On-premise
servers
persist
in
98%
of
busi-
nesses,
even
with
cloud
hype,”
2019.
[Online].
Avail-
able:
https://www.ciodive.com/news/on-premise-servers-persist-in-98-
of-businesses-even-with-cloud-hype/549643/
[26] S. Gupta, J. Hellings, and M. Sadoghi, “RCC: Resilient Concurrent
Consensus for High-Throughput Secure Transaction Processing,” in 37th
IEEE International Conference on Data Engineering.
IEEE, 2021, pp.
1392–1403.
[27] S. Gupta, S. Rahnama, and M. Sadoghi, “Permissioned blockchain
through the looking glass: Architectural and implementation lessons
learned,” in Proceedings of the 40th IEEE International Conference on
Distributed Computing Systems, 2020.
[28] S. Gupta, J. Hellings, and M. Sadoghi, Fault-Tolerant Distributed Trans-
actions on Blockchain, ser. Synthesis Lectures on Data Management.
Morgan & Claypool Publishers, 2021.
[29] S. Gupta, S. Rahnama, S. Pandey, N. Crooks, and M. Sadoghi, “Dis-
secting BFT Consensus: In Trusted Components we Trust!” CoRR, vol.
abs/2202.01354, 2022.
[30] Amazon Staff, “Amazon Prime Air prepares for drone deliveries,” 2022.
[Online]. Available: https://www.aboutamazon.com/news/transportation/
amazon-prime-air-prepares-for-drone-deliveries
[31] J. C. Corbett, J. Dean, M. Epstein, A. Fikes, C. Frost, J. Furman,
S. Ghemawat, A. Gubarev, C. Heiser, P. Hochschild, W. Hsieh, S. Kan-
thak, E. Kogan, H. Li, A. Lloyd, S. Melnik, D. Mwaura, D. Nagle,
S. Quinlan, R. Rao, L. Rolig, Y. Saito, M. Szymaniak, C. Taylor,
R. Wang, and D. Woodford, “Spanner: Google’s Globally-Distributed
Database,” in 10th USENIX Symposium on Operating Systems Design
and Implementation (OSDI 12).
USENIX Association, 2012, pp. 261–
264.
[32] L. Lamport, “The part-time parliament,” 1998.
[33] D. Ongaro and J. Ousterhout, “In search of an understandable consensus
algorithm,” in ATC, 2014.
[34] Cloudﬂare, “A byzantine failure in the real world,” 2020. [Online]. Avail-
able: https://blog.cloudﬂare.com/a-byzantine-failure-in-the-real-world/
[35] J. Katz and Y. Lindell, Introduction to Modern Cryptography, 2nd ed.,
2014.
[36] S. Capkun, L. Buttyan, and J.-P. Hubaux, “Self-organized public-key
management for mobile ad hoc networks,” IEEE Transactions on Mobile
Computing, vol. 2, no. 1, pp. 52–64, 2003.
[37] S. Gupta and M. Sadoghi, “Blockchain transaction processing,” in
Encyclopedia of Big Data Technologies.
Springer, 2019, pp. 1–11.
[38] E. Jonas, J. Schleier-Smith, V. Sreekanti, C.-C. Tsai, A. Khandelwal,
Q. Pu, V. Shankar, J. Carreira, K. Krauth, N. Yadwadkar, J. E. Gonzalez,
R. A. Popa, I. Stoica, and D. A. Patterson, “Cloud Programming
Simpliﬁed: A Berkeley View on Serverless Computing,” 2019.
[39] J. Yin, J.-P. Martin, A. Venkataramani, L. Alvisi, and M. Dahlin, “Sepa-
rating Agreement from Execution for Byzantine Fault Tolerant Services,”
in Proceedings of the Nineteenth ACM Symposium on Operating Systems
Principles, ser. SOSP ’03, 2003, p. 253–267.
[40] S. Gupta, J. Hellings, S. Rahnama, and M. Sadoghi, “Proof-of-
Execution: Reaching consensus through fault-tolerant speculation,”
in Proceedings of the 24th International Conference on Extending
Database Technology, 2021.
[41] G. Golan Gueta, I. Abraham, S. Grossman, D. Malkhi, B. Pinkas, M. Re-
iter, D.-A. Seredinschi, O. Tamir, and A. Tomescu, “SBFT: A scalable
and decentralized trust infrastructure,” in 2019 49th Annual IEEE/IFIP
International Conference on Dependable Systems and Networks (DSN).
IEEE, 2019, pp. 568–580.
[42] G. McGrath and P. R. Brenner, “Serverless Computing: Design, Imple-
mentation, and Performance,” in 2017 IEEE 37th International Confer-
ence on Distributed Computing Systems Workshops (ICDCSW), 2017,
pp. 405–410.
[43] R. Kotla, L. Alvisi, M. Dahlin, A. Clement, and E. Wong, “Zyzzyva:
Speculative byzantine fault tolerance,” SIGOPS Oper. Syst. Rev., vol. 41,
no. 6, pp. 45–58, 2007.
[44] M. T. ¨Ozsu and P. Valduriez, Principles of Distributed Database Systems.
Springer, 2020.
[45] R. Neiheiser, M. Matos, and L. Rodrigues, “Kauri: Scalable BFT
Consensus with Pipelined Tree-Based Dissemination and Aggregation,”
in Proceedings of the ACM SIGOPS 28th Symposium on Operating
Systems Principles, ser. SOSP ’21.
New York, NY, USA: Association
for Computing Machinery, 2021, p. 35–48.
[46] F. Suri-Payer, M. Burke, Z. Wang, Y. Zhang, L. Alvisi, and N. Crooks,
“Basil: Breaking up bft with acid (transactions),” in Proceedings of
the ACM SIGOPS 28th Symposium on Operating Systems Principles,
ser. SOSP ’21.
New York, NY, USA: Association for Computing
Machinery, 2021, p. 1–17.
[47] A. Thomson, T. Diamond, S.-C. Weng, K. Ren, P. Shao, and D. J.
Abadi, “Calvin: Fast Distributed Transactions for Partitioned Database
Systems,” in Proceedings of the 2012 ACM SIGMOD International
Conference on Management of Data, ser. SIGMOD.
ACM, 2012, pp.
1–12.
[48] R. Harding, D. Van Aken, A. Pavlo, and M. Stonebraker, “An Evaluation
of Distributed Concurrency Control,” Proc. VLDB Endow., vol. 10, no. 5,
pp. 553–564, 2017.
[49] T. Qadah, S. Gupta, and M. Sadoghi, “Q-Store: Distributed, Multi-
partition Transactions via Queue-oriented Execution and Communica-
tion,” in Proceedings of the 23rd International Conference on Extending
Database Technology.
OpenProceedings.org, 2020, pp. 73–84.
[50] T. M. Qadah and M. Sadoghi, “QueCC: A queue-oriented, control-free
concurrency architecture,” ser. Middleware, 2018.
[51] M. Kapritsos, Y. Wang, V. Quema, A. Clement, L. Alvisi, and M. Dahlin,
“All about Eve: Execute-Verify Replication for Multi-Core Servers,”
in Proceedings of the 10th USENIX Conference on Operating Systems

---

Design and Implementation, ser. OSDI’12. USENIX Association, 2012,
p. 237–250.
[52] S. Rahnama, S. Gupta, T. Qadah, J. Hellings, and M. Sadoghi, “Scalable,
resilient and conﬁgurable permissioned blockchain fabric,” Proc. VLDB
Endow., vol. 13, no. 12, pp. 2893–2896, 2020.
[53] S. Gupta, J. Hellings, S. Rahnama, and M. Sadoghi, “Building high
throughput permissioned blockchain fabrics: Challenges and opportuni-
ties,” Proc. VLDB Endow., vol. 13, no. 12, pp. 3441–3444, 2020.
[54] G. D’Amore, “NNG Reference Manual,” 2018.
[55] A. A. Donovan and B. W. Kernighan, The Go programming language.
Addison-Wesley Professional, 2015.
[56] The Crypto++ community, “Crypto++ library 8.1,” 2019. [Online].
Available: https://www.cryptopp.com/
[57] F. Sauter and K. Traub, C++ Requests: Curl for People, 2021. [Online].
Available: https://docs.libcpr.org/
[58] T. T. A. Dinh, J. Wang, G. Chen, R. Liu, B. C. Ooi, and K.-L. Tan,
“BLOCKBENCH: A framework for analyzing private blockchains,” in
Proceedings of the 2017 ACM International Conference on Management
of Data.
ACM, 2017, pp. 1085–1100.
[59] B. F. Cooper, A. Silberstein, E. Tam, R. Ramakrishnan, and R. Sears,
“Benchmarking cloud serving systems with YCSB,” in Proceedings of
the 1st ACM Symposium on Cloud Computing.
ACM, 2010, pp. 143–
154.
[60] S. Gupta and M. Sadoghi, “EasyCommit: A non-blocking two-phase
commit protocol,” ser. EDBT, 2018.
[61] E. Androulaki, A. Barger, V. Bortnikov, C. Cachin, K. Christidis,
A. De Caro, D. Enyeart, C. Ferris, G. Laventman, Y. Manevich,
S. Muralidharan, C. Murthy, B. Nguyen, M. Sethi, G. Singh, K. Smith,
A. Sorniotti, C. Stathakopoulou, M. Vukoli´c, S. W. Cocco, and J. Yellick,
“Hyperledger Fabric: A Distributed Operating System for Permissioned
Blockchains,” in Proceedings of the Thirteenth EuroSys Conference,
ser. EuroSys ’18.
New York, NY, USA: Association for Computing
Machinery, 2018.
[62] J. Yang, T. Qian, F. Zhang, and S. U. Khan, “Real-time facial expression
recognition based on edge computing,” IEEE Access, vol. 9, pp. 76 178–
76 190, 2021.
[63] X. Zhang, S. Huang, H. Dong, and Z. Bao, “Edge node placement
with minimum costs: When user tolerance on service delay matters,” in
Service-Oriented Computing - 19th International Conference, ICSOC,
ser. Lecture Notes in Computer Science, vol. 13121.
Springer, 2021,
pp. 765–772.
[64] F. Nawab, D. Agrawal, and A. E. Abbadi, “Nomadic datacenters at the
network edge: Data management challenges for the cloud with mobile
infrastructure,” in Proceedings of the 21st International Conference on
Extending Database Technology. OpenProceedings.org, 2018, pp. 497–
500.
[65] D. Wu, H. Xu, Z. Jiang, W. Yu, X. Wei, and J. Lu, “Edgelstm: Towards
deep and sequential edge computing for iot applications,” IEEE/ACM
Trans. Netw., vol. 29, no. 4, pp. 1895–1908, 2021.
[66] S. Gazzaz, V. Chakraborty, and F. Nawab, “Croesus: Multi-stage pro-
cessing and transactions for video-analytics in edge-cloud systems,” in
38th IEEE International Conference on Data Engineering, ICDE. IEEE,
2022, pp. 1463–1476.
[67] S. Shillaker and P. R. Pietzuch, “Faasm: Lightweight isolation for efﬁ-
cient stateful serverless computing,” in 2020 USENIX Annual Technical
Conference, USENIX ATC, A. Gavrilovska and E. Zadok, Eds. USENIX
Association, 2020, pp. 419–433.
[68] S. Agrawal and K. Daudjee, “A Performance Comparison of Algorithms
for Byzantine Agreement in Distributed Systems,” in 12th European
Dependable Computing Conference, EDCC.
IEEE Computer Society,
2016, pp. 249–260.
[69] M. El-Hindi, C. Binnig, A. Arasu, D. Kossmann, and R. Ramamurthy,
“BlockchainDB: A shared database on blockchains,” Proc. VLDB En-
dow., vol. 12, no. 11, pp. 1597–1609, 2019.
[70] V. Zakhary, D. Agrawal, and A. E. Abbadi, “Atomic commitment across
blockchains,” Proc. VLDB Endow., vol. 13, no. 9, pp. 1319–1331, 2020.
[71] M. J. Amiri, S. Maiyya, D. Agrawal, and A. E. Abbadi, “Seemore:
A fault-tolerant protocol for hybrid cloud environments,” in 36th IEEE
International Conference on Data Engineering, ICDE 2020, Dallas, TX,
USA, April 20-24, 2020.
IEEE, 2020, pp. 1345–1356.
[72] S. Maiyya, D. H. B. Cho, D. Agrawal, and A. E. Abbadi, “Fides:
Managing data on untrusted infrastructure,” in 40th IEEE International
Conference on Distributed Computing Systems, ICDCS 2020, Singapore,
November 29 - December 1, 2020.
IEEE, 2020, pp. 344–354.
[73] G. Zhang, F. Pan, M. Dang’ana, Y. Mao, S. Motepalli, S. Zhang,
and H. Jacobsen, “Reaching consensus in the byzantine empire: A
comprehensive review of BFT consensus algorithms,” CoRR, vol.
abs/2204.03181, 2022.
[74] G. Danezis, L. Kokoris-Kogias, A. Sonnino, and A. Spiegelman, “Nar-
whal and tusk: a dag-based mempool and efﬁcient BFT consensus,” in
EuroSys ’22: Seventeenth European Conference on Computer Systems.
ACM, 2022, pp. 34–50.
[75] J. A. Chacko, R. Mayer, and H.-A. Jacobsen, “Why do my blockchain
transactions fail? a study of hyperledger fabric,” in Proceedings of the
2021 International Conference on Management of Data, ser. SIGMOD
’21.
New York, NY, USA: Association for Computing Machinery,
2021, p. 221–234.
[76] J.
Chen,
S.
Gupta,
S.
Rahnama,
and
M.
Sadoghi,
“Power-of-
Collaboration: A Sustainable Resilient Ledger Built Democratically,”
IEEE Data Eng. Bull., vol. 45, no. 2, pp. 25–36, 2022.
[77] S. Bajoudah, C. Dong, and P. Missier, “Toward a decentralized, trust-
less marketplace for brokered iot data trading using blockchain,” in IEEE
International Conference on Blockchain, Blockchain 2019, Atlanta, GA,
USA, July 14-17, 2019.
IEEE, 2019, pp. 339–346.
[78] S. Satija, A. Mehra, S. Singanamalla, K. Grover, M. Sivathanu, N. Chan-
dran, D. Gupta, and S. Lokam, “Blockene: A high-throughput blockchain
over mobile devices,” in 14th USENIX Symposium on Operating Systems
Design and Implementation (OSDI 20).
USENIX Association, Nov.
2020, pp. 567–582.
[79] M. S. Aslanpour, A. N. Toosi, C. Cicconetti, B. Javadi, P. Sbarski,
D. Taibi, M. Assuncao, S. S. Gill, R. Gaire, and S. Dustdar, “Serverless
edge computing: Vision and challenges,” in 2021 Australasian Computer
Science Week Multiconference, ser. ACSW ’21.
New York, NY, USA:
Association for Computing Machinery, 2021.
[80] L. Baresi, D. Filgueira Mendonc¸a, and M. Garriga, “Empowering low-
latency applications through a serverless edge computing architecture,”
in Service-Oriented and Cloud Computing, F. De Paoli, S. Schulte, and
E. Broch Johnsen, Eds. Cham: Springer International Publishing, 2017,
pp. 196–210.

---

