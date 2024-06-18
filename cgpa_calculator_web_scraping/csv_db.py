import sqlite3
import pandas as pd

# subjects = pd.read_csv("subs.csv",encoding="ISO-8859-1")
# print(subjects)
# print(len(subjects))

def correctingCsvFile():
    def returnIndex(line:str):
        ilist = []
        for i, s in enumerate(line):
            if(s==","):
                ilist.append(i)
        return ilist[0]+1 , ilist[-3]

    text = ""
    with open("subs copy.csv", "r") as file:
        lines = file.readlines()
        text += lines[0]
        for line in lines[1:]:
            try:
                print(line)
                startIndex, endIndex = returnIndex(line)
                # print(line[startIndex : endIndex].replace(",", ""))
                print(line[:startIndex] + line[startIndex : endIndex].replace(",", "") + line[endIndex:])
                text += line[:startIndex] + line[startIndex : endIndex].replace(",", "") + line[endIndex:]
            except:
                pass

    with open("subs.csv", "w") as file:
        file.write(text)

def csv_db():
    def createSubjectsdb(cursor, subdata:pd.DataFrame):
        subdatalen = len(subdata)
        subid = 99011021
        # Insert data into the table
        for i,k in subdata.iterrows():
            try:

                subid += 1
                # print(k["subcode"])
                # print(k["coursetitle"])
                # print(type(int(k["credit"])))
                # print(type(k["practical"]))

                subcode = k["subcode"]
                subName = k["coursetitle"]
                subcredit = int(k["credit"])
                subMaxMarks = int(k["max_marks"])
                courseType = "THEORY"
                if(k["practical"].lower() == "true"):
                    courseType = "PRACTICAL"

                #insert into subjects
                cursor.execute(f'''
                    INSERT INTO subjects (subcode, id, semester, coursetype, coursetitle, credit, maxmark)
                    VALUES (?, ?, ?, ?, ?, ?, ?)
                    ''', (subcode,subid ,1, courseType,subName,subcredit,subMaxMarks))
                # break
            except:
                print("failed")
            print(f"{i}/{subdatalen} completed")
   
    database_path = 'courses.sqlite'
    connection = sqlite3.connect(database_path)
    cursor = connection.cursor()
    subdata = pd.read_csv("subs.csv")
    createSubjectsdb(cursor, subdata.drop_duplicates())

    connection.commit()
    connection.close()
    # print(f"Data successfully converted to SQLite database at: {database_path}")

if __name__ == "__main__":
    csv_db()

#old 5206