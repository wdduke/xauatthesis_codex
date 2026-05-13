$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $PSScriptRoot
$Extensions = @(".cls", ".cfg", ".sty", ".tex")
$SkipDirectories = @(
  ".git",
  "build",
  "build-check",
  "build-check-debug",
  "build-check-all2",
  "build-check-team",
  "build-anchor-single",
  "build-anchor-associate",
  "build-anchor-team"
)
$CjkFamilyPattern = "\\(songti|heiti|kaishu|fangsong)"
$LatinFamilyPattern = "\\(rmfamily|sffamily|ttfamily)"
$Violations = @()

$Files = Get-ChildItem -Path $Root -Recurse -File | Where-Object {
  $Extensions -contains $_.Extension
}

foreach ($File in $Files) {
  $RelativePath = $File.FullName.Substring($Root.Length).TrimStart("\", "/")
  $PathParts = $RelativePath -split "[\\/]"
  if (($PathParts | Where-Object { $SkipDirectories -contains $_ }).Count -gt 0) {
    continue
  }

  $Lines = Get-Content -Path $File.FullName -Encoding UTF8
  for ($Index = 0; $Index -lt $Lines.Count; $Index++) {
    $Line = $Lines[$Index]
    $CjkMatches = [regex]::Matches($Line, $CjkFamilyPattern)
    $LatinMatches = [regex]::Matches($Line, $LatinFamilyPattern)
    if ($CjkMatches.Count -eq 0 -or $LatinMatches.Count -eq 0) {
      continue
    }

    foreach ($CjkMatch in $CjkMatches) {
      foreach ($LatinMatch in $LatinMatches) {
        if ($LatinMatch.Index -gt $CjkMatch.Index) {
          $Violations += "{0}:{1}: Latin family command appears after CJK family command: {2}" -f `
            $RelativePath, ($Index + 1), $Line.Trim()
          break
        }
      }
    }
  }
}

if ($Violations.Count -gt 0) {
  Write-Host "Font command ordering violations:"
  $Violations | ForEach-Object { Write-Host "  - $_" }
  Write-Host ""
  Write-Host "Use Latin family first, then CJK family, for example: \rmfamily\heiti."
  exit 1
}

Write-Host "Font command ordering check passed."
