const { createRunOncePlugin } = require('@expo/config-plugins');
const pkg = require('../../package.json');

function withAutoSkeleton(config) {
  return config;
}

module.exports = createRunOncePlugin(withAutoSkeleton, pkg.name, pkg.version);
