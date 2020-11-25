#!/usr/bin/python3
import struct
import time
from socket import socket, AF_INET, SOCK_DGRAM

host = ''
port = 5000
address = "192.168.3.2"
sock = socket(AF_INET, SOCK_DGRAM)
device_path = "/dev/input/js0"

event_format = "LhBB";
event_size = struct.calcsize(event_format)

while True:
  try:
    with open(device_path, "rb") as device:
      print("input connect...")
      while True:
        event = device.read(event_size)
        if event:
          sock.sendto(event, (address, port))
  except:
    print("dead...")
    import traceback
    traceback.print_exc()
    time.sleep(5)
sock.close()


