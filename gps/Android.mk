ifneq ($(TARGET_GPS_HAL_PATH),)
    GPS_DIRS=core utils libloc_api_50001
    include $(call all-named-subdir-makefiles,$(GPS_DIRS))
endif
