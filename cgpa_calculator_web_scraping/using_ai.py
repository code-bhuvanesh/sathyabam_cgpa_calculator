import google.generativeai as genai
import PyPDF2
import os


apikey = "AIzaSyBifDzCemiGShP875dmX2m2xrulCtguKj0"
genai.configure(api_key=apikey)
model = genai.GenerativeModel(model_name="gemini-1.5-flash")
print("model loaded")

def getSubjectFromPDf():
    folder = "syllabus_pdf"
    filesList = os.listdir(folder)
    count = 0

    for filename in filesList:
        count+=1
        file_path = os.path.join(folder, filename)
        text = ""
        try:
            with open(file_path, 'rb') as pdf_file:
                pdf_reader = PyPDF2.PdfReader(pdf_file)
                for page in pdf_reader.pages:
                    text += page.extract_text()
            expected_subjects_count = text.lower().count("total")
            print("file extracted")
            response = model.generate_content([text,f'''from the pdf content get all the proper subject code ("subject code allways starts with a leter")  with subject name max marks , credit for the subject and also whether it is practical or not practical is mentioned as p as true or false and expected number of subjects is {expected_subjects_count} in the pdf as csv and return total number of subjects'''])
            # print(response.text)
            with open("out.csv", "a") as file:
                file.write("\n"+response.text)
        except:
            print(f"{filename} cannot read this pdf")
        print(f"{count}/{len(filesList)} completed")

def convertTOCsv():
    text = ""
    with open("out.csv", "r") as file:
        text = file.read()
    
    response = model.generate_content([text,f'return all csv data as single csv data from the given content buy having only one column name row'])
    print(response.text)
    with open("subs.csv", 'w') as file:
        file.write(response.text)

# getSubjectFromPDf()
convertTOCsv()