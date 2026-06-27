---
source: GitHub raw (secondsky/claude-skills)
library: Hugo Static Site Generator (secondsky)
package: secondsky-claude-skills
topic: hugo-tailwind-integration
fetched: 2026-06-23T00:00:00Z
official_docs: https://github.com/secondsky/claude-skills
branch: main
path: plugins/hugo/skills/hugo/references/tailwind-integration.md
---
# Hugo + Tailwind CSS v4 Integration Guide

**CRITICAL:** Do NOT use `tailwind-v4-shadcn` skill patterns with Hugo. That skill is for Vite + React.

## Quick Start (10 Minutes)

1. Install: `npm install -D tailwindcss postcss autoprefixer`
2. Configure Hugo: `build.writeStats: true` in hugo.yaml
3. Configure Tailwind: `content: ['./hugo_stats.json', './layouts/**/*.html', './content/**/*.{html,md}']`
4. Configure PostCSS: `postcss.config.js` with tailwindcss and autoprefixer
5. Create CSS: `assets/css/main.css` with `@import "tailwindcss"`
6. Process in template: `{{ $style := resources.Get "css/main.css" | resources.PostCSS }}`
7. Start: `hugo server`

## Dark Mode

CSS-only: `darkMode: 'class'` in Tailwind config, toggle `dark` class on `<html>`
Alpine.js: More features with reactive state management

## Production Optimization

```yaml
minify:
  minifyOutput: true
```
Build: `hugo --minify`

## Common Issues
1. **CSS not processing** → Verify PostCSS config
2. **Classes not purging** → Enable `writeStats: true`
3. **Dark mode broken** → Use `darkMode: 'class'`
4. **Asset fingerprinting fails** → Use `RelPermalink` not `Permalink`
5. **Hugo template syntax in CSS** → Apply classes in templates, not CSS
6. **Version mismatch** → Update all: `npm install -D tailwindcss@latest postcss@latest autoprefixer@latest`

Official docs:
- Tailwind CSS: https://tailwindcss.com/docs
- Hugo Pipes: https://gohugo.io/hugo-pipes/
