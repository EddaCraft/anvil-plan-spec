const fs = require('fs');
const path = require('path');
const prompts = require('prompts');
const { scaffold } = require('../scaffold');
const { detectAPS } = require('../detect');

async function init(targetDir, flags = {}) {
  const targetPath = path.resolve(targetDir);

  // Check if directory exists
  if (!fs.existsSync(targetPath)) {
    if (!flags.force) {
      const { confirm } = await prompts({
        type: 'confirm',
        name: 'confirm',
        message: `Directory "${targetPath}" does not exist. Create it?`,
        initial: true
      });

      if (!confirm) {
        console.log('Initialization cancelled.');
        return;
      }
    }
    fs.mkdirSync(targetPath, { recursive: true });
  }

  // Detect existing APS structure
  const apsDetection = detectAPS(targetPath);

  // Handle update mode
  if (flags.update) {
    if (!apsDetection.isAPS) {
      throw new Error('No APS structure detected. Remove --update flag to initialize a new project.');
    }

    console.log('Updating APS templates...');
    await scaffold(targetPath, { ...flags, update: true, skipPrompts: true });
    console.log('\n✓ Templates updated successfully!');
    return;
  }

  // Check if directory is not empty (and not an update)
  if (apsDetection.hasFiles && !flags.force) {
    const { confirm } = await prompts({
      type: 'confirm',
      name: 'confirm',
      message: `Directory "${targetPath}" is not empty. Continue?`,
      initial: false
    });

    if (!confirm) {
      console.log('Initialization cancelled.');
      return;
    }
  }

  // If APS structure exists, ask if they want to update
  if (apsDetection.isAPS && !flags.force) {
    const { action } = await prompts({
      type: 'select',
      name: 'action',
      message: 'APS structure detected. What would you like to do?',
      choices: [
        { title: 'Update templates only (preserves your work)', value: 'update' },
        { title: 'Reinitialize (WARNING: may overwrite files)', value: 'reinit' },
        { title: 'Cancel', value: 'cancel' }
      ],
      initial: 0
    });

    if (action === 'cancel') {
      console.log('Initialization cancelled.');
      return;
    }

    if (action === 'update') {
      flags.update = true;
      console.log('Updating APS templates...');
      await scaffold(targetPath, { ...flags, update: true, skipPrompts: true });
      console.log('\n✓ Templates updated successfully!');
      return;
    }
  }

  // Get configuration from prompts or flags
  const config = flags.nonInteractive
    ? getNonInteractiveConfig(flags)
    : await getInteractiveConfig(targetPath, flags);

  if (!config) {
    console.log('Initialization cancelled.');
    return;
  }

  // Scaffold the project
  console.log('\nInitializing APS structure...');
  await scaffold(targetPath, { ...flags, ...config });

  // Show success message
  showSuccessMessage(targetPath, config);
}

function getNonInteractiveConfig(flags) {
  if (!flags.projectType) {
    throw new Error('--type is required in non-interactive mode. Use: quickstart, simple, module, multi, or large');
  }

  return {
    projectType: flags.projectType,
    projectName: flags.projectName || path.basename(process.cwd()),
    includeExamples: false,
    includeDecisions: true
  };
}

async function getInteractiveConfig(targetPath, flags) {
  console.log('\nWelcome to Anvil Plan Spec! Let\'s set up your project.\n');

  const response = await prompts([
    {
      type: 'select',
      name: 'projectType',
      message: 'What type of project are you planning?',
      choices: [
        { title: 'Quickstart - Try APS in 5 minutes (single file)', value: 'quickstart', description: 'Fastest way to try APS' },
        { title: 'Simple - Small feature (1-3 work items)', value: 'simple', description: 'Perfect for small features' },
        { title: 'Module - Single bounded feature', value: 'module', description: 'Full module with interfaces' },
        { title: 'Multi-Module - Typical project (2-6 modules)', value: 'multi', description: 'Most common choice' },
        { title: 'Large Initiative - Complex project (6+ modules)', value: 'large', description: 'For large initiatives' }
      ],
      initial: 3
    },
    {
      type: 'text',
      name: 'projectName',
      message: 'Project name?',
      initial: flags.projectName || path.basename(targetPath),
      validate: value => value.trim().length > 0 || 'Project name cannot be empty'
    },
    {
      type: prev => ['multi', 'large'].includes(prev) ? 'text' : null,
      name: 'modulePrefix',
      message: 'Module ID prefix (2-6 uppercase letters)?',
      initial: (prev, values) => {
        const name = values.projectName || '';
        return name
          .split(/[\s-_]+/)
          .map(word => word[0])
          .join('')
          .toUpperCase()
          .slice(0, 4) || 'PROJ';
      },
      validate: value => {
        if (!/^[A-Z]{2,6}$/.test(value)) {
          return 'Must be 2-6 uppercase letters (e.g., AUTH, PAY, PROJ)';
        }
        return true;
      }
    },
    {
      type: 'confirm',
      name: 'includeExamples',
      message: 'Include example modules?',
      initial: false
    },
    {
      type: 'confirm',
      name: 'includeDecisions',
      message: 'Include decision log structure?',
      initial: true
    }
  ]);

  // Handle cancellation (Ctrl+C)
  if (!response.projectType) {
    return null;
  }

  return response;
}

function showSuccessMessage(targetPath, config) {
  const relPath = path.relative(process.cwd(), targetPath) || '.';

  console.log(`
✓ APS structure created successfully!

Created files:
  ${relPath}/plans/index.aps.md          - Main planning file
  ${relPath}/plans/aps-rules.md          - AI agent guidance
  ${relPath}/plans/modules/              - Module specifications
  ${relPath}/plans/execution/            - Action plans
${config.includeDecisions ? `  ${relPath}/plans/decisions/            - Decision records\n` : ''}
Next steps:

  1. Edit plans/index.aps.md to define your ${config.projectType === 'multi' ? 'modules' : 'work items'}

  2. Share plans/aps-rules.md with your AI assistant for best results

  3. Learn more: https://github.com/EddaCraft/anvil-plan-spec

${config.projectType === 'quickstart' ? `Quick tip: The quickstart template is designed to get you planning in 5 minutes.
Just fill in the work items and you're ready to go!\n` : ''}
Happy planning! 🎯
  `);
}

module.exports = { init };
