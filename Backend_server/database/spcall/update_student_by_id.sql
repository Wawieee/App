CREATE OR REPLACE FUNCTION update_student_by_id(
    p_student_id INT,
    p_student_name VARCHAR(255),
    p_course_id INT 
)
RETURNS VOID
AS $$
BEGIN
    UPDATE public.students
    SET
        student_name = p_student_name,
        course_id = p_course_id
    WHERE student_id = p_student_id;
END;
$$ LANGUAGE plpgsql;


SELECT update_student_by_id(1, 'New Student Name', 2);
