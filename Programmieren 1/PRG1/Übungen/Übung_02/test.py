import datetime
x = int(input("Gaben Sie eine Zahl: "))
time_now= datetime.datetime.now().time()
time_now= str(time_now)
print("Die Zeit ist: ",time_now)
time_now= time_now.split(":")
hour = int(time_now[0])
momints = int(time_now[1])
seconds = int(time_now[2].split(".")[0])
seconds = seconds + hour * 3600 + momints * 60
x = x + seconds
x = x + 7
x = x * 5
print(x)