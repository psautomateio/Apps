#!/bin/bash
#
# Title:      PSAutomate
# Based On:   PGBlitz (Reference Title File)
# Original Author(s):  Admin9705 - Deiteq
# PSAutomate Auther: fattylewis
# URL:        https://psautomate.io - http://github.psautomate.io
# GNU:        General Public License v3.0
################################################################################
program=$(cat /psa/var/role.name)
domain=$(cat /psa/var/server.domain)
port=$(cat /psa/tmp/program_port)
ip=$(cat /psa/var/server.ip)
ports=$(cat /psa/var/server.ports)

if [ "$program" == "plex" ]; then extra="/web"; else extra=""; fi

tee <<-EOF

💎 Config Info > http://$program.psautomate.io
EOF

tee <<-EOF
$program:${port} <- Traefik URL (Internal App-to-App)
EOF

if [ "$ports" == "" ]; then
tee <<-EOF
$ip:${port}${extra}
EOF
fi

if [ "$domain" != "NOT-SET" ]; then
  if [ "$ports" == "" ]; then
tee <<-EOF
$domain:${port}${extra}
EOF
  fi
tee <<-EOF
$program.$domain${extra}
EOF
fi

if [ "$program" == "plex" ]; then
if [ "$domain" != "NOT-SET" ]; then
tee <<-EOF
http://plex.${domain}:32400 <-- Use http; not https
EOF
fi

tee <<-EOF
$ip:${port}${extra}

EOF
fi
