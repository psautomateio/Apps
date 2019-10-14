#!/bin/bash
#
# Title:      PSAutomate
# Based On:   PGBlitz (Reference Title File)
# Original Author(s):  Admin9705 - Deiteq
# PSAutomate Auther: fattylewis
# URL:        https://psautomate.io - http://github.psautomate.io
# GNU:        General Public License v3.0
################################################################################

# BAD INPUT
badinput () {
echo
read -p '⛔️ ERROR - BAD INPUT! | PRESS [ENTER] ' typed < /dev/tty
question1
}

# FUNCTION - ONE
question1 () {

# Recall Program
image=$(cat /psa/tmp/program_var)

# Checks Image List
file="/psa/apps/programs/$image/image.sh"
if [ ! -e "$file" ]; then exit; fi

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌵  PG Multi Image Selector - $image
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

count=1
while read p; do
  echo "$count - $p"
  echo "$p" > /psa/tmp/display$count
  count=$[count+1]
done </psa/apps/programs/$image/image.sh
echo ""
read -p '🚀  Type Number | PRESS [ENTER]: ' typed < /dev/tty

  if [[ "$typed" -ge "1" && "$typed" -lt "$count" ]]; then
  mkdir -p /psa/var/image
  cat "/psa/tmp/display$typed" > "/psa/var/image/$image"
else badinput; fi
}

# END OF FUNCTIONS ############################################################

question1
