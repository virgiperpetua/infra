# Domain architecture

## Source of truth

- DNS provider: AWS Route 53
- Primary domain: `virgiperpetua.com`
- GitHub account: `virgiperpetua`
- DNS account: `034034521269`
- DNS access model: cross-account assume-role access from your own AWS login
- Hosted zone ID: `Z043433426DTXAX70X8VD`

## Routing rules

### Apex domain

- `virgiperpetua.com` is reserved for the marketing site repo: `virgiperpetua/marketing`
- `www.virgiperpetua.com` should either point to the same site or redirect to the apex

### Project domains

- Every additional project should use its own subdomain, such as `project-name.virgiperpetua.com`
- Prefer descriptive, stable subdomains that match the repo or product name

## GitHub Pages notes

For GitHub Pages sites:

- Configure the custom domain in the repository settings
- Ensure the published artifact contains a `CNAME` file when needed
- Point Route 53 records at the Pages target recommended by GitHub

## Non-Pages targets

For projects hosted outside GitHub Pages:

- Keep the DNS record in Route 53
- Point the record at the platform-specific hostname, load balancer, or static IP
- Record the platform and target in the inventory file

## Current known domains

- `virgiperpetua.com` -> `virgiperpetua/marketing`
- Route 53 hosted zone ID for `virgiperpetua.com`: `Z043433426DTXAX70X8VD`
- `poc-gelato-marketing` currently operates as a project site and should remain separate from the apex branding site unless intentionally consolidated later
