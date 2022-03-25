# :clapper: Marketing Analytics Case Study Notes :dvd:

## :clipboard: Learning Outcomes :heavy_check_mark:

<details>
<summary>
Click here to view learning outcomes from this case study!
</summary>

The following SQL skills and concepts will be covered in this Case Study :

1.  Learning how to interpret ERDs (entity-relationship diagrams) for data literacy and business context 

-   Identify key columns of interest and how they are linked to other tables via foreign keys
-   Use ERDs to analyze the data types for different columns in database tables
-   Understand data context for various tables that cause inherent natural relationships between fields

2.  Introduction to all types of table joining operations

-   Simple joins: left, inner
-   More involved joins: cross, anti, left-semi, full outer
-   Combination set operations: union, union all, intersect, except

3.  Practical application of table joins

-   Joining multiple tables to combine disparate datasets into a single data structure
-   Joining interim SQL outputs for more advanced group-by, split, merge data hacking strategies
-   Performing table joins that use 2 or more table references in the  `ON`  condition
-   Using anti joins to exclude records in a sequential fashion

4.  Filtering, window functions and aggregates for analytics and ranking

-   Using  `ROW_NUMBER`  to effecively rank order records with equal ties
-   Using  `WHERE`  filters to extract ranked records
-   Using multiple aggregate functions with different target partitions and ordering expressions for efficient data analysis
-   Using aggregate group by clauses to generate unique customer level insights

5.  Case statements for data transformation and manipulation

-   Pivoting datasets from long to wide using  `MAX`  and  `CASE WHEN`
-   Manipulating actual data values using conditional logic for business translation purposes

6.  SQL scripting basics

-   Designing SQL workflows which can be easily understood and implemented
-   Managing multiple dependencies for downstream table joining operations by using temporary tables to store interim datasets

7.  Manipulating text data

-   Converting text columns to title case
-   Combining multiple text and numeric data type columns into a single text expression

</details>

***

## :pushpin: 1.0 Overview

Personalized customer emails based off marketing analytics is a winning formula for many digital companies, and this is exactly the initiative that the leadership team at **DVD Rental Co** has decided to tackle!

We have been asked to support the customer analytics team at DVD Rental Co who have been tasked with generating the necessary data points required to populate specific parts of this first-ever customer email campaign.
***

## :pushpin: 2.0 Key Business Requirements

The marketing team have shared with us a draft of the email they wish to send to their customers.

**Let's breakdown these requirements into chunks!**

![Email Template - target output](https://github.com/mohammedsaqlainattar/Serious-SQL-Apprenticeship/blob/main/Images/Marketing%20Analytics%20Case%20Study/Email%20Template%20-%20target%20output.png?raw=true)

### :triangular_flag_on_post: 2.1 Summarizing Requirements
1.  Identify top 2 categories for each customer based off their past rental history ( **Requirement** - :one: , :four: )
2.  For each customer recommend up to 3 popular unwatched films for each category ( **Requirement** - :three: , :six: )
3.  Generate 1st category insights that includes ( **Requirement** - :two: ) :
    -   How many total films have they watched in their top category?
    -   How many more films has the customer watched compared to the average DVD Rental Co customer?
    -   How does the customer rank in terms of the top X% compared to all other customers in this film category?
4.  Generate 2nd insights that includes ( **Requirement** - :five:) :
    -   How many total films has the customer watched in this category?
    -   What proportion of each customer’s total films watched does this count make?
5.  Identify each customer’s favorite actor and film count, then recommend up to 3 more unwatched films starring the same actor ( **Requirement** - :seven: , :eight: and :nine: )

### :triangular_flag_on_post: 2.2 Review ERD

The Analytics team at DVD Rental Co have created an **Entity-Relationship Diagram (ERD)** to highlight which tables in the `dvd_rentals` schema we should focus on.

There are a few things to note about ERDs:

-   All column names as well as the data type are shown for each table
-   Table indexes and foreign keys are usually highlighted to show the linkages between tables

Let's take a look at the data before we start finding solutions for our business requirements.

![ERD](https://github.com/mohammedsaqlainattar/Serious-SQL-Apprenticeship/blob/main/Images/Marketing%20Analytics%20Case%20Study/ERD.png?raw=true)

>**View 'Understanding the Data' section for detailed exploration of each table.**
***

## :pushpin: 3.0 Deciding Which Type of Table Joins to Use?? :thinking:

To answer this one question “What type of table join should we use?” we actually need to answer 3 additional questions! Let's call it a **Table Joining Checklist**
1.  **What is the purpose of joining these two tables?**
**a) What contextual hypotheses do we have about the data?**
**b) How can we validate these assumptions?**
2.  **What is the distribution of foreign keys within each table?**
3.  **How many unique foreign key values exist in each table?**

Failing to answer any of these 3 questions before you embark on a SQL table joining journey will harpoon your chances of actually getting the job done!

>:bulb: **Refer to 'Joining Multiple Tables' tutorial in the Marketing Analytics Case Study to go through the detailed explanation of these 3 questions!**
***

### :triangular_flag_on_post: 3.1 What is the purpose of joining these two tables?
- **a) What contextual hypotheses do we have about the data?**
- **b) How can we validate these assumptions?**

:memo: **2 Key Analytical Questions to consider before proceeding with Joins**

The same questions can be used for all scenarios and is not just limited to this specific table join!

> **1.  How many records exist per  `foreign key`  value in  `left`  and  `right`  tables?**
> **2.  How many overlapping and missing unique  `foreign key`  values are there between the two tables?**

Now here is where things could get tricky, as there are a few unknowns that we need to address as we are matching the  `inventory_id`  foreign key between the  `rental`  and  `inventory`  tables.

1.  How many records exist per  `inventory_id`  value in  `rental`  or  `inventory`  tables?
2.  How many overlapping and missing unique  `foreign key`  values are there between the two tables?
***

#### :white_check_mark: 3.1.1 The 2 Phase Approach to inspect and understand our data

**The best way to answer these follow up questions is usually in 2 separate phases.**

Firstly you should think about the actual problem and datasets in terms of what they mean in real life.
Whilst thinking through the problem - we want to generate some hypotheses or assumptions about the data.

#### :white_check_mark: 3.1.2 Validating Hypotheses with Data

![Data Hypothesis](https://github.com/mohammedsaqlainattar/Serious-SQL-Apprenticeship/blob/main/Images/Marketing%20Analytics%20Case%20Study/Data%20Hypothesis.JPG?raw=true)

Since we know that the  `rental`  table contains every single rental for each customer - it makes sense logically that each valid rental record in the  `rental`  table should have a relevant  `inventory_id`  record as people need to physically hire some item in the store.

Additionally - it also makes sense that a specific item might be rented out by multiple customers at different times as customers return the DVD as shown by the  `return_date`  column in the dataset.

Now when we think about the  `inventory`  table - it should follow that every item should have a unique  `inventory_id`  but there may also be multiple copies of a specific film.

From these 2 key pieces of real life insight - we can generate some hypotheses about our 2 datasets.

#### :round_pushpin: Hypothesis 1

> **The number of unique `inventory_id` records will be equal in both `dvd_rentals.rental` and `dvd_rentals.inventory` tables**

**Rental Results**
```sql
SELECT
  COUNT(DISTINCT inventory_id)
FROM dvd_rentals.rental;
```
|count|
|:---:|
|4580|

**Inventory Results**
```sql
SELECT
  COUNT(DISTINCT inventory_id)
FROM dvd_rentals.inventory;
```
|count|
|:---:|
|4581|

**Findings**

There seems to be 1 additional inventory_id value in the  `dvd_rentals.inventory`  table compared to the  `dvd_rentals.rental`  table

This warrants further investigation but it seems to invalidate our first hypothesis.

#### :round_pushpin: Hypothesis 2

> **There will be a multiple records per unique `inventory_id` in the `dvd_rentals.rental` table**

We follow these 2 simple steps to summarise our dataset:

1.  Perform a  `GROUP BY`  record count on the target column (inventory_id)
2.  Summarise the record count output to show the distribution of records by unique count of the target column

```sql
-- first generate group by counts on the target_column_values column
WITH counts_base AS (
SELECT
  inventory_id AS target_column_values,
  COUNT(*) AS row_counts
FROM dvd_rentals.rental
GROUP BY target_column_values
)
-- summarize the group by counts above by grouping again on the row_counts from counts_base CTE part
SELECT
  row_counts,
  COUNT(target_column_values) as count_of_target_values
FROM counts_base
GROUP BY row_counts
ORDER BY row_counts;
```
|row_counts|count_of_target_values|
|:----|:----|
|1|4|
|2|1,126|
|3|1,151|
|4|1,160|
|5|1,139|

**Findings**

We can indeed confirm that there are multiple rows per  `inventory_id`  value in our  `dvd_rentals.rental`  table.

#### :round_pushpin: Hypothesis 3

> **There will be multiple `inventory_id` records per unique `film_id` value in the `dvd_rentals.inventory` table**

```sql
-- first generate group by counts on the target_column_values column
WITH counts_base AS (
SELECT
  film_id AS target_column_values,
  COUNT(DISTINCT inventory_id) AS unique_record_counts
FROM dvd_rentals.inventory
GROUP BY target_column_values
)
-- summarize the group by counts above by grouping again on the row_counts from counts_base CTE part
SELECT
  unique_record_counts,
  COUNT(target_column_values) as count_of_target_values
FROM counts_base
GROUP BY unique_record_counts
ORDER BY unique_record_counts;
```
|unique_record_counts|count_of_target_values|
|:----|:----|
|2|133|
|3|131|
|4|183|
|5|136|
|6|187|
|7|116|
|8|72|

**Findings**

We can confirm that there are indeed multiple unique  `inventory_id`  per  `film_id`  value in the  `dvd_rentals.inventory`  table.
***

### :triangular_flag_on_post: 3.2 What is the distribution of foreign keys within each table?

#### :white_check_mark: 3.2.1 Returning to the 2 Key Analytical Questions

1.  **How many records exist per  `inventory_id`  value in  `rental`  or  `inventory`  tables?**
2.  **How many overlapping and missing unique  `foreign key`  values are there between the two tables?**

:one: **Let's answer the 1st question**

> **How many records exist per  `inventory_id`  value in  `rental`  or  `inventory`  tables?**

We are inspecting the distribution of foreign key values and identifying the relationship between the foreign key and the rows of each left and right table

One of the first places to start inspecting our datasets is to look at the distribution of foreign key values in both  `rental`  and  `inventory`  tables used for our join.

The distribution and relationship within the table by the foreign keys is super important because it helps us inspect what our table joining inputs consist of and also determines what sort of outputs we should expect after joining.

**`rental`  distribution analysis on  `inventory_id`  foreign key**
```sql
-- first generate group by counts on the foreign_key_values column
WITH counts_base AS (
SELECT
  inventory_id AS foreign_key_values,
  COUNT(*) AS row_counts
FROM dvd_rentals.rental
GROUP BY foreign_key_values
)
-- summarize the group by counts above by grouping again on the row_counts from counts_base CTE part
SELECT
  row_counts,
  COUNT(foreign_key_values) as count_of_foreign_keys
FROM counts_base
GROUP BY row_counts
ORDER BY row_counts;
```

|row_counts|count_of_target_values|
|:----|:----|
|1|4|
|2|1,126|
|3|1,151|
|4|1,160|
|5|1,139|

**`inventory`  distribution analysis on  `inventory_id`  foreign key**
```sql
WITH counts_base AS (
SELECT
  inventory_id AS foreign_key_values,
  COUNT(*) AS row_counts
FROM dvd_rentals.inventory
GROUP BY foreign_key_values
)
SELECT
  row_counts,
  COUNT(foreign_key_values) as count_of_foreign_keys
FROM counts_base
GROUP BY row_counts
ORDER BY row_counts;
```

|row_counts|count_of_foreign_keys|
|:----|:----|
|1|4,581|

**Findings**

We can see in the  `rental`  table - there exists different multiple row counts for some values of the foreign keys - this is not unexpected, in fact we did exactly the same analysis previously to validate our first data hypothesis!

To break it down - we can see that 4 of our foreign key values (the  `inventory_id`  in this case) will have only a single row in the  `rental_table`.

Additionally in the  `rental`  table - there are 1,126  `inventory_id`  values which exist in 2 different rows and 1,151 in 3 different rows and so on.

This can also be referred to as a a 1-to-many relationship for the  `inventory_id`  in this  `rental`  table, or in other words - there may exist 1 or more record for each unique  `inventory_id`  value in this table.

|row_counts|count_of_target_values|
|:----|:----|
|1|4|
|2|1,126|
|3|1,151|
|4|1,160|
|5|1,139|

When we inspect the `dvd_rentals.inventory` table foreign key analysis using the same approach - we notice that there is only 1 row in the analysis output:

|row_counts|count_of_foreign_keys|
|:----|:----|
|1|4,581|

This essentially says that for every single unique `inventory_id` value in the `inventory` table - there exists only 1 table row record - this is the exact definition of a 1-to-1 relationship.

### :triangular_flag_on_post: 3.3 How many unique foreign key values exist in each table?

:two: **Now onto the second question:**

>**How many overlapping and missing unique  `foreign key`  values are there between the two tables?**

![Table Overlap Analysis](https://github.com/mohammedsaqlainattar/Serious-SQL-Apprenticeship/blob/main/Images/Marketing%20Analytics%20Case%20Study/Foreign%20Key%20Overlap%20Analysis.JPG?raw=true)

Firstly - let’s count how many unique keys are present in the left(rental) table:

```sql
-- how many foreign keys only exist in the left table and not in the right?
SELECT
  COUNT(DISTINCT rental.inventory_id)
FROM dvd_rentals.rental
WHERE NOT EXISTS (
  SELECT inventory_id
  FROM dvd_rentals.inventory
  WHERE rental.inventory_id = inventory.inventory_id
);
```
|count|
|:----|
|0|

Great we can confirm that there are no `inventory_id` records which appear in the `dvd_rentals.rental` table which does not appear in the `dvd_rentals.inventory` table.

Now onto the right side table:

```sql
-- how many foreign keys only exist in the right table and not in the left?
-- note the table reference changes
SELECT
  COUNT(DISTINCT inventory.inventory_id)
FROM dvd_rentals.inventory
WHERE NOT EXISTS (
  SELECT inventory_id
  FROM dvd_rentals.rental
  WHERE rental.inventory_id = inventory.inventory_id
);
```
|count|
|:----|
|1|

Ok - we’ve spotted a single `inventory_id` record. Let’s inspect further:

```sql
SELECT *
FROM dvd_rentals.inventory
WHERE NOT EXISTS (
  SELECT inventory_id
  FROM dvd_rentals.rental
  WHERE rental.inventory_id = inventory.inventory_id
);
```

|inventory_id|film_id|store_id|last_update|
|:----|:----|:----|:----|
|5|1|2|15/02/2006 5:09|

One such reason for this odd record could be that this specific rental inventory unit was never rented out by a customer.
***

### :triangular_flag_on_post: 3.4 Implementing the Join(s) between rental and inventory table

After performing this analysis we can conclude there is in fact no difference between running a  `LEFT JOIN`  or an  `INNER JOIN`  in our example!

We can finally implement our joins and prove this is the case by inspecting the raw row counts from the resulting join outputs.

Let’s also confirm that the unique  `inventory_id`  records are the same too.

```sql
DROP TABLE IF EXISTS left_rental_join;
CREATE TEMP TABLE left_rental_join AS
SELECT
  rental.customer_id,
  rental.inventory_id,
  inventory.film_id
FROM dvd_rentals.rental
LEFT JOIN dvd_rentals.inventory
  ON rental.inventory_id = inventory.inventory_id;

DROP TABLE IF EXISTS inner_rental_join;
CREATE TEMP TABLE inner_rental_join AS
SELECT
  rental.customer_id,
  rental.inventory_id,
  inventory.film_id
FROM dvd_rentals.rental
INNER JOIN dvd_rentals.inventory
  ON rental.inventory_id = inventory.inventory_id;

-- check the counts for each output (bonus UNION usage)
-- note that these parantheses are not really required but it makes
-- the code look and read a bit nicer!
(
  SELECT
    'left join' AS join_type,
    COUNT(*) AS record_count,
    COUNT(DISTINCT inventory_id) AS unique_key_values
  FROM left_rental_join
)
UNION
(
  SELECT
    'inner join' AS join_type,
    COUNT(*) AS record_count,
    COUNT(DISTINCT inventory_id) AS unique_key_values
  FROM inner_rental_join
);
```

|join_type|record_count|unique_key_values|
|:----|:----|:----|
|inner join|16044|4580|
|left join|16044|4580|

Great! In this example - we can indeed confirm that there is no difference between an **inner join** or **left join** for our datasets!

In practice however - running through all of these steps at this fine level of granularity is required to perfect table joining technique but over time you will develop strong intuition and likely you will skip a few of these steps after inspecting the data by hand - and this is totally fine!

### :triangular_flag_on_post: 3.5 In Summary

>1.  **What is the purpose of joining these two tables?**

We need to keep all of the customer rental records from `dvd_rentals.rental` and match up each record with its equivalent `film_id` value from the `dvd_rentals.inventory` table.

>2.  **What is the distribution of foreign keys within each table?**

There is a 1-to-many relationship between the `inventory_id` and the rows of the `dvd_rentals.rental` table

|row_counts|count_of_target_values|
|:----|:----|
|1|4|
|2|1,126|
|3|1,151|
|4|1,160|
|5|1,139|

There is a 1-to-1 relationship between the `inventory_id` and the rows of the `dvd_rentals.inventory` table.

|row_counts|count_of_foreign_keys|
|:----|:----|
|1|4,581|

>3.  **How many unique foreign key values exist in each table?**

All of the foreign key values in  `dvd_rentals.rental`  exist in  `dvd_rentals.inventory`  and only 1 record  `inventory_id = 5`  exists only in the  `dvd_rentals.inventory`  table.

There is an overlap of 4,580 unique inventory_id foreign key values which will exist after the join is complete.

### :triangular_flag_on_post: 3.6 Joins Part 2

When we are investigating the joining components - it is often best to deal with each table join component separately before combining all the joins.

**Let’s perform the checklist steps for just the  `dvd_rentals.inventory`  and  `dvd_rentals.film`  tables.**

> 1.  **What is the purpose of joining these two tables?**

We want to match the films on  `film_id`  to obtain the  `title`  of each film.

> a.  **What contextual hypotheses do we have about the data?**

There should be 1-to-many relationship for  `film_id`  and the rows of the  `dvd_rentals.inventory`  table as one specific film might have multiple copies to be purchased at the rental store.

There should be 1-to-1 relationship for  `film_id`  and the rows of the  `dvd_rentals.film`  table as it doesn’t make sense for there to be duplicates in this  `dvd_rentals.film`  - yes that’s actually a legitimate reason to generate a hypothesis - we use this argument a lot when we are dealing with data problems!

The saying is - if something doesn’t make sense - you should test it, preferably with data!

> b.  **How can we validate these assumptions?**

Generate the row counts for  `film_id`  for both the  `dvd_rentals.inventory`  and  `dvd_rentals.film`  tables - note that this also helps us with part 2 of the table joining checklist!

Let’s use a summarized group by with a CTE for the  `dvd_rentals.inventory`  table:

```sql
WITH base_counts AS (
SELECT
  film_id,
  COUNT(*) AS record_count
FROM dvd_rentals.inventory
GROUP BY film_id
)
SELECT
  record_count,
  COUNT(DISTINCT film_id) as unique_film_id_values
FROM base_counts
GROUP BY record_count
ORDER BY record_count;
```
|record_count|unique_film_id_values|
|:----|:----|
|2|133|
|3|131|
|4|183|
|5|136|
|6|187|
|7|116|
|8|72|

Confirmed - we have a 1-to-many relationship for the  `film_id`  foreign key in our  `dvd_rentals.inventory_table`

Now we just need to confirm that there are indeed only single records for the  `dvd_rentals.film`  table so we can use this query with a  `LIMIT`  as long as we are ordering by the  `record_count`  descending - if you see a number larger than 1 for the  `record_count`  field - it means that you have conclusive evidence that the table is not a 1-to-1 table!

```sql
SELECT
  film_id,
  COUNT(*) AS record_count
FROM dvd_rentals.film
GROUP BY film_id
ORDER BY record_count DESC
LIMIT 5;
```
|film_id|record_count|
|:----|:----|
|273|1|
|51|1|
|951|1|
|839|1|
|652|1|

We can now also confirm that there is a 1-to-1 relationship in the  `dvd_rentals.film`

> 2.  **What is the distribution of foreign keys within each table?**

We already did this with our previouis summarized group by count when confirming our hypotheses for both tables.

> 3.  **How many unique foreign key values exist in each table?**

We will use our same anti join approach to figure out the overlaps and exlusions as per the venn diagram previously.

```sql
-- how many foreign keys only exist in the inventory table
SELECT
  COUNT(DISTINCT inventory.film_id)
FROM dvd_rentals.inventory
WHERE NOT EXISTS (
  SELECT film_id
  FROM dvd_rentals.film
  WHERE film.film_id = inventory.film_id
);
```
|count|
|:----|
|0|

We can conclude that all of the  `film_id`  records from the  `dvd_rentals.inventory`  table exists in the  `dvd_rentals.film`  table.

Let’s check the other side now.

```sql
-- how many foreign keys only exist in the film table
SELECT
  COUNT(DISTINCT film.film_id)
FROM dvd_rentals.film
WHERE NOT EXISTS (
  SELECT film_id
  FROM dvd_rentals.inventory
  WHERE film.film_id = inventory.film_id
);
```
|count|
|:----|
|42|

Alright we have a discrepancy between the foreign key values - here we see a much larger count of keys which exist in the  `dvd_rentals.film`  table than in the  `dvd_rentals.inventory`  table.

Finally - let’s check that total count of distinct foreign key values that will be generated when we use a left semi join on our  `dvd_rentals.inventory`  as our base left table.

```sql
SELECT
  COUNT(DISTINCT film_id)
FROM dvd_rentals.inventory
-- note how the NOT is no longer here for a left semi join
-- compared to the anti join!
WHERE EXISTS (
  SELECT film_id
  FROM dvd_rentals.film
  WHERE film.film_id = inventory.film_id
);
```

|count|
|:----|
|958|

We will be expecting a total distinct count of `film_id` values of 958 once we perform the final join between our 2 tables.

We will be repeating these same steps to join all the necessary tables for our analysis.
***

## :pushpin: 4.0 Final Joint Dataset

```sql
DROP TABLE IF EXISTS complete_joint_dataset;
CREATE TEMP TABLE complete_joint_dataset AS
SELECT
  rental.customer_id,
  inventory.film_id,
  film.title,
  film_category.category_id,
  category.name AS category_name
FROM dvd_rentals.rental
INNER JOIN dvd_rentals.inventory
  ON rental.inventory_id = inventory.inventory_id
INNER JOIN dvd_rentals.film
  ON inventory.film_id = film.film_id
INNER JOIN dvd_rentals.film_category
  ON film.film_id = film_category.film_id
INNER JOIN dvd_rentals.category
  ON film_category.category_id = category.category_id;

SELECT * FROM complete_joint_dataset limit 10;
```
|customer_id|film_id|title|category_id|category_name|
|:----|:----|:----|:----|:----|
|130|80|BLANKET BEVERLY|8|Family|
|459|333|FREAKY POCUS|12|Music|
|408|373|GRADUATE LORD|3|Children|
|333|535|LOVE SUICIDES|11|Horror|
|222|450|IDOLS SNATCHERS|3|Children|
|549|613|MYSTIC TRUMAN|5|Comedy|
|269|870|SWARM GOLD|11|Horror|
|239|510|LAWLESS VISION|2|Animation|
|126|565|MATRIX SNOWMAN|9|Foreign|
|399|396|HANGING DEEP|7|Drama|

We will use this base table as our starting point as we work towards the customer level insights and the film recommendations.
***

## :pushpin: 5.0 SQL Problem Solving

We can generate each customers’ aggregated `rental_count` values for every `category_name` value from our `complete_joint_dataset` temporary table.

Let’s also sort the output by customer_id and show the `rental_count` from largest to smallest for each customer:

```sql
SELECT
  customer_id,
  category_name,
  COUNT(*) AS rental_count
FROM complete_joint_dataset
WHERE customer_id in (1, 2, 3)
GROUP BY
  customer_id,
  category_name
ORDER BY
  customer_id,
  rental_count DESC;
```

Let's look at the output only for **customer 3** :
|customer_id|category_name|rental_count|
|:----|:----|:----|
|3|Action|4|
|3|Sci-Fi|3|
|3|Animation|3|
|3|Horror|2|
|3|Sports|2|
|3|Comedy|2|
|3|New|2|
|3|Music|2|
|3|Games|2|
|3|Classics|1|
|3|Family|1|
|3|Drama|1|
|3|Documentary|1|

### :triangular_flag_on_post: 5.1 Top 2 Category Per Customer

Let’s now imagine that we go ahead and trim our dataset keeping only the top 2 categories for each customer - we would get the following results below.

Looking at only customer 2 and 3 :

|customer_id|category_name|rental_count|
|:----|:----|:----|
|2|Sports|5|
|2|Classics|4|

|customer_id|category_name|rental_count|
|:----|:----|:----|
|3|Action|4|
|3|Sci-Fi|3|
|3|Animation|3|

Customer 3 is an edge case where it just so happens that both `Sci-Fi` and `Animation` categories have a `rental_count` value of 3 - let’s dive into this a bit more.

#### :white_check_mark: 5.1.1 How are we going to deal with ties

There are multiple ways you can deal with these “equal” ranking row ties:

1.  Sort the values further by an additional condition or criteria
2.  Randomly select a single row

In most cases - you do not want to randomly select single rows as this is **not reproducible** - meaning that often the behaviour will change each time you run the SQL query.

A super simple method to execute might be to just sort the category_name fields alphabetically - it might not be the “best” solution for our customer experience, but it might just work.
However, for our email example (and in general) we should consider how a customer might respond as a result of certain decisions like this.

**For our example**, one really common sorting method is to look at the most recent purchase or rental and sort by some recency metric based on when the last purchase was made.
We could propose that we investigate when the latest rental was completed for each category - if we had this `rental_date` value for each individual rental record, we could easily find the `MAX(rental_date)` value for each `customer_id` and `category_name` combination.

Let's include this `rental_date` column in our **complete_joint_dataset_with_rental_date**.

```sql
--firstly bring in rental_date as a field from the table joins
DROP TABLE IF EXISTS complete_joint_dataset_with_rental_date;
CREATE TEMP TABLE complete_joint_dataset_with_rental_date AS
SELECT
  rental.customer_id,
  inventory.film_id,
  film.title,
  category.name AS category_name,
  rental.rental_date
FROM dvd_rentals.rental
INNER JOIN dvd_rentals.inventory
  ON rental.inventory_id = inventory.inventory_id
INNER JOIN dvd_rentals.film
  ON inventory.film_id = film.film_id
INNER JOIN dvd_rentals.film_category
  ON film.film_id = film_category.film_id
INNER JOIN dvd_rentals.category
  ON film_category.category_id = category.category_id
```
```sql
-- Finally perform group by aggregations on category_name and customer_id
SELECT
  customer_id,
  category_name,
  COUNT(*) AS rental_count,
  MAX(rental_date) AS latest_rental_date
FROM complete_joint_dataset_with_rental_date
-- note the different filter here!
WHERE customer_id = 3
GROUP BY
  customer_id,
  category_name
ORDER BY
  customer_id,
  rental_count DESC,
  latest_rental_date DESC;
```
**Customer 3**
|customer_id|category_name|rental_count|latest_rental_date|
|:----|:----|:----|:----|
|3|Action|4|2005-07-29 11:07:04|
|3|Sci-Fi|3|2005-08-22 09:37:27|
|3|Animation|3|2005-08-18 14:49:55|
|3|Music|2|2005-08-23 07:10:14|
|3|Comedy|2|2005-08-20 06:14:12|
|3|Horror|2|2005-07-31 11:32:58|
|3|Sports|2|2005-07-30 13:31:20|
|3|New|2|2005-07-28 04:46:30|
|3|Games|2|2005-07-27 04:54:42|
|3|Classics|1|2005-08-01 14:19:48|
|3|Family|1|2005-07-31 03:27:58|
|3|Drama|1|2005-07-30 21:45:46|
|3|Documentary|1|2005-06-19 08:34:53|

We can see that Customer 3 most recent rental was from the **Sci-Fi category** - so we can use this additional criteria to sort the output and select the 2nd ranking category!

#### :white_check_mark: 5.1.2 Calculating Averages on Top 2 Categories

So now that we have all of our customers top 2 categories - let’s see what happens when we try to calculate the average on only just the top 2 categories dataset:

|customer_id|category_name|rental_count|
|:----|:----|:----|
|1|Classics|6|
|1|Comedy|5|
|2|Sports|5|
|2|Classics|4|
|3|Action|4|
|3|Sci-Fi|3|

It should seem pretty clear that we have already experienced some sort of “data loss” - all of the  `Classics`  category films that customer 3 has watched are no longer in this existing dataset, and the same can be said about all of the other non top 2 category rental_count values for all of the other categories in the  `top_2_category_rental_count`  dataset.

If we were to calculate the average of all customer’s  `Classics`  films - there is actually no record for customer 3 and now the average is heavily skewed to only customers who have  `Classics`  as one of their top 2 categories - **this is a big problem!**

Let's compare our averages with the original aggregated `rental_count` values for all of our categories :

```sql
WITH aggregated_rental_count AS (
  SELECT
    customer_id,
    category_name,
    COUNT(*) AS rental_count
  FROM complete_joint_dataset
  WHERE customer_id in (1, 2, 3)
  GROUP BY
    customer_id,
    category_name
  /* -- we remove this order by because we don't need it here!
     ORDER BY
     customer_id,
     rental_count DESC
  */
)
SELECT
  category_name,
  -- round out large decimals to just 1 decimal point
  ROUND(AVG(rental_count), 1) AS avg_rental_count
FROM aggregated_rental_count
GROUP BY
  category_name
-- this will sort our output in alphabetical order
ORDER BY
  category_name;
```

|category_name|avg_rental_count|
|:----|:----|
|Action|3|
|Animation|2.7|
|Children|1|
|Classics|3.7|
|Comedy|3.5|
|Documentary|1|
|Drama|2.5|
|Family|1|
|Foreign|1|
|Games|1.7|
|Horror|2|
|Music|1.7|
|New|2|
|Sci-Fi|2|
|Sports|3|
|Travel|1.5|

Let’s try calculating the same average rental count values for the `top_2_category_rental_count` dataset so we can compare them with the same values for the entire dataset.

```sql
SELECT
  category_name,
  -- round out large decimals to just 1 decimal point
  ROUND(AVG(rental_count), 1) AS avg_rental_count
FROM top_2_category_rental_count
GROUP BY
  category_name
-- this will sort our output in alphabetical order
ORDER BY
  category_name;
```

|category_name|avg_rental_count|
|:----|:----|
|Action|4|
|Classics|5|
|Comedy|5|
|Sci-Fi|3|
|Sports|5|

And when we compare just the categories which show up in the `top_2_category` values - we can see quite a large discrepancy in values!

|category_name|top_2_average|all_category_average|
|:----|:----|:----|
|Action|4.0|3.0|
|Classics|5.0|3.7|
|Comedy|5.0|3.5|
|Sci-Fi|3.0|2.0|
|Sports|5.0|3.0|

**An Alternative?** - We can just use the entire dataset for some of these calculations **BEFORE** we isolate the first 2 categories for our final output.

### :triangular_flag_on_post: 5.2 Data Aggregation on Whole Dataset

We will need to aggregate the `rental_count` values for each of our customers and category values, however this time - we will do our aggregations on the whole `complete_joint_dataset` temporary table we created earlier.

We will split up each part of our various aggregations and calculations into separate temporary tables.

Let's refer to our **complete_joint_dataset_with_rental_date** again.

```sql
--firstly bring in rental_date as a field from the table joins
DROP TABLE IF EXISTS complete_joint_dataset_with_rental_date;
CREATE TEMP TABLE complete_joint_dataset_with_rental_date AS
SELECT
  rental.customer_id,
  inventory.film_id,
  film.title,
  category.name AS category_name,
  rental.rental_date
FROM dvd_rentals.rental
INNER JOIN dvd_rentals.inventory
  ON rental.inventory_id = inventory.inventory_id
INNER JOIN dvd_rentals.film
  ON inventory.film_id = film.film_id
INNER JOIN dvd_rentals.film_category
  ON film.film_id = film_category.film_id
INNER JOIN dvd_rentals.category
  ON film_category.category_id = category.category_id;
```

#### :white_check_mark: 5.2.1 Customer Rental Count

```sql
DROP TABLE IF EXISTS category_rental_counts;
CREATE TEMP TABLE category_rental_counts AS
SELECT
  customer_id,
  category_name,
  COUNT(*) AS rental_count,
  MAX(rental_date) AS latest_rental_date
FROM complete_joint_dataset_with_rental_date
GROUP BY
  customer_id,
  category_name;

-- profile just customer_id = 1 values sorted by desc rental_count
SELECT *
FROM category_rental_counts
WHERE customer_id = 1
ORDER BY
  rental_count DESC
  latest_rental_date DESC;
```

|customer_id|category_name|rental_count|latest_rental_date|
|:----|:----|:----|:----|
|1|Classics|6|19/08/2005 9:55|
|1|Comedy|5|22/08/2005 19:41|
|1|Drama|4|18/08/2005 3:57|
|1|Sci-Fi|2|21/08/2005 23:33|
|1|Animation|2|22/08/2005 20:03|
|1|Sports|2|08/07/2005 7:33|
|1|Music|2|09/07/2005 16:38|
|1|Action|2|17/08/2005 12:37|
|1|New|2|19/08/2005 13:56|
|1|Travel|1|11/07/2005 10:13|
|1|Family|1|02/08/2005 18:01|
|1|Documentary|1|01/08/2005 8:51|
|1|Games|1|08/07/2005 3:17|
|1|Foreign|1|28/07/2005 16:18|

#### :white_check_mark: 5.2.2 Total Customer Rentals

In order to generate the `category_percentage` calculation we will need to get the total rentals per customer.

```sql
DROP TABLE IF EXISTS customer_total_rentals;
CREATE TEMP TABLE customer_total_rentals AS
SELECT
  customer_id,
  SUM(rental_count) AS total_rental_count
FROM category_rental_counts
GROUP BY customer_id;

-- show output for first 5 customer_id values
SELECT *
FROM customer_total_rentals
WHERE customer_id <= 5
ORDER BY customer_id;
```

|customer_id|total_rental_count|
|:----|:----|
|1|32|
|2|27|
|3|26|
|4|22|
|5|38|

#### :white_check_mark: 5.2.3 Average Category Rental Counts

```sql
DROP TABLE IF EXISTS average_category_rental_counts;
CREATE TEMP TABLE average_category_rental_counts AS
SELECT
  category_name,
  AVG(rental_count) AS avg_rental_count
FROM category_rental_counts
GROUP BY
  category_name;

-- output the entire table by desc avg_rental_count
SELECT *
FROM average_category_rental_counts
ORDER BY
  avg_rental_count DESC;
```

|category_name|avg_rental_count|
|:----|:----|
|Animation|2.332|
|Sports|2.271676301|
|Family|2.18762475|
|Action|2.180392157|
|Documentary|2.173913043|
|Sci-Fi|2.171597633|
|Drama|2.115768463|
|Foreign|2.095334686|
|Games|2.044303797|
|New|2.008547009|
|Classics|2.006410256|
|Children|1.960580913|
|Comedy|1.901010101|
|Travel|1.893665158|
|Horror|1.875831486|
|Music|1.856823266|

#### :white_check_mark: 5.2.4 Update Table Values

Since it might seem a bit weird to be telling customers that they watched 1.346 more films than the average customer - let’s make an executive decision and just take the `FLOOR` value of the decimal to show our customers that they watch more films (as opposed to if we rounded the number to the nearest integer!)

```sql
UPDATE average_category_rental_counts
SET avg_rental_count = FLOOR(avg_rental_count)
RETURNING *;
```
|category_name|avg_rental_count|
|:----|:----|
|Sports|2|
|Classics|2|
|New|2|
|Family|2|
|Comedy|1|
|Animation|2|
|Travel|1|
|Music|1|
|Horror|1|
|Drama|2|
|Sci-Fi|2|
|Games|2|
|Documentary|2|
|Foreign|2|
|Action|2|
|Children|1|

#### :white_check_mark: 5.2.5 Percentile Values

>**`percentile`: How does the customer rank in terms of the top X% compared to all other customers in this film category?**

![enter image description here](https://github.com/mohammedsaqlainattar/Serious-SQL-Apprenticeship/blob/main/Images/Marketing%20Analytics%20Case%20Study/Point%203.png?raw=true)

![Normal Distribution](https://github.com/mohammedsaqlainattar/Serious-SQL-Apprenticeship/blob/main/Images/Marketing%20Analytics%20Case%20Study/Normal%20Distribution.png?raw=true)

This distribution chart above is a good representation of the same problem we’re facing with this `percentile` calculation. In the above example - the average test score was 60/100 but my score was 95/100 - landing me in the top 1% of all test takers - or if we interpret the numbers in the chart below, I beat 99% of all the other test takers.

So in the same way as me beating the 99% - we need to now generate this same `percentile` value for each customer when comparing their result - the number of films they’ve watched in a certain category - with all other customer rental counts in that category!

#### :white_check_mark: 5.2.6 Percent Rank Window Function

We can use the `PERCENT_RANK` window function to easily generate our `percentile` calculated field - however it only generates decimal percentages from 0 to 1.

We can use our aggregated `rental_count` values at a `customer_id` and `category_level` in the `category_rental_counts` temp table we created earlier to generate the required output like so - let’s first inspect the results for `customer_id = 1` for all of their records:

```sql
SELECT
  customer_id,
  category_name,
  rental_count,
  PERCENT_RANK() OVER (
    PARTITION BY category_name
    ORDER BY rental_count DESC
  ) AS percentile
FROM category_rental_counts
ORDER BY customer_id, rental_count DESC
LIMIT 14;
```

|customer_id|category_name|rental_count|percentile|
|:----|:----|:----|:----|
|1|Classics|6|0.002141328|
|1|Comedy|5|0.006072874|
|1|Drama|4|0.03|
|1|Animation|2|0.388777555|
|1|New|2|0.267665953|
|1|Action|2|0.333988212|
|1|Music|2|0.204035874|
|1|Sports|2|0.345559846|
|1|Sci-Fi|2|0.300395257|
|1|Documentary|1|0.643153527|
|1|Games|1|0.600422833|
|1|Foreign|1|0.617886179|
|1|Family|1|0.654|
|1|Travel|1|0.575963719|

Notice how the percentile values are very low for the  `Classics`  category - the top ranking record for our customer.

Firstly we will need to multiply the  `PERCENT_RANK`  output by 100 to make it go from a decimal between 0 and 1 to an actual percentage number between 0 and 100.

However - even if we rounded that new percentile metric to the nearest integer for the  `Classics`  record - it would still show the value  `0`  - which might look a bit weird when we generate our customer insight for the email template!

So instead of rounding - let’s just use the `CEILING` function to take the upper integer for each of those percentile metrics after we multiply by 100 to bring our decimal value between 0 and 1 to a new value between 0 and 100!

```sql
SELECT
  customer_id,
  category_name,
  rental_count,
  -- use ceiling to round up to nearest integer after multiplying by 100
  CEILING(
    100 * PERCENT_RANK() OVER (
      PARTITION BY category_name
      ORDER BY rental_count DESC
    )
  ) AS percentile
FROM category_rental_counts
ORDER BY customer_id, rental_count DESC
LIMIT 1;
```

|customer_id|category_name|rental_count|percentile|
|:----|:----|:----|:----|
|1|Classics|6|1|

Great - this will make much more sense to our customers now!

> **You’ve watched 6 Classics films, that’s 4 more than the DVD Rental Co average and puts you in the top 1% of Classics gurus!**

Let's create a separate temporary table just like all the other components - we can also remove that `rental_count` column from the table as we will already have the information from our `category_rental_counts` table for use in our next step.

We will also use a `CASE WHEN` to replace a `0` ranking value to `1` as it doesn’t make sense for the customer to be in the `Top 0%`!

```sql
DROP TABLE IF EXISTS customer_category_percentiles;
CREATE TEMP TABLE customer_category_percentiles AS
SELECT
  customer_id,
  category_name,
  -- use ceiling to round up to nearest integer after multiplying by 100
  CEILING(
    100 * PERCENT_RANK() OVER (
      PARTITION BY category_name
      ORDER BY rental_count DESC
    )
  ) AS percentile
FROM category_rental_counts;

UPDATE customer_category_percentiles  -- Updating to change percentile=0 to 1 
SET percentile = CASE
                  WHEN percentile = 0 THEN 1
                  ELSE percentile
                  END
RETURNING *;

-- inspect top 2 records for customer_id = 1 sorted by ascending percentile
SELECT *
FROM customer_category_percentiles
WHERE customer_id = 1
ORDER BY customer_id, percentile
LIMIT 2;
```

|customer_id|category_name|percentile|
|:----|:----|:----|
|1|Classics|1|
|1|Comedy|1|
***

## :pushpin: 6.0 Using Our Temporary Tables

So now we have a few separate temporary tables which we’ve generated from the previous steps:

1. **Table 1** -  `category_rental_counts`
```sql
SELECT *
FROM category_rental_counts
WHERE customer_id = 1
ORDER BY rental_count DESC
LIMIT 5;
```
|customer_id|category_name|rental_count|
|:----|:----|:----|
|1|Classics|6|
|1|Comedy|5|
|1|Drama|4|
|1|Music|2|
|1|Sports|2|


2. **Table 2** -  `customer_total_rentals`
```sql
SELECT *
FROM customer_total_rentals
LIMIT 5;
```
|customer_id|total_rental_count|
|:----|:----|
|184|23|
|87|30|
|477|22|
|273|35|
|550|32|

3. **Table 3** -  `average_category_rental_counts`
```sql
SELECT *
FROM average_category_rental_counts
LIMIT 5;
```
|category_name|avg_rental_count|
|:----|:----|
|Sports|2|
|Classics|2|
|New|2|
|Family|2|
|Comedy|1|

4. **Table 4** -  `customer_category_percentiles`
```sql
SELECT *
FROM customer_category_percentiles
WHERE customer_id = 1
ORDER BY percentile
LIMIT 5;
```
|customer_id|category_name|percentile|
|:----|:----|:----|
|1|Comedy|1|
|1|Classics|1|
|1|Drama|3|
|1|Music|21|
|1|New|27|

### :triangular_flag_on_post: 6.1 Joining Temporary Tables

```sql
DROP TABLE IF EXISTS customer_category_joint_table;
CREATE TEMP TABLE customer_category_joint_table AS
SELECT
  t1.customer_id,
  t1.category_name,
  t1.rental_count,
  t2.total_rental_count,
  t3.avg_rental_count,
  t4.percentile
FROM category_rental_counts AS t1
INNER JOIN customer_total_rentals AS t2
  ON t1.customer_id = t2.customer_id
INNER JOIN average_category_rental_counts AS t3
  ON t1.category_name = t3.category_name
INNER JOIN customer_category_percentiles AS t4
  ON t1.customer_id = t4.customer_id
  AND t1.category_name = t4.category_name;
-- table 4 `customer_category_percentiles` will join onto `category_rental_counts` on 2 columns

-- inspect customer_id = 1 rows sorted by percentile
SELECT *
FROM customer_category_joint_table
WHERE customer_id = 1
ORDER BY percentile;
```

|customer_id|category_name|rental_count|total_rental_count|avg_rental_count|percentile|
|:----|:----|:----|:----|:----|:----|
|1|Classics|6|32|2|1|
|1|Comedy|5|32|1|1|
|1|Drama|4|32|2|3|
|1|Music|2|32|1|21|
|1|New|2|32|2|27|
|1|Sci-Fi|2|32|2|31|
|1|Action|2|32|2|34|
|1|Sports|2|32|2|35|
|1|Animation|2|32|2|39|
|1|Travel|1|32|1|58|
|1|Games|1|32|2|61|
|1|Foreign|1|32|2|62|
|1|Documentary|1|32|2|65|
|1|Family|1|32|2|66|

### :triangular_flag_on_post: 6.2 Adding Calculated Fields

> **`average_comparison`: How many more films has the customer watched compared to the average DVD Rental Co customer?**

> **`category_percentage`: What proportion of each customer’s total films watched does this count make?**

Let’s drop the temporary table we just created `customer_category_joint_table` and recreate it with these 2 calculations included:

```sql
DROP TABLE IF EXISTS customer_category_joint_table;
CREATE TEMP TABLE customer_category_joint_table AS
SELECT
  t1.customer_id,
  t1.category_name,
  t1.rental_count,
  t1.latest_rental_date,
  t2.total_rental_count,
  t3.avg_rental_count,
  t4.percentile,
  t1.rental_count - t3.avg_rental_count AS average_comparison,
  -- round to nearest integer for percentage after multiplying by 100
  ROUND(100 * t1.rental_count / t2.total_rental_count) AS category_percentage
FROM category_rental_counts AS t1
INNER JOIN customer_total_rentals AS t2
  ON t1.customer_id = t2.customer_id
INNER JOIN average_category_rental_counts AS t3
  ON t1.category_name = t3.category_name
INNER JOIN customer_category_percentiles AS t4
  ON t1.customer_id = t4.customer_id
  AND t1.category_name = t4.category_name;

-- inspect customer_id = 1 top 5 rows sorted by percentile
SELECT *
FROM customer_category_joint_table
WHERE customer_id = 1
ORDER BY percentile
limit 5;
```
|customer_id|category_name|rental_count|latest_rental_date|total_rental_count|avg_rental_count|percentile|average_comparison|category_percentage|
|:----|:----|:----|:----|:----|:----|:----|:----|:----|
|1|Comedy|5|22/08/2005 19:41|32|1|1|4|16|
|1|Classics|6|19/08/2005 9:55|32|2|1|4|19|
|1|Drama|4|18/08/2005 3:57|32|2|3|2|13|
|1|Music|2|09/07/2005 16:38|32|1|21|1|6|
|1|New|2|19/08/2005 13:56|32|2|27|0|6|

### :triangular_flag_on_post: 6.3 Checking Data Types Using information_schema.columns Table

To check the data types of columns in specific tables you can use the following query and hit the `information_schema.columns` reference table **within PostgreSQL**. Note that different SQL flavours will have different ways to inspect the data types of columns and inspect tables further.

```sql
SELECT
  table_name,
  column_name,
  data_type
FROM information_schema.columns
WHERE table_name in ('customer_total_rentals', 'category_rental_counts');
```
|table_name|column_name|data_type|
|:----|:----|:----|
|category_rental_counts|customer_id|smallint|
|category_rental_counts|category_name|character varying|
|category_rental_counts|rental_count|bigint|
|customer_total_rentals|customer_id|smallint|
|customer_total_rentals|total_rental_count|numeric|
***

## :pushpin: 7.0 Ordering and Filtering Rows with ROW_NUMBER

Ok great - we now have all of our various calculations but we also have all of our categories for every customer, however we only need the top 2 categories.

We can use another ordered analytical function  `ROW_NUMBER`  to do this in another window function!

The  `ROW_NUMBER`  is used with an  `OVER`  clause and adds row numbers for records according to some  `ORDER BY`  condition within each “window frame” or “group” of rows assigned by the  `PARTITION BY`  clause.

Once the records within each window frame, partition or group are all numbered - the row number simply restarts at 1 for the next group and continues until all of the groups and rows are sorted and numbered.

For our example - we will aim to sort our records within each set of rows with the same  `customer_id`, ordering the rows by  `rental_count`  from largest to smallest and also using that  `latest_rental_date`  field for each customer’s category as an additional sorting criteria to “deal with ties” (we covered this earlier above!)

We will preference the category with the most recent  `latest_rental_date`  so we will also need to use a  `DESC`  with this second input to the  `ORDER BY`  clause.

We can perform this window function within a CTE and then apply a simple filter to only keep row number records which are less than or equal to 2 only.

Let’s create a final temporary table called  `top_categories_information`  with the output from this operation :

```sql
DROP TABLE IF EXISTS top_categories_information;

-- Note that you need an extra pair of (brackets) when you create tables
-- with CTEs inside the SQL statement!
CREATE TEMP TABLE top_categories_information AS (
-- use a CTE with the ROW_NUMBER() window function implemented
WITH ordered_customer_category_joint_table AS (
  SELECT
    customer_id,
    ROW_NUMBER() OVER (
      PARTITION BY customer_id
      ORDER BY rental_count DESC, latest_rental_date DESC
    ) AS category_ranking,
    category_name,
    rental_count,
    average_comparison,
    percentile,
    category_percentage
  FROM customer_category_joint_table
)
-- filter out top 2 rows from the CTE for final output
SELECT *
FROM ordered_customer_category_joint_table
WHERE category_ranking <= 2
);
```

Let’s now inspect the result for the first 3 customers

```sql
SELECT *
FROM top_categories_information
WHERE customer_id in (1, 2, 3)
ORDER BY customer_id, category_ranking;
```

|customer_id|category_ranking|category_name|rental_count|average_comparison|percentile|category_percentage|
|:----|:----|:----|:----|:----|:----|:----|
|1|1|Classics|6|4|1|19|
|1|2|Comedy|5|4|1|16|
|2|1|Sports|5|3|3|19|
|2|2|Classics|4|2|2|15|
|3|1|Action|4|2|5|15|
|3|2|Sci-Fi|3|1|15|12|

This matches exactly what we need for one of the first output tables for our case study!
***

## :star: SQL Logical Execution Order

In a nutshell - all SQL queries are “ran” in the following order:

1.  `FROM`
    1.  `WHERE`  filters
    2.  `ON`  table join conditions
2.  `GROUP BY`
3.  `SELECT`  aggregate function calculations
4.  `HAVING`
5.  Window functions
6.  `ORDER BY`
7.  `LIMIT`

_Note: that the actual execution order might differ slightly from the above order due to the SQL optimizer making its own decisions for performance reasons!_

