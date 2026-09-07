# AWS setup

This repository assumes DNS is managed in AWS Route 53 and that this machine uses a named AWS CLI profile for domain work.

## Recommended profile

- Profile name: `virgiperpetua-dns`
- Scope: Route 53 access, plus `sts:GetCallerIdentity`
- Credential style: access key and secret key

## One-time setup on a new computer

Run:

```bash
./scripts/bootstrap-aws-profile.sh
```

The script will:

1. Prompt for a profile name.
2. Prompt for AWS access key ID, secret access key, and default region.
3. Write the AWS CLI config to the current user's AWS config location.
4. Verify credentials with `aws sts get-caller-identity`.

## Manual setup

If you prefer the raw AWS CLI flow:

```bash
aws configure --profile virgiperpetua-dns
aws sts get-caller-identity --profile virgiperpetua-dns
```

## Notes

- Route 53 is a global service, but the CLI still expects a default region value. `ap-southeast-2` is a reasonable default if you do not have another preference.
- Do not commit files from `~/.aws/`.
- If you later move away from long-lived keys, keep the same profile name so the rest of this repo still works.
