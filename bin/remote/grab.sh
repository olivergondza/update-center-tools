# Grab existing plugin from community update center and place it to the local update center

if [ $# -lt 2 ]; then
  echo "Usage: $uct_command grab <update_center_id> <artifact_id> [<version>]" >&2
  exit 1
fi

destination=/var/opt/update-center/$1/$2.hpi

if [ $# -eq 2 ]; then
  url=http://updates.jenkins-ci.org/latest/$2.hpi
else
  url=http://updates.jenkins-ci.org/download/plugins/$2/$3/$2.hpi
fi

# Delete all existing artifacts that might be using different suffix
# to avoid both .jpi and .hpi to be present. Keep .pinned, though.
rm -vf /var/opt/update-center/$1/$2.[jh]p[il] || true

wget --no-check-certificate -nv -O $destination $url || rm $destination
