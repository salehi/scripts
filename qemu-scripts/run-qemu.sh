#!/bin/bash
USERID=$(whoami)

# Get name of newly created TAP device; see https://bbs.archlinux.org/viewtopic.php?pid=1285079#p1285079
precreationg=$(/usr/bin/ip tuntap list | /usr/bin/cut -d: -f1 | /usr/bin/sort)
sudo /usr/bin/ip tuntap add user $USERID mode tap
postcreation=$(/usr/bin/ip tuntap list | /usr/bin/cut -d: -f1 | /usr/bin/sort)
IFACE=$(comm -13 <(echo "$precreationg") <(echo "$postcreation"))

# This line creates a random MAC address. The downside is the DHCP server will assign a different IP address each time
printf -v macaddr "52:54:%02x:%02x:%02x:%02x" $(( $RANDOM & 0xff)) $(( $RANDOM & 0xff )) $(( $RANDOM & 0xff)) $(( $RANDOM & 0xff ))
# Instead, uncomment and edit this line to set a static MAC address. The benefit is that the DHCP server will assign the same IP address.
# macaddr='52:54:be:36:42:a9'
  
qemu-system-i386 -net nic,macaddr=$macaddr -net tap,ifname="$IFACE" $*
  
sudo ip link set dev $IFACE down &> /dev/null
sudo ip tuntap del $IFACE mode tap &> /dev/null
