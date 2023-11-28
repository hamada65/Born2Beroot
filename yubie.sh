#!/bin/bash

# ============ Architecture ============
arc=$(uname -a)

# ============ Processors ==============
pcpu=$(grep "processor" /proc/cpuinfo | wc -l)
vcpu=$(grep "physical id" /proc/cpuinfo | wc -l)

# ============ Memory (RAM) ============
tram=$(free -m | awk '$1 == "Mem:" {printf("%d", $2)}')
uram=$(free -m | awk '$1 == "Mem:" {printf("%d", $3)}')
pram=$(free | awk '$1 == "Mem:" {printf("%.2f", $3/$2*100)}')

# ============ Memory (Disk) ===========
tdisk=$(df -Bg | grep '^/dev' | grep -v '/boot$' | awk '{counter += $2} END {printf("%d", counter)}')
udisk=$(df -Bg | grep '^/dev' | grep -v '/boot$' | awk '{counter += $3} END {printf("%d", counter)}')
pdisk=$(df -Bg | grep '^/dev' | grep -v '/boot$' | awk '{i += $2} {j += $3} END {printf("%d", j/i*100)}')

# ============ Cpu load ================
cpul=$(vmstat 1 2 | tail -1 | awk '{print $15}')
cpuop=$(echo "100 - $cpul" | bc)
cpuend=$(printf "%.1f" $cpuop)

# ============ Last boot ===============
lb=$(who -b | awk '$1 == "system" {printf("%s %s %s", $3, $4, $5)}')

# ============ LVM check ===============
lvm=$(if [ $(lsblk | grep "lvm" | wc -l) -gt 0 ];then echo yes;else echo no; fi)

# ============ TCP connection ==========
tcp=$(ss -ta | grep "ESTAB" | wc -l)

# ============ USER log ================
ulog=$(users | wc -w)

# ============ adresses ================
ip=$(hostname -I)
mac=$(ip link | grep "link/ether" | awk '{printf("%s", $2)}')

# ============ sudo ====================
scmd=$(journalctl _COMM=sudo -q | grep 'COMMAND' | wc -l)

wall "    #ARCHITECTURE: $arc
    #CPU physical : $pcpu
    #vCPU : $vcpu
    #Memory Usage: $uram/${tram}MB ($pram%)
    #Disk Usage: $udisk/${tdisk}Gb ($pdisk%)
    #CPU load: $cpuend%
    #Last boot: $lb
    #LVM use: $lvm
    #Connection TCP : $tcp ESTABLISHED
    #User log: $ulog
    #Network: IP $ip ($mac)
    #Sudo : $scmd cmd"