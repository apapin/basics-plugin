# basics-plugin

A Claude Code plugin marketplace for personal productivity tools.

## Install

Add the marketplace:

```sh
claude plugin marketplace add apapin/basics-plugin
```

Then install the plugins you want:

```sh
claude plugin install obsidian@basics
```

Restart Claude Code to activate.

## Plugins

### obsidian

Tools for working with [Obsidian](https://obsidian.md) vaults — Markdown notes, Bases, JSON Canvas, the CLI, and web content extraction.

| Skill | Description |
|-------|-------------|
| **obsidian-markdown** | Create and edit Obsidian Flavored Markdown with wikilinks, embeds, callouts, properties, and other Obsidian-specific syntax |
| **obsidian-bases** | Create and edit Obsidian Bases (.base files) with views, filters, formulas, and summaries |
| **json-canvas** | Create and edit JSON Canvas files (.canvas) with nodes, edges, groups, and connections |
| **obsidian-cli** | Interact with Obsidian vaults via CLI — read, create, search, manage notes, and develop plugins |
| **defuddle** | Extract clean markdown from web pages, stripping navigation, ads, and clutter |

**Prerequisites:**
- **obsidian-cli** requires Obsidian to be running on your machine
- **defuddle** requires `npm install -g @kepano/defuddle-cli`

## Credits

Obsidian skills adapted from [kepano/obsidian-skills](https://github.com/kepano/obsidian-skills).
