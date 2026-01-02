# Write your MySQL query statement below
SELECT a.name AS Employee
FROM Employee a 
JOIN Employee b ON b.id = a.managerId
WHERE a.salary > b.salary