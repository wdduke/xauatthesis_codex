\NeedsTeXFormat{LaTeX2e}[2022/06/01]
\ProvidesClass{xauatthesis}
  [2026/05/06 v0.1 XAUAT thesis template entry]

\makeatletter
\ifx\input@path\@undefined
  \def\input@path{{src/}}
\else
  \edef\input@path{{src/}\input@path}
\fi
\makeatother

\InputIfFileExists{xauatthesis-core.cls}
  {}
  {
    \ClassError{xauatthesis}
      {Cannot find src/xauatthesis-core.cls}
      {Keep xauatthesis.cls in the template root and core files in src/.}
  }

\endinput
