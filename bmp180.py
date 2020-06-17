#!/usr/bin/python
import sys
import Adafruit_BMP.BMP085 as BMP085

def help():
    print('Usage: bmp180.py [option]')
    print(' a       Altitude [m]')
    print(' p       Pressure [Pa]')
    print(' t       Temperature [*C]')
    print(' sp      Sealevel Pressure [Pa]')
    print(' help    show this message')

sensor = BMP085.BMP085()
args = sys.argv

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

