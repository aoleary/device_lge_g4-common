#!/system/bin/sh
mkdir /log
mount /dev/block/platform/soc.0/f9824900.sdhci/by-name/sdcard /log

getprop > /log/props.txt
mount > /log/mounts.txt
df -h > /log/fileystems.txt
