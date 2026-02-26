const fs = require('fs');
const path = require('path');
const dir = 'c:/Users/asus/Documents/App Projects/voxai_quest/lib/features/reading/presentation/pages';
const files = fs.readdirSync(dir).filter(f => f.endsWith('.dart'));

for (const file of files) {
  const filePath = path.join(dir, file);
  let content = fs.readFileSync(filePath, 'utf8');

  // Fix all instances of context.read inside delayed closures
  content = content.replace(
    /BuildContext context\) {\s*if \(_selected(.*?)\s*Haptics\.vibrate\(HapticsType\.selection\);\s*setState\(\(\) => _selected(.*?) = index\);\s*Future\.delayed\(const Duration\(milliseconds: 300\), \(\) \{/g,
    "BuildContext context) {\n    if (_selected$1\n    Haptics.vibrate(HapticsType.selection);\n    setState(() => _selected$2 = index);\n    final readingBloc = context.read<ReadingBloc>();\n    \n    Future.delayed(const Duration(milliseconds: 300), () {"
  );
  
  content = content.replace(
    /if \(mounted\) \{\s*context\.read<ReadingBloc>\(\)\.add\(SubmitAnswer\((.*?)\)\);\s*\}/g,
    "if (mounted) {\n        readingBloc.add(SubmitAnswer($1));\n      }"
  );
  
  // Specific fix for readAndMatch
  content = content.replace(
    /if \(_matchedLeft\.length == _leftItems\.length\) \{\s*Future\.delayed\(const Duration\(milliseconds: 500\), \(\) \{\s*if \(mounted\) \{\s*context\.read<ReadingBloc>\(\)\.add\(SubmitAnswer\(true\)\);\s*\}\s*\}\);/g,
    "if (_matchedLeft.length == _leftItems.length) {\n           final readingBloc = context.read<ReadingBloc>();\n           Future.delayed(const Duration(milliseconds: 500), () {\n             if (mounted) {\n               readingBloc.add(SubmitAnswer(true));\n             }\n           });"
  );
  
  // Another specific fix for sentenceOrder
  content = content.replace(
    /void _submitAnswer\(List<int> correctOrder\) \{\s*if \(_hasSubmitted\) return;\s*Haptics\.vibrate\(HapticsType\.selection\);\s*setState\(\(\) => _hasSubmitted = true\);\s*([\s\S]*?)Future\.delayed\(const Duration\(milliseconds: 300\), \(\) \{/g,
    "void _submitAnswer(List<int> correctOrder) {\n    if (_hasSubmitted) return;\n    Haptics.vibrate(HapticsType.selection);\n    setState(() => _hasSubmitted = true);\n    $1\n    final readingBloc = context.read<ReadingBloc>();\n    Future.delayed(const Duration(milliseconds: 300), () {"
  );

  fs.writeFileSync(filePath, content, 'utf8');
}
console.log('Fixed lints.');
