#!/bin/bash

echo 'connecting to server...'
port=$(echo "give_me_port" | nc localhost $2)
echo "my port: $port" 
nc $1 $port
