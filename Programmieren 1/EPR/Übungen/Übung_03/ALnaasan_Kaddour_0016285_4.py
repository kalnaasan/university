""" This script is the solution of Exercise No.3 - Task 4 """
__author__ = "0016285: Kaddour Alnaasan"
__email__ = "qaduralnaasan@gmail.com"

# Aufgabe 4
""" Mit Hilfe einer einfachen Iterationsvorschrift laesst sich feststellen,
ob eine Zahl froehlich ist:
Gegeben sei eine Zahl N in Dezimaldarstellung. Man quadriere nun 
jede Ziffer der Zahl. Dann addiere diese Quadrate.
Die daraus resultierende Zahl wird genauso behandelt. 
Ergibt sich daraus irgendwann das Ergebnis 1, dann ist diese Zahl froehlich.
Die einzige Alternative ist es, dass diese Folge in einen periodischen
Zyklus von der 4 aus uebergeht.
Schreiben Sie ein Programm, welches fuer eine vom Benutzer eingegebene
Zahl bestimmt und in der Konsole ausgibt, ob diese froehlich ist oder 
in den periodischen Zyklus uebergeht.
Integrieren Sie dabei dieMoeglichkeit, dass der Algorithmus nach 100 
Iterationen abbricht.
geben Sie als Kommentar am Ende Ihres Code (in der .py-Datei) mindestens
3 Testfaelle an und begruenden Sie ihre (sinnvolle) Auswahl."""

# def happynumberRekusiv(tiefe, number)
#     if number == 1:
#         print("The number is happy")
#     elif number == 4:
#         print("The number is looping")
#     elif tiefe > 1:
#         happynumberRekusiv(tiefe - 1, calcNewNumber(number))
#     else:
#         print("maxium recursion")

# def calcNewNumber(number)
#     if remainder > 0 then:
#         lastDigit = number % 10
#         remainder = number // 10
#         number + lastDigit ^ 2
#         calcNewNumber()
#     return 

def happynumber():
    start_number = int(input("Enter a number: "))
    worked_number = start_number
    mod = 1
    new_number = 0
    counter = 1
    while worked_number != 1:
        while worked_number != 0:
            mod = worked_number % 10
            worked_number = worked_number // 10
            new_number = new_number + (mod * mod)
        print("The neu Number is:", new_number)
        if new_number == 1:
            print("The Number (", start_number, ") is happy.")
        elif new_number == 4 or counter == 100:
            print("there is a loop!!!")
            break
        worked_number = new_number
        new_number = 0
        counter = counter + 1
    play_again = input("Do you wont to play again (yes / no):")
    if play_again != "no":
        happynumber()


happynumber()

""" Erster Testfll:
Enter a number: 7
The neu Number is: 49
The neu Number is: 97
The neu Number is: 130
The neu Number is: 10
The neu Number is: 1
The Number( 7 ) is happy.
Das Beispiel zeigt schon, dass Funktion funktioniert
"""

""" Zweiter Testfall:
Enter a number: 125
The neu Number is: 30
The neu Number is: 9
The neu Number is: 81
The neu Number is: 65
The neu Number is: 61
The neu Number is: 37
The neu Number is: 58
The neu Number is: 89
The neu Number is: 145
The neu Number is: 42
The neu Number is: 20
The neu Number is: 4
there is a loop!!!
Das Funktion zeigt eine Schleife 
"""

""" Driettr Testfall
Enter a number: 150
The neu Number is: 26
The neu Number is: 40
The neu Number is: 16
The neu Number is: 37
The neu Number is: 58
The neu Number is: 89
The neu Number is: 145
The neu Number is: 42
The neu Number is: 20
The neu Number is: 4
there is a loop!!!
Das Funktion zeigt eine Schleife 
"""
