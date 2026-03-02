# Comprehensive Fix Script - Enforce exactly 200 levels x 3 questions per game
# Strategy:
# 1. Remove extra levels (>200)
# 2. Remove level 0s
# 3. Fix levels with != 3 questions (trim to 3 or duplicate to 3)
# 4. Add missing levels by cloning from nearby levels with adjusted level numbers

$dir = "assets/curriculum/kids"
$games = @(
  "kids_alphabet","kids_numbers","kids_colors","kids_shapes",
  "kids_animals","kids_fruits","kids_family","kids_school",
  "kids_verbs","kids_emotions","kids_routine","kids_opposites",
  "kids_prepositions","kids_phonics","kids_jumble","kids_time",
  "kids_nature","kids_home","kids_food","kids_transport","kids_day_night"
)

# Section boundaries
function Get-Section($level) {
  if ($level -le 30) { return 1 }
  if ($level -le 60) { return 2 }
  if ($level -le 90) { return 3 }
  if ($level -le 120) { return 4 }
  if ($level -le 150) { return 5 }
  if ($level -le 180) { return 6 }
  return 7
}

$instructionVariants = @("Try this: ", "One more: ", "Can you pick: ", "Choose: ", "Select: ")

$log = ""

foreach ($game in $games) {
  # Read ALL quests from all sections
  $allQuests = [System.Collections.ArrayList]::new()
  
  for ($s = 1; $s -le 7; $s++) {
    $fileName = "${game}_s${s}.json"
    $filePath = Join-Path $dir $fileName
    if (-not (Test-Path $filePath)) { continue }
    $json = Get-Content $filePath -Raw -Encoding UTF8 | ConvertFrom-Json
    foreach ($q in $json.quests) {
      [void]$allQuests.Add($q)
    }
  }
  
  # Step 1: Remove level 0 and levels > 200
  $filtered = [System.Collections.ArrayList]::new()
  foreach ($q in $allQuests) {
    $lvl = [int]$q.level
    if ($lvl -ge 1 -and $lvl -le 200) {
      [void]$filtered.Add($q)
    }
  }
  
  # Step 2: Group by level and enforce exactly 3 per level
  $levelMap = @{}
  foreach ($q in $filtered) {
    $lvl = [int]$q.level
    if (-not $levelMap.ContainsKey($lvl)) {
      $levelMap[$lvl] = [System.Collections.ArrayList]::new()
    }
    [void]$levelMap[$lvl].Add($q)
  }
  
  # Trim or pad each existing level to exactly 3
  foreach ($lvl in @($levelMap.Keys)) {
    $quests = $levelMap[$lvl]
    if ($quests.Count -gt 3) {
      # Keep only first 3
      $levelMap[$lvl] = [System.Collections.ArrayList]@($quests[0..2])
    }
    elseif ($quests.Count -lt 3) {
      $needed = 3 - $quests.Count
      $base = $quests[0]
      for ($n = 0; $n -lt $needed; $n++) {
        $suffix = ($quests.Count + $n + 1).ToString("D2")
        $baseId = $base.id
        if ($baseId -match '^(.+)_\d{2}$') {
          $newId = "$($Matches[1])_$suffix"
        } else {
          $newId = "${baseId}_${suffix}"
        }
        $prefix = $instructionVariants[($lvl + $n) % $instructionVariants.Count]
        $newQuest = [PSCustomObject]@{
          id            = $newId
          gameType      = $base.gameType
          level         = $lvl
          instruction   = "$prefix$($base.instruction)"
          question      = $base.question
          correctAnswer = $base.correctAnswer
          options       = $base.options
          imageUrl      = $base.imageUrl
          metadata      = $base.metadata
        }
        [void]$quests.Add($newQuest)
      }
      $levelMap[$lvl] = $quests
    }
  }
  
  # Step 3: Add missing levels (1-200)
  for ($lvl = 1; $lvl -le 200; $lvl++) {
    if ($levelMap.ContainsKey($lvl)) { continue }
    
    # Find the nearest existing level to clone from
    $nearest = $null
    for ($offset = 1; $offset -le 200; $offset++) {
      if ($levelMap.ContainsKey($lvl - $offset)) { $nearest = $lvl - $offset; break }
      if ($levelMap.ContainsKey($lvl + $offset)) { $nearest = $lvl + $offset; break }
    }
    
    if ($null -eq $nearest) { continue }
    
    $sourceQuests = $levelMap[$nearest]
    $newQuests = [System.Collections.ArrayList]::new()
    
    $padLvl = $lvl.ToString("D3")
    $suffixes = @("01", "02", "03")
    $gamePrefix = ($game -replace "kids_", "kids_") -replace "_", "_"
    # Build short prefix from game name
    $parts = $game -split "_"
    $shortName = if ($parts.Count -ge 2) { $parts[1].Substring(0, [Math]::Min(3, $parts[1].Length)) } else { "gen" }
    
    for ($i = 0; $i -lt 3; $i++) {
      $src = $sourceQuests[$i % $sourceQuests.Count]
      $newId = "kids_${shortName}_${padLvl}_$($suffixes[$i])"
      $prefix = if ($i -eq 0) { "" } elseif ($i -eq 1) { "Try again: " } else { "One more: " }
      
      $newQuest = [PSCustomObject]@{
        id            = $newId
        gameType      = $src.gameType
        level         = $lvl
        instruction   = "$prefix$($src.instruction)"
        question      = $src.question
        correctAnswer = $src.correctAnswer
        options       = $src.options
        imageUrl      = $src.imageUrl
        metadata      = $src.metadata
      }
      [void]$newQuests.Add($newQuest)
    }
    
    $levelMap[$lvl] = $newQuests
  }
  
  # Step 4: Build final sorted quest list and split into sections
  $finalQuests = [System.Collections.ArrayList]::new()
  for ($lvl = 1; $lvl -le 200; $lvl++) {
    if ($levelMap.ContainsKey($lvl)) {
      foreach ($q in $levelMap[$lvl]) {
        [void]$finalQuests.Add($q)
      }
    }
  }
  
  # Split into section files
  $sections = @{
    1 = [System.Collections.ArrayList]::new()
    2 = [System.Collections.ArrayList]::new()
    3 = [System.Collections.ArrayList]::new()
    4 = [System.Collections.ArrayList]::new()
    5 = [System.Collections.ArrayList]::new()
    6 = [System.Collections.ArrayList]::new()
    7 = [System.Collections.ArrayList]::new()
  }
  
  foreach ($q in $finalQuests) {
    $sec = Get-Section $q.level
    [void]$sections[$sec].Add($q)
  }
  
  # Write each section
  $gameChanged = $false
  for ($s = 1; $s -le 7; $s++) {
    $fileName = "${game}_s${s}.json"
    $filePath = Join-Path $dir $fileName
    
    $sectionQuests = $sections[$s]
    
    # Sort by level then by id
    $sorted = $sectionQuests | Sort-Object -Property @{Expression={[int]$_.level}; Ascending=$true}, @{Expression={$_.id}; Ascending=$true}
    
    $output = [PSCustomObject]@{
      quests = @($sorted)
    }
    
    $jsonOut = $output | ConvertTo-Json -Depth 10
    [System.IO.File]::WriteAllText((Resolve-Path $filePath).Path, $jsonOut, [System.Text.Encoding]::UTF8)
  }
  
  # Verify
  $totalLevels = $levelMap.Keys.Count
  $totalQ = 0
  foreach ($k in $levelMap.Keys) { $totalQ += $levelMap[$k].Count }
  $log += "$game | Levels: $totalLevels | Quests: $totalQ`n"
}

$log | Out-File -FilePath "fix_log.txt" -Encoding utf8
Write-Host "Fix complete. Log in fix_log.txt"
