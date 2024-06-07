#import "/template/template.typ": web-page-template
#import "/template/components.typ": note

#import "/lib/glossary.typ": tr

#show: web-page-template

// ## From TrueType to OpenType
== 从TrueType到OpenType

// But it was to no avail. There were many reasons why TrueType ended up winning the font wars. Some of these were economic in nature: the growing personal computer market meant that Microsoft and Apple had tremendous influence and power while Adobe remained targeting the high-end market. But some were technical: while PostScript fonts never really advanced beyond their initial capabilities, TrueType was constantly being developed and extended.
但这都无济于事。TrueType最终赢得字体大战的原因有很多。一些是经济上的：不断增长的个人计算机市场意味着微软和苹果有着巨大的影响和力量，而Adobe却仍将目标对准高端市场。另一些则是技术上的：PostScript 字体从未真正超出其初始功能，但TrueType则一直在不断开发和扩展。

// Apple extended TrueType, first as "TrueType GX" (to support their "QuickDraw GX" typography software released in 1995) and then as Apple Advanced Typography (AAT) in 1999. TrueType GX and AAT brought a number of enhancements to TrueType: ligatures which could be turned on and off by the user, complex contextual substitutions, alternate glyphs, and font variations (which we will look at in the next section). AAT never hit the big time; it lives on as a kind of typographic parallel universe in a number of OS X fonts (the open source font shaping engine Harfbuzz recently gained support for AAT). Its font variation support was later to be adopted as part of OpenType variable fonts, but the rest of its extensions were to be eclipsed by another development on top of TrueType: OpenType.
苹果扩展了TrueType。首先是TrueType GX（以支持其1995年发布的QuickDraw GX印刷软件），然后是1999年的Apple Advanced Typography（AAT）。TrueType GX和AAT大幅扩充了TrueType的功能：允许用户决定是否启用的#tr[ligature]、复杂的#tr[contextual]#tr[substitution]、#tr[alternate glyph]和字体变体（我们将在下一节中介绍）。但AAT也没有大获成功，它仅以几个OS X字体的形式存在于#tr[typography]的平行宇宙中（开源的字体#tr[shaping]引擎HarfBuzz最近支持了AAT）。它其中大部分扩展被基于TrueType开发的OpenType所彻底掩盖，字体变体则被吸收为OpenType#tr[variable font]功能的一部分。

// In 1997, Microsoft and Adobe made peace. They worked to develop their own set of enhancements to TrueType, which they called TrueType Open (Microsoft's software strategy throughout the 1990s was to develop software which implemented a public standard and extend it with their own feature enhancements, marginalizing users of the original standard. TrueType Open was arguably another instance of this...); the renderer for TrueType Open, Uniscribe, was added to the Windows operating system in 1999.
1997年，微软和Adobe达成了和解。他们致力于开发自己的TrueType扩展集，称为TrueType Open（Microsoft在1990年代的软件战略是开发符合公共标准的软件，并加入自己的增强功能以对其进行扩展，从而使原始标准的用户处于边缘地位。TrueType Open可以说是这种策略的一个例子）。TrueType Open的渲染器Uniscribe于1999年集成进Windows操作系统。

// Later called OpenType, the development of this new technology was led by David Lemon of Adobe and Bill Hill of Microsoft,[^12] and had the design goal of *interoperability* between TrueType fonts and Adobe Type 1 PostScript fonts. In other words, as well as being an updated version of TrueType to allow extended typographic refinements, OpenType was essentially a *merger* of two very different font technologies: TrueType and PostScript Type 1. As well as being backwardly compatible with TrueType, it allowed PostScript Type 1 fonts to be wrapped up in a TrueType-like wrapper - one font format, containing two distinct systems.
这项新技术后来被称为OpenType，由Adobe的David Lemon和微软的Bill Hill领导开发#footnote[
  // When Microsoft were working on TrueType Open before the tie-up with Adobe, the technical development was led by Eliyezer Kohen and Dean Ballard.
  在微软和Adobe的合作开始前，TrueType Open由Eliyezer Kohen和Dean Ballard领导开发。
]，其设计目标是在TrueType字体和Adobe PostScript Type 1 字体之间实现*互通*。换句话说，OpenType不仅是添加了高级#tr[typography]功能的TrueType改进版，而且本质上是TrueType 和 PostScript Type 1这两种非常不同的字体技术的*并集*。除了向后兼容TrueType之外，它还允许将PostScript Type 1字体封装在类似TrueType的容器中——一种字体格式，包含两个不同的系统。

// OpenType is now the *de facto* standard and best in class digital font format, and particularly in terms of its support for the kind of things we will need to do to implement global scripts and non-Roman typography, and so that's what we'll major on in the rest of this book.
OpenType现在是数字字体的事实标准，也是最优秀的一种格式，尤其是考虑到对#tr[global scripts]和非拉丁#tr[typography]的支持。这也是在本书剩余部分中我们要重点讨论的内容。
