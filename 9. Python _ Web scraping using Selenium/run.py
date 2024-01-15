from booking.booking import Booking

try:
    with Booking() as bot:
        bot.land_first_page()
        print ('Exiting...')
        bot.change_currency(currency='USD')
        bot.select_place_to_go('New York')
        bot.select_dates(check_in_date='2022-08-16'
                        , check_out_date='2022-08-19')
        bot.select_adults(count=10)
        bot.click_search()
        bot.apply_filtrations()

except Exception as e:
    if 'in PATH' in str(e):
        print("There is a problem running this program from the command line interface")
    else:
        raise # this would raise the original exception

# the print message should ask the users to input the following into the command line:  
# set PATH=%PATH%;C:\SeleniumDrivers\
# after that we can run python run.py


#when the code get out of the indentation created by the with statement it will execute
#the function writtin in the __exit__ method of the class

#we create quit() in the __exit__method and call the with syntax here to ensure the browser is closed after the code is finished
#if this is not done the system could be overloaded with too many windows when we run many different tests

#this is called context manager concept in Python
#apart from the __ext__ method, the __enter__ method of a class will be executed once
# a paramaeter is entered into the arguments of the class

# IMPLEMENTATION FROM THE COMMAND LINE
# the OS.environ can not be exected directly from the command line
# as a result, we should create a try except block and get the user to input in the location of the chrome webdriver in the command line

