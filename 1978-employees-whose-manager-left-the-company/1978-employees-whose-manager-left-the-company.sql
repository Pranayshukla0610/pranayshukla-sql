# Write your MySQL query statement below
WITH sort_salary AS (
    SELECT employee_id,
           name,
           manager_id,
           salary
    FROM Employees
    WHERE salary < 30000
)
SELECT employee_id
FROM sort_salary
WHERE manager_id NOT IN (SELECT employee_id FROM Employees)
AND manager_id IS NOT NULL
ORDER BY employee_id DESC