-- Delete a specific course by ID
CREATE OR REPLACE FUNCTION delete_course_by_id(p_course_id INT)
RETURNS VOID AS $$
BEGIN
    DELETE FROM courses WHERE course_id = p_course_id;
END;
$$ LANGUAGE plpgsql;
