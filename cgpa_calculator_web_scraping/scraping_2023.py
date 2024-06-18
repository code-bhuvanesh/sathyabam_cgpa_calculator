import json
import os
import re
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By
from time import sleep
import requests

# driver = None #webdriver.Chrome()
driver = webdriver.Chrome()

all_curiculams_website = "https://sist.sathyabama.ac.in/syllabus2023/syllabus.php"




def download_pdf(url):
     # Ensure the folder exists
    folder = "syllabus_pdf"
    if not os.path.exists(folder):
        os.makedirs(folder)
    filename = os.path.basename(url)
    file_path = os.path.join(folder, filename)
    if(os.path.exists(file_path)):
        return
    print(url)
    response = requests.get(url)
    with open(file_path, 'wb') as file:
        file.write(response.content)
    print(f"{filename} has been downloaded.")

coursePdfLink = []
def get_for_curiculam(curiculam_link):
    sleep(0.2)
    driver.get(curiculam_link)
    list_of_coruses = driver.find_element(by=By.XPATH, value="/html/body/div/div[3]/div[1]/div/div/ul").find_elements(by=By.TAG_NAME, value="li")
    del list_of_coruses[0:2]
    for course in list_of_coruses:
        sleep(0.2)
        course.click()
        print(course.get_attribute("id"))
        syllabus_btn = driver.find_element(by=By.XPATH, value="/html/body/div/div[3]/div[2]/div[1]/div/ul/li[3]/a/strong/font/button")
        syllabus_btn.click()
        sleep(0.2)
        pdfFrame = driver.find_element(by=By.CSS_SELECTOR, value="iframe")
        coursePdfLink.append("https://sist.sathyabama.ac.in/syllabus2023/"+pdfFrame.get_attribute("src"))
        # print(pdfFrame.get_attribute("src"))
        download_pdf(pdfFrame.get_attribute("src"))
        sleep(0.2)
        try:
            elective_course_btn = driver.find_element(by=By.XPATH, value="/html/body/div/div[3]/div[2]/div[1]/div/ul/li[4]/a/strong/font/button")
            elective_course_btn.click()
            sleep(0.2)
            pdfFrame = driver.find_element(by=By.CSS_SELECTOR, value="iframe")
            coursePdfLink.append("https://sist.sathyabama.ac.in/syllabus2023/"+pdfFrame.get_attribute("src"))
            # print(pdfFrame.get_attribute("src"))
            download_pdf(pdfFrame.get_attribute("src"))
        except:
            print("no elective")

if __name__ == "__main__":
    global cource_codes
    cource_codes = {}
    circulums = []
    driver.get(all_curiculams_website)
    linkHolder = driver.find_element(by=By.CSS_SELECTOR, value="ul")
    print(len(linkHolder.find_elements(by=By.TAG_NAME, value="a")))
    for i in linkHolder.find_elements(by=By.TAG_NAME, value="a"):
        circulums.append(i.get_attribute("href"))
    print(circulums)
    for c in circulums:
        get_for_curiculam(c)
        # break
    print(len(coursePdfLink))