#!/bin/bash
mkdir -p ~/.secrets

# Define secret files
files=(
  "postgres_root"
  "postgres_authentik"
  "authentik_secret"
)

# Generate and secure
for f in "${files[@]}"; do
    openssl rand -base64 24 > ~/.secrets/"$f"
done

chmod 600 ~/.secrets/*
