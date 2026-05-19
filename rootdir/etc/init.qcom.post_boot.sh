#!/system/bin/sh
# Copyright (c) 2012-2017, The Linux Foundation. All rights reserved.
#
# Consolidated msm8992 post-boot tuning
# Goal: balanced profile with a battery bias
# Stack: schedutil + PSI + ZRAM + Maple I/O
# Big cores are NOT forced online at boot. They should ramp only when needed.

# --------------------------------------------------
# helpers
# --------------------------------------------------
logi() {
    echo "[post_boot] $1" > /dev/kmsg
}

write_if_exists() {
    local node="$1"
    local val="$2"
    if [ -e "$node" ]; then
        echo "$val" > "$node"
    fi
}

chmod_if_exists() {
    local mode="$1"
    local node="$2"
    if [ -e "$node" ]; then
        chmod "$mode" "$node"
    fi
}

chown_if_exists() {
    local owner="$1"
    local node="$2"
    if [ -e "$node" ]; then
        chown "$owner" "$node"
    fi
}

set_schedutil_cluster() {
    local cpu="$1"
    local hispeed="$2"
    local base="/sys/devices/system/cpu/${cpu}/cpufreq/schedutil"

    write_if_exists "${base}/hispeed_freq" "$hispeed"
}

set_maple_param() {
    local node="$1"
    local val="$2"
    write_if_exists "/sys/block/mmcblk0/queue/iosched/${node}" "$val"
}

target="$(getprop ro.board.platform)"

# --------------------------------------------------
# legacy LGE nsrm block kept intact
# --------------------------------------------------
targetProd="$(getprop ro.product.name)"
case "$targetProd" in
    "z2_lgu_kr" | "p1_lgu_kr" | "z2_skt_kr" | "p1_skt_kr" | "p1_kt_kr" | "p1_bell_ca" | "p1_rgs_ca" | "p1_tls_ca")
        mkdir /data/connectivity/ 2>/dev/null
        chown system.system /data/connectivity/ 2>/dev/null
        chmod 775 /data/connectivity/ 2>/dev/null
        mkdir /data/connectivity/nsrm/ 2>/dev/null
        chown system.system /data/connectivity/nsrm/ 2>/dev/null
        chmod 775 /data/connectivity/nsrm/ 2>/dev/null
        cp /system/etc/dpm/nsrm/NsrmConfiguration.xml /data/connectivity/nsrm/ 2>/dev/null
        chown system.system /data/connectivity/nsrm/NsrmConfiguration.xml 2>/dev/null
        chmod 775 /data/connectivity/nsrm/NsrmConfiguration.xml 2>/dev/null
    ;;
esac

case "$target" in
    "msm8992")
        logi "starting consolidated msm8992 post_boot"

        # Give framework/services a moment to settle
        sleep 3

        # --------------------------------------------------
        # basic nodes / permissions
        # --------------------------------------------------
        [ -e /dev/soundtrigger_dma_drv ] || touch /dev/soundtrigger_dma_drv
        chmod_if_exists 0660 /dev/soundtrigger_dma_drv
        chown_if_exists media:media /dev/soundtrigger_dma_drv

        [ -e /dev/socket/perfd ] || touch /dev/socket/perfd
        chmod_if_exists 0777 /dev/socket/perfd

        # --------------------------------------------------
        # big cores policy
        # --------------------------------------------------
        # Do NOT force cpu4/cpu5 online here.
        # Let the kernel bring them in under load.
        # Keep thermal/core control enabled so hotplug policy can work.
        write_if_exists /sys/module/msm_thermal/core_control/enabled 1

        logi "cpu online before tuning: $(cat /sys/devices/system/cpu/online 2>/dev/null)"
        logi "cpu offline before tuning: $(cat /sys/devices/system/cpu/offline 2>/dev/null)"

        # --------------------------------------------------
        # schedutil tuning
        # --------------------------------------------------
        # Battery-biased balanced profile:
        # fast ramp up for touch/UI bursts, slower drop for stability,
        # but no forced big cluster wake-up.
        write_if_exists /sys/devices/system/cpu/cpu0/cpufreq/schedutil/up_rate_limit_us 500
        write_if_exists /sys/devices/system/cpu/cpu0/cpufreq/schedutil/down_rate_limit_us 12000
        write_if_exists /sys/devices/system/cpu/cpu0/cpufreq/schedutil/hispeed_load 90

        # cluster-specific hispeed limits
        # little: enough for UI
        # big: doesnt actually activate via this parameter
        set_schedutil_cluster cpu0 1248000

        # Optional policy min floors
        write_if_exists /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq 384000
        write_if_exists /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq 384000

        # --------------------------------------------------
        # scheduler core thresholds (from target_config.sh, integrated)
        # --------------------------------------------------
        write_if_exists /proc/sys/kernel/sched_util_clamp_min 0
        write_if_exists /proc/sys/kernel/sched_small_task 20
        write_if_exists /proc/sys/kernel/sched_init_task_load 0
        write_if_exists /proc/sys/kernel/sched_spill_nr_run 3
        write_if_exists /proc/sys/kernel/sched_mostly_idle_load 20

        # --------------------------------------------------
        # uclamp
        # --------------------------------------------------
        # Battery-biased ceilings for background groups.
        write_if_exists /dev/cpuctl/background/cpu.uclamp.max 5
        write_if_exists /dev/cpuctl/system-background/cpu.uclamp.max 35
        write_if_exists /dev/cpuctl/foreground/cpu.uclamp.max 60
        write_if_exists /dev/cpuctl/foreground/cpu.uclamp.min 10
        write_if_exists /dev/cpuctl/dex2oat/cpu.uclamp.max 40
        write_if_exists /dev/cpuctl/top-app/cpu.uclamp.min 20
        write_if_exists /dev/cpuctl/top-app/cpu.uclamp.max max
        write_if_exists /dev/cpuctl/top-app/cpu.uclamp.latency_sensitive 1
        write_if_exists /dev/cpuctl/camera-daemon/cpu.uclamp.min 40
        write_if_exists /dev/cpuctl/camera-daemon/cpu.uclamp.max max
        write_if_exists /dev/cpuctl/camera-daemon/cpu.uclamp.latency_sensitive 1

        # --------------------------------------------------
        # cpu input boost
        # --------------------------------------------------
        # Keep short and modest. Avoid long residency on big cluster.
        write_if_exists /sys/module/cpu_boost/parameters/input_boost_enabled 1
        write_if_exists /sys/module/cpu_boost/parameters/input_boost_freq "0:960000 1:960000 2:960000 3:960000 4:0 5:0"
        write_if_exists /sys/module/cpu_boost/parameters/input_boost_ms 40
        write_if_exists /sys/module/cpu_boost/parameters/boost_ms 0
        write_if_exists /sys/module/cpu_boost/parameters/dynamic_stune_boost 20

        # --------------------------------------------------
        # gpu boost
        # --------------------------------------------------
        # Light touch. Enough to avoid obvious frame hiccups.
        write_if_exists /sys/module/governor_msm_adreno_tz/parameters/boost_freq 315000000
        write_if_exists /sys/module/governor_msm_adreno_tz/parameters/boost_duration 60

        # --------------------------------------------------
        # zram / vm / reclaim
        # --------------------------------------------------
        write_if_exists /sys/block/zram0/max_comp_streams 4
        write_if_exists /sys/block/zram0/comp_algorithm lz4

        write_if_exists /proc/sys/vm/swappiness 100
        write_if_exists /proc/sys/vm/page-cluster 0
        write_if_exists /proc/sys/vm/overcommit_memory 1

        write_if_exists /proc/sys/vm/watermark_scale_factor 10
        write_if_exists /proc/sys/vm/extra_free_kbytes 24576
        write_if_exists /proc/sys/vm/min_free_kbytes 12288
        write_if_exists /proc/sys/vm/kswapd_threads 1
        write_if_exists /proc/sys/vm/stat_interval 30
        write_if_exists /proc/sys/vm/vfs_cache_pressure 80
        write_if_exists /proc/sys/vm/dirty_background_ratio 5
        write_if_exists /proc/sys/vm/dirty_ratio 15
        write_if_exists /proc/sys/vm/dirty_expire_centisecs 1500
        write_if_exists /proc/sys/vm/dirty_writeback_centisecs 1500

        write_if_exists /sys/module/vmpressure/parameters/allocstall_threshold 16

        # --------------------------------------------------
        # block I/O: Maple
        # --------------------------------------------------
        # init.qcom.rc currently uses noop very early for boot speed.
        # Here we switch to Maple for normal runtime.
	write_if_exists /sys/block/mmcblk0/queue/scheduler maple

	write_if_exists /sys/block/mmcblk0/queue/iosched/fifo_batch 8
	write_if_exists /sys/block/mmcblk0/queue/iosched/writes_starved 2
	write_if_exists /sys/block/mmcblk0/queue/iosched/sync_read_expire 120
	write_if_exists /sys/block/mmcblk0/queue/iosched/sync_write_expire 180
	write_if_exists /sys/block/mmcblk0/queue/iosched/async_read_expire 80
	write_if_exists /sys/block/mmcblk0/queue/iosched/async_write_expire 150
	write_if_exists /sys/block/mmcblk0/queue/iosched/sleep_latency_multiple 4

	write_if_exists /sys/block/mmcblk0/queue/read_ahead_kb 128
	write_if_exists /sys/block/mmcblk0/queue/nr_requests 64
	write_if_exists /sys/block/mmcblk0/queue/rq_affinity 2
	write_if_exists /sys/block/mmcblk0/queue/nomerges 1

        # --------------------------------------------------
        # memory bandwidth / devfreq
        # --------------------------------------------------
        for devfreq_gov in /sys/class/devfreq/qcom,cpubw*/governor; do
            [ -e "$devfreq_gov" ] && echo "bw_hwmon" > "$devfreq_gov"
        done

        for devfreq_gov in /sys/class/devfreq/qcom,mincpubw*/governor; do
            [ -e "$devfreq_gov" ] && echo "cpufreq" > "$devfreq_gov"
        done

        # modest RPS, keep it cheap
        write_if_exists /sys/class/net/rmnet_ipa0/queues/rx-0/rps_cpus 8

        # --------------------------------------------------
        # memory helper from stock post_boot, keep if available
        # --------------------------------------------------
        if type configure_memory_parameters >/dev/null 2>&1; then
            configure_memory_parameters
        fi

        restorecon -R /sys/devices/system/cpu 2>/dev/null

        # --------------------------------------------------
        # deep sleep
        # --------------------------------------------------
        write_if_exists /sys/module/lpm_levels/parameters/sleep_disabled 0

        logi "cpu online after tuning: $(cat /sys/devices/system/cpu/online 2>/dev/null)"
        logi "cpu offline after tuning: $(cat /sys/devices/system/cpu/offline 2>/dev/null)"
        logi "finished consolidated msm8992 post_boot"
    ;;
esac

case "$target" in
    "msm8226" | "msm8974" | "msm8610" | "apq8084" | "mpq8092" | "msm8916" | "msm8994" | "msm8992")
        image_version="10:"
        image_version+="$(getprop ro.build.id)"
        image_version+=":"
        image_version+="$(getprop ro.build.version.incremental)"
        image_variant="$(getprop ro.product.name)"
        image_variant+="-"
        image_variant+="$(getprop ro.build.type)"
        oem_version="$(getprop ro.build.version.codename)"

        setprop ro.qcimage.version "$image_version"
        setprop ro.qcimage.variant "$image_variant"
        setprop ro.qcimage.crm_version "$oem_version"
    ;;
esac
