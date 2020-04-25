#ADB Debugging
persist.sys.usb.config=mtp,adb
ro.adb.secure=0
ro.debuggable=1

# Audio
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.audio.sdk.fluencetype=fluencepro \
    persist.vendor.audio.fluence.audiorec=false \
    persist.vendor.audio.fluence.speaker=false \
    persist.vendor.audio.fluence.voicecall=true \
    persist.vendor.audio.fluence.voicecomm=true \
    persist.vendor.audio.fluence.voicerec=false \
    persist.speaker.prot.enable=true \
    ro.config.vc_call_vol_steps=7 \
    persist.vendor.audio.calfile0=/etc/acdbdata/Bluetooth_cal.acdb \
    persist.vendor.audio.calfile1=/etc/acdbdata/General_cal.acdb \
    persist.vendor.audio.calfile2=/etc/acdbdata/Global_cal.acdb \
    persist.vendor.audio.calfile3=/etc/acdbdata/Handset_cal.acdb \
    persist.vendor.audio.calfile4=/etc/acdbdata/Hdmi_cal.acdb \
    persist.vendor.audio.calfile5=/etc/acdbdata/Headset_cal.acdb \
    persist.vendor.audio.calfile6=/etc/acdbdata/Speaker_cal.acdb \
    persist.spkr.cal.duration=0 \
    ro.qc.sdk.audio.ssr=false \
    persist.audio.ssr.3mic=true \
    av.offload.enable=false \
    audio.offload.buffer.size.kb=32 \
    audio.offload.pcm.16bit.enable=false \
    audio.offload.gapless.enabled=false \
    audio.offload.passthrough=false \
    audio.offload.pcm.24bit.enable=true \
    audio.offload.multiple.enabled=false \
    audio.deep_buffer.media=true \
    tunnel.audio.encode=false \
    use.dedicated.device.for.voip=true \
    af.fast_track_multiplier=1 \
    audio_hal.period_size=192 \
    ro.audio.flinger_standbytime_ms=300 \
    use.voice.path.for.pcm.voip=false \
    ro.config.media_vol_steps=25 \
    ro.config.vc_call_vol_steps=7

# Bluetooth
PRODUCT_PROPERTY_OVERRIDES += \
    bluetooth.chip.vendor=brcm \
    qcom.bluetooth.soc=rome \
    ro.bt.bdaddr_path="/data/misc/bluetooth/bdaddr" \
    persist.bt.enableAptXHD=true

# Blur - Diable Blur in A12+
ro.surface_flinger.supports_background_blur=0
ro.sf.blurs_are_expensive=0
ro.launcher.blur.appLaunch=0

# Boot animation
TARGET_SCREEN_HEIGHT := 2560
TARGET_SCREEN_WIDTH := 1440
TARGET_BOOT_ANIMATION_RES := 1440

# Camera
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.camera.hal1.packagelist=com.skype.raider,com.instagram.android \
    ro.qc.sdk.camera.facialproc=false \
    ro.qc.sdk.gestures.camera=false \
    camera2.portability.force_api=1 \
    persist.camera.video.ubwc=0 \
    persist.camera.HAL3.enabled=1 \
    persist.ts.postmakeup=false \
    persist.ts.rtmakeup=false \
    camera.no_navigation_bar=true \
    ro.factorytest=0 \
# Enable low power video mode for 4K encode
    vidc.debug.perf.mode=2 \
    vidc.enc.dcvs.extra-buff-count=2

# Configstore
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    ro.surface_flinger.force_hwc_copy_for_virtual_displays=true \
    ro.surface_flinger.max_frame_buffer_acquired_buffers=3 \
    ro.surface_flinger.max_virtual_display_dimension=2048 \
    ro.surface_flinger.use_color_management=true

# DRM
PRODUCT_PROPERTY_OVERRIDES += \
    drm.service.enabled=true

# Dalvik
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.heapstartsize=8m \
    dalvik.vm.heapgrowthlimit=256m \
    dalvik.vm.heapsize=512m \
    dalvik.vm.heaptargetutilization=0.75 \
    dalvik.vm.heapminfree=512m \
    dalvik.vm.heapmaxfree=8m \
    dalvik.vm.dex2oat64.enabled=true

# Dexopt (try not to use big cores during dexopt)
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.boot-dex2oat-threads=4 \
    dalvik.vm.dex2oat-threads=4 \
    dalvik.vm.image-dex2oat-threads=4 \
    pm.dexopt.first-boot=quicken \
    pm.dexopt.bg-dexopt=everything \
    pm.dexopt.boot=verify \
    pm.dexopt.install=quicken \
    dalvik.vm.image-dex2oat-filter=speed \
    ro.vendor.qti.am.reschedule_service=true

# Display
PRODUCT_PROPERTY_OVERRIDES += \
    ro.sf.lcd_density=560 \
    qemu.hw.mainkeys=0 \
    ro.qualcomm.cabl=2 \
    ro.config.avoid_gfx_accel=true
# MSM8992 HAL settings
# 196610 is decimal for 0x30002 to report major/minor versions as 3/2
PRODUCT_PROPERTY_OVERRIDES += \
    debug.mdpcomp.logs=0 \
    persist.debug.wfd.enable=1 \
    persist.demo.hdmirotationlock=false \
    persist.hwc.enable_vds=1 \
    persist.hwc.mdpcomp.enable=true \
    persist.mdpcomp.4k2kSplit=1 \
    persist.mdpcomp_perfhint=50 \
    persist.metadata_dynfps.disable=true \
    persist.sys.ui.hw=1 \
    persist.sys.wfd.virtual=0 \
    ro.opengles.version=196610 \
    ro.sf.compbypass.enable=0

# Fling Velocity
PRODUCT_PROPERTY_OVERRIDES += \
    ro.min.fling_velocity=50 \
    ro.max.fling_velocity=20000

# FRP
PRODUCT_PROPERTY_OVERRIDES += \
    ro.frp.pst=/dev/block/bootdevice/by-name/persistent

# GPS
PRODUCT_PROPERTY_OVERRIDES += \
    persist.gps.qc_nlp_in_use=1 \
    persist.loc.nlp_name=com.qualcomm.services.location \
    ro.gps.agps_provider=1 \
    ro.qc.sdk.izat.premium_enabled=0 \
    ro.qc.sdk.izat.service_mask=0x0

#INTERNET: improve download/upload performance
PRODUCT_PROPERTY_OVERRIDES += \
    net.tcp.buffersize.default=4096,87380,256960,4096, 16384,256960 \
    net.tcp.buffersize.wifi=4096,87380,256960,4096,163 84,256960 \
    net.tcp.buffersize.umts=4096,87380,256960,4096,163 84,256960 \
    net.tcp.buffersize.gprs=4096,87380,256960,4096,163 84,256960 \
    net.tcp.buffersize.edge=4096,87380,256960,4096,163 84,256960 \
    net.rmnet0.dns1=8.8.8.8 \
    net.rmnet0.dns2=8.8.4.4 \
    net.dns1=1.1.1.1\
    net.dns2=9.9.9.9

# LMKD
PRODUCT_PROPERTY_OVERRIDES +=
        pm.dexopt.downgrade_after_inactive_days=7 \
	ro.lmk.critical_upgrade=true \
	ro.lmk.upgrade_pressure=40 \
	ro.lmk.downgrade_pressure=60 \
	ro.lmk.use_psi=false

# Media
PRODUCT_PROPERTY_OVERRIDES += \
    persist.media.treble_omx=false \
    mm.enable.qcom_parser=3379827 \
    mm.enable.smoothstreaming=true \
    media.aac_51_output_enabled=true \
    media.stagefright.legacyencoder=true
    media.stagefright.less-secure=true
    vidc.debug.level=1 \
    vidc.debug.perf.mode=2 \
    vidc.enc.dcvs.extra-buff-count=2 \
    persist.camera.cpp.duplication=false \
    ro.config.avoid_gfx_accel=true

# Perf
PRODUCT_PROPERTY_OVERRIDES += \
    persist.dpm.feature=1 \
    persist.timed.enable=true \
    ro.qualcomm.cabl=2 \
    ro.qualcomm.perf.cores_online=2 \
    ro.vendor.extension_library=libqti-perfd-client.so \
    ro.min_freq_0=384000 \
    ro.min_freq_4=384000 \
    ro.vold.umsdirtyratio=50

# Properties for Surfaceflinger
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    debug.sf.early.app.duration=24000000 \
    debug.sf.early.sf.duration=30000000 \
    debug.sf.earlyGl.app.duration=24000000 \
    debug.sf.earlyGl.sf.duration=30000000 \
    debug.sf.hwc.min.duration=23000000 \
    debug.sf.late.app.duration=24000000 \
    debug.sf.late.sf.duration=30000000

# Properties to improve rendering
    debug.composition.type=gpu \
    debug.cpurend.vsync=false \
    debug.enable.sglscale=1 \
    debug.enabletr=true \
    debug.egl.profiler=1 \
    debug.egl.hw=1 \
    debug.enabletr=true \
    debug.overlayui.enable=1 \
    debug.performance.tuning=1 \
    debug.qctwa.preservebuf=1 \
    debug.sf.hw=1 \
    debug.sf.disable_hwc=0 \
    debug.sf.enable_gl_backpressure=1 \
    debug.sf.recomputecrop=0 \
    debug.sf.disable_backpressure=1 \
    debug.sf.latch_unsignaled=0 \
    dev.pm.dyn_samplingrate=1 \
    hw3d.force=1 \
    persist.hwc.ptor.enable=true \
    persist.sys.composition.type=gpu \
    ro.fb.mode=1 \
    video.accelerate.hw=1 \
    debug.hwui.renderer=opengl \
    renderthread.skia.reduceopstasksplitting=true \
    debug.renderengine.backend=skiaglthreaded

#Properties to improve gaming experiance
PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.NV_FPSLIMIT=60 \
    persist.sys.NV_POWERMODE=1 \
    persist.sys.NV_PROFVER=15 \
    persist.sys.NV_STEREOCTRL=0 \
    persist.sys.NV_STEREOSEPCHG=0 \
    persist.sys.NV_STEREOSEP=20 \
    persist.sys.purgeable_assets=1 \
    ro.media.dec.jpeg.memcap=8000000 \
    ro.media.enc.hprof.vid.bps=8000000 \
    ro.media.dec.aud.wma.enabled=1 \
    ro.media.dec.vid.wmv.enabled=1 \
    ro.media.cam.preview.fps=0 \
    ro.media.codec_priority_for_thumb=so

# RIL
PRODUCT_PROPERTY_OVERRIDES += \
    rild.libpath=/vendor/lib64/libril-qc-qmi-1.so \
    ril.subscription.types=NV,RUIM \
    persist.data.mode=concurrent \
    persist.data.netmgrd.qos.enable=true \
    persist.data.qmi.adb_logmask=0 \
    persist.qcril.disable_retry=true \
    persist.radio.apm_sim_not_pwdn=1 \
    persist.radio.custom_ecc=1 \
    persist.radio.sib16_support=1 \
    ro.data.large_tcp_window_size=true \
    ro.use_data_netmgrd=true \
    ro.ril.svlte1x=false \
    ro.ril.svdo=false \
    persist.telephony.oosisdc=false \
    #Improve Speech Quality
    ro.ril.enable.amr.wideband=1

# RIL Powersaving
    persist.radio.add_power_save=1 \
    pm.sleep_mode=1 \
    ro.ril.disable.power.collapse=0 \
    ro.ril.fast.dormancy.rule=1 \
    ro.ril.fast.dormancy.timeout=3 \
    ro.mot.eri.losalert.delay=1000

# Security patch level
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.build.security_patch=2017-07-01

# Sensors
PRODUCT_PROPERTY_OVERRIDES += \
    ro.qc.sdk.sensors.gestures=true \
    persist.debug.sensors.hal=e \
    debug.qualcomm.sns.daemon=e \
    debug.qualcomm.sns.hal=e \
    debug.qualcomm.sns.libsensor1=e

# Shutdown
PRODUCT_PROPERTY_OVERRIDES += \
    sys.vendor.shutdown.waittime=500 \
    ro.build.shutdown_timeout=0

# Storage
PRODUCT_PROPERTY_OVERRIDES += \
    ro.sys.sdcardfs=true

# UI Smoothening
persist.service.lgospd.enable=0
persist.service.pcsync.enable=0

# WiFi Scan Interval (default = 15s)
PRODUCT_PROPERTY_OVERRIDES += \
    wifi.supplicant_scan_interval=600

# Zygote preforking
PRODUCT_PROPERTY_OVERRIDES += \
    persist.device_config.runtime_native.usap_pool_enabled=true
