# Erstellt von Egmont Schreiter @ Hochschule Zittau/Görlitz
# 2016-12-09
# https://www.hszg.de/f-ei/fakultaet/mitarbeiter/egmont-schreiter.html

try:
    import serial
    pass
except:
        print("Modul serial fehlt, versuchen Sie mit 'pip install pyserial' zu reparieren")
        raise

try:
    import binascii
    pass
except:
        print("Modul binascii fehlt, versuchen Sie mit 'pip install binascii' zu reparieren")
        raise

import sys
import time

def EA_open(com_port):
    # '/dev/ttyUSB0' = GPS
    # '/dev/ttyS0'
    # '/dev/ttyS1'
    # 'COM4' # unter Win7
    with serial.Serial(com_port, 9600, timeout=1) as ser:
     ser.stopbits=1
     ser.rtscts=False
    ser.open()
    return ser


def EA__fill_zeros(out_frame):
    out_frame = out_frame + '0' * (2*25-len(out_frame))    # Frame auf 25 bytes (50Zeichen = 2/Byte in Hex-Darstellung) verlaengern
    return out_frame


def EA__checksum_org(out_frame):
    checksum = sum(ord(i) for i in str(binascii.unhexlify(out_frame)))
    out_frame = out_frame + binascii.hexlify(chr(checksum & 0xff))
    return out_frame

def EA__checksum(out_frame):
    if(sys.version_info > (3,0,0)):
        #print("Version 3") # binascii.hexlify liefert bytes()
        checksum = sum(i for i in binascii.unhexlify(out_frame)) # einzelwerte der decodierten Hex-Werte addieren
        #print(checksum)
        #print(type(checksum))
    	# print((checksum & 0xff))
        #out_frame = binascii.hexlify(chr(100))
        #crc = "{0:x}".format(checksum & 0xff) # Checksumme auf ein Byte begrenzen und als HEX ausgeben
        #print(crc)
        crc = binascii.hexlify(bytes([checksum & 255])).decode()
        #print(crc)
        out_frame = out_frame + crc
    else:
        print("Version 2") # binascii.hexlify liefert str()
        checksum = sum(ord(i) for i in str(binascii.unhexlify(out_frame)))
        out_frame = out_frame + binascii.hexlify(chr(checksum & 0xff))
    return out_frame

def EA_set_remote(remote,addr,serial_port):
	command = 0x20
	out_frame = 'aa%02x%02x'% ((addr & 0xff),(command & 0xff)) #bit 1-3
	out_frame = out_frame + '%02x' % (remote != 0)  # nur null und ungleich null unterscheiden

	out_frame = EA__fill_zeros(out_frame)
	out_frame = EA__checksum(out_frame)

	serial_port.write(binascii.unhexlify(out_frame))
	rx1 = binascii.hexlify(serial_port.read(26))
	return rx1, out_frame

def EA_set_output(output_on,addr,serial_port):
	command = 0x21
	out_frame = 'aa%02x%02x'% ((addr & 0xff),(command & 0xff)) #bit 1-3
	out_frame = out_frame + '%02x' % (output_on != 0)  # nur null und ungleich null unterscheiden

	out_frame = EA__fill_zeros(out_frame)
	out_frame = EA__checksum(out_frame)

	serial_port.write(binascii.unhexlify(out_frame))
	rx1 = binascii.hexlify(serial_port.read(26))
	return rx1, out_frame

def EA_set_max_voltage(max_voltage_limit,addr,serial_port):
	command = 0x22
	out_frame = 'aa%02x%02x'% ((addr & 0xff),(command & 0xff)) #bit 1-3

	max_voltage_hex = "%08x" % (abs(max_voltage_limit) * 1000)
	out_frame = out_frame + max_voltage_hex[6:8]
	out_frame = out_frame + max_voltage_hex[4:6]
	out_frame = out_frame + max_voltage_hex[2:4]
	out_frame = out_frame + max_voltage_hex[0:2]

	out_frame = EA__fill_zeros(out_frame)
	out_frame = EA__checksum(out_frame)

	serial_port.write(binascii.unhexlify(out_frame))
	rx1 = binascii.hexlify(serial_port.read(26))
	return rx1, out_frame

def EA_set_voltage(voltage,addr,serial_port):
	command = 0x23
	out_frame = 'aa%02x%02x'% ((addr & 0xff),(command & 0xff)) #bit 1-3

	voltage_hex = "%08x" % int((abs(voltage) * 1000))
	out_frame = out_frame + voltage_hex[6:8]
	out_frame = out_frame + voltage_hex[4:6]
	out_frame = out_frame + voltage_hex[2:4]
	out_frame = out_frame + voltage_hex[0:2]

	out_frame = EA__fill_zeros(out_frame)
	out_frame = EA__checksum(out_frame)

	serial_port.write(binascii.unhexlify(out_frame))
	rx1 = binascii.hexlify(serial_port.read(26))
	return rx1, out_frame

def EA_set_current(current,addr,serial_port):
	command = 0x24
	out_frame = 'aa%02x%02x'% ((addr & 0xff),(command & 0xff)) #bit 1-3

	current_hex = "%04x" % int((abs(current) * 1000))
	out_frame = out_frame + current_hex[2:4]
	out_frame = out_frame + current_hex[0:2]

	out_frame = EA__fill_zeros(out_frame)
	out_frame = EA__checksum(out_frame)

	serial_port.write(binascii.unhexlify(out_frame))
	rx1 = binascii.hexlify(serial_port.read(26))
	return rx1, out_frame


def EA_set_address(new_addres,addr,serial_port):
	command = 0x25
	out_frame = 'aa%02x%02x'% ((addr & 0xff),(command & 0xff)) #bit 1-3

	out_frame = out_frame + '%02x' % (new_addres & 0xff)

	out_frame = EA__fill_zeros(out_frame)
	out_frame = EA__checksum(out_frame)

	serial_port.write(binascii.unhexlify(out_frame))
	rx1 = binascii.hexlify(serial_port.read(26))
	return rx1, out_frame


def EA_get_values(addr,serial_port):
	command = 0x26
	out_frame = 'aa%02x%02x'% ((addr & 0xff),(command & 0xff)) #bit 1-3

	out_frame = EA__fill_zeros(out_frame)
	out_frame = EA__checksum(out_frame)

	serial_port.write(binascii.unhexlify(out_frame))
	rx1 = binascii.hexlify(serial_port.read(26))
	return rx1, out_frame

def EA_process_values(rx):
    rx_ascii = binascii.unhexlify(rx)
    current = (ord(binascii.unhexlify(rx[6:8]))+ord(binascii.unhexlify(rx[8:10]))*256)/1000.0
    voltage  = ord(binascii.unhexlify(rx[10:12]))
    voltage += ord(binascii.unhexlify(rx[12:14]))*256
    voltage += ord(binascii.unhexlify(rx[14:16]))*256*256
    voltage += ord(binascii.unhexlify(rx[16:18]))*256*256*256
    voltage /= 1000.0
    supplys_state = ord(binascii.unhexlify(rx[18:20]))
    max_current = (ord(binascii.unhexlify(rx[20:22]))+ord(binascii.unhexlify(rx[22:24]))*256)/1000.0

    max_voltage  = ord(binascii.unhexlify(rx[24:26]))
    max_voltage += ord(binascii.unhexlify(rx[26:28]))*256
    max_voltage += ord(binascii.unhexlify(rx[28:30]))*256*256
    max_voltage += ord(binascii.unhexlify(rx[30:32]))*256*256*256
    max_voltage /= 1000.0

    target_voltage  = ord(binascii.unhexlify(rx[32:34]))
    target_voltage += ord(binascii.unhexlify(rx[34:36]))*256
    target_voltage += ord(binascii.unhexlify(rx[36:38]))*256*256
    target_voltage += ord(binascii.unhexlify(rx[38:40]))*256*256*256
    target_voltage /= 1000.0

#    voltage
#    current
#
    print("Strom:         " + "%.3f" %current + " Ampere")
    print("Spannung:      " + "%.3f" %voltage + " Volt\n\r")
    print("State:         " + "0x%02x" %supplys_state)
    print("Strom MAX:     " + "%.3f" %max_current + " Ampere")
    print("Spannung MAX:  " + "%.3f" %max_voltage + " Volt")
    print("Spannung SOLL: " + "%.3f" %target_voltage + " Volt")

    return

# routines for calibration not implemented yet, tbd


def EA_get_informations(addr,serial_port):
	command = 0x31
	out_frame = 'aa%02x%02x'% ((addr & 0xff),(command & 0xff)) #bit 1-3

	out_frame = EA__fill_zeros(out_frame)
	out_frame = EA__checksum(out_frame)

	serial_port.write(binascii.unhexlify(out_frame))
	rx1 = binascii.hexlify(serial_port.read(26))
	return rx1, out_frame
