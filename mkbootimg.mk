#
# Custom mkbootimg.mk for H815
#


#pick this into system/tools/mkbootimg
#https://review.lineageos.org/c/LineageOS/android_system_tools_mkbootimg/+/433617

LOCAL_PATH := $(call my-dir)

# Path to custom mkbootimg with --dt support
LOCAL_MKBOOTIMG := $(LOCAL_PATH)/mkbootimg/mkbootimg.py

# Path to device tree image
INSTALLED_DTIMAGE_TARGET := $(PRODUCT_OUT)/dt.img

INSTALLED_KERNEL_TARGET := $(PRODUCT_OUT)/kernel


# Rule to build dt.img with dtbTool_lgg4
$(INSTALLED_DTIMAGE_TARGET): $(INSTALLED_KERNEL_TARGET) | dtbTool_lgg4
	$(call pretty,"Building device tree image: $@")
	$(hide) $(HOST_OUT_EXECUTABLES)/dtbTool_lgg4 -o $@ -s 2048 -p $(KERNEL_OUT)/scripts/dtc/ $(KERNEL_OUT)/arch/arm64/boot/dts/

# Boot image
$(INSTALLED_BOOTIMAGE_TARGET): $(LOCAL_MKBOOTIMG) $(INTERNAL_BOOTIMAGE_FILES) $(BOOTIMAGE_EXTRA_DEPS) $(INSTALLED_DTIMAGE_TARGET)
	$(call pretty,"Target boot image: $@")
	$(hide) $(LOCAL_MKBOOTIMG) \
		$(INTERNAL_BOOTIMAGE_ARGS) \
		$(INTERNAL_MKBOOTIMG_VERSION_ARGS) \
		$(BOARD_MKBOOTIMG_ARGS) \
		--dt $(INSTALLED_DTIMAGE_TARGET) \
		--kernel $(INSTALLED_KERNEL_TARGET) \
		--output $@
	$(hide) $(call assert-max-image-size,$@,$(BOARD_BOOTIMAGE_PARTITION_SIZE))

# Recovery image
$(INSTALLED_RECOVERYIMAGE_TARGET): $(recoveryimage-deps) $(RECOVERYIMAGE_EXTRA_DEPS) $(INSTALLED_DTIMAGE_TARGET)
	$(call pretty,"Target recovery image: $@")
	$(hide) $(LOCAL_MKBOOTIMG) \
		$(INTERNAL_RECOVERYIMAGE_ARGS) \
		$(INTERNAL_MKBOOTIMG_VERSION_ARGS) \
		$(BOARD_MKBOOTIMG_ARGS) \
		--dt $(INSTALLED_DTIMAGE_TARGET) \
		--output $@
	$(hide) $(call assert-max-image-size,$@,$(BOARD_RECOVERYIMAGE_PARTITION_SIZE))
