# 全球文种的字体与布局

## 介绍

本书是 Simon Cozens 编写的《[Fonts and Layout for Global Scripts][origin-book]》的中文翻译版，是一本关于字体设计、Unicode和计算机中复杂文本处理的免费书籍。

因为本书的主题是字体，为了保证显示效果和想表达的内容一致和满足我个人打印出来阅读的需求，没有沿用原书的 Markdown 格式。

本项目使用 [Typst] 作为排版系统，借助 [typst-book] 生成在线阅读版本。

## 阅读

### 在线

访问 [Github Pages] 即可在线阅读，点击左上角的笔刷图标进行主题切换。

请注意，由于技术方案的特性，可能在某些设备/情况下不太稳定。如果在阅读时遇到任何问题，请[提交 Issue][new-issue] 或选择下载PDF。

如果不出意外，在线版本永远是最新的。

### 离线

编译出的PDF文件可从以下两处下载：

1. [GitHub Release]
2. [CI][github-action-ci] 中的 Artifacts

其中 Release 中的不一定是最新版，但永久有效，会在有改动时每周六发布一次。
CI 中会有最新版但文件可能过期，如果过期可开 Issue 告知。

## 反馈与共建

各章节内容在 `chapters` 文件夹中，正文内容（除各类图示外）基本均为类似 Markdown 的纯文本，即使没有使用过 Typst 也非常容易看懂。

所以如果发现明显翻译问题或笔误，鼓励直接提交 PR，并通过 CI 生成的文件检查修复结果。

版式调整与字体更换（涉及`/template`）、术语翻译（涉及`/lib/glossary.typ`）等影响较大的修改等请在 PR 前先开 Issue 讨论。

原文更新导致翻译需要更新时，请同时修改 `/template/consts.typ` 中的 `upstream-version`。

## 本地编译

(本节内容可能需要您有一些技术方面的基础知识，以及对 Typst 和相关生态的了解，如果只是普通读者可以跳过)

整体流程可以参考 [CI workflow 文件][action-build-yaml]，或按照以下文字描述操作。

### 网页

安装 [typst-book] 0.1.5。

下载[字体包][extra-font-release]，并将其解压到 `fonts/extra` 文件夹（没有就建一下）中。

使用下列命令编译：

```bash
typst-book serve --font-path fonts
```

注意，编译时间比较久。编译成功后会启动 HTTP Server 并输出应该访问的 URL。

如果只想编译，`serve` 换成 `build`。

### PDF

PDF 需要网页版编译成功作为前置，请先确定能够正常在本地编译出网页版。

然后安装 [Typst] 0.11.1。

```bash
typst --font-path fonts --input realpdf=1 --input theme=light pdf.typ
```

和网页版一样支持主题选择，可选 `[ light, rust, coal, navy, ayu ]`。

### 所见即所得

如果想所见即所得的编辑，推荐使用 VSCode 配合 [Tinymist] 和 [Typst Preview][typst-preview] 插件。

`.vscode/setting.json` 中已经包含了所需的配置，直接从 `pdf.typ` 文件启动 `typst-preview` 即可，这时预览的是 PDF 的效果。

如果你想查看网页版的效果，可以将 `.vscode/setting.json` 中的两处 `realpdf=1` 参数删去，然后从各章节文件启动单页预览。

## 参考资料

- 《FontForge 与字体设计》一书中的[术语表][fontforge-glossary]
- 知乎专栏文章《[Unicode®标准英文术语翻译对照表及部分术语汇释][unicode-glossary]》
- [Unicode 术语英中对照表][unicode-terminology]
- [symbl.cc]
- Adobe OpenType 特性语言的语法高亮文件是从 [language-fontforge] 项目转换而来，经过少量修改。
- 黑暗模式的语法高亮方案为 [tokyo night][theme-tokyo-night]，tmTheme 颜色配置来自 [typst-book] 的储存库。

## LICENSE

许可证原书一致，为 [CC BY-SA 4.0]。

细节请参考 LICENSE 文件（或原项目 README），其中有原作者对演绎版本的一些要求。

[origin-book]: https://simoncozens.github.io/fonts-and-layout/
[Typst]: https://github.com/typst/typst
[typst-book]: https://github.com/Myriad-Dreamin/typst-book
[Github Pages]: https://7sdream.github.io/fonts-and-layout-zhCN/
[new-issue]: https://github.com/7sDream/fonts-and-layout-zhCN/issues/new
[Github Release]: https://github.com/7sDream/fonts-and-layout-zhCN/releases/latest
[github-action-ci]: https://github.com/7sDream/fonts-and-layout-zhCN/actions/workflows/ci.yaml
[action-build-yaml]: https://github.com/7sDream/fonts-and-layout-zhCN/blob/master/.github/workflows/action-build.yaml
[extra-font-release]: https://github.com/7sDream/fonts-and-layout-zhCN/releases/tag/extra-fonts%2F20240615
[Tinymist]: https://github.com/Myriad-Dreamin/tinymist
[typst-preview]: https://github.com/Enter-tainer/typst-preview

[fontforge-glossary]: http://designwithfontforge.com/zh-CN/Glossary.html
[unicode-glossary]: https://zhuanlan.zhihu.com/p/79246427
[unicode-terminology]: https://www.unicode.org/terminology/term_en_zh_Hans_CN.html
[symbl.cc]: https://symbl.cc/
[language-fontforge]: https://github.com/Alhadis/language-fontforge
[theme-tokyo-night]: https://github.com/enkia/tokyo-night-vscode-theme

[CC BY-SA 4.0]: https://creativecommons.org/licenses/by-sa/4.0/deed.zh-hans
