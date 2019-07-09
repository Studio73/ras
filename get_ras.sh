#!/bin/bash

raspi-config nonint do_change_locale es_ES.UTF-8
raspi-config nonint do_configure_keyboard es
raspi-config nonint do_ssh 0
raspi-config nonint do_spi 0
raspi-config nonint do_i2c 0
passwd pi
apt-get update && apt-get upgrade -y
apt-get install -y git python3-pip libjpeg-dev zlib1g-dev supervisor libtiff5 libopenjp2-7
git clone --depth=1 -b release https://github.com/Studio73/ras.git /home/pi/ras
pip3 install -r /home/pi/ras/requirements.txt
# FIX: module 'spi' has no attribute 'openspi'
pip3 install git+git://github.com/lthiery/SPI-Py.git@8cce26b9ee6e69eb041e9d5665944b88688fca68
# WiFi hostpot
bash <(curl -L https://github.com/balena-io/wifi-connect/raw/master/scripts/raspbian-install.sh)
curl -SLo /usr/local/share/wifi-connect/ui/img/logo.svg https://upload.wikimedia.org/wikipedia/commons/c/ca/1x1.png
cp /home/pi/ras/dicts/credentials.json.sample /home/pi/ras/dicts/credentials.json
cat <<EOF > /etc/supervisor/conf.d/ras.conf
[program:ras]
directory=/home/pi/ras
command=python3 launcher.py
autostart=true
autorestart=true
user=root
EOF
supervisorctl reread && supervisorctl update