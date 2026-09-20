#!/system/bin/sh
# ---- User settings: edit, then reboot ----

# How eagerly the kernel moves idle app memory into compressed zRAM.
SWAPPINESS=100

# Lower = kernel keeps filesystem metadata cached longer (snappier app launches).
VFS_CACHE_PRESSURE=80

# 0 = don't read ahead when swapping in from zRAM (RAM is random access,
# so read-ahead only wastes CPU). Recommended: 0.
PAGE_CLUSTER=0

# Freeze cached (background) apps so they use zero CPU, similar to iOS suspension.
ENABLE_APP_FREEZER=1

# OPTIONAL: resize zRAM. 0 = leave alone (recommended to start).
ZRAM_SIZE_MB=0

# lz4 is fastest, zstd compresses better. Used only if ZRAM_SIZE_MB > 0.
ZRAM_ALGO=lz4
