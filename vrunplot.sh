#!/bin/bash

#Variables
SSDIR=/opt/Signal-Server
PLOTDIR=~/plots

#Functions
check_plotdir() {
        if [ ! -d "$PLOTDIR" ]; then
                mkdir $PLOTDIR
                echo 'Plot Directory Created'
                echo
        fi
}

clean_plotdir() {
        read -p "Clean plot directory before this run? (All .ppm, .png and .kmz files will be deleted) "
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
		if [ ! -f "$PLOTDIR/*.kmz" ]; then
			rm -fr $PLOTDIR/*.kmz
                fi
		if [ ! -f "$PLOTDIR/*.ppm" ]; then
                	rm -fr $PLOTDIR/*.ppm
		fi
                if [ ! -f "$PLOTDIR/*.png" ]; then
			rm -fr $PLOTDIR/*.png
                fi
		echo
                echo 'Plot Directory Cleaned'
                echo
        fi
}

get_input() {
	echo Latitude?; read lat; echo
	echo Longitude?; read lon; echo
	echo Height as AGL?; read hei; echo
	echo Frequency?; read freq; echo
	echo ERP?; read erp; echo
}

run_service() {
	echo Running Service Plot....
	echo
	runsig.sh -lat $lat -lon $lon -txh $hei -f $freq -erp $erp -rt 37 -rel 50 -res 600 -R 250 -color /opt/Signal-Server/color/blue.scf -o $freq-service | genkmz.sh 
	echo
}

run_interference() {
	echo Running Interference Plot....
	echo
	runsig.sh -lat $lat -lon $lon -txh $hei -f $freq -erp $erp -rt 19 -rel 10 -res 600 -R 250 -color /opt/Signal-Server/color/green.scf -o $freq-interference | genkmz.sh
	echo
}

run_adjacent () {
	echo Running Adjacent Plot....
	echo
	runsig.sh -lat $lat -lon $lon -txh $hei -f $freq -erp $erp -rt 43 -rel 10 -res 600 -R 250 -color /opt/Signal-Server/color/magenta.scf -o $freq-adjacent | genkmz.sh
	echo
}

#Main
clear
check_plotdir
clean_plotdir
#get_input
#cd $PLOTDIR
#run_service
#run_interference
#run_adjacent
