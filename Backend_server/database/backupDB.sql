PGDMP         #                  |            api    15.2    15.2                0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false                       0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false                       0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false                       1262    86695    api    DATABASE     |   CREATE DATABASE api WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_Philippines.1252';
    DROP DATABASE api;
                postgres    false            �            1255    86855    delete_course_by_id(integer)    FUNCTION     �   CREATE FUNCTION public.delete_course_by_id(p_course_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM courses WHERE course_id = p_course_id;
END;
$$;
 ?   DROP FUNCTION public.delete_course_by_id(p_course_id integer);
       public          postgres    false            �            1255    86863    delete_student_by_id(integer)    FUNCTION     �   CREATE FUNCTION public.delete_student_by_id(p_student_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM students WHERE student_id = p_student_id;
END;
$$;
 A   DROP FUNCTION public.delete_student_by_id(p_student_id integer);
       public          postgres    false            �            1255    86853    get_course_by_id(integer)    FUNCTION     @  CREATE FUNCTION public.get_course_by_id(p_course_id integer) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
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
$$;
 <   DROP FUNCTION public.get_course_by_id(p_course_id integer);
       public          postgres    false            �            1255    86849    get_courses()    FUNCTION       CREATE FUNCTION public.get_courses() RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN (
        SELECT jsonb_agg(jsonb_build_object(
            'course_id', course_id,
            'course_name', course_name
        ))
        FROM courses
    );
END;
$$;
 $   DROP FUNCTION public.get_courses();
       public          postgres    false            �            1255    86861    get_student_by_id(integer)    FUNCTION     �  CREATE FUNCTION public.get_student_by_id(p_student_id integer) RETURNS json
    LANGUAGE plpgsql
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
$$;
 >   DROP FUNCTION public.get_student_by_id(p_student_id integer);
       public          postgres    false            �            1255    86860    get_students()    FUNCTION     p  CREATE FUNCTION public.get_students() RETURNS json
    LANGUAGE plpgsql
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
$$;
 %   DROP FUNCTION public.get_students();
       public          postgres    false            �            1255    86852     insert_course(character varying)    FUNCTION     �   CREATE FUNCTION public.insert_course(p_course_name character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO courses(course_name)
    VALUES (p_course_name);
END;
$$;
 E   DROP FUNCTION public.insert_course(p_course_name character varying);
       public          postgres    false            �            1255    86857 *   insert_student(character varying, integer)    FUNCTION     �   CREATE FUNCTION public.insert_student(p_student_name character varying, p_course_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO students(student_name, course_id)
    VALUES (p_student_name, p_course_id);
END;
$$;
 \   DROP FUNCTION public.insert_student(p_student_name character varying, p_course_id integer);
       public          postgres    false            �            1255    86854 /   update_course_by_id(integer, character varying)    FUNCTION       CREATE FUNCTION public.update_course_by_id(p_course_id integer, p_course_name character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE courses
    SET
        course_name = p_course_name
    WHERE
        course_id = p_course_id;
END;
$$;
 `   DROP FUNCTION public.update_course_by_id(p_course_id integer, p_course_name character varying);
       public          postgres    false            �            1255    86862 9   update_student_by_id(integer, character varying, integer)    FUNCTION     C  CREATE FUNCTION public.update_student_by_id(p_student_id integer, p_student_name character varying, p_course_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE public.students
    SET
        student_name = p_student_name,
        course_id = p_course_id
    WHERE student_id = p_student_id;
END;
$$;
 x   DROP FUNCTION public.update_student_by_id(p_student_id integer, p_student_name character varying, p_course_id integer);
       public          postgres    false            �            1259    86815    courses    TABLE     q   CREATE TABLE public.courses (
    course_id integer NOT NULL,
    course_name character varying(100) NOT NULL
);
    DROP TABLE public.courses;
       public         heap    postgres    false            �            1259    86814    courses_course_id_seq    SEQUENCE     �   CREATE SEQUENCE public.courses_course_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.courses_course_id_seq;
       public          postgres    false    215                       0    0    courses_course_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.courses_course_id_seq OWNED BY public.courses.course_id;
          public          postgres    false    214            �            1259    86827    students    TABLE     �   CREATE TABLE public.students (
    student_id integer NOT NULL,
    student_name character varying(100) NOT NULL,
    course_id integer
);
    DROP TABLE public.students;
       public         heap    postgres    false            �            1259    86826    students_student_id_seq    SEQUENCE     �   CREATE SEQUENCE public.students_student_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.students_student_id_seq;
       public          postgres    false    217                       0    0    students_student_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.students_student_id_seq OWNED BY public.students.student_id;
          public          postgres    false    216            t           2604    86818    courses course_id    DEFAULT     v   ALTER TABLE ONLY public.courses ALTER COLUMN course_id SET DEFAULT nextval('public.courses_course_id_seq'::regclass);
 @   ALTER TABLE public.courses ALTER COLUMN course_id DROP DEFAULT;
       public          postgres    false    215    214    215            u           2604    86830    students student_id    DEFAULT     z   ALTER TABLE ONLY public.students ALTER COLUMN student_id SET DEFAULT nextval('public.students_student_id_seq'::regclass);
 B   ALTER TABLE public.students ALTER COLUMN student_id DROP DEFAULT;
       public          postgres    false    217    216    217            
          0    86815    courses 
   TABLE DATA           9   COPY public.courses (course_id, course_name) FROM stdin;
    public          postgres    false    215   �(                 0    86827    students 
   TABLE DATA           G   COPY public.students (student_id, student_name, course_id) FROM stdin;
    public          postgres    false    217   )                  0    0    courses_course_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.courses_course_id_seq', 3, true);
          public          postgres    false    214                       0    0    students_student_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.students_student_id_seq', 5, true);
          public          postgres    false    216            w           2606    86820    courses courses_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_pkey PRIMARY KEY (course_id);
 >   ALTER TABLE ONLY public.courses DROP CONSTRAINT courses_pkey;
       public            postgres    false    215            y           2606    86832    students students_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_pkey PRIMARY KEY (student_id);
 @   ALTER TABLE ONLY public.students DROP CONSTRAINT students_pkey;
       public            postgres    false    217            z           2606    86838     students students_course_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_course_id_fkey FOREIGN KEY (course_id) REFERENCES public.courses(course_id) ON DELETE CASCADE;
 J   ALTER TABLE ONLY public.students DROP CONSTRAINT students_course_id_fkey;
       public          postgres    false    215    217    3191            
   /   x�3�t��-(-I-RN�L�KN�2F9�d&'�d��q��qqq }N?         1   x�3��H��M,R�,.JL��4�2�tMI�JMQHL.�IJ
��qqq ��     