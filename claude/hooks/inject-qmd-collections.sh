#!/bin/bash
# Auto-inject available QMD collections into session context
export BUN_INSTALL=""

# If the current project has a QMD MCP server with INDEX_PATH, only show that index
if [ -f .mcp.json ]; then
  index_path=$(python3 -c "
import json, sys
d = json.load(open('.mcp.json'))
print(d.get('mcpServers',{}).get('qmd',{}).get('env',{}).get('INDEX_PATH',''))
" 2>/dev/null)
  if [ -n "$index_path" ]; then
    index=$(basename "$index_path" .sqlite)
    echo "QMD index: $index"
    qmd --index "$index" collection list 2>/dev/null || echo "  (not indexed)"
    exit 0
  fi
fi

# Fallback: show all indexes
for config in ~/.config/qmd/*.yml; do
  [ -f "$config" ] || continue
  index=$(basename "$config" .yml)
  echo "QMD index: $index"
  qmd --index "$index" collection list 2>/dev/null || echo "  (not indexed — run: qmd --index $index update)"
  echo
done
