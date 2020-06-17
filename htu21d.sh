#!/bin/bash
##############################
# HTU21D - Digital Relative Humidity sensor with Tempreture output
# ----------------------------
# Address
#   0x40
# ----------------------------
# Command
#   Command                         Code    Comment
#   Trigger Temperature Measurement 0xE3    Hold Master
#   Trigger Humidity Measurement    0xE5    Hold Master
#   Trigger Temperature Measurement 0xF3    No Hold Master
#   Trigger Humidity Measurement    0xF5    No Hold Master
#   Write User Register             0xE6
#   Read User Register              0xE7
#   Soft Reset                      0xFE
# ----------------------------
# Register
#   Bit     #Bits   Description                 Default
#   7,0     2       Measurement resolution      0,0
#                     Bit7 Bit0 RH     Temp
#                     0    0    12bits 14bits
#                     0    1     8bits 12bits
#                     1    0    10bits 13bits
#                     1    1    11bits 11bits
#   6       1       Status: End of Battery      0
#   3,4,5   3       Reserved                    0
#   2       1       Enable on-chip heater       0
#   1       1       Disable OTP reload          1
##############################

## LOG FUNCTION
SCRIPT=$(basename $0)
function log_msg() {
    #echo "$(date +"%F %T") $SCRIPT[$$]: $@"
    echo $@
}

## INIT
ADDRESS=0x40
CMD_mTemp_HM=0xE3
CMD_mTemp=0xF3
CMD_mHumi_HM=0xE5
CMD_mHumi=0xF5
CMD_wReg=0xE6
CMD_rReg=0xE7
CMD_reset=0xFE

## MAIN
## Bit 1 of the two LSBs indicates the measurement type (‘0’: temperature, ‘1’: humidity). Bit 0 is currently not assigned.

function mTemp (){
    RET=$(i2cget -y 1 $ADDRESS $CMD_mTemp_HM w)
    if [ $? -ne 0 ]; then
       log_msg "ERROR" "Failed measurement of Temperature"
       exit 1
    fi
    #RAW=0x683A  # TEST: result must be 24.7 C
    RAW=$(( ($RET & 0xfc00)>>8 | ($RET & 0x00ff)<<8 ))
    STAT=$(( ($RET & 0x0300)>>8 ))
    TEMP=$(echo "scale=2; -46.85+175.72*$RAW/65536" | bc )  # 65536 = 2^16
    echo $TEMP
}
function mHumi(){
    RET=$(i2cget -y 1 $ADDRESS $CMD_mHumi_HM w)
    if [ $? -ne 0 ]; then
        log_msg "ERROR" "Failed measurement of Humidity"
        exit 1
    fi  
    #RAW=0x4E85  # TEST: result must be 32.3 %RH
    RAW=$(( ($RET & 0xfc00)>>8 | ($RET & 0x00ff)<<8 ))
    STAT=$(( ($RET & 0x0300)>>8 ))
    RH=$(echo "scale=2; -6+125*$RAW/65536" | bc )   # 65536 = 2^16
    echo $RH
}
function mPres(){
    A=8.1332
    B=1762.39
    C=235.66
    TEMP=$(mTemp)
    #PP=$(echo "scale=1; 10^($A-$B/($TEMP+$C))" | bc)
    #echo $PP
    log_msg "ERROR" "not support"
    exit 1
}
function mdTemp(){
    log_msg "ERROR" "not support"
    exit 1
}
function help(){
    echo "Usage: $SCRIPT [OPTION]"
    echo " t        measure temperature"
    echo " h        measure relative humidity"
    #echo " p        measure partial pressire"
    #echo " d        measure dew point temperature"
    echo " help     show this message"
    #echo " reset    software reset"
}


case $1 in
    t) mTemp;;
    h) mHumi;;
    p) mPres;;
    d) mdTemp;;
    help) help;;
    *) log_msg "ERROR" "invalid option"
       help;;
esac        

