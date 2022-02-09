#!/usr/bin/python3
#######################################
# BMP180 Library
# -------------------------------------
#
#
#######################################
import smbus
import time
import logging

#logging.basicConfig(level=logging.DEBUG)

BMP180_I2CADDR = 0x77

# Over Sampling Setting
BMP180_ULTRALOW  = 0
BMP180_STANDARD  = 1
BMP180_HIGH      = 2
BMP180_ULTRAHIGH = 3

# Calibration Coefficients Regs
BMP180_CAL_AC1 = 0xAA # INT16 
BMP180_CAL_AC2 = 0xAC # INT16 
BMP180_CAL_AC3 = 0xAE # INT16 
BMP180_CAL_AC4 = 0xB0 # UINT16 
BMP180_CAL_AC5 = 0xB2 # UINT16 
BMP180_CAL_AC6 = 0xB4 # UINT16 
BMP180_CAL_B1  = 0xB6 # INT16 
BMP180_CAL_B2  = 0xB8 # INT16 
BMP180_CAL_MB  = 0xBA # INT16 
BMP180_CAL_MC  = 0xBC # INT16 
BMP180_CAL_MD  = 0xBE # INT16 

# Control Regs
BMP180_CONTROL     = 0xF4
BMP180_DATA        = 0xF6
BMP180_CMD_TEMP    = 0x2E
BMP180_CMD_PRES    = 0x34


class BMP180(object):
    def __init__(self, oss=BMP180_STANDARD, address=BMP180_I2CADDR):
        self._logger = logging.getLogger('BMP180')
        self._logger.debug('init')
        if oss not in [BMP180_ULTRALOW, BMP180_STANDARD, BMP180_HIGH, BMP180_ULTRAHIGH]:
            raise ValueError('Unexpected oss value {0}.'.format(oss))
        self._oss = oss
        self._i2c = smbus.SMBus(1)
        self._load_calibration()

    def read_int16(self, reg):
        data = self._i2c.read_i2c_block_data(BMP180_I2CADDR,reg,2)
        ret  = (data[0] << 8 | data[1]) & 0xFFFF
        if ret > 32767:
            ret -= 65536
        return ret

    def read_uint16(self, reg):
        data = self._i2c.read_i2c_block_data(BMP180_I2CADDR,reg,2)
        ret = (data[0] << 8 | data[1]) & 0xFFFF
        return ret

    def read_uint24(self, reg):
        data = self._i2c.read_i2c_block_data(BMP180_I2CADDR,reg,3)
        self._logger.debug('uint24 data:%d,%d,%d',data[0],data[1],data[2])
        ret  = data[0] << 16 | data[1] << 8 | data[2]
        return ret

    def write_data(self, reg, data):
        self._i2c.write_byte_data(BMP180_I2CADDR, reg, data)

    def write_block_data(self, reg, data):
        self._i2c.write_block_data(BMP180_I2CADDR, reg, data)

    def _load_calibration(self):
        self._AC1   = self.read_int16(BMP180_CAL_AC1)
        self._AC2   = self.read_int16(BMP180_CAL_AC2)
        self._AC3   = self.read_int16(BMP180_CAL_AC3)
        self._AC4   = self.read_uint16(BMP180_CAL_AC4)
        self._AC5   = self.read_uint16(BMP180_CAL_AC5)
        self._AC6   = self.read_uint16(BMP180_CAL_AC6)
        self._B1    = self.read_int16(BMP180_CAL_B1)
        self._B2    = self.read_int16(BMP180_CAL_B2)
        self._MB    = self.read_int16(BMP180_CAL_MB)
        self._MC    = self.read_int16(BMP180_CAL_MC)
        self._MD    = self.read_int16(BMP180_CAL_MD)

        self._logger.debug('AC1:%d',self._AC1)
        self._logger.debug('AC2:%d',self._AC2)
        self._logger.debug('AC3:%d',self._AC3)
        self._logger.debug('AC4:%d',self._AC4)
        self._logger.debug('AC5:%d',self._AC5)
        self._logger.debug('AC6:%d',self._AC6)
        self._logger.debug('B1 :%d',self._B1 )
        self._logger.debug('B2 :%d',self._B2 )
        self._logger.debug('MB :%d',self._MB )
        self._logger.debug('MC :%d',self._MC )
        self._logger.debug('MD :%d',self._MD )

    def _load_calibration_debug(self):
        self._AC1   =    408
        self._AC2   =    -72
        self._AC3   = -14383
        self._AC4   =  32741
        self._AC5   =  32757
        self._AC6   =  23153
        self._B1    =   6190
        self._B2    =      4
        self._MB    = -32767
        self._MC    =  -8711
        self._MD    =   2868

        self._logger.debug('AC1:%d',self._AC1)
        self._logger.debug('AC2:%d',self._AC2)
        self._logger.debug('AC3:%d',self._AC3)
        self._logger.debug('AC4:%d',self._AC4)
        self._logger.debug('AC5:%d',self._AC5)
        self._logger.debug('AC6:%d',self._AC6)
        self._logger.debug('B1 :%d',self._B1 )
        self._logger.debug('B2 :%d',self._B2 )
        self._logger.debug('MB :%d',self._MB )
        self._logger.debug('MC :%d',self._MC )
        self._logger.debug('MD :%d',self._MD )

    def read_raw_temperature(self):
        self.write_data(BMP180_CONTROL, BMP180_CMD_TEMP)
        time.sleep(0.005)
        raw = self.read_int16(BMP180_DATA)

        self._logger.debug('raw temp:%d',raw)

        return raw

    def read_raw_pressure(self):
        self.write_data(BMP180_CONTROL, BMP180_CMD_PRES + (self._oss << 6))
        if self._oss == BMP180_ULTRALOW:
            time.sleep(0.005)
        elif self._oss == BMP180_HIGH:
            time.sleep(0.014)
        elif self._oss == BMP180_ULTRAHIGH:
            time.sleep(0.026)
        else:
            time.sleep(0.008)
        raw = (self.read_uint24(BMP180_DATA)) >> ( 8 - self._oss)

        self._logger.debug('raw pres:%d',raw)

        return raw

    def read_temperature(self):
        UT = self.read_raw_temperature()
        X1 = ((UT - self._AC6) * self._AC5) >> 15
        X2 = (self._MC << 11) // (X1 + self._MD)
        B5 = X1 + X2
        temp = ((B5 + 8) >> 4) / 10.0

        self._logger.debug('UT:%d',UT)
        self._logger.debug('X1:%d',X1)
        self._logger.debug('X2:%d',X2)
        self._logger.debug('B5:%d',B5)
        self._logger.debug('temp:%d',temp)

        return temp

    def read_pressure(self):
        UT = self.read_raw_temperature()
        UP = self.read_raw_pressure()
        self._logger.debug('UT:%d',UT)
        self._logger.debug('UP:%d',UP)

        # calc B5, B6
        X1 = ((UT - self._AC6) * self._AC5) >> 15
        X2 = (self._MC << 11) // (X1 + self._MD)
        B5 = X1 + X2
        B6 = B5 - 4000
        self._logger.debug('B5:%d',B5)
        self._logger.debug('B6:%d',B6)

        # calc B3
        X1 = (self._B2 * (B6 * B6) >> 12) >> 11
        X2 = (self._AC2 * B6) >> 11
        X3 = X1 + X2
        B3 = (((self._AC1 * 4 + X3) << self._oss ) + 2 ) // 4
        self._logger.debug('B3:%d',B3)
        
        X1 = (self._AC3 * B6) >> 13
        X2 = (self._B1 * ((B6 * B6) >> 12)) >> 16
        X3 = ((X1 + X2) + 2) >> 2
        B4 = (self._AC4 * (X3 + 32768)) >> 15
        B7 = (UP -B3) * (50000 >> self._oss)
        self._logger.debug('B4:%d',B4)
        self._logger.debug('B7:%d',B7)

        if B7 < 0x80000000:
            p = (B7 * 2) // B4
        else:
            p = (B7 // B4) * 2
        X1 = (p >> 8) * (p >> 8)
        X1 = (X1 * 3038) >> 16
        X2 = (-7357 * p) >> 16
        p  = (p + ((X1 + X2 + 3791) >> 4))
        return p
    
    def read_altitude(self, sealevel_pa=101325.0):
        pres = self.read_pressure()
        alti = 4433.0 * (1.0 - pow(pres / sealevel_pa, (1.0/5.255)))
        self._logger.debug('altitude:%d',alti)
        return alti

    def read_sealevel_pressure(self, altitude_m=0.0):
        pres = self.read_pressure()
        p0 = pres / pow(1.0 -altitude_m/44330.0, 5.255)
        self._logger.debug('p0:%d',p0)
        return p0
