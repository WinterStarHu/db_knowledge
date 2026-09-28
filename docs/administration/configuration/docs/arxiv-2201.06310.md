# A survey study of success factors in data science projects

> 来源: https://arxiv.org/pdf/2201.06310

A survey study of success factors in data science projects
Iñigo Martinez
Vicomtech Foundation
Basque Research and Technology Alliance
Donostia-San Sebastián 20009, Spain
imartinez@vicomtech.org
Elisabeth Viles
University of Navarra
TECNUN School of Engineering
Donostia-San Sebastián 20018, Spain
eviles@tecnun.es
Igor G Olaizola
Vicomtech Foundation
Basque Research and Technology Alliance
Donostia-San Sebastián 20009, Spain
iolaizola@vicomtech.org
Abstract—In recent years, the data science community has
pursued excellence and made signiﬁcant research efforts to de-
velop advanced analytics, focusing on solving technical problems
at the expense of organizational and socio-technical challenges.
According to previous surveys on the state of data science project
management, there is a signiﬁcant gap between technical and
organizational processes. In this article we present new empirical
data from a survey to 237 data science professionals on the
use of project management methodologies for data science. We
provide additional proﬁling of the survey respondents’ roles and
their priorities when executing data science projects. Based on
this survey study, the main ﬁndings are: (1) Agile data science
lifecycle is the most widely used framework, but only 25% of
the survey participants state to follow a data science project
methodology. (2) The most important success factors are precisely
describing stakeholders’ needs, communicating the results to end-
users, and team collaboration and coordination. (3) Professionals
who adhere to a project methodology place greater emphasis
on the project’s potential risks and pitfalls, version control, the
deployment pipeline to production, and data security and privacy.
Index Terms—data science, survey, project management, factor
analysis, success factors
I. INTRODUCTION
In recent years, the data science (DS) community has
pursued excellence and made signiﬁcant research efforts to
develop advanced analytics, focusing on solving technical
problems at the expense of organizational and socio-technical
challenges. Developing and successfully implementing a data
science project to business processes pose signiﬁcant chal-
lenges to companies. According to VentureBeat [1], 87%
of data science projects never make it into production, and
a NewVantage survey [2] found that adoption of big data
and artiﬁcial intelligence (AI) initiatives remain a signiﬁcant
challenge for 77% of businesses. In fact, 70% of companies
report minimal or no impact from AI [3]. Gartner [4] also
reported that 80% of analytics insights will fail to deliver
business outcomes by 2022, and 80% of data science projects
will “remain alchemy, run by wizards”. These low success
rates in data science projects are indeed noteworthy given the
competitive advantage that such advanced techniques provide
to researchers and practitioners.
Leveraging data science within a business organizational
context involves organizational and socio-technical challenges
beyond the analytical ones: a lack of vision, strategy and
clear objectives, a biased emphasis on technical issues, a
lack of reproducibility, and role ambiguity are among these
challenges, which lead to a low level of maturity in data
science projects, that are managed in an ad-hoc fashion. The
lack of a deﬁned process methodology to manage data science
projects is one of the primary reasons for these challenges. [5].
Several surveys [6]–[9] have been conducted to collect
empirical data on the state of data science project management
in both industry and research. According to the ﬁndings of
these surveys, there is a signiﬁcant gap between technical and
organizational processes when applied to data science projects.
In this article, we present new empirical data from a
survey to 237 data science professionals on the use of project
management methodologies for data science. Furthermore, we
provide additional proﬁling of the survey respondents’ roles
(data scientist, data engineer, business analyst, etc.) and their
priorities when executing data science projects.
The rest of the article is structured as follows: Background
context is presented in Section II, along with organizational
and socio-technical challenges that arise when executing a
data science project. Section III describes the methodology
for the survey. Section IV presents and discusses the results
obtained from the survey and ﬁnally, Section V describes the
main conclusions of the paper.
II. BACKGROUND CONTEXT
Data science is a multidisciplinary ﬁeld that lies between
computer science, mathematics and statistics, and comprises
the use of scientiﬁc methods and techniques, to extract
knowledge and value from large amounts of structured and/or
unstructured data. After several decades of progress, data
science and machine learning technology are called to become
a signiﬁcant source of value for a wide range of businesses
[10], [11]. However, these recent technological achievements
do not correspond to their application to real-world data
science projects. Data scientists are struggling to deploy their
models into business processes. Evidence suggests that the
gap is widening between organizations successfully gaining
value from data science and those struggling to do so [12].
Signiﬁcant challenges remain unsolved, and many artiﬁcial
intelligence initiatives fail.
978-1-6654-3902-2/21/$31.00 ©2021 IEEE
©2021 IEEE. Personal use of this material is permitted. Permission from IEEE must be obtained for all other uses, in any
current or future media, including reprinting/republishing this material for advertising or promotional purposes, creating new
collective works, for resale or redistribution to servers or lists, or reuse of any copyrighted component of this work in other works.
arXiv:2201.06310v1  [cs.DB]  17 Jan 2022

---

Team Management
Project Management
Data & Information Management
Poor coordination
Low level of process maturity
Lack of reproducibility
Collaboration issues across teams
Uncertain business objectives
Retaining and accumulation of knowledge
Lack of transparent communication
Setting adequate expectations
Low data quality for ML
Inefﬁcient governance models
Hard to establish realistic project timelines
Lack of quality assurance checks
Lack of people with analytics skills
Biased emphasis on technical issues
No validation data
Rely not only on leading data scientist
Delivering the wrong thing
Data security and privacy
Build multidisciplinary teams
Project not used by business
Investment in IT infrastructure
TABLE I
DATA SCIENCE PROJECTS MAIN CHALLENGES
Table I summarizes the main challenges faced by data sci-
ence professionals when executing real data science projects.
Even though these issues do exist in real-world data science
projects, the community has not been overly concerned about
them [5], [13], and there is a wide consensus that not enough
has been written about solutions to tackle these problems [14].
Some authors and companies have proposed methodologies
for managing data science projects, and have come up with
new tools and processes to address the cited issues. The
most popular frameworks in this regard are: CRISP-DM [15],
Microsoft TDSP [16], Agile DS Lifecycle [17], Domino
DS Lifecycle [18], IBM FMDS [19], RAMSYS [20], and
MIDST [21]. An extensive critical review over 19 data science
methodologies was presented in [14].
However, while the proposed solutions are leading the
way in addressing these organizational and socio-technical
challenges, the reality is that data science projects are not
taking advantage of such methodologies and frameworks.
According to a survey [22] carried out in 2018 to professionals
from both industry and non-proﬁt organizations, 82% of the
respondents did not follow an explicit process methodology
for developing data science projects, and equally important,
85% of the respondents considered that using an improved
and more consistent process would result in more effective
data science projects. Furthermore, a survey conducted to
nearly 800 data and analytics leaders by Corinium Intelligence
[7] found that only 48% of data science organizations have
established standardized processes.
Considering a survey from KDnuggets in 2014 [6], the main
methodology used by 43% of respondents was CRISP-DM.
This methodology has been consistently the most commonly
used for analytics, data mining, and data science projects, for
each KDnuggets poll starting in 2002 up through the most
recent 2014 poll [8]. Recently, Saltz [9] conducted a survey
to 109 respondents to gather information about what project
management framework teams used to help them execute
data science projects. CRISP-DM is used by nearly half of
all respondents. Scrum, Kanban, and customized processes
followed.
According to the results of these surveys, the percentage of
people using CRISP-DM has not changed signiﬁcantly over
the last 20 years, indicating that technology has advanced
much faster than organizational processes for handling data
science projects.
III. METHODS
To better understand the use of project management method-
ologies and the priorities of data science professionals during
project execution, a cross-sectional quantitative survey was
conducted. This survey focused on understanding the pro-
fessional proﬁle of the respondents (Q1 −Q5), the type of
projects they carry out (Q6 −Q8), the most important factors
to successfully develop a DS project Q9 and whether they use
any project methodology Q10 −Q11 (Table II). In total 237
professionals from industry and research organizations were
surveyed during September 2021. Participants accessed the
survey via the LinkedIn professional network.
Question
Fig.
Q1
In what country do you work?
A.1
Q2
Which title best describes your role?
A.2
Q3
Which is your job experience level?
1
Q4
Who are the stakeholders of your work projects?
1
Q5
What is your gender?
1
Q6
Average project duration (<3, <6, >6 months)
1
Q7
Do you usually work in group or individually?
1
Q8
Magnitude of the project (local/national/international)
1
Q9
How relevant are these factors for the
development of data science projects?
3
Q10
Do you usually follow some data
science project methodology?
1
Q11
Select the methodologies you know about
and/or have used for your data science projects
2
TABLE II
SURVEY QUESTIONS
IV. RESULTS
The results of the survey are presented and discussed in
this section. First, the respondents’ professional proﬁles are
examined. The use of data science methodologies is then
investigated, and ﬁnally, the relevance scores assigned to
ﬁfteen success factors are presented.
A. Professional proﬁles
The survey included professionals from 35 different coun-
tries, the majority of whom work in the United States of
America or Spain. Among the survey respondents, 27% were
data scientists, 14% data engineers, 12% business analysts,
12% data analysts, 11% machine learning engineers and 6%
software developers. Figures A.1 and A.2 show a detailed view
of work-country and professional-roles respectively.

---

38.8%
18.1%
39.2%
25.3%
28.7%
21.9%
24.1%
67.5%
28.7%
41.4%
19.8%
35%
9.3%
11.4%
77.6%
28.7%
17.7%
7.2%
46.4%
8%
77.6%
14.3%
NA
From 3 to 6
months
Less than 3
months
More than 6
months
NA
Depends on the
project
No
Yes
NA
Group
Individually
NA
International
Local
National
NA
Female
Male
Other
Associate/Mid
Entry
Executive
Senior
Academic
institutions
Business
organizations
Technological
institutions
Who are the
stakeholders of your
work projects?
Which is your job
experience level?
What is your gender?
Magnitude of the
project
Do you usually
work in group or
individually?
Do you usually
follow some Data
Science project
methodology?
Average project
duration
0
50
100
150
200
Survey Respondents
Question
Fig. 1. Survey results to additional questions Q3 −Q8, Q10. NA means "Not
Answer".
The vast majority of respondents (77%) identiﬁed as male.
The level of job experience among the professionals polled
was distributed as follows: 46% senior, 28% associate, 18%
entry-level, and 7% executive. Hence, more than half of the
surveyed professionals have many years of experience under
the belt.
With regard to project characteristics, nearly 40% of the
respondents say a project usually takes more than 6 months
to complete, while another 40% says it takes between 3 to
6 months. This may suggest that long projects are the norm
in the ﬁeld of data science. In terms of projects magnitude,
42% of the professionals work on international projects, 35%
on national and 20% on local projects. This implies that
the majority of data science projects are large and involve
a large number of stakeholders, who in the case of this
survey are mostly business organizations (77%). With respect
to teamwork, 68% of the professionals polled say they usually
work in groups, with 29% working individually. This shows
the importance of coordination, transparent communication,
and collaboration among individuals and teams for the success
of DS projects. See Figure 1 for a detailed view on these
matters.
B. Data science methodologies
With regard to data science methodologies, Agile DS Lifecy-
cle is the most widely used framework, followed by CRISP-
DM and Microsoft TDSP (Figure 2). Few people use their
in-house methodology. However, it is remarkable to see that
only 25% of the participants are aware of CRISP-DM, whereas
65% of them know about Agile DS Lifecycle.
65.5 %
24.3 %
16.4 %
20.3 %
20.3 %
13.6 %
13 %
34.5 %
75.7 %
83.6 %
79.7 %
79.7 %
86.4 %
87 %
45.2 %
13.6 %
7.3 %
54.8 %
86.4 %
98.3 %
98.3 %
92.7 %
97.7 %
99.4 %
RAMSYS
MIDST
Microsoft TDSP
IBM FMDS
Domino DS Lifecycle
CRISP−DM
Agile DS Lifecycle
0
50
100
150
Survey Respondents
Methodology
Know about it
Did not know
Used it
Did not use
Fig. 2. Survey results to the use of methodologies for data science projects
(question Q11)
The fact that 75% of the respondents are unaware of
CRISP-DM may indicate a different trend in the use of this
methodology when compared with data collected in previous
surveys [6], [9], with around 45% use of CRISP-DM. Other
factors, such as the number of respondents and the distribution
of their professional proﬁles, may have skewed these ﬁndings.
An extensive survey could help to reduce this uncertainty.
Furthermore, only 25% of the survey participants state
they use some kind of data science project methodology, and
another 29% say it depends on the project. Moreover, the
number of NA (not answer) responses may suggest that the
proportion of people using a DS methodology is less than
25%. In any case, this low percentage demonstrates the lack
of a deﬁned process methodology for managing data science
projects, which has been recognized as one of the primary
causes for current failures and management challenges.
C. Success factors
Question Q9 requested survey participants to evaluate the
importance of ﬁfteen factors for the development and success
of data science projects. These factors are thought to contribute
to the project’s success in meeting its objectives, and were
selected based on an analysis of current challenges in data
science projects [14]. The scoring system followed a 5 point
Likert scale, from 1 (not important at all) to 5 (absolutely
essential). Figure 3 shows the distribution of the scores, along
with the weighted average and standard deviation for each
factor. The factors are listed in descending order (from top
to bottom in the ﬁgure) based on their weighted average
score. The top three most important success factors are to
1) precisely describe stakeholders needs, 2) communicate

---

8.4%
28.9%
55.8%
22.1%
37.4%
25.3%
9.5%
12.1%
18.9%
27.9%
34.7%
11.1%
32.6%
32.6%
20.5%
10%
32.1%
35.3%
20%
12.6%
22.1%
32.6%
30%
21.1%
38.9%
32.6%
8.9%
28.9%
33.2%
26.3%
7.9%
34.7%
36.3%
18.9%
18.4%
45.3%
28.4%
8.4%
32.1%
54.2%
18.4%
43.2%
32.1%
18.9%
44.7%
32.1%
29.5%
40%
22.1%
7.9%
18.9%
35.3%
34.2%
4.32 ± 0.94
3.11 ± 1.04
3.73 ± 1.23
3.56 ± 1.03
3.60 ± 1.00
3.75 ± 1.10
3.95 ± 0.95
3.72 ± 1.03
3.62 ± 0.95
3.92 ± 0.95
4.34 ± 0.88
3.99 ± 0.91
4.04 ± 0.85
3.73 ± 0.97
3.88 ± 1.08
Weighted
Avg ± Std
Data augmentation or metadata enrichment
Data visualization tools
Define a data lifecycle workflow
Harness knowledge for future work
Establishing timelines and deliverables
Data security and privacy
Understanding each team member skills and role
Deployment pipeline to production
Version control for code, data & models
Identify project potential risks and pitfalls
Develop a strategy to meet project requirements
Proactive team communication
Team collaboration and coordination
Communicating the results to end−users
Precisely describe stakeholders needs
0
50
100
150
Survey Respondents
Factor
5−Absolutely essential
4−Very important
3−Moderately important
2−Little importance
1−Not important at all
Fig. 3. Survey results to "how relevant are these factors for the development of data science projects?" question Q9. The scoring weights range from 1 (not
important at all) to 5 (absolutely essential). The weighted average and standard deviation are calculated based on the response count and the weight for the
answer choice.
the results to end-users, and 3) team collaboration and
coordination. The less important ones, on the other hand,
are data augmentation, data visualization tools and deﬁning
data life-cycle workﬂow. It is also worth noting the factors
with the highest standard deviations: deployment pipeline to
production and data security and privacy had more variance
in their scores, which could indicate that professionals have
differing views on the importance of these factors.
Furthermore, an additional analysis of these scores was
performed to determine whether there were any signiﬁcant dif-
ferences between professionals who use a project methodology
and those who do not. Using the responses from question Q10
(Do you usually follow a data science project methodology?),
the weighted average scores were computed for each choice
(Yes / No / Depends on the project), which are shown in
Figure 4. The orange asterisk on the right side indicates a
signiﬁcant difference between the Yes and No cases, based on
Mann-Whitney U-test. Statistical tests are performed using R
v3.6.3 [23]. Professionals who follow a project methodology
give more importance to a) the project’s potential risks and
pitfalls, b) version control, c) the deployment pipeline to
production, and d) data security and privacy.
D. Common factor analysis
Using the results from question Q9, common factor analysis
was conducted to see if there were are any latent variables in
the data, i.e., groups of factors that were answered similarly
based on the survey participants’ scores.
To begin, Bartlett’s test of sphericity and the Kaiser-Meyer-
Olkin measure of sampling adequacy were used to check
whether any meaningful latent factors could be found within
the data. The parallel analysis method was then used to
determine the number of factors, which resulted in 3 factors.
The results of the common factor analysis are shown in
Figure 5 (in blue color). Prior to the survey’s public release,
each of the ﬁfteen factors was weighted and classiﬁed based
on three distinct and speciﬁc latent dimensions (in yellow).
These latent variables were selected based on a previous
paper by the authors [14], which proposes the principles of
an integral methodology for data science that should include
three foundation stones: team, data and project management.
More information on the proposed principles for integral
methodologies can be found in section 5 (discussion) of [14].
Comparing the results from the common factor analysis with
the authors’ a priori determined weights, it can be observed

---

4.26
4.25
4.47
3.04 3.10 3.23
3.63
3.52
3.91
3.51 3.56 3.65
3.54
3.52
3.82
3.79
3.54
3.96
3.88
4.10
4.02
3.51
3.85
3.82
3.49
3.75
3.65
3.88
3.77
4.19
4.21
4.40 4.46
3.96 4.00 4.04
4.04
3.98
4.12
3.69 3.75 3.81
3.74
3.73
4.21
✱
✱
✱
✱
Data augmentation or metadata enrichment
Data visualization tools
Harness knowledge for future work
Define a data lifecycle workflow
Data security and privacy
Establishing timelines and deliverables
Understanding each team member skills
and role
Deployment pipeline to production
Version control for code, data & models
Identify project potential risks and
pitfalls
Proactive team communication
Develop a strategy to meet project
requirements
Team collaboration and coordination
Communicating the results to end-users
Precisely describe stakeholders needs
3.0
3.5
4.0
4.5
Score
Factor
Professionals address to DS methodology
Yes
No
Depends on the project
Fig. 4. Comparison of weighted average scores between people who follow
(and do not) follow any data science project methodology. The orange asterisk
on the right side indicates a signiﬁcant difference between the Yes and No
cases, based on Mann-Whitney U-test.
that the ﬁrst factor is related to the team management facet,
the second to the data management aspect and the third
to the project management. Hence, based on the relevance
scores provided by the survey participants and the conducted
factor analysis, it can be concluded that there are three latent
variables and, in addition, these coincide with the a priori set
values based on the proposed framework [14].
V. CONCLUSIONS
This article presents new empirical data from a survey to
237 data science professionals on the use of project manage-
ment methodologies for data science. Several aspects of survey
respondents’ work as data science professionals were evalu-
ated, including their experience level and role (data scientist,
data engineer, business analyst, etc.), projects characteristics
(magnitude, duration) and their priorities when executing data
science projects. Regarding the limitations of the presented
study, note there may be a bias due to the survey’s non-
probabilistic design.
According to this survey study, the most widely used
framework is Agile DS lifecycle, which has surpassed the
long-standing CRISP-DM methodology. However, only 25%
of the survey participants state to follow a data science project
methodology. This low percentage shows the lack of a deﬁned
process methodology for managing data science projects,
which has been identiﬁed as one of the primary causes for
current failures and management challenges. With regard to
the study of the success factors, based on the scores gathered,
the most important factors are (1) precisely describing stake-
Factor 1 (Team)
Factor 2 (Data)
Factor 3 (Project)
0.0
0.5
0.0
0.5
0.0
0.5
Communicating the results to end−users
Data augmentation or metadata enrichment
Data security and privacy
Data visualization tools
Define a data lifecycle workflow
Deployment pipeline to production
Develop a strategy to meet project requirements
Establishing timelines and deliverables
Harness knowledge for future work
Identify project potential risks and pitfalls
Precisely describe stakeholders needs
Proactive team communication
Team collaboration and coordination
Version control for code, data & models
Normalized loadings
Factor
A priori assigned
Factor analysis
Fig. 5. Factor analysis loadings. Comparison with preassigned weights prior
to the survey.
holders’ needs, (2) communicating the results to end-users,
and (3) team collaboration and coordination. Furthermore, a
statistical analysis of the scores revealed that professionals
who adhere to a project methodology place a greater emphasis
on the project’s potential risks and pitfalls, version control,
the deployment pipeline to production, and data security and
privacy. The obtained scores were subjected to a common
factor analysis, which revealed three latent factors. Comparing
the results from the common factor analysis with a priori
determined weights, the ﬁrst factor was related to the team
management facet, the second to the data management aspect
and the third to the project management.
Therefore, this survey reinforces the notion that the three
most important factors for successful DS projects are project
development, teamwork, and data management. The latter is
also most valued by those professionals who use DS method-
ologies. However, the methodologies that attempt to address
these three factors and were best valued according to the
principles of an integral methodology in [14] are hardly known
and used. There is still a need for greater dissemination of the
methodologies that reinforce these factors or for improving
and incorporating such factors into the most widely used
methodologies.
REFERENCES
[1] VentureBeat, “Why do 87% of data science projects never make it into
production?” 2019.
[2] New Vantage, “NewVantage Partners 2019 Big Data and AI Executive
Survey,” 2019.
[3] S. K. Sam Ransbotham, “Winning with ai,” Oct 2019. [Online].
Available: https://sloanreview.mit.edu/projects/winning-with-ai/
[4] Gartner, “Taking a First Step to Advanced Analytics.”

---

[5] J. S. Saltz, “The need for new processes, methodologies and tools to
support big data teams and improve big data project effectiveness,” in
2015 IEEE International Conference on Big Data (Big Data), Oct 2015,
pp. 2066–2071.
[6] G. Piatetsky, “Crisp-dm, still the top methodology for analytics, data
mining, or data science projects,” KDD News, 2014.
[7] C. G. Intelligence, “2020 state of data & analytics us.” [Online].
Available: https://www.coriniumintelligence.com/reports/2020-soda-us
[8] Jeffrey Saltz and Nicholas J Hotz, “CRISP-DM – Data Science Project
Management,” 2019.
[9] J.
Saltz,
“Crisp-dm
is
still
the
most
popular
framework
for
executing
data
science
projects,”
Jul
2021.
[Online].
Available:
https://www.datascience-pm.com/crisp-dm-still-most-popular/
[10] Nathan Benaich and Ian Hogarth, “State of AI 2019.”
[11] Mondal, Bhaskar, Artiﬁcial Intelligence: State of the Art.
Cham:
Springer International Publishing, 2020, pp. 389–425.
[12] N. S. Mayur P. Joshi, “Why so many data science projects fail
to deliver,” Mar 2021. [Online]. Available: https://sloanreview.mit.edu/
article/why-so-many-data-science-projects-fail-to-deliver/
[13] J. Saltz, I. Shamshurin, and C. Connors, “Predicting data science so-
ciotechnical execution challenges by categorizing data science projects,”
Journal of the Association for Information Science and Technology,
vol. 68, no. 12, pp. 2720–2728, 2017.
[14] I. Martinez, E. Viles, and I. G. Olaizola, “Data science methodologies:
Current challenges and future approaches,” Big Data Research, vol. 24,
p. 100183, 2021. [Online]. Available: https://www.sciencedirect.com/
science/article/pii/S2214579620300514
[15] R. Wirth and J. Hipp, “Crisp-dm: Towards a standard process model for
data mining,” in Proceedings of the 4th international conference on the
practical applications of knowledge discovery and data mining, vol. 1.
Springer-Verlag London, UK, 2000.
[16] Microsoft, “What is the team data science process? - azure architecture
center.”
[Online].
Available:
https://docs.microsoft.com/en-us/azure/
architecture/data-science-process/overview
[17] J. Russell, “Agile data science 2.0: Building full-stack data analytics
applications with spark,” 2017.
[18] Nicholas J Hotz and Jeffrey Saltz, “Domino Data Science Lifecycle –
Data Science Project Management,” 2018.
[19] John Rollings, “Foundational methodology for data science,” 2015.
[20] S. Moyle and A. Jorge, “Ramsys - a methodology for supporting
rapid remote collaborative data mining projects,” in ECML/PKDD01
Workshop: Integrating Aspects of Data Mining, Decision Support and
Meta-learning (IDDM-2001), vol. 64, 2001.
[21] K. Crowston, J. S. Saltz, A. Rezgui, Y. Hegde, and S. You, “Socio-
technical affordances for stigmergic coordination implemented in midst,
a tool for data-science teams,” Proceedings of the ACM on Human-
Computer Interaction, vol. 3, no. CSCW, pp. 1–25, 2019.
[22] J. Saltz, N. Hotz, D. J. Wild, and K. Stirling, “Exploring project
management methodologies used within data science teams,” in AMCIS,
2018.
[23] R Core Team, R: A Language and Environment for Statistical
Computing, R Foundation for Statistical Computing, Vienna, Austria,
2020. [Online]. Available: https://www.R-project.org
APPENDIX A
SURVEY ADDITIONAL RESULTS
6
2
2
61
6
8
4
2
2
3
9
2
3
6
4
11
3
16
67
4
Items with 1 count
                         Chile
                         China
                        Brazil
                        Greece
                        Poland
                       Austria
                       Romania
                      Colombia
                      Thailand
                    Luxembourg
                    Mauritania
                   Afghanistan
                  South Africa
             Brunei Darussalam
          Syrian Arab Republic
          United Arab Emirates
Items with 1 count
                         Chile
                         China
                        Brazil
                        Greece
                        Poland
                       Austria
                       Romania
                      Colombia
                      Thailand
                    Luxembourg
                    Mauritania
                   Afghanistan
                  South Africa
             Brunei Darussalam
          Syrian Arab Republic
          United Arab Emirates
Items with 1 count
                         Chile
                         China
                        Brazil
                        Greece
                        Poland
                       Austria
                       Romania
                      Colombia
                      Thailand
                    Luxembourg
                    Mauritania
                   Afghanistan
                  South Africa
             Brunei Darussalam
          Syrian Arab Republic
          United Arab Emirates
Items with 1 count
                         Chile
                         China
                        Brazil
                        Greece
                        Poland
                       Austria
                       Romania
                      Colombia
                      Thailand
                    Luxembourg
                    Mauritania
                   Afghanistan
                  South Africa
             Brunei Darussalam
          Syrian Arab Republic
          United Arab Emirates
Items with 1 count
                         Chile
                         China
                        Brazil
                        Greece
                        Poland
                       Austria
                       Romania
                      Colombia
                      Thailand
                    Luxembourg
                    Mauritania
                   Afghanistan
                  South Africa
             Brunei Darussalam
          Syrian Arab Republic
          United Arab Emirates
Items with 1 count
                         Chile
                         China
                        Brazil
                        Greece
                        Poland
                       Austria
                       Romania
                      Colombia
                      Thailand
                    Luxembourg
                    Mauritania
                   Afghanistan
                  South Africa
             Brunei Darussalam
          Syrian Arab Republic
          United Arab Emirates
Items with 1 count
                         Chile
                         China
                        Brazil
                        Greece
                        Poland
                       Austria
                       Romania
                      Colombia
                      Thailand
                    Luxembourg
                    Mauritania
                   Afghanistan
                  South Africa
             Brunei Darussalam
          Syrian Arab Republic
          United Arab Emirates
Items with 1 count
                         Chile
                         China
                        Brazil
                        Greece
                        Poland
                       Austria
                       Romania
                      Colombia
                      Thailand
                    Luxembourg
                    Mauritania
                   Afghanistan
                  South Africa
             Brunei Darussalam
          Syrian Arab Republic
          United Arab Emirates
Items with 1 count
                         Chile
                         China
                        Brazil
                        Greece
                        Poland
                       Austria
                       Romania
                      Colombia
                      Thailand
                    Luxembourg
                    Mauritania
                   Afghanistan
                  South Africa
             Brunei Darussalam
          Syrian Arab Republic
          United Arab Emirates
Items with 1 count
                         Chile
                         China
                        Brazil
                        Greece
                        Poland
                       Austria
                       Romania
                      Colombia
                      Thailand
                    Luxembourg
                    Mauritania
                   Afghanistan
                  South Africa
             Brunei Darussalam
          Syrian Arab Republic
          United Arab Emirates
Items with 1 count
                         Chile
                         China
                        Brazil
                        Greece
                        Poland
                       Austria
                       Romania
                      Colombia
                      Thailand
                    Luxembourg
                    Mauritania
                   Afghanistan
                  South Africa
             Brunei Darussalam
          Syrian Arab Republic
          United Arab Emirates
Items with 1 count
                         Chile
                         China
                        Brazil
                        Greece
                        Poland
                       Austria
                       Romania
                      Colombia
                      Thailand
                    Luxembourg
                    Mauritania
                   Afghanistan
                  South Africa
             Brunei Darussalam
          Syrian Arab Republic
          United Arab Emirates
Items with 1 count
                         Chile
                         China
                        Brazil
                        Greece
                        Poland
                       Austria
                       Romania
                      Colombia
                      Thailand
                    Luxembourg
                    Mauritania
                   Afghanistan
                  South Africa
             Brunei Darussalam
          Syrian Arab Republic
          United Arab Emirates
Items with 1 count
                         Chile
                         China
                        Brazil
                        Greece
                        Poland
                       Austria
                       Romania
                      Colombia
                      Thailand
                    Luxembourg
                    Mauritania
                   Afghanistan
                  South Africa
             Brunei Darussalam
          Syrian Arab Republic
          United Arab Emirates
Items with 1 count
                         Chile
                         China
                        Brazil
                        Greece
                        Poland
                       Austria
                       Romania
                      Colombia
                      Thailand
                    Luxembourg
                    Mauritania
                   Afghanistan
                  South Africa
             Brunei Darussalam
          Syrian Arab Republic
          United Arab Emirates
Items with 1 count
                         Chile
                         China
                        Brazil
                        Greece
                        Poland
                       Austria
                       Romania
                      Colombia
                      Thailand
                    Luxembourg
                    Mauritania
                   Afghanistan
                  South Africa
             Brunei Darussalam
          Syrian Arab Republic
          United Arab Emirates
Items with 1 count
                         Chile
                         China
                        Brazil
                        Greece
                        Poland
                       Austria
                       Romania
                      Colombia
                      Thailand
                    Luxembourg
                    Mauritania
                   Afghanistan
                  South Africa
             Brunei Darussalam
          Syrian Arab Republic
          United Arab Emirates
Items with 1 count
                         Chile
                         China
                        Brazil
                        Greece
                        Poland
                       Austria
                       Romania
                      Colombia
                      Thailand
                    Luxembourg
                    Mauritania
                   Afghanistan
                  South Africa
             Brunei Darussalam
          Syrian Arab Republic
          United Arab Emirates
Items with 1 count
                         Chile
                         China
                        Brazil
                        Greece
                        Poland
                       Austria
                       Romania
                      Colombia
                      Thailand
                    Luxembourg
                    Mauritania
                   Afghanistan
                  South Africa
             Brunei Darussalam
          Syrian Arab Republic
          United Arab Emirates
Items with 1 count
                         Chile
                         China
                        Brazil
                        Greece
                        Poland
                       Austria
                       Romania
                      Colombia
                      Thailand
                    Luxembourg
                    Mauritania
                   Afghanistan
                  South Africa
             Brunei Darussalam
          Syrian Arab Republic
          United Arab Emirates
Items with 1 count
                         Chile
                         China
                        Brazil
                        Greece
                        Poland
                       Austria
                       Romania
                      Colombia
                      Thailand
                    Luxembourg
                    Mauritania
                   Afghanistan
                  South Africa
             Brunei Darussalam
          Syrian Arab Republic
          United Arab Emirates
Items with 1 count
                         Chile
                         China
                        Brazil
                        Greece
                        Poland
                       Austria
                       Romania
                      Colombia
                      Thailand
                    Luxembourg
                    Mauritania
                   Afghanistan
                  South Africa
             Brunei Darussalam
          Syrian Arab Republic
          United Arab Emirates
Items with 1 count
                         Chile
                         China
                        Brazil
                        Greece
                        Poland
                       Austria
                       Romania
                      Colombia
                      Thailand
                    Luxembourg
                    Mauritania
                   Afghanistan
                  South Africa
             Brunei Darussalam
          Syrian Arab Republic
          United Arab Emirates
Items with 1 count
                         Chile
                         China
                        Brazil
                        Greece
                        Poland
                       Austria
                       Romania
                      Colombia
                      Thailand
                    Luxembourg
                    Mauritania
                   Afghanistan
                  South Africa
             Brunei Darussalam
          Syrian Arab Republic
          United Arab Emirates
Items with 1 count
                         Chile
                         China
                        Brazil
                        Greece
                        Poland
                       Austria
                       Romania
                      Colombia
                      Thailand
                    Luxembourg
                    Mauritania
                   Afghanistan
                  South Africa
             Brunei Darussalam
          Syrian Arab Republic
          United Arab Emirates
Items with 1 count
                         Chile
                         China
                        Brazil
                        Greece
                        Poland
                       Austria
                       Romania
                      Colombia
                      Thailand
                    Luxembourg
                    Mauritania
                   Afghanistan
                  South Africa
             Brunei Darussalam
          Syrian Arab Republic
          United Arab Emirates
Items with 1 count
                         Chile
                         China
                        Brazil
                        Greece
                        Poland
                       Austria
                       Romania
                      Colombia
                      Thailand
                    Luxembourg
                    Mauritania
                   Afghanistan
                  South Africa
             Brunei Darussalam
          Syrian Arab Republic
          United Arab Emirates
Items with 1 count
                         Chile
                         China
                        Brazil
                        Greece
                        Poland
                       Austria
                       Romania
                      Colombia
                      Thailand
                    Luxembourg
                    Mauritania
                   Afghanistan
                  South Africa
             Brunei Darussalam
          Syrian Arab Republic
          United Arab Emirates
Items with 1 count
                         Chile
                         China
                        Brazil
                        Greece
                        Poland
                       Austria
                       Romania
                      Colombia
                      Thailand
                    Luxembourg
                    Mauritania
                   Afghanistan
                  South Africa
             Brunei Darussalam
          Syrian Arab Republic
          United Arab Emirates
Items with 1 count
                         Chile
                         China
                        Brazil
                        Greece
                        Poland
                       Austria
                       Romania
                      Colombia
                      Thailand
                    Luxembourg
                    Mauritania
                   Afghanistan
                  South Africa
             Brunei Darussalam
          Syrian Arab Republic
          United Arab Emirates
Items with 1 count
                         Chile
                         China
                        Brazil
                        Greece
                        Poland
                       Austria
                       Romania
                      Colombia
                      Thailand
                    Luxembourg
                    Mauritania
                   Afghanistan
                  South Africa
             Brunei Darussalam
          Syrian Arab Republic
          United Arab Emirates
Items with 1 count
                         Chile
                         China
                        Brazil
                        Greece
                        Poland
                       Austria
                       Romania
                      Colombia
                      Thailand
                    Luxembourg
                    Mauritania
                   Afghanistan
                  South Africa
             Brunei Darussalam
          Syrian Arab Republic
          United Arab Emirates
Items with 1 count
                         Chile
                         China
                        Brazil
                        Greece
                        Poland
                       Austria
                       Romania
                      Colombia
                      Thailand
                    Luxembourg
                    Mauritania
                   Afghanistan
                  South Africa
             Brunei Darussalam
          Syrian Arab Republic
          United Arab Emirates
Items with 1 count
                         Chile
                         China
                        Brazil
                        Greece
                        Poland
                       Austria
                       Romania
                      Colombia
                      Thailand
                    Luxembourg
                    Mauritania
                   Afghanistan
                  South Africa
             Brunei Darussalam
          Syrian Arab Republic
          United Arab Emirates
Items with 1 count
                         Chile
                         China
                        Brazil
                        Greece
                        Poland
                       Austria
                       Romania
                      Colombia
                      Thailand
                    Luxembourg
                    Mauritania
                   Afghanistan
                  South Africa
             Brunei Darussalam
          Syrian Arab Republic
          United Arab Emirates
Items with 1 count
                         Chile
                         China
                        Brazil
                        Greece
                        Poland
                       Austria
                       Romania
                      Colombia
                      Thailand
                    Luxembourg
                    Mauritania
                   Afghanistan
                  South Africa
             Brunei Darussalam
          Syrian Arab Republic
          United Arab Emirates
                         Italy
                         Japan
                        Sweden
                       Belgium
                       Ireland
                       Denmark
                      Portugal
                   New Zealand
                        Norway
                     Singapore
                         India
                        Canada
                     Australia
                        France
                       Germany
                   Netherlands
                United Kingdom
                         Spain
     United States of America
NA
0
20
40
60
Survey Respondents
Fig. A.1. Survey results to "in what country do you work?" question Q1
2
2
28
3
3
33
2
8
66
3
28
14
2
2
27
Items with 1 count
                       C−Suite
                     Economist
                    Consultant
                    Strategist
                   Analyst NOC
               Biostatistician
               Cloud Architect
            Aerospace Engineer
            Analytics Engineer
           Industrial engineer
       Data Operations Manager
      User Experience Engineer
   Vice President of Analytics
Functional application manager
Items with 1 count
                       C−Suite
                     Economist
                    Consultant
                    Strategist
                   Analyst NOC
               Biostatistician
               Cloud Architect
            Aerospace Engineer
            Analytics Engineer
           Industrial engineer
       Data Operations Manager
      User Experience Engineer
   Vice President of Analytics
Functional application manager
Items with 1 count
                       C−Suite
                     Economist
                    Consultant
                    Strategist
                   Analyst NOC
               Biostatistician
               Cloud Architect
            Aerospace Engineer
            Analytics Engineer
           Industrial engineer
       Data Operations Manager
      User Experience Engineer
   Vice President of Analytics
Functional application manager
Items with 1 count
                       C−Suite
                     Economist
                    Consultant
                    Strategist
                   Analyst NOC
               Biostatistician
               Cloud Architect
            Aerospace Engineer
            Analytics Engineer
           Industrial engineer
       Data Operations Manager
      User Experience Engineer
   Vice President of Analytics
Functional application manager
Items with 1 count
                       C−Suite
                     Economist
                    Consultant
                    Strategist
                   Analyst NOC
               Biostatistician
               Cloud Architect
            Aerospace Engineer
            Analytics Engineer
           Industrial engineer
       Data Operations Manager
      User Experience Engineer
   Vice President of Analytics
Functional application manager
Items with 1 count
                       C−Suite
                     Economist
                    Consultant
                    Strategist
                   Analyst NOC
               Biostatistician
               Cloud Architect
            Aerospace Engineer
            Analytics Engineer
           Industrial engineer
       Data Operations Manager
      User Experience Engineer
   Vice President of Analytics
Functional application manager
Items with 1 count
                       C−Suite
                     Economist
                    Consultant
                    Strategist
                   Analyst NOC
               Biostatistician
               Cloud Architect
            Aerospace Engineer
            Analytics Engineer
           Industrial engineer
       Data Operations Manager
      User Experience Engineer
   Vice President of Analytics
Functional application manager
Items with 1 count
                       C−Suite
                     Economist
                    Consultant
                    Strategist
                   Analyst NOC
               Biostatistician
               Cloud Architect
            Aerospace Engineer
            Analytics Engineer
           Industrial engineer
       Data Operations Manager
      User Experience Engineer
   Vice President of Analytics
Functional application manager
Items with 1 count
                       C−Suite
                     Economist
                    Consultant
                    Strategist
                   Analyst NOC
               Biostatistician
               Cloud Architect
            Aerospace Engineer
            Analytics Engineer
           Industrial engineer
       Data Operations Manager
      User Experience Engineer
   Vice President of Analytics
Functional application manager
Items with 1 count
                       C−Suite
                     Economist
                    Consultant
                    Strategist
                   Analyst NOC
               Biostatistician
               Cloud Architect
            Aerospace Engineer
            Analytics Engineer
           Industrial engineer
       Data Operations Manager
      User Experience Engineer
   Vice President of Analytics
Functional application manager
Items with 1 count
                       C−Suite
                     Economist
                    Consultant
                    Strategist
                   Analyst NOC
               Biostatistician
               Cloud Architect
            Aerospace Engineer
            Analytics Engineer
           Industrial engineer
       Data Operations Manager
      User Experience Engineer
   Vice President of Analytics
Functional application manager
Items with 1 count
                       C−Suite
                     Economist
                    Consultant
                    Strategist
                   Analyst NOC
               Biostatistician
               Cloud Architect
            Aerospace Engineer
            Analytics Engineer
           Industrial engineer
       Data Operations Manager
      User Experience Engineer
   Vice President of Analytics
Functional application manager
Items with 1 count
                       C−Suite
                     Economist
                    Consultant
                    Strategist
                   Analyst NOC
               Biostatistician
               Cloud Architect
            Aerospace Engineer
            Analytics Engineer
           Industrial engineer
       Data Operations Manager
      User Experience Engineer
   Vice President of Analytics
Functional application manager
Items with 1 count
                       C−Suite
                     Economist
                    Consultant
                    Strategist
                   Analyst NOC
               Biostatistician
               Cloud Architect
            Aerospace Engineer
            Analytics Engineer
           Industrial engineer
       Data Operations Manager
      User Experience Engineer
   Vice President of Analytics
Functional application manager
Items with 1 count
                       C−Suite
                     Economist
                    Consultant
                    Strategist
                   Analyst NOC
               Biostatistician
               Cloud Architect
            Aerospace Engineer
            Analytics Engineer
           Industrial engineer
       Data Operations Manager
      User Experience Engineer
   Vice President of Analytics
Functional application manager
Items with 1 count
                       C−Suite
                     Economist
                    Consultant
                    Strategist
                   Analyst NOC
               Biostatistician
               Cloud Architect
            Aerospace Engineer
            Analytics Engineer
           Industrial engineer
       Data Operations Manager
      User Experience Engineer
   Vice President of Analytics
Functional application manager
Items with 1 count
                       C−Suite
                     Economist
                    Consultant
                    Strategist
                   Analyst NOC
               Biostatistician
               Cloud Architect
            Aerospace Engineer
            Analytics Engineer
           Industrial engineer
       Data Operations Manager
      User Experience Engineer
   Vice President of Analytics
Functional application manager
Items with 1 count
                       C−Suite
                     Economist
                    Consultant
                    Strategist
                   Analyst NOC
               Biostatistician
               Cloud Architect
            Aerospace Engineer
            Analytics Engineer
           Industrial engineer
       Data Operations Manager
      User Experience Engineer
   Vice President of Analytics
Functional application manager
Items with 1 count
                       C−Suite
                     Economist
                    Consultant
                    Strategist
                   Analyst NOC
               Biostatistician
               Cloud Architect
            Aerospace Engineer
            Analytics Engineer
           Industrial engineer
       Data Operations Manager
      User Experience Engineer
   Vice President of Analytics
Functional application manager
Items with 1 count
                       C−Suite
                     Economist
                    Consultant
                    Strategist
                   Analyst NOC
               Biostatistician
               Cloud Architect
            Aerospace Engineer
            Analytics Engineer
           Industrial engineer
       Data Operations Manager
      User Experience Engineer
   Vice President of Analytics
Functional application manager
Items with 1 count
                       C−Suite
                     Economist
                    Consultant
                    Strategist
                   Analyst NOC
               Biostatistician
               Cloud Architect
            Aerospace Engineer
            Analytics Engineer
           Industrial engineer
       Data Operations Manager
      User Experience Engineer
   Vice President of Analytics
Functional application manager
Items with 1 count
                       C−Suite
                     Economist
                    Consultant
                    Strategist
                   Analyst NOC
               Biostatistician
               Cloud Architect
            Aerospace Engineer
            Analytics Engineer
           Industrial engineer
       Data Operations Manager
      User Experience Engineer
   Vice President of Analytics
Functional application manager
Items with 1 count
                       C−Suite
                     Economist
                    Consultant
                    Strategist
                   Analyst NOC
               Biostatistician
               Cloud Architect
            Aerospace Engineer
            Analytics Engineer
           Industrial engineer
       Data Operations Manager
      User Experience Engineer
   Vice President of Analytics
Functional application manager
Items with 1 count
                       C−Suite
                     Economist
                    Consultant
                    Strategist
                   Analyst NOC
               Biostatistician
               Cloud Architect
            Aerospace Engineer
            Analytics Engineer
           Industrial engineer
       Data Operations Manager
      User Experience Engineer
   Vice President of Analytics
Functional application manager
Items with 1 count
                       C−Suite
                     Economist
                    Consultant
                    Strategist
                   Analyst NOC
               Biostatistician
               Cloud Architect
            Aerospace Engineer
            Analytics Engineer
           Industrial engineer
       Data Operations Manager
      User Experience Engineer
   Vice President of Analytics
Functional application manager
Items with 1 count
                       C−Suite
                     Economist
                    Consultant
                    Strategist
                   Analyst NOC
               Biostatistician
               Cloud Architect
            Aerospace Engineer
            Analytics Engineer
           Industrial engineer
       Data Operations Manager
      User Experience Engineer
   Vice President of Analytics
Functional application manager
Items with 1 count
                       C−Suite
                     Economist
                    Consultant
                    Strategist
                   Analyst NOC
               Biostatistician
               Cloud Architect
            Aerospace Engineer
            Analytics Engineer
           Industrial engineer
       Data Operations Manager
      User Experience Engineer
   Vice President of Analytics
Functional application manager
Items with 1 count
                       C−Suite
                     Economist
                    Consultant
                    Strategist
                   Analyst NOC
               Biostatistician
               Cloud Architect
            Aerospace Engineer
            Analytics Engineer
           Industrial engineer
       Data Operations Manager
      User Experience Engineer
   Vice President of Analytics
Functional application manager
Items with 1 count
                       C−Suite
                     Economist
                    Consultant
                    Strategist
                   Analyst NOC
               Biostatistician
               Cloud Architect
            Aerospace Engineer
            Analytics Engineer
           Industrial engineer
       Data Operations Manager
      User Experience Engineer
   Vice President of Analytics
Functional application manager
                           R&D
                         Other
                 Product Owner
           Engineering Manager
           Mechanical Engineer
                  Data Manager
                  Statistician
               Data Consultant
                Data Architect
            Software Developer
    Machine Learning Engineer
                  Data Analyst
              Business Analyst
                 Data Engineer
                Data Scientist
0
20
40
60
Survey Respondents
Fig. A.2. Survey results to "which title best describes your role?" question
Q2

---

