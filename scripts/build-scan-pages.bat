@echo off
setlocal

set "ROOT=%~dp0.."
set "SOURCE_DIR=%ROOT%\scripts\scan-pages"
set "OUTPUT_DIR=%ROOT%\assets\scan"

if not exist "%OUTPUT_DIR%" mkdir "%OUTPUT_DIR%"

pushd "%SOURCE_DIR%"
if errorlevel 1 exit /b 1

for %%F in (
  print-advisor-team.tex
  print-copyright.tex
  scan-advisor-team.tex
  scan-copyright.tex
) do (
  echo ==^> %%F
  xelatex -interaction=nonstopmode -halt-on-error -output-directory="%OUTPUT_DIR%" "%%F"
  if errorlevel 1 (
    popd
    exit /b 1
  )
)

popd

del /q "%OUTPUT_DIR%\*.aux" "%OUTPUT_DIR%\*.bcf" "%OUTPUT_DIR%\*.log" "%OUTPUT_DIR%\*.out" "%OUTPUT_DIR%\*.run.xml" "%OUTPUT_DIR%\*.synctex.gz" "%OUTPUT_DIR%\*.toc" "%OUTPUT_DIR%\*.xdv" 2>nul

echo.
echo Signed-page PDFs regenerated in assets\scan.
