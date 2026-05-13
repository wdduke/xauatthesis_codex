# xauatthesis 阶段说明

本目录是新的学位论文模板实践工程，不直接修改旧模板。

## 目录约定

用户入口保留在模板根目录：

- `thesis.tex`
- `metadata.tex`
- `xauatthesis.cls`
- `data/`
- `ref/`
- `examples/`

核心实现集中放在 `src/`：

- `src/xauatthesis-core.cls`
- `src/xauatthesis.cfg`
- `src/xauatthesis-packages.sty`
- `src/xauatthesis-debug.sty`
- `src/xauatthesis-fonts.cfg`
- `src/xauatthesis-layout.sty`
- `src/xauatthesis-frontmatter.sty`
- `src/xauatthesis-blind.sty`
- `src/xauatthesis-writing.sty`
- `src/xauatthesis-bib.sty`
- `src/xauatthesis-backmatter.sty`

根目录的 `xauatthesis.cls` 只是一个很薄的入口壳，负责把 `src/` 加入 LaTeX 输入路径并加载 `src/xauatthesis-core.cls`。这样主文档可以直接写：

```tex
\documentclass{xauatthesis}
```

主文档不再需要手动声明：

```tex
\def\input@path{{src/}{...}}
```

因此不会出现 `requested document class 'src/xauatthesis'` 这类路径警告。

## 第二阶段已接入的写作功能

当前第二阶段已经开始把模板从“可编译骨架”扩展为“可写论文模板”：

- 统一无编号章节入口，用于摘要、声明、目录、主要符号表、参考文献、致谢等页面。
- 图、表、子图、公式基础格式集中在 `src/xauatthesis-writing.sty`。
- 公式按章编号，当前形式为 `(1-1)`。
- 表格支持 `booktabs` 三线表和 `\xauattablenote{...}` 表注。
- 主要符号表可使用 `xauatdenotation` 环境。
- 参考文献优先使用 `biblatex-gb7714-2015`，后端为 `biber`；缺少该样式时回退到 `biblatex` 数字制。
- 盲审模式下，成果和致谢示例默认隐藏，并在日志中给出提示。

第二阶段新增文档类选项：

```tex
bib-style = auto | numeric | authoryear
blind-achievements = hide | anonymous | show
blind-acknowledgement = hide | placeholder | show
```

其中 `bib-style=auto` 会根据 `discipline-type` 选择参考文献样式：自然科学类使用数字制，人文社科类使用著者-出版年制。

成果和致谢内容建议只写在环境中，由模板决定是否输出：

```tex
\begin{xauatachievements}
  \begin{enumerate}
    \item 作者. 成果题名. 刊物，年份.
  \end{enumerate}
\end{xauatachievements}

\begin{xauatacknowledgement}
  致谢正文。
\end{xauatacknowledgement}
```

参考文献库需要在主文档中显式声明：

```tex
\XAUATaddbibresource{ref/refs.bib}
```

示例目录中使用相对路径：

```tex
\XAUATaddbibresource{../../ref/refs.bib}
```

## 前置部分入口

模板推荐把前置部分拆成独立命令调用，避免一个总命令同时控制封面、委员会页、声明页、摘要和目录：

```tex
\begin{document}

% 内封：中文内封、英文内封
\makecover

% 指导教师团队页：仅 advisor-mode=team 且非盲审时输出
\makeadvisorteampage

% 答辩委员会页：非盲审、非涉密时输出
\makecommitteepage

% 版权声明页
\makecopyrightpage

% 摘要、目录等前置正文阶段
\frontmatter
\input{data/abstract-cn}
\input{data/abstract-en}
\tableofcontents
\input{data/denotation}

% 正文阶段
\mainmatter
\input{data/chap01}
\input{data/chap02}
\printXAUATbibliography

\appendix
\input{data/appendix}

\backmatter
\input{data/resume}
\end{document}
```

其中 `\frontmatter` 只负责进入摘要、目录阶段，设置罗马页码和前置页眉；它不再生成封面或其他功能页。

需要使用签字扫描件时，可将签字扫描 PDF 放在 `assets/scan/` 目录下。以下文件存在时，模板会自动用扫描件替换对应页面；文件不存在时，仍正常生成 LaTeX 页面：

```tex
\makeadvisorteampage   % 自动检查 assets/scan/scan-advisor-team.pdf
\makecopyrightpage     % 自动检查 assets/scan/scan-copyright.pdf
```

`assets/scan/print-advisor-team.pdf` 和 `assets/scan/print-copyright.pdf` 是无水印打印页，方便打印签字；`scan-*.pdf` 是带 `scanned` 水印的占位扫描件，正式使用时用真实扫描件替换同名文件即可。生成这些 PDF 的独立源文件保存在 `scripts/scan-pages/`，避免资源目录混入代码文件。也可以继续用 `file=...` 显式指定任意扫描件路径：

```tex
\makeadvisorteampage[file=path/to/scan-advisor-team.pdf]
\makecommitteepage[file=path/to/scan-committee.pdf]
\makecopyrightpage[file=path/to/scan-copyright.pdf]
```

`\maketitle` 兼容为 `\makecover`；`\makefrontmatter` 仍保留为旧文档兼容入口，但新文档建议使用上面的独立命令序列。

## 维护调试

通用包集中在 `src/xauatthesis-packages.sty` 中管理；各功能模块原则上只保留本模块的排版逻辑和命令定义。

签字页占位 PDF 可用下面的批处理重新生成：

```bat
scripts\build-scan-pages.bat
```

前置页视觉回归测试会编译主文档实际前置输出，并额外编译一份不走扫描件替换的源生前置页，用于检查封面、指导教师团队页、答辩委员会页和声明页的版式快照。首次建立或主动刷新基线：

```powershell
powershell -ExecutionPolicy Bypass -File scripts\check-frontmatter-visual.ps1 -UpdateBaseline
```

之后检查当前输出是否和基线一致：

```powershell
powershell -ExecutionPolicy Bypass -File scripts\check-frontmatter-visual.ps1
```

模板保留隐藏的页面调试入口，不通过文档类选项暴露给普通使用者。维护者需要查看版心、页眉页脚或页面网格时，可以在主文档同级目录临时创建 `xauatthesis-debug.cfg`：

```tex
\xauatdebugshowframe
\xauatdebuggrid
\xauatdebuglogobox
```

其中 `\xauatdebugshowframe` 使用 `showframe` 显示版心和页眉页脚参考线，`\xauatdebuggrid` 在页面背景叠加 1 cm 辅助网格，`\xauatdebuglogobox` 在中文内封校名 logo 外叠加红色边界框。调试完成后删除该本地配置文件即可恢复正式输出。

## 字体策略

字体配置集中在 `src/xauatthesis-fonts.cfg`。模板借鉴清华大学学位论文模板的思路：`ctexbook`
使用 `fontset=none`，由模板自己接管中文、西文和数学字体配置。

默认配置会自动选择：

- Windows 或带 Windows 字体的平台：中文使用 `SimSun`、`SimHei`、`KaiTi`、`FangSong`，西文使用 `Times New Roman`。
- macOS：中文使用 `Songti SC`、`Heiti SC`、`Kaiti SC`、`STFangsong`，西文优先 `Times New Roman`。
- Linux / 在线 TeX Live：优先 `Noto Serif CJK SC`，否则回退到 TeX Live 自带的 `Fandol` 字体族；西文使用 `TeX Gyre Termes`。
- 数学字体：默认优先 `XITS Math`，然后回退到 `STIX Two Math`、`Libertinus Math`、`Latin Modern Math`。

也可以在文档类选项中手动指定字体方案：

```tex
\documentclass[
  fontset=windows,       % auto | windows | mac | noto | fandol | none
  font=times,            % auto | times | termes | none
  cjk-font=windows,      % auto | windows | windows-local | mac | noto | fandol | none
  math-font=xits,        % auto | xits | stix | libertinus | lm | none
  math-style=GB          % GB | ISO | TeX
]{xauatthesis}
```

如果系统字体不能通过字体名找到，但可以直接访问 Windows 字体目录，可以使用：

```tex
\documentclass[
  cjk-font=windows-local,
  windows-font-dir={C:/Windows/Fonts}
]{xauatthesis}
```

`ctexbook` 使用 `fontset=none`，因此中文字体族命令也由该配置文件补齐：

```tex
\songti
\heiti
\kaishu
\fangsong
```

## 编译

主文档：

```powershell
xelatex -interaction=nonstopmode -halt-on-error -output-directory=build thesis.tex
biber build\thesis
xelatex -interaction=nonstopmode -halt-on-error -output-directory=build thesis.tex
xelatex -interaction=nonstopmode -halt-on-error -output-directory=build thesis.tex
```

四个示例分别位于：

- `examples/electronic-normal/`
- `examples/electronic-blind/`
- `examples/print-normal/`
- `examples/print-blind/`
- `examples/humanities-normal/`

每个示例可以在自身目录下执行：

```powershell
latexmk -xelatex -interaction=nonstopmode -halt-on-error -outdir=build thesis.tex
```

第一阶段示例矩阵可以在模板根目录执行一次性检查：

```powershell
powershell -ExecutionPolicy Bypass -File scripts/check-phase1.ps1
```

该脚本会依次编译电子版、打印版、盲审版和人文社科参考文献样式示例，并检查日志中的致命错误和关键表格警告。
