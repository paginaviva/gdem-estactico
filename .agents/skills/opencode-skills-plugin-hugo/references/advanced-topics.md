---
source: GitHub raw (secondsky/claude-skills)
library: Hugo Static Site Generator (secondsky)
package: secondsky-claude-skills
topic: hugo-advanced-topics
fetched: 2026-06-23T00:00:00Z
official_docs: https://github.com/secondsky/claude-skills
branch: main
path: plugins/hugo/skills/hugo/references/advanced-topics.md
---
# Hugo Advanced Topics

## Custom Shortcodes

YouTube embed, alert boxes, code tabs - reusable content components in Markdown.

## Image Processing

Built-in resizing, responsive images, filters, WebP conversion, thumbnails with cropping.

## Custom Taxonomies

Beyond tags/categories: series, authors, difficulties.

```yaml
taxonomies:
  series: series
  author: authors
```

## Data Files

YAML/JSON/CSV data files for structured content, remote data via `getJSON`.

## Page Bundles

Leaf bundles (single page + resources) and branch bundles (section pages).

## Template Overrides

Override theme templates without modifying the theme.

## Hugo Modules

Advanced dependency management alternative to Git submodules:
```bash
hugo mod init github.com/username/my-site
hugo mod get
hugo mod tidy
hugo mod clean
```

## Custom Output Formats

JSON, RSS, and custom formats beyond HTML.

## Multilingual Menus

Per-language menu configurations.

Official docs:
- Hugo Templates: https://gohugo.io/templates/
- Image Processing: https://gohugo.io/content-management/image-processing/
- Hugo Modules: https://gohugo.io/hugo-modules/
