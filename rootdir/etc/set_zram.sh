#! /vendor/bin/sh

TMEM=$(cat /proc/meminfo | grep MemTotal | awk  '{print $2}')

# Setup ZRAM to 50% of memtotal
let 'ZMEM=((TMEM/100)*25)*1024'
echo 1 > /sys/block/zram0/reset
echo 'lz4' > /sys/block/zram0/comp_algorithm
echo $ZMEM > /sys/block/zram0/disksize
mkswap /dev/block/zram0
swapon -d /dev/block/zram0
echo 100 > /proc/sys/vm/swappiness
echo 3 /sys/block/zram0/max_comp_streams
echo 0 /proc/sys/vm/page-cluster
