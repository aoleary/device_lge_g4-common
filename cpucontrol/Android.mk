LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE    := cpucontrol

LOCAL_MODULE_TAGS := optional

LOCAL_SRC_FILES := cpucontrol.c
LOCAL_STATIC_LIBRARIES := liblog

include $(BUILD_EXECUTABLE)


