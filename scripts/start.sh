#!/usr/bin/env bash

if [[ -z `docker network ls --quiet --filter name=nginx-agora` ]]; then
    echo "Creating network 'nginx-agora'"
    docker network create nginx-agora
fi

if [[ -z `docker container ls --all --quiet --filter name=nginx-agora` ]]; then

    echo "Creating container 'nginx-agora'"

    volumes=""
    for name in `ls $base_dir/sites_installed`; do
        siteroot=`sed -n "1p" $base_dir/sites_installed/$name`

        if [ "$siteroot" != "proxy" ]; then
            volumes="$volumes --volume $siteroot:/var/www/$name"
        fi
    done

    docker run -d \
        --name nginx-agora \
        --restart unless-stopped \
        --publish 80:80 \
        --publish 443:443 \
        --volume $base_dir/sites_available:/etc/nginx/sites_available \
        --volume $base_dir/sites_enabled:/etc/nginx/conf.d \
        --volume /etc/letsencrypt:/etc/letsencrypt \
        $volumes \
        --network nginx-agora \
        nginx

elif [[ -z `docker container ls --quiet --filter name=nginx-agora` ]]; then
    echo "Starting container 'nginx-agora'"
    docker start nginx-agora
fi
