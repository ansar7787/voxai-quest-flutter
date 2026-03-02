$dir = "assets/curriculum/kids"
$games = @(
  "kids_alphabet","kids_numbers","kids_colors","kids_shapes",
  "kids_animals","kids_fruits","kids_family","kids_school",
  "kids_verbs","kids_emotions","kids_routine","kids_opposites",
  "kids_prepositions","kids_phonics","kids_jumble","kids_time",
  "kids_nature","kids_home","kids_food","kids_transport","kids_day_night"
)

$totalFiles = 0
$totalQuests = 0
$totalLevels = 0
$levelIssues = [System.Collections.ArrayList]::new()
$missingFiles = [System.Collections.ArrayList]::new()
$output = [System.Collections.ArrayList]::new()

foreach ($game in $games) {
  $gameQuests = 0
  $gameLevels = 0
  $gameFileCount = 0
  $gameIssueCount = 0

  for ($s = 1; $s -le 7; $s++) {
    $fileName = "${game}_s${s}.json"
    $file = Join-Path $dir $fileName
    if (-not (Test-Path $file)) {
      [void]$missingFiles.Add($file)
      continue
    }
    $gameFileCount++
    $totalFiles++

    $json = Get-Content $file -Raw | ConvertFrom-Json
    $quests = $json.quests

    $levelGroups = $quests | Group-Object -Property level

    foreach ($lg in $levelGroups) {
      $gameLevels++
      $totalLevels++
      $count = $lg.Count
      $totalQuests += $count
      $gameQuests += $count

      if ($count -ne 3) {
        $issue = "${fileName} | Level $($lg.Name) | $count questions (expected 3)"
        [void]$levelIssues.Add($issue)
        $gameIssueCount++
      }
    }
  }

  $status = "OK"
  if ($gameFileCount -ne 7) { $status = "MISSING FILES" }
  elseif ($gameIssueCount -gt 0) { $status = "ISSUES($gameIssueCount)" }

  $line = "$($game.PadRight(22)) | Files: $gameFileCount/7 | Levels: $($gameLevels.ToString().PadLeft(4)) | Quests: $($gameQuests.ToString().PadLeft(5)) | $status"
  [void]$output.Add($line)
}

$report = @"
==========================================
  KIDS CURRICULUM AUDIT REPORT
==========================================

Total JSON Files : $totalFiles / 147 expected
Total Levels     : $totalLevels / 4200 expected
Total Questions  : $totalQuests / 12600 expected

--- PER-GAME SUMMARY ---
"@

foreach ($gs in $output) { $report += "`n$gs" }

$report += "`n"

if ($missingFiles.Count -gt 0) {
  $report += "`n--- MISSING FILES ---"
  foreach ($mf in $missingFiles) { $report += "`n$mf" }
  $report += "`n"
}

if ($levelIssues.Count -gt 0) {
  $report += "`n--- LEVELS WITH != 3 QUESTIONS ($($levelIssues.Count) issues) ---"
  foreach ($li in $levelIssues) { $report += "`n$li" }
} else {
  $report += "`nAll levels have exactly 3 questions!"
}

$report | Out-File -FilePath "audit_results.txt" -Encoding utf8
Write-Host "Audit complete. Results written to audit_results.txt"
