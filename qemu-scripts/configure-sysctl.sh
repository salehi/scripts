#!/bin/bash

function seprator(){
        for((i=0;i<80;i++))
        do
                echo -n "*"
        done
        echo ""
}

seprator
echo " Configure Network in order to get working KVM"
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
