__author__ = "0016285: Kaddour Alnaasan"


#Aufgabe 1.4
#C

n = input("What time is it now (in hours)?")
#Wrong Function
n = int(n)
m = input("How many hours do you want to wait?")
m = int(m)

#Wrong opration and value
q = m + n
if q <= 12:
    print("The Final Time", q)
else:
    w = q - 12
    print("The Final Time", w)

# Test
#   What is the current time (in hours 0-23)?10
#   How many hours do you want to wait:
#   The Final Time: 3