# This file will include a class with instance methods.
# That will be responsible to interact with our website
# After we have some results, to apply filtrations.

# To make the element in the function eligible to show the method applicable,
# we must first declare the variable types in the function call first.


from typing import List
from selenium.webdriver.remote.webdriver import WebDriver
from selenium.webdriver.common.by import By

class BookingFiltration:
    def __init__(self, driver:WebDriver, my_list: List):
        self.driver = driver
    # always start with the above init to ensure the driver method is activated when using the function 

    def apply_star_rating(self, *star_values):
        star_filtration_box = self.driver.find_element(By.ID, 'filter_class')
        star_child_elements = star_filtration_box.find_elements(By.CSS_SELECTOR, '*')
        print(len(star_child_elements))
        # we can access the list of child elements using this way

        for star_value in star_values:
            for star_element in star_child_elements:
                if str(star_element.get_attribute('innerHTML')).strip() == f'{star_value} stars':
                    star_element.click() # use .strip() to remove any blank spaces


