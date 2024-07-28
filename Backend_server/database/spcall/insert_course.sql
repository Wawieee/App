-- Create a stored procedure to insert data into the "colleges" table
CREATE OR REPLACE FUNCTION insert_course(
    p_course_name VARCHAR(100)
)
RETURNS VOID AS $$
BEGIN
    INSERT INTO course(course_name)
    VALUES (p_course_name);
END;
$$ LANGUAGE plpgsql;

-- Example usage of the stored procedure
SELECT insert_course('Computer Science');
