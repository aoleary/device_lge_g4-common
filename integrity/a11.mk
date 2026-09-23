# LG G4 Android 11 integrity identity profile
#
# Variant-neutral.
#
# The selected device/lge/g4 product remains authoritative for all
# hardware and build identity values.
#
# This layer exposes the real selected build identity to build-time
# tooling/components. It does not replace the identity with another
# device identity.

G4_INTEGRITY_PROFILE := a11

G4_INTEGRITY_DEVICE := $(PRODUCT_DEVICE)
G4_INTEGRITY_NAME := $(PRODUCT_NAME)
G4_INTEGRITY_MODEL := $(PRODUCT_MODEL)
G4_INTEGRITY_BRAND := $(PRODUCT_BRAND)
G4_INTEGRITY_MANUFACTURER := $(PRODUCT_MANUFACTURER)
G4_INTEGRITY_FINGERPRINT := $(BUILD_FINGERPRINT)

G4_INTEGRITY_RELEASE := $(PLATFORM_VERSION)
G4_INTEGRITY_SDK := $(PLATFORM_SDK_VERSION)
