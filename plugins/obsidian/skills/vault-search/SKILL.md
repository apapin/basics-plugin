---
name: vault-search
description: >
  Search Obsidian vaults using QMD's hybrid search engine. Combines QMD's semantic and keyword
  search with Obsidian CLI's vault operations for a powerful find-then-act workflow. Use when
  the user asks to "search my vault", "find notes about X", "look through my Obsidian notes",
  or needs to locate and then read, edit, or organize vault content.
version: 0.1.0
---

# Vault Search

Use QMD as a semantic search layer over Obsidian vaults, then Obsidian CLI to act on results.

**Requires**: `qmd` (npm install -g @tobilu/qmd) and `obsidian` CLI (Obsidian must be running).

## Setup

Register each vault as a QMD collection:

```bash
# Add vault as a collection (only index markdown files)
qmd collection add ~/Obsidian/MyVault --name myvault --mask "**/*.md"

# Add context to improve search quality
qmd context add qmd://myvault "Personal knowledge base — notes, projects, journals"

# Add context to subfolders for more specific matches
qmd context add qmd://myvault/meetings "Meeting transcripts and action items"
qmd context add qmd://myvault/projects "Project documentation and planning"

# Generate vector embeddings (run once, then after major changes)
qmd embed
```

## When to Use Which Search

| Need | Tool | Command |
|------|------|---------|
| Conceptual or fuzzy search | QMD | `qmd query "how to handle errors"` |
| Semantic similarity | QMD | `qmd vsearch "deployment process"` |
| Fast keyword lookup | QMD | `qmd search "API key" -c myvault` |
| Exact string in active vault | Obsidian | `obsidian search query="specificFunction"` |

**Default to QMD** for search — it understands meaning, not just keywords. Fall back to `obsidian search` only for exact string matches or when Obsidian-specific metadata (tags, properties) matters.

## Find-Then-Act Workflow

### 1. Search with QMD

```bash
# Find relevant notes (hybrid search, best quality)
qmd query "quarterly planning" -c myvault -n 5

# Or get structured output for processing
qmd query "quarterly planning" -c myvault --json -n 10
```

### 2. Read with Obsidian CLI or QMD

```bash
# Read via Obsidian (by note name, no extension needed)
obsidian read file="Q4 Planning"

# Or read via QMD (by path from search results)
qmd get "projects/q4-planning.md" --full

# Or read by docid from search results
qmd get "#abc123" --full
```

### 3. Act with Obsidian CLI

```bash
# Append content to a found note
obsidian append file="Q4 Planning" content="- [ ] Review budget"

# Update properties
obsidian property:set name="status" value="reviewed" file="Q4 Planning"

# Create a new note based on findings
obsidian create name="Q4 Summary" content="# Q4 Summary\n\nBased on planning notes..."
```

## Keeping the Index Current

```bash
# Re-index after vault changes
qmd update

# Re-index and pull git changes (if vault is a git repo)
qmd update --pull

# Re-generate embeddings after significant new content
qmd embed
```

## Tips

- Add context generously with `qmd context add` — it's returned with search results and helps the agent understand what matched.
- Use `--min-score 0.3` to filter low-relevance noise from results.
- Use `qmd query` (hybrid) for best results when quality matters more than speed.
- Use `qmd search` (BM25 only) when you need fast results with known keywords.
- Run `qmd status` to check which vaults are indexed and their health.
