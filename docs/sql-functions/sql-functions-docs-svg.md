---
description: 'Documentation for Svg'
sidebarTitle: 'SVG'
slug: /sql-reference/functions/geo/svg
title: 'Functions for Generating SVG images from Geo data'
doc_type: 'reference'
---

## Svg {#svg}

Returns a string of select SVG element tags from Geo data.

**Syntax**

```sql
Svg(geometry,[style])
```

Aliases: `SVG`, `svg`

**Parameters**

- `geometry` — Geo data. [Geo](/reference/data-types/geo).
- `style` — Optional style name. [String](/reference/data-types/string).

**Returned value**

- The SVG representation of the geometry. [String](/reference/data-types/string).
  - SVG circle
  - SVG polygon
  - SVG path

**Examples**

**Circle**

```sql title="Query"
SELECT SVG((0., 0.))
```

```response title="Response"
```

**Polygon**

```sql title="Query"
SELECT SVG([(0., 0.), (10, 0), (10, 10), (0, 10)])
```

```response title="Response"
```

**Path**

```sql title="Query"
SELECT SVG([[(0., 0.), (10, 0), (10, 10), (0, 10)], [(4., 4.), (5, 4), (5, 5), (4, 5)]])
```

```response title="Response"
```
