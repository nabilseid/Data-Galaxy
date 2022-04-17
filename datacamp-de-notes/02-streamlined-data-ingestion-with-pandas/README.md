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

### Modifying flat file imports

When working with a big flat file you might want to take portion of the data and make it easier to work with. This will reduce your memory usage and make the data easier to scan through.

We can segment the data vertical by specifying column names or horizontally by specifying rows.

Let’s use [Vermont tax return data by ZIP code](https://assets.datacamp.com/production/repositories/4412/datasets/61bb27bf939aac4344d4f446ce6da1d1bf534174/vt_tax_data_2016.csv) and take only portion of it we want to work with.

 

```python
tax_data = pd.read_csv('vt_tax_data_2016.csv')
print(tax_data.shape)

# output
(1476, 147)
```
*Read and print dimension of the data*

This data 1476 x 147 which a small data by today’s standard. 147 columns can be a lot for us to work with this data so what we want to do is take only the columns we want to work with.

**Limiting Columns**

To limit columns we use `usecols` keyword argument. It accepts a list of column numbers or names, or callable filter function.


```python
col_names = ['STATEFIPS', 'STATE', 'zipcode', 'agi_stub']
col_nums = [0, 1, 2, 3]
col_2n = lambda col : len(col) == 2
# Load columns by names
tax_data_v1 = pd.read_csv('vt_tax_data_2016.csv', usecols=col_names)
# Load columns by number
tax_data_v2 = pd.read_csv('vt_tax_data_2016.csv', usecols=col_nums)
# Load columns by filter callback function
tax_data_v3 = pd.read_csv('vt_tax_data_2016.csv', usecols=col_2n)
```
*Read and print dimension of the data*

To load columns by name we have to know column names in advance. The order of names or numbers is ignored. The filter function only loads columns with are two character long. We can do more complex filtering on column names to select specific columns.

**Limiting Rows**

We have seen how to load selected columns, let’s see how we can select specific rows.

To select rows use use `nrows`keyword argument. It takes an integer and it takes the top n rows. It can be useful to read piece of a large file. `nrows` comes handy when used with `skiprows` . `skiprows` accepts row numbers, number of lines to skip or a callback function.

If using `skiprows` will skip the column row, we have to specify `header=None` so pandas know there are no columns.

```python
# read first 100 rows
tax_data_first100 = pd.read_csv('vt_tax_data_2016.csv', nrows=100)
# read the next 100 rows after skipping 100 rows
tax_data_next100 = pd.read_csv('vt_tax_data_2016.csv',
															 nrows=100,
															 skiprows=100,
															 header=None)
```
*Limit rows using `nrows` and `skiprows`*

To assign a column name we can use `names` argument. It accepts list of column names. The list should contain all column names. The usual way to get this is to first have the file loaded and extract column names from it using `list()` built-in function.

```python
# assign column name
col_names = list(tax_data_first100)
tax_data_next100_with_col = pd.read_csv('vt_tax_data_2016.csv',
																				 nrows=100,
																				 skiprows=100,
																				 header=None,
																				 names=col_names)
```
*Assigning column name of load *

We can use a filter function like we did with `usecols` to have a custom filter. The below code reads the top 100 rows that are not multiple of 3. It skips rows that are multiple of 3 like 3, 6, 9,... until the total number of rows reach 100.

```python
# read first 100 rows that are not multiple of 3 
tax_data_mod3 = pd.read_csv('vt_tax_data_2016.csv',
														nrows=100,
														skiprows=lambda row : r % 3)
```
*Applying callback of `skiprows`*
