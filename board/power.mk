WITH_CM_CHARGER := true
BOARD_CHARGER_DISABLE_INIT_BLANK := true
BOARD_CHARGER_ENABLE_SUSPEND := false
BACKLIGHT_PATH := "/sys/class/leds/lcd-backlight/brightness"

BOARD_CHARGING_CMDLINE_NAME := "androidboot.mode"
BOARD_CHARGING_CMDLINE_VALUE := "chargerlogo"

TARGET_TAP_TO_WAKE_NODE := "/sys/devices/virtual/input/lge_touch/tap2wake"

TARGET_BOOTANIMATION_MULTITHREAD_DECODE := true
