""" This script is the solution of Exercise Sheet No.4 - Task 1 """

from random import shuffle
from collections import OrderedDict

__author__ = "0016285: Kaddour Alnaasan"
__credits__ = """If you would like to thank somebody
              i.e. an other student for her code or leave it out"""
__email__ = "qaduralnaasan@gmail.com"

COLORS = ["Ka", "He", "Pi", "Kr"]
POINTS = {"7": 7, "8": 8, "9": 9, "10": 10,
          "Bu": 20, "Da": 10, "Ko": 10, "As": 11}

global card_types
global active_card
global results_play
playing_cards = []
list_of_players = []
cards_List = []


def getnumber(message):
    """To read number from Console."""
    is_num = False
    while is_num == False:
        try:
            number = int(input(message))
            break
        except:
            print("Gaben Sie eine ganze Zahl ein!")
    return number


def showactivecard():
    """To show the active Card"""
    active_card = storage_cards[len(storage_cards)-1]
    print("Es liegt:", active_card)


def generatecardlist(x):
    """ To generate a List of playing Cards.
        x is a number of Cards 0 <= x <= 8 (x = 4 would,
        for examole 7,8,9,10)"""
    card_types = []
    numbers = range(10, 10-x, -1)
    for num in numbers:  # convert from Int into String
        x = str(num)
        card_types.append(x)
    card_types = card_types + ["Bu", "Da", "Ko", "As"]
    for color in COLORS:
        for card_type in card_types:
            playing_cards.append(color + card_type)
    return playing_cards, card_types


def inputplayersnames(numbers_of_players):
    """ To read the Names of Players"""
    for player_num in range(numbers_of_players):
        player_name = input("Gaben Sie den Namen " +
                            str(player_num+1)+"-Spielers:")
        if player_name == "":
            list_of_players.append(player_num + 1)
        else:
            list_of_players.append(player_name)
    return list_of_players


def givecards(playing_cards, numbers_of_players, n):
    """ to give every Players his Cards """
    for player_num in range(numbers_of_players):
        player_cards = playing_cards[player_num:player_num+n]
        cards_List.append(player_cards)
        # Delete player_cards from playing_cards(=rest_card)
        for card in player_cards:
            del playing_cards[playing_cards.index(card)]
    rest_card = playing_cards
    return rest_card, cards_List


def playerturn(player):
    """ To give every Player his Turn."""
    print("Spieler", list_of_players[player], ":", cards_List[player])
    active_card = storage_cards[len(storage_cards)-1]
    is_card = False
    for card in cards_List[player]:
        if active_card[0:2] == card[0:2]:
            entry_player = card
            break
        elif active_card[2:] == card[2:]:
            entry_player = card
            break
    else:
        entry_player = "a"
    print("Dein Spielzug: Entweder Karte spielen"
          " oder eine Karte (a)ufnehmen:", entry_player)

    # To manual Play
    # entry_player = input("Dein Spielzug: Entweder Karte spielen"
    #                      " oder eine Karte (a)ufnehmen: ")

    if entry_player == "a":  # Taek a Card
        cards_List[player].append(rest_card[0])
        del rest_card[0]
        active_card = storage_cards[len(storage_cards)-1]
        showactivecard()
        return active_card
    elif entry_player in cards_List[player]:    # Test the Play Move:
        is_card = False
        active_card = storage_cards[len(storage_cards)-1]
        for color in COLORS:    # Same Colors
            if (color in entry_player) and (color in active_card):
                is_card = True
                break
        if is_card == False:
            for card_type in card_types:  # Same Type (King, lady)
                if (card_type in entry_player) \
                        and (card_type in active_card):
                    is_card = True
                    break
        if is_card == True:  # play Card
            rem_card = cards_List[player].index(entry_player)
            del cards_List[player][rem_card]
            storage_cards.append(entry_player)
            active_card = storage_cards[len(storage_cards)-1]
            showactivecard()
            return entry_player
        else:
            print("Unzulaessiger Spielzug.")
            playerturn(player)
    else:
        active_card = storage_cards[len(storage_cards)-1]
        showactivecard()
        print("Bitte eine Karte angeben, die sich in deinem "
              "Blatt befindet.")
        playerturn(player)


def calculateresults():
    """ To calculate the Results of Play."""
    print("Die Ergebnisse sind:", )
    player_pointes = 0
    all_pointes = 0
    for player in range(numbers_of_players):
        player_name = list_of_players[player]
        if len(cards_List[player]) > 0:
            for card in cards_List[player]:
                card_type = card[2:]
                player_pointes += POINTS[card_type]
                results_play[player_name] -= player_pointes
                all_pointes += player_pointes
        results_play_dict = OrderedDict(
            sorted(results_play.items(), key=lambda t: t[1]))

    for player_name, player_pointes in results_play_dict.items():
        if player_pointes == 0:
            player_pointes = all_pointes
        print("Spieler/in:", player_name, " hat",
                        player_pointes, "Punkte")


############################################################
# Start Play:
playing_cards, card_types = generatecardlist(4)
shuffle(playing_cards)  # Shuffle the Cards
#print("playing_cards:", playing_cards)
numbers_of_players = 0
while numbers_of_players < 2 or numbers_of_players > 4:
    numbers_of_players = getnumber("Spieleranzahl (2-4)?")

list_of_players = inputplayersnames(numbers_of_players)

results_play = {}
for player in range(numbers_of_players):
    results_play[list_of_players[player]] = 0

start_cards_number = 0
while start_cards_number < 3 or start_cards_number > 5:
    start_cards_number = getnumber("Wie viele Karten soll jeder"
                                   " Spieler zu Beginn bekommen (3 bis 5)?")

rest_card, cards_List = givecards(
    playing_cards, numbers_of_players, start_cards_number)
storage_cards = []
storage_cards.append(rest_card[0])    # to open the first card
del rest_card[0]
active_card = storage_cards[len(storage_cards)-1]
showactivecard()

# Play Game
check = True
while check:
    for player in range(numbers_of_players):
        active_card = playerturn(player)
    if len(rest_card) == 0:  # rest_card empty
        rest_card = storage_cards
        shuffle(rest_card)
        storage_cards = rest_card[0]
        active_card = storage_cards[len(storage_cards)-1]
        del rest_card[0]
    elif len(cards_List[player]) == 0:  # Siegbedingung
        print("Mau Mau!!!")
        print("Spieler", list_of_players[player], "hat gewonnen!")
        calculateresults()
        check = False
        break
print("Das Spiel ist beendet.")


# Test:
# Spieleranzahl (2-4)?2
# Gaben Sie den Namen 1-Spielers:Kaddour
# Gaben Sie den Namen 2-Spielers:Alnaasan
# Wie viele Karten soll jeder Spieler zu Beginn bekommen (3 bis 5)?5
# Es liegt: KrDa
# Spieler Kaddour : ['Kr10', 'PiAs', 'He8', 'KaKo', 'Pi7']
# Dein Spielzug: Entweder Karte spielen oder eine Karte (a)ufnehmen: Kr10
# Es liegt: Kr10
# Spieler Alnaasan : ['Kr7', 'Ka7', 'KrBu', 'Pi8', 'KrKo']
# Dein Spielzug: Entweder Karte spielen oder eine Karte (a)ufnehmen: Kr7
# Es liegt: Kr7
# Spieler Kaddour : ['PiAs', 'He8', 'KaKo', 'Pi7']
# Dein Spielzug: Entweder Karte spielen oder eine Karte (a)ufnehmen: Pi7
# Es liegt: Pi7
# Spieler Alnaasan : ['Ka7', 'KrBu', 'Pi8', 'KrKo']
# Dein Spielzug: Entweder Karte spielen oder eine Karte (a)ufnehmen: Ka7
# Es liegt: Ka7
# Spieler Kaddour : ['PiAs', 'He8', 'KaKo']
# Dein Spielzug: Entweder Karte spielen oder eine Karte (a)ufnehmen: KaKo
# Es liegt: KaKo
# Spieler Alnaasan : ['KrBu', 'Pi8', 'KrKo']
# Dein Spielzug: Entweder Karte spielen oder eine Karte (a)ufnehmen: KrKo
# Es liegt: KrKo
# Spieler Kaddour : ['PiAs', 'He8']
# Dein Spielzug: Entweder Karte spielen oder eine Karte (a)ufnehmen: a
# Es liegt: KrKo
# Spieler Alnaasan : ['KrBu', 'Pi8']
# Dein Spielzug: Entweder Karte spielen oder eine Karte (a)ufnehmen: KrBu
# Es liegt: KrBu
# Spieler Kaddour : ['PiAs', 'He8', 'Ka9']
# Dein Spielzug: Entweder Karte spielen oder eine Karte (a)ufnehmen: a
# Es liegt: KrBu
# Spieler Alnaasan : ['Pi8']
# Dein Spielzug: Entweder Karte spielen oder eine Karte (a)ufnehmen: a
# Es liegt: KrBu
# Spieler Kaddour : ['PiAs', 'He8', 'Ka9', 'Kr8']
# Dein Spielzug: Entweder Karte spielen oder eine Karte (a)ufnehmen: Kr8
# Es liegt: Kr8
# Spieler Alnaasan : ['Pi8', 'KaBu']
# Dein Spielzug: Entweder Karte spielen oder eine Karte (a)ufnehmen: Pi8
# Es liegt: Pi8
# Spieler Kaddour : ['PiAs', 'He8', 'Ka9']
# Dein Spielzug: Entweder Karte spielen oder eine Karte (a)ufnehmen: PiAs
# Es liegt: PiAs
# Spieler Alnaasan : ['KaBu']
# Dein Spielzug: Entweder Karte spielen oder eine Karte (a)ufnehmen: a
# Es liegt: PiAs
# Spieler Kaddour : ['He8', 'Ka9']
# Dein Spielzug: Entweder Karte spielen oder eine Karte (a)ufnehmen: a
# Es liegt: PiAs
# Spieler Alnaasan : ['KaBu', 'PiKo']
# Dein Spielzug: Entweder Karte spielen oder eine Karte (a)ufnehmen: PiKo
# Es liegt: PiKo
# Spieler Kaddour : ['He8', 'Ka9', 'HeAs']
# Dein Spielzug: Entweder Karte spielen oder eine Karte (a)ufnehmen: a
# Es liegt: PiKo
# Spieler Alnaasan : ['KaBu']
# Dein Spielzug: Entweder Karte spielen oder eine Karte (a)ufnehmen: a
# Es liegt: PiKo
# Spieler Kaddour : ['He8', 'Ka9', 'HeAs', 'He10']
# Dein Spielzug: Entweder Karte spielen oder eine Karte (a)ufnehmen: a
# Es liegt: PiKo
# Spieler Alnaasan : ['KaBu', 'KaAs']
# Dein Spielzug: Entweder Karte spielen oder eine Karte (a)ufnehmen: a
# Es liegt: PiKo
# Spieler Kaddour : ['He8', 'Ka9', 'HeAs', 'He10', 'Pi10']
# Dein Spielzug: Entweder Karte spielen oder eine Karte (a)ufnehmen: Pi10
# Es liegt: Pi10
# Spieler Alnaasan : ['KaBu', 'KaAs', 'Ka8']
# Dein Spielzug: Entweder Karte spielen oder eine Karte (a)ufnehmen: a
# Es liegt: Pi10
# Spieler Kaddour : ['He8', 'Ka9', 'HeAs', 'He10']
# Dein Spielzug: Entweder Karte spielen oder eine Karte (a)ufnehmen: He10
# Es liegt: He10
# Spieler Alnaasan : ['KaBu', 'KaAs', 'Ka8', 'He7']
# Dein Spielzug: Entweder Karte spielen oder eine Karte (a)ufnehmen: He7
# Es liegt: He7
# Spieler Kaddour : ['He8', 'Ka9', 'HeAs']
# Dein Spielzug: Entweder Karte spielen oder eine Karte (a)ufnehmen: He8
# Es liegt: He8
# Spieler Alnaasan : ['KaBu', 'KaAs', 'Ka8']
# Dein Spielzug: Entweder Karte spielen oder eine Karte (a)ufnehmen: Ka8
# Es liegt: Ka8
# Spieler Kaddour : ['Ka9', 'HeAs']
# Dein Spielzug: Entweder Karte spielen oder eine Karte (a)ufnehmen: Ka9
# Es liegt: Ka9
# Spieler Alnaasan : ['KaBu', 'KaAs']
# Dein Spielzug: Entweder Karte spielen oder eine Karte (a)ufnehmen: KaBu
# Es liegt: KaBu
# Spieler Kaddour : ['HeAs']
# Dein Spielzug: Entweder Karte spielen oder eine Karte (a)ufnehmen: a
# Es liegt: KaBu
# Spieler Alnaasan : ['KaAs']
# Dein Spielzug: Entweder Karte spielen oder eine Karte (a)ufnehmen: KaAs
# Es liegt: KaAs
# Mau Mau!!!
# Spieler Alnaasan hat gewonnen!
# Die Ergebnisse sind:
# Spieler/in: Kaddour  hat -32 Punkte
# Spieler/in: Alnaasan  hat 32 Punkte
# Das Spiel ist beendet.