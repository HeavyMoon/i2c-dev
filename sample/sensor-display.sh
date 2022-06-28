#!/bin/bash

TEMP=$(./i2c-dev/htu21d.sh t)
HUMI=$(./i2c-dev/htu21d.sh h)
#PRES=$(./i2c-dev/bmp180.py p)
PRES=$(echo "scale=1; $(./i2c-dev/bmp180.py p) / 100.0" | bc)

echo $(date)
echo "TEMP: $TEMP"
echo "HUMI: $HUMI"
echo "PRES: $PRES"

./i2c-dev/lcd.sh init
./i2c-dev/lcd.sh cls
./i2c-dev/lcd.sh m "$(date +"%H:%M")   ${PRES}Pa ${TEMP}C ${HUMI}%RH"


