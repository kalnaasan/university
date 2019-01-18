""" This script is the solution of Exercise Sheet No.6 """

__author__ = "0016285: Kaddour Alnaasan"
__credits__ = """If you would like to thank somebody
              i.e. an other student for her code or leave it out"""
__email__ = "qaduralnaasan@gmail.com"


def get_number(message, b, e):
    """ Docstring: To get number from Console"""
    number = ""
    while True:
        try:
            number = input(message)
            number = int(number)
            if number > b-1 and number <= e:
                break
            else:
                print("Sie haben eine falsche Zahl gegeben.")
        except:
            print("Sie haben einen Text gegeben.")
    return number


def first_exercise():
    """ Docstring: The Selution from 1th-exercise"""
    text = input("Geben Sie einen Text ein:")
    text_list = []
    for char in text:
        text_list.append(char)

    for char_item in text_list:
        if char_item == "a":
            print("Char:", char_item)
            text_list.remove(char_item)
            print("text list:", text_list)
        elif char_item == "A":
            print("Char:", char_item)
            text_list.remove(char_item)
            print("text list:", text_list)
        elif char_item == "5":
            print("Char:", char_item)
            text_list.remove(char_item)
            print("text list:", text_list)

    new_text = ""
    for item in text_list:
        new_text += item
    print("new text:", new_text)


def second_exercise():
    """ Docstring: The Selution from 2th-exercise"""
    text = input("Geben Sie einen Text ein:")
    text_list = []
    for char in text:
        text_list.append(char)
    counter = 0
    while counter < len(text):
        if text_list[counter] == "9":
            text_list[counter] = "neun"
        counter += 1
    new_text = ""
    for item in text_list:
        new_text += item
    print("new Text:", new_text)


def third_exercise():
    """ Docstring: The Selution from 3th-exercise"""
    # text = ""
    # while True:
    text = input("Geben Sie einen Text ein:")
    sobject = slice(4)
    new_text = text[sobject]
    print("new Text:", new_text)


def fourth_exercise():
    """ Docstring: The Selution from 4th-exercise"""
    text = input("Geben Sie einen Text ein:")
    len_text = len(text)
    sobject = slice(len_text-3, len_text, 1)
    new_text = text[sobject]
    print("new Text:", new_text)


def fifth_exercise():
    """ Docstring: The Selution from 5th-exercise"""
    text = input("Geben Sie einen Text ein:")
    len_text = len(text)
    sobject = slice(2, len_text, 2)
    new_text = text[sobject]
    print("new Text:", new_text)

def sixth_exercise():
    """ Docstring: The Selution from 6th-exercise"""
    text = input("Geben Sie einen Text ein:")
    sobject = slice(-4)
    new_text = text[sobject]
    print("new Text:", new_text)


def main():
    """ Docstring: The Main-Function to run the Program"""
    choose = get_number("Geben Sie den Nummer der Aufgabe ein (1-6): ", 1, 6)
    if choose == 1:
        first_exercise()
    elif choose == 2:
        second_exercise()
    elif choose == 3:
        third_exercise()
    elif choose == 4:
        fourth_exercise()
    elif choose == 5:
        fifth_exercise()
    elif choose == 6:
        sixth_exercise()


if __name__ == "__main__":
    main()