#!/bin/bash

function seprator(){
        for((i=0;i<80;i++))
        do
                echo -n "$1"
        done
        echo ""
}

function sepratorL(){
        for((i=0;i<$2;i++))
        do
                echo -n "$1"
        done
        echo ""
}

function PING(){
	ping -U -R -c 1 -t 100ms $1
	sepratorL '+' 40
}

function jobs(){
	PING 4.2.2.2
	PING google.com
	PING 192.168.2.1
#	PING localhost
}

seprator '*'
echo " custom ping to check network reachableness "
echo " Created by Seyyed Muhammed Sadegh Salehi"
echo " Copyright 2014. Seyyed Muhammed Sadegh Salehi"
echo " E-Mail : salehi1994@gmail.com"
echo " All rights reserved."
seprator '*'



for((;;))
do
sepratorL '-' 40
date
jobs
sepratorL '-' 40
sleep 1
clear
done

