# Duplicate existing collection

if [ $# -ne 2 ]; then
  command_usage "copy-collection <src_update_center_id> <new_update_center_id>" >&2
  exit 1
fi

src="/var/opt/update-center/$1"
if [ ! -d $src ]; then
  echo "$src does not exist" >&2
  exit 1
fi

dst="/var/opt/update-center/$2"
if [ -d $dst ]; then
  echo "$dst exists already" >&2
  exit 1
fi

set -x
cp -r "$src" "$dst"
