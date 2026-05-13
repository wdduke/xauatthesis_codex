# Frontmatter visual baseline

This directory stores PNG baselines for the frontmatter visual regression check.

Create or refresh the baseline after intentional layout changes:

```powershell
powershell -ExecutionPolicy Bypass -File scripts\check-frontmatter-visual.ps1 -UpdateBaseline
```

Check current output against the baseline:

```powershell
powershell -ExecutionPolicy Bypass -File scripts\check-frontmatter-visual.ps1
```

The current snapshots are written to `build-visual-frontmatter\current`.
