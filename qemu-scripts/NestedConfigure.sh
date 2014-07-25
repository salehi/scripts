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

CC ${LP}
seprator
$ECHO " Quick Xamin nested auto-configure (Called QXamin.sh)"
$ECHO " Created by Seyyed Muhammed Sadegh Salehi"
$ECHO " Copyright 2014. Seyyed Muhammed Sadegh Salehi"
$ECHO " E-Mail : salehi1994@gmail.com"
$ECHO " All rights reserved. GPLv3"
seprator
CC ${NC}

function prerequisties(){
	CC ${green}
	$ECHO "Checking for dependencies..."
	CC ${LG}
	apt-get install -y qemu qemu-kvm kvm libvirt-bin bridge-utils linux-headers-$(uname -r)
	CC ${NC}
}


# Checking for prerequisties
prerequisties

# Checking for CPU VT-d Technology
kvm-ok
if [ `egrep -c '(vmx|svm)' /proc/cpuinfo` ];then
	$ECHO "${green} Successful CPU configuration."
else
	$ECHO "${red} Please check for CPU configuration."
	EXIT 1
fi

# Check for network
# Disabling automatic network-manager service at all
CC ${NC}
if ! [ -f /etc/init/network-manager.override ]; then
	echo "manual" | sudo tee /etc/init/network-manager.override
	CC ${green}
	$ECHO "The Network Manager removed from start up, You can revert this setting by\n removing /etc/init/network-manager.override file."
	CC ${NC}
fi

if [ -f /tmp/interfaces.lst ];then
	rm /tmp/interfaces.lst
fi

ifconfig -a| awk '/Link/ { if( $4 == "HWaddr") print $1 }' | tee -a /tmp/interfaces.lst

br_nick="_smss1995"

for eth in `cat /tmp/interfaces.lst`
do
	if [ "${eth: -9}" == "${br_nick}" ];then
		$ECHO "bridge detected"
		exist_bridge="true"
		bridge="${eth}"
	else
		if [ "${eth:0:3}" == 'eth' ]; then
			last_eth="${eth}"
			if [ -z $first_eth ];then
				first_eth="${eth}"
			fi
		fi
	fi
	ifconfig ${eth} down
done

echo "********************************************************************************"

for eth in `cat /tmp/interfaces.lst`
do
	if [ "${eth}" != "${first_eth}" ];then
		ifconfig ${eth} up
	else
		ifconfig ${eth} 0.0.0.0 up
	fi
done

if [ -z $exist_bridge ]; then
	bridge="${first_eth}${br_nick}"
	brctl addbr ${bridge}
else
	bridge="${detected_br_name}"
fi

brctl addif ${bridge} ${first_eth}
dhclient ${bridge}

net.ipv4.ip_forward=1
net.bridge.bridge-nf-call-ip6tables=0
net.bridge.bridge-nf-call-iptables=0
net.bridge.bridge-nf-call-arptables=0


$ECHO -n "#!/bin/sh \n\nswitch=${bridge}\n\nif [ -n \$1 ];then\n        tunctl -u '`'whoami'`' -t \$1\n        ip link set \$1 up\n        sleep 2s\n        brctl addif \$switch \$1\n        exit 0\nelse\n        echo 'Error: no interface specified'\n        exit 1\nfi\n" | tee /etc/qemu-ifup

EXIT 0
