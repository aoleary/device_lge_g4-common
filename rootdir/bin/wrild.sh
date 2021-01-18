#!/system/bin/sh
###################################################################################################
#
# workaround for randomly no SIM on boot (https://github.com/Suicide-Squirrel/issues_oreo/issues/6)
# plus a watchdog for rild high-cpu load in rare cases
#
###################################################################################################

# rild
PRTRIGGER=0
REQRESTART=99
MAXRET=10
RILCHILL=240			# sleep value after RILD has been restarted before continuing

# watchdog ("woof:" in logcat)
DEBUGLOG=0                      # 0: disable debug logging, 1: enable
DOGLOGS=/sdcard/Download/wdlog	# log directory when DEBUGLOG=1, path must be owned and r/w for root
TSCPU=90                        # max allowed cpu usage threshold
TSTIME=60	                # how many secs rild is allowed to consume TSCPU before a restart of rild is triggered
WDFREQ=20	                # check frequency of the watchdog in secs
# The total check amount(!) will be calculated as: TSTIME / WDFREQ
# Examples:
# 60 / 5  = 12 checks over the 60 sec time frame
# 60 / 20 =  3 checks over the 60 sec time frame

# a "|" delimited list of apps/package names (case insensive) which are able to accept/do calls
# if one of these apps are in the foreground(!) the watchdog will skip any actions
# a package name is something like com.microsoft.office.lync15 but office.lync or lync is fully enough as well
CALLAPPS="dialer|call|whatsapp|thoughtcrime.securesms|telegram|challegram|viber|threema|slack|facebook.orca|facebook.mlite|skype|office.lync|microsoft.teams|imoim|tachyon"


# internal watchdog debug mode. never touch this!
WDDEBUG=0
#####################################################################################

# initial value for wrild property
setprop wrild.ril-handling starting

# logging func
F_LOG(){
    # d: DEBUG  e: ERROR  f: FATAL  i: INFO  v: VERBOSE  w: WARN  s: SILENT
    log -t WRILD -p "$1" "${0##*/}: $2"
}

# check for the current RIL and device state
F_RILCHK(){
    CURSTATE=$(getprop gsm.sim.state)
    CUROPER=$(getprop gsm.sim.operator.numeric)
    DBOOTED=$(getprop sys.boot_completed)
    CURANIM=$(getprop init.svc.bootanim)
    ENC=$(getprop ro.crypto.state)
    ENCSTATE=$(getprop vold.decrypt)
    PROPSIM=$(getprop wrild.sim.count)
    if [ -z "$PROPSIM" ];then
        SIMCOUNT=$(logcat -b all -d |egrep "insertedSimCount.*[01]" | egrep -o "[01]" | tail -n1)
        setprop wrild.sim.count $SIMCOUNT
    else
        F_LOG i "using previous detected sim count.."
        SIMCOUNT=$PROPSIM
    fi

    F_LOG "i" "sys.boot_completed >$DBOOTED<"
    F_LOG "i" "gsm.sim.state >$CURSTATE<"
    F_LOG "i" "gsm.sim.operator.numeric >$CUROPER<"
    F_LOG "i" "init.svc.bootanim >$CURANIM<"
    F_LOG "i" "enc, encstate: >$ENC<, >$ENCSTATE<"
    F_LOG "i" "sim count: >$SIMCOUNT<"

    if [ "$CURSTATE" == "READY" ] && [ ! -z "$CUROPER" ]; then
        echo 0
    elif [ "$DBOOTED" != "1" ];then
	echo 7
    elif [ "$CURANIM" != "stopped" ];then
        echo 7
    elif [ "$ENC" == "encrypted" ] && [ "$ENCSTATE" != "trigger_restart_framework" ];then
        echo 7
    elif [ "$CURSTATE" == "PIN_REQUIRED" ]; then
        echo 9
    elif [ "$CURSTATE" == "LOADED" ] && [ -z "$CUROPER" ];then
        F_LOG i "LOADED but no operator yet .. sleeping 25s"
	setprop wrild.ril-handling waiting-for-operatorid
        sleep 25
        echo 1
    elif [ "$CURSTATE" == "LOADED" ] && [ ! -z "$CUROPER" ];then
        echo 0
    elif [ "$SIMCOUNT" == "0" ];then
        echo 42
    else
        F_LOG i "No condition met (yet) .. sleeping 10s"
	setprop wrild.ril-handling no-condition-met
        sleep 10
        echo 1
    fi
}

F_RILRESTART(){
    x=$1
    while [ "$REQRESTART" -ne 0 ];do
        REQRESTART=$(F_RILCHK)
    
        # PIN_REQUIRED means usually the user get prompted - unfortunately 
        # sometimes there is no prompt.
        # this will restart RIL not on the first but every second run only (which should be safe) and
        # let the user enough time to enter the PIN if the prompt appears
        if [ "$REQRESTART" -eq 9 ]&&[ $PRTRIGGER -eq 0 ];then
	    setprop wrild.ril-handling waiting-for-pin
            F_LOG i "PIN_REQUIRED detected. waiting 40s for user input.." && sleep 40
            PRTRIGGER=1
        elif [ "$REQRESTART" -eq 7 ];then
            F_LOG i "Boot (still) in progress ... hanging around for 10s ..." && sleep 10
	    setprop wrild.ril-handling systemboot-in-progress
            x=1
        elif [ "$REQRESTART" -eq 1 ];then
            [ $WDDEBUG == 1 ] && F_LOG e "!!!! DEBUG MODE DEBUG MODE - NO ACTION TAKEN !!!!"
            if [ -d /storage/emulated/0 ];then
                F_LOG w "RIL restart - try $x of $MAXRET"
		setprop wrild.ril-handling restarting-rild
                [ $WDDEBUG == 0 ] && stop ril-daemon
                sleep 1
                [ $WDDEBUG == 0 ] && start ril-daemon
                F_LOG w "restarted RIL daemon as REQRESTART was set to >$REQRESTART<"
		setprop wrild.ril-handling restarting-rild-done
                sleep $RILCHILL
                PRTRIGGER=0
                x=$((x + 1))
            else
                F_LOG w "Skipping restart as /data isn't mounted yet ..." && sleep 5
		setprop wrild.ril-handling data-not-mounted-yet
            fi
        elif [ "$REQRESTART" -eq 9 ] ;then
            F_LOG i "PIN_REQUIRED detected. waiting another minute for user input.." && sleep 60
            x=1
	    setprop wrild.ril-handling waiting-for-pin
        elif [ "$REQRESTART" -eq 0 ] ;then
            F_LOG i "no restart required. RILD seems to work properly already."
	    setprop wrild.ril-handling rild-up
	    break
        elif [ "$REQRESTART" -eq 42 ];then
            F_LOG e "No SIM detected!" && return $REQRESTART
	    setprop wrild.ril-handling no-sim
        else
            F_LOG e "unusual state detected . waiting 20s before another try .." && sleep 20
	    setprop wrild.ril-handling weird-state
        fi
        if [[ $x -eq $MAXRET ]];then
            F_LOG e "auto restart RIL daemon aborted.. too many tries!"
	    setprop wrild.ril-handling too-many-retries
            return 99
        fi
    done
}

# endless sleep
F_DOZE(){
    if [ $WDDEBUG == 0 ];then
        while true; do F_LOG i "Watchdog has been disabled :("  && sleep 86400 ;done
    else
        F_LOG i "woof: DEBUG MODE !!!! Watchdog would have been disabled but as we debug..."
    fi
}

# delay the very first watchdog run
[ $WDDEBUG == 0 ] && F_LOG i "woof: *yawn* ... I think .. I will sleep a bit before actually starting my work (4 min)" && sleep $RILCHILL
[ $WDDEBUG == 1 ] && F_LOG e "woof: !!! DEBUG MODE DEBUG MODE !!! SLEEP DISABLED FOR FIRST WD RUN!"

# restart RIL in defined conditions.
F_RILRESTART 1
RRET=$?

MYPID=$(ps -opid,cmd|grep wrild.sh| egrep -o "[0-9]+")
F_LOG i "RIL handling finished. Going to background with pid >$MYPID<"

# when too many retries (returncode:99) the watchdog does not need to be started
# but we keep wrild running as we are a service
[ $RRET -eq 99 -o $RRET -eq 42 ] && F_DOZE

###############################################################################################
#
# watchdog area
#
###############################################################################################

F_LOG i "woof: watchdog is starting...."

# debug logs - if enabled
[ -d "$DOGLOGS" ] && rm -rf $DOGLOGS
F_LOGRIL(){
    if [ "$DEBUGLOG" -ne 0 ];then
        mkdir $DOGLOGS
        F_LOG i "woof: debug logging started"
        LOGPID=$1
        #TIMESTMP="$(date +%F-%H-%M-%S)"
        TIMESTMP="$(date +%F)"
        logcat -b all -d -D >> $DOGLOGS/${TIMESTMP}_${LOGPID}_logcat.txt \
            && F_LOG w "woof: debug log written: $DOGLOGS/${TIMESTMP}_${LOGPID}_logcat.txt"
        [ $WDDEBUG == 0 ] && logcat -b all -c && F_LOG w "woof: CLEARED LOGCAT" 
        echo -e "\n\n$(date):\n\n $(dmesg -c)" >> $DOGLOGS/${TIMESTMP}_${LOGPID}_dmesg.txt && F_LOG w "woof: debug log written: $DOGLOGS/${TIMESTMP}_${LOGPID}_dmesg.txt"
        echo -e "\n\n$(date):\n\n $(ps -A)" >> $DOGLOGS/${TIMESTMP}_${LOGPID}_ps.txt && F_LOG w "woof: debug log written: $DOGLOGS/${TIMESTMP}_${LOGPID}_ps.txt"
    fi
}

# watch the dog
F_WOOF(){
    DOG="$1"
    F_LOG d "woof: sniffing for $DOG"
    for dog in $(ps -A -opid:1,cmd:4,pcpu:0 | grep -v wrild | grep " $DOG"| tr " " "," | cut -d  "," -f 1,3);do
	#dpid=$(echo "${dog/,*/}"| egrep -o '[0-9]+')
	dpid="${dog/,*/}"
        dcpu=$(printf "%.0f" "${dog/*,/}")
	# if we found a dog which breaks the threshold immediately inform the watch proc & catch logs
	if [ "$dcpu" -ge "$TSCPU" ];then 
            F_LOG w "woof: $dog - current cpu usage: $dcpu %, pid: $dpid"
            echo $dpid && return 3
        fi
    done
    F_LOG d "woof: $DOG is a good doggie (normal CPU usage) ..."
    echo 0 && return 0
}

# bite the dog - but BEWARE OF THE DRAGONS!
F_BITEDOG(){
    DPID=$1

    # dragon: regular phone call
    INACALL=$(dumpsys telephony.registry | egrep -o 'mCallState=.*')
    case $INACALL in
        mCallState=0) # idle
        ;;
        mCallState=1) # ringing
            F_LOG w "woof: will not bite the dog because it barks (ringing)"
            return 3
        ;;
        mCallState=2) # active call
            F_LOG w "woof: will not bite the dog because he would bite back (active call)"
            return 4
        ;;
    esac

    # dragon: 3rd party app with calling support - foreground
    unset CAPP
    CAPP=$(dumpsys window windows | grep mCurrentFocus | egrep -oi "$CALLAPPS" | head -n 1)
    [ ! -z $CAPP ] && F_LOG w "woof: will not bite the dog because he has supercow powers (found a calling app in foreground: $CAPP)" && return 5

    # dragon: 3rd party app within a call - in background
    unset CAPP
    CAPP=$(dumpsys window windows |grep topApp | egrep -i "$CALLAPPS" | egrep -i "voip|call" | head -n 1 | tr -d " ")
    [ ! -z $CAPP ] && F_LOG w "woof: will not bite the dog because he is HIGH (active call in background) ..." && F_LOG w "woof: calling app in background: $CAPP" && return 6

    F_LOG w "woof: woof! saying goodbye to rild? We will see.."
    F_LOGRIL $DPID
    # reset operator id to ensure RIL gets restarted
    [ $WDDEBUG == 0 ] && setprop gsm.sim.operator.numeric ""
    REQRESTART=1 F_RILRESTART 2
    [ $? -eq 99 -o $? -eq 42 ] && F_DOZE
}


# run forever and watch out for dogs
WCNT=$(($TSTIME/WDFREQ))
[ $WDDEBUG == 1 ] && WCNT=2 && TSCPU=0
while true; do
    DOGPID=$(F_WOOF rild)
    WOOFRET=$?
    if [ $WOOFRET -eq 0 ];then
	F_LOG d "woof: all fine ... shhhh... don't wake sleeping dogs ..."
        WCNT=$(($TSTIME/WDFREQ))
    else
	WCNT=$((WCNT - 1))
	if [ "$WCNT" -gt 0 ];then
            [ $WDDEBUG == 1 ] && F_LOG e "woof: !!!! DEBUG MODE DEBUG MODE !!!!"
	    F_LOG i "woof: rild ($DOGPID) eats more CPU than is good for us - over ${TSCPU}% ... (countdown: $WCNT)"
	else
            [ $WDDEBUG == 1 ] && F_LOG e "woof: !!!! DEBUG MODE DEBUG MODE !!!!"
	    # trigger and give it time to come back
	    F_LOG w "woof: the hunt is open! run rild RUN ... (restarting $DOGPID)"
            F_BITEDOG $DOGPID
	    [ $WDDEBUG == 0 ] && sleep 30
            WCNT=$(($TSTIME/WDFREQ))
            [ $WDDEBUG == 1 ] && WCNT=2
	fi
    fi
    [ $WDDEBUG == 1 ] && WDFREQ=5
    sleep $WDFREQ 
done

#############################################################################################
F_LOG f "wtf!? This should never happen!"
