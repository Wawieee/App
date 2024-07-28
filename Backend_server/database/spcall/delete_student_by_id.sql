-- Delete a specific course by ID
CREATE OR REPLACE FUNCTION delete_student_by_id(p_student_id INT)
RETURNS VOID AS $$
BEGIN
    DELETE FROM students WHERE student_id = p_student_id;
END;
$$ LANGUAGE plpgsql;
