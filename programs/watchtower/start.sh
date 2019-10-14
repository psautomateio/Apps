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
################################################################################
# STARTER CODE! If there is any code to execute before role deployment!

# Generates App List From Core Apps
ls -la /psa/apps/programs/ | sed -e 's/.yml//g' \
| awk '{print $9}' | tail -n +4 > /psa/var/app.list

# Exemption List to Prevent WatchTower from Adding
sed -i -e "/traefik/d" /psa/var/app.list
sed -i -e "/image*/d" /psa/var/app.list
sed -i -e "/_appsgen.sh/d" /psa/var/app.list
sed -i -e "/_c*/d" /psa/var/app.list
sed -i -e "/_a*/d" /psa/var/app.list
sed -i -e "/_t*/d" /psa/var/app.list
sed -i -e "/templates/d" /psa/var/app.list
sed -i -e "/retry/d" /psa/var/app.list
sed -i "/^test\b/Id" /psa/var/app.list
sed -i -e "/nzbthrottle/d" /psa/var/app.list
sed -i -e "/watchtower/d" /psa/var/app.list
sed -i "/^_templates.yml\b/Id" /psa/var/app.list
sed -i -e "/oauth/d" /psa/var/app.list
sed -i -e "/dockergc/d" /psa/var/app.list
sed -i -e "/psaui/d" /psa/var/app.list

while read p; do
  echo -n $p >> /psa/tmp/watchtower.set
  echo -n " " >> /psa/tmp/watchtower.set
done </psa/var/app.list
################################################################################
ansible-playbook "/psa/apps/programs/${apps}/app.yml"
################################################################################
# ENDING CODE! If there is any code to execute before after deployment!

################################################################################
