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
LOCAL_PATH := device/realme/RMX2202
DEVICE_PATH := device/realme/RMX2202

# Soong 命名空间
PRODUCT_SOONG_NAMESPACES := \
    device/realme/RMX2202 \
    $(LOCAL_PATH)/stubs \
    vendor/twrp

PRODUCT_PROPERTY_OVERRIDES += persist.sys.purgeable_assets=1

COMMON_SOC := sm8350
# Define hardware platform
PRODUCT_PLATFORM := lahaina

# APEX 更新支持
$(call inherit-product, $(SRC_TARGET_DIR)/product/updatable_apex.mk)

# A/B OTA 支持
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota.mk)

# A/B OTA 后安装配置
AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=system/bin/otapreopt_script \
    FILESYSTEM_TYPE_system=ext4 \
    POSTINSTALL_OPTIONAL_system=true \
    RUN_POSTINSTALL_vendor=true \
    POSTINSTALL_PATH_vendor=bin/checkpoint_gc \
    FILESYSTEM_TYPE_vendor=ext4 \
    POSTINSTALL_OPTIONAL_vendor=true

# A/B
AB_OTA_UPDATER := true
AB_OTA_PARTITIONS := \
    boot \
    vendor_boot \
    dtbo \
    odm \
    product \
    system \
    system_ext \
    system_dlkm \
    vbmeta \
    vbmeta_system \
    vbmeta_vendor \
    vendor \
    vendor_dlkm \
    my_bigball \
    my_carrier \
    my_company \
    my_engineering \
    my_heytap \
    my_manifest \
    my_preload \
    my_product \
    my_region \
    my_stock
    
# OTA & Recovery 相关包
PRODUCT_PACKAGES += \
    update_engine \
    update_engine_sideload \
    update_verifier \
    checkpoint_gc \
    otapreopt_script \
    qcom_decrypt \
    qcom_decrypt_fbe
    
# OTA 证书
PRODUCT_EXTRA_RECOVERY_KEYS += \
    $(DEVICE_PATH)/security/local_OTA \
    $(DEVICE_PATH)/security/special_OTA
    
# Boot & Fastboot 支持
PRODUCT_PACKAGES += \
    android.hardware.boot@1.2-impl \
    android.hardware.boot@1.2-impl.recovery \
    android.hardware.boot@1.2-service \
    android.hardware.fastboot@1.1-impl-mock \
    fastbootd \
    toybox toolbox e2fsck mke2fs resize2fs tune2fs

# 显示相关 HAL
PRODUCT_PACKAGES += \
    android.hardware.graphics.mapper@4.0 \
    android.hardware.graphics.allocator@4.0 \
    vendor.display.config@1.0 \
    vendor.display.config@2.0

# Recovery 显示库（模块留在 BoardConfig；拷贝放 device.mk）
TARGET_RECOVERY_DEVICE_MODULES += \
    libdisplayconfig.qti \
    vendor.display.config@1.0 \
    vendor.display.config@2.0 \
    vendor.qti.hardware.tui_comm@1.0
    
# Health
PRODUCT_PACKAGES += \
    android.hardware.health@2.1-impl \
    android.hardware.health@2.1-service
# 文件系统支持（F2FS）
PRODUCT_PACKAGES += \
    fsck.f2fs \
    mkfs.f2fs \
    sload.f2fs \
    libf2fs_fmt \
    libf2fs_dlkm

# 属性
PRODUCT_PLATFORM := lahaina
TARGET_VENDOR_PROP := $(DEVICE_PATH)/vendor.prop
TARGET_ODM_PROP := $(DEVICE_PATH)/odm.prop
TARGET_SYSTEM_PROP := $(DEVICE_PATH)/system.prop

# 预构建文件拷贝
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/prebuilts/dtb.img:dtb.img \
    $(LOCAL_PATH)/rootdir/etc/fstab.default:$(TARGET_VENDOR_RAMDISK_OUT)/first_stage_ramdisk/fstab.default

# 分区与加密配置
PRODUCT_USE_DYNAMIC_PARTITIONS := true
BOARD_INCLUDE_RECOVERY_VENDOR_MODULES := true

PRODUCT_PROPERTY_OVERRIDES += \
    ro.crypto.state=encrypted \
    ro.crypto.type=file \
    ro.crypto.fuse_sdcard=true \
    ro.crypto.volume.options=::voldmanaged=userdata:default

# RRO Overlay 强制启用
PRODUCT_ENFORCE_RRO_TARGETS := *
