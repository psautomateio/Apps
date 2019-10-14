#!/bin/bash
#
# Title:      PSAutomate
# Based On:   PGBlitz (Reference Title File)
# Original Author(s):  Admin9705 - Deiteq
# PSAutomate Auther: fattylewis
# URL:        https://psautomate.io - http://github.psautomate.io
# GNU:        General Public License v3.0
################################################################################
mkdir -p /psa/var/emergency
mkdir -p /psa/data/blitz
rm -rf /psa/var/emergency/*
sleep 15
diskspace27=0

while true
do

# GDrive
if [[ $(rclone lsd --config /psa/rclone/psablitz.conf gd: | grep "\<psautomate\>") == "" ]]; then
  echo "🔴 Not Operational "> /psa/var/psa.gd; else echo "✅ Operational " > /psa/var/psa.gd; fi

if [[ $(ls -la /psa/gd | grep "psautomate") == "" ]]; then
  echo "🔴 Not Operational"> /psa/var/psa.gmount; else echo "✅ Operational" > /psa/var/psa.gmount; fi

# SDrive
if [[ $(rclone lsd --config /psa/rclone/psablitz.conf sd: | grep "\<psautomate\>") == "" ]]; then
  echo "🔴 Not Operational"> /psa/var/psa.sd; else echo "✅ Operational" > /psa/var/psa.sd; fi

if [[ $(ls -la /psa/sd | grep "psautomate") == "" ]]; then
  echo "🔴 Not Operational "> /psa/var/psa.smount; else echo "✅ Operational" > /psa/var/psa.smount; fi

# Union
if [[ $(rclone lsd --config /psa/rclone/psablitz.conf psaunity: | grep "\<psautomate\>") == "" ]]; then
  echo "🔴 Not Operational "> /psa/var/psa.unity; else echo "✅ Operational" > /psa/var/psa.unity; fi

if [[ $(ls -la /psa/unity | grep "psautomate") == "" ]]; then
  echo "🔴 Not Operational "> /psa/var/psa.umount; else echo "✅ Operational " > /psa/var/psa.umount; fi

# Disk Calculations - 4000000 = 4GB

leftover=$(df /psa/data/blitz | tail -n +2 | awk '{print $4}')


if [[ "$leftover" -lt "3000000" ]]; then
  diskspace27=1
  echo "Emergency: Primary DiskSpace Under 3GB - Stopped Media Programs & Downloading Programs (i.e. Plex, NZBGET, RuTorrent)" > /psa/var/emergency/message.1
  docker stop plex 1>/dev/null 2>&1
  docker stop emby 1>/dev/null 2>&1
  docker stop jellyfin 1>/dev/null 2>&1
  docker stop nzbget 1>/dev/null 2>&1
  docker stop sabnzbd 1>/dev/null 2>&1
  docker stop rutorrent 1>/dev/null 2>&1
  docker stop deluge 1>/dev/null 2>&1
  docker stop qbitorrent 1>/dev/null 2>&1
elif [[ "$leftover" -gt "3000000" && "$diskspace27" == "1" ]]; then
  docker start plex 1>/dev/null 2>&1
  docker start emby 1>/dev/null 2>&1
  docker start jellyfin 1>/dev/null 2>&1
  docker start nzbget 1>/dev/null 2>&1
  docker start sabnzbd 1>/dev/null 2>&1
  docker start rutorrent 1>/dev/null 2>&1
  docker start deluge 1>/dev/null 2>&1
  docker start qbitorrent 1>/dev/null 2>&1
  rm -rf /psa/var/emergency/message.1
  diskspace27=0
fi

##### Warning for Ports Open with Traefik Deployed
if [[ $(cat /psa/var/psa.ports) != "Closed" && $(docker ps --format '{{.Names}}' | grep "traefik") == "traefik" ]]; then
  echo "Warning: Traefik deployed with ports open! Server at risk for explotation!" > /psa/var/emergency/message.a
elif [ -e "/psa/var/emergency/message.a" ]; then rm -rf /psa/var/emergency/message.a; fi

if [[ $(cat /psa/var/psa.ports) == "Closed" && $(docker ps --format '{{.Names}}' | grep "traefik") == "" ]]; then
  echo "Warning: Apps Cannot Be Accessed! Ports are Closed & Traefik is not enabled!"
  echo "Either deploy traefik or open your ports (which is worst for security)" > /psa/var/emergency/message.b
elif [ -e "/psa/var/emergency/message.b" ]; then rm -rf /psa/var/emergency/message.b; fi
##### Warning for Bad Traefik Deployment - message.c is tied to traefik showing a status! Do not change unless you know what your doing
touch /psa/var/traefik.check
domain=$(cat /psa/var/server.domain)
wget -q "https://portainer.${domain}" -O "/psa/var/traefik.check"
if [[ $(cat /psa/var/traefik.check) == "" && $(docker ps --format '{{.Names}}' | grep traefik) == "traefik" ]]; then
  echo "Traefik is Not Deployed Properly! Cannot Reach the Portainer SubDomain!" > /psa/var/emergency/message.c
else
  if [ -e "/psa/var/emergency/message.c" ]; then
  rm -rf /psa/var/emergency/message.c; fi
fi
##### Warning for Traefik Rate Limit Exceeded
if [[ $(cat /psa/var/traefik.check) == "" && $(docker logs traefik | grep "rateLimited") != "" ]]; then
  echo "$domain's rated limited exceed | Traefik (LetsEncrypt)! Takes upto one week to"
  echo "clear up (or use a new domain)" > /psa/var/emergency/message.d
else
  if [ -e "/psa/var/emergency/message.d" ]; then
  rm -rf /psa/var/emergency/message.d; fi
fi

################# Generate Output
echo "" > /psa/var/emergency.log

if [[ $(ls /psa/var/emergency) != "" ]]; then
countmessage=0
while read p; do
  let countmessage++
  echo -n "${countmessage}. " >> /psa/var/emergency.log
  echo "$(cat /psa/var/emergency/$p)" >> /psa/var/emergency.log
done <<< "$(ls /psa/var/emergency)"
else
  echo "NONE" > /psa/var/emergency.log
fi

sleep 5
done
