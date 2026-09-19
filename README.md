# virgiperpetua/infra

Reusable infrastructure and workstation bootstrap for managing `virgiperpetua.com`.

This repo is the safe-to-commit source of truth for:

- AWS CLI login and cross-account role setup instructions
- Route 53 inspection and validation helpers
- Domain routing conventions
- GitHub project to domain mappings

It does **not** store live credentials, exported AWS config, or secret values.

## Layout

- `docs/aws-setup.md` - **bookmark this**: console Switch role values + CLI login for domains
- `docs/domain-architecture.md` - domain routing rules and conventions
- `inventory/projects.example.json` - example project/domain inventory
- `scripts/bootstrap-aws-profile.sh` - interactive AWS profile bootstrap helper
- `scripts/check-domain-state.sh` - read-only checks for AWS, Route 53, and DNS

## Current model

- Apex site: `virgiperpetua.com` -> `virgiperpetua/marketing`
- Project sites: `*.virgiperpetua.com` -> one subdomain per project
- DNS authority: AWS Route 53
- DNS account access: cross-account role in AWS account `034034521269`

## Access cheatsheet

Full details live in [`docs/aws-setup.md`](docs/aws-setup.md). Short version:

| Use case | How |
| --- | --- |
| AWS console | Switch role → account `034034521269`, role `virgiperpetua-com-dns-access` |
| AWS CLI / domains | Profile `virgiperpetua-dns` (bootstrap once, then `aws login --profile default`) |

Switch-role link:

```text
https://signin.aws.amazon.com/switchrole?account=034034521269&roleName=virgiperpetua-com-dns-access&displayName=virgiperpetua-dns
```

## First run on a new computer

1. Install `git`, `gh`, and AWS CLI v2.32.0 or newer.
2. Clone this repo.
3. Run `./scripts/bootstrap-aws-profile.sh`.
4. Export the desired profile, or pass it explicitly:

```bash
export AWS_PROFILE=virgiperpetua-dns
./scripts/check-domain-state.sh
```

## Creating a new project domain

1. Ensure CLI access: `export AWS_PROFILE=virgiperpetua-dns` (refresh with `aws login --profile default` if needed).
2. Add the project to the inventory file.
3. Decide whether it is the apex site, a GitHub Pages site, or another hosting target.
4. Create the matching Route 53 record.
5. Configure the custom domain in the hosting platform.
6. Re-run `./scripts/check-domain-state.sh` to verify the hosted zone is reachable.
