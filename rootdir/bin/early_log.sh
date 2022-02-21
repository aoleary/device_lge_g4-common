#!/system/bin/sh
mkdir /log
mount /dev/block/platform/soc.0/f9824900.sdhci/by-name/cache /log

/system/bin/logcat -b all -D -f /log/boot_lc_full.txt &
/system/bin/logcat -b crash -D -f /log/boot_lc_crash.txt &
/system/bin/logcat -b kernel -D -f /log/boot_lc_kernel.txt &

rm /log/props.txt /log/mounts.txt /log/dmesg.txt
while true; do date >> /log/props.txt; getprop >> /log/props.txt; sleep 1 ;done  &
while true; do date >> /log/mounts.txt; mount >> /log/mounts.txt; df >>  /log/mounts.txt; sleep 1 ;done &
while true; do date >> /log/dmesg.txt; dmesg -c >> /log/dmesg.txt; sleep 1 ;done &
