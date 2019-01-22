#!/usr/bin/env bash

export scripts_dir=`cd $(readlink -f $0 | xargs dirname) && pwd`
export base_dir=`dirname $scripts_dir`

command=$1

case "$command" in
    'help' | '' )
        echo 'nginx-agora start                             | start nginx-agora network and container'
        echo 'nginx-agora restart                           | restart nginx-agora running container'
        echo 'nginx-agora install <config> <root> <name?>   | install a new site'
        echo 'nginx-agora stop                              | stop nginx-agora running container'
        echo 'nginx-agora status                            | display nginx-agora container status'
        ;;
    'start' | 'restart' | 'install' | 'stop' | 'status' )
        $scripts_dir/$command.sh ${@:2}
        ;;
    * )
        echo "Unknown command '$command'"
        ;;
esac
