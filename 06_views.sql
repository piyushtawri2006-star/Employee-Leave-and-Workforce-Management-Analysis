USE workforce_db;

CREATE OR REPLACE VIEW employee_department_view AS
SELECT e.employee_id,e.employee_code,e.name,e.email,d.department_name,e.designation,e.salary,e.status
FROM employees e LEFT JOIN departments d ON e.department_id=d.department_id;

CREATE OR REPLACE VIEW leave_report_view AS
SELECT l.leave_id,e.name employee_name,lt.leave_type_name,
       l.start_date,l.end_date,l.status,l.reason,l.applied_on
FROM leave_requests l
JOIN employees e ON l.employee_id=e.employee_id
JOIN leave_types lt ON l.leave_type_id=lt.leave_type_id;

SELECT * FROM employee_department_view;
SELECT * FROM leave_report_view;
