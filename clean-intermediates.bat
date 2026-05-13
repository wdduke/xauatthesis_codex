@echo off
setlocal
pushd "%~dp0"

echo Cleaning LaTeX intermediate files...

for /r %%F in (
  *.aux
  *.bcf
  *.blg
  *.fdb_latexmk
  *.fls
  *.log
  *.out
  *.run.xml
  *.synctex.gz
  *.toc
  *.xdv
) do (
  if exist "%%F" del /q "%%F"
)

echo Done.
popd
endlocal
