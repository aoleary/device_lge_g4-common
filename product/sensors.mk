PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/sensors/sensor_def_common.conf:system/etc/sensors/sensor_def_common.conf \
    $(LOCAL_PATH)/sensors/sensor_def_variable.conf:system/etc/sensors/sensor_def_variable.conf \
    $(LOCAL_PATH)/sensors/hals.conf:system/etc/sensors/hals.conf

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:system/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:system/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:system/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepcounter.xml:system/etc/permissions/android.hardware.sensor.stepcounter.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepdetector.xml:system/etc/permissions/android.hardware.sensor.stepdetector.xml
