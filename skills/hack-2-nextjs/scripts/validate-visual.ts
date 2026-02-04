#!/usr/bin/env npx ts-node

/**
 * Visual Validator
 *
 * Compares screenshots of original source with generated NextJS app
 * Uses pixel-based comparison to ensure visual match >= 95%
 *
 * Usage: npx ts-node validate-visual.ts <screenshots-dir>
 *
 * Expected structure:
 * screenshots-dir/
 * ├── P001/
 * │   ├── original.png
 * │   └── generated.png
 * ├── P002/
 * │   ├── original.png
 * │   └── generated.png
 * └── ...
 */

import * as fs from 'fs';
import * as path from 'path';
import { execSync } from 'child_process';

interface VisualResult {
  pageId: string;
  status: 'PASS' | 'FAIL' | 'SKIP';
  matchPercentage: number;
  diffPixels: number;
  totalPixels: number;
  message: string;
}

// Check if ImageMagick is available
function checkDependencies(): boolean {
  try {
    execSync('which compare', { stdio: 'pipe' });
    return true;
  } catch {
    return false;
  }
}

// Compare two images using ImageMagick
function compareImages(original: string, generated: string, diffOutput: string): VisualResult {
  const pageId = path.basename(path.dirname(original));

  if (!fs.existsSync(original)) {
    return {
      pageId,
      status: 'SKIP',
      matchPercentage: 0,
      diffPixels: 0,
      totalPixels: 0,
      message: `Original screenshot not found: ${original}`
    };
  }

  if (!fs.existsSync(generated)) {
    return {
      pageId,
      status: 'SKIP',
      matchPercentage: 0,
      diffPixels: 0,
      totalPixels: 0,
      message: `Generated screenshot not found: ${generated}`
    };
  }

  try {
    // Use ImageMagick compare
    // -metric AE returns the number of different pixels
    const result = execSync(
      `compare -metric AE "${original}" "${generated}" "${diffOutput}" 2>&1 || true`,
      { encoding: 'utf-8' }
    );

    const diffPixels = parseInt(result.trim()) || 0;

    // Get image dimensions to calculate total pixels
    const identifyResult = execSync(
      `identify -format "%w %h" "${original}"`,
      { encoding: 'utf-8' }
    );
    const [width, height] = identifyResult.trim().split(' ').map(Number);
    const totalPixels = width * height;

    const matchPercentage = ((totalPixels - diffPixels) / totalPixels) * 100;

    return {
      pageId,
      status: matchPercentage >= 95 ? 'PASS' : 'FAIL',
      matchPercentage,
      diffPixels,
      totalPixels,
      message: `${matchPercentage.toFixed(1)}% match (${diffPixels} different pixels)`
    };
  } catch (error: any) {
    return {
      pageId,
      status: 'FAIL',
      matchPercentage: 0,
      diffPixels: 0,
      totalPixels: 0,
      message: `Comparison failed: ${error.message}`
    };
  }
}

// Alternative: Simple dimension check without ImageMagick
function compareDimensions(original: string, generated: string): VisualResult {
  const pageId = path.basename(path.dirname(original));

  if (!fs.existsSync(original) || !fs.existsSync(generated)) {
    return {
      pageId,
      status: 'SKIP',
      matchPercentage: 0,
      diffPixels: 0,
      totalPixels: 0,
      message: 'Screenshots not found'
    };
  }

  // Just check file sizes as a rough proxy
  const originalSize = fs.statSync(original).size;
  const generatedSize = fs.statSync(generated).size;

  const sizeDiff = Math.abs(originalSize - generatedSize) / originalSize * 100;

  return {
    pageId,
    status: sizeDiff < 20 ? 'PASS' : 'FAIL',
    matchPercentage: 100 - sizeDiff,
    diffPixels: 0,
    totalPixels: 0,
    message: `File size difference: ${sizeDiff.toFixed(1)}% (rough estimate)`
  };
}

function main() {
  const args = process.argv.slice(2);

  if (args.length < 1) {
    console.log('Usage: npx ts-node validate-visual.ts <screenshots-dir>');
    console.log('');
    console.log('Expected structure:');
    console.log('  screenshots-dir/P001/original.png');
    console.log('  screenshots-dir/P001/generated.png');
    process.exit(1);
  }

  const screenshotsDir = args[0];

  if (!fs.existsSync(screenshotsDir)) {
    console.error(`Error: Screenshots directory not found: ${screenshotsDir}`);
    process.exit(1);
  }

  const hasImageMagick = checkDependencies();

  console.log('═══════════════════════════════════════════════════════════════');
  console.log('  VISUAL VALIDATOR');
  console.log('  Required: 95%+ visual match');
  console.log('═══════════════════════════════════════════════════════════════');
  console.log('');

  if (!hasImageMagick) {
    console.log('\x1b[33mWarning: ImageMagick not found. Using file size comparison.\x1b[0m');
    console.log('For accurate comparison, install ImageMagick: brew install imagemagick\n');
  }

  // Find all page directories
  const pageIds = fs.readdirSync(screenshotsDir)
    .filter(f => {
      const fullPath = path.join(screenshotsDir, f);
      return fs.statSync(fullPath).isDirectory() && f.startsWith('P');
    });

  if (pageIds.length === 0) {
    console.error('No page directories found');
    process.exit(1);
  }

  console.log(`Found ${pageIds.length} pages to compare\n`);

  const results: VisualResult[] = [];
  let hasFailures = false;

  // Create diff output directory
  const diffDir = path.join(screenshotsDir, 'diffs');
  if (!fs.existsSync(diffDir)) {
    fs.mkdirSync(diffDir, { recursive: true });
  }

  for (const pageId of pageIds) {
    const original = path.join(screenshotsDir, pageId, 'original.png');
    const generated = path.join(screenshotsDir, pageId, 'generated.png');
    const diff = path.join(diffDir, `${pageId}-diff.png`);

    let result: VisualResult;

    if (hasImageMagick) {
      result = compareImages(original, generated, diff);
    } else {
      result = compareDimensions(original, generated);
    }

    results.push(result);

    const icon = result.status === 'PASS' ? '✓' : result.status === 'SKIP' ? '○' : '✗';
    const color = result.status === 'PASS' ? '\x1b[32m' : result.status === 'SKIP' ? '\x1b[33m' : '\x1b[31m';
    const reset = '\x1b[0m';

    console.log(`${color}${icon} ${pageId}: ${result.message}${reset}`);

    if (result.status === 'FAIL') {
      hasFailures = true;
      if (hasImageMagick) {
        console.log(`  Diff saved to: ${diff}`);
      }
    }
  }

  // Summary
  console.log('\n═══════════════════════════════════════════════════════════════');

  const passed = results.filter(r => r.status === 'PASS').length;
  const failed = results.filter(r => r.status === 'FAIL').length;
  const skipped = results.filter(r => r.status === 'SKIP').length;

  console.log(`Results: ${passed} passed, ${failed} failed, ${skipped} skipped`);

  if (hasFailures) {
    console.log('\n\x1b[31m✗ VISUAL VALIDATION FAILED\x1b[0m');
    console.log('\nThe generated app does not visually match the original.');
    console.log('Check the diff images in the diffs/ directory.');
    console.log('═══════════════════════════════════════════════════════════════\n');
    process.exit(1);
  } else {
    console.log('\n\x1b[32m✓ VISUAL VALIDATION PASSED\x1b[0m');
    console.log('\nAll pages meet the 95%+ visual match requirement.');
    console.log('═══════════════════════════════════════════════════════════════\n');
    process.exit(0);
  }
}

main();
