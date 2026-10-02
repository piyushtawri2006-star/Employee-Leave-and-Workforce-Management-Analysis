USE workforce_db;

-- Employees with department and salary
SELECT e.employee_id,e.name,d.department_name,e.salary
FROM employees e JOIN departments d ON e.department_id=d.department_id
WHERE e.salary >= (SELECT AVG(salary) FROM employees);

-- Department-wise statistics
SELECT d.department_name,COUNT(e.employee_id) employee_count,
       ROUND(AVG(e.salary),2) avg_salary,
       MIN(e.salary) min_salary,MAX(e.salary) max_salary
FROM departments d LEFT JOIN employees e ON d.department_id=e.department_id
GROUP BY d.department_id,d.department_name
ORDER BY employee_count DESC;

-- Leave report
SELECT e.name,lt.leave_type_name,l.start_date,l.end_date,l.status
FROM leave_requests l
JOIN employees e ON l.employee_id=e.employee_id
JOIN leave_types lt ON l.leave_type_id=lt.leave_type_id;

-- Attendance percentage
SELECT e.name,
ROUND(100*SUM(CASE WHEN a.status='Present' THEN 1 ELSE 0 END)/NULLIF(COUNT(a.attendance_id),0),2) attendance_percentage
FROM employees e LEFT JOIN attendance a ON e.employee_id=a.employee_id
GROUP BY e.employee_id,e.name;
