const { execSync } = require('child_process');
try {
  const output = execSync('flutter analyze lib/features/writing', { encoding: 'utf8' });
  console.log(output);
} catch (error) {
  console.log(error.stdout);
  console.log(error.stderr);
}
