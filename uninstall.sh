#!/system/bin/sh
# Runs when the module is removed. Sysctl/zRAM changes revert on reboot by themselves;
# these two persist in Android settings, so put them back to defaults.
settings put global cached_apps_freezer device_default
device_config delete activity_manager_native_boot use_freezer
