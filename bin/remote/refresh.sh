# Refresh update center metadata

if [ $# -eq 0 ]; then
  echo "No update_center_id provided" >&2
  command_usage "refresh <update_center_id...>" >&2
  exit 1
fi

function _refresh() {
    dest=/var/www/$1
    # work in temporary directory and switch semi-atomically
    temp_dest=$(mktemp -d ${dest}.XXXX)

    __refresh $1 $temp_dest > $temp_dest/log 2>&1

    # Replace old dir with just created
    rm -rf $dest
    rm -f $temp_dest/log
    mv $temp_dest $dest
}

function __refresh() {
    dest=/var/www/$1
    temp_dest=$2

    mkdir -p $temp_dest/download/raw-plugins

    # Create flat plugins dir
    cp /var/opt/update-center/$1/* $temp_dest/download/raw-plugins/

    # Create tarbal with all the raw files in raw-plugins directory
    cd $temp_dest/download/raw-plugins
    tar -zcf $temp_dest/download/raw-plugins.tar.gz ./*
    cd -

    /opt/apache-maven-3.0.5/bin/mvn -e exec:java -Dexec.args="\
        -id default\
        -hpiDirectory /var/opt/update-center/$1/\
        -key /etc/pki/tls/private/update-center.key\
        -certificate /etc/pki/tls/certs/update-center.crt\
        -root-certificate /etc/pki/tls/certs/update-center.crt\
        -www $temp_dest\
        -download $temp_dest/download\
        -repository http://$HOSTNAME/$1\
        -includeSnapshots\
        -pretty"
}

cd /opt/update-center/

if [ $# -eq 1 ]; then
    _refresh $1
else
    while [ $# -ne 0 ]; do
      # Detach descriptors to release ssh channel
      _refresh $1 < /dev/null > /dev/null 2>&1 &
      shift
    done
fi
