#!/bin/bash

case "$1" in
  start)
    rate=48000
    channels=2    
    port=12345
    ip=$(hostname -I | awk '{print $1}')

    item="Monitor Source: "
    list=$(pactl list | grep "$item")
    source=${list:${#item}+1}

    $0 stop 
    index=$(pactl load-module module-simple-protocol-tcp rate=$rate format=s16le channels=$channels source=$source record=true port=$port)
    echo "Audio streamer started."
    echo "Source     = $source"
    echo "Host	   = $ip:$port"
    echo "Rate	   = $rate Hz"
    echo "Channels   = $channels"
    echo "Mod.Index  = $index"
    ;;
    
  stop)
    index=$(pactl list | grep tcp -B1 | grep M | sed 's/[^0-9]//g')
    pactl unload-module $index
    echo "Audio streamer stopped."
    ;;
    
  *)
    echo "Usage: $0 start|stop" >&2
    ;;
esac
