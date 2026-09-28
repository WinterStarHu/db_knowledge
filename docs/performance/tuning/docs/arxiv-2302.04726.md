# RTClean: Context-aware Tabular Data Cleaning using Real-time OFDs

> 来源: https://arxiv.org/pdf/2302.04726

RTClean: Context-aware Tabular
Data Cleaning using Real-time OFDs
Daniel Del Gaudio
University of Stuttgart
Stuttgart, Germany
Daniel.Del-Gaudio@ipvs.uni-stuttgart.de
Tim Schubert
University of Stuttgart
Stuttgart, Germany
st148736@stud.uni-stuttgart.de
Mohamed Abdelaal
Software AG
Darmstadt, Germany
Mohamed.Abdelaal@softwareag.com
Abstract—Nowadays, machine learning plays a key role in
developing plenty of applications, e.g., smart homes, smart
medical assistance, and autonomous driving. A major challenge of
these applications is preserving high quality of the training and
the serving data. Nevertheless, existing data cleaning methods
cannot exploit context information. Thus, they usually fail to
track shifts in the data distributions or the associated error
proﬁles. To overcome these limitations, we introduce, in this
paper, a novel method for automated tabular data cleaning
powered by dynamic functional dependency rules extracted from
a live context model. As a proof of concept, we create a smart
home use case to collect data while preserving the context
information. Using two different data sets, our evaluations show
that the proposed cleaning method outperforms a set of baseline
methods in terms of the detection and repair accuracy.
Index Terms—data cleaning, context modeling, ontology, func-
tional dependency
I. INTRODUCTION
Machine learning and data quality: Over the last couple of
decades, the technological advances in storage and processing
power have broadly enabled numerous innovative products
and services based on machine learning (ML), e.g., Face-
book’s facial recognition program, Google’s translation and
speech recognition, Netﬂix’s recommendation engines, Uber’s
dynamic pricing systems, and Tesla’s self-driving cars. In
such applications, machine learning is typically employed to
derive insightful information from (large volumes of) data by
leveraging algorithms to identify complex patterns and learn
in an iterative process. One of the essential factors in training
an effective machine learning model is providing high quality
data. In fact, poor data quality can lead to incorrect business
intelligence decisions, worse data analysis, and a multitude of
errors. According to Gartner research, organizations believe
poor data quality to be responsible for an average of $15
million per year in losses [1].
Challenges: Several error types, e.g., numerical outliers,
null values, rules/constraints violation, typos, duplicates, and
inconsistencies, may co-exist in real-world tabular data. Such
error types typically originate owing to improper join opera-
tions, noisy communication channels, inaccurate and incom-
plete manual data entry, etc. To combat data quality problems,
several error detection methods have been introduced [2]–
[4] to automatically identify erroneous data instances, before
either removing or imputing them. These methods usually
leverage a set of static cleaning signals, e.g., business rules,
data constraints, or metadata, to detect different error types.
Nevertheless, such cleaning signals usually lack information
about the context of data collection, which can play an
important role while cleaning the data.
Motivating Scenario: To further explain the challenges of
dynamic environments while cleaning tabular data, we created
a Smart Home use case. From this use case, we collected
a real-world data set (cf. evaluations in Section V). Our
environment consists of four temperature sensors: two are
placed in the same room, one in another room and one outside
the Smart Home. Each sensor records the temperature value
every hour. The collected data has been used to predict the
energy consumption of our environment using ML models.
Since the sensors tend to produce erroneous values from time
to time, the predictions of the trained ML models are broadly
not accurate. A manual detection of errors in the collected
data is an overwhelming and time-consuming task, yet, context
knowledge about the environment that the sensors are placed
in can be helpful. For instance, two temperature sensors in
the same room, measuring different values at the same time,
can be an indication of an error. In fact, existing data cleaning
methods cannot exploit such context knowledge to enhance
their performance.
Context-aware cleaning: To overcome the limitations of
existing data cleaning methods, we introduce, RTClean1, a
novel data cleaning method which considers the context of
data collection and the dynamic nature of the deployment
environments. To this end, RTClean leverages a context model
of the intended application to capture a set of Ontologi-
cal Functional Dependencies (OFDs). Such OFDs describe
semantic attribute relationships such as synonyms and is-a
hierarchies deﬁned by an ontology. It is important to highlight
that several previous works exploited OFDs for data cleaning
[5], [6] (cf. Section VI for more details). However, RTClean
differentiates itself from these works in its ability to track real-
time changes in the environment, e.g., relocating the sensors
in the Smart Home scenario, thanks to our live context model.
Speciﬁcally, our context model enriches the static information,
embedded in an ontology, with live monitoring and sensor
data. Since the environment is mostly dynamic in terms of
1RTClean: https://github.com/delgaudl/RTClean
arXiv:2302.04726v1  [cs.DB]  9 Feb 2023

---

the available devices and sensors, our context model can be
updated constantly. Note that we do not aim to use OFDs on
the sensor data itself but on the context of the environment in
which the data is generated.
Contributions: To sum up, the paper provides the following
contributions: (1) We introduce a novel three-steps error detec-
tion method, including context modeling, feature generation,
and error detection. Based on our live context model, the error
detection method can be updated with fresh OFDs. (2) We
introduce a Smart Home use case to collect an IoT data set,
while preserving the context information. (3) We evaluate
the performance of RTClean using two real-world data sets,
including our Smart Home data set and the Hospital data
set from the US health service2, to ensure the generality of
the proposed method. In both data sets, the results show that
RTClean outperforms a set of baseline methods. To the best
of our knowledge, RTClean is the ﬁrst data cleaning method
which can be updated in real-time via considering both static
and dynamic information about the environments.
II. SYSTEM MODEL AND ARCHITECTURE
Our main objective is to enrich existing data cleaning meth-
ods with features extracted from an ontology-based context
model. RTClean is divided into three steps, which also reﬂect
the architecture of our system, since we propose a separate
component for each step. Thus, each component can be further
involved into different processes, e.g., using the context model
for system engineering. Figure 1 provides an overview over all
components of RTClean with their respective inputs. As the
ﬁgure shows, RTClean encompasses three main steps, which
are deﬁned as follows.
1) Context modeling: The ontology-based context model
must be manually/automatically generated in an ofﬂine phase
(It has been generated automatically for our Smart Home
use case). The concept to monitor an environment, detect
changes and update the context model constantly, using differ-
ent adapters, relies on our previous work [7] and is therefore
beyond the scope of this concept. However, it is important to
notice, that in our concept, context changes can originate from
multiple different sources, e.g., by the interaction of human
users via a user interface.
2) OFD extraction and feature generation: In the next
step, a set of different OFDs are extracted from the ontology.
To this end, RTClean relies on the OFD discovery algorithm
proposed in [8]. From the extracted OFDs, a set of binary
features are generated that can be used for data cleaning.
3) Data cleaning: Finally, the dirty data can be cleaned
through exploiting the binary features generated from the
OFDs dependencies. This step outputs a cleaned data set
and a set of detected errors. Afterward, the clean data can
be employed in different downstream applications, e.g., ML
model building, visualizations, business intelligence, etc.
When the whole system is initiated, changes in the environ-
ment are constantly registered using different adapters. Thus,
2Hospital data set: https://gitlab.com/hatjog/holoclean/-/tree/master/testdata
Environment (e.g., Smart Home, Hospital, etc.)
Context Modeling
User Interface
Monitoring
Adaptors
Data Cleaning
OFD Extraction &
Feature Generation
Clean
Data
Dirty Data
Context
Model
Context Changes
Downstream
Applications
OFDs &
Features
3
Context Modeling
OFD Extraction &
Feature Generation
1
2
Fig. 1. Overview of the RTClean approach.
if we have a stream of data originating from the environment,
we can adapt the data cleaning step in real-time to the current
context. In this paper, we assume that RTClean receives a data
set, that contains errors, and are able to create an ontology-
based context model that describes the structure of the data
or of the environment which the data is extracted from. For a
better understanding of the remainder of this paper, Section III
gives an overview of the context model described in [7]
together with the extensions we made to use the context model
for data cleaning.
III. ONTOLOGY-BASED CONTEXT MODEL
RTClean aims to use knowledge about the context of data
to improve data cleaning methods. To this end, RTClean
leverages an ontology-based context model to consolidate the
context knowledge, which is described in this section. OFDs
can then be used to generate additional features from the
model. For the context model, we use the live context model
approach that we proposed in our previous work [7], which
builds on the ontologies IoT-Lite [9] and SSN [10]. The use
of ontologies enables the extensibility of the context model to
different data and use cases. The approach aims to adapt the
ontology to the current state of the system. This adaptation is
achieved by using different adapters that periodically retrieve
changes in the environment, e.g., new devices, and update
the context model accordingly. Such fresh context information
enables us to adapt the data cleaning automatically to changes
of the environment in real-time. We extended the ontology
proposed in [7] for the purpose of data cleaning.
Figure 2 shows an extract of the context model of the
IoT scenario, described in Section I. The System is the root
node and indicates one environment. While, the Devices node
indicates physical devices that are currently present in the
environment. As the ﬁgure depicts, the Devices are linked
with the Sensors, which indicate currently available sensors,
by the use of Sensing Devices. The Sensors can be attached
with Metadata, e.g., to indicate maximum, minimum values
and the resolution of the sensor. Each Sensing Device can be
associated with a location, for which we use the Objects, via
a Deployment node. It is important to note, that the structure
of the context model highly depends on the structure of the
data, the use case and the environment from which the data

---

hasSubsystem
hasSubsystem
ssn:System
MA TestSystem
hasSubsystem
ssn:Device
device_main
ssn:ActuatingDevice
raspberry
hasSubsystem
hasMonitoringComponent
hasSubsystem
ssn:Device
device_in_1
hasDeployment
ssn:SensingDevice
esp8266_1
hasSensingDevice
hasMetadata
hasQuantityKind
isAssociatedWith
hasAttribute
isActed
iot-lite:Attribute
t1
hasQuantityKind
qu:QuantityKind
Temperature
hasLocation
ssn:Deployment
SensorInside
iot-lite:Object
Room1
iot-lite:Metadata
Resolution
metadataType=resolution
metadataValue=12
hasMeasurement
iot-context:MonitoringComponent
NETWORK_Monitor
hasValue
hasTimestamp
iot-context:Measurement
SignalStrength
xsd:dateTime
2022-01-12T12:00:00.000Z
xsd:double
-50 dBm
hasMetadata
hasMetadata
ssn:Sensor
ds18b20_1
hasDeployment
ssn:SensingDevice
esp8266_2
hasLocation
ssn:Deployment
SensorInside
...
iot-lite:Metadata
MinValue
metadataType=minValue
metadataValue=-55
iot-lite:Metadata
MaxValue
metadataType=maxValue
metadataValue=125
ssn:Device
device_in_1
ssn:Sensor
ds18b20_1
iot-context:MonitoringComponent
NETWORK_Monitor
hasMonitoringComponent
iot-context:Measurement
SignalStrength
hasMeasurement
hasTimestamp
xsd:dateTime
2022-01-12T12:00:00.000Z
hasValue
Fig. 2. Extract of the IoT context model ontology.
State
State: xsd:string
County
CountyName: xsd:string
City
City: xsd:string
ZipArea
ZipCode: xsd:nonNegativeInteger
Address
Address1: xsd:string
Hospital
HospitalName: xsd:string
PhoneNumber: xsd:long
HospitalOwner: xsd:string
ProviderNumber: xsd:nonNegativeInteger
Hospital Type
HospitalType: xsd:string
EmergencyService
EmergencyService: xsd:boolean
Measure Code
MeasureCode: xsd:string
MeasureName: xsd:string
Stateavg: xsd:string
Condition
Condition: xsd:string
hasAddress
hasType
hasMeasure
hasZipArea
hasCity
hasCounty
hasState
hasEmergencyService
Fig. 3. Ontology to represent the structure of the Hospital data set.
is originated. Therefore, we utilize another data set for the
evaluation with an according context model. Figure 3 shows
the ontology of the Hospital data set.
IV. CONTEXT-AWARE DATA CLEANING
In this section, we elaborate on the context-aware data
cleaning method. First, we give a deﬁnition of the various
OFDs dependencies which can be extracted from our live
context model. Second, we explain how RTClean exploits
these automatically-generated OFDs dependencies to detect
and repair erroneous data instances.
A. OFD Extraction from Ontologies
In general, OFDs are a special kind of Functional De-
pendencies (FDs), derived from an ontology. The different
types of OFDs that RTClean focuses on are explained in this
section. Considering a data set D with a relational schema R.
An FD X →Y is a constraint which uniquely determines
the relation of an attribute Y
∈R to a set of attributes
X ⊆R [11]. They mostly describe relationships based on
syntactic equality and can be used, e.g., in data integration
and data cleaning [12]. In this context, the FD dependencies
are used to specify data quality requirements. An instance I
of R satisﬁes the FD X →Y if for every pair of tuples
t1, t2 ∈I if t1[X] = t2[X], then t1[Y ] = t2[Y ]. For example,
consider the following two attributes: City and ZipCode. If the
tuples t1[city] = t2[city] = “Berlin”, then the corresponding
tuples t1[ZipCode], t2[ZipCode] should be equal to 10115.
To derive FDs from data observations, identiﬁcation of
the attribute order which deﬁnes the directionality is needed.
In order to reduce the exponential computational cost, the
existing methods rely on pruning to efﬁciently search over the
lattice of attribute combinations [11]. From our live context
model, RTClean can extract different dependencies, including
structure-based, time-based and value-based dependencies.
The time-based and value-based dependencies differentiate our
context model from other relevant works, e.g., [5] and [6].
The OFDs are extracted by querying the context model for
the different types of OFDs. Below, we describe each type of
these dependencies.
1) Structure-based: The extraction of structure-based de-
pendency usually does not consider the actual values of the
data, but solely the structure of the ontology. In this context,
we consider three different kinds of structure-based dependen-
cies: denial dependencies, matching dependencies, and device
link dependencies. The denial dependencies contain, e.g., func-
tional and conditional dependencies, which indicate whether
an instance in the data set is erroneous, if the dependency is
satisﬁed. A denial dependency D over a relation R is deﬁned
as A →B, where A and B are single attributes in R and
A̸ = B. An instance I satisﬁes D if for every pair of tuple
t1, t2 ∈I with t1[A] = t2[A], t1[B]̸ = t2[B].
On the other hand, the matching dependencies generalize
FDs by requiring pairs of tuples to be similar w.r.t. a certain
similarity metric in the left- and right-hand side column values
in lieu of being strictly equal. A matching dependency MD
over a relation R is represented as Ax% →Bx%, where A and
B are single attributes in R and A̸ = B. The subscript x%
denotes the level of similarity between A and B. An instance
I satisﬁes MD if for every pair of tuple t1, t2 ∈I with

---

t1[A] = t2[A], similarity between t1[B], t2[B] ≥x%. For
the device link dependency, it indicates whether a sensor is
linked to a speciﬁc device. A device link dependency L can
be represented as a function Ψ : X →Y , where X denotes the
set of sensors available in the IoT environment and Y denotes
devices. A dependency Ψ(A) = B is satisﬁed, if the sensor A
is physically connected to the device B. This relation means
that the sensor itself belongs to this device and can only be
read out from it speciﬁcally.
2) Time-based: Temporal dependencies are used to detect
errors in the order of the data. To detect errors concerning
this dependency, the data must be equipped with a timestamp.
Speciﬁcally, temporal dependencies T deﬁne a relation be-
tween two devices, A and B. If the dependency A →B
holds, the data, e.g., measurements, will only be sent from
device A to B. Let the timestamp tA denotes the time when a
message m is created or processed on the device A. Since the
transmission time from device A to device B is greater than
zero, the timestamp tA should be smaller than the timestamp
tB (timestamp at which the message is processed on the
device B). In this case, the device A can be called a temporal
predecessor of B.
3) Value-based: We consider three different kinds of value-
based dependencies: locality dependencies, monitoring depen-
dencies, and capability dependencies. A locality dependency
L is deﬁned as a function Γ : Device →Locality. Let A
be a sensing device and B a locality, e.g., a room. If the
device A is placed at the location of B, then the locality
dependency A →B holds and Γ(A) = B. This means that
measurements taken from the sensing device A will always
capture the environment at the location B. A monitoring
dependency M describes a device A, which is monitored by a
monitoring component B. For instance, health indicators, e.g.,
the CPU load, can be stored as measurements in the context
model. Since those measurements are being added live while
operating, monitoring dependencies can be used in real-time
or on an existing data set with timestamps.
A capability dependency C describes a set of capabilities
B assigned to a sensor A. One capability is represented as
a metadata object for a speciﬁc sensor. The metadata object
consists of a type, e.g., resolution or minimal measurable
value, and the corresponding value. Since metadata objects
store the capabilities of a sensor, they can be used as a ﬁlter
for the measured values. Speciﬁcally, the values which are not
plausible, regarding the sensor’s abilities, can then directly
be marked as erroneous. For example, if a measurement
is lower than the minimal measurable value of a sensor,
this measurement is considered as erroneous. A capability
can also deﬁne borders of the measured units. For example,
temperatures which are lower than the absolute zero are then
automatically labeled as an error.
B. Data Cleaning
For data cleaning, RTClean is built on top of a state-of-the-
art data cleaning framework, referred to as HoloClean [3].
However, It is important to mention that RTClean can be
TABLE I
EXAMPLES OF THE EXTRACTED OFDS
IoT
Hospital
Size
(1000,7)
(1000,20)
# Manual Dependencies
—
15
# Auto-extracted OFDs
21
25
OFD: Denial
System →Device,
Device →SensingDevice
PhoneNumber →Address1,
ZipCode →City
OFD: Matching
—
ProviderNumber75% →PhoneNumber75%,
Stateavg75% →MeasureCode75%
OFD: Device-Link
ds18b20 1 →device in 1
NA
OFD: Capability
ds18b20 1 →MaxValue,
ds18b20 1 →MinValue
NA
OFD: Locality
ds18b20 1 →Room1,
ds18b20 2 →Room1
NA
OFD: Temporal
device in 1 →device main
NA
integrated with any other data cleaning method. We selected
HoloClean since its mechanism supports manually-crafted
denial and matching dependencies. HoloClean includes several
methods for error detection, e.g., null detector, violation de-
tector (using manually-crafted dependencies), and error loader
detector3. To exploit the OFDs, extracted from our live context
model, in the process of data cleaning, we added an OFD vio-
lation detector to HoloClean. Such an OFD violation detector
is able to extract the OFDs and then evaluates them on the data
set. Speciﬁcally, the OFD detector creates a Boolean feature
for each OFD, stating whether the OFD is fulﬁlled for each
row in the data. Such binary features serve as the detected
errors by the OFD detector. These detected errors are then
further used by HoloClean in its normal pipeline.
V. PERFORMANCE EVALUATION
In this section, we assess the effectiveness of RTClean rela-
tive to a set of baselines. First, we introduce the experimental
setup, before discussing the obtained results
A. Experimental Setup
To evaluate RTClean, we utilized two real-world data sets,
including the Hospital data set and the IoT data set. Table I
provides information about the data sets and examples of the
extracted OFDs. We utilized an Error Generator4 to inject
realistic errors in the data sets. The errors comprise typos,
value errors, and null values. Regarding the IoT data set, we
injected 5% errors of each category, resulting in 149 erroneous
instances. Furthermore, we injected outliers into the numerical
values of the IoT data set to compare our approach with a
typical outlier detection method. We created two different data
sets with numerical values and errors: one with random errors
in the original value range, and one with random errors in the
doubled range of the original values.
It is important to mention that the original implementation
of HoloClean supports only denial dependencies and, with a
workaround, matching dependencies. We extended this imple-
mentation to exploit the extracted OFDs. As baseline methods,
we utilized Raha [2], an ML-based error detection method, and
3HoloClean: https://github.com/HoloClean/holoclean
4Error Generator: https://github.com/BigDaMa/error-generator

---

dBoost5 which is an outlier detection method for numerical
values. For the evaluation, we carried out data cleaning in three
different ways: (i) without any dependencies (using only the
null detector already exists in HoloClean), (ii) with manually-
crafted dependencies, and (iii) with automatically-extracted
dependencies. We store the context model in an Apache Jena6
triple store database and use the Fuseki7 SPARQL server
to extract the dependencies. The evaluation metrics comprise
the detection precision, recall and F1-score. Furthermore, we
employ the repair recall, deﬁned as the fraction of correct
repairs over the total number of correctly-detected erroneous
cells [3], and the repair F1-score, deﬁned as the harmonic
mean of precision and repair recall.
B. Results
1) Hospital Data Set: The Hospital data set contains names
of hospitals with their addresses, their types, and other categor-
ical attributes, as it can be seen in Figure 3. The data set comes
with a set of manually-created dependencies, and it includes a
set of erroneous instances. Figure 4 shows the results for the
Hospital data set. For the comparison, we executed the original
implementation of HoloClean on the Hospital data set with
no dependencies, 50% of the manual dependencies, 100% of
the manual dependencies, and the dependencies automatically
extracted from the context model.
As Figure 4 depicts, the detection and repair accuracies
are improved when increasing the number of dependencies
from 50% to 100%. Such a result emphasizes the general
impact of using dependencies for data cleaning. Aside from
the number of dependencies, HoloClean with no dependencies
achieves high precision. However, it detects only 36 errors in
total, whereas RTClean detects 431 errors in total. Similarly,
the high precision of HoloClean with no dependencies leads
to a high repair recall and repair F1-score, because all 36
errors have been correctly repaired. In the case of using
manually-crafted dependencies, HoloClean also achieves high
detection precision, since the dependencies have been created
speciﬁcally for the errors in the data set. However, they achieve
low detection recall, since the available dependencies are not
sufﬁcient to describe the important relationships in the data
set. Conversely, RTClean yields a signiﬁcant improvement
in recall, F1-score, repair recall and repair F1-score thanks
to the automatically-generated OFDs. For instance, RTClean
achieves higher detection F1-score, at least by 14%, relative
to HoloClean with 100% dependencies.
2) IoT Data Set: The IoT data set contains temperature
read-outs every hour. If more than one value is recorded in
this interval, the mean is calculated. The data set is mostly
free from errors, but it contains null values and the read-out
value of -128 is resulted when a sensor is faulty. These already
existing errors are removed manually before the evaluation
to have cleaner results for comparison. Figure 5 shows the
results for the whole IoT data set, including the numerical
5dBoost: https://github.com/cpitclaudel/dBoost
6Apache Jena: https://jena.apache.org/index.html
7Apache Fuseki: https://jena.apache.org/documentation/fuseki2/index.html
precision
recall
F1-score
repairing recall
repairing F1-score
0.0
0.2
0.4
0.6
0.8
1.0
0.94
0.60
0.73
0.71
0.81
1
0.46
0.63
0.53
0.70
1
0.12
0.22
0.29
0.45
1
0.07
0.13
1
1
ontology dependencies
manual dependencies (100%)
manual dependencies (50%)
no dependencies
Fig. 4. Results for the Hospital data set in comparison with HoloClean using
50% manual dependencies, 100% manual dependencies and no dependencies.
precision
recall
F1-score
0.0
0.2
0.4
0.6
0.8
1.0
0.92
0.46
0.61
0.88
0.30
0.44
0.77
0.28
0.40
HoloClean - ontology dependencies
HoloClean - no dependencies (100%)
Raha
Fig. 5. Results for the whole IoT data set in comparison with Raha.
and categorical attributes. We use Raha and HoloClean without
dependencies for comparison. In this case, we do not consider
the repair recall and the repair F1-score, because our goal for
the IoT scenario is to simply detect and erase the erroneous
instances. As the ﬁgure depicts, RTClean broadly outperforms
the baseline methods, where it achieves higher detection F1-
score at least by 28% and 35% than Raha and HoloClean
without dependencies, respectively.
To measure the ability of RTClean to detect numerical
outliers with different ranges, we carried out a comparison
between RTClean and dBoost. Figure 6 shows the detection
accuracy of RTClean and dBoost while being used for cleaning
the IoT data set. In this ﬁgure, the label “random” indicates
the IoT data set with errors in the original range of values.
Whereas, the label “+100%” indicates the data set with errors
in the doubled range of the original values. As the ﬁgure de-
picts, dBoost performs well in terms of the detection precision
on the “+100%”-data set. However, it fails to detect erroneous
instances when they are in the original range. Conversely,
RTClean can effectively detect errors in the different ranges.
For instance, RTClean achieves higher detection F1-score (at
least by 1.3% and 40%) than dBoost in the “+100%” range
and the original range, respectively.

---

precision
recall
F1-score
0.0
0.2
0.4
0.6
0.8
1.0
1.2
0.69
0.81
0.74
1
0.58
0.73
0.48
0.35
0.40
0.00
0.00
0.00
+100% range - ontology dependencies
+100% range - dboost
random - ontology dependencies
random - dboost
Fig. 6. Results for the numerical values of the IoT data set in comparison
with dboost.
VI. RELATED WORK
Zheng et al. [6], [13] propose an approach for dependency-
based data cleaning with OFDs. They show that real-world
data contains domain-speciﬁc relationships beyond syntactic
equivalence or similarity, e.g., synonyms, which can often
be described in ontologies. Similar to RTClean, they extract
such synonym relationships from ontologies using OFDs.
In contrast to their work, RTClean also focuses on errors
concerning numeric values. Furthermore, we aim to keep the
data cleaning process up-to-date using real-time OFDs. Zhang
et al. [5] recognize the need for FDs to clean data. Hence,
they focus on the extraction of FDs directly from the data,
instead of using an ontology. They use structured learning
with a probabilistic model to extract FDs from noisy data.
RTClean integrates expert knowledge into the data cleaning
by extracting OFDs from the context model. We consider the
combination of both approaches as a topic for future research.
Visengeriyeva and Abedjan [4] propose two holistic ap-
proaches to combine different error detection methods for
heterogeneous data from different sources. They state that, the
structural heterogeneity of these sources is the origin of data
quality problems, like missing values, duplicates, inconsistent
data, and outliers. In this context, metadata is necessary to
decide which error detection approach to use for a speciﬁc
data source. Multi-column dependencies are an example of
such metadata which they adopted for error detection. RTClean
exploits a live context model to extract multiple OFDs and use
them for error detection.
VII. CONCLUSION & OUTLOOK
We presented a novel approach, RTClean, that improves
tabular data cleaning using an ontology-based context model
and OFDs. Thus, knowledge about the environment the data
originates from can be involved in data cleaning. Using
our live context model, RTClean can automatically generate
multiple OFDs which represent the current state of the en-
vironment. Hence, RTClean broadly relieves the burden of
creating reliable dependencies describing the relationships in
the data. The evaluation results show that RTClean performs
better than typical state-of-the-art error detection methods.
Moreover, RTClean proves to be effective in detecting errors
on numerical values that are inside the typical range of the
data. In the future, we aim to test RTClean in an end-to-end
ML scenario on large data sets and continuous streams of data.
Furthermore, we plan to investigate how RTClean can handle
changes of the context model during the data cleaning process.
ACKNOWLEDGMENT
This research was funded by German Federal Ministry of
Education and Research (BMBF) through grants 01IS17051
(Software Campus program), 02L19C155 and 01IS21021A
(ITEA project number 20219).
REFERENCES
[1] S. Moore, “How to create a business case for data quality improvement,”
2018. Accessed on May 2022.
[2] M. Mahdavi, Z. Abedjan, R. Castro Fernandez, S. Madden, M. Ouzzani,
M. Stonebraker, and N. Tang, “Raha: A conﬁguration-free error detec-
tion system,” in Proceedings of the 2019 International Conference on
Management of Data, SIGMOD ’19, (New York, NY, USA), p. 865–882,
Association for Computing Machinery, 2019.
[3] T. Rekatsinas, X. Chu, I. F. Ilyas, and C. R´e, “Holoclean: Holistic data
repairs with probabilistic inference,” 2017.
[4] L. Visengeriyeva and Z. Abedjan, “Metadata-driven error detection,”
in Proceedings of the 30th International Conference on Scientiﬁc and
Statistical Database Management, SSDBM ’18, (New York, NY, USA),
Association for Computing Machinery, 2018.
[5] Y. Zhang, Z. Guo, and T. Rekatsinas, “A statistical perspective on
discovering functional dependencies in noisy data,” in Proceedings of
the 2020 ACM SIGMOD International Conference on Management of
Data, SIGMOD ’20, (New York, NY, USA), p. 861–876, Association
for Computing Machinery, 2020.
[6] Z. Zheng, L. Zheng, M. Alipourlangouri, F. Chiang, L. Golab,
J. Szlichta, and S. Baskaran, “Contextual data cleaning with ontology
functional dependencies,” J. Data and Information Quality, vol. 14,
no. 3, 2022.
[7] D. Del Gaudio, B. Ariguib, A. Bartenbach, and G. Solakis, “A live
context model for semantic reasoning in iot applications,” in 2022 IEEE
Int. Conf. on Pervasive Computing and Communications Workshops and
other Afﬁliated Events (PerCom Workshops), pp. 322–327, 2022.
[8] S. Baskaran, A. Keller, F. Chiang, L. Golab, and J. Szlichta, “Efﬁcient
discovery of ontology functional dependencies,” in Proceedings of the
2017 ACM on Conference on Information and Knowledge Management,
CIKM ’17, (New York, NY, USA), p. 1847–1856, Association for
Computing Machinery, 2017.
[9] M. Bermudez-Edo, T. Elsaleh, P. Barnaghi, and K. Taylor, “Iot-lite: A
lightweight semantic model for the internet of things,” in 2016 Intl IEEE
Conferences on Ubiquitous Intelligence & Computing, Advanced and
Trusted Computing, Scalable Computing and Communications, Cloud
and Big Data Computing, Internet of People, and Smart World Congress
(UIC/ATC/ScalCom/CBDCom/IoP/SmartWorld), pp. 90–97, 2016.
[10] M. Compton, P. Barnaghi, L. Bermudez, R. Garc´ıa-Castro, O. Corcho,
S. Cox, J. Graybeal, M. Hauswirth, C. Henson, A. Herzog, V. Huang,
K. Janowicz, W. D. Kelsey, D. Le Phuoc, L. Lefort, M. Leggieri,
H. Neuhaus, A. Nikolov, K. Page, A. Passant, A. Sheth, and K. Taylor,
“The ssn ontology of the w3c semantic sensor network incubator group,”
Journal of Web Semantics, vol. 17, pp. 25–32, 2012.
[11] Y. Zhang, Z. Guo, and T. Rekatsinas, “A statistical perspective on
discovering functional dependencies in noisy data,” in Proceedings of
the 2020 ACM SIGMOD International Conference on Management of
Data, SIGMOD ’20, (New York, NY, USA), p. 861–876, Association
for Computing Machinery, 2020.
[12] S. Baskaran, A. Keller, F. Chiang, L. Golab, and J. Szlichta, “Efﬁcient
discovery of ontology functional dependencies,” in Proceedings of the
2017 ACM on Conference on Information and Knowledge Management,
pp. 1847–1856, 11 2017.
[13] Z. Zheng, L. Zheng, M. A. Langouri, F. Chiang, and J. Szlichta, “Discov-
ery and contextual data cleaning with ontology functional dependencies,”
CoRR, vol. abs/2105.08105, 2021.

---

