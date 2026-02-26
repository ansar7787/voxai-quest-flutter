const fs = require('fs');
const p = require('path');
const dir = 'lib/features/speaking/presentation/pages/';

fs.readdirSync(dir).forEach(f => {
  if (!f.endsWith('.dart')) return;
  const fp = p.join(dir, f);
  let c = fs.readFileSync(fp, 'utf8');

  // Replace only the second occurrence.
  let count = 0;
  c = c.replace(/if \(_hasAnalyzed \|\| _recognizedText\.isEmpty\) \{ return; \}/g, match => {
    count++;
    if (count === 2) {
      return 'if (state is! SpeakingLoaded) { return; }';
    }
    return match;
  });

  fs.writeFileSync(fp, c);
});
console.log('Fixed duplicated if statements!');
