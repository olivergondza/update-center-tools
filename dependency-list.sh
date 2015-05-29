#!/bin/bash

if [ $# -lt 2 ]; then
  echo "Usage: $0 <update_center_id>" >&2
  exit 1
fi

data_dir=/var/opt/update-center/$1

function extract_dependencies() {
  zipgrep '-h -A 20' Plugin-Dependencies $1 META-INF/MANIFEST.MF | awk '/Plugin-Dependencies/, /Plugin-Developers/' | head -n -1 | tr -d '\r\n ' | sed s/Plugin-Dependencies://
}

for plugin in $data_dir/*.[jh]pi; do
  basename $plugin

  deps=`extract_dependencies $plugin`

  for dep in `sed s/,/\\\n/g <<< $deps`; do
    echo "    `sed "s/;resolution:=optional/ (optional)/" <<< $dep`"
  done
done
