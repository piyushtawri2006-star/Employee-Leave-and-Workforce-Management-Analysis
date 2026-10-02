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
