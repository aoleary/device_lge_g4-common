# QC Perf
PRODUCT_PROPERTY_OVERRIDES += \
    persist.timed.enable=true \
    ro.qualcomm.cabl=2 \
    ro.qualcomm.perf.cores_online=2 \
    ro.vendor.extension_library=libqti-perfd-client.so \
    persist.dpm.feature=1 \
    ro.min_freq_0=384000 \
    ro.min_freq_4=384000
