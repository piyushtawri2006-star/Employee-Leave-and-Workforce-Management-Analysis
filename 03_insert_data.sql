USE workforce_db;

INSERT IGNORE INTO departments(department_name,location) VALUES
('HR','Pune'),('IT','Mumbai'),('Finance','Pune'),('Sales','Delhi');

INSERT IGNORE INTO employees(employee_code,name,email,phone,gender,department_id,designation,joining_date,salary,status) VALUES
('EMP001','Rahul Sharma','rahul@example.com','9876543210','Male',1,'HR Executive','2024-01-10',45000,'Active'),
('EMP002','Priya Singh','priya@example.com','9876543211','Female',2,'Software Developer','2023-06-15',65000,'Active'),
('EMP003','Amit Kumar','amit@example.com','9876543212','Male',3,'Accountant','2022-03-20',55000,'Active'),
('EMP004','Neha Patel','neha@example.com','9876543213','Female',4,'Sales Executive','2025-02-01',42000,'Active'),
('EMP005','Rohan Verma','rohan@example.com','9876543214','Male',2,'Data Analyst','2024-08-12',60000,'Active'),
('EMP006','Sneha Joshi','sneha@example.com','9876543215','Female',1,'Recruiter','2023-11-05',48000,'Active'),
('EMP007','Vikas Mehta','vikas@example.com','9876543216','Male',3,'Finance Analyst','2021-09-18',58000,'Active'),
('EMP008','Kavya Shah','kavya@example.com','9876543217','Female',4,'Sales Manager','2020-07-10',72000,'Active');

INSERT IGNORE INTO leave_types(leave_type_name,total_days) VALUES
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

INSERT IGNORE INTO attendance(employee_id,attendance_date,status,check_in,check_out) VALUES
(1,'2026-08-25','Present','09:15:00','17:30:00'),
(2,'2026-08-25','Present','09:00:00','18:00:00'),
(3,'2026-08-25','Absent',NULL,NULL),
(4,'2026-08-25','Present','09:30:00','17:00:00'),
(5,'2026-08-25','Present','09:10:00','18:10:00'),
(6,'2026-08-25','Present','09:05:00','17:45:00'),
(7,'2026-08-25','Absent',NULL,NULL),
(8,'2026-08-25','Present','09:20:00','18:00:00');

INSERT IGNORE INTO users(username,password,role,employee_id)
SELECT 'admin','admin123','Admin',1
WHERE NOT EXISTS (SELECT 1 FROM users WHERE username='admin');
USE workforce_db;

SELECT * FROM employees;
