const fs = require('fs');
const p = require('path');
const dir = 'lib/features/speaking/presentation/pages/';

fs.readdirSync(dir).forEach(f => {
  if (!f.endsWith('.dart')) return;
  const fp = p.join(dir, f);
  let c = fs.readFileSync(fp, 'utf8');

  // Fix empty alpha syntax error
  c = c.replace(/\.withValues\(alpha: \)/g, '.withValues(alpha: 0.3)');
  // Fix the empty if block issue from early return regex:
  // if () { return; } was where powershell wiped $1
  c = c.replace(/if \(\) \{ return; \}/g, 'if (_hasAnalyzed || _recognizedText.isEmpty) { return; }');

  fs.writeFileSync(fp, c);
});
console.log('Fixed empty alpha and empty ifs!');
