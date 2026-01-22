# Write your MySQL query statement below

    SELECT employee_id,
           SUM(CASE WHEN employee_id % 2 = 1 AND name NOT LIKE 'M%'THEN 1.0 * salary ELSE 0 END) AS bonus
    FROM Employees
    GROUP BY employee_id
    ORDER BY employee_id 
