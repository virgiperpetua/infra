# virgiperpetua/infra

Reusable infrastructure and workstation bootstrap for managing `virgiperpetua.com`.

This repo is the safe-to-commit source of truth for:

- AWS CLI setup instructions
- Route 53 inspection and validation helpers
- Domain routing conventions
- GitHub project to domain mappings

It does **not** store live credentials, exported AWS config, or secret values.

## Layout

- `docs/aws-setup.md` - first-run AWS CLI setup on a new computer
- `docs/domain-architecture.md` - domain routing rules and conventions
- `inventory/projects.example.json` - example project/domain inventory
- `scripts/bootstrap-aws-profile.sh` - interactive AWS profile bootstrap helper
- `scripts/check-domain-state.sh` - read-only checks for AWS, Route 53, and DNS

## Current model

- Apex site: `virgiperpetua.com` -> `virgiperpetua/marketing`
- Project sites: `*.virgiperpetua.com` -> one subdomain per project
- DNS authority: AWS Route 53

## First run on a new computer

1. Install `git`, `gh`, and AWS CLI v2.
2. Clone this repo.
3. Run `./scripts/bootstrap-aws-profile.sh`.
4. Export the desired profile, or pass it explicitly:

```bash
export AWS_PROFILE=virgiperpetua-dns
./scripts/check-domain-state.sh
```

## Creating a new project domain

1. Add the project to the inventory file.
2. Decide whether it is the apex site, a GitHub Pages site, or another hosting target.
3. Create the matching Route 53 record.
4. Configure the custom domain in the hosting platform.
5. Re-run `./scripts/check-domain-state.sh` to verify the hosted zone is reachable.
