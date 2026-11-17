#!/bin/bash

case "$1" in
  start)
    coder port-forward jade-louse-47 --tcp 8082:8082 >/dev/null 2>&1 &
    coder port-forward jade-louse-47 --tcp 8080:8080 >/dev/null 2>&1 &
    coder port-forward jade-louse-47 --tcp 4200:4200 >/dev/null 2>&1 &
    coder port-forward jade-louse-47 --tcp 3000:3000 >/dev/null 2>&1 &
    echo "Port-forward avviati (8082, 8080, 4200, 3000)"
    ;;
  stop)
    pkill -f "coder port-forward"
    echo "Port-forward terminati"
    ;;
  *)
    echo "Uso: $0 {start|stop}"
    exit 1
    ;;
esac
