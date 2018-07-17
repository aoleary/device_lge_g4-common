#!/system/bin/sh
# Copyright (c) 2012-2017, The Linux Foundation. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of The Linux Foundation nor
#       the names of its contributors may be used to endorse or promote
#       products derived from this software without specific prior written
#       permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NON-INFRINGEMENT ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# LGE_CHANGE_S, [LGE_DATA][LGP_DATA_TCPIP_NSRM]
targetProd=`getprop ro.product.name`
case "$targetProd" in
    "z2_lgu_kr" | "p1_lgu_kr" | "z2_skt_kr" | "p1_skt_kr" | "p1_kt_kr" | "p1_bell_ca" | "p1_rgs_ca" | "p1_tls_ca")
    mkdir /data/connectivity/
    chown system.system /data/connectivity/
    chmod 775 /data/connectivity/
    mkdir /data/connectivity/nsrm/
    chown system.system /data/connectivity/nsrm/
    chmod 775 /data/connectivity/nsrm/
    cp /system/etc/dpm/nsrm/NsrmConfiguration.xml /data/connectivity/nsrm/
    chown system.system /data/connectivity/nsrm/NsrmConfiguration.xml
    chmod 775 /data/connectivity/nsrm/NsrmConfiguration.xml
    ;;
esac
# LGE_CHANGE_E, [LGE_DATA][LGP_DATA_TCPIP_NSRM]

target=`getprop ro.board.platform`
case "$target" in
    "msm8992")
        touch /dev/soundtrigger_dma_drv
        chmod 0660 /dev/soundtrigger_dma_drv
        chown media:media /dev/soundtrigger_dma_drv
        touch /dev/socket/perfd
        chmod 0777 /dev/socket/perfd
        # disable thermal bcl hotplug to switch governor
        echo 0 > /sys/module/msm_thermal/core_control/enabled
        for mode in /sys/devices/soc.0/qcom,bcl.*/mode
        do
            echo -n disable > $mode
        done
        for hotplug_mask in /sys/devices/soc.0/qcom,bcl.*/hotplug_mask
        do
            bcl_hotplug_mask=`cat $hotplug_mask`
            echo 0 > $hotplug_mask
        done
        for hotplug_soc_mask in /sys/devices/soc.0/qcom,bcl.*/hotplug_soc_mask
        do
            bcl_soc_hotplug_mask=`cat $hotplug_soc_mask`
            echo 0 > $hotplug_soc_mask
        done
        for mode in /sys/devices/soc.0/qcom,bcl.*/mode
        do
            echo -n enable > $mode
        done

        # ensure at most one A57 is online when thermal hotplug is disabled
        echo 0 > /sys/devices/system/cpu/cpu5/online
        # online CPU4
        echo 1 > /sys/devices/system/cpu/cpu4/online
        echo conservative > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor
        # configure CPU0
        echo blu_active > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
        echo 960000 > /sys/devices/system/cpu/cpu0/cpufreq/blu_active/hispeed_freq
        # restore A57's max
        cat /sys/devices/system/cpu/cpu4/cpufreq/cpuinfo_max_freq > /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq
        # plugin remaining A57s
        echo 1 > /sys/devices/system/cpu/cpu5/online
        # Restore CPU 4 max freq from msm_performance
        echo "4:1632000 5:1632000" > /sys/module/msm_performance/parameters/cpu_max_freq
	# input boost,cpu boost
	echo 0:672000 1:0 2:0 3:0 4:480000 5:0 > /sys/module/cpu_boost/parameters/input_boost_freq
        # multi boost configuration
        echo 0:672000 > /sys/module/cpu_boost/parameters/multi_boost_freq

        # Setting b.L scheduler parameters
        echo 1 > /proc/sys/kernel/sched_migration_fixup
        echo 30 > /proc/sys/kernel/sched_small_task
        echo 20 > /proc/sys/kernel/sched_mostly_idle_load
        echo 3 > /proc/sys/kernel/sched_mostly_idle_nr_run
        echo 99 > /proc/sys/kernel/sched_upmigrate
        echo 85 > /proc/sys/kernel/sched_downmigrate
        echo 400000 > /proc/sys/kernel/sched_freq_inc_notify
        echo 400000 > /proc/sys/kernel/sched_freq_dec_notify
        echo 70 > /proc/sys/vm/dirty_background_ratio
        echo 1000 > /proc/sys/vm/dirty_expire_centisecs
        echo 100 > /proc/sys/vm/swappiness
        #enable rps static configuration
        echo 8 >  /sys/class/net/rmnet_ipa0/queues/rx-0/rps_cpus
        for devfreq_gov in /sys/class/devfreq/qcom,cpubw*/governor
        do
            echo "bw_hwmon" > $devfreq_gov
        done
		for devfreq_gov in /sys/class/devfreq/qcom,mincpubw*/governor
        do
            echo "cpufreq" > $devfreq_gov
        done

        # Disable sched_boost
        # echo 0 > /proc/sys/kernel/sched_boost

		# Set Memory parameters
        configure_memory_parameters
        restorecon -R /sys/devices/system/cpu

	    # Disable CPU retention
	    echo 0 > /sys/module/lpm_levels/system/a53/cpu0/retention/idle_enabled
	    echo 0 > /sys/module/lpm_levels/system/a53/cpu1/retention/idle_enabled
	    echo 0 > /sys/module/lpm_levels/system/a53/cpu2/retention/idle_enabled
	    echo 0 > /sys/module/lpm_levels/system/a53/cpu3/retention/idle_enabled
	    echo 0 > /sys/module/lpm_levels/system/a57/cpu4/retention/idle_enabled
	    echo 0 > /sys/module/lpm_levels/system/a57/cpu5/retention/idle_enabled

	    # Disable L2 retention
	    echo 0 > /sys/module/lpm_levels/system/a53/a53-l2-retention/idle_enabled
	    echo 0 > /sys/module/lpm_levels/system/a57/a57-l2-retention/idle_enabled

	    # Disable CPU Standalone Power Collapse
	    echo "N" > /sys/module/lpm_levels/system/a53/cpu0/standalone_pc/idle_enabled
	    echo "N" > /sys/module/lpm_levels/system/a53/cpu1/standalone_pc/idle_enabled
	    echo "N" > /sys/module/lpm_levels/system/a53/cpu2/standalone_pc/idle_enabled
	    echo "N" > /sys/module/lpm_levels/system/a53/cpu3/standalone_pc/idle_enabled
	    echo "N" > /sys/module/lpm_levels/system/a57/cpu4/standalone_pc/idle_enabled
	    echo "N" > /sys/module/lpm_levels/system/a57/cpu5/standalone_pc/idle_enabled
	    echo "N" > /sys/module/lpm_levels/system/a53/cpu0/standalone_pc/suspend_enabled
	    echo "N" > /sys/module/lpm_levels/system/a53/cpu1/standalone_pc/suspend_enabled
	    echo "N" > /sys/module/lpm_levels/system/a53/cpu2/standalone_pc/suspend_enabled
	    echo "N" > /sys/module/lpm_levels/system/a53/cpu3/standalone_pc/suspend_enabled
	    echo "N" > /sys/module/lpm_levels/system/a57/cpu4/standalone_pc/suspend_enabled
	    echo "N" > /sys/module/lpm_levels/system/a57/cpu5/standalone_pc/suspend_enabled

        # re-enable thermal and BCL hotplug
        echo 1 > /sys/module/msm_thermal/core_control/enabled
        for mode in /sys/devices/soc.0/qcom,bcl.*/mode
        do
            echo -n disable > $mode
        done
        for hotplug_mask in /sys/devices/soc.0/qcom,bcl.*/hotplug_mask
        do
            echo $bcl_hotplug_mask > $hotplug_mask
        done
        for hotplug_soc_mask in /sys/devices/soc.0/qcom,bcl.*/hotplug_soc_mask
        do
            echo $bcl_soc_hotplug_mask > $hotplug_soc_mask
        done
        for mode in /sys/devices/soc.0/qcom,bcl.*/mode
        do
            echo -n enable > $mode
        done

        # enable low power mode sleep
        echo 0 > /sys/module/lpm_levels/parameters/sleep_disabled
    ;;
esac

case "$target" in
    "msm8226" | "msm8974" | "msm8610" | "apq8084" | "mpq8092" | "msm8610" | "msm8916" | "msm8994" | "msm8992")
        # Let kernel know our image version/variant/crm_version
        image_version="10:"
        image_version+=`getprop ro.build.id`
        image_version+=":"
        image_version+=`getprop ro.build.version.incremental`
        image_variant=`getprop ro.product.name`
        image_variant+="-"
        image_variant+=`getprop ro.build.type`
        oem_version=`getprop ro.build.version.codename`
        echo 10 > /sys/devices/soc0/select_image
        echo $image_version > /sys/devices/soc0/image_version
        echo $image_variant > /sys/devices/soc0/image_variant
        echo $oem_version > /sys/devices/soc0/image_crm_version
        ;;
esac

# Enable QDSS agent if QDSS feature is enabled
# on a non-commercial build.  This allows QDSS
# debug tracing.
if [ -c /dev/coresight-stm ]; then
    build_variant=`getprop ro.build.type`
    if [ "$build_variant" != "user" ]; then
        # Test: Is agent present?
        if [ -f /data/qdss/qdss.agent.sh ]; then
            # Then tell agent we just booted
           /system/bin/sh /data/qdss/qdss.agent.sh on.boot &
        fi
    fi
fi

# workaround for randomly no SIM on boot (https://github.com/Suicide-Squirrel/issues_oreo/issues/6)
x=1
PRTRIGGER=0
REQRESTART=$(getprop gsm.sim.state)
while [ "$REQRESTART" != "READY" ];do
 
    # PIN_REQUIRED means usually the user get prompted - unfortunately 
    # sometimes there is no prompt.
    # this will restart RIL not on the first but every second run only (which should be safe) and
    # let the user enough time to enter the PIN if the prompt appears
    if [ "$REQRESTART" == "PIN_REQUIRED" ]&&[ $PRTRIGGER -eq 0 ];then
        echo "$0: PIN_REQUIRED detected. waiting 30s for user input.." >> /dev/kmsg && sleep 30
        PRTRIGGER=1
    else
        echo "$0: RIL restart - try $x of 20" >> /dev/kmsg
        stop ril-daemon
        sleep 2
        start ril-daemon
        echo "$0: restarted RIL daemon as gsm.sim.state was >$REQRESTART<" >> /dev/kmsg
        sleep 30
        PRTRIGGER=0
    fi
    REQRESTART=$(getprop gsm.sim.state)
    x=$((x + 1))
    if [[ $x -eq 20 ]];then
	echo "$0: auto restart RIL daemon aborted.. too many tries!" >> /dev/kmsg
        break
    fi
done
echo "$0: gsm.sim.state >$REQRESTART<" >> /dev/kmsg
echo "$0: ended" >> /dev/kmsg
# < END workaround

