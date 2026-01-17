const fs = require('fs');
const path = require('path');

async function scaffold(targetPath, options = {}) {
  const {
    projectType = 'multi',
    projectName = 'My Project',
    modulePrefix = 'PROJ',
    includeExamples = false,
    includeDecisions = true,
    update = false
  } = options;

  const plansDir = path.join(targetPath, 'plans');
  const modulesDir = path.join(plansDir, 'modules');
  const executionDir = path.join(plansDir, 'execution');
  const decisionsDir = path.join(plansDir, 'decisions');

  // Create directory structure
  if (!update) {
    fs.mkdirSync(plansDir, { recursive: true });
    fs.mkdirSync(modulesDir, { recursive: true });
    fs.mkdirSync(executionDir, { recursive: true });

    if (includeDecisions) {
      fs.mkdirSync(decisionsDir, { recursive: true });
    }
  }

  // Determine template path (relative to this file)
  const templatesDir = path.join(__dirname, '..', 'templates');

  // Copy aps-rules.md
  const apsRulesSource = path.join(templatesDir, 'aps-rules.md');
  const apsRulesDest = path.join(plansDir, 'aps-rules.md');

  if (update || !fs.existsSync(apsRulesDest)) {
    if (fs.existsSync(apsRulesSource)) {
      fs.copyFileSync(apsRulesSource, apsRulesDest);
    }
  }

  // Copy template files to modules/
  const moduleTemplates = [
    '.module.template.md',
    '.simple.template.md'
  ];

  for (const template of moduleTemplates) {
    const source = path.join(templatesDir, template);
    const dest = path.join(modulesDir, template);

    if (fs.existsSync(source)) {
      fs.copyFileSync(source, dest);
    }
  }

  // Copy action plan template to execution/
  const actionsTemplate = path.join(templatesDir, '.actions.template.md');
  const actionsDest = path.join(executionDir, '.actions.template.md');

  if (fs.existsSync(actionsTemplate)) {
    fs.copyFileSync(actionsTemplate, actionsDest);
  }

  // Create main index file (only if not update mode)
  if (!update) {
    await createIndexFile(plansDir, modulesDir, projectType, projectName, modulePrefix, templatesDir);
  }

  // Create example modules if requested
  if (includeExamples && !update) {
    createExampleModule(modulesDir, modulePrefix);
  }

  // Create .aps-version file for tracking
  const versionFile = path.join(plansDir, '.aps-version');
  const versionData = {
    cliVersion: require('../package.json').version,
    lastUpdated: new Date().toISOString(),
    projectType: projectType
  };
  fs.writeFileSync(versionFile, JSON.stringify(versionData, null, 2));
}

async function createIndexFile(plansDir, modulesDir, projectType, projectName, modulePrefix, templatesDir) {
  let indexContent = '';
  let indexPath = '';

  switch (projectType) {
    case 'quickstart':
      indexPath = path.join(plansDir, 'index.aps.md');
      indexContent = fs.readFileSync(path.join(templatesDir, 'quickstart.template.md'), 'utf8');
      indexContent = indexContent.replace(/\[Project Name\]/g, projectName);
      break;

    case 'simple':
      indexPath = path.join(plansDir, 'index.aps.md');
      indexContent = fs.readFileSync(path.join(templatesDir, 'simple.template.md'), 'utf8');
      indexContent = indexContent.replace(/\[Feature Name\]/g, projectName);
      indexContent = indexContent.replace(/FEAT-/g, `${modulePrefix}-`);
      break;

    case 'module':
      indexPath = path.join(modulesDir, `01-${slugify(projectName)}.aps.md`);
      indexContent = fs.readFileSync(path.join(templatesDir, 'module.template.md'), 'utf8');
      indexContent = indexContent.replace(/\[Module Title\]/g, projectName);
      indexContent = indexContent.replace(/AUTH/g, modulePrefix);
      indexContent = indexContent.replace(/@username/g, getGitUser());
      break;

    case 'multi':
      indexPath = path.join(plansDir, 'index.aps.md');
      indexContent = fs.readFileSync(path.join(templatesDir, 'index.template.md'), 'utf8');
      indexContent = indexContent.replace(/\[Project Name\]/g, projectName);
      break;

    case 'large':
      indexPath = path.join(plansDir, 'index.aps.md');
      indexContent = fs.readFileSync(path.join(templatesDir, 'index-expanded.template.md'), 'utf8');
      indexContent = indexContent.replace(/\[Project Name\]/g, projectName);
      break;

    default:
      throw new Error(`Unknown project type: ${projectType}`);
  }

  fs.writeFileSync(indexPath, indexContent);
}

function createExampleModule(modulesDir, modulePrefix) {
  const exampleContent = `# Example Module

| ID | Owner | Priority | Status |
|----|-------|----------|--------|
| ${modulePrefix} | @username | medium | Draft |

## Purpose

This is an example module to show you how APS modules are structured.

## In Scope

- Example work items with all required fields
- Observable validation commands
- Confidence levels

## Work Items

### ${modulePrefix}-001: Example work item

- **Intent:** Demonstrate work item structure
- **Expected Outcome:** User understands required fields
- **Validation:** \`echo "success"\`
- **Confidence:** high

### ${modulePrefix}-002: Another example

- **Intent:** Show multiple work items in a module
- **Expected Outcome:** User sees how to break down larger features
- **Validation:** \`test -f README.md\`
- **Confidence:** medium

## Notes

- Delete this example when you're ready to create your own modules
- Refer to the template files in this directory for creating new modules
`;

  const examplePath = path.join(modulesDir, '00-example.aps.md');
  fs.writeFileSync(examplePath, exampleContent);
}

function slugify(text) {
  return text
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '');
}

function getGitUser() {
  try {
    const { execSync } = require('child_process');
    const username = execSync('git config user.name', { encoding: 'utf8', stdio: ['pipe', 'pipe', 'ignore'] }).trim();
    return username || 'username';
  } catch (error) {
    return 'username';
  }
}

module.exports = { scaffold };
