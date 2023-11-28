#!/bin/bash

arch=$(uname -a)

## =========== cpu ============

cpu_p=$(grep "physical id" /proc/cpuinfo | wc -l)
cpu_v=$(grep "processor" /proc/cpuinfo | wc -l)
## =========== mem ============

memfree=$(free --mega | awk '$1 == "Mem:"' | awk '{printf "%d" , $3}')
memtotal=$(free --mega | awk '$1 == "Mem:"'| awk '{printf "%dMB", $2}')
percent_mem=$(free --mega | awk '$1 == "Mem:"' | awk '{printf "%.2f", $3 / $2 * 100}')

## ========== space ===========

space_usage=$(df -m | grep "/dev/" | awk '{space_u += $3} END {printf "%d", space_u}')
space_total=$(df -m | grep "/dev/" | awk '{space_t += $2} END {printf "%dGb", space_t / 1000}')
space_percent=$(df -m | grep "/dev/" | awk '{space_u += $3} {space_t += $2} END {printf "%d" , space_u / space_t * 100}')

## ========= CPU Load =========

cpu_load=$(mpstat | grep "all" | awk '{printf "%.2f", 100 -$NF}')

## ========= Last Boot ========

last_boot=$(who -b | awk '$1 == "system" {print $3 " " $4}')

## ========= LVM Use  =========

count_lvm=$(if [ $(lsblk | grep "lvm" | wc -l) -gt 0 ]; then echo yes; else echo no;fi)

## ========= TCP ==============

tcp=$(ss -tlnup | grep "ESTAB" | wc -l)

## ========= User Log =========

user_log=$(users | wc -w)

## ========= Network IP =======

ip=$(hostname -I)
mac_address=$(ip link | grep "link/ether" | awk '{print $2}')

## ========= Sudo cmd =========

sudo_cmd=$(grep "COMMAND" "/var/log/sudo/sudo_config" | wc -l)

wall "    #Architecture: $arch
    #CPU physical: $cpu_p
    #vCPU: $cpu_v
    #Memory Usage: $memfree/$memtotal ($percent_mem%)
    #Disk Usage: $space_usage/$space_total ($space_percent%)
    #CPU load: $cpu_load
    #last boot: $last_boot
    #LVM use: $count_lvm
    #Connection TCP: $tcp
    #User log: $user_log
    #Network: IP $ip ($mac_address)
    #Sudo: $sudo_cmd
    "
