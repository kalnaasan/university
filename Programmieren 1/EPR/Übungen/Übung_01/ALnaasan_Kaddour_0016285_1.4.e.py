__author__ = "0016285: Kaddour Alnaasan"


#Aufgabe 1.4
#E

#Wrong Double Qoution
a = input("enter an hour")
x = input("write a number of hours")

# need Variables
x_int = int(x)
a_int = int(a)

#should convert to Int
h = x_int // 24
s = x_int % 24

print (h, s, sep="\\t")
#need new variable and should convert to Int
current_a = a_int + s

#Wrong Double Qoution
print ("hour now", current_a)