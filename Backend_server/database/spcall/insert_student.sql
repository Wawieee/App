CREATE OR REPLACE FUNCTION insert_student(
    p_student_name VARCHAR(100),
	p_course_id INT 
)
RETURNS VOID AS $$
BEGIN
    INSERT INTO students(student_name, course_id)
    VALUES (p_student_name, p_course_id);
END;
$$ LANGUAGE plpgsql;

-- Example usage of the stored procedure
SELECT insert_student('Edejed A. Paculba', 1);
