#!/usr/bin/env bash

set -euo pipefail

default_profile="${AWS_PROFILE:-virgiperpetua-dns}"
default_session="${AWS_SSO_SESSION_NAME:-virgiperpetua}"
default_start_url="${AWS_SSO_START_URL:-https://virgiperpetua.signin.aws.amazon.com/console}"
default_sso_region="${AWS_SSO_REGION:-us-east-1}"
default_account_id="${AWS_SSO_ACCOUNT_ID:-034034521269}"
default_region="${AWS_REGION:-us-east-1}"
default_role_name="${AWS_SSO_ROLE_NAME:-}"

read -r -p "AWS profile name [${default_profile}]: " profile_input
profile="${profile_input:-$default_profile}"

echo
echo "Preloading AWS IAM Identity Center defaults for profile '$profile'."
echo "SSO session: ${default_session}"
echo "SSO start URL: ${default_start_url}"
echo "SSO region: ${default_sso_region}"
echo "SSO account ID: ${default_account_id}"

python3 - <<PY
from configparser import RawConfigParser
from pathlib import Path

config_path = Path.home() / ".aws" / "config"
config_path.parent.mkdir(parents=True, exist_ok=True)

config = RawConfigParser()
config.optionxform = str
config.read(config_path)

session_section = "sso-session ${default_session}"
profile_section = "profile ${profile}"

if not config.has_section(session_section):
    config.add_section(session_section)

config.set(session_section, "sso_start_url", "${default_start_url}")
config.set(session_section, "sso_region", "${default_sso_region}")
config.set(session_section, "sso_registration_scopes", "sso:account:access")

if not config.has_section(profile_section):
    config.add_section(profile_section)

config.set(profile_section, "sso_session", "${default_session}")
config.set(profile_section, "sso_account_id", "${default_account_id}")
config.set(profile_section, "region", "${default_region}")
config.set(profile_section, "output", "json")

role_name = "${default_role_name}"
if role_name:
    config.set(profile_section, "sso_role_name", role_name)

with config_path.open("w") as fh:
    config.write(fh)
PY

echo
if [[ -n "$default_role_name" ]]; then
  echo "Using preset role name: ${default_role_name}"
else
  echo "The sign-in URL and account are now prefilled."
  echo "If the role is not already configured, AWS will ask only for the remaining role details."
  aws configure sso --profile "$profile"
fi

aws sso login --profile "$profile"

echo
echo "Verifying credentials for profile '$profile'..."
aws sts get-caller-identity --profile "$profile"

echo
echo "Profile '$profile' is ready."
