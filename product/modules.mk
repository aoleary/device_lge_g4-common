# Kernel modules dependencies
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/modules/mcDrvModule.ko:/system/lib/modules/mcDrvModule.ko \
    $(LOCAL_PATH)/configs/modules/mcKernelApi.ko:/system/lib/modules/mcKernelApi.ko
