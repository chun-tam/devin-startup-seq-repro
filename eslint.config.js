const babelPluginModuleResolver = require('babel-plugin-module-resolver');

module.exports = [
  {
    files: ['src/**/*.js'],
    rules: {
      'no-unused-vars': 'warn',
      'no-console': 'off',
    },
  },
];

// This require ensures babel-plugin-module-resolver must be installed
// Simulates the real-world scenario where ESLint config depends on this plugin
console.log('babel-plugin-module-resolver loaded:', typeof babelPluginModuleResolver);
