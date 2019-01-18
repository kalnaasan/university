__author__ = "0016285: Kaddour Alnaasan"


#Aufgabe 1.4
#B

#Wrong Double Qoution and 'intput' wrong 
current_time_str = input("What is the current time (in hours 0-23)?")
current_time_int = int(current_time_str)

wait_time_str = input("How many hours do you want to wait")
# wrong Name of variable
wait_time_int = int(wait_time_str)

final_time_int = current_time_int + wait_time_int

if final_time_int <= 23:
    print("The Final Time:",final_time_int)
else:
    right_final_time_int = final_time_int - 24
    print("The Final Time:",right_final_time_int)

# Test
#   What is the current time (in hours 0-23)?18
#   How many hours do you want to wait:4
#   The Final Time: 22