# Replace content of destination UC by the content on source UC.
# After the operations contents will be identical, the original destination content will be lost.

if [ $# -ne 2 ]; then
  command_usage "promote <src_update_center_id> <dst_update_center_id>" >&2
  exit 1
fi

src_dir=$(update_center_dir $1)
dst_dir=$(update_center_dir $2)

sdiff -s <(list_plugins_in_uc $1) <(list_plugins_in_uc $2)
if [ $? -eq 0 ]; then
  echo "No changes to promote" >&2
  exit 0
fi

echo "Promoting $1 into $2 (y/n)?"
read -n 1 input
echo
case "$input" in
  y|Y)
    echo "Promoting" >&2
  ;;
  n|N)
    echo "Aborting" >&2
    exit 0
  ;;
  *)
    echo "Invalid choice '$input'" >&2
    exit 1
  ;;
esac

rm -rf $dst_dir.bak/
mv $dst_dir/ $dst_dir.bak/
cp -r $src_dir/ $dst_dir
