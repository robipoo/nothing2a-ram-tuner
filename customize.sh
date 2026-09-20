#!/system/bin/sh
# Runs at install time inside Magisk / KernelSU

DEVICE="$(getprop ro.product.device)"
MODEL="$(getprop ro.product.model)"
ui_print "- Device: $MODEL ($DEVICE)"

case "$DEVICE" in
  [Pp]acman) ui_print "- Nothing Phone (2a) detected. Good to go." ;;
  *) ui_print "! This module is tuned for the Nothing Phone (2a)."
     ui_print "! Continuing anyway, values are conservative." ;;
esac

set_perm_recursive "$MODPATH" 0 0 0755 0644
set_perm "$MODPATH/service.sh"   0 0 0755
set_perm "$MODPATH/uninstall.sh" 0 0 0755
set_perm "$MODPATH/action.sh"    0 0 0755
set_perm "$MODPATH/config.sh"    0 0 0755

ui_print "- Edit config.sh inside the module folder to customize."
ui_print "- Reboot to apply."
