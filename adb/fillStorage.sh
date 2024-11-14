#!/bin/bash

# This script fills the connect device storage by creating and copying over a dummy file to Downloads directory
# You can provide an argument mentioning how much free storage you want, 50MB is the default value


#Check if there is any device connected
devicesList=$(adb devices | wc -l)
numberOfDevices=$(( devicesList-2 ))
if [ $numberOfDevices -ne 1 ]; then
	echo "More than one or no device connected"
	echo "Please make sure only one device is connected"
	exit 1
fi

exit 1; 


availableStorage=$(adb shell df /data | awk  'NR==2 {print $4}')


echo "Abvailable Storage: $availableStorage"
leaveStorage=$1


if [ -z "$leaveStorage" ]; then
	echo "No leaveStorage provided, using 50mb as default"
	leaveStorage=50
fi

leaveStorage=$((leaveStorage*1024))
#echo "LEAVE STORAGE: $leaveStorage"
#exit 1;

random_number=$RANDOM

fileName="dummyFile_${random_number}_.bin"

if [ -f "$fileName" ]; then
	echo "Deleting exisitng File"
	rm "$fileName"
fi


#Calculating File to be created
newFileSize=$((availableStorage-leaveStorage))

echo "NewFileSize = $newFileSize"

dd if=/dev/zero of=$fileName bs=1K count=$newFileSize 

adb push $fileName /sdcard/Download/

echo "File $fileName of size $newFileSize is pushed to /sdcard/Download/"

#deleting file from current system so it does not bloat
rm "$fileName"
