echo "RaspberryPi post configuration"
echo
echo "*****************"
echo "NTP Configuration"
echo "*****************"
sed -i 's\NTP=/c\NTP=time.cargolux.local time.google.com time1.google.com time2.google.com time3.google.com time4.google.com\g' /etc/systemd/timesyncd.conf
echo "*****************"
echo "Enable SSH"
echo "*****************"
sed -i '/Port /c\Port 9003' /etc/ssh/sshd_config
sed -i 's\PermitRootLogin=/c\PermitRootLogin=no\g'
echo "*******************"
echo "Reset ROOT password"
echo "*******************"
passwd
echo "************************"
echo "Create cargolux-mcc user"
echo "************************"
useradd --groups sudo -m cargolux-mcc
passwd cargolux-mcc
passwd --lock pi
echo "***************"
echo "Set auto login"
echo "***************"
echo "type cargolux-mcc"
echo " Choose 1.System Options>S5 Book/Auto Login> B4 Desktop Autologin"
raspi-config
read -p "Press enter to continue"
echo "********"
echo "Security"
echo "********"
apt-get update
apt-get install fail2ban
echo "****************************"
echo "Change the port in jail.conf"
echo "****************************"
number=$(grep -n -A 8 "^\[sshd" /etc/fail2ban/jail.conf|grep -n port|cut -d ":" -f2|cut -d "-" -f1)
awk -v line="$number" 'NR == line { $0 ="port    = 9003" } 1' /etc/fail2ban/jail.conf >temp && mv temp /etc/fail2ban/jail.conf
echo "************"
echo "MCC Handover"
echo "************"
cd /home/cargolux-mcc/mcc-handover
echo "#!/bin/bash" >>launch-mcc.sh
echo "		 " >>launch-mcc.sh
echo "URL=https://mcc-handover.cargolux.com/hangar/pitstop" >>launch-mcc.sh
echo "		 " >>launch-mcc.sh
echo "/usr/bin/chromium-browser --kiosk --app=$URL --noerrdialogs --disable-session-crashed-bubble --disable-infobars --check-for-update-interval=604800 --disable-pinch --enable-offline-auto-reload" >>launch-mcc.sh
echo "		 " >>launch-mcc.sh
echo "		 " >>launch-mcc.sh
echo "URL=https://mcc-handover.cargolux.com/hangar/pitstop" >>launch-mcc.sh
echo "		 " >>launch-mcc.sh
echo "/usr/bin/chromium-browser --kiosk --app=$URL --noerrdialogs --disable-session-crashed-bubble --disable-infobars --check-for-update-interval=604800 --disable-pinch --enable-offline-auto-reload" >>launch-mcc.sh
chmod 755 launch-mcc.sh
chown cargolux-mcc:cargolux-mcc launch-mcc.sh 
echo "*****************"
echo "Auto-Start script"
echo "*****************"
cd /etc/xdg/lxsession/LXDE-pi
echo "@xset s off" >>autostart
echo "@xset -dpms" >>autostart
echo "@xset s noblank" >>autostart
echo "               " >>autostart
echo "/home/cargolux-mcc/mcc-handover/launch-mcc.sh" >>autostart
echo "**********************"
echo "Reinstall certificates"
echo "**********************"
apt-get install --reinstall ca-certificate
echo "***************"
echo "Change Hostname"
echo "***************"
echo "Enter the hostname:"
read hname
echo $hname>/etc/hostname
echo "127.0.1.1 $hname">>/etc/hosts
grep $hname /etc/hosts
RESULT=$?
if [ $RESULT -eq 0 ]; then
  echo "Rebooting the system"
else
  exit
fi
