const fs = require('fs');
const p = require('path');
const dir = 'lib/features/speaking/presentation/pages/';

fs.readdirSync(dir).forEach(f => {
  if (!f.endsWith('.dart')) return;
  const fp = p.join(dir, f);
  let c = fs.readFileSync(fp, 'utf8');

  // Fix the broken syntax from a bad regex pass
  c = c.replace(/if \(state is SpeakingError\) \{ return Center\(child: Text\(state\.message\); \}/g, 'if (state is SpeakingError) { return Center(child: Text(state.message)); }');
  c = c.replace(/if \(state is SpeakingLoaded\) \{ return _buildGameUI\(context, state, isDark; \}/g, 'if (state is SpeakingLoaded) { return _buildGameUI(context, state, isDark); }');

  fs.writeFileSync(fp, c);
});
console.log('Fixed broken syntax!');
