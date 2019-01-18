__author__ = "0016285: Kaddour Alnaasan"


# Aufgabe 2

# read IBAN
iban = input("Geben Sie Ihre IBAN ohne Lerrzeichnen: ")
# Read country Code
country_code = iban[0:2]
# Test if IBAN courrect (Country code and Number)


def is_iban(iban, country, char_num):
    while len(iban) != char_num:
        print("die", country, "IBAN ist", char_num, "Zeichnen.")
        iban = input("Geben Sie Ihre IBAN ohne Lerrzeichnen: ")
    iban_int = iban[2:]

    iban_int_len = len(iban_int)
    i = 0
    ascii_char = ord(iban_int[i])
    while ascii_char >= 48 and ascii_char <= 57:
        if i < iban_int_len:
            ascii_char = ord(iban_int[i])
            i = i + 1
        elif i == iban_int_len:
            print("Die IBAN ist gültich.", iban)
            break
    else:
        print("Die IBAN ist ungültich.")
        iban = input("Geben Sie Ihre IBAN ohne Lerrzeichnen: ")
        is_iban(iban, country, char_num)
    return iban


if country_code == "DE" or country_code == "de":
    is_iban(iban, "deutsche", 22)
elif country_code == "FR" or country_code == "fr":
    is_iban(iban, "französische", 27)
elif country_code == "CH" or country_code == "ch":
    is_iban(iban, "schweize", 21)
