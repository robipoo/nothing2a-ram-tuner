#!/system/bin/sh
# Tap the "Action" button in Magisk / KernelSU to print current status
echo "== Nothing 2a RAM Tuner status =="
echo "swappiness:         $(cat /proc/sys/vm/swappiness)"
echo "vfs_cache_pressure: $(cat /proc/sys/vm/vfs_cache_pressure)"
echo "page-cluster:       $(cat /proc/sys/vm/page-cluster)"
echo "app freezer:        $(settings get global cached_apps_freezer)"
[ -r /sys/block/zram0/disksize ] && echo "zram size (bytes):  $(cat /sys/block/zram0/disksize)"
[ -r /sys/block/zram0/comp_algorithm ] && echo "zram algorithm:     $(cat /sys/block/zram0/comp_algorithm)"
echo
grep -E 'MemTotal|MemAvailable|SwapTotal|SwapFree' /proc/meminfo
echo
echo "Memory pressure (PSI):"
cat /proc/pressure/memory 2>/dev/null
