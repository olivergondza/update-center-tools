# Put local plugin to the remote repository via scp

if [ $# -lt 2 ]; then
  command_usage "push <update_center_id> <path_to_hpi> [<targe_file_name>]" >&2
  exit 1
fi

if [ ! -z $3 ]; then
  target=$3
  if [[ $target != *.hpi ]]; then
    target="${target}.hpi"
  fi
else
  target=$(basename "$2")
fi

scp "$2" $uc_authority:/var/opt/update-center/$1/$target
