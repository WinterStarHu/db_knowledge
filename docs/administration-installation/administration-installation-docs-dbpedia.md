---
description: 'Dataset containing 1 million articles from Wikipedia and their vector embeddings'
sidebarTitle: 'dbpedia dataset'
slug: /getting-started/example-datasets/dbpedia-dataset
title: 'dbpedia dataset'
keywords: ['semantic search', 'vector similarity', 'approximate nearest neighbours', 'embeddings']
doc_type: 'guide'
---

The [dbpedia dataset](https://huggingface.co/datasets/Qdrant/dbpedia-entities-openai3-text-embedding-3-large-1536-1M) contains 1 million articles from Wikipedia and their vector embeddings generated using the [text-embedding-3-large](https://platform.openai.com/docs/models/text-embedding-3-large) model from OpenAI.

The dataset is an excellent starter dataset to understand vector embeddings, vector similarity search and Generative AI. We use this dataset to demonstrate [approximate nearest neighbor search](/reference/engines/table-engines/mergetree-family/annindexes) in ClickHouse and a simple but powerful Q&A application.

## Dataset details {#dataset-details}

The dataset contains 26 `Parquet` files located on [huggingface.co](https://huggingface.co/api/datasets/Qdrant/dbpedia-entities-openai3-text-embedding-3-large-1536-1M/parquet/default/train/). The files are named `0.parquet`, `1.parquet`, ..., `25.parquet`. To view some example rows of the dataset, please visit this [Hugging Face page](https://huggingface.co/datasets/Qdrant/dbpedia-entities-openai3-text-embedding-3-large-1536-1M).

## Create table {#create-table}

Create the `dbpedia` table to store the article id, title, text and embedding vector:

```sql
CREATE TABLE dbpedia
(
  id      String,
  title   String,
  text    String,
  vector  Array(Float32) CODEC(NONE)
) ENGINE = MergeTree ORDER BY (id);

```

## Load table {#load-table}

To load the dataset from all Parquet files, run the following shell command:

```shell
for i in $(seq 0 25); do
  echo "Processing file ${i}..."
  clickhouse client -q "INSERT INTO dbpedia SELECT _id, title, text, \"text-embedding-3-large-1536-embedding\" FROM url('https://huggingface.co/api/datasets/Qdrant/dbpedia-entities-openai3-text-embedding-3-large-1536-1M/parquet/default/train/${i}.parquet') SETTINGS max_http_get_redirects=5,enable_url_encoding=0;"
  echo "File ${i} complete."
done
```

Alternatively, individual SQL statements can be run as shown below to load each of the 25 Parquet files:

```sql
INSERT INTO dbpedia SELECT _id, title, text, "text-embedding-3-large-1536-embedding" FROM url('https://huggingface.co/api/datasets/Qdrant/dbpedia-entities-openai3-text-embedding-3-large-1536-1M/parquet/default/train/0.parquet') SETTINGS max_http_get_redirects=5,enable_url_encoding=0;
INSERT INTO dbpedia SELECT _id, title, text, "text-embedding-3-large-1536-embedding" FROM url('https://huggingface.co/api/datasets/Qdrant/dbpedia-entities-openai3-text-embedding-3-large-1536-1M/parquet/default/train/1.parquet') SETTINGS max_http_get_redirects=5,enable_url_encoding=0;
...
INSERT INTO dbpedia SELECT _id, title, text, "text-embedding-3-large-1536-embedding" FROM url('https://huggingface.co/api/datasets/Qdrant/dbpedia-entities-openai3-text-embedding-3-large-1536-1M/parquet/default/train/25.parquet') SETTINGS max_http_get_redirects=5,enable_url_encoding=0;

```

Verify that 1 million rows are seen in the `dbpedia` table:

```sql
SELECT count(*)
FROM dbpedia
```

```response
   ┌─count()─┐
1. │ 1000000 │
   └─────────┘
```

## Semantic search {#semantic-search}

Recommended reading: ["Vector embeddings " OpenAPI guide](https://platform.openai.com/docs/guides/embeddings)

Semantic search (also referred to as _similarity search_) using vector embeddings involves the following steps:

- Accept a search query from a user in natural language e.g _"Tell me about some scenic rail journeys”_, _“Suspense novels set in Europe”_ etc
- Generate embedding vector for the search query using the LLM model
- Find nearest neighbours to the search embedding vector in the dataset

The _nearest neighbours_ are documents, images or content that are results relevant to the user query.
The retrieved results are the key input to Retrieval Augmented Generation (RAG) in Generative AI applications.

## Run a brute-force vector similarity search {#run-a-brute-force-vector-similarity-search}

KNN (k - Nearest Neighbours) search or brute force search involves calculating the distance of each vector in the dataset to the search embedding vector and then ordering the distances to get the nearest neighbours.  With the `dbpedia` dataset, a quick technique to visually observe semantic search is to use embedding vectors from the dataset itself as search vectors. For example:

```sql title="Query"
SELECT id, title
FROM dbpedia
ORDER BY cosineDistance(vector, ( SELECT vector FROM dbpedia WHERE id = '') ) ASC
LIMIT 20
```

```response title="Response" highlight={23}
    ┌─id────────────────────────────────────────┬─title───────────────────────────┐
 1. │           │ The Remains of the Day          │
 2. │    │ The Remains of the Day (film)   │
 3. │          │ Never Let Me Go (novel)         │
 4. │                      │ Last Orders                     │
 5. │                   │ The Unconsoled                  │
 6. │                │ The Hours (novel)               │
 7. │  │ An Artist of the Floating World │
 8. │                    │ Heat and Dust                   │
 9. │             │ A Pale View of Hills            │
10. │               │ Howards End (film)              │
11. │             │ When We Were Orphans            │
12. │        │ A Passage to India (film)       │
13. │            │ Memoirs of a Survivor           │
14. │                │ The Child in Time               │
15. │                 │ The Sea, the Sea                │
16. │               │ The Master (novel)              │
17. │                     │ The Memorial                    │
18. │                 │ The Hours (film)                │
19. │             │ Human Remains (film)            │
20. │                   │ Kazuo Ishiguro                  │
    └───────────────────────────────────────────┴─────────────────────────────────┘
20 rows in set. Elapsed: 0.261 sec. Processed 1.00 million rows, 6.22 GB (3.84 million rows/s., 23.81 GB/s.)
```

Note down the query latency so that we can compare it with the query latency of ANN (using vector index).
Also record the query latency with cold OS file cache and with `max_threads=1` to recognize the real compute usage and storage bandwidth usage (extrapolate it to a production dataset with millions of vectors!)

## Build a vector similarity index {#build-vector-similarity-index}

Run the following SQL to define and build a vector similarity index on the `vector` column:

```sql
ALTER TABLE dbpedia ADD INDEX vector_index vector TYPE vector_similarity('hnsw', 'cosineDistance', 1536, 'bf16', 64, 512);

ALTER TABLE dbpedia MATERIALIZE INDEX vector_index SETTINGS mutations_sync = 2;
```

The parameters and performance considerations for index creation and search are described in the [documentation](/reference/engines/table-engines/mergetree-family/annindexes).

Building and saving the index could take a few minutes depending on number of CPU cores available and the storage bandwidth.

## Perform ANN search {#perform-ann-search}

_Approximate Nearest Neighbours_ or ANN refers to group of techniques (e.g., special data structures like graphs and random forests) which compute results much faster than exact vector search. The result accuracy is typically "good enough" for practical use. Many approximate techniques provide parameters to tune the trade-off between the result accuracy and the search time.

Once the vector similarity index has been built, vector search queries will automatically use the index:

```sql title="Query"
SELECT
    id,
    title
FROM dbpedia
ORDER BY cosineDistance(vector, (
        SELECT vector
        FROM dbpedia
        WHERE id = ''
    )) ASC
LIMIT 20
```

```response title="Response" highlight={23}
    ┌─id──────────────────────────────────────────────┬─title─────────────────────────────────┐
 1. │                        │ Glacier Express                       │
 2. │                       │ BVZ Zermatt-Bahn                      │
 3. │                     │ Gornergrat railway                    │
 4. │                           │ RegioExpress                          │
 5. │               │ Matterhorn Gotthard Bahn              │
 6. │                       │ Rhaetian Railway                      │
 7. │                       │ Gotthard railway                      │
 8. │                  │ Furka–Oberalp railway                 │
 9. │                       │ Jungfrau railway                      │
10. │                 │ Monte Generoso railway                │
11. │      │ Montreux–Oberland Bernois railway     │
12. │                 │ Brienz–Rothorn railway                │
13. │  │ Lauterbrunnen–Mürren mountain railway │
14. │    │ Luzern–Stans–Engelberg railway line   │
15. │                          │ Rigi Railways                         │
16. │       │ Saint-Gervais–Vallorcine railway      │
17. │                        │ Gatwick Express                       │
18. │                    │ Brünig railway line                   │
19. │                       │ Regional-Express                      │
20. │                │ Schynige Platte railway               │
    └─────────────────────────────────────────────────┴───────────────────────────────────────┘
20 rows in set. Elapsed: 0.025 sec. Processed 32.03 thousand rows, 2.10 MB (1.29 million rows/s., 84.80 MB/s.)
```

## Generating embeddings for search query {#generating-embeddings-for-search-query}

The similarity search queries seen until now use one of the existing vectors in the `dbpedia` table as the search vector. In real world applications, the search vector has to be generated for a user input query which could be in natural language. The search vector should be generated by using the same LLM model used to generate embedding vectors for the dataset.

An example Python script is listed below to demonstrate how to programmatically call OpenAI API's to generate embedding vectors using the `text-embedding-3-large` model. The search embedding vector is then passed as an argument to the `cosineDistance()` function in the `SELECT` query.

Running the script requires an OpenAI API key to be set in the environment variable `OPENAI_API_KEY`.
The OpenAI API key can be obtained after registering at https://platform.openai.com.

```python
import sys
from openai import OpenAI
import clickhouse_connect

ch_client = clickhouse_connect.get_client(compress=False) # Pass ClickHouse credentials
openai_client = OpenAI() # Set OPENAI_API_KEY environment variable

def get_embedding(text, model):
  text = text.replace("\n", " ")
  return openai_client.embeddings.create(input = [text], model=model, dimensions=1536).data[0].embedding

while True:
    # Accept the search query from user
    print("Enter a search query :")
    input_query = sys.stdin.readline();

    # Call OpenAI API endpoint to get the embedding
    print("Generating the embedding for ", input_query);
    embedding = get_embedding(input_query,
                              model='text-embedding-3-large')

    # Execute vector search query in ClickHouse
    print("Querying clickhouse...")
    params = {'v1':embedding, 'v2':10}
    result = ch_client.query("SELECT id,title,text FROM dbpedia ORDER BY cosineDistance(vector, %(v1)s) LIMIT %(v2)s", parameters=params)

    for row in result.result_rows:
        print(row[0], row[1], row[2])
        print("---------------")
```

## Q&A demo application {#q-and-a-demo-application}

The examples above demonstrated semantic search and document retrieval using ClickHouse. A very simple but high potential generative AI example application is presented next.

The application performs the following steps:

1. Accepts a _topic_ as input from the user
2. Generates an embedding vector for the _topic_ by invoking OpenAI API with model `text-embedding-3-large`
3. Retrieves highly relevant Wikipedia articles/documents using vector similarity search on the `dbpedia` table
4. Accepts a free-form question in natural language from the user relating to the _topic_
5. Uses the OpenAI `gpt-3.5-turbo` Chat API to answer the question based on the knowledge in the documents retrieved in step #3.
The documents retrieved in step #3 are passed as _context_ to the Chat API and are the key link in Generative AI.

A couple of conversation examples by running the Q&A application are first listed below, followed by the code for the Q&A application. Running the application requires an OpenAI API key to be set in the environment variable `OPENAI_API_KEY`. The OpenAI API key can be obtained after registering at https://platform.openai.com.

```shell
$ python3 QandA.py

Enter a topic : FIFA world cup 1990
Generating the embedding for 'FIFA world cup 1990' and collecting 100 articles related to it from ClickHouse...

Enter your question : Who won the golden boot
Salvatore Schillaci of Italy won the Golden Boot at the 1990 FIFA World Cup.

Enter a topic : Cricket world cup
Generating the embedding for 'Cricket world cup' and collecting 100 articles related to it from ClickHouse...

Enter your question : Which country has hosted the world cup most times
England and Wales have hosted the Cricket World Cup the most times, with the tournament being held in these countries five times - in 1975, 1979, 1983, 1999, and 2019.

$
```

Code:

```Python
import sys
import time
from openai import OpenAI
import clickhouse_connect

ch_client = clickhouse_connect.get_client(compress=False) # Pass ClickHouse credentials here
openai_client = OpenAI() # Set the OPENAI_API_KEY environment variable

def get_embedding(text, model):
  text = text.replace("\n", " ")
  return openai_client.embeddings.create(input = [text], model=model, dimensions=1536).data[0].embedding

while True:
    # Take the topic of interest from user
    print("Enter a topic : ", end="", flush=True)
    input_query = sys.stdin.readline()
    input_query = input_query.rstrip()

    # Generate an embedding vector for the search topic and query ClickHouse
    print("Generating the embedding for '" + input_query + "' and collecting 100 articles related to it from ClickHouse...");
    embedding = get_embedding(input_query,
                              model='text-embedding-3-large')

    params = {'v1':embedding, 'v2':100}
    result = ch_client.query("SELECT id,title,text FROM dbpedia ORDER BY cosineDistance(vector, %(v1)s) LIMIT %(v2)s", parameters=params)

    # Collect all the matching articles/documents
    results = ""
    for row in result.result_rows:
        results = results + row[2]

    print("\nEnter your question : ", end="", flush=True)
    question = sys.stdin.readline();

    # Prompt for the OpenAI Chat API
    query = f"""Use the below content to answer the subsequent question. If the answer cannot be found, write "I don't know."

Content:
\"\"\"
{results}
\"\"\"

Question: {question}"""

    GPT_MODEL = "gpt-3.5-turbo"
    response = openai_client.chat.completions.create(
        messages=[
        {'role': 'system', 'content': "You answer questions about {input_query}."},
        {'role': 'user', 'content': query},
       ],
       model=GPT_MODEL,
       temperature=0,
    )

    # Print the answer to the question!
    print(response.choices[0].message.content)
    print("\n")
```
