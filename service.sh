#!/system/bin/sh
# Runs on every boot in late_start service mode
MODDIR=${0%/*}
LOG="$MODDIR/tuner.log"
: > "$LOG"

. "$MODDIR/config.sh"

log() { echo "$(date '+%H:%M:%S') $*" >> "$LOG"; }

# wr <value> <file>: write only if the file exists and is writable
wr() {
  if [ -w "$2" ]; then
    if echo "$1" > "$2" 2>/dev/null; then log "set $2 = $1"; else log "FAILED $2"; fi
  else
    log "skip (not writable): $2"
  fi
}

# Wait until Android has fully booted, then let the system settle
until [ "$(getprop sys.boot_completed)" = "1" ]; do sleep 5; done
sleep 30
log "boot completed, applying tweaks"

# 1) Kernel virtual-memory tuning
wr "$SWAPPINESS"         /proc/sys/vm/swappiness
wr "$VFS_CACHE_PRESSURE" /proc/sys/vm/vfs_cache_pressure
wr "$PAGE_CLUSTER"       /proc/sys/vm/page-cluster

# 2) Freeze cached apps (Android's equivalent of iOS app suspension)
if [ "$ENABLE_APP_FREEZER" = "1" ]; then
  settings put global cached_apps_freezer enabled && log "cached_apps_freezer = enabled"
  device_config put activity_manager_native_boot use_freezer true && log "use_freezer = true"
fi

# 3) Optional zRAM resize
ZRAM=/sys/block/zram0
if [ "$ZRAM_SIZE_MB" -gt 0 ] && [ -d "$ZRAM" ]; then
  WANT=$((ZRAM_SIZE_MB * 1024 * 1024))
  CUR=$(cat "$ZRAM/disksize")
  if [ "$CUR" != "$WANT" ]; then
    log "resizing zram: $CUR -> $WANT"
    if swapoff /dev/block/zram0 2>>"$LOG"; then
      echo 1 > "$ZRAM/reset"
      if grep -q "$ZRAM_ALGO" "$ZRAM/comp_algorithm"; then
        echo "$ZRAM_ALGO" > "$ZRAM/comp_algorithm"
      else
        log "algorithm $ZRAM_ALGO not supported, keeping default"
      fi
      echo "$WANT" > "$ZRAM/disksize"
      mkswap /dev/block/zram0 >/dev/null 2>&1
    else
      log "swapoff failed, leaving zram untouched"
    fi
    # always try to bring swap back, even if a step above failed
    swapon /dev/block/zram0 2>>"$LOG" && log "zram swap active" || log "swapon FAILED"
  fi
fi

log "done"
