#!/usr/bin/env bash
set -euo pipefail

MANAGER_IP="192.168.56.10"

if ! docker info --format '{{.Swarm.LocalNodeState}}' | grep -qx 'active'; then
  docker swarm init --advertise-addr "$MANAGER_IP"
fi

# Arquivo compartilhado entre as MVs; os workers o usam somente durante o provisionamento.
docker swarm join-token -q worker > /vagrant/.worker_join_token
chmod 0644 /vagrant/.worker_join_token
