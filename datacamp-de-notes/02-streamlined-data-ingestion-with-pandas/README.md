# Streamlined Data Ingestion with Pandas

*This course is all about acquiring data form various sources such as spreadsheet, database, API... for analysis. We will use pandas to build pipeline to import data kept in common storage format.*

## Importing Data from Flat Files

### Introduction to flat files

Flat files are unformatted text files commonly used for data exchanges. Spreadsheets and databases use flat files to export and exchange data. In flat files a line represent a row and comma separated values are column values. The separator is called a delimiter. Other delimiters can be used to specify column values. 

Pandas a special tabular data structure to hold two-dimensional datas. It is called DataFrame. DataFrame has rows and columns. Pandas provide a functionality to load flat files.

```python
import pandas as pd

df = pd.read_csv('path_to_csv/data.csv') # read csv as a dataframe
df.head(4) # print top 4 rows
```
*Streamlined Data Ingestion with Pandas*


To read flat files with delimiter other than `,`

```python
import pandas as pd

df = pd.read_csv('path_to_csv/data.tsv', sep='\t') # read flat file separated by tabs
df.head(4) # print top 4 rows
```
*Streamlined Data Ingestion with Pandas*

See [read_csv](https://pandas.pydata.org/docs/reference/api/pandas.read_csv.html) to get possible values of sep.

### ****Modifying flat file imports****
