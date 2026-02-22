---
name: obsidian-bases
description: >
  Create and edit Obsidian Bases (.base files) with views, filters, formulas, and summaries.
  Use when working with .base files, creating database-like views of notes, or when the user
  mentions "Bases", "table views", "card views", "filters", or "formulas" in Obsidian.
version: 0.1.0
---

# Obsidian Bases

Create and edit valid Obsidian Bases (`.base` files) — YAML-based files that define dynamic views of notes in an Obsidian vault.

## File Format

Base files use `.base` extension and contain valid YAML.

## Complete Schema

```yaml
filters:            # Global filters for ALL views
  and: []
  or: []
  not: []

formulas:           # Computed properties
  formula_name: 'expression'

properties:         # Display configuration
  property_name:
    displayName: "Display Name"

summaries:          # Custom summary formulas
  custom_name: 'values.mean().round(3)'

views:              # One or more views
  - type: table | cards | list | map
    name: "View Name"
    limit: 10
    groupBy:
      property: property_name
      direction: ASC | DESC
    filters: {}
    order: []
    summaries: {}
```

## Filter Syntax

```yaml
# Single filter
filters: 'status == "done"'

# AND — all must be true
filters:
  and:
    - 'status == "done"'
    - 'priority > 3'

# OR — any can be true
filters:
  or:
    - file.hasTag("book")
    - file.hasTag("article")

# NOT — exclude matches
filters:
  not:
    - file.hasTag("archived")

# Nested
filters:
  or:
    - file.hasTag("tag")
    - and:
        - file.hasTag("book")
        - file.hasLink("Textbook")
```

### Filter Operators

`==`, `!=`, `>`, `<`, `>=`, `<=`, `&&`, `||`, `!`

## Properties

Three types:

1. **Note properties** — from frontmatter: `author`, `status`
2. **File properties** — metadata: `file.name`, `file.mtime`, `file.size`, `file.tags`, `file.links`, `file.folder`, `file.ext`, `file.ctime`, `file.backlinks`
3. **Formula properties** — computed: `formula.my_formula`

The `this` keyword refers to the base file itself (or the embedding file when embedded).

## Formula Syntax

```yaml
formulas:
  total: "price * quantity"
  status_icon: 'if(done, "done", "pending")'
  created: 'file.ctime.format("YYYY-MM-DD")'
  days_old: '(now() - file.ctime).days'
  days_until_due: 'if(due_date, (date(due_date) - today()).days, "")'
```

### Key Functions

**Global:** `date()`, `duration()`, `now()`, `today()`, `if()`, `min()`, `max()`, `number()`, `link()`, `list()`, `file()`, `image()`, `icon()`, `html()`, `escapeHTML()`

**Date fields:** `.year`, `.month`, `.day`, `.hour`, `.minute`, `.second`
**Date methods:** `.format(pattern)`, `.date()`, `.time()`, `.relative()`, `.isEmpty()`

**Duration:** Subtracting two dates returns a Duration. Access `.days`, `.hours`, `.minutes`, `.seconds` before applying number functions.

```yaml
# CORRECT
"(date(due_date) - today()).days"
"(now() - file.ctime).days.round(0)"

# WRONG — Duration doesn't support .round() directly
# "((date(due) - today()) / 86400000).round(0)"
```

**Date arithmetic:**

```yaml
"date + \"1M\""           # Add 1 month
"now() + \"1 day\""       # Tomorrow
"today() + \"7d\""        # A week from today
```

**String:** `.length`, `.contains()`, `.startsWith()`, `.endsWith()`, `.isEmpty()`, `.lower()`, `.title()`, `.trim()`, `.replace()`, `.split()`, `.slice()`

**Number:** `.abs()`, `.ceil()`, `.floor()`, `.round(digits?)`, `.toFixed(precision)`

**List:** `.length`, `.contains()`, `.filter(expr)`, `.map(expr)`, `.reduce(expr, init)`, `.flat()`, `.join(sep)`, `.sort()`, `.unique()`, `.isEmpty()`

**File:** `.asLink()`, `.hasLink()`, `.hasTag()`, `.hasProperty()`, `.inFolder()`

## View Types

### Table

```yaml
views:
  - type: table
    name: "My Table"
    order: [file.name, status, due_date]
    summaries:
      price: Sum
```

### Cards

```yaml
views:
  - type: cards
    name: "Gallery"
    order: [file.name, cover_image, description]
```

### List

```yaml
views:
  - type: list
    name: "Simple List"
    order: [file.name, status]
```

### Map

Requires latitude/longitude properties and the Maps community plugin.

## Default Summary Formulas

**Number:** `Average`, `Min`, `Max`, `Sum`, `Range`, `Median`, `Stddev`
**Date:** `Earliest`, `Latest`, `Range`
**Boolean:** `Checked`, `Unchecked`
**Any:** `Empty`, `Filled`, `Unique`

## Complete Example: Task Tracker

```yaml
filters:
  and:
    - file.hasTag("task")
    - 'file.ext == "md"'

formulas:
  days_until_due: 'if(due, (date(due) - today()).days, "")'
  is_overdue: 'if(due, date(due) < today() && status != "done", false)'
  priority_label: 'if(priority == 1, "High", if(priority == 2, "Medium", "Low"))'

properties:
  formula.days_until_due:
    displayName: "Days Until Due"
  formula.priority_label:
    displayName: Priority

views:
  - type: table
    name: "Active Tasks"
    filters:
      and:
        - 'status != "done"'
    order:
      - file.name
      - status
      - formula.priority_label
      - due
      - formula.days_until_due
    groupBy:
      property: status
      direction: ASC
    summaries:
      formula.days_until_due: Average

  - type: table
    name: "Completed"
    filters:
      and:
        - 'status == "done"'
    order:
      - file.name
      - completed_date
```

## Embedding Bases

```markdown
![[MyBase.base]]
![[MyBase.base#View Name]]
```

## YAML Quoting

Use single quotes for formulas containing double quotes: `'if(done, "Yes", "No")'`
Use double quotes for simple strings: `"My View Name"`
