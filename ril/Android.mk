RIL_PATH := $(call my-dir)

#ifeq ($(RIL_PATH),$(call project-path-for,qcom-ril))
include $(call first-makefiles-under,$(RIL_PATH))
#endif
