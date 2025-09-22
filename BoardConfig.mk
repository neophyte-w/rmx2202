#
# Copyright (C) 2025 The Android Open Source Project
#
# Copyright (C) 2025 xXHenneBXx
#
# Copyright (C) 2025 SebaUbuntu
#
# Copyright (C) 2025 Biraru
#
# SPDX-License-Identifier: Apache-2.0
#
LOCAL_PATH := device/realme/rmx2202
DEVICE_PATH := device/realme/rmx2202

# 允许 ELF 文件拷贝
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true
# 编译器与构建选项
TARGET_CLANG_VERSION := r416183
BUILD_BROKEN_DUP_RULES := true

# 架构定义
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_VARIANT := generic
TARGET_CPU_VARIANT_RUNTIME := kryo300

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv7-a-neon
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_VARIANT := generic
TARGET_2ND_CPU_VARIANT_RUNTIME := cortex-a75

# Bootloader与平台
TARGET_USES_UEFI := true
TARGET_NO_BOOTLOADER := true
QCOM_BOARD_PLATFORMS += lahaina
TARGET_BOARD_PLATFORM := lahaina
TARGET_BOOTLOADER_BOARD_NAME := lahaina

# 内核基础配置
BOARD_BOOT_HEADER_VERSION := 3
BOARD_KERNEL_BASE := 0x00000000
BOARD_KERNEL_CMDLINE := \
    console=ttyMSM0,115200n8 \
    androidboot.console=ttyMSM0 \
    androidboot.hardware=qcom \
    androidboot.memcg=1 \
    androidboot.usbcontroller=a600000.dwc3 \
    buildvariant=user \
    lpm_levels.sleep_disabled=1 \
    swiotlb=0 \
    kpti=off \
    video=vfb:640x400,bpp=32,memsize=3072000 \
    loop.max_part=7 \
    msm_rtb.filter=0x237 \
    service_locator.enable=1 \
    pcie_ports=compat \
    cgroup.memory=nokmem,nosocket
BOARD_KERNEL_PAGESIZE := 4096
BOARD_KERNEL_IMAGE_NAME := Image
BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOT_HEADER_VERSION)

# 采用预编译 kernel + 外置 DTB + 分离 DTBO（保持一致)
TARGET_FORCE_PREBUILT_KERNEL := true
ifeq ($(TARGET_FORCE_PREBUILT_KERNEL),true)
TARGET_PREBUILT_KERNEL := $(DEVICE_PATH)/prebuilts/kernel
TARGET_PREBUILT_DTB := $(DEVICE_PATH)/prebuilts/dtb.img
BOARD_MKBOOTIMG_ARGS += --dtb $(TARGET_PREBUILT_DTB)
BOARD_INCLUDE_DTB_IN_BOOTIMG := true
BOARD_PREBUILT_DTBOIMAGE := $(DEVICE_PATH)/prebuilts/dtbo.img
BOARD_KERNEL_SEPARATED_DTBO := true
endif

# 分区（用 by-name 实际值校准）
BOARD_FLASH_BLOCK_SIZE := 262144 # (BOARD_KERNEL_PAGESIZE * 64)
BOARD_BOOTIMAGE_PARTITION_SIZE := 201326592
BOARD_DTBOIMG_PARTITION_SIZE := 25165824
BOARD_VENDOR_BOOTIMAGE_PARTITION_SIZE := 201326592
BOARD_SUPER_PARTITION_SIZE := 10200547328
BOARD_SUPER_PARTITION_GROUPS := qti_dynamic_partitions
BOARD_QTI_DYNAMIC_PARTITIONS_SIZE := 10200547328
BOARD_QTI_DYNAMIC_PARTITIONS_PARTITION_LIST := \
    odm \
    system \
    vendor \
    product \
    system_ext \
    my_bigball \
    my_carrier \
    my_company \
    my_engineering \
    my_heytap \
    my_region \
    my_stock \
    my_preload \
    my_product \
    my_manifest

# Verified Boot
BOARD_AVB_ENABLE := true
BOARD_AVB_ALGORITHM := SHA256_RSA2048
BOARD_AVB_KEY_PATH := device/realme/rmx2202/oplus_avb.pem
BOARD_AVB_VBMETA_SYSTEM := system system_ext product
BOARD_AVB_VENDOR_BOOT_KEY_PATH := $(DEVICE_PATH)/security/avb.pem
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flags 3

# vbmeta_system（如果需要）
BOARD_AVB_VBMETA_SYSTEM_KEY_PATH := $(DEVICE_PATH)/security/avb.pem
BOARD_AVB_VBMETA_SYSTEM_ALGORITHM := SHA256_RSA2048
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX_LOCATION := 2

# vendor_boot（如果需要签名）
BOARD_AVB_VENDOR_BOOT_ALGORITHM := SHA256_RSA4096
BOARD_AVB_VENDOR_BOOT_ROLLBACK_INDEX := 1
BOARD_AVB_VENDOR_BOOT_ROLLBACK_INDEX_LOCATION := 1

# Recovery 配置
BOARD_USES_RECOVERY_AS_BOOT := true
#TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/rootdir/etc/fstab.default
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/recovery/root/system/etc/twrp.fstab
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true
BOARD_RAMDISK_USE_LZ4 := true
BOARD_INCLUDE_RECOVERY_ROOT := true

# TWRP UI 与功能
TW_INCLUDE_FASTBOOTD := true
TW_THEME := portrait_hdpi
TW_Y_OFFSET := 120
TW_H_OFFSET := -120
TW_LOAD_VENDOR_BOOT_MODULES := true
TW_LOAD_VENDOR_MODULES := "adsp_loader_dlkm.ko apr_dlkm.ko q6_dlkm.ko q6_notifier_dlkm.ko q6_pdr_dlkm.ko snd_event_dlkm.ko msm_drm.ko"
TW_SUPPORT_INPUT_1_2_HAPTICS := true
TW_EXCLUDE_TWRPAPP := true
TW_USE_TOOLBOX := true
TW_EXTRA_LANGUAGES := true
TW_FRAMERATE := 60
TW_HAS_EDL_MODE := true
TW_CUSTOM_BATTERY_POS := 740
TW_CUSTOM_CLOCK_POS := 500
TW_CUSTOM_CPU_POS := 180
# 使用 DRM/KMS 显示后端（无 /dev/graphics/fb0 的设备必须启用）
TW_USE_MINUI_WITH_LIBDRM := true
# 屏幕分辨率与 DPI（rmx2202: 1080x2400, 480dpi）
TARGET_SCREEN_WIDTH := 1080
TARGET_SCREEN_HEIGHT := 2400
TARGET_SCREEN_DENSITY := 480
# 避免 cont_splash 卡住 Logo，强制关闭内核的连续开机画面
BOARD_KERNEL_CMDLINE += msm_drm.dsi_display0.ignore_cont_splash=1
# 屏幕亮度路径（你设备树里已有 panel0-backlight，这里确认并补充默认值）
TW_BRIGHTNESS_PATH := "/sys/class/backlight/panel0-backlight/brightness"
TW_MAX_BRIGHTNESS := 2047
TW_DEFAULT_BRIGHTNESS := 800

# 加密与解密（高通 FBE）：
BOARD_USES_QCOM_FBE_DECRYPTION := true
BOARD_USES_METADATA_PARTITION := true
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
TW_INCLUDE_CRYPTO := true
TW_INCLUDE_CRYPTO_FBE := true
TW_INCLUDE_FBE_METADATA_DECRYPT := true
TW_USE_FSCRYPT_POLICY := 2

# VINTF
DEVICE_MATRIX_FILE := $(DEVICE_PATH)/recovery/root/vendor/etc/vintf/compatibility_matrix.xml
DEVICE_MANIFEST_FILE += \
     $(DEVICE_PATH)/recovery/root/vendor/etc/vintf/manifest.xml \
     device/realme/rmx2202/recovery/root/vendor/etc/vintf/manifest/android.hardware.usb@1.2-service.xml
# 仅在 recovery 生效的策略目录（推荐）
BOARD_RECOVERY_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/recovery

#内核镜像、设备树、ramdisk等在内存/内核偏移地址
BOARD_RAMDISK_OFFSET := 0x01000000
BOARD_KERNEL_SECOND_OFFSET := 0x00f00000
BOARD_KERNEL_TAGS_OFFSET := 0x00000100
BOARD_KERNEL_OFFSET := 0x00008000
BOARD_DTB_OFFSET := 0x01f00000
BOARD_MKBOOTIMG_ARGS += --dtb_offset $(BOARD_DTB_OFFSET)

# 依赖显示的 vendor 共享库
RECOVERY_LIBRARY_SOURCE_FILES += \
    $(TARGET_OUT_VENDOR_SHARED_LIBRARIES)/libdisplayconfig.qti.so \
    $(TARGET_OUT_VENDOR_SHARED_LIBRARIES)/vendor.display.config@1.0.so \
    $(TARGET_OUT_VENDOR_SHARED_LIBRARIES)/vendor.display.config@2.0.so \
    $(TARGET_OUT_VENDOR_SHARED_LIBRARIES)/vendor.qti.hardware.tui_comm@1.0.so

# UI/fastbootd
TW_NO_LEGACY_PROPS := true
TARGET_USE_CUSTOM_LUN_FILE_PATH := /config/usb_gadget/g1/functions/mass_storage.0/lun.%d/file
TW_QCOM_ATS_OFFSET := 1621580431500

# 其他常见开关：
TARGET_SUPPORTS_64_BIT_APPS := true
TARGET_COPY_OUT_VENDOR := vendor
BOARD_HAS_LARGE_FILESYSTEM := true
TARGET_USES_MKE2FS := true
