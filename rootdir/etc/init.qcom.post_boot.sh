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

        # Give services time to settle
        sleep 3

        # ==============================
        # CPU GOVERNOR CONFIGURATION
        # ==============================

        # Big cluster online
        echo 1 > /sys/devices/system/cpu/cpu4/online
        echo 1 > /sys/devices/system/cpu/cpu5/online

        # Shared schedutil tuning (balanced)
        echo 0    > /sys/devices/system/cpu/cpufreq/schedutil/up_rate_limit_us
        echo 2000 > /sys/devices/system/cpu/cpufreq/schedutil/down_rate_limit_us
        echo 85   > /sys/devices/system/cpu/cpufreq/schedutil/hispeed_load

        # Hispeed frequencies (prevent unnecessary big jumps)
        echo 1440000 > /sys/devices/system/cpu/cpu0/cpufreq/schedutil/hispeed_freq
        echo 1824000 > /sys/devices/system/cpu/cpu4/cpufreq/schedutil/hispeed_freq

        # ==============================
        # INPUT BOOST (Short + Efficient)
        # ==============================

        echo 1  > /sys/module/cpu_boost/parameters/input_boost_enabled
        echo "0:960000 1:960000 2:960000 3:960000 4:1248000 5:1248000" \
        > /sys/module/cpu_boost/parameters/input_boost_freq
        echo 45  > /sys/module/cpu_boost/parameters/input_boost_ms
        echo 0   > /sys/module/cpu_boost/parameters/boost_ms

        # Moderate scheduler boost bias
        echo 35 > /sys/module/cpu_boost/parameters/dynamic_stune_boost

        # ==============================
        # GPU BOOST (Shortened)
        # ==============================

        echo 450000000 > /sys/module/governor_msm_adreno_tz/parameters/boost_freq
        echo 180       > /sys/module/governor_msm_adreno_tz/parameters/boost_duration

        # ==============================
        # RPS Static Configuration
        # ==============================

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

        # ==============================
        # MEMORY / VM ALIGNMENT
        # ==============================

        echo 10     > /proc/sys/vm/watermark_scale_factor
        echo 32768  > /proc/sys/vm/extra_free_kbytes
        echo 16384  > /proc/sys/vm/min_free_kbytes
        echo 16     > /sys/module/vmpressure/parameters/allocstall_threshold
        echo 2      > /proc/sys/vm/kswapd_threads
        echo 0      > /proc/sys/vm/stat_interval

        # ==============================
        # UCLAMP
        # ==============================

        echo 5   > /dev/cpuctl/background/cpu.uclamp.max
        echo 40  > /dev/cpuctl/system-background/cpu.uclamp.max
        echo 62  > /dev/cpuctl/foreground/cpu.uclamp.max
        echo 34  > /dev/cpuctl/foreground/cpu.uclamp.min
        echo 5   > /dev/cpuctl/dex2oat/cpu.uclamp.max
        echo max > /dev/cpuctl/top-app/cpu.uclamp.min
        echo 1   > /dev/cpuctl/top-app/cpu.uclamp.latency_sensitive
        echo max > /dev/cpuctl/camera-daemon/cpu.uclamp.min
        echo 1   > /dev/cpuctl/camera-daemon/cpu.uclamp.latency_sensitive

        # ==============================
        # RE-ENABLE THERMAL CONTROL
        # ==============================

        echo 1 > /sys/module/msm_thermal/core_control/enabled

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
