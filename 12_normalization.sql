USE workforce_db;

-- 1NF: Atomic values and one leave request per row

-- 2NF: Employee and Leave Request information are separated

-- 3NF: Department information is separated to remove transitive dependency

-- Final 3NF structure

CREATE TABLE IF NOT EXISTS normalization_demo_departments (
    Department_ID INT PRIMARY KEY,
    Department_Name VARCHAR(100) NOT NULL,
    Location VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS normalization_demo_employees (
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

CREATE TABLE IF NOT EXISTS normalization_demo_leave_types (
    Leave_Type_ID INT PRIMARY KEY,
    Leave_Type_Name VARCHAR(50) NOT NULL,
    Total_Days INT
);

CREATE TABLE IF NOT EXISTS normalization_demo_leave_requests (
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

CREATE TABLE IF NOT EXISTS normalization_demo_attendance (
    Attendance_ID INT PRIMARY KEY,
    Employee_ID INT NOT NULL,
    Attendance_Date DATE,
    Status VARCHAR(20),
    Check_In TIME,
    Check_Out TIME,
    FOREIGN KEY (Employee_ID)
        REFERENCES normalization_demo_employees(Employee_ID)
);