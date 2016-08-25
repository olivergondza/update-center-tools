# List all plugins and their dependencies

if [ $# -lt 1 ]; then
  command_usage "dependency-list <update_center_id>" >&2
  exit 1
fi

data_dir=$(update_center_dir $1)

function extract_dependencies() {
  grep -h -A 20 Plugin-Dependencies | awk '/Plugin-Dependencies/, /Plugin-Developers/' | head -n -1 | tr -d '\r\n ' | sed s/Plugin-Dependencies://
}

for plugin in $data_dir/*.[jh]pi; do
  mf="$(unzip -p $plugin META-INF/MANIFEST.MF)"

  basename "$plugin $(grep 'Plugin-Version:' <<< "$mf" | sed 's/Plugin-Version: //')"

  grep Jenkins-Version <<< "$mf" | sed 's/.*Jenkins-Version: /    jenkins /'

  deps=$(extract_dependencies $plugin <<< "$mf")
  for dep in $(sed s/,/\\\n/g <<< $deps); do
    echo "    - $(sed -e 's/;resolution:=optional/ (optional)/g' -e 's/:/ /g' <<< "$dep")"
  done
  echo ""
done
