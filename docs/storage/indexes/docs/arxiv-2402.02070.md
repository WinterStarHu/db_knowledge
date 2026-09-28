# HotRAP: Hot Record Retention and Promotion for LSM-trees with Tiered Storage

> 来源: https://arxiv.org/pdf/2402.02070

HotRAP: Hot Record Retention and Promotion for LSM-trees with Tiered Storage
Jiansheng Qiu
Tsinghua University
Fangzhou Yuan
Tsinghua University
Mingyu Gao
Tsinghua University
Huanchen Zhang
Tsinghua University
Abstract
The multi-level design of Log-Structured Merge-trees
(LSM-trees) naturally fits the tiered storage architecture: the
upper levels (recently inserted/updated records) are kept in
fast storage to guarantee performance while the lower levels
(the majority of records) are placed in slower but cheaper stor-
age to reduce cost. However, frequently accessed records may
have been compacted and reside in slow storage. Existing
algorithms are inefficient in promoting these “hot” records to
fast storage, leading to compromised read performance. We
present HotRAP, a key-value store based on RocksDB that can
timely promote hot records individually from slow to fast stor-
age and keep them in fast storage while they are hot. HotRAP
uses an on-disk data structure (a specially-made LSM-tree) to
track the hotness of keys and includes three pathways to en-
sure that hot records reach fast storage with short delays. Our
experiments show that HotRAP outperforms state-of-the-art
LSM-trees on tiered storage by up to 5.4× compared to the
second best under read-only and read-write-balanced YCSB
workloads with common access skew patterns, and by up to
1.9× compared to the second best under Twitter production
workloads.
1
Introduction
Log-Structured Merge-trees (LSM-trees) [19,30] are widely
adopted to build key-value stores [7,13,17,26] and database
storage engines [1,2,18,20,23] because of their superior write
performance. To achieve better cost efficiency, systems tend
to leverage the tiered storage by locating the upper levels of
the LSM-tree in fast local solid-state drives (SSDs) while
storing the lower levels (i.e., the majority of the records) in
slower but cheaper cloud storage or hard disk drives (HDDs).
Such a storage-tier separation is inherently efficient for the
write operations (i.e., inserts, updates, deletes) because the
append-only nature of the LSM-tree keeps the most recent
writes automatically in the fast storage. However, although
in typical workloads the records that are frequently accessed
are often correlated with those that are frequently updated,
the “read-hot” set and the “write-hot” set may not always
fully overlap. This leads to a majority of the read-hot records
sitting in slow storage with higher latency, thus compromising
the read performance of the LSM-tree.
The problem can be mitigated by caching frequently ac-
cessed records in memory, and prior studies have proposed
numerous caching algorithms [33,34,36,40,44]. However,
memory is often a limiting resource for systems [24,38,39],
and the size of hot records can be far larger than the memory
capacity (limitation 1). RocksDB, therefore, introduces the
secondary cache on fast SSDs for caching recently-accessed
data blocks [28, 42]. Solutions such as Mutant [37], Log-
Store [25], and MirrorKV [32] propose to adjust the place-
ment of blocks/SSTables across storage tiers periodically
according to their access frequencies. These approaches,
nonetheless, cannot fully leverage the capacity of the ex-
pensive fast storage because they move data at a coarse
granularity, where many cold records in the identified hot
blocks/SSTables are altogether piggybacked to the fast stor-
age (limitation 2). Moreover, the above solutions can only pro-
mote hot data to fast storage through LSM-tree compactions.
To deal with read-heavy workloads where compactions hap-
pen infrequently, several systems [25, 31] allow triggering
compactions proactively, but they must wait for the hot records
to accumulate in the slow storage before promoting them.
Such a delay harms read performance because it could over-
step the time window when a record is hot (limitation 3).
In this paper, we present HotRAP (Hot record Retention
And Promotion), an LSM-tree design based on RocksDB on
tiered storage. HotRAP can promote hot records timely from
the slow disk (abbr. as SD hereafter) to the fast disk (abbr. as
FD hereafter), and retain them in FD as long as they stay hot.
HotRAP addresses the aforementioned three limitations of
previous solutions. Figure 1 shows the big picture of HotRAP.
First, instead of tracking the record hotness in memory,
HotRAP logs each record access in a small specially-made
LSM-tree, called RALT (Recent Access Lookup Table), lo-
cated in FD (addressing limitation 1). RALT tracks the access
1
arXiv:2402.02070v3  [cs.DB]  19 Dec 2024

---

history for each logged key and maintains a hotness score for
the key using exponential smoothing. RALT then evicts low-
score keys periodically from itself to stay under a size limit
that can be automatically tuned according to the workload.
We choose LSM-tree to implement RALT in order to benefit
from its low write latency on disks because inserting access
records to it is on the critical path of lookups.
By utilizing RALT, HotRAP also supports hot record re-
tention and promotion at the record level rather than at the
block/SSTable level, thus preventing cold records from be-
ing piggybacked to FD (addressing limitation 2). Also, be-
sides waiting for LSM-tree compactions to retain/promote hot
records, HotRAP introduces a small in-memory promotion
cache to cache records read from SD and timely promotes the
hot ones (via checking RALT) by flushing them to the top of
the data LSM-tree (addressing limitation 3).
More specifically, HotRAP provides the following three
pathways for hot records to reside in FD: retention, promotion
by compaction, and promotion by flush. First, during com-
pactions from FD to SD, HotRAP checks the hotness of each
record in the selected SSTable in FD, and hot records are writ-
ten back to FD instead of merged down to SD, i.e., retention.
Second, an in-memory mutable promotion cache in HotRAP
is used to cache accessed records in SD. When the above
compaction from FD to SD happens, HotRAP also checks the
hotness of the records in the mutable promotion cache that
are within the compaction key range, and similarly handle
these records, writing the hot ones to FD and compacting
the others to SD. We call this path promotion by compaction.
Both the hotness checks in these two paths are facilitated
by RALT and can be efficiently performed mainly with se-
quential scans of corresponding key ranges. Third, when the
mutable promotion cache grows too big due to insufficient
compactions, we turn it into an immutable promotion cache
and trigger promotion by flush to bulk-insert the hot records in
the immutable promotion cache (also identified via consulting
RALT) to L0 of the LSM-tree. Thus we effectively restrict the
size of the promotion cache. To prevent promotion by flush
from overwriting records with a newer version (i.e., promot-
ing a stale record to L0 that has a higher level than the newly
updated version), we perform extra checks and carry out a
concurrency control mechanism to guarantee correctness.
We evaluated HotRAP using YCSB-based workloads and
Twitter production traces [35] on AWS instances with fast
local NVMe SSDs and slower cloud storage. We compare
HotRAP to the state-of-the-art LSM-trees on tiered stor-
age, e.g., Mutant [37] (promoting at the SSTable level),
SAS-Cache [42] (based on RocksDB with secondary block
cache [28]), and PrismDB [31] (proactively triggering com-
pactions). HotRAP achieves 5.4× speedup over the second
best for read-only YCSB workloads, 3.8× for read-write-
balanced YCSB workloads, and 1.9× for Twitter production
workloads, while maintaining competitive performance for
write-heavy and update-heavy YCSB workloads. Our exper-
Retain
hot records
Insert access
    records
Insert
key-value
mPC
immPC
If full
Promote by
compaction
Promote
by flush
Fast Disk
Slow Disk
RALT
Check hotness
of keys
Figure 1: The high-level picture of HotRAP. RALT is a
small LSM-tree in FD that tracks the hotness of keys. mPC
and immPC stand for the mutable and immutable promotion
caches. Hot records are retained in FD during compactions.
Records accessed in SD are inserted into the promotion cache
and then promoted by compaction or flush if they are hot.
iments also show that HotRAP adds < 1% overhead to the
plain RocksDB under uniform workloads and is robust against
hotspot shifts, where RALT quickly evicts stale access records
and adds keys in the new hotspot into the hot set.
We make three primary contributions in this paper. First,
we propose an on-disk data structure (i.e., RALT, a specially-
made LSM-tree) for tracking the hotness of key-value records.
Second, we design three pathways in a tiered LSM-tree for
timely promoting/retaining hot records to/in FD. Our algo-
rithm operates at the record level so that the system can effi-
ciently utilize the limited space of FD. Finally, we implement
HotRAP, a key-value store based on RocksDB that outper-
forms state-of-the-art LSM-trees on tiered storage because of
its efficient hot record tracking and movement features.
2
Background & Related Work
2.1
LSM-trees and tiered storage
A Log-Structured Merge-tree (LSM-tree) consists of an in-
memory buffer (i.e., MemTable) and multiple levels L0,...,Ln
on disk. The capacity of level Li is made T times larger than
Li−1, where T is called the size ratio of the LSM-tree. Records
are first inserted into MemTable. When MemTable is full, it
becomes immutable and then flushed to L0 as an SSTable (i.e.,
a file format called Sorted String Table). When level Li−1
reaches its capacity, it will trigger the compaction process to
merge its content into the next level Li. There are typically
two kinds of compaction policies: leveling and tiering. Level-
ing only allows one sorted run per level while tiering allows
multiple. This paper focuses on the leveling policy because
it is RocksDB’s default choice [26]. RocksDB also adopts
partial compaction: each compaction picks an SSTables from
Li−1 whose key range overlaps with a minimal number of
SSTables in Li to merge to the next level. Such a compaction
strategy leads to a write amplification of ≈nT
2 [12].
A lookup first checks the MemTable and then searches the
levels from top to bottom until a matching key is found. A
block index in memory is used to determine which SSTable
2

---

data block to search for a particular key in a sorted run. Per-
SSTable Bloom filters are used to reduce the number of can-
didate SSTables to further save I/Os. RocksDB provides snap-
shot isolation via multiversion concurrency control (MVCC)
to prevent compactions from blocking normal read operations.
A snapshot in RocksDB, called a superversion, is created after
a flush or compaction completes. An old snapshot is garbage
collected when no active queries refer to it.
Although many LSM-trees such as RocksDB are initially
designed for local SSDs, the multi-level nature of LSM-trees
is a good fit for the tiered storage architecture. The upper lev-
els contain the recently inserted and updated records and are
therefore kept in the fast storage such as local SSDs because
they are more likely to be accessed in the near future. To im-
prove the system’s cost efficiency, the majority of records in
the lower levels are placed in HDDs [14,15] or low-tier cloud
storage based on HDDs [16]. HDDs exhibit higher latency
than SSDs, but they are much cheaper. For example, the unit
price for a 20TB Seagate Enterprise HDD Exos X20 today
is 6.75× cheaper than a 7.68TB SAMSUNG Enterprise SSD
PM9A3 [4,5]. That means a tiered storage with a size ratio of
1:10 based on these hardware can reduce the storage cost by
77% compared to pure SSDs of the same capacity.
2.2
Hot/cold separation in LSM-trees
Tracking the access history of (potentially) hot records in
memory can incur a large footprint. According to the Twit-
ter trace [35], for example, 50% of the workloads have a
value size smaller than 5× the key size. We take the AWS
EC2 i4i.2xlarge instance for example, which is equipped with
64GB memory and an 1875GB local AWS Nitro SSD [3]. The
configuration reflects the typical memory-disk ratio in the in-
dustry. If 1TB of its local SSD is used to store hot records, we
need at least 1TB/(1+5) = 166.7GB memory to track those
hot keys, which exceeds the physical memory of the instance.
Mutant [37] tracks the access frequencies of SSTables
and adjusts their placement periodically to store the hottest
SSTables in the faster storage. LogStore [25] maintains his-
tograms in memory to track the hotness of SSTables and
retains/promotes hot SSTables in/to the faster storage. They
both separate hot/cold data in the granularity of SSTables,
which is too coarse because there can be considerable cold
data in the same SSTable that is considered hot.
RocksDB introduces the on-disk secondary cache for data
blocks not hot enough for the in-memory block cache [28].
SAS-Cache [42] further proposes several optimizations. How-
ever, the granularity of blocks is still too coarse because small
objects are prevalent in large-scale systems [24], and there
can be many cold tiny records in a hot data block. An alterna-
tive solution is to employ a separate on-disk key-value cache
(such as [9,24]) on top of the LSM-tree. But separate caches
incur extra disk I/O when updating, because it needs to update
the key in both cache and LSM-tree. It is also challenging to
ensure consistency between the cache and the LSM-tree.
MirrorKV [32] splits the LSM-tree into the key and value
LSM-tree and caches the hottest key SSTables in the faster
storage. Additionally, MirrorKV retains the hottest blocks
(e.g., 10%) during compactions from L1 to L2. Similarly, the
granularity of SSTables and blocks are both too coarse.
SA-LSM [41] accurately predicts cold data with survival
analysis and demotes cold records from the faster storage to
the slower storage. However, SA-LSM does not support pro-
moting hot records back to the faster storage, and the training
cost of the survival model is heavy.
PrismDB [31] estimates key popularity with the clock al-
gorithm, and the clock bits are indexed with a hash table.
Hot records are retained/promoted in/to the fast disk during
compactions. However, the hash table can consume consider-
able memory. Also, the promotion speed of PrismDB is slow
because it only promotes during compactions.
2-Tree [43] maintains two B-trees, one in the memory and
the other on the disk. It migrates hot records to the in-memory
B-tree and cold records to the on-disk B-tree. However, it
does not support tiered storage and the in-memory B-tree
consumes huge memory.
3
Design & Implementation
3.1
Overview
The overview of HotRAP is shown in Figure 2. There are
two components to facilitate retention and promotion: Recent
Access Lookup Table (RALT) and the promotion cache. RALT
is responsible for tracking the hotness of records. It maintains
a set of hot keys (without values) that are worth promoting
and retaining. The promotion cache consists of a mutable
promotion cache and a list of immutable promotion caches.
Records read from SD are inserted into the mutable promotion
cache. The mutable promotion cache is turned into immutable
when full. Immutable promotion caches are flushed to disk
as soon as possible. The mutable promotion cache resides
between the last level of FD and the first level of SD. To read
a key, HotRAP first searches in MemTables and levels in FD,
then searches in the mutable promotion cache, and at last
searches levels in SD.
When a record in FD is accessed ( I⃝), its key will be in-
serted into RALT to record the access ( II⃝). When a record
in SD is accessed ( 1⃝), HotRAP first inserts the key into the
mutable promotion cache ( 2⃝) (unless checks in §3.3 fail),
and the key’s hotness information in RALT is updated later.
Retention. During compactions from FD to SD ( 3⃝), Ho-
tRAP checks the hotness of each record to be compacted, and
retains the hot ones in FD. It does so by constructing a RALT
iterator whose range is the key range of FD’s input SSTables.
This iterator produces the hot records identified by RALT in
the order of keys. Therefore, we can advance the compaction
iterator and the RALT iterator in a sort-merge manner ( 4⃝), to
3

---

...
L0
Li
Li+1
③Compaction
⑤Retain
①Get
Get
Li-1
②Insert
I
mPC
…
K1 K2
K1
K3
immPC
Memory
RALT
④Scan hot keys
…
K3
K0
K3
K5 K6
⑥Extract records in range
⑧Promote hot records to FD
⑨
⑦Check & update
hotness of Ki
ⓑCheck & update
hotness of Kj
ⓐIf full
ⓒFlush hot records to L0
ⓓ
Insert
II
K0
K0 K1
…
K3
K3
K7
K3
Fast Disk
Slow Disk
Figure 2: Overview of HotRAP. mPC and immPC stand for the mutable and immutable promotion caches. Solid arrows are data
flow. Dashed arrows are control flow. The accessed keys in SD are firstly inserted into the mutable promotion cache ( 1⃝to 2⃝).
Hot records are retained in FD during compactions ( 3⃝to 5⃝). A compaction can piggyback hot records in its range to FD ( 6⃝to
9⃝). If the mutable promotion cache becomes full, hot records in it will be flushed to Level 0 ( a⃝to e⃝).
decide the records to retain and write them to new SSTables
in FD ( 5⃝). The I/O incurred by the RALT iterator is small
because RALT does not store values of HotRAP records.
Promotion by compaction. During the compaction be-
tween FD and SD, we also would like to promote the hot
records in SD to FD. Recall that the accessed records in SD
are cached in the in-memory promotion cache. We extract the
records from the mutable promotion cache that fall within the
compaction key range ( 6⃝), so that they could be handled to-
gether with this compaction. For the example in Figure 2, K1
and K2 are extracted. HotRAP consults RALT about whether
each key is hot, and updates the hotness score in RALT ac-
cordingly ( 7⃝). Hot records (K1) are written to the last level
in FD ( 8⃝). Cold records (K2) are dropped ( 9⃝) and future
lookups to them would go to SD. Actually, promotion by com-
paction could also be triggered by a compaction to a level in
FD. However, doing promotion during compactions at higher
levels of FD would require complex version control, because
the records in the promotion cache have older versions.
Promotion by flush. For read-heavy workloads, there may
not be enough compactions. In this case, promotion by com-
paction is insufficient to keep the mutable promotion cache
small. Therefore, when the size of the mutable promotion
cache grows to the target size of SSTables (64 MiB by de-
fault), HotRAP converts it to an immutable promotion cache,
and a new mutable promotion cache will be created ( a⃝). For
the example in Figure 2, K1 and K2 have been promoted by
compaction. Therefore, only K3,K5,... are packed into an im-
mutable promotion cache. The immutable promotion cache
consults RALT whether the records are hot ( b⃝). Hot records
(K3) will be flushed to L0 in FD ( c⃝), while cold records
(K5,K6) are dropped ( d⃝). To avoid creating tiny SSTables in
L0 which will trigger compactions from L0 to L1 prematurely,
L1
L2 .......
Ln
Access key user12345
(1) Insert access record
(2) Key hotness check
Y/N
(3)(4) Range queries
Iterators / range hot size
Unsorted buﬀer
Bloom ﬁlters
user12345
200
12
1
Value
length
Key
Tick
Score
Fast Disk
Memory
Figure 3: RALT structure. Suppose key user12345, whose
value length is 200B, is accessed in HotRAP and an access
record is inserted to RALT. The figure shows the RALT access
record format, as well as the four supported operations (1) to
(4). The current time slice sequence number for exponential
smoothing is 12. The HotRAP size is len(user12345) + 200
= 209 bytes. The physical size is (9+4)+(4×3) = 25 bytes,
where we use 4 bytes for the length of the key, and 4 bytes
each for the value length, tick, and score.
if the total size of hot records is less than half of the target
SSTable size, we insert them back into the mutable promotion
cache instead of flushing to L0.
3.2
Recent Access Lookup Table (RALT)
RALT is a lightweight LSM-tree on FD, logging the accesses
to records in HotRAP. Its structure is in Figure 3. Each access
record in RALT consists of the key, the length of the value
(instead of the value itself), and the scoring metadata tick and
score. Keys are considered hot if their scores are greater than
a threshold. We distinguish the size of the original key-value
4

---

record in HotRAP (called the HotRAP size) and the size of the
RALT access record itself (called the physical size). The total
HotRAP size of hot records is called the hot set size. RALT
has two parameters: the hot set size limit and the physical size
limit, which constrain the total size of hot records and the disk
usage of RALT itself, respectively. We set their values based
on workload characteristics in §3.7.
RALT supports four operations in Figure 3: (1) insert ac-
cess records; (2) check if a key is hot; (3) calculate the hot
set size in a range; (4) scan hot keys in a range. When Ho-
tRAP inserts an access record into RALT, it first goes into
an in-memory unsorted buffer. We use an unsorted buffer to
improve performance because a sorted memory table does
not benefit much: if a key is accessed again while its last
access record is in the buffer, it should be super hot and pro-
moted very fast. If the unsorted buffer is full, it is sorted and
flushed to FD. There are several levels on FD, following LSM-
tree leveling compaction. For hotness checking, RALT uses
in-memory bloom filters to avoid random disk reads. For cal-
culating range hot set size, RALT stores the prefix sum of the
HotRAP size of hot records in index blocks. The details are
explained below. For range scans, RALT constructs iterators
on each level, like other LSM-trees. To avoid blocking reads,
RALT maintains multiple versions of the LSM-tree structure.
If the hot set size or the disk usage of RALT exceeds the
limits, an eviction is triggered, in which RALT evicts β of
access records, and all access records are merged into a single
sorted run (see below). β = 10% is a trade-off between the
I/O cost and the stability of HotRAP’s hit rate.
Calculating scores. We use exponential smoothing [21] to
calculate scores in order to utilize history information. The
score for a key is defined as ∑N
i=1 aiαt−i where N is the num-
ber of time slices, t is the current time slice sequence number,
and ai = 1 if the key is accessed in the i-th time slice, ai = 0
otherwise. In every access record, we store a pair (tick,score)
for scoring, where tick = t is the current time slice sequence
number and score = ∑i aiαtick−i. RALT maintains the current
time slice sequence number t, and increments t every time af-
ter γ×(size of FD) data have been accessed. When the time
slice proceeds, we do not need to update the scores in al-
ready stored access records; the real score of an access record
(tick,score) can be obtained as αt−tick · score. Two records
(ticki,scorei),(tickj,scorej) with the same key may need to
be merged in RALT which is an LSM-tree. The merged record
(tick∗,score∗) becomes score∗= αtickj−ticki ·scorei +scorej
and tick∗= tickj, assuming ticki < tickj without loss of gen-
erality. We set γ to 0.001 and α to 1−γ = 0.999.
Eviction. If the hot set size or the physical size of RALT
exceeds the limit, RALT evicts β records. Ideally, we would
like to set a score threshold and evict access records with
scores smaller than it. However, since the records in RALT
are sorted by key, not by score, it is non-trivial to determine a
proper threshold. Instead, we use an approximate approach.
We formalize the problem as follows. Each record i has a
...
...
...
...
Record score
Sampled points
Sampled scores
Find the k-th largest sampled score:
Evict records whose scores < 6:
12
12
13
3 3
13
17
3
5
7
4
4
6
6
6
Records
...
Figure 4: Eviction in RALT. The length of records represents
their size (HotRAP size or physical size). The sampled points
are shown as stars in this virtual size space.
size Ai (either HotRAP size or physical size) and a score Si.
We denote the total size as A = ∑i Ai. β records will be evicted,
and the target size after eviction becomes A′ = (1−β)A. We
want to find a score threshold S′, so that records with scores
less than S′ are evicted, and the total size of records with
scores ≥S′ is approximately A′, i.e., ∑i∈RALT,Si≥S′ Ai ≈A′.
Our algorithm is illustrated in Figure 4. First, we sample
N numbers ai from the numerical range [0,A), and use a
full scan to find the corresponding record x of ai, defined as
∑j<x Aj ≤ai < ∑j≤x Aj; that is, the record that roughly sits at
the uniformly sampled position ai in the space of all records.
Then, the probability for a record i to be sampled is NAi/A.
According to the definition of S′, ∑Si≥S′ NAi/A ≈NA′/A, i.e.,
the expected number of sampled records with scores ≥S′ is
≈NA′/A = k. We thus pick the k-th largest score in sampled
records to be an approximation of S′.
We use this method to calculate the score thresholds for
the two size limits, respectively. Records with a score less
than the physical size score threshold are evicted from RALT.
Records with a score less than the hot set score threshold
but not less than the physical size score threshold are kept
but not considered hot. The hotness check and hot key scan
operations in RALT ensure this guarantee.
During eviction, RALT also merges all records. To limit
the temporary disk usage, RALT merges step by step. At each
step, it picks several unmerged SSTables in the largest level
and SSTables that overlap with them in other levels. It then
merges them and updates the version of RALT’s LSM-tree.
Checking hotness of a key. Searching keys by reading
from SSTables is expensive, so for each SSTable, RALT stores
bloom filters in memory that contain hot keys (keys with
scores higher than the threshold). When checking whether
a key is hot, RALT checks bloom filters at each level and
returns true if any bloom filter gives a positive result. We use
14-bit bloom filters to achieve a low overall false positive rate
(≪1%). The small number of false positives does not affect
performance. Thus we do not perform second-verification.
Calculating the hot set size in a range. RALT needs to
calculate the hot set size in a given range, for HotRAP to
select which SSTable to compact (details in §3.5). Similar to
a normal LSM-tree, we have data blocks and index blocks for
SSTables. For each data block, its first key and the sum of
5

---

the HotRAP size of hot keys in all previous data blocks are
added to the index block. For a range query, at each level, we
read the two edge index blocks and calculate the difference
of their stored sums, to obtain the total HotRAP size of hot
keys in the range. The results of all levels are summed up and
returned, as an estimation of the hot set size in the range.
The above result is slightly overestimated because of two
error sources. First, the total HotRAP size of hot keys in
the one or two edge data blocks is small, so we choose to
tolerate the error and not read them. Second, there may be
duplicate keys in different levels. If the number of levels
is small and the size ratio between levels is large, we can
expect the overestimation rate to be small. For example, if the
size ratio is 10, the result in the second largest level may be
about 1/10 of the result in the largest level on average. So
the overestimation is only about 10%. §3.5 discusses how we
handle such overestimation in HotRAP.
Memory usage and I/O cost. Bloom filters and index
blocks are cached in memory. Suppose HotRAP record size is
200B and 5% keys are hot, then the memory usage of bloom
filters in RALT is 5% × 14/8/200 = 0.0438% of the data
size. Suppose the key length is about 20B. Then the size of an
index block record is less than 40B. The size of a data block
in RALT is 16KiB. Therefore, the memory usage of index
blocks is 5% × 40/16/1024 = 0.0122% of the data size. In
total, the memory usage is only 0.056% of the data size.
For I/O cost, suppose RALT has NL levels, and the size
ratio is T. Since we evict β of data each time, the total write
amplification is T
2 NL + 1
β. The total read amplification is
T
2 NL + 2
β because we need two full scans to calculate the
score threshold and evict records. In our experiments in §4.4,
T = 10,β = 10%,NL ≈2, the read amplification is about 30
while the write amplification is about 20. The experiment re-
sults show that RALT is only responsible for 5.5%–12.7% of
total I/O, because a RALT record does not contain the value
in a HotRAP record, therefore the total I/O of RALT is small
compared to HotRAP.
3.3
Checks before inserting to promotion
cache
The promotion cache resides between FD and SD. Therefore,
before promoting a record into the promotion cache, it is cru-
cial to verify the absence of a newer version of this record
in SD, which would otherwise be shielded by the inserted
older record in the promotion cache. For a point read that
wants to insert the latest version just retrieved from SD into
the promotion cache, it is known that no newer version ex-
ists in the same superversion (i.e., the LSM-tree’s snapshot).
However, it is still possible that a newer version of the record
is compacted into SD before the previous record has finished
being inserted into the promotion cache.
To address this issue, HotRAP marks SSTables as being
.......
L0
Li
Li+1
mPC
Mut
Imms
FD
SD
①Get
K1
RALT
⑤Hot? ⑥Y/N
⑦
ⓑ
⑧Check
ⓒ
⑪Flush
⑨
②Insert
immPC
③If full
ⓐIf full
④     Take
snapshot
Hot record refs
Updated
⑩
FD
Mem
Figure 5: Concurrency control of promotion by flush. Pro-
cesses with lock icons are protected by the DB mutex lock.
8⃝ensures that no newer versions exist in the snapshot of the
LSM-tree. a⃝to c⃝insert all updated keys in immutable pro-
motion caches into their updated fields. Records with updated
keys are excluded in 9⃝. The snapshot is taken ( 4⃝) after the
creation of the immutable promotion cache ( 3⃝), therefore, a
key updated before 9⃝is either found out by 8⃝or by a⃝– c⃝.
or having been compacted when setting up compaction jobs.
During the client access, SD SSTables whose range contains
the key are recorded. Before inserting a record into the promo-
tion cache, HotRAP checks if any of the recorded SSTables is
being or has been compacted. If there is, HotRAP aborts the
insertion. The abort rate is low because of the small number of
compaction jobs. Our experiments show that this check only
aborts less than 1% of insertions into the promotion cache.
3.4
Concurrency control of promotion by flush
Now we discuss the details of promotion by flush in Figure 5.
As mentioned before, a read to SD record ( 1⃝) inserts it to
the mutable promotion cache ( 2⃝), which may be later made
immutable when full ( 3⃝). At this point, a snapshot is taken by
incrementing the reference count of the caller’s superversion
( 4⃝). We pass the immutable promotion cache’s reference and
the superversion’s reference to a background thread called
Checker, who handles the rest part. This minimizes the impact
on foreground reads. Checker then picks out hot records in
the immutable promotion cache by consulting RALT ( 5⃝to
7⃝). These hot records are candidates to be flushed to L0.
Proper concurrency control is needed to avoid the issue
that flushing a hot record to L0 may shield a newer version of
this key in the FD levels. Checker looks for newer versions
of the hot records in the snapshot’s immutable MemTables
and the levels in FD ( 8⃝). Hot records without newer versions
are packed into a new immutable MemTable ( 9⃝)1. The im-
mutable promotion cache can be deleted now (10
⃝). Those
records will eventually be flushed into L0 (11
⃝).
However, there is still a corner case: newer versions can
be flushed into L0 in the normal access path when HotRAP
1Or inserted back into the mutable promotion cache if there are too few
of them.
6

---

is looking for newer versions during step 8⃝. To address this
issue, HotRAP attaches an updated field to each immutable
promotion cache. When a mutable MemTable becomes im-
mutable during normal accesses ( a⃝), for every record in it,
HotRAP checks whether the same key exists in the immutable
promotion caches ( b⃝), and if so, HotRAP inserts the key into
the updated field of the corresponding immutable promotion
cache ( c⃝). The records whose keys exist in the updated field
will not be packed into the immutable MemTable at step 9⃝.
To ensure that the list of immutable promotion caches does
not change during the creation of immutable MemTables at
step
a⃝so that the updated fields are comprehensive, we
create immutable promotion caches with the DB mutex (the
only major lock in RocksDB) held at step 3⃝. Since flushes
are protected by the DB mutex, there are only two possible
cases and both are correct: (1) An immutable MemTable is
created before an immutable promotion cache is created. The
newer versions of records in the immutable MemTable will
be detected by the check of 8⃝. (2) An immutable promotion
cache is created before an immutable MemTable is created.
The newer versions of records in the immutable MemTable
will be added to the updated field and detected by a⃝to c⃝.
3.5
How to pick an SSTable to compact
When a level reaches its capacity, we pick an SSTable
and merge it into the next level. Typically, we calculate
a score for each SSTable and pick the one with the high-
est score. For example, RocksDB defines the score as
FileSize/OverlappingBytes by default, in which Overlapping-
Bytes represents the total size of the target level’s SSTables
whose key ranges overlap with the key range of the picked
SSTable. This is essentially a cost-benefit trade-off score: File-
Size is the benefit, and (FileSize+OverlappingBytes) is the
cost, in which FileSize is optimized out.
However, the cost-benefit score needs some adjustment to
better support HotRAP. During a cross-tier compaction from
FD to SD in HotRAP, hot records in the chosen SSTable
will be retained in the source level. Therefore, the benefit
becomes (FileSize−HotSize), and the cost is still (FileSize+
OverlappingBytes). Their ratio is the new cost-benefit score.
HotRAP estimates the HotSize of an SSTable by query-
ing RALT about the hot set size in the corresponding range
(§3.2). Recall that the obtained HotSize is an overestimation.
Therefore, it is possible, although very unlikely, that all bene-
fit values are zero. In this case, HotRAP falls back to choose
the oldest SSTable for compaction.
3.6
Write amplification of retention
Suppose the fraction of cold data in the last level of FD is
p. Since each compaction from FD to SD only compacts p
of selected data to SD and writes remaining (1−p) of data
back to FD, 1
p× more compactions are needed to compact
the same amount of data. Therefore, suppose the size ratio of
the LSM-tree is T, FD and SD respectively have nFD and nSD
levels, the write amplification in FD is T
2 nFD + 1−p
p
and the
write amplification in SD is T
2p + T
2 (nSD −1), which are 1−p
p
and T
2p −T
2 larger than a normal LSM-tree, respectively.
Write amplification can be lowered by tuning the level size
ratios. Specifically, we can shrink the first level of SD to make
the size ratio between the last level of FD and the first level of
SD be pT. To keep the size of the LSM-tree in SD unchanged,
we can add an extra level after the last level with a size ratio
of 1
p. The size ratio between other levels in SD remains T. In
this way, the write amplification in SD is T
2 nSD + 1
2p, which
is only 1
2p larger than a normal LSM-tree.
3.7
Auto-tuning
In §3.2, RALT takes 2 parameters: the hot set size limit and the
physical size limit, to constrain the total size of hot records and
the space of RALT itself, respectively. However, the hot set
size is determined by the distribution of the workload, which is
usually unknown to the user and may further dynamically vary
over time. Hence we propose an automatic tuning approach
to estimate the most suitable hot set size and physical size.
We assume each key k has an access probability of pk. For
skewed workload distributions, we can set a hot key threshold
pt, and find all the keys with pk ≥pt. When pt is given, this
is a “frequent items” problem, with several known solutions
like counter-based methods [22, 29] or sketch-based meth-
ods [10]. However, counter-based methods need to maintain
a large amount of counters, and sketch-based methods also
use expensive data structures. We proposed a novel algorithm
that can dynamically calculate the hot size with small storage
overheads and can be implemented by slightly modifying the
RALT record format and compaction/eviction strategies.
Our algorithm to update the two size limits is summarized
in Algorithm 1. We maintain a counter c and a tag t in each
RALT access record. Records with c > 0 and t = 1 are consid-
ered stable; otherwise unstable. The first access to a key sets
c = ∆c and t = 0. A hit on an existing key increments c by ∆c
(capped at cmax) and activates t = 1 to be stable. Similar to
the score calculation in §3.2, records with the same keys are
merged during compaction. Every time when the accessed
data amount (in terms of the HotRAP size) reaches a limit R
(e.g., the size of FD), we decrement all counters by 1, which
eventually makes cold records become no longer stable. The
maximum counter value cmax ensures that cold keys can be
evicted after accessing at most cmax ·R data.
Old unstable records are evicted when the hot set size
or physical size exceeds the limit. If the size is still too
large, records with low scores will continue to be evicted
following the eviction process in §3.2. After each eviction,
we also update the two limits as depicted in Lines 18 to
21 in Algorithm 1. Here we have several pre-determined
7

---

Algorithm 1 Algorithm for updating hot set size limit
1: Let the set of tracked keys T ←∅
2: for each access ki do
3:
if ki ∈T then
4:
cki ←min(cki +∆c,cmax)
5:
tki ←1
6:
else
7:
T ←T ∪{ki}
8:
cki ←∆c
9:
tki ←0
10:
end if
11:
if accessed data amount reaches R then
12:
forall ki ∈T do cki ←max(cki −1,0)
13:
end if
14:
if hot set size limit or physical size limit is exceeded then
15:
Evict k from T with either ck or tk is 0
16:
If not enough, evict k with low scores
17:
% Update size limits.
18:
t ←HotRAP size of stable records
19:
p ←Physical size of stable records
20:
Hot set size limit ←max(Lhs,min(t +Dhs,Rhs))
21:
Physical size limit ←p+rDhs
22:
end if
23: end for
parameters. Lhs and Rhs are the lower and upper bounds of
the hot set size; Dhs is the maximum allowed HotRAP size
of unstable records. Their values in our implementation are
listed at the end of this subsection. Essentially, we set the
hot set size limit to be the size of stable records plus Dhs,
subject to constraints of the two bounds. Finally, r is the
average ratio between physical size and HotRAP size, i.e.,
RALT access record size/key-value record size. The physi-
cal size limit is thus r times of the hot set size limit.
Our algorithm ensures that if we set ∆c and cmax carefully,
and accesses are identically distributed and independent, then
almost all hot keys will become stable, while the size of stable
cold keys is bounded. We have formally proved these prop-
erties, but we omit the proof due to space limit. Intuitively,
because of the tag t, we need to access an originally unstable
key at least two times with less than Dhs other data accessed
in between, in order to make it stable during R amount of
data accessed. While the difference between ∑k is hot pk and
∑k is cold pk may not be large enough due to the very large
number of cold keys, the difference between ∑k is hot p2
k and
∑k is cold p2
k is typically large enough to separate them apart.
Implementation details. We set Lhs = 0.05 × FD size,
Rhs = 0.7×FD size, Dhs = 0.1×Rhs, R = Rhs. We set ∆c =
2.6,cmax = 5, pt =
1
0.5×FD size. With these parameters, ac-
cording to our analysis, the HotRAP size of cold keys with
pk < 0.1× pt is smaller than 0.5×FD size, which is accept-
able. The probability of each hot key becoming stable is at
least 98%. The experiments are shown in §4.6.
Limitation. The algorithm keeps unstable records of Ho-
tRAP size Dhs to detect hot records. It assumes that hot
Table 1: Disk performance on our EC2 instances.
Fast Disk
Slow Disk
Type
AWS Nitro SSD
gp3
16 threads rand 16K read IOPS
≈83000
10000
Sequential read bandwidth
≈1.4GiB/s
1000MiB/s
Sequential write bandwidth
≈1.1GiB/s
1000MiB/s
Table 2: Read-write ratios of YCSB workloads in our tests.
Notation
Meaning
Read-write ratio
RO
read-only
100% read
RW
read-write
75% read, 25% insert
WH
write-heavy
50% read, 50% insert
UH
update-heavy
50% read, 50% update
records are accessed randomly, so that every hot record has
a probability > 0 to be detected. If a hot record is accessed
once every > Dhs accesses, then it cannot be captured. In the
extreme case, such as “sequential flooding”, the algorithm
cannot work unless increasing Dhs. But this is uncommon in
real-world datasets (for example, the Twitter trace in §4.3).
4
Evaluation
4.1
Experimental setup
Testbed. We evaluate HotRAP on AWS EC2 i4i.2xlarge in-
stances running Debian 12. Each instance has 8 vCPU cores,
64GiB memory, and a 1875GB local AWS Nitro SSD. We
use local SSDs as FD and gp3 as SD, with their performance
shown in Table 1. Since HDD RAID arrays can achieve thou-
sands of IOPS and high throughput [6], we set the maximum
IOPS and throughput of gp3 to 10000 and 1000MiB/s respec-
tively to simulate the most performant HDD RAID arrays.
Sizes of tiers. We set the space ratio between tiers to 10:
the expected used size of FD is set to 10GB and the initial
expected used size of SD is set to 100GB.
Compared systems. We compare HotRAP with Mutant [37],
PrismDB [31], SAS-Cache [42], and following two variants of
RocksDB. RocksDB-FD stores all data in FD, which is used
to indicate the upper-bound performance that HotRAP can
achieve. RocksDB-tiered tunes its size ratios between levels
so that the total size of FD levels becomes 10GB, which is
the same as HotRAP. Mutant, PrismDB, and SAS-Cache are
also tuned to use about 10GB of FD expectedly.
Configurations. All experiments run with 16 threads. The
block size of all systems is set to 16KiB following Meta’s
practice [27]. The maximum number of background jobs is set
to 6 for HotRAP and RocksDB. To minimize the impact of the
file system cache, direct I/O is used for HotRAP, RocksDB,
and PrismDB, for fair comparison. For Mutant, since it is
difficult to enable direct I/O due to its old version of RocksDB,
we limit its memory with systemd-run to reduce the page
cache size. Auto-tuning of HotRAP is turned on. We set the
8

---

RO
RW
WH
UH
(a) hotspot-5%
0
5
10
15
Operations per second
×104
RO
RW
WH
UH
(b) zipfian
0
5
10
15
×104
RO
RW
WH
UH
(c) uniform
0
5
10
15
×104
RocksDB-FD
RocksDB-tiered
Mutant
PrismDB
SAS-Cache
HotRAP
Figure 6: Throughput comparison with 1KiB record size.
RO
RW
WH
UH
(a) hotspot-5%
0
4
8
12
Operations per second
×104
RO
RW
WH
UH
(b) uniform
0
1
2
3
×104
RocksDB-FD
RocksDB-tiered
HotRAP
Figure 7: Throughput comparison with 200B record size.
RO
RW
WH
(a) 99%
0.0
2.5
Latency (ms)
RO
RW
WH
(b) 99.9% (log scale)
100
101
RocksDB-FD
RocksDB-tiered
Mutant
PrismDB
SAS-Cache
HotRAP
Figure 8: Get tail latency comparison under hotspot-5% work-
loads with 1KiB record size.
initial hot set size limit and RALT physical size limit to 50%
and 15% of the FD size respectively. The secondary cache
size of SAS-Cache is set to 6GB. HotRAP is configured with
a 128MiB block cache, while other systems are configured
with 64MiB more block cache to compensate for the memory
usage of RALT. All systems are configured with 10-bit bloom
filters. Other configurations are set to their default values.
4.2
Performance on YCSB workloads
To assess the performance of HotRAP under various key dis-
tributions and read-write ratios, we evaluate HotRAP with
the YCSB workloads [11] shown in Table 2. RO (read-only)
tests the effectiveness of promotion. RW (read-write) and WH
(write-heavy) test the effectiveness of retention. UH (update-
heavy) is the worst case for HotRAP. With UH, the key distri-
butions of reads and updates are the same. Therefore, newer
versions of read-intensive records are frequently inserted into
the database and flushed into FD, making the proactive pro-
motion of HotRAP barely needed.
We test three skewness types: hotspot-5%, Zipfian, and
uniform. In the hotspot-5% distribution, 5% of records are ac-
cessed by 95% operations uniformly. The other 5% operations
uniformly access the other 95% of records. In the Zipfian dis-
tribution, the access probability of the k-th hottest record is
proportional to 1/ks [8]. In our experiments, s = 0.99. In the
uniform distribution, the access probability of all records is
the same. We evaluate two record sizes, 1KiB (≈24B key and
1000B value) and 200B (≈24B key and 176B value).
All workloads consist of the load phase and the run phase.
The load phase loads 110GB of records into the LSM-tree.
The run phase executes read/write operations. We focus on
the performance of the run phase. For workloads with 1KiB
records, the run phase executes 2.2 × 108 operations. For
200B records, the run phase executes 1.1×109 operations.
Figures 6 and 7 compare the average throughput (over
the final 10% of the run phase) of evaluated systems under
different read-write ratios and skewness types, with 1KiB and
200B records, respectively. Since the trends are similar, we
only show a representative subset in Figure 7 to save space.
Under both record sizes, the performance of HotRAP when
running hotspot-5% workloads is close to that of the ideal
RocksDB-FD, because HotRAP promotes almost all hot data
into FD and achieves about 95% hit rate. Compared to other
systems, HotRAP achieves 5.4× speedup over the second
best for read-only (RO) workloads, and 3.8× for read-write-
balanced workloads (RW). On the other hand, HotRAP is only
0.4% slower than RocksDB-tiered under uniform workloads,
showing the overhead of HotRAP is low when promotion
has no benefits. For the Zipfian distribution, there is a notice-
able gap in Figure 6 between HotRAP and the upper-bound
RocksDB-FD, because the hit rate is lower (79%) compared
to hotspot-5%. But HotRAP still outperforms other designs.
For the three baseline designs, Mutant and SAS-Cache
show negligible improvements compared to RocksDB-tiered,
because their data promotion granularity is too coarse: data
blocks for SAS-Cache and SSTables for Mutant. PrismDB
also only has small improvements over RocksDB-tiered due
to its inefficient promotion mechanism.
9

---

0.0
0.2
0.4
0.6
0.8
1.0
# of reads on hot records / # of reads
0.0
0.2
0.4
0.6
0.8
1.0
# of reads on sunk records / # of reads
read-heavy
read-write
write-heavy
Figure 9: Characteristics of Twitter production traces. Each
point stands for a cluster’s trace. Dark black points are our
selected traces for evaluation in Figure 10.
0.0
0.2
0.4
0.6
0.8
1.0
# of reads on hot records / # of reads
0.0
0.2
0.4
0.6
0.8
1.0
# of reads on sunk records / # of reads
02
2.13x
10
1.04x
11
2.32x
16
2.08x
17
5.27x
18
4.06x
19
1.08x
22
2.98x
23
0.98x
29
0.95x
37
1.02x
46
0.96x
48
2.20x
52
2.67x
53
2.78x
read-heavy
read-write
write-heavy
0.9
1.0
2.0
3.0
4.0
5.0
6.0
Figure 10: Speedup of HotRAP over RocksDB-tiered on Twit-
ter production traces. Numbers on the two sides of a point are
the cluster ID and the speedup. Traces with bold cluster IDs
are selected for further analysis in Figure 11.
Among different read-write ratios, we notice that all sys-
tems exhibit higher throughput under the update-heavy (UH)
workloads. This is because the updated data have a skewed
distribution, and thus update operations can be considered as
promotions to FD. However, PrismDB and SAS-Cache per-
form relatively poorly in this case. PrismDB suffers from lock
contention and inefficient random writes to FD. SAS-Cache
has its secondary cache frequently evict and promote data
blocks, thus incurring significant FD I/O.
Figure 8 shows the tail latencies (again over the final 10%
of the run phase) under hotspot-5% workloads with 1KiB
record size. When running read-heavy workloads (RO & RW),
HotRAP achieves lower tail latency than other systems except
RocksDB-FD. In these cases, HotRAP has higher FD hit rates
and thus reduces accesses to SD, so there are proportionally
fewer long-latency accesses affected by the SD tail latency
among all FD and SD accesses.
11
17
19
16
53
10
29
Cluster ID
0
5
10
15
20
Operations per second
×104
RocksDB-FD
RocksDB-tiered
PrismDB
SAS-Cache
HotRAP
Figure 11: Throughput comparison under several Twitter pro-
duction traces.
4.3
Performance on real-world Twitter traces
To show the performance of HotRAP under real-world work-
loads, we evaluate HotRAP with the Twitter production
traces [35]. We pre-process every trace into two phases: the
load phase and the run phase. In the load phase, we ignore
reads and keep inserting about 110GB of data. In the run
phase, we execute 5 × 108 operations. We augment small
traces by repeating operations until reaching 110GB of data.
For example, if a trace has 40GB of data, we repeat each op-
eration 3 times, e.g., an operation “INSERT user1” becomes
“INSERT 0user1, INSERT 1user1, INSERT 2user1”.
Traces are categorized based on their read proportions: read-
heavy has >75% reads; read-write has >50% and ≤75%
reads; write-heavy has ≤50% reads. In some traces, it is com-
mon for a frequently read key to be also frequently updated.
Proactively promoting this key has little benefit because its
newer version will be automatically inserted into FD. We
define that a read is performed on a sunk record if the data
amount written since the last update of its key is greater than
5% of the DB size, so that the latest version is now likely
sunk to SD when being read. For example, suppose we first
update keys A,C,D,B, then we read key A. If the total size of
records C,D,B is greater than 5% of the DB size, then we say
A is sunk when being read. Similarly, we define that a read is
performed on a hot record if the data amount read since the
last read of this record is less than 5% of the DB size, so that
the record is likely to be identified as hot. If there are many
reads on such sunk and hot records, then it is necessary to
promote them to FD.
Figure 9 shows the categories and proportion of reads on
sunk/hot records in the Twitter traces. We select some rep-
resentative traces to evaluate the speedup of HotRAP over
RocksDB-tiered in Figure 10. HotRAP performs better when
the proportions of reads on sunk and hot records are higher,
e.g., achieving up to 5.27× speedup under the trace of cluster
17. On the other hand, HotRAP is not significantly slower
than RocksDB-tiered under traces with low proportions of
reads on sunk and hot records, showing its low overhead.
We further analyze several traces with high (11, 17), middle
10

---

RO
RW
WH
UH
(a) hotspot-5%
0
2
4
CPU time (seconds)
×104
RocksDB-FD
HotRAP
RO
RW
WH
UH
(b) uniform
0
2
4
CPU time (seconds)
×104
RocksDB-tiered
HotRAP
Read
Insert
Compaction
Checker
RALT
Others
Figure 12: CPU time breakdown with 200B record size.
RO
RW
WH
UH
(a) hotspot-5%
0
10
20
I/O (TB)
RocksDB-FD
HotRAP
RO
RW
WH
UH
(b) uniform
0
10
20
I/O (TB)
RocksDB-tiered
HotRAP
Get in SD
Get in FD
Compaction in SD
Compaction in FD
RALT
Others
Figure 13: I/O breakdown with 200B record size.
(19, 16, 53), and low (10, 29) proportions of sunk record reads
and show their throughput in Figure 11. Mutant is not shown
because it incurs too much FD usage (>30GB) when execut-
ing several traces. HotRAP is almost always the best among
compared systems, and achieves up to 1.9× speedup over
the second best. When the proportion of sunk record reads
is lower, almost all systems perform better, but the speedup
of HotRAP also becomes smaller. At middle and high pro-
portions of sunk record reads, if we increase the amount of
hot record reads, HotRAP throughput would significantly in-
crease, while PrismDB and SAS-Cache perform moderately
better, and RocksDB-tiered does not benefit from it at all.
PrismDB performs extremely badly under cluster 10 trace
because this trace uniformly reads recently updated keys
which are still in FD. Therefore PrismDB identifies almost all
data in FD as hot and retains them. As a result, when FD gets
full, PrismDB can only demote a few keys to SD, and it has
to trigger demotion repeatedly to keep FD usage under the
limit. The frequent demotion contends for locks with reads
and thus causes severe performance degradation.
4.4
Cost breakdown
Figures 12 and 13 show the breakdown of CPU time and I/O
for the run phase of YCSB workloads with 200B record size.
The size of RALT here is more than 1GB, which needs to be
Table 3: Promotion costs with/without retention under the RW
hotspot-5% workload with 1KiB record size.
Version
Promoted
Retained
Compaction
Hit rate
HotRAP
6.2GB
40.2GB
2346.1GB
94.5%
no-retain
35.1GB
0.0GB
3038.6GB
71.4%
Table 4: Promotion costs with/without hotness checking under
the RO uniform workload with 1KiB record size.
Version
Promoted
Retained
Compaction
HotRAP
1.2GB
0.0MB
26.6GB
no-hotness-check
205.8GB
9.0GB
6645.1GB
stored in FD instead of memory. The results show that RALT
is only responsible for 3.7%–13.3% of total CPU time and
5.5%–12.7% of total I/O, hence the design is efficient.
In the hotspot-5% workloads, HotRAP incurs more CPU
time and I/O on compaction than RocksDB-FD, because reten-
tion increases write amplification. In the uniform workloads,
HotRAP consumes more CPU time than RocksDB-tiered
because most accesses are in SD and thus the records are
inserted into the promotion cache. However, few records are
promoted into FD due to the hotness checking ( 7⃝& b⃝in
Figure 2), therefore they have similar compaction I/O.
Figure 14 shows the breakdown of device throughput under
the RW (75% read, 25% insert) hotspot-5% workload. Ho-
tRAP promotes and retains hot records in FD. Therefore, the
number of Get operations served by FD increases over time,
raising the total throughput of Get until it is close to that of
RocksDB-FD. Most Get operations in RocksDB-tiered are
served by SD, which bounds its total Get throughput.
4.5
Effectiveness of individual techniques
To show the effectiveness of retention, we remove the reten-
tion mechanism from HotRAP and call the design no-retain.
Table 3 shows that no-retain incurs more promotion costs
and achieves a lower final hit rate than HotRAP. The rea-
son is that although no-retain still promotes records into FD,
the promoted records are compacted into SD again during
compactions. Therefore, hot records have to be promoted
repeatedly, with much more promotion traffic.
HotRAP only promotes hot records to reduce the overhead
introduced by promotion. To show its effectiveness, we re-
move hotness checking and promote all accessed records. Ta-
ble 4 shows that under uniform workloads, no-hotness-check
promotes 173.0× more records and thus incurs 248.4× more
compaction I/O than HotRAP.
4.6
Performance on dynamic workload
To show that HotRAP can adapt to changes in the access pat-
tern, we evaluate it under a dynamic workload. The details of
the dynamic workload and the results are shown in Figure 15.
11

---

0
1000
2000
3000
(a) RocksDB-FD
0
1000
Throughput (MB/s)
Time (Seconds)
0
5000
10000
15000
(b) RocksDB-tiered
0
200
Time (Seconds)
0
2000
4000
(c) HotRAP
0
1000
Time (Seconds)
FD
SD
FD-Compaction
SD-Compaction
Get
Figure 14: Device throughput breakdown under the RW (75% read, 25% insert) hotspot-5% workload with 1KiB record size.
For readability, throughput is averaged every 200 seconds. Get is the measured throughput of disk reads during Get operations,
which is an indicator of end-to-end performance.
0
5
Size (GB)
Hotspot shifts
Hotspot size
Hot set size
0.0
0.5
1.0
Hit rate
Hotspot shifts
0.0
0.5
1.0
1.5
2.0
Completed operation count
×109
0.0
2.5
5.0
Operations per second
×104
Hotspot shifts
Figure 15: HotRAP under dynamic workload. The run phase
consists of nine stages, whose data distributions are first uni-
form, then hotspot-2% →4% →6% →8% →5% →5% →
3% →1%. Each stage executes 2.2×108 read operations. The
two 5% hotspots in the 6th and 7th stages are non-overlapping.
When the hotspots increase from 2% to 8%, the new hotspot
completely contains the old hotspot. When they decrease, the
new one is completely contained by the old one.
The hot set starts from 5GB. The first stage has a uniform
distribution, so there are few stable records, and the hot set
size limit decreases to the minimum value 0.5GB. At the sec-
ond stage, the key distribution becomes hotspot-2%. With the
auto-tuning method in §3.7, HotRAP gradually increases the
hot set size limit until all hotspot keys are added to the hot set.
Eventually, the hot set size stabilizes around the hotspot size.
After the hotspot expands from 2% to 4% and from 4% to
6%, the FD hit rate temporarily drops because new hot keys
are not yet promoted. Then HotRAP gradually increases the
hot set size limit until all new hot keys are added to the hot
set, thus recovering the hit rate. After the hotspot expands
from 6% to 8%, the hotspot size exceeds the max hot set size
(7GB). Therefore, the performance of HotRAP is relatively
low. When the hotspot shifts, HotRAP reacts adaptively by
evicting old hot keys after they become unstable, and gradu-
ally adding new hot keys to the hot set. Both the throughput
and the hit rate recover eventually. After the hotspot shrinks
from 5% to 3% and from 3% to 1%, the throughput and the
hit rate do not drop because new hot keys are already con-
sidered hot and have already been promoted. Nevertheless,
HotRAP in this case could decrease the hot set size limit after
old access records become unstable.
In summary, the results show that the auto-tuning mech-
anism enables HotRAP to find the most suitable hot set
size limit under a dynamic workload with hotspot expand-
ing, shrinking, and shifting.
5
Conclusion
We introduced HotRAP, an LSM-tree-based key-value store
on tiered storage. Unlike previous solutions, HotRAP adopts
an efficient on-disk hotness tracker, along with fine-grained
record-level retention and promotion mechanisms that inde-
pendently operate besides LSM-tree compactions. These tech-
niques allow HotRAP to move data efficiently across tiers
to fully utilize the fast storage for keeping hot records even
under read-heavy workloads.
References
[1] Apache cassandra, 2009.
https://cassandra.
apache.org.
[2] Scylladb, 2015.
https://github.com/scylladb/
scylladb.
12

---

[3] Amazon ec2 instance types, 2024.
https://aws.
amazon.com/ec2/instance-types/.
[4] Samsung pm9a3 2.5" u.2 7.68tb pcie 4.0 x4 nvme
1.4 v-nand tlc enterprise solid state drive, 2024.
https://www.newegg.com/p/N82E16820147858?
Item=9SIA12KJA14195.
[5] Seagate
exos
x20
st20000nm007d
20tb
7200
rpm
256mb
cache
3.5"
internal
hard
drive,
2024.
https://www.newegg.com/
seagate-exos-x20-st20000nm007d-20tb/p/
N82E16822185011?Item=N82E16822185011.
[6] Standard raid levels, 2024. https://en.wikipedia.
org/wiki/Standard_RAID_levels.
[7] Tikv is a highly scalable, low latency, and easy to use
key-value database, 2024. https://tikv.org/.
[8] Zipf’s law, 2024.
https://en.wikipedia.org/
wiki/Zipf%27s_law.
[9] Benjamin Berg, Daniel S Berger, Sara McAllister, Isaac
Grosof, Sathya Gunasekar, Jimmy Lu, Michael Uhlar,
Jim Carrig, Nathan Beckmann, Mor Harchol-Balter, et al.
The {CacheLib} caching engine: Design and experi-
ences at scale. In 14th USENIX Symposium on Oper-
ating Systems Design and Implementation (OSDI 20),
pages 753–768, 2020.
[10] Moses Charikar, Kevin Chen, and Martin Farach-Colton.
Finding frequent items in data streams. In International
Colloquium on Automata, Languages, and Program-
ming, pages 693–703. Springer, 2002.
[11] Brian F Cooper, Adam Silberstein, Erwin Tam, Raghu
Ramakrishnan, and Russell Sears. Benchmarking cloud
serving systems with ycsb. In Proceedings of the 1st
ACM symposium on Cloud computing, pages 143–154,
2010.
[12] Niv Dayan, Tamar Weiss, Shmuel Dashevsky, Michael
Pan, Edward Bortnikov, and Moshe Twitto. Spooky:
granulating lsm-tree compactions correctly. Proceed-
ings of the VLDB Endowment, 15(11):3071–3084, 2022.
[13] Siying Dong, Mark Callaghan, Leonidas Galanis,
Dhruba Borthakur, Tony Savor, and Michael Strum. Op-
timizing space amplification in rocksdb. In CIDR, vol-
ume 3, page 3, 2017.
[14] Siying Dong, Andrew Kryczka, Yanqin Jin, and Michael
Stumm. Evolution of development priorities in key-
value stores serving large-scale applications: The
{rocksdb} experience. In 19th USENIX Conference on
File and Storage Technologies (FAST 21), pages 33–49,
2021.
[15] Siying Dong, Andrew Kryczka, Yanqin Jin, and Michael
Stumm. Rocksdb: Evolution of development priorities
in a key-value store serving large-scale applications.
ACM Transactions on Storage (TOS), 17(4):1–32, 2021.
[16] Siying Dong, Shiva Shankar P, Satadru Pan, Anand
Ananthabhotla, Dhanabal Ekambaram, Abhinav Sharma,
Shobhit Dayal, Nishant Vinaybhai Parikh, Yanqin Jin,
Albert Kim, et al. Disaggregating rocksdb: A production
experience. Proceedings of the ACM on Management
of Data, 1(2):1–24, 2023.
[17] Google.
Leveldb, 2011.
https://github.com/
google/leveldb.
[18] Dongxu Huang, Qi Liu, Qiu Cui, Zhuhe Fang, Xiaoyu
Ma, Fei Xu, Li Shen, Liu Tang, Yuxing Zhou, Menglong
Huang, et al. Tidb: a raft-based htap database. Proceed-
ings of the VLDB Endowment, 13(12):3072–3084, 2020.
[19] HV Jagadish, PPS Narayan, Sridhar Seshadri, S Sudar-
shan, and Rama Kanneganti. Incremental organization
for data recording and warehousing. In VLDB, pages
16–25, 1997.
[20] Cockroach Labs.
Cockroachdb, 2015.
https://
github.com/cockroachdb/cockroach.
[21] Justin J Levandoski, Per-Åke Larson, and Radu Stoica.
Identifying hot and cold data in main-memory databases.
In 2013 IEEE 29th International Conference on Data
Engineering (ICDE), pages 26–37. IEEE, 2013.
[22] Gurmeet Singh Manku and Rajeev Motwani. Approxi-
mate frequency counts over data streams. In VLDB’02:
Proceedings of the 28th International Conference on
Very Large Databases, pages 346–357. Elsevier, 2002.
[23] Yoshinori Matsunobu, Siying Dong, and Herman Lee.
Myrocks: Lsm-tree database storage engine serving face-
book’s social graph. Proceedings of the VLDB Endow-
ment, 13(12):3217–3230, 2020.
[24] Sara McAllister, Benjamin Berg, Julian Tutuncu-Macias,
Juncheng Yang, Sathya Gunasekar, Jimmy Lu, Daniel S
Berger, Nathan Beckmann, and Gregory R Ganger. Kan-
garoo: Caching billions of tiny objects on flash.
In
Proceedings of the ACM SIGOPS 28th Symposium on
Operating Systems Principles, pages 243–262, 2021.
[25] Prashanth Menon, Thamir M Qadah, Tilmann Rabl, Mo-
hammad Sadoghi, and Hans-Arno Jacobsen. Logstore:
A workload-aware, adaptable key-value store on hybrid
storage systems. IEEE Transactions on Knowledge and
Data Engineering, 34(8):3867–3882, 2020.
[26] Meta.
Rocksdb: A persistent key-value store for
flash and ram storage, 2012. https://github.com/
facebook/rocksdb/.
13

---

[27] Meta.
Memory
usage
in
rocksdb, 2021.
https://github.com/facebook/rocksdb/wiki/
Memory-usage-in-RocksDB.
[28] Meta.
Secondarycache
(experimental), 2022.
https://github.com/facebook/rocksdb/wiki/
SecondaryCache-(Experimental).
[29] Ahmed Metwally, Divyakant Agrawal, and Amr El Ab-
badi. Efficient computation of frequent and top-k ele-
ments in data streams. In International conference on
database theory, pages 398–412. Springer, 2005.
[30] Patrick O’Neil, Edward Cheng, Dieter Gawlick, and Eliz-
abeth O’Neil. The log-structured merge-tree (lsm-tree).
Acta Informatica, 33:351–385, 1996.
[31] Ashwini Raina, Jianan Lu, Asaf Cidon, and Michael J
Freedman. Efficient compactions between storage tiers
with prismdb. In Proceedings of the 28th ACM Inter-
national Conference on Architectural Support for Pro-
gramming Languages and Operating Systems, Volume
3, pages 179–193, 2023.
[32] Zhiqi Wang and Zili Shao. Mirrorkv: An efficient key-
value store on hybrid cloud storage with balanced per-
formance of compaction and querying. Proceedings of
the ACM on Management of Data, 1(4):1–27, 2023.
[33] Fenggang Wu, Ming-Hong Yang, Baoquan Zhang, and
David HC Du. Ac-key: Adaptive caching for lsm-based
key-value stores. In 2020 USENIX Annual Technical
Conference (USENIX ATC 20), pages 603–615, 2020.
[34] Xingbo Wu, Li Zhang, Yandong Wang, Yufei Ren,
Michel Hack, and Song Jiang. zexpander: A key-value
cache with both high performance and fewer misses. In
Proceedings of the Eleventh European Conference on
Computer Systems, pages 1–15, 2016.
[35] Juncheng Yang, Yao Yue, and K. V. Rashmi. A large
scale analysis of hundreds of in-memory cache clusters
at twitter. In 14th USENIX Symposium on Operating
Systems Design and Implementation (OSDI 20), pages
191–208. USENIX Association, November 2020.
[36] Lei Yang, Hong Wu, Tieying Zhang, Xuntao Cheng,
Feifei Li, Lei Zou, Yujie Wang, Rongyao Chen, Jiany-
ing Wang, and Gui Huang. Leaper: A learned prefetcher
for cache invalidation in lsm-tree based storage engines.
Proceedings of the VLDB Endowment, 13(12):1976–
1989, 2020.
[37] Hobin Yoon, Juncheng Yang, Sveinn Fannar Kristjans-
son, Steinn E Sigurdarson, Ymir Vigfusson, and Ada
Gavrilovska. Mutant: Balancing storage cost and la-
tency in lsm-tree data stores. In Proceedings of the
ACM Symposium on Cloud Computing, pages 162–173,
2018.
[38] Huanchen Zhang, David G Andersen, Andrew Pavlo,
Michael Kaminsky, Lin Ma, and Rui Shen. Reducing the
storage overhead of main-memory oltp databases with
hybrid indexes. In Proceedings of the 2016 International
Conference on Management of Data, pages 1567–1581,
2016.
[39] Huanchen Zhang, Hyeontaek Lim, Viktor Leis, David G
Andersen, Michael Kaminsky, Kimberly Keeton, and
Andrew Pavlo. Surf: Practical range query filtering with
fast succinct tries. In Proceedings of the 2018 Inter-
national Conference on Management of Data, pages
323–336, 2018.
[40] Jianshun Zhang, Fang Wang, and Chao Dong. Halsm:
A hotspot-aware lsm-tree based key-value storage en-
gine. In 2022 IEEE 40th International Conference on
Computer Design (ICCD), pages 179–186. IEEE, 2022.
[41] Teng Zhang, Jian Tan, Xin Cai, Jianying Wang, Feifei Li,
and Jianling Sun. Sa-lsm: optimize data layout for lsm-
tree based storage using survival analysis. Proceedings
of the VLDB Endowment, 15(10):2161–2174, 2022.
[42] Chang Guo Zhang Cao, Ziyuan Lv, Anand Ananthab-
hotla, and Zhichao Cao. Sas-cache: A semantic-aware
secondary cache for lsm-based key-value stores. In The
38th International Conference on Massive Storage Sys-
tems and Technology (MSST 2024), 2024.
[43] Xinjing Zhou, Xiangyao Yu, Goetz Graefe, and Michael
Stonebraker. Two is better than one: The case for 2-tree
for skewed data sets. memory, 11:13, 2023.
[44] Yuanhui Zhou, Jian Zhou, Shuning Chen, Peng Xu, Peng
Wu, Yanguang Wang, Xian Liu, Ling Zhan, and Jiguang
Wan. Calcspar: A contract-aware lsm store for cloud
storage with low latency spikes. In 2023 USENIX An-
nual Technical Conference (USENIX ATC 23), pages
451–465, 2023.
14

---

