# AWS setup

This repository assumes DNS is managed in AWS Route 53 and that this machine uses a named AWS CLI profile for domain work.

## Recommended profile

- Profile name: `virgiperpetua-dns`
- Scope: Route 53 access in the DNS account, plus `sts:GetCallerIdentity`
- Credential style: AWS IAM Identity Center / SSO plus cross-account role selection
- DNS account: `034034521269`

## One-time setup on a new computer

Run:

```bash
./scripts/bootstrap-aws-profile.sh
```

The script will:

1. Prompt for a profile name.
2. Launch `aws configure sso` for that profile.
3. Let you enter the IAM Identity Center sign-in URL and choose the target DNS account and role.
4. Run `aws sso login` for the new profile.
5. Verify credentials with `aws sts get-caller-identity`.

## Manual setup

If you prefer the raw AWS CLI flow, configure the profile interactively:

```bash
aws configure sso --profile virgiperpetua-dns
aws sso login --profile virgiperpetua-dns
aws sts get-caller-identity --profile virgiperpetua-dns
```

## Notes

- Your current AWS access pattern is cross-account: the domain is registered in another AWS account, and you reach it through an allowed role in account `034034521269`.
- Route 53 is a global service, but the CLI still expects a default region value. `us-east-1` is a safe default for this setup unless you prefer another region.
- Do not commit files from `~/.aws/`.
- Keep the profile name `virgiperpetua-dns` even if the underlying login flow changes later, so the rest of this repo still works.
