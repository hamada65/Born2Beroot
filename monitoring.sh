#!/bin/bash

###### [ Architecture ] #######

arch=$(uname -a)

###### [ vCpu ] ######

vc=$(grep "physical id" /proc/cpuinfo | wc -l)

###### [ CPU ] ######

cp=$(nproc --all)

###### [ Memory Usage ] ######

mu=$(free -m | grep Mem | awk '{printf "%s/%sMB (%.2f%%)", $3, $2, $3/$2 * 100}')

###### [ Disk Usage ] ######

total_space=$(df -Bg | grep '^/dev' | grep -v '/boot$' | awk '{counter += $2} END {printf("%dGb", counter)}')
used_space=$(df -Bm | grep '^/dev' | grep -v '/boot$' | awk '{counter += $3} END {printf("%d", counter)}')
percentage_space=$(df -Bm | grep '^/dev' | grep -v '/boot$' | awk '{i += $2} {j += $3} END {printf("%d", j/i*100)}')

###### [ CPU Load ] ######

cl=$(mpstat | grep "all " | awk '{printf "%.2f%%", 100 - $NF}')

###### [ Last Boot ] ######

lb=$(who -b | awk '{print $3, $4}')

###### [ LVM use ] ######

lu=$(if [ $(lsblk | grep "lvm" | wc -l) -gt 0 ];then echo yes;else echo no; fi)

###### [ Connections TCP ] ######

tcp=$(ss -t | grep "ESTAB" | wc -l)

###### [ User log ] ######

ul=$(who | wc -l)

###### [ Network ] ######

netIP=$(hostname -I)
mac=$(ip link | grep "link/ether" | awk '{printf("%s", $2)}')

###### [ Sudo ] ######

su=$(journalctl _COMM=sudo -q | grep 'COMMAND' | wc -l)

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
