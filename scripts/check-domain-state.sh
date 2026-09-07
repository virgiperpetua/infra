#!/usr/bin/env bash

set -euo pipefail

profile="${AWS_PROFILE:-virgiperpetua-dns}"
zone_name="${1:-virgiperpetua.com}"

echo "Using AWS profile: ${profile}"
echo "Checking AWS caller identity..."
aws sts get-caller-identity --profile "$profile"

echo
echo "Looking up hosted zone for ${zone_name}..."
aws route53 list-hosted-zones-by-name \
  --dns-name "${zone_name}" \
  --max-items 1 \
  --profile "$profile"

echo
echo "Resolving public DNS..."
if command -v dig >/dev/null 2>&1; then
  dig +short "${zone_name}"
  dig +short "www.${zone_name}"
else
  echo "dig not installed; skipping resolver check."
fi
