// Sample source file for ESLint to check
const greeting = 'Hello from devin-startup-seq-repro';

function getEnvironmentInfo() {
  return {
    nodeVersion: process.version,
    platform: process.platform,
    arch: process.arch,
    pid: process.pid,
  };
}

function main() {
  console.log(greeting);
  const env = getEnvironmentInfo();
  console.log('Node version:', env.nodeVersion);
  console.log('Platform:', env.platform);
  console.log('Architecture:', env.arch);
}

main();
