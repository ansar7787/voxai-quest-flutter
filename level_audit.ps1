# Detailed Level Audit - Find exactly which levels exist/missing/extra per game
$dir = "assets/curriculum/kids"
$games = @(
  "kids_alphabet","kids_numbers","kids_colors","kids_shapes",
  "kids_animals","kids_fruits","kids_family","kids_school",
  "kids_verbs","kids_emotions","kids_routine","kids_opposites",
  "kids_prepositions","kids_phonics","kids_jumble","kids_time",
  "kids_nature","kids_home","kids_food","kids_transport","kids_day_night"
)

$out = ""
$out += "DETAILED LEVEL AUDIT`n"
$out += "====================`n`n"

foreach ($game in $games) {
  $allLevels = @{}
  $totalQuests = 0
  
  for ($s = 1; $s -le 7; $s++) {
    $fileName = "${game}_s${s}.json"
    $filePath = Join-Path $dir $fileName
    if (-not (Test-Path $filePath)) { continue }
    
    $json = Get-Content $filePath -Raw -Encoding UTF8 | ConvertFrom-Json
    foreach ($q in $json.quests) {
      $lvl = [int]$q.level
      if (-not $allLevels.ContainsKey($lvl)) {
        $allLevels[$lvl] = @{ count = 0; section = $s }
      }
      $allLevels[$lvl].count++
      $totalQuests++
    }
  }
  
  $uniqueLevels = $allLevels.Keys | Sort-Object
  $levelCount = $uniqueLevels.Count
  $minLevel = if ($uniqueLevels.Count -gt 0) { $uniqueLevels[0] } else { 0 }
  $maxLevel = if ($uniqueLevels.Count -gt 0) { $uniqueLevels[-1] } else { 0 }
  
  # Find missing levels (1-200)
  $missing = @()
  for ($i = 1; $i -le 200; $i++) {
    if (-not $allLevels.ContainsKey($i)) { $missing += $i }
  }
  
  # Find extra levels (>200)
  $extra = @()
  foreach ($lvl in $uniqueLevels) {
    if ($lvl -gt 200) { $extra += $lvl }
  }
  
  # Find levels with != 3 questions
  $wrongCount = @()
  foreach ($lvl in $uniqueLevels) {
    if ($allLevels[$lvl].count -ne 3) {
      $wrongCount += "$lvl($($allLevels[$lvl].count)q)"
    }
  }
  
  $status = "OK"
  if ($missing.Count -gt 0 -or $extra.Count -gt 0 -or $wrongCount.Count -gt 0) {
    $status = "NEEDS FIX"
  }
  
  $out += "GAME: $game | Levels: $levelCount | Quests: $totalQuests | Range: $minLevel-$maxLevel | $status`n"
  
  if ($missing.Count -gt 0) {
    $out += "  MISSING levels: $($missing -join ', ')`n"
  }
  if ($extra.Count -gt 0) {
    $out += "  EXTRA levels (>200): $($extra -join ', ')`n"
  }
  if ($wrongCount.Count -gt 0) {
    $out += "  WRONG question count: $($wrongCount -join ', ')`n"
  }
  $out += "`n"
}

$out | Out-File -FilePath "level_audit.txt" -Encoding utf8
Write-Host "Done. Results in level_audit.txt"
