import json
import os
from time import sleep

import requests
from selenium import webdriver
from selenium.common.exceptions import (NoSuchElementException,
                                        WebDriverException)
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.ui import WebDriverWait

url = 'https://www.google.com/search?q={0}&source=lnms&tbm=isch'

for finger_type in ('fingers', 'clubbed+fingers+medical',):
    driver = webdriver.Chrome()
    driver.get(url.format(finger_type))
    driver.implicitly_wait(1)
    for i in range(10):
        driver.execute_script(
            "window.scrollTo(0, document.body.scrollHeight);")
        sleep(.25)
    driver.find_element_by_id('smb').click()
    driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
    urls = list()
    image_class = 'rg_ic'
    lowres_images = driver.find_elements_by_class_name(image_class)
    print('found {0} images...'.format(len(lowres_images)))
    for lowres_image in lowres_images:
        try:
            lowres_image.click()
            sleep(.5)
            hires_image = driver.find_element_by_xpath(
                '//img[@class="irc_mi" and contains(@src, "jpg")]')
            url = hires_image.get_attribute('src')
            if url not in urls:
                urls.append(url)
        except (NoSuchElementException, WebDriverException):
            continue
        webdriver.ActionChains(driver).send_keys(Keys.ESCAPE).perform()
    driver.close()

    for i, url in enumerate(urls):
        r = requests.get(url, stream=True)
        if r.status_code == 200:
            with open('data/train/fingers/{0}_{1}.jpg'.format(
                    finger_type.replace('+', '_'), i), 'wb') as f:
                for chunk in r:
                    f.write(chunk)
