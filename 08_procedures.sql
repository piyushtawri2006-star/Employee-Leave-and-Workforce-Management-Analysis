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
