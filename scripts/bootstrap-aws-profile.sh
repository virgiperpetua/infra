#!/usr/bin/env bash

set -euo pipefail

default_profile="${AWS_PROFILE:-virgiperpetua-dns}"
default_region="${AWS_REGION:-ap-southeast-2}"

read -r -p "AWS profile name [${default_profile}]: " profile_input
profile="${profile_input:-$default_profile}"

read -r -p "AWS access key ID: " access_key_id
read -r -s -p "AWS secret access key: " secret_access_key
printf '\n'
read -r -p "Default region [${default_region}]: " region_input
region="${region_input:-$default_region}"

aws configure set aws_access_key_id "$access_key_id" --profile "$profile"
aws configure set aws_secret_access_key "$secret_access_key" --profile "$profile"
aws configure set region "$region" --profile "$profile"
aws configure set output json --profile "$profile"

echo
echo "Verifying credentials for profile '$profile'..."
aws sts get-caller-identity --profile "$profile"

echo
echo "Profile '$profile' is ready."
