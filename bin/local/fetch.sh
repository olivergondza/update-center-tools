# Fetch remote update center plugins to local directory

if [ $# -lt 2 ]; then
  echo "Usage: $uct_command fetch <update_center_id> <local-dir>" >&2
  exit 1
fi

if [ ! -d "$2" ]; then
  mkdir "$2"
  trap 'rm -rf "$2"' ERR
else
  echo "Directory already exists '$2'" >&2
  exit 1
fi

# Use scp iff username provided and port 22 is open
if [ $uc_hostname == *@* ] && [ $(echo exit | telnet ${uc_hostname##*@} 22 > /dev/null 2> /dev/null) ]; then
  scp -r $uc_hostname:/var/opt/update-center/$1/* $2/
else
  tar_path=$2/plugins.tar.gz
  src_path=http://$uc_hostname/$1/download/raw-plugins.tar.gz
  curl -LkSsf $src_path -o $tar_path
  if [ $? -ne 0 ]; then
    echo "Failed to download: $src_path" >&2
    exit 1
  fi
  tar xf $tar_path -C $2
  rm -f $tar_path
fi
