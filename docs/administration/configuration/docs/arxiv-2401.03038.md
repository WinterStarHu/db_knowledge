# SPADE: Synthesizing Data Quality Assertions for Large Language Model Pipelines

> 来源: https://arxiv.org/pdf/2401.03038

spade: Synthesizing Data Quality Assertions
for Large Language Model Pipelines
Shreya Shankar1, Haotian Li2, Parth Asawa1, Madelon Hulsebos1, Yiming Lin1, J.D.
Zamfirescu-Pereira1, Harrison Chase3, Will Fu-Hinthorn3, Aditya G. Parameswaran1, Eugene Wu4
1UC Berkeley, 2HKUST, 3LangChain, 4Columbia University
{shreyashankar,pgasawa,madelon,yiminglin,zamfi,adityagp} @berkeley.edu
haotian.li@connect.ust.hk, {harrison,wfh} @langchain.dev, ewu@cs.columbia.edu
ABSTRACT
Large language models (LLMs) are being increasingly deployed as
part of pipelines that repeatedly process or generate data of some
sort. However, a common barrier to deployment are the frequent
and often unpredictable errors that plague LLMs. Acknowledging
the inevitability of these errors, we propose data quality assertions
to identify when LLMs may be making mistakes. We present spade,
a method for automatically synthesizing data quality assertions
that identify bad LLM outputs. We make the observation that de-
velopers often identify data quality issues during prototyping prior
to deployment, and attempt to address them by adding instructions
to the LLM prompt over time. spade therefore analyzes histories of
prompt versions over time to create candidate assertion functions
and then selects a minimal set that fulfills both coverage and accu-
racy requirements. In testing across nine different real-world LLM
pipelines, spade efficiently reduces the number of assertions by 14%
and decreases false failures by 21% when compared to simpler base-
lines. spade has been deployed as an offering within LangSmith,
LangChain’s LLM pipeline hub, and has been used to generate
data quality assertions for over 2000 pipelines across a spectrum of
industries.
1
INTRODUCTION
There is a lot of excitement around the use of large language models
(LLMs) for processing, understanding, and generating data [18].
Without needing large labeled datasets, one can easily create an
LLM pipeline for any task on a collection of data items—simply by
crafting a natural language prompt that instructs the LLM on what to
do with each item. This could span traditional data processing tasks,
such as summarizing each document in a corpus, extracting entities
from each news article in a collection of articles, or even imputing
missing data for each tuple in a relation [36]. LLMs additionally
enable new and more complex data processing tasks that involve
generating data, e.g., an LLM could write an explanation for why
a product was recommended to a user, author emails to potential
sales leads, or draft blog posts for marketing and outreach. In all
of these data processing tasks, deploying these LLM pipelines at
scale—either offline, on each batch of data items, or online, as and
when new items arrive—presents significant challenges, due to data
quality errors made by LLMs seemingly at random [25]—with LLMs
often disregarding instructions, making mistakes with the output
format, or hallucinating facts [50, 64].
One approach to catch errors in deployed LLM pipelines is via
data quality assertions. Indeed, multiple recent papers [28, 43, 55]
♠spade
Developer
Current
Prompt
Template
P𝑖+1
Version
History
P0, . . . , P𝑖
LLM
Output
All Example
Inputs and
Outputs
1
Generate
Assertion
Candidates
2
Filter Bad
Assertions
Assertions
to Deploy
edits
saves to
labels
saves to
Figure 1: Before a developer deploys a prompt template to
production, spade analyzes the deltas (i.e., diffs) between
consecutive prompt templates to generate assertions. Then,
spade uses labeled pipeline inputs and outputs to filter out
redundant and inaccurate assertions, while maintaining cov-
erage of bad outputs.
and LLM pipeline authoring systems [23, 29, 33] provide mecha-
nisms to embed manually-provided or selected assertions as part of
LLM pipelines to catch errors during deployment. However, deter-
mining which assertions to add remains an open problem—and is a
big customer painpoint based on our experience at LangChain—a
company that helps people build LLM pipelines. Developers often
find it difficult to determine the right set of assertions for their
custom tasks [40]. Challenges include predicting all possible LLM
failure modes, the time-consuming nature of writing assertions
with various specification methods (like Python functions or LLM
calls), the necessity for precision in assertions (especially those in-
volving LLM calls), and the fact that many LLM pipeline developers
lack software engineering expertise or coding experience [28, 64].
Moreover, if there are non-informative assertions or too many of
them, developers can get overwhelmed monitoring the results of
these assertions. While there is some work on automatically detect-
ing errors in traditional ML pipelines [5, 41, 48, 49], this line of work
operates on many structured records at a time, and doesn’t apply to
an unstructured setting. So, we target the following question: can
arXiv:2401.03038v2  [cs.DB]  31 Mar 2024

---

we identify data quality assertions for LLM pipelines with as little
effort from developers as possible?
Example LLM Pipeline. Consider an LLM pipeline for a movie
streaming platform, where the task is to generate a paragraph of
text explaining why a specific movie was recommended to a specific
user. A developer might write a prompt template like: “Given the fol-
lowing information about the user, {personal_info}, and information
about a movie, {movie_info}: write a personalized note for why the
user should watch this movie” to be executed for many user-movie
pairs. In theory, this prompt seems adequate, but the developer
might observe some data quality issues while testing it across dif-
ferent inputs: the LLM output might reference a movie the user
never watched, cite a sensitive attribute (e.g., race or ethnicity), or
even exhibit a basic issue by being too short. To fix these problems,
developers typically add instructions to the prompt to catch these
data quality issues, such as “Don’t reference race in your answer”.
However, the LLM may still violate these instructions in an unpre-
dictable manner for some data items, requiring assertions applied
to LLM outputs post-hoc, during deployment.
Analyzing Prompt Version Histories. To automatically syn-
thesize assertions for developers, our first insight is that we can
mine prompt version histories to identify assertion criteria for LLM
pipelines, since developers implicitly embed data quality require-
ments through changes to the prompt, or prompt deltas, over time.
In our example above, instructions such as “Make sure your re-
sponse is at least 3 sentences” or “Don’t reference race in your
answer” could each correspond to a candidate assertion. To under-
stand the types of prompt deltas in LLM pipelines and verify their
usefulness for data quality assertions, we present an analysis of
prompt version histories of 19 custom pipelines from LangChain
users. Using this analysis, we construct a taxonomy of prompt deltas
(Figure 2), which may be of independent interest for researchers
and practitioners studying how to best build LLM pipelines.
Redundancy in Data Quality Assertions. Our second insight
from analyzing these pipelines is that if we were to create candidate
assertions from prompt deltas, say, using an LLM, there may be
far too many assertions—often exceeding 50 for just a few prompt
deltas. Many of these assertions (or equivalently, prompt deltas)
are redundant, while some are too imprecise or ambiguous to be
useful (e.g., “return a concise response”). Reducing this redundancy
is nontrivial, even for engineers: assertions themselves can involve
LLM calls with varying accuracies, motivating an automated com-
ponent that can filter out bad candidates. One approach is to use a
small handful of developer-labeled LLM outputs to estimate each
data quality assertion’s false positive and false negative rate—but
collectively determining the right set of assertions that can catch
most errors, while incorrectly flagging as few outputs as possible,
is not straightforward.
spade: Our Data Quality Assertion Generation Framework.
In this paper, we leverage the aforementioned insights to develop
spade (System for Prompt Analysis and Delta-Based Evaluation,
Figure 1). spade’s goal is to select a set of boolean assertions
with minimal overlap, while maximizing coverage of bad outputs
and minimizing false failures (correct outputs that are incorrectly
flagged) for the conjunction of selected assertions. We decompose
spade into two components—candidate assertion generation and
filtering.
Component 1: Prompt Deltas for Candidate Assertion Generation.
For generating candidate assertions, instead of directly querying
an LLM to “write assertions for x prompt,” which causes the LLM
to miss certain portions of the prompt, we generate candidates
from each prompt delta, which typically indicate specific failure
modes of LLMs. spade leverages the aforementioned taxonomy of
prompt deltas we constructed by first automatically categorizing
deltas using the taxonomy, then synthesizing Python functions (that
may include LLM calls) as candidate assertions. At LangChain,
we publicly release this component of spade—which has been
subsequently used for over 2000 pipelines across more than
10 sectors like finance, medicine, and IT [52]. We present an
analysis of this usage in Section 2.4.
Component 2: Filtering Candidate Assertions with Limited Data. To
filter out incorrect and redundant candidate assertions, instead
of requiring cumbersome manual selection or even fine-tuning
of separate models [45, 58], we propose an automated approach
that only requires a small handful of labeled examples, which are
usually already present in most target applications. Using these
examples, we could estimate each assertion’s false failure rate (FFR),
i.e., how often an assertion incorrectly flags failures, and eliminate
individual assertions that exceed a given threshold. However, given
we are selecting a set of assertions, the set may still exceed the FFR
threshold and flag too many failures incorrectly, and redundancies
may persist. We show that selecting a small subset of assertions to
meet failure coverage and FFR criteria is NP-hard. That said, we
may express the problem as an integer linear program (ILP) and
use an ILP solver to identify a solution in a reasonable time given
the size of our problem (hundreds to thousands of variables).
In some cases, when there are limited developer-provided exam-
ples, we find that labeled LLM outputs may not cover all failure
modes, leading to omission of valuable data quality assertions. For
instance, in our movie recommendation scenario, an assertion that
correctly verifies if the output is under 200 words will get dis-
carded if all outputs in our developer-labeled sample respect this
limit. To expand coverage, active learning and weak supervision
approaches can be used to sample and label new LLM input-output
pairs for each candidate assertion [7, 42], but this may be expen-
sive or inaccessible for non-programmers. We introduce assertion
subsumption as a way of ensuring comprehensive coverage: if one
assertion doesn’t encompass the failure modes of another, both may
be selected. As such, spade selects a minimal set of assertions that
respects failure coverage, accuracy, and subsumption constraints.
Overall, we make the following contributions:
• We identify prompt version history as a rich source for
LLM output correctness, creating a taxonomy of assertion
criteria from 19 diverse LLM pipelines (Section 2),
• We introduce spade, our system that automatically gener-
ates data quality assertions for LLM pipelines. In a public
release of spade’s candidate assertion generation compo-
nent1, we observe and analyze 2000+ deployments (Sec-
tion 2.4),
1https://spade-beta.streamlit.app
2

---

Prompt Deltas
Structural
Response Format 
Instruction
Example Demonstration
Prompt Clarification
Content-Based
Workflow Description
Data Integration
Quantity Instruction
Inclusion Instruction
Exclusion Instruction
Qualitative Criteria
Other
Figure 2: Taxonomy of prompt deltas from 19 LLM pipelines.
• We present a method to select a minimal set of assertions
while meeting coverage and accuracy requirements, used
by spade to reduce the number of assertions. For low-data
settings, we introduce assertion subsumption as a novel
proxy for coverage (Section 3), and
• We demonstrate spade’s effectiveness on nine real-world
LLM pipelines (eight of which we open-source). In our
low-data setting (approximately 75 inputs and outputs per
pipeline), our subsumption-based solution outperforms sim-
pler baselines that do not consider interactions between
assertions by reducing the number of assertions by 14% and
lowering the false failure rate by 21% (Section 4).
2
IDENTIFYING CANDIDATE ASSERTIONS
Our first goal is to generate a set of candidate assertions. We de-
scribe how prompt deltas can inform candidate assertions and ex-
plain how to derive candidate assertions from them.
2.1
Prompt Deltas
A single-step LLM pipeline consists of a prompt template P, which
is formatted with a serialized input tuple 𝑡to derive a prompt
that is fed to an LLM, returning a response. There can be many
versions of P, depending on how a developer iterates on their
prompt template. Let P0 be the empty string, the 0th version, and
let P𝑖be the ith version of a template. In the movie recommendation
example from the introduction, suppose there are 7 versions, where
P7 is the following: “Given the following information about the user,
{personal_info}, and information about a movie, {movie_info}: write a
personalized note for why the user should watch this movie. Ensure
the recommendation note is concise, not exceeding 100 words. Mention
the movie’s genre and any shared cast members between the {movie_-
name} and other movies the user has watched. Mention any awards or
critical acclaim received by {movie_name}. Do not mention anything
related to the user’s race, ethnicity, or any other sensitive attributes.”
We define a prompt delta ΔP𝑖+1 to be the diff (or difference)
between P𝑖and P𝑖+1. Concretely, a prompt delta ΔP is a set of
sentences, where each sentence is tagged as an addition (i.e., “+”) or
deletion (i.e., “-”). Table 1 shows the ΔPs for a number of versions
for our example. Each sentence in ΔP𝑖is composed of additions
(i.e., new sentences in P𝑖that didn’t exist in P𝑖−1) and deletions
(i.e., sentences in P𝑖−1 that don’t exist in P𝑖). A modification to a
sentence is represented by a deletion and addition—for example,
ΔP6 in Table 1 contains some new instructions added to a sentence
from P5. Each addition in ΔP𝑖indicates possible assertion criteria,
as shown in the right-most column of Table 1.
2.2
Prompt Delta Analysis
To understand what assertions developers may care about, we turn
to real-world LLM pipelines. We analyzed 19 LLM pipelines col-
lected from LangChain users, each of which consists of between
three and 11 historical prompt template versions. These pipelines
span various tasks across more than five domains (e.g., finance,
marketing, coding, education, health), from generating workout
summaries to a chatbot acting as a statistics tutor. Table 7 in Appen-
dix B shows a summary of the pipelines, including a description of
each pipeline and the number of prompt versions. For each pipeline,
we categorized prompt deltas, i.e., ΔP𝑖, into different types—for
example, instructing the LLM to include a new phrase in each re-
sponse (i.e., inclusion), or instructing the LLM to respond with
a certain tone (i.e., qualitative criteria). Two authors iterated on
the categories 4 times through a process of open and axial coding,
ultimately producing the taxonomy in Figure 2. The taxonomy-
annotated dataset of prompt versions can be found online2.
We divide deltas into two main high-level categories: Structural
and Content-Based. Around 35% categories identified across all
deltas in our dataset were Structural, and 65% were Content-Based.
Structural deltas indicate a minor restructuring of the prompt, with-
out changing any criteria of a good response (e.g., adding a newline
for readability), or specification of the intended output (e.g., JSON or
Markdown). Plausible assertion criteria based on structural deltas
would check if the LLM output adheres to the user-specified struc-
ture. On the other hand, content-based deltas indicate a change in
the meaning or definition of the task. Content-based deltas include
descriptions of the workflow steps that the LLM should perform
(e.g., “first, do X, then, come up with Y”), instructions of specific
phrases to include or exclude in responses, or qualitative indicators
of good responses (e.g., “maintain a professional tone”). The Data
Integration subcategory (under Content-Based deltas) concerns
adding new sources of context to the prompt—for example, adding
a new variable like “{movie_info}” to the prompt, indicating a new
type of information to be analyzed along with other content in
the prompt. For some illustrative examples of prompt deltas for
each category, we categorize the prompt deltas in Table 1, and in
Table 2, we show sample prompt deltas for each category in our
taxonomy. This taxonomy may be of independent interest to re-
searchers studying the process of prompt engineering, as well as
practitioners seeking to identify ways to improve their prompts for
production LLM pipelines.
Overall, our exercise in building this taxonomy reveals two key
findings. First, developers across diverse LLM pipelines iterate on
prompts in similar ways as encoded as nodes in the taxonomy,
many of which correspond to aspects that can be explicitly checked
via assertions. Second, we find that an automated approach to
synthesize data quality assertions may be promising, since our
taxonomy reveals several such instances where the prompt delta
could directly correspond to an assertion that captures the same
requirement. For example, many deltas correspond to instructions
to include or exclude specific phrases, indicating that developers
may benefit from assertions that explicitly verify the inclusion or
exclusion of such phrases in LLM outputs.
2https://github.com/shreyashankar/spade-experiments/blob/main/taxonomy_labels.
csv
3

---

Version 𝑖
ΔP𝑖
ΔP𝑖Category
Possible New Assertion Criteria
1
+ Given the following information about the user, {per-
sonal_info}, and information about a movie, {movie_-
info}: write a personalized note for why the user should
watch this movie.
Inclusion
Response should be personalized and relevant to the
given user information
2
+ Include elements from the movie’s genre, cast, and
themes that align with the user’s interests.
Inclusion
Response includes specific references to the user’s in-
terests related to the movie’s genre, cast, and themes
3
+ Ensure the recommendation note is concise.
Qualitative Assessment
Response should be concise
4
- Ensure the recommendation note is concise. + Ensure
the recommendation note is concise, not exceeding 100
words.
Count
Response should be within the 100 word limit
5
- Include elements from the movie’s genre, cast, and
themes that align with the user’s interests. + Mention the
movie’s genre and any shared cast members between the
{movie_name} and other movies the user has watched.
Inclusion
Response should mention genre and verify cast members
are accurate
6
+ Mention any awards or critical acclaim received by
movie_name.
Inclusion
Response should include references to awards or critical
acclaim of the movie
7
+ Do not mention anything related to the user’s race,
ethnicity, or any other sensitive attributes.
Exclusion
Response should not include references to sensitive per-
sonal attributes
Table 1: Comparison of 7 prompt versions for an LLM pipeline to write personalized movie recommendations. In each ΔP𝑖, a
sentence starts with “+” if it is a newly added sentence; a sentence starts with “-” if it is removed from P𝑖−1. For each ΔP𝑖, we
list its category (using the taxonomy in Figure 2) and possible new assertion criteria.
However, if we are to use an LLM to automatically generate
assertion criteria based on our taxonomy of deltas, we also need
to test whether LLMs can accurately identify the categories cor-
responding to a delta. Therefore, we confirmed GPT-4’s correct
categorization of prompt deltas (as of October 2023): we assigned
ground truth categories to all prompt deltas from the 19 pipelines,
and GPT-4 achieved an F1 score of 0.8135. The prompt used for
category extraction from prompt deltas is detailed in Appendix C.
Category
Explanation
Example Prompt Delta
Response Format In-
struction
Structure guidelines.
“+ Start response with ‘You
might like...’.”
Example Demonstra-
tion
Illustrative example.
“+ For example, here is a re-
sponse for sci-fi fans...”
Prompt Clarification
Refines
prompt/re-
moves ambiguity.
“- Discuss/+ Explain movie
fit...”
Workflow Description
Describe
“thinking”
process.
“+ First, analyze viewing his-
tory...”
Data Integration
Adds placeholders.
“+ Include user’s {genre} re-
views.”
Quantity Instruction
Adds numerical con-
tent.
“+ Keep note under 100 words.”
Inclusion Instruction
Directs specific con-
tent.
“+ Mention movie awards/ac-
claim.”
Exclusion Instruction
Advises on omissions.
“+ Avoid movie plot spoilers.”
Qualitative Criteria
Sets
stylistic
at-
tributes.
“+ Maintain friendly, positive
tone.”
Table 2: Categories of prompt deltas.
2.3
From Taxonomy to Assertions
As we saw previously, prompt delta as categorized into nodes in
our taxonomy often correspond to meaningful assertion criteria.
Next, we need a method to automatically synthesize the data quality
assertions from the prompt deltas. A natural idea is to prompt an
LLM to generate assertion functions corresponding to relevant
categories in our taxonomy given the prompt deltas. We tried this
approach with GPT-4 in January 2024 and observed several omitted
assertions that clearly corresponded to categories in our taxonomy.
Therefore, we adopt a two-step prompting process in our approach,
as it has been demonstrated that breaking tasks into steps can
enhance LLM accuracy [22, 60, 62]. In the first step, we prompt
GPT-4 for natural language descriptions of assertion criteria, and in
the second step, we prompt GPT-4 to generate Python functions that
implement such criteria. However, it’s worth noting that with daily
advancements in LLMs, a one-step process might already be feasible.
Additionally, while our taxonomy guides LLM-generated assertions
now, future LLMs may implicitly learn these categories through
reinforcement learning from human feedback [13]. Nevertheless,
knowing the taxonomy-based categories associated with candidate
assertions may help in filtering them.
More specifically, for each prompt delta ΔP𝑖, we first prompt an
LLM to suggest as many criteria as possible for assertions—each
aligning with a taxonomy category from Figure 3. A criterion is
loosely defined as some natural language expression that operates
on a given output or example and evaluates to True or False (e.g.,
“check for conciseness”). Our method analyzes every ΔP𝑖instead
of just the last prompt version for several reasons: developers often
remove instructions from prompts to reduce costs while expect-
ing the same behavior [40], prompts contain inherent ambiguities
and imply multiple ways of evaluating some criteria, and complex
prompts may lead to missed assertions if only one version is ana-
lyzed. Consequently, analyzing each ΔP𝑖increases the likelihood
of generating relevant assertions.
For each delta, our method collects the criteria identified and
prompts an LLM again to create Python assertion functions. The
synthesized functions can use external Python libraries or pose
binary queries to an LLM for complex criteria. For function synthe-
sis, the LLM is instructed that if the criterion is vaguely specified
4

---

Construct ΔP5
“- Include elements from the movie’s genre, cast, and
themes that align with the user’s interests. + Men-
tion the movie’s genre and any shared cast members...”
Prompt LLM with ΔP5 to identify the delta type(s)
and assertion criteria based on our taxonomy
{"criterion": "The response should mention the movie 's
↩→
genre.", "category": "Inclusion", "source": "
↩→Mention the movie 's genre"},
{"concept": "The response should include shared cast
↩→members between the specified movie and other
↩→movies the user has watched.", "category": "
↩→Inclusion", "source": "any shared cast members
↩→between the {movie_name} and other movies the user
↩→has watched"}
Synthesize Function(s)
def assert_mention_of_movie_genre(ex: dict , prompt:
↩→str , response: str):
expected_genre = ex.get('movie_genre ', '').lower ()
return expected_genre in response.lower()
def assert_accurate_inclusion_of_shared_cast_members(
↩→prompt: str , response: str):
# Formulate questions for the 'ask_llm ' function
↩→to check for presence and accuracy
presence_question = "Does the response include
↩→shared cast members between the specified movie
↩→
and other movies?"
accuracy_question = "Are the shared cast members
↩→mentioned in the response accurate and
↩→correctly representing those shared between the
↩→
specified movie and other movies?"
return ask_llm(prompt , response , presence_question
↩→) and ask_llm(prompt , response ,
↩→accuracy_question)
Figure 3: Generating candidate assertions from a ΔP.
or open to interpretation, such as “check for conciseness,” it can
generate multiple functions that each evaluate the criterion. In this
conciseness example, the LLM could return multiple functions—a
function that splits the response into sentences and ensures that
there are no more than, say, 3 sentences, a function that splits the
response into words and ensures that there are no more than, say,
25 words, or a function that sends the response to an LLM and asks
whether the response is concise. The overall outcome of this is a
multiset of candidate functions 𝐹= {𝑓1, . . . , 𝑓𝑚}. The two prompts
for generating assertion criteria and functions can be found in
Appendix C.
2.4
Initial Deployment
To assess the potential of our auto-generated assertions, in No-
vember 2023, we released an early prototype of spade’s candidate
assertion generation framework via a Streamlit application3. At the
time of public release, the Streamlit application had a different set of
3https://spade-beta.streamlit.app/
prompts to generate assertions; these prompts generated relatively
few assertions compared to the number of assertions generated in
this paper’s version of spade. However, the taxonomy has remained
the same. In the Streamlit app, a developer can either paste their
prompt template that they want to generate assertions for, or they
can point to their LangChain Hub prompt template (which contains
prompt version histories via commits). The app then visualizes the
identified taxonomy categories in the user’s prompt and displays
the candidate assertions, as shown in the screenshot in Figure 4.
Tool Usage Insights and Feedback. From the reception to our
Streamlit application, we found significant interest in auto-generated
data quality assertions for LLM pipelines: there have been over 2000
runs of the app for custom prompt templates (i.e., not the sample de-
fault prompt template in app). These runs span many fields, includ-
ing medicine, education, cooking, and finance—providing insights
from a diversity of use cases for LLM pipelines. Figure 5 shows
a rough breakdown of the use cases people wanted to generate
assertions for; however, it’s important to note that some runs may
not cleanly fit into a single category (e.g., a chatbot for telehealth-
related questions for a medical provider could be in “customer
support” and “health”). Interestingly, 8% of tasks related to con-
versational assistants, and we observed instances of at least four
different companies generating assertions for their chatbots, given
that the company name was in the prompt. Users for 48 of these
runs clicked the “download assertions” button, which downloads
the candidate assertions as a Python file. We note that users can also
directly copy the assertions code displayed, instead of downloading
the assertions as a Python file, and we did not measure the copy
events. No users clicked the “thumbs down” button—which is not to
say that the generated assertions were perfect. In fact, anecdotally,
we have seen the candidate assertion quality improve over the last
several months as GPT-4 continually improves. On average, 3.3
assertions were generated per run, with minimum 1 and maximum
10 assertions generated for a run. Most of the runs corresponded to
a single prompt version. After our Streamlit app was released, we
found an unprompted review of spade-generated assertions from
a LangChain user who built a “chat-with-your-pdf” tool4: in their
words, “When I saw it I didnt beleive it could work that well, but it
really did and made the evaluation process fun and ez.”
Observations about Assertion Criteria. Across the 2000+ runs,
with regards to our taxonomy, assertion criteria were most com-
monly derived from inclusion and exclusion instructions. For ex-
ample, for a shopping assistant, where the objective was to find
the most relevant product related to a customer’s query, responses
were required to include “all the features [the customer] asked
for.” In another customer support agent example, responses were
required to include “exact quotes in the [context] relevant to the
[customer’s] question...word for word.” One common exclusion
instruction across chat-related tasks was to avoid any discussion
unrelated to the end-user’s question; however, we noticed that GPT-
4 struggled to generate assertion criteria around such a generic
exclusion instruction. We found Python functions generated to
implement criteria such as “avoid unrelated ideas”, did not use an
LLM to check the criteria. Instead, they checked for the presence of
4https://twitter.com/th_calafatidis/status/1728144652119769394
5

---

specific phrases like “unrelated” and “I’m sorry, I did not find any-
thing related” in the response. Such errors indicate the limitations
of current state-of-the-art LLMs and may suggest the need for spe-
cialized, fine-tuned LLMs for generating assertions in future work;
here, we work with the limitations of present-day state-of-the-art
LLMs. We discuss this further in Section 4.4.
A new pattern we noticed after deployment, which wasn’t seen
in our initial analysis, is that developers often wish to hide certain
parts of the LLM workflow in the outputs. This could be viewed
as a special instance of the exclusion category in our taxonomy.
For instance, in a prompt related to enterprise automation, the
first instruction was to write a query targeting a specific database
(e.g., “Write a SQL query to fetch the most relevant table from the
MySQL database”). However, another instruction in the prompt
specified that the name of the database should not appear in the
final summary returned to the end-user (e.g., “Do not mention that
you queried the MySQL table X”). We were pleasantly surprised to
find that our process for generating criteria successfully identified
and implemented such exclusion instructions accurately.
Observations about Assertions. In LLM pipelines with numerous
prompt versions, we observed two main patterns. First, prompt
engineering often leads to many similar assertions, and redundancy
can be a headache at deployment when a developer has to keep track
of so many assertions. For instance, a pipeline to summarize lecture
transcripts5 had 14 prompt versions, with many edits localized to
the paragraph providing instructions on titles, speakers, and dates,
creating multiple overlapping assertions. 10 assertions assessed the
lecture’s central thesis; two are as follows:
async def assert_response_articulates_central_thesis(
example: dict , prompt: str , response: str
):
return "Central Thesis:" in response
async def assert_response_completeness(example: dict ,
↩→prompt: str , response: str):
required_elements = [
"Context:",
"Central Thesis:",
"Key Points:",
"Conclusions and Takeaways:",
"Glossary of Important Terms:",
]
return all(element in response for element in
↩→required_elements)
Second, many assertions may be incorrect, causing runtime er-
rors or false failures. Assessing the accuracy of these assertions
is challenging, particularly for those that are complex or invoke
LLMs themselves, where even experienced developers might not
be able to gauge their effectiveness without viewing the results
of the functions on many examples. Even if the assertions are not
incorrect, they still may have undesirable failure rates or coverage,
which is often hard for a developer to reason about in conjunction
with other assertions. Since there can be 50+ assertions generated
for just a handful of prompt versions (as demonstrated in Section 4),
manually filtering them by eyeballing failure rates for each sub-
set of assertions is impractical. Therefore, we adopt an automated
approach for filtering, as discussed in the following section.
5https://smith.langchain.com/hub/kirby/simple-lecture-summary
Figure 4: Screenshot of an early version of the spade Stream-
lit application.
3
FILTERING CANDIDATE ASSERTIONS
As we saw in the previous section, we often have redundant and in-
correct assertions, particularly in pipelines with numerous prompt
versions. Here, we focus on filtering this candidate set to a smaller
number, which not only improves efficiency and reduces cost when
deploying the assertions to run in production, but it also reduces
cognitive overhead for the developer.
3.1
Definitions
Consider 𝑒𝑖as an example end-to-end execution (i.e., run) of an LLM
pipeline on some input. For the purposes of this section, we assume
the prompt template P is fixed to be the final prompt version that
the developer eventually decided on. We denote 𝑦𝑖∈{0, 1} to
6

---

0
5
10
15
20
Health
IT and Programming
Project Management
Customer Support
Education
Sports and En-
tertainment
Cooking
Finance
Marketing
Others
20.8
16.7
12.5
12.5
8.3
8.3
8.3
4.2
4.2
4.2
Percentage
Figure 5: Prompts submitted to the spade Streamlit applica-
tion span a variety of fields.
represent whether the developer considers 𝑒𝑖to be a success (1) or
failure (0).
Let 𝐸be the set of all such example runs (this set is not pro-
vided upfront, as we will deal with shortly). We define an asser-
tion function 𝑓: 𝐸→{0, 1}, where 1 indicates that the exam-
ple was processed successfully by the LLM and 0 otherwise. Let
𝐹′ = {𝑓1, 𝑓2, . . . , 𝑓𝑘} be a set of𝑘data quality assertions. An example
𝑒𝑖is deemed successful by 𝐹′ if and only if it satisfies all assertions
in 𝐹′. Specifically:
ˆ𝑦𝑖=
(
1 if 𝑓(𝑒𝑖) = 1
∀𝑓∈𝐹′,
// Deemed successful by all of 𝐹′
0 otherwise.
// Deemed a failure by ≥1 of 𝐹′
Given all 𝑚candidate assertions 𝐹= {𝑓1, 𝑓2, . . . , 𝑓𝑚}, the objective
is to select 𝐹′ ⊆𝐹such that ˆ𝑦𝑖= 𝑦𝑖for most examples in 𝐸, with
𝐹′ being as small as possible. This goal involves maximizing failure
coverage and minimizing the false failure rate and selected function
count, expressed as follows:
Definition 3.1. Coverage for a set 𝐹′ is the proportion of actual
failures that are correctly identified by 𝐹′, defined as:
Coverage  𝐹′ =
Í
𝑖I [ ˆ𝑦𝑖= 0 ∧𝑦𝑖= 0]
Í
𝑖I [𝑦𝑖= 0]
// Failures caught by 𝐹′
Definition 3.2. False Failure Rate (FFR) for a set 𝐹′ is the fraction
of examples that 𝐹′ incorrectly evaluates as failures (ˆ𝑦𝑖= 0) when
they are actually successful (𝑦𝑖= 1), defined as:
FFR  𝐹′ =
Í
𝑖I [ ˆ𝑦𝑖= 0 ∧𝑦𝑖= 1]
Í
𝑖I [𝑦𝑖= 1]
// Non-failures flagged by 𝐹′
In both definitions above, ˆ𝑦𝑖represents set 𝐹′’s prediction for
the 𝑖-th example, 𝑦𝑖is the actual outcome, while I is the indicator
function. In practice, coverage and FFR are impossible to compute
since the universe of examples 𝐸is unknown. So, for now, we
assume access to a subset 𝐸′ ⊂𝐸of labeled LLM responses, where
𝐸′ is a manually provided set of example runs and may not contain
all the types of failures the LLM pipeline could observe—an issue
we will deal with in Section 3.3. Thus, we replace Definition 3.1
and Definition 3.2 with Coverage𝐸′
 𝐹′ and FFR𝐸′  𝐹′, omitting
the subscript 𝐸′ for brevity. Table 8 in Appendix A summarizes the
notation used throughout this section.
3.2
Coverage Problem Formulation
Our goal is therefore to select a minimal set of assertions 𝐹′ ⊆𝐹
based on a sample 𝐸′ = {𝑒1, . . . ,𝑒𝑛} ⊂𝐸. Formally:
minimize
|𝐹′|
subject to:
Coverage(𝐹′) ≥𝛼,
FFR(𝐹′) ≤𝜏
The above problem may be infeasible with certain values of 𝛼, for
multiple reasons. To see this, consider the case where no assertion
catches a specific failure, while 𝛼is set to 1. We ignore this (and
similar cases) for now and defer their discussion to Section 4. To
expand out the above, we introduce a matrix 𝑀(size 𝑛× 𝑚) to
track each assertion’s result on each example 𝑒𝑖, where 𝑀𝑖𝑗= 1
if 𝑓𝑗(𝑒𝑖) = 1 (i.e., 𝐹𝑗deems 𝑒𝑖a success) and 𝑀𝑖𝑗= 0 otherwise.
We also define binary variables 𝑥𝑗and 𝑤𝑖𝑗to represent whether
an assertion is chosen and if it marks an example as a failure:
𝑤𝑖𝑗=  1 −𝑀𝑖𝑗
 · 𝑥𝑗, which is based on whether 𝑓𝑗denotes 𝑒𝑖as
a failure and 𝑓𝑗is included in 𝐹′. We additionally introduce the
binary variable 𝑢𝑖to represent whether a failed example is covered
by any selected assertion:
𝑢𝑖≤
𝑚
∑︁
𝑗=1
𝑤𝑖𝑗,
∀𝑖∈[1,𝑛] : 𝑦𝑖= 0. // Coverage of failure 𝑒𝑖
Then, the coverage constraint can be written as:
Í
𝑖:𝑦𝑖=0 𝑢𝑖
Í
𝑖I [𝑦𝑖= 0] ≥𝛼.
Now, we formulate the FFR constraint. Observe that FFR can be
decomposed into the following:
Í𝑛
𝑖=1 𝑦𝑖· max𝑗
 𝑤𝑖𝑗

Í𝑛
𝑖=1 [𝑦𝑖= 1]
≤𝜏.
(1)
The product 𝑤𝑖𝑗=  1 −𝑀𝑖𝑗
 · 𝑥𝑗in the numerator is 1 if 𝑓𝑗is
included in 𝐹′ and incorrectly marks a good example as a failure.
The max function ensures that as long as there is some selected
function 𝑓𝑗that marks 𝑒𝑖as a failure, the product is 1. Multiplying
𝑦𝑖by the max result ensures that the numerator is incremented only
when 𝑦𝑖= 1, or when the example 𝑒𝑖is actually not a failure. This
numerator is thus equivalent to the numerator in Definition 3.2,
i.e., 𝑦𝑖= 1 ∧ˆ𝑦𝑖= 0. The entire fraction is less than the threshold
𝜏, which represents the maximum allowed false failure rate across
the examples. To formulate FFR according to (1), we introduce a
new binary variable 𝑧𝑖, which defines whether 𝐹′ denotes 𝑒𝑖as a
failure while 𝑒𝑖is actually a successful example (i.e., false failure):
𝑧𝑖≥𝑦𝑖· 𝑤𝑖𝑗,
∀𝑖∈[1,𝑛] ; ∀𝑗∈[1,𝑚] . // 𝑒𝑖is a false failure
Then, the FFR constraint is:
Í𝑛
𝑖=1 𝑧𝑖
Í𝑛
𝑖=1 I [𝑦𝑖= 1] ≤𝜏.
We can then state the problem of minimizing the number of
assertions while meeting 𝐸′ coverage and FFR constraints as an
7

---

Integer Linear Program (ILP):
minimize
𝑚
∑︁
𝑗=1
𝑥𝑗
subject to:
𝑤𝑖𝑗= (1 −𝑀𝑖𝑗) · 𝑥𝑗,
∀𝑖∈[1,𝑛] , ∀𝑗∈[1,𝑚] ;
𝑢𝑖≤
𝑚
∑︁
𝑗=1
𝑤𝑖𝑗,
∀𝑖∈[1,𝑛] where 𝑦𝑖= 0;
Í
𝑖:𝑦𝑖=0 𝑢𝑖
Í
𝑖I [𝑦𝑖= 0] ≥𝛼;
𝑧𝑖≥𝑦𝑖· 𝑤𝑖𝑗,
∀𝑖∈[1,𝑛] , ∀𝑗∈[1,𝑚] ;
Í𝑛
𝑖=1 𝑧𝑖
Í𝑛
𝑖=1 I [𝑦𝑖= 1] ≤𝜏;
𝑥𝑗,𝑢𝑖,𝑧𝑖,𝑤𝑖𝑗∈{0, 1},
∀𝑖∈[1,𝑛] , ∀𝑗∈[1,𝑚] .
We refer to a solution for this ILP as spadecov. Trivially, the problem
is NP-hard for 𝜏= 0 and 𝛼= 1, via a simple reduction from set
cover, and is in NP, since it can be stated in ILP form. In our case,
given tens of candidate assertions and fewer than 100 examples 𝑒𝑖,
the ILPs tend to be of reasonable size (i.e., thousands of variables).
Most ILP solvers can efficiently and quickly such programs.
3.3
Subsumption Problem Formulation
So far, we’ve assumed that the developer is willing to provide a
comprehensive set of labeled example runs 𝐸′. In settings where
the developer is unwilling to do so, and where 𝐸′ does not include
all failure types in 𝐸, spadecov may overlook useful assertions in 𝐹
that only catch failures in 𝐸\ 𝐸′—as shown empirically in Section 4.
We initially considered using active learning [7] to sample more
LLM responses for each assertion and weak supervision to label
the responses [42]. However, this approach can be costly with
state-of-the-art LLMs, and it demands significant manual effort to
balance failing and successful examples for each assertion, ensuring
meaningful FFRs, and avoiding the exclusion of assertions due to
underrepresented failure types. For this setting, we additionally
introduce the notion of subsumption. Assuming that all candidate
assertion functions cover as many failure modes as possible, our
goal is to pick 𝐹′ ⊆𝐹such that assertions in 𝐹\ 𝐹′ are subsumed
by 𝐹′. Formally, a set of functions 𝑆subsumes some function 𝑓if
the conjunction of functions in 𝑆logically implies the conjunction
of functions in 𝑆and 𝑓. That is,
Definition 3.3. A set of functions 𝑆=⇒𝑓if and only if ∀𝑒∈
𝐸, ∃𝑠∈𝑆such that 𝑠(𝑒)
=⇒
𝑓(𝑒). In other words, if 𝑆
=⇒
𝑓,
then 𝑓catches no new failures that 𝑆does not already catch.
A simple example of subsumption is as follows: suppose our set
of functions 𝑆contains only one function 𝑓, which parses an LLM
output into a JSON list to check that the list has at least 2 elements.
𝑓may be generated as a result of a count-related instruction from
our taxonomy of prompt deltas. Now, let 𝑔be some other function
that only checks if the output can be turned into a JSON list.𝑔might
have been generated due to a “Response Format Instruction”-type
delta. If 𝑔fails for some LLM output, 𝑓—and therefore 𝑆—must also
fail that output; thus 𝑆=⇒𝑔.
3.3.1
ILP with Subsumption Constraints. We reformulate the prob-
lem with subsumption constraints. Let 𝐺be the set of functions in
𝐹\ 𝐹′ not subsumed by 𝐹′:
minimize
|𝐹′| + |𝐺|
subject to:
Coverage(𝐹′) ≥𝛼,
FFR(𝐹′) ≤𝜏
To represent 𝐺, we introduce binary variables and a matrix 𝐾to
denote subsumption relationships. 𝐾𝑖𝑗= 1 if and only if 𝑓𝑖=⇒𝑓𝑗.
We discuss how we construct 𝐾in more detail in Section 3.3.2.
Recall that 𝑥𝑗represents whether 𝑓𝑗is selected in 𝐹′. For each
function 𝑓𝑗, a binary variable 𝑟𝑗indicates if it is subsumed by 𝐹′.
𝑥𝑖· 𝐾𝑖𝑗≤𝑟𝑗≤
𝑚
∑︁
𝑖=1
𝑖≠𝑗
 𝑥𝑖· 𝐾𝑖𝑗
 ,
∀𝑗∈[1,𝑚] ,𝑖≠𝑗.
Now, 𝑠𝑗will denote if 𝑓𝑗is neither in 𝐹′ nor subsumed by 𝐹′. We
break this into three parts. First,
𝑠𝑗≤1 −𝑥𝑗,
∀𝑗∈[1,𝑚] ,
indicates that 𝑓𝑗∉𝐹′ if 𝑠𝑗is allowed to be 1 (i.e., 𝑓𝑗∉𝐹′ when
𝑥𝑗= 0). The second constraint,
𝑠𝑗≤1 −𝑟𝑗,
∀𝑗∈[1,𝑚] ,
captures the condition where 𝑓𝑗is not subsumed by 𝐹′. Here, if
𝑟𝑗= 0, suggesting no subsumption, then 𝑠𝑗may be 1. Lastly, to
combine these conditions, we employ the constraint,
𝑠𝑗≥1 −𝑥𝑗−𝑟𝑗,
∀𝑗∈[1,𝑚] ,
which ensures that 𝑠𝑗can only be 1 if both prior conditions are
satisfied: 𝑓𝑗is neither in 𝐹′ nor subsumed by 𝐹′.
Finally, our objective is to minimize the sum of the number of
functions in 𝐹′ and non-subsumed functions𝐺. The ILP formulation
then becomes (with changes highlighted in blue):
minimize
𝑚
∑︁
𝑗=1
𝑥𝑗+
𝑚
∑︁
𝑗=1
𝑠𝑗
subject to:
𝑤𝑖𝑗=  1 −𝑀𝑖𝑗
 · 𝑥𝑗, ∀𝑖∈[1,𝑛] , ∀𝑗∈[1,𝑚] ;
𝑢𝑖≤
𝑚
∑︁
𝑗=1
𝑤𝑖𝑗,
∀𝑖∈[1,𝑛] where 𝑦𝑖= 0;
Í
𝑖:𝑦𝑖=0 𝑢𝑖
Í
𝑖I [𝑦𝑖= 0] ≥𝛼;
𝑧𝑖≥𝑦𝑖· 𝑤𝑖𝑗,
∀𝑖∈[1,𝑛] , ∀𝑗∈[1,𝑚] ;
Í𝑛
𝑖=1 𝑧𝑖
Í𝑛
𝑖=1 I [𝑦𝑖= 1] ≤𝜏;
𝑥𝑖· 𝐾𝑖𝑗≤𝑟𝑗≤
𝑚
∑︁
𝑖=1
𝑖≠𝑗
 𝑥𝑖· 𝐾𝑖𝑗
 ,
∀𝑗∈[1,𝑚] ,𝑖≠𝑗;
𝑠𝑗≤1 −𝑥𝑗,
𝑠𝑗≤1 −𝑟𝑗,
∀𝑗∈[1,𝑚] ;
𝑠𝑗≥1 −𝑥𝑗−𝑟𝑗,
∀𝑗∈[1,𝑚] ;
𝑥𝑗,𝑢𝑖,𝑧𝑖,𝑤𝑖𝑗,𝑟𝑗,𝑠𝑗∈{0, 1},
∀𝑖∈[1,𝑛] , ∀𝑗∈[1,𝑚] .
We call a solution to this ILP spadesub. We maintain the coverage
constraint because the subsumption approach alone does not in-
herently account for the distribution or the significance of different
types of failures. For instance, if a particular type of failure makes
up a critical portion of 𝐸′, a subsumption-based approach might
overlook it. To see this in the simplest case, consider 𝛼= 1: simply
optimizing for the sum |𝐹′| + |𝐺| does not guarantee all failures
in 𝐸′ are covered. In practice, spadesub is less sensitive to 𝛼than
spadecov, as we will discuss further in Section 4.
8

---

3.3.2
Assessing Subsumption. Here, we detail how to construct
𝐾, our matrix representing subsumption relationships between
pairs of functions 𝑓𝑖, 𝑓𝑗. For pure Python functions, one could use
static analysis to determine subsumption. However, it becomes
complex when dealing with assertions that include LLM calls or a
mix of pure Python and LLM-invoking assertions. For these, spade
employs GPT-4 to identify potential subsumptions {𝑎}
=⇒
𝑏
for pairs of functions 𝑎,𝑏. For any pipeline, there are only two
calls to the LLM to determine all subsumptions: first, all assertion
functions are combined into a single prompt for GPT-4, instructing
it to list as many subsumption relationships as it can identify, then
prompting it again to transform its response into a parse-able list
of pairs 𝑎=⇒𝑏. Details of this LLM subsumption prompt are in
Appendix C.
To maximize precision of
=⇒
relationships identified, we
employ some heuristics. First, 𝐸′ can filter subsumptions: for 𝑓𝑖and
𝑓𝑗, observe that:
∃𝑒𝑖∈𝐸′ : (𝑓𝑖(𝑒𝑖) = 1) ∧ 𝑓𝑗(𝑒𝑖) = 0 ⇒ {. . . , 𝑓𝑖, . . .}̸ =⇒𝑓𝑗
 .
In other words, any set containing 𝑓𝑖definitely does not subsume
𝑓𝑗if 𝑓𝑗flags a failure that {𝑓𝑖} does not. Next, we use the FFR
threshold to skip evaluating subsumption. Observe that, for any set
of assertions 𝑆and 𝑓∉𝑆,
max (FFR (𝑆) , FFR ({𝑓})) ≤FFR (𝑆∪{𝑓}) ,
FFR (𝑆∪{𝑓}) ≤FFR (𝑆) + FFR ({𝑓}) .
(2)
As such, we need not evaluate {𝑓𝑖} =⇒𝑓𝑗if either FFR ({𝑓𝑖}) ≥𝜏
or FFR  {𝑓𝑗} ≥𝜏. Lastly, we use transitivity of implication to
further prune checks: if 𝑥=⇒𝑦and 𝑦=⇒𝑧, then 𝑥=⇒𝑧is
also true.
3.3.3
Subsumption without Examples. For completeness, we also
consider the case where we have no developer-provided examples
𝐸′. In this case, we are only reliant on our subsumption relationships
to pick our set 𝐹′. Our problem can then be restated as follows:
minimize
𝑚
∑︁
𝑗=1
𝑥𝑗+
𝑚
∑︁
𝑗=1
𝑠𝑗
subject to:
𝑥𝑖· 𝐾𝑖𝑗≤𝑟𝑗≤
𝑚
∑︁
𝑖=1
𝑖≠𝑗
(𝑥𝑖· 𝐾𝑖𝑗),
∀𝑗∈[1,𝑚] ;
𝑠𝑗≤1 −𝑥𝑗,
𝑠𝑗≤1 −𝑟𝑗,
∀𝑗∈[1,𝑚] ;
𝑠𝑗≥1 −𝑥𝑗−𝑟𝑗,
∀𝑗∈[1,𝑚] ;
𝑥𝑗,𝑟𝑗,𝑠𝑗∈{0, 1},
∀𝑗∈[1,𝑚] .
However, it turns out this problem is no longer NP-Hard. Consider
the example in Figure 6, where an edge indicates subsumption. For
example 𝑎→𝑏means that 𝑏catches a subset of the failures of
𝑎, and is therefore subsumed by 𝑎. Here, if we were to minimize
Σ𝑗(𝑥𝑗+𝑠𝑗), we would simply pick 𝑎and 𝑒to be part of 𝐹′, since the
rest of the functions would be subsumed (therefore their 𝑠𝑗= 0—
recall that 𝑠𝑗= 1 for assertions that are neither subsumed nor
selected), and our overall metric would evaluate to 2. One intuitive
way to view this problem is to start by keeping all of the nodes as
unselected, i.e., 𝑥𝑗= 0,𝑠𝑗= 1, and then by adding them one at a
time in a predefined order to 𝐹′, we set 𝑥𝑗= 1,𝑠𝑗= 0, and at the
a
b
d
c
e
f
Figure 6: Example depicting subsumption relationships.
same time, we also impact 𝑠𝑗(moving them from 1 to 0) for all other
functions that then become subsumed as a result.
More generally, subsumption relationships can be represented
in the form of a Directed Acyclic Graph (DAG), as in our example
above. (We omit the trivial case where two or more functions are
equivalent, that is the only case where there can be cycles; in all
other cases we have a DAG.) Within this DAG, we simply select
all nodes that have no incoming edges and add them to 𝐹′. We
can see that the rest of the nodes are subsumed, since they have at
least one incoming edge. We could certainly exclude a node that
doesn’t have any incoming edge from 𝐹′, but adding it to 𝐹′ does
not worsen the objective because there is no way that that node will
be subsumed by another. So, overall, we need to do a topological
sort of the subsumption graph and pick the nodes “at the top”. Thus,
the problem is in PTIME when there are no examples provided.
4
EVALUATION
We first discuss the LLM pipelines and datasets (i.e., 𝐸′); then, we
discuss methods and metrics and present our results. The experi-
ment code, datasets, and LLM responses are hosted on GitHub6.
4.1
Pipeline and Dataset Descriptions
We evaluated spade on nine LLM pipelines—eight from LangChain
Hub7, an open-source collection of LLM pipelines, and 1 propri-
etary pipeline. Each pipeline consists of a prompt template for the
LLM and collection of approximately 75 examples (i.e., inputs and
ouptuts in 𝐸′) with labels for whether the outputs were good or
bad. All nine pipelines come from LangChain users. Six pipelines
were used in developing our prompt delta taxonomy (Section 2.2),
each representing a different domain (e.g., programming, finance,
marketing). Two pipelines came from spade’s Streamlit deployment
(Section 2.4). We include one final proprietary pipeline (the fashion
pipeline) in our experiments because it had the largest number of
prompt template versions and spade’s assertions have already been
deployed in production for tens of thousands of daily runs.
Table 3 provides details on each LLM pipeline and correspond-
ing set of good and bad examples. For the fashion pipeline, good
and bad examples were provided by a developer at the correspond-
ing startup. While we used real user-provided prompt templates
and histories (between 3 and 16 prompt versions) for the other
8 pipelines, we constructed and annotated our own input-output
examples so we could release them publicly. For two pipelines,
we sourced examples from Kaggle. For the other six pipelines, we
synthetically generated the other datasets using Chat GPT Pro
(based on GPT-4) and manually reviewed them. For instance, for
6https://github.com/shreyashankar/spade-experiments
7https://smith.langchain.com/hub
9

---

Pipeline
# Good Ex. # Bad Ex. # Prompt Ver. Data Generation Task
Full Prompt Link
codereviews
60
16
8
Writing reviews of GitHub repo pull requests
homanp/github-code-reviews
emails
43
55
3
Creating SaaS user onboarding emails
gitmaxd/onboard-email
fashion
48
34
16
Suggesting outfit ideas for specific events
N/A
financea
48
52
5
Summarizing financial earnings call transcripts
casazza/map_template
lecturesummariesb
27
22
14
Summarizing lectures or talks, focusing on main points and
critical insights
kirby/simple-lecture-summary
negotiation
27
19
8
Writing tailored negotiation strategies based on provided
contracts and target prices
antoniogonc/strategy-report
sportroutine
19
31
3
Transforming workout video transcripts into structured ex-
ercise routines
aaalexlit/sport-routine-to-program
statsbot
39
31
3
Writing interactive discussions for any topic in statistics
anthonynolan/statistics-teacher
threads
50
56
4
Crafting concise, engaging Twitter threads for specific audi-
ences and topics
flflo/summarization
a https://www.kaggle.com/datasets/ashwinm500/earnings-call-transcripts
b https://www.kaggle.com/datasets/miguelcorraljr/ted-ultimate-dataset
Table 3: Description of data-generating LLM pipelines in our experiments. The fashion examples (and ground-truth indicators
of whether the example response is good or bad) are provided by a startup that uses LangChain. All other examples are
synthetically generated except examples for the finance and lecturesummaries pipelines, which are taken from Kaggle.
Pipeline
# CA
Method
FFR
Coverage
on 𝐸′
Frac Func.
Selected
Frac Excl.
Funcs. not
Subsumed
codereviews
44
baseline
0.117 ✓
1
✓
0.456 (20)
0 (0)
spadecov
0
✓
0.625 ✓
0.045 (2)
0.409 (18)
spadesub
0.117 ✓
0.875 ✓
0.341 (15)
0 (0)
emails
24
baseline
0
✓
1
✓
0.5 (12)
0 (0)
spadecov
0
✓
1
✓
0.0417 (1)
0.458 (11)
spadesub
0
✓
1
✓
0.458 (11)
0 (0)
fashion
106
baseline
0.878 ✗
0.971 ✓
0.632 (67)
0 (0)
spadecov
0.245 ✓
0.6 ✓
0.028 (3)
0.321 (34)
spadesub
0.224 ✓
0.62 ✓
0.377 (40)
0 (0)
finance
47
baseline
0.667 ✗
1
✓
0.787 (37)
0 (0)
spadecov
0.229 ✓
0.673 ✓
0.085 (4)
0.553 (26)
spadesub
0.208 ✓
0.981 ✓
0.553 (26)
0 (0)
lecturesum.
70
baseline
0.528 ✗
1
✓
0.457 (32)
0 (0)
spadecov
0.194 ✓
0.643 ✓
0.014 (1)
0.414 (29)
spadesub
0.194 ✓
1
✓
0.343 (24)
0 (0)
negotiation
50
baseline
0.444 ✗
1
✓
0.4 (20)
0 (0)
spadecov
0.222 ✓
0.632 ✓
0.04 (2)
0.32 (16)
spadesub
0.185 ✓
1
✓
0.34 (17)
0 (0)
sportroutine
26
baseline
0.211 ✓
1
✓
0.538 (14)
0 (0)
spadecov
0.211 ✓
0.774 ✓
0.077 (2)
0.462 (12)
spadesub
0
✓
0.871 ✓
0.308 (8)
0 (0)
statsbot
15
baseline
0
✓
1
✓
0.467 (7)
0 (0)
spadecov
0
✓
0.935 ✓
0.133 (2)
0.333 (5)
spadesub
0
✓
1
✓
0.467 (7)
0 (0)
threads
34
baseline
0
✓
1
✓
0.765 (26)
0 (0)
spadecov
0
✓
0.875 ✓
0.029 (1)
0.735 (25)
spadesub
0
✓
1
✓
0.589 (20)
0 (0)
Table 4: Results of different versions of spade with 𝛼= 0.6
and 𝜏= 0.25. “# CA” is short for the number of candidate
assertions. The ✓and ✗marks denote whether 𝛼and 𝜏con-
straints are met. Each entry is a fraction of the total number
of candidate assertions for that pipeline (with the absolute
number in parentheses). spadecov selects the fewest asser-
tions overall. spadesub selects the fewest assertions while
optimizing for subsumption.
the codereviews pipeline that uses an LLM to review pull requests,
we asked Chat GPT to generate example pull requests covering
a variety of programming languages, application types, and diff
sizes. On average, we collected 75 examples per pipeline. We then
executed the LLM pipelines on these inputs and manually labeled
the responses to assess whether they met the prompt instructions.
4.2
Method Comparison and Metrics
As before, let 𝐸′ be a dataset of example prompt-response pairs, as
well as the corresponding labels of whether the response was good
(i.e., 1) or bad (i.e., 0). Let 𝜏be the FFR threshold and 𝐹be the set of
candidate assertions produced by the first step of spade (Section 2).
If a candidate function 𝑓results in a runtime error for some example
𝑒, we denote 𝑓(𝑒) = 0 (i.e., failure). All of our code was written in
Python, using the PuLP Python package to find solutions for the
ILPs. We used the default PuLP configuration, which uses the CBC
solver [19].
The simplest baseline involves generating candidate assertions
and choosing all of them, but it proved ineffective, yielding 100%
coverage and 100% FFR due to at least one assertion failing all tests.
Failures were due to errors or overly specific conditions that, in
theory, could pass some outputs (for example, requiring a precise
phrase in a certain case) but, in reality, never matched any actual
LLM outputs. As such, we evaluated two versions of spade against
a baseline that simply filters candidate assertions that individually
exceed the FFR threshold:
• baseline selects all functions 𝑓in 𝐹where FFR ({𝑓}) ≤𝜏
• spadecov is a solution to the ILP defined in Section 3.2
• spadesub is a solution to the ILP defined in Section 3.3.1
Let 𝐹′ represent the set of selected assertions by any version of
spade. We measure four metrics:
(1) Fraction of Assertions Selected (i.e., |𝐹′|/|𝐹|)
(2) Fraction of Excluded Non-Subsumed Functions (i.e., |𝐺|/|𝐹|,
where 𝐺= {𝑔| 𝑔∈𝐹\ 𝐹′ and 𝐹′̸ =⇒𝑔})
(3) False Failure Rate (Definition 3.2)
(4) Coverage on 𝐸′ (Definition 3.1)
10

---

Additionally, an important aspect of spadesub’s success is the
effectiveness of subsumption assessment between all pairs of asser-
tions. Since we do not have ground truth for subsumption, we focus
on precision, calculated as the proportion of correctly identified
subsumed pairs out of all subsumed pairs identified by the LLM.
We do not assess recall—whether GPT-4 identified every possible
subsumption—due to the impracticality of labeling possibly tens
of thousands of assertion pairs per pipeline. Moreover, precision
is more critical than recall or accuracy, as identifying even some
subsumptions allows spadesub to achieve a solution with fewer
selected assertions than baseline.
4.3
Results and Discussion
Pipeline
Precision
codereviews
0.90
emails
0.79
fashion
0.74
finance
0.79
lecturesummaries
0.89
negotiation
0.68
sportroutine
0.89
statsbot
0.86
threads
0.80
Table 5: Precision of
assessing subsump-
tion with GPT-4 (ver-
ified by two authors).
Pipeline
spadecov
spadesub
codereviews
0.267
0.362
emails
0.196
0.225
fashion
0.628
1.197
finance
0.352
0.441
lecturesummaries
0.265
0.538
negotiation
0.220
0.332
sportroutine
0.120
0.158
statsbot
0.104
0.122
threads
0.272
0.332
Table 6: Average ILP runtimes (in sec-
onds) over 10 trials for spadecov and
spadesub. The baseline method
has no ILP component.
First, we briefly discuss whether individual components of spade
are practical (e.g., determining subsumption, solving the ILPs). Us-
ing GPT-4 to assess subsumption results in an average precision of
0.82 across all pipelines, as seen in Table 5, confirming its effective-
ness. The ILP runtimes in Table 6 are all under one second, except
for 1.197 seconds for spadesub for the fashion pipeline. This rela-
tively small runtime demonstrates the feasibility of our approach.
In the remainder of this section, we will focus on the assertions
chosen by different methods.
For simplicity, we set the coverage and FFR thresholds to be
the same across all pipelines (𝛼= 0.6, 𝜏= 0.25). We report re-
sults for the three methods in Table 4. Consider the codereviews
pipeline, for example, which uses an LLM to review a pull request for
any code repository. Here, baseline selects 20 assertions, spadecov
selects two assertions, and spadesub selects 15 assertions. By se-
lecting more functions, spadesub ensures that all non-subsumed
functions are included. All three approaches respect the 𝐸′ cover-
age constraint, but baseline violates the FFR constraint in 4 out
of 9 pipelines, while the spade approaches do not violate the FFR
constraint.
For our workloads, spadesub opts for approximately 14% fewer
assertions compared to baseline and shows a significantly lower
FFR, reducing it by about 21% relative to baseline. spadecov ex-
cludes, on average, about 44% of functions that are not subsumed
by 𝐹′. Choosing a spade implementation primarily depends on
how much labeled data is available. We subsequently discuss the
trade-offs between different spade implementations.
Subsumption vs. 𝐸′ Coverage. spadecov and spadesub are comple-
mentary, the former being more useful if 𝐸′ is more comprehensive.
For our datasets, 𝐸′ is not comprehensive: Table 4 reveals that, on
average, 44% of functions excluded by spadecov are not subsumed
by the selected functions, despite being accurate within the FFR
threshold. This is unsurprising given that each task has only 34
bad (i.e., failure) examples on average. While larger or more mature
organizations may have extensive datasets and could get a mean-
ingful result from spadecov, spadesub’s ability to select assertions
that cover unrepresented potential failures can be beneficial in data-
scarce settings. For example, here is a sample of 3 assertions for the
codereviews pipeline ignored by spadecov but included in spadesub
(with comments excluded for brevity):
async def assert_includes_code_improvement_v2(
example: dict , prompt: str , response: str
):
question = "Does the response include suggestions
↩→for code improvements?"
return await ask_llm(prompt , response , question)
async def assert_contains_brief_answers_v1(example:
↩→dict , prompt: str , response: str):
question = "Is the response brief and to the point
↩→
without unnecessary elaboration?"
return await ask_llm(prompt , response , question)
async def assert_responds_to_correct_pull_request(
example: dict , prompt: str , response: str
):
pr_title = example["title"]
question = (
f"Is the response a review focused on the Pull
↩→
Request titled '{pr_title}'?"
)
return await ask_llm(prompt , response , question)
Subsumption as a Means for Reducing Redundancy. Several
pipelines exhibit a large discrepancy between functions selected in
baseline and spadesub, which occurs when there are many redun-
dant candidates. For example, in the codereviews pipeline’s 8 prompt
versions, the developer iterated several times on the instruction
to give a clear and concise review, resulting in five assertions that
check the same thing (two of which are shown below):
async def assert_response_is_concise_v1(
example: dict , prompt: str , response: str
) -> bool:
question = "Is the LLM response concise and to the
↩→
point?"
return await ask_llm(prompt , response , question)
async def assert_response_is_concise_and_clear(
example: dict , prompt: str , response: str
):
question = "Is this pull request review response
↩→concise and clear?"
return await ask_llm(prompt , response , question)
async def assert_clear_professional_language_v1(
example: dict , prompt: str , response: str
):
question = "Is the response professional , clear ,
↩→and without unnecessary jargon or overly
↩→complex vocabulary?"
return await ask_llm(prompt , response , question)
Since all the five assertions meet the FFR constraint, individu-
ally, baseline would select them all, which is undesirable because
they all do the same thing, but spadesub would select the one most
11

---

compatible with the FFR constraint, as long as subsumption is as-
sessed correctly. On the flip side, while assessing subsumption,
the LLM may not recall all subsumptions, so spadesub may have
duplicate assertions. For example, the codereviews pipeline con-
tains assertions titled assert_includes_code_improvement_v1
and assert_includes_code_improvement_v2.
𝜶and 𝝉Threshold Sensitivity. The feasibility of solutions from
the ILP solver in spade is dependent on the chosen 𝛼and 𝜏thresh-
olds. If a feasible solution is not found, developers may need to
adjust these values in a binary search fashion. In our case, all 9 LLM
pipelines yielded feasible solutions with 𝛼= 0.6 and 𝜏= 0.25. How-
ever, the small size of 𝐸′ makes spadecov particularly sensitive to 𝛼.
In the pipelines, we observed that between one and five assertions
covered 60% of 𝐸′’s failures. For example, spadecov selected only
one assertion for the emails pipeline:
async def assert_encouragement_to_contact_company(
example: dict , prompt: str , response: str
) -> bool:
contact_phrases = [
"reach out",
"don't hesitate to contact",
"looking forward to hearing from you",
"if you have any questions",
"need help getting started",
]
return any(phrase in response for phrase in
↩→contact_phrases)
If 𝐸′ is exhaustive of failure modes and representative of the dis-
tribution of failures (e.g., for the emails pipeline, most failures are
actually due to the response lacking an encouragement to contact
the company), spadecov might be a satisfactory solution. How-
ever, our 𝐸′ datasets clearly were not exhaustive, considering that
spadesub always chose additional assertions. spadesub is less sensi-
tive to 𝛼, as it explicitly selects assertions based on their potential
to cover new failures (i.e., subsumption) without exceeding the FFR,
even if the constraint on coverage is no longer tight.
FFR Tradeoffs. Considering that the difference between the frac-
tion of functions selected for baseline and spadesub is less than
10% for three LLM pipelines, one may wonder if the complexity
of spadesub is worth it. spadesub is generally preferable because
baseline fails to consistently meet the FFR threshold 𝜏. We ob-
served that as prompt versions increase, so do the number of asser-
tions, impacting baseline adversely. The worst-case FFR of a set is
the sum of individual FFRs, as shown in Equation (2). Hence, with
a large number of independent assertions, the total FFR is likely
to surpass the threshold. This issue is evident in the fashion and
lecturesummaries pipelines, where despite each of the 67 and 32
assertions meeting FFR constraints individually, the total FFR for
baseline reaches 88% and 53%, respectively. In practice, if spade
were to be deployed in an interactive system, where spade could
observe each LLM call in real-time (e.g., as a wrapper around the
OpenAI API), the multitude of prompt versions further necessitates
filtering assertions based on overall FFR. This underscores the need
for the more complex spadecov or spadesub approaches.
4.4
Limitations and Future Work
Improving Quality of LLMs. While LLMs (both closed and open-
source) are improving rapidly, and we don’t explicitly study prompt
engineering strategies for spade, a complementary research idea is
to explore such strategies or fine-tune small open-source models to
generate assertions. Moreover, we proposed subsumption as a cover-
age proxy but didn’t explore prompt engineering or even non-LLM
strategies (e.g., assertion provenance) for assessing subsumption.
Despite LLM advancements, spade’s filtering stage remains crucial
for reducing redundancy and ensuring accuracy, especially since
assertions may involve LLMs.
Collecting Labeled Examples. Acquiring labeled data (𝐸′) is
hard. Most of our datasets had very few prompt versions (only the
ones committed to LangChain Hub), but in reality, developers may
iterate on their prompt tens or hundreds of times. Future work
could involve passive example collection via LLM API wrappers or
gathering developer feedback on assertions. Prioritizing different
types of assertions and formalizing these priorities within spade is
another area for exploration. Additionally, assessing the accuracy
of FFR estimates with limited 𝐸′ and exploring methods to enhance
FFR accuracy in the absence of large labeled datasets (e.g., via
prediction-powered inference [2]), presents an interesting area for
future work.
Supporting More Complex LLM Pipelines. Our study focuses
on single-prompt LLM pipelines, but more complex pipelines, such
as those involving multiple prompts, external resources, and human
interaction, present opportunities for auto-generating assertions for
each pipeline component. For instance, in retrieval-augmented gen-
eration pipelines[31], assertions could be applied to the retrieved
context before LLM responses are even generated.
5
RELATED WORK
We survey work from prompt engineering, evaluating ML and
LLMs, LLMs for software testing, and testing ML pipelines.
Prompt Engineering. For both nontechnical [64] and technical
users [39, 53], prompt engineering is hard for several reasons: small
changes in prompt phrasing [4, 32] or the order of instructions or
contexts [34] can significantly affect outputs. Moreover, as LLMs
change under the hood of the API (i.e., prompt drift), outputs can
change without developer awareness [10]. Tools and papers are
emerging to aid in prompt management and experimentation, and
are even using LLMs to write prompts [3, 12, 61, 62, 66]. Moreover,
deployed prompts introduce new challenges, like “balancing more
context with fewer tokens” and “wrangling prompt output” to meet
user-defined criteria [40]. Our work doesn’t focus explicitly on
helping developers create better prompts, but it could indirectly
support developers by helping identify mistakes.
ML and LLM Evaluation. Evaluating and monitoring deployed
ML models is known to be challenging [38, 51]. Evaluating LLMs
in a deployed setting is even more challenging because LLMs are
typically used for generative tasks, where the outputs are free-
form [14]. Some LLM pipeline types, like question-answering with
retrieval-augmented generation pipelines [31], can use standard-
ized, automated metrics [15, 45], but others face challenges due to
unknown metrics and lack of labeled datasets [9, 40, 63]. Typically,
organizations rely on human evaluators for LLM outputs [20, 40, 59],
12

---

but recent studies suggest LLMs can self-evaluate effectively with
detailed “scorecards” [8, 28, 65]. However, writing these scorecards
can be challenging [40], motivating auto-generated evaluators. Re-
cent work [28, 43, 55] and industry tools [23, 29, 33] proposes the
use of assertions to catch mistakes in LLM pipelines, while requiring
the user to select these assertions.
LLMs for Software Testing. LLMs are increasingly being used in
software testing, mainly for generating unit tests and test cases [30,
46, 54, 56, 57]. Research explores how LLMs’ prompting strategies,
hallucinations, and nondeterminism affect code or test accuracy [11,
16, 17, 37]. Our work is complementary and leverages LLMs to
generate code-based assertions for LLM pipelines.
Testing and Validation in ML Pipelines. ML pipelines are hard
to manage in production. Much of the literature on ML testing
is geared towards validating structured data, through analyzing
data quality [6, 24, 48, 49] or provenance [35, 47]. Platforms for ML
testing typically offer automated experiment tracking and preven-
tion against overfitting [1, 44], as well as tools for data distribution
debugging [21]. Model-specific assertions typically require human
specification [27], or at least large amounts of data to train learned
assertions [26]. LLM chains or pipelines are a new class of ML
pipelines, and LLMs themselves can generate assertions with lit-
tle data. A recent study highlights the difficulty of testing LLM
pipelines for “copilot”-like products: developers want to ensure
accuracy while avoiding excessive resource use, such as running
hundreds of assertions [40]—motivating assertion filtering.
6
CONCLUSION AND FUTURE WORK
We introduce a new problem of auto-generating assertions to catch
failures in LLM pipelines, as well as spade, our framework for doing
so. spade comprises two components: first, it synthesizes candidate
assertions, and then it filters them down into a more manageable
subset. To synthesize candidate assertions, we analyzed prompt ver-
sion histories and learned that prompt deltas are often a rich source
of requirements and therefore candidate assertions. We developed a
taxonomy of prompt deltas for assertion synthesis, demonstrating
its value via integration and deployment with LangChain, with
over 2000 runs across domains. For the latter problem of candidate
assertion filtering, we expressed the selection of an optimal set of
assertions, covering most failures while introducing as few false
failures as possible as an Integer Linear Program (ILP). We proposed
assertion subsumption to cover failures in data-scarce scenarios
and incorporated this into our ILP. We also studied the setting
where there are no examples and demonstrated that it reduces to a
topological sort on the subsumption graph. Our auto-generating
assertion system, spade, was evaluated on nine real-world data-
generating LLM pipelines. We have made our code and datasets
public for further research and analysis.
There are a number of open questions in our effort to make
production LLM pipelines more robust. For instance, while meeting
developer provided criteria (𝛼,𝜏) is helpful, sometimes developers
would like to examine the generated and selected assertions in a
way that helps them make the tradeoffs themselves, motivating a
human-in-the-loop interface to assist developers in defining data
quality for LLM pipelines. Such an interface could also be a vehicle
for getting developers to label examples on the fly. Determining
which labeled examples would help best select from the set of
assertions is an open question that is reminiscent of active learning.
Finally, we could also envision automatically updating assertion
sets in deployed pipelines, as new failure modes inevitably arise in
production.
REFERENCES
[1] Pulkit Agrawal, Rajat Arya, Aanchal Bindal, Sandeep Bhatia, Anupriya Gagneja,
Joseph Godlewski, Yucheng Low, Timothy Muss, Mudit Manu Paliwal, Sethu
Raman, Vishrut Shah, Bochao Shen, Laura Sugden, Kaiyu Zhao, and Ming-Chuan
Wu. 2019. Data Platform for Machine Learning. In Proceedings of the 2019 Inter-
national Conference on Management of Data (Amsterdam, Netherlands) (SIGMOD
’19). Association for Computing Machinery, New York, NY, USA, 1803–1816.
https://doi.org/10.1145/3299869.3314050
[2] Anastasios N Angelopoulos, Stephen Bates, Clara Fannjiang, Michael I Jor-
dan, and Tijana Zrnic. 2023. Prediction-powered inference. arXiv preprint
arXiv:2301.09633 (2023).
[3] Ian Arawjo, Chelse Swoopes, Priyan Vaithilingam, Martin Wattenberg, and Elena
Glassman. 2023. ChainForge: A Visual Toolkit for Prompt Engineering and LLM
Hypothesis Testing. arXiv preprint arXiv:2309.09128 (2023).
[4] Simran Arora, Avanika Narayan, Mayee F Chen, Laurel Orr, Neel Guha, Kush
Bhatia, Ines Chami, Frederic Sala, and Christopher Ré. 2022. Ask me anything: A
simple strategy for prompting language models. arXiv preprint arXiv:2210.02441
(2022).
[5] Eric Breck, Neoklis Polyzotis, Sudip Roy, Steven Whang, and Martin Zinkevich.
2019. Data Validation for Machine Learning.. In MLSys.
[6] Eric Breck, Marty Zinkevich, Neoklis Polyzotis, Steven Whang, and Sudip Roy.
2019. Data Validation for Machine Learning. In Proceedings of SysML. https:
//mlsys.org/Conferences/2019/doc/2019/167.pdf
[7] Rui Castro and Robert Nowak. 2008. Active learning and sampling. In Foundations
and Applications of Sensor Management. Springer, 177–200.
[8] Chi-Min Chan, Weize Chen, Yusheng Su, Jianxuan Yu, Wei Xue, Shanghang
Zhang, Jie Fu, and Zhiyuan Liu. 2023. Chateval: Towards better llm-based
evaluators through multi-agent debate. arXiv preprint arXiv:2308.07201 (2023).
[9] Yupeng Chang, Xu Wang, Jindong Wang, Yuan Wu, Kaijie Zhu, Hao Chen, Linyi
Yang, Xiaoyuan Yi, Cunxiang Wang, Yidong Wang, et al. 2023. A survey on
evaluation of large language models. arXiv preprint arXiv:2307.03109 (2023).
[10] Lingjiao Chen, Matei Zaharia, and James Zou. 2023. How is ChatGPT’s behavior
changing over time? arXiv preprint arXiv:2307.09009 (2023).
[11] Mark Chen, Jerry Tworek, Heewoo Jun, Qiming Yuan, Henrique Ponde
de Oliveira Pinto, Jared Kaplan, Harri Edwards, Yuri Burda, Nicholas Joseph,
Greg Brockman, et al. 2021. Evaluating large language models trained on code.
arXiv preprint arXiv:2107.03374 (2021).
[12] Yu Cheng, Jieshan Chen, Qing Huang, Zhenchang Xing, Xiwei Xu, and Qinghua
Lu. 2023. Prompt Sapper: A LLM-Empowered Production Tool for Building AI
Chains. arXiv preprint arXiv:2306.12028 (2023).
[13] Paul F Christiano, Jan Leike, Tom Brown, Miljan Martic, Shane Legg, and Dario
Amodei. 2017. Deep reinforcement learning from human preferences. Advances
in neural information processing systems 30 (2017).
[14] Yao Dou, Maxwell Forbes, Rik Koncel-Kedziorski, Noah A Smith, and Yejin
Choi. 2021. Is GPT-3 text indistinguishable from human text? SCARECROW: A
framework for scrutinizing machine text. arXiv preprint arXiv:2107.01294 (2021).
[15] Shahul Es, Jithin James, Luis Espinosa-Anke, and Steven Schockaert. 2023. RA-
GAS: Automated Evaluation of Retrieval Augmented Generation. arXiv preprint
arXiv:2309.15217 (2023).
[16] Angela Fan, Beliz Gokkaya, Mark Harman, Mitya Lyubarskiy, Shubho Sengupta,
Shin Yoo, and Jie M Zhang. 2023. Large language models for software engineering:
Survey and open problems. arXiv preprint arXiv:2310.03533 (2023).
[17] Robert Feldt, Sungmin Kang, Juyeon Yoon, and Shin Yoo. 2023. Towards Au-
tonomous Testing Agents via Conversational Large Language Models. arXiv
preprint arXiv:2306.05152 (2023).
[18] Raul Castro Fernandez, Aaron J. Elmore, Michael J. Franklin, Sanjay Krishnan, and
Chenhao Tan. 2023. How Large Language Models Will Disrupt Data Management.
Proc. VLDB Endow. 16, 11 (jul 2023), 3302–3309. https://doi.org/10.14778/3611479.
3611527
[19] John Forrest and Robin Lougee-Heimer. 2005. CBC user guide. In Emerging
theory, methods, and applications. INFORMS, 257–277.
[20] Sebastian Gehrmann, Elizabeth Clark, and Thibault Sellam. 2023. Repairing the
cracked foundation: A survey of obstacles in evaluation practices for generated
text. Journal of Artificial Intelligence Research 77 (2023), 103–166.
[21] Stefan Grafberger, Paul Groth, Julia Stoyanovich, and Sebastian Schelter. 2022.
Data distribution debugging in machine learning pipelines. The VLDB Journal
31, 5 (2022), 1103–1126.
[22] Madeleine Grunde-McLaughlin, Michelle S Lam, Ranjay Krishna, Daniel S Weld,
and Jeffrey Heer. 2023. Designing LLM Chains by Adapting Techniques from
13

---

Crowdsourcing Workflows. arXiv preprint arXiv:2312.11681 (2023).
[23] Guardrails 2023. Guardrails AI. https://github.com/guardrails-ai/guardrails.
[24] Nick Hynes, D. Sculley, and Michael Terry. 2017. The Data Linter: Lightweight
Automated Sanity Checking for ML Data Sets. http://learningsys.org/nips17/
assets/papers/paper_19.pdf
[25] Adam Tauman Kalai and Santosh S Vempala. 2023. Calibrated Language Models
Must Hallucinate. arXiv preprint arXiv:2311.14648 (2023).
[26] Daniel Kang, Nikos Arechiga, Sudeep Pillai, Peter D Bailis, and Matei Zaharia.
2022. Finding label and model errors in perception data with learned observation
assertions. In Proceedings of the 2022 International Conference on Management of
Data. 496–505.
[27] Daniel Kang, Deepti Raghavan, Peter Bailis, and Matei Zaharia. 2020. Model
assertions for monitoring and improving ML models. Proceedings of Machine
Learning and Systems 2 (2020), 481–496.
[28] Tae Soo Kim, Yoonjoo Lee, Jamin Shin, Young-Ho Kim, and Juho Kim. 2023.
EvalLM: Interactive Evaluation of Large Language Model Prompts on User-
Defined Criteria. arXiv preprint arXiv:2309.13633 (2023).
[29] Langchain 2023. Langchain AI. https://github.com/langchain-ai/langchain.
[30] Caroline Lemieux, Jeevana Priya Inala, Shuvendu K Lahiri, and Siddhartha Sen.
2023. CODAMOSA: Escaping coverage plateaus in test generation with pre-
trained large language models. In International conference on software engineering
(ICSE).
[31] Patrick Lewis, Ethan Perez, Aleksandra Piktus, Fabio Petroni, Vladimir
Karpukhin, Naman Goyal, Heinrich Küttler, Mike Lewis, Wen-tau Yih, Tim Rock-
täschel, et al. 2020. Retrieval-augmented generation for knowledge-intensive nlp
tasks. Advances in Neural Information Processing Systems 33 (2020), 9459–9474.
[32] Pengfei Liu, Weizhe Yuan, Jinlan Fu, Zhengbao Jiang, Hiroaki Hayashi, and
Graham Neubig. 2023. Pre-train, prompt, and predict: A systematic survey of
prompting methods in natural language processing. Comput. Surveys 55, 9 (2023),
1–35.
[33] Llama Index 2023. Llama Index. https://github.com/run-llama/llama_index.
[34] Yao Lu, Max Bartolo, Alastair Moore, Sebastian Riedel, and Pontus Stenetorp.
2021. Fantastically ordered prompts and where to find them: Overcoming few-
shot prompt order sensitivity. arXiv preprint arXiv:2104.08786 (2021).
[35] Mohammad Hossein Namaki, Avrilia Floratou, Fotis Psallidas, Subru Krishnan,
Ashvin Agrawal, Yinghui Wu, Yiwen Zhu, and Markus Weimer. 2020. Vamsa:
Automated Provenance Tracking in Data Science Scripts. In Proceedings of the 26th
ACM SIGKDD International Conference on Knowledge Discovery & Data Mining
(Virtual Event, CA, USA) (KDD ’20). Association for Computing Machinery, New
York, NY, USA, 1542–1551. https://doi.org/10.1145/3394486.3403205
[36] Avanika Narayan, Ines Chami, Laurel Orr, Simran Arora, and Christopher Ré.
2022. Can foundation models wrangle your data? arXiv preprint arXiv:2205.09911
(2022).
[37] Shuyin Ouyang, Jie M Zhang, Mark Harman, and Meng Wang. 2023. LLM is
Like a Box of Chocolates: the Non-determinism of ChatGPT in Code Generation.
arXiv preprint arXiv:2308.02828 (2023).
[38] Andrei Paleyes, Raoul-Gabriel Urma, and Neil D Lawrence. 2022. Challenges
in deploying machine learning: a survey of case studies. Comput. Surveys 55, 6
(2022), 1–29.
[39] Aditya G Parameswaran, Shreya Shankar, Parth Asawa, Naman Jain, and Yujie
Wang. 2023. Revisiting Prompt Engineering via Declarative Crowdsourcing.
arXiv preprint arXiv:2308.03854 (2023).
[40] Chris Parnin, Gustavo Soares, Rahul Pandita, Sumit Gulwani, Jessica Rich, and
Austin Z. Henley. 2023. Building Your Own Product Copilot: Challenges, Oppor-
tunities, and Needs. arXiv:2312.14231 [cs.SE]
[41] Neoklis Polyzotis, Sudip Roy, Steven Euijong Whang, and Martin Zinkevich.
2018. Data lifecycle challenges in production machine learning: a survey. ACM
SIGMOD Record 47, 2 (2018), 17–28.
[42] Alexander Ratner, Stephen H Bach, Henry Ehrenberg, Jason Fries, Sen Wu,
and Christopher Ré. 2020. Snorkel: Rapid training data creation with weak
supervision. The VLDB Journal 29, 2-3 (2020), 709–730.
[43] Traian Rebedea, Razvan Dinu, Makesh Sreedhar, Christopher Parisien, and
Jonathan Cohen. 2023. Nemo guardrails: A toolkit for controllable and safe llm
applications with programmable rails. arXiv preprint arXiv:2310.10501 (2023).
[44] Cedric Renggli, Frances Ann Hubis, Bojan Karlaš, Kevin Schawinski, Wentao
Wu, and Ce Zhang. 2019. Ease.Ml/Ci and Ease.Ml/Meter in Action: Towards Data
Management for Statistical Generalization. Proc. VLDB Endow. 12, 12 (aug 2019),
1962–1965. https://doi.org/10.14778/3352063.3352110
[45] Jon Saad-Falcon, Omar Khattab, Christopher Potts, and Matei Zaharia. 2023.
ARES: An Automated Evaluation Framework for Retrieval-Augmented Genera-
tion Systems. arXiv preprint arXiv:2311.09476 (2023).
[46] Max Schäfer, Sarah Nadi, Aryaz Eghbali, and Frank Tip. 2023. An Empirical
Evaluation of Using Large Language Models for Automated Unit Test Generation.
arXiv preprint arXiv:2302.06527 (2023).
[47] Sebastian Schelter, Stefan Grafberger, Shubha Guha, Bojan Karlas, and Ce Zhang.
2023. Proactively Screening Machine Learning Pipelines with ARGUSEYES. In
Companion of the 2023 International Conference on Management of Data (Seattle,
WA, USA) (SIGMOD ’23). Association for Computing Machinery, New York, NY,
USA, 91–94. https://doi.org/10.1145/3555041.3589682
[48] Sebastian Schelter, Dustin Lange, Philipp Schmidt, Meltem Celikel, Felix Biess-
mann, and Andreas Grafberger. 2018.
Automating Large-Scale Data Qual-
ity Verification.
Proc. VLDB Endow. 11, 12 (aug 2018), 1781–1794.
https:
//doi.org/10.14778/3229863.3229867
[49] Shreya Shankar, Labib Fawaz, Karl Gyllstrom, and Aditya Parameswaran. 2023.
Automatic and Precise Data Validation for Machine Learning. In Proceedings of the
32nd ACM International Conference on Information and Knowledge Management.
2198–2207.
[50] Shreya Shankar, Rolando Garcia, Joseph M Hellerstein, and Aditya G
Parameswaran. 2022. Operationalizing machine learning: An interview study.
arXiv preprint arXiv:2209.09125 (2022).
[51] Shreya Shankar, Bernease Herman, and Aditya G Parameswaran. 2022. Rethink-
ing streaming machine learning evaluation. arXiv preprint arXiv:2205.11473
(2022).
[52] Shreya Shankar, Haotian Li, Will Fu-Hinthorn, Harrison Chase, J.D. Zamfirescu-
Pereira, Yiming Lin, Sam Noyes, Eugene Wu, and Aditya Parameswaran.
2023.
SPADE: Automatically digging up evals based on prompt refine-
ments. https://blog.langchain.dev/spade-automatically-digging-up-evals-based-
on-prompt-refinements/
[53] Chenglei Si, Zhe Gan, Zhengyuan Yang, Shuohang Wang, Jianfeng Wang, Jordan
Boyd-Graber, and Lijuan Wang. 2022. Prompting gpt-3 to be reliable. arXiv
preprint arXiv:2210.09150 (2022).
[54] Mohammed Latif Siddiq, Joanna Santos, Ridwanul Hasan Tanvir, Noshin Ul-
fat, Fahmid Al Rifat, and Vinicius Carvalho Lopes. 2023. Exploring the Effec-
tiveness of Large Language Models in Generating Unit Tests. arXiv preprint
arXiv:2305.00418 (2023).
[55] Arnav Singhvi, Manish Shetty, Shangyin Tan, Christopher Potts, Koushik
Sen, Matei Zaharia, and Omar Khattab. 2023.
DSPy Assertions: Computa-
tional Constraints for Self-Refining Language Model Pipelines. arXiv preprint
arXiv:2312.13382 (2023).
[56] Benjamin Steenhoek, Michele Tufano, Neel Sundaresan, and Alexey Svyatkovskiy.
2023. Reinforcement Learning from Automatic Feedback for High-Quality Unit
Test Generation. arXiv preprint arXiv:2310.02368 (2023).
[57] Junjie Wang, Yuchao Huang, Chunyang Chen, Zhe Liu, Song Wang, and Qing
Wang. 2023. Software testing with large language model: Survey, landscape, and
vision. arXiv preprint arXiv:2307.07221 (2023).
[58] Yidong Wang, Zhuohao Yu, Zhengran Zeng, Linyi Yang, Wenjin Yao, Cunxiang
Wang, Hao Chen, Chaoya Jiang, Rui Xie, Jindong Wang, et al. 2023. PandaLM:
An Automatic Evaluation Benchmark for LLM Instruction Tuning Optimization.
In The Twelfth International Conference on Learning Representations.
[59] Yufei Wang, Wanjun Zhong, Liangyou Li, Fei Mi, Xingshan Zeng, Wenyong
Huang, Lifeng Shang, Xin Jiang, and Qun Liu. 2023. Aligning large language
models with human: A survey. arXiv preprint arXiv:2307.12966 (2023).
[60] Jason Wei, Xuezhi Wang, Dale Schuurmans, Maarten Bosma, Fei Xia, Ed Chi,
Quoc V Le, Denny Zhou, et al. 2022. Chain-of-thought prompting elicits reason-
ing in large language models. Advances in Neural Information Processing Systems
35 (2022), 24824–24837.
[61] Tongshuang Wu, Ellen Jiang, Aaron Donsbach, Jeff Gray, Alejandra Molina,
Michael Terry, and Carrie J Cai. 2022. Promptchainer: Chaining large language
model prompts through visual programming. In CHI Conference on Human Factors
in Computing Systems Extended Abstracts. 1–10.
[62] Tongshuang Wu, Michael Terry, and Carrie Jun Cai. 2022. Ai chains: Transparent
and controllable human-ai interaction by chaining large language model prompts.
In Proceedings of the 2022 CHI conference on human factors in computing systems.
1–22.
[63] Ziang Xiao, Susu Zhang, Vivian Lai, and Q Vera Liao. 2023.
Evaluating
NLG Evaluation Metrics: A Measurement Theory Perspective. arXiv preprint
arXiv:2305.14889 (2023).
[64] JD Zamfirescu-Pereira, Richmond Y Wong, Bjoern Hartmann, and Qian Yang.
2023. Why Johnny can’t prompt: how non-AI experts try (and fail) to design
LLM prompts. In Proceedings of the 2023 CHI Conference on Human Factors in
Computing Systems. 1–21.
[65] Xinghua Zhang, Bowen Yu, Haiyang Yu, Yangyu Lv, Tingwen Liu, Fei Huang,
Hongbo Xu, and Yongbin Li. 2023. Wider and deeper llm networks are fairer llm
evaluators. arXiv preprint arXiv:2308.01862 (2023).
[66] Yongchao Zhou, Andrei Ioan Muresanu, Ziwen Han, Keiran Paster, Silviu Pitis,
Harris Chan, and Jimmy Ba. 2022. Large language models are human-level
prompt engineers. arXiv preprint arXiv:2211.01910 (2022).
14

---

A
NOTATION
Table 8 summarizes the important notation used in the paper, in-
cluding high-level descriptions of the ILP variables.
Symbol
Description
P
A prompt template (i.e., a string with placeholders, intended to be
submitted to an LLM)
P𝑖
The 𝑖th version of a prompt template
ΔP𝑖
The diff or changes between consecutive versions of a prompt template
𝐸
The set of all hypothetical example runs for an LLM pipeline
𝐸′
A small set of example runs for an LLM pipeline (with labels denoting
whether responses were good) that we can observe, where 𝐸′ ⊂𝐸
𝑛
The number of examples in 𝐸′
𝑒𝑖
The 𝑖th example in 𝐸′
𝑓
An arbitrary assertion function
𝐹
The set of all candidate assertions from Section 2
𝑚
The number of assertions in 𝐹
𝐹′
A subset of 𝐹selected as a minimal set of assertions
𝐺
Set of functions in 𝐹\ 𝐹′ not subsumed by 𝐹′ (as defined by Defini-
tion 3.3)
ˆ𝑦𝑖
Binary indicator of whether example 𝑒𝑖satisfies all assertions in 𝐹′
𝑦𝑖
Binary indicator of whether a developer considers the LLM pipeline
response for example 𝑒𝑖good (i.e., success) or bad (i.e., failure)
𝛼
Threshold for coverage of failing examples; 𝐹′ should cover at least 𝛼
of failing examples
𝜏
Threshold for False Failure Rate (FFR); 𝐹′ should fail no more than 𝜏
good examples
𝑀
𝑛× 𝑚matrix representing the results of assertions on examples in 𝐸′
𝐾
𝑚× 𝑚matrix representing subsumption relationships between func-
tions
𝑥𝑗
ILP variable indicating inclusion of 𝑓𝑗in 𝐹′
𝑤𝑖𝑗
ILP variable representing if 𝐹′ denotes 𝑒𝑖as a failure
𝑢𝑖
ILP variable indicating if a failed example is covered
𝑧𝑖
ILP variable defining if 𝐹′ incorrectly marks a successful example as a
failure (false failure)
𝑟𝑗
ILP variable indicating if a function is subsumed by any function in 𝐹′
𝑠𝑗
ILP variable representing functions in 𝐹\ 𝐹′ not subsumed by 𝐹′
Table 8: Notation used in the paper
B
LANGCHAIN PROMPT HUB AND
TAXONOMY OF PROMPT DELTAS
The LangChain Prompt Hub is an open-source repository of prompts
for chains, detailing the version history of the prompts. In analyzing
prompt deltas, we filter the Prompt Hub for user-uploaded chains
with at least 3 prompt versions. Table 7 summarizes the chains
analyzed.
C
SPADE PROMPTS
spade leverages LLMs in three places. The first uses GPT-4 to cat-
egorize the delta (constructed by Python’s difflib). The second
uses GPT-4 to generate Python assertion functions, based on the
prompt and categories identified by the first ste.. The third usage
of LLMs is in asking GPT-4 to evaluate whether two functions
subsume each other.
Given prompt_diff, a list of sentences that have been modified
from the previous prompt template to the current prompt template
(i.e., ΔP), the prompt for categorizing the delta is as follows:
"""
Here are the changed lines in my prompt template:
``{prompt_diff}''
I want to write assertions for my LLM pipeline to run
↩→on all pipeline responses. Here are some categories
↩→
of assertion concepts I want to check for:
- Presentation Format: Is there a specific format for
↩→the response , like a comma -separated list or a JSON
↩→
object?
- Example Demonstration: Does the prompt template
↩→include any examples of good responses that
↩→demonstrate any specific headers , keys , or
↩→structures?
- Workflow Description: Does the prompt template
↩→include any descriptions of the workflow that the
↩→LLM should follow , indicating possible assertion
↩→concepts?
- Count: Are there any instructions regarding the
↩→number of items of a certain type in the response ,
↩→such as ``at least '', ``at most '', or an exact
↩→number?
- Inclusion: Are there keywords that every LLM
↩→response should include?
- Exclusion: Are there keywords that every LLM
↩→response should never mention?
- Qualitative Assessment: Are there qualitative
↩→criteria for assessing good responses , including
↩→specific requirements for length , tone , or style?
- Other: Based on the prompt template , are there any
↩→other concepts to check in assertions that are not
↩→covered by the above categories?
Give me a list of concepts to check for in LLM
↩→responses. Each item in the list should contain a
↩→string description of a concept to check for , its
↩→corresponding category , and the source , or phrase
↩→in the prompt template that triggered the concept.
↩→For example , if the prompt template is "I am a
↩→still -life artist. Give me a bulleted list of
↩→colors that I can use to paint <object >.", then a
↩→concept might be "The response should include a
↩→bulleted list of colors ." with category "
↩→Presentation Format" and source "Give me a bulleted
↩→
list of colors ".
Your answer should be a JSON list of objects within
↩→```json ``` markers , where each object has the
↩→following fields: "concept", "category", and "
↩→source ". This list should contain as many assertion
↩→
concepts as you can think of , as long are specific
↩→
and reasonable.
"""
Let concepts be the parsed categories identified by the previous
prompt. The prompt for generating the Python assertion functions
is as follows:
15

---

Task Domain
Summary of Prompt
Num. Versions
Conversational AI
Act as an AI assistant that can execute tools and have a natural conversation with a user.
8
Web Development
Generate Tailwind CSS components like text, tables, and cards to help answer fantasy football questions.
3
Question Answering
Identify key assumptions in questions and generate follow-up questions to fact check those assumptions.
5
Programming Assistant
Safely execute any code a user provides to help them complete tasks, while alerting them to any concerning instructions.
3
Model Evaluation
Evaluate a model’s outputs by assigning a score based on provided criteria and examples.
6
Question Answering
Concisely answer questions using no more than 3 sentences and provided context passages.
9
Workflow Automation
Create a JSON workflow using a list of provided tools based on the user’s natural language query.
11
Question Answering
Answer open-ended questions by asking clarifying follow-up questions before providing a final answer.
8
Information Retrieval
Determine if a passage contains enough useful information to help answer a specific question.
3
Code Translation
Convert Python code snippets to valid, idiomatic TypeScript code.
6
Code Review
Review GitHub pull requests and provide constructive feedback for improvement.
8
Question Answering
Concisely answer questions using no more than 3 sentences and provided context passages.
5
Email Marketing
Craft a user onboarding email following marketing best practices based on provided context.
3
Text Summarization
Summarize long text into a compelling, engaging Twitter thread for a target audience.
4
Email Marketing
Craft a user onboarding email following marketing best practices based on provided context.
7
Procurement Automation
Develop a detailed, tailored negotiation strategy report using provided information about suppliers, goals, etc.
8
Education
Teach statistics topics interactively by answering questions, providing feedback, and posing example problems.
3
Fitness
Convert a text description of a fitness challenge into a structured exercise program.
3
Education
Generate engaging, concise quiz questions based on the information contained in a provided context document.
5
Table 7: Description of each chain in our dataset. We describe the domain of the task the chain is trying to perform, and a short
summary of the task.
"""
Here is my prompt template:
"{ prompt_template }"
Here is an example and its corresponding LLM response:
Example: {sample_example}
LLM Response: {sample_response}
Here are the concepts I want to check for in LLM
↩→responses:
{concepts}
Give me a list of assertions as Python functions that
↩→can be used to check for these concepts in LLM
↩→responses. Assertion functions should not be
↩→decomposed into helper functions. Assertion
↩→functions can leverage the external function `
↩→ask_llm ` if the concept is too hard to evaluate
↩→with Python code alone (e.g., qualitative criteria)
↩→. The `ask_llm ` function accepts formatted_prompt ,
↩→response , and question arguments and submits this
↩→context to an expert LLM , which returns True or
↩→False based on the context. Since `ask_llm ` calls
↩→can be expensive , you can batch similar concepts
↩→that require LLMs to evaluate into a single
↩→assertion function , but do not cover more than two
↩→concepts with a function. For concepts that are
↩→ambiguous to evaluate , you should write multiple
↩→different assertion functions (e.g., different `
↩→ask_llm ` prompts) for the same concept(s).
Each function should take in 3 args: an example (dict
↩→with string keys), prompt formatted on that example
↩→
(string), and LLM response (string). Each function
↩→
shold return a boolean indicating whether the
↩→response satisfies the concept(s) covered by the
↩→function. Here is a sample assertion function for
↩→an LLM pipeline that generates summaries:
```python
def assert_simple_and_coherent_narrative(example: dict
↩→, prompt: str , response: str):
# Check that the summary form a simple , coherent
↩→narrative telling a complete story.
question = "Does the summary form a simple ,
↩→coherent narrative telling a complete story ?"
return ask_llm(prompt , response , question)
```
Your assertion functions should be distinctly and
↩→descriptively named , and they should include a
↩→docstring describing what the function is checking
↩→for.
"""
16

---

C.1
Evaluating Subsumption
To evaluate subsumption, we use one prompt to query the subsumed
pairs, given all assertions, and then a second prompt to format the
subsumed pairs as a JSON so it can be easily parsed by spade. The
first prompt is as follows:
"""
Here are all the functions I have:\n\n{assertion_blob
↩→}\n\nBased on the code , please identify every pair
↩→of functions where one function implies the other.
↩→Note that function A might imply function B, but
↩→function B may not imply function A. If two
↩→functions A and B check for the same thing , then
↩→they both imply each other (i.e., A implies B and B
↩→
implies A), so you should list both directions.
↩→Feel free to use the function names to decide if
↩→two functions check for the same thing.
"""
In the prompt above, the assertion_blob represents a string of
all assertion functions. Then, the second prompt is as follows:
"""
Please return your answer as a JSON list within ```
↩→json ``` ticks , where each element of the list is a
↩→
tuple (A, B). If two functions A and B check for
↩→the same thing , make sure to include both tuples (A
↩→, B) and (B, A). For example , if I only had two
↩→functions `check_json ` and `assert_json `, the
↩→answer should be: ```json\n[(" check_json", "
↩→assert_json "), (" assert_json", "check_json ")]```
"""
17

---

