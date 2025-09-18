#!/system/bin/sh

# 获取总内存（单位：kB）
MemTotal=$(grep MemTotal /proc/meminfo | awk '{print $2}')
RamSizeMB=$((MemTotal / 1024))

# 计算 ZRAM 大小（最多 4096MB）
if [ $RamSizeMB -le 2048 ]; then
    zRamSizeMB=$((RamSizeMB * 3 / 4))
else
    zRamSizeMB=$((RamSizeMB / 2))
fi
[ $zRamSizeMB -gt 4096 ] && zRamSizeMB=4096

# 启用 ZRAM（如果内核支持）
if [ -f /sys/block/zram0/disksize ]; then
    echo "${zRamSizeMB}M" > /sys/block/zram0/disksize
    mkswap /dev/block/zram0
    swapon /dev/block/zram0 -p 32758
    echo "ZRAM enabled with size ${zRamSizeMB}MB" > /tmp/zram.log
else
    echo "ZRAM not supported in this kernel" > /tmp/zram.log
fi

#!/system/bin/sh

# 获取总内存（单位：kB）
MemTotal=$(grep MemTotal /proc/meminfo | awk '{print $2}')

# 计算 ZRAM 大小（最多 4GB）
if [ $MemTotal -le 524288 ]; then
    zram_size=402653184
elif [ $MemTotal -le 1048576 ]; then
    zram_size=805306368
elif [ $MemTotal -le 2097152 ]; then
    zram_size=1342177280
elif [ $MemTotal -le 3145728 ]; then
    zram_size=1610612736
elif [ $MemTotal -le 4194304 ]; then
    zram_size=2684354560
elif [ $MemTotal -le 6291456 ]; then
    zram_size=3221225472
else
    zram_size=4294967296
fi

# 启用 ZRAM（如果支持）
if [ -f /sys/block/zram0/disksize ]; then
    echo lz4 > /sys/block/zram0/comp_algorithm 2>/dev/null
    echo "$zram_size" > /sys/block/zram0/disksize
    mkswap /dev/block/zram0
    swapon /dev/block/zram0 -p 32758
    echo "ZRAM enabled with size $((zram_size / 1048576))MB" > /tmp/zram.log
else
    echo "ZRAM not supported in this kernel" > /tmp/zram.log
fi

#endif /*OPLUS_FEATURE_ZRAM_OPT*/

function configure_read_ahead_kb_values() {
	MemTotalStr=`cat /proc/meminfo | grep MemTotal`
	MemTotal=${MemTotalStr:16:8}

	dmpts=$(ls /sys/block/*/queue/read_ahead_kb | grep -e dm -e mmc)

	# Set 128 for <= 3GB &
	# set 512 for >= 4GB targets.
	if [ $MemTotal -le 3145728 ]; then
		ra_kb=128
	else
		ra_kb=512
	fi
	if [ -f /sys/block/mmcblk0/bdi/read_ahead_kb ]; then
		echo $ra_kb > /sys/block/mmcblk0/bdi/read_ahead_kb
	fi
	if [ -f /sys/block/mmcblk0rpmb/bdi/read_ahead_kb ]; then
		echo $ra_kb > /sys/block/mmcblk0rpmb/bdi/read_ahead_kb
	fi
	for dm in $dmpts; do
		dm_dev=`echo $dm |cut -d/ -f4`
		if [ "$dm_dev" = "" ]; then
			is_erofs=""
		else
			is_erofs=`mount |grep erofs |grep "${dm_dev} "`
		fi
		if [ "$is_erofs" = "" ]; then
			echo $ra_kb > $dm
		else
			echo 128 > $dm
		fi
	done
}

function configure_memory_parameters() {

	MemTotalStr=`cat /proc/meminfo | grep MemTotal`
	MemTotal=${MemTotalStr:16:8}

#!/system/bin/sh

# 检查是否支持 ZRAM
if [ -f /sys/block/zram0/disksize ]; then
    echo lz4 > /sys/block/zram0/comp_algorithm 2>/dev/null
    echo 1073741824 > /sys/block/zram0/disksize  # 设置为 1GB
    mkswap /dev/block/zram0
    swapon /dev/block/zram0 -p 32758
    echo "ZRAM enabled (1GB)" > /tmp/zram.log
fi

# 设置 read-ahead
configure_read_ahead_kb_values

# 调整虚拟内存参数（仅调试用途）
echo 0 > /proc/sys/vm/page-cluster
echo 0 > /proc/sys/vm/watermark_boost_factor

#!/system/bin/sh

# Gold 核心调度配置
echo 2 > /sys/devices/system/cpu/cpu4/core_ctl/min_cpus
echo 60 > /sys/devices/system/cpu/cpu4/core_ctl/busy_up_thres
echo 30 > /sys/devices/system/cpu/cpu4/core_ctl/busy_down_thres
echo 100 > /sys/devices/system/cpu/cpu4/core_ctl/offline_delay_ms
echo 3 > /sys/devices/system/cpu/cpu4/core_ctl/task_thres

# Gold+ 核心调度配置
echo 0 > /sys/devices/system/cpu/cpu7/core_ctl/min_cpus
echo 60 > /sys/devices/system/cpu/cpu7/core_ctl/busy_up_thres
echo 30 > /sys/devices/system/cpu/cpu7/core_ctl/busy_down_thres
echo 100 > /sys/devices/system/cpu/cpu7/core_ctl/offline_delay_ms
echo 1 > /sys/devices/system/cpu/cpu7/core_ctl/task_thres
echo 1 > /sys/devices/system/cpu/cpu7/core_ctl/nr_prev_assist_thresh

# 禁用 silver 核心调度
echo 0 > /sys/devices/system/cpu/cpu0/core_ctl/enable

# 调度器参数（可选）
echo 95 95 > /proc/sys/kernel/sched_upmigrate
echo 85 85 > /proc/sys/kernel/sched_downmigrate
echo 100 > /proc/sys/kernel/sched_group_upmigrate
echo 85 > /proc/sys/kernel/sched_group_downmigrate
echo 1 > /proc/sys/kernel/sched_walt_rotate_big_tasks

echo "Core_ctl and scheduler parameters applied" > /tmp/sched_config.log

#!/system/bin/sh

# WALT 调度器优化（若支持）
echo 325 > /proc/sys/kernel/walt_low_latency_task_threshold 2>/dev/null
echo 162 > /proc/sys/kernel/sched_min_task_util_for_colocation 2>/dev/null
echo 0 > /proc/sys/kernel/sched_boost 2>/dev/null

# 设置 governor（若支持）
echo "uag" > /sys/devices/system/cpu/cpufreq/policy0/scaling_governor 2>/dev/null
echo 0 > /sys/devices/system/cpu/cpufreq/policy0/schedutil/down_rate_limit_us 2>/dev/null
echo 0 > /sys/devices/system/cpu/cpufreq/policy0/schedutil/up_rate_limit_us 2>/dev/null
echo 1209600 > /sys/devices/system/cpu/cpufreq/policy0/uag/hispeed_freq 2>/dev/null

echo "TWRP scheduler tuning applied" > /tmp/sched_tune.log

#!/system/bin/sh
rev=$(cat /sys/devices/soc0/revision 2>/dev/null)
# 设置最小频率（防止卡顿）
echo 691200 > /sys/devices/system/cpu/cpufreq/policy0/scaling_min_freq 2>/dev/null
# 启用调度器扩展（若支持）
echo 1 > /sys/devices/system/cpu/cpufreq/policy0/schedutil/pl 2>/dev/null
# 配置 input boost（若模块存在）
if [ -f /sys/devices/system/cpu/cpu_boost/input_boost_freq ]; then
    if [ "$rev" = "1.0" ]; then
        echo "0:1382800" > /sys/devices/system/cpu/cpu_boost/input_boost_freq
    else
        echo "0:1305600" > /sys/devices/system/cpu/cpu_boost/input_boost_freq
    fi
    echo 120 > /sys/devices/system/cpu/cpu_boost/input_boost_ms
    echo "Input boost configured" > /tmp/input_boost.log
else
    echo "cpu_boost module not available" > /tmp/input_boost.log
fi

#!/system/bin/sh

# 预先读取必要信息
rev=$(cat /sys/devices/soc0/revision 2>/dev/null)
ddr_type=$(od -An -tx /proc/device-tree/memory/ddr_device_type 2>/dev/null)
ddr_type4="07"
ddr_type5="08"

log() { echo "[postboot] $*" > /dev/kmsg 2>/dev/null || echo "[postboot] $*"; }

# gold cluster policy4
if [ -d /sys/devices/system/cpu/cpufreq/policy4 ]; then
  echo "uag" > /sys/devices/system/cpu/cpufreq/policy4/scaling_governor 2>/dev/null
  echo 0 > /sys/devices/system/cpu/cpufreq/policy4/schedutil/down_rate_limit_us 2>/dev/null
  echo 0 > /sys/devices/system/cpu/cpufreq/policy4/schedutil/up_rate_limit_us 2>/dev/null
  if [ "$rev" = "1.0" ]; then
    echo 1497600 > /sys/devices/system/cpu/cpufreq/policy4/uag/hispeed_freq 2>/dev/null
  else
    echo 1555200 > /sys/devices/system/cpu/cpufreq/policy4/uag/hispeed_freq 2>/dev/null
  fi
  echo 1 > /sys/devices/system/cpu/cpufreq/policy4/schedutil/pl 2>/dev/null
  echo "80 2112000:95" > /sys/devices/system/cpu/cpufreq/policy4/uag/target_loads 2>/dev/null
else
  log "policy4 not present"
fi

# gold+ cluster policy7
if [ -d /sys/devices/system/cpu/cpufreq/policy7 ]; then
  echo "uag" > /sys/devices/system/cpu/cpufreq/policy7/scaling_governor 2>/dev/null
  echo 0 > /sys/devices/system/cpu/cpufreq/policy7/schedutil/down_rate_limit_us 2>/dev/null
  echo 0 > /sys/devices/system/cpu/cpufreq/policy7/schedutil/up_rate_limit_us 2>/dev/null
  if [ "$rev" = "1.0" ]; then
    echo 1536000 > /sys/devices/system/cpu/cpufreq/policy7/uag/hispeed_freq 2>/dev/null
  else
    echo 1670400 > /sys/devices/system/cpu/cpufreq/policy7/uag/hispeed_freq 2>/dev/null
  fi
  echo 1 > /sys/devices/system/cpu/cpufreq/policy7/schedutil/pl 2>/dev/null
  echo "80 2380800:95" > /sys/devices/system/cpu/cpufreq/policy7/uag/target_loads 2>/dev/null
else
  log "policy7 not present"
fi

# bus-dcvs/devfreq 配置（安全遍历 + 存在性判断）
SOC_ROOT=/sys/devices/platform/soc
[ -d "$SOC_ROOT" ] || SOC_ROOT=/sys/devices/platform  # 兜底

# cpu-llcc 带宽 governor: bw_hwmon
for cpubw in $SOC_ROOT/*cpu-cpu-llcc-bw/devfreq/*cpu-cpu-llcc-bw; do
  [ -d "$cpubw" ] || continue
  af="$cpubw/available_frequencies"
  [ -f "$af" ] && awk '{print $1}' "$af" > "$cpubw/min_freq" 2>/dev/null
  echo "4577 7110 9155 12298 14236 15258" > "$cpubw/bw_hwmon/mbps_zones" 2>/dev/null
  echo 4     > "$cpubw/bw_hwmon/sample_ms" 2>/dev/null
  echo 80    > "$cpubw/bw_hwmon/io_percent" 2>/dev/null
  echo 20    > "$cpubw/bw_hwmon/hist_memory" 2>/dev/null
  echo 10    > "$cpubw/bw_hwmon/hyst_length" 2>/dev/null
  echo 30    > "$cpubw/bw_hwmon/down_thres" 2>/dev/null
  echo 0     > "$cpubw/bw_hwmon/guard_band_mbps" 2>/dev/null
  echo 250   > "$cpubw/bw_hwmon/up_scale" 2>/dev/null
  echo 1600  > "$cpubw/bw_hwmon/idle_mbps" 2>/dev/null
  echo 12298 > "$cpubw/max_freq" 2>/dev/null
  echo 40    > "$cpubw/polling_interval" 2>/dev/null
done

# llcc-ddr 带宽 governor: bw_hwmon（按 DDR 类型区分 zones）
for llccbw in $SOC_ROOT/*cpu-llcc-ddr-bw/devfreq/*cpu-llcc-ddr-bw; do
  [ -d "$llccbw" ] || continue
  af="$llccbw/available_frequencies"
  [ -f "$af" ] && awk '{print $1}' "$af" > "$llccbw/min_freq" 2>/dev/null
  if [ "${ddr_type:4:2}" = "$ddr_type4" ]; then
    echo "1720 2086 2929 3879 5931 6515 8136" > "$llccbw/bw_hwmon/mbps_zones" 2>/dev/null
  elif [ "${ddr_type:4:2}" = "$ddr_type5" ]; then
    echo "1720 2086 2929 3879 6515 7980 12191" > "$llccbw/bw_hwmon/mbps_zones" 2>/dev/null
  fi
  echo 4     > "$llccbw/bw_hwmon/sample_ms" 2>/dev/null
  echo 80    > "$llccbw/bw_hwmon/io_percent" 2>/dev/null
  echo 20    > "$llccbw/bw_hwmon/hist_memory" 2>/dev/null
  echo 10    > "$llccbw/bw_hwmon/hyst_length" 2>/dev/null
  echo 30    > "$llccbw/bw_hwmon/down_thres" 2>/dev/null
  echo 0     > "$llccbw/bw_hwmon/guard_band_mbps" 2>/dev/null
  echo 250   > "$llccbw/bw_hwmon/up_scale" 2>/dev/null
  echo 1600  > "$llccbw/bw_hwmon/idle_mbps" 2>/dev/null
  echo 6515  > "$llccbw/max_freq" 2>/dev/null
  echo 40    > "$llccbw/polling_interval" 2>/dev/null
done

# snoop-l3 带宽
for l3bw in $SOC_ROOT/*snoop-l3-bw/devfreq/*snoop-l3-bw; do
  [ -d "$l3bw" ] || continue
  af="$l3bw/available_frequencies"
  [ -f "$af" ] && awk '{print $1}' "$af" > "$l3bw/min_freq" 2>/dev/null
  echo 4     > "$l3bw/bw_hwmon/sample_ms" 2>/dev/null
  echo 10    > "$l3bw/bw_hwmon/io_percent" 2>/dev/null
  echo 20    > "$l3bw/bw_hwmon/hist_memory" 2>/dev/null
  echo 10    > "$l3bw/bw_hwmon/hyst_length" 2>/dev/null
  echo 0     > "$l3bw/bw_hwmon/down_thres" 2>/dev/null
  echo 0     > "$l3bw/bw_hwmon/guard_band_mbps" 2>/dev/null
  echo 0     > "$l3bw/bw_hwmon/up_scale" 2>/dev/null
  echo 1600  > "$l3bw/bw_hwmon/idle_mbps" 2>/dev/null
  echo 9155  > "$l3bw/max_freq" 2>/dev/null
  echo 40    > "$l3bw/polling_interval" 2>/dev/null
done

# mem_latency / qoslat
for memlat in $SOC_ROOT/*lat/devfreq/*lat; do
  [ -d "$memlat" ] || continue
  af="$memlat/available_frequencies"
  [ -f "$af" ] && awk '{print $1}' "$af" > "$memlat/min_freq" 2>/dev/null
  echo 8   > "$memlat/polling_interval" 2>/dev/null
  echo 400 > "$memlat/mem_latency/ratio_ceil" 2>/dev/null
done

# gold latfloor
for latfloor in $SOC_ROOT/*cpu4-cpu*latfloor/devfreq/*cpu4-cpu*latfloor; do
  [ -d "$latfloor" ] || continue
  af="$latfloor/available_frequencies"
  [ -f "$af" ] && awk '{print $1}' "$af" > "$latfloor/min_freq" 2>/dev/null
  echo 8 > "$latfloor/polling_interval" 2>/dev/null
done

# prime latfloor
for latfloor in $SOC_ROOT/*cpu7-cpu*latfloor/devfreq/*cpu7-cpu*latfloor; do
  [ -d "$latfloor" ] || continue
  af="$latfloor/available_frequencies"
  [ -f "$af" ] && awk '{print $1}' "$af" > "$latfloor/min_freq" 2>/dev/null
  echo 8     > "$latfloor/polling_interval" 2>/dev/null
  echo 25000 > "$latfloor/mem_latency/ratio_ceil" 2>/dev/null
done

# L3 ratio ceil per core
for c in 4 5 6; do
  for l3 in $SOC_ROOT/*cpu${c}-cpu-l3-lat/devfreq/*cpu${c}-cpu-l3-lat; do
    [ -d "$l3" ] || continue
    echo 4000 > "$l3/mem_latency/ratio_ceil" 2>/dev/null
  done
done
for l3p in $SOC_ROOT/*cpu7-cpu-l3-lat/devfreq/*cpu7-cpu-l3-lat; do
  [ -d "$l3p" ] || continue
  echo 20000 > "$l3p/mem_latency/ratio_ceil" 2>/dev/null
done

# qoslat ratio ceil
for qoslat in $SOC_ROOT/*qoslat/devfreq/*qoslat; do
  [ -d "$qoslat" ] || continue
  echo 50 > "$qoslat/mem_latency/ratio_ceil" 2>/dev/null
done

# 允许系统进入深度睡眠
echo N > /sys/module/lpm_levels/parameters/sleep_disabled 2>/dev/null

log "CPU gov + bus-dcvs/devfreq tuned (rev=$rev ddr=${ddr_type:4:2})"
#!/system/bin/sh

# Sleep mode adjustment (if supported)
boot_mode=$(getprop sys.oppo_ftm_mode)
if [ -w /sys/power/mem_sleep ]; then
    if [ "$boot_mode" = "3" ]; then
        echo "s2idle" > /sys/power/mem_sleep
        echo "[postboot] s2idle sleep mode set" > /dev/kmsg
    else
        echo "deep" > /sys/power/mem_sleep
        echo "[postboot] deep sleep mode set" > /dev/kmsg
    fi
fi

# Kernel image metadata (optional in TWRP)
if [ -f /sys/devices/soc0/select_image ]; then
    image_version="10:$(getprop ro.build.id):$(getprop ro.build.version.incremental)"
    image_variant="$(getprop ro.product.name)-$(getprop ro.build.type)"
    oem_version="$(getprop ro.build.version.codename)"
    echo 10 > /sys/devices/soc0/select_image
    echo "$image_version" > /sys/devices/soc0/image_version
    echo "$image_variant" > /sys/devices/soc0/image_variant
    echo "$oem_version" > /sys/devices/soc0/image_crm_version
fi

# Console log level
console_config=$(getprop persist.vendor.console.silent.config)
if [ "$console_config" = "1" ]; then
    echo 0 > /proc/sys/kernel/printk
    echo "[postboot] console silenced" > /dev/kmsg
fi

# Governor permission (only if system user exists, mostly skipped in TWRP)
for p in 0 4 7; do
    path="/sys/devices/system/cpu/cpufreq/policy$p/schedutil/target_loads"
    [ -f "$path" ] && chown -h root.root "$path"
done

# Post-boot flag (for debugging only)
setprop vendor.post_boot.parsed 1

