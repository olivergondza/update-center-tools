# Dump update center refresh statistics

for uc_dir in $UC_SRC_ROOTDIR/*; do
  uc=$(basename $uc_dir);
  echo -e "\n== $uc ==\n"

  uc_dst_dir="$UC_DST_ROOTDIR/$uc/download/raw-plugins"
  if [ ! -d "$uc_dst_dir" ]; then
    echo "Not published (not refreshed yet?)"
    continue;
  fi

  if diff -r "$uc_dir" "$uc_dst_dir" > /dev/null; then
    echo "Ok (synced)"
  else
    # Show diff
    sdiff -s <(list_plugins_in_uc "$uc") <(list_plugins_in_dir "$uc_dst_dir") || true
  fi
done
