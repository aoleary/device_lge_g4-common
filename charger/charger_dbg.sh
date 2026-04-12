#!/system/bin/sh
LOG=/data/local/tmp/charger_wrapper.log

echo "===== charger_dbg start =====" >> $LOG
date >> $LOG

echo "--- system properties ---" >> $LOG
getprop ro.bootmode >> $LOG 2>&1
getprop ro.boot.bootreason >> $LOG 2>&1
getprop sys.boot.reason >> $LOG 2>&1

echo "--- ps snapshot ---" >> $LOG
ps -A | grep charger >> $LOG 2>&1

echo "--- framebuffer state ---" >> $LOG
cat /sys/class/graphics/fb0/blank >> $LOG 2>&1
cat /sys/class/graphics/fb0/status >> $LOG 2>&1

echo "--- power supply ---" >> $LOG
cat /sys/class/power_supply/battery/online >> $LOG 2>&1
cat /sys/class/power_supply/usb/online >> $LOG 2>&1
cat /sys/class/power_supply/ac/online >> $LOG 2>&1

echo "--- end of wrapper log ---" >> $LOG
