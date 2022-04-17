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
tax_data_next100_with_col = pd.read_csv('vt_tax_data_2016.csv',																	nrows=100,
					skiprows=100,
					header=None,
					names=col_names)
```
*Assigning column name of load*

We can use a filter function like we did with `usecols` to have a custom filter. The below code reads the top 100 rows that are not multiple of 3. It skips rows that are multiple of 3 like 3, 6, 9,... until the total number of rows reach 100.

```python
# read first 100 rows that are not multiple of 3 
tax_data_mod3 = pd.read_csv('vt_tax_data_2016.csv',
			    nrows=100,
			    skiprows=lambda row : r % 3)
```
*Applying callback of `skiprows`*

### Handling errors and missing data

Importing data with the ways we saw above is enough to work on the data if the data is in great shape. But how to handle when the data is missing values or the is error while importing due to corrupted rows.

Common flat file import issues are:

- Column data types are wrong
- Missing value with custom designators
- Corrupted rows in file

**Specifying data types**

Pandas automatically infer column data types. Some times it infer incorrectly. When this happen we can manually give data type for columns at the time of loading.

```python
tax_data = pd.read_csv('vt_tax_data_2016.csv')
print(tax_data.dtypes)

#output
STATEFIPS     int64
STATE        object
zipcode       int64 # zipcode is integer type
agi_stub      int64
N1            int64
              ...  
A85300        int64
N11901        int64
A11901        int64
N11902        int64
A11902        int64
```
*Print out dtypes of a DataFrame*

Pandas infer data type of *zipcode* to be an integer. *zipcode* should be a string type. We can use `dtype` to tell pandas columns data type. It accept a dictionary of column names with their corresponding data type.

```python
# tell pandas the data type for zipcode column is string
tax_data = pd.read_csv('vt_tax_data_2016.csv', dtype={'zipcode': str})
print(tax_data.dtypes)

#output
STATEFIPS     int64
STATE        object
zipcode      object # zipcode is object type, which is pandas' counterpart to python str
agi_stub      int64
N1            int64
              ...  
A85300        int64
N11901        int64
A11901        int64
N11902        int64
A11902        int64
```
*Set data type of columns with dtype*

**Customizing missing data values**

Pandas does a good job at tracing missing values. They are give value of NaN. Imputing this missing values easy in pandas but what happens when missing values have already been imputed with dummy datas?

```python
# select and print only *STATEFIPS*, *STATE*, *zipcode*, *agi_stub* columns
print(tax_data[['STATEFIPS', 'STATE', 'zipcode', 'agi_stub']])

# output
     STATEFIPS	STATE	zipcode	agi_stub
0	          50	   VT	      0	       1 # dummy zipcode value
1	          50	   VT	      0	       2
2	          50	   VT	      0	       3
3	          50	   VT	      0	       4
4	          50	   VT	      0	       5
...	       ...	  ...	   ...	      ...
1471	          50	   VT	  99999	       2
1472	          50	   VT	  99999	       3
1473	          50	   VT	  99999	       4
1474	          50	   VT	  99999	       5
1475	          50	   VT	  99999	       6
```
*Explore for dummy values in tax_data*

If we know the values of the dummy datas then we can let pandas know the dummy datas are missing values and to be treated as NaN. Pandas will load the dummy datas as NaN values.

Here *zipcode* with `0` values are missing values. We know `0` is a dummy value, a placeholder for missing values. By using `na_values` argument we can tell pandas `0` is a dummy data in *zipcode* column and all `0` values in *zipcode* should be convert to NaN. It accept a dictionary of column names with dummy values.

```python
# all 0 values in *zipcode should* be NaN
tax_data = pd.read_csv('vt_tax_data_2016.csv',
		       dtype={'zipcode': str},
		       na_values={'zipcode': 0})

print(tax_data[['STATEFIPS', 'STATE', 'zipcode', 'agi_stub']])

# output
     STATEFIPS	STATE	zipcode	agi_stub
0	          50	   VT	    NaN	       1 # dummy value replaced by NaN
1	          50	   VT	    NaN	       2
2	          50	   VT	    NaN	       3
3	          50	   VT	    NaN	       4
4	          50	   VT	    NaN	       5
...	         ...	  ...	   ...	      ...
1471	          50	   VT	  99999	       2
1472	          50	   VT	  99999	       3
1473	          50	   VT	  99999	       4
1474	          50	   VT	  99999	       5
1475	          50	   VT	  99999	       6
```
*Impute dummy values in zipcode with NaN values*

**Lines with errors**

The data flat file might contain a missing delimiter or skip a column value in a row. Such errors will corrupt the file and pandas will raise a *ParserError* exception. Pandas has an option to skip rows where the data is corrupted and read only rows with correct format.

- `error_bad_lines` argument takes boolean and skip unparseable records.
- `warn_bad_lines` is another useful argument that takes boolean wether to show message when records are skipped.

```python
# skips error records and show a message why
tax_data = pd.read_csv('vt_tax_data_2016.csv',
		       error_bad_lines=False,
		       warn_bad_lines=True)
```
*Skip corrupted records when loading a csv*
