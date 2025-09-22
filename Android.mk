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

LOCAL_PATH := $(call my-dir)
LOCAL_IGNORE_MAX_PAGE_SIZE := true

ifeq ($(TARGET_DEVICE),rmx2202)
include $(call all-subdir-makefiles,$(LOCAL_PATH))
endif
