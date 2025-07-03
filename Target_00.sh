#!/bin/bash


echo Drag the capture folder into this window and then hit return
read path
echo Scan barcodes below:

[ ! -d "${path}/_TEST" ] && mkdir "${path}/_TEST"

while read x; 
do
	counter=`find "$path" -maxdepth 1 -type d ! -regex '.*/CaptureOne' ! -iregex '.*/*test' -print| wc -l` 
#	((counter--))
	if [[ "$x" -lt 20 ]]; then
		mkdir "${path}/$(printf "%03d" $((counter-1)))_${lastDir}/${lastDir}_0${x}"
		echo "$(printf "%03d" $((counter-1)))_${lastDir}/${lastDir}_0${x}"> ${path}/../../../../Scripts/nextCaptureFolder.txt
	else
		mkdir "${path}/$(printf "%03d" ${counter})_${x// /_}" "${path}/$(printf "%03d" ${counter})_${x}/${x}_00" "${path}/$(printf "%03d" ${counter})_${x}/${x}_01" "${path}/$(printf "%03d" ${counter})_${x}/${x}_02"
# Plus Swim
		#mkdir "${path}/$(printf "%03d" ${counter})_${x// /_}" "${path}/$(printf "%03d" ${counter})_${x}/${x}_10" "${path}/$(printf "%03d" ${counter})_${x}/${x}_11"
# Make next folder target
		echo "$(printf "%03d" ${counter})_${x}/${x}_02"> ${path}/../../../../Scripts/nextCaptureFolder.txt
# Mark as completed in GE Studio
		osascript -e "tell application \"Google Chrome\" to activate" -e "tell application \"Google Chrome\" to tell active tab in front window to execute javascript \"document.getElementsByClassName('srchText')[0].value = '${x}'; document.getElementsByClassName('srchButton')[0].click();\"" > /dev/null 2>&1
		sleep 5
		osascript -e "tell application \"Google Chrome\" to activate" -e "tell application \"Google Chrome\" to tell active tab in front window to execute javascript \"document.getElementsByClassName('checkmark')[0].click(); document.getElementsByClassName('Primary vertMarginSml SubChoiceHide')[0].click();\"" > /dev/null 2>&1
	lastDir=$x
	fi

done

