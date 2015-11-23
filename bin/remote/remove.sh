# Remove plugins from update center. This is destructive operation.

if [ $# -lt 2 ]; then
  command_usage "remove <update_center_id> <artifact_id...>" >&2
  exit 1
fi

data_dir=$(update_center_dir $1)

shift

for artifact in "$@"; do
  rm -v $data_dir/$artifact.[jh]p[il]*
done
