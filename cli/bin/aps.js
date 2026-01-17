#!/usr/bin/env node

const { init } = require('../lib/commands/init');

const args = process.argv.slice(2);
const command = args[0];

async function main() {
  if (!command || command === '--help' || command === '-h') {
    showHelp();
    process.exit(0);
  }

  if (command === '--version' || command === '-v') {
    const pkg = require('../package.json');
    console.log(pkg.version);
    process.exit(0);
  }

  if (command === 'init') {
    const { targetDir, flags } = parseInitArgs(args.slice(1));

    try {
      await init(targetDir, flags);
      process.exit(0);
    } catch (error) {
      console.error('Error:', error.message);
      process.exit(1);
    }
  } else {
    console.error(`Unknown command: ${command}`);
    console.error('Run "aps --help" for usage information.');
    process.exit(1);
  }
}

function parseInitArgs(args) {
  const flags = {};
  let targetDir = null;

  for (let i = 0; i < args.length; i++) {
    const arg = args[i];

    if (arg === '--update') {
      flags.update = true;
    } else if (arg === '--force') {
      flags.force = true;
    } else if (arg === '--non-interactive') {
      flags.nonInteractive = true;
    } else if (arg === '--type' && args[i + 1]) {
      flags.projectType = args[i + 1];
      i++;
    } else if (arg === '--name' && args[i + 1]) {
      flags.projectName = args[i + 1];
      i++;
    } else if (!arg.startsWith('--') && !targetDir) {
      // First non-flag argument is the target directory
      targetDir = arg;
    }
  }

  return {
    targetDir: targetDir || process.cwd(),
    flags
  };
}

function showHelp() {
  console.log(`
aps - Anvil Plan Spec CLI

Usage:
  aps init [directory] [options]     Initialize APS structure in a project
  aps --help, -h                     Show this help message
  aps --version, -v                  Show version number

Commands:
  init                               Create APS directory structure and templates

Options:
  --update                           Update templates in existing APS project
  --force                            Skip safety prompts (use with caution)
  --non-interactive                  Run without prompts (requires --type)
  --type <type>                      Project type: quickstart, simple, module, multi, large
  --name <name>                      Project name for templates

Examples:
  aps init                           Interactive setup in current directory
  aps init ./my-project              Interactive setup in specific directory
  aps init --update                  Refresh templates in existing project
  aps init --type simple --name "My Feature"  Non-interactive setup

For more information, visit: https://github.com/EddaCraft/anvil-plan-spec
  `);
}

main().catch(error => {
  console.error('Unexpected error:', error);
  process.exit(1);
});
