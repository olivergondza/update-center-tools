#!/bin/bash

# Replace content of destination UC by the content on source UC.
# After the operations contents will be identical, the original destination content will be lost.

if [ $# -ne 2 ]; then
  echo "Usage: $0 <src_update_center_id> <dst_update_center_id>" >&2
  exit 1
fi

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

src_dir="/var/opt/update-center/$1"
if [ ! -d $src_dir ]; then
  echo "Source UC does not exist: $src_dir" >&2
  exit 1
fi
dst_dir="/var/opt/update-center/$2"
if [ ! -d $dst_dir ]; then
  echo "Destination UC does not exist: $dst_dir" >&2
  exit 1
fi

sdiff -s <($DIR/list.sh $1) <($DIR/list.sh $2)
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
