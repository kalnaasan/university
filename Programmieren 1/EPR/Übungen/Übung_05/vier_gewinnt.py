import abc
""" This script is the solution of Exercise Sheet No.4 - Task 1 """

import random
from os import system
from platform import system as _system_name

__author__ = "0016285: Kaddour Alnaasan, 6805940: Abdul-Rahman Oudeh"
__credits__ = """If you would like to thank somebody
              i.e. an other student for her code or leave it out"""
__email__ = "qaduralnaasan@gmail.com, abdul.oudeh@stud.uni-frankfurt.de"


def generate_play():
    """ Docstring: To generate tne Main-List."""
    play = []
    for y in range(0, 10, 1):
        play.append([])
        counter = 0
        while counter < 9:
            counter += 1
            play[y].append("")
    return play


def get_nummber(message, start, end):
    """ Docstring: To read an Number from Console.
        - Message: Input Message.
        - start: the Bignn of Nummber's Range.
        - end: the End of Nummber's Range."""
    number = ""
    while True:
        try:
            number = input(message)
            number = int(number)
            if number > start-1 and number <= end:
                break
            else:
                print("Sie haben eine falsche Zahl gegeben.")
        except:
            print("Sie haben einen Text gegeben.")
    return number - 1


def get_players_names(number_players):
    """ Docstring: To read the Names of Players.
        number_players: Nummbers of Players."""
    names = []
    for player in range(0, number_players, 1):
        name = input("Geben Sie den Name des " +
                     str(player+1) + "-Spielers ein:")
        names.append(name)
    return names


def clear_console():
    """ Docstring: """
    print("_system_name:", _system_name)
    if _system_name() == "Windows":
        system("cls")
    elif _system_name() == "Linux":
        system("clear")
    elif _system_name() == "Mac":
        system("clear")


def print_play_to_console(play):
    """ Docstring: To print the Main-List to Console.
        play: The Main-List."""
    for item_row in play:
        print("###################################"
              "#########################################")
        output_1 = ""
        output_2 = ""
        for item_coll in item_row:
            if item_coll == "":
                output_1 += "###     "
                output_2 += "###     "
            else:
                output_1 += "###  " + item_coll + "  "
                output_2 += "###     "
        print(output_2 + " ###", "\n" + output_1 +
              " ###", "\n" + output_2, "###")
    print("###################################"
          "#########################################")


def menu():
    """ Docstring: To print Menu List to Console and choice a Value"""
    chose = False
    while chose == False:
        wahl = input(
            "Wählen Sie für:\n- Spiel neu starten (n)\n- Spiel beenden (q)\n")
        if wahl == "n":
            main()
            chose = True
            break
        elif wahl == "q":
            chose = True
        else:
            print("Ungültige Eingabe.")
    return chose


def is_point(play, symboles, player_num, row, coll):
    """ Docstring: To check if the current Cell has a Symbol.
        play: The List of Playing.
        symboles: The list of Symboles.
        player_num: The Number of Player.
        row_num: The Number of Row.
        col_num: The Number of Column."""
    is_point = False
    if (row >= 0 and row <= 9)and(coll >= 0 and coll <= 8):
        if play[row][coll] == symboles[player_num]:
            is_point = True
    return is_point


def first_form(play, symboles, player_num, row_num, col_num):
    """ Docstring: To check if the 1th-Form is on the Console
        play: The List of Playing.
        symboles: The list of Symboles.
        player_num: The Number of Player.
        row_num: The Number of Row.
        col_num: The Number of Column."""
    is_win = False
    first_point = True
    second_point = is_point(play, symboles, player_num, row_num, col_num+1)
    third_point = is_point(play, symboles, player_num, row_num+1, col_num)
    forth_point = is_point(play, symboles, player_num, row_num+1, col_num-1)
    if first_point == True and second_point == True and third_point == True and forth_point == True:
        is_win = True
    return is_win


def second_form(play, symboles, player_num, row_num, col_num):
    """ Docstring: To check if the 2th-Form is on the Console
        play: The List of Playing.
        symboles: The list of Symboles.
        player_num: The Number of Player.
        row_num: The Number of Row.
        col_num: The Number of Column."""
    is_win = False
    first_point = True
    second_point = is_point(play, symboles, player_num, row_num, col_num+1)
    third_point = is_point(play, symboles, player_num, row_num+1, col_num+1)
    forth_point = is_point(play, symboles, player_num, row_num+1, col_num+2)
    if first_point == True and second_point == True and third_point == True and forth_point == True:
        is_win = True
    return is_win


def third_form(play, symboles, player_num, row_num, col_num):
    """ Docstring: To check if the 3th-Form is on the Console
        play: The List of Playing.
        symboles: The list of Symboles.
        player_num: The Number of Player.
        row_num: The Number of Row.
        col_num: The Number of Column."""
    is_win = False
    first_point = True
    second_point = is_point(play, symboles, player_num, row_num+1, col_num)
    third_point = is_point(play, symboles, player_num, row_num+1, col_num+1)
    forth_point = is_point(play, symboles, player_num, row_num+2, col_num+1)
    if first_point == True and second_point == True and third_point == True and forth_point == True:
        is_win = True
    return is_win


def forth_form(play, symboles, player_num, row_num, col_num):
    """ Docstring: To check if the 4th-Form is on the Console
        play: The List of Playing.
        symboles: The list of Symboles.
        player_num: The Number of Player.
        row_num: The Number of Row.
        col_num: The Number of Column."""
    is_win = False
    first_point = True
    second_point = is_point(play, symboles, player_num, row_num+1, col_num)
    third_point = is_point(play, symboles, player_num, row_num+1, col_num-1)
    forth_point = is_point(play, symboles, player_num, row_num+2, col_num-1)
    if first_point == True and second_point == True and third_point == True and forth_point == True:
        is_win = True
    return is_win


def is_winner(play, symboles, player_num):
    """ Docstring: to test if player hat a Form to Win.
        play: The List of Playing.
        symboles: The list of Symboles.
        player_num: The Number of Player"""
    is_win = False
    row_num = 0
    while is_win == False and row_num <= 9:
        col_num = 0
        while is_win == False and col_num <= 8:
            if play[row_num][col_num] == symboles[player_num]:
                for form_num in range(0, 4, 1):
                    if form_num == 0:
                        is_win = first_form(
                            play, symboles, player_num, row_num, col_num)
                    elif form_num == 1:
                        is_win = second_form(
                            play, symboles, player_num, row_num, col_num)
                    elif form_num == 2:
                        is_win = third_form(
                            play, symboles, player_num, row_num, col_num)
                    elif form_num == 3:
                        is_win = forth_form(
                            play, symboles, player_num, row_num, col_num)
                    if is_win == True:
                        break
            col_num += 1
        row_num += 1
    return is_win


def player_turn(players_names, name, play, symboles, wrong_entry):
    """ Docstring: Player plays his Turn.
        players_names: The List of Names of Players.
        Name: the Name of Player.
        play: The List of Playing.
        symboles: The list of Symboles.
        wrong_entry: Ture or Flase to rerun."""
    logic_play = dict(is_winner=False, end_play=False)
    is_played = False
    clear_console()
    print_play_to_console(play)
    print("Spielzug von", name)
    if wrong_entry == True:
        print("Die Spalte ist voll, wählen Sie eine andere:")
    entry_player_column = -2
    if name == "!!PC!!":
        entry_player_column = random.randint(0, 8)
    else:
        entry_player_column = get_nummber(
            "Geben Sie die Nummer der Spalte ein (1-9) oder 0 um zum Menü zu gelangen:", 0, 9)
    if entry_player_column == -1:
        logic_play['end_play'] = menu()
    if logic_play['end_play'] == False:
        for item_row in reversed(play):
            if item_row[entry_player_column] == "":
                item_row[entry_player_column] = symboles[players_names.index(
                    name)]
                is_played = True
                break
        if is_played == False:
            player_turn(players_names, name, play, symboles, True)
        logic_play['is_winner'] = is_winner(
            play, symboles, players_names.index(name))
    return play, logic_play


def is_playing(play):
    """ Docstring: to check if there is possibility to play  """
    can_play = False
    for item_y in play:
        for item_x in item_y:
            if item_x == "":
                can_play = True
                break
    return can_play


def main():
    """ Docstring:The Main Function."""
    clear_console()
    symboles = ["X", "O"]
    playing_list = generate_play()
    number_players = get_nummber(
        "Geben Sie die Zahl der Spieler ein (1-2):", 1, 2)
    if number_players == 0:
        players_names = get_players_names(number_players + 1)
        players_names.append("!!PC!!")
    elif number_players == 1:
        players_names = get_players_names(number_players + 1)
    can_play = True
    logic_play = dict(is_winner=False, end_play=False)
    while can_play == True and\
            logic_play['is_winner'] == False and logic_play['end_play'] == False:
        for player_name in players_names:
            playing_list, logic_play = player_turn(
                players_names, player_name, playing_list, symboles, False)
            if logic_play['end_play'] == True:
                break
            can_play = is_playing(playing_list)
            if logic_play['is_winner'] == True:
                clear_console()
                print_play_to_console(playing_list)
                print(player_name, "hat gewonnen.")
                break
            if can_play == False:
                clear_console()
                print_play_to_console(playing_list)
                print("Es gibt keine Möglichkeit mehr zu spielen.")


if __name__ == "__main__":
    main()