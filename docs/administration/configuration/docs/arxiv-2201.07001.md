# Supporting Domain Data Selection in Data-Enhanced Process Models

> 来源: https://arxiv.org/pdf/2201.07001

Supporting Domain Data Selection in
Data-Enhanced Process Models
Jonas Cremerius and Mathias Weske
Hasso-Plattner-Institute, University of Potsdam, Potsdam, Germany
{jonas.cremerius, mathias.weske}@hpi.de
Abstract. Process mining bridges the gap between process management and data
science by discovering process models using event logs derived from real-world
data. Besides mandatory event attributes, additional attributes can be part of an
event representing domain data, such as human resources and costs. Data-enhanced
process models provide a visualization of domain data associated to process activi-
ties directly in the process model, allowing to monitor the actual values of domain
data in the form of event attribute aggregations. However, event logs can have so
many attributes that it is difﬁcult to decide, which one is of interest to observe
throughout the process. This paper introduces three mechanisms to support domain
data selection, allowing process analysts and domain experts to progressively reach
their information of interest. We applied the proposed technique on the MIMIC-IV
real-world data set on hospitalizations in the US.
Keywords: Visual Process Analytics, Change Detection, Process Mining, Infor-
mation Highlighting
1
Introduction
Business organizations are confronted with the challenge of dealing with more and more
data provided by their information systems. Those systems store real-world process
execution data, from which process models can be discovered using process discovery
techniques. The discovered process models represent the actual execution of processes,
which allows conﬁrming expected process behaviour and might reveal unknown insights
about the processes [1].
So far, process models can be analysed using events and their ordering. As informa-
tion systems provide additional domain data stored as event attributes, data-enhanced
process models allow a data-based exploration of processes. In data-enhanced process
models, domain data can be displayed at activities, where an event attribute was used or
modiﬁed, allowing to observe how domain data is inﬂuenced by the process [2].
In comparison to other work in the literature, data-enhanced process models allow
monitoring the development of the actual values of domain data during process execution
in the process model, as, for example, the laboratory values during hospitalization might
change throughout the process. This can help to check, for example, clinical guidelines,
which make statements about the data behind events, such as that elevated concentrations
of circulating cardiac troponins are detected in the vast majority of patients with acute
heart failure [3].
17th International Conference on Wirtschaftsinformatik
February 2022, Nürnberg, Germany
arXiv:2201.07001v1  [cs.DB]  13 Jan 2022

---

However, an event might have many event attributes. For example, an event represent-
ing a stay in a hospital department can include over 100 laboratory values, medication
data, imaging results, vital signs, and more [4,5]. Choosing the event attribute for obser-
vation in the data-enhanced process model is difﬁcult, if not impossible, with so many
event attributes available. Does the value of an event attribute change throughout the
process, or is it only used at one process step? If it changes, which activities modify the
event attribute, and what is the degree of variability? Therefore, the process analysts and
domain experts are confronted with information overloading when faced with a long list
of available event attributes.
Information highlighting is a technique to control information overloading aiming
to reduce confusion, and to increase accuracy and efﬁciency of understanding the
information presented [6]. This paper provides an approach, in which highlighting is
used to support the information selection process of domain data for illustration in
data-enhanced process models. Concretely, we introduce three mechanisms helping
process analysts and domain experts to observe the most interesting event attributes from
event logs depending on their type, variability, and process characteristic.
This contribution follows a design science approach consisting of ﬁve steps before
publication [7]. The ﬁrst step, Problem Identiﬁcation and Motivation, was presented in
the ﬁrst section. After that, Section II describes the second step, Objectives of a Solution,
by illustrating related work facing the stated problem and current solutions in other
ﬁelds dealing with the problem. Section III and IV present the Design and Development
step, introducing preliminaries and the approach. Section V covers the last two steps,
Demonstration and Evaluation, by applying the approach to the MIMIC-IV real-world
data set on hospitalizations. We discuss the approach and its limitations in Section VI
before the paper is concluded in Section VII.
2
Related Work
Even though process discovery mainly focuses on control ﬂow, the visualization of
domain data has been researched as well.
In data-enhanced process models, domain data can be monitored in the form of
event attribute aggregations, enabling a data-based exploration of the process. There,
the process analysts and domain experts choose the activity and the event attribute for
aggregation from a list, which is then visualized at the respective activity of the process
model [2]. Another example is the multi-perspective process explorer, where the value
distribution of selected domain data can be observed at each activity in the form of
histograms [8]. In data-aware heuristic mining, domain data is chosen from a list to
identify conditional dependency relations or decision rules [9].
These contributions have in common, that these leave the users with the choice of
the event attribute of interest. This can be a problem when facing a lot of available event
attributes, leading to information overloading.
The approach to support process analysts and domain experts on ﬁnding event
attributes of interest is related to the topic of highlighting in information visualization,
which deals with the problem of information overloading. In particular, the interaction

---

control for information retrieval should provide mechanisms allowing users progressively
to reach their interested information [6].
One mechanism to highlight event attributes is related to the classiﬁcation of event
attributes. Event attributes have been classiﬁed in several ways for different analysis pur-
poses. For instance, [10] classiﬁes event attributes into controllable and non-controllable,
where the ﬁrst one can be altered during a process execution and the other cannot. An-
other contribution classiﬁes domain data according to a medical standard (openEHR) to
ﬁnd dependencies within and between these categories [11].
The other mechanism of highlighting refers to the discipline of change detection.
Change detection is widely spread in image detection and involves measuring how the
attributes of an area have changed between two dates [12]. It can be used to identify, for
example, ﬂooding, earthquakes, or urban sprawl. Change detection can also be applied
for an arbitrary amount of images. In [13], the coefﬁcient of variation (CV) is used to
measure the change across N images of a particular area. Considering a construction site,
the CV can measure the degree of variability during the process of construction.
The approach in this paper addresses the problem of ﬁnding event attributes of
interest for analysis in a data-enhanced process model, which has not been tackled so far
to our knowledge. The objective is to reduce the cognitive load of process analysts and
domain experts, allowing them to observe the most interesting information in the process.
To achieve that, this contribution brings the disciplines of information highlighting, event
attribute classiﬁcation, and change detection together to provide an artefact supporting
domain data selection in data-enhanced process models.
3
Preliminaries
This paper builds on data-enhanced process models, which are mined from an event log.
An event log consists of sequences of events, which are grouped into traces. An event
can have an arbitrary number of additional event attributes. The following deﬁnition is
based on [14].
Deﬁnition 1 (Event log, Trace, and Event) Let V be the universe of all possible values
and EA be the universe of event attributes. An event e is a mapping of event attributes to
values, such as e ∈EA →V . The universe of events is deﬁned as EU = EA →V . A
trace t ∈EU
⋆is a sequence of events, and T = EU
⋆represents the respective universe
of traces. An event log L is a multi-set of traces, so L ∈M(T), where, given any set
X, M(X) is the set of all possible multi-sets over X. Normally, an event represents
an activity which is conducted within a certain case at a given timestamp. These are
treated as regular event attributes in this contribution, so we assume activity, case, and
timestamp. The event instances of a given trace are ordered by their timestamp and have
the same case. If an event e ∈EU has no value assigned to an event attribute eAt ∈EA,
it is denoted as e(eAt) = ⊥. We further assume, that the data type of one event attribute
is always the same for all events and that each event is unique. As every event is unique,
we say, that two traces t1, t2 ∈L are identical, if the events in the traces have the same
activity ordering.

---

In process mining, process models are discovered from event logs, which are deﬁned
in the following.
Deﬁnition 2 (Process Model) Given an event log L ∈M(T) and a process discovery
algorithm α taking L as its input, then α(L) generates a process model P = (N, E). N
is the set of process activities and represents the events in the event log, such that given
an event e ∈EU and any event attribute eAt ∈EA representing the process activity
in the log L, e(eAt) ∈N. In the following, we assume, that e(activity) is used as the
process activity. E is a set of directed edges, such that E ⊆N × N. Gateways or other
model-speciﬁc elements are not considered in this deﬁnition, as data-enhanced process
models modify the activities of process models only.
To make event attributes presentable at activities in process models, event attribute
aggregations take all event attributes related to an activity and provide different operations
for aggregation. The deﬁnition is based on [2].
Deﬁnition 3 (Event Attribute Aggregation) An event attribute aggregation is a tuple
eAA = (a, eAt, EAV , λA) consisting of
– an activity a ∈N for which the event attributes are extracted
– an event attribute eAt ∈EA, which is aggregated
– a multi-set EAV with all event attribute values to be aggregated
– an aggregation function λA taking all event attribute values in EAV and aggregating
them to a rational number
Given an event log L, the desired event attribute values can be extracted by iterating
through each trace t ∈L, including the contained events. In the following, we use the
normal set deﬁnition notation for multi-sets, as we specify beforehand, if the set is a
multi-set:
EAV := {e(eAt) ∈V | e(activity) = a, e ∈t, t ∈L}
(1)
The event attribute aggregations can be linked to a process model, resulting in a
data-enhanced process model. The deﬁnition is based on [2] as well.
Deﬁnition 4 (Data Enhanced Process Model) Let EAA be the universe of event
attribute aggregations. An event attribute aggregation eAA is a tuple, as deﬁned in Deﬁ-
nition 3, such that eAA ∈EAA. Given a process model P = (N, E), a data-enhanced
process model DEP enhances each activity N by a set of event attribute aggregations,
resulting in NDEP ⊆(N × EAA). The data-enhanced model is then a tuple of data-
enhanced activities NDEP and edges E, such that DEP = (NDEP , E).
Measuring and comparing the degree of variability between different characteristics,
such as different event attributes, is achieved by using the coefﬁcient of variation (CV),
which is also known as the relative standard deviation.
Deﬁnition 5 (Coefﬁcient of Variation (CV)) Given the mean (µ) and standard devia-
tion (σ), the CV is deﬁned as follows [15]:

---

CV (%) = σ
µ ∗100
Dividing the standard deviation by the mean creates a relative measure, allowing to
compare the degree of variability between different characteristics. It is undeﬁned for
µ = 0, which might be the case when data is normalized or negative values are in the
data.
4
Approach
In this contribution, we help the user to ﬁnd an event attribute eAt ∈EA for a selected
activity act ∈dom(NDEP ) to be represented as an event attribute aggregation eAA ∈
EAA. Thus, we provide support for creating the tuple (act, eAA) ⊆NDEP , which is
the foundation of data-enhanced process models DEP = (NDEP , E). To achieve that,
three mechanisms are provided to reduce the amount of selectable domain data. The
reason why we provide mechanisms instead of recommending a certain event attribute is
that the preferences on which attribute might be interesting can vary among different
domain experts and process analysts. Some might be interested in looking at a speciﬁc
attribute at a given process step, while others are interested in observing the development
of an event attribute throughout the process. The mechanisms are related to the purpose
of data-enhanced process models, which aim at understanding the process behaviour of
the actual values of domain data.
Therefore, we start by separating categorical from quantitative event attributes. Then,
we deﬁne process characteristics of domain data, which classiﬁes domain data according
to their process behaviour. Finally, we provide further ﬁltering of domain data with a
certain process characteristic based on the CV.
Differentiation between categorical and quantitative event attributes The idea be-
hind separating categorical from quantitative event attributes is to get a ﬁrst overview
about the domain data in the event log, which is a well established data pre-processing
step [16]. Additionally, data-enhanced process models provide different forms of aggre-
gations for both types of variables [2].
One approach to separate both classes is to calculate the number of unique values
and divide this by the number of all values in a data-set, which was chosen based on
current literature [16]. For any given event attribute eAt ∈EA, we say that the set
eUnique contains all unique values and the multi-set eV alues includes all values of eAt
in the event log. Dividing |eUnique| by |eV alues| results in a ratio cf, which can be used
to classify the event attributes. This ratio can be compared to a threshold th, where a
low value indicates a categorical and a high value a quantitative type. For example, if
all values of an event attribute are unique, cf is 1, indicating a quantitative attribute. If
three of 100 values are unique, cf is 0.03, which is likely to be categorical. Choosing
the threshold is dependent on the view of what a categorical variable is. The threshold
should have the property that variables with a lot of unique values have a cf ≫th and
variables with a comprehensible amount of categories have a cf ≪th.
Having the domain data classiﬁed into categorical and quantitative, the process
characteristics of them are assessed in the following.

---

Classifying event attributes according to their process characteristics In process
mining, process analysts try to understand the process behaviour of events in the event
log. The process behaviour is graphically represented by the control ﬂow and optionally
gateways, which bring structure into the events. It can be seen, if events with the same
activity name occur multiple times or just once during a process instance. Thus, events
in an event log have different process characteristics.
In this contribution, we propose to give event attributes a process characteristic as
well. An event attribute might be used only once in a process. Another one might be
used multiple times and evolves throughout the process.
Therefore, the following classiﬁcation according to process characteristics of event
attributes is suggested. Two features are provided to classify the process characteristic of
domain data. The ﬁrst feature is the total number of activities in which the event attribute
is set. Formally, it is deﬁned as follows:
Given an event attribute eAt ∈EA in an event log L, the set eAct represents all
activities in which the event attribute is used.
eAct := {e(activity) ∈V | e(eAt)̸ = ⊥, e ∈t, t ∈L}
(2)
The cardinality |eAct| represents the number of activities in which the respective
event attribute occurs.
The second feature, eAvgT race, is the average number of times, the event attribute
occurs per trace. This feature is important to answer the question, whether an event
attribute is used once or multiple times during a process instance. Hence, it can be
evaluated, whether an event attribute evolves throughout the process. This feature is
calculated by iterating through each trace in which the event attribute is used at least
once. In these traces, the number of events having the respective event attribute are
counted.
Formally, this is deﬁned as follows, given an event attribute eAt ∈EA and an event
log L ∈M(T): First, the event log is ﬁltered, so that only traces are included which use
the event attribute at least once.
L′ = {t ∈L | (∃e ∈t)[e(eAt)̸ = ⊥]}
(3)
Then, the average number of events using the event attribute can be calculated:
eAvgT race =
P
t∈L′
P
e∈t[e(eAt)̸ = ⊥]
|L′|
(4)
The equation above uses the Iverson bracket, which evaluates to 1, if the condition is
true and otherwise to 0. Hence, if the event attribute is not ⊥, 1 is returned and added to
the sum [17].
Three different process characteristics are deﬁned in this contribution based on
the previously deﬁned features |eAct| and eAvgT race. The ﬁrst process characteristic
describes event attributes which do not change throughout the process and occur at only
one activity in all process instances. That characteristic is called static. For instance,
the admission location of a patient in a hospital could be recorded only at the hospital
admission.

---

The second one includes event attributes which do not change throughout the process,
but occur at different activities in the process. Looking at a logistic process, where one
of multiple means of transportations can be chosen, the attribute transfer duration could
occur at the activities "Transport via ship" or "Transport via truck", but always only once
per process instance. That one is called semi-dynamic.
The last process characteristic describes domain data which changes throughout
the process and occurs at multiple activities. That one is called dynamic. An example
could be the state of an order, which is created at the beginning by one activity and
ﬁnished/cancelled by other activities at the end of the process. In the following, the
presented process characteristics are formalized:
pc(eAt) =





static,
|eAct| = 1, eAvgT race = 1
semi −dynamic,
|eAct| > 1, eAvgT race = 1
dynamic,
|eAct| ≥1, eAvgT race > 1





It should be noted, that eAvgT race is a rational and |eAct| is a natural number.
eAvgT race cannot be < 1, because we look only at traces including the event attribute at
least once. Considering loops, the condition for the dynamic process characteristic, that
|eAct| ≥1 is important. If there is a loop of a single process activity changing a unique
event attribute, |eAct| is 1, but the event attribute occurs multiple times in a trace.
This mechanism gives process analysts and domain experts an overview of the
process behaviour of domain data, where they know in advance, if an event attribute
at a given activity can be used for monitoring throughout the process or is exclusively
available for the activity.
Looking at dynamic event attributes, the degree of variability can be speciﬁed based
on the CV introduced previously.
Filtering dynamic event attributes according to their degree of variability Dynamic
event attributes have the particular property of evolving throughout the process. However,
some event attributes might change through the process execution and some might not.
Measuring the degree of variability of domain data would enable process analysts
and domain experts to ﬁlter event attributes according to their degree of variability,
identifying event attributes which are sensitive to the process. Thus, they can decide if
they desire to analyse event attributes, which remain constant throughout the process or
have a high degree of variability.
In this paper, the CV is proposed to measure the degree of variability of domain data.
As mentioned in related work, the CV has been used in the ﬁeld of change detection in
images, taking a sequence of pixels and measuring their change over time [13]. Inspired
by this methodology, this contribution uses the CV to measure the degree of variability
of domain data.
The reason for choosing the CV is its ability to identify variability and its indepen-
dency to the scale of a variable, which allows comparing variables of different scales [15].
To demonstrate that, an example event log is presented in Table 1, showing two traces
with two additional event attributes representing laboratory values in a hospital. The
example event log contains two event attributes which are occurring in multiple activities

---

Table 1. Example event log
Case ID
Activity
Timestamp
Glucose
Value
Creatinine
Value
1
Admit to hospital
1
140
0.7
1
Treat in Medical Ward
2
200
0.7
1
Discharge Patient
3
120
0.8
2
Admit to hospital
1
135
0.6
2
Treat in ICU
2
175
0.6
2
Discharge Patient
3
110
0.7
and multiple times in a trace. Therefore, these are classiﬁed as dynamic. Hence, these
can be further ﬁltered by their degree of variability. The laboratory values of glucose
and creatinine have different scales, which makes a comparison by their variance (41
mg/dL vs. 0.05 mg/dL for case 1) useless. However, the CV as a relative measure results
in a comparable number for both variables (27% vs. 7% for case 1). Thus, the glucose
value has a higher degree of variability than the creatinine value in case 1, which can
also be conﬁrmed by looking at the values in the event log. The same can be calculated
for case 2, where the CV for the glucose value is 22%. Taking the average of both traces
results in an average CV of 24.5% for the glucose value.
The method to calculate the CV of a given event attribute eAt ∈EA for an event log
L ∈M(T) is formalized in two steps.
The ﬁrst step is to calculate the CV of eAt for each trace t ∈L′ representing a
process instance, where L′ is the event log including traces where the event attribute
occurs at least once, as deﬁned in equation 3. For that, the function CV (t) = t →CV
takes the event attribute values of a given trace and returns the CV of this sequence. The
multi-set CVeAt contains the CV of all traces in the event log L′.
CVeAt = {CV (t) : t ∈L′}
(5)
Having the CV of each trace for an event attribute eAt, this contribution deﬁnes the
degree of variation of an event attribute DegV areAt as the average CV of all traces in
the event log L′.
DegV areAt =
P
CV ∈CVeAt CV
|CVeAt|
(6)
The CV is only useful for event attributes having a ratio scale [15]. Ratio scale
variables are non-negative, which is not the case for all quantitative variables. For
example, the temperature is a quantitative variable, but its values can be negative. This
kind of variable is on a so-called interval ratio.
One reason why the CV is unsuitable for negative values is the danger of having
a mean close to zero, which would distort the CV, as the standard deviation is divided
by the mean to calculate it [18]. Dealing with negative event attributes can be solved
by shifting all data points by adding all numbers with the absolute of the minimum
value, such that the minimum becomes zero and the other numbers become positive. As
this contribution uses the CV for detecting variability, the actual values do not matter,

---

but only the distance between them. Therefore, this type of normalization is suitable
for dealing with negative data. For example, the sequence [−2, 2, 4] is transformed to
[0, 4, 6] by adding the absolute minimum value (2) to all numbers.
Additionally, if interval scale variables can be converted to different scales, such as
°C to °F, the CV can be manipulated. That is due to the fact, that the ratios between two
temperature measurements in °C or °F are not deﬁned, as 40 °C is not twice as warm as
20 °C. Therefore, the ratios change when converting the values, and with that the degree
of variability measured by the CV. This can be solved by converting the variables to a
ratio scale, as, for example, the temperature can be measured in °K, which is on a ratio
scale.
Looking at categorical data, it is not possible to calculate the mean and standard
deviation of all categorical event attributes, as some of them might be encoded as strings.
However, a technique is proposed to transform categories into numerical values to
calculate the CV. The transformation is based on [18]: The so-called mapping method
maps the categories of an event attribute eAt with discrete values from 1 to n, with
n being the total number of categories. First, the frequency of all possible values of
eAt is obtained, where the values are sorted according to their frequency. Then, the
mapping is performed by assigning the discrete values from 1 to n to the categories
of eAt, corresponding to their position in the sorted frequency list. Using the mapped
values, a feasible numerical representation for CV calculation is available.
Next, this approach is evaluated on a real-world healthcare data set, provided by the
MIMIC-IV database.
5
Evaluation
The proposed approach was implemented in ProM as an extension of the data-enhanced
process model implementation, which is based on the inductive visual miner1. The
implementation is available on GitHub, which can be downloaded2. The relevance of
this approach is illustrated in a medical environment, where an event log was extracted
from the Medical Information Mart for Intensive Care IV (MIMIC-IV) database. The
reason for creating an event log from this database is to illustrate an example, where
event attributes are available which are measured throughout the whole process, such as
laboratory values or vital signs.
5.1
Dataset
MIMIC-IV is a relational database representing the whole patient journey through a
hospital, including procedures performed, medications given, laboratory values taken,
image analysis conducted, and more. Its purpose is to support research in healthcare and
is therefore publicly available [19].
1 https://github.com/jcremerius/Data-Enhanced-Process-Models
2 https://github.com/jcremerius/Supporting-Domain-Data-Selection
-in-DEP

---

The event log extracted from MIMIC-IV incorporates a high-level process, where the
patient journey through different hospital departments, such as emergency department,
medical ward or intensive care unit (ICU), is stored. The event log contains 1050 hospital
process instances with 8646 events of heart failure patients treated in the ICU.
An event can have up to 67 event attributes, including laboratory values, vital signs,
status scores, and demographic information. The number of available event attributes
could be much higher in such a hospital process (imaging data, medications, procedures,
and more), where this event log focusses on the most prevalent values from the MIMIC-
IV database only. Thus, it contains 52 laboratory value measurements, 6 demographic
data points, and 9 ICU related measurements (vital signs and status scores).
5.2
Results
We applied the approach explained in Section 4 on the dataset introduced above. Thus,
the event attributes were separated according to their quantitative or categorical type.
Then, these were classiﬁed according to their process characteristic and the CV was
calculated for the dynamic event attributes. This information can then be used to ﬁnd the
event attribute of interest to be displayed in a data-enhanced process model, which is
illustrated in Fig. 1.
Figure 1. Attribute selection view showing dynamic event attributes
At the top, the view shows the selected activity and the means of aggregation, whereas
at the bottom two lists are illustrated, which show the separation between quantitative
and categorical event attributes. The selection list above the two lists allows ﬁltering
according to the three process characteristics. The two sliders at the bottom allow further
ﬁltering of dynamic domain data according to the CV(%).
The event attributes are separated by their quantitative or categorical type. The
quantitative variables include the actual values of the measurements conducted, whereas
the categorical event attributes include booleans indicating an abnormal laboratory value
or strings describing the insurance or admission location of a patient. We used a threshold
th of 0.05 to separate domain data, where all quantitative and categorical data types
were identiﬁed correctly.
With the help of the proposed ﬁltering techniques, the number of event attributes to
choose from can be reduced signiﬁcantly. The two boxes at the bottom of Fig. 1 show the

---

result of an arbitrary ﬁltering process, where event attributes having a dynamic process
characteristic are shown, which are in the speciﬁed CV range illustrated by the sliders.
The activity "Medical ICU" has 26 quantitative and 26 categorical laboratory value
measurements which are dynamic. It has none static and 11 semi-dynamic event attributes.
Laboratory values are measured in completely different scales. Nevertheless, these can
be compared by their degree of variability, where the laboratory value of “Glucose”
has a relatively high degree of variability with a CV of 12.7%. On the other hand, the
categorical variable “Abnormal Hemoglobin” has a relatively low degree of variability
in the process, with a CV of 2.7%. Thus, the view can be modiﬁed, so that there is
only a comprehensible amount of event attributes left for selection. When selecting the
desired event attribute, the preferred aggregation can be chosen, which can then be either
displayed solely at the selected activity or at all activities using the event attribute.
Fig. 2 illustrates a data-enhanced process model with event attributes selected based
on the information ﬁltering. We decided to show the mean of the quantitative event
attributes to represent the whole patient group. It can be seen, that the laboratory value
of “Glucose” varies throughout the process, as it is between 144 mg/dL and 148 mg/dL
during treatment and then drops to 125 mg/dL after treatment in the “Post-ICU” and
“Discharged” activities. On the other hand, the laboratory value of “Red Cell Distribution
Width (RDW)” barely changes during process execution and remains at 16% for the
patients with heart failure, which is also represented by a CV of 1.3%.
Figure 2. Data-enhanced process model with event attributes selected based on their process
behaviour. RDW: Red Cell Distribution Width
The same can be observed for the categorical event attributes, where “Abnormal
Phosphate” (CV: 14.4%) varies and “Abnormal Hemoglobin” (CV: 2.7%) remains similar
throughout the process. Additionally, the activity “Emergency Department” has three
static event attributes including age, insurance, and ethnicity, which are only available
for this activity. That is the case for the “discharge_location” at the activity “Discharged”
as well. The “Temperature F” is a semi-dynamic event attribute, which is exclusively
measured at the three ICU wards, where heart failure patients in this process stay only
once during their hospitalization. This discussion shows, that domain data selection by
expert users is signiﬁcantly improved by the techniques proposed in this paper, because
it is already known during the ﬁltering process, whether domain data is used at the
selected activity only or evolves throughout the process, and, if so, to which degree event
attributes are sensitive to the process.

---

6
Discussion
This paper suggests a method to classify domain data according to their process charac-
teristics and measuring their degree of variability, which is used to ﬁlter event attributes.
With that, data-based exploration in data-enhanced process models should be improved
by reducing information overloading when process analysts together with domain experts
look for domain data of interest.
Supporting information ﬁltering based on process characteristics and the degree of
variability goes hand-in-hand with the process analysis possibilities of data-enhanced
process models. These include Monitoring event attribute values and Comparison of
process activities, suggesting observing, whether an event attribute is changing through-
out the process or identifying differences between event attribute values in different
activities [2]. With the approach presented in this contribution, it can be determined,
if an event attribute is changing and, if so, at what degree in comparison to others.
By displaying that event attribute as an event attribute aggregation in a data-enhanced
process model, the activities causing the variability can be identiﬁed.
This contribution suggests using the CV as a measure of variability, which was
chosen based on current research dealing with change detection. The evaluation shows
promising results to use the CV as a measure to compare the degree of variability
between different event attributes. However, the need of converting domain data being
on an interval ratio or categorical still leaves room for improvement.
It should be noted, that this kind of analysis is of explorative nature and not cre-
ating any causal evidence. The whole concept of data-enhanced process models aims
at enhancing the ability of process exploration in process mining by supporting the
visualization of event attributes, which gives a ﬁrst impression on the behaviour of
domain data in the process.
7
Conclusion and Future Work
This contribution researches methods to ﬁlter domain data, supporting domain experts
and process analysts to ﬁnd the information of interest. The proposed mechanisms allow
reducing the number of event attributes to choose from to a comprehensive amount by
ﬁltering them according to their process characteristics and their degree of variability.
Future work could focus on enhancing the methodology and evaluation. For example,
further ﬁltering mechanisms can be developed, such as a comparison of semi-dynamic
attributes regarding their difference between activities. The differentiation between
categorical and quantitative event attributes could also be improved by applying further
methods, such as machine learning techniques, to automatically identify the most suitable
threshold for an event log. Additional evaluation by talking to domain experts or applying
the approach to more use cases could be conducted as well.

---

References
1. van der Aalst, W.: Process Mining. Springer Berlin Heidelberg (2016)
2. Cremerius, J., Weske, M.: Data-enhanced process models in process mining (2021), https:
//arxiv.org/abs/2107.00565
3. Acute and chronic heart failure guidelines, https://www.escardio.org/Guideli
nes/Clinical-Practice-Guidelines/Acute-and-Chronic-Heart-Fai
lure
4. Laposata, M.: Laboratory medicine: the diagnosis of disease in the clinical laboratory.
McGraw-Hill Education Medical (2014)
5. Dash, S., Shakyawar, S.K., Sharma, M., Kaushik, S.: Big data in healthcare: management,
analysis and future prospects. Journal of Big Data 6(1) (Jun 2019)
6. Liang, J., Huang, M.L.: Highlighting in information visualization: A survey. In: 2010 14th
International Conference Information Visualisation. IEEE (Jul 2010)
7. Peffers, K., Tuunanen, T., Gengler, C., Rossi, M., Hui, W., Virtanen, V., Bragge, J.: The design
science research process: A model for producing and presenting information systems research.
Proceedings of First International Conference on Design Science Research in Information
Systems and Technology DESRIST (02 2006)
8. Mannhardt, F., de Leoni, M., Reijers, H.: The multi-perspective process explorer. vol. 1418
(08 2015)
9. Mannhardt, F., de Leoni, M., Reijers: Heuristic mining revamped: An interactive, data-aware,
and conformance-aware miner (09 2017)
10. Bozorgi, Z., Teinemaa, I., Dumas, M., La Rosa, M., Polyvyanyy, A.: Process mining meets
causal machine learning: Discovering causal rules from event logs. pp. 129–136 (10 2020)
11. Xu, H., Pang, J., Yang, X., Yu, J., Li, X., Zhao, D.: Modeling clinical activities based on
multi-perspective declarative process mining with openEHR’s characteristic. BMC Medical
Informatics and Decision Making 20(S14) (Dec 2020)
12. Radke, R., Andra, S., Al-Kofahi, O., Roysam, B.: Image change detection algorithms: a
systematic survey. IEEE Transactions on Image Processing 14(3), 294–307 (2005)
13. Koeniguer, E., Nicolas, J.M.: Change detection based on the coefﬁcient of variation in sar
time-series of urban areas. Remote Sensing 12, 2089 (06 2020)
14. de Leoni, M., van der Aalst, W.M., Dees, M.: A general process mining framework for
correlating, predicting and clustering dynamic behavior based on event logs. Information
Systems 56, 235–257 (Mar 2016)
15. Brown, C.E.: Coefﬁcient of Variation, pp. 155–157. Springer Berlin Heidelberg, Berlin,
Heidelberg (1998)
16. Valera, I., Ghahramani, Z.: Automatic discovery of the statistical types of variables in a dataset.
In: Precup, D., Teh, Y.W. (eds.) Proceedings of the 34th International Conference on Machine
Learning. Proceedings of Machine Learning Research, vol. 70, pp. 3521–3529. PMLR (06–11
Aug 2017), http://proceedings.mlr.press/v70/valera17a.html
17. Graham, R.L., Knuth, D.E., Patashnik, O.: Concrete Mathematics: A Foundation for Computer
Science. Addison-Wesley Longman Publishing Co., Inc., USA, 2nd edn. (1994)
18. Bindu, K., Morusupalli, R., Dey, N., Rao, C.: Coefﬁcient of Variation and Machine Learning
Applications (10 2019)
19. Johnson, A., Bulgarelli, L., Pollard, T., Horng, S., Celi, L.A., Mark, R.: Mimic-iv (2020),
https://physionet.org/content/mimiciv/1.0/

---

