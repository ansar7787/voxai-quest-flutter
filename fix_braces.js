const fs = require('fs');
const p = require('path');
const dir = 'lib/features/speaking/presentation/pages/';

fs.readdirSync(dir).forEach(f => {
  if (!f.endsWith('.dart')) return;
  const fp = p.join(dir, f);
  let c = fs.readFileSync(fp, 'utf8');

  // Replace
  // if (widget.level is String)
  //   lvl = int.tryParse(widget.level) ?? 1;
  // else if (widget.level is int)
  //   lvl = widget.level;
  
  c = c.replace(/if \(widget\.level is String\)\s+lvl = int\.tryParse\(widget\.level\) \?\? 1;/g, 'if (widget.level is String) { lvl = int.tryParse(widget.level) ?? 1; }');
  c = c.replace(/else if \(widget\.level is int\)\s+lvl = widget\.level;/g, 'else if (widget.level is int) { lvl = widget.level; }');

  fs.writeFileSync(fp, c);
});
console.log('Fixed unbraced level ifs!');
