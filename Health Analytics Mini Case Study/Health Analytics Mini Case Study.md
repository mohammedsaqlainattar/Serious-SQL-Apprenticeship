# 👨🏻‍⚕️ Health Analytics Mini Case Study 🩺

**We’ve just received an urgent request from the General Manager of Analytics at Health Co requesting our assistance with their analysis of the  `health.user_logs`  dataset.**

**The Health Co analytics team have shared with us their SQL script - they unfortunately ran into a few bugs that they couldn’t fix!**

**We’ve been asked to quickly debug their SQL script and use the resulting query outputs to quickly answer a few questions that the GM has requested for a board meeting about their active users.**

# :pushpin: Solutions

1.  **How many unique users exist in the logs dataset?**

```sql
SELECT 
  COUNT(DISTINCT(id)) 
FROM health.user_logs;
```
|unique_users|
|:---:|
|554|

There are 554 unique users in the logs dataset.

***
**To answer Q2-Q8, let's create a temporary table**

```sql
DROP TABLE IF EXISTS user_measure_count;

CREATE TEMP TABLE user_measure_count AS(
SELECT
  id,
  COUNT(*) AS measure_count,
  COUNT(DISTINCT measure) as unique_measure_count
FROM health.user_logs
GROUP BY id
);
```
|id|measure_count|unique_measure_count|
|:---:|:---:|:---:|
|004beb6711843b214e80d73df57a3680fdf9700a|3|2|
|007fe1259a4283a991e1f2835ddcdedacf78dde9|1|1|
|008dd1dc1728bb0b420188963905d259c5533149|1|1|
|00ae4fa0241952312d518cee728a387bf156f514|4|1|
|0115244529929acd03b01315cff7eabfb9f126af|1|1|
|01c0c7f442e3c15fce73ea8b7b045067a7024e69|1|1|

***

2. **How many total measurements do we have per user on average?**

```sql
SELECT
  ROUND(AVG(measure_count),2) AS avg_measurements
FROM user_measure_count;
```
|avg_measurements|
|:---:|
|79.23|

On average, there are 79 measurements per user.
***
3. **What about the median number of measurements per user?**

```sql
SELECT
  PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY measure_count) AS median_measurements
FROM user_measure_count;
```
|median_measurements|
|:---:|
|2|

The median measurements per user is 2.
***
4. **How many users have 3 or more measurements?**

```sql
SELECT
  COUNT(*) AS three_or_more_measurements
FROM user_measure_count
WHERE measure_count >=3;
```
|three_or_more_measurements|
|:---:|
|209|

There are 209 users with 3 or more measurements.
***
5. **How many users have 1,000 or more measurements?**

```sql
SELECT
  COUNT(*) AS thousand_or_more_measurements
FROM user_measure_count
WHERE measure_count >=1000;
```
|three_or_more_measurements|
|:---:|
|5|

There are 5 users with 1000 or more measurements.
***

6. **Looking at the logs data - what is the number and percentage of the active user base who : Have logged blood glucose measurements?**

```sql
SELECT
  measure,
  COUNT(DISTINCT(id)) AS total_unique_ids,
  ROUND(100 * COUNT(DISTINCT(id)) / SUM(COUNT(DISTINCT(id))) OVER(),2) AS percentage
FROM health.user_logs
GROUP BY measure;
```
|measure|total_unique_ids|percentage|
|:----|:----|:----|
|blood_glucose|325|40.22|
|blood_pressure|123|15.22|
|weight|360|44.55|
***
7. **Looking at the logs data - what is the number and percentage of the active user base who : Have at least 2 types of measurements?**

```sql
DROP TABLE IF EXISTS user_measure_count;

CREATE TEMP TABLE user_measure_count AS(
SELECT
  id,
  COUNT(*) AS measure_count,
  COUNT(DISTINCT measure) as unique_measure_count
FROM health.user_logs
GROUP BY id
);

WITH measure_atleast_two_cte AS (
SELECT
  *
FROM user_measure_count
WHERE unique_measure_count >= 2
)

SELECT 
  COUNT(DISTINCT M.id) AS unique_users,
  ROUND(100 * COUNT(DISTINCT M.id)::NUMERIC / COUNT(DISTINCT U.id),2) AS percentage
FROM user_measure_count AS U 
LEFT JOIN measure_atleast_two_cte AS M
ON U.id = M.id;

--**OR**--

SELECT 
  COUNT(DISTINCT id) AS unique_users,
  ROUND(100*
  (SELECT COUNT(DISTINCT id) FROM measure_atleast_two_cte)::NUMERIC / 
  (SELECT COUNT(DISTINCT id) FROM user_measure_count),2) AS percentage
FROM measure_atleast_two_cte;
```
|unique_users|percentage|
|:---:|:---:|
|204|36.82|

Out of 554 users, 204 unique users i.e almost 37% have atleast two types of measurements.
***

8. **Looking at the logs data - what is the number and percentage of the active user base who : Have all 3 measures - blood glucose, weight and blood pressure?**

```sql
DROP TABLE IF EXISTS user_measure_count;

CREATE TEMP TABLE user_measure_count AS(
SELECT
  id,
  COUNT(*) AS measure_count,
  COUNT(DISTINCT measure) as unique_measure_count
FROM health.user_logs
GROUP BY id
);

WITH all_measures_cte AS (
SELECT
  *
FROM user_measure_count
WHERE unique_measure_count = 3
)

SELECT 
  COUNT(DISTINCT M.id) AS unique_users,
  ROUND(100 * COUNT(DISTINCT M.id)::NUMERIC / COUNT(DISTINCT U.id),2) AS percentage
FROM user_measure_count AS U 
LEFT JOIN all_measures_cte AS M
ON U.id = M.id;

--**OR**--

SELECT 
  COUNT(DISTINCT id) AS unique_users,
  ROUND(100*
  (SELECT COUNT(DISTINCT id) FROM all_measures_cte)::NUMERIC / 
  (SELECT COUNT(DISTINCT id) FROM user_measure_count),2) AS percentage
FROM all_measures_cte;
```
|unique_users|percentage|
|:---:|:---:|
|50|9.03|

Out of 554 users, 50 unique users i.e approx 9% have all 3 measurements.
***

9. **For users that have blood pressure measurements: What is the median systolic/diastolic blood pressure values?**

```sql
SELECT
  'blood_pressure' AS measure_name,
  PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY systolic) AS systolic_median,
  PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY diastolic) AS diastolic_median
FROM health.user_logs
WHERE measure = 'blood_pressure';
``` 
|measure_name|systolic_median|diastolic_median|
|:---:|:---:|:---:|
|blood_pressure|126|79|
***
