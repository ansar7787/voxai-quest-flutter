const { exec } = require('child_process');
const fs = require('fs');
exec('flutter analyze lib/features/writing', (error, stdout, stderr) => {
  fs.writeFileSync('detailed_analysis.txt', stdout + '\n' + stderr);
  console.log('Done');
});
