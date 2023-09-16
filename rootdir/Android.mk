LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)

# Device init scripts

include $(CLEAR_VARS)
LOCAL_MODULE       := fstab.qcom
LOCAL_MODULE_TAGS  := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_SRC_FILES    := etc/fstab.qcom
LOCAL_MODULE_PATH  := $(TARGET_OUT_VENDOR_ETC)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE       := init.qcom.rc
LOCAL_MODULE_TAGS  := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_SRC_FILES    := etc/init.qcom.rc
LOCAL_MODULE_PATH  := $(TARGET_OUT_VENDOR_ETC)/init/hw
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE       := init.qcom.power.rc
LOCAL_MODULE_TAGS  := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_SRC_FILES    := etc/init.qcom.power.rc
LOCAL_MODULE_PATH  := $(TARGET_OUT_VENDOR_ETC)/init/hw
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE       := init.qcom.usb.rc
LOCAL_MODULE_TAGS  := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_SRC_FILES    := etc/init.qcom.usb.rc
LOCAL_MODULE_PATH  := $(TARGET_OUT_VENDOR_ETC)/init/hw
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE       := ueventd.qcom.rc
LOCAL_MODULE_STEM  := ueventd.rc
LOCAL_MODULE_TAGS  := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_SRC_FILES    := etc/ueventd.qcom.rc
LOCAL_MODULE_PATH  := $(TARGET_OUT_VENDOR_ETC)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE       := sysctl.rc
LOCAL_MODULE_TAGS  := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_SRC_FILES    := etc/sysctl.rc
LOCAL_MODULE_PATH  := $(TARGET_OUT_VENDOR_ETC)/init
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE       := sysctl.conf
LOCAL_MODULE_TAGS  := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_SRC_FILES    := etc/sysctl.conf
LOCAL_MODULE_PATH  := $(TARGET_VENDOR_OUT_ETC)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE       := init.safailnet.rc
LOCAL_MODULE_TAGS  := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_SRC_FILES    := etc/init.safailnet.rc
LOCAL_MODULE_PATH  := $(TARGET_OUT_VENDOR_ETC)/init/hw
include $(BUILD_PREBUILT)

# Configuration scripts

include $(CLEAR_VARS)
LOCAL_MODULE	    := wrild.sh
LOCAL_MODULE_TAGS   := optional
LOCAL_MODULE_CLASS  := EXECUTABLES
LOCAL_SRC_FILES	    := bin/wrild.sh
LOCAL_MODULE_PATH   := $(TARGET_OUT_VENDOR_EXECUTABLES)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE        := pulse.sh
LOCAL_MODULE_TAGS   := optional
LOCAL_MODULE_CLASS  := EXECUTABLES
LOCAL_SRC_FILES     := bin/pulse.sh
LOCAL_MODULE_PATH   := $(TARGET_OUT_VENDOR_EXECUTABLES)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE        := init.qcom.coex.sh
LOCAL_MODULE_TAGS   := optional
LOCAL_MODULE_CLASS  := ETC
LOCAL_SRC_FILES     := etc/init.qcom.coex.sh
LOCAL_MODULE_PATH   := $(TARGET_OUT_VENDOR_EXECUTABLES)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE        := init.qcom.fm.sh
LOCAL_MODULE_TAGS   := optional
LOCAL_MODULE_CLASS  := ETC
LOCAL_SRC_FILES     := etc/init.qcom.fm.sh
LOCAL_MODULE_PATH   := $(TARGET_OUT_VENDOR_EXECUTABLES)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE        := init.qcom.post_boot.sh
LOCAL_MODULE_TAGS   := optional
LOCAL_MODULE_CLASS  := ETC
LOCAL_SRC_FILES     := etc/init.qcom.post_boot.sh
LOCAL_MODULE_PATH   := $(TARGET_OUT_VENDOR_EXECUTABLES)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE        := init.qcom.uicc.sh
LOCAL_MODULE_TAGS   := optional
LOCAL_MODULE_CLASS  := ETC
LOCAL_SRC_FILES     := etc/init.qcom.uicc.sh
LOCAL_MODULE_PATH   := $(TARGET_OUT_VENDOR_EXECUTABLES)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE	    := init.class_main.sh
LOCAL_MODULE_TAGS   := optional
LOCAL_MODULE_CLASS  := ETC
LOCAL_SRC_FILES	    := etc/init.class_main.sh
LOCAL_MODULE_PATH   := $(TARGET_OUT_VENDOR_EXECUTABLES)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE	    := init.msm8992.sensor.sh
LOCAL_MODULE_TAGS   := optional
LOCAL_MODULE_CLASS  := ETC
LOCAL_SRC_FILES	    := etc/init.msm8992.sensor.sh
LOCAL_MODULE_PATH   := $(TARGET_OUT_VENDOR_EXECUTABLES)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE        := init.baseband.sh
LOCAL_MODULE_TAGS   := optional
LOCAL_MODULE_CLASS  := ETC
LOCAL_SRC_FILES     := etc/init.baseband.sh
LOCAL_MODULE_PATH   := $(TARGET_OUT_VENDOR_EXECUTABLES)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE        := init.qcom.usb.sh
LOCAL_MODULE_TAGS   := optional
LOCAL_MODULE_CLASS  := ETC
LOCAL_SRC_FILES     := etc/init.qcom.usb.sh
LOCAL_MODULE_PATH   := $(TARGET_OUT_VENDOR_EXECUTABLES)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE        := init.qcom.qseecomd.sh
LOCAL_MODULE_TAGS   := optional
LOCAL_MODULE_CLASS  := ETC
LOCAL_SRC_FILES     := etc/init.qcom.qseecomd.sh
LOCAL_MODULE_PATH   := $(TARGET_OUT_VENDOR_EXECUTABLES)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE        := init.qcom.bt.sh
LOCAL_MODULE_TAGS   := optional
LOCAL_MODULE_CLASS  := ETC
LOCAL_SRC_FILES     := etc/init.qcom.bt.sh
LOCAL_MODULE_PATH   := $(TARGET_OUT_VENDOR_EXECUTABLES)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE       := set_tasks.sh
LOCAL_MODULE_TAGS  := optional
LOCAL_MODULE_CLASS := EXECUTABLES
LOCAL_SRC_FILES    := etc/set_tasks.sh
LOCAL_VENDOR_MODULE    := true
include $(BUILD_PREBUILT)
