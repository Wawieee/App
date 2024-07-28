CREATE OR REPLACE FUNCTION get_student_by_id(p_student_id INT)
RETURNS JSON
AS $$
BEGIN
    RETURN (
        SELECT json_build_object(
            'student_id', s.student_id,
            'student_name', s.student_name,
            'course_name', c.course_name
        )
        FROM public.students s
        JOIN public.courses c ON s.course_id = c.course_id
        WHERE s.student_id = p_student_id
    );
END;
$$ LANGUAGE plpgsql;

SELECT get_student_by_id(1);
