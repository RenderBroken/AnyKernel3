#!/system/bin/sh 

sleep 30;

# Applying RenderZenith Settings

# Disable sched_boost during CONSERVATIVE_BOOST
	echo 0 > /dev/stune/foreground/schedtune.sched_boost_no_override
	echo 0 > /dev/stune/top-app/schedtune.sched_boost_no_override

# Tune Core_CTL for proper task placement
	echo 0 > /sys/devices/system/cpu/cpu0/core_ctl/enable
	echo 0 > /sys/devices/system/cpu/cpu4/core_ctl/enable
	echo 0 > /sys/devices/system/cpu/cpu7/core_ctl/enable

# Disable CAF task placement for Big Cores
	echo 0 > /proc/sys/kernel/sched_walt_rotate_big_tasks

# Disable WALT Signal and use PELT
#	echo 1 > /proc/sys/kernel/sched_use_walt_cpu_util
#	echo 1 > /proc/sys/kernel/sched_use_walt_task_util

# Tweak IO performance after boot complete
	echo "cfq" > /sys/block/sda/queue/scheduler
	echo 128 > /sys/block/sda/queue/read_ahead_kb
	echo 128 > /sys/block/dm-0/queue/read_ahead_kb

# Input boost and stune configuration
	echo "0:1056000" > /sys/module/cpu_boost/parameters/input_boost_freq
	echo 500 > /sys/module/cpu_boost/parameters/input_boost_ms
	echo 15 > /sys/module/cpu_boost/parameters/dynamic_stune_boost
	echo 1500 > /sys/module/cpu_boost/parameters/dynamic_stune_boost_ms

# Dynamic Stune Boost during sched_boost
	echo 15 > /dev/stune/top-app/schedtune.sched_boost

# Setup Schedutil Governor
	echo "schedutil" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
	echo 500 > /sys/devices/system/cpu/cpufreq/policy0/schedutil/up_rate_limit_us
	echo 20000 > /sys/devices/system/cpu/cpufreq/policy0/schedutil/down_rate_limit_us
	echo 1 > /sys/devices/system/cpu/cpufreq/policy0/schedutil/iowait_boost_enable
	echo 0 > /sys/devices/system/cpu/cpufreq/policy0/schedutil/pl
	echo 0 > /sys/devices/system/cpu/cpufreq/policy0/schedutil/hispeed_freq

	echo "schedutil" > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor	
	echo 500 > /sys/devices/system/cpu/cpufreq/policy4/schedutil/up_rate_limit_us
	echo 20000 > /sys/devices/system/cpu/cpufreq/policy4/schedutil/down_rate_limit_us
	echo 1 > /sys/devices/system/cpu/cpufreq/policy4/schedutil/iowait_boost_enable
	echo 0 > /sys/devices/system/cpu/cpufreq/policy4/schedutil/pl
	echo 0 > /sys/devices/system/cpu/cpufreq/policy4/schedutil/hispeed_freq

# Setup EAS cpusets values for better load balancing
	echo 0-7 > /dev/cpuset/top-app/cpus
	echo 0-3,5-7 > /dev/cpuset/foreground/cpus
	echo 0-1 > /dev/cpuset/background/cpus
	echo 0-3 > /dev/cpuset/system-background/cpus
	echo 0-3 > /dev/cpuset/display/cpus

# For better screen off idle
	echo 0-3 > /dev/cpuset/restricted/cpus

# Tune FS
	echo 3000 > /proc/sys/vm/dirty_expire_centisecs
	echo 10 > /proc/sys/vm/dirty_background_ratio

# Setup runtime blkio
# value for group_idle is us
#	echo 1000 > /dev/blkio/blkio.weight
#	echo 10 > /dev/blkio/background/blkio.weight
#	echo 2000 > /dev/blkio/blkio.group_idle
#	echo 0 > /dev/blkio/background/blkio.group_idle

sleep 15;

# Disable OP Service related to OPChain and the rest
	resetprop ctl.stop oneplus_brain_service

echo "RenderZenith Boot Completed" >> /dev/kmsg
