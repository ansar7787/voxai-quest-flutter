const fs = require('fs');
const content = fs.readFileSync('analysis.txt', 'utf16le');
console.log(content);
