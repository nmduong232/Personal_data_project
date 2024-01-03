#make sure to give enough time before you run the bot again or else the website will block your IP addresses

from calendar import c
from re import search
from selenium import webdriver
import booking.constant as const
import os
from selenium.webdriver.common.by import By
from booking.booking_filtration import BookingFiltration

class Booking(webdriver.Chrome):
    def __init__(self, driver_path=r";C:\SeleniumDrivers", teardown = False): # really watch out for syntax such as plural in the naming since this can create mismatch and hence errors
        self.driver_path = driver_path
        os.environ['PATH'] += self.driver_path
# Windows Path variable is a single string of semi-colon separated paths to various executables, which should look something like: "Path1;Path2;...;PathN".
# A good practice is to add a semi-colon after any new path you add to Path.
        super(Booking, self).__init__() # the super method is used here to instantiate the inherited class of webdriver.chrome, the syntax is as above
        self.implicitly_wait(15)
        self.maximize_window()
        
    def __exit__(self, exc_type, exc_val, exc_tb):
        if self.teardown:
            self.quit()

    def land_first_page(self):
        self.get(const.BASE_URL)

    def change_currency(self, currency=None):
        currency_element = self.find_element(By.CSS_SELECTOR, 
            'button[data-tooltip-text="Choose your currency"]') 
    #first is the type of the CSS selector and in the square bracket is
    #the expression to filter the HTML item
    #once an element is retrieved from the webpage we should assign it to a variable so that later we can perform various actions on it
    #examples of actions are .click(), .send_keys(), .clear()
    #remember that if we have the id attribute that would be the strongest type of element to select an html selector

        currency_element.click()
        selected_currency_element = self.find_element(By.CSS_SELECTOR, f'a[data-modal-header-async-url-param*="selected_currency={currency}"]')
        selected_currency_element.click()

    def select_place_to_go(self, place_to_go):
        search_field = self.find_element(By.ID, 'ss')
        search_field.clear()
    #should clear the field first before send_keys
        search_field.send_keys(place_to_go)
        first_result = self.find_element(By.CSS_SELECTOR, 
        'li[data-i="0"]')
        first_result.click()

    def select_dates(self, check_in_date, check_out_date):
        check_in_element = self.find_element(By.CSS_SELECTOR,
            f'td[data-date="{check_in_date}"]'
        )
        check_in_element.click()

        check_out_element = self.find_element(By.CSS_SELECTOR,
            f'td[data-date="{check_out_date}"]'
        )
        check_out_element.click()

    def select_adults(self, count=1):
        selection_element = self.find_element(By.ID, 'xp__guests__toggle')
        selection_element.click()
        
        while True:
            decrease_adults_element = self.find_element(By.CSS_SELECTOR,
                'button[aria-label="Decrease number of Adults"]'
            )
            decrease_adults_element.click()
            #If the value of adults reaches 1, then we should get out
            #of the while loop
            adults_value_element = self.find_element(By.ID, 'group_adults')
            adults_value = adults_value_element.get_attribute(
                'value'
            ) #this should give back the adult counts that are stored in the value attribute
            
            if int(adults_value) == 1:
                break
        
            increase_adults_element = self.find_element(By.CSS_SELECTOR,
                'button[aria-label="Increase number of Adults"]'
            )

            for _ in range(count - 1):
            # convention in python: if we do not use the variable in the for loop then we can use _ instead
                increase_adults_element.click()

    def click_search(self):
        search_button = self.find_element(By.CSS_SELECTOR, 'button[type="submit"]')
        search_button.click()

    def apply_filtrations(self):
        filtration = BookingFiltration(driver=self)
        # filtration is an instance of the BookingFiltration class.
        # so basically if any task is performed frequently, there should be a class designated for it
        filtration.apply_star_rating(3,4,5)



                
            







