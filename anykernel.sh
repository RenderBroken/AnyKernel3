# AnyKernel3 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
kernel.string=RenderZenith kernel
do.devicecheck=1
do.modules=0
do.cleanup=1
do.cleanuponabort=0
device.name1=OnePlus7Pro
device.name2=guacamole
device.name3=OnePlus7
device.name4=guacamoleb
device.name5=OnePlus7ProTMO
device.name6=guacamoles
device.name7=OnePlus7TPro
device.name8=hotdog
device.name9=OnePlus7T
device.name10=hotdogb
supported.versions=10
supported.patchlevels=
'; } # end properties

# shell variables
block=/dev/block/bootdevice/by-name/boot;
is_slot_device=1;
ramdisk_compression=auto;


## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. tools/ak3-core.sh;


## AnyKernel file attributes
# set permissions/ownership for included ramdisk files
set_perm_recursive 0 0 755 644 $ramdisk/*;
set_perm_recursive 0 0 750 750 $ramdisk/init* $ramdisk/sbin;


## begin vendor changes
mount -o rw,remount -t auto /vendor >/dev/null;

# Make a backup of init.target.rc
restore_file /vendor/etc/init/hw/init.target.rc;
backup_file /vendor/etc/init/hw/init.target.rc;

# Do work
replace_string /vendor/etc/init/hw/init.target.rc "write /dev/stune/top-app/schedtune.colocate 0" "write /dev/stune/top-app/schedtune.colocate 1" "write /dev/stune/top-app/schedtune.colocate 0";

# Add RZ tweaks
append_file /vendor/etc/init/hw/init.target.rc "R4ND0MSTR1NG" init.target.rc;


## AnyKernel install
dump_boot;

# Clean up other kernels' ramdisk overlay files
rm -rf $ramdisk/overlay;
rm -rf $ramdisk/overlay.d;

# begin ramdisk changes
# Add skip_override parameter to cmdline so user doesn't have to reflash Magisk
#if [ -d $ramdisk/.backup ]; then
#	ui_print " "; ui_print "Magisk detected! Patching cmdline so reflashing Magisk is not necessary...";
#	patch_cmdline "skip_override" "skip_override";
#	mv /tmp/anykernel/overlay.d $ramdisk/overlay.d
#	chmod -R 750 $ramdisk/overlay.d/*
#	chown -R root:root $ramdisk/overlay.d/*
#	chmod -R 755 $ramdisk/overlay.d/sbin/init.renderzenith.sh
#	chown -R root:root $ramdisk/overlay.d/sbin/init.renderzenith.sh
#else
#	patch_cmdline "skip_override" "";
#fi;

# end ramdisk changes

write_boot;
## end install

