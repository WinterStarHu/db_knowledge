# Enlightening Flash Storage to Stream Writes by Objects

> 来源: https://arxiv.org/pdf/2201.04409

Enlightening Flash Storage to Stream Writes by Objects
Jong-Hyeok Park Gihwan Oh Sang-Won Lee
Sungkyunkwan University Suwon, Korea
{akindo19,wurikiji,swlee}@skku.edu
ABSTRACT
For a write request, today’s flash storage cannot distinguish the
logical object it comes from. In such object-oblivious flash devices,
concurrent writes from different objects are simply packed in their
arrival order to flash memory blocks; hence objects with different
lifetimes are multiplexed onto the same flash blocks. This multi-
plexing incurs write amplification, worsening the performance.
Tackling the multiplexing problem, we propose a novel interface
for flash storage, FlashAlloc. It is used to pass the logical address
ranges of logical objects to the flash storage and thus enlighten
the storage to stream writes by objects. The object-aware flash
storage can de-multiplex writes from different objects with dis-
tinct deathtimes into per-object dedicated flash blocks. Given that
popular data stores separate writes using objects (e.g., SSTables in
RocksDB), we can achieve, unlike the existing solutions, transparent
write streaming just by calling FlashAlloc upon object creation. Our
experimental results using an open-source SSD prototype demon-
strate that FlashAlloc can reduce write amplification factor (WAF)
in RocksDB, F2FS, and MySQL by 1.5, 2.5, and 0.3, respectively
and thus improve throughput by 2x, 1.8x, and 1.2x, respectively. In
particular, FlashAlloc will mitigate the interference among multi-
tenants. When RocksDB and MySQL were run together on the same
SSD, FlashAlloc decreased WAF from 4.2 to 2.5 and doubled their
throughputs.
1
INTRODUCTION
Most software systems, including LSM (Log-Structured-Merge)
tree-based KV (Key-Value) stores, relational DBMSs, and file sys-
tems manage data using logical objects: to name a few, SSTables in
RocksDB, DWB (double write buffer) in MySQL, and segments in
F2FS. And, upon each object creation, its logical space is secured in
advance before writes are made to the object. For instance, RocksDB
calls fallocate() right after creating an SSTable file so as to se-
cure the logical address space for the file. The logical address range
allocated from the call belongs to the file object. For this reason,
from an LBA address, the host-side data stores can identify its be-
longing object. In addition, when an object is deleted, all its data
will be invalidated together at once; thus the data set belonging to
an object is said to have the same deathtime. Meanwhile, different
objects are, though created and populated simultaneously, usually
destructed at different points in time; they have different death-
times. In summary, host software stacks manage data by objects;
each object is the unit of logical space allocation and, in many cases,
all its pages will have the same deathtime.
Though host software stacks can distinguish objects by their
logical address ranges, the host-side semantic about objects’ logical
address ranges cannot cross the storage interface wall simply be-
cause no interface exists to pass it to the storage. As a result, today’s
flash storage has no knowledge about the belongs-to relationship be-
tween LBA address and object. Therefore, when concurrent writes
Figure 1: Object Placement: Multiplexing vs. Clustering
from different objects interleave, the conventional object-oblivious
flash storage cannot distinguish each write’s object so that it has
no choice but to simply append new data in their arrival order
into flash blocks. As a consequence, writes from different objects
colocate in the same flash blocks. That is, each flash block will be
multiplexed by data from multiple objects with different deathtimes,
as illustrated in Figure 1. We call this situation as multiplexing.
The multiplexing is the main culprit of physical write amplifi-
cation in flash storage, worsening the performance and lifespan
of flash storage. Since logical objects have different deathtimes
each other in most cases (e.g., four SSTables in Figure 1 will be
deleted at different points of time), pages in a multiplexed flash
block will be incrementally invalidated at different points of time.
When the block is chosen as a victim for garbage collection, the
remaining valid pages have to be relocated to another block, am-
plifying physical writes inside flash storage. In particular, contrary
to the common belief, the multiplexing will make even RocksDB
and F2FS taking sequential write patterns suffer from severe device-
level write amplification [7, 36, 39]. According to our experiments
using commercial SSDs, write amplification factor (WAF in short)
becomes even greater than eight (Figure 2(b)). In this sense, the
so called flash-friendly sequential writes are not less harmful than
random ones in the conventional flash storage [26]. In addition, the
multiplexing can exacerbate the performance interference in multi-
tenant environment [1]. When multiple applications, each with
its set of objects, are run together on a flash device, more objects
with more deviating deathtimes will be multiplexed onto the same
flash blocks, worsening write amplification. To sum up, since no
interface exists to offload the host semantic about objects’ logical
address range to the storage, the valuable semantic is discarded and
the object-oblivious flash device can not stream writes by objects,
incurring multiplexing and write amplification.
Addressing the multiplexing problem, we propose a novel inter-
face, FlashAllocate (FlashAlloc in short), which is used to pass the
arXiv:2201.04409v1  [cs.DB]  12 Jan 2022

---

Jong-Hyeok Park Gihwan Oh Sang-Won Lee
host semantic about object’s logical address range to the flash stor-
age and thus to enlighten the storage to be object-aware in handling
writes. To be concrete, after creating an object, a data store calls
FlashAlloc with the object’s local address range as a parameter to
inform the flash device that the address range belongs to the same
object. Then, upon receiving FlashAlloc, the flash device creates a
corresponding FlashAlloc (FA in short) instance, which keeps the
given range information and thus is now aware of the address range
of the object. At the same time, the flash device will secure physical
flash block(s) where to place writes from the object and dedicate
those blocks to the FA instance. Hereafter, the logical address range
of an FlashAlloc call has its corresponding physical space. For each
write request, flash storage probes its matching FA instance, if
it exists, using the starting LBA address of the request and then
stream the write to the dedicated blocks for the FA instance.
Once logical objects are FlashAlloc-ed, their writes will be, as illus-
trated in the right bottom of Figure 1, de-multiplexed into per-object
dedicated flash blocks. In this regard, we say that flash storage, en-
lightened by FlashAlloc, can stream writes by objects. The write
streaming by objects is a natural way to achieve grouping data by
deathtime [14] because logical objects have different deathtimes
while all pages of an object become dead together at once upon the
object destruction. Thus, the ultimate benefit of streaming writes
by objects is to avoid GC-induced write amplification. For instance,
as each SSTable file is deleted in Figure 1, all its pages are invali-
dated, and thus, its dedicated block can be erased in its entirety, not
causing any page relocation. In summary, FlashAlloc provides an
alternative in controlling the physical placement of writes inside flash
devices: it enables to de-multiplex logical objects into the different
flash block(s) just resorting to the already-existing host-side object
semantic and thus without introducing other intermediate concepts
such as stream-id or zone-id [3, 17].
Whilst effectively de-multiplexing objects with sequential write-
once pattern, FlashAlloc is not a panacea for the write amplification
problem. In particular, FlashAlloc is not intended to be used for ob-
jects with random overwrites (e.g., relational database’s tablespace
under OLTP workload). For non-FlashAlloc-ed objects, their data
will be stored in non-FA instance and managed by the conventional
FTL. In this way, flash storage supporting FlashAlloc can support
two types of objects, objects with sequential writes and objects with
random overwrite, concurrently. In this respect, FlashAlloc is in
stark contrast with the Zoned Name Space (ZNS) interface, which
forces applications to follow the strict sequential write rule [3].
The main contributions of this paper are summarized below.
• We make an observation that data stores with flash-friendly
write patterns, contrary to the common belief, experience
severe write amplification on conventional SSDs and investi-
gate the write multiplexing as the main culprit for the prob-
lem. We also show that the write multiplexing makes multi-
tenants interfere with each other.
• We motivate that existing flash devices are object-oblivious
simply because the host semantic about the object’s logical
address range cannot cross the storage interface wall.
• Based on this motivation, we propose a new interface, FlashAl-
loc, which allows to offload the host semantic about object’s
logical address range to the storage and thus to enlighten
flash device to be able to stream writes by objects, reducing
device-level write amplification. We also suggest an extended
design of page-mapping FTL to support FlashAlloc.
• The abstraction used in FlashAlloc is so simple and intuitive
that existing software stacks can realize the write streaming
by objects with minimal change in its codebase. .
• We have prototyped FlashAlloc using the Cosmos open-source
SSD. Our experimental results show that FlashAlloc can re-
duce WAFs in RocksDB, F2FS, and MySQL by 1.5, 2.5, and
0.3, respectively, and accordingly improve throughput by 2x,
1.8x, and 1.2x, respectively. In particular, when RocksDB and
MySQL are run together, FlashAlloc can reduce WAF from
4.2 to 2.5, and doubled their throughputs.
FlashAlloc is similar to the trim command [34]: both aim at
reducing write amplification by hinting flash device about host
semantics (i.e., logical address range allocated upon object creation
and staled upon object deletion, respectively). Interestingly, when
used together, they are synergetic to reduce write amplification
further. Meanwhile, the FlashAlloc interface might not be such novel
considering there already exists a write streaming interface, MS-
SSD [17]. Unlike MS-SSD resorting to the stream-id concept, we
can stream writes simply by calling FlashAlloc after object creation.
Thus, developers are free from the burdens of determining the
proper number of streams, grouping objects into limited streams,
and assigning stream-id to every write call. Also, FlashAlloc will
not incur the stream-id conflict among multi-tenants. In this sense,
FlashAlloc is a simpler and more advanced abstraction than MS-SSD,
enabling transparent write streaming.
2
BACKGROUND AND MOTIVATION
This section reviews several key concepts about flash storage,
presents a few motivating examples about write amplification in
flash-friendly data stores, and makes a problem statement on why
flash storage is object-oblivious.
2.1
Flash Memory SSD
Here we review how the existing flash storage works and explain
two key concepts of page deathtime and stream write by time.
FTL An FTL (Flash Translation Layer) is responsible for several
key functionalities such as address mapping, GC and wear level
management [23]. Because overwrites are not allowed in flash
memory, a new page writes should be handled in an out of place
manner (i.e., log-structured) - the old version of the page will be
marked as invalid and new version will be stored in a new clean
flash page. Thus, FTL has to manage the ever-changing address
mapping between each page’s logical address at the file system
layer and its physical address in flash memory chips. Since the
address mapping scheme is critical to the performance and lifespan
of flash storages, most flash storage prefers the page-mapping FTL
scheme among numerous address mapping schemes, mainly for
performance reason at the cost of memory resource for managing
the logical-to-physical mapping at the page granule [13, 18, 23].
Garbage Collection When clean space for new writes runs
out, FTL has to reclaim new clean space by the garbage collection
(GC in short) procedure. Upon GC, a victim block 𝑉is chosen, then
its valid pages are relocated to a clean block 𝐵(i.e., valid pages

---

Enlightening Flash Storage to Stream Writes by Objects
are read out from 𝑉and written back to 𝐵), and then 𝑉is erased
and returned to the free block pool. After GC, new writes from
the host will be appended to the remaining space in 𝐵. Relocating
valid pages during GC amplifies physical writes inside flash storage.
Informally, write amplification factor (WAF) represents the ratio of
physical writes to flash memory over logical writes from the host.
Page Deathtime When a page copy in flash block is overwrit-
ten by new write or discarded by the trim command, the old copy
is said to be dead. And the point of time it becomes invalidated is
called as its deathtime [14]. The distribution of deathtimes of pages
in flash blocks is critical to determining the write amplification.
For instance, let us assume that a flash block fb1 stores only data
pages from the same SSTable in RocksDB. All the pages in fb1 will
be dead when the SSTable is deleted after compaction. Then, the
GC procedure can secure a new clean block without relocating
any page but simply by erasing fb1, incurring no write amplifica-
tion. In contrast, when a flash block stores pages with quite distant
deathtimes and later is chosen as a victim for GC, many valid pages
should be relocated to another block. Therefore, grouping pages by
deathtimes is paramount to reducing write amplification.
Stream-Writes-by-Time Consider how today’s flash storage
handles writes when concurrent write requests from different ob-
jects interleave. For each write request with logical address (i.e.,
start_lba), the existing flash storage cannot distinguish the object
the data belongs to. Therefore, the conventional object-oblivious
flash storage will simply append writes from different objects in
their arrival order at the clean flash memory space [4]; we call this
write policy as stream-writes-by-time.
2.2
Motivation
It has long been believed that sequential writes are flash-friendly:
less harmful than random writes in terms of write amplification [26].
With this expectation in mind, sequential writes have been opted for
by many data stores such as LSM (log-structured merge) tree-based
KV (key-value) stores [8, 12, 17, 27] and F2FS (Flash-Friendly File
System) [20] which is a variant of log-structured file system [32].
Contrary to the belief, however, log-structured sequential writes
at such flash-friendly software stacks are not effective in reducing
write amplification. In reality, our experimental results below will
clearly reveal that such sequential writes are as harmful as random
ones (e.g., OLTP workloads on RDBMS) in terms of WAF in flash
storage. Similar observations have been made consistently across
different software stacks [7, 14, 36, 39], albeit they did not explain
the reasons.
In this section, we demonstrate that two data stores, RocksDB
and F2FS with the so-called flash-friendly write patterns, suffer from
severe write amplification. We also motivate a write multiplexing
problem in MySQL. In addition, we point out that two tenants of
RocksDB and MySQL interfere each other and thus exacerbate the
write amplification further. While running each workload on top
of a commercial SSD of 256GB, we measured its throughput and
also the running WAF at the device-level using smartmontools [35]
1 and present the results in Figure 2. The figure clearly shows that
WAFs increase over time across all cases, and application through-
puts inverse-proportionally degrade. In particular, it is noteworthy
that WAF values in RocksDB and F2FS with sequential writes are
no less than that in MySQL with random writes. Below, for each
workload, in turn, we describe the experimental setting and explain
its IO architecture and dominant write patterns. In particular, we
elaborate on why they experience severe device-level WAF despite
their flash-friendly write patterns.
RocksDB(Figure 2(a)) RocksDB is a popular KV store used in
many large-scale data services as well as databases [8, 9]. Since
it uses Log-Structured-Merge (LSM) tree [27] as the primary data
structure, the dominant write pattern from RocksDB is sequential
in the unit of SSTable (Single Sorted Tables). Upon memtable flush
or compaction, RocksDB creates new SSTable file(s), allocates a
logical space of (by default) 64MB to each file via the fallocate()
call, writes data, and then flushes the file. SSTables will be later
deleted after compaction; all pages of an SSTable will be invali-
dated together upon the file deletion. Note that SSTable files which
are created and populated simultaneously will be compacted and
deleted at different points of time. Using the sequential batch write
for each SSTable, RocksDB expects pages from the same SSTable
and thus with the same deathtime to colocate in the same flash
blocks and thus to barely cause write amplification.
To verify the WAF problem in RocksDB, we ran four RocksDB
instances with db_bench’s fillrandom workload [10] on Ext4 file
system until the commercial SSD was full. Each RocksDB instance
has four concurrent user threads and uses four concurrent com-
paction threads to utilize storage better and thus mitigate the com-
paction overhead [9]. In addition, the discard option was enabled
while mounting Ext4. While running the workload, we measured
the average OPS (Operations per Second) of four benchmarks and
also running WAFs of the SSD in every five minutes, and plot the
result in Figure 2(a). To our surprise, the WAF has continued to soar
over time, ending around five. Note that the WAF value of five is
even greater than that observed in OLTP workloads with random
writes [18]. This unexpected result about flash-unfriendly RocksDB
has been reported consistently by other researchers [7, 36, 39]. All
other LSM tree-based KV stores will we believe experience the same
WAF problem [12, 17].
Consider why RocksDB suffers from high WAF. Though each
SSTable file is sequentially written, four compaction threads will
flush their SSTables concurrently. In addition, each flush of 64MB
SSTable file tends to split into smaller write requests due to file
system fragmentation and kernel IO scheduling [5, 37]. Thus, write
requests from multiple SSTables will interleave at the flash storage,
and they are handled according to the stream-writes-by-time policy.
Further, the striped architecture will divide each write request into
smaller write chunks (e.g., 4KB) and distribute them over multiple
channels [16, 19, 30]. As a result, pages from multiple SSTables
being flushed concurrently tend to be stored together in the same
flash blocks. Recalling that SSTables have distinct deathtimes, the
multiplexing will incur write amplification.
1We refer to technical note from vendor[25] which describes how to measure the write
amplification factor for client SSDs using the Self-Monitoring, Analysis, and Reporting
Technology (SMART) attributes.

---

Jong-Hyeok Park Gihwan Oh Sang-Won Lee
1
1.5
2
2.5
3
3.5
4
4.5
5
0
2
4
6
8
10
12
0
0.5
1
1.5
2
2.5
WAF
Avg. OPS (x1000)
Time (hr)
WAF
OPS
(a) 4 DB_Bench Tenants (Ext4)
1
2
3
4
5
6
7
8
9
0
2
4
6
8
10
12
0
0.5
1
1.5
2
WAF
Avg. OPS (x1000)
Time (hr)
WAF
OPS
(b) 4 DB_Bench Tenants (F2FS)
1
1.5
2
2.5
3
3.5
4
4.5
0
5
10
15
20
25
30
35
40
45
0
0.5
1
1.5
2
2.5
3
3.5
4
4.5
WAF
TPS (x100)
Time (hr)
WAF
TPS
(c) TPC-C (MySQL, Ext4)
1
2
3
4
5
6
7
8
0
5
10
15
20
0
10
20
30
40
50
60
70
80
WAF
OPS (x1000), TPS
Time (hr)
WAF
TPS
OPS
(d) DB_Bench + TPC-C (Ext4)
Figure 2: Four Realistic Workloads on a Commercial SSD: WAF and Throughput
F2FS (Figure 2(b)) F2FS aims at reducing write amplification
by taking log-structured writes [20]. In F2FS, a segment is a basic
unit of management and, the whole storage volume is divided into
fixed-size segments (by default 2MB). To turn random writes into
sequential ones, F2FS basically builds on append-only logging to
segments. That is, it appends new page write to one of six active
segments depending on the page’s hotness. Hence, the write pattern
in F2FS can be characterized as multi-head logging [20]: writes
are concurrently made against six segments while write to each
segment is append-only logging. When an active segment is filled
up, the segment becomes inactive and a new segment becomes
active. The old inactive segment will be later chosen as a victim for
garbage collection and be cleansed [32]. Upon a segment cleansing,
all logically valid pages will be relocated to a new segment and
the old segment is returned as free segment. Note that all pages
in a segment have the same deathtime because they are discarded
altogether when the segment is cleansed.
To validate how WAF in F2FS varies, we measured OPS and
device-level WAF while running the same four RocksDB instances
used for Figure 2(a) on F2FS, and present the result in Figure 2(b).
The device-level WAF became quite high (i.e., greater than 8) around
the mid-phase of the experiment. Considering that the log-structured
file system itself incurs logical write amplification [32, 39], it is not
surprising to see that the average OPS of four RocksDB instances
was lower than that on Ext4 (i.e., Figure 2(a)). Other recent stud-
ies have also reported the device-level WAF issue when running
F2FS on top of flash storage [36, 39]. Interestingly, the authors of
F2FS acknowledged that its multi-head logging could mix pages
from multiple active segments into the same flash block [20]. Thus,
considering that segments are cleansed at different points of time,
pages with different deathtimes are multiplexed in the same flash
blocks. This is the reason F2FS experiences such high WAF.
MySQL (Figure 2(c)) In order to guarantee the write atomicity
in the presence of crashes, MySQL takes the redundant journaling
approach using the special object, called double write buffer (DWB
in short): before flushing dirty pages to their original locations,
InnoDB engine first appends them sequentially to DWB. On system
booting, contiguous logical address space of 2 MB is allocated to
DWB. Though tiny in capacity, DWB will account for half of the
writes in InnoDB to the storage. When full, the DWB space will be
reused from the beginning. Therefore, the write pattern to DWB
can be characterized as sequentially appended and cyclically reused.
In addition, the pages written to DWB in the previous cycle will
be quickly overwritten in the next cycle. Namely, the DWB object
has short lifetime and its pages written during the same cycle will
have almost the same deathtime.
Another characteristics in InnoDB engine’s write pattern is that
sequential writes to DWB and random writes to original database
locations will interleave at the storage. Thus, in the case of flash
storage, according to the stream-writes-by-time policy, both types
of data with different deathtimes will colocate in the same flash
blocks, thus adversely affecting WAF. To confirm this, we measured
TPS and running WAF while running the TPC-C benchmark [21]
with 32 client threads and initial database of 150GB (i.e., 1,500
warehouses) on Ext4 file system until the SSD is full, and present
the result in Figure 2(c). As shown in the figure, the WAF has steadily
worsened over time and accordingly the transaction throughput
(TPS) has dropped continuously. The multiplexing of DWB pages
and normal data pages on the same flash blocks is believed to
contribute to the WAF in part, though not all. According to our
experience [6, 29], we can lower write amplification moderately by
separating normal and DWB writes into different flash blocks.
Multi-tenant Databases (Figure 2(d)) With the ever-growing
capacity of SSDs, it is not uncommon for multiple databases to share
a single large SSD, which is particularly true for the cloud environ-
ment [22]. In multi-tenant workloads, as different tenants concur-
rently issue writes for their own objects, pages from more objects
with further distant deathtimes are likely to be multiplexed onto the
same flash blocks. Thus, the write amplification would be worse
than that when each tenant was run alone, which is undesirable in
guaranteeing performance isolation among tenants [1].
To verify how the device-level WAF behaves under multi-tenant
databases, we ran db_bench and TPC-C together on the commer-
cial SSD. While running both benchmarks with initial database of
80GB until the SSD became full, we measured their throughputs and
device-level WAF, and presented the result in Figure 2(d). By com-
paring WAF and throughput in the figure with those in Figure 2(a)
and 2(c), we confirm that the WAF over time in multi-tenant case
are much higher (i.e., almost double) than that when either tenant
was run alone. Also, note that as the WAF spikes at the initial phase
during the multi-tenant experiment, both OPS and TPS drop more
rapidly than the throughput in either single tenant. To sum up, the
write multiplexing among multi-tenants will exacerbate the write
amplification and thus worsen their performance interference.

---

Enlightening Flash Storage to Stream Writes by Objects
In this subsection, we have demonstrated that, despite flash-
friendly write patterns, database engines and file systems still suf-
fer from high write amplification which is comparable to or even
greater than that in OLTP workloads. Though only three data stores
are used to illustrate the multiplexing problem, the problem is we be-
lieve ubiquitous: to name a few, SQLite’s RBJ or WAL journal, Ext4’s
journal area, and temporary files generated in Spark/Map-reduce
applications or during join processing in relational databases.
2.3
Object Characteristics in Data Stores
Understanding workloads is essential to storage system design.
However, little work has been conducted on characterizing objects
in popular data stores from the perspective of the write multiplexing
in flash storage. In this section, we make three observations about
object characteristics in flash-friendly data stores: logical space
allocation, write pattern, and deathtime. The design of FlashAlloc
capitalizes on these characteristics.
Eager Logical Space Allocation The host data stores manage
data using logical objects such as RocksDB’s SSTables, F2FS’s seg-
ments and InnoDB’s DWB. Each store will invoke the write system
calls against such logical objects and those objects account for a
dominant portion of total I/O in the store. To each logical object,
data stores will allocate its logical address space at the file system
layer in advance before writing data to the object. For instance,
RocksDB calls the fallocate() call prior to writing any data to a
newly created SSTable. Hence, the logical address range per each
SSTable is statically determined before writes are made to the object.
In this regard, we say that host-side stores know the relationship
between objects and their logical address ranges and also stream
writes by objects.
Write Pattern The logical write pattern to each object can
be characterized as sequential (in either batch or append). During
flushing memtable in RocksDB, a write system call is made against
L0 SSTable with memtable data as parameter, which we call batch
sequential write. And, SSTables generated during the compaction
in RocksDB will also be populated by batch sequential write. Mean-
while, the write pattern to individual segments in F2FS and DWB
in InnoDB will be appended sequential write. It should be noted,
however, that every data store usually armed with multiple write
threads will issue writes from multiple objects concurrently to the
storage. For example, RocksDB has by default four background
compaction threads and F2FS employs multi-head logging for six
active segments. Therefore, even though the write pattern to in-
dividual logical objects is sequential, writes from different objects
will interleave each other to the underlying storage.
Deathtime All pages of each individual object become dead
together upon the object’s deletion. For instance, when an SSTable
is deleted upon compaction in RocksDB, all its pages will be invali-
dated. Likewise, upon a segment cleaning in F2FS, all its log pages
will be discarded. Meanwhile, different objects will, though created
at the same time, have different deathtimes. For example, two SSTa-
bles concurrently generated at different levels by two compaction
threads are likely to compacted at quite distant points of time. The
similar argument can be made with segments in F2FS, which were
active together but cleansed at different times.
2.4
Problem Statement
Multiplexing The characteristics of object deathtime discussed
above can bring to flash storage the chance of realizing stream-
write-by-deathtime and avoiding write amplification. That is, given
that pages from the same object tend to have the same deathtime
and objects differ in their deathtimes, once flash storage can stream
pages from different objects into per-object dedicated flash blocks,
its effect is to stream writes by deathtimes. However, despite the ea-
ger logical space allocation by objects and log-structured sequential
write to individual object in flash-friendly data stores, concurrent
writes from different objects in single or multiple tenants will inter-
leave to the flash storage. Thus, according to the stream-writes-by-
time policy, the existing flash storage will pack those writes in their
arrival order into flash blocks. An undesirable consequence is that
pages from different objects are packed onto the same flash blocks.
We call this phenomenon as multiplexing. As flash blocks are multi-
plexed with pages with different deathtimes, write amplification is
inevitable. For example, consider the case where four SSTable files
are multiplexed (left-bottom in Figure 1). When the SSTable1 file is
deleted, each of the four flash blocks still keeps three valid pages.
Thus, if a block becomes victim, three pages have to be relocated.
In contrast, when four files are de-multiplexed into different files
(right-bottom in Figure 1), a flash block with all pages invalidated
is available. Thus, a clean block can be obtained without relocating
any page.
Missing interface Consider why existing flash devices should
be object-oblivious in handling writes and thus incur the multiplex-
ing problem. The main reason is that, from the logical address in a
write request, flash storage can not distinguish the logical object
the address belongs to. This is in turn because the conventional
block interfaces do not provide any mechanism to pass the rela-
tionship between objects and their logical address ranges to the
storage. That is, while the host software stacks are aware of the
relationship, the valuable semantic cannot cross the storage inter-
face wall but is simply discarded. In this sense, we say that a crucial
semantic interface is missing which can make flash storage object-
aware. Note that the absence of such useful interface is due to the
legacy that the existing storage interfaces have been developed
assuming harddisk. In the case of harddisk where overwrites are
allowed, logical space allocation via the fallocate() call at the
file system layer implicitly indicates physical space allocation at the
storage. Thus, writes from the host will go to their corresponding
physical location simply according to their start_lbas: harddisk
is object-aware in handling writes without any hint from the host.
For this reason, no storage interface was in need, which can pass
the host semantic about object’s address range to the storage. This
unwritten contract fails on SSDs where overwrites are not allowed.
3
DESIGN OF FLASHALLOC
In this section we propose new interface for flash storage, called
FlashAlloc, and presents its design principles, semantics, and archi-
tecture. In addition, we explain its use cases and benefits.

---

Jong-Hyeok Park Gihwan Oh Sang-Won Lee
3.1
Key Idea and Design Principles
As discussed in Section 2, grouping data by deathtime is effective in
reducing write amplification [14]. Considering that pages of indi-
vidual object have the same deathtime while different objects have
different deathtimes, grouping data by objects will have the effect of
grouping data by deathtime. However, as pointed out in Section 2.4,
the existing flash devices can not group writes by objects simply
because they are unaware of the relationship between objects and
their logical address ranges. This is, in turn, because no interface
exists to allow host to convey the semantic to the flash storage.
Recognizing the missing interface, we introduce a new interface,
FlashAlloc, to hint flash devices about the host-side semantic that
all pages in a logical address range belong to the same logical object.
With the help of the simple hint, flash devices should be able to place
writes into distinct flash blocks by objects. The design objectives
of FlashAlloc are threefold. First, it takes advantage of the existing
concept at the host layer, per-object logical address range. This
is in stark contrast with other approaches (e.g., multi-stream SSD
and ZNS [3, 17]) which introduce new concepts (e.g., stream-id and
zone-id) and thus force applications to adapt to their interfaces.
Second, host-side data stores should be able to leverage FlashAlloc
with minimal change. In particular, required changes, if any, must
be limited to the use of abstraction provided by FlashAlloc. Third,
FlashAlloc aims at passing the host semantic to the storage without
being limited to any specific application domain. So the abstractions
of FlashAlloc must introduce minimal changes to the standards such
as NVMe and the changes must not disrupt existing applications.
This approach is novel in that it turns the common knowledge at
host (i.e., a logical address range constitutes an object) into a strong
point for flash storage (i.e., to be able to stream writes by objects).
3.2
Interface
As a way to pass the information that a logical address range consti-
tutes an object from the host to the flash storage, we propose new
FlashAlloc(logical_addr_range) interface, as detailed below.
FlashAlloc ({LBA, LENGTH}*) FlashAlloc informs flash storage
that the logical address range denoted by the parameter,
{LBA, LENGTH}*, belongs to one object. As indicated by *, an
address range can consist of one or multiple logical chunks.
Recall that an object may consist of multiple chunks because
of the file system fragmentation [37]. Each chunk is presented
by a pair of LBA and LENGTH which represent its starting
address and length, respectively, and chunks should not be
either continuous or overlapping.
Since the storage command is not always available to applications
(e.g., database engines) that access objects through a file system, we
exploited the ioctl infrastructure so that the FlashAlloc command
can pass through the file system to the storage device, instead of
invoking the new command directly from applications.
More importantly, calling a FlashAlloc command, the host ex-
presses its intention that it will perform operations on the given
logical address range, LS, as an integral unit for writes: once a por-
tion of the dataset is written, all the dataset is going to be written
once, and later they will be invalidated together nearly at the same
time. This is a useful hint for write optimization in flash storage.
Upon receiving a FlashAlloc command, flash storage will dedicate
the corresponding physical flash block(s) (PS). Then, flash storage
will store all writes from LS in the arrival order into PS; In this way,
flash storage will guarantee the physical clustering of all pages from
the same logical object. In particular, note that even when the writes
from an FlashAlloc-ed object are spatially fragmented (e.g., due to
file system aging [37]) or temporally split (e.g., due to log-appending
in F2FS), they are guaranteed to be eventually clustered into the
same flash block(s). Thus, when properly FlashAlloc-ed, concurrent
write streams from different logical objects will be de-multiplexed
into each own dedicated flash block. Recalling the object deathtime
characteristics that objects tend to be dead at different times while
pages in each object are invalidated at the same time, the physical
clustering by logical objects will have the effect of stream-write-
by-deathtime, thus minimizing write amplification. The beauty of
FlashAlloc lies in that it can achieve the transparent write streaming
without the hassle of assigning stream-id or zone-id to each write
request [3, 17].
Use Cases As illustrated in Figure 3, popular database engines
and file systems have write-intensive objects (e.g., SSTable, DWB,
segment) whose IO patterns fit well with the purpose of FlashAlloc:
each object is written sequentially just once and later becomes dead
in its entirety at the same or similar time. In addition, objects with
such “write-once and dead-at-once” pattern are ubiquitous in most
data stores: numerous LSM-based KV stores, WAL log files in rela-
tional databases, two journaling modes (RBJ and WAL) in SQLite,
and file system journaling. In addition, FlashAlloc will naturally
stream writes from different tenants so that it is, as demonstrated in
Section 5, quite beneficial in reducing write amplification and per-
formance interference in multi-tenant database environments [1].
Meanwhile, FlashAlloc is not a panacea for write amplification prob-
lem in flash storage. In particular, FlashAlloc would be inappropriate
for objects with random overwrites (e.g., OLTP tablespace). Thus,
data from such objects can be better handled, as discussed below,
using conventional FTL techniques.
3.3
Architecture
Figure 3 illustrates the architecture of FlashAlloc. Using the fig-
ure, we explain the concept of FlashAlloc instance and its physical
space management. Also, we explain how write and read operations
work and describe how the logic of trim and garbage collection
is extended to support FlashAlloc. Though the page-mapping FTL
is assumed throughout this paper, FlashAlloc can be seamlessly
supported by other FTL schemes such as block and hybrid map-
pings [23].
FlashAlloc Instance Upon receiving a FlashAlloc command
with a logical address range, flash storage will create its correspond-
ing FlashAlloc instance (in short, FA instance). In addition, flash
storage will secure the corresponding physical space (i.e., one or
more clean flash memory blocks whose total size amounts to the
given logical address range’s size), and dedicate the space to the
instance2. The physical space to an FA instance is allocated in the
2For the simplicity of discussion, we assume synchronous physical space allocation
throughout this paper. Note, however, that the FlashAlloc interface does not mandate
synchronous allocation. Instead, as long as the physical space is secured prior to the first
write to the instance, either asynchronous or even on-demand physical space allocation

---

Enlightening Flash Storage to Stream Writes by Objects
Figure 3: FlashAlloc Architecture
unit of flash memory block (e.g., usually 2MB in flash memory chips)
so as to isolate writes from the instance into the dedicated blocks
Though we assume flash memory block as the unit of physical
space allocation for the simplicity of discussion, we do not exclude
the case where two or more FA instances can share one physical
flash block, when their logical address sizes are less than the size
of a flash memory block. We would like to stress that, even when
a flash memory block is shared by two or more FA instances, it is
always beneficial to cluster pages from one logical object into the
same physical flash block and thus to prevent them from scattering
over different flash blocks The dedicated blocks for FA instances
are called as FlashAlloc-ed. Once multiple blocks are allocated to
an instance, data for the instance will be striped across channels
for better bandwidth [19]. As illustrated in Figure 3, an FA instance
consists of three metadata: logical address range, physical flash
blocks, and physical location for next write. Next write for an FA
instance will be appended to the page pointed by next_write_ptr.
Active FA Instances Once created, every FA instance and its
metadata will remain active and also be managed persistently until
its destruction. An FA instance and its metadata will be destructed
once its physical space is filled up. As depicted in Figure 3, multiple
FA instances could be active at a point of time. Note that the logical
address ranges of all instances should be disjoint from each other.
Meanwhile, the number of active FA instances will remain rather
small in practice, though unlimited in principle. For instance, con-
sidering that an SSTable file in RocksDB is, once created, quickly
filled by memtable flushing or compaction, its FA instance will be
(or securing) is acceptable, which may bring some optimization opportunities. We
leave such an interesting optimization topic as future work.
destructed shortly after created. Thus, when running a RocksDB,
the number of active FA instances will not be greater than that of
concurrent compaction threads(i.e., four by default). Similar argu-
ment can be made for F2FS segments.
Non-FlashAlloc-ed Objects While good for objects with se-
quential or log-appending write patterns, FlashAlloc is not intended
for objects with random write pattern. For the latter type of objects,
FlashAlloc is not recommended to be called. Thus, flash devices
supporting FlashAlloc are desirable to be able to support such non-
FlashAlloc-ed objects as well; writes from non-FlashAlloc-ed objects
can be handled same as in the conventional SSD and stored in nor-
mal blocks. For this reason, in our FlashAlloc architecture, there are
two types of blocks, FlashAlloc-ed and normal, as illustrated in the
bottom of Figure 3. In this regard, our approach is in contrast with
the ZNS interface which strictly assumes all writes to be sequential
and thus cannot support workloads with random writes.
Write For a write request with two parameters, LBA_start
and length, indicating the starting LBA and length of the data
respectively, flash storage first probes its matching FA instance
using the LBA_start, as depicted in Figure 3. If a matching instance
is found, the write data will be appended to a FlashAlloc-ed block
pointed by the instance’s next_write_ptr, and the corresponding
entry in L2P table and next_write_ptr value will be accordingly
adjusted. Otherwise, the request comes from non-FlashAlloc-ed
objects. In this case, as in the conventional SSDs, the writes will
be stored in normal block. In this way, our approach supports two
write policies: stream-write-by-object for FlashAlloc-ed objects and
stream-write-by-time for normal writes.

---

Jong-Hyeok Park Gihwan Oh Sang-Won Lee
Read While FlashAlloc aims at reducing WAF by controlling
the placement of writes into different blocks by objects, its read
operation will proceed exactly same as in the conventional page-
mapping FTLs: after looking up the physical page number (i.e.,
block-id + page-offset) from the mapping table with the given LBA
address, FTL reads out the page from the corresponding flash block.
Trim The trim command was introduced to notify the flash
storage that a set of logical pages is no longer valid. Upon receiving
a trim command, flash storage will invalidate the relevant pages,
preventing them from being unnecessarily relocated. In our FlashAl-
loc architecture, the trim command will be handled same as in the
conventional flash storage with one exception. Considering that
pages in an FlashAlloc-ed object have the same deathtime and are
also clustered in the same physical flash block(s), the trim command
against the object can complete by erasing the block(s) instead of
invalidating individual pages. In this sense, FlashAlloc enables to
achieve nearly zero-overhead trim. In fact, the trim command is,
though effective in lowering write amplification, known to induce
non-trivial run-time overhead (e.g., trim spikes [9]); thus data stores
such as RocksDB and F2FS take the delayed discard policy to miti-
gate the effect of trim spikes on the write latency [20, 24]. The trim
optimization enabled by FlashAlloc will remove the trim-induced
stalls so that the developers are free from the burden of devising
deliberate rate limiting to file deletion [24] or delayed discard [20].
Garbage Collection (GC) When no space is available for new
writes, FTL has to conduct the GC operation: copying valid pages
from a victim block to a clean block, fb and then returning fb.
Unfortunately, the conventional GC algorithm returning a partially
clean block fb is inappropriate for FA instances. Recalling that
FlashAlloc intends to disallow pages from different objects to mix in
the same flash block(s), each FA instance needs total-clean block(s).
Thus, FTL has to handle two cases of GC differently: The first case
is when FlashAlloc is called, and the second one is when free space
is unavailable for normal write. Recall that when a FlashAlloc-ed
object is trimmed, all its blocks will be returned as free and thus
the free block pool is likely to have some free blocks. In the case
when GC is triggered for normal write, FTL will first check the
free block pool for a free block and, if found, use it. Otherwise, it
will carry out the conventional GC: it chooses a victim block with
the least valid pages and merges the victim. In the second case,
when a FlashAlloc call is made, FTL checks whether clean blocks
are available in the free block pool and, when unavailable, has to
merge multiple blocks to secure total-clean block(s) [18].
In addition, while selecting victim blocks for each of two GC
cases, block types have to be taken into account so that pages
from normal blocks are not mixed with those from FlashAlloc-ed
blocks. In the case of GC for normal writes, only normal blocks
can be victims. Otherwise, once an FlashAlloc-ed block is chosen
as victim, non-FlashAlloc-ed normal writes should co-locate with
the relocated pages from the old FlashAlloc-ed victim block. In the
case of GC for FlashAlloc, as discussed above, multiple blocks have
to be merged to secure total-clean block(s) for FlashAlloc. In this
case, those multiple blocks should have the same type. In this sense,
we call our algorithm as GC-By-Block-Types. Interestingly, the
GC-By-Block-Type algorithm will adaptively allocate the space of
FlashAlloc-ed and normal blocks: depending on victim block type,
one region grows while the other shrinks. For instance, if a new
FlashAlloc block is in need and no free block is available, multiple
normal blocks have to be merged so as to secure a total-clean block,
enlarging FlashAlloc-ed region. In this way, the space allocation to
both regions will adapt to the changing workloads, requiring no
static allocation or tuning.
3.4
Advantages
To the best of our knowledge, FlashAlloc is the first work which
allows host applications to hint the storage that a logical address
range belongs to the same object. The advantages of FlashAlloc
are threefold. First, enlightened by FlashAlloc, flash storage can
now cluster data from the same object and thus with the same
deathtime into the same physical flash blocks, thus minimizing
write amplification. In particular, data from objects which are even
logically fragmented will be physically de-fragmented into the same
flash block(s). In this regard, FlashAlloc could be a clean solution to
the logical and physical fragmentation problem in flash storage [33,
36]. Second, since the abstraction used in FlashAlloc complies to
the popular abstractions (e.g., fallocate() call and segment in
F2FS), the existing software stacks can achieve write streaming
with minimal code changes, as detailed in Section 4.
Third, since the FlashAlloc semantic is simple and does not re-
quire involving intermediate layers such as the kernel block layer,
it is easy to incorporate the command into the existing storage
interface standards such as SATA, SAS and NVMe (e.g., using the
vendor specific command).
4
IMPLEMENTATION
This section presents the implementation details of the FlashAlloc ar-
chitecture. The dominant portion of the FlashAlloc implementation
is made into the FTL firmware of the Cosmos development board
by cross-compiling the source code written in C. The FlashAlloc
command was prototyped via vendor unique command. A user-
level library that implements a protocol for the new commands via
the ioctl system call supports applications and SSDs. This approach
not only allows to quickly prototype the concept in a development
environment but also to make the prototype portable to most file
systems. In addition, this section describes the changes we made
in file systems and database engines to enable them to run on the
FlashAlloc interface. Note that the changes are, as summarized in
Table 1, marginal and moreover local to a few modules.
4.1
Changes made in F2FS
While initializing a file system volume, F2FS divides the whole
volume into fixed-size segments. The segment is a basic unit of
management in F2FS: it allocates storage pages in the unit of seg-
ments and also performs “cleaning” in the unit of segment. F2FS
maintains multiple active segments (by default, six segments). To
stream writes by active segments inside flash storage, F2FS is modi-
fied to obtain, whenever a segment becomes active, its logical ad-
dress range using the super block data structure (i.e., f2fs_sb_info)
and segment number information and then to call FlashAlloc with
the range as parameter. For this, only 26 lines were added to the
segment-allocation module. Like in Ext4, the FlashAlloc-ed block

---

Enlightening Flash Storage to Stream Writes by Objects
Table 1: Lines modified across applications to use FlashAlloc
Applications
Lines Added
Lines Removed
RocksDB
(v6.10)
72
-
MySQL/InnoDB
(v5.7)
74
16
F2FS
(v5.4.20)
26
-
FTL (cosmos+)
(v3.0.0)
1683
193
for a segment will be erased in their entireties when the trim com-
mand is automatically called for the segment upon its cleansing.
4.2
Changes made in Applications
RocksDB As explained in Section 2, RocksDB manages key-value
documents using SSTables. In particular, after creating each SSTable
file, RocksDB secures its logical address space (whose size is by de-
fault 64MB) in advance by calling fallocate() for the file. Once al-
locating the logical space for the given fallocate() call, RocksDB
engine calls FlashAlloc. For this reason, every SSTable’s data will
be streamed to its dedicated flash block(s). Flash blocks dedicated
to each SSTable remain full of valid pages until the SSTable is later
compacted and deleted. When an SSTable is deleted, all its pages
will be trimmed and thus invalidated altogether at once and accord-
ingly all flash blocks dedicated for the SSTable can be simply erased,
thus causing no write amplification. Hence, as shown in Section 5,
RocksDB can achieve near ideal WAF (i.e., 1) transparently with
minimal changes in its codebase.
MySQL/InnoDB In order to isolate DWB pages from normal
ones into different flash blocks and thus to reduce write amplifica-
tion [6], we modified the InnoDB engine to call FlashAlloc with the
logical address range of DWB as parameter before writing to the
journal area for the first time. To obtain the address range was used
the FS_IOC_FIEMAP ioctl call. Also, whenever DWB is cyclically
reused, the trim call is made for the journal area so as to invalidate
all the old pages and and thus to make the old FlashAlloc-ed block
to be erased in its entirety. As shown in Table 1, the changes made
in InnoDB engine were minimal - less than 100 lines of code change
were made at two modules of double-write-buffer and file.
4.3
Changes made in FTL
We have prototyped FlashAlloc on the OpenSSD Cosmos board [19]
by extending its firmware. The Cosmos board is an SSD develop-
ment platform that is made publicly available by the OpenSSD
Project to promote research and education. The board employs the
HYU Tiger 4 controller based on Dual-Core ARM Cortex-A9 on
top of Xilinx Zynq-7000 board, and 16GB MLC Nand flash memory.
Thus it has the same performance characteristics as a commer-
cial SSD equipped with the Barefoot controller. The Cosmos board
adopts a page mapping scheme for flash memory management, as
in most contemporary SSD products. The board is connected to
a host system through the NVMe interface. Main technical issues
encountered while embodying FlashAlloc on the board are summa-
rized below. Note that the existing FTL can support FlashAlloc with
moderate changes in its codebase, as shown in Table 1.
FA Instances For each FlashAlloc command, a corresponding
FA instance is created in Cosmos board’s DRAM, which contains
its logical address range, the list of flash blocks dedicated to the
instance, and the current write pointer. The memory requirement
per instance is, while slightly varying depending on address range
and the number of flash blocks, just several tens bytes. Thus, consid-
ering that the number of active FA instances is in practice limited
(e.g., less than 100), small amount of DRAM (i.e., several tens KB)
will suffice to maintain active FA instances.
GC and Block Type The existing GC firmware in the Cos-
mos board was extended to support the GC-By-Block-Type policy.
Also, since FTL need distinguish two types of blocks, normal and
FlashAlloc-ed, one bit flag, FA-BLK, was added to the block_header
struct in the Cosmos firmware. A block’s FA-BLK flag will be set
on dedicating the block to an FA instance and later reset when the
block is erased and returned as free.
Probing the matching FA instance For a write request, FTL
should be able to quickly probe the matching FA instance using
the given LBA address. If the probing fails (i.e., no matching in-
stance exists), the request is not for active FA instance thus will
be written to non-FA instance. To determine whether the given
write is for active FA instance or not, a flag bit was added to ev-
ery entry in page-mapping table. The flag bit of every relevant
logical page is set when an FlashAlloc command is invoked and
later reset when the page is overwritten or discarded. The next
issue is, when the flag is turned on, how to probe the matching
instance. While there should be alternative implementations such
as hardware-acceleration and pipelining, rather a simple approach
was taken for fast prototyping. That is, while scanning each of all
active FA instances, we check whether its logical address range
contains the start_LBA in the given write request. Once a matching
instance is found, the write will be appended at the physical space
pointed by the next_write_ptr of the instance.
5
PERFORMANCE EVALUATION
In this section, we present performance evaluation carried out to
analyze the impact of FlashAlloc on key-value store, log-structured
file system, relational database, and multi-tenancy.
5.1
Experimental Setup
All experiments were conducted on a Linux platform with 5.4.20
Kernel running on an Intel Core i7-6700 CPU 3.40GHz processor
with two sockets of four cores and 50GB DRAM. The host ma-
chine has two storage devices, 16GB Cosmos OpenSSD and 256GB
Samsung 850 Pro SSD. The Cosmos OpenSSD employs a controller
based on Dual Core ARM Cortex-A9 on top of Xilinx Zynq-7000
board with 256KB SRAM, 1GB DDR3DRAM, and 16GB MLC Nand
flash memory [28]. The Cosmos OpenSSD was used as the main
storage device for the experimental data and connected to host
using PCIe interface. The over-provisioning area in the board was
set to 10% (i.e., 1.6GB) for all experiments. The Samsung 850 Pro
SSD was used as the log device when MySQL/InnoDB was run.
5.2
Workloads
To demonstrate the benefit of FlashAlloc, we used a synthetic work-
load and two realistic workloads, db_bench and TPC-C. The fio

---

Jong-Hyeok Park Gihwan Oh Sang-Won Lee
tool was used to generate a synthetic workload. And, to evaluate the
effect of FlashAlloc on key-value stores, we ran the db_bench bench-
mark using RocksDB on ext4 file system. The same db_bench work-
load was run also using F2FS [20] to test the impact of FlashAlloc on
log-structured file system. In addition, the TPC-C benchmark was
used to measure the effect of separating DWB in MySQL/InnoDB
into dedicated flash blocks. Finally, to highlight the benefit of
FlashAlloc in multi-tenancy, we ran db_bench using RocksDB and
TPC-C using MySQL concurrently on Ext4 file system. In all ex-
periments, the direct I/O option (O_DIRECT) was enabled to mini-
mize the interference from file system’s page caching and the TRIM
option was turned on for both file system. To compare the per-
formance impact of FlashAlloc, we ran those workloads using the
vanilla databases and file systems on the Cosmos board running the
original FTL and also ran them using the modified versions with
the board supporting FlashAlloc. The three workloads used in the
experiments are summarized below.
FIO The Flexible I/O (FIO) benchmark is commonly used to test
the performance of file and storage systems [11]. It spawns
a number of threads or processes doing a particular type of
I/O operations as specified by the user parameters.
db_bench RocksDB provides db_bench as the default benchmark
program, consisting of several configurable workloads [10].
The fillrandom workload was used to evaluate the impact
of FlashAlloc, which writes key-value pairs in random key
order. Each key-value entry was sized to have a key of 16
bytes and a value of 100 bytes. The workload was run against
empty database till the Cosmos board became full.
TPC-C The tpcc-mysql tool [31] was used for TPC-C benchmark-
ing [21]. The benchmark was run using 32 clients against
initial database of 80 warehouses until no space was left in
the storage device.
5.3
Performance Analysis
Let us briefly review the overall performance benefit of FlashAlloc
using Figure 4. While running four experiments using vanilla and
FlashAlloc-ed configurations, we measured the throughput of each
benchmark program and the running WAF at the Cosmos device
every minute till no space is left in the Cosmos device, and present
the results in Figure 4. In the figure, the X-axis represents the
time and the left and right Y-axis does the running WAF and the
throughput of each benchmark, respectively. As shown in Figure 4,
FlashAlloc-ed version outperforms the vanilla one considerably in
terms of throughput as well as WAF consistently across all four
experiments. The running WAF gaps between two versions are
ever-growing over time in all experiments. That is, as the Cosmos
board is filled with data, the effect of de-multiplexing different
objects into different blocks in FlashAlloc becomes outstanding. In
particular, the running WAF in FlashAlloc-ed version remain close
to 1 even at the ends of RocksDB and F2FS experiments.
Synthetic FIO Workload Before explaining the effect of FlashAl-
loc on realistic workloads in Figure 4, let us show the benefit of
FlashAlloc using a synthetic write workload. For this, using the
fio tool, we created eight 2GB files on Linux and Cosmos board
and ran eight threads, each of which performs random overwrites
in the unit of 2MB against its dedicated 2GB file. The same exper-
iments were conducted in two modes, vanilla and FlashAlloc-ed.
In the FlashAlloc-ed mode, before invoking each 2MB overwrite,
FlashAlloc was called a prior so as to secure a dedicated flash block
to store new data. While running each experiment during one hour,
we measured the device WAF and the write bandwidth and plotted
the result in Figure 5. FlashAlloc has reduced the device WAF from
3.1 to 1 and has doubled the write bandwidth (i.e., approximately
from 75MB to 150MB). In addition, to further highlight the effect of
FlashAlloc when the multiplexing degree is increased, we carried
out another experiment by increasing the number of concurrent
write threads to 32 in fio tool and thus decreasing the per-thread
file size to 512MB, and present the result in Figure 5. Note that,
under more concurrent write threads, a flash block in the Cosmos
board will be multiplexed by more files with more deviating life-
times. As clearly shown in the figure, FlashAlloc has reduced the
device WAF from 4 to 1 and thus has tripled the write bandwidth
(i.e., roughly from 60MB to 180MB). The considerable gain in WAF
and write bandwidth was direct reflection of reductions in the
garbage collection overhead.
RocksDB on EXT4
To analyze the effect of FlashAlloc on
RocksDB engine, we ran 4 RocksDB instances concurrently on
top of two configurations of ext4 file system and the Cosmos board,
vanilla and FlashAlloc-ed. Each RocksDB instance was run with
the fillrandom workload in the db_bench benchmark. In order
to minimize the interference from flushing the WAL log, the log
file was stored in a separate storage device. While running both
experiments, we measured device-level WAF and average OPS of
four RocksDB instances over time and present the result in Fig-
ure 4(a). In the case of vanilla mode, as SSTables at different levels
are simultaneously created and populated by multiple compaction
threads in RocksDB, they are multiplexed into the same flash blocks.
Recall that SSTables at different levels will be compacted and thus
deleted at different points of time. For this reason, in the vanilla
version, device-level WAF increased steadily while RocksDB’s OPS
decreased inverse-proportionally, which is consistent with the re-
sult in Figure 2(a). In contrast, in the case of FlashAlloc-ed mode,
WAF at the Cosmos board, as expected, remained nearly one even till
the end of the experiment and accordingly the average RocksDB’s
OPS improved by 1.5x, compared to the vanilla version. This clearly
illustrates that FlashAlloc can drastically reduce write amplification
in RocksDB by de-multiplexing SSTables into different flash blocks.
Nonetheless, write amplification was not completely removed
in FlashAlloc-ed mode. The running WAF was 1.1 at the end of the
experiment. The residual physical write amplification is attributable
to metadata files. RocksDB maintains several metadata files (e.g.,
MANIFEST and CURRENT) to keep track of database state changes
whose write patterns are not log-structured instead random writes.
Though the sizes of those files are relatively small, they contribute
non-marginal fraction of total writes from RocksDB. Those ran-
dom writes go to the non-FA instance which is managed by the
conventional Greed FTL and hence incur write amplifications.
Note that the OPS gain by FlashAlloc over vanilla is relatively
smaller than the WAF gain. Recalling that OPS is determined by log-
ical write amplification at the RocksDB level as well as device-level

---

Enlightening Flash Storage to Stream Writes by Objects
0
0.5
1
1.5
2
2.5
3
0
5
10
15
20
25
WAF
Avg. OPS (x1000)
Write Sequence
VANILLA_WAF
VANILLA_OPS
FlashALLOC_WAF
FlashALLOC_OPS
(a) EXT4 (4 RocksDB Tenants)
0
0.5
1
1.5
2
2.5
3
3.5
4
0
0.5
1
1.5
2
2.5
3
3.5
4
WAF
Avg. OPS (x1000)
Write Sequence
VANILLA_WAF
VANILLA_OPS
FlashALLOC_WAF
FlashALLOC_OPS
(b) F2FS (4 RocksDB Tenants)
1
1.2
1.4
1.6
1.8
2
2.2
0
10
20
30
40
50
WAF
TPS
Write Sequence
VANILLA_WAF 
VANILLA_TPS 
FlashALLOC_WAF 
FlashALLOC_TPS
(c) MySQL (TPC-C)
1
1.5
2
2.5
3
3.5
4
4.5
0
5
10
15
20
25
30
35
40
45
WAF
OPS(x1000), TPS
Write Sequence
VANILLA_WAF
VANILLA_TPS
VANILLA_OPS
FlashALLOC_WAF
FlashALLOC_TPS
FlashALLOC_OPS
(d) Multi-tenant DB (TPC-C + RocksDB)
Figure 4: Write Amplifications and Throughput in Realistic Workloads
0
0.5
1
1.5
2
2.5
3
3.5
4
4.5
0
50
100
150
200
250
300
WAF
Bandwidth (MB/s)
Write Sequence
VANILLA_WAF 
VANILLA_BW 
FlashALLOC_WAF 
FlashALLOC_BW
(a) 8 Threads
0
0.5
1
1.5
2
2.5
3
3.5
4
4.5
0
50
100
150
200
250
300
WAF
Bandwidth (MB/s)
Write Sequence
VANILLA_WAF 
VANILLA_BW 
FlashALLOC_WAF 
FlashALLOC_BW
(b) 32 Threads
Figure 5: WAF and Bandwidth in FIO
write amplifcation at the device level, the physical WAF reduction
is offset by the same logical write amplification in both modes.
RocksDBs on F2FS To evaluate the effect of FlashAlloc on
log-structured file systems, we ran four RocksDB instances each
with the same fillrandom workload used in subsection 5.3 on
top of two configurations of F2FS and Cosmos boards, vanilla and
FlashAlloc-ed. While concurrent log writes from active segments are
multiplexed into the same flash block in the vanilla configuration,
writes from each segment is perfectly isolated into its dedicated
flash block in the FlashAlloc-ed version. Thus, the FlashAlloc-ed
version can nearly remove write amplification due to the write
multiplexing in the vanilla version; the WAF at the final phase was
reduced from 3.5 to 1.1, as shown in Figure 4(b). The residual WAF
of 0.1 in FlashAlloc-ed version is we guess contributed by random
writes for hot metadata in F2FS [20]. Accordingly, FlashAlloc-ed
version outperforms the vanilla version about by three folds in
terms of the db_bench’s OPS at the end of experiment.
The result from F2FS experiment indicates that FlashAlloc can be
a fundamental solution to the log-on-log problem [36, 39] by allow-
ing to perfectly align logical segments in higher F2FS with physical
blocks in lower flash storage. Namely, FlashAlloc enables F2FS and
RocksDB to achieve an ideal WAF of 1 and thus to realize the full
potential of their flash-friendly log-structured write patterns.
DWB in MySQL/InnoDB To evaluate the effect of separating
the DWB object with cyclic and sequential writes from the main
database with random writes, we measured the throughput and the
device-level WAF while running the TPC-C benchmark using the
vanilla and FlashAlloc-ed MySQL/InnoDB engines, and present the
result in Figure 4(c). Recall that half of writes goes to the FA instance
for DWB in the case of FlashAlloc-ed version while the other half
(that is, random writes against original database) does to the non-FA
instance. Hence, the write amplification induced by the random
writes in non-FA instance is inevitable even in the FlashAlloc-ed
mode. Though, as shown in Figure 4(c), FlashAlloc can reduce the
additional write amplifications by one third (i.e., 1.2 to 0.8) and
thus improve the throughput by 50%. We believe that the benefit
of FlashAlloc on DWB will hold also on other ubiquitous journal
objects including WAL files in RocksDB, SQLite and relational
databases and jbd2 in Ext4 file system.
Multi-Tenancy As discussed in Section 2, when run together
on the same SSD, multi-tenants can interfere each other in terms of
write amplification since objects from different tenants with more
distant lifetimes are multiplexed in the same flash blocks. To demon-
strate the benefit of FlashAlloc in mitigating the WAF interference
in multi-tenancy, we ran two databases concurrently on Ext4 file
system and the Cosmos board, one RocksDB instance (used in Fig-
ure 4(a)) and one MySQL instance (used in Figure 4(c)), in vanilla
and FlashAlloc-ed modes, respectively, and present the results in
Figure 4(d). In the case of vanilla version, the WAF in multi-tenancy
is much worse than that in either single tenant (i.e., Figure 4(a) and
Figure 4(c), which is consistent with the result in Figure 2(d) ob-
tained from commercial SSDs. In the case of FlashAlloc-ed version,
the WAF in multi-tenancy remains lower than that in either single
tenant. As a result, both benchmarks’ throughputs in FlashAlloc-ed
mode are considerably higher than in vanilla mode. The result in
Figure 4(d) indicates that FlashAlloc is not only beneficial to the
calling tenant itself but also altruistic to neighbor tenants and is
thus effective in isolating the performance between tenants [1].
6
RELATED WORK
In that FlashAlloc aims at reducing physical WAF by passing the
host semantic to flash devices, three interfaces are closely related
to it: Trim [34], Multi-stream SSD [17] and Zoned Name Space [3].
Trim Even when a file is deleted, the old storage interface (e.g.,
SATA) provides no mechanism to pass the host semantic about the
file deletion and thus flash devices regard pages from the deleted
file as still valid and unnecessarily relocate them during GC, caus-
ing write amplification. To address this, the trim command was
proposed to inform flash devices that page(s) specified by a logi-
cal address range are no longer valid (i.e., dead) at the host [34];
the trim-hinted device will not relocate those pages upon GC [2].
FlashAlloc and trim are common in that both explicitly provide flash
storages with host-side semantic so as to lower write amplification:
FlashAlloc is used to pass the semantic about the logical address

---

Jong-Hyeok Park Gihwan Oh Sang-Won Lee
space constituting an object and the FlashAlloc-hinted device will
de-multiplex different objects into different blocks. In addition, they
are synergetic to each other: when a file is FlashAlloc-ed, the trim
command can complete simply by erasing all the FlashAlloc-ed
blocks (that is, nearly zero-overhead trim), instead of invalidating
all pages individually [15]. Meanwhile, they differ in their invoke
time: FlashAlloc is called at object creation while trim is at ob-
ject deletion. Lastly, let us remark that FlashAlloc and trim are not
in need for harddisks: since overwrites are allowed, logical space
management implies physical one as well.
Multi-Stream SSD A novel interface for flash storages, Multi-
Stream SSD (MS-SSD), was proposed and standardized [17, 38],
which allows applications to place pages with different lifetimes
to different streams (i.e., flash blocks). More specifically, when in-
voking a write system call, applications can assign a proper stream
identifier (i.e., stream-id) for the data being written, and, on receiv-
ing the write command with a stream-id, MS-SSD will place the data
into the corresponding physical stream. This interface performs
effectively when correctly hinted by applications [17].
While both commonly aim at streaming writes to reduce write
amplification, MS-SSD and FlashAlloc are in stark contrast in their
abstractions for write streaming. The MS-SSD interface has in-
troduced the additional concept of stream-id and mandates appli-
cations to statically bind stream-id to each write call. The static
binding of stream-id, combined with the limited number of physical
streams available in commercial MS-SSDs (e.g., 8), will raise several
practical issues. First of all, it is a non-transparent abstraction in that
every write call has to come with static stream-id. Next, it would be
a non-trivial task for developers to estimate the number of physical
streams for their applications and to correctly group numerous
objects with different lifetimes into the limited streams. Third, the
static stream-id assignment is non-adaptive. As the lifetimes of ob-
jects can change over time, programmers need scrutinize those
statistics and periodically re-assign stream-ids to objects. Lastly,
the effect of write streaming would be useless due to the stream-id
conflict in the multi-tenant environment [22]. Different applications
which were independently developed might have assigned the same
stream-id to their objects. Therefore, different tenants’ objects with
quite distant lifetimes might share the same physical stream.
In contrast, FlashAlloc supports the per-object write streaming
abstraction, which provides several benefits over MS-SSD. First, it
enables transparent write streaming: since it simply requires the
logical address range of each object upon object creation, appli-
cation can achieve write streaming with no or minimal change.
Second, since it provides fine-grained per-object streaming, the ap-
plication developers are free from burdens of managing stream-ids
to objects and further need not care about the stream-id conflict
in multi-tenant environment. In summary, FlashAlloc is we believe
more advanced streaming mechanism than MS-SSD.
Zoned Name Space To overcome the write amplification prob-
lem in the conventional SSDs with block interface while obviating
the need for in-device GC, DRAM resource for page mapping FTL,
and the over-provisioned physical space, the system community
has recently proposed a new interface for flash storage, ZNS (Zoned
Name Space) [3], which exposes zones (a set of logical blocks) to
the host as the unit of data management.
Though novel and worth investigating, however, the interface
imposes strict write-ordering rules: all writes to zones should be
to be sequential and also in their LBA order. In other words, ZNS
disallows out-of-LBA-order random writes to each zone. Such strict
rules will bring two drawbacks. First, all the software stacks from
applications, database engines to file system should be modified to
meet the sequential write ordering. A storage interface which man-
dates the whole software stacks to adapt to it is unlikely to succeed.
Second, while exempting from the block interface tax, ZNS instead
introduces yet-more-expensive tax of log-structured writes (e.g.,
compaction in RocksDB and segment cleansing in F2FS). Such oper-
ations are known to induce application-level logical WAF of more
than 10 [7, 39]. In addition, log-structured write inevitably needs
over-provisioned logical space. In contrast, FlashAlloc does not ask
the existing software stacks to adapt to it; they can achieve trans-
parent write streaming. Also, flash storage supporting FlashAlloc
can support random writes as well simultaneously.
7
CONCLUSION
Existing flash devices are object-oblivious in handling writes and
thus allow to colocate data from different objects in the same
flash block, causing high write amplification. To remedy such write
multiplexing problem, we proposed a novel interface, FlashAlloc,
which is used to enlighten flash devices to de-multiplex writes from
different logical objects into different flash blocks (i.e., object-aware
in handling writes), thus minimizing write amplification.
To verify the effect of FlashAlloc, we have prototyped FlashAlloc
on a real SSD board by extending its conventional FTL firmware
and also modified a set of representative software stacks so as to
use the FlashAlloc interface. Experimental results have confirmed
that FlashAlloc can enable RocksDB and F2FS to eliminate write
amplification, realizing their full potential of flash-friendliness. Also,
we have demonstrated that FlashAlloc is effective in mitigating the
performance interference between multi-tenant applications.
REFERENCES
[1] Daniel Abadi et al. 2020. The Seattle Report on Database Research. SIGMOD
Record 48, 4 (Feb. 2020).
[2] Remzi H. Arpaci-Dusseau and Andrea C. Arpaci-Dusseau. 2018. Operating Sys-
tems: Three Easy Pieces. CreateSpace Independent Publishing Platform, USA.
[3] Matias Bjørling, Abutalib Aghayev, Hans Holmberg, Aravind Ramesh, Damien Le
Moal, Gregory R. Ganger, and George Amvrosiadis. 2021. ZNS: Avoiding the
Block Interface Tax for Flash-based SSDs. In 2021 USENIX Annual Technical
Conference (USENIX ATC 21). USENIX Association, 689–703.
[4] Feng Chen, Binbing Hou, and Rubao Lee. 2016. Internal Parallelism of Flash
Memory-Based Solid-State Drives. ACM Transactions on Storage 12, 3, Article 13
(May 2016).
[5] Soyee Choi, Dong Hyun Kang, Sang-Won Lee, and Young Ik Eom. 2020. Concur-
rent Sequential Writes Also Considered Harmful in Solid State Drives (Poster
paper). In Proceedings of the 18th USENIX Conference on File and Storage Technolo-
gies (FAST ’20). USENIX Association.
[6] Soyee Choi, Hyunwoo Park, and Sang Won Lee. 2018. Don’t write all data pages
in one stream. In Proceedings of the 21th International Conference on Extending
Database Technology (Vienna, Austria) (EDBT 2018). 654–657.
[7] Diego Didona, Nikolas Ioannou, Radu Stoica, and Kornilios Kourtis. 2020. To-
ward a Better Understanding and Evaluation of Tree Structures on Flash SSDs.
Proceedings of VLDB Endowment 14, 3 (Nov. 2020), 364–377.
[8] Siying Dong, Mark Callaghan, Leonidas Galanis, Dhruba Borthakur, Tony Savor,
and Michael Strum. 2017. Optimizing Space Amplification in RocksDB. In 8th
Biennial Conference on Innovative Data Systems Research (CIDR) 2017).
[9] Siying Dong, Andrew Kryczka, Yanqin Jin, and Michael Stumm. 2021. Evolution of
Development Priorities in Key-value Stores Serving Large-scale Applications: The
RocksDB Experience. In 19th USENIX Conference on File and Storage Technologies,
FAST 2021. USENIX Association, 33–49.

---

Enlightening Flash Storage to Stream Writes by Objects
[10] FaceBook 2021.
db_bench.
https://github.com/facebook/rocksdb/wiki/
Benchmarking-tools.
[11] Fio: Flexible I/O tester [n.d.]. Fio: Flexible I/O tester. https://github.com/axboe/fio.
[12] Google. 2020. LevelDB. https://github.com/google/leveldb.
[13] Aayush Gupta, Youngjae Kim, and Bhuvan Urgaonkar. 2009. DFTL: A Flash
Translation Layer Employing Demand-based Selective Caching of Page-level
Address Mappings. In Proceedings of the 14th International Conference on Architec-
tural Support for Programming Languages and Operating Systems (ASPLOS XIV).
229–240.
[14] Jun He, Sudarsun Kannan, Andrea C. Arpaci-Dusseau, and Remzi H. Arpaci-
Dusseau. 2017. The Unwritten Contract of Solid State Drives. In Proceedings of
the Twelfth European Conference on Computer Systems (EuroSys ’17). 127–144.
[15] Choulseung Hyun, Jongmoo Choi, Donghee Lee†, and Sam H. No. 2011. To TRIM
or Not to TRIM: Judicious TRIMing for Solid State Drive. In Proceedings of the
23rd ACM Symposium on Operating Systems Principles (SOSP ’11).
[16] Myoungsoo Jung and Mahmut Kandemir. 2012. An Evaluation of Different Page
Allocation Strategies on High-Speed SSDs. In Proceedings of the 4th USENIX
Conference on Hot Topics in Storage and File Systems (HotStorage’12).
[17] Jeong-Uk Kang, Jeeseok Hyun, Hyunjoo Maeng, and Sangyeun Cho. 2014. The
Multi-streamed Solid-State Drive. In 6th USENIX Workshop on Hot Topics in
Storage and File Systems (HotStorage 14).
[18] Minji Kang, Soyee Choi, Gihwan Oh, and Sang Won Lee. 2020. 2R: Efficiently
Isolating Cold Pages in Flash Storages. Proceedings of VLDB Endowment 13, 11
(2020), 2004–2017.
[19] Jaewook Kwak, Sangjin Lee, Kibin Park, Jinwoo Jeong, and Yong Ho Song. 2020.
Cosmos+ OpenSSD: Rapid Prototype for Flash Storage Systems. ACM Transactions
on Storage 16, 3, Article 15 (July 2020), 35 pages.
[20] Changman Lee, Dongho Sim, Joo-Young Hwang, and Sangyeun Cho. 2015. F2FS:
A New File System for Flash Storage. In Proceedings of the 13th USENIX Conference
on File and Storage Technologies (FAST’15). USENIX Association, 273–286.
[21] Scott T. Leutenegger and Daniel Dias. 1993. A Modeling Study of the TPC-C
Benchmark. In Proceedings of the 1993 ACM SIGMOD International Conference
on Management of Data (Washington, D.C., USA) (SIGMOD ’93). Association for
Computing Machinery, New York, NY, USA, 22–31.
https://doi.org/10.1145/
170035.170042
[22] Feifei Li. 2019. Cloud-Native Database Systems at Alibaba: Opportunities and
Challenges. PVLDB 12, 12 (2019), 1942–1945.
[23] Ma, Dongzhe and Feng, Jianhua and Li, Guoliang. 2014. A Survey of Address
Translation Technologies for Flash Memories. ACM Computing Survey 46, 3,
Article 36 (Jan. 2014), 36:1–36:39 pages.
[24] Yoshinori Matsunobu, Siying Dong, and Herman Lee. 2020. MyRocks: LSM-Tree
Database Storage Engine Serving Facebook’s Social Graph. Proceedings of VLDB
Endowment 13, 12 (Aug. 2020).
[25] Micron Technology 2014. TN-FD-23: Calculating Write Amplification Factor.
https://media-www.micron.com/-/media/client/global/documents/products/
technical-note/solid-state-storage/tnfd23_m500_smart_attributes_calc_waf.
pdf?rev=2e6d1f560a1548b3b6d4d8cf60335dca.
[26] Changwoo Min, Kangnyeon Kim, Hyunjin Cho, Sang-Won Lee, and Young Ik
Eom. 2012. SFS: random write considered harmful in solid state drives. In 10th
USENIX Conference on File and Storage Technologies (FAST ’12).
[27] Patrick O’Neil, Edward Cheng, Dieter Gawlick, and Elizabeth O’Neil. 1996. The
Log-Structured Merge-Tree (LSM-Tree). Acta Information 33, 4 (June 1996),
351–385.
[28] OPENSSD TEAM 2019. The OpenSSD Project. http://www.openssd.io.
[29] Hyun-Woo Park, Soyee Choi, Mijin An, and Sang-Won Lee. 2019. Freezing Frozen
Pages with Multi-Stream SSDs. In Proceedings of the 15th International Workshop
on Data Management on New Hardware (DaMoN’19). Article 16, 3 pages.
[30] David A. Patterson, Garth Gibson, and Randy H. Katz. 1988. A Case for Redundant
Arrays of Inexpensive Disks (RAID). In Proceedings of the 1988 ACM SIGMOD
International Conference on Management of Data (SIGMOD ’88). 109–116.
[31] Percona-Lab 2008. tpcc-mysql benchmark. https://github.com/Percona-Lab/tpcc-
mysql.
[32] Mendel Rosenblum and John K. Ousterhout. 1992. The Design and Implementa-
tion of a Log-structured File System. ACM Transactions on Computer Systems 10,
1 (Feb. 1992), 26–52.
[33] Sangwook Shane Hahn and Sungjin Lee and Cheng Ji and Li-Pin Chang and In-
hyuk Yee and Liang Shi and Chun Jason Xue and Jihong Kim. 2017. Improving File
System Performance of Mobile Storage Systems Using a Decoupled Defragmenter.
In 2017 USENIX Annual Technical Conference (USENIX ATC 17). 759–771.
[34] Frank Shu. 2007.
Notification of Deleted Data Proposal for ATA-ACS2.
http://t13.org.
[35] smartmontools. 2021.
Smartmontools Documentation.
https://www.
smartmontools.org/wiki/TocDoc#Tutorials.
[36] Sungjin Lee and Ming Liu and Sangwoo Jun and Shuotao Xu and Jihong Kim and
Arvind. 2016. Application-Managed Flash. In 14th USENIX Conference on File and
Storage Technologies (FAST 16). 339–353.
[37] Wikepedia. 2019. File System Fragmentation. https://en.wikipedia.org/wiki/File_
system_fragmentation.
[38] William Martin(T10 Technical Editor). 2015. SCSI Block Commands - 4 (SBC-
4) (Working Draft Revision 9): 4.34 Stream Control. http://www.t10.org/cgi-
bin/ac.pl?t=f&f=sbc4r09.pdf. , 110–112 pages.
[39] Jingpei Yang, Ned Plasson, Greg Gillis, Nisha Talagala, and Swaminathan Sun-
dararaman. 2014. Don’t Stack Your Log On My Log. In 2nd Workshop on Interac-
tions of NVM/Flash with Operating Systems and Workloads (INFLOW 14). USENIX
Association.

---

