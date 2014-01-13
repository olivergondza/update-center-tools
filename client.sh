#!/bin/bash

# Run command remotely on update center server
# Ex.:
#   ./client.sh grab.sh jenkins-test git-plugin 1.5
#   ./client.sh refre.sh jenkins-test

dir="$( cd "$( dirname "$0" )" && pwd )"
hostname=`cat $dir/hostname`

ssh $hostname "$@"
