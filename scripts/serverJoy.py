#!/usr/bin/python3
import struct
import time
import serial
import logging
from socket import socket, AF_INET, SOCK_DGRAM

mlogger = logging.getLogger('drone.micro')
logger = logging.getLogger('drone.controller')

console = logging.StreamHandler()
file_handler = logging.FileHandler(filename="drone.log")
logging.basicConfig(
    level=logging.DEBUG,
    format='%(asctime)-15s: %(name)s: %(levelname)s: %(message)s',
    handlers = [file_handler, console]
)

#status
power = 0;
water = 0;
led_status = 0;
mode_status = 0;

md_xpwma = 0; #PWMA
md_xpwmb = 0; #PWMB
md_ypwma = 0; #PWMA
md_ypwmb = 0; #PWMB

md_xain2 = 0; #AIN2
md_xain1 = 0; #AIN1
md_xbin1 = 0; #BIN1
md_xbin2 = 0; #BIN2
md_yain2 = 0; #AIN2
md_yain1 = 0; #AIN1
md_ybin1 = 0; #BIN1
md_ybin2 = 0; #BIN2

power_save = 512;

host = '192.168.3.2'
port = 5000

EVENT_FORMAT = "LhBB";
EVENT_SIZE = struct.calcsize(EVENT_FORMAT)

sock = socket(AF_INET, SOCK_DGRAM)
sock.bind((host, port))
print("recv start") 
logger.info("recv start")
while True:
  try:
    if not 'ser' in locals():
      ser = serial.Serial('/dev/ttyS0',115200,timeout=None)
    msg, address = sock.recvfrom(EVENT_SIZE)
    (ds3_time, ds3_val, ds3_type, ds3_num) = struct.unpack(EVENT_FORMAT, msg)
    change = 1;
    if (ds3_val == 0 and ds3_type == 1 and ds3_num ==3):
      mode_status = 1
    elif (ds3_val == 0 and ds3_type == 1 and ds3_num ==2):
      led_status = 1
    elif (ds3_val == 0 and ds3_type == 1 and ds3_num ==0):
      mode_status = 0
    elif (ds3_val == 0 and ds3_type == 1 and ds3_num ==1):
      led_status = 0
    elif (ds3_type == 2 and ds3_num == 0):
      #xb
      if ds3_val < 0:
        md_xbin2 = 0
        md_xbin1 = 1
      else:
        md_xbin2 = 1
        md_xbin1 = 0
      md_xpwmb = abs(int(ds3_val/power_save))
      #yb
      if ds3_val < 0:
        md_ybin2 = 1
        md_ybin1 = 0
      else:
        md_ybin2 = 0
        md_ybin1 = 1
      md_ypwmb = abs(int(ds3_val/power_save))
 
    elif (ds3_type == 2 and ds3_num ==1):
      #xb
      if ds3_val < 0:
        md_xbin2 = 0
        md_xbin1 = 1
      else:
        md_xbin2 = 1
        md_xbin1 = 0
      md_xpwmb = abs(int(ds3_val/power_save))
      #yb
      if ds3_val < 0:
        md_ybin2 = 0
        md_ybin1 = 1
      else:
        md_ybin2 = 1
        md_ybin1 = 0
      md_ypwmb = abs(int(ds3_val/power_save))
 
    elif (ds3_type == 2 and ds3_num ==2):
      #xa
      if ds3_val < 0:
        md_xain2 = 0
        md_xain1 = 1
      else:
        md_xain2 = 1
        md_xain1 = 0
      md_xpwma = abs(int(ds3_val/power_save))
      #ya
      if ds3_val < 0:
        md_yain2 = 1
        md_yain1 = 0
      else:
        md_yain2 = 0
        md_yain1 = 1
      md_ypwma = abs(int(ds3_val/power_save))

    elif (ds3_type == 2 and ds3_num ==5):
      #xa
      if ds3_val < 0:
        md_xain2 = 1
        md_xain1 = 0
      else:
        md_xain2 = 0
        md_xain1 = 1
      md_xpwma = abs(int(ds3_val/power_save))
      #ya
      if ds3_val < 0:
        md_yain2 = 1
        md_yain1 = 0
      else:
        md_yain2 = 0
        md_yain1 = 1
      md_ypwma = abs(int(ds3_val/power_save))

    else:
      change = 0;
     
    if (change == 1):
      #logger.debug("{0}, {1}, {2}, {3}".format( ds3_time, ds3_val, ds3_type, ds3_num ))
      cmd="X"+str(led_status)+"," \
        +str(mode_status)+"," \
        +str(md_xpwma)+"," \
        +str(md_xain2)+"," \
        +str(md_xain1)+"," \
        +str(md_xbin1)+"," \
        +str(md_xbin2)+"," \
        +str(md_xpwmb)+"," \
        +str(md_ypwma)+"," \
        +str(md_yain2)+"," \
        +str(md_yain1)+"," \
        +str(md_ybin1)+"," \
        +str(md_ybin2)+"," \
        +str(md_ypwmb)+",2733\n"
      logger.info(cmd)
      try:
        ser.write(cmd.encode('utf-8'))
        logger.debug("Wrote:"+cmd.encode('utf-8'))
      except:
        ser.close()
        ser = serial.Serial('/dev/ttyS0',115200,timeout=None)
    try:
      line = ser.readline()
      mlogger.info(line)
    except:
      ser.close()
      ser = serial.Serial('/dev/ttyS0',115200,timeout=None)
    #print(line)
  except:
    logger.fatal("dead...")
    ser.close()
    import traceback
    traceback.print_exc() 
    time.sleep(1)

print("dead...")
