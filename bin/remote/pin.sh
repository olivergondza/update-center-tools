# Pin plugins in the update center
# Ex.: ./pin.sh jenkins-test junit

if [ $# -lt 2 ]; then
  echo "Usage: $0 <update_center_id> <artifact_id...>" >&2
  exit 1
fi

data_dir=$(update_center_dir $1)

shift

for artifact in "$@"; do
  for file in $(ls $data_dir/$artifact.[jh]pi*); do
    touch "$file.pinned"
    echo "$file.pinned" >&2
  done
done
