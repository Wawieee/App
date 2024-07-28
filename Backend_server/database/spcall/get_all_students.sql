CREATE OR REPLACE FUNCTION get_students()
RETURNS JSON
AS $$
DECLARE
    result_json JSON;
BEGIN
    SELECT
        json_agg(json_build_object(
            'student_id', student_id,
            'student_name', student_name,
            'course_name', course_name
        )) INTO result_json
    FROM (
        SELECT
            s.student_id,
            s.student_name,
            c.course_name
        FROM
            public.students s
        JOIN
            public.courses c ON s.course_id = c.course_id
        ORDER BY
            s.student_id
    ) subquery;

    RETURN result_json;
END;
$$ LANGUAGE plpgsql;

	SELECT * FROM get_students()
