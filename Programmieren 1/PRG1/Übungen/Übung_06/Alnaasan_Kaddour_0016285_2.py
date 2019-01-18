""" This script is the solution of Exercise Sheet No.4 - Task 3 and 4 """

__author__ = "0016285: Kaddour Alnaasan"
__credits__ = """If you would like to thank somebody
              i.e. an other student for her code or leave it out"""
__email__ = "qaduralnaasan@gmail.com"


def main():
    """ Docstring: The Main-Function to run the Program"""
    character_string = ["A", "B", "C", "D", "E", "F", "G", "H", "I",
                        "J", "K", "L", "M", "N", "O", "P", "Q", "R",
                        "S", "T", "U", "V", "W", "X", "Y", "Z", "AE",
                        "OE", "UE", "a", "b", "c", "d", "e", "f",
                        "g", "h", "i", "j", "k", "l", "m", "n", "o",
                        "p", "q", "r", "s", "t", "u", "v", "w", "x",
                        "y", "z", "ae", "oe", "ue", ]
    text = input("Geben Sie einen Text ein:")
    text_list = []
    for char in text:
        if char == "Ä":
            char = "AE"
        elif char == "ä":
            char = "ae"
        if char == "Ö":
            char = "OE"
        elif char == "ö":
            char = "oe"
        if char == "Ü":
            char = "UE"
        elif char == "ü":
            char = "ue"
        text_list.append(char)
    number_comparison = 0
    counter_1 = 0
    print("text_list:", text_list)
    """ While will stop, when she reads all Characters, that are in text_list.
        Tow-Whiles are uesd, the First While to read all Characters and the
        Second-While to compare every Char with all Characters in the List """
    while counter_1 < len(text_list):
        counter_2 = counter_1 + 1
        while counter_2 < len(text_list):
            if character_string.index(text_list[counter_1]) > \
                    character_string.index(text_list[counter_2]):
                char = text_list.pop(counter_2)
                text_list.insert(counter_1, char)
                print("text_list:", text_list)
            counter_2 += 1
            number_comparison += 1
        counter_1 += 1
    new_text = ""
    for item in text_list:
        new_text += item
    print("new Text:", new_text)
    print("The number of Comparison:", number_comparison)


if __name__ == "__main__":
    main()


# ################################################################################################
# Examples:
# First:
# Geben Sie einen Text ein:qwertzuioplkjhgfdsa
# text_list: ['q', 'w', 'e', 'r', 't', 'z', 'u', 'i', 'o', 'p', 'l', 'k', 'j', 'h', 'g', 'f', 'd',
# 's', 'a']
# text_list: ['e', 'q', 'w', 'r', 't', 'z', 'u', 'i', 'o', 'p', 'l', 'k', 'j', 'h', 'g', 'f', 'd',
#  's', 'a']
# text_list: ['d', 'e', 'q', 'w', 'r', 't', 'z', 'u', 'i', 'o', 'p', 'l', 'k', 'j', 'h', 'g', 'f',
#  's', 'a']
# text_list: ['a', 'd', 'e', 'q', 'w', 'r', 't', 'z', 'u', 'i', 'o', 'p', 'l', 'k', 'j', 'h', 'g',
#  'f', 's']
# text_list: ['a', 'd', 'e', 'i', 'q', 'w', 'r', 't', 'z', 'u', 'o', 'p', 'l', 'k', 'j', 'h', 'g',
#  'f', 's']
# text_list: ['a', 'd', 'e', 'h', 'i', 'q', 'w', 'r', 't', 'z', 'u', 'o', 'p', 'l', 'k', 'j', 'g',
#  'f', 's']
# text_list: ['a', 'd', 'e', 'g', 'h', 'i', 'q', 'w', 'r', 't', 'z', 'u', 'o', 'p', 'l', 'k', 'j',
#  'f', 's']
# text_list: ['a', 'd', 'e', 'f', 'g', 'h', 'i', 'q', 'w', 'r', 't', 'z', 'u', 'o', 'p', 'l', 'k',
#  'j', 's']
# text_list: ['a', 'd', 'e', 'f', 'g', 'h', 'i', 'o', 'q', 'w', 'r', 't', 'z', 'u', 'p', 'l', 'k',
#  'j', 's']
# text_list: ['a', 'd', 'e', 'f', 'g', 'h', 'i', 'l', 'o', 'q', 'w', 'r', 't', 'z', 'u', 'p', 'k',
#  'j', 's']
# text_list: ['a', 'd', 'e', 'f', 'g', 'h', 'i', 'k', 'l', 'o', 'q', 'w', 'r', 't', 'z', 'u', 'p',
#  'j', 's']
# text_list: ['a', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'o', 'q', 'w', 'r', 't', 'z', 'u',
#  'p', 's']
# text_list: ['a', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'o', 'p', 'q', 'w', 'r', 't', 'z',
#  'u', 's']
# text_list: ['a', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'o', 'p', 'q', 'r', 'w', 't', 'z',
#  'u', 's']
# text_list: ['a', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'o', 'p', 'q', 'r', 't', 'w', 'z',
#  'u', 's']
# text_list: ['a', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'o', 'p', 'q', 'r', 's', 't', 'w',
#  'z', 'u']
# text_list: ['a', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'o', 'p', 'q', 'r', 's', 't', 'u',
#  'w', 'z']
# new Text: adefghijklopqrstuwz
# The number of Comparison: 171
# ################################################################################################
# Second
# Geben Sie einen Text ein:äöjkadgadgtzzADFÄnbvÜ
# text_list: ['ae', 'oe', 'j', 'k', 'a', 'd', 'g', 'a', 'd', 'g', 't', 'z', 'z', 'A', 'D', 'F',
# 'AE', 'n', 'b', 'v', 'UE']
# text_list: ['j', 'ae', 'oe', 'k', 'a', 'd', 'g', 'a', 'd', 'g', 't', 'z', 'z', 'A', 'D', 'F',
# 'AE', 'n', 'b', 'v', 'UE']
# text_list: ['a', 'j', 'ae', 'oe', 'k', 'd', 'g', 'a', 'd', 'g', 't', 'z', 'z', 'A', 'D', 'F',
# 'AE', 'n', 'b', 'v', 'UE']
# text_list: ['A', 'a', 'j', 'ae', 'oe', 'k', 'd', 'g', 'a', 'd', 'g', 't', 'z', 'z', 'D', 'F',
# 'AE', 'n', 'b', 'v', 'UE']
# text_list: ['A', 'D', 'a', 'j', 'ae', 'oe', 'k', 'd', 'g', 'a', 'd', 'g', 't', 'z', 'z', 'F',
# 'AE', 'n', 'b', 'v', 'UE']
# text_list: ['A', 'D', 'F', 'a', 'j', 'ae', 'oe', 'k', 'd', 'g', 'a', 'd', 'g', 't', 'z', 'z',
# 'AE', 'n', 'b', 'v', 'UE']
# text_list: ['A', 'D', 'F', 'AE', 'a', 'j', 'ae', 'oe', 'k', 'd', 'g', 'a', 'd', 'g', 't', 'z',
# 'z', 'n', 'b', 'v', 'UE']
# text_list: ['A', 'D', 'F', 'AE', 'UE', 'a', 'j', 'ae', 'oe', 'k', 'd', 'g', 'a', 'd', 'g', 't',
# 'z', 'z', 'n', 'b', 'v']
# text_list: ['A', 'D', 'F', 'AE', 'UE', 'a', 'd', 'j', 'ae', 'oe', 'k', 'g', 'a', 'd', 'g', 't',
# 'z', 'z', 'n', 'b', 'v']
# text_list: ['A', 'D', 'F', 'AE', 'UE', 'a', 'a', 'd', 'j', 'ae', 'oe', 'k', 'g', 'd', 'g', 't',
# 'z', 'z', 'n', 'b', 'v']
# text_list: ['A', 'D', 'F', 'AE', 'UE', 'a', 'a', 'b', 'd', 'j', 'ae', 'oe', 'k', 'g', 'd', 'g',
# 't', 'z', 'z', 'n', 'v']
# text_list: ['A', 'D', 'F', 'AE', 'UE', 'a', 'a', 'b', 'd', 'g', 'j', 'ae', 'oe', 'k', 'd', 'g',
# 't', 'z', 'z', 'n', 'v']
# text_list: ['A', 'D', 'F', 'AE', 'UE', 'a', 'a', 'b', 'd', 'd', 'g', 'j', 'ae', 'oe', 'k', 'g',
# 't', 'z', 'z', 'n', 'v']
# text_list: ['A', 'D', 'F', 'AE', 'UE', 'a', 'a', 'b', 'd', 'd', 'g', 'g', 'j', 'ae', 'oe', 'k',
# 't', 'z', 'z', 'n', 'v']
# text_list: ['A', 'D', 'F', 'AE', 'UE', 'a', 'a', 'b', 'd', 'd', 'g', 'g', 'j', 'k', 'ae', 'oe',
# 't', 'z', 'z', 'n', 'v']
# text_list: ['A', 'D', 'F', 'AE', 'UE', 'a', 'a', 'b', 'd', 'd', 'g', 'g', 'j', 'k', 't', 'ae',
# 'oe', 'z', 'z', 'n', 'v']
# text_list: ['A', 'D', 'F', 'AE', 'UE', 'a', 'a', 'b', 'd', 'd', 'g', 'g', 'j', 'k', 'n', 't',
# 'ae', 'oe', 'z', 'z', 'v']
# text_list: ['A', 'D', 'F', 'AE', 'UE', 'a', 'a', 'b', 'd', 'd', 'g', 'g', 'j', 'k', 'n', 't',
# 'z', 'ae', 'oe', 'z', 'v']
# text_list: ['A', 'D', 'F', 'AE', 'UE', 'a', 'a', 'b', 'd', 'd', 'g', 'g', 'j', 'k', 'n', 't',
# 'v', 'z', 'ae', 'oe', 'z']
# text_list: ['A', 'D', 'F', 'AE', 'UE', 'a', 'a', 'b', 'd', 'd', 'g', 'g', 'j', 'k', 'n', 't',
# 'v', 'z', 'z', 'ae', 'oe']
# new Text: ADFAEUEaabddggjkntvzzaeoe
# The number of Comparison: 210
# ################################################################################################
# Third
# Geben Sie einen Text ein:üöäzyxwutsrqponmlkjihgfedcba
# text_list: ['ue', 'oe', 'ae', 'z', 'y', 'x', 'w', 'u', 't', 's', 'r', 'q', 'p', 'o', 'n', 'm',
# 'l', 'k', 'j', 'i', 'h', 'g', 'f', 'e', 'd', 'c', 'b', 'a']
# text_list: ['oe', 'ue', 'ae', 'z', 'y', 'x', 'w', 'u', 't', 's', 'r', 'q', 'p', 'o', 'n', 'm',
# 'l', 'k', 'j', 'i', 'h', 'g', 'f', 'e', 'd', 'c', 'b', 'a']
# text_list: ['ae', 'oe', 'ue', 'z', 'y', 'x', 'w', 'u', 't', 's', 'r', 'q', 'p', 'o', 'n', 'm',
# 'l', 'k', 'j', 'i', 'h', 'g', 'f', 'e', 'd', 'c', 'b', 'a']
# text_list: ['z', 'ae', 'oe', 'ue', 'y', 'x', 'w', 'u', 't', 's', 'r', 'q', 'p', 'o', 'n', 'm',
# 'l', 'k', 'j', 'i', 'h', 'g', 'f', 'e', 'd', 'c', 'b', 'a']
# text_list: ['y', 'z', 'ae', 'oe', 'ue', 'x', 'w', 'u', 't', 's', 'r', 'q', 'p', 'o', 'n', 'm',
# 'l', 'k', 'j', 'i', 'h', 'g', 'f', 'e', 'd', 'c', 'b', 'a']
# text_list: ['x', 'y', 'z', 'ae', 'oe', 'ue', 'w', 'u', 't', 's', 'r', 'q', 'p', 'o', 'n', 'm',
# 'l', 'k', 'j', 'i', 'h', 'g', 'f', 'e', 'd', 'c', 'b', 'a']
# text_list: ['w', 'x', 'y', 'z', 'ae', 'oe', 'ue', 'u', 't', 's', 'r', 'q', 'p', 'o', 'n', 'm',
# 'l', 'k', 'j', 'i', 'h', 'g', 'f', 'e', 'd', 'c', 'b', 'a']
# text_list: ['u', 'w', 'x', 'y', 'z', 'ae', 'oe', 'ue', 't', 's', 'r', 'q', 'p', 'o', 'n', 'm',
# 'l', 'k', 'j', 'i', 'h', 'g', 'f', 'e', 'd', 'c', 'b', 'a']
# text_list: ['t', 'u', 'w', 'x', 'y', 'z', 'ae', 'oe', 'ue', 's', 'r', 'q', 'p', 'o', 'n', 'm',
# 'l', 'k', 'j', 'i', 'h', 'g', 'f', 'e', 'd', 'c', 'b', 'a']
# text_list: ['s', 't', 'u', 'w', 'x', 'y', 'z', 'ae', 'oe', 'ue', 'r', 'q', 'p', 'o', 'n', 'm',
# 'l', 'k', 'j', 'i', 'h', 'g', 'f', 'e', 'd', 'c', 'b', 'a']
# text_list: ['r', 's', 't', 'u', 'w', 'x', 'y', 'z', 'ae', 'oe', 'ue', 'q', 'p', 'o', 'n', 'm',
# 'l', 'k', 'j', 'i', 'h', 'g', 'f', 'e', 'd', 'c', 'b', 'a']
# text_list: ['q', 'r', 's', 't', 'u', 'w', 'x', 'y', 'z', 'ae', 'oe', 'ue', 'p', 'o', 'n', 'm',
# 'l', 'k', 'j', 'i', 'h', 'g', 'f', 'e', 'd', 'c', 'b', 'a']
# text_list: ['p', 'q', 'r', 's', 't', 'u', 'w', 'x', 'y', 'z', 'ae', 'oe', 'ue', 'o', 'n', 'm',
# 'l', 'k', 'j', 'i', 'h', 'g', 'f', 'e', 'd', 'c', 'b', 'a']
# text_list: ['o', 'p', 'q', 'r', 's', 't', 'u', 'w', 'x', 'y', 'z', 'ae', 'oe', 'ue', 'n', 'm',
# 'l', 'k', 'j', 'i', 'h', 'g', 'f', 'e', 'd', 'c', 'b', 'a']
# text_list: ['n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'w', 'x', 'y', 'z', 'ae', 'oe', 'ue', 'm',
# 'l', 'k', 'j', 'i', 'h', 'g', 'f', 'e', 'd', 'c', 'b', 'a']
# text_list: ['m', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'w', 'x', 'y', 'z', 'ae', 'oe', 'ue',
# 'l', 'k', 'j', 'i', 'h', 'g', 'f', 'e', 'd', 'c', 'b', 'a']
# text_list: ['l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'w', 'x', 'y', 'z', 'ae', 'oe',
# 'ue', 'k', 'j', 'i', 'h', 'g', 'f', 'e', 'd', 'c', 'b', 'a']
# text_list: ['k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'w', 'x', 'y', 'z', 'ae',
# 'oe', 'ue', 'j', 'i', 'h', 'g', 'f', 'e', 'd', 'c', 'b', 'a']
# text_list: ['j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'w', 'x', 'y', 'z',
# 'ae', 'oe', 'ue', 'i', 'h', 'g', 'f', 'e', 'd', 'c', 'b', 'a']
# text_list: ['i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'w', 'x', 'y',
# 'z', 'ae', 'oe', 'ue', 'h', 'g', 'f', 'e', 'd', 'c', 'b', 'a']
# text_list: ['h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'w', 'x',
# 'y', 'z', 'ae', 'oe', 'ue', 'g', 'f', 'e', 'd', 'c', 'b', 'a']
# text_list: ['g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'w',
# 'x', 'y', 'z', 'ae', 'oe', 'ue', 'f', 'e', 'd', 'c', 'b', 'a']
# text_list: ['f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u',
# 'w', 'x', 'y', 'z', 'ae', 'oe', 'ue', 'e', 'd', 'c', 'b', 'a']
# text_list: ['e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't',
# 'u', 'w', 'x', 'y', 'z', 'ae', 'oe', 'ue', 'd', 'c', 'b', 'a']
# text_list: ['d', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's',
# 't', 'u', 'w', 'x', 'y', 'z', 'ae', 'oe', 'ue', 'c', 'b', 'a']
# text_list: ['c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r',
# 's', 't', 'u', 'w', 'x', 'y', 'z', 'ae', 'oe', 'ue', 'b', 'a']
# text_list: ['b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q',
# 'r', 's', 't', 'u', 'w', 'x', 'y', 'z', 'ae', 'oe', 'ue', 'a']
# text_list: ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p',
# 'q', 'r', 's', 't', 'u', 'w', 'x', 'y', 'z', 'ae', 'oe', 'ue']
# new Text: abcdefghijklmnopqrstuwxyzaeoeue
# The number of Comparison: 378
