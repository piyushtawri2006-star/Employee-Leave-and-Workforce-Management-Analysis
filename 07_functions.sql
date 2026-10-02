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
