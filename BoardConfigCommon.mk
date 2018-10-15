#
# Copyright (C) 2015 The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

BOARD_VENDOR := lge

COMMON_PATH := device/lge/g4-common

TARGET_SPECIFIC_HEADER_PATH := $(COMMON_PATH)/include

include $(COMMON_PATH)/PlatformConfig.mk
include $(COMMON_PATH)/board/*.mk

# Filesystem
TARGET_USERIMAGES_USE_F2FS := true
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_EXFAT_DRIVER := sdfat
TARGET_VFAT_DRIVER := sdfat

# HIDL
DEVICE_MANIFEST_FILE := $(COMMON_PATH)/configs/manifest.xml

# Keymaster
TARGET_KEYMASTER_WAIT_FOR_QSEE := true

# Shim libs
TARGET_LD_SHIM_LIBS := \
    /system/vendor/lib/libwvm.so|libshims_wvm.so \
    /system/vendor/lib64/libcneapiclient.so|/system/vendor/lib64/libcne_shim.so \
    /system/vendor/lib64/libril-qc-qmi-1.so|/system/vendor/lib64/rild_socket.so \
    /system/lib64/libmdmcutback.so|libqsap_shim.so \
    /system/lib/libshim_camera.so:/system/lib/libcamera_client.so|libshim_cameraclient.so \
    /system/vendor/lib/libmmcamera_stillmore_lib.so|/system/lib/libcamera_client.so

# inherit from the proprietary version
-include vendor/lge/g4-common/BoardConfigVendor.mk
