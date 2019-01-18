__author__ = "0016285: Kaddour Alnaasan"
# s8362356@stud.uni-frankfurt.de

# Aufgabe 1


def loops():
    def while_loop(num):
        num_new = 0
        counter = num
        while counter != 0:
            num_new = num_new + counter
            counter = counter - 1
        average = num_new / num
        print("Der Durchschnitt der Zahlen:", str(average))

    def for_loop(num):
        num_new = 0
        for counter in range(1, num + 1):
            num_new = num_new + counter
        average = num_new / num
        print("Der Durchschnitt der Zahlen:", str(average))

    loop_kind = input("Gaben Sie den Schleifenart (while/for):")

    if loop_kind == "while":
        number = int(input("Gaben Sie eine Zahl: "))
        while_loop(number)
    elif loop_kind == "for":
        number = int(input("Gaben Sie eine Zahl: "))
        for_loop(number)
    else:
        loops()


# loops()

# Aufgabe 2

# Aufgabe 3
# Aufgabe 4
def happynumber():
    start_number = int(input("Geben Sie eine Zahl: "))
    worked_number = start_number
    mod = 1
    new_number = 0
    counter = 1
    while worked_number != 1:
        while worked_number != 0:
            mod = worked_number % 10
            worked_number = worked_number // 10
            new_number = new_number + (mod * mod)
        print("Die neue Zahl ist:", new_number)
        if new_number == 1:
            print("Die Zahi(", start_number, ") ist fröhlich.")
        elif new_number == 4 or counter == 100:
            print("there is a loop!!!")
            break
        
        # if new_number != start_number:
        worked_number = new_number
        new_number = 0
        counter = counter + 1
    play_again = input("Wollen Sie noch mal spielen (ja/nein):")
    if play_again != "nein":
        happynumber()


happynumber()
