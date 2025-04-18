import sys
import os
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from app import app  


def test_index():
    tester = app.test_client()  
    response = tester.get('/')  

    assert b"Levchenko Alexey Viktorovich" in response.data  
    assert b"Group: DOS24-onl" in response.data  
    assert b"Topic: webserver" in response.data  
    assert b"IP Address:" in response.data  


def test_images_exist():
    tester = app.test_client()
    response = tester.get('/')

    assert b"<img src=\"" in response.data 


def test_page_title():
    tester = app.test_client()
    response = tester.get('/')

    assert b"<title>Information</title>" in response.data  


test_index()
test_images_exist()
test_page_title()
