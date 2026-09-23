# LG G4 integrity compatibility layer
#
# Variant-neutral.
# device/lge/g4 remains authoritative for product identity.

include $(LOCAL_PATH)/integrity/integrity.mk

ifeq ($(PLATFORM_VERSION),11)
include $(LOCAL_PATH)/integrity/a11.mk
endif
