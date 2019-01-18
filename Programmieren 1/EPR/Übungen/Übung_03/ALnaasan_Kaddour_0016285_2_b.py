""" This script is the solution of Exercise Sheet No.3 - Task 2-b """
import random
__author__ = "0016285: Kaddour Alnaasan"
__email__ = "qaduralnaasan@gmail.com"


# Aufgabe 2
# B
""" Schreiben Sie eine zweite Variante mit einer Endlosschleife, welche
bei Erfolg mit einer break-Anweisung verlassen wird."""


number = random.randint(10,99)
counter = 0
while True:
    counter += 1
    if number == 18:
        break
    number = random.randint(10,99)

print("die Anzahl der Wuerfe ist: ", str(counter))