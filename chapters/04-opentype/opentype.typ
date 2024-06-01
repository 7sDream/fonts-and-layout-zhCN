#import "/template/heading.typ": chapter
#import "/template/components.typ": note
#import "/template/lang.typ": tibetan, khmer

#import "/lib/glossary.typ": tr

#chapter[
  // How OpenType Works
  OpenType的工作原理
]

// They say that if you enjoy sausages, you shouldn't look too carefully into how they are made, and the same is true of OpenType fonts.
俗话说，如果你喜欢吃香肠，那就别关心它是怎么制作的。对于OpenType字体来说也一样。

// In this chapter we're going to look in some depth about the OpenType font format: how it actually converts the outlines, metrics and advanced typographic features of a font into a file that a computer can interpret. In an ideal world, this would be information that programmers of layout systems and font handling libraries would need, but implementation details that font designers could safely ignore.
在本章中，我们会深入OpenType字体的内部格式，了解它是如何将字体的#tr[outline]信息、#tr[metrics]信息和其他各种#tr[typography]相关的特性封装成一个计算机可读的文件的。在理想的世界中，只有开发电子排版系统或字体加载库的程序员们需要了解这方面的信息，字体设计师完全不需要懂这些。

// But we are not in an ideal world, and as we will see when we start discussing the metrics tables, the implementation details matter for font designers too - different operating systems, browsers and applications will potentially interpret the information contained within a font file in different ways leading to different layout.
但我们这个世界并不理想，所以你经常能听到字体设计师也在讨论#tr[metrics]之类的实现层面的细节。不同的操作系统、浏览器、应用程序会用不同的方式来理解和使用字体文件中的信息，也会产生不同的显示效果。

// So put on your overalls, grab your bucket, and let's take a look inside the font sausage factory.
现在穿上工作服，拿上装备，我们就要亲自深入香肠工厂好好看看了。

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

// ## FontTools and ttx
== FontTools 和 `ttx` 工具

// To crack open that OTF file and look at the tables inside, we're going to use a set of Python programs called `fonttools`. `fonttools` was originally written by Just van Rossum, but is now maintained by Cosimo Lupo and a cast of hundreds. If you don't have `fonttools` already installed, you can get hold of it by issuing the following commands at a command prompt:
为了能拆开 OTF 文件并且直接看看这些数据表，我们需要一套被称为`fontTools`的Python程序。`fontTools`最初由Just van Rossum编写，现在则由 Cosimo Lupo 和数百位贡献者一起维护。如果你还未安装 `fontTools`，可以使用如下命令来安装它：

#note[
  // > If you're a Mac user and you're not familiar with using a terminal emulator, pick up a copy of *Learning Unix for OS X* by Dave Taylor. If you're a Windows user, I'm afraid you're on your own; Windows has never made it particularly easy to operate the computer through the command prompt, and it's too painful to explain it here. If you're on Linux, you already know what you're doing.
  如果你是Mac用户，且不熟悉终端和命令行操作，可以看看Dave Taylor写的《Learn Unix for OS X》一书。如果你是Windows用户，你可能需要自行研究了。Windows的命令行功能不太易用，使用它进行系统交互会比较痛苦，我在这就不过多解释了。如果你是Linux用户的话，我相信你已经很熟悉下面的操作了。
]

```bash
easy_install pip
pip install fonttools
```

// If you have the Homebrew package manager installed, which is highly recommended for developing on Mac computers, you can get `fonttools` through Homebrew:
如果你安装了在Mac上做开发工作时推荐使用的Homebrew包管理器的话，也可以用它来获取 `fontTools`：

```bash
brew install fonttools
```

#note[
  // > Homebrew is a system which allows you to easily install and manage a number of useful free software packages on Mac OS X. You can get it from http://brew.sh/
  Homebrew 是 Mac OS X 系统上的一个用于轻松安装和管理自由软件包的工具。你可以在其官网获取它：#link("http://brew.sh/")。
]

// The core of the `fonttools` package is a library, some code which helps Python programmers to write programs for manipulating font files. But `fonttools` includes a number of programs already written using the library, and one of these is called `ttx`.
`fontTools`的核心是一个帮助Python开发者编写字体处理功能的程序库。但它同时也包含了几个用这个库编写而成的可以直接使用的程序。`ttx` 工具就是其中之一。

// As we mentioned above, an OpenType font file is a database. The database, with its various tables, is stored in a file using a format called SFNT, which stands for "spline font" or "scalable font". OpenType, TrueType, PostScript and a few other font types all use the SFNT representation to lay out their tables into a binary file. But because the SFNT representation is *binary* - that is to say, not human readable - it's not very easy for us either to investigate what's going on in the font or to make changes to it. The `ttx` utility helps us with that. It is used to turn an SFNT database into a textual representation, XML, and back again. The XML format is still designed primarily to be read by computers rather than humans, but it at least allows us to peek inside the contents of an OpenType font which would otherwise be totally opaque to us.
上面已经介绍过，OpenType字体文件其实是一个包含多个数据表的数据库。这些数据表使用 SFNT 格式储存在文件中。SFNT代表#tr[spline]字体（spline font）或可缩放字体（scalable font）。OpenType、TrueType、PostScript等字体格式都会使用SFNT来储存数据表。但SFNT是一种人类无法直接阅读的二进制格式，想了解字体内部的构造或者修改它就比较困难。`ttx`工具就是来帮我们处理这个难题的。它可以将SFNT数据库转换为XML格式的文本形式，同时支持反向转换。XML其实也是一种偏向于给计算机看的格式，但至少比之前那种人类完全不可理解要好的多了。借助它，我们可以略微窥探一下OpenType字体中的实际内容。

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

// ### The `head` table
=== `head` 表

// `head` is a general header table with some computed metadata and other top-level information about the font as a whole:
`head`表中储存的是整个字体的基本信息和一些计算出的元数据：

```xml
<head>
  <!-- 此表中的大部分数据会在编译时自动计算和更新 -->
  <tableVersion value="1.0"/>
  <fontRevision value="1.0"/>
  <checkSumAdjustment value="0x9fe5c40f"/>
  <magicNumber value="0x5f0f3cf5"/>
  <flags value="00000000 00000011"/>
  <unitsPerEm value="1000"/>
  <created value="Tue Sep 20 15:02:17 2016"/>
  <modified value="Tue Sep 20 15:02:17 2016"/>
  <xMin value="93"/>
  <yMin value="-200"/>
  <xMax value="410"/>
  <yMax value="800"/>
  <macStyle value="00000000 00000000"/>
  <lowestRecPPEM value="3"/>
  <fontDirectionHint value="2"/>
  <indexToLocFormat value="0"/>
  <glyphDataFormat value="0"/>
</head>
```

// The most interesting values here for font designers and layout programmers are `unitsPerEm` through `macStyle`.
这些值中，字体设计师和排版程序开发者们最关心的是从`unitsPerEm`到`macStyle`的部分。

// The `unitsPerEm` value, which defines the scaling of the font to an em, must be a power of two for fonts using TrueType outlines. The most common values are 1000 for CFF fonts and 1024 for TrueType fonts; you may occasionally come across fonts with other values. (Open Sans, for instance, has an upem of 2048.)
`unitsPerEm`定义了字体中单位长度和`em`之间的比例关系。在使用TrueType#tr[outline]的字体中必须设置成2的整数次方，一般会使用1024。使用CFF表示法的字体则一般设置成1000。偶尔也会碰到使用其他值的字体，比如Open Sans字体的`unitsPerEm`值为2048。

#note[
  // > If you are writing a font renderer, you should not make assumptions about this value!
  在编写字体渲染器时不应对这个值有任何预先假设！
]

// `created` and `modified` are mostly self-explanatory; in OpenType's binary representation they are actually stored as seconds since January 1st 1904, (Mac versions prior to OS X used this as their *epoch*, or reference point.) but `ttx` has kindly converted this to a more readable time value.
`created`和`modified`这两个值的意义不言自明。但需要知道的是，它们在二进制表示中其实储存的是从1904年1月1日到目标时间的秒数。Mac 系统在 OS X 版本前用这个特定日期作为其时间零点，或者叫参考点。`ttx` 工具把这个秒数自动转换为了更加易读的日期时间表示。

// `xMin` through `yMax` represent the highest and lowest coordinates used in the font. In this case, the `.notdef` glyph - the only glyph with any outlines - stretched from -200 below the baseline to 800 units above it, has a left sidebearing of 93, and its right edge falls at X coordinate 410.
`xMin`到`yMax`这四个值告诉我们字体中使用的坐标的最大最小值。在本例中，唯一有实际#tr[outline]的`.notdef`#tr[glyph]在竖直方向上具有从-200到800的跨度（这里负数表示位置在#tr[baseline]之下，正数则是#tr[baseline]之上）。它的左#tr[sidebearing]为93，右边缘则位于X坐标410的位置。

// The `macStyle` value is a bit field, used, as its name implies, to determine the style of the font on Mac systems. It consists of two bytes; the one on the left is not used, and the bits in the one of the right have the following meanings:
`macStyle`值中的每个比特位表示一个状态开关，正如其名称所示，Mac系统用这个值来确定字体的样式。它包含两个字节，其中左侧字节的没有使用，右侧字节的每一位的含义如下：

/*
|-|----------|
|0|Bold |
|1|Italic |
|2|Underline |
|3|Outline |
|4|Shadow |
|5|Condensed |
|6|Extended |
|7|(unused) |
|-|-----------|
*/
#align(center, table(
  columns: 2,
  align: left,
  ..for (i, v) in (
    [粗体],
    [意大利体],
    [下划线],
    [#tr[outline]],
    [阴影],
    [窄体],
    [宽体],
    [(未使用)]
  ).enumerate() { (str(i), v,) }
))

// So a bold italic condensed font should have a `macStyle` value of `00000000 00100011` (remember that we count from the right in binary).
所以，一个粗窄意大利体字体的`macStyle`值就会是 `00000000 00100011`（注意字节中最低的位在最右边）。

// ### Vertical metrics: `hhea` and `OS/2`
=== 纵向#tr[metrics]：`hhea` 和 `OS/2` 表

// Before this next test, we will actually add some outlines to our font: a capital A and a capital B:
在介绍下一部分之前，我们先要往测试字体中加入一些#tr[glyph]#tr[outline]，比如@figure:soource-sans-AB 中的A和B。

#figure(
  caption: [Paul Hunt 设计的 Source Sans 字体中的 A B #tr[glyph]]
)[
  #grid(
    columns: 2,
    inset: 0pt,
    image("sourcesans-A.png"),
    image("sourcesans-B.png"),
  )
] <figure:soource-sans-AB>

// After exporting the new font and converting it to XML again using TTX, let's have a look at the `hhea` and `OS/2` tables. These tables are used to set the global defaults that a rendering engine needs to know when using this font in horizontal typesetting. They represent one of the more unfortunate compromises of the OpenType standard, which brought together font files from both the Windows and Mac platforms. It's a cardinal rule of data handling that you shouldn't store the same value in two different places; if you do, they are practically guaranteed to end up either going out of sync, or being used in different ways. OpenType manages to display *both* of these failure modes.
用 `ttx` 把添加了新#tr[glyph]的字体重新转换成XML后，现在可以开始介绍`hhea`和`OS/2`表了。这两张表提供了在进行文本横排时所需的全局默认值。用两张表来做同一件事再一次表现了OpenType标准中令人遗憾的妥协，它需要同时支持 Windows 和 Mac 平台上的不同历史标准。不应该把同一个值重复储存在两个地方是数据处理中的经典规则。因为如果你这么做了，那迟早有一天这两个地方的值会不再一致，或者会被以不同的方式使用。OpenType不幸的两点全中。

首先，我们来看`hhea`表中的（一部分）内容：

```xml
<hhea>
  <!-- ... -->
  <ascent value="1000"/>
  <descent value="-200"/>
  <lineGap value="0"/>
  <advanceWidthMax value="618"/>
  <!-- ... -->
</hhea>
```

// At this point let's pause and skip down to the parts of the `OS/2` table which deal with glyph metrics. Because you can't say `OS/2` in valid XML, `ttx` writes it funny:
同时我们也看一下`OS/2`表中关于#tr[glyph]#tr[metrics]的部分。因为`OS/2`这个标识符无法在XML中作为元素名称使用，`ttx` 将它写作 `OS_2`：

```xml
<OS_2>
  <!-- ... -->
  <fsSelection value="00000000 01000000"/>
  <sTypoAscender value="800"/>
  <sTypoDescender value="-200"/>
  <sTypoLineGap value="200"/>
  <usWinAscent value="1000"/>
  <usWinDescent value="200"/>
  <sxHeight value="500"/>
  <sCapHeight value="700"/>
  <!-- ... -->
</OS_2>
```

// Immediately you should see that the font editor (I used Glyphs to produce this font) has chosen to provide different values for things that seem to be the same: `ascent` in `hhea` is 1000, and so is `usWinAscent` in `OS/2`, but we also have `sTypoAscender` which is set to 800. `descent` and `sTypoDescender` are -200, but `usWinDescent` is 200. Most confusingly, `lineGap` in `hhea` is 0 but `sTypoLineGap` in `OS/2` is 200, but if you look into the OpenType specification, you will find that `lineGap` in `hhea` is described as "typographic line gap" and `sTypoLineGap` is described as "the typographic line gap for this font". Sounds like the same thing, doesn't it?
很容易就能发现，字体编辑器（我这里使用的是Glyphs）在看起来含义相同的两个字段里填入了不同的值：`hhea`中的`ascent`值为1000，和`OS/2`中的`usWinAscent`相同，但它里面还有一个值为 800 的`sTypoAscender`；`descent`和`sTypoDescender`都是 -200，但`usWinDescent`又是200。更让人迷惑的是，`hhea`中的`lineGap`是0，`OS/2` 中 的`sTypoLineGap` 却是 200。如果你觉得它们描述的是两个不同的参数，那看看OpenType标准规范中是怎么说的吧：`lineGap`的含义是“行间距”；`sTypoLineGap`的含义是“此字体的行间距”。这明明看上去就是一回事吧？

// Finally, bit 7 of the `fsSelection` flag is set. The description of bit 7 in the OpenType standard reads "if set, it is strongly recommended to use `OS/2.sTypoAscender - OS/2.sTypoDescender + OS/2.sTypoLineGap` as a value for default line spacing for this font."
然后，`fsSelection`字段的第七个比特位为1。这个比特在OpenType规范中定义为：“如果设置为1，则强烈推荐使用`OS/2.sTypoAscender - OS/2.sTypoDescender + OS/2.sTypoLineGap`作为此字体的默认行距”。

// What on earth is going on?
这到底是在干嘛呢？

// The problem, once again, is that not only did Macintosh and Windows have their own font formats, they each had their own interpretation of how the metrics of a font should be interpreted. Things were bad enough when the only consumers of fonts were the Windows and Mac operating systems, but now word processors, page layout programs, web browsers and a wide range of other software peek into the metrics of fonts and interpret the values in their own special way.
之所以有这些问题，不只是因为我们提到过的 Mac 和 Windows 平台的字体格式不同，更重要的原因是它们对如何理解和处理字体的#tr[metrics]也有不同意见。而现在除了这两个系统之外，又多了文字处理软件、页面排版软件、浏览器等等各种字体使用者。这些使用者各自使用不同的方式理解字体中的属性值，这就让问题更加严重了。

// In particular, when we are talking about global scripts with glyph proportions and line spacing that can differ significantly from Latin glyphs, the default mechanisms of font browsers for computing these values may not be ideal, and they may not provide identical results across platforms. So you may well need to play with some of these values yourself.
特别是我们现在还是在讨论#tr[global scripts]，某些#tr[scripts]的#tr[glyph]属性、行间距等参数可能和拉丁字符有天壤之别。字体浏览器计算这些值的默认方式可能也不一致，可能导致不同的平台上的展示效果也不相同。所以你可能需要手工仔细调整这些值。

// How are they used? To see what's going on, I made this special glyph in position `C`:
这些值到底是干什么用的？为了更好的说明，我在`C`的位置上画了一个特殊的#tr[glyph]：

#figure(
  placement: none,
  caption: [一个用于测量的特殊#tr[glyph]]
)[
  #v(4em)
  #text(font: ("TTX Test",), size: 10em)[C]
  #v(6em)
]

// On my Mac, the TextEdit application seemed to struggle with this, sometimes clipping off the top of the `1000` and anything below the center of the `-200`, and sometimes maintaining it:

// Safari, Firefox and Illustrator all do this:

// (Although when I select the glyph in Illustrator, the selection extends to slightly *more* than 500 points below the baseline. I have no idea why this is.)

在我的Mac系统上，TextEdit应用似乎很难正确处理这个#tr[glyph]。有时候最上面的`1000`和`-200`以下的所有内容都会被截断（@figure:textedit-safari 左半），但有时又不会。

Safari，Firefox和Illustrator三个软件的结果一致（@figure:textedit-safari 右半）。不过在Illustrator中选中#tr[glyph]时，反色选区会略微超过基线以下500单位的位置，我不清楚其中的原因。

#figure(
  caption: [不同应用的显示结果。左图为TextEdit，右图为Safari等]
)[
  #grid(
    columns: 2,
    column-gutter: 2em,
    image("textedit.png"),
    image("safari.png"),
  )
] <figure:textedit-safari>

// The `usWinAscent` and `usWinDescent` values are used for text *clipping* on Windows. In other words, any contours above 1000 or below -200 units will be clipped on Windows applications. On a Mac, the relevant values for clipping are `hhea`'s `ascender` and `descender`. Mac uses `hhea`'s `lineGap` to determine line spacing. As we can see from our Safari example, there is no gap between the lines: the first line's descender at -200 units lines up perfectly with the second line's ascender at 1000 units. Finally, the `typo` values are used by layout applications to position the first baseline of a text block and set the default line spacing.
`usWinAscent`和`usWinDescent`这两个值是 Windows 平台用于截断文本的。也就是说，Windows 平台的软件在显示时会将 1000 以上和 -200 以下的所有东西都裁切去除。在 Mac 上，和截断相关的值是 `hhea` 表中的 `ascender` 和 `descender`。Mac用`hhea`中的`lineGap`来决定行间距，这里的值是 0。所以正如@figure:textedit-safari 中Safari所显示的那样，两行文本间没有空隙，第一行的 -200 和第二行的 1000 位于相同高度。剩下的 `typo` 系列属性用于排版系统中，用以确定文本块中第一行的#tr[baseline]位置和默认行距。

// So how should actually we set these values? Unfortunately, there is not a real consensus on the "right" way to do this - the major foundries each have their own strategies - but hopefully by being aware of what the relevant values do, you should now know what to test for and how to adjust your font's metrics where there are problems. To get you started, here is our recommended method (distilled from a discussion on [Typedrawers](http://typedrawers.com/discussion/1705)):
所以我们到底该怎么设置这些值呢？很抱歉，没有哪一种方法是绝对“正确”的，每个开发商都有自己的设置策略。但只要知道了这些值的用途，你就知道在设计字体时需要测试哪些问题，并且如何对#tr[metrics]进行相应的调整了。推荐先按如下的方式设置（来自Typedrawers论坛上的讨论帖@WeiHuang.WebfontVertical.2016）：

// * The `sTypoAscender` minus the `sTypoDescender` should equal the unit square. (Usually 1000 units.)
- `sTypoAscender - sTypoDescender` 应该等于#tr[em square]的高度。
// * `sTypoLinegap` should be the default linespacing distance for your intended language environment.
- `sTypoLinegap` 应该等于目标语言环境中的默认行距。
// * `lineGap` should be zero.
- `lineGap` 应该设置为 0。
// * `usWinAscent` and `usWinDescent` should be set so that no clipping occurs. If your font contains glyphs with tall, stacked accents - for instance, the Vietnamese letter LATIN CAPITAL LETTER A WITH BREVE AND HOOK ABOVE (Ẳ) - you will need to ensure that these values can accommodate the highest (and lowest) *possible* values of your shaped text. They should also be set so that they sum to *at least* the value of `sTypoAscender - sTypoDescender + sTypoLinegap`.
- `usWinAscent` 和 `usWinDescent` 应该被设置成不会导致任何裁切的值。如果你的字体中会往较高#tr[glyph]上继续堆叠符号的话（比如越南字母 `LATIN CAPITAL LETTER A WITH BREVE AND HOOK ABOVE` Ẳ），你需要保证这两个值比文本#tr[shaping]后可能达到的最高（或最低）值还大。另外这两个值的和至少应该大于`sTypoAscender - sTypoDescender + sTypoLinegap`。
// * `ascent` and `descent` should be set to the same values as `usWinAscent` and `usWinDescent`, remembering that `usWinDescent` is positive and `descent` is negative.
- `ascent`、`descent` 应该和 `usWinAscent`、`usWinDescent` 设置为相同的值。但要注意 `usWinDescent` 是正数，而对应的 `descent` 需要是负数。
// * Bit 7 of `fsSelection` should be turned on.
- `fsSelection`的第7位应该设置成1。

// If you don't like this strategy, there are plenty of others to choose from. The [Glyphs web site](https://www.glyphsapp.com/tutorials/vertical-metrics) describes the strategies used by Adobe, Microsoft and web fonts; [Google fonts](https://github.com/googlefonts/gf-docs/tree/main/VerticalMetrics) has another. Karsten Lucke has a [guide](https://www.kltf.de/downloads/FontMetrics-kltf.pdf) which goes into all of this in excruciating detail but finally lands on the strategy mentioned above.
如果你不喜欢这种设置策略，也可以选择其他方式。Glyphs的网站上描述了 Adobe公司、微软公司和网页字体标准中的设置策略@Scheichelbauer.ZongXiang.2012。Google Fonts也有自己的策略@GoogleFonts.VerticalMetrics。Karsten Lucke 写了一篇关于如何调整这些值的指南@Lucke.FontMetrics，不过最后也归纳为了我们上面描述的策略。

// Yes, this is a complete hot mess. Sorry.
很抱歉，但确实就是这么混乱。

// ### The `hmtx` table
=== `hmtx` 表

// Let's go back onto somewhat safer ground, with the `hmtx` table, containing the horizontal metrics of the font's glyphs. As we can see in the screenshots from Glyphs above, we are expecting our /A to have an LSB of 3, an RSB of 3 and a total advance width of 580, while the /B has LSB 90, RSB 40 and advance of 618.
包含横向#tr[metrics]信息的 `hmtx` 表的情况稍好一些。从@figure:soource-sans-AB 的 Glypys 截图中可以看出，我们测试字体中的 A 的左#tr[sidebearing]（LSB）和右#tr[sidebearing]（RSB）都是3，#tr[advance width]是580。#tr[glyph] B 则是 LSB 为 90，RSB 为 40，#tr[advance width] 618。

// Mercifully, that's exactly what we see:
这和XML中显示的完全一致：

```xml
<hmtx>
  <mtx name=".notdef" width="500" lsb="93"/>
  <mtx name="A" width="580" lsb="3"/>
  <mtx name="B" width="618" lsb="90"/>
</hmtx>
```

// There are vertical counterparts to the `hhea` and `hmtx` tables (called, unsurprisingly, `vhea` and `vmtx`), but we will discuss those when we look at implementing global typography in OpenType.
`hhea`和`hmtx`中的信息会在文本横排时使用，这些信息也有对应的竖排版本，储存在 `vhea` 和 `vmtx` 表中。我们会在后面介绍如何用 OpenType 实现#tr[global scripts]的排版时再讨论它们。

// ### The `name` table
=== `name` 表

// Any textual data stored within a font goes in the `name` table; not just the name of the font itself, but the version, copyright, creator and many other strings are found inside a font. For our purposes, one of the loveliest things about OpenType is that these strings are localisable, in that they can be specified in multiple languages; your bold font can appear as Bold, Gras, Fett, or Grassetto depending on the user's language preference.
字体中所有文本型的信息都储存在`name`表里，不只是字体名，还包括版本号、版权信息、创作者等。OpenType 中很棒的一点是这些文本都可以被本地化，也就是一个信息可以有多个语言的版本。比如粗体可以根据用户的语言偏好而被显示为 Bold、Gras或Fett。

// Unfortunately, as with the rest of OpenType, the ugliest thing is that it is a compromise between multiple font platform vendors, and all of them need to be supported in different ways. Multiple platforms times multiple languages means a proliferation of entries for the same field. So, for instance, there may be a number of entries for the font's designer: one entry for when the font is used on the Mac (platform ID 1, in OpenType speak) and one for when it is used on Windows (platform ID 3).
但很不幸，OpenType 的老毛病在这里也依旧存在。因为要同时支持多个字体供应商的古老标准，这些文本信息也需要为这些字体平台重复多次。多平台X多语言，这就意味着每一个字段都会膨胀为一堆条目。比如，字体设计者这个字段，就分别在Mac上使用的条目（按照OpenType标准的说法叫做平台ID为1），和另一个在Windows上使用的条目（平台ID为3）。

#note[
  // > There's also a platform ID 0, for the "Unicode platform", and platform ID 2, for ISO 10646. Yes, these platforms are technically identical, but politically distinct. But don't worry; nobody ever uses those anyway.
  其实也有代表Unicode的平台 0和代表ISO 10646的平台2。这两个平台在技术上是同一个，但在政治原则上是不同的。别担心，对应这两个平台的条目都没人使用。
]

// There may be further entries *for each platform* if the creator's name should appear differently in different scripts: a Middle Eastern type designer may wish their name to appear in Arabic when the font is used in an Arabic environment, or in Latin script otherwise.
如果某个字段需要在不同的#tr[scripts]环境下显示为不同的值，那么每个平台下可能还会细分更多的条目。比如一个中东的字体设计师，可能希望字体创建者名称在阿拉伯文环境下显示为阿拉伯文，但在其他环境下显示为对应的拉丁字母转写。

// Name entry records on the Mac platform are usually entered in the Latin script. While it's *in theory* possible to create string entries in other scripts, nobody really seems to do this. For the Windows platform (`platformID=3`), if you're using a script other than Latin for a name record, encode your strings in UTF-16BE, choose the appropriate [language ID](https://www.microsoft.com/typography/otspec180/name.htm) from the OpenType specification, and you should be OK.

// ### The `cmap` table
=== `cmap` 表

// A font can contain whatever glyphs, in whatever encoding and order, it likes. If you want to start your font with a Tibetan letter ga (ག) as glyph ID 1, nothing is going to stop you. But for the font to work, you need to provide information about how users should access the glyphs they want to use - or in other words, how your glyph IDs map to the Unicode (or other character set) code points that their text consists of. The `cmap` table is that character map.
字体设计者可以按照自己的偏好来决定字体中要包含哪些#tr[glyph]，使用什么#tr[encoding]，用什么顺序排列。如果你想把藏文字母ga（#tibetan[ག]）安排在#tr[glyph]ID 1 的位置，没有任何规则会阻止你。但为了让这个字体能正常工作，你还需要提供一些让用户知道在什么时候调用这个#tr[glyph]的信息。也就是调用方需要知道怎么把Unicode（或者其他#tr[encoding]）中的#tr[character]映射到绘制的#tr[glyph]上。`cmap` 表的作用就是提供这个#tr[character]映射信息。

// If a user's text has the letter `A` (Unicode code point `0x41`), which glyph in the font should be used? Here's how it looks in our dummy font:
如果有一段包含`A`（Unicode#tr[codepoint]为`0x41`）的文本，那么哪个#tr[glyph]会被调用呢？我们测试字体中的`cmap`信息如下：

```xml
<cmap>
  <tableVersion version="0"/>
  <cmap_format_4 platformID="0" platEncID="3" language="0">
    <map code="0x41" name="A"/><!-- LATIN CAPITAL LETTER A -->
    <map code="0x42" name="B"/><!-- LATIN CAPITAL LETTER B -->
  </cmap_format_4>
  <cmap_format_6 platformID="1" platEncID="0" language="0">
    <map code="0x41" name="A"/>
    <map code="0x42" name="B"/>
  </cmap_format_6>
  <cmap_format_4 platformID="3" platEncID="1" language="0">
    <map code="0x41" name="A"/><!-- LATIN CAPITAL LETTER A -->
    <map code="0x42" name="B"/><!-- LATIN CAPITAL LETTER B -->
  </cmap_format_4>
</cmap>
```

// The `ttx` software used to generate the textual dump of the font has been overly helpful in this case - it has taken the mapping of characters to glyph *ID*s, and has then replaced the IDs by names. The `cmap` table itself just contains glyph IDs.
在这里`ttx`为了生成便于阅读的文本格式而进行了额外工作。它将映射表中的#tr[glyph]ID转换为了对应的名称。原始的`cmap`表中储存的只是#tr[glyph]ID。

// Looking back at the `GlyphOrder` pseudo-table that `ttx` has generated for us:
通过 `ttx` 在生成的XML中附加的 `GlyphOrder` 表，我们可以知道原始的#tr[glyph]ID信息：

```xml
<GlyphOrder>
  <!-- id 属性仅供人类阅读使用，当程序解析时将被忽略 -->
  <GlyphID id="0" name=".notdef"/>
  <GlyphID id="1" name="A"/>
  <GlyphID id="2" name="B"/>
</GlyphOrder>
```

// We see that if the user wants Unicode codepoint `0x41`, we need to use glyph number 1 in the font. The shaping engine will use this information to turn code points in input documents into glyph IDs.
这下我们就知道，如果用户需要Unicode#tr[codepoint]`0x41`对应的字形，就会自动使用ID为1的#tr[glyph]。#tr[shaping]引擎就是这样将输入的字符串转换为#tr[glyph]ID列表。

// ### The `CFF` table
=== `CFF` 表

// Finally, let's look at the table which is of least interest to typography and layout software, although font designers seem to rather obsess over it: the actual glyph outlines themselves. First, we'll look at the `CFF` table which, as mentioned above, represents OpenType fonts with PostScript outlines.
最后我们来看看排版软件最不关心，但字体设计师痴迷其中的东西：#tr[glyph]#tr[outline]。我们先以用PostScript方式表达#tr[outline]时使用的`CFF`表为例。

// What's interesting about the `CFF` table is that its representation is "alien" to OpenType. CFF is a data format borrowed wholesale from elsewhere - Adobe invented the Compact Font Format in 1996 as a "compact" (binary) way to represent its PostScript Type 1 fonts, as opposed to the longform way of representing font data in the PostScript language. It was used since PDF version 1.2 to represent font subsets within PDF documents, and later introduced into OpenType as the representation for PS outlines.
`CFF`表的一个特点是，对于OpenType来说它就像一种外来生物。确实，CFF 是一种从其他技术中借鉴而来的数据格式。1996 年，为了优化长期以来低效地用PostScript语言直接表示PostScript Type 1字体的方法，Adobe发明了紧凑字体格式（Compat Font Format）。它也用于在PDF 1.2之前的文档中储存字体子集。后来OpenType标准将其定为储存PostScript#tr[outline]的格式。

// In other words, CFF is an *independent* font format. You actually have another whole font file inside your font file. This CFF font file begins with its own "public" header before it launches into the outline definitions, giving some general information about the font:
换句话说，CFF本身就是一个*独立的*字体格式。在这个字体文件中其实包含了另一个完整的字体文件。CFF 字体文件在#tr[outline]之前有它自己的公共头部信息，用于提供关于字体的基础信息：

```xml
<CFF>
  <CFFFont name="TTXTest-Regular">
    <version value="001.000"/>
    <Notice value="copyright missing"/>
    <FullName value="TTX Test Regular"/>
    <Weight value="Regular"/>
    <isFixedPitch value="0"/>
    <ItalicAngle value="0"/>
    <UnderlineThickness value="50"/>
    <PaintType value="0"/>
    <CharstringType value="2"/>
    <FontMatrix value="0.001 0 0 0.001 0 0"/>
    <FontBBox value="3 -200 578 800"/>
    <StrokeWidth value="0"/>
    <!-- 字符集被单独储存在 GlyphOrder 元素中 -->
    <Encoding name="StandardEncoding"/>
```

// From an OpenType perspective, much of this is information we already know, but which has to be filled in to make this table conform to the CFF format. Font production software will generally copy this information from other parts of the font: the copyright notice and font name find their native OpenType home in the `name` table, the weight value can be found in the `OS/2` table, the bounding box information comes from the `head` table, and so on.
从OpenType标准的视角来说，这个头部中的大多数信息都在别处已经提供。但为了满足CFF格式标准，必须在这里也填写一遍。字体制作软件通常会从其他表中自动复制所需的信息进行填入。比如版权信息和字体名会从`name`表中获取，字重值则来自`OS/2`表，#tr[bounding box]相关信息可以从`head`表中得知。

// It's not clear if any software cares too much about the values in this header. As an experiment, I tried modifying the paint type and stroke width to attempt to create an outline font (recompiling the XML representation back into OpenType, again using `ttx`), and embedding this in a PDF document, but nothing changed.
我不确定是否有软件真的会使用这个公共头部里的信息。我尝试过修改其中的`PaintType`和`StrokeWidth`字段，然后将XML表示重新转换回字体文件并嵌入PDF文件里，但结果什么都没变。

// After the public header comes a private header, which is very much used:
公共头部之后是私有头部，这部分就很有用了：

```xml
<Private>
  <BlueScale value="0.037"/>
  <BlueShift value="7"/>
  <BlueFuzz value="0"/>
  <ForceBold value="0"/>
  <LanguageGroup value="0"/>
  <ExpansionFactor value="0.06"/>
  <initialRandomSeed value="0"/>
  <defaultWidthX value="0"/>
  <nominalWidthX value="0"/>
</Private>
```

// These mainly have to do with hinting, which we will deal with in the appropriate chapter.
这些字段大多和#tr[hinting]有关，我们会在专门的章节中再进行详细介绍。

// Finally we get to the good stuff:
再往后就是我们现在感兴趣的部分了：

```xml
<CharStrings>
  <!-- ... -->
  <CharString name="A">
    580 213 72 342 73 hstem
    3 574 vstem
    240 700 rmoveto
    -237 -700 rlineto
    91 hlineto
    67 213 rlineto
    255 hlineto
    66 -213 rlineto
    95 hlineto
    -237 700 rlineto

    -157 -415 rmoveto
    33 107 24 79 24 75 22 81 rlinecurve
    4 hlineto
    22 -81 23 -76 25 -78 34 -107 rcurveline
    endchar
```

// The definition of the characters themselves, in the PostScript language, begins with some hinting information: the total width is 580, and there's a horizontal stem that starts at 213 and goes for 72 units to 285; (the crossbar of the A) then another which goes from 285+342=627 to 627+73=700 to represent the apex of the A. The vertical stem goes from the left side bearing (3 units) all the way across the glyph.
这些就是用PostScript语言写成的#tr[glyph]定义了。定义中最开始的部分也是#tr[hinting]。其含义为：整个#tr[glyph]宽度为580；有两个水平的#tr[stem]，第一个#tr[stem]（A字中间的横梁）从坐标213处开始，高72个单位，持续到`213+72=285`；第二个#tr[stem]（A的顶部尖端部分）则从坐标`285+342=627`处开始，持续到`627+73=700`。竖向的#tr[stem]则从左#tr[sidebearing]（横坐标为3）处开始，一直横跨整个字符（这里描述的是竖向#tr[stem]的横轴长度，正如之前横向#tr[stem]是描述其纵轴高度）。

// Then there are a series of moving and drawing operations: we `rmoveto` the left side of the apex, and draw the left outmost stroke of the A, a diagonal `rlineto` the position (3,0). (PostScript uses relative coordinates: we move left 237 units and down 700 units, so we end up at (3,0).) Now we're at the bottom left corner of the A, about to draw the horizontal line at the bottom of the left leg. PostScript has a special drawing instruction, `hlineto`, for horizontal lines, which omits the vertical coordinate, which means that `91 hlineto` takes us from (3,0) to (94,0).
后续则是一些移动和绘制指令。首先 `rmoveto` 将画笔移动到顶部尖端的左侧，然后 `rlineto` 命令绘制出A字的最左边的一笔。这里 PostScript 语言使用的是相对坐标，因为最开始将画笔移动到了 `(240, 700)`，所以往左 237，往下 700 单位后就到了最左下角的 `(3, 0)`。现在要接着画左脚的底部横线，PostScript 对于水平线段有一个专用的指令 `hlineto`，使用它就无需填写纵坐标参数。所以这里代码 `91 hlineto` 就画出了从 `(3, 0)` 到 `(94, 0)` 的一条横线。

// We go around the outline until `-237 700` takes us back to the top *right* of the apex. (I've added a blank line here for clarity, although it would not be in the actual TTX outline.) This is almost the end of the outer outline. We haven't actually drawn the line between the top right of the apex and the top left where we started, but it turns out we don't need to. When we pick up the pen and move it somewhere else, which will be our next instruction, the outline gets closed for us.
在经过了一系列绘制后，通过 `-237 700` 的一次移动，最终我们回到了顶部尖端的右侧（为了能看的更清楚，我在这条语句之后加了一个空行，要注意代码中实际上是没有的），这基本就是整个最外侧#tr[outline]的样子了。我们不需要手动写出从尖端右侧到作为绘制起点的尖端左侧的横向线条，因为下一条语句是 `rmoveto`，将画笔拿起并移动到其他位置的命令会自动将当前的#tr[outline]封闭。

// We've just been dealing with straight lines so far, but moving us left 157 units and down 415 units places us in the middle of the counter of the A, where we start to see some curves - there are subtle flexes within the diagonals of the aperture. (You font designers are *clever* people.) `rlinecurve` specifies the relative positions of the start, first control point, second control point and end point of our cubic Bézier curve. We move across to the right a bit, have a curve that comes down, and that concludes our letter A.
至今为止我们都是在画直线，不过在将画笔移动到A的#tr[counter]部分之后，因为开口的内部角落处会有细微的弯曲，所以我们得开始画曲线了。`rlinecurve` 通过起始点、第一控制点、第二控制点、终结点之间的相对位置来绘制一条贝塞尔曲线。然后向右画一条小横线，再画一条向下的曲线，这样我们的字母A就完成了。

// ### The `post` table
=== `post` 表

// While we're on the subject of PostScript Type 1 representation, let's briefly look at the `post` table, which is used to assemble data for downloading fonts onto PostScript printers:
既然我们已经在介绍PostScript相关技术了，也顺便看看用于把字体传输到PostScript打印机上的`post`表的内容：

```xml
<post>
  <formatType value="3.0"/>
  <italicAngle value="0.0"/>
  <underlinePosition value="-75"/>
  <underlineThickness value="50"/>
  <isFixedPitch value="0"/>
  <minMemType42 value="0"/>
  <maxMemType42 value="0"/>
  <minMemType1 value="0"/>
  <maxMemType1 value="0"/>
</post>
```

// The `post` table has been through various revisions; in previous versions, it would also include a list of glyph names, but as of version 3.0, no glyph names are provided to the PostScript processor. The final four values are hints to the driver as to how much memory this font requires to process. Setting it to zero doesn't do any harm; it just means that the driver has to work it out for itself. The italic angle is specified in degrees *counter*clockwise, so a font that leans forward 10 degrees will have an italic angle of -10. `isFixedPitch` specifies a monospaced font, and the remaining two values are irrelevant because nobody should ever use underlining for anything, am I right?
`post`表有多个版本，在老版本中它还需要包含#tr[glyph]名称列表，不过3.0之后就不需要了。最后的四个值用于告诉打印机这个字体需要多少内存来进行处理。将它们设置成0并不会影响字体的功能，只是代表打印机需要自行判断使用多少内存。`italicAngle` 在表示倾斜角度时要求使用逆时针，所以向前倾斜10度的字体这个字段需要填 -10。`isFixedPitch`用于指定是否为等宽字体。剩下的两个很明显是决定下划线的位置和粗细程度。

// ## TrueType Representation
== TrueType#tr[outline]表示法

// So that was the PostScript format, which is the normal way of exporting OpenType fonts. But Glyphs allows us to output our test font with TrueType outlines, and if we do that, we see that things have changed:
以上我们介绍了 PostScript 格式，这也是导出 OpenType 字体时常用的#tr[outline]格式。但 Glyphs 也允许我们使用TrueType格式输出#tr[outline]。如果我们导出字体时开启了此选项，就能看到有些表发生了变化：

```bash
$ ttx -l TTXTest-Regular.ttf
Listing table info for "TTXTest-Regular.ttf":
    tag     checksum   length   offset
    ----  ----------  -------  -------
    DSIG  0x00000001        8     1960
    GSUB  0x00010000       10     1948
    OS/2  0x683D6762       96      764
    cmap  0x007700CF       74      860
    cvt   0x00000000        6     1416
    fpgm  0x47A67342      479      936
    gasp  0x001A0023       16     1932
    glyf  0xABA0B11E      368      252
    head  0x09740B40       54      660
    hhea  0x062F01A9       36      728
    hmtx  0x06A200BA       12      716
    loca  0x00840118        8      652
    maxp  0x00780451       32      620
    name  0xDF876A4F      465     1424
    post  0xFFDE0057       40     1892
```

// An OpenType font with TrueType outlines does not have a `CFF` table, but instead contains a number of other tables; two of which contain data about the glyphs themselves:
使用TrueType#tr[outline]的OpenType字体没有`CFF`表，但相对的会多出一些其他表。其中有两张表包含了#tr[glyph]信息：

/*
|`glyf`|Glyph data|
|`loca`|Index to location|
*/
#align(center, table(
  columns: 2,
  align: left,
  [`glyf`], [#tr[glyph]数据],
  [`loca`], [位置索引],
))

// And four which are used for hinting and rasterizing, which we will deal with in the appropriate chapter:
另外四张表用于#tr[hinting]和#tr[rasterization]过程，这些我们会在相应的章节中再详细介绍：

/*
|`prep`|The Control Value "pre-program"|
|`fpgm`|Font program|
|`cvt`|Data values used by the hint program|
|`gasp`|Information about how to render the font on grayscale devices|
*/
#align(center, table(
  columns: 2,
  align: left,
  [`prep`], [控制值预处理程序],
  [`fpgm`], [字体程序],
  [`cvt`], [#tr[hinting]程序中使用的数据值],
  [`gasp`], [关于如何在支持灰度的设备上渲染字体的信息],
))

// The names of the first two of these hinting tables are somewhat misleading. The "font program" (`fpgm`) is run once before the font is used, in order to set up definitions and functions for hinting, whereas the "pre-program" (`prep`) actually contains the size-specific font hinting instructions and is executed every time the font changes size. Yes, this is completely brain-dead.
前两个表名非常容易造成错误理解。字体程序（`fgpm`）是在字体被使用之前，用来初始化#tr[hinting]中需要用到的各种定义和函数的程序。而预处理程序（pre-program，`prep`）实际上是包含了和特定字体大小相关的#tr[hinting]指令，它在字体每次改变大小时都需要执行。这些名字起的确实有些烧脑。

// How are glyphs represented in TrueType outlines? The binary representation in the table is in a series of fixed-width arrays, containing instructions, relative coordinates and flags, (see the OpenType specification if you need to deal with the binary tables) but `ttx` expands them to a very friendly format for us:
那么TrueType到底使用什么方式表达#tr[glyph]#tr[outline]呢？在二进制文件中，这些表实际储存了一系列定长数组，它们包含了绘图指令，相对坐标和控制选项（如果你需要直接处理字体文件，可以参考OpenType规范文件）。而 `ttx` 工具会将他们转换为更加友好的格式：

```xml
<TTGlyph name="A" xMin="3" yMin="0" xMax="577" yMax="700">
  <contour>
    <pt x="240" y="700" on="1"/>
    <pt x="340" y="700" on="1"/>
    <pt x="577" y="0" on="1"/>
    <pt x="482" y="0" on="1"/>
    <pt x="416" y="213" on="1"/>
    <pt x="161" y="213" on="1"/>
    <pt x="94" y="0" on="1"/>
    <pt x="3" y="0" on="1"/>
  </contour>
  <contour>
    <pt x="394" y="285" on="1"/>
    <pt x="360" y="392" on="1"/>
    <pt x="320" y="518" on="0"/>
    <pt x="290" y="627" on="1"/>
    <pt x="286" y="627" on="1"/>
    <pt x="258" y="527" on="0"/>
    <pt x="233" y="449" on="1"/>
    <pt x="228" y="430" on="0"/>
    <pt x="216" y="392" on="1"/>
    <pt x="183" y="285" on="1"/>
  </contour>
  <instructions><assembly>
    </assembly></instructions>
</TTGlyph>
```

// Here we can see the two contours of our A, as a series of on-curve and off-curve points. Remember that TrueType uses *quadratic* Bézier curves, so within our aperture we only see one off-curve point between the on-point curves. Glyphs has converted our Béziers for us:
很明显 A 由两条#tr[contour]组成，这些线条由线上点和线外点控制。还记得 TrueType 使用的是*二次*贝塞尔曲线吧？所以在两个线上点之间，我们最多只会看见一个线外点。Glyph 在导出时自动帮我们进行了贝塞尔曲线的转换（@figure:bezier-convert）。

#figure(
  placement: none,
  caption: [三次贝塞尔曲线转换为二次]
)[#include "bezier.typ"] <figure:bezier-convert>

// Sometimes you might open up a `glyf` table and find something confusing:
有些时候`glyf`表里也会出现一些奇怪的东西：

```xml
<TTGlyph name="C" xMin="125" yMin="-20" xMax="1231" yMax="1483">
  <contour>
    <pt x="827" y="1331" on="1"/>
    <pt x="586" y="1331" on="0"/>
    <pt x="307" y="1010" on="0"/>
    <pt x="307" y="731" on="1"/>
      ...
```

// There are two off-curve points between the on-curves! Does this mean that we're suddenly using cubic Bézier curves in our TrueType outlines? Nope, the font is doing something clever here to save space: there is an "implied" on-curve point located half-way between the off-curves points. Software handling these curves needs to insert the implied on-curve point.
在线上点之间竟然连续出现了两个线外点！这难道不是在TrueType #tr[outline]中使用了三次贝塞尔曲线吗？不不不，这只是字体文件为了节省空间而进行了某些聪明的省略罢了。这种写法表示在两个线外点的正中间有一个隐含的线上点。软件在处理这些曲线时，还是需要把这个被省略的点给加回去的。

#figure(
  placement: none,
  caption: [两个线外点间隐含的线上点]
)[#include "implied.typ"]


// What about the `loca` table? The `glyf` table contains all contours for all the glyphs, one after another as a big long binary lump. When you're trying to find a glyph, you look up its glyph index in the `loca` table, and it'll tell you which byte of the `glyf` table you need to jump to.
那 `loca` 表又是干什么用的呢？因为 `glyf` 表是直接以二进制形式连续储存所有#tr[glyph]的#tr[contour]的，我们需要从`loca`表中找到这个#tr[glyph]在`glyf`数据中的位置，才能知道从哪开始读取#tr[outline]信息并绘制它。

// ## And more tables!
== 更多数据表

// We've looked at all of the compulsory tables in an OpenType font; there are many other tables which can also be present. There are tables which handle vertical typesetting, and tables which allow you to position the baseline at different places for different scripts; tables which give hints on how to justify lines, or resize mathematical symbols; tables which help with hinting, and tables which contain bitmaps, vector graphics, and color font information. For more on how these tables work, it's best to read the [OpenType specification itself](https://docs.microsoft.com/en-us/typography/opentype/spec/).
我们介绍完了OpenType中所有必须的数据表，但实际应用中还可能会出现其他表。按用途分可能有：用于竖排文本；为不同的文种调整基线位置；提供关于如何对齐线条和缩放数学符号的信息；辅助提供#tr[hinting]；使用#tr[bitmap]或矢量图形表示#tr[glyph]；彩色字体等。关于这些数据表的工作方式，最好直接阅读OpenType规范@Microsoft.OpenTypeSpecification。

// In fact, why stop there? There's nothing to stop you defining your own table structure and adding it to your font; the font is just a database. If you want to add a `SHKS` table which contains the complete works of Shakespeare, you can do that; software which doesn't recognise the table will simply ignore it, so it'll still be a perfectly valid font. (Yes, I have tried this.) TTX will even happily dump it out for you, even if it doesn't know how to interpret it. The Graphite font rendering software, developed by SIL, uses this method to embed advanced features inside the fonts, such as automatic collision avoidance and word kerning (character kerning across a space boundary), in custom Graphite-specific tables.
我们也不用拘泥于这些已经定义好的数据表格式。事实上OpenType并不限制在字体中使用自创的数据表结构，毕竟字体就是一个数据库。即使你想在字体中加入一个叫`SHKS`的表用于存放莎士比亚的所有作品也是可以的。虽然无法识别这个表的用途的应用软件会将它忽略，但它仍然会是一个有效的字体文件（我真的试过这么做）。而 TTX 工具即使不知道如何解读，也会照常将表中的数据导出。由 SIL 开发的 Graphite 字体渲染软件就使用这种自定义数据表的方式向字体中嵌入了更多高级特性，比如自动避让和词偶距（在单词之间的空格处生效的#tr[kern]）等。

// Finally, there is one more table which we haven't mentioned, but without which nothing would work: the very first table in the font, called the Offset Table, tells the system which tables are contained in the font file and where they are located within the file. If we were to look at our dummy OpenType font file in a hex editor, we would see some familiar names at the start of the file:
最后，我还想介绍一个非常重要的，甚至没有它的话字体就无法正常工作的数据表。它位于文件的开头，叫做偏移量表。它告诉系统字体文件中到底包含哪些数据表，以及每张表在文件中的位置。如果我们使用十六进制编辑器直接打开字体文件，在开头的部分就会看见很多熟悉的名字：

```
00000000: 4f54 544f 000a 0080 0003 0020 4346 4620  OTTO....... CFF
00000010: 400e 39a4 0000 043c 0000 01de 4753 5542  @.9....<....GSUB
00000020: 0001 0000 0000 061c 0000 000a 4f53 2f32  ............OS/2
00000030: 683d 6762 0000 0110 0000 0060 636d 6170  h=gb.......`cmap
00000040: 0017 0132 0000 03d0 0000 004a 6865 6164  ...2.......Jhead
00000050: 0975 3eb0 0000 00ac 0000 0036 6868 6561  .u>........6hhea
00000060: 062f 01a9 0000 00e4 0000 0024 686d 7478  ./.........$hmtx
00000070: 06a2 00ba 0000 0628 0000 000c 6d61 7870  .......(....maxp
```

// `OTTO` is a magic string to tell us this is an OpenType font. Then there is a few bytes of bookkeeping information, followed by the name of each table, a checksum of its content, its offset within the file, and its length. So here we see that the `CFF ` table lives at offset `0x0000043c` (or byte 1084) and stretches for `0x000001de` (478) bytes long.
`OTTO`是代表OpenType字体的魔术字。在几个表示字体信息的字节之后就是数据表偏移量记录。每项记录由表名、表数据的校验和、在文件中的位置以及数据长度组成。比如上面的数据显示，`CFF` 表位于 `0x0000043c`（也就是第1084个字节）的位置，长度为`0x000001de`（478）个字节。

// ## Font Collections
== 字体集

// In OpenType, each instance of a font's family lives in its own file. So Robert Slimbach's Minion Pro family - available in two widths, four weights, four optical sizes, and roman and italic styles - ships as $$ 2 * 4 * 4 * 2 = 64 $$ separate `.otf` files. In many cases, some of the information contained in the font will be the same in each file - the character maps, the ligature and other substitution features, and so on.
在 OpenType 中，字体家族中的每一个字体实例都分别储存在独立的文件中。比如由 Robert Slimbach 制作的，拥有两种宽度、四个字重、四个大小、罗马体和意大利体两种样式的 Minbion Pro 字体家族，就被分成了共计 $2*4*4*2 = 64$ 个`otf`文件。在大多数情况下，这些字体文件中的某些信息会是相同的，比如#tr[character]映射表、#tr[ligature]和其他#tr[character]#tr[substitution]特性等。

// Font collections provide a way of both sharing this common information and packaging families more conveniently to the user. Originally called TrueType Collections, a font collection is a single file (with the extension `.ttc`) containing multiple fonts. Each font within the collection has its own Offset Table, and this naturally allows it to share tables. For instance, a collection might share a `GSUB` table between family members; in this case, the `GSUB` entry in each member's Offset Table would point to the same location in the file.
源自TrueType的字体集则是一种便于相同信息共享和字体家族打包的储存方式。字体集使用单个文件（后缀名为`ttc`）来储存多个字体。每个字体有自己的偏移量表，这样就天然的支持了数据表的共享。比如，只需将所有字体偏移量表中的`GSUB`条目指向文件中的同一位置，就可以让字体家族成员都使用同一个`GSUB`表。

// A collection is, then, a bunch of TrueType fonts all welded together, with a header on top telling you where to locate the Offset Table of each font. Here's the start of Helvetica Neue:
字体集中的TrueType字体连续储存，在整个文件的开始处则又有一个偏移量表，来指明每个字体的位置。如下是 Helvetica Neue 字体集的起始数据：

```
00000000: 7474 6366 0002 0000 0000 000b 0000 0044  ttcf...........D
00000010: 0000 0170 0000 029c 0000 03c8 0000 04f4  ...p............
```

// `ttcf` tells us that this is a TrueType collection, then the next four bytes tell us this is using version 2.0 of the TTC file format. After that we get the number of fonts in the collection (`0x0000000b` = 11), followed by 11 offsets: the Offset Table of the first font starts at byte 0x44 of this file, the next at 0x170, and so on.
`ttcf`文件头告诉我们这是一个TrueType字体集文件，接下来的四个字节表示这是TTC文件格式的2.0版。之后的 `0x0000000b = 11` 则是集合中的字体数量，再后面 11 个字节就是这些字体在文件中的位置。比如这里显示第一个字体在`0x44`，第二个在`0x170`等。

== OpenType可变字体 <heading:opentype.font-variation>

// Another, more flexible way of putting multiple family members in the same file is provided by OpenType Font Variations. Announced at the ATypI conference in 2016 as part of the OpenType 1.8 specification, font variations fulfill the dream of a font whereby the end user can dynamically make the letterforms heavier or lighter, condensed or expanded, or whatever other axes of variation are provided by the font designer; in other words, not only can you choose between a regular and a bold, but the user may be able to choose any point in between - semibolds, hemi-semibolds and everything else suddenly become available. (Whether or not you believe that users really *ought* to have access to infinite variations of a font is entirely another matter.)
OpenType可变字体是另一种能更灵活地将多个字体家族成员放入同一个文件中的方式。它是在 2016 年的 AtypI 会议上发布的 OpenType 1.8 版本中的新增功能。它完成了字体行业的一个久远的梦想：让用户能够通过调整设计师提供的数轴上的取值，来动态生成所需的不同字重或宽窄的字体变体。换句话说，用户们不再仅仅只能从选择常规体和粗体，而是可以根据需要，自行生成符合需求的粗细程度。（至于用户是否能用好这种拥有无限变化的字体就是另一回事了。）

// As with everything OpenType, variable fonts are achieved through additional tables; and as with everything OpenType, legacy compromises means that things are achieved in different ways depending on whether you're using PostScript or TrueType outlines. TrueType outlines are the easiest to understand, so we'll start with these.
和其他OpenType特性一样，可变字体也是通过新增数据表的方式实现的。同理，OpenType的缺点这次也没有缺席，它还是需要兼顾PostScript和TrueType两种历史实现。其中TrueType#tr[outline]比较容易理解，我们就从它开始。

// But first, we have to understand interpolation and deltas. From a designer's perspective, what you do when you design a variable font doesn't really change much from an ordinary multiple master font. First, you decide on your design axes and the points on those axes that you will design; the most common axis is the weight axis - perhaps you will go from regular to bold, or you may design thin, regular and black weights and interpolate between those points. Or you may choose to work on the width axis, designing condensed, regular and extended masters. Then you draw your glyphs, and five years later you have a font.
首先，我们来介绍插值和变化量。从设计师的视角看，设计可变字体和之前的多母版字体之间并没有太大区别。首先你需要决定字体的哪些属性可以变化，以及你要对这些属性中的哪些值进行实际设计。最常见的可变轴是字重，你可以设计常规体和粗体，或细体、常规体和浓体，然后使用插值完成中间的部分。你也可以通过设计窄、常规和宽三个母版来让字宽可变。接下来就开始画#tr[glyph]吧，五年之后你就能得到一个字体了。

// > Italic isn't a design axis; it's usually handled separately, for two reasons: first, you don't really want people to be producing semi-italic fonts, and second, often the italic shapes of characters are quite different to the upright shapes, so it's not possible or sensible to interpolate between them. I mean, you *could*. But you probably shouldn't.
#note[
  意大利体不应作为可变轴，它通常由手工单独处理。这有两个原因，一是你不太会希望人们使用“半意大利体”之类的中间形式。二是意大利体需要对#tr[character]的形状进行某些变化，导致在常规体和意大利体之间无法进行插值，或者至少插值的效果并不太好。所以虽然技术上允许，但最好别这么做。
]

#figure(
  placement: none,
)[#include "designspace.typ"]

// Once you have designed your masters, you can then interpolate instances in between those extremes; for instance, if we wanted to create a semibold instance of this font, (Noto Sans Khmer) we would take the regular and the bold masters and, for each point on the glyph, compute a position that lays some proportion of the way between the corresponding points on the two masters.
当母版设计好后，下一步就是从这些极值点插值出中间的实例。比如为了创建上图字体（Noto Sans Khmer）的半粗体，就需要拿出常规体和粗体的两个母版。#tr[glyph]中的每一个点在两个母版上的位置会有不同，按照一定的比例分配后就能计算出其在半粗体时的位置了。

// How does this work? In the diagram below, the green (regular) and red (bold) outlines represent our two different input masters. To form the semibold, we "take the average" of each point between the green and red, ending up with the yellow points, which is the outline of our semibold instance:
那么这个过程究竟是怎样的呢？@figure:interpolation 中绿色是常规体母版的#tr[outline]，红色则是粗体的。为了构建半粗体，我们取每一个点在红色和绿色线条上位置的平均值，得到黄色的点。这些点连起来就是半粗体的#tr[outline]了。

#figure(
  caption: [由常规体和粗体插值出半粗体的过程],
)[#image("interpolation.svg", width: 90%)] <figure:interpolation>

// But there's another way to think about masters and interpolation. When *designing* your font, you design with two distinct masters for each axis. Each master represents an "end" of the axis - one master for the thickest and one for the thinnest; one master for the widest, and one for the narrowest, and so on. Nothing changes here. But when the font is assembled as an OpenType variation font, it only has one set of outlines as normal. The outlines in the `CFF` or `glyf` tables represent the Ur-Outline, the One True Master, essentially a "normal" or "average" form of each glyph. The *axes* (such as width or weight) are represented in terms of how we should vary the shape of the One True Master. For each point, we have a set of *deltas*. For example, the bold axis will be given as a set of vector coordinates for each point on each glyph, describing how to get from the One True Master to the bold form:
这个过程还可以用@figure:deltas-1 描述的另一种方式来思考。当设计字体时，你还是为每个变化轴的两个极值分别设计母版。比如在字重轴上就设计一个最细的和一个最粗的，在字宽轴上就设计一个最窄的和一个最宽的等等，这些步骤还是不变。当在将设计编译成OpenType可变字体时，文件中只存在唯一的一个#tr[outline]，储存在`CFF`或者`glyf`表中。这个唯一#tr[outline]是你设计的所有母版中#tr[glyph]#tr[outline]的均值。而这些可变轴（字重或字宽）实际上存储为对这个唯一#tr[outline]的变化。对于#tr[outline]中的每个点，我们都会储存一些“变化量”。比如，字重轴会存储为#tr[glyph]中每个点上的一个向量，用于描述如何将唯一母版变化到粗体形式。

#figure(
  caption: [每个点在粗体轴上的变化量],
  placement: none,
  include "deltas-1.typ",
) <figure:deltas-1>

// The reason for using a single master and multiple deltas is that you can then *blend* together motion along multiple design axes. Instead of having separate regular, condensed, bold, and bold condensed masters, the font is represented internally as having a single master and two sets of deltas, one which makes the font more bold and one which makes it more condensed:
使用单个母版加多个变化向量的方式有一个好处：多个可变轴可以叠加应用。这样你就不用创建常规体、窄体、粗体、粗窄体四个母版了，而是只需要单个常规母版，加上分别使字体更粗和字体更窄的两套变化向量即可。

#figure(
  caption: [两个变化量的叠加应用],
  placement: none,
  include "deltas-2.typ"
) <figure:deltas-2>

// Creating a semibold condensed instance of this font requires you to do some vector mathematics. If we say that "semibold" means 50% of full bold, and "condensed" is 100% of the way down the condensed axis, then for each point, we need to compute its "semibold condensed" vector. We multiply the red *weight* vector for that point by 50%, then take the product of that vector with 100% of the yellow *condensed* vector. Then we add the resulting vector to the original position of the point on the green master.
用这种方式创建半粗窄体则需要进行一些向量计算。假设你把半粗定义50%程度的粗，窄体定义为字宽轴上的100%位置。那么对于每一个点，我们都将红色的粗体向量乘以50%，再加上100%的黄色窄体向量，这样就计算出了对应的“半粗窄体”向量。将绿色模板上的原始点按照计算出的向量方向移动即可得到半粗窄体的#tr[outline]点。

#note[
  // That was a simplification, as we'll see a bit later.
  这是简化版的描述，后续会介绍细节。
]

// So let's see how this is actually looks inside the file. We've been using Noto Sans Khmer, so let's break that open in `ttx`:
让我们看看使用了这种技术的字体文件中的实际内容。用 `ttx` 工具打开 Noto Sans Khmer 字体：

```bash
$ ttx NotoSansKhmer-GX.ttf
Dumping "NotoSansKhmer-GX.ttf" to "NotoSansKhmer-GX.ttx"...
Dumping 'GlyphOrder' table...
Dumping 'head' table...
Dumping 'hhea' table...
Dumping 'maxp' table...
Dumping 'OS/2' table...
Dumping 'hmtx' table...
Dumping 'cmap' table...
Dumping 'loca' table...
Dumping 'glyf' table...
Dumping 'name' table...
Dumping 'post' table...
Dumping 'GDEF' table...
Dumping 'GPOS' table...
Dumping 'GSUB' table...
Dumping 'fvar' table...
Dumping 'gvar' table...
```

// We've got a couple more tables this time: `fvar` and `gvar`. The `fvar` table describes the design axes, their range, and where the One True Master is situated on that axis:
这次的结果中出现了`fvar`和`gvar`这两个前面没见过的数据表。`fvar` 表用于描述设计师定义的可变轴和每个轴的变化范围，以及初始的唯一母版在可变轴上的位置。

```xml
<fvar>
  <Axis>
    <AxisTag>wdth</AxisTag>
    <MinValue>70.0</MinValue>
    <DefaultValue>100.0</DefaultValue>
    <MaxValue>100.0</MaxValue>
    <AxisNameID>256</AxisNameID>
  </Axis>
  <Axis>
    <AxisTag>wght</AxisTag>
    <MinValue>26.0</MinValue>
    <DefaultValue>90.0</DefaultValue>
    <MaxValue>190.0</MaxValue>
    <AxisNameID>257</AxisNameID>
  </Axis>
```

// This font has two design axes, width and weight. (There's also a third axis in the font, a custom axis which doesn't seem to be used. So I've removed it for clarity.)
这个字体有字宽和字重两个可变轴。（实际上还有第三个自定义的可变轴，但似乎并没有实际用到，所以这里为了描述更清晰而删掉了它。）

// The names of the axes are localised in the `name` table so that they can be displayed to users in the appropriate language. The width axis runs from compressed=70 to regular=100, and the One True Master represents the regular width; the weight axis runs from 26 to 190, with the One True Master located at 90.
可变轴的名称需要储存在`name`表中并本地化为不同的语言展示给用户。字宽轴的范围从最窄的70到常规的100，初始母版使用常规字宽。字重轴则从26到190，初始母版的值为90。

#note[
  // > There are two types of axes in the Font Variations specification: registered axes and custom axes. The idea behind a registered axis is that everyone should be able to use the axis in the same way. Weight and width are registered axes, because they're the kind of thing that a lot of fonts are going to use. So the specification also defines some semantics for the values on these axes, so that applications can produce an interface and user experience that is common across fonts. The width axis is defined as a percentage value of compression, with "100" representing the default font neither compressed nor expanded. The weight axis is supposed to work like CSS weights, with a standard regular master having a value of 400. (Noto is being naughty here.)
  在可变字体的规范中可变轴有预定义和自定义两种。因为大量字体都会使用规范中预定义的可变轴，所以这些轴的使用方式要保持一致。为此，规范为这些轴上的数值也规定了具体语义。这样应用程序就可以设计一个对多个字体都可用的统一界面。比如，字宽轴定义为伸缩的百分比，数值100就表示默认的既没有被压缩也没有被拉伸的字体。字重轴则被定义成以类似CSS中的值，标准常规母版使用400。（Noto 字体在这有些调皮了）

  // > For custom axes, where you start and end your values and where you put your default is up to you; the numbers on custom axes are dimensionless quantities that are only interpreted in relation to each other.
  自定义轴的范围和初始值就完全取决于设计师自己了。这些数值是无单位的，只能按照数字大小来进行相对比较。

  // In both cases, when we come to looking at the deltas, these values get normalized: -1 represents the bottom end of the axis, 1 represents the top end, and 0 represents the *default*. (not the middle!)
  当需要计算变化量时，这两种轴都会进行归一化。具体来说是将最小值视为 -1，最大值视为 1，默认值（而不是中位值！）被视作 0。
]

// While the purpose of Variable Fonts is to allow the user infinite flexibility, we still want the user to have access to particular instances of the font that the designer thinks work particularly well or define a good typographic hierarchy. So the `fvar` table also includes definitions for named instances, located at specific points on the design space:
虽然可变字体技术的目的是为了让用户拥有无限的调整灵活性，但我们希望用户依然可以和之前一样，从设计师精心调整过的几个特定实例间进行挑选并直接使用。所以`fvar`表中还有一部分信息是命名实例，它们可以想象成整个设计空间中某些特定的点：

```xml
<!-- Thin -->
<NamedInstance subfamilyNameID="259">
  <coord axis="wdth" value="100.0"/>
  <coord axis="wght" value="26.0"/>
</NamedInstance>
<!-- ... -->
<!-- Condensed ExtraLight -->
<NamedInstance subfamilyNameID="269">
  <coord axis="wdth" value="79.0"/>
  <coord axis="wght" value="39.0"/>
</NamedInstance>
```

// Noto Sans Khmer Thin is all the way down the bottom of the weight axis, and Condensed ExtraLight is part of the way down the weight axis and almost all the way down the bottom of the width axis.
Noto Sans Khmer 的 Thin 字体实例使用了字重轴的最小值，而 Condensed ExtraLight 则使用了接近最小的字重和最窄的字宽。

// Now we come to the `gvar` table, which in a TrueType outline font, stores the deltas themselves. We've been playing with KHMER LETTER LO (ល), which goes by the glyph name "uni179B". (I'm sure you can work out why.)
再来看看TrueType#tr[outline]表示法使用可变字体技术时会出现的`gvar`表，它用于存储变化量。就用我们之前举例过的高棉语字母 Lo（#khmer[ល]）为例，它在字体中的#tr[glyph]名是`uni179B0`（我相信你知道为什么叫这个），对应的 `gvar` 表内容如下：

```xml
<gvar>
  <version value="1"/>
  <reserved value="0"/>
  <!-- ... -->
  <glyphVariations glyph="uni179B">
    <tuple>
      <coord axis="wdth" value="-1.0"/>
      <delta pt="0" x="-141" y="-9"/>
      <delta pt="1" x="-141" y="0"/>
      <!-- ... -->
    </tuple>
    <tuple>
      <coord axis="wght" value="-1.0"/>
      <delta pt="0" x="-53" y="7"/>
      <delta pt="1" x="-53" y="0"/>
      <!-- ... -->
    </tuple>
```

// Here are the full deltas for the bottom end of the width axis (completely condensed) and the bottom end of the weight axis (thin). To create a thin version of the letter LO, start with the regular version, and move the first point left 53 units and up 7 units. To create a condensed version, move the first point left 9 units.
这里展示了字宽轴的最小值（最窄时）和字重轴的最小值（最细时）对应的变化量。如果要创建一个细体版本的 Lo 字母，以常规体母版为基础，需要将#tr[outline]中的第一个点向左移动53个单位，向上移动7个单位。如果想要紧缩体版本，则是向左141单位，向下9个单位。

// If you read on to the next few tuples, you will discover that our initial explanation of deltas was a little bit of a simplification, in a number of ways. First, rather than a single delta for weight, you may have find that a font gets thinner or bolder at different rates. So the delta above tells you how to make the font thin, but making the font bold is not just a matter of inverting the delta. One delta is used to travel from the regular into the light direction, but there's a separate delta used for travelling from the default in the boldness direction:
如果再往下看几个具体变化量的数据的话，你就会发现我们之前对它的解释在各个方面都有些简化了。首先，整个字重轴并不是只有一个变化量，这一点你可能能从字体的粗细变化并不是匀速这点上看出来。上面的这一个变化量只用于将字体变细，将字体变粗时并不仅仅是将这个向量反向这么简单，而是由另一个变化量单独负责：

```xml
    <tuple>
      <coord axis="wght" value="1.0"/>
      <delta pt="0" x="74" y="-5"/>
      <delta pt="1" x="74" y="0"/>
      <!-- ... -->
    </tuple>
```

// As well as that, creating a bold condensed font is not simply a matter of blindly multiplying a bold weight delta with a condensed width delta; you may have design-specific adjustments which need to happen when your font is both bold and condensed. This can be represented as another vector: "go this way for both bold and condensed":
另外，创建粗窄体并不只是简单的叠加应用粗体和窄体的变化量就能完成，你还需要专门设计一个在变粗和变窄同时发生时生效的变化量。这个变化量也是一个向量，表示“同时变粗变窄时要向这个方向移动”。

```xml
    <tuple>
      <coord axis="wdth" value="-1.0"/>
      <coord axis="wght" value="1.0"/>
      <delta pt="0" x="-17" y="13"/>
      <delta pt="1" x="-17" y="0"/>
      <!-- ... -->
    </tuple>
  </glyphVariations>
```

// In other words, you have a variety of deltas, and each delta is associated with a position in the design space. When the instances are generated, each set of deltas is given a weight representing how useful it is in getting to the point in design space you're aiming at. So if you want a semibold instance, deltas which make the font lighter are no use at all, so have their weight set to zero. If you want a semibold condensed, deltas which make the font bold, condensed and both bold and condensed at the same time will all be taken into account in varying proportions according to their usefulness. The vectors multiplied by their weights, and applied to the default point, and it all works out in the end.
换言之，你可以有很多个变化量，它们都位于设计空间的某个位置上。当需要生成某个字体实例时，会根据变化量所在位置对于将常规点往实例点移动产生了多少贡献来为它们赋予权重。比如你想生成一个半粗体，那使字体变窄的变化量就没有任何贡献，它的权重就是0。当生成半粗窄体时，粗体、窄体以及粗窄体三个方向的变化量都会用到，并会根据它们的作用按比例分配权重。这些向量乘以权重后再叠加应用到常规母版中的#tr[outline]点上，产生的才是最终的字体实例。

#note[
  // > Another simplification I've made is that your glyphs may change shape completely as they pass particular thresholds: when a dollar sign ($) goes from regular to bold, it sometimes loses the line through the middle of the curve, opting for just protrusions at the top and bottom. Variable fonts lets you flip over to another glyph after a particular threshold on the axis, but I'm not going to go into that.
  此处我还做了一个简化，就是当跨过某些特定的阈值时，#tr[glyph]#tr[outline]可以发生整体性的变化。比如当美元符号（\$）逐渐变粗时，这条穿过S的竖线的中间部分可能会消失，只能看见顶部和底部。可变字体允许在跨越某个变化轴的阈值时对#tr[glyph]进行替换，这里我们就不介绍得这么详细了。

  // > If you actually need to implement variable fonts, print out the [font variations overview](https://www.microsoft.com/typography/otspec/otvaroverview.htm) and sit down with it over a cup of coffee. It's not too hard to understand.
  如果你真的需要实现一个可变字体，请将《OpenType可变字体概述》#[@Microsoft.OpenTypeFont]打印出来，泡杯咖啡，然后坐下慢慢阅读吧。这项技术其实并不难理解。
]

// We've looked at TrueType outlines; what about PostScript outlines? Well, the old CFF font format didn't have support for deltas and variations, so a new format was needed. CFF2 introduces new operators `blend` and `vsindex` to handle deltas. (There are a number of other changes between CFF and CFF2, but we are not going to go into them here.)
我们已经了解完TrueType#tr[outline]下的可变字体了，那使用PostScript#tr[outline]时又如何呢？嗯，老的CFF字体格式并不支持可变轴和变化量，所以我们需要一个新格式。CFF2 引入了两个新的操作 `blend` 和 `vsindex` 来支持可变字体。（CFF2还有很多变化，但此处不过多介绍。）

// The `blend` operator tells the renderer to apply a variation across multiple axes. The following example is taken from the [CFF2 CharString Format specification](https://docs.microsoft.com/en-us/typography/opentype/spec/cff2charstr). Imagine you have an outline which starts at co-ordinate (100,200) in the One True Master, but which starts at the following co-ordinates in the other masters:
`blend` 操作让渲染器在多个轴上进行变化。我们举一个CFF2字符串格式规范#[@Microsoft.CFF2CharString]中的例子，假设在初始母版有一个以 `(100, 200)` 为起点的#tr[outline]，且其他母版下这个起点坐标如下：

/*
|---|
| Master | Co-ordinate | Delta |
|-------|----:|----:|
| Regular | (100,200) | |
| Light | (100,150) | (0,-50) |
| Bold | (100,300) | (0, +100) |
| Condensed | (50,100) | (-50,-100) |
*/
#align(center, table(
  columns: 3,
  align: (x, y) => if x * y == 0 { center } else { left },
  table.header(
    [母版], [坐标], [变化量],
  ),
  [常规], [`(100, 200)`], [],
  [细], [`(100, 150)`], [`(  0, -50)`],
  [粗], [`(100, 300)`], [`(  0, +100)`],
  [窄], [`( 50, 100)`], [`(-50, -100)`],
))

// Let's also imagine we want to find the bold condensed instance of this font.
接下来我们来看看如何生成粗窄体的实例。

// In a non-variable font, we would start the CFF program with:
在不可变的字体中，这个起点的CFF程序将会是：

```
100 200 rmoveto
```

// But we want instead want to *compute* the appropriate co-ordinate to move to, based on the deltas. So the program is written using the `blend` operator like so:
但现在我们需要根据变化量来计算这个起点的位置，这里就要用到 `blend` 操作了。它的语法如下：

```
(初始母版值) (X 方向变化量) (Y 方向变化量) (操作数数量) blend (原命令)
```

// In this case:
在我们这个具体例子中就是：

```
(100 200) (0 0 -50) (-50 100 -100) 2 blend rmoveto
```

// (I've added parentheses so you can see how the arguments are grouped, but in the font program it would just appear as `100 200 0 0 -50 ...`)
（为了便于理解这些参数是如何分组的，这里我额外加上了括号，但在实际的字体程序中只会这么写： `100 200 0 0 -50 ...`）

// When this font program is executed by the PostScript implementation, the `blend` command runs first, before the `rmoveto` command. `blend` applies the bold (second) and condensed (third) deltas to the One True Master outline, does the computation leaving behind two operands to the next command, and then disappears off the stack. What we then have left to execute is:
当字体程序被PostScript解释器运行时，会先执行`blend`命令再执行`rmoveto`命令。`blend`会将粗体（变化量中的第二个数）和窄体（第三个数）的变化量应用到初始模板的#tr[outline]点坐标上，并给出两个数值作为结果，之后自身从执行栈中消失。那么剩下要执行的就变成了：

```
(100+0-50) (200+100-100) rmoveto
```

// i.e.
也即

```
50 200 rmoveto
```

// which puts us in the right place for the bold condensed instance.
这样就将起点移动到了粗窄体的对应位置。
