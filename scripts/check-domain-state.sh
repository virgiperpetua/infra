#!/usr/bin/env bash

set -euo pipefail

profile="${AWS_PROFILE:-virgiperpetua-dns}"
zone_name="${1:-virgiperpetua.com}"
hosted_zone_id="${HOSTED_ZONE_ID:-Z043433426DTXAX70X8VD}"

echo "Using AWS profile: ${profile}"
echo "Checking AWS caller identity..."
aws sts get-caller-identity --profile "$profile"

echo
echo "Looking up hosted zone ${hosted_zone_id} for ${zone_name}..."
aws route53 get-hosted-zone \
  --id "${hosted_zone_id}" \
  --profile "$profile"

echo
echo "Listing record set summary for ${zone_name}..."
aws route53 list-resource-record-sets \
  --hosted-zone-id "${hosted_zone_id}" \
  --max-items 10 \
  --profile "$profile"

echo
echo "Resolving public DNS..."
if command -v dig >/dev/null 2>&1; then
  dig +short "${zone_name}"
  dig +short "www.${zone_name}"
else
  echo "dig not installed; skipping resolver check."
fi
