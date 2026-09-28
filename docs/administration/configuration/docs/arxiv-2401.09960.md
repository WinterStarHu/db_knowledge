# A Comprehensive Scalable Framework for Cloud-Native Pattern Detection with Enhan

> 来源: https://arxiv.org/pdf/2401.09960

A Comprehensive Scalable Framework for Cloud-Native Pattern
Detection with Enhanced Expressiveness
Ioannis Mavroudopoulosa, Anastasios Gounarisa
aAristotle University of Thessaloniki, Dept. of Informatics, Thessaloniki, Greece
Abstract
Detecting complex patterns in large volumes of event logs has diverse applications in various do-
mains, such as business processes and fraud detection. Existing systems like ELK are commonly
used to tackle this challenge, but their performance deteriorates for large patterns, while they suf-
fer from limitations in terms of expressiveness and explanatory capabilities for their responses.
In this work, we propose a solution that integrates a Complex Event Processing (CEP) engine into
a broader query processsor on top of a decoupled storage infrastructure containing inverted in-
dices of log events. The results demonstrate that our system excels in scalability and robustness,
particularly in handling complex queries. Notably, our proposed system delivers responses for
large complex patterns within seconds, while ELK experiences timeouts after 10 minutes. It also
significantly outperforms solutions relying on FlinkCEP and executing MATCH RECOGNIZE
SQL queries.
Keywords: pattern detection, big data, CEP, Spark
1. Introduction
In recent years, logging systems have become an essential tool for organizations to monitor
their processes, generating log entries that can reach the order of terabytes per day[1]. Each
log entry typically contains at least an event type and a timestamp, usually along with other
domain-specific information, thus the set of logs forms an event sequence database. The ad-
vanced analytics that are then applied to these sequences typically fall into two main categories:
sequential pattern mining (SPM) [2] and complex event processing (CEP) [3, 4]. SPM techniques
extract interesting sequences from the event sequence database, such as frequent[5], important,
and highly utility ones [6], while CEP detects arbitrary patterns in real-time over a stream of
events.
However, organizations often need to detect specific behaviors that are not known beforehand
or are not frequent (arbitrary patterns); there is a need to support ad-hoc pattern queries over these
very large sequence databases. For instance, an online shop may want to identify customers
who purchase product A followed by product B and are likely to be interested in the newly
arrived product C, in order to efficiently make a targeted advertisement. Similarly, in case of
Email addresses: mavroudo@csd.auth.gr (Ioannis Mavroudopoulos), gounaria@csd.auth.gr (Anastasios
Gounaris)
Preprint submitted to XXX
January 19, 2024
arXiv:2401.09960v1  [cs.DB]  18 Jan 2024

---

a cybersecurity attack, companies need to efficiently search their logs for event sequences to
determine whether they have been affected by the attack.
This problem can be addressed by employing a CEP engine, such as SASE [4], and treating
the event sequence database as an event stream. However, findings from [7] strongly indicate that
this approach is suboptimal when applied to large sequence databases. The reason behind this
suboptimal performance is that CEP engines require parsing the entire dataset for each query, as
they lack any indexing mechanisms to facilitate efficient search space reduction. An alternative
solution involves the utilization of MATCH RECOGNIZE (MR) [8, 9], a recent SQL extension
that is capable of pattern detection, similar to CEP. Nevertheless, current implementations of MR
do not rely on any tailored indexing either, and thus they encounter similar limitations as CEP,
i.e. they cannot scale in big data scenarios. Therefore, a form of indexing is crucial in order to
effectively address the detection of arbitrary patterns in large volumes of data.
The main problem this work aims to address is detecting arbitrary complex patterns in large
log databases. In the online shopping example described above, the pattern is a simple one
and can be denoted as < A, B,C >. Complex patterns include negations and iterations, e.g.,
< A, B, !C, D, E∗, A, B+,C, D, E >, while duration constraints between events may apply, e.g.,
the timestamps between the first and the last event should not exceed a threshold. We propose a
novel approach, according to which the complex pattern above in our experimental setting can
be detected in less than 10 seconds, whereas the open-source state-of-the-art ELK (Elasticsearch,
Logstash, Kibana) stack1 times out after 10 minutes. Note that these complex patterns are already
supported by both CEP engines, like SASE [4] and FlinkCEP [10], and MR; however, as also
evidenced by our experimental results, these solutions do not scale. The second problem we
target is how to offer explainability in simple patterns, i.e., to explain to the user the minimal
change in the timestamps required for a trace to include the requested pattern in case the trace
contains the pattern events but not in the user-defined order; this increases the trust in the system
[11].
Both problems are addressed through the development of a system that, to the best of our
knowledge, is the first one that encapsulates a CEP engine within a query processor that is to-
tally decoupled from the (indexed) log storage thus adhering to the modern design principles
for cloud-native big data management systems [12]. As a basis, we use the indexing solution
of the preliminary version of the system [13], which is shown to outperform other index-based
approaches, such as [14], [15] and ELK, for simple patterns. Building on top of [13] indexing
rationale, we fully re-engineer its query processor to (i) encapsulate SASE [3, 4], (ii) run in
Spark to attain scalability and (iii) offer explanations. We also heavily modify the storage layer
departing from Cassandra (so that storage and processing are fully decoupled) while addressing
incremental indexing issues. In summary, this work has four main contributions.
• We propose a novel architecture for arbitrary pattern detection in log databases that encap-
sulates a CEP engine and its storage is decoupled from the query processing module.
• We propose a methodology to efficiently process complex queries and offer explanation
when matches are not found.
• We conduct experiments using a large volume of data to demonstrate the superior scala-
bility and pattern detection capabilities of SIESTA compared to its competitors, including
ELK, FlinkCEP, and MATCH RECOGNIZE.
1https://www.elastic.co/what-is/elk-stack
2

---

• We provide the complete solution in open source and the experimental setting for repro-
ducibility of our work.
The remaining sections of this paper are organized as follows. We present the related work
next. In Section 3, we introduce the notation and briefly describe some of the key components of
SIESTA. Section 4 discusses the novel aspects of the query processor. In Section 5, we present
an alternative storage solution to the one in the preliminary version of SIESTA, the incremental
indexing approach, and additional storage optimizations. In Section 6, we evaluate the proposed
implementation. Section 7 presents some ideas for future extensions, and we conclude the paper
in Section 8.
2. Related Work
SIESTA relates more closely with three other areas, which are briefly described in turn.
Pattern Detection and expressiveness of CEP systems: There have been numerous surveys
presenting scalable solutions for detecting complex events in data streams, with a particular focus
on pattern detection [16, 17]. Over the years, several general-purpose CEP languages have been
proposed, offering different capabilities and levels of expressiveness in terms of supported pattern
queries [18]. Preliminary languages, like SASE [19] and SQL-TSQ[20], could only support
a single selection policy, namely strict-contiquity (SC). Later, an extension called SASE+ [3]
was introduced, which allowed the skipping of irrelevant events in the stream, enabling skip-
till-next-match (STNM) and skip-till-any-match (STAM) policies. Moreover, SASE+ expanded
upon the original version by supporting the Kleene* operator. Based on the SASE+ language,
the CEP engine SASE has been developed [4]. We chose to integrate it with SIESTA as it is
lightweight software and provides support for a wide variety of patterns. To the best of our
knowledge, such usage of a CEP engine has not appeared before, while we avoid reinventing the
wheel. Other examples of CEP engines include Cayuga[21], NextCEP[22], and FlinkCEP[10],
which is a complex event recognition and processing on top of Apache Flink[23]. In addition
to traditional pattern detection, CEP systems have also tackled real-world challenges such as
handling imprecise event timestamps [24] and out-of-order event arrivals [25].
The MATCH RECOGNIZE (MR) SQL extension can express complex queries, similar to
CEP engines, but it operates over static data, i.e., data stored in a relational database. MR is
supported by various query engines, including Trino [8] and Snowflake [9]. We directly compare
our solutions against such an implementation. Notably, recently, a system called TReX [26]
that builds upon MR and optimizes pattern searches in time series data leveraging query plan
optimization techniques has been developed. These advances refer to execution plans, where
event types are derived from time series data on the fly and the corresponding low-level operators
can be re-ordered based on metadata, such as selectivity. Consequently, they are orthogonal to
our work, which assumes that event type instances are already present in the logs. However, in
our solution, we also extract occurrences of pairs of event types ordered by their selectivity.
Pattern mining: For non-streaming data, a series of methods have been developed in order to
mine patterns. The majority of these proposals look for frequent patterns; e.g., Sahli et al in [27]
proposed a scalable method for detecting frequent patterns in long sequences. As another exam-
ple, in several other fields such as biology, several methods have developed, which are typically
based on statistics (e.g., [28, 29]) and suffix trees (e.g., [30]). Parallel flavors have also been pro-
posed, e.g., in [31, 32], with the latter one implemented on top of Apache Hadoop. Other forms
of mined patterns include outlying patterns [33], high contrast patterns [34] or general patterns
3

---

with high utility as shown in [35]. [36] support efficient pattern detection of frequent patterns by
building indices. Finally, extensive research has been conducted to detect patterns under various
constraints [37]. Introducing constraints not only benefits users in finding precisely what they
need but also enhances the efficiency of the methods by avoiding unnecessary computations.
Inspired by the advances in these relative fields, our aim in this work is to enable the efficient
detection of more complex queries over large volumes of data.
Business processes: There are applications in business process management that employ
pattern mining techniques to find outlier patterns and clear log files of infrequent behavior, e.g.,
[38, 39], in order to facilitate process discovery. Another application is to predict the upcoming
events in a trace [40, 41, 42] and also use this information to determine if a trace will fail to
execute properly [43]. All these techniques complement the proposed framework, and it would be
interesting, in the future, to evaluate the performance of a domain-specific engine tailored to this
context, rather than using SASE or any other competitor against which we already compare. Such
an engine may offer more specialized capabilities for business process management. Finally, in
the field of Business Process Mining, the MR operator has been employed to detect patterns in
log files [44].
3. Background
We begin with a brief description of the notation and an overview of the SIESTA system.
SIESTA is an infrastructure for efficient support of sequential pattern queries based on inverted
indices, generated from a logfile L containing timestamped events E. The events are of a specific
type and are logically grouped into sets called cases, sessions, or traces2. More formally:
Definition 3.1. (Event Log) Let A be a finite set of activities (aka tasks). A log L is defined as
L = (E,C, γ, δ, ≺) where E is the finite set of events, C is the finite set of Cases, γ : E →C is a
surjective function assigning events to Cases, δ : E →A is a surjective function assigning events
to activities. An event ev ∈E that belongs in a case t ∈C, is a tuple that consists of at least a
recorded timestamp ts, denoting the recording of task execution, an event type type ∈A, and a
position pos, denoting the position of the event in t (i.e., t =< ev1, ev2, . . . , evn > and evi.pos = i
). Finally, ≺is the strict total ordering over events belonging to a specific case, deriving from the
events’ timestamp.
Within a specific case, we assume that two events cannot have the same timestamp. In ses-
sions like web user activity and similar ones, events are usually instantaneous. However, this
is not the case in task executions in business processes. In the latter case, the timestamp refers
to either the beginning of the activity or its completion, but in any case, logging needs to be
consistent. Table 1 summarizes the main notation.
Definition 3.2 (et-pair). An event type pair, or et-pair for short , is a pair (ai, aj), where ai, aj ∈
A
Definition 3.3 (event-pair). For a given et-pair (ai, aj) and a sequence of events t =< ev1, ev2, ..., evn >,
there is an event-pair (evx, evy) with x ≤y ∧evx.type = ai ∧evy.type = aj and evx, evy ∈t. Note
that based on this definition, the events in a event-pair do not have to be consecutive.
2We use the terms trace, case and session interchangeably.
4

---

Table 1: Frequently used symbols and interpretation
Symbol
Short description
L
the log database containing events
A
the set of activities (or tasks), i.e., the event types
E
the set of all event instances
C
the set of cases, where each case corresponds to a single logical unit
of execution, i.e., a session, a trace of a specific business process
instance execution, and so on
ev
an event (ev ∈E), which is an instance of an event type
ts
the timestamp of an event (also denoted as ev.ts)
pos
the position of an event in its trace (also denoted as ev.pos)
type
the event type of an event (also denoted as ev.type); type ∈A
s
CEP operator, s ∈[ , +, ∗, !, ||]
e
query event in QP, e = (a, s), a ∈A
Database
Logfile
Preprocess
Incremental
Indexing
Query
Processor
CEP
Append events
Object Sotrage
User
Exressiveness
Explainability
Figure 1: Architecture of the initial SIESTA proposal (white background) along with its extensions in this work (light
blue background)
Definition 3.4 (event-pairs non-overlapping in time). Two event-pairs (evx, evy) and (evi, ev j)
are non-overlapping in time if and only if x > j ∨y < i.
In the original SIESTA, event-pairs are generated based on Definition 3.4. However, in our
proposed solution, we allow for two event-pairs to partially overlap in time. This modification
affects only the event-pairs (ev1, ev2) where ev1.type = ev2.type = ai (i.e., both event types are
the same), in which case the second event can be reused as the first event in another event-pair
instance. This enables us to support efficiently more advanced queries, like time constraints,
which will be discussed in Section 4.
The architecture of the early implementation of SIESTA (illustrated in Figure 1) consists
of two main components: the pre-processing component and the query processor. The pre-
5

---

processing component is responsible for handling continuously arriving logs and computing the
appropriate indices, while the query processor utilizes the stored indices to perform efficient
pattern analysis.
The primary inverted index, named IndexTable, is created based on the et-pairs. For each
et-pair, we extract from each trace a list of (non-overlapping in time) event-pairs and combine
them in a single list, by keeping for each event-pair the traceid in which it was detected and the
timestamps of the two events in the pair. In addition to the IndexTable, there are several auxiliary
tables that enable different processes. A complete list of all the tables used is presented below,
including their purpose and structure. It is important to note that the structure of all the tables
follows a key-value pair, as they are stored in Cassandra in [13].
• IndexTable: This table is the inverted index and serves as the primary table for answering
queries. Its primary key is an et-pair, i.e. (ai, aj), where ax ∈A. The structure is (ai, aj)
: [(traceid, evk.ts, evλ.ts), . . . ], where traceid uniquely identifies each trace and evk.ts <
evλ.ts and evk, evλ ∈t with t being the trace with id equal to traceid. The inverted list of an
et-pair (ai, aj) is denoted as IndexTable[(ai, aj)].
• SequenceTable: This table is used to store and manage all indexed traces in the system;
new events belonging to an already active trace are simply appended to the list. The struc-
ture of the table is represented as (traceid) : [ev1, ev2, ..., evn], where evi ∈t with t being
the trace with id equal to traceid.
• SingleTable: This table is an inverted index having as key a single event type and fa-
cilitates the generation of new event-pairs as well as the detection of patterns in group
of traces. Its structure is (ai) : [(traceid, evk.ts, evk.pos), . . . ], where evk ∈t with t be-
ing the trace with id equal to traceid. The inverted list of an event type ai is denoted as
SingleTable[(ai)].
• LastChecked: This table is used to avoid creating pair of events that have already been
created and indexed. The structure of this table is (ai, a j, traceid) : tslast, where for a
pair (ai, aj) and a trace identifier traceid the last timestamp that this pair is completed is
stored, i.e. tslast = {ev j.ts| j ≥λ ∀(trace′
id, evk.ts, evλ.ts) ∈IndexTable[(ai, aj)], with
trace′
id = traceid }. The last timestamp of an et-pair (ai, aj) of a trace with id equal to
traceid is denoted as LastChecked[(ai, aj, traceid)]
• CountTable: This table is responsible to store useful statistics for each et-pair. The struc-
ture is (ai, a j) : [total completions,sum durations], where total completions is equal to the
length of IndexTable[(ai, aj)] and sum durations is equal to P(evλ.ts −evk.ts)∀(traceid,
evk.ts, evλ.ts) ∈IndexTable[(ai, aj)].
Example: Let us consider a web logging application that monitors the order of different
actions denoted as A, B, and C, for two users. Figure 2 presents this logfile along with the
corresponding et-pairs and SIESTA’s built indices. For simplicity, we use only the position of
the events in the traces instead of their timestamps.
Once the indices have been calculated and stored, the query processor utilizes them to re-
spond to different query types. The query input q in the initial SIESTA solution, in all different
queries, is a pattern (i.e., a sequence) of p event types q =< a1, . . . , ap >, where ai ∈A. The
supported query types in increasing order of complexity are as follows:
6

---

t1 = <A, A, B>
t2 = <A, B, C>
Logfile
Indices
IndexTable
(A, A) -> [(t1, 1, 2)]
(B, C) -> [(t2, 2, 3)]
(A, C) -> [(t2, 1, 3)]
(A, B) -> [(t1, 1, 3), (t2, 1, 2)]
SingleTable
(A) -> [(t1, 1), (t1, 2), (t2, 1)]
(C) -> [(t2, 3)]
(B) -> [(t1, 3), (t2, 2)]
LastChecked
(A, A) -> [(t1, 2)]
(B, C) -> [(t2, 3)]
(A, C) -> [(t2, 2)]
(A, B) -> [(t1, 3), (t2, 2)]
CountTable
(A, A) -> (1, 1)
(B, C) -> (1, 1)
(A, C) -> (1, 2)
(A, B) -> (2, 3)
et-pairs
(A,A) (A,B) (A,C) (B,C)
Figure 2: Example of indices built
• Statistics. This query type generates statistics for every consecutive et-pair in the pat-
tern, which can provide useful insights about the pattern’s behavior through simple post-
processing.
• Pattern Detection. This type of query aims to return all traces that contain the given
pattern.
• Pattern Continuation. This type of pattern querying returns the events that are most likely
to extend the pattern in the query, i.e. it is an exploratory query.
To complete the discussion, we provide a brief overview of how the query processor handles
pattern detection queries (the remaining query types are not further investigated). For a query
pattern of p event types q =< a1, . . . , ap >, SIESTA uses the IndexTable to detect occurrences
of this pattern in the indexed traces. An occurrence of the pattern in a trace t is represented as
Occ = (t, < ev1, . . . , evp >) and satisfies evi.type = ai, with evi ∈t ∧ai ∈q. To that end,
query processor first extracts the set of consecutive et-pairs from q, (ai, ai+1) ∀i ∈[1, p −1],
and retrieves the corresponding lists stored in the IndexTable. Then, it prunes all traces that do
not contain all of the above et-pairs, and finally validates these traces to remove false positives,
i.e., traces that contain all et-pairs but the events do not appear in the correct order. Since the
timestamps are already stored in IndexTable, SIESTA can perform the validation without the
need to access the original traces in the SequenceTable.
Example: Let us consider the small indexed log presented in the Figure 2, and our goal is
to detect the pattern q =< A, B,C >. First, the set of consecutive et-pairs is extracted, which
in this case contains the et-pairs (A, B) and (B,C). Then, the relevant inverted lists are retrieved
from the IndexTable and all the traces that do not appear in both lists are eliminated. As we can
7

---

observe, only t2 is present in both lists. Finally, a validation step ensures that t2 indeed contains
the pattern q, confirming that it is not a false positive.
Definition 3.5 (Occurrences, non-overlapping in time). Following the Definition 3.4, two oc-
currences Occ1 = (t1, < ev1
1, . . . , ev1
p >) and Occ2 = (t2, < ev2
1, . . . , ev2
p >) of a query pattern q
of length p, with ev1
i .type = ev2
i .type, do not overlap in time if ev1
p.ts < ev2
1.ts ∨ev1
1.ts > ev2
p.ts.
It is worth noting that events in each occurrence need not be consecutive, which is enabled by
the extraction of et-pairs (Definition 3.3), making it well-suited for real-world applications where
data may contain outliers or unexpected behavior. SIESTA’s detection approach is similar to the
selection strategy known as Skip-till-Next-Match (STNM) with consume [18] in CEP terminol-
ogy. In STNM, irrelevant events are skipped until the next matching event is detected. However,
in the case of multiple occurrences of the pattern in the same trace, SIESTA extends the tradi-
tional definition of STNM by excluding any occurrences that overlap in time (Definition 3.5).
This design choice ensures that the returned information is more compact.
4. Query Processor Design
In this section, we introduce the extended query processor (QP) that enhances the capabil-
ities of the original query processor by enabling a wider variety of pattern queries. Due to the
improved expressiveness, more sophisticated detections can be performed, such as adding con-
straints between two events, enabling practical applications like fraud detection and online shop-
ping. Additionally, the processor can now provide explanations about the result set by detecting
inconsistencies in both queries and the events’ timestamps. These are achieved by integrating
SASE into SIESTA. In the rest of this section, we provide a generalized formulation of the en-
hanced pattern detection queries and describe how the various components were implemeneted.
These components include time and gap constraints, complex query patterns with Kleene opera-
tions and negations, and explanation of non-matches.
4.1. Pattern Detection Query
Following the semantics of the SASE+ language [3], the type of pattern queries supported
conform to the following template:
FROM <process name>
PATTERN <pattern q>
[WHERE <time/gap constraints> ]
[BETWEEN <starting time> AND <ending time>]
[GROUPS <group definition>]
[EXPLAIN-NON-ANSWERS < k, uncertainty, step >]
[RETURN-ALL <true/false>]
The query structure above extends the one in the original implementation of SIESTA, which
only contained the PATTERN, GROUPS, and RETURN-ALL clauses. In some cases, organiza-
tions may need to monitor multiple processes separately, such as monitoring the sales and the
costumer support. Our comprehensive solution can now support indexing and querying multiple
different processes, referred to as log databases. The FROM clause is used to specify the name
8

---

of the log database. The same name is also used during indexing to ensure that the new logfiles
are correctly appended to the appropriate indices.
The PATTERN clause describes the query pattern. We extend the simpler definition of query
pattern in Section 3 by allowing CEP operators. That is, the query pattern q is now defined as
an ordered list of query events e, with e being a tuple (a, s), where a ∈A and s is a CEP operator.
s ∈[ , +, ∗, !, ||], thus corresponding to simple event, event with Kleene + operator, event with
Kleene * operator, Negation and Or, respectively. In the case of an Or operator, we extend the
query event with a list of all the alternative event types. For example, if events A, B, and C are
possible alternatives for the position i of a query q, then this is being denoted as ei = (A, ||, [B,C]),
with ei ∈q. The FROM and PATTERN clauses are mandatory in each pattern detection query.
In the WHERE clause, time and gap constraints between events are defined. Each constraint
is a tuple (gt,wa,v,i,j), where gt = gap/time, wa = within/atleast, v is the constraint value, and
i,j denote the positions of the two events in the query pattern. Therefore, for a query pattern q
with |q| = p, the constraint (time, within, value, a, b) denotes that for every detected occurrence
Occ = (t, < i1, . . . , ip >), the event in position a and the event in position b should occur within a
timeframe that is less or equal than the given value, evib.ts −evia.ts ≤value. It would have been
≥if, instead of within, it was atleast and the pos would have been used instead of ts in case of
a gap constraint. This is especially valuable in applications like fraud detection. For instance,
consider a scenario where a pattern q consisting of p events (p ≥3) needs to be detected, but the
first three events should occur within a two-minute timeframe. In this case, the WHERE clause
will be set to (time, within, 2, 1, 3).
The BETWEEN-AND clause defines the time window of interest in which we want the
matches to have taken place. That is, for a query pattern q, with |q| = p and the clause BE-
TWEEN tsa AND tsb, every detected occurrence Occ = (t, < i1, . . . , ip >) should occur within
this timeframe, i.e. evi1.ts ≥tsa ∧evip.ts ≤tsb. Therefore, if it is assumed that a security breach
occurs outside of regular working hours, the time window of interest can be adjusted accordingly.
The GROUPS clause allows for custom grouping between traces to be defined during the
query phase. Groups are defined as a list of sets, where each set can contain a single number or
a range of numbers. For example, the group definition [(1 −3, 8), (5 −7)] represents two groups:
one containing the traces with ids (1, 2, 3, 8) and the other containing the traces with ids (5, 6, 7).
This supports scenarios like web logging, where multiple sessions can be grouped based on the
IP or an external user id. The implementation of groups has been explained in [13] and thus
further details are omitted here.
The EXPLAIN-NON-ANSWERS clause is used to enable the detection of both inconsis-
tencies in the query and imprecise timestamps in the traces and it will be explained in detail
in Section 4.4. Note that this option is currently only allowed in simple query patterns q (i.e.
∀e ∈q|e.s = ).
Finally, by setting the RETURN-ALL parameter to true (default is false), multiple non-
overlapping occurrences of the query pattern can be returned for each individual trace. Oth-
erwise, only the first occurrence of the pattern for each trace will be returned to speedup result
generation.
4.2. Handling Gap/Time-Constraints
As mentioned in Section 3, the pattern detection queries are handled in the following way:
first, it extracts all the consecutive et-pairs that exist in the query pattern, then it retrieves the
corresponding inverted lists from the IndexTable, pruning all the traces that do not contain all
9

---

the pairs, and finally validating the remaining ones based on the retrieved events. However, this
approach does not allow for straightforward integration of constraints between events.
For example, consider a trace t =< A1, A2, B1,C1 >, where A1 occurs five hours prior to
B1, and A2 occurs only thirty minutes before B1. In this case, correctly identifying instances of
the pattern q =< (A, ), (B, ), (C, ) > with constraint (time, within, 60 minutes, 1, 2) becomes
challenging. That is because during indexing, since the event-pairs are not overlapping, there
would be one instance of the (A, B) et-pair, namely (A1, B1), and one instance for the (B,C) et-
pair, namely (B1,C1). Therefore, when detecting query q, only the events A1, B1, and C1 will be
retrieved from the IndexTable, leading to the conclusion that there is no instance of this pattern
in t. However, the sequence < A2, B1,C1 > actually constitutes a valid occurrence of the pattern.
Thus, the challenge lies in correctly applying constraints and efficiently retrieving all necessary
information from the database to effectively prune the traces before proceeding to the validation
step.
Lemma 4.1. If a trace t contains multiple events of type ai, then including an et-pair (ai, ai) in
the list of et-pairs to be queried from the IndexTable guarantees the retrieval of all events with
that type.
Proof The proof is by contradiction. Assume the inverted list IndexTable[(ai, ai)] has been re-
trieved, but an event evx of a trace t with evx.type = ai is not in the list. Also assume that
|oai| ≥2, where oai = [ ev j| ∀ev j ∈t, ev j.type = ai] and o is sorted based on the timestamps
(evx ∈oai). Since the event-pairs in the IndexTable are generated based on Definition 3.4 with its
discussed exception when the event types are the same, an event-pair (ev j, ev j+1) will be gener-
ated ∀j ∈[1, |oai| −1]. Therefore, evx will be included in at least one of the indexed event-pairs
in the IndexTable, which contradicts the assumption that it will not be retrieved.
Our proposal is based on Lemma 4.1. For a query pattern q =< (a1, s1), (a2, s2), · · · > with
a list of constraints, defined as tuples (gt,wa,v,i,j), we extend the et-pairs to be queried from
the IndexTable using the following procedure: (1) if wa = within we add (ai, ai) whereas (2) if
wa =atleast we add an et-pair (a j, aj). We consider these additional et-pairs as optional, and
so we do not prune traces that do not contain them. The type of the constraint (gap/time) is not
relevant in this procedure.
Theorem 4.2 (Correctness of our proposal). There are no false negatives for any constraint
definition, i.e. there are no instances of the query pattern that are mistakenly excluded.
Proof If we prove that Theorem 4.2 holds for every two consecutive events then it can be
generalized for every two pairs in the pattern. Let us consider a small query pattern q =< (a1, s1),
(a2, s2) > with a constraint defined as tuple (gt,wa,v,i,j). (a1, a2) is the only one et-pair in q. The
IndexTable[(a1, a2)] separates the set of traces into two subsets (those that contain this et-pair and
those that do not). The latter subset can be safely pruned, as these traces do not contain any event-
pair (evii, evi2), where evii.type = ai∧evi2.type = a2∧evi1.ts < evi2.ts∧evi2.ts−evi1.ts < lookback.
The remaining traces can be further divided into two categories: those that have at least
one retrieved event-pair satisfying the constraint, and those that do not. The traces in the first
category are true positives and are added to the result set. However, we cannot dismiss the traces
in the second category yet. For example, if the returned event-pair is (eva, evb) and the wa =
within, there might exist an event evx with evx.type = a1 such that eva.ts < evx.ts < evb.ts and
evb.ts −evx.ts ≤v. To retrieve all events of type a1 we have included the et-pair (a1, a1) in the
queried pairs (as shown in Lemma 4.1). Note that if the trace does not have multiple instances of
10

---

Algorithm 1 Calculate Et and Ea
Input Pattern q = [e1, e2, . . . , en], List < Constraints > clist
Output Et, Ea
1: qp ←extract different queries(q)
2: Et, Ea ←{ }, { }
3: for j ∈[1, . . . , m], where m = |qp| do
4:
Ex j ←{ }
5:
for all ei in qpj do
6:
if ei.s ∈[”!”, ” ∗”] then
7:
Ea.add( (ei.a, ei.a))
8:
qpj.remove(ei)
9:
for i ∈[1, . . . , |qp j| −1] do
10:
Exj.add(ei.a, ei+1.a)
11:
for all ei ∈qp j do
12:
if ei.s = ”+” then
13:
Ea.add((ei.a, ei.a))
14:
for all (qt,wa,v,i1,i2) in clist do
15:
if wa = within then
16:
Ea.add((ei1.a, ei1.a))
17:
else
18:
Ea.add((ei2.a, ei2.a))
19: Et ←Ex1 ∩Ex2 ∩. . . Exm
20: return Et, Ea
a1, then there can be no other event between the pair in the trace, and so the trace can be safely
pruned. Additionally, we do not need to retrieve all events of type a2, since it is guaranteed (by
Definition 3.4) that evb is the closest event of type a2 after eva.
For the case where wa =atleast, it is possible that an event evy with evy.type = a2 exists such
that evy.ts > evb.ts and evy.ts −eva.ts ≥v. In this case, we include the event-pair (a2, a2) in the
queried pairs. This time, there is no need to retrieve all the events of type a1 as it is guaranteed
(by Definition 3.4) that eva is the furthest event of type a1 from evb (and does not overlap with a
previous event-pair). If there exists an ev′
a with ev′
a.type = a1 and ev′
a.ts < eva.ts, then it would
be a part of another event-pair of (a1, a2) and therefore would be available for the validation
process. Overall, in every case all the required events are retrieved from the IndexTable and thus
there are no false negatives.
4.3. Additional operators and SASE integration
In this section, we discuss the implementation of additional operators, such as Kleene+ and
negation, in the pattern detection query.
As with the previous section, to effectively prune
traces and remove false positives, we will ensure that all necessary events are retrieved from
the database, by extending the et-pairs set. Note that only the original et-pairs are used to prune
the search space. The additional et-pairs are solely responsible for retrieving extra information
required for trace validation and, therefore, do not introduce any false positives. To this end, we
define 2 sets of et-pairs, Et and Ea, with Et ⊆Ea. The former contains the et-pairs that should
be present in a trace to proceed with the validation step, while the latter contains all the et-pairs
that will be retrieved from the IndexTable.
11

---

For a query pattern q =< e1, e2, . . . , en > and a list of constraints, Algorithm 1 generates Et
and Ea. First, the algorithm extracts all the possible patterns, i.e. the different patterns that are
formed due to the Or (”||”) operator (line 1). Note that after this operation, there will be no events
ei, with ei.s = ”||”. For each one of the j possible patterns derived, we perform 3 operations.
First, for every event with negation or Or operator (i.e. ∀ei ∈qp j|ei.s ∈[”!”, ” ∗”]) it adds
an (ei.a, ei.a) pair in the Ea and removes it from the qp j, because these events are not required
to be part of a trace in order to contain a valid occurrence of the q (lines 6-8). Next for every
two consecutive events in the remaining qp j, the algorithm adds an et-pair to the Ex j, as in the
original SIESTA QP solution. This set contains the true et-pairs for each qp j (lines 9-10) and the
overall set of true et-pairs is calculated as the intersection of all Ex j (line 19). Additionally, for
each ei with Kleene + (ei.s = ”+”), we add an (ei.a, ei.a) pair to the Ea based on Lemma 4.1(lines
11-13). Finally, for completeness, lines 14-18 describe the procedure for handling constraints, as
represented in the previous section.
After retrieving from the IndexTable all the et-pairs in Ea and prune the traces based on the Et
contents, the remaining traces proceed to validation. In the original implementation, of the query
processor, a linear parser was utilized for that purpose. However, now that the queries contain
Kleene closure and negation operators, along with constraints, a more sophisticated approach is
required. Modern CEP engines fit that purpose. CEP engines can parse a stream of events and
enumerate all the appearances of a predefined pattern based on a selection strategy. Therefore,
we integrate SASE 3 with SIESTA, to perform the final validation step.
The events are first partitioned based on the trace id and then ordered according to their
timestamps. These sequences of events are then processed by SASE, which is initialized with
the query pattern. The occurrences of the pattern detected by SASE are subsequently returned to
SIESTA. Even though SASE initially lacked the implementation for Kleene* and Or operators,
these functionalities were straightforward to implement. Note that, as shown in [7], SASE is
not suitable for big data. However, the efficient pruning performed by SIESTA (since traces are
aggressively eliminated and only the relevant events are present during validation) allows the
SASE overhead to be mitigated and outweighed by the benefits of extended functionality.
4.4. Explaining non-answers
End-users of most systems typically lack direct access to the underlying data model, making
it difficult for them to verify the reasoning behind the results returned from a query. This lack
of transparency often results in a lack of trust in the tool, leading to end-users becoming dis-
engaged [11]. Previous studies on non-answer explanations for database queries have focused
on either query explanation [11, 45], which addresses issues in the query, or data explanation
[46, 47], which addresses issues in the data. Recently, in [48], a framework is proposed that
addresses non-answer explanations for streaming data, covering both aspects of query and data
explanation. Inspired by this work, we implemented a similar solution on top of SIESTA to de-
tect inconsistencies in the query patterns and stored data. Before executing a pattern detection
query, we first evaluate its consistency through three steps: (1) verifying that all event types in
the query exist in the database, (2) ensuring that all extracted et-pairs are present in the database,
and (3) confirming that each constraint can be satisfied by at least one event-pair. To facilitate
these checks, we extend the information stored for each et-pair in the CountTable to include its
3https://github.com/haopeng/sase
12

---

t1
t2
t3
t4
t5
t6
t7
A
B
C
(a) Possible cases (words)
B
A
within 2
NFA
Stream (A,t1), (A,t2), (B,t2), (A,t3), (B,t3),
(B,t4), (C,t5), (C,t6), (C,t7)  
 
C
(b) Sase evaluation
Figure 3: Example with modified timestamps
minimum and maximum recorded duration, i.e. time difference between the two events. This
extension enables us to efficiently perform all three evaluations.
The data explanation takes place during the validation step, when all required events are
present. By treating once again the retrieved events as a (sub-trace) stream, we can employ
techniques that detect patterns in streams with imprecise timestamps, such as those presented
in [24] and [49]. For our implementation, we chose the Point-based method described in [24]
due to its simplicity and capability to work with SASE, which we have already integrated with
SIESTA. This procedure can be enabled during the query phase .
The Point-based method starts by calculating the possible cases (words). That is, each event
ev has an uncertainty interval (ev.ts ± uncertainty), and for each timestamp in this interval, a
new event is created; the parameter step is used to define the discrete timestamps in this interval,
since time is a continuous variable. Once all events have been generated, they are passed as a
stream and evaluated by SASE. The skip-till-any-match selection strategy is utilized to ensure
that no modification is missed [24]. If a match is returned that meets all the constraints, we report
the modification.
Similarly to [48], if there are multiple modifications found, the one with the minimum cost
is preferred. The cost is calculated as the sum of the absolute differences between each event’s
original and modified timestamp and is efficiently counted as the events are processed by SASE.
Additionally, the cost must be less than the user-defined parameter k for a modification to be
considered valid. Based on this, we ensure that SASE will terminate any partial matches whose
cost has exceeded the parameter k. The parameters k, uncertainty, and step are specified in the
pattern detection query in the EXPLAIN-NON-ANSWERS clause.
Example: Consider an industrial environment with location sensors installed, monitoring
the movement of workers. Each time a worker enters a room, the location sensor transmits this
information with the worker’s id. However, due to possible transmission delays of up to 1 second,
the recorded timestamps may not precisely match the actual event times. The administrator wants
to detect if a specific sequence B, A,C is followed by any of the workers. The constraints are that
the transition from room A to room C should occur within 2 seconds, and considering the possible
delays, it allows searching for modified timestamps that sum up to 4 seconds from the recorded
timestamps. Based on the above the submitted query will be the following:
FROM <main>
PATTERN < (B, ), (A, ), (C, ) >
13

---

WHERE (time, within, 2, 2, 3)
EXPLAIN-NON-ANSWERS (4, 1, 1)
For a worker, the events A, B, and C are retrieved with relevant timestamps t2, t3, and t6, respec-
tively. Based on the uncertainty parameter (1 second), the possible timestamps for ev1 are t1, t2,
and t3, and the same applies to the other two events (Figure 3a). This results in a total of 33 = 27
possible cases. However, the generated stream passed to SASE for evaluation contains only a
single extended case with 3 × 3 = 9 events. Figure 3b illustrates the stream and the NFA used
for evaluation. Although the sequence < B, A,C > does not appear in the retrieved subtrace, an
occurrence of the pattern can be found in the timestamps < t2, t3, t5 >, and the modification cost
is equal to 3, which is less than the threshold k = 4; B’s timestamp is decreased by 1 and A’s is
increased by 1 to meet the ordering constraints, while C is also modified (decreased by 1) to meet
the within constraint. Overall, the non-answer explanation lies in producing this modification to
notify the user under which altered timestamps the trace id would have been returned.
5. Storage
In this section, we outline the storage design choices that differ from the initial implementa-
tion in [13].
5.1. Object Storage
Here, we explore an alternative approach that aims to further increase SIESTA’s storage scal-
ability and cost-efficiency, making it suitable for a wider range of applications and easier to
deploy by real-world organizations. This alternative utilizes an Object Storage System (OSS)
and in our implementation, we opted for the S3 protocol through MinIO4 due to its widespread
adoption in both the industry and the research community [50]. S3 simplifies deployment, costs
less and compresses data before transmission. It utilizes parquet files5 for data storage, which
are immutable and can be partitioned based on column values. This immutability poses two
main challenges that need to be addressed. Firstly, in incremental indexing (discussed in the
next section), the process involves fetching the previous records, combining them with the new
data, and rewriting them back to S3, making the process more time-consuming than it would be
otherwise. Secondly, we must ensure that using S3 in SIESTA does not compromise the system’s
fast response times, considering that the data is stored in a less optimized index lookup structure
compared to Cassandra.
To address these challenges, we have implemented partitions as a solution. We introduced
two new parameters during index building: split every days and trace split. The split every days
parameter allows users to specify a time interval in days for splitting the IndexTable and Sin-
gleTable into non-overlapping segments. For example, if set to 30, both tables will be split into
30-day segments. Note that in the case of the IndexTable, if a pair of events spans multiple seg-
ments, it is added to the segment of the last event. Similarly, the trace split parameter partitions
the SequenceTable and LastChecked based on trace groups. For instance, if set to 10K, a new
partition will be created every 10K traces. In addition, the split every days parameter helps to
limit the size of the inverted lists and refer to bounded time periods; otherwise they would grow
infinitely (for this reason, this feature is implemented in Cassandra as well).
4https://min.io/
5https://parquet.apache.org/
14

---

Furthermore, to optimize response times, we have implemented data partitioning based on
the original columns. However, partitioning the data using the primary keys that are used in
Cassandra tables will sometimes result in an excessive number of partitions, like in the case of
IndexTable, negatively impacting times. Therefore, instead of using the entire et-pair as the par-
tition key in IndexTable, LastChecked, and CountTable, we have chosen to partition these tables
based solely on the first event of the et-pair. This approach allows us to retain the benefits of par-
titioning in response times without compromising the efficiency of the preprocessing procedure.
For example, the structure of the IndexTable that was previously stored in Cassandra (as shown
in Section 3) is transformed to the following format: IndexTable: (ai, aj, tsstart, tsend, [(traceid,
evk.tsa, evλ.ts), . . . ]), partitioned first by the time interval (tsstart, tsend) which is derived from the
split every days parameter, and then by the first event in the et-pair (i.e., ai).
5.2. Incremental Indexing
Implementing efficient incremental indexing can be challenging, especially for systems like
SIESTA that have multiple indices with relatively high building times. Minimizing index build-
ing time is critical for maintaining the practicality and real-world applicability of SIESTA. We
target scenarios where indices are updated on a daily or an hourly basis or even more frequently,
e.g., every 15 minutes.
The biggest challenge is to efficiently handle the traces that expand in multiple log batches.
The additional events belonging to an ongoing trace require combining them with the previous
events in order to generate all the corresponding event-pairs. Consider a scenario where we log
user events on a website and create a new logfile every day at midnight. In this scenario, for
example, a user logs in at 23:50 and performs the events A1, B1, and A2 until midnight. After
midnight, the user is still browsing the website and performs the events B2 and D1, which are
logged to a newly created logfile. When the new logfile is processed for indexing at the end of
the second day, we expect to see, among others, the event-pairs (A1, D1) and (A2, B2).
Moreover, in certain domains, it is necessary to consider only those event-pairs that occur
within a specific time frame to improve efficiency. To meet this requirement, we have introduced
a final parameter called lookback, which is set during the preprocessing stage. This parameter
defines the maximum number of days that can separate two events for them to be considered
related and create an event-pair. For example, consider a business process logging application
where each process can potentially run for months. If the organization sets the lookback pa-
rameter to 30, it defines that two events are related if they occur within a month. Therefore,
event-pairs with a time difference of more than a month will not be stored in the IndexTable,
reducing the size of the main index and improving the query performance.
The key ideas for an efficient incremental processing are to (1) avoid creating the pairs that
have already been created and indexed, and (2) effectively update the various tables, while also
ensuring that all constraints, such as the time frame between events, are met.
For a newly arrived logfile, the preprocess component will start by calculating the single
inverted index for the new events. Then, it will update SequenceTable and SingleTable with the
new information. Next, the updated traces from the SequenceTable, along with the parameters
lookback and split every days, will be used by the incremental indexing procedure, outlined in
Algorithm2, to extract the new event-pairs.
For each trace all the et-pairs are generated. Then, for each et-pair we extract a list of the
timestamps of each one of the two event types in the pair (lines 6-7). That is, the function
getAllTsOf, when called for a trace t and an event type ai, it will return a list of all the events
15

---

Algorithm 2 Extract Pairs
procedure Extract(lookback, split every days,traces)
newPairs ←empty list
for every trace in traces do
comb ←create all et-pairs
5:
for every (ai, aj) in comb do
tslistai ←trace.getAllTsOf(ai)
tslista j ←trace.getAllTsOf(a j)
tslast ←LastChecked[(ai,a j,trace.id)]
pairs ←Extract Pairs(tslistai, tslistaj, tslast, lookback)
10:
newPairs.append(pairs)
inter ←createIntervals(newPairs, split every days)
for every p in newPairs do
p.assignInterval(inter)
return newPairs
procedure extract pairs(tslistai, tslista j, tslast, lookback)
15:
if tslast is not null then
remove ts|ts < tslast, ts ∈tslistai ∨ts ∈tslista j
pairs ←empty list
for every tsi in tslistai do
find the first ts j in tslista j so
20:
(a) tsi ≤ts j
(b) ts j hasn’t been used as second event
(c) ts j-tsi ≤lookback
pairs.append(tsi,ts j)
return pairs
with that type in t (i.e. [ev.ts|, ev ∈t, ev.type = ai]). Next, to avoid recalculating already indexed
event-pairs, the algorithm retrieves the last timestamps of each event-pair per trace from the
LastChecked (line 8). The two lists with the timestamps that correspond to event types ai and
aj along with the last timestamp and the lookback parameter are passed to the Extract Pairs
procedure to generate the event-pairs.
Extract Pairs begins by pruning all the timestamps in both lists that are before the tslast.
Then, it parses through the timestamps in tslistai and for each tsi, it searches for a ts j from the
tslistaj that meets specific criteria: (a) it occurs after the former one, (b) it has not been used in
a previous pair as second timestamp, and (c) it occurs within a timeframe former the first one,
defined by the parameter lookback. When ai = a j, it holds that we can reuse aj. Once all the
pairs for each different key have been generated, the procedure creates a list of time intervals
(non-overlapping time-windows with a length defined by the parameter split every days), and
assigns each pair to one interval, based on the timestamp of the second event in the pair (lines
12-14).
5.3. Storage Optimizations
Minimizing the storage space also has a significant impact on response times, as the amount
of data that needs to be transferred from the database to the QP in order to answer a query pattern
is significantly reduced. The first step to optimize the storage space is to store the positions
of the events in a pair within a trace, instead of their exact timestamps. This simple change
16

---

BPI 2017
BPI 2018
BPI 2019
Synthetic
Events
1,202,267
2,514,266
1,595,923
1,000,000
Traces
31,509
43,809
251,734
10,000
Event Types
26
41
42
150
Mean
38.1
57.3
6.3
100
Min
10
24
1
50
Max
180
2973
990
150
Distribution
power-law
power-law
power-law
uniform
Table 2: Dataset characteristics
resulted in a significant reduction in storage space, as we replaced two strings of approximately
20 characters with two integers. The overall index building process remains unchanged, as both
timestamps and positions are available during preprocessing. For querying, there are only a few
modifications since the positions of events are mainly used to evaluate the occurrence of a pattern.
However, in cases where a pattern detection query involves time constraints, necessitating time
information, the original trace must be retrieved from the SequenceTable. Finally, to further
optimize storage space, we have implemented support for several compression algorithms in
SIESTA. These algorithms include Snappy [51], LZ4 [52], and ZSTD [53], which are supported
by both S3 and Cassandra. By using these algorithms, we can compress the data stored in the
indices, thereby reducing the amount of storage required.
6. Evaluation
Datasets. We selected the datasets from the Business Process Intelligence (BPI) Challenges
of 2017, 2018, and 2019 [54, 55, 56], as they contained the largest number of events compared
to other available datasets. In addition, we created a synthetic dataset with 10,000 traces and
1 million events spanning 150 different event types. The key characteristics of these 4 datasets
are presented in Table 2. Note that the synthetic dataset differs from the real-world ones in that
activities were randomly selected from a uniform distribution, unlike the real-world datasets,
which follow a power-law distribution.
Competitors. We evaluate our comprehensive implementation of SIESTA, containing the
extended query processor, utilizing both Cassandra and S3, against ELK and two other index-
based systems, namely Signatures [14] and Set-Containment [15], that can support arbitrary
pattern detection over big data. In our evaluation, we use ELK version v8.7.0, which supports
a wider variety of pattern detection queries than the previous versions. Signatures and Set-
Containment are the implementations of [14] and [15], respectively, on top of the SIESTA
framework. The code for these implementations, both for the index building and the integration
with the query processor, is publicly available6.
Furthermore, we assess the performance of two more systems, namely FlinkCEP and MATCH
RECOGNIZE (MR), during the query phase. We employed FlinkCEP version 1.17.1 and the
Trino implementation of MR (version 429) [8].
6https://github.com/mavroudo/SequenceDetectionPreprocess/tree/v2.1.1,
https://github.com/mavroudo/SequenceDetectionQueryExecutor/tree/v2.0.0
17

---

6.1. Incremental Indexing
In the first set of experiments, we evaluate the performance of incremental indexing. We test
all the datasets mentioned above and modify each logfile to last for one day, i.e. the difference
between the first event in the logfile and the last event being less than 24 hours. Next, we change
the trace ids so that 10% of the traces from one logfile continue to the logfile of the next day,
simulating a real-world scenario where millions of events are indexed every day. All experiments
were conducted on a small cluster comprising five machines: one with 64GB of RAM and 6 cores
(12 threads) running at 2.1 GHz, and four identical machines with 32GB of RAM and 6 cores (6
threads) running at 2.9 GHz. The network speed between the machines was 100Mbps. For all
systems that rely on the SIESTA framework, which will be referring as SIESTA-based from now
on, the database (Cassandra/MinIO-S3) and Spark Master both run on the first machine, with
30GB of RAM and 2 cores allocated to the former and 30GB of RAM and 4 cores to the latter.
Four Spark workers were deployed on the other four machines, each with full access to all local
resources. The ELK system ran in cluster mode on all five machines with complete control of
the available resources.
First, we investigate the impact of using S3 instead of Cassandra for the two different modes
of storing the positions (pos) or the timestamps (ts) in the IndexTable. Note for all the exper-
iments, we utilize the Snappy [51] compression algorithm for both databases. The results are
presented in Figure 4. As demonstrated in all four plots, Cassandra outperforms S3, and storing
positions is generally faster than storing timestamps.
More specifically, Figure 4 offers insights into the impact of various parameters on the in-
dexing process. We maintained a consistent 3-day lookback period for all experiments. The
split every days parameter was set to 5 for the real-world datasets and 30 for the synthetic
dataset. That is, the IndexTable was kept as a single table throughout the experiments for the
synthetic dataset, while it was split into two tables for the real-world dataset. For S3, we set
the trace split to match the number of traces in each log, ensuring each LastChecked partition
maintained records of approximately one dataset.
The key findings are as follows: (1) Cassandra’s indexing times consistently increased for
all datasets, with minimal influence from the split every days parameter. In contrast, S3 showed
promising signs of efficient incremental processing, particularly with shorter inverted lists. In
the real-world datasets, S3’s indexing time exhibited a drop on the 6th day and barely exceeded
the time of the previous (5th) day. This drop occurs because the new segment in the IndexTable
is generated on the 5th day, but some event-pairs need to be stored in the previous segment,
resulting in the observed improvement on the 6th day. (2) Even though the IndexTable in the
synthetic dataset remained unsplit, implying that S3 had to read and recreate the entire table daily,
S3 demonstrated nearly constant indexing times after the 4th day, especially when timestamps
were used. In contrast, Cassandra’s indexing time continued to rise. It is worth noting that
the synthetic dataset posed the most demanding scenario for SIESTA, with a larger volume of
event-pairs generated daily (35 million compared to 4 million in the real-world datasets). These
findings suggest that if this trend continues, S3 may eventually outperform Cassandra in terms
of indexing.
S3’s performance is largely attributed to its efficient compression. The use of immutable
parquet files for storing indices enables the preprocessing component to benefit from high com-
pression rates, saving time by minimizing network traffic. However, it is essential to consider
other factors such as required storage space, cost-efficiency, and query response times before
drawing conclusions.
18

---

0
2
4
6
8
Day
100
150
200
250
300
Time (s)
SIESTA-Cass-pos
SIESTA-Cass-ts
SIESTA-S3-pos
SIESTA-S3-ts
(a) BPI 2017
0
2
4
6
8
Day
100
200
300
400
500
Time (s)
SIESTA-Cass-pos
SIESTA-Cass-ts
SIESTA-S3-pos
SIESTA-S3-ts
(b) BPI 2018
0
2
4
6
8
Day
100
200
300
400
500
600
Time (s)
SIESTA-Cass-pos
SIESTA-Cass-ts
SIESTA-S3-pos
SIESTA-S3-ts
(c) BPI 2019
0
2
4
6
8
Day
0
500
1000
1500
2000
Time (s)
SIESTA-Cass-pos
SIESTA-Cass-ts
SIESTA-S3-pos
SIESTA-S3-ts
(d) synthetic
Figure 4: Indexing times for the different datasets during a 10 days period.
Dataset
S3-pos
Cass-pos
S3-ts
Cass-ts
BPI 2017
903
1,648
1,501
2,262
BPI 2018
1,320
2,580
2,002
3,331
BPI 2019
572
1,565
638
1,904
synthetic
4,920
12,249
9,709
16,129
Table 3: Size in mb at the end of indexing (after 10 days).
Table 3 displays the required storage space for storing all the indices for each dataset and
configuration at the end of the 10th day. The results indicate that S3 significantly benefits from
compression, requiring considerably less storage space than Cassandra for the same mode, with
space savings of up to 64%.
To conduct a more detailed cost analysis, we examined Amazon, one of the leading service
providers. We aimed to determine the cost an organization would incur to index the synthetic
dataset for 10 days using the position of the events and subsequently store the results for a month.
We explored the pricing options for both S3 and Keyspaces (equivalent to Cassandra) for a region
close to our university. For S3, the organization would pay 0.023$/GB stored per month. Since
data transfers to S3 are free and data transfers from S3 are billed after the first 100GB (after that
is 0.009$/GB), the total cost for the entire process would be 0.092$ (4 × 0.023). For Keyspaces,
the billing is based on write request units (WRUs) and read request units (RRUs). A WRU is
equivalent to storing one row of data of up to 1KB, while an RRU is equivalent to reading data
up to 8KB (LOCAL ONE consistency). The costs are 1.48$ for every million WRUs and 0.29$
for every million RRUs. The entire process requires 55.7 million WRUs and 4.9 million RRUs,
resulting in a total cost of 82.56$, plus 3.6$ to store the data for a month (0.3/GB$ per month).
Among the 55.7 million WRUs, LastChecked accounts for 49.5 million WRUs, since it contains
a large number of small rows (each row corresponds to a combination of et-pair and traceid).
19

---

0
2
4
6
8
Day
0
200
400
600
Time (s)
SIESTA-Cass-ts
Signatures
Set-Containment
SIESTA-S3-ts
ELK
(a) BPI 2018
0
2
4
6
8
Day
102
103
104
Time (s)
SIESTA-Cass-ts
Signatures
Set-containment
SIESTA-S3-ts
ELK
(b) synthetic
Figure 5: Indexing times for different datasets and various systems.
To reduce the cost, one could argue that instead of using a separate row for each combination,
multiple rows could be grouped based on the et-pair, resulting in only 12.3 million WRUs and
a total cost of 21.65 (17.76 for WRUs, 0.29 for RRUs, and 3.6 for storage). However, this
approach would require retrieving and combining data from the LastChecked every time, adding
an extensive overhead and resulting in much higher indexing times (detailed results are omitted).
These findings support the argument that S3 is a more cost-efficient solution for SIESTA, since
the savings are on the orders of magnitude. However, it remains to be seen how this affects query
response times, which will be evaluated in the next section.
In Figure 5, we present the indexing time for the various alternatives when indexing the
BPI 2018 and synthetic datasets. Note that the BPI 2018 dataset is almost twice as large as
the synthetic dataset. In both datasets, Set-Containment achieved the best performance. In the
synthetic dataset, where event types follow uniform distribution, SIESTA showed the worst per-
formance, followed by Signatures. This is because in the uniform distribution, there are more
event-pairs generated, as most of the events appear only once in each trace, and thus, the number
of the generated event-pairs is closer to n(n −1)/2. On the other hand, in the real-world datasets,
where the event types follow a power-law distribution, there may be multiple appearances of the
same event type in the trace, which decreases the number of event pairs thus speeding up the
indexing time of SIESTA. In the BPI 2018 dataset, SIESTA outperformed the state-of-the-art
system ELK showing faster indexing times, especially when Cassandra is utilized.
As a final remark, we can see that both implementations of SIESTA are applicable in real-
world scenarios, as they can effectively build the indices for the real-world data in under 7 min-
utes for 2.5 million new events for the BPI 2018 dataset on the 10th day.
6.2. Query Processor Experiments
In this section, we evaluate the response times of the different systems in pattern detection
queries. We execute 100 random queries for each experiment, with patterns that appear in at
least one trace. The queries were performed on the complete datasets presented in the previous
section. The experiments were conducted on the strongest machine among the five presented
before. We allocated 30GB of memory to the query processor of the SIESTA-based systems,
while the rest of the memory was reserved for the database. ELK, FlinkCEP, and MR were
executed on the same machine and had complete control over the available resources.
First, we evaluate the impact of database choice and mode on response times for pattern
detection queries using the synthetic dataset. The results, presented in Figure 6, show that for
20

---

S3-ts
S3-pos
Cass-ts
Cass-pos
System
0.0
2.5
5.0
7.5
10.0
12.5
15.0
17.5
20.0
Time (s)
Pruning
Validation
(a) |q| = 2
S3-ts
S3-pos
Cass-ts
Cass-pos
System
0
10
20
30
40
50
Time (s)
Pruning
Validation
(b) |q| = 10
Figure 6: Response times for the SIESTA variations for query lengths equal to 2 and 10.
smaller queries, Cassandra outperforms S3, while for larger queries, there is no noticeable differ-
ence. Storing positions performs better than storing timestamps in all setups, as the overhead of
transferring and deserializing event-pairs with timestamps outweighs the benefits of not having
to retrieve complete traces from the SequenceTable. For larger queries, with more et-pairs to
retrieve, responses are three times faster. Therefore, we will use positions for the remaining ex-
periments in this section. Furthermore, we also observed that the majority of time spent in query
answering is on fetching and pruning the traces rather than on validation. This suggests that
SIESTA is successful in pruning the search space of traces, particularly for queries of length 10,
where the retrieved traces are highly accurate and the validation step is completed quickly, tak-
ing only a few milliseconds. This effective pruning capability of SIESTA allows it to efficiently
incorporate SASE to support more expressive and complex queries.
We then proceeded to assess the performance of FlinkCEP and MR in pattern detection across
a continuously expanding sequence database. Figure 7 presents the average response times for
100 queries, of length equal to 5, performed by each system. These queries were conducted using
synthetic dataset in three distinct scenarios: (1) employing only the events from the first day, (2)
using events from the first 5 days, and (3) utilizing events from the full 10 days. Evidently,
SIESTA is highly scalable with respect to the data volume, regardless of the utilized database.
Furthermore, it is demonstrated that both FlinkCEP and MR struggle with large data volumes
due to their lack of an efficient index, necessitating a complete data scan for every query.
Next, we evaluate the query response times for SIESTA against the index-based competitors.
Simple pattern detection queries of length 2 and 10 were executed on the BPI 2019 dataset, with-
out constraints or more complex operators. Figure 8 shows that ELK yields the best performance
in the smaller queries, outperforming the other systems by two orders of magnitude. However,
for queries of length 10, it shows a big deviation in response times with a median performance
higher than SIESTA, which is rather insensitive to the event types in the query pattern. Set-
Containment has the highest response times, followed by Signatures. Using Cassandra shows a
greater deviation in response times, with the average time slightly better than S3. This may be
due to Cassandra’s caching mechanisms, allowing faster responses when data are already cached
in main memory. Figures 8c and 8d further demonstrate the effective pruning of search space by
SIESTA.
Following, we evaluate the performance of the various systems in more complex queries,
using the synthetic dataset to see if the data distribution affects response times. While all the
21

---

1
5
10
#Days indexed
0
5
10
15
20
25
30
Time (s)
SIESTA-Cass
SIESTA-S3
FlinkCEP
MATCH_RECOGNIZE
Figure 7: Response times for simple pattern detection queries utilizing the synthetic dataset.
SIESTA-Cass
SIESTA-S3
Signatures
Set-Containment
ELK
10
−1
10
0
10
1
10
2
Time (s)
(a) |q| = 2
SIESTA-Cass
SIESTA-S3
Signatures
Set-Containment
ELK
10
0
10
1
10
2
Time (s)
(b) |q| = 10
SIESTA-Cass
SIESTA-S3
Signatures
Set-Containment
0
25
50
75
100
Time (s)
Pruning
Validation
(c) |q| = 2
SIESTA-Cass
SIESTA-S3
Signatures
Set-Containment
0
25
50
75
100
Time (s)
Pruning
Validation
(d) |q| = 10
Figure 8: Response times for simple pattern detection queries utilizing the BPI 2019 dataset. (a,b): performance of all
systems. (c,d): difference between the pruning and the validation phase of all systems implemented on top SIESTA.
SIESTA-based systems can support the queries described in Section 4.3 due to their integration
22

---

SIESTA-Cass
SIESTA-S3
Signatures
Set-Containment
ELK
10
−1
10
0
10
1
10
2
Time (s)
(a) |q| = 2
SIESTA-Cass
SIESTA-S3
Signatures
Set-Containment
ELK
10
0
10
1
10
2
Time (s)
(b) |q| = 10
SIESTA-Cass
SIESTA-S3
Signatures
Set-Containment
0
10
20
30
Time (s)
Pruning
Validation
(c) |q| = 2
SIESTA-Cass
SIESTA-S3
Signatures
Set-Containment
0
5
10
15
20
Time (s)
Pruning
Validation
(d) |q| = 10
Figure 9: Response times for more complex pattern detection queries utilizing the synthetic dataset.
with SASE, ELK does not support certain operators. According to its documentation7, ELK uses
a state machine similar to CEP to detect matches. However, it cannot detect all the potential
matches as this operation deemed too slow and costly to be implemented in large datasets. ELK,
except for the traditional sequence operator, can also support the following operators: maxspan
(time-lapse between first and last event), until (similar to negation, but the search stops once this
event is found, while SASE will simply drop all the partial matches and continue searching) and
with runs (bounded Kleene+, between 1 and 100). Therefore, we generated the more complex
queries by randomly modifying 100 simple queries with equal parts of 15% negations, Kleene+,
and time constraints between the first and last event. Note that a query can have more than one
of these operators. The results are presented in Figure 9.
For the smaller queries, we observe a similar behavior as before, with ELK exhibiting the
best median performance. However, for bounded Kleene+ queries, ELK’s average response time
is 484.2 seconds, which are the outliers spotted in Figure 9a. Furthermore, for the |q|=10 queries,
most of the ELK queries timed out at 600 seconds. This is not the case for the SIESTA-based
systems that show a relatively constant behavior despite the complexity or the length of the query.
Figures 9c and 9d demonstrate that Set-Containment performs well for uniformly distributed
event types since the inverted lists have roughly the same size and are relatively small.
7https://www.elastic.co/guide/en/elasticsearch/reference/current/eql.html
23

---

1
2
3
4
5
uncertainty
0
5
10
15
20
Time (s)
2
5
10
k
0
5
10
15
20
Time (s)
(a) |q| = 3
1
2
3
4
5
uncertainty
0
500
1000
1500
2000
2500
Time (s)
2
5
10
k
0
500
1000
1500
2000
2500
Time (s)
(b) |q| = 5
Figure 10: Response times for various parameterizations in explainability for |q| = 3 (left) and |q| = 5 (right). Both
parameters uncertainty and k were set to 2 while the other was modified.
Based on the experiments described above, we can make the following observations. (1)
ELK is efficient in supporting small, simple queries. However, SIESTA-based systems with
SASE integration can handle a wider range of patterns and constraints, and can scale better,
making them suitable for a broader range of applications. (2) Among the SIESTA-based systems,
Signatures had the poorest performance, while Set-Containment has its best performance when
event types are uniformly distributed. Thus, in real-world settings, our SIESTA proposal seems
the most appropriate. (3) The experiments also showed that SIESTA’s indexing and pruning
mechanisms are effective in reducing the search space and enabling the application of SASE on
large data sets. (4) SIESTA’s response times scale well with query size, regardless of the dataset’s
characteristics, making it a suitable choice for big data applications. (5) Finally, the evaluation
showed that both Cassandra and S3 are viable options for storage. Cassandra provides better
indexing times and slightly faster responses, but it should only be preferred when deployed in-
house. On the other hand, S3 is much more cost-effective and it should be preferred for most
cloud-based deployments.
Finally, we conducted an evaluation of SIESTA’s explainability performance by executing
queries of lengths 3 and 5, adjusting both k and uncertainty. The results are presented in Fig-
ure 10. Notably, in both pattern lengths, the response time shows a direct correlation with the
uncertainty parameter. However, the k parameter plays a more pivotal role in the larger queries.
This is due to the increase of the possible modifications in a trace as the number of relevant
events grows, and the k parameter aids in the early termination of the process. Moreover, beyond
k and uncertainty, response times are influenced by the query’s length and the frequency of event
occurrences within the database. As the number of events in a query increases, more events are
24

---

retrieved, amplifying the impact of the uncertainty parameter. Additionally, if a specific event
type is infrequent in the indexed traces, even a substantial increase in uncertainty has minimal
impact on response times. While explainability enhances the user experience and fosters a better
understanding of query responses, it is crucial to note that it can significantly increase response
times, as evidenced in the query response times for |q| = 5. Therefore, fine-tuning is necessary
to balance these trade-offs.
7. Future Work
This work has demonstrated the ease of extending SIESTA with additional functionalities
and exploring alternative implementations. Therefore, in the future, it would be interesting to
further enhance the expressiveness of the supported queries, e.g. including nested operations or
support for more complex data schemas with embedded domain-specific information. Addition-
ally, exploring alternative storage options such as ScyllaDB 8 and TileDB 9 could contribute to
further improving overall performance.
An intriguing idea is to combine Object Storage System (OSS) with Delta Lake10 technology.
This approach offers several advantages. Firstly, it enhances the performance of the incremental
indexing in OSS, as it allows new events to be appended in parquet files and enforces ACID
properties [57]. Secondly, it allows for the seamless integration of streaming data, facilitating
the combination of real-time monitoring with SIESTA’s powerful pattern detection capabilities.
By incorporating streaming data into SIESTA, additional analytics can be utilized such as pre-
dictive maintenance and complex event forecasting, transforming SIESTA into a complete and
comprehensive system for efficiently managing logging in real-world organizations.
8. Conclusion
In this work, we present the SIESTA comprehensive and scalable framework that supports
cloud-native pattern detection with enhanced expressiveness, which is built on top of a pre-
liminary proof-of-concept of work on how to index and process event logs. By integrating a
state-of-the-art CEP engine, SASE, we enhance the expressiveness of SIESTA and enable the
provision of explanations for unexpected results. Additionally, we explore an alternative im-
plementation that utilizes an OSS instead of Cassandra. Furthermore, we provide a detailed
description of SIESTA’s incremental indexing approach, addressing the associated challenges.
We conduct thorough experiments using a large volume of data to demonstrate the superior scal-
ability and pattern detection capabilities of SIESTA compared to its competitors, including the
state-of-the-art ELK stack and FlinkCEP.
Acknowledgment. This research was financially supported by the European Union’s Horizon
Europe programme under the grant agreement No 101058174 (TRINEFLEX - Transformation
of energy intensive process industries through integration of energy, process, and feedstock flex-
ibility).
8https://www.scylladb.com/
9https://tiledb.com/
10https://delta.io/
25

---

References
[1] D. Abadi, A. Ailamaki, D. G. Andersen, P. Bailis, M. Balazinska, P. A. Bernstein, P. A. Boncz, S. Chaudhuri,
A. Cheung, A. Doan, L. Dong, M. J. Franklin, J. Freire, A. Y. Halevy, J. M. Hellerstein, S. Idreos, D. Kossmann,
T. Kraska, S. Krishnamurthy, V. Markl, S. Melnik, T. Milo, C. Mohan, T. Neumann, B. C. Ooi, F. Ozcan, J. M. Patel,
A. Pavlo, R. A. Popa, R. Ramakrishnan, C. R´e, M. Stonebraker, D. Suciu, The seattle report on database research,
Commun. ACM 65 (2022) 72–79. URL: https://doi.org/10.1145/3524284. doi:10.1145/3524284.
[2] P. Fournier-Viger, J. C.-W. Lin, R. U. Kiran, Y. S. Koh, R. Thomas, A survey of sequential pattern mining, Data
Science and Pattern Recognition 1 (2017) 54–77.
[3] Y. Diao, N. Immerman, D. Gyllstrom, Sase+: An agile language for kleene closure over event streams, UMass
Technical Report (2007).
[4] H. Zhang, Y. Diao, N. Immerman, On complexity and optimization of expensive queries in complex event pro-
cessing, in: Proceedings of the 2014 ACM SIGMOD international conference on Management of data, 2014, pp.
217–228.
[5] M. J. Zaki, SPADE: an efficient algorithm for mining frequent sequences, Machine learning 42 (2001) 31–60.
[6] P. Fournier-Viger, J. Chun-Wei Lin, T. Truong-Chi, R. Nkambou, A survey of high utility itemset mining, in:
High-utility pattern mining, Springer, 2019, pp. 1–45.
[7] I. Mavroudopoulos, T. Toliopoulos, C. Bellas, A. Kosmatopoulos, A. Gounaris, Sequence detection in event log
files., in: EDBT, 2021, pp. 85–96.
[8] Match recognize, 2022. URL: https://trino.io/docs/current/sql/match-recognize.html, accessed
on Nov 1, 2023.
[9] Match recognize
-
snowflake
documentation,
2022.
URL:
https://docs.snowflake.com/en/
sql-reference/constructs/match_recognize, accessed on Nov 1, 2023.
[10] A. S. Foundation, Flinkcep, 2021. URL: https://nightlies.apache.org/flink/flink-docs-stable/,
accessed: 16 May 2023.
[11] A. Chapman, H. V. Jagadish, Why not?, in: Proceedings of the 2009 ACM SIGMOD International Conference
on Management of Data, SIGMOD ’09, Association for Computing Machinery, New York, NY, USA, 2009, pp.
523–534. URL: https://doi.org/10.1145/1559845.1559901. doi:10.1145/1559845.1559901.
[12] J. Tan, T. Ghanem, M. Perron, X. Yu, M. Stonebraker, D. J. DeWitt, M. Serafini, A. Aboulnaga, T. Kraska, Choosing
A cloud DBMS: architectures and tradeoffs, PVLDB 12 (2019) 2170–2182.
[13] I. Mavroudopoulos, A. Gounaris, Siesta: A scalable infrastructure of sequential pattern analysis, IEEE Transactions
on Big Data (2022) 1–16. doi:10.1109/TBDATA.2022.3229092.
[14] A. Nanopoulos, Y. Manolopoulos, M. Zakrzewicz, T. Morzy, Indexing web access-logs for pattern queries, in:
Proceedings of the 4th international workshop on Web information and data management, 2002, pp. 63–68.
[15] D. Deng, C. Yang, S. Shang, F. Zhu, L. Liu, L. Shao, Lcjoin: set containment join via list crosscutting, in: 2019
IEEE 35th International Conference on Data Engineering (ICDE), IEEE, 2019, pp. 362–373.
[16] G. Cugola, A. Margara, Processing flows of information: From data stream to complex event processing, ACM
Comput. Surv. 44 (2012). URL: https://doi.org/10.1145/2187671.2187677. doi:10.1145/2187671.
2187677.
[17] M. Dayarathna, S. Perera,
Recent advancements in event processing,
ACM Comput. Surv. 51 (2018). URL:
https://doi.org/10.1145/3170432. doi:10.1145/3170432.
[18] N. Giatrakos, E. Alevizos, A. Artikis, A. Deligiannakis, M. Garofalakis, Complex event recognition in the big data
era: a survey, The VLDB Journal 29 (2020) 313–352.
[19] E. Wu, Y. Diao, S. Rizvi, High-performance complex event processing over streams, in: Proceedings of the 2006
ACM SIGMOD international conference on Management of data, 2006, pp. 407–418.
[20] R. Sadri, C. Zaniolo, A. Zarkesh, J. Adibi, Optimization of sequence queries in database systems, in: Proceedings
of the twentieth ACM SIGMOD-SIGACT-SIGART symposium on Principles of database systems, 2001, pp. 71–
81.
[21] A. J. Demers, J. Gehrke, B. Panda, M. Riedewald, V. Sharma, W. M. White, et al., Cayuga: A general purpose
event monitoring system., in: Cidr, volume 7, 2007, pp. 412–422.
[22] N. P. Schultz-Møller, M. Migliavacca, P. Pietzuch, Distributed complex event processing with query rewriting, in:
Proceedings of the Third ACM International Conference on Distributed Event-Based Systems, 2009, pp. 1–12.
[23] P. Carbone, A. Katsifodimos, S. Ewen, V. Markl, S. Haridi, K. Tzoumas,
Apache flink™: Stream and batch
processing in a single engine, IEEE Data Eng. Bull. 36 (2015).
[24] H. Zhang, Y. Diao, N. Immerman,
Recognizing patterns in streams with imprecise timestamps,
Infor-
mation Systems 38 (2013) 1187–1211. URL: https://www.sciencedirect.com/science/article/pii/
S0306437912000051. doi:https://doi.org/10.1016/j.is.2012.01.002.
[25] P. Carbone, M. Fragkoulis, V. Kalavri, A. Katsifodimos, Beyond analytics: The evolution of stream processing
26

---

systems, in: Proceedings of the 2020 ACM SIGMOD international conference on Management of data, 2020, pp.
2651–2658.
[26] S. Huang, E. Zhu, S. Chaudhuri, L. Spiegelberg, T-rex: Optimizing pattern search on time series, Proceedings of
the ACM on Management of Data 1 (2023) 1–26.
[27] M. Sahli, E. Mansour, P. Kalnis, Acme: A scalable parallel system for extracting frequent patterns from a very
long sequence, The VLDB Journal 23 (2014). doi:10.1007/s00778-014-0370-1.
[28] R. Grossi, A. Pietracaprina, N. Pisanti, G. Pucci, E. Upfal, F. Vandin, Madmx: A novel strategy for maximal dense
motif extraction, in: International Workshop on Algorithms in Bioinformatics, Springer, 2009, pp. 362–374.
[29] A. Apostolico, M. Comin, L. Parida, Varun: discovering extensible motifs under saturation constraints, IEEE/ACM
Transactions on Computational Biology and Bioinformatics 7 (2008) 752–762.
[30] A. Floratou, S. Tata, J. M. Patel, Efficient and accurate discovery of patterns in sequence data sets, IEEE Transac-
tions on Knowledge and Data Engineering 23 (2011) 1154–1168.
[31] A. M. Carvalho, A. L. Oliveira, A. T. Freitas, M.-F. Sagot, A parallel algorithm for the extraction of structured
motifs, in: Proceedings of the 2004 ACM symposium on Applied computing, 2004, pp. 147–153.
[32] J. M.-T. Wu, G. Srivastava, M. Wei, U. Yun, J. C.-W. Lin,
Fuzzy high-utility pattern mining in parallel and
distributed hadoop framework, Information Sciences 553 (2021) 31–48.
[33] L. Cao, Y. Yan, S. Madden, E. A. Rundensteiner, M. Gopalsamy, Efficient discovery of sequence outlier patterns,
Proceedings of the VLDB Endowment 12 (2019) 920–932.
[34] Y. Wu, Y. Wang, Y. Li, X. Zhu, X. Wu, Top-k self-adaptive contrast sequential pattern mining, IEEE transactions
on cybernetics (2021).
[35] J. Yin, Z. Zheng, L. Cao, Uspan: an efficient algorithm for mining high utility sequential patterns, in: Proceedings
of the 18th ACM SIGKDD international conference on Knowledge discovery and data mining, 2012, pp. 660–668.
[36] J. O. Aoga, T. Guns, P. Schaus, Mining time-constrained sequential patterns with constraint programming, Con-
straints 22 (2017) 548–570.
[37] J. Pei, J. Han, W. Wang, Constraint-based sequential pattern mining: the pattern-growth methods, Journal of
Intelligent Information Systems 28 (2007) 133–160.
[38] S. J. van Zelst, M. F. Sani, A. Ostovar, R. Conforti, M. La Rosa, Detection and removal of infrequent behavior
from event streams of business processes, Information Systems 90 (2020) 101451.
[39] Y. Huang, Y. Wang, Y. Huang, Filtering out infrequent events by expectation from business process event logs, in:
2018 14th international conference on computational intelligence and security (CIS), IEEE, 2018, pp. 374–377.
[40] V. Pasquadibisceglie, A. Appice, G. Castellano, D. Malerba, A multi-view deep learning approach for predictive
business process monitoring, IEEE Transactions on Services Computing (2021).
[41] B. Kang, D. Kim, S.-H. Kang, Real-time business process monitoring method for prediction of abnormal termina-
tion using knni-based lof prediction, Expert Systems with Applications 39 (2012) 6061–6068.
[42] C. D. Francescomarino, C. Ghidini,
Predictive process monitoring,
in: Process Mining Handbook, vol-
ume 448 of Lecture Notes in Business Information Processing, Springer, 2022, pp. 320–346. doi:10.1007/
978-3-031-08848-3\_10.
[43] M. Borkowski, W. Fdhila, M. Nardelli, S. Rinderle-Ma, S. Schulte, Event-based failure prediction in distributed
business processes, Information Systems 81 (2019) 220–235.
[44] A. Augusto, A. Awad, M. Dumas, Efficient checking of temporal compliance rules over business process event
logs, 2021. arXiv:2112.04623.
[45] Q. T. Tran, C.-Y. Chan, How to conquer why-not questions, in: Proceedings of the 2010 ACM SIGMOD Inter-
national Conference on Management of Data, SIGMOD ’10, Association for Computing Machinery, New York,
NY, USA, 2010, pp. 15–26. URL: https://doi.org/10.1145/1807167.1807172. doi:10.1145/1807167.
1807172.
[46] J. Huang, T. Chen, A. Doan, J. F. Naughton, On the provenance of non-answers to queries over extracted data, Proc.
VLDB Endow. 1 (2008) 736–747. URL: https://doi.org/10.14778/1453856.1453936. doi:10.14778/
1453856.1453936.
[47] M. Herschel, M. A. Hern´andez, Explaining missing answers to spjua queries 3 (2010) 185–196. URL: https:
//doi.org/10.14778/1920841.1920869. doi:10.14778/1920841.1920869.
[48] S. Song, R. Huang, Y. Gao, J. Wang, Why not match: On explanations of event pattern queries, in: G. Li, Z. Li,
S. Idreos, D. Srivastava (Eds.), SIGMOD ’21: International Conference on Management of Data, Virtual Event,
China, June 20-25, 2021, ACM, 2021, pp. 1705–1717. URL: https://doi.org/10.1145/3448016.3452818.
doi:10.1145/3448016.3452818.
[49] Y. Zhou, C. Ma, Q. Guo, L. Shou, G. Chen, Sequence pattern matching over event data with temporal uncertainty,
in: Proc. 17th International Conference on Extending Database Technology (EDBT), Athens, Greece, 2014, pp.
205–216.
[50] W. Cao, X. Feng, B. Liang, T. Zhang, Y. Gao, Y. Zhang, F. Li, Logstore: A cloud-native and multi-tenant log
database, in: G. Li, Z. Li, S. Idreos, D. Srivastava (Eds.), SIGMOD ’21: International Conference on Management
27

---

of Data, Virtual Event, China, June 20-25, 2021, ACM, 2021, pp. 2464–2476. URL: https://doi.org/10.
1145/3448016.3457565. doi:10.1145/3448016.3457565.
[51] Google, Snappy, 2011. URL: https://github.com/google/snappy.
[52] Y. Collet, Lz4, 2011. URL: https://github.com/lz4/lz4.
[53] Facebook, Zstd, 2016. URL: https://github.com/facebook/zstd.
[54] B. van Dongen,
Bpi challenge 2017,
2017. URL: https://data.4tu.nl/articles/dataset/BPI_
Challenge_2017/12696884/1. doi:10.4121/uuid:5f3067df-f10b-45da-b98b-86ae4c7a310b.
[55] B. van Dongen, F. F. Borchert, Bpi challenge 2018, 2018. URL: https://data.4tu.nl/articles/dataset/
BPI_Challenge_2018/12688355/1. doi:10.4121/uuid:3301445f-95e8-4ff0-98a4-901f1f204972.
[56] B.
van
Dongen,
Bpi
challenge
2019,
2019.
URL:
https://data.4tu.nl/articles/
dataset/BPI_Challenge_2019/12715853.
doi:https://doi.org/10.4121/uuid:
d06aff4b-79f0-45e6-8ec8-e19730c248f1.
[57] M. Armbrust, T. Das, L. Sun, B. Yavuz, S. Zhu, M. Murthy, J. Torres, H. van Hovell, A. Ionescu, A. Łuszczak, et al.,
Delta lake: high-performance acid table storage over cloud object stores, Proceedings of the VLDB Endowment
13 (2020) 3411–3424.
28

---

