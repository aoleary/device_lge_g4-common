/*
 * Copyright (C) 2021 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <aidl/android/hardware/ir/BnConsumerIr.h>
#include <aidl/android/hardware/ir/ConsumerIrFreqRange.h>
#include <android-base/logging.h>
#include <android/binder_interface_utils.h>
#include <android/binder_manager.h>
#include <android/binder_process.h>
#include <hardware/consumerir.h>
#include <numeric>

#include <log/log.h>

// LG specific defines
#define IR_DEVICE "/dev/ttyHSL1"
#define LG_IR_BAUD_RATE 115200

using ::aidl::android::hardware::ir::ConsumerIrFreqRange;

namespace aidl::android::hardware::ir {

extern "C" { extern int transmitIr(const char *dev, int baudRate, int frequency, int pattern[], int pattern_len); }

enum LG_TRANSMIT_IR_RETURN_CODES {
    IR_SUCCESS,
    IR_FAIL,
    IR_INVALID_PORT,
    IR_INVALID_BAUDRATE,
    IR_ERROR_OPEN_PORT,
    IR_ERROR_WRITE,
    IR_ERROR_READ,
    IR_INVALID_DATA_SIZE,
    IR_INVALID_DATA,
    IR_MAX_DURATIONS_EXCEEDED
};

static const std::vector<ConsumerIrFreqRange> kCarrierFreqRanges = {
    {30000, 30000},
    {33000, 33000},
    {36000, 36000},
    {38000, 38000},
    {40000, 40000},
    {56000, 56000},
};

class ConsumerIr : public BnConsumerIr {
  public:
    ConsumerIr();
  private:
    ::ndk::ScopedAStatus getCarrierFreqs(std::vector<ConsumerIrFreqRange>* _aidl_return) override;
    ::ndk::ScopedAStatus transmit(int32_t in_carrierFreqHz,
                                  const std::vector<int32_t>& in_pattern) override;
    consumerir_device_t *mDevice = nullptr;
};

ConsumerIr::ConsumerIr() {
    ALOGI("ConsumerIr AIDL service initialized (direct transmitIr backend)");
}

::ndk::ScopedAStatus ConsumerIr::getCarrierFreqs(
        std::vector<ConsumerIrFreqRange>* _aidl_return) {

    *_aidl_return = kCarrierFreqRanges;
    return ::ndk::ScopedAStatus::ok();
}

::ndk::ScopedAStatus ConsumerIr::transmit(
        int32_t in_carrierFreqHz,
        const std::vector<int32_t>& in_pattern) {

    size_t entries = in_pattern.size();

    ALOGD("transmitting pattern at %d Hz", in_carrierFreqHz);

    int rc = transmitIr(
            IR_DEVICE,
            LG_IR_BAUD_RATE,
            in_carrierFreqHz,
            const_cast<int32_t*>(in_pattern.data()),
            sizeof(int32_t) * entries);

    if (rc != IR_SUCCESS) {
        ALOGE("transmitIr() failed, error %d", rc);
        return ::ndk::ScopedAStatus::fromServiceSpecificError(rc);
    }

    return ::ndk::ScopedAStatus::ok();
}

}  // namespace aidl::android::hardware::ir

using aidl::android::hardware::ir::ConsumerIr;

int main() {
    auto binder = ::ndk::SharedRefBase::make<ConsumerIr>();
    const std::string name = std::string() + ConsumerIr::descriptor + "/default";
    CHECK_EQ(STATUS_OK, AServiceManager_addService(binder->asBinder().get(), name.c_str()))
            << "Failed to register " << name;

    ABinderProcess_setThreadPoolMaxThreadCount(0);
    ABinderProcess_joinThreadPool();

    return EXIT_FAILURE;  // should not reached
}
