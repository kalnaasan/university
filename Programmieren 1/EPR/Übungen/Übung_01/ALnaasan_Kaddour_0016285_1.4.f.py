__author__ = "0016285: Kaddour Alnaasan"


#Aufgabe 1.4
#F

str_time = input("What time is it now?")
str_wait_time = input("What is the number of hours to wait?")
time = int(str_time)
# wrong Name of variable
wait_time = int(str_wait_time)

time_when_alarm_go_off = time + wait_time

if time_when_alarm_go_off <= 23:
    print(time_when_alarm_go_off)
else:
    rigth_time_when_alarm_go_off = time_when_alarm_go_off - 24
    print(rigth_time_when_alarm_go_off)


# Test:
#   What time is it now?10
#   What is the number of hours to wait?5
#   15
