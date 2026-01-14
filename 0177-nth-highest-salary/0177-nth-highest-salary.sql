CREATE FUNCTION getNthHighestSalary(n INT) RETURNS INT
BEGIN
  RETURN (
    WITH n_salary AS (
        SELECT salary,
               DENSE_RANK() OVER (ORDER BY salary DESC) AS rnk
        FROM Employee
    )
    SELECT MAX(salary)
    FROM n_salary
    WHERE rnk = n
  );
END
