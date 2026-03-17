# Write your MySQL query statement below
WITH first_positive AS (
    SELECT p.patient_id,
           MIN(t.test_date) AS first_positive_test
    FROM patients p
    JOIN covid_tests t ON p.patient_id = t.patient_id
    WHERE result = 'positive'
    GROUP BY patient_id
),
first_negative AS (
    SELECT f.patient_id,
           MIN(t.test_date) AS first_negative_test
    FROM first_positive f 
    JOIN covid_tests t ON f.patient_id = t.patient_id
    AND t.test_date > f.first_positive_test
    WHERE t.result = 'negative'
    GROUP BY f.patient_id
)
SELECT a.patient_id,
       c.patient_name,
       c.age,
       DATEDIFF(b.first_negative_test,a.first_positive_test) AS recovery_time
FROM first_positive a 
JOIN first_negative b ON a.patient_id = b.patient_id
JOIN patients c ON a.patient_id = c.patient_id
ORDER BY recovery_time ASC, c.patient_name ASC