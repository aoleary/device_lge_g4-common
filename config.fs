[system/vendor/bin/qmuxd]
mode: 0700
user: AID_RADIO
group: AID_SHELL
caps: BLOCK_SUSPEND

[system/vendor/bin/mm-qcamera-daemon]
mode: 0700
user: AID_CAMERA
group: AID_SHELL
caps: SYS_NICE

[system/vendor/bin/pm-service]
mode: 0755
user: AID_SYSTEM
group: AID_SYSTEM
caps: NET_BIND_SERVICE

[system/vendor/bin/imsdatadaemon]
mode: 0755
user: AID_SYSTEM
group: AID_SYSTEM
caps: NET_BIND_SERVICE

[system/vendor/bin/ims_rtp_daemon]
mode: 0755
user: AID_SYSTEM
group: AID_RADIO
caps: NET_BIND_SERVICE

[firmware/]
mode: 0771
user: AID_SYSTEM
group: AID_SYSTEM
caps: 0

[mpt/]
mode: 0755
user: AID_SYSTEM
group: AID_SYSTEM
caps: 0

[persist/]
mode: 0771
user: AID_SYSTEM
group: AID_SYSTEM
caps: 0

[persist-lg/]
mode: 0755
user: AID_SYSTEM
group: AID_SYSTEM
caps: 0

[sns/]
mode: 0775
user: AID_SYSTEM
group: AID_SYSTEM
caps: 0
