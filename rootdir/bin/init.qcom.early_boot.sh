#!/vendor/bin/sh

# 获取屏幕宽度并设置 LCD 密度
if [ -f /sys/class/graphics/fb0/virtual_size ]; then
    fb_width=$(cut -d',' -f1 /sys/class/graphics/fb0/virtual_size 2>/dev/null)
    if [ "$fb_width" -ge 1600 ]; then
        setprop vendor.display.lcd_density 640
    elif [ "$fb_width" -ge 1080 ]; then
        setprop vendor.display.lcd_density 480
    elif [ "$fb_width" -ge 720 ]; then
        setprop vendor.display.lcd_density 320
    else
        setprop vendor.display.lcd_density 240
    fi
else
    setprop vendor.display.lcd_density 320
fi

# 设置 GPU 可用频率（如支持）
if [ -f /sys/class/kgsl/kgsl-3d0/gpu_available_frequencies ]; then
    gpu_freq=$(cat /sys/class/kgsl/kgsl-3d0/gpu_available_frequencies 2>/dev/null)
    setprop vendor.gpu.available_frequencies "$gpu_freq"
fi
