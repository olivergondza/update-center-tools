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

# Use scp iff username provided and port 22 is open
if [ $hostname == *@* ] && [ `echo exit | telnet ${hostname##*@} 22 > /dev/null 2> /dev/null` ]; then
  scp -r $hostname:/var/opt/update-center/$1/* $2/
else
  cd $2
  host=${hostname##*@}
  pwd
  wget -r -nd -N --no-check-certificate -A hpi,jpi --quiet http://$host/$1/download/raw-plugins/
  cd - > /dev/null
fi
