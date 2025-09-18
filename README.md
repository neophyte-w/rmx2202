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
git clone --depth=1 https://github.com/neophyte-w/RMX2202CN device/realme/RMX2202CN
#克隆sm8350内核源码
git clone https://github.com/LineageOS/android_kernel_oneplus_sm8350.git kernel/qcom/sm8350
#克隆
git clone https://github.com/AOSPA/android_device_qcom_common.git device/qcom/common

```
```
#为预防编译错误
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

```

```shell
# 编译twrp镜像
make clean   #清理环境
rm -rf out/  #清除/out

export USE_CCACHE=1         # 启用 ccache
export CCACHE_EXEC=/usr/bin/ccache #设置ccache缓存路径
export ALLOW_MISSING_DEPENDENCIES=true  # 忽略编译错误
source build/envsetup.sh    # 加载构建环境
lunch twrp_RMX2202CN        # 选择设备
make bootimage -j$(nproc)  # 制作boot镜像
```
If there is no error, boot.img will be found in `out/target/product/RMX2202CN/boot.img`


## To use it:

```shell
fastboot boot boot.img
```

or

```shell
fastboot flash boot_a boot.img
fastboot flash boot_b boot.img
```
