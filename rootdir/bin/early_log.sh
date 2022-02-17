#!/system/bin/sh
mkdir /log
mount /dev/block/platform/soc.0/f9824900.sdhci/by-name/cache /log

/system/bin/logcat -b all -D -f /log/boot_lc_full.txt
/system/bin/logcat -b crash -D -f /log/boot_lc_crash.txt
/system/bin/logcat -b kernel -D -f /log/boot_lc_kernel.txt
