__author__ = "0016285: Kaddour Alnaasan"


#Aufgabe 1.3

date_of_birth_str = input("The Date of Birth:")
date_of_birth_int = int(date_of_birth_str)

current_year = 2018
age = (current_year - date_of_birth_int) + 1

print("Your Age is:",age)

# Test:
#   The Date of Birth:1993
#   Your Age is: 26