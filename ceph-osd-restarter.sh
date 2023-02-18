#!/usr/bin/bash

set -eu

INTERVAL_SECONDS=15
MEM_RESTART_THRESHOLD_KB=250000

if [ $# -ge 1 ];then
  INTERVAL_SECONDS=$1
fi

if [ $# -ge 2 ];then
  MEM_RESTART_THRESHOLD_KB=$2
fi

while true
do
  AVAILABLE_MEMORY_KB=$(free | grep ^Mem | awk '{ print $7 }')
  echo "available memory: ${AVAILABLE_MEMORY_KB} KB"

  OSD_CONTAINERS=$(docker ps -a --filter "name=ceph" --filter "status=running" --format "{{.Names}}" | grep osd)

  if [ $AVAILABLE_MEMORY_KB -lt $MEM_RESTART_THRESHOLD_KB ]; then
    echo "Restart the osd container because there is less than ${MEM_RESTART_THRESHOLD_KB} KB available."
    for OSD_CONTAINER in $OSD_CONTAINERS; do
      docker container restart $OSD_CONTAINER
    done
  fi
  sleep $INTERVAL_SECONDS
done
