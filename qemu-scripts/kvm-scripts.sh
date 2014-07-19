#!/bin/bash

function seprator(){
        for((i=0;i<80;i++))
        do
                echo -n "*"
        done
        echo ""
}

seprator
echo " KVM Launching commands"
echo " Created by Seyyed Muhammed Sadegh Salehi"
echo " Copyright 2014. Seyyed Muhammed Sadegh Salehi"
echo " E-Mail : salehi1994@gmail.com"
echo " All rights reserved."
seprator


echo "sudo qemu-system-x86_64 -hda xamin.img -m 2048 -device e1000,netdev=net0,mac=52:54:00:11:22:33 -netdev tap,id=net0,script=/etc/qemu-ifup -vga std '$'*"
echo "sudo qemu-system-x86_64 -hda xamin.img -m 2048 -net nic,model=virtio,macaddr=52:54:00:11:22:33,netdev=nic-0 -netdev tap,id=nic-0,script=/etc/qemu-ifup,vhost=on"
echo "sudo qemu-system-x86_64 -hda xamin.img -m 2048 -net nic,model=virtio,macaddr=52:54:00:11:22:33,netdev=nic-0 -netdev tap,id=nic-0,script=/etc/qemu-ifup"
