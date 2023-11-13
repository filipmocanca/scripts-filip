echo "Enter mac:"
read mac
my_addr=$(ifconfig eth0|grep ether|awk {print'$2'})
checked_mac=$(grep -i "$mac" serverlist|awk {print'$2'}|tr '[:upper:]' '[:lower:]')
checked_server=$(grep -i "$mac" serverlist|awk {print'$1'}|tr '[:upper:]' '[:lower:]')
if [ "$my_addr" == "$checked_mac" ]
then
  echo $checked_server
else
  echo "not match"

fi
