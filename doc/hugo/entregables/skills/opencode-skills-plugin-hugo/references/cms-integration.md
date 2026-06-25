---
source: GitHub raw (secondsky/claude-skills)
library: Hugo Static Site Generator (secondsky)
package: secondsky-claude-skills
topic: hugo-cms-integration
fetched: 2026-06-23T00:00:00Z
official_docs: https://github.com/secondsky/claude-skills
branch: main
path: plugins/hugo/skills/hugo/references/cms-integration.md
---
# Hugo CMS Integration Guide

## Sveltia CMS Integration (Recommended)

### Setup (5 Minutes)

1. Create `static/admin/index.html` with CDN script
2. Create `static/admin/config.yml` with collections config
3. Rebuild: `hugo` → Admin at `http://localhost:1313/admin`

### Production OAuth Setup

Uses Cloudflare Workers for OAuth proxy:
- Create OAuth proxy with Hono framework
- Configure GitHub OAuth App
- Set secrets: GITHUB_CLIENT_ID, GITHUB_CLIENT_SECRET
- Deploy with Wrangler

### Key Points
- Admin accessible at `/admin` after build
- `local_backend: true` for local testing
- YAML frontmatter required
- Collections map to Hugo content directories

## TinaCMS Integration (Not Recommended)

⚠️ **Use Sveltia CMS instead.** TinaCMS has significant limitations for Hugo:
❌ React-only visual editing
❌ Complex setup (requires Node.js server or Tina Cloud)
❌ 692 npm packages vs Sveltia's 1 CDN script
❌ 7 security vulnerabilities
❌ $29/month for production

## Comparison: Sveltia vs TinaCMS

| Feature | Sveltia CMS | TinaCMS |
|---------|-------------|---------|
| Setup Time | 5 minutes | 1-2 hours |
| Dependencies | 1 CDN script | 692 npm packages |
| Security Issues | 0 | 7 (4 high, 3 critical) |
| Cost | Free | $29/month |

Official docs:
- Sveltia CMS: https://github.com/sveltia/sveltia-cms
- TinaCMS: https://tina.io/docs/
