from EA_Netzteil import *

ser = EA_open('Com4')
#Oszi
# out_frame = '0 \r'


rx,tx = EA_set_remote(1,0,ser)
rx,tx = EA_set_max_voltage(26,0,ser)
rx,tx = EA_set_output(1,0,ser)
rx,tx = EA_set_voltage(2.1,0,ser)
rx,tx = EA_set_current(0.6,0,ser)
time.sleep(1)
rx,tx = EA_set_address(1,0,ser)
rx,tx = EA_set_voltage(4.1,0,ser)
rx,tx = EA_set_voltage(8.1,1,ser)
rx,tx = EA_set_address(0,1,ser)

rx,tx = EA_get_informations(0,ser)
print("Infos:  " + str(rx))
time.sleep(1)
rx,tx = EA_get_values(0,ser)
print("Values: " + str(rx))
EA_process_values(rx) # print values

# rx,tx = EA_set_output(0,0,ser)
rx,tx = EA_set_remote(0,0,ser)

print(rx), print(tx)
#ser.close()
