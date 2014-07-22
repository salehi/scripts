#!/bin/bash

set -x

function seprator(){
        for((i=0;i<80;i++))
        do
                echo -n "*"
        done
        echo ""
}

#-------------------------------------------------------------------------------
#----------------------------------Colorize-------------------------------------
#-------------------------------------------------------------------------------

#Black        0;30     Dark Gray     1;30
#Blue         0;34     Light Blue    1;34
#Green        0;32     Light Green   1;32
#Cyan         0;36     Light Cyan    1;36
#Red          0;31     Light Red     1;31
#Purple       0;35     Light Purple  1;35
#Brown/Orange 0;33     Yellow        1;33
#Light Gray   0;37     White         1;37

NC='\e[0m' 				# No Color
red='\e[0;31m'			# Red
green='\e[0;32m'		# Green
LP='\e[1;35m'			# Light Purple
LG='\e[1;31m'			# Light Green
cyan='\e[0;36m'
ECHO="echo -e"
function CC(){
	${ECHO} $1
}

function EXIT(){
	CC ${NC}
	exit $1
}

# ------------------------------------------------------------------------------
# ------------------------------End Of Colorize---------------------------------
# ------------------------------------------------------------------------------

Environment="screen"
SUDO="sudo"
VirtualRunner="kvm"
IMG="-hda xamin.img" #Path to the Virtual Hard Disk
MEM="-m 2G"
NETWORK_best="-net nic,model=virtio,netdev=nic-0"
NETWORK_best="${NETWORK_best} -netdev tap,id=nic-0,script=/etc/qemu-ifup"
net="${NETWORK_best}"
VGA="-vga std"

VNC_Host="0.0.0.0"
VNC_port="10"
VNC_Password="password"
Spice="" # To do
cdrom="-cdrom /dev/sr0"
boot="-boot c"
Monitor="${VNC}"
Key="-k en-us"
function usage(){
	(
	CC ${green}
	$ECHO "Usage: $0 [options]"
	$ECHO "Available options:"
	$ECHO "  --help 	------------------>  prints this."
	$ECHO "  -e|--environment<screen> --->										"
	$ECHO "                 	Specify where the command will be executed.			"
	$ECHO "                 	(Note that \'screen\' is a package.)				"
	$ECHO "                 	You can run the command in the current Environment	"
	$ECHO "                 	by setting it to ''				 				"
	$ECHO "  -s|--sudo	------------------>	Specify sudoer, 					"
	$ECHO "                         		Set it to '' in order to run as an ordina-"
	$ECHO "                         		-ry user.									"
	$ECHO "  -n|--network 	----------------> Specifies all of the network option." # To do: Provide some modes internally
	$ECHO "  -M|--Monitor 	----------------> Specifies all of the monitor option."
	$ECHO "  -k|--key 	----------------> Specifies the keyboard language.	"
	CC ${LG}
	$ECHO "  -i|--image 	----------------> Specifies path to the virtual HD.	"
	CC ${green}
	$ECHO "  -m|--memory 	----------------> Specifies the amount of V-Memory.	"
	$ECHO "  -c|--cdrom  	----------------> Specifies the path to cdrom (ISO or dev)"
	$ECHO "  -b|--boot   	----------------> Specifies the boot priotiry, See kvm boot options"
	
	CC ${NC}
   ) 1>&2
}

while getopts  "e:environment:s:sudo:n:network:M:Monitor:k:key:i:image:m:memory:h:help:c:cdrom:b:boot" flag; do
    case $flag in
	h|help)		usage ; EXIT 0;;
	e|environment)	$Environment="$OPTARG";;
        s|sudo)		$SUDO="$OPTARG";;
        n|network)	$net="$OPTARG";;
        M|Monitor)	$Monitor="$OPTARG";;
	k|key)		$Key="-k ${OPTARG}";;
	i|image)	$IMG="-hda ${OPTARG}";;
	m|memory)	$MEM="-m ${OPTARG}";;
	c|cdrom)	$cdrom="-cdrom ${OPTARG}";;
	b|boot)		$boot="-boot ${OPTARG}";;
    esac
done

VNC="-vnc ${VNC_Host}:${VNC_Port},${VNC_Password}"

CC ${LP}
seprator
$ECHO " Quick Xamin nested auto-configure (Called QXamin.sh)"
$ECHO " Created by Seyyed Muhammed Sadegh Salehi"
$ECHO " Copyright 2014. Seyyed Muhammed Sadegh Salehi"
$ECHO " E-Mail : salehi1994@gmail.com"
$ECHO " All rights reserved. GPLv3"
seprator

CC $cyan
$SUDO $Environment $VirtualRunner $IMG $MEM $net $Key $Monitor $cdrom $boot

EXIT 0
