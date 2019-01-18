""" This script is the solution of Exercise Sheet No.3  - Task 2-a"""

import random
__author__ = "0016285: Kaddour Alnaasan"
__email__ = "qaduralnaasan@gmail.com"


# Aufgabe 2
# A
""" Lassen Sie in einer nicht endlosen while-Schleife ganzzahlige zweistel-
lige Zufallszahlen werfen, bis eine 18 geworfen wird. Geben Sie die Anzahl
der Wuerfe in der Konsole aus."""


number = random.randint(10,99)
counter = 0
while number != 18:
    counter += 1
    number = random.randint(10,99)

print("die Anzahl der Wuerfe ist: ", str(counter))