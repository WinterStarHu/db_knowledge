# A Practical Approach of Actions for FAIRification Workflows

> 来源: https://arxiv.org/pdf/2201.07866

A Practical Approach of Actions for FAIRification 
Workflows 
Natalia Queiroz de Oliveira1[0000-0001-8371-142X], Vânia Borges1[0000-0002-6717-1168],         
Henrique F. Rodrigues1[0000-0002-6777-3935], Maria Luiza Machado Campos1[0000-0002-7930-
612X], Giseli Rabello Lopes1[0000-0003-2482-1826] 
1 Federal University of Rio de Janeiro, Rio de Janeiro, Brazil 
natalia.oliveira@ppgi.ufrj.br, vjborges30@ufrj.br, 
hfr@ufrj.br, mluiza@ppgi.ufrj.br, giseli@ic.ufrj.br 
Abstract Since their proposal in 2016, the FAIR principles have been largely 
discussed by different communities and initiatives involved in the development 
of infrastructures to enhance support for data findability, accessibility, interoper-
ability, and reuse. One of the challenges in implementing these principles lies in 
defining a well-delimited process with organized and detailed actions. This paper 
presents a workflow of actions that is being adopted in the VODAN BR pilot for 
generating FAIR (meta)data for COVID-19 research. It provides the understand-
ing of each step of the process, establishing their contribution. In this work, we 
also evaluate potential tools to (semi)automatize (meta)data treatment whenever 
possible. Although defined for a particular use case, it is expected that this work-
flow can be applied for other epidemical research and in other domains, benefit-
ing the entire scientific community. 
Keywords: FAIRification workflow, FAIR (meta)data, ETL4FAIR. 
1 
 Introduction 
Since its publication in 2016 [1], the FAIR principles have been guiding best practices 
on publishing scientific research data and their associated metadata to make them Find-
able, Accessible, Interoperable, and Reusable by humans and especially by machines. 
The international GO FAIR1 initiative aims at implementing the FAIR principles 
through Implementation Networks (INs)2, which operate as FAIR drivers, collabora-
tively involving communities, institutions, and countries. As a sense of urgency due to 
the rapidly COVID-19 pandemic spread, the Data Together initiative involving the 
Committee on Data for Science and Technology (CODATA)3, Research Data Alliance 
 
1 https://www.go-fair.org/ 
2 https://www.go-fair.org/implementation-networks/ 
3 https://codata.org/ 

---

2 
(RDA)4, World Data System (WDS)5, and GO FAIR was established, including a joint 
effort, the Virus Outbreak Data Network IN (VODAN-IN6). The initial goal is to de-
velop a federated data infrastructure to support the capture and use of data related to 
epidemic outbreaks, both for the current situation and future epidemics. 
Initiatives such as VODAN-IN attempt to deliver FAIR data, in the original sense of 
the acronym, but also in the sense of “Federated, AI-Ready”7 data, therefore readable 
and machine actionable. The first IN of GO FAIR Brazil [2], GO FAIR Brazil Health8, 
is a thematic network responsible for developing strategies for the implementation of 
the FAIR principles in the health domain. VODAN BR9  is the first pilot of GO FAIR 
Brazil Health, aiming to collect and implement a data management infrastructure for 
COVID-19 hospitalized patients’ cases, according to the FAIR principles. The pub-
lished scientific research data and their associated metadata should be as open as pos-
sible and as closed as necessary, to protect participant privacy and reduce the risk of 
data misuse. 
The attempt of adopting the FAIR principles has led many scientific disciplines, 
which value the importance of research data stewardship [3], to consider: “Which 
knowledge is needed to make my data FAIR?” or “What solutions could be used?”. The 
process of making data FAIR is called FAIRification and the VODAN BR pilot has 
been using the FAIRification workflow [4] for the transformation and publication of 
FAIR (meta)data. This general workflow describes a process that applies to any type of 
data and can be extended, adapted, and reused in different domains. However, in the 
VODAN BR pilot, we verified the need for specific actions to be defined in a more 
detailed FAIRification process, as a basis for implementation choices that needed to be 
carried out to support it. 
Based on the recommendations of the original FAIRification process, this paper pre-
sents a practical approach for actions associated with the transformation of data and 
metadata, which are being tested in the VODAN BR pilot to ensure the publication of 
FAIR (meta)data on COVID-19. To systematize some of the established actions, we 
experimented and analyzed potential solutions to support FAIRification. 
The remainder of this paper is organized as follows: Section 2 presents an overview 
of the FAIRification workflow; Section 3 describes the actions established for each step 
of the workflow for the VODAN BR pilot; Section 4 presents support solutions ana-
lyzed during the study of the steps, aiming at the systematization of the process; Section 
5 presents a discussion about the relevant aspects treated in this work and concludes 
with final comments for future work. 
2 
FAIRification Workflow  
 
4 https://rd-alliance.org/ 
5 https://world-datasystem.org/ 
6 https://go-fair.org/wp-content/uploads/2020/03/Data-Together-COVID-19-Statement-FINAL.pdf 
7 https://www.go-fair.org/implementation-networks/overview/vodan/ 
8 https://www.go-fair-brasil.org/saude 
9 https://portal.fiocruz.br/en/vodan-brazil 

---

3 
The generic workflow proposed in [4] aims to facilitate the FAIRification process com-
prising three defined phases: pre-FAIRification, FAIRification and post-FAIRification. 
The phases are further divided into seven steps: 1) identify the FAIRification objective; 
2) analyze data; 3) analyze metadata; 4) define semantic model for data (4a) and 
metadata (4b); 5) make data (5a) and metadata (5b) linkable; 6) host FAIR data; and 7) 
assess FAIR data. 
From these multiple steps, the authors describe how data and metadata can be pro-
cessed, which knowledge is required, and which procedures and tools can be used to 
obtain FAIR (meta)data. The FAIRification workflow was defined based on discus-
sions and experimentations from a series of workshops (Bring your own device - 
BYOD) [5] and is applicable to any kind of data and metadata. 
FAIRification is in fact a complex process, requiring several areas of expertise and 
data stewardship knowledge. Our adaptation follows the steps of the generic FAIRifi-
cation workflow and, according to our understanding, steps 6 and 7 have been renamed 
to 6) host FAIR data and metadata and 7) assess FAIR data and metadata. The reason 
is to emphasize the importance of storing, publishing, and evaluating both FAIR data 
and metadata. 
In the literature review we found related studies and experiments discussing the 
FAIRification process. In [6], a retrospective form of FAIRification approach is pre-
sented, using two related metabolic datasets associated with journal articles to curate 
and re-annotate data and metadata using interoperability standards. However, the work 
does not follow the generic FAIRification workflow approach. 
The work of [7] details the FAIRification process10 proposed by GO FAIR, which 
aims to facilitate the conversion of spreadsheets into FAIR databases, with the help of 
the NMDataParser tool [8]. This tool supports data aggregation block levels, developed 
to speed up the mapping of the original file into the eNanoMapper11 semantic model.  
In [9], the authors present an architecture, following the GO FAIR FAIRification 
process, and addressing identified gaps in the process when dealing with datasets from 
the health domain. Another paper [10] proposes the De-novo FAIRification method, 
based on an Electronic Data Capture (EDC) system, where the steps of the generic 
FAIRification workflow are incorporated into the data collection process for a registra-
tion or research project. 
We verified that these related works present approaches with guidelines for FAIR-
ification proposed by the generic workflow and for the FAIRification process of GO 
FAIR. However, none of the works present the detail of associated actions for the 
FAIRification in a delimited and specific way, justifying implementation choices to 
support the transformation and publishing of FAIR (meta)data.  
3 
Set of Actions for FAIRification 
3.1 
VODAN BR Pilot 
 
10 https://www.go-fair.org/fair-principles/fairification-process/ 
11 https://search.data.enanomapper.net/ 

---

4 
The VODAN BR pilot has been using the adapted FAIRification workflow, in a plat-
form acting as a FAIR solution for COVID-19 clinical data. This platform is not only 
concerned with the process of data transformation and metadata generation, but also 
with support solutions to host and publish FAIR (meta)data. Figure 1 shows a diagram 
of the platform, with the (meta)data flow from the original source to the target FAIR 
Data Point, associated with the steps of the adapted FAIRification workflow. 
For the pilot, the platform captures COVID-19 patients’ datasets, in CSV format 
(1), applying the pre-FAIRification phase (a) steps. This dataset and the results of the 
performed analyses are used in steps 4a and 4b of the FAIRification phase (b), estab-
lishing the semantic models. Following the actions specified by steps 5a and 5b, the 
Extract, Transform and Load (ETL) process, designated in this work as ETL4FAIR (2), 
is responsible for transforming data and metadata to the RDF representation. 
Hosting of (meta)data follows step 6, with the linkable (meta)data published in a 
triplestore (3). A triplestore Application Programming Interface (API) can be made 
available for access to (meta)data. The metadata schemas for the dataset and its distri-
butions are provided in a FAIR Data Point (5). The distribution metadata schemas can 
provide an URL to download the RDF file published in the repository (4) and/or an 
SPARQL endpoint to the triplestore. 
Finally, step 7, intended for the assessment of FAIR (meta)data, in the post-FAIR-
ification phase (c), allows the (meta)data FAIRness evaluation and verifying the suita-
bility of the established platform. 
 
Fig. 1. VODAN BR pilot platform, with associated steps of the adapted FAIRification workflow. 
3.2 
Phases, Steps and Actions 
In the platform, we transformed the recommendations from each step of the adapted 
FAIRification workflow into a practical set of actions enabling the implementation of 
the FAIR principles, improving the FAIRness evaluation and, consequently, the reuse 
of (meta)data. Representing a continuous evolution for the FAIRification workflow, 
this approach can be used as a reference framework. The set of delimited actions is 
presented below according to each phase of the FAIRification workflow. 

---

5 
Pre-FAIRification Phase 
The actions established for step 1 (Identify FAIRification Objective) seek to propose a 
view of the expected results to be achieved through FAIRification. It requires access to 
data, followed by a preliminary analysis of data and associated metadata. Based on 
these, it is possible to set goals for the treatment to be performed, identifying the objec-
tives to obtain FAIR (meta)data and defining a set of competency questions that allows 
it to validate the FAIRification process. 
For step 2 (Analyze Data), the actions aim to analyze the data representation accord-
ing to their format and semantics, the FAIRness evaluation, to check the FAIR maturity 
level, for example, according to RDA [11], and, finally, to define a relevant subset of 
the analyzed data for FAIRification. 
The actions for step 3 (Analyze Metadata) analyze the metadata associated with the 
relevant subset of data defined in the previous step and their FAIRness evaluation. It is 
important to identify the provenance metadata that should be collected for each step of 
the adapted FAIRification workflow. Figure 2 presents the set of associated actions, for 
each step of the Pre-FAIRification phase. 
 
Fig. 2. Set of associated actions for each step of the Pre-FAIRification phase.  
FAIRification Phase 
Steps 4a (Define Semantic Data Model) and 4b (Define Semantic Metadata Model) are 
responsible for the specification of semantic models for data and metadata by identify-
ing and evaluating whether any semantic models already exist and could be reused for 
them. For cases where no semantic model is available, a new one should be created for 
the representation of data or metadata. 
In steps 5a (Make Data Linkable) and 5b (Make Metadata Linkable), the actions 
highlight the importance of choosing an RDF framework, as a major step to make 
(meta)data interoperable and machine-accessible with the association of the semantic 
models defined in step 4. In step 5b, it is worth mentioning the importance of repre-
senting and transforming provenance metadata into a machine-readable and actionable 
language.  
For step 6 (Host FAIR Data and Metadata), the actions make data and metadata 
available for human and machine use, through various interfaces, such as the adoption 

---

6 
of a triplestore for RDF triples and also a FAIR Data Point for metadata storage. The 
FAIR Data Point adoption facilitates transparent and gradually controlled access over 
the metadata through four different hierarchical layers: starting with metadata from the 
FAIR Data Point itself, followed by metadata from the catalog, from the datasets, and 
from the distributions [12]. Figure 3 presents the set of associated actions for each step 
of the FAIRification phase. 
 
Fig. 3. Set of associated actions for each step for the FAIRification phase. 
Post-FAIRification Phase 
Finally, the actions of step 7 (Assess FAIR Data and Metadata) contemplate the assets 
of the Post-FAIRification process, verifying the objectives and answering the compe-
tence questions defined in step 1. Another relevant aspect refers to the assessment of 
the FAIRness evaluation of data and metadata after the completion of all actions in the 
adapted FAIRification workflow. Figure 4 shows the set of associated actions for each 
step in the Post-FAIRification phase. 
 
Fig. 4. Set of associated actions for each step for the Post-FAIRification phase. 
4 
Solutions to Support the FAIRification Phase 

---

7 
During this study, we investigated solutions capable of supporting and systematizing 
the FAIRification process, aiming to reduce human errors. The analysis of them helped 
to understand the recommendations associated with the steps (4a, 4b, 5a, 5b, and 6) of 
the FAIRification phase. The solutions contributed to validate the actions, promoting 
the automated support of some steps in the workflow. 
 
Fig. 5. Analyzed solutions and possible integrations. 
The solutions experimented and analyzed are presented below, emphasizing their 
potential to support the steps of the FAIRification phase. Figure 5 presents a summary 
of the heterogeneous solutions used in the VODAN BR pilot and the possible integra-
tions through their API. 
 
Fig. 6. Schematic representation of a patient’s outcome using the COVIDCRFRAPID seman-
tics. 

---

8 
For the experiments and analyses of the solutions, we considered the transformation 
of (meta)data referring to the questions presented in the WHO Case Record Form 
(CRF-WHO) [13], using the COVIDCRFRAPID semantic model. CRF-WHO was de-
veloped by experts to collect relevant anonymous information related to patients with 
COVID-19. It has three modules: the first one collects the patient's data on the admis-
sion day to the health center; the second one, the follow-up, collects daily information 
such as ICU admission and laboratory results; and the last one summarizes the medical 
care and collects the outcome information. Figure 6 highlights: (a) the CRF-WHO out-
come questions present in “Module3: Complete at discharge/death”; and (b) the seman-
tic model excerpt that handles these questions, associated with instances (example). 
4.1 
ETL4LOD+ Framework  
The ETL4LOD+12 framework provides data cleansing and triplification solutions in the 
context of Linked Open Data. The framework is an extension of the Pentaho Data In-
tegration (PDI) tool, also known as Kettle, widely used in data ETL processes. This 
framework provides searching and selecting terms of ontologies and interlinks to other 
data. 
According to our experiments and analyses ETL4LOD+ assists the FAIRification 
process contributing to the systematization of steps 5a and 5b. Figure 7 shows an ex-
ample using ETL4LOD+ to transform a patient's outcome data as shown in Figure 6(b). 
The framework components organize data obtained from the sources into triple (RDF 
format), according to the respective semantic model, connecting to vocabularies or on-
tologies (which can be imported). 
 
Fig. 7. Triplification extract for outcome questions using ETL4LOD+. 
To create triplified data, ETL4LOD+ provides several components. In the process 
depicted in Figure 8, to generate the required URI, we use the “Formula - fx” (1) com-
ponent. Then, data are annotated with the CRF-OMS ontology. The “Data Property 
Mapping - Dm” (2) component deals with literal values related to the answers. We also 
use the “Object Property Mapping - Om” (3) component for other ontology-related 
items. After mapping, the “NTriple Generator - N3” (4) component serializes the data 
in N-triples format. Finally, the serialized data is unified in a file through the “File 
Output” (5) component. 
In step 5b, the tool can collect metadata related to the data processing, using solutions 
 
12 https://github.com/Grupo-GRECO/ETL4LODPlus 

---

9 
such as the Provenance Collector Agent (PCA) (detailed in section 4.2). The associated 
metadata are obtained in triple format. Furthermore, the tool gathers and organizes other 
metadata such as the FAIR Data Point dataset and distribution metadata schemas, both 
generated by the CEDAR tool (detailed in section 4.3), employing the “REST Client” 
PDI step. In step 6, the tool contributes to the last part of the ETL process, enabling 
automatic loading of triplified data into a triplestore (currently Virtuoso13) or generating 
an output in files with RDF data serialized in N-Triples. These files can be published 
in different triplestores. 
4.2 
ETL4LinkedProv Approach 
The purpose of the ETL4LinkedProv14 approach is to manage the collection and publi-
cation of provenance metadata with distinct provenance granularity as Linked Data. 
The approach uses ETL workflows and employs the Provenance Collector Agent 
(PCA) component, capturing prospective and retrospective provenance metadata. To 
support the semantic publication of provenance, ETL4LinkedProv approach uses a set 
of existing ontologies as PROV-O15, OPMW16 and COGS17 [14]. 
Through initial analyses and simulation working with the ETL4LOD+ framework, 
the PCA showed potential to collect provenance metadata associated with an ETL 
workflow. Our simulation was not as detailed as it was planned due to the version mis-
match between ETL4LinkedProv and ETL4LOD+ framework used in the VODAN BR 
pilot. Therefore, an update of ETL4LinkedProv is currently under development to ex-
periment with the FAIRification process.  
As shown in Figure 8, PCA could contribute to steps 5b and 6, capturing prospective 
and retrospective provenance metadata at different granularity levels and supporting 
the assessment of the quality and reliability of FAIR provenance metadata. Thus, at the 
step 6, the captured provenance metadata, as RDF triples semantically annotated using 
existing provenance ontologies, could be available in a triplestore for SPARQL18 que-
ries.  
 
Fig. 8. ETL4LinkedProv approach representing the provenance metadata in steps 5a, 5b and 6. 
 
13 https://virtuoso.openlinksw.com/ 
14 https://github.com/rogersmendonca/provenance_collector 
15 http://www.w3.org/TR/2013/REC-prov-o-20130430/ 
16 https://www.opmw.org/model/OPMW/ 
17 http://vocab.deri.ie/cogs 
18 https://www.w3.org/TR/rdf-sparql-query/ 

---

10 
4.3 
Center for Expanded Data Annotation and Retrieval (CEDAR) Work-
bench 
CEDAR Workbench19 provides a suite of Web-based tools that allows users to build 
and populate metadata templates, generate high-quality metadata, and share and man-
age these resources through an API based environment [15]. This solution can assist 
steps 5b and 6 with respect to metadata schemas established for the FAIR Data Point 
[12]. Through CEDAR, it is possible to create metadata schemas as templates. These 
templates must be instantiated with the metadata for the dataset and distribution to be 
generated. The generated metadata schemas, in RDF N-Quad or JSON-LD, can be ac-
cessed directly or through the API and published in the FAIR Data Point. Our experi-
ment used the “REST Client” PDI with CEDAR to collect the metadata schemas of the 
COVID-19 dataset and its RDF distribution that will be published on the FAIR Data 
Point. 
4.4 
Prov Python (Prov 2.0.0) 
According to our metadata provenance analyses, it was observed the importance of also 
capturing the provenance of the macro process. For the study of this high-level prove-
nance, the Prov.2.0.020 was selected. Prov Python is a library for the implementation of 
the W3C PROV Data Model21, with support for serialization in PROV-O (RDF), 
PROV-XML and PROV-JSON [16].  
The experiment and analysis identified a potential solution for steps 5b and 6. In step 
5b, the solution provided provenance information, capturing provenance of each step, 
and it could even collect details of the actions themselves. Figure 9 illustrates a repre-
sentation of provenance metadata of the step 5b obtained with Prov Python. In step 6, 
the provenance workflow can be published in a repository or accessed by the 
ETL4LOD+ tool and joined with the triples of the data file. 
 
Fig. 9. An extract from the provenance metadata for step 5b with Prov Python. 
Figure 9, due to space limitations, only shows an extract of the workflow provenance 
 
19 https://metadatacenter.org/ 
20 https://openprovenance.org 
21 https://www.w3.org/TR/prov-dm/ 

---

11 
metadata based on PROV-O Model, generated by Prov Python. This extract highlights 
the solutions, represented as software agents (orange pentagons), used in step 5b, the 
activity (blue rectangle), for metadata generation, and the entities (yellow ovals).  
5 
Discussion and Conclusion 
In the VODAN BR pilot, we verified the need for specific actions to be defined in a 
more detailed FAIRification process, justifying implementation choices of the domain. 
The rapid spread of the COVID-19 pandemic accelerated the discussion on technology 
support to publish FAIR (meta)data, although there are still many questions and open 
issues, especially in the context of metadata management and support. Complementary, 
it is important to consider a set of best practices from a great number of projects exper-
imenting with the FAIRification process of (meta)data related not only to virus out-
breaks, but to life sciences data in general. 
    This work analyzed the recommendations proposed by the generic workflow for 
FAIRification and it established an approach inspired by a group of well-delimited ac-
tions to support researchers and data stewardship in the generation of FAIR (meta)data. 
This proposal is being tested in the VODAN BR pilot to guarantee the publication of 
FAIR data and metadata about COVID-19 hospitalized patients’ cases with the support 
provided by the ETL4FAIR framework. The framework promotes integration between 
heterogeneous tools to support the process, providing a (semi-)automated workflow for 
users and reducing error-prone situations. 
    The first lesson learned along this work is that FAIRification is a complex process in 
which a multidisciplinary team involvement is extremely important. FAIRification re-
quires several areas of expertise as well as domain knowledge to support each step of 
the process. Establishing roles and responsibilities for the mapped actions is also im-
portant. The second lesson learned is that transforming data and metadata aligned with 
the FAIR principles is not an easy task. Identifying, choosing, and adapting appropriate 
data and metadata semantic models are critical actions, as there are many standards 
disseminated on the Web. Finally, the actions analyzed in this work emphasized the 
existence of different categories of metadata (for data, data transformation process, and 
applied process) that can be presented at different granularity levels, contributing to 
reuse and interoperability. These metadata should be captured throughout a FAIRifica-
tion process, supported by appropriate tools, whenever possible.  
    From the exposed context, the importance of establishing actions to define and dis-
cuss implementation choices aligned with FAIRification is observed. This contributes 
to a better organization and maturity of a process that could be assisted by a group of 
heterogeneous but interoperable solutions. In the near future, we are considering im-
proving the actions proposed in this paper, applying them in different domains.  
Acknowledgements. This work has been partially supported with students grants from 
CAPES (Process numbers 223038.014313/2020-19 and 88887.613048/2021-00), 
CNPq (Process number 158474/2020-1) and UNIRIO. 

---

12 
References 
1. Wilkinson M, Dumontier M, Aalbersberg I, Appleton G, Axton M,Baak A, et al. The FAIR 
Guiding Principles for scientific data management and stewardship. Sci Data. 2016; 
3:160018. doi:10.1038/sdata.2016.18.2.  
2. Sales L, Henning P, Veiga V, Costa MM, Sayão LF, da Silva Santos LOB, et al. GO FAIR 
Brazil: A Challenge for Brazilian Data Science. Data Intelligence. 2020 Jan;2(1–2):238–45 
doi: 10.1162/dint_a_00046 
3. Jansen P, Van Den Berg L, Van Overveld P, Boiten J-W. Research Data Stewardship for 
Healthcare Professionals. In: Kubben P, Dumontier M, Dekker A, editors. Fundamentals of 
Clinical Data Science [Internet]. Cham: Springer International Publishing; 2019. p. 37–53. 
Available from: https://doi.org/10.1007/978-3-319-99713-1_4 
4. Jacobsen A, Kaliyaperumal R, da Silva Santos LOB, Mons B, Schultes E, Roos M, et al. A 
Generic Workflow for the Data FAIRification Process. Data Intelligence 2020; 2 (1-2): 56–
65. doi:10.1162/dint_a_00028 
5. Hooft R, Goble C, Evelo C, Roos M, Sansone S, Ehrhart F, et al. ELIXIR-EXCELERATE 
D5.3: Bring Your Own Data (BYOD). https://zenodo.org/record/3207809. Last accessed 
2021/06/16. 
6. Rocca-Serra P, Sansone SA. Experiment design driven FAIRification of omics data matri-
ces, an exemplar. Sci Data. 2019; 6(1):271. doi:10.1038/s41597-019-0286-0. 
7. Kochev N, Jeliazkova N, Paskaleva V, Tancheva G, Iliev L, et al. Your Spreadsheets Can 
Be FAIR: A Tool and FAIRification Workflow for the eNanoMapper Database. Nano-
materials. 2020; 10(10):1908. https://doi.org/10.3390/nano10101908. 
8. Jeliazkova N, Doganis P, Fadeel B, Grafström R, Hastings J, Jeliazkov V, et al. The first 
eNanoMapper prototype: A substance database to support safe-by-design. In: 2014 IEEE 
International Conference on Bioinformatics and Biomedicine (BIBM). 2014. p. 1–9.  
9. Sinaci A, Núñez-Benjumea F, Gencturk M, Jauer M, Deserno T, et al. From Raw Data to 
FAIR Data: The FAIRification Workflow for Health Research. Methods Inf Med. 2020; 
59(S 01):e21-e32. doi: 10.1055/s-0040-1713684. 
10. Groenen K, Jacobsen A, Kersloot M, Vieira B, van Enckevort E, Kaliyaperumal R, et al. 
The de novo FAIRification process of a registry for vascular anomalies. 2020. doi: 
10.1101/2020.12.12.20245951. 
11. FAIR Data Maturity Model Working Group (2020) FAIR Data Maturity Model. Specifica-
tion and Guidelines. doi: 10.15497/rda00050. 
12. FAIRDataTeam. FAIR Data Point Metadata Specification. https://github.com/FAIR-
DataTeam/FAIRDataPoint-Spec/blob/master/spec.md. Last accessed 2021/06/16. 
13. World Health Organization. (2020). Global COVID-19 clinical platform: rapid core case 
report form (CRF). https://apps.who.int/iris/handle/10665/333229. 
14. Mendonça R., Cruz S., Machado, M. L. C., ETL4LinkedProv: Managing Multigranular Lin-
ked Data Provenance. Journal of Information and Data Management. 2016;7:70–85. 
15. Gonçalves RS, O’Connor MJ, Martínez-Romero M, Egyedi AL, Willrett D, Graybeal J, et 
al. The CEDAR Workbench: An Ontology-Assisted Environment for Authoring Metadata 
that Describe Scientific Experiments. In: d’Amato C, Fernandez M, Tamma V, Lecue F, 
Cudré-Mauroux P, Sequeda J, et al., editors. The Semantic Web - ISWC 2017. Cham: 
Springer International Publishing; 2017. p. 103–10.  
16. Moreau L., Freire J., Futrelle J., McGrath R.E., Myers J. Paulson P. The Open Provenance 
Model: An Overview. In: Freire J., Koop D., Moreau L. (eds) Provenance and Annotation 
of Data and Processes. IPAW 2008. Lecture Notes in Computer Science, vol 5272. Springer, 
Berlin, Heidelberg. https://doi.org/10.1007/978-3-540-89965-5_31. 

---

