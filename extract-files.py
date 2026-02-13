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
        'vendor/lib/libalmcascore.so',
        'vendor/lib/libalmcaswrap.so',
        'vendor/lib/libVDLowLightAPI.so',
        'vendor/lib/libVDBase.so',
        'vendor/lib/libalhdri.so',
    ): blob_fixup()
        .replace_needed('libstdc++.so', 'libstdc++_vendor.so'),
    (
        'vendor/lib/libmmcamera_hdr_gb_lib.so',
    )
        : blob_fixup()
        .replace_needed('libstdc++.so', 'libstdc++_vendor.so')
        .add_needed('liblog.so'),
    (
        'vendor/lib/libarcsoft_beauty_shot.so',
    ): blob_fixup()
        .replace_needed('libandroid.so', 'libsensorndkbridge.so')
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
        .add_needed('libaudioclient_shim_g4.so')
        .remove_needed('libmedia.so')
        .replace_needed('libril.so', 'libril_lge.so')
        .add_needed('liblog.so'),
    (
        'vendor/lib/libmm-abl.so',
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
        .binary_regex_replace(b'system/lib/hw/sensors.hal.tof.so', b'vendor/lib/hw/sensors.hal.tof.so')
        .add_needed('liblog.so'),
    (
        'vendor/bin/netmgrd'
    ): blob_fixup()
        .binary_regex_replace(b'system/etc/data/netmgr_config.xml', b'vendor/etc/data/netmgr_config.xml'),
    (
        'vendor/bin/qmuxd'
    ): blob_fixup()
        .binary_regex_replace(b'system/etc/data/qmi_config.xml', b'vendor/etc/data/qmi_config.xml'),
    (
        'vendor/lib/libdsi_netctrl.so',
        'vendor/lib64/libdsi_netctrl.so',
    ): blob_fixup()
        .binary_regex_replace(b'system/etc/data/dsi_config.xml', b'vendor/etc/data/dsi_config.xml'),
    (
        'vendor/lib/hw/camera.msm8992.so',
    ): blob_fixup()
        .add_needed('libfence_shim.so')
        .replace_needed('libandroid.so', 'libsensorndkbridge.so')
        .replace_needed('libcamera_client.so', 'libcamera_client_vendor.so'),
    (
        'vendor/lib/libcamera_client_vendor.so',
        'vendor/lib64/libcamera_client_vendor.so',
    ): blob_fixup()
        .add_needed('libgui_shim_vendor.so')
	    .clear_symbol_version('__aeabi_memcpy')
        .clear_symbol_version('__aeabi_memset')
        .clear_symbol_version('__aeabi_memmove')
        .clear_symbol_version('__aeabi_atexit')
        .clear_symbol_version('__gnu_Unwind_Find_exidx'),
    ('vendor/lib/libidl.so', 'vendor/lib/libqmimotext.so', 'vendor/lib/libdsutils.so', 'vendor/lib/libconfigdb.so', 'vendor/lib/lib-imsxml.so', 'vendor/lib/libmmcamera2_awb_lg.so', 'vendor/lib/lib-imsqimf.so', 'vendor/lib/libsystem_health_mon.so', 'vendor/lib/lib-imsrcs.so', 'vendor/lib/lib-imsrcscm.so', 'vendor/lib/libmmcamera_chromaflash_lib.so', 'vendor/lib/libmmcamera_faceproc.so', 'vendor/lib/libadm.so', ): blob_fixup()
        .clear_symbol_version('__aeabi_memcpy')
        .clear_symbol_version('__aeabi_memset')
        .clear_symbol_version('__aeabi_memmove')
        .clear_symbol_version('__gnu_Unwind_Find_exidx'),
    (
        'vendor/lib/libgps.utils.so',
        'vendor/lib64/libgps.utils.so',
    ): blob_fixup()
        .add_needed('libprocessgroup.so'),
    (
        'vendor/lib/libtime_genoff.so',
        'vendor/lib64/libtime_genoff.so',
        'vendor/lib/libloc_core.so',
        'vendor/lib64/libloc_core.so',
        'vendor/lib/libloc_api_v02.so',
        'vendor/lib64/libloc_api_v02.so',
        'vendor/lib/libmmosal.so',
        'vendor/lib64/libmmosal.so',
        'vendor/lib/libQSEEComAPI.so',
        'vendor/lib64/libQSEEComAPI.so',
        'vendor/lib/libqomx_core.so',
        'vendor/lib/libmmparser_lite.so',
        'vendor/lib64/libmmparser_lite.so',
        'vendor/bin/energy-awareness',
        'vendor/lib/liblbs_core.so',
        'vendor/lib64/liblbs_core.so',
        'vendor/lib/libcneapiclient.so',
        'vendor/lib64/libcneapiclient.so',
        'vendor/lib/lib-rtpdaemoninterface.so',
        'vendor/lib64/lib-rtpdaemoninterface.so',
        'vendor/lib/libCB.so',
        'vendor/lib64/libCB.so',
	    'vendor/lib/libmmcamera2_pp_buf_mgr.so',
	    'vendor/lib/libmmcamera_ppbase_module.so',
	    'vendor/lib/libatd_corelib.so',
	    'vendor/lib64/libatd_corelib.so',
	    'vendor/lib/libmmcamera2_stats_algorithm.so',
	    'vendor/lib64/libmmcamera2_stats_algorithm.so',
	    'vendor/lib/liblgkm.so',
	    'vendor/lib64/liblgkm.so',
	    'vendor/lib/libquipc_os_api.so',
	    'vendor/lib64/libquipc_os_api.so',
	    'vendor/lib/liblowi_client.so',
	    'vendor/lib64/liblowi_client.so',
	    'vendor/lib/soundfx/libqcreverb.so',
	    'vendor/lib/libmmcamera_vpu_module.so',
	    'vendor/lib/libmmcamera2_c2d_module.so',
	    'vendor/lib/libmmcamera2_q3a_core.so',
	    'vendor/lib/libmmcamera2_cpp_module.so',
	    'vendor/lib/soundfx/libqcvirt.so',
	    'vendor/lib/libmmcamera2_vpe_module.so',
	    'vendor/lib/liblgftmitem.so',
	    'vendor/lib64/liblgftmitem.so',
	    'vendor/lib/libmmcamera_eztune_module.so',
        'vendor/lib/libmmcamera2_isp_modules.so',
        'vendor/lib/libmmcamera_dbg.so',
        'vendor/lib/liblocationservice.so',
        'vendor/lib64/liblocationservice.so',
        'vendor/lib/libcne.so',
        'vendor/lib64/libcne.so',
        'vendor/bin/imsqmidaemon',
        'vendor/bin/imswmsproxy',
        'vendor/bin/bdaddr_loader',
        'vendor/lib/libchromatix_imx234_hfr_90_open.so',
        'vendor/lib/libchromatix_imx234_hfr_90.so',
        'vendor/lib/libmm-qcamera.so',
        'vendor/lib/libchromatix_imx234_hfr_120_open.so',
        'vendor/lib/libchromatix_imx234_hfr_120.so',
        'vendor/lib/libmmcamera_isp_sub_module.so',
        'vendor/lib/libchromatix_imx234_hfr_60.so',
        'vendor/lib/libchromatix_imx234_hfr_60_open.so',
        'vendor/lib/libchromatix_imx234_liveshot.so',
        'vendor/lib/libchromatix_imx234_liveshot_open.so',
        'vendor/lib/libmm-als.so',
        'vendor/lib64/libmm-als.so',
        'vendor/lib/libsubsystem_control.so',
        'vendor/lib64/libsubsystem_control.so',
        'vendor/lib/libois_lc898122.so',
        'vendor/lib/libmmcamera_pdaf_v3.so',
        'vendor/lib/libthermalclient.so',
        'vendor/lib64/libthermalclient.so',
        'vendor/bin/mm-qcamera-daemon',
        'vendor/bin/msm_irqbalance',
        'vendor/lib/libmmQSM.so',
        'vendor/lib64/libmmQSM.so',
        'vendor/lib/soundfx/libqcbassboost.so',
        'vendor/lib/liblowi_wifihal.so',
        'vendor/lib64/liblowi_wifihal.so',
        'vendor/lib64/libthermalioctl.so',
        'vendor/lib/libxtwifi_ulp_adaptor.so',
        'vendor/lib64/libxtwifi_ulp_adaptor.so',
        'vendor/bin/imsdatadaemon',
        'vendor/lib/libmmcamera_isp_fovcrop_viewfinder40.so',
        'vendor/bin/loc_launcher',
        'vendor/lib/libjpegehw.so',
        'vendor/lib/libmmcamera_isp_fovcrop_encoder40.so',
        'vendor/lib/libmmcamera_isp_ihist_stats44.so',
        'vendor/lib/libmmcamera_isp_gamma44.so',
        'vendor/bin/mm-qcamera-app',
        'vendor/lib/libmmcamera_isp_clamp_video40.so',
        'vendor/lib/libjpegdmahw.so',
        'vendor/lib64/libCommandSvc.so',
        'vendor/lib/libmmcamera_isp_bcc44.so',
        'vendor/lib/libmmcamera_isp_mce40.so',
        'vendor/lib/libmmcamera_isp_linearization40.so',
        'vendor/bin/pm-proxy',
        'vendor/bin/lowi-server',
        'vendor/lib/libchromatix_imx234_default_video_open.so',
        'vendor/lib/libchromatix_imx234_cpp_flash_snapshot.so',
        'vendor/lib/libchromatix_t4ka3_cpp_vt_open.so',
        'vendor/lib/libmmcamera_isp_luma_adaptation40.so',
        'vendor/lib/libchromatix_imx234_default_video.so',
        'vendor/lib/libmmcamera_isp_clamp_encoder40.so',
        'vendor/lib/libmmcamera_isp_clf44.so',
        'vendor/lib/libmmcamera_isp_chroma_suppress40.so',
        'vendor/lib/libmmcamera_isp_bg_stats44.so',
        'vendor/bin/rmt_storage',
        'vendor/lib/libmmcamera_imx234.so',
        'vendor/lib/libmmcamera_isp_ltm44.so',
        'vendor/lib/libalarmservice_jni.so',
        'vendor/lib64/libalarmservice_jni.so',
        'vendor/lib/libchromatix_imx234_common_video.so',
        'vendor/lib/libmmcamera_ov5670.so',
        'vendor/lib/libjpegdhw.so',
        'vendor/lib/libsensor_lge_cal.so',
        'vendor/lib64/libsensor_lge_cal.so',
        'vendor/lib/libchromatix_imx234_video_hdr.so',
        'vendor/lib/libchromatix_imx234_video_dual_open.so',
        'vendor/lib/libQtiTether.so',
        'vendor/lib64/libQtiTether.so',
        'vendor/lib/libmmcamera_isp_mesh_rolloff44.so',
        'vendor/lib/libmmcamera_isp_rs_stats44.so',
        'vendor/lib/libmmcamera_isp_chroma_enhan40.so',
        'vendor/lib/libqomx_jpegenc.so',
        'vendor/lib/libqomx_jpegenc_pipe.so',
        'vendor/lib/libmmcamera_isp_bhist_stats44.so',
        'vendor/lib/libmmcamera_ov5670w.so',
        'vendor/lib/libmmcamera_cac2_lib.so',
        'vendor/lib/libmmcamera_isp_color_correct40.so',
        'vendor/lib/libqomx_jpegdec.so',
        'vendor/lib/liblistenjni.so',
        'vendor/lib/libchromatix_imx234_snapshot.so',
        'vendor/lib/hw/wbc_hal.default.so',
        'vendor/lib64/hw/wbc_hal.default.so',
        'vendor/lib/libchromatix_imx234_cpp_flash_snapshot_open.so',
        'vendor/lib/libmmcamera_isp_sce40.so',
        'vendor/lib/libdrmdecrypt.so',
        'vendor/lib/libchromatix_imx234_common.so',
        'vendor/lib/libmmcamera_isp_color_xform_encoder40.so',
        'vendor/lib/libchromatix_imx234_snapshot_panorama.so',
        'vendor/lib/libmmcamera_isp_sce40.so',
        'vendor/lib/libchromatix_imx234_snapshot_hdr_open.so',
        'vendor/bin/rfs_access',
        'vendor/lib/libmmcamera_isp_clamp_viewfinder40.so',
        'vendor/lib/libqti-iop-client.so',
        'vendor/lib64/liblistenjni.so',
        'vendor/lib/libchromatix_imx234_common_video_open.so',
        'vendor/lib/libchromatix_imx234_preview_open.so',
        'vendor/lib/libmmcamera_isp_color_xform_viewfinder40.so',
        'vendor/lib/libQTapGLES.so',
        'vendor/lib64/libQTapGLES.so',
        'vendor/lib/libmmcamera_tintless_bg_pca_algo.so',
        'vendor/bin/qseecom_sample_client',
        'vendor/lib/libchromatix_imx234_common_open.so',
        'vendor/lib/libSubSystemShutdown.so',
        'vendor/lib/libqti-gt.so',
        'vendor/lib64/libqti-gt.so',
        'vendor/lib/libmmcamera_pdaf.so',
        'vendor/bin/tftp_server',
        'vendor/lib/libmmcamera_isp_scaler_viewfinder44.so',
        'vendor/lib/libmmcamera_isp_bf_stats44.so',
        'vendor/lib/libchromatix_imx234_snapshot_open.so',
        'vendor/lib/libchromatix_imx234_video_dual.so',
        'vendor/lib/libmmcamera_isp_demux40.so',
        'vendor/lib/libmmcamera_isp_demosaic44.so',
        'vendor/lib/libqti-iop-client.so',
        'vendor/lib/libmmcamera_isp_wb40.so',
        'vendor/lib/libmmcamera_isp_cs_stats44.so',
        'vendor/lib/libchromatix_t4ka3_cpp_vt.so',
        'vendor/lib/libchromatix_imx234_video_hdr_open.so',
        'vendor/lib64/libqti-iop-client.so',
        'vendor/lib/libmmcamera2_frame_algorithm.so',
        'vendor/lib/libchromatix_imx234_snapshot_panorama_open.so',
        'vendor/lib/libmmcamera_isp_bf_scale_stats44.so',
        'vendor/lib/libchromatix_imx234_snapshot_hdr.so',
        'vendor/lib/libmmcamera_isp_bpc44.so',
        'vendor/lib/libmmcamera_pdafcamif.so',
        'vendor/lib/libmmcamera_isp_scaler_encoder44.so',
        'vendor/bin/xtwifi-inet-agent',
        'vendor/lib/libmmcamera_isp_abf44.so',
        'vendor/lib/libchromatix_imx234_preview.so',
        'vendor/lib/libmmcamera_isp_be_stats44.so',
        'vendor/lib64/libmdmcutback.so',
        'vendor/lib64/libloc_ds_api.so',
        'vendor/lib/libloc_ds_api.so',
    ): blob_fixup()
        .add_needed('liblog.so'),
    (
        'vendor/lib/libperipheral_client.so',
        'vendor/lib64/libperipheral_client.so',
	    'vendor/lib/lib-imsrcscmclient.so',
        'vendor/lib/libimscamera_jni.so',
        'vendor/lib64/libimscamera_jni.so',
    ): blob_fixup()
        .add_needed('liblog.so')
        .clear_symbol_version('__aeabi_memcpy')
        .clear_symbol_version('__aeabi_memset')
        .clear_symbol_version('__aeabi_memmove')
        .clear_symbol_version('__aeabi_atexit')
        .clear_symbol_version('__gnu_Unwind_Find_exidx'),
    (
        'vendor/lib/lib-imsdpl.so',
        'vendor/lib64/lib-imsdpl.so',
        'vendor/lib/libsecureks.so',
        'vendor/lib64/libsecureks.so',
	    'vendor/lib/libmmcamera2_aec_lg.so',
	    'vendor/lib/lib-imsSDP.so',
	    'vendor/lib64/lib-imsSDP.so',
        'vendor/lib/lib-imss.so',
        'vendor/lib64/lib-imss.so',
    ): blob_fixup()
        .add_needed('liblog.so')
        .clear_symbol_version('__aeabi_memcpy')
        .clear_symbol_version('__aeabi_memset')
        .clear_symbol_version('__aeabi_memmove')
        .clear_symbol_version('__gnu_Unwind_Find_exidx'),
    (
        'vendor/lib/libwvdrm_L1.so',
    ): blob_fixup()
        .add_needed('liblog.so')
        .clear_symbol_version('__aeabi_atexit'),
    (
        'vendor/lib/lib-ims-rcscmjni.so',
        'vendor/lib/lib-imsrcscmservice.so',
        'vendor/lib/hw/sensors.msm8992.so',
        'vendor/lib/hw/sound_trigger.primary.msm8992.so',
        'vendor/lib/libmotext_inf.so',
        'vendor/lib/libpowermanager_vendor.so',
    ): blob_fixup()
        .clear_symbol_version('__aeabi_memset')
        .clear_symbol_version('__aeabi_memcpy')
        .clear_symbol_version('__aeabi_atexit')
        .clear_symbol_version('__gnu_Unwind_Find_exidx'),
    (
        'vendor/lib/libvoice-svc.so',
        'vendor/lib64/libvoice-svc.so',
    ): blob_fixup()
        .add_needed('liblog.so')
        .add_needed('libprocessgroup.so'),
    (
        'vendor/bin/ATFWD-daemon',
    ): blob_fixup()
        .add_needed('liblog.so')
        .add_needed('libcutils_shim.so'),

}  # fmt: skip
# (
#        'vendor/bin/thermal-engine',
#    ): blob_fixup()
#        .replace_needed('libpowermanager.so', ' libpowermanager_vendor.so'),


module = ExtractUtilsModule(
    'g4-common',
    'lge',
    namespace_imports=namespace_imports,
    blob_fixups=blob_fixups,
)

if __name__ == '__main__':
    utils = ExtractUtils.device(module)
    utils.run()
