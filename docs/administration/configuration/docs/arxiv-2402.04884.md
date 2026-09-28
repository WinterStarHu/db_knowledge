# Topological relations in water quality monitoring

> 来源: https://arxiv.org/pdf/2402.04884

Topological relations in water quality monitoring
Bruno Chaves Figueiredo
INESC-ID Lisboa
Instituto Superior Técnico
Universidade de Lisboa, Portugal
brunocfigueiredo@tecnico.ulisboa.pt
Maria Alexandra Oliveira
Centre for Ecology, Evolution and Environmental Changes
CHANGE - Institute for Global Change and Sustainability,
Faculdade de Ciências
Universidade de Lisboa, Portugal
maoliveira@ciencias.ulisboa.pt
João Nuno Silva
INESC-ID Lisboa
Instituto Superior Técnico
Universidade de Lisboa, Portugal
joao.n.silva@inesc-id.pt
Abstract—The Alqueva Multi-Purpose Project (EFMA) is a
massive abduction and storage infrastructure system in the
Alentejo, which has a water quality monitoring network with
almost thousands of water quality stations distributed across
three subsystems: Alqueva, Pedrogão, and Ardila. Identification
of pollution sources in complex infrastructure systems, such as
the EFMA, requires recognition of water flow direction and
delimitation of areas being drained to specific sampling points.
The transfer channels in the EFMA infrastructure artificially
connect several water bodies that do not share drainage basins,
which further complicates the interpretation of water quality data
because the water does not flow exclusively downstream and is
not restricted to specific basins.
The existing user-friendly GIS tools do not facilitate the
exploration and visualisation of water quality data in spatial-
temporal dimensions, such as defining temporal relationships
between monitoring campaigns, nor do they allow the estab-
lishment of topological and hydrological relationships between
different sampling points.
This thesis work proposes a framework capable of aggregating
many types of information in a GIS environment, visualising
large water quality-related datasets and, a graph data model to
integrate and relate water quality between monitoring stations
and land use. The graph model allows to exploit the relationship
between water quality in a watercourse and reservoirs associated
with infrastructures.
The graph data model and the developed framework demon-
strated encouraging results and has proven to be preferred when
compared to relational databases.
I. INTRODUCTION
The European Union, established water policies such as
the Water Framework Directive (WFD), which focused on the
evaluation of water bodies in order to improve, protect, and
prevent further deterioration of the water quality in European
Union (EU) [1].
In Portugal, sampling in primarily done in large rivers and
reservoirs for domestic water supply, with water samples being
taken at monthly intervals and analysed for general chemical
and physical variables, organic pollution indicators, nutrients
and some heavy metals [2]. The number of parameters to
be monitored is continuously increasing, and are constantly
modified and refined in response to the expanding uses of
water, as well as the development of analytical capabilities
for measuring more substances at ever-lower concentrations
[2].
The Alqueva Multi-Purpose Project (EFMA) is located
in the Alentejo region of Portugal and consists of water
abduction and storage infrastructures, as well as infrastructures
to improve irrigation areas [3]. The EFMA includes several
reservoirs, small-medium size dams, and transfer channels that
feed the Alqueva dam, a major dam in the Guadiana river [4].
The water quality monitoring system of EFMA is a network
with hundreds of water quality stations mainly operated and
maintained by two entities, Empresa de Desenvolvimento e
Infra estruturas do Alqueva, S.A. (EDIA) and Portuguese
Environment Agency (APA /ARH) [5], [6].
Fig. 1. EFMA region, Alentejo.
The SNIRH database is a public database available via web
browser, that aggregates most of the available water quality
data from Portugal, including the EFMA region, also storing
data from old water monitoring programmes, such as Estudo
dos Recursos Hídricos Subterraneos do Alentejo (ERSHA).
The EDIA monitoring bulletins and SNIRH database are
two independent data sources and follow their own data
schema. Furthermore, both the APA and EDIA institutions
have stored data of field monitoring campaigns in tabular
databases with inconsistent data schemas. Currently, it is
challenging to create a database with different types of com-
plementary information, such as hydrometry (e.g, precipitation
amount and water levels) or geological and land use data that
is typically represented spatially explicit information, such as
vectors, including the ESRI Shapefiles, or rasters.
The monitoring stations can evaluate multiple parameters
and have various purposes [7]. The water quality is frequently
evaluated in several locations and, in dams and reservoirs
arXiv:2402.04884v1  [cs.DB]  7 Feb 2024

---

or large rivers, at several depths. In addition, measurements
include physical and chemical parameters, collected in situ
or sent to certified laboratories for chemical analysis [8]. As
a result, a large amount of 4D data (2D parameters, space,
and time) that, due to the complexity associated with its
representation, are not fully utilised and explored, for example,
in the detection of frequent water pollution sources. When
working with 4-dimensional data, both temporal and spatial
correlations must be considered, which complicates the data
analysis and visualisation process significantly.
Current tools have limited capability in handling more
complex data and are frequently unable of adapting to new
methods, standards, and criteria used on water quality moni-
toring. The increasing parameters and number of sampled data
force researchers and managers to find customised scalable
solutions that need to be flexible to work with new types of
data and data relationships, and that can evolve the advancing
progress of technology and scientific research work.
The creation of a framework that can detect water relation-
ships between sites on a river’s branches and correlate them
with water quality samples would be a significant tool for
researchers to quickly monitor contaminant circulation over
the river network and water distribution systems. Also, the
developed solution offers a tool to migrate these spreadsheets
to a database, which would reduce data redundancy and
provide data abstraction and advanced querying.
II. RELATED WORK
A. Water pollution
Water pollution is defined as any physical, chemical, or
biological change in water quality that has a detrimental effect
on living creatures in the ecosystem or renders a water re-
source unfit for one or more of its intended uses [9] Currently,
commercial software is uncapable to address all these issues
and the development of a customised tool that integrates and
stores this large amount and diversity of the data is needed
for this kind of data processing and analysis. The chemical
usage in agriculture can affect directly the water quality
over the terrain drainage which reach surface waters such
as streams, ponds and may compromise the enriched aquatic
habitats important for aquatic species. The phosphate, nitro-
gen, nitrates, and organics are the main chemical substances
that associated to livestock farming [10], [11] that promotes
eutrophication. Eutrophication is the process of accelerated
nutrient enrichment of a water body [12], which contributes to
enhanced aquatic plant growth that negatively influences water
quality and, in particular, dissolved oxygen availability [13].
B. Alqueva Multi-Purpose Project
The Environmental Management Programme (EMP) of
EDIA was approved by Joint Ordinance 1050/2005 of 6
December of the Ministry of the Environment, Territorial
Planning and Regional Development and Ministry of Agri-
culture, Rural Development and Fisheries, and provides the
promotion and coordination of the design and implementa-
tion of environmental monitoring programmes for different
aspects of the EFMA. The EDIA is responsible for monitoring
environmental factors in the EFMA, from status of surface
and underground bodies of water, to soils, fauna and flora
[14], and is responsible for implementing and researching new
climatological and hydrometric monitoring stations [15]. The
WFD, which has been transposed into the national legal system
via the Water Law, establishes the framework for a sustainable
water management, highlighting the main environmental goal
of achieving a “Good” status for all the surface water and
ground water bodies [16].
Additional water quality assessments are undertaken by the
Portuguese Environment Agency (APA) and made available to
the public through the National Water Resources Information
System (SNIRH), which is a database that compiles data from
a monitoring network that covers all the regions of Portugal,
including the EFMA region.
The SNIRH processes, validates and publishes all the infor-
mation collected in the APA monitoring networks and those
of other bodies (e.g., local and regional, including in the
Azores and Madeira archipelagos). The SNIRH helps achieve
the following objectives: assessment of water availability;
characterisation of water resources; assessment of the water
quality trends; among others [17].
In addition to the EDIA and APA water quality monitoring
database, groundwater quality data from early environmental
impact studies done by ERSHA (Estudo dos Recursos Hídricos
Subterrâneos do Alentejo) over the 1997–2001 period are also
available [18]. At the time, the Portuguese Water Institute
(INAG) [19], part of APA since 2012 [20], was responsible
for the study of the aquifer systems.
C. Geographical Information System
In the geospatial analysis process, maps are extremely
important[21] because they are a type of graphical user in-
terface (GUI) with a geospatial dimension that provide a GIS
direct and interactive interface [21]. They also help evaluate
the intermediate analysis results and present the final results
[22].
GIS has become a highly effective tool in processing and
representing environmental data. GIS is capable for handling
large amounts of spatial data in order to model non-point
source pollution problems [23] and combines native raster and
native vector data that are commonly used in environmental
assessments [24].
1) GIS applied to Water Quality: Most hydrological anal-
yses performed using GIS frameworks are static, with data
processing and representation being performed separately or
in combination, but not as an integrated process: the spatial
analysis is conducted using GIS, and the time-series analysis is
mostly done using spreadsheets or statistical software. Neither
approach considers the source-sink relationships between sam-
pling points. Alternatively, some authors choose to highlight
the changes in water pollution observed throughout time,
which is a classical way to evaluate water pollution and does
not require the use of GIS. This way, time-series analysis
is performed and the tabular data that do not include either

---

location (and hence, distance), or topological relationships, are
statistically analysed [7], [25], [26], [27], [28]
Geospatial data are not easy to store in a standard RDBMS.
As a result, spatial extensions have been developed, such as
PostGIS, a PostgreSQL add-on that provides standard spatial
data types and spatial queries.[29]. However, graph database
technology has been increasingly used and has been found to
handle graph-like spatio-temporal data much more effectively
[30]. In the previous section, it was highlighted on some stud-
ies that graph databases outperformed PostGIS/PostgreSQL on
interconnected spatio-temporal data.
D. Graph Databases
The GIS databases are the underlying support for web
GIS applications [21]. The GIS data storage should hold a
collection of geographic datasets of different types, such a
basic vector data (e.g. points, lines and polygons) and raster
data such as satellite and aerial images [21].
There are important constraints on its use for the represen-
tation of water pollution: water is always moving, and the
position of a water particle or a water contaminant varies
geographically and temporally [31], [32], [33], following the
hydrological cycle.
The flexibility of a graph model permits the addition of new
nodes and relationships without compromising the existing
network and storage system and without expensively migrating
the data [34].
The existing approaches using relational databases have
encountered performance limitations, both in storing and
searching for information, when processing large amounts of
data. In this domain, the datasets are fairly large and describe
a wide range of connections and entities [35].
The use aggregate stores for interrelated data results in a
disjointed development experience since it must have to add
a lot of code to fill the limitations of aggregate store storage
principles. Furthermore, as the number of hops (query com-
plexity) increases, aggregate stores slow down significantly
[34].
1) Graph Data-driven approaches for River management:
Graph databases open up new possibilities as to how we
can efficiently access and interconnect data, while recalling
the performance of the graph theory on complex querying
and data searching. This way of storing information brings
new approaches to current problems that were limited with
other database solutions. Graphs appear to be capable of
advancing current studies on water quality assessment or river
network modelling in hydrology and water management [36],
[37]. A recent study demonstrated that graphs can be used
to model geospatial data in hydrology (e.g. watersheds or
drainage networks) [38]. A watersheds are usually connected
in a drainage network with confluences, start and end points
connected by drainage stretches (network edges)[38].
A property graph data model, which is based on labelled-
property graphs, was proposed to facilitate the understanding
of drainage networks [38]. The study presents a use case for
modelling a drainage network and watershed hierarchies where
drainage points, rivers and watersheds are represented as nodes
of a graph, containing property information, such as the ID
and type, river name, and watershed ID code, respectively.
The relationships between drainage points represent the water
stretches. In the presented data model, a river has an associated
drainage network and can be connected to other rivers through
a drainage point (Figure 2). Additionally, the watersheds have
associated water stretches and can be part of other watersheds
[38].
Fig. 2. GVRiver graph view schema. Adapted from [38]
According to that study, river systems and other types
of transportation networks can be modelled as graphs and
implemented using graph databases, on which queries are
more easily expressed using high-level graph query languages,
such as Cypher. Its findings also show that queries involving
path computation run faster on graph databases, in general,
without using advanced SQL query tuning, due to the fact
that their underlying data structures are optimised for a fast
path traversal. A relational representation, on the other hand,
requires the use of recursive queries to compute the transitive
closure of a graph, which reduces query efficiency because the
relational representation does not adequately capture the graph
structure. Aggregate, path, and spatial queries were among
the five types of queries investigated. Only three of the 16
queries performed better in the relational version. The results
were obtained using Neo4j library algorithms rather than the
built-in transitive closure computation of Cypher. Long path
traversals, such as those required in this problem, were clearly
not handled appropriately when using the relational model, as
they require the multiple self-joins of the table containing the
relationships between the river segments [39].
III. DATA MODELLING
The information was available in 4 different file types:
spreadsheets (e.g., water quality data), ERSI shapefies (e.g.,
watersheds, soil and land use, EFMA infrastructures and
reservoirs), TIFF format (e.g., DEM) and PDF, which contains
information about of the EFMA water distribution system.
A. Internal Representation
The new data model aim to integrate and relate water quality
between monitoring stations and land use, as well as exploit
the relationship between water quality in a watercourse and
reservoirs associated with infrastructures. By modelling the
EFMA system as a graph data model, it is possible to connect
all data elements through their relationships and unlock new
analysis methods given the graph model characteristics, such
as relationships between infrastructures to search for paths to
the origin of contamination via specific chemical parameters

---

or to identify the water sub-systems that will be affected by
the contamination via network paths.
Fig. 3. Metagraph data schema
The figure
3 presents the proposed data model for the
EFMA water quality system which consists into a directed
graph with node entities that models the river water stretch, the
water quality monitoring network, the infrastructure network,
and water basin characteristics (e.g., sub-watersheds and land
use), as well as the relationships between them, in a spatial
referenced context.
1) Nodes: The proposed data model has the following list
of entities: WaterSystem, WaterNode, QualityStation,
QualityData,
WaterStretch,
Watershed,
LandUse,
Geometry and DEM.
The WaterSystem nodes on the data model represents the
water system. Associated to WaterSystem are the infrastruc-
tures, a water monitoring network and GIS data, such as raster
with elevation data (e.g. DEM).
The
WaterNode
represents
the
physical
elements
associated
to
a
water
system,
the
infrastructures.The
QualityStation nodes represent the water quality monitoring
stations. The data quality data collected by a water quality
station is represented by the QualityData node. The GIS
data integrated to this thesis project is divided into vector
and raster data. Vector data is composed by Geometry,
Watershed, and LandUse nodes, while raster data consist
of DEM nodes. The WaterStretch node, which has the id
and geometry properties, represents a stretch of the drainage
network that flows to and from infrastructures.
2) Relationships:
The
Node
entities
can
be
interrelated
by
using
the
following
relation-
ships:
:CONNECTED,
:MONITORED_BY ,
:STATION_OF,
:COLLECTED,
:FLOWS_TO,
:WITHIN, :HAS_LANDUSE, :HAS_WATERSHED,
:HAS_GEOMETRY ,
:REPRESENTED,
and
:PART_OF.
The :CONNECTED relationship specifies the water
connection
between
WaterNodes,
which
represent
the
artificial water transfers that connects the infrastructures.
The attribution of vector data to a WaterNode is made
using :REPRESENTED. The relation :FLOWS_TO
is established between WaterStretch A and B nodes if
water can flow from segment A to segment B. The relation
:MONITORED_BY establishes the relation between the
WaterStretch (or WaterNodes) and the water quality
station. The :HAS_LANDUSE, :HAS_WATERSHED
and
:HAS_GEOMETRY
relationships
indexes
the
GIS
data
associated
with
a
:WaterSystem,
such
as
LandUse, Geometry, and Watershed, respectively. The
:WITHIN indicates that a QualityStation, WaterNode,
WaterStretch or LandUse is located with a specific
watershed. :PART_OF is used to indicate sub-watershed
that are within a watershed.
IV. IMPLEMENTATION
The proposed architecture is described and essential com-
ponents are explained in this section. Furthermore, the imple-
mentation steps of the Framework are also addressed.
A. Framework Functionalities
The main goal of the thesis work, as stated in the first
chapter, is to develop a framework capable of aggregating all
different information in a GIS environment, visualising and
analysing large water quality related datasets, and exploring
interactively the topological relationships between data. The
framework is a web application designed to aid in the man-
agement of water distribution networks and assist the water
quality assessment of a certain region. The framework must
support the following functionalities:
• Input file processing and data conversion for database
storage: A file upload form for processing and populating
information from files mentioned before into the database.
The upload form accepts CSV files, such as water nodes,
water nodes links, water quality stations, water quality
data, as well as the geospatial data in GeoJSON or ESRI
shapefile formats, such as watersheds and land use.
• Interactive map for visual geodata exploration: Simple
user interface for creating and editing database informa-
tion. A simple web map for visualising the water distribu-
tion network and exploring geospatial-related information
(e.g., water nodes, water quality stations, and watersheds).
The web map interface also provides methods to create
and delete data from the database.
• Data filters and big-data visualisation toolbox for water
quality data analysis: A console interface for filtering
specific parameters from water quality data and visualise
data into bar, time series and bubble charts.
• Export tool for water quality analysis results: Export the
water quality data results from console to CSV files.
• Path-finding discovery tool between points in the water
distribution system network: Network routing of the water
distribution graph and displays the routing results on the
web map. It features options such as finding the water
sources of a water node and discovering the path between
a water node and the end points of the network.
To gather the information that was not available in the
sourced files, such as the water stretches of drainage networks

---

and the association between water stretches and water quality
stations, I developed a toolbox to compute and estimate sub-
watersheds, drainage networks, and some geometric manipula-
tions for geospatial features, such as the intersection between
polygons and points. This tool will be described in the next
section.
B. Framework Architecture
The architecture of the web application consists of a 3 tier
client-server architecture with: client, web server and database
server. This architecture allows to isolate the development
and maintenance of each tier, and allows to run the tiers
separately. Also, the mid-layer adds another security level to
the database. Figure 4 presents the architecture proposal for
the web application.
Fig. 4. Client-Server Architecture.
The client-server architecture is very popular for common
web applications and, as mentioned in chapter 2, is also used
for many web GIS applications. To run the web application
on old machines or low-performance machines, the GIS pro-
cessing tasks occur at the server, while the client is only used
to show results and user interactions (i.e., definition of a thin
architecture).
The client is an application that runs on the web browser.
The client provides the user-interface for data visualisation
and exploration. The client comprises 3 modules: a web map,
search data, and data exploration. The web map displays all
geographic data accessible in the database, and the search data
module is where the user searches and requests data from
the database. The data exploration module is the interface
to analyse, filter and plot the water quality data. The client
communicates with the back-end over the HTTP protocol.
The back-end consists of an API server that links the user
and the database. The server makes the resources available
through REST API to the client. The REST API provides a
uniform interface and client-server separation that makes the
development of client and server more independent of each
other.
The server has all GIS-related computational and input
file parsing processes described by the modules: input file
processor, vector data tools and watershed analysis tool. The
input file processor is the module that parses and converts the
files, if needed, before populating the database. The vector data
tool consists of a set of vector data methods (e.g., intersection
and contained verification methods). This module is used to
verify relationships between data in a GIS context, such as
to verify if a watershed is within another watershed, or to
detect if a water quality station intersects a water line. All
drainage network and watershed calculations are performed in
the drainage analysis module.
The server communicates with the database via bolt pro-
tocol. Bolt is a binary protocol that is more compact and
has better overall performance than HTTP due to the binary
serialisation format for the requests and responses, making
them smaller and faster to send large chunks of data. At the
last tier, the database server stores all information in a graph
data model.
V. FRAMEWORK IMPLEMENTATION
A. Frontend
The Frontend was developed in Javascript with the ReactJS
library. Javascript is the most popular programming language
for frontend and is the default runtime of the web browsers.
The application is made up of five main UI components
organised in a grid layout, that can be resized and movable.
The main UI components are: Console, Map Search, Search,
Navbar and Map Settings.
The Map Search component provides the web map interface
to explore the geospatial data and relationships. The Search
component is for searching the infrastructures and centring
the web map on the finding results. The Map Settings is the
interface for controlling the data displayed on the web map,
and the Navbar is used to control the application background
colour and manage the other components at the layout grid,
such as adding a new component to the grid. The console
component is for uploading the input files, visualising the
selected quality stations, and plotting water quality data from
selected quality stations.
B. Backend
The backend was developed in Python, a very popular
language along with JavaScript, and has many mature li-
braries for creating a web server and handling geospatial data.
The web server was implemented using the Flask [40], a
lightweight python-based web framework that does not include
database abstraction layer, form validation, and other features
that are common to other frameworks, such as Django [41].
Flask is simple to implement since it does not enforce any
dependencies or project layout, and supports extensions to
add functionalities to the server. In this implementation, some
extensions were used:
• Flask-Caching: adds caching support for various back-
ends to any Flask application.
• Flask-JWT-Extended: adds support for using JSON Web
Tokens (JWT) to Flask for protecting routes and many
features built in to make working with JWT easier.
• Flask-Executor: easy to use wrapper for asynchronously
executing callables.
1) API: The web server uses RESTful APIs to communi-
cate with the frontend application. the available APIs can be
categorised into Authentication API, File API, Queries API
and Resource API.
The Authentication API is used to authenticate the client and
granting access to all other APIs. The API uses JWT-based

---

authentication. The File API includes several endpoints for
uploading files to the database, including specific file upload
endpoints and a main endpoint that auto-identifies the file
type and redirects the file to the appropriate endpoint for
processing.
The Queries API has 42 endpoints for querying almost all
types and forms of data from the database. All endpoints are
cached to minimise the number of requests to the database.
The resources API has endpoints for GIS computational tasks,
such as calculating the sub-watersheds or GIS data manipu-
lations. Because some computations can take long execution
times, the endpoints use parallel and asynchronous tasks to
make the result available later.
2) Database: The graph database solution chosen to this
project was Neo4j [42]. Neo4j is a native graph technology
that has substantial support, such as extensive documentation
and reference code, and offers spatial functions for exploring
geospatial data stored in the database. It is also simple to setup
and offers a free online sandbox for testing queries. Neo4j has
its own query language called Cypher.
VI. EVALUATION AND VALIDATION
In this section, we analyse the potential of the implemented
framework to solve the challenges described before. We eval-
uate the implementation using a graph database, such as the
effectiveness of the data model introduced in section ?? and
highlight the differences between the queries implemented
in Cypher with a solution in SQL. Furthermore, we test
the essential functionalities offered by the Framework, which
include both frontend and backend performance and the ability
to visualise time-series water quality data.
A. EFMA Dataset
The dataset used to evaluate the platform implementation is
composed of files that resulted from pre-processing using the
procedures described in the data preparation section: Quality
stations CSV file, CSV files with the water nodes of Alqueva,
Pedrógão and Ardila, GeoJSON geometries of the water nodes,
GeoJSON file with the hydrographic basins, GeoJSON file
with the land-use and the several processed water quality files.
The EFMA data produced a graph with 44887 nodes and
44285 edges. More accurately, there are 115 water nodes, 795
water quality stations, 43892 water quality data, 39 geometries,
23 watersheds, 22 land use zones and 1 DEM. Furthermore,
the stored DEM generated 1862 nodes (i.e., water stretches)
and 1922 edges. The resulting graph database has a storage
size of approximately 0.2GB.
B. File Upload Performance
We benchmark the performance of water nodes and water
quality data uploads using the Framework, analysing the
behaviour of information size versus processing time. For
comparison, we measured the upload and processing times
of other files. File processing time includes the following
components: web application processing time, communication
time between the three layers, server processing time, and
database populating time.
The upload was tested using the API server endpoints
dedicated to processing each file type. The test was carried
out on a single machine equipped with a CPU 1,8 GHz Intel
Core i5 and 8 GB 1600 MHz DDR3 RAM memory. the
upload times were measured at the web application using the
developer tools of the Opera browser. In the water quality files
test, the larger files take substantially longer to process, which
may be explained by the files being processed on the web
server before being uploaded to the database.
Fig. 5. Upload time versus number of nodes.
The upload time with the increase of the number of water
nodes is shown in Figure
5. Although the water node
files show acceptable processing times, they only represent
a practical case of uploading small files. The increase in time
with much larger files, on the other hand, cannot be predicted.
The GeoJSON files upload times are: 9s, 0.3s and 2s for
land use, watersheds and geometries, respectively. We also
evaluated the data in ESRI shapefile format, which took 16s
for land use (6700kB), 0.55s for watershed (2200kB), and 5.1s
for geometry (129kB).
C. Database Query Analysis
The potential and capabilities of the Cypher queries de-
veloped in this project are explored in this chapter. We will
go over four main queries (i.e, namely Q1, Q2, Q3 and Q4)
that will allow the user to explore the EFMA network water
relationships and discover relationships between water quality
data. The following queries were run on a single machine
equipped with a 1.8 GHz Intel Core i5 CPU and 8 GB 1600
MHz DDR3 RAM memory. The Neo4j database console was
used to measure all of the time records.
1) Q1: Finding water source of a water node: The query is
used to locate the water source of a given point in the EFMA
water transfers network. The query is simple and descriptive,
which is a Cypher characteristic that allows developers to
write explicit relationship patterns in queries. Neo4j provides
a simple path finding procedure that consists of assigning a
variable to the relationship pattern (i.e. path variable in ??).
The query runtime for a graph with 115 water nodes and 113
edges, the longest path of which has 21 edges, was 3ms. The
runtime remained consistent across multiple runs.

---

2) Q2: Finding full water paths containing a given water
node: The query identifies find the path between water source
and end locations for a given infrastructures. This query is
used to identify the upstream and downstream infrastructures
of given infrastructure.
The query is similar to the previous one, but it searches
for the complete path pattern (i.e., backward and forward)
and returns a list of paths. When compared to an SQL
implementation, the SQL version would be more complex in
determining the path between nodes with nodes and edges
stored in tables. Recursive queries with multiple joins between
the two table entities may be required to find a path between
two nodes. The query took 6ms to return the longest path on
the EFMA distribution network in the console (i.e., path with
21 edges). The query was run multiple times, and the time
consistency was maintained.
3) Q3: Finding all quality stations in a downstream water-
course: The query is used to determine the entire path of a
watercourse and collect all monitoring water quality stations
along that path. The query begins by locating the full path
watercourse that contains a specific water stretch, and then
searches for monitoring water quality stations associated with
the discovered water stretches.
The query runtime was tested on a drainage network with
73 nodes and 73 edges, as well as three quality stations linked
to the drainage network, with the longest path between water
quality stations being 17 edges long. The query returned the
result in 4ms. As previously stated, path finding queries are
simple to write in Cypher, and Neo4j, as a native graph
database, enables the use of the benefits of graph theory rather
than abstracting the information using tables.
4) Q4: Finding quality stations contained in the same
catchment area as a given land use: The query returns all
existing quality stations in the same watershed as the land-use
area. The query first locates the watersheds containing the land
use, and then collects all quality stations that monitored the
drainage network within the watershed. To obtain the same
information using a SQL implementation, multiple joins (e.g.,
at least three joins) would be required. The query was tested
using the same use-case as the previous query, with a drainage
network of 73 nodes and 73 edges, as well as three quality
stations connected to the drainage network. The query took
5ms to return the result to the console.
Summary: The queries implemented in the project for
searching nodes and paths have execution times lower than
10ms. Table I summarises the execution times of the queries
explored in this section.
TABLE I
QUERY EXECUTION TIMES.
Query
Execution Time
Q1
3 ms
Q2
6ms
Q3
4ms
Q4
5ms
The Cypher turns queries simpler to construct because it
allows to explicitly write the relationship patterns to find nodes
or paths. Furthermore, the graph database supports direct data
linking, allowing for quick data traversal by simply following
the data connections. In comparison, relational database solu-
tions would have multiple tables to store the same information,
and querying would be more complex, requiring expensive
JOIN operations or the use of multiple queries to achieve the
same result.
VII. USABILITY
The client application showed that it can render a large
number of elements over the map without compromising the
responsiveness and exploiting the resource consumption of
the application. Moreover, the map rendering and generat-
ing charts with large datasets present response times within
the acceptable values for a good user experience (i.e, 100-
200ms)[43].
The queries used for gathering data from databases are
simple and with average execution times less than 10ms, which
is significantly lower than the 100ms, a common value for
HTTP latency [44], and even lower than the 2s tolerable
waiting time for information retrieval [45]. Therefore, the
choice of the database will not affect the performance of the
client application.
VIII. CONCLUSIONS
This thesis introduces the development of an open-source
framework capable of aggregating all types of information
in a GIS environment, visualising and analysing large water
quality-related datasets, and interactively exploring topological
relationships between data. In order to solve the mentioned
issues, this thesis proposes a graph data model to integrate
and relate water quality between monitoring stations and land
use, as well as to exploit the relationship between water quality
in a watercourse and reservoirs associated with infrastructures.
Instead of a relational database, a graph database (i.e Neo4j)
is implemented and analysed in this thesis work.
The graph data model implemented in this thesis project al-
lowed to connect all different information through the existing
relationships between data, and it was demonstrated that it can
natively store graph-like data, such as the water distribution
network. Furthermore, the flexibility of the data model, as an
inherent feature of a graph database, was useful for storing
data with a variable number of attributes, such as water quality
stations and data.
The development of the framework required choosing the
technologies and design models that allow building a solution
capable of scale, performance-oriented and able to run almost
all machines, including with low computational power. The
framework allows users to explore the relationships between
data and enable other types of analysis supported by graph
path-finding algorithms, such as the search for paths to the
origin of contamination via specific chemical parameters or
identification of the water sub-systems that will be affected
by the contamination via network paths.

---

The query analysis tests showed noticeable performance
for the path-finding queries. The Cypher (i.e., graph query
language of Neo4j) simplifies query construction by allowing
explicit writing of relationship patterns to find nodes or paths.
Furthermore, the graph database supports direct data linking,
which enables fast data traversal by simply following the
data connections. In the map interface and data visualisation
tests, the Framework demonstrated its ability to handle large
collections of points while providing responsive map naviga-
tion to the user. Render performance was usually guaranteed
when exploring a map with a large dataset, which can be
attributed to good data flow design between web application
components and HTML best practices. The plot also showed
a responsive interaction during the test and was reasonably
fast when plotting a large dataset, demonstrating good query
and client application performance. However, the input file
tests showed that upload time for larger water quality data
was noticeable. The larger files contain numerous parameters
that will be converted to attributes of the water quality data
nodes. Furthermore, before sending the file to the database,
the web server verifies the file structure and checks for invalid
data. Therefore, the parsing time will increase with file size.
The input file feature can be optimised at both the query and
server implementation levels.
In conclusion, the graph data model and the developed
framework are proofs of concepts that show promising results.
Allows users to access data that was previously difficult to
visualise and has proven to be advantageous in comparison
to relational databases. The framework can be a useful tool
for researchers to quickly monitor water pollutants circulation
across the river network and water distribution systems.
REFERENCES
[1] EU, “Directive (eu) 2020/2184 of the european parliament and of
the council,” 12 2020. [Online]. Available: https://eur-lex.europa.eu/
legal-content/EN/TXT/HTML/?uri=CELEX:32020L2184
[2] P. Kristensen and J. Bøgestrand, European Topic Centre on Inland
Waters SURFACE WATER QUALITY MONITORING by, 1996, no.
January.
[3] A.
M.
G.
Coimbra
and
N.
Gonçalves,
“Mathematical
simulation
of
the
Alqueva
irrigation
system,”
pp.
1–
10. [Online]. Available: https://fenix.tecnico.ulisboa.pt/downloadFile/
844820067125018/\ExtendedAbstract{_}AMG.pdf
[4] P. Bettencourt and M. Grade, “Environmental Impact Assessment of a
Mega Project in Portugal and Spain–the Alqueva Project,” 29th Annual
Conference of the International Association for Impact Assessment, 16-
22 May 2009, Accra International Conference Center, Accra, Ghana,
no. May, pp. 2–5, 2009.
[5] M. Ruivo, M. Murteira, and A. Ilhéu, “A qualidade das massas de
água nos aproveitamentos hidroagrícolas do sul de Portugal - o caso
do EFMA,” pp. 1–15, 2012.
[6] INAG, “Redes de monitorização de águas subterrâneas no alentejo,”
2000.
[7] M. M. Morais, A. M. Serafim, P. Pinto, A. Ilhéu, and M. Ruivo,
“Monitoring the water quality in Alqueva Reservoir , Guadiana River ,
southern Portugal,” Reservoir and River Basin Management, Exchange
of Experiences from Brazil, Portugal and Germany, no. 1983, pp. 96–
112, 2007.
[8] E. S.A, “Relatório de atividades,” 2020.
[9] J. Bartram, Water quality monitoring: a practical guide to the design
and implementation of freshwater quality studies and monitoring pro-
grammes, 01 1996.
[10] APA, “Circuito hidráulico de viana do alentejo e respetivo bloco de
rega,” March 2018.
[11] NEMUS, “Estudo de impacte ambiental do bloco a beneficiar pela infra-
estrutura 12,” 1999.
[12] C. Lindim, “Modelling of water quality in the alqueva reservoir, portu-
gal,” Ph.D. dissertation, 03 2011.
[13] C.
E.
Boyd,
Eutrophication.
Cham:
Springer
International
Publishing,
2020,
pp.
311–322.
[Online].
Available:
https:
//doi.org/10.1007/978-3-030-23335-8_15
[14] E. S.A. Environmental policy. [Online]. Available: https://www.edia.pt/
en/social-responsability/environmental-policy/
[15] ——.
Monitoring.
[Online].
Available:
https://www.edia.pt/en/
what-we-do/monitoring/
[16] APA, “About us.” [Online]. Available: https://apambiente.pt/en/apa/
portuguese-environment-agency-apa
[17] ——,
“State
of
surface
and
groundwater
bodies,”
2017.
[Online].
Available:
https://rea.apambiente.pt/content/
state-surface-and-groundwater-bodies?language=en
[18] ——.
Sistema
nacional
de
informação
de
recursos
hí-
dricos
-
snirh.
[Online].
Available:
https://apambiente.pt/agua/
sistema-nacional-de-informacao-de-recursos-hidricos-snirh
[19] E. António Reis Rosado Paralta, O. Científico, D. Luís Filipe Tavares
Ribeiro Júri, D. Maria José Antão Pais de Almeida Cerejeira Vogais,
D. Rosa Maria da Cunha Salgado Cabral Fernandes Vogais, D. Amélia
Maria Mello de Carvalho Vogais, D. Luís Filipe Tavares Ribeiro
Vogais, D. José Manuel Vaz Velho Barbosa Marques Vogais, and
D. Tibor Yvan Stigter, “UTILIZAÇÃO DE MODELOS DE RECARGA
E TÉCNICAS ISOTÓPICAS NA AVALIAÇÃO DO IMPACTE DA
AGRICULTURA NA QUALIDADE DA ÁGUA SUBTERRÂNEA DE
ZONAS AGRÍCOLAS Caso de estudo no Aquífero dos Gabros de
Beja Dissertação para obtenção do Grau de Doutor em Ciências de
Engenharia UNIVERSIDADE TÉCNICA DE LISBOA INSTITUTO
SUPERIOR TÉCNICO,” 2009.
[20] INAG,
“Redes
de
monitorização
-
alentejo,”
1999.
[Online].
Available:
https://snirh.apambiente.pt/snirh/download/relatorios/redes_
agsub_\alentejo.pdf
[21] J. Peuralahti, “Geographic Information System - A Case Study for
Developers,” no. February, 2014.
[22] M. J. Kraak, Cartography : visualization of geospatial data.
Harlow
New York: Prentice Hall, 2010.
[23] U. S. Tim and R. Jolly, “Evaluating agricultural nonpoint-source
pollution
using
integrated
geographic
information
systems
and
hydrologic/water quality model,” Journal of Environmental Quality,
vol. 23, no. 1, pp. 25–35, Jan. 1994. [Online]. Available: https:
//doi.org/10.2134/jeq1994.00472425002300010006x
[24] T. Wade, J. Wickham, M. Nash, A. Neale, K. Riitters, and K. Jones, “A
comparison of vector and raster gis methods for calculating landscape
metrics used in environmental assessments,” Photogrammetric engineer-
ing and remote sensing, vol. 69, pp. 1399–1405, 12 2003.
[25] P. Palma, P. Alvarenga, V. Palma, C. Delerue-Matos, R. Fernandes,
A. Soares, and I. Barbosa, “Evaluation of surface water quality using
an ecotoxicological approach: A case study of the alqueva reservoir
(portugal),” Environmental science and pollution research international,
vol. 17, pp. 703–16, 04 2009.
[26] J. R. Pérez, S. Loureiro, S. Menezes, P. Palma, R. M. Fernandes,
I. R. Barbosa, and A. M. V. M. Soares, “Assessment of water quality
in the alqueva reservoir (portugal) using bioassays,” vol. 17, no. 3,
pp. 688–702, May 2009. [Online]. Available: https://doi.org/10.1007/
s11356-009-0174-9
[27] A. I. McLeod, K. W. Hipel, and B. A. Bodo, “Trend analysis
methodology for water quality time series,” Environmetrics, vol. 2,
no. 2, pp. 169–200, 1991. [Online]. Available: https://onlinelibrary.
wiley.com/doi/abs/10.1002/env.3770020205
[28] N. M. Mattikalli, “Time series analysis of historical surface water
quality data of the river glen catchment, u.k.” Journal of Environmental
Management, vol. 46, no. 2, pp. 149–172, 1996. [Online]. Available:
https://www.sciencedirect.com/science/article/pii/S0301479796900134
[29] A. Jolma, D. P. Ames, N. Horning, M. Neteler, A. Racicot, and T. Sutton,
“Free and open source geospatial tools for environmental modeling and
management,” Proceedings of the iEMSs 3rd Biennial Meeting," Summit
on Environmental Modelling and Software", no. January, 2006.
[30] S. B. Effendi, B. van der Merwe, and W. T. Balke, “Suitability of graph
database technology for the analysis of spatio-temporal data,” Future
Internet, vol. 12, no. 5, pp. 1–31, 2020.

---

[31] H. Allafta and C. Opp, “Spatio-temporal variability and pollution
sources identification of the surface sediments of shatt al-arab river,
southern iraq,” Scientific Reports, vol. 10, no. 1, Apr. 2020. [Online].
Available: https://doi.org/10.1038/s41598-020-63893-w
[32] A. Lintern, J. Webb, D. Ryu, S. Liu, U. Bende-Michl, D. Waters,
P. Leahy, P. Wilson, and A. W. Western, “Key factors influencing
differences in stream water quality across space,” WIREs Water, vol. 5,
no. 1, Oct. 2017. [Online]. Available: https://doi.org/10.1002/wat2.1260
[33] B. Hugo, M. Fernando, and C. Jorge Alberto, “Topological GIS-based
analysis of a water distribution network model. Applications of the min-
imum spanning tree,” Proceedings of the 8th International Conference
on Computing and Control for the Water Industry, CCWI 2005: Water
Management for the 21st Century, vol. 1, no. September 2005, 2005.
[34] B. M. Sasaki, J. Chao, and R. Howard, “Graph DB for beginer.”
[35] F. Gong, Y. Ma, W. Gong, X. Li, C. Li, and X. Yuan, “Neo4j graph
database realizes efficient storage performance of oilfield ontology,”
PLoS ONE, vol. 13, no. 11, pp. 1–16, 2018.
[36] M. Fry and J. Rosecký, “Graph-based river network analysis for rapid
discovery and analysis of linked hydrological data,” in EGU General
Assembly Conference Abstracts, ser. EGU General Assembly Conference
Abstracts, May 2020, p. 17318.
[37] J. Torres, L. Dueñas-Osorio, Q. Li, and A. Yazdani, “Exploring topo-
logical effects on water distribution system performance using graph
theory and statistical models,” Journal of Water Resources Planning
and Management, vol. 143, p. 04016068, 09 2016.
[38] D. Jaudet, “Universidade Estadual de Campinas Instituto de Computação
Jaudete Daltio Views over Graph Databases : A Multifocus Approach
for Heterogeneous Data Visões em Bancos de Dados de Grafos : Uma
Supervisor / Orientadora : Profa . Dra . Claudia Maria Bauzer Mede,”
2017.
[39] E. Bollen, R. Hendrix, B. Kuijpers, and A. Vaisman, “Towards the
internet of water: Using graph databases for hydrological analysis on
the flemish river system,” Transactions in GIS, vol. 25, no. 6, pp. 2907–
2938, Jul. 2021. [Online]. Available: https://doi.org/10.1111/tgis.12801
[40] [Online]. Available: https://flask.palletsprojects.com
[41] [Online]. Available: https://www.djangoproject.com
[42] B. M. Sasaki, “Graph databases for beginners: Why a database
query language matters (more than you think).” [Online]. Available:
https://neo4j.com/blog/why-database-query-language-matters/
[43] J. R. Dabrowski and E. V. Munson, “Is 100 milliseconds too fast?”
in CHI '01 extended abstracts on Human factors in computing
systems
-
CHI
'01.
ACM
Press,
2001.
[Online].
Available:
https://doi.org/10.1145/634067.634255
[44] D. Bermbach and E. Wittern, “Benchmarking web API quality –
revisited,” Journal of Web Engineering, Oct. 2020. [Online]. Available:
https://doi.org/10.13052/jwe1540-9589.19563
[45] F. F.-H. Nah, “A study on tolerable waiting time: how long are
web users willing to wait?” Behaviour & Information Technology,
vol.
23,
no.
3,
pp.
153–163,
May
2004.
[Online].
Available:
https://doi.org/10.1080/01449290410001669914

---

