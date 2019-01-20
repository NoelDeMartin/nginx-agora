#!/usr/bin/env bash

config="$1"
root=`cd $2 && pwd`

name=`basename $config`
while [[ $name =~ \. ]]; do
    name="${name%.?*}"
done

if [[ ! $config =~ .*\.conf$ ]]; then
    echo "Configuration file must end with '.conf'!"
    exit
fi

echo "Installing site $name"
cp $config $base_dir/sites_available
echo $root > $base_dir/sites_installed/$name
