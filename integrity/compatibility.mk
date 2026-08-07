
# Play Integrity CTS compatibility

PRODUCT_COPY_FILES += \
$(LOCAL_PATH)/integrity/cts/permissions.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/lg-g4-cts-permissions.xml \
$(LOCAL_PATH)/integrity/cts/features.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/lg-g4-cts-features.xml

include $(LOCAL_PATH)/integrity/integrity.mk

