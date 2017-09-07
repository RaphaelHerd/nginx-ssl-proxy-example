#! /usr/bin/env bash

# get primary network interface
NET_IF=`netstat -rn | awk '/^0.0.0.0/ {thif=substr($0,74,10); print thif;} /^default.*UG/ {thif=substr($0,65,10); print thif;}'`

# get ip of primary network interface
NET_IP=`ifconfig ${NET_IF} | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'`

# start compose with primary ip of device
sudo sed -e "s/LOCAL_HOST_IP/$NET_IP/g" docker-compose.yml | docker-compose --file - up