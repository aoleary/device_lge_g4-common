#!/system/bin/sh
# ----------------------------------------
# g4_idle_tune_v4_extreme.sh
# Extreme idle enforcement profile
# ----------------------------------------

LOGFILE=/cache/g4_idle_tune_v4_extreme.log

echo "$(date) START" > "$LOGFILE"

sleep 20

# ----------------------------------------
# Very aggressive GCM / MicroG heartbeat
# ----------------------------------------
# Mobile: 90 min
# Wi-Fi : 120 min
settings put global gcm_heartbeat_interval_ms 5400000
settings put global gcm_heartbeat_interval_ms_wifi 7200000

# ----------------------------------------
# Wi-Fi / BLE suppression
# ----------------------------------------
settings put global wifi_scan_always_enabled 0
settings put global ble_scan_always_enabled 0
settings put global wifi_sleep_policy 2
settings put global wifi_networks_available_notification_on 0

WIFI_IFACE="$(iw dev 2>/dev/null | awk '/Interface/ {print $2; exit}')"
[ -z "$WIFI_IFACE" ] && WIFI_IFACE="wlan0"

if command -v iw >/dev/null 2>&1; then
    iw dev "$WIFI_IFACE" set power_save on 2>/dev/null
fi

for f in \
    /sys/module/wlan/parameters/enable_power_save \
    /sys/module/wlan/parameters/power_save \
    /sys/module/qcacld/parameters/gEnableBmps \
    /sys/module/qcacld/parameters/gEnableImps \
    /sys/module/qcacld/parameters/gEnablePowerSaveOffload \
    /sys/module/qcacld3/parameters/gEnableBmps \
    /sys/module/qcacld3/parameters/gEnableImps \
    /sys/module/qcacld3/parameters/gEnablePowerSaveOffload
do
    [ -f "$f" ] && echo 1 > "$f" 2>/dev/null
done

# ----------------------------------------
# App standby / jobs / sync / doze
# Very aggressive but still syntactically safe
# ----------------------------------------
settings put global app_standby_enabled 1
settings put global app_idle_constants "active_to=300000,working_set_to=900000,frequent_to=1800000,rare_to=7200000,restricted_to=14400000"

settings put global job_scheduler_constants "min_ready_cpu_only_jobs_count=4,min_ready_non_active_jobs_count=4,heavy_use_factor=1.0,moderate_use_factor=0.8"

settings put global sync_manager_constants "max_sync_retry_time_in_seconds=7200"

settings put global device_idle_constants "light_after_inactive_to=60000,light_idle_to=120000,light_idle_factor=2.0,light_max_idle_to=600000,min_light_maintenance_time=5000,inactive_to=600000,sensing_to=120000,locating_to=15000,motion_inactive_to=300000,idle_after_inactive_to=900000,idle_pending_to=120000,max_idle_pending_to=300000,idle_pending_factor=2.0,quick_doze_delay_to=10000,idle_to=1800000,max_idle_to=21600000,idle_factor=2.0,min_time_to_alarm=3600000"

# ----------------------------------------
# Telephony props
# ----------------------------------------
setprop persist.qcril.disable_retry true
setprop persist.radio.apm_sim_not_pwdn 1

# ----------------------------------------
# Standby buckets: cage the worst offenders
# ----------------------------------------
for APP in \
    org.microg.gms \
    com.google.android.gms \
    org.kman.AquaMail \
    com.android.vending \
    com.whatsapp \
    org.telegram.plus \
    mega.privacy.android.app \
    com.google.android.apps.messaging \
    com.fsck.k9 \
    com.google.android.apps.photos \
    com.touchtype.swiftkey
do
    am set-standby-bucket "$APP" restricted 2>/dev/null
done

# Keep launcher a bit saner if needed
am set-standby-bucket bitpit.launcher frequent 2>/dev/null

# ----------------------------------------
# Hard background restrictions
# ----------------------------------------
for APP in \
    org.microg.gms \
    com.google.android.gms \
    org.kman.AquaMail \
    com.android.vending \
    com.whatsapp \
    org.telegram.plus \
    mega.privacy.android.app \
    com.google.android.apps.messaging \
    com.fsck.k9 \
    com.google.android.apps.photos \
    com.touchtype.swiftkey
do
    cmd appops set "$APP" RUN_ANY_IN_BACKGROUND ignore 2>/dev/null
    cmd appops set "$APP" RUN_IN_BACKGROUND ignore 2>/dev/null
    cmd appops set "$APP" WAKE_LOCK ignore 2>/dev/null
done

# ----------------------------------------
# Optional: force idle states harder
# Note: these do not persist, but help test behavior
# ----------------------------------------
cmd deviceidle disable false 2>/dev/null
cmd deviceidle enable 2>/dev/null

# ----------------------------------------
# Snapshot
# ----------------------------------------
echo "gcm_mobile=$(settings get global gcm_heartbeat_interval_ms 2>/dev/null)" >> "$LOGFILE"
echo "gcm_wifi=$(settings get global gcm_heartbeat_interval_ms_wifi 2>/dev/null)" >> "$LOGFILE"
echo "app_idle=$(settings get global app_idle_constants 2>/dev/null)" >> "$LOGFILE"
echo "jobs=$(settings get global job_scheduler_constants 2>/dev/null)" >> "$LOGFILE"
echo "syncs=$(settings get global sync_manager_constants 2>/dev/null)" >> "$LOGFILE"
echo "doze=$(settings get global device_idle_constants 2>/dev/null)" >> "$LOGFILE"
echo "wifi_ps=$(iw dev "$WIFI_IFACE" get power_save 2>/dev/null | awk '{print $3}')" >> "$LOGFILE"
echo "qcril_disable_retry=$(getprop persist.qcril.disable_retry)" >> "$LOGFILE"
echo "apm_sim_not_pwdn=$(getprop persist.radio.apm_sim_not_pwdn)" >> "$LOGFILE"

for APP in \
    org.microg.gms \
    com.google.android.gms \
    org.kman.AquaMail \
    com.android.vending \
    com.whatsapp \
    org.telegram.plus \
    mega.privacy.android.app
do
    echo "bucket_$APP=$(am get-standby-bucket "$APP" 2>/dev/null)" >> "$LOGFILE"
done

echo "$(date) END" >> "$LOGFILE"
exit 0
