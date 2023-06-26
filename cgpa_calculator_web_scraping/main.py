import json
import os
import re
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By
from time import sleep
import requests

driver = None #webdriver.Chrome()
#driver = webdriver.Chrome()

all_curiculams_website = "https://www.sathyabama.ac.in/academics/curriculum-syllabus"
course_codes = {}

def get_all_ciriculams():
    circulums = []
    driver.get(all_curiculams_website)
    linkHolder = driver.find_element(by=By.XPATH, value="/html/body/div[3]/div/section/div[2]/article/div/div/div/section[1]/div/div")
    print(len(linkHolder.find_elements(by=By.TAG_NAME, value="a")))
    for i in linkHolder.find_elements(by=By.TAG_NAME, value="a"):
        circulums.append(i.get_attribute("href"))
    for c in circulums:
        get_for_curiculam(c)


def get_for_curiculam(curiculam_link):
    sleep(0.2)
    driver.get(curiculam_link)
    list_of_coruses = driver.find_element(by=By.XPATH, value="/html/body/div/div[3]/div[1]/div/div/ul").find_elements(by=By.TAG_NAME, value="li")
    del list_of_coruses[0:2]
    for course in list_of_coruses:
        sleep(0.2)
        print(course.get_attribute("id"))
        c = course.get_attribute("id").split("_")
        if c[1] not in course_codes:
            course_codes[c[1]] = {}
        course_codes[c[1]][c[2]] = c[0]

    current_dir = os.getcwd()
    parent_dir = os.path.dirname(current_dir)
    
def get_credit_points(code):
    base_url = "https://sist.sathyabama.ac.in/syllabus2019/db/subjectListQuery.php?deptid="
    response = requests.post(base_url+code)
    if response.status_code == 200:
        credits = json.loads(response.content)
        # print(code)
        if credits == None:
            return None
        course_credits = {}
        for course in credits:
            courseCode = course.pop("coursecode")
            if courseCode == "":
                courseCode = course["coursetitle"]
            course_credits[courseCode] = course
    return course_credits

def get_all_credit_points():
    
    with open("cource_codes.json", "r") as inFile:
        # print(inFile)
        course_codes = json.loads(inFile.read())

    all_courses_credits_dict = {}

    timer = 0
    for key1, _ in course_codes.items():
        for key2, _ in course_codes[key1].items():
            timer -= 1
    returnedDict = {}
    courseToBeDeleted = []
    for key1, _ in course_codes.items():
        for key2, _ in course_codes[key1].items():
            print(timer)
            timer += 1
            course_credits = get_credit_points(course_codes[key1][key2])
            # course_credits = get_credit_points("11")
            if course_credits != None:
                if contains_batches(course_credits):
                    courseToBeDeleted.append(key2)
                for k, v in return_splited_batches(course_credits.copy(), key2).items():
                    if key1 not in all_courses_credits_dict:
                        all_courses_credits_dict[key1] = {} 
                    all_courses_credits_dict[key1][k] = v
    print(all_courses_credits_dict)
    
    with open("course_credits.json", "w") as outFile:
        json.dump(all_courses_credits_dict, outFile, indent=2)

def contains_batches(courses):
     for key, value in courses.items():
        if "(Only for 2019 and 2020 batches)" in value["coursetitle"] or "(from 2021 batch)" in value["coursetitle"]:
            return True
        else:
            return False

def return_splited_batches(courses, branch):
    out_dict = {
        branch+"-2019": courses.copy(),
        branch+"-2020": courses.copy(),
        branch+"-2021": courses.copy(),
    }
    isChanged = False
    for key, value in courses.items():
        if check_strings_in_list(value["coursetitle"].lower(), "only for 2019 and 2020".split()):
            out_dict[branch+"-2021"].pop(key)
            out_dict[branch+"-2019"][key]["coursetitle"] = remove_bracket_content(value["coursetitle"]).strip()
            out_dict[branch+"-2020"][key]["coursetitle"] = remove_bracket_content(value["coursetitle"]).strip()
            isChanged = True
        elif check_strings_in_list(value["coursetitle"].lower(), "only for 2019".split()):
            out_dict[branch+"-2021"].pop(key)
            out_dict[branch+"-2020"].pop(key)
            out_dict[branch+"-2019"][key]["coursetitle"] = remove_bracket_content(value["coursetitle"]).strip()
            isChanged = True 
        elif check_strings_in_list(value["coursetitle"].lower(), "from 2020".split()):
            out_dict[branch+"-2019"].pop(key)
            out_dict[branch+"-2020"][key]["coursetitle"] = remove_bracket_content(value["coursetitle"]).strip()
            out_dict[branch+"-2021"][key]["coursetitle"] = remove_bracket_content(value["coursetitle"]).strip()
            isChanged = True
        elif check_strings_in_list(value["coursetitle"].lower(), "from 2021".split()):
            out_dict[branch+"-2019"].pop(key)
            out_dict[branch+"-2020"].pop(key)
            out_dict[branch+"-2021"][key]["coursetitle"] = remove_bracket_content(value["coursetitle"]).strip()
            isChanged = True
    if isChanged:
        return out_dict   
    else:  
        return {branch :courses}

def separate_by_sem():
    global course_credits
    with open("course_credits.json", "r") as f:
        course_credits = json.loads(f.read())
    
    course_credits_copy = course_credits.copy()
    for k1, v1 in course_credits.items():
        for k2, v2 in course_credits[k1].items():
            courses = course_credits[k1][k2]
            sem_wise_arranged = {}
            for courseName, _ in courses.items():
                sem = courses[courseName].pop("semester")
                if sem == 21 or sem == 22:
                    continue
                # if str(sem) not in sem_wise_arranged:
                #     sem_wise_arranged[str(sem)] = {}
                
                sem_wise_arranged[str(sem)][courseName] = courses[courseName]
            course_credits_copy[k1][k2] = sem_wise_arranged

def delete_unwanted_sem():
    global course_credits
    with open("course_credits.json", "r") as f:
        course_credits = json.loads(f.read())
    course_credits_copy = course_credits.copy()
    for k1, v1 in course_credits.items():
        for k2, v2 in course_credits[k1].items():
            courses = course_credits[k1][k2]
            sem_wise_arranged = {}
            for courseName, _ in courses.items():
                sem = courses[courseName]["semester"]
                if sem == 21 or sem == 22:
                    continue
                # if str(sem) not in sem_wise_arranged:
                #     sem_wise_arranged[courseName] = {}
                
                sem_wise_arranged[courseName] = courses[courseName]
            course_credits_copy[k1][k2] = sem_wise_arranged
            


    
    with open("course_credits2.json", "w") as outFile:
        json.dump(course_credits, outFile, indent=2)


def remove_bracket_content(string):
    # Use regular expression to remove content inside brackets
    pattern = r'\([^)]*\)'  # Matches anything between '(' and ')'
    result = re.sub(pattern, '', string)
    pattern = r'\[[^\]]*\]'  # Matches anything between '[]' and ']'
    result = re.sub(pattern, '', result)
    return result

def check_strings_in_list(string, string_list, extraWord = ""):
    string_list.append(extraWord)
    for item in string_list:
        if item not in string:
            return False
    return True

if __name__ == "__main__":
    global cource_codes
    cource_codes = {}
    # get_for_curiculam("https://sist.sathyabama.ac.in/syllabus2019/schoolWiseSyllabus.php?id=2&school=ELECTRONICS&shortname=soe&regularpt=regular")
    
    # get_all_ciriculams()
    # with open("cource_codes.json", "w") as outFile:
    #     json.dump(course_codes, outFile, indent=2)

    # print(get_credit_points("1101"))
    # get_all_credit_points()

    # separate_by_sem()
    get_all_credit_points()
    delete_unwanted_sem()