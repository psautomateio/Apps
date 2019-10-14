#!/bin/bash
#
# Title:      PSAutomate
# Based On:   PGBlitz (Reference Title File)
# Original Author(s):  Admin9705 - Deiteq
# PSAutomate Auther: fattylewis
# URL:        https://psautomate.io - http://github.psautomate.io
# GNU:        General Public License v3.0
################################################################################
appslistgen () {

# Generates App List
ls -la /psa/apps/programs/ | sed -e 's/.yml//g' \
| awk '{print $9}' | tail -n +4  > /psa/var/app.list

# Enter Items Here to Prevent them From Showing Up on AppList
sed -i -e "/watchtower/d" /psa/var/app.list
sed -i -e "/psaui/d" /psa/var/app.list

}
