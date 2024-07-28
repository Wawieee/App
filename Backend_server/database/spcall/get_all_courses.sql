-- Create a function to get data from the "courses" table
CREATE OR REPLACE FUNCTION get_courses()
RETURNS JSONB AS $$
BEGIN
    RETURN (
        SELECT jsonb_agg(jsonb_build_object(
            'course_id', course_id,
            'course_name', course_name
        ))
        FROM courses
    );
END;
$$ LANGUAGE plpgsql;


