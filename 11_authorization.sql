USE workforce_db;

-- Run this file only with MySQL administrator privileges.
CREATE USER IF NOT EXISTS 'workforce_user'@'localhost' IDENTIFIED BY 'workforce123';
GRANT SELECT,INSERT,UPDATE ON workforce_db.* TO 'workforce_user'@'localhost';
REVOKE DELETE ON workforce_db.* FROM 'workforce_user'@'localhost';
SHOW GRANTS FOR 'workforce_user'@'localhost';
