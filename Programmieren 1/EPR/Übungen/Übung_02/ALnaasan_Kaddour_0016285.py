__author__ = "0016285: Kaddour Alnaasan"

# Aufgabe 1
# a)
scretNumber = 2
a = input("Geben Sie eine Zahl ein: ")
if (a == scretNumber):
    print("Herzlichen Glückwunsch, Sie haben die Zahl erraten")
else:
    print("Schade, Das war nicht die gesuchte Zahl.")  

# b)
scretNumber = 55
def printStr(str_word):
    print("Schade, Das war nicht die gesuchte Zahl.")           
    print("Deine Zahl ist ", str_word)

def readNumber():
    zahl_str = input("Geben Sie eine Zahl zwischen 1 und 100: ")
    zahl_int = int(zahl_str)
    if (zahl_int > scretNumber):
        printStr("großer")
        readNumber()
    elif zahl_int < scretNumber:
        printStr("kleiner")
        readNumber()
    elif zahl_int == scretNumber:
        print("Herzlichen Glückwunsch, Sie haben die Zahl erraten")

readNumber()


    