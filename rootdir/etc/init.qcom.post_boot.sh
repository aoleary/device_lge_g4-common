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

        # Temporarily disable thermal core control to switch governors cleanly
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

# Available CPU Freqs in kernel
# Little: 384000 460800 600000 672000 787200 864000 960000 1248000 1440000
# Big: 384000 480000 633600 768000 864000 960000 1248000 1344000 1440000 1536000 1632000 1689600 1824000

# configure governor settings for little cluster
        echo schedutil > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
        echo 250 > /sys/devices/system/cpu/cpufreq/schedutil/up_rate_limit_us
        echo 2500 > /sys/devices/system/cpu/cpufreq/schedutil/down_rate_limit_us
        echo 90 > /sys/devices/system/cpu/cpufreq/schedutil/hispeed_load
        echo 600000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
        echo 1440000 > /sys/devices/system/cpu/cpu0/cpufreq/schedutil/hispeed_freq      #Core 4 Maximum Frequency = 1440MHz

# online CPU4
        echo 1 > /sys/devices/system/cpu/cpu4/online

# configure governor settings for big cluster
        echo schedutil > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor
        echo 120 > /sys/devices/system/cpu/cpufreq/schedutil/up_rate_limit_us
        echo 1500 > /sys/devices/system/cpu/cpufreq/schedutil/down_rate_limit_us
        echo 85 > /sys/devices/system/cpu/cpufreq/schedutil/hispeed_load
        echo 768000 > /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq
        echo 1824000 > /sys/devices/system/cpu/cpu4/cpufreq/schedutil/hispeed_freq      #Core 5 Maximum Frequency = 1824MHz

# plugin remaining A57s
        echo 1 > /sys/devices/system/cpu/cpu5/online

# Sheduler tuning
        echo 90  > /proc/sys/kernel/sched_upmigrate
        echo 80  > /proc/sys/kernel/sched_downmigrate
        echo 9   > /proc/sys/kernel/sched_upmigrate_min_nice
        echo 100 > /proc/sys/kernel/sched_wakeup_load_threshold
        echo 20  > /proc/sys/kernel/sched_small_task
        echo 1   > /proc/sys/kernel/sched_migration_fixup

# Setup uclamp
        echo 5 > /dev/cpuctl/background/cpu.uclamp.max
        echo 30 > /dev/cpuctl/system-background/cpu.uclamp.max
        echo 50 > /dev/cpuctl/foreground/cpu.uclamp.max
        echo 24 > /dev/cpuctl/foreground/cpu.uclamp.min
        echo 5 > /dev/cpuctl/dex2oat/cpu.uclamp.max
        echo max > /dev/cpuctl/top-app/cpu.uclamp.min
        echo 1 > /dev/cpuctl/top-app/cpu.uclamp.latency_sensitive
        echo max > /dev/cpuctl/camera-daemon/cpu.uclamp.min
        echo 1 > /dev/cpuctl/camera-daemon/cpu.uclamp.latency_sensitive

# GPU Input Boost
# Available GPU Freqs in kernel
# 180000000 300000000 367000000 450000000 490000000 600000000
        echo 450000000 > /sys/module/governor_msm_adreno_tz/parameters/boost_freq
        echo 180       > /sys/module/governor_msm_adreno_tz/parameters/boost_duration

    #Tune ZRAM
        echo 80 > /proc/sys/vm/swappiness
        echo 1 >  /proc/sys/vm/overcommit_memory
        echo 1 >  /proc/sys/vm/page-cluster

    # VM tuning
        echo 5 > /proc/sys/vm/dirty_background_ratio
        echo 15 > /proc/sys/vm/dirty_ratio
        echo 1500 > /proc/sys/vm/dirty_expire_centisecs
        echo 1000 > /proc/sys/vm/dirty_writeback_centisecs

    # VM cache behaviour
        echo 0 > /proc/sys/vm/page_cluster
        echo 1 > /proc/sys/vm/stat_interval
        echo 80 > /proc/sys/vm/vfs_cache_pressure

    # PSI / memory pressure tuning
        echo 49152 > /proc/sys/vm/extra_free_kbytes

    # Set allocstall_threshold to 0 (optimized for PSI)
        echo 0 > /sys/module/vmpressure/parameters/allocstall_threshold

    # Minimum free memory before reclaim kicks in
        echo 16384 > /proc/sys/vm/min_free_kbytes

    # Set IO Scheduler parameter
        echo maple > /sys/block/mmcblk0/queue/scheduler

        echo 2 > /sys/block/mmcblk0/queue/iosched/writes_starved
        echo 200 > /sys/block/mmcblk0/queue/iosched/sync_read_expire
        echo 450 > /sys/block/mmcblk0/queue/iosched/sync_write_expire
        echo 300 > /sys/block/mmcblk0/queue/iosched/async_read_expire
        echo 700 > /sys/block/mmcblk0/queue/iosched/async_write_expire
        echo 8 > /sys/block/mmcblk0/queue/iosched/fifo_batch
        echo 10 > /sys/block/mmcblk0/queue/iosched/sleep_latency_multiple
        echo 1 > /sys/block/mmcblk0/queue/iosched/suspend_starved_limit

        echo 70 > /sys/block/mmcblk0/queue/iosched/read_bias_pct
        echo 30 > /sys/block/mmcblk0/queue/iosched/write_bias_pct
        echo 128 > /sys/block/mmcblk0/queue/read_ahead_kb
        echo 64 > /sys/block/mmcblk0/queue/nr_requests
        echo 1 > /sys/block/mmcblk0/queue/rq_affinity
        echo 1 > /sys/block/mmcblk0/queue/nomerges
        echo 0 > /sys/block/mmcblk0/queue/rotational

       echo maple > /sys/block/mmcblk1/queue/scheduler

       echo 1 > /sys/block/mmcblk1/queue/iosched/writes_starved
       echo 250 > /sys/block/mmcblk1/queue/iosched/sync_read_expire
       echo 500 > /sys/block/mmcblk1/queue/iosched/sync_write_expire
       echo 400 > /sys/block/mmcblk1/queue/iosched/async_read_expire
       echo 800 > /sys/block/mmcblk1/queue/iosched/async_write_expire
       echo 8 > /sys/block/mmcblk1/queue/iosched/fifo_batch
       echo 10 > /sys/block/mmcblk1/queue/iosched/sleep_latency_multiple
       echo 1 > /sys/block/mmcblk0/queue/iosched/suspend_starved_limit

       echo 256 > /sys/block/mmcblk1/queue/read_ahead_kb
       echo 32 > /sys/block/mmcblk1/queue/nr_requests
       echo 1 > /sys/block/mmcblk1/queue/rq_affinity
       echo 0 > /sys/block/mmcblk1/queue/nomerges
       echo 0 > /sys/block/mmcblk1/queue/rotational

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

	# Set Memory parameters
        configure_memory_parameters
        restorecon -R /sys/devices/system/cpu

	    # Enable CPU retention
	    echo 1 > /sys/module/lpm_levels/system/a53/cpu0/retention/idle_enabled
	    echo 1 > /sys/module/lpm_levels/system/a53/cpu1/retention/idle_enabled
	    echo 1 > /sys/module/lpm_levels/system/a53/cpu2/retention/idle_enabled
	    echo 1 > /sys/module/lpm_levels/system/a53/cpu3/retention/idle_enabled
	    echo 1 > /sys/module/lpm_levels/system/a57/cpu4/retention/idle_enabled
	    echo 1 > /sys/module/lpm_levels/system/a57/cpu5/retention/idle_enabled

	    # Enable L2 retention
	    echo 1 > /sys/module/lpm_levels/system/a53/a53-l2-retention/idle_enabled
	    echo 0 > /sys/module/lpm_levels/system/a57/a57-l2-retention/idle_enabled

	    # Enable CPU Standalone Power Collapse
	    echo "Y" > /sys/module/lpm_levels/system/a53/cpu0/standalone_pc/idle_enabled
	    echo "Y" > /sys/module/lpm_levels/system/a53/cpu1/standalone_pc/idle_enabled
	    echo "Y" > /sys/module/lpm_levels/system/a53/cpu2/standalone_pc/idle_enabled
	    echo "Y" > /sys/module/lpm_levels/system/a53/cpu3/standalone_pc/idle_enabled
	    echo "N" > /sys/module/lpm_levels/system/a57/cpu4/standalone_pc/idle_enabled
	    echo "N" > /sys/module/lpm_levels/system/a57/cpu5/standalone_pc/idle_enabled

	    # Suspend behavior (battery-optimized
	    echo "Y" > /sys/module/lpm_levels/system/a53/cpu0/standalone_pc/suspend_enabled
	    echo "Y" > /sys/module/lpm_levels/system/a53/cpu1/standalone_pc/suspend_enabled
	    echo "Y" > /sys/module/lpm_levels/system/a53/cpu2/standalone_pc/suspend_enabled
	    echo "Y" > /sys/module/lpm_levels/system/a53/cpu3/standalone_pc/suspend_enabled
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

        # Ensure deep sleep allowed
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

# Fix timekeep restore
/vendor/bin/timekeep restore

# Write heartbeat intervals
settings put global gcm_heartbeat_interval_ms 900000
settings put global gcm_heartbeat_interval_ms_wifi 1800000
