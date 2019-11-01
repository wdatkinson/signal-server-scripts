# signal-server-scripts
Non-Privileged user-facing scripts for use with https://github.com/N9OZB/Signal-Server.

I learned of Signal-Server in my role as Vice Chairman for the Indiana Repeater Council.  During one of our regional meetings,
Aaron (N9OZB), mentioned his work on a fork of the original Signal-Server.  I set out to install it and make it available to our
coordinators.  As I worked with the program, I very quickly learned that it was meant to be run as the root user.  I shouldn't
need to explain why granting root access to remote users, especially those not skilled in linux, is a bad idea.

So I embarked upon the adventure of trying to make Aaron's fork run under a non-privileged user.  As of this writing, I've been
able to successfully run VHF and UHF plots from my non-privileged account.  Additionally, I've added some spit and polish to the
overall process.  As I worked with the software, I tried to imagine the process from the viewpoint of a remote coordinator with 
little or no linux expirience.  And that is what you will find here.

There are three scripts and one supportig file that are part of this package:

gettiles.sh - This script should be placed in your Signal-Server directory.  This script must, at least for now, be run as the root
user.  It does not need to be run with each plot run and it only needed to create the tiles for use by Signal-Server.  This script
accomplishes the following tasks:

	1). Checks to ensure that the tiles directory exists.  If not, it is created.
	2). Cleans the destination prior to downloading tiles.
	3). Downloads the zipped tiles in SRTM format.
	4). Unzips tiles post download
	5). Renamed them from and uppercase extention to a lower case extention.
	6). Runs the utility to convert from SRTM to .sdf for use by Signal-Server.

If you installed Signal-Server somewhere else besides /opt/Signal-Server, then you will need to edit the script and update the path
for the three variables.  I may look at simplifying this a bit with the next interation.

Since this file is run as root, there are no special concerns or permissions required.

runplot.sh - The script should be placed in the home directory of your non-privileged user.  It should be owned by that user and part 
of a group called signal-server.  Permissions of 755 are recommended and what was used during testing. This script accomplishes the
following tasks:

	1). Checks to ensure that ~/plots exists.  If not, it is created.
	2). Optionally cleans the ~/plots directory for leftovers from prior runs.
	3). Requests plot run parameters from user and stores them as variables.
	4). Calls Signal-Server to run Service, Interference and Adjacent plots based upon info entered in #3.
	5). Removes *.ppm and *.png from the ~/plots directory as those files have no current use.

batchplot.sh - This is basically the same as the runplot.sh, except that it processes multiple plots sourced from the source.csv file. It also DOES NOT prompt you before cleaning the plots directory.  So once you edit your source.csv, you run this file and go away.  Each plot will show you the system time at the start of the run, so you can get some idea as to progress.  There is also an indicator for each frequency of which plot it's on (1 of 3, 2 of 3, and 3 of 3).

source.csv - This is a comma separated file in the format of: band,lattitude,longitude,height,frequency,erp,outfileprefix.  There are two examples provided in the sample file.  Be careful as there is currently no error checking, nor any comments in the file.  If you edit this file off-system and then upload it, it's up to you to make sure no special characters (notorious when editing linux files on Windows) find their way into the file.  As of version 1.2, I've put in a function to hopefully strip hidden characters, however due regard should still be used to avoid them to begin with.

Post run, you'll have a *.kmz file which can be offloaded and run in Google Earth of observe your plot.

Requirements for non-privileged user functionality:

	1). Group called signal-server created and each user is a member of this group.
	2). Recursive group of all files and directories in the Signal-Server tree are set to signal-server
	3). Recursive 755 permissions set in Signal-Server tree.

Since the Signal-Server program itself could be upgraded/changed at any time, I've attempted to keep modifications to it's programs as
minimal as possible.  As of right now, the only change I've made was to edit the runsig.sh on line 16 to reflect the location of the
tiles.  Specifically this parameter:

	-sdf /opt/Signal-Server/tiles

That's it for now.  Hopefully you find this useful.  Please feel free to reach out with any questions or issues.

73!

de NF9K
