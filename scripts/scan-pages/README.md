# Signed-page PDF generators

These standalone files regenerate the stable PDF assets in `assets/scan/`.

Compile from this directory, for example:

```bat
xelatex -interaction=nonstopmode -halt-on-error -output-directory=D:/Desktop/2026/codex_xauat/xauatthesis/assets/scan scan-copyright.tex
```

The generators are kept outside `assets/` so the assets directory only contains
stable resources. They intentionally compile from this directory so the local
root-level `xauatthesis-debug.cfg` is not loaded; generated PDFs should not
contain debug grids or showframe lines.
