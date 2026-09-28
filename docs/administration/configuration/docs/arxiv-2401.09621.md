# XTable in Action: Seamless Interoperability in Data Lakes

> 来源: https://arxiv.org/pdf/2401.09621

XTABLE in Action: Seamless Interoperability in Data Lakes
Ashvin Agrawal1, Tim Brown2, Anoop Johnson3,
Jesús Camacho-Rodríguez1, Kyle Weller2, Carlo Curino1, Raghu Ramakrishnan1
1Microsoft, 2Onehouse, 3Google
1{ashvin.agrawal, jesusca, carlo.curino, raghu}@microsoft.com, 2{tim, kyle}@onehouse.ai, 3anoopkj@google.com
Abstract
Contemporary approaches to data management are increasingly
relying on unified analytics and AI platforms to foster collabora-
tion, interoperability, seamless access to reliable data, and high
performance. Data Lakes featuring open standard table formats
such as Delta Lake, Apache Hudi, and Apache Iceberg are central
components of these data architectures. Choosing the right format
for managing a table is crucial for achieving the objectives men-
tioned above. The challenge lies in selecting the best format, a task
that is onerous and can yield temporary results, as the ideal choice
may shift over time with data growth, evolving workloads, and the
competitive development of table formats and processing engines.
Moreover, restricting data access to a single format can hinder data
sharing resulting in diminished business value over the long term.
The ability to seamlessly interoperate between formats and with
negligible overhead can effectively address these challenges. Our
solution in this direction is an innovative omni-directional transla-
tor, XTable, that facilitates writing data in one format and reading
it in any format, thus achieving the desired format interoperability.
In this work, we demonstrate the effectiveness of XTable through
application scenarios inspired by real-world use cases.
ACM Reference Format:
Ashvin Agrawal1, Tim Brown2, Anoop Johnson3,, Jesús Camacho-Rodríguez1,
Kyle Weller2, Carlo Curino1, Raghu Ramakrishnan1. 2024. XTable in Action:
Seamless Interoperability in Data Lakes. In Proceedings of ACM Conference
(Conference’17). ACM, New York, NY, USA, 4 pages. https://doi.org/10.1145/
nnnnnnn.nnnnnnn
1
Introduction
In the quest to harness the full potential of data, organizations are
invariably dedicated to eliminating data silos and enabling analyt-
ics on a single copy of data, regardless of where or how the data
is stored. Their goal is to not only guarantee uniform access to
data for both proprietary and open-source analytical engines, but
also to achieve seamless interoperability, enabling any engine to
utilize the information processed in any format. Simultaneously,
organizations prioritize key aspects such as security, performance,
management, and governance, all of which are significantly sim-
plified by maintaining a single copy of data. Notable examples of
Permission to make digital or hard copies of all or part of this work for personal or
classroom use is granted without fee provided that copies are not made or distributed
for profit or commercial advantage and that copies bear this notice and the full citation
on the first page. Copyrights for components of this work owned by others than ACM
must be honored. Abstracting with credit is permitted. To copy otherwise, or republish,
to post on servers or to redistribute to lists, requires prior specific permission and/or a
fee. Request permissions from permissions@acm.org.
Conference’17, July 2017, Washington, DC, USA
© 2024 Association for Computing Machinery.
ACM ISBN 978-x-xxxx-xxxx-x/YY/MM...$15.00
https://doi.org/10.1145/nnnnnnn.nnnnnnn
platforms facilitating this integration include Google BigLake [11],
Microsoft Fabric [12], and Databricks [9].
At the core of this strategy lies a unified data lake, which is
the central data repository in these platforms. The data lake is
designed to handle large volumes and diverse types of enterprise
data, providing a scalable and secure environment. It allows data to
be ingested from various sources, including cloud, on-premises, and
edge-computing platforms. Additionally, it facilitates analytical and
decision-making processes by ensuring data is easily accessible in
formats usable by a wide range of applications like data engineering,
data science, real-time analytics, and business intelligence.
Conventional text formats like CSV and JSON, though widely
used for data storage, prove inadequate when dealing with the
vast scale of big data, rendering them suboptimal for data lakes.
As a response to the escalating volumes of data, file formats such
as Apache Avro [4], Apache Parquet [7], and Apache ORC [5]
have emerged. These formats have gained prominence due to their
optimizations for data storage and retrieval, especially in scenarios
characterized as read-heavy. It is worth noting that these formats
are designed to be immutable. However, modern analytics scenarios
do not just demand static analysis of large data sets; they also
require frequent, incremental updates to structured data in small
batches—a demand these formats are not suited to meet.
In this context, Log-Structured Tables (LSTs) have emerged as
compelling proposals to address the aforementioned challenges.
LSTs are table storage formats that combine the advantages of
optimized file formats with a design suited for frequent table up-
dates (§2). They have evolved into an industry standard; notable
implementations that have gained widespread adoption include
Delta Lake [2], Apache Iceberg [3], and Apache Hudi [1]. Each LST
adopts a distinct approach to storing and managing metadata, in-
cluding versioning, schema, and partitioning. This diversity arises
from the fact that each LST is developed by open-source commu-
nities with different goals, use cases, and requirements, leading to
unique features and capabilities.
To achieve interoperability and unified experiences across en-
gines, organizations must decide between standardizing on a sin-
gle LST for their entire data lake [8, 10, 18] or opting for engines
that connect to many LSTs [15]. However, both strategies involve
a trade-off; the performance varies significantly across different
workload types, and tends to fluctuate over time with changes in
the characteristics of the workloads, LSTs, infrastructure, and the
engines [19, 20]. This suggests that relying exclusively on a single
LST or engine may not be fruitful always. The problem of data estate
fragmentation is only partially addressed without solutions that
provide interoperability in both engine and format. Consequently,
users often resort to data duplication, posing a challenge to the
overarching goal of achieving unification and interoperability. This
duplication not only raises costs significantly but can also decrease
arXiv:2401.09621v1  [cs.DB]  17 Jan 2024

---

the value of the data, e.g., the timeliness of insights and actions
based on the ingested data.
To leverage the advantages offered by different LSTs while ad-
hering to the data lake vision, LST translation has emerged as an
effective approach. The translation involves generating metadata
for one LST from that of another, while reusing the data files. This
means that the data, written in a format, is simultaneously avail-
able in other formats. Given that the table metadata is considerably
smaller in size and the translation does not involve larger data
files, this process is both low-overhead and swift. LST translation
preserves the ‘single source of truth’ concept while simultaneously
enhancing format interoperability.
In this direction, we introduce XTable [14] (§3), a tool designed
to realize seamless interoperability in data lakes. XTable is an open-
sourced tool providing omni-directional and incremental translation
between LSTs, operates with low overheads and high performance,
and is designed for extensibility and usability. In this demonstra-
tion, we employ XTable to target diverse application scenarios
and user requirements, showcasing its versatility and capabilities.
The participants will (1) use notebooks to explore the structure of
data and metadata layout of various table formats, examining their
differences and similarities, (2) engage with unified analytical plat-
forms to delve into query planning using table format features, and
(3) have the opportunity to interact with XTable and experience
its practical applications firsthand through exercises inspired by
real-world scenarios.
2
LST Overview
A Log-Structured Table (LST or simply a table) is a specification
designed for storing versioned tabular data using optimized file
formats such as Parquet and ORC. The specifications guarantee data
integrity and consistency through adherence to ACID transactions.
An LST is primarily composed of data files and metadata files.
The data files store the table’s records and are typically organized
according to the table’s partitioning scheme. Once written, data
files are immutable, i.e., any change to the LST data results in
the creation of new data files. On the other hand, the metadata
files contain details about the table, including its schema, partition
scheme, location of data files, file-level statistics, and configuration.
LSTs use the metadata files for version control, where each commit
operation is reflected through a subset of metadata files that capture
the table’s state. The metadata files associated with a new commit
contain references to both newly added and existing data files, while
ensuring that no existing files are deleted. This ensures completion
of concurrent read operations successfully. The metadata update
process is designed to be atomic. This design also supports features
like schema evolution and time travel (querying historical data). The
separation of data and metadata facilitates efficient management of
big datasets, as task planning deals with smaller and fewer metadata
files, and is independent of the numerous larger data files.
Listing 1 and Figure 1 serves as an example to demonstrate work-
ing of a LST named sales using Apache Iceberg. On Line 1, the table
is created with two columns: s_id and s_type. As it is partitioned,
Iceberg will arrange table’s data files in folders according to val-
ues of s_type. At this stage, initial metadata files are generated,
capturing the table’s schema, partition details, and no data files.
1
CREATE TABLE sales (s_id int , s_type string) USING
ICEBERG PARTITIONED BY (s_type);
2
INSERT INTO sales VALUES (1, 'a'), (2, 'b'), (3, 'b');
3
DELETE FROM sales WHERE s_id = 3;
Listing 1: Example code for LST operations
Figure 1: Simplified layout of metadata files and referenced
data files for example in Listing 1
On Line 2, three rows are added to sales. Iceberg processes this by
creating one or more data files. Following this, metadata files are
created, which only reference the newly added data files. Line 3
removes one record. Iceberg generates new data files from existing
files (assuming copy-on-write mode), omitting the deleted records.
Subsequently, new metadata files reflecting the post-deletion table
state are created. This latest metadata files do not refer to any data
files that contained the now-deleted records. Together, the three
sets of metadata files represent the table’s history.
Interestingly, Delta Lake, Iceberg, and Hudi are designed to be
compatible with standard file formats, and their data file layout
typically aligns with the previously described layout. The primary
distinction lies in their metadata layers, where the differences are
minor. The metadata across these three formats fulfills similar func-
tions and contains similar types of information.
Despite having similar metadata information, real-world per-
formance of LSTs can vary dramatically [19, 20]. The metadata
layout is just one of many factors that contribute to performance
variations. Other responsible factors include the characteristics of
the workload, the specific algorithms implemented within the LST,
and the protocols governing engine interactions which affect con-
currency and isolation. Furthermore, configuration parameters play
a significant role, influencing broader aspects such as the data file
sizes. Consequently, to maximize the performance by fully utilizing
the potential of LSTs, users might find it necessary to use different
engines for different tasks, with each engine supporting multiple
formats. This approach then allows them to select the best fit based
on their workload and environment.
A hurdle in attaining such interoperability lies in the continuous
evolution of the formats and the processing engines. This neces-
sitates a continual update of the connectors, which is difficult to
maintain. This leads to varying levels of support in these integra-
tions, such as the lack of uniform optimization support, resulting
in situations where optimizations effective for one format might
not be applicable to another [16].
2

---

3
XTable Overview
One of the most efficient strategies for enabling interoperability
is to make the data available in the preferred format, rather than
maintaining and extending all engines. XTable is an innovative
omni-directional, incremental, extensible, and low-overhead transla-
tor providing seamless interop between LSTs. It facilitates scenar-
ios where data, created in a source LST, becomes accessible across
all supported target LSTs without data duplication. Significantly,
XTable is not a new LST itself and does not interact with engines
directly. It operates asynchronously, ensuring that existing appli-
cations optimized for specific LST can seamlessly work with both
original and translated data, eliminating the need for maintaining
multiple connectors. The core underlying principle of XTable is
the realization that the differences in the metadata layers of the
currently popular LSTs are relatively minor.
Omni-directional. XTable has the ability to translate metadata
in any direction. It means that it doesn’t matter what the source or
target LST is; XTable can handle the translation both ways. With
its unique omni-directional conversion capability, infrastructure
teams are relieved from the burden of deploying and maintaining
separate translators and connectors for each table format.
Low-overhead. LST translation is primarily focused on the meta-
data, which is a significantly lighter task compared to processing
large data files. In most cases, the actual data files do not need to be
read for the translation to occur. Furthermore, since the differences
in the metadata between various LSTs are minor, the translation
process does not demand extensive computational resources.
Incremental. Incremental translation enhances XTable’s efficiency.
XTable can detect which source LST commits have not yet been
translated to the target LST and focuses solely on converting those.
This approach significantly reduces the time and required compu-
tational resources. This allows for frequent invocations of XTable,
even on a commit-by-commit basis, effectively minimizing the stal-
eness of the target data.
Extensible. XTable is designed to easily adapt and expand in re-
sponse to emerging table formats [6] or new versions of existing
LSTs. This adaptability is enabled by an internal representation
that serves as a universal exchange mechanism, effectively bridging
different formats. The internal representation plays a pivotal role
in simplifying development and validation by effectively isolating
source formats from target formats. This isolation means that when
adding support for a new format or updating an existing one, devel-
opers can focus solely on how to translate to and from this internal
representation, rather than dealing with the complexities of direct
format-to-format translation. This design fosters community-led
development of XTable and quickly assimilate new formats and
updates.
Listing 2 is an example XTable configuration file. XTable re-
quires three key inputs: the source LST (Hudi in this case), a list
of target LSTs (Delta and Iceberg), and the location of the data in
the source LST. The specified location is an Azure Blob File System
(ABFS) path, which hosts the sales table in Hudi format. XTable
generates Delta-Lake and Iceberg metadata from the Hudi metadata.
The generated metadata is persisted in the base path of sales table
colocated with the data files.
1
sourceFormat: HUDI
2
targetFormats:
3
- DELTA
4
- ICEBERG
5
datasets:
6
-
7
tableBasePath: abfs :// container@ac.dfs.core.
windows.net/sales
Listing 2: Example XTable config
Figure 2: Overview of the XTable Architecture.
3.1
XTable Architecture
At a high level, as illustrated in the Figure 2, XTable’s architecture
is comprised of three key components, the source readers, the target
writers, and the central core logic.
Source Readers. These are LST specific modules responsible for
reading metadata from the source tables. They operate using a
pluggable file system, allowing them to connect to different data
lake implementations. The source readers extract information like
schema, transactions, and partitions, and translate it into XTable’s
unified internal representation.
Target Writers. These mirror the source readers. Their role is to
take the internal representation of the metadata and accurately map
it to the target format’s metadata structure. This includes recreating
schema, transaction logs, and partition details in the new format.
Core Logic. This is the central processing unit of XTable. It or-
chestrates the entire translation process, including initializing of
all components, managing sources and targets, and handling tasks
like caching for efficiency, state management for recovery and in-
cremental processing, and telemetry for monitoring.
4
Related Work
Delta’s UniForm [17] and Iceberg’s Migrate Table [13] are related
technologies that, while addressing interoperability challenges, of-
fer translation in only one direction compared to XTable. UniForm
specifically focuses on efficient, incremental translation from Delta
metadata to Iceberg. It incurs minimal impact on Delta write per-
formance, as the transaction is performed after the Delta commit.
Similarly, the Migrate action creates a new Iceberg table based on a
specific point-in-time snapshot of a source table. However, this pro-
cess also removes the source table from the catalog, eliminating the
option to using the original format. While the two processes share
3

---

core principles with XTable, further validating the approach’s ef-
fectiveness, their capabilities are more focused. This makes it a
useful yet narrower solution in the context of LST translation.
5
Demonstration Overview
The demonstration, grounded in realistic use cases, is designed to
help the attendees understand how XTable’s omni-directional LST
translation capabilities enhance interoperability and efficiency in
data lakes. To this end, we deploy XTable as a background process
which is triggered asynchronously either periodically or on demand
following one or more commit operations by analytical engines
such as Apache Spark, Trino, and Apache Flink. The engines and
XTable do not interact, eliminating need for code changes or special
engine configurations.
Utilities Package. XTable demonstration comprises of two main
packages. The first is a set of utilities designed to visualize and
examine artifacts generated by XTable, LSTs, and query engines.
The utilities include python notebooks (1) to visualize file layout
and the structure of key metadata files of the LSTs to highlight
the working of the formats and compare them with each other, (2)
examine execution plans of queries submitted by attendees, and (3)
visualize the timeline view of XTable events and the work done.
Attendees will interact with these python notebooks throughout
the exercise scenarios discussed below.
Applications Package. The second package consists of practical
exercises, enabling attendees to engage directly with real-world
applications of XTable and experience its impact firsthand. These
exercises have been designed using publicly available datasets and
a mix of open-sourced and proprietary analytical engines. Our
demonstration assigns attendees different roles, such as a data
engineer, performance engineer, and a data scientist, enabling them
to unlock engine and format interoperability on a single copy of
data using XTable.
Scenario 1: Multi-Format Data Import/Export in Managed
Environments. The prevailing approach for analytics and AI in
managed environments is to stick to a single LST. Yet, in practice,
when collaborating with external partners who use different for-
mats, numerous organizations depend on various data sources and
often distribute their data in multiple formats. In this scenario, an
e-commerce company uses a managed data lake for its varied data
storage and analysis needs. In the role of a data engineer, the at-
tendee will complete data integration exercises by specifying the
locations of datasets and using XTable to import multi-format data
from partners and export their data in the format required by their
partners. This capability practically unlocks their data and elimi-
nates the need to employ ad-hoc processes to managing multiple
data copies in different formats.
Scenario 2: Unlocking Analytics Across Table Formats. In a
global financial firm, different teams use different analytics engines
and LSTs for their operations. Team A processes transactional data
using Apache Iceberg, while Team B prefers Apache Hudi for their
market analysis. Typically, sharing insights across these teams re-
quires extensive data conversion and coordination. With XTable,
both teams can access and analyze most up-to-date version of each
Figure 3: Scenario 2: Team-A uses Iceberg exclusively, and
Team B uses Hudi. XTable enables access to Stocks and
Crypto tables in both formats for seamless interop.
other’s data seamlessly without the need for time-consuming coor-
dination efforts. As a data scientist of Team A, the attendee will use
their preferred stack, Spark and Iceberg, to analyze Team B’s Hudi-
formatted Stock table’s data directly for completing a forecasting
exercise, as shown in Figure 3.
Scenario 3: Optimizing Performance with Engine Flexibility.
In this scenario, a healthcare organization collects vast amounts of
sensor data in streaming fashion in Hudi-based tables. For certain
complex queries, they find their analytical engine, Trino, is opti-
mized for using column statistics in Iceberg, offering faster query
execution and efficient data processing. Using XTable, the attendee,
acting as a performance engineer, will convert their Hudi-based
datasets to Iceberg, utilize Trino for certain complex queries. This
flexibility allows them to choose the best engine for the task at
hand without duplicating data or compromising on data integrity.
The attendee will leverage the query plan visualization tool from
the utilities package for this exercise.
References
[1] 2017. Apache Hudi. https://hudi.apache.org/. Accessed: 2023-02-23.
[2] 2019. Delta Lake. https://delta.io/. Accessed: 2023-02-23.
[3] 2021. Apache Iceberg. https://iceberg.apache.org/. Accessed: 2023-02-23.
[4] 2023. Apache Avro. https://avro.apache.org/. Accessed: 2023-02-23.
[5] 2023. Apache ORC. https://orc.apache.org/. Accessed: 2023-02-23.
[6] 2023. Apache Paimon. https://paimon.apache.org. Accessed: 2023-11-29.
[7] 2023. Apache Parquet. https://parquet.apache.org/. Accessed: 2023-02-23.
[8] 2023. Apple-Iceberg. https://trino.io/blog/2022/11/28/trino-summit-2022-apple-
recap.html. Accessed: 2023-11-29.
[9] 2023. Databricks. https://www.databricks.com/. Accessed: 2023-11-26.
[10] 2023.
Fabric Interoperability.
https://learn.microsoft.com/en-us/fabric/get-
started/delta-lake-interoperability. Accessed: 2023-11-29.
[11] 2023. Google BigLake. https://cloud.google.com/biglake. Accessed: 2023-11-26.
[12] 2023. Microsoft Fabric. https://learn.microsoft.com/en-us/fabric/.
[13] 2023. Migrate Action. https://iceberg.apache.org/docs/1.3.0/table-migration/.
Accessed: 2023-12-07.
[14] 2023. OneTable. https://onetable.dev. Accessed: 2023-11-29.
[15] 2023. Starburst. https://docs.starburst.io/latest/object-storage.html. Accessed:
2023-11-29.
[16] 2023. Trino Hudi Connector Issue. https://github.com/trinodb/trino/pull/17899.
Accessed: 2023-12-07.
[17] 2023. Universal Format (UniForm). https://learn.microsoft.com/en-us/azure/
databricks/delta/uniform. Accessed: 2023-06-23.
[18] 2023. Walmart-Hudi. https://medium.com/walmartglobaltech/lakehouse-at-
fortune-1-scale-480bcb10391b/. Accessed: 2023-12-08.
[19] Jesús Camacho-Rodríguez, Ashvin Agrawal, Anja Gruenheid, Ashit Gosalia,
Cristian Petculescu, Josep Aguilar-Saborit, Avrilia Floratou, Carlo Curino, and
Raghu Ramakrishnan. 2023. LST-Bench: Benchmarking Log-Structured Tables in
the Cloud. arXiv:2305.01120 [cs.DB]
[20] Paras Jain, Peter Kraft, Conor Power, Tathagata Das, Ion Stoica1, and Matei
Zaharia. 2023. Analyzing and Comparing Lakehouse Storage Systems. CIDR
(2023).
4

---

