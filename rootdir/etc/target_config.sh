#!/system/bin/sh

echo 0 > /proc/sys/kernel/sched_util_clamp_min

echo 30 > /proc/sys/kernel/sched_small_task
echo 0 > /proc/sys/kernel/sched_init_task_load
echo 15 > /proc/sys/kernel/sched_spill_nr_run
echo 30 > /proc/sys/kernel/sched_mostly_idle_load

