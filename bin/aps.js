#!/usr/bin/env node

/**
 * APS CLI - Anvil Plan Spec Initializer
 *
 * Usage:
 *   npx anvil-plan-spec init [target-dir]
 *   npx anvil-plan-spec init --update [target-dir]
 *   aps init [target-dir]
 *   aps init --update [target-dir]
 */

import { existsSync, mkdirSync, writeFileSync, readFileSync, copyFileSync } from 'node:fs';
import { join, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const SCAFFOLD_DIR = join(__dirname, '..', 'scaffold', 'plans');

const GREEN = '\x1b[32m';
const YELLOW = '\x1b[33m';
const RESET = '\x1b[0m';

function info(msg) {
  console.log(`${GREEN}[aps]${RESET} ${msg}`);
}

function warn(msg) {
  console.log(`${YELLOW}[aps]${RESET} ${msg}`);
}

function showHelp() {
  console.log(`
Anvil Plan Spec (APS) CLI

Usage:
  aps init [target-dir]           Initialize APS in a project
  aps init --update [target-dir]  Update templates only (preserves your specs)
  aps help                        Show this help message

Examples:
  aps init                        Initialize in current directory
  aps init ./my-project           Initialize in specific directory
  aps init --update               Update templates in current directory

Learn more: https://github.com/EddaCraft/anvil-plan-spec
`);
}

function copyFile(srcName, destPath) {
  const srcPath = join(SCAFFOLD_DIR, srcName);
  if (existsSync(srcPath)) {
    const content = readFileSync(srcPath, 'utf-8');
    writeFileSync(destPath, content);
  } else {
    throw new Error(`Source file not found: ${srcPath}`);
  }
}

function initAPS(targetDir, updateMode) {
  const plansDir = join(targetDir, 'plans');

  if (updateMode) {
    if (!existsSync(plansDir)) {
      warn('No plans/ directory found. Run without --update to initialize.');
      process.exit(1);
    }

    info('Updating APS templates and rules (your specs are preserved)...');

    copyFile('aps-rules.md', join(plansDir, 'aps-rules.md'));
    copyFile('modules/.module.template.md', join(plansDir, 'modules', '.module.template.md'));
    copyFile('modules/.simple.template.md', join(plansDir, 'modules', '.simple.template.md'));
    copyFile('execution/.steps.template.md', join(plansDir, 'execution', '.steps.template.md'));

    info('Updated:');
    console.log('  - aps-rules.md (agent guidance)');
    console.log('  - modules/.module.template.md');
    console.log('  - modules/.simple.template.md');
    console.log('  - execution/.steps.template.md');
    console.log('');
    info('Your specs (index.aps.md, modules/*.aps.md) were NOT modified.');
  } else {
    if (existsSync(plansDir)) {
      warn('plans/ directory already exists.');
      warn('To update templates only: aps init --update');
      warn(`To reinitialize: rm -rf ${plansDir} && aps init`);
      process.exit(1);
    }

    info(`Creating APS structure in ${plansDir}...`);

    mkdirSync(join(plansDir, 'modules'), { recursive: true });
    mkdirSync(join(plansDir, 'execution'), { recursive: true });
    mkdirSync(join(plansDir, 'decisions'), { recursive: true });

    copyFile('aps-rules.md', join(plansDir, 'aps-rules.md'));
    copyFile('index.aps.md', join(plansDir, 'index.aps.md'));
    copyFile('modules/.module.template.md', join(plansDir, 'modules', '.module.template.md'));
    copyFile('modules/.simple.template.md', join(plansDir, 'modules', '.simple.template.md'));
    copyFile('execution/.steps.template.md', join(plansDir, 'execution', '.steps.template.md'));

    writeFileSync(join(plansDir, 'decisions', '.gitkeep'), '');

    info('Done! Created:');
    console.log('');
    console.log('  plans/');
    console.log('  ├── aps-rules.md            <- Agent guidance (READ THIS)');
    console.log('  ├── index.aps.md            <- Your main plan (edit this)');
    console.log('  ├── modules/');
    console.log('  │   ├── .module.template.md <- Template for modules');
    console.log('  │   └── .simple.template.md <- Template for small features');
    console.log('  ├── execution/');
    console.log('  │   └── .steps.template.md  <- Template for action plans');
    console.log('  └── decisions/');
    console.log('      └── .gitkeep');
    console.log('');
    info('Next steps:');
    console.log('  1. Edit plans/index.aps.md to define your plan');
    console.log('  2. Copy templates to create modules (remove leading dot)');
    console.log('  3. Point your AI agent at plans/aps-rules.md');
    console.log('');
  }
}

function main() {
  const args = process.argv.slice(2);

  if (args.length === 0 || args[0] === 'help' || args[0] === '--help' || args[0] === '-h') {
    showHelp();
    process.exit(0);
  }

  const command = args[0];

  if (command !== 'init') {
    warn(`Unknown command: ${command}`);
    showHelp();
    process.exit(1);
  }

  let updateMode = false;
  let targetDir = '.';

  for (let i = 1; i < args.length; i++) {
    if (args[i] === '--update' || args[i] === '-u') {
      updateMode = true;
    } else if (!args[i].startsWith('-')) {
      targetDir = args[i];
    }
  }

  if (!existsSync(targetDir)) {
    warn(`Target directory does not exist: ${targetDir}`);
    process.exit(1);
  }

  initAPS(targetDir, updateMode);
}

main();
