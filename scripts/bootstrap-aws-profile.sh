#!/usr/bin/env bash

set -euo pipefail

default_profile="${AWS_PROFILE:-virgiperpetua-dns}"
default_source_profile="${AWS_SOURCE_PROFILE:-default}"
default_account_id="${AWS_DNS_ACCOUNT_ID:-034034521269}"
default_role_name="${AWS_DNS_ROLE_NAME:-virgiperpetua-com-dns-access}"
default_session_name="${AWS_ROLE_SESSION_NAME:-virgiperpetua}"
default_region="${AWS_REGION:-us-east-1}"

read -r -p "AWS profile name [${default_profile}]: " profile_input
profile="${profile_input:-$default_profile}"

echo
echo "Configuring cross-account Route 53 access for profile '$profile'."
echo "Source profile: ${default_source_profile}"
echo "DNS account ID: ${default_account_id}"
echo "DNS role name: ${default_role_name}"
echo "Role session name: ${default_session_name}"

python3 - <<PY
from configparser import RawConfigParser
from pathlib import Path

config_path = Path.home() / ".aws" / "config"
config_path.parent.mkdir(parents=True, exist_ok=True)

config = RawConfigParser()
config.optionxform = str
config.read(config_path)

profile_section = "profile ${profile}"

if not config.has_section(profile_section):
    config.add_section(profile_section)

config.set(profile_section, "role_arn", "arn:aws:iam::${default_account_id}:role/${default_role_name}")
config.set(profile_section, "source_profile", "${default_source_profile}")
config.set(profile_section, "role_session_name", "${default_session_name}")
config.set(profile_section, "region", "${default_region}")
config.set(profile_section, "output", "json")

with config_path.open("w") as fh:
    config.write(fh)
PY

echo
echo "Refreshing the source AWS login if needed..."
aws login

echo
echo "Verifying credentials for profile '$profile'..."
aws sts get-caller-identity --profile "$profile"

echo
echo "Profile '$profile' is ready."
