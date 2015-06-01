#!/bin/bash

# List plugins with versions

if [ $# -lt 1 ]; then
  echo "Usage: $0 <update_center_id>" >&2
  exit 1
fi

data_dir=/var/opt/update-center/$1

function version() {
  zipgrep '-h' Plugin-Version $1 META-INF/MANIFEST.MF | sed "s/Plugin-Version: //"
}

for plugin in $data_dir/*.[jh]pi; do
  echo "`basename $plugin`:`version $plugin`"
done
