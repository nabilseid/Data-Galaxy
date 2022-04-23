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

## **Importing Data From Excel Files**

### Introduction to spreadsheets

Spreadsheets or excels are one of the most used formats to store data. They are beings used everywhere. Data is stored tabular cells arranged in rows and columns. Spreadsheets can have formatting and formula to automatically update values. Multiple spreadsheets can exist in a workbook.

Using `read_excel()` we can load spreadsheet to a pandas DataFrame. `read_excel()` is very similar with `read_csv()`. They share most of the argument keywords. 

If it is your first time using `read_excel()`, you might face ImportError exception.

```python
ImportError: Missing optional dependency 'openpyxl'.  Use pip or conda to install openpyxl.
```

To fix this go to your terminal and run the code below. This install *openpyxl*

```bash
pip install openpyxl
```

Let’s load [fcc-new-coder-survey](https://assets.datacamp.com/production/repositories/4412/datasets/fdb113aa942a0e0ad5c155b2f04784886f0038c9/fcc-new-coder-survey.xlsx) excel and see the output

```python
# load an excel file
survey_data = pd.read_excel('fcc-new-coder-survey.xlsx')
print(survey_data.head())

# output
           FreeCodeCamp New Developer Survey Responses, 2016	       Unnamed: 1	    Unnamed: 2	       Unnamed: 3
0	   Source: https://www.kaggle.com/freecodecamp/20...	              NaN	           NaN	              NaN
1	                                                 Age	 AttendedBootcamp	BootcampFinish	BootcampLoanYesNo
2	                                                  28	                0	           NaN	              NaN
3	                                                  22	                0	           NaN	              NaN
4	                                                  19	                0	           NaN	              NaN
...	                                                 ...	              ...	           ...	              ...
997	                                                  35	                0	           NaN	              NaN
998	                                                  19	                0	           NaN	              NaN
999	                                                  25	                0	           NaN	              NaN
1000	                                                  28	                0	           NaN	              NaN
1001	                                                  39	                0	           NaN	              NaN
```

**Loading selected columns and rows**

Spreadsheets can be structured in whatever way a user wants. Row and columns can be merged together (usually to hold metadata) which disturbs the tabular format. Loading such excels in pandas will not result what you might expect. Like the above spreadsheet output. 

![Screen Shot 2022-04-17 at 5.37.12 PM.png](./assets/sheet1.png)

If you look at the first row, it contains a title and second row contains source link. We need to remove the rows for pandas to correctly parse and load the data in this spreadsheet. Like `read_csv()`, `read_excel()`has `nrows`, `skiprows`, `usecols`... In addition to column positions and names `usecols` accepts letters (e.g “A:P”).

```python
# load an excel file
survey_data = pd.read_excel('fcc-new-coder-survey.xlsx',
		 	    skiprows=2,         # skpi the first two rows
			    usecols="W:Z, AR")  # read columns from W to Z and AR
print(survey_data.head())

# output
        CommuteTime            CountryCitizen               CountryLive                    EmploymentField	  Income
0	        5.0  United States of America  United States of America  office and administrative support	  32000.0
1	        0.0  United States of America  United States of America                  food and beverage        15000.0
2	        5.0  United States of America  United States of America                            finance	  48000.0
3	        0.0  United States of America  United States of America                          education	   6000.0
```

### ****Getting data from multiple worksheets****

Spreadsheet and excel are often used exchangeable although excel can mean a workbook with multiple spreadsheets. Excel can contain tabular data, graphs or metadata. We will focus on excel with tabular data. To select which sheets to load we use `sheet_name` keyword argument. It accept sheet name, (zero-indexed) position argument or mixture of both. By default it is set to 0 which refers to the first sheet.

Our fcc-new-coder-survey.xlsx excel file has two sheets. 2016 and 2017

```python
# load the second sheet by index position
survey_data_sheet2 = pd.read_excel('fcc-new-coder-survey.xlsx', sheet_name=1)
# load the second sheet by name
survey_data_2017 = pd.read_excel('fcc-new-coder-survey.xlsx', sheet_name='2017')

print(survey_data_sheet2.equals(survey_data_2017))

# output
True
```

**Loading all sheets**

Passing sheet_name=None will load all sheet.

```python
# load all sheets
survey_data = pd.read_excel('fcc-new-coder-survey.xlsx', sheet_name=None)

print(type(survey_data))

# output
dict

survay_data_2016 = survay_data['2016']
survay_data_2017 = survay_data['2017']

print(type(survay_data_2016))
print(type(survay_data_2017))

# output
<class 'pandas.core.frame.DataFrame'>
<class 'pandas.core.frame.DataFrame'>
```

Any argument passed will be apply on each sheet load. To put the sheet together, we loop through the dict and merge the DataFrame to a common variable. In our case the two sheet has similar structure(have the same columns) so we don’t have to make them the same structure to put them together. 

```python
# load all sheets, skip the first 2 rows 
survey_data = pd.read_excel('fcc-new-coder-survey.xlsx',
                            skiprows=2,
                            sheet_name=None)

all_survey = pd.DataFrame()
# iterate thorugh dataframes in a dictionary
for sheet_name, frame in survey_data.items(): 
		# add a Year column so we know which year data is from
		frame['Year'] = sheet_name
		# add all frames to all_survey
		all_survey = all_survey.append(frame)

# get unique values in data
print(all_survey.Year.unique())

# output
['2016', '2017']
```

### ****Modifying imports: true/false data****

Booleans are true / false values. They only have two values. They come handy when dealing with tasks such as filtering. Pandas treat booleans as float values. True is 1 & false is 0. Booleans can come in different format from different sources. Let’s look at a portion of fcc survey booleans data.

![Screen Shot 2022-04-22 at 11.21.56 AM.png](./assets/sheet2.png)

The first column is id column. **AttendedBootcamp** and **BootcampLoan** columns have 0s and 1s. These boolean values are common among people with programming experience. **AttendedBootCampTF** and **LoanTF** columns ****have TRUEs and FALSEs. **AttendedBootcampYesNo** and **LoanYesNo** columns have Yeses and Noes. TRUE / False and Yes /  No values are commonly gathered from surveys. Let’s see how pandas interpret such boolean values and how we can handle them.

We are going to use [fcc-survey_booleans](https://github.com/nabilseid/Data-Galaxy/blob/main/datacamp-de-notes/02-streamlined-data-ingestion-with-pandas/fcc-survey_booleans.xlsx) data that was extracted from fcc-new-coder-survey data. Here is a sneak peek on how I genera it.

```python
# read survey data
survey_data = pd.read_excel('fcc-new-coder-survey.xlsx', skiprows=2)

# callback functions to transform 1 and 0 to True and False respectively 
callback_TF = lambda b : b if math.isnan(b) else True if b else False
# callback functions to transform 1 and 0 to Yes and No respectively
callback_YesNo = lambda b : b if math.isnan(b) else 'Yes' if b else 'No'

# generate missing columns from the survey data
survey_data['BootcampLoan'] = survey_data['BootcampLoanYesNo']
survey_data['AttendedBootcampTF'] = survey_data['AttendedBootcamp'].apply(callback_TF)
survey_data['AttendedBootcampYesNo'] = survey_data['AttendedBootcamp'].apply(callback_YesNo)
survey_data['LoanTF'] = survey_data['BootcampLoan'].apply(callback_TF)
survey_data['LoanYesNo'] = survey_data['BootcampLoan'].apply(callback_YesNo)

# load boolean columns we want to fcc-survey_booleans.xlsx
survey_data[['ID.x', 'AttendedBootcamp', 'BootcampLoan',
	     'AttendedBootcampTF', 'AttendedBootcampYesNo',
	     'LoanTF', 'LoanYesNo'] ].to_excel('fcc-survey_booleans.xlsx', index=False)
```

Now we have that sorted out, let’s experiment with the boolean data.

Pandas infer *True / False* and *1 / 0* values as float types. and *Yes / No* as object types.

```python
survey_bool = pd.read_excel('fcc-survey_booleans.xlsx')

print(survey_bool.dtypes)

# output
ID.x                      object
AttendedBootcamp         float64
BootcampLoan             float64
AttendedBootcampTF       float64
AttendedBootcampYesNo     object
LoanTF                   float64
LoanYesNo                 object
```

If we further export the data by summing the true values and check the missing data, we see that 37 attended boot camp and 14 took out a lone. 6 values are missing from boot camp attendance and 964 values are missing from boot camp loan.

```python
# print sum of true values
print(survey_bool.sum())

# output
AttendedBootcamp          37.0
BootcampLoan              14.0
AttendedBootcampTF        37.0
LoanTF                    14.0

# print sum of missing values
print(survey_bool.isna().sum())

# output
ID.x                       0
AttendedBootcamp           6
BootcampLoan             964
AttendedBootcampTF         6
AttendedBootcampYesNo      6
LoanTF                   964
LoanYesNo                964
```

As we saw pandas infer boolean values as float type, what we want is a boolean type. What if we define the boolean type explicitly.

```python
survey_bool = pd.read_excel('fcc-survey_booleans.xlsx',
			    dtype={'AttendedBootcamp': 'boolean',
				   'BootcampLoan': 'boolean',
                                   'AttendedBootcampTF': 'boolean',
                                   'AttendedBootcampYesNo': 'boolean',
                                   'LoanTF': 'boolean',
                                   'LoanYesNo': 'boolean'})

# This code in my environment setup throw an ValueError exception, pandas version: 1.3.5

# output
ValueError: 0 cannot be cast to bool
```

What the error is telling us is 0 value can not be converted to boolean type. Luckily we have `true_values` and `false_values` keyword arguments to tell pandas what values to expect as true and false.

```python
survey_bool = pd.read_excel('fcc-survey_booleans.xlsx',
			    dtype={'AttendedBootcamp': 'boolean',
				   'BootcampLoan': 'boolean',
                                   'AttendedBootcampTF': 'boolean',
                                   'AttendedBootcampYesNo': 'boolean',
                                   'LoanTF': 'boolean',
                                   'LoanYesNo': 'boolean'},
			    true_values=[1, 'Yes'], # Treat 1 and Yes as true values when casting
			    false_values=[0, 'No']) # Treat 0 and No as false when casting

print(survey_bool)

# output
ID.x                      object
AttendedBootcamp         boolean
BootcampLoan             boolean
AttendedBootcampTF       boolean
AttendedBootcampYesNo    boolean
LoanTF                   boolean
LoanYesNo                boolean
```

Fantastic! We have successfully cast all columns to boolean type. If we now look at the sum of true values we have similar sum across all columns.

```python
# print sum of true values
print(survey_bool.sum())

# output
AttendedBootcamp          37.0
BootcampLoan              14.0
AttendedBootcampTF        37.0
AttendedBootcampYesNo     37.0
LoanTF                    14.0
LoanYesNo                 14.0
```

When casting values to boolean we have to be careful about specifying false values and incorrectly inferred true values by pandas. Casting to boolean changes 0 / 1, Yes / No and other possible true / false values into pythons boolean values. We have to think in advance do so will benefit us over having the float, integer or string values.

### Modifying imports: parsing dates

Let’s talk about dates and time! 

Dates and time have their own data type. They as stored as a string indifferent formats. Pandas infers date and time as objects by default. To tell pandas which columns are dates we use `parse_dates`keyword argument not `dtype`. The survey data has 4 columns with date values. 

![Screen Shot 2022-04-22 at 3.46.09 PM.png](./assets/sheet3.png)

Their type by default is object. We want them in dateTime type. To cast to datetime on load using `parse_dates`. To change type to datetime after reading use `pd.to_datetime()`.

```python
# load start and end time as datetime type 
survey_data = pd.read_excel('fcc-new-coder-survey.xlsx', parse_dates = ['Part1EndTime',
									'Part1StartTime',
									'Part2EndTime'])

# change type of Part2StartTime column to datetime
survey_data['Part2StartTime'] = pd.to_datetime(survey_data['Part2StartTime'])

# print type of parsed dates
print(survey_data[['Part1EndTime', 'Part1StartTime', 'Part2EndTime', 'Part2StartTime']].dtypes)

# output
Part1EndTime      datetime64[ns]
Part1StartTime    datetime64[ns]
Part2EndTime      datetime64[ns]
Part2StartTime    datetime64[ns]
```

Let’s spice it up! Date and time doesn’t come this format always. It might follow other standard format or a custom format.

The below snippet of code split *Part2StartTime* into StartDate and StartTime columns. StartDate and StartTime are standard format that pandas can understand. StartTimeCustom on the other hand is a custom date format which pandas can’t parse.

```python
# split date '2016-03-29 21:27:25' into '2016-03-29' '21:27:25' and store them
# separately with col name StartDate and StartTime
survey_data[['StartDate', 'StartTime']] = survey_data.Part2EndTime.str.split(' ', expand=True)

# This is an alternative way of doing the above operation
# This one is more accurate because we changed the string to datetime and extract
# date and time separately
survey_data['StartDate'] = pd.to_datetime(survey_data.Part2EndTime).dt.date
survey_data['StartTime'] = pd.to_datetime(survey_data.Part2EndTime).dt.time

# remove the '-' to create custom datetime format
# '2016-03-29 21:27:25' -> '20160329 21:27:25'
survey_data['StartTimeCustom'] = survey_data.Part2EndTime.str.replace('-', '')

print(survey_data[['StartTimeCustom', 'StartDate', 'StartTime']])

# output
          StartTimeCustom	  StartDate 	  StartTime
0	20160329 21:27:25	 2016-03-29	   21:27:25
1	20160329 21:29:10	 2016-03-29	   21:29:10
2	20160329 21:28:21	 2016-03-29	   21:28:21
3	20160329 21:30:51	 2016-03-29	   21:30:51

survey_data.to_excel('fcc-survey_date.xlsx', index=False)
```

We can specify the types for *StartDate* and *StartTime* when reading the sheet. By adding nested list we can combine multiple columns together and parse them as datetime. To specify a column type for newly created column we can use dictionary instead of nested list.

```python
survey_data_date = pd.read_excel('fcc-survey_date.xlsx', parse_dates=['StartTimeCustom',
								      ['StartDate', 'StartTime']])

print(survey_data_date)

# output
            StartTimeCustom	  StartDate_StartTime
0	2016-03-29 21:27:25	  2016-03-29 21:27:25
1	2016-03-29 21:29:10	  2016-03-29 21:29:10
2	2016-03-29 21:28:21	  2016-03-29 21:28:21
3	2016-03-29 21:30:51	  2016-03-29 21:30:51

survey_data_date = pd.read_excel('fcc-survey_date.xlsx', 
				 parse_dates={'StartTime': 'StartTimeCustom',
					      'StartDate_Time': ['StartDate', 'StartTime']])

print(survey_data_date)

# output
                  StartTime	       StartDate_Time
0	2016-03-29 21:27:25	  2016-03-29 21:27:25
1	2016-03-29 21:29:10	  2016-03-29 21:29:10
2	2016-03-29 21:28:21	  2016-03-29 21:28:21
3	2016-03-29 21:30:51	  2016-03-29 21:30:51
```

`parse_dates` doesn’t work with non-standard datetime formats. To parse custom date and time we use `to_datetime()` function and we give it the format to parse the strings by. Datetime formats are described with codes and characters. 

> [strftime.org](https://strftime.org/) is a good reference to datetime formatting.
> 

Here are some important codes

| Code | Meaning | Example |
| --- | --- | --- |
| %Y | Year (4-digit) | 1996 |
| %m | Month (zero-padded) | 02 |
| %d | Day (zero-padded) | 07 |
| %H | Hour (zero-padded) | 10 |
| %M | Minute (zero-padded) | 48 |
| %S | Second (zero-padded) | 59 |

```python
# 20160329 21:27:25 is in the format of %Y%m%d %H:%M:%S
survey_data_date['StartTimeCustom'] = pd.to_datetime(survey_data_date['StartTimeCustom'],
						     format='%Y%m%d %H:%M:%S')

print(survey_data_date[['StartTimeCustom']])

# output
StartTimeCustom     datetime64[ns]

print(survey_data_date['StartTimeCustom'].head())

# output
            StartTimeCustom
0	2016-03-29 21:27:25
1	2016-03-29 21:29:10
2	2016-03-29 21:28:21
```
