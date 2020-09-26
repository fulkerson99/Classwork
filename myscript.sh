#!/bin/bash

#myscript.sh

#Programmed by Joseph Fulkerson
#9/25/2020
#This program displays system information using getopts statements to control function selection. 



#This function displays OS Realease and Linux flavor
function os-flavor(){
	echo "Os Release:  "
	echo
	cat /etc/os-release | head -6
	echo 
	echo "Linux Flavor:  "
	echo
	uname -r
	echo "*" \* 25 
	echo
}


#This function displays the linux filesystem structure
function filesystem(){
	echo "File System Structure:  "
	echo
	cat /etc/fstab | tail -6
	echo
	lsblk
	echo "-------------------------"
	echo
}

#This funciton displays system memory capacity
function memory(){
	echo "System Memory Capacity:  "
	echo
	free -m
	echo "-------------------------"
	echo
}

#This function displays the server IP address
function ipadrss(){
	echo "IP Address:  "
	echo
	ip address | head -9 | tail -1
	echo "-------------------------" 
	echo
}

#This function displays system runtime
function runtime(){
	echo "System Runtime:  "
	echo
	uptime
	echo "-------------------------"
	echo
}

#This function displays network interace configuration
function networki(){
	echo "Network Interface Configuration:  "
	echo
	sudo ifconfig
	echo "-------------------------"
	echo
}


#This fucntion displays shell usage
function usage(){
	echo "Usage: ./myscript.sh -abcdef"
	echo

	echo "Case Options:"
	echo -e " \ta) OS Version & Linux Flavor"
	echo -e " \tb) Linux Filesystem Structure "
	echo -e " \tc) System Memory Capacity "
	echo -e " \td) System IP Address "
	echo -e " \te) System Runtime "
	echo -e " \tf) Network Interface Configuration "
}


#Main containing getopts for case selection

while getopts abcdef options 2>/dev/null
do
	case $options in
	a) os-flavor;;
	b) filesystem;;
	c) memory ;;
	d) ipadrss;;
	e) runtime;;
	f) networki;;
	\?) usage;;
	esac
done

exit 0


