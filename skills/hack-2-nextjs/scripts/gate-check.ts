#!/usr/bin/env npx ts-node

/**
 * Validation Gate
 *
 * Quick check to determine if extraction is valid enough to proceed.
 * Designed to be called between phases in the skill workflow.
 *
 * Usage: npx ts-node gate-check.ts <candidates-dir> <phase>
 *
 * Phases:
 *   - post-extraction: After Phase 1, before Phase 2
 *   - post-components: After Phase 4, before Phase 5
 *   - post-generation: After Phase 5, before Phase 6
 *
 * Exit codes:
 *   0 = Gate passed, proceed
 *   1 = Gate failed, stop execution
 */

import * as fs from 'fs';
import * as path from 'path';

type Phase = 'post-extraction' | 'post-components' | 'post-generation';

interface GateResult {
  passed: boolean;
  errors: string[];
  warnings: string[];
}

function extractClasses(content: string): Set<string> {
  const classes = new Set<string>();
  const classRegex = /(?:class|className)=["']([^"']+)["']/g;
  let match;
  while ((match = classRegex.exec(content)) !== null) {
    match[1].split(/\s+/).forEach(cls => {
      if (cls.trim()) classes.add(cls.trim());
    });
  }
  return classes;
}

function checkPostExtraction(candidatesDir: string): GateResult {
  const result: GateResult = { passed: true, errors: [], warnings: [] };

  // Find all page directories
  const pageIds = fs.readdirSync(candidatesDir)
    .filter(f => {
      const fullPath = path.join(candidatesDir, f);
      return fs.statSync(fullPath).isDirectory() && f.startsWith('P');
    });

  if (pageIds.length === 0) {
    result.passed = false;
    result.errors.push('No page directories found in candidates/');
    return result;
  }

  for (const pageId of pageIds) {
    const sourceHtml = path.join(candidatesDir, pageId, 'source.html');
    const sourceTsx = path.join(candidatesDir, pageId, 'source.tsx');

    // Check files exist
    if (!fs.existsSync(sourceHtml)) {
      result.passed = false;
      result.errors.push(`${pageId}: Missing source.html`);
      continue;
    }

    if (!fs.existsSync(sourceTsx)) {
      result.passed = false;
      result.errors.push(`${pageId}: Missing source.tsx`);
      continue;
    }

    // Quick class comparison
    const htmlContent = fs.readFileSync(sourceHtml, 'utf-8');
    const tsxContent = fs.readFileSync(sourceTsx, 'utf-8');

    const htmlClasses = extractClasses(htmlContent);
    const tsxClasses = extractClasses(tsxContent);

    // Check preservation rate
    let preserved = 0;
    htmlClasses.forEach(cls => {
      if (tsxClasses.has(cls)) preserved++;
    });

    const rate = (preserved / htmlClasses.size) * 100;

    if (rate < 95) {
      result.passed = false;
      result.errors.push(`${pageId}: Class preservation only ${rate.toFixed(1)}% (required: 95%+)`);
    }

    // Check for significant additions
    let added = 0;
    tsxClasses.forEach(cls => {
      if (!htmlClasses.has(cls)) added++;
    });

    if (added > 5) {
      result.warnings.push(`${pageId}: ${added} classes added (may indicate modifications)`);
    }
  }

  return result;
}

function checkPostComponents(candidatesDir: string): GateResult {
  const result: GateResult = { passed: true, errors: [], warnings: [] };

  const componentsFile = path.join(candidatesDir, 'components', 'candidates.json');
  const patternsFile = path.join(candidatesDir, 'patterns.json');

  // Check that component candidates are documented
  if (!fs.existsSync(componentsFile) && !fs.existsSync(patternsFile)) {
    result.warnings.push('No component candidates file found - ensure components are from actual patterns');
  }

  // Check aggregated components directory
  const aggregatedDir = path.join(path.dirname(candidatesDir), 'aggregated');
  const componentsDoc = path.join(aggregatedDir, 'components.md');

  if (fs.existsSync(componentsDoc)) {
    const content = fs.readFileSync(componentsDoc, 'utf-8');

    // Check for source references
    if (!content.includes('Source:') && !content.includes('Found in:')) {
      result.warnings.push('components.md does not reference source patterns - may contain imaginary components');
    }
  }

  return result;
}

function checkPostGeneration(candidatesDir: string): GateResult {
  const result: GateResult = { passed: true, errors: [], warnings: [] };

  const projectDir = path.dirname(candidatesDir);
  const nextjsDir = path.join(projectDir, 'nextjs-app');

  if (!fs.existsSync(nextjsDir)) {
    result.passed = false;
    result.errors.push('nextjs-app/ directory not found');
    return result;
  }

  // Check package.json exists
  if (!fs.existsSync(path.join(nextjsDir, 'package.json'))) {
    result.passed = false;
    result.errors.push('package.json not found in nextjs-app/');
  }

  // Check app directory exists
  if (!fs.existsSync(path.join(nextjsDir, 'app'))) {
    result.passed = false;
    result.errors.push('app/ directory not found in nextjs-app/');
  }

  // Spot check: compare a page's classes
  const pageIds = fs.readdirSync(candidatesDir)
    .filter(f => {
      const fullPath = path.join(candidatesDir, f);
      return fs.statSync(fullPath).isDirectory() && f.startsWith('P');
    });

  if (pageIds.length > 0) {
    // Check first page as sample
    const samplePage = pageIds[0];
    const sourceTsx = path.join(candidatesDir, samplePage, 'source.tsx');

    if (fs.existsSync(sourceTsx)) {
      const sourceContent = fs.readFileSync(sourceTsx, 'utf-8');
      const sourceClasses = extractClasses(sourceContent);

      // Find corresponding generated page
      // This is a simplified check - in practice would need route mapping
      const appDir = path.join(nextjsDir, 'app');
      const generatedPages = fs.readdirSync(appDir)
        .filter(f => f.endsWith('.tsx') || f === 'page.tsx');

      if (generatedPages.length > 0) {
        const generatedContent = fs.readFileSync(path.join(appDir, 'page.tsx'), 'utf-8');
        const generatedClasses = extractClasses(generatedContent);

        // Check that generated contains most source classes
        let found = 0;
        sourceClasses.forEach(cls => {
          if (generatedClasses.has(cls)) found++;
        });

        const rate = (found / sourceClasses.size) * 100;

        if (rate < 80) {
          result.warnings.push(`Sample page class match only ${rate.toFixed(1)}% - may indicate reimplementation`);
        }
      }
    }
  }

  return result;
}

function main() {
  const args = process.argv.slice(2);

  if (args.length < 2) {
    console.log('Usage: npx ts-node gate-check.ts <candidates-dir> <phase>');
    console.log('');
    console.log('Phases: post-extraction, post-components, post-generation');
    process.exit(1);
  }

  const candidatesDir = args[0];
  const phase = args[1] as Phase;

  if (!['post-extraction', 'post-components', 'post-generation'].includes(phase)) {
    console.error(`Unknown phase: ${phase}`);
    process.exit(1);
  }

  if (!fs.existsSync(candidatesDir)) {
    console.error(`Candidates directory not found: ${candidatesDir}`);
    process.exit(1);
  }

  console.log(`\n🚦 GATE CHECK: ${phase.toUpperCase()}\n`);

  let result: GateResult;

  switch (phase) {
    case 'post-extraction':
      result = checkPostExtraction(candidatesDir);
      break;
    case 'post-components':
      result = checkPostComponents(candidatesDir);
      break;
    case 'post-generation':
      result = checkPostGeneration(candidatesDir);
      break;
  }

  // Output results
  if (result.errors.length > 0) {
    console.log('Errors:');
    result.errors.forEach(err => {
      console.log(`  \x1b[31m✗ ${err}\x1b[0m`);
    });
  }

  if (result.warnings.length > 0) {
    console.log('Warnings:');
    result.warnings.forEach(warn => {
      console.log(`  \x1b[33m⚠ ${warn}\x1b[0m`);
    });
  }

  console.log('');

  if (result.passed) {
    console.log('\x1b[32m✓ GATE PASSED - Proceed to next phase\x1b[0m\n');
    process.exit(0);
  } else {
    console.log('\x1b[31m✗ GATE FAILED - Do not proceed\x1b[0m');
    console.log('\nThe extraction violates "COLLECT, DON\'T CREATE" rules.');
    console.log('Fix the errors above before continuing.\n');
    process.exit(1);
  }
}

main();
