---
name: vault
description: >
  Work with Obsidian vaults — search, read, create, and organize notes using QMD and native
  file tools. Use when the user mentions "vault", "notes", "Obsidian", "docs", "documentation",
  "reference", or wants to find, search, look up, save, remember, get context on, or update
  information in their knowledge base. Also use when asked "what do we have on", "check if
  there's a doc", or "get context" for a topic.
version: 0.2.0
---

# Vault

Work with Obsidian vaults using QMD for search and native file tools for read/write.

## Discovery

Available vault indexes and their collections are listed in the SessionStart output at the top of every session. Check project CLAUDE.md/AGENTS.md for project-specific collection details.

## Search

Use **QMD MCP tools** when available (the project's `.mcp.json` configures the right index automatically). Fall back to CLI when MCP is not configured.

### MCP tools (preferred — no index needed)

- `mcp__qmd__query` — hybrid search (best quality, recommended)
- `mcp__qmd__get` — retrieve a document by path or ID
- `mcp__qmd__multi_get` — retrieve multiple documents by glob
- `mcp__qmd__status` — check index status and collections

### CLI fallback

When MCP is not available, use the CLI with `--index <name>` (index names are in the SessionStart output):

```bash
qmd --index <name> query "quarterly planning"   # hybrid (recommended)
qmd --index <name> search "API key"             # BM25 keyword (fast, no LLM)
qmd --index <name> vsearch "how to deploy"      # semantic similarity
```

### Common options

| Flag | Purpose |
|------|---------|
| `-c <collection>` | Restrict to a collection |
| `-n <num>` | Number of results (default 5) |
| `--min-score <num>` | Minimum relevance score |
| `--all --min-score 0.3` | All matches above threshold |
| `--json` | Structured JSON output |
| `--files` | File paths only |
| `--intent "..."` | Disambiguate the query |

### Lex syntax (keyword search)

- `"quoted phrase"` — exact phrase match
- `-term` — exclude term

## Read & Write

After finding notes via search, use **native file tools** at their file paths:

```
Read:  /path/to/vault/ref/topic/note.md
Edit:  /path/to/vault/ref/topic/note.md
Write: /path/to/vault/Stream/2026-03-11.1430.md
```

## Retrieve

Via MCP: `mcp__qmd__get` (by path or `#docid`) and `mcp__qmd__multi_get` (by glob).

Via CLI fallback:

```bash
qmd --index <name> get "path/to/file.md"         # by path
qmd --index <name> get "#docid"                   # by ID from search results
qmd --index <name> multi-get "journals/2025-05*"  # by glob
```

## Vault Structure

All vaults follow this universal structure:

```
vault/
├── desk/<project>/   # Active projects: plans, active work, things in progress
├── ref/<topic>/      # Evergreen knowledge: topics, people, places, how things work
└── Stream/           # Temporal: daily notes, meeting notes, logs
```

- **desk/** — One folder per active project (kebab-case). Use for anything in progress with a defined goal.
- **ref/** — One folder per topic. Stable, evergreen knowledge. Updated as things change, not timeline-driven.
- **Stream/** — Timestamped entries. Naming: `YYYY-MM-DD.HHmm.md` (e.g., `2026-03-11.1430.md`).

**Where to put something:** *desk* if active project with a goal, *ref* if stable knowledge updated over time, *Stream* if timestamped log entry.

## Creating Notes

Always include frontmatter:

```yaml
---
date: 2026-03-11
time: "14:30"
tags:
  - desk    # or ref, stream
  - topic-tag
rel:
  - "[[Related Concept]]"
  - "[[Project Name]]"
---

# Note Title

Content here.
```

- `rel` links back to evergreen concepts in `ref/` or active projects in `desk/`

## Obsidian Markdown

### Links & Embeds

```markdown
[[Note Name]]                   Link to a note
[[Note Name|Display Text]]      Link with custom text
[[Note Name#Heading]]           Link to a heading
![[Note Name]]                  Embed a note
![[image.png]]                  Embed an image
```

### Callouts

```markdown
> [!note]
> Standard callout.

> [!warning] Title
> With a custom title.

> [!tip]- Collapsed
> Foldable content.
```

Types: `note`, `tip`, `warning`, `info`, `todo`, `success`, `question`, `failure`, `danger`, `bug`, `example`, `quote`.

### Formatting

| Style | Syntax |
|-------|--------|
| Bold | `**text**` |
| Italic | `*text*` |
| Highlight | `==text==` |
| Strikethrough | `~~text~~` |
| Tag | `#tag` or `#nested/tag` |
| Comment (hidden) | `%%hidden in reading view%%` |

## Guidelines

- **Append to existing notes** when adding to an ongoing topic — don't create duplicates.
- **Use wikilinks** `[[Note Name]]` to connect related notes.
- **Use descriptive filenames** — they become the note title in Obsidian.
- **Search before creating** — check if a note already exists.
