#/bin/sh -x

cd /home/pi/underwater-drone
sudo -u pi git pull origin master

/usr/bin/python3 /home/pi/.local/bin/ds4drv --led ffff00 --daemon
exit 0

