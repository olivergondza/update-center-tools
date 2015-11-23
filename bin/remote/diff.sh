# Compare content of 2 update centers.

if [ $# -ne 2 ]; then
  echo "Usage: $0 <src_update_center_id> <dst_update_center_id>" >&2
  exit 1
fi

sdiff -s <(list_plugins_in_uc $1) <(list_plugins_in_uc $2)
