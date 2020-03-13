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

# Available Freqs in kernel
# Little: 384000 460800 600000 672000 787200 864000 960000 1248000 1440000
# Big: 384000 480000 633600 768000 864000 960000 1248000 1344000 1440000 1536000 1632000 1689600 1824000

        # ensure at most one A57 is online when thermal hotplug is disabled
        echo 0 > /sys/devices/system/cpu/cpu5/online
        # online CPU4
        echo 1 > /sys/devices/system/cpu/cpu4/online
        echo tripndroid > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor
        # configure CPU0
        echo tripndroid > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
        # restore A57's max
        cat /sys/devices/system/cpu/cpu4/cpufreq/cpuinfo_max_freq > /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq
        # plugin remaining A57s
        echo 1 > /sys/devices/system/cpu/cpu5/online
        # Restore CPU 4 max freq from msm_performance
        echo "4:1632000 5:1632000" > /sys/module/msm_performance/parameters/cpu_max_freq
	# input boost,cpu boost
	echo 0:787200 1:0 2:0 3:0 4:480000 5:0 > /sys/module/cpu_boost/parameters/input_boost_freq
        echo 20 > /sys/module/cpu_boost/parameters/boost_ms
        echo 40 > /sys/module/cpu_boost/parameters/input_boost_ms

        # multi boost configuration
        echo 0:787200 > /sys/module/cpu_boost/parameters/multi_boost_freq

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

# LowMemKiller (LMK)
# set lowmemory killer (LMK) profile. Set in PAGES (i.e. 4KB)
# to set e.g. 50 MB: (50*1024)/4 = 12800 <-- so 12800 is the value to set
#
# Foreground Applications (FA):
#	The application currently shown on the screen and running.
# Visible Applications (VA):
#	Applications that might not be shown on the screen currently, but are still running.
#	They might be hidden behind an overlay or have a transparent window.
# Secondary Server (SSRV):
#	Services running in the background and needed for Apps to function properly.
#	This category includes Google Play Services for example.
# Hidden Applications (HA):
#	Applications that are hidden from the user, but are running in the background.
# Content Providers (CP):
#	These are the services providing content to the system like contacts provider, location provider etc.
# Empty Applications (EA):
#	This category contains Applications that the user exited, but Android still keeps in RAM.
#	They do not steal any CPU time or cause any power drain.
#
# (source: https://www.droidviews.com/tweak-android-low-memory-killer-needs/)
#
# Example values:
# 	115200 = 450 MB
#	76800  = 300 MB
#	51200  = 200 MB
#	35840  = 140 MB
#	30720  = 120 MB
#	25600  = 100 MB
#	17920  =  70 MB
#	12800  =  50 MB
#	10240  =  40 MB
#	7680   =  30 MB
#	5120   =  20 MB
#
# Example for LOS default (LG G4):
#      8777,10971,13165,15360,26331,38400

# MEMTOTAL_MB calculates the detected RAM and set different profiles based on the findings.
MEMTOTAL_MB="$(($(grep -i memtotal /proc/meminfo  | egrep -o '[0-9]+') / 1024))"
if [ "$MEMTOTAL_MB" -ge "2800" ];then
    #      FA  , VA  , SSRV,  HA ,  CP  , EA
    echo '7680,10240,30720,51200,30720,76800' > /sys/module/lowmemorykiller/parameters/minfree
elif [ "$MEMTOTAL_MB" -ge "2000" ];then
    #      FA  , VA  , SSRV,  HA ,  CP  , EA
    echo '7680,10240,25600,30720,25600,51200' > /sys/module/lowmemorykiller/parameters/minfree
fi
# skip setting a LMK profile when we have *NO* finding (i.e. using the default)

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


