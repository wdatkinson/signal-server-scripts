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
        read -p "Clean plot directory (all .ppm, .png and .kmz files will be deleted) before this run? "
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		rm -fr $PLOTDIR/*.kmz
        	rm -fr $PLOTDIR/*.ppm
		rm -fr $PLOTDIR/*.png
		echo
                echo 'Plot Directory Cleaned'
                echo
        fi
}

vhf_uhf() {
	read -p "Run a VHF or UHF plot? (V/U) "
	if [[ $REPLY =~ ^[Vv]$ ]]; then
		SERVICE_RT=37
		INTERFERENCE_RT=19
		ADJACENT_RT=43
		echo
	else
		SERVICE_RT=39
                INTERFERENCE_RT=21
                ADJACENT_RT=41
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
	runsig.sh -lat $lat -lon $lon -txh $hei -f $freq -erp $erp -rt $SERVICE_RT -rel 50 -res 600 -R 250 -color /opt/Signal-Server/color/blue.scf -o $freq-service | genkmz.sh 
	echo
}

run_interference() {
	echo Running Interference Plot....
	echo
	runsig.sh -lat $lat -lon $lon -txh $hei -f $freq -erp $erp -rt $INTERFERENCE_RT -rel 10 -res 600 -R 250 -color /opt/Signal-Server/color/green.scf -o $freq-interference | genkmz.sh
	echo
}

run_adjacent () {
	echo Running Adjacent Plot....
	echo
	runsig.sh -lat $lat -lon $lon -txh $hei -f $freq -erp $erp -rt $ADJACENT_RT -rel 10 -res 600 -R 250 -color /opt/Signal-Server/color/magenta.scf -o $freq-adjacent | genkmz.sh
	echo
}

post_plot_clean () {
	echo Removing *.ppm and *.png files from plot directory.  These files currently serve no purpose.
	echo
	rm -fr $PLOTDIR/*.ppm
        rm -fr $PLOTDIR/*.png
	echo
}

#Main
clear
check_plotdir
clean_plotdir
vhf_uhf
get_input
cd $PLOTDIR
run_service
run_interference
run_adjacent
post_plot_clean
