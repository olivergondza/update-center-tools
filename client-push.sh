#!/bin/bash

# Put local plugin to the remote repository via scp
# Ex.: ./client-push.sh jenkins-test path-to.hpi

if [ $# -lt 2 ]; then
  echo "Usage: $0 <update_center_id> <path_to_hpi>" >&2
  exit 1
fi

dir="$( cd "$( dirname "$0" )" && pwd )"
hostname=`cat $dir/hostname`

scp $2 $hostname:/var/opt/update-center/$1/
