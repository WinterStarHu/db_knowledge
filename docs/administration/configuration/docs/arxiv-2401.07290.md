# Optimizing a Data Science System for Text Reuse Analysis

> 来源: https://arxiv.org/pdf/2401.07290

Optimizing a Data Science System for Text Reuse Analysis
Ananth Mahadevan, Michael Mathioudakis, Eetu Mäkelä and Mikko Tolonen
University of Helsinki, Finland
ABSTRACT
Text reuse is a methodological element of fundamental importance
in humanities research: pieces of text that re-appear across dif-
ferent documents, verbatim or paraphrased, provide invaluable
information about the historical spread and evolution of ideas, en-
able researchers to quantify the intellectual influence of specific
authors and literary works, and sometimes offer precious clues in
revealing the identity of an author or detecting plagiarism. Tradi-
tionally, humanities scholars have studied text reuse at a very small
scale, for example, when comparing the opinions of two authors
(e.g., 18th-century philosophers) as they appear in their texts (e.g.,
their articles). Against that backdrop, large modern digitized cor-
pora offer the opportunity to revolutionize humanities research, as
they enable the joint analysis of text collections that span entire
centuries and the detection of large-scale patterns, impossible to
detect with traditional small-scale analysis. For this opportunity to
materialize, it is necessary to develop efficient data science systems
that perform the corresponding analysis tasks.
In this paper, we share insights from ReceptionReader, a system
for analyzing text reuse in large historical corpora. In particular,
we describe the data management considerations that have allowed
us to move from an originally deployed but unoptimized version of
the system to an extensively evaluated and substantially optimized
version, which is destined to be the newly deployed version of the
system. The system is built upon large digitized corpora of 18th-
century texts, which include almost all known books, articles, and
newspapers from that period. It implements a data management
and processing pipeline for billions of instances of text reuse. Its
main functionality is to perform downstream analysis tasks related
to text reuse, such as finding the instances of text reuse that stem
from a given article or identifying the most reused quotes from a set
of documents, with each task expressed as a database query. For the
purposes of the paper, we discuss the related design options for data
management, including various levels of database normalization
and query execution, including combinations of distributed data
processing (Apache Spark), indexed row store engine (MariaDB
Aria), and compressed column store engine (MariaDB Columnstore).
Moreover, we present an extensive evaluation in terms of various
metrics of interest (latency, storage size, and computing costs) for
varying workloads, and we offer insights from the trade-offs we
observed and the choices that emerged as optimal in our setting.
In summary, our results demonstrate that (1) for the workloads
that are most relevant to text-reuse analysis, the row store engine
(MariaDB Aria) emerges as the overall optimal choice for executing
analysis tasks at the user-end of the pipeline, (2) big data processing
(Apache Spark) is irreplaceable for all processing stages of the
system’s pipeline.
1
INTRODUCTION
Text reuse is an essential methodological element in humanities
research, which involves the detection and analysis of similar pieces
of text across different documents. It offers a window into the his-
torical evolution and dissemination of ideas, allowing researchers to
trace intellectual influences, quantify the impact of specific authors
and literary works, and occasionally unravel author identities or
detect plagiarism instances. Traditionally, text reuse analysis has
been conducted on a small scale, such as comparing the writings
of two philosophers. However, the advent of large-scale digitized
historical corpora spanning centuries has transformed this field.
Modern algorithms enable the automatic detection of text reuses
across documents, and modern technology enables the analysis
of these reuses, uncovering large-scale reuse patterns that were
previously indiscernible with smaller-scale analysis.
In
this
paper,
we
present
insights
learned
from
ReceptionReader,
a
system
designed
for
analyzing
text
reuse in large historical corpora. The ReceptionReader system
is built upon billions of pre-processed text reuses identified from
18th-century documents. These documents include a vast array of
books, articles, and newspapers from the 17th and 18th centuries.
They are primarily digitized using Optical Character Recognition
(OCR) which tends to be noisy and error-prone. The raw text reuses
are obtained using a fuzzy-string-matching algorithm adapted
to identify similar pieces of text between documents amidst
noisy OCR data. These reuses are then pre-processed by merging
and clustering the individual text pieces. This pre-processing
pipeline results from continuous domain-driven research in digital
humanities and is described in Section 2. The system uses the
pre-processed text reuses to provide functionality for two main
downstream analysis tasks. The first task, reception, is finding all
the text reuses that stem from a particular document The second
task, top quotes, is identifying the most reused quotes from a set
of documents.
We are interested in optimizing system performance metrics,
such as query latency, data storage size, and computing costs for
each downstream analysis task. Hence, based on these metrics, we
evaluate various design choices for the data management, storage
and processing of the pre-processed text reuses. In particular, we
consider three data management choices corresponding to three
levels of database normalization: fully normalized data (referred
to as Standard), task-agnostic normalized tables (Intermediate),
and task-specific denormalized data (Denorm). Moreover, we con-
sider three frameworks for data storage and query execution: dis-
tributed data processing (Apache Spark), indexed row store data-
base (MariaDB Aria), and compressed column store database (Mari-
aDB Columnstore).
We extensively evaluate each design choice over various work-
loads for each downstream analysis task. We study the trade-offs
provided and discuss the insights that enabled the evolution from an
initial, deployed, but unoptimized version to a highly optimized sys-
tem for analyzing text reuses. From our results, we observe that the
data management choices offer a trade-off between data storage size
and query latency. Specifically, materializing Denorm level data has
arXiv:2401.07290v1  [cs.DB]  14 Jan 2024

---

the best query latency with increased data storage size, especially
for the reception task. On the other hand, the frameworks evaluated
offer an independent trade-off between data storage, query execu-
tion costs and workload consistency. For example, the Columnstore
framework has a smaller data storage size compared to Aria for the
same data normalization level. However, the Columnstore frame-
work has higher query latency resulting in larger cost for query
execution in comparison to Aria. Similarly, the Spark framework
has the highest query execution cost but is the only framework that
completes task queries with a high workload.
In summary, from our evaluation we find that the Aria frame-
work, especially with Denorm level data, is optimal considering
workloads relevant to the analysis of text reuses. Furthermore, the
Spark framework is irreplaceable for the pre-processing and materi-
alization phases in the system. Finally, the Columnstore framework
is a good trade-off between data storage cost and query latency,
however, is only feasible with the Denorm level normalized data.
The paper is organized as follows. Section 2 describes the text
corpora, reuse detection method and the pre-processing pipeline
of the ReceptionReader system. Section 3 discusses the datasets,
metrics and design choices evaluated. The queries and workloads
for the reception and top-quotes tasks are described in Sections 4
and 5 respectively. In Section 6, we present the evaluation results
for each design choice and discuss the trade-offs offered and key
insights. We highlight related works in Section 7 and present our
conclusions in Section 8.
2
BACKGROUND
This section provides the necessary background to understand the
ReceptionReader system. First, Section 2.1 introduces the three
collections that make up our large historical text corpora. Next,
Section 2.2 discusses the algorithm used to detect text reuses across
documents in the corpora. Finally, Section 2.3 describes the phases
in the pipeline for pre-processing the text reuses.
2.1
Historical Text Corpora
The historical text corpora used in our system come from different
document collections shown in Table 1. The Eighteenth Century
Collections Online (ECCO) [8, 10] consists of English language books
published in the 18th century digitized using a mix of OCR [5] and
manual transcription [9]. The Early English Books Online Text
Creation Partnership (EEBO-TCP) [14] consists of accurately tran-
scribed books spanning the 17th and 18th centuries. The British
Library Newspapers (Newspapers) [7] collection contains over 300
years of published newspaper articles digitized using OCR.
There are two challenges in working with several document
collections. First, each collection has its own unique metadata for-
mat and different set of metadata attributes. Such heterogeneous
sources of metadata make downstream queries complex requiring
several table joins and brittle to the addition of more collections.
Therefore, we collect, parse and standardize the metadata attributes
required for downstream tasks such as publication dates, document
titles and authors. Second, research has shown that text from OCR
is noisy and error-prone due to several factors, such as archaic
fonts [11], document layouts [5] and scanning quality [20]. Fur-
thermore, the quality of the OCR varies significantly within and
without collections [13]. Such OCR errors and variance in OCR
noise pose challenges in identifying similar pieces of text. We ad-
dress this challenge by using novel algorithms that are robust to
OCR noise and errors.
Table 1: Collections in the historical text corpora. Document
length is measured in number of characters.
Collection
Publication Years
# Docs
Avg. Doc Length
ECCO
1505-1839
207613
295641
EEBO-TCP
1473-1865
60327
18148
Newspapers
1604-1804
1769266
9519
2.2
Text Reuse Detection
Standard string matching algorithms perform poorly in identifying
similar pieces of text in the presence of OCR noise. Therefore, we
use BLAST (Basic Local Alignment Search Tool) [2], a fuzzy-string-
matching algorithm that is widely used for DNA sequence matching
and has proved to be more effective than alternatives in finding
text reuses with noisy OCR data [19]. We adapt the algorithm as
seen in Vesanto [17] to find similar pieces of text in a large corpora.
First, we encode the text of each document in the corpora into
the format used by BLAST. Then, using these encoded texts, we
run the BLAST algorithm comparing every document against the
entire corpora. BLAST returns hits, which are the similar pairs of
text between documents. Each hit contains a pair of document IDs
along with the starting and ending offsets within the respective
document’s encoded text. These encoded offset values are decoded
to obtain the starting and ending offsets in the original text of
the document. Therefore, we define a piece as a fragment of text
identified by the tuple of a document ID, the starting and ending
offsets. In addition, we define a text reuse as an undirected edge
between similar pieces.
2.3
Pre-processing Pipeline
The text reuses obtained as hits using the BLAST algorithm require
pre-processing before they are useful for downstream tasks. This
pipeline is illustrated in Figure 1 and its three phases are as follows.
Phase 1: Defragmentation. When a paragraph of text is reused
in several documents, it’s starting and ending offsets in different
BLAST hits might differ slightly due to the OCR noise and the
fuzzy-string matching. This phenomenon is known as fragmenta-
tion and is depicted as overlapping red boxes in documents B and D
in Figure 1. Such fragmentation leads to issues in the downstream
tasks, either due to redundancy (multiple overlapping pieces refer-
ring to the same text) or loss of results (e.g., identifying only short
matches rather than longer matching passages). To remedy this, we
perform a “conservative” merging of overlapping pieces within a
document. This only merges pieces of similar length that overlap
a given amount, thereby ensuring that smaller pieces do not get
merged into larger overlapping pieces. This behavior is beneficial
because smaller pieces have a different contextual meaning than
larger text reuse pieces. The conservative merging process results
in new defragmented pieces and the mapping between defragmented
2

---

A
B
C
D
A
B
C
D
A
B
C
D
Defragment
& Cluster
Identify Sources
q Doc
Piece
Text Reuse
Defrag Piece
Defrag Text Reuse
Cluster
Source Piece
Destination Piece
Reception
Figure 1: Illustration of the pre-processing pipeline for text reuses. The hits from BLAST (red) are first defragmented (blue) and
then clustered (purple). Then in each cluster, the piece from the earliest document is identified as the source (yellow) and the
rest are destinations (green). The directed edge between a source and destination piece is a reception edge.
pieces are the new defragmented text reuses depicted by blue boxes
and lines in Figure 1 respectively.
Phase 2: Clustering. We create a reuse network where defrag-
mented pieces are nodes and text reuse pairs are edges. This net-
work is clustered to find all the similar text pieces across documents.
For the network clustering we use Chinese Whispers [3], a label-
propagation graph clustering algorithm. The resulting clusters are
groups similar of pieces from different documents depicted by pur-
ple enclosures in Figure 1.
Phase 3: Source identification. In each cluster, we identify the
earliest piece(s) using the publication dates from the document
metadata. These earliest pieces are called the “sources” of the text
reuse in that cluster. Furthermore, the pieces which are not sources
in a cluster are called the “destination” of the text reuse in that
cluster. Hence, an edge from a source piece to a destination piece
signifies the direction of the text reuse and is called a reception
edge. Due to the granularity of the publication date metadata from
different collections, there can be several source pieces in each
cluster. In such scenarios, we treat each source piece as equal and
possible originations for the text reuse in a cluster. Hence, in such
multi-source clusters, each destination piece will have multiple
incoming reception edges. The reception edges are used to find text
reuses that either originate from or end on particular documents
for downstream tasks.
For the purposes of this paper, the three-phase pre-processing
pipeline described above is considered fixed, as it has been devel-
oped through years of field expertise by the digital humanities
researchers in our team. The pre-processing pipeline has been im-
plemented in Apache Spark and can scale to billions of raw BLAST
hits. At the end of the pre-processing pipeline, we obtain data
in the form of several Spark data frames stored as Parquet files.
We omit the nuances of the complex document-metadata relation-
ships and present a simplified schema shown in Figure 2. In the
docs
doc_id
doc_name
defrag_textreuses
textreuse_id
piece1_id
piece2_id
num_orig_links
defrag_pieces
piece_id
doc_id
start
end
clustered_defrag_pieces
cluster_id
piece_id
source_pieces
cluster_id
piece_id
doc_authors
doc_id
author_id
doc_publication_date
doc_id
publication_date
Figure 2: Simplified data schema for pre-processed text reuses
following sections, we will use this simplified schema to explain
the ReceptionReader system and the downstream tasks.
3
EVALUATION SETUP
In this section, we describe the setup of the experimental evalu-
ation. First, Section 3.1 presents the two text reuse datasets used
to evaluate the system. Then, in Section 3.2, we discuss the three
data management design choices expressed as levels of database
normalization. Next, Section 3.3 presents the three frameworks
for data storage and query execution. Additionally, Section 3.4 de-
scribes how to materialize and load the data for each normalization
level and framework combination. Finally, Sections 3.5 and 3.6 dis-
cuss the implementation details of the frameworks and the system
evaluation metrics respectively.
3

---

Table 2: Text Reuse Datasets
Attribute
Dataset
Basic
Extended
Collections
ECCO &
ECCO, EEBO-TCP
EEBO-TCP
& Newspapers
# documents
267940
2037206
BLAST hits
965665512
6310546114
# defragmented pieces
383894269
1098916260
Avg. defragmented piece length
748
461
# defragmented reuses
965134100
5608256233
# clusters
50332146
91576355
# authors
46017
46017
3.1
Datasets
Following the steps mentioned in Sections 2.2 and 2.3 we collect
two datasets of text reuse, shown in Table 2. The dataset used in our
originally deployed ReceptionReader system is called Basic and
consists of the text reuses between documents, primarily books,
from the ECCO and EEBO-TCP collections. The dataset starts with
nearly one billion hits from the BLAST algorithm for fuzzy string
matching. After pre-processing there are 383 million pieces in 47
million text reuse clusters.
The second dataset, Extended, consists of text reuses between
documents from all the collections in Table 1. This dataset contains
nearly 6.5× BLAST hits compared to the Basic dataset due to the
inclusion of the Newspapers collection. We see similar increases af-
ter pre-processing resulting in 2.8× more defragmented pieces and
1.9× more text reuse clusters. However, note that the number of au-
thors do not increase because the Newspapers collection’s metadata
does not contain authorship attributes. Furthermore, newspaper
articles are smaller than books, resulting in an average piece being
1.6× shorter. We use the Extended dataset in our evaluation to
showcase the scalability of the ReceptionReader system.
3.2
Data Normalization Levels
We consider three design choices for data management expressed as
three levels of database normalization. Each level of normalization
consists of different materialized data tables for each downstream
analysis task. The levels range from using fully normalized data to
task-specific denormalized data. On one end, fully normalized data
reduces redundancies and used lesser storage space while making
queries for downstream tasks more computationally demanding.
On the other end, materializing task-specific data requires more
storage space while making the queries for downstream tasks faster.
We now describe the three normalization levels.
First, the Standard normalization level uses fully normalized
data as per the schema shown in Figure 2. The queries for down-
stream tasks will require joining several tables and filtering them
to obtain the desired result.
Second, the Intermediate normalization level materializes data
which is task-agnostic and can be used in each of the down-
stream tasks. Specifically, we materialize the pieces in each text
reuse cluster which are the destination of the reuses (i.e., not
1 SELECT cluster_id,piece_id FROM source_pieces sp
2 RIGHT JOIN clustered_defrag_pieces cdp
3 USING(cluster_id,piece_id)
4 WHERE sp.piece_id IS NULL
Listing 1: SQL for destination_pieces
the source pieces). We call this table destination_pieces and
the SQL query to materialize it is shown in Listing 1. The SQL
query performs an exclusive right join on the source_pieces
and clustered_defrafg_pieces tables from Figure 2 to ob-
tain the pieces and their respective clusters which are not in
the source_pieces table. These destination pieces are task-
agnostic and useful in both the reception and top quotes tasks.
Therefore, the main difference between the queries for the
Standard and Intermediate normalization levels is whether the
destination_pieces table is materialized.
Third, the Denorm normalization level materializes task-specific
data that aids in answering the queries of the specific downstream
task. For each downstream task, we first express the task-specific
data as SQL queries which use the normalized tables seen in Fig-
ure 2. Then, we materialize the data in the system and use it while
answering the downstream queries. We describe the Denorm level
data and queries for each task in the upcoming sections.
3.3
Data Storage and Query Execution
We evaluate the ReceptionReader system on three frameworks
for data storage and query execution. Each framework has a unique
format to store the data and a corresponding SQL execution engine
to answer downstream tasks expressed as SQL queries. The different
frameworks and their components are shown in Table 3.
Table 3: Storage formats and query execution engines for
different frameworks
Framework
Storage Format
Query Execution
Spark
Apache Parquet
Apache Spark SQL
Aria
indexed row-store
MariaDB Aria
Columnstore
compressed column-store
MariaDB ColumnStore
In the Spark framework, the data is stored as Parquet files on a
cloud object storage platform. These Parquet file objects are loaded
in Spark as distributed data frames and then used to answer SQL
queries. In both the relational Aria and Columnstore frameworks,
a MariaDB database is created, and the data are loaded into tables in
their respective storage formats. Additionally, for the Aria frame-
work, we create B+-tree indexes on the essential columns of each
table. The downstream tasks, expressed as SQL queries, are run on
the framework’s execution engines with the appropriate tables to
obtain results.
3.4
Data Materialization and Loading
At the end of the pre-processing pipeline described in Section 2.3,
the text reuse data is stored as Parquet files in the normalized
schema shown in Figure 2, which corresponds to the Standard
4

---

Table 4: Data storage and query execution costs of different
frameworks in CSC Billing Units (BU)
Framework
Data Storage Cost
Query Execution Cost
Spark
1 BU/TiB hr
1254 BU/hr
Aria
3.5 BU/TiB hr
24 BU/hr
Columnstore
3.5 BU/TiB hr
24 BU/hr
normalization level (as explained in Section 3.2 above). Obtaining
the Intermediate and Denorm from the Standard normalization
level requires materializing additional data. Below we describe two
approaches for the data materialization, depending on whether we
use Spark or the relational frameworks (Aria or Columnstore) to
perform it.
The first approach is to materialize all the necessary data using
the Spark framework and then bulk-load the data into the Aria
and Columnstore frameworks. Towards this, we execute the mate-
rialization SQL query for a given normalization level in the Spark
framework and store the data as Parquet files. Then, we load the
necessary Parquet files into the Aria and Columnstore frameworks
as tables.
The second approach is to use the relational frameworks (Aria
and Columnstore) frameworks to perform the materialization di-
rectly in their storage formats. Towards this, we first load all the
pre-processed data into the Aria and Columnstore frameworks.
Then, in each framework, we execute the materialization SQL query
for a given normalization level and store the result as a table in the
respective storage format.
3.5
Framework Implementation
We use the cloud computing resources provided by CSC1 to imple-
ment and evaluate the different frameworks described in Section 3.3.
The Spark framework is implemented as a Kubernetes cluster
on CSC’s Rahti service. The cluster has 38 worker pods and one
driver pod. Each worker (and driver) pod has two cores and 32 GiB
RAM. Only the driver pod has 16 GiB persistent storage for storing
code and runtime environments. All the data are stored in cloud
data buckets on CSC’s Allas service and accessed in Spark using
the S3 API2.
The Aria and Columnstore frameworks are implemented on
CSC’s Pouta service. We create a Virtual Machine (VM) which has
16 cores, 78 GiB RAM and 700 GiB SSD storage. Then we attach a
persistent cloud storage volume to the VM and create ZFS pool and
designate the SSD as cache. This configuration offers larger storage
space as well as better I/O performance.
There are resource costs for running the system in CSC measured
in Billing Units (BU). In Table 4, we report data storage and query
execution costs for each framework as per our implementation.
3.6
Metrics of Interest
Each downstream analysis task is expressed as a database query
and executed on the framework of the system. Hence, the system
performance for a given query is affected by the design choices as
1https://research.csc.fi/cloud-computing
2https://spark.apache.org/docs/latest/cloud-integration.html
well as the downstream task. We evaluate the performance of the
system using the three important metrics described below.
Query Latency The time duration to obtain a result set for a query
is defined as the query latency. In practice, we measure latency as
the time taken to iterate through all the rows from the result set of
a query. Furthermore, to mitigate the effect of network latency on
the query latency, in the Aria and Columnstore frameworks, we
execute the queries directly on the VM where the data is stored. A
low query latency is desirable as it leads to better user experience.
Furthermore, the workload of a query determines the computa-
tional effort required to return a result set which directly affects
the query latency. For our experiments, we define the workload
of each downstream analysis query and evaluate the system over
different query workloads.
Data Storage Size and Cost We define the data storage size as
the total size of the materialized data required to answer a given
query. In practice, we measure size of the materialized data as the
disk space used. By its definition, the data storage size depends
on the normalization level and the framework of the system. The
costs for data storage in different frameworks is shown in Table 4
measured in CSC Billing Units per tebibyte hour (BU/TiB hr). A low
query storage size is desirable as it leads to lower costs for storing
the data and indicates better scalability. In our experiments, for
a given framework, we calculate the data storage size in TiB for
each combination of normalization level and downstream task and
report the total storage cost in BU/hr.
Query Execution Cost The cost of computational resources re-
quired to answer a downstream query is defined as the query ex-
ecution cost. In practice, we use the execution cost for a given
framework shown in Table 4, and the query latency to compute the
cost to execute one query in that framework. A low query execution
cost is desirable as it reduces the cost of running the system and in
turn allows scaling to multiple users.
4
RECEPTION TASK
In this downstream analysis task, the aim is to find all the text
reuses that originate from a given a query document, denoted by 𝐷.
Section 4.1 describes the queries to achieve this task at each level
of data normalization. Then, Section 4.2 quantifies the workload
of a reception query and analyzes the distribution of the workload.
Lastly, we describe the process of sampling the workload distribu-
tion to get query documents for the system evaluation.
4.1
Reception Queries
The steps to find the text reuses that originate from a document
𝐷are as follows. First, we find all the clusters where the source
piece originates from 𝐷. Next, we gather all the destination pieces
of those clusters. Lastly, we create a mapping between a source
piece and each destination piece in a cluster. These mappings are
the reception edges, and we return them as the result set.
Following the above steps, the SQL query for the Intermediate
normalization level is shown in Listing 2. This normalization level
contains data from the schema shown in Figure 2 and the additional
materialized destination_pieces table. The SQL query requires
one join to find the source clusters and a further two joins to find
the text reuses. In the result set, each row contains one reception
5

---

1 WITH doc_pieces AS (
2
SELECT * FROM defrag_pieces
3
WHERE doc_id = D
4 ),doc_clusters_and_src_pieces AS (
5
SELECT cluster_id, dp.*
6
FROM source_pieces
7
INNER JOIN doc_pieces dp USING(piece_id)
8 )SELECT
dp1.doc_id AS src_doc_id,
9
dp1.start AS src_start,
10
dp1.end AS src_end,
11
dp2.doc_id AS dst_doc_id,
12
dp2.start AS dst_start,
13
dp2.end AS dst_end
14 FROM doc_clusters_and_src_pieces dp1
15 INNER JOIN destination_pieces dsp USING(cluster_id)
16 INNER JOIN defrag_pieces dp2 ON dsp.piece_id = dp2.piece_id
Listing 2: Intermediate level Reception query
Table 5: Reception Denorm table attributes
reception_edges_denorm
Attribute
Description
src_doc_id
Source piece document ID
src_start
Source piece start offset
src_end
Source piece end offset
dst_doc_id
Destination piece document ID
dst_start
Destination piece start offset
dst_end
Destination piece end offset
edge between a source piece from the given document 𝐷and a
destination piece.
The only difference for the Standard normalization level is that
the destination_pieces data is not materialized. Therefore, the
Standard level reception query contains the additional subquery
shown in Listing 1.
For the Denorm normalization level, we materialize a table called
reception_edges_denorm, containing the reception edges for all
the documents in the dataset. The attributes of the table and the SQL
query for materializing it are shown in Table 5 and Listing 3 respec-
tively. Once the table is materialized, the Denorm level reception
query is a simple filtering query as seen in Listing 4.
The materialization query shown in Listing 3 first creates a
mapping from each source piece ID in a cluster to every destination
piece ID of that cluster. This mapping, called the reception_edges
subquery, is denormalized to obtain the document ID and offsets for
the source and destination pieces. Table 6 shows the statistics of the
materialized table for different datasets. We see that each dataset has
more than a billion reception edges. Furthermore, the Extended
dataset has 3.7× more reception edges than the Basic dataset. This
large number of reception edges will affect the performance of the
Denorm level query in different frameworks.
4.2
Reception Workload Distribution
The workload of a reception query is quantified by the number
of reception edges for the given document 𝐷. Figure 3 shows the
1 WITH reception_edges AS(
2
SELECT sp.piece_id as src_piece_id,
3
dsp.piece_id as dst_piece_id
4
FROM source_pieces sp
5
INNER JOIN destination_pieces dsp USING(cluster_id)
6 ) SELECT dp1.doc_id AS src_trs_id,
7
dp1.start AS src_start,
8
dp1.end AS src_end,
9
dp2.doc_id AS dst_doc_id,
10
dp2.start AS dst_start,
11
dp2.end AS dst_end
12
FROM reception_edges re
13
INNER JOIN defrag_pieces dp1
14
ON re.src_piece_id = dp1.piece_id
15
INNER JOIN defrag_pieces dp2
16
ON re.dst_piece_id = dp2.piece_id
Listing 3: Reception task Denorm level materialization query
1 SELECT re.* FROM reception_edges_denorm re
2 WHERE src_doc_id = D
Listing 4: Denorm level Reception query
Table 6: Statistics of reception_edges_denorm table for differ-
ent datasets
Statistic
Basic
Extended
# of reception edges
1277583845
4739160201
# of source documents
227917
1384487
# of destination documents
246437
1735188
distribution of the number of reception edges for the Basic dataset.
We see that on one end there are a lot of documents with only one
reception edge and on the other end there are a few documents with
more than 100 million text reuses. This indicates that the workload
follows a power-law distribution with a heavy-tail. We see a similar
distribution for the larger Extended dataset.
To effectively evaluate the impact of the workload on the system
performance, we sample 10 documents from 10 logarithmic spaced
buckets labelled 0 to 9 shown in Figure 3. Documents from higher
numbered buckets have more reception edges causing reception
queries to take longer and vice versa. These 100 sampled documents
of varying workloads are used to study the trade-offs offered by
different normalization levels and frameworks.
5
TOP QUOTES TASK
In this task, we are given a set of documents called an edition
denoted by 𝐸. The goal is to find the top 100 most reused quotes
from those documents. Specifically, based on domain expertise, we
define a quote as a piece of text between 150 and 300 characters long
that has been reused in documents written by a different author
at least once. In Section 5.1, we describe the queries for the task at
different data normalization levels. Then, in Section 5.2, we quantify
and study the workload of a top quotes query. Finally, we describe
6

---

101
103
105
107
Number of reception edges
101
102
103
104
Frequency
Distribution
Bucket 0
Bucket 1
Bucket 2
Bucket 3
Bucket 4
Bucket 5
Bucket 6
Bucket 7
Bucket 8
Bucket 9
Figure 3: Reception task workload distribution for the Basic
dataset. The log-spaced buckets, shown as vertical bands, are
used for sampling query documents for system evaluation.
the process to sample editions from the query workload distribution
to evaluate the system.
5.1
Top Quotes Queries
The importance of a quote is quantified by the number of times it
is reused in documents written by a different author, denoted by
n_reuses. Given an edition set 𝐸, the three steps for computing the
n_reuses statistic and finding the top 100 quotes are as follows.
First, we find all clusters where a source piece originates from
the documents in 𝐸and is between 150 and 300 characters long.
Second, we find the authors of the documents in 𝐸. Third, for each
source piece cluster from step one, we gather the destination pieces
and find the document and the author of each destination piece.
Then, using the authors of 𝐸from the second step, we count the
number of unique destination documents with different authors.
This count is the n_reuses statistic for the cluster, which is mapped
back to the source pieces of that cluster. Finally, we sort the source
pieces in descending order of the n_reuses statistic and return the
first 100 pieces as the top quotes.
The Intermediate level SQL query following the above steps
is shown in Listing 5. The first two steps are simple subqueries
performing table joins and filtering based on the query set 𝐸and
piece length. The third step is a group-by aggregation over clusters
using the materialized destination_pieces table. The final result
set is obtained after ordering the source pieces based on n_reuses
and limiting them to the top 100 rows.
The only change for the Standard level SQL query is the inclu-
sion of the subquery for the destination_pieces table shown in
Listing 1.
For the Denorm level, we materialize a table with the n_works
statistic pre-computed for each source piece in the dataset regard-
less of length. The materialization SQL query is similar to the query
shown in Listing 5 without the first filtering subquery. We refer
to this materialized table as source_piece_statistics_denorm
and its attributes are described in Table 7. The Denorm level SQL
query then filters the materialized table based on the documents
in edition 𝐸and piece length as shown in Listing 6. The statistics
of the materialized table for different datasets is shown in Table 8.
1 WITH filtered_clusters AS (
2
SELECT cluster_id, dp.* FROM defrag_pieces dp
3
INNER JOIN source_pieces
4
USING(piece_id)
5
WHERE doc_id IN E
6
AND (dp.end - dp.start) BETWEEN 150 AND 300
7 ),query_authors AS ( SELECT DISTINCT author_id
8
FROM doc_authors
9
WHERE doc_id IN E
10
AND author_id IS NOT NULL
11 ), cluster_stats AS (SELECT cluster_id,
12
COUNT(DISTINCT doc_id) as n_reuses
13
FROM filtered_clusters
14
INNER JOIN destination_pieces nsp
15
USING (cluster_id)
16
INNER JOIN defrag_pieces dp
17
ON dsp.piece_id = dp.piece_id
18
INNER JOIN edition_authors USING(doc_id)
19
-- left exclusive join
20
LEFT JOIN query_authors qa USING(author_id)
21
-- only authors who are not the same as query authors
22
WHERE qa.author_id_i IS NULL
23
GROUP
BY cluster_id
24 ),results AS (
25
SELECT *,end-start AS piece_length
26
FROM cluster_stats INNER JOIN filtered_clusters
27
USING (cluster_id)
28 )SELECT * FROM results
29 ORDER BY n_reuses DESC,piece_length DESC
30 LIMIT 100
Listing 5: Intermediate level Top Quotes query
Table 7: Top Quotes Denorm table attributes
source_piece_statistics_denrom
Attribute
Description
piece_id
Source piece id
cluster_id
Cluster id
doc_id
Source document id
start
Piece start offset
end
Piece end offset
piece_length
Length of piece
n_reuses
# reuses from other authors
The Extended dataset has 1.6× more source pieces from 6× from
documents. Furthermore, the number of editions in both datasets
are similar to the number of documents. Therefore, each edition set
contains a few documents.
5.2
Top Quotes Workload Distribution
We now quantify the workload of a top quotes query for a given
edition set 𝐸. No additional work is required for the Denorm level
because the n_reuses statistic is pre-computed. However, for
the Standard and Intermediate level queries, computing the
n_reuses statistic is the main workload, which depends on two
factors. The first factor is the number of source pieces from the
7

---

Table 8: Statistics of source_piece_statistics_denorm table
for different datasets
Statistic
Basic
Extended
# source pieces
56093986
90144871
# clusters
48314577
77733584
# documents
227917
1384487
# editions
209305
1365831
Avg. piece length
1236
964
Avg. n_reuses
2.6966
6.6588
1 SELECT piece_id,n_reuses,
2 cluster_id,doc_id,start,end,piece_length
3 FROM
source_piece_statistics_denorm
4 WHERE doc_id IN E
5 AND piece_length BETWEEN 150 AND 300
6 ORDER BY n_reuses DESC, piece_length DESC
7 LIMIT 100
Listing 6: The Denorm query for top quotes task
documents in 𝐸. The second factor is the number of destination
pieces for each source piece. This second factor correlates with the
n_reuses statistic. Furthermore, the sum of the n_reuses statis-
tic for a given edition set, denoted by sum_n_reuses, correlates
with the overall computational workload. Therefore, we use the
sum_n_reuses statistic to quantify the workload of a top quotes
query.
Figure 4 displays the distribution of the sum_n_reuses statistic
for all edition sets in the Basic dataset. Similar to the reception task,
the workload distribution follows a power-law curve with a few
edition sets having greater than a million other documents reusing
the text from the edition. However, we also see that some edition
sets have sum_n_reuses as low as one. Therefore, to effectively
sample from the workload distribution, we set a lower threshold
of 100 for the sum_n_reuses statistic. This threshold ensures that,
on average, each source piece in the top 100 quotes of a sampled
edition will have at least one other author’s document reusing it.
From the thresholded sum_n_reuses distribution, we sample 10
editions, each from one of 10 log-spaced buckets numbered from 0
to 9. These sum_n_reuses values for the sampled edition are shown
Figure 4 as colored vertical lines. Similarly, 10 editions are sampled
from the workload distribution of the Extended dataset. These
sampled editions are used as the query edition 𝐸to evaluate the
system performance for different design choices.
6
RESULTS AND DISCUSSION
As discussed in Section 3, our evaluation is structured around the
two core design choices of database normalization levels and frame-
works for data storage & query execution. Each design choice has
three options namely Standard, Intermediate and Denorm nor-
malization levels and the Spark, Aria and Columnstore frame-
works. We evaluate each design choice combination on metrics
such as query latency, data storage size, and computing costs. The
aim of this evaluation is to identify the most effective combination
101
103
105
sum_n_reuses
101
102
103
104
Frequency
Distribution
Treshold
Sample 0
Sample 1
Sample 2
Sample 3
Sample 4
Sample 5
Sample 6
Sample 7
Sample 8
Sample 9
Figure
4:
Top
Quotes
task
workload
distribution
(sum_n_reuses)
for
the
Basic
dataset.
The
threshold
for sampling at 100 is shown as a vertical dashed line. The
workload of the 10 sampled edition sets are shown as solid
vertical lines.
of design choices for optimizing the system’s performance under
various workloads for the two downstream text reuse analysis tasks.
For each combination of normalization level and framework the
evaluation is conducted as follows. First, we gather the text reuse
data for the given dataset from the pre-processing pipeline. Then,
we materialize any additional data using the Spark framework and,
if necessary, load the data into the framework being evaluated.
Next, for each document sampled from the reception workload
distribution (see Section 4.2), we execute the reception query with a
timeout of five minutes. Similarly, for each edition set sampled from
the workload distribution of the top quotes task (see Section 5.2), we
execute the top quotes query with a timeout of 15 minutes. For each
query executed, we collect the query latency and other metrics.
The results from the evaluation are reported and discussed in
the following sections. Section 6.1 discusses the practicalities in
materializing data for the Intermediate and Denorm levels and
loading them into the Aria and Columnstore frameworks. Then,
Section 6.2 presents the query latency results across different work-
loads for each downstream tasks and discusses the impact of each
design choice. Lastly, Section 6.3 presents the trade-offs between
data storage and query execution costs for each design choice.
6.1
Materialization and Loading Results
First, we discuss the practicalities related to materializing the data
for the Intermediate and Denorm levels and then the loading the
data into the Aria and Columnstore frameworks. Then, we present
the materialization and loading time results and discuss the insights.
Materialization Practicalities. Section 3.4 describes two ap-
proaches for materializing the data required for the Intermediate
and Denorm levels. The first approach uses the Spark framework to
execute SQL queries and materialize the data as Parquet files. The
second approach loads the Standard data into the relational frame-
works (Aria and Columnstore) and uses the relational engine to
execute SQL queries to materialize the data as tables. However, in
our experiments, we found that the second approach is only possi-
ble when using the Aria framework and the Intermediate level.
8

---

Table 9: Materialization and Loading times (in seconds)
by normalization level and framework for the Extended
dataset. Each cell shows the loading time with the material-
ization time using Spark in parentheses.
Normalization
Framework
Level
Aria
Columnstore
Intermediate
4552 (122)
5519 (122)
Denorm (Reception Task)
24550 (690)
52222 (690)
Denorm (Top Quotes Task)
639 (1472)
953 (1472)
Even in this case, the time taken to materialize the table and index
it in Aria was twice as long as the first approach. Furthermore, for
the Denorm level, the second approach failed to complete after 24
hours in the Aria framework and reported a memory error in the
Columnstore framework. Therefore, in this section, we only report
the results from using the Spark framework for materialization.
Data Loading Practicalities. After the data is materialized us-
ing Spark, it is loaded into the Aria and Columnstore frame-
works. For the Aria framework, we turn off database transactions
for tables and load data in parallel from Spark using the JDBC
API3. However, database transactions cannot be disabled for ta-
bles in the Columnstore framework, resulting in infeasible loading
times for large tables using JDBC. Therefore, we use the cimport4
tool to instead bulk-load data from tables in the Aria framework
into Columnstore. Furthermore, because loading sorted tables into
Columnstore increases the system performance, we first index the
Aria tables and then load sorted data into Columnstore.
Table 9 reports the time taken to then load the data for each
normalization level into Aria and Columnstore after it has been
materialized using Spark for the Extended dataset. For the Aria
framework, the reported loading time includes the time spent index-
ing the table. Similarly, due to the practicalities mentioned above,
the loading time reported for the Columnstore framework consists
of the time spent in loading the data into and indexing the tables
in Aria along with the time taken to load into Columnstore.
Let us first analyze the Intermediate level results from Table 9.
Materializing the destination_pieces data in Spark only takes a
few minutes. Then, bulk-loading the data into Aria takes 24 minutes
and then indexing the table takes 51 minutes. It then takes 16 more
minutes to bulk-load the indexed data from Aria to Columnstore.
Next, we analyze the Denorm level results for the reception and
top quotes from Table 9. For the reception task, the materialization
is fast in Spark taking 11 minutes while the bulk-loading into and
indexing in Aria are slow taking 2.5 and 4.3 hours respectively.
Then loading the indexed data from Aria into Columnstore takes
an additional 7 hours. These large loading (and indexing) times are
due to the billions of rows in the reception_edges_denorm table
as seen in Table 6. The above trend is reversed for the top quotes
task, where materialization in Spark is slow, taking 24 minutes,
while the bulk-loading into and indexing in Aria is fast, taking
3.5 and 7.1 minutes respectively. Furthermore, loading from Aria
3https://spark.apache.org/docs/latest/sql-data-sources-jdbc.html
4https://mariadb.com/docs/server/data-operations/data-import/enterprise-
columnstore/cpimport/
into Columnstore takes only an additional 5 minutes. This behav-
ior is due to the computational effort required to calculate the
n_reuses statistic and the relatively small size of the resulting
source_piece_statistics_denorm table as seen in Table 8.
In summary, the materialization practicalities discussed above
indicate that the Spark framework is essential to materialize the ad-
ditional data required for the system. Furthermore, the discussion of
loading practicalities highlight the limitations of the Columnstore
framework to bulk-load data both after pre-processing and mate-
rialization. Lastly, the results show the overhead of indexing the
tables in the Aria framework after bulk-loading from Spark.
6.2
Latency results
We present the query latency results for each downstream task
across different workloads.
Reception Task Results. Figure 5 presents the latency results
for the reception task. In each plot, the x-axis corresponds to the
different query workloads and the colors correspond to the different
normalization levels.
From the results, we see that the Standard query in the
Columnstore framework never finishes, even for the smallest work-
load. Furthermore, none of the queries finish for the highest work-
load in both Columnstore and Aria. In contrast, Spark has a high
but consistent query latency across all workloads.
At lower workloads, the Denorm query has the lowest latency
across all frameworks. Specifically, the Aria framework has the low-
est latency compared to the other frameworks due to the presence
of indexed tablesx. However, at higher workloads (6, 7 and 8), the
latency of Aria is dominated by the iteration over the large result
set and not by the query execution. This is evidenced by the similar
query latency for all three normalization levels. Furthermore, the
latency for all frameworks at higher workloads are similar.
Interestingly, the Intermediate query in the Aria framework
has a higher latency compared to the Standard query. Furthermore,
the Denorm query also has a larger latency at higher workloads in
the Extended dataset. These higher latencies were due to system
page faults stemming from a cold cache. Therefore, to heat up the
cache, we re-ran each query twice and recorded the latency from the
second run. We present these hot-cache results for the Extended
dataset in Figure 6. From these results, we observe that all queries
have an overall lower query latency. Moreover, we now see that the
Intermediate and Denorm queries perform similarly with latency
lower than the Standard query.
Top Quotes Results. Figure 7 presents the query latency results
for the top quotes task. Similar to the reception task, we observe
that the Denorm query has the lowest latency across all frame-
works. However, the gap in query latency to the Standard and
Intermediate queries are much larger here due to the cost to com-
pute the n_reuses statistic. Additionally, the latency gap in the
Aria framework is two orders of magnitude due to the presence of
indexed tables with pre-computed n_reuses statistics.
However, the Intermediate and Standard queries on the Aria
framework fail at higher workloads for the Extended dataset. This
is due to the larger aggregations required to compute the n_reuses
statistic at higher workloads. In contrast, the Intermediate query
in the Columnstore framework has a consistent query latency. This
9

---

0
1
2
3
4
5
6
7
8
9
Workload
10−2
10−1
100
101
102
Qery Latency
Spark
Denorm
Intermediate
Standard
0
1
2
3
4
5
6
7
8
9
Workload
Aria
0
1
2
3
4
5
6
7
8
9
Workload
Columnstore
(a) Basic dataset
0
1
2
3
4
5
6
7
8
9
Workload
10−1
101
103
Qery Latency
Spark
Denorm
Intermediate
Standard
0
1
2
3
4
5
6
7
8
9
Workload
Aria
0
1
2
3
4
5
6
7
8
9
Workload
Columnstore
(b) Extended dataset
Figure 5: Reception query latency for different workloads, frameworks and datasets. Missing results indicate that the query
didn’t finish after 5 minutes.
0
1
2
3
4
5
6
7
8
9
Workload
10−2
10−1
100
101
102
Qery Latency
Aria
Denorm
Intermediate
Standard
Figure 6: Reception query latency for Aria framework with
hot cache for Extended dataset
consistency is due to the nature of the columnar data storage and
execution engine built for aggregation queries. For similar reasons,
the Spark framework also has a consistent latency for both the
Intermediate and Standard queries across all workloads.
6.3
Data Storage and Execution Cost Results
Using the size on disk of the materialized data for each normaliza-
tion level and the duration of each downstream query, we compute
the data storage and query execution costs for a framework using
the rates shown in Table 4 For both downstream tasks, we omit
the highest query workload as they do not reflect real-world use-
workloads of the system. We report these costs as trade-off plots in
Figure 8 and Figure 9 for the reception and top quotes tasks respec-
tively. In each plot, the y-axis is the query execution cost measured
in CSC Business Units (BU) and the x-axis is the data storage cost
measured in billing units per hour (BU/hr). The variance in the
query execution cost is caused due to the range of workloads eval-
uated. The desirable region for a design choice is the bottom-left
which corresponds to both low storage and query execution costs.
Let us first analyze the reception task results shown in Figure 8.
We observe that Aria has the lowest execution cost due to its low
latency. However, it also has the highest storage cost due to the
large materialized reception_edges_denorm table and its index.
In contrast, Spark has the lowest storage costs and the highest
execution costs. Finally, the Columnstore framework with Denorm
level data offers a good trade-off between the two costs, especially
for the Extended dataset.
10

---

0
1
2
3
4
5
6
7
8
9
Workload
10−1
101
103
Qery Latency
Spark
Denorm
Intermediate
Standard
0
1
2
3
4
5
6
7
8
9
Workload
Aria
0
1
2
3
4
5
6
7
8
9
Workload
Columnstore
(a) Basic dataset
0
1
2
3
4
5
6
7
8
9
Workload
10−1
100
101
102
103
Qery Latency
Spark
Denorm
Intermediate
Standard
0
1
2
3
4
5
6
7
8
9
Workload
Aria
0
1
2
3
4
5
6
7
8
9
Workload
Columnstore
(b) Extended dataset
Figure 7: Top Quotes query latency for different workloads, frameworks and datasets. Missing results indicate that the query
didn’t finish after 15 minutes.
Normalization Level — Framework
Denorm — Aria
Denorm — Columnstore
Denorm — Spark
Intermediate — Aria
Intermediate — Columnstore
Intermediate — Spark
Standard — Aria
Standard — Columnstore
Standard — Spark
10−2
10−1
Storage Costs (in BU/hr)
10−3
10−2
10−1
100
101
Qery Execution Cost (in BU)
(a) Basic dataset
10−1
Storage Costs (in BU/hr)
10−2
10−1
100
101
Qery Execution Cost (in BU)
(b) Extended dataset
Figure 8: Trade-off plots between query execution and data storage costs for the Reception task. Each framework has a different
marker and each normalization levels has a different color. Lower is better for both metrics.
11

---

10−2
10−1
Storage Costs (in BU/hr)
10−4
10−3
10−2
10−1
100
101
Qery Execution Cost (in BU)
(a) Basic dataset
10−2
10−1
Storage Costs (in BU/hr)
10−3
10−2
10−1
100
101
Qery Execution Cost (in BU)
(b) Extended dataset
Figure 9: Trade-off plots between query execution and data storage costs for the Top Quotes task. Each framework has a
different marker and each normalization levels has a different color. Lower is better for both metrics.
Next, we analyze the top quotes task results shown in Figure 9.
In this task, the smaller size of the Denorm data and the lower la-
tency from indexed tables results in the Aria framework habing
the lowest query execution cost. However, at the Intermediate
and Standard levels, the data storage costs of the Aria framework
is the largest. Moreover, the Aria framework fails at higher work-
loads for Extended dataset as shown in Figure 7b. Therefore, the
Columnstore framework is a better choice for the Intermediate
normalization level and the Spark framework offers the best trade-
off for the Standard normalization level.
6.4
Discussion
We have three main takeaways from the results presented in the
above section.
Denorm queries have the lowest latency For both the downstream
tasks and across frameworks, the Denorm query has the lowest
query latency. The materialization of the task-specific data greatly
helps to lower the time to get answers to queries, especially at lower
workloads. However, for the reception task, the Denorm level comes
with a significant materialization and data storage cost. In contrast,
for the top quotes task, both the materialization and data storage
costs are lower, making Denorm normalization level the best option.
Spark is irreplaceable and good at higher workloads As shown
in Section 6.1, Spark is the only viable approach for materialization
and loading the data required for the Intermediate and Denorm
normalization levels. The Spark framework is also the only frame-
work that works at the highest workload for both downstream
tasks. Additionally, even at higher workloads, the framework offers
a consistent, yet high, query latency even with the Standard data
normalization level.
Columnstore offers a good trade-off The Columnstore frame-
work is the compromise between the Spark and Aria frameworks.
It has higher latency when compared to Aria, but is consistent
across workloads. And similar to Spark, the compressed columnar
storage of the Columnstore framework results in very low storage
costs, even with large Denorm level materialized data. The two main
drawbacks are inability to run any Standard level query and the
significantly high materialization and loading costs.
7
RELATED WORKS
There are several systems for identifying and analyzing text reuses
from in recent literature [6, 12, 15, 18]. These systems use differ-
ent approaches to identifying text reuses from noisy OCR such as
n-grams [16]. All these systems also have a pre-processing phase
that includes filtering, merging and clustering the identified text
reuses. However, many of these systems focus primarily on his-
torical newspaper corpora, and with at most a couple million text
reuses. In contrast, our ReceptionReader system is built to work
with billions of text reuses from a mixture of historical books and
newspaper corpora. Furthermore, we evaluate our system on com-
plex downstream analytical tasks while the other systems simply
provide a front-end interface of the pre-processed text reuses.
Regarding the Aria and Columnstore frameworks considered
in this paper, there are several studies comparing row store and
column store database management systems [1, 4]. However, these
studies are generic using TCP-H benchmarks to analyze the trade-
off between different storage and execution engines. In contrast, we
provide a detailed evaluation of the database frameworks along with
the Spark framework. Moreover, we discuss the materialization
costs and the trade-offs between the different frameworks in context
of analyzing large-scale text reuse data.
8
CONCLUSION
In this paper, we presented ReceptionReader, our system for an-
alyzing text reuses in large historical corpora. We studied the im-
pact of data management, data storage and query execution on
the performance of the system for the two downstream analy-
sis tasks of reception and top quotes. For data management, we
considered three levels of data normalization, namely, Standard,
Intermediate and Denorm, each has its own data materialization
and task-related queries. For data storage and query execution,
we considered three frameworks: Spark, Aria and Columnstore.
We analyzed the trade-off of each combination of normalization
12

---

level and framework in terms of query latency, data storage size
and query execution costs. Our results showed that the Denorm
normalization level in the Aria framework has the lowest query
latency with higher data materialization and storage costs. We
found that the Spark framework is irreplaceable for the large-scale
data processing of the system regardless of the high execution cost.
We noted the limitations of the Columnstore framework in terms
of data loading costs and incompatibility with the Standard nor-
malization level. However, at the Denorm level, the Columnstore
framework offers a good trade-off between data storage and execu-
tion costs, especially as the dataset scales. Lastly, our contributions
showcased the system’s scalability from the Basic dataset to the
6× larger Extended dataset.
In future work, we would like to evaluate the pre-processing
pipeline and other execution frameworks. In particular, a quanti-
tative and qualitative analysis of the text reuse clusters obtained
might offer insights into the nature of text reuses detected during
pre-processing. Furthermore, evaluating a graph database frame-
work for the text reuse network would be interesting.
In conclusion, our paper represents a significant advance in eval-
uating and optimizing scalable data science system for humanities
research. Our findings provide valuable insights into the trade-offs
offered by each design choices towards the practical deployment of
the system.
REFERENCES
[1] Daniel J. Abadi, Samuel R. Madden, and Nabil Hachem. 2008. Column-Stores vs.
Row-Stores: How Different Are They Really?. In Proceedings of the 2008 ACM
SIGMOD International Conference on Management of Data (Vancouver, Canada)
(SIGMOD ’08). Association for Computing Machinery, New York, NY, USA, 967–
980. https://doi.org/10.1145/1376616.1376712
[2] Stephen F. Altschul, Warren Gish, Webb Miller, Eugene W. Myers, and David J.
Lipman. 1990. Basic local alignment search tool. Journal of Molecular Biology
215, 3 (1990), 403–410. https://doi.org/10.1016/S0022-2836(05)80360-2
[3] Chris Biemann. 2006. Chinese Whispers - an Efficient Graph Clustering Algo-
rithm and its Application to Natural Language Processing Problems. In Proceed-
ings of TextGraphs: the First Workshop on Graph Based Methods for Natural Lan-
guage Processing, Rada Mihalcea and Dragomir Radev (Eds.). Association for Com-
putational Linguistics, New York City, 73–80. https://aclanthology.org/W06-3812
[4] Hichem Chaalal, Mostefa Hamdani, and Hafida Belbachir. 2021. Finding the Best
between the Column Store and Row Store Databases. In Proceedings of the 10th
International Conference on Information Systems and Technologies (Lecce, Italy)
(ICIST ’20). Association for Computing Machinery, New York, NY, USA, Article
40, 4 pages. https://doi.org/10.1145/3447568.3448548
[5] Matthew Christy, Anshul Gupta, Elizabeth Grumbach, Laura Mandell, Richard
Furuta, and Ricardo Gutierrez-Osuna. 2017. Mass Digitization of Early Modern
Texts With Optical Character Recognition. J. Comput. Cult. Herit. 11, 1, Article 6
(dec 2017), 25 pages. https://doi.org/10.1145/3075645
[6] Marten Düring, Matteo Romanello, Maud Ehrmann, Kaspar Beelen, Daniele
Guido, Brecht Deseure, Estelle Bunout, Jana Keck, and Petros Apostolopoulos.
2023. impresso Text Reuse at Scale. An interface for the exploration of text reuse
data in semantically enriched historical newspapers. Frontiers in big data 6 (2023),
1249469. https://doi.org/10.3389/fdata.2023.1249469
[7] Gale. [n.d.]. British Library Newspapers. https://www.gale.com/intl/primary-
sources/british-library-newspapers
[8] Gale. 2003. Eighteenth Century Collections Online. https://www.gale.com/intl/
primary-sources/eighteenth-century-collections-online
[9] Gale and University of Michigan. [n.d.]. Eighteenth Century Collections Online
- Text Creation Partnership (ECCO-TCP). https://quod.lib.umich.edu/e/ecco/
[10] Stephen H. Gregg. 2021. Old Books and Digital Publishing: Eighteenth-Century
Collections Online. Cambridge University Press.
[11] Anshul Gupta. 2015. Assessment of OCR Quality and Font Identification in Histor-
ical Documents. Master’s thesis. Texas A & M University.
[12] Martyn Harris, Mark Levene, Dell Zhang, and Dan Levene. 2018. Finding Parallel
Passages in Cultural Heritage Archives. J. Comput. Cult. Herit. 11, 3, Article 15
(aug 2018), 24 pages. https://doi.org/10.1145/3195727
[13] Mark J Hill and Simon Hengchen. 2019.
Quantifying the impact of dirty
OCR on historical text analysis: Eighteenth Century Collections Online as a
case study.
Digital Scholarship in the Humanities 34, 4 (04 2019), 825–843.
https://doi.org/10.1093/llc/fqz024 arXiv:https://academic.oup.com/dsh/article-
pdf/34/4/825/33046904/fqz024.pdf
[14] University of Michigan. 2009. Early English Books Online - Text Creartion
Partnership (EEBO-TCP). https://quod.lib.umich.edu/e/eebogroup/
[15] Glenn Roe, Clovis Gladstone, Robert Morrissey, and Mark Olsen. 2016. Digging
into ECCO: Identifying Commonplaces and other Forms of Text Reuse at Scale..
In Digital Humanities 2016: Conference Abstracts. 336–339.
[16] David A. Smith, Ryan Cordell, and Abby Mullen. 2015. Computational Meth-
ods for Uncovering Reprinted Texts in Antebellum Newspapers. American
Literary History 27, 3 (06 2015), E1–E15.
https://doi.org/10.1093/alh/ajv029
arXiv:https://academic.oup.com/alh/article-pdf/27/3/E1/194881/ajv029.pdf
[17] Aleksi Vesanto. 2018. Detecting and Analyzing Text Reuse with BLAST. Master’s
thesis. University of Turku.
[18] Aleksi Vesanto, Filip Ginter, Hannu Salmi, Asko Nivala, and Tapio Salakoski.
2017. A System for Identifying and Exploring Text Repetition in Large Historical
Document Corpora. In Proceedings of the 21st Nordic Conference on Computational
Linguistics, Jörg Tiedemann and Nina Tahmasebi (Eds.). Association for Computa-
tional Linguistics, Gothenburg, Sweden, 330–333. https://aclanthology.org/W17-
0249
[19] Aleksi Vesanto, Asko Nivala, Heli Rantala, Tapio Salakoski, Hannu Salmi, and
Filip Ginter. 2017. Applying BLAST to Text Reuse Detection in Finnish News-
papers and Journals, 1771-1910. In Proceedings of the NoDaLiDa 2017 Work-
shop on Processing Historical Language, Gerlof Bouma and Yvonne Adesam
(Eds.). Linköping University Electronic Press, Gothenburg, 54–58.
https:
//aclanthology.org/W17-0510
[20] Peng Ye and David Doermann. 2013. Document Image Quality Assessment: A
Brief Survey. In 2013 12th International Conference on Document Analysis and
Recognition. 723–727. https://doi.org/10.1109/ICDAR.2013.148
13

---

