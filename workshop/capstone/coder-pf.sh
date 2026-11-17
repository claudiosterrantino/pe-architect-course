#!/bin/bash

WORKSPACE="jade-louse-47"

case "$1" in
  start)
    case "$2" in
      platform)
        coder port-forward "$WORKSPACE" --tcp 8082:8082 >/dev/null 2>&1 &
        coder port-forward "$WORKSPACE" --tcp 8080:8080 >/dev/null 2>&1 &
        coder port-forward "$WORKSPACE" --tcp 4200:4200 >/dev/null 2>&1 &
        coder port-forward "$WORKSPACE" --tcp 3000:3000 >/dev/null 2>&1 &
        echo "Coder port-forward platform avviati (8082, 8080, 4200, 3000)"
        ;;
      urlshortener)
        coder port-forward "$WORKSPACE" --tcp 8099:8099 >/dev/null 2>&1 &
        coder port-forward "$WORKSPACE" --tcp 8088:8088 >/dev/null 2>&1 &
        coder port-forward "$WORKSPACE" --tcp 8090:8090 >/dev/null 2>&1 &
        echo "Coder port-forward urlshortener avviati (8099, 8088, 8090)"
        ;;
      *)
        echo "Uso: $0 start {platform|urlshortener}"
        exit 1
        ;;
    esac
    ;;
  stop)
    case "$2" in
      platform)
        pkill -f "coder port-forward.*(8082:8082|8080:8080|4200:4200|3000:3000)"
        echo "Coder port-forward platform terminati"
        ;;
      urlshortener)
        pkill -f "coder port-forward.*(8099:8099|8088:8088|8090:8090)"
        echo "Coder port-forward urlshortener terminati"
        ;;
      "")
        pkill -f "coder port-forward"
        echo "Tutti i coder port-forward terminati"
        ;;
      *)
        echo "Uso: $0 stop [platform|urlshortener]"
        exit 1
        ;;
    esac
    ;;
  *)
    echo "Uso: $0 {start|stop} {platform|urlshortener}"
    exit 1
    ;;
esac
