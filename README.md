# Intro To Data Engineering

## What is data engineering

- Gather data from different sources: ingest data
- Optimize database for analysis: make fetching query fast
- Remove corrupt data

**DE are masters in databases.**  
**Processing large amount of data using cluster of machines.**
- To remove corrupt data, to aggregate or to join data
- Know the to abstraction of processing tools and know their limitations

**Scheduling tools to run jobs at a specific interval**  

### Existing tools  

| Database | Processing | Scheduling |
| --- | --- | --- |
| MySQL | Spark | Airflow |
| PostgreSQL | Hive | oozie |
| | | Cron |

**A data pipeline**

collect data from different source → process it → load it to an analytics data warehouse  

### **Cloud computing**
- Cost efficient
- Database reliability

They provide
- Storage
- Store unstructured data
- Computation
- Setup a virtual machine and use it as you wish
- Databases

## Data engineering toolbox

### Databases
- Store large amount of structured/organized data for fast retrieval. Database schema define the structure and relation of the database.
- Files on the other hand are unstructured data and are not as optimized for search as databases.
- Json structure are semi structured data and stored in NoSQL databases. NoSQL databases can be structured or unstructured.


<aside>

💡 Data warehouses mostly use [star schema](https://en.wikipedia.org/wiki/Star_schema). Star schema consists of one or more [fact table](https://en.wikipedia.org/wiki/Fact_table) that are referencing any number of [dimension tables](https://en.wikipedia.org/wiki/Dimension_table).
</aside>

Facts: things that happened (eg. Product order)
Dimension: information on the world (eg. Customer information)

### Parallel computing

When dealing with big data **memory inefficiency** and **computational power** is a big bottle neck. To resolve this we split the data into multiple sections and perform the computation in multiple computers. By running the task on multiple computes we increase our processing power and most of all we reduce the memory footprint.

Parallel computing has an overhead of communication between processes. Thus, to leverage from parallel computing the data should be big or the task is intensive.

<aside>

💡 [Parallel slowdown](https://en.wikipedia.org/wiki/Parallel_slowdown): parallelization of a program beyond a certain point causes the program to run slower. Typically this happens when more processing node are added and communication among processes take more time than useful processing.
</aside>

> Use parallel computing if - memory and computation is an issue
> Use multithreading if I/O is an issue

### Parallel computing frameworks

`Hadoop` - contains **HDFS** and **MapReducer**
`Hive` - created to address some of the issue of MapReducer
`Spark` - perform data processing on memory, avoid disk writes

### Workflow scheduling framework

  

`Cron` - a bash based scheduler
`Luigi` - created by Spotify
`Airflow` - created by Airbnb based on DAG and later joined the Apache foundations

## Extract, Transform and Load (ETL)
