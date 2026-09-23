# LG G4 integrity identity framework
#
# No device-specific identity or Android-version-specific Build properties are defined here.
# The selected device_lge_g4 product remains the single source of truth.

G4_INTEGRITY_DEVICE := $(PRODUCT_DEVICE)
G4_INTEGRITY_NAME := $(PRODUCT_NAME)
G4_INTEGRITY_BRAND := $(PRODUCT_BRAND)
G4_INTEGRITY_MODEL := $(PRODUCT_MODEL)
G4_INTEGRITY_MANUFACTURER := $(PRODUCT_MANUFACTURER)
G4_INTEGRITY_FINGERPRINT := $(BUILD_FINGERPRINT)

# Android release, SDK, security patch and fingerprint remain controlled by
# the selected ROM/product build. Runtime Play Integrity spoofing is outside
# the device tree and remains the responsibility of the runtime component.
