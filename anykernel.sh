# AnyKernel3 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
kernel.string=RenderZenith kernel
do.devicecheck=1
do.modules=0
do.systemless=1
do.cleanup=1
do.cleanuponabort=0
device.name1=OnePlus6
device.name2=OnePlus6T
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


## AnyKernel install
dump_boot;

# Clean up other kernels' ramdisk overlay files
rm -rf $ramdisk/overlay;
rm -rf $ramdisk/overlay.d;

# begin ramdisk changes
# Add skip_override parameter to cmdline so user doesn't have to reflash Magisk
if [ -d $ramdisk/.backup ]; then
	mv /tmp/anykernel/overlay.d $ramdisk/overlay.d
	chmod -R 750 $ramdisk/overlay.d/*
	chown -R root:root $ramdisk/overlay.d/*
	chmod -R 755 $ramdisk/overlay.d/sbin/init.renderzenith.sh
	chown -R root:root $ramdisk/overlay.d/sbin/init.renderzenith.sh
fi;

# end ramdisk changes


write_boot;
## end install

