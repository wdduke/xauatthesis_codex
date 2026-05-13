param(
  [switch]$UpdateBaseline,
  [int]$Resolution = 144
)

$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $PSScriptRoot
$WorkDir = Join-Path $Root "build-visual-frontmatter"
$CurrentDir = Join-Path $WorkDir "current"
$BaselineDir = Join-Path $Root "tests\visual-baseline\frontmatter"
$GeneratedSource = Join-Path $WorkDir "generated-frontmatter.tex"

New-Item -ItemType Directory -Force -Path $WorkDir | Out-Null
New-Item -ItemType Directory -Force -Path $CurrentDir | Out-Null
New-Item -ItemType Directory -Force -Path $BaselineDir | Out-Null

$GeneratedTex = @'
\documentclass[
  degree=doctor,
  degree-type=academic,
  media=electronic,
  review=normal,
  advisor-mode=team,
  discipline-type=science
]{xauatthesis}

\input{metadata}

\begin{document}
\makecover
\makeatletter
\xauat@makeadvisorteam@normal
\xauat@makecommittee@normal
\xauat@makecopyright@normal
\makeatother
\end{document}
'@

Set-Content -Path $GeneratedSource -Value $GeneratedTex -Encoding UTF8

$Cases = @(
  @{
    Name = "main-output"
    Source = "thesis.tex"
    Pdf = "thesis.pdf"
    Pages = 5
  },
  @{
    Name = "generated-frontmatter"
    Source = "build-visual-frontmatter/generated-frontmatter.tex"
    Pdf = "generated-frontmatter.pdf"
    Pages = 5
  }
)

$Failures = @()

foreach ($Case in $Cases) {
  $CaseName = $Case.Name
  $BuildDir = Join-Path $WorkDir $CaseName
  $CaseCurrentDir = Join-Path $CurrentDir $CaseName
  $CaseBaselineDir = Join-Path $BaselineDir $CaseName

  New-Item -ItemType Directory -Force -Path $BuildDir | Out-Null
  if (Test-Path $CaseCurrentDir) {
    Remove-Item -Force -Recurse -Path $CaseCurrentDir
  }
  New-Item -ItemType Directory -Force -Path $CaseCurrentDir | Out-Null

  Write-Host "==> Compile $CaseName"
  Push-Location $Root
  try {
    $RunOutput = Join-Path $BuildDir "xelatex.out"
    & xelatex -interaction=nonstopmode -halt-on-error -output-directory="$BuildDir" $Case.Source > $RunOutput 2>&1
    if ($LASTEXITCODE -ne 0) {
      $Failures += "${CaseName}: xelatex exited with code $LASTEXITCODE"
      Get-Content -Path $RunOutput -Tail 40 | ForEach-Object { Write-Host $_ }
      continue
    }
  }
  finally {
    Pop-Location
  }

  $PdfPath = Join-Path $BuildDir $Case.Pdf
  if (-not (Test-Path $PdfPath)) {
    $Failures += "${CaseName}: missing PDF $PdfPath"
    continue
  }

  Write-Host "==> Render $CaseName"
  $Prefix = Join-Path $CaseCurrentDir $CaseName
  & pdftoppm -png -r $Resolution -f 1 -l $Case.Pages $PdfPath $Prefix
  if ($LASTEXITCODE -ne 0) {
    $Failures += "${CaseName}: pdftoppm exited with code $LASTEXITCODE"
    continue
  }

  if ($UpdateBaseline) {
    if (Test-Path $CaseBaselineDir) {
      Remove-Item -Force -Recurse -Path $CaseBaselineDir
    }
    New-Item -ItemType Directory -Force -Path $CaseBaselineDir | Out-Null
    Copy-Item -Path (Join-Path $CaseCurrentDir "*.png") -Destination $CaseBaselineDir
    continue
  }

  if (-not (Test-Path $CaseBaselineDir)) {
    $Failures += "${CaseName}: missing baseline, run scripts\check-frontmatter-visual.ps1 -UpdateBaseline first"
    continue
  }

  $CurrentFiles = Get-ChildItem -Path $CaseCurrentDir -Filter "*.png" | Sort-Object Name
  $BaselineFiles = Get-ChildItem -Path $CaseBaselineDir -Filter "*.png" | Sort-Object Name

  if ($CurrentFiles.Count -ne $BaselineFiles.Count) {
    $Failures += "${CaseName}: current image count $($CurrentFiles.Count) differs from baseline $($BaselineFiles.Count)"
    continue
  }

  for ($Index = 0; $Index -lt $CurrentFiles.Count; $Index++) {
    if ($CurrentFiles[$Index].Name -ne $BaselineFiles[$Index].Name) {
      $Failures += "${CaseName}: image name differs, current $($CurrentFiles[$Index].Name), baseline $($BaselineFiles[$Index].Name)"
      continue
    }

    $CurrentHash = (Get-FileHash -Algorithm SHA256 -Path $CurrentFiles[$Index].FullName).Hash
    $BaselineHash = (Get-FileHash -Algorithm SHA256 -Path $BaselineFiles[$Index].FullName).Hash
    if ($CurrentHash -ne $BaselineHash) {
      $Failures += "${CaseName}: visual snapshot changed at $($CurrentFiles[$Index].Name)"
    }
  }
}

$Manifest = [ordered]@{
  resolution = $Resolution
  cases = $Cases | ForEach-Object {
    [ordered]@{
      name = $_.Name
      pages = $_.Pages
    }
  }
}

$Manifest | ConvertTo-Json -Depth 4 | Set-Content -Path (Join-Path $CurrentDir "manifest.json") -Encoding UTF8
if ($UpdateBaseline) {
  $Manifest | ConvertTo-Json -Depth 4 | Set-Content -Path (Join-Path $BaselineDir "manifest.json") -Encoding UTF8
}

Write-Host ""
Write-Host "Frontmatter visual regression summary"
Write-Host "-------------------------------------"
if ($UpdateBaseline) {
  Write-Host "Baseline updated in tests\visual-baseline\frontmatter."
}

if ($Failures.Count -gt 0) {
  Write-Host "Failures:"
  $Failures | ForEach-Object { Write-Host "  - $_" }
  exit 1
}

Write-Host "Failures: none"
Write-Host "Current snapshots: build-visual-frontmatter\current"
