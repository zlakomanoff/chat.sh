#!/bin/bash

echo 'durak.sh'
echo 'select mode: server|client'

while read mode; do
	mode=( $mode )
	case "${mode[0]]}" in
		'server')
			if [[ -z ${mode[1]} ]]; then
				host='localhost'
			else
				host=${mode[1]}
			fi
			if [[ -z ${mode[2]} ]]; then
				port=1234
			else
				port=${mode[2]}
			fi
			bash game_server.sh $port &
			sleep 1
			bash client.sh $host $port
			;;
		'client')
			if [[ -z ${mode[1]} ]]; then
				echo 'port required'
				continue
			fi
			if [[ -z ${mode[2]} ]]; then
				echo 'host required'
				continue
			fi
			bash client.sh "${mode[1]]}" "${mode[2]]}"
			;;
		*)
			echo 'select mode: server [port] | client [port] [ip]'
	esac
done

