#!/bin/bash

################################################################################################
# gettiles.sh - SRTM to SDF File Processing Script v1.1 - Bill Atkinson (NF9K) - bill@nf9k.net #
################################################################################################


# Variables
SSDIR=/opt/Signal-Server
LIST1=/opt/Signal-Server/tiles-source.lst
DEST=/opt/Signal-Server/tiles

# Functions
check_dest() {
	if [ ! -d "$DEST" ]; then
		mkdir $DEST
		echo 'Local File Destination Created'
        	echo
	fi
}

clean_dest() {
	if [ "$(ls -A $DEST)" ]; then
 		rm -fr $DEST/*
		echo 'Local File Destination Cleaned'
		echo
	fi
}

pull_files() {
	echo Downloading Files....
	echo
	wget -c -i $LIST1 -P $DEST > /dev/null 2>&1
	echo 'SRTM Files Downloaded'
	echo
}

unzip_files() {
	if [ ! -f "$DEST/*.zip" ]; then
                echo 'Unzipping Files....'
		echo
		cd $DEST
		unzip '*.zip' > /dev/null 2>&1
		rm -fr *.zip
                echo 'Files Unzipped'
                echo
        fi
}

rename_files() {
	if [ ! -f "$DEST/*.HGT" ]; then
                echo 'Renaming Files....'
		echo
		cd $DEST
		for i in *.HGT; do mv $i ${i/.HGT/.hgt}; done
                echo 'Files Renamed'
                echo
        fi
}

convert_files() {
	if [ ! -f "$DEST/*.hgt" ]; then
                echo 'Converting files.... Please be patient, this can take some time.'
		echo
		cd $DEST
		for file in *.hgt; do /opt/Signal-Server/utils/sdf/srtm2sdf -d /dev/null $file > /dev/null 2>&1; done
		if [ ! -f "$DEST/*.sdf" ]; then
			rm -fr *.hgt
                fi
		echo 'Files Converted'
                echo
        fi
}

# Main
clear
check_dest
clean_dest
pull_files
unzip_files
rename_files
convert_files
