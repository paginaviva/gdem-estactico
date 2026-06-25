---
source: GitHub raw (secondsky/claude-skills)
library: Hugo Static Site Generator (secondsky)
package: secondsky-claude-skills
topic: hugo-setup-guide
fetched: 2026-06-23T00:00:00Z
official_docs: https://github.com/secondsky/claude-skills
branch: main
path: plugins/hugo/skills/hugo/references/setup-guide.md
---
# Hugo Complete Setup Guide

Complete 7-step setup process for Hugo projects with all configuration options.

## Step 1: Installation and Verification

**Install Hugo Extended** using one of these methods:

**Method 1: Homebrew (macOS/Linux)** ✅ Recommended
```bash
brew install hugo
```

**Method 2: Binary Download (Linux)**
```bash
VERSION="0.152.2"
wget https://github.com/gohugoio/hugo/releases/download/v${VERSION}/hugo_extended_${VERSION}_linux-amd64.deb
sudo dpkg -i hugo_extended_${VERSION}_linux-amd64.deb
```

**Method 3: Docker**
```bash
docker run --rm -it -v $(pwd):/src klakegg/hugo:ext-alpine
```

**Verification:**
```bash
hugo version  # Should output: hugo v0.152.2+extended
```

## Step 2: Project Scaffolding

```bash
hugo new site my-site --format yaml
cd my-site
```

## Step 3: Theme Installation

```bash
git submodule add --depth=1 https://github.com/adityatelange/hugo-PaperMod.git themes/PaperMod
```

## Step 4: Configuration

```yaml
baseURL: "https://example.com/"
title: "My Hugo Blog"
theme: "PaperMod"
languageCode: "en-us"
defaultContentLanguage: "en"
enableRobotsTXT: true
buildDrafts: false
buildFuture: false
buildExpired: false
enableEmoji: true

minify:
  disableXML: true
  minifyOutput: true

params:
  env: production
  title: "My Hugo Blog"
  description: "A blog built with Hugo and PaperMod"
  author: "Your Name"
  ShowReadingTime: true
  ShowShareButtons: true
  ShowPostNavLinks: true
  ShowBreadCrumbs: true
  ShowCodeCopyButtons: true
  defaultTheme: auto

  socialIcons:
    - name: twitter
      url: "https://twitter.com/username"
    - name: github
      url: "https://github.com/username"

menu:
  main:
    - identifier: posts
      name: Posts
      url: /posts/
      weight: 10
    - identifier: about
      name: About
      url: /about/
      weight: 20

outputs:
  home:
    - HTML
    - RSS
    - JSON
```

## Step 5: Content Creation

```bash
hugo new content posts/my-first-post.md
```

**YAML Frontmatter:**
```yaml
---
title: "My First Post"
date: 2025-11-04T10:00:00+11:00
draft: false
tags: ["hugo", "blog"]
categories: ["General"]
description: "A brief description for SEO"
cover:
  image: "/images/cover.jpg"
  alt: "Cover image"
---
```

## Step 6: Build and Development

```bash
# Development
hugo server
hugo server --buildDrafts
hugo server --buildFuture

# Production
hugo --minify
hugo --minify -b $CF_PAGES_URL
```

## Step 7: Cloudflare Workers Deployment

**wrangler.jsonc:**
```jsonc
{
  "name": "my-hugo-site",
  "compatibility_date": "2025-01-29",
  "assets": {
    "directory": "./public",
    "html_handling": "auto-trailing-slash",
    "not_found_handling": "404-page"
  }
}
```

**GitHub Actions:**
```yaml
name: Deploy to Cloudflare Workers
on:
  push:
    branches: [main]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4
        with:
          submodules: recursive
      - name: Setup Hugo
        uses: peaceiris/actions-hugo@v2
        with:
          hugo-version: '0.152.2'
          extended: true
      - name: Build
        run: hugo --minify
      - name: Deploy to Cloudflare Workers
        uses: cloudflare/wrangler-action@v3
        with:
          apiToken: ${{ secrets.CLOUDFLARE_API_TOKEN }}
```

## Official Documentation
- **Hugo**: https://gohugo.io/documentation/
- **PaperMod Theme**: https://github.com/adityatelange/hugo-PaperMod/wiki
- **Cloudflare Workers**: https://developers.cloudflare.com/workers/
