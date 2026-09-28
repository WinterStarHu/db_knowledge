# When Large Language Models Meet Vector Databases: A Survey

> 来源: https://arxiv.org/pdf/2402.01763

arXiv:2402.01763v4  [cs.DB]  23 Jun 2025
When Large Language Models Meet Vector Databases: A Survey
Zhi Jing*1, Yongye Su*2, Yikun Han*3, Bo Yuan4, Haiyun Xu6,
Chunjiang Liu5∗Kehai Chen4∗, Min Zhang4
1Carnegie Mellon University
2Purdue University
3University of Michigan
4Harbin Institute of Technology (Shenzhen)
5National Science Library (Chengdu), Chinese Academy of Sciences
6Shandong University of Technology
zjing2@cs.cmu.edu, su311@purdue.edu, yikunhan@umich.edu, 23s051006@stu.hit.edu.cn,
liucj@clas.ac.cn, chenkehai@hit.edu.cn, xuhy@sdut.edu.cn, zhangmin2021@hit.edu.cn
Abstract
This survey explores the synergistic potential
of Large Language Models (LLMs) and Vector
Databases (VecDBs), a burgeoning but rapidly
evolving research area.
With the proliferation
of LLMs comes a host of challenges, including
hallucinations, outdated knowledge, prohibitive
commercial application costs, and memory issues.
VecDBs emerge as a compelling solution to
these issues by offering an efficient means to
store, retrieve, and manage the high-dimensional
vector representations intrinsic to LLM operations.
Through this nuanced review, we delineate the
foundational principles of LLMs and VecDBs and
critically analyze their integration’s impact on
enhancing LLM functionalities.
This discourse
extends into a discussion on the speculative future
developments in this domain, aiming to catalyze
further research into optimizing the confluence of
LLMs and VecDBs for advanced data handling and
knowledge extraction capabilities.
1
Introduction
The field of Natural Language Processing (NLP) achieves
a great milestone when ChatGPT unlocks the power of
interactive smart assistants and people are offered the
unprecedentedly tangible experience of talking to a machine
program that is seemingly more knowledgeable than an
ordinary person.
This remarkable breakthrough is largely
attributed to the advancements in LLMs, such as GPT
[Brown et al., 2020; Achiam et al., 2023], T5
[Raffel et
al., 2020], and Llama
[Touvron et al., 2023].
They can
process, understand, and generate human-like text. Thanks to
the power of pre-training, which involves training a language
model on a massive corpus of text data, LLMs can capture the
complexities of human languages, including context, idioms,
and even cultural references.
∗Corresponding author.
However, despite the impressive capabilities of LLMs, they
are still under the shadows of doubt in certain aspects. 1. One
major shortcoming is the problem of hallucination, where
LLMs generate plausible but factually incorrect or faithfully
nonsensical information
[Huang et al., 2023].
There are
many potential causes behind this. First, LLMs lack domain
knowledge.
The fact that LLMs are primarily trained on
public datasets [Penedo et al., 2023] inevitably leads to a
limited ability to answer domain-specific questions that are
out of the scope of their internal knowledge.
Moreover,
real-time knowledge updates are challenging for LLMs. Even
if the questions are within the learning corpus of LLMs,
their answers may still exhibit limitations because the internal
knowledge may be outdated when the outside world is
dynamic and keeps changing [Onoe et al., 2022]. Last but
not least, LLMs are found to be biased. The datasets used
to train LLMs are large, which may introduce systematic
errors [Bender et al., 2021]. Essentially, every dataset can
be questioned with bias issues, including imitative falsehoods
[Lin et al., 2022], duplicating biases [Lee et al., 2022], and
social biases [Narayanan Venkit et al., 2023]. 2. Another
disadvantage of incorporating LLMs commercially is the
expensive cost [Schwartz et al., 2020].
For an average
business entity, applying LLMs for business use is barely
feasible.
It is almost impossible for a non-tech company
to customize and train a GPT model of its own because
they don’t have the resources and talents to conduct such
a big project [Musser, 2023], while frequent API calls to
third-party LLM providers like OpenAI can be extremely
expensive, not to mention there are a very limited number
of such providers in certain areas. 3. The oblivion problem
of LLMs has been controversial because LLMs are found to
tend to forget information from previous inputs. It is studied
that LLMs also exhibit the behavior of catastrophic forgetting
[Luo et al., 2023] as neural networks do
[Kemker et al.,
2017].
While generative models like LLMs use vector data
embeddings to represent unstructured data in our real world,
users need a reliable data system to manage and retrieve
a considerable amount of data with cost-efficiency.
Yet

---

another increasingly popular field that seems orthogonal
to LLMs is purpose-built databases for AI that support
vector data storage and its efficient retrieval at scale, also
known as VecDB. With efficient combinations of VecDBs
and LLMs, VecDBs can either be incorporated as an external
knowledge base with efficient retrieval providing domain-
specific knowledge for LLMs, a memory for LLMs saving
previous related chat contents for each user’s dialog tab, or a
semantic cache, the aforementioned problems of LLMs can
be seamlessly solved.
In the light of lacking papers that introduce LLMs in the
view of VecDB, this survey aims to picture how VecDBs can
be potential solutions to refine LLMs’ known shortcomings
in previous works and hopes to offer a unique perspective of
future directions in the intersection that is fertile of research
opportunities.
2
Background
2.1
Large Language Models
Over the last half-decade, we have witnessed the ground-
breaking success of LLMs, marking a significant milestone
in the field of NLP. LLMs have revolutionized our views
on the approaches to understanding and generating human
languages by machines.
Development of Language Models
With the advent of neural networks, the field of NLP
has undergone a transformative shift, which began with
the introduction of Recurrent Neural Networks (RNNs)
[Zaremba et al., 2014].
RNNs provide a way to process
sequences of words and capture temporal dependencies in
text. And 2 of its famous variants, Gated Recurrent Units
(GRUs) [Chung et al., 2014] and Long Short-Term Memory
networks (LSTMs) [Shi et al., 2015] address the limitations
of RNNs in handling problems of vanishing and exploding
gradients.
The next pivotal milestone for language models is
the widespread adoption of the Transformer architecture
[Vaswani et al., 2017] which has set a new standard for
language models.
The multi-head self-attention modules
and cross-attention modules in the encoders and decoders
enable the model to capture long-range dependencies, parallel
processing, and contextual understanding. Furthermore, the
model starts to rapidly grow in size in the Transformer era.
More importantly, the Transformer represents a paradigm
shift in the NLP field, and the success of the Transformer
architecture becomes the significant backbone of LLMs.
Power of Pre-training
The scaling laws proposed by OpenAI [Kaplan et al., 2020]
highlight a critical trend: the scaling of Pretrained Language
Models (PLMs), in terms of both model size and data volume,
leads to significant improvement in downstream tasks. This is
evidenced by the development of increasingly larger PLMs,
such as the 1.76-trillion-parameter GPT-4
[Achiam et al.,
2023] and the 540-billion-parameter PaLM [Chowdhery et
al., 2023]. Unlike their smaller predecessors, like the 330-
million-parameter BERT
[Devlin et al., 2018] and 1.5-
billion-parameter GPT-2 [Radford et al., 2019], these large-
scale models demonstrate unique behaviors and emergent
abilities
[Wei et al., 2022] in various tasks like zero-shot
learning, which is extremely challenging for the small-scale
models.
The power of pre-training lies in its ability to provide
models with a general understanding of the languages, which
is then tailored through additional training, known as fine-
tuning, for specific tasks. The advantage is that the model
doesn’t start from scratch when learning a new task; it
builds upon a rich, pre-existing foundation of language
understanding.
This enables what is known as transfer
learning [Yosinski et al., 2014].
Are We There Yet? Challenges Faced by Pure LLMs
Although LLMs have achieved remarkable success, they
face significant challenges that cannot be overlooked. Three
primary challenges are particularly noteworthy in the context
of pure LLMs. Addressing these challenges is crucial for
the continued advancement and practical application of these
models. We have outlined these challenges as follows:
• Model Editing involves integrating more flexible
architectures into models, enabling targeted updates or
edits without the need for complete retraining.
This
presents a complex challenge: alterations in one part of
the model can unexpectedly affect other areas. Ensuring
that these updates neither degrade performance nor
introduce biases is a difficult task.
Model editing
also includes elements such as personality, emotions,
opinions, and beliefs.
While these aspects have
received some attention, they largely remain unexplored
territories
[Yao et al., 2023].
Ethical concerns,
including data biases [Raffel et al., 2020], privacy issues
[Li et al., 2023a], and the potential misuse of generative
content [Ganguli et al., 2022], are significant challenges
in model editing.
• Hallucinations in LLMs
[Ji et al., 2023] pose a
major challenge, undermining the reliability of their
outputs.
LLMs often generate plausible yet factually
incorrect or nonsensical information
[Huang et al.,
2023]. Several factors contribute to this issue. First,
LLMs lack domain-specific knowledge, primarily due
to their training on public datasets
[Penedo et al.,
2023], limiting their ability to answer domain-specific
questions. Additionally, updating LLMs with real-time
knowledge is a challenge, leading to outdated internal
knowledge in a rapidly changing world [Onoe et al.,
2022].
• Substantial computational resources required for
training and operating LLMs raise environmental
and accessibility concerns
[Strubell et al., 2019],
contradicting the principles of sustainable AI [Wu and
Raghavendra, 2022]. The escalating sizes of LLMs and
their training datasets significantly influence training
and inference costs.
The environmental footprint
of these technologies is substantial, with significant
greenhouse gas emissions and energy consumption
during model training and tuning [Kaack et al., 2022].
This situation necessitates a critical evaluation of AI’s

---

Name
Supported Data
Supported Query
Vector Index
(Version with year)
Vec. Dim.
Type
Filter
Multi-Vec.
Graph
IVF
ChromaDB (2022)
1536
Vec.
✓
✓
Manu (2022)
32768
Vec.+ Ftx.
✓
✓
✓
✓
Milvus (2021)
32768
Vec.+ Ftx.
✓
✓
✓
✓
Pinecone (2019)
20000
Vec.
✓
✓
✓
✓
Weaviate (2019)
65535
Vec.+ Ftx.
✓
✓
✓
Qdrant (2021)
4096
Vec.+ Ftx.
✓
✓
✓
Amazon OpenSearch (v2.9, 2023)
16,000
Ftx.
✓
✓
✓
✓
Elastic Search (v8.0, 2022)
4096
Ftx.
✓
✓
✓
✓
AnalyticDB-V (2020)
≥512
Rel.+Ftx.
✓
✓
✓
PostgreSQL-pgvector (2021)
2000
Rel.+ Ftx.
✓
✓
✓
✓
MongoDB Atlas (v6.0, 2023)
2048
NoSQL+ Ftx.
✓
✓
MyScale (2023)
1536
Rel.
✓
✓
Table 1: Comparison of mainstream all-level databases supporting vector data (the version number represents the first version that supports
vector search and its release date). Abbreviations note: Ftx., Rel., Vec. stand for full-text search, relational database, and vector search.
environmental impact, encouraging the development of
more energy-efficient models and the adoption of green
computing practices [Wynsberghe, 2021].
Transitioning to VecDBs could potentially comprehen-
sively address these challenges. VecDBs, with their efficient
data structuring and retrieval capabilities, offer a promising
solution for enhancing model editing flexibility, reducing
hallucinations by improving domain-specific responses,
and optimizing computational resource utilization, thereby
aligning more closely with the principles of sustainable AI.
2.2
Vector Databases, the V-factor
A distinct database optimized for vector data
While LLMs like ChatGPT are relatively new concepts,
database management systems (DBMS) have been thor-
oughly developed and applied in many aspects in the last 60
years of history and are well-recognized for their consistent
stability and universality for structured data with fixed
formats that excel well with computer storage. However, the
development and wide application of deep learning models
such as convolutional neural networks [He et al., 2016] and
transformers [Devlin et al., 2018], enable the embedding of
unstructured multi-modal data like images and text mapped
into corresponding fixed-length vector representations, which
include the high-dimensional semantic features of original
data, and the semantic similarities are naturally represented
by distances between vectors, requiring a new type of
DBMS that is specifically designed for handling vector data
operations, especially search and storage.
There are many kinds of databases, whereas VecDBs
are the only category of databases that naturally support
diverse unstructured data with efficient storage, indexing, and
retrieval. As a result of various blooming applications on the
cloud, various data sources exist in many different formats
and diverse places. Unlike traditional databases that require
structured or semi-structured data that must convey a few
restrictions and formats, VecDBs are purpose-designed for
storing the deep learning embedding of various unstructured
data that has emerged in real-world applications.
On the
other hand, distinct from traditional DBMSs that search
for exact values within databases, the semantic feature of
vectors in VecDBs needs an approximate search for vectors,
which searches approximate top-k nearest-distance neighbors
within the high-dimensional base vector data space that do
not necessarily require exact matches, representing top-k
semantically close data.
Efficient vector retrieval within VDBMS
With the unstructured base data embedded into vectors with
high dimensionality, calculating the k-nearest neighbors of
a given query vector data can be expensive since it requires
distance computation to every point in the dataset and
maintaining the top-k results.
Such an operation would
result in a time complexity of O(dN + N log k), where d
is the dimensionality and N is the number of vectors, for
exhaustively searching top-k results using pair-wise distance
calculation and a heap to keep top-k results.
Since brute-force search is time-consuming and compu-
tationally expensive, this calls for a more efficient search
and storage technique with satisfying accuracy.
Vector
indexing can solve both of these problems, which optimized
for ANN search within VDBMS include tree-based [Muja
and Lowe, 2009; Tao et al., 2009], hash-based [Andoni
and Indyk, 2008], Product Quantization (PQ) [J´egou et al.,
2011], and graph-based methods [Malkov and Yashunin,
2018], while the ANN Benchmarks 1 has also showcased
the great performance gap between brute-force search and
index-enhanced ANN search.
All these operations could
be efficiently done based on the vector indexes, which are
optimally designed collections of vectors deployed together
for approximate nearest neighbor (ANN) search. The ANN
Benchmarks have also showcased the great performance
gap between brute-force search and index-enhanced ANN
1https://ann-benchmarks.com/

---

search. Also, according to them, among all these indexes, the
graph-based Hierarchical Navigable Small Worlds (HNSW)
provides state-of-the-art performance and capability with
great universality and is widely used within most VecDB
management systems, including the examples we mentioned
in Table 1.
A feasible solution of knowledge base for LLMs
Traditional full-text and keyword search engines, such as
Elastic Search and Amazon OpenSearch, are based on term
frequency metrics like BM25, which has proved practical for
many search applications. However, such search techniques
require significant investment in time and expertise to tune
them to account for the meaning or relevance of the terms
searched. On the other hand, they lack multi-modal storage
and retrieval support, as VecDBs do.
Nevertheless, VecDBs are capable of solving the aforemen-
tioned problem by simply transforming data into vectors and
leveraging their retrieval efficiency; thus, the emergence of
VecDBs (as shown in Table 1) has greatly influenced machine
learning systems and their multi-modal applications.
An
intuitive application using vector search is searching images
with an image on search engines built on VecDBs [Wang
et al., 2021] like Google Image Search 2, which uses one
input image to find similar images on the internet. While
VecDBs boast their unique search capability and efficiency
for unstructured data, they are just a back-end factor for
manifold applications. To maximize their abilities, this leads
us to an interesting question: since LLMs use embeddings
to represent text as vectors, can developers combine VecDBs
and LLMs to overcome the aforementioned challenges that
are inherited in LLM applications? The answer is yes.
As a kind of database encapsulated with vector search
in vector data that represents real-world information within
high dimensionalities, VecDBs are well-capable for retrieval
applications [Asai et al., 2023] incorporating LLMs because
LLM applications are generally read-intensive, not requiring
many write-related changes, especially data deletes [Pan et
al., 2023].
On the other hand, VecDBs can efficiently
manage and warehouse vector data required and generated
by LLMs, thus providing a solid data cornerstone for both
LLMs and their applications. While LLMs are often limited
by domain knowledge that cannot be uploaded or distributed
due to security and privacy concerns, domain knowledge is
often unstructured data that can easily be embedded into
VecDBs for efficient local retrieval and further integration
with generative AIs. Moreover, the computing and storage
resources of VecDBs are way cheaper than LLMs, since
they do require costly GPUs and TPUs, thus achieving a
cost-effective way of fast retrieval and durable (non-volatile)
storage.
3
Synergizing LLMs with VecDBs:
Enhancements and Innovations
With recent rapid development in both areas, applications that
utilize the combination of the two are also growing rapidly,
2https://cloud.google.com/vertex-ai/docs/vector-search/
overview
and the most fruitful one is Retrieval-Augmented Generation
(RAG), where VecDBs play a crucial role in enabling cost-
effective data storage and efficient retrieval.
3.1
VecDB as an External Knowledge Base:
Retrieval-Augmented Generation (RAG)
Development of RAG Paradigm
As the release of ChatGPT casts a spotlight on LLMs
to the public world, there is an increasing need to use
AI chatbots as query and retrieval agents.
But simply
loading users’ private data as input to LLMs is found to
be incompetent in real-world applications.
LLMs have
been constrained by their limited token counts and the
high costs associated with training and fine-tuning for every
alteration of data, especially when dealing with personalized
or business-specific responses that require real-time data
updates.
To address such concerns and needs, retrieval-
augmented generation (RAG) emerges as a novel solution
that addresses the challenges faced by LLMs in integrating
and processing large and dynamic data in external databases,
where VecDBs offer a solution by acting as external memory
for LLMs. They allow for the segmentation of private data
by converting them into vectors and storing these vectors
efficiently for a quick retrieval process.
Integrating with
VecDBs enables LLMs to access and synthesize enormous
amounts of data without the need for constant re-training,
thereby overcoming their inherent limitations.
The concept of RAG is devised to be a paradigm, and a
common workflow of RAG is illustrated in Figure 1. There
are essentially three main parts to a full run of the system:
data storage, retrieval, and generation.
Data storage means establishing reliable external memory
like VecDBs, and there are detailed recipes for this process
[Han et al., 2023]. It starts with data preprocessing, during
which the original data is collected, cleaned, integrated,
transformed, normalized, and standardized. The processed
data is chunked into smaller segments because of the
contextual limitations of LLMs.
These segments of data
are then converted by an embedding model into vectors,
the semantic representations of the data, which are stored
in VecDBs and will be used for vector search in later
steps.
A well-developed VecDB will properly index the
data and optimize the retrieval process.
The retrieval
part starts with a user asking a question in the form of
prompts to the same embedding model, which has generated
the vector representation of the stored data and gained
the vector embeddings of the question.
The next step
of the process is vector searching and scoring inside the
VecDBs, which essentially involves computing similarity
scores among vectors, and the database then identifies and
retrieves the data segments that have the highest similarity
scores (top K in most RAG systems) compared to the query
vector.
These retrieved segments are then converted back
from their vector format to their original form, which is
typically the text of documents. In the generation part, LLMs
are involved in generating the final answers. The retrieved
documents, along with the user’s question, are incorporated
into a specifically chosen and designed prompt template.
This template selection is based on the task type and aims

---

audio
Unstructured Data
Chunking 
Embedding Model
Vector Database
Vectorized
Create 
Embeddings
Question
Get Relevant 
Documents
Large Language Models
Get Answers
Prompt  
Template
Embeddings 
Text
Audio Image
Video
Vector Search 
Context
Please answer the question 
using the given context. If 
you don't know the answer, 
just say that you don't know.
Context:
“{Context}”
Question:
“{Question}”
Llama
Get Answers
Question
Question:
Who starred in Oppenheimer as 
Oppenheimer?
Context:
•
In Oppenheimer Cillian Murphy plays J. Robert Oppenheimer …
•
In Oppenheimer Robert Downey Jr. plays Lewis Strauss …
•
In Oppenheimer Emily Blunt plays Katherine Oppenheimer … 
•
In Oppenheimer Kurt Koehler plays Thomas Morgan ...
Answer (RAG):
In Oppenheimer, Cillian Murphy starred as J. Robert 
Oppenheimer.
Answer (No RAG):
As of my last knowledge update in January 2022, there 
hadn't been a widely released film or television 
production about J. Robert Oppenheimer with a well-
known actor portraying him.
Figure 1: A sample RAG framework that uses VecDBs.
to effectively merge the context with the question to form
a coherent prompt. The selected LLM is provided with the
prompt and generates the final answer.
RAG with VecDBs
In the prototype of the RAG paradigm, we use such an idea to
overcome the hallucination problems of LLMs by providing
domain-specific data with accurate instructions.
where
VecDBs serve as an external knowledge base to warehouse
domain-specific data, then LLMs can easily handle massive
data owned by users.
Even though LLMs such as ChatGPT now have user-
specified GPTs for specific uses, with just prompt engineer-
ing, their knowledge bases are still limited to the training data
provided by OpenAI. However, by using VecDBs, users can
pre-filter whatever they want it to look at, whereas that is
difficult with prompt-engineering GPT assistants.
Many research and industry examples justified RAG’s
profound effect.
Azure AI Search (formerly Cognitive
Search)
developed
its
vector
search
using
Qdrant
3.
Another example is Pinecone’s Canopy 4, an open-source
framework that leverages Pinecone’s VecDB to build and host
production-ready RAG systems. Companies like Spotify and
Yahoo have adopted Vespa, an AI-driven online VecDB, and
Yahoo uses it to help users directly chat with their mailbox,
ask questions about their mailbox, and tell it to do things
for them. This uses personalized data integrated with LLMs
to form a RAG system 5.
These examples demonstrate
the strength of RAG combined with VecDBs to address the
unique challenges faced by business enterprises in managing
and extracting value from diverse datasets but also showcase
how the aforementioned difficulties faced by LLMs can be
solved via integration with VecDBs.
3https://learn.microsoft.com/en-us/azure/search/
vector-search-overview
4https://www.pinecone.io/blog/canopy-rag-framework/
5https://vespa.ai/
3.2
VecDB as a Cost-effective Semantic Cache
The combination of VecDBs and LLM not only facilitates the
profound application of LLM with RAG but also provides a
new frontier for cost-effective end-to-end LLM applications.
Outrageous API Costs
LLM-based chatbots and agent
systems heavily rely on LLM’s output from API vendors;
repeated or similar inquiries may lead to outrageous API
costs.
API Bandwidth Limitations
Such chatbots and agent
systems could also experience a bursty inquiry workload that
may drown the system’s bandwidth with explosive API calls
coming within seconds, leading to the system’s outage and
reconfiguration.
One of the primary benefits of integrating VecDBs
with LLMs is the significant reduction in data operational
costs [Sanca and Ailamaki, 2023]. GPT-Cache [Bang, 2023],
a VecDB that serves as a semantic cache, as shown in
Figure 2, for instance, stores responses to previously asked
queries and works as a cache before calling LLM APIs. This
caching mechanism means that the system doesn’t need to
have API calls to wait for generated responses from scratch
every time, reducing the number of costly API calls to the
LLM. Moreover, this approach also speeds up the response
time, enhancing the user experience.
VecDBs enhance the LLMs’ ability to retrieve and utilize
relevant information by indexing vast amounts of previous
Q&A data and mapping them into a vector space. Instead
of caches in computer systems that require exact hash-match,
this allows more precise semantic matching of queries with
existing knowledge and results in responses that are not only
generated based on the LLM’s training data but also informed
by the most relevant and recent information available in the
VecDBs.
3.3
VecDB as a Reliable Memory of GPTs
Oblivion
When using LLM Q&A applications like Chat-
GPT, LLMs are likely to completely forget the content and

---

Vector Storage
(e.g. DynamoDB)
Large 
Language 
Models
Embedding
Models
text-embedding-3-small 
text-embedding-3-large
Q&A
Data
Vector  Search
Query IDs
Cache 
Hit
Yes
No
Natural 
Language 
Query (Q)
Generated 
Answer (A)
Generated
Cached
GPT Cache
Figure 2: An overview of semantic cache for GPTs that utilizes
VecDBs.
information of your previous conversation, even within the
same chat tab.
VecDBs serve as a robust memory layer [Zhang et
al., 2023b] that addresses one of the intrinsic limitations
of LLMs:
the static nature of their knowledge.
While
LLMs excel in generating human-like text based on patterns
learned during training, they cannot inherently update their
knowledge base dynamically and, thus, may lack the few-
shot learning ability. VecDBs bridge this gap by offering a
storage solution that can be continually updated with new
information, ensuring that the LLM’s responses are informed
by the most current and relevant data available.
The VecDB and LLM combination brings forth a synergy
where the LLM provides context and understanding for user
queries, while the VecDB offers a precise mechanism for
storing and retrieving the relevant vectors. This collaborative
approach allows for more accurate, relevant, and efficient
responses to complex queries, which would be challenging
for either system to address independently.
A VecDB integrated with an LLM facilitates real-time
learning and adaptation. As new data is ingested into the
VecDB, the LLM can immediately leverage this updated
repository to refine its responses. This capability is pivotal
for applications requiring up-to-the-minute accuracy, such
as financial analysis, news dissemination, and personalized
recommendations.
4
Expanding Horizons: RAG Advancements
4.1
Multimodality of RAG
RAG has now evolved to handle a wide range of data
types by lending the power of multimodal models.
The
impressive achievements of LLMs have inspired significant
advancements
in
vision-language
research.
DALL-E
from OpenAI introduced a Transformer-based approach for
converting text to images, treating images as sequences
of discrete tokens.
Subsequent improvements in the text-
to-image area
[Zhang et al., 2023a] have been achieved
through methods like model scaling,
pre-training,
and
enhanced image quantization models.
BLIP-2
[Li et al.,
2023b] uses static image encoders with LLMs for efficient
visual language pre-training, facilitating direct image-to-text
transformations. Flamingo [Alayrac et al., 2022] presented
a visual language model for text generation, showcasing
remarkable adaptability and leading performance across
various vision-and-language tasks. CM3 [Aghajanyan et al.,
2022] trained a randomly masked model on a large HTML
corpus and showed that the model is capable of generating
images and text. FROMAGe [Koh et al., 2023] gains robust
multimodal capabilities for few-shot learning solely from
image-caption pairs, unlike other models that necessitate
large-scale, interwoven image-text data from the websites.
To import speech data to RAG systems, Wav2Seq [Wu et
al., 2022] allows for efficient pre-training without the need
for transcriptions, using techniques like k-means clustering
and byte-pair encoding to generate pseudo-subwords from
speech. The Large Language and Speech Model (LLaSM)
[Shu et al., 2023] is an end-to-end trained, large multi-
modal speech-language model equipped with cross-modal
conversational skills and proficient in understanding and
responding to combined speech-and-language directives.
Videos are also made available for certain types of RAG
systems. Vid2Seq [Yang et al., 2023] enhances language
models with specific temporal indicators for predicting event
limits and textual descriptions in a single output sequence.
4.2
Retrieval Optimizations of RAG
To better harness the knowledge from various types of
data, kNN-LMs
[Khandelwal et al., 2020] explore how
incorporating nearest neighbor search into language models
can enhance their ability to generalize by effectively
leveraging memorized examples. EASE [Nishikawa et al.,
2022] is distinctive in its use of entities as a strong indicator
of text semantics, providing rich training signals for sentence
embedding. In-context RALM [Ram et al., 2023] proves
that with the language model architecture unchanged, simply
appending grounding documents to the input will improve the
performance. SURGE
[Kang and Kwak, 2023] enhances
dialogue generation by incorporating context-relevant sub-
graphs from a knowledge graph. Another work that combines
knowledge graphs and LLMs is RET-LLM
[Modarressi
et al., 2023], which is designed to equip LLMs with
a general write-read memory unit.
These studies have
focused on retrieval granularity and data structuring levels,
with coarse granularity providing more, but less precise,
information.
Conversely, structured text retrieval offers
detailed information at the cost of efficiency.
To utilize both internal knowledge and external resources,
SKR [Yu et al., 2023] improves LLMs’ ability by enabling
them to assess what they know and identify when to seek
external information to answer questions more effectively.
Selfmem
[Xin et al., 2023] enhances retrieval-augmented
text generation by creating an unbounded memory pool
using the model’s output and selecting the best output as
memory for subsequent rounds. FLARE [Jiang et al., 2023]
uses predictions of upcoming sentences to anticipate future
content and retrieve relevant documents for regenerating
sentences, especially when they contain low-confidence
tokens. Atlas [Izacard et al., 2022] demonstrates impressive
performance in tasks like question-answering and fact-
checking, outperforming much larger models despite having

---

fewer parameters. Many other works like these also aim to
make the RAG system more efficient and competent.
5
Discussion: Challenges and Future Work
Are vector searches all you need?
Although VecDBs offer a cost-efficient modality for infor-
mation retrieval within LLMs’ frameworks, their utility in
traditional relational database operations remains limited.
Specifically, vector-based search methodologies are still
not well optimized for operations such as post-query
filtering, comprehensive full-text searches, and keyword
search mechanisms that are fundamental to conventional
database systems and search engines.
In the context of
diverse applications for different users with multiple needs,
vector search, or any single search approach, is not a one-
size-fits-all solution.
For example, for searching exact
transaction data, users may have queries of very specific
keywords to look up in a huge pool of data; giving them
semantic approximate results totally would not make sense,
resulting in a one-step forward yet two-step back.
On
the other hand, traditional DBMSs are well-developed for
efficiently handling structured data within their transactional
and analytical applications, while dedicated VecDBs are not
yet.
This distinction underscores a potential gap in the func-
tional alignment of VecDBs with previously well-established
data retrieval paradigms, necessitating the development of
hybrid search algorithms that can seamlessly integrate vector
search with traditional relational data engine capabilities.
VDBMS with multi-modality
In real-world data representation and search, we may look
for multi-modal data entries that are not restricted to a
specific kind of structured, semi-structured, or unstructured
data, but with any random combination of them, e.g., users
can look for a knowledge graph from an interacted prompt
of image and description. While searches using uni-modal
data may lack the prospect of providing informative and
more contextually appropriate search results, multi-modal
data search and its hybrid processing also present a non-
trivial challenge for VecDBs’ storage and retrieval [Wang
and et al., 2023], since integrating and merging multi-
modal data require efficient preprocessing with multi-modal
encoders, multi-modal storage indexes, but also ranking
weight assignment and multi-modal data fusion.
Data preprocessing
While text embedding is considered efficient for processing
long text and its retrieval, it comes with a dazzling challenge
for building every text-based knowledge database.
It is
observed that vector retrieval would have fundamentally
better performance when precise chunks of text with clear
meaning are applied.
This raises an interesting question:
how do we have a proper (probably unified) embedding
methodology for every raw text?
On the other hand, dimension reduction for vector data
is considered important since compressing high-dimensional
vectors will use less memory and disk resources.
From
this view, the current vector data dimension is not cost-
effective, as the vectors are large, e.g., a 1536-dimensional
vector embedded only by OpenAI’s lightweight model text-
embedding-3-small 6 is about 6 kilobytes; with scaling up
to 1 billion, the data size would be 6 terabytes. Also with
the curse of dimensionality theory, data sparsity increases
with dimensionality, resulting in hardship in distinguishing
meaningful similarities.
Moreover,
current dimension
reduction algorithms like PQ contribute to a memory-efficient
vector data representation, whereas lossy data compression
still hurts the recall quality [Chen et al., 2021]. This requires
a more efficient vector data dimension reduction algorithm
for VecDBs and searches.
Data management systems for LLMs with multi-tenancy
Both for VecDBs and LLMs, this challenge is particularly
in preventing data leaks between tenants and maintaining the
isolation and security of distinct tenants’ data while ensuring
efficiency, where isolation is crucial for privacy and security.
On the other hand, it must be balanced with the need for
dynamic resource sharing to ensure resources are flexibly
allocated and deallocated.
Cost-effective and scalable data storage and retrieval
While state-of-the-art vector search algorithms are mainly
memory-based, memory resources in the cloud are consid-
ered expensive and volatile.
With billion-scale amounts
of data, naively handling them in memory resources is
bankrupting. On the other hand, disk-based search methods
have downgraded performance that does not satisfy real-time
applications with low latency tolerance.
This calls for a
more cost-effective way to ensure the performance of LLM
applications.
Knowledge conflict
Conflicting knowledge from the same or different knowledge
bases presents a non-trivial challenge for both humans and
LLMs to distinguish the correct piece of knowledge. This
conflict becomes particularly prominent when integrating
multiple knowledge bases where each potentially carries its
own biases or inaccuracies, such as when different datasets
provide contradictory information about the same fact or
when biases inherent in data sources lead to inconsistent
conclusions.
While VecDBs cannot naturally distinguish,
resolving such conflicts requires robust conflict resolution
strategies that can assess the reliability of sources and the
context of data to determine the most accurate information.
6
Conclusion
In this paper, we present a systematic review of recent
advances in combinations of LLMs and VecDBs.
We
summarize the rationales for viewing LLMs with VecDBs
and also introduce certain applications that combine LLMs
and VecDBs with distinct prototypes that categorize exist-
ing works from various perspectives and interdisciplinary
studies. Our study also demonstrates both the research and
engineering challenges in this fast-growing field and suggests
directions for future work.
6https://platform.openai.com/docs/guides/embeddings

---

References
[Achiam et al., 2023] Josh Achiam, Steven Adler, et al. Gpt-
4 technical report. arXiv preprint arXiv:2303.08774, 2023.
[Aghajanyan et al., 2022] Armen
Aghajanyan,
Bernie
Huang, et al. Cm3: A causal masked multimodal model
of the internet. arXiv preprint arXiv:2201.07520, 2022.
[Alayrac et al., 2022] Jean Alayrac, Jeff Donahue, et al.
Flamingo: a visual language model for few-shot learning.
arXiv preprint arXiv:2204.14198, 2022.
[Andoni and Indyk, 2008] Alexandr Andoni and Piotr Indyk.
Near-optimal hashing algorithms for approximate nearest
neighbor in high dimensions. Comm. ACM, 51(1):117–
122, 2008.
[Asai et al., 2023] Akari Asai, Sewon Min, et al. Retrieval-
based language models and applications. In ACL, pages
41–46, 2023.
[Bang, 2023] Fu Bang. Gptcache: An open-source semantic
cache for llm applications enabling faster answers and cost
savings. In NLP-OSS Workshop, pages 212–218, 2023.
[Bender et al., 2021] Emily M Bender, Timnit Gebru, et al.
On the dangers of stochastic parrots: Can language models
be too big? In FAccT, page 610–623, 2021.
[Brown et al., 2020] Tom Brown, Benjamin Mann, et al.
Language models are few-shot learners. In NeurIPS, pages
1877–1901, 2020.
[Chen et al., 2021] Qi Chen, Bing Zhao, et al.
Spann:
Highly-efficient billion-scale approximate nearest neigh-
bor search. In NeurIPS 2021, 2021.
[Chowdhery et al., 2023] Aakanksha
Chowdhery,
Sharan
Narang, et al.
Palm: Scaling language modeling with
pathways. JMLR, 24(240):1–113, 2023.
[Chung et al., 2014] Junyoung Chung,
Caglar Gulcehre,
et al.
Empirical evaluation of gated recurrent neural
networks
on
sequence
modeling.
arXiv
preprint
arXiv:1412.3555, 2014.
[Devlin et al., 2018] Jacob Devlin, Ming-Wei Chang, et al.
Bert:
Pre-training of deep bidirectional transform-
ers
for
language
understanding.
arXiv
preprint
arXiv:1810.04805, 2018.
[Ganguli et al., 2022] Deep Ganguli, Liane Lovitt, et al. Red
teaming language models to reduce harms:
Methods,
scaling behaviors, and lessons learned.
arXiv preprint
arXiv:2209.07858, 2022.
[Han et al., 2023] Yikun Han, Chunjiang Liu, et al.
A
comprehensive survey on vector database:
Storage
and retrieval technique,
challenge.
arXiv preprint
arXiv:2310.11703, 2023.
[He et al., 2016] Kaiming He, Xiangyu Zhang, et al. Deep
residual learning for image recognition. In CVPR, pages
770–778, 2016.
[Huang et al., 2023] Lei Huang, Weijiang Yu, et al. A survey
on hallucination in large language models: Principles,
taxonomy, challenges, and open questions. arXiv preprint
arXiv:2311.05232, 2023.
[Izacard et al., 2022] Gautier Izacard, Lewis Patrick, et al.
Atlas:
Few-shot learning with retrieval augmented
language models. arXiv preprint arXiv:2208.03299, 2022.
[J´egou et al., 2011] Herv´e J´egou, Matthijs Douze, et al.
Product Quantization for Nearest Neighbor Search.
TPAMI, 33(1):117–128, 2011.
[Ji et al., 2023] Ziwei Ji, Nayeon Lee, et al.
Survey of
hallucination in natural language generation.
ACM
Computing Surveys, 55(12):1–38, 2023.
[Jiang et al., 2023] Zhengbao Jiang, Frank F Xu, et al.
Active retrieval augmented generation.
arXiv preprint
arXiv:2305.06983, 2023.
[Kaack et al., 2022] Lynn H Kaack, Priya L Donti, et al.
Aligning
artificial
intelligence
with
climate
change
mitigation. Nature Climate Change, 12:518–527, 2022.
[Kang and Kwak, 2023] Minki Kang and Jin M Kwak.
Knowledge
graph-augmented
language
models
for
knowledge-grounded dialogue generation. arXiv preprint
arXiv:2305.18846, 2023.
[Kaplan et al., 2020] Jared Kaplan, Sam McCandlish, et al.
Scaling laws for neural language models. arXiv preprint
arXiv:2001.08361, 2020.
[Kemker et al., 2017] Ronald Kemker, Marc McClure, et al.
Measuring catastrophic forgetting in neural networks.
arXiv preprint arXiv:1708.0207, 2017.
[Khandelwal et al., 2020] Urvashi Khandelwal, Levy Omer,
et al.
Generalization through memorization:
Nearest
neighbor language models, 2020.
[Koh et al., 2023] Jing Yu Koh, Ruslan Salakhutdinov, et al.
Grounding language models to images for multimodal
inputs and outputs. In ICML, 2023.
[Lee et al., 2022] Katherine Lee, Daphne Ippolito, et al.
Deduplicating training data makes language models better.
In ACL, pages 8424–8445, 2022.
[Li et al., 2023a] Haoran Li, Yulin Chen, et al.
Privacy
in large language models: Attacks, defenses and future
directions. arXiv preprint arXiv:2310.10383, 2023.
[Li et al., 2023b] Junnan Li Li, Dongxu Li, et al.
Blip-
2: Bootstrapping language-image pre-training with frozen
image encoders and large language models. arXiv preprint
arXiv:2301.12597, 2023.
[Lin et al., 2022] Stephanie Lin, Jacob Hilton, and Owain
Evans. TruthfulQA: Measuring how models mimic human
falsehoods. In Smaranda Muresan, Preslav Nakov, et al.,
editors, ACL, pages 3214–3252, 2022.
[Luo et al., 2023] Yun Luo, Zhen Yang, et al.
An empir-
ical study of catastrophic forgetting in large language
models during continual fine-tuning.
arXiv preprint
arXiv:2308.08747, 2023.
[Malkov and Yashunin, 2018] Yury A Malkov and Dmitry A
Yashunin.
Efficient and Robust Approximate Nearest
Neighbor Search Using Hierarchical Navigable Small
World Graphs. PAMI, 42(4):824–836, 2018.

---

[Modarressi et al., 2023] Ali Modarressi,
Ayyoob Imani,
et al. Ret-llm: Towards a general read-write memory for
large language models. arXiv preprint arXiv:2305.14322,
2023.
[Muja and Lowe, 2009] Marius Muja and David G Lowe.
Fast Approximate Nearest Neighbors with Automatic
Algorithm Configuration.
In VISAPP, pages 331–340,
2009.
[Musser, 2023] Micah Musser. A cost analysis of generative
language models and influence operations. arXiv preprint
arXiv:2308.03740, 2023.
[Narayanan Venkit et al., 2023] Pranav Narayanan Venkit,
Sanjana Gautam, et al. Nationality bias in text generation.
In EACL, pages 116–122, 2023.
[Nishikawa et al., 2022] Sosuke Nishikawa,
Ryokan Ri,
et al. EASE: Entity-aware contrastive learning of sentence
embedding. In NAACL, pages 3870–3885, 2022.
[Onoe et al., 2022] Yasumasa Onoe, Michael Zhang, et al.
Entity cloze by date:
What LMs know about unseen
entities. In NAACL Findings, pages 693–702, 2022.
[Pan et al., 2023] James Jie Pan, Jianguo Wang, et al. Survey
of vector database management systems. arXiv preprint
arXiv:2310.14021, 2023.
[Penedo et al., 2023] Guilherme Penedo, Quentin Malartic,
et al. The refinedweb dataset for falcon llm: Outperform-
ing curated corpora with web data, and web data only.
arXiv preprint arXiv:2306.01116, 2023.
[Radford et al., 2019] Alec Radford,
Jeffrey Wu,
et al.
Language models are unsupervised multitask learners.
OpenAI Blog, 1(8):9, 2019.
[Raffel et al., 2020] Colin Raffel, Noam Shazeer, et al.
Exploring the limits of transfer learning with a unified text-
to-text transformer. JMLR, 21(1):5485–5551, 2020.
[Ram et al., 2023] Ori Ram, Yoav Levine, et al. In-context
retrieval-augmented language models.
TACL, 11:1316–
1331, 2023.
[Sanca and Ailamaki, 2023] Viktor Sanca and Anastasia
Ailamaki. E-scan: Consuming contextual data with model
plugins. In VLDB Workshop, 2023.
[Schwartz et al., 2020] Roy Schwartz, Jesse Dodge, et al.
Green ai. Commun. ACM, 63(12):54–63, 2020.
[Shi et al., 2015] Xingjian Shi,
Zhourong Chen,
et al.
Convolutional lstm network: A machine learning approach
for precipitation nowcasting. In NeurIPS, 2015.
[Shu et al., 2023] Yu Shu, Siwei Dong, et al.
Llasm:
Large language and speech model.
arXiv preprint
arXiv:2308.15930, 2023.
[Strubell et al., 2019] Emma Strubell, Ananya Ganesh, et al.
Energy and policy considerations for deep learning in nlp.
arXiv preprint arXiv:1906.02243, 2019.
[Tao et al., 2009] Yufei Tao, Ke Yi, et al.
Quality and
efficiency in high dimensional nearest neighbor search. In
SIGMOD, page 563–576, 2009.
[Touvron et al., 2023] Hugo Touvron, Thibaut Lavril, et al.
Llama: Open and efficient foundation language models.
arXiv preprint arXiv:2302.13971, 2023.
[Vaswani et al., 2017] Ashish Vaswani, Noam Shazeer, et al.
Attention is all you need. In NeurIPS, 2017.
[Wang and et al., 2023] Mengzhao Wang and Xiangyu Ke
et al.
Must: An effective and scalable framework for
multimodal search of target modality.
arXiv preprint
arXiv:2312.06397, 2023.
[Wang et al., 2021] Jianguo Wang, Xiaomeng Yi, et al.
Milvus: A purpose-built vector data management system.
In SIGMOD, pages 2614–2627, 2021.
[Wei et al., 2022] Jason Wei, Yi Tay, et al.
Emergent
abilities of large language models.
arXiv preprint
arXiv:2206.07682, 2022.
[Wu and Raghavendra, 2022] Carole J. Wu and Ramya oth-
ers Raghavendra.
Sustainable ai:
Environmental
implications, challenges and opportunities.
In MLSys,
pages 795–813, 2022.
[Wu et al., 2022] Felix
Wu,
Kwangyoun
Kim,
et
al.
Wav2seq:
Pre-training speech-to-text encoder-decoder
models
using
pseudo
languages.
arXiv
preprint
arXiv:2205.01086, 2022.
[Wynsberghe, 2021] Almee V Wynsberghe. Sustainable ai:
Ai for sustainability and the sustainability of ai. AI Ethics,
1:213–218, 2021.
[Xin et al., 2023] Cheng Xin, Luo Di, et al. Lift yourself up:
Retrieval-augmented text generation with self memory.
arXiv preprint arXiv:2305.02437, 2023.
[Yang et al., 2023] Antoine Yang, Arsha Nagrani, et al.
Vid2seq:
Large-scale pretraining of a visual language
model for dense video captioning.
arXiv preprint
arXiv:2302.14115, 2023.
[Yao et al., 2023] Yunzhi Yao, Peng Wang, et al.
Editing
large language models: Problems, methods, and opportu-
nities. arXiv preprint arXiv:2305.13172, 2023.
[Yosinski et al., 2014] Jason Yosinski, Jeff Clune, et al. How
transferable are features in deep neural networks?
In
NeurIPS, 2014.
[Yu et al., 2023] Wenhao Yu, Dan Iter, et al. Generate rather
than retrieve: Large language models are strong context
generators. arXiv preprint arXiv:2209.10063, 2023.
[Zaremba et al., 2014] Wojciech Zaremba, Ilya Sutskever,
et al.
Recurrent neural network regularization.
arXiv
preprint arXiv:1409.2329, 2014.
[Zhang et al., 2023a] Chenshuang Zhang, Chaoning Zhang,
et al. Text-to-image diffusion models in generative ai: A
survey. arXiv preprint arXiv:2303.07909, 2023.
[Zhang et al., 2023b] Yi Zhang, Zhongyang Yu, et al. Long-
term memory for large language models through topic-
based vector database. In IALP, pages 258–264, 2023.

---

