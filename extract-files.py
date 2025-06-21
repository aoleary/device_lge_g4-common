#!/usr/bin/env -S PYTHONPATH=../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: 2024 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

from extract_utils.fixups_blob import (
    blob_fixup,
    blob_fixups_user_type,
)
from extract_utils.fixups_lib import (
    lib_fixup_vendorcompat,
    lib_fixups_user_type,
    libs_proto_3_9_1,
)
from extract_utils.main import (
    ExtractUtils,
    ExtractUtilsModule,
)

namespace_imports = [
    'device/lge/g4-common',
    'hardware/qcom-caf/msm8994',
]

blob_fixups: blob_fixups_user_type = {
    (
        'system/lib/hw/lgkm.msm8992.so',
        'system/lib64/hw/lgkm.msm8992.so',
    ): blob_fixup()
        .remove_needed('libsecureks.so'),
    (
        'vendor/lib/libtinyxml.so',
        'vendor/lib64/libtinyxml.so',
        'vendor/lib/libsregex.so',
        'vendor/lib/libsurround_3mic_proc.so',
        'vendor/lib/liblgmda.so',
        'vendor/lib/libdrc.so',
        'vendor/lib/libAlAisLib.so',
        'vendor/lib/libcir_driver.so',
        'vendor/lib64/libcir_driver.so',
        'vendor/lib/libtar.so',
        'vendor/lib/libAlAisTune.so',
        'vendor/lib/libmorpho_image_stab31.so',
        'vendor/lib/libHDR.so',
        'vendor/lib/libseemore.so',
        'vendor/lib/libtrueportrait.so',
        'vendor/lib/liboptizoom.so',
        'vendor/lib/libubifocus.so',
        'vendor/bin/LKCore',
        'vendor/lib/libchromaflash.so',
        'vendor/lib/libmorpho_superzoom.so',
	'vendor/lib/libUserAgent.so',
	'vendor/lib64/libUserAgent.so',
	'vendor/lib/libAlAisWrap.so',
	'vendor/bin/RIDLClient.exe',
    ): blob_fixup()
        .replace_needed('libstdc++.so', 'libstdc++_vendor.so'),
    (
        'vendor/lib/libbccQTI.so',
        'vendor/lib64/libbccQTI.so',
    ): blob_fixup()
        .remove_needed('libLLVM.so'), #FIX ME
    (
        'vendor/lib/libsettings.so',
        'vendor/lib64/libsettings.so',
    ): blob_fixup()
        .replace_needed('libprotobuf-cpp-full-29a.so', 'libprotobuf-cpp-full-29.so'),
    (
        'vendor/lib/libwvm.so',
    ): blob_fixup()
        .add_needed('libshims_wvm.so'),
}  # fmt: skip


#TARGET_LD_SHIM_LIBS := \
#    /system/vendor/lib/libwvm.so|libshims_wvm.so \
#    /system/lib64/libmdmcutback.so|libqsap_shim.so \
#    /system/lib/libshim_camera.so:/system/lib/libcamera_client.so|libshim_cameraclient.so \
#    /system/vendor/lib/libmmcamera_stillmore_lib.so|/system/lib/libshim_cameraclient.so \
#    /system/vendor/lib/hw/camera.msm8992.so|/system/vendor/lib/libfence_shim.so \
#    /system/vendor/lib64/lib-rtpcore.so|/system/vendor/lib64/ims_rtp_shim.so \
#    /system/vendor/bin/slim_daemon|/system/vendor/lib64/slim_shim.so \
#    /system/vendor/lib/libril-qc-qmi-1.so|libaudioclient_shim.so \
#    /system/vendor/lib64/libril-qc-qmi-1.so|libaudioclient_shim.so \
#    /system/vendor/bin/thermal-engine|libshims_thermal.so \
#    /system/vendor/lib64/libmm-abl.so|libshims_thermal.so


module = ExtractUtilsModule(
    'g4-common',
    'lge',
    namespace_imports=namespace_imports,
    blob_fixups=blob_fixups,
)

if __name__ == '__main__':
    utils = ExtractUtils.device(module)
    utils.run()
