from flask import Flask, jsonify, request, render_template
from flask_cors import CORS
import sys
import psycopg2
#from psycopg2 import sql

db_connection = psycopg2.connect(
        dbname='SSIS',
        user='postgres',
        password='nawawi',
        host='localhost',
    )

app = Flask(__name__)
CORS(app)

def spcall(qry, param, commit=False):
    try:
        cursor = db_connection.cursor()
        cursor.callproc(qry, param)
        res = cursor.fetchall()
        if commit:
            db_connection.commit()
        return res
    except:
        res = [("Error: " + str(sys.exc_info()[0]) +
                " " + str(sys.exc_info()[1]),)]
    return res

@app.route('/courses', methods=['GET'])
def get_courses():
    try:
        courses=spcall('get_courses', param=None)[0][0]
        return jsonify({"status": "ok",
                        'Message': courses})
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)})

@app.route('/addcourse', methods=['POST'])
def create_course():
    data = request.get_json()
    course_name = data.get('course_name')
    try:
        if course_name:
            with db_connection.cursor() as cursor:
                # Execute the INSERT statement
                cursor.execute("INSERT INTO courses (course_name) VALUES (%s) RETURNING course_id;", (course_name,))
                # Fetch the generated course_id
                course_id = cursor.fetchone()[0]
                # Commit the transaction
                db_connection.commit()
                
                return jsonify({"status": "ok", "course_id": course_id, 'message': 'Course created successfully'})
        else:
            return jsonify({"status": "error", "message": "Course name not provided"})
    except Exception as e:
        # Rollback transaction in case of error
        db_connection.rollback()
        return jsonify({"status": "error", "message": str(e)})

    
# Get a specific course by ID
@app.route('/getcourse/<int:courseId>', methods=['GET'])
def get_course(courseId):
    try:
        res = spcall('get_course_by_id', (courseId, ), commit=False)[0][0]
        return jsonify({"status": "ok",
                            'message': res})
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)})

# Update a course by ID
@app.route('/updatecourse/<int:course_id>', methods=['PUT'])
def update_course(course_id):
    try:
        data = request.get_json()
        course = data.get('course_name')

        if course:
            res = spcall('update_course_by_id', (course_id, course), commit=True)
            return jsonify({"status": "ok", 'message': 'course updated successfully'})

    except Exception as e:
        return jsonify({"status": "error", "message": str(e)})

# Delete a course by ID
@app.route('/deletecourse/<int:course_id>', methods=['DELETE'])
def delete_course(course_id):
    try:
        res = spcall('delete_course_by_id', (course_id, ), commit=True)
        return jsonify({"status": "ok",
                        'message': 'course deleted successfully'})
    except:
        return {"status":"error", "message":str(sys.exc_info()[0]) +
                " " + str(sys.exc_info()[1])}


#STUDENTS API

@app.route('/students', methods=['GET'])
def get_students():
    try:
        students =spcall('get_students', param=None)[0][0]
        return jsonify({"status": "ok",
                        'Message': students})
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)})

from flask import jsonify, request

@app.route('/student', methods=['POST'])
def create_student():
    data = request.get_json()
    student = data.get('student')
    course_id = data.get('course_id')
    try:
        if student:
            # Assuming spcall returns True on success
            if spcall('insert_student', (student, course_id), commit=True):
                return jsonify({"status": "ok", "message": "Student created successfully"}), 200
            else:
                return jsonify({"status": "error", "message": "Failed to create student"}), 500
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500

    return jsonify({"status": "error", "message": "Invalid request"}), 400

# Get a specific student by ID
@app.route('/student/<int:student_id>', methods=['GET'])
def get_student(student_id):
    try:
        res = spcall('get_student_by_id', (student_id, ), commit=False)[0][0]
        return jsonify({"status": "ok",
                            'message': res})
                            
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)})

# Update a student by ID
@app.route('/updatestudent/<int:student_id>', methods=['PUT'])
def update_student(student_id):
    try:
        data = request.get_json()
        student = data.get('student')
        course_id = data.get('course_id')

        if student:
            res = spcall('update_student_by_id', (student_id, student, course_id), commit=True)
            return jsonify({"status": "ok", 'message': 'student updated successfully'})

    except Exception as e:
        return jsonify({"status": "error", "message": str(e)})

# Delete a student by ID
@app.route('/student/<int:student_id>', methods=['DELETE'])
def delete_student(student_id):
    try:
        res = spcall('delete_student_by_id', (student_id, ), commit=True)
        return jsonify({"status": "ok",
                        'message': 'student deleted successfully'})
    except:
        return {"status":"error", "message":str(sys.exc_info()[0]) +
                " " + str(sys.exc_info()[1])}
    
@app.route('/', methods = ['GET', 'POST'])
def home():
    return render_template("web-interface.html")

if __name__ == '__main__':
    app.run(debug=True)
