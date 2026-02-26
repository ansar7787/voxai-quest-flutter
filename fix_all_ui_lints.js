const fs = require('fs');
const p = require('path');
const dir = 'lib/features/speaking/presentation/pages/';

fs.readdirSync(dir).forEach(f => {
  if (!f.endsWith('.dart')) return;
  const fp = p.join(dir, f);
  let c = fs.readFileSync(fp, 'utf8');

  // Fix withOpacity(x) -> withValues(alpha: x)
  c = c.replace(/\.withOpacity\(([^)]+)\)/g, '.withValues(alpha: $1)');

  // Fix if () return; -> if () { return; }
  // We need to match precisely: if (...) return; where (...) doesn't contain )
  // Wait, if expression contains multiple parens? _recognizedText.isEmpty has parenthesis!
  // It's `if (_hasAnalyzed || _recognizedText.isEmpty) return;`
  c = c.replace(/if \(_hasAnalyzed \|\| _recognizedText\.isEmpty\) return;/g, 'if (_hasAnalyzed || _recognizedText.isEmpty) { return; }');
  c = c.replace(/if \(state is! SpeakingLoaded\) return;/g, 'if (state is! SpeakingLoaded) { return; }');

  // For the `if (mounted)` one, it already has braces.

  // Fix multi-line if statements returning Center/Widget
  c = c.replace(/if \(state is SpeakingError\)[\s\n]+return Center\([^;]+\);/g, 'if (state is SpeakingError) { return Center(child: Text(state.message)); }');
  c = c.replace(/if \(state is SpeakingLoaded\)[\s\n]+return _buildGameUI\([^;]+\);/g, 'if (state is SpeakingLoaded) { return _buildGameUI(context, state, isDark); }');

  // Fix unbraced level conditionals
  c = c.replace(/if \(widget\.level is String\)[\s\n]+lvl = int\.tryParse\(widget\.level\) \?\? 1;/g, 'if (widget.level is String) { lvl = int.tryParse(widget.level) ?? 1; }');
  c = c.replace(/else if \(widget\.level is int\)[\s\n]+lvl = widget\.level;/g, 'else if (widget.level is int) { lvl = widget.level; }');

  fs.writeFileSync(fp, c);
});
console.log('Fixed all UI lints smoothly!');
