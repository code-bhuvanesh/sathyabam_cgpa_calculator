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
            maxmark INTEGER
        )
    ''')


def createSubjectsdb(cursor, subdata):

    # Insert data into the table
    for k in subdata:
        data = subdata[k]
        data["subcode"] = k

        #insert into subjects
        cursor.execute(f'''
        INSERT INTO subjects (subcode, id, semester, coursetype, coursetitle, credit, maxmark)
        VALUES (?, ?, ?, ?, ?, ?, ?)
    ''', (data["subcode"], data["id"], data["semester"], data["coursetype"],data["coursetitle"],data["credit"],int(data["cae"]) + int(data["ese"])))

   
if __name__ == "__main__":
    database_path = 'courses.sqlite'
    connection = sqlite3.connect(database_path)
    cursor = connection.cursor()

    create_tables(cursor)
    subfile = open("subs.json", "r")
    subdata = json.load(subfile)
    createSubjectsdb(cursor, subdata)

    connection.commit()
    connection.close()


    print(f"Data successfully converted to SQLite database at: {database_path}")
