# Data Processing Framework for Ship Performance Analysis

> 来源: https://arxiv.org/pdf/2202.01000

Highlights
Data Processing Framework for Ship Performance Analysis
Prateek Gupta,Young-Rong Kim,Sverre Steen,Adil Rasheed
• Ship’s hydrodynamic performance can be assessed using the data from ship-in-service
• Data can be recorded onboard the ship, obtained via AIS or as noon reports
• Gathered data needs to be cleaned and processed for performance analysis
• A standardized data processing framework for preparing the data is developed
• Data processing framework can be easily casted for processing any similar datasets
arXiv:2202.01000v1  [cs.DB]  2 Feb 2022

---

Data Processing Framework for Ship Performance Analysis
Prateek Guptaa,∗, Young-Rong Kima, Sverre Steena and Adil Rasheedb
aNorwegian University of Science and Technology (NTNU), Department of Marine Technology, Trondheim, 7052, Sør-trondelag, Norway
bNorwegian University of Science and Technology (NTNU), Department of Engineering Cybernetics, Trondheim, 7034, Sør-trondelag, Norway
A R T I C L E I N F O
Keywords:
Ship in-service data
AIS data
Noon reports
Metocean hindcast data
Data processing
Ship performance analysis
A B S T R A C T
The hydrodynamic performance of a sea-going ship can be analysed using the data obtained from
the ship. Such data can be gathered from diﬀerent sources, like onboard recorded in-service data,
AIS data, and noon reports. Each of these sources is known to have their inherent problems. The
current work gives a brief introduction to these data sources as well as the common problems
associated with them, along with some examples. In order to resolve most of these problems,
a streamlined semi-automatic data processing framework for fast data processing is developed
and presented here. The data processing framework can be used to process the data obtained
from any of the above three mentioned sources. The framework incorporates processing steps
like interpolating weather hindcast (metocean) data to ship’s location in time, deriving additional
features, validating data, estimating resistance components, data cleaning, and outlier detection.
A brief description of each of the processing steps is provided with examples from existing
datasets. The processed data can be further used to analyse the hydrodynamic performance of a
ship.
1. Introduction
The performance of a sea-going ship is important not only to keep the fuel and operational cost in-check but also
to reduce global emissions from the shipping industry. Analyzing the performance of a ship is also of great interest for
charter parties to estimate the potential of a ship and the proﬁt that can be made out of it. Therefore, driven by both the
economic and social incentives, the trade of ship performance analysis and monitoring has been booming substantially
in recent times. The importance of in-service data in this context is very well understood by most of the stake holders,
clearly reﬂected by the amount of investment made by them on onboard sensors, data acquisition systems, and onshore
operational performance monitoring and control centers.
The traditional way to evaluate the performance of a ship is using the noon report data provided by the ship’s crew.
A more exact approach, but not very feasible for commercial vessels, was suggested by Walker and Atkins (2007),
conducting in-service sea trials in calm-water conditions on a regular basis. With the advent of sensor-based continuous
monitoring systems, the current trend is to directly or indirectly observe the evolution of the calm-water speed-power
curve over time. ISO 19030 ISO (2016) along with several researchers (Koboević et al. (2019); Coraddu et al. (2019))
recommends observing the horizontal shift (along the speed axis) of the calm-water speed-power curve, termed as
the speed-loss, over time to monitor the performance of a sea-going ship using the in-service data. Alternatively, it
is suggested to observe the vertical shift of the calm-water speed-power curve, often termed as the change in power
demand (adopted by Gupta et al. (2021a) and Carchen and Atlar (2020)). Some researchers also formulated and used
some indirect performance indicators like fuel consumption (Koboević et al. (2019)), resistance (or fouling) coeﬃcient
(Munk (2016); Foteinos et al. (2017); Carchen and Atlar (2020)), (generalized) admiralty coeﬃcient (Ejdfors (2019);
Gupta et al. (2021b)), wake fraction (Carchen and Atlar (2020)), fuel eﬃciency (Kim et al. (2021)), etc. In each of
these cases, it is clearly seen (and most of the time acknowledged) that the results are quite sensitive to the quality of
the data used to estimate the ship’s performance.
The ship’s performance-related data obtained from various sources usually inherits some irregularities due to
several factors like sensor inaccuracies, vibration of the sensor mountings, electrical noise, variation of environment,
etc., as pointed out in the Guide for Smart Functions for Marine Vessels and Oﬀshore Units (Smart Guide) published
recently by American Bureau of Shipping (2020). The quality of data used to carry-out ship performance analysis
∗Corresponding author
prateek.gupta@ntnu.no (P. Gupta); youngrong.kim@ntnu.no (Y. Kim); sverre.steen@ntnu.no (S. Steen);
adil.rasheed@ntnu.no (A. Rasheed)
ORCID(s): 0000-0001-7147-0868 (P. Gupta)
P. Gupta, Y.-R. Kim, S. Steen, A. Rasheed: Preprint submitted to Elsevier
Page 1 of 22

---

Data Processing Framework for Ship Performance Analysis
and the results obtained further can be signiﬁcantly improved by adopting some rational data processing techniques, as
shown by Liu et al. (2020) and Kim et al. (2020). Another important factor is the source of data as it may also be possible
to obtain such datasets using the publicly available AIS data (You et al. (2017)). Dalheim and Steen (2020b) presented
a data preparation toolkit based on the in-service data recorded onboard 2 ships. The presented toolkit was developed
for a speciﬁc type of dataset, where the variables were recorded asynchronously and had to be synchronized before
carrying-out ship performance analysis. The current work would rather focus on challenges faced while processing an
already synchronized dataset.
The current paper presents a review of diﬀerent data sources used for ship performance analysis and monitoring,
namely, onboard recorded in-service data, AIS data, and noon reports, along with the characteristics for each of these
data sources. Finally, a data processing framework is outlined which can be used to prepare these datasets for ship
performance analysis and monitoring. Although the data processing framework is developed for the performance
monitoring of ships, it may easily be casted for several other purposes. With the easy availability of data from ships,
the concept of creating digital twins for sea-going ships is becoming quite popular. Major et al. (2021) presented the
concept of digital twin for a ship and the cranes onboard it. The digital twin established by Major et al. (2021) can
be used to perform three main oﬀshore operations, including remote monitoring of the ship, maneuvering in harsh
weather and crane operations, from an onshore control center. Moreover, as pointed out by Major et al. (2021), the
digital twin technology can also be adopted for several other purposes, like predictive maintenance, ship autonomy,
etc. Nevertheless, the data processing framework presented here can also be used to process the real-time data obtained
to create digital twins for ships in an eﬃcient manner.
The following section discusses the art of ship performance analysis and the bare minimum characteristics of
a dataset required to do such an analysis. Section 3 presents the above mentioned sources of data used for ship
performance analysis, their characteristics, and the tools required to process these datasets. Section 4 presents the
data processing framework which can be used to process and prepare these datasets for ship performance monitoring.
Finally, section 5 ﬁnishes the paper with concluding remarks.
2. Ship Performance Analysis
The performance of a ship-in-service can be assessed by observing its current performance and, then, comparing
it to a benchmarking standard. There are several ways to establish (or obtain) a benchmarking standard, like model
test experiments, full-scale sea trials, CFD analysis, etc. It may even be possible to establish a benchmarking standard
using the in-service data recorded onboard a newly built ship, as suggested by Coraddu et al. (2019) and Gupta et al.
(2021b). On the other hand, evaluating the current performance of a ship requires a good amount of data processing as
the raw data collected during various voyages of a ship is susceptible to noise and errors. Moreover, the benchmarking
standard is, generally, established for only a given environmental condition, most likely the calm-water condition. In
order to draw a comparison between the current performance and the benchmarking standard, the current performance
must be translated to the same environmental condition, therefore, increasing the complexity of the problem.
2.1. Bare Minimum Variables
For translating the current performance data to the benchmarking standard’s environmental condition and carrying-
out a reliable ship performance analysis, a list of bare minimum variables must be recorded (or observed) at a good
enough sampling rate. The bare minimum list of variables must provide the following information about each sampling
instant for the ship: (a) Operational control, (b) Loading condition, (c) Operational environment, and (d) Operating
point. The variables containing the above information must either be directly recorded (or observed) onboard the
ship, collected from regulatory data sources such as AIS, or may be derived using additional data sources, like the
operational environment can be easily derived using the ship’s location and timestamp with the help of an appropriate
weather hindcast (or metocean) data repository.
The operational control information should contain the values of the propulsion-related control parameters set by
the ship’s captain on the bridge, like shaft rpm, rudder angle, propeller pitch, etc. The shaft rpm (or propeller pitch, in
case of ships equipped with controllable pitch propellers running at constant rpm) is by far the most important variable
here as it directly correlates with the ship’s speed-through-water. It should be noted that even in the case of constant
power or speed mode, the shaft rpm (or propeller pitch) continues to be the primary control parameter as the set power
or speed is actually achieved by using a real-time optimizer (incorporated in the governor) which optimizes the shaft
rpm (or propeller pitch) to get to the set power or speed. Nevertheless, in case the shaft rpm (or propeller pitch) is not
P. Gupta, Y.-R. Kim, S. Steen, A. Rasheed: Preprint submitted to Elsevier
Page 2 of 22

---

Data Processing Framework for Ship Performance Analysis
Table 1
The list of bare minimum data variables required for ship performance analysis.
Category
Variables
Operational Control
Shaft rpm, Rudder angle, & Propeller pitch
Loading Condition
Fore and aft draft
Operational Environment
Longitudinal and transverse wind speed, Signiﬁcant wave height,
Relative mean wave direction, & Mean wave period
Operating Point
Shaft power & Speed-through-water
available, it may be appropriate to use the ship’s speed-through-water as an operational control parameter, as done by
several researchers (Farag and Ölçer (2020); Laurie et al. (2021); Minoura et al. (2021); Liang et al. (2019)), but in this
case, it should be kept in mind that, unlike the shaft rpm (or propeller pitch), the speed-through-water is a dependant
variable strongly inﬂuenced by the loading condition and the operational environment.
The loading condition should contain the information regarding the ship’s fore and aft draft, which can be easily
recorded onboard the ship. Although the wetted surface area and under-water hull-form are more appropriate for a
hydrodynamic analysis, these can be derived easily using the ship’s hull form, if the fore and aft draft is known. The
operational environment should at least contain variables indicating the intensity of wind and wave loads acting on
the ship, like wind speed and direction, signiﬁcant wave height, mean wave direction, mean wave period, etc. Finally,
the operating point should contain the information regarding the speed-power operating point for the sampling instant.
Table 1 presents the list of bare minimum variables required for ship performance analysis. The list given in the table
may have to be modiﬁed according to ship speciﬁcations, for example, the propeller pitch is only relevant for a ship
equipped with a controllable pitch propeller.
2.2. Best Practices
It is well-known that the accuracy of various measurements is not the same. It also depends on the source of the
measurements. The measurements recorded using onboard sensors are generally more reliable as compared to the
manually recorded noon report measurements, due to the possibility of human error in the latter. Even in the case of
onboard recorded sensor measurements, the accuracy varies from sensor-to-sensor and case-to-case. Some sensors can
be inherently faulty, whereas others can give incorrect measurements due to unfavorable installation and operational
conditions, and even the best ones are known to have some measurement noise. Thus, it is recommended to establish
and follow some best practices for a reliable and robust ship performance analysis.
The onboard measurements for shaft rpm (푛) and shaft torque (휏) are generally obtained using a torsion meter
installed on the propeller shaft, which is considered to be quite reliable. The shaft power (푃푠) measurements are
also derived from the same as the shaft power is related to the shaft rpm and torque through the following identity:
푃푠= 2휋푛휏. It should be noted that no approximation is assumed in this formulation and, therefore, it should be validated
with the data, if all three variables (푛, 휏, 푃푠) are available. On the other hand, the measurements for speed-through-water
are known to have several problems, as presented by Dalheim and Steen (2021). Thus, it is recommended to use shaft
rpm (and not speed-though-water) as the independent variable while creating data-driven regression models to predict
the shaft power. Owing to the same reason, it may also be a good idea to quantify the change in ship’s performance in
terms of change in power demand rather than speed-loss (or speed-gain), as recommended by ISO 19030 ISO (2016).
Further, it is also quite common to use fuel oil consumption as a key performance indicator for ship performance
analysis (Karagiannidis and Themelis (2021)). The fuel oil consumption can be easily calculated from the engine
delivered torque and engine rpm, if the speciﬁc fuel consumption (SFC) curve for the engine is known. Even though the
SFC curve is established and supplied by the engine manufacturer, it is only valid for a speciﬁc operating environment,
and it is known to evolve over time due to engine degradation and maintenance. Thus, including the fuel oil consumption
in ship performance analysis increases the complexity of the problem, which requires taking engine health into
account. If the objective of ship performance analysis is also to take into account the engine performance, then it
may be beneﬁcial to divide the problem into two parts: (a) Evaluate the change in power demand (for hydrodynamic
performance analysis), and (b) Evaluate the change in engine SFC (for engine performance analysis). Now, the latter
can be formulated as an independent problem with a completely new set of variables-of-interest, like engine delivered
torque, engine rpm, ambient air temperature, caloriﬁc value of fuel, turbocharger health, etc. This would not only
improve the accuracy of ship’s hydrodynamic performance analysis but would also allow the user to develop a more
P. Gupta, Y.-R. Kim, S. Steen, A. Rasheed: Preprint submitted to Elsevier
Page 3 of 22

---

Data Processing Framework for Ship Performance Analysis
comprehensive and, probably, accurate analysis model. The current work is focused on the hydrodynamic performance
analysis.
2.3. Sampling Frequency
Almost all electronics-based sensors are known to have some noise in their measurements. The simplest way
adopted to subdue this noise is by taking an average over a number of measurements (known as a ‘sample’ in
statistics), recorded over a very short period of time (milliseconds). It is also known that the statistical mean of a
‘sample’ converges to the true mean (i.e., the mean of the entire population), thereby eliminating the noise, as the
number of measurements in the ‘sample’ is increased, provided the observations follow a symmetrical distribution.
Nevertheless, it is observed that the high frequency data still retains some noise, probably due to the fact that the
number of measurements in each ‘sample’ is small, i.e., the measurements are obtained by averaging a small number
of samples recorded over a very short period of time. On the other hand, as seen in the case of noon reports and most of
the in-service datasets, time-averaging the measurements over a longer period of time obscures the eﬀect of moderately
varying inﬂuential factors, for example, instantaneous incident wind and waves, response motions, etc. Thus, a very
high sampling frequency data may retain high noise, and a very low sampling frequency data, with time-averaged
values, may result in obscuring important eﬀects from the data time-series. Furthermore, in the third scenario, it may
be possible that the data acquisition (DAQ) system onboard the ship is simply using low sampling frequency, recording
instantaneous values instead of time-averaged ones, saving a good amount of storage and bandwidth while transmitting
it to the shore-based control centers. These low frequency instantaneous values may result in an even more degraded
data quality as it would contain noise as well as obscure the moderately varying eﬀects.
The ideal sampling frequency would also depend on the objective of the analysis and the recorded variables.
For example, if the objective of the analysis is to predict the motion response of a ship or analyse its seakeeping
characteristics, the data should be recorded at a high enough sampling frequency such that it is able to capture such
eﬀects. Hansen et al. (2011) analyzed the ship’s rudder movement and the resulting resistance, and demonstrated that if
the sampling interval would be large, the overall dynamics of the rudder movement would not be captured, resulting in
a diﬀerence in resistance. One criterion for selecting the data sampling rate is Nyquist frequency (Jerri (1977)), which
is widely used in signal processing. According to this criterion, the sampling frequency shall be more than twice the
frequency of the observed phenomenon to suﬃciently capture the information regarding the phenomenon. Therefore,
if the aim is not to record any information regarding the above mentioned moderately varying eﬀects (instantaneous
incident wind and waves, response motions, etc.), it may be acceptable to just obtain low frequency time-averaged
values so that such eﬀects are subdued. But it may still be useful to obtain high frequency data, in this case, as it can
be advantageous from data cleaning point of view. For example, the legs of time-series showing very high variance,
due to the noise or moderately varying eﬀects, can be removed from the analysis to increase the reliability of results.
3. Data Sources, Characteristics & Processing Tools
3.1. In-service Data
The in-service data, referred to here, is recorded onboard a ship during its voyages. This is achieved by installing
various sensors onboard the ship, collecting the measurements from these sensors on a regular basis (at a predeﬁned
sampling rate) using a data acquisition (DAQ) system, and fetching the collected data to onshore control centers. The
two most important features of in-service data is the sampling rate (or, alternatively, sampling frequency) and the list
of recorded variables. Unfortunately, there is no proper guide or standard which is followed while deﬁning both these
features for a ship. Thus, the in-service data processing has to be adapted to each case individually.
The in-service datasets used here are recorded over a uniform (across all recorded variables) and evenly-spaced
sampling interval, which makes it easier to adopt and apply data processing techniques. In an otherwise case, where
the data is sampled with a non-uniform and uneven sampling interval, some more pre-processing has to be done in
order to prepare it for further analysis, as demonstrated by Dalheim and Steen (2020b). Dalheim and Steen (2020b)
presented a detailed algorithm to deal with time vector jumps and synchronizing non-uniformly recorded data variables.
The problem of synchronization can, alternatively, be looked at using the well-known dynamic time warping (DTW)
technique, which is generally used for aligning the measurements taken by two sensors, measuring the same or highly
correlated features. In a diﬀerent approach, Virtanen et al. (2020) demonstrated that the collected data can be down-
sampled or up-sampled (resampling) to obtain a uniform and evenly sampled dataset.
P. Gupta, Y.-R. Kim, S. Steen, A. Rasheed: Preprint submitted to Elsevier
Page 4 of 22

---

Data Processing Framework for Ship Performance Analysis
3.1.1. Inherently Faulty & Incorrect Measurements
Some of the sensors onboard a ship can be inherently faulty and provide incorrect measurements due to unfavorable
installation or operational conditions. Many of these can actually be ﬁxed quite easily. For instance, Wahl (2019)
presented the case of faulty installation of the wind anemometer onboard a ship, resulting in missing measurements for
head-wind condition probably due to the presence of an obstacle right in front of the sensor. Such a fault is fairly simple
to deal with, say, by ﬁxing the installation of the sensor, and it is even possible to ﬁx the already recorded dataset using
the wind measurements from one of the publicly available weather hindcast datasets. Such an instance also reﬂects
the importance of data exploration and validation for ship performance analysis. Unlike above, the case of draft and
speed-through-water measurement sensors is not as fortunate and easy to resolve.
The ship’s draft is, generally, recorded using a pressure transducer installed onboard the ship. The pressure
transducer measures the hydrostatic pressure acting on the bottom plate of the ship which is further converted into
the corresponding water level height or the draft measurement. When the ship starts to move and the layer of water
in contact with the ship develops a relative velocity with respect to the ship, the total pressure at the ship’s bottom
reduces due to the non-zero negative hydrodynamic pressure and, therefore, further measurements taken by the draft
sensor are incorrect. This is known as the Venturi eﬀect. It may seem like a simple case, and one may argue that the
measurements can be ﬁxed by just adding the water level height equivalent to the hydrodynamic pressure, which may
be calculated using the ship’s speed-through-water. Here, it should be noted that, ﬁrstly, to accurately calculate the
hydrodynamic pressure, one would need the localized relative velocity of the ﬂow (and not the ship’s speed-through-
water), which is impractical to measure, and secondly, the speed-though-water measurements are also known to have
several sources of inaccuracy. Alternatively, it may be possible to obtain the correct draft measurements from the ship’s
loading computer. The loading computer can calculate the draft and trim in real-time based on the information such as
the ship’s lightweight, cargo weight and distribution, and ballast water loading conﬁguration.
The state-of-the-art speed-though-water measurement device uses the Doppler acoustic speed log principle. Here,
the relative speed of water around the hull (i.e., the speed-though-water) is measured by observing the shift in frequency
(popularly known as the Doppler shift) of the ultrasound pulses emitted from the ship’s hull, due to its motion. The
ultrasonic pulses are reﬂected by the ocean bottom, impurities in the surrounding water, marine life, and even the
liquid-liquid interface between the density diﬀerence layers in deep ocean. The speed of water surrounding the ship is
inﬂuenced by the boundary layer around the hull so it is required that the ultrasonic pulses reﬂected only by the particles
outside the boundary layer are used to estimate the speed-though-water. Therefore, a minimum pulse travelling distance
has to be prescribed for the sensor. If the prescribed distance is too larger or if the ship is sailing in shallow waters,
the Doppler shift is calculated using the reﬂection from the ocean bottom, i.e., the sensor is in ground-tracking mode,
and therefore, it would clearly record the ship’s speed-over-ground instead of the speed-though-water. Dalheim and
Steen (2021) presented a detailed account regarding the uncertainty in the speed-though-water measurements for a
ship, commenting that the speed log sensors are considered to be one of the most inaccurate ones onboard the ship.
It may also be possible to estimate the speed-though-water of a ship using the ship’s speed-over-ground and incident
longitudinal water current speed. The speed-over-ground of a ship is measured using a GPS sensor, which is considered
to be quite accurate, but unfortunately, the water current speed is seldom recorded onboard the ship. It is certainly
possible to obtain the water current speed from a weather hindcast data source, but the hindcast measurements are not
accurate enough to obtain a good estimate for speed-through-water, as indicated by Antola et al. (2017). It should also
be noted that the temporal and spatial resolution of weather hindcast data is relatively larger than the sampling interval
of the data recorded onboard the ship. Moreover, the water current speed varies along the depth of the sea, therefore,
the incident longitudinal water current speed must be calculated as an integral of the water current speed proﬁle over
the depth of the ship. Thus, in order to obtain accurate estimates of speed-though-water, the water current speed has
to be measured or estimated upto a certain depth of the sea with good enough accuracy, which is not possible with the
current state-of-the-art.
3.1.2. Outliers
Another big challenge with data processing is the problem of detecting and handling outliers. As suggested by
Olofsson (2020), it may be possible to categorize outliers into the following two broad categories: (a) Contextual
outliers, and (b) Correlation-defying outliers1. Dalheim and Steen (2020b) presented methods to detect and remove
contextual outliers, further categorized as (i) obvious (or invalid) outliers, (ii) repeated values, (iii) drop-outs, and
(iv) spikes. Contextual outliers are easily identiﬁable as they either violate the known validity limits of one or more
1Called collective outliers by Olofsson (2020).
P. Gupta, Y.-R. Kim, S. Steen, A. Rasheed: Preprint submitted to Elsevier
Page 5 of 22

---

Data Processing Framework for Ship Performance Analysis
recorded variables (as seen in the case of obvious outliers and spikes) or present an easily identiﬁable but anomalous
pattern (as seen in the case of repeated values and drop-outs).
The case of correlation-defying outliers is much more diﬃcult to handle, as they can easily blend into the cleaned
data pool. The two most popular methods which can be used to identify correlation-defying outliers are Principal
Component Analysis (PCA) and autoencoders. Both these methods try to reconstruct the data samples after learning
the correlation between the variables. It is quite obvious that a correlation-defying outlier would result in an abnormally
high reconstruction error and, therefore, can be detected using such techniques. In a recent attempt, Thomas and Judith
(2021) demonstrated an ensemble method combining PCA and autoencoders coupled with isolation forest to detect
such outliers.
3.1.3. Time-Averaging Problem
As aforementioned, the onboard recorded in-service data can be supplied as time-averaged values over a short
period of time (generally upto around 15 minutes). Although the time-averaging method eliminates white noise and
reduces the variability in the data samples, it introduces a new problem in case of angular measurements. The angular
measurements are, generally, recorded in the range of 0 to 360 degrees. When the measurement is around 0 or 360
degrees, it is obvious that the instantaneous measurements, reported by the sensor, will ﬂuctuate in the vicinity of 0 and
360 degrees. For instance, assuming that the sensor reports a value of about 0 degree for half of the averaging time and
about 360 degrees for the remaining time, the time-averaged value recorded by the data acquisition (DAQ) system will
be around 180 degrees, which is signiﬁcantly incorrect. Most of the angular measurements recorded onboard a ship,
like relative wind direction, ship heading, etc., are known to inherit this problem, and it should be noted that, unlike
the example given here, the incorrect time-averaged angle can take any value between 0 and 360 degrees, depending
on the instantaneous values over which the average is calculated.
Although it may be possible to ﬁx these incorrect values using a carefully designed algorithm, there is no established
method available at the moment. Thus, it is suggested to ﬁx these measurements using an alternate source for the data
variables. For example, the wind direction can be gathered easily from a weather hindcast data source. Thus, it can be
used to correct or just replace the relative wind direction measurements, recorded onboard the ship. The ship’s heading,
on the other hand, can be estimated using the latitude and longitude measurements from the GPS sensor.
3.2. AIS Data
AIS is an automatic tracking system that uses transceivers to help ships and maritime authorities identify and
monitor ship movements. It is generally used as a tool for ship transportation services to prevent collisions during
navigation. Ships over 300 tons must be equipped with transponders capable of transmitting and receiving all message
types of AIS under the SOLAS Convention. AIS data is divided into dynamic (position, course, speed, etc.) static
(ship name, dimensions, etc.), and voyage-related data (draft, destination, ETA, etc.). Dynamic data is automatically
transmitted every 2-10 seconds depending on the speed and course of the ship, and if anchored, such information is
automatically transmitted every 6 minutes. On the other hand, static and voyage-related data is provided by the ship’s
crew, and it is transmitted every 6 minutes regardless of the ship’s movement state.
Since dynamic information is automatically updated based on sensor data, it is susceptible to faults and errors,
similar to those described in section 3.1.1. In addition, problems may occur even in the process of collecting and
transmitting data between AIS stations, as noted by Weng et al. (2020). The AIS signal can also be inﬂuenced by
external factors, such as weather conditions and Earth’s magnetic ﬁeld, due to their interference with the very high
frequency (VHF) equipment. Therefore, some of the AIS messages are lost or get mixed. Moreover, the receiving station
has a short time slot during which the data must be received, and due to heavy traﬃc in the region, it fails to receive
the data from all the ships in that time. In some cases, small ships deliver inaccurate information due to incorrectly
calibrated transmitters, as shown by Weng et al. (2020). In a case study, Harati-Mokhtari et al. (2007) observed that
2% of the MMSI (Maritime Mobile Service Identity) information was incorrect and 30% of the ships were not properly
marked with the correct navigation status. In the case of ship dimensions, about 18% of the information was found to be
inaccurate. Therefore, before using AIS raw data for ship performance analysis, it is necessary to check key parameters
such as GPS position, speed, and course, and the data identiﬁed as incorrect must be ﬁxed.
3.2.1. Irrational Speed Data
The GPS speed (or speed-over-ground) measurements from AIS data may contain samples that have a sudden
jump compared to adjacent samples or excessively higher or lower value than the normal operating range. This type of
P. Gupta, Y.-R. Kim, S. Steen, A. Rasheed: Preprint submitted to Elsevier
Page 6 of 22

---

Data Processing Framework for Ship Performance Analysis
Table 2
Typical service speed range of diﬀerent ship types, given by Solutions (2018).
Category
Type
Service speed (knot)
Tanker
Crude oil carrier
13-17
Gas tanker/LNG carrier
16-20
Product
13-16
Chemical
15-18
Bulk carrier
Ore carrier
14-15
Regular
12-15
Container
Line carrier
20-23
Feeder
18-21
General cargo
General cargo
14-20
Coaster
13-16
Roll-on/roll-oﬀcargo
Ro-Ro/Ro-Pax
18-23
Passenger ship
Cruise ship
20-23
Ferry
16-23
inaccurate data can be identiﬁed through comparison with location and speed data of adjacent samples. The distance
covered by the ship at the corresponding speed during the time between the two adjacent AIS messages is calculated,
and the distance between the actual two coordinates is calculated using the Haversine formula (given by equation 1) to
compare the two values. If the diﬀerence between the two values is negligible, the GPS speed can be said to be normal,
but if not, it is recommended to be replaced with the GPS speed value of the adjacent sample. It should be noted that
if the time diﬀerence between the samples is too short, the deviation of the distance calculated through this method
may be large. In such a case, it is necessary to consider the average trend for several samples. If there are no valid
samples nearby or the GPS coordinate data is problematic, one can refer to the normal service speed according to the
ship type, as shown in table 2, or if available, a more speciﬁc method such as normalcy box (Rhodes et al. (2005); Tu
et al. (2017)), which deﬁnes the speed range of the ships according to the geographic location, may be applied.
퐷= 2푟sin−1
(√
sin2 (푦푖+1 −푦푖
2
)
+ cos (푦푖
) cos (푦푖+1
) sin2 (푥푖+1 −푥푖
2
))
(1)
Where 퐷is the distance between two coordinates (푥푖, 푦푖) and (푥푖+1, 푦푖+1), 푟is the radius of Earth, and (푥푖, 푦푖) is
the longitude and latitude at timestamp 푖.
3.2.2. Uncertainty due to Human Error
AIS data, excluding dynamic information, is not automatically updated by the sensors, but it is logged by the ship’s
crew manually, so there is a possibility of human error. This includes information such as the draft, navigation status,
destination, and estimated time of arrival (ETA) of the ship. Although it is diﬃcult to clearly distinguish the incorrectly
entered information, it is possible to indirectly determine whether the manual input values have been updated using the
automatically logged dynamic information. Each number in navigation status represents ship activity such as ‘under
way using engine (0)’, ‘at anchorage (1)’, and ‘moored (5)’. If this ﬁeld is being updated normally, it should be ‘0’ if
the ship is in-trip and ‘5’ if it is at berth. If the navigation status of the collected AIS data is ‘1’ or ‘5’ above a certain
GPS speed (or speed-over-ground), or if the state is set to ‘0’ even when the speed is 0 and the location is within the
port, the AIS data have not been updated on time and other manually entered information should also be questioned.
3.3. Noon Report Data
Ships engaged in international navigation of more than 500 gross tons are required to send a noon report to the
company, which brieﬂy records what happened on the ship from previous noon to present noon. The noon report must
basically contain suﬃcient information regarding the location, course, speed, and internal and external conditions
aﬀecting the vessel’s voyage. Additionally, the shipping company collects information related to fuel consumption
and remaining fuel onboard, propeller slip, average RPM, etc. as needed. Such information is often used as a ship’s
management tool and reference data, such as monitoring and evaluating ship’s performance, calculating energy
P. Gupta, Y.-R. Kim, S. Steen, A. Rasheed: Preprint submitted to Elsevier
Page 7 of 22

---

Data Processing Framework for Ship Performance Analysis
eﬃciency operating indicators, and obtaining fuel and freshwater order information. Despite its customary use, the
standardized information in the noon reports may not be suﬃcient to accurately assess the performance of the ship,
due to several problems discussed as follows. This information is based on the average values from noon to noon. For
an accurate ship performance analysis, higher frequency samples and additional data may be recommended.
3.3.1. Uncertainties due to Averaging Measurements & Human Error
Basically, information reported through the noon reports is created based on the measurement values of the
onboard sensor. Therefore, it also has the possibility to involve the problem of inherently faulty sensors and incorrect
measurements, as discussed in section 3.1.1. Apart from the problems caused by sensors, the noon report data may
have problems caused by the use of 24-hour averaged values and human errors. The data collection interval is once
a day and the average of the values recorded for 24 hours is reported, thus, signiﬁcant inaccuracies may be included
in the data. Aldous et al. (2015) performed a sensitivity analysis to assess the uncertainty due to the input data for
ship performance analysis using continuously recorded in-service data and noon reports. It was observed here that
the uncertainty of the outcome was signiﬁcantly sensitive to the number of samples in the dataset. In other words,
such uncertainty can be mitigated through the use of data representing longer time-series, data collection with higher
frequency, and data processing. These results were also conﬁrmed by Park et al. (2017) and Themelis et al. (2018).
Park et al. (2017) demonstrated in a case study that the power consumption between the noon reports and the recorded
sensor data diﬀered by 6.2% and 17.8% in ballast and laden voyage, respectively.
Using the averaged values over a long time period, as in the case of noon reports, the variations due to
acceleration/deceleration and maneuvering cannot be captured. In particular, in the case of ships that sail relatively
short voyages such as feeder ships and ferries, inappropriate data for performance analysis may be provided due to
frequent changes in the operational state. In the case of information regarding the weather and sea states, the information
generally corresponds to the condition right before the noon report is sent from the ship, therefore, it is not easy to
account for the changes in the performance of the ship due to the variation of weather conditions during the last 24
hours. In general, the information to be logged in the noon report is read and noted by a person from onboard sensors.
Thus, it is possible that the time at which the values are read from the sensors everyday may be diﬀerent as well as
diﬀerent sensors may be used for the values to be logged for the same ﬁeld. In addition, there may be cases when the
observed value is incorrectly entered into the noon report. Thus, if the process of preparing the noon reports is not
automated, there would always be a possibility of human errors in the data.
4. Results: Data Processing Framework
The results here are presented in the form of the developed data processing framework, which can be used to process
raw data obtained from one of the above mentioned data sources (in section 3) for ship performance analysis. The data
processing framework is designed to resolve most of the problems cited in the above section. Figure 1 shows the ﬂow
diagram for the data processing framework. The following sections will explain brieﬂy the consecutive processing steps
of the given ﬂow diagram. It may be possible that the user may not able to carry-out each step due to unavailability of
some information or features in the dataset, for example, due to the unavailability of the GPS data (latitude, longitude
and timestamp variables), it may not be possible to interpolate weather hindcast data. In such a case, it is recommended
to skip the corresponding step and continue with the next one.
The data processing framework has been outlined in such a manner that, after being implemented, it can be executed
in a semi-automatic manner, i.e., requiring limited intervention from the user. The semi-autonomous nature of the
framework would also result in fast data processing, which can be important for very large datasets. The implementation
of the framework in terms of executable code is also quite important to obtain a semi-automatic and fast implementation
of the data processing framework. Therefore, it is recommended to adopt best practices and optimized algorithms for
each individual processing step according to the programming language in use. On another note, the reliability of the
data processing activity is also quite critical to obtain good results. Therefore, it is important to carry-out the validation
of work done in each processing step by creating visualization (or plots) and inspecting them for any undesired errors.
The usual practice adopted here, while processing the data using the framework, is to create several such visualizations,
like time-series plots of data variables in trip-wise manner (explained later in section 4.2), at the end of each processing
step and then inspecting them to validate the outcome.
P. Gupta, Y.-R. Kim, S. Steen, A. Rasheed: Preprint submitted to Elsevier
Page 8 of 22

---

Data Processing Framework for Ship Performance Analysis
Raw Data
Ensure Uniform
Time Steps
Divide into Trips
Interpolate Hindcast
(Using GPS Data)
Weather Hindcast
Derive New Features
Interpolation
Error?
Validation Checks
Data Processing
Errors Detected?
Fix Draft & Trim
Calculate Hydrostatics
(Displacement, WSA, etc.)
Ship Particulars
Calculate Resistance
Components
Data Cleaning &
Outlier Detection
Processed Data
No
Yes
Yes
No
Figure 1: Data processing framework ﬂow diagram.
4.1. Ensure Uniform Time Steps
Ensuring uniform and evenly-spaced samples would not only make it easier to apply time-gradient-based data
processing or analysis steps but would also help avoid any misunderstanding while visualizing the data, by clearly
showing a gap in the time-series plots (when plotted against sample numbers) and removing any abrupt jumps in the
data values. Depending on the data acquisition (DAQ) system, the in-service data recorded onboard a ship is generally
recorded with a uniform and evenly spaced sampling interval. Nevertheless, it is observed that the extracted sub-dataset
P. Gupta, Y.-R. Kim, S. Steen, A. Rasheed: Preprint submitted to Elsevier
Page 9 of 22

---

Data Processing Framework for Ship Performance Analysis
from the main database may contain several missing time steps (or timestamps). In such a case, it is recommended to
check for such missing timestamps by simply calculating the gradient of timestamps, and for each missing timestamp,
just add an empty row consisting only the missing timestamp value. Finally, the dataset should be sorted according the
timestamps, resulting in a uniform and evenly-spaced list of samples.
Similar procedure can be adopted for a noon report dataset. The noon reports are generally recorded every 24 hours,
but it may sometimes be more or less than 24 hours if the vessel’s local time zone is adjusted, specially on the day of
arrival or departure. The same procedure may not be feasible in case of AIS data, as the samples here are sporadically
distributed in general. Here, the samples are collected at diﬀerent frequencies depending on the ship’s moving state,
surrounding environment, traﬃc, and the type of AIS receiving station (land-based or satellite). It is observed here
that the data is collected in short and continuous sections of the time-series, leaving some large gaps between samples,
as shown in ﬁgure 2. Here, it is recommended to ﬁrst resample the short and continuous sections of AIS data to a
uniform sampling interval through data resampling techniques, i.e., up-sampling or down-sampling (as demonstrated
by Virtanen et al. (2020)), and then, ﬁll the remaining large gaps with empty rows.
Figure 2: Down-sampling the collected AIS data to 15 minutes interval.
4.2. Divide Into Trips
Using conventional tools, data visualization becomes a challenge if the number of samples in the dataset is
enormously large. It may simply not be practical to plot the whole time-series in a single plot. Moreover, dividing
the time-series into individual trips may be considered as neat and help discretize the time-series into sensible sections
which may be treated individually for further data processing and analysis. Plotting an individual trip would also give
a complete overview of a port-to-port journey of the ship. Dividing the data into trips and at-berth legs would also
make further data processing computationally less expensive as it may be possible to ignore a large number of samples
(for further steps) where the ship is not in a trip. For such samples, it may not be necessary to interpolate hindcast,
calculate hydrostatics, calculate resistance components, etc. Lastly, identifying individual trips would also make draft
and trim correction step easier.
Dividing data into trips is substantially easier for noon reports and AIS data as they are generally supplied with a
source and/or destination port name. In case of in-service data, it may be possible that no such information is available.
In such a case, if the GPS data (latitude and longitudes) is available, it may be possible to just plot the samples on the
world map and obtain individual trips by looking at the port calls. Alternatively, if the in-service data is supplied with a
‘State’ variable2 (mentioned by Gupta et al. (2019)), indicating the propulsive state of the ship, like ‘Sea Passage’, ‘At
Berth’, ‘Maneuvering’, etc., it is recommended to ﬁnd the continuous legs of ‘At Berth’ state and enumerate the gaps in
these legs with trip numbers, containing the rest of the states, as shown in ﬁgure 3a. Otherwise, it is recommended to
2Generally available for ships equipped with Marorka systems (www.marorka.com).
P. Gupta, Y.-R. Kim, S. Steen, A. Rasheed: Preprint submitted to Elsevier
Page 10 of 22

---

Data Processing Framework for Ship Performance Analysis
use the shaft rpm and GPS speed (or speed-over-ground) time-series to identify the starting and end of each port-to-port
trip. Here, a threshold value can be adopted for the shaft rpm and GPS speed. All the samples above these threshold
values (either or both) are considered to be in-trip samples, as shown in ﬁgure 3b. Thus, continuous legs of such in-trip
samples can simply be identiﬁed and enumerated. It may also be possible to append few samples before and after each
of these identiﬁed trips to obtain a proper trip, starting from zero and ending at zero. Such a process is designed keeping
in mind the noise in the shaft rpm and GPS speed variables when the ship is actually static. Finally, if the GPS data is
available, further adjustments can be done by looking at the port calls on the world map plotted with the GPS data.
(a) Splitting time-series into trips using the ‘State’ variable.
(b) Splitting time-series into trips using threshold values (in-
dicated by dashed red lines) for shaft rpm (10 rpm) and GPS
speed (3 knots) variables.
Figure 3: Splitting time-series into trips.
4.3. Interpolate Hindcast & GPS Position Correction
Even if the raw data contains information regarding the state of the weather for each data sample, it may be a
good idea to interpolate weather hindcast (or metocean) data available from one of the well-established sources. The
interpolated hindcast data would not only provide a quantitative measure of the weather conditions (and, consequently,
the environmental loads) experienced by the ship, but it would also help carry-out some important validation checks
(discussed later in section 4.5). In order to interpolate hindcast data, the information regarding the location (latitude
and longitude) and recording timestamp must be available in the ship’s dataset. For ship performance analysis, it should
be aimed that, at least, the information regarding the three main environmental load factors, i.e., wind, waves and sea
currents, is gathered from the weather hindcast sources. For a further detailed analysis, it may also be a good idea to
obtain additional variables, like sea water temperature (both surface and gradient along the depth of the ship), salinity,
etc.
Before interpolating the weather hindcast data to the ship’s location and timestamps, it is recommended to ensure
that the available GPS (or navigation) data is validated and corrected (if possible) for any errors. If the GPS data is
inaccurate, weather information at the wrong location is obtained, resulting in incorrect values for further analysis.
For instance, the ship’s original trajectory obtained from the GPS data, presented in ﬁgure 4a, shows that the ship
proceeds in a certain direction while suddenly jumping to an oﬀ-route location occasionally. The ship, of course, may
have gone oﬀ-route as shown here, but referring to the GPS speed and heading of the ship at the corresponding time,
shown in ﬁgure 4b, it is obvious that the navigation data is incorrect. Here, such an irrational position change can
be detected through the two-stage steady-state (or stationarity) ﬁlter suggested by Gupta et al. (2021b), based on the
P. Gupta, Y.-R. Kim, S. Steen, A. Rasheed: Preprint submitted to Elsevier
Page 11 of 22

---

Data Processing Framework for Ship Performance Analysis
method developed by Dalheim and Steen (2020a). The ﬁrst stage of the ﬁlter uses a sliding window to remove unsteady
samples by performing a t-test on the slope of the data values, while the second stage performs an additional gradient
check for the samples failing in the ﬁrst stage to retain the misidentiﬁed samples. The ‘irrational position’ in ﬁgure
4a shows the coordinates identiﬁed as unsteady when the above two-stage ﬁlter is applied to longitude and latitude
time-series. The ﬁltered trajectory is further obtained after removing the samples with ‘irrational position’ from the
original data.
(a) Original trajectory and ﬁltered trajectory with irrational
GPS position.
(b) Trends of GPS speed, heading, and position of the ship
according to the corresponding period.
Figure 4: GPS position cleaning using the steady-state detection algorithm.
The hindcast data sources generally allow downloading a subset of the variables, timestamps, and a sub-grid
of latitudes and longitudes, i.e., the geographical location. Depending on the hindcast source, the datasets can be
downloaded manually (by ﬁlling a form), using an automated API script, or even by directly accessing their ftp servers.
It may also be possible to select the temporal and spatial resolution of the variables being downloaded. In some cases,
the hindcast web servers allows the users to send a single query, in terms of location, timestamp, and list of variables,
to extract the required data for an individual sample. But every query received by these servers is generally queued for
processing, causing substantially long waiting times, as they are facing a good amount of traﬃc from all over the world.
Thus, it is recommended to simply download the required subset of data on a local machine for faster interpolation.
Once the hindcast data ﬁles are available oﬄine, the main task at hand is to understand the cryptic (but highly
eﬃcient) data packaging format. Now-a-days, the two most poplar formats for such data ﬁles are GRIdded Binary
data (GRIB) and NetCDF. GRIB (available as GRIB1 or GRIB2) is the international standard accepted by World
Meteorological Organization (WMO), but due to some compatibility issues with windows operating systems, it may
be preferable to use the NetCDF format.
Finally, a step-by-step interpolation has to be carried-out for each data sample from the ship’s dataset. Algorithm
1 shows a simple procedure for n-th order (in time) interpolation scheme. Here, the spatial and temporal interpolation
is performed in steps 10 and 12, respectively. For a simple and reliable procedure, it is recommended to perform the
spatial interpolation using a grid of latitudes and longitudes around the ship’s location, after ﬁtting a linear or non-linear
2D surface over the hindcast grid. It may be best to use a linear surface here as, ﬁrstly, the hindcast data may not be so
accurate that performing a higher order interpolation would provide any better estimates, and secondly, in some case,
higher order interpolation may result in highly inaccurate estimates, due to the waviness of the over-ﬁtted non-linear
P. Gupta, Y.-R. Kim, S. Steen, A. Rasheed: Preprint submitted to Elsevier
Page 12 of 22

---

Data Processing Framework for Ship Performance Analysis
surface. Similar arguments can be given in the case of temporal interpolation, and therefore, a linear interpolation in
time can also be considered acceptable. The advantage of using the given algorithm is that the interpolation steps, here,
can be easily validated by plotting contours (for spatial interpolation) and time-series (for temporal interpolation).
Algorithm 1 A simple algorithm for n-th order interpolation of weather hindcast data variables.
1: 푤퐷푎푡푎←weather hindcast data
2: 푥←data variables to interpolate from hindcast
3: 푤푇←timestamps in 푤퐷푎푡푎
4: for all timestamps in ship’s dataset do
5:
푡←current ship time stamp
6:
푙표푐←current ship location (latitude & longitude)
7:
푖←푛+ 1 indices of 푤푇around 푡
8:
for all 푥do
9:
for all 푖do
10:
푥[푖] ←2D spatial interpolation at 푙표푐using 푤퐷푎푡푎[푥][푖, ∶, ∶]
11:
end for
12:
푋←n-th order temporal interpolation at 푡using 푥[푖]
13:
end for
14: end for
An important feature of hindcast datasets is masking the invalid values. For instance, the signiﬁcant wave height
should only be predicted by the hindcast model for the grid nodes which fall in the sea, requesting the value of
such a variable on land should result in an invalid value. Such invalid values (or nodes) are by default masked in
the downloaded hindcast data ﬁles, probably for an eﬃcient storage of the data. These masked nodes may be ﬁlled
with zeros before carrying-out the spatial interpolation in step 10, as one or more of these nodes may be contributing
to the interpolation. Alternatively, if a particular masked node is contributing to the interpolation, it can be set to the
mean of other nodes surrounding the point of interpolation, as suggested by Ejdfors (2019). It is argued by Ejdfors
(2019) that this would help avoid the artiﬁcially low (zero) values during the interpolation, but if the grid resolution is
ﬁne-enough, it is expected that the calculated mean (of unmasked surrounding nodes) would also not be much higher
than zero.
4.4. Derive New Features
Interpolating the weather hindcast variables to ship’s location at a given time would provide the hindcast variables
in the global (or the hindcast model’s) reference frame. For further analysis, it may be appropriate to translate these
variables to ship’s frame of reference, and furthermore, it may be desired to calculate some new variables which could
be more relevant for the analysis or could help validate the assimilated (ship and hindcast) dataset. The wind and
sea current variables, obtained from the hindcast source and the ship’s dataset, can be resolved into the longitudinal
and transverse speed components for validation and further analysis. Unfortunately, the wave load variables cannot be
resolved in a similar manner, but the mean wave direction should be translated into the relative mean wave direction
(relative to the ship’s heading or course).
4.5. Validation Checks
Although it is recommended to validate each processing step by visualizing (or plotting) the task being done, it
may be a good idea to take an intermediate pause and perform all types of possible validation checks. These validation
checks would not only help assess the dataset from reliability point of view but can also be used to understand the
correlation between various features. The validation checks can be done top-down, starting from the most critical
feature to the least one. As explained in section 2.2, the shaft power measurements can be validated against the shaft
rpm and shaft torque measurements, if these are available, else just plotting the shaft rpm against the shaft power can
also provide a good insight into the quality of data. For a better assessment, it is suggested to visualize the shaft rpm
vs shaft power overlaid with the engine operational envelope and propeller curves, as presented by Liu et al. (2020)
(in ﬁgure 11). Any sample falling outside the shaft power overload envelope (specially at high shaft rpm) should be
removed from the analysis, as they may be having measurement errors. It may also be possible to make corrections, if
the shaft power data seems to be shifted (up or down) with respect to the propeller curves due to sensor bias.
P. Gupta, Y.-R. Kim, S. Steen, A. Rasheed: Preprint submitted to Elsevier
Page 13 of 22

---

Data Processing Framework for Ship Performance Analysis
The quality of speed-through-water measurements can be assessed by validating it against its estimate, obtained
as a diﬀerence between the speed-over-ground and longitudinal current speed. Here, it should be kept in mind that the
two values may not be a very good match due to several problems cited in section 3.1.1. Visualizing the speed-though-
water vs shaft power along with all the available estimates of the speed-power calm-water curve is also an important
validation step (shown in ﬁgure 5). Here, the majority of measurement data should accumulate around these curves. In
case of disparity between the curves, the curve obtained through the sea trial of the actual ship may take precedence.
Figure 5: Speed-though-water (log speed) vs shaft power with various estimates of speed-power calm-water curves.
The interpolated weather hindcast data variables must also be validated against the measurements taken onboard the
ship. This is quite critical as the sign and direction notations assumed by the hindcast models and ship’s sensors (or data
acquisition system) are probably not the same, which may cause mistakes during the interpolation step. Moreover, most
ships are generally equipped with anemometers that can measure the actual and relative wind speed and directions, and
these two modes (actual or relative) can be switched through a simple manipulation by the crew onboard. It is possible
that this mode change may have occurred during the data recording duration, resulting in errors in the recorded data.
In addition, there may be a diﬀerence between the reference height of the wind hindcast data and the vertical position
of the installed anemometer, which may lead to somewhat diﬀerent results even at the same location at sea. The wind
speed at the reference height (푉푊푇푟푒푓) can be corrected using the anemometer recorded wind speed (푉푊푇), assuming
a wind speed proﬁle, as follows (recommended by ITTC (2017)):
푉푊푇푟푒푓= 푉푊푇
(푍푟푒푓
푍푎
) 1
9
(2)
Where 푍푟푒푓is the reference height above the sea level and 푍푎is the height of the anemometer.
Finally, these wind measurements can be translated into the longitudinal and transverse relative components. The
obtained transverse relative wind speed can be validated against the transverse wind speed, obtained from the hindcast
source, as they are basically the same. Similarly, the diﬀerence between the longitudinal relative wind speed and the
speed-over-ground of the ship can be validated against the longitudinal wind speed measurements from hindcast, as
P. Gupta, Y.-R. Kim, S. Steen, A. Rasheed: Preprint submitted to Elsevier
Page 14 of 22

---

Data Processing Framework for Ship Performance Analysis
shown in ﬁgure 6. In case of time-averaged in-service data, the problem of faulty averaging of angular measurements
when the measurement values are near 0 or 360 degrees (i.e., the angular limits), explained in section 3.1.3, must
also be veriﬁed and appropriate corrective measures should be taken. From ﬁgure 6, it can be clearly seen that the
time-averaging problem (in relative wind direction) causes the longitudinal wind speed (estimated using the ship data)
to jump from positive to negative, resulting in a mismatch with the corresponding hindcast values. In such a case, it is
recommended to either ﬁx these faulty measurements, which may be diﬃcult as there is no proven way to do it, or just
use the hindcast measurements for further analysis.
Figure 6: Validating longitudinal wind speed obtained using the ship data against the values obtained from the hindcast.
The time-averaging problem with angular measurements around 0 or 360 degrees (explained in section 3.1.3) is clearly
visible here.
As discussed in the case of noon reports in section 3.3.1, weather information generally refers to the state of the
weather at the time when the report is logged, which is probably not the average state from noon to noon. Furthermore,
the wind loads here are observed based on the Beaufort scale, therefore, the deviation may be somewhat large when
converted to the velocity scale. In this case, it is recommended to consider the daily average values obtained from the
weather hindcast data, over the travel region, rather than the noon report values.
4.6. Data Processing Errors
The validation step is very critical in ﬁnding out any processing mistakes or inherent problems with the dataset, as
demonstrated in the previous section. Such problems or mistakes, if detected, must be corrected or amended for before
moving forward with the processing and analysis. The main mistakes found at this step are generally either interpolation
mistakes or incorrect formulation of the newly derived feature. These mistakes should be rectiﬁed accordingly, as shown
in the ﬂow diagram (ﬁgure 1).
4.7. Fix Draft & Trim
The draft measurements recorded onboard the ship are often found to be incorrect due to the Venturi eﬀect,
explained brieﬂy in section 3.1.1. The Venturi eﬀect causes the draft measurements to drop to a lower value due to a
non-zero negative dynamic pressure as soon as the ship develops a relative velocity with respect of the water around
the hull. Thus, the simplest solution to ﬁx these incorrect measurements is by interpolating the draft during a voyage
using the draft measured just before and after the voyage. Such a simple solution provides good results for a simple
case where the draft of the ship basically remains unchanged during the voyage, except for the reduction of draft due
to consumed fuel, as shown in the ﬁgure 7a.
P. Gupta, Y.-R. Kim, S. Steen, A. Rasheed: Preprint submitted to Elsevier
Page 15 of 22

---

Data Processing Framework for Ship Performance Analysis
(a) Simple draft correction.
(b) Complex draft correction.
Figure 7: Correcting in-service measured draft.
In a more complex case where the draft of the ship is changed in the middle of the voyage and the ship is still
moving, i.e., conducting ballasting operations or trim adjustments during transit, the simple draft interpolation would
result in corrections which can be way oﬀthe actual draft of the vessel. As shown in ﬁgure 7b, the fore draft is seen to
be dropping and the aft draft increasing in the middle of the voyage without much change in the vessel speed, indicating
trim adjustments during transit. In this case, a more complex correction is applied after taking into account the change
in draft during the transit. Here, ﬁrst of all, a draft change operation is identiﬁed (marked by green and red vertical
lines in ﬁgure 7b), then the diﬀerence between the measurements before and after the operation is calculated by taking
an average over a number of samples. Finally, a ramp is created between the starting of the draft change operation
(green line) and the end of operation (red line). The slope of the ramp is calculated using the diﬀerence between the
draft measurements before and after the draft change operation. The draft change operation can either be identiﬁed
manually, by looking at the time-series plots, or using the steady-state (or stationarity) ﬁlter developed by Dalheim and
Steen (2020a).
In case of AIS data, Bailey et al. (2008) reported that 31% of the draft information out of the investigated AIS
messages had obvious errors. The draft information from AIS data generally corresponds to the condition of ships
while arriving at or departing from the port, and changes due to fuel consumption and ballast adjustment onboard are
rarely updated. Since the draft obtained from the AIS as well as noon reports has a long update cycle and is acquired
by humans, it is practically diﬃcult to precisely ﬁx the draft values as in the case of in-service data. However, by
comparing the obtained draft with a reference value, it may be possible to gauge whether the obtained draft is, in fact,
correct. If the obtained draft excessively deviates from the reference, it may be possible to remove the corresponding
data samples from further analysis or replace the obtained draft value with a more appropriate value. Table 3 shows the
results of investigating the average draft ratio, which is the ratio of the actual draft (푇푐) and design draft (푇푑), for various
ship types from 2013 to 2015 by Olmer et al. (2017). As summarized in the table, the draft ratio varies depending on
the ship type and the voyage type. By using these values as the above mentioned reference, the draft obtained from the
AIS data and noon reports can be roughly checked and corrected.
4.8. Calculate Hydrostatics
Depending on the type of performance analysis, it may be necessary to have features like displacement, wetted
surface area (WSA), etc. in the dataset, as they are more relevant from a hydrodynamic point of view. Moreover,
most of the empirical or physics-based methods for resistance calculations (to be done in the next step) requires these
P. Gupta, Y.-R. Kim, S. Steen, A. Rasheed: Preprint submitted to Elsevier
Page 16 of 22

---

Data Processing Framework for Ship Performance Analysis
Table 3
Average draft ratio (푇푐∕푇푑) for diﬀerent ship types. 푇푐= actual draft during a voyage; 푇푑= design draft of the ship.
Ship types
Ballast Voyage
Laden Voyage
Liqueﬁed gas tanker
0.67
0.89
Chemical tanker
0.66
0.88
Oil tanker
0.60
0.89
Bulk carrier
0.58
0.91
General cargo
0.65
0.89
The following ship types do not generally have ballast-only voyages.
Container
0.82
Ro-Ro
0.87
Cruise
0.98
Ferry pax
0.90
Ferry ro-pax
0.93
Table 4
Estimation formulas for wetted surface area of diﬀerent ship types.
Category
Formula
Reference
Tanker/Bulk carrier
푊푆퐴= 0.99 ⋅( ∇
푇+ 1.9 ⋅퐿푊퐿⋅푇)
Kristensen and Bingham (2017)
Container
푊푆퐴= 0.995 ⋅( ∇
푇+ 1.9 ⋅퐿푊퐿⋅푇)
Kristensen and Bingham (2017)
Other (General)
푊푆퐴= 1.025 ⋅( ∇
푇+ 1.7 ⋅퐿푃푃⋅푇)
Molland (2011)
Table 5
Typical block coeﬃcient (퐶퐵) range at design draft for diﬀerent ship types, given by Solutions (2018).
Category
Type
Block coeﬃcient (퐶퐵)
Tanker
Crude oil carrier
0.78-0.83
Gas tanker/LNG carrier
0.65-0.75
Product
0.75-0.80
Chemical
0.70-0.78
Bulk carrier
Ore carrier
0.80-0.85
Regular
0.75-0.85
Container
Line carrier
0.62-0.72
Feeder
0.60-0.70
General cargo
General cargo/Coaster
0.70-0.85
Roll-on/roll-oﬀcargo
Ro-Ro cargo
0.55-0.70
Ro-pax
0.50-0.70
Passenger ship
Cruise ship
0.60-0.70
Ferry
0.50-0.70
features. Unfortunately, these feature cannot be directly recorded onboard the ship. But it is fairly convenient to estimate
them using the ship’s hydrostatic table or hull form (or oﬀset table) for the corresponding mean draft and trim for each
data sample. Here, it is recommended to use the corrected draft and trim values, obtained in the previous step. If the
detailed hull form is not available, the wetted surface area can also be estimated using the empirical formulas shown
in table 4. The displacement at design draft, on the other hand, can be estimated using the ship particulars and typical
range of block coeﬃcient (퐶퐵), presented in table 5.
4.9. Calculate Resistance Components
There are several components of the ship’s total resistance, and there are several methods to estimate each of
these components. The three main resistance components which generally constitutes the majority of the ship’s total
resistance are calm-water, added wind, and added wave resistance. It is possible to further divide the calm-water
resistance into sub-components, namely, skin friction and residual resistance. The total calm-water resistance can
be calculated using one of the many well-known empirical methods, like Guldhammer and Harvald (Guldhammer
P. Gupta, Y.-R. Kim, S. Steen, A. Rasheed: Preprint submitted to Elsevier
Page 17 of 22

---

Data Processing Framework for Ship Performance Analysis
and Harvald (1970)), updated Guldhammer and Harvald (Kristensen and Bingham (2017)), Hollenbach (Hollenbach
(1998)), Holtrop and Mennen (Holtrop and Mennen (1982)), etc. These empirical methods are developed using the
data from numerous model test results of diﬀerent types of ships, and each one is proven to be ﬁtting well on several
diﬀerent ship types. The latter makes choosing the right method for a ship quite complicated.
The easiest way to choose the right calm-water resistance estimation method is to calculate the calm-water
resistance from each of these methods and comparing it with the corresponding data obtained for the given ship.
The calm-water data for a given ship can be obtained from the model tests, sea trial, or even ﬁltering the operational
data, obtained from one of the sources discussed here (in section 3), for near-calm-water condition. The usual practice
here is to use the sea trial data as it is obtained and corrected for near-calm-water condition and do not suﬀer from
scale eﬀects, seen in model test results. But the sea trials are sometimes conducted at only the high range of speed
and ballast displacement (as shown in ﬁgure 5). Thus, it is recommended to use the near-calm-water ﬁltered (and
corrected) operational data to choose the right method so that a good ﬁt can be ensured for a complete range to speed
and displacement.
According to ITTC (2017), the increase in resistance due to wind loads can be obtained by applying one of
the three suggested methods, namely, wind tunnel model tests, STA-JIP, and Fujiwara’s method. If the wind tunnel
model test results for the vessel are available, it may be considered as the most accurate method for estimating added
wind resistance. Otherwise, the database of wind resistance coeﬃcients established by STA-JIP (van den Boom et al.
(2013)) or the regression formula presented by Fujiwara et al. (2005) is recommended. From the STA-JIP database,
experimental values according to the speciﬁc ship type can be obtained, whereas Fujiwara’s method is based-on the
regression analysis of data obtained from several wind tunnel model tests for diﬀerent ship types.
The two main sets of parameters required to estimate the added wind resistance using any of the above three methods
are incident wind parameters and information regarding the exposed area to the wind. The incident wind parameters,
i.e., relative wind speed and direction, can be obtained from onboard measurements or weather hindcast data. In case
of weather hindcast data, the relative wind measurements can be calculated from the hindcast values according to
the formulation outlined by ITTC (2017) in section E.1, and in case of onboard measurements, the relative wind
measurements should be corrected for the vertical position of the anemometer according to the instructions given by
ITTC (2017) in section E.2, also explained here in section 4.5. The information regarding the exposed area to the wind
can be either estimated using the general arrangement drawing of the ship or approximately obtained using a regression
formula based-on the data from several ship, presented by Kitamura et al. (2017).
The added wave resistance (푅퐴푊) can also be obtained in a similar manner using one of the several well-established
methods for estimating 푅퐴푊. ITTC (2017) recommends conducting sea keeping model tests in regular waves to obtain
푅퐴푊transfer functions, which can further be used to estimate 푅퐴푊for the ship in irregular seas. To empirically obtain
these transfer functions or 푅퐴푊for a given ship, it is possible to use physics-based empirical methods like STAWAVE1
and STAWAVE2 (recommended by ITTC (2017)). STAWAVE1 is a simpliﬁed method for directly estimating 푅퐴푊
in head wave conditions only, and it requires limited input, including ship’s waterline length, breadth, and signiﬁcant
wave height. STAWAVE2 is an advanced method to empirically estimate parametric 푅퐴푊transfer functions for a
ship. The method is developed using an extensive database of sea keeping model test results from numerous ships, but
unfortunately, it only provides transfer functions for approximate head wave conditions (0 to ±45 degrees from bow).
A method proposed by DTU (Martinsen (2016); Taskar and Andersen (2019); Taskar and Andersen (2021)) provides
transfer functions for head to beam seas, i.e., 0 to ±90 degrees from bow. Finally, for all wave heading, it may be
recommended to use the newly established method by Liu et al. (2020). There have been several studies to assess and
compare the eﬃcacy of each of these methods and several other methods, but no consistent guidelines are provided
regarding their applicability.
4.10. Data Cleaning & Outlier Detection
It may be argued by some that the process of data cleaning and outlier detection should be carried-out way earlier
in the data processing framework, as proposed by Dalheim and Steen (2020b), but it should be noted here that all the
above steps proposed here have to be performed only once for a given dataset, whereas data cleaning is done based
on the features selected for further analysis. Since the same dataset can be used for several diﬀerent analyses, which
may be using diﬀerent sets of features, some part of data cleaning has to be repeated before each analysis to obtain a
clean dataset with as many data samples as possible. Moreover, the additional features acquired during the above listed
processing steps may be helpful in determining to a better extent if a suspected sample is actually an outlier or not.
P. Gupta, Y.-R. Kim, S. Steen, A. Rasheed: Preprint submitted to Elsevier
Page 18 of 22

---

Data Processing Framework for Ship Performance Analysis
Nevertheless, it may be possible to reduce the work load for the above processing steps by performing some basic
data cleaning before some of these steps. For instance, while calculating the resistance components for in-trip data
samples, it is possible to ﬁlter-out samples with invalid values for one or more of the ship data variables used to
calculate these components, like speed-though-water, mean draft (or displacement), etc. This would reduce the number
of samples for which the new feature has to be calculated. It should also be noted that even if such simple data cleaning
(before each step) is not performed, these invalid samples would be easily ﬁltered-out in the present step. Thus, the
reliability and eﬃcacy of the data processing framework is not aﬀected by performing the data cleaning and outlier
detection step at the end.
Most of the methods developed for ship performance monitoring assumes that the ship is in a quasi-steady state
for each data sample. The quasi-steady assumption indicates that the propulsive state of the ship remains more or less
constant during the sample recording duration, i.e., the ship is neither accelerating nor decelerating. This is specially
critical for aforementioned time-averaged datasets, as the averaging duration can be substantially long, hiding the eﬀects
of accelerations and decelerations. Here, the two-stage steady-state ﬁlter, explained in section 4.3, can be applied to the
shaft rpm time-series to remove the samples with accelerations and decelerations, resulting in quasi-steady samples.
In tandem to the steady-state ﬁlter on the shaft rpm time-series, it may also be possible to use the steady-state ﬁlter,
with relaxed setting, on the speed-over-ground time-series to ﬁlter-out the sample where the GPS speed (or speed-over-
ground) signal suddenly drops or recovers from a dead state, resulting in measurement errors.
As discussed in section 3.1.2, the outliers can be divided into two broad categories: (a) Contextual outliers, and (b)
Correlation-defying outliers. The contextual outliers can be identiﬁed and resolved by the methods presented as well as
demonstrated by Dalheim and Steen (2020b), and for correlation-defying outliers, methods like Principal Component
Analysis (PCA) and autoencoders can be used. Figure 8 shows the in-service data samples recorded onboard a ship. The
data here is already ﬁltered-out for quasi-steady assumption, explained above, and contextual outliers, according to the
methods suggested by Dalheim and Steen (2020b). Thus, the samples highlighted by red circles (around 6.4 MW shaft
power in ﬁgure 8a) can be classiﬁed as correlation-defying outliers. The time-series plot (shown in ﬁgure 8b) clearly
indicates that the detected outliers have faulty measurements for the speed-through-water (stw) and speed-over-ground
(sog), defying the correlation between these variables and the rest. It is also quite surprising to notice that the same fault
occurs in both the speed measurements at the same time, considering that they are probably obtained from diﬀerent
sensors.
(a) Log speed (or stw) vs shaft power.
(b) Time-series.
Figure 8: Correlation-defying outliers marked with red circles.
P. Gupta, Y.-R. Kim, S. Steen, A. Rasheed: Preprint submitted to Elsevier
Page 19 of 22

---

Data Processing Framework for Ship Performance Analysis
5. Conclusion
The quality of data is very important in estimating the performance of a ship. In this study, a streamlined semi-
automatic data processing framework is developed for ship performance analysis. The data processing framework can
be used to process data from several diﬀerent sources, like onboard recorded in-service data, AIS data and noon reports.
These three data sources are discussed here in detail along with their inherent problems and associated examples. It is
here recommended to use the onboard recorded in-service data for ship performance monitoring over the other data
sources, as it is considered more reliable due its consistent and higher sampling rate. Moreover, the AIS data and noon
reports lacks some of the critical variables required for ship performance analysis, and they are also susceptible to
human error, as some of the data variables recorded here are manually logged by the ship’s crew. Nevertheless, all
three data sources are known to have several problems and should be processed carefully for any further analysis.
The data processing framework, presented in the current work, is designed to address and resolve most of the
problems found in the above three data sources. It is ﬁrst recommended to divide the data into trips so that further
processing can be performed in a more systematic manner. A simple logic to divide the data into individual trips
is outlined here if the port call information is not available. The weather hindcast (metocean) data is considered as
an important supplementary information, which can be used for data validation and estimating environmental loads
experienced by the ship. A simple algorithm to eﬀectively interpolate the hindcast data at a speciﬁc time and location
of a ship is presented within the data processing framework. The problem of erroneous draft measurements, caused due
to the Venturi eﬀect, is discussed in detail as well as simple interpolation is recommended to ﬁx these measurements.
A more complex case, where the draft or trim is voluntarily adjusted during the voyage without reducing the vessel
speed, is also presented here. Such a case cannot be resolved with simple interpolation, and therefore, an alternate
method is suggested for the same problem.
Choosing the most suitable methods for estimating resistance components may also be critical for ship performance
analysis. It is, therefore, recommended to carry out some validation checks to ﬁnd the most suitable methods before
adopting them into practice. Such validation checks should be done, wherever possible, using the data obtained from
the ship while in-service rather than just using the sea trial or model test results. Data cleaning and outlier detection is
also considered an important step for processing the data. Since cleaning the data requires selecting a subset of features
relevant for the analysis, it is recommended to perform this as the last step of the data processing framework, and some
part of it should be reiterated before carrying out a new type of analysis. The presented data processing framework can
be systematically and eﬃciently adopted to process the datasets for ship performance analysis. Moreover, the various
data processing methods or steps mentioned here can also be used elsewhere to process the time-series data from ships
or similar sources, which can be used further for a variety of tasks.
CRediT authorship contribution statement
Prateek Gupta: Conceptualization, Methodology, Investigation, Software, Data curation, Visualization, Writing.
Young-Rong Kim: Conceptualization, Methodology, Investigation, Software, Data curation, Visualization, Writing.
Sverre Steen: Conceptualization, Supervision, Resources. Adil Rasheed: Conceptualization, Supervision.
References
Aldous, L., Smith, T., Bucknall, R., Thompson, P., 2015. Uncertainty analysis in ship performance monitoring. Ocean Engineering 110, 29–38.
American Bureau of Shipping, 2020. Guide for smart functions for marine vessels and oﬀshore units. ABS Guides .
Antola, M., Solonen, A., Pyorre, J., 2017. Notorious speed through water. 2nd Hull Performance & Insight Conference (HullPIC’17) , 156–165.
Bailey, N.J., Ellis, N., Sampson, H., 2008. Training and technology onboard ship: how seafarers learned to use the shipboard automatic identiﬁcation
system (AIS). Seafarers International Research Centre (SIRC), CardiﬀUniversity.
van den Boom, H., Huisman, H., Mennen, F., 2013. New guidelines for speed/power trials. Level playing ﬁeld established for IMO EEDI. SWZ
Maritime , 1–11.
Carchen, A., Atlar, M., 2020.
Four KPIs for the assessment of biofouling eﬀect on ship performance.
Ocean Engineering 217,
107971. URL: https://www.sciencedirect.com/science/article/pii/S0029801820309239, doi:https://doi.org/10.1016/j.
oceaneng.2020.107971.
Coraddu, A., Oneto, L., Baldi, F., Cipollini, F., Atlar, M., Savio, S., 2019. Data-driven ship digital twin for estimating the speed loss caused by the
marine fouling. Ocean Engineering 186. doi:10.1016/j.oceaneng.2019.05.045. cited By 1.
Dalheim, Ø., Steen, S., 2020a. A computationally eﬃcient method for identiﬁcation of steady state in time series data from ship monitoring. Journal
of Ocean Engineering and Science doi:10.1016/j.joes.2020.01.003. cited By 1.
P. Gupta, Y.-R. Kim, S. Steen, A. Rasheed: Preprint submitted to Elsevier
Page 20 of 22

---

Data Processing Framework for Ship Performance Analysis
Dalheim, Ø.Ø., Steen, S., 2020b. Preparation of in-service measurement data for ship operation and performance analysis. Ocean Engineering 212,
107730. URL: https://www.sciencedirect.com/science/article/pii/S0029801820307125, doi:https://doi.org/10.1016/j.
oceaneng.2020.107730.
Dalheim, Ø.Ø., Steen, S., 2021.
Uncertainty in the real-time estimation of ship speed through water.
Ocean Engineering 235,
109423. URL: https://www.sciencedirect.com/science/article/pii/S0029801821008313, doi:https://doi.org/10.1016/j.
oceaneng.2021.109423.
Ejdfors, K.O., 2019.
Use of in-service data to determine the added power of a ship due to fouling.
Master’s thesis. NTNU.
URL: http:
//hdl.handle.net/11250/2622960.
Farag, Y.B., Ölçer, A.I., 2020.
The development of a ship performance model in varying operating conditions based on ann and regression
techniques. Ocean Engineering 198, 106972. URL: https://www.sciencedirect.com/science/article/pii/S0029801820300536,
doi:https://doi.org/10.1016/j.oceaneng.2020.106972.
Foteinos, M., Tzanos, E., Kyrtatos, N., 2017. Ship hull fouling estimation using shipboard measurements, models for resistance components,
and shaft torque calculation using engine model. Journal of Ship Research 61, 64–74. URL: https://www.scopus.com/inward/record.
uri?eid=2-s2.0-85024491367&doi=10.5957%2fJOSR.61.2.160053&partnerID=40&md5=4d8fedda376f0ed57cf089dbbfe28012,
doi:10.5957/JOSR.61.2.160053. cited By 3.
Fujiwara, T., Ueno, M., Ikeda, Y., 2005. A new estimation method of wind forces and moments acting on ships on the basis of physical component
models. Journal of the Japan Society of Naval Architects and Ocean Engineers 2, 243–255. doi:10.2534/jjasnaoe.2.243.
Guldhammer, H., Harvald, S., 1970. Ship Resistance: Eﬀect of Form and Principal Dimensions. Akademisk Forlag.
Gupta, P., Rasheed, A., Steen, S., 2021a. Ship performance monitoring using machine-learning. arXiv:2110.03594.
Gupta, P., Steen, S., Rasheed, A., 2019.
Big data analytics as a tool to monitor hydrodynamic performance of a ship.
doi:10.1115/
OMAE2019-95815. v07AT06A059.
Gupta, P., Taskar, B., Steen, S., Rasheed, A., 2021b.
Statistical modeling of ship’s hydrodynamic performance indicator.
Applied Ocean
Research 111, 102623.
URL: https://www.sciencedirect.com/science/article/pii/S0141118721001000, doi:https://doi.
org/10.1016/j.apor.2021.102623.
Hansen, S.V., Petersen, J., Jensen, J., 2011. Performance monitoring of ships. DTU Mechanical Engineering.
Harati-Mokhtari, A., Wall, A., Brooks, P., Wang, J., 2007. Automatic identiﬁcation system (ais): data reliability and human error implications. The
Journal of Navigation 60, 373–389.
Hollenbach, K.U., 1998. Estimating resistance and propulsion for single-screw and twin-screw ships. Ship Technology Research 45, 72–76. Cited
By 21.
Holtrop, J., Mennen, G., 1982. Approximate power prediction method., pp. 166–170. URL: https://www.scopus.com/inward/record.
uri?eid=2-s2.0-0020154745&doi=10.3233%2fisp-1982-2933501&partnerID=40&md5=d9302542762e00fd19dfb49dd2bd6990,
doi:10.3233/isp-1982-2933501. cited By 347.
ISO, 2016. ISO 19030-2:2016: Ships and marine technology — measurement of changes in hull and propeller performance — part 2: Default
method. URL: https://www.iso.org/standard/63775.html.
ITTC, 2017. Recommended procedures and guidelines 7.5-04-01-01.1: Preparation, conduct and analysis of speed/power trials. URL: https:
//www.ittc.info/media/7691/75-04-01-011.pdf.
Jerri, A.J., 1977. The shannon sampling theorem—its various extensions and applications: A tutorial review. Proceedings of the IEEE 65, 1565–1596.
Karagiannidis, P., Themelis, N., 2021. Data-driven modelling of ship propulsion and the eﬀect of data pre-processing on the prediction of ship
fuel consumption and speed loss. Ocean Engineering 222, 108616. URL: https://www.sciencedirect.com/science/article/pii/
S0029801821000512, doi:https://doi.org/10.1016/j.oceaneng.2021.108616.
Kim, S.Y., Kim, M.S., Han, K.M., gyu Kim, J., Seo, D.W., 2020.
Study on Data Analysis of On-Board Measurement Data for
Ship’s
Speed
Power
Performance.
URL:
https://doi.org/10.1115/OMAE2020-19153,
doi:10.1115/OMAE2020-19153,
arXiv:https://asmedigitalcollection.asme.org/OMAE/proceedings-pdf/OMAE2020/84379/V06AT06A038/6606596/v06at06a038-omae
v06AT06A038.
Kim, Y.R., Jung, M., Park, J.B., 2021. Development of a fuel consumption prediction model based on machine learning using ship in-service data.
Journal of Marine Science and Engineering 9. URL: https://www.mdpi.com/2077-1312/9/2/137, doi:10.3390/jmse9020137.
Kitamura, F., Ueno, M., Fujiwara, T., Sogihara, N., 2017. Estimation of above water structural parameters and wind loads on ships. Ships and
Oﬀshore Structures 12, 1100–1108.
Koboević, Ž., Bebić, D., Kurtela, Ž., 2019. New approach to monitoring hull condition of ships as objective for selecting optimal docking period.
Ships and Oﬀshore Structures 14, 95–103. doi:10.1080/17445302.2018.1481631. cited By 1.
Kristensen, H.O.H., Bingham, H., 2017. Prediction of Resistance and Propulsion Power of Ships. Technical Report. Technical University of
Denmark. URL: https://gitlab.gbar.dtu.dk/oceanwave3d/Ship-Desmo.
Laurie, A., Anderlini, E., Dietz, J., Thomas, G., 2021. Machine learning for shaft power prediction and analysis of fouling related performance
deterioration. Ocean Engineering 234, 108886. URL: https://www.sciencedirect.com/science/article/pii/S0029801821003218,
doi:https://doi.org/10.1016/j.oceaneng.2021.108886.
Liang, Q., Tvete, H.A., Brinks, H.W., 2019.
Prediction of vessel propulsion power using machine learning on AIS data, ship performance
measurements and weather data. Journal of Physics: Conference Series 1357, 012038. URL: https://doi.org/10.1088/1742-6596/
1357/1/012038, doi:10.1088/1742-6596/1357/1/012038.
Liu, S., Loh, M., Leow, W., Chen, H., Shang, B., Papanikolaou, A., 2020. Rational processing of monitored ship voyage data for improved oper-
ation. Applied Ocean Research 104, 102363. URL: https://www.sciencedirect.com/science/article/pii/S0141118720309226,
doi:https://doi.org/10.1016/j.apor.2020.102363.
Major, P., Li, G., Zhang, H., Hildre, H., 2021. Real-time digital twin of research vessel for remote monitoring, pp. 159–164. doi:10.7148/
2021-0159.
P. Gupta, Y.-R. Kim, S. Steen, A. Rasheed: Preprint submitted to Elsevier
Page 21 of 22

---

Data Processing Framework for Ship Performance Analysis
Martinsen, M.A., 2016.
An design tool for estimating the added wave resistance of container ships, et design værktøj til estimering af øget
bølgemodstand for kontainerskibe.
Minoura, M., Hanaki, T., Nanjo, T., 2021. Improvement of statistical estimation of ship performance in actual seas by normalization of data
unevenness using cluster analysis, in: Okada, T., Suzuki, K., Kawamura, Y. (Eds.), Practical Design of Ships and Other Floating Structures,
Springer Singapore, Singapore. pp. 878–898.
Molland, A.F., 2011. The maritime engineering reference book: a guide to ship design, construction and operation. Elsevier.
Munk, T., 2016.
Fuel conservation through managing hull resistance, in: Motorship Propulsion Conference, Copenhagen.
URL: https:
//www.messe.no/ExhibitorDocuments/97726/2419/BIMCO%20Hull-Resistance.pdf.
Olmer, N., Comer, B., Roy, B., Mao, X., Rutherford, D., 2017. Greenhouse gas emissions from global shipping, 2013–2015 detailed methodology.
International Council on Clean Transportation: Washington, DC, USA , 1–38.
Olofsson, R., 2020. Unsupervised anomaly detection. Master’s thesis. UMEÅ University. URL: https://www.diva-portal.org/smash/get/
diva2:1445794/FULLTEXT01.pdf.
Park, J., Kim, B., Jeong, S., Park, J.H., Jeong, D., Ahn, K., 2017. A comparative analysis of ship speed-power performance based on the noon
reports and recorded sensor data: Overcoming sensor issues, in: OCEANS 2017-Anchorage, IEEE. pp. 1–7.
Rhodes, B.J., Bomberger, N.A., Seibert, M., Waxman, A.M., 2005. Maritime situation monitoring and awareness using learning mechanisms, in:
MILCOM 2005-2005 IEEE Military Communications Conference, IEEE. pp. 646–652.
Solutions, M.E., 2018. Basic principles of ship propulsion. MAN: Augsburg, Germany .
Taskar, B., Andersen, P., 2019. Beneﬁt of speed reduction for ships in diﬀerent weather conditions .
Taskar, B., Andersen, P., 2021.
Comparison of added resistance methods using digital twin and full-scale data.
Ocean Engineering 229,
108710. URL: https://www.sciencedirect.com/science/article/pii/S0029801821001451, doi:https://doi.org/10.1016/j.
oceaneng.2021.108710.
Themelis, N., Spandonidis, C., Christopoulos, G., Giordamlis, C., 2018. A comparative study on ship performance assessment based on noon report
and continuous monitoring system datasets, in: Proceedings, pp. 55–64.
Thomas, R., Judith, J., 2021. Hybrid dimensionality reduction for outlier detection in high dimensional data. International Journal of Emerging
Trends in Engineering Research 8. doi:10.30534/ijeter/2020/160892020.
Tu, E., Zhang, G., Rachmawati, L., Rajabally, E., Huang, G.B., 2017. Exploiting ais data for intelligent maritime navigation: A comprehensive
survey from data to methodology. IEEE Transactions on Intelligent Transportation Systems 19, 1559–1582.
Virtanen, P., Gommers, R., Oliphant, T.E., Haberland, M., Reddy, T., Cournapeau, D., Burovski, E., Peterson, P., Weckesser, W., Bright, J., et al.,
2020. Scipy 1.0: fundamental algorithms for scientiﬁc computing in python. Nature methods 17, 261–272.
Wahl, J.M., 2019.
Prediction of fuel consumption of a ship in transit using machine learning.
Master’s thesis. NTNU.
URL: https:
//ntnuopen.ntnu.no/ntnu-xmlui/handle/11250/2622968.
Walker, M., Atkins, I., 2007. Surface ship hull and propeller fouling managment, pp. 131–138. Cited By 3.
Weng, J., Liao, S., Wu, B., Yang, D., 2020. Exploring eﬀects of ship traﬃc characteristics and environmental conditions on ship collision frequency.
Maritime Policy & Management 47, 523–543.
You, Y., Kim, J., Seo, M.G., 2017. A feasibility study on the rpm and engine power estimation based on the combination of ais and ecmwf database
to replace the full-scale measurement. Journal of the Society of Naval Architects of Korea 54, 501–514. doi:10.3744/SNAK.2017.54.6.501.
P. Gupta, Y.-R. Kim, S. Steen, A. Rasheed: Preprint submitted to Elsevier
Page 22 of 22

---

