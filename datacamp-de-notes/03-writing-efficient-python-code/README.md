# ****Writing Efficient Python Code****

## ****Foundations for Efficiencies****

As a data engineer the majority of your time should be spend managing and organizing data, not waiting for data to be processed. In this article we will cover how to write clean, fast and efficient python code  and how to profile your code for bottlenecks and eliminate them.

**Efficient code** is that takes minimum time to complete ( latency) and minimum resource consumption (small memory footprint).

**Pythonic** is a term used to describe a preferred way of doing things in python. There are many ways to accomplish a task in python and the one way that is preferred is called pythonic. Pythonic is following the convention of python community and using python in a way it is intended to be used.

**The Zen of Python** is a list of guidelines to write an efficient python code. To list the zen of python run  `import this` in python terminal.

In other programming language like javascript looping through a list of items is typically done by holding an index variable `i` and incrementing it by 1 on each iteration. And if index greater than length of the list looping is terminated.

```jsx
const nums = [1, 2, 3, 4, 5]
const sqr = []

for (let i = 0; i < nums.length; i++){
    sqr.push(nums[i]**2) // square of a number 
}

console.log(sqr)

// output
[ 1, 4, 9, 16, 25 ] // square of numbers in nums
```

In python a *pythonic* way to do this is to loop over the content of *nums* instead of using index variable. The best *pythonic* way of doing this is to use list comprehension.

```python
nums = [1, 2, 3, 4, 5]
sqr = []

for num in nums:
	sqr.append(pow(num, 2))

print(sqr)
# output
[1, 4, 9, 16, 25]

# ------------ list comprehension ------------
sqr = [pow(num, 2) for num in nums]

print(sqr)
# output
[1, 4, 9, 16, 25]
```

### Built-ins

Python comes with a standard library which contains types, function and modules. Everything that comes in python’s library is called a built-in and they ship with every python installation which means anyone can access them without installing any additional package.

We will focus on 3 built-in functions that come in handy when working with lists.

`range()` is a built in function used to generate a list of numbers. It accept start, stop and step parameters. It return a range type, we have to convert it to a list type to use it as a list using `list()`.

```python
nums = list(range(11)) # range with stop parameter only
nums_2 = list(range(0, 11)) # range with start and stop parameter
even_nums = [*range(2, 11, 2)] # range step parameter, and unpacking '*' operation

print(nums)
print(nums_2)
print(even_nums)
# output
[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10] # stop value is excluded
[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10] # stop value is excluded
[2, 4, 6, 8, 10] # step value is incremental value
```

`enumerate()` accept a list of items and produces index list of items. We can specify starting index with `start` keyword argument. It return enumerate type thus we have to convert it to list first.

```python
letters = ['a', 'b', 'c', 'd', 'e']

indexed_letters = list(enumerate(letters))
indexed_letters2 = list(enumerate(letters, start=3))

print(indexed_letters)
print(indexed_letters2)
# output
[(0, 'a'), (1, 'b'), (2, 'c'), (3, 'd'), (4, 'e')] # start from 0
[(3, 'a'), (4, 'b'), (5, 'c'), (6, 'd'), (7, 'e')] # start from 3
```

`map()` built-in function let’s us apply a function on each items in a list. It accept a function name or a lambda function (anonymous function) and a list. We use lambda function of the function we want to call require multiple arguments like `pow(n, p)` function. Like others we have to convert the return *map* type to list.

```python
nums = [1, 2, 3, 4, 5]
rounded_nums = list(map(round, nums)) # inserting a function name
sqr_nums = list(map(lambda num: pow(num, 2), nums)) # using lambda function

print(rounded_nums)
print(sqr_nums)
# output
[1, 4, 9, 16, 25]
[1, 2, 3, 4, 5]
```

<aside>
💡 Use `range` to generate a list of integers.
Use `enumerate` to keep a count of iterations.
Use `map` to apply a function on each item in a list.

</aside>

A more clean way of casting iterator types like *range*, *enumerate* and *map* to list type is to use unpacking operation (`*`). Read about unpacking [here](https://stackabuse.com/unpacking-in-python-beyond-parallel-assignment/).

```python
nums = [1, 2, 3, 4, 5]
rounded_nums = list(map(round, nums)) # inserting a function name
rounded_nums2 = [*map(round, nums)] # using unpacking

print(rounded_nums == rounded_nums2)
# output
True
```

### NumPy arrays

[NumPy](https://numpy.org/) is a fantastic package for doing scientific computations in python. NumPy provide arrays which are python list alternative with fast and memory efficient features an a lot more. NumPy array are homogenous, which means they only contain items of the same type. With homogeneity NumPy arrays don’t have to check for type of each items in the array which make them fast to work with. If we give it heterogenous data it will try to cast them into similar type other wise it will raise error exception.

```python
>>> import numpy as np

>>> nums_np = np.array(range(5))
>>> nums_ht = np.array([1, 5.3, 4])

>>> nums_np
array([0, 1, 2, 3, 4]) # type is array
>>> nums_ht
array([1. , 5.3, 4. ]) # integers are casted to floats
>>> nums_ht.dtype
dtype('float64')
```

In NumPy arrays we don’t have to loop over each items to perform a task, with **array broadcasting** NumPy will apply the task on each items that was applied on the array variable. In python list to perform task we either iterate over the items or use list comprehension or use map function.

```python
nums_np = np.array(range(5))
nums_sqr = nums_np ** 2

print(nums_sqr)
# output
[ 0  1  4  9 16]
```

NumPy has the advantage of selecting a specific elements in multi-dimension array only using indexes.

```python
num2d = [ [1, 2, 3],
					  [1, 4, 9] ]

num2d_np = np.array(num2d)

print(num2d[0][1])
print(num2d_np[0,1])
# output
2
2

print([row[2] for row in num2d])
print(num2d_np[:,2]) # : indicates for all rows, give me second column values
# output
[3, 9]
array([3, 9])
```

Boolean indexing in NumPy let us select items based on a boolean values. What this means is we give it a list of booleans that are same length as the array we want to filter and it returns items where the value of their exact location in boolean list is true.

```python
>>> nums_np = np.array(range(1, 11))
>>> nums_np % 2 == 0
array([False, True, False, True, False, True, False, True, False, True])
>>> nums_np[nums_np % 2 == 0]
array([2,  4,  6,  8, 10]) # return number that satisfy the condition
```

## **Timing and profiling code**
