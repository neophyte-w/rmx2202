# TWRP device tree for OPLUS sm8350

## Supported devices

- Realme GT(RMX2202CN)
## Build it yourself?

```shell
#创建文件夹
mkdir twrp && cd twrp
#初始化repo
repo init --depth=1 -u https://github.com/TWRP-Test/platform_manifest_twrp_aosp.git -b twrp-16.0
#同步
repo sync
#克隆设备树源码
git clone --depth=1 https://github.com/neophyte-w/rmx2202 device/realme/RMX2202
#克隆sm8350内核源码
git clone https://github.com/LineageOS/android_kernel_oneplus_sm8350.git kernel/qcom/sm8350
#克隆
git clone https://github.com/AOSPA/android_device_qcom_common.git device/qcom/common

```
```shell
#为预防编译错误提前修改--1
#No user specified for service 'charger', so it would have been root.
#No user specified for service 'recovery', so it would have been root.
#No user specified for service 'adbd', so it would have been root.
cd ~/twrp/bootable/recovery/etc/  打开init.rc
搜索对应代码替换为以下：
service charger /system/bin/charger
    class core
    user root
    group root
    critical
    seclabel u:r:charger:s0

service recovery /system/bin/recovery
    class main
    user root
    group system
    socket recovery stream 422 system system
    seclabel u:r:recovery:s0

service adbd /system/bin/adbd --root_seclabel=u:r:su:s0 --device_banner=recovery
    class main
    user root
    group system shell log
    disabled
    socket adbd stream 660 system system
    seclabel u:r:adbd:s0

############################################################################

#为预防编译错误提前修改--2
# mkbootimg: error: ambiguous option: --dt could match --dtb, --dtb_offset
# cd ~/twrp/build/make/core/Makefile
# 大概1356行
INTERNAL_BOOTIMAGE_ARGS += --dt $(INSTALLED_DTIMAGE_TARGET) 
# 大概2778行
INTERNAL_RECOVERYIMAGE_ARGS += --dt $(INSTALLED_DTIMAGE_TARGET)
# 改成以下：
INTERNAL_BOOTIMAGE_ARGS += --dtb $(INSTALLED_DTIMAGE_TARGET)
INTERNAL_RECOVERYIMAGE_ARGS += --dtb $(INSTALLED_DTIMAGE_TARGET)

# 如果设备需要偏移（BOARD_DTB_OFFSET），则改成：
INTERNAL_BOOTIMAGE_ARGS += --dtb $(INSTALLED_DTIMAGE_TARGET) --dtb_offset $(BOARD_DTB_OFFSET)
INTERNAL_RECOVERYIMAGE_ARGS += --dtb $(INSTALLED_DTIMAGE_TARGET) --dtb_offset $(BOARD_DTB_OFFSET)

```

```shell
# 编译twrp镜像
make clean   #清理环境（上次编译错误）
make clobber #清理构建产物 + 部分缓存
rm -rf out/  #清除/out路径下所有构建产物和缓存，建议大量错误时使用
make installclean #保留中间产物加速重编译
#开始编译twrp
export ALLOW_MISSING_DEPENDENCIES=true  # 忽略编译错误
source build/envsetup.sh    # 加载构建环境
lunch twrp_RMX2202CN        # 选择设备
make bootimage -j$(nproc)  # 制作boot镜像
```
If there is no error, boot.img will be found in `out/target/product/RMX2202/boot.img`


## To use it:

```shell
fastboot boot boot.img
```

or

```shell
fastboot flash boot_a boot.img
fastboot flash boot_b boot.img
```
