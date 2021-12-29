# Copyright 2016 The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.02
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

LOCAL_PATH := $(call my-dir)

# QSAP
include $(CLEAR_VARS)
LOCAL_SRC_FILES := libqsap_shim.c
LOCAL_SHARED_LIBRARIES := libqsap_sdk liblog
LOCAL_C_INCLUDES := $(COMMON_PATH)/softap/sdk
LOCAL_MODULE := libqsap_shim
LOCAL_MODULE_TAGS := optional
LOCAL_PROPRIETARY_MODULE := true
include $(BUILD_SHARED_LIBRARY)

# cameraclient
include $(CLEAR_VARS)
LOCAL_SRC_FILES := cameraclient_shim.cpp
LOCAL_MODULE := libshim_cameraclient
LOCAL_MODULE_TAGS := optional
include $(BUILD_SHARED_LIBRARY)

# Fence
include $(CLEAR_VARS)
LOCAL_SRC_FILES := fence.cpp
LOCAL_MODULE := libfence_shim
LOCAL_MODULE_TAGS := optional
LOCAL_PROPRIETARY_MODULE := true
LOCAL_VENDOR_MODULE := true
include $(BUILD_SHARED_LIBRARY)

# RTP
include $(CLEAR_VARS)
LOCAL_SRC_FILES := rtp.cpp
LOCAL_MODULE := ims_rtp_shim
LOCAL_MODULE_TAGS := optional
LOCAL_PROPRIETARY_MODULE := true
LOCAL_CFLAGS_arm64 := -DLIBSHIMS_64BIT
include $(BUILD_SHARED_LIBRARY)

# Slim_shim
include $(CLEAR_VARS)
LOCAL_SRC_FILES := slim_shim.cpp
LOCAL_MODULE := slim_shim
LOCAL_MODULE_TAGS := optional
LOCAL_PROPRIETARY_MODULE := true
LOCAL_VENDOR_MODULE := true
LOCAL_CFLAGS_arm64 := -DLIBSHIMS_64BIT
include $(BUILD_SHARED_LIBRARY)

# Pthread
include $(CLEAR_VARS)
LOCAL_SRC_FILES := pthread_shim.cpp
LOCAL_SHARED_LIBRARIES := liblog
LOCAL_C_INCLUDES := $(TOP)/bionic/libc/bionic/
LOCAL_C_INCLUDES += $(TOP)/bionic/libstdc++/include
LOCAL_C_INCLUDES += $(TOP)/bionic/libc
LOCAL_C_INCLUDES += $(TOP)/bionic/libc/async_safe/include
LOCAL_MODULE := libpthread_shim
LOCAL_MODULE_TAGS := optional
LOCAL_PROPRIETARY_MODULE := true
include $(BUILD_SHARED_LIBRAR)
