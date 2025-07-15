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
    'device/lge/g4-common/camera',
    'hardware/qcom-caf/msm8992',
    'hardware/qcom-caf/msm8992/display',
    'hardware/qcom-caf/msm8992/media',
    'hardware/qcom-caf/msm8992/audio',
    'vendor/qcom/opensource/dataservices',
]

blob_fixups: blob_fixups_user_type = {
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
        'vendor/lib/libuiblur.so',
	    'vendor/bin/RIDLClient.exe',
        'vendor/lib/libmmcamera2_is.so',
        'vendor/lib/libmmcamera_hdr_gb_lib.so',
        'vendor/lib/libarcsoft_beauty_shot.so'
    ): blob_fixup()
        .replace_needed('libstdc++.so', 'libstdc++_vendor.so'),
    (
        'vendor/lib/libbccQTI.so',
        'vendor/lib64/libbccQTI.so',
    ): blob_fixup()
        .remove_needed('libLLVM.so'),
    (
        'vendor/lib/libmmcamera_stillmore_lib.so',
    ): blob_fixup()
        .add_needed('libshim_cameraclient.so'),
    (
        'vendor/lib64/lib-rtpcore.so',
    ): blob_fixup()
        .add_needed('ims_rtp_shim.so'),
    (
        'vendor/bin/slim_daemon',
    ): blob_fixup()
        .add_needed('slim_shim.so'),
    (
        'vendor/lib/libril-qc-qmi-1.so',
        'vendor/lib64/libril-qc-qmi-1.so',
    ): blob_fixup()
        .add_needed('libaudioclient_shim.so')
        .remove_needed('libmedia.so')
        .replace_needed('libril.so', 'libril_lge.so'),
    (
        'vendor/lib64/libmm-abl.so',
    ): blob_fixup()
        .add_needed('libshims_thermal.so'),
    (
        'vendor/lib/libwfdhdcpcp.so',
    ): blob_fixup()
        .remove_needed('libDxHdcp.so'),
    (
        'vendor/lib/libril-qcril-hook-oem.so',
        'vendor/lib/libvss_common_core.so',
        'vendor/lib64/libril-qcril-hook-oem.so',
        'vendor/lib64/libvss_common_core.so',
        'vendor/lib64/libvss_nv_core.so',
        'vendor/bin/hw/rild',
    ): blob_fixup()
        .replace_needed('libril.so', 'libril_lge.so'),
    (
        'vendor/bin/qseecom_sample_client'
        'vendor/lib/drm/libdrmwvmplugin.so',
        'vendor/lib/libSecureUILib.so',
        'vendor/lib/libdrmdecrypt.so',
        'vendor/lib/liboemcrypto.so',
        'vendor/lib/libpvr.so',
        'vendor/lib/librmp.so',
        'vendor/lib/libsi.so',
        'vendor/lib/libtzdrmgenprov.so',
        'vendor/lib/libwvm.so',
        'vendor/lib64/libSecureUILib.so',
        'vendor/lib64/libmdtp.so',
        'vendor/lib64/libpvr.so',
        'vendor/lib64/librmp.so',
        'vendor/lib64/libsi.so',
        'vendor/lib64/libtzdrmgenprov.so',
    ): blob_fixup()
        .binary_regex_replace(b'system/etc/firmware', b'vendor/firmware\x00\x00\x00\x00'),
    (
        'vendor/lib/libmmcamera2_stats_modules.so'
    ): blob_fixup()
        .replace_needed('libandroid.so', 'libsensorndkbridge.so')
        .binary_regex_replace(b'system/lib/hw/sensors.hal.tof.so', b'vendor/lib/hw/sensors.hal.tof.so'),
 #   (
 #       'vendor/lib/libcamera_client.so',
 #       'vendor/lib64/libcamera_client.so'
 #   ): blob_fixup()
 #       .add_needed('libshim_cameraclient.so')

}  # fmt: skip
#    (
#        'system/lib/hw/lgkm.msm8992.so',
#        'system/lib64/hw/lgkm.msm8992.so',
#    ): blob_fixup()
#        .remove_needed('libsecureks.so'),
    #    (
#        'vendor/lib/libsettings.so',
#        'vendor/lib64/libsettings.so',
#    ): blob_fixup()
#        .replace_needed('libprotobuf-cpp-full-29a.so', 'libprotobuf-cpp-full-v29.so'),
#    (
#        'vendor/lib/libcneapiclient.so',
#        'vendor/lib64/libcneapiclient.so',
#        'vendor/lib/libcne.so',
#        'vendor/lib64/libcne.so',
#        'vendor/lib/libwms.so',
#        'vendor/lib64/libwms.so',
#        'vendor/lib/libwqe.so',
#        'vendor/lib64/libwqe.so',
#    ): blob_fixup()
#        .replace_needed('libprotobuf-cpp-lite-29a.so', 'libprotobuf-cpp-lite-v29.so'),
#    (
#        'vendor/lib/libwvm.so',
#    ): blob_fixup()
#        .add_needed('libshim_wvm.so'),
   # (
   #     'system/lib64/libmdmcutback.so',
   # ): blob_fixup()
   #     .add_needed('libqsap_shim.so'),


       #(
       # 'vendor/lib/hw/camera.msm8992.so',
    #): blob_fixup()
    #    .add_needed('libfence_shim.so'),
#    /system/lib/libshim_camera.so:/system/lib/libcamera_client.so|libshim_cameraclient.so \ #FIX ME



module = ExtractUtilsModule(
    'g4-common',
    'lge',
    namespace_imports=namespace_imports,
    blob_fixups=blob_fixups,
)

if __name__ == '__main__':
    utils = ExtractUtils.device(module)
    utils.run()
