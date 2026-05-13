# Signed-page scan placeholders

This folder stores stable PDF assets that are expected to be printed, signed,
scanned, and inserted back into the thesis.

Default inserted files:

- `scan-advisor-team.pdf`: inserted by `\makeadvisorteampage` when present.
- `scan-copyright.pdf`: inserted by `\makecopyrightpage` when present.

Printable clean files:

- `print-advisor-team.pdf`
- `print-copyright.pdf`

The `scan-*.pdf` files in this repository are generated placeholders with a
`scanned` watermark. After signing and scanning the clean print pages, replace
the corresponding `scan-*.pdf` files with the real scans.

The standalone generators live in `scripts/scan-pages/`, keeping this assets
folder limited to reusable PDF resources and documentation.
