-- Create a function to get a specific course by ID
CREATE OR REPLACE FUNCTION get_course_by_id(p_course_id INT)
RETURNS JSONB AS $$
BEGIN
    RETURN (
        SELECT jsonb_build_object(
            'course_id', course_id,
            'course_name', course_name
        )
        FROM courses
        WHERE course_id = p_course_id
    );
END;
$$ LANGUAGE plpgsql;
