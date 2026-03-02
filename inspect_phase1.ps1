$files = @(
  "assets/curriculum/kids/kids_colors_s4.json",
  "assets/curriculum/kids/kids_shapes_s1.json",
  "assets/curriculum/kids/kids_shapes_s7.json"
)

$out = ""
foreach ($file in $files) {
  $json = Get-Content $file -Raw | ConvertFrom-Json
  $groups = $json.quests | Group-Object -Property level
  foreach ($g in $groups) {
    if ($g.Count -ne 3) {
      $out += "FILE: $file | Level $($g.Name) | $($g.Count) quests`n"
      foreach ($q in $g.Group) {
        $out += "  id=$($q.id) | q=$($q.question) | ans=$($q.correctAnswer)`n"
      }
    }
  }
}
$out | Out-File -FilePath "phase1_inspect.txt" -Encoding utf8
Write-Host "Done"
