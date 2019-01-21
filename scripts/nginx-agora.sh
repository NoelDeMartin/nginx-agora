#!/usr/bin/env bash

export scripts_dir=`cd $(dirname $0) && pwd`
export base_dir=`dirname $scripts_dir`

command=$1

case "$command" in
    'help' | '' )
        echo 'start: Starts nginx-agora'
        echo 'restart: Restarts nginx-agora'
        echo 'install [config] [root]: Install a new site'
        echo 'stop: Stops nginx-agora'
        echo 'status: Print nginx-agora status'
        ;;
    'start' | 'restart' | 'install' | 'stop' | 'status' )
        $scripts_dir/$command.sh ${@:2}
        ;;
    * )
        echo "Unknown command '$command'"
        ;;
esac
