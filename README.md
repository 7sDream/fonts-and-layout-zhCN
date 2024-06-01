# 全球文种的字体与布局

## 介绍

本书是 Simon Cozens 的关于字体设计、Unicode和计算机中复杂文本处理的免费书籍《[Fonts and Layout for Global Scripts](https://simoncozens.github.io/fonts-and-layout/)》的中文翻译版。

因为本书的主题是字体，为了保证显示效果和想表达的内容一致和满足我个人打印出来阅读的需求，选择 PDF 作为发布格式。

请从 GitHub Release 中下载最新版 PDF。

## 反馈与共建

本项目使用[Typst](https://github.com/typst/typst)作为排版工具。

各章节内容在 `chapters` 文件夹中，正文内容（除各类图示外）基本均为类似 Markdown 的纯文本，即使没有使用过也非常容易看懂。

所以如果发现明显翻译问题或笔误，鼓励直接提交 PR，并通过 CI 生成的文件检查修复结果。

版式调整与字体更换（涉及`/template`）、术语翻译（涉及`/lib/glossary.typ`）等影响较大的修改等请在 PR 前先开 Issue 讨论。

原文更新导致翻译需要更新时，请同时修改 `/template/consts.typ` 中的 `upstream-version`。

## 本地编译

先下载字体包并解压，假设最终路径为 `/path/to/fonts`。

```bash
cd fonts-and-layout-zhCN
typst --font-path "/path/to/fonts" --font-path "./fonts" book.typ
```

## 参考资料

- 《FontForge 与字体设计》一书中的[词汇表](http://designwithfontforge.com/zh-CN/Glossary.html)
- 知乎专栏文章《[Unicode®标准英文术语翻译对照表及部分术语汇释](https://zhuanlan.zhihu.com/p/79246427)》
- [Unicode 术语英中对照表](https://www.unicode.org/terminology/term_en_zh_Hans_CN.html)
- <https://symbl.cc/>
- Adobe OpenType 特性语言的语法高亮文件是从 [language-fontforge](https://github.com/Alhadis/language-fontforge) 项目转换而来，经过少量修改。

## LICENSE

许可证原书一致，为[CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/deed.zh-hans)。

细节请参考 LICENSE 文件（或原项目README），其中有原作者对演绎版本的一些要求。
