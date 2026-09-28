# Desbordante: from benchmarking suite to high-performance science-intensive data 

> 来源: https://arxiv.org/pdf/2301.05965

Desbordante: from benchmarking suite to high-performance
science-intensive data profiler (preprint)
George Chernishev1,2, Michael Polyntsov2, Anton Chizhov2, Kirill Stupakov2, Ilya Shchuckin2,
Alexander Smirnov2, Maxim Strutovsky1,2, Alexey Shlyonskikh2, Mikhail Firsov2, Stepan
Manannikov2, Nikita Bobrov2, Daniil Goncharov2, Ilia Barutkin2, Vladislav Shalnev2, Kirill
Muraviev2, Anna Rakhmukova2, Dmitriy Shcheka2, Anton Chernikov2, Dmitrii Mandelshtam2,
Mikhail Vyrodov2, Arthur Saliou2, Eduard Gaisin2, Kirill Smirnov2
1Unidata LLC, Russia
2Saint-Petersburg University, Russia
Saint-Petersburg, Russia
georgii.chernyshev@unidata-platform.ru,polyntsov.m@gmail.com,anton.i.chizhov@gmail.com,kirill.v.stupakov@
gmail.com,shchuckinilya@gmail.com,alexander.a.smirnovv@gmail.com,maxim.strutovskiy@unidata-platform.ru,
shlyonskikh.alexey@gmail.com,mikhail.a.firsov@gmail.com,manannikov.st@gmail.com,nikita.v.bobrov@gmail.
com,goncharov.y.daniil@gmail.com,ilia.d.barutkin@gmail.com,vladislav.a.shalnevv@gmail.com,rakhmukova.
anna@gmail.com,dmitriy.v.shcheka@gmail.com,chernikov.a.anton@gmail.com,mandelshtamd@yandex.ru,
mikhail.v.vyrodov@gmail.com,arthur.salio@gmail.com,edu.gaisin@gmail.com,kirill.k.smirnov@gmail.com
ABSTRACT
Pioneering data profiling systems such as Metanome and Open-
Clean brought public attention to science-intensive data pro-
filing. This type of profiling aims to extract complex patterns
(primitives) such as functional dependencies, data constraints,
association rules, and others. However, these tools are research
prototypes rather than production-ready systems.
The following work presents Desbordante — a high-perfor-
mance science-intensive data profiler with open source code.
Unlike similar systems, it is built with emphasis on industrial
application in a multi-user environment. It is efficient, resilient to
crashes, and scalable. Its efficiency is ensured by implementing
discovery algorithms in C++, resilience is achieved by extensive
use of containerization, and scalability is based on replication of
containers.
Desbordante aims to open industrial-grade primitive discov-
ery to a broader public, focusing on domain experts who are not
IT professionals. Aside from the discovery of various primitives,
Desbordante offers primitive validation, which not only reports
whether a given instance of primitive holds or not, but also points
out what prevents it from holding via the use of special screens.
Next, Desbordante supports pipelines — ready-to-use function-
ality implemented using the discovered primitives, for example,
typo detection. We provide built-in pipelines, and the users can
construct their own via provided Python bindings. Unlike other
profilers, Desbordante works not only with tabular data, but with
graph and transactional data as well.
In this paper, we present Desbordante, the vision behind it
and its use-cases. To provide a more in-depth perspective, we
discuss its current state, architecture, and design decisions it is
built on. Additionally, we outline our future plans.
1
INTRODUCTION
According to [2], data profiling is the “set of activities and pro-
cesses to determine the metadata about a given dataset”. Such
metadata can be useful for dataset exploration, various tasks
related to data quality, database management and database re-
verse engineering. It also has many applications [3, 20] in data
integration and query optimization domains.
Data profiling can be divided into naive and science-intensive.
Naive profiling concerns extraction of such simple facts as num-
ber of rows and columns in a table, minimum and maximum
values in a column, detection of atomic column data types and
so on. There are hundreds of data profiling tools that belong
to this class, as almost all big information system vendors offer
them. Many open-source tools exist as well, and one of the most
prominent ones is Pandas Profiling [11].
On the other hand, science-intensive profilers focus on ex-
traction of complex metadata, which requires sophisticated al-
gorithms. Examples of such metadata discovery are the follow-
ing: extraction of all kinds of functional dependencies from ta-
bles, both exact and relaxed [12], association rule mining [4],
detection of semantic column types [19], discovery of data con-
straints [6, 37] and many more. Tools that offer such profiling are
much rarer. Two significant systems that offer such functionality
are Metanome [26] and OpenClean [24].
In this paper, we present Desbordante (Spanish for bound-
less) — a high-performance science-intensive data profiler. It is
inspired by Metanome, but differs from it in various key points.
First of all, the focus of Desbordante is on industrial applications
in a multi-user environment. Extracting complex metadata re-
quires sophisticated algorithms which are very computationally
expensive and crash-prone. Desbordante addresses these issues
by taking a mindful approach to algorithm implementation and
via specifically-designed application architecture.
Second, we have a different vision of use-cases for such a tool.
We envision our primary users as domain experts who possess a
large amount of data that they would like to explore, and at the
same time, they are not necessarily IT professionals. Our users
wish to discover various patterns in their data which state a non-
trivial fact. These patterns are formally described using a variety
of the so-called primitives. By itself, a primitive is a description
of a rule that holds over the data (or a part of it), described
formally, by mathematical methods. Functional dependencies
can be considered as a well-known example.
The kinds of experts who could be interested in pattern dis-
covery are:
arXiv:2301.05965v1  [cs.DB]  14 Jan 2023

---

(1) Bioinformatics researchers, chemists, geologists, and in
fact almost any scientist working with large amounts of
data, especially those obtained experimentally.
(2) People working with financial data: financial analysts,
salespeople, traders, who all also have a lot of data at hand
that can be explored.
(3) Data scientists, data analysts, machine learning specialists.
For scientists that work with large amounts of data, finding a
primitive indicates the presence of some pattern. Based on it, they
may be able to formulate a hypothesis or even draw conclusions
immediately (if there is enough data). At the very least, the found
pattern can give them a direction for further study. For example,
the bioinformatics group of the Saint-Petersburg JetBrains lab
used such primitives in their work [35].
In the case of financial data, the researcher can also try to ob-
tain some kind of hypothesis (for example, “out of all cars offered
by a competing company, red ones are the best selling”). How-
ever, there are more mundane and more in-demand applications:
cleaning errors in data, finding and removing inexact duplicates,
and many more. Note that scientists might also be interested in
this functionality, albeit to a much lesser extent.
As for machine learning, the found primitives can help in
feature engineering and choosing the direction for the ablation
study.
The aforementioned use-cases lead to the following specific
requirements for our primitive discovery tool:
• Focus on approximate primitives. Our users work with
real data, therefore implementing approximate primitives
should be of priority.
• Focus not only on primitive discovery, but also on prim-
itive validation and explainability of results. Our users
need to be provided with information why a particular
instance of a primitive does not hold.
• Focus on tunability. Our users wish to fine-tune discovery
process by specifying various constraints on sought-after
primitives.
• Focus on non-tabular data. While most popular data type
are tables, our users are also interested in other types such
as graphs and transactional data.
• Focus on supporting multiple interfaces. Some of our users
need console application, some a rich web UI, and some
need a Python interface.
The academic database community has created a large amount
of primitives describing many different patterns that may be
present in data. For example, there are more than thirty different
formulations only for the class of relaxed functional dependen-
cies [12]. And every year novel primitives continue to appear.
However, these primitives are largely unknown to people out-
side of the community. In the worst case they simply remain a
theoretical result, and at best they exist in the form of a little-
known prototype which is not ready for industrial application.
There are several tools [24, 26] that contain collections of algo-
rithms that discover and validate primitives but they are not
production-ready, too. They are performance-bound and fail to
cater to specific needs of our users by lacking required function-
ality.
Therefore, the idea of Desbordante is to “open” these primitives
to the general public and give everyone the opportunity to study
their data.
Now, turning to the Desbordante itself:
• Industrial focus is expressed through efficiency and re-
silience. Unlike other science-intensive profilers the kernel
of Desbordante is implemented in C++.
• Desbordante comes with a console and a web version. Also,
Python interface is provided.
• It supports pipelines — ready-to-use functionality imple-
mented using the discovered primitives, e.g, typo detec-
tion. Users can construct their own pipelines via python
bindings.
• It supports tabular and non-tabular data (graph, transac-
tional).
Desbordante is the open-source1 project implemented using
the modern tech stack. You can try the deployed demo here2.
The main contribution of this paper is the description of the
tool vision, architecture, and approaches we took to satisfy user
needs and ensure its high performance, resilience, and scalabil-
ity. We also discuss tool positioning, list currently supported
primitives, and present future plans.
The paper is organized as follows. In Section 2 we present re-
lated work and discuss existing profiling tools. Next, in Section 3
we describe primitives and requirements specific to their discov-
ery. In Section 4 we examine Desbordante from a 10K feet view
and below by describing project’s vision, core functionality, con-
siderations regarding user experience and system’s performance.
In Section 5 we sketch a system architecture of Desbordante,
technology stack, hows and whys of implemented microservices.
In Section 6 we list our future plans and milestones to achieve.
2
RELATED WORK
It is hard to classify existing tools in such a way that they would
exactly match with Desbordante by properties, functionality, or
vision. Therefore, we review most well-known tools which imple-
ment various data profiling techniques and can mine primitives
or at least highly rely on them.
The closest relative to Desbordante in the data profilers family
is Metanome [26]. In a nutshell, Metanome is a framework which
provides developers with an infrastructure and a corresponding
set of interfaces for implementing and benchmarking primitives.
Metanome’s architecture makes the process of developing and
testing research ideas as fast and convenient as it can be, thus
enabling developers to concentrate on the algorithms instead of
boilerplate code for database connectors, text processing utilities,
etc. Metanome was developed by the Hasso Plattner Institute
group and almost any algorithm developed by the same group
can be plugged into Metanome as a JAR file (the concept of an
algorithm as connectable compiled code is what Desbordante
currently lacks). However, Metanome can not be considered as
a true industrial alternative to Desbordante due to the reasons
we present in an extensive evaluation and comparison of both
platforms [34]: larger memory footprint, inferior dependency
discovery speed, just to name a few. Still, Metanome system
is an inspiration for Desbordante as for a user-friendly, high-
performance and flexible data profiler.
The goal of the OpenClean [24] system is to become a part of a
modern data science stack by taking a niche of data cleaning and
profiling. Being an open-source Python library, OpenClean pro-
vides its users with an environment where they can seamlessly
integrate data profiling with other frameworks and libraries for
1https://github.com/Mstrutov/Desbordante (algorithms),
https://github.com/vs9h/Desbordante (web application).
2https://desbordante.unidata-platform.ru

---

data processing and machine learning. The concept of FD is used
in two ways: checking data for FD violations and FD mining. The
former is implemented in Python as a combination of mapper and
group filters (much like the SELECT...GROUP BY ...HAVING
idiom for FD checking in SQL). For records which violate the FD,
a repair process can be started via OpenClean repair strategies
or user-defined ones. The primitive mining functionality is pro-
vided by a standalone package which initiates a subprocess for
running Metanome JAR files. Basically, any algorithm that was
once implemented for Metanome, can be run within OpenClean.
It also means that in terms of algorithm performance OpenClean
inherits all problems of Metanome.
Unlike OpenClean, most data cleaning tools have no built-in
functionality for primitive mining, and expect a user to provide
primitives as an input data to the cleaning process [7, 13, 29, 30].
For example, a data repairing framework HoloClean [29] makes
good use of denial constraints (DC), which subsumes FD, CFD and
matching FD concepts. The input of HoloClean is an inconsistent
dataset, a set of DCs and any external knowledge which can be
used to repair the dataset. HoloClean combines every piece of
available information and proposes solutions that can bring the
data to a consistent state. Since the main goal of HoloClean is
to pave a road to a careful restoration of a consistent form of a
dataset, the tool does not implement any internal mechanisms
for mining of primitives or for efficient in-place inference of
metadata. The same vision is shared by Horizon [30], which
computes a FD pattern graph based on the FD set provided, and
constructs a solution via pattern graph static analysis.
However, not every data profiling tool considers primitives as
a great deal for a cleaning process or error detection task. Other-
wise, they rely on machine learning, probabilistic methods [36],
or a curated knowledge base like Katara does [14]. The authors
of Katara even refuse to consider FDs as trusted metadata, since
this type of primitive can not guarantee that data would be fixed
in a non-ambiguous way.
Some data engineering tools follow a different philosophy:
instead of fixing data, they make sure it is tidy in the first place.
Great Expectations [1] allows its user to define complex integrity
constraints which are used as an assertion mechanism while the
data flows through ETL processes. Such tiny unit tests for data val-
idation can be embedded into a workflow and immediately raise
a flag if anything unexpected happens, e.g., newly arrived data
violates a primitive that was described within the Great Expecta-
tions framework. A similar idea is used in the Auto-Validate [32]
system.
The aforementioned tools are implementations of research
findings which are carefully surveyed in dozens of papers, and
some of these tools are open-source and free to use. To make
the overview complete, we would like to list some of industrial
solutions.
Most commercial solutions provide support for the concept
of FD as a part of data profiling: SAP Information Steward, Ora-
cle Warehouse Builder, Informatica Data Quality, Microsoft SQL
Server Data Profiling Task, and Talend Open Studio can return
functional dependencies which almost hold on data, or verify
whether a user-specified dependency holds. For each AFD, these
tools also maintain the fraction of records which violate a depen-
dency. It seems that this way of processing FD/AFD is almost
a must-have feature for any data profiling tool and it comes
handy when performing anomaly detection and exploring “bro-
ken” records. However, usually FD/AFD are the only types of
primitives that are implemented in a pay-to-use tool, since nowa-
days their focus has shifted to the machine learning side of data
profiling spectrum.
3
DISCOVERY OF SCIENCE-INTENSIVE
PRIMITIVES
3.1
Current State and Motivation
By itself, a primitive is some description of a rule (a pattern)
that holds over the data, described mathematically. Functional
dependencies can be a good example: dependency A −→B (A
and B being columns) holds if for each pair of rows it is true that
from the equality of values in A follows the equality of values in
B.
There are several hundred of types of primitives [12, 33], and
each of them has well-established properties and a sound theory
behind it. New types are developed all the time, too.
However, as stated in the Introduction, they largely stay within
the database and associated communities, they provide no benefit
to broader public.
The reasons for this are the following:
• Largely, implementations of primitives are poorly accessi-
ble or not available at all:
– The majority of them was developed in the pre-Github
era when it was not customary for authors to provide
source code or the source code was published on re-
search group’s web site, which is usually long-dead now.
Either way, currently there is no source code available.
– These that are accessible now are scattered around the
Web, on personal web sites or in obscure repositories.
Of course, the presenting paper usually includes a link,
but prospective users have to know about the primitive
and the paper first, which is not the case.
• If they are available, they are hard to set up and run. For
example, the newcomers of our team took from 6 to 12
work hours to set up and run Metanome. And at the same
time they are mostly computer science students who fa-
miliar with IT specifics. Thus, for a non-IT specialist who
would like to try some primitive, it will be a rather tedious
task.
• Each available implementation of a primitive (or even dis-
covery algorithm) would require its own software ecosys-
tem to set up and maintain. It is an another obstacle to
overcome for a prospective non-technical user who would
like to try some primitives.
• Finally, available implementations are usually proofs of
concept or prototypes which were made for some paper
and were abandoned later. Therefore, they are usually not
very efficient since they were developed in language which
favours rapid prototyping, like Java or Python. These lan-
guages lack efficiency and low-level tunability of C++.
There are also scalability issues in a sense that real world
datasets are likely to be larger than those benchmarked
by paper authors. Moreover, these implementations may
crash when processing a dataset which was not bench-
marked by its authors. Thus, it is necessary to shift the
limits of applicability further (since the name — Desbor-
dante).
There are platforms which try to address these issues, such
as Metanome or OpenClean. However, they fail to address all
these issues at once. Thus, there is a need for an industrial-grade

---

Figure 1: The result page of the web version of Desbordante (conditional functional dependencies)
platform which will open primitive discovery to the broader
public and Desbordante tries to achieve this goal.
3.2
Specifics of science-intensive primitive
discovery
Discovery of science-intensive primitives has its own specifics,
which can be described by several aspects, divided into two
groups. The ones belonging to first group are inherent to all
science-intensive profilers and stem from the nature of primitive
discovery task.
(1) Primitive discovery is a computationally hard problem.
Discovery algorithms run into time or memory limits even
for small datasets. Consider, for example, Table 1 from [28]
where one can see sizes of datasets that can be mined for
functional dependencies using server-class hardware. All
datasets except two are smaller than one megabyte. The
situation is similar in case of other primitives. Therefore,
in order to make the discovery of primitives truly usable,
we need to address these limitations.
(2) Implementations of discovery algorithms are very com-
plex, frequently depend on third-party libraries, and in
general they solve a task belonging to the forefront of
science. Therefore, they are fragile — they can crash or
freeze on some inputs. Therefore, when “industrializing”
them, one has to improve reliability of the application by
making it fault-tolerant.
The second group describes aspects which are specific to the
vision and goals of our system. These reflect use-cases and needs
of our users.
(1) Our users are more interested in approximate primitives.
Real world data is likely to have all kinds of errors, missing
values, and other types of artifacts. Therefore, exact ver-
sions of primitives are not applicable, they will be rarely
found in real data. Instead, developing our profiler, we
must provide inexact versions, which will allow some de-
gree of error.
(2) Our users need not only discovery of primitives, but also
their validation. Unlike discovery, validation accepts a
specific instance of a primitive (e.g. a specific functional
dependency) as input and returns whether it holds or not.
This leads to the need for special screens in which the
user can analyze the data and see what prevents a given
primitive from holding (e.g. conflicting values, rows, etc.).
(3) Our users need to be provided with various tuning knobs
that will govern the discovery process. For example, con-
cerning the discovery of functional dependencies, it is
well-known that dependencies with a larger left-hand side
are less valuable. Their discovery usually does not indicate
the presence of a real dependency, but instead points to
the fact that the data segment which was used for mining
is too small to contain a counterexample. Primitive discov-
ery process is always costly and it is worthwhile to skip
unnecessary computations. Another important example
is setting the error threshold for approximate primitives.
At the same time, correct values depend on the particular
dataset and user goals.
(4) Our users have different preferences regarding the inter-
face to use. Some of them prefer an old-school command-
line interface, while others ask for a rich web UI. Further-
more, in order to open primitives to data scientists it is
essential to provide a Python interface.
Desbordante aims to take into account these specifics.
4
DESBORDANTE
4.1
Overview
The core of Desbordante is a C++ library containing all auxiliary
data structures needed for primitive discovery algorithms, the
algorithms themselves and all required surrounding infrastruc-
ture. The library provides an API for executing the algorithms
and obtaining their results which is used by the back-end of the
web application. There is also additional library version with
python bindings,so that all Desbordante features can be used

---

Figure 2: Console validation screen for metric functional dependency
from within Python. There are two available user interfaces for
the Desbordante library: console and web interface.
Desbordante supports two different types of tasks (and there-
fore algorithms):
• Discovery: find all holding instances of specified primitive
over specified dataset;
• Validation: given a primitive instance determine whether
it holds over specified dataset, provide additional informa-
tion about what prevents it from holding otherwise.
The usage workflow is generally the following:
(1) Select the primitive and desired algorithm for its discovery
or validation;
(2) Specify a dataset to work on and the required parameters;
(3) Execute the algorithm and retrieve the results;
(4) Filter and sort the results as needed.
These steps are clearly separated in the web application, while
in the console version all the required information for the algo-
rithm (steps 1–2) can be set directly via CLI parameters. Since the
web application was designed to be used by non-IT professionals
in the first place, it should provide quality of life features besides
its main functionality. Examples of such features are a viewable
snippet of the selected dataset, a user-friendly interface with
extensive usage examples, ready-to-use pipelines, and a progress
bar which shows the current execution status of a task. Desbor-
dante itself and the web application have a set of the built-in
datasets. They mainly serve two purposes. First, help users to un-
derstand what possible data insights they can get using specific
primitives. Second, make newbies familiar with the workflow
of the tool. In addition to built-in datasets, the web application
allows the user to upload their own. These datasets constitute
user’s personal library which shares the same workflow as the
built-in ones.
4.2
User-facing aspects
The first feature that we would like to present is the tunability
of primitive discovery and validation processes. Each primitive
discovery or validation algorithm has a set of various options.
These options can be divided in two groups: general and primitive-
specific parameters. General parameters are the properties which
need to be set up for any discovery task: dataset, its delimiter, and
the Boolean switch which indicates whether the dataset has a
header. Then, there are primitive-specific parameters, the first and
most important of which is the algorithm. For some primitives,
the best performing algorithm is more or less known, but for
some it is not. Moreover, a discovery algorithm may perform
badly on a “wide” or a “long” table. It may also crash due to the
specifics of a particular dataset since different algorithms are
built upon different principles and, for example, may require too
much memory. Therefore, we have decided to provide several
available algorithms and in some cases all of them.
Each of these algorithms has its own set of supported param-
eters. First of all, they are what to validate or to look for, some
filters on the primitive instance. Then, if an algorithm supports
discovery (or validation) of an approximate primitive, then the
degree of allowed violations. Next, for discovery algorithms it
is useful in some way to limit the “depth” of search. Discovery
process is time-consuming and, at the same time, all instances
are not always needed. Finally, a user can specify the number of
threads which will be used for primitive discovery or validation
if the selected algorithm supports multi-threading.
The next important feature are custom screens for the primi-
tive validation task. This task reports whether a specific primitive
holds or not. However, if it does not hold, users need explanations
and answers to questions such as “how much is lacking?” and
“what prevents it from holding?”. It is essential to provide such
information since it is an important knowledge about data being
explored. It can indicate errors in data and point out “problematic”
records. Therefore, there is a need for a screen that will provide
this information.
An example of such a screen for the console version of metric
functional dependency [22] validation is presented in Figure 2. It
shows clusters of records that share the same left hand side, but
differ in the right one. The “x” marks records which are too far
from the rest in terms of their right hand side. Their distance to
any of points from the same cluster is larger than the specified
one and therefore they are good candidates to be outliers. The
user can sort clusters and records within clusters using various
parameters such as distance, index, number of outliers and so on.
Primitive discovery task also implements result screens with
rich interaction tools that allow sorting using various parameters,
filtering with regular expressions, and so on.

---

4.3
Pipelines
Aside from primitive discovery and primitive validation tasks,
Desbordante offers pipelines. A pipeline is a set of ready-to-use
functionality implemented using discovered primitives, which
benefits a non-expert end user. While discovered primitive in-
stances are useful by themselves, we believe that it is important
to demonstrate what can be done using them.
There are two types of pipelines in Desbordante: built-in and
custom. The first ones are present in the web application and have
a rich interface. As a demo, we have included a typo detection
pipeline in the deployed version. Its idea is as follows:
(1) Find functional dependencies which almost hold, i.e. ap-
proximate dependency [23] holds, but not the exact one.
Present them to the user for inspection.
(2) Then, for the dependency selected by the user, present its
clusters — row groups with the same left hand side and
different values in the right hand side. These are the sets of
rows which prevent exact FD from holding. In this screen,
user can inspect the differences in the right hand side and
decide whether the there is a typo or not. Having resolved
the conflict for a particular cluster, a user can reupload
the new version of dataset and continue data cleaning.
(3) In order to reduce the number of presented clusters, the
user interface contains several parameters that enable clus-
ter filtering. A threshold for dependency to be considered
as “almost” holding can also be set.
Note that the CLI does not provide built-in pipelines, since
they require extensive interactivity.
While built-in pipelines are useful as a demo, they require
significant effort to implement. As we are limited in resources,
we put only the most useful scenarios on the web version. At
the same time, we would like to allow users to experiment and
build their own pipelines. For this, we provide an ability to build
custom pipelines.
Contemporary data scientists use Python, and therefore it is es-
sential to enable calling primitive discovery and validation tasks
from Python programs. For this, we employed the pybind11 [21]
library to provide the necessary operators and data structures.
Using these bindings, our users can call Desbordante algorithms
to experiment and construct their own pipelines. We plan to
add popular ones to the web version and develop a user-friendly
interface for them.
4.4
Performance
Unlike all existing open-source solutions, the discovery part of
Desbordante is fully implemented in modern C++. While popular
languages such as Python and Java are relatively simpler and
thus offer a fast development process, they possess a number of
no less prominent drawbacks:
(1) Given equal effort put into code, the resulting performance
of Java/Python applications is worse than that of C++, on
average.
(2) Java application performance can be unpredictable. Since
explicit memory management is not possible in Java, pro-
grams rely on an automatic garbage collector, which may
be invoked at any time. Therefore, run times may signif-
icantly differ even for consecutive invocations of single-
threaded programs.
(3) Java programs usually leave a higher memory footprint
than C++.
Figure 3: Performance comparison of Desbordante and
Metanome using Pyro
(4) Finally, these languages restrict opportunities for low-level
optimizations, such as vectorization via SIMD instructions.
It is a critical drawback for solving a high-performance
computing task.
To demonstrate the validity of our arguments we have experi-
mentally compared Desbordante with Metanome [34]. For this,
we have selected the Pyro algorithm [23] since it was one of the
most promising primitives for the intended application scenarios.
This algorithm discovers approximate functional dependencies.
The results are presented in Figure 3. The obtained improve-
ment ranged from 1.19 to 3.43 times and was 2.12 on average.
While the numbers are not really high, it is still an important
result for such a computationally expensive problem.
Another significant benefit is the reduction of memory con-
sumption — the memory footprint of Desbordante is approxi-
mately two times lower than Metanome’s. This is crucial since
many primitive discovery algorithms are memory-bound [28].
Thus, reducing memory footprint enables the processing of larger
datasets.
It is important to note that we have not exhausted the tuning
potential of the C++ implementation. No sophisticated techniques
were used (e.g., vectorization), no source code profiling was done,
standard data structures and libraries were used, etc. Currently,
Desbordante uses default C++ and Boost data structures, and we
have not tuned their parameters. Desbordante does not rely on
custom memory management libraries (allocators), but instead
uses the C++ default. It is a well-known fact [25] that using a
special allocator is a simple yet efficient way to improve per-
formance of C++ programs. Therefore, it is possible to improve
performance even more.
Finally, we must also discuss the approaches that rely on dis-
tribution of Java/Python code. Firstly, we believe that they will
not improve the situation much. Primitive discovery problems
are generally poorly scalable and naive approaches are not func-
tional at all (e.g. see Fig. 1 in [31]). The reason for this is that
it is necessary to pass over the whole (or a significant part of)

---

Figure 4: Desbordante architecture in detail
dataset in order to get to the answer. Therefore, we believe that it
is important to get the maximum performance out of single-node
processing.
Secondly, since distribution approaches usually consist of a
data shuffling scheme and some local algorithm, we can say that
a distribution-based approach is not competing, but complemen-
tary to ours.
4.5
Supported primitives
Due to the reasons stated in Section 3 Desbordante possesses
a slightly different set of primitives than Metanome. Currently,
Desbordante supports discovery and validation for the following
primitives:
(1) Discovery of exact functional dependencies. We support all
algorithms [27] that were implemented by the Metanome
team, including HyFD [28] and the approximate algorithm
AID-FD [8].
(2) Discovery of approximate functional dependencies, using
the Pyro [23] and TANE [18] algorithms.
(3) Discovery of conditional functional dependencies using
the CTANE [15, 16] algorithm and its variations.
(4) Discovery of unary and n-ary Inclusion Dependencies
using the Spider algortihm [5].
(5) Validation of metric dependencies [22] (only in the console
version for now).
(6) Discovery of fuzzy algebraic constraints [10] (only in the
console version for now).
(7) Discovery of association rules. This code was adapted
from Christian Borgelt’s3 implementations [9] since it is
efficient (used in the R package4) and time-proven. Follow-
ing his recommendations, we have selected only ECLAT,
FP-Growth and Apriori algorithms.
(8) Validation of Graph Dependencies [17] (only console ver-
sion for now)
3https://borgelt.net/fpm.html
4https://www.rdocumentation.org/packages/arules/versions/1.6-8
(9) Naive profiling. In order to expand the userbase, we have
also implemented naive profiling, which includes a num-
ber of simple statistics like min, max, number of missing
values over column and so on.
For now, we lack a significant number of primitives that Me-
tanome has, such as UCCs, order dependencies and others. How-
ever, we have other types that are absent there (e.g. metric FDs),
and which are more relevant for our use-cases. Also, to the best of
our knowledge, for some of primitive types, e.g. graph dependen-
cies, metric functional dependencies, and algebraic constraints
our implementation is the only one publicly available. Finally,
in the future we plan to greatly expand their number and catch
up — some of the missing ones are already in the works.
5
ARCHITECTURE
In this section, we describe the architecture of the web application
that we built around its core — Desbordante. Initially, Desbor-
dante was a simple console application which used command line
parameters and standard output as a user interface. In summer
2021 we have come to the vision described in the Introduction
section and decided to provide it with a web interface.
Thinking about its implementation, we have formulated the
following requirements for the web application:
(1) Functionality. The system should be able to perform sev-
eral user tasks in parallel.
(2) Recoverability. The system should be able to recover itself
in case of various unexpected errors.
(3) Efficiency and manageability. The system should be able
to limit computational resources which are given to a par-
ticular user or even a task. This requirement is crucial to
prevent resource overuse and will also will allow resource
scheduling.
(4) Scalability. The architecture of the system should allow
using several computing nodes for performing user tasks.
Therefore, we have decided to use the microservice architec-
ture, where each individual service performs a specific set of tasks.
We have separate services for serving user requests, managing
containers, executing tasks, database and task queue. Also, the
microservice architecture goes well with containerization. The

---

overall architecture showing connections between microservices
is presented in Figure 4.
This approach also simplified dependency management as
each of the services has every dependency pre-installed in its
container. Thus, new versions of the application can be quickly
redeployed to deliver new features to the users as soon as possible.
As the result, we have built a fault-tolerant application, which
means that in case of one of the microservices failing, the ap-
plication will continue its work and quickly restart the failed
microservice. Our architecture is highly scalable, it can launch
more task-executors if necessary.
Let us consider the architecture in detail.
(1) Serving webpages, frontend server directly interacts with
the users. It is responsible for server-side rendering, a
technique that moves calculations from the client browsers
to the server. That speeds up page loading and makes user
interface more responsible.
(2) Node.js web server provides an API that allows to run
tasks, send files and receive status updates. For each task
on its arrival it creates entries both in the database and the
queue. Web client periodically sends pings to the server,
which replies with the progress info on the task. After
task execution is finished, it sends back either the results
or an error message (if a calculation error occurred or it
required too many computational resources to complete).
(3) In addition to Docker, we have our own container orches-
trator that is used for executor containers management.
The orchestrator also behaves as a consumer for the queue.
For each task, it creates a new executor container and pro-
vides it with the task’s payload. This service allows us
to limit computational resources used by the executors.
Additionally, in case of the executor failure it puts an error
message into the database.
(4) We use Kafka as a task queue.
That makes load balancing between multiple instances of
the orchestrator service possible.
(5) PostgreSQL serves as a DBMS in our project. It is used
as a storage for the information about currently running
or recently finished tasks, such as progress info, error
messages and calculation results. Additionally it contains
user profiles, session info and file metadata
(6) The kernel of the app is its task executor utilizing Desbor-
dante as a library. Its purpose is to run the specified algo-
rithm on the provided data. On launch it acquires the data
from the database and then starts the execution. While
calculations are in progress, executor updates its task’s
status in the database. Finishing successfully or failing it
returns calculation results or an error, respectively. Several
executor containers can run at the same time, therefore
making it possible to serve the users simultaneously.
The main set of the microservices is accompanied by the mon-
itoring system. It utilizes two specific tools: Prometheus and
Grafana. Prometheus accumulates metrics from the services, pe-
riodically collecting data from the specified endpoints. Grafana
presents these data in the form of informative dashboards. It
is also capable of notifying of events meeting the predefined
requirements.
Collected data provides some insights about the system’s
health, resource consumption, and execution errors. It is cru-
cial for addressing probable hardware and software issues.
6
FUTURE PLANS
Desbordante is currently being actively developed. There are
two primary directions: improving user experience (in a broader
sense) and adding new primitives. The first one includes the
following tasks:
• alternative approaches to data uploading: via external file
link, database connectors or import of serialized data struc-
tures (e.g. pandas pickled dataframes or NumPy arrays);
• export of results in most common data exchange formats;
• web API tokens, so remote high-performing server can be
used for discovery tasks;
• data manipulation such as in-place table edits, column
renaming or creation of new columns based on a user
defined formula;
• regexp search over dataset cells;
• extending user and admin dashboard.
The second one concerns extending the pool of available prim-
itives. There are two directions: first we plan to catch up with
Metanome by adding missing primitives and at the same time we
plan to continue to implement our vision and bring less known
primitives to light. Near-term plans include implementing the
following primitives:
• matching dependencies
• order dependencies
• denial constraints
• differential dependencies
• unique column combination
• various types of relaxed functional dependencies
• graph dependency discovery
• advanced dataset statistics
Finally, we also plan to touch upon system aspects:
• Devise smart result caching and checking result contain-
ment.
• Implement stream processing and dynamic recalculation
of primitives.
ACKNOWLEDGMENTS
We would like to thank Nikita Talalay and Bulat Biktagirov for
their contribution to the project. We would also like to thank
Anna Smirnova for her help with the preparation of this paper.
7
CONCLUSION
In this paper we have presented Desbordante — an open-source
data profiler with the focus on discovery of science-intensive
patterns in data. Desbordante aims to open industrial-grade prim-
itive discovery to a broader public, focusing on domain experts
who are not IT professionals. Unlike similar systems, it is built
with emphasis on industrial application in a multi-user environ-
ment. It is efficient, resilient to crashes, and scalable. Its efficiency
is ensured by implementing discovery algorithms in C++, re-
silience is achieved by extensive use of containerization, and
scalability is based on replication of containers.
REFERENCES
[1] James Campbell Abe Gong. [n.d.]. Great Expectations. https://github.com/
great-expectations/great_expectations.
[2] Ziawasch Abedjan, Lukasz Golab, and Felix Naumann. 2015.
Profiling
Relational Data: A Survey. The VLDB Journal 24, 4 (aug 2015), 557–581.
https://doi.org/10.1007/s00778-015-0389-y
[3] Ziawasch Abedjan, Lukasz Golab, Felix Naumann, and Thorsten Papenbrock.
2018. Data Profiling. Morgan & Claypool Publishers.

---

[4] Charu C. Aggarwal and Jiawei Han. 2014. Frequent Pattern Mining. Springer
Publishing Company, Incorporated.
[5] Jana Bauckmann, Ulf Leser, Felix Naumann, and Veronique Tietz. 2007. Ef-
ficiently Detecting Inclusion Dependencies. In 2007 IEEE 23rd International
Conference on Data Engineering. 1448–1450. https://doi.org/10.1109/ICDE.
2007.369032
[6] Leopoldo Bertossi, Loreto Bravo, Enrico Franconi, and Andrei Lopatenko.
2008. The complexity and approximation of fixing numerical attributes in
databases under integrity constraints. Information Systems 33, 4 (2008), 407–
434. https://doi.org/10.1016/j.is.2008.01.005 Selected Papers from the Tenth
International Symposium on Database Programming Languages (DBPL 2005.
[7] George Beskales, Ihab F. Ilyas, and Lukasz Golab. 2010. Sampling the Repairs
of Functional Dependency Violations under Hard Constraints. Proc. VLDB
Endow. 3, 1–2 (sep 2010), 197–207. https://doi.org/10.14778/1920841.1920870
[8] Tobias Bleifuß, Susanne Bülow, Johannes Frohnhofen, Julian Risch, Georg
Wiese, Sebastian Kruse, Thorsten Papenbrock, and Felix Naumann. 2016.
Approximate Discovery of Functional Dependencies for Large Datasets. In
Proceedings of the 25th ACM International on Conference on Information and
Knowledge Management (CIKM ’16). Association for Computing Machinery,
New York, NY, USA, 1803–1812. https://doi.org/10.1145/2983323.2983781
[9] Christian Borgelt. 2005. An Implementation of the FP-Growth Algorithm. In
Proceedings of the 1st International Workshop on Open Source Data Mining: Fre-
quent Pattern Mining Implementations (OSDM ’05). Association for Computing
Machinery, New York, NY, USA, 1–5. https://doi.org/10.1145/1133905.1133907
[10] Paul G. Brown and Peter J. Hass. 2003. BHUNT: Automatic Discovery of
Fuzzy Algebraic Constraints in Relational Data. In Proceedings of the 29th
International Conference on Very Large Data Bases - Volume 29 (VLDB ’03).
VLDB Endowment, 668–679.
[11] Simon Brugman. 2019. pandas-profiling: Exploratory Data Analysis for Python.
https://github.com/pandas-profiling/pandas-profiling.
[12] Loredana Caruccio, Vincenzo Deufemia, and Giuseppe Polese. 2016. Relaxed
Functional Dependencies—A Survey of Approaches. IEEE Transactions on
Knowledge and Data Engineering 28, 1 (2016), 147–165.
https://doi.org/10.
1109/TKDE.2015.2472010
[13] Xu Chu, Ihab F. Ilyas, and Paolo Papotti. 2013. Holistic data cleaning: Putting
violations into context. In 2013 IEEE 29th International Conference on Data
Engineering (ICDE). 458–469. https://doi.org/10.1109/ICDE.2013.6544847
[14] Xu Chu, John Morcos, Ihab F. Ilyas, Mourad Ouzzani, Paolo Papotti, Nan
Tang, and Yin Ye. 2015. KATARA: Reliable Data Cleaning with Knowledge
Bases and Crowdsourcing. Proc. VLDB Endow. 8, 12 (aug 2015), 1952–1955.
https://doi.org/10.14778/2824032.2824109
[15] Wenfei Fan, Floris Geerts, Laks V. S. Lakshmanan, and Ming Xiong. 2009.
Discovering Conditional Functional Dependencies. In Proceedings of the 25th
International Conference on Data Engineering, ICDE 2009, March 29 2009 - April
2 2009, Shanghai, China. IEEE, 1231–1234. https://doi.org/10.1109/ICDE.2009.
208
[16] Wenfei Fan, Floris Geerts, Jianzhong Li, and Ming Xiong. 2011. Discovering
Conditional Functional Dependencies. IEEE Trans. Knowl. Data Eng. 23, 5
(2011), 683–698. https://doi.org/10.1109/TKDE.2010.154
[17] Wenfei Fan, Yinghui Wu, and Jingbo Xu. 2016. Functional Dependencies for
Graphs. In Proceedings of the 2016 International Conference on Management
of Data (SIGMOD ’16). Association for Computing Machinery, New York, NY,
USA, 1843–1857. https://doi.org/10.1145/2882903.2915232
[18] Y. Huhtala, J. Kärkkäinen, P. Porkka, and H. Toivonen. 1999. Tane: An Effi-
cient Algorithm for Discovering Functional and Approximate Dependencies.
Comput. J. 42, 2 (1999), 100–111. https://doi.org/10.1093/comjnl/42.2.100
[19] Madelon Hulsebos, Kevin Hu, Michiel Bakker, Emanuel Zgraggen, Arvind
Satyanarayan, Tim Kraska, Çagatay Demiralp, and César Hidalgo. 2019. Sher-
lock: A Deep Learning Approach to Semantic Data Type Detection. In Proceed-
ings of the 25th ACM SIGKDD International Conference on Knowledge Discovery
& Data Mining (KDD ’19). Association for Computing Machinery, New York,
NY, USA, 1500–1508. https://doi.org/10.1145/3292500.3330993
[20] Ihab F. Ilyas and Xu Chu. 2019. Data Cleaning. Association for Computing
Machinery, New York, NY, USA.
[21] Wenzel
Jakob,
Jason
Rhinelander,
and
Dean
Moldovan.
2017.
pybind11
–
Seamless
operability
between
C++11
and
Python.
https://github.com/pybind/pybind11.
[22] Nick Koudas, Avishek Saha, Divesh Srivastava, and Suresh Venkatasubrama-
nian. 2009. Metric Functional Dependencies. In 2009 IEEE 25th International
Conference on Data Engineering. 1275–1278. https://doi.org/10.1109/ICDE.
2009.219
[23] Sebastian Kruse and Felix Naumann. 2018. Efficient Discovery of Approximate
Dependencies. Proc. VLDB Endow. 11, 7 (March 2018), 759–772. https://doi.
org/10.14778/3192965.3192968
[24] Heiko Müller, Sonia Castelo, Munaf Qazi, and Juliana Freire. 2021. From Papers
to Practice: The Openclean Open-Source Data Cleaning Library. Proc. VLDB
Endow. 14, 12 (oct 2021), 2763–2766. https://doi.org/10.14778/3476311.3476339
[25] “No Bugs” Hare. 2018.
Testing Memory Allocators: ptmalloc2 vs tc-
malloc vs hoard vs jemalloc While Trying to Simulate Real-World
Loads.
http://ithare.com/testing-memory-allocators-ptmalloc2-tcmalloc-
hoard-jemalloc-while-trying-to-simulate-real-world-loads/
[26] Thorsten Papenbrock, Tanja Bergmann, Moritz Finke, Jakob Zwiener, and
Felix Naumann. 2015. Data Profiling with Metanome. Proc. VLDB Endow. 8,
12 (Aug. 2015), 1860–1863. https://doi.org/10.14778/2824032.2824086
[27] Thorsten Papenbrock, Jens Ehrlich, Jannik Marten, Tommy Neubert, Jan-
Peer Rudolph, Martin Schönberg, Jakob Zwiener, and Felix Naumann. 2015.
Functional Dependency Discovery: An Experimental Evaluation of Seven
Algorithms. Proc. VLDB Endow. 8, 10 (June 2015), 1082–1093. https://doi.org/
10.14778/2794367.2794377
[28] Thorsten Papenbrock and Felix Naumann. 2016. A Hybrid Approach to
Functional Dependency Discovery. In Proceedings of the 2016 International
Conference on Management of Data (SIGMOD ’16). Association for Computing
Machinery, New York, NY, USA, 821–833. https://doi.org/10.1145/2882903.
2915203
[29] Theodoros Rekatsinas, Xu Chu, Ihab F. Ilyas, and Christopher Ré. 2017. Holo-
Clean: Holistic Data Repairs with Probabilistic Inference. Proc. VLDB Endow.
10, 11 (aug 2017), 1190–1201. https://doi.org/10.14778/3137628.3137631
[30] El Kindi Rezig, Mourad Ouzzani, Walid G. Aref, Ahmed K. Elmagarmid,
Ahmed R. Mahmood, and Michael Stonebraker. 2021.
Horizon: Scalable
Dependency-Driven Data Cleaning. Proc. VLDB Endow. 14, 11 (oct 2021),
2546–2554. https://doi.org/10.14778/3476249.3476301
[31] Hemant Saxena, Lukasz Golab, and Ihab F. Ilyas. 2019. Distributed Implemen-
tations of Dependency Discovery Algorithms. Proc. VLDB Endow. 12, 11 (jul
2019), 1624–1636. https://doi.org/10.14778/3342263.3342638
[32] Jie Song and Yeye He. 2021. Auto-Validate: Unsupervised Data Validation Using
Data-Domain Patterns Inferred from Data Lakes. In Proceedings of the 2021
International Conference on Management of Data (SIGMOD ’21). Association
for Computing Machinery, New York, NY, USA, 1678–1691. https://doi.org/
10.1145/3448016.3457250
[33] Shaoxu Song, Fei Gao, Ruihong Huang, and Chaokun Wang. 2022. Data
Dependencies Extended for Variety and Veracity: A Family Tree.
IEEE
Transactions on Knowledge and Data Engineering 34, 10 (2022), 4717–4736.
https://doi.org/10.1109/TKDE.2020.3046443
[34] Maxim Strutovskiy, Nikita Bobrov, Kirill Smirnov, and George Chernishev.
2021. Desbordante: a Framework for Exploring Limits of Dependency Dis-
covery Algorithms. In 2021 29th Conference of Open Innovations Association
(FRUCT). 344–354. https://doi.org/10.23919/FRUCT52173.2021.9435469
[35] Petr Tsurinov, Oleg Shpynov, Nina Lukashina, Daria Likholetova, and Maxim
Artyomov. 2021. FARM: Hierarchical Association Rule Mining and Visu-
alization Method. In Proceedings of the 12th ACM Conference on Bioinfor-
matics, Computational Biology, and Health Informatics (BCB ’21). Associa-
tion for Computing Machinery, New York, NY, USA, Article 70, 1 pages.
https://doi.org/10.1145/3459930.3469499
[36] Mohamed Yakout, Laure Berti-Équille, and Ahmed K. Elmagarmid. 2013. Don’t
Be SCAREd: Use SCalable Automatic REpairing with Maximal Likelihood and
Bounded Changes. In Proceedings of the 2013 ACM SIGMOD International
Conference on Management of Data (SIGMOD ’13). Association for Computing
Machinery, New York, NY, USA, 553–564. https://doi.org/10.1145/2463676.
2463706
[37] C.T. Yu and W. Sun. 1989. Automatic knowledge acquisition and maintenance
for semantic query optimization. IEEE Transactions on Knowledge and Data
Engineering 1, 3 (1989), 362–375. https://doi.org/10.1109/69.87981

---

