# Phase 1: Extraction Reference

## 1.1 CSS Extraction Script

```javascript
evaluate_script({
  function: `() => {
    const styles = {
      inline: [],
      embedded: [],
      external: []
    };

    document.querySelectorAll('[style]').forEach(el => {
      styles.inline.push({
        selector: el.tagName + (el.className ? '.' + el.className.split(' ')[0] : ''),
        style: el.getAttribute('style')
      });
    });

    document.querySelectorAll('style').forEach(style => {
      styles.embedded.push(style.textContent);
    });

    document.querySelectorAll('link[rel="stylesheet"]').forEach(link => {
      styles.external.push(link.href);
    });

    return styles;
  }`
})
```

## 1.2 Computed Style Extraction Script

```javascript
evaluate_script({
  function: `() => {
    const tokens = {
      colors: new Map(),
      typography: new Map(),
      spacing: new Map(),
      shadows: new Map(),
      borders: new Map()
    };

    document.querySelectorAll('*').forEach(el => {
      const cs = getComputedStyle(el);

      ['color', 'backgroundColor', 'borderColor'].forEach(prop => {
        const val = cs[prop];
        if (val && val !== 'rgba(0, 0, 0, 0)' && val !== 'transparent') {
          tokens.colors.set(val, (tokens.colors.get(val) || 0) + 1);
        }
      });

      const font = cs.fontFamily + '|' + cs.fontSize + '|' + cs.fontWeight + '|' + cs.lineHeight;
      tokens.typography.set(font, (tokens.typography.get(font) || 0) + 1);

      ['padding', 'margin', 'gap'].forEach(prop => {
        const val = cs[prop];
        if (val && val !== '0px') {
          tokens.spacing.set(val, (tokens.spacing.get(val) || 0) + 1);
        }
      });

      const shadow = cs.boxShadow;
      if (shadow && shadow !== 'none') {
        tokens.shadows.set(shadow, (tokens.shadows.get(shadow) || 0) + 1);
      }

      const radius = cs.borderRadius;
      if (radius && radius !== '0px') {
        tokens.borders.set(radius, (tokens.borders.get(radius) || 0) + 1);
      }
    });

    return {
      colors: [...tokens.colors.entries()].sort((a,b) => b[1] - a[1]),
      typography: [...tokens.typography.entries()].sort((a,b) => b[1] - a[1]),
      spacing: [...tokens.spacing.entries()].sort((a,b) => b[1] - a[1]),
      shadows: [...tokens.shadows.entries()].sort((a,b) => b[1] - a[1]),
      borders: [...tokens.borders.entries()].sort((a,b) => b[1] - a[1])
    };
  }`
})
```

## 1.3 Asset Extraction Script

```javascript
evaluate_script({
  function: `() => {
    const assets = { images: [], svgs: [], fonts: [], other: [] };

    // Images
    document.querySelectorAll('img').forEach(img => {
      if (img.src) {
        assets.images.push({
          src: img.src,
          path: new URL(img.src).pathname,
          alt: img.alt,
          width: img.naturalWidth,
          height: img.naturalHeight
        });
      }
    });

    // Background images
    document.querySelectorAll('*').forEach(el => {
      const bg = getComputedStyle(el).backgroundImage;
      if (bg && bg !== 'none' && bg.includes('url(')) {
        const match = bg.match(/url\\(["']?([^"')]+)["']?\\)/);
        if (match) {
          assets.images.push({
            src: match[1],
            path: new URL(match[1], location.href).pathname,
            type: 'background'
          });
        }
      }
    });

    // Inline SVGs
    document.querySelectorAll('svg').forEach((svg, i) => {
      assets.svgs.push({
        id: svg.id || 'svg-' + i,
        html: svg.outerHTML,
        viewBox: svg.getAttribute('viewBox'),
        inline: true
      });
    });

    // External SVGs
    document.querySelectorAll('img[src$=".svg"], use[href]').forEach(el => {
      const src = el.src || el.getAttribute('href');
      if (src) {
        assets.svgs.push({
          src: src,
          path: new URL(src, location.href).pathname,
          inline: false
        });
      }
    });

    // Fonts
    [...document.styleSheets].forEach(sheet => {
      try {
        [...sheet.cssRules].forEach(rule => {
          if (rule.cssText.includes('@font-face')) {
            const match = rule.cssText.match(/url\\(["']?([^"')]+)["']?\\)/g);
            if (match) {
              match.forEach(url => {
                const src = url.replace(/url\\(["']?|["']?\\)/g, '');
                assets.fonts.push({
                  src: src,
                  path: new URL(src, location.href).pathname
                });
              });
            }
          }
        });
      } catch (e) {}
    });

    // Other media
    document.querySelectorAll('video source, audio source').forEach(el => {
      if (el.src) {
        assets.other.push({
          type: el.parentElement.tagName.toLowerCase(),
          src: el.src,
          path: new URL(el.src).pathname
        });
      }
    });

    return assets;
  }`
})
```

## 1.4 Asset Download Commands

```bash
# Preserve original path structure
for asset in assets_list:
  mkdir -p "assets/$(dirname ${asset.path})"

  if [[ "$asset_src" == http* ]]; then
    curl -o "assets${asset.path}" "${asset.src}"
  else
    cp "${source_dir}${asset.path}" "assets${asset.path}"
  fi
```

## 1.5 Asset Manifest Format

```json
{
  "generated": "ISO8601 timestamp",
  "source": "original source URL/path",
  "assets": {
    "images": [{ "original": "/path", "local": "assets/path", "size": "KB", "dimensions": "WxH" }],
    "fonts": [{ "original": "/path", "local": "assets/path", "family": "name", "weight": 400 }],
    "svgs": [{ "id": "name", "type": "inline|external", "local": "assets/path" }]
  },
  "pathMapping": {
    "/images/": "assets/images/",
    "/fonts/": "assets/fonts/"
  }
}
```
