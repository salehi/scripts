#!/bin/bash

function seprator(){
        for((i=0;i<80;i++))
        do
                echo -n "*"
        done
        echo ""
}

seprator
echo " Xamin mini run script"
echo " Created by Seyyed Muhammed Sadegh Salehi"
echo " Copyright 2014. Seyyed Muhammed Sadegh Salehi"
echo " E-Mail : salehi1994@gmail.com"
echo " All rights reserved."
seprator

echo "Restarting Network..."
sudo service networking restart
echo "Set system controls settings ..."
echo "Set IPv4 Forwarding option to true..."
sudo sysctl -w net.ipv4.ip_forward=1
echo "Set bridge-nf-call-ip6tables to false..."
sudo sysctl -w net.bridge.bridge-nf-call-ip6tables=0
echo "Set bridge-nf-call-iptables to false..."
sudo sysctl -w net.bridge.bridge-nf-call-iptables=0
echo "Set bridge-nf-call-arptables to false..."
sudo sysctl -w net.bridge.bridge-nf-call-arptables=0
echo "Set iptables physical bridge forwarding option to ACCETP packets"
sudo iptables -I FORWARD -m physdev --physdev-is-bridged -j ACCEPT

#sudo qemu-system-x86_64 -hda xamin.img -m 2048 -device e1000,netdev=net0,mac=52:54:00:11:22:33 -netdev tap,id=net0,script=/etc/qemu-ifup -vga std $*
#sudo qemu-system-x86_64 -hda xamin.img -m 2048 -net nic,model=virtio,macaddr=52:54:00:11:22:33,netdev=nic-0 -netdev tap,id=nic-0,script=/etc/qemu-ifup,vhost=on
#sudo qemu-system-x86_64 -hda xamin.img -m 2048 -net nic,model=virtio,macaddr=52:54:00:11:22:33,netdev=nic-0 -netdev tap,id=nic-0,script=/etc/qemu-ifup
sudo qemu-system-x86_64 -hda ubuntu.raw -m $(( 4 * 1024 )) -net nic,model=virtio,netdev=nic-0 -netdev tap,id=nic-0,script=/etc/qemu-ifup -device e1000,netdev=nic-1 -netdev tap,id=nic-1,script=/etc/qemu-ifup

#sudo qemu-system-x86_64 -device e1000,netdev=net0,mac=52:54:AB:AB:AB:AB -netdev tap,id=net0,script=/etc/qemu-ifup -nic,model=virtio,macaddr=52:54:AB:AB:AB:BB,netdev=nic-0 -netdev tap,id=nic-0,script=/etc/qemu-ifup,vhost=on -vnc localhost:2 -m 512 -hda IMG.qcow2
