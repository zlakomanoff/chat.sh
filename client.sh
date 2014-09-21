#!/bin/bash

echo 'connecting to server...'
echo "give_me_port" | nc localhost $2 | cat
echo "my port: $port" 
#nc $1 $port
