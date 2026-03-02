# Check gameType values stored in each game's JSON files
$dir = "assets/curriculum/kids"
$games = @(
  "kids_alphabet","kids_numbers","kids_colors","kids_shapes",
  "kids_animals","kids_fruits","kids_family","kids_school",
  "kids_verbs","kids_emotions","kids_routine","kids_opposites",
  "kids_prepositions","kids_phonics","kids_jumble","kids_time",
  "kids_nature","kids_home","kids_food","kids_transport","kids_day_night"
)

$out = ""
foreach ($game in $games) {
  $filePath = Join-Path $dir "${game}_s1.json"
  if (-not (Test-Path $filePath)) { continue }
  $json = Get-Content $filePath -Raw -Encoding UTF8 | ConvertFrom-Json
  $firstQuest = $json.quests[0]
  $out += "$game | gameType in JSON: '$($firstQuest.gameType)' | id prefix: '$($firstQuest.id.Substring(0, [Math]::Min(15, $firstQuest.id.Length)))'`n"
}
$out | Out-File -FilePath "gametype_check.txt" -Encoding utf8
Write-Host "Done"
