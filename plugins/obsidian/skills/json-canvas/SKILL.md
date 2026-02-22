---
name: json-canvas
description: >
  Create and edit JSON Canvas files (.canvas) with nodes, edges, groups, and connections.
  Use when working with .canvas files, creating visual canvases, mind maps, flowcharts,
  or when the user mentions "Canvas files" in Obsidian.
version: 0.1.0
---

# JSON Canvas

Create and edit valid JSON Canvas files (`.canvas`) used in Obsidian and other applications. Follows the JSON Canvas Spec 1.0.

## File Structure

```json
{
  "nodes": [],
  "edges": []
}
```

Nodes are ordered by z-index: first = bottom layer, last = top layer.

## Node Types

All nodes share: `id` (string, required), `type` (required), `x`, `y`, `width`, `height` (integers, required), `color` (optional canvasColor).

### Text Nodes

```json
{
  "id": "6f0ad84f44ce9c17",
  "type": "text",
  "x": 0, "y": 0, "width": 400, "height": 200,
  "text": "# Hello World\n\nThis is **Markdown** content."
}
```

**Important:** Use `\n` for newlines in JSON strings, never `\\n`.

### File Nodes

```json
{
  "id": "a1b2c3d4e5f67890",
  "type": "file",
  "x": 500, "y": 0, "width": 400, "height": 300,
  "file": "Attachments/diagram.png"
}
```

Optional `subpath` for linking to a heading or block: `"subpath": "#Implementation"`.

### Link Nodes

```json
{
  "id": "c3d4e5f678901234",
  "type": "link",
  "x": 1000, "y": 0, "width": 400, "height": 200,
  "url": "https://obsidian.md"
}
```

### Group Nodes

```json
{
  "id": "d4e5f6789012345a",
  "type": "group",
  "x": -50, "y": -50, "width": 1000, "height": 600,
  "label": "Project Overview",
  "color": "4"
}
```

Optional `background` (path to image) and `backgroundStyle`: `cover`, `ratio`, or `repeat`.

## Edges

```json
{
  "id": "f67890123456789a",
  "fromNode": "6f0ad84f44ce9c17",
  "fromSide": "right",
  "fromEnd": "none",
  "toNode": "a1b2c3d4e5f67890",
  "toSide": "left",
  "toEnd": "arrow",
  "color": "1",
  "label": "leads to"
}
```

- `fromSide`/`toSide`: `top`, `right`, `bottom`, `left` (optional)
- `fromEnd`: defaults to `none`; `toEnd`: defaults to `arrow`
- End shapes: `none`, `arrow`

## Colors

Hex: `"#FF0000"` or presets: `"1"` (Red), `"2"` (Orange), `"3"` (Yellow), `"4"` (Green), `"5"` (Cyan), `"6"` (Purple).

## ID Generation

Use 16-character lowercase hex strings: `"6f0ad84f44ce9c17"`.

## Layout Guidelines

- Coordinates can be negative (infinite canvas)
- `x` increases right, `y` increases down
- Position is top-left corner

| Node Type | Width | Height |
|-----------|-------|--------|
| Small text | 200-300 | 80-150 |
| Medium text | 300-450 | 150-300 |
| Large text | 400-600 | 300-500 |
| File preview | 300-500 | 200-400 |
| Link preview | 250-400 | 100-200 |

Leave 20-50px padding inside groups. Space nodes 50-100px apart. Align to multiples of 10 or 20.

## Complete Example: Mind Map

```json
{
  "nodes": [
    {
      "id": "8a9b0c1d2e3f4a5b",
      "type": "text",
      "x": 0, "y": 0, "width": 300, "height": 150,
      "text": "# Main Idea\n\nCentral concept."
    },
    {
      "id": "1a2b3c4d5e6f7a8b",
      "type": "text",
      "x": 400, "y": -100, "width": 250, "height": 100,
      "text": "## Point A\n\nDetails here."
    },
    {
      "id": "2b3c4d5e6f7a8b9c",
      "type": "text",
      "x": 400, "y": 100, "width": 250, "height": 100,
      "text": "## Point B\n\nMore details."
    }
  ],
  "edges": [
    {
      "id": "3c4d5e6f7a8b9c0d",
      "fromNode": "8a9b0c1d2e3f4a5b",
      "fromSide": "right",
      "toNode": "1a2b3c4d5e6f7a8b",
      "toSide": "left"
    },
    {
      "id": "4d5e6f7a8b9c0d1e",
      "fromNode": "8a9b0c1d2e3f4a5b",
      "fromSide": "right",
      "toNode": "2b3c4d5e6f7a8b9c",
      "toSide": "left"
    }
  ]
}
```

## Complete Example: Project Board

```json
{
  "nodes": [
    {
      "id": "5e6f7a8b9c0d1e2f",
      "type": "group",
      "x": 0, "y": 0, "width": 300, "height": 500,
      "label": "To Do", "color": "1"
    },
    {
      "id": "6f7a8b9c0d1e2f3a",
      "type": "group",
      "x": 350, "y": 0, "width": 300, "height": 500,
      "label": "In Progress", "color": "3"
    },
    {
      "id": "7a8b9c0d1e2f3a4b",
      "type": "group",
      "x": 700, "y": 0, "width": 300, "height": 500,
      "label": "Done", "color": "4"
    },
    {
      "id": "8b9c0d1e2f3a4b5c",
      "type": "text",
      "x": 20, "y": 50, "width": 260, "height": 80,
      "text": "## Task 1\n\nImplement feature X"
    },
    {
      "id": "9c0d1e2f3a4b5c6d",
      "type": "text",
      "x": 370, "y": 50, "width": 260, "height": 80,
      "text": "## Task 2\n\nReview PR #123",
      "color": "2"
    }
  ],
  "edges": []
}
```

## Validation Rules

1. All `id` values must be unique across nodes and edges
2. `fromNode` and `toNode` must reference existing node IDs
3. `type` must be: `text`, `file`, `link`, or `group`
4. `backgroundStyle` must be: `cover`, `ratio`, or `repeat`
5. Side values must be: `top`, `right`, `bottom`, or `left`
6. End shapes must be: `none` or `arrow`
7. Color presets: `"1"` through `"6"` or valid hex color
