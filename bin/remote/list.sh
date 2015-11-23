# List plugins with versions

if [ $# -ne 1 ]; then
  command_usage "list <update_center_id>" >&2
  exit 1
fi

list_plugins_in_uc "$1"
