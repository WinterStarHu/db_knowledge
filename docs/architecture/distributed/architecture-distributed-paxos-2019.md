arXiv:1902.06776v1  [cs.DC]  18 Feb 2019 A Generalised Solution to Distributed Consensus Heidi Howard, Richard Mortier University of Cambridge first.last@cl.cam.ac.uk Abstract Distributed consensus, the ability to reach agreement in the face of failures and asynchrony, is a fundamental primitive for constructing reliable distributed systems from unreliable components.
The Paxos algorithm is synonymous with distributed consensus, yet it performs poorly in practice and is famously difficult to understand.
In this paper, we re-examine the foundations of distributed consensus. We derive an abstract solution to consensus, which utilises immutable state for intuitive reasoning about safety. We prove that our abstract solution generalises over Paxos as well as the Fast Paxos and Flexible Paxos algorithms. The surprising result of this analysis is a substantial weakening to the quorum requirements of these widely studied algorithms.
1 Introduction We depend upon distributed systems, yet the computers and networks that make up these systems are asynchronous and unreliable. The longstanding problem of distributed consensus formalises how to reliably reach agreement in such systems.
When solved, we become able to construct strongly consistent distributed systems from unreliable components [13, 21, 4, 17].
Lamport’s Paxos algorithm [14] is widely deployed in production to solve distributed consensus [5, 6], and experience with it has led to extensive research to improve its performance and our understanding but, despite its popularity, both remain problematic.
Paxos performs poorly in practice because its use of majorities means that each decision re- quires a round trip to many participants, thus placing substantial load on each participant and the network connecting them. As a result, systems are typically limited in practice to just three or five participants. Furthermore, Paxos is usually implemented in the form of Multi-Paxos, which establishes one participant as the master, introducing a performance bottleneck and increasing latency as all decisions are forwarded via the master. Given these limitations, many production systems often opt to sacrifice strong consistency guarantees in favour of performance and high availability [7, 3, 18]. Whilst compromise is inevitable in practical distributed systems [10], Paxos offers just one point in the space of possible trade-offs. In response, this paper aims to improve performance by offering a generalised solution allowing engineers the flexibility to choose their own trade-offs according to the needs of their particular application and deployment environment.
Paxos is also notoriously difficult to understand, leading to much follow up work, explaining the algorithm in simpler terms [20, 15, 19, 23] and filling the gaps in the original description, necessary for constructing practical systems [6, 2]. In recent years, immutability has been increasingly widely utilised in distributed systems to tame complexity [11]. Examples such as append-only log stores [1, 8] and CRDTs [22] have inspired us to apply immutability to the problem of consensus.
1

---

This paper re-examines the problem of distributed consensus with the aim of improving perfor- mance and understanding. We proceed as follows. Once we have defined the problem of consen- sus (§2), we propose a generalised solution to consensus that uses only immutable state to enable more intuitive reasoning about correctness (§3). We subsequently prove that both Paxos and Fast Paxos [16] are instances of our generalised consensus algorithm and thus show that both algorithms are conservative in their approach, particularly in their rules for quorum intersection and quorum agreement (§4 & §5). Finally, we conclude by illustrating the power of our abstraction by out- lining three different instances of our generalised consensus algorithm which provide alternative performance trade-offs compared to Paxos (§6).
2 Problem definition The classic formulation of consensus considers how to decide upon a single value in a distributed sys- tem. This seemingly simple problem is made non-trivial by the weak assumptions made about the underlying system: we assume only that the algorithm is correctly executed (i.e., the non-Byzantine model). We do not assume that participants are either reliable or synchronous. Participants may operate at arbitrary speeds and messages may be arbitrarily delayed.
We consider systems comprised of two types of participant: servers, which store the value, and clients, which read/write the value. Clients take as input a value to be written and produce as output the value decided by the system. Messages may only be exchanged between clients and servers and we assume that the set of participants, servers and clients, is fixed and known to the clients.
An algorithm solves consensus if it satisfies the following three requirements:
• Non-triviality. All output values must have been the input value of a client.
• Agreement. All clients that output a value must output the same value.
• Progress. All clients must eventually output a value if the system is reliable and synchronous for a sufficient period.
The progress requirement rules out algorithms that could reach deadlock.
As termination cannot be guaranteed in an asynchronous system where failures may occur [9], algorithms need only guarantee termination assuming liveness.
If we have only one server, the solution is straightforward. The server has a single persistent write-once register, R0, to store the decided value. Clients send requests to the server with their input value. If R0 is unwritten, the value received is written to R0 and is returned to the client.
If R0 is already written, then the value in R0 is read and returned to the client.
The client then outputs the returned value. This algorithm achieves consensus but requires the server to be available for clients to terminate. To overcome this limitation requires deployment of more than one server, so we now consider how to generalise to multiple servers.
3 Generalised solution Consider a set of servers, {S0, S1, . . . , Sn}, where each has a infinite series of write-once, persistent registers, {R0, R1, . . . }. Clients read and write registers on servers and, at any time, each register is in one of the three states:
• unwritten, the starting state for all registers; or • contains a value, e.g., A, B, C; or • contains nil, a special value denoted as ⊥.
2

---

Register Quorums R0 {{S0, S1, S2}} R1, R2, . . .
{{S0, S1}, {S0, S2}, {S1, S2}} (a) Register Quorums R0, R2, . . .
{{S0, S1}} R1, R3, . . .
{{S2, S3}} (b) Register Quorums R0, R1, . . .
{{S0, S1}, {S2, S3}} (c) Register Quorums R0, R1, . . .
{{S0, S1}, {S0, S2}, {S1, S2}} (d) Figure 1: Sample configurations for systems of three or four servers.
S0 S1 S2 R0 A ⊥ B R1 ⊥ ⊥ ⊥ R2 B A A (a) A decided by R2 S0 S1 S2 R0 A A A R1 A A (b) A decided by R0 & R1 S0 S1 S2 R0 A ⊥ A R1 A C ⊥ R2 C B (c) No decisions yet Figure 2: Sample state tables for a system using the configuration in Figure 1a.
A quorum, Q, is a (non-empty) subset of servers, such that if all servers have a same (non-nil) value v in the same register then v is said to be decided. A register set, i, is the set comprised of the register Ri from each server. Each register set i is configured with a set of quorums, Qi, and four example configurations are given in Figure 1. The state of all registers can be represented in a table, known as a state table, where each column represents the state of one server and each row represents a register set. By combining a configuration with a state table, we can determine whether any decision(s) have been reached, as shown in Figure 2.
3.1
Correctness Figure 3 describes a generalised solution to consensus by giving four rules governing how clients in- teract with registers to ensure that the non-triviality and agreement requirements for consensus (§2) are satisfied.
Rule 1 (quorum agreement) ensures that clients only output values that have been decided.
Rule 2 (new value) ensures that only client input values can be written to registers thus only client input values can be decided and output by clients. Rules 3 and 4 ensures that no two quorums Rule 1: Quorum agreement. A client may only output a (non-nil) value v if it has read v from a quorum of servers in the same register set.
Rule 2: New value. A client may only write a (non-nil) value v provided that either v is the client’s input value or that the client has read v from a register.
Rule 3: Current decision. A client may only write a (non-nil) value v to register r on server s provided that if v is decided in register set r by a quorum Q ∈Qr where s ∈Q then no value v′ where v̸ = v′ can also be decided in register set r.
Rule 4: Previous decisions. A client may only write a (non-nil) value v to register r provided no value v′ where v̸ = v′ can be decided by the quorums in register sets 0 to r −1.
Figure 3: The four rules for correctness.
3

---

Register Client R0, R3, . . .
C0 R1, R4, . . .
C1 R2, R5, . . .
C2 Figure 4: Sample round robin allocation of register sets to clients.
can decide upon different values. Rule 3 (current decision) ensures that all decisions made by a register set will be for the same value whilst Rule 4 (previous decisions) ensures that all decisions made by different register sets are for the same value.
3.2
Implementing the correctness rules Rules 1 and 2 are easy to implement, but Rules 3 and 4 require more careful treatment.
Rule 3 (current decision).
The simplest implementation of Rule 3 is to permit only configura- tions with one quorum per register set, as in Figure 1b. We generalise this to intersecting quorums configurations by permitting multiple quorums per register set, provided that all quorums for a given register set intersect, as in Figure 1d. The requirement for intersection ensures that if mul- tiple quorums in a register set decide a value then they must decide the same value as they must share a common register.
Alternatively, we can support disjoint quorums if we require that all values written to a given register set are the same. This can be achieved by assigning register sets to clients and requiring that clients write only to their own register sets, with at most one value. In practice, this could be implemented by using an allocation such as that in Figure 4 and by requiring clients to keep a persistent record of which register sets they have written too. We refer to these as client restricted configurations.
Both techniques, intersecting quorums configurations and client restricted configurations, can be combined on a per-register-set basis.
Rule 4 (previous decisions).
Rule 4 requires clients to ensure that, before writing a (non-nil) value, previous register sets cannot decide a different value. This is trivially satisfied for register set 0, however, more work is required by clients to satisfy this rule for subsequent register sets.
Assume each client maintains their own local copy of the state table. Initially, each client’s state table is empty as they have not yet learned anything regarding the state of the servers. A client can populate its state tables by reading registers and storing the results in its copy of the state table. Since the registers are persistent and write-once, if a register contains a value (nil or otherwise) then any reads will always remain valid. Each client’s state tables will therefore always contain a subset of the values from the state table.
From its local state table, each client can track whether decisions have been reached or could be reached by previous quorums. We refer to this as the decision table. At any given time, each quorum is in one of four decision states:
• Any: Any value could be decided by this quorum.
• Maybe v: If this quorum reaches a decision, then value v will be decided.
• Decided v: The value v has been decided by this quorum; a final state.
• None: This quorum will not decide a value; a final state.
The rules for updating the decision table are as follows: Initially, the decision state of all quorums is Any. If there is a quorum where all registers contain the same value v then its decision 4

---

A client may output value v provided at least one quorum state is Decided v (Rule 1).
A client c may write a non-nil value v to register set r provided:
i. v is c’s input value or has been read from a register (Rule 2), and ii. r is either:
• quorum intersecting, or • client restricted and r has been allocated to c but not yet used (Rule 3), and iii. the decision state of each quorum from register sets 0 to r −1 is None, Maybe v or Decided v (Rule 4).
Figure 5: Client decision table rules S0 S1 S2 S3 R0 Register Quorum Decision state R0 {S0, S1} Any (a) Initial state.
S0 S1 S2 S3 R0 R1 B Register Quorum Decision state R0 {S0, S1} Maybe B R1 {S2, S3} Maybe B (b) State after reading B from R1 on S3.
S0 S1 S2 S3 R0 A R1 B Register Quorum Decision state R0 {S0, S1} None R1 {S2, S3} Maybe B (c) State after reading A from R0 on S0.
S0 S1 S2 S3 R0 A R1 B B Register Quorum Decision state R0 {S0, S1} None R1 {S2, S3} Decided B (d) State after reading read B from R1 on S2.
Figure 6: Sample client state tables (left) and decision tables (right).
state is Decided v. When a client reads nil from register r on server s then for all quorums Q ∈Qr where s ∈Q, the decision state Any/Maybe v becomes None. When a client reads a non-nil value v from a client restricted register set r then for all quorums over register sets 0 to r, the decision state Any becomes Maybe v and Maybe v′ where v̸ = v′ becomes None. When a client reads a non-nil value v from a quorum intersecting register set r on server s then for all quorums Q ∈Qr where s ∈Q and for all quorums over register sets 0 to r −1, the state Any becomes Maybe v and Maybe v′ where v̸ = v′ becomes None.
These rules utilise the knowledge that if a client reads a (non-nil) value v from the register r on server s, it learns that:
• If r is client restricted then all quorums in r must decide v if they reach a decision (Rule 3).
• If any quorum of register sets 0 to r −1 reaches a decision then value v is decided (Rule 4).
Figure 5 describes how clients can use decision tables to implement the four rules for correctness.
3.3
Examples This process is illustrated by Figures 6 and 7, which demonstrate how a client’s state is updated as they read registers. Figure 6 shows the state of a client C0 in a system of 4 servers using the intersecting quorum configuration from Figure 1b. Figure 6a shows the client’s initial state. The 5

---

S0 S1 S2 S3 R0 Register Quorum Decision state R0 {S0, S1} Any {S2, S3} Any (a) Initial state.
S0 S1 S2 S3 R0 ⊥ Register Quorum Decision state R0 {S0, S1} None {S2, S3} Any (b) State after reading nil from R0 on S0.
S0 S1 S2 S3 R0 ⊥ ⊥ R1 B Register Quorum Decision state R0 {S0, S1} None {S2, S3} None R1 {S0, S1} Maybe B {S2, S3} Maybe B (c) State after reading nil from R0 and B from R1 on S3.
S0 S1 S2 S3 R0 ⊥ ⊥ R1 B B Register Quorum Decision state R0 {S0, S1} None {S2, S3} None R1 {S0, S1} Maybe B {S2, S3} Decided B (d) State after reading B from R1 on S2.
Figure 7: Sample client state tables (left) and decision tables (right).
client’s state table is empty thus the status of all quorums in the decision table is Any. At this time, the client may only write non-nil values to R0 due to condition (iii) in Figure 5. Next, Figure 6b, the status of quorum {S2, S3} over register set 1 is updated to Maybe B since, depending on the state of register R1 on S2, either this quorum will not reach a decision or it decides value B. Since the client that wrote B into R1 on S3 must have followed Rule 4, the quorum in R0 must decide B if it reaches a decision thus its status is updated to Maybe B. The client C0 can now write value B to R1 or R2. Subsequently in Figure 6c, the client could now safely write its input value to R1 but there would be no use in doing so. Finally in Figure 6d, the client learns that B is decided and thus can output B.
Figure 7 shows the state of a client C0 in a system using the configuration in Figure 1c and the client allocation from Figure 4. Figure 7a shows the initial state of the client C0. At this time, the client C0 can only write non-nil values to R0. Later in Figure 7c, the client has updated the status of both quorums in R1 to Maybe B after reading B from R1. This is because register set 1 is client restricted to value B.
4 Generalisation of Paxos The (unoptimised) Paxos algorithm is described in Figure 8 using only write-once registers. Figure 9 gives an example of the message exchange as two clients execute Paxos with three servers.
We observe that Paxos is a conservative instance of our generalised solution to consensus. The configuration used by Paxos is majorities for all register sets, such a configuration is given in Figure 1d. Paxos also uses client restricted for all register sets and a suitable client assignment is given in Figure 4. The purpose of phase one is to implement Rule 4 and the purpose of phase two is to implement Rule 1. Earlier (§3), we proposed client state and decision tables as a mechanism for clients to implement the rules for correctness. Upon receiving P1b(r,R) where R is the set 6

---

Phase 1 • A client c chooses a register set r that it has been assigned but not yet used and sends P1a(r) to all servers.
• Upon receiving p1a(r), each server checks if register r is unwritten. If so, any unwritten registers up to r −1 (inclusive) are set to nil. The server replies with p1b(r, S) where S is a set of all written non-nil registers.
• If c receives p1b messages from a majority of servers then c chooses the value from the greatest (non-nil) register. If no values were returned with P1b messages then c chooses its input value. c then proceeds to phase two. Otherwise, c times out and restarts phase one.
Phase 2 • c sends P2a(r, v) to all servers where v is value chosen at the end of phase one.
• Upon receiving P2a(r, v), each server checks if register r is unwritten. If so, any unwritten registers up to r−1 (inclusive) are set to to nil and register r is set to v. The server replies with P2b(r, v).
• If c receives P2b messages from the majority of servers then c learns that the value v has been decided and can output v. Otherwise, c times out and restarts phase one.
Figure 8: The Paxos algorithm using write-once registers.
C0 C1 S0 S1 P1a(0) P1b(0,{}) P1b(0,{}) P2a(0,A) P2b(0,A) P2b(0,A) P1a(1) P1b(1,{R0:A}) P1b(1,{R0:A}) P2a(1,A) P2b(1,A) P2b(1,A) Figure 9: Sample message exchange for Paxos S0 S1 S2 R0 Register Quorum Decision state R0 {S0, S1} Any {S0, S2} Any {S1, S2} Any (a) Initial state, unchanged after receiving P1b(0,{}) from S1.
S0 S1 S2 R0 A A Register Quorum Decision state R0 {S0, S1} Decided A {S0, S2} Maybe A {S1, S2} Maybe A (b) State after receiving P2b(0,A) from S1.
Figure 10: Sample client state tables (left) and decision tables (right) for client C0 during the execution in Figure 9.
7

---

S0 S1 S2 R0 A Register Quorum Decision state R0 {S0, S1} Maybe A {S0, S2} Maybe A {S1, S2} Maybe A (a) State after receiving P1b(1,{R0:A}) from S0.
S0 S1 S2 R0 A A Register Quorum Decision state R0 {S0, S1} Decided A {S0, S2} Maybe A {S1, S2} Maybe A (b) State after receiving P1b(1,{R0:A}) from S1.
Figure 11: Sample client state tables (left) and decision tables (right) for client C1 during the execution in Figure 9.
of registers from a server, the client learns the contents of registers 0 to r −1. This is because registers are always written to in-order on each server and register r must be unwritten. Therefore the client’s state table and thus its decision table can be updated accordingly. This is demonstrated in Figure 10 for client C0 and Figure 11 for client C1.
4.1
Weakened quorum intersection requirements The boolean function I tests whether two or more quorum sets are intersecting and is defined as I({Qi}) ≡∀i, ∀Qi ∈Qi : T Qi̸ = ∅.
Paxos utilises majorities as it requires all quorums, Q ∈Q, to intersect, regardless of the register set or phase of the algorithm. That is, in terms of I, I(Q, Q).
Instead, we differentiate between the quorums used for each register set and which phase of Paxos the quorum is used for. Qk r is the set of quorums for phase k of register set r. We observe that quorum intersection is required only between the phase one quorum for register set r and the phase two quorums of register sets 0 to r −1. This is the case because a client can always proceed to phase two after intersecting with all previous phase two quorums since the condition (iii) in Figure 5 will be satisfied. More formally, ∀r ∈N0, ∀r′ ∈N<r : I(Q1 r, Q2 r′).
(*) This result confirms the findings of Flexible Paxos [12]. This is illustrated in Figure 10a where the client was safe to proceed to phase two from startup since there is no intersection requirement for register set 0.
4.2
Progress without quorums Each of the two phases of Paxos waits for agreement from a quorum of servers. However, we observe that it may be possible to proceed prior to reaching quorum agreement.
A client can safely terminate once it learns that a value has been decided (Rule 1). This need not be the result of completing both phases of the algorithm. This is illustrated in Figure 11b where the client learns that value A has been decided prior to starting phase two.
Similarly, if a server learns that a register r contains a (non-nil) value v then it also learns that if any quorums from register sets 0 to r reach a decision then v must be chosen. By updating their decision table, we observe that it is no longer necessary for the client in phase one to intersect with the phase two quorums of registers up to r (inclusive). This is illustrated in Figure 11a where the client could safely proceed to phase two after one P1b message as the client reads a non-nil value from predecessor register set.
8

---

Register Quorums R0, R1, . . .
{{S0, S1, S2}, {S0, S1, S3}, {S0, S2, S3}, {S1, S2, S3}} (a) Register Quorums R0, R1, R2 {{S0, S1, S2}} R3, R4, . . .
{{S0, S1}, {S0, S2}, {S1, S2}} (b) Register Quorums R0 {{S0, S1}} R1, R2, . . .
{{S0, S1}, {S0, S2}, {S1, S2}} (c) Register Quorums R0, R1, . . . , R10 {{S0, S1}, {S0, S2}, {S1, S2}} R11, . . .
{{S3, S4}, {S3, S5}, {S4, S5}} (d) Figure 12: Additional sample configurations.
5 Generalisation of Fast Paxos Paxos requires client restricted configuration for all register sets. Fast Paxos [16] generalises Paxos by permitting intersecting quorum configurations for some register sets, known as fast sets, whilst still utilising client restricted configurations for remaining sets, known as classic sets. Quorums for classic sets must include > 1/2 of servers whereas quorums for fast sets must include ≥3/4 of servers. Figure 12a is an example of such a configuration.
Fast Paxos modifies our original Paxos algorithm (Figure 8) as follows:
• If a register set is fast then a client does not need to be assigned the register set nor do they need to ensure that they write to it with only one value. Any client can use the any fast register set.
• If the register set is fast then completion of each phase requires responses from 3/4 of servers instead of 1/2 of servers.
• When choosing a value at the end of phase one, multiple values may have been read from the same register set (if it was a fast set), in which case the client chooses the most common.
5.1
Weakened quorum intersection requirements Fast Paxos uses quorums of 3/4 of servers for fast sets and 1/2 of servers for classic sets since it requires the following intersection between quorums for fast sets, Qf and quorums for classic sets, Qc: I(Qc, Qc), and I(Qc, Qf, Qf).1 As with Paxos, these intersection requirements are conservative. We differentiate between the quorums used for each register set and which phase of the algorithm the quorum is used for. Qk r is the set of quorums for phase k of register set r. In addition to Paxos’s weakened intersection requirement (Eq. (*)), we observe that two additional quorum intersections are required: between the quorums for each fast register set, and between the phase one quorum for register set r and any pair of phase two quorums of fast register sets from 0 to r −1. Denoting the set of fast register sets as F, we express these requirements as follows:
∀r ∈F : I(Q2 r, Q2 r) and ∀r ∈N0, ∀r′ ∈F<r : I(Q1 r, Q2 r′, Q2 r′).
(**)
5.2
Progress without quorums Utilising decision tables, we observe that quorum agreement is sufficient but not necessary for a client to complete a phase of the algorithm. In particular, during the following three cases.
(i) As with Paxos, once a client learns that a quorum of registers contain a value then the client can terminate and return that value.
1Generalisation to quorums requires us to rewrite the value selection rule to chose the value which may be decided.
9

---

S0 S1 S2 S3 R0 ⊥ ⊥ Register Quorum Decision state R0 {S0, S1, S2} None {S0, S1, S3} None {S0, S2, S3} None {S1, S2, S3} None Figure 13: Sample client state table (left) and decision table (right) for client C0 during Fast Paxos.
S0 S1 S2 S3 R0 A B Register Quorum Decision state R0 {S0, S1, S2} None {S0, S1, S3} None {S0, S2, S3} Maybe A {S1, S2, S3} Maybe B Figure 14: Sample client state table (left) and decision table (right) for client C0 during Fast Paxos.
(ii) If a client learns that a register r contains a (non-nil) value v then it also learns that if any quorums from register sets 0 to r −1 reach a decision then v must be chosen. If r is a classic register set then it also learns that if any quorums from register sets r reach a decision then v must be chosen. The client therefore no longer needs to intersect with quorums 0 to r −1 if r is fast or quorums 0 to r if r is classic.
(iii) Furthermore, a client in phase one will only need to intersect with any previous two fast quorums if it is unable to determine which value to propose. Figures 13 & 14 give an example of this with the configuration from Figure 12a. According to Equation (**), the client C0 needs to read three registers from register set 0 before it can safely write to register set 1. However, in Figure 13, the client can safely write to register set 1 after reading just two registers. This is not the case in Figure 14 however.
Figure 15 summaries how these generalisation can be combined into a revised Fast Paxos algo- rithm. Note that a client can complete a phase once the completion criteria (underlined) has been satisfied even if it has not executed every step.
6 Example consensus algorithms In this section, we outline three uses of our generalisation of Paxos and Fast Paxos by utilising different configurations.
Co-located consensus. Consider a configuration which uses a quorum containing all servers for the first k register sets and majority quorums afterwards, as shown in Figure 12b. All registers sets are client restricted. Participants in a system may be deciding a value between themselves, and so a server and client are co-located on each participant. A client can therefore either achieve consensus in one round trip to all servers (if all are available) or two round trips to any majority (in case a server has failed).
Fixed-majority consensus. Consider a configuration with one majority quorum for register set 0 and majority quorums for register sets 1 onwards, as shown in Figure 12c. Register set 0 is quorum intersecting and register sets 1 onwards are client restricted. A client can either achieve consensus in one round trip to a specific majority or two round trips to any majority.
Reconfigurable consensus.
Consider a set of servers partitioned into a primary set and backup set. Consider a configuration which uses only primary servers for register set 0 to k −1 and only backup servers from register set k, as shown in Figure 12d. A client can move the systems from primary servers to backup servers by executing Paxos for register set k or greater. No subsequent 10

---

Phase 1 • A client c chooses a register set r that is either: quorum intersecting or is client restricted and has been assigned to c but not yet used. c sends P1a(r) to all servers.
• Upon receiving p1a(r), each server checks if register r is unwritten. If so, any unwritten registers up to r −1 (inclusive) are set to to nil. The server replies with p1b(r,S) where S is a set of all written registers.
• Each time c receives a P1a, it updates its state and decision tables accordingly. If the decision state of all quorums from register sets 0 to r −1 is None or Maybe v then c chooses v (or if all states are None then its input value) and proceeds to phase two. If c times out before completing phase one, it restarts phase one.
Phase 2 • c sends P2a(r,v) to all servers where v is value chosen at the end of phase one.
• Upon receiving P2a(r,v), each server checks if register r is unwritten. If so, any unwritten registers up to r −1 (inclusive) are set to nil and register r is set to v. The server replies with P2b(r,v).
• Each time c receives a P2a, it updates its state and decision tables accordingly. If the decision state of a quorum is Decided v then c outputs v. If c times out before completing phase two, it restarts phase one.
Figure 15: The Generalised Fast Paxos algorithm.
client will need a reply from a primary server to make progress whilst the backup set is available.
7 Conclusion Paxos has long been the de facto approach to reaching consensus, however, this “one size fits all” solution performs poorly in practice and is famously difficult to understand. In this paper, we have reframed the problem of distributed consensus in terms of write-once registers and thus proposed a generalised solution to distributed consensus. We have demonstrated that this solution not only unifies existing algorithms including Paxos and Fast Paxos but also demonstrates that such algorithms are conservative as their quorum intersection requirements and quorum agreement rules can be substantially weakened. We have illustrated the power of our generalised consensus algorithm by proposing three novel algorithms for consensus, demonstrating a few interesting points on the diverse array of algorithms made possible by our abstract.
Our aim is to make reasoning about correctness sufficiently intuitive that proofs are not neces- sary to make a convincing case for the safety; nonetheless, we include in Appendix A for complete- ness.
8 Acknowledgements We would like to thank Jon Crowcroft, Stephen Dolan and Martin Kleppmann for their valu- able feedback on this paper.
This work was funded in part by EPSRC EP/N028260/2 and EP/M02315X/1.
11

---

References [1] M. Balakrishnan, D. Malkhi, J. D. Davis, V. Prabhakaran, M. Wei, and T. Wobber. Corfu: A distributed shared log. ACM Trans. Comput. Syst., 31(4):10:1–10:24, Dec. 2013.
[2] W. J. Bolosky, D. Bradshaw, R. B. Haagens, N. P. Kusters, and P. Li. Paxos replicated state machines as the basis of a high-performance data store. In Proceedings of the 8th USENIX Con- ference on Networked Systems Design and Implementation, NSDI’11, pages 141–154, Berkeley, CA, USA, 2011. USENIX Association.
[3] N. Bronson, Z. Amsden, G. Cabrera, P. Chakka, P. Dimov, H. Ding, J. Ferris, A. Giardullo, S. Kulkarni, H. Li, M. Marchukov, D. Petrov, L. Puzar, Y. J. Song, and V. Venkataramani.
Tao: Facebook’s distributed data store for the social graph. In Proceedings of the 2013 USENIX Conference on Annual Technical Conference, USENIX ATC’13, pages 49–60, Berkeley, CA, USA, 2013. USENIX Association.
[4] N. Budhiraja, K. Marzullo, F. B. Schneider, and S. Toueg. Distributed systems (2nd ed.).
chapter The Primary-backup Approach, pages 199–216. ACM Press/Addison-Wesley Publish- ing Co., New York, NY, USA, 1993.
[5] M. Burrows. The chubby lock service for loosely-coupled distributed systems. In Proceedings of the 7th Symposium on Operating Systems Design and Implementation, OSDI ’06, pages 335–350, Berkeley, CA, USA, 2006. USENIX Association.
[6] T. D. Chandra, R. Griesemer, and J. Redstone. Paxos made live: An engineering perspec- tive. In Proceedings of the Twenty-sixth Annual ACM Symposium on Principles of Distributed Computing, PODC ’07, pages 398–407, New York, NY, USA, 2007. ACM.
[7] G. DeCandia, D. Hastorun, M. Jampani, G. Kakulapati, A. Lakshman, A. Pilchin, S. Sivasub- ramanian, P. Vosshall, and W. Vogels. Dynamo: Amazon’s highly available key-value store.
In Proceedings of Twenty-first ACM SIGOPS Symposium on Operating Systems Principles, SOSP ’07, pages 205–220, New York, NY, USA, 2007. ACM.
[8] Facebook. LogDevice project homepage. https://logdevice.io/. [Online; accessed 5-Oct- 2018].
[9] M. J. Fischer, N. A. Lynch, and M. S. Paterson. Impossibility of distributed consensus with one faulty process. Journal of the ACM (JACM), 32(2):374–382, 1985.
[10] S. Gilbert and N. Lynch.
Brewer’s conjecture and the feasibility of consistent, available, partition-tolerant web services. SIGACT News, 33(2):51–59, June 2002.
[11] P. Helland. Immutability changes everything. Queue, 13(9):40:101–40:125, Nov. 2015.
[12] H. Howard, D. Malkhi, and A. Spiegelman. Flexible Paxos: Quorum Intersection Revisited. In P. Fatourou, E. Jim´enez, and F. Pedone, editors, 20th International Conference on Principles of Distributed Systems (OPODIS 2016), volume 70 of Leibniz International Proceedings in Informatics (LIPIcs), pages 25:1–25:14, Dagstuhl, Germany, 2017. Schloss Dagstuhl–Leibniz- Zentrum fuer Informatik.
[13] L. Lamport.
The implementation of reliable distributed multiprocess systems.
Computer Networks (1976), 2(2):95 – 114, 1978.
12

---

[14] L. Lamport. The part-time parliament. ACM Trans. Comput. Syst., 16(2):133–169, May 1998.
[15] L. Lamport. Paxos made simple. ACM SIGACT News (Distributed Computing Column), 2001.
[16] L. Lamport. Fast paxos. Technical Report MSR-TR-2005-112, Microsoft Research, 2005.
[17] B. W. Lampson. How to build a highly available system using consensus. In Proceedings of the 10th International Workshop on Distributed Algorithms, WDAG ’96, pages 1–17, London, UK, UK, 1996. Springer-Verlag.
[18] H. Lu, K. Veeraraghavan, P. Ajoux, J. Hunt, Y. J. Song, W. Tobagus, S. Kumar, and W. Lloyd.
Existential consistency: Measuring and understanding consistency at facebook. In Proceedings of the 25th Symposium on Operating Systems Principles, SOSP ’15, pages 295–310, New York, NY, USA, 2015. ACM.
[19] D. Ongaro and J. Ousterhout. In search of an understandable consensus algorithm. In Proc.
USENIX Annual Technical Conference, pages 305–320, 2014.
[20] R. D. Prisco, B. W. Lampson, and N. A. Lynch. Revisiting the paxos algorithm. In Proceedings of the 11th International Workshop on Distributed Algorithms, WDAG ’97, pages 111–125, London, UK, UK, 1997. Springer-Verlag.
[21] F. B. Schneider. Implementing fault-tolerant services using the state machine approach: A tutorial. ACM Comput. Surv., 22(4):299–319, Dec. 1990.
[22] M. Shapiro, N. Pregui¸ca, C. B. Moreno, and M. Zawirsky. Conflict-free replicated data types.
page 386–400, July 2011.
[23] R. Van Renesse and D. Altinbuken. Paxos made moderately complex. ACM Comput. Surv., 47(3):42:1–42:36, Feb. 2015.
13

---

Appendices A Proofs of safety In this appendix, we provide proofs for the safety properties (non-triviality, agreement) of our proposed algorithms for solving consensus.
A.1 Four correctness rules Figure 3 proposed four rules which we claim are sufficient to satisfy the non-triviality and agreement requirements of distributed consensus (§2). We now consider each requirement in turn. We will use s[r] = v to denote that the value v is in register r on server s.
Theorem A.1 (Satisfying non-triviality). If a value v is the output of a client c then v was the input of some client c′.
Proof.
Assume v was the output of client c.
According to Rule 1, ∃r ∈N0, ∃Q ∈Qr, ∀s ∈Q : s[r] = v therefore at least one register contains v.
Consider the invariant that all (non-nil) registers contain client input values.
Initially, all registers are unwritten thus this invariant holds. According to Rule 2, each client will only write either their input value or a value copied from another register, thus the invariant will be preserved.
Theorem A.2 (Satisfying agreement). If two clients, c and c′, output values, v and v′ (respec- tively), then v = v′.
Proof.
Assume that value v was the output of client c. Assume that value v′ was the output of client c′.
According to Rule 1, the following must be true:
∃r ∈N0, ∃Q ∈Qr, ∀s ∈Q : s[r] = v ∃r′ ∈N0, ∃Q′ ∈Q′ r, ∀s′ ∈Q′ : s′[r′] = v′ Since register sets are totally ordered, it must be the case that either r = r′, r < r′ or r > r′:
Case r = r′:
Both decisions are in the same register set. It is either the case that both clients have read from the same quorum or they have read from different quorums.
Case Q = Q′:
Each quorum can decide at most one value thus v = v′ Case Q̸ = Q′:
According to Rule 3, since Q has decided v, each client who wrote a register in Q must have ensured that no other quorum in register set r can reach a different decisions. Thus v = v′.
Case r < r′:
According to Rule 4, a client will only write v to register set r′ after ensuring no quorum in register set r will reach a different decision. Thus v = v′.
14

---

Case r > r′:
This is the same as r < r′ with r and r′ swapped. Thus v = v′.
A.2 Client decision table rules We have shown that the four rules for correctness are sufficient to satisfy the non-triviality and agreement requirements of consensus. We will now show that the client decision table rules (Fig- ure 5) implement the four rules for correctness (Figure 3) and thus satisfies the non-triviality and agreement requirements of consensus.
Theorem A.3 (Satisfying Rule 1). If the value v is the output of client c then c has read v from a quorum Q ∈Qr in register set r.
Proof.
Assume the value v is the output of client c. There must exist a register set r and quorum Q ∈Qr in the decision table of c with the status Decided v (Figure 5). A quorum Q can only reach decision state Decided v if ∀s ∈Q : s[r] = v.
Theorem A.4 (Satisfying Rule 2). If the value v is written by a client c then either v is c’s input value or v has been read from some register.
Proof.
Assume the value v has been written by client c. According to Figure 5, v must be either the input value of c or read from some register.
Theorem A.5 (Satisfying Rule 3). If the values v and v′ are decided in register set r then v = v′.
Proof.
Assume the value v is decided in register set r by quorum Q ∈Qr, thus ∀s ∈Q : s[r] = v.
Assume the value v′ is decided in register set r by quorum Q′ ∈Qr, thus ∀s ∈Q′ : s[r] = v′.
The register set r either uses intersecting quorums or client restricted configuration.
Case r is client restricted:
Each client is assigned a disjoint subset of register sets thus at most one client is assigned r.
A client will only write a (non-nil) value to r if they have been assigned it and not yet written to it (Figure 5). The register set r will therefore only contain one (non-nil) value thus v = v′.
Case r has intersecting quorums:
This requires that there exists a server s such that s ∈Q and s ∈Q′. We require that both s[r] = v and s[r] = v′, thus v = v′.
Theorem A.6 (Satisfying Rule 4). If the value v is decided in register set r and the (non-nil) value v′ is written to register set r′ where r < r′ then v = v′ We will prove this by induction over the writes to register sets > r.
Theorem A.7 (Satisfying Rule 4 - Base case). If the value v is decided in register set r then the first (non-nil) value to be written to a register set r′ where r < r′ is v.
15

---

Proof.
Assume the value v is decided in register set r by quorum Q ∈Qr thus ∀s ∈Q : s[r] = v. Since registers are write once, the following always holds true: ∀s ∈Q : s[r] = v ∨s[r] = unwritten.
Assume the value v′ is written to register set r′ by client c where r < r′. Assume that v′ is the first value to be written thus c cannot read any (non-nil) values from registers > r before writing v′.
We will show that v = v′.
Consider the decision table of client c when it is writing to r′. Since r < r′, the decision state of Q must be either None, Maybe v′ or Decided v′ (Figure 5).
Case Decided v′:
This decision state requires that ∀s ∈Q : s[r] = v′. Since we know that ∀s ∈Q : s[r] = v ∨unwritten then v = v′.
Case Maybe v′:
The decision state Maybe v′ can be reached in one of three ways:
Case c read v′ from register r of some server s ∈Q: Since we know that ∀s ∈Q : s[r] = v ∨unwritten then v = v′.
Case r is client restricted and c read v′ from register r of some server s Since we know that ∀s ∈Q : s[r] = v ∨unwritten then v = v′.
Case c read v′ from a register > r: Since v′ is the first value to be written to a register > r, this case cannot occur.
Case None:
The decision state None can be reached in one of five ways:
Case c read nil from register r of some server s ∈Q:
Since ∀s ∈Q : s[r] = v ∨unwritten, this case cannot occur.
Case c read two different values from two servers, s, s′ ∈Q:
Since ∀s ∈Q : s[r] = v ∨unwritten, this case cannot occur.
Case c read two different values from registers > r:
Since v′ is the first value to be written to a register > r, this case cannot occur.
Case c read a value from register r of some server s ∈Q and a different value from a register
> r:
Since v′ is the first value to be written to a register > r, this case cannot occur.
Case r is client restricted, c read a value from a register in r and a different value from a register > r:
Since v′ is the first value to be written to a register > r, this case cannot occur.
Since the following proof overlaps significantly with the previous proof, we have underlined the parts which have been altered.
Theorem A.8 (Satisfying Rule 4 - Inductive case). If the value v is decided in register set r and all (non-nil) values written to registers > r are v then the next (non-nil) value to be written to a register set r′ where r < r′ is also v.
Proof.
Assume the value v is decided in register set r by quorum Q ∈Qr thus ∀s ∈Q : s[r] = v. Since registers are write once, the following always holds true: ∀s ∈Q : s[r] = v ∨s[r] = unwritten.
Assume the value v′ is written to register set r′ by client c where r < r′. Assume that all (non-nil) values written to registers > r are v thus c can only read v from (non-nil) registers > r.
We will show that v = v′.
16

---

Consider the decision table of client c when it is writing to r′. Since r < r′, the decision state of Q must be either None, Maybe v′ or Decided v′ (Figure 5).
Case Decided v′:
This decision state requires that ∀s ∈Q : s[r] = v′. Since we know that ∀s ∈Q : s[r] = v ∨unwritten then v = v′.
Case Maybe v′:
The decision state Maybe v′ can be reached in one of three ways:
Case c read v′ from register r of some server s ∈Q:
Since we know that ∀s ∈Q : s[r] = v ∨unwritten then v = v′.
Case r is client restricted and c read v′ from register r of some server s:
Since we know that ∀s ∈Q : s[r] = v ∨unwritten then v = v′.
Case c read v′ from a register > r:
Since v is the only (non-nil) value to be written to registers > r then v = v′.
Case None:
The decision state None can be reached in one of five ways:
Case c read nil from register r of some server s ∈Q:
Since ∀s ∈Q : s[r] = v ∨unwritten, this case cannot occur.
Case c read two different values from two servers, s, s′ ∈Q:
Since ∀s ∈Q : s[r] = v ∨unwritten, this case cannot occur.
Case c read two different values from registers > r:
Since v is the only (non-nil) value to be written to registers > r, this case cannot occur.
Case c read a value from register r of some server s ∈Q and a different value from a register
> r:
Since we know that ∀s ∈Q : s[r] = v ∨unwritten and v is the only (non-nil) value to be written to registers > r, this case cannot occur.
Case r is client restricted, c read a value from a register in r and a different value from a register > r:
Since we know that at some time ∀s ∈Q : s[r] = v, then if r is client restricted then all non-nil registers in r must contain v. Since v is the only (non-nil) value to be written to registers > r, this case cannot occur.
A.3 (Fast) Paxos Figure 8 describes the Paxos algorithm using write-once registers. Section 5 describe how to gen- eralise Figure 8 to Fast Paxos. In this section, we proof that Fast Paxos (and therefore Paxos) implements the four rules for correctness (Figure 3) and thus satisfies the non-triviality and agree- ment requirements of consensus.
Theorem A.9 (Satisfying Rule 1). If the value v is the output of client c then c has read v from a quorum Q ∈Qr in register set r.
Proof.
Assume the value v is the output of client c.
This must be the result of c completing phase two of Fast Paxos for some register set r. c must have received the message P2b(r,v) from > 1 2/≥3 4 of servers (depending on either r is classic/fast).
Prior to sending P2b(r,v), each server s has written register r to v. Qr is any subset of servers containing > 1 2/≥3 4 of servers (depending on either r is classic/fast). Thus c has read a quorum Q ∈Qr in register set r.
17

---

Theorem A.10 (Satisfying Rule 2). If the value v is written by a client c then either v is c’s input value or v has been read from some register.
Proof.
Assume a value v is written by a client c. This must be the result of completing phase one of Fast Paxos for some register set r and choosing the value v. The value v must have been chosen in one of following ways:
Case 0 (non-nil) registers where returned with P1b messages:
In this case, v is c’s input value.
Case 1 or more (non-nil) registers where returned with P1b messages:
In this case, v is the most common value from the greatest register set thus v has been read from some register.
Theorem A.11 (Satisfying Rule 3). If the values v and v′ are decided in register set r then v = v′.
Proof.
Assume the values v and v′ are decided in register set r. It is therefore the case that there exists two quorums Q, Q′ ∈Qr such that ∀s ∈Q : s[r] = v and ∀s ∈Q′ : s[r] = v′ The register set r is either fast (quorum intersecting) or classic (client restricted):
Case r is fast:
There exists a server s where s ∈Q and s ∈Q′. We require that s[r] = v ∧s[r] = v′ thus v = v′ Case r is classic:
At most one client is assigned register set r.
Each client only writes (non-nil) values to assigned register sets and each does so with only one value. Therefore v = v′.
Theorem A.12 (Satisfying Rule 4). If the value v is decided in register set r and the (non-nil) value v′ is written to register set r′ where r < r′ then v = v′ We will prove this by induction over the writes to register sets > r.
Theorem A.13 (Satisfying Rule 4 - Base case). If the value v is decided in register set r then the first (non-nil) value to be written to a register set r′ where r < r′ is v.
Proof.
Assume the value v is decided in register set r. If r is fast (quorum intersecting), v must have been written to register r on 3 4 or more of servers. Otherwise, if r is classic (client restricted), v must have been written to register r on least 1 2 of servers. The writing of v to r must be the result of receiving P2a(r,v).
Assume the (non-nil) value v′ is written to register set r′ by client c. This must be the result of completing phase one of Fast Paxos for register set r′ and choosing the value v′. The value v′ could be chosen in one of two ways:
Case v′ is c’s input value: This requires that (non-nil) registers where returned to c with the P1b messages for r. At last one server s must both write s[r] = v and send a P1b message to c since both require at least 1 2 of servers.
Case s sends P1b for register r′ first:
Prior to sending P1b, the server s must write nil to all unwritten registers 0 to r′ −1, including register r since r < r′. Server s will not be able to later write s[r] = v so this case cannot occur.
18

---

Case s must write s[r] = v first:
Since no registers where returned with P1b messages, this case cannot occur.
Case v′ is the most common value read from the greatest (non-nil) register set: This requires that 1 or more (non-nil) registers where returned to c with the P1b messages for r. As we have already seen, at least one P1b message for register r′ must include r : v. The chosen value v′ must have either been read from register set r or from any register set > r.
Case v′ was read from register set r:
The register set r is either fast (quorum intersecting) or classic (client restricted):
Case r is classic:
All (non-nil) registers from r returned with P1b messages will contain v thus v = v′.
Case r is fast:
At least 1 4 of servers will reply with r : v. Therefore v will be the most common value and it will be chosen by c thus v = v′.
Case v′ was read from a register set > r:
Since the client c is the first to write to a register > r then c will not read any registers
> r. Therefore this case cannot occur.
Since the following proof overlaps significantly with the previous proof, we have underlined the parts which have been altered.
Theorem A.14 (Satisfying Rule 4 - Inductive case). If the value v is decided in register set r and all (non-nil) values written to registers > r are v then the next (non-nil) value to be written to a register set r′ where r < r′ is also v.
Proof.
Assume the value v is decided in register set r. If r is fast (quorum intersecting), v must have been written to register r on 3 4 or more of servers. Otherwise, if r is classic (client restricted), v must have been written to register r on least 1 2 of servers. The writing of v to r must be the result of receiving P2a(r,v).
Assume the (non-nil) value v′ is written to register set r′ by client c. This must be the result of completing phase one of Fast Paxos for register set r′ and choosing the value v′. The value v′ could be chosen in one of two ways:
Case v′ is c’s input value: This requires that (non-nil) registers where returned to c with the P1b messages for r. At last one server s must both write s[r] = v and send a P1b message to c since both require at least 1 2 of servers.
Case s sends P1b for register r′ first:
Prior to sending P1b, the server s must write nil to all unwritten registers 0 to r′ −1, including register r since r < r′. Server s will not be able to later write s[r] = v so this case cannot occur.
Case s must write s[r] = v first:
Since no registers where returned with P1b messages, this case cannot occur.
Case v′ is the most common value read from the greatest (non-nil) register set: This requires that 1 or more (non-nil) registers where returned to c with the P1b messages for r. As we have already seen, at least one P1b message for register r′ must include r : v. The chosen value v′ must have either been read from register set r or from any register set > r.
Case v′ was read from register set r:
The register set r is either fast (quorum intersecting) or classic (client restricted):
19

---

Case r is classic:
All (non-nil) registers from r returned with P1b messages will contain v thus v = v′.
Case r is fast:
At least 1 4 of servers will reply with r : v. Therefore v will be the most common value and it will be chosen by c thus v = v′.
Case v′ was read from a register set > r:
Since all non-nil registers > r contain v then c will not read any other value from any registers > r thus v = v′.
20

---

