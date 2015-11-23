# List plugins with versions

if [ $# -ne 1 ]; then
  echo "Usage: $0 <update_center_id>" >&2
  exit 1
fi

data_dir=$(update_center_dir "$1")

for plugin in $data_dir/*.[jh]pi; do
  name=$(basename $plugin)
  echo "${name%%.*} $(plugin_version $plugin)"
done
