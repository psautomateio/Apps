#!/bin/bash
#
# Title:      PSAutomate
# Based On:   PGBlitz (Reference Title File)
# Original Author(s):  Admin9705 - Deiteq
# PSAutomate Auther: fattylewis
# URL:        https://psautomate.io - http://github.psautomate.io
# GNU:        General Public License v3.0
################################################################################

# FUNCTIONS START ##############################################################
source /psa/apps/functions.sh
source /psa/apps/_appsgen.sh

# Part 1
question1 () {

# Generates the List of Apps to Install
appgen

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PSABox | Mass-App Multi-Installer | 📓 psabox.psautomate.io
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📂 Potential Apps to Install

$notrun

💾 Apps Queued for Installation

$buildup

💬 Quitting? TYPE > exit  |  💪 Ready to install? TYPE > deploy
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
read -p '🌍 Type APP for QUEUE | Press [ENTER]: ' typed < /dev/tty

if [ "$typed" == "deploy" ]; then deploying; fi

if [ "$typed" == "exit" ]; then exit; fi

current=$(cat /psa/var/psabox.buildup | grep "\<$typed\>")
if [ "$current" != "" ]; then queued && question1; fi

current=$(cat /psa/var/psabox.running | grep "\<$typed\>")
if [ "$current" != "" ]; then exists && question1; fi

current=$(cat /psa/var/program.temp | grep "\<$typed\>")
if [ "$current" == "" ]; then badinput1 && question1; fi

userlistgen
}

deploying () {

# Image Selector
image=off
while read p; do

echo $p > /psa/tmp/program_var

### If multiple images exists, a user is presented with a choice of images
bash /psa/apps/_image.sh

done </psa/var/psabox.buildup

while read p; do
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
$p - Now Installing!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

sleep 1

if [ "$p" == "nzbthrottle" ]; then nzbt; fi

# Execute Main Program
apps="${p}"
echo $apps > /psa/var/role.name
bash "/psa/apps/programs/${p}/start.sh"

# End Banner
bash /psa/apps/additional/endbanner.sh >> /psa/tmp/output.info

sleep .5
done </psa/var/psabox.buildup
echo "" >> /psa/tmp/output.info
cat /psa/tmp/output.info
final
}

# FUNCTIONS END ##############################################################
echo "" > /psa/tmp/output.info
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >> /psa/tmp/output.info
echo "🌍 Final Configuration Information ~ http://psautomate.io" >> /psa/tmp/output.info
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >> /psa/tmp/output.info

initial
question1
