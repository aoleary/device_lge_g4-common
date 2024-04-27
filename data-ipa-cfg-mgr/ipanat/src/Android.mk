ifneq (,$(filter $(QCOM_BOARD_PLATFORMS),$(TARGET_BOARD_PLATFORM)))
ifneq (, $(filter aarch64 arm arm64, $(TARGET_ARCH)))

LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_C_INCLUDES := $(LOCAL_PATH)/../inc
LOCAL_C_INCLUDES += $(LOCAL_PATH)

LOCAL_HEADER_LIBRARIES := generated_kernel_headers

LOCAL_SRC_FILES := ipa_nat_drv.c \
                   ipa_nat_drvi.c

LOCAL_CFLAGS := -DDEBUG
LOCAL_CFLAGS += \
    -Wno-unused-parameter

LOCAL_MODULE := libipanat
LOCAL_MODULE_TAGS := optional
LOCAL_PRELINK_MODULE := false
LOCAL_VENDOR_MODULE := true
#LOCAL_CLANG := false

include $(BUILD_SHARED_LIBRARY)

endif # $(TARGET_ARCH)
endif
