#!/bin/bash

# Refresh update center metadata
# Ex.: ./refre.sh jenkins-test

if [ $# -ne 1 ]; then
  echo "No update_center_id provided" >&2
  echo "Usage: $0 <update_center_id>" >&2
  exit 1
fi

cd /opt/update-center/

rm -r /var/www/$1/*

mkdir -p /var/www/$1/download/raw-plugins
cp /var/opt/update-center/$1/* /var/www/$1/download/raw-plugins/
tar -zcf /var/www/$1/download/raw-plugins.tar.gz /var/www/$1/download/raw-plugins

/opt/apache-maven-3.0.5/bin/mvn -e exec:java -Dexec.args="\
    -id $1\
    -hpiDirectory /var/opt/update-center/$1/\
    -key /etc/pki/tls/private/update-center.key\
    -certificate /etc/pki/tls/certs/update-center.crt\
    -root-certificate /etc/pki/tls/certs/update-center.crt\
    -www /var/www/$1\
    -download /var/www/$1/download\
    -repository $HOSTNAME/$1\
    -includeSnapshots\
    -pretty"

