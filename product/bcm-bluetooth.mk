PRODUCT_PROPERTY_OVERRIDES += \
    bluetooth.chip.vendor=brcm \
    qcom.bluetooth.soc=rome \
    ro.bt.bdaddr_path="/data/misc/bluetooth/bdaddr" \
    persist.bt.enableAptXHD=true

# Bluetooth
PRODUCT_PACKAGES += \
    hwaddrs \
    libprotobuf-cpp-full


PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:system/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:system/etc/permissions/android.hardware.bluetooth_le.xml
