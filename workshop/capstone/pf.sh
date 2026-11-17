#!/bin/bash

case "$1" in
  start)
    kubectl port-forward -n keycloak svc/keycloak-service 8082:8080 >/dev/null 2>&1 &
    kubectl port-forward -n engineering-platform svc/teams-ui-service 8080:8080 >/dev/null 2>&1 &
    kubectl port-forward -n engineering-platform svc/teams-api-service 4200:4200 >/dev/null 2>&1 &
    kubectl port-forward -n monitoring svc/grafana-stack 3000:80 >/dev/null 2>&1 &
    echo "Port-forward avviati (8082, 8080, 4200, 3000)"
    ;;
  stop)
    pkill -f "kubectl port-forward"
    echo "Port-forward terminati"
    ;;
  *)
    echo "Uso: $0 {start|stop}"
    exit 1
    ;;
esac
