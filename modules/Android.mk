LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_MODULE := lahaina_modules
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_RECOVERY_ROOT_OUT)
# 安装阶段执行：把 ko 和 modules.load 拷贝到 recovery/root/lib/modules/
LOCAL_POST_INSTALL_CMD += \
    mkdir -p $(TARGET_RECOVERY_ROOT_OUT)/lib/modules; \
    cp -rf $(LOCAL_PATH)/modules/*.ko $(TARGET_RECOVERY_ROOT_OUT)/lib/modules/; \
    cp -f $(LOCAL_PATH)/modules/modules.load $(TARGET_RECOVERY_ROOT_OUT)/lib/modules/;

include $(BUILD_PHONY_PACKAGE)
