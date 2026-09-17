#!/usr/bin/env bash
set -euo pipefail

MANAGER_IP="$1"
TOKEN_FILE="/vagrant/.worker_join_token"

# O Vagrant executa as máquinas na ordem definida; a espera mantém o script
# idempotente caso o Docker do manager leve alguns segundos para iniciar.
for _ in $(seq 1 60); do
  if [ -s "$TOKEN_FILE" ]; then
    break
  fi
  sleep 2
done

if [ ! -s "$TOKEN_FILE" ]; then
  echo "Token de entrada do Swarm não encontrado em ${TOKEN_FILE}." >&2
  exit 1
fi

if ! docker info --format '{{.Swarm.LocalNodeState}}' | grep -qx 'active'; then
  docker swarm join --token "$(tr -d '\r\n' < "$TOKEN_FILE")" "$MANAGER_IP:2377"
fi
