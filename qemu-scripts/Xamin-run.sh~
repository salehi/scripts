#!/bin/bash
# generate a random mac address for the qemu nic

HDA="/media/Kali/VM/xamin.vdi"
cdrom="/home/smss/Downloads/xamin-beta-1.1.10.iso"
#
# 	 [order=drives][,once=drives][,menu=on|off]
#    [,splash=sp_name][,splash-time=sp_time]
#    'drives': floppy (a), hard disk (c), CD-ROM (d), network (n)
#    'sp_name': the file's name that would be passed to bios as logo picture, if menu=on
#    'sp_time': the period that splash picture last if menu=on, unit is ms
#
boot="d"
memory="2048"

DEVICE="e1000"
NETDEV="net0"
MAC="" #initialize later...
NETDEV2="tap"
id="net0"
ifup_script="./etc/qemu-ifup"
script="/etc/qemu-ifup"
createBridge="true"
showHelp="false"
CMD="true"
verbose="false"
br="br0"
eth="eth0"
HostIP="192.168.2.2"
ClientIP="192.168.2.3"
bits="x86_64"
options="-hda ${HDA} -cdrom ${cdrom} -m ${memory}"

function decimalToHex()
{
	local decimal=$1
	local output
	output=$(printf "%02X" ${decimal})
	echo $output
}

function hexRand(){
	local output
	output=$(decimalToHex $((RANDOM%256)))
	echo $output
}

function HostSide(){
	sudo brctl addbr $br
	sudo brtcl addif $br $eth
	sudo ifconfig $br up
	sudo sysctl -w net.ipv4.ip_forward=1                 # allow forwarding of IPv4
	route add -host ${ClientIP} dev ${NETDEV2} 			 # add route to the client
	$options="${options} -device ${DEVICE},netdev=${NETDEV},mac=$MAC -netdev ${NETDEV2},id=${id},script=${ifup_script}"
#qemu-system-x86_64 -hda /path/to/hda.img -device e1000,netdev=net0,mac=$macaddress -netdev tap,id=net0
}

function ClientSide(){
	echo "Client Side Configurations:"
	echo "    Default GW of the client is of course then the host\
			  (<ip-of-host>=${HostIP} has to be in same subnet as\
			   <ip-of-client>=${ClientIP} ...)"
	echo ""
	echo "    if the subnet masks is equal, then enter this command On the client:\
			  # route add default gw ${HostIP}"
	echo ""
	echo " 	  otherwise,(means if you host IP is not on the same subnet as \
			  <ip-of-client>=${ClientIP},\
			  then you must manually add the route to host before you create default route: "
	echo "	  # route add -host ${HostIP} dev <network-interface> \
		      # route add default gw ${HostIP} "
}

r2=$(hexRand)
r3=$(hexRand)
r4=$(hexRand)
r5=$(hexRand)

MAC="52:54:$r2:$r3:$r4:$r5"
echo "Generated MAC: ${MAC}"
echo "=========================================================================" >> lastMac.log
echo date >> lastMac.log
echo "Generated MAC: ${MAC}" >> lastMac.log
echo "=========================================================================" >> lastMac.log

function usage(){
   (
	echo "Usage: $0 [options]"
	echo "Available options:"
	echo "      --help                   prints this"
	echo "  --mac <MAC ADDRESS>        			specifies a MAC Address.(default=random)"
	echo "  --device <DEVICE>            		specifies a device. (default=${DEVICE})"
	echo "  --netdev <netdev>            		specifies a network device. (default=${NETDEV})"
	echo "  --netdev2 <netdev>           		specifies another network device.( default=${NETDEV2})"
	echo "  --netdev2_id <id>            		specifies an ID for netdev2. (default=${netdev2_id})"
	echo "  --hda <image>                		specifies Hard Disk Image. a means the first hard disk.(default=${HDA})"
	echo "  -c|--create <HDName> <size>  		specifies Hard Disk name with its size to create. just create and exit"
	echo "  --qemu-script <script>       		specifies a script for qemu.(default=${script})"
	echo "  --system <bits>				 		specifies qemu-system-BITS, see the list of qemu-system- {press TAB to show}"
	echo "									 	   the popular bits are i386 and x86_64 for 32 and 64 system bits respectively."
	echo "  --configure-network|--network|-cn   specifies Configure Network or Not, additional Parameters are: HostSide"
	echo "																									   ClientSide"
	echo "																							  default:both of above"
	echo "  -br|--bridge <bridgeName>			specifies the beidge name.(default=${br}). workd with network configure options only."
	echo "  --hostIP <IP>						specifies the host IP.(default=${HostIP})"
	echo "  --clientIP <IP>             		specifies the client IP.(default=${ClientIP})"
	echo "  --eth <ethName>						specifies eth name, works with --create-bridge only.(default=${eth})"
	echo "  -v                          		verbose mode.(default=${verbose})"
   ) 1>&2
}

while getopts  "mac:device:netdev:netdev2:netdev2_id:hda:qemu-script:create-bridge:bits:br" flag; do
    case "$flag" in
        mac)			MAC=$OPTARG;;
        device)			DEVICE=$OPTARG;;
        netdev)			NETEV=$OPTARG;;
        netdev2)		NETDEV2=$OPTARG;;
        netdev2_id)		NETDEV2_id=$OPTARG;;
		create-bridge)	createBridge=$OPTARG;;
		hda) 			HDA=$OPTARG;;
		qemu-script) 	script=$OPTARG;;
		v) 				verbose=true;;
		bits)			bits=$OPTARG;;
		br)				br=$OPTARG;;
    esac
done
chmod +x ${script}

while [ $# -gt 0 ]
do
  case $1 in

    -h|--help)
      usage
      exit 0
      ;;
	-c|--create)
	  if [ ${2} == "HardDisk" ]; then
		if [ ${4} -lt 10G ]; then
			echo "You most specify at least 10GB to installing xamin OS"
		fi
		qemu-img --create ${3} ${4}
		exit 0
	  else 
		usage 
		exit 1
	  fi	  
	  ;;
	--configure-network|--network|-cn)
	  if [ ${2} == "HostSide" ]; then
		HostSide
	  elif [ ${2} == "ClientSide" ]; then
		ClientSide
	  else
		HostSide
		ClientSide
	  fi
	  shift 1
	  ;;
  esac
  shift 1
done

if [ verbose = "true" ]; then
	echo "COMMAND is : qemu-system-${bits} -hda ${HDA} -device ${DEVICE},netdev=${NETDEV},mac=${MAC} -netdev ${NETDEV2},id=${NETDEV2_id}"
fi
echo "Be patien, if everything is ready, your VM will be run."
echo "You can run again this script with '-cn' Option to get network configurations working"
echo "Options : ${options}"
sudo sh -c "qemu-system-${bits} ${options}" &
