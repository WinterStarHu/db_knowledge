# Designing a Visual Tool for Property Graph Schema Extraction and Refinement: An 

> 来源: https://arxiv.org/pdf/2201.03643

Designing a Visual Tool for Property Graph Schema
Extraction and Reﬁnement: An Expert Study
Capita Selecta Databases (2IMD05)
Nimo Beeren
n.beeren@student.tue.nl
Eindhoven University of Technology
Department of Mathematics and Computer Science
January 12, 2022
Abstract
The design space of visual tools that aim to help people create schemas for property
graphs is explored. Interviews are conducted with experts in the domain of property
graphs and data management in general. Through this collaboration, we determine how
a schema extraction tool can provide value. These insights are used to establish design
requirements and design a UI prototype, which are then relayed back to the experts.
Positive reactions were received, which encourage future work in the property graph
schema space.
1
Introduction
A property graph (PG) can be used to represent data as a directed, attributed multi-graph,
in which nodes and edges carry a set of labels and a set of key-value pairs, known as
properties [2]. PGs are used as the underlying data model in many common graph database
systems, such as Neo4j1, TigerGraph [6], and Amazon Neptune [1].
By imposing a set of integrity constraints (schema) on a database system, we ensure that there
is some agreement between data consumers and producers regarding the type of data that is
stored. The schema can be used to better understand the structure of data and how entities
are connected, which is essential for data integration, analytics, and physical optimization
of the database system. The Linked Data Benchmark Council (LDBC)2 concerns itself with
standardization and the community around graph processing technologies. In particular, the
Property Graph Schema Working Group (PGSWG)3 is currently working to standardize the
notion of schemas for PGs.
Because of the ﬂexibility of the PG model, graph databases are often used to store a large
variety of data. Unfortunately, these heterogeneous collections of data do not always have a
well-deﬁned structure in the form of a schema, which can make them diﬃcult to work with.
Recently, work has been done to generate a schema for a given PG instance, in a process
called schema extraction [10, 11]. Given the advantages of schemas and the practical lack of
structure in many PGs, these techniques may provide signiﬁcant value.
1https://neo4j.com/
2https://ldbcouncil.org/
3https://ldbcouncil.org/gql-community/pgswg/
1
arXiv:2201.03643v1  [cs.DB]  10 Jan 2022

---

While schema extraction techniques may guarantee that the data matches the extracted
schema, we cannot expect the schema to be optimal from a semantic perspective. Datamod-
elling is an inherently human task, which relies on a broad knowledge of concepts and their
relations in the real world. Hence, we may want to reﬁne the extracted schema to our liking.
Furthermore, a schema may evolve over time as data sources and requirements change.
Besides schema extraction and reﬁnement, we also want to facilitate exploration of an existing
PG schema. This is essential when trying to understand a schema as a whole, and when
deciding how to change it. To this end, we employ a graph visualization method which brings
numerous cognitive beneﬁts, such as enhancing pattern detection, ability to examine a large
amount of information, and providing an abstract view of the data by omitting details [4].
To tackle this challenge, a team of three members was formed. To start, Bei Li∗is interested
in all work around schema extraction and commonly works with knowledge graphs. Next,
we have George Fletcher†, who is a researcher and professor interested in query languages
and graph databases. Finally, Nimo Beeren† is a master student in Computer Science &
Engineering, with a focus on helping people build better software.
Furthermore, the
contribution of experts, whom are introduced in Section 2, was invaluable in the realization
of this project.
The contributions of this work are:
• A written report of 7 interviews with 4 experts in the domain of property graph
schema.
• A set of informal requirements for a tool designed to facilitate schema extraction and
reﬁnement, inspired by the interviews.
• A UI prototype following the design requirements.
The rest of this document is structured as follows. In Section 2, the key insights from
interviews with domain experts are described. In Section 3, a prioritized list of requirements
is established. In Section 4, the UI prototype is shown, its views are linked to requirements.
In Section 5, we reﬂect together with the experts on the design choices. Section 6 concludes
the paper.
2
Interviews
To determine how a visual schema extraction tool could work in the real world, we conducted
interviews with four experts from industry. Following a convenience sampling strategy,
members of the PGSWG were approached and asked to participate. The interviews were
unstructured and informal in nature, with the focus on generating hypotheses and exploring
ideas. This section is based on the author’s interpretation, and does not necessarily represent
the opinions of the interviewee or the company they work for. A list of all interviews and
the dates they took place is given in Appendix A.
2.1
Dušan Živković
After decades of work and numerous jobs with organisations in the ﬁnance industry, Dušan is
currently an architect at Thought Machine4. While his current engagement revolves around
a relational database as a foundation, he uses graphs to model systems conceptually.
∗Bei is currently associated with Google.
†George and Nimo are currently associated with Eindhoven University of Technology.
4https://thoughtmachine.net/
2

---

In Dušan’s experience across the industry, the presence of a solid structure in data is anything
but guaranteed. Many datasets are only partially documented, and the accuracy and detail
of this documentation is often suboptimal. Furthermore, documentation that may once have
been accurate, can fall victim to the eﬀects of ad-hoc schema changes. As an example, Dušan
explains the concept of semantic drift, where the usage and semantics of a data attribute
change over time, while documentation is not updated.
The lack of documentation, such as schemas, can be explained by the current culture in data
management. In practice, the typical approach is application-ﬁrst, rather than knowledge-
ﬁrst. Data is often wrangled into a shape that ﬁts a particular purpose, at the cost of reusability.
This gives rise to a critical pain point: having an information need, how does one produce a
suitable query?
Focusing on graph databases, we discuss how they are diﬀerent from relational databases. In
Dušan’s work, the ability to execute graph traversal queries is one of the main advantages of
graph databases. The graph data model allows modeling causal relationships, which is not
really possible in the relational model. This is particularly useful when modeling processes.
Even though data is often stored in relational databases, Dušan explains that he often
combines relational data with graphs. In particular, he uses a graph to model dependencies
between tables. These may be functional dependencies or ordering-dependencies, for example.
In a functional dependency, one or more attributes functionally determine another attribute.
In ordering-dependency, events depend on one another, sometimes as a simple one-after-
another sequence, but more often in form of complex directed acyclic graphs.
When prompted, Dušan agrees that visualizing a graph schema may be useful. However, most
visualizations don’t scale; any suﬃciently complex schema quickly becomes overwhelming
when visualized all at once. In practice, most of the time people are interested in only a
small part of the graph, or how to “get from one place to another”. This idea is not limited to
schema graphs, but could also apply to a data graph. The question is then what elements of
the graph to show or hide? There is a trade-oﬀbetween simplicity and completeness, where
showing too much can make it too hard to understand the graph at a glance, and showing
too little may require too much ‘drilling down’. To make the right compromise, a user study
would be very valuable.
2.2
Victor Lee
When it comes to hands-on experience with property graph schemas, Victor is a prime
candidate to interview. He works at TigerGraph5, which is a company that takes a schema-
ﬁrst approach to property graph databases. This allows them to improve performance and
scalability, as long as the data has a well-deﬁned structure. Hence, TigerGraph customers
could beneﬁt from a tool that helps with discovering such a structure.
Victor mentioned that many people who are getting started with TigerGraph already have
data in a relational database that they want to use. For this use case, TigerGraph oﬀers
a migration tool that allows mapping a relational schema to a property graph schema.
This procedure creates a schema mapping from tables to nodes, and from columns to node
properties. Afterwards, the data can be loaded directly into TigerGraph.
Considering schema extraction, a similar workﬂow could be imagined. The main diﬀerence
is that the relational migration procedure depends on a predeﬁned structure in the form of a
relational schema, while the goal of schema extraction is to produce a schema given only data.
However, neither of these two approaches can be expected to produce a perfect schema in
5https://tigergraph.com/
3

---

all situations. Therefore, it may be desirable to reﬁne the initially generated schema through
human intervention.
Some common schema reﬁnement tasks were identiﬁed, starting with basic operations such as
adding and removing nodes and edges. Furthermore, the direction of edges may be changed,
or we may choose to add reverse edges. Depending on the graph DB implementation, the
direction of edges may determine the types of queries that are supported, e.g. it may not be
possible to execute a traversal query from edge target to the source.
Furthermore, it may be useful to merge two types into one, especially when data is gathered
from multiple sources, as there may be overlapping or redundant types. Conversely, a single
type can be split into two. To illustrate the usefulness of splitting types, consider a Person
node type with an optional property parkingSpot. From an ontological perspective, it
may be desirable to split Person into an Employee with a required parkingSpot,
and a Guest without a parkingSpot.
Other reﬁnement tasks include escalating a property to a node type, which would make
certain traversal queries easier. For example, we could ﬁnd all pairs of entities associated
with the same property value (when this property is escalated to a node). However, when
many entities are associated with the same property value (as is often the case with nominal
data types), a performance penalty may be incurred when escalating this property to a node.
2.3
Juan Sequeda
Juan works at data.world6, where he concerns himself with data cataloging, knowledge
graphs, and facilitating collaboration around data. One of the products he worked on is
Grafo7, a design tool for knowledge graphs.
To start the discussion, we talked about what makes schemas valuable in general. The
answer depends largely on who you ask. A data engineer may be interested in the physical
implementation of the schema, with the purpose of optimizing query eﬃciency. In contrast, a
data scientist may be more interested in using the schema to express data analysis tasks in the
form of queries. Furthermore, the role of knowledge scientist [8] was identiﬁed as someone
who takes responsibility for the usability and reliability of data, by means of maintaining
schemas, data cataloging, and creating data integration mappings [9]. These three personas
are summarized in Table 1.
The sentiment that organizations are often too application-focused is also reﬂected by Juan.
Instead, we should take a knowledge-ﬁrst approach, prioritizing quality of data. In this sense,
a schema is a primary form of knowledge. Related is the emerging discipline of DataOps [7],
which aims to improve quality of data and the processes around it. Again, the ultimate goal
of these practices is to enable people to get the information they want from a database, as
quickly as possible.
This is one of the goals Grafo aims to reach. Juan describes Grafo as an ontology editor, which
allows people to document the structure of their knowledge graph, as well as mapping data
sources to entities in the graph. Grafo supports both RDF and property graph representations,
allowing the user to add concepts (nodes), relationships (edges), attributes (properties),
and specializations (subtype relationships). Relational data sources can be mapped to the
knowledge graph, but this must be done manually by selecting tables or columns from the
relational schema.
6https://data.world/
7https://gra.fo/
4

---

When discussing schema extraction, Juan was not immediately convinced of the value. He
stressed that it should be veriﬁed that an extracted schema indeed helps people to ﬁnd what
they are looking for with less eﬀort. An experiment could be conducted to test the time it
takes people to come up with a correct query to answer a particular question. In any case, it
is clear that a study on the practical value of schema extraction must include real users.
While schema extraction could be used to generate a schema where there previously was
none, it could also be interesting to use schema extraction to reﬁne an existing schema. This
could be useful when the existing schema is incomplete or outdated. Of course, no schema is
perfect, and determining which schema is better is a diﬃcult and very human task. To aid in
this task, Juan suggests building some sort of diﬀbetween two schemas, showing in what
ways these schemas are diﬀerent.
Persona
Description
Data engineer
Interested in the physical implementation of the schema,
optimizing query eﬃciency.
Data scientist
Interested in using the schema to express data analysis
tasks in the form of queries.
Knowledge scientist
Takes responsibility for the usability and reliability of
data, by means of maintaining schemas, data cataloging,
and creating data integration mappings.
Table 1: The three personas that were identiﬁed during the interview with Juan.
2.4
Joshua Shinavier
Joshua currently works at LinkedIn8, and previously lead the data standardization eﬀort at
Uber9. His expertise lies in the ﬁeld of graph data management, and knowledge graphs.
We ﬁrst discussed why the decision to standardize data was made at Uber. The main problem
was that the datasets that were being used all had their own versions of common concepts,
such as driver or trip. This made it diﬃcult to maintain the company-wide knowledge graph,
especially when introducing new data sources. Every time a new data source was added, it
took considerable eﬀort to map the original data schema to the knowledge graph schema.
This became the bottleneck of the process, so they set out to unify the schemas of all data in
use at the company.
As we also found in other interviews, the vast majority of datasets being used in knowl-
edge graphs are not graph data. Commonly, data is stored in relational databases, or in a
schemaless format such as JSON. It is notable that at Uber, nearly all datasets had some
well-deﬁned structure as well as globally unique entity identiﬁers. This was very valuable in
the standardization process, but as we found, not all organizations are in the same situation.
We also touched on the topic of schema evolution. In Joshua’s experience, it was very
common for schemas to change over time. To keep track of schema history, the schema ﬁles
were often checked in to a version control system such as Git. Before a schema change is
published, a number of checks are performed to ensure the changes are backwards compatible.
This is essential for them, because many services depend on the existing schema.
The rules for backwards compatibility limit what kinds of changes can be made to the graph
8https://linkedin.com/
9https://uber.com/
5

---

schema. In general, we can only add things, not remove them. This means that many of the
schema reﬁnement functions that we identiﬁed earlier would violate the rules. However,
we should consider the use case here. On the one hand, for an existing system running
in production, backwards compatibility is often of importance. On the other hand, when
creating an initial schema from scratch, or when the entire data stack is restructured, these
rules may not be relevant.
It can be very useful to see how a schema evolved over time. This could be done by viewing
a diﬀbetween two diﬀerent versions of the schema. This diﬀcould be visual, for example
by showing a graph where nodes and edges are green when they are added, and red when
they are removed. This approach may be useful for speciﬁc types of changes such as adding
nodes or changing labels, but Joshua warns that not all types of changes are easy to represent
visually. For example, displaying all properties that were changed may produce a view that
is too cluttered to be useful.
As a more general solution to the schema diﬀproblem, Joshua suggests creating a semantic diﬀ.
Instead of displaying changes as visual graph elements, we describe the changes using natural
language, for example ‘Added node Employee’ or ‘Changed property type Person.age
from string to integer’. Such a diﬀis both easy to parse by humans (like a visual diﬀ),
and scalable (like a line-by-line text diﬀ).
3
Design Requirements
Using the insights obtained from the interviews, we now establish a set of design require-
ments using the MoSCoW method [5] for prioritization. Requirements are linked to the
interview that inspired them, although not all requirements were explicitly discussed during
the interviews. Furthermore, the requirements M1 and M8 were established by the team,
independently from the interviews.
Note: these requirements are further discussed in Section 5, which resulted in a change of priority
for some requirements. For a summary of the changes, see Table 3.
Must have
M1. Extract a PG schema given a PG database instance. — Bei/George/Nimo
M2. Visualize the schema graph. — All
M3. Display the schema in textual form. — Joshua
M4. Add/remove a node to/from the schema graph. — Victor/Juan
M5. Add/remove an edge to/from the schema graph. — Victor/Juan
M6. Add/remove a property to/from the schema graph. — Victor/Juan
M7. Set the data type of a property. — Victor/Juan
M8. Save the schema. — Bei/George/Nimo
Should have
S1. Indicate the relation between the visual and textual representation of the schema graph.
— Joshua
S2. Modify a PG schema in textual form. — Joshua
6

---

S3. Display a visual diﬀbetween two PG schemas. — Joshua/Juan
S4. Display a semantic diﬀbetween two PG schemas. — Joshua/Juan
S5. Merge any pair of nodes. — Victor
S6. Merge any pair of edges. — Victor
S7. Duplicate a node. — Victor
S8. Duplicate an edge. — Victor
S9. Set the direction of an edge. — Victor
Could have
C1. Expand schema nodes one by one. — Dušan
C2. Prevent backwards-incompatible schema changes when desired by the user. — Joshua
C3. Set the cardinality of edge types. — Victor
C4. Escalate a property to a node. — Victor
C5. Visualize sub/supertype relations. — Victor
Won’t have
W1. Mutate data to conform to schema changes.
W2. Map data sources to the PG schema.
W3. Add an edge in the reverse direction for a speciﬁed directed edge in the schema. —
Victor
7

---

4
UI Design
Using the established design requirements as a guideline, a UI prototype was designed. The
prototype consists of four screens: Extract, Edit schema, History, and Export. The relationships
between screens and requirements are shown in Table 2.
Screen
Requirements
Extract
M1
Edit schema
M2, M3, M4, M5, M6, M7, S1, S2, S5, S6, S7, S8, S9,
C2, C5
History
M2, M3, S3, S4, C5
Export
M8
Unmet requirements
C1, C3, C4, W1, W2, W3
Table 2: Mapping from screens in the UI prototype to the requirements they cover.
8

---

Figure 1: The Extract screen allows connecting to a database instance and start schema extraction.
9

---

Figure 2: On the Edit schema screen, the current schema can be reﬁned. When a schema element is selected, the
relationship between textual and visual representation of the schema is shown by a colored outline. The schema can be
modiﬁed by typing in the text view, or using the buttons in the visual view. Backwards-incompatible changes can be
prevented using a checkbox.
10

---

Figure 3: On the History screen, two versions of the schema can be compared. After selecting the versions to compare, a
diﬀview is shown. A switch allows toggling between the semantic and raw text view of the schema.
11

---

Figure 4: On the Export screen, the current schema can be saved to a ﬁle.
12

---

5
Discussion
After establishing the design requirements and designing the UI prototype, the experts were
invited again to discuss the results. The setup of these interviews was similar to the ﬁrst
round. This time, we only talked with Dušan, Victor, and Juan.
5.1
Schema reﬁnement
The feature that was most universally liked was the possibility to read and modify the schema
in textual form (Req. M3, S2). The main advantage of this approach is that it exposes the
deﬁnitive source of truth to the user. After all, the schema text is what is used by other
applications, while the visual representation is only useful for humans. Another advantage
is that it is easy to search through text by simply matching substrings (i.e. the well-known
Ctrl+F). However, in this way we lose the semantics of the schema, making it impossible
to discern node and property names, for example. Finally, the possibility to use common text
manipulation methods such as copy/paste was appreciated.
Further discussion of the visual schema editor lead to some feedback on the merge operation
(Req. S5, S6). It was not completely clear when this operation would be useful. Most experts
indicated that they had not felt the need for this operation when they were doing schema
design. However, when using a schema extraction algorithm, a situation could arise where a
single entity was mistakenly identiﬁed as two diﬀerent entities. But even in this context,
the need for a merge operation seemed small enough to lower the requirement priority to
Could have.
When explaining what the merge operation should actually do, it became clear there are
actually multiple ways in which it could be interpreted. Indeed, the requirement does not
precisely specify what the result of a merge should be. In type systems, we often distinguish
between a type union and intersection. The original thought behind the merge operation was
to do a union, i.e. combine properties from both types to create a type that allows all of those
properties. As discussed, the usefulness of this operation seems limited. However, creating
an intersection type may be useful in a diﬀerent way. For example, we may wish to create a
maximal supertype of a set of types, which is exactly what the intersection operation does.
To summarize this point, the merge operation could be split into a union and intersection,
though both would be relatively low-priority features.
5.2
Visualization
Regarding the visualization of the schema graph, feedback was mostly neutral because there
are no really novel features. One feature that did spark a discussion was the possibility to
expand schema nodes (Req. C1). First of all, it was not clear what this means. The original
motivation for this requirement was to make it easier to navigate and explore large graphs.
The idea was to avoid visual clutter by hiding most of the graph initially, and then allowing
the user to select a node, after which its neighborhood would be shown.
A question that arose was about which schema elements to show initially. A possible solution
would be to ﬁnd a node or group of nodes that are somehow important, which could be
achieved using a measure of centrality [3], for example. Another option would be to show
everything by default, but let the user partition the schema into modules, i.e. subgraphs
which could be hidden or expanded at will (this is what Grafo does).
While this kind of user customization may be nice, it may only be useful in very speciﬁc
cases. The experts agreed that in their experience, even the larger schemas only have around
100 nodes. While this is too large to make sense of when shown all at once, simple zooming
13

---

and panning controls would be suﬃcient to explore the schema. Hence, we could consider
demoting this requirement to Won’t have.
Finally, some improvement points regarding the user experience of the visual diﬀviewer
were discussed. While the design uses green and red coloring to distinguish added and
removed elements, this may not work for people who are not able to distinguish these colors
well. A simple solution would be to add symbols like + or - to the visual diﬀ, similar to the
text diﬀ. This would improve accessibility and usability for many people.
5.3
Future work
We now have a list of design requirements and a UI prototype based on them. We should
keep in mind that the experts we interviewed were sampled from a single group (PGSWG),
and this sample is not necessarily representative of all people who may beneﬁt from a schema
extraction tool. In future work, more interviews could be conducted to reach other target
groups, such as application developers, data scientists, and anyone else who is concerned
with schema design.
Furthermore, it is important to realize that the hypotheses presented in this work have not
been validated outside the expert interviews. To increase conﬁdence in the validity of the
results, a user study could be done. This way, the impact of the tool could be quantiﬁed, by
measuring e.g. the time it takes a user to produce a satisfactory schema for a given property
graph instance.
5.4
Summary
As a result of this discussion, the priority of some requirements was changed. These changes
are summarized in Table 3.
Requirements
Old priority
New priority
S5, S6
Should have
Could have
C1
Could have
Won’t have
Table 3: Requirements which had their priority changed as a result of the discussion.
In addition, the following opportunities for improvement were found:
• The merge operation could be split into two operations: union and intersection.
• The visual diﬀviewer could be made more accessible.
6
Conclusion
We investigated if and how schema extraction methods for property graphs could be applied
to provide value. By talking to experts, we found that one of the main problems when
working with data lies in producing a query for a particular question about data, though a
schema can make this much easier. Given that graph data often lacks a complete schema, we
see schema extraction as a potentially valuable tool.
We created design requirements and a UI prototype, which received encouraging reactions
from experts. Most of the features were not directly related to schema extraction, but
instead focused on reﬁning an existing (extracted) schema. We found that textual and
visual representations of the schema can be combined to enable easy exploration as well
14

---

as manipulation. Furthermore, we identiﬁed some common operations on schema graphs.
Finally, we found that a simple graph visualization was deemed suﬃcient to explore the
schema in most cases.
Our results may stimulate future work on the design, implementation, and analysis of schema
extraction tools. The world of graph data management is evolving quickly, and we believe
that more tools around graph schema are necessary to meet the needs of data engineers,
data scientists, and knowledge scientists everywhere.
15

---

A
Interview Dates
Interviewee
Date
Dušan Živković
30-09-2021
Victor Lee
04-10-2021
Juan Sequeda
06-10-2021
Joshua Shinavier
15-10-2021
Victor Lee
12-11-2021
Juan Sequeda
12-11-2021
Dušan Živković
12-11-2021
Table 4: The list of interviews with the date they took place.
16

---

References
[1] Bradley R Bebee, Daniel Choi, Ankit Gupta, Andi Gutmans, et al.
Amazon Nep-
tune: Graph data management in the cloud. In International Semantic Web Conference
(P&D/Industry/BlueSky), 2018.
[2] Angela Bonifati, George Fletcher, Hannes Voigt, and Nikolay Yakovets. Querying graphs.
Morgan & Claypool Publishers, 2018.
[3] Stephen P Borgatti, Martin G Everett, and Jeﬀrey C Johnson. Analyzing social networks.
Sage, 2018.
[4] Stuart K Card, Jock D Mackinlay, and Ben Shneiderman. Information visualization.
Readings in information visualization: using vision to think, pages 1–34, 1999.
[5] Dai Clegg and Richard Barker. Case Method Fast-Track: A Rad Approach. Addison-Wesley
Longman Publishing Co., Inc., USA, 1994.
[6] Alin Deutsch, Yu Xu, Mingxi Wu, and Victor E. Lee. TigerGraph: A native MPP graph
database. CoRR, abs/1901.08248, 2019.
[7] Julian Ereth. DataOps – Towards a deﬁnition. LWDA, 2191:104–112, 2018.
[8] George Fletcher, Paul Groth, and Juan F. Sequeda. Knowledge scientists: Unlocking the
data-driven organization. CoRR, abs/2004.07917, 2020.
[9] George Fletcher and Catharine M Wyss. Towards a general framework for eﬀective
solutions to the data mapping problem. In Journal on Data Semantics XIV, pages 37–73.
Springer, 2009.
[10] Hanâ Lbath, Angela Bonifati, and Russ Harmer. Schema inference for property graphs.
EDBT, 24:499–504, 2020.
[11] Xue Lei. Property graph schema extraction. Master’s thesis, Eindhoven University of
Technology, 2021.
17

---

