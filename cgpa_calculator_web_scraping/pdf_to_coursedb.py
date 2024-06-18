import os
import re
import tabula
import pandas
import pickle5 as pickle
def extract_tables_from_pdf(file_path):
    # Extract tables from the PDF file
    tables = tabula.read_pdf(file_path, pages='all', multiple_tables=True)
    return tables

# URL of the PDF and filename
url = 'https://example.com/sample.pdf'
# file_path = 'syllabus_pdf/beaero-r2023book.pdf'

def remove_bracket_content(string):
    # Use regular expression to remove content inside brackets
    pattern = r'\([^)]*\)'  # Matches anything between '(' and ')'
    result = re.sub(pattern, '', string)
    pattern = r'\[[^\]]*\]'  # Matches anything between '[]' and ']'
    result = re.sub(pattern, '', result)
    return result.replace('\r', '').replace('\n', '')

def check_strings_in_list(string, string_list, extraWord = ""):
    string_list.append(extraWord)
    for item in string_list:
        if item not in string:
            return False
    return True

def remove_nan_rows(tables):
    # Remove rows where all values are NaN
    cleaned_tables = []
    for table in tables:
        df_cleaned:pandas.DataFrame = table
        df_cleaned = df_cleaned.dropna(how='all')
        if(all(table.columns.str.startswith('Unnamed'))):
            header = df_cleaned.iloc[0]
            df_cleaned = df_cleaned[1:]
            df_cleaned.columns = header
            # print(df_cleaned)
        if(len(df_cleaned) == 1):
            cols = []
            for c in df_cleaned.columns:
                x = ' '.join(c.strip().split()) if isinstance(c, str) else c
                x = "Credits" if(isinstance(x, str) and  (x == "redits" or x.lower() == "credit" or x.lower() == "c" )) else x
                cols.append(x)
            df_cleaned.columns = cols
            df_cleaned = df_cleaned.loc[:, ~df_cleaned.columns.isna()]
            cleaned_tables.append(df_cleaned)
    return cleaned_tables

def findCredits(table: pandas.DataFrame):
    courseCode = table.columns[0]
    courseName = remove_bracket_content(table.columns[1])
    ci = table.columns.get_loc("Credits")
    credits = int(table.iloc[0].iloc[ci-2])
    tmi = table.columns.get_loc("Total Marks")
    totalMarks = int(table.iloc[0].iloc[tmi-2])
    pi = table.columns.get_loc("P")
    isPractical = False if int(table.iloc[0].iloc[pi-2]) == 0 else True
    return courseCode, courseName, credits, totalMarks, isPractical

folder = "syllabus_pdf"
allsubs = []
allTables = []
for file_name in os.listdir(folder):
    # Extract tables from the PDF
    try:
        file_path = os.path.join(folder, file_name)
        tables = extract_tables_from_pdf(file_path)
        tables = remove_nan_rows(tables)
        print("reading ", file_name)
        for i, table in enumerate(tables):
            s = list(findCredits(table))
            allTables.append(table)
            allsubs.append(s)
            print(table)
            print(s)
    except:
        print(f"cannot read {file_name}")
print("\n\n")

print(allsubs)

print("total no. of subs : ", len(allsubs))
with open("all_tables.pkl", 'wb') as file:
    pickle.dump(allTables, file)
with open("all_subs.pkl", 'wb') as file:
    pickle.dump(allsubs, file)