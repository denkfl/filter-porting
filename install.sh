#!/bin/sh

#WARNING this removes all files in /home/aadc/ADTF!
rm -r /home/aadc/ADTF

mkdir /home/aadc/ADTF

cp -a . /home/aadc/ADTF

chmod +x /home/aadc/ADTF/*.sh
chmod +x /home/aadc/ADTF/config/*.sh
rm /home/aadc/ADTF/*.bat
rm /home/aadc/ADTF/config/*.bat
#rm /home/aadc/ADTF/install.sh
cd /home/aadc/ADTF
./build_base.sh
./build_user.sh
./build_demo.sh

chown -hR aadc /home/aadc/ADTF

#install template
cp /home/aadc/ADTF/config/templates/AADC_UserConfig /opt/adtf/2.14.0/bin/templates -r
