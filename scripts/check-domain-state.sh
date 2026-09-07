#!/usr/bin/env bash

set -euo pipefail

profile="${AWS_PROFILE:-virgiperpetua-dns}"
zone_name="${1:-virgiperpetua.com}"
hosted_zone_id="${HOSTED_ZONE_ID:-Z043433426DTXAX70X8VD}"
normalized_zone_name="${zone_name%.}."

echo "Using AWS profile: ${profile}"
echo "Checking AWS caller identity..."
aws sts get-caller-identity --profile "$profile"

echo
echo "Looking up hosted zone ${hosted_zone_id} for ${zone_name}..."
hosted_zone_json="$(
  aws route53 get-hosted-zone \
  --id "${hosted_zone_id}" \
  --profile "$profile"
)"
printf '%s\n' "$hosted_zone_json"

actual_zone_name="$(
  printf '%s' "$hosted_zone_json" | python3 -c 'import json,sys; print(json.load(sys.stdin)["HostedZone"]["Name"])'
)"

if [[ "$actual_zone_name" != "$normalized_zone_name" ]]; then
  echo "Hosted zone ${hosted_zone_id} is for ${actual_zone_name}, not ${normalized_zone_name}." >&2
  exit 1
fi

echo
echo "Listing record set summary for ${zone_name}..."
aws route53 list-resource-record-sets \
  --hosted-zone-id "${hosted_zone_id}" \
  --max-items 10 \
  --profile "$profile"

echo
echo "Resolving public DNS..."
if ! command -v dig >/dev/null 2>&1; then
  echo "dig not installed; cannot validate public DNS." >&2
  exit 1
fi

apex_answers="$(dig +short "${zone_name}")"
www_answers="$(dig +short "www.${zone_name}")"

printf '%s\n' "$apex_answers"
printf '\n'
printf '%s\n' "$www_answers"

if [[ -z "$apex_answers" || -z "$www_answers" ]]; then
  echo "Resolver check failed: expected non-empty answers for ${zone_name} and www.${zone_name}." >&2
  exit 1
fi
