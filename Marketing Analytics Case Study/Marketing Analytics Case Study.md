# :clapper: Marketing Analytics Case Study :dvd:

**Let's follow the PEAR technique to structure this Case Study** :pear:

<details>
<summary>
Click here to see the PEAR structure 
</summary>

## P - Problem :question:

What is the business problem and what sort of value can we generate by solving it? :thinking:

## E - Exploration :mag:

What available resources do we have and what initial data exploration can we perform to better understand our data? 

## A - Analysis :bar_chart:

This is where we start showing off our arsenal of data analysis techniques in a very structured and systematic manner.

## R - Report :page_with_curl:

Once we’ve finished our analysis we want to package up our various code snippets into a single process and generate the final outputs we need to solve our business problem.

</details>

***
## :pushpin: 1.0 Problem :question:

Personalized customer emails based off marketing analytics is a winning formula for many digital companies, and this is exactly the initiative that the leadership team at **DVD Rental Co** has decided to tackle!

We have been tasked by the DVD Rental Co marketing team to help them generate the analytical inputs required to drive their very first customer email campaign.

The marketing team expects their personalised emails to drive increased sales and engagement from the DVD Rental Co customer base.

The main initiative is to share insights about each customer’s viewing behaviour to demonstrate DVD Rental Co’s relentless focus on customer experience.

The insights requested by the marketing team include key statistics about each customer’s top 2 categories and favourite actor. There are also 3 personalised recommendations based off each customer’s previous viewing history as well as titles which are popular with other customers.

### :triangular_flag_on_post: 1.1 Email Template

The marketing team have shared with us a draft of the email they wish to send to their customers.

**Let's breakdown these requirements into chunks!**

![Email Template - target output](https://github.com/mohammedsaqlainattar/Serious-SQL-Apprenticeship/blob/main/Images/Marketing%20Analytics%20Case%20Study/Email%20Template%20-%20target%20output.png?raw=true)

### :triangular_flag_on_post: 1.2 Summarizing Requirements

#### :round_pushpin: 1.2.1 Top Category

1.  What was the top category watched by total rental count? :one:
2.  How many total films have they watched in their top category and how does it compare to the DVD Rental Co customer base? :two:
    -   How many more films has the customer watched compared to the average DVD Rental Co customer?
    -   How does the customer rank in terms of the top X% compared to all other customers in this film category?
3.  What are the top 3 film recommendations in the top category ranked by total customer rental count which the customer has not seen before? :three:
***

#### :round_pushpin: 1.2.2 Second Category

4.  What is the second ranking category by total rental count? :four:
5.  What proportion of each customer’s total films watched does this count make? :five:
6.  What are top 3 recommendations for the second category which the customer has not yet seen before? :six:
***

#### :round_pushpin: 1.2.3 Actor Insights

7.  Which actor has featured in the customer’s rental history the most? :seven:
8.  How many films featuring this actor has been watched by the customer? :eight:
9.  What are the top 3 recommendations featuring this same actor which have not been watched by the customer? :nine:
*** 

### :triangular_flag_on_post: 1.3 Entity Relationship Diagram

We’ve also been provided with the entity relationship diagram (ERD) as shown below with all foreign table keys and column data types:

![ERD](https://github.com/mohammedsaqlainattar/Serious-SQL-Apprenticeship/blob/main/Images/Marketing%20Analytics%20Case%20Study/ERD.png?raw=true)
***

## :pushpin: 2.0 Exploration :mag:

We have a total of 7 tables in our ERD for this case study highlighting the important columns which we should use to join our tables for our data analysis task.

### :triangular_flag_on_post: 2.1 Table Investigation

We have to analyze the relationships between the most important columns from each table to determine if there were one-many, many-one or many-to-many relationships to further guide our table joining investigation.

We are required to compare the following tables detailed in the following animated GIF for our **Category level insights** - and a similar sequence was followed but with the actor tables instead of the category tables for the **Actor insights**:

![ERD GIF](https://github.com/mohammedsaqlainattar/Serious-SQL-Apprenticeship/blob/main/Images/Marketing%20Analytics%20Case%20Study/ERD%20GIF.gif?raw=true)

To answer this one question “What type of table join should we use?” we actually need to answer 3 additional questions! Let’s call it a  **Table Joining Checklist**

1.  **What is the purpose of joining these two tables?**  
    **a) What contextual hypotheses do we have about the data?**  
    **b) How can we validate these assumptions?**
2.  **What is the distribution of foreign keys within each table?**
3.  **How many unique foreign key values exist in each table?**
***

### :triangular_flag_on_post: 2.2 Join Column Analysis Example 1

Here is a sample of the analysis we completed for our exploration of the `dvd_rentals.rental` and `dvd_rentals.inventory` tables:

>1.  **What is the purpose of joining these two tables?**

We need to keep all of the customer rental records from `dvd_rentals.rental` and match up each record with its equivalent `film_id` value from the `dvd_rentals.inventory` table.
***
>2.  **What is the distribution of foreign keys within each table?**

This essentially means - **How many records exist per  `inventory_id`  value in  `rental`  or  `inventory`  tables?**

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

There is a 1-to-many relationship between the `inventory_id` and the rows of the `dvd_rentals.rental` table
***

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

There is a 1-to-1 relationship between the `inventory_id` and the rows of the `dvd_rentals.inventory` table.
***
**Findings**

We can see in the  `rental`  table - there exists different multiple row counts for some values of the foreign keys.

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
***

>3.  **How many unique foreign key values exist in each table?**

**How many overlapping and missing unique  `foreign key`  values are there between the two tables?**

![Foreign Key Overlap Analysis](https://github.com/mohammedsaqlainattar/Serious-SQL-Apprenticeship/blob/main/Images/Marketing%20Analytics%20Case%20Study/Foreign%20Key%20Overlap%20Analysis.JPG?raw=true)

>**Firstly - let’s count how many unique keys are present in the left(rental) table:**

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

>**Now onto the right side table:**

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
**Findings**

All of the foreign key values in  `dvd_rentals.rental`  exist in  `dvd_rentals.inventory`  and only 1 record  `inventory_id = 5`  exists only in the  `dvd_rentals.inventory`  table.

There is an overlap of 4,580 unique inventory_id foreign key values which will exist after the join is complete.

After performing this analysis we can conclude there is in fact no difference between running a `LEFT JOIN` or an `INNER JOIN` in our example!
Let’s also confirm that the unique `inventory_id` records are the same too.

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

Great! In this example - we can indeed confirm that there is no difference between an  **inner join**  or  **left join**  for our datasets!

**We perform this same analysis for all of our tables within our core tables and concluded that the distribution for each of the join keys are as expected and are similar to what we see for these first 2 tables.**
***

### :triangular_flag_on_post: 2.3 Join Column Analysis Example 2

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

### :triangular_flag_on_post: 2.4 Join Column Analysis Example 3

We also need to investigate the relationships between the  `actor_id`  and  `film_id`  columns within the  `dvd_rentals.film_actor`  table.

Intuitively - we can hypothesise that one single actor might show up in multiple films and one film can have multiple actors. This is known as a many-to-many relationship.

Let’s perform some analysis on the data tables to see if our hunch is on point:

```sql
WITH actor_film_counts AS (
  SELECT
    actor_id,
    COUNT(DISTINCT film_id) AS film_count
  FROM dvd_rentals.film_actor
  GROUP BY actor_id
)
SELECT
  film_count,
  COUNT(*) AS total_actors
FROM actor_film_counts
GROUP BY film_count
ORDER BY film_count DESC;
```

Below we can conclude that 14 is the minimum number of films that one actor stars in - these actors are absolute stars!

|film_count|total_actors|
|:----|:----|
|42|1|
|41|1|
|40|1|
|39|1|
|37|1|
|36|1|
|35|6|
|34|5|
|33|13|
|32|10|
|31|16|
|…|…|
|18|2|
|16|1|
|15|2|
|14|1|


Let’s also confirm that there are multiple actors per film also (although this should be pretty obvious!):

```sql
WITH film_actor_counts AS (
  SELECT
    film_id,
    COUNT(DISTINCT actor_id) AS actor_count
  FROM dvd_rentals.film_actor
  GROUP BY film_id
)
SELECT
  actor_count,
  COUNT(*) AS total_films
FROM film_actor_counts
GROUP BY actor_count
ORDER BY actor_count DESC;
```

Some films only consist of a single actor!

|actor_count|total_films|
|:----|:----|
|15|1|
|13|6|
|12|6|
|11|14|
|10|21|
|9|49|
|8|90|
|7|119|
|6|150|
|5|195|
|4|137|
|3|119|
|2|69|
|1|21|

**In conclusion** - We can see that there is indeed a many to many relationship of the `film_id` and the `actor_id` columns within the `dvd_rentals.film_actor` table so we must take extreme care when we are joining these 2 tables as part of our analysis in the next section of this project!
***

## :pushpin: 3.0 Analysis :bar_chart:

Now that we’ve identified the key columns and highlighted some things we need to keep in mind when performing some table joins for our data analysis - we need to formalise our plan of attack.

### :triangular_flag_on_post: 3.1 Solution Plan

### 3.1.1 Category Insights

1.  Create a base dataset and join all relevant tables
-   `complete_joint_dataset`

2.  Calculate customer rental counts for each category

-   `category_counts`

3.  Aggregate all customer total films watched

-   `total_counts`

4.  Identify the top 2 categories for each customer

-   `top_categories`

5.  Calculate each category’s aggregated average rental count

-   `average_category_count`

6.  Calculate the percentile metric for each customer’s top category film count

-   `top_category_percentile`

7.  Generate our first top category insights table using all previously generated tables

-   `top_category_insights`

8.  Generate the 2nd category insights

-   `second_category_insights`
***

### 3.1.2 Category Recommendations

1.  Generate a summarised film count table with the category included, we will use this table to rank the films by popularity

-   `film_counts`

2.  Create a previously watched films for the top 2 categories to exclude for each customer

-   `category_film_exclusions`

3.  Finally perform an anti join from the relevant category films on the exclusions and use window functions to keep the top 3 from each category by popularity - be sure to split out the recommendations by category ranking

-   `category_recommendations`
***

### 3.1.3 Actor Insights

1.  Create a new base dataset which has a focus on the actor instead of category

-   `actor_joint_table`

2.  Identify the top actor and their respective rental count for each customer based off the ranked rental counts

-   `top_actor_counts`

### 3.1.4 Actor Recommendations

1.  Generate total actor rental counts to use for film popularity ranking in later steps

-   `actor_film_counts`

2.  Create an updated film exclusions table which includes the previously watched films like we had for the category recommendations - but this time we need to also add in the films which were previously recommended

-   `actor_film_exclusions`

3.  Apply the same  `ANTI JOIN`  technique and use a window function to identify the 3 valid film recommendations for our customers

-   `actor_recommendations`
***

### :triangular_flag_on_post: 3.2 Category Insights

#### :white_check_mark: 3.2.1 Create Base Dataset

We first created a  `complete_joint_dataset`  which joins multiple tables together after analysing the relationships between each table to confirm if there was a one-to-many, many-to-one or a many-to-many relationship for each of the join columns.

We also included the  `rental_date`  column to help us split ties for rankings which had the same count of rentals at a customer level - this helps us prioritise film categories which were more recently viewed.

```sql
DROP TABLE IF EXISTS complete_joint_dataset;
CREATE TEMP TABLE complete_joint_dataset AS
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
***

#### :white_check_mark: 3.2.2 Customer Rental Counts for each Category

We then created a follow-up table which uses the `complete_joint_dataset` to aggregate our data and generate a `rental_count` and the latest `rental_date` for our ranking purposes downstream.

```sql
DROP TABLE IF EXISTS category_counts;
CREATE TEMP TABLE category_counts AS
SELECT
  customer_id,
  category_name,
  COUNT(*) AS rental_count,
  MAX(rental_date) AS latest_rental_date
FROM complete_joint_dataset
GROUP BY
  customer_id,
  category_name;

-- profile just customer_id = 1 values sorted by desc rental_count
SELECT *
FROM category_counts
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
***

#### :white_check_mark: 3.2.3 Total Customer Rentals

We will then use this `category_counts` table to generate our `total_counts` table.

```sql
DROP TABLE IF EXISTS total_counts;
CREATE TEMP TABLE total_counts AS
SELECT
  customer_id,
  SUM(rental_count) AS total_count
FROM category_counts
GROUP BY customer_id;

-- show output for first 5 customer_id values
SELECT *
FROM total_counts
LIMIT 5;
```
|customer_id|total_count|
|:----|:----|
|184|23|
|87|30|
|477|22|
|273|35|
|550|32|

***
#### :white_check_mark: 3.2.4 Top Categories

We can also use a simple  `DENSE_RANK`  window function to generate a ranking of categories for each customer.

We will also split arbitrary ties by preferencing the category which had the most recent  `latest_rental_date`  value we generated in the  `category_counts`  for this exact purpose. To further prevent any ties - we will also sort the  `category_name`  in alphabetical (ascending) order just in case!

```sql
DROP TABLE IF EXISTS top_categories;
CREATE TEMP TABLE top_categories AS
WITH ranked_cte AS (
  SELECT
    customer_id,
    category_name,
    rental_count,
    DENSE_RANK() OVER (
      PARTITION BY customer_id
      ORDER BY
        rental_count DESC,
        latest_rental_date DESC,
        category_name
    ) AS category_rank
  FROM category_counts
)
SELECT * FROM ranked_cte
WHERE category_rank <= 2;
```
```sql
SELECT *
FROM top_categories
LIMIT 5;
```

|customer_id|category_name|rental_count|category_rank|
|:----|:----|:----|:----|
|1|Classics|6|1|
|1|Comedy|5|2|
|2|Sports|5|1|
|2|Classics|4|2|
|3|Action|4|1|
***

#### :white_check_mark: 3.2.5 Average Category Counts

Next we will need to use the `category_counts` table to generate the average aggregated rental count for each category rounded down to the nearest integer using the `FLOOR` function.

```sql
DROP TABLE IF EXISTS average_category_count;
CREATE TEMP TABLE average_category_count AS
SELECT
  category_name,
  FLOOR(AVG(rental_count)) AS category_average
FROM category_counts
GROUP BY
  category_name;

-- output the entire table by desc avg_rental_count
SELECT *
FROM average_category_count
ORDER BY
  category_average DESC,
  category_name;
```
|category_name|category_average|
|:----|:----|
|Action|2|
|Animation|2|
|Classics|2|
|Documentary|2|
|Drama|2|
|Family|2|
|Foreign|2|
|Games|2|
|New|2|
|Sci-Fi|2|
|Sports|2|
|Children|1|
|Comedy|1|
|Horror|1|
|Music|1|
|Travel|1|
***

#### :white_check_mark: 3.2.6 Top Category Percentile

>**`percentile`: How does the customer rank in terms of the top X% compared to all other customers in this film category?**

![enter image description here](https://github.com/mohammedsaqlainattar/Serious-SQL-Apprenticeship/blob/main/Images/Marketing%20Analytics%20Case%20Study/Point%203.png?raw=true)

![Normal Distribution](https://github.com/mohammedsaqlainattar/Serious-SQL-Apprenticeship/blob/main/Images/Marketing%20Analytics%20Case%20Study/Normal%20Distribution.png?raw=true)

This distribution chart above is a good representation of the same problem we’re facing with this `percentile` calculation. In the above example - the average test score was 60/100 but my score was 95/100 - landing me in the top 1% of all test takers - or if we interpret the numbers in the chart below, I beat 99% of all the other test takers.

So in the same way as me beating the 99% - we need to now generate this same `percentile` value for each customer when comparing their result - the number of films they’ve watched in a certain category - with all other customer rental counts in that category!

Basically, we need to compare each customer’s top category  `rental_count`  to all other DVD Rental Co customers - we do this using a combination of a  `LEFT JOIN`  and a  `PERCENT_RANK`  window function ordered by descending rental count to show the required top  `N%`  customer insight.

We will also use a  `CASE WHEN`  to replace a  `0`  ranking value to  `1`  as it doesn’t make sense for the customer to be in the  `Top 0%`!

```sql
DROP TABLE IF EXISTS top_category_percentile;
CREATE TEMP TABLE top_category_percentile AS
WITH calculated_cte AS (
SELECT
  top_categories.customer_id,
  top_categories.category_name AS top_category_name,
  top_categories.rental_count,
  category_counts.category_name,
  top_categories.category_rank,
  PERCENT_RANK() OVER (
    PARTITION BY category_counts.category_name
    ORDER BY category_counts.rental_count DESC
  ) AS raw_percentile_value
FROM category_counts
LEFT JOIN top_categories
  ON category_counts.customer_id = top_categories.customer_id
)
SELECT
  customer_id,
  category_name,
  rental_count,
  category_rank,
  CASE
    WHEN ROUND(100 * raw_percentile_value) = 0 THEN 1
    ELSE ROUND(100 * raw_percentile_value)
  END AS percentile
FROM calculated_cte
WHERE
  category_rank = 1
  AND top_category_name = category_name;
```
```sql
SELECT *
FROM top_category_percentile
LIMIT 10;
```

|customer_id|category_name|rental_count|percentile|
|:----|:----|:----|:----|
|323|Action|7|1|
|506|Action|7|1|
|151|Action|6|1|
|410|Action|6|1|
|126|Action|6|1|
|51|Action|6|1|
|487|Action|6|1|
|363|Action|6|1|
|209|Action|6|1|
|560|Action|6|1|

>_**This can also be done in an alternative way**_

```sql
DROP TABLE IF EXISTS customer_category_percentiles;
CREATE TEMP TABLE customer_category_percentiles AS
SELECT
  customer_id,
  category_name,
  -- use ceiling to round up to nearest integer after multiplying by 100
  CEILING(
    100 * PERCENT_RANK() OVER (
      PARTITION BY customer_id,category_name
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
```
***

#### :white_check_mark: 3.2.7 1st Category Insights

Let’s now compile all of our previous temporary tables into a single `category_insights` table with what we have so far - we will use our most recently generated `top_category_percentile` table as the base and `LEFT JOIN` our average table to generate an `average_comparison` column.

```sql
DROP TABLE IF EXISTS first_category_insights;
CREATE TEMP TABLE first_category_insights AS
SELECT
  base.customer_id,
  base.category_name,
  base.rental_count,
  base.rental_count - average.category_average AS average_comparison,
  base.percentile
FROM top_category_percentile AS base
LEFT JOIN average_category_count AS average
  ON base.category_name = average.category_name;
```
```sql
SELECT *
FROM first_category_insights
LIMIT 10;
```

|customer_id|category_name|rental_count|average_comparison|percentile|
|:----|:----|:----|:----|:----|
|323|Action|7|5|1|
|506|Action|7|5|1|
|151|Action|6|4|1|
|410|Action|6|4|1|
|126|Action|6|4|1|
|51|Action|6|4|1|
|487|Action|6|4|1|
|363|Action|6|4|1|
|209|Action|6|4|1|
|560|Action|6|4|1|
***

#### :white_check_mark: 3.2.8 2nd Category Insights

Our second ranked category insight is pretty simple as we only need our  `top_categories`  table and the  `total_counts`  table to process our insights.

The only thing to note here is that we’ll need to cast one of our fraction components of our  `total_percentage`  column to avoid the dreaded integer floor division!

```sql
DROP TABLE IF EXISTS second_category_insights;
CREATE TEMP TABLE second_category_insights AS
SELECT
  top_categories.customer_id,
  top_categories.category_name,
  top_categories.rental_count,
  -- need to cast as NUMERIC to avoid INTEGER floor division!
  ROUND(
    100 * top_categories.rental_count::NUMERIC / total_counts.total_count
  ) AS total_percentage
FROM top_categories
LEFT JOIN total_counts
  ON top_categories.customer_id = total_counts.customer_id
WHERE category_rank = 2;
```
```sql
SELECT *
FROM second_category_insights
LIMIT 10;
```

|customer_id|category_name|rental_count|total_percentage|
|:----|:----|:----|:----|
|184|Drama|3|13|
|87|Sci-Fi|3|10|
|477|Travel|3|14|
|273|New|4|11|
|550|Drama|4|13|
|51|Drama|4|12|
|394|Documentary|3|14|
|272|Documentary|3|15|
|70|Music|2|11|
|190|Classics|3|11|
***

### :triangular_flag_on_post: 3.3 Category Recommendations

#### :white_check_mark: 3.3.1 Film Counts

We wil first generate another total rental count aggregation from our base table  `complete_joint_dataset`  - however this time we will use the  `film_id`  and  `title`  instead of the category - we still need to keep the  `category_name`  in our aggregation - so we will need to use a window function instead of a group by to perform this step.

The  `DISTINCT`  is really important for this query - if we were to omit it we would end up with duplicates in our table, which is definitely not what we want!

```sql
DROP TABLE IF EXISTS film_counts;
CREATE TEMP TABLE film_counts AS
SELECT DISTINCT
  film_id,
  title,
  category_name,
  COUNT(*) OVER (
    PARTITION BY film_id
  ) AS rental_count
FROM complete_joint_dataset;
```
```sql
SELECT *
FROM film_counts
ORDER BY rental_count DESC
LIMIT 10;
```

|film_id|title|category_name|rental_count|
|:----|:----|:----|:----|
|103|BUCKET BROTHERHOOD|Travel|34|
|738|ROCKETEER MOTHER|Foreign|33|
|331|FORWARD TEMPLE|Games|32|
|489|JUGGLER HARDLY|Animation|32|
|767|SCALAWAG DUCK|Music|32|
|382|GRIT CLOCKWORK|Games|32|
|730|RIDGEMONT SUBMARINE|New|32|
|973|WIFE TURN|Documentary|31|
|621|NETWORK PEAK|Family|31|
|1000|ZORRO ARK|Comedy|31|
***

#### :white_check_mark: 3.3.2 Category Film Exclusions

For the next step in our recommendation analysis - we will need to generate a table with all of our customer’s previously watched films so we don’t recommend them something which they’ve already seen before.

We will use the  `complete_joint_dataset`  base table to get this information - it is pretty straightforward, the only thing to keep in mind is how we will perform an  `ANTI JOIN`  with our previous  `film_counts`  table so we need to also keep the same  `film_id`  column to use as our join column.

We also want to make sure that the  `DISTINCT`  is also applied for this table too - it is not as important as in our last step, but it would be best practice to apply it here also!

_Note_: we could also keep the  `title`  and  `category_name`  columns but they are redundant and we want to minimise the amount of data we need to use!

```sql
DROP TABLE IF EXISTS category_film_exclusions;
CREATE TEMP TABLE category_film_exclusions AS
SELECT DISTINCT
  customer_id,
  film_id
FROM complete_joint_dataset;
```
```sql
SELECT *
FROM category_film_exclusions
LIMIT 10;
```

|customer_id|film_id|
|:----|:----|
|596|103|
|176|121|
|459|724|
|375|641|
|153|730|
|1|480|
|291|285|
|144|93|
|158|786|
|211|962|
***

#### :white_check_mark: 3.3.3 Final Category Recommendations

Finally we have arrived at the final point of our category recommendations analysis where we need to perform an  `ANTI JOIN`  on our  `category_film_exclusions`  table using a  `WHERE NOT EXISTS`  SQL implementation for our top 2 categories found in the  `top_categories`  table we generated a few steps prior.

After this exclusion - we will then perform a window function to select the top 3 films for each of the top 2 categories per customer. To avoid random ties - we will sort by the  `title`  alphabetically in case the  `rental_count`  values are equal in the  `ORDER BY`  clause for our window function.

We also need to keep our  `category_rank`  column in our final output so we can easily identify our recommendations for each customer’s preferred categories.

This  `ANTI JOIN`  is likely to be the most complex and challenging piece to understand in this entire analysis.

```sql
DROP TABLE IF EXISTS category_recommendations;
CREATE TEMP TABLE category_recommendations AS
WITH ranked_films_cte AS (
  SELECT
    top_categories.customer_id,
    top_categories.category_name,
    top_categories.category_rank,
    -- why do we keep this `film_id` column you might ask?
    -- you will find out later on during the actor level recommendations!
    film_counts.film_id,
    film_counts.title,
    film_counts.rental_count,
    DENSE_RANK() OVER (
      PARTITION BY
        top_categories.customer_id,
        top_categories.category_rank
      ORDER BY
        film_counts.rental_count DESC,
        film_counts.title
    ) AS reco_rank
  FROM top_categories
  INNER JOIN film_counts
    ON top_categories.category_name = film_counts.category_name
  -- This is a tricky anti-join where we need to "join" on 2 different tables!
  WHERE NOT EXISTS (
    SELECT 1
    FROM category_film_exclusions
    WHERE
      category_film_exclusions.customer_id = top_categories.customer_id AND
      category_film_exclusions.film_id = film_counts.film_id
  )
)
SELECT * FROM ranked_films_cte
WHERE reco_rank <= 3;
```
```sql
SELECT *
FROM category_recommendations
WHERE customer_id = 1
ORDER BY category_rank, reco_rank;
```

|customer_id|category_name|category_rank|film_id|title|rental_count|reco_rank|
|:----|:----|:----|:----|:----|:----|:----|
|1|Classics|1|891|TIMBERLAND SKY|31|1|
|1|Classics|1|358|GILMORE BOILED|28|2|
|1|Classics|1|951|VOYAGE LEGALLY|28|3|
|1|Comedy|2|1000|ZORRO ARK|31|1|
|1|Comedy|2|127|CAT CONEHEADS|30|2|
|1|Comedy|2|638|OPERATION OPERATION|27|3|
***

### :triangular_flag_on_post: 3.4 Actor Insights

#### :white_check_mark: 3.4.1 Actor Joint Table (Base Table)

For this entire analysis on actors - we will need to create a new base table as we will need to introduce the  `dvd_rentals.film_actor`  and  `dvd_rentals.actor`  tables to extract all the required data points we need for the final output.

We should also check that the combination of rows in our final table is expected because we should see many more rows than previously used in our categories insights as there is a many-to-many relationship between  `film_id`  and  `actor_id`  as we alluded to earlier in our data exploration section of this case study.

We will also include the  `rental_date`  column in this table so we can use it in case there are any ties - just like our previous analysis for the top categories piece.

```sql
-- Actor Insights and Recommendations
DROP TABLE IF EXISTS actor_joint_dataset;
CREATE TEMP TABLE actor_joint_dataset AS
SELECT
  rental.customer_id,
  rental.rental_id,
  rental.rental_date,
  film.film_id,
  film.title,
  actor.actor_id,
  actor.first_name,
  actor.last_name
FROM dvd_rentals.rental
INNER JOIN dvd_rentals.inventory
  ON rental.inventory_id = inventory.inventory_id
INNER JOIN dvd_rentals.film
  ON inventory.film_id = film.film_id
-- different to our previous base table as we know use actor tables
INNER JOIN dvd_rentals.film_actor
  ON film.film_id = film_actor.film_id
INNER JOIN dvd_rentals.actor
  ON film_actor.actor_id = actor.actor_id;
```
```sql
-- show the counts and count distinct of a few important columns
SELECT
  COUNT(*) AS total_row_count,
  COUNT(DISTINCT rental_id) AS unique_rental_id,
  COUNT(DISTINCT film_id) AS unique_film_id,
  COUNT(DISTINCT actor_id) AS unique_actor_id,
  COUNT(DISTINCT customer_id) AS unique_customer_id
FROM actor_joint_dataset;
```

|total_row_count|unique_rental_id|unique_film_id|unique_actor_id|unique_customer_id|
|:----|:----|:----|:----|:----|
|87980|16004|955|200|599|

```sql
-- show the first 10 rows
SELECT *
FROM actor_joint_dataset
LIMIT 10;
```

|customer_id|rental_id|film_id|rental_date|title|actor_id|first_name|last_name|
|:----|:----|:----|:----|:----|:----|:----|:----|
|130|1|80|24/05/2005 22:53|BLANKET BEVERLY|200|THORA|TEMPLE|
|130|1|80|24/05/2005 22:53|BLANKET BEVERLY|193|BURT|TEMPLE|
|130|1|80|24/05/2005 22:53|BLANKET BEVERLY|173|ALAN|DREYFUSS|
|130|1|80|24/05/2005 22:53|BLANKET BEVERLY|16|FRED|COSTNER|
|459|2|333|24/05/2005 22:54|FREAKY POCUS|147|FAY|WINSLET|
|459|2|333|24/05/2005 22:54|FREAKY POCUS|127|KEVIN|GARLAND|
|459|2|333|24/05/2005 22:54|FREAKY POCUS|105|SIDNEY|CROWE|
|459|2|333|24/05/2005 22:54|FREAKY POCUS|103|MATTHEW|LEIGH|
|459|2|333|24/05/2005 22:54|FREAKY POCUS|42|TOM|MIRANDA|
|408|3|373|24/05/2005 23:03|GRADUATE LORD|140|WHOOPI|HURT|
***

#### :white_check_mark: 3.4.2 Top Actor Counts

We can now generate our rental counts per actor and since we are only interested in the top actor for each of our customers - we can also perform a filter step to just keep the top actor records and counts for our downstream insights.

We will break up our analysis into separate CTEs so we can see the entire process without introducing more complex window functions within the initial  `GROUP BY`  queries.

```sql
DROP TABLE IF EXISTS top_actor_counts;
CREATE TEMP TABLE top_actor_counts AS
WITH actor_counts AS (
  SELECT
    customer_id,
    actor_id,
    first_name,
    last_name,
    COUNT(*) AS rental_count,
    -- we also generate the latest_rental_date just like our category insight
    MAX(rental_date) AS latest_rental_date
  FROM actor_joint_dataset
  GROUP BY
    customer_id,
    actor_id,
    first_name,
    last_name
),
ranked_actor_counts AS (
  SELECT
    actor_counts.*,
    DENSE_RANK() OVER (
      PARTITION BY customer_id
      ORDER BY
        rental_count DESC,
        latest_rental_date DESC,
        -- just in case we have any further ties, we'll throw in the names too!
        first_name,
        last_name
    ) AS actor_rank
  FROM actor_counts
)
SELECT
  customer_id,
  actor_id,
  first_name,
  last_name,
  rental_count
FROM ranked_actor_counts
WHERE actor_rank = 1;
```
```sql
SELECT *
FROM top_actor_counts
LIMIT 10;
```

|customer_id|actor_id|first_name|last_name|rental_count|
|:----|:----|:----|:----|:----|
|1|37|VAL|BOLGER|6|
|2|107|GINA|DEGENERES|5|
|3|150|JAYNE|NOLTE|4|
|4|102|WALTER|TORN|4|
|5|12|KARL|BERRY|4|
|6|191|GREGORY|GOODING|4|
|7|65|ANGELA|HUDSON|5|
|8|167|LAURENCE|BULLOCK|5|
|9|23|SANDRA|KILMER|3|
|10|12|KARL|BERRY|4|
***

### :triangular_flag_on_post: 3.5 Actor Recommendations

#### :white_check_mark: 3.5.1 Actor Film Counts

We need to generate aggregated total rental counts across all customers by  `actor_id`  and  `film_id`  so we can join onto our  `top_actor_counts`  table - this time it’s a little more complicated than just using our simple window function like before!

Since we have now introduced many many more rows than actual rentals - we will need to perform a split aggregation on our table and perform an additional left join back to our base table in order to obtain the right  `rental_count`  values.

The  `DISTINCT`  is really important in the final part of the CTE as it will remove duplicates which will have a huge impact on our downstream joins later!

```sql
DROP TABLE IF EXISTS actor_film_counts;
CREATE TEMP TABLE actor_film_counts AS
WITH film_counts AS (
  SELECT
    film_id,
    COUNT(DISTINCT rental_id) AS rental_count
  FROM actor_joint_dataset
  GROUP BY film_id
)
SELECT DISTINCT
  actor_joint_dataset.film_id,
  actor_joint_dataset.actor_id,
  -- why do we keep the title here? can you figure out why?
  actor_joint_dataset.title,
  film_counts.rental_count
FROM actor_joint_dataset
LEFT JOIN film_counts
  ON actor_joint_dataset.film_id = film_counts.film_id;
```
```sql
SELECT *
FROM actor_film_counts
LIMIT 10;
```

|film_id|actor_id|rental_count|
|:----|:----|:----|
|80|200|12|
|80|193|12|
|80|173|12|
|80|16|12|
|333|147|17|
|333|127|17|
|333|105|17|
|333|103|17|
|333|42|17|
|373|140|16|
***

#### :white_check_mark: 3.5.2 Actor Film Exclusions

We can perform the same steps we used to create the  `category_film_exclusions`  table - however we also need to  `UNION`  our exclusions with the relevant category recommendations that we have already given our customers.

The rationale behind this - customers would not want to receive a recommendation for the same film twice in the same email!

```sql
DROP TABLE IF EXISTS actor_film_exclusions;
CREATE TEMP TABLE actor_film_exclusions AS
-- repeat the first steps as per the category exclusions
-- we'll use our original complete_joint_dataset as the base here
-- can you figure out why???
(
  SELECT DISTINCT
    customer_id,
    film_id
  FROM complete_joint_dataset
)
-- we use a UNION to combine the previously watched and the recommended films!
UNION
(
  SELECT DISTINCT
    customer_id,
    film_id
  FROM category_recommendations
);
```
```sql
SELECT *
FROM actor_film_exclusions
LIMIT 10;
```

|customer_id|film_id|
|:----|:----|
|493|567|
|114|789|
|596|103|
|176|121|
|459|724|
|375|641|
|153|730|
|291|285|
|1|480|
|144|93|
***

#### :white_check_mark: 3.5.3 Final Actor Recommendations

We can now conclude our analysis phase with this final `ANTI JOIN` and `DENSE_RANK` query to perform the same operation as category insights previously - only this time we will use `top_actor_counts`, `actor_film_counts` and `actor_film_exclusions` tables for our analysis.

```sql
DROP TABLE IF EXISTS actor_recommendations;
CREATE TEMP TABLE actor_recommendations AS
WITH ranked_actor_films_cte AS (
  SELECT
    top_actor_counts.customer_id,
    top_actor_counts.first_name,
    top_actor_counts.last_name,
    top_actor_counts.rental_count,
    actor_film_counts.title,
    actor_film_counts.film_id,
    actor_film_counts.actor_id,
    DENSE_RANK() OVER (
      PARTITION BY
        top_actor_counts.customer_id
      ORDER BY
        actor_film_counts.rental_count DESC,
        actor_film_counts.title
    ) AS reco_rank
  FROM top_actor_counts
  INNER JOIN actor_film_counts
    -- join on actor_id instead of category_name!
    ON top_actor_counts.actor_id = actor_film_counts.actor_id
  -- This is a tricky anti-join where we need to "join" on 2 different tables!
  WHERE NOT EXISTS (
    SELECT 1
    FROM actor_film_exclusions
    WHERE
      actor_film_exclusions.customer_id = top_actor_counts.customer_id AND
      actor_film_exclusions.film_id = actor_film_counts.film_id
  )
)
SELECT * FROM ranked_actor_films_cte
WHERE reco_rank <= 3;
```
```sql
SELECT *
FROM actor_recommendations
ORDER BY customer_id, reco_rank
LIMIT 15;
```

|customer_id|first_name|last_name|rental_count|title|film_id|actor_id|reco_rank|
|:----|:----|:----|:----|:----|:----|:----|:----|
|1|VAL|BOLGER|6|PRIMARY GLASS|697|37|1|
|1|VAL|BOLGER|6|ALASKA PHANTOM|12|37|2|
|1|VAL|BOLGER|6|METROPOLIS COMA|572|37|3|
|2|GINA|DEGENERES|5|GOODFELLAS SALUTE|369|107|1|
|2|GINA|DEGENERES|5|WIFE TURN|973|107|2|
|2|GINA|DEGENERES|5|DOGMA FAMILY|239|107|3|
|3|JAYNE|NOLTE|4|SWEETHEARTS SUSPECTS|873|150|1|
|3|JAYNE|NOLTE|4|DANCING FEVER|206|150|2|
|3|JAYNE|NOLTE|4|INVASION CYCLONE|468|150|3|
|4|WALTER|TORN|4|CURTAIN VIDEOTAPE|200|102|1|
|4|WALTER|TORN|4|LIES TREATMENT|521|102|2|
|4|WALTER|TORN|4|NIGHTMARE CHILL|624|102|3|
|5|KARL|BERRY|4|VIRGINIAN PLUTO|945|12|1|
|5|KARL|BERRY|4|STAGECOACH ARMAGEDDON|838|12|2|
|5|KARL|BERRY|4|TELEMARK HEARTBREAKERS|880|12|3|
***

## :pushpin: 4.0 Report :page_with_curl:

To package up all our analysis into a single report - we will need to perform some further transformations to finally generate a sample table for the DVD Rental Co Marketing team to consume - there will be a few final data transformation steps included as part of the entire SQL analysis.

Let’s first generate all of our SQL outputs using a single SQL script and share a snapshot of what our outputs currently look like before these final transformations.
***

### :triangular_flag_on_post: 4.1 SQL Script

<details>
<summary>
This script is really long - Click here to see the entire SQL script!
</summary>

```sql
-- PART 1: Category Insights

/*---------------------------------------------------
1. Create a base dataset and join all relevant tables
  * `complete_joint_dataset`
----------------------------------------------------*/

DROP TABLE IF EXISTS complete_joint_dataset;
CREATE TEMP TABLE complete_joint_dataset AS
SELECT
  rental.customer_id,
  inventory.film_id,
  film.title,
  category.name AS category_name,
  -- also included rental_date for sorting purposes
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


/*---------------------------------------------------
2. Calculate customer rental counts for each category
  * `category_counts`
----------------------------------------------------*/

DROP TABLE IF EXISTS category_counts;
CREATE TEMP TABLE category_counts AS
SELECT
  customer_id,
  category_name,
  COUNT(*) AS rental_count,
  MAX(rental_date) AS latest_rental_date
FROM complete_joint_dataset
GROUP BY
  customer_id,
  category_name;

/* ---------------------------------------------------
3. Aggregate all customer total films watched
  * `total_counts`
---------------------------------------------------- */

DROP TABLE IF EXISTS total_counts;
CREATE TEMP TABLE total_counts AS
SELECT
  customer_id,
  SUM(rental_count) AS total_count
FROM category_counts
GROUP BY
  customer_id;


/* ---------------------------------------------------
4. Identify the top 2 categories for each customer
  * `top_categories`
---------------------------------------------------- */

DROP TABLE IF EXISTS top_categories;
CREATE TEMP TABLE top_categories AS
WITH ranked_cte AS (
  SELECT
    customer_id,
    category_name,
    rental_count,
    DENSE_RANK() OVER (
      PARTITION BY customer_id
      ORDER BY
        rental_count DESC,
        latest_rental_date DESC,
        category_name
    ) AS category_rank
  FROM category_counts
)
SELECT * FROM ranked_cte
WHERE category_rank <= 2;


/* ---------------------------------------------------
5. Calculate each category's aggregated average rental count
  * `average_category_count`
---------------------------------------------------- */

DROP TABLE IF EXISTS average_category_count;
CREATE TEMP TABLE average_category_count AS
SELECT
  category_name,
  FLOOR(AVG(rental_count)) AS category_average
FROM category_counts
GROUP BY category_name;


/* ---------------------------------------------------
6. Calculate the percentile metric for each customer's
top category film count - be careful of where the
WHERE filter is applied!
  * `top_category_percentile`
---------------------------------------------------- */

DROP TABLE IF EXISTS top_category_percentile;
CREATE TEMP TABLE top_category_percentile AS
WITH calculated_cte AS (
SELECT
  top_categories.customer_id,
  top_categories.category_name AS top_category_name,
  top_categories.rental_count,
  category_counts.category_name,
  top_categories.category_rank,
  PERCENT_RANK() OVER (
    PARTITION BY category_counts.category_name
    ORDER BY category_counts.rental_count DESC
  ) AS raw_percentile_value
FROM category_counts
LEFT JOIN top_categories
  ON category_counts.customer_id = top_categories.customer_id
)
SELECT
  customer_id,
  category_name,
  rental_count,
  category_rank,
  CASE
    WHEN ROUND(100 * raw_percentile_value) = 0 THEN 1
    ELSE ROUND(100 * raw_percentile_value)
  END AS percentile
FROM calculated_cte
WHERE
  category_rank = 1
  AND top_category_name = category_name;


/* ---------------------------------------------------
7. Generate our first top category insights table using all previously generated tables
  * `top_category_insights`
---------------------------------------------------- */

DROP TABLE IF EXISTS first_category_insights;
CREATE TEMP TABLE first_category_insights AS
SELECT
  base.customer_id,
  base.category_name,
  base.rental_count,
  base.rental_count - average.category_average AS average_comparison,
  base.percentile
FROM top_category_percentile AS base
LEFT JOIN average_category_count AS average
  ON base.category_name = average.category_name;


/* ---------------------------------------------------
8. Generate the 2nd category insights
  * `second_category_insights`
---------------------------------------------------- */

DROP TABLE IF EXISTS second_category_insights;
CREATE TEMP TABLE second_category_insights AS
SELECT
  top_categories.customer_id,
  top_categories.category_name,
  top_categories.rental_count,
  -- need to cast as NUMERIC to avoid INTEGER floor division!
  ROUND(
    100 * top_categories.rental_count::NUMERIC / total_counts.total_count
  ) AS total_percentage
FROM top_categories
LEFT JOIN total_counts
  ON top_categories.customer_id = total_counts.customer_id
WHERE category_rank = 2;


/* -----------------------------
################################
### Category Recommendations ###
################################
--------------------------------*/


/* --------------------------------------------------------------
1. Generate a summarised film count table with the category
included, we will use this table to rank the films by popularity
  * `film_counts`
---------------------------------------------------------------- */

DROP TABLE IF EXISTS film_counts;
CREATE TEMP TABLE film_counts AS
SELECT DISTINCT
  film_id,
  title,
  category_name,
  COUNT(*) OVER (
    PARTITION BY film_id
  ) AS rental_count
FROM complete_joint_dataset;


/* ---------------------------------------------------
2. Create a previously watched films for the top 2
categories to exclude for each customer
  * `category_film_exclusions`
---------------------------------------------------- */

DROP TABLE IF EXISTS category_film_exclusions;
CREATE TEMP TABLE category_film_exclusions AS
SELECT DISTINCT
  customer_id,
  film_id
FROM complete_joint_dataset;

/* -------------------------------------------------------------------------
3. Finally perform an anti join from the relevant category films on the
exclusions and use window functions to keep the top 3 from each category
by popularity - be sure to split out the recommendations by category ranking
  * `category_recommendations`
---------------------------------------------------------------------------- */

DROP TABLE IF EXISTS category_recommendations;
CREATE TEMP TABLE category_recommendations AS
WITH ranked_films_cte AS (
  SELECT
    top_categories.customer_id,
    top_categories.category_name,
    top_categories.category_rank,
    -- we use this film_id downstream when we
    -- need to exclude new category recommendations for each customer!
    film_counts.film_id,
    film_counts.title,
    film_counts.rental_count,
    DENSE_RANK() OVER (
      PARTITION BY
        top_categories.customer_id,
        top_categories.category_rank
      ORDER BY
        film_counts.rental_count DESC,
        film_counts.title
    ) AS reco_rank
  FROM top_categories
  INNER JOIN film_counts
    ON top_categories.category_name = film_counts.category_name
  -- This is a tricky anti-join where we need to "join" on 2 different tables!
  WHERE NOT EXISTS (
    SELECT 1
    FROM category_film_exclusions
    WHERE
      category_film_exclusions.customer_id = top_categories.customer_id AND
      category_film_exclusions.film_id = film_counts.film_id
  )
)
SELECT * FROM ranked_films_cte
WHERE reco_rank <= 3;


/* -------------------
######################
### Actor Insights ###
######################
----------------------*/


/* ---------------------------------------------------
1. Create a new base dataset which has a focus on the actor instead of category
  * `actor_joint_table`
---------------------------------------------------- */

DROP TABLE IF EXISTS actor_joint_dataset;
CREATE TEMP TABLE actor_joint_dataset AS
SELECT
  rental.customer_id,
  rental.rental_id,
  rental.rental_date,
  film.film_id,
  film.title,
  actor.actor_id,
  actor.first_name,
  actor.last_name
FROM dvd_rentals.rental
INNER JOIN dvd_rentals.inventory
  ON rental.inventory_id = inventory.inventory_id
INNER JOIN dvd_rentals.film
  ON inventory.film_id = film.film_id
-- different to our previous base table as we know use actor tables
INNER JOIN dvd_rentals.film_actor
  ON film.film_id = film_actor.film_id
INNER JOIN dvd_rentals.actor
  ON film_actor.actor_id = actor.actor_id;


/* ---------------------------------------------------
2. Identify the top actor and their respective rental
count for each customer based off the ranked rental counts
  * `top_actor_counts`
---------------------------------------------------- */

DROP TABLE IF EXISTS top_actor_counts;
CREATE TEMP TABLE top_actor_counts AS
WITH actor_counts AS (
  SELECT
    customer_id,
    actor_id,
    first_name,
    last_name,
    COUNT(*) AS rental_count,
    -- we also generate the latest_rental_date just like our category insight
    MAX(rental_date) AS latest_rental_date
  FROM actor_joint_dataset
  GROUP BY
    customer_id,
    actor_id,
    first_name,
    last_name
),
ranked_actor_counts AS (
  SELECT
    actor_counts.*,
    DENSE_RANK() OVER (
      PARTITION BY customer_id
      ORDER BY
        rental_count DESC,
        latest_rental_date DESC,
        -- just in case we have any further ties, we'll throw in the names too!
        first_name,
        last_name
    ) AS actor_rank
  FROM actor_counts
)
SELECT
  customer_id,
  actor_id,
  first_name,
  last_name,
  rental_count
FROM ranked_actor_counts
WHERE actor_rank = 1;


/* --------------------------
#############################
### Actor Recommendations ###
#############################
-----------------------------*/

/* ---------------------------------------------------
1. Generate total actor rental counts to use for film
popularity ranking in later steps
  * `actor_film_counts`
---------------------------------------------------- */

DROP TABLE IF EXISTS actor_film_counts;
CREATE TEMP TABLE actor_film_counts AS
WITH film_counts AS (
  SELECT
    film_id,
    COUNT(DISTINCT rental_id) AS rental_count
  FROM actor_joint_dataset
  GROUP BY film_id
)
SELECT DISTINCT
  actor_joint_dataset.film_id,
  actor_joint_dataset.actor_id,
  -- keep title in dataset as we need it for final recommendation text
  actor_joint_dataset.title,
  film_counts.rental_count
FROM actor_joint_dataset
LEFT JOIN film_counts
  ON actor_joint_dataset.film_id = film_counts.film_id;


/* -------------------------------------------------
2. Create an updated film exclusions table which
includes the previously watched films like we had
for the category recommendations - but this time we
need to also add in the films which were previously
recommended
  * `actor_film_exclusions`
---------------------------------------------------- */

DROP TABLE IF EXISTS actor_film_exclusions;
CREATE TEMP TABLE actor_film_exclusions AS
-- repeat the first steps as per the category exclusions
(
  SELECT DISTINCT
    customer_id,
    film_id
  FROM complete_joint_dataset
)
-- we use a UNION to combine the previously watched and the recommended films!
UNION
(
  SELECT DISTINCT
    customer_id,
    film_id
  FROM category_recommendations
);


/* -------------------------------------------------
3. Apply the same `ANTI JOIN` technique and use a
window function to identify the 3 valid film
recommendations for our customers
  * `actor_recommendations`
---------------------------------------------------- */

DROP TABLE IF EXISTS actor_recommendations;
CREATE TEMP TABLE actor_recommendations AS
WITH ranked_actor_films_cte AS (
  SELECT
    top_actor_counts.customer_id,
    top_actor_counts.first_name,
    top_actor_counts.last_name,
    top_actor_counts.rental_count,
    actor_film_counts.title,
    actor_film_counts.film_id,
    actor_film_counts.actor_id,
    DENSE_RANK() OVER (
      PARTITION BY
        top_actor_counts.customer_id
      ORDER BY
        actor_film_counts.rental_count DESC,
        actor_film_counts.title
    ) AS reco_rank
  FROM top_actor_counts
  INNER JOIN actor_film_counts
    -- join on actor_id instead of category_name!
    ON top_actor_counts.actor_id = actor_film_counts.actor_id
  -- This is a tricky anti-join where we need to "join" on 2 different tables!
  WHERE NOT EXISTS (
    SELECT 1
    FROM actor_film_exclusions
    WHERE
      actor_film_exclusions.customer_id = top_actor_counts.customer_id AND
      actor_film_exclusions.film_id = actor_film_counts.film_id
  )
)
SELECT * FROM ranked_actor_films_cte
WHERE reco_rank <= 3;
```

</details>

***

### :triangular_flag_on_post: 4.2 Key Table Outputs

#### :white_check_mark: 4.2.1 Customer Level Insights

1. `first_category_insights`

<details>
<summary>
Click to see the sample rows from `first_category_insights`
</summary>

```
SELECT *
FROM first_category_insights
LIMIT 10;
```

|customer_id|category_name|rental_count|average_comparison|percentile|
|:----|:----|:----|:----|:----|
|323|Action|7|5|1|
|506|Action|7|5|1|
|151|Action|6|4|1|
|410|Action|6|4|1|
|126|Action|6|4|1|
|51|Action|6|4|1|
|487|Action|6|4|1|
|363|Action|6|4|1|
|209|Action|6|4|1|
|560|Action|6|4|1|

</details>

***

2. `second_category_insights`

<details>
<summary>
Click to see the sample rows from `second_category_insights`
</summary>

```
SELECT *
FROM second_category_insights
LIMIT 10;
```

|customer_id|category_name|rental_count|total_percentage|
|:----|:----|:----|:----|
|184|Drama|3|13|
|87|Sci-Fi|3|10|
|477|Travel|3|14|
|273|New|4|11|
|550|Drama|4|13|
|51|Drama|4|12|
|394|Documentary|3|14|
|272|Documentary|3|15|
|70|Music|2|11|
|190|Classics|3|11|

</details>

***

3. `top_actor_counts`

<details>
<summary>
Click to see the sample rows from `top_actor_counts`
</summary>

```
SELECT *
FROM top_actor_counts
LIMIT 10;
```

|customer_id|actor_id|first_name|last_name|rental_count|
|:----|:----|:----|:----|:----|
|1|37|VAL|BOLGER|6|
|2|107|GINA|DEGENERES|5|
|3|150|JAYNE|NOLTE|4|
|4|102|WALTER|TORN|4|
|5|12|KARL|BERRY|4|
|6|191|GREGORY|GOODING|4|
|7|65|ANGELA|HUDSON|5|
|8|167|LAURENCE|BULLOCK|5|
|9|23|SANDRA|KILMER|3|
|10|12|KARL|BERRY|4|

</details>

***

#### :white_check_mark: 4.2.2 Recommendations

1.  `category_recommendations`

<details>
<summary>
Click to see the sample rows from `category_recommendations`
</summary>

```
SELECT *
FROM category_recommendations
WHERE customer_id = 1
ORDER BY category_rank, reco_rank;
```

|customer_id|category_name|category_rank|film_id|title|rental_count|reco_rank|
|:----|:----|:----|:----|:----|:----|:----|
|1|Classics|1|891|TIMBERLAND SKY|31|1|
|1|Classics|1|358|GILMORE BOILED|28|2|
|1|Classics|1|951|VOYAGE LEGALLY|28|3|
|1|Comedy|2|1000|ZORRO ARK|31|1|
|1|Comedy|2|127|CAT CONEHEADS|30|2|
|1|Comedy|2|638|OPERATION OPERATION|27|3|

</details>

***

1.  `actor_recommendations`

<details>
<summary>
Click to see the sample rows from `actor_recommendations`
</summary>

```
SELECT *
FROM actor_recommendations
ORDER BY customer_id, reco_rank
LIMIT 15;
```

|customer_id|first_name|last_name|rental_count|title|film_id|actor_id|reco_rank|
|:----|:----|:----|:----|:----|:----|:----|:----|
|1|VAL|BOLGER|6|PRIMARY GLASS|697|37|1|
|1|VAL|BOLGER|6|ALASKA PHANTOM|12|37|2|
|1|VAL|BOLGER|6|METROPOLIS COMA|572|37|3|
|2|GINA|DEGENERES|5|GOODFELLAS SALUTE|369|107|1|
|2|GINA|DEGENERES|5|WIFE TURN|973|107|2|
|2|GINA|DEGENERES|5|DOGMA FAMILY|239|107|3|
|3|JAYNE|NOLTE|4|SWEETHEARTS SUSPECTS|873|150|1|
|3|JAYNE|NOLTE|4|DANCING FEVER|206|150|2|
|3|JAYNE|NOLTE|4|INVASION CYCLONE|468|150|3|
|4|WALTER|TORN|4|CURTAIN VIDEOTAPE|200|102|1|
|4|WALTER|TORN|4|LIES TREATMENT|521|102|2|
|4|WALTER|TORN|4|NIGHTMARE CHILL|624|102|3|
|5|KARL|BERRY|4|VIRGINIAN PLUTO|945|12|1|
|5|KARL|BERRY|4|STAGECOACH ARMAGEDDON|838|12|2|
|5|KARL|BERRY|4|TELEMARK HEARTBREAKERS|880|12|3|

</details>

***

#### :white_check_mark: 4.2.3 Final Transformations

Ideally - we will be able to generate a single lookup table for the marketing team to consume and this table contains a single row for each customer.

We will make use of multiple CTEs to perform this transformation from long to wide for our multiple outputs. We use the `CONCAT` function to concatenate strings and column inputs - note that we could also use the double pipe `||` to perform the same operation!

```sql
DROP TABLE IF EXISTS final_data_asset;
CREATE TEMP TABLE final_data_asset AS
WITH first_category AS (
  SELECT
    customer_id,
    category_name,
    CONCAT(
      'You''ve watched ', rental_count, ' ', category_name,
      ' films, that''s ', average_comparison,
      ' more than the DVD Rental Co average and puts you in the top ',
      percentile, '% of ', category_name, ' gurus!'
    ) AS insight
  FROM first_category_insights
),
second_category AS (
  SELECT
    customer_id,
    category_name,
    CONCAT(
      'You''ve watched ', rental_count, ' ', category_name,
      ' films making up ', total_percentage,
      '% of your entire viewing history!'
    ) AS insight
  FROM second_category_insights
),
top_actor AS (
  SELECT
    customer_id,
    -- use INITCAP to transform names into Title case
    CONCAT(INITCAP(first_name), ' ', INITCAP(last_name)) AS actor_name,
    CONCAT(
      'You''ve watched ', rental_count, ' films featuring ',
      INITCAP(first_name), ' ', INITCAP(last_name),
      '! Here are some other films ', INITCAP(first_name),
      ' stars in that might interest you!'
    ) AS insight
  FROM top_actor_counts
),
adjusted_title_case_category_recommendations AS (
  SELECT
    customer_id,
    INITCAP(title) AS title,
    category_rank,
    reco_rank
  FROM category_recommendations
),
wide_category_recommendations AS (
  SELECT
    customer_id,
    MAX(CASE WHEN category_rank = 1  AND reco_rank = 1
      THEN title END) AS cat_1_reco_1,
    MAX(CASE WHEN category_rank = 1  AND reco_rank = 2
      THEN title END) AS cat_1_reco_2,
    MAX(CASE WHEN category_rank = 1  AND reco_rank = 3
      THEN title END) AS cat_1_reco_3,
    MAX(CASE WHEN category_rank = 2  AND reco_rank = 1
      THEN title END) AS cat_2_reco_1,
    MAX(CASE WHEN category_rank = 2  AND reco_rank = 2
      THEN title END) AS cat_2_reco_2,
    MAX(CASE WHEN category_rank = 2  AND reco_rank = 3
      THEN title END) AS cat_2_reco_3
  FROM adjusted_title_case_category_recommendations
  GROUP BY customer_id
),
adjusted_title_case_actor_recommendations AS (
  SELECT
    customer_id,
    INITCAP(title) AS title,
    reco_rank
  FROM actor_recommendations
),
wide_actor_recommendations AS (
  SELECT
    customer_id,
    MAX(CASE WHEN reco_rank = 1 THEN title END) AS actor_reco_1,
    MAX(CASE WHEN reco_rank = 2 THEN title END) AS actor_reco_2,
    MAX(CASE WHEN reco_rank = 3 THEN title END) AS actor_reco_3
  FROM adjusted_title_case_actor_recommendations
  GROUP BY customer_id
),
final_output AS (
  SELECT
    t1.customer_id,
    t1.category_name AS cat_1,
    t4.cat_1_reco_1,
    t4.cat_1_reco_2,
    t4.cat_1_reco_3,
    t2.category_name AS cat_2,
    t4.cat_2_reco_1,
    t4.cat_2_reco_2,
    t4.cat_2_reco_3,
    t3.actor_name AS actor,
    t5.actor_reco_1,
    t5.actor_reco_2,
    t5.actor_reco_3,
    t1.insight AS insight_cat_1,
    t2.insight AS insight_cat_2,
    t3.insight AS insight_actor
FROM first_category AS t1
INNER JOIN second_category AS t2
  ON t1.customer_id = t2.customer_id
INNER JOIN top_actor t3
  ON t1.customer_id = t3.customer_id
INNER JOIN wide_category_recommendations AS t4
  ON t1.customer_id = t4.customer_id
INNER JOIN wide_actor_recommendations AS t5
  ON t1.customer_id = t5.customer_id
)
SELECT * FROM final_output;
```
***

#### :white_check_mark: 4.2.4 Final Output Table

```sql
SELECT * FROM final_data_asset
LIMIT 5;
```

|customer_id|cat_1|cat_1_reco_1|cat_1_reco_2|cat_1_reco_3|cat_2|cat_2_reco_1|cat_2_reco_2|cat_2_reco_3|actor|actor_reco_1|actor_reco_2|actor_reco_3|insight_cat_1|insight_cat_2|insight_actor|
|:----|:----|:----|:----|:----|:----|:----|:----|:----|:----|:----|:----|:----|:----|:----|:----|
|1|Classics|Timberland Sky|Gilmore Boiled|Voyage Legally|Comedy|Zorro Ark|Cat Coneheads|Operation Operation|Val Bolger|Primary Glass|Alaska Phantom|Metropolis Coma|You’ve watched 6 Classics films, that’s 4 more than the DVD Rental Co average and puts you in the top 1% of Classics gurus!|You’ve watched 5 Comedy films making up 16% of your entire viewing history!|You’ve watched 6 films featuring Val Bolger! Here are some other films Val stars in that might interest you!|
|2|Sports|Gleaming Jawbreaker|Talented Homicide|Roses Treasure|Classics|Frost Head|Gilmore Boiled|Voyage Legally|Gina Degeneres|Goodfellas Salute|Wife Turn|Dogma Family|You’ve watched 5 Sports films, that’s 3 more than the DVD Rental Co average and puts you in the top 2% of Sports gurus!|You’ve watched 4 Classics films making up 15% of your entire viewing history!|You’ve watched 5 films featuring Gina Degeneres! Here are some other films Gina stars in that might interest you!|
|3|Action|Rugrats Shakespeare|Suspects Quills|Handicap Boondock|Sci-Fi|Goodfellas Salute|English Bulworth|Graffiti Love|Jayne Nolte|Sweethearts Suspects|Dancing Fever|Invasion Cyclone|You’ve watched 4 Action films, that’s 2 more than the DVD Rental Co average and puts you in the top 4% of Action gurus!|You’ve watched 3 Sci-Fi films making up 12% of your entire viewing history!|You’ve watched 4 films featuring Jayne Nolte! Here are some other films Jayne stars in that might interest you!|
|4|Horror|Pulp Beverly|Family Sweet|Swarm Gold|Drama|Hobbit Alien|Harry Idaho|Witches Panic|Walter Torn|Curtain Videotape|Lies Treatment|Nightmare Chill|You’ve watched 3 Horror films, that’s 2 more than the DVD Rental Co average and puts you in the top 8% of Horror gurus!|You’ve watched 2 Drama films making up 9% of your entire viewing history!|You’ve watched 4 films featuring Walter Torn! Here are some other films Walter stars in that might interest you!|
|5|Classics|Timberland Sky|Frost Head|Gilmore Boiled|Animation|Juggler Hardly|Dogma Family|Storm Happiness|Karl Berry|Virginian Pluto|Stagecoach Armageddon|Telemark Heartbreakers|You’ve watched 7 Classics films, that’s 5 more than the DVD Rental Co average and puts you in the top 1% of Classics gurus!|You’ve watched 6 Animation films making up 16% of your entire viewing history!|You’ve watched 4 films featuring Karl Berry! Here are some other films Karl stars in that might interest you!|

***

:heavy_check_mark: **The marketing team may use this final lookup table in their customer e-mail campaign to promote higher sales and engagement by sharing insights about each customer's viewing behaviour and delivering personalized recommendations!**
