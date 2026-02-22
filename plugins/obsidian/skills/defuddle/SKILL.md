---
name: defuddle
description: >
  Extract clean readable content from web pages using the Defuddle CLI tool. Strips navigation,
  ads, and clutter to produce clean markdown. Use when the user wants to "extract content from
  a web page", "convert a URL to markdown", "save a web article", or "clean up web page content".
version: 0.1.0
---

# Defuddle

Extract clean, readable content from web pages by removing navigation, ads, and unnecessary clutter. Produces clean markdown output optimized for reduced token usage.

## Installation

```bash
npm install -g @kepano/defuddle-cli
```

## Basic Usage

```bash
defuddle parse <url> --md
```

The `--md` flag outputs markdown format (recommended for most use cases).

## Output Options

| Flag | Format | Description |
|------|--------|-------------|
| `--md` | Markdown | Clean, readable markdown (recommended) |
| `--json` | JSON | Structured data with HTML and markdown |
| (none) | HTML | Raw HTML output |

## Save to File

```bash
defuddle parse <url> --md -o output.md
```

## Extract Metadata

```bash
defuddle parse <url> -p title
defuddle parse <url> -p description
defuddle parse <url> -p domain
```

## When to Use

Prefer Defuddle over other web-fetching tools for standard web content (articles, documentation, blog posts) because it strips unnecessary elements, producing cleaner output and reducing token consumption.

## Common Patterns

Extract an article to markdown:

```bash
defuddle parse "https://example.com/article" --md -o article.md
```

Get just the title:

```bash
defuddle parse "https://example.com/article" -p title
```

Get structured JSON with both HTML and markdown:

```bash
defuddle parse "https://example.com/article" --json
```
