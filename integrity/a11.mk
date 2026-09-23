# LG G4 Android 11 build identity contract
#
# Variant-neutral.
#
# The selected device_lge_g4 product remains authoritative for:
#   PRODUCT_DEVICE
#   PRODUCT_NAME
#   PRODUCT_MODEL
#   PRODUCT_BRAND
#   PRODUCT_MANUFACTURER
#   BUILD_FINGERPRINT
#
# This file deliberately does not replace or fabricate LG Android 11
# fingerprints. The G4 did not receive an official Android 11 build.
#
# Runtime attestation/property handling is intentionally outside the
# device tree.

G4_A11_IDENTITY_LAYER := 1
G4_A11_IDENTITY_VARIANT_NEUTRAL := 1
G4_A11_IDENTITY_PRESERVE_PRODUCT := 1
