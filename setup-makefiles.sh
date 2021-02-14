#!/bin/bash
#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017-2020 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

set -e

# Required!
DEVICE_COMMON=g4-common
VENDOR=lge

# Load extractutils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$MY_DIR" ]]; then MY_DIR="$PWD"; fi

ANDROID_ROOT="$MY_DIR/../../.."

HELPER="$ANDROID_ROOT/tools/extract-utils/extract_utils.sh"
if [ ! -f "$HELPER" ]; then
    echo "Unable to find helper script at $HELPER"
    exit 1
fi
. "$HELPER"

# Initialize the helper for common device
setup_vendor "$DEVICE_COMMON" "$VENDOR" "$ANDROID_ROOT" true

# Copyright headers and guards
write_headers "ls991_usu f500_usu h810_usu h811 h812_usu h815 h815_usu h818_usu h819_usu us991_usu vs986_usu"

# Common blobs
write_makefiles "$MY_DIR"/proprietary-files.txt

# We are done with common
write_footers

# Initialize the helper for device
setup_vendor "$DEVICE" "$VENDOR" "$ANDROID_ROOT"

# Copyright headers and guards
write_headers

# The device blobs
write_makefiles "$MY_DIR"/../$DEVICE/proprietary-files.txt

# We are done with device
write_footers
