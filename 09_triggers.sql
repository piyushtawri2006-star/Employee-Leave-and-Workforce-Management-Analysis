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
