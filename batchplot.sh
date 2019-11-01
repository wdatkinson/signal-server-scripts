#!/bin/bash

#############################################################################################
# batchplot.sh - Signal-Server non-privleged batch run script - v1.2 - Bill Atkinson (NF9K) #
#############################################################################################

#Variables
VERSION=1.2
SSDIR=/opt/Signal-Server
PLOTDIR=~/plots
INFILE=~/source.csv
TMPFILE=~/source.tmp

#Functions

timestamp() {
	date +"%T"
}

check_plotdir() {
        if [ ! -d "$PLOTDIR" ]; then
                mkdir $PLOTDIR
                echo Plot Directory Created
                echo
        fi
}

clean_plotdir() {
	rm -fr $PLOTDIR/*.kmz
       	rm -fr $PLOTDIR/*.ppm
	rm -fr $PLOTDIR/*.png
	echo
        echo Plot Directory Cleaned
        echo
}

validate_infile() {
	tr -cd "[:print:]\n" < $INFILE > $TMPFILE
	rm $INFILE
	mv $TMPFILE $INFILE
	echo
	echo Source File Contents Validated
	echo
}

batch_run() {
	OLDIFS=$IFS
        IFS=,
	[ ! -f $INFILE ] && { echo "$INFILE file not found.  Please create it as outlined in the README.md file."; echo; exit 99; }
	while read BAND LAT LON HEI FREQ ERP OUTFILEPREFIX
	do
		if [[ $BAND =~ ^[Vv]$ ]]; then
                	SERVICE_RT=37
                	INTERFERENCE_RT=19
                	ADJACENT_RT=43
                	echo
			echo Running $OUTFILEPREFIX-$FREQ Service Plot "(1 of 3)" beginning at "$(timestamp)" system time.  Please allow ~3.5 minutes....
        		runsig.sh -lat $LAT -lon $LON -txh $HEI -f $FREQ -erp $ERP -rt $SERVICE_RT -rel 50 -res 600 -R 250 -color /opt/Signal-Server/color/blue.scf -o $OUTFILEPREFIX-$FREQ-service | genkmz.sh > /dev/null 2>&1
        		echo
			echo
			echo Running $OUTFILEPREFIX-$FREQ Interference Plot "(2 of 3)" beginning at "$(timestamp)" system time.  Please allow ~3.5 minutes....
        		runsig.sh -lat $LAT -lon $LON -txh $HEI -f $FREQ -erp $ERP -rt $INTERFERENCE_RT -rel 10 -res 600 -R 250 -color /opt/Signal-Server/color/green.scf -o $OUTFILEPREFIX-$FREQ-interference | genkmz.sh > /dev/null 2>&1
        		echo			
			echo
			echo Running $OUTFILEPREFIX-$FREQ Adjacent Plot "(3 of 3)" beginning at "$(timestamp)" system time.  Please allow ~3.5 minutes....
        		runsig.sh -lat $LAT -lon $LON -txh $HEI -f $FREQ -erp $ERP -rt $ADJACENT_RT -rel 10 -res 600 -R 250 -color /opt/Signal-Server/color/magenta.scf -o $OUTFILEPREFIX-$FREQ-adjacent | genkmz.sh > /dev/null 2>&1
			echo       
 		else
                	SERVICE_RT=39
                	INTERFERENCE_RT=21
                	ADJACENT_RT=41
			echo
			echo Running $OUTFILEPREFIX-$FREQ Service Plot "(1 of 3)" beginning at "$(timestamp)" system time.  Please allow ~3.5 minutes....
                        runsig.sh -lat $LAT -lon $LON -txh $HEI -f $FREQ -erp $ERP -rt $SERVICE_RT -rel 50 -res 600 -R 250 -color /opt/Signal-Server/color/blue.scf -o $OUTFILEPREFIX-$FREQ-service | genkmz.sh > /dev/null 2>&1
                        echo
			echo
                        echo Running $OUTFILEPREFIX-$FREQ Interference Plot "(2 of 3)" beginning at "$(timestamp)" system time.  Please allow ~3.5 minutes....
                        runsig.sh -lat $LAT -lon $LON -txh $HEI -f $FREQ -erp $ERP -rt $INTERFERENCE_RT -rel 10 -res 600 -R 250 -color /opt/Signal-Server/color/green.scf -o $OUTFILEPREFIX-$FREQ-interference | genkmz.sh > /dev/null 2>&1
                        echo
			echo                    
                        echo Running $OUTFILEPREFIX-$FREQ Adjacent Plot beginning "(3 of 3)" at "$(timestamp)" system time.  Please allow ~3.5 minutes....
                        runsig.sh -lat $LAT -lon $LON -txh $HEI -f $FREQ -erp $ERP -rt $ADJACENT_RT -rel 10 -res 600 -R 250 -color /opt/Signal-Server/color/magenta.scf -o $OUTFILEPREFIX-$FREQ-adjacent | genkmz.sh > /dev/null 2>&1
                        echo                  
                echo
        	fi
	done < $INFILE
	IFS=$OLDIFS
}

post_plot_clean () {
	echo
	echo Removing .ppm and .png files from plot directory.  These files currently serve no purpose.
	echo
	rm -fr $PLOTDIR/*.ppm
        rm -fr $PLOTDIR/*.png
	echo
}

#Main
clear
echo "You are running batchplot.sh v$VERSION"
echo  ---------------------------------
echo
check_plotdir
clean_plotdir
cd $PLOTDIR
validate_infile
batch_run
post_plot_clean
