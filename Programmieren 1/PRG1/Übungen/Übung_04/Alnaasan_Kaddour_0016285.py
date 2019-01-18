""" This script is the solution of Exercise Sheet No.4 - Task 3 and 4 """
__author__ = "0016285: Kaddour Alnaasan"
__email__ = "qaduralnaasan@gmail.com"

# Aufabe 3


def average():
    """ collect the average and point to the console """
    print("Please enter two integers.")
    first_number = int(input("The first number: "))
    second_number = int(input("The second number: "))
    d = (first_number + second_number) // 2
    new_d = str(d)
    print("D:", str(d), "\nType of D:", type(d))
    print("The first digit in D:", new_d[0])
    print("The last digit in D:", new_d[len(new_d)-1])
    print("The Output of Average is from back to front:")
    for new_d_item in reversed(new_d):
        print(new_d_item)

    play_agian = ""

    def playagian():
        "Get play_agian's value"
        play_agian = input(
            "Do you wont collect the Averge another Numbers agian(yes / no)")
        if play_agian == "yes":
            average()
        elif play_agian != "no":
            playagian()

    playagian()


average()


""" Test:
Please enter two integers.
The first number: 123
The second number: 456
D: 289.5
Type of D: <class 'float'>
The first digit in D: 2
The last digit in D: 9
The Output of Average is from back to front:
9
8
2
"""

# Aufabe 4

my_bool = True #or False, it work’s with both of them
while(my_bool == True):
    #while-branch
while (my_bool == False):
    #while-branch

""" Solang der Wert True oder False ist, wird die Schleife durchlaufen.
    Oder bis die Schleife break in while-branch findet."""
