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
 #跳过ELF对齐
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/aosp_base.mk)
# Inherit some common TWRP stuff.
$(call inherit-product, vendor/twrp/config/common.mk)
# Inherit from RMX2202 device
$(call inherit-product, device/realme/RMX2202/device.mk)

PRODUCT_DEVICE := RMX2202
PRODUCT_NAME := twrp_RMX2202
PRODUCT_BRAND := realme
PRODUCT_MODEL := RMX2202
PRODUCT_MANUFACTURER := realme

# 平台版本与安全补丁
PLATFORM_VERSION := 99.87.36
PLATFORM_VERSION_LAST_STABLE := $(PLATFORM_VERSION)
PLATFORM_SECURITY_PATCH := 2127-12-31
VENDOR_SECURITY_PATCH := $(PLATFORM_SECURITY_PATCH)
BOOT_SECURITY_PATCH := $(PLATFORM_SECURITY_PATCH)
TW_DEVICE_VERSION := realme GT

PRODUCT_GMS_CLIENTID_BASE := android-realme

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRIVATE_BUILD_DESC="qssi-user 15 AP3A.240617.008 1755013593344 release-keys"

BUILD_FINGERPRINT := realme/RMX2202/RMX2202:15/AP3A.240617.008/1755013593344:user/release-keys
