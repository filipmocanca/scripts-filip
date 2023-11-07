##az login
#
curr_file="serverlist"
if [ -e "$curr_file" ]; then
  # Rename the file
  mv "$curr_file" "$curr_file.$(date +%F)"
else
  echo	
  echo "File serverlist cannot be renamed"
  echo
fi
echo " List the VMs in the infrastructure"
echo "***********************************"
echo
az vm list --output table|awk '{print $1}'|tail -n +3|tee $curr_file
echo
echo " Count of VMs in the infrastructure"
echo "***********************************"
echo
az vm list --output table|awk '{print $1}'|tail -n +3|wc -l
prev_file=$(ls -lrt $curr_file.*|head -1|awk '{print $9}')

if [ -e "$prev_file" ]; then
	echo
	echo "Checking the differences"
	echo "************************"
	echo
	diff $curr_file $prev_file
else
	echo "Old file cannot be found"
	
fi

