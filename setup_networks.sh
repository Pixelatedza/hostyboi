#!/bin/bash

# List of networks to ensure exist
NETWORKS=("traefik" "postgres")

for net in "${NETWORKS[@]}"; do
  if ! docker network inspect "$net" >/dev/null 2>&1; then
    echo "Creating network: $net"
    docker network create "$net"
  else
    echo "Network $net already exists, skipping."
  fi
done
