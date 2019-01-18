""" This script is the solution of Exercise Sheet No.3 - Task 3 """
__author__ = "0016285: Kaddour Alnaasan"
__email__ = "qaduralnaasan@gmail.com"


# Aufgabe 3 
"""
string = "" 
for x in range(1,10):
    print("x is ", x)
    string += " " + str(x)
    print("Now, x is ",x)
print("for: All previous numbers: ", string)
"""
""" Nehmen Sie nun folgende Veraenderungen vor:
Ersetzen Sie die for-Schleife durch eine while-Schleife.
Verwenden Sie zur Steuerung einen Zaehler. Beachten Sie
hierbei die vorhin in range() angegebenen Grenzen.
Kommentieren Sie ihre Aenderungen im Code gemaess PEP 8 unter
https://www.python.org/dev/peps/pep-0008/comments."""


string = ""
# Start-Number of Range
x = 1
# replaces the For loop with While loop
while x != 10:
    print("x is ", x)
    string += " " + str(x)
    print("Now, x is ", x)
    # add 1 to x 
    x += 1
print("All previous numbers: ", string)