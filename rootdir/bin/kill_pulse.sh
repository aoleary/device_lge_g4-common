#!/system/bin/sh
##############################################
#
# Kill pulse led manually
#
##############################################
pid=$(pgrep pulse.sh)
kill $pid
