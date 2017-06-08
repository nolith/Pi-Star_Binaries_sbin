#!/bin/bash
#########################################################
#                                                       #
#              HostFilesUpdate.sh Updater               #
#                                                       #
# Written for Pi-Star (http://www.mw0mwz.co.uk/pi-star) #
#               By Andy Taylor (MW0MWZ)                 #
#                                                       #
#                     Version 2.0                       #
#                                                       #
#  Based on the updaters writted by Tony Corbett G0WFV  #
#                                                       #
#########################################################

APRSHOSTS=/usr/local/etc/APRSHosts.txt
DCSHOSTS=/usr/local/etc/DCS_Hosts.txt
DExtraHOSTS=/usr/local/etc/DExtra_Hosts.txt
DMRIDFILE=/usr/local/etc/DMRIds.dat
DMRHOSTS=/usr/local/etc/DMR_Hosts.txt
DPlusHOSTS=/usr/local/etc/DPlus_Hosts.txt
P25HOSTS=/usr/local/etc/P25Hosts.txt
YSFHOSTS=/usr/local/etc/YSFHosts.txt

# How many backups
FILEBACKUP=1

# Check we are root
if [ "$(id -u)" != "0" ]
then
	echo "This script must be run as root" 1>&2
	exit 1
fi

# Create backup of old files
if [ ${FILEBACKUP} -ne 0 ]
then
	cp ${APRSHOSTS} ${APRSHOSTS}.$(date +%Y%m%d)
	cp ${DCSHOSTS} ${DCSHOSTS}.$(date +%Y%m%d)
	cp ${DExtraHOSTS} ${DExtraHOSTS}.$(date +%Y%m%d)
	cp ${DMRIDFILE} ${DMRIDFILE}.$(date +%Y%m%d)
	cp ${DMRHOSTS} ${DMRHOSTS}.$(date +%Y%m%d)
	cp ${DPlusHOSTS} ${DPlusHOSTS}.$(date +%Y%m%d)
	cp ${P25HOSTS} ${P25HOSTS}.$(date +%Y%m%d)
	cp ${YSFHOSTS} ${YSFHOSTS}.$(date +%Y%m%d)
fi

# Prune backups
FILES="${APRSHOSTS}
${DCSHOSTS}
${DExtraHOSTS}
${DMRIDFILE}
${DMRHOSTS}
${DPlusHOSTS}
${P25HOSTS}
${YSFHOSTS}"

for file in ${FILES}
do
  BACKUPCOUNT=$(ls ${file}.* | wc -l)
  BACKUPSTODELETE=$(expr ${BACKUPCOUNT} - ${FILEBACKUP})

  if [ ${BACKUPCOUNT} -gt ${FILEBACKUP} ]
  then
	for f in $(ls -tr ${file}.* | head -${BACKUPSTODELETE})
	do
		rm $f
	done
  fi
done

# Generate Host Files
curl --fail -s http://www.mw0mwz.co.uk/pi-star/APRS_Hosts.txt > ${APRSHOSTS}
curl --fail -s http://www.mw0mwz.co.uk/pi-star/DCS_Hosts.txt > ${DCSHOSTS}
curl --fail -s http://www.mw0mwz.co.uk/pi-star/DMR_Hosts.txt > ${DMRHOSTS}
curl --fail -s http://www.mw0mwz.co.uk/pi-star/DPlus_Hosts.txt > ${DPlusHOSTS}
curl --fail -s http://www.mw0mwz.co.uk/pi-star/DExtra_Hosts.txt >> ${DPlusHOSTS}
curl --fail -s http://www.mw0mwz.co.uk/pi-star/DMRIds.dat > ${DMRIDFILE}
curl --fail -s http://www.mw0mwz.co.uk/pi-star/P25_Hosts.txt > ${P25HOSTS}
curl --fail -s http://www.mw0mwz.co.uk/pi-star/YSF_Hosts.txt > ${YSFHOSTS}
curl --fail -s http://www.mw0mwz.co.uk/pi-star/USTrust_Hosts.txt > ${DExtraHOSTS}

exit 0