#!/bin/bash
echo "=== COMPLETE PLATFORM VERIFICATION ==="
echo -n "[Gatekeeper Pods]: "
kubectl get pods -n gatekeeper-system --no-headers | wc -l
echo -n "[Falco Pods]: "
kubectl get pods -n falco-system --no-headers | wc -l
echo -n "[Teams API Deployment]: "
kubectl get deployment teams-api -n engineering-platform -o jsonpath='{.status.readyReplicas}'
echo ""
echo -n "[Teams Operator Deployment]: "
kubectl get deployment teams-operator -n engineering-platform -o jsonpath='{.status.readyReplicas}'
echo ""
echo -n "[Teams UI Deployment]: "
kubectl get deployment teams-ui -n engineering-platform -o jsonpath='{.status.readyReplicas}'
echo ""
echo -n "[Teams Censiti nell'API]: "
curl -s http://localhost:4200/teams | jq length
echo -n "[Namespace Gestiti dall'Operator]: "
kubectl get ns -l app.kubernetes.io/managed-by=teams-operator --no-headers | wc -l
echo "=== PLATFORM READY ==="
