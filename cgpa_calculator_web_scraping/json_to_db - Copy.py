import json
import sqlite3

"""
"SHSA1101": {
    "id": 1192,
    "semester": 2,
    "coursetype": "THEORY",
    "coursetitle": "Technical English ",
    "lecture": 3,
    "tutorial": "0",
    "practical": 0,
    "credit": 3,
    "cae": 50,
    "ese": 50,
    "displaysyllabus": 1
},
"""
#subjects
def create_tables(cursor):
    # Create a table with two columns: key and value
    cursor.execute(f'''
        CREATE TABLE IF NOT EXISTS subjects (
            subcode TEXT PRIMARY KEY,
            id INTEGER,
            semester INTEGER,
            coursetype Text,
            coursetitle Text,
            credit INTEGER,
            cae INTEGER,
            ese INTEGER,
            displaysyllabus INTEGER
        )
    ''')

    cursor.execute(f'''
        CREATE TABLE IF NOT EXISTS courses (
            course TEXT PRIMARY KEY, 
            branch Text,
            maxsem INTEGER
        )
    ''')

    #many-to-many realationship table
    cursor.execute(f'''
        CREATE TABLE IF NOT EXISTS course_subjects (
            course TEXT, 
            subcode TEXT,
            FOREIGN KEY (subcode) REFERENCES subjects (subcode),
            FOREIGN KEY (course) REFERENCES courses (course),
            PRIMARY KEY (course, subcode)
        )
    ''')



def createSubjectsdb(cursor, subdata):

    # Insert data into the table
    for k in subdata:
        data = subdata[k]
        data["subcode"] = k

        #insert into subjects
        cursor.execute(f'''
        INSERT INTO subjects (subcode, id, semester, coursetype, coursetitle, credit, cae, ese, displaysyllabus)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
    ''', (data["subcode"], data["id"], data["semester"], data["coursetype"],data["coursetitle"],data["credit"],data["cae"],data["ese"],data["displaysyllabus"]))

def createCoursesdb(cursor, data):

    # Insert data into the table
    for branch in data:
        for course, subs in data[branch].items():
            maxsem = 0
            for i in subs:
                if subs[i]['semester'] > maxsem and subs[i]['semester'] <= 10:
                    maxsem = subs[i]['semester']
            # print(maxsem)
            try:
                # print(course)
                #insert into courses
                cursor.execute(f'''
                INSERT INTO courses (course, branch, maxsem)
                VALUES (?, ?, ?)
            ''', (course, branch, maxsem))
                for subcode in (data[branch][course].keys()):
                    # print(subcode)
                    cursor.execute(f'''
                    INSERT INTO course_subjects (course, subcode)
                    VALUES (?, ?)
                ''', (course, subcode))
            except:
                print(f"cannot add this course : {course}")

   
if __name__ == "__main__":
    database_path = 'courses.sqlite'
    connection = sqlite3.connect(database_path)
    cursor = connection.cursor()

    create_tables(cursor)

    subfile = open("subs.json", "r")
    subdata = json.load(subfile)

    createSubjectsdb(cursor, subdata)

    coursefile = open("courses.json", "r")
    coursedata = json.load(coursefile)
    createCoursesdb(cursor, coursedata)

    connection.commit()
    connection.close()


    print(f"Data successfully converted to SQLite database at: {database_path}")
