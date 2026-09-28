# The SeaLiT Ontology -- An Extension of CIDOC-CRM for the Modeling and Integratio

> 来源: https://arxiv.org/pdf/2301.04493

The SeaLiT Ontology – An Extension of CIDOC-CRM for the
Modeling and Integration of Maritime History Information
PAVLOS FAFALIOS, ATHINA KRITSOTAKI, and MARTIN DOERR, Centre for Cultural Informatics
and Information Systems Laboratory, FORTH-ICS, Greece
We describe the construction and use of the SeaLiT Ontology, an extension of the ISO standard CIDOC-CRM for the modelling
and integration of maritime history information. The ontology has been developed gradually, following a bottom-up approach
that required the analysis of large amounts of real primary data (archival material) as well as knowledge and validation by
domain experts (maritime historians). We present the specification of the ontology, RDFS and OWL implementations, as well
as knowledge graphs that make use of this data model for integrating information originating from a large and diverse set of
archival documents, such as crew lists, sailors registers, naval ship registers and payrolls. We also describe an application
that operates over these knowledge graphs and which supports historians in exploring and quantitatively analysing the
integrated data through a user-friendly interface. Finally, we discuss aspects related to the use, evolution and sustainability of
the ontology.
CCS Concepts: • Computing methodologies →Ontology engineering; • Information systems →Ontologies; Infor-
mation integration; Digital libraries and archives; Semantic web description languages.
Additional Key Words and Phrases: Ontologies, Maritime History, CIDOC-CRM, Data Integration, Semantic Interoperability
1
INTRODUCTION
Maritime history is the study of human activity at sea. It covers a broad thematic element of history, focusing
on understanding humankind’s various relationships to the oceans, seas, and major waterways of the globe [7].
A large area of research in this field requires the collection and integration of data coming from multiple and
diverse historical sources, in order to perform qualitative and quantitative analysis of empirical facts and draw
conclusions on possible impact factors [5, 16].
Consider, for instance, the real use case of the SeaLiT project (ERC Starting Grant in the field of maritime
history)1, which studies the transition from sail to steam navigation and its effects on seafaring populations
in the Mediterranean and the Black Sea between the 1850s and the 1920s [2]. Historians in this project have
collected a large number of archival documents of different types and languages, including crew lists, payrolls,
sailor registers, naval ship register lists, and employment records, gathered from multiple authorities in different
countries (more about this project in Sect. 2.1). Complementary information about the same entity of interest,
such as a ship, a port, or a captain, may exist in different archival documents. For example, for the same ship,
one source may provide information about its owners, another source may provide construction details and
characteristics of the ship (length, width, tonnage, horsepower, etc.), while other sources may provide information
about the ship’s voyages and crew.
Information integration is crucial in this context for performing valid data analysis and drawing safe conclusions,
such as finding answers to questions that require combining and aggregating information, like “finding the number
of sailors per residence location that arrived at a specific port and who were crew members in ships of a specific type,
e.g. Brig”. Moreover, information integration under a common data model can produce data of high value and
long-term validity that can be reused beyond a particular research activity or project, as well as integrated with
other datasets by the wider (historical science) community.
1https://sealitproject.eu/
Authors’ address: Pavlos Fafalios, fafalios@ics.forth.gr; Athina Kritsotaki, athinak@ics.forth.gr; Martin Doerr, martin@ics.forth.gr, Centre
for Cultural Informatics and Information Systems Laboratory, FORTH-ICS, N. Plastira 100, Heraklion, Greece, GR-70013.
ACM J. Comput. Cult. Herit., Vol. -, No. -, Article . Publication date: January 2022.
arXiv:2301.04493v1  [cs.DB]  11 Jan 2023

---

2
•
Pavlos Fafalios, Athina Kritsotaki, and Martin Doerr
To this end, this paper describes the construction and use of the SeaLiT Ontology. The ontology aims at
facilitating a shared understanding of maritime history information by providing a common and extensible
semantic framework for information modeling and integration. It uses and extends the CIDOC Conceptual
Reference Model (CRM) (ISO 21127:2014)2 as a formal ontology of human activity, things and events happening
in space and time [3].
The ontology was designed considering requirements and knowledge of domain experts (a large group of
maritime historians), expressed through research needs, inference processes they follow, and exceptions they
make. It was developed in a bottom-up manner by analysing large and heterogeneous amounts of primary data,
in particular archival documents of different types and languages gathered from authorities in several countries,
including crew lists, payrolls, civil registers, sailor registers, naval ship registers, employments records, censuses,
and others. All modeling decisions were validated by the domain experts and, in practice, by transforming their
data (transcripts) to a rich semantic network based on the SeaLiT Ontology, which enables them (through a
user-friendly interface) to find answers to information needs that require combining information of different
sources.
We describe the methodology and the steps we followed for designing the ontology, and provide its specification,
RDFS and OWL implementations, as well as knowledge graphs that make use of the ontology for integrating data
transcribed from a large and diverse set of archival documents. We also describe a data exploration application
that operates over these knowledge graphs and which currently supports maritime historians in exploring and
analysing the integrated data.
Table 1 provides the key access links to the SeaLiT Ontology as well as related resources and information.
Table 1. Key access links and information of the SeaLiT Ontology.
SeaLiT Ontology Specification
https://zenodo.org/record/6797750
DOI of the SeaLiT Ontology
10.5281/zenodo.6797750
Namespace of the SeaLiT Ontology
http://www.sealitproject.eu/ontology/
SeaLiT Ontology RDFS (Turtle)
https://sealitproject.eu/ontology/SeaLiT_Ontology_v1.1_RDFS.ttl
SeaLiT Ontology RDFS (RDF/XML)
https://sealitproject.eu/ontology/SeaLiT_Ontology_v1.1_RDFS.rdf
SeaLiT Ontology OWL (RDF/XML)
https://sealitproject.eu/ontology/SeaLiT_Ontology_v1.1.owl
SeaLiT Knowledge Graphs (KGs)
https://zenodo.org/record/6460841
DOI of SeaLiT KGs
10.5281/zenodo.6460841
ResearchSpace application over the KGs
http://rs.sealitproject.eu/
License of SeaLiT Ontology & KGs
Creative Commons Attribution 4.0
The rest of this paper is organised as follows: Section 2 describes the context of this work, provides the required
background, and discusses related work. Section 3 details the methodology and principles we have followed for
building the ontology. Section 4 presents the ontology, describes an example on how a part of the model was
revised several times to incorporate new historical knowledge, and provides its specification as well as an RDFS
and an OWL implementation. Section 5 describes the application of the ontology in a real context. Section 6
discusses its usage and sustainability. Finally, Section 7 concludes the paper and outlines future work.
2https://cidoc-crm.org/
ACM J. Comput. Cult. Herit., Vol. -, No. -, Article . Publication date: January 2022.

---

The SeaLiT Ontology
•
3
2
CONTEXT, BACKGROUND AND RELATED WORK
2.1
The SeaLiT Project
The ontology has been developed in the context of the SeaLiT project3, a European project in the field of maritime
history (ERC Starting Grant, No 714437). The project studies the transition from sail to steam navigation and
its effects on seafaring populations in the Mediterranean and the Black Sea between the 1850s and the 1920s.
Historians in SeaLiT investigate the maritime labour market, the evolving relations among ship-owners, captain,
crew, and local societies, and the development of new business strategies, trade routes, and navigation patterns,
during the transitional period from sail to steam. The main concepts on which the scientific research focuses,
are the ships (including various information such as type, usage, dimensions, technology), the people related to
the ships (sailors, ship owners, students, relatives) and the historical events/activities related to these (such as
voyages, recruitments, payments).
The archival sources considered and studied in SeaLiT range from hand written ship log books, crew lists,
payrolls and employment records, to registers of different types such as civil, sailors, students and naval ship
registers. These archival sources have been gathered from different authorities in countries of the Mediterranean
and the Black Sea, and are written in different languages, including Spanish, Italian, French, Russian, and Greek.
The full archival corpus studied in SeaLiT is described in the project’s web site.4
2.2
The ISO standard CIDOC-CRM
The SeaLiT Ontology uses and extends the CIDOC-CRM (Conceptual Reference Model)5, in particular its stable
version 7.1.1, which means that each class of the SeaLiT Ontology is a direct subclass or a descendant of a
CIDOC-CRM class.
CIDOC-CRM is a high-level, event-centric ontology of human activity, things and events happening in
spacetime, providing definitions and a formal structure for describing the implicit and explicit concepts and
relationships used in cultural heritage documentation [3]. It is the international standard (ISO 21127:2014)6 for
the controlled exchange of cultural heritage information, intended to be used as a common language for domain
experts and implementers to formulate requirements for information systems, providing a way to integrate
cultural heritage information of different sources.
The considered stable release of CIDOC-CRM (version 7.1.1) consists of 81 classes and 160 unique properties.
The highest-level distinction in CIDOC-CRM is represented by the top-level concepts of E77 Persistent Item
(equivalent to the philosophical notion of endurant), E2 Temporal Entity (equivalent to the philosophical
notion of perdurant) and, further, the concept of E92 Spacetime Volume which describes the entities whose
substance has or is an identifiable, confined geometrical extent in the material world that may vary over time.
Fig. 1 depicts how the high level classes of CIDOC-CRM are connected.
2.3
Related Work
Over the last years, methods and technologies of the Semantic Web have started playing a significant and
ever increasing role in historical research. The survey in [13] reviews the state of the art in the application of
semantic technologies to historical research, in particular works related to i) knowledge modeling (ontologies,
data linking), ii) text processing and mining, iii) search and retrieval, and iv) semantic interoperability (data
integration, classification systems).
3https://sealitproject.eu/
4https://sealitproject.eu/archival-corpus
5http://www.cidoc-crm.org/
6https://www.iso.org/standard/57832.html
ACM J. Comput. Cult. Herit., Vol. -, No. -, Article . Publication date: January 2022.

---

4
•
Pavlos Fafalios, Athina Kritsotaki, and Martin Doerr
Fig. 1. High level properties and classes of CIDOC-CRM.
As regards ontologies for the modeling of maritime history information, the most relevant work is an ongoing
project on the ontology management environment OntoME [1] that aims to provide a data model for the field of
maritime/nautical history.7 The project is a cooperation between the Huygens Institute for the History of the
Netherlands, LARHRA and the Data for History consortium. The current (draft) model consists of 13 classes
and 12 properties, while it makes use of CIDOC-CRM as well as extensions of CIDOC-CRM. The ontology is
unfinished and not for use yet (as of December 15, 2022).
Conflict8 is an ontology developed in the context of the SAILS project (2010-2013)9 that models concepts
useful for describing the First World War. The provided ontology version (0.1) is actually a taxonomy consisting
of 175 classes, some of which allow modeling information related to maritime history, like the classes Ship,
Ship_journey, Ship_type, and Ownership. Similarly, there are ontologies that could be used for modeling other
parts of the model, such as GoodRelations [8], a lightweight ontology for exchanging e-commerce information,
for the part that concerns payments for products.
We selected to use CIDOC-CRM because it is the standard ontology for cultural heritage documentation,
extensively used in the fields of cultural heritage, history and archaeology. It is directly related to the domain of
discourse of history, as a discipline that studies the life of humans and societies in the past. This scope, studied
from the point of view of maritime historical research, can be represented by the abstraction of reality offered
by CIDOC-CRM. As an example, we can directly take advantage of the (direct or inherited) properties of the
CIDOC-CRM class E7 Activity, such as ‘P14 carried out by’, ‘P4 has time-span’, ‘P7 took place at’, etc., and use
them for describing instances of classes of the SeaLiT Ontology that are subclasses of E7 Activity (e.g. Voyage,
Arrival, Recruitment, etc.). Therefore, using CIDOC-CRM facilitates data integration with relevant (existing or
future) datasets that also make use of CIDOC-CRM, but also it enables data sustainability because CIDOC-CRM
is a living standard and has a very active community that constantly works on it and improves it.
Finally, there is a plethora of ontologies which have been developed as extensions of CIDOC-CRM, e.g.
CRMas [14] for documenting archaeological science, CRMgeo [9] for geospatial information, CRMdig [18] for
provenance of digital objects, IAM [4] for factual argumentation, and others.
7https://ontome.net/namespace/66
8http://ontologies.michelepasin.org/docs/conflict/index.html
9http://sailsproject.cerch.kcl.ac.uk/
ACM J. Comput. Cult. Herit., Vol. -, No. -, Article . Publication date: January 2022.

---

The SeaLiT Ontology
•
5
3
DESIGN METHODOLOGY AND PRINCIPLES
3.1
Overall Methodology
The ontology has been created gradually, following a bottom-up strategy [6], working with real empirical data
and information needs, in particular digitised historical records (transcripts) and corresponding data structures
in various forms, as well as research questions provided by a large group of historians. The archival material
together with the research questions define the modeling requirements.
The main characteristics of our strategy are summarised as follows:
• Study and analysis of a large and diverse set of archival sources related to maritime history. This material
provides historical information about ships, persons (such as sailors, captains, ship owners, students), and
relevant activities and events (such as voyages, recruitments, payments, teaching activities).
• Gathering of research questions and corresponding information needs (competency questions) for which
the considered archival sources can provide answers or important relevant information.
• Lengthy discussions with a large group of maritime historians from different institutions and countries
(Spain, Italy, France, Croatia, Greece), for consulting as well as understanding of inference processes and
exceptions they make.
In more detail, our approach focused on studying and analysing the historical sources from the historians
perspective, following their respective research questions and practices of documentation. In order to achieve
that, we had to consult all the data providers (coming from different research teams and countries) for a long
period and to do extensive research on their research practices and the historical data for the development and
the validation of the model. As a result, the model was designed from actual data values, from existing (and used)
structured information sources (such as spreadsheets) and historical records (transcripts) that include the original
information. The model’s concepts were refined several times during the span of the project for considering new
information coming from new kinds of sources. Table 2 provides the considered archival sources as well as an
overview of the recorded information and an example record (transcript) for each source.10
As regards the research questions and information needs provided by the historians, their majority concerns
aggregated information, such as number of sailors per origin location that arrived at a specific port, average
tonnage of ships, wage level per country, percentages of immigration in relation to the sailors’ profession, etc. Other
information needs concern the retrieval of a specific list of entities (e.g. ship construction places during a specific
time period), comparative information (e.g. time of sailors’ service in relation to the time on land, number of
women/men in ships, etc.), or the retrieval of a specific value (e.g. total number of officers employed by the company
in a specific year or span of years).11
For creating the ontology, we followed a custom engineering methodology [11] which, though, maintains most
of the features supported by existing methodologies, such as HCOME [10] and DILIGENT [17]. In particular:
• Data-driven / bottom-up processing (our strategy for the development of the ontology)
• Involvement of domain experts (maritime historians in our case)
• Iterative processing (gradual, highly-iterative ontology development)
• Collaborative engineering processing (within a small team of conceptual modeling experts)
• Validation and exploitation (validation by domain experts and application in a real context)
• Detailed versioning (multiple intermediate versions, currently in stable version 1.1)
10A web application that allows exploring the data in the transcripts of these archival sources is available at: https://catalogues.sealitproject.eu/
11The full list of information needs is available at https://users.ics.forth.gr/~fafalios/SeaLiT_Competency_Questions_InfoNeeds.pdf
ACM J. Comput. Cult. Herit., Vol. -, No. -, Article . Publication date: January 2022.

---

6
•
Pavlos Fafalios, Athina Kritsotaki, and Martin Doerr
Table 2. Considered archival sources and type of recorded information.
Archival source
Overview of recorded information and example transcript
Crew and displacement list (Roll)
ships (name, type, construction location, construction year, registry location, owners), ports of
provenance, arrival ports, destination ports, crew members (name, father’s name, birth place, resi-
dence location, profession, age), embarkation ports, discharge ports. [example transcript: https:
//tinyurl.com/4ukzezfe]
Crew List (Ruoli di Equipaggio)
ships (name, type, construction location, construction year, registry number, registry port, owners),
voyages (date from/to, duration, total crew number), destinations, departure ports, arrival ports, crew
members (name, residence location, birth year, serial number, profession), embarkation ports, dis-
charge ports. [example transcript: https://tinyurl.com/2u35frya]
General Spanish Crew List
ships (name, type, tonnage, registry port), ship owners, crew members (name, age, residence location),
voyages (date from/to, total crew number), embarkation ports, destinations. [example transcript:
https://tinyurl.com/3axs6ret]
Sailors Register (Libro de registro de
marineros)
seafarers (name, father’s name, mother’s name, birth date, birth place, profession, military service
organisation locations) [example transcript: https://tinyurl.com/2p8kzm6n]
Register of Maritime Personnel
persons (name, father’s name, mother’s name, birth place, birth date, residence location, marital
status, previous profession, military service organisation location). [example transcript: https:
//tinyurl.com/4v6hnwjj]
Seagoing Personnel
persons (name, father’s name, marital status, birth date, profession, end of service reason, work status
type), ships (name), destinations. [example transcript: https://tinyurl.com/2x5cu37n]
Naval Ship Register List
ships (name, type, tonnage, length, construction location, registration location, owner). [example
transcript: https://tinyurl.com/bdhx87tr]
List of Ships
ships (name, previous name, type, registry port, registry year, construction place, construction year,
tonnage, engine construction place, engine manufacturer, nominal power, indicated power, owners).
[example transcript: https://tinyurl.com/2cphfpef]
Civil Register
persons (name, profession, origin location, age, sex, marital status, death location, death reason, re-
lated persons). [example transcript: https://tinyurl.com/bdzeja8n]
Maritime Register, La Ciotat
persons (name, birth date, birth place, residence location, profession, service sector), embarkation
locations, disembarkation locations, ships (name, type, navigation type), captains, patrons. [example
transcript: https://tinyurl.com/fkhyyp4a]
Students Register
students (origin location, profession, employment company, religion, related persons), courses (title,
subject, date from/to, semester, total number of students). [example transcript: https://tinyurl.
com/mryp6cbb]
Census La Ciotat
occupants (name, age, birth year, birth place, nationality, marital status, religion, profession, working
organisation, household role, address). [example transcript: https://tinyurl.com/4dzfcbtt]
Census of the Russian Empire
occupants (name, patronymic, sex, age, marital status, estate, religion, native language, household
role, occupation, address). [example transcript: https://tinyurl.com/43xczvux]
Payroll (of Greek Ships)
ships (name, type, owners), captains, voyages (date from/to, total days, days at sea, days at port,
overall total wages, overall pension fund, overall net wage), persons (name, adult/child, literacy, ori-
gin location, professio/rank), employments (recruitment date, discharge date, recruitement location,
monthy wage, total wage, pension fund, net wage). [example transcript: https://tinyurl.com/
ztjk4jw7]
Payroll (of Russian Steam Navigation
and Trading Company)
ships (name, owners), persons (name, patronymic, adult/child, sex, birth date, estate, registration
place), recruitments (port, type of document, rank/specialisation, salary per month). [example tran-
script: https://tinyurl.com/y5urjhc9]
Employment
records
(Shipyards
of
Messageries Maritimes, La Ciotat)
workers (name, sex, birth year, birth place, residence location, marital status, profession, status of
service in company, workshop manager). [example transcript: https://tinyurl.com/yc3havkc]
Logbook
ships (name, type, telegraphic code, tonnage, registry port, owners), captains, departure ports, desti-
nation ports, route movements, calendar event types. [example transcript: https://tinyurl.com/
mrx2re9k]
Accounts Book
ships (name, type, owners), voyages, captains, departure ports, destination ports, ports of call, transac-
tions (type, recording location, supplier, mediator, receiver). [example transcript: https://tinyurl.
com/4uf3bye8]
ACM J. Comput. Cult. Herit., Vol. -, No. -, Article . Publication date: January 2022.

---

The SeaLiT Ontology
•
7
3.2
Design Steps and Principles
The basis for the model was CIDOC-CRM since it is a standard suitable for recording historical information
relating who, when, where, and what. From an ontological point of view, we followed the below steps:
(1) We have extended CIDOC-CRM by creating new classes as subclasses of CIDOC-CRM classes and defining
properties accordingly (with some of them being subproperties of CIDOC-CRM properties). After extending
or revising the model for a given type of archival source and corresponding information needs, we created
mappings for transforming the data from the source schema to a semantic network (RDF triples) based on
the designed (target) model. This conceptual alignment was an important step to the ontology development
process, contributing to redesign concepts and finalise the model.
(2) We distinguished the entities included in the existing schemata into those that directly or indirectly imply an
event and to those that imply objects, mobile or immobile, and classified them in abstraction levels according
to whether they represent individuals, or set of individuals. We realised that most binary relationships
acquire substance as temporal entities (e.g. has met, has created, etc.). This principle helped us to detect
hidden events in the data structures.
(3) We classified the existing relations between the entities according to the abstraction level which their
domain and range entity belong to, and created class and property hierarchies accordingly. We did not
define the same property twice for different classes, but found the most general (super)class that the
property applies to. The discovery of repeating properties for different classes, suggested that they rely on
a common, more general concept, causal to the ability to have such a relation in the first place. Finding the
single most general concept to describe this common generalization allowed the creation of a general class
to which the properties can be applied and from which these relations can be inherited by assigning the
originally modelled classes as subclasses of the newly created generalization (like in the case of classes
Money for Service and Legal Object Relationship).
(4) We found classes for the relevant properties, and not properties for relevant classes (e.g. Voyage for the
property ‘voyages’, Ship Construction for ‘constructed’, etc.). We detected the general classes for which
each property is characteristic of. In other terms, we found the one most specific class that generalizes over
all classes for which the property applies as domain or range.
(5) We defined concepts by finding the identity criteria of them, by distinguishing what is and what is not
an instance of these concepts. We identified classes that exist independent from the property, and not
“anything that has this property” (e.g. the case of the Service concept).
(6) The number of the classes and relationships developed can answer queries of global nature. By global
queries we mean those that users would address to more than one database (source) at the same time
in order to get a comprehensive answer, in particular including joins across databases. It should also
be emphasised that the goal was not to model ‘everything’ but rather to model the necessary and well
understood concepts for this specific domain.
The ontology was built following these principles. Its design and development was an iterative process with
several repetitions of the steps described above.
4
THE SEALIT ONTOLOGY
We first provide an overview of the ontology (Sect. 4.1), then we describe an ontology evolution example (Sect. 4.2),
and finally we present the specification of the ontology as well as RDFS and OWL implementations (Sect. 4.3).
4.1
Ontology Overview
The ontology currently (version 1.1) contains 46 classes, 79 properties and 4 properties of properties, allowing
the description of information about ships, ship voyages, seafaring people, employments and payments, teaching
ACM J. Comput. Cult. Herit., Vol. -, No. -, Article . Publication date: January 2022.

---

8
•
Pavlos Fafalios, Athina Kritsotaki, and Martin Doerr
Fig. 2. Modelling information about a ship.
activities, as well as a plethora of other related activities and characteristics. Appendices A and B provide the full
class and property hierarchy, respectively.
Fig. 2 shows how information about a ship is modelled.12 A Ship (subclass of E22 Human-Made Object) is the
result of a Ship Construction activity (subclass of E12 Production) which gave the Ship Name (subclass of
E41 Appellation) to the ship. A ship also has some characteristics, like Horsepower and Tonnage (subclasses of
E54 Dimension; this allows providing, apart from the value, the corresponding measurement unit, a note, etc.),
and is registered through a Ship Registration (subclass of E7 Activity) by a Port of Registry (subclass
of E74 Group), with a ship flag of a particular Country (subclass of E53 Place) and with a particular Ship ID
(subclass of E42 Identifier). Modeling the ship ID as a class allows including additional information about
the identifier, such as which authority provided the identifier, when, etc. (by connecting it to the CIDOC-CRM
class E15 Identifier Assignment). Finally, a ship has one or more Ship Ownership Phases (subclass of
Legal Object Relationship), each one initialized by a Ship Registration and terminated by a De-flagging
activity. Note here that, all classes related to activities (like Ship Construction, Ship Repair, De-flagging,
etc.) can make use of the CIDOC-CRM property ‘P4 has time-span’ for providing temporal information.
Fig. 3 shows how information about a ship voyage is modelled in the ontology. First, a Voyage (subclass of
E7 Activity) concerns a particular Ship, navigated by one or more captains (E39 Actor), and has a starting
from place, a destination place, and a finally arriving at place (E53 Place). Then, the main activities during a ship
voyage include Loading things, Leaving from a place, Passing by or through a place, Arrival at a place, and
12The classes whose name starts with the letter ’E’ followed by a number are CIDOC-CRM classes (these are in green boxes in the figures).
All other are classes of the SeaLiT Ontology (in blue boxes). Accordingly, all properties whose name starts with the letter ’P’ followed by a
number are properties of CIDOC-CRM, while all other are properties of the SeaLiT Ontology.
ACM J. Comput. Cult. Herit., Vol. -, No. -, Article . Publication date: January 2022.

---

The SeaLiT Ontology
•
9
Fig. 3. Modelling information about a ship voyage.
Unloading things. All these activities are linked to a E52 Time-Span through the CIDOC-CRM property ‘P4 has
time-span’.
Fig. 4 shows how the ontology allows describing information about employments and payments. Money for
Service (subclass of E7 Activity) is given to an E39 Actor for a particular Service (subclass of E7 Activity).13
The class Money for Service has two specialisations (subclasses): Money for Things and Money for Labour,
while the class Employment is a specialisation of the class Service. A Crew Payment concerns a particular Voyage
and is a specialisation of Money for Labour. In this context, a Labour Contract (subclass of E29 Design or
Procedure) specifies the conditions of Money for Labour. An Employment starts with a Recruitment (subclass
of E7 Activity) and ends with a Discharge (subclass of E7 Activity).
Fig. 5 shows how information about persons (seagoing people, such as captains, crew members, students, etc.)
is modelled in the ontology. A person (E21 Person) is registered through a Civil Registration activity and
receives an identifier (E42 Identifier). A person has a first name and last name (E62 String), works at an
organisation or company (E74 Group), has an age (E60 Number) at a specific time (the time of the information
recording), as well as a set of other properties, in particular a Religion Status, a Literacy Status, a Sex
Status, a Language Capacity, a Social Status, and a Profession (all subclasses of E55 Type). The use of
E55 Type as superclass of these properties/qualities (instead of modeling them as temporal entities) is a good
solution when the sources (such as a civil register or a census document) do not provide enough temporal
information to infer/observe the corresponding event (this is exactly the case with the archival sources of the
SeaLiT project). In addition, a Punishment (subclass of E7 Activity) or Promotion (subclass of E13 Attribute
13We use the term ‘money’ instead of ‘payment’, because we want to indicate that there was a money transaction, e.g. using lira, franc, etc.
(in older times, a payment could be conducted without the use of money, e.g. using things).
ACM J. Comput. Cult. Herit., Vol. -, No. -, Article . Publication date: January 2022.

---

10
•
Pavlos Fafalios, Athina Kritsotaki, and Martin Doerr
Fig. 4. Modelling information about employments and payments.
Fig. 5. Modelling information about persons.
Assignment) can be given to a person. A Promotion is related either to a Social Status promotion or to a
job/career (Profession) promotion.
Finally, Fig. 6 shows how the ontology allows describing information about teaching activities related to
seafaring. A Teaching Unit is an activity that can be specialised to Course or Section. It is connected to a
Subject (subclass of E55 Type), the students (E39 Actor) who participated in the teaching unit, the number
of participating students (E60 Number), as well as one or more other teaching units through the CIDOC-CRM
ACM J. Comput. Cult. Herit., Vol. -, No. -, Article . Publication date: January 2022.

---

The SeaLiT Ontology
•
11
Fig. 6. Modelling information about teaching activities.
property ‘P9 consists of’. The latter allows, in particular, describing the information that a course consists of
sections.
4.2
Ontology Evolution Example
The ontology development process lasted more than two years, including a large number of intermediate
versions, before releasing the first stable version (1.0). In particular, the ontology elements (classes and properties)
were revised several times based on (a) new evidence coming from newly-considered archival sources, and (b)
new requirements (information needs) by the domain experts (maritime historians). Such new evidence and
requirements required either the definition of new elements, such as the creation of a new class or property, or
the revision of an existing set of elements that concern a part of the model.
Fig. 7 shows how the part of the ontology that concerns ship ownership was revised several times during the
ontology development process.
A first requirement provided by the historians was the ability to find all ships per owner. The analysed archival
material (crew lists) only provided the name of the owner, where the value was either the name of a person or the
name of a company. Based on this evidence, the property ‘has owner’ was created connecting an instance of Ship
with the an instance of the CIDOC-CRM class E39 Actor (v1 in Fig. 7).
Another source (naval ship register lists) provided information about ships’ previous owners, while a new
requirement was the ability to find the number of first owners per ship during a period of time. Based on this, as
well as on the fact that the binary relationship has owner implies/hides a temporal entity, we defined the class
Ship Ownership Phase, the property ‘has phase’ for connecting a ship to a ship ownership phase, the property
‘in time’ for connecting the ownership phase to a E52 Time-Span, while the property ‘has owner’ was revised for
connecting the ship ownership phase with an E39 Actor (v2 in Fig. 7).
A ship can have many names during its lifespan, while an owner can own more than one ships with the same
name (as shown in logbooks and crew and displacement lists). According to the historians, ownership usually
assigns a name to a ship and a ship changes its name under a new ownership state at a specific time. Based on this
historical knowledge, the property ‘ownership under name’ was created for enabling to link the ship ownership
phase to a Ship Name (v3 in Fig. 7).
Evidence shows that ownership of a ship is a type of information that can be inferred and not directly
observed. An ownership phase can be traced by the ship registration activity that initiates it and by the de-flagging
activity that terminates it. The documentation of a ship registration in Austrian Lloyd’s fleet lists, in particular,
includes information about the ship’s construction place and date, which together with the name given to ship
after construction constitute safe criteria to identify a ship. Based on this, the classes Ship Registration
ACM J. Comput. Cult. Herit., Vol. -, No. -, Article . Publication date: January 2022.

---

12
•
Pavlos Fafalios, Athina Kritsotaki, and Martin Doerr
Fig. 7. Ontology evolution example for modeling ship ownership information.
(subclass of E72 Activity), De-flagging (subclass of E72 Activity) and Ship Construction (subclass of E12
Production) were defined, together with the properties ‘registers’ (for linking a registration activity to a ship),
‘ownership is initialized by’ (for linking an ownership phase to a registration activity), ‘de-flagging of’ (for linking
a de-flagging activity to a ship), ‘ownership is terminated by’ (for linking an ownership phase to a de-flagging
activity), ‘constructed’ (for linking a construction activity to a ship), and ‘under name’ (for linking a construction
activity to a ship name (v4 in Fig. 7).
The ownership of a ship is actually a legal agreement in which an owner holds shares. For example, according
to Italian sources (maritime registers), the ownership of a ship was structured in 24 parts (“carati”). Sometimes
only one ship owner possessed all 24 parts. However, much more frequently the 24 parts were distributed
among several ship owners. Based on this evidence, a new class Shareholding was created as a specialisation
(subclass) of Ship Ownership Phase, together with the property ‘of share’ for assigning the number of shares to
a shareholding phase (v5 in Fig. 7).
In the last ontology version (see Fig. 2), Ship Ownership Phase is defined as specialisation (subclass) of the
class Legal Object Relationship, together with the class Legal Document with Temporal Validity which
comprises official documents or legal agreements that are valid for a specific time-span. The more general class
Legal Object Relationship represents kinds of relationships whose state and time-span are not documented
and thus cannot be directly observed. We can only observe the relationship through the events that initialise or
terminate the state (starting and terminating events).
ACM J. Comput. Cult. Herit., Vol. -, No. -, Article . Publication date: January 2022.

---

The SeaLiT Ontology
•
13
4.3
Specification, RDFS and OWL Implementation
The specification of the ontology and its RDFS implementation are available through the Zenodo repository (DOI:
10.5281/zenodo.6797750)14, under a Creative Commons Attribution 4.0 license. The (resolvable) namespace of
the ontology pointing to the RDFS implementation is: http://www.sealitproject.eu/ontology/.
The specification document defines the ontology classes and properties. For each class, it provides: i) its
superclasses, ii) its subclasses (if any), iii) a scope note (a textual description of the class’s intension), iv) one or
more examples of instances of this class, and v) its properties (if any), each one represented by its name and
the range class that it links to. For each property, the specification provides: i) its domain, ii) its range, iii) its
superproperties (if any), iv) its subproperties (if any), v) a scope note, vi) one or more examples of instances of
this property, and vii) its properties (if any). If a property has an inverse property, this is provided in parentheses
next to the property name. Scope notes are not formal modelling constructs, but are provided to help explain the
intended meaning and application of a class or property. They refer to a conceptualisation common to domain
experts (maritime historians) and disambiguate between different possible interpretations.
The RDFS implementation provides the scope note of each class or property using ‘rdfs:comment’. For producing
the class and property URIs, the space character in the name of a class or property is replaced by the underscore
character. Inverse properties are provided using ‘owl:inverseOf’. The version of the ontology is provided through
the property ‘owl:versionInfo’ and its license through the Dublin Core term ‘dc:license’. For the properties pointing
to classes that are represented as literals in RDF (seven properties in total, pointing to the CIDOC-CRM classes
E60 Number or E62 String), we define their range as rdfs:Literal.
We also provide an OWL implementation of the ontology, containing 71 object properties, 7 datatype properties
and 1 symmetric property (the property ‘related to’).15
Since RDF does not provide a direct way to express properties of properties, we make use of property classes (as
suggested and implemented by CIDOC-CRM), as a reification method for encoding the four properties of properties
defined in the SeaLiT Ontology. Using this method, a class is created for each property having a property. This
property class can then be instantiated and used together with the properties ‘P01 has domain’ and ‘P02 has range’
provided by the RDFS implementation of CIDOC-CRM.16 For example, Fig. 8 depicts how the property ‘in the
role of’ of the property ‘works at’ is implemented using the idea of property classes. First, the property class
PC works at is provided for representing the property ‘works at’. During data generation/instantiation, an
instance of this property class is created pointing to the domain (an instance of E21 Person) and the range (an
instance of E74 Group) of the original property ‘works at’ using the properties ‘P01 has domain’ and ‘P01 has range’,
respectively. Then, we can provide the property of property ‘in the role of’ by directly linking it to the property
class instance.
5
APPLICATION
5.1
SeaLiT Knowledge Graphs
The SeaLiT Ontology has been used in the context of the SeaLiT project (cf. Section 2.1) for transforming the
data transcribed from a set of disparate, localised information sources of maritime history to a rich and coherent
semantic network of integrated data (a knowledge graph). The objective of this transformation is the ability to
run complex questions over the integrated data, like those provided by the historians that require combining
information from more than one sources.
In particular, the original archival documents are collaboratively transcribed and documented by historians in
tabular form (similar to spreadsheets) using the FAST CAT system [5]. In FAST CAT, data from different sources
14https://zenodo.org/record/6797750
15https://sealitproject.eu/ontology/SeaLiT_Ontology_v1.1.owl
16https://cidoc-crm.org/rdfs/7.1.1/CIDOC_CRM_v7.1.1_PC.rdf
ACM J. Comput. Cult. Herit., Vol. -, No. -, Article . Publication date: January 2022.

---

14
•
Pavlos Fafalios, Athina Kritsotaki, and Martin Doerr
Fig. 8. Representing a property of property in RDF using a property class.
are transcribed as records belonging to specific templates. A record organises the data and metadata of an archival
document in a set of tables, while a template represents the structure of a single data source, i.e. it defines the data
entry tables. Currently, more than 600 records have been already created and filled in FAST CAT by historians of
SeaLiT. An example of a record for each different type of source (template) is provided in Table 2.
For transforming the transcribed data to RDF based on the SeaLiT Ontology, schema mappings are created for
each distinct FAST CAT template. These mappings define how the data elements of the FAST CAT records (e.g.
the columns of a table) are mapped to ontology classes and properties. To create the schema mappings and run the
transformations, we make use of the X3ML mapping definition language and framework [12]. The transformed
data (RDF triples) are then ingested into a semantic repository (RDF triplestore) which can be accessed by external
applications and services using the SPARQL language and protocol. The ResearchSpace application (described
below) operates over such a repository for supporting historians in searching and analysing quantitatively the
integrated data. The reader can refer to [5] for more information about the FAST CAT system and the data
transcription, curation and transformation processes.
The generated knowledge graphs are available through the Zenodo repository (DOI: 10.5281/zenodo.6460841)17,
under a Creative Commons Attribution 4.0 license. This dataset currently consists of more than 18.5M triples,
providing integrated information for about 3,170 ships, 92,240 persons, 935 legal bodies, and 5,530 locations. These
numbers might change in a future version since data curation, including instance matching, is still undergoing
and new archival documents are transcribed in FAST CAT.
5.2
ResearchSpace Application
For supporting historians in exploring the SeaLiT Knowledge Graphs (and thus the integrated data), we make use
of ResearchSpace [15], an open source platform that offers a variety of functionalities, including a query building
interface that supports users in gradually building complex queries through an intuitive (user friendly) interface.
The results can then be browsed, filtered, or analysed quantitatively through different visualisations, such as bar
charts. The application is accessible at: http://rs.sealitproject.eu/.
The query building interface of ResearchSpace has been configured for the case of the SeaLiT Knowledge
Graphs. In particular, the following searching categories have been defined: Ship, Person, Legal Body, Crew
Payment, Place, Voyage, Course, Record, Source. By selecting a category (e.g. Ship) the user is shown a list with its
connected categories. By selecting a connected category (e.g. Place) the user can then select a property connecting
them (e.g. arrived at) as well as an instance/value (e.g. Marseille; thus the user is searching for ships that arrived
at Marseille). Such a property actually corresponds to a path in the knowledge graph that connects instances of
the selected categories.
17https://zenodo.org/record/6460841
ACM J. Comput. Cult. Herit., Vol. -, No. -, Article . Publication date: January 2022.

---

The SeaLiT Ontology
•
15
Fig. 9. Query building and visualisation of results in the ResearchSpace application.
Fig. 9 shows a screen dump of the system. In this example, the user has searched for persons that were crew
members at ships that arrived at Marseille,18 and has selected to group the persons by their residence location and
visualise the result in a bar chart. From the bar chart we see that the majority of persons had Camogli as their
residence location. This query corresponds to a real information need provided by the historians of SeaLiT.
For retrieving the results and creating the chart, ResearchSpace internally translates the user interactions to
SPARQL queries that are executed over the SeaLiT Knowledge Graphs. For instance, the below SPARQL query
retrieves the persons that were crew members at ships that had Marseille as their final destination:
1 PREFIX crm: <http://www.cidoc-crm.org/cidoc-crm/>
2 PREFIX sealit: <http://www.sealitproject.eu/ontology/>
3
4 SELECT DISTINCT ?person WHERE {
5
?ship sealit:voyages ?voyage .
6
?voyage sealit:finally_arriving_at <https://rs.sealitproject.eu/kb/location/Marseille> ;
7
crm:P14_carried_out_by ?person }
18ResearchSpace link to the query: https://tinyurl.com/2p8ky96e
ACM J. Comput. Cult. Herit., Vol. -, No. -, Article . Publication date: January 2022.

---

16
•
Pavlos Fafalios, Athina Kritsotaki, and Martin Doerr
For grouping the persons by their residence location and showing a chart, the below SPARQL is executed for
retrieving the relevant data:
1 PREFIX crm: <http://www.cidoc-crm.org/cidoc-crm/>
2 PREFIX sealit: <http://www.sealitproject.eu/ontology/>
3 PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
4
5 SELECT DISTINCT ?location ?locationName (COUNT(?person) AS ?numOfPersons) WHERE {
6
?ship sealit:voyages ?voyage
.
7
?voyage sealit:finally_arriving_at <https://rs.sealitproject.eu/kb/location/Marseille> ;
8
crm:P14_carried_out_by ?person .
9
?person crm:P74_has_current_or_former_residence ?location .
10
?location rdfs:label ?locationName .
11 } GROUP BY ?location ?locationName ORDER BY ?locationName
Such queries can also utilise the RDFS inference rules, e.g. those based on the subClassOf and subPropertyOf
relations. An example is the use of the CIDOC CRM property ‘P9 consists of’ for getting all voyage-related
activities of a particular ship (leaving by a place, arrival at a place, passing by or through a place, loading things,
unloading things), as shown in the below SPARQL query:
1 PREFIX crm: <http://www.cidoc-crm.org/cidoc-crm/>
2 PREFIX sealit: <http://www.sealitproject.eu/ontology/>
3 PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
4
5 SELECT DISTINCT ?activity ?activityName WHERE {
6
<SHIP-URI> sealit:voyages ?voyage
.
7
?voyage crm:P9_consists_of ?activity .
8
?activity rdfs:label ?activityName }
In this case, we exploit the fact that the property ‘P9 consists of’ is super-property of the properties ‘consists of
leaving’, ‘consists of arrival’, ‘consists of passing’, ‘consists of loading’, and ‘consists of unloading’.
The type of historians’ research questions / information needs that can be answered (either directly or indirectly)
using the ResearchSpace platform over the integrated data mainly depends on the actual archival material that is
transcribed and transformed to RDF based on the SeaLiT Ontology, and less on the ontology itself. Specifically, the
ontology was designed considering community requirements and material evidence, therefore if the data needed
to answer an information need (or to find important information related to the information need) exists in the
transcripts (and thus in the transformed data) then the question can be answered either fully, or partially through
the retrieval of important relevant information. For example, in the case of SeaLiT, there are transcripts (FAST
CAT records) containing tables that are not fully filled, either because some archival documents do not provide
the corresponding information, or just because historians did not fill the columns during data transcription
(planning to do it at a later stage). In this case, information needs that require this missing information cannot be
satisfied. In future, if new types of information (and corresponding information needs) appear that cannot be
modelled by the ontology, the ontology will be extended/revised and a new version will be released.
With respect to incomplete information, missing entity attributes (e.g. unknown construction location for a
particular ship) are in general very common in historical-archival research, but at the same time an important-to-
know information for historians because they can affect the interpretation of quantitative analysis results. Our
configuration of ResearchSpace considers missing information by representing it as an ‘unknown’ value, e.g. by
showing an ‘unknown’ column in a bar chart.
ACM J. Comput. Cult. Herit., Vol. -, No. -, Article . Publication date: January 2022.

---

The SeaLiT Ontology
•
17
6
USAGE AND SUSTAINABILITY
As already stated, the ontology has been created and used in the context of the SeaLiT project for transforming
data transcribed from archival documents of maritime history to a rich semantic network. The integrated data of
the semantic network allows a large group of maritime historians to perform quantitative and qualitative analysis
of the transcribed material (through the user-friendly interface provided by the ResearchSpace platform) and find
important information relevant to their research needs.
A continuation of the relevant activities is expected after the end of the SeaLiT project through the close
collaboration of the two involved institutions of the Foundation for Research and Technology - Hellas (FORTH):
the Institute of Mediterranean Studies (coordinator of SeaLiT) and the Institute of Computer Science (data
engineering partner in SeaLiT). In particular, the ontology will be extended as soon as a new type of archival
material needs to be transcribed and integrated into the SeaLiT Knowledge Graphs.
The long-term sustainability of the ontology is assured through our participation in relevant communities,
in particular CIDOC-CRM SIG19 and Data for History Consortium20, an international consortium aiming at
establishing a common method for modelling, curating and managing data in historical research. There is already
an interest on using (and probably extending) the ontology in the context of other (ongoing) projects in the field
of historical/archival research. In addition, the part of the model which is about employments and payments is
considered for the creation of a new CIDOC-CRM family model about social transactions and bonds (there are
relevant discussions on this in the CIDOC-CRM Special Interest Group; see issues 420 and 55721).
7
CONCLUSION
We have presented the construction and use of the SeaLiT Ontology, an extension of CIDOC-CRM for the
modeling and integration of data in the field of maritime history. The ontology aims at facilitating a shared
understanding of maritime history information, by providing a common and extensible semantic framework (a
common language) for evidence-based information integration. We provide the specification of the ontology, an
RDFS and an OWL implementation, as well as knowledge graphs that make use of the ontology for integrating a
large and diverse set of archival documents into a rich semantic network. We have also presented a real-working
application (ResearchSpace deployment) that operates on top of the knowledge graphs and which supports
maritime historians in exploring and analysing the integrated data through a user-friendly interface.
In the near future, we plan to a) investigate possible extensions of the ontology based on new data modeling
requirements, b) improve the scope notes of classes and properties in the specification document and add more
examples (and then provide a new ontology version), c) create and make available a JSON-LD context of the
ontology for use in Web-based programming environments.
Acknowledgements
This work has received funding from the European Union’s Horizon 2020 research and innovation programme
under i) the Marie Sklodowska-Curie grant agreement No 890861 (Project ReKnow), and ii) the European Research
Council (ERC) grant agreement No 714437 (Project SeaLiT).
REFERENCES
[1] Francesco Beretta. 2021. A challenge for historical research: making data FAIR using a collaborative ontology management environment
(OntoME). Semantic Web 12, 2 (2021), 279–294.
[2] Apostolos Delis. 2020. Seafaring Lives at the crossroads of Mediterranean maritime history. International Journal of Maritime History 32,
2 (2020), 464–478.
19https://www.cidoc-crm.org/sig-members
20http://dataforhistory.org/members
21https://cidoc-crm.org/issue_summary
ACM J. Comput. Cult. Herit., Vol. -, No. -, Article . Publication date: January 2022.

---

18
•
Pavlos Fafalios, Athina Kritsotaki, and Martin Doerr
[3] Martin Doerr. 2003. The CIDOC conceptual reference module: an ontological approach to semantic interoperability of metadata. AI
magazine 24, 3 (2003), 75–75.
[4] Martin Doerr, Athina Kritsotaki, and Katerina Boutsika. 2011. Factual argumentation—a core model for assertions making. Journal on
Computing and Cultural Heritage (JOCCH) 3, 3 (2011), 1–34.
[5] Pavlos Fafalios, Kostas Petrakis, Georgios Samaritakis, Korina Doerr, Athina Kritsotaki, Yannis Tzitzikas, and Martin Doerr. 2021. FAST
CAT: Collaborative Data Entry and Curation for Semantic Interoperability in Digital Humanities. ACM Journal on Computing and
Cultural Heritage (2021).
[6] Fabien Gandon. 2002. Distributed Artificial Intelligence and Knowledge Management: ontologies and multi-agent systems for a corporate
semantic web. Ph.D. Dissertation. Université Nice Sophia Antipolis.
[7] John B Hattendorf. 2012. Maritime History Today. Perspectives on History 50, 2 (2012), 34–36.
[8] Martin Hepp. 2008. Goodrelations: An ontology for describing products and services offers on the web. In International conference on
knowledge engineering and knowledge management. Springer, 329–346.
[9] Gerald Hiebel, Martin Doerr, and Øyvind Eide. 2017. CRMgeo: A spatiotemporal extension of CIDOC-CRM. International Journal on
Digital Libraries 18, 4 (2017), 271–279.
[10] Konstantinos Kotis and George A Vouros. 2006. Human-centered ontology engineering: The HCOME methodology. Knowledge and
Information Systems 10, 1 (2006), 109–131.
[11] Konstantinos I Kotis, George A Vouros, and Dimitris Spiliotopoulos. 2020. Ontology engineering methodologies for the evolution of
living and reused ontologies: status, trends, findings and recommendations. The Knowledge Engineering Review 35 (2020).
[12] Yannis Marketakis, Nikos Minadakis, Haridimos Kondylakis, Konstantina Konsolaki, Georgios Samaritakis, Maria Theodoridou, Giorgos
Flouris, and Martin Doerr. 2017. X3ML mapping framework for information integration in cultural heritage and beyond. International
Journal on Digital Libraries 18, 4 (2017), 301–319.
[13] Albert Meroño-Peñuela, Ashkan Ashkpour, Marieke Van Erp, Kees Mandemakers, Leen Breure, Andrea Scharnhorst, Stefan Schlobach,
and Frank Van Harmelen. 2015. Semantic technologies for historical research: A survey. Semantic Web 6, 6 (2015), 539–564.
[14] Franco Niccolucci. 2017. Documenting archaeological science with CIDOC CRM. International Journal on Digital Libraries 18, 3 (2017),
223–231.
[15] Dominic Oldman and Diana Tanase. 2018. Reshaping the Knowledge Graph by connecting researchers, data and practices in Re-
searchSpace. In International Semantic Web Conference. Springer, 325–340.
[16] Kostas Petrakis, Georgios Samaritakis, Thomas Kalesios, Enric García Domingo, Apostolos Delis, Yannis Tzitzikas, Martin Doerr, and
Pavlos Fafalios. 2021. Digitizing, Curating and Visualizing Archival Sources of Maritime History: the case of ship logbooks of the
nineteenth and twentieth centuries. Drassana 28 (2021), 60–87.
[17] H Sofia Pinto, Christoph Tempich, and Steffen Staab. 2009. Ontology engineering and evolution in a distributed world using DILIGENT.
In Handbook on ontologies. Springer, 153–176.
[18] Maria Theodoridou, Yannis Tzitzikas, Martin Doerr, Yannis Marketakis, and Valantis Melessanakis. 2010. Modeling and querying
provenance by extending CIDOC CRM. Distributed and Parallel Databases 27, 2 (2010), 169–210.
A
CLASS HIERARCHY OF SEALIT ONTOLOGY
E1 CRM Entity
- E2 Temporal Entity
- - E4 Period
- - - E5 Event
- - - - E7 Activity
- - - - - Voyage
- - - - - Arrival
- - - - - Leaving
- - - - - Passing
- - - - - Loading
- - - - - Unloading
- - - - - De-flagging
- - - - - Discharge
- - - - - Civil Registration
- - - - - Ship Registration
ACM J. Comput. Cult. Herit., Vol. -, No. -, Article . Publication date: January 2022.

---

The SeaLiT Ontology
•
19
- - - - - E11 Modification
- - - - - - Ship Repair
- - - - - - E12 Production
- - - - - - - Ship Construction
- - - - - Money for Service
- - - - - - Money for Things
- - - - - - Money for Labour
- - - - - - - Crew Payment
- - - - - Teaching Unit
- - - - - - Course
- - - - - - Section
- - - - - Service
- - - - - - Employment
- - - - - E13 Attribute Assignment
- - - - - - Promotion
- - - - - Punishment
- - - - - Recruitment
- E53 Place
- - Country
- E54 Dimension
- - Horsepower
- - Duration
- - Tonnage
- E77 Persistent Item
- - E39 Actor
- - - E74 Group
- - - - Port of Registry
- - E70 Thing
- - - E71 Human-Made Thing
- - - - E24 Physical Human-Made Thing
- - - - - E22 Human-Made Object
- - - - - - Ship
- - - - - - Ammunition
- - - - E28 Conceptual Object
- - - - - E55 Type
- - - - - - Language Capacity
- - - - - - Literacy Status
- - - - - - Navigation Type
- - - - - - Profession
- - - - - - Religion Status
- - - - - - Sex Type
- - - - - - Social Status
- - - - - - Subject
- - - E72 Legal Object
- - - - E90 Symbolic Object
- - - - - E41 Appellation
- - - - - - Ship Name
- - - - - - E42 Identifier
- - - - - - - Ship ID
- - - - - E73 Information Object
ACM J. Comput. Cult. Herit., Vol. -, No. -, Article . Publication date: January 2022.

---

20
•
Pavlos Fafalios, Athina Kritsotaki, and Martin Doerr
- - - - - - E29 Design or Procedure
- - - - - - - Labour Contract
- Legal Object Relationship
- - Ship Ownership Phase
- - - Shareholding
- - Legal Document with Temporal Validity
B
PROPERTY HIERARCHY OF SEALIT ONTOLOGY
PROPERTY
DOMAIN
RANGE
P1 is identified by (identifies)
E1 CRM Entity
E41 Appellation
- has ship ID (ship ID identifies)
Ship
Ship ID
P2 has type (is type of)
E1 CRM Entity
E55 Type
- has navigation type (is navigation type of)
Ship
Navigation Type
- has language capacity (is language capacity of)
E21 Person
Language Capacity
- has literacy status (is literacy status of)
E21 Person
Literacy Status
- has social status (is social status of)
E21 Person
Social Status
- has sex type (is sex type of)
E21 Person
Sex Type
- has profession (profession of)
E21 Person
Profession
- has religion status (is religion status of)
E21 Person
Religion Status
- has subject (is subject of)
Teaching Unit
Subject
P9 consists of (forms part of)
E4 Period
E4 Period
- consists of leaving (leaving is part of)
Voyage
Leaving
- consists of arrival (arrival is part of)
Voyage
Arrival
- consists of passing (passing is part of)
Voyage
Passing
- consists of loading (loading is part of)
Voyage
Loading
- consists of unloading (unloading is part of)
Voyage
Unloading
P12 occurred in the presence of (was present at)
E63 Beginning of Existence
E77 Persistent Item
- P92 brought into existence (was brought...)
E63 Beginning of Existence
E77 Persistent Item
- - P108 has produced (was produced by)
E12 Production
E24 Physical Human-Made Thing
- - - constructed (was constructed by)
Ship Construction
Ship
- P11 had participant (participated in)
E5 Event
E39 Actor
- - P14 carried out by (performed)
E7 Activity
E39 Actor
- - - navigated by captain (navigated)
Voyage
E39 Actor
- - - registered by (is responsible for...)
Ship Registration
Port of Registry
- - - money provided by (provided money)
Money for Service
E39 Actor
- - - was mediated by (was mediator of)
Money for Service
E39 Actor
- - - money provided to (received money)
Money for Service
E39 Actor
- - - service provided by (provided service)
Service
E39 Actor
- - - - employment provided by (provided ...)
Employment
E39 Actor
- - had student (student in)
Teaching Unit
E39 Actor
- P31 has modified (was modified by)
E11 Modification
E18 Physical Thing
- - repaired (was repaired by)
Ship Repair
Ship
- voyage of (voyages)
Voyage
Ship
P15 was influenced by (influenced)
E7 Activity
E1 CRM Entity
- P17 was motivated by (motivated)
E7 Activity
E1 CRM Entity
- - for voyage (motivated payment)
Crew Payment
Voyage
P43 has dimension (is dimension of)
E70 Thing
E54 Dimension
- has tonnage (is tonnage of)
Ship
Tonnage
ACM J. Comput. Cult. Herit., Vol. -, No. -, Article . Publication date: January 2022.

---

The SeaLiT Ontology
•
21
- has horsepower (is horsepower of)
Ship
Horsepower
P46 is composed of (forms part of)
E18 Physical Thing
E18 Physical Thing
- has ammunition (is ammunition of)
Ship
Ammunition
P90 has value
E54 Dimension
E60 Number
- has duration value
Duration
E60 Number
P107i is current or former member of (has...)
E39 Actor
E74 Group
- works at (is working place of)
E21 Person
E74 Group
P140 assigned attribute to (was attributed by)
E13 Attribute Assignment
E1 CRM Entity
- concerned (was promoted by)
Promotion
E21 Person
P141 assigned (was assigned by)
E13 Attribute Assignment
E1 CRM Entity
- promoted into status type (status type was...)
Promotion
Social Status
- promoted into employment position type (...)
Promotion
Profession
P173 starts before or with the end of (ends...)
E2 Temporal Entity
E2 Temporal Entity
- P174 starts before the end of (ends after...)
E2 Temporal Entity
E2 Temporal Entity
- - P175 starts before or with the start of (...)
E2 Temporal Entity
E2 Temporal Entity
- - - started (started by)
Recruitment
Employment
- - P184 ends before or with the end of (ends...)
E2 Temporal Entity
E2 Temporal Entity
- - - ended (ended by)
Discharge
Employment
P191 had duration (was duration of)
E52 Time-Span
E54 Dimension
- had duration (duration of)
E52 Time-Span
Duration
had flag of (was flag of)
Ship
Country
has crew number capacity
Ship
E60 Number
under name (named with)
Ship Construction
Ship Name
with ship flag of (is flag of)
Ship Registration
Country
with ship ID (ship ID of)
Ship Registration
Ship ID
registers (is registered by)
Ship Registration
Ship
has owner (is owner of phase)
Ship Ownership Phase
E39 Actor
- has shareholder (participates with share)
Shareholding
E39 Actor
is ownership phase of (has ownership phase)
Ship Ownership Phase
Ship
- is shareholding phase of (has shareholding)
Shareholding
Ship
ownership under name (name with ownership)
Ship Ownership Phase
Ship Name
is initialized by (initializes)
Legal Object Relationship
E5 Event
- ownership is initialized by (initializes...)
Ship Ownership Phase
Ship Registration
is terminated by (terminates)
Legal Object Relationship
E5 Event
- ownership is terminated by (terminates...)
Ship Ownership Phase
De-flagging
has owner (is owner of phase)
Ship Ownership Phase
E39 Actor
- has shareholder (participates with share)
Shareholding
E39 Actor
of share
Shareholding
E60 Number
in time (is time of)
Legal Object Relationship
E52 Time-Span
formerly or currently possesses (is formerly...)
E39 Actor
Legal Doc. with Temp. Validity
de-flagging of (de-flagged in)
De-flagging
Ship
finally arriving at (is arrival place of)
Voyage
E53 Place
starting from (is starting place of)
Voyage
E53 Place
destination (is destination of)
Voyage
E53 Place
loaded (was loaded by)
Loading
E18 Physical Thing
unloaded (was unloaded by)
Unloading
E18 Physical Thing
at place (is place of arrival)
Arrival
E53 Place
from place (is place of leaving)
Leaving
E53 Place
by place (is place of passing by)
Passing
E53 Place
through place (is place of passing through)
Passing
E53 Place
ACM J. Comput. Cult. Herit., Vol. -, No. -, Article . Publication date: January 2022.

---

22
•
Pavlos Fafalios, Athina Kritsotaki, and Martin Doerr
for service (service of)
Money for Service
Service
- for employment (employment from)
Money for Labour
Employment
had money value (was price of)
Money for Service
E97 Monetary Amount
for employment period (is employment period of)
Money for Labour
E52 Time-Span
has been agreed in (is agreement for)
Money for Labour
Labour Contract
for thing (thing of)
Money for Things
E18 Physical Thing
has first name
E21 Person
E62 String
has last name
E21 Person
E62 String
has current age
E21 Person
E60 Number
with ID (ID of)
Civil Registration
E42 Identifier
registers person (person is registered by)
Civil Registration
E21 Person
is given to (was punished by)
Punishment
E39 Actor
related to
E21 Person
E21 Person
with number of students
Teaching Unit
E60 Number
ACM J. Comput. Cult. Herit., Vol. -, No. -, Article . Publication date: January 2022.

---

