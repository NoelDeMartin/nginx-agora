#!/usr/bin/env bash

export scripts_dir=`cd $(readlink -f $0 | xargs dirname) && pwd`
export base_dir=`dirname $scripts_dir`

command=$1

case "$command" in
    'help' | '' )
        echo 'nginx-agora start                                     | start nginx-agora network and container'
        echo 'nginx-agora restart                                   | restart nginx-agora running container'
        echo 'nginx-agora install --link? <config> <root> <name?>   | install a new site'
        echo 'nginx-agora install-proxy <config> <name?>            | install a new site as a proxy'
        echo 'nginx-agora uninstall <name>                          | uninstall a site'
        echo 'nginx-agora enable <name>                             | enable a site'
        echo 'nginx-agora disable <name>                            | disable a site'
        echo 'nginx-agora stop                                      | stop nginx-agora running container'
        echo 'nginx-agora status                                    | display nginx-agora container status'
        ;;
    'start' | 'restart' | 'install' | 'install-proxy' | 'uninstall' | 'enable' | 'disable' | 'stop' | 'status' )
        $scripts_dir/$command.sh ${@:2}
        ;;
    * )
        echo "Unknown command '$command'"
        ;;
esac
