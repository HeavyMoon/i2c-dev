#!/usr/bin/python3
#######################################
# BMP180
# -------------------------------------
# libbmp180 sample code
#
#######################################
import sys
import libbmp180 as BMP180
#import logging
#logging.basicConfig(level=logging.DEBUG)

def help():
    print('Usage: ./bmp180.py [option]')
    print(' a       Altitude [m]')
    print(' p       Pressure [Pa]')
    print(' t       Temperature [C]')
    print(' s       Sealevel Pressure [Pa]')
    print(' help    show this message')

args = sys.argv
sensor = BMP180.BMP180()

if   args[1] == 'p':
    print('{0:0.2f}'.format(sensor.read_pressure()))
elif args[1] == 't':
    print('{0:0.2f}'.format(sensor.read_temperature()))
elif args[1] == 'a':
    print('{0:0.2f}'.format(sensor.read_altitude()))
elif args[1] == 'sp':
    print('{0:0.2f}'.format(sensor.read_sealevel_pressure()))
elif args[1] == 'help':
    help()
else:
    print('invalid option')
    help()
    sys.exit(1)

