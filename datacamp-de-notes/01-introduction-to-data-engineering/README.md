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


💡 Data warehouses mostly use [star schema](https://en.wikipedia.org/wiki/Star_schema). Star schema consists of one or more [fact table](https://en.wikipedia.org/wiki/Fact_table) that are referencing any number of [dimension tables](https://en.wikipedia.org/wiki/Dimension_table).

> Facts: things that happened (eg. Product order)

> Dimension: information on the world (eg. Customer information)

### Parallel computing

When dealing with big data **memory inefficiency** and **computational power** is a big bottle neck. To resolve this we split the data into multiple sections and perform the computation in multiple computers. By running the task on multiple computes we increase our processing power and most of all we reduce the memory footprint.

Parallel computing has an overhead of communication between processes. Thus, to leverage from parallel computing the data should be big or the task is intensive.

💡 [Parallel slowdown](https://en.wikipedia.org/wiki/Parallel_slowdown): parallelization of a program beyond a certain point causes the program to run slower. Typically this happens when more processing node are added and communication among processes take more time than useful processing.

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

### Extract

Data is extracted from persistence storage like file, databases and api to memory where it is suitable for processing.

File can be
- Unstructured data like plain text
- Flat files, eg. `.csv`
- Semi structured data json

Most APIs use json to communicate data. Json has 4 atomic type: *number*, *string*, *boolean* & *null* and two composite types: *array* and *object.*

```python
import json

result = json.loads('{"key": "value"}')
print(result['key'])

# output value
```

The most common persistence storage is database. There are two kind of databases:

**Application databases**
- Optimized for lots of transactions
- Transactions are inserting or updating a row
- Row oriented, data are insert per row
- OLTP: online transaction processing

**Analytical databases**
- Optimized for analysis
- Aggregate queries
- Column oriented
- OLAP: online analytical processing

Database require a connection string to access them

💡 `postgresql://[user[:password]@][host][:port]`

To fetch from a database return the result in pandas DataFrame

```python
connection_uri = 'postgresql://username:password@localhost:5432/database'
db_engine = sqlalchemy.create_engine(connection_uri)

query = "SELECT * FROM tableName"
table_df = pd.read_sql(query, db_engine)
```
*Load stringify json*

### Transform

Performing a task process on the extracted data. This can include:

- selecting of attribute
- Translation of values
- Data validation, cleaning data
- Aggregation
- Splitting column into multiple columns
- Join from multiple sources...

### Loading

After transforming process we want to load/store the data to a database to perform different tasks on it at a later time. Mostly at the end of an ETL analytical databases are targeted to store the transformed data. 

Although **application databases** are fast to push rows of values in, they are not suitable for fast retrieval of big data and parallel processing. 

Being able to query subset of columns makes analytical(column-oriented) databases fit for parallel processing. Since application databases is row oriented, it would have to skip columns of unused rows.

**MPP Databases**

*Massively parallel processing databases*

Where queries are performed on multiple computing nodes in parallel. It can be setup with a **shared nothing** or **shared disk architecture** but it is mostly setup with **shared nothing architecture.**

Some example of MPP databases are: AWS Redshift, BigQuery, Azure SQL Data Warehouse

Let’s see a use case on AWS redshift.

Typically MPP databases read columnar storage format from storage bucket. Incase of redshift commonly the data is stored in S3 as a columnar format, commonly as parquet and then we connect redshift and copy the data.

  

```python
# Writing data to parquet in pandas
df.to_parquet('s3-path/data.parquet')
# Writing data to parquet in pyspark
df.write.parquet('s3-path/data.parquet')
```
*Loading data in parquet format*

```sql
COPY data
FROM 's3-path/data.parquet'
FORMAT AS parquet
```
*Copy the data over to redshift*

Often we need to load transformed data to application databases such as PostgreSQL. We can easily do that using pandas `to_sql()` method.

```python
df.to_sql('table_name',
          db_engine,
	  schema='store',
	  if_exists='replace')
```
*store DataFrame to table_name for specified database and it table exist replace it.*

**Insert data to postgreSQL from pandas**

```python
# Finish the connection URI
connection_uri = "postgresql://repl:password@localhost:5432/dwh"
db_engine_dwh = sqlalchemy.create_engine(connection_uri)

# Transformation step, join with recommendations data
film_pdf_joined = film_pdf.join(recommendations)

# Finish the .to_sql() call to write to store.film
film_pdf_joined.to_sql("film", db_engine_dwh, schema="store", if_exists="replace")

# Run the query to fetch the data
pd.read_sql("SELECT film_id, recommended_film_ids FROM store.film", db_engine_dwh)
```
*Connect with postgreSQL and store DataFrame data to a table.*
