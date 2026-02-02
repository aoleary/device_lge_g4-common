/*
 * Copyright (C) 2026 The LineageOS Project
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#pragma once

#include <aidl/android/hardware/ir/ConsumerIrFreqRange.h>
#include <vector>
/*
 * Board specific nodes
 *
 * If your device exposes these controls in another place, you can either
 * symlink to the locations given here, or override this header in your
 * device tree.
 */

// LG specific defines
#define IR_DEVICE "/dev/ttyHSL1"
#define LG_IR_BAUD_RATE 115200
#define CIR_DRIVER_LIB "libcir_driver.so"
namespace aidl::android::hardware::ir {

inline const std::vector<ConsumerIrFreqRange> kCarrierFreqRanges = {
    {30000, 30000},
    {33000, 33000},
    {36000, 36000},
    {38000, 38000},
    {40000, 40000},
    {56000, 56000},
};

}  // namespace aidl::android::hardware::ir