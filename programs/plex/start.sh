#!/bin/bash
#
# Title:      PSAutomate
# Based On:   PGBlitz (Reference Title File)
# Original Author(s):  Admin9705 - Deiteq
# PSAutomate Auther: fattylewis
# URL:        https://psautomate.io - http://github.psautomate.io
# GNU:        General Public License v3.0
################################################################################
# DO NOT CHANGE OR DELETE!
source /psa/apps/functions.sh
apps="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
apps="$( echo "$apps" | cut -d'/' -f5- )"
common
multiimage
################################################################################
# STARTER CODE! If there is any code to execute before role deployment!

# FUNCTIONS START ##############################################################

# BAD INPUT
repeatprocess() {
  echo ""
  startfunction
}

startfunction() {
  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 PG - PLEX Installer ~ http://plex.psautomate.io
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[1] PLEX - Local  Server Install
[2] PLEX - Remote Server Install
[Z] Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
NOTE 1: Using LOCAL SERVER  - YOUR HOUSE on YOUR NETWORK? Select #1
NOTE 2: USING REMOTE SERVER - Hetzner, GCE, NETCUP & ETC? Select #2.
NOTE 3: Selected the WRONG OPTION requires > UNINSTALL > then REINSTALL!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

  read -p 'Type a Number | Press [ENTER]: ' typed </dev/tty
  echo ""
  if [ "$typed" == "2" ]; then
    echo remote >/psa/var/server.type && serverclaim
  elif [ "$typed" == "1" ]; then
    echo local >/psa/var/server.type
  elif [[ "$typed" == "z" || "$typed" == "Z" ]]; then
    exit
  else repeatprocess; fi
}

# THIRD QUESTION
serverclaim() {
  tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 Remote Plex Server - Claim the PLEX Server
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
To Claim the Plex Server, visit https://www.plex.tv/claim/ and input the
code below! You have 5 minutes to do so!

If reinstalling PLEX with a prior setup, this step as you won't need to
claim it again. Just Press [ENTER].
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

  read -p 'CLAIM NUMBER | Press [ENTER]: ' typed </dev/tty
  echo $typed >/psa/var/plex.claim && break=on
}

# FUNCTIONS END ##############################################################
startfunction

################################################################################
ansible-playbook "/psa/apps/programs/${apps}/app.yml"
################################################################################
# ENDING CODE! If there is any code to execute before after deployment!

################################################################################
