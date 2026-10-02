USE workforce_db;

-- SELECT and WHERE
SELECT * FROM employees;
SELECT name,email,salary FROM employees WHERE salary > 50000;

-- ORDER BY
SELECT * FROM employees ORDER BY salary DESC;

-- UPDATE
UPDATE employees SET salary = salary + 1000 WHERE employee_id = 1;

-- DELETE example (commented for safety)
-- DELETE FROM employees WHERE employee_id = 8;

-- INNER JOIN
SELECT e.name,d.department_name
FROM employees e INNER JOIN departments d ON e.department_id=d.department_id;

-- LEFT JOIN
SELECT d.department_name,e.name
FROM departments d LEFT JOIN employees e ON d.department_id=e.department_id;

-- Aggregate functions
SELECT COUNT(*) AS total_employees FROM employees;
SELECT SUM(salary) AS total_salary, AVG(salary) AS average_salary,
       MIN(salary) AS minimum_salary, MAX(salary) AS maximum_salary
FROM employees;

-- GROUP BY and HAVING
SELECT department_id, COUNT(*) AS employee_count
FROM employees GROUP BY department_id HAVING COUNT(*) >= 1;

-- NULL
SELECT * FROM employees WHERE email IS NULL;
SELECT * FROM employees WHERE department_id IS NOT NULL;

-- Nested subquery
SELECT name,salary FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

-- UNION
SELECT name FROM employees WHERE department_id=1
UNION
SELECT name FROM employees WHERE department_id=2;
