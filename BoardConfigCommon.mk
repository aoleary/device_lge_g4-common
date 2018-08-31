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

# RILD
TARGET_PROCESS_SDK_VERSION_OVERRIDE := \
        /vendor/bin/hw/rild=27

#Camera Version Override for Pie
TARGET_PROCESS_SDK_VERSION_OVERRIDE := \
        /system/vendor/bin/mm-qcamera-daemon=24

# Graphics
HAVE_ADRENO_SOURCE:= false
OVERRIDE_RS_DRIVER:= libRSDriver_adreno.so
MAX_EGL_CACHE_KEY_SIZE := 12*1024
MAX_EGL_CACHE_SIZE := 2048*1024
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3
SF_VSYNC_EVENT_PHASE_OFFSET_NS := 5000000
TARGET_FORCE_HWC_FOR_VIRTUAL_DISPLAYS := true
TARGET_USES_C2D_COMPOSITION := true
TARGET_USES_HWC2 := true
TARGET_USES_ION := true
VSYNC_EVENT_PHASE_OFFSET_NS := 7500000

# Gralloc
TARGET_ADDITIONAL_GRALLOC_10_USAGE_BITS := 0x02000000U

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
    /system/vendor/lib/libmmcamera_stillmore_lib.so|/system/lib/libshim_cameraclient.so \
    /system/vendor/lib/hw/camera.msm8992.so|/system/vendor/lib/libfence_shim.so

# inherit from the proprietary version
-include vendor/lge/g4-common/BoardConfigVendor.mk
