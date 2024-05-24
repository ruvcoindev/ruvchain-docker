#!/bin/bash
set -euo pipefail

### ---- ###

echo "Switch back to master"
git checkout master
git reset --hard origin/master

### ---- ###

version=$(curl -s "https://lv.luzifer.io/catalog-api/ruvchain-go/latest.txt?p=version")
grep -q "RUVCHAIN_VERSION=${version}" Dockerfile && exit 0 || echo "Update required"

sed -Ei \
	-e "s/RUVCHAIN_VERSION=[0-9.]+/RUVCHAIN_VERSION=${version}/" \
	Dockerfile

### ---- ###

echo "Testing build..."
docker build .

### ---- ###

echo "Updating repository..."
git add Dockerfile
git -c user.name='Travis Automated Update' -c user.email='admin@ruvcha.in' \
	commit -m "ruvchain ${version}"
git tag v${version}

git push -q https://${GH_USER}:${GH_TOKEN}@github.com/ruvcoindev/ruvchain-docker master --tags
