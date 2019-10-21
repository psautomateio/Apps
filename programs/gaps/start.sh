#!/bin/bash
#
# Title:      PSAutomate
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

################################################################################
ansible-playbook "/psa/apps/programs/${apps}/app.yml"
################################################################################
# ENDING CODE! If there is any code to execute before after deployment!

################################################################################
