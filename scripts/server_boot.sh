#/bin/sh -x

cd /home/pi/underwater-drone
sudo -u pi git pull origin master

sudo -u pi /usr/bin/python3 /home/pi/.local/bin/ds4drv --led 00ffff --daemon

#/home/pi/mjpg-streamer/mjpg-streamer-experimental/mjpg_streamer -o "/home/pi/mjpg-streamer/mjpg-streamer-experimental/output_file.so -f /home/pi/mjpg-streamer/mjpg-streamer-experimental/output_files -d 67 " -o "/home/pi/mjpg-streamer/mjpg-streamer-experimental/output_http.so -w /home/pi/mjpg-streamer/mjpg-streamer-experimental/www" -i "/home/pi/mjpg-streamer/mjpg-streamer-experimental/input_raspicam.so -x 1024 -y 768 -fps 15 -q 3" -b
/home/pi/mjpg-streamer/mjpg-streamer-experimental/mjpg_streamer -o "/home/pi/mjpg-streamer/mjpg-streamer-experimental/output_file.so -f /home/pi/mjpg-streamer/mjpg-streamer-experimental/output_files -d 100 " -o "/home/pi/mjpg-streamer/mjpg-streamer-experimental/output_http.so -w /home/pi/mjpg-streamer/mjpg-streamer-experimental/www" -i "/home/pi/mjpg-streamer/mjpg-streamer-experimental/input_raspicam.so -x 1024 -y 768 -fps 10 -q 7" -b

/usr/bin/gpio mode 0 alt5
exit 0
