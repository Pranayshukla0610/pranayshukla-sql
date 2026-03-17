# Write your MySQL query statement below
WITH RECURSIVE hierarchy AS (
    -- Step 1: Start from CEO
    SELECT 
        employee_id,
        employee_name,
        manager_id,
        salary,
        1 AS level
    FROM Employees
    WHERE manager_id IS NULL

    UNION ALL

    -- Step 2: Build levels
    SELECT 
        e.employee_id,
        e.employee_name,
        e.manager_id,
        e.salary,
        h.level + 1
    FROM Employees e
    JOIN hierarchy h
        ON e.manager_id = h.employee_id
),

subordinates AS (
    -- Each employee is root of their subtree
    SELECT 
        employee_id AS manager_id,
        employee_id AS subordinate_id
    FROM Employees

    UNION ALL

    -- Expand all descendants
    SELECT 
        s.manager_id,
        e.employee_id
    FROM subordinates s
    JOIN Employees e
        ON e.manager_id = s.subordinate_id
)

SELECT 
    h.employee_id,
    h.employee_name,
    h.level,
    COUNT(s.subordinate_id) - 1 AS team_size,   -- exclude self
    SUM(e.salary) AS budget
FROM hierarchy h
JOIN subordinates s
    ON h.employee_id = s.manager_id
JOIN Employees e
    ON s.subordinate_id = e.employee_id
GROUP BY 
    h.employee_id, 
    h.employee_name, 
    h.level
ORDER BY 
    h.level ASC,
    budget DESC,
    h.employee_name ASC;