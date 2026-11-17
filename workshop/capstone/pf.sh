#!/bin/bash

URLSHORTENER_NS="team-urlshortener"
KEYCLOAK_NS=keycloak
MONITORING_NS=monitoring
PLATFORM_NS=platform-engineering

case "$1" in
  start)
    case "$2" in
      platform)
        kubectl port-forward -n $KEYCLOAK_NS svc/keycloak-service 8082:8080 >/dev/null 2>&1 &
        kubectl port-forward -n $PLATFORM_NS svc/teams-ui-service 8080:8080 >/dev/null 2>&1 &
        kubectl port-forward -n $PLATFORM_NS svc/teams-api-service 4200:4200 >/dev/null 2>&1 &
        kubectl port-forward -n $MONITORING_NS svc/grafana-stack 3000:80 >/dev/null 2>&1 &
        echo "Platform avviata (8082, 8080, 4200, 3000)"
        ;;
      urlshortener)
        kubectl port-forward -n "$URLSHORTENER_NS" svc/urlshortener-front-svc 8099:8080 >/dev/null 2>&1 &
        kubectl port-forward -n "$URLSHORTENER_NS" svc/urlshortener-backend 8088:8080 >/dev/null 2>&1 &
        kubectl port-forward -n "$URLSHORTENER_NS" svc/urlshortener-redirector 8090:8080 >/dev/null 2>&1 &
        echo "Urlshortener avviato (8099, 8088, 8090)"
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
        pkill -f "kubectl port-forward.*(8082:8080|8080:8080|4200:4200|3000:80)"
        echo "Port-forward platform terminati"
        ;;
      urlshortener)
        pkill -f "kubectl port-forward.*(8099:8080|8088:8080|8090:8080)"
        echo "Port-forward urlshortener terminati"
        ;;
      "")
        pkill -f "kubectl port-forward"
        echo "Tutti i port-forward terminati"
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
