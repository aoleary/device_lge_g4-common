#!/system/bin/sh
##############################################
#
# pulse led
#
##############################################

INTERVALL=1.5s

F_ON(){
    echo 0 > /sys/class/leds/green/brightness
    echo 127 > /sys/class/leds/blue/brightness
    echo 255 > /sys/class/leds/red/brightness
}

F_OFF(){
    echo 0 > /sys/class/leds/green/brightness
    echo 0 > /sys/class/leds/blue/brightness
    echo 0 > /sys/class/leds/red/brightness
}

F_RESET(){
    # reset when needed ONLY. Ensures a valid new led color does not get overwritten (e.g. battery state)
    # F_ON specifices green as 0 so do never reset it here
    grep -q 127 /sys/class/leds/blue/brightness && echo 0 > /sys/class/leds/blue/brightness
    grep -q 255 /sys/class/leds/red/brightness && echo 0 > /sys/class/leds/red/brightness
    return 0
}

# if started with stop arg reset only
[ "$1" == stop ] && F_RESET && exit 0

# pulse forever
while true; do 
    F_ON
    sleep $INTERVALL
    F_OFF
    sleep $INTERVALL
done
