# TiLT: A Time-Centric Approach for Stream Query Optimization and Parallelization

> 来源: https://arxiv.org/pdf/2301.12030

TiLT: A Time-Centric Approach for
Stream Query Optimization and Parallelization
Anand Jayarajan
anandj@cs.toronto.edu
University of Toronto, Vector Institute
Canada
Wei Zhao∗
xiaoteemo.zhao@mail.utoronto.ca
University of Toronto
Canada
Yudi Sun∗
yudi@cs.toronto.edu
University of Toronto
Canada
Gennady Pekhimenko
pekhimenko@cs.toronto.edu
University of Toronto, Vector Institute
Canada
ABSTRACT
Stream processing engines (SPEs) are widely used for large scale
streaming analytics over unbounded time-ordered data streams.
Modern day streaming analytics applications exhibit diverse com-
pute characteristics and demand strict latency and throughput re-
quirements. Over the years, there has been significant attention
in building hardware-efficient stream processing engines (SPEs)
that support several query optimization, parallelization, and exe-
cution strategies to meet the performance requirements of large
scale streaming analytics applications. However, in this work, we
observe that these strategies often fail to generalize well on many
real-world streaming analytics applications due to several inherent
design limitations of current SPEs. We further argue that these
limitations stem from the shortcomings of the fundamental design
choices and the query representation model followed in modern
SPEs. To address these challenges, we first propose TiLT, a novel
intermediate representation (IR) that offers a highly expressive tem-
poral query language amenable to effective query optimization and
parallelization strategies. We subsequently build a compiler back-
end for TiLT that applies such optimizations on streaming queries
and generates hardware-efficient code to achieve high performance
on multi-core stream query executions. We demonstrate that TiLT
achieves up to 326× (20.49× on average) higher throughput com-
pared to state-of-the-art SPEs (e.g., Trill) across eight real-world
streaming analytics applications. TiLT source code is available at
https://github.com/ampersand-projects/tilt.git.
CCS CONCEPTS
• Information systems →Data streaming; Query languages
for non-relational engines; Stream management; • Computing
methodologies →Parallel programming languages; • Soft-
ware and its engineering →Parallel programming languages;
Domain specific languages.
∗Authors have contributed equally to this research.
Permission to make digital or hard copies of part or all of this work for personal or
classroom use is granted without fee provided that copies are not made or distributed
for profit or commercial advantage and that copies bear this notice and the full citation
on the first page. Copyrights for third-party components of this work must be honored.
For all other uses, contact the owner/author(s).
ASPLOS ’23, March 25–29, 2023, Vancouver, BC, Canada
© 2023 Copyright held by the owner/author(s).
ACM ISBN 978-1-4503-9916-6/23/03.
https://doi.org/10.1145/3575693.3575704
KEYWORDS
stream data analytics, temporal query processing, intermediate
representation, compiler
ACM Reference Format:
Anand Jayarajan, Wei Zhao, Yudi Sun, and Gennady Pekhimenko. 2023.
TiLT: A Time-Centric Approach for Stream Query Optimization and Par-
allelization. In Proceedings of the 28th ACM International Conference on
Architectural Support for Programming Languages and Operating Systems,
Volume 2 (ASPLOS ’23), March 25–29, 2023, Vancouver, BC, Canada. ACM,
New York, NY, USA, 16 pages. https://doi.org/10.1145/3575693.3575704
1
INTRODUCTION
Stream processing applications are widely used in the industry to
perform both real-time and offline analysis on unbounded, time-
ordered, and high-frequency event streams. For example, social
media companies (e.g., Twitter, Meta) use click stream analytics
for serving advertisements [26, 49], banking institutions analyze
purchasing trends for identifying fraudulent transactions [58], and
investment companies conduct high-frequency trading based on
real-time stock prices [1]. In recent years, stream processing is
finding even wider application in non-traditional areas like agricul-
ture [51], climate science [5], energy/manufacturing industry [42],
and healthcare [19]. These applications involve computation that
require fine-grained control over the time-dimension of data streams,
such as computing a moving average over time or finding the tempo-
ral correlation between events across streams. Moreover, streaming
computations are often long-running and process data in a continu-
ous manner with strict latency and throughput requirements [45].
Stream processing engines (SPEs) are special systems designed
to meet the ever-increasing performance demands of streaming
analytics applications. Modern SPEs [4, 6, 8, 11, 14, 19, 24, 25, 47, 59]
provide familiar SQL-like temporal query language interface for
writing complex streaming analytics applications. Many popular
SPEs [4, 6, 8, 52, 59] are designed as scale-out systems which meet
the performance requirements of streaming applications by scaling
the query execution over large cluster of machines. Despite being
a widely adopted design, scale-out SPEs showcase significantly low
hardware-utilization and therefore are highly resource intensive [32,
60]. This spawned several scale-up SPEs [11, 14, 19, 33, 34, 47] with
hardware-conscious designs to better utilize modern multi-core
machines. Table 1 shows the performance comparison between
state-of-the-art scale-out and scale-up SPEs on the popular Yahoo
arXiv:2301.12030v1  [cs.DB]  27 Jan 2023

---

ASPLOS ’23, March 25–29, 2023, Vancouver, BC, Canada
Anand Jayarajan, Wei Zhao, Yudi Sun, and Gennady Pekhimenko
Table 1: Throughput (million events/sec) of Yahoo streaming
benchmark [31] on a 32-core machine
Scale-out[8, 59]
Scale-up [11, 14, 34, 47]
Spark
Flink
Trill
StreamBox
Grizzly
LightSaber
0.14
0.59
34.07
167.19
118.74
296.40
streaming benchmark [31]. As shown, scale-up SPEs are able to
achieve 100 −1000× higher throughput under the same hardware
budget [60], which makes them a more cost-effective alternative to
scale-out SPEs for large scale stream processing [30].
Scale-up SPEs face three key challenges to achieve high single-
machine performance for streaming queries. First, improving hard-
ware utilization of streaming queries requires supporting effective
optimization strategies for improving cache utilization of query ex-
ecution and pruning redundant computation. Second, unlike batch
processing applications, streaming queries do not inherently expose
data parallelism due to their continuous query execution model.
Therefore, SPEs need to support sophisticated parallelization strate-
gies to fully utilize all the processing cores in a multi-core machine.
Finally, since stream queries are long-running workloads, they re-
quire a low-overhead runtime to meet their latency requirements.
Despite having significant research attention, current scale-up SPE
designs fail to address all three challenges at the same time on many
real-world streaming applications due to the following reasons.
Current scale-up SPEs [11, 33, 34, 61] follow the traditional data
flow representation of streaming applications where the queries are
defined as a directed acyclic graph (DAG) of temporal operations
and the query execution is performed by interpreting the data flow
graph. Even though this design is conceptually simple and easy to
extend, this query execution model is shown to introduce significant
interpretation overhead at runtime [37, 60]. Moreover, the query
optimizations in the interpreted SPEs are mostly heuristics-based
graph-level transformations such as reordering the operations in the
DAG [6]. Applying such optimizations requires the streaming query
to precisely match with certain pre-defined rules and, therefore,
typically has narrow applicability on many streaming applications.
Finally, many of these systems only extract limited parallelization
opportunities available through partitioned data streams.
To address the inefficiencies of interpretation-based SPEs, re-
cent works have proposed compiler-based solutions [14, 24, 47, 48].
These approaches offer low-overhead runtime for query execu-
tion by automatically generating hardware-efficient code from the
high-level query description. State-of-the-art compiler-based SPEs
also support low-level query optimizations like operator fusion to
maximize data locality by passing data between operators through
registers or cache memory, and can automatically parallelize the
query execution even on non-partitioned data streams. However,
the optimization, parallelization, and code generation strategies
proposed in current compiler-based SPEs primarily target appli-
cations performing only a limited set of operations (e.g., stream
aggregations) and these strategies do not generalize well on queries
with more complex operations (e.g., stream-to-stream join). This
significantly limits the ability of current compiler-based SPEs to
support many real-world streaming analytics applications.
In this work, to support the growing adoption of stream process-
ing in a wide range of application domains, we set a goal to provide
an infrastructure for effective and generalizable optimization and
parallelization strategies for streaming queries. We make a key
observation that the limited optimization and parallelization capa-
bilities of SPEs are due to the fundamental limitations of the query
representation model used by modern SPEs. Under the current
so-called event-centric model, streaming queries are constructed
using primitive temporal operations, each defining a transforma-
tion over a sequence of discrete time-ordered events. Even though
this is a natural representation model for streaming queries as the
data streams are inherently an unbounded time-ordered sequence
of events, we argue that this event-centric definition of temporal
operations does not expose the important time semantical informa-
tion of the streaming queries that are required for effective query
optimization and parallelization. Since streaming queries are tem-
poral in nature, we believe that the temporal operations should also
follow a representation model that is fundamentally based on time.
Based on this observation, we propose a novel intermediate rep-
resentation (IR) called TiLT that follows a time-centric model for
defining streaming queries. Unlike the traditional event-centric
model, TiLT IR defines temporal operations as functional transfor-
mations over well-defined time-domains using new constructs like
temporal object, reduction function, and temporal expression. With
these simple constructs, TiLT offers a highly expressive program-
ming paradigm to represent a diverse set of streaming applications.
At the same time, the time-centric definition of streaming queries
enables optimization opportunities that are otherwise difficult to
perform using the traditional query representation models. More-
over, the side-effect-free functional definition of TiLT queries ex-
poses inherent data parallelism that can be leveraged to parallelize
arbitrary streaming queries. Finally, we build a compiler-backend
for TiLT that automatically translates the logical stream query defi-
nitions into hardware-efficient executable code and achieves high
multi-core performance on a wide range of streaming applications.
To evaluate TiLT’s ability to provide high performance on a
diverse range of applications, we prepare a benchmark suite with
eight stream processing applications representative of real-world
streaming analytics use-cases in fields including stock trading,
signal processing, industrial manufacturing, banking institutions,
and healthcare. On these applications, TiLT achieves 6 −322×
(20.49× on average) higher throughput against the state-of-the-
art interpretation-based SPE Trill [11]. This speedup comes from
two major fronts: (i) effective query optimization and paralleliza-
tion enabled by the time-centric query representation model in
TiLT, and (ii) a compiler-based SPE design that eliminates common
inefficiencies like query interpretation and managed language over-
head common in interpreted SPEs. We also show that TiLT can
achieve competitive performance against compiler-based SPEs that
are specially designed for efficient stream aggregation. For example,
on Yahoo streaming benchmark [12], TiLT is able to achieve 1.5×
and 3.8× higher throughput compared to state-of-the-art compiler-
based SPEs LightSaber [47] and Grizzly [14], respectively.
In summary, we make the following contributions:
• We highlight the limitations of the query representation mod-
els used in current SPEs in supporting effective optimization
and parallelization strategies. To address these limitations,
we propose a novel intermediate representation called TiLT.

---

TiLT: A Time-Centric Approach for Stream Query Optimization and Parallelization
ASPLOS ’23, March 25–29, 2023, Vancouver, BC, Canada
We show that TiLT enables generalizable optimization and
parallelization strategies that are otherwise difficult to sup-
port in the traditional query representation models.
• We build a compiler for TiLT that can optimize and paral-
lelize arbitrary streaming queries and generate hardware-
efficient code to achieve high multi-core performance.
• We prepare a new representative benchmark suite with
eight real-world streaming analytics applications used in
signal processing, stock trading, industrial manufacturing,
banking service, and healthcare. Across these applications,
we demonstrate that TiLT can achieve 6 −326× (20.49×
on average) higher throughput compared to state-of-the-
art SPEs. TiLT is currently open-sourced and available at
https://github.com/ampersand-projects/tilt.git
2
BACKGROUND
Streaming analytics applications typically process unbounded se-
quence of time-ordered events in a continuous manner. Table 2
shows eight representative real-world streaming analytics appli-
cations used in areas including stock market trading, signal pro-
cessing, healthcare, manufacturing, and banking services. These
applications process data at a high rate and demand strict latency
and throughput requirements. For example, high-frequency trading
applications demand sub-second level latency [15, 28, 44]. Moreover,
the computations performed by these applications often require
fine-grained control over the time-dimension of the data streams such
as using different windowing strategies to analyze changing trends
in the data streams [18, 41, 46].
Many modern SPEs [8, 11, 14, 19, 47, 59] provide SQL-like query
languages with temporal extensions for writing such complex
streaming applications. These languages offer a vocabulary of sim-
ple yet highly expressive primitive temporal operations with each
defining a transformation over one or more data streams. Figure 1
illustrates four primitive temporal operations commonly used in
streaming queries and their corresponding transformations on
event streams. Without loss of generality, each event in the data
stream is represented using a payload value and a validity inter-
val. The Select and Where operations shown in the Figure 1a and
1b follow the relational SQL semantics of projection and selec-
tion operations, respectively. Both operations perform per-event
transformations where the former modifies the payload field of
each event and the latter conditionally filters out events based on
a user-defined predicate on the payload. The temporal Join oper-
ation shown in Figure 1c joins two streams into a single output
stream. The output stream of the Join operation contains events
corresponding to the strictly overlapping regions of events in the
input streams. Finally, the aggregation operations on data streams
are generally performed over a time-bounded window defined by
its window size and stride length. For example, a Sum aggrega-
tion operation defined over a Window(size, stride) computes the
sum of every 𝑠𝑖𝑧𝑒-seconds1 windows that are stride-seconds apart.
Figure 1d shows a sliding-window aggregation with window size
10 and stride length 5. Since all these operations are defined as
1For the purpose of the discussion, we use seconds as the unit of time. However, any
other units of time are also applicable to the definitions used in this paper.
transformations over events, we call them to follow an event-centric
model of temporal operator definition.
These simple primitive operations can be combined together
to construct more complex streaming queries. Figure 2a shows
an example streaming query written using the primitive temporal
operations shown in Figure 1. This query is a simplified version of
the stock market trend analysis application [18] described in Table 2.
This query analyzes the trends in the price of a particular stock
by computing two moving average of the stock prices over 10 and
20 seconds intervals on every second by first using two Window-
Sum operations and then dividing the sum by their corresponding
window sizes using the Select operation. Afterwards, the difference
between the concurrent pairs of 10-second and 20-second averages
is computed using the temporal Join operation. The final Where
operation filters only the events with a positive difference in the
average. The validity intervals of the events in the final output
stream corresponds to the period of time for which the stock price
is observing an upward trend.
Once the temporal queries are defined, SPEs can internally han-
dle the execution of the queries. Many popular SPEs [3, 4, 6, 8, 52, 59]
are primarily designed to meet the performance requirements of the
query by distributing the execution over large cluster of machines.
Despite being a widely popular approach, prior works [11, 19, 40, 60]
have shown that such scale-out SPEs are highly resource-intensive
and often perform 2 −3 orders of magnitude slower than their cor-
responding hand-tuned implementations, thus causing significant
waste of compute and energy resources. This observation led to the
development of several scale-up SPEs [11, 14, 19, 24, 33, 34, 47, 61]
that follow hardware-conscious designs to maximize the single-
machine performance of streaming query execution. State-of-the-
art scale-up SPEs have shown that modern day multi-core machines
with hundreds of processing cores and gigabytes of memory band-
width are capable of meeting the performance demands of large
scale streaming workloads and can be a cost-effective alternative
to more expensive large multi-machine clusters [30].
3
MODERN SPE DESIGNS AND LIMITATIONS
Scale-up SPEs attempt to achieve high single-machine performance
primarily by three means. First, the user-defined query is subjected
to several optimization passes to prune redundant computations
and increase data locality in order to improve the hardware utiliza-
tion during query execution. Second, SPEs utilize different paral-
lelization strategies to take advantage of parallel processing cores
available in multi-core machines. Finally, SPEs try to provide a
low-overhead runtime in order to meet the latency and through-
put requirements of long running streaming applications. Despite
the wide attention, we observe that the query optimization, paral-
lelization, and execution strategies proposed in prior SPEs fail to
generalize well on real-world streaming analytics applications due
to several fundamental design limitations that we highlight below.
Limited query optimization opportunities. The optimization
strategies adopted in current SPEs have limited applicability and of-
ten fail to cover a wide variety of real-world streaming applications.
For instance, the majority of SPEs [6, 11, 34] adopt heuristics-based
query optimization strategies, which are limited to basic graph

---

ASPLOS ’23, March 25–29, 2023, Vancouver, BC, Canada
Anand Jayarajan, Wei Zhao, Yudi Sun, and Gennady Pekhimenko
Table 2: Real-world streaming analytics applications
Analytics application
Description
Operators in the query
Data set
Trend-based trading [18]
Moving average trend in stock price
Avg (2), Join, Where
New York Stock Exchange [38]
Relative strength index [46]
Stock price momentum indicator
Shift, Join, Avg (2)
Normalization [57]
Normalize event values using Z-score
Avg, StdDev, Join
Synthetic Data (Random
floating point values generated
at 1000Hz frequency)
Signal imputation [54]
Replacing missing signal values
Avg, Shift, Join
Resampling [55]
Changing signal frequency
Select, Join, Shift, Chop
Pan-Tomkins algorithm [39]
Detect QRS complexes in ECG
Custom-Agg(3), Select, Avg
MIMIC-III waveform data [21]
Vibration analysis [41]
Monitor machine vibrations using kurtosis,
root mean square, and crest factor metrics
Max, Avg(2), Join (2),
Custom-Agg
Bearing vibration data [17]
Fraud detection [58]
Credit card fraud detection
Avg, StdDev, Shift, Join
Kaggle credit card data [22]
a
Select(e ⇒ e+1)
Input
stream
Output
stream
10
11
12
b
Where(e ⇒ e%2==0)
10
11
12
11
12
13
10
12
c
Join((l,r) ⇒ l+r)
10
11
12
d
Window(10, 5).Sum()
10
11
12
30
31
10
Time
20
21
11
12
Figure 1: Common temporal operations: (a) Select, (b) Where, (c) Temporal Join, and (d) Window-Sum
stock
Window(10,1)
.Sum()
Window(20,1)
.Sum()
Select(e ⇒ e/10)
Select(e ⇒ e/20)
Join((l, r) ⇒ l - r)
Where(e ⇒ e > 0)
(a) Un-optimized version
stock
Window(10,1)
.Sum()
Window(20,1)
.Sum()
Join((l, r) ⇒ l/10 - r/20)
Where(e ⇒ e > 0)
(b) Fused version
Figure 2: Stock price trend analysis query
transformations such as substituting or reordering individual oper-
ations in the query [6, 11]. For instance, predicate pushdown [6]
is a common optimization where filtering operations (Where) are
moved closer to the data source in order to reduce the number
of events the remaining operations in the query need to process.
However, this optimization is only applicable if the predicate of the
filtering operation is defined over the events in the input stream.
For example, predicate pushdown cannot be applied to the example
query in Figure 2a as the Where operation depends on the result
generated by the parent Join operation.
Certain advanced SPEs [14, 47] support more sophisticated low-
level optimizations such as operator fusion for improving regis-
ter/cache utilization by combining multiple operators into a single
operator. For example, the Select operators in the stock analysis
query can be trivially fused with the Join operator as shown in
Figure 2b. This avoids unnecessary data movement between opera-
tors and allows intermediate results to remain in registers or cache
memory for as long as possible. Unfortunately, the fusion rules im-
plemented in current SPEs can only fuse operators until a so-called
soft pipeline-breaker [37, 60] is reached. Soft pipeline-breakers are
operators that require partial materialization of the output events
before the next operator in the query pipeline can start processing.
For instance, in Figure 2b, both Window-Sum and Join operators
are soft pipeline-breakers. Fusing these operators together is non-
trivial and optimizers in current SPEs fail in such scenarios. This
significantly limits the applicability of fusion optimization on many
real-world streaming applications as they often contain multiple
pipeline-breakers in the query. For example, Table 2 shows the
temporal operations used in the queries of each application and
each query contains between 2 −6 pipeline-breakers.
Limited query parallelization capability. Unlike batch process-
ing applications, streaming queries do not inherently expose data
parallelism as many temporal operations exhibit sequential data
dependencies (e.g., sliding-window aggregation). Therefore, extract-
ing data parallelism from streaming queries is often challenging
and many SPEs rely on users to provide partitioned data streams in
order to parallelize the query execution. For example, the trend anal-
ysis query (Figure 2a) can be trivially parallelized by executing on
data streams corresponding to different stocks. However, the degree
of parallelism available from this approach is limited by the number
of unique partitions available in the data stream [47]. Moreover,
in certain streaming analytics applications used in healthcare [19]
and manufacturing industry [23], even a single partition of the data
stream can contain events generated at rates as high as 1 −40 KHz.
In such cases, parallelizing the stream query execution requires
more sophisticated strategies.

---

TiLT: A Time-Centric Approach for Stream Query Optimization and Parallelization
ASPLOS ’23, March 25–29, 2023, Vancouver, BC, Canada
Prior works [9, 24, 47, 50] have proposed solutions to automati-
cally extract data parallelism in streaming queries without needing
a partitioned data stream. However, these works have been solely fo-
cusing on window-based aggregation operations. For example, the
sliding-window sum in Figure 1c can be parallelized by first comput-
ing partial sums on 5-second tumbling-windows2 and then adding
up two consecutive partial sums. Since the tumbling-windows do
not overlap, the data streams can be partitioned on the 5-second
window boundaries and each window can be processed in parallel.
The partial sum additions can also be parallelized through parallel
reduction [47]. However, extending these strategies to parallelize
arbitrary streaming queries is often non-trivial. For instance, de-
termining the partition boundaries on stock price stream in the
example query is unclear as the query contains multiple sliding-
windows and a temporal join operation. We observe that the query
parallelization methods in current scale-up SPEs [14, 47] are inca-
pable of handling such scenarios.
High runtime overhead during query execution. The query
execution model adopted in current SPEs fail to provide low over-
head runtime for a wide range of real-world applications. The major-
ity of the SPEs [8, 11, 33, 34, 59, 61] follow an interpretation-based
query execution model also called an iterator model [13, 29]. In
this model, the logical query description is translated to a data
flow graph by mapping each temporal operator in the query to a
concrete implementation. Each physical operator is designed to
process events one-by-one or in micro-batches and passes the gen-
erated output events to the next operator in the graph through
message queues. Despite being a widely adopted design, prior
works [14, 19, 37, 40, 47, 60] have shown that interpreted SPEs
often perform 1 −2 orders of magnitude slower compared to cor-
responding hand-tuned implementations. This inefficiency can be
mainly attributed to the cost of data transfer between operators in
the data flow graph [37, 60], poor support for effective optimiza-
tion strategies such as operator fusion [60], and failure to maintain
end-to-end data locality because of fixed size micro-batching [19].
To address the inefficiencies of interpreted SPEs, recent works
have proposed compiler-based solutions [14, 24, 47], which can
generate compact and efficient machine code from the high-level
query description using customized code-generation techniques.
Even though, compiler-based SPEs are shown to achieve state-of-
the-art single-machine performance, we observe that these SPEs
follow highly restrictive query languages with limited expressive
power. To the best of our knowledge, prior compiler-based SPEs
are designed only for queries performing window-based aggrega-
tion. Since it is common to use more complex and diverse set of
temporal operations in streaming queries, the ability of current
compiler-based SPEs to support real-world streaming analytics ap-
plications is significantly limited. Additionally, the code generation
techniques used in these SPEs are primarily designed as source-
to-source translator and heavily rely on template expanders. Such
compiler designs are known to be highly inflexible and extremely
hard to maintain [10, 43].
Based on these observations, we conclude that the current SPEs
only exploit the optimization and parallelization opportunities on
2Tumbling-window is a special case of sliding-windows when the stride length is same
as the window size.
stream queries in limited capacity due to several inherent design lim-
itations. This prevents such SPEs from providing high-performance
stream processing for many real-world streaming analytics appli-
cations. In this work, we set the goal to provide hardware-efficient
stream processing without sacrificing programmability and gener-
ality to support the diverse computational requirements of modern
day streaming analytics workloads.
4
TILT: A TIME-CENTRIC APPROACH
Addressing the aforementioned design limitations and providing (i)
effective query optimization, (ii) parallelization, and (iii) execution
strategies on a diverse set of streaming analytics applications re-
quires us to fundamentally rethink how SPEs should be designed.
In this work, we argue that the limited query optimization capa-
bilities and lack of automatic parallelization support stem from
the event-centric temporal query representation model adopted
in SPEs. Since the data streams are represented as a sequence of
events, it is natural to define temporal operators as transformations
over events. However, we observe that this event-centric definition
of temporal operations do not fully express the time semantics of
temporal queries necessary for effective query optimization and
parallelization (see Section 5 for more details). Based on this obser-
vation, we make a fundamental shift from this established design
principle and propose a new compiler-based SPE design that follows
a time-centric model for streaming queries.
As opposed to the traditional event-centric model, the time-
centric model adopts a more fine-grained representation of tem-
poral operations by defining them as functional transformations
over well-defined time domains using a novel intermediate repre-
sentation (IR) called TiLT. TiLT IR is a highly expressive functional
language with extensions to support temporal operations and offers
several advantages over traditional query representation models.
First, the functional definition of TiLT IR exposes inherent data
parallelism which enables TiLT to parallelize arbitrary streaming
queries. Second, we demonstrate that the fine-grained time-centric
definition of temporal operations allows TiLT to support effective
query optimization strategies through simple IR transformations. Fi-
nally, we build a compiler-backend for TiLT that can automatically
translate the time-centric IR query definitions to hardware-efficient
executable code.
Figure 3 shows the lifecycle of a streaming application in TiLT.
In the first stage, TiLT converts the streaming query written by the
user into the TiLT IR form (Section 4.1). After that, the compiler
infers the boundary conditions necessary for parallelizing the query
execution through a step called boundary resolution (Section 5.1).
Afterwards, TiLT queries are subjected to an optimization phase
(Section 5.2). Finally, in the code generation step, the optimized
query is lowered to LLVM IR and subsequently to executable code
for parallel query execution (Section 6).
4.1
TiLT IR
Similar to regular functional languages, TiLT supports data types
such as integers, floating points, arrays, structures, dictionaries,
and expressions such as arithmetic/logical operations, conditional
operations, variables, and external function/library calls. On top of
this, we introduce three new constructs, namely temporal objects,

---

ASPLOS ’23, March 25–29, 2023, Vancouver, BC, Canada
Anand Jayarajan, Wei Zhao, Yudi Sun, and Gennady Pekhimenko
(a) Translation to TiLT IR form (Sec. 4.1)
 t = TDom(-∞, ∞, 1)
 ∼sum10[t] = ⊕(+, ∼stock[t-10 : t])
 ∼sum20[t] = ⊕(+, ∼stock[t-20 : t])
 ∼avg10[t] = ∼sum10[t] / 10
 ∼avg20[t] = ∼sum20[t] / 20
 ∼join[t] = (∼avg10[t] != ϕ && ∼avg20[t] != ϕ) ?
	
(∼avg10[t] - ∼avg20[t]) : ϕ
 ∼filter[t] = (∼join[t] > 0) ? ∼join[t] : ϕ
(c) Optimized TiLT IR query (Sec. 5.2)
 t = TDom(Ts, Te, 1)
 ∼filter[t] = { a10 = ⊕(+, ∼stock[t-10 : t]) / 10
	
a20 = ⊕(+, ∼stock[t-20 : t]) / 20
        j = (a10 != ϕ && a20 != ϕ) ? (a10 - a20) : ϕ
	
return ( j > 0 ) ? j : ϕ
 }
(b) Inferring boundary conditions (Sec. 5.1)
 ∼filter[Ts : Te] ⇐ ∼stock[Ts-20 : Te]
(d) Code generation (Sec. 6.1)
 loop_filter(Ts, Te, ~filter, ~stock) {
    ts = Ts;
    initialize reduction states;
    while(ts < Te) {       
        ts = next ts when ~stock[ts-20 : ts]
  	
  	
or ~stock[ts-10 : ts] change value;
        val = compute snapshot value;
        add (ts, val) to ~filter;
    }
 }
stock
Window
.Sum
Window
.Sum
Select
Select
Join
Where
Figure 3: TiLT compilation pipeline
reduction functions, and temporal expressions, which enables TiLT
to define a diverse set of temporal operations. First, the temporal
object is similar to a regular scalar object, except that it takes on
a time-evolving value that spans over an infinitely long timeline.
As opposed to the traditional way of representing streams as a
sequence of discrete events with the time interval and payload
fields, TiLT models the data stream using a single temporal object
that assumes different values at different points in time based on the
events active at that time. Second, TiLT uses the reduction functions
to reduce the mutating values of a temporal object to a single
scalar value. Reduction functions are introduced in TiLT to perform
aggregate operations on data streams. Finally, temporal expressions
are functional transformations on one or more temporal objects
defined over a well-defined time domain. Temporal expressions are
the basic building blocks of a streaming application in TiLT.
Temporal object: We use the ∼notation to distinguish temporal
objects from scalar objects. For example, let ∼𝑠𝑡𝑜𝑐𝑘be a temporal
object corresponding to a data stream of stock price events 𝑒𝑖with
price value 𝜌𝑖and validity interval (𝑡𝑠
𝑖,𝑡𝑒
𝑖]. The value of ∼𝑠𝑡𝑜𝑐𝑘at
any point in time 𝑇can be retrieved using an indexing operator
([]), and is defined as follows.
∼𝑠𝑡𝑜𝑐𝑘[𝑇] =
(
𝜌𝑖
if
∃𝑒𝑖| 𝑇∈(𝑡𝑠
𝑖,𝑡𝑒
𝑖]
𝜙
otherwise
(1)
The value of the temporal object ∼𝑠𝑡𝑜𝑐𝑘at time 𝑇is the value of
the payload of the stock price event active at 𝑇.3 When there are
no events active at time𝑇, the temporal object assumes a null value
called 𝜙. The value 𝜙has the special property that performing any
arithmetic operations on it would always result in 𝜙. Additionally,
TiLT allows defining derived temporal objects from existing ones
by passing a time interval to the index. For example, the stock price
values between time points 𝑡𝑠and 𝑡𝑒can be written as a derived
temporal object ∼𝑤𝑖𝑛= ∼𝑠𝑡𝑜𝑐𝑘[𝑡𝑠: 𝑡𝑒]. Then, the value of ∼𝑤𝑖𝑛at
any point in time 𝑇is defined as follows.
∼𝑤𝑖𝑛[𝑇] =
(
∼𝑠𝑡𝑜𝑐𝑘[𝑇]
if
𝑇∈(𝑡𝑠,𝑡𝑒]
𝜙
otherwise
(2)
Reduction function: The reduce function, denoted as ⊕(𝑓, ∼𝐼), is
a special expression used to reduce a temporal object ∼𝐼into a scalar
value based on a reduction operation 𝑓. TiLT, by default, supports
several basic aggregation operations such as Sum (+), Product (∗),
Max (>), and Min (<). For example, reducing the temporal object
3For simplicity, in this section, we assume that there are no events with overlapping
intervals in the stream and therefore, there is only at most one event active at any
given time. Handling data streams with overlapping events is discussed in Section 6.
∼𝑤𝑖𝑛using summation (+) can be written as ⊕(+, ∼𝑤𝑖𝑛) and is
defined as follows:
⊕(+, ∼𝑤𝑖𝑛) =
∑︁
{∼𝑤𝑖𝑛[𝑡]
∀𝑡| ∼𝑤𝑖𝑛[𝑡] ≠𝜙}
(3)
Other aggregation operations such as average can be expressed
by combining the built-in reduction functions. On top of that, TiLT
also allows users to define custom reduction operations (see Sec-
tion 6 for more details).
Temporal expression: TiLT expresses streaming queries as a se-
quence of temporal expressions each defining an output temporal
object as a functional transformation over one or more input tem-
poral objects on a time domain. A time domain TDom(start, end,
precision) has a start and end time indicating the interval between
which the temporal expression is defined and a time precision de-
noting how frequently the value of the resulting temporal object
can change in the time domain.
t = TDom( Ts, Te, p)
? O[ t ] = Fn( ~I 1, . . . , ~I n, C1, . . . , Cm)
The general syntax of a temporal expression is shown above.
The above expression defines the output temporal object ∼𝑂as a
functional transformation (𝐹𝑛) over 𝑛input temporal objects ∼𝐼1,
..., ∼𝐼𝑛and 𝑚constants 𝐶1, ..., 𝐶𝑚over a time domain 𝑡. Here, 𝑡is
defined within the time interval (𝑇𝑠,𝑇𝑒] and has a time precision
of 𝑝. Therefore, at any point in time 𝑇∈(𝑇𝑠,𝑇𝑒] and is a multiple
of 𝑝, ∼𝑂[𝑇] assumes a value returned by the expression 𝐹𝑛(∼𝐼1, ∼
𝐼2, ..., ∼𝐼𝑛) at time 𝑇.
4.2
TiLT Queries
Figure 4 shows the temporal expressions corresponding to the
operations described in Figure 1. In the example above, the time
domain 𝑡is defined between −∞and +∞and has a precision of
1 second. That means the temporal expressions using 𝑡define a
value of the output temporal object at every second over an infinite
time domain. The first temporal expression is equivalent to the
Select operation in Figure 1a. This expression defines a functional
transformation from the temporal object ∼𝑚to ∼𝑠𝑒𝑙𝑒𝑐𝑡over the
time domain𝑡and the value of ∼𝑠𝑒𝑙𝑒𝑐𝑡at any point in time is defined
to be 1 more than the value of ∼𝑚at the same time. Similarly, the
second expression is equivalent to the Where operation and it filters
only even values from ∼𝑚. In this example, the value of ∼𝑤ℎ𝑒𝑟𝑒
at any point in time is conditionally selected to be 𝜙if ∼𝑚has an
odd value at that time. The third expression corresponds to the
temporal join operation and follows a very similar structure to the

---

TiLT: A Time-Centric Approach for Stream Query Optimization and Parallelization
ASPLOS ’23, March 25–29, 2023, Vancouver, BC, Canada
Where operation, except that it is a binary expression derived from
two input temporal objects ∼𝑚and ∼𝑛. This expression identifies
the strictly overlapping intervals between the events in ∼𝑚and
∼𝑛by checking if the both ∼𝑚and ∼𝑛have a non-null value at
a given time. If yes, the expression returns the sum of the values,
otherwise 𝜙. Finally, the 10-second sliding-window Window-Sum
operation with 5-second stride is defined by applying the Sum
reduction function on every 10-second window derived from ∼𝑚
over a time domain 𝑡′ with a precision of 5.
t = TDom( - ?, ?, 1)
? sel ect [ t ] = ? m[ t ] + 1
? wher e[ t ] = ( ? m[ t ] %2 == 0) ? ? m[ t ] : ?
? j oi n[ t ] = ( ? m[ t ] ! = ? && ? n[ t ] ! = ?) ? 
( ? m[ t ] + ? n[ t ] ) : ?
t ' = TDom( - ?, ?, 5)
? wsum[ t ' ] = ? ( +, ? m[ t ' - 10 : t ' ] )
Figure 4: Temporal expression for Select, Where, Join, and
Window-Sum operations
It should be noted that, even though the traditional definitions of
these temporal operations have seemingly different semantics, TiLT
definitions of the same operations are very similar in structure. This
shows that TiLT is able to find a minimal set of abstractions neces-
sary to represent a wide range of temporal operations. We believe
that the integration of constructs such as temporal objects, reduc-
tion function, and temporal expressions into a powerful functional
programming paradigm has made TiLT a highly expressive query
representation model suitable for modern streaming applications.
5
TILT: OPTIMIZATION AND
PARALLELIZATION
The compilation pipeline in TiLT starts by converting the streaming
query into TiLT IR form as shown in Figure 3a. Here, the exam-
ple query is lowered to TiLT IR by defining the input data stream
as a temporal object (∼𝑠𝑡𝑜𝑐𝑘) and mapping each operation to the
corresponding temporal expression defined over an infinite time
domain. After the translation, TiLT first extracts data parallelism
from the query by resolving the boundary conditions of the TiLT
expressions through a step called boundary resolution (Section 5.1).
Then, TiLT performs several optimization passes over the query
through simple IR transformations. A full exploration of the op-
timization opportunities on TiLT IR is beyond the scope of this
work. Instead, we focus on an optimization that provides the most
bang-for-the-buck: operator fusion. Streaming queries generally
exhibit high data locality and therefore can significantly benefit
from operator fusion optimization that exploits this property to
improve register/cache utilization [19, 60]. In the Section 5.2, we
show how TiLT can overcome the limitations of current SPEs in
performing operator fusion across pipeline-breakers.
5.1
Boundary Resolution
The time-centric definition of the temporal queries in TiLT precisely
captures the data dependency between temporal objects over the
entire time domain. For example, the value of ∼𝑗𝑜𝑖𝑛at time 𝑇in
Figure 4 is only depended on the values of ∼𝑚and ∼𝑛at the same
time. That means, the value of ∼𝑗𝑜𝑖𝑛at two different time points𝑇1
and 𝑇2 are independent and can be evaluated in parallel. This data
dependency information can be extended for the entire TiLT IR
query. For example, the data dependency of ∼𝑓𝑖𝑙𝑡𝑒𝑟[𝑇] in Figure 3a
can be determined by following the lineage all the way to the input
temporal object ∼𝑠𝑡𝑜𝑐𝑘. In this example, computing the value of
∼𝑓𝑖𝑙𝑡𝑒𝑟at 𝑇is solely dependent on the values of ∼𝑠𝑡𝑜𝑐𝑘between
time intervals (𝑇−10,𝑇] and (𝑇−20,𝑇]. We call this the temporal
lineage of the temporal objects. TiLT uses this temporal lineage
information to extract data parallelism from arbitrary temporal
queries through a step called boundary resolution.
During the boundary resolution step, TiLT converts the initial
query defined over the infinite time domain to a bounded domain
by inferring the boundary conditions over the time domain. For
example, based on the temporal lineage of the query in Figure 3a,
the values of ∼𝑓𝑖𝑙𝑡𝑒𝑟between an arbitrary interval (𝑇𝑠,𝑇𝑒] is only
dependent on the values between the interval (𝑇𝑠−20,𝑇𝑒] in ∼𝑠𝑡𝑜𝑐𝑘.
After the temporal boundary conditions have been inferred, TiLT
redefines the time domain of the temporal query to the symbolic
interval (𝑇𝑠,𝑇𝑒] by setting 𝑡to 𝑇𝐷𝑜𝑚(𝑇𝑠,𝑇𝑒, 1) (Figure 3b). TiLT
uses this boundary condition to partition the data streams in order
to parallelize the query execution (see Section 6.2 for more details).
5.2
Operator Fusion
Once the query is defined in the TiLT IR expression form, per-
forming fusion optimization is straightforward through simple
IR transformations. Applying operator fusion in TiLT queries en-
tails simply merging two successive temporal expressions that are
defined over the same time domain into a single expression. For
example, following is the resulting expression after applying fusion
rule on the temporal expressions ∼𝑎𝑣𝑔10, ∼𝑎𝑣𝑔20, and ∼𝑗𝑜𝑖𝑛.
? j oi n[ t ] = { a10 = ? sum10[ t ] / 10
a20 = ? sum20[ t ] / 20
 
r et ur n ( a10 ! = ? && a20 ! = ?) ?
 ( a10 - a20) : ? }
Fusing expressions defined by ∼𝑎𝑣𝑔10, ∼𝑎𝑣𝑔20, and ∼𝑗𝑜𝑖𝑛simply
requires replacing every occurrence of ∼𝑎𝑣𝑔10[𝑡] and ∼𝑎𝑣𝑔20[𝑡] in
the ∼𝑗𝑜𝑖𝑛with ∼𝑠𝑢𝑚10[𝑡]/10 and ∼𝑠𝑢𝑚20[𝑡]/20 as shown above.
This transformation is equivalent to the fusion optimization pass
supported in current SPEs (shown in Figure 2b). However, unlike
traditional SPEs, the same IR transformation can be applied to all the
expressions in the query including the pipeline-breakers (e.g., ∼𝑗𝑜𝑖𝑛,
∼𝑠𝑢𝑚10, ∼𝑠𝑢𝑚20). TiLT repeatedly applies this transformation to
fuse all temporal expressions in the trend-analysis query into a
single expression as shown below.
t = TDom( Ts, Te, 1)
? f i l t er [ t ] = { 
s10 = ? ( +, ? st ock[ t - 10: t ] )
s20 = ? ( +, ? st ock[ t - 20: t ] )
a10 = s10/ 10
a20 = s20/ 20
j = ( a10 ! = ? && a20 ! = ?) ? ( a10- a20) : ?
 
r et ur n ( j > 0) ? j : ? }
In comparison to current SPEs, TiLT supports more holistic and
generalizable query optimization strategies because of the following

---

ASPLOS ’23, March 25–29, 2023, Vancouver, BC, Canada
Anand Jayarajan, Wei Zhao, Yudi Sun, and Gennady Pekhimenko
two key reasons. First, the graph-level representation of stream-
ing queries are typically too coarse-grained. Therefore, the fused
version of the primitive operations is often not expressible at this
level. TiLT, on the other hand, provides a more flexible query repre-
sentation that allows fine-grained transformations as shown above.
Second, the event-centric model often do not expose how the in-
tervals of the events are manipulated after each temporal operator
to the optimizer. For example, the intervals of the output events
of Join is only determined at runtime. In contrast, the time-centric
definitions in TiLT IR expressions explicitly encode the transfor-
mations over time domains which allows TiLT to perform more
sophisticated optimizations. We believe that TiLT IR opens up sev-
eral more optimization opportunities on temporal queries that are
otherwise hard to implement on traditional query representation
models and we plan to explore them in the future work.
6
TILT: COMPILATION AND EXECUTION
Even though the fine-grained compute definitions in TiLT IR is
better suited for effective stream query optimizations, it also comes
with significant amount of redundancy. For example, the temporal
expression corresponding to the Select operation shown in Fig-
ure 4 defines the value for the temporal object ∼𝑠𝑒𝑙𝑒𝑐𝑡at every
second in the time domain. Although this fine-grained definition
provides great flexibility for IR manipulation, it also introduces
redundant computation since the value of the input temporal object
∼𝑚may not necessarily change every second. Therefore, naïvely
translating TiLT queries into executable code can potentially be
highly inefficient. Below, we describe how TiLT compiler removes
this redundancy and generates hardware-efficient executable code
corresponding to TiLT IR queries.
6.1
Code Generation
TiLT compiler is written using C++ and LLVM JIT compiler in-
frastructure [27]. During the code generation phase, the compiler
lowers the TiLT IR representation to LLVM IR. Since TiLT IR is
fundamentally a functional language, it lends itself to standard
code generation practices followed in compilers [2, 35]. Below, we
explain the code generation strategy used for the three newly in-
troduced constructs in TiLT.
6.1.1
Temporal Objects. According to the formal definition in equa-
tion 1, temporal objects define a value at every point in time. How-
ever, following the same definition for the physical implementation
is impractical. Instead TiLT stores only changes in the value of
the temporal object using a data structure called snapshot buffer
(SSBuf). A snapshot buffer is an ordered sequence of snapshots
stored in an array where each snapshot stores the timestamp (𝑡𝑠)
and value (𝑣𝑎𝑙) at the point when a change occurred.
Figure 5 shows an example event stream stored as a snapshot
buffer. The first snapshot in this buffer takes a value of null (𝜙) at
timestamp 5 as there are no events active in the stream before that
point. The second snapshot is added when first event ends (at 10)
and takes the value (𝑎) of the payload of that event. Similarly, a new
snapshot is added to the buffer at the start and end of every sub-
sequent events in the data stream. When the data stream contains
events with overlapping validity intervals, a single snapshot can
Time
0
5
10
15
20
25
30
35
40
Event
stream
a
b
c
SSBuf
(5,ϕ) (10,a) (16,ϕ) (23,b) (30,ϕ) (35,c)
Figure 5: Event stream as snapshot buffer
assume multiple values. In such cases, TiLT uses a list/map to store
the values of a snapshot.
6.1.2
Reduction Functions. We provide native support for several
common reduction functions like Sum, Product, Min, and Max.
Additionally, TiLT also supports user-defined reduction functions.
Both built-in and user-defined functions are implemented using a
general template similar to the ones followed in other SPEs [11, 47].
This template contains four lambda functions that is designed to
incrementally update a state on every snapshot in the temporal
object. (i) Init function returns the initial state of the reduction
operation (e.g., 0 for Sum). (ii) Acc function accumulates a single
snapshot to the state (e.g., addition for Sum). (iii) Result function re-
turns the reduction result from the incremental state (e.g., the state
for Sum). (iv) For invertible reduction functions, an optional Deacc
function can be provided that applies the inverse of the aggregate
function on the state (e.g., subtraction for Sum). This simple tem-
plate allows TiLT to support efficient aggregation implementations
like Subtract-on-Evict [16].
6.1.3
Temporal Expressions. Finally, the temporal expressions are
synthesized into loops that iterate over input snapshot buffers and
update the output snapshot buffer. Figure 3d shows the synthesized
loop for the example query. The loop boundaries (𝑇𝑠, 𝑇𝑒) and the
loop counter (𝑡𝑠) increment is determined from the time domain
boundaries and precision. The loop body performs the computa-
tion defined by the temporal expression. One iteration of the loop
computes the snapshot value (𝑣𝑎𝑙) of the output buffer ∼𝑓𝑖𝑙𝑡𝑒𝑟at
the timestamp 𝑡𝑠.
However, as described above, naïvely setting the loop counter
increment based on time domain precision (𝑡𝑠= 𝑡𝑠+ 1) might be
highly inefficient as it introduces redundant iterations. Instead,
TiLT takes advantage of an invariant of the functional definition
of the temporal expressions to avoid redundant iterations, i.e., the
output value of a temporal expression would only change when
the inputs are changed. Based on this invariant, TiLT compiler gen-
erates an expression to increment the loop counter that computes
the next value of 𝑡𝑠at which at least one of ∼𝑠𝑡𝑜𝑐𝑘[𝑡𝑠−10 : 𝑡𝑠] and
∼𝑠𝑡𝑜𝑐𝑘[𝑡𝑠−20 : 𝑡𝑠] have changed the enclosing snapshots. After
loop synthesis, the generated loop is wrapped in a callable function
with the symbolic loop boundaries parametrized as arguments (Fig-
ure 3d). This allows TiLT to execute the query over any arbitrary
time intervals on the output snapshot buffer.

---

TiLT: A Time-Centric Approach for Stream Query Optimization and Parallelization
ASPLOS ’23, March 25–29, 2023, Vancouver, BC, Canada
Time
0
1000
2000
Partitioned
~stock SSBufs
~filter SSBufs
Figure 6: Parallel query execution
6.2
Query Execution
TiLT executes the generated code by partitioning the input data
stream into snapshot buffers and processing them in parallel us-
ing independent worker threads. The data streams are partitioned
based on the resolved boundary conditions (Figure 3b) and a user-
defined interval size. For example, Figure 6 shows the partitioned
snapshot buffers for the example query in Figure 3c with an interval
size of 1000 seconds. In this example, computing the output snap-
shots in ∼𝑓𝑖𝑙𝑡𝑒𝑟between the interval of (0, 1000] requires reading
snapshots from the input stream between the interval (−20, 1000].
Similarly, output snapshots between (1000, 2000] require process-
ing input snapshots between (980, 2000] and so on. Even though,
partitioning snapshot buffers as above adds some redundancy with
duplicated snapshots (shaded area in Figure 6), extracting data par-
allelism like this allows executing continuous streaming queries
using synchronization-free parallel worker threads.
7
EVALUATION
Benchmarks: For TiLT evaluation, we prepare two sets of bench-
marks and a representative group of real-world streaming applica-
tions. (i) Temporal operations: this benchmark includes four com-
monly used primitive temporal operations shown in the Figure 1.
(ii) Yahoo streaming benchmark (YSB) [12]: a popular streaming
benchmark comprising a Select, Where, and a tumbling-window
count operations. (iii) Real-world applications: this includes eight
real-world streaming analytics applications shown in the Table 2.4
Table 2 also describes the public datasets used in the evaluation. We
provide more details on the benchmark queries in the Appendix A.
Metrics: Inline with prior works [11, 34, 47, 59], we use data
processing throughput, i.e., the number of events processed per
second, as the primary comparison metric for the performance eval-
uation. Additionally, we also report latency-bounded throughput
to evaluate the performance of different SPEs across a wide latency
spectrum. Unless otherwise specified, the performance numbers are
measured using a dataset with 160 million events. All the numbers
reported are the average measurements from 5 runs of each experi-
ment. The standard deviation of all the measurements is observed
to be below 2%.
Baselines: On the temporal operations benchmarks, we com-
pare the throughput of TiLT against four state-of-the-art scale-up
stream query processing engines (SPEs): StreamBox [34], Microsoft
4We prepare these applications based on the realization that common benchmarks
like YSB used for evaluating SPEs only represent a narrow set of real-world streaming
analytics use-cases.
Trill [11], LightSaber [47], and Grizzly [14]. StreamBox and Mi-
crosoft Trill are both interpretation-based SPEs. StreamBox is writ-
ten in C++ and uses pipeline parallelism to parallelize streaming
queries. Trill is an SPE written in C# designed to support diverse
streaming analytics applications. Both LightSaber and Grizzly are
compiler-based SPEs optimized for aggregation operations.
Experimental setup: All the experiments are conducted on AWS
EC2 m5.8xlarge with 32 cores (with hyper-threading), 2.5 GHz, and
128 GB DRAM. We also use AWS EC2 m5zn.3xlarge with 12 cores,
4.5 GHz, and 48 GB DRAM for the scalability experiment. For a fair
performance comparison, we exclude the time taken for disk and
network accesses and only measure the compute performance of
the query execution after loading the entire input dataset into the
memory.
7.1
Temporal Operations Throughput
We measure the performance of TiLT on the temporal operations
Select, Where, Window-Sum, and Join on a synthetic dataset contain-
ing 160 million events using 16 worker threads. Figure 7a shows
the processing throughput comparison against StreamBox, Trill,
Grizzly and LightSaber. For simple per-event operations like Select
and Where, TiLT achieves similar performance to other SPEs (be-
tween 0.69−1.44×). On more complex operations like Window-Sum,
TILT outperforms the Trill and StreamBox by 6.64× and 18.30×,
respectively. This shows that TiLT generated code can significantly
outperform hand-written operations in interpretation-based SPEs.
Moreover, TiLT outperforms the two compiler-based SPEs Grizzly
and LightSaber, which are optimized for window-based aggrega-
tion, by 7.44× and 1.87×, respectively. We observe that the high
overhead of Grizzly is caused by expensive atomic state updates
used by the SPEs to perform parallel aggregation. LightSaber, on
the other hand, uses complex data structures such as parallel ag-
gregation tree which we observe to be inefficient for fine-grained
window-aggregations that are common in modern streaming ana-
lytics applications.
Finally, we evaluate the performance of temporal Join. Neither
Grizzly nor LightSaber supports Join operation, therefore we only
compare the performance of TiLT against StreamBox and Trill.
We observe that TiLT achieves 321.94× higher performance over
StreamBox and 13.87× higher over Trill. The Join operation in
StreamBox is highly inefficient as it uses 𝑂(𝑛2) algorithm to find
overlapping events. Both Trill and TiLT follow in-order processing
of the events and therefore only need 𝑂(𝑛) comparisons to perform
the join. However, the Trill implementation uses expensive concur-
rent hashmaps to maintain operator states, whereas the time-centric
model allows TiLT to generate more efficient state-free code for Join.
These results show that TiLT is able to generate highly efficient
code for commonly used temporal operations that can significantly
outperform both interpretation-based and compiler-based SPEs.
7.2
Scalability
We evaluate how well TiLT can scale streaming queries over multi-
cores using Yahoo Streaming Benchmark [12]. We execute the query
on a 12-core and a 32-core machine by increasing the number of
worker threads and compare the throughput against Trill, Stream-
Box, Grizzly, and LightSaber. Figure 8a and Figure 8b show the

---

ASPLOS ’23, March 25–29, 2023, Vancouver, BC, Canada
Anand Jayarajan, Wei Zhao, Yudi Sun, and Gennady Pekhimenko
 0
 100
 200
 300
 400
 500
 600
 700
 800
 900
Select
Where
WSum
Join
million events/sec
LightSaber
Grizzly
StreamBox
2.08
Trill
TiLT
(a) Throughput on primitive temporal operations
 0
 50
 100
 150
 200
 250
 300
 350
 400
Trading
RSI
Normalize
Impute
Resample
PanTom
Vibration
FraudDet
million events/sec
Trill
18.0
11.7
40.0
30.0
0.9
9.8
5.6
15.7
TiLT
227.9
207.9
251.5
289.6
295.4
115.3
207.5
254.0
(b) Throughput on real-world streaming applications
Figure 7: Performance comparison of TiLT on temporal operations and real-world streaming application benchmarks
 0
 100
 200
 300
 400
 500
 0
 2
 4
 6
 8
 10
 12
million events/sec
Number of threads
LightSaber
Grizzly
StreamBox
Trill
TiLT
(a) Throughput on 12-core machine
 0
 100
 200
 300
 400
 500
 0
 5
 10
 15
 20
 25
 30
million events/sec
Number of threads
LightSaber
Grizzly
StreamBox
Trill
TiLT
(b) Throughput on 32-core machine
Figure 8: Multi-core scalability on Yahoo Streaming Benchmark (YSB)
 0.1
 1
 10
 100
 0.001
 0.01
 0.1
 1
 10
 100
million events/sec
Batch size (10K events) 
Trading
 0.1
 1
 10
 100
 0.001
 0.01
 0.1
 1
 10
 100
RSI
 0.1
 1
 10
 100
 0.001
 0.01
 0.1
 1
 10
 100
Normalize
 0.1
 1
 10
 100
 0.001
 0.01
 0.1
 1
 10
 100
Impute
 0.1
 1
 10
 100
 0.001
 0.01
 0.1
 1
 10
 100
Resample
 0.1
 1
 10
 100
 0.001
 0.01
 0.1
 1
 10
 100
PanTom
 0.1
 1
 10
 100
 0.001
 0.01
 0.1
 1
 10
 100
Vibration
 0.1
 1
 10
 100
 0.001
 0.01
 0.1
 1
 10
 100
Trill
TiLT
FraudDet
Figure 9: Latency-bounded throughput of Trill and TiLT
throughput measured on the 12-core and 32-core machines, re-
spectively. Trill only supports parallel execution over partitioned
streams and exhibits the worst scalability. We also observe limited
scalability in Grizzly. We believe this is due to concurrent data struc-
tures and atomic states used to synchronize between worker threads.
Both StreamBox and LightSaber scale up to 8 parallel threads on

---

TiLT: A Time-Centric Approach for Stream Query Optimization and Parallelization
ASPLOS ’23, March 25–29, 2023, Vancouver, BC, Canada
the 32-core machine. LightSaber achieves a peak multi-core perfor-
mance of 291𝑀events/sec and 296𝑀events/sec on the 12-core and
32-core machine, respectively. TiLT consistently outperforms all
the SPEs and achieves a peak performance of 406 million events/sec
on 12-core machine and 450 million events/sec on 32-core machine.
The superior performance of TiLT comes from the synchronization-
free data parallel query execution strategy described in Section 6.2.
TiLT achieves close to linear scaling till 4-threads in the 12-core
machine and 8-threads in the 32-core machine. The scalability ben-
efits start to diminish afterwards because the query execution is
shifting from being compute-bound to being memory-bound. This
shows that TiLT can effectively parallelize the query execution
while achieving 1.52 −13.20× higher peak performance over the
state-of-the-art SPEs.
7.3
Real-World Applications Performance
We evaluate how well TiLT can support the performance require-
ments of real streaming workloads in comparison to state-of-the-art
SPEs. To this end, we evaluate the throughput of TiLT on eight
real-world streaming analytics applications listed in Table 2. These
applications perform complex temporal transformations over data
streams and therefore require a highly expressive temporal lan-
guage for writing them as streaming queries. Out of all the baselines,
we find that only Trill provides a query language that is capable
of supporting all eight applications. Therefore, we compare the
performance of TiLT on these applications against Trill.
First, we measure the throughput obtained from Trill and TiLT
on these applications with 16 worker threads. As shown in Fig-
ure 7b, TiLT is able to outperform Trill across all the applications
by 6.29 −326.30×. This shows that TiLT is able to provide superior
performance on a diverse set of streaming analytics applications.
The best speedup is obtained on the signal resampling benchmark
with 326.30× higher throughput over Trill. This query requires
a non-standard temporal operation called Chop, which we find
to have an inefficient operator implementation in Trill. Despite
this non-standard operation, TiLT is able to generate an efficient
implementation that is ultimately resulted in a significant speedup.
Additionally, we also measure the latency-bounded throughput
of TiLT against Trill on the real-world applications with the syn-
thetic dataset. Trill is optimized to provide high throughput over
a wide latency spectrum. As shown in Figure 9, we measure the
throughput by setting the batch/snapshot buffer size to contain
events between 10 and 1M. We observe that TiLT provide con-
sistently higher throughput across the entire latency spectrum,
whereas Trill exhibits 18 −227× slowdown on smaller batch sizes
due to high query execution overhead. This demonstrates that TiLT
provides a runtime environment that adds minimal overhead and
is able to provide high-performance over a wide latency spectrum.
7.4
Effectiveness of Query Optimization
We analyze the effectiveness of the fusion optimization in TiLT by
measuring the single-thread execution time of the example query
(Figure 3) before and after applying the IR transformations described
in Section 5.2. We compare the result with the Trill version of the
un-optimized and optimized queries shown in Figures 2a and 2b. In
Figure 10, we report the speed up observed on each of these query
 0
 2
 4
 6
 8
 10
UnOpt
Opt
Speedup
Trill
1.00x
1.06x
UnOpt
Opt
TiLT
2.61x
8.55x
Figure 10: Performance breakdown of query optimization in
Trill and TiLT (normalized to Trill)
versions normalized to the throughput of the un-optimized Trill
query. As shown, applying operator fusion in Trill achieves only a
nominal speedup of 1.06×. This highlights the limited optimization
opportunities available in current scale-up SPEs. In TiLT, on the
other hand, even the un-optimized version of the query outper-
forms the optimized Trill query by 2.61×. The TiLT query without
applying the any optimizations (e.g., operator fusion) follows a
similar query execution model as that of an interpreted SPE. There-
fore, the speed up observed in this case can be mainly attributed
to avoiding the common overheads associated with the managed
language (C#) implementation of Trill. This shows that TiLT can
generate efficient code corresponding to individual operators that
outperforms the hand-written implementations in interpreted SPEs.
On top of this, the speedup can be further improved to 8.55× af-
ter applying the operator fusion optimization. This speedup is the
result of maximizing cache utilization by immediately reusing the
intermediate results generated during query execution. This sen-
sitivity study shows that the performance benefits of TiLT comes
from both minimizing the runtime overhead using a compiler-based
approach and by performing effective query optimizations enabled
by the time-centric query representation model.
8
RELATED WORK
Many of the stream processing engines (SPEs) commonly used in the
industry (e.g., Apache Spark [59], Flink [8], Storm [52], Beam [4])
are designed as scale-out systems based on the assumption that
single machines are incapable to handle the performance demands
of modern streaming analytics applications. However, recent works
on scale-up SPEs [11, 14, 24, 33, 34, 47, 61] have shown that a
well-designed system running on a single multi-core machine can
often satisfy the performance requirements of large scale stream
processing [30]. Unfortunately, we observe that many of the state-
of-the-art scale-up SPEs sacrifice the expressive power of the lan-
guage to achieve high single-machine performance. In this work,
we argue that to meet the demands of modern streaming analytics

---

ASPLOS ’23, March 25–29, 2023, Vancouver, BC, Canada
Anand Jayarajan, Wei Zhao, Yudi Sun, and Gennady Pekhimenko
applications, it is important to strike a good balance between pro-
grammability and performance. Below, we compare state-of-the-art
scale-up SPEs in terms of these two aspects.
Microsoft Trill [11] is optimized for diverse streaming analyt-
ics applications and provides a highly expressive temporal query
language with rich set of temporal operations and fine-grained win-
dowing support. Trill uses efficient operator implementations and
columnar data representation to maximize cache utilization and is
shown to achieve 10 −100× higher single machine performance
than scale-out SPEs [36]. However, Trill follows an interpretation-
based query execution model that suffers from significant runtime
overhead [19, 37, 60]. TiLT, on the other hand, offers a similar query
language but uses a compiler-based approach to generate hardware-
efficient code that outperforms Trill by 20× on average (Section 7.3).
Other interpretation-based SPEs such as StreamBox [7], StreamBox-
HBM [33], BriskStream [61] are designed to achieve high perfor-
mance on multi-core machines by efficiently parallelizing streaming
queries. However, these SPEs only expose low-level APIs for writing
streaming applications and offers limited temporal query language
support. Moreover, we show that the synchronization-free data
parallel query execution in TiLT achieve better scalability than
these systems (Section 7.2).
SABER [24], LightSaber [47], Scabbard [48], and Grizzly [14] are
notable examples of recent compiler-based SPEs. However, as we
explain in Section 3, these systems are only optimized to efficiently
execute the window-based aggregation and do not support impor-
tant common temporal operations like temporal join. Therefore,
these systems cannot support many real-world streaming analytics
applications such as the ones shown in Table 2. TiLT, on the other
hand, supports a wide range of streaming analytics applications
with the help of the highly expressive temporal constructs in TiLT
IR. We have also shown that TiLT is able to generate more efficient
code and achieve superior performance compared to these SPEs
(Section 7). Moreover, the code generators in these SPEs are de-
signed as template expanders which are harder to maintain and
extend [43]. In contrast, TiLT takes a more systematic approach
by proposing a well-defined IR which we believe is important to
facilitate further research in this field.
9
CONCLUSION
In this paper, we highlight the limitations of current stream pro-
cessing engines (SPEs) and their inability to meet the performance
demands of diverse set of modern day streaming analytics ap-
plications. To address these limitations, we design TiLT, a novel
temporal query representation model for streaming applications.
TiLT provides a rich programming interface to support a wide
range of streaming analytics applications while enabling efficient
query optimizations and parallelization strategies that are oth-
erwise harder to perform on traditional SPEs. We also build a
compiler-backend to generate hardware-efficient code from the
TiLT query representation. We demonstrate that TiLT can outper-
form the state-of-the-art SPEs (e.g., Trill) by up to 326× (20.49× on
average) on eight real-world streaming analytics applications with
diverse computational characteristics. TiLT source code is available
at https://github.com/ampersand-projects/tilt.git.
10
DATA-AVAILABILITY STATEMENT
The artifact of this paper is published through Zenodo [20].
ACKNOWLEDGMENTS
We first thank our shepherds and the anonymous reviewers for
their valuable feedback and comments. We also like to thank mem-
bers of the members of the EcoSystem lab, especially Kevin Song,
Jasper Zhu, Xin Li, and Christina Giannoula for providing insightful
comments and constructive feedback on the paper. This project was
supported in part by the Canada Foundation for Innovation JELF
grant, NSERC Discovery grant, AWS Machine Learning Research
Award, and Facebook Faculty Research Award.
A
REAL-WORLD STREAMING
APPLICATIONS
We prepare a benchmark suite with eight streaming analytics appli-
cations used in fields like stock trading, signal processing, industrial
manufacturing, financial institutions, and healthcare. We prepare
these applications based on the realization that commonly used
benchmarking queries to evaluate stream processing engines (SPEs)
like yahoo streaming benchmark (YSB) [12] and Nexmark [14] only
represent a narrow set of real-world streaming analytics use-cases.
Table 2 provides a brief description of the streaming applications
included in the benchmark suite and the corresponding public data
sets used for the evaluation. In the following, we provide a detailed
description of these applications. We also release the implementa-
tions of these queries in both Trill and TiLT as an artifact.
Stock trading queries: Streaming applications are widely used
by investment services for analysing the trends in stock markets
in order to make purchasing decisions. These applications continu-
ously perform statistical algorithms on high-frequency stock price
data streams. In our benchmark suite, we include two commonly
used trading algorithms (i) Trend-based, and (ii) Relative strength
index-based trading. The trend-based trading algorithm [18] com-
putes short-term and longer-term moving averages (e.g., 20 minutes
and 50 minutes) of each stock price over time and identifies an up-
ward trend when the short-term average goes above long-term and
vice versa for the downward trend. The second trading algorithm
uses relative strength index (RSI) [46] as the momentum indicator
instead of the moving averages. RSI is an indicator to chart the
current and historical strength or weakness of a stock or market
based on the closing prices during a 14-day trading period. These
two algorithms are widely used and are often combined with more
sophisticated trading algorithms.
Data cleaning/preparation: The real-time data processed by stream-
ing applications are usually misformatted, corrupt and garbled.
Therefore, data analysts often need to conduct data cleaning and
preprocessing before analysing the raw data streams. For example,
events collected from different sources often vary widely in their
scale of values. Data normalization is a commonly used approach
to bring the values of the events on different scales to a notionally
common scale. We include a standard score-based normalization
query which computes the mean (𝜇) and standard deviation (𝜎)
of the event payload values (𝑋) over every 10-second tumbling
window. The values of each event in the window is normalized by
computing (𝑋−𝜇)/𝜎.

---

TiLT: A Time-Centric Approach for Stream Query Optimization and Parallelization
ASPLOS ’23, March 25–29, 2023, Vancouver, BC, Canada
Secondly, signal processing operations are used in the healthcare
industry to clean and prepare the physiological signals like ECG and
EEG collected from the patients [19]. These signals are collected at a
fixed frequency usually ranging from 10−4 Hz to 103 Hz. We include
two commonly used signal processing operations in our benchmark
suite: (i) signal imputation, and (ii) signal resampling. Signal imputa-
tion operations are used to fill missing events in the signal streams.
The naive imputation approaches include substituting the missing
signal values with a constant (e.g., zero) or with the value of the last
active event. We include a signal imputation query that replaces the
missing signal values with the average values of the events in their
corresponding 10-second tumbling window. The signal resampling
operation is used to translate a signal stream in one frequency to
another. We use the linear-interpolation[55] algorithm to perform
the frequency conversion on the signal streams.
Finally, PanTomkins algorithm [39] is commonly used to detect
QRS complexes in ECG signals. The QRS complex represents the
ventricular depolarization and the main spike visible in an ECG
signal and is used to measure the heart rate of the patients.
Manufacturing industry: Industrial sensors used for monitor-
ing the health of large machinery in the manufacturing industry.
One such use case is monitoring the vibration signals of the ball
bearings in order to predict their failure rates. These sensors of-
ten generate data streams at a very high frequency (as much as
40 KHz frequency) [23] and the standard vibration analysis algo-
rithms require computing complex aggregate functions on such
streams. We include a vibration analysis query that computes three
window-based aggregate functions over the data stream, namely,
kurtosis [41], root mean square [56], and crest factor [53] over a
100-millisecond tumbling window.
Financial institutions: It is important for the financial and bank-
ing institutions to identify fraudulent activities by analyzing the
real-time financial transaction data of their customers. One of the
basic fraud detection strategy is a rule against abnormal transac-
tion quantities. The fraud detection query in our benchmark suite
computes a moving average (𝜇) and standard deviation (𝜎) on the
purchasing quantity on the transactions for each individual over a
10-day sliding window and calculates the threshold for large quan-
tity as 𝜇+ 3 ∗𝜎. Finally, a filtering operation is applied to select the
transactions that crosses the large quantity threshold and marks as
a potential fraudulent transaction.
B
ARTIFACT APPENDIX
B.1
Abstract
We provide the source code and scripts to reproduce the scalability
results (in Section 7.2) and the real-world applications performance
(in Section 7.3) in the main paper. This appendix contains instruc-
tions to generate plots similar to Figure 8a, Figure 8b, and Figure 7b
on synthetically generated data sets. The performance numbers
measured on synthetic data set should be a close estimate of the
same on the real data set.
We include docker containers to setup the runtime environment
for all the experiments in order to support portability. Therefore, the
artifact can be executed on any multi-core machine with docker en-
gine installed. We also use Linux gnuplot utility to generate figures
from the collected performance numbers. We recommend using
Ubuntu 20.04 operating system for running the scripts provided in
the artifact.
B.2
Artifact Checklist
• Algorithm: Not applicable.
• Program: Benchmarks described in the Table 2.
• Compilation: Provided as dockerized containers.
• Transformations: No transformation tools required.
• Binary: Source code and scripts included.
• Data set: A synthetic data set is provided along with the artifact.
• Run-time environment: Docker files provided to create runtime
environment.
• Hardware: A single multi-core CPU. Ideally, with at least 16 cores
and 128 GB memory.
• Runtime state: Not sensitive to runtime state.
• Execution: Less than an hour to evaluate all the benchmarks.
• Metrics: Number of events processed per second (Throughput).
• Output: Plots similar to Figure 8a, Figure 8b, and Figure 7b in the
main paper.
• Experiments: Bash scripts and docker files are provided to run the
benchmarks. Numerical variations in the results are negligible.
• How much disk space required (approximately)?: ∼50 GB.
• How much time is needed to prepare workflow (approximately)?:
Under 1 hour to setup the runtime environments.
• How much time is needed to complete experiments (approx-
imately)?: Under 30 minutes.
• Publicly available?: Yes
• Code licenses (if publicly available)?: LGPL-3.0
• Data licenses (if publicly available)?: Not applicable.
• Workflow framework used?: No.
• Archival link: https://doi.org/10.5281/zenodo.7493145
B.3
Description
B.3.1
How to Access. The artifact can be downloaded either from
the GitHub link https://github.com/ampersand-projects/streambench
or from the DOI link https://doi.org/10.5281/zenodo.7493145 .
B.3.2
Hardware Dependencies. TiLT does not require any special
hardware. A single general purpose multi-core CPU should be
sufficient for running the artifact. We recommend to use a machine
with at least 16-cores and 128 GB memory.
B.3.3
Software Dependencies. The experiments provided in this
artifact is prepared to run inside a docker container. We recom-
mend to use a machine with Ubuntu 20.04 with docker installed
to reproduce the results. Additionally, we use gnuplot generate
plots/figures from the performance numbers.
B.3.4
Benchmarks and Baselines. The experiments provided in this
artifact uses the Yahoo Streaming Benchmark (YSB) [12] to perform
the scalability experiments described in Section 7.2 and streaming
applications shown in Table 2 to measure real-world application
performance described in Section 7.3. We include scripts to build and
run these experiments on Trill [11], StreamBox [34], Grizzly [14],
LightSaber [47], and TiLT. We use query processing throughput as
the comparison metric for all the benchmarks, i.e., the number of
events processed per second.
B.3.5
Data Sets. For convenience, we provide a synthetically gen-
erated data set for all the experiments. The results produced on the

---

ASPLOS ’23, March 25–29, 2023, Vancouver, BC, Canada
Anand Jayarajan, Wei Zhao, Yudi Sun, and Gennady Pekhimenko
synthetic data set should be comparable to the results we report on
the real data set in the main paper.
B.4
Installation
We provide docker files to setup the runtime environment for all
the experiment.
(1) Install docker following the instructions in
https://docs.docker.com/engine/install/ubuntu/.
(2) Install gnuplot by running the following command:
sudo apt-get install -y gnuplot
(3) Clone the git repository using the following command:
git clone
https://github.com/ampersand-projects/streambench.git
--recursive
(4) Build the docker images by running the setup.sh script at
the root directory of the cloned repository.
B.5
Experiment Workflow
Execute run.sh to run all the experiments and generate the figures.
B.6
Evaluation and Expected Results
Once the script has finished execution, they would have generated
plots similar to Figure 8a and 7b. The figures can be found at the root
directory of the repository under the names ysb.pdf and e2e.pdf.
First, ysb.pdf plots the throughput comparison of TiLT against
Trill, StreamBox, Grizzly, and LightSaber on the Yahoo Streaming
Benchmark (YSB) [12] on different degree of parallelism ranging
from 1 to 16. Compared to other baselines, TiLT should consistently
achieve higher throughput and scalability. Second, e2e.pdf plots
the throughput comparison of TiLT against Trill on the real-world
streaming applications listed in Table 2 both using a fixed paral-
lelism of 8 threads. On an average, TiLT should achieve ∼10−100×
higher throughput compared to Trill.
B.7
Experiment Customization
The parallelism for the real-world applications performance eval-
uation experiment can be modified by setting the $THREADS envi-
ronmental variable to appropriate number of threads in the scripts
trill_bench/run.sh and tilt_bench/run.sh.
B.8
Methodology
Submission, reviewing and badging methodology:
• https://www.acm.org/publications/policies/artifact-review-badging
• http://cTuning.org/ae/submission-20201122.html
• http://cTuning.org/ae/reviewing-20201122.html
REFERENCES
[1] Ajay Acharya and Nandini S. Sidnal. 2016. High Frequency Trading with Complex
Event Processing. In 2016 IEEE 23rd International Conference on High Performance
Computing Workshops (HiPCW). 39–42. https://doi.org/10.1109/HiPCW.2016.014
[2] Alfred V. Aho, Monica S. Lam, Ravi Sethi, and Jeffrey D. Ullman. 2006. Compil-
ers: Principles, Techniques, and Tools (2nd Edition). Addison-Wesley Longman
Publishing Co., Inc., USA.
[3] Tyler Akidau, Alex Balikov, Kaya Bekiroglu, Slava Chernyak, Josh Haberman,
Reuven Lax, Sam McVeety, Daniel Mills, Paul Nordstrom, and Sam Whittle. 2013.
MillWheel: Fault-Tolerant Stream Processing at Internet Scale. In Very Large Data
Bases. 734–746.
[4] Tyler Akidau, Robert Bradshaw, Craig Chambers, Slava Chernyak, Rafael J.
Fernández-Moctezuma, Reuven Lax, Sam McVeety, Daniel Mills, Frances Perry,
Eric Schmidt, and Sam Whittle. 2015. The Dataflow Model: A Practical Approach
to Balancing Correctness, Latency, and Cost in Massive-Scale, Unbounded, Out-of-
Order Data Processing. Proceedings of the VLDB Endowment 8 (2015), 1792–1803.
[5] Iyad Aldasouqi and Jalal Atoum. 2011. Stream Processing Environmental Appli-
cations in Jordan Valley. International Journal of Computer Science and Security
(IJCSS) 5, 1 (2011), 1.
[6] Michael Armbrust, Tathagata Das, Joseph Torres, Burak Yavuz, Shixiong Zhu,
Reynold Xin, Ali Ghodsi, Ion Stoica, and Matei Zaharia. 2018. Structured Stream-
ing: A Declarative API for Real-Time Applications in Apache Spark. In Proceed-
ings of the 2018 International Conference on Management of Data (Houston, TX,
USA) (SIGMOD ’18). Association for Computing Machinery, New York, NY, USA,
601–613. https://doi.org/10.1145/3183713.3190664
[7] Brian Babcock, Shivnath Babu, Mayur Datar, Rajeev Motwani, and Jennifer
Widom. 2002. Models and Issues in Data Stream Systems. In Proceedings of the
Twenty-First ACM SIGMOD-SIGACT-SIGART Symposium on Principles of Database
Systems (Madison, Wisconsin) (PODS ’02). Association for Computing Machinery,
New York, NY, USA, 1–16. https://doi.org/10.1145/543613.543615
[8] Paris Carbone, Asterios Katsifodimos, Stephan Ewen, Volker Markl, Seif Haridi,
and Kostas Tzoumas. 2015. Apache Flink™: Stream and Batch Processing in a
Single Engine. IEEE Data Eng. Bull. 38, 4 (2015), 28–38. http://sites.computer.
org/debull/A15dec/p28.pdf
[9] Paris Carbone, Jonas Traub, Asterios Katsifodimos, Seif Haridi, and Volker Markl.
2016. Cutty: Aggregate Sharing for User-Defined Windows. In Proceedings of the
25th ACM International on Conference on Information and Knowledge Management
(Indianapolis, Indiana, USA) (CIKM ’16). Association for Computing Machinery,
New York, NY, USA, 1201–1210. https://doi.org/10.1145/2983323.2983807
[10] Donald D. Chamberlin, Morton M. Astrahan, Michael W. Blasgen, James N. Gray,
W. Frank King, Bruce G. Lindsay, Raymond Lorie, James W. Mehl, Thomas G.
Price, Franco Putzolu, Patricia Griffiths Selinger, Mario Schkolnick, Donald R.
Slutz, Irving L. Traiger, Bradford W. Wade, and Robert A. Yost. 1981. A History
and Evaluation of System R. Commun. ACM 24, 10 (oct 1981), 632–646. https:
//doi.org/10.1145/358769.358784
[11] Badrish Chandramouli, Jonathan Goldstein, Mike Barnett, Robert De-
Line,
Danyel
Fisher,
John
Platt,
James
Terwilliger,
John
Wernsing,
and Robert DeLIne. 2015.
Trill: A High-Performance Incremental
Query Processor for Diverse Analytics. VLDB - Very Large Data Bases.
https://www.microsoft.com/en-us/research/publication/trill-a-high-
performance-incremental-query-processor-for-diverse-analytics/
[12] Sanket Chintapalli, Derek Dagit, Bobby Evans, Reza Farivar, Thomas Graves, Mark
Holderbaugh, Zhuo Liu, Kyle Nusbaum, Kishorkumar Patil, Boyang Jerry Peng,
and Paul Poulosky. 2016. Benchmarking Streaming Computation Engines: Storm,
Flink and Spark Streaming. In 2016 IEEE International Parallel and Distributed
Processing Symposium Workshops (IPDPSW). 1789–1792. https://doi.org/10.1109/
IPDPSW.2016.138
[13] G. Graefe and W.J. McKenna. 1993. The Volcano optimizer generator: extensibility
and efficient search. In Proceedings of IEEE 9th International Conference on Data
Engineering. 209–218. https://doi.org/10.1109/ICDE.1993.344061
[14] Philipp M. Grulich, Breß Sebastian, Steffen Zeuch, Jonas Traub, Janis von Ble-
ichert, Zongxiong Chen, Tilmann Rabl, and Volker Markl. 2020. Grizzly: Efficient
Stream Processing Through Adaptive Query Compilation. In Proceedings of the
2020 ACM SIGMOD International Conference on Management of Data (Portland,
OR, USA) (SIGMOD ’20). Association for Computing Machinery, New York, NY,
USA, 2487–2503. https://doi.org/10.1145/3318464.3389739
[15] Joel Hasbrouck and Gideon Saar. 2013. Low-latency trading. Journal of Financial
Markets 16, 4 (2013), 646–679. https://doi.org/10.1016/j.finmar.2013.05.003 High-
Frequency Trading.
[16] Martin Hirzel, Scott Schneider, and Kanat Tangwongsan. 2017. Sliding-Window
Aggregation Algorithms: Tutorial. In Proceedings of the 11th ACM International
Conference on Distributed and Event-Based Systems (Barcelona, Spain) (DEBS
’17). Association for Computing Machinery, New York, NY, USA, 11–14. https:
//doi.org/10.1145/3093742.3095107
[17] Natalie Huang, Huan; Baddour. 2019. Bearing Vibration Data under Time-varying
Rotational Speed Conditions. https://doi.org/10.17632/v43hmbwxpm.2
[18] investopedia. [n. d.].
Basics of Algorithmic Trading: Concepts and Exam-
ples.
https://www.investopedia.com/articles/active-trading/101014/basics-
algorithmic-trading-concepts-and-examples.asp
[19] Anand Jayarajan, Kimberly Hau, Andrew Goodwin, and Gennady Pekhimenko.
2021. LifeStream: A High-Performance Stream Processing Engine for Periodic
Streams. In Proceedings of the 26th ACM International Conference on Architectural
Support for Programming Languages and Operating Systems (Virtual, USA) (ASP-
LOS 2021). Association for Computing Machinery, New York, NY, USA, 107–122.
https://doi.org/10.1145/3445814.3446725
[20] Anand Jayarajan, Wei Zhao, and Yudi Sun. 2022. TiLT: A Time-Centric Approach
for Stream Query Optimization and Parallelization. (2022). https://doi.org/10.
5281/zenodo.7493145
[21] Alistair E.W. Johnson, Tom J. Pollard, Lu Shen, Li-wei H. Lehman, Mengling Feng,
Mohammad Ghassemi, Benjamin Moody, Peter Szolovits, Leo Anthony Celi,
and Roger G. Mark. 2016. MIMIC-III, a freely accessible critical care database.

---

TiLT: A Time-Centric Approach for Stream Query Optimization and Parallelization
ASPLOS ’23, March 25–29, 2023, Vancouver, BC, Canada
Scientific Data 3, 1 (24 May 2016), 160035. https://doi.org/10.1038/sdata.2016.35
[22] Kaggle. [n. d.]. Credit Card Fraud. https://www.kaggle.com/code/samkirkiles/
credit-card-fraud/data
[23] A Khadersab and S Shivakumar. 2018. Vibration Analysis Techniques for Ro-
tating Machinery and its effect on Bearing Faults. Procedia Manufacturing 20
(2018), 247–252. https://doi.org/10.1016/j.promfg.2018.02.036 2nd International
Conference on Materials, Manufacturing and Design Engineering (iCMMD2017),
11-12 December 2017, MIT Aurangabad, Maharashtra, INDIA.
[24] Alexandros Koliousis, Matthias Weidlich, Raul Castro Fernandez, Alexander L.
Wolf, Paolo Costa, and Peter Pietzuch. 2016. SABER: Window-Based Hybrid
Stream Processing for Heterogeneous Architectures. In Proceedings of the 2016
International Conference on Management of Data (San Francisco, California,
USA) (SIGMOD ’16). Association for Computing Machinery, New York, NY, USA,
555–569. https://doi.org/10.1145/2882903.2882906
[25] Lingkun Kong and Konstantinos Mamouras. 2020. StreamQL: A Query Language
for Processing Streaming Time Series. Proc. ACM Program. Lang. 4, OOPSLA,
Article 183 (nov 2020), 32 pages. https://doi.org/10.1145/3428251
[26] Sanjeev Kulkarni, Nikunj Bhagat, Maosong Fu, Vikas Kedigehalli, Christopher
Kellogg, Sailesh Mittal, Jignesh M. Patel, Karthik Ramasamy, and Siddarth Taneja.
2015. Twitter Heron: Stream Processing at Scale. In Proceedings of the 2015 ACM
SIGMOD International Conference on Management of Data (Melbourne, Victoria,
Australia) (SIGMOD ’15). Association for Computing Machinery, New York, NY,
USA, 239–250. https://doi.org/10.1145/2723372.2742788
[27] Chris Lattner and Vikram Adve. 2004. LLVM: A Compilation Framework for
Lifelong Program Analysis and Transformation. In Proceedings of the International
Symposium on Code Generation and Optimization: Feedback-Directed and Runtime
Optimization (Palo Alto, California) (CGO ’04). IEEE Computer Society, USA, 75.
[28] John W. Lockwood, Adwait Gupte, Nishit Mehta, Michaela Blott, Tom Eng-
lish, and Kees Vissers. 2012. A Low-Latency Library in FPGA Hardware for
High-Frequency Trading (HFT). In 2012 IEEE 20th Annual Symposium on High-
Performance Interconnects. 9–16. https://doi.org/10.1109/HOTI.2012.15
[29] Raymond A. Lorie. 1974. XRM - An Extended (N-ary) Relational Memory. Research
Report / G / IBM / Cambridge Scientific Center G320-2096 (1974).
[30] LSDS. [n. d.]. Do We Need Distributed Stream Processing? https://lsds.doc.ic.ac.
uk/blog/do-we-need-distributed-stream-processing
[31] Ruirui Lu, Gang Wu, Bin Xie, and Jingtong Hu. 2014. Stream Bench: Towards
Benchmarking Modern Distributed Stream Computing Frameworks. In Proceed-
ings of the 2014 IEEE/ACM 7th International Conference on Utility and Cloud
Computing (UCC ’14). IEEE Computer Society, USA, 69–78. https://doi.org/10.
1109/UCC.2014.15
[32] Frank McSherry, Michael Isard, and Derek G. Murray. 2015. Scalability! But at
what COST?. In 15th Workshop on Hot Topics in Operating Systems (HotOS XV).
USENIX Association, Kartause Ittingen, Switzerland. https://www.usenix.org/
conference/hotos15/workshop-program/presentation/mcsherry
[33] Hongyu Miao, Myeongjae Jeon, Gennady Pekhimenko, Kathryn S. McKinley, and
Felix Xiaozhu Lin. 2019. StreamBox-HBM: Stream Analytics on High Bandwidth
Hybrid Memory. In Proceedings of the Twenty-Fourth International Conference
on Architectural Support for Programming Languages and Operating Systems
(Providence, RI, USA) (ASPLOS ’19). Association for Computing Machinery, New
York, NY, USA, 167–181. https://doi.org/10.1145/3297858.3304031
[34] Hongyu Miao, Heejin Park, Myeongjae Jeon, Gennady Pekhimenko, Kathryn S.
McKinley, and Felix Xiaozhu Lin. 2017. StreamBox: Modern Stream Processing
on a Multicore Machine. In 2017 USENIX Annual Technical Conference (USENIX
ATC 17). USENIX Association, Santa Clara, CA, 617–629. https://www.usenix.
org/conference/atc17/technical-sessions/presentation/miao
[35] Steven S. Muchnick. 1998. Advanced Compiler Design and Implementation. Morgan
Kaufmann Publishers Inc., San Francisco, CA, USA.
[36] Derek G. Murray, Frank McSherry, Rebecca Isaacs, Michael Isard, Paul Barham,
and Martín Abadi. 2013. Naiad: A Timely Dataflow System. In Proceedings of
the Twenty-Fourth ACM Symposium on Operating Systems Principles (Farminton,
Pennsylvania) (SOSP ’13). Association for Computing Machinery, New York, NY,
USA, 439–455. https://doi.org/10.1145/2517349.2522738
[37] Thomas Neumann. 2011. Efficiently Compiling Efficient Query Plans for Modern
Hardware. Proc. VLDB Endow. 4, 9 (jun 2011), 539–550. https://doi.org/10.14778/
2002938.2002940
[38] NYSE. [n. d.]. New York Stock Exchange. ftp://ftp.nyse.com/
[39] Jiapu Pan and Willis J. Tompkins. 1985. A Real-Time QRS Detection Algorithm.
IEEE Transactions on Biomedical Engineering BME-32, 3 (1985), 230–236. https:
//doi.org/10.1109/TBME.1985.325532
[40] Gennady Pekhimenko, Chuanxiong Guo, Myeongjae Jeon, Peng Huang, and
Lidong Zhou. 2018. TerseCades: Efficient Data Compression in Stream Process-
ing. In 2018 USENIX Annual Technical Conference (USENIX ATC 18). USENIX
Association, Boston, MA, 307–320. https://www.usenix.org/conference/atc18/
presentation/pekhimenko
[41] Robert B. Randall and Jérôme Antoni. 2011. Rolling element bearing diagnos-
tics—A tutorial. Mechanical Systems and Signal Processing 25, 2 (2011), 485–520.
https://doi.org/10.1016/j.ymssp.2010.07.017
[42] Md. Mamunur Rashid, Iqbal Gondal, and Joarder Kamruzzaman. 2015. Condition
monitoring through mining fault frequency from machine vibration data. In
2015 International Joint Conference on Neural Networks (IJCNN). 1–8.
https:
//doi.org/10.1109/IJCNN.2015.7280569
[43] Amir Shaikhha, Yannis Klonatos, Lionel Parreaux, Lewis Brown, Mohammad
Dashti, and Christoph Koch. 2016. How to Architect a Query Compiler. In
Proceedings of the 2016 International Conference on Management of Data (San
Francisco, California, USA) (SIGMOD ’16). Association for Computing Machinery,
New York, NY, USA, 1907–1922. https://doi.org/10.1145/2882903.2915244
[44] Sasha Stoikov and Rolf Waeber. 2016.
Reducing transaction costs
with
low-latency
trading
algorithms.
Quantitative
Finance
16,
9
(2016),
1445–1451.
https://doi.org/10.1080/14697688.2016.1151926
arXiv:https://doi.org/10.1080/14697688.2016.1151926
[45] Michael Stonebraker, Ugur Çetintemel, and Stanley B. Zdonik. 2005. The 8
requirements of real-time stream processing. SIGMOD Rec. 34, 4 (2005), 42–47.
https://doi.org/10.1145/1107499.1107504
[46] Adrian Ţăran-Moroşan. 2011. The relative strength index revisited. African
Journal of Business Management 5, 14 (2011), 5855–5862.
[47] Georgios Theodorakis, Alexandros Koliousis, Peter Pietzuch, and Holger Pirk.
2020. LightSaber: Efficient Window Aggregation on Multi-Core Processors. In
Proceedings of the 2020 ACM SIGMOD International Conference on Management of
Data (Portland, OR, USA) (SIGMOD ’20). Association for Computing Machinery,
New York, NY, USA, 2505–2521. https://doi.org/10.1145/3318464.3389753
[48] Georgios Theodorakis, Fotios Kounelis, Peter Pietzuch, and Holger Pirk. 2021.
Scabbard: Single-Node Fault-Tolerant Stream Processing. Proc. VLDB Endow. 15,
2 (oct 2021), 361–374. https://doi.org/10.14778/3489496.3489515
[49] Ankit Toshniwal, Siddarth Taneja, Amit Shukla, Karthik Ramasamy, Jignesh M.
Patel, Sanjeev Kulkarni, Jason Jackson, Krishna Gade, Maosong Fu, Jake Donham,
Nikunj Bhagat, Sailesh Mittal, and Dmitriy Ryaboy. 2014. Storm@twitter. In
Proceedings of the 2014 ACM SIGMOD International Conference on Management of
Data (Snowbird, Utah, USA) (SIGMOD ’14). Association for Computing Machinery,
New York, NY, USA, 147–156. https://doi.org/10.1145/2588555.2595641
[50] Jonas Traub, Philipp Marian Grulich, Alejandro Rodriguez Cuellar, Sebastian
Bress, Asterios Katsifodimos, Tilmann Rabl, and Volker Markl. 2018. Scotty:
Efficient Window Aggregation for Out-of-Order Stream Processing. In 2018 IEEE
34th International Conference on Data Engineering (ICDE). 1300–1303.
https:
//doi.org/10.1109/ICDE.2018.00135
[51] Deepak Vasisht, Zerina Kapetanovic, Jongho Won, Xinxin Jin, Ranveer Chandra,
Sudipta Sinha, Ashish Kapoor, Madhusudhan Sudarshan, and Sean Stratman.
2017. FarmBeats: An IoT Platform for Data-Driven Agriculture. In 14th USENIX
Symposium on Networked Systems Design and Implementation (NSDI 17). USENIX
Association, Boston, MA, 515–529. https://www.usenix.org/conference/nsdi17/
technical-sessions/presentation/vasisht
[52] Jan Sipke van der Veen, Bram van der Waaij, Elena Lazovik, Wilco Wijbrandi,
and Robert J. Meijer. 2015. Dynamically Scaling Apache Storm for the Analysis
of Streaming Data. In Proceedings of the 2015 IEEE First International Conference
on Big Data Computing Service and Applications (BIGDATASERVICE ’15). IEEE
Computer Society, USA, 154–161. https://doi.org/10.1109/BigDataService.2015.56
[53] Wikipedia. 2023. Crest factor — Wikipedia, The Free Encyclopedia. http://en.
wikipedia.org/w/index.php?title=Crest%20factor&oldid=1106197809. [Online;
accessed 27-January-2023].
[54] Wikipedia. 2023.
Imputation (statistics) — Wikipedia, The Free Encyclope-
dia. http://en.wikipedia.org/w/index.php?title=Imputation%20(statistics)&oldid=
1118637345. [Online; accessed 27-January-2023].
[55] Wikipedia. 2023.
Linear interpolation — Wikipedia, The Free Encyclope-
dia. http://en.wikipedia.org/w/index.php?title=Linear%20interpolation&oldid=
1105095045. [Online; accessed 27-January-2023].
[56] Wikipedia. 2023.
Root mean square — Wikipedia, The Free Encyclope-
dia. http://en.wikipedia.org/w/index.php?title=Root%20mean%20square&oldid=
1127312985. [Online; accessed 27-January-2023].
[57] Wikipedia. 2023. Standard score — Wikipedia, The Free Encyclopedia. http://en.
wikipedia.org/w/index.php?title=Standard%20score&oldid=1128321544. [Online;
accessed 27-January-2023].
[58] wso2. [n. d.].
Fraud Detection and Prevention: A Data Analytics Ap-
proach. https://wso2.com/whitepapers/fraud-detection-and-prevention-a-data-
analytics-approach/#09
[59] Matei Zaharia, Tathagata Das, Haoyuan Li, Timothy Hunter, Scott Shenker, and
Ion Stoica. 2013. Discretized Streams: Fault-Tolerant Streaming Computation at
Scale. In Proceedings of the Twenty-Fourth ACM Symposium on Operating Systems
Principles (Farminton, Pennsylvania) (SOSP ’13). Association for Computing Ma-
chinery, New York, NY, USA, 423–438. https://doi.org/10.1145/2517349.2522737
[60] Steffen Zeuch, Bonaventura Del Monte, Jeyhun Karimov, Clemens Lutz, Manuel
Renz, Jonas Traub, Sebastian Breß, Tilmann Rabl, and Volker Markl. 2019. Ana-
lyzing Efficient Stream Processing on Modern Hardware. Proc. VLDB Endow. 12,
5 (jan 2019), 516–530. https://doi.org/10.14778/3303753.3303758
[61] Shuhao Zhang, Jiong He, Amelie Chi Zhou, and Bingsheng He. 2019. BriskStream:
Scaling Data Stream Processing on Shared-Memory Multicore Architectures. In

---

ASPLOS ’23, March 25–29, 2023, Vancouver, BC, Canada
Anand Jayarajan, Wei Zhao, Yudi Sun, and Gennady Pekhimenko
Proceedings of the 2019 International Conference on Management of Data (Amster-
dam, Netherlands) (SIGMOD ’19). Association for Computing Machinery, New
York, NY, USA, 705–722. https://doi.org/10.1145/3299869.3300067
Received 2022-07-07; accepted 2022-09-22

---

