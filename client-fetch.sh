#!/bin/bash

# Fetch remote update center plugins to local directory
# Ex.: ./client-fetch.sh jenkins-test local-dir

if [ $# -lt 2 ]; then
  echo "Usage: $0 <update_center_id> <local-dir>" >&2
  exit 1
fi

dir="$( cd "$( dirname "$0" )" && pwd )"
hostname=`cat $dir/hostname`

if [ ! -d $2 ]; then
  mkdir $2
fi

scp -r $hostname:/var/opt/update-center/$1/* $2/
