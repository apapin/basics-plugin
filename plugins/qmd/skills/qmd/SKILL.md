---
name: qmd
description: >
  Search and retrieve content from indexed markdown notes, meeting transcripts, documentation,
  and knowledge bases using QMD. Supports fast keyword search (BM25), semantic vector search,
  and hybrid search with LLM re-ranking — all running locally. Use when the user asks to
  "search my notes", "find documents about X", "look up meeting notes", "search my knowledge base",
  or "retrieve a document".
version: 0.1.0
---

# QMD — Query Markup Documents

On-device search engine for markdown notes, meeting transcripts, documentation, and knowledge bases. Combines BM25 full-text search, vector semantic search, and LLM re-ranking — all local.

## Installation

```bash
npm install -g @tobilu/qmd
```

## Setup

Create collections and generate embeddings before searching:

```bash
# Index directories
qmd collection add ~/notes --name notes
qmd collection add ~/Documents/meetings --name meetings

# Add context descriptions (improves search quality)
qmd context add qmd://notes "Personal notes and ideas"
qmd context add qmd://meetings "Meeting transcripts and notes"

# Generate vector embeddings
qmd embed
```

## Search Modes

| Command | Method | Speed | Quality | Use when |
|---------|--------|-------|---------|----------|
| `qmd search` | BM25 keyword | Fast | Good for exact terms | Looking for specific words or phrases |
| `qmd vsearch` | Vector semantic | Medium | Good for concepts | Query doesn't match exact wording |
| `qmd query` | Hybrid + reranking | Slower | Best | Need highest quality results |

## Common Patterns

### Searching

```bash
# Keyword search
qmd search "project timeline"

# Semantic search
qmd vsearch "how to deploy the app"

# Hybrid search (best quality)
qmd query "quarterly planning process"

# Search within a specific collection
qmd search "API" -c notes

# More results with a minimum score
qmd search "authentication" -n 10 --min-score 0.3

# All matches above a threshold
qmd query "error handling" --all --min-score 0.4
```

### Retrieving Documents

```bash
# Get by file path
qmd get "meetings/2024-01-15.md"

# Get by docid (from search results)
qmd get "#abc123"

# Get starting at a specific line, limited length
qmd get notes/meeting.md:50 -l 100

# Get multiple documents by glob
qmd multi-get "journals/2025-05*.md"

# Get multiple by comma-separated list
qmd multi-get "doc1.md, doc2.md, #abc123"
```

### Output Formats

Use `--json` or `--files` for structured output in agentic workflows:

```bash
# Structured JSON for processing
qmd search "authentication" --json -n 10

# File list with scores
qmd query "error handling" --all --files --min-score 0.4

# Full document content
qmd get "docs/api-reference.md" --full

# Other formats
qmd search "API" --md     # Markdown
qmd search "API" --csv    # CSV
qmd search "API" --xml    # XML
```

### Collection Management

```bash
# Add a collection
qmd collection add ~/path --name myproject

# Custom glob pattern
qmd collection add ~/docs --name docs --mask "**/*.md"

# List collections
qmd collection list

# List files in a collection
qmd ls notes

# Remove a collection
qmd collection remove myproject
```

### Context Management

Context adds descriptions that are returned with search results, helping understand what matched and why:

```bash
# Add context to collections
qmd context add qmd://notes "Personal notes and ideas"
qmd context add qmd://docs/api "API documentation"

# Global context
qmd context add / "Knowledge base for my projects"

# List and remove
qmd context list
qmd context rm qmd://notes/old
```

### Maintenance

```bash
# Index status and collection info
qmd status

# Re-index all collections
qmd update

# Re-index with git pull first
qmd update --pull

# Re-embed all documents
qmd embed -f

# Clean up cache
qmd cleanup
```

## Score Interpretation

| Score | Meaning |
|-------|---------|
| 0.8–1.0 | Highly relevant |
| 0.5–0.8 | Moderately relevant |
| 0.2–0.5 | Somewhat relevant |
| 0.0–0.2 | Low relevance |

## Tips

- Use `qmd search` for fast lookups when you know the exact terms.
- Use `qmd query` when you need the best results and can wait a moment longer.
- Add context to collections with `qmd context add` — it significantly improves result quality for agents.
- Use `--min-score 0.3` to filter noise from results.
- Use `--json` output when feeding results to another tool or LLM.
- Run `qmd status` to check index health and collection info.
