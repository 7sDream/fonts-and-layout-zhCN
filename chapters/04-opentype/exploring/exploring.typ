#import "/template/template.typ": web-page-template
#import "/template/components.typ": note

#import "/lib/glossary.typ": tr

#show: web-page-template

// ## Exploring OpenType with `ttx`
== 借助 `ttx` 探索 OpenType 字体

// To begin investigating how OpenType works, I started by creating a completely empty font in Glyphs, turned off exporting all glyphs apart from the letter "A" - which has no paths - and exported it as an OpenType file. Now let's prod at it with `ttx`.
在开始研究OpenType的工作原理之前，我使用 Glyphs 软件制作了一个完全空白的OpenType字体文件，它除了一个空白的A之外不包含任何其他#tr[glyph]。我们就把它作为`ttx`工具的第一个目标。

// First, let's list what tables we have present in the font:
首先，我们列出这个字体中的所有数据表：

```bash
$ ttx -l TTXTest-Regular.otf
Listing table info for "TTXTest-Regular.otf":
    tag     checksum   length   offset
    ----  ----------  -------  -------
    CFF   0x187D42BC      292     1088
    GSUB  0x00010000       10     1380
    OS/2  0x683D6751       96      280
    cmap  0x00140127       72      984
    head  0x091C432A       54      180
    hhea  0x05E10189       36      244
    hmtx  0x044C005D        8      236
    maxp  0x00025000        6      172
    name  0x6BFD9C8F      606      376
    post  0xFFB80032       32     1056
```

// All apart from the first two tables in our file are required in every TrueType and OpenType font. Here is what these tables are for:
除了最上面的两个之外，其他所有数据表对于所有TrueType和OpenType字体来说都是必须的。这些数据表的作用如下：

#align(center, table(
  columns: 2,
  align: left,
  [`OS/2`], [
    // glyph metrics used historically by OS/2 and Windows platforms
    因为历史原因，OS/2和Windows平台使用此表中的#tr[glyph]#tr[metrics]
  ],
  [`cmap`], [
    // mapping between characters and glyphs
    #tr[character]到#tr[glyph]的映射表
  ],
  [`head`], [
    // basic font metadata
    字体的基础元数据
  ],
  [`hhea`], [
    // basic information for horizontal typesetting
    用于水平#tr[typeset]的基础信息
  ],
  [`hmtx`], [
    // horizontal metrics (width and left sidebearing) of each character
    每个#tr[character]的水平#tr[metrics]（比如宽度和左#tr[sidebearing]）
  ],
  [`maxp`], [
    // information used by for the font processor when loading the font
    字体处理器加载这个字体时的所需信息
  ],
  [`name`], [
    // a table of "names" - textual descriptions and information about the font
    名称表，储存了关于这个字体的各种文本描述信息
  ],
  [`post`], [
    // information used when downloading fonts to PostScript printers
    当字体加载到PostScript打印机上时使用的信息
  ]
))

// OpenType fonts have two distinct ways of representing glyph outline data: PostScript strings and TrueType outlines. In general, PostScript strings are used, but TrueType is also an option. (You will see a lot of this dual nature of OpenType throughout the chapter, based on the dual heritage of OpenType fonts.)
OpenType 字体支持使用两种不同的方式来表达#tr[glyph]#tr[outline]数据，分别是PostScript表示法和TrueType表示法，其中PostScript表示法更加常用。（你会在后文中看到，由于OpenType同时继承了两种古老的技术遗产，所以存在大量的这种双标准共存现象。）

//So the first table, `CFF`, is required if the outlines of the font are represented as PostScript CFF strings; a font using TrueType outlines will have a different set of tables instead (`cvt`, `fpgm`, `glyf`, `loca` and `prep`, which we will look at later).
`ttx`工具列出的第一个数据表`CFF`在使用PostScript表示法时是必须的，它使用PostScript CFF 字符串来储存#tr[outline]信息。如果使用的是TrueType表示法，则会有一系列其他的数据表（具体来说有`cvt`、`fpgm`、`glyf`、`loca`和`prep`，后文会进行介绍）。

// The second table in our list, `GSUB`, is one of the more exciting ones; it's the *glyph substitution* table which, together with `GPOS` (*glyph positioning*), stores most of the OpenType smarts. We will discuss these two tables and what they can do in the next chapter.
第二个数据表叫做`GSUB`，它是这些表中比较有趣的一个。它的全称是#tr[glyph]#tr[substitution]（glyph substitution）表，和另一个#tr[glyph]#tr[positioning]（glyph positioning）表一起完成了OpenType的绝大多数智能特性。这两个表我们会单独在下一章中介绍。

// So those are the tables in our completely empty font. Now let us examine those tables by turning the whole font into an XML document:
这就是我们自制的空白字体里的所有数据表了。现在我们将其转化为XML文档：

```bash
$ ttx TTXTest-Regular.otf
Dumping "TTXTest-Regular.otf" to "TTXTest-Regular.ttx"...
Dumping 'GlyphOrder' table...
Dumping 'head' table...
Dumping 'hhea' table...
Dumping 'maxp' table...
Dumping 'OS/2' table...
Dumping 'name' table...
Dumping 'cmap' table...
Dumping 'post' table...
Dumping 'CFF ' table...
Dumping 'GSUB' table...
Dumping 'hmtx' table...
```

// This produces a `ttx` file, which is the XML representation of the font, containing the tables mentioned above. But first, notice we have a new table, which did not appear in our list - `GlyphOrder`. This is not actually part of the font; it's an artefact of TTX, but it's pretty helpful. It tells us the mapping that TTX has used between the Glyph IDs in the font and some human readable names. Looking at the file we see the table as follows:
这个命令生成了一个后缀为`ttx`的文件，他就是整个字体的XML形式，上述所有数据表的信息都包含在内。但首先我们发现这里出现了一个我们没见过的数据表，`GlyphOrder`。这个表并不是字体文件的内容，它是由`ttx`生成的。但它很有用，它能告诉我们字体中每个#tr[glyph]的人类可读名称对应的ID是多少。文件中这个表的内容如下：

```xml
<GlyphOrder>
  <!-- id 属性仅供人类阅读使用，当程序解析时将被忽略 -->
  <GlyphID id="0" name=".notdef"/>
  <GlyphID id="1" name="A"/>
</GlyphOrder>
```

#let line-height-image = f => context {
  let line-height = measure([X]).height
  box(height: line-height)[#image(f)]
}

// Here we see our exported glyph `A`, and the special glyph `.notdef` which is used when the font is called upon to display a glyph that is not present. The Glyphs software provides us with a default `.notdef` which looks like this: ![notdef](opentype/notdef.png)
这里我们看到#tr[glyph]`A`被导出了，除此之外还有一个特殊的#tr[glyph]`.notdef`。这个特殊#tr[glyph]会在字体里没有某个#tr[glyph]时使用。Glyphs 软件为我们提供了一个默认的 `.notdef` #tr[glyph]，显示出来会是这样：#text(font: ("TTX Test", ))[?]

// The `post` and `maxp` tables are essentially *aides memoire* for the computer; they are a compilation of values automatically computed from other parts of the font, so we will skip over them. The `GSUB` table in our font is empty, so we will not deal with it here, but will return to it when we consider OpenType features.
`post`和`maxp`表在计算机上没什么作用，它们基本上只是根据字体的其他部分计算出来的一堆数值，这里略过不介绍。我们字体的`GSUB`表是空的，所以也没有什么能讲解的，但后面介绍OpenType特性时我们会再用到它。
