TARGET_PROVIDES_CONSUMERIR_HAL := true

PRODUCT_PACKAGES += \
    android.hardware.ir@1.0-impl \
    consumerir.msm8992 

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.consumerir.xml:system/etc/permissions/android.hardware.consumerir.xml
