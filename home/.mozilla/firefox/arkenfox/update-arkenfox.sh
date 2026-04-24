#!/usr/bin/env bash
# IMPORTANT: run in actual FF profile dir, not in repo

# update repo
cd arkenfox-upstream || exit
git pull origin master
echo "Updating arkenfox repo"
cd .. || exit

# copy scripts
# rsync because cp doesn't handle repo symlink well
rsync -avL arkenfox-upstream/updater.sh .
rsync -avL arkenfox-upstream/prefsCleaner.sh .
rsync -avL arkenfox-upstream/user.js .

# run scripts
./updater.sh
./prefsCleaner.sh
echo "Arkenfox updated"
