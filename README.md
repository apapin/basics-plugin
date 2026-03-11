# dotagent

Personal agent configuration, hooks, and Claude Code plugins.

## What's here

```
├── plugins/         Claude Code plugin marketplace
│   ├── obsidian/      Vault skill — search, read, create notes via QMD
│   └── skill-creator/ Guide for authoring skills
├── claude/           Global agent config
│   ├── CLAUDE.md       Preferences, conventions, vault instructions
│   ├── hooks/          SessionStart hook (QMD collection injection)
│   └── settings.reference.json
├── qmd/              QMD index configurations
│   ├── acolyte.yml     Personal Obsidian vault
│   └── yuma.yml        Yuma project docs
└── install.sh        Bootstrap — symlinks configs into place
```

## Setup

```sh
git clone git@github.com:apapin/dotagent.git ~/dev/dotagent
cd ~/dev/dotagent
./install.sh          # or --dry-run to preview
```

The install script symlinks `CLAUDE.md`, hooks, and QMD configs into their expected locations (`~/.claude/`, `~/.config/qmd/`). Re-run safely after pulling changes.

### Plugin marketplace

```sh
claude plugin marketplace add apapin/dotagent
claude plugin install obsidian@basics
```

### QMD

```sh
npm install -g @tobilu/qmd
qmd --index acolyte update && qmd --index acolyte embed
qmd --index yuma update && qmd --index yuma embed
```

## How it works

- **CLAUDE.md** — always loaded into agent context. Contains behavioral directives (search vault before coding), conventions, vault index names.
- **SessionStart hook** — injects available QMD collections at session start. Project-aware: if `.mcp.json` defines a QMD `INDEX_PATH`, only that index is shown.
- **Vault skill** — auto-triggers on vault/docs/notes/reference keywords. Documents MCP tools (preferred) and CLI fallback.
- **QMD configs** — define which folders to index, ignore patterns, and sub-collection context descriptions.

## Multiple config dirs

If using multiple Claude Code config dirs (e.g. `~/.claude` and `~/.claude-team`), symlink the content dirs from the secondary to the primary:

```sh
ln -s ~/.claude/CLAUDE.md ~/.claude-team/CLAUDE.md
ln -s ~/.claude/hooks ~/.claude-team/hooks
ln -s ~/.claude/skills ~/.claude-team/skills
```

`settings.json` should remain independent per config dir (it accumulates instance-specific state).
