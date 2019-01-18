""" This script is the solution of Exercise Sheet No.4 - Task 3 and 4 """

__author__ = "0016285: Kaddour Alnaasan"
__credits__ = """If you would like to thank somebody
              i.e. an other student for her code or leave it out"""
__email__ = "qaduralnaasan@gmail.com"


def length_list(text):
    length = len(text)
    return length


def invert_list(text):
    new_text = ""
    for i in range(len(text)-1, -1, -1):
        new_text += text[i]
    print("2) The invert Text:", new_text)
    return True


def multiplied_list(text):
    """"""
    my_default_param = 2
    new_text = text * my_default_param
    return new_text


def return_tow_character(text):
    """"""
    sobject = slice(2, 4, 1)
    return text[sobject]


def read_text(text):
    """"""
    len_text = length_list(text)
    sobject = slice(len_text-4, len_text, 1)
    new_text = text[sobject]
    return return_tow_character(new_text)


def main():
    """ Docstring: The Main-Function to run the Program"""
    text = input("Geben Sie einen Text ein:")
    length_text = length_list(text)    # 1
    print("1) The Length of Text:", str(length_text))    # 1
    invert_list(text)    # 2
    multi_text = multiplied_list(text)    # 3
    print("3) The multiple Text:", multi_text)  # 3
    tow_characters = read_text(text)    # 5
    print("5) The Last Tow Characters:", tow_characters)    # 5


if __name__ == "__main__":
    main()
