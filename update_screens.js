const fs = require('fs');
const path = require('path');

const libDir = "c:/Users/asus/Documents/App Projects/voxai_quest/lib/features";

function walkDir(dir, callback) {
    fs.readdirSync(dir).forEach(f => {
        let dirPath = path.join(dir, f);
        let isDirectory = fs.statSync(dirPath).isDirectory();
        isDirectory ? walkDir(dirPath, callback) : callback(path.join(dir, f));
    });
}

function processFile(filePath) {
    if (!filePath.endsWith('_screen.dart') || filePath.includes('kids') || filePath.includes('voxin_mascot')) return;
    
    let content = fs.readFileSync(filePath, 'utf8');
    
    if (!content.includes('void _showGameOverDialog') || !content.includes('RestoreLife()')) return;
    
    let blocMatch = content.match(/context\.read<([A-Za-z]+Bloc)>\(\)\.add\(RestoreLife\(\)\);/);
    if (!blocMatch) {
        return;
    }
    let blocName = blocMatch[1];
    
    // Find the _showGameOverDialog block and replace its ModernGameDialog configuration.
    // We target the exact section containing RETRY and QUIT.
    let oldBlockPattern = /buttonText:\s*['"]RETRY['"],[\s\S]*?onSecondaryPressed:\s*\(\)\s*\{[\s\S]*?\},/;
    
    let replacement = `isSuccess: false,
        isRescueLife: true,
        buttonText: 'GIVE UP',
        onButtonPressed: () {
          Navigator.pop(c);
          context.pop();
        },
        onAdAction: () {
          void restoreLife() {
            context.read<${blocName}>().add(RestoreLife());
            Navigator.pop(c);
          }
          final isPremium = context.read<AuthBloc>().state.user?.isPremium ?? false;
          if (isPremium) {
            restoreLife();
          } else {
            di.sl<AdService>().showRewardedAd(
              isPremium: false,
              onUserEarnedReward: (_) => restoreLife(),
              onDismissed: () {},
            );
          }
        },
        adButtonText: 'WATCH AD TO CONTINUE',`;

    if (oldBlockPattern.test(content)) {
        content = content.replace(oldBlockPattern, replacement);
        
        let needAuthBloc = !content.includes("import 'package:voxai_quest/features/auth/presentation/bloc/auth_bloc.dart';");
        let needAdService = !content.includes("import 'package:voxai_quest/core/utils/ad_service.dart';");
        
        // Find last import
        if (needAuthBloc || needAdService) {
            let lastImportIndex = content.lastIndexOf("import 'package:");
            let endOfLastImport = content.indexOf(';', lastImportIndex) + 1;
            
            let importsToAdd = "\n";
            if (needAuthBloc) importsToAdd += "import 'package:voxai_quest/features/auth/presentation/bloc/auth_bloc.dart';\n";
            if (needAdService) importsToAdd += "import 'package:voxai_quest/core/utils/ad_service.dart';\n";
            
            content = content.slice(0, endOfLastImport) + importsToAdd + content.slice(endOfLastImport);
        }

        fs.writeFileSync(filePath, content, 'utf8');
        console.log("Updated", filePath);
    } else {
        console.log("Pattern did not match in", filePath);
    }
}

walkDir(libDir, processFile);
