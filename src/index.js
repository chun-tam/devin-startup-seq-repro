// Sample source file for ESLint to check
const os = require('os');

const greeting = 'Hello from devin-startup-seq-repro';

function getEnvironmentInfo() {
  return {
    platform: process.platform,
    arch: process.arch,
    nodeVersion: process.version,
    osType: os.type(),
    osRelease: os.release(),
    osMachine: os.machine(),
    cpus: os.cpus().length,
    totalMemory: os.totalmem(),
    hostname: os.hostname(),
  };
}

function main() {
  console.log(greeting);

  const envInfo = getEnvironmentInfo();
  console.log('Environment Info:');
  console.log(`  Platform:     ${envInfo.platform}`);
  console.log(`  Architecture: ${envInfo.arch}`);
  console.log(`  Node Version: ${envInfo.nodeVersion}`);
  console.log(`  OS Type:      ${envInfo.osType}`);
  console.log(`  OS Release:   ${envInfo.osRelease}`);
  console.log(`  OS Machine:   ${envInfo.osMachine}`);
  console.log(`  CPUs:         ${envInfo.cpus}`);
  console.log(`  Total Memory: ${envInfo.totalMemory}`);
  console.log(`  Hostname:     ${envInfo.hostname}`);
}

module.exports = { getEnvironmentInfo };

main();
