#!/bin/bash

# Grab existing plugin from community update center and place it to the local update center
# Ex.: ./grab.sh jenkins-test git-plugin 1.45

if [ $# -lt 2 ]; then
  echo "Usage: $0 <update_center_id> <artifact_id> [<version>]" >&2
  exit 1
fi

destination=/var/opt/update-center/$1/$2.hpi

if [ $# -eq 2 ]; then
  url=http://updates.jenkins-ci.org/latest/$2.hpi
else
  url=http://updates.jenkins-ci.org/download/plugins/$2/$3/$2.hpi
fi

wget --no-check-certificate -nv -O $destination $url || rm $destination
