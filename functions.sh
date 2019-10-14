#!/bin/bash
#
# Title:      PSAutomate
# Based On:   PGBlitz (Reference Title File)
# Original Author(s):  Admin9705 - Deiteq
# PSAutomate Auther: fattylewis
# URL:        https://psautomate.io - http://github.psautomate.io
# GNU:        General Public License v3.0
################################################################################
variable () {
  file="$1"
  if [ ! -e "$file" ]; then echo "$2" > $1; fi
}
################################################################################
common () {
  echo "${apps}" > /psa/var/role.name
  mkdir -p "/psa/data/${apps}"

  variable /psa/var/tld.status ""
  variable /psa/var/oauth.status ""
  variable /psa/var/domain.status "NOT-SET"
  variable /psa/var/port.status ""
  variable /psa/var/tld.status "portainer"

  if [[ "apps" != "plex" ]]; then
    chown -R 1000:1000 "/psa/data/${apps}"
    chmod -R 775 "/psa/data/${apps}"
  else
    chown 1000:1000 "/psa/data/${apps}"
    chmod 775 "/psa/data/${apps}"
  fi

  docker stop "${apps}" 1>/dev/null 2>&1
  docker rm "${apps}" 1>/dev/null 2>&1
}
################################################################################
appgen () {

### Blank Out Temp List
rm -rf /psa/var/program.temp && touch /psa/var/program.temp

### List Out Apps In Readable Order (One's Not Installed)
sed -i -e "/templates/d" /psa/var/app.list
touch /psa/tmp/test.99
num=0
while read p; do
  echo -n $p >> /psa/var/program.temp
  echo -n " " >> /psa/var/program.temp
  num=$[num+1]
  if [ "$num" == 10 ]; then
    num=0
    echo " " >> /psa/var/program.temp
  fi
done </psa/var/app.list

notrun=$(cat /psa/var/program.temp)
buildup=$(cat /psa/var/psabox.output)

if [ "$buildup" == "" ]; then buildup="NONE"; fi
}
################################################################################
userlistgen () {
echo "$typed" >> /psa/var/psabox.buildup
num=0

touch /psa/var/psabox.output && rm -rf /psa/var/psabox.output

while read p; do
echo -n $p >> /psa/var/psabox.output
echo -n " " >> /psa/var/psabox.output
if [ "$num" == 8 ]; then
  num=0
  echo " " >> /psa/var/psabox.output
fi
done </psa/var/psabox.buildup

sed -i "/^$typed\b/Id" /psa/var/app.list

question1
}
################################################################################
badinput () {
echo
read -p '⛔️ ERROR - Bad Input! | Press [ENTER] ' typed < /dev/tty
}

badinput1 () {
echo
read -p '⛔️ ERROR - Bad Input! | Press [ENTER] ' typed < /dev/tty
question1
}

variable () {
  file="$1"
  if [ ! -e "$file" ]; then echo "$2" > $1; fi
}

initial () {
  rm -rf /psa/var/psabox.output 1>/dev/null 2>&1
  rm -rf /psa/var/psabox.buildup 1>/dev/null 2>&1
  rm -rf /psa/var/program.temp 1>/dev/null 2>&1
  rm -rf /psa/var/app.list 1>/dev/null 2>&1
  touch /psa/var/psabox.output
  touch /psa/var/program.temp
  touch /psa/var/app.list
  touch /psa/var/psabox.buildup

  # from _appsgen.sh (generates the list of apps to install)
  appslistgen

  docker ps | awk '{print $NF}' | tail -n +2 > /psa/var/psabox.running
}

queued () {
echo
read -p '⛔️ ERROR - APP Already Queued! | Press [ENTER] ' typed < /dev/tty
question1
}

exists () {
echo ""
echo "⛔️ ERROR - APP Already Installed!"
read -p '⚠️  Do You Want To ReInstall ~ y or n | Press [ENTER] ' foo < /dev/tty

if [ "$foo" == "y" ]; then part1;
elif [ "$foo" == "n" ]; then question1;
else exists; fi
}

final () {
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  read -p '✅ Process Complete! | PRESS [ENTER] ' typed < /dev/tty
  echo
  exit
}

part1 () {
echo "$typed" >> /psa/var/psabox.buildup
num=0

touch /psa/var/psabox.output && rm -rf /psa/var/psabox.output

while read p; do
echo -n $p >> /psa/var/psabox.output
echo -n " " >> /psa/var/psabox.output
if [ "$num" == 7 ]; then
  num=0
  echo " " >> /psa/var/psabox.output
fi
done </psa/var/psabox.buildup

sed -i "/^$typed\b/Id" /psa/var/app.list

question1
}

# Multi-Image Selector #########################################################
multiimage() {

  # Checks Image List
  file="/psa/apps/image/$apps"
  if [ ! -e "$file" ]; then exit; fi

  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌵  PSA Multi Image Selector - $apps
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

  count=1
  while read p; do
    echo "[$count] $p"
    echo "$p" >/tmp/display$count
    count=$((count + 1))
  done </psa/apps/image/$apps
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  read -p '🚀  Type Number | PRESS [ENTER]: ' typed </dev/tty

  if [[ "$typed" -ge "1" && "$typed" -lt "$count" ]]; then
    cat "/tmp/display$typed" > "/psa/var/image.select"
  else
    multiimage
  fi
}
# END OF MULTIIMAGE ############################################################
