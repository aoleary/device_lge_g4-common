#!/system/bin/sh
###################################################################################################
#
# workaround for randomly no SIM on boot (https://github.com/Suicide-Squirrel/issues_oreo/issues/6)
#
###################################################################################################
x=1
PRTRIGGER=0
REQRESTART=99
MAXRET=50

# logging func
F_LOG(){
    # d: DEBUG  e: ERROR  f: FATAL  i: INFO  v: VERBOSE  w: WARN  s: SILENT
    log -t WRILD -p "$1" "${0}: $2"
}

# check for the current RIL state
F_RILCHK(){
    CURSTATE=$(getprop gsm.sim.state)
    CUROPER=$(getprop gsm.sim.operator.numeric)
    F_LOG "i" "gsm.sim.state >$CURSTATE<"
    F_LOG "i" "gsm.sim.operator.numeric >$CUROPER<"

    if [ "$CURSTATE" == "READY" ]; then
        echo 0
    elif  [ "$CURSTATE" == "PIN_REQUIRED" ]; then
        echo 9
    elif [ "$CURSTATE" == "LOADED" ] && [ -z "$CUROPER" ];then
        echo 1
    elif [ "$CURSTATE" == "LOADED" ] && [ ! -z "$CUROPER" ];then
        echo 0
    else
        echo 1
    fi
}

while [ "$REQRESTART" -ne 0 ];do
    REQRESTART=$(F_RILCHK)

    # PIN_REQUIRED means usually the user get prompted - unfortunately 
    # sometimes there is no prompt.
    # this will restart RIL not on the first but every second run only (which should be safe) and
    # let the user enough time to enter the PIN if the prompt appears
    if [ "$REQRESTART" -eq 9 ]&&[ $PRTRIGGER -eq 0 ];then
        F_LOG i "PIN_REQUIRED detected. waiting 10s for user input.." && sleep 10
        PRTRIGGER=1
    elif [ "$REQRESTART" -eq 1 ];then
        F_LOG w "RIL restart - try $x of $MAXRET"
        stop real-ril-daemon
        sleep 1
        start real-ril-daemon
        F_LOG w "restarted RIL daemon as REQRESTART was set to >$REQRESTART<"
        sleep 20
        PRTRIGGER=0
    elif [ "$REQRESTART" -eq 9 ] ;then
        F_LOG i "PIN_REQUIRED detected. waiting another 20s for user input.." && sleep 20
    elif [ "$REQRESTART" -eq 0 ] ;then
        F_LOG i "no restart required. RILD seems to work properly already." && break
    else
        F_LOG e "unusual state detected . waiting 10s and will try again .." && sleep 20
    fi
    x=$((x + 1))
    if [[ $x -eq $MAXRET ]];then
        F_LOG e "auto restart RIL daemon aborted.. too many tries!"
        break
    fi
done

MYPID=$(ps -opid,cmd|grep wrild.sh| egrep -o "[0-9]+")
F_LOG i "RIL should be fine now. Going to background with pid >$MYPID<"

# run forever
while true; do sleep 86400; done

F_LOG f "killed?!"
