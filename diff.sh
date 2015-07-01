#!/bin/bash

# Compare content of 2 update centers.

if [ $# -ne 2 ]; then
  echo "Usage: $0 <src_update_center_id> <dst_update_center_id>" >&2
  exit 1
fi

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

sdiff -s <($DIR/list.sh $1) <($DIR/list.sh $2)
