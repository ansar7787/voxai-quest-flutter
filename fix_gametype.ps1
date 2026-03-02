# Fix gameType in all JSON files to match app screen strings
# Also ensure 'choice_multi' is preserved as the actual game mechanic type
$dir = "assets/curriculum/kids"

# Map file name prefix -> correct Firestore gameType
$gameTypeMap = @{
  "kids_alphabet"      = "alphabet"
  "kids_numbers"       = "numbers"
  "kids_colors"        = "colors"
  "kids_shapes"        = "shapes"
  "kids_animals"       = "animals"
  "kids_fruits"        = "fruits"
  "kids_family"        = "family"
  "kids_school"        = "school"
  "kids_verbs"         = "verbs"
  "kids_emotions"      = "emotions"
  "kids_routine"       = "routine"
  "kids_opposites"     = "opposites"
  "kids_prepositions"  = "prepositions"
  "kids_phonics"       = "phonics"
  "kids_jumble"        = "jumble"
  "kids_time"          = "time"
  "kids_nature"        = "nature"
  "kids_home"          = "home"
  "kids_food"          = "food"
  "kids_transport"     = "transport"
  "kids_day_night"     = "day_night"
}

$totalFixed = 0

foreach ($game in $gameTypeMap.Keys) {
  $correctGameType = $gameTypeMap[$game]
  
  for ($s = 1; $s -le 7; $s++) {
    $fileName = "${game}_s${s}.json"
    $filePath = Join-Path $dir $fileName
    if (-not (Test-Path $filePath)) { continue }
    
    $json = Get-Content $filePath -Raw -Encoding UTF8 | ConvertFrom-Json
    $changed = $false
    
    foreach ($q in $json.quests) {
      if ($q.gameType -ne $correctGameType) {
        $q.gameType = $correctGameType
        $changed = $true
      }
    }
    
    if ($changed) {
      $jsonOut = $json | ConvertTo-Json -Depth 10
      [System.IO.File]::WriteAllText((Resolve-Path $filePath).Path, $jsonOut, [System.Text.Encoding]::UTF8)
      $totalFixed++
      Write-Host "FIXED gameType: $fileName -> '$correctGameType'"
    }
  }
}

Write-Host ""
Write-Host "Total files with gameType fixed: $totalFixed"
