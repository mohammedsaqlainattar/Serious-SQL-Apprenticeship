# :computer: SERIOUS SQL :exclamation:

# :mag: DATA EXPLORATION :earth_asia:

## :pushpin: Select & Sort Data

**Show all records from the `language` table from the `dvd_rentals` schema**
```sql
SELECT * FROM dvd_rentals.language;
```

**Show only the `language_id` and `name` columns from the `language` table**
```sql
SELECT 
language_id,name 
FROM dvd_rentals.language;
```

**Use `LIMIT` to restrict the output to just the first few rows from the query.**
```sql
SELECT *
FROM dvd_rentals.actor
LIMIT 10;
```

>:bulb: **We can use the `ORDER BY` clause at the end of our queries to sort the output using `ASC` or `DESC`**

**What are the first 5 values in the `country` column from the `country` table by alphabetical order?**
```sql
SELECT country
FROM dvd_rentals.country
ORDER BY country ASC
LIMIT 5;
```

**Sort By Multiple Columns** - We can also perform a multi-level sort by specifying 2 or more columns with the `ORDER BY` clause.

```sql
SELECT * FROM sample_table
ORDER BY column_a ASC/DESC, column_b ASC/DESC;
```

## :star: Exercises

1.  **What is the  `name`  of the category with the highest  `category_id`  in the  `dvd_rentals.category`  table?**
```sql
SELECT name,category_id FROM dvd_rentals.category
ORDER BY category_id DESC;
```
2. **For the films with the longest  `length`, what is the  `title`  of the “R” rated film with the lowest  `replacement_cost`  in  `dvd_rentals.film`  table?**
 - We have **3** things to keep in mind for this question
	 1. Longest `Length`
	 2. `title` with 'R' rating
	 3. Lowest `replacement_cost`
```sql
SELECT title,rating,length,replacement_cost 
FROM dvd_rentals.film
WHERE rating ='R'
ORDER BY length DESC,replacement_cost ASC
LIMIT 10;
```

3.  **Who was the  `manager`  of the store with the highest  `total_sales`  in the  `dvd_rentals.sales_by_store`  table?**
```sql
SELECT manager,total_sales FROM dvd_rentals.sales_by_store
ORDER BY total_sales DESC 
LIMIT 1;
```

4.  **What is the  `postal_code`  of the city with the 5th highest  `city_id`  in the  `dvd_rentals.address`  table?**
```sql
SELECT city_id,postal_code FROM dvd_rentals.address
ORDER BY city_id DESC
LIMIT 5; --Look at the 5th row
```
**OR**
   
```sql
SELECT city_id,postal_code
FROM dvd_rentals.address
ORDER BY city_id DESC
LIMIT 1 OFFSET 4; -- To return 5th row, offset the 1st 4 rows and only show the 5th row
```
***

## :pushpin: Record Counts & Distinct Values

**We use the `COUNT` function to take a look at a simple record count in a table.
For example, how many rows are there in the `film_list` table?**
```sql
SELECT COUNT(*) AS row_count
FROM dvd_rentals.film_list;
```

**The `DISTINCT` keyword is used to identify the unique values from a column.**
- **What are the unique values for the `rating` column in the `film` table?**
```sql
SELECT DISTINCT(rating)
FROM dvd_rentals.film_list;
```

- **How many unique `category` values are there in the `film_list` table?**
```sql
SELECT
  COUNT(DISTINCT category) AS unique_category_count
FROM dvd_rentals.film_list;
```

**`GOUP BY` clause with an aggregate function like `COUNT` allows us to "Group" the data based of the values of the selected columns.**

- **What is the frequency of values in the `rating` column in the `film_list` table?**
```sql
SELECT rating,COUNT(*) AS frequency
FROM dvd_rentals.film_list
GROUP BY rating;
```
>**:bulb: The important thing to note for `GROUP BY` aggregate functions is this: Only 1 row is returned for each group. Grouping on multiple columns returns a row for every unique combination of values present in the columns.**

**Using `GROUP BY` on 2+ columns.**
- **What are the 5 most frequent `rating` and `category` combinations in the `film_list` table?**
```sql
SELECT
  rating,
  category,
  COUNT(*) AS frequency
FROM dvd_rentals.film_list
GROUP BY rating, category
ORDER BY frequency DESC
LIMIT 5;
```

>**:bulb: Some SQL developers like to refer to target columns used in `GROUP BY` and `ORDER BY` clauses by the positional number that the columns appear in the `SELECT` statement. This is just a stylistic choice by some developers and it won't make any difference. I would recommend sticking with complete column names wherever possible.
>For example:**
```sql
SELECT
  rating,
  category,
  COUNT(*) AS frequency
FROM dvd_rentals.film_list
GROUP BY 1,2
ORDER BY 2,1,3 DESC
LIMIT 5;
```

## :star: Exercises

1.  **Which  `actor_id`  has the most number of unique  `film_id`  records in the  `dvd_rentals.film_actor`  table?**
```sql
SELECT actor_id,COUNT(DISTINCT(film_id)) AS film_count
FROM dvd_rentals.film_actor
GROUP BY actor_id
ORDER BY film_count DESC
LIMIT 1;
```
|actor_id|film_count|
|:---:|:---:|
|107|42|

2.  **How many distinct  `fid`  values are there for the 3rd most common  `price`  value in the  `dvd_rentals.nicer_but_slower_film_list`  table?**
- We have **2** things to notice here
	1. 'How many distinct' hints that we have to use `COUNT` and `DISTINCT`.
	2. '3rd most common `price` value' indicates that we have to use `GROUP BY` on `price` column.

```sql
SELECT price,COUNT(DISTINCT fid) as fid_count
FROM dvd_rentals.nicer_but_slower_film_list
GROUP BY price
ORDER BY fid_count DESC;
```
|price|fid_count|
|:---:|:---:|
|0.99|340|
|4.99|334|
|2.99|323|

3.  **How many unique  `country_id`  values exist in the  `dvd_rentals.city`  table?**
```sql
SELECT COUNT(DISTINCT(country_id)) AS unique_countries 
FROM dvd_rentals.city;
```
|unique countries|
|:---:|
|109|

4.  **What percentage of overall  `total_sales`  does the Sports  `category`  make up in the  `dvd_rentals.sales_by_film_category`  table?**
```sql
SELECT 
  category,
  ROUND(100*CAST(total_sales AS NUMERIC)/SUM(total_sales) OVER(),2) 
  AS percentage
FROM dvd_rentals.sales_by_film_category;
```
|category|percentage|
|:---:|:---:|
|Sports|7.88|
|Sci-Fi|7.06|
|Animation|6.91|
|Drama|6.8|
|Comedy|6.5|
|Action|6.49|
|New|6.46|
|Games|6.35|
|Foreign|6.33|
|Family|6.28|
|Documentary|6.26|
|Horror|5.52|
|Children|5.42|
|Classics|5.4|
|Travel|5.27|
|Music|5.07|


5.  **What percentage of unique  `fid`  values are in the Children  `category`  in the  `dvd_rentals.film_list`  table?**
```sql
SELECT 
  category,
  ROUND(100 * COUNT(DISTINCT(fid))::NUMERIC / 
  SUM(COUNT(DISTINCT(fid))) OVER(),2) 
  AS percent_categories
FROM dvd_rentals.film_list
GROUP BY category;
```
|category|percent_categories|
|:---:|:---:|
|Action|6.42|
|Animation|6.62|
|Children|6.02|
|Classics|5.72|
|Comedy|5.82|
|Documentary|6.82|
|Drama|6.12|
|Family|6.92|
|Foreign|7.32|
|Games|6.12|
|Horror|5.62|
|Music|5.12|
|New|6.32|
|Sci-Fi|6.12|
|Sports|7.32|
|Travel|5.62|


>**:sparkles: Tip: Take a note of that `CAST` or `::NUMERIC` in the previous two examples. This is to "avoid" dreaded integer floor division.
For example : consider a simple case of division like** 
```sql
SELECT 100/3 AS integer_division;
--OR
SELECT 15/20 AS integer_division;
```
> We expect the answer to be **33.333** for 100/3 but we actually get **33** and **0.75** for 15/20 but we get **0**.
> 
>:point_right: **Explanation: When you divide an `INT` data type with another `INT` data type - the SQL engine automatically returns you the floor division!
>:heavy_check_mark: The solution is to simply cast either the top or the bottom of the division terms as a `NUMERIC` data type and you’re set!**

***
## :pushpin: Identifying Duplicate Records and How to deal with them :thinking:

>**Introduction to Health Data** : For context, this real world (`health.user_logs`) messy dataset captures data taken from individuals logging their measurements via an online portal throughout the day. For example, multiple measurements can be taken on the same day at different times, but you may notice this information is missing as the `log_date` column does not show timestamp values!. **Initial dataset inspection is covered in the course content**.

### :triangular_flag_on_post: Detecting Duplicate Records
Before we think about removing duplicate records - we need a systematic way to check whether our table has any duplicate records first!
The first ingredient for this recipe is the basic record count for our table - plain and simple using the `COUNT(*)` function.
```sql
SELECT COUNT(*)
FROM health.user_logs;
```
### :triangular_flag_on_post: Remove All Duplicates

We could use the `DISTINCT` keyword to remove duplicates from the table 
```sql
SELECT DISTINCT *
FROM health.user_logs;
```
**BUT**, if we want to count the number of rows in this deduplicated dataset using the `COUNT` function then we will run into an error :x: :point_right: **" syntax error at or near * "** for the code below
```sql
SELECT COUNT(DISTINCT *) -- this won't work
FROM health.user_logs;
```
Unfortunately for us - **PostgreSQL** does not allow for this style of  `COUNT(DISTINCT *)`  syntax like we can use on a single column! :heavy_exclamation_mark:
There are some other flavours of SQL that actually allow for this syntax namely Teradata, however it is not a standard operation which we can use everywhere.

However, it is relatively straightforward to get around this and there are a few ways!

1. **Subquery**
	A subquery is essentially a query within a query - in this case we want to use our  `DISTINCT *`  output in the innermost nested query as a data source for the outer query.
Take note of the syntax - especially the  `AS`  component because subqueries must always have an alias!
```sql
SELECT COUNT(*)
FROM (
  SELECT DISTINCT *
  FROM health.user_logs
) AS subquery;
```

2. **Common Table Expression (CTE)**
	A CTE is a SQL query that manipulates existing data and stores the data outputs as a new reference, very similar to storing data in a new temporary Excel sheet (following the Excel analogy!).

	Subsequent CTEs can refer to existing datasets, as well as previously generated CTEs. This allows for quite complex nested queries and operations to be performed, whilst keeping the code nice and readable!
```sql
WITH deduped_logs AS (
  SELECT DISTINCT *
  FROM health.user_logs
)
SELECT COUNT(*)
FROM deduped_logs;
```

3. **Temporary Tables**
	We can also create a temporary table with only the unique values of our dataset after we run the  `DISTINCT`  query.
	This is a very common approach when you know that you will only be analyzing the deduplicated dataset, and you will ignore the original one with duplicates.

	The main benefit of using temporary tables is removing the need to always run the same  `DISTINCT`  command everytime you want to run a query on the deduplicated records. Temporary tables can also be used with indexes and partitions to speed up performance of our SQL queries.

	There is a lengthier process to dealing with temporary tables for our example
- First we run a  `DROP TABLE IF EXISTS`  statement to clear out any previously created tables
```sql
DROP TABLE IF EXISTS deduplicated_user_logs;
```
:warning: Be very careful when running this following `DROP TABLE` statement as you can’t really undo things when you drop an actual table!

- Next create a new temporary table using the results of the query below
```sql
CREATE TEMP TABLE deduplicated_user_logs AS
SELECT DISTINCT *
FROM health.user_logs;
```

- Let’s query this newly created temporary table to make sure we can access it
```sql
SELECT *
FROM deduplicated_user_logs
LIMIT 10;
```

-   Finally, let’s run that same  `COUNT`  on this deduplicated temp table to confirm it did the right thing!
```sql
SELECT COUNT(*)
FROM deduplicated_user_logs;
```
:white_check_mark: The entire query will look like
```sql
DROP TABLE IF EXISTS deduplicated_user_logs;

CREATE TEMP TABLE deduplicated_user_logs AS
SELECT DISTINCT *
FROM health.user_logs;

SELECT COUNT(*)
FROM deduplicated_user_logs;
```
#### So, out of the 3 ways which one should I use? :thinking:
Ask this question to yourself:
> Will I need to use the deduplicated data later?
- If **YES** :+1:, opt for **Temporary Tables**
- If **NO** :-1:, go with **CTEs**

Subqueries are not recommended because they are less readable than CTEs.

### :triangular_flag_on_post: Identifying Duplicate Records
Finally our aim is to write a final SQL statement to efficiently return us all rows which are duplicated in our target table.

:white_check_mark: **Group By Counts On All Columns**
There are different ways to approach this simple problem of returning duplicate rows depending on what is required.
We can implement a single SQL statement that will help us achieve both outputs and also something even more useful!
The trick is to use a  `GROUP BY`  clause which has every single column in the grouping element and a  `COUNT`  aggregate function - this is an elegant solution to quickly find the unique combinations of all the rows.

Hang on a second…isn’t that exactly what the  `DISTINCT` keyword is supposed to do?
Yes - that’s correct! The only difference here is that we can also apply the aggregate function with the  `GROUP BY`  clause to find the counts for the unique combinations.
```sql
SELECT
  id,
  log_date,
  measure,
  measure_value,
  systolic,
  diastolic,
  COUNT(*) AS frequency
FROM health.user_logs
GROUP BY
  id,
  log_date,
  measure,
  measure_value,
  systolic,
  diastolic
ORDER BY frequency DESC;
```
Notice how the frequency for some of these values is 1 (which means they are unique) - whilst some are greater than 1 (which means they are duplicates)
This is exactly how we know which unique combinations of the columns have duplicates!

:white_check_mark: **Having Clause For Unique Duplicates**
Now the final step is to use the `HAVING` clause to further trim down our output by applying a condition on the same `COUNT(*)` expression we were using for the 'frequency' column.
Since we only want the duplicate records to be returned - we would like that `COUNT(*)` value to be greater than 1.
```sql
SELECT
  id,
  log_date,
  measure,
  measure_value,
  systolic,
  diastolic
FROM health.user_logs
GROUP BY
  id,
  log_date,
  measure,
  measure_value,
  systolic,
  diastolic
HAVING COUNT(*)>1;
```
**OR** - **Using TEMP Tables**
```sql
-- Don't forget to clean up any existing temp tables!
DROP TABLE IF EXISTS unique_duplicate_records;

CREATE TEMPORARY TABLE unique_duplicate_records AS
SELECT *
FROM health.user_logs
GROUP BY
  id,
  log_date,
  measure,
  measure_value,
  systolic,
  diastolic
HAVING COUNT(*) > 1;

-- Finally let's inspect the top 10 rows of our temp table
SELECT *
FROM unique_duplicate_records
LIMIT 10;
```
:memo: Note that we cannot use the same `*` within the `GROUP BY` grouping elements as it will throw a syntax error.

:white_check_mark: **Retaining Duplicate Counts**
Let’s say for example - we want to know which exact records are duplicated and also how many times they appeared.
```sql
WITH groupby_counts AS (
  SELECT
    id,
    log_date,
    measure,
    measure_value,
    systolic,
    diastolic,
    COUNT(*) AS frequency
  FROM health.user_logs
  GROUP BY
    id,
    log_date,
    measure,
    measure_value,
    systolic,
    diastolic
)
SELECT *
FROM groupby_counts
WHERE frequency > 1
ORDER BY frequency DESC
LIMIT 10;
```
|id|log_date|measure|measure_value|systolic|diastolic|frequency|
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
|054250c692e07a9fa9e62e345231df4b54ff435d|2019-12-06|blood_glucose|401| | |104|
|054250c692e07a9fa9e62e345231df4b54ff435d|2019-12-05|blood_glucose|401| | |77|
|054250c692e07a9fa9e62e345231df4b54ff435d|2019-12-04|blood_glucose|401| | |72|
|054250c692e07a9fa9e62e345231df4b54ff435d|2019-12-07|blood_glucose|401| | |70|
|054250c692e07a9fa9e62e345231df4b54ff435d|2020-09-30|blood_glucose|401| | |39|
|054250c692e07a9fa9e62e345231df4b54ff435d|2020-09-29|blood_glucose|401| | |24|
|054250c692e07a9fa9e62e345231df4b54ff435d|2020-10-02|blood_glucose|401| | |18|
|054250c692e07a9fa9e62e345231df4b54ff435d|2019-12-10|blood_glucose|140| | |12|
|054250c692e07a9fa9e62e345231df4b54ff435d|2019-12-11|blood_glucose|220| | |12|
|054250c692e07a9fa9e62e345231df4b54ff435d|2020-04-15|blood_glucose|236| | |12|


## :star: Exercises

1.  **Which  `id`  value has the most number of duplicate records in the  `health.user_logs`  table?**
```sql
-- Use CTE to create a table with a new column to COUNT the number of duplicated records using GROUP BY. 
WITH cte_duplicate_records AS (
SELECT
  id,
  log_date,
  measure,
  measure_value,
  systolic,
  diastolic,
  COUNT(*) AS frequency
FROM health.user_logs
GROUP BY 
  id,
  log_date,
  measure,
  measure_value,
  systolic,
  diastolic
)

SELECT
  id,
  SUM(frequency) AS total_duplicates -- Use SUM to add up frequencies of each id since we are grouping by ids.
FROM cte_duplicate_records
WHERE frequency > 1  -- To filter all records which appeared more than once which makes them duplicates.
GROUP BY id
ORDER BY total_duplicates DESC
LIMIT 10;
```
|id|total_duplicates|
|:---:|:---:|
|054250c692e07a9fa9e62e345231df4b54ff435d|17279|
|ee653a96022cc3878e76d196b1667d95beca2db6|758|
|0f7b13f3f0512e6546b8d2c0d56e564a2408536a|485|
|6c2f9a8372dac248192c50219c97f9087ab778ba|106|
|981197b530b9ec5032abb0ffe4b69dba3649f467|77|
|907d1231aed4a3540b30f91b336130746042ce47|69|
|316f2f73322d8edcea74d4f22b6749bf2dc3dd9a|58|
|df0da942ab95c538f96d70dead8353e348845efe|45|
|abc634a555bbba7d6d6584171fdfa206ebf6c9a0|42|
|576fdb528e5004f733912fae3020e7d322dbc31a|41|


2.  **Which  `log_date`  value had the most duplicate records after removing the max duplicate  `id`  value from question 1?**
```sql
-- Using CTE from previous question to solve this problem.
WITH cte_duplicate_records AS (
SELECT
  id,
  log_date,
  measure,
  measure_value,
  systolic,
  diastolic,
  COUNT(*) AS frequency
FROM health.user_logs
WHERE id != '054250c692e07a9fa9e62e345231df4b54ff435d' -- This was the id with the most duplicated records
GROUP BY 
  id,
  log_date,
  measure,
  measure_value,
  systolic,
  diastolic
)

SELECT
  log_date,
  SUM(frequency) AS total_duplicates
FROM cte_duplicate_records
WHERE frequency > 1
GROUP BY log_date
ORDER BY total_duplicates DESC
LIMIT 10;
```
|log_date|total_duplicates|
|:---:|:---:|
|2019-12-11|55|
|2019-12-10|22|
|2020-04-11|20|
|2020-03-08|20|
|2020-06-12|19|
|2020-07-30|18|
|2020-07-31|17|
|2020-06-11|16|
|2020-07-20|16|
|2020-06-14|16|


3.  **Which  `measure_value`  had the most occurences in the  `health.user_logs`  value when  `measure = 'weight'`?**
```sql
SELECT 
  measure_value,
  COUNT(measure_value) AS frequency
FROM health.user_logs
WHERE measure = 'weight'
GROUP BY measure_value
ORDER BY frequency DESC
LIMIT 10;
```
|measure_value|frequency|
|:---:|:---:|
|68.49244787|109|
|67.58526313|107|
|63.50288|44|
|62.595696|44|
|64.863656|39|
|62.142104|39|
|65.317248|38|
|65.77084|37|
|78.6982762|29|
|79.15186857|27|


4.  **How many single duplicated rows exist when  `measure = 'blood_pressure'`  in the  `health.user_logs`? How about the total number of duplicate records in the same table?**
- Single duplicated rows here means - how many rows of duplicate records are present?
- Total no. of duplicates  --> `SUM(frequency)`
```sql
WITH cte_blood_pressure AS (
SELECT
  id,
  log_date,
  measure,
  measure_value,
  systolic,
  diastolic,
  COUNT(*) AS frequency
FROM health.user_logs
WHERE measure = 'blood_pressure'
GROUP BY 
  id,
  log_date,
  measure,
  measure_value,
  systolic,
  diastolic
)

SELECT 
  COUNT(*) AS single_duplicate_rows_count,
  SUM(frequency) AS total_duplicate_count
FROM cte_blood_pressure
WHERE frequency > 1;
```
|single_duplicate_rows_count|total_duplicate_count|
|:---:|:---:|
|147|301|


5.  **What percentage of records  have `measure_value = 0`  when  `measure = 'blood_pressure'`  in the  `health.user_logs`  table? How many records are there also for this same condition?**
```sql
WITH cte_blood_pressure AS (
SELECT
  measure_value,
  COUNT(*) AS frequency,
  SUM(COUNT(*)) OVER() AS overall_total
FROM health.user_logs
WHERE measure = 'blood_pressure'
GROUP BY measure_value
)

SELECT 
  measure_value,
  frequency,
  overall_total,
  ROUND((100 * frequency::NUMERIC / overall_total),2) AS percentage
FROM cte_blood_pressure
WHERE measure_value = 0;
```
|measure_value|frequency|overall_total|percentage|
|:---:|:---:|:---:|:---:|
|0|562|2417|23.25|

6.  **What percentage of records are duplicates in the  `health.user_logs`  table?**
- This is seemingly simple question is actually deceivingly tricky - mainly because of how one would set the numerator for this calculation!
- We will use a `SUM` and a `CASE WHEN` statement to make this happen in a single query.
```sql
WITH cte_duplicate_records AS (
  SELECT
    id,
    log_date,
    measure,
    measure_value,
    systolic,
    diastolic,
    COUNT(*) AS frequency
  FROM health.user_logs
  GROUP BY
    id,
    log_date,
    measure,
    measure_value,
    systolic,
    diastolic
)

SELECT
  ROUND(100 * SUM(CASE
      WHEN frequency > 1 THEN frequency - 1   --(-1) to count the actual duplicates
      ELSE 0 
      END)::NUMERIC /
      SUM(frequency),2) AS percentage
FROM cte_duplicate_records;
```
|percentage|
|:---:|
|29.36|

**Alternate Solution using Subqueries**
```sql
WITH cte_unique_records AS (
SELECT DISTINCT * FROM health.user_logs
)

SELECT
  ROUND(100 * 
  ((SELECT COUNT(*) FROM health.user_logs) - (SELECT COUNT(*) FROM cte_unique_records))::NUMERIC /
  (SELECT COUNT(*) FROM health.user_logs),2) AS duplicate_percentage;
```
***
## :pushpin: Summary Statistics :bar_chart:

### :triangular_flag_on_post: Measures of Central Tendency :point_right: Mean, Median and Mode

- **Mean** - Also known as Average, it is the sum of all values divided by the total count of values for a set of numbers.
			![Mean formula](https://github.com/mohammedsaqlainattar/Serious-SQL-Apprenticeship/blob/main/Images/Mean%20formula.JPG?raw=true)

- **Median** - The median (also known as the 50th percentile value) is the value separating the top half from the bottom half of a data sample, a population, or a probability distribution. It is simply the **middle value** in an ordered (ascending or descending) list of numbers.

- **Mode** - The mode is simply calculated as the value that appears the most number of times i.e the most frequent value in the dataset. Also, a given set of observations can have more than one mode.
![enter image description here](https://cdn.educba.com/academy/wp-content/uploads/2020/02/Statistics-Formula.jpg.webp)

Some flavours of SQL actually have implemented median and mode values as regular functions like the `AVG` function. But, in PostgreSQL it's a little tricky!
```sql
SELECT
  AVG(example_values) AS mean_value,
  PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY example_values) AS median_value,
  MODE() WITHIN GROUP (ORDER BY example_values) AS mode_value
FROM sample_data;
```

### :triangular_flag_on_post: Spread of the Data :point_right: Min, Max and Range

The **minimum** and **maximum** values of observations in a dataset help us identify the boundaries of where our data exists.
We use the **range** calculation to show the total possible limits of our data by simply calculating the difference between the max and min values from our data.
```sql
SELECT
  MIN(measure_value) AS minimum_value,
  MAX(measure_value) AS maximum_value,
  MAX(measure_value) - MIN(measure_value) AS range_value
FROM health.user_logs
WHERE measure = 'weight';
```
|minimum_value|maximum_value|range_value|
|:---:|:---:|:---:|
|0|39642120|39642120|


### :triangular_flag_on_post: Variance and Standard Deviation

**Variance** and **Standard Deviation** are used to describe the “spread” of the data about the mean value. Also, the variance is simply the square of the standard deviation.

**Variance and Std.Dev Formulae:**

![Variance and Std.Dev](https://github.com/mohammedsaqlainattar/Serious-SQL-Apprenticeship/blob/main/Images/Variance%20and%20Std.Dev.JPG)

```sql
 WITH sample_data (example_values) AS (
 VALUES
 (82), (51), (144), (84), (120), (148), (148), (108), (160), (86)
)
SELECT
  ROUND(VARIANCE(example_values), 2) AS variance_value,
  ROUND(STDDEV(example_values), 2) AS standard_dev_value,
  ROUND(AVG(example_values), 2) AS mean_value,
  PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY example_values) AS median_value,
  MODE() WITHIN GROUP (ORDER BY example_values) AS mode_value
FROM sample_data;
```
|variance_value|standard_dev_value|mean_value|median_value|mode_value|
|:---:|:---:|:---:|:---:|:---:|
|1340.99|36.62|113.1|114|148|


We’ve talked about the variance and standard deviation being a measure of spread - but what do we mean by this?

One of the best examples to explain this is to take a look at the humble bell curve, or normal distribution.Now there is a huge caveat to this explanation in that - data is not ALWAYS normally distributed.
![Normal Distribution](https://www.w3schools.com/statistics/img_normal_distribution.svg)

### :triangular_flag_on_post: Confidence Intervals or The Empirical Rule

One other way to interpret the standard deviation is the `Empirical Rule`.
Essentially if our data is approximately normally distributed (it looks like a bell curve) - we can make rough generalisations about how much percentage of the total lies between different ranges related to our standard deviation values.

These boundaries are also known as **Confidence Intervals** or confidence bands - ranges where we are fairly sure that the data will lie within!
![enter image description here](https://cdn.corporatefinanceinstitute.com/assets/empirical-rule2.png)
We refer to these ranges as “**one standard deviation about the mean**” contains 68% of values etc.

One popular method to detect an uneven distribution in the dataset is to compare the average, mode and median values - this statistical property is known as a **Skew** in the distribution.
![Skewness](https://upload.wikimedia.org/wikipedia/commons/c/cc/Relationship_between_mean_and_median_under_different_skewness.png)

### :triangular_flag_on_post: Calculating All The Summary Statistics

```sql
SELECT
  'weight' AS measure,
  ROUND(MIN(measure_value), 2) AS minimum_value,
  ROUND(MAX(measure_value), 2) AS maximum_value,
  ROUND(AVG(measure_value), 2) AS mean_value,
  ROUND(
    -- this function actually returns a float which is incompatible with ROUND!
    -- we use this cast function to convert the output type to NUMERIC
    CAST(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY measure_value) AS NUMERIC),
    2
  ) AS median_value,
  ROUND(
    MODE() WITHIN GROUP (ORDER BY measure_value),
    2
  ) AS mode_value,
  ROUND(STDDEV(measure_value), 2) AS standard_deviation,
  ROUND(VARIANCE(measure_value), 2) AS variance_value
FROM health.user_logs
WHERE measure = 'weight';
```
|measure|minimum_value|maximum_value|mean_value|median_value|mode_value|standard_deviation|variance_value|
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
|weight|0|39642120|28786.85|75.98|68.49|1062759.55|1.12946E+12|

Carefully observe the summary statistics to identify issues like outliers/extreme values in the dataset.

A few questions come to mind straightaway :
-   Does it make sense to have such low minimum values and such a high value?
-   Why is the average value 28,786kg but the median is 75.98kg?
-   The standard deviation of values is WAY too large at 1,062,759kg

We now understand that there are outliers in the minimum and maximum values which are affecting the mean value, standard deviation and variance values. So this data needs to be cleaned!!

## :star: Exercises

1.  **What is the average, median and mode values of blood glucose values to 2 decimal places?**
```sql
SELECT
  ROUND(AVG(measure_value),2) AS mean_value,
  ROUND(CAST(PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY measure_value) AS NUMERIC),2) AS median_value,
-- this function actually returns a float which is incompatible with ROUND!
-- we use this cast function to convert the output type to NUMERIC
  ROUND(MODE() WITHIN GROUP(ORDER BY measure_value),2) AS mode_value
FROM health.user_logs
WHERE measure = 'blood_glucose';
```
|mean_value|median_value|mode_value|
|:---:|:---:|:---:|
|177.35|154|401|


2.  **What is the most frequently occuring  `measure_value`  for all blood glucose measurements?**
```sql
SELECT
  measure_value,
  COUNT(*) AS frequency
FROM health.user_logs
WHERE measure = 'blood_glucose'
GROUP BY measure_value
ORDER BY frequency DESC
LIMIT 10;
```
|measure_value|frequency|
|:---:|:---:|
|401|433|
|117|350|
|118|307|
|115|290|
|126|290|
|122|289|
|108|287|
|123|283|
|125|282|
|120|281|

**OR** if we only want to know the exact `measure_value`
```sql
SELECT
  MODE() WITHIN GROUP (ORDER BY measure_value) AS mode
FROM health.user_logs
WHERE measure = 'blood_glucose';
```
|mode|
|:---:|
|401|


3.  **Calculate the 2 Pearson Coefficient of Skewness for blood glucose measures given the following formulas:**

![Pearson Coefficient of Skewness](https://github.com/mohammedsaqlainattar/Serious-SQL-Apprenticeship/blob/main/Images/Pearson%20Coefficient%20of%20Skewness.JPG?raw=true)

```sql
WITH cte_blood_glucose AS (
SELECT
  AVG(measure_value) AS mean_value,
  PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY measure_value) AS median_value,
  MODE() WITHIN GROUP (ORDER BY measure_value) AS mode_value,
  STDDEV(measure_value) AS standard_deviation
FROM health.user_logs
WHERE measure = 'blood_glucose'
)

SELECT 
  (mean_value - mode_value) / standard_deviation AS pearson_corr_1,
  3*(mean_value - median_value) / standard_deviation AS pearson_corr_2
FROM cte_blood_glucose;
```
|pearson_corr_1|pearson_corr_2|
|:---:|:---:|
|-0.1932489|0.060523971|

- The Skewness terms are quantitative measure of how lopsided a certain distribution is.
- In particularly this is really really useful when you need to find out whether a specific table index has a “skew” in the values - leading to disproportionate allocation of data points to specific buckets or nodes.
- This will be covered in detail later!
***

## :pushpin: Distribution Functions

### :triangular_flag_on_post: Cumulative Distribution Functions (CDF)

In mathematical terms, a cumulative distribution function takes a value and returns us the percentile or in other words: the probability of any value between the minimum value of our dataset  `X`  and the value  `V`  as shown below:

![CDF](https://github.com/mohammedsaqlainattar/Serious-SQL-Apprenticeship/blob/main/Images/CDF.JPG?raw=true)

The beautiful thing about probabilities is that they always add up to 1!
>**:bulb: Refer to course notes for working algorithm and thinking**

### SQL Implementation
### :round_pushpin: Order and Assign
1.  Order all of the weight measurement values from smallest to largest
2.  Split them into 100 equal buckets - and assign a number from 1 through to 100 for each bucket.

We can actually achieve both of these algorithmic steps in a single bit of SQL functionality with the all-powerful  **analytical function**.
Firstly the  `OVER`  and  `ORDER BY`  clauses in the following query help us re-order the dataset by the  `measure_value`  column - it sorts by ascending order by default)
Then the  `NTILE`  window function is used to perform the assignment of numbers 1 through 100 for each row in the records for each  `measure_value`.

```sql
SELECT
  measure_value,
  NTILE(100) OVER (ORDER BY measure_value) AS percentile
FROM health.user_logs
WHERE measure = 'weight'
```
_Only the first 5 and last 5 rows of the output are shown below_
|measure_value|percentile|
|:----|:----|
|0|1|
|0|1|
|1.814368|1|
|2.26796|1|
|2.26796|1|
|…|…|
|190.4|100|
|200.487664|100|
|576484|100|
|39642120|100|
|39642120|100|

### :round_pushpin: Bucket Calculations

3.  For each bucket:
    -   calculate the minimum value and the maximum value for the ceiling and floor values
    -   count how many records there are

Since we now have our percentile values and our dataset is split into 100 buckets - we can simply use a  `GROUP BY`  on the  `percentile`  column from the previous table to calculate our  `MIN`  and  `MAX`  `measure_value`  ranges for each bucket and also the  `COUNT`  of records for the  `percentile_counts`  field.

We can also use the previous query in a CTE so we can pull all the calculations in a single SQL query:

```sql
WITH percentile_values AS (
  SELECT
    measure_value,
    NTILE(100) OVER (ORDER BY measure_value) AS percentile
  FROM health.user_logs
  WHERE measure = 'weight'
)

SELECT
  percentile,
  MIN(measure_value) AS floor_value,
  MAX(measure_value) AS ceiling_value,
  COUNT(*) AS percentile_counts
FROM percentile_values
GROUP BY percentile
ORDER BY percentile;
```
|percentile|floor_value|ceiling_value|percentile_counts|
|:----|:----|:----|:----|
|1|0|29.029888|28|
|2|29.48348|32.0689544|28|
|3|32.205032|35.380177|28|
|4|35.380177|36.74095|28|
|5|36.74095|37.194546|28|
|6|37.194546|38.101727|28|
|…|…|…|…|
|96|130.54207|131.570999146|27|
|97|131.670013428|132.776|27|
|98|132.776000977|133.832000732|27|
|99|133.89095|136.531192|27|
|100|136.531192|39642120|27|

###  :round_pushpin: What Do I Do With This?
So you’re probably asking yourself - ok cool…so what do I do with this cumulative distribution table then?

The first place to take a careful look at is the tails of the values - namely  `percentile = 1`  and  `percentile = 100`

What do you notice from these two rows alone?
|percentile|floor_value|ceiling_value|percentile_counts|
|:----|:----|:----|:----|
|1|0|29.029888|28|
|100|136.531192|39642120|27|

So from first glance you get the following insights right away:

1.  28 values lie between 0 and ~29KG
2.  27 values lie between 136.53KG and 39,642,120KG

Please tell me that you don’t think insight number 2 is normal - unless you’re a GIANT!

Let’s dive a little bit deeper and start thinking critically about what these insights mean.

### :round_pushpin: Critical Thinking
Ok - firstly we need to consider what the data point is that we’re actually using here - in this case, it is a weight value in KG units.

When we think of those small values in the 1st percentile under 29kg, a few things should come to mind:

1.  Maybe there were some incorrectly measured values - leading to some 0kg weight measurements
2.  Perhaps some of the low weights under 29kg were actually valid measurements from young children who were part of the customer base

For the 100th percentile we could consider:

1.  Does that 136KG floor value make sense?
2.  How many error values were there actually in the dataset?

Let’s first inspect that 1st and 100th percentile values carefully and inspect each value to see what happened!

### :triangular_flag_on_post: RANKING FUNCTIONS - ROW_NUMBER, RANK, DENSE_RANK

These are **Window Functions** for sorting values. The most important thing with ranking functions and what are the differences between them is to understand - **HOW DO WE DEAL WITH TIES?**

> :memo: **All Window Functions are analytical functions but not all analytical functions are window functions**

Let's understand by a simple analogy : 
Imagine we have 4 runners in a race - **Danny, Rowan, Abe and Christian**.

![enter image description here](https://github.com/mohammedsaqlainattar/Serious-SQL-Apprenticeship/blob/main/Images/Ranking%20Functions%20example.JPG?raw=true)

**RANK** - There's skipping of values whenever there is a tie.
`RANK()` ensures that duplicates have equal position, where the subsequent position after a set of duplicates is N + X (where X = number of duplicates).

**DENSE_RANK** - There is no skipping of values that come out of the ranking function, when it encounters a tie.
`DENSE_RANK()` also ensures that duplicates have equal position, but the subsequent position after a set of duplicates is N + 1.

**ROW_NUMBER** - Whenever there is a tie, it assigns an arbitrary number depending on where they are situated in the data even though they're exactly the same value. So, it's basically arbitrarily ranking ties.
`ROW_NUMBER()` orders each value depending on its position in the bucket, regardless of whether there are duplicates. Equation = N + 1.

:star2: **Example** :
```sql
WITH percentile_values AS (
  SELECT
    measure_value,
    NTILE(100) OVER (
      ORDER BY
        measure_value
    ) AS percentile
  FROM health.user_logs
  WHERE measure = 'weight'
)
SELECT
  measure_value,
  -- these are examples of window functions below
  ROW_NUMBER() OVER (ORDER BY measure_value DESC) as row_number_order,
  RANK() OVER (ORDER BY measure_value DESC) as rank_order,
  DENSE_RANK() OVER (ORDER BY measure_value DESC) as dense_rank_order
FROM percentile_values
WHERE percentile = 100
ORDER BY measure_value DESC;
```
|measure_value|row_number_order|rank_order|dense_rank_order|
|:----|:----|:----|:----|
|39642120|1|1|1|
|39642120|2|1|1|
|576484|3|3|2|
|200.487664|4|4|3|
|190.4|5|5|4|
|188.69427|6|6|5|
|186.8799|7|7|6|
|185.51913|8|8|7|
|175.086512|9|9|8|
|173.725736|10|10|9|
|170.5506|11|11|10|
|170.5506|12|11|10|
|170.5506|13|11|10|
|164|14|14|11|
|157.5778608|15|15|12|

### :round_pushpin: Large Outliers
So it looks like there are at least 3 HUGE values which are outliers in our weight values in that top percentile.
|measure_value|row_number_order|rank_order|dense_rank_order|
|:----|:----|:----|:----|
|39642120|1|1|1|
|39642120|2|1|1|
|576484|3|3|2|
|200.487664|4|4|3|

The last 200kg value MIGHT be a real measurement - so we would have to apply our judgement to determine whether this is actually an outlier or not.
The next question is: what do we do with them? - simple: you remove them!

### :round_pushpin: Small Outliers
Let’s again show all of those ordering window functions so you can take a look again - this time we will sort from smallest to largest so we will remove all of the `DESC` parts in our ranking query to end up with the following:

|measure_value|row_number_order|rank_order|dense_rank_order|
|:----|:----|:----|:----|
|0|1|1|1|
|0|2|1|1|
|1.814368|3|3|2|
|2.26796|4|4|3|
|2.26796|5|4|3|
|8|6|6|4|

It seems like there are a few 0 weight values as well as a few very small values.
Let's just remove the 0 values and keep everything else!

### :round_pushpin: Removing Outliers
To do this - we can simply use a  `WHERE`  filter with some SQL conditions.
Let’s create a temporary  `clean_weight_logs`  table with our outliers removed by applying strict inequality conditions.

1.  Create a temporary table using a  `CREATE TEMP TABLE <> AS`  statement
```sql
DROP TABLE IF EXISTS clean_weight_logs;
CREATE TEMP TABLE clean_weight_logs AS (
  SELECT *
  FROM health.user_logs
  WHERE measure = 'weight'
    AND measure_value > 0
    AND measure_value < 201
    -- (we can also use BETWEEN 1 AND 201)
);
```
2.  Calculate summary statistics on this new temp table
```sql
SELECT
  ROUND(MIN(measure_value), 2) AS minimum_value,
  ROUND(MAX(measure_value), 2) AS maximum_value,
  ROUND(AVG(measure_value), 2) AS mean_value,
  ROUND(
    -- this function actually returns a float which is incompatible with ROUND!
    -- we use this cast function to convert the output type to NUMERIC
    CAST(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY measure_value) AS NUMERIC),
    2
  ) AS median_value,
  ROUND(
    MODE() WITHIN GROUP (ORDER BY measure_value),
    2
  ) AS mode_value,
  ROUND(STDDEV(measure_value), 2) AS standard_deviation,
  ROUND(VARIANCE(measure_value), 2) AS variance_value
FROM clean_weight_logs;
```

|minimum_value|maximum_value|mean_value|median_value|mode_value|standard_deviation|variance_value|
|:----|:----|:----|:----|:----|:----|:----|
|1.81|200.49|80.76|75.98|68.49|26.91|724.29|

How does this compare to our original summary statistics on the weight values prior to our treatment of the outliers?

|minimum_value|maximum_value|mean_value|median_value|mode_value|standard_deviation|variance_value|
|:----|:----|:----|:----|:----|:----|:----|
|0|39642120|28786.85|75.98|68.49|1062759.55|1.12946E+12|

3.  Show the new cumulative distribution function with treated data

```sql
WITH percentile_values AS (
  SELECT
    measure_value,
    NTILE(100) OVER (ORDER BY measure_value) AS percentile
  FROM clean_weight_logs
)
SELECT
  percentile,
  MIN(measure_value) AS floor_value,
  MAX(measure_value) AS ceiling_value,
  COUNT(*) AS percentile_counts
FROM percentile_values
GROUP BY percentile
ORDER BY percentile;
```

|percentile|floor_value|ceiling_value|percentile_counts|
|:----|:----|:----|:----|
|1|1.814368|29.48348|28|
|2|29.48348|32.4771872|28|
|3|32.658623|35.380177|28|
|4|35.380177|36.74095|28|
|5|36.74095|37.194546|28|
|..|..|..|..|
|95|129.77278|130.52802|27|
|96|130.5389|131.54168|27|
|97|131.54169|132.6599|27|
|98|132.736|133.765|27|
|99|133.80965|136.0776|27|
|100|136.0776|200.487664|27|

### :triangular_flag_on_post: Data Visualization

Click on the top right little chart icon next to the blue `Run` button - Configure visualization - select Line option - hover over different parts of the chart - you will see a tooltip popup with additional information about that data point.

![SQLPad Viz](https://github.com/mohammedsaqlainattar/Serious-SQL-Apprenticeship/blob/main/Images/SQLPad%20viz.png?raw=true)

![Median Viz](https://github.com/mohammedsaqlainattar/Serious-SQL-Apprenticeship/blob/main/Images/Median%20Viz.png?raw=true)

![80th Percentile Viz](https://github.com/mohammedsaqlainattar/Serious-SQL-Apprenticeship/blob/main/Images/80th%20Percentile%20Viz.png?raw=true)

![Range Distribution Values and Percentiles](https://github.com/mohammedsaqlainattar/Serious-SQL-Apprenticeship/blob/main/Images/Range%20Distribution%20Values%20and%20Percentiles.png?raw=true)

### :triangular_flag_on_post: Histograms

![Normal Distribution](https://github.com/mohammedsaqlainattar/Serious-SQL-Apprenticeship/blob/main/Images/Normal%20Distribution.png?raw=true)

A histogram is essentially trying to mimic this bell curve but instead of having a smooth line only - we will have vertical bars that represent some range of the X-axis and the Y-value or the height of the bar will represent how many records exist in that range.

In PostgreSQL we have a  `WIDTH_BUCKET`  function that helps us split the range of values into a number of buckets we would like. Let’s again use our  `clean_weight_logs`  temporary dataset to perform these transformations.

One important thing to note is that we actually require the minimum and maximum values from the weight values to use as the ranges for this function.
```sql
SELECT
  MIN(measure_value) AS minimum_value,
  MAX(measure_value) AS maximum_value
FROM clean_weight_logs;
```
|minimum_value|maximum_value|
|:----|:----|
|1.814368|200.487664|

For our dataset - let’s take 0 as the minimum and 200 as the maximum and use 50 buckets for our visualization, we will also need the `AVG` from each bucket to use as our X-value location for the histogram:

```sql
SELECT
  WIDTH_BUCKET(measure_value, 0, 200, 50) AS bucket,
  AVG(measure_value) AS measure_value,
  COUNT(*) AS frequency
FROM clean_weight_logs
GROUP BY bucket
ORDER BY bucket;
```

|bucket|measure_value|frequency|
|:----|:----|:----|
|1|2.116762667|3|
|3|9.924138667|3|
|4|14.061352|2|
|5|18.14368|1|
|6|22.226008|2|
|7|26.64853|8|
|8|30.55509116|32|
|9|34.41613442|43|
|10|37.95278404|120|
|11|41.54462592|66|
|12|45.63419633|18|
|13|49.374735|8|
|14|53.62668816|22|
|15|57.43087518|52|
|16|62.7802731|197|
|17|65.85507871|410|
|18|69.01802695|220|
|19|74.55357018|184|
|20|78.34794395|307|
|21|81.03449969|66|
|22|86.43871084|79|
|23|89.95040369|129|
|24|93.84927092|71|
|25|97.50817396|131|
|26|101.9506805|64|
|27|106.1814394|40|
|28|109.318591|36|
|29|113.9617229|42|
|30|118.4711933|63|
|31|122.2072225|133|
|32|125.5701738|40|
|33|130.3593597|90|
|34|133.41501|65|
|35|136.7067054|14|
|36|141.1578304|1|
|37|144.695848|2|
|38|149.68536|1|
|40|157.5778608|1|
|42|164|1|
|43|170.5506|3|
|44|174.406124|2|
|47|186.199515|2|
|48|189.547135|2|
|51|200.487664|1|

Generate this visualization using SQLPad
![Histogram](https://github.com/mohammedsaqlainattar/Serious-SQL-Apprenticeship/blob/main/Images/Histogram.png?raw=true)

Although this chart is not quite a perfect bell curve - it’s representing how our data would look like!
However, CDF's are preferred over Histogram's because the shape of the Histogram purely depends on the number of bins and the histogram is very sensitive to outliers.
