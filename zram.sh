#!/bin/sh
# zram-swap setup

CORES=$( nproc --all )
modprobe zram num_devices="$CORES"
MEM=$( awk '/MemTotal:/ { print $2 }' /proc/meminfo )
EACH=$( expr $MEM / $CORES )

swapoff --all

for core in $( seq 0 $( expr "$CORES" - 1 ) )
do
  FREEDEV=$( zramctl --find --size "${EACH}KiB" )
  mkswap "$FREEDEV"
  swapon --priority 5 "$FREEDEV" 
done

# zramctl on raspi not as recent as x86.
# options restricted.
zramctl
