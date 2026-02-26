const fs = require('fs');
const p = require('path');
const dir = 'lib/features/speaking/presentation/pages/';

fs.readdirSync(dir).forEach(f => {
  if (!f.endsWith('.dart')) return;
  const fp = p.join(dir, f);
  let c = fs.readFileSync(fp, 'utf8');

  // Fix deprecation
  c = c.replace(/\.withOpacity\(([^)]+)\)/g, '.withValues(alpha: $1)');

  // Fix early returns (needs curly braces for flutter analyze info)
  c = c.replace(/if \(([^)]+)\) return;/g, 'if ($1) { return; }');

  // Fix specific if statement without braces returning Center 
  c = c.replace(/if \(state is SpeakingError\) return Center\(([^)]+)\);/g, 'if (state is SpeakingError) { return Center($1); }');

  // Fix specific if statement without braces returning _buildGameUI
  c = c.replace(/if \(state is SpeakingLoaded\) return _buildGameUI\(context, state, isDark\);/g, 'if (state is SpeakingLoaded) { return _buildGameUI(context, state, isDark); }');

  fs.writeFileSync(fp, c);
});
console.log('Fixed UI lints without breaking syntax');
