-- Create a function to update a specific course by ID
CREATE OR REPLACE FUNCTION update_course_by_id(
    p_course_id INT,
    p_course_name VARCHAR(100)
)
RETURNS VOID AS $$
BEGIN
    UPDATE courses
    SET
        course_name = p_course_name
    WHERE
        course_id = p_course_id;
END;
$$ LANGUAGE plpgsql;
