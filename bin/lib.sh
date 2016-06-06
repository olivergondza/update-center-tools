# This is needed to be able to `exit` the command from subshell
set -e

### General

function command_usage() {
  echo "Usage: $uct_command $1"
}

# Invoke remote part of the command from its local part
# @param String Command name
# @param* String Arguments
function invoke_remote() {
  command_name=$1
  shift
  cat $dir/bin/lib.sh "$dir/bin/remote/$command_name.sh" | ssh $uc_authority uct_command="$command_name" "bash -s" "$@"
}

### Update center

UC_SRC_ROOTDIR="/var/opt/update-center/"
UC_DST_ROOTDIR="/var/www/"

# Get the data dir path
# @param String update center ID
# @return String path to hpi directory
function update_center_dir() {
  data_dir=$UC_SRC_ROOTDIR/$1

  if [ ! -d $data_dir ]; then
    echo "Invalid update center ID: $1" >&2
    exit 1
  fi
  echo $data_dir
}

# Extract plugin version from file name
# @param String path to file
# @return String version string
function plugin_version() {
  zipgrep '-h' Plugin-Version $1 META-INF/MANIFEST.MF | sed "s/Plugin-Version: //" | tr -d '\r' # CRLF
}

# List all plugins in update center directory
# @param String UC name
function list_plugins_in_uc() {
  list_plugins_in_dir "$(update_center_dir "$1")"
}

# List all plugins in HPI directory
# @param String Path to the dir
function list_plugins_in_dir() {
  data_dir="$1"

  for plugin in $data_dir/*.[jh]pi; do
    name=$(basename $plugin)
    line="${name%%.*} $(plugin_version $plugin)"
    if [ -f ${plugin}.pinned ]; then
      line="$line (pinned)"
    fi
    echo $line
  done
}
