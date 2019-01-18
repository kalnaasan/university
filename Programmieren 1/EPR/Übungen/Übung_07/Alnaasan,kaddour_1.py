""" This script is the solution of Exercise Sheet No.4 - Task 1 """
from os import system
from platform import system as _system_name

__author__ = "0016285: Kaddour Alnaasan"
__credits__ = """If you would like to thank somebody
              i.e. an other student for her code or leave it out"""
__email__ = "qaduralnaasan@gmail.com"


def main():

    class Member:
        def __init__(self):
            self.iD = None
            self.name = None

    class Professor(Member):
        def __init__(self, iD, name):
            self.iD = iD
            self.name = name

    class WIMI(Member):
        def __init__(self, iD, name):
            self.iD = iD
            self.name = name

    class Presentation():

        def __init__(self, iD, title, date):
            self.iD = iD
            self.title = title
            self.date = date

        def change_date(self, new_date):
            self.date = new_date

    class ResearchGeoup():
        def __init__(self, name):
            self.name = name
            self.total_presentation = []
            self.heads = []
            self.members = []

        def set_head(self, prof):
            self.heads.append({"iD": prof.iD, "name": prof.name})

        def get_head(self):
            return self.heads

        def add_member(self, member):
            self.members.append({"iD": member.iD, "name": member.name})

        def get_members(self):
            return self.members

        def set_presentation(self, member, pres):
            self.total_presentation.append({"iD": pres.iD,
                                            "title": pres.title,
                                            "date": pres.date,
                                            "presenter": member.name})

        def get_total_presentation(self):
            return self.total_presentation

    def clear_console():
        if _system_name() == "Windows":
            system("cls")
        else:
            for i in range(50):
                i = ""
                print(i)
        print("###################################################"
              "##################\n###############################"
              "######################################\n###########"
              "###################################################"
              "#######")
        print("Info: We want to create a scientific group, the foll"
              "owing information\n      must be given:")

    def input_string(message=""):
        "Docstring: to test if the input value is text"
        text = ""
        while True:
            try:
                text = input(message)
                is_num = float(text)
                if is_num:
                    print("You have not given a text, please try again")
            except:
                if text == "":
                    print("Info:  You should enter a name, not an empty name")
                else:
                    break
        return text

    def input_int():
        """ Docstring: To read a Nummber from The User."""
        nummber = ""
        while True:
            try:
                nummber = input()
                nummber = int(nummber)
                if nummber:
                    break
            except:
                print("You have not given a Nummber, please try again")
        return nummber

    def create_group():
        """ Docstring: To create a Group"""
        return group

    def print_read_value(message, value, read_value=False):
        """Docstring: """
        print("###################################################"
              "##################\nInfo:  " + str(message) + " " +
              str(value))
        if read_value == True:
            input_value = input_string("Input: ")
            print("####################################################"
                  "#################")
            return input_value
        else:
            print("####################################################"
                  "#################")

    ################################################################
    ################################################################
    # Program start's
    ################################################################
    ################################################################
    groups = []
    professors = []
    members_wimi = []

    clear_console()

    groups.append(print_read_value("Enter the Name of Group:", "", True))
    group = ResearchGeoup(groups[0])

    professors.append(print_read_value(
        "Enter the Name of Professor:", "", True))
    prof = Professor(1, professors[0])

    is_head_of_groppe = ""
    print("is The Professor the Head of Gruppe (yes/no)")
    while True:
        is_head_of_groppe = input_string()
        if is_head_of_groppe == "Yes" or\
             is_head_of_groppe == "yes" or\
             is_head_of_groppe == "Y" or\
             is_head_of_groppe == "y":
            break
        else:
            print("Please enter Yes or No.")
            

    if is_head_of_groppe == "yes":
        group.set_head(prof)

    print("3-Member")

    def create_wimi():
        """ Docstring: """
        iD = len(members_wimi)
        # name = input_string()
        name = print_read_value("Enter the Name of Worker:", "", True)
        member_wimi = WIMI(iD + 1, name)
        return member_wimi, iD

    print("The Group should at least a Memmber:")
    memmber_wimi, iD = create_wimi()
    members_wimi.append(memmber_wimi)
    group.add_member(members_wimi[iD])

    def menu():
        """Docstring: """
        print("What do you wont to do?\n"
              "1 - Get the Head of Group.\n"
              "2 - Get all Members in the Group.\n"
              "3 - Get the Date of Presentaation for a Memmber.\n"
              "4 - Get All Presentations\n"
              "5 - Add Professor.\n"
              "6 - Add Memmber-\n"
              "7 - Add a Presentation to Memmber\n"
              "8 - Change the Date a Presentation.\n"
              "9 - To Exit")
        process_num = input_int()
        if process_num == 1:
            print_read_value("The Name of Professor is:",
                             group.get_head()[0]["name"])
            # print("#########################################################"
            #       "############\nInfo: The Name of Professor is:",
            #       group.get_head()[0]["name"],
            #       "\n#########################################################"
            #       "############")
        # elif process_num == 2:
        #     pass
        # elif process_num == 3:
        #     pass
        # elif process_num == 4:
        #     pass
        # elif process_num == 5:
        #     pass
        # elif process_num == 6:
        #     pass
        # elif process_num == 7:
        #     pass
        # elif process_num == 8:
        #     pass
        if process_num != 9:
            menu()

    menu()

    # print("after Menu:", group.get_head())
    # pres_1 = Presentation(1, "IT", "2019.2.6")
    # pres_2 = Presentation(2, "Wirtschaft", "2019.2.7")

    # group.add_member(member_2)

    # group.set_presentation(member_1, pres_1)
    # group.set_presentation(member_2, pres_2)

    # print(group.get_head())
    # print(group.get_members())
    # print(group.get_total_presentation())


if __name__ == "__main__":
    main()
