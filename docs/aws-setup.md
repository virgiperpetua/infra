# AWS setup

This repository assumes DNS is managed in AWS Route 53 and that this machine uses a named AWS CLI profile for domain work.

## Quick reference

| Item | Value |
| --- | --- |
| DNS account ID | `034034521269` |
| DNS role name | `virgiperpetua-com-dns-access` |
| Role ARN | `arn:aws:iam::034034521269:role/virgiperpetua-com-dns-access` |
| CLI profile name | `virgiperpetua-dns` |
| Default region | `us-east-1` |
| Hosted zone | `virgiperpetua.com` (`Z043433426DTXAX70X8VD`) |

## Console: Switch role

Use this when you need the AWS web console for Route 53 / domain work.

1. Sign in to **your own** AWS account.
2. Open **Switch role**, or use this link:

```text
https://signin.aws.amazon.com/switchrole?account=034034521269&roleName=virgiperpetua-com-dns-access&displayName=virgiperpetua-dns
```

3. Fill in (if not using the link):

| Field | Value |
| --- | --- |
| Account | `034034521269` |
| Role | `virgiperpetua-com-dns-access` |
| Display name | `virgiperpetua-dns` (optional) |

4. After switching, open Route 53 and work in the `virgiperpetua.com` hosted zone.

## CLI: Login and profile for domains

Use this on a workstation when creating or checking domains with the AWS CLI.

### Recommended profile

- Profile name: `virgiperpetua-dns`
- Scope: Route 53 access in the DNS account, plus `sts:GetCallerIdentity`
- Credential style: console login for your own AWS account plus cross-account `AssumeRole`
- DNS account: `034034521269`
- DNS role name: `virgiperpetua-com-dns-access`

### One-time setup on a new computer

Requires AWS CLI `2.32.0` or newer so `aws login` is available.

Run:

```bash
./scripts/bootstrap-aws-profile.sh
```

The script will:

1. Prompt for a profile name.
2. Write a named AWS CLI profile that assumes the DNS role in account `034034521269`.
3. Refresh your base AWS console login with `aws login --profile default`.
4. Verify the assumed-role credentials with `aws sts get-caller-identity`.

### Manual setup

If you prefer the raw AWS CLI flow, the essential profile is:

```ini
[profile virgiperpetua-dns]
role_arn = arn:aws:iam::034034521269:role/virgiperpetua-com-dns-access
source_profile = default
role_session_name = virgiperpetua
region = us-east-1
output = json
```

Then refresh the base login and verify:

```bash
aws login --profile default
aws sts get-caller-identity --profile virgiperpetua-dns
```

### Everyday domain commands

After the profile exists, use it for domain work:

```bash
export AWS_PROFILE=virgiperpetua-dns

# Refresh base login if credentials expired
aws login --profile default

# Confirm you are in the DNS account via the access role
aws sts get-caller-identity

# Inspect domain / hosted-zone state
./scripts/check-domain-state.sh
```

When creating a new project subdomain, keep using `AWS_PROFILE=virgiperpetua-dns` for any `aws route53 ...` commands, then re-run `./scripts/check-domain-state.sh`. See `docs/domain-architecture.md` and the README section **Creating a new project domain**.

## Notes

- Your current AWS access pattern is cross-account: you sign in to your own AWS account, then switch into the DNS account role `virgiperpetua-com-dns-access` in account `034034521269`.
- Route 53 is a global service, but the CLI still expects a default region value. `us-east-1` is a safe default for this setup unless you prefer another region.
- Do not commit files from `~/.aws/`.
- Keep the profile name `virgiperpetua-dns` even if the underlying login flow changes later, so the rest of this repo still works.
