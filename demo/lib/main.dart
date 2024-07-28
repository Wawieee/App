import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Simple Student Information System'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Welcome to the SSIS",
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
                const SizedBox(height: 30),
                Builder(builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => CoursesPage()),
                      );
                    },
                    child: const Text('Courses'),
                  );
                }),
                const SizedBox(height: 20),
                Builder(builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => StudentsPage()),
                      );
                    },
                    child: const Text('Students'),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class CoursesPage extends StatefulWidget {
  const CoursesPage({Key? key}) : super(key: key);

  @override
  _CoursesPageState createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  final String apiUrl = 'http://localhost:5000'; // Change to your API URL
  dynamic courseDetails;
  bool isLoading = false;

  TextEditingController courseNameController = TextEditingController();
  TextEditingController courseIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCourseDetails();
  }

  Future<void> fetchCourseDetails() async {
    setState(() {
      isLoading = true;
    });
    try {
      final Uri url = Uri.parse('$apiUrl/courses');

      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final dynamic body = json.decode(response.body);
        if (body is Map<String, dynamic>) {
          final List<dynamic> courses = body['Message'] ?? [];
          final formattedCourses = courses.map((course) =>
              "Course ID: ${course['course_id']} || Course Name: ${course['course_name']}")
              .join('\n');

          setState(() {
            courseDetails = formattedCourses;
            isLoading = false;
          });
        } else {
          throw Exception('Invalid response format or status is not "ok"');
        }
      } else {
        throw Exception('Failed to load details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching course details: $e');
    }
  }

  Future<void> searchCourse(int courseId) async {
    setState(() {
      isLoading = true;
    });
    try {
      final Uri url = Uri.parse('$apiUrl/getcourse/$courseId');

      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final dynamic body = json.decode(response.body);
        if (body is Map<String, dynamic>) {
          final dynamic message = body['message']; // Access 'message' instead of 'Message'
          if (message != null) { // Check if message is not null
            final formattedCourse =
              "Course ID: ${message['course_id']} || Course Name: ${message['course_name']}";
            setState(() {
              courseDetails = formattedCourse; // Set single course details
              isLoading = false;
            });
          } else {
            setState(() {
              courseDetails = null; // No course found
              isLoading = false;
            });
          }
        } else {
          throw Exception('Invalid response format or status is not "ok"');
        }
      } else {
        throw Exception('Failed to load details: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        courseDetails = null; // Reset courseDetails on error
        isLoading = false;
      });
      print('Error fetching course details: $e');
    }
  }

  Future<void> addCourse(String courseName) async {
    final Uri url = Uri.parse('$apiUrl/addcourse');
    final Map<String, dynamic> requestBody = {'course_name': courseName};

    final headers = {'Content-Type': 'application/json'};

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        print('Course added successfully');
        fetchCourseDetails(); // Refresh course list after adding
      } else {
        print('Failed to add course. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> deleteCourse(int courseId) async {
    final Uri url = Uri.parse('$apiUrl/deletecourse/$courseId');

    final headers = {'Content-Type': 'application/json'};

    try {
      final response = await http.delete(
        url,
        headers: headers,
      );

      if (response.statusCode == 200) {
        print('Course deleted successfully');
        fetchCourseDetails(); // Refresh course list after deletion
      } else {
        print('Failed to delete course. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> updateCourse(String courseName, int courseId) async {
    final Uri url = Uri.parse('$apiUrl/updatecourse/$courseId');
    final Map<String, dynamic> requestBody = {'course_name': courseName};

    final headers = {'Content-Type': 'application/json'};

    try {
      final response = await http.put(
        url,
        headers: headers,
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        print('Course updated successfully');
        fetchCourseDetails(); // Refresh course list after update
      } else {
        print('Failed to update course. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchCourse(int courseId) async {
    try {
      final Uri url = Uri.parse('$apiUrl/getcourse/$courseId');

      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );
      
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final dynamic body = json.decode(response.body);
        if (body != null && body is Map<String, dynamic>) {
          // Retrieve student name and course name
          final courseName = body['message']['course_name'];
          setState(() {
            courseNameController.text = courseName ?? ''; // Populate student name field
          });
        } else {
          setState(() {
            courseNameController.text = ''; // Clear student name field
          });
          // Handle the case where the student with the provided ID does not exist
          print('No course found for ID: $courseId');
        }     
      } else {
        throw Exception('Failed to load student details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching course details: $e');
    }
  }

  void clearCourseDetails() {
  setState(() {
    courseNameController.text = ''; // Clear course name field
  });
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Courses'),
      centerTitle: true,
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            'Manage Courses',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: courseIdController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Course ID',
              hintText: 'Enter Course ID',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.numbers),
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                fetchCourse(int.tryParse(value) ?? 0);
              } else {
                clearCourseDetails();
              }
            },
          ),
          const SizedBox(height: 10),
          TextField(
            controller: courseNameController,
            decoration: InputDecoration(
              labelText: 'Course Name',
              hintText: 'Enter Course Name',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.book),
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              ElevatedButton.icon(
                icon: Icon(Icons.add),
                label: const Text('Add'),
                onPressed: () => addCourse(courseNameController.text),
              ),
              ElevatedButton.icon(
                icon: Icon(Icons.delete),
                label: const Text('Delete'),
                onPressed: () => deleteCourse(int.tryParse(courseIdController.text) ?? 0),
              ),
              ElevatedButton.icon(
                icon: Icon(Icons.update),
                label: const Text('Update'),
                onPressed: () => updateCourse(courseNameController.text, int.tryParse(courseIdController.text) ?? 0),
              ),
              ElevatedButton.icon(
                icon: Icon(Icons.search),
                label: const Text('Search'),
                onPressed: () => searchCourse(int.tryParse(courseIdController.text) ?? 0),
              ),
              ElevatedButton.icon(
                icon: Icon(Icons.refresh),
                label: const Text('Refresh'),
                onPressed: fetchCourseDetails,
              ),
            ],
          ),
          const SizedBox(height: 20),
          isLoading
              ? const CircularProgressIndicator()
              : courseDetails != null
                  ? Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Courses:\n$courseDetails',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    )
                  : const Text('No courses available'),
        ],
      ),
    ),
  );
}
}

class StudentsPage extends StatefulWidget {
  const StudentsPage({Key? key}) : super(key: key);

  @override
  _StudentsPageState createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {
  final String apiUrl = 'http://localhost:5000'; // Change to your API URL
  dynamic studentDetails;
  bool isLoading = false;

  TextEditingController studentIdController = TextEditingController();
  TextEditingController studentNameController = TextEditingController();
  int? selectedCourseId; // Track the selected course ID

  List<dynamic> courses = []; // List to store the fetched courses

  @override
  void initState() {
    super.initState();
    fetchStudentDetails();
    fetchCourses(); // Fetch courses when the page initializes
  }

  Future<void> fetchCourses() async {
    try {
      final Uri url = Uri.parse('$apiUrl/courses');

      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final dynamic body = json.decode(response.body);
        if (body is Map<String, dynamic>) {
          setState(() {
            courses = body['Message'] ?? [];
          });
        } else {
          throw Exception('Invalid response format or status is not "ok"');
        }
      } else {
        throw Exception('Failed to load details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching courses: $e');
    }
  }

  Future<void> fetchStudentDetails() async {
    setState(() {
      isLoading = true;
    });
    try {
      final Uri url = Uri.parse('$apiUrl/students');

      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}'); // Add this line for debugging
      if (response.statusCode == 200) {
        final dynamic body = json.decode(response.body);
        if (body is Map<String, dynamic>) {
          final List<dynamic> students = body['Message'] ?? [];
          final formattedStudents = students.map((student) =>
              "Student ID: ${student['student_id']} || Student Name: ${student['student_name']} || Course: ${student['course_name']}")
              .join('\n');

          setState(() {
            studentDetails = formattedStudents;
            isLoading = false;
          });
        } else {
          throw Exception('Invalid response format or status is not "ok"');
        }
      } else {
        throw Exception('Failed to load details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching student details: $e');
    }
  }

  Future<void> searchStudent(int studentId) async {
    setState(() {
      isLoading = true;
    });

    try {
      final Uri url = Uri.parse('$apiUrl/student/$studentId');

      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final dynamic body = json.decode(response.body);
        if (body != null && body is Map<String, dynamic>) {
          final student = body['message'];
          final formattedStudent = "Student ID: ${student['student_id']} || Student Name: ${student['student_name']} || Course: ${student['course_name']}";
          
          setState(() {
            studentDetails = formattedStudent; // Update studentDetails with the search result
          });
        } else {
          setState(() {
            studentDetails = 'No student found for ID: $studentId'; // Update with appropriate message
          });
        }
      } else {
        throw Exception('Failed to load student details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error searching for student: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> addStudent(String studentName, int courseId) async {
    final Uri url = Uri.parse('$apiUrl/student');
    final Map<String, dynamic> requestBody = {
      'student': studentName,
      'course_id': courseId
    };

    final headers = {'Content-Type': 'application/json'};

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('Server Response: $responseData');
        print('Student added successfully');
        fetchStudentDetails();
      } else {
        print('Failed to add student. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> deleteStudent(int studentId) async {
    final Uri url = Uri.parse('$apiUrl/student/$studentId'); // Correct endpoint URL

    final headers = {'Content-Type': 'application/json'};

    try {
      final response = await http.delete(
        url,
        headers: headers,
      );

      if (response.statusCode == 200) {
        print('Student deleted successfully');
        fetchStudentDetails(); // Refresh student list after deletion
      } else {
        print('Failed to delete student. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> updateStudent(int studentId, String studentName, int courseId) async {
    final Uri url = Uri.parse('$apiUrl/updatestudent/$studentId');
    final Map<String, dynamic> requestBody = {
      'student': studentName,
      'course_id': courseId,
    };

    final headers = {'Content-Type': 'application/json'};

    try {
      final response = await http.put(
        url,
        headers: headers,
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        print('Student updated successfully');
        fetchStudentDetails(); // Refresh student list after update
      } else {
        print('Failed to update student. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchStudent(int studentId) async {
    try {
      final Uri url = Uri.parse('$apiUrl/student/$studentId');

      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final dynamic body = json.decode(response.body);
        if (body != null && body is Map<String, dynamic>) {
          // Retrieve student name and course name
          final studentName = body['message']['student_name'];
          final courseName = body['message']['course_name'];

          // Find the corresponding course ID based on the received course name
          final selectedCourse = courses.firstWhere(
            (course) => course['course_name'] == courseName,
            orElse: () => null,
          );

          if (selectedCourse != null) {
            final courseId = selectedCourse['course_id'];

            setState(() {
              studentNameController.text = studentName ?? ''; // Populate student name field
              selectedCourseId = courseId; // Set selected course
            });
          } else {
            setState(() {
              studentNameController.text = ''; // Clear student name field
              selectedCourseId = null; // Reset selected course
            });
            // Handle the case where the course name does not match any available course
            print('No course found with name: $courseName');
          }
        } else {
          setState(() {
            studentNameController.text = ''; // Clear student name field
            selectedCourseId = null; // Reset selected course
          });
          // Handle the case where the student with the provided ID does not exist
          print('No student found for ID: $studentId');
        }
      } else {
        throw Exception('Failed to load student details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching student details: $e');
    }
  }

  void clearStudentDetails() {
    setState(() {
      studentNameController.text = ''; // Clear student name field
      selectedCourseId = null; // Reset selected course
    });
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Students'),
      centerTitle: true,
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            'Manage Student',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: studentIdController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Student ID',
              hintText: 'Enter Student ID',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person_outline),
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                fetchStudent(int.tryParse(value) ?? 0);
              } else {
                clearStudentDetails();
              }
            },
          ),
          const SizedBox(height: 10),
          TextField(
            controller: studentNameController,
            decoration: InputDecoration(
              labelText: 'Student Name',
              hintText: 'Enter Student Name',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
            ),
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<int>(
            decoration: InputDecoration(
              labelText: 'Select Course',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.school),
            ),
            value: selectedCourseId,
            onChanged: (int? newValue) {
              setState(() {
                selectedCourseId = newValue;
              });
            },
            items: courses.map<DropdownMenuItem<int>>((dynamic course) {
              return DropdownMenuItem<int>(
                value: course['course_id'],
                child: Text(course['course_name']),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              ElevatedButton.icon(
                icon: Icon(Icons.add),
                label: const Text('Add'),
                onPressed: () => addStudent(studentNameController.text, selectedCourseId ?? 0),
              ),
              ElevatedButton.icon(
                icon: Icon(Icons.delete),
                label: const Text('Delete'),
                onPressed: () => deleteStudent(int.tryParse(studentIdController.text) ?? 0),
              ),
              ElevatedButton.icon(
                icon: Icon(Icons.update),
                label: const Text('Update'),
                onPressed: () {
                  updateStudent(
                    int.tryParse(studentIdController.text) ?? 0,
                    studentNameController.text,
                    selectedCourseId ?? 0,
                  );
                },
              ),
              ElevatedButton.icon(
                icon: Icon(Icons.search),
                label: const Text('Search'),
                onPressed: () => searchStudent(int.tryParse(studentIdController.text) ?? 0),
              ),
              ElevatedButton.icon(
                icon: Icon(Icons.refresh),
                label: const Text('Refresh'),
                onPressed: fetchStudentDetails,
              ),
            ],
          ),
          const SizedBox(height: 20),
          isLoading
              ? const CircularProgressIndicator()
              : studentDetails != null
                  ? Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Students:\n$studentDetails',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    )
                  : const Text('No students available'),
        ],
      ),
    ),
  );
}

}
