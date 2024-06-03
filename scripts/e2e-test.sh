#!/bin/bash

set -eo pipefail

GREEN='\033[0;32m'
NC='\033[0m'

log() {
    echo -e "${GREEN}$1${NC}"
}

log "Running e2e tests..."

log "Creating kind cluster..."
make kind-create-cluster

log "Installing cert-manager..."
make install-and-wait-cert-manager

log "Building latest version of the operator and installing it via Helm..."
make helm-install-local

log "Waiting for Armada Operator pod to be ready..."
kubectl wait --for='condition=Ready' pods -l 'app.kubernetes.io/name=armada-operator' --timeout=600s --namespace armada-system

log "Deleting kind cluster..."
make kind-delete-cluster
