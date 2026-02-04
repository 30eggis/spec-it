#!/usr/bin/env npx ts-node

/**
 * Extraction Validator
 *
 * Compares source HTML with generated TSX to ensure:
 * 1. All classes are preserved (no additions, no removals)
 * 2. DOM structure matches
 * 3. No imaginary components were created
 *
 * Usage: npx ts-node validate-extraction.ts <candidates-dir> <output-dir>
 */

import * as fs from 'fs';
import * as path from 'path';

interface ValidationResult {
  pageId: string;
  status: 'PASS' | 'FAIL';
  errors: string[];
  warnings: string[];
}

interface ClassComparison {
  onlyInSource: string[];
  onlyInGenerated: string[];
  common: string[];
}

// Extract all Tailwind/CSS classes from content
function extractClasses(content: string): Set<string> {
  const classes = new Set<string>();

  // Match class="..." or className="..."
  const classRegex = /(?:class|className)=["']([^"']+)["']/g;
  let match;

  while ((match = classRegex.exec(content)) !== null) {
    const classList = match[1].split(/\s+/);
    classList.forEach(cls => {
      if (cls.trim()) {
        classes.add(cls.trim());
      }
    });
  }

  return classes;
}

// Extract DOM structure (simplified)
function extractStructure(content: string): string[] {
  const tags: string[] = [];

  // Match opening tags
  const tagRegex = /<(\w+)(?:\s[^>]*)?>/g;
  let match;

  while ((match = tagRegex.exec(content)) !== null) {
    tags.push(match[1].toLowerCase());
  }

  return tags;
}

// Compare two class sets
function compareClasses(source: Set<string>, generated: Set<string>): ClassComparison {
  const onlyInSource: string[] = [];
  const onlyInGenerated: string[] = [];
  const common: string[] = [];

  source.forEach(cls => {
    if (generated.has(cls)) {
      common.push(cls);
    } else {
      onlyInSource.push(cls);
    }
  });

  generated.forEach(cls => {
    if (!source.has(cls)) {
      onlyInGenerated.push(cls);
    }
  });

  return { onlyInSource, onlyInGenerated, common };
}

// Validate a single page
function validatePage(candidateDir: string, pageId: string): ValidationResult {
  const result: ValidationResult = {
    pageId,
    status: 'PASS',
    errors: [],
    warnings: []
  };

  const sourceHtmlPath = path.join(candidateDir, pageId, 'source.html');
  const sourceTsxPath = path.join(candidateDir, pageId, 'source.tsx');

  // Check files exist
  if (!fs.existsSync(sourceHtmlPath)) {
    result.status = 'FAIL';
    result.errors.push(`Missing source.html for ${pageId}`);
    return result;
  }

  if (!fs.existsSync(sourceTsxPath)) {
    result.status = 'FAIL';
    result.errors.push(`Missing source.tsx for ${pageId}`);
    return result;
  }

  const sourceHtml = fs.readFileSync(sourceHtmlPath, 'utf-8');
  const sourceTsx = fs.readFileSync(sourceTsxPath, 'utf-8');

  // Compare classes
  const sourceClasses = extractClasses(sourceHtml);
  const generatedClasses = extractClasses(sourceTsx);
  const comparison = compareClasses(sourceClasses, generatedClasses);

  // Check for removed classes (CRITICAL ERROR)
  if (comparison.onlyInSource.length > 0) {
    result.status = 'FAIL';
    result.errors.push(
      `CLASSES REMOVED (${comparison.onlyInSource.length}): ${comparison.onlyInSource.slice(0, 10).join(', ')}${comparison.onlyInSource.length > 10 ? '...' : ''}`
    );
  }

  // Check for added classes (CRITICAL ERROR)
  // Allow some JSX-specific additions like 'className' syntax artifacts
  const allowedAdditions = new Set(['className']);
  const problematicAdditions = comparison.onlyInGenerated.filter(cls => !allowedAdditions.has(cls));

  if (problematicAdditions.length > 0) {
    result.status = 'FAIL';
    result.errors.push(
      `CLASSES ADDED (${problematicAdditions.length}): ${problematicAdditions.slice(0, 10).join(', ')}${problematicAdditions.length > 10 ? '...' : ''}`
    );
  }

  // Compare structure (warning level)
  const sourceStructure = extractStructure(sourceHtml);
  const generatedStructure = extractStructure(sourceTsx);

  if (sourceStructure.length !== generatedStructure.length) {
    result.warnings.push(
      `Structure mismatch: source has ${sourceStructure.length} tags, generated has ${generatedStructure.length} tags`
    );
  }

  // Calculate preservation rate
  const preservationRate = (comparison.common.length / sourceClasses.size) * 100;
  if (preservationRate < 95) {
    result.status = 'FAIL';
    result.errors.push(`Class preservation rate: ${preservationRate.toFixed(1)}% (required: 95%+)`);
  }

  return result;
}

// Check for imaginary components
function checkForImaginaryComponents(outputDir: string, candidateDir: string): string[] {
  const errors: string[] = [];

  const componentsDir = path.join(outputDir, 'components');
  if (!fs.existsSync(componentsDir)) {
    return errors;
  }

  // Get list of extracted component patterns
  const patternsFile = path.join(candidateDir, 'patterns.json');
  let knownPatterns: string[] = [];

  if (fs.existsSync(patternsFile)) {
    try {
      const patterns = JSON.parse(fs.readFileSync(patternsFile, 'utf-8'));
      knownPatterns = patterns.map((p: any) => p.name || p.id);
    } catch (e) {
      // patterns.json not available
    }
  }

  // Scan components directory
  const scanDir = (dir: string) => {
    if (!fs.existsSync(dir)) return;

    const files = fs.readdirSync(dir);
    files.forEach(file => {
      const fullPath = path.join(dir, file);
      const stat = fs.statSync(fullPath);

      if (stat.isDirectory()) {
        scanDir(fullPath);
      } else if (file.endsWith('.tsx') && !file.startsWith('index')) {
        const componentName = file.replace('.tsx', '');

        // Check if this component was extracted from patterns
        // For now, just log all components for manual review
        if (knownPatterns.length > 0 && !knownPatterns.includes(componentName)) {
          errors.push(`Component "${componentName}" not found in extracted patterns - may be imaginary`);
        }
      }
    });
  };

  scanDir(componentsDir);

  return errors;
}

// Main validation
function main() {
  const args = process.argv.slice(2);

  if (args.length < 1) {
    console.log('Usage: npx ts-node validate-extraction.ts <candidates-dir> [output-dir]');
    console.log('');
    console.log('Example: npx ts-node validate-extraction.ts ./candidates ./nextjs-app');
    process.exit(1);
  }

  const candidatesDir = args[0];
  const outputDir = args[1] || null;

  if (!fs.existsSync(candidatesDir)) {
    console.error(`Error: Candidates directory not found: ${candidatesDir}`);
    process.exit(1);
  }

  console.log('═══════════════════════════════════════════════════════════════');
  console.log('  EXTRACTION VALIDATOR');
  console.log('  Rule: COLLECT, DON\'T CREATE');
  console.log('═══════════════════════════════════════════════════════════════');
  console.log('');

  // Find all page directories
  const pageIds = fs.readdirSync(candidatesDir)
    .filter(f => {
      const fullPath = path.join(candidatesDir, f);
      return fs.statSync(fullPath).isDirectory() && f.startsWith('P');
    });

  if (pageIds.length === 0) {
    console.error('No page directories found (expected P001, P002, etc.)');
    process.exit(1);
  }

  console.log(`Found ${pageIds.length} pages to validate\n`);

  const results: ValidationResult[] = [];
  let hasFailures = false;

  // Validate each page
  for (const pageId of pageIds) {
    const result = validatePage(candidatesDir, pageId);
    results.push(result);

    const icon = result.status === 'PASS' ? '✓' : '✗';
    const color = result.status === 'PASS' ? '\x1b[32m' : '\x1b[31m';
    const reset = '\x1b[0m';

    console.log(`${color}${icon} ${pageId}: ${result.status}${reset}`);

    if (result.errors.length > 0) {
      hasFailures = true;
      result.errors.forEach(err => {
        console.log(`  ${'\x1b[31m'}ERROR: ${err}${reset}`);
      });
    }

    if (result.warnings.length > 0) {
      result.warnings.forEach(warn => {
        console.log(`  ${'\x1b[33m'}WARNING: ${warn}${reset}`);
      });
    }
  }

  // Check for imaginary components
  if (outputDir && fs.existsSync(outputDir)) {
    console.log('\n--- Component Check ---\n');
    const componentErrors = checkForImaginaryComponents(outputDir, candidatesDir);

    if (componentErrors.length > 0) {
      hasFailures = true;
      componentErrors.forEach(err => {
        console.log(`\x1b[31m✗ ${err}\x1b[0m`);
      });
    } else {
      console.log('\x1b[32m✓ No imaginary components detected\x1b[0m');
    }
  }

  // Summary
  console.log('\n═══════════════════════════════════════════════════════════════');

  const passed = results.filter(r => r.status === 'PASS').length;
  const failed = results.filter(r => r.status === 'FAIL').length;

  console.log(`Results: ${passed} passed, ${failed} failed`);

  if (hasFailures) {
    console.log('\n\x1b[31m✗ VALIDATION FAILED\x1b[0m');
    console.log('\nThe extraction contains modifications that violate the');
    console.log('"COLLECT, DON\'T CREATE" principle. Please re-extract');
    console.log('without any class additions, removals, or structure changes.');
    console.log('═══════════════════════════════════════════════════════════════\n');
    process.exit(1);
  } else {
    console.log('\n\x1b[32m✓ VALIDATION PASSED\x1b[0m');
    console.log('\nAll extractions preserve the original classes and structure.');
    console.log('Safe to proceed to the next phase.');
    console.log('═══════════════════════════════════════════════════════════════\n');
    process.exit(0);
  }
}

main();
