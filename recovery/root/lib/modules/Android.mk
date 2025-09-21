LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := lahaina_modules
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_RECOVERY_ROOT_OUT)

LOCAL_POST_INSTALL_CMD += \
    mkdir -p $(TARGET_RECOVERY_ROOT_OUT)/lib/modules; \
    cp -a $(LOCAL_PATH)/* $(TARGET_RECOVERY_ROOT_OUT)/lib/modules/;

include $(BUILD_PHONY_PACKAGE)
