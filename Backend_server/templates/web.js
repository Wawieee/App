// courses.js - JavaScript for Courses Page

// Fetch and display courses
function fetchCourses() {
    fetch('/courses')
        .then(response => response.json())
        .then(data => {
            const coursesList = document.getElementById('courses-list');
            coursesList.innerHTML = '';
            data.Message.forEach(course => {
                const courseElement = document.createElement('div');
                courseElement.textContent = `Course ID: ${course.course_id}, Course Name: ${course.course_name}`;
                coursesList.appendChild(courseElement);
            });
        })
        .catch(error => console.error('Error fetching courses:', error));
}

// Add event listener for add course form submission
document.getElementById('add-course-form').addEventListener('submit', function(event) {
    event.preventDefault();
    const courseName = document.getElementById('course-name').value;
    if (courseName.trim() !== '') {
        addCourse(courseName);
    } else {
        alert('Please enter a course name.');
    }
});

// Function to add a course
function addCourse(courseName) {
    fetch('/addcourse', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({ course_name: courseName })
    })
    .then(response => response.json())
    .then(data => {
        alert(data.message);
        fetchCourses(); // Refresh course list after adding
    })
    .catch(error => console.error('Error adding course:', error));
}

// courses.js - JavaScript for Courses Page (Continued)

// Function to delete a course
function deleteCourse(courseId) {
    fetch(`/deletecourse/${courseId}`, {
        method: 'DELETE',
        headers: {
            'Content-Type': 'application/json'
        }
    })
    .then(response => response.json())
    .then(data => {
        alert(data.message);
        fetchCourses(); // Refresh course list after deletion
    })
    .catch(error => console.error('Error deleting course:', error));
}

// Function to populate course details for update
function populateCourseDetails(courseId) {
    // Fetch course details by ID
    fetch(`/getcourse/${courseId}`)
    .then(response => response.json())
    .then(data => {
        const course = data.message;
        // Populate form fields with course details
        document.getElementById('course-id').value = course.course_id;
        document.getElementById('course-name-update').value = course.course_name;
    })
    .catch(error => console.error('Error fetching course details:', error));
}

// Add event listener for delete course buttons
document.getElementById('courses-list').addEventListener('click', function(event) {
    if (event.target.classList.contains('delete-btn')) {
        const courseId = event.target.dataset.courseId;
        if (confirm('Are you sure you want to delete this course?')) {
            deleteCourse(courseId);
        }
    }
});

// Add event listener for update course form submission
document.getElementById('update-course-form').addEventListener('submit', function(event) {
    event.preventDefault();
    const courseId = document.getElementById('course-id').value;
    const courseName = document.getElementById('course-name-update').value;
    updateCourse(courseId, courseName);
});

// Function to update a course
function updateCourse(courseId, courseName) {
    fetch(`/updatecourse/${courseId}`, {
        method: 'PUT',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({ course_name: courseName })
    })
    .then(response => response.json())
    .then(data => {
        alert(data.message);
        fetchCourses(); // Refresh course list after update
    })
    .catch(error => console.error('Error updating course:', error));
}

// Initial fetch of courses when the page loads
fetchCourses();
