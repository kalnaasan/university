"""A game of Mau Mau for two to four players.

"""

import os
import sys
import platform
from random import shuffle, random


CARD_COLORS = ["Herz", "Karo", "Kreuz", "Pik"]
CARD_VALUES = ["7", "8", "9", "10", "Bube", "Dame", "König", "Ass"]


def amount_players():
    """Starts the game and asks for information about the number of
    players.
    """
    print("Mau Mau wurde gestartet.")
    while True:
        number = input("Wie viele Spieler (2 bis 4)? ")
        if number == "2" or number == "3" or number == "4":
            number = int(number)
            break
        else:
            print("Keine Zahl, oder Anzahl an Spielern nicht möglich. \
Probieren sie es nocheinmal.")
    return number


def name_player(number):
    """This returns the name of the player with number \"number\"."""
    player = input("Wie soll Spieler " + str(number) + " heißen? ")
    return player


def all_players():
    """This function creates and returns the list of players."""
    player_count = amount_players()
    competitors = []
    i = 0
    while i < player_count:
        competitors = competitors + [[(i+1, name_player(i+1))]]
        i += 1
    return competitors


def create_deck():
    """This function creates a deck of 32 cards."""
    deck = []
    for color in CARD_COLORS:
        for number in CARD_VALUES:
            deck = [(color, number)] + deck
    return deck


def move_card(coming_from, to, amount=1, card_number=0):
    """This function moves cards from one list to another."""
    i = 0
    while i < amount:
        to = [coming_from[card_number]] + to
        coming_from.remove(coming_from[card_number])
        i += 1
    return coming_from, to


def set_up(list_of_players, deck):
    """This function deals the cards at the beginning of the game."""
    player_hands = []
    discard = []
    for i in list_of_players:
        # If you want to start the game with 3 cards, change here.
        deck, player_hand = move_card(deck, i, 5)
        player_hands += [player_hand]
    deck, discard = move_card(deck, discard)
    return player_hands, deck, discard


def card_fit(card, stack):
    """This function checks if the card fits the first card of a stack.
    """
    if card[0] == stack[0] or card[1] == stack[1]:
        return False
    else:
        return True


def deck_refiller(deck, discard):
    """A function that shuffles all but the first card of the discard
    stack into a new deck."""
    if len(deck) == 0:
        new_discard = [discard[0]]
        new_deck = discard[1:]
        shuffle(new_deck)
        print("Die Karten wurden neu gemischt")
        # print(new_deck)   # Uncomment if you want to see the new deck.
    else:
        new_discard = discard
        new_deck = deck
    return new_deck, new_discard


def choose_card(hand, draw=True):
    """This function shows the hand, and returns the choice of card.
        draw: can be set to false if a card can not be drawn."""
    if draw:
        print("0 -> Karte ziehen")
    else:
        print("0 -> Kann nicht, also setze ich aus :(")
    for i in range(0, len(hand)-1):
        print(str(i+1) + " -> " + str(hand[i]))
    choice = input("Welche Aktion möchten Sie ausführen? ")
    while not choice.isdigit():
        choice = input("Bitte geben Sie eine Zahl an: ")
    choice = int(choice)
    return choice


def next_player(current_player, all_players):
    """A function to return the index of the next player."""
    if current_player < len(all_players)-1:
        current_player += 1
    elif current_player == len(all_players)-1:
        current_player = 0
    return current_player


def clear():
    """ A function to clear the board after each move, works
        dependant on the shell."""
    if sys.platform[0] == "w":
        os.system('cls')
    elif sys.platform[0] == "l":
        os.system('clear')
    else:
        for i in range(50):
            i = i
            print()


def ui(all_hands, deck, discard):
    """This function prints the information for a player."""
    deck, discard = deck_refiller(deck, discard)
    print("______________________________________________")
    for i in all_hands:
        print(i[-1][1] + " (Spieler " + str(i[-1][0]) + ") hat noch   "
              + str(len(i)-1) + "   Karten.")
    print("______________________________________________")
    print("Es sind noch " + str(len(deck)) + " Karten auf dem Nachziehstapel.")
    print("Offenliegende Karte:\n \n", discard[0])
    print("______________________________________________")
    return deck, discard


def game_loop(hands, deck, discard):
    """This manages the games execution."""
    i = 0
    clear()
    while len(hands[i]) > 1:
        for player in hands:
            print("---------> " + player[-1][1] + " (Spieler "
                  + str(player[-1][0]) + ") <---------")
            input("Drücken Sie 'Enter' um Ihren Zug zu starten.")
            deck, discard = ui(hands, deck, discard)
            if len(deck) == 0:   # This only activates if the deck
                                 # is empty and cannot be refilled
                print("ACHTUNG: Es wurden alle Karten außer der Offenliegenden\
                        gezogen. Bis eine Karte gelegt wurde ist es nicht\
                        möglich eine zu ziehen.\n")
                choice = choose_card(player, False)
                # These loops would work better as a function
                while (not choice in range(len(player))) \
                        or card_fit(player[choice-1], discard[0]):
                    if choice == 0:
                        break
                    print("______________________________________________")
                    print("Ihre Auswahl passt nicht auf die offen liegende\
                            Karte oder befindet sich nicht auf Ihrer Hand!")
                    print("Probieren Sie es noch einmal:")
                    choice = choose_card(player, False)
            else:                # This is the usual way.
                choice = choose_card(player)
                while (not choice in range(len(player))) \
                        or card_fit(player[choice-1], discard[0]):
                    if choice == 0:
                        break
                    print("______________________________________________")
                    print("Ihre Auswahl passt nicht auf die offen liegende \
Karte oder befindet sich nicht auf Ihrer Hand!")
                    print("Probieren Sie es noch einmal:")
                    choice = choose_card(player)

            if choice == 0 and len(deck) > 0:
                deck, player = move_card(deck, player)
                print("______________________________________________")
                second_choice = choose_card(player, False)
                while (not second_choice in range(len(player))) \
                        or card_fit(player[second_choice-1], discard[0]):
                    if second_choice == 0:
                        break
                    print("______________________________________________")
                    print("Ihre Auswahl passt nicht auf die offen liegende \
Karte oder befindet sich nicht auf Ihrer Hand!")
                    print("Probieren Sie es noch einmal:")
                    second_choice = choose_card(player, False)
                if second_choice == 0:
                    hands[i] = player
                    i = next_player(i, hands)
                elif 0 < second_choice < len(player):
                    player, discard = move_card(player, discard, 1,
                                                second_choice-1)
                    hands[i] = player
                    i = next_player(i, hands)
            elif 0 < choice < len(player):
                player, discard = move_card(player, discard, 1, choice-1)
                if len(player) == 1:
                    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
                    print("Mau Mau! " + player[0][1] + " (Spieler " + str(
                        player[0][0]) + ") hat das Spiel gewonnen! Whoo!")
                    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
                    break
                hands[i] = player
                i = next_player(i, hands)
            else:
                print("Sie haben Ausgesetzt")

            input("Drücken Sie 'Enter' um Ihren Zug zu beenden.")
            clear()
    return hands, deck, discard


def after_math(player):
    """A function that prints the scoreboard after the match."""

    scores = []
    for hands in player:
        score = 0
        cards = 0
        while len(hands) > 1:   # In this the scores are added up.
                                # If you want differen values for a card
                                # change here.
            if hands[0][1] == "Ass":
                score += 11
            elif hands[0][1] == "Bube" or hands[0][1] == "Dame" \
                    or hands[0][1] == "König":
                score += 10
            else:
                score += int(hands[0][1])
            del hands[0]
            cards += 1
        scores += [(score, cards, hands[0])]
        scores.sort()
    print("Die Plazierungen sind:")
    rank = 1
    for score in scores:
        if rank == 1:
            print("1. Platz: " + score[2][1] + " (Spieler " + str(score[2][0])
                  + ") hat alle Karten abgelegt.")
            rank += 1
        else:
            print(str(rank) + ". Platz: " + score[2][1] + " (Spieler "
                  + str(score[2][0]) + ") mit", score[1], "Karten im Wert von", score[0], "Punkten.")
            rank += 1


def __main__():
    players = all_players()
    deck = create_deck()
    shuffle(deck)
    # print(deck)   # Uncomment to test the shuffling of the cards
    player_hands, deck, discard = set_up(players, deck)
    player_hands, deck, discard = game_loop(player_hands, deck, discard)
    after_math(player_hands)
    input("Drücken Sie 'Enter' um das Spiel zu beenden.")


if __name__ == "__main__":
    __main__()
