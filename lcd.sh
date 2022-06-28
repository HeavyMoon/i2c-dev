#!/bin/bash
##############################
# 16x2 I2C LCD Module
##############################

## LOG FUNCTION
SCRIPT=$(basename $0)
function log_msg() {
    #echo "$(date +"%F %T") $SCRIPT[$$]: $@"
    echo $@
}

## INIT
ADDRESS=0x3A
CMD_FunctionSet=0x20
CMD_H0_ClearDisplay=0x01
CMD_H0_ReturnHome=0x02
CMD_H0_DisplayControl=0x10
CMD_H0_CDShift=0x10
CMD_H0_DdramAd=0x80

# LCD Control
function lcd_clear(){
    i2cset -y 1 $ADDRESS 0x00 $CMD_H0_ClearDisplay i                # CO=0 RS=0
}
function lcd_cursor(){
    if [ 0 -le $1 ] && [ $1 -le 32 ]; then
        i2cset -y 1 $ADDRESS 0x00 $((CMD_H0_DdramAd + $1)) i        # CO=0 RS=0
    fi
}
function lcd_init(){
    i2cset -y 1 $ADDRESS 0x00 $((CMD_FunctionSet | 0x10)) i         # CO=0 RS=0, data length 8bit + 1-line by 32 display + MUX 1:18
    lcd_clear
    lcd_cursor 0
    i2cset -y 1 $ADDRESS 0x00 $((CMD_H0_DisplayControl | 0x04)) i   # CO=0 RS=0, display on + cursor off + cursor blink off
    i2cset -y 1 $ADDRESS 0x00 0x0C i    # display on
}
function lcd_char(){
    echo "$1" | fold -w 1 | while read c
    do
        case "$c" in
            ' ') i2cset -y 1 $ADDRESS 0x40 0xA0 i;;
            '!') i2cset -y 1 $ADDRESS 0x40 0xA1 i;;
            '"') i2cset -y 1 $ADDRESS 0x40 0xA2 i;;
            '#') i2cset -y 1 $ADDRESS 0x40 0xA3 i;;

            '%') i2cset -y 1 $ADDRESS 0x40 0xA5 i;;
            '&') i2cset -y 1 $ADDRESS 0x40 0xA6 i;;
            "'") i2cset -y 1 $ADDRESS 0x40 0xA7 i;;
            '(') i2cset -y 1 $ADDRESS 0x40 0xA8 i;;
            ')') i2cset -y 1 $ADDRESS 0x40 0xA9 i;;
            '*') i2cset -y 1 $ADDRESS 0x40 0xAA i;;
            '+') i2cset -y 1 $ADDRESS 0x40 0xAB i;;
            ',') i2cset -y 1 $ADDRESS 0x40 0xAC i;;
            '-') i2cset -y 1 $ADDRESS 0x40 0xAD i;;
            '.') i2cset -y 1 $ADDRESS 0x40 0xAE i;;
            '/') i2cset -y 1 $ADDRESS 0x40 0xAF i;;
            '0') i2cset -y 1 $ADDRESS 0x40 0xB0 i;;
            '1') i2cset -y 1 $ADDRESS 0x40 0xB1 i;;
            '2') i2cset -y 1 $ADDRESS 0x40 0xB2 i;;
            '3') i2cset -y 1 $ADDRESS 0x40 0xB3 i;;
            '4') i2cset -y 1 $ADDRESS 0x40 0xB4 i;;
            '5') i2cset -y 1 $ADDRESS 0x40 0xB5 i;;
            '6') i2cset -y 1 $ADDRESS 0x40 0xB6 i;;
            '7') i2cset -y 1 $ADDRESS 0x40 0xB7 i;;
            '8') i2cset -y 1 $ADDRESS 0x40 0xB8 i;;
            '9') i2cset -y 1 $ADDRESS 0x40 0xB9 i;;
            ":") i2cset -y 1 $ADDRESS 0x40 0xBA i;;
            ";") i2cset -y 1 $ADDRESS 0x40 0xBB i;;
            "<") i2cset -y 1 $ADDRESS 0x40 0xBC i;;
            "=") i2cset -y 1 $ADDRESS 0x40 0xBD i;;
            ">") i2cset -y 1 $ADDRESS 0x40 0xBE i;;
            "?") i2cset -y 1 $ADDRESS 0x40 0xBF i;;

            'A') i2cset -y 1 $ADDRESS 0x40 0xC1 i;;
            'B') i2cset -y 1 $ADDRESS 0x40 0xC2 i;;
            'C') i2cset -y 1 $ADDRESS 0x40 0xC3 i;;
            'D') i2cset -y 1 $ADDRESS 0x40 0xC4 i;;
            'E') i2cset -y 1 $ADDRESS 0x40 0xC5 i;;
            'F') i2cset -y 1 $ADDRESS 0x40 0xC6 i;;
            'G') i2cset -y 1 $ADDRESS 0x40 0xC7 i;;
            'H') i2cset -y 1 $ADDRESS 0x40 0xC8 i;;
            'I') i2cset -y 1 $ADDRESS 0x40 0xC9 i;;
            'J') i2cset -y 1 $ADDRESS 0x40 0xCA i;;
            'K') i2cset -y 1 $ADDRESS 0x40 0xCB i;;
            'L') i2cset -y 1 $ADDRESS 0x40 0xCC i;;
            'M') i2cset -y 1 $ADDRESS 0x40 0xCD i;;
            'N') i2cset -y 1 $ADDRESS 0x40 0xCE i;;
            'O') i2cset -y 1 $ADDRESS 0x40 0xCF i;;
            'P') i2cset -y 1 $ADDRESS 0x40 0xD0 i;;
            'Q') i2cset -y 1 $ADDRESS 0x40 0xD1 i;;
            'R') i2cset -y 1 $ADDRESS 0x40 0xD2 i;;
            'S') i2cset -y 1 $ADDRESS 0x40 0xD3 i;;
            'T') i2cset -y 1 $ADDRESS 0x40 0xD4 i;;
            'U') i2cset -y 1 $ADDRESS 0x40 0xD5 i;;
            'V') i2cset -y 1 $ADDRESS 0x40 0xD6 i;;
            'W') i2cset -y 1 $ADDRESS 0x40 0xD7 i;;
            'X') i2cset -y 1 $ADDRESS 0x40 0xD8 i;;
            'Y') i2cset -y 1 $ADDRESS 0x40 0xD9 i;;
            'Z') i2cset -y 1 $ADDRESS 0x40 0xDA i;;

            'a') i2cset -y 1 $ADDRESS 0x40 0xE1 i;;
            'b') i2cset -y 1 $ADDRESS 0x40 0xE2 i;;
            'c') i2cset -y 1 $ADDRESS 0x40 0xE3 i;;
            'd') i2cset -y 1 $ADDRESS 0x40 0xE4 i;;
            'e') i2cset -y 1 $ADDRESS 0x40 0xE5 i;;
            'f') i2cset -y 1 $ADDRESS 0x40 0xE6 i;;
            'g') i2cset -y 1 $ADDRESS 0x40 0xE7 i;;
            'h') i2cset -y 1 $ADDRESS 0x40 0xE8 i;;
            'i') i2cset -y 1 $ADDRESS 0x40 0xE9 i;;
            'j') i2cset -y 1 $ADDRESS 0x40 0xEA i;;
            'k') i2cset -y 1 $ADDRESS 0x40 0xEB i;;
            'l') i2cset -y 1 $ADDRESS 0x40 0xEC i;;
            'm') i2cset -y 1 $ADDRESS 0x40 0xED i;;
            'n') i2cset -y 1 $ADDRESS 0x40 0xEE i;;
            'o') i2cset -y 1 $ADDRESS 0x40 0xEF i;;
            'p') i2cset -y 1 $ADDRESS 0x40 0xF0 i;;
            'q') i2cset -y 1 $ADDRESS 0x40 0xF1 i;;
            'r') i2cset -y 1 $ADDRESS 0x40 0xF2 i;;
            's') i2cset -y 1 $ADDRESS 0x40 0xF3 i;;
            't') i2cset -y 1 $ADDRESS 0x40 0xF4 i;;
            'u') i2cset -y 1 $ADDRESS 0x40 0xF5 i;;
            'v') i2cset -y 1 $ADDRESS 0x40 0xF6 i;;
            'w') i2cset -y 1 $ADDRESS 0x40 0xF7 i;;
            'x') i2cset -y 1 $ADDRESS 0x40 0xF8 i;;
            'y') i2cset -y 1 $ADDRESS 0x40 0xF9 i;;
            'z') i2cset -y 1 $ADDRESS 0x40 0xFA i;;

            *)   i2cset -y 1 $ADDRESS 0x40 0xA0 i;; # BLANK 
        esac
    done
}
function help(){
    echo "Usage: $SCRIPT [OPTION]"
    echo " init             initialize LCD"
    echo ' m "message"      display message'
    echo " c NUMBER         move cursor to NUMBER (1-line by 32 display)"
    echo " cls              clear screen and return home"
}

## MAIN
case $1 in
    'init') lcd_init;;
    'm')    lcd_char "$2";;
    'c')    lcd_cursor "$2";;
    'cls')  lcd_clear;;
    'help') help;;
    *)      echo 'invalid option'
            help;;
esac

