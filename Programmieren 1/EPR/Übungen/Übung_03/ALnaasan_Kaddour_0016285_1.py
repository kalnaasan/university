""" This script is the solution of Exercise Sheet No.3 - Task 1 """
__author__ = "0016285: Kaddour Alnaasan"
__email__ = "qaduralnaasan@gmail.com"


# Aufgabe 1
""" Schreiben Sie ein Programm, welches eine natuerliche Zahl n und
die Auswahl der Schleifenart in der Konsole entgegennimmt.
In Abhaengigkeit von der Auswahl der Schleifenart berechnen sie den
Durchschnitt der Zahlen von 1 bis n und geben Sie das Ergebnis in
der Konsole aus. Setzen Sie die Berechnung in einer For- und in einer
While-Schleife um."""


def loops():
    def whileloop(num):
        """ calculate the average of 1 to a number, using While-loop """
        num_new = 0
        counter = num
        while counter != 0:
            num_new = num_new + counter
            counter = counter - 1
        average = num_new / num
        print("Der Durchschnitt der Zahlen:", str(average))

    def forloop(num):
        """ calculate the average of 1 to a number, using For-loop """
        num_new = 0
        for counter in range(1, num + 1):
            num_new = num_new + counter
        average = num_new / num
        print("Der Durchschnitt der Zahlen:", str(average))
    
    # Read the Kind of Loop
    loop_kind = input("Gaben Sie den Schleifenart (while/for):")

    if loop_kind == "while":
        # Read a Number
        number = int(input("Gaben Sie eine Zahl: "))
        whileloop(number)
    elif loop_kind == "for":
        # Read a Number
        number = int(input("Gaben Sie eine Zahl: "))
        forloop(number)
    else:
        loops()


loops()