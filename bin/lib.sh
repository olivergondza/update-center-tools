# This is needed to be able to `exit` the command from subshell
set -e

# Get the data dir path
# @param String update center ID
# @return String path to hpi directory
function update_center_dir() {
  data_dir=/var/opt/update-center/$1

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
  zipgrep '-h' Plugin-Version $1 META-INF/MANIFEST.MF | sed "s/Plugin-Version: //"
}

# List all plugins in hpi directory
# @param String UC name
function list_plugins_in_uc() {
  data_dir=$(update_center_dir "$1")

  for plugin in $data_dir/*.[jh]pi; do
    name=$(basename $plugin)
    echo "${name%%.*} $(plugin_version $plugin)"
  done
}
