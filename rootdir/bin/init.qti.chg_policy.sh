#! /vendor/bin/sh

#
# Copyright (c) 2019-2021 Qualcomm Technologies, Inc.
# All Rights Reserved.
# Confidential and Proprietary - Qualcomm Technologies, Inc.
#
# Copyright (c) 2019 The Linux Foundation. All rights reserved.
#

#!/vendor/bin/sh

export PATH=/vendor/bin

soc_id=$(getprop ro.vendor.qti.soc_id)

case "$soc_id" in
    "415"|"439"|"456"|"501"|"502")
        echo "Detected Lahaina SoC ($soc_id)"
        # 可选：执行调试脚本（如果你打包了它）
        # /vendor/bin/init.qti.kernel.debug-lahaina.sh
        ;;
    *)
        echo "Non-Lahaina SoC ($soc_id) — skipping debug init"
        ;;
esac

setprop persist.vendor.hvdcp_opti.start 1
