const fs = require('fs');
const path = require('path');

function detectAPS(targetPath) {
  const plansDir = path.join(targetPath, 'plans');
  const apsRules = path.join(plansDir, 'aps-rules.md');
  const indexFile = path.join(plansDir, 'index.aps.md');
  const modulesDir = path.join(plansDir, 'modules');

  const result = {
    isAPS: false,
    hasPlansDir: false,
    hasApsRules: false,
    hasIndexFile: false,
    hasModulesDir: false,
    hasFiles: false,
    apsFiles: []
  };

  // Check if target directory has any files
  if (fs.existsSync(targetPath)) {
    try {
      const files = fs.readdirSync(targetPath);
      result.hasFiles = files.length > 0;
    } catch (error) {
      // Permission error or other issue
      result.hasFiles = false;
    }
  }

  // Check for plans directory
  if (fs.existsSync(plansDir) && fs.statSync(plansDir).isDirectory()) {
    result.hasPlansDir = true;
  }

  // Check for aps-rules.md
  if (fs.existsSync(apsRules) && fs.statSync(apsRules).isFile()) {
    result.hasApsRules = true;
  }

  // Check for index.aps.md
  if (fs.existsSync(indexFile) && fs.statSync(indexFile).isFile()) {
    result.hasIndexFile = true;
    result.apsFiles.push('index.aps.md');
  }

  // Check for modules directory
  if (fs.existsSync(modulesDir) && fs.statSync(modulesDir).isDirectory()) {
    result.hasModulesDir = true;

    // Find .aps.md files in modules
    try {
      const moduleFiles = fs.readdirSync(modulesDir)
        .filter(file => file.endsWith('.aps.md') && !file.startsWith('.'));
      result.apsFiles.push(...moduleFiles.map(f => `modules/${f}`));
    } catch (error) {
      // Ignore read errors
    }
  }

  // Determine if this is an APS project
  // At minimum, should have plans dir and either aps-rules or index file
  result.isAPS = result.hasPlansDir && (result.hasApsRules || result.hasIndexFile || result.apsFiles.length > 0);

  return result;
}

module.exports = { detectAPS };
