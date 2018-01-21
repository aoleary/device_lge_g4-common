# RIL
PRODUCT_PACKAGES += \
    android.hardware.radio@1.0-impl \
    android.hardware.radio@1.0-service \
    android.hardware.radio.deprecated@1.0-impl \
    android.hardware.radio.deprecated@1.0-service \
    libsecril-client-sap \
    libprotobuf-cpp-full \
    rild_socket \
    libxml2

PRODUCT_PROPERTY_OVERRIDES += \
    rild.libpath=/vendor/lib64/libril-qc-qmi-1.so \
    ril.subscription.types=NV,RUIM

PRODUCT_PROPERTY_OVERRIDES += \
    persist.data.mode=concurrent \
    persist.data.netmgrd.qos.enable=true \
    persist.data.qmi.adb_logmask=0 \
    persist.qcril.disable_retry=true \
    persist.radio.apm_sim_not_pwdn=1 \
    persist.radio.custom_ecc=1 \
    persist.radio.sib16_support=1 \
    ro.data.large_tcp_window_size=true \
    ro.use_data_netmgrd=true \
    ro.telephony.default_network=12 \
    ro.ril.svlte1x=false \
    ro.ril.svdo=false \
    persist.radio.add_power_save=1 \
    persist.telephony.oosisdc=false

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.telephony.gsm.xml:system/etc/permissions/android.hardware.telephony.gsm.xml \
    frameworks/native/data/etc/android.hardware.telephony.cdma.xml:system/etc/permissions/android.hardware.telephony.cdma.xml \
    $(LOCAL_PATH)/configs/qcril.db:system/etc/motorola/qcril.db \
    $(LOCAL_PATH)/configs/qmi_fw.conf:/system/etc/qmi_fw.conf \
    $(LOCAL_PATH)/configs/ctbk_val.cfg:/system/etc/motorola/mdmctbk/ctbk_val.cfg
