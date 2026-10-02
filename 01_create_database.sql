CREATE DATABASE workforce_db;
USE workforce_db;


CREATE TABLE departments(
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(100) NOT NULL UNIQUE,
    location VARCHAR(100),
    employees int
);

select * from departments;

CREATE TABLE employees(
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_code VARCHAR(20) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(120) UNIQUE,
    phone VARCHAR(20),
    gender VARCHAR(20),
    department_id INT,
    designation VARCHAR(100),
    joining_date DATE,
    salary DECIMAL(10,2),
    status VARCHAR(20) DEFAULT 'Active',
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
        ON UPDATE CASCADE ON DELETE SET NULL
);
select * from employees;

CREATE TABLE leave_types(
    leave_type_id INT PRIMARY KEY AUTO_INCREMENT,
    leave_type_name VARCHAR(50) NOT NULL UNIQUE,
    total_days INT NOT NULL DEFAULT 0
);
select * from leave_requests;

CREATE TABLE leave_requests(
    leave_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT NOT NULL,
    leave_type_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    reason VARCHAR(255),
    status VARCHAR(20) DEFAULT 'Pending',
    applied_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    approved_by INT NULL,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE CASCADE,
    FOREIGN KEY (leave_type_id) REFERENCES leave_types(leave_type_id),
    FOREIGN KEY (approved_by) REFERENCES employees(employee_id) ON DELETE SET NULL
);

CREATE TABLE attendance(
    attendance_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT NOT NULL,
    attendance_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL,
    check_in TIME NULL,
    check_out TIME NULL,
    UNIQUE(employee_id, attendance_date),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE CASCADE
);

select *from attendance;

CREATE TABLE users(
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL DEFAULT 'Employee',
    employee_id INT NULL,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE SET NULL
);

CREATE TABLE audit_log(
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    table_name VARCHAR(50),
    operation VARCHAR(20),
    record_id INT,
    log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    details VARCHAR(255)
);
select * from audit_log;

USE workforce_db;

INSERT INTO departments(department_name,location) VALUES
('HR','Pune'),('IT','Mumbai'),('Finance','Pune'),('Sales','Delhi');

INSERT INTO employees(employee_code,name,email,phone,gender,department_id,designation,joining_date,salary,status) VALUES
('EMP001','Rahul Sharma','rahul@example.com','9876543210','Male',1,'HR Executive','2024-01-10',45000,'Active'),
('EMP002','Priya Singh','priya@example.com','9876543211','Female',2,'Software Developer','2023-06-15',65000,'Active'),
('EMP003','Amit Kumar','amit@example.com','9876543212','Male',3,'Accountant','2022-03-20',55000,'Active'),
('EMP004','Neha Patel','neha@example.com','9876543213','Female',4,'Sales Executive','2025-02-01',42000,'Active'),
('EMP005','Rohan Verma','rohan@example.com','9876543214','Male',2,'Data Analyst','2024-08-12',60000,'Active'),
('EMP006','Sneha Joshi','sneha@example.com','9876543215','Female',1,'Recruiter','2023-11-05',48000,'Active'),
('EMP007','Vikas Mehta','vikas@example.com','9876543216','Male',3,'Finance Analyst','2021-09-18',58000,'Active'),
('EMP008','Kavya Shah','kavya@example.com','9876543217','Female',4,'Sales Manager','2020-07-10',72000,'Active');
select * from employees;

INSERT INTO leave_types(leave_type_name,total_days) VALUES
('Casual Leave',12),('Sick Leave',10),('Earned Leave',15);

INSERT INTO leave_requests(employee_id,leave_type_id,start_date,end_date,reason,status)
SELECT 1,1,'2026-08-10','2026-08-11','Personal work','Approved'
WHERE NOT EXISTS (SELECT 1 FROM leave_requests WHERE employee_id=1 AND start_date='2026-08-10');

INSERT INTO leave_requests(employee_id,leave_type_id,start_date,end_date,reason,status)
SELECT 2,2,'2026-08-15','2026-08-16','Not feeling well','Pending'
WHERE NOT EXISTS (SELECT 1 FROM leave_requests WHERE employee_id=2 AND start_date='2026-08-15');

INSERT INTO leave_requests(employee_id,leave_type_id,start_date,end_date,reason,status)
SELECT 4,1,'2026-08-20','2026-08-22','Family function','Rejected'
WHERE NOT EXISTS (SELECT 1 FROM leave_requests WHERE employee_id=4 AND start_date='2026-08-20');

INSERT INTO attendance(employee_id,attendance_date,status,check_in,check_out) VALUES
(1,'2026-08-25','Present','09:15:00','17:30:00'),
(2,'2026-08-25','Present','09:00:00','18:00:00'),
(3,'2026-08-25','Absent',NULL,NULL),
(4,'2026-08-25','Present','09:30:00','17:00:00'),
(5,'2026-08-25','Present','09:10:00','18:10:00'),
(6,'2026-08-25','Present','09:05:00','17:45:00'),
(7,'2026-08-25','Absent',NULL,NULL),
(8,'2026-08-25','Present','09:20:00','18:00:00');

INSERT INTO users(username,password,role,employee_id)
SELECT 'admin','admin123','Admin',1
WHERE NOT EXISTS (SELECT 1 FROM users WHERE username='admin');
USE workforce_db;

SELECT * FROM employees;

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

USE workforce_db;

DROP FUNCTION IF EXISTS leave_days;
DELIMITER //
CREATE FUNCTION leave_days(p_start DATE,p_end DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(p_end,p_start)+1;
END//
DELIMITER ;

SELECT leave_days('2026-08-10','2026-08-12') AS total_leave_days;

USE workforce_db;

DROP PROCEDURE IF EXISTS add_employee;
DELIMITER //
CREATE PROCEDURE add_employee(
    IN p_code VARCHAR(20), IN p_name VARCHAR(100), IN p_email VARCHAR(120),
    IN p_phone VARCHAR(20), IN p_department INT, IN p_designation VARCHAR(100),
    IN p_salary DECIMAL(10,2)
)
BEGIN
    INSERT INTO employees(employee_code,name,email,phone,department_id,designation,salary)
    VALUES(p_code,p_name,p_email,p_phone,p_department,p_designation,p_salary);
END//
DELIMITER ;

DROP PROCEDURE IF EXISTS approve_leave;
DELIMITER //
CREATE PROCEDURE approve_leave(IN p_leave_id INT, IN p_approver INT)
BEGIN
    UPDATE leave_requests
    SET status='Approved', approved_by=p_approver
    WHERE leave_id=p_leave_id;
END//
DELIMITER ;

-- Example:
-- CALL add_employee('EMP009','Test User','test@example.com','9999999999',2,'Intern',25000);
-- CALL approve_leave(1,1);


USE workforce_db;

DROP TRIGGER IF EXISTS after_employee_insert;
DELIMITER //
CREATE TRIGGER after_employee_insert
AFTER INSERT ON employees
FOR EACH ROW
BEGIN
    INSERT INTO audit_log(table_name,operation,record_id,details)
    VALUES('employees','INSERT',NEW.employee_id,CONCAT('Employee added: ',NEW.name));
END//
DELIMITER ;

DROP TRIGGER IF EXISTS after_leave_update;
DELIMITER //
CREATE TRIGGER after_leave_update
AFTER UPDATE ON leave_requests
FOR EACH ROW
BEGIN
    IF OLD.status <> NEW.status THEN
        INSERT INTO audit_log(table_name,operation,record_id,details)
        VALUES('leave_requests','UPDATE',NEW.leave_id,
               CONCAT('Status changed from ',OLD.status,' to ',NEW.status));
    END IF;
END//
DELIMITER ;

USE workforce_db;

DROP PROCEDURE IF EXISTS employee_cursor_demo;
DELIMITER //
CREATE PROCEDURE employee_cursor_demo()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE emp_name VARCHAR(100);
    DECLARE result_text TEXT DEFAULT '';
    DECLARE cur CURSOR FOR SELECT name FROM employees ORDER BY employee_id;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done=TRUE;

    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO emp_name;
        IF done THEN LEAVE read_loop; END IF;
        SET result_text=CONCAT(result_text,emp_name,' | ');
    END LOOP;
    CLOSE cur;

    SELECT result_text AS employee_names;
END//
DELIMITER ;

-- CALL employee_cursor_demo();

USE workforce_db;

-- Run this file only with MySQL administrator privileges.
CREATE USER IF NOT EXISTS 'workforce_user'@'localhost' IDENTIFIED BY 'workforce123';
GRANT SELECT,INSERT,UPDATE ON workforce_db.* TO 'workforce_user'@'localhost';
REVOKE DELETE ON workforce_db.* FROM 'workforce_user'@'localhost';
SHOW GRANTS FOR 'workforce_user'@'localhost';

USE workforce_db;

-- 1NF: Atomic values and one leave request per row

-- 2NF: Employee and Leave Request information are separated

-- 3NF: Department information is separated to remove transitive dependency

-- Final 3NF structure

CREATE TABLE normalization_demo_departments(
    Department_ID INT PRIMARY KEY,
    Department_Name VARCHAR(100) NOT NULL,
    Location VARCHAR(100)
);

CREATE TABLE normalization_demo_employees(
    Employee_ID INT PRIMARY KEY,
    Employee_Code VARCHAR(20) UNIQUE NOT NULL,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100),
    Phone VARCHAR(20),
    Gender VARCHAR(10),
    Department_ID INT,
    Designation VARCHAR(100),
    Joining_Date DATE,
    Salary DECIMAL(10,2),
    Status VARCHAR(20),
    FOREIGN KEY (Department_ID)
        REFERENCES normalization_demo_departments(Department_ID)
);

CREATE TABLE normalization_demo_leave_types(
    Leave_Type_ID INT PRIMARY KEY,
    Leave_Type_Name VARCHAR(50) NOT NULL,
    Total_Days INT
);

CREATE TABLE normalization_demo_leave_requests(
    Leave_ID INT PRIMARY KEY,
    Employee_ID INT NOT NULL,
    Leave_Type_ID INT NOT NULL,
    Start_Date DATE,
    End_Date DATE,
    Reason VARCHAR(255),
    Status VARCHAR(20),
    Applied_On DATE,
    Approved_By INT,
    FOREIGN KEY (Employee_ID)
        REFERENCES normalization_demo_employees(Employee_ID),
    FOREIGN KEY (Leave_Type_ID)
        REFERENCES normalization_demo_leave_types(Leave_Type_ID)
);

CREATE TABLE normalization_demo_attendance(
    Attendance_ID INT PRIMARY KEY,
    Employee_ID INT NOT NULL,
    Attendance_Date DATE,
    Status VARCHAR(20),
    Check_In TIME,
    Check_Out TIME,
    FOREIGN KEY (Employee_ID)
        REFERENCES normalization_demo_employees(Employee_ID)
);
select * from normalization_demo_leave_requests;




