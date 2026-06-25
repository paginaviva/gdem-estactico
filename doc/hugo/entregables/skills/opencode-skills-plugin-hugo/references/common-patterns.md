---
source: GitHub raw (secondsky/claude-skills)
library: Hugo Static Site Generator (secondsky)
package: secondsky-claude-skills
topic: hugo-common-patterns
fetched: 2026-06-23T00:00:00Z
official_docs: https://github.com/secondsky/claude-skills
branch: main
path: plugins/hugo/skills/hugo/references/common-patterns.md
---
# Hugo Common Patterns

## Pattern 1: Blog with PaperMod Theme

```bash
hugo new site my-blog --format yaml
cd my-blog && git init
git submodule add --depth=1 https://github.com/adityatelange/hugo-PaperMod.git themes/PaperMod
```

## Pattern 2: Documentation Site with Hugo Book

```bash
hugo new site docs --format yaml
cd docs && git init
git submodule add https://github.com/alex-shpak/hugo-book.git themes/hugo-book
```

## Pattern 3: Landing Page

Custom layouts with no theme dependency. Hero, features, testimonials, CTA sections.

## Pattern 4: Multilingual Site

```yaml
languages:
  en:
    languageName: "English"
    weight: 1
  es:
    languageName: "Español"
    weight: 2
```

Content: `content/posts/post-1.en.md`, `content/posts/post-1.es.md`

## Pattern 5: Portfolio Site

Custom content type with technology tags, GitHub/demo links.

## Pattern 6: E-commerce (Static)

Snipcart or Stripe integration for static e-commerce.

## Pattern 7: Newsletter/Blog

ConvertKit/Mailchimp integration with RSS feeds.

Official documentation: https://gohugo.io/documentation/
