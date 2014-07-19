#!/bin/bash

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
ECHO="echo -e"
function ChangeColor(){
    local color=$1;
	local cmd="tput setaf $color;tput sgr0"
    if ! [[ $color =~ '^[0-9]$' ]] ; then
       case $(echo $color | tr '[:upper:]' '[:lower:]') in
        black) color=0 ;;
        red) color=1 ;;
        green) color=2 ;;
        yellow) color=3 ;;
        blue) color=4 ;;
        magenta) color=5 ;;
        cyan) color=6 ;;
        white) color=7 ;;
		*) $cmd="${ECHO} ${color}";;
       esac
    fi
	sh -c $cmd
}

function EXIT(){
	ChangeColor ${NC}
	exit $1
}

# ------------------------------------------------------------------------------
# ------------------------------End Of Colorize---------------------------------
# ------------------------------------------------------------------------------

Environment="screen"
SUDO="sudo"
VirtualRunner="kvm"
IMG="xamin.img" #Path to the Virtual Hard Disk
MEM="2G"
NETWORK_best="-net nic,model=virtio,netdev=nic-0"
NETWORK_best="${NETWORK_best} -netdev tap,id=nic-0,script=/etc/qemu-ifup"
net="${NETWORK_best}"
VGA="-vga std"

VNC_Host="0.0.0.0"
VNC_port="10"
VNC_Password="password"
Spice="" # To do

Monitor="${VNC}"
Key="-k en-us"

while getopts  "e:environment:s:sudo:n:network:M:Monitor:k:key:i:image:m:memory" flag; do
    case "$flag" in
		e|environment)	$Environment=$OPTARG;;
        s|sudo)			$SUDO=$OPTARG;;
        n|network)		$net=$OPTARG;;
        M|Monitor)		$Monitor=$OPTARG;;
		k|key)			$Key="-k ${OPTARG}";;
		i|image)		$IMG="${OPTARG}"
		m|memory)		$MEM="${OPTARG}"
    esac
done

VNC="-vnc ${VNC_Host}:${VNC_Port},${VNC_Password}"

seprator
ChangeColor ${LP}
$ECHO " Quick Xamin nested auto-configure (Called QXamin.sh)"
$ECHO " Created by Seyyed Muhammed Sadegh Salehi"
$ECHO " Copyright 2014. Seyyed Muhammed Sadegh Salehi"
$ECHO " E-Mail : salehi1994@gmail.com"
$ECHO " All rights reserved."
seprator

ChangeColor cyan
$Environment $SUDO $VirtualRunner -hda $IMG -m $MEM $net $Key $Monitor

EXIT 0
