#import "/template/template.typ": web-page-template
#import "/template/components.typ": note

#import "/lib/glossary.typ": tr

#show: web-page-template

// ## What is a font?
== 字体是什么？

// From a computer's perspective, a font is a database. It's a related collection of *tables* - lists of information. Some of the information is global, in the sense that it refers to the font as a whole, and some of the information refers to individual glyphs within the font. A simplified schematic representation of a font file would look like this:
从计算机的视角来看，字体就是一个由一系列互相关联的*数据表*组成的数据库。这些数据表中分别储存着各种各样的信息。其中有些信息是全局性的，也就是负责描述这个字体的整体情况；另外一些信息则可能是关于字体中的某个特定#tr[glyph]的。字体内部组织结构的简化版示意图如下：

#figure(
  placement: none,
  caption: [字体内部的组织结构],
  kind: image,
)[#include "schemtic.typ"]


// In other words, most of the information in a font is not the little black shapes that you look at; they're *easy*. The computer is much more concerned with details about how the font is formatted, the glyphs that it supports, the heights, widths and sidebearings of those glyphs, how to lay them out relative to other glyphs, and what clever things in terms of kerns, ligatures and so on need to be applied. Each of these pieces of information is stored inside a table, which is laid out in a binary (non-human-readable) representation inside your OTF file.
换句话说，字体中除了用于显示的那些黑色图形之外还有大量其他信息。图形#tr[outline]信息处理起来其实非常简单，计算机其实更关心那些控制这些图形如何正确显示的其他信息。比如，字体支持哪些#tr[glyph]，它们有多高，多宽，左右#tr[sidebearing]是多少，在显示多个#tr[glyph]时应该如何关联它们，在#tr[kern]方面需要有哪些智能处理，#tr[ligature]和其他高级特性应该如何应用等等。所有这些零碎信息都储存在数据表中，最终被组织为一个（人类不可读的）二进制格式，也就是你看到的 OTF 文件。
