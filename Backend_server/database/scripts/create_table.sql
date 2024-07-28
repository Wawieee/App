-- Create Colleges Table
CREATE TABLE colleges (
    college_id SERIAL PRIMARY KEY,
    college_name VARCHAR(100) NOT NULL,
    location VARCHAR(100) NOT NULL
);

-- Create Courses Table
CREATE TABLE courses (
    course_id SERIAL PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    college_id INT REFERENCES colleges(college_id) ON DELETE CASCADE
);

-- Create Students Table
CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    college_id INT REFERENCES colleges(college_id) ON DELETE CASCADE,
    course_id INT REFERENCES courses(course_id) ON DELETE CASCADE
);
