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