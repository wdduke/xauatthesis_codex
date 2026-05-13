$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $PSScriptRoot
$Examples = @(
  "examples/electronic-normal",
  "examples/electronic-blind",
  "examples/print-normal",
  "examples/print-blind",
  "examples/humanities-normal"
)

$OutputDir = "build-phase1-check"
$FatalPatterns = @(
  "LaTeX Error:",
  "Emergency stop",
  "Fatal error occurred",
  "I can't write on file"
)
$WarningPatterns = @(
  "Table width is too small",
  "Overfull \\hbox"
)

$Failures = @()
$Warnings = @()
$XeLaTeXArgs = @(
  "-interaction=nonstopmode",
  "-halt-on-error",
  "-output-directory",
  $OutputDir,
  "thesis.tex"
)

foreach ($Example in $Examples) {
  $ExamplePath = Join-Path $Root $Example
  $BuildPath = Join-Path $ExamplePath $OutputDir

  New-Item -ItemType Directory -Force -Path $BuildPath | Out-Null
  Write-Host "==> $Example"

  Push-Location $ExamplePath
  try {
    for ($Run = 1; $Run -le 2; $Run++) {
      $RunOutput = Join-Path $BuildPath "xelatex-run-$Run.out"
      & xelatex @XeLaTeXArgs > $RunOutput 2>&1
      if ($LASTEXITCODE -ne 0) {
        $Failures += "${Example}: xelatex run $Run exited with code $LASTEXITCODE"
        Get-Content -Path $RunOutput -Tail 40 | ForEach-Object { Write-Host $_ }
        break
      }
    }
  }
  finally {
    Pop-Location
  }

  $LogPath = Join-Path $BuildPath "thesis.log"
  if (Test-Path $LogPath) {
    foreach ($Pattern in $FatalPatterns) {
      $Matches = Select-String -Path $LogPath -Pattern $Pattern -SimpleMatch
      foreach ($Match in $Matches) {
        $Failures += "${Example}: $($Match.Line.Trim())"
      }
    }

    foreach ($Pattern in $WarningPatterns) {
      $Matches = Select-String -Path $LogPath -Pattern $Pattern -SimpleMatch
      foreach ($Match in $Matches) {
        $Warnings += "${Example}: $($Match.Line.Trim())"
      }
    }
  }
  else {
    $Failures += "${Example}: missing log file"
  }
}

Write-Host ""
Write-Host "Phase 1 example check summary"
Write-Host "-----------------------------"

if ($Warnings.Count -gt 0) {
  Write-Host "Warnings:"
  $Warnings | ForEach-Object { Write-Host "  - $_" }
}
else {
  Write-Host "Warnings: none"
}

if ($Failures.Count -gt 0) {
  Write-Host "Failures:"
  $Failures | ForEach-Object { Write-Host "  - $_" }
  exit 1
}

Write-Host "Failures: none"
Write-Host "All phase 1 examples compiled."
