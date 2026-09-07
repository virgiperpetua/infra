#!/usr/bin/env bash

set -euo pipefail

default_profile="${AWS_PROFILE:-virgiperpetua-dns}"
read -r -p "AWS profile name [${default_profile}]: " profile_input
profile="${profile_input:-$default_profile}"

echo
echo "This flow will launch AWS IAM Identity Center setup for profile '$profile'."
echo "Use the sign-in URL provided by your AWS access administrator."
echo "When prompted, choose the DNS account and role that can manage Route 53 for virgiperpetua.com."
echo

aws configure sso --profile "$profile"
aws sso login --profile "$profile"

echo
echo "Verifying credentials for profile '$profile'..."
aws sts get-caller-identity --profile "$profile"

echo
echo "Profile '$profile' is ready."
