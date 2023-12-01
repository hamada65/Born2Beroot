#!/bin/bash

###### [ Architecture ] #######

arch=$(uname -a) # Unix Name : all

###### [ vCpu ] ######

vc=$(grep "physical id" /proc/cpuinfo | wc -l) # GREP : get line that contain "physical id" from the file /proc/cpuinfo
# WC used to count the number of words, lines, and characters
###### [ CPU ] ######

cp=$(nproc --all) # print the number of installed processors

###### [ Memory Usage ] ######

mu=$(free -m | grep Mem | awk '{printf "%s/%sMB (%.2f%%)", $3, $2, $3/$2 * 100}') # Free : display informations about memory
# awk : programing language 
###### [ Disk Usage ] ######

total_space=$(df -Bg | grep '^/dev' | grep -v '/boot$' | awk '{counter += $2} END {printf("%dGb", counter)}') # ^ : start of the line , $ : end of the line
used_space=$(df -Bm | grep '^/dev' | grep -v '/boot$' | awk '{counter += $3} END {printf("%d", counter)}')
percentage_space=$(df -Bm | grep '^/dev' | grep -v '/boot$' | awk '{i += $2} {j += $3} END {printf("%d", j/i*100)}')
# B : scale sizes by SIZE before printing them
###### [ CPU Load ] ######

cl=$(mpstat | grep "all " | awk '{printf "%.2f%%", 100 - $NF}')
# NF : Number Of Fields , $NF : The value of the final Fields
###### [ Last Boot ] ######

lb=$(who -b | awk '{print $3, $4}')
# Who : Print information about users who are currently logged in , -b : last boot time
###### [ LVM use ] ######

lu=$(lsblk | grep 'lvm' | wc -l | awk '{if ($1 > 0) printf "yes"; else printf "no"}')
# lsblk : List information about block devices
###### [ Connections TCP ] ######

tcp=$(ss -t | grep "ESTAB" | wc -l)
# ss -t : display TCP sockets
###### [ User log ] ######

ul=$(who | wc -l)

###### [ Network ] ######

netIP=$(hostname -I) # -I : all addresses for the host
mac=$(ip link | grep "link/ether" | awk '{printf("%s", $2)}') # t displays a list of network interfaces along with relevant information. 

###### [ Sudo ] ######

su=$(journalctl _COMM=sudo -q | grep 'COMMAND' | wc -l)
# jourbakctl : system journal logs, _COMM=sudo :  entries where the command name = sudo , -q : option remove additional infromations to make the output smaller
wall "	#Architecture: $arch
	#CPU physical : $vc
	#vCpu : $cp
	#Memory Usage: $mu
	#Disk Usage: $used_space/$total_space ($percentage_space%)
	#Cpu load: $cl
	#Last boot: $lb
	#LVM use: $lu
	#Connections TCP : $tcp ESTABLISHED
	#User log: $ul
	#Network: IP $netIP ($mac)
	#Sudo : $su cmd"
