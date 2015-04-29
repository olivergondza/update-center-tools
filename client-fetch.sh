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
else
  echo "Directory already exists $2" >&2
  exit 1
fi

# Use scp iff username provided and port 22 is open
if [ $hostname == *@* ] && [ `echo exit | telnet ${hostname##*@} 22 > /dev/null 2> /dev/null` ]; then
  scp -r $hostname:/var/opt/update-center/$1/* $2/
else
  host=${hostname##*@}
  tar_path=$2/plugins.tar.gz
  wget --no-check-certificate --quiet http://$host/$1/download/raw-plugins.tar.gz -O $tar_path
  tar xf $tar_path -C $2
  rm -f $tar_path
fi
