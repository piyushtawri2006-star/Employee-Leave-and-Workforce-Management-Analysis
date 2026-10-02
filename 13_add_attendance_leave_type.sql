USE workforce_db;

ALTER TABLE attendance
    ADD COLUMN leave_type_id INT NULL AFTER status;

ALTER TABLE attendance
    ADD CONSTRAINT fk_attendance_leave_type
    FOREIGN KEY (leave_type_id) REFERENCES leave_types(leave_type_id)
    ON DELETE SET NULL;