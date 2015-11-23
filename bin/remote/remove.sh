# Remove plugins from update center. This is destructive operation.
# Ex.: ./grab.sh jenkins-test git-plugin

if [ $# -lt 2 ]; then
  echo "Usage: $0 <update_center_id> <artifact_id...>" >&2
  exit 1
fi

data_dir=$(update_center_dir $1)

shift

for artifact in "$@"; do
  rm -v $data_dir/$artifact.[jh]p[il]*
done
